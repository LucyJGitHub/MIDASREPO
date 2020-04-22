     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer loans screen 1 validations')         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LECLIP1VL -  Customer Loans screen 1 validations             *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD055380           Date 17Apr20               *
      *  Prev Amend No. MD052327           Date 17Nov18               *
      *                 MD052214           Date 26Oct18               *
      *                 MD052213           Date 26Oct18               *
      *                 CLE071             Date 18Jul18               *
      *                 MD027418           Date 18Jul18               *
      *                 MD026971           Date 18Jul18               *
      *                 MD025837A          Date 18Jul18               *
      *                 CLE158             Date 18Jul18               *
      *                 MD046370           Date 07Nov17               *
      *                 MD046248           Date 27Oct17               *
      *                 MD041443           Date 19Sep16               *
      *                 CLE154             Date 06Aug12               *
      *                 CLE141             Date 08Feb16               *
      *                 MD031089           Date 12Feb15               *
      *                 MD032052           Date 23Jan15               *
      *                 MD031225           Date 10Dec14               *
      *                 MD025521           Date 19Aug14               *
      *                 MD025864           Date 12May14               *
      *                 MD021823A          Date 07May14               *
      *                 MD023789           Date 06May14               *
      *                 MD022946           Date 18Oct13               *
      *                 MD022807C          Date 15Oct13               *
      *                 MD022807           Date 11Oct13               *
      *                 AR820729           Date 09Sep13               *
      *                 MD021016           Date 27Jun13               *
      *                 AR882700           Date 19Jun13               *
      *                 MD020859           Date 12Jun13               *
      *                 MD020722           Date 31May13               *
      *                 MD020605           Date 28May13               *
      *                 MD000091           Date 23May13               *
      *                 AR1053735          Date 14Nov12               *
      *                 MD020274           Date 06May13               *
      *                 AR1021136          Date 24Apr13               *
      *                 MD019830A          Date 15Apr13               *
      *                 MD019830           Date 10Apr13               *
      *                 AR1096933          Date 02Apr13               *
      *                 AR1094066          Date 06Mar13               *
      *                 AR1094759          Date 11Mar13               *
      *                 AR740107A          Date 21Dec12               *
      *                 AR740107           Date 21Dec12               *
      *                 AR804863           Date 10Dec12               *
      *                 AR217961           Date 10Dec12               *
      *                 AR1081637          Date 29Jan13               *
      *                 AR826996           Date 09Nov12               *
      *                 AR722666           Date 18Oct12               *
      *                 AR740717           Date 18Oct12               *
      *                 AR682750           Date 18Oct12               *
      *                 AR632104           Date 02Oct12               *
      *                 AR763386           Date 14Oct12               *
      *                 261084             Date 17Aug12               *
      *                 AR468303           Date 01Aug12               *
      *                 263288             Date 01Aug12               *
      *                 262461A            Date 01Aug12               *
      *                 262328             Date 01Aug12               *
      *                 262461             Date 01Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 AR970786           Date 23Jul12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSC054             Date 23Feb12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 AR787620           Date 10Jun11               *
      *                 CLE064             Date 06Dec10               *
      *                 262581             Date 24Feb09               *
      *                 262328             Date 30Oct09               *
      *                 AR702741           Date 02Feb11               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG21898           Date 03Mar09               *
      *                 BUG22318           Date 28Jan09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 256611             Date 24Sep08               *
      *                 256579             Date 17Sep08               *
      *                 BUG18363           Date 24Apr08               *
      *                 247441             Date 20Jul07               *
      *                 248222             Date 19Jun07               *
      *                 247676             Date 01Jun07               *
      *                 247585             Date 07May07               *
      *                 245273             Date 26Jan07               *
      *                 245411             Date 26Jan07               *
      *                 245217             Date 29Mar07               *
      *                 CAS019             Date 24Mar07               *
      *                 BUG13843           Date 02May07               *
      *                 CPK027             Date 16Apr07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 245227             Date 27Feb07               *
      *                 244213             Date 18Jan07               *
      *                 244891             Date 08Jan07               *
      *                 243931             Date 12Dec06               *
      *                 244151             Date 05Dec06               *
      *                 243770             Date 16Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK026             Date 02Jan07               *
      *                 240510             Date 19Oct06               *
      *                 242481             Date 20Sep06               *
      *                 241204             Date 07Aug06               *
      *                 CPK025             Date 29Aug06               *
      *                 241198             Date 06Jun06               *
      *                 240342             Date 30Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 238864             Date 28Apr06               *
      *                 238646             Date 29Mar06               *
      *                 237744             Date 26Jan06               *
      *                 237217             Date 18Jan06               *
      *                 CGL058             Date 30Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10391R          Date 17Feb06               *
      *                 BUG10825           Date 10Mar06               *
      *                 BUG10671R          Date 09Mar06               *
      *                 BUG10671R          Date 07Mar06               *
      *                 BUG10733           Date 28Feb06               *
      *                 BUG10657 (Reopen)  Date 28Feb06               *
      *                 BUG10657           Date 23Feb06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9691            Date 22Dec05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE036             Date 22Sep03               *
      *                 CLE034             Date 05May03               *
      *                 CLE031             Date 03Feb03               *
      *                 BUG8436            Date 09Sep05               *
      *                 BUG8017            Date 28Jul05               *
      *                 CAP086             Date 08Jun05               *
      *                 BUG7029            Date 09Jun05               *
      *                 BUG6108            Date 16Apr05               *
      *                 BUG7009            Date 10May05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG5863            Date 14Feb04               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG5148            Date 17Dec04               *
      *                 BUG4663            Date 08Nov04               *
      *                 BUG4663            Date 08Nov04               *
      *                 BUG4351 (reopen)   Date 12Oct04               *
      *                 BUG4351            Date 23Sep04               *
      *                 BUG3721 (CLE028)   Date 09Aug04               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG2319            Date 11May04               *
      *                 TDA023             Date 24Mar04               *
      *                 225363             Date 01Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CSF002             Date 11Aug03               *
      *                 213809             Date 16Jan03               *
      *                 CLE030             Date 29Aug02               *
      *                 CLE023             Date 08Aug02               *
      *                 CAP074  *CREATE    Date 26Apr02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055380 - Rollover can't be completed when main loan in WIP.*
      *             Reverse fix AR820729.                             *
      *  MD052327 - A serious MIDAS error occurred while Inserting    *
      *             a New Participation Sold                          *
      *  MD052214 - Warning message with outside block not appearing. *
      *             Use WId instead of WIdx such that other warning   *
      *             message will not be overridden                    *
      *  MD052213 - If CLE158 ON CLE025 OFF, issue overridable error  *
      *             when facility amount exceeded for backvalued loan *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD027418 - Display Warning/Error on auth of insert (CLE158)  *
      *  MD026971 - Issue either overridable error or warning         *
      *  MD025837A - Apply MD025837 extra check to CLE158 processing  *
      *  CLE158 - Tranche and Facility Control                        *
      *  MD046370 - Component LERC135 is looping in COB. If system    *
      *             value 'AutoEndCalcLoanFee' is 'N', allow change   *
      *             of loan maturity date to be earlier than fee start*
      *             date & if system value is 'Y', this is prohibited.*
      *             Applicable for all calculated loan fees.          *
      *  MD046248 - Finastra Rebranding                               *
      *  MD041443 - CBC022001 failed due to invalid character in file *
      *             text description (Recompile)                      *
      *  CLE154 - Loan Repayment Schedule Enhancement (Recompile)     *
      *  CLE141 - Currency and Location Business Day Convention for   *
      *           Lending Transactions                                *
      *  MD031089 - Add validation on maturity date against fee start *
      *             fee start date for calc loan fees 90/97/98/99.    *
      *  MD032052 - Unable to authorize loan repaired from repair     *
      *             queue. Enhance MD031225 to bypass validation of   *
      *             loan number if record come from COB.              *
      *  MD031225 - Bypass validation of loan number on COB since it  *
      *             was auto generated.                               *
      *  MD025521 - Recompile due to changes on LECLI2PD.             *
      *  MD025864 - Enhance the fix AR740717 to avoid looping.        *
      *  MD021823A - SECI was defaulted from facility instead of the  *
      *              Original Loan                                    *
      *  MD023789 - Error processing CLIP message                     *
      *  MD022946 - Missing error message in BF2.1. Need to           *
      *             re-introduce as event code.                       *
      *  MD022807C - Additional validation delivered by MD022807      *
      *              no longer required.                              *
      *            - Repayment details cannot be amended for PDCLs    *
      *  MD022807 - Additional validation for PDCL Maturity Date      *
      *             amendment                                         *
      *  AR820729 - Loan remains unauthorised after Rejection. Add    *
      *             error message to prevent amendment when rollover  *
      *             details had been changed. (Child: AR820730)       *
      *           - Applied for MD022300                              *
/*    *  MD021016  - Transaction went into repair queue_Deal date     *
/*    *              must not be after Last availability date of      *
/*    *              the facility                                     *
      *  AR882700 - LEC06A on MESSAGEWAIT on A1 TEST SYSTEM. Insert   *
      *             additional validation in Facility Currency        *
      *             Exchange Rate. (Child: AR882701)                  *
      *  MD020859 - CLE134 No validation PDCL CCY during IC creation  *
      *  MD020722  - LE: CLE134: No validation on type/s-type during  *
      *              PDCL creation.                                   *
      *  MD020605 - CLE134 Impossible to create PDCL in IC            *
      *  MD000091 - Event Codes Substitution                          *
      *  AR1053735 - Amendment of loan with reversed fees not allowed *
      *              Error message LEL0202 is displayed. Check the    *
      *              status of loan fee before the validation of      *
      *              maturity date. (Child: AR1053736)                *
      *  MD020274 - Amend PDCL various error messages encountered     *
      *  AR1021136 - CLE148: Loan with re* rence '000000' can be      *
      *              created. Issue an error message when AlphaLoan   *
      *              is allow and input loan ref# is '000000' or      *
      *              '999999'. (Child: AR1021140)                     *
      *  MD019830A - Unable to amend authorised Loan (Reopened)       *
      *  MD019830 - Unable to amend authorised Loan                   *
      *  AR1096933 - Warning message of event code not found during   *
      *              complete and authorisation.                      *
      *  AR1094066 - LEC000138 & LEC000456 - Expired CLIP             *
      *  AR1094759 - Error 45099999, Event code not found             *
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
      *  AR217961 - Wrong settlement method after amendment rejection.*
      *             Initialised the WSVCN field so that the proper    *
      *             value will be passed to LECLIPVU.                 *
      *           - Applied for AR910559 (Child: AR910560)            *
      *  AR1081637 - Error in amending due date of CLIP (with attached*
      *              fee, end date beyond rundate) equal to rundate.  *
      *              Deleted a line introduced by CLE134 that is in   *
      *              conflict with 261084.                            *
      *  AR826996 - Validate Base Rate Code + Currency in SDBSRTPD    *
      *             for PDCL generation. (Child: AR826997)            *
      *  AR722666 - Loan matured but still shows old maturity date.   *
      *             Amendment of maturity date should also consider   *
      *             the defined maturity on LS amendment from LOAMS   *
      *             (Child: AR722667)                                 *
      *  AR740717 - Maturity date cannot be earlier than existing loan*
      *             amendment(except REpayment Schedule) and historic *
      *             event (Child: AR740718)                           *
      *  AR682750 - Issue error message LEL0133 when loan has loan    *
      *             amendment with value date greater than new        *
      *             maturity date. Same applies for loan events in    *
      *             history file                                      *
      *  AR632104 - Autosettlement 'C' when subtype change is present.*
      *             Do not allow change of autosettlement to 'C' when *
      *             subtype change is present with undefined PDCL     *
      *             details. (Child: AR632105)                        *
      *  AR763386 - Error on amendment of PDCL with expired facility. *
      *             Added condition to allow amendment of PDCL even   *
      *             if facility is expired. (Child: AR763387)         *
      *  261084 - LE: Automatic closure of periodic fees (type 99)    *
      *           with loans. System sends error msg LEL0202 when a   *
      *           loan is early matured. Added condition to validate  *
      *           calculated loan-based fees.                         *
      *  AR468303 - CAN:?? ??????????????? Loan Amend                 *
      *             (Child: AR468304)                                 *
      *  263288 - Don't allow insert of type 'Xx', 'Yx' or 'Zx' Loans *
      *  262461A - Error LER5573 should not be output if              *
      *           Loan type starts by X, Y or Z. (Reopen)             *
      *  262328 - Serious Midas error occurred. Increase size of WBIC *
      *           array from 150 to 900.                              *
      *  262461 - Prevent amendment of Auto-settle = 'C' if           *
      *           loan type/subtype does not have a PDCL loan type    *
      *           subtype.                                            *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  AR970786 - Error while closing the loan (Child: AR970787)    *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSC054 - Period End Adjustments                              *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate                                                *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,LEH00247                                 *
      *             WNCPYSRC,LEH00248                                 *
      *             WNCPYSRC,LEH00249                                 *
      *             WNCPYSRC,LEH00250                                 *
      *  CLE064 - Enhancement of Lending Frequencies                  *
      *  262581 - If maturity date changes then amend amortisation    *
      *           period on related fees.                             *
      *  262328 - Serious Midas error occurred. Increase size of WBIC *
      *           array from 150 to 900.                              *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting ¥24c             *
      *           (Recompile)                                         *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus                                          *
      *  BUG21898 - Missing rollover frequency.                       *
      *  BUG22318 - Risk Participation loans with recourse are not    *
      *             allowed.                                          *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  256611 - Participation purchased input error:                *
      *           Non multi-customer facilities should be validated   *
      *           against purchased from customer instead of original *
      *           borrower. Pattern fix from core 203794(LE2030).     *
      *  256579 - Introduced a new system value RateFixingDaysDfault  *
      *  BUG18363 - When amending maturity date field in Loan         *
      *             Transaction it takes awhile to load               *
      *  247441 - Additional parameter for LECLIP1VL                  *
      *  248222 - If record is created by a Principal Transfer, set   *
      *           PRTRF to 'Y'.                                       *
      *  247676 - Consider FI/FD when loan is amended.                *
      *  247585 - Loans with Int Freq of 'R' cannot be deleted.       *
      *  245273 - Recompiled due to changes in LECLI1PD.              *
      *  245411 - Update GPRT and TOLN if record is created by a      *
      *           Principal Transfer Transaction.                     *
      *  245217 - Loan processing type error message is incorrect.    *
      *  CAS019 - Upgrade of CAS016 to Midas Plus                     *
      *  BUG13843 - Wrong OLNO reflected                              *
      *  CPK027 - Errors in compiling MP1_3_TTTS - 243770 incompatible*
      *           with CSD027.                                        *
      *  245227 - Update OAM and CAMD during I/C when Auto-settle     *
      *           indicator is changed. Apply 204347 / 207595         *
      *  244213 - Irrelevant error messages LEL0670 (Deal Date must   *
      *           not be after Last Availability Date of Facility)    *
      *           and LEL0236 (Start Date is later than Last          *
      *           Availabilty Date on the Facility) for Principal     *
      *           Transfers. Upgrade GEMS227374 to Midas Plus.        *
      *           This also applies to LEL0029 (Deal Date is a        *
      *           holiday in local currency).                         *
      *  244891 - Prevent early maturity when there is a pending      *
      *           principal transfer valuing later than new maturity. *
      *  243931 - Validate deal date against last availability date   *
      *           only if loan type is not a part sold.               *
      *  244151 - Incorrect warning message is issued during confir-  *
      *           mation of authorisation of loans.  Applied core fix *
      *           240342.                                             *
      *  240342 - Principal amount should only be added to OAM during *
      *           insert. Applied fix 232104.                         *
      *  243770 - LEL0132 prevented maturity of participated loan.    *
      *           The system should amend the participants' maturity  *
      *           dates.                                              *
      *  CPK026 - Change numeric customer number.                     *
      *  240510 - Default Secured indicator from Facility             *
      *  242481 - Current Exposure was updated with the wrong amount  *
      *           if loan was in Base Currency (wrong multiply/divide *
      *           indicator was used). Amendment to CLE023.           *
      *  241204 - Internal Participation Purchased loans should be    *
      *           correctly process with regards to validation for    *
      *           multi-ccy allowed indicator, MCRA. MCRA of internal *
      *           parts purchased loans and participation sold loans  *
      *           must be equal to MCRA of original or mirror loan.   *
      *           Patterned after fix 202101.                         *
      *  CPK025 - MidasPlus 1.3 packaging.  Mismatch of IF and END.   *
      *  241198 - Loan input not allowed against a reactivated        *
      *           facility.  Do not use old 'Last Availability Date'  *
      *           if facility has been reactivated.                   *
      *  240342 - Principal amount should only be added to OAM during *
      *           insert. Applied fix 232104.                         *
      *  CSD031 - Error in compilation when CHAIN(N) is used if file  *
      *           is not used for update. Change F-Specs for FCLTY,   *
      *           CLOAN and LOAMS.                                    *
      *  238864 - Applied fix 210977.                                 *
      *  210977 - Rollover Date should not be allowed to be equal to  *
      *           Value Date.                                         *
      *  238646  - LEL0523 should be sent only in case of proc type   *
      *            65,67,63                                           *
      *  237744 - Consider new maturity date existing on rollover     *
      *           details (of the related loan) when validating       *
      *           maturity date of part sold loan. In addition,       *
      *           corrected message ID for auto pay at maturity.      *
      *  237217 - Remove validation of roll over date against         *
      *           available date when CLE030 is not installed.        *
      *  CGL058 - Default Branch Code                                 *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10391R - Funding Rate and Funding Spread Rate fields      *
      *              should be shown separately when CLE036 is *ON    *
      *              (Recompile)                                      *
      *  BUG10825  - Error encountered on generated IPP when creating *
      *              a loan whose branch is different from the        *
      *              facility branch.                                 *
      *  BUG10671R - Incorrect auto generated loans created.          *
      *  BUG10671R - Auto generated error on completion of agented    *
      *              loan.                                            *
      *  BUG10733 - Ensure that CCLLSTS will be equal to 'Q' only if  *
      *             CLE030 is on.                                     *
      *  BUG10657 - Error shown on credit agreement should be         *
      *             changed to warning only.                          *
      *  BUG10657 - Changed validation of rollover date. Only a       *
      *             warning message be shown when the entered roll-   *
      *             over date is later than the last availability     *
      *             date of the facility.                             *
      *  CLE042 - Extended Loan Sub Type                              *
      *  BUG9691- Include CAS011 changes in GZCLOANCL to align valids *
      *           file format.(Recompile)                             *
      *  CLE106 - Syndications Manager. Amended validation of linked  *
      *           to syndicate field.                                 *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2  *
      *           Allow specific base rates  (Recompile)              *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompile)                                         *
      *  CLE031 - Lending Enhancements (Recompile)                    *
/*    *  BUG8436- Additional OME changes to cater Bug6108 validation  *
      *  BUG8017- Do not alter the loan range number key before       *
      *           calling AOLENOR0                                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  BUG6108- Allow manual entry of loan numbers                  *
      *  BUG7009-  WCPMFC is incorrectly setup                        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG5863 - Index of Warning errors array (WId) should be      *
      *            reset to zero to prevent array index out of range. *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG5148- Allow linked to syndicate to be 'N'                 *
      *  BUG4663- Midas Serious Error upon insert on CLIP             *
      *  BUG4663- DB Error due to invalid date in RUN0 to RUN9 fields *
      *  BUG4351 - Index of Warning errors array WFldNmXAr should be  *
      *            different to the index for WFldNamArr.             *
      *  BUG4351 - Remove the use of work fields to suppress warning  *
      *            errors being re-displayed when data unchanged.     *
      *  BUG3721 - Flat Rate Personal Loans (Rule of 78s) (CLE028).   *
      *            Early Mature not allowed for Flat Rate Loans,      *
      *            Patterned fix from 218531.                         *
      *  CLE025 - Credit Lines                                        *
      *  BUG2319- Facility Customer defaulted is not INZ Branch       *
      *  TDA023 - Increase Maturity Date Account to 18 Digits         *
      *           (Recompile)                                         *
      *  225363 - Wrong branch written to the Facility Branch field   *
      *           FCLB on CLOANCL. Logged on Bugzilla as Bug 1254.    *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSF002 - Global layer.                                       *
      *         - Replace previous ZBACT* parameters with the new     *
      *           unique code.                                        *
      *  213809 - Auto settle field defaults to 'N'                   *
      *  CLE030 - Release Authorisation processing                    *
      *  CLE023 - Lending Facility History Improvements.              *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** | F-specs                              |
      ** | =======                              |
      ** +--------------------------------------+
      *****************************************************************
      *
      ***  FILES
      *    =====
     F*FCLTY*** IF   E           K DISK    INFSR(*PSSR)                                       CSD031
     FFCLTY     UF   E           K DISK    INFSR(*PSSR)                                       CSD031
     F                                     IGNORE(FCLTYHHF)
     F                                     IGNORE(FCLTYZZF)
      *
     FLEFCAML3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFCAMPF:LEFCAMD3)
      *
     F*CLOAN*** IF   E           K DISK    INFSR(*PSSR)                                       CSD031
     FCLOAN     UF   E           K DISK    INFSR(*PSSR)                                       CSD031
     F                                     IGNORE(CLOANHHF:CLOANZ1F)
      *
     FLELOAML3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LOAMSDKF:LELOAM3F)
      *
     FSDBSRTL0  IF   E           K DISK    INFSR(*PSSR)                                     AR826996
     F                                                                                      AR826996
     FLEFCLTLD  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:LEFCLTDD)
     FLEFCLTLC  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFNF:LEFCLTDC)
      *
     FCLOANCL   IF   E             DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:CLOANLJ)
      *
     F*LOAMS*** IF   E           K DISK    INFSR(*PSSR)                                       CSD031
     FLOAMS     IF   E           K DISK    INFSR(*PSSR)                                       CSD031
     F                                     IGNORE(LOAMSDHF)
     F                                     IGNORE(LOAMSZ1F)
      *
     FLEFCAML7  IF   E           K DISK    INFSR(*PSSR)
      *
     FLEFCLTL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FCLTYFMF:LEFCLTD2)
      *
     FSDBRCHL5  IF   E           K DISK    INFSR(*PSSR)
      *
     FLEFEEDL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFEEDF:LEFEED2F)
      *
     FPSOLDLL   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:PSOLDF)
      *
     FLEFCLTL4  IF   E           K DISK
     F                                     RENAME(FCLTYFMF:LEFCLTD0)
      *
     FLEPARTL1  IF   E           K DISK
     F                                     RENAME(LEPARTD0:LEPARTD1)
      *
     FLEPARTL2  IF   E           K DISK
                                                                                             BUG6108
     FMLOAN     IF   E           K DISK                                                      BUG6108
     F                                     Ignore(CLOANHHF)                                  BUG6108
     F                                     Ignore(CLOANZ1F)                                  BUG6108
     F                                     Ignore(CLOANCKF)                                  BUG6108
     F                                     Rename(CLOANCLF:MLOANCLF)                         BUG6108
      *                                                                                      BUG6108
     FHISTSL0   IF   E           K DISK    INFSR(*PSSR)                                       248222
     F                                     IGNORE(HISTSHMF:HISTSHQF)                          248222
     F                                     PREFIX(J)                                          248222
      *                                                                                       248222
      ** Midas LE Fee Details                                                                 CAS019
     FLEFEEDLH  IF   E           K DISK    INFSR(*PSSR)                                       CAS019
      *                                                                                       CAS019
      ** LEPRATPD Details                                                                   MD019830
     FLEPRATL1  IF   E           K DISK    INFSR(*PSSR)                                     MD019830
      **********                                                                  MD022807 MD022807C
      ***Original*Loan*Details*****************************************           MD022807 MD022807C
     F***CLOANC*   UF   E           K DISK    INFSR(*PSSR)                        MD022807 MD022807C
     F**********                           IGNORE(CLOANHHF:CLOANZ1F)              MD022807 MD022807C
     F**********                           IGNORE(CLOANCKF)                       MD022807 MD022807C
     F**********                           RENAME(CLOANCLF:CLOANORG)              MD022807 MD022807C
     F**********                           PREFIX(OL)                             MD022807 MD022807C
      ***********                                                                 MD022807 MD022807C
      ***Original*Fee*Details******************************************           MD022807 MD022807C
     F***LEFEED*   IF   E           K DISK    INFSR(*PSSR)                        MD022807 MD022807C
     F**********                           RENAME(LEFEEDF:LEFEEDOR)               MD022807 MD022807C
     F**********                           PREFIX(OF)                             MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
      ***Original*transaction*loams*event******************************           MD022807 MD022807C
     F***LOAMSOM3  IF   E           K DISK    INFSR(*PSSR)                        MD022807 MD022807C
     F**********                           RENAME(LOAMSDKF:LOAMSORG)              MD022807 MD022807C
     F**********                           PREFIX(O2)                             MD022807 MD022807C
      *                                                                                      BUG6108
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,LECLIP1V01
      *
      *****************************************************************
      ** +--------------------------------------+
      ** | Automatically included D-specs       |
      ** | ==============================       |
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
      ** | End of automatically included D-specs|
      ** | =====================================|
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** | Manually included D-specs            |
      ** | =========================            |
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** | Named constants                      |
      ** | ===============                      |
      ** +--------------------------------------+
      *
     D XArrayMax       C                   CONST(40)
      ***  The maximum size of the appended error arrays
      *                                                                                      BUG6108
      * Constant to hold input parameter for AOSVALR0.                                       BUG6108
     D AutoAlloc       C                   Const('LoanNbrAutoAllocate')                      BUG6108
     D*OMEInd***       C                   CONST('OMEIndicator')                      BUG8436 CSC054
     D PEAInd          C                   CONST('PEAIndicator')                              CSC054
     D RateFixDays     C                   Const('RateFixingDaysDfault')                      256579
     D FctyNoDaysFwd   C                   Const('FctyExceedNoDaysFwd')                       CLE158
      *
      ** +--------------------------------------+
      ** | Arrays and Data Structures           |
      ** | ==========================           |
      ** +--------------------------------------+
      *
     D WFREQ           S              1    DIM(20) CTDATA PERRCD(20)                          CLE064
      ***  Frequency codes for rollovers                                                      CLE064
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)
      *
     D***WDRPT**         S              3    DIM(12) CTDATA PERRCD(1)                        BUG3721
     D WDRPT           S              3    DIM(13) CTDATA PERRCD(1)                          BUG3721
      ***  Frequency codes for interest and repayments
      *
     D*WBIC*****       S              6  0 DIM(150)                                           CSD027
     D*WBIC*****       S              6    DIM(150)                                    CSD027 262328
     D WBIC            S              6    DIM(900)                                           262328
      ***  Branch internal customer array
      *
     D WCY             S              3    DIM(9)
      ***  Work Allowable currencies array
      *
     D***DRAW***         S              1    DIM(5)                                          BUG3721
     D DRAW            S              1    DIM(6)                                            BUG3721
      *
     D                 DS
      ***  Data structure of rundates
      *
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
     D  RUNS                   1     30P 0
     D                                     DIM(10) ASCEND
      *
     D                 DS                                                                     CSD027
      ** General data structure to handle OLNO field now that is alpha.                       CSD027
     D OLNOAlpha               1      6                                                       CSD027
     D*OLNONum**               1      6  0                                             CSD027 CLE148
     D OLNONum                 1      6                                                       CLE148
      *                                                                                       CSD027
     D                 DS
      ***  Data structure of drawn amounts
      *
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
     D  OAM                    1     70P 0
     D                                     DIM(10)
     D                 DS
      ***  Data structure of rundates
      *
     D  RUN0D                  1      3P 0
     D  RUN1D                  4      6P 0
     D  RUN2D                  7      9P 0
     D  RUN3D                 10     12P 0
     D  RUN4D                 13     15P 0
     D  RUN5D                 16     18P 0
     D  RUN6D                 19     21P 0
     D  RUN7D                 22     24P 0
     D  RUN8D                 25     27P 0
     D  RUN9D                 28     30P 0
     D  RUNSD                  1     30P 0
     D                                     DIM(10) ASCEND
      *
     D                 DS
      ***  Data structure of drawn amounts
      *
     D  OAM1D                  1      7P 0
     D  OAM2D                  8     14P 0
     D  OAM3D                 15     21P 0
     D  OAM4D                 22     28P 0
     D  OAM5D                 29     35P 0
     D  OAM6D                 36     42P 0
     D  OAM7D                 43     49P 0
     D  OAM8D                 50     56P 0
     D  OAM9D                 57     63P 0
     D  OA10D                 64     70P 0
     D  OAMD                   1     70P 0
     D                                     DIM(10)
      *
     D ExtData       E DS                  EXTNAME(LECLEXPD)
      ***  LE (CLIP) Extra Data - File (D/B) format
      *
     D SDLENO        E DS                  EXTNAME(SDLENOPD)                                 BUG6108
      ** Loan number ranges file                                                             BUG6108
      *                                                                                      BUG6108
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
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ***  External DS for customer details
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D QQDFAC1       E                     EXTFLD(QQDFAC)                                     CGL029
      ***  External DS for branch details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  External DS for module details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ***  External DS for general ledger details
      *
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
      ***  External DS for loans details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External DS for currency details
      *
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)                    213809
      ***  Customer lending ICD                                                 213809
      *                                                                         213809
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CER020
     D  SLCD         E                     EXTFLD(LCD)                                        CER020
      ** Access object for SAR details                                                        CER020
      *                                                                                       CER020
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)                                  CLE134
      ** External DS for base rate details                                                    CLE134
      *                                                                                       CLE134
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  First DS for access programs, long data structure
      *
     D ValidLnCl     E DS                  EXTNAME(LEVCLILPD)
      ***  Valid Loans CL layout -> CLOANCL
     D                                     PREFIX(C)
     D  ValidCurPR          1906   1935                                                       CLE141
     D  ValidLocPR          1936   1965                                                       CLE141
     D  ValidCurPI          1966   1995                                                       CLE141
     D  ValidLocPI          1996   2025                                                       CLE141
      *
     D ValidLnCk     E DS                  EXTNAME(LEVCLIKPD)
      ***  Valid Loans CK layout -> CLOANCK
      *
     D TranInScr1    E DS                  EXTNAME(LECLI1PD)
      ***  Incoming Transaction
                                                                                             BUG3721
     D TranInScr2    E DS                  EXTNAME(LECLI2PD)                                 BUG3721
      ** Incoming Transaction - 2nd screen                                                   BUG3721
      *
     D TranInScr3    E DS                  EXTNAME(LECLI3PD)                                  CLE106
      ***  Incoming Transaction - 3rd screen                                                  CLE106
      *                                                                                       CLE134
     D TranInScr6    E DS                  EXTNAME(LECLI6PD)                                  CLE134
      ***  Incoming Transaction - 4th screen                                                  CLE134
                                                                                              CLE141
     D TranInScr7    E DS                  EXTNAME(LECLI7PD)                                  CLE141
     D  CurLocPR               1     60                                                       CLE141
     D  TrCurPR                1     30                                                       CLE141
     D  TrLocPR               31     60                                                       CLE141
     D  TrCurPI               61     90                                                       CLE141
     D  TrLocPI               91    120                                                       CLE141
      ** Incoming Transaction - Business Day Conv Screen                                      CLE141
                                                                                              CLE106
     D CLOANCLfmt    E DS                  EXTNAME(CLOAN:CLOANCLF)                            CLE106
                                                                                              CLE106
     D ClilFilFmt    E DS                  EXTNAME(CLOANCL) PREFIX(@@)
      * (Current) Loans record CL in file Format

      *
     D OKFlagsDS     E DS                  EXTNAME(LEECLI1PD)
     D OKFlagsDS2    E DS                  EXTNAME(LEECLI7PD)                                 CLE141
     D  OKFlgCurPR             1     10                                                       CLE141
     D  OKFlgLocPR            11     20                                                       CLE141
     D  OKFlgCurPI            21     30                                                       CLE141
     D  OKFlgLocPI            31     40                                                       CLE141
      ***  Flags to indicate whether transaction fields are valid
      *
                                                                                              CAP086
      ** Interface Data Format Definition File format                                         CAP086
     D InfData       E DS                  EXTNAME(LELEIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
     D ZMUSER          DS            17
      ***  ZMUSER data layout
     D  USRBCH                11     13
     D  DBRN                  11     13
      *
     D RUNDAT          DS            13
      *** Rundate data area
     D  RUNA                   1      7
     D  RUND                   8     10P 0
     D  SSF                   11     11
     D  DATF                  12     12
     D  AGMBIN                13     13
      *
     D D#SLFC          DS
     D**S#FCUS**               1      6  0                                                    CSD027
     D  S#FCUS                 1      6                                                       CSD027
     D  S#FTYP                 7      9  0
     D  S#FSEQ                10     11  0
      *
     D                 DS
      ***  Data structure of key list used in chaining to FCLTY
      *
     D  FCTREC                 1     12
     D**WFCNUM**               1      6  0                                                    CSD027
     D  WFCNUM                 1      6                                                       CSD027
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
     D  FCUSM                 64     69                                                       CSD027
     D  FTYPM                 70     72  0
     D  FSEQM                 73     74  0
     D  FCXRM                 75     87  8
     D  FMDIM                 88     88
     D  ORBRM                 89     91
     D  CRSKM                 92     93
     D**LINDM***              94     96                                                       CER020
     D  LOICM                 94     96                                                       CER020
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
     D**CNUMF***             451    456  0                                                    CSD027
     D**PMFC****             457    462  0                                                    CLE106
     D**W#PMFC**             457    462  0                                             CLE106 CSD027
     D  ANUM                 445    450                                                       CSD027
     D  CNUMF                451    456                                                       CSD027
     D  W#PMFC               457    462                                                       CSD027
     D  W#SYCU               463    468
     D  WPTYP                469    470  0
     D**WLIND***             471    473                                                       CER020
     D  WLOIC                471    473                                                       CER020
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
     D  OOSDA                202    219                                                      CGL029
     D  OOMDA                220    237                                                      CGL029
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
     D  SIPFR                 18     18
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
     D  WOSDA                202    219                                                      CGL029
     D  WOMDA                220    237                                                      CGL029
     D  CONFS1                 1     34
     D  LINKS1                 6     34
     D  CONFS2                35    158
     D  LINKS2               183    201
      *
     D DATMSG          DS
     D  O#NIDT                 1      7
     D  O#NRPD                 8     14
      *
      ** +--------------------------------------+
      ** | Declared variables                   |
      ** | ==================                   |
      ** +--------------------------------------+
      *
     D Idx             S              3P 0
      ***  Index for arrays of of error message ids etc
      *
     D WId             S              3P 0
     D WIdx            S              3P 0                                                   BUG4351
      ***  Index for arrays of of warning message ids etc
      *
      ***                                                                                   MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
                                                                                              CLE025
     D CAS016          S              1                                                       CAS019
     D CLE025          S              1                                                       CLE025
     D CLE134          S              1                                                       CLE134
                                                                                              CLE134
      ** Work Variables for CLE141                                                            CLE141
     D CLE141          S              1A                                                      CLE141
     D LCUR            S              3A                                                      CLE141
     D LoanITYPE       S              4A                                                      CLE141
     D OKFlgBDYCL      S              1A                                                      CLE141
     D BDCHolInd       S              7A                                                      CLE141
     D LoanBDC         S             60A                                                      CLE141
     D DayNo           S              5  0                                                    CLE141
     D DayNoZ          S              5  0                                                  MD052327
                                                                                              CLE141
      ** Index for arrays of error message ids etc                                            CLE141
     D Ix              S                   LIKE(Idx)                                          CLE141
                                                                                              CLE141
      ** Array for error message ids                                                          CLE141
     D MsgIDErr        S                   DIM(ArrayMax)                                      CLE141
     D                                     LIKE(#MsgID)                                       CLE141
                                                                                              CLE141
      ** Array for fields in error                                                            CLE141
     D FldNamErr       S                   DIM(ArrayMax)                                      CLE141
     D                                     LIKE(FldNameArr)                                   CLE141
                                                                                              CLE141
     D PRTCD           S              7                                                       CLE025
     D POPTN           S              7                                                       CLE025
     D PSARD           S              6                                                       CLE025
     D CLE106          S              1                                                       CLE106
     D PBRCA           S              3                                                       CLE106
     D CLE031          S              1                                                       CLE031
     D WFCNBP          S              1  0                                                    CLE106
     D WFPAM           S             13  0                                                    CLE106
     D WCFCPA          S             13  0                                                    CLE106
     D WFMINX          S              1                                                       CLE106
     D WSPOT           S             13  8                                                    CLE106
     D WRATM           S             13  8                                                    CLE106
     D WFCXRate        S             13  8                                                    CLE106
     D WRATP           S             13  8                                                    CLE106
     D WrkEndLoop      S              1A                                                   BUG10671R
     D WrkBypass       S              1A                                                      243770
      *                                                                                       CER020
      ** Fields added for CER020                                                              CER020
     D CER020          S              1A                                                      CER020
     D PZErrCd         S              7A                                                      CER020
     D PZDtFmt         S              1A                                                      CER020
     D PZDate          S              6P 0                                                    CER020
     D PZDayNo         S              5P 0                                                    CER020
     D WInsDt          S              5P 0                                                    CER020
     D WFmtDt          S              5P 0                                                    CER020
     D PCcy            S              3A                                                      CER020
     D PZloc           S              3A                                                      CER020
     D PZInd           S              1A                                                      CER020
                                                                                              CLE025
     D PSysVal01       S             20A   INZ('LoansPartPrchPartSld')                       BUG6108
     D PCurSet01       S            200A                                                     BUG6108
     D PSysVal02       S             20A                                                     BUG6108
     D PCurSet02       S            200A                                                     BUG6108
     D PSysVal03       S             20A                                                     BUG6108
     D PCurSet03       S            200A                                                     BUG6108
     D PSysVal04       S             20A                                                     BUG6108
     D PCurSet04       S            200A                                                     BUG6108
     D PSysVal05       S             20A                                                     BUG6108
     D PCurSet05       S            200A                                                     BUG6108
     D PSysVal06       S             20A                                                     BUG6108
     D PCurSet06       S            200A                                                     BUG6108
     D PSysVal07       S             20A                                                     BUG6108
     D PCurSet07       S            200A                                                     BUG6108
     D PSysVal08       S             20A                                                     BUG6108
     D PCurSet08       S            200A                                                     BUG6108
     D PSysVal09       S             20A                                                     BUG6108
     D PCurSet09       S            200A                                                     BUG6108
     D PSysVal10       S             20A                                                     BUG6108
     D PCurSet10       S            200A                                                     BUG6108
                                                                                              CLE158
     D NDayFwd         S              2S 0 INZ(0)                                             CLE158
     D CLE158          S              1A                                                      CLE158
                                                                                              CLE143
     D CLE143          S              1A                                                      CLE143
     D @KEY1           S              3                                                       CLE134
     D @KEY2           S              2                                                       CLE134
     D WPEAInd         S              1A                                                      CSC054
     D CSC054          S              1A                                                      CSC054
      ** Data Structure for MPHAS Dataarea                                                  MD031225
     D MPHAS           DS             1                                                     MD031225
     D AYPCS1          S             11P 7                                                  MD019830
     D AIPCS1          S             11P 7                                                  MD019830
     D*ZIBEG****       S              5  0                                        MD022807 MD022807C
     D*ZIEND****       S              5  0                                        MD022807 MD022807C
     D*ZICALC***       S              1  0                                        MD022807 MD022807C
     D*ZIAMT****       S             15  0                                        MD022807 MD022807C
     D*ZIRATE***       S             11  7                                        MD022807 MD022807C
     D*ZINTR****       S             30  9                                        MD022807 MD022807C
     D*WrkOutInt       S             13  0                                        MD022807 MD022807C
     D*WkRound**       S             13  0                                        MD022807 MD022807C
     D*WOSAC****       S             18                                           MD022807 MD022807C
     D*WSETP****       S              2  0                                        MD022807 MD022807C
     D*ILCNUM***       S              6                                           MD022807 MD022807C
     D*CCYL*****       S              3                                           MD022807 MD022807C
     D*KSCCY****       S              3                                           MD022807 MD022807C
     D*OSBR*****       S              3                                           MD022807 MD022807C
     D*WBLCKD***       S              1                                           MD022807 MD022807C
      ** +--------------------------------------+
      ** | Rename fields                        |
      ** | =============                        |
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
     I/COPY WNCPYSRC,LEH00247
      *
     ILEFCAMD3
     I              RECI                        RECIC
     I              BRCA                        BRCAC
     I              CNUM                        CNUMC
     I              FACT                        FACTC
     I              FCNO                        FCNOC
     I              RVCR                        RVCRC
     I              ASTS                        ASTSC
     I              IUSR                        IUSRC
     I              AUSR                        AUSRC
     I              XUSR                        XUSRC
     I              CHTP                        CHTPC
     I              ORED                        OREDC
     I/COPY WNCPYSRC,LEH00248
      *
     ILELOAM3F
     I              RECI                        RECIA
     I              LNRF                        LNRFA
     I              VDAT                        VDATA
     I              LASN                        LASNA
     I              PRAM                        PRAMA
     I              AMTP                        AMTPA
     I              BRCA                        BRCAA
     I              CNUM                        CNUMA
     I              ORED                        OREDA
     I              TNLU                        TNLUA
     I              GPRT                        GPRTA
     I              NRLI                        NRLIA
     I              CHTP                        CHTPA
     ILEFCLTDD
     I              CNUM                        CNUMB
     I              FACT                        FACTB
     I              FCNO                        FCNOB
     I              FCCY                        FCCYB
     I              TRCA                        TRCAB
     I              AVLD                        AVLDB
     I              FAMT                        FAMTB
      *
     ILEFCLTDC
     I              CNUM                        CNUMD
     I              FACT                        FACTD
     I              FCNO                        FCNOD
     I              RUN0                        RUN0D
     I              RUN1                        RUN1D
     I              RUN2                        RUN2D
     I              RUN3                        RUN3D
     I              RUN4                        RUN4D
     I              RUN5                        RUN5D
     I              RUN6                        RUN6D
     I              RUN7                        RUN7D
     I              RUN8                        RUN8D
     I              RUN9                        RUN9D
     I              OAM1                        OAM1D
     I              OAM2                        OAM2D
     I              OAM3                        OAM3D
     I              OAM4                        OAM4D
     I              OAM5                        OAM5D
     I              OAM6                        OAM6D
     I              OAM7                        OAM7D
     I              OAM8                        OAM8D
     I              OAM9                        OAM9D
     I              OA10                        OA10D
     I/COPY WNCPYSRC,LEH00249
      *
     ICLOANLJ
     I              RECI                        RECIX
     I              LNRF                        LNRFX
     I              RCDT                        RCDTX
     I              MRIN                        MRINX
     I              PTYP                        PTYPX
     I              CNUM                        CNUMX
     I              BRCA                        BRCAX
     I              LTYP                        LTYPX
     I              SUTP                        SUTPX
     I              DDAT                        DDATX
     I              VDAT                        VDATX
     I              MDAT                        MDATX
     I              LASQ                        LASQX
     I              FCUS                        FCUSX
     I              FTYP                        FTYPX
     I              FSEQ                        FSEQX
     I              CCY                         CCYX
     I              CPAM                        CPAMX
     I              INTC                        INTCX
     I              INTR                        INTRX
     I              BRTT                        BRTTX
     I              BRTE                        BRTEX
     I              RTSP                        RTSPX
     I              MARG                        MARGX
     I              SPIN                        SPINX
     I              CHIN                        CHINX
     I              WTRT                        WTRTX
     I              WTIN                        WTINX
     I              REPT                        REPTX
     I              RAMT                        RAMTX
     I              NRPD                        NRPDX
     I              RFRQ                        RFRQX
     I              RDYN                        RDYNX
     I              FCCY                        FCCYX
     I              LIND                        LINDX
     I              CRSK                        CRSKX
     I              ACOF                        ACOFX
     I              NACD                        NACDX
     I              RELI                        RELIX
     I              AUTO                        AUTOX
     I              PSAM                        PSAMX
     I              BCXR                        BCXRX
     I              FCXR                        FCXRX
     I              SDST                        SDSTX
     I              OSDA                        OSDAX
     I              TSTN                        TSTNX
     I              MDST                        MDSTX
     I              OMDA                        OMDAX
     I              TMAN                        TMANX
     I              FACO                        FACOX
     I              RLDT                        RLDTX
     I              NROD                        NRODX
     I              RLFQ                        RLFQX
     I              RLDY                        RLDYX
     I              RDFC                        RDFCX
     I              NBRA                        NBRAX
     I              NRTS                        NRTSX
     I              NSIN                        NSINX
     I              NCAS                        NCASX
     I              AWTP                        AWTPX
     I              WTRD                        WTRDX
     I              WTWD                        WTWDX
     I              IWOD                        IWODX
     I              PWOD                        PWODX
     I              BMDI                        BMDIX
     I              FMDI                        FMDIX
     I              PDIN                        PDINX
     I              LSWC                        LSWCX
     I              LSWS                        LSWSX
     I              OSDB                        OSDBX
     I              OMDB                        OMDBX
     I              ORBR                        ORBRX
     I              PRFC                        PRFCX
     I              FCLB                        FCLBX
     I              MLNR                        MLNRX
     I              BTIN                        BTINX
     I              BLDY                        BLDYX
     I              OLNO                        OLNOX
     I              RCSI                        RCSIX
     I              ICBS                        ICBSX
     I              IPFR                        IPFRX
     I              TOTI                        TOTIX
     I              NIDT                        NIDTX
     I              IBDT                        IBDTX
     I              SLID                        SLIDX
     I              AIPD                        AIPDX
     I              DLRC                        DLRCX
     I              IACD                        IACDX
     I              AITC                        AITCX
     I              TFEP                        TFEPX
     I              AIAP                        AIAPX
     I              IPRD                        IPRDX
     I              IPRM                        IPRMX
     I              ICTD                        ICTDX
     I              AIMN                        AIMNX
     I              RBDT                        RBDTX
     I              NOPS                        NOPSX
     I              NCHI                        NCHIX
     I              ZZ001A                      ZZ01AX
     I              IFDY                        IFDYX
     I              LONI                        LONIX
     I              CNFI                        CNFIX
     I              ACEI                        ACEIX
     I              TLXI                        TLXIX
     I              CBLI                        CBLIX
     I              ORED                        OREDX
     I              LCD                         LCDX
     I              CHTP                        CHTPX
     I              TNLU                        TNLUX
     I              ADDI                        ADDIX
     I              ORMD                        ORMDX
     I              ORTI                        ORTIX
     I              ZZ023A                      ZZ23AX
     I              BOKC                        BOKCX
     I              COCU                        COCUX
     I              RECE                        RECEX
     I              OMDT                        OMDTX
     I              NIPD                        NIPDX
     I              NMDT                        NMDTX
     I              APMI                        APMIX
     I              RSTM                        RSTMX
     I              RONS                        RONSX
     I              RIBN                        RIBNX
     I              RIBA                        RIBAX
     I              ROBN                        ROBNX
     I              ROCN                        ROCNX
     I              PSTM                        PSTMX
     I              PONS                        PONSX
     I              PIBN                        PIBNX
     I              PIBA                        PIBAX
     I              POBN                        POBNX
     I              POCN                        POCNX
     I              RCRN                        RCRNX
     I              RCRA                        RCRAX
     I              RVNO                        RVNOX
     I              AWBN                        AWBNX
     I              AWBA                        AWBAX
     I              BENN                        BENNX
     I              BENA                        BENAX
     I              DTP1                        DTP1X
     I              DTP2                        DTP2X
     I              DTP3                        DTP3X
     I              DTP4                        DTP4X
     I              DCHG                        DCHGX
     I              BTB1                        BTB1X
     I              BTB2                        BTB2X
     I              BTB3                        BTB3X
     I              BTB4                        BTB4X
     I              BTB5                        BTB5X
     I              BTB6                        BTB6X
     I              CVMR                        CVMRX
     I              PTFR                        PTFRX
     I              HLEX                        HLEXX
     I              FSRP                        FSRPX
     I              FSGN                        FSGNX
     I              FPRC                        FPRCX
     I              TCOF                        TCOFX
     I              ACPD                        ACPDX
     I              ACDA                        ACDAX
     I              ACAJ                        ACAJX
     I              ACAP                        ACAPX
     I              COFD                        COFDX
     I              COFM                        COFMX
     I              CFCD                        CFCDX
     I              NFRS                        NFRSX
     I              NFSN                        NFSNX
     I              NFPC                        NFPCX
     I              PDCF                        PDCFX
     I              FCTD                        FCTDX
     I              FWOD                        FWODX
     I              DFTP                        DFTPX
     I              DFST                        DFSTX
     I              MCRA                        MCRAX
     I              FCRA                        FCRAX
     I              PDDI                        PDDIX
     I              PTDI                        PTDIX
     I              GDPR                        GDPRX
     I              GDIN                        GDINX
     I              LNKS                        LNKSX
     I              MNSG                        MNSGX
     I              GASS                        GASSX
     I              GPRT                        GPRTX
     I              TOLN                        TOLNX
     I              LSTS                        LSTSX
     I              IUSR                        IUSRX
     I              AUSR                        AUSRX
     I              XUSR                        XUSRX
     I              RATF                        RATFX
     I              CNCF                        CNCFX
     I              PCRF                        PCRFX
     I              LPFI                        LPFIX
     I              PTFC                        PTFCX
     I              PTFT                        PTFTX
     I              PTFN                        PTFNX
     I              PCOB                        PCOBX
     I              LRLD                        LRLDX
     I              LMCD                        LMCDX
     I              OIDT                        OIDTX
     I              CLAS                        CLASX                                         CLE042
     I              DFCL                        DFCLX                                         CLE042
     I              SLTP                        SLTPX                                         CLE042
     I              SLST                        SLSTX                                         CLE042
     I              SLCL                        SLCLX                                         CLE042
     I              LOIC                        LOICX                                         CER020
      *
     ILOAMSDKF
     I              RECI                        RECIA
     I              LNRF                        LNRFA
     I              VDAT                        VDATA
     I              LASN                        LASNA
     I              AMTP                        AMTPA
     I              BRCA                        BRCAA
     I              CNUM                        CNUMA
     I              ORED                        OREDA
     I              TNLU                        TNLUA
     I              GPRT                        GPRTA
     I              CHTP                        CHTPA
     I              LTYP                        LTYPA                                       AR632104
     I              SUTP                        SUTPA                                       AR632104
     I              CLAS                        CLASA                                       AR632104
     I              LSMD                        LSMDA                                       AR722666
      *
     ILEFCAMPF
     I              RECI                        RECIC
     I              BRCA                        BRCAC
     I              CNUM                        CNUMC
     I              FACT                        FACTC
     I              FCNO                        FCNOC
     I              RVCR                        RVCRC
     I              ASTS                        ASTSC
     I              IUSR                        IUSRC
     I              AUSR                        AUSRC
     I              XUSR                        XUSRC
     I              CHTP                        CHTPC
     I              ORED                        OREDC
     I/COPY WNCPYSRC,LEH00250
      *
     ICLOANCKF
     I              NLRA                        NLRAK
     I              ORED                        OREDK
      *
     ICLOANCLF
     I              PCOB                        PCOBL
     I              PCRF                        PCRFL
      *
     IPSOLDF
     I              RECI                        PRECI
     I              OLNO                        POLNO
     I              MDAT                        PMDTE
     I              PTYP                        PPTYP
     I              LNKS                        PLNKS                                         243770
      *
     ILEFCLTD0
     I              RECI                        RECIF
     I              CNUM                        CNUMF
     I              BRCA                        BRCAF
     I              FCCY                        FCCYF
     I              DTAP                        DTAPF
     I              DTEX                        DTEXF
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
     I              COMD                        COMDF
     I              SCCY                        SCCYF
     I              ICCY                        ICCYF
      *
      ** +--------------------------------------+
      ** | End of D-specs                       |
      ** | ==============                       |
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** | Hook for non-core D-specs (all types)  |
      ** | also any I-specs (if necessary)        |
      ** | =====================================  |
      ** +----------------------------------------+
      /COPY WNCPYSRC,LECLIP1V02
      *
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** |                                                                |
      ** | Initial processing is performed automatically: the *INZSR is   |
      ** | executed at program activation.                                |
      ** |                                                                |
      ** +----------------------------------------------------------------+
      *
      ** GET ZMUSER to access default branch.                                                BUG7029
                                                                                             BUG7029
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C                   IN        ZMUSER                                                    BUG7029
     C                   UNLOCK    ZMUSER                                                    BUG7029
                                                                                             BUG7029
      /COPY WNCPYSRC,LECLIP1V03
      *
      ***  Validation for screen details 1
      *    ===============================
                                                                                              CLE106
      ** Reset fields of loans file                                                           CLE106
     C                   CLEAR                   CLOANCLfmt                                   CLE106
      *
      ***  Reset variables updated by each module
     C                   EXSR      RESETERRS
      *                                                                                     AR804863
      ** Skip validation process if action is reject.                                       AR804863
      *                                                                                     AR804863
     C     @ACTRV        IFEQ      'Y'                                                      AR804863
     C                   EXSR      SRRSFD                                                   AR804863
     C                   RETURN                                                             AR804863
     C                   ENDIF                                                              AR804863
      *
      /COPY WNCPYSRC,LECLIP1V04
      *
      ***  Validate Customer/Original borrower
     C                   EXSR      SRCUST
      *
      /COPY WNCPYSRC,LECLIP1V05
      *
      ***  Validate facility (for loans and parts purchased)
      ***  Default to customer if blank
     C                   EXSR      SRFCUS
      *
      /COPY WNCPYSRC,LECLIP1V06
      *
      ***  Validate branch code
      ***  All validations relating to facility will be ignored
      ***  for parts sold as it does not have the facility field
     C                   EXSR      SRBRCA
      *
      /COPY WNCPYSRC,LECLIP1V07
      *                                                                                       CLE042
      ** Default Sub Type and Class                                                           CLE042
     C                   EXSR      DSUBTCLAS                                                  CLE042
      *
      ***  Validate loan type/subtype
     C                   EXSR      SRLNTS
      *                                                                                       CLE134
      ***  Validate PDCL principal/interest default base rate                                 CLE134
     C                   IF        CLE134  = 'Y' AND                                          CLE134
     C                             CCLAUTO = 'C' AND                                          CLE134
     C                             TranInScr6 = *Blanks                                       CLE134
     C                   IF        %SUBST(DDLTYP:1:1) <> 'X'    AND                         MD020274
     C                             %SUBST(DDLTYP:1:1) <> 'Y'    AND                         MD020274
     C                             %SUBST(DDLTYP:1:1) <> 'Z'                                MD020274
     C                   EXSR      SRBSRT                                                     CLE134
     C                   ENDIF                                                              MD020274
     C                   ENDIF                                                                CLE134
      *
      /COPY WNCPYSRC,LECLIP1V08
      *                                                                                      BUG6108
      ***  Validate Loan number if insert mode                                               BUG6108
     C                   If        DDACTN = 'I'                                              BUG6108
     C                   EXSR      SRLNRF                                                    BUG6108
     C                   EndIf                                                               BUG6108
      /COPY WNCPYSRC,LECLIP1V33                                                              BUG6108
      *
      ***  Validate purchased from (for parts purchased)
     C                   EXSR      SRPFRM
      *
      /COPY WNCPYSRC,LECLIP1V09
      *
      ***  Validate mirror loan number (for parts purchased)
     C                   EXSR      SRMLNR
      *
      /COPY WNCPYSRC,LECLIP1V10
      *
      ***  Validate sale of loan number (for parts sold)
     C                   EXSR      SROLNO
      *
      /COPY WNCPYSRC,LECLIP1V11
      *
      ***  Validate the currency
     C                   EXSR      SRCURR
      *
      /COPY WNCPYSRC,LECLIP1V12
      *
      ***  Validate the amount of loan
     C                   EXSR      SRCPAM
      *
      /COPY WNCPYSRC,LECLIP1V13
      *
      ***  Validate the deal date
     C                   EXSR      SRDDAT
      *
      /COPY WNCPYSRC,LECLIP1V14
                                                                                              CLE143
      ** Validate Original Contract Date                                                      CLE143
                                                                                              CLE143
     C                   MOVEL     *BLANKS       DDOCDT                                       CLE134
     C                   IF        CLE143 = 'Y'                                               CLE143
     C                   EXSR      SROCDT                                                     CLE143
     C                   ENDIF                                                                CLE143
      *
      ***  Validate auto settlement indicator
     C                   EXSR      SRAUTO
      *
      /COPY WNCPYSRC,LECLIP1V15
      *
      ***  Validate the value date
     C                   EXSR      SRVDAT
      *
      /COPY WNCPYSRC,LECLIP1V16
      *
      ***  Validate the recourse indicator
     C                   EXSR      SRRCSI
      *
      /COPY WNCPYSRC,LECLIP1V17
      *
      ***  Validate the maturity date
     C                   EXSR      SRMDAT
      *
      ***  Additional validation for parts sold
      ***  (when sale of loan number is valid)
      *
     C     RespMode      IFNE      'S'
     C     DDACTN        ANDEQ     'R'
     C     W#SEQ         ANDEQ     1
     C     RespMode      OREQ      'S'
     C     RespMode      ORNE      'S'
     C     DDACTN        ANDNE     'R'
      *
     C     *IN83         IFEQ      '1'
     C     DDOLNOOK      ANDNE     'N'
     C                   EXSR      SRSOLD
     C                   ENDIF
     C                   ENDIF
      *
      /COPY WNCPYSRC,LECLIP1V18
      *
      ***  Validate the auto-pay at maturity indicator (for S01465)
     C                   EXSR      SRAPMI
      *
      /COPY WNCPYSRC,LECLIP1V19
      *
      ***  Validate the multi-currency rollovers allowed
     C                   EXSR      SRMCRA
      *
      /COPY WNCPYSRC,LECLIP1V20
                                                                                              CLE141
      ** Validate Business Day Convention Details                                             CLE141
     C                   IF        CLE141 = 'Y'                                               CLE141
     C                   EXSR      SRBDYCL                                                    CLE141
     C                   ENDIF                                                                CLE141
      *
      ***  Validate the rollover date
     C                   EXSR      SRRLDT
      *
      /COPY WNCPYSRC,LECLIP1V21
      *
      ***  Validate the rollover frequency and day number
     C                   EXSR      SRRLFQ
      *
      ***  Validate the rate fixing days
     C                   EXSR      SRRFDY
      *
      /COPY WNCPYSRC,LECLIP1V22
      *
      ***  Validate default participation loan type/subtype
      ***  (for loans and parts purchased when facility is syndicated)
     C                   EXSR      SRDFTP
      *                                                                                       CLE106
      **  Validate default Sub-participation loan type/subtype when CLE106 is on              CLE106
      *                                                                                       CLE106
     C     CLE106        IFEQ      'Y'                                                        CLE106
     C                   EXSR      SRFSTP                                                     CLE106
     C                   ENDIF                                                                CLE106
      *
      /COPY WNCPYSRC,LECLIP1V23
      *
      ***  Validate linked to syndicate
     C                   EXSR      SRLNKS
      *
      /COPY WNCPYSRC,LECLIP1V24
      *
      ***  Validate assignment (For Part. Purchase)
     C                   EXSR      SRASSN
      *
      /COPY WNCPYSRC,LECLIP1V25
                                                                                              CLE034
      ** Update Settlement Allocation                                                         CLE034
                                                                                              CLE034
     C                   EVAL      CCLSTAL = DDSTAL                                           CLE034
                                                                                              245411
      ** Update Originating Loan Number and Generated by Prin Tfr ind.                        245411
                                                                                              245411
     C                   IF        DDPNTF   = 'Y'                                             245411
     C                   EVAL      CCLGPRT  = 'Y'                                             245411
     C                   MOVE      DDTOLN        CCLTOLN                                      245411
     C                   ELSE                                                                 245411
     C                   EVAL      CCLGPRT  = 'N'                                             245411
     C**********         MOVE      *ZEROS        CCLTOLN                               245411 CLE148
     C                   MOVE      *BLANKS       CCLTOLN                                      CLE148
     C                   ENDIF                                                                245411
      **********                                                                   AR820729 MD055380
      ***Validate*Rollover*Status                                                  AR820729 MD055380
      **********                                                                   AR820729 MD055380
     C**********         EXSR      SRRSTS                                          AR820729 MD055380
      *                                                                                       CER020
      ** Validate Initial Start and Final Maturity Date                                       CER020
      *                                                                                       CER020
     C                   IF        CER020 = 'Y'                                               CER020
      *                                                                                       CER020
     C                   IF        DDVDATOK <> 'N'                                            CER020
     C                   EXSR      SRVInStDt                                                  CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   IF        DDMDATOK <> 'N'                                            CER020
     C                   EXSR      SRVFnMtDt                                                  CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *
      ***  Update error information with that received back
      ***  from each validation module.
     C                   EXSR      UPDATERRS
      *
      ***  Save the loan reference for warning
      *
     C                   MOVEL     DDLNRF        SaveDDLNRF        6
      *
      /COPY WNCPYSRC,LECLIP1V26
      *
      ***  Return
      *    ======
     C                   RETURN
      *
      *****************************************************************
     C/EJECT                                                                                 BUG6108
      *****************************************************************                      BUG6108
      *  SRLNRF - Validate loan number                               *                       BUG6108
      *****************************************************************                      BUG6108
     C     SRLNRF        BegSR                                                               BUG6108
                                                                                             BUG6108
      ** Loan number must be left blank unless                                               BUG6108
      ** system value 'Auto-allocate loan numbers' is set to 'N'                             BUG6108
      *                                                                                      BUG6108
     C                   If        AUTOLN = 'Y'                                          B01 BUG6108
      *                                                                                      BUG6108
     C                   If        DDLNRF <> *BLANKS                                     B02 BUG6108
                                                                                             BUG8436
      ***Allow*entry*for*loan*number*for*Insert*if*CSC024*is                          BUG8436 CSC054
      ***switched*on*and*running*on*OME*system.                                       BUG8436 CSC054
      ** Allow entry for loan number for Insert if CSC054 is                                  CSC054
      ** switched on and running on PEA system.                                               CSC054
                                                                                             BUG8436
     C**********         IF        CSC024 <> 'Y' OR                                   BUG8436 CSC054
     C**********                   WOMEInd <> 'Y'                                     BUG8436 CSC054
     C                   IF        CSC054 <> 'Y' OR                                          BUG8436
     C                             WPEAInd <> 'Y'                                            BUG8436
                                                                                             BUG8436
     C                   MOVE      *BLANKS       WFOTRID           8                        MD032052
     C                   MOVEL     APFOTranID    WFOTRID                                    MD032052
     C     CLE134        IFEQ      'N'                                                      MD031225
     C     CLE134        OREQ      'Y'                                                      MD031225
     C     MPHAS         ANDNE     'C'                                                      MD031225
     C     WFOTRID       ANDNE     'LE000473'                                               MD032052
     C                   Eval      Idx = Idx + 1                                             BUG6108
     C                   Eval      DDLNRFOK = 'N'                                            BUG6108
     C                   Eval      FldNamXAr(Idx) = 'DDLNRF'                                 BUG6108
     C/COPY WNCPYSRC,LECLIP1V28                                                              BUG6108
     C                   If        CLE010 = 'Y'                                          B03 BUG6108
     C                   Eval      MsgIDXAr(Idx) = 'LEL0401'                                 BUG6108
     C                   Else                                                            X03 BUG6108
     C                   Eval      MsgIDXAr(Idx) = 'LEL0541'                                 BUG6108
     C                   EndIf                                                           E03 BUG6108
     C                   ENDIF                                                              MD031225
                                                                                             BUG8436
     C                   ENDIF                                                               BUG8436
                                                                                             BUG8436
     C                   EndIf                                                           E02 BUG6108
      *                                                                                      BUG6108
      * Else, system value allows user to input a loan number manually                       BUG6108
      *                                                                                      BUG6108
     C                   Else                                                            X01 BUG6108
      *                                                                                      BUG6108
     C                   If        DDLNRF <> *blanks                                     B02 BUG6108
      * Loan number has been entered                                                         BUG6108
      *                                                                                       CLE148
     C                   If        wLoanAlpha = 'N'                                           CLE148
      *                                                                                       CLE148
      * Check that loan number is between 000001 and 999998 inclusive                        BUG6108
     C                   MOVEL     DDLNRF        WNUM7                                       BUG6108
     C                   MOVEL     WNUM7         WALF6                                       BUG6108
     C                   If        DDLNRF <> WALF6 or                                    B03 BUG6108
     C                             DDLNRF = '000000' or                                      BUG6108
     C                             DDLNRF = '999999'                                         BUG6108
     C                   Eval      Idx = Idx + 1                                             BUG6108
     C                   Eval      DDLNRFOK = 'N'                                            BUG6108
     C                   Eval      FldNamXAr(Idx) = 'DDLNRF'                                 BUG6108
     C                   Eval      MsgIDXAr(Idx) = 'LEL0540'                                 BUG6108
     C                   EndIf                                                           E03 BUG6108
      *                                                                                       CLE148
     C                   Else                                                                 CLE148
      *                                                                                       CLE148
      ** Call program 'LELOANISO' to validate the number.                                     CLE148
      *                                                                                       CLE148
     C                   Eval      PLNRF = DDLNRF                                             CLE148
     C                   Eval      PValid = *BLANKS                                           CLE148
     C                   Eval      PChkDigit = *BLANK                                         CLE148
     C                   Eval      PData = *BLANKS                                            CLE148
      *                                                                                       CLE148
     C                   Call(E)   'LELOANISO'   P_LELOANISO                                  CLE148
      *                                                                                       CLE148
     C                   If        PValid <> *BLANKS                                          CLE148
     C                   Eval      Idx = Idx + 1                                              CLE148
     C                   Eval      DDLNRFOK = 'N'                                             CLE148
     C                   Eval      FldNamXAr(Idx) = 'DDLNRF'                                  CLE148
     C                   Eval      MsgIDXar(Idx) = '5045549'                                  CLE148
     C                   EndIf                                                                CLE148
      *                                                                                    AR1021136
     C                   IF        PValid = *BLANKS and                                    AR1021136
     C                             (DDLNRF= '000000' or                                    AR1021136
     C                              DDLNRF = '999999')                                     AR1021136
     C                   EVAL      Idx = Idx + 1                                           AR1021136
     C                   EVAL      DDLNRFOK = 'N'                                          AR1021136
     C                   EVAL      FldNamXAr(Idx) = 'DDLNRF'                               AR1021136
     C                   EVAL      MsgIDXAr(Idx) = '5045916'                               AR1021136
     C                   ENDIF                                                             AR1021136
      *                                                                                       CLE148
     C                   EndIf                                                                CLE148
      *                                                                                      BUG6108
      * Check that loan number has not already been used.                                    BUG6108
      * First check for existence in live loans file:                                        BUG6108
     C                   MOVE      DDLNRF        WALON                                       BUG6108
     C                   MOVE      'A'           WEPAR                                       BUG6108
     C*****WKLON         CHAIN     CLOAN                              89            BUG6108 MD020605
     C     WKLON         CHAIN (N) CLOAN                              89                    MD020605
     C                   If        *IN89 = '0'                                           B03 BUG6108
     C                   Eval      Idx = Idx + 1                                             BUG6108
     C                   Eval      DDLNRFOK = 'N'                                            BUG6108
     C                   Eval      FldNamXAr(Idx) = 'DDLNRF'                                 BUG6108
     C                   Eval      MsgIDXAr(Idx) = 'LEL0539'                                 BUG6108
     C                   EndIf                                                           E03 BUG6108
      *                                                                                      BUG6108
      * Then check for existence in matured loan file:                                       BUG6108
     C**********         MOVE      DDLNRF        MLLNRF            6 0                BUG6108 CLE148
     C                   MOVE      DDLNRF        MLLNRF            6                          CLE148
     C                   MOVE      'A'           MLRCDT            1                         BUG6108
     C     MLKEY         CHAIN     MLOAN                              89                     BUG6108
     C                   If        *IN89 = '0'                                           B03 BUG6108
     C                   Eval      Idx = Idx + 1                                             BUG6108
     C                   Eval      DDLNRFOK = 'N'                                            BUG6108
     C                   Eval      FldNamXAr(Idx) = 'DDLNRF'                                 BUG6108
     C                   Eval      MsgIDXAr(Idx) = 'LEL0539'                                 BUG6108
     C                   EndIf                                                           E03 BUG6108
     C                   EndIf                                                           E02 BUG6108
     C                   EndIf                                                           E01 BUG6108
      *                                                                                      BUG6108
      * DDLNRF is blank, get next available loan number                                      BUG6108
     C                   If        DDLNRF = *BLANKS                                      B01 BUG6108
     C                   EXSR      SRNXLNRF                                                  BUG6108
     C                   EndIf                                                           E01 BUG6108
      *                                                                                      BUG6108
     C                   EndSR                                                               BUG6108
      *****************************************************************                      BUG6108
     C/EJECT                                                                                 BUG6108
      *****************************************************************                      BUG6108
      *  SRNXLNRF - Get next available loan reference                *                       BUG6108
      *****************************************************************                      BUG6108
     C     SRNXLNRF      BegSR                                                               BUG6108
      *                                                                                      BUG6108
     C                   MOVEL     PRANG         PRANGW            2 0                       BUG6108
     C                   MOVE      PRANG         WWRANG            2                         BUG6108
      *                                                                                      BUG6108
     C**********         If        PRANGW < 10                                       BUG6108 BUG8017
     C**********         MOVEL     ' '           WWRANG                              BUG6108 BUG8017
     C**********         EndIf                                                       BUG6108 BUG8017
      *                                                                                      BUG6108
     C/COPY WNCPYSRC,LECLIP1V29                                                              BUG6108
     C                   CALL      'AOLENOR0'                                                BUG6108
     C                   PARM      *BLANKS       PRTCD                                       BUG6108
     C                   PARM      '*KEY'        POPTN                                       BUG6108
     C                   PARM                    WWRANG                                      BUG6108
     C     SDLENO        PARM      SDLENO        DSFDY                                       BUG6108
                                                                                             BUG6108
      * If loan number range was not found for this loan type-subtype                        BUG6108
      * display an error message                                                             BUG6108
     C                   If        PRtCd <> *BLANKS                                          BUG6108
      *                                                                                      BUG6108
     C                   Eval      Idx = Idx + 1                                             BUG6108
     C                   Eval      DDLNRFOK = 'N'                                            BUG6108
     C                   Eval      FldNamXAr(Idx) = 'DDLNRF'                                 BUG6108
     C                   If        CLE010 = 'N'                                              BUG6108
     C                   If        AUTOLN = 'Y'                                              BUG6108
     C                   Eval      MsgIDXAr(Idx) = 'LEL0542'                                 BUG6108
     C                   Else                                                                BUG6108
     C                   Eval      MsgIDXAr(Idx) = 'LEL0543'                                 BUG6108
     C                   EndIf                                                               BUG6108
     C                   Else                                                   CLE010 is on.BUG6108
     C                   Eval      MsgIDXAr(Idx) = 'LEL0561'                                 BUG6108
     C                   EndIf                                                               BUG6108
      *                                                                                      BUG6108
     C/COPY WNCPYSRC,LECLIP1V31                                                              BUG6108
     C/COPY WNCPYSRC,LECLIP1V30                                                              BUG6108
     C                   EndIf                                                               BUG6108
      *                                                                                      BUG6108
     C/COPY WNCPYSRC,LECLIP1V32                                                              BUG6108
                                                                                             BUG6108
     C                   EndSR                                                               BUG6108
      *****************************************************************                      BUG6108
     C/EJECT
      *****************************************************************
      *  SRCUST - Validate customer/Original borrower                 *
      *****************************************************************
     C     SRCUST        BEGSR
      *
      ***  The customer number cannot be blank
      *
     C     DDCUST        IFEQ      *BLANKS
     C                   MOVE      'N'           DDCUSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCUST'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0178'     MsgIDXAr(Idx)
      *
      ***  Must be a valid customer
      *
     C                   ELSE
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      DDCUST        @CUST            10
     C                   PARM      *BLANKS       @KEYSTS           7
     C     SDCUST        PARM      SDCUST        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDCUSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCUST'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0034'     MsgIDXAr(Idx)
     C     @RTCD         IFEQ      '*NOSEL  '
     C                   MOVE      *BLANKS       DDCUST
     C                   ENDIF
     C                   ELSE
      *
      ***  Must not be a parent
      *
     C     *IN82         IFEQ      '0'
     C                   MOVE      BBCUST        WSVCN             6
     C                   ENDIF
     C                   MOVE      *BLANKS       DDCUST
     C                   MOVEL     BBCUST        DDCUST
     C**********         MOVE      BBLICD        WLIND             3                          CER020
     C                   MOVE      BBLICD        WLOIC             3                          CER020
     C     BBPAIN        IFEQ      'P'
     C                   MOVE      'N'           DDCUSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCUST'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0036'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ***  Original borrower must be different from purchased from
      ***  customer
     C     *IN82         IFEQ      '1'

     C     DDCUSTOK      IFNE      'N'
     C     DDCUST        ANDEQ     DDPFRM
     C                   MOVE      'N'           DDCUSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCUST'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0172'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF

     C     DDCUSTOK      IFNE      'N'
     C     *IN82         IFEQ      '0'
     C                   MOVEL     DDCUST        CCLCNUM
     C                   ELSE
     C                   MOVEL     DDCUST        CCLOLNO
     C                   MOVEL     DDCUST        DDOLNO                                     BUG13843
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CGL058
      ** Check if it is necessary to default one of the the branch codes                      CGL058
      ** This must be done here as branch code is used in SRFCUS                              CGL058
      *                                                                                       CGL058
     C                   IF            CGL058   =  'Y'                                        CGL058
     C                             AND DDCUSTOK <> 'N'                                        CGL058
     C                             AND BGMBIN   =  'Y'                                        CGL058
     C                             AND DDACTN   =  'I'                                        CGL058
      *                                                                                       CGL058
      ** Default the Branch Code                                                              CGL058
      *                                                                                       CGL058
     C                   IF            DDBRCA = *Blanks                                       CGL058
     C                   EVAL      DDBRCA = BBBRCD                                            CGL058
     C                   ENDIF                                                                CGL058
      *                                                                                       CGL058
      ** Always default the field Originating Branch Code of the valid file.                  CGL058
      ** LECLIP3VL will decide on using or not the value                                      CGL058
      *                                                                                       CGL058
     C                   IF            BKOBRU = 'Y'                                           CGL058
     C                   EVAL      CCLORBR = BBBRCD                                           CGL058
     C                   ENDIF                                                                CGL058
      *                                                                                       CGL058
     C                   ENDIF                                                                CGL058
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRFCUS - Validate facility (for loans and parts purchased)   *
      *****************************************************************
     C     SRFCUS        BEGSR
      *
      ***  Retrieve previous settings for ACEI when amending a loan
      *
     C     DDACTN        IFEQ      'A'
     C                   MOVE      @@ACEI        WACEI             1
     C                   ENDIF
      *
      ***  Rset working fields
      *
     C                   MOVE      *BLANK        WCPRTR            1
     C                   MOVE      *BLANK        WAGENT            6
     C**********         Z-ADD     0             WCPMFC            6 0                        CSD027
     C                   MOVE      *BLANKS       WCPMFC            6                          CSD027
     C                   Z-ADD     0             WCPMFT            3 0
     C                   Z-ADD     0             WCPMFN            2 0
      *
      ***  VALIDATE FACILITY (for loans and parts purchased)
      ***  Default to customer if blank
      *
     C     *IN83         IFEQ      '0'
      *
     C                   DO
     C     DDFCUS        IFEQ      *BLANKS
     C                   MOVEL     DDCUST        DDFCUS
     C     *IN82         IFEQ      '1'
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      DDPFRM        @CUST
     C                   PARM      *BLANKS       @KEYSTS
     C     SDCUST        PARM      SDCUST        DSSDY
     C     @RTCD         IFEQ      '*NOSEL  '
     C                   MOVE      *BLANKS       DDPFRM
     C                   ENDIF
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      *BLANKS       DDPFRM
     C                   MOVEL     BBCUST        DDPFRM
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ***  Must be numeric
      *
     C**********         MOVEL     DDFCUS        WNUM7             7 0                        CSD027
     C**********         MOVEL     WNUM7         WALF6             6                          CSD027
     C*****DDFCUS        IFNE      WALF6                                                      CSD027
     C**********         MOVE      'N'           DDFCUSOK                                     CSD027
     C**********         ADD       1             Idx                                          CSD027
     C**********         MOVEL     'DDFCUS'      FldNamXAr(Idx)                               CSD027
     C**********         MOVEL     'LEL0134'     MsgIDXAr(Idx)                                CSD027
     C**********         LEAVE                                                                CSD027
     C**********         ENDIF                                                                CSD027
      *
      ***  Facility must exist on facility file (both A and B recs)
      *
     C                   MOVE      DDFCUS        WFCNUM
     C                   MOVE      DDFTYP        WFFACT
     C                   MOVE      DDFSEQ        WFFCNO
     C                   MOVE      'A'           WFRCTP
     C     WKFAC         CHAIN(N)  FCLTY                              99
      *                                                                                      BUG4663
     C                   MOVE      'B'           WFRCTP                                      BUG4663
     C     WKFAC         CHAIN(N)  FCLTY                              30                     BUG4663
      *                                                                                      BUG4663
     C     *IN30         IFEQ      *ON                                                       BUG4663
     C     *IN99         ANDEQ     *OFF                                                      BUG4663
     C     *LOCK         IN        LDA                                                       BUG4663
     C                   MOVEL     'FCLTYFN'     DBFILE                                      BUG4663
     C                   Z-ADD     16            DBASE                                       BUG4663
     C                   MOVEL     FCTREC        DBKEY                                       BUG4663
     C                   OUT       LDA                                                       BUG4663
     C                   EXSR      *PSSR                                                     BUG4663
     C                   ENDIF                                                               BUG4663
      *
      ***  If Facility is either closed or expired, check for records
      ***  in PF/LEFCAMPD if it has been reactivated.
      *
     C     *IN99         IFEQ      *OFF
     C                   EXSR      SRCKFR
     C                   ENDIF
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           DDFCUSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFCUS'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0134'     MsgIDXAr(Idx)
     C                   LEAVE
     C                   ENDIF
      *
      ***  Check if facility is multi-customer
      *
     C     *IN99         IFEQ      '0'
     C     DDFCUSOK      ANDNE     'N'
     C*****DDCUST        ANDNE     DDFCUS                                                     256611
     C     MCSIF         ANDNE     'Y'
     C     DDCUST        IFNE      DDFCUS                                                     256611
     C     *IN82         ANDEQ     '0'                                                        256611
     C                   MOVE      'N'           DDFCUSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFCUS'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0112'     MsgIDXAr(Idx)
     C                   LEAVE
     C                   ENDIF                                                                256611
     C                   ENDIF
      *
      ***  Skip this validation if fclty has been reactivated.
      *
     C     *IN99         IFEQ      '0'
     C     RECIF         ANDNE     'D'
     C     DDACTN        ANDEQ     'I'
     C     WREAC         ANDEQ     *OFF
     C     *IN99         OREQ      '0'
     C     RECIF         ANDNE     'D'
     C     DDACTN        ANDEQ     'A'
     C     WREAC         ANDEQ     *OFF
      *
     C                   MOVEL     DDLTYP        LTYP1                                      AR763386
      *                                                                                     AR763386
     C     RECIF         IFEQ      'E'
      *                                                                                    AR1094066
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     DDMDAT        ANDEQ     *BLANKS
     C*****LTYP1         ANDNE     'X'                                           AR763386  AR1094066
     C*****LTYP1         ANDNE     'Y'                                           AR763386  AR1094066
     C*****LTYP1         ANDNE     'Z'                                           AR763386  AR1094066
      *                                                                                    AR1094066
     C                   IF        CLE134 = 'Y'                                            AR1094066
      *                                                                                    AR1094066
     C                   CALL      'AOLOANR0'                                              AR1094066
     C                   PARM      *BLANKS       @RTCD                                     AR1094066
     C                   PARM      '*KEY   '     @OPTN                                     AR1094066
     C                   PARM                    DDLTYP                                    AR1094066
     C                   PARM                    DDSUTP                                    AR1094066
     C                   PARM                    DDCLAS                                    AR1094066
     C     SDLOAN        PARM      SDLOAN        DSSDY                                     AR1094066
      *                                                                                    AR1094066
     C                   IF        (LTYP1 = 'X' OR LTYP1 = 'Y' OR LTYP1 = 'Z')             AR1094066
     C                   IF        (AYFAMU <> 'Y')                                         AR1094066
     C                   GOTO      SkipVal                                                 AR1094066
     C                   ENDIF                                                             AR1094066
     C                   ENDIF                                                             AR1094066
     C                   ENDIF                                                             AR1094066
      *                                                                                    AR1094066
     C                   MOVE      'N'           DDFCUSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFCUS'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0505'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           DDFCUSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFCUS'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0506'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   LEAVE
      *
     C                   ENDIF
      *
     C     SkipVal       TAG                                                               AR1094066
      *                                                                                    AR1094066
     C                   MOVE      'B'           WFRCTP
     C     WKFAC         CHAIN(N)  FCLTY                              99
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           DDFCUSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFCUS'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0134'     MsgIDXAr(Idx)
     C                   LEAVE
     C                   ENDIF
      *
      ***  Skip this validation if fclty has been reactivated.
      *
     C     *IN99         IFEQ      '0'
     C     RECIF         ANDNE     'D'
     C     DDACTN        ANDEQ     'I'
     C     WREAC         ANDEQ     *OFF
     C     *IN99         OREQ      '0'
     C     RECIF         ANDNE     'D'
     C     DDACTN        ANDEQ     'A'
     C     WREAC         ANDEQ     *OFF
      *
     C                   MOVEL     DDLTYP        LTYP1                                      AR763386
      *                                                                                     AR763386
     C     RECIF         IFEQ      'E'
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     DDMDAT        ANDEQ     *BLANKS
     C*****LTYP1         ANDNE     'X'                                            AR763386 AR1094066
     C*****LTYP1         ANDNE     'Y'                                            AR763386 AR1094066
     C*****LTYP1         ANDNE     'Z'                                            AR763386 AR1094066
      *                                                                                    AR1094066
     C                   IF        CLE134 = 'Y'                                            AR1094066
      *                                                                                    AR1094066
     C                   CALL      'AOLOANR0'                                              AR1094066
     C                   PARM      *BLANKS       @RTCD                                     AR1094066
     C                   PARM      '*KEY   '     @OPTN                                     AR1094066
     C                   PARM                    DDLTYP                                    AR1094066
     C                   PARM                    DDSUTP                                    AR1094066
     C                   PARM                    DDCLAS                                    AR1094066
     C     SDLOAN        PARM      SDLOAN        DSSDY                                     AR1094066
      *                                                                                    AR1094066
     C                   IF        (LTYP1 = 'X' OR LTYP1 = 'Y' OR LTYP1 = 'Z')             AR1094066
     C                   IF        (AYFAMU <> 'Y')                                         AR1094066
     C                   GOTO      SkipValX                                                AR1094066
     C                   ENDIF                                                             AR1094066
     C                   ENDIF                                                             AR1094066
     C                   ENDIF                                                             AR1094066
      *                                                                                    AR1094066
     C                   MOVE      'N'           DDFCUSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFCUS'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0505'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'N'           DDFCUSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFCUS'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0506'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   LEAVE
      *
     C                   ENDIF
     C     SkipValX      TAG                                                               AR1094066
      *
      ***  Must not use Credit Agreements
      *
     C     DDFCUSOK      IFNE      'N'
     C     TRCA          ANDEQ     'CA'
     C                   MOVE      'N'           DDFCUSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFCUS'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0497'     MsgIDXAr(Idx)
     C                   LEAVE
     C                   ENDIF
      *
     C     ddFCUSOK      IFNE      'N'
     C                   MOVE      PRTR          WCPRTR
     C                   MOVE      ANUM          WAGENT
     C**********         Z-ADD     PMFC          WCPMFC                                       CSD027
     C                   EVAL      WCPMFC = PMFC                                              CSD027
     C                   Z-ADD     PMFT          WCPMFT
     C**********         Z-ADD     PMFN          WCPMFC                                      BUG7009
     C                   Z-ADD     PMFN          WCPMFN                                      BUG7009
      *
      ***  Save Permitted currencies against the multi-currency facility
      *
     C     CSEL          IFEQ      'Y'
     C                   MOVEA     ALCY          WCY
     C                   ENDIF
      *
     C                   ENDIF
      *
      ***  If facility is not in error, for non-multi-customer facility,
      ***  loan customer must equal facility customer
      *
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDBRCA        @BRCD
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C                   MOVEL     A8SYCU        W#SYCU            6
      *
     C                   MOVEL     DDCUST        WWCUST            6

     C     DDFCUSOK      IFNE      'N'
     C     *IN83         ANDEQ     '0'
     C     MCSIF         ANDNE     'Y'
     C     DDFCUS        ANDNE     WWCUST
     C     DDRCSI        ANDEQ     'Y'
     C*****SYINF         IFNE      'Y'                                                        256611
     C*****SYINF         OREQ      'Y'                                                        256611
     C     SYINF         IFEQ      'Y'                                                        256611
     C     WAGENT        ANDNE     W#SYCU
     C                   MOVE      'N'           DDFCUSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFCUS'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0135'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C     DDFCUSOK      IFNE      'N'
     C     *IN82         ANDEQ     '1'
     C     MCSIF         ANDNE     'Y'
     C     DDFCUS        ANDNE     WWCUST
     C     DDRCSI        ANDNE     'Y'
     C*****SYINF         IFNE      'Y'                                                        256611
     C*****SYINF         OREQ      'Y'                                                        256611
     C     SYINF         IFEQ      'Y'                                                        256611
     C     WAGENT        ANDNE     W#SYCU
     C                   MOVE      'N'           DDFCUSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFCUS'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0136'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      *
     C                   ENDDO
     C                   ENDIF
      *
     C     DDFCUSOK      IFNE      'N'
     C     DDFTYPOK      ANDNE     'N'
     C     DDFSEQOK      ANDNE     'N'
     C                   MOVE      DDFCUS        CCLFCUS
     C                   MOVE      DDFTYP        CCLFTYP
     C                   MOVE      DDFSEQ        CCLFSEQ
     C                   MOVEL     FCCYF         CCLFCCY
     C***********        MOVEL     BRCAF         CCLBRCA                                      225363
     C                   MOVEL     BRCAF         CCLFCLB                                      225363
     C*                                                                                       240510
     C                   IF        W#PDCL = 'N'                                            MD021823A
     C                   EXSR      SRRELI                                                     240510
     C                   ENDIF                                                             MD021823A
     C*                                                                                       240510
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *  SRBRCA - Validate branch code                                *
      *****************************************************************
     C     SRBRCA        BEGSR
      *******************                                                       BUG2319
      *****If*branch*is*blank, set to default branch                            BUG2319
      *******************                                                       BUG2319
     C*****DDBRCA********IFEQ      *BLANKS                                      BUG2319
     C*****RespMode******ANDEQ     'S'                                          BUG2319
     C*******************MOVE      DBRN          DDBRCA                         BUG2319
     C*******************ENDIF                                                  BUG2319
      *******************                                                       BUG2319
     C*****BGMBIN********IFEQ      'Y'                                          BUG2319
      *
      ***  If branch not entered and facility multi-branch indicator
      ***  is 'N', use facility branch as default
      *
     C     DDBRCA        IFEQ      *BLANKS
     C     MBFC          ANDNE     'Y'
     C     DDFCUSOK      ANDNE     'N'
     C     *IN83         ANDEQ     '0'
     C     BGMBIN        ANDEQ     'Y'                                          BUG2319
     C                   MOVE      BRCAF         DDBRCA
     C                   ENDIF
      *                                                                         BUG2319
      ***  If branch is blank, set to default branch                            BUG2319
      *                                                                         BUG2319
     C     DDBRCA        IFEQ      *BLANKS                                      BUG2319
     C     RespMode      ANDEQ     'S'                                          BUG2319
     C                   MOVE      DBRN          DDBRCA                         BUG2319
     C                   ENDIF                                                  BUG2319
      *
     C     BGMBIN        IFEQ      'Y'                                          BUG2319
     C     DDACTN        IFEQ      'I'
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDBRCA        @BRCD             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDBRCAOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBRCA'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0103'     MsgIDXAr(Idx)
     C                   MOVE      *BLANKS       WLCCD             3
     C     @RTCD         IFEQ      '*NOSEL  '
     C                   MOVE      *BLANKS       DDBRCA
     C                   ENDIF
     C                   ELSE
     C                   MOVE      A8LCCD        WLCCD
     C                   MOVE      A8BRCD        DDBRCA
      *
      ***  Branch (input or default)/action must be valid for user
      *
     C     RespMode      IFNE      'S'
     C                   CALL      'ZBACTBU'
     C                   PARM      DDACTN        @ZACTN
     C                   PARM      A8BRCD        @ZBR
     C                   PARM                    @@USER
     C**********         PARM                    @ZMGRP            4 0                        CSF002
     C**********         PARM                    @ZICDE            4                          CSF002
     C                   PARM                    @UNQCDE          10                          CSF002
     C                   PARM                    @ERR
     C                   ELSE
     C                   CALL      'ZVACTBU'
     C                   PARM      DDACTN        @ZACTN            1
     C                   PARM      A8BRCD        @ZBR              3
     C                   PARM                    @ERR              1 0
      *
     C     @ERR          IFEQ      1
     C                   MOVE      'N'           DDBRCAOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBRCA'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0303'     MsgIDXAr(Idx)
     C                   ENDIF
     C     @ERR          IFEQ      2
     C                   MOVE      'N'           DDBRCAOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBRCA'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0304'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  If facility multi-branch is 'N', branch must be the same
      ***  as the facility branch
      *
     C     *IN83         IFEQ      '0'
     C     DDFCUSOK      ANDNE     'N'
     C     DDBRCAOK      ANDNE     'N'
     C     MBFC          ANDNE     'Y'
     C     DDBRCA        ANDNE     BRCAF
     C                   MOVE      'N'           DDBRCAOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBRCA'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0032'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     DDBRCAOK      IFNE      'N'
     C                   MOVEL     DDBRCA        CCLBRCA
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CLE042
      *****************************************************************                       CLE042
      * Default Sub Type and Class                                                            CLE042
      *****************************************************************                       CLE042
     C     DSUBTCLAS     BEGSR                                                                CLE042
      *                                                                                       CLE042
     C                   CALL      'LE002000'                                                 CLE042
      * Inputs                                                                                CLE042
     C                   PARM                    DDACTN                                       CLE042
     C                   PARM                    DDLNRF                                       CLE042
     C                   PARM                    DDCUST                                       CLE042
     C                   PARM                    DDVDAT                                       CLE042
     C                   PARM                    DDMDAT                                       CLE042
     C                   PARM                    DDBOKC                                       CLE042
     C                   PARM                    DDPRFC                                       CLE042
     C                   PARM                    DDCURR                                       CLE042
     C                   PARM                    FCCYF                                        CLE042
     C                   PARM                    DDOLNO                                       CLE042
      * Inputs/Outputs                                                                        CLE042
     C                   PARM                    DDLTYP                                       CLE042
     C                   PARM                    DDSUTP                                       CLE042
      *                                                                                       CLE042
     C                   ENDSR                                                                CLE042
      *****************************************************************                       CLE042
     C/EJECT
      *****************************************************************
      *  SRLNTS - Validate loan type/subtype                          *
      *****************************************************************
     C     SRLNTS        BEGSR
      *
     C                   MOVE      DDLTYP        @LNTY             2
     C                   MOVE      DDSUTP        @LNST             2
     C                   MOVE      DDCLAS        @LNCL             4                          CLE042
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @LNTY
     C                   PARM                    @LNST
     C                   PARM                    @LNCL                                        CLE042
     C     SDLOAN        PARM      SDLOAN        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDLTYPOK
     C                   MOVE      'N'           DDSUTPOK
     C                   MOVE      'N'           DDCLASOK                                     CLE042
     C                   ADD       1             Idx
     C                   MOVEL     'DDLTYP'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0101'     MsgIDXAr(Idx)
     C     @RTCD         IFEQ      '*NOSEL  '
     C                   MOVE      *BLANKS       DDLTYP
     C                   MOVE      *BLANKS       DDSUTP
     C                   MOVE      *BLANKS       DDCLAS                                       CLE042
     C                   ENDIF
      *
      ***  Processing type retrieved must be valid for the type of
      ***  transaction entered
      *
     C                   ELSE
     C                   MOVE      AYLNTY        DDLTYP
     C                   MOVE      AYLNST        DDSUTP
     C                   MOVE      AYLNCL        DDCLAS                                       CLE042
     C                   Z-ADD     AYLNPT        WLNPT             2 0
     C                   MOVE      AYRANG        PRANG             2
     C                   SELECT
      *
      ***  For parts purchased, valid are 64, 65; morevoer if CLE005
      ***  is installed, 68 and 71 are also valid
      *
     C     *IN82         WHENEQ    '1'
     C     WLNPT         IFNE      64
     C     WLNPT         ANDNE     65
     C     WLNPT         ANDNE     68
     C     WLNPT         ANDNE     71
     C     WLNPT         OREQ      68
     C     CLE005        ANDEQ     'N'
     C     WLNPT         OREQ      71
     C     CLE005        ANDEQ     'N'
     C                   MOVE      'N'           DDLTYPOK
     C                   MOVE      'N'           DDSUTPOK
     C                   MOVE      'N'           DDCLASOK                                     CLE042
     C                   ENDIF
     C     *IN83         WHENEQ    '1'
      *
      ** For parts sold, valid are 66, 67;  moreover if CLE005
      ** is installed, 69 and 72 are also valid
      *
     C     WLNPT         IFNE      66
     C     WLNPT         ANDNE     67
     C     WLNPT         ANDNE     69
     C     WLNPT         ANDNE     72
     C     WLNPT         OREQ      69
     C     CLE005        ANDEQ     'N'
     C     WLNPT         OREQ      72
     C     CLE005        ANDEQ     'N'
     C                   MOVE      'N'           DDLTYPOK
     C                   MOVE      'N'           DDSUTPOK
     C                   MOVE      'N'           DDCLASOK                                     CLE042
     C                   ENDIF
     C                   OTHER
     C     WLNPT         IFNE      61
     C     WLNPT         ANDNE     62
     C     WLNPT         ANDNE     63
     C     WLNPT         ANDNE     70
     C     CLE028        ANDEQ     'N'                                                       BUG3721
                                                                                             BUG3721
     C     CLE028        OREQ      'Y'                                                       BUG3721
     C     WLNPT         ANDNE     61                                                        BUG3721
     C     WLNPT         ANDNE     62                                                        BUG3721
     C     WLNPT         ANDNE     63                                                        BUG3721
     C     WLNPT         ANDNE     70                                                        BUG3721
     C     WLNPT         ANDNE     80                                                        BUG3721
                                                                                             BUG3721
     C                   MOVE      'N'           DDLTYPOK
     C                   MOVE      'N'           DDSUTPOK
     C                   MOVE      'N'           DDCLASOK                                     CLE042
     C                   ENDIF
     C                   ENDSL
      *
     C     DDLTYPOK      IFEQ      'N'
     C                   ADD       1             Idx
     C                   MOVEL     'DDLTYP'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0102'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ***  If not a parts sold
      ***  Determine if loan type is allowed on facility
      *
     C     *IN83         IFEQ      '0'

     C                   MOVEA     *BLANKS       DRAW
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C                   MOVEA     DTPX          DRAW                                        BUG3721
     C                   ELSE                                                                BUG3721
     C                   MOVEA     DTPS          DRAW
     C                   ENDIF                                                               BUG3721
     C                   Z-ADD     1             W#NO              1 0
     C                   MOVE      'N'           W#FLAG            1
     C                   MOVE      WLNPT         W#LNPT            2
      *
     C*****W#NO*         DOWLE     5                                                         BUG3721
     C     W#NO          DOWLE     6                                                         BUG3721
     C     W#FLAG        ANDEQ     'N'
      *
     C                   MOVE      *BLANKS       W#LOK             3
     C     DRAW(W#NO)    CAT       W#LNPT        W#LOK
     C     W#LOK         LOOKUP    WDRPT                                  97
      *
     C     *IN97         IFEQ      '1'
     C                   MOVE      'Y'           W#FLAG
     C                   ENDIF
      *
     C                   ADD       1             W#NO
      *
     C                   ENDDO
      *
      ***  Generate Message if Loan type is restricted on facility
      *
     C     W#FLAG        IFEQ      'N'
     C     DTPS          ANDNE     *BLANKS
     C     CLE028        ANDEQ     'N'                                                       BUG3721
                                                                                             BUG3721
     C     W#FLAG        OREQ      'N'                                                       BUG3721
     C     DTPX          ANDNE     *BLANKS                                                   BUG3721
     C     CLE028        ANDEQ     'Y'                                                       BUG3721
                                                                                             BUG3721
     C                   MOVE      'N'           DDLTYPOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDLTYP'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0498'     MsgIDXAr(Idx)
     C                   ENDIF

     C                   ENDIF
      *
      **  For insert, Loan Type must not begin with X, Y or Z.                                263288
      *                                                                                       263288
     C     DDACTN        IFEQ      'I'                                                        263288
     C     CLE134        ANDEQ     'Y'                                                        263288
     C     W#PDCL        ANDEQ     'N'                                                        CLE134
     C                   MOVEL     DDLTYP        LTYP1             1                          263288
     C     LTYP1         IFEQ      'X'                                                        263288
     C     LTYP1         OREQ      'Y'                                                        263288
     C     LTYP1         OREQ      'Z'                                                        263288
     C                   MOVE      'N'           DDLTYPOK                                     263288
     C                   ADD       1             Idx                                          263288
     C                   MOVEL     'DDLTYP'      FldNamXAr(Idx)                               263288
     C                   MOVEL     '5045559'     MsgIDXAr(Idx)                                263288
     C                   ENDIF                                                                263288
     C                   ENDIF                                                                263288
      *                                                                                       263288
      ** PDCL validation of loan type subtype                                               MD020722
      *                                                                                     MD020722
     C                   IF        CLE134 = 'Y'                                             MD020722
     C                   EVAL      LTYP1 = DDLTYP                                           MD020722
      *                                                                                     MD020722
     C                   IF        DDORLN <> *BLANKS                                        MD020722
      *                                                                                     MD020722
     C                   IF        LTYP1 <> 'X'  AND                                        MD020722
     C                             LTYP1 <> 'Y'                                             MD020722
     C                   MOVE      'N'           DDLTYPOK                                   MD020722
     C                   ADD       1             Idx                                        MD020722
     C                   MOVEL     'DDLTYP'      FldNamXAr(Idx)                             MD020722
     C                   MOVEL     '5045928'     MsgIDXAr(Idx)                              MD020722
     C                   ENDIF                                                              MD020722
      *                                                                                     MD020722
     C**********         ELSEIF    DDOFCU <> *BLANKS  OR                           MD020722 MD023789
     C**********                   DDOFAC <> *BLANKS  OR                           MD020722 MD023789
     C**********                   DDOFES <> *BLANKS  OR                           MD020722 MD023789
     C**********                   DDOFSQ <> *BLANKS  OR                           MD020722 MD023789
     C**********                   DDOFLN <> *BLANKS                               MD020722 MD023789
     C                   ELSEIF    (DDOFCU <> *BLANKS  AND                                  MD023789
     C                              DDOFAC <> *BLANKS  AND                                  MD023789
     C                              DDOFES <> *BLANKS  AND                                  MD023789
     C                              DDOFSQ <> *BLANKS) OR                                   MD023789
     C                             (DDOFES <> *BLANKS AND                                   MD023789
     C                              DDOFSQ <> *BLANKS AND                                   MD023789
     C                              DDOFLN <> *BLANKS)                                      MD023789
      *                                                                                     MD020722
     C                   IF        LTYP1 <> 'Z'                                             MD020722
     C                   MOVE      'N'           DDLTYPOK                                   MD020722
     C                   ADD       1             Idx                                        MD020722
     C                   MOVEL     'DDLTYP'      FldNamXAr(Idx)                             MD020722
     C                   MOVEL     '5045929'     MsgIDXAr(Idx)                              MD020722
     C                   ENDIF                                                              MD020722
     C                                                                                      MD020722
     C                   ENDIF                                                              MD020722
      *                                                                                     MD020722
     C                   ENDIF                                                              MD020722
      *                                                                                     MD020722
     C     DDLTYPOK      IFNE      'N'
     C     DDSUTPOK      ANDNE     'N'
     C     DDCLASOK      ANDNE     'N'                                                        CLE042
     C                   MOVEL     DDLTYP        CCLLTYP
     C                   MOVEL     DDSUTP        CCLSUTP
     C                   MOVEL     DDCLAS        CCLCLAS                                      CLE042
     C                   Z-ADD     AYLNPT        CCLPTYP
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRPFRM - Validate purchased from (for parts purchased)       *
      *****************************************************************
     C     SRPFRM        BEGSR
      *
     C     *IN82         IFEQ      '1'
     C     DDPFRM        IFEQ      *BLANKS
     C                   MOVE      'N'           DDPFRMOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPFRM'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0179'     MsgIDXAr(Idx)
      *
      ***  Must be a valid customer
      *
     C                   ELSE
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM      DDPFRM        @CUST
     C                   PARM      *BLANKS       @KEYSTS
     C     SDCUST        PARM      SDCUST        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDPFRMOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPFRM'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0034'     MsgIDXAr(Idx)
     C     @RTCD         IFEQ      '*NOSEL  '
     C                   MOVE      *BLANKS       DDPFRM
     C                   ENDIF
      *
      ***  Must not be a parent
      *
     C                   ELSE
     C                   MOVE      *BLANKS       DDPFRM
     C                   MOVE      BBCUST        DDPFRM
     C                   MOVE      BBCUST        WSVCN
     C     BBPAIN        IFEQ      'P'
     C                   MOVE      'N'           DDPFRMOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPFRM'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0036'     MsgIDXAr(Idx)
     C                   ELSE                                                                 256611
      *                                                                                       256611
      ** Purchased from should be equal to the facility customer when                         256611
      ** facility is not designated as muti-customer.                                         256611
      *                                                                                       256611
     C                   IF        %Trim(DDPFRM) <> DDFCUS and                                256611
     C                                   DDCUST  <> DDFCUS and                                256611
     C                                   MCSIF   <> 'Y'    and                                256611
     C                                   SYINF   <> 'Y'                                       256611
     C                   MOVE      'N'           DDPFRMOK                                     256611
     C                   ADD       1             Idx                                          256611
     C                   MOVEL     'DDPFRM'      FldNamXAr(Idx)                               256611
     C                   MOVEL     'LEL0180'     MsgIDXAr(Idx)                                256611
     C                   ENDIF                                                                256611
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C     DDPFRMOK      IFNE      'N'
     C                   MOVE      DDPFRM        CCLCNUM
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRMLNR - Validate mirror loan number (for parts purchased)   *
      *****************************************************************
     C     SRMLNR        BEGSR
      *
     C                   MOVE      *BLANK        MCRAM                                        241204
     C     *IN82         IFEQ      '1'
     C     DDFCUSOK      ANDNE     'N'
     C     DDMLNR        IFNE      *BLANK
     C     DDMLNR        ANDNE     '000000'
      *
      ***  Must be blank for non-syndicated or non-agent facilities
      *
     C     SYINF         IFNE      'Y'
     C     SYINF         OREQ      'Y'
     C     WCPRTR        ANDNE     'A'
     C                   MOVE      'N'           DDMLNROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMLNR'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0093'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  Must exist in the system as live
      *
     C     DDMLNROK      IFNE      'N'
     C                   MOVE      DDMLNR        WALON
     C                   MOVE      'A'           WEPAR
     C     WKLON         CHAIN(N)  CLOAN                              99
     C     *IN99         IFEQ      '0'
     C     RECI          ANDNE     'D'
     C     RespMode      ANDEQ     'S'
     C     *IN99         OREQ      '1'
     C                   MOVE      'N'           DDMLNROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMLNR'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0095'     MsgIDXAr(Idx)
      *                                                                                       241204
      **      Save MCRA of mirror loan number for later validation                            241204
      *                                                                                       241204
     C                   ELSE                                                                 241204
     C                   MOVE      MCRA          MCRAM                                        241204
     C                   ENDIF
     C                   ENDIF
      *
      ***  With facility similar as the loan being entered
      *
     C     DDMLNROK      IFNE      'N'
     C     WFCNUM        IFNE      FCUS
     C     WFFACT        ORNE      FTYP
     C     WFFCNO        ORNE      FSEQ
     C                   MOVE      'N'           DDMLNROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMLNR'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0096'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ***  Mandatory for agent facilities
      *
     C                   ELSE
     C     SYINF         IFEQ      'Y'
     C     WCPRTR        ANDEQ     'A'
     C                   MOVE      'N'           DDMLNROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMLNR'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0094'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE                                                                 CLE106
                                                                                              CLE106
      ** Mirror Loan Number must not be entered if loan is not Internal Parts Purchased       CLE106
                                                                                              CLE106
     C                   IF        *IN82 = *OFF And DDMLNR <> *Blanks                         CLE106
     C                   EVAL      DDMLNROK = 'N'                                             CLE106
     C                   EVAL      Idx = Idx + 1                                              CLE106
     C                   EVAL      FldNamXAr(Idx) = 'DDMLNR'                                  CLE106
     C                   EVAL      MsgIDXAr(Idx) = 'LEL0427'                                  CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF
      *
     C     DDMLNROK      IFNE      'N'
     C                   MOVE      DDMLNR        CCLMLNR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SROLNO - Validate sale of loan number (for parts sold)       *
      *****************************************************************
     C     SROLNO        BEGSR
      *
      ***  If Parts sold is being reversed along with Parts purchased
      ***  and originating loan bypass validation for batch mode.
      *
     C     RespMode      IFNE      'S'
     C     DDACTN        ANDEQ     'R'
     C     W#SEQ         ANDEQ     1
     C     RespMode      OREQ      'S'
     C     RespMode      ORNE      'S'
     C     DDACTN        ANDNE     'R'
     C     W#PCOB        ANDNE     *BLANKS
     C     RespMode      ORNE      'S'
     C     W#PCOB        ANDEQ     *BLANKS
      *
B002 C     *IN83         IFEQ      '1'
      *
B003 C     DDOLNO        IFEQ      *BLANKS
     C                   MOVE      'N'           DDOLNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDOLNO'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0123'     MsgIDXAr(Idx)
X003 C                   ELSE
      *
      ***  Must be a valid loan processing type
      *
     C                   MOVE      DDOLNO        WALON
     C                   MOVE      'A'           WEPAR
     C     WKLON         CHAIN(N)  CLOAN                              99
B004 C     *IN99         IFEQ      '0'
     C     RECI          ANDNE     'D'
     C                   MOVE      '1'           *IN99
E004 C                   ENDIF
B004 C     *IN99         IFEQ      '1'
     C     DDACTN        ANDEQ     'A'
     C     RECI          ANDNE     'M'
     C                   MOVE      '1'           *IN99
E004 C                   ENDIF
      *
      ***  Loans must be of processing types 62,63,64,65 to be
      ***  sold; moreover if CLE005 is installed, those with processing
      ***  types 61, 68, 70 and 71 are also accepted
      *
B004 C     *IN99         IFEQ      '1'
     C     *IN99         OREQ      '0'
     C     PTYP          ANDNE     62
     C     PTYP          ANDNE     63
     C     PTYP          ANDNE     64
     C     PTYP          ANDNE     65
     C     PTYP          ANDNE     61
     C     PTYP          ANDNE     68
     C     PTYP          ANDNE     70
     C     PTYP          ANDNE     71
     C                   MOVE      'N'           DDOLNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDOLNO'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0122'     MsgIDXAr(Idx)
E004 C                   ENDIF
      *
B004 C     DDOLNOOK      IFNE      'N'
     C     CLE005        ANDEQ     'N'
B005 C     PTYP          IFEQ      61
     C     PTYP          OREQ      68
     C     PTYP          OREQ      70
     C     PTYP          OREQ      71
     C                   MOVE      'N'           DDOLNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDOLNO'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0122'     MsgIDXAr(Idx)
E005 C                   ENDIF
E004 C                   ENDIF
      *
      ***  Save sale of loan facility details
      *
     C                   MOVE      FCUS          S#FCUS
     C                   MOVE      FTYP          S#FTYP
     C                   MOVE      FSEQ          S#FSEQ
     C                   Z-ADD     ICBS          S#ICBS            1 0
     C                   Z-ADD     PTYP          WPTYP             2 0
E003 C                   ENDIF
      *
      ***  Parts sold must be 67 if related loan is 63 or 65
      ***  otherwise, must be 66
      ***  If CLE005 is installed, parts sold 69 is allowed for related
      ***  loans 61 or 68; parts sold 72 is allowed for related loans
      ***  of any type (excluding of course a parts sold)
      *
B003 C     DDLTYPOK      IFNE      'N'
     C     DDOLNOOK      ANDNE     'N'
B004 C     PTYP          IFEQ      63
     C     PTYP          OREQ      65
B005 C     WLNPT         IFNE      67
     C     WLNPT         ANDNE     72
     C                   MOVE      'N'           DDOLNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDOLNO'      FldNamXAr(Idx)
     C**********         MOVEL     'LEL0006'     MsgIDXAr(Idx)                                245217
     C                   MOVEL     'LEL0810'     MsgIDXAr(Idx)                                245217
E005 C                   ENDIF
E004 C                   ENDIF
      *
B004 C     PTYP          IFEQ      62
     C     PTYP          OREQ      64
B005 C     WLNPT         IFNE      66
     C     WLNPT         ANDNE     72
     C                   MOVE      'N'           DDOLNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDOLNO'      FldNamXAr(Idx)
     C**********         MOVEL     'LEL0006'     MsgIDXAr(Idx)                                245217
     C                   MOVEL     'LEL0807'     MsgIDXAr(Idx)                                245217
E005 C                   ENDIF
E004 C                   ENDIF
      *
B004 C     PTYP          IFEQ      61
     C     PTYP          OREQ      68
B005 C     WLNPT         IFNE      69
     C     WLNPT         ANDNE     72
     C                   MOVE      'N'           DDOLNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDOLNO'      FldNamXAr(Idx)
     C**********         MOVEL     'LEL0006'     MsgIDXAr(Idx)                                245217
     C                   MOVEL     'LEL0808'     MsgIDXAr(Idx)                                245217
E005 C                   ENDIF
E004 C                   ENDIF
      *
B004 C     PTYP          IFEQ      70
     C     PTYP          OREQ      71
B005 C     WLNPT         IFNE      72
     C                   MOVE      'N'           DDOLNOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDOLNO'      FldNamXAr(Idx)
     C**********         MOVEL     'LEL0006'     MsgIDXAr(Idx)                                245217
     C                   MOVEL     'LEL0809'     MsgIDXAr(Idx)                                245217
E005 C                   ENDIF
E004 C                   ENDIF
      *
      ***  Funding participant details should also be made available
      ***  for participation sold in term and call loans
      ***  Also, determine what processing type 72 is to be like
      *
B004 C     CLE005        IFEQ      'Y'
     C     WLNPT         ANDEQ     72
B005 C                   SELECT
     C     PTYP          WHENEQ    62
     C     PTYP          OREQ      64
     C                   MOVE      '66'          W72TP             2
     C     PTYP          WHENEQ    61
     C     PTYP          OREQ      68
     C                   MOVE      '69'          W72TP
     C     PTYP          WHENEQ    63
     C     PTYP          OREQ      65
     C                   MOVE      '67'          W72TP
     C     PTYP          WHENEQ    70
     C     PTYP          OREQ      71
     C                   MOVE      '70'          W72TP
E005 C                   ENDSL
E004 C                   ENDIF
      *
E003 C                   ENDIF
      *
E002 C                   ENDIF
      *
      ** Need to save multi ccy rollover allowed indicator if
      ** internal parts purchased
      *
B001 C     *IN82         IFEQ      '1'
     C     DDMLNROK      ANDNE     'N'
     C                   MOVE      MCRA          MCRAM             1
E001 C                   ENDIF
      *
B001 C     *IN83         IFEQ      '1'
      *
      ***  Save fields of related reference for later validation
      *
B002 C     DDOLNOOK      IFNE      'N'
     C                   MOVE      CNUM          CNUMM             6
     C                   MOVE      BRCA          BRCAM             3
     C                   MOVE      CCY           CCYM              3
     C                   Z-ADD     CPAM          CPAMM            13 0
     C                   Z-ADD     DDAT          DDATM             5 0
     C                   Z-ADD     VDAT          VDATM             5 0
     C                   Z-ADD     MDAT          MDATM             5 0
     C                   Z-ADD     PSAM          PSAMM            13 0
      *
     C                   Z-ADD     FCXR          WSVFX            13 8
     C**********         Z-ADD     FCUS          FCUSM             6 0                        CSD027
     C                   MOVE      FCUS          FCUSM             6                          CSD027
     C                   Z-ADD     FTYP          FTYPM             3 0
     C                   Z-ADD     FSEQ          FSEQM             2 0
     C                   Z-ADD     FCXR          FCXRM            13 8
     C                   Z-ADD     NMDT          NMDTM             5 0                        237744
     C                   MOVE      FMDI          FMDIM             1
     C                   MOVE      ORBR          ORBRM             3
     C                   MOVE      CRSK          CRSKM             2
     C**********         MOVE      LIND          LINDM             3                          CER020
     C                   MOVE      LOIC          LOICM             3                          CER020
     C                   MOVE      PRFC          PRFCM             4
     C                   MOVE      ACOF          ACOFM             2
     C                   MOVE      FCCY          FCCYM             3
     C                   MOVE      FCLB          FCLBM             3
     C                   MOVE      MCRA          MCRAM             1
     C                   MOVE      PTYP          PTYPM             2 0

     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      FCCY          @CYCD
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   Z-ADD     1             DBASE                          * DBERR 002 *
     C                   MOVEL     FCCY          DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
E004 C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        WCDPF             1 0
      *
      ***  Save multi-ccy rollover details for later validation
      *
     C                   Z-ADD     RLDT          RLDTM             5 0
B003 C     CLE006        IFEQ      'Y'
     C                   MOVE      DDOLNO        WALON
     C                   MOVE      'B'           WEPAR
     C     WKLON         CHAIN(N)  CLOAN                              99
B004 C     *IN99         IFEQ      '0'
     C                   Z-ADD     NBRA          NBRAM             2 0
     C                   Z-ADD     NCAS          NCASM             1 0
     C                   MOVE      NCHI          NCHIM             1
     C                   MOVE      NCCY          NCCYM             3
     C                   Z-ADD     NFCE          NFCEM            13 8
     C                   MOVE      NFMD          NFMDM             1
     C                   Z-ADD     NBCE          NBCEM            13 8
     C                   MOVE      NBMD          NBMDM             1
     C     NCCYM         IFNE      *BLANK
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      NCCYM         @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   Z-ADD     1             DBASE                          * DBERR 001 *
     C                   MOVEL     NCCYM         DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
E004 C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        NBDPM             1 0
E004 C                   ENDIF
E004 C                   ENDIF
E003 C                   ENDIF
      *
E002 C                   ENDIF
      *
E001 C                   ENDIF
      *
B002 C     DDOLNOOK      IFNE      'N'
B002 C     *IN83         ANDEQ     '1'
E001 C                   MOVE      DDOLNO        CCLOLNO
E001 C                   ENDIF
      *
E001 C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCURR  -  Validate the currency                             *
      *****************************************************************
     C     SRCURR        BEGSR
      *
      ***  Validations relating to facility will be ignored for
      ***  parts sold as it does not have this field
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCURR        @CYCD
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDCURROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCURR'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0066'     MsgIDXAr(Idx)
     C     @RTCD         IFEQ      '*NOSEL  '
     C                   MOVE      *BLANKS       DDCURR
     C                   ENDIF
      *
      ***  Must be a dealing currency
      *
     C                   ELSE
     C                   MOVE      A6CYCD        DDCURR
     C     A6DLCI        IFNE      'Y'
     C                   MOVE      'N'           DDCURROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCURR'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0109'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      A6INCY        WINFL             1
      *                                                                                     MD020859
      ** PDCL validation of CCY and OL CCY                                                  MD020859
      *                                                                                     MD020859
     C                   IF        CLE134 = 'Y'                                             MD020859
     C                             AND DDORLN <> *BLANKS                                    MD020859
                                                                                            MD020859
     C                   EVAL      LTYP1 = DDLTYP                                           MD020859
     C                   MOVE      DDORLN        WALON                                      MD020859
     C                   MOVE      'A'           WEPAR                                      MD020859
                                                                                            MD020859
     C     WKLON         CHAIN (N) CLOAN                              87                    MD020859
      *                                                                                     MD020859
     C                   IF        *IN87 = '0'                                              MD020859
     C                             AND LTYP1 <> 'X'                                         MD020859
     C                             AND CCY <> DDCURR                                        MD020859
     C                             OR *IN87 = '0'                                           MD020859
     C                             AND LTYP1 <> 'Y'                                         MD020859
     C                             AND CCY <> DDCURR                                        MD020859
                                                                                            MD020859
     C                   MOVE      'N'           DDCURROK                                   MD020859
     C                   ADD       1             Idx                                        MD020859
     C                   MOVEL     'DDCURR'      FldNamXAr(Idx)                             MD020859
     C                   MOVEL     '5045941'     MsgIDXAr(Idx)                              MD020859
                                                                                            MD020859
     C                   ENDIF                                                              MD020859
     C                   ENDIF                                                              MD020859
      *
      ***  If not a multi-currency facility, currency must equal
      ***  the facility currency
      *
     C     *IN83         IFEQ      '0'
     C     DDFCUSOK      ANDNE     'N'
     C     DDCURROK      ANDNE     'N'
     C     MCCYF         IFNE      'Y'
     C     DDCURR        ANDNE     FCCYF
     C                   MOVE      'N'           DDCURROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCURR'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0110'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ***  If multi-currency and currency select indicators or on check
      ***  the currency entered is one of the permitted currencies on
      ***  the facility.
      *
      ***  Do not check when a parts sold is entered
      *
     C     DDCURROK      IFNE      'N'
     C     *IN83         ANDEQ     '0'
     C     MCCYF         ANDEQ     'Y'
     C     CSEL          ANDEQ     'Y'
     C     DDCURR        ANDNE     FCCYF
     C                   Z-ADD     0             X1                2 0
      *
     C                   DO        9
     C     DDCURR        LOOKUP    WCY                                    38
     C                   ENDDO
      *
      ** Put out warning message not error message if facility                                CLE030
      ** is multi-ccy and the transaction ccy is not included                                 CLE030
      ** on the list of valid currencies. Also set loan status                                CLE030
      ** (CCLLSTS) on valid file data structure to 'Requires Release'.                        CLE030
      ** Only if CLE030 is on.                                                                CLE030
      *                                                                                       CLE030
     C     *IN38         IFEQ      *OFF
     C     CLE030        IFEQ      'N'
     C                   MOVE      'N'           DDCURROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCURR'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0174'     MsgIDXAr(Idx)
     C                   ELSE                                                                 CLE030
     C*****DDCURR        IFNE      W1DCURR                                            CLE030 BUG4351
     C**********         MOVE      DDCURR        W1DCURR           3                  CLE030 BUG4351
     C                   MOVE      'W'           DDCURROK
     C                   ADD       1             WId                                          CLE030
     C                   MOVEL     'DDCURR'      WFldNmXAr(WId)                               CLE030
     C                   MOVEL     'LEL0113'     WMsgIDXAr(WId)                               CLE030
     C**********         ENDIF                                                        CLE030 BUG4351
     C                   EVAL      CCLLSTS = 'Q'                                              CLE030
     C                   ENDIF                                                                CLE030
     C                   ENDIF
      *                                                                                       CLE030
      * If there is a credit agreement, then if the currency is not on the                    CLE030
      * list of allowable currencies for this then we need to send a                          CLE030
      * warning message                                                                       CLE030
      *                                                                                       CLE030
     C*****CANM          IFNE      *ZEROS                                              CLE030 CSD027
     C     CANM          IFNE      *BLANKS                                                    CSD027
     C     CAFT          ANDNE     *ZEROS                                                     CLE030
     C     CAFN          ANDNE     *ZEROS                                                     CLE030
     C     TRCA          ANDEQ     'TR'                                                       CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *                                                                                       CLE030
      * Save the values of the current facility stored                                        CLE030
      *                                                                                       CLE030
     C**********         MOVE      WFCNUM        WFCNUMX           6 0                 CLE030 CSD027
     C                   MOVE      WFCNUM        WFCNUMX           6                          CSD027
     C                   MOVE      WFFACT        WFFACTX           3 0                        CLE030
     C                   MOVE      WFFCNO        WFFCNOX           2 0                        CLE030
     C                   MOVE      WFRCTP        WFRCTPX           1                          CLE030
      *                                                                                       CLE030
      * Setup the values of the credit agreement                                              CLE030
      *                                                                                       CLE030
     C**********         Z-ADD     CANM          WFCNUM                                CLE030 CSD027
     C                   EVAL      WFCNUM = CANM                                              CSD027
     C                   Z-ADD     CAFT          WFFACT                                       CLE030
     C                   Z-ADD     CAFN          WFFCNO                                       CLE030
     C                   MOVE      'A'           WFRCTP                                       CLE030
      *                                                                                       CLE030
     C     WKFAC         CHAIN(N)  FCLTY                              99                      CLE030
      *                                                                                       CLE030
      ** Check allowable currencies array                                                     CLE030
      *                                                                                       CLE030
     C                   MOVEA     ALCY          WCY                                          CLE030
     C                   DO        9                                                          CLE030
     C     DDCURR        LOOKUP    WCY                                    38                  CLE030
     C                   ENDDO                                                                CLE030
      *                                                                                       CLE030
     C     *IN38         IFEQ      *OFF                                                       CLE030
     C*****DDCURR        ANDNE     W1DCURRCR                                          CLE030 BUG4351
     C     CSEL          ANDEQ     'Y'                                                        CLE030
     C**********         MOVE      DDCURR        W1DCURRCR         3                  CLE030 BUG4351
     C                   MOVE      'W'           DDCURROK                                     CLE030
     C                   ADD       1             WId                                          CLE030
     C                   MOVEL     'DDCURR'      WFldNmXAr(WId)                               CLE030
     C                   MOVEL     'LEL0284'     WMsgIDXAr(WId)                               CLE030
      *                                                                                       CLE030
     C                   EVAL      CCLLSTS = 'Q'                                              CLE030
     C                   ENDIF                                                                CLE030
      *                                                                                       CLE030
      ** Move back the saved values of the tranche                                            CLE030
      *                                                                                       CLE030
     C                   MOVE      WFCNUMX       WFCNUM                                       CLE030
     C                   MOVE      WFFACTX       WFFACT                                       CLE030
     C                   MOVE      WFFCNOX       WFFCNO                                       CLE030
     C                   MOVE      WFRCTPX       WFRCTP                                       CLE030
     C     WKFAC         CHAIN(N)  FCLTY                              99                      CLE030
     C                   ENDIF                                                                CLE030
      *
     C                   ENDIF
      *
      **  If no error, save some fields
      *
     C     DDCURROK      IFNE      'N'
     C                   MOVE      A6MDIN        WSVIN             1
     C                   Z-ADD     A6SPRT        WSVRT            13 8
     C                   Z-ADD     A6NBDP        WCDPL             1 0
     C                   Z-ADD     A6TXND        WSVTX             2 0
     C                   MOVE      DDCURR        W#CCY             3
     C                   MOVE      FCCYF         W#FCY             3
      *
      ** Save currency details.
      *
     C     CLE023        IFEQ      'Y'
     C                   MOVE      @CYCD         ZCCYI
     C                   Z-ADD     A6SPRT        ZRATE1
     C                   MOVE      A6MDIN        ZMDI1
     C                   Z-ADD     A6NBDP        ZCDPI
     C                   ENDIF
     C                   ELSE
     C                   Z-ADD     3             WCDPL
     C                   ENDIF
      *
     C     DDCURROK      IFNE      'N'
     C                   MOVEL     DDCURR        CCLCCY
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCPAM  -  Validate amount of loan                           *
      *****************************************************************
     C     SRCPAM        BEGSR
      *
     C                   Z-ADD     *ZEROS        WSVAM            13 0
     C                   MOVE      *BLANKS       PSCRF            16
     C                   MOVE      DDCPAM        PSCRF
     C                   Z-ADD     WCDPL         PNDEC             1 0
     C     13            SUB       WCDPL         PNDIG             2 0
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    PSCRF            16
     C                   PARM                    PNDEC             1 0
     C                   PARM                    PNDIG             2 0
     C                   PARM      *BLANKS       PRVAL            16
     C                   MOVE      PRVAL         WSVAM
      *
      ***  If loan is created by a Principal Transfer, validation
      ***  for the loan repayment amount should be against the amount
      ***  of the principal transfer record.
      *
     C                   Z-ADD     WSVAM         WSVAM2           13 0
      *
     C     WSVAM         IFEQ      0
     C**********         Z-ADD     CCLLNRF       WLLOAN                                       CLE148
     C                   MOVEL     CCLLNRF       WLLOAN                                       CLE148
     C                   Z-ADD     0             WLVDAT
     C                   Z-ADD     0             WLLASN
     C                   MOVEL     'N'           EXIT1             1
      *
     C     WKLAM         SETLL     LELOAML3
     C                   READ      LELOAML3                               99
     C     WLLOAN        DOWEQ     LNRFA
     C     *IN99         ANDNE     '1'
     C     EXIT1         ANDNE     'Y'
     C     AMTPA         IFEQ      'PT'
     C     RECIA         ANDEQ     'D'
     C     NRLIA         ANDEQ     'Y'
     C                   ADD       PRAMA         WSVAM2
     C                   MOVEL     'Y'           EXIT1
     C                   ENDIF
     C                   READ      LELOAML3                               99
     C                   ENDDO
      *
     C                   ENDIF
      *                                                                                       248222
      ***  If loan is created by a Principal Transfer, set PRTRF to 'Y'.                      248222
      *                                                                                       248222
     C**********         Z-ADD     CCLLNRF       WLLOAN                                248222 CLE148
     C                   MOVEL     CCLLNRF       WLLOAN                                       CLE148
     C                   Z-ADD     0             WLVDAT                                       248222
     C                   Z-ADD     0             WLLASN                                       248222
     C                   MOVEL     'N'           PRTRF             1                          248222
      *                                                                                       248222
     C     WKLAM         SETLL     LELOAML3                                                   248222
     C     WLLOAN        READE     LELOAML3                               99                  248222
     C     *IN99         DOWEQ     '0'                                                        248222
     C     AMTPA         IFEQ      'PT'                                                       248222
     C                   MOVEL     'Y'           PRTRF                                        248222
     C                   LEAVE                                                                248222
     C                   ENDIF                                                                248222
     C     WLLOAN        READE     LELOAML3                               99                  248222
     C                   ENDDO                                                                248222
      *                                                                                       248222
     C                   IF        PRTRF = 'N'                                                248222
     C**********         Z-ADD     CCLLNRF       WLLOAN                                248222 CLE148
     C                   MOVEL     CCLLNRF       WLLOAN                                       CLE148
     C                   Z-ADD     0             WLVDAT                                       248222
      *                                                                                       248222
     C     WKLHS         SETLL     HISTSL0                                                    248222
     C     WLLOAN        READE     HISTSL0                                99                  248222
     C     *IN99         DOWEQ     '0'                                                        248222
     C     JAMTP         IFEQ      'PT'                                                       248222
     C                   MOVEL     'Y'           PRTRF                                        248222
     C                   LEAVE                                                                248222
     C                   ENDIF                                                                248222
     C     WLLOAN        READE     HISTSL0                                99                  248222
     C                   ENDDO                                                                248222
      *                                                                                       248222
     C                   ENDIF                                                                248222
      *
      ** Validation for Principal Amount if CLE031 is not installed, or                       CLE106
      ** if it is and facility currency principal amount is blank, or                         CLE106
      ** if it is and action is not insert                                                    CLE106
      *                                                                                       CLE106
     C                   IF        CLE031 = 'N'                                               CLE106
     C                             Or CLE031 = 'Y' And DDFPAM = *Blanks                       CLE106
     C                             Or CLE031 = 'Y' And DDACTN <> 'I'                          CLE106
     C     DDCPAM        IFEQ      *BLANKS
     C     RespMode      ANDEQ     'S'
     C     PGNTF         ANDNE     'Y'                                                        CLE106
     C     WSVAM         OREQ      *ZEROS
     C     DDACTN        ANDEQ     'I'
     C     PGNTF         ANDNE     'Y'
     C     RespMode      ANDNE     'S'
     C     *IN82         ANDEQ     *OFF
     C     *IN83         ANDEQ     *OFF
     C     WSVAM         OREQ      *ZEROS
     C     DDACTN        ANDEQ     'I'
     C     PGNTF         ANDNE     'Y'                                                        CLE106
     C     RespMode      ANDEQ     'S'
     C     @RTCD         ORNE      *BLANKS
     C     DDACTN        ANDEQ     'I'
     C     PGNTF         ANDNE     'Y'                                                        CLE106
                                                                                              CLE106
     C     CLE106        IFEQ      'N'                                                        CLE106
     C     DDPTFC        OREQ      *BLANKS                                                    CLE106
     C     @RTCD         ORNE      *BLANKS                                                    CLE106
     C                   MOVE      'N'           DDCPAMOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCPAM'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0138'     MsgIDXAr(Idx)
     C                   ENDIF                                                                CLE106
     C                   ENDIF
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
      ** Validate Facility Currency Principal Amount                                          CLE106
                                                                                              CLE106
     C                   IF        CLE031 = 'Y' And DDFCCY <> *Blanks                         CLE106
     C                             And DDACTN = 'I' And DDFCUSOK = 'Y'                        CLE106
                                                                                              CLE106
     C                   CALLB     'AOCURRR0'                                                 CLE106
     C                   PARM      *Blanks       @RTCD                                        CLE106
     C                   PARM      '*KEY   '     @OPTN                                        CLE106
     C                   PARM      DDFCCY        @CYCD                                        CLE106
     C     SDCURR        PARM      SDCURR        DSSDY                                        CLE106
                                                                                              CLE106
     C                   IF        @RTCD <> *Blanks                                           CLE106
     C     *LOCK         IN        LDA                                                        CLE106
     C                   EVAL      DBFILE = 'SDCURRPD'                                        CLE106
     C                   EVAL      DBASE = 91                                                 CLE106
     C                   EVAL      DBKEY = DDFCCY                                             CLE106
     C                   OUT       LDA                                                        CLE106
     C                   EXSR      *PSSR                                                      CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
      ** Get Cross Rate and mult/div indicator                                                CLE106
                                                                                              CLE106
     C                   IF        DDFCCY <> BJCYCD                                           CLE106
     C                   IF        A6MDIN = 'M'                                               CLE106
     C                   EVAL      WFMINX = 'D'                                               CLE106
     C                   ELSE                                                                 CLE106
     C                   EVAL      WFMINX = 'M'                                               CLE106
     C                   ENDIF                                                                CLE106
     C                   IF        A6MDIN = 'M' And WSVIN = 'M' Or                            CLE106
     C                             A6MDIN = 'D' And WSVIN = 'D'                               CLE106
     C     A6SPRT        DIV(H)    WSVRT         WSPOT                                        CLE106
     C                   ELSE                                                                 CLE106
     C     A6SPRT        MULT(H)   WSVRT         WSPOT                                        CLE106
     C                   ENDIF                                                                CLE106
     C                   ELSE                                                                 CLE106
     C                   EVAL      WSPOT = WSVRT                                              CLE106
     C                   EVAL      WFMINX = WSVIN                                             CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
     C                   MOVE      *Blanks       PSCRF                                        CLE106
     C                   MOVE      DDFPAM        PSCRF                                        CLE106
     C                   EVAL      WFCNBP = A6NBDP                                            CLE106
     C                   EVAL      PNDIG = 13 - WFCNBP                                        CLE106
     C                   CALL      'ZALIGN'                                                   CLE106
     C                   PARM      *Blanks       PRTCD                                        CLE106
     C                   PARM                    PSCRF                                        CLE106
     C                   PARM      A6NBDP        PNDEC                                        CLE106
     C                   PARM                    PNDIG                                        CLE106
     C                   PARM      *Blanks       PRVAL                                        CLE106
                                                                                              CLE106
     C                   MOVE      PRVAL         WFPAM                                        CLE106
                                                                                              CLE106
      ** If the amount is invalid                                                             CLE106
                                                                                              CLE106
     C                   IF        PRTCD <> *Blanks                                           CLE106
     C                   EVAL      DDFPAMOK = 'N'                                             CLE106
     C                   EVAL      Idx = Idx + 1                                              CLE106
     C                   EVAL      FldNamXAr(Idx) = 'DDFPAM'                                  CLE106
     C                   EVAL      MsgIDXAr(Idx) = 'LEL0138'                                  CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
      ** Error if facility and loan currencies are the same                                   CLE106
                                                                                              CLE106
     C                   IF        DDCURR = FCCYF And WFPAM <> *Zeros                         CLE106
     C                   EVAL      DDFPAMOK = 'N'                                             CLE106
     C                   EVAL      Idx = Idx + 1                                              CLE106
     C                   EVAL      FldNamXAr(Idx) = 'DDFPAM'                                  CLE106
     C                   EVAL      MsgIDXAr(Idx) = 'LEL0579'                                  CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
      ** If Facility Currency Principal amount is ok populate Principal Amount                CLE106
                                                                                              CLE106
     C                   IF        PRTCD = *Blanks And WFPAM <> *Zeros                        CLE106
     C                             And DDFPAMOK <> 'N'                                        CLE106
     C                   EVAL      CCLFPAM = WFPAM                                            CLE106
                                                                                              CLE106
      ** Simulate the validation on Facility Exchange Rate as to be done in                   CLE106
      ** LECLIP3VL before converting Principal.                                               CLE106
                                                                                              CLE106
     C                   EXSR      SRFCXR                                                     CLE106
                                                                                              CLE106
      ** if error was found during exchange rate validation, skip validation                  CLE106
      ** else move output PRVAL to ZALIGN parameter ZEXCH if no error occured                 CLE106
                                                                                              CLE106
     C                   IF        PRTCD = *Blanks                                            CLE106
                                                                                              CLE106
     C                   MOVE      PRVAL         ZEXCH                                        CLE106
     C                   IF        DDFMIN = 'D'                                               CLE106
     C                   EVAL      ZMD = 'M'                                                  CLE106
     C                   ELSE                                                                 CLE106
     C                   EVAL      ZMD = 'D'                                                  CLE106
     C                   ENDIF                                                                CLE106
     C                   CALLB     'ZCONVZ1'                                                  CLE106
     C                   PARM      WFPAM         ZAMTCI                                       CLE106
     C                   PARM                    ZEXCH                                        CLE106
     C                   PARM                    ZMD                                          CLE106
     C                   PARM      DDFCCY        ZCCYI                                        CLE106
     C                   PARM      DDCURR        ZCCYO                                        CLE106
     C                   PARM      WFCNBP        ZCDPI                                        CLE106
     C                   PARM      WCDPL         ZCDPO                                        CLE106
     C                   PARM                    ZAMTCO                                       CLE106
     C                   EVAL      WCFCPA = ZAMTCO                                            CLE106
                                                                                              CLE106
      ** Default Principal amount if it was left blank                                        CLE106
                                                                                              CLE106
     C                   IF        DDCPAM = *Blanks                                           CLE106
     C                   EVAL      WSVAM = WCFCPA                                             CLE106
     C                   EVAL      WSVAM2 = WCFCPA                                            CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
      ** Error if principal amount and facility currency principal amount                     CLE106
      ** are both blank or zero                                                               CLE106
                                                                                              CLE106
     C                   IF        (DDCPAM = *Blanks Or WSVAM = *Zeros) And                   CLE106
     C                             (DDFPAM = *Blanks Or WCFCPA = *Zeros)                      CLE106
     C                   EVAL      DDFPAMOK = 'N'                                             CLE106
     C                   EVAL      Idx = Idx + 1                                              CLE106
     C                   EVAL      FldNamXAr(Idx) = 'DDFPAM'                                  CLE106
     C                   EVAL      MsgIDXAr(Idx) = 'LEL0569'                                  CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
      ** Error if converted amount (WCFCPA) is not equal to principal amount                  CLE106
                                                                                              CLE106
     C                   IF        WCFCPA <> WSVAM And DDCURR <> DDFCCY                       CLE106
     C                   EVAL      DDFPAMOK = 'N'                                             CLE106
     C                   EVAL      Idx = Idx + 1                                              CLE106
     C                   EVAL      FldNamXAr(Idx) = 'DDFPAM'                                  CLE106
     C                   EVAL      MsgIDXAr(Idx) = 'LEL0567'                                  CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
     C                   IF        DDCPAMOK <> 'N' And DDFPAM <> 'N'                          CLE106
     C                   MOVE      *Blanks       ZFIELD                                       CLE106
     C                   MOVE      WSVAM         ZFIELD                                       CLE106
     C                   CALL      'ZEDIT'                                                    CLE106
     C                   PARM                    ZFIELD                                       CLE106
     C                   PARM      WCDPL         ZADEC                                        CLE106
     C                   MOVE      ZFIELD        DDCPAM                                       CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
      *
     C     DDCPAMOK      IFNE      'N'
     C                   Z-ADD     WSVAM         CCLCPAM
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CLE106
      *  SRFCXR  -  Validate Facility Exchange Rate                   *                       CLE106
      *             LECLIP3VL does this but the fields must be valid  *                       CLE106
      *             to be able to proceed with conversion.            *                       CLE106
      *****************************************************************                       CLE106
     C     SRFCXR        BEGSR                                                                CLE106
                                                                                              CLE106
     C                   IF        DDFCXR = *Blanks                                           CLE106
     C                   MOVE      WSPOT         PRVAL                                        CLE106
     C                   ELSE                                                                 CLE106
                                                                                              CLE106
     C                   CALL      'ZALIGN'                                                   CLE106
     C                   PARM      *Blanks       PRTCD                                        CLE106
     C                   PARM      DDFCXR        PSCRF                                        CLE106
     C                   PARM      8             PNDEC                                        CLE106
     C                   PARM      5             PNDIG                                        CLE106
     C                   PARM      *Blanks       PRVAL                                        CLE106
                                                                                              CLE106
      ** Also check if rate is within 25% of the rate calculated                              CLE106
                                                                                              CLE106
     C                   IF        PRTCD <> *Blanks                                           CLE106
     C                   EVAL      DDFPAMOK = 'N'                                             CLE106
     C                   EVAL      Idx = Idx + 1                                              CLE106
     C                   EVAL      FldNamXAr(Idx) = 'DDFPAM'                                  CLE106
     C                   EVAL      MsgIDXAr(Idx) = 'LEL0283'                                  CLE106
     C                   ELSE                                                                 CLE106
     C                   MOVE      PRVAL         WFCXRate                                     CLE106
      *                                                                                     AR882700
      ** Facility Exchange Rate should not be equal to zero                                 AR882700
      *                                                                                     AR882700
     C     WFCXRate      IFEQ      *ZERO                                                    AR882700
     C                   EVAL      PRTCD = '*ERROR'                                         AR882700
     C                   ELSE                                                               AR882700
      *                                                                                     AR882700
     C                   IF        DDFMIN <> WFMINX                                           CLE106
     C     1             DIV(H)    WSPOT         WSPOT                                        CLE106
     C                   ENDIF                                                                CLE106
     C     WSPOT         MULT(H)   .75           WRATM                                        CLE106
     C     WSPOT         MULT(H)   1.25          WRATP                                        CLE106
     C                   IF        WFCXRate < WRATM Or                                        CLE106
     C                             WFCXRate > WRATP                                           CLE106
     C                   EVAL      DDFPAMOK = 'W'                                             CLE106
     C**********         EVAL      WIdx = WIdx + 1                                   CLE106 MD052214
     C**********         EVAL      WFldNmXAr(WIdx) = 'DDFPAM'                        CLE106 MD052214
     C**********         EVAL      WMsgIDXAr(WIdx) = 'LEL0079'                       CLE106 MD052214
     C                   EVAL      WId = WId + 1                                            MD052214
     C                   EVAL      WFldNmXAr(WId) = 'DDFPAM'                                MD052214
     C                   EVAL      WMsgIDXAr(WId) = 'LEL0079'                               MD052214
     C                   ENDIF                                                                CLE106
      *                                                                                     AR882700
     C                   ENDIF                                                              AR882700
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
      ** Validate Facility Currency Indicator as well                                         CLE106
                                                                                              CLE106
     C                   IF        DDFCXR = *Blanks And DDFMIN <> *Blanks Or                  CLE106
     C                             DDFCXR <> *Blanks And DDFMIN = *Blanks                     CLE106
     C                   EVAL      DDFPAMOK = 'N'                                             CLE106
     C                   EVAL      Idx = Idx + 1                                              CLE106
     C                   EVAL      FldNamXAr(Idx) = 'DDFPAM'                                  CLE106
     C                   EVAL      MsgIDXAr(Idx) = 'LEL0291'                                  CLE106
     C                   EVAL      PRTCD = '*ERROR'                                           CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
     C                   ENDSR                                                                CLE106
      *****************************************************************                       CLE106
      /EJECT                                                                                  CLE106
      *****************************************************************
      *  SRDDAT  -  Validate the deal date                            *
      *****************************************************************
     C     SRDDAT        BEGSR
      *
     C                   MOVE      DDDDAT        ZDATE
     C                   MOVE      BJDFIN        ZDATFM
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR              7
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDAYNO            5 0
      *
     C                   MOVEL     DDDDAT        WNUM7             7 0
     C                   MOVEL     WNUM7         WALF6             6
     C                   Z-ADD     ZDAYNO        WSVDD             5 0
     C     ZERR          IFNE      *BLANKS
     C     DDDDAT        ORNE      WALF6
     C                   MOVE      'N'           DDDDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0026'     MsgIDXAr(Idx)
     C                   ELSE
      *
      ***  validate relationships if deal date is valid
      ***  must be earlier than or equal to rundate (except for
      ***  principal transfer)
      *
     C     WSVDD         IFGT      BJRDNB
      ** Allow for Principal Transfers (remove RespMode as this                               244213
      ** no longer applies for Midas Plus)                                                    244213
     C*****RespMode      IFNE      'S'                                                        244213
     C*****PGNTF         ANDEQ     'Y'                                                        244213
     C     PGNTF         IFEQ      'Y'                                                        244213
     C     @@GPRT        OREQ      'Y'
     C                   ELSE
     C                   MOVE      'N'           DDDDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0027'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  Must not be a holiday in local currency
      *
     C                   ELSE
     C                   Z-ADD     WSVDD         ZDAYNO
     C                   MOVE      BJLCCY        ZCCY
     C                   MOVE      WLCCD         ZLOC
      *
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
     C                   PARM      *BLANK        ZIND              1
      *
     C     ZIND          IFEQ      'H'
     C     DDACTN        ANDEQ     'I'
      * Allow for Principal Transfer (PGNTF is 'Y' during INSERT and                          244213
      * @@GPRT is 'Y' during AMEND)                                                           244213
     C     PGNTF         IFEQ      'Y'                                                        244213
     C     @@GPRT        OREQ      'Y'                                                        244213
     C                   ELSE                                                                 244213
     C                   MOVE      'N'           DDDDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0029'     MsgIDXAr(Idx)
     C                   ENDIF                                                                244213
     C                   ENDIF
     C                   ENDIF
      *                                                                                       243931
      ** Do not validate deal date against last availability date if                          243931
      ** loan type is for a participation sold.                                               243931
      *                                                                                       243931
     C     LoanType      IFNE      'PTSO'                                                     243931
      *                                                                                       CLE030
      ** Must not be later than 'Last Availibility date' of facility                          CLE030
      ** Put out warning message not error message and set loan status                        CLE030
      ** (CCLLSTS) on valid file data structure to 'Requires release'                         CLE030
      ** Only if CLE030 is on.                                                                CLE030
      ** But allow for Principal Transfers                                                    244213
      *                                                                                       CLE030
     C     WSVDD         IFGT      AVLD                                                       CLE030
     C     AVLD          ANDNE     *ZERO                                                      CLE030
     C     CLE030        IFEQ      'N'                                                        CLE030
     C     PGNTF         IFEQ      'Y'                                                        244213
     C     @@GPRT        OREQ      'Y'                                                        244213
     C     PRTRF         OREQ      'Y'                                                        248222
     C                   ELSE                                                                 244213
      *                                                                                     MD021016
     C                   IF        CLE134 = 'Y'                                             MD021016
     C                   SELECT                                                             MD021016
     C                   WHEN      %SUBST(DDLTYP:1:1) = 'X'                                 MD021016
     C                   MOVEL     'N'           WFAMU             1                        MD021016
     C                   OTHER                                                              MD021016
     C                   MOVEL     DDFAMU        WFAMU             1                        MD021016
     C                   ENDSL                                                              MD021016
      *                                                                                     MD021016
     C                   IF        WFAMU = 'Y'                                              MD021016
     C                   MOVE      'W'           DDVDATOK                                   MD021016
     C                   ADD       1             WId                                        MD021016
     C                   MOVEL     'DDDDAT'      WFldNmXAr(WId)                             MD021016
     C                   MOVEL     'LEL0670'     WMsgIDXAr(WId)                             MD021016
     C                   ENDIF                                                              MD021016
     C                   GOTO      SKIP2                                                    MD021016
      *                                                                                     MD021016
     C                   ENDIF                                                              MD021016
      *                                                                                     MD021016
     C                   MOVE      'N'           DDDDATOK                                     CLE030
     C                   ADD       1             Idx                                          CLE030
     C                   MOVEL     'DDDDAT'      FldNamXAr(Idx)                               CLE030
     C                   MOVEL     'LEL0670'     MsgIDXAr(Idx)                                CLE030
     C                   ENDIF                                                                244213
     C                   ELSE                                                                 CLE030
     C*****WSVDD         IFNE      W1SVDD                                             CLE030 BUG4351
     C**********         Z-ADD     WSVDD         W1SVDD            5 0                CLE030 BUG4351
     C                   MOVE      'W'           DDDDATOK                                     CLE030
     C                   ADD       1             WId                                          CLE030
     C                   MOVEL     'DDDDAT'      WFldNmXAr(WId)                               CLE030
     C                   MOVEL     'LEL0669'     WMsgIDXAr(WId)                               CLE030
     C**********         ENDIF                                                        CLE030 BUG4351
     C                   EVAL      CCLLSTS = 'Q'                                              CLE030
     C                   ENDIF                                                                CLE030
     C                   ENDIF                                                                CLE030
      *                                                                                       243931
     C                   ENDIF                                                                243931
     C     SKIP2         TAG                                                                MD021016
      *
     C     DDDDATOK      IFNE      'N'
     C                   Z-ADD     WSVDD         CCLDDAT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************                       CLE143
      /EJECT                                                                                  CLE143
      *****************************************************************                       CLE143
      *  SROCDT  -  Validate Original Contract Date                   *                       CLE143
      *****************************************************************                       CLE143
     C     SROCDT        BEGSR                                                                CLE143
                                                                                              CLE143
      ** If Original Contract Dats is entered, muat be a valid date                           CLE143
                                                                                              CLE143
     C                   IF        DDOCDT <> *BLANKS                                          CLE143
     C                   MOVE      DDOCDT        ZDATE                                        CLE143
     C                   MOVE      BJDFIN        ZDATFM                                       CLE143
     C                   CALL      'ZDATE1'                                                   CLE143
     C                   PARM      *BLANKS       ZERR                                         CLE143
     C                   PARM                    ZDATE                                        CLE143
     C                   PARM                    ZDATFM                                       CLE143
     C                   PARM                    ZDAYNO                                       CLE143
                                                                                              CLE143
     C                   MOVEL     DDOCDT        WNUM7                                        CLE143
     C                   MOVEL     WNUM7         WALF6                                        CLE143
     C                   Z-ADD     ZDAYNO        WSOCD             5 0                        CLE143
                                                                                              CLE143
     C     ZERR          IFNE      *BLANKS                                                    CLE143
     C     DDOCDT        ORNE      WALF6                                                      CLE143
     C                   MOVE      'N'           DDOCDTOK                                     CLE143
     C                   ADD       1             Idx                                          CLE143
     C                   MOVEL     'DDOCDT'      FldNamXAr(Idx)                               CLE143
     C                   MOVEL     'LEL0858'     MsgIDXAr(Idx)                                CLE143
     C                   ENDIF                                                                CLE143
                                                                                              CLE143
     C     DDOCDTOK      IFNE      'N'                                                        CLE143
     C                   Z-ADD     WSOCD         CCLOCDT                                      CLE143
     C                   ENDIF                                                                CLE143
                                                                                              CLE143
     C                   ELSE                                                                 CLE143
     C     DDDDATOK      IFNE      'N'                                                        CLE143
     C                   MOVEL     DDDDAT        DDOCDT                                       CLE143
     C                   Z-ADD     WSVDD         CCLOCDT                                      CLE143
     C                   ENDIF                                                                CLE143
     C                   ENDIF                                                                CLE143
                                                                                              CLE143
     C                   ENDSR                                                                CLE143
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRAUTO  -  Validate auto settlement indicator                *
      *****************************************************************
     C     SRAUTO        BEGSR
      *                                                                                       262461
      ** if auto-settle is 'C' ensure that the loan type/subtype has a                        262461
      *  PDCL loan type/subtype                                                               262461
     C                   IF        CLE134      = 'Y'                                          262461
     C                   MOVEL     DDLTYP        WLTYP             1                         262461A
      *                                                                                      262461A
     C     DDAUTO        IFEQ      'C'                                                        262461
     C     WLTYP         ANDNE     'X'                                                       262461A
     C     WLTYP         ANDNE     'Y'                                                       262461A
     C     WLTYP         ANDNE     'Z'                                                       262461A
      *                                                                                      262461A
     C     AYPPLT        IFEQ      *BLANKS                                                  AR632104
     C*****AYPPLS        OREQ      *BLANKS                                         AR632104 AR826996
     C     AYPPLS        ANDEQ     *BLANKS                                                  AR826996
     C     AYIPLT        OREQ      *BLANKS                                                  AR632104
     C*****AYIPLS        OREQ      *BLANKS                                         AR632104 AR826996
     C     AYIPLS        ANDEQ     *BLANKS                                                  AR826996
     C     AYCAPI        ANDNE     'Y'                                                      AR826996
     C                   MOVEL     'N'           WPDCL             1                        AR632104
     C                   ELSE                                                               AR632104
     C                   MOVEL     'Y'           WPDCL                                      AR632104
     C                   ENDIF                                                              AR632104
      *                                                                                     AR632104
      ** If subtype change exists, ensure that new loan type/subtype is                     AR632104
      ** defined with PDCL details.                                                         AR632104
      *                                                                                     AR632104
     C                   MOVE      'N'           FOUNDLS           1                        AR632104
     C                   MOVEL     'N'           LSVALUE           1                        AR632104
     C     WLLOAN        SETLL     LOAMS                                                    AR632104
     C     WLLOAN        READE     LOAMS                                  99                AR632104
     C     *IN99         DOWEQ     '0'                                                      AR632104
     C     AMTPA         IFEQ      'LS'                                                     AR632104
     C     RECIA         ANDEQ     'D'                                                      AR632104
     C                   MOVE      'Y'           FOUNDLS                                    AR632104
     C                   MOVE      LTYPA         @LNTY                                      AR632104
     C                   MOVE      SUTPA         @LNST                                      AR632104
     C                   MOVE      CLASA         @LNCL                                      AR632104
     C                   CALL      'AOLOANR0'                                               AR632104
     C                   PARM      *BLANKS       @RTCD                                      AR632104
     C                   PARM      '*KEY   '     @OPTN                                      AR632104
     C                   PARM                    @LNTY                                      AR632104
     C                   PARM                    @LNST                                      AR632104
     C                   PARM                    @LNCL                                      AR632104
     C     SDLOAN        PARM      SDLOAN        DSSDY                                      AR632104
     C     AYPPLT        IFEQ      *BLANKS                                                  AR632104
     C*****AYPPLS        OREQ      *BLANKS                                         AR632104 AR826996
     C     AYPPLS        ANDEQ     *BLANKS                                                  AR826996
     C     AYIPLT        OREQ      *BLANKS                                                  AR632104
     C*****AYIPLS        OREQ      *BLANKS                                         AR632104 AR826996
     C     AYIPLS        ANDEQ     *BLANKS                                                  AR826996
     C     AYCAPI        ANDNE     'Y'                                                      AR826996
     C                   EVAL      DDAUTOOK    = 'N'                                        AR632104
     C                   EVAL      Idx        += 1                                          AR632104
     C                   EVAL      FldNamXAr(Idx) = 'DDAUTO'                                AR632104
     C                   EVAL      MsgIDXAr(Idx)  = 'LER5598'                               AR632104
     C                   LEAVE                                                              AR632104
     C                   ELSE                                                               AR632104
     C     VDATA         IFEQ      BJRDNB                                                   AR632104
     C                   MOVEL     'Y'           LSVALUE                                    AR632104
     C                   ENDIF                                                              AR632104
     C     VDATA         IFGT      BJRDNB                                                   AR632104
     C     WPDCL         ANDEQ     'N'                                                      AR632104
     C     LSVALUE       ANDEQ     'N'                                                      AR632104
     C                   EVAL      DDAUTOOK    = 'N'                                        AR632104
     C                   EVAL      Idx        += 1                                          AR632104
     C                   EVAL      FldNamXAr(Idx) = 'DDAUTO'                                AR632104
     C                   EVAL      MsgIDXAr(Idx)  = '5045665'                               AR632104
     C                   LEAVE                                                              AR632104
     C                   ENDIF                                                              AR632104
     C                   ENDIF                                                              AR632104
     C                   ENDIF                                                              AR632104
     C     WLLOAN        READE     LOAMS                                  99                AR632104
     C                   ENDDO                                                              AR632104
      *                                                                                     AR632104
     C     FOUNDLS       IFEQ      'N'                                                      AR632104
     C                   MOVE      DDLTYP        @LNTY                                      AR632104
     C                   MOVE      DDSUTP        @LNST                                      AR632104
     C                   MOVE      DDCLAS        @LNCL                                      AR632104
     C                   CALL      'AOLOANR0'                                               AR632104
     C                   PARM      *BLANKS       @RTCD                                      AR632104
     C                   PARM      '*KEY   '     @OPTN                                      AR632104
     C                   PARM                    @LNTY                                      AR632104
     C                   PARM                    @LNST                                      AR632104
     C                   PARM                    @LNCL                                      AR632104
     C     SDLOAN        PARM      SDLOAN        DSSDY                                      AR632104
     C     AYPPLT        IFEQ      *BLANKS                                                    262461
     C*****AYPPLS        OREQ      *BLANKS                                           262461 AR826996
     C     AYPPLS        ANDEQ     *BLANKS                                                  AR826996
     C     AYIPLT        OREQ      *BLANKS                                                    262461
     C*****AYIPLS        OREQ      *BLANKS                                           262461 AR826996
     C     AYIPLS        ANDEQ     *BLANKS                                                  AR826996
     C     AYCAPI        ANDNE     'Y'                                                      AR826996
     C                   EVAL      DDAUTOOK    = 'N'                                          262461
     C                   EVAL      Idx        += 1                                            262461
     C                   EVAL      FldNamXAr(Idx) = 'DDAUTO'                                  262461
     C                   EVAL      MsgIDXAr(Idx)  = '5045665'                                 262461
     C                   ENDIF                                                                262461
     C                   ENDIF                                                              AR632104
      *
      ** Base Rate Code + Currency Validation                                               AR826996
      *                                                                                     AR826996
     C     DDACTN        IFEQ      'I'                                                      AR826996
     C     DDACTN        OREQ      'A'                                                      AR826996
     C     AYPPLT        IFNE      *BLANKS                                                  AR826996
     C     AYPPLS        ANDNE     *BLANKS                                                  AR826996
     C     AYPBSR        ANDNE     0                                                        AR826996
      *                                                                                     AR826996
     C     KCYBR         KLIST                                                              AR826996
     C                   KFLD                    DDCURR                                     AR826996
     C                   KFLD                    @BSRT                                      AR826996
     C                                                                                      AR826996
      *                                                                                     AR826996
      ** Validate Base rate code + Currency for PDCL Principal                              AR826996
      *                                                                                     AR826996
     C                   MOVE      *BLANK        @BSRT             2                        AR826996
     C                   MOVE      AYPBSR        @BSRT                                      AR826996
     C                                                                                      AR826996
     C     KCYBR         CHAIN     SDBSRTL0                           31                    AR826996
     C     *IN31         IFEQ      *ON                                                      AR826996
     C                   MOVE      *BLANKS       @CCYBR                                     AR826996
     C     DDCURR        CAT       @BSRT         @CCYBR            5                        AR826996
     C                   EVAL      DDAUTOOK    = 'N'                                        AR826996
     C                   EVAL      Idx        += 1                                          AR826996
     C                   EVAL      FldNamXAr(Idx) = 'DDAUTO'                                AR826996
     C                   EVAL      MsgIDXAr(Idx)  = 'LER5605'                               AR826996
     C                   EVAL      MsgDtaXAr = @CCYBR                                       AR826996
     C                   ENDIF                                                              AR826996
     C     AYIPLT        IFNE      *BLANKS                                                  AR826996
     C     AYIPLS        ANDNE     *BLANKS                                                  AR826996
     C     AYCAPI        ANDNE     'Y'                                                      AR826996
     C     AYIBSR        ANDNE     0                                                        AR826996
      *                                                                                     AR826996
      ** Validate Base rate code + Currency for PDCL Interest                               AR826996
      *                                                                                     AR826996
     C                   MOVE      *BLANK        @BSRT                                      AR826996
     C                   MOVE      AYIBSR        @BSRT                                      AR826996
     C                                                                                      AR826996
     C     KCYBR         CHAIN     SDBSRTL0                           32                    AR826996
     C     *IN32         IFEQ      *ON                                                      AR826996
      * Error Interest                                                                      AR826996
     C                   MOVE      *BLANKS       @CCYBR                                     AR826996
     C     DDCURR        CAT       @BSRT         @CCYBR            5                        AR826996
     C                   EVAL      DDAUTOOK    = 'N'                                        AR826996
     C                   EVAL      Idx        += 1                                          AR826996
     C                   EVAL      FldNamXAr(Idx) = 'DDAUTO'                                AR826996
     C                   EVAL      MsgIDXAr(Idx)  = 'LER5606'                               AR826996
     C                   EVAL      MsgDtaXAr = @CCYBR                                       AR826996
     C                   ENDIF                                                              AR826996
     C                   ENDIF                                                              AR826996
     C                   ENDIF                                                              AR826996
     C                   ENDIF                                                              AR826996
     C                   ENDIF                                                                262461
     C                   ENDIF                                                                262461
      *
     C     DDAUTO        IFEQ      *BLANK
     C*******************MOVE      'N'           DDAUTO                         213809
     C                   IF        S01465 = 'Y'                                 213809
     C                   EVAL      DDAUTO = BPDASI                              213809
     C                   ELSE                                                   213809
     C                   EVAL      DDAUTO = 'N'                                 213809
     C                   ENDIF                                                  213809
                                                                                213809
     C                   ELSE
     C                   IF        CLE134      = 'Y'                                          CLE134
     C                   IF        DDAUTO     <> 'Y'       AND                                CLE134
     C                             DDAUTO     <> 'N'       AND                                CLE134
     C                             DDAUTO     <> 'C'                                          CLE134
     C                   EVAL      DDAUTOOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDAUTO'                                  CLE134
     C                   EVAL      MsgIDXAr(Idx)  = '5045576'                                 CLE134
      *                                                                                       CLE134
     C                   ELSE                                                                 CLE134
     C                   IF        DDAUTO      = 'C'           AND                            CLE134
     C                             WLNPT      <> 61            AND                            CLE134
     C                             WLNPT      <> 62            AND                            CLE134
     C                             WLNPT      <> 64            AND                            CLE134
     C                             WLNPT      <> 66            AND                            CLE134
     C                             WLNPT      <> 68            AND                            CLE134
     C                             WLNPT      <> 69            AND                            CLE134
     C                             WLNPT      <> 80                                           CLE134
     C                   EVAL      DDAUTOOK    = 'N'                                          CLE134
     C                   EVAL      Idx        += 1                                            CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDAUTO'                                  CLE134
     C                   EVAL      MsgIDXAr(Idx)  = '5045575'                                 CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
      *                                                                                       CLE134
     C                   ELSE                                                                 CLE134
     C     DDAUTO        IFNE      'Y'
     C     DDAUTO        ANDNE     'N'
     C                   MOVE      'N'           DDAUTOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAUTO'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0061'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF                                                                CLE134
     C                   ENDIF
      *                                                                                       245227
      ** Check if Autosettle indicator has been changed on amend mode.                        245227
      *                                                                                       245227
     C                   MOVE      'N'           WAUTOA                                       245227
     C                   MOVE      *BLANKS       WAUTOY                                       245227
     C     DDACTN        IFEQ      'A'                                                        245227
     C     DDAUTO        IFNE      CCLAUTO                                                    245227
     C     DDAUTO        ANDNE     *BLANKS                                                    245227
     C                   MOVE      'Y'           WAUTOA                                       245227
      *                                                                                       CLE134
     C                   IF        CLE134      = 'Y'                                          CLE134
     C                   EVAL      WAUTOA      = DDAUTO                                       CLE134
     C                   ENDIF                                                                CLE134
      *                                                                                       245227
      ** Check whether amendment is from AUTOSETTLE to NON-AUTOSETTLE                         245227
      ** or vice versa.                                                                       245227
      *                                                                                       245227
     C     CCLAUTO       IFEQ      'Y'                                                        245227
     C     DDAUTO        ANDEQ     'N'                                                        245227
     C     CCLAUTO       OREQ      'C'                                                        CLE134
     C     DDAUTO        ANDEQ     'N'                                                        CLE134
     C     CLE134        ANDEQ     'Y'                                                        CLE134
     C                   MOVE      '1'           WAUTOY                                       245227
     C                   ELSE                                                                 245227
     C                   MOVE      '2'           WAUTOY                                       245227
     C                   ENDIF                                                                245227
     C                   ELSE                                                                 245227
     C                   MOVE      'N'           WAUTOY                                       245227
     C                   ENDIF                                                                245227
     C                   ENDIF                                                                245227
      *
      *****Cannot*be*'Y'*if*stop*accruals*is*set*or*amended*today******                       CLE134
      ** Cannot be 'C' or 'Y' if stop accruals is set or amended today                        CLE134
      *
     C     DDAUTO        IFEQ      'Y'
     C     DDACTN        ANDEQ     'A'
     C     DDAUTO        OREQ      'C'                                                        CLE134
     C     DDACTN        ANDEQ     'A'                                                        CLE134
     C     CLE134        ANDEQ     'Y'                                                        CLE134
     C                   TESTB     '3'           @@LONI                   99
     C     *IN99         IFEQ      '1'
     C                   TESTB     '2'           @@ACEI               99
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           DDAUTOOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAUTO'      FldNamXAr(Idx)
      *                                                                                       CLE134
     C                   IF        CLE134      = 'Y'                                          CLE134
     C                   MOVEL     '5045653'     MsgIDXAr(Idx)                                CLE134
      *                                                                                       CLE134
     C                   ELSE                                                                 CLE134
     C                   MOVEL     'LEL0061'     MsgIDXAr(Idx)
     C                   ENDIF                                                                CLE134
      *                                                                                       CLE134
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     DDAUTOOK      IFNE      'N'
     C                   MOVEL     DDAUTO        CCLAUTO
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRVDAT  -  Validate the value date                           *
      *****************************************************************
     C     SRVDAT        BEGSR
      *
      ***  Validations relating to facility will be ignored for
      ***  parts sold as it does not have this field
      *
     C                   MOVE      DDVDAT        ZDATE
     C                   MOVE      BJDFIN        ZDATFM
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR              7
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZDATFM            1
     C                   PARM                    ZDAYNO            5 0
      *
     C                   MOVEL     DDVDAT        WNUM7             7 0
     C                   MOVEL     WNUM7         WALF6             6
     C                   Z-ADD     ZDAYNO        WSVVD             5 0
      *
B001 C     ZERR          IFNE      *BLANKS
     C     DDVDAT        ORNE      WALF6
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0150'     MsgIDXAr(Idx)
     C                   ELSE
      *
      ***  Must be on or later than 'date approved' of facility
      *
     C     *IN83         IFEQ      '0'
     C     DDFCUSOK      ANDNE     'N'
     C     WSVVD         IFLT      DTAPF
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0233'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  Must be on or later than 'date committed' of facility
      *
     C     WSVVD         IFLT      COMDF
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0237'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  Must not be later than 'Last Availability Date' of facility
      ***  Put out warning message not error message and set loan                             CLE030
      ***  status (CCLLSTS) on valid file data structure to 'Requires                         CLE030
      ***  release'. Only if CLE030 is on.                                                    CLE030
      ***  But allow for Principal Transfers                                                  244213
      *                                                                                     AR468303
     C                   MOVEL     *BLANKS       LTYP1                                      AR468303
     C     CLE134        IFEQ      'Y'                                                      AR468303
     C                   MOVEL     DDLTYP        LTYP1                                      AR468303
     C                   END                                                                AR468303
      *
     C     WSVVD         IFGT      AVLD
     C     AVLD          ANDNE     *ZERO
     C     CLE030        IFEQ      'N'                                                        CLE030
     C     PGNTF         IFEQ      'Y'                                                        244213
     C     @@GPRT        OREQ      'Y'                                                        244213
     C     PRTRF         OREQ      'Y'                                                        248222
     C     LTYP1         OREQ      'Y'                                                      AR468303
     C     LTYP1         OREQ      'Z'                                                      AR468303
     C     LTYP1         OREQ      'X'                                                      AR468303
     C                   ELSE                                                                 244213
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0236'     MsgIDXAr(Idx)
     C                   ENDIF                                                                244213
     C                   ELSE                                                                 CLE030
     C*****WSVVD         IFNE      W1SVVD                                             CLE030 BUG4351
     C**********         Z-ADD     WSVVD         W1SVVD            5 0                CLE030 BUG4351
     C                   MOVE      'W'           DDVDATOK
     C                   ADD       1             WId                                          CLE030
     C                   MOVEL     'DDVDAT'      WFldNmXAr(WId)                               CLE030
     C                   MOVEL     'LEL0114'     WMsgIDXAr(WId)                               CLE030
     C**********         ENDIF                                                        CLE030 BUG4351
     C                   EVAL      CCLLSTS = 'Q'                                              CLE030
     C                   ENDIF                                                                CLE030
     C                   ENDIF
      *
     C     TRCA          IFEQ      'TR'
      *
     C     CRAKEY        CHAIN     LEFCLTLD                           99
      *
      ***  If credit agreement facility record is not found, show
      ***  error message.
      *
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           DDFCUSOK
     C                   ADD       1             Idx
     C                   MOVEL     'LEL0134'     MsgIDXAr(Idx)
     C                   MOVEL     'DDFCUS'      FldNamXAr(Idx)
     C                   ENDIF
      *
     C     WSVVD         IFGT      AVLDB
     C     AVLDB         ANDNE     0
      *                                                                                       CLE030
      ** If CLE030 is off then this is an error                                               CLE030
      *                                                                                       CLE030
     C     CLE030        IFEQ      'N'                                                        CLE030
      *                                                                                     MD020605
     C                   IF        CLE134 = 'Y'                                             MD020605
     C                   SELECT                                                             MD020605
     C                   WHEN      %SUBST(DDLTYP:1:1) = 'X'                                 MD020605
     C                   MOVEL     'N'           WFAMU             1                        MD020605
     C                   WHEN      %SUBST(DDLTYP:1:1) = 'Y'                                 MD020605
     C                   EXSR      SrLFAMU                                                  MD020605
     C                   MOVEL     AYFAMU        WFAMU             1                        MD020605
     C                   ENDSL                                                              MD020605
      *                                                                                     MD020605
     C                   IF        WFAMU = 'Y'                                              MD020605
     C                   MOVE      'W'           DDVDATOK                                   MD020605
     C                   ADD       1             WId                                        MD020605
     C                   MOVEL     'DDVDAT'      WFldNmXAr(WId)                             MD020605
     C                   MOVEL     'LEL0521'     WMsgIDXAr(WId)                             MD020605
     C                   ENDIF                                                              MD020605
     C                   GOTO      SKIP1                                                    MD020605
      *                                                                                     MD020605
     C                   ENDIF                                                              MD020605
      *                                                                                     MD020605
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0518'     MsgIDXAr(Idx)
      *                                                                                       CLE030
      ** If CLE030 is on then this should be a warning                                        CLE030
      *                                                                                       CLE030
     C                   ELSE                                                                 CLE030
     C**********         Z-ADD     WSVVD         W1SVVD                               CLE030 BUG4351
     C                   MOVE      'W'           DDVDATOK                                     CLE030
     C                   ADD       1             WId                                          CLE030
     C                   MOVEL     'DDVDAT'      WFldNmXAr(WId)                               CLE030
     C                   MOVEL     'LEL0521'     WMsgIDXAr(WId)                               CLE030
     C                   EVAL      CCLLSTS = 'Q'                                              CLE030
     C                   ENDIF                                                                CLE030
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C     SKIP1         TAG                                                                MD020605
      *
      ***  Deal date must be earlier than or equal to value date
      *
     C     WSVDD         IFGT      WSVVD
     C                   MOVE      'N'           DDDDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0028'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ***  Issue warning if loan or part purchased is being inserted
      ***  against a syndicated facility.
      ***  Skip this part if CLE106 Syndications Manager is available                         CLE106
      *
     C     DDACTN        IFEQ      'I'
     C     DDFCUSOK      ANDNE     'N'
     C     *IN83         ANDEQ     '0'
     C     RespMode      ANDEQ     'S'
     C     CLE106        ANDEQ     'N'                                                        CLE106
      *
     C*****WE232         IFEQ      *BLANK                                                    BUG4351
     C*****WE232         OREQ      'Y'                                                       BUG4351
     C*****DDFCUS        ANDNE     W1CNUM                                                    BUG4351
     C*****WE232         OREQ      'Y'                                                       BUG4351
     C*****DDFTYP        ANDNE     W1FACT                                                    BUG4351
     C*****WE232         OREQ      'Y'                                                       BUG4351
     C*****DDFSEQ        ANDNE     W1FCNO                                                    BUG4351
     C**********         MOVE      DDFCUS        W1CNUM            6                         BUG4351
     C**********         MOVE      DDFTYP        W1FACT            3                         BUG4351
     C**********         MOVE      DDFSEQ        W1FCNO            2                         BUG4351
      *
     C     SYINF         IFEQ      'Y'
     C**********         MOVE      'Y'           WE232                                       BUG4351
     C                   MOVE      'W'           DDFCUSOK
     C                   ADD       1             WId
     C                   MOVEL     'DDFCUS'      WFldNmXAr(WId)
     C                   MOVEL     'LEM0232'     WMsgIDXAr(WId)
     C                   ENDIF
     C**********         ENDIF                                                               BUG4351
     C                   ENDIF
      *
      ***  Issue a warning message if facility amount has been
      ***  exceeded, (for loans and parts purchased)
      *
     C     DDFCUSOK      IFNE      'N'
     C     DDCURROK      ANDNE     'N'
     C     DDCPAMOK      ANDNE     'N'
     C     DDVDATOK      ANDNE     'N'
     C     *IN83         ANDEQ     '0'
     C     WSVAM         ANDGT     *ZEROS
      *
      ***  Check if this is an Internal Part Purchased.  If it is, amount
      ***  validation should be against the internal customer's facility.
      ***  (If IPP, Mirror Loan No. will be valid).
      *
     C     DDMLNROK      IFNE      'N'
     C     DDMLNR        ANDNE     *BLANKS
     C     DDMLNR        ANDNE     '000000'
                                                                                            BUG10825
      ** If multi-brach, get facility branch details                                        BUG10825
                                                                                            BUG10825
     C                   IF        BGMBIN = 'Y'                                             BUG10825
     C                   CALL      'AOBRCHR1'                                               BUG10825
     C                   PARM      *BLANKS       @RTCD                                      BUG10825
     C                   PARM      '*KEY   '     @OPTN                                      BUG10825
     C                   PARM      BRCAF         @BRCD                                      BUG10825
     C     SDBRCH        PARM      SDBRCH        DSSDY                                      BUG10825
     C     @RTCD         IFNE      *BLANKS                                                  BUG10825
     C     *LOCK         IN        LDA                                                      BUG10825
     C                   EVAL      DBFILE = 'SDBRCHPD'                                      BUG10825
     C                   EVAL      DBASE = 19                                               BUG10825
     C                   EVAL      DBKEY = @BRCD                                            BUG10825
     C                   OUT       LDA                                                      BUG10825
     C                   EXSR      *PSSR                                                    BUG10825
     C                   ENDIF                                                              BUG10825
     C                   ENDIF                                                              BUG10825
                                                                                            BUG10825
     C                   MOVE      BRCAF         K#BRCA
     C                   MOVE      DDFCUS        K#PMFC
     C                   MOVE      DDFTYP        K#PMFT
     C                   MOVE      DDFSEQ        K#PMFN
     C                   MOVE      A8BICN        K#CNUM
     C     K#FUND        CHAIN     LEFCLTL2                           99
      *
      ***  If record not found, there is no Internal Participant - Error
      *
     C     *IN99         IFEQ      *ON
     C                   MOVE      'N'           DDFCUSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFCUS'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0293'     MsgIDXAr(Idx)
     C                   ELSE
      *
      ***  If CHAIN was successful, must access FCLTYFN details too.
      *
     C     DDACTN        IFEQ      'I'
      *
      ***  Save value
      *
     C**********         MOVE      DDMLNR        WSMLNR            6 0                        CLE148
     C                   MOVE      DDMLNR        WSMLNR            6                          CLE148
      *
      ***  Search for the mirror loan in CLOANCL and get the loan's
      ***  current principal amount and part sold amount.
      *
     C     1             SETLL     CLOANLJ
     C                   READ      CLOANLJ                                99
      *
     C     *IN99         DOWEQ     '0'
      *
     C     WSMLNR        IFEQ      LNRFX
     C                   Z-ADD     CPAMX         WCPAMX           13 0
     C                   Z-ADD     PSAMX         WPSAMX           13 0
     C                   MOVE      '1'           *IN99
     C                   ELSE
     C                   READ      CLOANLJ                                99
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   MOVE      '0'           *IN99
      *
     C     WSMLNR        SETLL     LOAMS
     C     WSMLNR        READE     LOAMS                                  99
      *
     C     *IN99         DOWEQ     '0'
     C     VDATA         ANDLE     WSVVD
      *
     C     RECIA         IFEQ      'D'
      *
     C     AMTPA         IFEQ      'PI'
     C     AMTPA         OREQ      'PT'
     C                   ADD       PRAM          WCPAMX
     C                   ENDIF
      *
     C     AMTPA         IFEQ      'PF'
     C     AMTPA         OREQ      'RE'
     C     AUTO          ANDEQ     'Y'
      *                                                                                       CLE134
     C     AMTPA         OREQ      'RE'                                                       CLE134
     C     AUTO          ANDEQ     'C'                                                        CLE134
     C     CLE134        ANDEQ     'Y'                                                        CLE134
      *                                                                                       CLE134
     C     AMTPA         OREQ      'MR'
     C                   SUB       PRAM          WCPAMX
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     WSMLNR        READE     LOAMS                                  99
     C                   ENDDO
      *
      ***  Search for loans attached to the mirror loan number to get the
      ***  loan's available amount to date.
      *
     C                   MOVE      '0'           *IN99
     C     1             SETLL     CLOANLJ
     C                   READ      CLOANLJ                                99
      *
     C     *IN99         DOWEQ     '0'
      *
     C     RECIX         IFEQ      'D'
      *
     C                   EVAL      OLNOAlpha = OLNOX                                          CSD027
     C*****WSMLNR        IFEQ      OLNOX                                                      CSD027
     C     WSMLNR        IFEQ      OLNONum                                                    CSD027
     C     WSMLNR        OREQ      MLNRX
      *
      ***  Check for the amendments made against the participations sold
      ***  loan/ IPP loan.
      *
     C                   MOVE      '0'           *IN99
      *
     C     LNRFX         SETLL     LOAMS
     C     LNRFX         READE     LOAMS                                  99
      *
      ***  Check the amendments for the loan with value date less than or
      ***  equal to the loan's (to be inserted) value date.
      *
     C     *IN99         DOWEQ     '0'
     C     VDATA         ANDLE     WSVVD
      *
     C     RECIA         IFEQ      'D'
      *
      ***  for loans attached to the original/mirror loan, if amendment
      ***  type is PI, add the principal amount to the loan's CPAM then
      ***  add the same amount to the orignal/mirror loan's part sold
      *
     C     AMTPA         IFEQ      'PI'
     C                   ADD       PRAM          CPAMX
     C                   ADD       PRAM          WPSAMX
     C                   ENDIF
      *
      ***  If amendment type is PT, add the amount to the loan's CPAM
      ***  PSAM should not be updated because it was already updated in
      ***  menu PTMN.
      *
     C     AMTPA         IFEQ      'PT'
     C                   ADD       PRAM          CPAMX
     C                   ENDIF
      *
      ***  If amendment type is PF, deduct the amount to the loan's CPAM
      ***  PSAM should not be updated because it was already updated in
      ***  menu PTMN.
      *
     C     AMTPA         IFEQ      'PF'
     C                   SUB       PRAM          CPAMX
     C                   ENDIF
      *
      ***  If AMTP is MR/RE, deduct amount from loan's CPAM and from the
      ***  orginal/mirror loan's PSAM.
      *
     C     AMTPA         IFEQ      'RE'
     C     AUTO          ANDEQ     'Y'
      *                                                                                       CLE134
     C     AMTPA         OREQ      'RE'                                                       CLE134
     C     AUTO          ANDEQ     'C'                                                        CLE134
     C     CLE134        ANDEQ     'Y'                                                        CLE134
      *                                                                                       CLE134
     C     AMTPA         OREQ      'MR'
     C                   SUB       PRAM          CPAMX
     C                   SUB       PRAM          WPSAMX
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     LNRFX         READE     LOAMS                                  99
     C                   ENDDO
      *
     C                   MOVE      '0'           *IN99
      *
     C     MDATX         IFLE      WSVVD
     C     MDATX         ANDGT     0
     C     AUTOX         ANDEQ     'Y'
      *                                                                                       CLE134
     C     MDATX         ORLE      WSVVD                                                      CLE134
     C     MDATX         ANDGT     0                                                          CLE134
     C     AUTOX         ANDEQ     'C'                                                        CLE134
     C     CLE134        ANDEQ     'Y'                                                        CLE134
      *                                                                                       CLE134
      *
      ***  Subtract principal amount of maturing part sold loan from the
      ***  original loan's part sold amount.
      *
     C     WPSAMX        SUB       CPAMX         WPSAMX
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      CLOANLJ                                99
     C                   ENDDO
      *
     C     WCPAMX        SUB       WPSAMX        WCPAMX
      *
     C     WSVAM         IFGT      WCPAMX
     C                   MOVE      'N'           DDCPAMOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCPAM'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0119'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVE      CNUM          WFCNUM
     C                   MOVE      FACT          WFFACT
     C                   MOVE      FCNO          WFFCNO
     C                   MOVE      'B'           WFRCTP
     C     WKFAC         CHAIN(N)  FCLTY                              99
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVE      FCCYF         @CYCD
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CYCD
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
     C                   MOVEL     @CYCD         DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
E004 C                   ENDIF
      *
      ***  Determine cross rate and mult/div indicator
      *
     C                   Z-ADD     A6NBDP        WCDPF             1 0
      *                                                                                       CLE023
      ** Save currency details.                                                               CLE023
      *                                                                                       CLE023
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C                   MOVE      @CYCD         ZCCYO                                        CLE023
     C                   Z-ADD     A6SPRT        ZRATE2                                       CLE023
     C                   MOVE      A6MDIN        ZMDI2                                        CLE023
     C                   Z-ADD     A6NBDP        ZCDPO                                        CLE023
     C                   ENDIF                                                                CLE023
      *                                                                                       CLE023
     C                   SELECT
     C     FCCYF         WHENNE    BJCYCD
     C     A6MDIN        IFEQ      'M'
     C                   MOVE      'D'           WFMIN             1
     C                   ELSE
     C                   MOVE      'M'           WFMIN
     C                   ENDIF
     C     A6MDIN        IFEQ      'M'
     C     WSVIN         ANDEQ     'M'
     C     A6MDIN        OREQ      'D'
     C     WSVIN         ANDEQ     'D'
     C     A6SPRT        DIV(H)    WSVRT         WSVFX
     C                   ELSE
     C     A6SPRT        MULT(H)   WSVRT         WSVFX
     C                   ENDIF
     C                   MOVE      'Y'           WFLAG
      *
     C                   OTHER
     C                   Z-ADD     WSVRT         WSVFX
     C     WSVIN         IFEQ      'M'
     C                   MOVE      'N'           WFLAG             1
     C                   MOVE      'M'           WFMIN
     C                   ELSE
     C                   MOVE      'Y'           WFLAG
     C                   MOVE      'D'           WFMIN
     C                   ENDIF
     C                   ENDSL
      *
      ***  Determine facility currency equivalent
      *
     C                   MOVE      CMDI          WFCMDI            1
     C                   Z-ADD     CAXR          WFCAXR           13 8
     C                   EXSR      SRFEQV
     C                   MOVE      FCCYF         ZCCY
     C                   MOVE      ' '           ZFREQ
     C                   Z-ADD     0             ZMDAY
     C                   Z-ADD     99999         ENDAY             5 0
     C                   Z-ADD     WSVVD         DAYNO             5 0
     C                   MOVE      *BLANK        ZLOC
     C                   Z-ADD     WOPAMF        FCBAL            13 0
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C                   ADD       WFLTIF        FCBAL                                       BUG3721
     C                   ADD       WCHGAF        FCBAL                                       BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   MOVE      'A'           WFUPD             1
     C                   MOVE      'Y'           WFUAV             1
     C                   Z-ADD     FCBAL         WRK13            13 0
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C                   Z-ADD     WXSVAM        FXCBAL           13 0                        CLE023
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C                   ADD       WFLTIF        FXCBAL                                      BUG3721
     C                   ADD       WCHGAF        FXCBAL                                      BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   Z-ADD     FXCBAL        WRK14            13 0                        CLE023
     C                   ENDIF                                                                CLE023
     C     DDACTN        IFEQ      'I'
      * Call SRFUPD required to setup field WNOUP                                             CLE023
     C                   MOVE      *BLANK        WPRME             1                          CLE023
     C                   MOVE      *BLANK        WPART             1                          CLE023
     C     LPFI          IFNE      *BLANK                                                     CLE023
     C                   MOVE      'Y'           WPRME                                        CLE023
     C                   ENDIF                                                                CLE023
     C                   MOVE      '1'           WUPDT             1                          CLE023
     C                   EXSR      SRFUPD                                                     CLE023
     C                   EXSR      SRFEXP
     C                   ENDIF
      *
      ***  Consider facility amendments in determining facility
      ***  amount if CLE005 and CLE007 are installed
      *
     C     CLE005        IFEQ      'Y'
     C     CLE007        ANDEQ     'Y'
     C     WKFAM         SETLL     LEFCAML7
     C     WKFAM         READE     LEFCAML7                               99
     C     *IN99         DOWEQ     '0'
     C*****VLDT*         ANDLE     WSVVD                                                      247676
     C     VLDT          IFLE      WSVVD                                                      247676
     C     DDACTN        ORNE      'I'                                                        247676
     C     RUND          ANDGE     CCLORED                                                    247676
     C     CCLORED       ANDGT     0                                                          247676
     C     RUND          ANDGT     WSVVD                                                      247676
     C     VLDT          ANDGE     RUNS(1)                                                    247676
     C     FATP          IFEQ      'FI'
     C                   ADD       AAMT          FAMT
     C                   ELSE
     C                   SUB       AAMT          FAMT
     C                   ENDIF
     C                   ENDIF                                                                247676
     C     WKFAM         READE     LEFCAML7                               99
     C                   ENDDO
     C                   ENDIF
      *                                                                                       CLE158
     C                   MOVE      DDMDAT        ZDATE                                        CLE158
     C                   MOVE      BJDFIN        ZDATFM                                       CLE158
     C                   CALL      'ZDATE1'                                                   CLE158
     C                   PARM      *BLANKS       ZERR                                         CLE158
     C                   PARM                    ZDATE                                        CLE158
     C                   PARM                    ZDATFM                                       CLE158
     C                   PARM                    ZDAYNO                                       CLE158
      *                                                                                       CLE158
     C                   Z-ADD     ZDAYNO        WMDAT2            5 0                        CLE158
      *                                                                                       CLE158
      ** Call program to check for facility exceeded amount from                              CLE158
      ** value date (Only applicable if CLE025 is OFF)                                        CLE158
      *                                                                                       CLE158
     C                   IF        CLE158 = 'Y'                                               CLE158
     C                             and CLE025 = 'N'                                           CLE158
     C                             and DDACTN = 'I'                                           CLE158
     C                             and WSVVD >= BJRDNB                                        CLE158
     C                             and LoanType = 'LOAN'                                      CLE158
      *                                                                                       CLE158
     C                             OR CLE158 = 'Y'                                            CLE158
     C                             and CLE025 = 'N'                                           CLE158
     C                             and DDACTN = 'I'                                           CLE158
     C                             and WSVVD >= BJRDNB                                        CLE158
     C                             and LoanType = 'PTPU'                                      CLE158
      *                                                                                     MD027418
     C                             OR CLE158 = 'Y'                                          MD027418
     C                             and CLE025 = 'N'                                         MD027418
     C                             and DDACTN = 'X'                                         MD027418
     C                             and @@CHTP = 'I'                                         MD027418
     C                             and WSVVD >= BJRDNB                                      MD027418
     C                             and LoanType = 'LOAN'                                    MD027418
      *                                                                                     MD027418
     C                             OR CLE158 = 'Y'                                          MD027418
     C                             and CLE025 = 'N'                                         MD027418
     C                             and DDACTN = 'X'                                         MD027418
     C                             and @@CHTP = 'I'                                         MD027418
     C                             and WSVVD >= BJRDNB                                      MD027418
     C                             and LoanType = 'PTPU'                                    MD027418
      *                                                                                       CLE158
     C                   MOVE      FACT          @FACT             3                          CLE158
     C                   MOVE      FCNO          @FCNO             2                          CLE158
     C                   MOVE      *BLANKS       DSAMTP            2                        MD027418
      *                                                                                       CLE158
     C                   CALL      'LE000630'                                                 CLE158
     C                   PARM                    CNUMF                                        CLE158
     C                   PARM                    @FACT                                        CLE158
     C                   PARM                    @FCNO                                        CLE158
     C                   PARM                    WSVVD                                        CLE158
     C                   PARM                    WMDAT2                                    MD025837A
     C                   PARM                    FCBAL                                        CLE158
     C                   PARM                    NDayFwd                                      CLE158
     C                   PARM                    DDACTN                                     MD027418
     C                   PARM                    DDLNRF                                     MD027418
     C                   PARM                    DSAMTP                                     MD027418
     C                   PARM      *BLANKS       @PRTCD            1                          CLE158
      *                                                                                       CLE158
      ** If the transaction amount causes the available amount of the                         CLE158
      ** Fcty/Tranche to be exceeded for any of the next NFwdDays                             CLE158
      ** business days from the value date of the transaction                                 CLE158
      ** --> Issue overridable error message                                                  CLE158
      *                                                                                       CLE158
     C     @PRTCD        IFEQ      'E'                                                        CLE158
     C                   MOVE      'W'           DDCPAMOK                                   MD026971
     C                   ADD       1             WId                                        MD026971
     C                   MOVEL     'DDCPAM'      WFldNmXAr(WId)                             MD026971
     C                   MOVEL     '5049116'     WMsgIDXAr(WId)                             MD026971
     C                   ENDIF                                                                CLE158
      *                                                                                       CLE158
      ** If the transaction causes the available amount of the                                CLE158
      ** Fcty/Tranche to be exceeded beyond the NDayFwd business day                          CLE158
      ** --> Issue warning message only                                                       CLE158
      *                                                                                       CLE158
     C     @PRTCD        IFEQ      'W'                                                        CLE158
     C                   MOVE      'W'           DDCPAMOK                                     CLE158
     C                   ADD       1             WId                                          CLE158
     C                   MOVEL     'DDCPAM'      WFldNmXAr(WId)                               CLE158
     C                   MOVEL     '5049117'     WMsgIDXAr(WId)                             MD026971
     C                   ENDIF                                                                CLE158
      *                                                                                       CLE158
     C                   ENDIF                                                                CLE158
      *
     C     OVPC          ADD       100           WRK85             8 5
     C                   DIV       100           WRK85
     C                   MULT(H)   WRK85         FAMT
     C                   Z-ADD     1             S
      *
      ** Perform old validation if CLE158 is off, or                                          CLE158
      ** is ON but value date is less than the run date.                                      CLE158
      *                                                                                       CLE158
     C     S             DOWLE     10
     C     RUNS(S)       ANDLE     DTEXF
     C     CLE158        ANDEQ     'N'                                                        CLE158
      *                                                                                       CLE158
     C     S             ORLE      NdayFwd                                                    CLE158
     C     RUNS(S)       ANDLE     DTEXF                                                      CLE158
     C     CLE158        ANDEQ     'Y'                                                        CLE158
     C     WSVVD         ANDLT     BJRDNB                                                     CLE158

     C     RUNS(S)       IFGE      WSVVD
     C     FAMT          ANDLT     OAM(S)
     C     WREAC         ANDEQ     *OFF
     C     CLE025        ANDEQ     'N'                                                        CLE025
     C     RUNS(S)       ORGE      WSVVD
     C     FAMT          ANDLT     WOAM
     C     WREAC         ANDEQ     *ON
     C     CLE025        ANDEQ     'N'                                                        CLE025
      *                                                                                       CLE030
      ** If CLE030 is switched on, then set loan status                                       CLE030
      ** (CCLLSTS) on valid file data structure to 'Requires Release'.                        CLE030
      *                                                                                       CLE030
     C     CLE030        IFEQ      'Y'                                                        CLE030
     C                   EVAL      CCLLSTS = 'Q'                                              CLE030
     C                   ENDIF                                                                CLE030

     C*****WE003         IFEQ      *BLANK                                                    BUG4351
     C*****WE003         OREQ      'Y'                                                       BUG4351
     C*****WSVAM         ANDNE     W1AM                                                      BUG4351
     C**********         Z-ADD     WSVAM         W1AM             13 0                       BUG4351
     C**********         MOVE      'Y'           WE003             1                         BUG4351
     C                   MOVE      'W'           DDCPAMOK
     C                   ADD       1             WId
     C                   MOVEL     'DDCPAM'      WFldNmXAr(WId)
     C     CLE158        IFEQ      'Y'                                                      MD052213
     C     WSVVD         ANDLT     BJRDNB                                                   MD052213
     C                   MOVEL     '5049116'     WMsgIDXAr(WId)                             MD052213
     C                   ELSE                                                               MD052213
     C                   MOVEL     'LEL0069'     WMsgIDXAr(WId)
     C                   ENDIF                                                              MD052213
      *                                                                                     MD052213
     C                   LEAVE
     C**********         ENDIF                                                               BUG4351
      *                                                                                       CLE030
     C     WREAC         IFEQ      *ON
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ADD       1             S
     C                   ENDDO
      *
      ***  If Internal Part. Purch., restore original borrower's facility
      ***  details.
      *
     C     DDMLNROK      IFNE      'N'
     C     DDMLNR        ANDNE     *BLANKS
     C                   MOVE      DDFCUS        WFCNUM
     C                   MOVE      DDFTYP        WFFACT
     C                   MOVE      DDFSEQ        WFFCNO
     C                   MOVE      'A'           WFRCTP
     C     WKFAC         CHAIN(N)  FCLTY                              99
     C                   ENDIF
      *
     C                   ENDIF
      *
      ***  Determine if the Credit agreement amount will be exceeded.
      *
     C     DDFCUSOK      IFNE      'N'
     C     DDCURROK      ANDNE     'N'
     C     DDCPAMOK      ANDNE     'N'
     C     DDVDATOK      ANDNE     'N'
     C     *IN83         ANDEQ     '0'
     C     WSVAM         ANDGT     *ZEROS
      *
     C     CRAKEY        CHAIN     LEFCLTLC                           99
      *
     C     *IN99         IFEQ      *OFF
      *
      ** Get Credit agreement currency details
      *
     C                   MOVE      FCCYB         @CYCD
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CYCD
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   Z-ADD     13            DBASE                          * DBERR 002 *
     C                   MOVEL     @CYCD         DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Determine cross rate and mult/div indicator
      *
     C                   Z-ADD     A6NBDP        WCDPF             1 0
      *
      ** Save currency details.
      *
     C     CLE023        IFEQ      'Y'
     C                   MOVE      @CYCD         ZCCYO
     C                   Z-ADD     A6SPRT        ZRATE2
     C                   MOVE      A6MDIN        ZMDI2
     C                   Z-ADD     A6NBDP        ZCDPO
     C                   ENDIF
      *
     C                   SELECT
     C     FCCYB         WHENNE    BJCYCD
     C     A6MDIN        IFEQ      'M'
     C                   MOVE      'D'           WFMIN             1
     C                   ELSE
     C                   MOVE      'M'           WFMIN
     C                   ENDIF
     C     A6MDIN        IFEQ      'M'
     C     WSVIN         ANDEQ     'M'
     C     A6MDIN        OREQ      'D'
     C     WSVIN         ANDEQ     'D'
     C     A6SPRT        DIV(H)    WSVRT         WSVFX
     C                   ELSE
     C     A6SPRT        MULT(H)   WSVRT         WSVFX
     C                   ENDIF
     C                   MOVE      'Y'           WFLAG
      *
     C                   OTHER
     C                   Z-ADD     WSVRT         WSVFX
     C     WSVIN         IFEQ      'M'
     C                   MOVE      'N'           WFLAG             1
     C                   MOVE      'M'           WFMIN
     C                   ELSE
     C                   MOVE      'Y'           WFLAG
     C                   MOVE      'D'           WFMIN
     C                   ENDIF
     C                   ENDSL
      *
      ***  Determine credit agreement ccy equivalent
      *
     C                   MOVE      CMDI          WFCMDI            1
     C                   Z-ADD     CAXR          WFCAXR           13 8
     C                   EXSR      SRFEQVCA
     C                   MOVE      FCCYB         ZCCY
     C                   MOVE      ' '           ZFREQ
     C                   Z-ADD     0             ZMDAY
     C                   Z-ADD     99999         ENDAY             5 0
     C                   Z-ADD     WSVVD         DAYNO             5 0
     C                   MOVE      *BLANK        ZLOC
     C                   Z-ADD     WOPAMF        FCBAL            13 0
     C                   MOVE      'A'           WFUPD             1
     C                   MOVE      'Y'           WFUAV             1
     C                   Z-ADD     FCBAL         WRK13            13 0
     C     CLE023        IFEQ      'Y'
     C                   Z-ADD     WXSVAM        FXCBAL           13 0
     C                   Z-ADD     FXCBAL        WRK14            13 0
     C                   ENDIF
      *
      ***  Consider facility amendments in determining facility
      ***  amount if CLE005 and CLE007 are installed
      *
     C     CLE005        IFEQ      'Y'
     C     CLE007        ANDEQ     'Y'
     C     WKFAM3        SETLL     LEFCAML7
     C     WKFAM3        READE     LEFCAML7                               99
     C     *IN99         DOWEQ     '0'
     C     VLDT          ANDLE     WSVVD
     C     FATP          IFEQ      'FI'
     C                   ADD       AAMT          FAMTB
     C                   ELSE
     C                   SUB       AAMT          FAMTB
     C                   ENDIF
     C     WKFAM3        READE     LEFCAML7                               99
     C                   ENDDO
     C                   ENDIF
      *
      ** Call program to check for facility exceeded amount from                              CLE158
      ** value date (Only applicable if CLE025 is OFF)                                        CLE158
      *                                                                                       CLE158
     C                   IF        CLE158 = 'Y'                                               CLE158
     C                             and CLE025 = 'N'                                           CLE158
     C                             and DDACTN = 'I'                                           CLE158
     C                             and WSVVD >= BJRDNB                                        CLE158
     C                             and LoanType = 'LOAN'                                      CLE158
      *                                                                                       CLE158
     C                             OR CLE158 = 'Y'                                            CLE158
     C                             and CLE025 = 'N'                                           CLE158
     C                             and DDACTN = 'I'                                           CLE158
     C                             and WSVVD >= BJRDNB                                        CLE158
     C                             and LoanType = 'PTPU'                                      CLE158
      *                                                                                       CLE158
     C                             OR CLE158 = 'Y'                                            CLE158
     C                             and CLE025 = 'N'                                           CLE158
     C                             and DDACTN = 'X'                                           CLE158
     C                             and @@CHTP = 'I'                                           CLE158
     C                             and WSVVD >= BJRDNB                                        CLE158
     C                             and LoanType = 'LOAN'                                      CLE158
      *                                                                                       CLE158
     C                             OR CLE158 = 'Y'                                            CLE158
     C                             and CLE025 = 'N'                                           CLE158
     C                             and DDACTN = 'X'                                           CLE158
     C                             and @@CHTP = 'I'                                           CLE158
     C                             and WSVVD >= BJRDNB                                        CLE158
     C                             and LoanType = 'PTPU'                                      CLE158
      *                                                                                       CLE158
     C                   MOVE      CAFT          @FACT                                        CLE158
     C                   MOVE      CAFN          @FCNO                                        CLE158
     C                   MOVE      *BLANKS       DSAMTP            2                          CLE158
      *                                                                                       CLE158
     C                   CALL      'LE000630'                                                 CLE158
     C                   PARM                    CNUMF                                        CLE158
     C                   PARM                    @FACT                                        CLE158
     C                   PARM                    @FCNO                                        CLE158
     C                   PARM                    WSVVD                                        CLE158
     C                   PARM                    WMDAT2                                       CLE158
     C                   PARM                    FCBAL                                        CLE158
     C                   PARM                    NDayFwd                                      CLE158
     C                   PARM                    DDACTN                                       CLE158
     C                   PARM                    DDLNRF                                       CLE158
     C                   PARM                    DSAMTP                                       CLE158
     C                   PARM      *BLANKS       @PRTCD            1                          CLE158
      *                                                                                       CLE158
      ** If the transaction amount causes the available amount of the                         CLE158
      ** Fcty/Tranche to be exceeded for any of the next NFwdDays                             CLE158
      ** business days from the value date of the transaction                                 CLE158
      ** --> Issue overridable error message                                                  CLE158
      *                                                                                       CLE158
     C     @PRTCD        IFEQ      'E'                                                        CLE158
     C                   MOVE      'W'           DDCPAMOK                                     CLE158
     C                   ADD       1             WId                                          CLE158
     C                   MOVEL     'DDCPAM'      WFldNmXAr(WId)                               CLE158
     C                   MOVEL     '5049118'     WMsgIDXAr(WId)                               CLE158
     C                   ENDIF                                                                CLE158
      *                                                                                       CLE158
      ** If the transaction causes the available amount of the                                CLE158
      ** Fcty/Tranche to be exceeded beyond the NDayFwd business day                          CLE158
      ** --> Issue warning message only                                                       CLE158
      *                                                                                       CLE158
     C     @PRTCD        IFEQ      'W'                                                        CLE158
     C                   MOVE      'W'           DDCPAMOK                                     CLE158
     C                   ADD       1             WId                                          CLE158
     C                   MOVEL     'DDCPAM'      WFldNmXAr(WId)                               CLE158
     C                   MOVEL     '5049119'     WMsgIDXAr(WId)                               CLE158
     C                   ENDIF                                                                CLE158
      *                                                                                       CLE158
     C                   ENDIF                                                                CLE158
      *                                                                                       CLE158
     C     OVPC          ADD       100           WRK85             8 5
     C                   DIV       100           WRK85
     C                   MULT(H)   WRK85         FAMTB
      *
     C                   Z-ADD     1             S
     C                   Z-ADD     0             WTSUM            13 0
      *                                                                                       CLE158
      ** Perform old validation if CLE158 is off, or                                          CLE158
      ** is ON but value date is less than the run date.                                      CLE158
      *                                                                                       CLE158
     C     S             DOWLE     10
     C     CLE025        ANDEQ     'N'                                                        CLE025
     C     CLE158        ANDEQ     'N'                                                        CLE158
      *                                                                                       CLE158
     C     S             ORLE      NdayFwd                                                    CLE158
     C     CLE025        ANDEQ     'N'                                                        CLE158
     C     CLE158        ANDEQ     'Y'                                                        CLE158
     C     WSVVD         ANDLT     BJRDNB                                                     CLE158
      *                                                                                       CLE158
     C     CRAKEY        CHAIN     LEFCLTLC                           99
      *
     C*****OAMD(S)*******ADD       WSVAM         WTSUM
     C                   IF        DDACTN = 'I'                                               240342
     C     OAMD(S)       ADD       WOPAMF        WTSUM
     C                   ENDIF                                                                240342
      *
     C     RUNSD(S)      IFGE      WSVVD
     C     WTSUM         ANDGT     FAMTB
      *                                                                                       CLE030
      ** If CLE030 is switched on, then set loan status                                       CLE030
      ** (CCLLSTS) on valid file data structure to 'Requires Release'.                        CLE030
      *                                                                                       CLE030
     C     CLE030        IFEQ      'Y'                                                        CLE030
     C                   EVAL      CCLLSTS = 'Q'                                              CLE030
     C                   ENDIF                                                                CLE030

     C*****WE004         IFEQ      *BLANK                                                    BUG4351
     C*****WE004         OREQ      'Y'                                                       BUG4351
     C*****WSVAM         ANDNE     WOSVAM                                                    BUG4351
     C*****WE004         OREQ      'Y'                                                       BUG4351
     C*****WSVVD         ANDNE     WOSVVD                                                    BUG4351
     C*****WE004         OREQ      'Y'                                                       BUG4351
     C*****WSVFX         ANDNE     WOSVFX                                                    BUG4351
     C**********         Z-ADD     WSVAM         WOSVAM           13 0                       BUG4351
     C**********         Z-ADD     WSVVD         WOSVVD            5 0                       BUG4351
     C**********         Z-ADD     WSVFX         WOSVFX           13 8                       BUG4351
     C**********         MOVE      'Y'           WE004             1                         BUG4351
     C                   MOVE      'W'           DDCPAMOK
     C                   ADD       1             WId
     C                   MOVEL     'DDCPAM'      WFldNmXAr(WId)
     C     CLE158        IFEQ      'Y'                                                      MD052213
     C     WSVVD         ANDLT     BJRDNB                                                   MD052213
     C                   MOVEL     '5049118'     WMsgIDXAr(WId)                             MD052213
     C                   ELSE                                                               MD052213
     C                   MOVEL     'LEL0520'     WMsgIDXAr(WId)
     C                   ENDIF                                                              MD052213
      *                                                                                     MD052213
     C                   LEAVE
     C**********         ENDIF                                                               BUG4351
      *
     C                   ENDIF
     C                   ADD       1             S
     C                   Z-ADD     0             WTSUM
     C                   ENDDO
      *
     C                   ENDIF
     C                   ENDIF
      *
      ***  Facility amount corrupted. Need to deduct amount after
      ***  validation.
      *
     C                   MOVE      'Y'           NYET              1
      *
     C                   MOVE      'S'           WFUPD
     C                   MOVE      'Y'           WFUAV
     C                   Z-ADD     FCBAL         WRK13
     C                   MOVE      ' '           WNOUP             1                          CLE023
     C                   EXSR      SRFEXP
      *
     C                   MOVE      'N'           NYET
      *
     C     DDFCUSOK      IFNE      'N'
     C     DDFTYPOK      ANDNE     'N'
     C     DDFSEQOK      ANDNE     'N'
     C     DDVDATOK      ANDNE     'N'
     C     DDCPAMOK      ANDNE     'N'
     C                   Z-ADD     WSVVD         CCLVDAT
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRCSI  -  Validate the recourse indicator                    *
      *            (for parts purchased/sold only)                    *
      *****************************************************************
     C     SRRCSI        BEGSR
      *
     C     *IN82         IFEQ      '1'
     C     *IN83         OREQ      '1'
     C     DDRCSI        IFEQ      *BLANK
     C                   MOVE      'N'           DDRCSI
     C                   ELSE
     C     DDRCSI        IFNE      'Y'
     C     DDRCSI        ANDNE     'N'
     C                   MOVE      'N'           DDRCSIOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRCSI'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0173'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  Do not allow recourse indicator = 'Y' if Risk Purchased/Sold
      *
     C*****DDRCSIOK      IFNE      'N'                                                      BUG22318
     C*****DDRCSI        ANDEQ     'Y'                                                      BUG22318
     C*****WLNPT         IFEQ      71                                                       BUG22318
     C*****WLNPT         OREQ      72                                                       BUG22318
     C**********         MOVE      'N'           DDRCSIOK                                   BUG22318
     C**********         ADD       1             Idx                                        BUG22318
     C**********         MOVEL     'DDRCSI'      FldNamXAr(Idx)                             BUG22318
     C**********         MOVEL     'LEL0507'     MsgIDXAr(Idx)                              BUG22318
     C**********         ENDIF                                                              BUG22318
     C**********         ENDIF                                                              BUG22318
      *
     C                   ENDIF
      *
     C                   ELSE
     C**********         MOVE      'N'           DDRCSI                                       CLE106
                                                                                              CLE106
      ** Recourse Indicator is not allowed for main loans                                     CLE106
                                                                                              CLE106
     C                   IF        DDRCSI = 'Y'                                               CLE106
     C                   EVAL      DDRCSIOK = 'N'                                             CLE106
     C                   EVAL      Idx = Idx + 1                                              CLE106
     C                   EVAL      FldNamXAr(Idx) = 'DDRCSI'                                  CLE106
     C                   EVAL      MsgIDXAr(Idx) = 'LEL0429'                                  CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF
      *
     C     DDRCSIOK      IFNE      'N'
     C                   MOVEL     DDRCSI        CCLRCSI
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRMDAT  -  Validate the maturity date                         *
      *****************************************************************
     C     SRMDAT        BEGSR
      *
     C                   Z-ADD     *ZEROS        WSVMD
     C     DDMDAT        IFNE      *BLANKS
      *
      ** ... must be blank for call or demand loans during insert
      *
     C     DDACTN        IFEQ      'I'
     C     WLNPT         ANDEQ     61
     C     DDACTN        OREQ      'I'
     C     WLNPT         ANDEQ     68
     C     DDACTN        OREQ      'I'
     C     WLNPT         ANDEQ     69
     C     DDACTN        OREQ      'I'
     C     WLNPT         ANDEQ     72
     C     W72TP         ANDEQ     '69'
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0130'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  Must be numeric
      *
     C     DDMDATOK      IFNE      'N'
      *
     C                   MOVE      DDMDAT        ZDATE
     C                   MOVE      BJDFIN        ZDATFM
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR
     C                   PARM                    ZDATE
     C                   PARM                    ZDATFM
     C                   PARM                    ZDAYNO
      *
     C                   MOVEL     DDMDAT        WNUM7
     C                   MOVEL     WNUM7         WALF6
     C                   Z-ADD     ZDAYNO        WSVMD
B001 C     ZERR          IFNE      *BLANKS
     C     DDMDAT        ORNE      WALF6
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0128'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ***  For non-call/demand loans, maturity date must be input
      *
     C                   ELSE
     C     DDLTYPOK      IFNE      'N'
     C     DDSUTPOK      ANDNE     'N'
     C     DDCLASOK      ANDNE     'N'                                                        CLE042
     C     WLNPT         ANDNE     61
     C     WLNPT         ANDNE     68
     C     WLNPT         ANDNE     69
     C     WLNPT         ANDNE     72
     C     DDLTYPOK      ORNE      'N'
     C     DDSUTPOK      ANDNE     'N'
     C     DDCLASOK      ANDNE     'N'                                                        CLE042
     C     WLNPT         ANDEQ     72
     C     W72TP         ANDNE     '69'
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0128'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ***  If maturity date is valid and non-zero, continue with the
      ***  rest of the validation
      *
     C                   IF        DDMDATOK <> 'N' AND DDACTN <> 'I'                       MD022807C
     C                   IF        CLE134 = 'Y' AND                                        MD022807C
     C                             WSVMD <> @@MDAT AND                                     MD022807C
     C                             (%SUBST(DDLTYP:1:1) = 'X' OR                            MD022807C
     C                              %SUBST(DDLTYP:1:1) = 'Y' OR                            MD022807C
     C                              %SUBST(DDLTYP:1:1) = 'Z')                              MD022807C
      *                                                                                    MD022807C
      ** Maturity Date amendment is prohibited for PDCLs                                   MD022807C
      *                                                                                    MD022807C
     C                   MOVE      'N'           DDMDATOK                                  MD022807C
     C                   ADD       1             Idx                                       MD022807C
     C                   MOVEL     'DDMDAT'      FldNamXAr(Idx)                            MD022807C
     C                   MOVEL     '5046138'     MsgIDXAr(Idx)                             MD022807C
     C                   ENDIF                                                             MD022807C
     C                   ENDIF                                                             MD022807C
      *                                                                                    MD022807C
     C     DDMDATOK      IFNE      'N'
     C     WSVMD         ANDNE     *ZEROS
      *
      ***  Must be later than value date
      *
     C     DDVDATOK      IFNE      'N'
     C     WSVMD         ANDLE     WSVVD
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0129'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  Must be on or earlier than expiry date of facility
      *
     C     *IN83         IFEQ      '0'
     C     DDFCUSOK      ANDNE     'N'
     C*****WSVMD         ANDGT     DTEXF                                                      241198
     C     WREAC         IFEQ      *ON                                                        241198
     C     WSVMD         ANDGT     NDEX                                                       241198
     C     WREAC         OREQ      *OFF                                                       241198
     C     WSVMD         ANDGT     DTEXF                                                      241198
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0234'     MsgIDXAr(Idx)
     C                   ENDIF                                                                241198
     C                   ENDIF
      *
     C     DDACTN        IFNE      'I'
     C                   EXSR      SRMATY
      ***********                                                                 MD022807 MD022807C
      ***Check*PDCL*Maturity*Date*amendment****************************           MD022807 MD022807C
      ***********                                                                 MD022807 MD022807C
     C***********        IF        CLE134 = 'Y' AND                               MD022807 MD022807C
     C***********                  WSVMD <> @@MDAT AND                            MD022807 MD022807C
     C***********                  (%SUBST(DDLTYP:1:1) = 'X' OR                   MD022807 MD022807C
     C***********                   %SUBST(DDLTYP:1:1) = 'Y' OR                   MD022807 MD022807C
     C***********                   %SUBST(DDLTYP:1:1) = 'Z')                     MD022807 MD022807C
     C***********        EXSR      SRChckMat                                      MD022807 MD022807C
     C***********        ENDIF                                                    MD022807 MD022807C
      ***********                                                                 MD022807 MD022807C
     C                   ENDIF
     C                   ENDIF
      *
     C     DDMDATOK      IFNE      'N'
     C                   Z-ADD     WSVMD         CCLMDAT
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************                     MD020605
      /EJECT                                                                                MD020605
      *****************************************************************                     MD020605
      * SRLFAMU -  Extract FAMU Indicator from SDLOANPD               *                     MD020605
      *****************************************************************                     MD020605
      *                                                                                     MD020605
     C     SRLFAMU       BEGSR                                                              MD020605
     C                   MOVE      DDORLN        WALON                                      MD020605
     C                   MOVE      'A'           WEPAR                                      MD020605
     C     WKLON         CHAIN (N) CLOAN                              89                    MD020605
     C                   IF        *IN89 = '0'                                              MD020605
     C                   CALL      'AOLOANR1'                                               MD020605
     C                   PARM      *BLANKS       @RTCD                                      MD020605
     C                   PARM      '*KEY   '     @OPTN                                      MD020605
     C                   PARM                    LTYP                                       MD020605
     C                   PARM                    SUTP                                       MD020605
     C                   PARM                    DDCLAS                                     MD020605
     C     SDLOAN        PARM      SDLOAN        DSSDY                                      MD020605
     C                   ENDIF                                                              MD020605
      *                                                                                     MD020605
     C                   ENDSR                                                              MD020605
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRAPMI  -  Validate the auto-pay at maturity indicator        *
      *            (for S01465)                                       *
      *****************************************************************
     C     SRAPMI        BEGSR
      *
     C     S01465        IFEQ      'Y'
      *
     C     DDAPMI        IFNE      *BLANK
     C     DDAPMI        ANDNE     'Y'
     C     DDAPMI        ANDNE     'N'
     C                   MOVE      'N'           DDAPMIOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAPMI'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0111'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ** ... cannot be changed from 'Y' to 'N' if telex has been prod
      *
     C     DDAPMIOK      IFNE      'N'
     C     DDACTN        ANDEQ     'A'
     C     @@APMI        ANDEQ     'Y'
     C     DDAPMI        ANDEQ     'N'
     C                   TESTB     '1'           @@TLXI                   99
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           DDAPMIOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDAPMI'      FldNamXAr(Idx)
     C**********         MOVEL     'LEL0117'     MsgIDXAr(Idx)                                237744
     C                   MOVEL     'LEL0538'     MsgIDXAr(Idx)                                237744
     C                   ENDIF
     C                   ENDIF
      *
     C     DDAPMIOK      IFNE      'N'
     C     DDAPMI        ANDEQ     *BLANK
     C                   MOVE      'Y'           DDAPMI
     C                   ENDIF
     C     DDAPMIOK      IFNE      'N'
     C                   MOVEL     DDAPMI        CCLAPMI
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRMCRA  -  Validate the multi-currency rollovers allowed      *
      *****************************************************************
     C     SRMCRA        BEGSR
      *
     C     DDMCRA        IFEQ      *BLANK
     C                   MOVE      'N'           DDMCRA
     C******IN83         IFEQ      '1'                                                        241204
     C     MCRAM         IFNE      *BLANK                                                     241204
     C                   MOVE      MCRAM         DDMCRA
     C                   ENDIF
     C                   ENDIF
      *
     C     DDMCRA        IFNE      'Y'
     C     DDMCRA        ANDNE     'N'
     C     DDMCRA        OREQ      'Y'
     C     MCCYF         ANDNE     'Y'
     C     MCRAM         ANDEQ     *BLANK                                                     241204
     C******IN83         ANDEQ     '0'                                                        241204
     C*****LPFI          ANDNE     'I'                                                        241204
     C                   MOVE      'N'           DDMCRAOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMCRA'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0408'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  Check multi-currency indicator from its attached loan or
      ***  facility and display another error message.
      *
     C******IN83         IFEQ      '1'                                                        241204
     C*****DDOLNOOK      ANDNE     'N'                                                 CLE106 241204
     C*****LPFI          OREQ      'I'                                                        241204
     C     MCRAM         IFNE      *BLANK                                                     241204
     C     DDOLNOOK      ANDNE     'N'                                                        CLE106
     C     DDMCRA        IFNE      MCRAM
     C                   MOVE      'N'           DDMCRAOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMCRA'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0515'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
                                                                                             BUG3721
      ** MULTI-CURRENCY ROLLOVERS ALLOWED may not be 'Y' for Flat Rate                       BUG3721
      ** Personal Loans.                                                                     BUG3721
                                                                                             BUG3721
     C     DDMCRAOK      IFNE      'N'                                                       BUG3721
     C     DDMCRA        ANDEQ     'Y'                                                       BUG3721
     C     WLNPT         ANDEQ     80                                                        BUG3721
     C     CLE028        ANDEQ     'Y'                                                       BUG3721
     C                   MOVE      'N'           DDMCRAOK                                    BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   MOVEL     'DDMCRA'      FldNamXAr(Idx)                              BUG3721
     C                   MOVEL     'LEL0545'     MsgIDXAr(Idx)                               BUG3721
     C                   ENDIF                                                               BUG3721
      *
      ***  MCRA should be 'Y' for Parts Sold if original loan has
      ***  multi-ccy details
      *
     C     *IN83         IFEQ      '1'
     C     DDACTN        ANDEQ     'I'
     C     DDMCRA        ANDEQ     'N'
     C     NCCYM         ANDNE     *BLANKS
     C     NCCYM         ANDNE     CCYM
     C                   MOVE      'N'           DDMCRAOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMCRA'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0509'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C     DDMCRAOK      IFNE      'N'
     C                   MOVEL     DDMCRA        CCLMCRA
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRLDT  -  Validate the rollover date                         *
      *****************************************************************
     C     SRRLDT        BEGSR
      *
     C                   Z-ADD     *ZEROS        WSVRD
      *
     C     DDACTN        IFEQ      'I'
      *
      ***  Must be blank for discount loans
      ***  and participations
      *
     C     DDRLDT        IFNE      *BLANKS
     C                   DO
      *
     C     WLNPT         IFEQ      63
     C     DDACTN        ANDEQ     'I'
     C     WLNPT         OREQ      65
     C     DDACTN        ANDEQ     'I'
     C     WLNPT         OREQ      67
     C     DDACTN        ANDEQ     'I'
     C     WLNPT         OREQ      72
     C     W72TP         ANDNE     '66'
     C     W72TP         ANDNE     '69'
     C     W72TP         ANDNE     '70'
     C                   MOVE      'N'           DDRLDTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRLDT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0272'     MsgIDXAr(Idx)
     C                   LEAVE
     C                   ENDIF
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     WLNPT         IFEQ      80                                                        BUG3721
     C     DDACTN        ANDEQ     'I'                                                       BUG3721
     C                   MOVE      'N'           DDRLDTOK                                    BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   MOVEL     'DDRLDT'      FldNamXAr(Idx)                              BUG3721
     C                   MOVEL     'LEL0545'     MsgIDXAr(Idx)                               BUG3721
     C                   LEAVE                                                               BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
      *
     C                   MOVE      DDRLDT        ZDATE
     C                   MOVE      BJDFIN        ZDATFM
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR
     C                   PARM                    ZDATE
     C                   PARM                    ZDATFM
     C                   PARM                    ZDAYNO
      *
     C                   MOVEL     DDRLDT        WNUM7
     C                   MOVEL     WNUM7         WALF6
     C                   Z-ADD     ZDAYNO        WSVRD
B001 C     ZERR          IFNE      *BLANKS
     C     DDRLDT        ORNE      WALF6
     C                   MOVE      'N'           DDRLDTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRLDT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0151'     MsgIDXAr(Idx)
     C                   LEAVE
     C                   ENDIF
      *
      ***  Must be greater than interest accrual control date
      *
     C                   MOVE      '0'           WIN63             1
     C     DDACTN        IFEQ      'I'
     C                   Z-ADD     WSVVD         IACD
     C                   ENDIF
     C*****WSVRD         IFLT      IACD                                                       210977
     C     WSVRD         IFLE      IACD                                                       210977
     C                   MOVE      '1'           WIN63
     C                   ENDIF
      *
      ***  If rollover date has changed and loan is not a disc loan,
      ***  and maturity date is entered,
      ***  if new maturity date is entered, rollover date must be earlier
      ***  than new mat date, else rollover date must be earlier than
      ***  maturity date
      *
     C     WLNPT         IFNE      63
     C     WLNPT         ANDNE     65
     C     WLNPT         ANDNE     67
     C     DDACTN        ORNE      'A'
     C     DDACTN        ANDNE     'X'
     C     WSVRD         ORNE      RLDT
     C     DDACTN        ORNE      'Q'                                                        CLE030
     C     CLE030        ANDNE     'Y'                                                        CLE030
      *
     C     WSVRD         IFGT      IACD
     C     DDMDATOK      ANDNE     'N'
     C     DDMDAT        ANDNE     *BLANKS
     C     NMDT          IFGT      *ZEROS
     C     DDACTN        ANDNE     'I'
     C                   Z-ADD     NMDT          W0MDT             5 0
     C                   ELSE
     C                   Z-ADD     WSVMD         W0MDT
     C                   ENDIF
     C     WSVRD         IFGE      W0MDT
     C     WLNPT         IFNE      61
     C     WLNPT         ORNE      68
     C     WLNPT         ORNE      69
     C                   MOVE      '1'           WIN63
     C                   ELSE
     C     W0MDT         IFNE      0
     C                   MOVE      '1'           WIN63
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     WSVRD         IFGE      DTEXF
     C     WLNPT         IFEQ      61
     C     WLNPT         OREQ      68
     C     WLNPT         OREQ      69
     C     W0MDT         IFEQ      0
     C                   MOVE      '1'           WIN63
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     WIN63         IFEQ      '1'
     C                   MOVE      'N'           DDRLDTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRLDT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0152'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  Send warning msg if rollover date is different w/ sale of
      ***  loan w/ multi-ccy rollover details
      *
     C     WSVRD         IFNE      RLDTM
     C     NCCYM         ANDNE     *BLANKS
     C     NCCYM         ANDNE     CCYM
      *
     C*****WE510         IFEQ      *BLANK                                                    BUG4351
     C*****WE510         OREQ      'Y'                                                       BUG4351
     C*****WSVRD         ANDNE     W1RLDT                                                    BUG4351
     C**********         Z-ADD     WSVRD         W1RLDT            5 0                       BUG4351
     C**********         MOVE      'Y'           WE510             1                         BUG4351
     C                   MOVE      'W'           DDRLDTOK
     C                   ADD       1             WId
     C                   MOVEL     'DDRLDT'      WFldNmXAr(WId)
     C                   MOVEL     'LEL0510'     WMsgIDXAr(WId)
     C**********         ENDIF                                                               BUG4351
     C                   ENDIF
      *
     C                   ENDDO
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Check if  rollover date is > last availability date
      ** for Insert/Amend/Authorise
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'R'                                                        247585
     C     DDACTN        OREQ      'Q'                                                        CLE030
      *
      ** Need to re-calc WSVRD if Amend or authorise or release
      *
     C     DDRLDT        IFNE      *BLANKS
     C                   DO
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'R'                                                        247585
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C                   MOVE      DDRLDT        ZDATE
     C                   MOVE      BJDFIN        ZDATFM
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       ZERR
     C                   PARM                    ZDATE
     C                   PARM                    ZDATFM
     C                   PARM                    ZDAYNO
      *
     C     ZERR          IFEQ      *BLANKS
     C                   Z-ADD     ZDAYNO        WSVRD
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Facility
      *
     C     WSVRD         IFGT      AVLD
     C     AVLD          ANDNE     0
      **************************************************************                 CLE030 BUG10657
      ***If*CLE030*is*off*then*this*is an error                                      CLE030 BUG10657
      **************************************************************                 CLE030 BUG10657
     C*****CLE030********IFEQ      'N'                                               CLE030 BUG10657
     C*****AYLNPT        IFEQ      63                                                  238646 237217
     C*****AYLNPT        OREQ      65                                                  238646 237217
     C*****AYLNPT        OREQ      67                                                  238646 237217
     C**********         MOVE      'N'           DDRLDTOK                            CLE030 BUG10657
     C**********         ADD       1             Idx                                 CLE030 BUG10657
     C**********         MOVEL     'DDRLDT'      FldNamXAr(Idx)                      CLE030 BUG10657
     C**********         MOVEL     'LEL0523'     MsgIDXAr(Idx)                       CLE030 BUG10657
     C**********         ENDIF                                                         238646 237217
      **********                                                                     CLE030 BUG10657
      ***If*CLE030 is on then this should be a warning                               CLE030 BUG10657
      **********                                                                     CLE030 BUG10657
     C**********         ELSE                                                        CLE030 BUG10657
     C**********         Z-ADD     WSVRD         W1RLDT                               CLE030 BUG4351
     C                   MOVE      'W'           DDRLDTOK                                     CLE030
     C                   ADD       1             WId                                          CLE030
     C                   MOVEL     'DDRLDT'      WFldNmXAr(WId)                               CLE030
     C                   MOVEL     'LEL0524'     WMsgIDXAr(WId)                               CLE030
     C     DDACTN        IFEQ      'I'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                      BUG10733
     C     DDACTN        OREQ      'X'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                      BUG10733
     C                   EVAL      CCLLSTS = 'Q'                                              CLE030
     C                   ENDIF                                                                CLE030
     C**********         ENDIF                                                       CLE030 BUG10657
     C                   ENDIF
      *
      ** Credit agreement
      *
     C     WSVRD         IFGT      AVLDB
     C     AVLDB         ANDNE     0
      ****************************************************************               CLE030 BUG10657
      ** If CLE030 is off then this is an error                                      CLE030 BUG10657
      ****************************************************************               CLE030 BUG10657
     C*****CLE030        IFEQ      'N'                                               CLE030 BUG10657
     C**********         MOVE      'N'           DDRLDTOK                            CLE030 BUG10657
     C**********         ADD       1             Idx                                 CLE030 BUG10657
     C**********         MOVEL     'DDRLDT'      FldNamXAr(Idx)                      CLE030 BUG10657
     C**********         MOVEL     'LEL0519'     MsgIDXAr(Idx)                       CLE030 BUG10657
      ****************************************************************               CLE030 BUG10657
      ***If*CLE030*is*on*then*this*should*be*a*warning****************               CLE030 BUG10657
      ****************************************************************               CLE030 BUG10657
     C**********         ELSE                                                        CLE030 BUG10657
     C**********         Z-ADD     WSVRD         W1RLDT                               CLE030 BUG4351
     C     CLE030        IFEQ      'Y'                                                        237217
     C                   MOVE      'W'           DDRLDTOK                                     CLE030
     C                   ADD       1             WId                                          CLE030
     C                   MOVEL     'DDRLDT'      WFldNmXAr(WId)                               CLE030
     C                   MOVEL     'LEL0522'     WMsgIDXAr(WId)                               CLE030
     C     DDACTN        IFEQ      'I'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                      BUG10733
     C     DDACTN        OREQ      'X'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                      BUG10733
     C                   EVAL      CCLLSTS = 'Q'                                              CLE030
     C                   ENDIF                                                                CLE030
     C**********         ENDIF                                                       CLE030 BUG10657
     C                   ENDIF                                                                CPK025
     C                   ENDIF
      *
     C                   ENDIF
      *
      ***  If action 'A' or 'X' set up field for later validation
      *
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   Z-ADD     @@RLDT        WSVRD
     C                   ENDIF
      *
     C     DDRLDTOK      IFNE      'N'
     C                   Z-ADD     WSVRD         CCLRLDT
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRLFQ  -  Validate the rollover frequency and day number     *
      *****************************************************************
     C     SRRLFQ        BEGSR
      *
      ***  Rollover details to be validated only on insert
      *
     C     DDACTN        IFEQ      'I'
      *
     C     DDRLDT        IFEQ      *BLANKS
     C     DDRLFQ        ANDNE     *BLANK
     C                   MOVE      'N'           DDRLFQOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRLFQ'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0273'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      *****Frequencies allowed are M,Q,X and Y                                                CLE064
      ***  Frequencies allowed are M,T,Q,X,Y,D,W,F,4,5,7,8,9,V,E,C,I,J,                       CLE064
      ***  N and U                                                                            CLE064
      ***  Moreover, it must be a valid frequency for the facility to
      ***  which the loan is being linked
      *
     C     DDRLFQ        IFNE      *BLANK
     C*****DDRLFQ        ANDNE     'M'                                                        CLE064
     C*****DDRLFQ        ANDNE     'T'                                               BUG21898 CLE064
     C*****DDRLFQ        ANDNE     'Q'                                                        CLE064
     C*****DDRLFQ        ANDNE     'X'                                                        CLE064
     C*****DDRLFQ        ANDNE     'Y'                                                        CLE064
     C     DDRLFQ        LOOKUP    WFREQ                                  97                  CLE064
     C     *IN97         IFEQ      '0'                                                        CLE064
     C                   MOVE      'N'           DDRLFQOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRLFQ'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0055'     MsgIDXAr(Idx)
     C                   ENDIF                                                                CLE064
     C                   ELSE
     C     *IN83         IFEQ      '0'
     C     DDRLFQ        ANDNE     *BLANK
     C     DDRLFQ        SCAN      RTPS:1                                 99
     C     DDRLFQ        SCAN      RTS15:1                                98                  CLE064
     C     *IN99         IFEQ      '0'
     C     *IN98         ANDEQ     '0'                                                        CLE064
     C                   MOVE      'N'           DDRLFQOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRLFQ'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0410'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     DDRLFQ        IFEQ      *BLANKS
     C     DDRLDY        ANDNE     *BLANKS
     C                   MOVE      'N'           DDRLDYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRLDY'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0277'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  Defaults to the day number of rollover date
      *
     C     DDRLDY        IFEQ      *BLANK
     C     DDRLFQ        IFNE      *BLANK
     C     DDRLDT        ANDNE     *BLANK
     C     DDRLDTOK      ANDNE     'N'
     C     DDRLFQOK      ANDNE     'N'
     C                   MOVE      DDRLDT        WDATE
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      WDAT2         DDRLDY
     C                   ELSE
     C                   MOVE      WDAT1         DDRLDY
     C                   ENDIF
     C                   ENDIF
      *
      ***  Must be numeric from 1 to 31
      *
     C                   ELSE
     C                   MOVEL     DDRLDY        WNUM3             3 0
     C                   MOVEL     WNUM3         WALF2             2
     C     DDRLDY        IFNE      WALF2
     C     DDRLDY        ORLT      '01'
     C     DDRLDY        ORGT      '31'
     C                   MOVE      'N'           DDRLDYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRLDY'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0279'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      DDRLDY        WRLDY             2 0
      *
      ***  If rollover frequency is entered, next rollover date
      ***  calculated should be on or earlier than maturity date
      *
     C     DDACTN        IFEQ      'I'
     C     WLNPT         IFNE      61
     C     WLNPT         ANDNE     68
     C     DDRLDT        ANDNE     *BLANKS
     C     DDRLFQ        ANDNE     *BLANK
     C     DDRLDTOK      ANDNE     'N'
     C     DDRLFQOK      ANDNE     'N'
     C     DDRLDYOK      ANDNE     'N'
     C     DDMDAT        ANDNE     *BLANKS
     C     DDMDATOK      ANDNE     'N'
     C                   MOVE      DDRLFQ        ZFREQ
     C                   Z-ADD     WSVRD         ZDAYNO
     C                   MOVE      DDCURR        ZCCY
     C                   MOVE      DDRLDY        ZMDAY
     C                   CALLB     'ZFREQB'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ZFREQ
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM      *BLANKS       ZLOC                                       AR702741
     C                   PARM      *ZERO         ZMDAY
     C                   PARM                    BJDFIN
     C                   PARM      SDGELR        SDGELR
     C     ZDAYNO        IFGT      WSVMD
     C                   MOVE      'N'           DDRLFQOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRLFQ'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0054'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ***  Issue a warning message if rollover date is a holiday
      ***  in loan currency
      *
     C     DDRLDTOK      IFNE      'N'
     C     DDRLDT        ANDNE     *BLANKS
                                                                                              CLE141
     C                   IF        CLE141 = 'N'                                               CLE141
     C                   Z-ADD     WSVRD         ZDAYNO
     C                   MOVE      DDCURR        ZCCY
     C                   MOVE      WLCCD         ZLOC
      *
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM      *BLANK        ZIND
     C     ZIND          IFEQ      'H'
     C*****WE009         IFEQ      *BLANK                                                    BUG4351
     C*****WE009         OREQ      'Y'                                                       BUG4351
     C*****WSVRD         ANDNE     W1RD                                                      BUG4351
     C**********         Z-ADD     WSVRD         W1RD              5 0                       BUG4351
     C**********         MOVE      'Y'           WE009             1                         BUG4351
     C                   MOVE      'W'           DDRLDTOK
     C                   ADD       1             WId
     C                   MOVEL     'DDRLDT'      WFldNmXAr(WId)
     C                   MOVEL     'LEL0075'     WMsgIDXAr(WId)
     C**********         ENDIF                                                               BUG4351
     C                   ENDIF
     C                   ENDIF                                                                CLE141
                                                                                              CLE141
      ** If CLE141 is ON, validate holiday with Business Day Convention                       CLE141
      ** for rollover and rate fixing                                                         CLE141
                                                                                              CLE141
     C                   IF        CLE141 = 'Y' and                                           CLE141
     C                             OKFlgBDYCL <> 'N'                                          CLE141
     C                   CALLB     'LEVBDYLE'                                                 CLE141
     C                   PARM      *BLANKS       BDCHolInd                                    CLE141
     C                   PARM      CurLocPR      LoanBDC                                      CLE141
     C**********         PARM      WSVRD         DayNo                               CLE141 MD052327
     C                   PARM      WSVRD         DayNoZ                                     MD052327
     C                   IF        BDCHolInd = 'HOLIDAY'                                      CLE141
     C                   EVAL      DDRLDTOK = 'W'                                             CLE141
     C                   EVAL      WId = WId + 1                                              CLE141
     C                   EVAL      WFldNmXAr(WId) = 'DDRLDT'                                  CLE141
     C                   EVAL      WMsgIDXar(WId) = '5048509'                                 CLE141
     C                   ENDIF                                                                CLE141
     C                   ENDIF                                                                CLE141
                                                                                              CLE141
     C                   ENDIF
      *
      ***  For parts sold, determine if facility of original loan
      ***  is syndicated
      *
     C                   MOVE      *BLANK        WLPFI             1
     C                   MOVE      *BLANK        CCLLPFI
     C                   MOVE      *BLANK        WPASI             1
     C**********         Z-ADD     *ZEROS        WPTFC             6 0                        CSD027
     C                   MOVE      *BLANKS       WPTFC             6                          CSD027
     C                   Z-ADD     *ZEROS        WPTFT             3 0
     C                   Z-ADD     *ZEROS        WPTFN             2 0
      *
     C     *IN83         IFEQ      '1'
     C     DDOLNOOK      ANDNE     'N'
     C                   MOVE      FCUSM         WFCNUM
     C                   MOVE      FTYPM         WFFACT
     C                   MOVE      FSEQM         WFFCNO
     C                   MOVE      'A'           WFRCTP
     C     WKFAC         CHAIN(N)  FCLTY                              99
      *
     C     *IN99         IFEQ      *OFF
     C                   EXSR      SRCKFR
     C                   ENDIF
      *
     C     *IN99         IFEQ      '1'
     C     *IN99         OREQ      '0'
     C     RECIF         ANDNE     'D'
     C     WREAC         ANDEQ     *OFF
     C     *LOCK         IN        LDA
     C                   MOVEL     'FCLTY   '    DBFILE                         *************
     C                   Z-ADD     3             DBASE                          * DBERR 003 *
     C                   MOVEL     FCTREC        DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C     DDRLFQOK      IFNE      'N'
     C     DDRLDYOK      ANDNE     'N'
     C                   MOVEL     DDRLFQ        CCLRLFQ
     C                   MOVEL     DDRLDY        CCLRLDY
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRRFDY  -  Validate the rate fixing days                      *
      *****************************************************************
     C     SRRFDY        BEGSR
      *
     C     CLE011        IFEQ      'Y'
      *
     C     DDRFDY        IFNE      *BLANKS
      *
     C                   MOVE      *BLANKS       PSCRF
     C                   MOVE      DDRFDY        PSCRF
     C                   Z-ADD     0             PNDEC
     C                   Z-ADD     2             PNDIG
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    PSCRF            16
     C                   PARM                    PNDEC             1 0
     C                   PARM                    PNDIG             2 0
     C                   PARM      *BLANKS       PRVAL            16
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDRFDYOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDRFDY'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0511'     MsgIDXAr(Idx)
     C                   ELSE
     C                   MOVE      PRVAL         DDRFDY
     C                   ENDIF
      *
      ***  If Rate Fix day is not entered, default to '02'
      *
     C                   ELSE
     C**********         MOVEL     '02'          DDRFDY                                       256579
     C                   MOVEL     PCurSet03     DDRFDY                                       256579
      *
     C                   ENDIF
      *
      ***  When loan is flagged as rate fixed and rate fixing days has
      ***  been amended, issue warning message
      *
     C                   MOVEL     @@RFDY        WCHR02            2
      *
     C     DDACTN        IFEQ      'A'
     C     @@RFRI        ANDEQ     'Y'
     C     DDRFDY        ANDNE     WCHR02
     C     WE512         ANDEQ     *BLANKS
      *
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      RFRT          ZFIELD           16
     C                   Z-ADD     7             ZADEC             1 0
      *
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
      *
     C                   ADD       1             Idx
      *
     C                   SELECT
      *
      ***  Participation Purchased
      *
     C     *IN82         WHENEQ    *ON
     C                   MOVEL     'LEL0513'     MsgIDXAr(Idx)
      *
      ***  Participation Sold
      *
     C     *IN83         WHENEQ    *ON
     C                   MOVEL     'LEL0514'     MsgIDXAr(Idx)
      *
      ***  Loan
      *
     C                   OTHER
     C                   MOVEL     'LEL0512'     MsgIDXAr(Idx)
     C                   ENDSL
      *
     C                   MOVE      'Y'           WE512
     C                   MOVE      ZFIELD        WCHR12           12
     C                   MOVE      'N'           DDRFDYOK
     C                   MOVEL     'DDRFDY'      FldNamXAr(Idx)
     C**********         MOVEL     WCHR12        MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(WCHR12))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(WCHR12)                   MD000091
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     DDRFDYOK      IFNE      'N'
     C                   MOVEL     DDRFDY        CCLRFDY
     C                   ENDIF
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRDFTP  -  Validate default participation loan type/subtype   *
      *            (for loans and parts purchased when facility is    *
      *             syndicated)                                       *
      *****************************************************************
     C     SRDFTP        BEGSR
      *
     C     *IN83         IFEQ      '0'
      *
      ***  Entry valid only when facility is syndicated
      *
     C     '?'           SCAN      DDDFTP:1                               77
     C     '?'           SCAN      DDDFST:1                               78
     C     '?'           SCAN      DDDFCL:1                               79                  CLE042
     C     SYINF         IFNE      'Y'
     C     DDDFTP        IFNE      *BLANKS
     C     DDDFST        ORNE      *BLANKS
     C     DDDFCL        ORNE      *BLANKS                                                    CLE042
     C                   MOVE      'N'           DDDFTPOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDFTP'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0042'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ***  Loan subtype must be entered if loan type is entered
      ***  and likewise
      *
     C     DDDFTPOK      IFNE      'N'
     C     *IN77         ANDEQ     '0'
     C     *IN78         ANDEQ     '0'
     C     *IN79         ANDEQ     '0'                                                        CLE042
     C     DDDFTP        IFEQ      *BLANKS
     C     DDDFST        ANDNE     *BLANKS
     C     DDDFTP        ORNE      *BLANKS
     C     DDDFST        ANDEQ     *BLANKS
     C                   MOVE      'N'           DDDFTPOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDFTP'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0413'     MsgIDXAr(Idx)
     C                   ENDIF
     C     DDDFTP        IFEQ      *BLANKS                                                    CLE042
     C     DDDFCL        ANDNE     *BLANKS                                                    CLE042
     C     DDDFTP        ORNE      *BLANKS                                                    CLE042
     C     DDDFCL        ANDEQ     *BLANKS                                                    CLE042
     C     CLE042        ANDEQ     'Y'                                                        CLE042
     C                   MOVE      'N'           DDDFTPOK                                     CLE042
     C                   ADD       1             Idx                                          CLE042
     C                   MOVEL     'DDDFTP'      FldNamXAr(Idx)                               CLE042
     C                   MOVEL     'LEL0732'     MsgIDXAr(Idx)                                CLE042
     C                   ENDIF                                                                CLE042
      *
      ***  Loan type must start with 'H, 'J' or 'K' if entered
      *
     C     DDDFTPOK      IFNE      'N'
     C     DDDFTP        ANDNE     *BLANKS
     C     1             SUBST     DDDFTP:1      WFRST             1
     C     *IN77         IFEQ      '0'
     C     *IN78         ANDEQ     '0'
     C     *IN79         ANDEQ     '0'                                                        CLE042
     C     WFRST         ANDNE     'H'
     C     WFRST         ANDNE     'J'
     C     WFRST         ANDNE     'K'
     C                   MOVE      'N'           DDDFTPOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDFTP'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0411'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ***  Must form a valid loan type/subtype with processing type
      ***  of a participations sold
      *
     C     DDDFTPOK      IFNE      'N'
     C     DDDFTP        IFNE      *BLANKS
     C     DDDFST        ORNE      *BLANKS
     C     DDDFCL        ORNE      *BLANKS                                                    CLE042
     C                   MOVE      DDDFTP        @LNTY
     C                   MOVE      DDDFST        @LNST
     C                   MOVE      DDDFCL        @LNCL                                        CLE042
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @LNTY
     C                   PARM                    @LNST
     C                   PARM                    @LNCL                                        CLE042
     C     SDLOAN        PARM      SDLOAN        DSFDY
      *
     C                   SELECT
     C     @RTCD         WHENEQ    '*NOSEL'
     C                   MOVE      *BLANKS       DDDFTP
     C                   MOVE      *BLANKS       DDDFST
     C                   MOVE      *BLANKS       DDDFCL                                       CLE042
     C     @RTCD         WHENNE    *BLANKS
     C                   MOVE      'N'           DDDFTPOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDFTP'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0412'     MsgIDXAr(Idx)
     C     @RTCD         WHENEQ    *BLANKS
     C                   MOVE      AYLNTY        DDDFTP
     C                   MOVE      AYLNST        DDDFST
     C                   MOVE      AYLNCL        DDDFCL                                       CLE042
     C     AYLNPT        IFNE      66
     C     AYLNPT        ANDNE     67
     C     AYLNPT        ANDNE     69
     C     AYLNPT        ANDNE     72
     C     WLNPT         OREQ      69
     C     CLE005        ANDEQ     'N'
     C     WLNPT         OREQ      72
     C     CLE005        ANDEQ     'N'
     C                   MOVE      'N'           DDDFTPOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDFTP'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0047'     MsgIDXAr(Idx)
     C                   ENDIF
                                                                                              CLE106
      ** Default Loan Type/Subtype must be in the same category as the loan's                 CLE106
                                                                                              CLE106
     C                   IF        WLNPT = 61 And AYLNPT <> 69 Or                             CLE106
     C                             WLNPT = 62 And AYLNPT <> 66 Or                             CLE106
     C                             WLNPT = 63 And AYLNPT <> 67 Or                             CLE106
     C                             WLNPT = 70 And AYLNPT <> 72                                CLE106
     C                   EVAL      DDDFTPOK = 'N'                                             CLE106
     C                   EVAL      Idx = Idx + 1                                              CLE106
     C                   EVAL      FldNamXAr(Idx) = 'DDDFTP'                                  CLE106
     C                   EVAL      MsgIDXAr(Idx) = 'LEL0424'                                  CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDSL
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     DDDFTPOK      IFNE      'N'
     C     DDDFSTOK      ANDNE     'N'
     C     DDDFCLOK      ANDNE     'N'                                                        CLE042
     C                   MOVEL     DDDFTP        CCLDFTP
     C                   MOVEL     DDDFST        CCLDFST
     C                   MOVEL     DDDFCL        CCLDFCL                                      CLE042
     C                   ENDIF
      *
     C                   ENDSR
      *********************************************************************                   CLE106
      * SRFSTP  -  Validate default Sub-participation loan type/subtype   *                   CLE106
      *            (for loans and parts purchased when facility is        *                   CLE106
      *             syndicated)                                           *                   CLE106
      *********************************************************************                   CLE106
     C     SRFSTP        BEGSR                                                                CLE106
      *                                                                                       CLE106
     C     *IN83         IFEQ      '0'                                                        CLE106
      *                                                                                       CLE106
      **  Entry valid only when facility is syndicated                                        CLE106
      *                                                                                       CLE106
     C     '?'           SCAN      DDSLTP:1                               77                  CLE106
     C     '?'           SCAN      DDSLST:1                               78                  CLE106
     C     '?'           SCAN      DDSLCL:1                               79                  CLE042
     C     SYINF         IFNE      'Y'                                                        CLE106
     C     DDSLTP        IFNE      *BLANKS                                                    CLE106
     C     DDSLST        ORNE      *BLANKS                                                    CLE106
     C     DDSLCL        ORNE      *BLANKS                                                    CLE042
     C                   MOVE      'N'           DDSLTPOK                                     CLE106
     C                   ADD       1             Idx                                          CLE106
     C                   MOVEL     'DDSLTP'      FldNamXAr(Idx)                               CLE106
     C                   MOVEL     'LEL0714'     MsgIDXAr(Idx)                                CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
      ** Loan subtype must be entered if loan type is entered                                 CLE106
      ** and likewise                                                                         CLE106
      *                                                                                       CLE106
     C     DDSLTPOK      IFNE      'N'                                                        CLE106
     C     *IN77         ANDEQ     '0'                                                        CLE106
     C     *IN78         ANDEQ     '0'                                                        CLE106
     C     *IN79         ANDEQ     '0'                                                        CLE042
     C     DDSLTP        IFEQ      *BLANKS                                                    CLE106
     C     DDSLST        ANDNE     *BLANKS                                                    CLE106
     C     DDSLTP        ORNE      *BLANKS                                                    CLE106
     C     DDSLST        ANDEQ     *BLANKS                                                    CLE106
     C                   MOVE      'N'           DDSLTPOK                                     CLE106
     C                   ADD       1             Idx                                          CLE106
     C                   MOVEL     'DDSLTP'      FldNamXAr(Idx)                               CLE106
     C                   MOVEL     'LEL0706'     MsgIDXAr(Idx)                                CLE106
     C                   ENDIF                                                                CLE106
     C     DDSLTP        IFEQ      *BLANKS                                                    CLE042
     C     DDSLCL        ANDNE     *BLANKS                                                    CLE042
     C     DDSLTP        ORNE      *BLANKS                                                    CLE042
     C     DDSLCL        ANDEQ     *BLANKS                                                    CLE042
     C     CLE042        ANDEQ     'Y'                                                        CLE042
     C                   MOVE      'N'           DDSLTPOK                                     CLE042
     C                   ADD       1             Idx                                          CLE042
     C                   MOVEL     'DDSLTP'      FldNamXAr(Idx)                               CLE042
     C                   MOVEL     'LEL0733'     MsgIDXAr(Idx)                                CLE042
     C                   ENDIF                                                                CLE042
      *                                                                                       CLE106
      ** Loan type must start with 'H, 'J' or 'K' if entered                                  CLE106
      *                                                                                       CLE106
     C     DDSLTPOK      IFNE      'N'                                                        CLE106
     C     DDSLTP        ANDNE     *BLANKS                                                    CLE106
     C     1             SUBST     DDSLTP:1      WFRST             1                          CLE106
     C     *IN77         IFEQ      '0'                                                        CLE106
     C     *IN78         ANDEQ     '0'                                                        CLE106
     C     *IN79         ANDEQ     '0'                                                        CLE042
     C     WFRST         ANDNE     'H'                                                        CLE106
     C     WFRST         ANDNE     'J'                                                        CLE106
     C     WFRST         ANDNE     'K'                                                        CLE106
     C                   MOVE      'N'           DDSLTPOK                                     CLE106
     C                   ADD       1             Idx                                          CLE106
     C                   MOVEL     'DDSLTP'      FldNamXAr(Idx)                               CLE106
     C                   MOVEL     'LEL0707'     MsgIDXAr(Idx)                                CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
      ** Must form a valid loan type/subtype with processing type                             CLE106
      ** of a participations sold                                                             CLE106
      *                                                                                       CLE106
     C     DDSLTPOK      IFNE      'N'                                                        CLE106
     C     DDSLTP        IFNE      *BLANKS                                                    CLE106
     C     DDSLST        ORNE      *BLANKS                                                    CLE106
     C     DDSLCL        ORNE      *BLANKS                                                    CLE042
     C                   MOVE      DDSLTP        @LNTY                                        CLE106
     C                   MOVE      DDSLST        @LNST                                        CLE106
     C                   MOVE      DDSLCL        @LNCL                                        CLE042
     C                   CALL      'AOLOANR0'                                                 CLE106
     C                   PARM      *BLANKS       @RTCD                                        CLE106
     C                   PARM      '*KEY   '     @OPTN                                        CLE106
     C                   PARM                    @LNTY                                        CLE106
     C                   PARM                    @LNST                                        CLE106
     C                   PARM                    @LNCL                                        CLE042
     C     SDLOAN        PARM      SDLOAN        DSFDY                                        CLE106
      *                                                                                       CLE106
     C                   SELECT                                                               CLE106
     C     @RTCD         WHENEQ    '*NOSEL'                                                   CLE106
     C                   MOVE      *BLANKS       DDSLTP                                       CLE106
     C                   MOVE      *BLANKS       DDSLST                                       CLE106
     C                   MOVE      *BLANKS       DDSLCL                                       CLE042
     C     @RTCD         WHENNE    *BLANKS                                                    CLE106
     C                   MOVE      'N'           DDSLTPOK                                     CLE106
     C                   ADD       1             Idx                                          CLE106
     C                   MOVEL     'DDSLTP'      FldNamXAr(Idx)                               CLE106
     C                   MOVEL     'LEL0708'     MsgIDXAr(Idx)                                CLE106
     C     @RTCD         WHENEQ    *BLANKS                                                    CLE106
     C                   MOVE      AYLNTY        DDSLTP                                       CLE106
     C                   MOVE      AYLNST        DDSLST                                       CLE106
     C                   MOVE      AYLNCL        DDSLCL                                       CLE042
     C     AYLNPT        IFNE      66                                                         CLE106
     C     AYLNPT        ANDNE     67                                                         CLE106
     C     AYLNPT        ANDNE     69                                                         CLE106
     C     AYLNPT        ANDNE     72                                                         CLE106
     C     WLNPT         OREQ      69                                                         CLE106
     C     CLE005        ANDEQ     'N'                                                        CLE106
     C     WLNPT         OREQ      72                                                         CLE106
     C     CLE005        ANDEQ     'N'                                                        CLE106
     C                   MOVE      'N'           DDSLTPOK                                     CLE106
     C                   ADD       1             Idx                                          CLE106
     C                   MOVEL     'DDSLTP'      FldNamXAr(Idx)                               CLE106
     C                   MOVEL     'LEL0709'     MsgIDXAr(Idx)                                CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
      ** Default Loan Type/Subtype must be in the same category as the loan's                 CLE106
                                                                                              CLE106
     C                   IF        WLNPT = 61 And AYLNPT <> 69 Or                             CLE106
     C                             WLNPT = 62 And AYLNPT <> 66 Or                             CLE106
     C                             WLNPT = 63 And AYLNPT <> 67 Or                             CLE106
     C                             WLNPT = 70 And AYLNPT <> 72                                CLE106
     C                   EVAL      DDSLTPOK = 'N'                                             CLE106
     C                   EVAL      Idx = Idx + 1                                              CLE106
     C                   EVAL      FldNamXAr(Idx) = 'DDSLTP'                                  CLE106
     C                   EVAL      MsgIDXAr(Idx) = 'LEL0424'                                  CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDSL                                                                CLE106
      *                                                                                       CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C     DDSLTPOK      IFNE      'N'                                                        CLE106
     C     DDSLSTOK      ANDNE     'N'                                                        CLE106
     C     DDSLCLOK      ANDNE     'N'                                                        CLE042
     C                   MOVEL     DDSLTP        CCLSLTP                                      CLE106
     C                   MOVEL     DDSLST        CCLSLST                                      CLE106
     C                   MOVEL     DDSLCL        CCLSLCL                                      CLE042
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   ENDSR                                                                CLE106
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRLNKS  -  Validate linked to syndicate                       *
      *****************************************************************
     C     SRLNKS        BEGSR
      *
     C     *IN82         IFEQ      '1'
     C     *IN83         OREQ      '1'
      *
     C     SYINF         IFNE      'Y'
     C*****DDLNKS        ANDNE     *BLANK                                                     CLE106
     C*****DDLNKS        ANDNE     'N'                                                BUG5148 CLE106
     C     DDLNKS        ANDEQ     'Y'                                                        CLE106
     C                   MOVE      'N'           DDLNKSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDLNKS'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0414'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  Entry is mandatory if facility is syndicated
      *
     C     SYINF         IFEQ      'Y'
      *
     C     DDLNKS        IFNE      'Y'
     C     DDLNKS        ANDNE     'N'
     C     DDLNKS        ANDNE     *BLANKS
     C                   MOVE      'N'           DDLNKSOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDLNKS'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0415'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C     DDLNKS        IFEQ      *BLANKS
     C                   MOVE      'N'           DDLNKS
     C                   ENDIF
      *
      ***  Issue warning if part sold is being inserted against a
      ***  syndicated facility.
      ***  Skip this part if CLE106 Syndications Manager is available                         CLE106
      *
     C     DDACTN        IFEQ      'I'
     C     RespMode      ANDEQ     'S'
     C     *IN83         ANDEQ     '1'
     C     DDLNKS        ANDEQ     'Y'
     C     CLE106        ANDEQ     'N'                                                        CLE106
      *
     C*****WE232         IFEQ      *BLANK                                                    BUG4351
     C*****WE232         OREQ      'Y'                                                       BUG4351
     C*****DDLNKS        ANDNE     W1LNKS                                                    BUG4351
     C**********         MOVE      DDLNKS        W1LNKS            1                         BUG4351
      *
     C     SYINF         IFEQ      'Y'
     C                   MOVE      'W'           DDLNKSOK
     C                   ADD       1             WId
     C                   MOVEL     'DDLNKS'      WFldNmXAr(WId)
     C                   MOVEL     'LEM0232'     WMsgIDXAr(WId)
     C**********         MOVE      'Y'           WE232                                       BUG4351
     C                   ENDIF
      *
     C**********         ENDIF                                                               BUG4351
     C                   ENDIF
      *
      ***  Facility reference must be a prime facility
      *
     C     DDFCUSOK      IFNE      'N'
     C                   MOVE      '0'           *IN99
     C     WCPRTR        IFNE      ' '
     C     WCPRTR        ANDNE     'A'
     C                   MOVE      '1'           *IN99
     C                   ENDIF
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           DDFTYPOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDFTYP'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0043'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ***  Get branch details of prime facility
      *
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      BRCAF         @BRCD
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBRCHPD'    DBFILE                         *************
     C                   Z-ADD     4             DBASE                          * DBERR 004 *
     C                   MOVEL     @BRCD         DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      A8SYCU        W#SYCU            6
      *
      ***  For Participation Purchased where the bank is the Agent,
      ***  the funding participant customer must be the BICN.
      *
     C     *IN82         IFEQ      '1'
     C     WAGENT        ANDEQ     W#SYCU
     C**********         MOVE      A8BICN        WCUST             6 0                        CSD027
     C                   MOVE      A8BICN        WCUST             6                          CSD027
     C                   ELSE
     C                   MOVE      WSVCN         WCUST
     C                   ENDIF
      *
     C     *IN82         IFEQ      '1'
     C     WAGENT        ANDEQ     W#SYCU
     C     *IN83         OREQ      '1'
      *                                                                                       CLE106
     C                   MOVE      CNUMF         W#PMFC                                       CLE106
      *
     C                   MOVE      BRCAF         WFBRCA            3
     C                   MOVE      CNUMF         WFCNUM
     C                   MOVE      FACT          WFFACT
     C                   MOVE      FCNO          WFFCNO
     C     WKPRM         SETLL     LEFCLTL4
      *
     C                   IF        DDLPFI <> *BLANK                                        BUG10671R
                                                                                           BUG10671R
     C**********         DOW       *IN99 = *OFF AND                              BUG10671R BUG10671R
     C**********                   WCUST  <> CNUMF AND                           BUG10671R BUG10671R
     C**********                   DDLPFI <> PRTR  OR                            BUG10671R BUG10671R
     C**********                   *IN99 = *OFF    AND                           BUG10671R BUG10671R
     C**********                   WCUST  =  CNUMF AND                           BUG10671R BUG10671R
     C**********                   DDLPFI =  PRTR  AND                           BUG10671R BUG10671R
     C**********                   RECIF = 'R'                                   BUG10671R BUG10671R
     C*****WKPRM         READE     LEFCLTL4                               99     BUG10671R BUG10671R
     C**********         ENDDO                                                   BUG10671R BUG10671R
     C                   EVAL      WrkEndLoop = 'N'                                        BUG10671R
     C                   DOW       *IN99 = *OFF AND                                        BUG10671R
     C                             WrkEndLoop = 'N'                                        BUG10671R
     C     WKPRM         READE     LEFCLTL4                               99               BUG10671R
     C                   IF        WCUST  =  CNUMF AND                                     BUG10671R
     C                             DDLPFI =  PRTR  AND                                     BUG10671R
     C                             RECIF <> 'R'                                            BUG10671R
     C                   EVAL      WrkEndLoop = 'Y'                                        BUG10671R
     C                   ENDIF                                                             BUG10671R
     C                   ENDDO                                                             BUG10671R
                                                                                           BUG10671R
     C                   ELSE                                                              BUG10671R
                                                                                           BUG10671R
     C     *IN99         DOWEQ     '0'
     C     WCUST         ANDNE     CNUMF
     C     *IN99         OREQ      '0'
     C     WCUST         ANDEQ     CNUMF
     C     RECIF         ANDEQ     'R'
     C     WKPRM         READE     LEFCLTL4                               99
     C                   ENDDO
                                                                                           BUG10671R
     C                   ENDIF                                                             BUG10671R
      *
     C                   ENDIF
      ****************************************************************                        CLE106
      *****For*a*risk*parts*sold,*customer*must*be*a*risk*participant*                        CLE106
      *****starting*not*later*than*the*value*date*of*loan*************                        CLE106
      ****************************************************************                        CLE106
     C**********         MOVE      *BLANK        WRISK             1                          CLE106
     C******IN83         IFEQ      '1'                                                        CLE106
     C******IN99         ANDEQ     '1'                                                        CLE106
     C*****WLNPT         ANDEQ     72                                                         CLE106
     C**********         MOVE      WFBRCA        PBRCA             3                          CLE106
     C**********         MOVE      WFCNUM        S#FCUS                                       CLE106
     C**********         MOVE      WFFACT        S#FTYP                                       CLE106
     C**********         MOVE      WFFCNO        S#FSEQ                                       CLE106
     C*****K#PART        CHAIN     LEPARTD1                           99                      CLE106
     C******IN99         IFEQ      '0'                                                        CLE106
     C*****WSVVD         ANDLT     JDTE                                                       CLE106
     C**********         MOVE      '1'           *IN99                                        CLE106
     C**********         ELSE                                                                 CLE106
     C**********         MOVE      'Y'           WRISK                                        CLE106
     C**********         ENDIF                                                                CLE106
     C**********         ENDIF                                                                CLE106
      *
      ***  For an internal parts purchased, customer purchased from
      ***  must be the Agent of the facility branch
      *
     C     *IN82         IFEQ      '1'
     C     WAGENT        ANDEQ     W#SYCU
     C     *IN99         IFEQ      '0'
     C     PRTR          ANDNE     'I'
     C     *IN99         OREQ      '1'
     C                   MOVE      'N'           DDPFRMOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPFRM'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0044'     MsgIDXAr(Idx)
     C                   ENDIF
     C     W#SYCU        IFNE      WSVCN
     C                   MOVE      'N'           DDPFRMOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDPFRM'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0045'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ***  For a non-direct parts sold, loan customer must not be
      ***  the BIC of the facility branch
      *
     C     *IN83         IFEQ      '1'
     C     *IN99         IFEQ      '0'
     C     BRCAF         ANDNE     DDBRCA
     C     PRTR          ANDNE     'P'
     C     PRTR          ANDNE     'S'                                                        CLE106
     C     PRTR          ANDNE     'I'
     C     WLNPT         ANDNE     72
     C     *IN99         OREQ      '0'
     C     BRCAF         ANDEQ     DDBRCA
     C     PRTR          ANDNE     'P'
     C     PRTR          ANDNE     'S'                                                        CLE106
     C     WLNPT         ANDNE     72
     C     *IN99         OREQ      '1'
     C                   MOVE      'N'           DDCUSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCUST'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0044'     MsgIDXAr(Idx)
     C                   ENDIF
     C     A8BICN        IFEQ      WSVCN
     C                   MOVE      'N'           DDCUSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCUST'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0046'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ***  Save participant facility details if no error
      *
     C     *IN82         IFEQ      '1'
     C     WAGENT        ANDEQ     W#SYCU
     C*****WRISK         OREQ      *BLANK                                                     CLE106
     C******IN83         ANDEQ     '1'                                                        CLE106
     C     *IN83         OREQ      '1'                                                        CLE106
     C     CLE106        OREQ      'Y'                                                        CLE106
     C                   MOVE      PRTR          WLPFI
     C                   MOVE      PASI          WPASI
     C**********         Z-ADD     CNUMF         WPTFC                                        CSD027
     C                   EVAL      WPTFC = CNUMF                                              CSD027
     C                   Z-ADD     FACT          WPTFT
     C                   Z-ADD     FCNO          WPTFN
     C                   ELSE
     C                   MOVE      *BLANK        WLPFI
     C*****WRISK         IFEQ      'Y'                                                        CLE106
     C**********         MOVE      'R'           WLPFI                                        CLE106
     C**********         ENDIF                                                                CLE106
     C**********         Z-ADD     *ZEROS        WPTFC                                        CSD027
     C                   EVAL      WPTFC = *BLANKS                                            CSD027
     C                   Z-ADD     *ZEROS        WPTFT
     C                   Z-ADD     *ZEROS        WPTFN
     C                   ENDIF
      *
     C                   ENDIF
                                                                                              CLE106
     C                   ELSE                                                                 CLE106
                                                                                              CLE106
      ** Error if loan is not Internal Parts Purchased or Parts Sold but                      CLE106
      ** Linked to Syndicate has been entered.                                                CLE106
                                                                                              CLE106
     C                   IF        DDLNKS = 'Y'                                               CLE106
     C                   EVAL      DDLNKSOK = 'N'                                             CLE106
     C                   EVAL      Idx = Idx + 1                                              CLE106
     C                   EVAL      FldNamXAr(Idx) = 'DDLNKS'                                  CLE106
     C                   EVAL      MsgIDXAr(Idx) = 'LEL0426'                                  CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF
      *
     C     DDLNKSOK      IFNE      'N'
     C     DDFCUSOK      ANDNE     'N'
     C     DDFTYPOK      ANDNE     'N'
     C     DDFSEQOK      ANDNE     'N'
     C     DDPFRMOK      ANDNE     'N'
     C     DDOLNOOK      ANDNE     'N'
     C     DDCUSTOK      ANDNE     'N'
     C                   MOVE      DDLNKS        CCLLNKS                                      CLE106
     C                   MOVEL     DDDFTP        CCLDFTP
     C                   MOVE      WLPFI         CCLLPFI
     C**********         Z-ADD     WPTFC         CCLPTFC                                      CSD027
     C                   EVAL      CCLPTFC = WPTFC                                            CSD027
     C                   Z-ADD     WPTFT         CCLPTFT
     C                   Z-ADD     WPTFN         CCLPTFN
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRASSN  -  Validate assignment (For Part. Purchase)           *
      *****************************************************************
     C     SRASSN        BEGSR
      *
     C     *IN82         IFEQ      '1'
      *
      ***  Must be 'P', 'A' or blank
      *
     C     DDASSN        IFNE      'P'
     C     DDASSN        ANDNE     'A'
     C     DDASSN        ANDNE     *BLANK
     C                   MOVE      'N'           DDASSNOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDASSN'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0084'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C     DDASSNOK      IFNE      'N'
     C     SYINF         IFNE      'Y'
      *
      ***  For participation purchased against non-syndicated
      ***  facility, assignment flag must be 'P'
      *
     C     DDASSN        IFEQ      *BLANK
     C                   MOVE      'P'           DDASSN
     C                   MOVE      'P'           GASS
     C                   ELSE
     C     DDASSN        IFNE      'P'
     C                   MOVE      'N'           DDASSNOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDASSN'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0085'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
      ***  For participation  purchased against syndicated
      ***  facility, it will default to value on participant facility
      *
     C     DDASSN        IFEQ      *BLANK
     C     DDFCUSOK      ANDNE     'N'
      *
     C                   MOVE      WPASI         DDASSN
     C                   MOVE      WPASI         GASS
      *
     C     WCPRTR        IFNE      'A'
     C     WCPRTR        ANDNE     *BLANK
     C                   MOVE      WCPMFC        WFCNUM
     C                   MOVE      WCPMFT        WFFACT
     C                   MOVE      WCPMFN        WFFCNO
     C                   MOVE      'A'           WFRCTP
     C     WKFAC         CHAIN(N)  FCLTY                              99
      *
     C     *IN99         IFEQ      *OFF
     C                   EXSR      SRCKFR
     C                   ENDIF
      *
     C     *IN99         IFEQ      '1'
     C     *IN99         OREQ      '0'
     C     RECIF         ANDNE     'D'
     C     WREAC         ANDEQ     *OFF
     C     *LOCK         IN        LDA
     C                   MOVEL     'FCLTY   '    DBFILE                         *************
     C                   Z-ADD     5             DBASE                          * DBERR 005 *
     C                   MOVEL     FCTREC        DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVE      CNUM          WAGENT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ***  Derive value for Assignment (A or P), for part. sold,
      ***  where inserting in interactive mode:-
      ***  Only perform if no other screen errors.
      *
     C     *IN83         IFEQ      *ON
     C     RespMode      ANDEQ     'S'
     C     DDACTN        ANDEQ     'I'
     C     *IN83         OREQ      *ON                                                        247441
     C     ModeofOp      ANDEQ     '*FRONT'                                                   247441
     C     DDACTN        ANDEQ     'I'                                                        247441
     C                   MOVE      'P'           DDASSN
     C                   MOVE      'P'           GASS
      *
      ***  1. Default first to value on participant facility
      ***  2. Set to 'A' if syndicated facility and assignment
      ***     exists with 'introduced by' = agent
      ***     and 'joining date' = start date of loan.
      *
     C     SYINF         IFEQ      'Y'
      *
      * Get sale of loan facility for facility branch
     C     K#FCLT        CHAIN(N)  FCLTYFMF                           99
      *
     C     *IN99         IFEQ      *OFF
     C                   EXSR      SRCKFR
     C                   ENDIF
      *
     C     *IN99         IFEQ      *ON
     C     *IN99         OREQ      *OFF
     C     RECIF         ANDNE     'D'
     C     WREAC         ANDEQ     *OFF
     C     *LOCK         IN        LDA
     C                   MOVEL     'FCLTY'       DBFILE                         *************
     C                   Z-ADD     6             DBASE                          * DBERR 006 *
     C                   MOVEL     D#SLFC        DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Get syndicate agent for sale of loan facility branch
      *
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      BRCAF         @BRCD
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBRCHPD'    DBFILE                         *************
     C                   Z-ADD     7             DBASE                          * DBERR 007 *
     C                   MOVEL     PBRCA         DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      WPASI         DDASSN
     C                   MOVE      WPASI         GASS
      *
     C     DDASSN        IFNE      'A'
     C     K#PART        CHAIN     LEPARTL2                           99
     C     *IN99         DOWEQ     *OFF
     C     INUM          IFEQ      ANUM
     C     JDTE          ANDEQ     WSVVD
     C                   MOVE      'A'           DDASSN
     C                   MOVE      'A'           GASS
     C                   LEAVE
     C                   ENDIF
     C     K#PART        READE     LEPARTL2                               99
     C                   ENDDO
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** If not Internal Parts Purchased nor Parts Sold, Assignment should not be entered     CLE106
      ** If entered value is equal to 'A', else it is equal to 'P'                            CLE106
                                                                                              CLE106
     C                   IF        *IN82 = *OFF And *IN83 = *OFF                              CLE106
     C                             And DDASSN = 'A'                                           CLE106
     C                   EVAL      DDASSNOK = 'N'                                             CLE106
     C                   EVAL      Idx = Idx + 1                                              CLE106
     C                   EVAL      FldNamXAr(Idx) = 'DDASSN'                                  CLE106
     C                   EVAL      MsgIDXAr(Idx) = 'LEL0428'                                  CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
     C     DDASSNOK      IFNE      'N'
     C                   MOVEL     DDASSN        CCLGASS
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSOLD  -  Additional validation for parts sold               *
      *****************************************************************
     C     SRSOLD        BEGSR
      *
      ***  Customer must not match customer of related loan
      *
     C     DDCUSTOK      IFNE      'N'
     C     WSVCN         ANDEQ     CNUMM
     C                   MOVE      'N'           DDCUSTOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCUST'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0121'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  Branch must equal the branch of the related loan
      *
     C     DDBRCAOK      IFNE      'N'
     C     DDBRCA        ANDNE     BRCAM
     C                   MOVE      'N'           DDBRCAOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDBRCA'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0033'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  Currency must equal the currency of the related loan
      *
     C     DDCURROK      IFNE      'N'
     C     DDCURR        ANDNE     CCYM
     C                   MOVE      'N'           DDCURROK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCURR'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0118'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  Sum of the entry and the amount sold on the related loan
      ***  should not exceed the current principal amount of the related
      ***  loan on insert
      *
     C                   MOVE      'N'           WRISP
     C     PTYPM         IFEQ      72
     C     WLNPT         ANDEQ     72
     C     WKEY          CHAIN     LEPARTL1                           99
     C     *IN99         IFEQ      '0'
     C                   MOVE      'Y'           WRISP             1
     C                   ENDIF
     C                   ENDIF
      *
     C     DDACTN        IFEQ      'I'
     C     DDCPAMOK      ANDNE     'N'
     C     PTYPM         ANDNE     72
     C     WLNPT         ANDNE     72
     C     DDACTN        OREQ      'I'
     C     DDCPAMOK      ANDNE     'N'
     C     WRISP         ANDEQ     'N'
     C     PTYPM         ANDEQ     72
     C     WLNPT         ANDEQ     72
     C     DDACTN        OREQ      'I'
     C     DDCPAMOK      ANDNE     'N'
     C     PTYPM         ANDEQ     70
     C     WLNPT         ANDEQ     72
     C     DDACTN        OREQ      'I'
     C     DDCPAMOK      ANDNE     'N'
     C     PTYPM         ANDEQ     71
     C     WLNPT         ANDEQ     72
     C     PSAMM         ADD       WSVAM         WSVPA            13 0
      *
      ***  Include some loan amendments in computing the current
      ***  principal amount of the originating loan available for
      ***  part sold.
      *
     C                   Z-ADD     CPAMM         WCPAMM           13 0
     C                   MOVE      DDOLNO        WLLOAN
     C     WLLOAN        SETLL     LOAMS
     C     WLLOAN        READE     LOAMS                                  99
      *
     C     *IN99         DOWEQ     '0'
     C     VDATA         ANDLE     WSVVD
      *
     C     RECIA         IFEQ      'D'
      *
     C     AMTPA         IFEQ      'PI'
     C     AMTPA         OREQ      'PT'
     C                   ADD       PRAM          WCPAMM
     C                   ENDIF
      *
     C     AMTPA         IFEQ      'PF'
     C     AMTPA         OREQ      'RE'
     C     AUTO          ANDEQ     'Y'
      *                                                                                       CLE134
     C     AMTPA         OREQ      'RE'                                                       CLE134
     C     AUTO          ANDEQ     'C'                                                        CLE134
     C     CLE134        ANDEQ     'Y'                                                        CLE134
      *                                                                                       CLE134
     C     AMTPA         OREQ      'MR'
     C                   SUB       PRAM          WCPAMM
      *
      ***  Saved part sold amount (WSVPA) should not be deducted with MR,
      ***  RE, or PF principal amount.  Deduction may cause WSVAM to be
      ***  greater than the available principal amount for part sold.
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     WLLOAN        READE     LOAMS                                  99
     C                   ENDDO
      *
     C                   MOVE      *IN01         WIN01             1
     C     1             SETLL     CLOANLJ
     C                   READ      CLOANLJ                                01
      *
     C     *IN01         DOWEQ     '0'
      *
     C     RECIX         IFEQ      'D'
      *
     C                   EVAL      OLNOAlpha = OLNOX                                          CSD027
     C*****WLLOAN        IFEQ      OLNOX                                                      CSD027
     C     WLLOAN        IFEQ      OLNONum                                                    CSD027
     C     WLLOAN        OREQ      MLNRX
      *
      ***  Check for the amendments made aginst the participations sold
      ***  loan/ IPP loan.
      *
     C                   MOVE      '0'           *IN01
      *
     C     LNRFX         SETLL     LOAMS
     C     LNRFX         READE     LOAMS                                  01
      *
      ***  Check the amendments for the loan with value date less than or
      ***  equal to the loan's (to be inserted) value date.
      *
     C     *IN01         DOWEQ     '0'
     C     VDATA         ANDLE     WSVVD
      *
     C     RECIA         IFEQ      'D'
      *
      ***  for loans attached to the original/mirror loan, if amendment
      ***  type is PI, add the principal amount to the loan's CPAM then
      ***  add the same amount to the orignal/mirror loan's part sold
      *
     C     AMTPA         IFEQ      'PI'
     C                   ADD       PRAM          CPAMX
     C                   ADD       PRAM          WSVPA
     C                   ENDIF
      *
      ***  If amendment type is PT, add the amount to the loan's CPAM
      ***  PSAM should not be updated because it was already updated in
      ***  menu PTMN.
      *
     C     AMTPA         IFEQ      'PT'
     C                   ADD       PRAM          CPAMX
     C                   ENDIF
      *
      ***  If amendment type is PF, deduct the amount to the loan's CPAM
      ***  PSAM should not be updated because it was already updated in
      ***  menu PTMN.
      *
     C     AMTPA         IFEQ      'PF'
     C                   SUB       PRAM          CPAMX
     C                   ENDIF
      *
      ***  If AMTP is MR/RE, deduct amount from loan's CPAM and from the
      ***  orginal/mirror loan's PSAM.
      *
     C     AMTPA         IFEQ      'RE'
     C     AUTO          ANDEQ     'Y'
      *                                                                                       CLE134
     C     AMTPA         OREQ      'RE'                                                       CLE134
     C     AUTO          ANDEQ     'C'                                                        CLE134
     C     CLE134        ANDEQ     'Y'                                                        CLE134
      *                                                                                       CLE134
     C     AMTPA         OREQ      'MR'
     C                   SUB       PRAM          CPAMX
     C                   SUB       PRAM          WSVPA
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     LNRFX         READE     LOAMS                                  01
     C                   ENDDO
      *
     C                   MOVE      '0'           *IN01
      *
     C     MDATX         IFLE      WSVVD
     C     MDATX         ANDGT     0
     C     AUTOX         ANDEQ     'Y'
      *                                                                                       CLE134
     C     MDATX         ORLE      WSVVD                                                      CLE134
     C     MDATX         ANDGT     0                                                          CLE134
     C     AUTOX         ANDEQ     'C'                                                        CLE134
     C     CLE134        ANDEQ     'Y'                                                        CLE134
      *                                                                                       CLE134
     C     WSVPA         SUB       CPAMX         WSVPA
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   READ      CLOANLJ                                01
     C                   ENDDO
      *
     C                   MOVE      WIN01         *IN01
      *
      ***  If called by principal transfer, validation is not needed
      *
     C     PGNTF         IFEQ      'Y'
     C     RespMode      ANDNE     'S'
     C                   ELSE
     C     WSVPA         IFGT      WCPAMM
     C                   MOVE      'N'           DDCPAMOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDCPAM'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0119'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ***  Deal date must not be earlier than the deal date of the
      ***  related loan
      *
     C     DDDDATOK      IFNE      'N'
     C     WSVDD         ANDLT     DDATM
     C                   MOVE      'N'           DDDDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDDDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0115'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  Start date must not be earlier than the start date of the
      ***  related loan
      *
     C     DDVDATOK      IFNE      'N'
     C     WSVVD         ANDLT     VDATM
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDVDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0116'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  Maturity date must not be later than maturity date of
      ***  the related loan
      *
     C     DDMDATOK      IFNE      'N'
     C     WSVMD         ANDGT     MDATM
     C     NMDTM         ANDEQ     *ZERO                                                      237744
     C     DDMDATOK      ORNE      'N'                                                        237744
     C     WSVMD         ANDGT     NMDTM                                                      237744
     C     NMDTM         ANDGT     MDATM                                                      237744
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0117'     MsgIDXAr(Idx)
     C                   ENDIF
      *                                                                                       237744
      ** ...to ensure that call parts sold will mature earlier or                             237744
      ** at the same day the related loan will mature, call parts                             237744
      ** sold should not be allowed to have a blank maturity date                             237744
      ** if the related loan has an existing maturity date                                    237744
      *                                                                                       237744
     C     DDMDATOK      Ifne      'N'                                                        237744
     C     WLNPT         Ifeq      69                                                         237744
     C     WSVMD         Andeq     *Zero                                                      237744
     C     MDATM         AndGt     *Zero                                                      237744
     C                   Move      'N'           DDMDATOK                                     237744
     C                   Add       1             Idx                                          237744
     C                   Movel     'DDMDAT'      FldNamXAr(Idx)                               237744
     C                   Movel     'LEL0210'     MsgIDXAr(Idx)                                237744
     C                   Endif                                                                237744
     C                   Endif                                                                237744
      *
      ***  Maturity date of a discount parts sold must equal that
      ***  of the related loan
      *
     C     RespMode      IFEQ      'S'
     C     RespMode      ORNE      'S'
     C     SYINF         ANDNE     'Y'
     C     DDACTN        IFEQ      'A'
     C     WLNPT         ANDEQ     67
     C     WSVMD         ANDNE     @@MDAT
     C     DDACTN        OREQ      'A'
     C     WLNPT         ANDEQ     72
     C     W72TP         ANDEQ     '67'
     C     WSVMD         ANDNE     @@MDAT
      *
      ***  Cannot early mature a disc loan with rollover details nor
      ***  can maturity date be extended
      *
     C     WSVMD         IFLT      @@MDAT
     C     @@RLDT        ANDNE     *ZEROS
     C     WSVMD         ORGT      @@MDAT
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0097'     MsgIDXAr(Idx)
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRMATY  -  Further validation of maturity date for amend      *
      *****************************************************************
     C     SRMATY        BEGSR
      *
      ***  For amended disc. loans, maturity date can be amended
      ***  only to a date earlier than the original maturity date,
      ***  unless it is for a discounted loan with rollover details
      *
     C     WLNPT         IFEQ      63
     C     WSVMD         IFGT      @@MDAT
     C     WSVMD         ORLT      @@MDAT
     C     @@RLDT        ANDNE     *ZEROS
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0097'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ENDIF
      *
      ***  Discounted parts purchased cannot have their maturity
      ***  dates amended
      *
     C     WLNPT         IFEQ      65
     C     WSVMD         ANDNE     @@MDAT
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0128'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      ***  In amend mode where there are participants, loan maturity
      ***  must be on or later than maturity date of participation
      ***  (for loans and parts purchased)
      ***  Only if not in batch mode or in batch mode but the loan is
      ***  linked to an unsyndicated facility
      *
     C     RespMode      IFEQ      'S'
     C     RespMode      ORNE      'S'
     C     SYINF         ANDNE     'Y'
     C     *IN83         IFEQ      '0'
     C     @@NOPS        IFGT      *ZEROS
     C                   Z-ADD     99999         WMDAT
     C                   EVAL      OLNONum = @@LNRF                                           CSD027
     C                   EVAL      @@LNRFA = OLNOAlpha                                        CSD027
     C     WKPAR         SETLL     PSOLDLL
     C                   READ      PSOLDLL                                99
     C*****@@LNRF        IFEQ      POLNO                                                      CSD027
     C                   EVAL      OLNOAlpha = POLNO                                          CSD027
     C     @@LNRF        IFEQ      OLNONum                                                    CSD027
     C     WSVMD         ANDLT     PMDTE
      *                                                                                       243770
      ** Check if all participations are still linked from the primary,                       243770
      ** if yes, bypass validation else display error msg                                     243770
      *                                                                                       243770
     C                   EVAL      WrkBypass = 'N'                                            243770
     C                   IF        CLE106 = 'Y'                                               243770
     C                   EVAL      OLNOAlpha = POLNO                                          CPK027
     C**********         DOW       @@LNRF = POLNO                                      243770 CPK027
     C                   DOW       @@LNRF = OLNONum                                           CPK027
     C                             AND *IN99 = *OFF                                           243770
      *                                                                                       243770
     C                   IF        PLNKS = 'N'                                                243770
     C                   EVAL      Wrkbypass = 'N'                                            243770
     C                   LEAVE                                                                243770
     C                   ELSE                                                                 243770
     C                   EVAL      Wrkbypass = 'Y'                                            243770
     C                   ENDIF                                                                243770
      *                                                                                       243770
     C                   READ      PSOLDLL                                99                  243770
     C                   EVAL      OLNOAlpha = POLNO                                          CPK027
     C                   ENDDO                                                                243770
     C                   ENDIF                                                                243770
      *                                                                                       243770
     C                   IF        WrkBypass = 'N'                                            243770
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0132'     MsgIDXAr(Idx)
     C                   ENDIF                                                                243770
      *                                                                                       243770
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ***  If maturity date is amended to be earlier than rundate
      ***  generate a warning message
      *
     C     WSVMD         IFNE      @@MDAT
     C     WSVMD         ANDLT     BJRDNB
     C*****WE020         IFEQ      *BLANK                                                    BUG4351
     C*****WE020         OREQ      'Y'                                                       BUG4351
     C*****WSVMD         ANDNE     W1MD                                                      BUG4351
     C**********         Z-ADD     WSVMD         W1MD              5 0                       BUG4351
     C**********         MOVE      'Y'           WE020             1                         BUG4351
     C                   MOVE      'W'           DDMDATOK
     C                   ADD       1             WId
     C                   MOVEL     'DDMDAT'      WFldNmXAr(WId)
     C                   MOVEL     'LEL0080'     WMsgIDXAr(WId)
     C**********         ENDIF                                                               BUG4351
     C                   ENDIF
      *
      ***  Maturity date must be later than interest, rollover and
      ***  and repayment dates when amended
      *
     C     WSVMD         IFNE      @@MDAT
      *
     C     DDRLDTOK      IFNE      'N'
     C     WSVMD         IFLE      @@RLDT
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0131'     MsgIDXAr(Idx)
     C                   Z-ADD     W#NIDT        ZDAYNO
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE             6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   MOVE      ZADATE        O#NIDT
     C                   Z-ADD     W@NRPD        ZDAYNO
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         ZDATE
     C                   PARM      *BLANK        ZADATE
     C                   MOVE      ZADATE        O#NRPD
     C**********         MOVEL     DATMSG        MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DATMSG))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DATMSG)                   MD000091
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                     AR740107
      ** If maturity date is amended to be equal to Next Repayment                          AR740107
      ** date generate a warning message                                                    AR740107
      *                                                                                     AR740107
     C     WSVMD         IFNE      @@MDAT                                                   AR740107
     C     WSVMD         ANDEQ     @@NRPD                                                   AR740107
     C                   MOVE      'W'           DDMDATOK                                   AR740107
     C                   ADD       1             WId                                        AR740107
     C                   MOVEL     'DDMDAT'      WFldNmXAr(WId)                             AR740107
     C                   MOVEL     'LEL0812'     WMsgIDXAr(WId)                             AR740107
     C                   ENDIF                                                              AR740107
      *
      ***  Maturity date cannot be amended before last actioned event
      *
     C                   MOVE      DDLNRF        WLLOAN                                     AR682750
     C     WLLOAN        SETGT     HISTSL0                                                  AR682750
     C     WLLOAN        READPE    HISTSL0                                99                AR682750
      *                                                                                     AR682750

     C     DDACTN        IFEQ      'A'
     C     WSVMD         ANDLT     @@IACD
     C     DDACTN        OREQ      'A'                                                      AR682750
     C     WLLOAN        ANDEQ     JLNRF                                                    AR682750
     C     WSVMD         ANDLT     JVDAT                                                    AR682750
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0235'     MsgIDXAr(Idx)
     C                   ENDIF
      *
      *****Cannot*amend*maturity*date*to*be*later*than*the*last********                     AR740717
      *****loan*amendment*date*****************************************                     AR740717
      **   Cannot amend maturity date to be earlier than existing                           AR740717
      **   loan amendment date except Repayment Schedule.                                   AR740717
      *                                                                                     AR682750
     C                   MOVE      DDLNRF        WLLOAN                                     AR682750
     C                   Z-ADD     99999         WLVDAT                                     AR682750
     C                   Z-ADD     99            WLLASN                                     AR682750
     C     WKLAM         SETGT     LOAMS                                                    AR682750
     C                   READP(N)  LOAMS                                  99                AR682750
     C     *IN99         DOWEQ     '0'                                                      AR682750
     C     LNRFA         IFEQ      @@LNRF                                                   AR682750
     C     RECIA         ANDEQ     'D'                                                      AR682750
     C     AMTPA         ANDNE     'RE'                                                     AR682750
     C     WSVMD         ANDLE     VDATA                                                    AR740717
      *                                                                                     AR740717
     C     AMTPA         IFEQ      'LS'                                                     AR740717
     C     AMTPA         OREQ      'SC'                                                     AR740717
     C     AMTPA         OREQ      'BC'                                                     AR740717
     C     AMTPA         OREQ      'SA'                                                     AR740717
     C     AMTPA         OREQ      'PI'                                                     AR740717
     C                   MOVE      'N'           DDMDATOK                                   AR682750
     C                   ADD       1             Idx                                        AR682750
     C                   MOVEL     'DDMDAT'      FldNamXAr(Idx)                             AR682750
     C                   MOVEL     'LEL0133'     MsgIDXAr(Idx)                              AR682750
     C                   MOVE      '1'           *IN99                                      AR682750
     C                   ENDIF                                                              AR740717
      *                                                                                     AR740717
     C     WSVMD         IFLT      VDATA                                                    AR740717
     C     AMTPA         IFEQ      'MR'                                                     AR740717
     C     AMTPA         OREQ      'PT'                                                     AR740717
     C     AMTPA         OREQ      'PF'                                                     AR740717
     C                   MOVE      'N'           DDMDATOK                                   AR740717
     C                   ADD       1             Idx                                        AR740717
     C                   MOVEL     'DDMDAT'      FldNamXAr(Idx)                             AR740717
     C                   MOVEL     'LEL0133'     MsgIDXAr(Idx)                              AR740717
     C                   MOVE      '1'           *IN99                                      AR740717
     C                   ENDIF                                                              AR740717
     C                   ENDIF                                                              AR740717
      *                                                                                     AR740717
      ** If valid record, read next LOAMS record                                            AR740717
      *                                                                                     AR740717
     C*****DDMDATOK      IFNE      'N'                                             AR740717 MD025864
     C     *IN99         IFNE      '1'                                                      MD025864
     C                   ReadP(N)  LOAMS                                  99                AR740717
     C                   ENDIF                                                              AR740717
      *                                                                                     AR740717
     C                   ELSE                                                               AR682750
      *                                                                                     AR722666
      ** Issue error if maturity date <> maturity date from LS change.                      AR722666
      *                                                                                     AR722666
     C     LNRFA         IFEQ      @@LNRF                                                   AR722666
     C     RECIA         ANDEQ     'D'                                                      AR722666
     C     AMTPA         ANDEQ     'LS'                                                     AR722666
     C     WSVMD         ANDNE     LSMDA                                                    AR722666
     C                   MOVE      'N'           DDMDATOK                                   AR722666
     C                   ADD       1             Idx                                        AR722666
     C                   MOVEL     'DDMDAT'      FldNamXAr(Idx)                             AR722666
     C**********         MOVEL     'LEL0830'     MsgIDXAr(Idx)                     AR722666 MD022946
     C                   MOVEL     '5046145'     MsgIDXAr(Idx)                              MD022946
     C                   MOVE      '1'           *IN99                                      AR722666
     C                   ENDIF                                                              AR722666
      *                                                                                     AR722666
     c     LNRFA         IFNE      @@LNRF                                                   AR682750
     C                   MOVE      '1'           *IN99                                      AR682750
     C                   ELSE                                                               AR682750
     C                   READP(N)  LOAMS                                  99                AR682750
     C                   ENDIF                                                              AR682750
     C                   ENDIF                                                              AR682750
     C                   ENDDO                                                              AR682750
      *                                                                                    AR740107A
      ** If Maturity Date is amended check if there is a                                   AR740107A
      ** Repayment schedule on the same day                                                AR740107A
      *                                                                                    AR740107A
     C                   MOVE      DDLNRF        WLLOAN                                    AR740107A
     C                   Z-ADD     99999         WLVDAT                                    AR740107A
     C                   Z-ADD     99            WLLASN                                    AR740107A
     C     WKLAM         SETGT     LOAMS                                                   AR740107A
     C                   READP(N)  LOAMS                                  99               AR740107A
      *                                                                                    AR740107A
     C     *IN99         DOWEQ     '0'                                                     AR740107A
     C     LNRFA         ANDEQ     @@LNRF                                                  AR740107A
     C     VDATA         ANDGE     WSVMD                                                   AR740107A
     C     RECIA         IFEQ      'D'                                                     AR740107A
     C     WSVMD         ANDEQ     VDATA                                                   AR740107A
     C     AMTPA         ANDEQ     'RE'                                                    AR740107A
     C                   MOVE      'W'           DDMDATOK                                  AR740107A
     C                   ADD       1             WId                                       AR740107A
     C**********         MOVEL     'DDMDAT'      WFldNmXAr(WId)                  AR740107A AR1096933
     C                   EVAL      WFldNmXAr(WId) = 'DDNRPD'                               AR1096933
     C**********         MOVEL     'LEL0813'     WMsgIDXAr(WId)                  AR740107A AR1096933
     C                   EVAL      WMsgIDXAr(WId) = '5045918'                              AR1096933
     C                   MOVE      '1'           *IN99                                     AR740107A
     C                   ENDIF                                                             AR740107A
      *                                                                                    AR740107A
     C                   ReadP(N)  LOAMS                                  99               AR740107A
     C                   ENDDO                                                             AR740107A
      *
     C                   MOVE      DDLNRF        WLLOAN
     C                   Z-ADD     99999         WLVDAT
     C                   Z-ADD     99            WLLASN
     C     WKLAM         SETGT     LOAMS
     C     *IN99         DOUEQ     '1'
     C     RECIA         OREQ      'D'
     C                   READP(N)  LOAMS                                  99
     C                   ENDDO
      *
      ***  Generate a warning message if CLE005 is installed,
      ***  otherwise, display an error message
      *
     C     *IN99         IFEQ      '0'
     C     LNRFA         ANDEQ     @@LNRF
     C     WSVMD         ANDLT     VDATA
     C     AMTPA         ANDNE     'PT'                                                       244891
     C     AMTPA         ANDNE     'PF'                                                       244891
     C     CLE005        IFEQ      'Y'
     C     CLE007        ANDEQ     'Y'
     C*****WE021         IFEQ      *BLANK                                                    BUG4351
     C*****WE021         OREQ      'Y'                                                       BUG4351
     C*****WSVMD         ANDNE     W1MD                                                      BUG4351
     C*****WE021         OREQ      'Y'                                                       BUG4351
     C*****WSVMD         ANDEQ     W1MD                                                      BUG4351
     C*****WSVMD         ANDNE     INDAT                                                     BUG4351
     C**********         Z-ADD     WSVMD         INDAT             5 0                       BUG4351
     C**********         Z-ADD     WSVMD         W1MD                                        BUG4351
     C**********         MOVE      'Y'           WE021             1                         BUG4351
     C                   MOVE      'W'           DDMDATOK
     C                   ADD       1             WId
     C                   MOVEL     'DDMDAT'      WFldNmXAr(WId)
     C                   MOVEL     'LEL0081'     WMsgIDXAr(WId)
     C**********         ENDIF                                                               BUG4351
     C                   ELSE
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0133'     MsgIDXAr(Idx)
     C                   ENDIF
     C                   ELSE
     C**********         Z-ADD     WSVMD         INDAT                                       BUG4351
     C                   ENDIF
      *                                                                                       244891
      ** Get latest principal transfer record.                                                244891
      *                                                                                       244891
     C                   Z-ADD     0             WPTDAT            5 0                        244891
     C                   Z-ADD     0             WLVDAT                                       244891
     C                   Z-ADD     0             WLLASN                                       244891
     C     WKLAM         SETLL     LOAMS                                                      244891
     C                   READ      LOAMS                                                      244891
     C                   DOW       NOT %EOF(LOAMS)                                            244891
     C                             AND LNRFA = WLLOAN                                         244891
     C                   IF        RECIA = 'D'                                                244891
      *                                                                                       244891
     C                   IF        VDATA > WPTDAT                                             244891
     C                             AND AMTPA = 'PT'                                           244891
     C                             OR VDATA > WPTDAT                                          244891
     C                             AND AMTPA = 'PF'                                           244891
     C                   EVAL      WPTDAT = VDATA                                             244891
     C                   ENDIF                                                                244891
      *                                                                                       244891
     C                   ENDIF                                                                244891
     C                   READ      LOAMS                                                      244891
     C                   ENDDO                                                                244891
      *                                                                                       244891
      ** Issue error when maturity date is earlier than the value date of                     244891
      ** any pending principal transfer.                                                      244891
      *                                                                                       244891
     C                   IF        WPTDAT > WSVMD                                             244891
     C                             AND WSVMD <> 0                                             244891
     C                   MOVE      'N'           DDMDATOK                                     244891
     C                   ADD       1             Idx                                          244891
     C                   MOVEL     'DDMDAT'      FldNamXAr(Idx)                               244891
     C                   MOVEL     'LEL0176'     MsgIDXAr(Idx)                                244891
     C                   ENDIF                                                                244891
      *
      ***  Check that the Maturity date is greater than the End Dates
      ***  of any Fees attached to the Loan.
      *
      ***  Not applicable to Call/Demand Loans (PTYP 61) as these
      ***  have no Maturity Date.
      *
     C     WLNPT         IFNE      61
      *
     C                   MOVEL     DDCUST        FCNUM
     C                   MOVEL     DDLNRF        FLOAN
      *
     C     LEFKEY        SETLL     LEFEEDL2
     C     LEFKEY        READE     LEFEEDL2                               99
      *
     C     *IN99         DOWEQ     *OFF
      *
     C     FERECI        IFEQ      'D'                                                     AR1053735
      *                                                                                    AR1053735
     C     WSVMD         IFLT      FEPEND
     C     FERECI        ANDNE     '*'                                                      AR970786
     C     FECALT        ANDNE     '97'                                                       261084
     C     FECALT        ANDNE     '98'                                                       261084
     C     FECALT        ANDNE     '99'                                                       261084
     C*****WSVMD         ORLT      FEPEND                                           CLE134 AR1081637
     C     FECALT        ANDNE     '90'                                                       CLE134
     C                   MOVE      'N'           DDMDATOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDMDAT'      FldNamXAr(Idx)
     C                   MOVEL     'LEL0202'     MsgIDXAr(Idx)
     C                   LEAVE
     C                   ENDIF
      *                                                                                     MD031089
      ** For fees 97, 98, and 99, isssue error message when maturity date                   MD031089
      ** is less than or equal to fee start date                                            MD031089
      ** and system value AutoEndCalcLoanFee' is 'Y'                                        MD046370
      *                                                                                     MD031089
     C     WSVMD         IFLE      FEPSTD                                                   MD031089
     C     FEPEND        ANDGT     BJRDNB                                                   MD031089
     C     FECALT        IFEQ      '90'                                                     MD031089
     C     FECALT        OREQ      '97'                                                     MD031089
     C     AutoEndFee    ANDEQ     'Y'                                                      MD046370
     C     FECALT        OREQ      '98'                                                     MD031089
     C     AutoEndFee    ANDEQ     'Y'                                                      MD046370
     C     FECALT        OREQ      '99'                                                     MD031089
     C     AutoEndFee    ANDEQ     'Y'                                                      MD046370
     C                   MOVE      'N'           DDMDATOK                                   MD031089
     C                   ADD       1             Idx                                        MD031089
     C                   MOVEL     'DDMDAT'      FldNamXAr(Idx)                             MD031089
     C                   MOVEL     '5047475'     MsgIDXAr(Idx)                              MD031089
     C                   LEAVE                                                              MD031089
     C                   ENDIF                                                              MD031089
     C                   ENDIF                                                              MD031089
      *                                                                                       261084
      ** For fees 97, 98, and 99, check that the entered maturity date                        261084
      ** is not before last payment date                                                      261084
      *                                                                                       261084
     C     WSVMD         IFLT      FELPDT                                                     261084
     C     FECALT        IFEQ      '97'                                                       261084
     C     FECALT        OREQ      '98'                                                       261084
     C     FECALT        OREQ      '99'                                                       261084
     C                   MOVE      'N'           DDMDATOK                                     261084
     C                   ADD       1             Idx                                          261084
     C                   MOVEL     'DDMDAT'      FldNamXAr(Idx)                               261084
     C                   MOVEL     '5045712'     MsgIDXAr(Idx)                                261084
     C                   LEAVE                                                                261084
     C                   ENDIF                                                                261084
     C                   ENDIF                                                                261084
      *
     C                   ENDIF                                                             AR1053735
     C     LEFKEY        READE     LEFEEDL2                               99
     C                   ENDDO
      *
     C                   ENDIF
                                                                                             BUG3721
      ** Additional validation for processing type 80 if loan is for                         BUG3721
      ** early maturity                                                                      BUG3721
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     WLNPT         ANDEQ     80                                                        BUG3721
     C     WSVMD         ANDNE     @@MDAT                                                    BUG3721
                                                                                             BUG3721
     C                   Z-ADD     @@MDAT        ZDAYNO                                      BUG3721
     C                   CALLB     'ZDATE2'                                                  BUG3721
     C                   PARM                    ZDAYNO                                      BUG3721
     C                   PARM                    BJDFIN                                      BUG3721
     C                   PARM      *ZERO         ZDATE                                       BUG3721
     C                   PARM      *BLANK        ZADATE                                      BUG3721
                                                                                             BUG3721
     C                   MOVE      ZDATE         @@MDATorig        6                         BUG3721
                                                                                             BUG3721
     C                   MOVE      'N'           WPDUE             1                         BUG3721
     C     @@LNRF        SETLL     LOAMS                                                     BUG3721
     C     @@LNRF        READE     LOAMS                                  90                 BUG3721
     C     *IN90         DOWEQ     '0'                                                       BUG3721
     C     AMTPA         IFEQ      'PD'                                                      BUG3721
     C                   MOVE      'Y'           WPDUE                                       BUG3721
     C                   ENDIF                                                               BUG3721
     C     @@LNRF        READE     LOAMS                                  90                 BUG3721
     C                   ENDDO                                                               BUG3721
                                                                                             BUG3721
     C     @@CPAM        IFLE      0                                                         BUG3721
     C     WPDUE         ANDEQ     'N'                                                       BUG3721
     C     @@AITC        ADD       @@AIAP        WINOUT           13 0                       BUG3721
     C                   ADD       @@AIMN        WINOUT           13 0                       BUG3721
                                                                                             BUG3721
     C     @@ADIF        IFNE      'Y'                                                       BUG3721
     C                   SUB       @@IPRD        WINOUT                                      BUG3721
     C                   ENDIF                                                               BUG3721
     C                   SUB       @@ICTD        WINOUT                                      BUG3721
                                                                                             BUG3721
     C     WINOUT        IFGT      0                                                         BUG3721
     C                   MOVE      @@MDATorig    DDMDAT                                      BUG3721
     C                   MOVE      'N'           DDMDATOK                                    BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   MOVEL     'DDMDAT'      FldNamXAr(Idx)                              BUG3721
     C                   MOVEL     'LEL0576'     MsgIDXAr(Idx)                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ELSE                                                                BUG3721
                                                                                             BUG3721
     C                   MOVE      @@MDATorig    DDMDAT                                      BUG3721
     C                   MOVE      'N'           DDMDATOK                                    BUG3721
     C                   ADD       1             Idx                                         BUG3721
     C                   MOVEL     'DDMDAT'      FldNamXAr(Idx)                              BUG3721
     C                   MOVEL     'LEL0576'     MsgIDXAr(Idx)                               BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                              CAS019
     C                   IF        CAS016 = 'Y'                                               CAS019
                                                                                              CAS019
      ** Check for valid values of maturity date when amortising fees exist                   CAS019
      ** New maturity date cannot be before the start date of the amortisation period of the  262581
      ** fees associated with the loan.                                                       262581
                                                                                              CAS019
     C                   IF        DDACTN = 'A' AND                                           CAS019
     C                             WSVMD <> @@MDAT                                            CAS019
     C     @@LNRF        CHAIN     LEFEEDF                            21                      CAS019
     C**********         DOW       *IN21 = *ON                                       CAS019 BUG18363
     C                   DOW       *IN21 = *OFF                                             BUG18363
                                                                                              CAS019
     C**********         IF        FEAMRI = 'N' AND                                    CAS019 262581
     C**********                   FESTPD <= BJRDNB OR                                 CAS019 262581
     C**********                   FEAMRI = 'Y' AND                                    CAS019 262581
     C**********                   FESTPD <= BJRDNB AND                                CAS019 262581
     C**********                   FEENPD > WSVMD                                      CAS019 262581
     C                   IF        FESTPD >= WSVMD                                            262581
     C                   MOVE      @@MDATorig    DDMDAT                                       CAS019
     C                   MOVE      'N'           DDMDATOK                                     CAS019
     C                   ADD       1             Idx                                          CAS019
     C                   MOVEL     'DDMDAT'      FldNamXAr(Idx)                               CAS019
     C**********         MOVEL     'LEV1072'     MsgIDXAr(Idx)                         CAS019 262581
     C                   MOVEL     'LER5601'     MsgIDXAr(Idx)                                262581
     C                   ENDIF                                                                CAS019
                                                                                              CAS019
     C     @@LNRF        READE     LEFEEDF                                21                  CAS019
     C                   ENDDO                                                                CAS019
      **********                                                                       CAS019 262581
      ***Check*for history records                                                     CAS019 262581
      **********                                                                       CAS019 262581
     C*****@@LNRF        CHAIN     LEFHSTF                            21               CAS019 262581
     C**********         DOW       *IN21 = *ON                                       CAS019 BUG18363
     C**********         DOW       *IN21 = *OFF                                      BUG18363 262581
      **********                                                                       CAS019 262581
     C**********         IF        HIAMRI = 'N' AND                                    CAS019 262581
     C**********                   HISTPD <= BJRDNB OR                                 CAS019 262581
     C**********                   HIAMRI = 'Y' AND                                    CAS019 262581
     C**********                   HISTPD <= BJRDNB AND                                CAS019 262581
     C**********                   HIENPD > WSVMD                                      CAS019 262581
     C**********         MOVE      @@MDATorig    DDMDAT                                CAS019 262581
     C**********         MOVE      'N'           DDMDATOK                              CAS019 262581
     C**********         ADD       1             Idx                                   CAS019 262581
     C**********         MOVEL     'DDMDAT'      FldNamXAr(Idx)                        CAS019 262581
     C**********         MOVEL     'LEV1072'     MsgIDXAr(Idx)                         CAS019 262581
     C**********         ENDIF                                                         CAS019 262581
                                                                                              CAS019
     C*****LNRF          READE     LEFHSTF                                21         CAS019 BUG18363
     C*****@@LNRF        READE     LEFHSTF                                21         BUG18363 262581
     C**********         ENDDO                                                         CAS019 262581
                                                                                              CAS019
     C                   ENDIF                                                                CAS019
     C                   ENDIF                                                                CAS019
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFEQV  -  Get facility equivalent of amounts                 *
      *****************************************************************
     C     SRFEQV        BEGSR
      *
     C     WCDPF         SUB       WCDPL         CX                1 0
     C                   ADD       4             CX
      *                                                                                       CLE023
      ** If CLE023 is ON, get cross rate of currencies spot.                                  CLE023
      *                                                                                       CLE023
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C                   CALLB     'ZXRATE'                                                   CLE023
     C                   PARM                    ZRATE1           13 8                        CLE023
     C                   PARM                    ZMDI1             1                          CLE023
     C                   PARM                    ZRATE2           13 8                        CLE023
     C                   PARM                    ZMDI2             1                          CLE023
     C                   PARM                    ZRATEX           13 8                        CLE023
     C                   PARM                    ZMDIX             1                          CLE023
     C                   Z-ADD     ZRATEX        ZEXCH                                        CLE023
     C                   MOVE      ZMDIX         ZMD                                          CLE023
      * If loan is in base currency, use Facility Ccy spot rate.                              242481
     C     ZCCYI         IFEQ      BJCYCD                                                     CLE023
     C                   Z-ADD     ZRATE2        ZEXCH                                        242481
     C     ZMDI2         IFEQ      'D'                                                        242481
     C                   MOVE      'M'           ZMD                                          CLE023
     C                   ELSE                                                                 242481
     C                   MOVE      'D'           ZMD                                          242481
     C                   ENDIF                                                                242481
     C                   ENDIF                                                                CLE023
     C                   ENDIF                                                                CLE023
      *                                                                                       CLE023
      *
      ***  For insert
      *
     C     DDACTN        IFEQ      'I'
     C     WFLAG         IFEQ      'Y'
     C     WFMIN         IFEQ      'D'
     C     WSVFX         DIV(H)    POWER(CX)     WFCXRT           15 8
     C     1             DIV(H)    WFCXRT        WFCXRT
     C                   ELSE
     C     WSVFX         MULT(H)   POWER(CX)     WFCXRT
     C                   ENDIF
     C                   ELSE
     C     WSVFX         MULT(H)   POWER(CX)     WFCXRT
     C                   ENDIF
      *
      ***  For non-insert
      *
     C                   ELSE
      *                                                                                       CLE023
      ** If CLE023 is installed and there is a rollover of facility                           CLE023
      ** exchange rate where rollover date is less than or equal to                           CLE023
      ** rundate.                                                                             CLE023
      *                                                                                       CLE023
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C     @@RLDT        ANDNE     0                                                          CLE023
     C     @@RLDT        ANDLT     BJRDNB                                                     CLE023
     C     NFCE          ANDNE     0                                                          CLE023
     C     NCCY          ANDEQ     *BLANKS                                                    CLE023
     C     NFMD          IFEQ      'D'                                                        CLE023
     C     NFCE          DIV(H)    POWER(CX)     WNFCE            15 9                        CLE023
     C     1             DIV(H)    WNFCE         WNFCE
     C                   ELSE                                                                 CLE023
     C     NFCE          MULT(H)   POWER(CX)     WNFCE                                        CLE023
     C                   ENDIF                                                                CLE023
     C     @@CPAM        MULT(H)   WNFCE         CPAMF                                        CLE023
     C     @@RAMT        MULT(H)   WNFCE         RAMTF                                        CLE023
      * should be current RAMT before update                                                  CLE023
     C*****W#RAMT        MULT(H)   WNFCE         RAMT1                                        CLE023
                                                                                             BUG3721
      ** Include interest and charge during exposure update                                  BUG3721
      ** when add on interest or add on charge is set to 'Y'                                 BUG3721
      ** for flat rate personal loans                                                        BUG3721
                                                                                             BUG3721
     C                   Z-ADD     *ZEROS        FLTIF                                       BUG3721
     C                   Z-ADD     *ZEROS        W#FLIF           13 0                       BUG3721
     C                   Z-ADD     *ZEROS        CHGAF                                       BUG3721
     C                   Z-ADD     *ZEROS        W#CHGF           13 0                       BUG3721
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     @@PTYP        ANDEQ     80                                                        BUG3721
     C     @@VDAT        ANDLE     BJRDNB                                                    BUG3721
     C     @@ORED        ANDEQ     BJRDNB                                                    BUG3721
                                                                                             BUG3721
     C     @@ADIF        IFEQ      'Y'                                                       BUG3721
     C     @@FLTI        MULT(H)   WNFCE         FLTIF            13 0                       BUG3721
     C*****W#FLTI        MULT(H)   WNFCE         W#FLIF           13 0                       BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     @@ADCF        IFEQ      'Y'                                                       BUG3721
     C     @@CHGA        MULT(H)   WNFCE         CHGAF            13 0                       BUG3721
     C*****W#CHGA        MULT(H)   WNFCE         W#CHGF           13 0                       BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDIF                                                               BUG3721
      *                                                                                       CLE023
     C                   ELSE                                                                 CLE023
     C     @@FMDI        IFEQ      'D'
     C     @@FCXR        DIV(H)    POWER(CX)     WFCXRT
     C     1             DIV(H)    WFCXRT        WFCXRT
     C                   ELSE
     C     @@FCXR        MULT(H)   POWER(CX)     WFCXRT
     C                   ENDIF
     C     @@CPAM        MULT(H)   WFCXRT        CPAMF            13 0
     C     @@RAMT        MULT(H)   WFCXRT        RAMTF            13 0
      * should be current RAMT before update                                                  CLE023
     C*****RAMT          MULT(H)   WFCXRT        RAMT1            13 0                        CLE023
                                                                                             BUG3721
      ** Include interest and charge during exposure update                                  BUG3721
      ** when add on interest or add on charge is set to 'Y'                                 BUG3721
      ** for flat rate personal loans                                                        BUG3721
                                                                                             BUG3721
     C                   Z-ADD     *ZEROS        FLTIF                                       BUG3721
     C                   Z-ADD     *ZEROS        W#FLIF                                      BUG3721
     C                   Z-ADD     *ZEROS        CHGAF                                       BUG3721
     C                   Z-ADD     *ZEROS        W#CHGF                                      BUG3721
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     @@PTYP        ANDEQ     80                                                        BUG3721
     C     @@VDAT        ANDLE     BJRDNB                                                    BUG3721
     C     @@ORED        ANDEQ     BJRDNB                                                    BUG3721
                                                                                             BUG3721
     C     @@ADIF        IFEQ      'Y'                                                       BUG3721
     C     @@FLTI        MULT(H)   WFCXRT        FLTIF                                       BUG3721
     C*****W#FLTI        MULT(H)   WFCXRT        W#FLIF                                      BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     @@ADCF        IFEQ      'Y'                                                       BUG3721
     C     @@CHGA        MULT(H)   WFCXRT        CHGAF                                       BUG3721
     C*****W#CHGA        MULT(H)   WFCXRT        W#CHGF                                      BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDIF                                                                CLE023
      *                                                                                       CLE023
      ** If CLE023 is ON convert amounts using spot rate.                                     CLE023
      *                                                                                       CLE023
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C                   Z-ADD     @@CPAM        ZAMTCI                                       CLE023
     C                   CALLB     'ZCONVZ1'                                                  CLE023
     C                   PARM                    ZAMTCI           15 0                        CLE023
     C                   PARM                    ZEXCH            13 8                        CLE023
     C                   PARM                    ZMD               1                          CLE023
     C                   PARM                    ZCCYI             3                          CLE023
     C                   PARM                    ZCCYO             3                          CLE023
     C                   PARM                    ZCDPI             1 0                        CLE023
     C                   PARM                    ZCDPO             1 0                        CLE023
     C                   PARM                    ZAMTCO           15 0                        CLE023
     C                   Z-ADD     ZAMTCO        WXCPAM           13 0                        CLE023
     C*******            Z-ADD     W#RAMT        ZAMTCI                                       CLE023
     C                   Z-ADD     @@RAMT        ZAMTCI                                       CLE023
      *                                                                                       CLE023
     C                   CALLB     'ZCONVZ1'                                                  CLE023
     C                   PARM                    ZAMTCI                                       CLE023
     C                   PARM                    ZEXCH                                        CLE023
     C                   PARM                    ZMD                                          CLE023
     C                   PARM                    ZCCYI                                        CLE023
     C                   PARM                    ZCCYO                                        CLE023
     C                   PARM                    ZCDPI                                        CLE023
     C                   PARM                    ZCDPO                                        CLE023
     C                   PARM                    ZAMTCO                                       CLE023
     C                   Z-ADD     ZAMTCO        WXRAMT           13 0                        CLE023
                                                                                             BUG3721
      ** Include interest and charge during exposure update                                  BUG3721
      ** when add on interest or add on charge is set to 'Y'                                 BUG3721
      ** for flat rate personal loans                                                        BUG3721
                                                                                             BUG3721
     C                   Z-ADD     *ZEROS        FLTIF                                       BUG3721
     C                   Z-ADD     *ZEROS        W#FLIF                                      BUG3721
     C                   Z-ADD     *ZEROS        CHGAF                                       BUG3721
     C                   Z-ADD     *ZEROS        W#FLIF                                      BUG3721
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     @@PTYP        ANDEQ     80                                                        BUG3721
     C     @@VDAT        ANDLE     BJRDNB                                                    BUG3721
     C     @@ORED        ANDEQ     BJRDNB                                                    BUG3721
                                                                                             BUG3721
     C     @@ADIF        IFEQ      'Y'                                                       BUG3721
     C                   Z-ADD     @@FLTI        ZAMTCI                                      BUG3721
     C                   CALLB     'ZCONVZ1'                                                 BUG3721
     C                   PARM                    ZAMTCI           15 0                       BUG3721
     C                   PARM                    ZEXCH            13 8                       BUG3721
     C                   PARM                    ZMD               1                         BUG3721
     C                   PARM                    ZCCYI             3                         BUG3721
     C                   PARM                    ZCCYO             3                         BUG3721
     C                   PARM                    ZCDPI             1 0                       BUG3721
     C                   PARM                    ZCDPO             1 0                       BUG3721
     C                   PARM                    ZAMTCO           15 0                       BUG3721
     C                   Z-ADD     ZAMTCO        FLTIF                                       BUG3721
                                                                                             BUG3721
     C**********         Z-ADD     W#FLTI        ZAMTCI                                      BUG3721
     C**********         EXSR      ZCONVZ1                                                   BUG3721
     C**********         Z-ADD     ZAMTCO        W#FLIF                                      BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     @@ADCF        IFEQ      'Y'                                                       BUG3721
     C                   Z-ADD     @@CHGA        ZAMTCI                                      BUG3721
     C                   CALLB     'ZCONVZ1'                                                 BUG3721
     C                   PARM                    ZAMTCI           15 0                       BUG3721
     C                   PARM                    ZEXCH            13 8                       BUG3721
     C                   PARM                    ZMD               1                         BUG3721
     C                   PARM                    ZCCYI             3                         BUG3721
     C                   PARM                    ZCCYO             3                         BUG3721
     C                   PARM                    ZCDPI             1 0                       BUG3721
     C                   PARM                    ZCDPO             1 0                       BUG3721
     C                   PARM                    ZAMTCO           15 0                       BUG3721
     C                   Z-ADD     ZAMTCO        CHGAF                                       BUG3721
                                                                                             BUG3721
     C**********         Z-ADD     W#CHGA        ZAMTCI                                      BUG3721
     C**********         EXSR      ZCONVZ1                                                   BUG3721
     C**********         Z-ADD     ZAMTCO        W#CHGF                                      BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDIF                                                                CLE023
      *                                                                                       CLE023
     C                   ENDIF
      *
      ***  For non-reversal
      *
     C     DDACTN        IFNE      'R'
      *                                                                                       CLE023
      ** If rollover date is less than or equal to the repayment date                         CLE023
      ** and there is a rollover of facility exchange rate, use the                           CLE023
      ** new facility exchange rate defined.                                                  CLE023
      *                                                                                       CLE023
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C     W#RLDT        ANDNE     0                                                          CLE023
     C     W#RLDT        ANDLT     BJRDNB                                                     CLE023
     C     NFCE          ANDNE     0                                                          CLE023
     C     NCCY          ANDEQ     *BLANKS                                                    CLE023
     C     NFMD          IFEQ      'D'                                                        CLE023
     C     NFCE          DIV(H)    POWER(CX)     WNFCE                                        CLE023
     C     1             DIV(H)    WNFCE         WNFCE
     C                   ELSE                                                                 CLE023
     C     NFCE          MULT(H)   POWER(CX)     WNFCE                                        CLE023
     C                   ENDIF                                                                CLE023
     C     WSVAM         MULT(H)   WNFCE         WOPAMF                                       CLE023
     C     WSVRA         MULT(H)   WNFCE         WRAMTF                                       CLE023
                                                                                             BUG3721
      ** Include interest and charge during exposure update                                  BUG3721
      ** when add on interest or add on charge is set to 'Y'                                 BUG3721
      ** for flat rate personal loans                                                        BUG3721
                                                                                             BUG3721
     C                   Z-ADD     *ZEROS        WFLTIF                                      BUG3721
     C                   Z-ADD     *ZEROS        WCHGAF                                      BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     @@PTYP        ANDEQ     80                                                        BUG3721
                                                                                             BUG3721
     C     DDADIF        IFEQ      'Y'                                                       BUG3721
     C     WTOTI         MULT(H)   WNFCE         WFLTIF           13 0                       BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     DDADCF        IFEQ      'Y'                                                       BUG3721
     C     WCHGA         MULT(H)   WNFCE         WCHGAF           13 0                       BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ADD       WFLTIF        WOPAMF                                      BUG3721
     C                   ADD       WCHGAF        WOPAMF                                      BUG3721
     C                   ENDIF                                                               BUG3721
      *                                                                                       CLE023
     C                   ELSE                                                                 CLE023
     C     WSVAM         MULT(H)   WFCXRT        WOPAMF           13 0
     C     WSVRA         MULT(H)   WFCXRT        WRAMTF           13 0
                                                                                             BUG3721
      ** Include interest and charge during exposure update                                  BUG3721
      ** when add on interest or add on charge is set to 'Y'                                 BUG3721
      ** for flat rate personal loans                                                        BUG3721
                                                                                             BUG3721
     C                   Z-ADD     *ZEROS        WFLTIF                                      BUG3721
     C                   Z-ADD     *ZEROS        WCHGAF                                      BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     @@PTYP        ANDEQ     80                                                        BUG3721
                                                                                             BUG3721
     C     DDADIF        IFEQ      'Y'                                                       BUG3721
     C     WTOTI         MULT(H)   WFCXRT        WFLTIF                                      BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     DDADCF        IFEQ      'Y'                                                       BUG3721
     C     WCHGA         MULT(H)   WFCXRT        WCHGAF                                      BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDIF                                                                CLE023
      *                                                                                       CLE023
      ** If CLE023 is ON convert amounts using spot rate.                                     CLE023
      *                                                                                       CLE023
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C                   Z-ADD     WSVAM         ZAMTCI                                       CLE023
     C                   CALLB     'ZCONVZ1'                                                  CLE023
     C                   PARM                    ZAMTCI                                       CLE023
     C                   PARM                    ZEXCH                                        CLE023
     C                   PARM                    ZMD                                          CLE023
     C                   PARM                    ZCCYI                                        CLE023
     C                   PARM                    ZCCYO                                        CLE023
     C                   PARM                    ZCDPI                                        CLE023
     C                   PARM                    ZCDPO                                        CLE023
     C                   PARM                    ZAMTCO                                       CLE023
     C                   Z-ADD     ZAMTCO        WXSVAM           13 0                        CLE023
      *                                                                                       CLE023
     C                   Z-ADD     WSVRA         ZAMTCI                                       CLE023
     C                   CALLB     'ZCONVZ1'                                                  CLE023
     C                   PARM                    ZAMTCI                                       CLE023
     C                   PARM                    ZEXCH                                        CLE023
     C                   PARM                    ZMD                                          CLE023
     C                   PARM                    ZCCYI                                        CLE023
     C                   PARM                    ZCCYO                                        CLE023
     C                   PARM                    ZCDPI                                        CLE023
     C                   PARM                    ZCDPO                                        CLE023
     C                   PARM                    ZAMTCO                                       CLE023
     C                   Z-ADD     ZAMTCO        WXSVRA           13 0                        CLE023
                                                                                             BUG3721
      ** Include interest and charge during exposure update                                  BUG3721
      ** when add on interest or add on charge is set to 'Y'                                 BUG3721
      ** for flat rate personal loans                                                        BUG3721
                                                                                             BUG3721
     C                   Z-ADD     *ZEROS        WFLTIF                                      BUG3721
     C                   Z-ADD     *ZEROS        WCHGAF                                      BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     @@PTYP        ANDEQ     80                                                        BUG3721
                                                                                             BUG3721
     C     DDADIF        IFEQ      'Y'                                                       BUG3721
     C                   Z-ADD     WTOTI         ZAMTCI                                      BUG3721
     C                   CALLB     'ZCONVZ1'                                                 BUG3721
     C                   PARM                    ZAMTCI                                      BUG3721
     C                   PARM                    ZEXCH                                       BUG3721
     C                   PARM                    ZMD                                         BUG3721
     C                   PARM                    ZCCYI                                       BUG3721
     C                   PARM                    ZCCYO                                       BUG3721
     C                   PARM                    ZCDPI                                       BUG3721
     C                   PARM                    ZCDPO                                       BUG3721
     C                   PARM                    ZAMTCO                                      BUG3721
     C                   Z-ADD     ZAMTCO        WFLTIF                                      BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     DDADCF        IFEQ      'Y'                                                       BUG3721
     C                   Z-ADD     WCHGA         ZAMTCI                                      BUG3721
     C                   CALLB     'ZCONVZ1'                                                 BUG3721
     C                   PARM                    ZAMTCI                                      BUG3721
     C                   PARM                    ZEXCH                                       BUG3721
     C                   PARM                    ZMD                                         BUG3721
     C                   PARM                    ZCCYI                                       BUG3721
     C                   PARM                    ZCCYO                                       BUG3721
     C                   PARM                    ZCDPI                                       BUG3721
     C                   PARM                    ZCDPO                                       BUG3721
     C                   PARM                    ZAMTCO                                      BUG3721
     C                   Z-ADD     ZAMTCO        WCHGAF                                      BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDIF                                                                CLE023
      *                                                                                       CLE023
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFEXP  -  Update exposure and availability array of facility *
      *****************************************************************
     C     SRFEXP        BEGSR
      *
     C     DAYNO         IFNE      *ZEROS
     C     ZFREQ         DOUEQ     *BLANK
      *
     C                   Z-ADD     1             Z                 2 0
     C     DAYNO         LOOKUP    RUNS(Z)                            99  99
     C     *IN99         IFEQ      '1'
     C     DAYNO         ANDGT     ENDAY
     C     *IN99         OREQ      '0'
     C                   LEAVE
     C                   ENDIF
      *
      ***  Do not update if amount is negative
      *
     C                   SUB       FCBAL         WRK13                99  99
     C     WRK13         IFLT      *ZEROS
     C                   ADD       WRK13         FCBAL                99
     C                   Z-ADD     *ZEROS        WRK13
     C                   ENDIF
     C     *IN99         IFEQ      '0'
     C                   LEAVE
     C                   ENDIF
      *
      ***  Update exposure if earlier than or equal to rundate
      ***  Do not update exposure of an internal parts purchased for
      ***  participant facility
      *
     C     WNOUP         IFNE      'Y'                                                        CLE023
     C     CLE025        ANDEQ     'N'                                                        CLE025
     C     DAYNO         IFLE      BJRDNB
     C     WFUPD         IFEQ      'S'
     C                   SUB       FCBAL         CAMD
     C                   ELSE
     C                   ADD       FCBAL         CAMD
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                CLE023
      *
      ***  If CLE009 is installed, set Work Regeneration Indicator to
      ***  changed
      *
     C     CLE009        IFEQ      'Y'
     C                   MOVE      'C'           WKSWRI            1
     C                   ENDIF
      *
      *
      ***  Prevent update of availability if:
      ***  (1) customer is a branch internal customer for parts purchased
      ***  and sold
      *
     C     *IN82         IFEQ      '1'
     C     *IN83         OREQ      '1'
     C**********         MOVE      WSVCN         NUMCUST           6 0                        CSD027
     C                   MOVE      WSVCN         NUMCUST           6                          CSD027
     C     NUMCUST       LOOKUP    WBIC(1)                                99
     C     *IN99         IFEQ      '1'
     C                   MOVE      'N'           WFUAV
     C                   ENDIF
     C                   ENDIF
      *
      ***  Update outstanding amounts
      *
     C     WNOUP         IFNE      'Y'                                                        CLE023
     C     WFUAV         IFEQ      'Y'
     C     DDMDAT        IFEQ      *BLANKS
     C                   Z-ADD     99999         WSVMD             5 0
     C                   ENDIF
     C                   IF        CLE025 = 'N'                                               CLE025
     C     Z             DOWLE     10
     C     RUNS(Z)       ANDLT     DTEXF
     C     WFUPD         IFEQ      'S'
     C     OAM(Z)        SUB       FCBAL         OAM(Z)
     C                   ELSE
     C     OAM(Z)        ADD       FCBAL         OAM(Z)
     C                   ENDIF
     C     Z             ADD       1             Z
     C                   ENDDO
     C                   Z-ADD     FCBAL         WOAM             13 0
     C                   ENDIF                                                                CLE025
     C                   ENDIF
     C                   ENDIF                                                                CLE023
      *                                                                                       CLE023
      ** If CLE023 is on, update Current Exposure based on spot rate.                         CLE023
      *                                                                                       CLE023
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C                   SUB       FXCBAL        WRK14                86  86                  CLE023
     C     WRK14         IFLT      *ZEROS                                                     CLE023
     C                   ADD       WRK14         FXCBAL               86                      CLE023
     C                   Z-ADD     *ZEROS        WRK14                                        CLE023
     C                   ENDIF                                                                CLE023
     C     *IN86         IFEQ      '0'                                                        CLE023
     C                   LEAVE                                                                CLE023
     C                   ENDIF                                                                CLE023
      *                                                                                       CLE023
     C     DAYNO         IFLE      BJRDNB                                                     CLE023
     C     CLE025        ANDEQ     'N'                                                        CLE025
     C     WFUPD         IFEQ      'S'                                                        CLE023
     C                   SUB       FXCBAL        CEXP                                         CLE023
     C                   ELSE                                                                 CLE023
     C                   ADD       FXCBAL        CEXP                                         CLE023
     C                   ENDIF                                                                CLE023
     C                   ENDIF                                                                CLE023
      *                                                                                       CLE023
     C                   ENDIF                                                                CLE023
      *
      ***  Increase DAYNO by frequency code
      *
     C     ZFREQ         IFNE      *BLANK
     C                   Z-ADD     DAYNO         ZDAYNO
     C                   CALLB     'ZFREQB'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    ZFREQ             1
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      DDCURR        ZCCY              3
     C                   PARM      *BLANKS       ZLOC                                       AR702741
     C                   PARM      *ZERO         ZMDAY             2 0
     C                   PARM                    BJDFIN
     C                   PARM      SDGELR        SDGELR
      *
     C                   Z-ADD     ZDAYNO        DAYNO
      *
     C                   ENDIF
      *
     C                   ENDDO
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFEQVCA  -  Get credit agreement equivalent of amounts       *
      *****************************************************************
     C     SRFEQVCA      BEGSR
      *
     C     WCDPF         SUB       WCDPL         CX                1 0
     C                   ADD       4             CX
      *
      ** If CLE023 is ON, get cross rate of currencies spot.
      *
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
     C     ZCCYI         IFEQ      BJCYCD
     C                   MOVE      'M'           ZMD
     C                   ENDIF
     C                   ENDIF
      *
      *
      ***  For insert
      *
     C     DDACTN        IFEQ      'I'
     C     WFLAG         IFEQ      'Y'
     C     WFMIN         IFEQ      'D'
     C     WSVFX         DIV(H)    POWER(CX)     WFCXRT           15 8
     C     1             DIV(H)    WFCXRT        WFCXRT
     C                   ELSE
     C     WSVFX         MULT(H)   POWER(CX)     WFCXRT
     C                   ENDIF
     C                   ELSE
     C     WSVFX         MULT(H)   POWER(CX)     WFCXRT
     C                   ENDIF
      *
      ***  For non-insert
      *
     C                   ELSE
      *
      ** If CLE023 is installed and there is a rollover of facility
      ** exchange rate where rollover date is less than or equal to
      ** rundate.
      *
     C     CLE023        IFEQ      'Y'
     C     @@RLDT        ANDNE     0
     C     @@RLDT        ANDLT     BJRDNB
     C     NFCE          ANDNE     0
     C     NCCY          ANDEQ     *BLANKS
     C     NFMD          IFEQ      'D'
     C     NFCE          DIV(H)    POWER(CX)     WNFCE            15 9
     C     1             DIV(H)    WNFCE         WNFCE
     C                   ELSE
     C     NFCE          MULT(H)   POWER(CX)     WNFCE
     C                   ENDIF
     C     @@CPAM        MULT(H)   WNFCE         CPAMF
     C     @@RAMT        MULT(H)   WNFCE         RAMTF
      *
     C                   ELSE
     C     @@FMDI        IFEQ      'D'
     C     @@FCXR        DIV(H)    POWER(CX)     WFCXRT
     C     1             DIV(H)    WFCXRT        WFCXRT
     C                   ELSE
     C     @@FCXR        MULT(H)   POWER(CX)     WFCXRT
     C                   ENDIF
     C     @@CPAM        MULT(H)   WFCXRT        CPAMF            13 0
     C     @@RAMT        MULT(H)   WFCXRT        RAMTF            13 0
     C                   ENDIF
      *
      ** If CLE023 is ON convert amounts using spot rate.
      *
     C     CLE023        IFEQ      'Y'
     C                   Z-ADD     @@CPAM        ZAMTCI
     C                   CALLB     'ZCONVZ1'
     C                   PARM                    ZAMTCI           15 0
     C                   PARM                    ZEXCH            13 8
     C                   PARM                    ZMD               1
     C                   PARM                    ZCCYI             3
     C                   PARM                    ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
     C                   PARM                    ZAMTCO           15 0
     C                   Z-ADD     ZAMTCO        WXCPAM           13 0
     C                   Z-ADD     @@RAMT        ZAMTCI
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
     C                   Z-ADD     ZAMTCO        WXRAMT           13 0
     C                   ENDIF
      *
     C                   ENDIF
      *
      ***  For non-reversal
      *
     C     DDACTN        IFNE      'R'
      *
      ** If rollover date is less than or equal to the repayment date
      ** and there is a rollover of facility exchange rate, use the
      ** new facility exchange rate defined.
      *
     C     CLE023        IFEQ      'Y'
     C     W#RLDT        ANDNE     0
     C     W#RLDT        ANDLT     BJRDNB
     C     NFCE          ANDNE     0
     C     NCCY          ANDEQ     *BLANKS
     C     NFMD          IFEQ      'D'
     C     NFCE          DIV(H)    POWER(CX)     WNFCE
     C     1             DIV(H)    WNFCE         WNFCE
     C                   ELSE
     C     NFCE          MULT(H)   POWER(CX)     WNFCE
     C                   ENDIF
     C     WSVAM         MULT(H)   WNFCE         WOPAMF
     C     WSVRA         MULT(H)   WNFCE         WRAMTF
      *
     C                   ELSE
     C     WSVAM         MULT(H)   WFCXRT        WOPAMF           13 0
     C     WSVRA         MULT(H)   WFCXRT        WRAMTF           13 0
     C                   ENDIF
      *
      ** If CLE023 is ON convert amounts using spot rate.
      *
     C     CLE023        IFEQ      'Y'
     C                   Z-ADD     WSVAM         ZAMTCI
     C                   CALLB     'ZCONVZ1'
     C                   PARM                    ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
     C                   PARM                    ZAMTCO
     C                   Z-ADD     ZAMTCO        WXSVAM           13 0
      *
     C                   Z-ADD     WSVRA         ZAMTCI
     C                   CALLB     'ZCONVZ1'
     C                   PARM                    ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
     C                   PARM                    ZAMTCO
     C                   Z-ADD     ZAMTCO        WXSVRA           13 0
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SRCKFR  -  Check if the Facility has been reactivated.       *
      *****************************************************************
     C     SRCKFR        BEGSR
      *
     C                   MOVE      *OFF          WREAC             1
      *
     C     RECIF         IFEQ      'C'
     C     RECIF         OREQ      'E'
      *
     C     WKFAM2        SETLL     LEFCAML3
     C     WKFAM2        READE     LEFCAML3                               99
      *
     C     *IN99         DOWEQ     *OFF
     C     WREAC         ANDEQ     *OFF
     C     RECIC         IFEQ      'D'
     C     FATP          ANDEQ     'FR'
     C                   Z-ADD     AAMT          FAMT
     C                   Z-ADD     NDEX          DTEXF
     C                   MOVE      *ON           WREAC
      *                                                                                       241198
      ** If Last Availability Date has not yet been amended,                                  241198
      ** use the new expiry date from the Reactivation instead.                               241198
     C     AVLD          IFLT      BJRDNB                                                     241198
     C                   Z-ADD     NDEX          AVLD                                         241198
     C                   ENDIF                                                                241198
      *                                                                                       241198
     C                   ENDIF
     C     WKFAM2        READE     LEFCAML3                               99
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN99
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFUPD  -  Determine if adding to or subtracting from         *
      *            facility                                           *
      *****************************************************************
     C     SRFUPD        BEGSR
      *
      ***  First case, add to facility exposure and oustanding amount if:
      ***  (1) normal loan
      ***  (2) non-syndicated parts purchased
      ***  (3) syndicated parts purchased for the participant facility
      ***  (4) syndicated psold for the participant facility
      ***  If not any of the above, subtract from exposure and
      ***  outstanding amount
      *
     C                   MOVE      *BLANK        WNOUP             1                          CLE023
     C     WUPDT         IFEQ      '1'
     C                   SELECT
      *
      ***  Parts purchased
      *
     C     *IN82         WHENEQ    '1'
     C     WPRME         IFEQ      'Y'
     C                   MOVE      'S'           WFUPD             1
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C                   MOVE      'Y'           WNOUP                                        CLE023
     C                   ENDIF                                                                CLE023
     C                   ELSE
     C                   MOVE      'A'           WFUPD
     C                   ENDIF
      *
      ***  Parts sold
      *
     C     *IN83         WHENEQ    '1'
     C     WPART         IFEQ      'Y'
     C                   MOVE      'A'           WFUPD
     C                   ELSE
     C                   MOVE      'S'           WFUPD
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C                   MOVE      'Y'           WNOUP                                        CLE023
     C                   ENDIF                                                                CLE023
     C                   ENDIF
      *
      ***  Normal loan
      *
     C                   OTHER
     C                   MOVE      'A'           WFUPD
     C                   ENDSL
      *
      ***  For the second case, processing would be the exact opposite
      ***  of the first case
      *
     C                   ELSE
      *
      ***  Parts purchased
      *
     C                   SELECT
     C     *IN82         WHENEQ    '1'
     C     WPRME         IFEQ      'Y'
     C                   MOVE      'A'           WFUPD
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C                   MOVE      'Y'           WNOUP                                        CLE023
     C                   ENDIF                                                                CLE023
     C                   ELSE
     C                   MOVE      'S'           WFUPD
     C                   ENDIF
      *
      ***  Parts sold
      *
     C     *IN83         WHENEQ    '1'
     C     WPART         IFEQ      'Y'
     C                   MOVE      'S'           WFUPD
     C                   ELSE
     C                   MOVE      'A'           WFUPD
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C                   MOVE      'Y'           WNOUP                                        CLE023
     C                   ENDIF                                                                CLE023
     C                   ENDIF
      *
      ***  Normal loan
      *
     C                   OTHER
     C                   MOVE      'S'           WFUPD
     C                   ENDSL
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
      ** Value Date                                                                         AR804863
      *                                                                                     AR804863
     C                   Z-ADD     CCLVDAT       WSVVD                                      AR804863
      *                                                                                     AR804863
      ** Maturity Date                                                                      AR804863
      *                                                                                     AR804863
     C                   Z-ADD     *ZEROS        WSVMD                                      AR804863
     C                   MOVE      DDMDAT        ZDATE                                      AR804863
     C                   MOVE      BJDFIN        ZDATFM                                     AR804863
     C                   CALL      'ZDATE1'                                                 AR804863
     C                   PARM      *BLANKS       ZERR                                       AR804863
     C                   PARM                    ZDATE                                      AR804863
     C                   PARM                    ZDATFM                                     AR804863
     C                   PARM                    ZDAYNO                                     AR804863
      *                                                                                     AR804863
     C                   MOVEL     DDMDAT        WNUM7                                      AR804863
     C                   MOVEL     WNUM7         WALF6                                      AR804863
     C                   Z-ADD     ZDAYNO        WSVMD                                      AR804863
     C                   Z-ADD     WSVMD         CCLMDAT                                    AR804863
      *                                                                                     AR217961
      ** Customer number / short name                                                       AR217961
      *                                                                                     AR217961
     C                   MOVEL     DDCUST        WSVCN                                      AR217961
      *                                                                                     AR804863
      ** Principal Amount                                                                   AR804863
      *                                                                                     AR804863
     C                   Z-ADD     CCLCPAM       WSVAM                                      AR804863
      *                                                                                     AR804863
      ** Auto settlement indicator                                                          AR804863
      *                                                                                     AR804863
     C                   MOVEL     DDAUTO        CCLAUTO                                    AR804863
      *                                                                                     AR804863
      ** Auto-pay at maturity indicator                                                     AR804863
      *                                                                                     AR804863
     C                   MOVEL     DDAPMI        CCLAPMI                                    AR804863
      *                                                                                     AR804863
      ** Multi-currency                                                                     AR804863
      *                                                                                     AR804863
     C                   MOVEL     DDMCRA        CCLMCRA                                    AR804863
      *                                                                                     AR804863
      ** Recourse Indicator                                                                 AR804863
      *                                                                                     AR804863
     C                   MOVEL     DDRCSI        CCLRCSI                                    AR804863
      *                                                                                     AR804863
      ** Fixing Days                                                                        AR804863
      *                                                                                     AR804863
     C                   MOVEL     DDRFDY        CCLRFDY                                    AR804863
      *                                                                                     AR804863
      ** Populate Loan Details                                                              AR804863
      *                                                                                     AR804863
     C                   MOVE      DDLTYP        @LNTY                                      AR804863
     C                   MOVE      DDSUTP        @LNST                                      AR804863
     C                   MOVE      DDCLAS        @LNCL                                      AR804863
     C                   CALL      'AOLOANR0'                                               AR804863
     C                   PARM      *BLANKS       @RTCD                                      AR804863
     C                   PARM      '*KEY   '     @OPTN                                      AR804863
     C                   PARM                    @LNTY                                      AR804863
     C                   PARM                    @LNST                                      AR804863
     C                   PARM                    @LNCL                                      AR804863
     C     SDLOAN        PARM      SDLOAN        DSFDY                                      AR804863
     C                   Z-ADD     AYLNPT        WLNPT                                      AR804863
      *                                                                                     AR804863
     C                   CALLB     'AOCURRR0'                                               AR804863
     C                   PARM      *BLANK        @RTCD                                      AR804863
     C                   PARM      '*KEY   '     @OPTN                                      AR804863
     C                   PARM      DDCURR        @CYCD                                      AR804863
     C     SDCURR        PARM      SDCURR        DSSDY                                      AR804863
     C                   Z-ADD     A6NBDP        WCDPL                                      AR804863
      *                                                                                     AR804863
     C                   ENDSR                                                              AR804863
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
                                                                                             BUG5863
      ** Reset Index of Warning errors.                                                      BUG5863
                                                                                             BUG5863
     C                   EVAL      WId = *ZERO                                               BUG5863
      *
      ***  Reset warning flags
      *
     C     SaveDDLNRF    IFNE      DDLNRF
     C**********         MOVE      *BLANK        WE003             1                         BUG4351
     C**********         MOVE      *BLANK        WE009             1                         BUG4351
     C**********         MOVE      *BLANK        WE020             1                         BUG4351
     C**********         MOVE      *BLANK        WE021             1                         BUG4351
     C**********         MOVE      *BLANK        WE232             1                         BUG4351
     C**********         MOVE      *BLANK        WE510             1                         BUG4351
     C                   MOVE      *BLANK        WE512             1
     C**********         MOVE      *BLANK        W1DCURR           3                         BUG4351
     C**********         MOVE      *BLANK        W1DCURRCR         3                  CLE030 BUG4351
     C**********         Z-ADD     *ZERO         W1SVDD            5 0                       BUG4351
     C**********         Z-ADD     *ZERO         W1SVVD            5 0                       BUG4351
     C**********         MOVE      *BLANK        W1CNUM            6                         BUG4351
     C**********         MOVE      *BLANK        W1FACT            3                         BUG4351
     C**********         MOVE      *BLANK        W1FCNO            2                         BUG4351
     C**********         Z-ADD     *ZERO         W1AM             13 0                       BUG4351
     C**********         Z-ADD     *ZERO         W1RLDT            5 0                       BUG4351
     C**********         Z-ADD     *ZERO         W1RD              5 0                       BUG4351
     C**********         MOVE      *BLANK        W1LNKS            1                         BUG4351
     C**********         Z-ADD     *ZERO         W1MD              5 0                       BUG4351
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
     C*****I****         SUB       1             WId                                         BUG4351
     C     I             SUB       1             WIdx                                        BUG4351
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  #TERM - Termination processing.                              *
      *****************************************************************
     C     #TERM         BEGSR
      *
      ***  Terminate program
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
      *****************************************************************                       240510
      * SRRELI  -  GET SECI FROM FCLTYFM                              *                       240510
      * Called by: SRFCUS - Validate Facility                         *                       240510
      * Calls    : None                                               *                       240510
      *****************************************************************                       240510
     C     SRRELI        BEGSR                                                                240510
      *                                                                                       240510
     C     DDACTN        IFEQ      'I'                                                        240510
      *                                                                                       240510
     C*****              MOVE      DDFCUS        VARCUS            6 0                 240510 CPK026
     C                   MOVE      DDFCUS        VARCUS            6                          CPK026
     C                   MOVE      DDFTYP        VARTYP            3 0                        240510
     C                   MOVE      DDFSEQ        VARSEQ            2 0                        240510
      *                                                                                       240510
     C     K#SECI        KLIST                                                                240510
     C                   KFLD                    VARCUS                                       240510
     C                   KFLD                    VARTYP                                       240510
     C                   KFLD                    VARSEQ                                       240510
      *                                                                                       240510
     C     K#SECI        CHAIN     LEFCLTDC                           89                      240510
     C     *IN89         IFEQ      *OFF                                                       240510
     C                   MOVE      SECI          DDSECI                                       240510
     C                   ENDIF                                                                240510
      *                                                                                       240510
     C                   ENDIF                                                                240510
      *                                                                                       240510
     C                   ENDSR                                                                240510
      /EJECT                                                                                  240510
      *****************************************************************            AR820729 MD055380
      ***SRRSTS*-*Validate*Rollover*Status                            *            AR820729 MD055380
      *****************************************************************            AR820729 MD055380
     C*****SRRSTS        BEGSR                                                     AR820729 MD055380
      **********                                                                   AR820729 MD055380
      ***Do*not*allow*amendment*when*there*is*a*pending*change*on                  AR820729 MD055380
      ***rollover*details                                                          AR820729 MD055380
      **********                                                                   AR820729 MD055380
     C*****DDACTN        IFEQ      'A'                                             AR820729 MD055380
     C*****CLRSTS        ANDEQ     'R'                                             AR820729 MD055380
     C*****DDACTN        OREQ      'R'                                             AR820729 MD055380
     C*****CLRSTS        ANDEQ     'R'                                             AR820729 MD055380
     C**********         ADD       1             Idx                               AR820729 MD055380
     C**********         MOVEL     '5046109'     MsgIDXAr(Idx)                     AR820729 MD055380
     C**********         MOVEL     'DDLNRF'      FldNamXAr(Idx)                    AR820729 MD055380
     C**********         ENDIF                                                     AR820729 MD055380
     C**********         ENDSR                                                     AR820729 MD055380
      */EJECT***                                                                   AR820729 MD055380
      *****************************************************************                       CER020
      *                                                               *                       CER020
      *  SRVInStDt - Validate Initial Start Date                      *                       CER020
      *                                                               *                       CER020
      *  Called by: MAIN Processing                                   *                       CER020
      *                                                               *                       CER020
      *  Calls: None                                                  *                       CER020
      *                                                               *                       CER020
      *****************************************************************                       CER020
     C     SRVInStDt     BEGSR                                                                CER020
      *                                                                                       CER020
      ** Default Initial Start Date is BLANKS                                                 CER020
      *                                                                                       CER020
     C                   IF        DDISDT = *BLANKS                                           CER020
     C                   EVAL      DDISDT = DDVDAT                                            CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
      ** If the value input is not a valid date                                               CER020
      *                                                                                       CER020
     C                   MOVEL     DDISDT        PZDate                                       CER020
     C                   EVAL      PZDtFmt = BJDFIN                                           CER020
     C                   EXSR      SRZDate1                                                   CER020
      *                                                                                       CER020
      ** Invalid Date Entered                                                                 CER020
      *                                                                                       CER020
     C                   IF        PZErrCd <> *BLANKS                                         CER020
      *                                                                                       CER020
     C                   EVAL      DDISDTOK = 'N'                                             CER020
     C                   EVAL      Idx = Idx + 1                                              CER020
     C                   EVAL      FldNamXAr(Idx) = 'DDISDT'                                  CER020
     C                   EVAL      MsgIDXAr(Idx) = 'LEL0850'                                  CER020
      *                                                                                       CER020
     C                   ELSE                                                                 CER020
     C                   EVAL      WInsDt = PZDayNo                                           CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
      ** If the date input is greater than value date entered                                 CER020
      *                                                                                       CER020
     C                   IF        WInsDt > WSVVD                                             CER020
      *                                                                                       CER020
     C                   EVAL      DDISDTOK = 'N'                                             CER020
     C                   EVAL      Idx = Idx + 1                                              CER020
     C                   EVAL      FldNamXAr(Idx) = 'DDISDT'                                  CER020
     C                   EVAL      MsgIDXAr(Idx) = 'LEL0851'                                  CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
      ** Initial Start date ought not to be a holiday                                         CER020
      *                                                                                       CER020
     C                   CALLB     'ZCHKH'                                                    CER020
     C                   PARM      WInsDt        PZDayNo                                      CER020
     C                   PARM      DDCURR        PCcy                                         CER020
     C                   PARM      *BLANKS       PZLoc                                        CER020
     C                   PARM      *BLANKS       PZInd                                        CER020
      *                                                                                       CER020
     C                   IF        PZInd = 'H'                                                CER020
      *                                                                                       CER020
     C                   EVAL      DDISDTOK = 'W'                                             CER020
     C**********         EVAL      WIdx = WIdx + 1                                   CER020 MD052214
     C**********         EVAL      WFldNmXAr(WIdx) = 'DDISDT'                        CER020 MD052214
     C**********         EVAL      WMsgIDXAr(WIdx) = 'LEL0852'                       CER020 MD052214
     C                   EVAL      WId = WId + 1                                            MD052214
     C                   EVAL      WFldNmXAr(WId) = 'DDISDT'                                MD052214
     C                   EVAL      WMsgIDXAr(WId) = 'LEL0852'                               MD052214
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
      ** If no errors                                                                         CER020
      *                                                                                       CER020
     C                   IF        DDISDTOK <> 'N'                                            CER020
     C                   EVAL      CCLISDT = WInsDt                                           CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   ENDSR                                                                CER020
      *****************************************************************                       CER020
      /EJECT                                                                                  CER020
      *****************************************************************                       CER020
      *                                                               *                       CER020
      *  SRVFnMtDt - Validate Final Maturity Date                     *                       CER020
      *                                                               *                       CER020
      *  Called by: MAIN Processing                                   *                       CER020
      *                                                               *                       CER020
      *  Calls: None                                                  *                       CER020
      *                                                               *                       CER020
      *****************************************************************                       CER020
     C     SRVFnMtDt     BEGSR                                                                CER020
      *                                                                                       CER020
      ** Default the Final Maturity Date with the Maturity Date,                              CER020
      ** if BLANKS                                                                            CER020
      *                                                                                       CER020
     C                   IF        DDMDAT <> *BLANKS AND                                      CER020
     C                             DDFMDT = *BLANKS                                           CER020
     C                   EVAL      DDFMDT = DDMDAT                                            CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
      ** If call deals, Then if Maturity date is blank then Final                             CER020
      ** Maturity Date must also be blank                                                     CER020
      *                                                                                       CER020
     C                   IF        WLNPT = 61 OR                                              CER020
     C                             WLNPT = 68 OR                                              CER020
     C                             WLNPT = 69                                                 CER020
      *                                                                                       CER020
     C                   IF        DDMDAT = *BLANKS AND                                       CER020
     C                             DDFMDT <> *BLANKS                                          CER020
      *                                                                                       CER020
     C                   EVAL      DDFMDTOK = 'N'                                             CER020
     C                   EVAL      Idx = Idx + 1                                              CER020
     C                   EVAL      FldNamXAr(Idx) = 'DDFMDT'                                  CER020
     C                   EVAL      MsgIDXAr(Idx) = 'LEL0853'                                  CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   ELSE                                                                 CER020
      *                                                                                       CER020
      ** If term deal, Final Maturity Date should not be blanks                               CER020
      *                                                                                       CER020
     C                   IF        DDFMDT = *BLANKS                                           CER020
      *                                                                                       CER020
     C                   EVAL      DDFMDTOK = 'N'                                             CER020
     C                   EVAL      Idx = Idx + 1                                              CER020
     C                   EVAL      FldNamXAr(Idx) = 'DDFMDT'                                  CER020
     C                   EVAL      MsgIDXAr(Idx) = 'LEL0854'                                  CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
      ** If Final maturity date not blank. Check whether Final Maturity                       CER020
      ** Date is a valid date                                                                 CER020
      *                                                                                       CER020
     C                   IF        DDFMDT <> *BLANKS                                          CER020
      *                                                                                       CER020
     C                   MOVEL     DDFMDT        PZDate                                       CER020
     C                   EVAL      PZDtFmt = BJDFIN                                           CER020
     C                   EXSR      SRZDate1                                                   CER020
      *                                                                                       CER020
     C                   IF        PZErrCd <> *BLANKS                                         CER020
      *                                                                                       CER020
     C                   EVAL      DDFMDTOK = 'N'                                             CER020
     C                   EVAL      Idx = Idx + 1                                              CER020
     C                   EVAL      FldNamXAr(Idx) = 'DDFMDT'                                  CER020
     C                   EVAL      MsgIDXAr(Idx) = 'LEL0855'                                  CER020
      *                                                                                       CER020
     C                   ELSE                                                                 CER020
     C                   EVAL      WFmtDt = PZDayNo                                           CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
      ** Else if Final Maturity Date is blank                                                 CER020
      *                                                                                       CER020
     C                   ELSE                                                                 CER020
     C                   EVAL      WFmtDt = *ZEROS                                            CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
      ** Final Maturity Date must not be lower than Maturity Date                             CER020
      *                                                                                       CER020
     C                   IF        DDFMDT <> *BLANKS AND                                      CER020
     C                             DDMDAT <> *BLANKS                                          CER020
      *                                                                                       CER020
     C                   IF        WFmtDt < WSVMD                                             CER020
      *                                                                                       CER020
     C                   EVAL      DDFMDTOK = 'N'                                             CER020
     C                   EVAL      Idx = Idx + 1                                              CER020
     C                   EVAL      FldNamXAr(Idx) = 'DDFMDT'                                  CER020
     C                   EVAL      MsgIDXAr(Idx) = 'LEL0856'                                  CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
      ** Final maturity date ought not to be a holiday                                        CER020
      *                                                                                       CER020
     C                   IF        DDFMDT <> *BLANKS                                          CER020
      *                                                                                       CER020
     C                   CALLB     'ZCHKH'                                                    CER020
     C                   PARM      WFmtDt        PZDayNo                                      CER020
     C                   PARM      DDCURR        PCcy                                         CER020
     C                   PARM      *BLANKS       PZLoc                                        CER020
     C                   PARM      *BLANKS       PZInd                                        CER020
      *                                                                                       CER020
     C                   IF        PZInd = 'H'                                                CER020
      *                                                                                       CER020
     C                   EVAL      DDFMDTOK = 'W'                                             CER020
     C**********         EVAL      WIdx = WIdx + 1                                   CER020 MD052214
     C**********         EVAL      WFldNmXAr(WIdx) = 'DDFMDT'                        CER020 MD052214
     C**********         EVAL      WMsgIDXAr(WIdx) = 'LEL0857'                       CER020 MD052214
     C                   EVAL      WId = WId + 1                                            MD052214
     C                   EVAL      WFldNmXAr(WId) = 'DDFMDT'                                MD052214
     C                   EVAL      WMsgIDXAr(WId) = 'LEL0857'                               MD052214
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
      ** If no errors                                                                         CER020
      *                                                                                       CER020
     C                   IF        DDFMDTOK <> 'N'                                            CER020
     C                   EVAL      CCLFMDT = WFmtDt                                           CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   ENDSR                                                                CER020
      *****************************************************************                       CER020
      /EJECT                                                                                  CER020
      *****************************************************************                       CER020
      *                                                               *                       CER020
      *  SRZDate1 - Routine to Convert Date to Day Number             *                       CER020
      *                                                               *                       CER020
      *  Called by: MAIN Processing                                   *                       CER020
      *                                                               *                       CER020
      *  Calls: None                                                  *                       CER020
      *                                                               *                       CER020
      *****************************************************************                       CER020
     C     SRZDate1      BEGSR                                                                CER020
      *                                                                                       CER020
     C                   CALL      'ZDATE1'                                                   CER020
     C                   PARM      *BLANKS       PZErrCd                                      CER020
     C                   PARM                    PZDate                                       CER020
     C                   PARM                    PZDtFmt                                      CER020
     C                   PARM                    PZDayNo                                      CER020
      *                                                                                       CER020
     C                   ENDSR                                                                CER020
      *****************************************************************                       CER020
      /EJECT                                                                                  CER020
      *****************************************************************
      *  SRBSRT - Validate PDCL Principal / Interest Base Rate Code   *                       CLE134
      *****************************************************************                       CLE134
     C     SRBSRT        BEGSR                                                                CLE134
                                                                                              CLE134
     C                   MOVE      AYLNTY        DDLTYP                                     MD019830
     C                   MOVE      AYLNST        DDSUTP                                     MD019830
     C                   MOVE      AYLNCL        DDCLAS                                     MD019830
                                                                                            MD019830
     C**********         CALL      'AOLOANR0'                                     MD019830 MD019830A
     C                   CALL      'AOLOANR1'                                              MD019830A
     C                   PARM      *BLANKS       @RTCD                                      MD019830
     C                   PARM      '*KEY   '     @OPTN                                      MD019830
     C                   PARM                    DDLTYP                                     MD019830
     C                   PARM                    DDSUTP                                     MD019830
     C                   PARM                    DDCLAS                                     MD019830
     C     SDLOAN        PARM      SDLOAN        DSSDY                                      MD019830
                                                                                            MD019830
     C                   IF        @RTCD = *BLANKS                                          MD019830
     C                   EVAL      AYPCS1 = AYPCSP                                          MD019830
     C                   EVAL      AIPCS1 = AIPCSP                                          MD019830
     C                   ENDIF                                                              MD019830
                                                                                            MD019830
     C                   IF        AYPBRT = 0                                                 CLE134
     C                   EVAL      @KEY1 = CCLCCY                                             CLE134
     C                   MOVE      AYPBSR        @KEY2                                        CLE134
                                                                                              CLE134
     C                   CALLB     'AOBSRTR0'                                                 CLE134
     C                   PARM      *BLANKS       @RTCD                                        CLE134
     C                   PARM      '*KEY   '     @OPTN                                        CLE134
     C                   PARM                    @KEY1                                        CLE134
     C                   PARM                    @KEY2                                        CLE134
     C     SDBSRT        PARM      SDBSRT        DSSDY                                        CLE134
                                                                                              CLE134
     C                   IF        @RTCD <> *BLANKS                                           CLE134
     C                             AND AYPBSR <> *ZEROS                                       CLE134
     C                             OR  AYPBSR = *ZEROS                                        CLE134
     C                             AND AYPRSP = *ZEROS                                        CLE134
     C                             AND AYPCS1 = *ZEROS                                      MD019830
     C                   MOVE      'N'           PBRFLG            1                        MD019830
      * Check for Principal Base Rates                                                      MD019830
     C                   EXSR      SRPBRT                                                   MD019830
     C                   IF        PBRFLG = 'Y'                                             MD019830
     C                   GOTO      SRBSEND                                                  MD019830
     C                   ENDIF                                                              MD019830
     C                   EVAL      DDLTYPOK = 'N'                                             CLE134
     C                   EVAL      DDSUTPOK = 'N'                                             CLE134
     C                   EVAL      DDCLASOK = 'N'                                             CLE134
     C                   ADD       1             Idx                                          CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDLTYP'                                  CLE134
     C**********         EVAL      MsgIdXAr(Idx) = 'LER5571'                        CLE134 AR1094759
     C                   EVAL      MsgIdXAr(Idx) = '5045663'                               AR1094759
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Check interest PDCL for a loan                                                       CLE134
                                                                                              CLE134
     C                   IF        AYSIIN = 'Y'                                               CLE134
     C                             OR B2SPLI = 'Y'                                          MD019830
     C                   IF        AYIBRT = 0                                                 CLE134
     C                   EVAL      @KEY1 = CCLCCY                                             CLE134
     C                   MOVE      AYIBSR        @KEY2                                        CLE134
                                                                                              CLE134
     C                   CALLB     'AOBSRTR0'                                                 CLE134
     C                   PARM      *BLANKS       @RTCD                                        CLE134
     C                   PARM      '*KEY   '     @OPTN                                        CLE134
     C                   PARM                    @KEY1                                        CLE134
     C                   PARM                    @KEY2                                        CLE134
     C     SDBSRT        PARM      SDBSRT        DSSDY                                        CLE134
                                                                                              CLE134
     C                   IF        @RTCD <> *BLANKS                                           CLE134
     C                             AND AYIBSR <> *ZEROS                                       CLE134
     C                             OR  AYIBSR = *ZEROS                                        CLE134
     C                             AND AYIRSP = *ZEROS                                        CLE134
     C                             AND AIPCS1 = *ZEROS                                      MD019830
     C                   MOVE      'N'           IBRFLG            1                        MD019830
      * Check for Interest Base Rates                                                       MD019830
     C                   EXSR      SRIBRT                                                   MD019830
     C                   IF        IBRFLG = 'Y'                                             MD019830
     C                   GOTO      SRBSEND                                                  MD019830
     C                   ENDIF                                                              MD019830
     C                   EVAL      DDLTYPOK = 'N'                                             CLE134
     C                   EVAL      DDSUTPOK = 'N'                                             CLE134
     C                   EVAL      DDCLASOK = 'N'                                             CLE134
     C                   ADD       1             Idx                                          CLE134
     C                   EVAL      FldNamXAr(Idx) = 'DDLTYP'                                  CLE134
     C**********         EVAL      MsgIdXAr(Idx) = 'LER5572'                        CLE134 AR1094759
     C                   EVAL      MsgIdXAr(Idx) = '5045664'                               AR1094759
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C**********         ENDSR                                                       CLE134 MD019830
     C     SRBSEND       ENDSR                                                              MD019830
      *****************************************************************                       CLE134
     C/EJECT                                                                                  CLE134
      *****************************************************************                     MD019830
      *  SRPBRT - Validate PDCL Principal Base Rate Code              *                     MD019830
      *****************************************************************                     MD019830
     C     SRPBRT        BEGSR                                                              MD019830
                                                                                            MD019830
     C     DDLNRF        CHAIN     LEPRATD0                           35                    MD019830
                                                                                            MD019830
     C                   IF        *IN35 = '1'                                              MD019830
     C                   EVAL      Idx = Idx + 1                                            MD019830
     C                   EVAL      DDLNRFOK = 'N'                                           MD019830
     C                   EVAL      FldNamXAr(Idx) = 'DDLNRF'                                MD019830
     C**********         EVAL      MsgIDXAr(Idx) = 'LEE0002'                       MD019830 MD020274
     C                   EVAL      MsgIDXAr(Idx) = '5045925'                                MD020274
     C                   ENDIF                                                              MD019830
                                                                                            MD019830
     C                   IF        B2PBSR = *ZEROS                                          MD019830
     C                             AND B2PRSP = *ZEROS                                      MD019830
     C                             AND B2PCSP = *ZEROS                                      MD019830
     C                   MOVE      'N'           PBRFLG                                     MD019830
     C                   ELSE                                                               MD019830
     C                   MOVE      'Y'           PBRFLG                                     MD019830
     C                   ENDIF                                                              MD019830
                                                                                            MD019830
     C                   IF        B2PBSR <> *ZEROS                                         MD019830
     C                   MOVE      CCLCCY        @KEY1                                      MD019830
     C                   MOVE      B2PBSR        @KEY2                                      MD019830
                                                                                            MD019830
     C                   CALLB     'AOBSRTR0'                                               MD019830
     C                   PARM      *BLANKS       @RTCD                                      MD019830
     C                   PARM      '*KEY   '     @OPTN                                      MD019830
     C                   PARM                    @KEY1                                      MD019830
     C                   PARM                    @KEY2                                      MD019830
     C     SDBSRT        PARM      SDBSRT        DSSDY                                      MD019830
                                                                                            MD019830
     C                   IF        @RTCD <> *BLANKS                                         MD019830
     C                   EVAL      Idx = Idx + 1                                            MD019830
     C                   EVAL      DDLTYPOK = 'N'                                           MD019830
     C                   EVAL      FldNamXAr(Idx) = 'DDLTYP'                                MD019830
     C                   EVAL      MsgIDXAr(Idx) = '5045663'                                MD019830
     C                   ENDIF                                                              MD019830
     C                   ENDIF                                                              MD019830
                                                                                            MD019830
     C                   ENDSR                                                              MD019830
      *****************************************************************                     MD019830
     C/EJECT                                                                                MD019830
      *****************************************************************                     MD019830
      *  SRIBRT - Validate PDCL Interest Base Rate Code               *                     MD019830
      *****************************************************************                     MD019830
     C     SRIBRT        BEGSR                                                              MD019830
                                                                                            MD019830
     C     DDLNRF        CHAIN     LEPRATD0                           36                    MD019830
                                                                                            MD019830
     C                   IF        *IN36 = '1'                                              MD019830
     C                   EVAL      Idx = Idx + 1                                            MD019830
     C                   EVAL      DDLNRFOK = 'N'                                           MD019830
     C                   EVAL      FldNamXAr(Idx) = 'DDLNRF'                                MD019830
     C**********         EVAL      MsgIDXAr(Idx) = 'LEE0002'                       MD019830 MD020274
     C                   EVAL      MsgIDXAr(Idx) = '5045925'                                MD020274
     C                   ENDIF                                                              MD019830
                                                                                            MD019830
     C                   IF        B2IBSR = *ZEROS                                          MD019830
     C                             AND B2IRSP = *ZEROS                                      MD019830
     C                             AND B2ICSP = *ZEROS                                      MD019830
     C                   MOVE      'N'           IBRFLG                                     MD019830
     C                   ELSE                                                               MD019830
     C                   MOVE      'Y'           IBRFLG                                     MD019830
     C                   ENDIF                                                              MD019830
                                                                                            MD019830
     C                   IF        B2IBSR <> *ZEROS                                         MD019830
     C                   MOVE      CCLCCY        @KEY1                                      MD019830
     C                   MOVE      B2IBSR        @KEY2                                      MD019830
                                                                                            MD019830
     C                   CALLB     'AOBSRTR0'                                               MD019830
     C                   PARM      *BLANKS       @RTCD                                      MD019830
     C                   PARM      '*KEY   '     @OPTN                                      MD019830
     C                   PARM                    @KEY1                                      MD019830
     C                   PARM                    @KEY2                                      MD019830
     C     SDBSRT        PARM      SDBSRT        DSSDY                                      MD019830
                                                                                            MD019830
     C                   IF        @RTCD <> *BLANKS                                         MD019830
     C                   EVAL      Idx = Idx + 1                                            MD019830
     C                   EVAL      DDLTYPOK = 'N'                                           MD019830
     C                   EVAL      FldNamXAr(Idx) = 'DDLTYP'                                MD019830
     C                   EVAL      MsgIDXAr(Idx) = '5045664'                                MD019830
     C                   ENDIF                                                              MD019830
     C                   ENDIF                                                              MD019830
                                                                                            MD019830
     C                   ENDSR                                                              MD019830
      *****************************************************************                     MD019830
     C/EJECT                                                                                MD019830
      *****************************************************************                       CLE134
      *                                                               *                       CLE141
      * SRBDYCL - Validate Currency and Location Business Day Conv    *                       CLE141
      *                                                               *                       CLE141
      *****************************************************************                       CLE141
     C     SRBDYCL       BEGSR                                                                CLE141
                                                                                              CLE141
      ** Validate Currency and Location Bus Day Conv for Rollover Date                        CLE141
                                                                                              CLE141
     C                   EVAL      OKFlgBDYCL = 'Y'                                           CLE141
     C                   CALLB     'LEVBDYCL'                                                 CLE141
     C                   PARM      *BLANKS       RetCodeIn                                    CLE141
     C                   PARM      CCLCCY        LCUR                                         CLE141
     C                   PARM                    TrCurPR                                      CLE141
     C                   PARM                    TrLocPR                                      CLE141
     C                   PARM      'RARF'        LoanITYPE                                    CLE141
     C                   PARM                    OKFlgCurPR                                   CLE141
     C                   PARM                    OKFlgLocPR                                   CLE141
     C                   PARM      *BLANKS       MsgIDErr                                     CLE141
     C                   PARM      *BLANKS       FldNamErr                                    CLE141
                                                                                              CLE141
      ** Update error info with that returned from validation module                          CLE141
                                                                                              CLE141
     C                   EVAL      Ix = 1                                                     CLE141
     C                   DOW       FldNamErr(Ix) <> *BLANKS and                               CLE141
     C                             Idx < XArrayMax                                            CLE141
     C                   EVAL      Idx = Idx + 1                                              CLE141
     C                   EVAL      OKFlgBDYCL = 'N'                                           CLE141
     C                   EVAL      FldNamXAr(Idx) = FldNamErr(Ix)                             CLE141
     C                   EVAL      MsgIDXAr(Idx) = MsgIDErr(Ix)                               CLE141
     C                   EVAL      Ix = Ix + 1                                                CLE141
     C                   ENDDO                                                                CLE141
                                                                                              CLE141
      ** Validate Currency and Location Bus Day Conv for Fees, Interest                       CLE141
      ** and Principal Settlement                                                             CLE141
                                                                                              CLE141
     C                   CALLB     'LEVBDYCL'                                                 CLE141
     C                   PARM      *BLANKS       RetCodeIn                                    CLE141
     C                   PARM      CCLCCY        LCUR                                         CLE141
     C                   PARM                    TrCurPI                                      CLE141
     C                   PARM                    TrLocPI                                      CLE141
     C                   PARM      'IPRI'        LoanITYPE                                    CLE141
     C                   PARM                    OKFlgCurPI                                   CLE141
     C                   PARM                    OKFlgLocPI                                   CLE141
     C                   PARM      *BLANKS       MsgIDErr                                     CLE141
     C                   PARM      *BLANKS       FldNamErr                                    CLE141
                                                                                              CLE141
      ** Update error info with that returned from validation module                          CLE141
                                                                                              CLE141
     C                   EVAL      Ix = 1                                                     CLE141
     C                   DOW       FldNamErr(Ix) <> *BLANKS and                               CLE141
     C                             Idx < XArrayMax                                            CLE141
     C                   EVAL      Idx = Idx + 1                                              CLE141
     C                   EVAL      OKFlgBDYCL = 'N'                                           CLE141
     C                   EVAL      FldNamXAr(Idx) = FldNamErr(Ix)                             CLE141
     C                   EVAL      MsgIDXAr(Idx) = MsgIDErr(Ix)                               CLE141
     C                   EVAL      Ix = Ix + 1                                                CLE141
     C                   ENDDO                                                                CLE141
                                                                                              CLE141
      ** If no error, update Valid File with Business Day Conv details                        CLE141
                                                                                              CLE141
     C                   IF        OKFlgBDYCL <> 'N'                                          CLE141
     C                   EVAL      ValidCurPR = TrCurPR                                       CLE141
     C                   EVAL      ValidLocPR = TrLocPR                                       CLE141
     C                   EVAL      ValidCurPI = TrCurPI                                       CLE141
     C                   EVAL      ValidLocPI = TrLocPI                                       CLE141
     C                   ENDIF                                                                CLE141
                                                                                              CLE141
     C                   ENDSR                                                                CLE141
      *****************************************************************                       CLE141
      /EJECT                                                                                  CLE141
      *****************************************************************                       CLE141
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
     C                   PARM                    TranInScr1
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
      ** Loan details screen 2                                                               BUG3721
     C                   PARM                    TranInScr2                                  BUG3721
                                                                                              CLE106
      ** Loan details screen 3                                                                CLE106
     C                   PARM                    TranInScr3                                   CLE106
      ** Loan details screen 6                                                                CLE134
     C                   PARM                    TranInScr6                                   CLE134
                                                                                              CLE141
      ** Business Day Convention Screen Detail                                                CLE141
     C                   PARM                    TranInScr7                                   CLE141
      *
      ***  Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
     C                   PARM                    OKFlagsDS2                                   CLE141
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
     C************       PARM                    WId                                         BUG4351
     C                   PARM                    WIdx                                        BUG4351
      *
      ***  Valid Loan CL layout (DS) from/to caller
     C                   PARM                    ValidLnCl
      *
      ***  Valid Loan CK layout (DS) from/to caller
     C                   PARM                    ValidLnCk
      *
      ***  Next available loan number
     C                   PARM                    PRANG
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
      ***  (Current) loan in file format CL
     C                   PARM                    CliLFilFmt
                                                                                              245227
      ***  Autosettle changed ?                                                               245227
                                                                                              245227
     C                   PARM                    WAUTOA            1                          245227
     C                   PARM                    WAUTOY            1                          245227
      *                                                                                       247441
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                                  247441
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                              247441
     C                   PARM                    ModeofOp          6                          247441
     C                   PARM                    W#PDCL            1                          CLE134
      ** Front Office ID                                                                    MD032052
     C                   PARM                    APFOTranID       20                        MD032052
     C**********         PARM                    PDCLBlock         1              MD022807 MD022807C
      *
      **********                                                                             BUG7029
      *****Get*ZMUSER*to*access*default*branch.                                              BUG7029
      **********                                                                             BUG7029
     C******DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C**********         IN        ZMUSER                                                    BUG7029
     C**********         UNLOCK    ZMUSER                                                    BUG7029
      *
      ***  Get RUNDAT to access multi-branching indicator
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   UNLOCK    RUNDAT
      *
      ***  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'LECLIP1VL'   DBPGM
     C                   OUT       LDA
      *
      ***  Define working fields
      *
     C     *LIKE         DEFINE    RLDT          W#RLDT
     C     *LIKE         DEFINE    NIDT          W#NIDT
     C     *LIKE         DEFINE    NRPD          W@NRPD
      *
     C                   MOVEL     @USER         @@USER           10
      *
      ***  Access Bank details via access program
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   Z-ADD     8             DBASE                          * DBERR 008 *
     C                   MOVEL     '*FIRST'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
E004 C                   ENDIF
      *
      ***  Retrieve midas module details
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   Z-ADD     9             DBASE                          * DBERR 009 *
     C                   MOVEL     '*FIRST'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
E004 C                   ENDIF
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
     C                   Z-ADD     10            DBASE                          * DBERR 010 *
     C                   MOVEL     '*FIRST'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
E004 C                   ENDIF
      *
      ***  Set up an array of branch internal customer
      ***  If branch file is empty, report db error
      *
     C     *LOVAL        SETLL     SDBRCHL5
     C                   READ      SDBRCHL5                               99
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBRCHL5'    DBFILE                         *************
     C                   Z-ADD     11            DBASE                          * DBERR 011 *
     C                   MOVEL     '*FIRST  '    DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C     *IN99         DOUEQ     '1'
     C                   ADD       1             S                 3 0
     C                   MOVE      A8BICN        WBIC(S)
     C                   READ      SDBRCHL5                               99
     C                   ENDDO
     C                   ENDIF
      *                                                                         213809
      ***  Retrieve lending ICD                                                 213809
      *                                                                         213809
     C                   CALL      'AOCLNDR0'                                   213809
     C                   PARM      *BLANKS       @RTCD                          213809
     C                   PARM      '*FIRST '     @OPTN                          213809
     C*****SDCLND        PARM      SDCLND        DSFDY                                 213809 CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
                                                                                213809
     C     @RTCD         IFNE      *BLANKS                                      213809
     C     *LOCK         IN        LDA                                          213809
     C                   MOVE      '*FIRST'      DBKEY                          213809
     C                   MOVEL     'SDCLNDPD'    DBFILE                         213809
     C                   Z-ADD     14            DBASE                          213809
     C                   OUT       LDA                                          213809
     C                   EXSR      *PSSR                                        213809
     C                   ENDIF                                                  213809
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
     C                   MOVE      'N'           CLE009            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE009'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE009
     C                   END
      *
     C                   MOVE      'N'           CLE011            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE011'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE011
     C                   END
      *
     C                   MOVE      'N'           S01465            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01465'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           S01465
     C                   END
      *                                                                                       CLE023
     C                   MOVE      'N'           CLE023            1                          CLE023
     C                   CALLB     'AOSARDR0'                                                 CLE023
     C                   PARM      *BLANKS       @RTCD                                        CLE023
     C                   PARM      '*VERIFY'     @OPTN                                        CLE023
     C                   PARM      'CLE023'      @SARD                                        CLE023
      *                                                                                       CLE023
     C     @RTCD         IFEQ      *BLANKS                                                    CLE023
     C                   MOVE      'Y'           CLE023                                       CLE023
     C                   END                                                                  CLE023
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
     C                   Z-ADD     12            DBASE                          * DBERR 012 * CLE030
     C                   MOVEL     @OPTN         DBKEY                          ************* CLE030
     C                   EXSR      *PSSR                                                      CLE030
     C                   ENDIF                                                                CLE030
     C                   ENDIF                                                                CLE030
      *
      ** Determine if CLE025 is switched on                                                   CLE025
                                                                                              CLE025
     C                   MOVE      'N'           CLE025                                       CLE025
     C                   CALLB     'AOSARDR0'                                                 CLE025
     C                   PARM      *BLANKS       PRTCD                                        CLE025
     C                   PARM      '*VERIFY'     POPTN                                        CLE025
     C                   PARM      'CLE025'      PSARD                                        CLE025
                                                                                              CLE025
     C                   IF        PRTCD <> *BLANKS and                                       CLE025
     C                             PRTCD <> '*NRF   '                                         CLE025
     C                   MOVEL     PSARD         DBKEY                                        CLE025
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CLE025
     C                   Z-ADD     15            DBASE                                        CLE025
     C                   EXSR      *PSSR                                                      CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
     C                   IF        PRTCD = *BLANKS                                            CLE025
     C                   MOVE      'Y'           CLE025                                       CLE025
     C                   ENDIF                                                                CLE025
      *                                                                                       CGL058
      ** Check if CGL058 is on                                                                CGL058
      *                                                                                       CGL058
     C                   MOVE      'N'           CGL058            1                          CGL058
     C                   CALLB     'AOSARDR0'                                                 CGL058
     C                   PARM      *BLANKS       PRTCD                                        CGL058
     C                   PARM      '*VERIFY'     POPTN                                        CGL058
     C                   PARM      'CGL058'      PSARD                                        CGL058
      *                                                                                       CGL058
     C                   IF        PRTCD = *BLANKS                                            CGL058
     C                   MOVE      'Y'           CGL058                                       CGL058
     C                   ENDIF                                                                CGL058
                                                                                             BUG6108
      ** Check if CLE010 (Loan Manager) is switched on:                                      BUG6108
     C                   Eval      PSard = 'CLE010'                                          BUG6108
     C                   CALLB     'AOSARDR0'                                                BUG6108
     C                   Parm      *BLANKS       PRtCd                                       BUG6108
     C                   Parm      '*VERIFY'     POptn                                       BUG6108
     C                   Parm      'CLE010'      PSard                                       BUG6108
                                                                                             BUG6108
     C                   If        PRtCd = *BLANKS                                           BUG6108
     C                   Move      'Y'           CLE010            1                         BUG6108
     C                   Else                                                                BUG6108
     C                   Move      'N'           CLE010                                      BUG6108
     C                   If        PRtCd <> '*NRF    '                                       BUG6108
     C     *LOCK         In        LDA                                                       BUG6108
     C                   Eval      DBFile = 'SCSARDPD'                                       BUG6108
     C                   Eval      DBase = 16                                                BUG6108
     C                   Eval      DBKey = 'CLE010'                                          BUG6108
     C                   Out       LDA                                                       BUG6108
     C                   ExSR      *PSSR                                                     BUG6108
     C                   EndIf                                                               BUG6108
     C                   EndIf                                                               BUG6108
                                                                                             BUG8436
      ***Check*if*CSC024*(OME)*is*switched*on:                                        BUG8436 CSC054
      ** Check if CSC054 (PEA) is switched on:                                                CSC054
                                                                                             BUG8436
     C                   CALLB     'AOSARDR0'                                                BUG8436
     C                   PARM      *BLANKS       PRtCd                                       BUG8436
     C                   PARM      '*VERIFY'     POptn                                       BUG8436
     C**********         PARM      'CSC024 '     PSard                                BUG8436 CSC054
     C                   PARM      'CSC054 '     PSard                                        CSC054
                                                                                             BUG8436
     C                   IF        PRtCd = *BLANKS                                           BUG8436
     C**********         MOVE      'Y'           CSC024            1                  BUG8436 CSC054
     C                   MOVE      'Y'           CSC054                                       CSC054
     C                   ELSE                                                                BUG8436
     C**********         MOVE      'N'           CSC024                               BUG8436 CSC054
     C                   MOVE      'N'           CSC054                                       CSC054
     C                   IF        PRtCd <> '*NRF    '                                       BUG8436
     C     *LOCK         IN        LDA                                                       BUG8436
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG8436
     C                   EVAL      DBase = 18                                                BUG8436
     C**********         EVAL      DBKey = 'CSC024'                                   BUG8436 CSC054
     C                   EVAL      DBKey = 'CSC054'                                           CSC054
     C                   OUT       LDA                                                       BUG8436
     C                   EXSR      *PSSR                                                     BUG8436
     C                   ENDIF                                                               BUG8436
     C                   ENDIF                                                               BUG8436
      *                                                                                       CLE106
      ** Determine if CLE106 is switched on                                                   CLE106
      *                                                                                       CLE106
     C                   MOVE      'N'           CLE106                                       CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *BLANKS       PRTCD                                        CLE106
     C                   PARM      '*VERIFY'     POPTN                                        CLE106
     C                   PARM      'CLE106'      PSARD                                        CLE106
      *                                                                                       CLE106
     C                   IF        PRTCD <> *BLANKS and                                       CLE106
     C                             PRTCD <> '*NRF   '                                         CLE106
     C                   MOVEL     PSARD         DBKEY                                        CLE106
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CLE106
     C                   Z-ADD     16            DBASE                                        CLE106
     C                   EXSR      *PSSR                                                      CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE106
     C                   IF        PRTCD = *BLANKS                                            CLE106
     C                   MOVE      'Y'           CLE106                                       CLE106
     C                   ENDIF                                                                CLE106
      *                                                                                       CLE042
      ** Determine if CLE042 is switched on                                                   CLE042
      *                                                                                       CLE042
     C                   MOVE      'N'           CLE042                                       CLE042
     C                   CALLB     'AOSARDR0'                                                 CLE042
     C                   PARM      *BLANKS       PRTCD                                        CLE042
     C                   PARM      '*VERIFY'     POPTN                                        CLE042
     C                   PARM      'CLE042'      PSARD                                        CLE042
      *                                                                                       CLE042
     C                   IF        PRTCD <> *BLANKS and                                       CLE042
     C                             PRTCD <> '*NRF   '                                         CLE042
     C                   MOVEL     PSARD         DBKEY                                        CLE042
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CLE042
     C                   Z-ADD     60            DBASE                                        CLE042
     C                   EXSR      *PSSR                                                      CLE042
     C                   ENDIF                                                                CLE042
      *                                                                                       CLE042
     C                   IF        PRTCD = *BLANKS                                            CLE042
     C                   MOVE      'Y'           CLE042            1                          CLE042
     C                   ENDIF                                                                CLE042
                                                                                              CLE031
      ** Determine if CLE031 is switched on                                                   CLE031
                                                                                              CLE031
     C                   MOVE      'N'           CLE031                                       CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       PRTCD                                        CLE031
     C                   PARM      '*VERIFY'     POPTN                                        CLE031
     C                   PARM      'CLE031'      PSARD                                        CLE031
                                                                                              CLE031
     C                   IF        PRTCD <> *BLANKS and                                       CLE031
     C                             PRTCD <> '*NRF   '                                         CLE031
     C                   MOVEL     PSARD         DBKEY                                        CLE031
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CLE031
     C                   Z-ADD     18            DBASE                                        CLE031
     C                   EXSR      *PSSR                                                      CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
     C                   IF        PRTCD = *BLANKS                                            CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CAS019
      ** Determine if CAS016 is switched on                                                   CAS019
                                                                                              CAS019
     C                   MOVE      'N'           CAS016                                       CAS019
     C                   CALLB     'AOSARDR0'                                                 CAS019
     C                   PARM      *BLANKS       PRTCD                                        CAS019
     C                   PARM      '*VERIFY'     POPTN                                        CAS019
     C                   PARM      'CAS016'      PSARD                                        CAS019
                                                                                              CAS019
     C                   IF        PRTCD <> *BLANKS and                                       CAS019
     C                             PRTCD <> '*NRF   '                                         CAS019
     C                   MOVEL     PSARD         DBKEY                                        CAS019
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAS019
     C                   Z-ADD     20            DBASE                                        CAS019
     C                   EXSR      *PSSR                                                      CAS019
     C                   ENDIF                                                                CAS019
                                                                                              CAS019
     C                   IF        PRTCD = *BLANKS                                            CAS019
     C                   MOVE      'Y'           CAS016                                       CAS019
     C                   ENDIF                                                                CAS019
      *                                                                                       CER020
      ** Determine if CER020 is switched on                                                   CER020
      *                                                                                       CER020
     C                   EVAL      CER020 = 'N'                                               CER020
     C                   CALLB     'AOSARDR0'                                                 CER020
     C                   PARM      *BLANKS       PRtcd                                        CER020
     C                   PARM      '*VERIFY'     POptn                                        CER020
     C                   PARM      'CER020'      PSard                                        CER020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER020
      *                                                                                       CER020
     C                   IF        PRtcd <> *BLANKS AND                                       CER020
     C                             PRtcd <> '*NRF   '                                         CER020
      *                                                                                       CER020
     C                   EVAL      DBKEY = PSard                                              CER020
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER020
     C                   EVAL      DBASE = 21                                                 CER020
     C                   EXSR      *PSSR                                                      CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   IF        PRtcd = *BLANKS                                            CER020
     C                   MOVE      'Y'           CER020                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CLE134
      ** Access SAR details to see if CLE134 is switched on.                                  CLE134
      *                                                                                       CLE134
     C                   EVAL      CLE134      = 'N'                                          CLE134
     C                   CALL      'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANKS       PRTCD                                        CLE134
     C                   PARM      '*VERIFY'     POPTN                                        CLE134
     C                   PARM      'CLE134'      PSARD                                        CLE134
      *                                                                                       CLE134
     C                   IF        PRTCD      <> *BLANKS       AND                            CLE134
     C                             PRTCD      <> '*NRF'                                       CLE134
     C     *LOCK         IN        LDA                                                        CLE134
     C                   EVAL      DBKey       = PSARD                                        CLE134
     C                   EVAL      DBFile      = 'SCSARDPD'                                   CLE134
     C                   EVAL      DBase       = 912                                          CLE134
     C                   OUT       LDA                                                        CLE134
     C                   EXSR      *PSSR                                                      CLE134
     C                   ENDIF                                                                CLE134
      *                                                                                       CLE134
     C                   IF        PRTCD       = *BLANKS                                      CLE134
     C                   EVAL      CLE134      = 'Y'                                          CLE134
     C     *DTAARA       DEFINE                  MPHAS                                      MD031225
     C                   IN        MPHAS                                                    MD031225
     C                   UNLOCK    MPHAS                                                    MD031225
     C                   ENDIF                                                                CLE134
                                                                                             BUG6108
                                                                                              CLE143
      ** Determine if CLE143 is switched on                                                   CLE143
                                                                                              CLE143
     C                   EVAL      CLE143 = 'N'                                               CLE143
     C                   CALLB     'AOSARDR0'                                                 CLE143
     C                   PARM      *BLANKS       PRtcd                                        CLE143
     C                   PARM      '*VERIFY'     POptn                                        CLE143
     C                   PARM      'CLE143'      PSard                                        CLE143
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE143
                                                                                              CLE143
     C                   IF        PRtcd <> *BLANKS AND                                       CLE143
     C                             PRtcd <> '*NRF   '                                         CLE143
                                                                                              CLE143
     C                   EVAL      DBKEY = PSard                                              CLE143
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE143
     C                   EVAL      DBASE = 22                                                 CLE143
     C                   EXSR      *PSSR                                                      CLE143
                                                                                              CLE143
     C                   ENDIF                                                                CLE143
                                                                                              CLE143
     C                   IF        PRtcd = *BLANKS                                            CLE143
     C                   MOVE      'Y'           CLE143                                       CLE143
     C                   ENDIF                                                                CLE143
                                                                                              CLE143
      ** Determine if CLE141 is switched on                                                   CLE141
                                                                                              CLE141
     C                   EVAL      CLE141 = 'N'                                               CLE141
     C                   CALLB     'AOSARDR0'                                                 CLE141
     C                   PARM      *BLANKS       PRtcd                                        CLE141
     C                   PARM      '*VERIFY'     POptn                                        CLE141
     C                   PARM      'CLE141'      PSard                                        CLE141
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE141
                                                                                              CLE141
     C                   IF        PRtcd = *BLANKS                                            CLE141
     C                   EVAL      CLE141 = 'Y'                                               CLE141
     C                   ENDIF                                                                CLE141
                                                                                              CLE141
     C                   IF        PRtcd <> *BLANKS AND                                       CLE141
     C                             PRtcd <> '*NRF   '                                         CLE141
     C                   EVAL      DBKEY = PSard                                              CLE141
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CLE141
     C                   EVAL      DBASE = 24                                                 CLE141
     C                   EXSR      *PSSR                                                      CLE141
     C                   ENDIF                                                                CLE141
                                                                                              CLE141
      ** Determine if CLE158 is switched on                                                   CLE158
                                                                                              CLE158
     C                   EVAL      CLE158 = 'N'                                               CLE158
     C                   CALLB     'AOSARDR0'                                                 CLE158
     C                   PARM      *BLANKS       PRTCD                                        CLE158
     C                   PARM      '*VERIFY'     POPTN                                        CLE158
     C                   PARM      'CLE158'      PSARD                                        CLE158
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE158
                                                                                              CLE158
     C                   IF        PRTCD = *BLANKS                                            CLE158
     C                   EVAL      CLE158 = 'Y'                                               CLE158
     C                   ENDIF                                                                CLE158
                                                                                              CLE158
      ** Check for auto allocation of loan numbers system value.                             BUG6108
     C                   CALLB     'AOSVALR0'                                                BUG6108
     C                   PARM      *BLANKS       PRtCd                                       BUG6108
     C                   PARM      AutoAlloc     PSysVal01                                   BUG6108
     C                   PARM                    PCurSet01                                   BUG6108
     C**********         PARM                    PSysVal02                           BUG6108 BUG8436
     C**********         PARM      OMEInd        PSysVal02                            BUG8436 CSC054
     C                   PARM      PEAInd        PSysVal02                                    CSC054
     C                   PARM                    PCurSet02                                   BUG6108
     C**********         PARM                    PSysVal03                            BUG6108 256579
     C                   PARM      RateFixDays   PSysVal03                                    256579
     C                   PARM                    PCurSet03                                   BUG6108
     C**********         PARM                    PSysVal04                            BUG6108 CLE158
     C                   PARM      FctyNoDaysFwd PSysVal04                                    CLE158
     C                   PARM                    PCurSet04                                   BUG6108
     C                   PARM                    PSysVal05                                   BUG6108
     C                   PARM                    PCurSet05                                   BUG6108
     C                   PARM                    PSysVal06                                   BUG6108
     C                   PARM                    PCurSet06                                   BUG6108
     C                   PARM                    PSysVal07                                   BUG6108
     C                   PARM                    PCurSet07                                   BUG6108
     C                   PARM                    PSysVal08                                   BUG6108
     C                   PARM                    PCurSet08                                   BUG6108
     C                   PARM                    PSysVal09                                   BUG6108
     C                   PARM                    PCurSet09                                   BUG6108
     C                   PARM                    PSysVal10                                   BUG6108
     C                   PARM                    PCurSet10                                   BUG6108
                                                                                             BUG6108
     C                   If        PRtCd <> *Blanks                                          BUG6108
     C     *LOCK         In        LDA                                                       BUG6108
     C                   Eval      DBFile = 'SDSVALPD'                                       BUG6108
     C                   Eval      DBase = 17                                                BUG6108
     C                   Eval      DBKey = PSysVal01                                         BUG6108
     C                   Out       LDA                                                       BUG6108
     C                   ExSR      *PSSR                                                     BUG6108
     C                   EndIf                                                               BUG6108
                                                                                             BUG6108
      * Isolate the first character of the current system value setting                      BUG6108
     C                   MOVEL     PCurSet01     WRK01             1                         BUG6108
     C                   If        WRK01 = 'N'                                               BUG6108
     C                   Move      'N'           AUTOLN            1                         BUG6108
     C                   Else                                                                BUG6108
     C                   Move      'Y'           AUTOLN                                      BUG6108
     C                   EndIf                                                               BUG6108
                                                                                             BUG8436
      ** Isolate the first character of the current system value setting                     BUG8436
                                                                                             BUG8436
     C                   MOVEL     PCurSet02     WRK01                                       BUG8436
     C                   IF        WRK01 = 'N'                                               BUG8436
     C**********         MOVE      'N'           WOMEInd           1                  BUG8436 CSC054
     C                   MOVE      'N'           WPEAInd                                      CSC054
     C                   ELSE                                                                BUG8436
     C**********         MOVE      'Y'           WOMEINd                              BUG8436 CSC054
     C                   MOVE      'Y'           WPEAINd                                      CSC054
     C                   ENDIF                                                               BUG8436
                                                                                              CLE158
     C                   MOVEL     PCurSet04     NdayFwd                                      CLE158
      *                                                                                       CLE148
      ** Check System Value: LoanAlphaAllow                                                   CLE148
      ** Check System Value: AutoEndCalcLoanFee                                             MD046370
      *                                                                                     MD046370
     C                   EVAL      SVALK1 = 'LoanAlphaAllow'                                  CLE148
     C                   EVAL      SVALK2 = 'AutoEndCalcLoanFee'                            MD046370
      *                                                                                       CLE148
     C                   CALL      'AOSVALR0'                                                 CLE148
     C                   PARM                    RTNCDE            7                          CLE148
     C                   PARM                    SVALK1           20                          CLE148
     C                   PARM                    SVAL1           200                          CLE148
     C                   PARM                    SVALK2           20                          CLE148
     C                   PARM                    SVAL2           200                          CLE148
     C                   PARM                    SVALK3           20                          CLE148
     C                   PARM                    SVAL3           200                          CLE148
     C                   PARM                    SVALK4           20                          CLE148
     C                   PARM                    SVAL4           200                          CLE148
     C                   PARM                    SVALK5           20                          CLE148
     C                   PARM                    SVAL5           200                          CLE148
     C                   PARM                    SVALK6           20                          CLE148
     C                   PARM                    SVAL6           200                          CLE148
     C                   PARM                    SVALK7           20                          CLE148
     C                   PARM                    SVAL7           200                          CLE148
     C                   PARM                    SVALK8           20                          CLE148
     C                   PARM                    SVAL8           200                          CLE148
     C                   PARM                    SVALK9           20                          CLE148
     C                   PARM                    SVAL9           200                          CLE148
     C                   PARM                    SVALK0           20                          CLE148
     C                   PARM                    SVAL10          200                          CLE148
      *                                                                                       CLE148
      * If the system value is not found then issue a database error                          CLE148
     C                   IF        RTNCDE <> *BLANKS                                          CLE148
     C                   EVAL      DBFile = 'SDSVALPD'                                        CLE148
     C                   EVAL      DBKey  = '*FIRST  '                                        CLE148
     C                   EVAL      DBase  = 23                                                CLE148
     C                   EXSR      *PSSR                                                      CLE148
                                                                                              CLE148
     C                   ELSE                                                                 CLE148
     C                   MOVEL     SVAL1         wLoanAlpha        1                          CLE148
     C                   MOVEL     SVAL2         AutoEndFee        1                        MD046370
     C                   ENDIF                                                                CLE148
                                                                                              CLE148
     C     P_LELOANISO   PList                                                                CLE148
      ** Loan Number (Input)                                                                  CLE148
     C                   Parm                    PLNRF             6                          CLE148
      ** Validity Flags (Output)                                                              CLE148
     C                   Parm                    PValid            6                          CLE148
      ** Check Digit (Output)                                                                 CLE148
     C                   Parm                    PChkDigit         1                          CLE148
     C                   Parm                    PData             2                          CLE148
      *                                                                                      BUG6108
      ** Key for accessing MCLONCL.                                                          BUG6108
      *                                                                                      BUG6108
     C     MLKEY         KLIST                                                               BUG6108
     C                   KFLD                    MLLNRF                                      BUG6108
     C                   KFLD                    MLRCDT                                      BUG6108
      *
      ***  Key list for Facilities file
      *
     C     WKFAC         KLIST
     C**********         KFLD                    WFCNUM            6 0                        CSD027
     C                   KFLD                    WFCNUM            6                          CSD027
     C                   KFLD                    WFFACT            3 0
     C                   KFLD                    WFFCNO            2 0
     C                   KFLD                    WFRCTP            1
      *
     C     WKFAM2        KLIST
     C                   KFLD                    CNUMF
     C                   KFLD                    FACT
     C                   KFLD                    FCNO
      *
      ***  Key list for CLOAN
      *
     C     WKLON         KLIST
     C**********         KFLD                    WALON             6 0                        CLE148
     C                   KFLD                    WALON             6                          CLE148
     C                   KFLD                    WEPAR             1
      *
      ***  Key list for LOAMS
      *
     C     WKLAM         KLIST
     C**********         KFLD                    WLLOAN            6 0                        CLE148
     C                   KFLD                    WLLOAN            6                          CLE148
     C                   KFLD                    WLVDAT            5 0
     C                   KFLD                    WLLASN            3 0
      *
      ***  Key list for HISTSHP                                                               248222
      *                                                                                       248222
     C     WKLHS         KLIST                                                                248222
     C**********         KFLD                    WLLOAN            6 0                 248222 CLE148
     C                   KFLD                    WLLOAN            6                          CLE148
     C                   KFLD                    WLVDAT            5 0                        248222
      *                                                                                       248222
      ***  Key list for LF/LEFCLTLD (credit agreement facility file)
      *
     C     CRAKEY        KLIST
     C**********         KFLD                    CANM              6 0                        CSD027
     C                   KFLD                    CANM              6                          CSD027
     C                   KFLD                    CAFT              3 0
     C                   KFLD                    CAFN              2 0
      *
      ***  Key list for LEPARTL1
      *
     C     WKEY          KLIST
     C                   KFLD                    BRCAM
     C                   KFLD                    FCUSM
     C                   KFLD                    FTYPM
     C                   KFLD                    FSEQM
      *
      ***  Key list for LEFCLTL2 (funding participant details)
      *
     C     K#FUND        KLIST
     C                   KFLD                    K#BRCA            3
     C**********         KFLD                    K#PMFC            6 0                        CSD027
     C                   KFLD                    K#PMFC            6                          CSD027
     C                   KFLD                    K#PMFT            3 0
     C                   KFLD                    K#PMFN            2 0
     C**********         KFLD                    K#CNUM            6 0                        CSD027
     C                   KFLD                    K#CNUM            6                          CSD027
      *
      ***  Key list for Facility Amendments file
      *
     C     WKFAM         KLIST
     C                   KFLD                    BRCAF
     C                   KFLD                    CNUMF
     C                   KFLD                    FACT
     C                   KFLD                    FCNO
      *
      ***  Key list for Facility Amendments file (CA)
      *
     C     WKFAM3        KLIST
     C                   KFLD                    BRCAF
     C                   KFLD                    CNUMF
     C                   KFLD                    FACTB
     C                   KFLD                    FCNOB
      *
      ***  KLIST for LF/LEFEEDL2
      *
     C     LEFKEY        KLIST
     C**********         KFLD                    FCNUM             6 0                        CSD027
     C                   KFLD                    FCNUM             6                          CSD027
     C                   KFLD                    FFACL             5 0
     C**********         KFLD                    FLOAN             6 0                        CLE148
     C                   KFLD                    FLOAN             6                          CLE148
      *
      ***  Key list for PSOLDLL
      *
     C     WKPAR         KLIST
     C**********         KFLD                    @@LNRF                                       CSD027
     C                   KFLD                    @@LNRFA           6                          CSD027
     C                   KFLD                    WMDAT             5 0
      *
      ***  Key list for Facilities file (access of prime facility)
      *
     C     WKPRM         KLIST
     C                   KFLD                    WFCNUM
     C                   KFLD                    WFFACT
     C                   KFLD                    WFFCNO
      *
      ***  Key list for lepartl2 (sale of loan fac)
      *
     C     K#PART        KLIST
     C                   KFLD                    PBRCA
     C                   KFLD                    S#FCUS
     C                   KFLD                    S#FTYP
     C                   KFLD                    S#FSEQ
      *
      ***  Key list for fclty (sale of loan fac)
      *
     C     K#FCLT        KLIST
     C                   KFLD                    S#FCUS
     C                   KFLD                    S#FTYP
     C                   KFLD                    S#FSEQ
      **********                                                                  MD022807 MD022807C
     C*****K_Fees        KLIST                                                    MD022807 MD022807C
     C**********         KFLD                    @@BRCA                           MD022807 MD022807C
     C**********         KFLD                    @@OFCU                           MD022807 MD022807C
     C**********         KFLD                    NNOFAC                           MD022807 MD022807C
     C**********         KFLD                    @@OFLN                           MD022807 MD022807C
     C**********         KFLD                    NNOFSQ                           MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C*****K_FEEV        KLIST                                                    MD022807 MD022807C
     C**********         KFLD                    @@OFLN                           MD022807 MD022807C
     C**********         KFLD                    WSVMD                            MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C*****K_LOEV        KLIST                                                    MD022807 MD022807C
     C**********         KFLD                    @@ORLN                           MD022807 MD022807C
     C**********         KFLD                    WSVMD                            MD022807 MD022807C
      *
      ***  set the message file
      *
     C                   EVAL      #MsgFile = 'LERMSGF'
      *
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,LECLIP1V27
      *
      ***  Program, module and procedure names for database error processing.
      ***  =================================================================
      ***  The following /COPY sets these values, and also defines LDA as
      ***  an external data area
      *
     C                   ENDSR
      *****************************************************************           MD022807 MD022807C
     C*EJECT***********************************************************           MD022807 MD022807C
      *****************************************************************           MD022807 MD022807C
      **SRChckMat*-*Validate*PDCL*Maturity*Date************************           MD022807 MD022807C
      *****************************************************************           MD022807 MD022807C
     C*****SRChckMat     BEGSR                                                    MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
      ***Entry*is*prohibited*when*Outstanding*Interest/Principal*is*not Zero,     MD022807 MD022807C
      ***PDCL*Block*Debit*system*value*is*'Y',*and*Settlement*account*is          MD022807 MD022807C
      ***blocked.******************************************************           MD022807 MD022807C
     C**********         EVAL      WrkoutInt = 0                                  MD022807 MD022807C
     C**********         EXSR      SRIntOut                                       MD022807 MD022807C
     C**********         EXSR      SRRtvAcc                                       MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C**********         IF        PDCLBlock = 'Y' AND WBLCKD = 'Y'               MD022807 MD022807C
     C**********                   AND (WrkoutInt <> 0 OR @@CPAM <> 0)            MD022807 MD022807C
     C**********         MOVE      'N'           DDMDATOK                         MD022807 MD022807C
     C**********         ADD       1             Idx                              MD022807 MD022807C
     C**********         MOVEL     'DDMDAT'      FldNamXAr(Idx)                   MD022807 MD022807C
     C**********         MOVEL     '5046134'     MsgIDXAr(Idx)                    MD022807 MD022807C
     C**********         ENDIF                                                    MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
      ***Send*warning*if*PDCL*maturity*date*is*earlier*that*the********           MD022807 MD022807C
      ***original*transaction*maturity*********************************           MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C**********         IF        %SUBST(DDLTYP:1:1) = 'Z'                       MD022807 MD022807C
     C**********         MOVE      @@OFAC        NNOFAC            5 0            MD022807 MD022807C
     C**********         MOVE      @@OFSQ        NNOFSQ            2 0            MD022807 MD022807C
     C*****K_Fees        CHAIN     LEFEED                                         MD022807 MD022807C
     C**********         IF        WSVMD < OFFEPEND                               MD022807 MD022807C
     C**********         EVAL      DDMDATOK = 'W'                                 MD022807 MD022807C
     C**********         EVAL      WIdx = WIdx + 1                                MD022807 MD022807C
     C**********         EVAL      WFldNmXAr(WIdx) = 'DDMDAT'                     MD022807 MD022807C
     C**********         EVAL      WMsgIDXAr(WIdx) = '5046135'                    MD022807 MD022807C
     C**********         ENDIF                                                    MD022807 MD022807C
     C**********         ELSE                                                     MD022807 MD022807C
     C*****@@ORLN        CHAIN     CLOANC                                         MD022807 MD022807C
     C**********         IF        WSVMD < OLMDAT                                 MD022807 MD022807C
     C**********         EVAL      DDMDATOK = 'W'                                 MD022807 MD022807C
     C**********         EVAL      WIdx = WIdx + 1                                MD022807 MD022807C
     C**********         EVAL      WFldNmXAr(WIdx) = 'DDMDAT'                     MD022807 MD022807C
     C**********         EVAL      WMsgIDXAr(WIdx) = '5046135'                    MD022807 MD022807C
     C**********         ENDIF                                                    MD022807 MD022807C
     C**********         ENDIF                                                    MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
      ***A*payment*is*due*for*the*Original*transaction*on*the**********           MD022807 MD022807C
      ***on*the*PDCL*Maturity*date*************************************           MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C**********         EVAL      WRepay = *BLANKS                               MD022807 MD022807C
     C**********         IF        %SUBST(DDLTYP:1:1) = 'Z'                       MD022807 MD022807C
     C*****K_FEEV        SETLL     LOAMSOM3                                       MD022807 MD022807C
     C*****K_FEEV        READE     LOAMSOM3                               65      MD022807 MD022807C
     C**********         DOW       *IN65 = '0'                                    MD022807 MD022807C
     C**********         IF        O2AMTP = 'RE' OR O2AMTP = 'MR'                 MD022807 MD022807C
     C**********         MOVE      'Y'           WRepay            1              MD022807 MD022807C
     C**********         LEAVE                                                    MD022807 MD022807C
     C**********         ENDIF                                                    MD022807 MD022807C
     C*****K_FEEV        READE     LOAMSOM3                               65      MD022807 MD022807C
     C**********         ENDDO                                                    MD022807 MD022807C
      ***Issue*warning*************************************************           MD022807 MD022807C
     C**********         IF        WSVMD = OFFENPYD OR WRepay = 'Y'               MD022807 MD022807C
     C**********         EVAL      DDMDATOK = 'W'                                 MD022807 MD022807C
     C**********         EVAL      WIdx = WIdx + 1                                MD022807 MD022807C
     C**********         EVAL      WFldNmXAr(WIdx) = 'DDMDAT'                     MD022807 MD022807C
     C**********         EVAL      WMsgIDXAr(WIdx) = '5046136'                    MD022807 MD022807C
     C**********         ENDIF                                                    MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C**********         ELSE                                                     MD022807 MD022807C
     C*****K_LOEV        SETLL     LOAMSOM3                                       MD022807 MD022807C
     C*****K_LOEV        READE     LOAMSOM3                               65      MD022807 MD022807C
     C**********         DOW       *IN65 = '0'                                    MD022807 MD022807C
     C**********         IF        O2AMTP = 'RE' OR O2AMTP = 'MR'                 MD022807 MD022807C
     C**********         MOVE      'Y'           WRepay                           MD022807 MD022807C
     C**********         LEAVE                                                    MD022807 MD022807C
     C**********         ENDIF                                                    MD022807 MD022807C
     C*****K_LOEV        READE     LOAMSOM3                               65      MD022807 MD022807C
     C**********         ENDDO                                                    MD022807 MD022807C
      ***Issue*warning*************************************************           MD022807 MD022807C
     C**********         IF        WSVMD = NRPD OR WSVMD = NIPD                   MD022807 MD022807C
     C**********                   OR WRepay = 'Y'                                MD022807 MD022807C
     C**********         EVAL      DDMDATOK = 'W'                                 MD022807 MD022807C
     C**********         EVAL      WIdx = WIdx + 1                                MD022807 MD022807C
     C**********         EVAL      WFldNmXAr(WIdx) = 'DDMDAT'                     MD022807 MD022807C
     C**********         EVAL      WMsgIDXAr(WIdx) = '5046136'                    MD022807 MD022807C
     C**********         ENDIF                                                    MD022807 MD022807C
     C**********         ENDIF                                                    MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C**********         ENDSR                                                    MD022807 MD022807C
      *****************************************************************           MD022807 MD022807C
     C*EJECT***********************************************************           MD022807 MD022807C
      *****************************************************************           MD022807 MD022807C
      **srGLINTC*-*Calculate*Interest*on*period************************           MD022807 MD022807C
      *****************************************************************           MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C*****SRGLINTC      BEGSR                                                    MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C**********         CALL      'GLINTC'                                       MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
      ***Starting*Date*************************************************           MD022807 MD022807C
      ***Finishing*Date************************************************           MD022807 MD022807C
      ***Calc.*Basis***************************************************           MD022807 MD022807C
      ***Principal*****************************************************           MD022807 MD022807C
      ***Rate*of*Interest**********************************************           MD022807 MD022807C
      ***Interest******************************************************           MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C**********         PARM                    ZIBEG                            MD022807 MD022807C
     C**********         PARM                    ZIEND                            MD022807 MD022807C
     C**********         PARM                    ZICALC                           MD022807 MD022807C
     C**********         PARM                    ZIAMT                            MD022807 MD022807C
     C**********         PARM                    ZIRATE                           MD022807 MD022807C
     C**********         PARM                    ZINTR                            MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C**********         ENDSR                                                    MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C*EJECT***********************************************************           MD022807 MD022807C
      *****************************************************************           MD022807 MD022807C
      **srIntOut*-*Outstanding*Interest********************************           MD022807 MD022807C
      *****************************************************************           MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C*****SRIntOut      BEGSR                                                    MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
      ****O/S*INTEREST*************************************************           MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C**********         Z-ADD     0             WrkOutInt                        MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
      ***Set*End*date**************************************************           MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C**********         IF        WSVVD  > BJRDNB AND CLE005 = 'Y'               MD022807 MD022807C
     C**********         EVAL      ZIEND = WSVVD                                  MD022807 MD022807C
     C**********         ELSE                                                     MD022807 MD022807C
     C**********         EVAL      ZIEND = BJRDNB                                 MD022807 MD022807C
     C**********         ENDIF                                                    MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C**********         IF        WSVMD <> 0 AND WSVMD < BJRDNB                  MD022807 MD022807C
     C**********         EVAL      ZIEND = WSVMD                                  MD022807 MD022807C
     C**********         ENDIF                                                    MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
      ***Start*Date****************************************************           MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C**********         EVAL      ZIBEG = @@IACD                                 MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
      ***Add*1*to*End*date*dependin*on*ADDI*indicator******************           MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C**********         IF        @@ADDI = 'B' AND ZIEND = WSVMD AND             MD022807 MD022807C
     C**********                   @@ORED < WSVMD                                 MD022807 MD022807C
     C**********         EVAL      ZIEND = ZIEND + 1                              MD022807 MD022807C
     C**********         ENDIF                                                    MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
      ***Add*1*to*End*date*if*Original*Entry*date*is*after*************           MD022807 MD022807C
      ** maturity date                                                            MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C**********         IF        @@ADDI = 'B' AND @@ORED >= WSVMD               MD022807 MD022807C
     C**********         EVAL      ZIEND = ZIEND + 1                              MD022807 MD022807C
     C**********         ENDIF                                                    MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
      ***set*parameters*required*for*interest*calculation**************           MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C**********         EVAL      ZICALC = @@ICBS                                MD022807 MD022807C
     C**********         EVAL      ZIRATE = @@INTR                                MD022807 MD022807C
     C**********         EVAL      ZIAMT = @@CPAM                                 MD022807 MD022807C
     C**********         EXSR      SRGLINTC                                       MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
      ***Round*Interest*depending*on*RDFC*indicator********************           MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C**********         IF        @@RDFC = 'Y'                                   MD022807 MD022807C
     C**********         Z-ADD     ZINTR         WkRound                          MD022807 MD022807C
     C**********         Z-ADD     WkRound       ZINTR                            MD022807 MD022807C
     C**********         ENDIF                                                    MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
      ***Calculate*Interest*Outstanding********************************           MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C**********         EVAL      WrkOutInt = ZINTR + @@AITC + @@AIAP +          MD022807 MD022807C
     C**********                   @@AIMN - @@IPRD - @@ICTD - @@IWOD              MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C**********         ENDSR                                                    MD022807 MD022807C
      *****************************************************************           MD022807 MD022807C
     C*EJECT***********************************************************           MD022807 MD022807C
      *****************************************************************           MD022807 MD022807C
      **srRtvAcc*-*Retrieve*Account*Details****************************           MD022807 MD022807C
      *****************************************************************           MD022807 MD022807C
      *****************************************************************           MD022807 MD022807C
     C*****SRRtvAcc      BEGSR                                                    MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C**********         MOVE      *BLANKS       WOSAC                            MD022807 MD022807C
     C**********         MOVE      *BLANKS       WSETP                            MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C*****@@PTYP        IFNE      66                                             MD022807 MD022807C
     C*****@@PTYP        ANDNE     67                                             MD022807 MD022807C
     C*****@@PTYP        ANDNE     69                                             MD022807 MD022807C
     C*****@@PTYP        ANDNE     72                                             MD022807 MD022807C
     C**********         MOVE      @@RONS        WOSAC                            MD022807 MD022807C
     C**********         MOVE      @@RSTM        WSETP                            MD022807 MD022807C
     C**********         MOVE      @@OMDB        OSBR                             MD022807 MD022807C
     C**********         ELSE                                                     MD022807 MD022807C
     C**********         MOVE      @@PONS        WOSAC                            MD022807 MD022807C
     C**********         MOVE      @@PSTM        WSETP                            MD022807 MD022807C
     C**********         MOVE      @@OSDB        OSBR                             MD022807 MD022807C
     C**********         ENDIF                                                    MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
      ***Retrieve*sett*account*and*priority****************************           MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C**********         MOVE      @@CNUM        ILCNUM                           MD022807 MD022807C
     C**********         CALL      'LE007054'                                     MD022807 MD022807C
     C**********         PARM      @@CCY         CCYL                             MD022807 MD022807C
     C**********         PARM                    ILCNUM                           MD022807 MD022807C
     C**********         PARM      @@SCCY        KSCCY                            MD022807 MD022807C
     C**********         PARM                    WOSAC                            MD022807 MD022807C
     C**********         PARM                    WSETP                            MD022807 MD022807C
     C**********         PARM                    @@OLNO                           MD022807 MD022807C
     C**********         PARM                    OSBR                             MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C**********         PARM      *BLANKS       WBLCKD                           MD022807 MD022807C
      **********                                                                  MD022807 MD022807C
     C**********         ENDSR                                                    MD022807 MD022807C
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
**  CPY@
(c) Finastra International Limited 2002
** WFREQ **      Table of frequency codes for rollovers                                       CLE064
DWFMTQ45X789VEYCIJNU                                                                          CLE064
**  POWER - ARRAY OF POWERS FOR CURRENCY CONVERSION
0000001
0000010
0000100
0001000
0010000
0100000
1000000
** WDRPT **      Table of Facility's Drawing Types and Loan Processing Types
C61
C68
C69
T62
T64
T66
D63
D65
D67
R70
R71
R72
F80                                                                                          BUG3721
