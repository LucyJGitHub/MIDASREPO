     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBI *  OVRDBF FILE(LEFEEDLH) TOFILE(LEFEEDLH) SHARE(*NO)            *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Customer loans database update')              *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LECLIPUPD - Customer Loans database update                   *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD051922           Date 15OCt18               *
      *  Prev Amend No. CLE071             Date 18Jul18               *
      *                 MD040789           Date 24Jan18               *
      *                 MD046370           Date 07Nov17               *
      *                 260408             Date 06Oct17               *
      *                 MD046248           Date 27Oct17               *
      *                 MD041714           Date 29Sep16               *
      *                 MD039449           Date 04Jul16               *
      *                 MD034363           Date 30Jun15               *
      *                 MD045480           Date 12May17               *
      *                 AR943686           Date 23Sep16               *
      *                 CLE141             Date 08Feb16               *
      *                 MD034771           Date 23Jun15               *
      *                 CGL165             Date 17Mar15               *
      *                 MD030621           Date 26Feb15               *
      *                 MD032052           Date 23Jan15               *
      *                 CLE164             Date 18Aug14               *
      *                 AR318769           Date 19Aug14               *
      *                 MD026167           Date 13May14               *
      *                 MD025467           Date 08May14               *
      *                 MD024342B          Date 08May14               *
      *                 MD024342           Date 08May14               *
      *                 MD023203           Date 24Apr14               *
      *                 MD022807I          Date 24Apr14               *
      *                 MD022807           Date 27Dec13               *
      *                 AR1093201          Date 27Dec13               *
      *                 MD020361A          Date 30Sep13               *
      *                 MD020242           Date 30Sep13               *
      *                 MD022114           Date 22Aug13               *
      *                 MD021423           Date 21Aug13               *
      *                 MD020954           Date 02Aug13               *
      *                 MD021554           Date 02Aug13               *
      *                 MD021395           Date 02Aug13               *
      *                 MD020960           Date 27Jun13               *
      *                 AR868380           Date 19Jun13               *
      *                 MD019945           Date 19Jun13               *
      *                 AR819476           Date 19Jun13               *
      *                 MD020605           Date 10Jun13               *
      *                 MD020534           Date 23May13               *
      *                 MD020318           Date 14May13               *
      *                 AR1052933          Date 07Nov12               *
      *                 AR1091213          Date 26Feb13               *
      *                 AR1079502          Date 03Feb13               *
      *                 AR1085742          Date 06Jan13               *
      *                 AR804863           Date 10Dec12               *
      *                 262735A            Date 17Aug12               *
      *                 262735             Date 17Aug12               *
      *                 AR1022006          Date 01Aug12               *
      *                 AR1021983          Date 01Aug12               *
      *                 AR574498           Date 01Aug12               *
      *                 AR545441           Date 01Aug12               *
      *                 AR317473A          Date 01Aug12               *
      *                 AR314017           Date 01Aug12               *
      *                 AR217556           Date 01Aug12               *
      *                 263840             Date 01Aug12               *
      *                 262328             Date 01Aug12               *
      *                 262431             Date 01Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 AR322732           Date 23Jul12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CLE139             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 262581             Date 24Feb09               *
      *                 262328             Date 30Oct09               *
      *                 AR702741           Date 02Feb11               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG22218           Date 23Jan09               *
      *                 BUG21821           Date 02Dec08               *
      *                 256233A            Date 20Oct08               *
      *                 256233             Date 09Sep08               *
      *                 255240             Date 13Aug08               *
      *                 252789             Date 07Feb08               *
      *                 252039             Date 11Jan08               *
      *                 245719             Date 26Feb07               *
      *                 243048             Date 18Jul06               *
      *                 242751             Date 05Oct06               *
      *                 CLE055             Date 13Jul06               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG18527           Date 12May08               *
      *                 245273             Date 26Jan07               *
      *                 245411             Date 26Jan07               *
      *                 245177             Date 12Mar07               *
      *                 BUG13843           Date 02May07               *
      *                 CAS019             Date 24Mar07               *
      *                 245227             Date 27Feb07               *
      *                 241519             Date 05Sep06               *
      * Midas Plus 1.4 Base ----------- ------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK025             Date 29Aug06               *
      *                 241196             Date 17Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027A            Date 08May06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10391R          Date 17Feb06               *
      *                 BUG10671R          Date 07Mar06               *
      *                 BUG10574           Date 02Mar06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9173            Date 07Nov05               *
      *                 BUG9491            Date 05Dec05               *
      *                 BUG9225            Date 16Nov05               *
      *                 BUG8642            Date 26Sep05               *
      *                 BUG8464            Date 12Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE036             Date 22Sep03               *
      *                 CLE034             Date 05May03               *
      *                 CLE031             Date 03Feb03               *
      *                 BUG7870            Date 18Jun05               *
      *                 CAS011             Date 16May05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3971            Date 08Dec04               *
      *                 BUG3642            Date 20Sep04               *
      *                 CLE120             Date 09Aug04               *
      *                 BUG3721 (CLE028)   Date 09Aug04               *
      *                 BUG3760            Date 30Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CRE020             Date 20Jan04               *
      *                 TDA023             Date 22Mar04               *
      *                 225959             Date 23Mar04               *
      *                 225363             Date 01Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 01Dec03               *
      *                 CAP084             Date 11Oct02               *
      *                 CDE005             Date 23Sep02               *
      *                 CLE030             Date 29Aug02               *
      *                 CLE023             Date 08Aug02               *
      *                 CAP074  *CREATE    Date 05May02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD051922 - PDCL Y with same ccy settlement defaulted exchange*
      *             rate and divide indicator when enquired or amended*
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD040789 - LE1150P1 is not generated during authorization of *
      *             maturity amendment.                               *
      *  MD046370 - Component LERC135 is looping in COB. If loan      *
      *             maturity date is amended, updated of fee end date/*
      *             next payment date is done if system value         *
      *             'AutoEndCalcLoanFee' is 'Y' and if system value is*
      *             'N', no update should be done.  Applicable for all*
      *             calculated loan fees.                             *
      *  260408 - For non-sydicated loan, NOPS is not updated if      *
      *           attached part sold has processing type (PTYP) = 72. *
      *           This allows the main loan to be deleted even if the *
      *           part sold still exists. Amended program source to   *
      *           properly update NOPS.                               *
      *         - Applied for MD048145.                               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD041714 - Reversed PDCL Interest Loan has incorrect         *
      *             RECI in LEPDUEPD                                  *
      *  MD039449 - CLE164: Unable to change loan autosettle          *
      *             indicator from N to C                             *
      *  MD034363 - Reversal projected movements were generated during*
      *             Input Cycle, change value of RAMT to CPAM when    *
      *             RAMT value is less than CPAM.                     *
      *  MD045480 - Redefine RLOIC from numeric to character field.   *
      *  AR943686 - CLE031: System generating wrong projected move-   *
      *             ment. Populate value of SCCY to convert amount    *
      *             to account currency. (Child: AR943687)            *
      *           - Applied for MD-40690                              *
      *  CLE141 - Currency and Location Business Day Convention for   *
      *           Lending Transactions                                *
      *  MD034771 - Transactions sent via SOAP and MQ are still in    *
      *             Complete status even auto-auth is set to Y        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  MD030621 - Do not update facility exposure for PDCLs created *
      *             with decrease indicator 'Y'.                      *
      *  MD032052 - Database error occur when checking a one digit    *
      *             facility type on file.                            *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *  AR318769 - LE payments for new loan not generating during    *
      *             IC. Amended program to pass the correct parameter *
      *             to ZF2C.                                          *
      *           - Applied for MD025778                              *
      *  AR318769 - LE payments for new loan not generating during    *
      *             IC. Amended program to pass the correct parameter *
      *             to ZF2C.                                          *
      *           - Applied for MD025778                              *
      *  MD026167 - COB: PDP should not update online positions but   *
      *             GLOLPSPD is being updated by PDP transactions     *
      *             during COB                                        *
      *  MD025467 - API locking issue. Redesign approach.             *
      *  MD024342B - API issue. Trailer file allocation problem.      *
      *  MD024342 - LOAMSZ1 allocation problem                        *
      *  MD023203 - Condition PDCL creation access to Fee file        *
      *             Locking issues during PDCL creation               *
      *  MD022807I - Update of LEMQLGPD->LGSTAT to 'S' will now be    *
      *              done in Java layer                               *
      *  MD022807 - Several PDCLs that went to repair queue with no   *
      *             validation error.                                 *
      *  AR1093201 - MT202 not generated on insert of new loans.      *
      *              Write loans on insert or amend on LTRIX when     *
      *              CLE002 is ON but authorisation required is N on  *
      *              Lending ICD.  (Child: AR1093202)                 *
      *            - Applied for MD022492                             *
      *  MD020361A- Do not generate reversal shadow post on a changed *
      *             Pay Settlement account if loan status is Complete *
      *  MD020242 - No shadow posting is generated for Credit account *
      *             on amendment of Pay Settlement details.           *
      *  MD022114 - LEACCNPD differences after check cob 6            *
      *  MD021423 - Abnormally long run of PDCL/MAPY processing       *
      *             components                                        *
      *  MD020954 - Projected account movement of new PDCL is missing.*
      *             Amended the program to update CLOANE, used in the *
      *             re-run of LE0480.                                 *
      *  MD021554 - LEC06A 01001 failed due to FCOOB                  *
      *  MD021395 - Loan without loan number exists in CLOANCL file   *
      *  MD020960 - Projected account movement on amended PDCL is     *
      *             twice taken up.                                   *
      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
      *             calling program if file locking occurred on       *
      *             online position files. (Child: AR868381)          *
      *  MD019945 - System generate wrong projected movements after   *
      *             PDCL settlement account change. Generate projected*
      *             a/c movement for PDCL old and new settlement a/c  *
      *             only when there is an outstanding amounts.        *
      *  AR819476 - System did not generate the projected movements   *
      *             after changing PDCL loan's settlement account.    *
      *             Amend program to reverse the projected movement   *
      *             for the old account and generate the projected    *
      *             movement for the new account.  (Child: AR819484)  *
      *  MD020605 - CLE134 Impossible to create PDCL in IC            *
      *  MD020534 - System did not generate PDCL for the unpaid       *
      *             balance of interest after COB (Recompile)         *
      *  MD020318 - PDCL Reference number generated not updated to    *
      *             LEFEED.                                           *
      *  AR1052933 -  CLE055 - Customer account is not credited after *
      *               authorization. (Child: AR1052935)               *
      *  AR1091213 - Additional fixes needed for Recovery Processing  *
      *              of PDCL components                               *
      *  AR1079502 - Be able to reverse a PDCL created on line        *
      *  AR1085742 - Recovery handling when PDP components loop due   *
      *              to database connection issues                    *
      *  AR804863 - Details are not correctly reverted back when the  *
      *             amended transaction is rejected in WIP. Pass      *
      *             reject button to correctly revert back amended    *
      *             details. (Child: AR804864)                        *
      *           - Applied for AR910559 (Child: AR910560)            *
      *  262735A - No projected account movement shown for periodic   *
      *            fees (type 99). Unable to authorise loans. Amend   *
      *            fix 262735 on reading next record of LEFEEDL1 to   *
      *            avoid looping. (Reopened)                          *
      *  262735 - No projected account movement shown for periodic    *
      *           fees (type 99). Unable to authorise loans. No       *
      *           projection of fees when maturity date of loan was   *
      *           amended. Ensure that FEPEND and FENPYD are also     *
      *           updated when loan's maturity was amended for        *
      *           FECALT = 97, 98, or 99 or 90.                       *
      *  AR1022006 - COB Performance Optimisation                     *
      *  AR1021983 - Option C - Technical Enhancements Stated in POC  *
      *  AR574498 - Records for reversed loans remains in LEACCNPD.   *
      *             (Child: AR574499)                                 *
      *  AR545441 - API LE2030 API which fails to update LEACCNPD     *
      *             properly (Child: AR545442)                        *
      *  AR317473A - Wrong projected movements                        *
      *              (in addition to Defect 2018)                     *
      *             (Child: AR317474A)                                *
      *  AR314017 - LEC0459 failed in COB # 10 in BB                  *
      *             CLOAN (Child: AR314018)                           *
      *  AR217556 - Wrong PCN for Past Due Call Loan for Facility Fee *
      *             (Child: AR217745)                                 *
      *  263840 - Correct update of facility utilisation for PDCLs.   *
      *  262328 - Serious Midas error occurred. Increase size of WBIC *
      *           array from 150 to 900.                              *
      *  262431 - P2: CLE134 Serious Midas Error                      *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  AR322732 - LEC0212A and APISERVER locks LTRIX file.          *
      *           - Prevent LTRIX RRN 1 from being locked.            *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSF011A - CCR016: Settlement Allocation                      *
      *  CER049 - Stamp Tax                                           *
      *  CRE073 - Interest Rate Rounding                              *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate                                                *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  262581 - If maturity date changes then amend amortisation    *
      *           period on related fees.                             *
      *  262328 - Serious Midas error occurred. Increase size of WBIC *
      *           array from 150 to 900.                              *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus                                          *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  BUG22218 - Applied fix 255752A                               *
      *  255752A - Confirmation not produced if loan maturity date    *
      *           amended.                                            *
      *  BUG21821 - Editing loans causing serious midas error.        *
      *  256233A- Amend fix 256233 to ensure that no maturity posting *
      *           will be generated when maturity date is amended.    *
      *  256233 - do not generate maturity posting when maturity      *
      *           is amended with a future value.                     *
      *  256233 - missing posting on current account when maturity    *
      *           date is amended and when the loan was reversed.     *
      *           Reverse fix 255240.                                 *
      *  255240 - do not clear settlement details upon insert to      *
      *           generate projected CR entries. Reverse fix 243048.  *
      *           Projections are generated upon completion except    *
      *           for reversal transaction.                           *
      *  252789 - No projection should generate when amending the     *
      *           non-settlement details.                             *
      *  252039 - Additional condition for FIX 245719.                *
      *  245719 - Prevent the generation of a reversal entry if the   *
      *           non-setllement details is updated using Loan Input  *
      *           if CLE055 is ON.                                    *
      *  243048 - Projected CR entries not generated even after       *
      *           authorisation.                                      *
      *  242751 - Setup field RIUS on Insertion                       *
      *  CLE055 - Projected LE Movements                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG18527 - When a Loan is drawn against a facility, the      *
      *             updation is not happening online                  *
      *  245273 - Added parameter to LECLIPRTV call.                  *
      *  245411 - Update GPRT and TOLN if record is created by a      *
      *           Principal Transfer Transaction.                     *
      *  245177 - LEL0069 was incorrectly issued.                     *
      *  BUG13843 - Wrong OLNO reflected (Recompile)                  *
      *  CAS019 - Upgrade of CAS016 to Midas Plus                     *
      *  245227 - Availability of a facility should be affected up to *
      *           and including the expiry date of the facility.      *
      *  241519 - Clear Pay - Our Account if Pay Settlement Method    *
      *           equals 04 before updating CLOANCL.                  *
      *  CPK025 - MidasPlus 1.3 packaging.  SDYLDCPD layout changed   *
      *           and further Customer Number changes.                *
      *  241196 - Changes to Industry code, country of risk and       *
      *           profit centre are not applied to part sold          *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10391R - Funding Rate and Funding Spread Rate fields      *
      *              should be shown separately when CLE036 is *ON    *
      *              (Recompile)                                      *
      *  BUG10671R - Auto generated error on completion of agented    *
      *              loan. (Recompile)                                *
      *  BUG10574 - Recompiled due to changes in LECLI4PD.            *
      *  CLE042 - Extended Loan Sub Type                              *
      *  BUG9691- Include CAS011 changes in GZCLOANCL to align valids *
      *           file format.(Recompile)                             *
      *  BUG9173- Could not authorise loan coming from valid file     *
      *           updater.                                            *
      *  BUG9491 - BASR field should be under switchable feature      *
      *            CLE036.                                            *
      *  BUG9225 - Update LESTALPD with correct loan reference.       *
      *  BUG8642- Exposure for Internal Facility not reduced by Risk  *
      *           Participation Solds when its Sale of Loan is IPP    *
      *  BUG8464- Unable to Approve/Authorise Risk Parts Sold against *
      *           a Discounted Loan                                   *
      *  CLE106 - Syndications Manager                                *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2  *
      *           Allow specific base rates  (Recompile)              *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompile)                                         *
      *  CLE031 - Lending Enhancements                                *
      *  BUG7870 - Loan input error                                   *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3971- Reversal of loan with associated fee cause the      *
      *           program to loop.                                    *
      *  BUG3642- Branch is missing from the PC Reference on Loan     *
      *  CLE120 - Core changes for GBO020                             *
      *         - Debt Classification by Assets                       *
      *         - Upgrade to Midasplus                                *
      *           Core hooks added:LECLIPPD01,LECLIPPC01,LECLIPPF01   *
      *                            LECLIPPC02,LECLIPPC03,LECLIPPC04   *
      *  BUG3721 - Flat Rate Personal Loans (Rule of 78s) (CLE028)    *
      *  BUG3760 - Compliance Watch (CSD015) changes missing from the *
      *            Lending APIs.                                      *
      *  CLE025 - Credit Lines                                        *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  TDA023 - Increase Maturity Date Account to 18 Digits         *
      *           (Recompile)                                         *
      *  225959 - Missing CAS00x changes                              *
      *  225363 - Wrong branch written to the Facility Branch field   *
      *           FCLB on CLOANCL. Logged on Bugzilla as Bug 1254.    *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Apply 220754                                        *
      *  CAP084 - Midas Plus API development                          *
      *  CDE005   Reservation ID                                      *
      *  CLE030 - Release Authorisation processing                    *
      *  CLE023 - Lending Facility History Improvements.              *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *                                                               *
      *****************************************************************
      *
     FCLOAN     UF A E           K DISK    INFSR(SRERR)
     F                                     COMMIT
     F                                     IGNORE(CLOANHHF)
      *
     F***LTRIX**** UF   F   43        DISK    INFSR(SRERR)                                  AR322732
     FLTRIX     O  A F   45        DISK    INFSR(SRERR)                                     AR322732
     F                                     COMMIT
     F                                     INFDS(FLDTX)
      *
     FLEFCAML3  IF   E           K DISK
     F                                     RENAME(LEFCAMPF:LEFCAMD3)
      *
     FFCLTY     UF   E           K DISK    INFSR(SRERR)
     F                                     COMMIT
     F                                     IGNORE(FCLTYHHF)
     F                                     IGNORE(FCLTYZZF)
      *
     FSDBRCHL5  IF   E           K DISK    INFSR(SRERR)
      *
     FLEREF     UF A E           K DISK    INFSR(SRERR)
     F                                     COMMIT
      *
     FLEFELNL0  UF A E           K DISK    INFSR(SRERR)
     F                                     COMMIT
      *
     FLEFEEDL1  UF   E           K DISK    INFSR(SRERR)
     F                                     COMMIT
      *                                                                                     MD023203
     FLEFEEDL0  UF   E           K DISK    INFSR(SRERR)                                     MD023203
     F                                     COMMIT                                           MD023203
     F                                     RENAME(LEFEEDF:LEFEEDX)                          MD023203
     F                                     PREFIX(X_)                                       MD023203
      *
     FLELOAML3  UF   E           K DISK    INFSR(SRERR)
     F                                     COMMIT
     F                                     RENAME(LOAMSDKF:LELOAM3F)
      *
     FLERELEPD  UF A E           K DISK    INFSR(SRERR)
     F                                     COMMIT
     FSDCWHTL1  IF   E           K DISK    INFSR(SRERR)                                      BUG3760
      ** Compliance Watch Hit List                                                           BUG3760
                                                                                              CRE020
     FREADVCL1  UF   E           K DISK    INFSR(*PSSR)                                       CRE020
     F                                     USROPN                                             CRE020
     F                                     COMMIT                                             CRE020
      ** Midas RE Settled Transaction Index File by Ref No/Pgm Ref                            CRE020
      *
     FLESTALLA  UF   E           K DISK    COMMIT                                            BUG9225
     F                                     PREFIX(XX)                                        BUG9225
      ** Midas LE Settlement Allocation by Parent PC Reference                               BUG9225
     FLEEIRDL5  UF   E           K DISK    INFSR(SRERR)                                       CAS011
     F                                     COMMIT                                             CAS011
     F                                     RENAME(LEEIRDD0:LEEIRDD5)                          CAS011
      *                                                                                       241196
     FPSOLD     UF   E           K DISK    INFSR(SRERR)                                       241196
     F                                     COMMIT                                             241196
     F                                     RENAME(CLOANCLF:PSOLDF2)                           241196
     F                                     PREFIX(PS)                                         241196
                                                                                              CAS019
      ** Effective Interest Rate Details                                                      CAS019
     FLEEIRDL9  UF   E           K DISK    INFSR(*PSSR)                                       CAS019
     F                                     COMMIT                                             CAS019
     F                                     RENAME(LEEIRDD0:LEEIRDD9)                          CAS019
      ** Effective Interest Rate Details                                                      CAS019
     FLEERAPL0  UF   E           K DISK    INFSR(*PSSR)                                       CAS019
     F                                     COMMIT                                             CAS019
      ** Midas LE Fee Details                                                                 CAS019
     FLEFEEDLH  UF   E           K DISK    INFSR(*PSSR)                                       CAS019
     F***                                  COMMIT                                             CAS019
     F                                     RENAME(LEFEEDF:LEFEEDF2)                           CAS019
     F                                     USROPN                                           BUG21821
      ** Past Due & Original Loan Link                                                     AR1021983
     FLEPDUELB  UF   E           K DISK    INFSR(*PSSR)                                    AR1021983
     F                                     COMMIT                                          AR1021983
      ** Past Due & Original Fee Link                                                      AR1021983
     FLEPDUFLB  UF   E           K DISK    INFSR(*PSSR)                                    AR1021983
     F                                     COMMIT                                          AR1021983
     FLELSUTL0  UF A E           K DISK    INFSR(*PSSR)                                     MD020242
     F                                     COMMIT                                           MD020242
      ** Midas LE Loan Settlement Update Trace                                              MD020242
      *                                                                                       CAS019
      ** Retail Account                                                                       CLE134
                                                                                              CLE134
     FACCNTL1   IF   E           K DISK    INFSR(*PSSR) PREFIX(ac)                            CLE134
                                                                                              CLE134
      ** Repayment Priority                                                                   CLE134
                                                                                              CLE134
     F***LEACCNLA  UF A E           K DISK    INFSR(*PSSR)                             CLE134 CLE164
     F***                                  COMMIT                                      CLE134 CLE164
                                                                                              CLE134
      ** Account Postings Next Available Number file                                          CLE134
                                                                                              CLE134
     FGLAPNAPD  UF A E           K DISK    COMMIT                                             CLE134
                                                                                              CLE134
      ** Account Shadow Postings                                                              CLE134
                                                                                              CLE134
     F***RSACMTLX  IF   E           K DISK    PREFIX(sp)                               CLE134 CLE164
                                                                                              CLE134
      ** Copy of PDCL loans                                                                   CLE134
                                                                                              CLE134
     FLENEWLPD  O    E             DISK    COMMIT                                             CLE134
     F                                     RENAME(CLOANCLF:LENEWLD0)                          CLE134
                                                                                              CLE134
     FLEPDUEL1  IF   E           K DISK    INFSR(*PSSR)                                    AR317473A
     F                                     RENAME(LEPDUED0:LEPDUED1)                       AR1021983
                                                                                           AR317473A
     FACCNT     IF   E           K DISK    INFSR(*PSSR) PREFIX(QZ)                         AR317473A
     F                                     RENAME(ACCNTABF:ACCNTBF)                        AR317473A
                                                                                           AR317473A
      ** PDP Transaction Log File sent to MQ                                                  CLE134
     F***LEMQLGL0  UF   E           K DISK    INFSR(*PSSR)                          CLE134 MD022807I
     F**********                           COMMIT                                   CLE134 MD022807I
      ** Past Due & Original Loan Link                                                     AR1079502
     FLEPDUELC  UF   E           K DISK    INFSR(*PSSR)                                    AR1079502
     F                                     RENAME(LEPDUED0:LEPDUEDC)                       AR1079502
     F                                     COMMIT                                          AR1079502
     FCLOANC    IF   E           K DISK    INFSR(SRERR) PREFIX(TF)                          MD021554
     F                                     RENAME(CLOANCLF:CLOANCTF)                        MD021554
     F                                     IGNORE(CLOANHHF)                                 MD021554
     F                                     IGNORE(CLOANCKF)                                 MD021554
     F                                     IGNORE(CLOANZ1F)                                 MD021554
     FCLOANE    UF A E           K DISK    INFSR(*PSSR) PREFIX(PD)                          MD020954
     F                                     COMMIT                                           MD020954
     F                                     RENAME(CLOANCLF:LELWNELF)                        MD020954
     F                                     RENAME(CLOANCKF:LELWNEKF)                        MD020954
     F                                     RENAME(CLOANZ1F:LELWNEZF)                        MD020954
     F                                     IGNORE(CLOANHHF)                                 MD020954
     F***SDAPDRL0  IF   E           K DISK    INFSR(*PSSR)                         MD024342 MD025467
      **********                                                                   MD024342 MD025467
      ***Midas*SD API Driving File                                                 MD024342 MD025467
     F***CLOANZ1X  O    E             DISK    COMMIT                              MD024342B MD025467
     F**********                           RENAME(CLOANZ1F:CLOANZ1FX)             MD024342B MD025467
      ***API:*Midas LE LOANS TRAILER                                              MD024342B MD025467
      **********                                                                  MD024342B MD025467
     FLECLPZTD  O    E             DISK    COMMIT                                           MD025467
     F                                     RENAME(CLOANZ1F:CLOANZ1FX)                       MD025467
      ** API: Midas LE LOANS TRAILER (CLONE)                                                MD025467
      *                                                                                     MD025467
     FCLOANZI0  IF   E           K DISK                                                       CLE164
     F/COPY WNCPYSRC,LECLIPPF01
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
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
      *
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
      *
      **--------------------------------------------------------------------------------------------
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      *
     D TimeStamp       S               Z
      ***  Timestamp for the loan
      *
     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)
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
     D*WBIC*****       S              6  0 DIM(150)                                           CSD027
     D*WBIC*****       S              6A   DIM(150)                                    CSD027 262328
     D WBIC            S              6A   DIM(900)                                           262328
      ***  Branch internal customer array
      *
     D CYA             S              3    DIM(150)
      ***  Currencies array
      *
     D TND             S              1  0 DIM(150)
      ***  Telex Notice Days array
      *
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
      *
     D WNOST           S              2  0 DIM(5) CTDATA PERRCD(5)
      ***  Settlements through nostros

     D XOT             S             25A   DIM(Elements) PERRCD(1) CTDATA                    BUG3760
      ** XML Opening Tags for the Compliance Engine                                          BUG3760
                                                                                             BUG3760
     D XCT             S             25A   DIM(Elements) PERRCD(1) CTDATA                    BUG3760
      ** XML Closing Tags for the Compliance Engine                                          BUG3760
                                                                                             BUG3760
      *                                                                                       CER020
      ** Switchable feature CER020                                                            CER020
     D CER020          S              1A                                                      CER020
     D CRE073          S              1A                                                      CRE073
     D CLE141          S              1A                                                      CLE141

     D LEVCliL       E DS                  EXTNAME(LEVCLILPD)
     D                                     PREFIX(L_)
      ***  Externally desc'd DS for valid loan Details CL
     D LEVCliK       E DS                  EXTNAME(LEVCLIKPD)
     D                                     PREFIX(K_)
      ***  Externally desc'd DS for valid loan Details CL
     D TranInExt     E DS                  EXTNAME(LESTMP2PD)                                 CER049
      ***  Externally desc'd DS for screen Loans extension                                    CER049


     D LoanL         E DS                  EXTNAME(CLOANCL)
     D LoanK         E DS                  EXTNAME(CLOANCK)
     D                                     PREFIX(K_)

     D LoanC         E DS                  EXTNAME(CLOANCL)                                  BUG3760
     D                                     PREFIX(CH)                                        BUG3760

      ** Data Structure for MPHAS Dataarea                                                   CLE134
                                                                                             CLE134
     D MPHAS           DS             1                                                      CLE134
                                                                                             CLE134
     D FLDTX           DS
      ** Data Structure for LTRIX
      *
     D  TXSTS            *STATUS


     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  Data structure for bank details
     D SDLENO        E DS                  EXTNAME(SDLENOPD)
      ***  Loan number ranges file
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
      ***  Trading details
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ***  Customer lending ICD
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  Currency details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  Currency details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D QQACCD1       E                     EXTFLD(QQACCD)                                     CGL029
      ***  General Ledger details
                                                                                              CRE020
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRE020
     D  SCLCD        E                     EXTFLD(LCD)                                        CRE020
      ** Switchable Feature Details                                                           CRE020
                                                                                              CRE020
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D QQACCD2       E                     EXTFLD(QQACCD)                                     CGL029
      ***  Nostro details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                 BUG3760
     D QQDFAC2       E                     EXTFLD(QQDFAC)                                    BUG3760
      ***  Customer Details                                                                  BUG3760
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ***  Branch details
                                                                                              CLE134
     D SDFACT        E DS                  EXTNAME(SDFACTPD)                                  CLE134
                                                                                              CLE134
      ** External DS for facility type details.                                               CLE134
                                                                                              CLE134
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)                                  CLE134
                                                                                              CLE134
      ** External DS for loans type details.                                                  CLE134
                                                                                              CLE134
     D SDFEE         E DS                  EXTNAME(SDFEEPD)                                   CLE134
                                                                                              CLE134
      ** External DS for Fee Details                                                          CLE134
                                                                                              CLE134
     D APHEAD        E DS                  EXTNAME(APHEADPD)
      ***  Midas API Message Header Format Definition
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  Second DS for access programs, long data structure

     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                 BUG3760
      ** Midas Functions for Watch List Checking Details File                                BUG3760
      *                                                                                      BUG3760
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                 BUG3760
      ** Midas SD Watch List Configuration Data File                                         BUG3760
      *                                                                                      BUG3760
     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)                                 BUG3760
      ** Watch List Transaction details file                                                 BUG3760
      *                                                                                      BUG3760
     D PFreeFmtStr     S          30000A                                                     BUG3760
      ** Compliance Engine Free Format String Parameter                                      BUG3760
                                                                                             BUG3760
     D Elements        C                   CONST(13)                                         BUG3760
      ** Array Size Definition                                                               BUG3760
                                                                                             BUG3760
     D WLF             S             18A   DIM(Elements)                                     BUG3760
      ** Watch List Fields Array.                                                            BUG3760

     D Z#BSTS        E DS                  EXTNAME(Z#BST)
      ***  before image of update to LE position files
     D Z#ASTS        E DS                  EXTNAME(Z#AST)
      ***  after image of update to LE position files
     D Z#WSTS        E DS                  EXTNAME(Z#WST)
      ***  before image of update to LE position files                                        CLE055
     D Z#ZBSTS       E DS                  EXTNAME(CLOANCL)                                   CLE055
     D                                     PREFIX(ZB_)                                        CLE055
      ***  after image of update to LE position files                                         CLE055
     D Z#ZASTS       E DS                  EXTNAME(CLOANCL)                                   CLE055
     D                                     PREFIX(ZA_)                                        CLE055
      ***  work file of update to LE position files
     D SDHEDG        E DS                  EXTNAME(SDHEDGPD)                                  CAS011
      ***  External data structure for Midas Hedging ICD file                                 CAS011
                                                                                              CAS011
     D*SDYLDC*       E DS            42    EXTNAME(SDYLDCPD)                           CAS011 CPK025
     D SDYLDC        E DS            91    EXTNAME(SDYLDCPD)                                  CPK025
     D  FYLDC        E                     EXTFLD(FSYLDC)                                     CAS011
     D  FCHTP        E                     EXTFLD(FSCHTP)                                     CAS011
      ***  Dummy record format for access to Yield Curve files                                CAS011
                                                                                              CAS011
     D Z#ASTK          DS          2048                                                       222373
     D Z#BSTK          DS          2048                                                       222373

     D Z#BSTF        E DS                  EXTNAME(Z#BST)                                     262735
     D                                     PREFIX(FB_)                                        262735
     D Z#ASTF        E DS                  EXTNAME(Z#AST)                                     262735
     D                                     PREFIX(FA_)                                        262735
     D Z#WSTF        E DS                  EXTNAME(Z#WST)                                     262735
     D                                     PREFIX(FW_)                                        262735
      *                                                                                       262735
      ** Fee in file format                                                                   262735
      *                                                                                       262735
     DCrFeFilFmt     E DS                  EXTNAME(LEFEEDL1)                                  262735
     D                                     PREFIX(F_)                                         262735

     D SC24X7        E DS                  EXTNAME(SC24X7)
      ***  24X7 Data Structure

     D SDSTAT        E DS                  EXTNAME(SDSTAT)
      ***  SDSTAT Data Structure

     D LELWNE        E DS                  EXTNAME(LELWNEPD)                                MD020954
     D                                     PREFIX(PD)                                       MD020954
      ** New PDCL record on CLOANCL (COB)                                                   MD020954
      *                                                                                     MD020954
     D LELWNK        E DS                  EXTNAME(LELWNEPK)                                MD020954
     D                                     PREFIX(PD)                                       MD020954
     D PKRECI        E                     EXTFLD(RECI)                                     MD020954
     D PKLNRF        E                     EXTFLD(LNRF)                                     MD020954
     D PKRCDT        E                     EXTFLD(RCDT)                                     MD020954
     D PKMRIN        E                     EXTFLD(MRIN)                                     MD020954
     D PKORED        E                     EXTFLD(ORED)                                     MD020954
     D PKLCD         E                     EXTFLD(LCD )                                     MD020954
     D PKCHTP        E                     EXTFLD(CHTP)                                     MD020954
     D PKTNLU        E                     EXTFLD(TNLU)                                     MD020954
     D PKFRNT        E                     EXTFLD(FRNT)                                     MD020954
     D PKAFRT        E                     EXTFLD(AFRT)                                     MD020954
     D PKREPA        E                     EXTFLD(REPA)                                     MD020954
     D PKTMST        E                     EXTFLD(TMST)                                     MD020954
      ** New PDCL record on CLOANCK (COB)                                                   MD020954
      *                                                                                     MD020954
     D LEALLO        E DS                  EXTNAME(LEALLO)
      ***  DS for calculating PC reference
      *
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
      ***  Dummy message ID and message file fields for use on the calls to
      ***  ZAMSGTOOPR
      *
     D TRANSDTL        S           5800A

     D                 DS
      ***  Data structure of key list used in chaining to FCLTY
     D  FCTREC                 1     12
     D**WFCNUM**               1      6  0                                                    CSD027
     D  WFCNUM                 1      6A                                                      CSD027
     D  WFFACT                 7      9  0
     D  WFFCNO                10     11  0
     D  WFRCTP                12     12

     D                 DS
      ***  Data structure of key list used in chaining to LEREF
     D  LERFKY                 1     17
     D**WCNUM***               1      6  0                                                    CSD027
     D  WCNUM                  1      6A                                                      CSD027
     D  WFACT                  7      9  0
     D  WFCNO                 10     11  0
     D**WLNRF***              12     17  0                                                    CLE148
     D  WLNRF                 12     17                                                       CLE148

     D                 DS
      ***  Data structure for ZDAT10
     D  ZZDTIN                 1      8  0
     D  ZWYYYY                 1      4  0
     D  ZWCC                   1      2  0
     D  ZWMTH                  5      6  0
     D  ZWDAY                  7      8  0


     D***PrvLOAN        DS           200                                                      CGL029
     D  PrvLOAN        DS                                                                     CGL029
      ***  Fields used in setting confirmation indicators (old record)
     D  Prv_MDAT               1      5  0
     D  Prv_NIDT               6     10  0
     D  Prv_NRPD              11     15  0
     D  Prv_IFDY              16     17  0
     D  Prv_IPFR              18     18
     D  Prv_RDYN              19     20  0
     D  Prv_RFRQ              21     21
     D  Prv_RAMT              22     34  0
     D  Prv_LNDTLS             1     34

     D  Prv_SDST              35     36  0
     D***Prv_OSDA              37     48                                                      CGL029
     D  QQOSD1                37     48                                                       CGL029
     D  Prv_TSTN              49     58
     D  Prv_FACO              59     68
     D  Prv_SPI1              69     98
     D  Prv_SPI2              99    128
     D  Prv_SPI3             129    158
     D  Prv_SPI               69    158
     D  Prv_STRINS            35    158

     D  Prv_MDST             159    160  0
     D***Prv_OMDA             161    172                                                      CGL029
     D  QQOMD1               161    172                                                       CGL029
     D  Prv_TMAN             173    182
     D  Prv_MATINS           159    182
                                                                                              CGL029
     D  Prv_OSDA             202    219                                                       CGL029
     D  Prv_OMDA             220    237                                                       CGL029
                                                                                             BUG3721
     D  Prv_ADIF             238    238                                                      BUG3721
     D  Prv_ADCF             239    239                                                      BUG3721
     D  Prv_ICIF             240    240                                                      BUG3721
     D  Prv_CHGA             241    253  0                                                   BUG3721
     D  Prv_FLTI             254    266  0                                                   BUG3721
     D  Prv_FRPD             267    271  0                                                   BUG3721
     D  Prv_LNDTLS2          238    271                                                      BUG3721
     D  Prv_FCRA             272    284  0                                                    CAS011
     D**Prv_LNRF             285    290  0                                             CAS011 CLE148
     D  Prv_LNRF             285    290                                                       CLE148
     D  Prv_AUTO             291    291                                                       252789
     D  Prv_OCDT             292    296  0                                                    CLE143
     D  Prv_EAIR             297    311  8                                                    CLE143

     D***Prv_FAMU            291    291                                                CLE134 CLE164
     D***Prv_RIDT            292    296  0                                             CLE134 CLE164
     D***Prv_RCAT            297    297  0                                             CLE134 CLE164
     D***Prv_BIDT            298    302  0                                             CLE134 CLE164
     D***Prv_BCAT            303    303  0                                             CLE134 CLE164
     D  Prv_FAMU             312    312                                                       CLE164
     D  Prv_RIDT             313    317  0                                                    CLE164
     D  Prv_RCAT             318    318  0                                                    CLE164
     D  Prv_BIDT             319    323  0                                                    CLE164
     D  Prv_BCAT             324    324  0                                                    CLE164

     D***NewLOAN        DS           200                                                      CGL029
     D  NewLOAN        DS                                                                     CGL029
      ***  Fields used in setting confirmation indicators (old record)
     D  New_MDAT               1      5  0
     D  New_NIDT               6     10  0
     D  New_NRPD              11     15  0
     D  New_IFDY              16     17  0
     D  New_IPFR              18     18
     D  New_RDYN              19     20  0
     D  New_RFRQ              21     21
     D  New_RAMT              22     34  0
     D  New_LNDTLS             1     34

     D  New_SDST              35     36  0
     D***New_OSDA              37     48                                                      CGL029
     D  QQOSD2                37     48                                                       CGL029
     D  New_TSTN              49     58
     D  New_FACO              59     68
     D  New_SPI1              69     98
     D  New_SPI2              99    128
     D  New_SPI3             129    158
     D  New_SPI               69    158
     D  New_STRINS            35    158

     D  New_MDST             159    160  0
     D***New_OMDA             161    172                                                      CGL029
     D  QQOMD2               161    172                                                       CGL029
     D  New_TMAN             173    182
     D  New_MATINS           159    182
                                                                                              CGL029
     D  New_OSDA             202    219                                                       CGL029
     D  New_OMDA             220    237                                                       CGL029
                                                                                             BUG3721
     D  New_ADIF             238    238                                                      BUG3721
     D  New_ADCF             239    239                                                      BUG3721
     D  New_ICIF             240    240                                                      BUG3721
     D  New_CHGA             241    253  0                                                   BUG3721
     D  New_FLTI             254    266  0                                                   BUG3721
     D  New_FRPD             267    271  0                                                   BUG3721
     D  New_LNDTLS2          238    271                                                      BUG3721
     D  New_PTYP             272    273  0                                                    CAS011
     D  New_VDAT             274    278  0                                                    CAS011
     D  New_FCRA             279    291  0                                                    CAS011
     D**New_OLNO*****        292    297  0                                              CAS011CSD027
     D  New_OLNO             292    297                                                       CSD027
     D  New_CHTP             298    298                                                       CAS011
     D  New_AUTO             299    299                                                       252789
     D  New_OCDT             300    304  0                                                    CLE143
     D  New_EAIR             305    319  8                                                    CLE143

     D***New_FAMU            299    299                                                CLE134 CLE164
     D***New_RIDT            300    304  0                                             CLE134 CLE164
     D***New_RCAT            305    305  0                                             CLE134 CLE164
     D***New_BIDT            306    310  0                                             CLE134 CLE164
     D***New_BCAT            311    311  0                                             CLE134 CLE164
     D  New_FAMU             320    320                                                       CLE164
     D  New_RIDT             321    325  0                                                    CLE164
     D  New_RCAT             326    326  0                                                    CLE164
     D  New_BIDT             327    331  0                                                    CLE164
     D  New_BCAT             332    332  0                                                    CLE164

      ** Break up timestamp field to get RETIME for Release Authorisation Report
     D  L_CLTMST       DS            26
     D  WREHRS                12     13
     D  WREMIN                15     16
     D  WRESEC                18     19
      *                                                                                     AR322732
      ** Data structure to define LTRIX fields                                              AR322732
      *                                                                                     AR322732
     D CNRQD           S              1                                                     AR322732
     D PRI1D           S              1S 0                                                  AR322732
     D PRI2D           S              1S 0                                                  AR322732
     D PRI3D           S              1S 0                                                  AR322732
     D PRI4D           S              1S 0                                                  AR322732
     D RRNTD           S              5P 0                                                  AR322732
     D VDATD           S              5S 0                                                  AR322732
      *

      ** Fields redefined by CGL029                                                           CGL029
     D PACCD           S             10A                                                      CGL029
     D PDEALNO         S             24A                                                      CGL029
     D PADEALNO        S             24A                                                      CGL029
     D T#TREF          S             26A                                                      CGL029
                                                                                              CGL029
      ** CRE020 Variables                                                                     CRE020
     D PSARD           S              6A                                                      CRE020
     D CRE020          S              1A                                                      CRE020
     D KRefNo          S             30A                                                      CRE020
     D KPrgMn          S             10A   INZ('LECLIPUPD ')                                  CRE020
     D PSysVal01       S             20A   INZ('LoansPartPrchPartSld')                        CRE020
     D PCurSet01       S            200A                                                      CRE020
     D PSysVal02       S             20A                                                      CRE020
     D PCurSet02       S            200A                                                      CRE020
     D PSysVal03       S             20A                                                      CRE020
     D PCurSet03       S            200A                                                      CRE020
     D PSysVal04       S             20A                                                      CRE020
     D PCurSet04       S            200A                                                      CRE020
     D PSysVal05       S             20A                                                      CRE020
     D PCurSet05       S            200A                                                      CRE020
     D PSysVal06       S             20A                                                      CRE020
     D PCurSet06       S            200A                                                      CRE020
     D PSysVal07       S             20A                                                      CRE020
     D PCurSet07       S            200A                                                      CRE020
     D PSysVal08       S             20A                                                      CRE020
     D PCurSet08       S            200A                                                      CRE020
     D PSysVal09       S             20A                                                      CRE020
     D PCurSet09       S            200A                                                      CRE020
     D PSysVal10       S             20A                                                      CRE020
     D PCurSet10       S            200A                                                      CRE020
     D WSysVal01       S              1A                                                      CRE020
     D WNew            S              1A                                                      CRE020
                                                                                              CLE025
     D*CLE025***       S              1                                              CLE025 BUG18527
     D CLE024          S              1                                                     BUG18527
      *                                                                                       CAS011
     D*WTRAN****       S              6  0                                             CAS011 CLE148
     D WTRAN           S              6                                                       CLE148
     D WVALD           S              5  0                                                    CAS011
     D WADJP           S              1                                                       CAS011
     D WDELR           S              1                                                       CAS011
     D WIFDY           S              2S 0                                                    CAS011
     D WRDYN           S              2S 0                                                    CAS011
     D SVIN81          S              1                                                       CAS011
     D CLE031          S              1                                                       CLE031
     D CLE106          S              1                                                       CLE106
     D CLE036          S              1                                                      BUG9491
                                                                                              CLE134
     D CLE134          S              1                                                       CLE134
     D DSLoop          S              9  0 INZ                                                CLE134
     D***DSCNUM       S                   INZ LIKE(RPCNUM)                             CLE134 CLE164
     D***DSACOD       S                   INZ LIKE(RPACOD)                             CLE134 CLE164
     D***DSACSQ       S                   INZ LIKE(RPACSQ)                             CLE134 CLE164
     D***DSBRCA       S                   INZ LIKE(RPBRCA)                             CLE134 CLE164
     D***DSACCY       S                   INZ LIKE(RPACCY)                             CLE134 CLE164
                                                                                              CLE134
     D #A              S              9  0 INZ                                                CLE134
                                                                                              CLE134
     D DSBCN           S              3  0 INZ DIM(9)                                         CLE134
     D DSBCE           S              3  0 INZ DIM(9)                                         CLE134
                                                                                              CLE134
     D DSRCN           S              3  0 INZ DIM(9)                                         CLE134
     D DSRCE           S              3  0 INZ DIM(9)                                         CLE134
                                                                                              CLE134
     D KacACNO         S                   INZ LIKE(acACNO)                                   CLE134
     D KGLNARI         S                   INZ LIKE(GLNARI)                                   CLE134
                                                                                              CLE134
     D***KRPLNRF      S                   INZ LIKE(RPLNRF)                             CLE134 CLE164
                                                                                              CLE134
     D***KspXRFI      S                   INZ LIKE(spXRFI)                             CLE134 CLE164
     D***KspXRFN      S                   INZ LIKE(spXRFN)                             CLE134 CLE164
                                                                                              CRE020
     D OVRDBF          C                   'OVRDBF FILE(LEFEEDLH)-                          BUG21821
     D                                       TOFILE(LEFEEDLH) SHARE(*NO)'                   BUG21821
     D CAS016          S              1    INZ('N')                                           CAS019
     D CAS009          S              1    INZ('N')                                           CAS011
     D CSD015          S              1    INZ('N')                                          BUG3760
     D CCF001          S              1    INZ('N')                                          BUG3760
     D CAP086          S              1A   INZ('N')                                           CAP086
     D CLE055          S              1    INZ('N')                                           CLE055
     D WFuncType       S              8                                                      BUG3760
     D WIdntifier      S             40                                                      BUG3760
     D WBranch         S              3                                                      BUG3760
     D WLChgFlg        S              1    INZ('N')                                          BUG3760
     D WLOkFlg         S              1    INZ('N')                                          BUG3760
     D WXMLPacket      S            310                                                      BUG3760
     D WData           S            216                                                      BUG3760
     D Ctr             S              2P 0                                                   BUG3760
     D PRetCode        S              7                                                      BUG3760
     D POption         S              7                                                      BUG3760
     D PFunc           S              8                                                      BUG3760
     D PCust           S             10                                                      BUG3760
     D PStKey          S              7                                                      BUG3760
     D PFmtCCY         S              3                                                      BUG3760
     D PDummy6         S              6                                                      BUG3760
     D PDummy16        S             16                                                      BUG3760
     D PDummy35        S             35                                                      BUG3760
     D PZARtCd         S              7                                                      BUG3760
     D PZADayNo        S              5                                                      BUG3760
     D PZADDT          S               D                                                     BUG3760
     D PZACvtDt        S             10                                                      BUG3760
     D WDDT            S               D                                                     BUG3760
     D WDtlOPay        S              1                                                      BUG3760
     D WPtyp           S              2A                                                     BUG3760
     D W#FRNT          S              8A                                                   AR1021983
      *                                                                                       241519
     D PONS_TEMP       S             18A   INZ(*BLANKS)                                       241519
     D XCtr            S              3P 0                                                  MD022807
      *                                                                                     AR318769
     D FWRDYS          S              2S 0                                                  AR318769
     D ZNRDYS          S              2P 0                                                  AR318769
      *                                                                                     AR318769
     D/COPY WNCPYSRC,LECLIPPD01
                                                                                              CLE164
      ** +--------------------------------------+                                             CLE164
      ** ¦ Program Prototypes                   ¦                                             CLE164
      ** ¦ ==================                   ¦                                             CLE164
      ** +--------------------------------------+                                             CLE164
     D UPDATE_MATRIX   PR                  Extpgm('LE000506')                                 CLE164
     D    pRetCode                    7A                                                      CLE164
     D    pAction                     8A                                                      CLE164
     D    pFile                      10A                                                      CLE164
     D    pLoanRef                    6A                                                      CLE164
     D    pBranch                     3A                                                      CLE164
     D    pCustomer                   6A                                                      CLE164
     D    pFeeFclty                   5S 0                                                    CLE164
     D    pFeeLoan                    6A                                                      CLE164
     D    pFeeSeqn                    2S 0                                                    CLE164
     D    pLSPDPGrpID                 3A                                                      CLE164
     D    pFTPDPGrpID                 3A                                                      CLE164
     D    pFCPDPGrpID                 3A                                                      CLE164
     D    pCategory                   5A                                                      CLE164
                                                                                              CLE164
      ** Variable declaration                                                                 CLE164
     D  Loan_Prefix    S              1A   INZ(*ZEROS)                                        CLE164
     D  wRetCode       S              7A                                                      CLE164
     D  wAction        S              8A                                                      CLE164
     D  wFile          S             10A                                                      CLE164
     D  wCustomer      S              6A   INZ(*BLANKS)                                       CLE164
     D  wFeeFclty      S              5S 0 INZ(*ZEROS)                                        CLE164
     D  wFeeLoan       S              6A   INZ(*BLANKS)                                       CLE164
     D  wFeeSeqn       S              2S 0 INZ(*ZEROS)                                        CLE164
     D  wCategory      S              5A   INZ(*BLANKS)                                       CLE164
                                                                                              CLE164
     D  aCAT           S              5A   DIM(4)                                             CLE164
     D  aORIGLN        S              5A   DIM(4)                                             CLE164
     D  aPDCL_X        S              5A   DIM(4)                                             CLE164
     D  aPDCL_Y        S              5A   DIM(4)                                             CLE164
     D  aPDCL_Z        S              5A   DIM(4)                                             CLE164
                                                                                              CLE164
     D  Index          S              2S 0 INZ(*ZEROS)                                        CLE164
     D  MAX_CATEGORY   S              2S 0 INZ(*ZEROS)                                        CLE164
     D  CUR_AUTO       S              1A   INZ(*BLANKS)                                       CLE164
     D  wLoanRef       S              6A   INZ(*BLANKS)                                       CLE164
     D  wLSPDPGrpID    S              3A   INZ(*BLANKS)                                       CLE164
     D  wFTPDPGrpID    S              3A   INZ(*BLANKS)                                       CLE164
     D  wFCPDPGrpID    S              3A   INZ(*BLANKS)                                       CLE164
     D  wLREF          S              6A                                                      CLE164
                                                                                             BUG3760
      *  =============
      ** Rename fields
      *  =============

     ICLOANCKF
     I              NLRA                        NLRAK
     I              ORED                        OREDK
      *
     ICLOANCLF
     I              PCOB                        PCOBL
     I              PCRF                        PCRFL
      ** Rename filler to serve as confirmation flag.                                        255752A
      *                                                                                      255752A
     I              ZZ001A                      CONF                                         255752A
      *                                                                                      255752A
     ICLOANZ1F
     I              LNRF                        Z1LNRF
      *
     I*LTRIX**** NS        1 CH                                                             AR322732
      *****Transaction*index*header************************************                     AR322732
      *
     I**********                        1    1  RECID                                       AR322732
     I**********                        2    2  RCDTD                                       AR322732
     I**********                        3    8 0LNRFD                                       AR322732
     I**********                   P    9   11 0NORED                                       AR322732
     I**********                   P   12   14 0FLSZD                                       AR322732
     I**********                   P   15   17 0RRLCD                                       AR322732
     I**********                   P   18   20 0RRNAD                                       AR322732
     I**********                   P   21   23 0RRLXD                                       AR322732
     I**********                   P   24   26 0RRXPD                                       AR322732
     I**********                   P   27   29 0NLNRD                                       AR322732
     I**********                   P   30   32 0NLARD                                       AR322732
     I**********                       33   33 0STPID                                       AR322732
     I**********                   P   38   40 0TNLUD                                       AR322732
      *
     I**********NS        1 CD                                                              AR322732
      *****Transaction*index*detail************************************                     AR322732
      *
     I**********                        1    1  RECID                                       AR322732
     I**********                        2    2  RCDTD                                       AR322732
     I**********                        3    8 0LNRFD                                       AR322732
     I**********                        9   13 0VDATD                                       AR322732
     I**********                       14   16 0LASND                                       AR322732
     I**********                       17   17  CHTPD                                       AR322732
     I**********                       18   18  CNRQD                                       AR322732
     I**********                       19   19  CNPRD                                       AR322732
     I**********                       20   20  REPRD                                       AR322732
     I**********                       21   25 0RRLAD                                       AR322732
     I**********                       26   26  LADID                                       AR322732
     I**********                       27   27 0PRI1D                                       AR322732
     I**********                       32   34  BRCAD                                       AR322732
     I**********                   P   35   37 0RRNTD                                       AR322732
     I**********                   P   38   40 0TNLUD                                       AR322732
     I**********                       41   41 0PRI2D                                       AR322732
     I**********                       42   42 0PRI3D                                       AR322732
     I**********                       43   43 0PRI4D                                       AR322732
      *
     I**********NS                                                                          AR322732
      *****Catch*all***************************************************                     AR322732
     I**********                        1    1  RECID                                       AR322732
      *
     ILEFCAMD3
      ** Rename fields
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
      ** Rename fields
     I              RECI                        RECIF
     I              CNUM                        CNUMF
     I              CALC                        CALCF
     I              ORED                        OREDF
     I              TNLU                        TNLUF
      *
     ILELOAM3F
     I** Rename fields
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
      *
     ILELWNEZF                                                                              MD020954
     I              NLRA                        PZNLRA                                      MD020954
     I              TNLU                        PZTNLU                                      MD020954
      /EJECT
      *****************************************************************
      * MAIN - Main body                                              *
      *****************************************************************

      ** Check whether user is a web browser user, if so overwrite              CAP084
     C                   CALL      'SFC000026'                                  CAP084
     C                   PARM      *BLANKS       USER             10            CAP084
      *                                                                         CAP084
     C                   IF        USER <> *BLANKS                              CAP084
     C                   EVAL      PSUSER = USER                                CAP084
     C                   ENDIF                                                  CAP084

      * Determine Loan type

     C                   EXSR      DET_LOANTYPE
      *
      ***  Ensure the loan has not been updated by another workstation
      ***  - if so, bypass updating and return to calling program.
      *
     C     CLE134        IFEQ      'Y'                                                        CLE134
     C*****MPHAS         ANDEQ     'A'                                               CLE134 MD025467
     C     MPHAS         ANDNE     'C'                                                      MD025467
     C     CLE134        OREQ      'N'                                                      MD025467
     C     MPHAS         ANDNE     'C'                                                      MD025467
     C                   EXSR      CHKOTHUPD
     C                   ENDIF                                                                CLE134
      *
     C                   IF        @@RTCD <> *BLANKS
     C                   GOTO      EXIT
     C                   ENDIF

      *** Access related loan (if a partication sold)

     C                   Z-ADD     *ZERO         PTYP_M
     C     *IN83         IFEQ      '1'
     C                   EXSR      ACSREL
     C                   ENDIF

      * Access Loan Currency details

     C                   MOVEL     L_CLCCY       @CYCD
     C                   EXSR      ACS_CURR
     C                   Z-ADD     A6TXND        LoanCyTXND        2 0
     C                   Z-ADD     A6NBDP        LoanCyNBDP        1 0
      *
      ***  Get last transaction number
      *
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANK        P@RTCD           10
     C                   PARM                    NATN              5 0
      *
      ***  Get Timestamp
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      *
     C                   IF        L_CLPSTM = 04                                              241519
     C                   EVAL      PONS_TEMP = L_CLPONS                                       241519
     C                   MOVE      *BLANKS       L_CLPONS                                     241519
     C                   ENDIF                                                                241519
      *                                                                                       241519
      ***  Insert, Amend, authorise or reverse the loan
      *
     C                   SELECT
     C     L_CLCHTP      WHENEQ    'I'
     C                   EXSR      INSERT
     C     L_CLCHTP      WHENEQ    'A'
     C                   EXSR      AMEND
     C     L_CLCHTP      WHENEQ    'X'
     C     L_CLCHTP      OREQ      'Q'
     C                   EXSR      AUTHOR
     C     L_CLCHTP      WHENEQ    'R'
     C                   EXSR      REVERSE
     C                   ENDSL
      *
     C                   IF        L_CLPSTM = 04                                              241519
     C                   EVAL      L_CLPONS = PONS_TEMP                                       241519
     C                   ENDIF                                                                241519
      *                                                                                       241519
      ***  If CLE009 is installed, update Fees file
      *
     C     CLE009        IFEQ      'Y'
     C                   EXSR      SRFEES
     C                   ENDIF
      *
      ***  If Support System active, update 24X7 Log
      *
     C**********         IN        SDSTAT                                                    BUG3760
     C**********         IN        SC24X7                                                    BUG3760
     C     CSC011        IFEQ      'Y'
     C     S1SUPP        ANDEQ     LIBR
     C                   EXSR      UPD24X7LOG
     C                   ENDIF
      *
      ***  Update shadow files
      *
     C     L_CLCHTP      IFEQ      'I'
     C     L_CLCHTP      OREQ      'A'
     C     L_CLCHTP      OREQ      'R'
     C*****L_CLCHTP      OREQ      'X'                                                 243048 255240
     C*****CLE055        ANDEQ     'Y'                                                 243048 255240
     C*****L_CLCHTP      OREQ      'Q'                                                 243048 255240
     C*****CLE055        ANDEQ     'Y'                                                 243048 255240
     C     L_CLCHTP      OREQ      'X'                                                        256233
     C     CLE055        ANDEQ     'Y'                                                        256233
     C     L_CLCHTP      OREQ      'Q'                                                        256233
     C     CLE055        ANDEQ     'Y'                                                        256233
     C*****CLE134        IFEQ      'N'                                               CLE134 MD025467
     C*****CLE134        OREQ      'Y'                                               CLE134 MD025467
     C*****MPHAS         ANDEQ     'A'                                               CLE134 MD025467
     C     MPHAS         IFNE      'C'                                                      MD025467
     C/COPY WNCPYSRC,LEH01179
     C                   EXSR      SRSHDW
     C                   ENDIF                                                                CLE134
     C                   ENDIF
                                                                                              CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   SELECT                                                               CRE020
     C                   WHEN      L_CLCHTP = 'X' OR                                          CRE020
     C                             L_CLCHTP = 'R'                                             CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   WHEN      L_CLCHTP = 'A'                                             CRE020
     C                   EXSR      SRIdxAmd                                                   CRE020
                                                                                              CRE020
     C                   IF        BPLOAU = 'N'                                               CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   WHEN      L_CLCHTP = 'I'                                             CRE020
     C                   IF        BPLOAU = 'N'                                               CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDSL                                                                CRE020
     C                   ENDIF                                                                CRE020
      *
      ***  Data export for CCRM - Limits
      *
     C     CDE001        IFEQ      'Y'
     C                   MOVEL     L_CLLNRF      T#TREF
     C                   CALL      'DEWTTRIG'
     C**********         PARM                    T#TREF           20                          CGL029
     C                   PARM                    T#TREF                                       CGL029
     C                   PARM      'LOAN'        T#TCAT            4
     C                   PARM                    ReservId                                     CDE005
     C                   ENDIF
      *
      ***  Exit From Program
      *
     C     EXIT          TAG
      *
     C                   RETURN
      ****************************************************************
      /EJECT
      *****************************************************************
      * DET_LOANTYPE - Determine Loan Type                            *
      *****************************************************************
     C     DET_LOANTYPE  BEGSR

     C                   SELECT
     C     L_CLPTYP      WHENEQ    61
     C     L_CLPTYP      OREQ      62
     C     L_CLPTYP      OREQ      63
     C     L_CLPTYP      OREQ      70
     C     L_CLPTYP      OREQ      80                                                        BUG3721
     C                   MOVEL     'LOAN'        LoanType
     C     L_CLPTYP      WHENEQ    64
     C     L_CLPTYP      OREQ      65
     C     L_CLPTYP      OREQ      68
     C     L_CLPTYP      OREQ      71
     C                   MOVEL     'PTPU'        LoanType
     C     L_CLPTYP      WHENEQ    66
     C     L_CLPTYP      OREQ      67
     C     L_CLPTYP      OREQ      69
     C     L_CLPTYP      OREQ      72
     C                   MOVEL     'PTSO'        LoanType          4
     C                   ENDSL

     C                   MOVE      '0'           *IN82
     C                   MOVE      '0'           *IN83

     C                   SELECT
     C     LoanType      WHENEQ    'PTPU'
     C                   MOVE      '1'           *IN82
     C     LoanType      WHENEQ    'PTSO'
     C                   MOVE      '1'           *IN83
     C***********        SELECT                                                              BUG8464
     C*****L_CLPTYP      WHENEQ    62                                                        BUG8464
     C*****L_CLPTYP      OREQ      64                                                        BUG8464
     C***********        MOVE      '66'          W72TP             2                         BUG8464
     C*****L_CLPTYP      WHENEQ    61                                                        BUG8464
     C*****L_CLPTYP      OREQ      68                                                        BUG8464
     C***********        MOVE      '69'          W72TP                                       BUG8464
     C*****L_CLPTYP      WHENEQ    63                                                        BUG8464
     C*****L_CLPTYP      OREQ      65                                                        BUG8464
     C***********        MOVE      '67'          W72TP                                       BUG8464
     C*****L_CLPTYP      WHENEQ    70                                                        BUG8464
     C*****L_CLPTYP      OREQ      71                                                        BUG8464
     C***********        MOVE      '70'          W72TP                                       BUG8464
     C***********        ENDSL                                                               BUG8464
     C                   ENDSL

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CHKOTHUPD - Check for update by another workstation           *
      *****************************************************************
     C     CHKOTHUPD     BEGSR
      *
      ***  Retrieve current loan number
      *
     C*****L_CLLNRF      IFNE      *ZERO                                                      CLE148
     C     L_CLLNRF      IFNE      *BLANKS                                                    CLE148
     C                   MOVE      L_CLLNRF      MidasLnNum        6
     C                   ELSE
     C                   MOVE      *BLANKS       MidasLnNum
     C                   ENDIF
      *
     C                   CALLB     'LECLIPRTV'

      * INPUTS

      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    @@MODE            6
      * Response mode SECURITY CKECKING
     C                   PARM      ' '           @@RSMD            1
      * Action Code
     C                   PARM      L_CLCHTP      ACTN              1
      * Front Office Transaction ID
     C                   PARM      L_CLFRNT      FOTRID           20
      * (Midas) Customer Loan Reference
     C                   PARM                    MidasLnNum        6
      *
      ** Loan type/sub type
     C                   PARM                    MidasLTYP         2
     C                   PARM                    MidasSUTP         2
     C                   PARM                    MidasCLAS         4                          CLE042
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028                                      BUG3721

      * OUTPUTS

      * Loan Processing Type
     C                   PARM                    @@LoanPtyp        2 0
      * Loan Type
     C                   PARM                    @@LoanType        4

      * (Current) Customer loan CL in file format
     C                   PARM                    LoanL
      * (Current) Customer loan CK in file format
     C                   PARM                    LoanK
      * OK - Action code
     C                   PARM      *BLANK        DDACTNOK          1
      * OK - Loan Reference
     C                   PARM                    DDLNRFOK          1
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANK        FldNameArr
     C                   PARM      *BLANK        MsgIdArr
     C                   PARM      *BLANK        MsgDtaArr
      ***  Array index (3P0) from/to caller
     C                   PARM      *ZERO         Ix                3 0
     C                   PARM                    WFldNamArr                                   225959
     C                   PARM                    WMsgIdArr                                    225959
     C                   PARM                    WMsgDtaArr                                   225959
     C                   PARM                    WIdx              3 0                        225959
     C                   PARM                    PFPTF                                        245273
      *                                                                                     AR804863
      ** Action Code (Reject transaction)                                                   AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV                                     AR804863
     C/COPY WNCPYSRC,LECLIPPC04
      *
      ***  Error if Timestamp is not the same (record has been changed
      ***  by another workstation)
      *
      ***  Processing varies according to mode program is running in.
      ***  In interacive mode simply check whether the timestamp field
      ***  has been updated since the original Customer was fetched
      ***  by this program.
      ***  In batch (API input) check return parameters from Retrieve
      ***  module for errors, and send message to system operator.
      *
      ***  Interactive mode:
      *
     C                   IF        @TYPE = '1'
      *
     C                   IF        TMST <> L_CLTMES
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   ENDIF
      *
      ***  Batch mode:
      *
     C                   ELSE
     C                   IF        DDACTNOK = 'N' OR
     C                             DDLNRFOK = 'N'
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   Z-ADD     1             C                 2 0
      *
     C                   DOW       C < ArrayMax AND
     C                             FldNameArr(C) <> *BLANKS
     C                   CLEAR                   DBError         132
     C                   EVAL      DBerror = 'Update error: ' + FOTRID
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
     C                   ADD       1             C
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * INSERT - Insert a loan details                               *
      ****************************************************************
     C     INSERT        BEGSR
      *
      ***  Update related loan record for parts sold
      ***  or an internal parts purchased
      *
     C     *IN83         IFEQ      '1'
     C     *IN82         OREQ      '1'
     C*****L_CLMLNR      ANDNE     *ZEROS                                                     CLE148
     C     L_CLMLNR      ANDNE     *BLANKS                                                    CLE148
     C                   EXSR      SRRELL
     C                   ENDIF
      *
      ***  Initialise loan Details
      *
     C                   CLEAR                   LoanL
     C                   CLEAR                   LoanK
     C                   CLEAR                   PrvLOAN                                     BUG3721
     C                   CLEAR                   NewLOAN                                     BUG3721
      *
      ** Set Confirmation Required indicator for insert
      *
     C                   EXSR      CNFRQD_INS
      *
      **** The following processing is belt and braces to prevent duplicate                   CAP084
      **** loan numbers being assigned to the loans files                                     CAP084
      *                                                                                       CAP084
      ***  Write CLOANCL record                                                               CAP084
      *                                                                                       CAP084
     C                   EXSR      LONL_INS                                                   CAP084
                                                                                              CAP084
      ***  Access the next available loan number                                              CAP084
      *
     C*****L_CLLNRF      IFEQ      *ZERO                                                      CLE148
     C     L_CLLNRF      IFEQ      *BLANKS                                                    CLE148
     C                   EVAL      XCtr = 1                                                 MD022807
     C                   EVAL      *IN89 = '0'                                              MD022807
     C                   DOU       *IN89 = '1' AND                                          MD022807
     C                             L_CLLNRF <> *BLANKS OR                                   MD022807
     C                             XCtr > 100                                               MD022807
     C                   EVAL      XCtr = XCtr + 1                                          MD022807
     C                   EXSR      ACS_NXTAVL
     C**********         MOVE      F9NALN        L_CLLNRF                                     CLE148
     C                   MOVE      F9NALA        L_CLLNRF                                     CLE148
     C*****L_CLLNRF      CHAIN (E) CLOANCLF                           89             CAP084 MD021554
     C     L_CLLNRF      CHAIN (E) CLOANCTF                           89                    MD021554
      *
      *
     C**********         DOW       *IN89  <> '1'                                     CAP084 MD022807
      **********                                                                     CAP084 MD022807
     C**********         EXSR      ACS_NXTAVL                                        CAP084 MD022807
     C**********         MOVE      F9NALN        L_CLLNRF                              CAP084 CLE148
     C**********         MOVE      F9NALA        L_CLLNRF                            CLE148 MD022807
     C*****L_CLLNRF      CHAIN (E) CLOANCLF                           89             CAP084 MD021554
     C*****L_CLLNRF      CHAIN (E) CLOANCTF                           89           MD021554 MD022807
                                                                                              CAP084
     C                   ENDDO                                                                CAP084
     C                   ENDIF                                                                CAP084
      *****Write*CLOANCL record                                                               CAP084
      ***********                                                                             CAP084
     C***********        EXSR      LONL_INS                                                   CAP084
      * Update Loan number                                                                    CAP084
     C                   MOVE      L_CLLNRF      LNRF                                         CAP084
                                                                                              CLE134
      ***If*Pre-check*Order;******************************************                 CLE134 CLE164
      ***Retrieve*Repayment*Priority*Details.*************************                 CLE134 CLE164
                                                                                              CLE134
     C**********         IF        CLE134      = 'Y'                                   CLE134 CLE164
     C**********         IF        AUTO        = 'C'                                   CLE134 CLE164
     C**********         EVAL      KRPLNRF     = LNRF                                  CLE134 CLE164
     C*****KLEACCNLA     CHAIN(E)  LEACCNLA                                            CLE134 CLE164
                                                                                              CLE134
     C**********         IF        %FOUND(LEACCNLA)            OR                      CLE134 CLE164
     C**********                   %ERROR                                              CLE134 CLE164
     C**********         MOVEL     '*ERROR '     @@RTCD                                262431 CLE164
     C**********         EVAL      DBFILE      = 'LEACCNLA'                            CLE134 CLE164
     C**********         MOVEL(P)  KRPLNRF       DBKEY                                 CLE134 CLE164
     C**********         EVAL      DBASE       = 200                                   CLE134 CLE164
     C**********         EXSR      *PSSR                                               CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
                                                                                              CLE134
      ***Set*&*Write*Repayment*Priority*Details.*********************                  CLE134 CLE164
                                                                                              CLE134
     C**********         EXSR      xsACCN                                              CLE134 CLE164
                                                                                              CLE134
     C**********         WRITE(E)  LEACCND0                                            CLE134 CLE164
                                                                                              CLE134
     C**********         IF        %ERROR                                              CLE134 CLE164
     C**********         MOVEL     '*ERROR '     @@RTCD                                262431 CLE164
     C**********         EVAL      DBFILE      = 'LEACCNLA'                            CLE134 CLE164
     C**********         MOVEL(P)  KRPLNRF       DBKEY                                 CLE134 CLE164
     C**********         EVAL      DBASE       = 201                                   CLE134 CLE164
     C**********         EXSR      *PSSR                                               CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
                                                                                              CLE164
      *                                                                                       CLE164
      ** Output Repayment Priority Details to Customer Loan                                   CLE164
      ** Repayment Priority Extension File                                                    CLE164
     C                   MOVEL     AUTO          CUR_AUTO                                     CLE164
     C                   EXSR      WriteExtFile                                               CLE164
     C                   EXSR      UpdOrigLoan                                                CLE164
                                                                                              CLE164
                                                                                             BUG3760
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                             BUG3760
     C                             AND (CSC011 = 'N' OR CSC011 = 'Y'                         BUG3760
     C                             AND LIBR = S1MAIN)                                        BUG3760
                                                                                             BUG3760
     C                   MOVEL     RONS          WLF(1)                                      BUG3760
     C                   MOVEL     RIBN          WLF(2)                                      BUG3760
     C                   MOVEL     ROBN          WLF(3)                                      BUG3760
     C                   MOVEL     ROCN          WLF(4)                                      BUG3760
     C                   MOVEL     PONS          WLF(5)                                      BUG3760
     C                   MOVEL     PIBN          WLF(6)                                      BUG3760
     C                   MOVEL     POBN          WLF(7)                                      BUG3760
     C                   MOVEL     POCN          WLF(8)                                      BUG3760
     C                   MOVEL     RCRN          WLF(9)                                      BUG3760
     C                   MOVEL     RVNO          WLF(10)                                     BUG3760
     C                   MOVEL     AWBN          WLF(11)                                     BUG3760
     C                   MOVEL     BENN          WLF(12)                                     BUG3760
                                                                                             BUG3760
     C                   EVAL      Ctr = 1                                                   BUG3760
     C                   DOU       Ctr > Elements                                            BUG3760
                                                                                             BUG3760
     C                   IF        WLF(Ctr) <> *BLANKS                                       BUG3760
     C                   EVAL      WLOKFlg = 'Y'                                             BUG3760
     C                   LEAVE                                                               BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   EVAL      Ctr = Ctr + 1                                             BUG3760
                                                                                             BUG3760
     C                   ENDDO                                                               BUG3760
                                                                                             BUG3760
     C                   IF        WLOKFlg = 'Y'                                             BUG3760
     C                   EXSR      SrWatch                                                   BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                              CAP086
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C     L_CLAUTH      IFEQ      'Y'                                                        CAP086
     C                   EVAL      AUTH   = L_CLAUTH                                          CAP086
     C                   ENDIF                                                                CAP086
      *                                                                                       CER020
      ** Check for CER020 feature                                                             CER020
      *                                                                                       CER020
     C                   IF        CER020 = 'Y'                                               CER020
      *                                                                                       CER020
     C                   EVAL      ISDT = L_CLISDT                                            CER020
     C                   EVAL      FMDT = L_CLFMDT                                            CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
                                                                                             BUG3760
     C                   IF        CAS009 = 'Y'                                               CAS011
     C                   EXSR      EIRRTN                                                     CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
      ** Preventive fix for blank loan reference                                            MD021395
                                                                                            MD021395
     C                   IF        LNRF = *BLANKS                                           MD021395
     C     *LOCK         IN        LDA                                                      MD021395
     C                   MOVEL     'NO LNRF'     DBKEY                                      MD021395
     C                   MOVEL     'CLOANCL'     DBFILE                                     MD021395
     C                   Z-ADD     95            DBASE                                      MD021395
     C                   OUT       LDA                                                      MD021395
     C                   EXSR      SRERR                                                    MD021395
     C                   ENDIF                                                              MD021395
                                                                                            MD021395
     C                   WRITE     CLOANCLF

     C                   IF        CLE134 = 'Y'                                               CLE134
     C**********                   AND MPHAS <> 'A'                                  CLE134 MD025467
     C                             AND MPHAS =  'C'                                         MD025467
     C                   WRITE     LENEWLD0                                                   CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C*****MPHAS         IFNE      'A'                                             MD020954 MD026167
     C     MPHAS         IFEQ      'C'                                                      MD026167
     C     LNRF          ANDNE     *BLANKS                                                  MD020954
     C     LNRF          CHAIN(E)  LELWNELF                           90                    MD020954
     C                   IF        *IN90 = '1'                                              MD020954
     C                   EVAL      LELWNE = LoanL                                           MD020954
     C                   WRITE     LELWNELF                                                 MD020954
     C                   ENDIF                                                              MD020954
     C                   ENDIF                                                              MD020954
      *                                                                                     MD020954
     C                   MOVE      *BLANKS       Z#BSTS
     C                   MOVEL     LoanL         Z#ASTS
      *
      ***  Write CLOANCK records
      *
     C                   EXSR      LONK_INS
     C                   WRITE     CLOANCKF
     C                   MOVE      *BLANKS       Z#BSTK                                       222373
     C                   MOVEL     LoanK         Z#ASTK                                       222373
      *                                                                                     MD020954
     C*****MPHAS         IFNE      'A'                                             MD020954 MD025467
     C     MPHAS         IFEQ      'C'                                                      MD025467
     C     LNRF          CHAIN(E)  LELWNEKF                           90                    MD020954
     C                   IF        *IN90 = '1'                                              MD020954
     C                   EVAL      LELWNK = LoanK                                           MD020954
     C                   EVAL      PDRCDT = RCDT                                            MD020954
     C                   EVAL      PDMRIN = MRIN                                            MD020954
     C                   EVAL      PDORED = OREDK                                           MD020954
     C                   EVAL      PDLCD  = LCD                                             MD020954
     C                   EVAL      PDCHTP = CHTP                                            MD020954
     C                   EVAL      PDTNLU = TNLU                                            MD020954
     C                   EVAL      PDFRNT = FRNT                                            MD020954
     C                   EVAL      PDAFRT = AFRT                                            MD020954
     C                   EVAL      PDREPA = REPA                                            MD020954
     C                   EVAL      PDTMST = TMST                                            MD020954
     C                   WRITE     LELWNEKF                                                 MD020954
     C     CLE134        IFEQ      'N'                                                      MD021423
     C*****MPHAS         OREQ      'A'                                             MD021423 MD025467
     C     MPHAS         ORNE      'C'                                                      MD025467
     C                   EXSR      SrUpdTrailer                                             MD020954
     C                   ENDIF                                                              MD021423
     C                   ENDIF                                                              MD020954
     C                   ENDIF                                                              MD020954
      *                                                                                     MD020954

      * Access the LTRIX header record

     C**********         EXSR      SRACSLTH                                                 AR322732

      * Update FCLTY, LEREF

     C                   IF        CLE134 = 'N'                                               CLE134
     C**********                   OR  CLE134 = 'Y'                                    CLE134 263840
     C**********                   AND %SUBST(LTYP: 1: 1) = 'X'                        CLE134 263840
     C**********                   AND FAMU = 'Y'                                      CLE134 263840
     C                             OR  CLE134 = 'Y'                                           CLE134
     C                             AND %SUBST(LTYP: 1: 1) = 'Y'                               CLE134
     C                             AND FAMU = 'Y'                                             CLE134
     C                             OR  CLE134 = 'Y'                                           CLE134
     C                             AND %SUBST(LTYP: 1: 1) = 'Z'                               CLE134
     C                             AND FAMU = 'Y'                                             CLE134
     C                             OR  CLE134 = 'Y'                                           CLE134
     C**********                   AND %SUBST(LTYP: 1: 1) <> 'X'                       CLE134 263840
     C                             AND %SUBST(LTYP: 1: 1) <> 'Y'                              CLE134
     C                             AND %SUBST(LTYP: 1: 1) <> 'Z'                              CLE134
     C                             AND @DEPI  <> 'Y'                                        MD030621
     C                   EXSR      SRFCLT
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   EXSR      SRLREF

      * Write an LTRIX record
      * Update the LTRIX header record

     C     CLE002        IFEQ      'N'
     C     CLE002        OREQ      'Y'                                                      MD034771
     C     L_CLAUTH      ANDEQ     'Y'                                                      MD034771
     C     @TYPE         OREQ      '1'                                                     AR1093201
     C     BPLOAU        ANDNE     'Y'                                                     AR1093201
     C     @TYPE         OREQ      '1'                                                     AR1093201
     C     BPPPAU        ANDNE     'Y'                                                     AR1093201
     C     @TYPE         OREQ      '1'                                                     AR1093201
     C     BPPSAU        ANDNE     'Y'                                                     AR1093201
     C                   MOVE      'Y'           CNRQD                                     AR1093201
     C     CLE134        IFEQ      'N'                                                        CLE134
     C     CLE134        OREQ      'Y'                                                        CLE134
     C     MPHAS         ANDEQ     'A'                                                        CLE134
     C                   EXSR      SRWRTLTX
     C**********         EXSR      SRUPDLTH                                                 AR322732
     C                   ENDIF                                                                CLE134
     C                   ENDIF

      * Update CLOAN trailer

     C     CLE134        IFEQ      'N'                                                      MD021423
     C*****MPHAS         OREQ      'A'                                             MD021423 MD025467
     C     MPHAS         ORNE      'C'                                                      MD025467
     C                   EXSR      SRUPDTRL
     C                   ENDIF                                                              MD021423
     C/COPY WNCPYSRC,LECLIPPC02
                                                                                              CLE055
      * If authorization required clear settlement deatils.                                   CLE055
     C                   If        CLE055 = 'Y'                                               CLE055
     C                   If        *In82  = *on  and  BPPPAU = 'Y' or                         CLE055
     C                             *In83  = *on  and  BPPSAU = 'Y' or                         CLE055
     C                             *In82  = *off and  *In83  = *off  and                      CLE055
     C                                                BPLOAU = 'Y'                            CLE055
                                                                                              CLE055
     C                   Clear                   Z#ZASTS                                      CLE055
                                                                                              CLE055
     C                   Eval      Z#ZASTS   =    Z#ASTS                                      CLE055
                                                                                              CLE055
     C**********         Clear                   ZA_Pons                               243048 255240
     C**********         Clear                   ZA_Pstm                               243048 255240
     C                   Clear                   ZA_Pons                                      256233
     C                   Clear                   ZA_Pstm                                      256233
      *
     C**********         If        LoanType  = 'LOAN'  or  LoanType  = 'PTPU'          CLE055 255240
     C**********         Clear                   ZA_Pons                               CLE055 243048
     C**********         Clear                   ZA_Pstm                               CLE055 243048
     C**********         Clear                   ZA_Sdst                               CLE055 255240
     C**********         Clear                   ZA_Osda                               CLE055 255240
     C**********         Else                                                          CLE055 255240
     C**********         Clear                   ZA_Mdst                               CLE055 255240
     C**********         Clear                   ZA_Omda                               CLE055 255240
     C**********         Endif                                                         CLE055 255240
     C                   If        LoanType  = 'LOAN'  or  LoanType  = 'PTPU'                 256233
     C                   Clear                   ZA_Sdst                                      256233
     C                   Clear                   ZA_Osda                                      256233
     C                   Else                                                                 256233
     C                   Clear                   ZA_Mdst                                      256233
     C                   Clear                   ZA_Omda                                      256233
     C                   Endif                                                                256233
                                                                                              CLE055
     C                   Endif                                                                CLE055
     C                   Endif                                                                CLE055
      *                                                                                    AR1021983
      ** Update Past Due link reference                                                    AR1021983
      *                                                                                    AR1021983
     C                   MOVEL     L_CLFRNT      W#FRNT                                    AR1021983
     C                   IF        CLE134 = 'Y' AND                                        AR1021983
     C                             W#FRNT = 'LE000473'                                     AR1021983
      *                                                                                    AR1021983
     C                   EVAL      KYOFLN = L_CLOFLN                                       AR1021983
     C                   EVAL      KYOFCU = L_CLOFCU                                       AR1021983
     C                   MOVEL     L_CLOFAC      KYOFAC                                    AR1021983
     C                   MOVEL     L_CLOFSQ      KYOFSQ                                    AR1021983
     C                   EVAL      KYBRCA = L_CLBRCA                                       AR1021983
      *                                                                                    AR1021983
     C                   SELECT                                                            AR1021983
      ** Principal or Total                                                                AR1021983
     C                   WHEN      %SUBST(L_CLLTYP:1:1) = 'X'                              AR1021983
     C     L_CLORLN      CHAIN     LEPDUELB                           97                   AR1021983
     C                   DOW       *IN97 = '0'                                             AR1021983
     C                   IF        (YPDCT = 'P' OR YPDCT = 'T')                            AR1021983
     C                   EVAL      YPLON = L_CLLNRF                                        AR1021983
     C                   IF        YRECI = 'd'                                             AR1021983
     C                   EVAL      YRECI = 'D'                                             AR1021983
     C                   ENDIF                                                             AR1021983
     C                   IF        YRECI = 'p'                                             AR1021983
     C                   EVAL      YRECI = 'P'                                             AR1021983
     C                   ENDIF                                                             AR1021983
     C                   UPDATE    LEPDUED0                                                AR1021983
     C                   ENDIF                                                             AR1021983
     C     L_CLORLN      READE     LEPDUELB                               97               AR1021983
     C                   ENDDO                                                             AR1021983
     C**********         EXSR      SRUpdateMQF                                      CLE134 MD022807I
      ** Interest                                                                          AR1021983
     C                   WHEN      %SUBST(L_CLLTYP:1:1) = 'Y'                              AR1021983
     C     L_CLORLN      CHAIN     LEPDUELB                           97                   AR1021983
     C                   DOW       *IN97 = '0'                                             AR1021983
     C                   IF        YPDCT = 'I'                                             AR1021983
     C                   EVAL      YPLON = L_CLLNRF                                        AR1021983
     C                   IF        YRECI = 'd'                                             AR1021983
     C                   EVAL      YRECI = 'D'                                             AR1021983
     C                   ENDIF                                                             AR1021983
     C                   IF        YRECI = 'p'                                             AR1021983
     C                   EVAL      YRECI = 'P'                                             AR1021983
     C                   ENDIF                                                             AR1021983
     C                   UPDATE    LEPDUED0                                                AR1021983
     C                   ENDIF                                                             AR1021983
     C     L_CLORLN      READE     LEPDUELB                               97               AR1021983
     C                   ENDDO                                                             AR1021983
     C**********         EXSR      SRUpdateMQF                                      CLE134 MD022807I
      ** Fee                                                                               AR1021983
     C                   WHEN      %SUBST(L_CLLTYP:1:1) = 'Z'                              AR1021983
     C     KEY_UFLB      CHAIN     LEPDUFLB                           97                   AR1021983
     C                   DOW       *IN97 = '0'                                             AR1021983
     C                   EVAL      YPLON = L_CLLNRF                                        AR1021983
     C                   IF        YRECI = 'd'                                             AR1021983
     C                   EVAL      YRECI = 'D'                                             AR1021983
     C                   ENDIF                                                             AR1021983
     C                   IF        YRECI = 'p'                                             AR1021983
     C                   EVAL      YRECI = 'P'                                             AR1021983
     C                   ENDIF                                                             AR1021983
     C                   UPDATE    LEPDUFD0                                                AR1021983
     C     KEY_UFLB      READE     LEPDUFLB                               97               AR1021983
     C                   ENDDO                                                             AR1021983
     C**********         EXSR      SRUpdateMQF                                      CLE134 MD022807I
     C                   ENDSL                                                             AR1021983
      *                                                                                    AR1021983
      ** Update the original fee rocord                                                    AR1021983
      *                                                                                    AR1021983
     C                   IF        %SUBST(L_CLLTYP:1:1) = 'Z'                               MD023203
     C     KEY_FEED      CHAIN     LEFEEDL1                           98                   AR1021983
     C                   IF        *IN98 = '0'                                             AR1021983
     C                   EVAL      FEPLNR = L_CLLNRF                                       AR1021983
     C                   UPDATE    LEFEEDF                                                  MD020318
     C                   ENDIF                                                             AR1021983
     C                   ENDIF                                                              MD023203
     C                   ENDIF                                                             AR1021983

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * AMEND  - Amend a loan                                        *
      ****************************************************************
     C     AMEND         BEGSR
      *
      ***  Access loan Detail record
      *
     C     KCLLNRF       CHAIN     CLOANCKF                           99
     C  N99KCLLNRF       CHAIN     CLOANCLF                           99
      *
      ***  Database error
      *
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVE      L_CLLNRF      DBKEY                          *************
     C                   MOVEL     'CLOAN  '     DBFILE                         * DBERR 001 *
     C                   Z-ADD     1             DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   MOVE      'N'           MDAT00            1                        AR819476
     C                   Z-ADD     0             OINTR            13 0                      MD019945
     C                   EVAL      OINTR = AITC-IPRD-AIAP                                   MD019945
     C                   IF        CLE134 = 'Y' and MDAT = 0 and                            AR819476
     C**********                   CPAM > 0 and OINTR > 0 and                      MD019945 MD020960
     C                             (CPAM > 0 or OINTR > 0) and                              MD020960
     C                             (%SUBST(LTYP: 1: 1) = 'X' or                             AR819476
     C                             %SUBST(LTYP: 1: 1) = 'Y' or                              AR819476
     C                             %SUBST(LTYP: 1: 1) = 'Z')                                AR819476
     C                   MOVE      'Y'           MDAT00                                     AR819476
     C                   Z-ADD     BJRDNB        MDAT                                       AR819476
     C                   ENDIF                                                              AR819476
      *                                                                                     AR819476
      ** Change before repayment amount value if CPAM is less than RAMT                     MD034363
      *                                                                                     MD034363
     C                   IF        (CPAM < RAMT AND REPT = 1) or                            MD034363
     C                             (CPAM < RAMT AND REPT = 2) or                            MD034363
     C                             (RAMT > (OINTR+CPAM) AND REPT = 3)                       MD034363
     C                   Z-ADD     CPAM          RAMT                                       MD034363
     C                   ENDIF                                                              MD034363
      *                                                                                     MD034363
     C                   MOVEL     LoanL         Z#BSTS
      *                                                                                     AR819476
     C                   IF        MDAT00 = 'Y'                                             AR819476
     C                   Z-ADD     0             MDAT                                       AR819476
     C                   ENDIF                                                              AR819476
      *                                                                                     AR819476
     C                   MOVEL     LoanK         Z#BSTK                                       222373
      *                                                                                      BUG3760
     C                   MOVEL     LoanL         LoanC                                       BUG3760
      *
      * Save Previous and New Loan details
      *
     C                   EXSR      S_PrvLOAN
     C                   EXSR      S_NewLOAN
     C                   Exsr      SRSETLL                                                    245719
      *
      ** Set Confirmation Required indicator for amend
      *
     C                   EXSR      CNFRQD_AMD
      *
      ***  Update CLOANCL record
      *
     C                   EXSR      LONL_AMD
      *                                                                                      BUG3760
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                             BUG3760
     C                             AND (CSC011 = 'N' OR CSC011 = 'Y'                         BUG3760
     C                             AND LIBR = S1MAIN)                                        BUG3760
                                                                                             BUG3760
     C                   EVAL      WFuncType ='CLOANCL'                                      BUG3760
     C                   MOVEL     L_CLLNRF      WIdntifier                                  BUG3760
     C                   EVAL      WBranch = L_CLBRCA                                        BUG3760
                                                                                             BUG3760
     C     KCwFld        CHAIN     SDCWHTL1                                                  BUG3760
                                                                                             BUG3760
     C                   IF        %FOUND(SDCWHTL1) AND W3UNCF = 'Y'                         BUG3760
     C                   MOVEL     RONS          WLF(1)                                      BUG3760
     C                   MOVEL     RIBN          WLF(2)                                      BUG3760
     C                   MOVEL     ROBN          WLF(3)                                      BUG3760
     C                   MOVEL     ROCN          WLF(4)                                      BUG3760
     C                   MOVEL     PONS          WLF(5)                                      BUG3760
     C                   MOVEL     PIBN          WLF(6)                                      BUG3760
     C                   MOVEL     POBN          WLF(7)                                      BUG3760
     C                   MOVEL     POCN          WLF(8)                                      BUG3760
     C                   MOVEL     RCRN          WLF(9)                                      BUG3760
     C                   MOVEL     RVNO          WLF(10)                                     BUG3760
     C                   MOVEL     AWBN          WLF(11)                                     BUG3760
     C                   MOVEL     BENN          WLF(12)                                     BUG3760
     C                   EXSR      SRWatch                                                   BUG3760
     C                   ELSE                                                                BUG3760
                                                                                             BUG3760
     C                   MOVEA     *BLANKS       WLF                                         BUG3760
                                                                                             BUG3760
     C                   IF        RONS <> CHRONS                                            BUG3760
     C                   MOVEL     RONS          WLF(1)                                      BUG3760
     C                   EVAL      WLChgFlg = 'Y'                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        RIBN <> CHRIBN                                            BUG3760
     C                   MOVEL     RIBN          WLF(2)                                      BUG3760
     C                   EVAL      WLChgFlg = 'Y'                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        ROBN <> CHROBN                                            BUG3760
     C                   MOVEL     ROBN          WLF(3)                                      BUG3760
     C                   EVAL      WLChgFlg = 'Y'                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        ROCN <> CHROCN                                            BUG3760
     C                   MOVEL     ROCN          WLF(4)                                      BUG3760
     C                   EVAL      WLChgFlg = 'Y'                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        PONS <> CHPONS                                            BUG3760
     C                   MOVEL     PONS          WLF(5)                                      BUG3760
     C                   EVAL      WLChgFlg = 'Y'                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        PIBN <> CHPIBN                                            BUG3760
     C                   MOVEL     PIBN          WLF(6)                                      BUG3760
     C                   EVAL      WLChgFlg = 'Y'                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        POBN <> CHPOBN                                            BUG3760
     C                   MOVEL     POBN          WLF(7)                                      BUG3760
     C                   EVAL      WLChgFlg = 'Y'                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        POCN <> CHPOCN                                            BUG3760
     C                   MOVEL     POCN          WLF(8)                                      BUG3760
     C                   EVAL      WLChgFlg = 'Y'                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        RCRN <> CHRCRN                                            BUG3760
     C                   MOVEL     RCRN          WLF(9)                                      BUG3760
     C                   EVAL      WLChgFlg = 'Y'                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        RVNO <> CHRVNO                                            BUG3760
     C                   MOVEL     RVNO          WLF(10)                                     BUG3760
     C                   EVAL      WLChgFlg = 'Y'                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        AWBN <> CHAWBN                                            BUG3760
     C                   MOVEL     AWBN          WLF(11)                                     BUG3760
     C                   EVAL      WLChgFlg = 'Y'                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        BENN <> CHBENN                                            BUG3760
     C                   MOVEL     BENN          WLF(12)                                     BUG3760
     C                   EVAL      WLChgFlg = 'Y'                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   EVAL      WDtlOPay = 'N'                                            BUG3760
     C                   IF        DTP1 <> CHDTP1  or                                        BUG3760
     C                             DTP2 <> CHDTP2  or                                        BUG3760
     C                             DTP3 <> CHDTP3  or                                        BUG3760
     C                             DTP4 <> CHDTP4                                            BUG3760
     C                   EVAL      WLChgFlg = 'Y'                                            BUG3760
     C                   EVAL      WDtlOPay = 'Y'                                            BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        WLChgFlg = 'Y'                                            BUG3760
     C                   EXSR      SRWatch                                                   BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                              CAP086
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   EVAL      AUTH = L_CLAUTH                                            CAP086
      *                                                                                       CER020
      ** Check for CER020 feature                                                             CER020
      *                                                                                       CER020
     C                   IF        CER020 = 'Y'                                               CER020
      *                                                                                       CER020
     C                   EVAL      ISDT = L_CLISDT                                            CER020
     C                   EVAL      FMDT = L_CLFMDT                                            CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                      BUG3760
     C                   IF        CAS009 = 'Y'                                               CAS011
     C                   EXSR      EIRRTN                                                     CAS011
     C                   ENDIF                                                                CAS011

     C                   UPDATE    CLOANCLF
      *
     C                   IF        CLE134 = 'Y' and MDAT = 0 and                            AR819476
     C**********                   CPAM > 0 and OINTR > 0 and                      MD019945 MD020960
     C                             (CPAM > 0 or OINTR > 0) and                              MD020960
     C                             (%SUBST(LTYP: 1: 1) = 'X' or                             AR819476
     C                             %SUBST(LTYP: 1: 1) = 'Y' or                              AR819476
     C                             %SUBST(LTYP: 1: 1) = 'Z')                                AR819476
     C                   Z-ADD     BJRDNB        MDAT                                       AR819476
     C                   ENDIF                                                              AR819476
      *                                                                                     AR819476
     C                   MOVEL     LoanL         Z#ASTS
      *
      ** Write settlement change record in PF/LELSUTPD                                      MD020242
      *                                                                                     MD020242
     C                   IF        CLE055 = 'Y'                                             MD020242
     C                             AND WPayChg = 'Y'                                        MD020242
     C                   WRITE     LELSUTD0                                                 MD020242
     C                   EVAL      WPayChg = *Blank                                         MD020242
     C                   ENDIF                                                              MD020242
      *                                                                                     MD020242
     C     KCLLNRF       CHAIN     CLOANCKF                           89
      *
     C     *IN89         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVE      L_CLLNRF      DBKEY                          *************
     C                   MOVEL     'CLOAN  '     DBFILE                         * DBERR 004 *
     C                   Z-ADD     2             DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ***  Update CLOANCK record
      *
     C                   EXSR      LONK_AMD
     C                   UPDATE    CLOANCKF
      *                                                                                       262735
     C                   MOVEL     LNRF          WFLOAN                                       262735
     C                   MOVEL     CNUM          WFCNUM                                       262735
     C                   Z-ADD     0             WFFACL                                       262735
      *                                                                                       262735
     C     WKFEE         SETLL     LEFEEDL1                                                   262735
     C     WKFEE         READE     LEFEEDL1                               89                 262735A
      *                                                                                       262735
     C     *IN89         DOWEQ     '0'                                                        262735
      *                                                                                       262735
     C     FECALT        IFEQ      '97'                                                       262735
     C     AutoEndFee    ANDEQ     'Y'                                                      MD046370
     C     FECALT        OREQ      '98'                                                       262735
     C     AutoEndFee    ANDEQ     'Y'                                                      MD046370
     C     FECALT        OREQ      '99'                                                       262735
     C     AutoEndFee    ANDEQ     'Y'                                                      MD046370
     C     FECALT        OREQ      '90'                                                       262735
      *                                                                                       262735
      ** Populate Fee fields                                                                  262735
      *                                                                                       262735
     C                   EXSR      POPFEE                                                     262735
     C                   Z-ADD     FENPYD        FENPYDP           5 0                        262735
     C                   Z-ADD     FEPEND        FEPENDP           5 0                        262735
     C                   MOVEL     CrFeFilFmt    Z#BSTF                                       262735
      *                                                                                       262735
     C     MDAT          IFNE      0                                                          262735
     C     MDAT          IFLT      FENPYD                                                     262735
     C     FENPYD        ANDGT     BJRDNB                                                     262735
     C     FELPDT        ANDLE     MDAT                                                       262735
     C                   Z-ADD     MDAT          FENPYD                                       262735
     C                   ENDIF                                                                262735
      *                                                                                       262735
     C     MDAT          IFLT      FEPEND                                                     262735
     C     FEPEND        ANDGT     BJRDNB                                                     262735
     C     FELPDT        ANDLE     MDAT                                                       262735
     C                   Z-ADD     MDAT          FEPEND                                       262735
     C                   ENDIF                                                                262735
     C                   ENDIF                                                                262735
      *                                                                                       262735
     C     FEPEND        IFNE      FEPENDP                                                    262735
     C     FENPYD        ORNE      FENPYDP                                                    262735
     C                   UPDATE    LEFEEDF                                                    262735
      *                                                                                       262735
     C                   Z-ADD     FEPEND        F_FEPEND                                     262735
     C                   Z-ADD     FENPYD        F_FENPYD                                     262735
     C                   MOVEL     CrFeFilFmt    Z#ASTF                                       262735
     C                   CALL      'AOOUFEU0'                                                 262735
     C                   PARM                    ##RTCD            7                          262735
     C                   PARM                    Z#BSTF                                       262735
     C                   PARM                    Z#ASTF                                       262735
     C                   PARM                    Z#WSTF                                       262735
      *                                                                                     AR868380
     C     ##RTCD        IFEQ      '*RECLCK'                                                AR868380
     C                   MOVEL     '*RECLCK'     @@RTCD                                     AR868380
     C                   GOTO      EXIT                                                     AR868380
     C                   ENDIF                                                              AR868380
      *                                                                                       262735
     C     ##RTCD        IFEQ      '*ERROR*'                                                  262735
     C                   MOVEL     'AOOUFEU0'    DBFILE                                       262735
     C                   Z-ADD     22            DBASE                                        262735
     C                   MOVEL     ##RTCD        DBKEY                                        262735
     C                   EXSR      *PSSR                                                      262735
     C                   ENDIF                                                                262735
     C                   ENDIF                                                                262735
      *                                                                                       262735
     C                   ENDIF                                                                262735
      *                                                                                      262735A
     C     WKFEE         READE     LEFEEDL1                               89                 262735A
      *                                                                                      262735A
     C                   ENDDO                                                                262735
      *                                                                                       241196
      ** Update related loan for parts sold                                                   241196
      *                                                                                       241196
     C     *IN83         IFNE      *ON                                                        241196
     C     NOPS          ANDGT     0                                                          241196
     C                   EXSR      PSOLDUPD                                                   241196
     C                   ENDIF                                                                241196

     C                   MOVEL     LoanK         Z#ASTK                                       222373
      * Access the LTRIX header record

     C**********         EXSR      SRACSLTH                                                 AR322732

      * Update FCLTY

     C                   IF        CLE134      = 'N'           OR                             263840
                                                                                              263840
     C                             CLE134      = 'Y'           AND                            263840
     C                             FAMU        = 'Y'           AND                            263840
     C                             (%SUBST(LTYP: 1: 1) = 'Y'   OR                             263840
     C                              %SUBST(LTYP: 1: 1) = 'Z')  OR                             263840
                                                                                              263840
     C                             CLE134      = 'Y'           AND                            263840
     C                             %SUBST(LTYP: 1: 1) <> 'Y'   AND                            263840
     C                             %SUBST(LTYP: 1: 1) <> 'Z'                                  263840
     C                             AND @DEPI  <> 'Y'                                        MD030621
     C                   EXSR      SRFCLT
     C                   ENDIF                                                                263840

      * Write an LTRIX record
      * Update the LTRIX header record

     C     CLE002        IFEQ      'N'
     C     @TYPE         OREQ      '1'                                                     AR1093201
     C     BPLOAU        ANDNE     'Y'                                                     AR1093201
     C     @TYPE         OREQ      '1'                                                     AR1093201
     C     BPPPAU        ANDNE     'Y'                                                     AR1093201
     C     @TYPE         OREQ      '1'                                                     AR1093201
     C     BPPSAU        ANDNE     'Y'                                                     AR1093201
     C                   MOVE      'Y'           CNRQD                                     AR1093201
     C                   EXSR      SRWRTLTX
     C**********         EXSR      SRUPDLTH                                                 AR322732
     C                   ENDIF
     C/COPY WNCPYSRC,LECLIPPC03
      *
      * If authorization required clear settlement deatils.                                   CLE055
     C                   If        CLE055 = 'Y'                                               CLE055
     C                   If        *In82  = *on  and  BPPPAU = 'Y' or                         CLE055
     C                             *In83  = *on  and  BPPSAU = 'Y' or                         CLE055
     C                             *In82  = *off and  *In83  = *off  and                      CLE055
     C                                                BPLOAU = 'Y'                            CLE055
                                                                                              CLE055
     C                   Clear                   Z#ZBSTS                                      CLE055
     C                   Clear                   Z#ZASTS                                      CLE055
                                                                                              CLE055
     C**********         If        LSTS      <>  'A'                                   CLE055 243048
     C**********         If        LSTS      <>  'A'                                   255240 256233
     C                   If        *IN88 = '0'                                                245719
     C                   Eval      Z#ZBSTS   =    Z#BSTS                                      CLE055
     C**********         If        (VDAT < BJRDNB) and (ORED < BJRDNB)                 252039 256233
     C**********         If        (VDAT <= BJRDNB) and (ORED <= BJRDNB)             256233 MD020242
     C**********                   and CHLSTS <> 'A'                                 256233 MD020242
     C**********         Clear                   ZB_Sdst                             252039 MD020242
     C**********         Clear                   ZB_Osda                             252039 MD020242
     C**********         Endif                                                       252039 MD020242
     C                   Endif                                                                245719
     C**********         Endif                                                         CLE055 243048
     C**********         Endif                                                         255240 256233
                                                                                              CLE055
     C                   Eval      Z#ZASTS   =    Z#ASTS                                      CLE055
                                                                                              CLE055
     C**********         If        LSTS      <>  'A'                                   CLE055 243048
     C**********         If        CHLSTS    <>  'A'                                   243048 255240
     C**********         If        LSTS      <>  'A'                                   255240 256233
     C**********         If        CHLSTS    <>  'A'                                  256233 256233A
     C                   If        LSTS      <>  'A'                                         256233A
     C                             AND ZB_Pstm = ZA_Pstm                                    MD020242
     C                             AND ZB_Pons = ZA_Pons                                    MD020242
     C                             OR LSTS = 'C'                                           MD020361A
     C                             OR WPayChg = 'E'                                        MD020361A
     C                   Clear                   ZB_Pons                                      CLE055
     C                   Clear                   ZB_Pstm                                      CLE055
                                                                                              CLE055
     C                   If        LoanType  = 'LOAN'  or  LoanType  = 'PTPU'                 CLE055
     C                   Clear                   ZB_Sdst                                      CLE055
     C                   Clear                   ZB_Osda                                      CLE055
     C                   Else                                                                 CLE055
     C                   Clear                   ZB_Mdst                                      CLE055
     C                   Clear                   ZB_Omda                                      CLE055
     C                   Endif                                                                CLE055
     C                   Endif                                                                CLE055
                                                                                              CLE055
     C                   Clear                   ZA_Pons                                      CLE055
     C                   Clear                   ZA_Pstm                                      CLE055
                                                                                              CLE055
     C                   If        LoanType  = 'LOAN'  or  LoanType  = 'PTPU'                 CLE055
     C                   Clear                   ZA_Sdst                                      CLE055
     C                   Clear                   ZA_Osda                                      CLE055
     C                   Else                                                                 CLE055
     C                   Clear                   ZA_Mdst                                      CLE055
     C                   Clear                   ZA_Omda                                      CLE055
     C                   Endif                                                                CLE055
                                                                                              CLE055
     C                   If        *IN88 = '1'                                                252789
     C                   Clear                   ZA_Mdst                                      252789
     C                   Clear                   ZA_Omda                                      252789
     C                   Clear                   ZA_Sdst                                      252789
     C                   Clear                   ZA_Osda                                      252789
     C                   Endif                                                                252789
                                                                                              252789
     C                   Endif                                                                CLE055
     C                   Endif                                                                CLE055
      *                                                                                       CLE164
      ** Output Repayment Priority Details to Customer Loan                                   CLE164
      ** Repayment Priority Extension File                                                    CLE164
     C                   EXSR      UpdateExtFile                                              CLE164
                                                                                              CLE055
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * AUTHOR - Authorise a loan                                    *
      ****************************************************************
     C     AUTHOR        BEGSR
      *
      ***  Access loan Detail record
      *
     C     KCLLNRF       CHAIN     CLOANCKF                           99
     C  N99KCLLNRF       CHAIN     CLOANCLF                           99
      *
      ***  Database error
      *
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVE      L_CLLNRF      DBKEY                          *************
     C                   MOVEL     'CLOAN  '     DBFILE                         * DBERR 003 *
     C                   Z-ADD     3             DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   MOVEL     LoanL         Z#BSTS
     C                   MOVEL     LoanK         Z#BSTK                                       222373
      *
      * Save Previous and New Loan details
      *
     C                   EXSR      S_PrvLOAN
     C                   EXSR      S_NewLOAN
      *
      ** Set Confirmation Required indicator for authorise
      *
     C                   EXSR      CNFRQD_AUT
      *
      ** Write to LERELEPD if loan has been released
      *
     C     L_CLCHTP      IFEQ      'Q'
     C                   EXSR      WRT_LERELE
     C                   ENDIF
      *
      ***  Update CLOANCL record
      *
     C                   EXSR      LONL_AUT
     C                   UPDATE    CLOANCLF
      *
     C                   MOVEL     LoanL         Z#ASTS
      *
     C     KCLLNRF       CHAIN     CLOANCKF                           89
      *
     C     *IN89         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVE      L_CLLNRF      DBKEY                          *************
     C                   MOVEL     'CLOAN  '     DBFILE                         * DBERR 004 *
     C                   Z-ADD     4             DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ***  Update CLOANCK record
      *
     C                   EXSR      LONK_AUT
     C                   UPDATE    CLOANCKF

     C                   MOVEL     LoanK         Z#ASTK                                       222373
      * Access the LTRIX header record

     C**********         EXSR      SRACSLTH                                                 AR322732

      * Write an LTRIX record
      * Update the LTRIX header record

     C     L_CLCHTP      IFEQ      'X'
     C     L_CLLSTS      ANDNE     'Q'
     C     L_CLCHTP      OREQ      'Q'
     C                   EXSR      SRWRTLTX
     C**********         EXSR      SRUPDLTH                                                 AR322732
     C                   ENDIF
      *                                                                                       CLE055
      * If authorization required clear settlement deatils.                                   CLE055
     C                   If        CLE055 = 'Y'                                               CLE055
     C                   If        *In82  = *on  and  BPPPAU = 'Y' or                         CLE055
     C                             *In83  = *on  and  BPPSAU = 'Y' or                         CLE055
     C                             *In82  = *off and  *In83  = *off  and                      CLE055
     C                                                BPLOAU = 'Y'                            CLE055
                                                                                              CLE055
      ** Check if Pay Settlement has been amended prior to authorisation                    MD020242
                                                                                            MD020242
     C                   MOVE      L_CLLNRF      KPLnrf            6                        MD020242
     C                   Z-ADD     BJRDNB        KPDate            5 0                      MD020242
     C                   MOVE      'N'           WPayAmd           1                        MD020242
     C     KPSETD        SETLL     LELSUTD0                                                 MD020242
     C     KPSETD        READE     LELSUTD0                               60                MD020242
     C                   IF        *IN60 = '0'                                              MD020242
     C**********         IF        MBPSTM <> PSTM                                 MD020242 MD020361A
     C**********                   OR MBPONS <> PONS                              MD020242 MD020361A
     C                   Eval      WPayAmd = 'Y'                                            MD020242
     C**********         ENDIF                                                    MD020242 MD020361A
                                                                                            MD020242
      ** Set all amend records as processed                                                 MD020242
                                                                                            MD020242
     C                   DOW       *IN60 = '0'                                              MD020242
     C                   EVAL      MLProcF = 'Y'                                            MD020242
     C                   UPDATE    LELSUTD0                                                 MD020242
     C     KPSETD        READE     LELSUTD0                               60                MD020242
     C                   ENDDO                                                              MD020242
     C                   ENDIF                                                              MD020242
                                                                                            MD020242
     C                   Clear                   Z#ZBSTS                                      CLE055
     C                   Clear                   Z#ZASTS                                      CLE055
                                                                                              CLE055
     C**********         Eval      Z#ZBSTS   =    Z#BSTS                               CLE055 243048
     C**********         Eval      Z#ZBSTS   =    Z#BSTS                               255240 256233
     C                   If        L_CLXUSR = *BLANK                                          245719
     C                   Eval      Z#ZASTS   =    Z#ASTS                                      CLE055
     C**********         If        (VDAT < BJRDNB) and (ORED < BJRDNB)                 252039 256233
     C                   If        (VDAT <= BJRDNB) and (ORED <= BJRDNB)                      256233
     C                             and LSTS <> 'A'                                         AR1052933
     C                   Clear                   ZB_Sdst                                      252039
     C                   Clear                   ZB_Osda                                      252039
     C                   Endif                                                                252039
     C                   Else                                                                 245719
     C**********         If        K_ZZ009 = 'Y'                                    245719 AR1052933
     C**********         Eval      K_ZZ009 = ' '                                    245719 AR1052933
     C                   Eval      Z#ZASTS   =    Z#ASTS                                      245719
     C**********         If        (VDAT < BJRDNB) and (ORED < BJRDNB)                 252039 256233
      *                                                                                     MD020242
      ** If there was no change in Pay Settlement during amend, clear                       MD020242
      ** Pay Settlement account to prevent duplicate shadow posting                         MD020242
      *                                                                                     MD020242
     C                   If        (VDAT <= BJRDNB) and (ORED <= BJRDNB)                      256233
     C                             and LSTS <> 'A'                                         AR1052933
     C                             OR WPayAmd = 'N' AND WPLsts = 'R'                        MD020242
     C                   IF        LoanType  = 'LOAN'  OR  LoanType  = 'PTPU'               MD020242
     C                   Clear                   ZA_Sdst                                      252039
     C                   Clear                   ZA_Osda                                      252039
     C                   ELSE                                                               MD020242
     C                   CLEAR                   ZA_Mdst                                    MD020242
     C                   CLEAR                   ZA_Omda                                    MD020242
     C                   ENDIF                                                              MD020242
     C                   Endif                                                                252039
     C**********         Endif                                                      245719 AR1052933
     C                   Endif                                                                245719
                                                                                              CLE055
     C**********         If        LSTS   <> 'A'                                       CLE055 243048
     C**********         If        LSTS   <> 'A'                                       255240 256233
     C                   Clear                   Z#BSTS                                       CLE055
                                                                                              CLE055
     C                   Clear                   ZA_Rons                                      CLE055
     C                   Clear                   ZA_Rstm                                      CLE055
     C                   If        LoanType  = 'LOAN'  or  LoanType  = 'PTPU'                 CLE055
     C                   Clear                   ZA_Mdst                                      CLE055
     C                   Clear                   ZA_Omda                                      CLE055
     C                   Else                                                                 CLE055
     C                   Clear                   ZA_Sdst                                      CLE055
     C                   Clear                   ZA_Osda                                      CLE055
     C                   Endif                                                                CLE055
                                                                                              CLE055
     C**********         Endif                                                         CLE055 243048
     C**********         Endif                                                         255240 256233
                                                                                              CLE055
     C                   Endif                                                                CLE055
     C                   Endif                                                                CLE055
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * REVERSE - Reverse a loan                                     *
      ****************************************************************
     C     REVERSE       BEGSR
      *
      ***  Update related loan for parts sold on reversal
      ***  or reversal of an internal parts purchased
      *
     C     *IN83         IFEQ      '1'
     C     *IN82         OREQ      '1'
     C*****L_CLMLNR      ANDNE     *ZEROS                                                     CLE148
     C     L_CLMLNR      ANDNE     *BLANKS                                                    CLE148
     C                   EXSR      SRRELL
     C                   ENDIF
      *
      ***  Access loan Detail record
      *
     C     KCLLNRF       CHAIN     CLOANCKF                           99
     C  N99KCLLNRF       CHAIN     CLOANCLF                           99
      *
      ***  Database error
      *
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVE      L_CLLNRF      DBKEY                          *************
     C                   MOVEL     'CLOAN  '     DBFILE                         * DBERR 005 *
     C                   Z-ADD     5             DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C                   MOVEL     LoanL         Z#BSTS
     C                   MOVEL     LoanK         Z#BSTK                                       222373
      *                                                                                       243048
     C*****CLE055        Ifeq      'Y'                                                 243048 255240
     C**********         MOVEL     LoanL         LoanC                                 243048 255240
     C**********         Endif                                                         243048 255240
     C     CLE055        Ifeq      'Y'                                                        256233
     C                   MOVEL     LoanL         LoanC                                        256233
     C                   Endif                                                                256233
      *
      * Save Previous and New Loan details
      *
     C                   EXSR      S_PrvLOAN
     C                   EXSR      S_NewLOAN
      *
      ** Set Confirmation Required indicator for reverse
      *
     C                   EXSR      CNFRQD_REV
      *
      ***  Update CLOANCL record
      *
     C                   EXSR      LONL_REV
     C                   UPDATE    CLOANCLF
      *
     C                   MOVEL     LoanL         Z#ASTS
      *
     C     KCLLNRF       CHAIN     CLOANCKF                           89
      *
     C     *IN89         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVE      L_CLLNRF      DBKEY                          *************
     C                   MOVEL     'CLOAN  '     DBFILE                         * DBERR 004 *
     C                   Z-ADD     6             DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ***  Update CLOANCL record
      *
     C                   EXSR      LONK_REV
     C                   UPDATE    CLOANCKF

     C                   MOVEL     LoanK         Z#ASTK                                       222373
      * Access the LTRIX header record

     C**********         EXSR      SRACSLTH                                                 AR322732

      * Update FCLTY, LEREF

     C                   IF        CLE134      = 'N'           OR                             263840
                                                                                              263840
     C                             CLE134      = 'Y'           AND                            263840
     C                             FAMU        = 'Y'           AND                            263840
     C                             (%SUBST(LTYP: 1: 1) = 'Y'   OR                             263840
     C                              %SUBST(LTYP: 1: 1) = 'Z')  OR                             263840
                                                                                              263840
     C                             CLE134      = 'Y'           AND                            263840
     C                             %SUBST(LTYP: 1: 1) <> 'Y'   AND                            263840
     C                             %SUBST(LTYP: 1: 1) <> 'Z'                                  263840
     C                             AND @DEPI  <> 'Y'                                        MD030621
     C                   EXSR      SRFCLT
     C**********         EXSR      SrUpdLEPDUE                                    AR1079502 MD041714
     C                   ENDIF                                                                263840
                                                                                              263840
      *                                                                                     MD041714
      ** Reverse PDCL Interest Loan                                                         MD041714
      *                                                                                     MD041714
     C                   IF        CLE134      = 'Y'           AND                          MD041714
     C                             (%SUBST(LTYP: 1: 1) = 'X'   OR                           MD041714
     C                              %SUBST(LTYP: 1: 1) = 'Y')                               MD041714
     C                   EXSR      SrUpdLEPDUE                                              MD041714
     C                   ENDIF                                                              MD041714
                                                                                            MD041714
     C                   EXSR      SRLREF

      * Write an LTRIX record
      * Update the LTRIX header record

     C     CLE002        IFEQ      'N'
     C     XUSR          ORNE      *BLANKS
     C     @TYPE         OREQ      '1'                                                     AR1093201
     C     BPLOAU        ANDNE     'Y'                                                     AR1093201
     C     @TYPE         OREQ      '1'                                                     AR1093201
     C     BPPPAU        ANDNE     'Y'                                                     AR1093201
     C     @TYPE         OREQ      '1'                                                     AR1093201
     C     BPPSAU        ANDNE     'Y'                                                     AR1093201
     C                   EXSR      SRWRTLTX
     C**********         EXSR      SRUPDLTH                                                 AR322732
     C                   ENDIF

      ***If*a*record*exists*in*LEACCNPD*then*delete*it****************               AR574498 CLE164
                                                                                            AR574498
     C**********         EVAL      KRPLNRF     = L_CLLNRF                            AR574498 CLE164
     C*****KLEACCNLA     CHAIN(E)  LEACCNLA                                          AR574498 CLE164
                                                                                            AR574498
     C**********         IF        %FOUND(LEACCNLA)                                  AR574498 CLE164
     C**********         DELETE    LEACCND0                                          AR574498 CLE164
     C**********         ENDIF                                                       AR574498 CLE164
      *                                                                                       CLE164
      ** Delete Repayment Priority Details record                                             CLE164
     C                   EXSR      DeleteExtFile                                              CLE164
                                                                                            AR574498
      * Update CLOAN trailer

     C                   EXSR      SRUPDTRL
      *                                                                                       CLE055
      * If authorization required clear settlement deatils.                                   CLE055
     C                   If        CLE055 = 'Y'                                               CLE055
     C                   If        *In82  = *on  and  BPPPAU = 'Y' or                         CLE055
     C                             *In83  = *on  and  BPPSAU = 'Y' or                         CLE055
     C                             *In82  = *off and  *In83  = *off  and                      CLE055
     C                                                BPLOAU = 'Y'                            CLE055
                                                                                              CLE055
     C                   Clear                   Z#ZBSTS                                      CLE055
     C                   Clear                   Z#ZASTS                                      255240
                                                                                              CLE055
     C                   Eval      Z#ZBSTS   =    Z#BSTS                                      CLE055
                                                                                              CLE055
     C**********         If        LSTS      <> 'A'                                    CLE055 243048
     C**********         Clear                   Z#BSTS                                CLE055 243048
     C**********         If        CHLSTS    <> 'A'                                    243048 255240
     C**********         Clear                   ZB_Pons                               243048 255240
     C**********         Clear                   ZB_Pstm                               243048 255240
                                                                                243048
     C**********         If        LoanType  = 'LOAN'  or  LoanType  = 'PTPU'          243048 255240
     C**********         Clear                   ZB_Sdst                               243048 255240
     C**********         Clear                   ZB_Osda                               243048 255240
     C**********         Else                                                          243048 255240
     C**********         Clear                   ZB_Mdst                               243048 255240
     C**********         Clear                   ZB_Omda                               243048 255240
     C**********         Endif                                                         243048 255240
     C**********         Endif                                                         CLE055 255240
     C                   If        CHLSTS    <> 'A'                                           256233
     C                   Clear                   ZB_Pons                                      256233
     C                   Clear                   ZB_Pstm                                      256233
                                                                                              256233
     C                   If        LoanType  = 'LOAN'  or  LoanType  = 'PTPU'                 256233
     C                   Clear                   ZB_Sdst                                      256233
     C                   Clear                   ZB_Osda                                      256233
     C                   Else                                                                 256233
     C                   Clear                   ZB_Mdst                                      256233
     C                   Clear                   ZB_Omda                                      256233
     C                   Endif                                                                256233
     C                   Endif                                                                256233
                                                                                              CLE055
     C                   Endif                                                                CLE055
     C                   Endif                                                                CLE055

     C                   ENDSR
      ****************************************************************                        245719
      /EJECT                                                                                  245719
      ****************************************************************                        245719
      * SRSETLL - Verify if the changes are in Settlement Details    *                        245719
      ****************************************************************                        245719
     C     SRSETLL       BEGSR                                                                245719
     C                   MOVE      '1'           *IN88                                        245719
     C   88Prv_STRINS    COMP      New_STRINS                             88                  245719
     C   88Prv_OSDA      COMP      New_OSDA                               88                  245719
     C   88Prv_MATINS    COMP      New_MATINS                             88                  245719
     C   88Prv_OMDA      COMP      New_OMDA                               88                  245719
     C   88Prv_MDAT      COMP      New_MDAT                               88                  252039
     C   88Prv_NRPD      COMP      New_NRPD                               88                  252039
     C   88Prv_NIDT      COMP      New_NIDT                               88                  252039
     C   88Prv_AUTO      COMP      New_AUTO                               88                  252789
     C   88Prv_RAMT      COMP      New_RAMT                               88                  252789
     C  N88              Eval      K_ZZ009='Y'                                                245719
     C                   ENDSR                                                                245719
      ****************************************************************
      /EJECT
      ****************************************************************
      * CNFIND_INS Confirmation Required Ind setting for INSERT      *
      ****************************************************************
     C     CNFRQD_INS    BEGSR

     C                   MOVE      'N'           CNRQD
     C                   BITOFF    '01234567'    L_CLCNFI
      *
      ***  If no authorisation, request confirmation
      ***  if settlement instruction is entered
      *
     C     CLE002        IFEQ      'N'
     C     CLE002        OREQ      'Y'                                                      MD034771
     C     L_CLAUTH      ANDEQ     'Y'                                                      MD034771
     C                   MOVE      'Y'           CNRQD
     C     BLL2II        IFEQ      'Y'
     C     L_CLSDST      ANDEQ     *ZEROS
     C     L_CLMDST      ANDEQ     *ZEROS
     C                   MOVE      'N'           CNRQD
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * CNFIND_AMD Confirmation Required Ind setting for AMEND       *
      ****************************************************************
     C     CNFRQD_AMD    BEGSR

     C                   MOVE      'N'           CNRQD
      *
      ***  Check if basic loan details or start or maturity instructions
      ***  have changed. If so, request confirmation
      *
     C     CLE002        IFEQ      'N'
     C     CLE002        OREQ      'Y'                                                      MD034771
     C     L_CLAUTH      ANDEQ     'Y'                                                      MD034771
      *                                                                                      255752A
      ** For amend, check settlement details/interest payment/pricipal                       255752A
      ** repayment/maturity for request confirmation.                                        255752A
      *                                                                                      255752A
     C     Prv_LNDTLS    IFNE      New_LNDTLS
     C*****Prv_STRINS    ORNE      New_STRINS                                                255752A
     C*****Prv_OSDA      ANDNE     New_OSDA                                           CGL029 255752A
     C*****Prv_MATINS    ORNE      New_MATINS                                                255752A
     C*****Prv_OMDA      ANDNE     New_OMDA                                           CGL029 255752A
     C*****ORED*         IFEQ      BJRDNB                                                    255752A
     C*****ORED*         ORLT      BJRDNB                                                    255752A
     C*****VDAT*         ANDGE     BJRDNB                                                    255752A
     C                   MOVE      'Y'           CNRQD
     C                   BITOFF    '0'           L_CLCNFI
     C**********         ENDIF                                                               255752A
     C                   ENDIF
     C                   ELSE                                                                255752A
     C     Prv_LNDTLS    IFNE      New_LNDTLS                                                255752A
     C     Prv_PONS      ORNE      New_PONS                                                  255752A
     C     Prv_PSTM      ORNE      New_PSTM                                                  255752A
     C     Prv_RONS      ORNE      New_RONS                                                  255752A
     C     Prv_RSTM      ORNE      New_RSTM                                                  255752A
     C                   MOVE      'Y'           CONF                                        255752A
     C                   ENDIF                                                               255752A
     C                   ENDIF

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * CNFIND_AUT Confirmation Required Ind setting for AUTHORISE   *
      ****************************************************************
     C     CNFRQD_AUT    BEGSR

     C                   MOVE      'N'           CNRQD

      ** First authorisation

     C     XUSR          IFEQ      *BLANKS
     C                   BITOFF    '01234567'    L_CLCNFI
     C                   MOVE      'Y'           CNRQD
     C     BLL2II        IFEQ      'Y'
     C     L_CLSDST      ANDEQ     *ZEROS
     C     L_CLMDST      ANDEQ     *ZEROS
     C                   MOVE      'N'           CNRQD
     C                   ENDIF
     C                   ENDIF

      * Not first authorisation

     C     XUSR          IFNE      *BLANKS
     C     BLL2II        IFNE      'Y'
     C     L_CLSDST      ORNE      *ZEROS
     C     L_CLMDST      ORNE      *ZEROS
     C*****ORED*         IFEQ      BJRDNB                                                    255752A
     C*****ORED*         ORLT      BJRDNB                                                    255752A
     C*****VDAT*         ANDGE     BJRDNB                                                    255752A
     C     CONF          IFEQ      'Y'                                                       255752A
     C                   MOVE      'Y'           CNRQD
     C                   BITOFF    '0'           L_CLCNFI
     C                   MOVE      *BLANKS       CONF                                        255752A
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * CNFIND_REV Confirmation Required Ind setting for REVERSE     *
      ****************************************************************
     C     CNFRQD_REV    BEGSR

     C                   MOVE      'N'           CNRQD
      *
      ***  For reverse, if confirmation control is ON, request
      ***  confirmation and set off commencement indicator
      *
     C                   TESTB     '1'           L_CLCNFI                 87
     C     *IN87         IFEQ      '1'
     C                   BITOFF    '0'           L_CLCNFI
     C                   MOVE      'Y'           CNRQD
     C                   ENDIF

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * S_PrvLoan - Save Previous Loan details                       *
      ****************************************************************
     C     S_PrvLOAN     BEGSR

     C                   Z-ADD     MDAT          Prv_MDAT
     C                   Z-ADD     NIDT          Prv_NIDT
     C                   Z-ADD     NRPD          Prv_NRPD
     C                   Z-ADD     IFDY          Prv_IFDY
     C                   MOVE      IPFR          Prv_IPFR
     C                   Z-ADD     RDYN          Prv_RDYN
     C                   MOVE      RFRQ          Prv_RFRQ
     C                   Z-ADD     RAMT          Prv_RAMT
     C                   Z-ADD     SDST          Prv_SDST
     C                   MOVE      OSDA          Prv_OSDA
     C                   MOVE      TSTN          Prv_TSTN
     C                   MOVE      FACO          Prv_FACO
     C                   MOVE      SPI1          Prv_SPI1
     C                   MOVE      SPI2          Prv_SPI2
     C                   MOVE      SPI3          Prv_SPI3
     C                   Z-ADD     MDST          Prv_MDST
     C                   MOVE      OMDA          Prv_OMDA
     C                   MOVE      TMAN          Prv_TMAN
     C                   MOVE      AUTO          Prv_AUTO                                     252789
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C                   MOVE      ADIF          Prv_ADIF                                    BUG3721
     C                   MOVE      ADCF          Prv_ADCF                                    BUG3721
     C                   MOVE      ICIF          Prv_ICIF                                    BUG3721
     C                   Z-ADD     CHGA          Prv_CHGA                                    BUG3721
     C                   Z-ADD     FLTI          Prv_FLTI                                    BUG3721
     C                   Z-ADD     FRPD          Prv_FRPD                                    BUG3721
                                                                                             BUG3721
     C                   ELSE                                                                BUG3721
     C                   MOVE      *BLANKS       Prv_ADIF                                    BUG3721
     C                   MOVE      *BLANKS       Prv_ADCF                                    BUG3721
     C                   MOVE      *BLANKS       Prv_ICIF                                    BUG3721
     C                   Z-ADD     *ZEROS        Prv_CHGA                                    BUG3721
     C                   Z-ADD     *ZEROS        Prv_FLTI                                    BUG3721
     C                   Z-ADD     *ZEROS        Prv_FRPD                                    BUG3721
     C                   ENDIF                                                               BUG3721
      *
     C                   IF        CLE134      = 'Y'                                          CLE134
     C                   EVAL      Prv_FAMU    = FAMU                                         CLE134
     C                   EVAL      Prv_RIDT    = RIDT                                         CLE134
     C                   EVAL      Prv_RCAT    = RCAT                                         CLE134
     C                   EVAL      Prv_BIDT    = BIDT                                         CLE134
     C                   EVAL      Prv_BCAT    = BCAT                                         CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   EVAL      Prv_FAMU    = *BLANK                                       CLE134
     C                   EVAL      Prv_RIDT    = 0                                            CLE134
     C                   EVAL      Prv_RCAT    = 0                                            CLE134
     C                   EVAL      Prv_BIDT    = 0                                            CLE134
     C                   EVAL      Prv_BCAT    = 0                                            CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   Z-ADD     FCRA          Prv_FCRA                                     CAS011
     C**********         Z-ADD     LNRF          Prv_LNRF                              CAS011 CLE148
     C                   MOVEL     LNRF          Prv_LNRF                                     CLE148
      *                                                                                      255752A
      ** Save previous settlements.                                                          255752A
      *                                                                                      255752A
     C     *LIKE         Define    PONS          Prv_PONS                                    255752A
     C     *LIKE         Define    PSTM          Prv_PSTM                                    255752A
     C     *LIKE         Define    RONS          Prv_RONS                                    255752A
     C     *LIKE         Define    RSTM          Prv_RSTM                                    255752A
      *                                                                                      255752A
     C                   MOVE      PONS          Prv_PONS                                    255752A
     C                   MOVE      PSTM          Prv_PSTM                                    255752A
     C                   MOVE      RONS          Prv_RONS                                    255752A
     C                   MOVE      RSTM          Prv_RSTM                                    255752A
      *                                                                                      255752A
     C                   Z-ADD     OCDT          Prv_OCDT                                     CLE143
     C                   Z-ADD     EAIR          Prv_EAIR                                     CLE143
      *                                                                                       CAS011
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * S_NewLoan - Save New Loan details                            *
      ****************************************************************
     C     S_NewLOAN     BEGSR

     C                   Z-ADD     L_CLMDAT      New_MDAT
     C                   Z-ADD     L_CLNIDT      New_NIDT
     C                   Z-ADD     L_CLNRPD      New_NRPD
     C                   Z-ADD     L_CLIFDY      New_IFDY
     C                   MOVE      L_CLIPFR      New_IPFR
     C                   Z-ADD     L_CLRDYN      New_RDYN
     C                   MOVE      L_CLRFRQ      New_RFRQ
     C                   Z-ADD     L_CLRAMT      New_RAMT
     C                   Z-ADD     L_CLSDST      New_SDST
     C                   MOVE      L_CLOSDA      New_OSDA
     C                   MOVE      L_CLTSTN      New_TSTN
     C                   MOVE      L_CLFACO      New_FACO
     C                   MOVE      K_CLSPI1      New_SPI1
     C                   MOVE      K_CLSPI2      New_SPI2
     C                   MOVE      K_CLSPI3      New_SPI3
     C                   Z-ADD     L_CLMDST      New_MDST
     C                   MOVE      L_CLOMDA      New_OMDA
     C                   MOVE      L_CLTMAN      New_TMAN
     C                   MOVE      L_CLAUTO      New_AUTO                                     252789
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C                   MOVE      L_CLADIF      New_ADIF                                    BUG3721
     C                   MOVE      L_CLADCF      New_ADCF                                    BUG3721
     C                   MOVE      L_CLICIF      New_ICIF                                    BUG3721
     C                   Z-ADD     L_CLCHGA      New_CHGA                                    BUG3721
     C                   Z-ADD     L_CLFLTI      New_FLTI                                    BUG3721
     C                   Z-ADD     L_CLFRPD      New_FRPD                                    BUG3721
                                                                                             BUG3721
     C                   ELSE                                                                BUG3721
     C                   MOVE      *BLANKS       New_ADIF                                    BUG3721
     C                   MOVE      *BLANKS       New_ADCF                                    BUG3721
     C                   MOVE      *BLANKS       New_ICIF                                    BUG3721
     C                   Z-ADD     *ZEROS        New_CHGA                                    BUG3721
     C                   Z-Sub     *ZEROS        New_FLTI                                    BUG3721
     C                   Z-ADD     *ZEROS        New_FRPD                                    BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                              CLE134
     C                   IF        CLE134      = 'Y'                                          CLE134
     C                   EVAL      New_FAMU    = L_CLFAMU                                     CLE134
     C                   EVAL      New_RIDT    = L_CLRIDT                                     CLE134
     C                   EVAL      New_RCAT    = L_CLRCAT                                     CLE134
     C                   EVAL      New_BIDT    = L_CLBIDT                                     CLE134
     C                   EVAL      New_BCAT    = L_CLBCAT                                     CLE134
                                                                                              CLE134
     C                   ELSE                                                                 CLE134
     C                   EVAL      New_FAMU    = *BLANK                                       CLE134
     C                   EVAL      New_RIDT    = 0                                            CLE134
     C                   EVAL      New_RCAT    = 0                                            CLE134
     C                   EVAL      New_BIDT    = 0                                            CLE134
     C                   EVAL      New_BCAT    = 0                                            CLE134
     C                   ENDIF                                                                CLE134
      *                                                                                       CAS011
     C                   Z-ADD     L_CLPTYP      New_PTYP                                     CAS011
     C                   Z-ADD     L_CLVDAT      New_VDAT                                     CAS011
     C                   Z-ADD     L_CLFCRA      New_FCRA                                     CAS011
     C***********        Z-ADD     L_CLOLNO      New_OLNO                               CAS011CSD027
     C                   MOVE      L_CLOLNO      New_OLNO                                     CSD027
     C                   MOVE      L_CLCHTP      New_CHTP                                     CAS011
      *                                                                                      255752A
      ** Save new settlement details.                                                        255752A
      *                                                                                      255752A
     C     *LIKE         Define    L_CLPONS      New_PONS                                    255752A
     C     *LIKE         Define    L_CLPSTM      New_PSTM                                    255752A
     C     *LIKE         Define    L_CLRONS      New_RONS                                    255752A
     C     *LIKE         Define    L_CLRSTM      New_RSTM                                    255752A
      *                                                                                      255752A
     C                   MOVE      L_CLPONS      New_PONS                                    255752A
     C                   MOVE      L_CLPSTM      New_PSTM                                    255752A
     C                   MOVE      L_CLRONS      New_RONS                                    255752A
     C                   MOVE      L_CLRSTM      New_RSTM                                    255752A
      *
     C                   Z-ADD     L_CLOCDT      New_OCDT                                     CLE143
     C                   Z-ADD     L_CLEAIR      New_EAIR                                     CLE143
                                                                                              CLE143
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * LONL_INS -  Format CLOANCL fields for INSERT                  *
      *****************************************************************
     C     LONL_INS      BEGSR
      *
      * Record Id
     C                   MOVE      'D'           RECI
      *
      * Loan number
     C                   MOVE      L_CLLNRF      LNRF
      *
      * Record type
     C                   MOVE      'A'           RCDT
      *
      * Matching records indicator
     C                   Z-ADD     1             MRIN
      *
      * Loan processing type
     C                   Z-ADD     L_CLPTYP      PTYP
      *
      * Customer number
     C                   MOVE      L_CLCNUM      CNUM
      *
      * Branch Code - Alpha
     C                   MOVE      L_CLBRCA      BRCA
      *
      * Loan type
     C                   MOVE      L_CLLTYP      LTYP
      *
      * Loan sub-type
     C                   MOVE      L_CLSUTP      SUTP
      * Loan class                                                                            CLE042
     C                   MOVE      L_CLCLAS      CLAS                                         CLE042
      *
      * Deal date
     C                   Z-ADD     L_CLDDAT      DDAT
      *
      * Value date
     C                   Z-ADD     L_CLVDAT      VDAT
      *
      * Maturity date
     C                   Z-ADD     L_CLMDAT      MDAT
      *
      * Customer loan a/c seq no.
     C                   MOVE      L_CLLASQ      LASQ
      *
      * Facility customer
      * Facility type
      * Facility sequence number
     C     *IN83         IFEQ      '0'
     C                   MOVE      L_CLFCUS      FCUS
     C                   MOVE      L_CLFTYP      FTYP
     C                   MOVE      L_CLFSEQ      FSEQ
     C                   ELSE
     C**********         Z-ADD     FCUS_M        FCUS                                         CSD027
     C                   EVAL      FCUS = FCUS_M                                              CSD027
     C                   Z-ADD     FTYP_M        FTYP
     C                   Z-ADD     FSEQ_M        FSEQ
     C                   ENDIF
      *
      * Currency code
     C                   MOVE      L_CLCCY       CCY
      *
      * Current principal amount
     C                   Z-ADD     L_CLCPAM      CPAM
      *
      * Interest captilisation ind
     C                   MOVE      L_CLINTC      INTC
     C     L_CLINTC      IFEQ      *BLANK
     C                   MOVE      'N'           INTC
     C                   ENDIF
      *
      * Interest rate
     C                   SELECT
     C     L_CLSPIN      WHENEQ    'A'
     C     L_CLBRTE      ADD       L_CLRTSP      INTR
     C     L_CLSPIN      WHENEQ    'S'
     C     L_CLBRTE      SUB       L_CLRTSP      INTR
     C     L_CLSPIN      WHENEQ    'P'
     C     L_CLRTSP      DIV       100           WRK_139          13 9
     C     WRK_139       MULT(H)   L_CLBRTE      INTR
     C     L_CLSPIN      WHENEQ    *Blank                                                     CLE106
     C                   Z-ADD     L_CLRTSP      INTR                                         CLE106
     C                   ENDSL
      *
      * Base rate code
     C                   MOVE      L_CLBRTT      BRTT
      *                                                                                       CLE106
      * Base rate                                                                             CLE106
     C                   IF        CLE036 = 'Y'                                              BUG9491
     C                   Z-ADD     L_CLBASR      BASR                                         CLE106
     C                   ENDIF                                                               BUG9491
      *
      * Current Base rate
     C                   Z-ADD     L_CLBRTE      BRTE
      *
      * Rate/spread
     C                   Z-ADD     L_CLRTSP      RTSP
      *
      * Margin
     C                   Z-ADD     L_CLMARG      MARG
      *
      * Spread indicator
     C                   MOVE      L_CLSPIN      SPIN
      *
      * Change ind
     C                   MOVE      L_CLCHIN      CHIN
     C     L_CLBRTT      IFNE      *ZERO
     C     L_CLCHIN      ANDEQ     *BLANK
     C     L_CLPTYP      IFEQ      63
     C     L_CLPTYP      OREQ      65
     C     L_CLPTYP      OREQ      67
     C     L_CLPTYP      OREQ      72
     C     W72TP         ANDEQ     '67'
     C     L_CLPTYP      OREQ      80                                                        BUG3721
     C     CLE028        ANDEQ     'Y'                                                       BUG3721
     C                   MOVE      'N'           CHIN
     C                   ELSE
     C                   MOVE      'D'           CHIN
     C                   ENDIF
     C                   MOVE      CHIN          L_CLCHIN                                     CLE106
     C                   ENDIF
      *
      * Withholding tax rate
     C                   Z-ADD     L_CLWTRT      WTRT
      *
      * Withholding tax indicator
     C                   MOVE      L_CLWTIN      WTIN
      *
      * Repayment type
     C                   MOVE      L_CLREPT      REPT
     C     L_CLREPT      IFEQ      *ZERO
     C                   MOVE      '0'           REPT
     C                   ENDIF
      *
      * Repayment amount
     C                   Z-ADD     L_CLRAMT      RAMT
      *
      * Next repayment date
     C                   Z-ADD     L_CLNRPD      NRPD
      *
      * Repayment frequency
     C                   MOVE      L_CLRFRQ      RFRQ
      *
      * Repayment day no.
     C                   MOVE      L_CLRDYN      RDYN
      *
      * Facility currency
      *
     C     *IN83         IFEQ      '0'
     C                   MOVE      L_CLFCCY      FCCY
     C                   ELSE
     C                   MOVE      FCCY_M        FCCY
     C                   ENDIF
      *
      * Local industry code
     C     *IN83         IFEQ      '0'
     C**********         MOVE      L_CLLIND      LIND                                         CER020
     C                   MOVE      L_CLLOIC      LOIC                                         CER020
     C                   ELSE
     C**********         MOVE      LIND_M        LIND                                         CER020
     C**********         MOVE      LIND_M        L_CLLIND                              CLE106 CER020
     C                   MOVE      LIND_M        LOIC                                         CER020
     C                   MOVE      LIND_M        L_CLLOIC                                     CER020
     C                   ENDIF
      *
      * Country of risk
     C     *IN83         IFEQ      '0'
     C                   MOVE      L_CLCRSK      CRSK
     C                   ELSE
     C                   MOVE      CRSK_M        CRSK
     C                   MOVE      CRSK_M        L_CLCRSK                                     CLE106
     C                   ENDIF
      *
      * Account officer
     C                   MOVE      L_CLACOF      ACOF
      *
      * Name and address code
     C                   MOVE      L_CLNACD      NACD
      *
      * Indicators: secured/doc/fee
     C                   MOVE      L_CLRELI      RELI
      *
      * Auto settlement indicator
     C                   MOVE      L_CLAUTO      AUTO
      *
      * Base currency exchange rate
     C                   Z-ADD     L_CLBCXR      BCXR
      *
      * Facility ccy exch. rate
     C     *IN83         IFEQ      '0'
     C                   Z-ADD     L_CLFCXR      FCXR
     C                   ELSE
     C                   Z-ADD     FCXR_M        FCXR
     C                   Z-ADD     FCXR_M        L_CLFCXR                                     CLE106
     C                   ENDIF
                                                                                              CLE031
      * Facility Currency Principal Amount                                                    CLE031
                                                                                              CLE031
     C                   IF        CLE031 = 'Y'                                               CLE031
     C                   EVAL      FPAM = L_CLFPAM                                            CLE031
     C                   ENDIF                                                                CLE031
      *
      * Start date settlement type
      * Our start date account
      * Their start nostro
      * Maturity date settlement typ
      * Our maturity date account
      * Their maturity nostro
      * For account of
     C                   Z-ADD     L_CLSDST      SDST
     C                   MOVE      L_CLOSDA      OSDA
     C                   MOVE      L_CLTSTN      TSTN
     C                   Z-ADD     L_CLMDST      MDST
     C                   MOVE      L_CLOMDA      OMDA
     C                   MOVE      L_CLTMAN      TMAN
     C                   MOVE      L_CLFACO      FACO
      *
      * Rollover date
     C                   Z-ADD     L_CLRLDT      RLDT
     C     *IN83         IFEQ      '1'
     C     RLDT_M        ANDNE     *ZERO
     C     NCCY_M        ANDNE     *BLANKS
     C     NCCY_M        ANDNE     CCY_M
     C     L_CLRLDT      ANDEQ     *ZERO
     C                   Z-ADD     RLDT_M        RLDT
     C                   ENDIF
      *
      * Rollover freq
     C                   MOVE      L_CLRLFQ      RLFQ
      *
      * Rollover day
     C                   MOVE      L_CLRLDY      RLDY
      *
      * Round Down Interest Indicato
     C                   MOVE      L_CLRDFC      RDFC
      *
      * Next base rate type
      * Next calculation basis
      * Next change indicator
     C     *IN83         IFEQ      '1'
     C     RLDT_M        ANDNE     *ZERO
     C     NCCY_M        ANDNE     *BLANKS
     C     NCCY_M        ANDNE     CCY_M
     C     NBRA_M        ANDNE     *ZERO
     C                   Z-ADD     NBRA_M        NBRA
     C                   Z-ADD     NCAS_M        NCAS
     C                   MOVE      NCHI_M        NCHI
     C                   ENDIF
      *
      * Base ccy m/d ind
     C                   MOVE      L_CLBMDI      BMDI
      *
      * Facil ccy m/d ind
     C     *IN83         IFEQ      '0'
     C                   MOVE      L_CLFMDI      FMDI
     C                   ELSE
     C                   MOVE      FMDI_M        FMDI
     C                   MOVE      FMDI_M        L_CLFMDI                                     CLE106
     C                   ENDIF
      *
      * Our start date settle branch
      * Our maturity settle branch
     C                   MOVE      L_CLOSDB      OSDB
     C                   MOVE      L_CLOMDB      OMDB
      *
      * Originating branch
     C     *IN83         IFEQ      '0'
     C                   MOVE      L_CLORBR      ORBR
     C                   ELSE
     C                   MOVE      ORBR_M        ORBR
     C                   MOVE      ORBR_M        L_CLORBR                                     CLE106
     C                   ENDIF
      *
      * Profit centre
     C     *IN83         IFEQ      '0'
     C                   MOVE      L_CLPRFC      PRFC
     C                   ELSE
     C                   MOVE      PRFC_M        PRFC
     C                   MOVE      PRFC_M        L_CLPRFC                                     CLE106
     C                   ENDIF
      *
      * Facility Branch Code
     C     *IN83         IFEQ      '0'
     C***********        MOVE      L_CLBRCA      FCLB                                         225363
     C                   MOVE      L_CLFCLB      FCLB                                         225363
     C                   ELSE
     C                   MOVE      FCLB_M        FCLB
     C                   ENDIF
      *
      * Mirror Loan Number
     C     *IN82         IFEQ      '1'
     C                   MOVE      L_CLMLNR      MLNR
     C                   ENDIF
      *
      * Billing/telex indicator
      * Billing days
     C     *IN83         IFEQ      '0'
     C                   MOVE      L_CLBTIN      BTIN
     C                   MOVE      L_CLBLDY      BLDY
     C                   ELSE
     C                   MOVE      'N'           BTIN
     C                   Z-ADD     *ZEROS        BLDY
     C                   ENDIF
      *
      * Original loan number
     C     *IN82         IFEQ      '1'
     C     *IN83         OREQ      '1'
     C                   MOVEL     L_CLOLNO      OLNO
     C                   ENDIF
      *
      * Recourse ind.
     C                   MOVE      L_CLRCSI      RCSI
      *
      * Interest calculation basis
     C                   MOVE      L_CLICBS      ICBS
      *
      * Interest payment frequency
     C                   MOVE      L_CLIPFR      IPFR
      *
      * Total interest
     C                   Z-ADD     L_CLTOTI      TOTI
                                                                                             BUG3721
      ** For flat rate personal loans update total flat interest field (FLTI)                BUG3721
      ** with the computed interest                                                          BUG3721
                                                                                             BUG3721
     C     L_CLPTYP      IFEQ      80                                                        BUG3721
     C     CLE028        ANDEQ     'Y'                                                       BUG3721
     C                   Z-ADD     L_CLFLTI      FLTI                                        BUG3721
     C                   Z-ADD     L_CLFRPD      FRPD                                        BUG3721
     C                   ENDIF                                                               BUG3721
      *
      * Next interest payment date
     C                   Z-ADD     L_CLNIDT      NIDT
      *
      * Interest base date
     C                   Z-ADD     L_CLNIDT      IBDT
      *
      * Start date or last int. date
     C                   Z-ADD     L_CLVDAT      SLID
      *
      * Date of last rate change
     C                   Z-ADD     L_CLVDAT      DLRC
      *
      * Interest accrual control dt
     C                   Z-ADD     L_CLVDAT      IACD
      *
      * Repayment base date
     C                   Z-ADD     L_CLNRPD      RBDT
      *
      * Int freq day in month
     C                   MOVE      L_CLIFDY      IFDY
      *
      * Loan indicators
     C                   BITOFF    '01234567'    LONI
     C                   BITON     '0'           LONI
     C     L_CLPTYP      IFNE      63
     C     L_CLPTYP      ANDNE     65
     C     L_CLPTYP      ANDNE     67
     C     L_CLPTYP      ANDNE     72
     C     L_CLPTYP      OREQ      72
     C     W72TP         ANDNE     '67'
     C                   BITON     '2'           LONI
     C                   ENDIF
      *
      * Confirmation indicators
     C                   MOVE      L_CLCNFI      CNFI
      *
      * Accounting entries indicator
     C                   BITOFF    '01234567'    ACEI
      *
      * Telex indicators
     C                   BITOFF    '01234567'    TLXI
      *
      * Customer bills ind
     C                   BITOFF    '01234567'    CBLI
      *
      * Original entry date
     C                   Z-ADD     BJRDNB        ORED
      *
      * Last change date
     C                   Z-ADD     BJRDNB        LCD
      *
      * Type of last change
     C                   MOVE      L_CLCHTP      CHTP
      *
      * Transact.no of last update
     C                   Z-ADD     NATN          TNLU
      *
      * Additional Day Indicator
     C                   MOVE      L_CLADDI      ADDI
      *
      * Book Code
     C                   MOVE      L_CLBOKC      BOKC
      *
      * Customer Confirmation
     C     S01465        IFEQ      'Y'
     C                   MOVE      L_CLCOCU      COCU
     C                   ENDIF
      *
      * Receiver of the Guarantee
     C     BPGIAV        IFEQ      'Y'
     C                   MOVEL     L_CLRECE      RECE
     C                   ENDIF
      *
      * Automatic Pay at Maturity
     C     S01465        IFEQ      'Y'
     C                   MOVE      L_CLAPMI      APMI
     C                   ENDIF
                                                                                             BUG3721
      ** Move Add on Interest, Add on Charges, Charge Amount and                             BUG3721
      ** Include Charges in Interest from display field to file field                        BUG3721
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C                   MOVE      L_CLADIF      ADIF                                        BUG3721
     C                   MOVE      L_CLADCF      ADCF                                        BUG3721
     C                   Z-ADD     L_CLCHGA      CHGA                                        BUG3721
     C                   MOVE      L_CLICIF      ICIF                                        BUG3721
     C                   ENDIF                                                               BUG3721
      *
      * RECEIPT INSTRUCTIONS
      *
     C                   Z-ADD     L_CLRSTM      RSTM
     C                   MOVE      L_CLRONS      RONS
     C                   MOVE      L_CLRIBN      RIBN
     C                   MOVE      L_CLRIBA      RIBA
     C                   MOVE      L_CLROBN      ROBN
     C                   MOVE      L_CLROCN      ROCN
      *
      * PAYMENT INSTRUCTIONS
      *
     C                   Z-ADD     L_CLPSTM      PSTM
     C                   MOVE      L_CLPONS      PONS
     C                   MOVE      L_CLPIBN      PIBN
     C                   MOVE      L_CLPIBA      PIBA
     C                   MOVE      L_CLPOBN      POBN
     C                   MOVE      L_CLPOCN      POCN
     C                   MOVE      L_CLRCRN      RCRN
     C                   MOVE      L_CLRCRA      RCRA
     C                   MOVE      L_CLRVNO      RVNO
     C                   MOVE      L_CLAWBN      AWBN
     C                   MOVE      L_CLAWBA      AWBA
     C                   MOVE      L_CLBENN      BENN
     C                   MOVE      L_CLBENA      BENA
     C                   MOVE      L_CLDTP1      DTP1
     C                   MOVE      L_CLDTP2      DTP2
     C                   MOVE      L_CLDTP3      DTP3
     C                   MOVE      L_CLDTP4      DTP4
     C                   MOVE      L_CLDCHG      DCHG
     C                   MOVE      L_CLBTB1      BTB1
     C                   MOVE      L_CLBTB2      BTB2
     C                   MOVE      L_CLBTB3      BTB3
     C                   MOVE      L_CLBTB4      BTB4
     C                   MOVE      L_CLBTB5      BTB5
     C                   MOVE      L_CLBTB6      BTB6
     C                   MOVE      L_CLCVMR      CVMR
      *
      * Portfolio reference
     C                   MOVE      L_CLPTFR      PTFR
      *
      * Funding Spread/Rate
      * Funding Sign
      * Funding Profit Centre
     C                   Z-ADD     L_CLFSRP      FSRP
     C     CDE002        IFEQ      'Y'
     C     FSRP          ANDEQ     0
     C     INTR          SUB       L_CLMARG      FSRP
     C     FSRP          IFLT      *ZERO
     C                   Z-ADD     0             FSRP
     C                   ENDIF
     C                   ENDIF
     C                   MOVE      L_CLFSGN      FSGN
     C                   MOVE      L_CLFPRC      FPRC
      *
      * COF Accrual Control Date
     C     BGN0ST        IFEQ      'Y'
     C     CDE002        OREQ      'Y'
     C                   Z-ADD     L_CLVDAT      FCTD
     C                   ENDIF
      *
      * Default Part. Loan Type
      * Default Part. Loan Subtype
     C                   MOVE      L_CLDFTP      DFTP
     C                   MOVE      L_CLDFST      DFST
     C                   MOVE      L_CLDFCL      DFCL                                         CLE042
      *
      * Multi-ccy Rollover Allowed
     C                   MOVE      L_CLMCRA      MCRA
      *
      * Facility Ccy Repayment Amt
     C                   MOVE      L_CLFCRA      FCRA
      *
      * Payment Due Day Indicator
     C                   MOVE      L_CLPDDI      PDDI
      *
      * Payment Taken Day Indicator
     C                   MOVE      L_CLPTDI      PTDI
      *
      * Grace Days for Principal
     C                   MOVE      L_CLGDPR      GDPR
      *
      * Grace Days for Interest
     C                   MOVE      L_CLGDIN      GDIN
      *
      * Linked to Syndicate
     C                   MOVE      L_CLLNKS      LNKS
      *
      * Manual/System Generated
     C                   MOVE      'M'           MNSG
      *
      * Assignment/ Participant
     C                   MOVE      L_CLGASS      GASS
      *
      * Generated by Principal Tfr
     C**********         MOVE      'N'           GPRT                                         245411
     C                   EVAL      GPRT = L_CLGPRT                                            245411
     C                   EVAL      TOLN = L_CLTOLN                                            245411
      *
      * Loan Status Indicator
     C                   MOVE      'A'           LSTS
     C     CLE002        IFEQ      'Y'
     C     *IN82         IFEQ      '1'
     C     BPPPAU        ANDEQ     'Y'
     C     *IN83         OREQ      '1'
     C     BPPSAU        ANDEQ     'Y'
     C     *IN82         OREQ      '0'
     C     *IN83         ANDEQ     '0'
     C     BPLOAU        ANDEQ     'Y'
     C     L_CLAUTH      IFNE      'Y'                                                        CAP086
     C                   MOVE      'C'           LSTS
     C                   ENDIF                                                                CAP086
     C                   ENDIF
     C                   ENDIF
      *
      * Insert User Profile
     C                   IF        CallModCode = 'JVA'                                       BUG9173
     C                   MOVE      PSUser        IUSR
     C                   ELSE                                                                BUG9173
     C                   MOVE      L_CLIUSR      IUSR                                        BUG9173
     C                   ENDIF                                                               BUG9173
      *
      * Consolidated Confirmation
     C     BPCONR        IFEQ      'Y'
     C                   MOVE      'N'           CNCF
     C                   ELSE
     C                   MOVE      *BLANK        CNCF
     C                   ENDIF
      *
      * PC Transaction Reference
     C     PTREF         IFNE      *BLANK
     C*****CLE106        OREQ      'Y'                                                CLE106 CSF011A
     C     CLE106        ANDEQ     'Y'                                                       CSF011A
     C     CLE134        OREQ      'Y'                                                      MD020605
     C     PTREF         ANDNE     *BLANK                                                   MD020605
     C                   MOVEL     PTREF         PCRFL
     C                   ELSE
     C                   MOVE      L_CLBRCA      @BRCD
     C                   EXSR      ACS_BRCA
     C                   IF        A8MQSM <> *BLANKS                            BUG3642
     C                   MOVEL     A8MQSM        W#1ST3            3
     C                   ELSE                                                   BUG3642
     C                   MOVEL     A8BRCD        W#1ST3                         BUG3642
     C                   ENDIF                                                  BUG3642
     C******DTAARA       DEFINE                  LEALLO                                       CLE148
     C******LOCK         IN        LEALLO                                                     CLE148
     C*****PCLAST        ADD       1             PCNEXT            8 0                        CLE148
                                                                                              CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM      'Y'           PUPDT             1                          CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT            8                          CLE148
                                                                                              CLE148
     C                   MOVE      PCNEXT        W1ST11           11
     C                   MOVEL     W#1ST3        W1ST11
     C                   MOVEL     W1ST11        PCRFL
     C                   MOVE      '0001'        PCRFL
     C**********         Z-ADD     PCNEXT        PCLAST                                       CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C                   ENDIF
      *
      * Linked to Part. Facility Ind
      * Participant Facility Custome
      * Participant Facility Type
      * Participant Facility Number
     C                   MOVE      L_CLLPFI      LPFI
     C**********         Z-ADD     L_CLPTFC      PTFC                                         CSD027
     C                   EVAL      PTFC = L_CLPTFC                                            CSD027
     C                   Z-ADD     L_CLPTFT      PTFT
     C                   Z-ADD     L_CLPTFN      PTFN
      *
      * PC Originating Branch
     C                   MOVE      L_CLPCOB      PCOBL
      *
      * Settlement Currency
      * IN Currency in Fld 72
     C     CEU004        IFEQ      'Y'
     C                   MOVE      L_CLSCCY      SCCY
     C                   MOVE      L_CLICCY      ICCY
     C                   ENDIF
      *
      * Original Interest Rate
     C                   Z-ADD     INTR          OINR
      *
      * Original Interest Date
     C                   Z-ADD     L_CLNIDT      OIDT
      *
      * Rollover Rate Fixing Days
     C     CLE011        IFEQ      'Y'
     C                   MOVEL     L_CLRFDY      RFDY
     C                   ENDIF
      *
      * Front Office transaction ID
     C                   MOVE      L_CLFRNT      FRNT                           Front Office ID
      *
      * Repair location
     C                   MOVE      L_CLREPA      REPA                           Repair Location
      *
      * Timestamp
     C                   EVAL      TMST=TimeStamp

      * Yield Curve                                                                           225959
     C     CAS001        IFEQ      'Y'                                                        225959
     C                   MOVEL     L_CLYLDC      FSYLDC                                       225959
     C                   MOVEL     L_CLFYLD      FSFYLD                                       225959
     C                   ENDIF                                                                225959
                                                                                              225959
     C     CAS005        IFEQ      'Y'                                                        225959
     C                   MOVEL     L_CLCPAM      FSCPAM                                       225959
     C                   ENDIF                                                                225959
                                                                                              CLE031
     C                   IF        CLE031 = 'Y'                                               CLE031
     C                   EVAL      SCCY = L_CLSCCY                                          AR943686
     C                   EVAL      REXR = L_CLREXR                                            CLE031
     C                   EVAL      REXI = L_CLREXI                                            CLE031
     C                   EVAL      PSCY = L_CLPSCY                                            CLE031
     C                   EVAL      PEXR = L_CLPEXR                                            CLE031
     C                   EVAL      PEXI = L_CLPEXI                                            CLE031
     C                   IF        MPHAS = 'C'                                              MD051922
     C                   IF        REXR = *ZEROS                                            MD051922
     C                   EVAL      REXI = *BLANKS                                           MD051922
     C                   ENDIF                                                              MD051922
     C                   IF        PEXR = *ZEROS                                            MD051922
     C                   EVAL      PEXI = *BLANKS                                           MD051922
     C                   ENDIF                                                              MD051922
     C                   ENDIF                                                              MD051922
     C                   ENDIF                                                                CLE031
                                                                                              CLE106
     C                   IF        CLE106 = 'Y'                                               CLE106
     C                   EVAL      SLTP = L_CLSLTP                                            CLE106
     C                   EVAL      SLST = L_CLSLST                                            CLE106
     C                   EVAL      SLCL = L_CLSLCL                                            CLE042
     C                   ENDIF                                                                CLE106
                                                                                              CLE106
     C                   EVAL      STAL = L_CLSTAL                                            CLE034
                                                                                              CLE034
      ** Original Contract Date                                                               CLE143
                                                                                              CLE143
     C                   Z-ADD     L_CLOCDT      OCDT                                         CLE143
                                                                                              CLE143
      ** Effective Annual Interest Rate                                                       CLE143
                                                                                              CLE143
     C                   Z-ADD     L_CLEAIR      EAIR                                         CLE143
                                                                                              CLE143
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   Z-ADD     L_CLCNSP      CNSP                                         CRE073
     C                   EVAL      CNSG = L_CLCNSG                                            CRE073
     C                   EVAL      RDMT = L_CLRDMT                                            CRE073
     C                   EVAL      RDFD = L_CLRDFD                                            CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CLE134
      ** If Past Due Processing;                                                              CLE134
      ** Set Miscellaneous Values.                                                            CLE134
                                                                                              CLE134
     C                   IF        CLE134      = 'Y'                                          CLE134
     C                   EVAL      FAMU        = L_CLFAMU                                     CLE134
                                                                                              CLE134
     C                   EVAL      FPNR        = L_CLFPNR                                     CLE134
     C                   EVAL      RICC        = L_CLRICC                                     CLE134
     C                   EVAL      BICC        = L_CLBICC                                     CLE134
                                                                                              CLE134
      ** Set Reporting Values.                                                                CLE134
                                                                                              CLE134
     C                   IF        RIDT       <> L_CLRIDT      AND                            CLE134
     C                             RIDT       <> 0                                            CLE134
     C                   EVAL      RIDC       += 1                                            CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   IF        RCAT       <> L_CLRCAT      AND                            CLE134
     C                             RCAT       <> 0                                            CLE134
     C                   EVAL      RCAC       += 1                                            CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   EVAL      RIDT        = L_CLRIDT                                     CLE134
     C                   EVAL      RCSD        = L_CLRIDT                                     CLE134
     C                   EVAL      RCAT        = L_CLRCAT                                     CLE134
                                                                                              CLE134
     C                   IF        RCAT        > 1                                            CLE134
     C                   IF        DSRCN(RCAT-1) > 0           AND                            CLE134
     C                             DSRCN(RCAT-1) < 999                                        CLE134
     C                   EVAL      RCSD       += DSRCN(RCAT-1)                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   EVAL      RCDY        = DSRCE(RCAT)                                  CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Set Basel II Values.                                                                 CLE134
                                                                                              CLE134
     C                   IF        BIDT       <> L_CLBIDT      AND                            CLE134
     C                             BIDT       <> 0                                            CLE134
     C                   EVAL      BIDC       += 1                                            CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   IF        BCAT       <> L_CLBCAT      AND                            CLE134
     C                             BCAT       <> 0                                            CLE134
     C                   EVAL      BCAC       += 1                                            CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   EVAL      BIDT        = L_CLBIDT                                     CLE134
     C                   EVAL      BCSD        = L_CLBIDT                                     CLE134
     C                   EVAL      BCAT        = L_CLBCAT                                     CLE134
                                                                                              CLE134
     C                   IF        BCAT        > 1                                            CLE134
     C                   IF        DSBCN(BCAT-1) > 0           AND                            CLE134
     C                             DSBCN(BCAT-1) < 999                                        CLE134
     C                   EVAL      BCSD       += DSBCN(BCAT-1)                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   EVAL      BCDY        = DSBCE(BCAT)                                  CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Set Extension Reference.                                                             CLE134
                                                                                              CLE134
     C**********         EXSR      xeXRF                                            CLE134 AR1022006
     C                   EVAL      XRFI = 'CLI'                                            AR1022006
     C                   ENDIF                                                                CLE134
                                                                                              CRE073
     C                   IF        CLE134 = 'Y'                                            AR1021983
     C                   EVAL      ORLN = L_CLORLN                                         AR1021983
     C                   EVAL      OFCU = L_CLOFCU                                         AR1021983
     C                   EVAL      OFAC = L_CLOFAC                                         AR1021983
     C                   EVAL      OFES = L_CLOFES                                         AR1021983
     C                   EVAL      OFSQ = L_CLOFSQ                                         AR1021983
     C                   EVAL      OFLN = L_CLOFLN                                         AR1021983
     C                   ENDIF                                                             AR1021983
                                                                                           AR1021983
     C                   IF        CLE141 = 'Y'                                               CLE141
     C                   EVAL      C1PR = L_CLC1PR                                            CLE141
     C                   EVAL      C2PR = L_CLC2PR                                            CLE141
     C                   EVAL      C3PR = L_CLC3PR                                            CLE141
     C                   EVAL      C4PR = L_CLC4PR                                            CLE141
     C                   EVAL      C5PR = L_CLC5PR                                            CLE141
     C                   EVAL      C6PR = L_CLC6PR                                            CLE141
     C                   EVAL      C7PR = L_CLC7PR                                            CLE141
     C                   EVAL      C8PR = L_CLC8PR                                            CLE141
     C                   EVAL      C9PR = L_CLC9PR                                            CLE141
     C                   EVAL      C0PR = L_CLC0PR                                            CLE141
     C                   EVAL      L1PR = L_CLL1PR                                            CLE141
     C                   EVAL      L2PR = L_CLL2PR                                            CLE141
     C                   EVAL      L3PR = L_CLL3PR                                            CLE141
     C                   EVAL      L4PR = L_CLL4PR                                            CLE141
     C                   EVAL      L5PR = L_CLL5PR                                            CLE141
     C                   EVAL      L6PR = L_CLL6PR                                            CLE141
     C                   EVAL      L7PR = L_CLL7PR                                            CLE141
     C                   EVAL      L8PR = L_CLL8PR                                            CLE141
     C                   EVAL      L9PR = L_CLL9PR                                            CLE141
     C                   EVAL      L0PR = L_CLL0PR                                            CLE141
     C                   EVAL      C1PI = L_CLC1PI                                            CLE141
     C                   EVAL      C2PI = L_CLC2PI                                            CLE141
     C                   EVAL      C3PI = L_CLC3PI                                            CLE141
     C                   EVAL      C4PI = L_CLC4PI                                            CLE141
     C                   EVAL      C5PI = L_CLC5PI                                            CLE141
     C                   EVAL      C6PI = L_CLC6PI                                            CLE141
     C                   EVAL      C7PI = L_CLC7PI                                            CLE141
     C                   EVAL      C8PI = L_CLC8PI                                            CLE141
     C                   EVAL      C9PI = L_CLC9PI                                            CLE141
     C                   EVAL      C0PI = L_CLC0PI                                            CLE141
     C                   EVAL      L1PI = L_CLL1PI                                            CLE141
     C                   EVAL      L2PI = L_CLL2PI                                            CLE141
     C                   EVAL      L3PI = L_CLL3PI                                            CLE141
     C                   EVAL      L4PI = L_CLL4PI                                            CLE141
     C                   EVAL      L5PI = L_CLL5PI                                            CLE141
     C                   EVAL      L6PI = L_CLL6PI                                            CLE141
     C                   EVAL      L7PI = L_CLL7PI                                            CLE141
     C                   EVAL      L8PI = L_CLL8PI                                            CLE141
     C                   EVAL      L9PI = L_CLL9PI                                            CLE141
     C                   EVAL      L0PI = L_CLL0PI                                            CLE141
     C                   ENDIF                                                                CLE141
                                                                                              CLE164
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * LONL_AMD -  Format CLOANCL fields for AMEND                   *
      *****************************************************************
     C     LONL_AMD      BEGSR
      ***  If maturity date is changed and autosettle indicator
      ***  is 'N', set off maturity accounting indicator
      *
     C     L_CLMDAT      IFNE      MDAT
     C     L_CLAUTO      ANDEQ     'N'
     C                   BITOFF    '2'           ACEI
     C                   ENDIF
      *
      ***  If next interest payment date is amended and is less than
      ***  the maturity date, reset bit 2 (interest) of telex indicator
      ***  to generate new message.
      *
     C                   MOVE      L_CLAUTO      WAUTOC            1                          CLE134
     C     WAUTOC        IFEQ      'C'                                                        CLE134
     C     CLE134        ANDEQ     'Y'                                                        CLE134
     C                   MOVE      'Y'           WAUTOC                                       CLE134
     C                   END                                                                  CLE134
      *                                                                                       CLE134
     C     L_CLNIDT      IFNE      *ZERO
     C     L_CLNIDT      ANDLT     L_CLMDAT
     C*****L_CLAUTO      ANDEQ     'Y'                                                        CLE134
     C     WAUTOC        ANDEQ     'Y'                                                        CLE134
     C     L_CLAUTO      ANDEQ     AUTO
     C     L_CLNIDT      ANDNE     NIDT
     C     BJRDNB        ANDGT     ORED
     C                   BITOFF    '2'           TLXI
     C                   ENDIF
      *
      ***  If next repayment date is amended and is less than
      ***  the maturity date, reset bit 3(repayment) of telex indicator
      ***  to generate new message.
      *
     C     L_CLNRPD      IFNE      *ZERO
     C     L_CLNRPD      ANDLT     L_CLMDAT
     C*****L_CLAUTO      ANDEQ     'Y'                                                        CLE134
     C     WAUTOC        ANDEQ     'Y'                                                        CLE134
     C     L_CLAUTO      ANDEQ     AUTO
     C     L_CLNRPD      ANDNE     NRPD
     C     BJRDNB        ANDGT     ORED
     C                   BITOFF    '3'           TLXI
     C                   ENDIF
      *
      ***  If maturity is amended and is less than the prior maturity date
      ***  (early mature), reset bit 1 (Maturity) of field TLXI to
      ***  generate new message.
      *
     C     L_CLMDAT      IFNE      *ZERO
     C*****L_CLAUTO      ANDEQ     'Y'                                                        CLE134
     C     WAUTOC        ANDEQ     'Y'                                                        CLE134
     C     L_CLAUTO      ANDEQ     AUTO
     C     L_CLMDAT      ANDLT     MDAT
     C     BJRDNB        ANDGT     ORED
     C                   BITOFF    '1'           TLXI
     C                   ENDIF
      *
      ***  Customer bills for amend
      *
     C     L_CLNIDT      IFNE      NIDT
     C                   TESTB     '0'           CBLI                     87
     C     *IN87         IFEQ      '1'
     C                   BITON     '1'           CBLI
     C                   ENDIF
     C                   ENDIF
     C     L_CLNRPD      IFNE      NRPD
     C     L_CLNRPD      OREQ      NRPD
     C     L_CLRAMT      ANDNE     RAMT
     C                   TESTB     '2'           CBLI                     87
     C     *IN87         IFEQ      '1'
     C                   BITON     '3'           CBLI
     C                   ENDIF
     C                   ENDIF
     C     L_CLMDAT      IFEQ      *ZEROS
     C                   TESTB     '4'           CBLI                     87
     C     *IN87         IFEQ      '1'
     C                   BITOFF    '45'          CBLI
     C                   ENDIF
     C                   ENDIF
     C     L_CLMDAT      IFNE      MDAT
     C                   TESTB     '4'           CBLI                     87
     C     *IN87         IFEQ      '1'
     C                   BITON     '5'           CBLI
     C                   ENDIF
     C                   ENDIF
      *
      * Original maturity date
      *
     C     S01465        IFEQ      'Y'
     C     L_CLMDAT      ANDNE     MDAT
     C                   Z-ADD     MDAT          OMDT
     C                   ENDIF
      *
      *----------------------------------------------------------------
      *
      * Maturity date
     C                   Z-ADD     L_CLMDAT      MDAT
      *
      * Margin
     C                   Z-ADD     L_CLMARG      MARG
      *
      * Withholding tax rate
     C                   Z-ADD     L_CLWTRT      WTRT
      *
      * Withholding tax indicator
     C                   MOVE      L_CLWTIN      WTIN
      *
      * Repayment amount
     C                   Z-ADD     L_CLRAMT      RAMT
      *
      * Next repayment date
     C                   Z-ADD     L_CLNRPD      NRPD
      *
      * Repayment frequency
     C                   MOVE      L_CLRFRQ      RFRQ
      *
      * Repayment day no.
     C                   MOVE      L_CLRDYN      RDYN
      *
      * Local industry code
     C     *IN83         IFEQ      '0'
     C**********         MOVE      L_CLLIND      LIND                                         CER020
     C                   MOVE      L_CLLOIC      LOIC                                         CER020
     C                   ELSE
     C**********         MOVE      LIND_M        LIND                                         CER020
     C                   MOVE      LIND_M        LOIC                                         CER020
     C                   ENDIF
      *
      * Country of risk
     C     *IN83         IFEQ      '0'
     C                   MOVE      L_CLCRSK      CRSK
     C                   ELSE
     C                   MOVE      CRSK_M        CRSK
     C                   ENDIF
      *
      * Account officer
     C                   MOVE      L_CLACOF      ACOF
      *
      * Name and address code
     C                   MOVE      L_CLNACD      NACD
      *
      * Indicators: secured/doc/fee
     C                   MOVE      L_CLRELI      RELI
      *
      * Auto settlement indicator
     C                   MOVE      L_CLAUTO      AUTO
      *
      * Start date settlement type
      * Our start date account
      * Their start nostro
      * Maturity date settlement typ
      * Our maturity date account
      * Their maturity nostro
      * For account of
     C                   Z-ADD     L_CLSDST      SDST
     C                   MOVE      L_CLOSDA      OSDA
     C                   MOVE      L_CLTSTN      TSTN
     C                   Z-ADD     L_CLMDST      MDST
     C                   MOVE      L_CLOMDA      OMDA
     C                   MOVE      L_CLTMAN      TMAN
     C                   MOVE      L_CLFACO      FACO
      *
      * Our start date settle branch
      * Our maturity settle branch
     C                   MOVE      L_CLOSDB      OSDB
     C                   MOVE      L_CLOMDB      OMDB
      *
      * Originating branch
     C     *IN83         IFEQ      '0'
     C                   MOVE      L_CLORBR      ORBR
     C                   ELSE
     C                   MOVE      ORBR_M        ORBR
     C                   ENDIF
      *
      * Profit centre
     C     *IN83         IFEQ      '0'
     C                   MOVE      L_CLPRFC      PRFC
     C                   ELSE
     C                   MOVE      PRFC_M        PRFC
     C                   ENDIF
      *
      * Billing/telex indicator
      * Billing days
     C     *IN83         IFEQ      '0'
     C                   MOVE      L_CLBTIN      BTIN
     C                   MOVE      L_CLBLDY      BLDY
     C                   ELSE
     C                   MOVE      'N'           BTIN
     C                   Z-ADD     *ZEROS        BLDY
     C                   ENDIF
      *
      * Original loan number
     C     *IN82         IFEQ      '1'
     C     *IN83         OREQ      '1'
     C                   MOVEL     L_CLOLNO      OLNO
     C                   ENDIF
      *
      * Original interest date
     C                   Z-ADD     L_CLNIDT      OIDT
      *
      * Recourse ind.
     C                   MOVE      L_CLRCSI      RCSI
      *
      * Interest payment frequency
     C                   MOVE      L_CLIPFR      IPFR
      *
      * Total interest
     C                   Z-ADD     L_CLTOTI      TOTI
                                                                                             BUG3721
      ** For flat rate personal loans update total flat interest field (FLTI)                BUG3721
      ** with the computed interest                                                          BUG3721
                                                                                             BUG3721
     C     L_CLPTYP      IFEQ      80                                                        BUG3721
     C     CLE028        ANDEQ     'Y'                                                       BUG3721
     C     BJRDNB        ANDEQ     ORED                                                      BUG3721
     C                   Z-ADD     L_CLFLTI      FLTI                                        BUG3721
     C                   Z-ADD     L_CLFRPD      FRPD                                        BUG3721
     C                   ENDIF                                                               BUG3721
      *
      * Next interest payment date
     C                   Z-ADD     L_CLNIDT      NIDT
      *
      * Interest base date
     C                   Z-ADD     L_CLNIDT      IBDT
      *
      * Repayment base date
     C                   Z-ADD     L_CLNRPD      RBDT
      *
      * Int freq day in month
     C                   MOVE      L_CLIFDY      IFDY
      *
      * Confirmation indicators
     C                   MOVE      L_CLCNFI      CNFI
      *
      * Last change date
     C                   Z-ADD     BJRDNB        LCD
      *
      * Type of last change
     C                   MOVE      L_CLCHTP      CHTP
      *
      * Transact.no of last update
     C                   Z-ADD     NATN          TNLU
      *
      * Original maturity date
      * Original total interest
      *
     C     L_CLPTYP      IFEQ      63
     C     L_CLPTYP      OREQ      65
     C     L_CLPTYP      OREQ      67
     C     L_CLPTYP      OREQ      72
     C     W72TP         ANDEQ     '67'
     C                   Z-ADD     L_CLORMD      ORMD
     C                   Z-ADD     L_CLORTI      ORTI
     C                   ENDIF
      *
      * Book Code
     C                   MOVE      L_CLBOKC      BOKC
      *
      * Customer Confirmation
     C     S01465        IFEQ      'Y'
     C                   MOVE      L_CLCOCU      COCU
     C                   ENDIF
      *
      * Receiver of the Guarantee
     C     BPGIAV        IFEQ      'Y'
     C                   MOVEL     L_CLRECE      RECE
     C                   ENDIF
      *
      * Automatic Pay at Maturity
     C     S01465        IFEQ      'Y'
     C                   MOVE      L_CLAPMI      APMI
     C                   ENDIF
                                                                                             BUG3721
      ** Move Add on Interest, Add on Charges, Charge Amount and                             BUG3721
      ** Include Charges in Interest from display field to file field                        BUG3721
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     BJRDNB        ANDEQ     ORED                                                      BUG3721
     C                   MOVE      L_CLADIF      ADIF                                        BUG3721
     C                   MOVE      L_CLADCF      ADCF                                        BUG3721
     C                   Z-ADD     L_CLCHGA      CHGA                                        BUG3721
     C                   MOVE      L_CLICIF      ICIF                                        BUG3721
     C                   ENDIF                                                               BUG3721
      *                                                                                     MD020242
      ** If there is a change in Pay Settlement details, store old                          MD020242
      ** details in PF/LELSUTPD for later use in authorisation                              MD020242
      *                                                                                     MD020242
     C                   MOVE      *Blank        WPayChg           1                        MD020242
     C                   IF        CLE055 = 'Y'                                             MD020242
     C                             AND LSTS <> 'C'                                         MD020361A
     C                   IF        PSTM <> L_CLPSTM                                         MD020242
     C                             OR PONS <> L_CLPONS                                      MD020242
      *                                                                                    MD020361A
      ** Check first if there is an unprocessed amendment in Pay                           MD020361A
      ** Settlement, no need to write a new record if there is                             MD020361A
      *                                                                                     MD020242
     C                   MOVE      L_CLLNRF      KPLnrf                                    MD020361A
     C                   Z-ADD     BJRDNB        KPDate                                    MD020361A
     C     KPSETD        SETLL     LELSUTD0                                                MD020361A
     C     KPSETD        READE     LELSUTD0                               60               MD020361A
     C                   IF        *IN60 = '1'                                             MD020361A
     C                   Z-ADD     PSTM          MBPSTM                                     MD020242
     C                   MOVE      PONS          MBPONS                                     MD020242
     C                   Z-ADD     L_CLPSTM      MAPSTM                                     MD020242
     C                   MOVE      L_CLPONS      MAPONS                                     MD020242
     C                   MOVE      L_CLLNRF      MLLNRF                                     MD020242
     C                   Z-ADD     BJRDNB        MLDAT                                      MD020242
     C                   Z-ADD     NATN          MLTNLU                                     MD020242
     C                   EVAL      MLProcF = 'N'                                            MD020242
     C                   EVAL      WPayChg = 'Y'                                            MD020242
     C                   ELSE                                                              MD020361A
      ** Set indicator to record 'E'xists                                                  MD020361A
     C                   EVAL      WPayChg = 'E'                                           MD020361A
     C                   ENDIF                                                             MD020361A
      *                                                                                     MD020242
     C                   ENDIF                                                              MD020242
     C                   ENDIF                                                              MD020242
      *
      * RECEIPT INSTRUCTIONS
      *
     C                   Z-ADD     L_CLRSTM      RSTM
     C                   MOVE      L_CLRONS      RONS
     C                   MOVE      L_CLRIBN      RIBN
     C                   MOVE      L_CLRIBA      RIBA
     C                   MOVE      L_CLROBN      ROBN
     C                   MOVE      L_CLROCN      ROCN
      *
      * PAYMENT INSTRUCTIONS
      *
     C                   Z-ADD     L_CLPSTM      PSTM
     C                   MOVE      L_CLPONS      PONS
     C                   MOVE      L_CLPIBN      PIBN
     C                   MOVE      L_CLPIBA      PIBA
     C                   MOVE      L_CLPOBN      POBN
     C                   MOVE      L_CLPOCN      POCN
     C                   MOVE      L_CLRCRN      RCRN
     C                   MOVE      L_CLRCRA      RCRA
     C                   MOVE      L_CLRVNO      RVNO
     C                   MOVE      L_CLAWBN      AWBN
     C                   MOVE      L_CLAWBA      AWBA
     C                   MOVE      L_CLBENN      BENN
     C                   MOVE      L_CLBENA      BENA
     C                   MOVE      L_CLDTP1      DTP1
     C                   MOVE      L_CLDTP2      DTP2
     C                   MOVE      L_CLDTP3      DTP3
     C                   MOVE      L_CLDTP4      DTP4
     C                   MOVE      L_CLDCHG      DCHG
     C                   MOVE      L_CLBTB1      BTB1
     C                   MOVE      L_CLBTB2      BTB2
     C                   MOVE      L_CLBTB3      BTB3
     C                   MOVE      L_CLBTB4      BTB4
     C                   MOVE      L_CLBTB5      BTB5
     C                   MOVE      L_CLBTB6      BTB6
     C                   MOVE      L_CLCVMR      CVMR
      *
      * Portfolio reference
     C                   MOVE      L_CLPTFR      PTFR
      *
      * Funding Spread/Rate
      * Funding Sign
      * Funding Profit Centre
     C                   Z-ADD     L_CLFSRP      FSRP
     C                   MOVE      L_CLFSGN      FSGN
     C                   MOVE      L_CLFPRC      FPRC
      *
      * Default Part. Loan Type
      * Default Part. Loan Subtype
     C                   MOVE      L_CLDFTP      DFTP
     C                   MOVE      L_CLDFST      DFST
     C                   MOVE      L_CLDFCL      DFCL                                         CLE042
      *
      * Multi-ccy Rollover Allowed
     C                   MOVE      L_CLMCRA      MCRA
      *
      * Facility Ccy Repayment Amt
     C                   MOVE      L_CLFCRA      FCRA
      *
      * Payment Due Day Indicator
     C                   MOVE      L_CLPDDI      PDDI
      *
      * Payment Taken Day Indicator
     C                   MOVE      L_CLPTDI      PTDI
      *
      * Grace Days for Principal
     C                   MOVE      L_CLGDPR      GDPR
      *
      * Grace Days for Interest
     C                   MOVE      L_CLGDIN      GDIN
      *
      * Linked to Syndicate
     C                   MOVE      L_CLLNKS      LNKS
      *
      * Loan Status Indicator
     C     CLE002        IFEQ      'Y'
     C     *IN82         IFEQ      '1'
     C     BPPPAU        ANDEQ     'Y'
     C     *IN83         OREQ      '1'
     C     BPPSAU        ANDEQ     'Y'
     C     *IN82         OREQ      '0'
     C     *IN83         ANDEQ     '0'
     C     BPLOAU        ANDEQ     'Y'
     C     LSTS          IFEQ      'A'
     C     LSTS          OREQ      'R'
     C                   MOVE      'R'           LSTS
     C                   ELSE
     C                   MOVE      'C'           LSTS
     C                   ENDIF
     C                   ELSE
     C                   MOVE      'A'           LSTS
     C                   ENDIF
     C                   ENDIF
      *                                                                                       CAP086
      ** Check for Automatic Authorisation                                                    CAP086
      *                                                                                       CAP086
     C     L_CLAUTH      IFEQ      'Y'                                                        CAP086
     C                   MOVE      'A'           LSTS                                         CAP086
     C                   ENDIF                                                                CAP086
      *                                                                                     AR804863
     C     @ACTRV        IFEQ      'Y'                                                      AR804863
     C                   MOVE      'A'           LSTS                                       AR804863
     C                   ENDIF                                                              AR804863
      *
      * Amend User Profile
     C                   IF        CallModCode = 'JVA'                                       BUG9173
     C                   MOVE      PSUser        AUSR
     C                   ELSE                                                                BUG9173
     C                   MOVE      L_CLAUSR      AUSR                                        BUG9173
     C                   ENDIF                                                               BUG9173
      *
      * Consolidated Confirmation
     C     BPCONR        IFEQ      'Y'
     C                   MOVE      'N'           CNCF
     C                   ELSE
     C                   MOVE      *BLANK        CNCF
     C                   ENDIF
      *
      * Settlement Currency
      * IN Currency in Fld 72
     C     CEU004        IFEQ      'Y'
     C                   MOVE      L_CLSCCY      SCCY
     C                   MOVE      L_CLICCY      ICCY
     C                   ENDIF
      *
      * Rollover Rate Fixing Days
     C     CLE011        IFEQ      'Y'
     C                   MOVEL     L_CLRFDY      RFDY
     C                   ENDIF
      *
      * Front Office transaction ID
     C                   MOVE      L_CLFRNT      FRNT                           Front Office ID
      *
      * Repair location
     C                   MOVE      L_CLREPA      REPA                           Repair Location
      *
      * Timestamp
     C                   EVAL      TMST=TimeStamp
      * Yield Curve                                                             225959
     C     CAS001        IFEQ      'Y'                                          225959
     C                   MOVEL     L_CLYLDC      FSYLDC                         225959
     C                   MOVEL     L_CLFYLD      FSFYLD                         225959
     C                   ENDIF                                                  225959
                                                                                225959
     C     CAS005        IFEQ      'Y'                                          225959
     C                   MOVEL     L_CLCPAM      FSCPAM                         225959
     C                   ENDIF                                                  225959
                                                                                              CLE031
     C                   IF        CLE031 = 'Y'                                               CLE031
     C                   EVAL      SCCY = L_CLSCCY                                          AR943686
     C                   EVAL      REXR = L_CLREXR                                            CLE031
     C                   EVAL      REXI = L_CLREXI                                            CLE031
     C                   EVAL      PSCY = L_CLPSCY                                            CLE031
     C                   EVAL      PEXR = L_CLPEXR                                            CLE031
     C                   EVAL      PEXI = L_CLPEXI                                            CLE031
     C                   IF        MPHAS = 'C'                                              MD051922
     C                   IF        REXR = *ZEROS                                            MD051922
     C                   EVAL      REXI = *BLANKS                                           MD051922
     C                   ENDIF                                                              MD051922
     C                   IF        PEXR = *ZEROS                                            MD051922
     C                   EVAL      PEXI = *BLANKS                                           MD051922
     C                   ENDIF                                                              MD051922
     C                   ENDIF                                                              MD051922
     C                   ENDIF                                                                CLE031
                                                                                              CLE106
     C                   IF        CLE106 = 'Y'                                               CLE106
     C                   EVAL      SLTP = L_CLSLTP                                            CLE106
     C                   EVAL      SLST = L_CLSLST                                            CLE106
     C                   EVAL      SLCL = L_CLSLCL                                            CLE042
     C                   ENDIF                                                                CLE106

     C                   EVAL      STAL = L_CLSTAL                                            CLE034
                                                                                              CLE034
      ** Original Contract Date                                                               CLE143
                                                                                              CLE143
     C                   Z-ADD     L_CLOCDT      OCDT                                         CLE143
                                                                                              CLE143
      ** Effective Annual Interest Rate                                                       CLE143
                                                                                              CLE143
     C                   Z-ADD     L_CLEAIR      EAIR                                         CLE143
                                                                                              CLE143
      ** If Past Due Processing;                                                              CLE134
      ** Set Miscellaneous Values.                                                            CLE134
                                                                                              CLE134
     C                   IF        CLE134      = 'Y'                                          CLE134
     C                   EVAL      FAMU        = L_CLFAMU                                     CLE134
                                                                                              CLE134
     C                   EVAL      FPNR        = L_CLFPNR                                     CLE134
     C                   EVAL      RICC        = L_CLRICC                                     CLE134
     C                   EVAL      BICC        = L_CLBICC                                     CLE134
                                                                                              CLE134
      ** Set Reporting Values.                                                                CLE134
                                                                                              CLE134
     C                   IF        RIDT       <> L_CLRIDT      AND                            CLE134
     C                             RIDT       <> 0                                            CLE134
     C                   EVAL      RIDC       += 1                                            CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   IF        RCAT       <> L_CLRCAT      AND                            CLE134
     C                             RCAT       <> 0                                            CLE134
     C                   EVAL      RCAC       += 1                                            CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   EVAL      RIDT        = L_CLRIDT                                     CLE134
     C                   EVAL      RCSD        = L_CLRIDT                                     CLE134
     C                   EVAL      RCAT        = L_CLRCAT                                     CLE134
                                                                                              CLE134
     C                   IF        RCAT        > 1                                            CLE134
     C                   IF        DSRCN(RCAT-1) > 0           AND                            CLE134
     C                             DSRCN(RCAT-1) < 999                                        CLE134
     C                   EVAL      RCSD       += DSRCN(RCAT-1)                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   EVAL      RCDY        = DSRCE(RCAT)                                  CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Set Basel II Values.                                                                 CLE134
                                                                                              CLE134
     C                   IF        BIDT       <> L_CLBIDT      AND                            CLE134
     C                             BIDT       <> 0                                            CLE134
     C                   EVAL      BIDC       += 1                                            CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   IF        BCAT       <> L_CLBCAT      AND                            CLE134
     C                             BCAT       <> 0                                            CLE134
     C                   EVAL      BCAC       += 1                                            CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   EVAL      BIDT        = L_CLBIDT                                     CLE134
     C                   EVAL      BCSD        = L_CLBIDT                                     CLE134
     C                   EVAL      BCAT        = L_CLBCAT                                     CLE134
                                                                                              CLE134
     C                   IF        BCAT        > 1                                            CLE134
     C                   IF        DSBCN(BCAT-1) > 0           AND                            CLE134
     C                             DSBCN(BCAT-1) < 999                                        CLE134
     C                   EVAL      BCSD       += DSBCN(BCAT-1)                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   EVAL      BCDY        = DSBCE(BCAT)                                  CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** Set Extension Reference.                                                             CLE134
                                                                                              CLE134
     C                   IF        XRFI        = *BLANKS       OR                             CLE134
     C                             XRFN        = 0                                            CLE134
     C**********         EXSR      xeXRF                                            CLE134 AR1022006
     C                   EVAL      XRFI = 'CLI'                                            AR1022006
     C                   ENDIF                                                                CLE134
                                                                                            AR545441
      ***If*Auto-settle*is*not*'C'*and*a*record*exists*in*LEACCNPD****               AR545441 CLE164
      ***then*delete*LEACCNPD*****************************************               AR545441 CLE164
                                                                                            AR545441
     C**********         IF        AUTO        <> 'C'                                AR545441 CLE164
     C**********         EVAL      KRPLNRF     = L_CLLNRF                            AR545441 CLE164
     C*****KLEACCNLA     CHAIN(E)  LEACCNLA                                          AR545441 CLE164
                                                                                            AR545441
      ***if*record*exists,*delete*it**********************************               AR545441 CLE164
                                                                                            AR545441
     C**********         IF        %FOUND(LEACCNLA)                                  AR545441 CLE164
     C**********         DELETE    LEACCND0                                          AR545441 CLE164
     C**********         ENDIF                                                       AR545441 CLE164
                                                                                            AR545441
     C**********         ENDIF                                                       AR545441 CLE164
                                                                                            AR545441
      ***If*Pre-check*Order;******************************************                 CLE134 CLE164
      ***Retrieve*Repayment*Priority*Details.*************************                 CLE134 CLE164
                                                                                              CLE134
     C**********         IF        AUTO        = 'C'                                   CLE134 CLE164
     C**********         EVAL      KRPLNRF     = LNRF                                  CLE134 CLE164
     C*****KLEACCNLA     CHAIN(E)  LEACCNLA                                            CLE134 CLE164
                                                                                              CLE134
     C**********         IF        %ERROR                                              CLE134 CLE164
     C**********         MOVEL     '*ERROR '     @@RTCD                                262431 CLE164
     C**********         EVAL      DBFILE      = 'LEACCNLA'                            CLE134 CLE164
     C**********         MOVE(P)   KRPLNRF       DBKEY                                 CLE134 CLE164
     C**********         EVAL      DBASE       = 250                                   CLE134 CLE164
     C**********         EXSR      *PSSR                                               CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
                                                                                              CLE134
      ***Set*&*Update*Repayment*Priority*Details**********************                 CLE134 CLE164
      ***(if*Settlement*A/c*Changed)**********************************                 CLE134 CLE164
                                                                                              CLE134
     C**********         IF        %FOUND(LEACCNLA)                                    CLE134 CLE164
     C**********         EVAL      DSCNUM      = RPCNUM                                CLE134 CLE164
     C**********         EVAL      DSACOD      = RPACOD                                CLE134 CLE164
     C**********         EVAL      DSACSQ      = RPACSQ                                CLE134 CLE164
     C**********         EVAL      DSBRCA      = RPBRCA                                CLE134 CLE164
     C**********         EVAL      DSACCY      = RPACCY                                CLE134 CLE164
     C**********         EXSR      xsACCN                                              CLE134 CLE164
                                                                                              CLE134
     C**********         IF        DSCNUM     <> RPCNUM        OR                      CLE134 CLE164
     C**********                   DSACOD     <> RPACOD        OR                      CLE134 CLE164
     C**********                   DSACSQ     <> RPACSQ        OR                      CLE134 CLE164
     C**********                   DSBRCA     <> RPBRCA        OR                      CLE134 CLE164
     C**********                   DSACCY     <> RPACCY                                CLE134 CLE164
     C**********         UPDATE(E) LEACCND0                                            CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
                                                                                              CLE134
      ***Set*&*Write*Repayment*Priority*Details.**********************                 CLE134 CLE164
                                                                                              CLE134
     C**********         ELSE                                                          CLE134 CLE164
     C**********         EXSR      xsACCN                                              CLE134 CLE164
     C**********         WRITE(E)  LEACCND0                                            CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
                                                                                              CLE134
     C**********         IF        %ERROR                                              CLE134 CLE164
     C**********         MOVEL     '*ERROR '     @@RTCD                                262431 CLE164
     C**********         EVAL      DBFILE      = 'LEACCNLA'                            CLE134 CLE164
     C**********         MOVE(P)   KRPLNRF       DBKEY                                 CLE134 CLE164
     C**********         EVAL      DBASE       = 251                                   CLE134 CLE164
     C**********         EXSR      *PSSR                                               CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
                                                                                              CLE034
      ** Currency and Location Business Day Convention                                        CLE141
                                                                                              CLE141
     C                   IF        CLE141 = 'Y'                                               CLE141
     C                   EVAL      C1PR = L_CLC1PR                                            CLE141
     C                   EVAL      C2PR = L_CLC2PR                                            CLE141
     C                   EVAL      C3PR = L_CLC3PR                                            CLE141
     C                   EVAL      C4PR = L_CLC4PR                                            CLE141
     C                   EVAL      C5PR = L_CLC5PR                                            CLE141
     C                   EVAL      C6PR = L_CLC6PR                                            CLE141
     C                   EVAL      C7PR = L_CLC7PR                                            CLE141
     C                   EVAL      C8PR = L_CLC8PR                                            CLE141
     C                   EVAL      C9PR = L_CLC9PR                                            CLE141
     C                   EVAL      C0PR = L_CLC0PR                                            CLE141
     C                   EVAL      L1PR = L_CLL1PR                                            CLE141
     C                   EVAL      L2PR = L_CLL2PR                                            CLE141
     C                   EVAL      L3PR = L_CLL3PR                                            CLE141
     C                   EVAL      L4PR = L_CLL4PR                                            CLE141
     C                   EVAL      L5PR = L_CLL5PR                                            CLE141
     C                   EVAL      L6PR = L_CLL6PR                                            CLE141
     C                   EVAL      L7PR = L_CLL7PR                                            CLE141
     C                   EVAL      L8PR = L_CLL8PR                                            CLE141
     C                   EVAL      L9PR = L_CLL9PR                                            CLE141
     C                   EVAL      L0PR = L_CLL0PR                                            CLE141
     C                   EVAL      C1PI = L_CLC1PI                                            CLE141
     C                   EVAL      C2PI = L_CLC2PI                                            CLE141
     C                   EVAL      C3PI = L_CLC3PI                                            CLE141
     C                   EVAL      C4PI = L_CLC4PI                                            CLE141
     C                   EVAL      C5PI = L_CLC5PI                                            CLE141
     C                   EVAL      C6PI = L_CLC6PI                                            CLE141
     C                   EVAL      C7PI = L_CLC7PI                                            CLE141
     C                   EVAL      C8PI = L_CLC8PI                                            CLE141
     C                   EVAL      C9PI = L_CLC9PI                                            CLE141
     C                   EVAL      C0PI = L_CLC0PI                                            CLE141
     C                   EVAL      L1PI = L_CLL1PI                                            CLE141
     C                   EVAL      L2PI = L_CLL2PI                                            CLE141
     C                   EVAL      L3PI = L_CLL3PI                                            CLE141
     C                   EVAL      L4PI = L_CLL4PI                                            CLE141
     C                   EVAL      L5PI = L_CLL5PI                                            CLE141
     C                   EVAL      L6PI = L_CLL6PI                                            CLE141
     C                   EVAL      L7PI = L_CLL7PI                                            CLE141
     C                   EVAL      L8PI = L_CLL8PI                                            CLE141
     C                   EVAL      L9PI = L_CLL9PI                                            CLE141
     C                   EVAL      L0PI = L_CLL0PI                                            CLE141
     C                   ENDIF
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * LONL_AUT -  Format CLOANCL fields for AUTHORISE               *
      *****************************************************************
     C     LONL_AUT      BEGSR
      *
      ***  Authorisation
      *
     C     L_CLCHTP      IFEQ      'X'
     C                   MOVE      LSTS          WPLsts            1                        MD020242
      *
      * Loan Status
     C     L_CLLSTS      IFEQ      'Q'
     C                   MOVE      'Q'           LSTS
     C                   ELSE
     C                   MOVE      'A'           LSTS
     C                   ENDIF
      *
      ** Release procesing
      *
     C                   ELSE
      *
      * Loan Status
     C                   MOVE      'A'           LSTS
      *
     C                   ENDIF
      *
      * Authorising user
     C                   IF        CallModCode = 'JVA'                                       BUG9173
     C                   MOVE      PSUser        XUSR
     C                   ELSE                                                                BUG9173
     C                   MOVE      L_CLXUSR      XUSR                                        BUG9173
     C                   ENDIF                                                               BUG9173
      *
      * TNLU
     C                   Z-ADD     NATN          TNLU
      *
      * Last Change Date
     C                   Z-ADD     BJRDNB        LCD
      *                                                                                     MD040789
      ** Confirmation inds.                                                                 MD040789
      *                                                                                     MD040789
     C                   MOVE      L_CLCNFI      CNFI                                       MD040789
      *
      * Front Office ID
     C                   MOVE      L_CLFRNT      FRNT                           Front Office ID
      *
      * Repair location
     C                   MOVE      L_CLREPA      REPA                           Repair Location
      *
      * Timestamp
     C                   EVAL      TMST=TimeStamp

     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * LONL_REV -  Format CLOANCL fields for REVERSE                *
      *****************************************************************
     C     LONL_REV      BEGSR
      *
      * Record ID
     C                   MOVE      'R'           RECI
      *
      * Status
     C                   MOVE      'A'           LSTS
      *
      * Confirmation inds.
     C                   MOVE      L_CLCNFI      CNFI
      *
      * Change type
     C                   MOVE      L_CLCHTP      CHTP
      *
      * TNLU
     C                   Z-ADD     NATN          TNLU
      *
      * Last Change Date
     C                   Z-ADD     BJRDNB        LCD
      *
      * Front Office ID
     C                   MOVE      L_CLFRNT      FRNT                           Front Office ID
      *
      * Repair location
     C                   MOVE      L_CLREPA      REPA                           Repair Location
      *
      * Timestamp
     C                   EVAL      TMST=TimeStamp
                                                                                              CLE134
      ** Set Extension Reference.                                                             CLE134
                                                                                              CLE134
     C                   IF        XRFI        = *BLANKS       AND                            CLE134
     C                             XRFN        = 0                                            CLE134
     C**********         EXSR      xeXRF                                            CLE134 AR1022006
     C                   EVAL      XRFI = 'CLI'                                            AR1022006
     C                   ENDIF                                                                CLE134

     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * SRLONL  -  Format CLOANCL fields for update                   *
      *****************************************************************
     C     SRLONL        BEGSR
      *
      *** Change type (not X)
     C                   MOVE      L_CLCHTP      CHTP
      *
      *** TNLU
     C                   Z-ADD     NATN          TNLU
      *
      ** Last Change Date
     C                   Z-ADD     BJRDNB        LCD
      *
      *** Manual/system generated
     C                   MOVE      'M'           MNSG
      *
      *** PC orig. branch
     C                   MOVE      L_CLPCOB      PCOBL
      *
      *** Front Office ID
     C                   MOVE      L_CLFRNT      FRNT                           Front Office ID
      *
      *** Repair location
     C                   MOVE      L_CLREPA      REPA                           Repair Location
      *
      *** Timestamp
     C                   EVAL      TMST=TimeStamp
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * LONK_INS - Format CLOANCK fields on INSERT                    *
      *****************************************************************
     C     LONK_INS      BEGSR
      *
      *** Record ID
     C                   MOVE      'D'           RECI
      *
      *** Loan Ref
     C                   MOVE      L_CLLNRF      LNRF
      *
      *** Record Type
     C                   MOVE      'B'           RCDT
     C                   Z-ADD     4             MRIN
      *
      *** Update narratives
     C                   MOVE      K_CLNAR1      NAR1
     C                   MOVE      K_CLNAR2      NAR2
     C                   MOVE      K_CLNAR3      NAR3
     C                   MOVE      K_CLNAR4      NAR4
      *
      *** Original principal amount
     C                   Z-ADD     L_CLCPAM      OPAM
      *
      *** frbc
     C                   MOVE      K_CLFRBC      FRBC
      *
      *** Update spec ins
     C                   MOVE      K_CLSPI1      SPI1
     C                   MOVE      K_CLSPI2      SPI2
     C                   MOVE      K_CLSPI3      SPI3
      *
      *** Original entry date
     C                   Z-ADD     BJRDNB        OREDK
      *
      ** Last change date
     C                   Z-ADD     BJRDNB        LCD
      *
      ** Change Type
     C                   MOVE      L_CLCHTP      CHTP
      *
      *** TNLU
     C                   Z-ADD     NATN          TNLU
      *
      *** Rollover Status ind
     C                   MOVE      'A'           RSTS
      *                                                                                       242751
      * Insert User Profile                                                                   242751
     C                   MOVE      PSUser        RIUS                                         242751
      *
      *** Rollover PC trans ref

     C     3             SUBST(P)  PCRFL         RPCR

     C******LOCK         IN        LEALLO                                                     CLE148
     C*****PCLAST        ADD       1             PCNEXT            8 0                        CLE148
                                                                                              CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD             7                          CLE148
     C                   PARM      'Y'           PUPDT             1                          CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT            8                          CLE148
                                                                                              CLE148
     C                   MOVE      PCNEXT        W1ST11
     C                   MOVEL     W#1ST3        W1ST11
     C                   MOVEL     W1ST11        RPCR
     C                   MOVE      '0001'        RPCR
     C**********         Z-ADD     PCNEXT        PCLAST                                       CLE148
     C**********         OUT       LEALLO                                                     CLE148
      *
      * New Currency
      * New Currency Principal Amount
      * New Facility Ccy Exch Rate
      * New Facility Ccy Mult/Div Ind
      * New Loan Ccy Repayment Amount
      * New Base Currency Exch Rate
      * New Base Currency Mult/Div I
      *
     C     *IN83         IFEQ      '1'
     C     RLDT_M        ANDNE     *ZEROS
     C     NCCY_M        ANDNE     *BLANKS
     C     NCCY_M        ANDNE     CCY_M
      *
     C                   MOVE      NCCY_M        NCCY
     C                   Z-ADD     NFCE_M        NFCE
     C                   MOVE      NFMD_M        NFMD
     C                   Z-ADD     NBCE_M        NBCE
     C                   MOVE      NBMD_M        NBMD
      *
     C                   Z-ADD     FCXR_M        ZRATE1           13 8
     C                   MOVE      FMDI_M        ZMDI1             1
     C                   MOVE      NFMD_M        ZMDI2             1
     C                   Z-ADD     NFCE_M        ZRATE2           13 8
     C                   EXSR      ZXRATE
      * New currency
     C                   MOVEL     NCCY_M        @CYCD
     C                   EXSR      ACS_CURR
     C                   Z-ADD     A6NBDP        NewCcyNBDP        1 0
      *
     C                   Z-ADD     L_CLCPAM      ZAMTCI           15 0
     C                   Z-ADD     ZRATEX        ZEXCH            13 8
     C                   MOVE      ZMDIX         ZMD               1
     C                   MOVEL     L_CLCCY       ZCCYI             3
     C                   MOVEL     NCCY_M        ZCCYO             3
     C                   Z-ADD     LoanCyNBDP    ZCDPI             1 0
     C                   Z-ADD     NewCcyNBDP    ZCDPO             1 0
     C                   Z-ADD     *ZEROS        ZAMTCO           15 0
      *
     C                   EXSR      ZCONVZ1
     C                   Z-ADD     ZAMTCO        NCPA
      *
     C     L_CLRAMT      IFNE      *ZEROS
     C     L_CLNRPD      ANDLE     RLDT_M
     C                   Z-ADD     L_CLRAMT      ZAMTCI
     C                   EXSR      ZCONVZ1
     C                   Z-ADD     ZAMTCO        NLRA
     C                   ENDIF
     C                   ENDIF
      *
      *** Front Office ID
     C                   MOVE      L_CLFRNT      FRNT                           Front Office ID
     C                   MOVE      L_CLREPA      REPA                           Repair Location
      *
      *** Timestamp
     C                   EVAL      TMST=TimeStamp
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * LONK_AMD - Format CLOANCK fields on AMEND                     *
      *****************************************************************
     C     LONK_AMD      BEGSR
      *
      *** Update narratives
     C                   MOVE      K_CLNAR1      NAR1
     C                   MOVE      K_CLNAR2      NAR2
     C                   MOVE      K_CLNAR3      NAR3
     C                   MOVE      K_CLNAR4      NAR4
      *
      *** frbc
     C                   MOVE      K_CLFRBC      FRBC
      *
      *** Update spec ins
     C                   MOVE      K_CLSPI1      SPI1
     C                   MOVE      K_CLSPI2      SPI2
     C                   MOVE      K_CLSPI3      SPI3
                                                                                              245719
     C                   EVAL      ZZ009 = K_ZZ009                                            245719
      *
      ** Last change date
     C                   Z-ADD     BJRDNB        LCD
      *
      ** Change Type
     C                   MOVE      L_CLCHTP      CHTP
      *
      *** TNLU
     C                   Z-ADD     NATN          TNLU
      *
      *** Front Office ID
     C                   MOVE      L_CLFRNT      FRNT                           Front Office ID
     C                   MOVE      L_CLREPA      REPA                           Repair Location
      *
      *** Timestamp
     C                   EVAL      TMST=TimeStamp
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * LONK_AUT - Format CLOANCK fields on AUTHORISE                 *
      *****************************************************************
     C     LONK_AUT      BEGSR
      *
      ** Last change date
     C                   Z-ADD     BJRDNB        LCD
      *
      ** TNLU
     C                   Z-ADD     NATN          TNLU
      *
      *** Front Office ID
     C                   MOVE      L_CLFRNT      FRNT                           Front Office ID
     C                   MOVE      L_CLREPA      REPA                           Repair Location
      *
      *** Timestamp
     C                   EVAL      TMST=TimeStamp
                                                                                              245719
     C                   If        K_ZZ009='Y'                                                245719
     C                   EVAL      ZZ009 = ' '                                                245719
     C                   Endif                                                                245719
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * LONK_REV - Format CLOANCK fields on REVERSE                   *
      *****************************************************************
     C     LONK_REV      BEGSR
      *
      ** Record id
     C                   MOVE      'R'           RECI
      *
      ** Last change date
     C                   Z-ADD     BJRDNB        LCD
      *
      ** Change Type
     C                   MOVE      L_CLCHTP      CHTP
      *
      ** TNLU
     C                   Z-ADD     NATN          TNLU
      *
      *** Front Office ID
     C                   MOVE      L_CLFRNT      FRNT                           Front Office ID
     C                   MOVE      L_CLREPA      REPA                           Repair Location
      *
      *** Timestamp
     C                   EVAL      TMST=TimeStamp
      *
     C                   ENDSR
      *****************************************************************                      BUG3760
      /EJECT                                                                                 BUG3760
      *****************************************************************                      BUG3760
      *                                                               *                      BUG3760
      * SRWatch - Initiates the Midas Compliance Engine.              *                      BUG3760
      *                                                               *                      BUG3760
      *****************************************************************                      BUG3760
                                                                                             BUG3760
     C     SRWatch       BEGSR                                                               BUG3760
                                                                                             BUG3760
      ** Initialise the Transaction Details parameter.                                       BUG3760
                                                                                             BUG3760
     C                   CLEAR                   SDWLTD                                      BUG3760
                                                                                             BUG3760
      ** Setup First Parameter                                                               BUG3760
                                                                                             BUG3760
     C                   MOVEL     PTYP          WPtyp                                       BUG3760
     C     'LE'          CAT       WPtyp:0       W4ITEM                                      BUG3760
      *                                                                                      BUG3760
     C                   MOVEL     L_CLLNRF      W4IDEN                                      BUG3760
      *                                                                                      BUG3760
     C                   EVAL      W4BRCH = L_CLBRCA                                         BUG3760
      *                                                                                      BUG3760
     C                   IF        CSC011 = 'Y'                                              BUG3760
     C                   EVAL      W4SYSM = S1MAIN                                           BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      W4SYSM = LIBR                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   EVAL      W4FUNT = 'CLOANCL'                                        BUG3760
                                                                                             BUG3760
     C                   MOVEL     L_CLCNUM      PCUST                                       BUG3760
     C                   CALLB     'AOCUSTR0'                                                BUG3760
     C                   PARM      *BLANKS       PRTCD                                       BUG3760
     C                   PARM      '*KEY'        POPTN                                       BUG3760
     C                   Parm                    PCUST                                       BUG3760
     C                   PARM      *BLANKS       PSTKEY                                      BUG3760
     C     SDCUST        PARM      SDCUST        DSSDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        PRTCD <> *BLANKS                                          BUG3760
     C                             AND PRTCD <> '*NRF   '                                    BUG3760
     C                   EVAL      DBKEY = POPTN                                             BUG3760
     C                   EVAL      DBFILE = 'SDCUSTPD'                                       BUG3760
     C                   EVAL      DBASE = 908                                               BUG3760
     C                   EXSR      SRERR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   MOVE      L_CLCNUM      W4CNUM                                      BUG3760
                                                                                             BUG3760
      ** Determine Counterparty Type                                                         BUG3760
                                                                                             BUG3760
     C                   IF        CCF001 = 'Y'                                              BUG3760
     C                   IF        BBCRPC = 'Y'                                              BUG3760
     C                   EVAL      W4CTYP = 'C'                                              BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      W4CTYP = 'I'                                              BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ELSE                                                                BUG3760
     C                   IF        BBLICD <> *BLANKS                                         BUG3760
     C                             AND BBLICD <> W1IND1                                      BUG3760
     C                             AND BBLICD <> W1IND2                                      BUG3760
     C                             AND BBLICD <> W1IND3                                      BUG3760
     C                             AND BBLICD <> W1IND4                                      BUG3760
     C                             AND BBLICD <> W1IND5                                      BUG3760
     C                   EVAL      W4CTYP = 'C'                                              BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      W4CTYP = 'I'                                              BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   EVAL      W4CUST = BBCRNM + BBCRTN                                  BUG3760
                                                                                             BUG3760
      ** Convert Dates                                                                       BUG3760
                                                                                             BUG3760
     C                   MOVE      '0001-01-01'  W4DDAT                                      BUG3760
     C                   MOVE      DDAT          PZADayNo                                    BUG3760
     C                   EXSR      SRDateToDDT                                               BUG3760
     C                   EVAL      W4DDAT = WDDT                                             BUG3760
                                                                                             BUG3760
     C                   MOVE      '0001-01-01'  W4VDAT                                      BUG3760
     C                   MOVE      VDAT          PZADayNo                                    BUG3760
     C                   EXSR      SRDateToDDT                                               BUG3760
     C                   EVAL      W4VDAT = WDDT                                             BUG3760
                                                                                             BUG3760
     C                   MOVE      '0001-01-01'  W4MDAT                                      BUG3760
     C                   MOVE      MDAT          PZADayNo                                    BUG3760
     C                   EXSR      SRDateToDDT                                               BUG3760
     C                   EVAL      W4MDAT = WDDT                                             BUG3760
                                                                                             BUG3760
     C                   EVAL      W4DEN1 = CCY                                              BUG3760
     C                   EVAL      W4DEN2 = *BLANKS                                          BUG3760
                                                                                             BUG3760
     C                   EVAL      W4AMT1 = CPAM                                             BUG3760
     C                   EVAL      W4AMT2 = 0                                                BUG3760
                                                                                             BUG3760
      ** Build the free format string (2nd parameter)                                        BUG3760
                                                                                             BUG3760
     C                   EVAL      Ctr = 1                                                   BUG3760
     C                   EVAL      PFreeFmtStr = *BLANKS                                     BUG3760
     C                   EVAL      WXMLPacket = *BLANKS                                      BUG3760
     C                   EVAL      WData = *BLANKS                                           BUG3760
                                                                                             BUG3760
     C                   DOU       Ctr >= Elements                                           BUG3760
                                                                                             BUG3760
     C                   IF        WLF(Ctr) <> *BLANKS                                       BUG3760
     C                             AND WLF(Ctr) <> '000000'                                  BUG3760
                                                                                             BUG3760
     C                   EVAL      PFmtCCY = L_CLCCY                                         BUG3760
                                                                                             BUG3760
     C                   CALL      'SDCWLFMT'                                                BUG3760
     C                   PARM                    PRTCD                                       BUG3760
     C                   PARM                    WLF(Ctr)                                    BUG3760
     C                   PARM                    PDummy35                                    BUG3760
     C                   PARM                    PDummy35                                    BUG3760
     C                   PARM                    PDummy35                                    BUG3760
     C                   PARM                    PDummy35                                    BUG3760
     C                   PARM                    PDummy35                                    BUG3760
     C                   PARM                    PFmtCCY                                     BUG3760
     C                   PARM                    WData                                       BUG3760
     C                   PARM                    PDummy6                                     BUG3760
                                                                                             BUG3760
     C                   CAT       XOT(Ctr):0    WXMLPacket                                  BUG3760
     C                   CAT       WData:0       WXMLPacket                                  BUG3760
                                                                                             BUG3760
     C                   SELECT                                                              BUG3760
                                                                                             BUG3760
     C                   WHEN      Ctr = 2                                                   BUG3760
     C                   CAT       RIBA:0        WXMLPacket                                  BUG3760
                                                                                             BUG3760
     C                   WHEN      Ctr = 6                                                   BUG3760
     C                   CAT       PIBA:1        WXMLPacket                                  BUG3760
                                                                                             BUG3760
     C                   WHEN      Ctr = 9                                                   BUG3760
     C                   CAT       RCRA:1        WXMLPacket                                  BUG3760
                                                                                             BUG3760
     C                   WHEN      Ctr = 11                                                  BUG3760
     C                   CAT       AWBA:1        WXMLPacket                                  BUG3760
                                                                                             BUG3760
     C                   WHEN      Ctr = 12                                                  BUG3760
     C                   CAT       BENA:1        WXMLPacket                                  BUG3760
                                                                                             BUG3760
     C                   ENDSL                                                               BUG3760
                                                                                             BUG3760
     C                   CAT       XCT(Ctr):0    WXMLPacket                                  BUG3760
     C                   CAT       WXMLPacket:0  PFreeFmtStr                                 BUG3760
                                                                                             BUG3760
     C                   EVAL      WXMLPacket = *BLANKS                                      BUG3760
     C                   EVAL      WData = *BLANKS                                           BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   EVAL      Ctr = Ctr + 1                                             BUG3760
     C                   ENDDO                                                               BUG3760
                                                                                             BUG3760
      ** Add the Payment Details.                                                            BUG3760
                                                                                             BUG3760
     C                   IF        DTP1 <> *BLANKS or DTP2 <> *BLANKS or                     BUG3760
     C                             DTP3 <> *BLANKS or DTP4 <> *BLANKS                        BUG3760
                                                                                             BUG3760
     C                   IF        WDtlOPay = 'Y'                                            BUG3760
     C                   CAT       XOT(Ctr):0    WXMLPacket                                  BUG3760
     C                   CAT       DTP1:0        WXMLPacket                                  BUG3760
     C                   CAT       DTP2:1        WXMLPacket                                  BUG3760
     C                   CAT       DTP3:1        WXMLPacket                                  BUG3760
     C                   CAT       DTP4:1        WXMLPacket                                  BUG3760
     C                   CAT       XCT(Ctr):0    WXMLPacket                                  BUG3760
     C                   CAT       WXMLPacket:0  PFreeFmtStr                                 BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Check for compliance.                                                               BUG3760
                                                                                             BUG3760
     C                   CALL      'SDCWLCHK'                                                BUG3760
     C                   PARM                    SDWLTD                                      BUG3760
     C                   PARM                    PFreeFmtStr                                 BUG3760
                                                                                             BUG3760
     C                   ENDSR                                                               BUG3760
      *****************************************************************                      BUG3760
      /EJECT                                                                                 BUG3760
      *****************************************************************                      BUG3760
      *                                                               *                      BUG3760
      * SRDateToDDT - Converts a date into Date Data Type format.     *                      BUG3760
      *                                                               *                      BUG3760
      *****************************************************************                      BUG3760
                                                                                             BUG3760
     C     SRDateToDDT   BEGSR                                                               BUG3760
                                                                                             BUG3760
      ** Convert the derived Midas Day Number into Date Data Type.                           BUG3760
                                                                                             BUG3760
     C                   CALL      'ZACVTDATE'                                               BUG3760
     C                   PARM      *BLANKS       PZARtCd                                     BUG3760
     C                   PARM                    PZADayNo                                    BUG3760
     C                   PARM                    PZADDT                                      BUG3760
     C                   PARM                    PZACvtDt                                    BUG3760
                                                                                             BUG3760
     C                   EVAL      WDDT = PZADDT                                             BUG3760
                                                                                             BUG3760
     C                   ENDSR                                                               BUG3760
                                                                                             BUG3760
      ****************************************************************
      /EJECT
      *****************************************************************
      * SRFCLT  -  Update facilities file                            *
      ****************************************************************
     C     SRFCLT        BEGSR
      *
     C**********         Z-ADD     FCUS          WFCNUM                                       CSD027
     C                   EVAL      WFCNUM = FCUS                                              CSD027
     C                   Z-ADD     FTYP          WFFACT
     C                   Z-ADD     FSEQ          WFFCNO
      *
      ***  Retrieve loan facilities detail A record
      *
     C                   MOVE      'A'           WFRCTP
     C     WKFAC         CHAIN     FCLTY                              89
      *
     C     *IN89         IFEQ      *OFF
     C                   EXSR      SRCKFR
     C                   EXSR      SRCKRV                                                     245177
     C                   ENDIF
      *
     C     *IN89         IFEQ      '1'
     C     *IN89         OREQ      '0'
     C     RECIF         ANDNE     'D'
     C     RECIF         ANDNE     'E'
     C     WREAC         ANDEQ     *OFF
     C     *LOCK         IN        LDA
     C                   MOVE      FCTREC        DBKEY                          *************
     C                   MOVEL     'FCLTY   '    DBFILE                         * DBERR 008 *
     C                   Z-ADD     7             DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ***  Retrieve loan facilities detail A record
      *
     C                   MOVE      'B'           WFRCTP
     C     WKFAC         CHAIN     FCLTY                              89
     C     *IN89         IFEQ      '1'
     C     *IN89         OREQ      '0'
     C     RECIF         ANDNE     'D'
     C     RECIF         ANDNE     'E'
     C     WREAC         ANDEQ     *OFF
     C     *LOCK         IN        LDA
     C                   MOVE      FCTREC        DBKEY                          *************
     C                   MOVEL     'FCLTY   '    DBFILE                         * DBERR 009 *
     C                   Z-ADD     8             DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ***  If linked to participant facility, first update is for the
      ***  prime facility
      *
     C                   MOVE      MCSIF         WMCSI             1
     C                   MOVE      *BLANK        WPRME             1
     C                   MOVE      *BLANK        WPART             1
     C     LPFI          IFNE      *BLANK
     C                   MOVE      'Y'           WPRME
     C                   ENDIF
      *
      ***  Do the loan facility updates
      *
     C                   EXSR      SRFCUP
      *
      ***  Save the revolving credit indicator of the facility
      *
     C     CLE014        IFEQ      'Y'
     C                   MOVE      RVCR          WRVCR             1
     C                   ENDIF
      *
      ***  If the facility has a credit agreement/super facility
      ***  Do the credit agreement/superfacility facility updates
      *
     C     CLE005        IFEQ      'Y'
     C     TRCA          ANDEQ     'TR'
     C                   MOVE      LPFI          W0LPFI            1
     C**********         Z-ADD     PTFC          W0PTFC            6 0                        CSD027
     C                   MOVE      PTFC          W0PTFC            6                          CSD027
     C                   Z-ADD     PTFT          W0PTFT            3 0
     C                   Z-ADD     PTFN          W0PTFN            2 0
     C                   EXSR      SRCAUP
     C                   MOVE      W0LPFI        LPFI
     C**********         Z-ADD     W0PTFC        PTFC                                         CSD027
     C                   EVAL      PTFC = W0PTFC                                              CSD027
     C                   Z-ADD     W0PTFT        PTFT
     C                   Z-ADD     W0PTFN        PTFN
     C                   ENDIF
      *
      ***  If linked to participant facility,
      ***  Do the participant facility facility updates
      *
     C     LPFI          IFNE      *BLANK
     C*****LPFI*         ANDNE     'R'                                                        CLE106

     C                   MOVE      *BLANK        WPRME
     C                   MOVE      'Y'           WPART
     C**********         Z-ADD     PTFC          WFCNUM                                       CSD027
     C                   EVAL      WFCNUM = PTFC                                              CSD027
     C                   Z-ADD     PTFT          WFFACT
     C                   Z-ADD     PTFN          WFFCNO
      *
      *** Access participant facility 'A' record
      *
     C                   MOVE      'A'           WFRCTP
     C     WKFAC         CHAIN     FCLTY                              89
     C     *IN89         IFEQ      '1'
     C     *IN89         OREQ      '0'
     C     RECIF         ANDNE     'D'
     C     RECIF         ANDNE     'E'
     C     *LOCK         IN        LDA
     C                   MOVE      FCTREC        DBKEY                          *************
     C                   MOVEL     'FCLTY   '    DBFILE                         * DBERR 010 *
     C                   Z-ADD     9             DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
      *** Access participant facility 'B' record
      *
     C                   MOVE      'B'           WFRCTP
     C     WKFAC         CHAIN     FCLTY                              89
     C     *IN89         IFEQ      '1'
     C     *IN89         OREQ      '0'
     C     RECIF         ANDNE     'D'
     C     RECIF         ANDNE     'E'
     C     *LOCK         IN        LDA
     C                   MOVE      FCTREC        DBKEY                          *************
     C                   MOVEL     'FCLTY   '    DBFILE                         * DBERR 011 *
     C                   Z-ADD     10            DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ***  Do the participant facility update
      *
     C                   EXSR      SRFCUP
      *
     C                   ENDIF
      *                                                                                      BUG8642
      ***  If sold and the 'Sale of Loan' is an Internal participation purchased             BUG8642
      ***  Do the internal participant facility facility updates                             BUG8642
      *                                                                                      BUG8642
     C     *IN83         IFEQ      '1'                                                       BUG8642
     C*****PTFC_M        ANDNE     0                                                 BUG8642 CSD027A
     C     PTFC_M        ANDNE     *Blanks                                                   CSD027A
                                                                                             BUG8642
     C                   MOVE      'I'           WPRME                                       BUG8642
     C                   MOVE      *BLANKS       WPART                                       BUG8642
     C**********         Z-ADD     PTFC_M        WFCNUM                              BUG8642 CSD027A
     C                   MOVE      PTFC_M        WFCNUM                                      CSD027A
     C                   Z-ADD     PTFT_M        WFFACT                                      BUG8642
     C                   Z-ADD     PTFN_M        WFFCNO                                      BUG8642
      *                                                                                      BUG8642
      *** Access internal participant facility 'A' record                                    BUG8642
      *                                                                                      BUG8642
     C                   MOVE      'A'           WFRCTP                                      BUG8642
     C     WKFAC         CHAIN     FCLTY                              89                     BUG8642
     C     *IN89         IFEQ      '1'                                                       BUG8642
     C     *IN89         OREQ      '0'                                                       BUG8642
     C     RECIF         ANDNE     'D'                                                       BUG8642
     C     RECIF         ANDNE     'E'                                                       BUG8642
     C     *LOCK         IN        LDA                                                       BUG8642
     C                   MOVE      FCTREC        DBKEY                          *************BUG8642
     C                   MOVEL     'FCLTY   '    DBFILE                         * DBERR 012 *BUG8642
     C                   Z-ADD     12            DBASE                          *************BUG8642
     C                   OUT       LDA                                                       BUG8642
     C                   EXSR      SRERR                                                     BUG8642
     C                   ENDIF                                                               BUG8642
      *                                                                                      BUG8642
      *** Access internal participant facility 'B' record                                    BUG8642
      *                                                                                      BUG8642
     C                   MOVE      'B'           WFRCTP                                      BUG8642
     C     WKFAC         CHAIN     FCLTY                              89                     BUG8642
     C     *IN89         IFEQ      '1'                                                       BUG8642
     C     *IN89         OREQ      '0'                                                       BUG8642
     C     RECIF         ANDNE     'D'                                                       BUG8642
     C     RECIF         ANDNE     'E'                                                       BUG8642
     C     *LOCK         IN        LDA                                                       BUG8642
     C                   MOVE      FCTREC        DBKEY                          *************BUG8642
     C                   MOVEL     'FCLTY   '    DBFILE                         * DBERR 013 *BUG8642
     C                   Z-ADD     13            DBASE                          *************BUG8642
     C                   OUT       LDA                                                       BUG8642
     C                   EXSR      SRERR                                                     BUG8642
     C                   ENDIF                                                               BUG8642
      *                                                                                      BUG8642
      ***  Do the internal participant facility update                                       BUG8642
      *                                                                                      BUG8642
     C                   EXSR      SRFCUP                                                    BUG8642
      *                                                                                      BUG8642
     C                   ENDIF                                                               BUG8642
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * SRFCUP  -  Facilities updates                                *
      ****************************************************************
     C     SRFCUP        BEGSR
      *
     C     CredAgreUP    IFEQ      *BLANK
     C     CredAgreUP    OREQ      'Y'
     C     FCCYF         ANDNE     WFCCYF
      *                                                                                       CLE023
      ** Loan currency details.                                                               CLE023
      *
     C     CredAgreUP    IFEQ      'Y'
     C                   MOVE      WFCCYF        @CYCD
     C                   ELSE
     C                   MOVE      L_CLCCY       @CYCD
     C                   ENDIF
     C                   EXSR      ACS_CURR
     C                   Z-ADD     A6NBDP        WCDPL             1 0
      *                                                                                       CLE023
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C                   MOVE      @CYCD         ZCCYI                                        CLE023
     C                   Z-ADD     A6SPRT        ZRATE1                                       CLE023
     C                   MOVE      A6MDIN        ZMDI1                                        CLE023
     C                   Z-ADD     A6NBDP        ZCDPI                                        CLE023
     C                   ENDIF                                                                CLE023
      *                                                                                       CLE023
      ** Facility currency details.                                                           CLE023
      *
     C     CredAgreUP    IFEQ      'Y'
     C                   MOVE      FCCYF         @CYCD
     C                   ELSE
     C                   MOVE      FCCY          @CYCD
     C                   ENDIF
     C                   EXSR      ACS_CURR
     C                   Z-ADD     A6NBDP        WCDPF             1 0
      *                                                                                       CLE023
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C                   MOVE      @CYCD         ZCCYO                                        CLE023
     C                   Z-ADD     A6SPRT        ZRATE2                                       CLE023
     C                   MOVE      A6MDIN        ZMDI2                                        CLE023
     C                   Z-ADD     A6NBDP        ZCDPO                                        CLE023
     C                   ENDIF                                                                CLE023
      *
      ***  Convert amounts into facility currency equivalent
      *
     C                   EXSR      SRFEQV
     C                   ENDIF
      *
     C                   DO
      *
      ***  If sold with recourse, do not update exposure and availability
      ***  For syndicated loans, do not update prime facility if sold
      ***  with recourse
      ***  Do not update prime facility for Internal parts purchased
      *
     C     *IN83         IFEQ      '1'
     C     RCSI          ANDEQ     'Y'
     C     WPART         ANDEQ     *BLANK
     C     RCSI          OREQ      'Y'
     C     WPRME         ANDEQ     'Y'
     C     RCSI          OREQ      'Y'                                                       BUG8642
     C     WPRME         ANDEQ     'I'                                                       BUG8642
     C     *IN82         OREQ      '1'
     C     WPRME         ANDEQ     'Y'
     C     LPFI          ANDEQ     'I'
     C                   LEAVE
     C                   ENDIF
      *
      ***  Update file for value date
      ***  Disregard facility/commitment indicator check
      *
     C                   MOVE      'Y'           WFUAV             1
      *
     C                   MOVE      FCCYF         ZCCY
     C                   MOVE      ' '           ZFREQ
     C                   Z-ADD     0             ZMDAY
     C                   Z-ADD     99999         ENDAY
      *
      ***  For insert
      *
     C     L_CLCHTP      IFEQ      'I'
      *
     C     *IN83         IFEQ      '1'
     C     WPART         ANDEQ     *BLANKS
     C                   MOVE      'N'           WFUAV
     C                   ENDIF
      *
     C                   MOVE      '1'           WUPDT             1
     C                   EXSR      SRFUPD
     C                   Z-ADD     L_CLVDAT      DAYNO             5 0
     C                   MOVE      *BLANK        ZLOC
     C                   Z-ADD     New_FcEqCPAM  FCBAL            13 0
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C                   ADD       WFLTIF        FCBAL                                       BUG3721
     C                   ADD       WCHGAF        FCBAL                                       BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C**********         Z-ADD     New_FcEqCPAM  WRK13                                       BUG3721
     C                   Z-ADD     FCBAL         WRK13                                       BUG3721
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C                   Z-ADD     New_FcSpCPAM  FXCBAL           13 0                        CLE023
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C                   ADD       WFLTIF        FXCBAL                                      BUG3721
     C                   ADD       WCHGAF        FXCBAL                                      BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C**********         Z-ADD     New_FcSpCPAM  WRK14            13 0                CLE023 BUG3721
     C                   Z-ADD     FXCBAL        WRK14            13 0                       BUG3721
     C                   ENDIF                                                                CLE023
     C                   EXSR      SRFEXP
     C                   ENDIF
      *
      ***  For reversal
      *
     C     L_CLCHTP      IFEQ      'R'
      *
     C     *IN83         IFEQ      '1'
     C     WPART         ANDEQ     *BLANKS
     C                   MOVE      'N'           WFUAV
     C                   ENDIF
      *
     C                   MOVE      '2'           WUPDT
     C                   EXSR      SRFUPD
     C                   Z-ADD     VDAT          DAYNO
     C                   MOVE      *BLANK        ZLOC
     C                   Z-ADD     Prv_FcEqCPAM  FCBAL
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     PTYP          ANDEQ     80                                                        BUG3721
     C                   ADD       FLTIF         FCBAL                                       BUG3721
     C                   ADD       CHGAF         FCBAL                                       BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C**********         Z-ADD     Prv_FcEqCPAM  WRK13            13 0                       BUG3721
     C                   Z-ADD     FCBAL         WRK13            13 0                       BUG3721
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C                   Z-ADD     Prv_FcSpCPAM  FXCBAL                                       CLE023
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     PTYP          ANDEQ     80                                                        BUG3721
     C                   ADD       FLTIF         FXCBAL                                      BUG3721
     C                   ADD       CHGAF         FXCBAL                                      BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C**********         Z-ADD     Prv_FcSpCPAM  WRK14                                CLE023 BUG3721
     C                   Z-ADD     FXCBAL        WRK14                                       BUG3721
     C                   ENDIF                                                                CLE023
     C                   EXSR      SRFEXP
     C                   ENDIF
      *
      ***  Determine if update for repayments necessary
      ***  (for loans and parts purchased)
      *
     C                   MOVE      'N'           WFUAV
     C     RVCR          IFEQ      'Y'
     C     RVCR          OREQ      'N'                                                        245177
     C     WRVCRC        ANDEQ     'Y'                                                        245177
     C     BJRDNB        ANDGE     WVLDT                                                      245177
     C                   MOVE      'Y'           WFUAV
     C                   ENDIF
     C     RVCR          IFEQ      'Y'                                                        245177
     C     WRVCRC        ANDEQ     'N'                                                        245177
     C     BJRDNB        ANDGE     WVLDT                                                      245177
     C                   MOVE      'N'           WFUAV                                        245177
     C                   ENDIF                                                                245177
      *
      ***  If no change, do not update exposure and availability
      ***  Need to use work fields for old values as CLOAN has been
      ***  updated at this point
      *
     C     L_CLCHTP      IFEQ      'A'
     C     NRPD          ANDEQ     Prv_NRPD
     C     New_FcEqRAMT  ANDEQ     Prv_FcEqRAMT
     C     RFRQ          ANDEQ     Prv_RFRQ
     C     RDYN          ANDEQ     Prv_RDYN
     C     MDAT          ANDEQ     Prv_MDAT
     C     ADIF          ANDEQ     Prv_ADIF                                                  BUG3721
     C     ADCF          ANDEQ     Prv_ADCF                                                  BUG3721
     C     WAUTOA        ANDEQ     'N'                                                       245227
     C                   LEAVE
     C                   ENDIF
      *
      ***  Update file for repayment (non-insert transaction)
      *
     C                   MOVE      L_CLAUTO      WAUTOC            1                          CLE134
     C     WAUTOC        IFEQ      'C'                                                        CLE134
     C     CLE134        ANDEQ     'Y'                                                        CLE134
     C                   MOVE      'Y'           WAUTOC                                       CLE134
     C                   END                                                                  CLE134
      *                                                                                       CLE134
     C     L_CLCHTP      IFNE      'I'
     C     L_CLCHTP      ANDNE     'R'                                                        245227
     C     L_CLAUTO      ANDNE     'N'                                                        245227
     C     L_CLCHTP      OREQ      'R'                                                        245227
     C*****L_CLAUTO      ANDEQ     'Y'                                                 245227 CLE134
     C     WAUTOC        ANDEQ     'Y'                                                        CLE134
                                                                                              CLE134
     C     L_CLCHTP      OREQ      'A'                                                        245227
     C     WAUTOA        ANDEQ     'Y'                                                        245227
                                                                                              CLE134
     C     L_CLCHTP      OREQ      'A'                                                        CLE134
     C     WAUTOA        ANDEQ     'C'                                                        CLE134
     C     CLE134        ANDEQ     'Y'                                                        CLE134
      *
     C     *IN83         IFEQ      '1'
     C     WPART         ANDEQ     *BLANKS
     C                   MOVE      'N'           WFUAV
     C                   ENDIF
      *
     C                   MOVE      '1'           WUPDT
     C                   EXSR      SRFUPD
                                                                                             BUG3721
      ** Include interest and charge during exposure update                                  BUG3721
      ** when add on interest or add on charge is set to 'Y'                                 BUG3721
      ** for flat rate personal loans                                                        BUG3721
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     PTYP          ANDEQ     80                                                        BUG3721
     C     VDAT          ANDLE     BJRDNB                                                    BUG3721
     C     ORED          ANDEQ     BJRDNB                                                    BUG3721
                                                                                             BUG3721
     C                   Z-ADD     VDAT          ZDAYNO                                      BUG3721
     C                   Z-ADD     *ZERO         FCBAL                                       BUG3721
     C                   MOVE      *BLANK        ZFREQ                                       BUG3721
                                                                                             BUG3721
      ** Change in interest add on indicator                                                 BUG3721
                                                                                             BUG3721
     C     ADIF          IFNE      Prv_ADIF                                                  BUG3721
     C     ADIF          IFEQ      'Y'                                                       BUG3721
     C                   ADD       FLTIF         FCBAL                                       BUG3721
     C                   ELSE                                                                BUG3721
     C                   SUB       W#FLIF        FCBAL                                       BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
      ** Change in charge add on indicator                                                   BUG3721
                                                                                             BUG3721
     C     ADCF          IFNE      Prv_ADCF                                                  BUG3721
     C     ADCF          IFEQ      'Y'                                                       BUG3721
     C                   ADD       CHGAF         FCBAL                                       BUG3721
     C                   ELSE                                                                BUG3721
     C                   SUB       W#CHGF        FCBAL                                       BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   Z-ADD     FCBAL         WRK13                                       BUG3721
     C                   EXSR      SRFEXP                                                    BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     Prv_MDAT      IFEQ      *ZEROS
     C                   Z-ADD     99999         ENDAY
     C                   ELSE
     C                   Z-ADD     Prv_MDAT      ENDAY             5 0
     C                   ENDIF
     C                   Z-ADD     Prv_NRPD      DAYNO
     C                   MOVE      Prv_RFRQ      ZFREQ
     C                   MOVE      Prv_RDYN      ZMDAY
     C                   Z-ADD     Prv_FcEqRAMT  FCBAL
     C                   Z-ADD     Prv_FcEqCPAM  WRK13
     C                   MOVE      *BLANK        ZLOC
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C                   Z-ADD     Prv_FcSpRAMT  FXCBAL                                       CLE023
     C                   Z-ADD     Prv_FcSpCPAM  WRK14                                        CLE023
     C                   ENDIF                                                                CLE023
     C                   EXSR      SRFEXP
     C                   Z-ADD     WRK13         MATAM1           13 0
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C                   Z-ADD     WRK14         WMATM1           13 0                        CLE023
     C                   ENDIF                                                                CLE023
     C                   ENDIF
      *
      ***  Update file for repayment (for non-reversal transactions)
      *
     C     WAUTOA        IFEQ      'N'                                                        245227
      *                                                                                       245227
      ** Do not include newly inserted loan that has a non-autosettle                         245227
      ** indicator.                                                                           245227
      *                                                                                       245227
     C     L_CLCHTP      IFNE      'R'
     C     L_CLCHTP      ANDNE     'I'                                                        245227
     C     L_CLCHTP      OREQ      'I'                                                        245227
     C     L_CLAUTO      ANDEQ     'Y'                                                        245227
                                                                                              CLE134
     C     L_CLCHTP      OREQ      'I'                                                        CLE134
     C     L_CLAUTO      ANDEQ     'C'                                                        CLE134
     C     CLE134        ANDEQ     'Y'                                                        CLE134
      *
     C     *IN83         IFEQ      '1'
     C     WPART         ANDEQ     *BLANKS
     C                   MOVE      'N'           WFUAV
     C                   ENDIF
      *
     C                   MOVE      '2'           WUPDT
     C                   EXSR      SRFUPD
     C     L_CLMDAT      IFEQ      *ZEROS
     C                   Z-ADD     99999         ENDAY
     C                   ELSE
     C                   Z-ADD     L_CLMDAT      ENDAY
     C                   ENDIF
     C                   Z-ADD     L_CLNRPD      DAYNO
     C                   MOVE      RFRQ          ZFREQ
     C                   MOVE      RDYN          ZMDAY
     C                   Z-ADD     New_FcEqRAMT  FCBAL
     C                   Z-ADD     New_FcEqCPAM  WRK13
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C                   ADD       WFLTIF        WRK13                                       BUG3721
     C                   ADD       WCHGAF        WRK13                                       BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   MOVE      *BLANK        ZLOC              3
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C                   Z-ADD     New_FcSpRAMT  FXCBAL                                       CLE023
     C                   Z-ADD     New_FcSpCPAM  WRK14                                        CLE023
                                                                                             BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C                   ADD       WFLTIF        WRK14                                       BUG3721
     C                   ADD       WCHGAF        WRK14                                       BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDIF                                                                CLE023
     C                   EXSR      SRFEXP
     C                   Z-ADD     WRK13         MATAM2           13 0
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C                   Z-ADD     WRK14         WMATM2           13 0                        CLE023
     C                   ENDIF                                                                CLE023
     C                   ENDIF
     C                   ENDIF                                                                245227
      *
      ***  Update file for maturity date (for non-insert transactions)
      *
     C                   MOVE      ' '           ZFREQ
     C                   Z-ADD     0             ZMDAY
     C     L_CLCHTP      IFNE      'I'
     C     Prv_MDAT      ANDNE     *ZEROS
     C     L_CLCHTP      IFNE      'R'                                                        245227
     C     L_CLCHTP      OREQ      'R'                                                        245227
     C     L_CLAUTO      ANDEQ     'Y'                                                        245227
                                                                                              CLE134
     C     L_CLCHTP      OREQ      'R'                                                        CLE134
     C     L_CLAUTO      ANDEQ     'C'                                                        CLE134
     C     CLE134        ANDEQ     'Y'                                                        CLE134
                                                                                              CLE134
     C                   MOVE      '1'           WUPDT
     C                   EXSR      SRFUPD
     C                   Z-ADD     Prv_MDAT      DAYNO
     C                   Z-ADD     Prv_MDAT      ENDAY
     C     Prv_MDAT      IFGT      BJRDNB
     C                   ADD       1             DAYNO
     C                   ADD       1             ENDAY
     C                   END
     C                   MOVE      *BLANK        ZLOC
     C                   Z-ADD     MATAM1        FCBAL
     C                   Z-ADD     MATAM1        WRK13
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C                   Z-ADD     WMATM1        FXCBAL                                       CLE023
     C                   Z-ADD     WMATM1        WRK14                                        CLE023
     C                   ENDIF                                                                CLE023
     C                   EXSR      SRFEXP
     C                   ENDIF
     C                   ENDIF                                                                245227
      *
      ***  Update file for maturity date (for non-reversal transactions)
      *
     C     L_CLCHTP      IFNE      'R'
     C     L_CLMDAT      ANDNE     *ZEROS
     C     L_CLCHTP      IFNE      'I'                                                        245227
     C     L_CLCHTP      OREQ      'I'                                                        245227
     C     L_CLAUTO      ANDEQ     'Y'                                                        245227
                                                                                              CLE134
     C     L_CLCHTP      OREQ      'I'                                                        CLE134
     C     L_CLAUTO      ANDEQ     'C'                                                        CLE134
     C     CLE134        ANDEQ     'Y'                                                        CLE134
                                                                                              CLE134
     C                   MOVE      '2'           WUPDT
     C                   EXSR      SRFUPD
     C                   Z-ADD     L_CLMDAT      DAYNO
     C                   Z-ADD     L_CLMDAT      ENDAY
     C     L_CLMDAT      IFGT      BJRDNB
     C**********         ADD       1             DAYNO                                        245177
     C                   ADD       1             ENDAY
     C                   END
     C                   MOVE      *BLANK        ZLOC
     C                   Z-ADD     MATAM2        FCBAL
     C                   Z-ADD     MATAM2        WRK13
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C                   Z-ADD     WMATM2        FXCBAL                                       CLE023
     C                   Z-ADD     WMATM2        WRK14                                        CLE023
     C                   ENDIF                                                                CLE023
     C                   EXSR      SRFEXP
     C                   ENDIF
     C                   ENDIF                                                                245227
      *
     C                   ENDDO
      *
      ***  Update facilities file - B record
      *
     C                   MOVE      BJRDNB        LCD
     C                   MOVE      'A'           CHTP
     C                   Z-ADD     NATN          TNLU
     C                   UPDATE    FCLTYFNF
      *
     C                   ENDSR
      ****************************************************************
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
      *                                                                                       245227
     C     WAUTOY        IFEQ      '2'                                                        245227
     C                   MOVE      'A'           WFUPD                                        245227
     C                   ELSE                                                                 245227
     C                   MOVE      'S'           WFUPD             1
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C                   MOVE      'Y'           WNOUP                                        CLE023
     C                   ENDIF                                                                CLE023
     C                   ENDIF                                                                245227
     C                   ELSE
      *                                                                                       245227
     C     WAUTOY        IFEQ      '2'                                                        245227
     C                   MOVE      'S'           WFUPD                                        245227
     C     CLE023        IFEQ      'Y'                                                        245227
     C                   MOVE      'Y'           WNOUP                                        245227
     C                   ENDIF                                                                245227
     C                   ELSE                                                                 245227
     C                   MOVE      'A'           WFUPD
     C                   ENDIF                                                                245227
     C                   ENDIF
      *
      ***  Parts sold
      *
     C     *IN83         WHENEQ    '1'
     C     WPART         IFEQ      'Y'
      *                                                                                       245227
     C     WAUTOY        IFEQ      '2'                                                        245227
     C                   MOVE      'S'           WFUPD                                        245227
     C     CLE023        IFEQ      'Y'                                                        245227
     C                   MOVE      'Y'           WNOUP                                        245227
     C                   ENDIF                                                                245227
     C                   ELSE                                                                 245227
     C                   MOVE      'A'           WFUPD
     C                   ENDIF                                                                245227
     C                   ELSE
      *                                                                                       245227
     C     WAUTOY        IFEQ      '2'                                                        245227
     C                   MOVE      'A'           WFUPD                                        245227
     C                   ELSE                                                                 245227
     C                   MOVE      'S'           WFUPD
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C                   MOVE      'Y'           WNOUP                                        CLE023
     C                   ENDIF                                                                CLE023
     C                   ENDIF                                                                245227
     C                   ENDIF
      *
      ***  Normal loan
      *
     C                   OTHER
     C     WAUTOY        IFEQ      '2'                                                        245227
     C                   MOVE      'S'           WFUPD                                        245227
     C                   ELSE                                                                 245227
     C                   MOVE      'A'           WFUPD
     C                   ENDIF                                                                245227
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
     C*****CLE025        ANDEQ     'N'                                               CLE025 BUG18527
     C     CLE024        ANDEQ     'N'                                                      BUG18527
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
     C**********         MOVE      L_CLCNUM      NUMCUST           6 0                        CSD027
     C                   MOVE      L_CLCNUM      NUMCUST           6                          CSD027
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
     C     L_CLMDAT      IFEQ      *ZERO
     C                   Z-ADD     99999         L_CLMDAT          5 0
     C                   ENDIF
     C                   Z-ADD     FCBAL         WFCBL1           13 0                        245227
     C**********         IF        CLE025 = 'N'                                      CLE025 BUG18527
     C                   IF        CLE024 = 'N'                                             BUG18527
     C     Z             DOWLE     10
     C*****RUNS(Z)       ANDLT     DTEXF                                                      245227
     C     RUNS(Z)       ANDLE     DTEXF                                                      245227
      *                                                                                       245227
     C     RUNS(Z)       IFGE      L_CLMDAT                                                   245227
     C     WAUTOA        ANDEQ     'N'                                                        245227
     C     L_CLCHTP      ANDEQ     'A'                                                        245227
     C                   Z-ADD     0             FCBAL                                        245227
     C                   ENDIF                                                                245227
      *                                                                                       245227
     C     WFUPD         IFEQ      'S'
     C     OAM(Z)        SUB       FCBAL         OAM(Z)
     C                   ELSE
     C     OAM(Z)        ADD       FCBAL         OAM(Z)
     C                   ENDIF
     C     Z             ADD       1             Z
     C                   ENDDO
     C                   Z-ADD     WFCBL1        FCBAL                                        245227
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
     C*****CLE025        ANDEQ     'N'                                               CLE025 BUG18527
     C     CLE024        ANDEQ     'N'                                                      BUG18527
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
     C                   PARM      L_CLCCY       ZCCY              3
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
      * SRFEQV  -  Get facility equivalent of amounts                 *
      *****************************************************************
     C     SRFEQV        BEGSR
      *
     C     WCDPF         SUB       WCDPL         CX                1 0
     C                   ADD       4             CX
      *                                                                                       CLE023
      ** If CLE023 is ON, get cross rate of currencies spot rates                             CLE023
      *                                                                                       CLE023
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C                   EXSR      ZXRATE
     C                   Z-ADD     ZRATEX        ZEXCH                                        CLE023
     C                   MOVE      ZMDIX         ZMD                                          CLE023
     C     ZCCYI         IFEQ      BJCYCD                                                     CLE023
     C                   MOVE      'M'           ZMD                                          CLE023
     C                   ENDIF                                                                CLE023
     C                   ENDIF                                                                CLE023

      * If NOT Credit Agreement Update                                                        CLE023
      * ==============================
                                                                                              CLE023
     C     CredAgreUP    IFEQ      *BLANK
      *
      *
      ***  For insert
      ***  ----------
      *
     C     L_CLCHTP      IFEQ      'I'

     C     FMDI          IFEQ      'D'
     C     FCXR          DIV(H)    POWER(CX)     W_FcEXRT
     C     1             DIV(H)    W_FcEXRT      W_FcEXRT
     C                   ELSE
     C     FCXR          MULT(H)   POWER(CX)     W_FcEXRT         15 8
     C                   ENDIF
      *
      ***  For non-insert
      ***  --------------
      *
     C                   ELSE
      *                                                                                       245227
     C                   Z-ADD     CPAM          WRKBAL           13 0                        245227
     C                   EXSR      SRGETBAL                                                   245227
      *                                                                                       CLE023
      ** If CLE023 is installed and there is a rollover of facility                           CLE023
      ** exchange rate where rollover date is less than or equal to                           CLE023
      ** rundate.                                                                             CLE023
      *                                                                                       CLE023
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C     L_CLRLDT      ANDNE     0                                                          CLE023
     C     L_CLRLDT      ANDLT     BJRDNB                                                     CLE023
     C     NFCE          ANDNE     0                                                          CLE023
     C     NCCY          ANDEQ     *BLANKS                                                    CLE023
     C     NFMD          IFEQ      'D'                                                        CLE023
     C     NFCE          DIV(H)    POWER(CX)     WNFCE            15 8
     C     1             DIV(H)    WNFCE         WNFCE
     C                   ELSE                                                                 CLE023
     C     NFCE          MULT(H)   POWER(CX)     WNFCE                                        CLE023
     C                   ENDIF                                                                CLE023
     C*****CPAM          MULT(H)   WNFCE         Prv_FcEqCPAM                          CLE023 245227
     C     WRKBAL        MULT(H)   WNFCE         Prv_FcEqCPAM                                 245227
     C     Prv_RAMT      MULT(H)   WNFCE         Prv_FcEqRAMT                                 CLE023
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
     C     PTYP          ANDEQ     80                                                        BUG3721
     C     VDAT          ANDLE     BJRDNB                                                    BUG3721
     C     ORED          ANDEQ     BJRDNB                                                    BUG3721
     C     ADIF          IFEQ      'Y'                                                       BUG3721
     C     FLTI          MULT(H)   WNFCE         FLTIF            13 0                       BUG3721
     C     Prv_FLTI      MULT(H)   WNFCE         W#FLIF           13 0                       BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     ADCF          IFEQ      'Y'                                                       BUG3721
     C     CHGA          MULT(H)   WNFCE         CHGAF            13 0                       BUG3721
     C     Prv_CHGA      MULT(H)   WNFCE         W#CHGF           13 0                       BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
      *                                                                                       CLE023
     C                   ELSE                                                                 CLE023
     C     FMDI          IFEQ      'D'
     C     FCXR          DIV(H)    POWER(CX)     W_FcEXRT
     C     1             DIV(H)    W_FcEXRT      W_FcEXRT
     C                   ELSE
     C     FCXR          MULT(H)   POWER(CX)     W_FcEXRT
     C                   ENDIF
     C*****CPAM          MULT(H)   W_FcEXRT      Prv_FcEqCPAM     13 0                        245227
     C     WRKBAL        MULT(H)   W_FcEXRT      Prv_FcEqCPAM     13 0                        245227
     C     Prv_RAMT      MULT(H)   W_FcEXRT      Prv_FcEqRAMT     13 0
                                                                                             BUG3721
      ** Include interest and charge during exposure update                                  BUG3721
      ** when add on interest or add on charge is set to 'Y'                                 BUG3721
      ** for flat rate personal loans                                                        BUG3721
                                                                                             BUG3721
     C                   Z-ADD     *ZEROS        FLTIF                                       BUG3721
     C                   Z-ADD     *ZEROS        W#FLIF                                      BUG3721
     C                   Z-ADD     *ZEROS        CHGAF                                       BUG3721
     C                   Z-ADD     *ZEROS        W#CHGF                                      BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     PTYP          ANDEQ     80                                                        BUG3721
     C     VDAT          ANDLE     BJRDNB                                                    BUG3721
     C     ORED          ANDEQ     BJRDNB                                                    BUG3721
     C     ADIF          IFEQ      'Y'                                                       BUG3721
     C     FLTI          MULT(H)   W_FcEXRT      FLTIF                                       BUG3721
     C     Prv_FLTI      MULT(H)   W_FcEXRT      W#FLIF                                      BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     ADCF          IFEQ      'Y'                                                       BUG3721
     C     CHGA          MULT(H)   W_FcEXRT      CHGAF                                       BUG3721
     C     Prv_CHGA      MULT(H)   W_FcEXRT      W#CHGF                                      BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDIF                                                                CLE023
      *                                                                                       CLE023
      ** If CLE023 is ON convert amounts using spot rate.                                     CLE023
      *                                                                                       CLE023
     C     CLE023        IFEQ      'Y'                                                        CLE023
      *
     C**********         Z-ADD     CPAM          ZAMTCI                                CLE023 245227
     C                   Z-ADD     WRKBAL        ZAMTCI                                       245227
     C                   EXSR      ZCONVZ1
     C                   Z-ADD     ZAMTCO        Prv_FcSpCPAM     13 0                        CLE023
      *                                                                                       CLE023
     C                   Z-ADD     Prv_RAMT      ZAMTCI                                       CLE023
     C                   EXSR      ZCONVZ1
     C                   Z-ADD     ZAMTCO        Prv_FcSpRAMT     13 0                        CLE023
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
     C     PTYP          ANDEQ     80                                                        BUG3721
     C     VDAT          ANDLE     BJRDNB                                                    BUG3721
     C     ORED          ANDEQ     BJRDNB                                                    BUG3721
                                                                                             BUG3721
     C     ADIF          IFEQ      'Y'                                                       BUG3721
     C                   Z-ADD     FLTI          ZAMTCI                                      BUG3721
     C                   EXSR      ZCONVZ1                                                   BUG3721
     C                   Z-ADD     ZAMTCO        FLTIF                                       BUG3721
                                                                                             BUG3721
     C                   Z-ADD     Prv_FLTI      ZAMTCI                                      BUG3721
     C                   EXSR      ZCONVZ1                                                   BUG3721
     C                   Z-ADD     ZAMTCO        W#FLIF                                      BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C     ADCF          IFEQ      'Y'                                                       BUG3721
     C                   Z-ADD     CHGA          ZAMTCI                                      BUG3721
     C                   EXSR      ZCONVZ1                                                   BUG3721
     C                   Z-ADD     ZAMTCO        CHGAF                                       BUG3721
                                                                                             BUG3721
     C                   Z-ADD     Prv_CHGA      ZAMTCI                                      BUG3721
     C                   EXSR      ZCONVZ1                                                   BUG3721
     C                   Z-ADD     ZAMTCO        W#CHGF                                      BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDIF                                                                CLE023
      *                                                                                       CLE023
     C                   ENDIF
      *
      ***  For non-reversal
      ***  ----------------
      *
     C     L_CLCHTP      IFNE      'R'
      *                                                                                       CLE023
      ** If rollover date is less than or equal to the repayment date                         CLE023
      ** and there is a rollover of facility exchange rate, use the                           CLE023
      ** new facility exchange rate defined.                                                  CLE023
      *                                                                                       CLE023
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C     L_CLRLDT      ANDNE     0                                                          CLE023
     C     L_CLRLDT      ANDLT     BJRDNB                                                     CLE023
     C     NFCE          ANDNE     0                                                          CLE023
     C     NCCY          ANDEQ     *BLANKS                                                    CLE023
     C     NFMD          IFEQ      'D'                                                        CLE023
     C     NFCE          DIV(H)    POWER(CX)     WNFCE                                        CLE023
     C     1             DIV(H)    WNFCE         WNFCE
     C                   ELSE                                                                 CLE023
     C     NFCE          MULT(H)   POWER(CX)     WNFCE                                        CLE023
     C                   ENDIF                                                                CLE023
     C     L_CLCPAM      MULT(H)   WNFCE         New_FcEqCPAM                                 CLE023
     C     L_CLRAMT      MULT(H)   WNFCE         New_FcEqRAMT                                 CLE023
                                                                                             BUG3721
      ** Include interest and charge during exposure update                                  BUG3721
      ** when add on interest or add on charge is set to 'Y'                                 BUG3721
      ** for flat rate personal loans                                                        BUG3721
                                                                                             BUG3721
     C                   Z-ADD     *ZEROS        WFLTIF                                      BUG3721
     C                   Z-ADD     *ZEROS        WCHGAF                                      BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     PTYP          ANDEQ     80                                                        BUG3721
     C     L_CLADIF      IFEQ      'Y'                                                       BUG3721
     C     L_CLTOTI      MULT(H)   WNFCE         WFLTIF           13 0                       BUG3721
     C                   ENDIF                                                               BUG3721
     C     L_CLADCF      IFEQ      'Y'                                                       BUG3721
     C     L_CLCHGA      MULT(H)   WNFCE         WCHGAF           13 0                       BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ADD       WFLTIF        New_FcEqCPAM                                BUG3721
     C                   ADD       WCHGAF        New_FcEqCPAM                                BUG3721
     C                   ENDIF                                                               BUG3721
      *                                                                                       CLE023
     C                   ELSE                                                                 CLE023
     C     L_CLCPAM      MULT(H)   W_FcEXRT      New_FcEqCPAM     13 0
     C     L_CLRAMT      MULT(H)   W_FcEXRT      New_FcEqRAMT     13 0
                                                                                             BUG3721
      ** Include interest and charge during exposure update                                  BUG3721
      ** when add on interest or add on charge is set to 'Y'                                 BUG3721
      ** for flat rate personal loans                                                        BUG3721
                                                                                             BUG3721
     C                   Z-ADD     *ZEROS        WFLTIF                                      BUG3721
     C                   Z-ADD     *ZEROS        WCHGAF                                      BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     PTYP          ANDEQ     80                                                        BUG3721
     C     L_CLADIF      IFEQ      'Y'                                                       BUG3721
     C     L_CLTOTI      MULT(H)   W_FcEXRT      WFLTIF                                      BUG3721
     C                   ENDIF                                                               BUG3721
     C     L_CLADCF      IFEQ      'Y'                                                       BUG3721
     C     L_CLCHGA      MULT(H)   W_FcEXRT      WCHGAF                                      BUG3721
     C                   ENDIF                                                               BUG3721
     C                   ENDIF                                                               BUG3721
                                                                                             BUG3721
     C                   ENDIF                                                                CLE023
      *                                                                                       CLE023
      ** If CLE023 is ON convert amounts using spot rate.                                     CLE023
      *                                                                                       CLE023
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C                   Z-ADD     L_CLCPAM      ZAMTCI                                       CLE023
     C                   EXSR      ZCONVZ1
     C                   Z-ADD     ZAMTCO        New_FcSpCPAM     13 0                        CLE023
      *                                                                                       CLE023
     C                   Z-ADD     L_CLRAMT      ZAMTCI                                       CLE023
     C                   EXSR      ZCONVZ1
     C                   Z-ADD     ZAMTCO        New_FcSpRAMT     13 0                        CLE023
                                                                                             BUG3721
      ** Include interest and charge during exposure update                                  BUG3721
      ** when add on interest or add on charge is set to 'Y'                                 BUG3721
      ** for flat rate personal loans                                                        BUG3721
                                                                                             BUG3721
     C                   Z-ADD     *ZEROS        WFLTIF                                      BUG3721
     C                   Z-ADD     *ZEROS        WCHGAF                                      BUG3721
     C     CLE028        IFEQ      'Y'                                                       BUG3721
     C     PTYP          ANDEQ     80                                                        BUG3721
      *                                                                                      BUG3721
     C     L_CLADIF      IFEQ      'Y'                                                       BUG3721
     C                   Z-ADD     L_CLTOTI      ZAMTCI                                      BUG3721
     C                   EXSR      ZCONVZ1                                                   BUG3721
     C                   Z-ADD     ZAMTCO        WFLTIF                                      BUG3721
     C                   ENDIF                                                               BUG3721
     C     L_CLADCF      IFEQ      'Y'                                                       BUG3721
     C                   Z-ADD     L_CLCHGA      ZAMTCI                                      BUG3721
     C                   EXSR      ZCONVZ1                                                   BUG3721
     C                   Z-ADD     ZAMTCO        WCHGAF                                      BUG3721
     C                   ENDIF                                                               BUG3721
      *                                                                                      BUG3721
     C                   ENDIF                                                               BUG3721
      *                                                                                      BUG3721
     C                   ENDIF                                                                CLE023
      *                                                                                       CLE023
     C                   ENDIF
      *
     C                   ELSE

      * If Credit Agreement Update                                                            CLE023
      * ==========================

      **  Get loan amount in credit agreement currency

     C     WFCMDI        IFEQ      'D'
     C     WFCAXR        DIV(H)    POWER(CX)     W_FcEXRT         15 8
     C     1             DIV(H)    W_FcEXRT      W_FcEXRT
     C                   ELSE
     C     WFCAXR        MULT(H)   POWER(CX)     W_FcEXRT
     C                   ENDIF
      *
     C                   MULT(H)   W_FcEXRT      Prv_FcEqCPAM     13 0
     C                   MULT(H)   W_FcEXRT      Prv_FcEqRAMT     13 0
     C                   MULT(H)   W_FcEXRT      New_FcEqCPAM     13 0
     C                   MULT(H)   W_FcEXRT      New_FcEqRAMT     13 0
      *                                                                                       CLE023
      ** If CLE023 is on, calculate amounts using spot rate.                                  CLE023
      *                                                                                       CLE023
     C     CLE023        IFEQ      'Y'                                                        CLE023
     C                   Z-ADD     Prv_FcSpCPAM  ZAMTCI                                       CLE023
     C                   EXSR      ZCONVZ1
     C                   Z-ADD     ZAMTCO        Prv_FcSpCPAM                                 CLE023
      *                                                                                       CLE023
     C                   Z-ADD     Prv_FcSpRAMT  ZAMTCI                                       CLE023
     C                   EXSR      ZCONVZ1
     C                   Z-ADD     ZAMTCO        Prv_FcSpRAMT                                 CLE023
      *                                                                                       CLE023
     C                   Z-ADD     New_FcSpCPAM  ZAMTCI                                       CLE023
     C                   EXSR      ZCONVZ1
     C                   Z-ADD     ZAMTCO        New_FcSpCPAM                                 CLE023
      *                                                                                       CLE023
     C                   Z-ADD     New_FcSpRAMT  ZAMTCI                                       CLE023
     C                   EXSR      ZCONVZ1
     C                   Z-ADD     ZAMTCO        New_FcSpRAMT                                 CLE023
      *                                                                                       CLE023
     C                   ENDIF                                                                CLE023
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      ****************************************************************
      * SRCAUP  -  Update credit agreement/superfacility             *
      ****************************************************************
     C     SRCAUP        BEGSR
      *
      ***  Retrieve facilities detail A record
      *
     C                   MOVE      FCCYF         WFCCYF            3
     C                   MOVE      CMDI          WFCMDI            1
     C                   Z-ADD     CAXR          WFCAXR           13 8
     C**********         Z-ADD     CANM          WFCNUM                                       CSD027
     C                   EVAL      WFCNUM = CANM                                              CSD027
     C                   Z-ADD     CAFT          WFFACT
     C                   Z-ADD     CAFN          WFFCNO
     C                   MOVE      'A'           WFRCTP
     C     WKFAC         CHAIN     FCLTY                              89
     C     *IN89         IFEQ      '1'
     C     *IN89         OREQ      '0'
     C     RECIF         ANDNE     'D'
     C     RECIF         ANDNE     'E'
     C     *LOCK         IN        LDA
     C                   MOVE      FCTREC        DBKEY                          *************
     C                   MOVEL     'FCLTY   '    DBFILE                         * DBERR 014 *
     C                   Z-ADD     11            DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ***  Retrieve facilities detail B record
      *
     C                   MOVE      'B'           WFRCTP
     C     WKFAC         CHAIN     FCLTY                              89
     C     *IN89         IFEQ      '1'
     C     *IN89         OREQ      '0'
     C     RECIF         ANDNE     'D'
     C     RECIF         ANDNE     'E'
     C     *LOCK         IN        LDA
     C                   MOVE      FCTREC        DBKEY                          *************
     C                   MOVEL     'FCLTY   '    DBFILE                         * DBERR 015 *
     C                   Z-ADD     12            DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ***  If the revolving credit indicator is 'T', use the tranche's
      ***  revolving credit indicator
      *
     C     CLE014        IFEQ      'Y'
     C     RVCR          ANDEQ     'T'
     C                   MOVE      WRVCR         RVCR
     C                   ENDIF
      *
      ***  Do credit agreement/superfacility update
      *
     C                   MOVE      'Y'           CredAgreUP        1
     C                   EXSR      SRFCUP
     C                   MOVE      *BLANK        CredAgreUP
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * SRCKFR  -  Check if the Facility has been reactivated.       *
      ****************************************************************
     C     SRCKFR        BEGSR
      *
     C                   MOVE      *OFF          WREAC             1
      *
     C     RECIF         IFEQ      'C'
     C     RECIF         OREQ      'E'
      *
     C     WKFAM2        SETLL     LEFCAML3
     C     WKFAM2        READE     LEFCAML3                               89
      *
     C     *IN89         DOWEQ     *OFF
     C     WREAC         ANDEQ     *OFF
     C     RECIC         IFEQ      'D'
     C     FATP          ANDEQ     'FR'
     C                   Z-ADD     AAMT          FAMT
     C                   Z-ADD     NDEX          DTEXF
     C                   MOVE      *ON           WREAC
     C                   ENDIF
     C     WKFAM2        READE     LEFCAML3                               89
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   MOVE      *OFF          *IN89
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * SRLREF  -  Update LEREF record/s                              *
      *****************************************************************
     C     SRLREF        BEGSR
      *
      ***  Create just one record for a non-multi customer facility or
      ***  or when customer equals that of the facility
      ***  Otherwise, create two records
      ***  Checking if should create just one record does not depend on
      ***  multi-customer anymore as is the amendment for syndication
      *
     C                   MOVE      *BLANK        WONER
     C     L_CLCHTP      IFEQ      'I'
     C                   MOVE      L_CLCNUM      WCNUM
     C                   MOVE      L_CLFCUS      CNUMF
     C**********         Z-ADD     L_CLCNUM      W#CNUM                                       CSD027
     C                   EVAL      W#CNUM = L_CLCNUM                                          CSD027
     C     CNUMF         IFEQ      WCNUM
     C                   MOVE      'Y'           WONER             1
     C                   ENDIF
      *
     C                   ELSE
     C**********         Z-ADD     CNUM          WCNUM                                        CSD027
     C**********         Z-ADD     CNUM          W#CNUM            6 0                        CSD027
     C                   EVAL      WCNUM = CNUM                                               CSD027
     C                   MOVE      CNUM          W#CNUM            6                          CSD027
     C     FCUS          IFEQ      WCNUM
     C                   MOVE      'Y'           WONER             1
     C                   ELSE
     C                   MOVE      FCUS          WCNUM
     C                   ENDIF
     C                   ENDIF
      *
      ***  For parts sold, only one record will always be processed
      *
     C     *IN83         IFEQ      '1'
     C**********         Z-ADD     L_CLCNUM      WCNUM                                        CSD027
     C                   EVAL      WCNUM = L_CLCNUM                                           CSD027
     C                   MOVE      'Y'           WONER
     C                   MOVE      *ZEROS        L_CLFTYP
     C                   MOVE      *ZEROS        L_CLFSEQ
     C                   ENDIF
      *
     C                   MOVE      L_CLFTYP      WFACT
     C                   MOVE      L_CLFSEQ      WFCNO
     C                   MOVE      L_CLLNRF      WLNRF
     C     WKREF         CHAIN     LEREF                              89
      *
      ***  Create/delete the one record for the loan
      *
     C     WONER         IFEQ      'Y'
      *
     C     L_CLCHTP      IFEQ      'I'
     C     *IN89         ANDEQ     '0'
     C     RECI          ANDEQ     'D'
     C     L_CLCHTP      OREQ      'R'
     C     *IN89         ANDEQ     '1'
     C     L_CLCHTP      OREQ      'R'
     C     *IN89         ANDEQ     '0'
     C     RECI          ANDNE     'D'
     C     *LOCK         IN        LDA
     C                   MOVE      LERFKY        DBKEY                          *************
     C                   MOVEL     'LEREF   '    DBFILE                         * DBERR 016 *
     C                   Z-ADD     13            DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C     L_CLCHTP      IFEQ      'I'
     C                   MOVE      'D'           RECI
     C**********         Z-ADD     WCNUM         CNUM                                         CSD027
     C                   EVAL      CNUM = WCNUM                                               CSD027
     C                   MOVE      L_CLFTYP      FACT
     C                   MOVE      L_CLFSEQ      FCNO
     C                   MOVE      L_CLLNRF      LNNO
     C                   MOVE      *BLANK        FLIN
     C                   MOVE      *BLANK        ZZ001
     C                   WRITE     LEREFD1F
     C                   ELSE
     C                   MOVE      'R'           RECI
     C                   UPDATE    LEREFD1F
     C                   ENDIF
      *
      ***  Create two records on LEREF for multi-customer facility
      ***  with facility customer different from loan customer
      *
     C                   ELSE
      *
     C     L_CLCHTP      IFEQ      'I'
     C     *IN89         ANDEQ     '0'
     C     RECI          ANDEQ     'D'
     C     L_CLCHTP      OREQ      'R'
     C     *IN89         ANDEQ     '1'
     C     L_CLCHTP      OREQ      'R'
     C     *IN89         ANDEQ     '0'
     C     RECI          ANDNE     'D'
     C     *LOCK         IN        LDA
     C                   MOVE      LERFKY        DBKEY                          *************
     C                   MOVEL     'LEREF   '    DBFILE                         * DBERR 017 *
     C                   Z-ADD     14            DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ***  Create/delete first record
      *
     C     L_CLCHTP      IFEQ      'I'
     C                   MOVE      'D'           RECI
     C                   MOVE      L_CLFCUS      CNUM
     C                   MOVE      L_CLFTYP      FACT
     C                   MOVE      L_CLFSEQ      FCNO
     C                   MOVE      L_CLLNRF      LNNO
     C                   MOVE      'F'           FLIN
     C                   WRITE     LEREFD1F
     C                   ELSE
     C                   MOVE      'R'           RECI
     C                   UPDATE    LEREFD1F
     C                   ENDIF
      *
     C**********         Z-ADD     W#CNUM        WCNUM                                        CSD027
     C                   EVAL      WCNUM = W#CNUM                                             CSD027
     C                   Z-ADD     *ZEROS        WFACT
     C                   Z-ADD     *ZEROS        WFCNO
     C     WKREF         CHAIN     LEREF                              89
     C     L_CLCHTP      IFEQ      'I'
     C     *IN89         ANDEQ     '0'
     C     RECI          ANDEQ     'D'
     C     L_CLCHTP      OREQ      'R'
     C     *IN89         ANDEQ     '1'
     C     L_CLCHTP      OREQ      'R'
     C     *IN89         ANDEQ     '0'
     C     RECI          ANDNE     'D'
     C     *LOCK         IN        LDA
     C                   MOVE      LERFKY        DBKEY                          *************
     C                   MOVEL     'LEREF   '    DBFILE                         * DBERR 018 *
     C                   Z-ADD     15            DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ***  Create/delete second record
      *
     C     L_CLCHTP      IFEQ      'I'
     C                   MOVE      'D'           RECI
     C**********         Z-ADD     WCNUM         CNUM                                         CSD027
     C                   EVAL      CNUM = WCNUM                                               CSD027
     C                   Z-ADD     *ZEROS        FACT
     C                   Z-ADD     *ZEROS        FCNO
     C                   MOVE      L_CLLNRF      LNNO
     C                   MOVE      'L'           FLIN
     C                   WRITE     LEREFD1F
     C                   ELSE
     C                   MOVE      'R'           RECI
     C                   UPDATE    LEREFD1F
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * SRWRTLTX - Write an LTRIX record                              *
      *****************************************************************
     C     SRWRTLTX      BEGSR
      *
      ***  Settlement type must be 01,02,07,08 or 12 and loan must not
      ***  be a risk loan
      *
     C                   MOVE      '0'           *IN86
     C     L_CLPTYP      IFNE      70
     C     L_CLPTYP      ANDNE     71
     C     L_CLPTYP      ANDNE     72
     C     L_CLPTYP      OREQ      72
     C     W72TP         ANDNE     '70'
     C     L_CLSDST      LOOKUP    WNOST                                  86
     C                   ENDIF
      *
      ***  Set pay/receive indicators
      *
     C**********         MOVE      RRNAD         LXRRN                                      AR322732
      *
     C**********         MOVE      *IN74         IN74              1                        AR322732
     C**********         MOVE      '0'           *IN74                                      AR322732
     C**********         MOVE      '1'           TXERR             1                        AR322732
      *
     C*****LXRRN         CHAIN     LTRIX                              8974                  AR322732
      *
     C******IN74         DOWEQ     '1'                                                      AR322732
     C*****TXERR         ANDEQ     '1'                                                      AR322732
     C*****RECID         ORNE      *BLANK                                                   AR322732
      *
     C**********         Z-ADD     TXSTS         SVSTS             5 0                      AR322732
     C**********         UNLOCK    LTRIX                                                    AR322732
     C*****SVSTS         IFEQ      1218                                                     AR322732
     C******IN74         OREQ      '0'                                                      AR322732
     C*****RECID         ANDNE     *BLANK                                                   AR322732
      *
      ***  Access the LTRIX header record
      *
     C**********         EXSR      SRACSLTH                                                 AR322732
     C**********         MOVE      RRNAD         LXRRN                                      AR322732
     C*****LXRRN         CHAIN     LTRIX                              8974                  AR322732
      *
     C**********         ELSE                                                               AR322732
      *
     C**********         MOVE      '0'           TXERR                                      AR322732
     C**********         ENDIF                                                              AR322732
      *
     C**********         ENDDO                                                              AR322732
     C**********         MOVE      IN74          *IN74                                      AR322732
      *
     C*****TXERR         IFEQ      '0'                                                      AR322732
     C******LOCK         IN        LDA                                                      AR322732
     C**********         MOVE      LXRRN         DBKEY                          ************AR322732
     C**********         MOVEL     'LTRIX   '    DBFILE                         * DBERR 019 AR322732
     C**********         Z-ADD     16            DBASE                          ************AR322732
     C**********         OUT       LDA                                                      AR322732
     C**********         EXSR      SRERR                                                    AR322732
     C**********         ENDIF                                                              AR322732
      *
     C                   Z-ADD     0             PRI1D
     C                   Z-ADD     0             PRI2D
     C                   Z-ADD     0             PRI3D
     C                   Z-ADD     0             PRI4D
     C                   MOVE      L_CLVDAT      VDATD
      *
     C     L_CLCHTP      IFNE      'R'
     C     *IN86         ANDEQ     '1'
      *
      ***  Set value date then derive test date
      *
     C                   MOVE      BJLCCY        ZCCY1
     C                   MOVE      BJSLCD        ZLOC1
     C                   Z-ADD     Lccy_TXND     ZNRDYS
     C                   MOVE      BJLCCY        ZCCY2
     C                   MOVE      BJSLCD        ZLOC2
     C                   Z-ADD     BJRDNB        ZDAYNO
      *
      ***  If start settlement type is 01,07 or 08 use loan currency
      *
     C     L_CLSDST      IFEQ      01
     C     L_CLSDST      OREQ      07
     C     L_CLSDST      OREQ      08
     C                   Z-ADD     LoanCyTXND    ZNRDYS
     C                   MOVE      L_CLCCY       ZCCY2
     C                   MOVE      *BLANK        ZLOC2
     C                   ENDIF
      *                                                                                     AR318769
     C                   EVAL      FWRDYS = ZNRDYS                                          AR318769
      *                                                                                     AR318769
     C                   CALLB     'ZF2C'
     C                   PARM                    RETCODEIN        10
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY1             3
     C                   PARM                    ZLOC1             3
     C                   PARM                    ZCCY2             3
     C                   PARM                    ZLOC2             3
     C**********         PARM                    ZNRDYS            2 0                      AR318769
     C                   PARM                    FWRDYS                                     AR318769
     C                   PARM                    ZDYNBR            5 0
      *
      ***  Compare value date to rundate and test date
      *
     C     L_CLVDAT      IFGE      BJRDNB
     C     L_CLVDAT      ANDLE     ZDYNBR
     C                   Z-ADD     1             PRI1D
     C                   ENDIF
      *
      ***  For S01465 (BLI Lending Enhancement)
      *
     C     S01465        IFEQ      'Y'
      *
      ***  Set on maturity date pay/receive if
      ***     1. auto pay at maturity is Y
      ***   + 2. maturity date is within telex notice days
      *
     C     L_CLAPMI      IFEQ      'Y'
     C     L_CLMDAT      ANDLE     ZDYNBR
     C     L_CLMDAT      ANDNE     *ZEROS
     C                   Z-ADD     1             PRI2D
     C                   ENDIF
      *
      ***  Set on interest date pay/receive if
      ***     1. interest date is within telex notice days
      ***   + 2. interest date is not zero
      ***   + 3. interest date has changed
      ***   + 4. interest date is same as original maturity date
      ***   + 5. not backvalued
      *
     C     L_CLNIDT      IFLE      ZDYNBR
     C     L_CLNIDT      ANDNE     *ZEROS
     C     L_CLNIDT      ANDNE     Prv_NIDT
     C     L_CLNIDT      ANDEQ     Prv_MDAT
     C     L_CLNIDT      ANDGE     BJRDNB
     C                   Z-ADD     1             PRI3D
     C                   ENDIF
      *
      ***  Set on repayment date pay/receive if
      ***     1. repayment date is within telex notice days
      ***   + 2. repayment date is not zero
      ***   + 3. repayment date has changed
      ***   + 4. repayment date is same as original maturity date
      ***   + 5. not back-valued
      *
     C     L_CLNRPD      IFLE      ZDYNBR
     C     L_CLNRPD      ANDNE     *ZEROS
     C     L_CLNRPD      ANDNE     Prv_NRPD
     C     L_CLNRPD      ANDEQ     Prv_MDAT
     C     L_CLNRPD      ANDGE     BJRDNB
     C                   Z-ADD     1             PRI4D
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ***  Update LTRIX detail record
      *
     C     L_CLCHTP      IFEQ      'X'
     C     L_CLCHTP      OREQ      'Q'
     C                   MOVE      CHTP          LtrixCHTP         1
     C                   ELSE
     C                   MOVE      L_CLCHTP      LtrixCHTP
     C                   ENDIF
      *
     C                   EXCEPT    TRXDTL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUPDLTH -  Update the LTRIX Header                           *
      *****************************************************************
     C     SRUPDLTH      BEGSR
      *
     C**********         Z-ADD     1             LXRRN                                      AR322732
     C*****LXRRN         CHAIN     LTRIX                              89                    AR322732
     C**********         ADD       1             NORED                                      AR322732
     C**********         ADD       1             RRNAD                                      AR322732
     C**********         ADD       1             NLNRD                                      AR322732
     C**********         EXCEPT    TRXHDR                                                   AR322732
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUPDTRL -  Update CLOAN trailer                              *
      *****************************************************************
     C     SRUPDTRL      BEGSR
      *
      ***  Access trailer record
      *
     C                   MOVE      'Z'           WEPAR
     C                   MOVE      '999999'      WALON
     C                   MOVE      '999999Z'     WLTRL             7
     C                   IF        MTHREAD = 'N'                                            MD024342
     C     WKLON         CHAIN     CLOAN                              89
     C     *IN89         IFEQ      '1'
     C     *IN89         OREQ      '0'
     C     RECI          ANDNE     'T'
     C     *LOCK         IN        LDA
     C                   MOVE      WLTRL         DBKEY                          *************
     C                   MOVEL     'CLOAN   '    DBFILE                         * DBERR 020 *
     C                   Z-ADD     17            DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDIF                                                              MD024342
      *
      ***  Set up relevant total fields
      *
     C     L_CLCHTP      IFEQ      'I'
     C                   IF        MTHREAD = 'Y'                                            MD024342
     C                   EXSR      Initialise                                               MD024342
     C                   ENDIF                                                              MD024342
     C                   ADD       2             NORE
     C                   ADD       2             NINS
     C                   ADD       2             NLRA
     C                   ELSE
     C                   IF        MTHREAD = 'Y'                                            MD024342
     C                   EXSR      Initialise                                               MD024342
     C                   ENDIF                                                              MD024342
     C                   ADD       2             NDEL
     C                   SUB       2             NLRA
     C                   ENDIF
      *
      ***  Set up amount fields for insert
      *
     C     L_CLCHTP      IFEQ      'I'
     C     L_CLCPAM      DIV       1000          ZZAMT            15 3
     C     ZZAMT         IFLT      *ZEROS
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
      *
     C                   Z-ADD     VRIF          ZZTOTI
     C                   Z-ADD     VRIL          ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        VRIF
     C                   Z-ADD     ZZTOTD        VRIL
     C     L_CLCPAM      DIV       1000          ZZAMT
     C     ZZAMT         IFLT      *ZEROS
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
      *
     C                   Z-ADD     VLAF          ZZTOTI
     C                   Z-ADD     VLAL          ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        VLAF
     C                   Z-ADD     ZZTOTD        VLAL
      *
      ***  Set up amount fields for reversal
      *
     C                   ELSE
     C     CPAM          DIV       1000          ZZAMT
     C     ZZAMT         IFLT      *ZEROS
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
      *
     C                   Z-ADD     VRDF          ZZTOTI
     C                   Z-ADD     VRDL          ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        VRDF
     C                   Z-ADD     ZZTOTD        VRDL
     C     CPAM          DIV       1000          ZZAMT
     C     ZZAMT         IFLT      *ZEROS
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
      *
     C                   Z-ADD     VLAF          ZZTOTI
     C                   Z-ADD     VLAL          ZZTOTD
     C                   EXSR      GLZSUB
     C                   Z-ADD     ZZTOTI        VLAF
     C                   Z-ADD     ZZTOTD        VLAL
     C                   ENDIF
      *
      ***  Update CLOAN trailer
      *
     C                   IF        MTHREAD = 'N'                                            MD024342
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      L_CLCHTP      CHTP
     C                   Z-ADD     NATN          TNLU
     C                   UPDATE    CLOANZ1F
     C                   ELSE                                                               MD024342
     C                   MOVEL     LNRF          Z1LNRF                                     MD024342
     C                   MOVEL     'D'           RECI                                       MD024342
     C                   MOVEL     L_CLCHTP      RCDT                                       MD024342
     C                   Z-ADD     BJRDNB        LCD                                        MD024342
     C                   MOVE      'I'           CHTP                                       MD024342
     C                   Z-ADD     NATN          TNLU                                       MD024342
     C**********         WRITE     CLOANZ1F                                       MD024342 MD024342B
     C                   WRITE     CLOANZ1FX                                               MD024342B
     C                   ENDIF                                                              MD024342
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GLZSUB  -  Subtracts an amount (ZZAMT) from the total         *
      *****************************************************************
     C     GLZSUB        BEGSR
      *
      ***  Just reverse the 'sign' and add
      *
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   EXSR      GLZADD
     C                   Z-SUB     ZZAMT         ZZAMT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GLZADD  -  Adds an amount (ZZAMT) to the total (ZZTOTI,ZZTOTD)*
      *****************************************************************
     C     GLZADD        BEGSR
      *
     C     ZZAMT         IFNE      *ZERO
      *
      ***  Split ZZAMT into integer and decimal fields
      *
     C                   Z-ADD     ZZAMT         ZZAMTI           15 0
     C                   MOVE      ZZAMT         ZZAMTD            3 0
      *
      ***  Both ZZAMTI and ZZAMTD contain a 'sign' zone now
      *
     C                   EXSR      GLZSUM
     C                   ENDIF
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * GLZSUM  -  Carries out the addition of the amounts            *
      *****************************************************************
     C     GLZSUM        BEGSR
      *
      ***  Save values of indicators to be used in the program
      *
     C                   MOVE      *IN91         WIN91             1
     C                   MOVE      *IN92         WIN92             1
     C                   MOVE      *IN93         WIN93             1
     C                   MOVE      *IN94         WIN94             1
     C                   MOVE      *IN95         WIN95             1
     C                   MOVE      *IN96         WIN96             1
     C                   SETOFF                                       919293
     C                   SETOFF                                       949599
      *
      ***  Determine sign of ZZAMTI and ZZAMTD, 92 if neg
      *
     C     ZZAMTI        COMP      0                                    9293
     C   93ZZAMTD        COMP      0                                    9293
     C   93              GOTO      ZZSEND
      *
      ***  Determine sign of ZZTOTI and ZZTOTD, 91 if neg
      *
     C     ZZTOTI        COMP      0                                    9193
     C   93ZZTOTD        COMP      0                                    9193
      *
      ***  If ZZTOTAL is zero, return ZZAMOUNT
      *
     C   93              Z-ADD     ZZAMTI        ZZTOTI           15 0
     C   93              Z-ADD     ZZAMTD        ZZTOTD            3 0
     C   93              GOTO      ZZSEND
      *
      ***  If signs differ, bypass overflow checks
      *
     C   91
     CANN92
     CORN91
     CAN 92              GOTO      ZZOFPS
     C*
     C     ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
     C     ZZWK2         COMP      999                                93
     C  N93ZZWK2         COMP      -999                                 93
     C*
     C   93
     CANN92ZZAMTI        ADD       1             ZZWK3            15 0
     C   93
     CAN 92ZZAMTI        SUB       1             ZZWK3
     C   93ZZTOTI        ADD       ZZWK3         ZZWK3
     C  N93ZZTOTI        ADD       ZZAMTI        ZZWK3
      *
      ***  If the modulus of ZZWK3 is lt mod. ZZTOTI then O/F has occured
      *
     C  N92ZZWK3         COMP      ZZTOTI                               99
     C   92ZZWK3         COMP      ZZTOTI                             99
     C  N99              Z-ADD     ZZWK2         ZZTOTD
     C  N99              Z-ADD     ZZWK3         ZZTOTI
      *
      ***  If O/F zeroise ZZAMT, Ind '99' set and ZZTOT fields left intact
      *
     C   99              Z-ADD     0             ZZAMT            15 3
     C                   GOTO      ZZSEND
      *
      ***  The 'signs' are different
      *
     C     ZZOFPS        TAG
      *
      ***  If ZZAMT was negative, make it pos. to como with ZZTOT
      *
     C   92              Z-SUB     ZZAMTI        ZZAMTI           15 0
     C   92              Z-SUB     ZZAMTD        ZZAMTD            3 0
      *
      ***  If ZZTOT was negative, make it pos. to comp with ZZAMT.
      *
     C   91              Z-SUB     ZZTOTI        ZZTOTI
     C   91              Z-SUB     ZZTOTD        ZZTOTD
      *
      ***  Both ZZAMT and ZZTOT are now positive
      *
     C     ZZTOTI        COMP      ZZAMTI                             93  95
     C   95ZZTOTD        COMP      ZZAMTD                             93  95
      *
      ***  If ZZTOT eq. ZZAMT return ZERO.
      *
     C   95              Z-ADD     0             ZZTOTI
     C   95              Z-ADD     0             ZZTOTD
     C   95              GOTO      ZZSEND
      *
      ***  If ZZTOT gt. ZZAMT.
      *
     C   93ZZAMTD        COMP      ZZTOTD                             94
     C   93
     CAN 94ZZTOTI        SUB       1             ZZTOTI
     C   93
     CAN 94ZZTOTD        ADD       1000          ZZWK2
     C   93ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C   93
     CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
     C   93
     CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD
      *
      ***  If ZZAMT gt. ZZTOT.
      *
     C  N93ZZTOTD        COMP      ZZAMTD                             94
     C  N93
     CAN 94ZZAMTI        SUB       1             ZZWK3            15 0
     C  N93
     CAN 94ZZAMTD        ADD       1000          ZZWK2
     C  N93
     CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
     C  N93
     CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
     C  N93
     CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
     C  N93
     CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD
      *
      ***  Reverse sign of ZZTOT if larger I/P fields were negative
      *
     C                   SETOFF                                       94
     C   93
     CAN 91
     CORN93
     CAN 92              SETON                                        94
     C   94              Z-SUB     ZZTOTI        ZZTOTI
     C   94              Z-SUB     ZZTOTD        ZZTOTD
      *
      ***  Restore sign of ZZAMTI & ZZAMTD if it was reversed
      *
     C   92              Z-SUB     ZZAMTI        ZZAMTI
     C   92              Z-SUB     ZZAMTD        ZZAMTD
     C     ZZSEND        TAG
      *
      ***  If ZZTOTD is zero, and ZZTOTI is neg. set up ZZNEGD.
      *
     C                   SETOFF                                       96
     C     ZZTOTD        COMP      0                                      91
     C   91ZZTOTI        COMP      0                                    96
     C   96              MOVE      '.000-'       ZZNEGD            5
      *
      ***  Restore previous indicator values
      *
     C                   MOVE      WIN91         *IN91
     C                   MOVE      WIN92         *IN92
     C                   MOVE      WIN93         *IN93
     C                   MOVE      WIN94         *IN94
     C                   MOVE      WIN95         *IN95
     C                   MOVE      WIN96         *IN96
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * SRFEES  -  Update Fees File                                   *
      *****************************************************************
     C     SRFEES        BEGSR
      *
      ***  If authorisation switchable feature is on and action code
      ***  is insert or amend and a parts purchased is being inputted and
      ***  parts purchased authorisations is required
      *
     C     CLE002        IFEQ      'Y'
     C     L_CLCHTP      ANDNE     'X'
     C     L_CLCHTP      ANDNE     'R'
     C     *IN82         ANDEQ     *ON
     C     BPPPAU        ANDEQ     'Y'
      *
      ***  Or authorisation switchable feature is on and action code
      ***  is insert or amend and a parts sold is being inputted and
      ***  parts sold authorisations is required
      *
     C     CLE002        OREQ      'Y'
     C     L_CLCHTP      ANDNE     'X'
     C     L_CLCHTP      ANDNE     'R'
     C     *IN83         ANDEQ     *ON
     C     BPPSAU        ANDEQ     'Y'
      *
      ***  Or authorisation switchable feature is on and action code
      ***  is insert or amend and a loan is being inputted and loans
      ***  authorisations is required
      *
     C     CLE002        OREQ      'Y'
     C     L_CLCHTP      ANDNE     'X'
     C     L_CLCHTP      ANDNE     'R'
     C     *IN82         ANDEQ     *OFF
     C     *IN83         ANDEQ     *OFF
     C     BPLOAU        ANDEQ     'Y'
      *
     C**********         Z-ADD     0             WKLNRF            6 0                        CLE148
      *
      ***  If action code is insert
      *
     C     L_CLCHTP      IFEQ      'I'
      *
      ***  Write a record to Loan Fee Index File
      *
     C**********         MOVE      L_CLLNRF      WKLNRF                                       CLE148
     C**********         Z-ADD     WKLNRF        FLLNRF                                       CLE148
     C                   MOVEL     L_CLLNRF      FLLNRF                                       CLE148
     C                   MOVE      *BLANKS       FLAUTH
     C                   MOVE      WKSWRI        FLSWRI
     C                   WRITE     LEFELND0
      *
     C                   ENDIF
      *
      ***  If action code is amend
      *
     C     L_CLCHTP      IFEQ      'A'
      *
      ***  Chain to Loan Fee Index File with loan number
      *
     C**********         MOVE      L_CLLNRF      WKLNRF                                       CLE148
     C*****WKLNRF        CHAIN     LEFELNL0                           89                      CLE148
     C     L_CLLNRF      CHAIN     LEFELNL0                           89                      CLE148
      *
      ***  If record not found
      *
     C     *IN89         IFEQ      *ON
      *
      ***  Write a record to Loan Fee Index File
      *
     C**********         MOVE      L_CLLNRF      WKLNRF                                       CLE148
     C**********         Z-ADD     WKLNRF        FLLNRF                                       CLE148
     C                   MOVEL     L_CLLNRF      FLLNRF                                       CLE148
     C                   MOVE      'Y'           FLAUTH
     C                   MOVE      WKSWRI        FLSWRI
     C                   WRITE     LEFELND0
      *
     C                   ELSE
      *
      ***  If work regeneration indicator is changed and regeneration
      ***  indicator is blank
      *
     C     WKSWRI        IFEQ      'C'
     C     FLSWRI        ANDEQ     *BLANKS
      *
      ***  Update the record to Loan Fee Index File
      *
     C                   MOVE      WKSWRI        FLSWRI
     C                   UPDATE    LEFELND0
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
      ***  If action code is authorise
      *
     C     L_CLCHTP      IFEQ      'X'
      *
      ***  Chain to Loan Fee Index File with loan number
      *
     C**********         MOVE      L_CLLNRF      WKLNRF                                       CLE148
     C*****WKLNRF        CHAIN     LEFELNL0                           89                      CLE148
     C     L_CLLNRF      CHAIN     LEFELNL0                           89                      CLE148
      *
      ***  If record is found
      *
     C     *IN89         IFEQ      *OFF
      *
      ***  Update the record to Loan Fee Index File
      *
     C                   MOVE      FLSWRI        WKSWRI
     C                   MOVE      'Y'           FLAUTH
     C                   UPDATE    LEFELND0
     C                   ENDIF
      *
     C                   ENDIF
      *
      ***  If action code is reverse
      *
     C     L_CLCHTP      IFEQ      'R'
      *
      ***  Chain to Loan Fee Index File with loan number
      *
     C**********         MOVE      L_CLLNRF      WKLNRF                                       CLE148
     C*****WKLNRF        CHAIN     LEFELNL0                           89                      CLE148
     C     L_CLLNRF      CHAIN     LEFELNL0                           89                      CLE148
      *
      ***  If record is found
      *
     C     *IN89         IFEQ      *OFF
      *
      ***  If authorised is blank
      *
     C     FLAUTH        IFEQ      *BLANKS
     C                   MOVE      *BLANKS       WKSWRI
     C                   ELSE
      *
      ***  If work regeneration indicator is blank
      *
     C     WKSWRI        IFEQ      *BLANKS
     C                   MOVE      FLSWRI        WKSWRI
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ***  If work regeneration indicator is changed
      *
     C     WKSWRI        IFEQ      'C'
      *
      ***  Check if the facility has an associated fee
      *
     C                   MOVE      WFFACT        CHFACT            3
     C                   MOVE      WFFCNO        CHFCNO            2
     C     CHFACT        CAT       CHFCNO        CHFACL            5
     C                   MOVE      CHFACL        WFFACL
     C**********         Z-ADD     0             WFLOAN                                       CLE148
     C                   MOVEL     *BLANK        WFLOAN                                       CLE148
     C     WKFEE         SETLL     LEFEEDL1
     C*****WKFEE         READE     LEFEEDL1                               89                MD023203
     C     WKFEE         READE (N) LEFEEDL1                               89                MD023203
      *
      ***  Do while an associated fee exists
      *
     C     *IN89         DOWEQ     *OFF
      *
      ***  If the fee is a confirmed calculated fee and swift
      ***  regeneration indicator is not 'I', 'B', 'H'
      *
     C                   MOVE      FEAUTO        WFEAUTO           1                          CLE134
     C     WFEAUTO       IFEQ      'C'                                                        CLE134
     C     FEAUT2        OREQ      'C'                                                        CLE134
     C     CLE134        IFEQ      'Y'                                                        CLE134
     C                   MOVE      'Y'           WFEAUTO                                      CLE134
     C                   END                                                                  CLE134
     C                   END                                                                  CLE134
                                                                                              CLE134
     C*****FEAUTO        IFEQ      'Y'                                                        CLE134
     C     WFEAUTO       IFEQ      'Y'                                                        CLE134
     C     FECALT        ANDNE     *BLANKS
     C     FESWRI        ANDNE     'I'
     C     FESWRI        ANDNE     'B'
     C     FESWRI        ANDNE     'H'
      *
      ***  Set currency to fee currency
      ***  Set day to run date
      ***  Set number of working days to telex notice days
      *
     C                   MOVE      FEFCCY        ZCCY
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   Z-ADD     1             X
     C     FEFCCY        LOOKUP    CYA(X)                                 69
     C                   MOVE      *OFF          *IN69
     C                   MOVE      TND(X)        ZNRDYS
      *
      ***  If Fee Settlement type is '01', '02', '07', '08' or '12'
      *
     C     FESTTL        IFEQ      01
     C     FESTTL        OREQ      02
     C     FESTTL        OREQ      07
     C     FESTTL        OREQ      08
     C     FESTTL        OREQ      12
      *
     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM                    PCUSN             6
     C                   PARM      FEFCCY        PCURR             3
     C**********         PARM                    PACCD             4                          CGL029
     C                   PARM                    PACCD                                        CGL029
     C                   PARM                    PACSN             2
     C                   PARM      FEOURS        PNONB             2
     C                   PARM                    PBRCA             3
     C                   PARM                    PCSSN            10
     C                   PARM                    PPNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      FEFCCY        DBKEY                          *************
     C                   MOVEL     'SDNOSTPD'    DBFILE                         * DBERR 021 *
     C                   Z-ADD     18            DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      SRERR
      *
     C                   ELSE
      *
      ***  Set Location to Nostro Location
      *
     C                   MOVE      A7NOSN        ZLOC
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVE      *BLANKS       ZLOC
      *
     C                   ENDIF
      *
      ***  Calculate number of working days forward
      *
     C                   CALLB     'ZFWDT'
     C                   PARM                    ZDAYNO                         InputDay
     C                   PARM                    ZNRDYS                         DaysFwd
     C                   PARM                    ZDYNBR                         OutputDay
     C                   PARM                    ZCCY                           Currency
     C                   PARM                    ZLOC                           Location
      *
      ***  Set Telex Notice date to day number
      *
     C                   Z-ADD     ZDYNBR        TXDT              5 0
      *                                                                                     MD023203
     C                   MOVEL     FECNUM        WFCNUMX                                    MD023203
     C                   MOVEL     FEFACL        WFFACLX                                    MD023203
     C                   MOVEL     FELOAN        WFLOANX                                    MD023203
     C                   MOVEL     FEFSEQ        WFSEQNX                                    MD023203
      *
      ***  If next payment date is before or equals to Telex Notice date
      ***  and Next Payment Telex indicator is set to 'Y'
      *
     C     FENPYD        IFLE      TXDT
     C     FEPPTI        ANDEQ     'Y'
      *
      ***  Update Fees file
      *
     C     WKFEEX        CHAIN     LEFEEDL0                                                 MD023203
     C                   IF        %FOUND(LEFEEDL0)                                         MD023203
     C**********         MOVE      'A'           FESWRI                                     MD023203
     C**********         UPDATE    LEFEEDF                                                  MD023203
     C                   MOVE      'A'           X_FESWRI                                   MD023203
     C                   UPDATE    LEFEEDX                                                  MD023203
     C                   ENDIF                                                              MD023203
     C                   ELSE
      *
      ***  If end date is before or equals to Telex Notice date and End
      ***  Telex indicator is set to 'Y'
      *
     C     FEPEND        IFLE      TXDT
     C     FEEPTI        ANDEQ     'Y'
      *
      ***  Update Fees file
      *
     C     WKFEEX        CHAIN     LEFEEDL0                                                 MD023203
     C                   IF        %FOUND(LEFEEDL0)                                         MD023203
     C**********         MOVE      'A'           FESWRI                                     MD023203
     C**********         UPDATE    LEFEEDF                                                  MD023203
     C                   MOVE      'A'           X_FESWRI                                   MD023203
     C                   UPDATE    LEFEEDX                                                  MD023203
     C                   ENDIF                                                              MD023203
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C*****WKFEE         READE     LEFEEDL1                                                  BUG3971
     C*****WKFEE         READE     LEFEEDL1                               89        BUG3971 MD023203
     C     WKFEE         READE (N) LEFEEDL1                               89                MD023203
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       WKSWRI
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  262735
      *****************************************************************                       262735
      * PopFee  -  Populate Fee Fields                                *                       262735
      *****************************************************************                       262735
     C     POPFEE        BEGSR                                                                262735
     C                   MOVE      FERECI        F_FERECI                                     262735
     C                   MOVE      FEBRCA        F_FEBRCA                                     262735
     C                   MOVE      FECNUM        F_FECNUM                                     262735
     C                   Z-ADD     FEFACL        F_FEFACL                                     262735
     C                   MOVEL     FELOAN        F_FELOAN                                     262735
     C                   Z-ADD     FEFSEQ        F_FEFSEQ                                     262735
     C                   Z-ADD     FEFCOD        F_FEFCOD                                     262735
     C                   MOVE      FEACOF        F_FEACOF                                     262735
     C                   MOVE      FEFCCY        F_FEFCCY                                     262735
     C                   Z-ADD     FEFAMT        F_FEFAMT                                     262735
     C                   Z-ADD     FEPSTD        F_FEPSTD                                     262735
     C                   Z-ADD     FEPEND        F_FEPEND                                     262735
     C                   MOVE      FEPYON        F_FEPYON                                     262735
     C                   MOVE      FEAUTO        F_FEAUTO                                     262735
     C                   Z-ADD     FESTTL        F_FESTTL                                     262735
     C                   MOVE      QQOURS        F_QQOURS                                     262735
     C                   MOVE      FETHER        F_FETHER                                     262735
     C                   MOVE      FECALT        F_FECALT                                     262735
     C                   Z-ADD     FEFRT1        F_FEFRT1                                     262735
     C                   Z-ADD     FEFRT2        F_FEFRT2                                     262735
     C                   Z-ADD     FEFRT3        F_FEFRT3                                     262735
     C                   Z-ADD     FEFRT4        F_FEFRT4                                     262735
     C                   Z-ADD     FEFRT5        F_FEFRT5                                     262735
     C                   Z-ADD     FEAMT1        F_FEAMT1                                     262735
     C                   Z-ADD     FEAMT2        F_FEAMT2                                     262735
     C                   Z-ADD     FEAMT3        F_FEAMT3                                     262735
     C                   Z-ADD     FEAMT4        F_FEAMT4                                     262735
     C                   Z-ADD     FEAMT5        F_FEAMT5                                     262735
     C                   Z-ADD     FECALC        F_FECALC                                     262735
     C                   Z-ADD     FEERAT        F_FEERAT                                     262735
     C                   MOVE      FEMDIN        F_FEMDIN                                     262735
     C                   Z-ADD     FENPYD        F_FENPYD                                     262735
     C                   MOVE      FEFREQ        F_FEFREQ                                     262735
     C                   Z-ADD     FEDYIM        F_FEDYIM                                     262735
     C                   MOVE      FEPIND        F_FEPIND                                     262735
     C                   MOVE      FEDIND        F_FEDIND                                     262735
     C                   Z-ADD     FEAMTP        F_FEAMTP                                     262735
     C                   Z-ADD     FEAMTA        F_FEAMTA                                     262735
     C                   Z-ADD     FEAMTS        F_FEAMTS                                     262735
     C                   Z-ADD     FESDAT        F_FESDAT                                     262735
     C                   Z-ADD     FELPDT        F_FELPDT                                     262735
     C                   Z-ADD     FELADT        F_FELADT                                     262735
     C                   Z-ADD     FEADAT        F_FEADAT                                     262735
     C                   Z-ADD     FEDDAT        F_FEDDAT                                     262735
     C                   Z-ADD     FEAMTO        F_FEAMTO                                     262735
     C                   MOVE      FELTYP        F_FELTYP                                     262735
     C                   MOVE      FESUTP        F_FESUTP                                     262735
     C                   Z-ADD     FEORED        F_FEORED                                     262735
     C                   Z-ADD     FEPLPD        F_FEPLPD                                     262735
     C                   MOVE      FESPTI        F_FESPTI                                     262735
     C                   MOVE      FEPPTI        F_FEPPTI                                     262735
     C                   MOVE      FEEPTI        F_FEEPTI                                     262735
     C                   MOVE      FESBTI        F_FESBTI                                     262735
     C                   MOVE      FEPBTI        F_FEPBTI                                     262735
     C                   MOVE      FEEBTI        F_FEEBTI                                     262735
     C                   MOVE      FELCHT        F_FELCHT                                     262735
     C                   Z-ADD     FELCHD        F_FELCHD                                     262735
     C                   Z-ADD     FETNLU        F_FETNLU                                     262735
     C                   MOVE      FEOSBR        F_FEOSBR                                     262735
     C                   Z-ADD     FELPAM        F_FELPAM                                     262735
     C                   Z-ADD     FEPAMS        F_FEPAMS                                     262735
     C                   Z-ADD     FEPAMP        F_FEPAMP                                     262735
     C                   Z-ADD     FEADBP        F_FEADBP                                     262735
     C                   MOVE      FSTS          F_FSTS                                       262735
     C                   MOVE      IUSR          F_IUSR                                       262735
     C                   MOVE      AUSR          F_AUSR                                       262735
     C                   MOVE      XUSR          F_XUSR                                       262735
     C                   MOVE      PCRF          F_PCRF                                       262735
     C                   MOVE      PTFI          F_PTFI                                       262735
     C                   MOVE      SHFI          F_SHFI                                       262735
     C                   MOVE      OSDB          F_OSDB                                       262735
     C                   MOVE      OMDB          F_OMDB                                       262735
     C                   Z-ADD     RSTM          F_RSTM                                       262735
     C                   MOVE      RONSQQ        F_RONSQQ                                     262735
     C                   MOVE      RIBN          F_RIBN                                       262735
     C                   MOVE      RIBA          F_RIBA                                       262735
     C                   MOVE      ROBN          F_ROBN                                       262735
     C                   MOVE      ROCN          F_ROCN                                       262735
     C                   Z-ADD     PSTM          F_PSTM                                       262735
     C                   MOVE      PONSQQ        F_PONSQQ                                     262735
     C                   MOVE      PIBN          F_PIBN                                       262735
     C                   MOVE      PIBA          F_PIBA                                       262735
     C                   MOVE      POBN          F_POBN                                       262735
     C                   MOVE      POCN          F_POCN                                       262735
     C                   MOVE      RCRN          F_RCRN                                       262735
     C                   MOVE      RCRA          F_RCRA                                       262735
     C                   MOVE      RVNO          F_RVNO                                       262735
     C                   MOVE      AWBN          F_AWBN                                       262735
     C                   MOVE      AWBA          F_AWBA                                       262735
     C                   MOVE      BENN          F_BENN                                       262735
     C                   MOVE      BENA          F_BENA                                       262735
     C                   MOVE      DTP1          F_DTP1                                       262735
     C                   MOVE      DTP2          F_DTP2                                       262735
     C                   MOVE      DTP3          F_DTP3                                       262735
     C                   MOVE      DTP4          F_DTP4                                       262735
     C                   MOVE      DCHG          F_DCHG                                       262735
     C                   MOVE      BTB1          F_BTB1                                       262735
     C                   MOVE      BTB2          F_BTB2                                       262735
     C                   MOVE      BTB3          F_BTB3                                       262735
     C                   MOVE      BTB4          F_BTB4                                       262735
     C                   MOVE      BTB5          F_BTB5                                       262735
     C                   MOVE      BTB6          F_BTB6                                       262735
     C                   MOVE      CVMR          F_CVMR                                       262735
     C                   MOVE      GFPT          F_GFPT                                       262735
     C                   MOVE      PTAI          F_PTAI                                       262735
     C                   MOVE      SMAC          F_SMAC                                       262735
     C                   MOVE      PCOB          F_PCOB                                       262735
     C                   MOVE      FEPRFC        F_FEPRFC                                     262735
     C                   Z-ADD     LSWC          F_LSWC                                       262735
     C                   Z-ADD     LSWS          F_LSWS                                       262735
     C                   Z-ADD     FETADJ        F_FETADJ                                     262735
     C                   MOVE      FESCCY        F_FESCCY                                     262735
     C                   MOVE      FEICCY        F_FEICCY                                     262735
     C                   Z-ADD     FEWOFF        F_FEWOFF                                     262735
     C                   MOVE      FEINDC        F_FEINDC                                     262735
     C                   MOVE      FESWRI        F_FESWRI                                     262735
     C                   Z-ADD     FEAMTW        F_FEAMTW                                     262735
     C                   Z-ADD     FEREXR        F_FEREXR                                     262735
     C                   MOVE      FEREXI        F_FEREXI                                     262735
     C                   MOVE      FEPSCY        F_FEPSCY                                     262735
     C                   Z-ADD     FEPEXR        F_FEPEXR                                     262735
     C                   MOVE      FEPEXI        F_FEPEXI                                     262735
     C                   MOVE      FRNT          F_FRNT                                       262735
     C                   MOVE      AFRT          F_AFRT                                       262735
     C                   MOVE      REPA          F_REPA                                       262735
     C                   MOVE      STMP          F_STMP                                       262735
     C                   MOVE      FESTAL        F_FESTAL                                     262735
     C                   MOVE      FEOURS        F_FEOURS                                     262735
     C                   MOVE      RONS          F_RONS                                       262735
     C                   MOVE      PONS          F_PONS                                       262735
     C                   MOVE      FEAUTH        F_FEAUTH                                     262735
     C                   MOVE      FEADJY        F_FEADJY                                     262735
     C                   Z-ADD     FEAMTD        F_FEAMTD                                     262735
     C                   Z-ADD     FEFEAM        F_FEFEAM                                     262735
     C                   Z-ADD     FEFEAC        F_FEFEAC                                     262735
     C                   Z-ADD     FEAFES        F_FEAFES                                     262735
     C                   Z-ADD     FEAFEE        F_FEAFEE                                     262735
     C                   Z-ADD     FEAFOF        F_FEAFOF                                     262735
     C                   Z-ADD     FETFTD        F_FETFTD                                     262735
     C                   Z-ADD     FEAFLS        F_FEAFLS                                     262735
     C                   Z-ADD     FEUAFA        F_FEUAFA                                     262735
     C                   Z-ADD     FEAFLD        F_FEAFLD                                     262735
     C                   MOVE      FENLAI        F_FENLAI                                     262735
     C                   MOVE      FEMASF        F_FEMASF                                     262735
     C                   MOVE      FESYIN        F_FESYIN                                     262735
     C                   MOVE      FECLAS        F_FECLAS                                     262735
     C                   Z-ADD     FESAMT        F_FESAMT                                     262735
     C                   MOVE      FEAMRI        F_FEAMRI                                     262735
     C                   Z-ADD     FESTPD        F_FESTPD                                     262735
     C                   Z-ADD     FEENPD        F_FEENPD                                     262735
     C                   ENDSR                                                                262735
      /EJECT
      *****************************************************************
      * SRSHDW  -  Update shadow files                                *
      *****************************************************************
     C     SRSHDW        BEGSR

     C*****PCRFL         CHAIN     LESTALLA                           99             BUG9225 CSF011A
     C     PTREF         CHAIN     LESTALLA                           99                     CSF011A
     C     *IN99         DOWEQ     *OFF                                                      BUG9225
     C**********         Z-ADD     LNRF          XXLNRF                               BUG9225 CLE148
     C                   MOVEL     LNRF          XXLNRF                                       CLE148
     C                   EVAL      XXPTRF = PCRFL                                            CSF011A
     C                   UPDATE    LESTALD0                                                  BUG9225
     C*****PCRFL         READE     LESTALLA                               99         BUG9225 CSF011A
     C     PTREF         READE     LESTALLA                               99                 CSF011A
     C                   ENDDO                                                               BUG9225
     C                   EVAL      PTREF = PCRFL                                             CSF011A
                                                                                           AR317473A
      ** If this is a new PDCL, only do shadow posting if Decrease ='N'                    AR317473A
                                                                                           AR317473A
     C                   SETOFF                                       99                   AR317473A
     C                   IF        CLE134      = 'Y'           AND                         AR317473A
     C                             CHTP        = 'I'           AND                         AR317473A
     C                             (%SUBST(LTYP: 1: 1) = 'Y'   OR                          AR317473A
     C                              %SUBST(LTYP: 1: 1) = 'X')                              AR317473A
     C     LNRF          CHAIN     LEPDUEL1                           99                   AR317473A
     C                   IF        *IN99       = '0'           AND                         AR317473A
     C                             YDECRE      = 'Y'                                       AR317473A
     C                   SETON                                        99                   AR317473A
     C                   ENDIF                                                             AR317473A
                                                                                           AR317473A
      ** Shadow Posting must be for take-on account.                                       AR317473A
                                                                                           AR317473A
     C                   IF        *IN99       = '0'           AND                         AR317473A
     C                             YDECRE      = 'N'                                       AR317473A
     C                   IF        SDST        = 05                                        AR317473A
     C                   MOVEL     YTKPACL       OSDA                                      AR317473A
     C                   MOVEL     YTKPAAC       OSDA12           12                       AR317473A
     C                   MOVE      YTKPASE       OSDA12                                    AR317473A
     C                   MOVE      OSDA12        OSDA                                      AR317473A
     C                   MOVEL     YTKPABR       OSDB                                      AR317473A
     C                   MOVEL     LOANL         Z#ASTS                                    AR317473A
     C                   ENDIF                                                             AR317473A
     C                   IF        SDST        = 14                                        AR317473A
     C     KACCNT        CHAIN     ACCNT                              98                   AR317473A
     C                   IF        *IN98       = '0'                                       AR317473A
     C                   MOVEL     QZACNO        OSDA                                      AR317473A
     C                   MOVEL     LOANL         Z#ASTS                                    AR317473A
     C                   ENDIF                                                             AR317473A
     C                   ENDIF                                                             AR317473A
     C                   ENDIF                                                             AR317473A
     C                   ENDIF                                                             AR317473A
      *
      ***  Do on-line updates to PRONO, MEMOS, OLPOS and RSACMTPD
      ***  only if not a Guarantee loan, if its a Guarantee loan then
      ***  it should have an interest payment date.
      *
     C     PTYP          IFEQ      61
     C     PTYP          OREQ      62
     C     PTYP          OREQ      63
     C     PTYP          OREQ      64
     C     PTYP          OREQ      65
     C     PTYP          OREQ      66
     C     PTYP          OREQ      67
     C     PTYP          OREQ      68
     C     PTYP          OREQ      69
     C     PTYP          OREQ      70
     C     NIDT          ANDNE     0
     C     PTYP          OREQ      71
     C     NIDT          ANDNE     0
     C     PTYP          OREQ      72
     C     NIDT          ANDNE     0
                                                                                             BUG3721
     C     PTYP          OREQ      80                                                        BUG3721
     C     CLE028        ANDEQ     'Y'                                                       BUG3721
                                                                                             BUG3721
     C     @Type         IFEQ      '0'
     C                   MOVE      '*LEBTCH'     PRTCD
     C                   ELSE
     C                   MOVE      *BLANKS       PRTCD
     C                   ENDIF
      * If authorization required clear settlement details.                                   CLE055
     C                   If        CLE055 = 'Y'                                               CLE055
     C                   If        *In82  = *on  and  BPPPAU = 'Y' or                         CLE055
     C                             *In83  = *on  and  BPPSAU = 'Y' or                         CLE055
     C                             *In82  = *off and  *In83  = *off  and                      CLE055
     C                                                BPLOAU = 'Y'                            CLE055
                                                                                              CLE055
     C                   Select                                                               CLE055
     C                   When      L_CLCHTP = 'I'                                             CLE055
     C                   Eval      Z#ASTS   =    Z#ZASTS                                      CLE055
     C                   When      L_CLCHTP = 'A'                                             CLE055
     C                   Eval      Z#BSTS   =    Z#ZBSTS                                      CLE055
     C                   Eval      Z#ASTS   =    Z#ZASTS                                      CLE055
     C                   When      L_CLCHTP = 'X' or L_CLCHTP = 'Q'                           CLE055
     C                   Eval      Z#BSTS   =    Z#ZBSTS                                      CLE055
     C                   Eval      Z#ASTS   =    Z#ZASTS                                      CLE055
     C                   When      L_CLCHTP = 'R'                                             CLE055
     C                   Eval      Z#BSTS   =    Z#ZBSTS                                      CLE055
     C**********         Eval      Z#ASTS   =    Z#ZASTS                               CLE055 243048
     C**********         Eval      Z#ASTS   =    Z#ZASTS                               255240 256233
     C                   Endsl                                                                CLE055
                                                                                              CLE055
     C                   Endif                                                                CLE055
     C                   Endif                                                                CLE055
      *
     C                   IF        CLE134      = 'N'           OR                          AR317473A
     C                             CLE134      = 'Y'           AND                         AR317473A
     C**********                   *IN99       = '0'                              AR317473A MD026167
     C                             *IN99       = '0'           AND                          MD026167
     C                             MPHAS       = 'A'           OR                           MD026167
     C                             CLE134      = 'Y'           AND                          MD026167
     C                             *IN99       = '0'           AND                          MD026167
     C                             MPHAS       = 'G'                                        MD026167
     C                   CALL      'AOOULEU0'
     C                   PARM                    @RTCD
     C                   PARM                    Z#BSTS
     C                   PARM                    Z#ASTS
     C                   PARM                    Z#WSTS
     C                   PARM                    Z#BSTK                                       222373
     C                   PARM                    Z#ASTK                                       222373
     C                   PARM                    TranInExt                                    CER049
     C                   ENDIF                                                             AR317473A
      *                                                                                     AR868380
     C     @RTCD         IFEQ      '*RECLCK'                                                AR868380
     C                   MOVEL     '*RECLCK'     @@RTCD                                     AR868380
     C                   GOTO      EXIT                                                     AR868380
     C                   ENDIF                                                              AR868380
      *
     C     @RTCD         IFEQ      '*ERROR*'
     C                   EXSR      *PSSR
     C                   END
     C                   ENDIF
     C/COPY WNCPYSRC,LEH01180
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * SRACSLTH -  Access the LTRIX header record                   *
      ****************************************************************
     C     SRACSLTH      BEGSR
      *
      ***  Chain to transaction header to test whether full
      *
     C**********         Z-ADD     1             LXRRN             5 0                      AR322732
     C*****LXRRN         CHAIN(N)  LTRIX                              89                    AR322732
     C**********         Z-ADD     RRNAD         WRRNA             5 0                      AR322732
      *
     C******IN89         IFEQ      '1'                                                      AR322732
     C*****RRNAD         ORGT      FLSZD                                                    AR322732
     C******LOCK         IN        LDA                                                      AR322732
     C**********         MOVE      LXRRN         DBKEY                          ************AR322732
     C**********         MOVEL     'LTRIX   '    DBFILE                         * DBERR 022 AR322732
     C**********         Z-ADD     19            DBASE                          ************AR322732
     C**********         OUT       LDA                                                      AR322732
     C**********         EXSR      SRERR                                                    AR322732
     C**********         ENDIF                                                              AR322732
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * ACSREL -  Access related loan                                *
      ****************************************************************
     C     ACSREL        BEGSR
      *
      * 'A' record
     C                   MOVE      L_CLOLNO      WALON
     C                   MOVE      'A'           WEPAR
     C     WKLON         CHAIN     CLOAN                              99
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      L_CLOLNO      DBKEY
     C                   MOVEL     'CLOAN   '    DBFILE
     C                   Z-ADD     20            DBASE
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
      *
     C                   MOVE      CCY           CCY_M             3
     C**********         Z-ADD     FCUS          FCUS_M            6 0                        CSD027
     C                   MOVE      FCUS          FCUS_M            6                          CSD027
     C                   Z-ADD     FTYP          FTYP_M            3 0
     C                   Z-ADD     FSEQ          FSEQ_M            2 0
     C                   Z-ADD     FCXR          FCXR_M           13 8
     C                   MOVE      FMDI          FMDI_M            1
     C                   MOVE      ORBR          ORBR_M            3
     C                   MOVE      CRSK          CRSK_M            2
     C**********         MOVE      LIND          LIND_M            3                          CER020
     C                   MOVE      LOIC          LIND_M            3                          CER020
     C                   MOVE      PRFC          PRFC_M            4
     C                   MOVE      FCCY          FCCY_M            3
     C                   MOVE      FCLB          FCLB_M            3
     C                   MOVE      PTYP          PTYP_M            2 0
     C                   Z-ADD     RLDT          RLDT_M            5 0
     C**********         Z-ADD     PTFC          PTFC_M            6 0               BUG8642 CSD027A
     C                   MOVE      PTFC          PTFC_M            6                         CSD027A
     C                   Z-ADD     PTFT          PTFT_M            3 0                       BUG8642
     C                   Z-ADD     PTFN          PTFN_M            2 0                       BUG8642
      *
     C                   MOVE      L_CLOLNO      WALON
     C                   MOVE      'B'           WEPAR
     C     WKLON         CHAIN(N)  CLOAN                              99
     C     *IN99         IFEQ      '0'
     C                   Z-ADD     NBRA          NBRA_M            2 0
     C                   Z-ADD     NCAS          NCAS_M            1 0
     C                   MOVE      NCHI          NCHI_M            1
     C                   MOVE      NCCY          NCCY_M            3
     C                   Z-ADD     NFCE          NFCE_M           13 8
     C                   MOVE      NFMD          NFMD_M            1
     C                   Z-ADD     NBCE          NBCE_M           13 8
     C                   MOVE      NBMD          NBMD_M            1
     C                   ENDIF
     C*                                                                                      BUG8464
     C                   MOVE      *BLANKS       W72TP             2                         BUG8464
     C     L_CLPTYP      IFEQ      72                                                        BUG8464
     C                   SELECT                                                              BUG8464
     C     PTYP_M        WHENEQ    62                                                        BUG8464
     C     PTYP_M        OREQ      64                                                        BUG8464
     C                   MOVE      '66'          W72TP                                       BUG8464
     C     PTYP_M        WHENEQ    61                                                        BUG8464
     C     PTYP_M        OREQ      68                                                        BUG8464
     C                   MOVE      '69'          W72TP                                       BUG8464
     C     PTYP_M        WHENEQ    63                                                        BUG8464
     C     PTYP_M        OREQ      65                                                        BUG8464
     C                   MOVE      '67'          W72TP                                       BUG8464
     C     PTYP_M        WHENEQ    70                                                        BUG8464
     C     PTYP_M        OREQ      71                                                        BUG8464
     C                   MOVE      '70'          W72TP                                       BUG8464
     C                   ENDSL                                                               BUG8464
     C                   ENDIF                                                               BUG8464

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * UPD24X7LOG - Update 24X7 Log                                 *
      ****************************************************************
     C     UPD24X7LOG    BEGSR
      *
      ***  Process customer loans input log file
      *
     C                   MOVEL     SPI1          K_SPI1
     C                   MOVEL     SPI2          K_SPI2
     C                   MOVEL     SPI3          K_SPI3
     C                   CALLB     'LECLIPLOG'
     C                   PARM      *BLANKS       RETCODEOUT       10
     C                   PARM                    L_CLCHTP
     C                   PARM                    LoanL
     C                   PARM                    LoanK
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028                                      BUG3721
                                                                                             BUG3721
     C                   PARM                    TRANSDTL
      *
      ***  Write to support database log file
      *
     C     RETCODEOUT    IFEQ      *BLANKS
      *
     C                   EVAL      APTGTTYPE = 'LECLIP'
     C                   EVAL      APUSERID = PSUser
     C                   MOVEL     L_CLFRNT      APFOTRANID
     C                   MOVEL     L_CLLNRF      W@CLLNRF          6
     C**********         MOVE      *BLANKS       PDEALNO          18                          CGL029
     C                   MOVE      *BLANKS       PDEALNO                                      CGL029
     C                   EVAL      PDEALNO = W@CLLNRF
     C                   EVAL      PADEALNO = *BLANKS
      *
      *
     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RETCODEOUT
     C                   PARM                    APHEAD
     C                   PARM                    TRANSDTL
     C                   PARM      *BLANKS       WTIMESTAMP       26
     C                   PARM                    PDEALNO                                      CGL029
     C                   PARM                    PADEALNO                                     CGL029
     C**********         PARM                    PDEALNO          18                          CGL029
     C**********         PARM                    PADEALNO         18                          CGL029
      *
     C                   ENDIF
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * SRRELL  -  Update related loan record for parts sold         *
      ****************************************************************
     C     SRRELL        BEGSR
      *
     C     PTYP_M        IFNE      72
     C     L_CLPTYP      ANDNE     72
     C     PTYP_M        OREQ      70
     C     L_CLPTYP      ANDEQ     72
     C     PTYP_M        OREQ      71
     C     L_CLPTYP      ANDEQ     72
     C*****PTYP_M        OREQ      72                                                         260408
     C     PTYP_M        ORNE      72                                                         260408
     C     L_CLPTYP      ANDEQ     72
     C***********        Z-ADD     L_CLLNRF      WSCLLNRF          6 0                        CLE148
     C                   MOVEL     L_CLLNRF      WSCLLNRF          6                          CLE148
     C     *IN83         IFEQ      '1'
     C***********        Z-ADD     L_CLOLNO      L_CLLNRF                                     CSD027
     C                   MOVE      L_CLOLNO      L_CLLNRF                                     CSD027
     C                   ELSE
     C**********         Z-ADD     L_CLMLNR      L_CLLNRF                                     CLE148
     C                   MOVEL     L_CLMLNR      L_CLLNRF                                     CLE148
     C                   ENDIF
     C     KCLLNRF       CHAIN     CLOANCLF                           89
     C     *IN89         IFEQ      '1'
     C     *IN89         OREQ      '0'
     C     RECI          ANDNE     'D'
     C     *LOCK         IN        LDA
     C                   MOVE      L_CLLNRF      DBKEY                          *************
     C                   MOVEL     'CLOAN   '    DBFILE                         * DBERR 023 *
     C                   Z-ADD     21            DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
     C**********         Z-ADD     WSCLLNRF      L_CLLNRF                                     CLE148
     C                   MOVEL     WSCLLNRF      L_CLLNRF                                     CLE148
      *
      ***  Update parts sold amount and number of parts sold
      *
     C     L_CLCHTP      IFEQ      'I'
     C                   ADD       L_CLCPAM      PSAM
     C                   ADD       1             NOPS
     C                   ELSE
     C                   SUB       L_CLCPAM      PSAM
     C                   SUB       1             NOPS
     C                   ENDIF
     C                   Z-ADD     BJRDNB        LCD
     C     L_CLCHTP      IFNE      'R'
     C                   MOVE      'A'           CHTP
     C                   ENDIF
     C                   Z-ADD     NATN          TNLU
      *
     C                   UPDATE    CLOANCLF
      *
     C                   ENDIF
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * WRT_LERELE - WRITE TO LERELEPD                               *
      ****************************************************************
     C     WRT_LERELE    BEGSR

      *
      ** And move fields to and update the released items file - LERELEPD
      *
     C                   MOVE      L_CLRECI      RERECI
     C                   MOVE      L_CLLNRF      RELNRF
     C                   MOVE      L_CLPTYP      REPTYP
     C                   MOVE      L_CLCNUM      RECNUM
     C                   MOVE      L_CLBRCA      REBRCA
     C                   MOVE      L_CLLTYP      RELTYP
     C                   MOVE      L_CLSUTP      RESUTP
     C                   MOVE      L_CLCLAS      RECLAS                                       CLE042
     C                   MOVE      L_CLDDAT      REDDAT
     C                   MOVE      L_CLVDAT      REVDAT
     C                   MOVE      L_CLMDAT      REMDAT
     C                   MOVE      L_CLFCUS      REFCUS
     C                   MOVE      L_CLFTYP      REFTYP
     C                   MOVE      L_CLFSEQ      REFSEQ
     C                   MOVE      L_CLCCY       RECCY
     C                   MOVE      L_CLCPAM      RECPAM
     C                   MOVE      L_CLXUSR      REXUSR
     C                   MOVE      PSUser        RERUSR
     C                   MOVE      BJRDNB        RELCD
     C                   MOVE      *BLANKS       WTIME             6
     C                   EVAL      WTIME  = WREHRS + WREMIN + WRESEC
     C                   MOVE      WTIME         RETIME

     C                   WRITE     LERELED0

     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * ACS_NXTAVL - ACCESS NEXT AVAILABLE LOAN REFERENCE            *
      ****************************************************************
     C     ACS_NXTAVL    BEGSR
     C                   CALL      'AOLENOU0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY'        @OPTN
     C                   PARM                    @PRANG
     C     SDLENO        PARM      SDLENO        DSFDY
     C*****F9NALN        SUB       1             F9NALN                               CAP084 BUG7870
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     @PRANG        DBKEY                          *************
     C                   MOVEL     'SDLENOPD'    DBFILE                         * DBERR 002 *
     C                   Z-ADD     91            DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
     C*****F9NALN        IFGT      0                                                  BUG7870 CLE148
     C*****F9NALN        SUB       1             F9NALN                        CAP084 BUG7870 CLE148
     C**********         ENDIF                                                        BUG7870 CLE148
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * ACS_BRCA - ACCESS BRANCH                                     *
      ****************************************************************
     C     ACS_BRCA      BEGSR
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @BRCD             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      @BRCD         DBKEY                          *************
     C                   MOVEL     'SDBRCHPD'    DBFILE                         * DBERR 005 *
     C                   Z-ADD     92            DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * ACS_CURR - ACCESS CURRENCY                                   *
      ****************************************************************
     C     ACS_CURR      BEGSR
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      @CYCD         DBKEY                          *************
     C                   MOVEL     'SDCURRPD'    DBFILE                         * DBERR 007 *
     C                   Z-ADD     93            DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * ZCONVZ1 - CONVERSION                                         *
      ****************************************************************
     C     ZCONVZ1       BEGSR
     C                   CALLB     'ZCONVZ1'
     C                   PARM                    ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
     C                   PARM                    ZAMTCO
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * ZXRATE - CROSS RATE CALCULATION                              *
      ****************************************************************
     C     ZXRATE        BEGSR
     C                   CALLB     'ZXRATE'                                                   CLE023
     C                   PARM                    ZRATE1           13 8                        CLE023
     C                   PARM                    ZMDI1             1                          CLE023
     C                   PARM                    ZRATE2           13 8                        CLE023
     C                   PARM                    ZMDI2             1                          CLE023
     C                   PARM                    ZRATEX           13 8                        CLE023
     C                   PARM                    ZMDIX             1                          CLE023
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * SRERR - EXCEPTION ERRORS                                     *
      ****************************************************************
     C     SRERR         BEGSR
      *
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'LECLIPUPD'   DBPGM            10
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
      *
      ***  Terminate the Program
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************                       CRE020
      /EJECT                                                                                  CRE020
      *****************************************************************                       CRE020
      *                                                               *                       CRE020
      *  SRIdxTrn - Handles the advice index of the current           *                       CRE020
      *             transaction.                                      *                       CRE020
      *                                                               *                       CRE020
      *****************************************************************                       CRE020
     C     SRIdxTrn      BEGSR                                                                CRE020
                                                                                              CRE020
      ** Initialise key values.                                                               CRE020
                                                                                              CRE020
     C                   MOVE      *BLANKS       KRefNo                                       CRE020
     C                   MOVEL     LNRF          KRefNo                                       CRE020
                                                                                              CRE020
      ** Begin advice index processing.                                                       CRE020
                                                                                              CRE020
     C                   MOVE      *BLANK        WNew                                         CRE020
                                                                                              CRE020
     C                   OPEN      READVCL1                                                   CRE020
                                                                                              CRE020
     C     KADVC         SETLL     READVCL1                                                   CRE020
     C     KADVC         READE     READVCL1                                                   CRE020
                                                                                              CRE020
     C                   DOW       NOT %EOF                                                   CRE020
                                                                                              CRE020
      ** Check first if this is a new advice index.                                           CRE020
                                                                                              CRE020
     C                   IF        WNew = *BLANK                                              CRE020
     C                   IF        RCHTYP = 'I' AND                                           CRE020
     C                             RSAPIN = 'N'                                               CRE020
     C                   MOVE      'Y'           WNew                                         CRE020
     C                   ELSE                                                                 CRE020
     C                   MOVE      'N'           WNew                                         CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Set default values if the advice indicator is equal to blank.                        CRE020
                                                                                              CRE020
     C                   IF        RSAPIN = ' '                                               CRE020
                                                                                              CRE020
     C                   IF        CHTP = 'R'                                                 CRE020
     C                   MOVE      'R'           RCHTYP                                       CRE020
     C                   MOVE      'Y'           RSAPIN                                       CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
      ** Change type is always 'I' for newly inserted records.                                CRE020
                                                                                              CRE020
     C                   MOVE      'I'           RCHTYP                                       CRE020
     C                   MOVE      'N'           RSAPIN                                       CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   MOVE      'Y'           RAUTHI                                       CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
      ** Execute reversal processing if necessary.                                            CRE020
                                                                                              CRE020
     C                   IF        CHTP = 'R'                                                 CRE020
                                                                                              CRE020
      ** Delete the advice index if the current record is a new loan.                         CRE020
      ** Reverse it otherwise.                                                                CRE020
                                                                                              CRE020
     C                   MOVE      'R'           RCHTYP                                       CRE020
                                                                                              CRE020
     C                   IF        RAUTHI = 'N'                                               CRE020
     C                   MOVE      'Y'           RAUTHI                                       CRE020
                                                                                              CRE020
     C                   IF        WNew = 'Y'                                                 CRE020
     C                   MOVE      'Y'           RSAPIN                                       CRE020
     C                   ELSE                                                                 CRE020
     C                   MOVE      'N'           RSAPIN                                       CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
      ** Execute amend processing.                                                            CRE020
                                                                                              CRE020
     C                   IF        WNew = 'Y'                                                 CRE020
     C                   MOVE      'I'           RCHTYP                                       CRE020
                                                                                              CRE020
      ** Change field values only if the authorise indicator is equal to 'N'.                 CRE020
                                                                                              CRE020
     C                   IF        RAUTHI = 'N'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        RAUTHI = 'N'                                               CRE020
     C                   MOVE      CHTP          RCHTYP                                       CRE020
     C                   MOVE      'Y'           RAUTHI                                       CRE020
     C                   MOVE      'N'           RSAPIN                                       CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   UPDATE    READVCD0                                                   CRE020
                                                                                              CRE020
     C     KADVC         READE     READVCL1                                                   CRE020
     C                   ENDDO                                                                CRE020
                                                                                              CRE020
     C                   CLOSE     READVCL1                                                   CRE020
                                                                                              CRE020
     C                   ENDSR                                                                CRE020
      *****************************************************************                       CRE020
      /EJECT                                                                                  CRE020
      *****************************************************************                       CRE020
      *                                                               *                       CRE020
      *  SRIdxAmd - Handles the advice index during 'A' processing.   *                       CRE020
      *                                                               *                       CRE020
      *****************************************************************                       CRE020
     C     SRIdxAmd      BEGSR                                                                CRE020
                                                                                              CRE020
      ** Initialise key values.                                                               CRE020
                                                                                              CRE020
     C                   MOVE      *BLANKS       KRefNo                                       CRE020
     C                   MOVEL     LNRF          KRefNo                                       CRE020
                                                                                              CRE020
      ** Begin advice index processing.                                                       CRE020
                                                                                              CRE020
     C                   OPEN      READVCL1                                                   CRE020
                                                                                              CRE020
     C     KADVC         SETLL     READVCL1                                                   CRE020
     C     KADVC         READE     READVCL1                                                   CRE020
                                                                                              CRE020
     C                   DOW       NOT %EOF                                                   CRE020
                                                                                              CRE020
      ** Execute amend processing if necessary.                                               CRE020
                                                                                              CRE020
     C                   IF        RAUTHI = 'Y' AND                                           CRE020
     C                             RSAPIN = 'N'                                               CRE020
     C                   MOVE      'N'           RAUTHI                                       CRE020
     C                   UPDATE    READVCD0                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C     KADVC         READE     READVCL1                                                   CRE020
     C                   ENDDO                                                                CRE020
                                                                                              CRE020
     C                   CLOSE     READVCL1                                                   CRE020
                                                                                              CRE020
     C                   ENDSR                                                                CRE020
      /EJECT                                                              CSC011
      *****************************************************************                       CAS011
      *                                                               *                       CAS011
      *  SEIRI1 - Set EIR Indicators to re-calculate.                 *                       CAS011
      *                                                               *                       CAS011
      *****************************************************************                       CAS011
      *                                                                                       CAS011
     C     SEIRI1        BEGSR                                                                CAS011
      *                                                                                       CAS011
     C                   MOVE      *IN81         SVIN81                                       CAS011
      *                                                                                       CAS011
     C                   IF        CAS016 = 'Y'                                               CAS019
     C     WTRAN         CHAIN     LEEIRDL9                           81                      CAS019
     C                   ELSE                                                                 CAS019
     C     WTRAN         CHAIN     LEEIRDD5                           81                      CAS011
     C                   ENDIF                                                                CAS019
      *                                                                                       CAS011
     C     *IN81         IFEQ      '0'                                                        CAS011
     C     WVALD         ANDLE     EIENDT                                                     CAS011
      *                                                                                       CAS011
     C                   MOVE      'Y'           EIRCAL                                       CAS011
      *                                                                                       CAS011
     C     WDELR         IFEQ      'Y'                                                        CAS011
     C     WADJP         OREQ      'Y'                                                        CAS011
     C                   MOVE      'Y'           EIADJP                                       CAS011
     C                   ENDIF                                                                CAS011
      *                                                                                       CAS011
     C                   IF        CAS016 = 'Y'                                               CAS019
     C                   UPDATE    LEEIRDD9                                                   CAS019
     C                   ELSE                                                                 CAS019
     C                   UPDATE    LEEIRDD5                                                   CAS011
     C                   ENDIF                                                                CAS019
      *                                                                                       CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS019
      ** Search all fees amortised separately                                                 CAS019
                                                                                              CAS019
     C                   IF        CAS016 = 'Y'                                               CAS019
     C     WTRAN         CHAIN     LEERAPL0                           81                      CAS019
     C                   DOW       *IN81 = '0'                                                CAS019
      *                                                                                       CAS019
     C     VDAT          IFLE      EIENDT                                                     CAS019
     C                   MOVE      'Y'           EIRCAL                                       CAS019
     C                   UPDATE    LEERAPD0                                                   CAS019
     C                   ENDIF                                                                CAS019
      *                                                                                       CAS019
     C     WTRAN         READE     LEERAPL0                               81                  CAS019
     C                   ENDDO                                                                CAS019
      *                                                                                       CAS019
     C                   ENDIF                                                                CAS019
      *                                                                                       CAS011
     C                   MOVE      SVIN81        *IN81                                        CAS011
     C                   ENDSR                                                                CAS011
      *****************************************************************                       CAS011
      /EJECT                                                                                  CAS011
      *****************************************************************                       CAS011
      *                                                               *                       CAS011
      *  EIRRTN - Routine for EIR processing                          *                       CAS011
      *                                                               *                       CAS011
      *****************************************************************                       CAS011
      *                                                                                       CAS011
     C     EIRRTN        BEGSR                                                                CAS011
      *                                                                                       CAS011
      ** Only process EIR cost accounting if loan's value date is same                        CAS011
      ** as or after the non-linear amortisation cut-off date                                 CAS011
     C     L_CLVDAT      IFGE      FSNLAC                                                     CAS011
      *                                                                                       CAS011
     C     L_CLPTYP      IFNE      70                                                         CAS011
     C     L_CLPTYP      ANDNE     71                                                         CAS011
     C     L_CLPTYP      ANDNE     72                                                         CAS011
      *                                                                                       CAS011
     C                   MOVE      *BLANK        WADJP                                        CAS011
     C                   MOVE      *BLANK        WDELR                                        CAS011
      *                                                                                       CAS011
     C     L_CLIFDY      IFNE      0                                                          CAS011
     C                   Z-ADD     L_CLIFDY      WIFDY                                        CAS011
     C                   ELSE                                                                 CAS011
     C                   Z-ADD     0             WIFDY                                        CAS011
     C                   ENDIF                                                                CAS011
      *                                                                                       CAS011
     C     L_CLRDYN      IFNE      0                                                          CAS011
     C                   Z-ADD     L_CLRDYN      WRDYN                                        CAS011
     C                   ELSE                                                                 CAS011
     C                   Z-ADD     0             WRDYN                                        CAS011
     C                   ENDIF                                                                CAS011
      *                                                                                       CAS011
      ** Need to recalculate the EIR of the original loan when                                CAS011
      ** it is sold (or if the Part Sold is deleted).                                         CAS011
      *                                                                                       CAS011
     C     L_CLPTYP      IFEQ      66                                                         CAS011
     C     L_CLPTYP      OREQ      67                                                         CAS011
     C     L_CLPTYP      OREQ      69                                                         CAS011
     C     L_CLPTYP      OREQ      72                                                         CAS011
     C     L_CLCHTP      IFEQ      'I'                                                        CAS011
     C     L_CLCHTP      OREQ      'R'                                                        CAS011
     C                   MOVE      L_CLOLNO      WTRAN                                        CAS011
     C                   Z-ADD     L_CLVDAT      WVALD                                        CAS011
     C                   EXSR      SEIRI1                                                     CAS011
     C                   ENDIF                                                                CAS011
     C                   ENDIF                                                                CAS011
      *                                                                                       CAS011
      ** Need to recalculate the EIR of the loan on amend.                                    CAS011
      *                                                                                       CAS011
     C     L_CLCHTP      IFEQ      'A'                                                        CAS011
      *                                                                                       CAS011
      ** EIR of the amended Loan                                                              CAS011
      *                                                                                       CAS011
     C     New_NIDT      IFNE      Prv_NIDT                                                   CAS011
     C     New_IPFR      ORNE      Prv_IPFR                                                   CAS011
     C     New_IFDY      ORNE      WIFDY                                                      CAS011
     C**********         Z-ADD     Prv_LNRF      WTRAN                                 CAS011 CLE148
     C                   MOVEL     Prv_LNRF      WTRAN                                        CLE148
     C                   SELECT                                                               CAS011
     C     Prv_NIDT      WHENEQ    0                                                          CAS011
     C     New_NIDT      ANDNE     0                                                          CAS011
     C     New_NIDT      ORNE      0                                                          CAS011
     C     New_NIDT      ANDLT     Prv_NIDT                                                   CAS011
     C     New_NIDT      OREQ      Prv_NIDT                                                   CAS011
     C                   Z-ADD     New_NIDT      WVALD                                        CAS011
     C     New_NIDT      WHENEQ    0                                                          CAS011
     C     Prv_NIDT      ANDNE     0                                                          CAS011
     C     Prv_NIDT      ORNE      0                                                          CAS011
     C     Prv_NIDT      ANDLT     New_NIDT                                                   CAS011
     C     New_NIDT      OREQ      Prv_NIDT                                                   CAS011
     C                   Z-ADD     Prv_NIDT      WVALD                                        CAS011
     C                   ENDSL                                                                CAS011
     C                   EXSR      SEIRI1                                                     CAS011
     C                   ENDIF                                                                CAS011
      *                                                                                       CAS011
     C     New_NRPD      IFNE      Prv_NRPD                                                   CAS011
     C     New_RFRQ      ORNE      Prv_RFRQ                                                   CAS011
     C     New_RDYN      ORNE      WRDYN                                                      CAS011
     C     New_RAMT      ORNE      Prv_RAMT                                                   CAS011
     C     New_FCRA      ORNE      Prv_FCRA                                                   CAS011
     C**********         Z-ADD     Prv_LNRF      WTRAN                                 CAS011 CLE148
     C                   MOVEL     Prv_LNRF      WTRAN                                        CLE148
     C                   SELECT                                                               CAS011
     C     Prv_NRPD      WHENEQ    0                                                          CAS011
     C     New_NRPD      ANDNE     0                                                          CAS011
     C     New_NRPD      ORNE      0                                                          CAS011
     C     New_NRPD      ANDLT     Prv_NRPD                                                   CAS011
     C     New_NRPD      OREQ      Prv_NRPD                                                   CAS011
     C                   Z-ADD     New_NRPD      WVALD                                        CAS011
     C     New_NRPD      WHENEQ    0                                                          CAS011
     C     Prv_NRPD      ANDNE     0                                                          CAS011
     C     Prv_NRPD      ORNE      0                                                          CAS011
     C     Prv_NRPD      ANDLT     New_NRPD                                                   CAS011
     C     New_NRPD      OREQ      Prv_NRPD                                                   CAS011
     C                   Z-ADD     Prv_NRPD      WVALD                                        CAS011
     C                   ENDSL                                                                CAS011
     C                   EXSR      SEIRI1                                                     CAS011
     C                   ENDIF                                                                CAS011
      *                                                                                       CAS011
     C     New_MDAT      IFNE      Prv_MDAT                                                   CAS011
     C**********         Z-ADD     Prv_LNRF      WTRAN                                 CAS011 CLE148
     C                   MOVEL     Prv_LNRF      WTRAN                                        CLE148
     C                   SELECT                                                               CAS011
     C     Prv_MDAT      WHENEQ    0                                                          CAS011
     C     New_MDAT      ANDNE     0                                                          CAS011
     C     New_MDAT      ORNE      0                                                          CAS011
     C     New_MDAT      ANDLT     Prv_MDAT                                                   CAS011
     C     New_MDAT      OREQ      Prv_MDAT                                                   CAS011
     C                   Z-ADD     New_MDAT      WVALD                                        CAS011
     C     New_MDAT      WHENEQ    0                                                          CAS011
     C     Prv_MDAT      ANDNE     0                                                          CAS011
     C     Prv_MDAT      ORNE      0                                                          CAS011
     C     Prv_MDAT      ANDLT     New_MDAT                                                   CAS011
     C     New_MDAT      OREQ      Prv_MDAT                                                   CAS011
     C                   Z-ADD     Prv_MDAT      WVALD                                        CAS011
     C                   ENDSL                                                                CAS011
     C                   MOVE      'Y'           WADJP                                        CAS011
     C                   EXSR      SEIRI1                                                     CAS011
     C                   IF        CAS016 = 'Y'                                               CAS019
     C                   EXSR      SFEEAM                                                     CAS019
     C                   ENDIF                                                                CAS019
     C                   ENDIF                                                                CAS011
      *                                                                                       CAS011
      ** EIR of the original Loan                                                             CAS011
      *                                                                                       CAS011
     C     New_PTYP      IFEQ      66                                                         CAS011
     C     New_PTYP      OREQ      67                                                         CAS011
     C     New_PTYP      OREQ      69                                                         CAS011
     C     New_PTYP      OREQ      72                                                         CAS011
      *                                                                                       CAS011
     C     New_NIDT      IFNE      Prv_NIDT                                                   CAS011
     C     New_IPFR      ORNE      Prv_IPFR                                                   CAS011
     C     New_IFDY      ORNE      WIFDY                                                      CAS011
     C                   MOVE      New_OLNO      WTRAN                                        CAS011
     C                   SELECT                                                               CAS011
     C     Prv_NIDT      WHENEQ    0                                                          CAS011
     C     New_NIDT      ANDNE     0                                                          CAS011
     C     New_NIDT      ORNE      0                                                          CAS011
     C     New_NIDT      ANDLT     Prv_NIDT                                                   CAS011
     C     New_NIDT      OREQ      Prv_NIDT                                                   CAS011
     C                   Z-ADD     New_NIDT      WVALD                                        CAS011
     C     New_NIDT      WHENEQ    0                                                          CAS011
     C     Prv_NIDT      ANDNE     0                                                          CAS011
     C     Prv_NIDT      ORNE      0                                                          CAS011
     C     Prv_NIDT      ANDLT     New_NIDT                                                   CAS011
     C     New_NIDT      OREQ      Prv_NIDT                                                   CAS011
     C                   Z-ADD     Prv_NIDT      WVALD                                        CAS011
     C                   ENDSL                                                                CAS011
     C                   EXSR      SEIRI1                                                     CAS011
     C                   ENDIF                                                                CAS011
      *                                                                                       CAS011
     C     New_NRPD      IFNE      Prv_NRPD                                                   CAS011
     C     New_RFRQ      ORNE      Prv_RFRQ                                                   CAS011
     C     New_RDYN      ORNE      WRDYN                                                      CAS011
     C     New_RAMT      ORNE      Prv_RAMT                                                   CAS011
     C     New_FCRA      ORNE      Prv_FCRA                                                   CAS011
     C                   MOVE      New_OLNO      WTRAN                                        CAS011
     C                   SELECT                                                               CAS011
     C     Prv_NRPD      WHENEQ    0                                                          CAS011
     C     New_NRPD      ANDNE     0                                                          CAS011
     C     New_NRPD      ORNE      0                                                          CAS011
     C     New_NRPD      ANDLT     Prv_NRPD                                                   CAS011
     C     New_NRPD      OREQ      Prv_NRPD                                                   CAS011
     C                   Z-ADD     New_NRPD      WVALD                                        CAS011
     C     New_NRPD      WHENEQ    0                                                          CAS011
     C     Prv_NRPD      ANDNE     0                                                          CAS011
     C     Prv_NRPD      ORNE      0                                                          CAS011
     C     Prv_NRPD      ANDLT     New_NRPD                                                   CAS011
     C     New_NRPD      OREQ      Prv_NRPD                                                   CAS011
     C                   Z-ADD     Prv_NRPD      WVALD                                        CAS011
     C                   ENDSL                                                                CAS011
     C                   EXSR      SEIRI1                                                     CAS011
     C                   ENDIF                                                                CAS011
      *                                                                                       CAS011
     C     New_MDAT      IFNE      Prv_MDAT                                                   CAS011
     C                   MOVE      New_OLNO      WTRAN                                        CAS011
     C                   SELECT                                                               CAS011
     C     Prv_MDAT      WHENEQ    0                                                          CAS011
     C     New_MDAT      ANDNE     0                                                          CAS011
     C     New_MDAT      ORNE      0                                                          CAS011
     C     New_MDAT      ANDLT     Prv_MDAT                                                   CAS011
     C     New_MDAT      OREQ      Prv_MDAT                                                   CAS011
     C                   Z-ADD     New_MDAT      WVALD                                        CAS011
     C     New_MDAT      WHENEQ    0                                                          CAS011
     C     Prv_MDAT      ANDNE     0                                                          CAS011
     C     Prv_MDAT      ORNE      0                                                          CAS011
     C     Prv_MDAT      ANDLT     New_MDAT                                                   CAS011
     C     New_MDAT      OREQ      Prv_MDAT                                                   CAS011
     C                   Z-ADD     Prv_MDAT      WVALD                                        CAS011
     C                   ENDSL                                                                CAS011
     C                   MOVE      'Y'           WADJP                                        CAS011
     C                   EXSR      SEIRI1                                                     CAS011
     C                   IF        CAS016 = 'Y'                                               CAS019
     C                   EXSR      SFEEAM                                                     CAS019
     C                   ENDIF                                                                CAS019
     C                   ENDIF                                                                CAS011
      *                                                                                       CAS011
     C                   ENDIF                                                                CAS011
      *                                                                                       CAS011
     C                   ENDIF                                                                CAS011
      *                                                                                       CAS011
     C                   ENDIF                                                                CAS011
     C                   ENDIF                                                                CAS011
      *                                                                                       CAS011
     C                   ENDSR                                                                CAS011
      *****************************************************************                       241196
      /EJECT                                                                                  241196
      *****************************************************************                       241196
      *                                                               *                       241196
      *  PSOLDUPD - Update related parts sold                         *                       241196
      *                                                               *                       241196
      *****************************************************************                       241196
      *                                                                                       241196
     C     PSOLDUPD      BEGSR                                                                241196
      *                                                                                       241196
     C*****              MOVE      LNRF          RLNRF             6 0                 241196 CPK025
     C                   MOVE      LNRF          RLNRF             6                          CPK025
     C**********         MOVE      LIND          RLIND             3 0                 241196 CER020
     C**********         MOVE      LOIC          RLOIC             3 0               CER020 MD045480
     C                   MOVE      LOIC          RLOIC             3                        MD045480
     C                   MOVE      CRSK          RCRSK             2                          241196
     C                   MOVE      PRFC          RPRFC             4                          241196
     C                   MOVE      ORBR          RORBR             3                          241196
     C                   MOVE      PTFR          RPTFR             4                          241196
      *                                                                                       241196
     C     RLNRF         SETLL     PSOLD                                                      241196
     C     RLNRF         READE     PSOLD                                  90                  241196
      *                                                                                       241196
     C     *IN90         DOWEQ     *OFF                                                       241196
     C**********         MOVE      RLIND         PSLIND                                241196 CER020
     C                   MOVE      RLOIC         PSLOIC                                       CER020
     C                   MOVE      RCRSK         PSCRSK                                       241196
     C                   MOVE      RPRFC         PSPRFC                                       241196
     C                   MOVE      RORBR         PSORBR                                       241196
     C                   MOVE      RPTFR         PSPTFR                                       241196
     C                   UPDATE    PSOLDF2                                                    241196
     C     RLNRF         READE     PSOLD                                  90                  241196
     C                   ENDDO                                                                241196
      *                                                                                       241196
     C                   ENDSR                                                                241196
      *****************************************************************                       245227
      /EJECT                                                                                  245227
      *****************************************************************                       245227
      *                                                               *                       245227
      *  SRGETBAL - Get loan current principal amount.                *                       245227
      *                                                               *                       245227
      *****************************************************************                       245227
      *                                                                                       245227
     C     SRGETBAL      BEGSR                                                                245227
      *                                                                                       245227
     C     KCLLNRF       SETLL     LELOAML3                                                   245227
     C     KCLLNRF       READE     LELOAML3                                                   245227
     C                   DOW       NOT %EOF()                                                 245227
     C                   IF        VDATA <= BJRDNB AND                                        245227
     C                             (AMTPA = 'RE'   OR                                         245227
     C                              AMTPA = 'MR')                                             245227
     C                   EVAL      WRKBAL = WRKBAL - PRAMA                                    245227
     C                   ENDIF                                                                245227
     C     KCLLNRF       READE     LELOAML3                                                   245227
     C                   ENDDO                                                                245227
      *                                                                                       245227
     C                   ENDSR                                                                245227
      *                                                                                       245227
      *****************************************************************                       CAS019
      /EJECT                                                                                  CAS019
      *****************************************************************                       CAS019
      *                                                               *                       CAS019
      *  SFEEAM -   Set Amortisation end period of the fees           *                       CAS019
      *                                                               *                       CAS019
      *****************************************************************                       CAS019
      *                                                                                       CAS019
     C     SFEEAM        BEGSR                                                                CAS019
                                                                                              CAS019
     C                   EVAL      LENGTH = %SIZE(OVRDBF)                                   BUG21821
     C                   CALL      'QCMDEXC'                                                BUG21821
     C                   PARM      OVRDBF        QCMD             70                        BUG21821
     C                   PARM                    LENGTH           15 5                      BUG21821
     C                   OPEN      LEFEEDLH                                                 BUG21821
                                                                                            BUG21821
     C     WTRAN         CHAIN     LEFEEDF2                           20                      CAS019
     C                   DOW       *IN20 = *OFF                                               CAS019
     C                   IF        FEAMRI = 'Y' AND                                           CAS019
     C                             FERECI <> 'R' AND                                          262581
     C**********                   FESTPD > BJRDNB AND                                 CAS019 262581
     C**********                   FEENPD <> L_CLNMDT AND                              CAS019 262581
     C**********                   L_CLNMDT <> 0                                       CAS019 262581
     C                             FEENPD > New_MDAT AND                                      262581
     C                             New_MDAT <> 0 OR                                           262581
     C                             FEAMRI = 'N' AND                                           262581
     C                             FERECI <> 'R' AND                                          262581
     C                             FEENPD <> New_MDAT AND                                     262581
     C                             New_MDAT <> 0                                              262581
     C**********         MOVE      L_CLNMDT      FEENPD                                CAS019 262581
     C                   MOVE      New_MDAT      FEENPD                                       262581
     C                   MOVE      'A'           FELCHT                                       262581
     C                   Z-ADD     BJRDNB        FELCHD                                       262581
     C                   UPDATE    LEFEEDF2                                                   CAS019
     C                   ENDIF                                                                CAS019
     C     WTRAN         READE     LEFEEDF2                               20                  CAS019
     C                   ENDDO                                                                CAS019
                                                                                              CAS019
     C*****WTRAN         CHAIN     LEFHSTF                            20               CAS019 262581
     C**********         DOW       *IN20 = *OFF                                        CAS019 262581
     C**********         IF        HIAMRI = 'Y' AND                                    CAS019 262581
     C**********                   HISTPD > BJRDNB AND                                 CAS019 262581
     C**********                   HIENPD <> L_CLNMDT AND                              CAS019 262581
     C**********                   L_CLNMDT <> 0                                       CAS019 262581
     C**********         MOVE      L_CLNMDT      FEENPD                                CAS019 262581
     C**********         UPDATE    LEFHSTF                                             CAS019 262581
     C**********         ENDIF                                                         CAS019 262581
     C*****WTRAN         READE     LEFHSTF                                20           CAS019 262581
     C**********         ENDDO                                                         CAS019 262581
                                                                                              CAS019
     C                   CLOSE     LEFEEDLH                                                 BUG21821
     C                   ENDSR                                                                CAS019
                                                                                              CAS019
      ****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ***  Program Parameters
      *
     C     *ENTRY        PLIST
      *
      ***  Return Code
     C                   PARM                    @@RTCD            7
      *
      ***  Externally described DS for valid loan Detail CL
     C                   PARM                    LEVCliL
      *
      ***  Externally described DS for valid loan Detail CK
     C                   PARM                    LEVCliK
     C                   PARM                    TranInExt                                    CER049
      *
      ***  Loan number ranges file
     C                   PARM                    @PRANG            2
      *
      ***  PC Processing
     C                   PARM                    PPTIN             1
     C                   PARM                    PGNTF             1
     C                   PARM                    PTDT1            35
     C                   PARM                    PTDT2            35
     C                   PARM                    PTDT3            35
     C                   PARM                    PTREF            15
     C                   PARM                    W#SEQ             4 0
                                                                                              CDE005
      ** Reservation ID (input from VU only)                                                  CDE005
     C                   PARM                    ReservId         10                          CDE005
                                                                                              CDE005
      ** Calling module                                                                       CDE005
     C                   PARM                    CallModCode       3                          CDE005
                                                                                             BUG3721
      ** Switchable features                                                                 BUG3721
     C                   PARM                    CLE028            1                         BUG3721
     C                   PARM                    WAUTOA            1                          245227
     C                   PARM                    WAUTOY            1                          245227
     C                   PARM                    PFPTF             1                          245273
      *                                                                                     AR804863
      * Action Code (Reject transaction)                                                    AR804863
      *                                                                                     AR804863
     C                   PARM                    @ACTRV            1                        AR804863
     C                   PARM                    @DEPI             1                        MD030621
     C/COPY WNCPYSRC,LECLIPPC01
      *
      ***  Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Database Error
      *
     C                   IF        @RTCD <> *BLANK
     C     *LOCK         IN        LDA
     C                   MOVE      '*FIRST'      DBKEY                          *************
     C                   MOVEL     'SDBANKPD'    DBFILE                         * DBERR 024 *
     C                   Z-ADD     81            DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ***  Key list for Loan reference
      *
     C     KCLLNRF       KLIST
     C                   KFLD                    L_CLLNRF
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
      ***  Key list for LOAMS
      *
     C     WKLAM         KLIST
     C**********         KFLD                    WLLOAN            6 0                        CLE148
     C                   KFLD                    WLLOAN            6                          CLE148
     C                   KFLD                    WLVDAT            5 0
     C                   KFLD                    WLLASN            3 0
      *
     C     WKFAM2        KLIST
     C                   KFLD                    CNUMF
     C                   KFLD                    FACT
     C                   KFLD                    FCNO
      *
      ***  Key list for LEREF
      *
     C     WKREF         KLIST
     C**********         KFLD                    WCNUM             6 0                        CSD027
     C                   KFLD                    WCNUM             6                          CSD027
     C                   KFLD                    WFACT             3 0
     C                   KFLD                    WFCNO             2 0
     C**********         KFLD                    WLNRF             6 0                        CLE148
     C                   KFLD                    WLNRF             6                          CLE148
      *
      ***  Key list for CLOAN
      *
     C     WKLON         KLIST
     C**********         KFLD                    WALON             6 0                        CLE148
     C                   KFLD                    WALON             6                          CLE148
     C                   KFLD                    WEPAR             1
      *
      ***  Key list for Fees file
      *
     C     WKFEE         KLIST
     C**********         KFLD                    WFCNUM            6 0                        CSD027
     C                   KFLD                    WFCNUM            6                          CSD027
     C                   KFLD                    WFFACL            5 0
     C**********         KFLD                    WFLOAN            6 0                        CLE148
     C                   KFLD                    WFLOAN            6                          CLE148
     C     WKFEEX        KLIST                                                              MD023203
     C                   KFLD                    WFCNUMX           6                        MD023203
     C                   KFLD                    WFFACLX           5 0                      MD023203
     C                   KFLD                    WFLOANX           6                        MD023203
     C                   KFLD                    WFSEQNX           2 0                      MD023203
      *                                                                                      BUG3760
     C     KCwFld        KLIST                                                               BUG3760
     C                   KFLD                    WFuncType                                   BUG3760
     C                   KFLD                    WIdntifier                                  BUG3760
     C                   KFLD                    WBranch                                     BUG3760
                                                                                              CRE020
      ** Midas RE Settled Transaction Index File Key List                                     CRE020
                                                                                              CRE020
     C     KADVC         KLIST                                                                CRE020
     C                   KFLD                    KRefNo                                       CRE020
     C                   KFLD                    KPrgMn                                       CRE020
      *
      ** Retail Account Key List                                                              CLE134
                                                                                              CLE134
     C     KACCNTL1      KLIST                                                                CLE134
     C                   KFLD                    KacACNO                                      CLE134
                                                                                           AR317473A
     C     KACCNT        KLIST                                                             AR317473A
     C                   KFLD                    YTKPACL                                   AR317473A
     C                   KFLD                    YTKPACY                                   AR317473A
     C                   KFLD                    YTKPAAC                                   AR317473A
     C                   KFLD                    YTKPASE                                   AR317473A
     C                   KFLD                    YTKPABR                                   AR317473A
                                                                                              CLE134
      ** Repayment Priority Key List                                                          CLE134
                                                                                              CLE134
     C*****KLEACCNLA     KLIST                                                         CLE134 CLE164
     C**********         KFLD                    KRPLNRF                               CLE134 CLE164
                                                                                              CLE134
     C     KAPNAPD       KLIST                                                                CLE134
     C                   KFLD                    KGLNARI                                      CLE134
                                                                                              CLE134
     C*****KACMTLX       KLIST                                                         CLE134 CLE164
     C**********         KFLD                    KspXRFI                               CLE134 CLE164
     C**********         KFLD                    KspXRFN                               CLE134 CLE164
                                                                                              CLE134
      ** PLIST for Access Program AONOSTR0                                                    CLE134
                                                                                              CLE134
     C     PLIST1        PLIST                                                                CLE134
     C                   PARM      '*MSG   '     @RTCD             7                          CLE134
     C                   PARM      '*KEY   '     @OPTN             7                          CLE134
     C                   PARM                    KCNUM             6                          CLE134
     C                   PARM                    KCCY              3                          CLE134
     C                   PARM                    KEYC1            10                          CLE134
     C                   PARM                    KEYD              2                          CLE134
     C                   PARM                    KNONB             2                          CLE134
     C                   PARM                    KEYF              3                          CLE134
     C                   PARM                    KEYG             10                          CLE134
     C                   PARM                    KEYH              1                          CLE134
     C     SDNOST        PARM      SDNOST        DSFDY                                        CLE134
                                                                                              CLE134
      ** Midas LE past due & original fees link key list                                   AR1021983
      *                                                                                    AR1021983
     C     KEY_UFLB      KLIST                                                             AR1021983
     C                   KFLD                    KYOFLN            6                       AR1021983
     C                   KFLD                    KYOFCU            6                       AR1021983
     C                   KFLD                    KYOFAC            5 0                     AR1021983
     C                   KFLD                    KYOFSQ            2 0                     AR1021983
     C                   KFLD                    KYBRCA            3                       AR1021983
      *                                                                                    AR1021983
      ** Midas LE lending fees master detail inputs key list                               AR1021983
      *                                                                                    AR1021983
     C     KEY_FEED      KLIST                                                             AR1021983
     C                   KFLD                    KYOFCU                                    AR1021983
     C                   KFLD                    KYOFAC                                    AR1021983
     C                   KFLD                    KYOFLN                                    AR1021983
     C                   KFLD                    KYOFSQ                                    AR1021983
      *
      ** Loan Settlement Update Trace Key List                                              MD020242
      *                                                                                     MD020242
     C     KPSETD        KLIST                                                              MD020242
     C                   KFLD                    KPLnrf                                     MD020242
     C                   KFLD                    KPDate                                     MD020242
      **********                                                                   MD024342 MD025467
     C*****KAPILST       KLIST                                                     MD024342 MD025467
     C**********         KFLD                    WAPIC             4               MD024342 MD025467
     C**********         KFLD                    WFILN            10               MD024342 MD025467
      *                                                                                     MD020242
      ***  Retrieve trading data
      *
     C                   CALLB     'AOTRADR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDTRAD        PARM      SDTRAD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '*FIRST'      DBKEY                          *************
     C                   MOVEL     'SDTRADPD'    DBFILE                         * DBERR 025 *
     C                   Z-ADD     82            DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ***  Retrieve lending ICD
      *
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDCLND        PARM      SDCLND        DSFDY                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '*FIRST'      DBKEY                          *************
     C                   MOVEL     'SDCLNDPD'    DBFILE                         * DBERR 026 *
     C                   Z-ADD     83            DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
      *
      ***  Retrieve module details
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      '*FIRST'      DBKEY                          *************
     C                   MOVEL     'SDMMODPD'    DBFILE                         * DBERR 027 *
     C                   Z-ADD     84            DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ENDIF
     C/COPY WNCPYSRC,LEH01181
      *
     C     *DTAARA       DEFINE                  SDSTAT
      *
     C     *DTAARA       DEFINE                  SC24X7
      *
      ***  Set up an array of branch internal customer
      ***  If branch file is empty, report db error
      *
     C     *LOVAL        SETLL     SDBRCHL5
     C                   READ      SDBRCHL5                               99
     C     *IN99         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   MOVE      '*FIRST'      DBKEY                          *************
     C                   MOVEL     'SDBRCNL5'    DBFILE                         * DBERR 028 *
     C                   Z-ADD     85            DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      SRERR
     C                   ELSE
     C     *IN99         DOUEQ     '1'
     C                   ADD       1             S                 3 0
     C                   MOVE      A8BICN        WBIC(S)
     C                   READ      SDBRCHL5                               99
     C                   ENDDO
     C                   ENDIF
      *
      ***  Determine if CAS001 is installed
      *
     C                   MOVEL     'N'           CAS001            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAS001'      @SARD
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CAS001
     C                   END
      *                                                                                       225959
      ***  Determine if CAS005 is installed                                                   225959
      *                                                                                       225959
     C                   MOVEL     'N'           CAS005            1                          225959
     C                   CALLB     'AOSARDR0'                                                 225959
     C                   PARM      *BLANKS       @RTCD                                        225959
     C                   PARM      '*VERIFY'     @OPTN                                        225959
     C                   PARM      'CAS005'      @SARD                                        225959
     C     @RTCD         IFEQ      *BLANKS                                                    225959
     C                   MOVE      'Y'           CAS005                                       225959
     C                   END                                                                  225959
      *
      ***  Determine if Customer Lending Enhancements - Others
      ***  feature is installed
      *
     C                   MOVE      'N'           CLE002            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD             6
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE002
     C                   ENDIF

      ** Determine if CDE005 is switched on                                                   CDE005
      ** (include reservation ID as part of data export)                                      CDE005
     C                   MOVE      'N'           CDE005            1                          CDE005
     C                   CALLB     'AOSARDR0'                                                 CDE005
     C                   PARM      *BLANKS       @RTCD                                        CDE005
     C                   PARM      '*VERIFY'     @OPTN                                        CDE005
     C                   PARM      'CDE005'      @SARD                                        CDE005
      *                                                                                       CDE005
     C     @RTCD         IFEQ      *BLANKS                                                    CDE005
     C                   MOVE      'Y'           CDE005                                       CDE005
     C                   ENDIF                                                                CDE005
      *
     C                   MOVE      'N'           CLE005            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE005
     C                   ENDIF
      *
     C                   MOVE      'N'           CLE009            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE009'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE009
     C                   Z-ADD     1             X                 3 0
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C                   PARM                    @CYCD
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   MOVE      A6CYCD        CYA(X)
     C                   MOVE      A6TXND        TND(X)
     C     A6CYCD        IFEQ      BJLCCY
     C                   Z-ADD     A6TXND        Lccy_TXND         2 0
     C                   ENDIF
      *
     C     @RTCD         DOWNE     '*EOF    '
     C                   ADD       1             X
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*NEXT  '     @OPTN
     C                   PARM                    @CYCD
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      '*EOF    '
     C                   MOVE      A6CYCD        CYA(X)
     C                   MOVE      A6TXND        TND(X)
     C     A6CYCD        IFEQ      BJLCCY
     C                   Z-ADD     A6TXND        Lccy_TXND         2 0
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   MOVE      'N'           CLE011            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE011'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE011
     C                   ENDIF
      *
     C                   MOVE      'N'           CLE014            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE014
     C                   ENDIF
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
      *
     C                   MOVE      'N'           CEU004            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU004'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU004
     C                   ENDIF
      *
     C                   MOVE      'N'           CDE002            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE002'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDE002
     C                   ENDIF
      *
     C                   MOVE      'N'           CSC011            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC011'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CSC011
     C                   IN        SC24X7                                                    BUG3760
     C                   ENDIF
      *
     C                   MOVE      'N'           CDE001            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE001'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDE001
     C                   ENDIF
      *                                                                                       CLE023
     C                   MOVE      'N'           CLE023            1                          CLE023
     C                   CALLB     'AOSARDR0'                                                 CLE023
     C                   PARM      *BLANKS       @RTCD                                        CLE023
     C                   PARM      '*VERIFY'     @OPTN                                        CLE023
     C                   PARM      'CLE023'      @SARD                                        CLE023
      *                                                                                       CLE023
     C     @RTCD         IFEQ      *BLANKS                                                    CLE023
     C                   MOVE      'Y'           CLE023                                       CLE023
     C                   ENDIF                                                                CLE023
                                                                                              CRE020
      ** Check if CRE020 is enabled.                                                          CRE020
                                                                                              CRE020
     C                   CALLB     'AOSARDR0'                                                 CRE020
     C                   PARM      *BLANKS       PRtCd                                        CRE020
     C                   PARM      '*VERIFY'     POptn                                        CRE020
     C                   PARM      'CRE020'      PSARD                                        CRE020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE020
                                                                                              CRE020
     C                   EVAL      CRE020 = 'N'                                               CRE020
                                                                                              CRE020
     C                   IF        PRtCd = *BLANKS                                            CRE020
     C                   EVAL      CRE020 = 'Y'                                               CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        PRtCd <> '*NRF'                                            CRE020
     C     *LOCK         IN        LDA                                                        CRE020
     C                   EVAL      DBFile = 'SCSARDPD'                                        CRE020
     C                   EVAL      DBase = 101                                                CRE020
     C                   EVAL      DBKey = 'CRE020'                                           CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      SRErr                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Check if a System Value exists for this maintenance.                                 CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
                                                                                              CRE020
     C                   CALLB     'AOSVALR0'                                                 CRE020
     C                   PARM      *BLANKS       PRtCd                                        CRE020
     C                   PARM                    PSysVal01                                    CRE020
     C                   PARM                    PCurSet01                                    CRE020
     C                   PARM                    PSysVal02                                    CRE020
     C                   PARM                    PCurSet02                                    CRE020
     C                   PARM                    PSysVal03                                    CRE020
     C                   PARM                    PCurSet03                                    CRE020
     C                   PARM                    PSysVal04                                    CRE020
     C                   PARM                    PCurSet04                                    CRE020
     C                   PARM                    PSysVal05                                    CRE020
     C                   PARM                    PCurSet05                                    CRE020
     C                   PARM                    PSysVal06                                    CRE020
     C                   PARM                    PCurSet06                                    CRE020
     C                   PARM                    PSysVal07                                    CRE020
     C                   PARM                    PCurSet07                                    CRE020
     C                   PARM                    PSysVal08                                    CRE020
     C                   PARM                    PCurSet08                                    CRE020
     C                   PARM                    PSysVal09                                    CRE020
     C                   PARM                    PCurSet09                                    CRE020
     C                   PARM                    PSysVal10                                    CRE020
     C                   PARM                    PCurSet10                                    CRE020
                                                                                              CRE020
     C                   EVAL      WSysVal01 = 'N'                                            CRE020
                                                                                              CRE020
     C                   IF        PRtCd = *BLANKS                                            CRE020
     C                   MOVEL     PCurSet01     WSysVal01                                    CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        PRtCd <> '*NRF'                                            CRE020
     C     *LOCK         IN        LDA                                                        CRE020
     C                   EVAL      DBFile = 'SDSVALPD'                                        CRE020
     C                   EVAL      DBase = 102                                                CRE020
     C                   EVAL      DBKey = PSysVal01                                          CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      SRErr                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Determine if CLE025 is switched on                                                   CLE025
                                                                                              CLE025
     C**********         MOVE      'N'           CLE025                              CLE025 BUG18527
     C                   MOVE      'N'           CLE024                                     BUG18527
     C                   CALLB     'AOSARDR0'                                                 CLE025
     C                   PARM      *BLANKS       PRTCD                                        CLE025
     C                   PARM      '*VERIFY'     POPTN                                        CLE025
     C**********         PARM      'CLE025'      PSARD                               CLE025 BUG18527
     C                   PARM      'CLE024'      PSARD                                      BUG18527
                                                                                              CLE025
     C                   IF        PRTCD <> *BLANKS and                                       CLE025
     C                             PRTCD <> '*NRF   '                                         CLE025
     C     *LOCK         IN        LDA                                                        CLE025
     C                   MOVEL     PSARD         DBKEY                                        CLE025
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CLE025
     C                   Z-ADD     94            DBASE                                        CLE025
     C                   OUT       LDA                                                        CLE025
     C                   EXSR      SRERR                                                      CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
     C                   IF        PRTCD = *BLANKS                                            CLE025
     C**********         MOVE      'Y'           CLE025                              CLE025 BUG18527
     C                   MOVE      'Y'           CLE024                                     BUG18527
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
      ** Access SAR details to see if CSD015 is switched on.                                 BUG3760
      *                                                                                      BUG3760
     C                   IN        SDSTAT                                                    BUG3760
      *                                                                                      BUG3760
     C                   CALL      'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*VERIFY'     POption                                     BUG3760
     C                   PARM      'CSD015'      PSARD                                       BUG3760
     C     SCSARD        PARM      *BLANKS       DSFDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        PRetCode = *BLANKS                                        BUG3760
                                                                                             BUG3760
     C                   EVAL      CSD015 = 'Y'                                              BUG3760
     C                   ELSE                                                                BUG3760
                                                                                             BUG3760
     C                   IF        PRetCode <> '*NRF'                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'CSD015'                                          BUG3760
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBase = 903                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        CSD015 = 'Y'                                              BUG3760
                                                                                             BUG3760
      ** Check if transactions are being monitored by Compliance Watch.                      BUG3760
                                                                                             BUG3760
     C                   CALL      'AOWLCCR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*KEY   '     POption                                     BUG3760
     C                   PARM      'LENDING '    PFunc                                       BUG3760
     C     SDWLCC        PARM      SDWLCC        DSFDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        PRetCode <> *BLANKS AND                                   BUG3760
     C                             PRetCode <> '*NRF'                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'LENDING'                                         BUG3760
     C                   EVAL      DBFile = 'SDWLCCPD'                                       BUG3760
     C                   EVAL      DBase = 904                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   CALL      'AOCWCDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*FIRST '     POption                                     BUG3760
     C     SDCWCD        PARM      SDCWCD        DSSDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        PRetCode <> *BLANKS                                       BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = POption                                           BUG3760
     C                   EVAL      DBFile = 'SDCWCDPD'                                       BUG3760
     C                   EVAL      DBase = 905                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Access SAR details to see if CCF001 is switched on.                                 BUG3760
                                                                                             BUG3760
     C                   CALL      'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*VERIFY'     POption                                     BUG3760
     C                   PARM      'CCF001'      PSARD                                       BUG3760
     C     SCSARD        PARM      *BLANKS       DSFDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        PRetCode = *BLANKS                                        BUG3760
                                                                                             BUG3760
     C                   EVAL      CCF001 = 'Y'                                              BUG3760
     C                   ELSE                                                                BUG3760
                                                                                             BUG3760
     C                   IF        PRetCode <> '*NRF'                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'CCF001'                                          BUG3760
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBase = 907                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                              CLE031
      ** Access SAR details to see if CLE031 is switched on.                                  CLE031
                                                                                              CLE031
     C                   EVAL      CLE031 = 'N'                                               CLE031
     C                   CALL      'AOSARDR0'                                                 CLE031
     C                   PARM      *Blanks       PRetCode                                     CLE031
     C                   PARM      '*VERIFY'     POption                                      CLE031
     C                   PARM      'CLE031'      PSARD                                        CLE031
     C     SCSARD        PARM      *Blanks       DSFDY                                        CLE031
      *                                                                                       CLE031
     C                   IF        PRetCode = *BLANKS                                         CLE031
      *                                                                                       CLE031
     C                   EVAL      CLE031 = 'Y'                                               CLE031
     C                   ELSE                                                                 CLE031
      *                                                                                       CLE031
     C                   IF        PRetCode <> '*NRF'                                         CLE031
     C     *LOCK         IN        LDA                                                        CLE031
     C                   EVAL      DBKey = 'CLE031'                                           CLE031
     C                   EVAL      DBFile = 'SCSARDPD'                                        CLE031
     C                   EVAL      DBase = 910                                                CLE031
     C                   OUT       LDA                                                        CLE031
     C                   EXSR      *PSSR                                                      CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE106
      ** Access SAR details to see if CLE106 is switched on.                                  CLE106
      *                                                                                       CLE106
     C                   EVAL      CLE106 = 'N'                                               CLE106
     C                   CALL      'AOSARDR0'                                                 CLE106
     C                   PARM      *Blanks       PRetCode                                     CLE106
     C                   PARM      '*VERIFY'     POption                                      CLE106
     C                   PARM      'CLE106'      PSARD                                        CLE106
     C     SCSARD        PARM      *Blanks       DSFDY                                        CLE106
      *                                                                                       CLE106
     C                   IF        PRetCode = *BLANKS                                         CLE106
      *                                                                                       CLE106
     C                   EVAL      CLE106 = 'Y'                                               CLE106
     C                   ELSE                                                                 CLE106
      *                                                                                       CLE106
     C                   IF        PRetCode <> '*NRF'                                         CLE106
     C     *LOCK         IN        LDA                                                        CLE106
     C                   EVAL      DBKey = 'CLE106'                                           CLE106
     C                   EVAL      DBFile = 'SCSARDPD'                                        CLE106
     C                   EVAL      DBase = 909                                                CLE106
     C                   OUT       LDA                                                        CLE106
     C                   EXSR      *PSSR                                                      CLE106
     C                   ENDIF                                                                CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE134
      ** Access SAR details to see if CLE134 is switched on.                                  CLE134
                                                                                              CLE134
     C                   EVAL      CLE134 = 'N'                                               CLE134
     C                   CALL      'AOSARDR0'                                                 CLE134
     C                   PARM      *Blanks       PRetCode                                     CLE134
     C                   PARM      '*VERIFY'     POption                                      CLE134
     C                   PARM      'CLE134'      PSARD                                        CLE134
     C     SCSARD        PARM      *Blanks       DSFDY                                        CLE134
                                                                                              CLE134
     C                   IF        PRetCode = *BLANKS                                         CLE134
                                                                                              CLE134
     C                   EVAL      CLE134 = 'Y'                                               CLE134
     C                   ELSE                                                                 CLE134
                                                                                              CLE134
     C                   IF        PRetCode <> '*NRF'                                         CLE134
     C     *LOCK         IN        LDA                                                        CLE134
     C                   EVAL      DBKey = 'CLE134'                                           CLE134
     C                   EVAL      DBFile = 'SCSARDPD'                                        CLE134
     C                   EVAL      DBase = 912                                                CLE134
     C                   OUT       LDA                                                        CLE134
     C                   EXSR      *PSSR                                                      CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
      *                                                                                      BUG9491
      ** Access SAR details to see if CLE036 is switched on.                                 BUG9491
      *                                                                                      BUG9491
     C                   EVAL      CLE036 = 'N'                                              BUG9491
     C                   CALL      'AOSARDR0'                                                BUG9491
     C                   PARM      *Blanks       PRetCode                                    BUG9491
     C                   PARM      '*VERIFY'     POption                                     BUG9491
     C                   PARM      'CLE036'      PSARD                                       BUG9491
     C     SCSARD        PARM      *Blanks       DSFDY                                       BUG9491
      *                                                                                      BUG9491
     C                   IF        PRetCode = *BLANKS                                        BUG9491
      *                                                                                      BUG9491
     C                   EVAL      CLE036 = 'Y'                                              BUG9491
     C                   ELSE                                                                BUG9491
      *                                                                                      BUG9491
     C                   IF        PRetCode <> '*NRF'                                        BUG9491
     C     *LOCK         IN        LDA                                                       BUG9491
     C                   EVAL      DBKey = 'CLE036'                                          BUG9491
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG9491
     C                   EVAL      DBase = 911                                               BUG9491
     C                   OUT       LDA                                                       BUG9491
     C                   EXSR      *PSSR                                                     BUG9491
     C                   ENDIF                                                               BUG9491
     C                   ENDIF                                                               BUG9491

     C                   Eval      @RTCD = *BLANKS
      *
      ***  Determine whether program is running interactively or in batch
      ***   ( 0 = batch   1 = interactive)
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @Return           6
     C                   PARM                    @Type             1
      *
      ** Determine if SAR CAS009 is installed                                                 CAS011
      *                                                                                       CAS011
     C                   CALL      'AOSARDR0'                                                 CAS011
     C                   PARM      *BLANKS       PRetCode                                     CAS011
     C                   PARM      '*VERIFY'     POption                                      CAS011
     C                   PARM      'CAS009'      PSARD                                        CAS011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS011
      *                                                                                       CAS011
     C                   IF        PRetCode <> *BLANKS  and                                   CAS011
     C                             PRetCode <> '*NRF   '                                      CAS011
      *                                                                                       CAS011
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAS011
     C                   EVAL      DBase = 67                                                 CAS011
     C                   EVAL      DBKey = 'CAS009'                                           CAS011
     C                   EXSR      *PSSR                                                      CAS011
     C                   ENDIF                                                                CAS011
      *                                                                                       CAS011
     C                   IF        PRetCode = *BLANKS                                         CAS011
     C                   EVAL      CAS009 = 'Y'                                               CAS011
     C                   ELSE                                                                 CAS011
     C                   EVAL      CAS009 = 'N'                                               CAS011
     C                   ENDIF                                                                CAS011
      *                                                                                       CAS011
      ** Access object for Hedge ICD                                                          CAS011
      *                                                                                       CAS011
     C                   IF        CAS009 = 'Y'                                               CAS011
     C                   CALL      'AOHEDGR0'                                                 CAS011
     C                   PARM      *BLANKS       PRetCode                                     CAS011
     C                   PARM      '*VERIFY'     POption                                      CAS011
     C     SDHEDG        PARM      SDHEDG        DSFDY                                        CAS011
      *                                                                                       CAS011
     C                   IF        PRetCode <> *BLANKS                                        CAS011
     C     *LOCK         IN        LDA                                                        CAS011
     C                   EVAL      DBFile = 'SDHEDGPD'                                        CAS011
     C                   EVAL      DBase = 68                                                 CAS011
     C                   EVAL      DBKey = POption                                            CAS011
     C                   OUT       LDA                                                        CAS011
     C                   EXSR      *PSSR                                                      CAS011
     C                   ENDIF                                                                CAS011
     C                   ENDIF                                                                CAS011
      *                                                                                       CAS011
      *                                                                                       CLE055
      ** Determine if CAR CLE055 is installed>                                                CLE055
      ** Do this is if authorisation is required to be performed.                             CLE055
      *                                                                                       CLE055
     C                   IF        CLE002 = 'Y'                                               CLE055
     C                                                                                        CLE055
     C                   CALL      'AOSARDR0'                                                 CLE055
     C                   PARM      *BLANKS       PRetCode                                     CLE055
     C                   PARM      '*VERIFY'     POption                                      CLE055
     C                   PARM      'CLE055'      PSARD                                        CLE055
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE055
      *                                                                                       CLE055
     C                   IF        PRetCode <> *BLANKS  and                                   CLE055
     C                             PRetCode <> '*NRF   '                                      CLE055
      *                                                                                       CLE055
     C                   EVAL      DBFile = 'SCSARDPD'                                        CLE055
     C                   EVAL      DBase = 69                                                 CLE055
     C                   EVAL      DBKey = 'CLE055'                                           CLE055
     C                   EXSR      *PSSR                                                      CLE055
     C                   ENDIF                                                                CLE055
      *                                                                                       CLE055
     C                   IF        PRetCode = *BLANKS                                         CLE055
     C                   EVAL      CLE055 = 'Y'                                               CLE055
     C                   ELSE                                                                 CLE055
     C                   EVAL      CLE055 = 'N'                                               CLE055
     C                   ENDIF                                                                CLE055
      *                                                                                       CLE055
     C                   ENDIF                                                                CLE055
      *                                                                                       CLE055
      ** Determine if SAR CAS016 is installed                                                 CAS019
      *                                                                                       CAS019
     C                   CALL      'AOSARDR0'                                                 CAS019
     C                   PARM      *BLANKS       PRetCode                                     CAS019
     C                   PARM      '*VERIFY'     POption                                      CAS019
     C                   PARM      'CAS016'      PSARD                                        CAS019
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS019
      *                                                                                       CAS019
     C                   IF        PRetCode <> *BLANKS  and                                   CAS019
     C                             PRetCode <> '*NRF   '                                      CAS019
      *                                                                                       CAS019
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAS019
     C                   EVAL      DBase = 69                                                 CAS019
     C                   EVAL      DBKey = 'CAS016'                                           CAS019
     C                   EXSR      *PSSR                                                      CAS019
     C                   ENDIF                                                                CAS019
      *                                                                                       CAS019
     C                   IF        PRetCode = *BLANKS                                         CAS019
     C                   EVAL      CAS016 = 'Y'                                               CAS019
     C                   ELSE                                                                 CAS019
     C                   EVAL      CAS016 = 'N'                                               CAS019
     C                   ENDIF                                                                CAS019
                                                                                              CSD083
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALL      'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRetCode                                     CSD083
     C                   PARM      '*VERIFY'     POption                                      CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRetCode <> *BLANKS  AND                                   CSD083
     C                             PRetCode <> '*NRF   '                                      CSD083
                                                                                              CSD083
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBase = 70                                                 CSD083
     C                   EVAL      DBKey = 'CSD083'                                           CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRetCode = *BLANKS                                         CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
      *                                                                                       CER020
      ** Check for CER020 feature                                                             CER020
      *                                                                                       CER020
     C                   CALL      'AOSARDR0'                                                 CER020
     C                   PARM      *BLANKS       PRtcd                                        CER020
     C                   PARM      '*VERIFY'     POptn                                        CER020
     C                   PARM      'CER020'      PSard                                        CER020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER020
      *                                                                                       CER020
     C                   IF        PRtcd <> *BLANKS  AND                                      CER020
     C                             PRtcd <> '*NRF   '                                         CER020
      *                                                                                       CER020
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER020
     C                   EVAL      DBASE = 70                                                 CER020
     C                   EVAL      DBKEY = 'CER020'                                           CER020
     C                   EXSR      *PSSR                                                      CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   IF        PRtcd = *BLANKS                                            CER020
     C                   EVAL      CER020 = 'Y'                                               CER020
     C                   ELSE                                                                 CER020
     C                   EVAL      CER020 = 'N'                                               CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
      ** Check if CRE073 Interest Rate Rounding feature is instaled                           CRE073
      *                                                                                       CRE073
     C                   CALL      'AOSARDR0'                                                 CRE073
     C                   PARM      *BLANKS       PRtcd                                        CRE073
     C                   PARM      '*VERIFY'     POptn                                        CRE073
     C                   PARM      'CRE073'      PSard                                        CRE073
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE073
                                                                                              CRE073
     C                   IF        PRtcd <> *BLANKS  AND                                      CRE073
     C                             PRtcd <> '*NRF   '                                         CRE073
                                                                                              CRE073
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE073
     C                   EVAL      DBASE = 71                                                 CRE073
     C                   EVAL      DBKEY = 'CRE073'                                           CRE073
     C                   EXSR      *PSSR                                                      CRE073
                                                                                              CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   IF        PRtcd = *BLANKS                                            CRE073
     C                   EVAL      CRE073 = 'Y'                                               CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      CRE073 = 'N'                                               CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CLE141
      ** Access SAR details to see if CLE141 is switched on.                                  CLE141
                                                                                              CLE141
     C                   EVAL      CLE141 = 'N'                                               CLE141
     C                   CALL      'AOSARDR0'                                                 CLE141
     C                   PARM      *Blanks       PRetCode                                     CLE141
     C                   PARM      '*VERIFY'     POption                                      CLE141
     C                   PARM      'CLE141'      PSARD                                        CLE141
     C     SCSARD        PARM      *Blanks       DSFDY                                        CLE141
                                                                                              CLE141
     C                   IF        PRetCode = *BLANKS                                         CLE141
                                                                                              CLE141
     C                   EVAL      CLE141 = 'Y'                                               CLE141
     C                   ELSE                                                                 CLE141
                                                                                              CLE141
     C                   IF        PRetCode <> '*NRF'                                         CLE141
     C     *LOCK         IN        LDA                                                        CLE141
     C                   EVAL      DBKey = 'CLE141'                                           CLE141
     C                   EVAL      DBFile = 'SCSARDPD'                                        CLE141
     C                   EVAL      DBase = 913                                                CLE141
     C                   OUT       LDA                                                        CLE141
     C                   EXSR      *PSSR                                                      CLE141
     C                   ENDIF                                                                CLE141
     C                   ENDIF                                                                CLE141
                                                                                              CRE073
     C                   EVAL      SVALK1 = 'AutoEndCalcLoanFee'                            MD046370
     C                   CALLB     'AOSVALR0'                                               MD046370
     C                   PARM      *BLANKS       PRtCd                                      MD046370
     C                   PARM                    SVALK1           20                        MD046370
     C                   PARM                    SVAL1           200                        MD046370
     C                   PARM                    SVALK2           20                        MD046370
     C                   PARM                    SVAL2           200                        MD046370
     C                   PARM                    SVALK3           20                        MD046370
     C                   PARM                    SVAL3           200                        MD046370
     C                   PARM                    SVALK4           20                        MD046370
     C                   PARM                    SVAL4           200                        MD046370
     C                   PARM                    SVALK5           20                        MD046370
     C                   PARM                    SVAL5           200                        MD046370
     C                   PARM                    SVALK6           20                        MD046370
     C                   PARM                    SVAL6           200                        MD046370
     C                   PARM                    SVALK7           20                        MD046370
     C                   PARM                    SVAL7           200                        MD046370
     C                   PARM                    SVALK8           20                        MD046370
     C                   PARM                    SVAL8           200                        MD046370
     C                   PARM                    SVALK9           20                        MD046370
     C                   PARM                    SVAL9           200                        MD046370
     C                   PARM                    SVALK10          20                        MD046370
     C                   PARM                    SVAL10          200                        MD046370
      *                                                                                     MD046370
     C                   IF        PRtCd = *BLANKS                                          MD046370
     C                   MOVEL     SVAL1         AutoEndFee        1                        MD046370
     C                   ELSE                                                               MD046370
     C     *LOCK         IN        LDA                                                      MD046370
     C                   EVAL      DBFile = 'SDSVALPD'                                      MD046370
     C                   EVAL      DBase = 103                                              MD046370
     C                   EVAL      DBKey = SVALK1                                           MD046370
     C                   OUT       LDA                                                      MD046370
     C                   EXSR      SRErr                                                    MD046370
     C                   ENDIF                                                              MD046370
      *                                                                                     MD046370
      ** If Past Due Call Loans Processing;                                                   CLE134
      ** Set Basel II Classification Period Description & Days Arrays.                        CLE134
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
      ** Determine Number of Days in Each Period.                                             CLE134
                                                                                              CLE134
     C                   EVAL      DSBCE       = *ALL'999'                                    CLE134
     C                   EVAL      DSBCE(1)    = DSBCN(1)                                     CLE134
                                                                                              CLE134
     C     2             DO        9             #A                                           CLE134
     C                   IF        DSBCN(#A)   > 0             AND                            CLE134
     C                             DSBCN(#A)   < 999                                          CLE134
     C                   EVAL      DSBCE(#A)   = DSBCN(#A) - DSBCN(#A-1)                      CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDDO                                                                CLE134
                                                                                              CLE134
      ** Set Reporting Classification Period Description & Days Arrays.                       CLE134
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
      ** Determine Number of Days in Each Period.                                             CLE134
                                                                                              CLE134
     C                   EVAL      DSRCE       = *ALL'999'                                    CLE134
     C                   EVAL      DSRCE(1)    = DSRCN(1)                                     CLE134
      *                                                                                       CLE134
     C     2             DO        9             #A                                           CLE134
     C                   IF        DSRCN(#A)   > 0             AND                            CLE134
     C                             DSRCN(#A)   < 999                                          CLE134
     C                   EVAL      DSRCE(#A)   = DSRCN(#A) - DSRCN(#A-1)                      CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDDO                                                                CLE134
                                                                                              CLE134
      ** Get MPHAS dataarea.                                                                  CLE134
                                                                                              CLE134
     C     *DTAARA       DEFINE                  MPHAS                                        CLE134
     C                   IN        MPHAS                                                      CLE134
     C                   UNLOCK    MPHAS                                                      CLE134
                                                                                              CLE134
     C                   ENDIF                                                                CLE134
      *                                                                                     MD024342
     C                   MOVEL     'N'           MTHREAD           1                        MD024342
     C**********         MOVE      'CLIP'        WAPIC                             MD024342 MD025467
     C**********         MOVEL     'CLOANZ1'     WFILN                             MD024342 MD025467
     C**********         IF        MPHAS = 'A' AND                                 MD024342 MD025467
     C                   IF        MPHAS <> 'C' AND                                         MD025467
     C                             W#FRNT <> 'LE000473'                                     MD024342
     C                   MOVEL     'Y'           MTHREAD                                    MD025467
     C*****KAPILST       CHAIN     SDAPDRL0                           99           MD024342 MD025467
     C******IN99         IFEQ      '0'                                             MD024342 MD025467
     C**********         MOVEL     A8MULT        MTHREAD                           MD024342 MD025467
     C**********         ENDIF                                                     MD024342 MD025467
     C                   ENDIF                                                              MD024342
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************                        245177
      * SRCKRV  -  Check if there is any change on the facility's    *                        245177
      *            revolving credit indicator.                       *                        245177
      ****************************************************************                        245177
     C     SRCKRV        BEGSR                                                                245177
      *                                                                                       245177
     C                   MOVE      ' '           WRVCRC            1                          245177
     C                   Z-ADD     0             WVLDT             5 0                        245177
     C                   MOVE      '0'           *IN85                                        245177
     C     WKFAM2        SETLL     LEFCAML3                                                   245177
     C     WKFAM2        READE     LEFCAML3                               85                  245177
      *                                                                                       245177
     C     *IN85         DOWEQ     *OFF                                                       245177
     C     WRVCRC        ANDEQ     ' '                                                        245177
     C     RECIC         IFEQ      'D'                                                        245177
     C     FATP          ANDEQ     'RC'                                                       245177
     C                   MOVE      RVCRC         WRVCRC                                       245177
     C                   Z-ADD     VLDT          WVLDT                                        245177
     C                   ENDIF                                                                245177
     C     WKFAM2        READE     LEFCAML3                               85                  245177
     C                   ENDDO                                                                245177
      *                                                                                       245177
     C                   ENDSR                                                                245177
     C/EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      **xsACCN*-*Set*Repayment*Priority*Details.***********************                CLE134 CLE164
      *****************************************************************                       CLE134
     C*****xsACCN        BEGSR                                                         CLE134 CLE164
                                                                                              CLE134
      ***Initialisation.**********************************************                 CLE134 CLE164
                                                                                              CLE134
     C**********         CLEAR                   LEACCND0                              CLE134 CLE164
                                                                                              CLE134
      ***Derive*Settlement*Account.***********************************                 CLE134 CLE164
      ***Set*from*Payable.********************************************                 CLE134 CLE164
                                                                                              CLE134
     C**********         IF        PTYP        = 66            OR                      CLE134 CLE164
     C**********                   PTYP        = 72                                    CLE134 CLE164
     C**********         SELECT                                                        CLE134 CLE164
     C**********         WHEN      PSTM        = 01            OR                      CLE134 CLE164
     C**********                   PSTM        = 08                                    CLE134 CLE164
     C**********         EVAL      KCCY        = CCY                                   CLE134 CLE164
     C**********         EVAL      KNONB       = %SUBST(PONS:01:02)                    CLE134 CLE164
     C**********         EVAL      KCNUM       = *BLANKS                               CLE134 CLE164
     C**********         CALL      'AONOSTR0'    PLIST1                                CLE134 CLE164
                                                                                              CLE134
     C**********         IF        @RTCD       = *BLANKS                               CLE134 CLE164
     C**********         EVAL      RPCNUM      = A7CUST                                CLE134 CLE164
     C**********         EVAL      RPACOD      = %DEC(A7ACCD:10:0)                     CLE134 CLE164
     C**********         EVAL      RPACSQ      = A7ACSN                                CLE134 CLE164
     C**********         EVAL      RPBRCA      = A7BRCD                                CLE134 CLE164
     C**********         EVAL      RPACCY      = CCY                                   CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
                                                                                              CLE134
     C**********         WHEN      PSTM        = 05                                    CLE134 CLE164
     C**********         EVAL      RPCNUM      = %SUBST(PONS:01:06)                    CLE134 CLE164
     C**********         EVAL      RPACOD      = %DEC(%SUBST(PONS:07:10):10:0)         CLE134 CLE164
     C**********         EVAL      RPACSQ      = %DEC(%SUBST(PONS:17:02):02:0)         CLE134 CLE164
     C**********         EVAL      RPBRCA      = OMDB                                  CLE134 CLE164
     C**********         EVAL      RPACCY      = CCY                                   CLE134 CLE164
                                                                                              CLE134
     C**********         WHEN      PSTM        = 14                                    CLE134 CLE164
     C**********         MOVEL     PONS          KacACNO                               CLE134 CLE164
     C*****KACCNTL1      CHAIN(E)  ACCNTL1                                             CLE134 CLE164
                                                                                              CLE134
     C**********         IF        %FOUND(ACCNTL1)                                     CLE134 CLE164
     C**********         EVAL      RPCNUM      = acCNUM                                CLE134 CLE164
     C**********         EVAL      RPACOD      = acACOD                                CLE134 CLE164
     C**********         EVAL      RPACSQ      = acACSQ                                CLE134 CLE164
     C**********         EVAL      RPBRCA      = acBRCA                                CLE134 CLE164
     C**********         EVAL      RPACCY      = acCCY                                 CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
     C**********         ENDSL                                                         CLE134 CLE164
                                                                                              CLE134
      ***Set*From*Receivable.*****************************************                 CLE134 CLE164
                                                                                              CLE134
     C**********         ELSE                                                          CLE134 CLE164
     C**********         IF        PTYP        = 61            OR                      CLE134 CLE164
     C**********                   PTYP        = 62            OR                      CLE134 CLE164
     C**********                   PTYP        = 64            OR                      CLE134 CLE164
     C**********                   PTYP        = 68            OR                      CLE134 CLE164
     C**********                   PTYP        = 80                                    CLE134 CLE164
     C**********         SELECT                                                        CLE134 CLE164
     C**********         WHEN      RSTM        = 01            OR                      CLE134 CLE164
     C**********                   RSTM        = 08                                    CLE134 CLE164
     C**********         EVAL      KCCY        = CCY                                   CLE134 CLE164
     C**********         EVAL      KNONB       = %SUBST(RONS:01:02)                    CLE134 CLE164
     C**********         EVAL      KCNUM       = *BLANKS                               CLE134 CLE164
     C**********         CALL      'AONOSTR0'    PLIST1                                CLE134 CLE164
                                                                                              CLE134
     C**********         IF        @RTCD       = *BLANKS                               CLE134 CLE164
     C**********         EVAL      RPCNUM      = A7CUST                                CLE134 CLE164
     C**********         EVAL      RPACOD      = %DEC(A7ACCD:10:0)                     CLE134 CLE164
     C**********         EVAL      RPACSQ      = A7ACSN                                CLE134 CLE164
     C**********         EVAL      RPBRCA      = A7BRCD                                CLE134 CLE164
     C**********         EVAL      RPACCY      = CCY                                   CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
                                                                                              CLE134
     C**********         WHEN      RSTM        = 05                                    CLE134 CLE164
     C**********         EVAL      RPCNUM      = %SUBST(RONS:01:06)                    CLE134 CLE164
     C**********         EVAL      RPACOD      = %DEC(%SUBST(RONS:07:10):10:0)         CLE134 CLE164
     C**********         EVAL      RPACSQ      = %DEC(%SUBST(RONS:17:02):02:0)         CLE134 CLE164
     C**********         EVAL      RPBRCA      = OSDB                                CLE134 AR314017
     C**********         EVAL      RPBRCA      = OMDB                                AR314017 CLE164
     C**********         EVAL      RPACCY      = CCY                                   CLE134 CLE164
                                                                                              CLE134
     C**********         WHEN      RSTM        = 14                                    CLE134 CLE164
     C**********         MOVEL     RONS          KacACNO                               CLE134 CLE164
     C*****KACCNTL1      CHAIN(E)  ACCNTL1                                             CLE134 CLE164
                                                                                              CLE134
     C**********         IF        %FOUND(ACCNTL1)                                     CLE134 CLE164
     C**********         EVAL      RPCNUM      = acCNUM                                CLE134 CLE164
     C**********         EVAL      RPACOD      = acACOD                                CLE134 CLE164
     C**********         EVAL      RPACSQ      = acACSQ                                CLE134 CLE164
     C**********         EVAL      RPBRCA      = acBRCA                                CLE134 CLE164
     C**********         EVAL      RPACCY      = acCCY                                 CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
     C**********         ENDSL                                                         CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
                                                                                              CLE134
      ***Set*Repayment*Priority.**************************************                 CLE134 CLE164
                                                                                              CLE134
     C**********         EVAL      RPPCK1      = 99999                                 CLE134 CLE164
     C**********         EVAL      RPPCK2      = 99999                                 CLE134 CLE164
     C**********         EVAL      RPPCK3      = 99999                                 CLE134 CLE164
     C**********         EVAL      RPPCKO      = 99999                                 CLE134 CLE164
                                                                                              CLE134
     C**********         EVAL      @LNTY       = LTYP                                  CLE134 CLE164
     C**********         EVAL      @LNST       = SUTP                                  CLE134 CLE164
     C**********         EVAL      @LNCL       = CLAS                                  CLE134 CLE164
     C**********         EXSR      xrLOAN                                              CLE134 CLE164
                                                                                              CLE134
     C**********         IF        AYPCKO      > 0                                     CLE134 CLE164
     C**********         EVAL      RPPCK1      = AYPCKO                                CLE134 CLE164
     C**********         ENDIF                                                         CLE134 CLE164
                                                                                              CLE134
     C**********         MOVEL     FTYP          @FACT                               AR217556 CLE164
     C**********         EVAL      AMPCKO = *ZEROS                                     CLE134 CLE164
     C**********         EXSR      xrFACT                                            AR217556 CLE164
                                                                                            AR217556
     C**********         IF        AMPCKO      > 0                                   AR217556 CLE164
     C**********         EVAL      RPPCK2      = AMPCKO                              AR217556 CLE164
     C**********         ENDIF                                                       AR217556 CLE164
                                                                                            AR217556
     C**********         SELECT                                                        CLE134 CLE164
     C**********         WHEN      RPPCK1     <= RPPCK2        AND                     CLE134 CLE164
     C**********                   RPPCK1     <= RPPCK3                                CLE134 CLE164
     C**********         EVAL      RPPCKO      = RPPCK1                                CLE134 CLE164
                                                                                              CLE134
     C**********         WHEN      RPPCK2     <= RPPCK1        AND                     CLE134 CLE164
     C**********                   RPPCK2     <= RPPCK3                                CLE134 CLE164
     C**********         EVAL      RPPCKO      = RPPCK2                                CLE134 CLE164
                                                                                              CLE134
     C**********         WHEN      RPPCK3     <= RPPCK1        AND                     CLE134 CLE164
     C**********                   RPPCK3     <= RPPCK2                                CLE134 CLE164
     C**********         EVAL      RPPCKO      = RPPCK3                                CLE134 CLE164
     C**********         ENDSL                                                         CLE134 CLE164
                                                                                              CLE134
      ***Set*Remaining*Fields.****************************************                 CLE134 CLE164
                                                                                              CLE134
     C**********         EVAL      RPRECI      = RECI                                  CLE134 CLE164
     C**********         EVAL      RPSTDT      = VDAT                                  CLE134 CLE164
                                                                                              CLE134
      ***Loan...******************************************************                 CLE134 CLE164
                                                                                              CLE134
     C**********         EVAL      RPLNRF      = KRPLNRF                               CLE134 CLE164
     C**********         EVAL      RPLCBR      = BRCA                                  CLE134 CLE164
     C**********         EVAL      RPLCNU      = CNUM                                  CLE134 CLE164
     C**********         EVAL      RPLTYP      = LTYP                                  CLE134 CLE164
     C**********         EVAL      RPSUTP      = SUTP                                  CLE134 CLE164
     C**********         EVAL      RPLCLS      = CLAS                                  CLE134 CLE164
                                                                                              CLE134
      ***Fee...*******************************************************                 CLE134 CLE164
                                                                                              CLE134
     C**********         EVAL      RPFCBR      = *BLANKS                               CLE134 CLE164
     C**********         EVAL      RPFCNM      = *BLANKS                               CLE134 CLE164
     C**********         EVAL      RPFLNR      = *Blanks                               CLE134 CLE164
     C**********         EVAL      RPFACT      = 0                                     CLE134 CLE164
     C**********         EVAL      RPFSE1      = 0                                     CLE134 CLE164
     C**********         EVAL      RPFCOD      = 0                                     CLE134 CLE164
                                                                                              CLE134
      ***Facility...**************************************************                 CLE134 CLE164
                                                                                              CLE134
     C**********         EVAL      RPFFCB      = BRCAF                               CLE134 MD022114
     C**********         IF        *IN83 = *OFF                                      MD022114 CLE164
     C**********         EVAL      RPFFCB = L_CLFCLB                                 MD022114 CLE164
     C**********         ELSE                                                        MD022114 CLE164
     C**********         EVAL      RPFFCB = FCLB_M                                   MD022114 CLE164
     C**********         ENDIF                                                       MD022114 CLE164
     C**********         EVAL      RPFFCN      = FCUS                                  CLE134 CLE164
     C**********         EVAL      RPFFAC      = FTYP                                  CLE134 CLE164
     C**********         EVAL      RPFFNO      = FSEQ                                  CLE134 CLE164
                                                                                              CLE134
      ***Misc...******************************************************                 CLE134 CLE164
                                                                                              CLE134
     C**********         EVAL      RPFRNT      = FRNT                                  CLE134 CLE164
     C**********         EVAL      RPTMST      = TMST                                  CLE134 CLE164
                                                                                              CLE134
     C**********         EVAL      RPXRFI      = XRFI                                  CLE134 CLE164
     C**********         EVAL      RPXRFN      = XRFN                                  CLE134 CLE164
                                                                                              CLE134
     C**********         ENDSR                                                         CLE134 CLE164
     C/EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      **xeXRF*-*Evaluate*Extension*Reference*Index/Number.                          CLE134 AR1022006
      *                                                                                       CLE134
      ***This*routine*checks*whether*the*next*available*number*is*truly             CLE134 AR1022006
      ***available.**It*also*resuses*earlier*sequence*numbers*if*they               CLE134 AR1022006
      ***are*available*once*the*maximum*has*been*exceeded.                          CLE134 AR1022006
      *                                                                                       CLE134
      *****************************************************************                       CLE134
     C*****xeXRF         BEGSR                                                      CLE134 AR1022006
                                                                                              CLE134
      ***Retrieve*Next*Available*Key.                                               CLE134 AR1022006
                                                                                              CLE134
     C**********         EVAL      KGLNARI     = 'CLI'                              CLE134 AR1022006
     C*****KAPNAPD       CHAIN(E)  GLAPNAPD                                         CLE134 AR1022006
                                                                                              CLE134
     C**********         IF        %ERROR                                           CLE134 AR1022006
     C**********         MOVEL     '*ERROR '     @@RTCD                             262431 AR1022006
     C**********         EVAL      DBFILE      = 'GLAPNAPD'                         CLE134 AR1022006
     C**********         EVAL      DBKEY       = KGLNARI                            CLE134 AR1022006
     C**********         EVAL      DBASE       = 210                                CLE134 AR1022006
     C**********         EXSR      *PSSR                                            CLE134 AR1022006
     C**********         ENDIF                                                      CLE134 AR1022006
                                                                                              CLE134
     C**********         IF        NOT %FOUND(GLAPNAPD)                             CLE134 AR1022006
     C**********         EVAL      KspXRFN     = 1                                  CLE134 AR1022006
                                                                                              CLE134
     C**********         ELSE                                                       CLE134 AR1022006
     C**********         EVAL      KspXRFN     = GLNARN                             CLE134 AR1022006
     C**********         ENDIF                                                      CLE134 AR1022006
                                                                                              CLE134
      ***Check*Key*Not*Already*Allocated.                                           CLE134 AR1022006
                                                                                              CLE134
     C**********         EVAL      KspXRFI     = KGLNARI                            CLE134 AR1022006
     C*****KACMTLX       CHAIN(E)  RSACMTLX                                         CLE134 AR1022006
                                                                                              CLE134
     C**********         EVAL      DSLoop      = 0                                  CLE134 AR1022006
                                                                                              CLE134
     C**********         DOW       %FOUND(RSACMTLX)                                 CLE134 AR1022006
     C**********         IF        KspXRFN     = 9999999999                         CLE134 AR1022006
     C**********         IF        DSLoop      = 0                                  CLE134 AR1022006
     C**********         EVAL      DSLoop      = 1                                  CLE134 AR1022006
     C**********         EVAL      KspXRFN     = 0                                  CLE134 AR1022006
                                                                                              CLE134
     C**********         ELSE                                                       CLE134 AR1022006
     C**********         MOVEL     '*ERROR '     @@RTCD                             262431 AR1022006
     C**********         EVAL      DBFILE      = 'RSACMTLX'                         CLE134 AR1022006
     C**********         EVAL      DBKEY       = 'NO AVAIL KEY'                     CLE134 AR1022006
     C**********         EVAL      DBASE       = 215                                CLE134 AR1022006
     C**********         EXSR      *PSSR                                            CLE134 AR1022006
     C**********         ENDIF                                                      CLE134 AR1022006
     C**********         ENDIF                                                      CLE134 AR1022006
                                                                                              CLE134
     C**********         EVAL      KspXRFN    += 1                                  CLE134 AR1022006
     C*****KACMTLX       CHAIN(E)  RSACMTLX                                         CLE134 AR1022006
     C**********         ENDDO                                                      CLE134 AR1022006
                                                                                              CLE134
      ***Set*Extension*Reference.                                                   CLE134 AR1022006
                                                                                              CLE134
     C**********         EVAL      XRFI        = KspXRFI                            CLE134 AR1022006
     C**********         EVAL      XRFN        = KspXRFN                            CLE134 AR1022006
                                                                                              CLE134
      ***Update*GLAPNAPD*with*the*Next*Sequence*Number.                             CLE134 AR1022006
                                                                                              CLE134
     C**********         EVAL      GLNARI      = KGLNARI                            CLE134 AR1022006
     C**********         EVAL      GLNARN      = KspXRFN + 1                        CLE134 AR1022006
                                                                                              CLE134
     C**********         IF        NOT %FOUND(GLAPNAPD)                             CLE134 AR1022006
     C**********         WRITE(E)  GLAPNAPF                                         CLE134 AR1022006
                                                                                              CLE134
     C**********         ELSE                                                       CLE134 AR1022006
     C**********         UPDATE(E) GLAPNAPF                                         CLE134 AR1022006
     C**********         ENDIF                                                      CLE134 AR1022006
                                                                                              CLE134
     C**********         ENDSR                                                      CLE134 AR1022006
     C/EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      * xrFACT - Retrieve Facility Details.                                                   CLE134
      *****************************************************************                       CLE134
     C     xrFACT        BEGSR                                                                CLE134
                                                                                              CLE134
      ** Retrieve Record.                                                                     CLE134
                                                                                              CLE134
     C                   CALLB     'AOFACTR0'                                                 CLE134
     C                   PARM      '*BLANKS'     @RTCD             7                          CLE134
     C                   PARM      '*KEY   '     @OPTN             7                          CLE134
     C                   PARM                    @FACT             3                          CLE134
     C     SDFACT        PARM      SDFACT        DSFDY                                        CLE134
                                                                                              CLE134
     C                   IF        @RTCD      <> *BLANKS                                      CLE134
     C                   MOVEL     @RTCD         @@RTCD                                       262431
     C                   EVAL      DBFILE      = 'SDFACTPD'                                   CLE134
     C                   EVAL      DBKEY       = @FACT                                        CLE134
     C                   EVAL      DBASE       = 205                                          CLE134
     C                   EXSR      *PSSR                                                      CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
     C/EJECT                                                                                  CLE134
      *****************************************************************                       CLE134
      * xrLOAN - Retrieve Loan Details.                                                       CLE134
      *****************************************************************                       CLE134
     C     xrLOAN        BEGSR                                                                CLE134
                                                                                              CLE134
      ** Retrieve Record.                                                                     CLE134
                                                                                              CLE134
     C**********         CALL      'AOLOANR0'                                          CLE134 CLE164
     C                   CALL      'AOLOANR1'                                                 CLE164
     C                   PARM      *BLANKS       @RTCD             7                          CLE134
     C                   PARM      '*KEY   '     @OPTN             7                          CLE134
     C                   PARM                    @LNTY             2                          CLE134
     C                   PARM                    @LNST             2                          CLE134
     C                   PARM                    @LNCL             4                          CLE134
     C*****SDLOAN        PARM      SDLOAN        DSFDY                                 CLE134 CLE164
     C     SDLOAN        PARM      SDLOAN        DSSDY                                        CLE164
                                                                                              CLE134
     C                   IF        @RTCD      <> *BLANKS                                      CLE134
     C                   MOVEL     @RTCD         @@RTCD                                       262431
     C                   EVAL      DBFILE      = 'SDLOANPD'                                   CLE134
     C                   EVAL      DBKEY       = @LNST + @LNST + @LNCL                        CLE134
     C                   EVAL      DBASE       = 206                                          CLE134
     C                   EXSR      *PSSR                                                      CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   ENDSR                                                                CLE134
                                                                                              CLE134
      ****************************************************************                        CLE134
      /EJECT                                                                                  CLE134
      ****************************************************************                        CLE134
      * SrUpdadateMQF -  Update Transaction Log File sent to MQ      *                        CLE134
      ****************************************************************                        CLE134
     C*****SRUpdateMQF   BEGSR                                                      CLE134 MD022807I
                                                                                              CLE134
     C*****L_CLFRNT      CHAIN     LEMQLGL0                                         CLE134 MD022807I
     C**********         IF        %FOUND(LEMQLGL0)                                 CLE134 MD022807I
     C**********         SELECT                                                     CLE134 MD022807I
      *                                                                                       CLE134
      ** If current value of transaction status is "S" set this to "P"                        CLE134
     C**********         WHEN      LGSTAT = 'S'                                     CLE134 MD022807I
     C**********         EVAL      LGSTAT = 'P'                                     CLE134 MD022807I
      *                                                                                       CLE134
      ** If current value of transaction status is "E" set this to "R"                        CLE134
     C**********         WHEN      LGSTAT = 'E'                                     CLE134 MD022807I
     C**********         EVAL      LGSTAT = 'R'                                     CLE134 MD022807I
     C**********         ENDSL                                                      CLE134 MD022807I
      **********                                                                 AR1085742 MD022807I
     C**********         CALLB     'ZAGENTMSTM'                                  AR1085742 MD022807I
     C**********         PARM                    TimeStamp                       AR1085742 MD022807I
      *                                                                                    AR1085742
      ** Timestamp                                                                         AR1085742
      *                                                                                    AR1085742
     C**********         EVAL      LGPROC = TimeStamp                            AR1085742 MD022807I
      *                                                                                    AR1085742
     C**********         EVAL      LGLOAN = L_CLLNRF                             AR1085742 MD022807I
     C**********         UPDATE    LEMQLGPF                                         CLE134 MD022807I
     C**********         ENDIF                                                      CLE134 MD022807I
                                                                                              CLE134
     C**********         ENDSR                                                      CLE134 MD022807I
      ****************************************************************                     AR1079502
      /EJECT                                                                               AR1079502
      ****************************************************************                     AR1079502
      * SrUpdLEPDUE - Update Past Due and Original Loan Link         *                     AR1079502
      ****************************************************************                     AR1079502
     C     SrUpdLEPDUE   BEGSR                                                             AR1079502
     C     LNRF          CHAIN     LEPDUELC                           97                   AR1079502
     C                   DOW       *IN97 = '0'                                             AR1079502
     C**********         EVAL      YRECI = 'R'                                    AR1079502 MD041714
     C**********         EVAL      YTYLC = 'R'                                    AR1079502 MD041714
     C**********         UPDATE    LEPDUEDC                                       AR1079502 MD041714
     C                   DELETE    LEPDUEDC                                                 MD041714
     C     LNRF          READE     LEPDUELC                               97               AR1079502
     C                   ENDDO                                                             AR1079502
     C                   ENDSR                                                             AR1079502
      *****************************************************************                     MD020954
     C/EJECT                                                                                MD020954
      *****************************************************************                     MD020954
      *                                                               *                     MD020954
      * SrUpdTrailer - Update trailer file                            *                     MD020954
      *                                                               *                     MD020954
      * Called by: SRPDCLIN, SRPDCLUP                                 *                     MD020954
      *                                                               *                     MD020954
      * Calls: None                                                   *                     MD020954
      *                                                               *                     MD020954
      *****************************************************************                     MD020954
     C     SrUpdTrailer  BEGSR                                                              MD020954
      *                                                                                     MD020954
      ***  Access trailer record                                                            MD020954
      *                                                                                     MD020954
     C                   MOVE      'Z'           WEPAR                                      MD020954
     C                   MOVE      '999999'      WALON                                      MD020954
     C                   MOVE      '999999Z'     WLTRL             7                        MD020954
     C     WKLON         CHAIN     CLOANE                             89                    MD020954
      ** Insert trailer record for LELWNEZ1                                                 MD020954
     C     *IN89         IFEQ      '1'                                                      MD020954
     C                   CLEAR                   LELWNEZF                                   MD020954
     C                   MOVE      'T'           PDRECI                                     MD020954
     C                   MOVE      '999999'      PDLNRF                                     MD020954
     C                   MOVE      'Z'           PDRCDT                                     MD020954
      *                                                                                     MD020954
      ***  Set up amount fields for insert                                                  MD020954
      *                                                                                     MD020954
     C     CPAM          DIV       1000          ZZAMT            15 3                      MD020954
     C     ZZAMT         IFLT      *ZEROS                                                   MD020954
     C                   Z-SUB     ZZAMT         ZZAMT                                      MD020954
     C                   ENDIF                                                              MD020954
      *                                                                                     MD020954
     C                   Z-ADD     PDVRIF        ZZTOTI                                     MD020954
     C                   Z-ADD     PDVRIL        ZZTOTD                                     MD020954
     C                   EXSR      GLZADD                                                   MD020954
     C                   Z-ADD     ZZTOTI        PDVRIF                                     MD020954
     C                   Z-ADD     ZZTOTD        PDVRIL                                     MD020954
     C     CPAM          DIV       1000          ZZAMT                                      MD020954
     C     ZZAMT         IFLT      *ZEROS                                                   MD020954
     C                   Z-SUB     ZZAMT         ZZAMT                                      MD020954
     C                   ENDIF                                                              MD020954
      *                                                                                     MD020954
     C                   Z-ADD     PDVLAF        ZZTOTI                                     MD020954
     C                   Z-ADD     PDVLAL        ZZTOTD                                     MD020954
     C                   EXSR      GLZADD                                                   MD020954
     C                   Z-ADD     ZZTOTI        PDVLAF                                     MD020954
     C                   Z-ADD     ZZTOTD        PDVLAL                                     MD020954
      *                                                                                     MD020954
     C                   Z-ADD     3             PDNORE                                     MD020954
     C                   Z-ADD     2             PDNINS                                     MD020954
     C                   Z-ADD     3             PZNLRA                                     MD020954
     C                   Z-ADD     BJRDNB        PDLCD                                      MD020954
     C                   MOVE      'I'           PDCHTP                                     MD020954
     C                   Z-ADD     1             PZTNLU                                     MD020954
     C                   WRITE     LELWNEZF                                                 MD020954
      *                                                                                     MD020954
      ** Set pointer to the new record for update                                           MD020954
      *                                                                                     MD020954
     C                   ELSE                                                               MD020954
      *                                                                                     MD020954
      ***  Set up amount fields for insert                                                  MD020954
      *                                                                                     MD020954
     C     CPAM          DIV       1000          ZZAMT            15 3                      MD020954
     C     ZZAMT         IFLT      *ZEROS                                                   MD020954
     C                   Z-SUB     ZZAMT         ZZAMT                                      MD020954
     C                   ENDIF                                                              MD020954
      *                                                                                     MD020954
     C                   Z-ADD     PDVRIF        ZZTOTI                                     MD020954
     C                   Z-ADD     PDVRIL        ZZTOTD                                     MD020954
     C                   EXSR      GLZADD                                                   MD020954
     C                   Z-ADD     ZZTOTI        PDVRIF                                     MD020954
     C                   Z-ADD     ZZTOTD        PDVRIL                                     MD020954
     C     CPAM          DIV       1000          ZZAMT                                      MD020954
     C     ZZAMT         IFLT      *ZEROS                                                   MD020954
     C                   Z-SUB     ZZAMT         ZZAMT                                      MD020954
     C                   ENDIF                                                              MD020954
      *                                                                                     MD020954
     C                   Z-ADD     PDVLAF        ZZTOTI                                     MD020954
     C                   Z-ADD     PDVLAL        ZZTOTD                                     MD020954
     C                   EXSR      GLZADD                                                   MD020954
     C                   Z-ADD     ZZTOTI        PDVLAF                                     MD020954
     C                   Z-ADD     ZZTOTD        PDVLAL                                     MD020954
      *                                                                                     MD020954
      ***  Set up relevant total fields                                                     MD020954
      *                                                                                     MD020954
     C                   ADD       2             PDNORE                                     MD020954
     C                   ADD       2             PDNINS                                     MD020954
     C                   ADD       2             PZNLRA                                     MD020954
      *                                                                                     MD020954
      ***  Update CLOAN trailer                                                             MD020954
      *                                                                                     MD020954
     C                   Z-ADD     BJRDNB        PDLCD                                      MD020954
     C                   MOVE      'U'           PDCHTP                                     MD020954
     C                   ADD       1             PZTNLU                                     MD020954
     C                   UPDATE    LELWNEZF                                                 MD020954
     C                   ENDIF                                                              MD020954
      *                                                                                     MD020954
     C                   ENDSR                                                              MD020954
      *****************************************************************                     MD024342
      /EJECT                                                                                MD024342
      *****************************************************************                     MD024342
      * Initialise - Initialise trailer fields                        *                     MD024342
      *****************************************************************                     MD024342
     C     Initialise    BEGSR                                                              MD024342
      *                                                                                     MD024342
     C                   EVAL      NORE = 0                                                 MD024342
     C                   EVAL      NLRB = 0                                                 MD024342
     C                   EVAL      NINS = 0                                                 MD024342
     C                   EVAL      NDEL = 0                                                 MD024342
     C                   EVAL      NLRA = 0                                                 MD024342
     C                   EVAL      VLBF = 0                                                 MD024342
     C                   EVAL      VLBL = 0                                                 MD024342
     C                   EVAL      VRIF = 0                                                 MD024342
     C                   EVAL      VRIL = 0                                                 MD024342
     C                   EVAL      VRDF = 0                                                 MD024342
     C                   EVAL      VRDL = 0                                                 MD024342
     C                   EVAL      VLAF = 0                                                 MD024342
     C                   EVAL      VLAL = 0                                                 MD024342
      *                                                                                     MD024342
     C                   ENDSR                                                              MD024342
      *****************************************************************                       CLE164
      /EJECT                                                                                  CLE164
      *****************************************************************                       CLE164
      *                                                               *                       CLE164
      * SrWriteExtFile - Write Repayment Priority Details to          *                       CLE164
      *                  CLONZTD                                      *                       CLE164
      *                                                               *                       CLE164
      * Called by: INSERT                                             *                       CLE164
      *                                                               *                       CLE164
      * Calls: LE000506 - Midas LE Update Repayment Priority          *                       CLE164
      *        Extension Table                                        *                       CLE164
      *                                                               *                       CLE164
      *****************************************************************                       CLE164
     C     WriteExtFile  BEGSR                                                                CLE164
                                                                                              CLE164
     C**********         IF        CLE134 = *OFF                                     CLE164 MD039449
     C                   IF        CLE134 = 'N'                                             MD039449
     C                   LEAVESR                                                              CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
     C                   IF        L_CLCHTP = 'I' AND                                         CLE164
     C                             AUTO <> 'C'                                                CLE164
     C                   LEAVESR                                                              CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
     C                   EVAL      aORIGLN(1) = 'OLINT'                                       CLE164
     C                   EVAL      aORIGLN(2) = 'OLINM'                                       CLE164
     C                   EVAL      aORIGLN(3) = 'OLPRI'                                       CLE164
     C                   EVAL      aORIGLN(4) = 'OLPRM'                                       CLE164
                                                                                              CLE164
     C                   EVAL      aPDCL_X(1) = 'XINTR'                                       CLE164
     C                   EVAL      aPDCL_X(2) = 'XINTM'                                       CLE164
     C                   EVAL      aPDCL_X(3) = 'XPRIN'                                       CLE164
     C                   EVAL      aPDCL_X(4) = 'XPRIM'                                       CLE164
                                                                                              CLE164
     C                   EVAL      aPDCL_Y(1) = 'YINTR'                                       CLE164
     C                   EVAL      aPDCL_Y(2) = 'YINTM'                                       CLE164
     C                   EVAL      aPDCL_Y(3) = 'YPRIN'                                       CLE164
     C                   EVAL      aPDCL_Y(4) = 'YPRIM'                                       CLE164
                                                                                              CLE164
     C                   EVAL      aPDCL_Z(1) = 'ZINTR'                                       CLE164
     C                   EVAL      aPDCL_Z(2) = 'ZINTM'                                       CLE164
     C                   EVAL      aPDCL_Z(3) = 'ZPRIN'                                       CLE164
     C                   EVAL      aPDCL_Z(4) = 'ZPRIM'                                       CLE164
                                                                                              CLE164
     C                   EVAL      @LNTY = LTYP                                               CLE164
     C                   EVAL      @LNST = SUTP                                               CLE164
     C                   EVAL      @LNCL = CLAS                                               CLE164
     C                   EXSR      XrLoan                                                     CLE164
     C                   EVAL      wLSPDPGrpID = AYPGID                                       CLE164
                                                                                              CLE164
     C**********         EVAL      @FACT = %EDITC(FTYP:'3')                          CLE164 MD032052
     C                   MOVE      FTYP          @FACT                                      MD032052
     C                   EVAL      AMPGID = *BLANKS                                           CLE164
     C                   EXSR      XrFact                                                     CLE164
     C                   EVAL      wFTPDPGrpID = AMPGID                                       CLE164
     C                   EVAL      wFCPDPGrpID = '***'                                        CLE164
                                                                                              CLE164
     C                   EVAL      wAction = '*INSERT'                                        CLE164
     C                   EVAL      wFile   = 'CLOANZTD'                                       CLE164
     C                   EVAL      wLoanRef  = LNRF                                           CLE164
     C                   EVAL      wCustomer = CNUM                                           CLE164
     C                   EVAL      wBranch  = *BLANKS                                         CLE164
     C                   EVAL      wFeeFclty = *Zeros                                         CLE164
     C                   EVAL      wFeeLoan = *BLANKS                                         CLE164
     C                   EVAL      wFeeSeqn = *ZEROS                                          CLE164
     C                   EVAL      MAX_CATEGORY = 4                                           CLE164
                                                                                              CLE164
      ****************************************************************                        CLE164
      **  Original Loans (Auto-Settle = 'C' and must not begin      **                        CLE164
      **  with 'X','Y', or 'Z'                                      **                        CLE164
      ****************************************************************                        CLE164
                                                                                              CLE164
     C                   MOVEL     LTYP          LOAN_PREFIX       1                          CLE164
     C                   IF        CUR_AUTO = 'C' AND                                         CLE164
     C                             (LOAN_PREFIX <> 'X'                                        CLE164
     C                             AND LOAN_PREFIX <> 'Y'                                     CLE164
     C                             AND LOAN_PREFIX <> 'Z')                                    CLE164
     C                   EVAL       aCAT = %SUBARR(aORIGLN:1)                                 CLE164
     C                   EVAL      wLREF = LNRF                                               CLE164
     C                   EXSR      ProcessMatrix                                              CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
      ****************************************************************                        CLE164
      **  PDCL Auto-Settle = 'C' and first character of loan type   **                        CLE164
      **  begins with 'X','Y', or 'Z'                               **                        CLE164
      ****************************************************************                        CLE164
                                                                                              CLE164
     C                   IF        CUR_AUTO = 'C' AND                                         CLE164
     C                             (LOAN_PREFIX = 'X'                                         CLE164
     C                             OR LOAN_PREFIX = 'Y'                                       CLE164
     C                             OR LOAN_PREFIX = 'Z')                                      CLE164
                                                                                              CLE164
     C                   SELECT                                                               CLE164
                                                                                              CLE164
     C                   WHEN      LOAN_PREFIX = 'X'                                          CLE164
     C                   EVAL      aCAT = %SUBARR(aPDCL_X:1)                                  CLE164
     C                   EVAL      wLREF = LNRF                                               CLE164
     C                   EXSR      ProcessMatrix                                              CLE164
     C                   WHEN      LOAN_PREFIX = 'Y'                                          CLE164
     C                   EVAL      aCAT = %SUBARR(aPDCL_Y:1)                                  CLE164
     C                   EVAL      wLREF = LNRF                                               CLE164
     C                   EXSR      ProcessMatrix                                              CLE164
     C                   WHEN      LOAN_PREFIX = 'Z'                                          CLE164
     C                   EVAL      aCAT = %SUBARR(aPDCL_Z:1)                                  CLE164
     C                   EVAL      wLREF = LNRF                                               CLE164
     C                   EXSR      ProcessMatrix                                              CLE164
                                                                                              CLE164
     C                   ENDSL                                                                CLE164
                                                                                              CLE164
                                                                                              CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
     C                   ENDSR                                                                CLE164
      *****************************************************************                       CLE164
      /EJECT                                                                                  CLE164
      *****************************************************************                       CLE164
      *                                                               *                       CLE164
      * UpdateExtFile - Update Repayment Priority Details to          *                       CLE164
      *                   CLOANZTD                                    *                       CLE164
      *                                                               *                       CLE164
      * Called by: INSERT                                             *                       CLE164
      *                                                               *                       CLE164
      * Calls: WriteExtFile                                           *                       CLE164
      *                                                               *                       CLE164
      *****************************************************************                       CLE164
     C     UpdateExtFile BEGSR                                                                CLE164
                                                                                              CLE164
     C**********         IF        CLE134 = *OFF                                     CLE164 MD039449
     C                   IF        CLE134 = 'N'                                             MD039449
     C                   LEAVESR                                                              CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
     C                   IF        Prv_AUTO <> New_AUTO                                       CLE164
                                                                                              CLE164
     C                   IF        Prv_AUTO <> 'C' AND New_AUTO = 'C'                         CLE164
     C                   MOVEL     New_AUTO      CUR_AUTO                                     CLE164
     C                   EXSR      WriteExtFile                                               CLE164
     C                   ENDIF                                                                CLE164
     C                   IF        Prv_AUTO =  'C' AND New_AUTO <> 'C'                        CLE164
     C                   EXSR      DeleteExtFile                                              CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
     C                   ENDSR                                                                CLE164
      *****************************************************************                       CLE164
      /EJECT                                                                                  CLE164
      *****************************************************************                       CLE164
      *                                                               *                       CLE164
      * DeleteExtFile - Delete Repayment Priority Details from        *                       CLE164
      *                 CLOANZTD                                      *                       CLE164
      *                                                               *                       CLE164
      * Called by: INSERT                                             *                       CLE164
      *                                                               *                       CLE164
      * Calls: LE000506 - Midas LE Update Repayment Priority          *                       CLE164
      *        Extension Table                                        *                       CLE164
      *                                                               *                       CLE164
      *****************************************************************                       CLE164
     C     DeleteExtFile BEGSR                                                                CLE164
                                                                                              CLE164
     C**********         IF        CLE134 = *ON                                      CLE164 MD039449
     C                   IF        CLE134 = 'N'                                             MD039449
     C                   LEAVESR                                                              CLE164
     C                   ENDIF                                                                CLE164
     C                   EVAL      wFTPDPGrpID = *BLANKS                                      CLE164
     C                   EVAL      wLSPDPGrpID = *BLANKS                                      CLE164
     C                   EVAL      wFCPDPGrpID = *BLANKS                                      CLE164
     C                   EVAL      wAction = '*DELETE'                                        CLE164
     C                   EVAL      wFile   = 'CLOANZTD'                                       CLE164
     C                   EVAL      wLoanRef  = LNRF                                           CLE164
     C                   EVAL      wCustomer = CNUM                                           CLE164
     C                   EVAL      wBranch  = *BLANKS                                         CLE164
     C                   EVAL      wFeeFclty = *Zeros                                         CLE164
     C                   EVAL      wFeeLoan = *BLANKS                                         CLE164
     C                   EVAL      wFeeSeqn = *ZEROS                                          CLE164
     C                   CALLP     UPDATE_MATRIX(                                             CLE164
     C                               wRetCode                                                 CLE164
     C                             : wAction                                                  CLE164
     C                             : wFile                                                    CLE164
     C                             : LNRF                                                     CLE164
     C                             : wBranch                                                  CLE164
     C                             : wCustomer                                                CLE164
     C                             : wFeeFclty                                                CLE164
     C                             : wFeeLoan                                                 CLE164
     C                             : wFeeSeqn                                                 CLE164
     C                             : wLSPDPGrpID                                              CLE164
     C                             : wFTPDPGrpID                                              CLE164
     C                             : wFCPDPGrpID                                              CLE164
     C                             : wCategory                                                CLE164
     C                             )                                                          CLE164
     C                   IF        wRetCode <> *Blanks                                        CLE164
     C     *LOCK         IN        LDA                                                        CLE164
     C                   MOVE      *BLANKS       DBKEY                                        CLE164
     C                   MOVEL     'CLOANZTD'    DBFILE                                       CLE164
     C                   Z-ADD     101           DBASE                                        CLE164
     C                   OUT       LDA                                                        CLE164
     C                   EXSR      SRERR                                                      CLE164
     C                   ENDIF                                                                CLE164
     C                   ENDSR                                                                CLE164
      *****************************************************************                       CLE164
      /EJECT                                                                                  CLE164
      *****************************************************************                       CLE164
      *                                                               *                       CLE164
      * ProcessMatrix - Process Repayment Matrix  Details from        *                       CLE164
      *                                                               *                       CLE164
      * Called by: INSERT                                             *                       CLE164
      *                                                               *                       CLE164
      * Calls:                                                        *                       CLE164
      *                                                               *                       CLE164
      *                                                               *                       CLE164
      *****************************************************************                       CLE164
     C     ProcessMatrix BEGSR                                                                CLE164
                                                                                              CLE164
     C                   FOR       Index = 1 TO MAX_CATEGORY                                  CLE164
     C                   CALLP     UPDATE_MATRIX(                                             CLE164
     C                               wRetCode                                                 CLE164
     C                             : wAction                                                  CLE164
     C                             : wFile                                                    CLE164
     C                             : wLREF                                                    CLE164
     C                             : wBranch                                                  CLE164
     C                             : wCustomer                                                CLE164
     C                             : wFeeFclty                                                CLE164
     C                             : wFeeLoan                                                 CLE164
     C                             : wFeeSeqn                                                 CLE164
     C                             : wLSPDPGrpID                                              CLE164
     C                             : wFTPDPGrpID                                              CLE164
     C                             : wFCPDPGrpID                                              CLE164
     C                             : aCAT(Index)                                              CLE164
     C                             )                                                          CLE164
     C                   IF        wRetCode <> *Blanks                                        CLE164
     C     *LOCK         IN        LDA                                                        CLE164
     C                   MOVE      *BLANKS       DBKEY                                        CLE164
     C                   MOVEL     'CLOANZTD'    DBFILE                                       CLE164
     C                   Z-ADD     102           DBASE                                        CLE164
     C                   OUT       LDA                                                        CLE164
     C                   EXSR      SRERR                                                      CLE164
     C                   ENDIF                                                                CLE164
     C                   ENDFOR                                                               CLE164
                                                                                              CLE164
     C                   ENDSR                                                                CLE164
      *****************************************************************                       CLE164
      /EJECT                                                                                  CLE164
      *****************************************************************                       CLE164
      *                                                               *                       CLE164
      * UpdOrigLoan - Update CLOANZTD of Original Loan AUTO = C       *                       CLE164
      *                                                               *                       CLE164
      * Called by:                                                    *                       CLE164
      *                                                               *                       CLE164
      * Calls:                                                        *                       CLE164
      *                                                               *                       CLE164
      *                                                               *                       CLE164
      *****************************************************************                       CLE164
     C     UpdOrigLoan   BEGSR                                                                CLE164
                                                                                              CLE164
     C                   IF        CUR_AUTO = 'C' AND                                         CLE164
     C                             (LOAN_PREFIX = 'X'                                         CLE164
     C                             OR LOAN_PREFIX = 'Y'                                       CLE164
     C                             OR LOAN_PREFIX = 'Z')                                      CLE164
                                                                                              CLE164
     C                   IF        ORLN <> *BLANK                                             CLE164
     C                   EVAL      aCAT = %SUBARR(aORIGLN:1)                                  CLE164
     C                   EVAL      wLREF = ORLN                                               CLE164
     C     wLREF         CHAIN     CLOANZI0                                                   CLE164
     C                   IF        NOT %FOUND(CLOANZI0)                                       CLE164
     C                   EXSR      ProcessMatrix                                              CLE164
     C                   ENDIF                                                                CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CLE164
     C                   ENDSR                                                                CLE164
                                                                                              CLE164
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      /EJECT
      ********************************************************************
      *
      ** Update LTRIX header record
      *
     O*LTRIX**** E            TRXHDR                                                        AR322732
     O**********             NORED               11P                                        AR322732
     O**********             RRNAD               20P                                        AR322732
     O**********             NLNRD               29P                                        AR322732
     O**********             NATN                40P                                        AR322732
      *
      ** Update LTRIX detail record
      *
     O**********E            TRXDTL                                                         AR322732
     OLTRIX     EADD         TRXDTL                                                         AR322732
     O                                            2 'DL'
     O                       L_CLLNRF             8
     O                       VDATD               13
     O                                           16 '000'
     O                       LtrixCHTP           17
     O                       CNRQD               18
     O                                           19 'N'
     O                                           20 ' '
     O                                           25 '00001'
     O                                           26 'N'
     O                       PRI1D               27
     O                       L_CLBRCA            34
     O********               RRNAD               37P                                        AR322732
     O                       RRNTD               37P                                        AR322732
     O                       NATN                40P
     O                       PRI2D               41
     O                       PRI3D               42
     O                       PRI4D               43
     O                                           44 ' '                                     AR322732
     O                                           45 ' '                                     AR322732
      /EJECT
**  CPY@
(c) Finastra International Limited 2002
**  POWER - ARRAY OF POWERS FOR CURRENCY CONVERSION
0000001
0000010
0000100
0001000
0010000
0100000
1000000
** WNOST **      Table of settlements through nostros
0102070812
** XOT - OPEN TAGS for XML                                                                   BUG3760
<Receipt Nostro>                                                                             BUG3760
<Receipt Intermed Bank>                                                                      BUG3760
<Receipt Ordering Bank>                                                                      BUG3760
<Receipt Ordering Cust>                                                                      BUG3760
<Payment Nostro>                                                                             BUG3760
<Payment Intermed Bank>                                                                      BUG3760
<Payment Ordering Bank>                                                                      BUG3760
<Payment Ordering Cust>                                                                      BUG3760
<Receiver Correspondent>                                                                     BUG3760
<Receiver>                                                                                   BUG3760
<Account With Bank>                                                                          BUG3760
<Beneficiary>                                                                                BUG3760
<Details Of Payment>                                                                         BUG3760
** XCT - CLOSE TAGS for XML                                                                  BUG3760
</Receipt Nostro>                                                                            BUG3760
</Receipt Intermed Bank>                                                                     BUG3760
</Receipt Ordering Bank>                                                                     BUG3760
</Receipt Ordering Cust>                                                                     BUG3760
</Payment Nostro>                                                                            BUG3760
</Payment Intermed Bank>                                                                     BUG3760
</Payment Ordering Bank>                                                                     BUG3760
</Payment Ordering Cust>                                                                     BUG3760
</Receiver Correspondent>                                                                    BUG3760
</Receiver>                                                                                  BUG3760
</Account With Bank>                                                                         BUG3760
</Beneficiary>                                                                               BUG3760
</Details Of Payment>                                                                        BUG3760
