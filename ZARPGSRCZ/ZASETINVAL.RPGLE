     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Settle instructions validation')              *
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  ZASETINVAL - SETTLEMENT INSTRUCTIONS VALIDATION              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD024884A          Date 04Jul17               *
      *  Prev Amend No. MD032089           Date 28Apr15               *
      *                 MD040199           Date 05Aug16               *
      *                 MD039348           Date 17Jun16               *
      *                 MD033870           Date 17Apr15               *
      *                 AR892347           Date 25Nov14               *
      *                 MD030342           Date 25Nov14               *
      *                 MD029779           Date 25Nov14               *
      *                 CSW214             Date 25Nov14               *
      *                 CDL094             Date 01Sep14               *
      *                 254023             Date 19Aug14               *
      *                 MD023833           Date 27Nov13               *
      *                 MD022945           Date 18Oct13               *
      *                 CSW213             Date 03Jun13               *
      *                 MD020242           Date 30Sep13               *
      *                 MD021526           Date 01Aug13               *
      *                 MD020816           Date 11Jun13               *
      *                 MD000091           Date 15May13               *
      *                 AR1096686          Date 22Mar13               *
      *                 CMG003             Date 04Oct12               *
      *                 AR1039735          Date 02Oct12               *
      *                 AR1005230          Date 11Feb13               *
      *                 AR853046           Date 25Nov12               *
      *                 AR641619           Date 24Sep12               *
      *                 CLE134             Date 01Aug12               *
      *                 AR1000515          Date 06Jul12               *
      *                 CSW212             Date 03May12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR863960           Date 14Nov11               *
      *                 AR787620           Date 10Jun11               *
      *                 260863             Date 01Jul09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 260428             Date 28May09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG14913           Date 27Sep07               *
      *                 248393             Date 13Jun07               *
      *                 246120             Date 05Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 244636             Date 15Feb07               *
      *                 244370             Date 15Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 217715             Date 19Sep06               *
      *                 238721             Date 11Aug06               *
      *                 BUG12624           Date 21Nov06               *
      *                 BUG12540           Date 08Nov06               *
      *                 239587             Date 03May06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG11240           Date 23May06               *
      *                 239836             Date 18May06               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE033             Date 26Apr05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7875            Date 17Aug05               *
      *                 CSW037A            Date 02May05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG6393            Date 31Mar05               *
      *                 BUG6010            Date 30Mar05               *
      *                 CDL036             Date 28Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4511            Date 16Oct04               *
      *                 BUG4490            Date 11Oct04               *
      *                 BUG4478            Date 05Oct04               *
      *                 CGL014             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 CDL018             Date 03Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 207137             Date 05Jun03               *
      *                 214110             Date 19Feb03               *
      *                 CRE008             Date 19Feb02               *
      *                 219241             Date 01Jul03               *
      *                 CSW203             Date 26May03               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4.01.02 ----------------------------------------*
      *                 196461             Date 22Apr02               *
      *                 197865             Date 07Mar02               *
      * Midas Release 4.01.01 ----------------------------------------*
      *                 CSW202             Date 20May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP068             Date 01Mar02               *
      *                 196808             Date 25Oct01               *
      *                 194282             Date 15Oct01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 200400             Date 20Nov01               *
      *                 CSW201             Date 02May01               *
      *                 193584             Date 08Jun01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CUT009             Date 22Mar01               *
      *                 182652             Date 20Feb01               *
      *                 CUT009             Date 05Feb01               *
      *                 185751             Date 17Nov00               *
      *                 179510             Date 03Jul00               *
      *                 CIR003             Date 12Sep00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 186433             Date 16Nov00               *
      *                 CDL008             Date 02May00               *
      *                 182114             Date 27Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CSW200             DATE 21Aug00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSW097             Date 02Dec99               *
      *                 166320             Date 23Sep99               *
      *                 167942             Date 21Sep99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 164570             Date 16Jul99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 152344             DATE 05Jan98               *
      *                 CAP004             Date 07Sep98               *
      *                 CAP003             Date 03Jun98               *
      *                 136939             Date 10Jun98               *
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD024884A - Incorrect Payment and Receipt accounts           *
      *  MD032089  - PSTM and PONS lost when amended via SOAP with    *
      *              auto AUTH = 'Y'. Error due to clear of received  *
      *              ##PAYF, ##PAYR and ##PRIF on *INZSR and will not *
      *              execute SR/PAYMNT.  Remove CLEAR on *INZSR.      *
      *              They will be cleared as needed on specific SRs.  *
      *  MD040199 - ISDA Agreement Version reflected incorrectly in   *
      *             MT reports and deals enquiry. Reverse MD-33870.   *
      *  MD039348 - Error message "Settlement Payments fields cannot  *
      *             be amended. (Field: Pay - Ordering Customer)" is  *
      *             displayed during amendment of maturity date of    *
      *             a valued deal. Prevent defaulting of settlement   *
      *             fields when already protected by the system.      *
      *  MD033870 - Wrong value for DDAGVV. Corrected MOVE and MOVEL. *
      *  AR892347 - Details of payment defaulting should only take    *
      *             place if an MT103 is to be generated: i.e. if     *
      *             ordering customer is present or if beneficiary    *
      *             is not a bank. (Child: AR892348)                  *
      *  MD030342 - Valid values for Agreement Type for FX and AT     *
      *             transaction types for MT600                       *
      *  MD029779 - Incorrect error message displayed for Sender-to-  *
      *             Receiver fields                                   *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *  254023 - EXSS - ISDA cannot be input as 2006.                *
      *  MD023833 - Save return code before calling CSFACT and        *
      *             restore after and reset ACCT after call to        *
      *             AOACCTV0                                          *
      *  MD022945 - Incorrect message shown for /SRCE/ validation.    *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  MD020242 - Pay settlement of Parts Sold Loan in MAPY is      *
      *             returned as blank by ZASETINVAL on authorisation. *
      *             Call PAYMNT for MAPY when action is X and ##PPAY  *
      *             is ' '.                                           *
      *  MD021526 - System allowed inserting a deal with closed       *
      *             settlement accounts. Reversed fix AR1096686 as    *
      *             the validation should prevent this and display    *
      *             error message instead of warning message.         *
      *  MD020816 - Cannot authorize a loan transaction when Receipt  *
      *             Settlement currency is different from transaction *
      *             currency.  Error message "Receipt Settlement Cur- *
      *             rency is not a valid dealing currency" is being   *
      *             displayed upon pressing the Authorise button      *
      *  MD000091 - Event Codes Substitution                          *
      *  AR1096686 - LDNI does not allow closed account in Pay-Our    *
      *              Account and Receipt-Our Account fields. Warning  *
      *              is expected instead of Error.                    *
      *  CMG003    - SWIFT MT600 Message Generation                   *
      *  AR1039735 - Message type not defined before call of ME9950   *
      *  AR1005230 - Error on cross ccy settlement of a Manual        *
      *              Repayment on a Loan (Child:AR1005231)            *
      *  AR853046 - CLE031: System is not allowing to set Settlement  *
      *             currency in MR.                                   *
      *             Inclusion of ##CALP='MAPY' on CLE031 validations. *
      *             (Child: AR853047)                                 *
      *  AR641619 - Defaulting of receipt/pay settlement should be    *
      *             done during insert only. Settlement fields not    *
      *             amendable should not be validated anymore.        *
      *             Pattern to fix AR375187.                          *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  AR1000515 - 'DERV' must be accepted as a valid ISDA          *
      *              Agreement Type                                   *
      *  CSW212 - SWIFT 2012 Changes                                  *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  AR863960 - Settlement Payment fields values are reset to     *
      *             blanks                                            *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,ZAH00004                                 *
      *             WNCPYSRC,ZAH00005                                 *
      *  260863 - Skip Validation for closed Nostro Account and       *
      *           Blocked Debit/Credit.                               *
      *  260428 - For MM deals, skip validation for on receipt side / *
      *           pay side if accounting has taken place in the past  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG14913 - MT103 was not generated for Loans Input           *
      *  248393 - If settlement type is 14, allow only a 10 digit     *
      *           retail account number (ie position 11-18 of RONS or *
      *           PONS should be blank otherwise send error message). *
      *  246120 - Default settlement receipt for loan/parts purchased *
      *           and settlement payment for part sold.               *
      *  244636 - Modify check of payment settlement protection       *
      *  244370 - Default pay and receipt details during reversal of  *
      *           manual repayment.                                   *
      *  217715 - Wrong defaulting of Ordering Customer.              *
      *           Applied 215211 that is annotated as 239836.         *
      *  238721 - Do not default details of charges if both ordering  *
      *           customer and beneficiary are SWIFT fin inst.        *
      *  BUG12624 - Validation error on Pay/Rec-Our Account for       *
      *              Settlement 05.                                   *
      *  BUG12540 - fix 182652 validates regardless of Fed Funds'     *
      *             value.                                            *
      *  239587 - For MAPY, only pay or receive details necessary,    *
      *           therefore don't need to validate that pay and       *
      *           receive currencies are the same.                    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG11240 - Unable to Authorise and/or Reject newly inserted  *
      *             Manual Repayment, error msg LEM0102 displayed.    *
      *  239836 - Validation of ordering bank field should consider   *
      *           BBSWFI and not BBBNBI anymore. Apply 215211.        *
      *  CLE106 - Syndications manager.                               *
      *  CLE033 - Settlement method 09                                *
      *  CLE031 - Lending Enhancements - Settlement Currency          *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG7875 - Loan input - Settlement payment misleading error   *
      *            message.                                           *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  BUG6393- When defaulting ACSQ pass back to front end         *
      *  BUG6010 - Allow Amendment of the value date settlement if    *
      *            the loan has passed value date.  Display Warning   *
      *            message instead of an error message.               *
      *  CDL036 - Prevent Trade input if CLS SSI missing              *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4511 - Don't default Details of Charges for MT202 message *
      *           (field @OBNBI should be populated)                  *
      *  BUG4490 - Don't default Pay Ordering Customer if Pay         *
      *            Ordering Bank is entered (and vice-versa)          *
      *  BUG4478- Keep the warnings from previously called            *
      *           modules.                                            *
      *  CGL014 - Collaterals Processing                              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposit       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  207137 - Do not validate pay settlement account when pay     *
      *           side is protected as it has already valued.         *
      *  214110 - Allow 'SHA' code on details of charges field and    *
      *           ensure that allowed values are validated correctly. *
      *  CRE008 - Cash Management                                     *
      *  219241 - Defaulting of "Details of Charges" assign a         *
      *           system value                                        *
      *  CSW203 - SWIFT 2003 Standards Update                         *
      *  196461 - Validation of settlement shall not be done when     *
      *           Receipt and/or Payment are protected.               *
      *  197865 - Pay Ordering Customer cannot be blanked out.        *
      *  CSW202 - SWIFT 2002 Standards Update                         *
      *  CAP068 - Enable Lending APIs to call this instead of SD2410  *
      *  196808 - Corrected the validation of settlement currency when*
      *           calling program is DEAM.                            *
      *  194282 - ESM0918 keeps on coming out if ordering bank is not *
      *           flag as SWIFT financial institution even if method  *
      *           01 is used.                                         *
      *  200400 - Reverse fix 179510                                  *
      *  CSW201 - SWIFT 2001 Standards Update                         *
      *  193584 - When the nostro is a CLS Dummy nostro,              *
      *           entry should not be allowed in :                    *
      *           the Account detail line for fields 56 and 57.       *
      *  CUT009 - Core hooks added manually.                          *
      *  182652 - Corrected the validation of Intermediary Bank line  *
      *           and Account with bank line.                         *
      *           They do not have to be mandatory or '//FW'' if      *
      *           Fed Funds is 'Y'.                                   *
      *  CUT009 - Core hooks added manually.                          *
      *  185751 - Addition of the action code parameter.              *
      *  179510 - For Settlement method 04 , fields  xxMORI &  xxMOPI *
      *           Midas our Receive/Pay instructions  respectively  not
      *           correctly  updated .  Introduced  new  Data Structure
      *           @MORPI  which is used  for that purpose .           *
      *  CIR003 - Principal Exchange on Cross Currencies IRS          *
      *  186433 - Fix 166888 caused non-default of Ordering bank/     *
      *           customer and Beneficiary when SSIs are amended      *
      *           (after initially defaulted by system) but said      *
      *           fields have been left blank by the user             *
      *  CDL008 - Continuous Linked Settlement                        *
      *  182114 - Message 'Settlement Account is Blocked' is appearing*
      *           if either credits or debits are blocked, the type   *
      *           that is blocked may not be applicable. VLPONS should*
      *           check credits and VLRONS should check debits.       *
      *           System does not check for Blocked Retail Accounts.  *
      *  166888 - Settlement Instructions - Pay Ordering Bank returns *
      *           to defaulted value all the time. Apply GEMS 163745  *
      *           However, 163745 only fixes the problem for 'A' and  *
      *           'X' processing. Problem still exists for insert.    *
      *           Need to default only the 1st time validation is     *
      *           done. Do not re-default for subsequent validations. *
      *           Due to this 163745 in its original form is no       *
      *           longer required, now default required only for      *
      *           'first time insert'.                                *
      *  CSW200 - SWIFT 2000 Changes                                  *
      *  CSW097 - Swift 97 Changes for MT360s and MT340s              *
      *  166320 - When checking if bank/non-bank, field BBSWFI        *
      *           (SWIFT financial institution) should be checked.    *
      *  167942 - Do not default pay ordering bank to a BICN.         *
      *  164570 - Initialize FRA/IRS extended instructions if         *
      *           switchable features CSW005/CSW011 are off           *
      *  152344 - Invalid pay/receipt settlement currencies accepted  *
      *  CAP004 - API's Phase 3.                                      *
      *           Allow A/c with Bank = Beneficiary                   *
      *           Extra defaulting for telex.                         *
      *           Do not treat CIRS same as FRAs (should be similar   *
      *           to FX).                                             *
      *  CAP003 - Phase II of Midas API conversions                   *
      *  136939 - Remove back-valuation check for EMU                 *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
     FDLDLDGLE  IF   E           K DISK    INFSR(SRERR)                                       CGL014
     F                                     PREFIX(P_)                                         CGL014
     FDLGXSTL0  IF   E           K DISK    INFSR(SRERR) USROPN                                CGL014
     F                                     PREFIX(P_)                                         CGL014
     FSDCUSTL7  IF   E           K DISK    INFSR(SRERR)                                       CDL094
     F                                     PREFIX(C_)                                         CDL094
     F/COPY WNCPYSRC,ZAH00010
      /EJECT
      *****************************************************************
     C/COPY WNCPYSRC,ZASETINVF1
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
 
      **------------------------------------------------------------------------CAP003--------------
      ** The following /COPY line includes all the defined fields in the        CAP003
      ** Program Status Data Structures.  They have meaningful                  CAP003
      ** names, prefixed by 'PS'.                                               CAP003
     D/COPY ZACPYSRC,PSDS                                                       CAP003
      **------------------------------------------------------------------------CAP003--------------
                                                                                CAP003
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
                                                                                              CGL029
     D @ACCD           S             10                                                       CGL029
     D DDRONS          S             18                                                       CGL029
     D DDPONS          S             18                                                       CGL029
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D/COPY WNCPYSRC,ZASETNVD01
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      ** EXTERNAL DS FOR COUNTERPARTY NOSTRO DETAILS
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      * DATA STRUCTURE FOR CUSTOMER DETAILS
      *
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      ** EXTERNAL DS FOR NOSTRO DETAILS
      *
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D SDTRACCD      E                     EXTFLD(QQACCD)                                     CGL029
      ** EXTERNAL DS FOR TRADING DETAILS
      *
     D ACCT          E DS                  EXTNAME(ACCNTAB)
      ** EXTERNAL DS FOR ACCOUNT DETAILS
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D SDGEACCD      E                     EXTFLD(QQACCD)                                     CGL029
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
      *
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D SDREACCD      E                     EXTFLD(QQACCD)                                     CGL029
      ** EXTERNAL DS FOR RETAIL DETAILS
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D SDBRDFAC      E                     EXTFLD(QQDFAC)                                     CGL029
      ** EXTERNAL DS FOR BRANCH DETAILS
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** EXTERNAL DS FOR CURRENCY DETAILS
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** EXTERNAL DS FOR LONG DUMMY DATA STRUCTURE
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** EXTERNAL DS FOR SHORT DUMMY DATA STRUCTURE
                                                                                              219241
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)                                  219241
      ** External DS for Midas Message Management ICD                                         219241
                                                                                              CLE033
     D SDACOD        E DS                  EXTNAME(SDACODPD)                                  CLE033
     D SDACACCD      E                     EXTFLD(QQACCD)                                     CLE033
      ** External DS for Account Codes                                                        CLE033
      *
     D ##RECF        E DS                  EXTNAME(SDESFRPD)
      * FILE RECEIVE INSTRUCTIONS
      *
     D ##PAYF        E DS                  EXTNAME(SDESFPPD)
      * FILE PAYMENT INSTRUCTIONS
      *
     D ##FRIF        E DS                  EXTNAME(SDESFFPD)
      **FILE*FRA/IRS*INSTRUCTIONS**************************************                       CSW212
      * FILE EXTENDED SETTLEMENT INSTRUCTIONS                                                 CSW212
      *
     D ##RECS        E DS                  EXTNAME(SDESSRPD)
      * SCREEN RECEIVE INSTRUCTIONS
      *
     D ##PAYS        E DS                  EXTNAME(SDESSPPD)
      * SCREEN PAYMENT INSTRUCTIONS
      *
     D ##FRIS        E DS                  EXTNAME(SDESSFPD)
      **SCREEN*FRA/IRS*INSTRUCTIONS************************************                       CSW212
      * SCREEN EXTENDED SETTLEMENT INSTRUCTIONS                                               CSW212
      *
     D*@MORPI*****     DS                                                              179510 200400
      ***Midas*Our Receive / Pay  Instructions (for Sett Meth = 04 )                   179510 200400
     D**@@MORI****             1     12                                                179510 200400
     D**@@MOPI****            13     24                                                179510 200400
      ************                                                                     179510 200400
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CDL008
     D  WLCD         E                     EXTFLD(LCD)                          CDL008
      ** External DS for SAR Details                                            CDL008
      *                                                                         CDL008
     D DLUFBO        E DS                  EXTNAME(DLUFBOPD) DTAARA                           CGL014
 
      ** Array containing Copyright statement                                                 CLE033
     D SVAL            S             80    DIM(4) CTDATA PERRCD(1)                            CLE033
                                                                                              CLE033
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
                                                                                              219241
      ** flag to indicate if CFT013 is installed                                              219241
     D CFT013          S              1A                                                      219241
     D/COPY WNCPYSRC,ZAH00044
 
      * FLAGS TO INDICATE WHETHER RECEIVE INSTRUCTIONS ARE OK
     D OKReceive       DS
     D  DDRscyOK                      1A
     D  DDRstmOK                      1A
     D  DDRonxOK                      1A
     D  DDRocnOK                      1A
     D  DDRobnOK                      1A
     D  DDRibnOK                      1A
     D  DDRibaOK                      1A
     D  DDRmacOK                      1A                                                      CDL018
     D  DDRexrOK                      1A                                                      CLE031
     D  DDRexiOK                      1A                                                      CLE031
     D  DDRbb1OK                      1A                                                      CDL094
     D  DDRbb2OK                      1A                                                      CDL094
     D  DDRbb3OK                      1A                                                      CDL094
     D  DDRbb4OK                      1A                                                      CDL094
     D  DDRbb5OK                      1A                                                      CDL094
     D  DDRbb6OK                      1A                                                      CDL094
      *
      * FLAGS TO INDICATE WHETHER PAYMENT INSTRUCTIONS ARE OK
     D OKPayment       DS
     D  DDPscyOK                      1A
     D  DDPstmOK                      1A
     D  DDPonxOK                      1A
     D  DDRvnoOK                      1A
     D  DDCvmrOK                      1A
     D  DDPocnOK                      1A
     D  DDPobnOK                      1A
     D  DDRcrnOK                      1A
     D  DDRcraOK                      1A
     D  DDPibnOK                      1A
     D  DDPibaOK                      1A
     D  DDAwbnOK                      1A
     D  DDAwbaOK                      1A
     D  DDBennOK                      1A
     D  DDBenaOK                      1A
     D  DDDtp1OK                      1A
     D  DDDtp2OK                      1A
     D  DDDtp3OK                      1A
     D  DDDtp4OK                      1A
     D  DDDchgOK                      1A
     D  DDIc72OK                      1A
     D  DDBtb1OK                      1A
     D  DDBtb2OK                      1A
     D  DDBtb3OK                      1A
     D  DDBtb4OK                      1A
     D  DDBtb5OK                      1A
     D  DDBtb6OK                      1A
     D  DDPmacOK                      1A                                                      CDL018
     D  DDPexrOK                      1A                                                      CLE031
     D  DDPexiOK                      1A                                                      CLE031
      *
      **FLAGS*TO*INDICATE*WHETHER*FRA/IRS*INSTRUCTIONS*ARE*OK**********                       CSW212
      * FLAGS TO INDICATE WHETHER EXTENDED SETTLEMENT INSTRUCTIONS ARE OK                     CSW212
     D OKFRAIRS        DS
     D  DDDsr1OK                      1A
     D  DDDsr2OK                      1A
     D  DDDsr3OK                      1A
     D  DDDsr4OK                      1A
     D  DDDsr5OK                      1A
     D  DDDsr6OK                      1A
     D  DDSsr1OK                      1A
     D  DDSsr2OK                      1A
     D  DDSsr3OK                      1A
     D  DDSsr4OK                      1A
     D  DDSsr5OK                      1A
     D  DDSsr6OK                      1A
     D  DDCnd1OK                      1A
     D  DDCnd2OK                      1A
     D  DDCnd3OK                      1A
     D  DDCnd4OK                      1A
     D  DDCnd5OK                      1A
     D  DDCnd6OK                      1A
     D  DDIsdaOK                      1A
     D  DDAgtyOK                      1A
     D  DDAgdtOK                      1A
     D  DDAgvvOK                      1A
      *
     D RUNDAT          DS
     D/COPY WNCPYSRC,ZASETNVD02
      ** DATA STRUCTURE FOR MULTIBRANCH INDICATOR USING RUNDAT.
     D  @MBIN                 13     13
      *
     D/COPY WNCPYSRC,ZASETNVD04
      * OUR ACCOUNT
      *
     D                 DS
     D***A#OURA*                1     12                                                      CGL029
     D  A#OURA                 1     18                                                       CGL029
     D  A#NOST                 1      2
     D  A#CNUM                 1      6
     D  A#RENO                 1     10
     D***A#ACOD*                7     10                                                      CGL029
     D***A#ACAS*                7     12                                                      CGL029
     D***A#ACSQ*               11     12                                                      CGL029
     D***A#REST*                3     12                                                      CGL029
     D  A#ACOD                 7     16                                                       CGL029
     D  A#ACAS                 7     18                                                       CGL029
     D  A#ACSQ                17     18                                                       CGL029
     D  A#REST                 3     18                                                       CGL029
     D  A#RES2                11     18                                                       248393
      *
      * A/C LINE
      *
     D                 DS
     D  L#XIBA                 1     35
     D  L#RCR2                 1      2
     D  L#XIB1                 1      1
     D  L#XIB2                 2      2
     D  L#XIBE                 3      3
     D                 DS
      ** Data structure for use in checking whether Account With field is
      ** a Nostro Number.
     D  W#AWBN                 1     10
     D  W#AW                   1     10
     D                                     DIM(10) ASCEND
     D  W#NOST                 1      2
     D  W#REST                 3     10
      *
      * Input Parameters
      *
     D***I#PARM*         DS           512                                                     CGL029
     D I#PARM          DS           514                                                       CGL029
      * Field to be validated
     D  I#VFLD                 1      5
      * Pay/Receive Settlement (PAY/REC)
     D  I#PR                   6      8
      * Customer/Counterparty Nostro /BIC indentified type
      *    C           X              S  X-> C'party Nostro or Customer
      * Customer/Counterparty/BIC indentified
     D  I#PRTT                 9      9
     D  I#PRTY                10     20
      * Pay Currency
     D  I#PCCY                21     23
      * Receive Currency
     D  I#RCCY                24     26
      * Account Line
     D  I#ACLN                27     61
      * Account Line Character 1
     D  I#ACC1                27     27
      * Account Line Character 2
     D  I#ACC2                28     28
      * Account Line Character 3
     D  I#ACC3                29     29
      * Account Line first 4 characters
     D  I#ACCL                27     30
      * Account Line Clearing System
     D  I#ACCS                29     30
      * Account Line No account data
     D  I#SPC1                31     61
      * Message Type
     D  I#MTYP                62     64
      * Intermediary Institution for Bank to Bank validation
     D  I#INBT                65     65
     D  I#INBK                66     76
      * Account with Institution for Bank to Bank validation
     D  I#AWBT                77     77
     D  I#AWBK                78     88
      * Beneficiary for Bank to Bank validation
     D  I#BENT                89     89
     D  I#BENF                90    100
      * Pay and Receive Settlement Methods
     D  I#RSTM               101    102
     D  I#PSTM               103    104
      * Field 53 and 54 Entered
     D  I#5354               105    105
      * Midas Module
     D  I#MMOD               106    107
      * Pay and Receive Settlement Accounts
     D***I#PYAC*              108    125                                                      CGL029
     D***I#RCAC*              126    143                                                      CGL029
     D  I#PYACQQ             108    125                                                       CGL029
     D  I#RCACQQ             126    143                                                       CGL029
      * Transaction Type
     D  I#TTYP               144    145
      * Cover required
     D  I#COVR               146    146
      * Bank to Bank Information
     D  I#BTB                257    466
     D  I#BTB1               257    291
     D  I#BTB2               292    326
     D  I#BTB3               327    361
     D  I#BTB4               362    396
     D  I#BTB5               397    431
     D  I#BTB6               432    466
      *
     D  I#PYAC               467    490                                                       CGL029
     D  I#RCAC               491    514                                                       CGL029
      *
      * Output Parameters
      *
     D***O#PARM*         DS           512                                                     CGL029
     D O#PARM          DS           514                                                       CGL029
      * Account Line modified
     D  O#ACLN                 1     35
      * Bank to Bank Information
     D  O#BTB                257    466
     D  O#BTB1               257    291
     D  O#BTB2               292    326
     D  O#BTB3               327    361
     D  O#BTB4               362    396
     D  O#BTB5               397    431
     D  O#BTB6               432    466
      *
      * Error Parameters
      *
     D E#PARM          DS           256
      * Calling Program
     D  E#CPGM                 1     10
      * Error message sent
     D  E#ERRM                12     12
      * Warning message sent
     D  E#WARN                13     13
      * Error index
     D  E#INDX                14     18  0
      * Message text to prefix error message
     D  E#MSGD                19     25
     D  E#MSGF                26     35
      * Error codes array
     D  E#ERCD                51    200
     D  O#E                   51    200
     D                                     DIM(50)                              Return Error code
      *
     D                 DS
     D  W#AGDR                 1      6
     D  W#YYR                  1      2  0
     D  W#MMR                  3      4  0
     D  W#DDR                  5      6  0
     D                 DS
     D  W#AGDT                 1      6
     D  W#DD                   1      2  0
     D  W#MM                   3      4  0
     D  W#YY                   5      6  0
                                                                                              CSW203
      ** Flag to indicate if CSW203 is installed                                              CSW203
     D CSW203          S              1                                                       CSW203
     D PRTCD           S              7                                                       CSW203
                                                                                              CSW203
                                                                                              CRE008
     D CRE008          S              1                                                       CRE008
                                                                                              CRE008
      ** Parameters for RE101901                                                              CRE008
     D PRetCode        S              7                                                       CRE008
     D PInBranch       S              3                                                       CRE008
     D*PInCust**       S              6  0                                             CRE008 CSD027
     D PInCust         S              6                                                       CSD027
     D PInCurr         S              3                                                       CRE008
     D***PInACode        S              4  0                                           CRE008 CGL029
     D PInACode        S             10  0                                                    CGL029
     D PInASeqN        S              2  0                                                    CRE008
     D PDebAmnt        S             15  0                                                    CRE008
     D POutBranch      S              3                                                       CRE008
     D*POutCust*       S              6  0                                             CRE008 CSD027
     D POutCust        S              6                                                       CSD027
     D POutCurr        S              3                                                       CRE008
     D***POutACode       S              4  0                                           CRE008 CGL029
     D POutACode       S             10  0                                                    CGL029
     D POutASeqN       S              2  0                                                    CRE008
     D POutRetNo       S             10  0                                                    CRE008
                                                                                              CRE008
     D WFldNameArr     S             10    DIM(75)                                            CRE008
     D*WkCust***       S              6  0                                             CRE008 CSD027
     D WkCust          S              6                                                       CSD027
     D WkCcy           S              3                                                       CRE008
     D***WkACOD*         S              4  0                                           CRE008 CGL029
     D WkACOD          S             10  0                                                    CGL029
     D WkASEQ          S              2  0                                                    CRE008
     D WkBRCA          S              3                                                       CRE008
     D WkCustA         S              6                                                       CRE008
     D***WkACodeA        S              4                                              CRE008 CGL029
     D WkACodeA        S             10                                                       CGL029
     D WkASeqNA        S              2                                                       CRE008
     D WkRetNoA        S             10                                                       CRE008
     D WIdx            S              3  0                                                    CRE008
                                                                                              CGL014
     D PAmount         S             15  0                                                    CGL014
     D PTCCY           S              3                                                       CGL014
     D PBranch         S              3                                                       CGL014
     D PCustNo         S              6                                                       CGL014
     D PCurr           S              3                                                       CGL014
     D PActCode        S             10                                                       CGL014
     D PAcSeq          S              2                                                       CGL014
     D PRetail         S             10  0                                                    CGL014
     D WRcCust         S              6                                                       CGL014
     D WRcCcy          S              3                                                       CGL014
     D WRcACOD         S             10                                                       CGL014
     D WRcASEQ         S              2                                                       CGL014
     D WRcBRCA         S              3                                                       CGL014
     D WRcRetail       S             10  0                                                    CGL014
     D WPyCust         S              6                                                       CGL014
     D WPyCcy          S              3                                                       CGL014
     D WPyACOD         S             10                                                       CGL014
     D WPyASEQ         S              2                                                       CGL014
     D WPyBRCA         S              3                                                       CGL014
     D WPyRetail       S             10  0                                                    CGL014
     D CGL014          S              1                                                       CGL014
     D WPRInd          S              1                                                       CGL014
     D WDiff           S             13  0                                                    CGL014
     D WCurAmt         S             13  0                                                    CGL014
     D WPrvAmt         S             13  0                                                    CGL014
     D KDLNO           S              6  0                                                    CGL014
     D KEDCD           S              3                                                       CGL014
     D SETTF           S              1    INZ('N')                                          CSF011A
     D W@TYPE          S              4    INZ(*BLANKS)                                      CSF011A
                                                                                             CSF011A
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D   MsgDtaTmp                   99                                                     MD000091
                                                                                              CGL014
      ** Flag to indicate if CMG003 is installed                                              CMG003
     D CMG003          S              1A                                                      CMG003
                                                                                              CMG003
      ** Workfields for CMG003                                                                CMG003
     D WPayPMRT        S                   LIKE(A6PMRT)                                       CMG003
     D WRecPMRT        S                   LIKE(A6PMRT)                                       CMG003
                                                                                              CMG003
     D CSW214          S              1A                                                      CSW214
     D/COPY WNCPYSRC,ZASETNVD03
      /EJECT
     C*******************************************************************
     C*  MAIN PROCESSING
     C*******************************************************************
      *
      ** INITIAL PROCESSING
      *
     C                   EXSR      SRINIT
      *
      ** DO RECEIVE SIDE DEFAULTING FOR SETTLEMENT METHOD 01, 07, 08
      *
     C     DDRSTM        IFEQ      '01'
     C     ##ACCD        ANDEQ     'I'                                                        166888
     C     ##ValIter     ANDEQ     '1ST'                                                      166888
     C     DDRSTM        OREQ      '01'                                                       186433
     C     ##ACCD        ANDEQ     'A'                                                        186433
     C     ##ValIter     ANDEQ     '1ST'                                                      186433
     C     ##PREC        ANDNE     'Y'                                                      MD039348
     C     DDRSTM        OREQ      '07'
     C     ##ACCD        ANDEQ     'I'                                                        166888
     C     ##ValIter     ANDEQ     '1ST'                                                      166888
     C     DDRSTM        OREQ      '07'                                                       186433
     C     ##ACCD        ANDEQ     'A'                                                        186433
     C     ##ValIter     ANDEQ     '1ST'                                                      186433
     C     ##PREC        ANDNE     'Y'                                                      MD039348
     C     DDRSTM        OREQ      '08'
     C     ##ACCD        ANDEQ     'I'                                                        166888
     C     ##ValIter     ANDEQ     '1ST'                                                      166888
     C     DDRSTM        OREQ      '08'                                                       186433
     C     ##ACCD        ANDEQ     'A'                                                        186433
     C     ##ValIter     ANDEQ     '1ST'                                                      186433
     C     ##PREC        ANDNE     'Y'                                                      MD039348
     C                   EXSR      DEFREC
     C                   END
      *
      ** DO PAYMENT SIDE DEFAULTING FOR SETTLEMENT METHOD 01, 07, 08
      *
     C     DDPSTM        IFEQ      '01'
     C     ##ACCD        ANDEQ     'I'                                                        166888
     C     ##ValIter     ANDEQ     '1ST'                                                      166888
     C     DDPSTM        OREQ      '01'                                                       186433
     C     ##ACCD        ANDEQ     'A'                                                        186433
     C     ##ValIter     ANDEQ     '1ST'                                                      186433
     C     ##PPAY        ANDNE     'Y'                                                      MD039348
     C     DDPSTM        OREQ      '07'
     C     ##ACCD        ANDEQ     'I'                                                        166888
     C     ##ValIter     ANDEQ     '1ST'                                                      166888
     C     DDPSTM        OREQ      '07'                                                       186433
     C     ##ACCD        ANDEQ     'A'                                                        186433
     C     ##ValIter     ANDEQ     '1ST'                                                      186433
     C     ##PPAY        ANDNE     'Y'                                                      MD039348
     C     DDPSTM        OREQ      '08'
     C     ##ACCD        ANDEQ     'I'                                                        166888
     C     ##ValIter     ANDEQ     '1ST'                                                      166888
     C     DDPSTM        OREQ      '08'                                                       186433
     C     ##ACCD        ANDEQ     'A'                                                        186433
     C     ##ValIter     ANDEQ     '1ST'                                                      186433
     C     ##PPAY        ANDNE     'Y'                                                      MD039348
     C                   EXSR      DEFPAY
     C                   END
      *
      ** Display error message if this is a CLS (FX) transaction and                          CDL036
      ** no default settlement instructions have been setup for                               CDL036
      ** receipts and/or payments side                                                        CDL036
      *                                                                                       CDL036
     C     CDL036        IFEQ      'Y'                                                        CDL036
     C     CDL008        ANDEQ     'Y'                                                        CDL036
     C     ##CALP        ANDEQ     'FXDL'                                                     CDL036
     C     ##TTYP        ANDEQ     'CL'                                                       CDL036
     C     ##ACCD        ANDEQ     'I'                                                        CDL036
      *                                                                                       CDL036
     C     DDPSTM        IFEQ      '00'                                                       CDL036
     C     DDPSTM        OREQ      '  '                                                       CDL094
     C                   ADD       1             Idx                                          CDL036
     C                   EVAL      FldNameArr(Idx) = 'DDPSTM'                                 CDL036
     C                   EVAL      MsgIDArr(Idx) = 'ESM0307'                                  CDL036
     C                   MOVE      'N'           DDPstmOK                                     CDL036
     C                   ENDIF                                                                CDL036
      *                                                                                       CDL036
     C     DDRSTM        IFEQ      '00'                                                       CDL036
     C     DDRSTM        OREQ      '  '                                                       CDL094
     C                   ADD       1             Idx                                          CDL036
     C                   EVAL      FldNameArr(Idx) = 'DDRSTM'                                 CDL036
     C                   EVAL      MsgIDArr(Idx) = 'ESM0307'                                  CDL036
     C                   MOVE      'N'           DDRstmOK                                     CDL036
     C                   ENDIF                                                                CDL036
      *                                                                                       CDL036
     C                   ENDIF                                                                CDL036
                                                                                            AR863960
     C                   MOVEL     ##CALP        ##CALP2           4                        AR863960
                                                                                            AR863960
      ** 'LERI' calling function must be reset to 'LEND' to process                         AR863960
      ** all its validation                                                                 AR863960
                                                                                            AR863960
     C                   IF        ##CALP2 = 'LERI'                                         AR863960
     C                   EVAL      ##CALP = 'LEND'                                          AR863960
     C                   ENDIF                                                              AR863960
      *                                                                                       CDL036
      * RECEIPT INSTRUCTIONS
      *
     C                   IF        ##ACTN <> 'R'                                             BUG6010
     C                             OR ##ACTN = 'R' AND ##CALP = 'LEND'                       BUG6010
     C                             AND ##PREC <> 'Y'                                          244370
     C**********                   AND ##PREC = 'N'                                   BUG6010 244370
     C                             OR ##ACTN = 'R' AND ##CALP = 'MAPY'                        239587
     C**********                   AND ##PREC = 'N'                                  239587 AR853046
     C                             AND ##PREC <> 'Y'                                        AR853046
     C                   EXSR      RECEIP
     C                   ENDIF                                                               BUG6010
      *
      * PAYMENT INSTRUCTIONS
      *
     C**********         IF        ##ACTN <> 'R'                                      BUG6010 244636
     C**********                   OR ##ACTN = 'R' AND ##CALP = 'LEND'                BUG6010 244636
     C**********                   AND ##PPAY = 'N'                                   BUG6010 244636
     C**********         IF        (##ACTN <> 'R'                                    244636 BUG14913
     C                   IF        (##ACTN = 'I' OR ##ACTN = 'A'                            BUG14913
     C                             OR (##ACTN = 'R' AND ##CALP = 'LEND'))                     244636
     C                             AND ##PPAY <> 'Y'                                          244636
     C                             OR ##ACTN = 'X' AND ##PPAY = 'Y'                         BUG14913
     C                             OR ##ACTN = 'R' AND ##CALP = 'MAPY'                        239587
     C**********                   AND ##PPAY = 'N'                                  239587 AR853046
     C                             AND ##PPAY <> 'Y'                                        AR853046
     C                             OR ##ACTN = 'X' AND ##CALP = 'MAPY'                      MD020242
     C                             AND ##PPAY = ' ' AND ##PREC = 'Y'                        MD020242
     C                             OR ##ACTN <> 'R' AND ##CALP = 'LDNI'                       260428
     C                             OR ((##ACTN <> 'R' AND ##CALP2 = 'LERI')                 AR863960
     C                             OR ((##ACTN = 'R' AND ##CALP2 = 'LERI' )                 AR863960
     C                             AND ##PPAY <> 'Y'))                                      AR863960
     C                   EXSR      PAYMNT
     C/COPY WNCPYSRC,ZASETNVC36
     C                   ENDIF                                                               BUG6010
                                                                                              CGL014
      ** Check for Blocked Amount                                                             CGL014
                                                                                              CGL014
     C                   IF        CGL014 = 'Y' AND (##CALP = 'SIRS' OR                       CGL014
     C                             ##CALP = 'CXSV' OR ##CALP = 'CXSM') AND                    CGL014
     C                             (FLRSTM = 04 OR FLRSTM = 14) AND                           CGL014
     C                             (DDRONXOK <> 'N' OR DDPONXOK <> 'N')                       CGL014
     C                   EXSR      SRBlockAmt                                                 CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C/COPY WNCPYSRC,ZASETNVC28
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C     ##CALP        ANDEQ     'LEND'                                                     CLE031
     C                   ELSE                                                                 CLE031
      *
      * CROSS VALIDATE RECEIVE AND PAYMENT SETTLEMENT CURRENCY
      * IF NOT FX TYPE TRANSACTION
      *
     C     DDRscyOK      IFNE      'N'
     C     DDPscyOK      ANDNE     'N'
     C     ##CALP        ANDNE     'FXDL'
     C     ##CALP        ANDNE     'CIRS'
     C     ##CALP        ANDNE     'CXSV'                                                     CIR003
     C     ##CALP        ANDNE     'CXSM'                                                     CIR003
     C     ##ACTN        ANDNE     'R'                                                       BUG6010
     C                   EXSR      XVRPSETC
     C                   END
     C                   ENDIF                                                                CLE031
      *
      **FRA/IRS*SETTLEMENT*INSTRUCTIONS********************************                       CSW212
      * EXTENDED SETTLEMENT INSTRUCTIONS                                                      CSW212
      *
     C     ##CALP        IFEQ      'FRA '                                       164570
     C     ##CALP        OREQ      'SIRS'                                       164570
     C     ##CALP        OREQ      'CIRS'                                       164570
     C     ##CALP        OREQ      'SSI '                                       164570
     C     ##CALP        OREQ      'FXDL'                                                     CSW212
     C     CSW212        ANDEQ     'Y'                                                        CSW212
     C                   CLEAR                   ##FRIF                         164570
     C                   MOVE      '0000'        FLISDA                         164570
     C                   MOVE      '000000'      FLAGDT                         164570
     C                   MOVE      '00'          FLAGVV                         164570
     C                   MOVE      '00'          FLAGVC                         CSW097
     C     CSW005        IFEQ      'Y'                                          164570
     C     CSW011        OREQ      'Y'                                          164570
     C     ##CALP        ANDEQ     'FRA '                                       164570
     C     ##CALP        OREQ      'FXDL'                                                     CSW212
     C     CSW212        ANDEQ     'Y'                                                        CSW212
     C                   EXSR      VLFRIR                                       164570
     C                   END                                                    164570
     C                   END                                                    164570
     C/COPY WNCPYSRC,ZASETNVC29
                                                                                164570
     C*****CSW005********IFEQ      'Y'                                          164570
     C*****##CALP        ANDEQ     'FRAS'                                       CAP003
     C*****##CALP********ANDEQ     'FRAS'                                CAP003 164570
     C*****CSW005********OREQ      'Y'                                          164570
     C*****##CALP********ANDEQ     'SSI '                                       164570
     C*****CSW005********OREQ      'Y'                                   CAP004 164570
     C*****##CALP********ANDEQ     'CIRS'                                CAP004 164570
     C*****CSW011********OREQ      'Y'                                          164570
     C*****##CALP********ANDEQ     'FRAS'                                CAP003 164570
     C*****##CALP********ANDEQ     'FRA '                                CAP003 164570
     C*****CSW011********OREQ      'Y'                                          164570
     C*****##CALP********ANDEQ     'SSI '                                       164570
     C*****CSW011********OREQ      'Y'                                   CAP004 164570
     C*****##CALP********ANDEQ     'CIRS'                                CAP004 164570
     C*******************EXSR      VLFRIR                                       164570
     C*******************END                                                    164570
      *
      * RETURN
      *
     C                   RETURN
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* RECEIP - VALIDATE RECEIPT INSTRUCTIONS                        *
     C*                                                               *
     C*****************************************************************
     C     RECEIP        BEGSR
      *
      ** CLEAR OUTPUT RECEIVE FIELDS
      *
     C                   CLEAR                   ##RECF
      *
      ** RECEIVE SETTLEMENT FIELDS
      ** -------------------------
      *
     C     ##PREC        IFNE      'Y'                                                      AR641619
     C                   EXSR      VLRSFD
     C                   ENDIF                                                              AR641619
      *
      ** RECEIVE SETTLEMENT CURRENCY
      ** ---------------------------
      *
     C     DDRSCY        IFNE      *BLANKS
     C     ##PREC        ANDNE     'Y'                                                      AR641619
     C                   EXSR      VLRSCY
     C                   MOVE      DDRSCY        E#RCCY
     C                   ENDIF
     C                   MOVE      DDRSCY        FLRSCY
      *                                                                                       CDL018
      ** RECEIVE MORE ACCOUNT                                                                 CDL018
      ** --------------------                                                                 CDL018
      *                                                                                       CDL018
     C     CDL018        IFEQ      'Y'                                                        CDL018
     C                   EXSR      VLRMAC                                                     CDL018
     C                   MOVE      DDRMAC        FLRMAC                                       CDL018
     C                   ENDIF                                                                CDL018
      *                                                                                       CLE031
      ** RECEIVE EXCHANGE RATE AND INDICATOR                                                  CLE031
      ** -----------------------------------                                                  CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C     ##CALP        ANDEQ     'LEND'                                                     CLE031
     C     CLE031        OREQ      'Y'                                                      AR853046
     C     ##CALP        ANDEQ     'MAPY'                                                   AR853046
     C                   EXSR      VLREXR                                                     CLE031
     C                   ENDIF                                                                CLE031
      *
      ** RECEIVE SETTLEMENT METHOD
      ** -------------------------
      *
     C     ##PREC        IFNE      'Y'                                                      AR641619
     C                   EXSR      VLRSTM
     C                   ENDIF                                                              AR641619
     C                   MOVE      DDRSTM        FLRSTM
      **
      ** RECEIVE SETTLEMENT BRANCH
      ** -------------------------
      ** (Only validate Branch in multi-branching environment.)
      *
     C     @MBIN         IFEQ      'Y'
     C     CLE033        OREQ      'Y'                                                        CLE033
     C     FLRSTM        ANDEQ     09                                                         CLE033
     C     ##PREC        IFNE      'Y'                                                      AR641619
     C                   EXSR      VLROBR
     C                   ENDIF                                                              AR641619
     C                   END
     C                   MOVE      DDROBR        FLROBR                                     AR641619
      *
      ** OUR RECEIVE NOSTRO
      ** ------------------
     C/COPY WNCPYSRC,ZASETINV11                                                               CUT009
      *
     C**********         MOVEL     *BLANKS       WARN_RFLAG        1              AR1096686 MD021526
     C     ##PREC        IFNE      'Y'                                                      AR641619
     C                   EXSR      VLRONS
     C                   ENDIF                                                              AR641619
     C                   MOVEL     DDRONS        FLRONS
     C/COPY WNCPYSRC,ZASETINV12                                                               CUT009
      ************                                                                     179510 200400
      **For*Settlement*method*04*,*move*the*required*data*into*the*work*****           179510 200400
      **fields**,*and*then**into*the**correspondent**DataStructure*.********           179510 200400
      ************                                                                     179510 200400
     C*****DDRSTM*       IFEQ      '04'                                                179510 200400
     C************       MOVEL     ##CSNM        WMORIF           10                   179510 200400
     C************       MOVE      BMACCD        WMORIF                                179510 200400
     C************       MOVEL     WMORIF        WFMORI           12                   179510 200400
     C************       MOVE      '01'          WFMORI                                179510 200400
     C************       MOVE      WFMORI        @@MORI                                179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
      *                                                                                       179510
      *                                                                                       CLE033
      ** No need to validate swift fields if Swift for Lending is not                         CLE033
      ** on and settlement method is 09                                                       CLE033
      *                                                                                       CLE033
     C     CLE033        IFNE      'Y'                                                        CLE033
     C     FLRSTM        ORNE      09                                                         CLE033
     C     BGSWCL        OREQ      'Y'                                                        CLE033
      *
      ** RECEIVE ORDERING CUSTOMER
      ** -------------------------
      *
     C     DDRocnOK      IFNE      'N'
     C     DDROCN        ANDNE     *BLANKS
     C                   EXSR      VLROCN
     C                   END
      *
      ** RECEIVE ORDERING BANK
      ** ---------------------
      *
     C     DDRobnOK      IFNE      'N'
     C     DDROBN        ANDNE     *BLANKS
     C                   EXSR      VLROBN
     C                   END
      *
      ** RECEIVE ORDERING CUSTOMER & BANK
      ** --------------------------------
      *
     C     ##PREC        IFNE      'Y'                                                      AR641619
     C                   EXSR      VLROCB
     C                   ENDIF                                                              AR641619
      *
      ** RECEIVE INTERMEDIARY BANK
      ** -------------------------
      *
      * If CDL094 is On, check if an Intermediary has been defined for                        CDL094
      * the receive nostro and if so default the details defined                              CDL094
     C     CDL094        IFEQ      'Y'                                                        CDL094
     C                   IF        (##CALP = 'FXDL' or ##CALP = 'LDNI'                        CDL094
     C                             or ##CALP = 'DEAM')                                        CDL094
     C                             AND (DDRSTM = '01' or DDRSTM = '07'                        CDL094
     C                             or DDRSTM = '08')                                          CDL094
     C                             AND DDRonxOK = 'Y'                                         CDL094
     C                             AND DDRIBN = *BLANKS                                       CDL094
     C                   IF        A7RF56 <> *BLANKS                                          CDL094
      *                                                                                       CDL094
      * If entry is a SWIFT BIC, retreive the customer number and use                         CDL094
     C                   MOVEL     A7RF56        WBIC             12                          CDL094
     C     WBIC          CHAIN     SDCUSTL7                                                   CDL094
     C                   IF        %FOUND(SDCUSTL7)                                           CDL094
     C                   MOVEL     C_BBCUST      DDRIBN                                       CDL094
     C                   ELSE                                                                 CDL094
     C                   MOVEL     A7RF56        DDRIBN                                       CDL094
     C                   ENDIF                                                                CDL094
     C                   MOVEL     A7RA56        DDRIBA                                       CDL094
     C                   ENDIF                                                                CDL094
     C                   ENDIF                                                                CDL094
     C                   ENDIF                                                                CDL094
      *                                                                                       CDL094
     C     DDRibnOK      IFNE      'N'
     C     DDRIBN        ANDNE     *BLANKS
     C                   EXSR      VLRIBN
     C                   END
      *
      ** RECEIVE INTERMEDIARY BANK A/C LINE
      ** ----------------------------------
      *
     C     DDRibaOK      IFNE      'N'
     C     DDRIBA        ANDNE     *BLANKS
     C     ##PREC        ANDNE     'Y'                                                      AR641619
     C                   EXSR      VLRIBA
     C                   END
     C                   MOVE      DDRIBA        FLRIBA                                     AR641619
      *                                                                                       CLE033
      ** RECEIVE BANK TO BANK INFORMATION                                                     CDL094
      ** ------------------------                                                             CDL094
     C                   IF        CDL094 = 'Y'                                               CDL094
     C                   EXSR      VLRBTBI                                                    CDL094
     C                   ENDIF                                                                CDL094
      *                                                                                       CDL094
     C                   ELSE                                                                 CLE033
     C                   MOVEL     DDROCN        FLROCN                                       CLE033
     C                   MOVEL     DDROBN        FLROBN                                       CLE033
     C                   MOVEL     DDRIBN        FLRIBN                                       CLE033
     C                   MOVE      DDRIBA        FLRIBA                                       CLE033
     C                   MOVEL     DDRBB1        FLRBB1                                       CDL094
     C                   MOVEL     DDRBB2        FLRBB2                                       CDL094
     C                   MOVEL     DDRBB3        FLRBB3                                       CDL094
     C                   MOVEL     DDRBB4        FLRBB4                                       CDL094
     C                   MOVEL     DDRBB5        FLRBB5                                       CDL094
     C                   MOVEL     DDRBB6        FLRBB6                                       CDL094
     C                   ENDIF                                                                CLE033
                                                                                              CRE008
      ** Do an Overdraft Limit check                                                          CRE008
                                                                                              CRE008
     C                   IF        CRE008 = 'Y'                                               CRE008
     C                   EXSR      SROvrChk                                                   CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CGL014
      ** Save Receive Settlement Instructions                                                 CGL014
                                                                                              CGL014
     C                   IF        CGL014 = 'Y'                                               CGL014
     C                   EVAL      WRcBRCA= WkBRCA                                            CGL014
     C                   EVAL      WRcCcy  = WkCcy                                            CGL014
     C                   MOVE      WkCust        WRcCust                                      CGL014
     C                   MOVE      WkACOD        WRcACOD                                      CGL014
     C                   MOVE      WkASEQ        WRcASEQ                                      CGL014
     C                   ENDIF                                                                CGL014
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* PAYMNT - VALIDATE PAYMENT INSTRUCTIONS                        *
     C*                                                               *
     C*****************************************************************
     C     PAYMNT        BEGSR
      *
      ** CLEAR OUTPUT PAYMENT FIELDS
      *
     C                   CLEAR                   ##PAYF
      *
      ** PAYMENT SETTLEMENT FIELDS
      ** -------------------------
      *
     C     ##PPAY        IFNE      'Y'                                                      AR641619
     C                   EXSR      VLPSFD
     C                   ENDIF                                                              AR641619
      *
      ** RECIPIENT OF MT100
      ** ------------------
     C/COPY WNCPYSRC,ZASETINV13                                                               CUT009
      *
     C     DDRvnoOK      IFNE      'N'
     C                   EXSR      VLRVNO
     C                   END
     C/COPY WNCPYSRC,ZASETINV14                                                               CUT009
      *
      ** PAYMENT SETTLEMENT CURRENCY
      ** ---------------------------
     C/COPY WNCPYSRC,ZASETINV15                                                               CUT009
      *
     C     DDPSCY        IFNE      *BLANKS
     C     ##PPAY        ANDNE     'Y'                                                      AR641619
     C                   EXSR      VLPSCY
     C                   MOVE      DDPSCY        E#PCCY
     C                   ENDIF
     C                   MOVE      DDPSCY        FLPSCY
     C/COPY WNCPYSRC,ZASETINV16                                                               CUT009
      *                                                                                       CDL018
      ** PAY MORE ACCOUNT                                                                     CDL018
      ** ----------------                                                                     CDL018
      *                                                                                       CDL018
     C     CDL018        IFEQ      'Y'                                                        CDL018
     C                   EXSR      VLPMAC                                                     CDL018
     C                   MOVE      DDPMAC        FLPMAC                                       CDL018
     C                   ENDIF                                                                CDL018
      *                                                                                       CLE031
      ** PAYMENT EXCHANGE RATE AND INDICATOR                                                  CLE031
      ** -----------------------------------                                                  CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C     ##CALP        ANDEQ     'LEND'                                                     CLE031
     C     CLE031        OREQ      'Y'                                                      AR853046
     C     ##CALP        ANDEQ     'MAPY'                                                   AR853046
     C                   EXSR      VLPEXR                                                     CLE031
     C                   ENDIF                                                                CLE031
      *
      ** PAYMENT SETTLEMENT METHOD
      ** -------------------------
      *
     C     ##PPAY        IFNE      'Y'                                                      AR641619
     C                   EXSR      VLPSTM
     C                   ENDIF                                                              AR641619
     C                   MOVE      DDPSTM        FLPSTM
     C/COPY WNCPYSRC,ZASETINVC1
      **
      ** PAYMENT SETTLEMENT BRANCH
      ** -------------------------
      ** (Only validate Branch in multi-branching environment.)
      *
     C     @MBIN         IFEQ      'Y'
     C     CLE033        OREQ      'Y'                                                        CLE033
     C     FLPSTM        ANDEQ     09                                                         CLE033
     C     ##PPAY        IFNE      'Y'                                                      AR641619
     C                   EXSR      VLPOBR
     C                   ENDIF                                                              AR641619
     C                   END
     C                   MOVE      DDPOBR        FLPOBR                                     AR641619
      *
      ** OUR PAYMENT NOSTRO
      ** ------------------
     C/COPY WNCPYSRC,ZASETINV09                                                               CUT009
      *
     C**********         MOVEL     *BLANKS       WARN_PFLAG        1              AR1096686 MD021526
     C     ##PPAY        IFNE      'Y'                                                      AR641619
     C                   EXSR      VLPONS
     C                   ENDIF                                                              AR641619
     C                   MOVEL     DDPONS        FLPONS
                                                                                              CGL014
      ** Save Pay Settlement Instructions                                                     CGL014
                                                                                              CGL014
     C                   IF        CGL014 = 'Y'                                               CGL014
     C                   EVAL      WPyBRCA= WkBRCA                                            CGL014
     C                   EVAL      WPyCcy  = WkCcy                                            CGL014
     C                   MOVE      WkCust        WPyCust                                      CGL014
     C                   MOVE      WkACOD        WPyACOD                                      CGL014
     C                   MOVE      WkASEQ        WPyASEQ                                      CGL014
     C                   ENDIF                                                                CGL014
     C/COPY WNCPYSRC,ZASETINV10                                                               CUT009
      ************                                                                     179510 200400
      ************                                                                     179510 200400
      **For*Settlement*method*04*,*move*the*required*data*into*the*work***             179510 200400
      **fields**,*and*then**into*the**correspondent**DataStructure*.******             179510 200400
      ************                                                                     179510 200400
     C*****DDPSTM*       IFEQ      '04'                                                179510 200400
     C************       MOVEL     ##CSNM        WMOPIF           10                   179510 200400
     C************       MOVE      BMACCD        WMOPIF                                179510 200400
     C************       MOVEL     WMOPIF        WFMOPI           12                   179510 200400
     C************       MOVE      '01'          WFMOPI                                179510 200400
     C************       MOVE      WFMOPI        @@MOPI                                179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
      ************                                                                     179510 200400
      *                                                                                       CLE033
      ** No need to validate swift fields if Swift for Lending is not                         CLE033
      ** on and settlement method is 09                                                       CLE033
      *                                                                                       CLE033
     C     CLE033        IFNE      'Y'                                                        CLE033
     C     FLPSTM        ORNE      09                                                         CLE033
     C     BGSWCL        OREQ      'Y'                                                        CLE033
      *
      ** PAYMENT ORDERING CUSTOMER
      ** -------------------------
      *
     C     DDPocnOK      IFNE      'N'
     C     DDPOCN        ANDNE     *BLANKS
     C                   EXSR      VLPOCN
     C                   END
      *
      ** PAYMENT ORDERING BANK
      ** ---------------------
      *
     C     DDPobnOK      IFNE      'N'
     C     DDPOBN        ANDNE     *BLANKS
     C                   EXSR      VLPOBN
     C                   END
      *
      ** PAYMENT ORDERING CUSTOMER & BANK
      ** --------------------------------
      *
     C     ##PPAY        IFNE      'Y'                                                      AR641619
     C                   EXSR      VLPOCB
     C                   ENDIF                                                              AR641619
      *
      ** RECEIVER'S CORRESPONDANT
      ** ------------------------
      *
     C/COPY WNCPYSRC,ZAH00004
     C     DDRcrnOK      IFNE      'N'
     C     DDRCRN        ANDNE     *BLANKS
     C/COPY WNCPYSRC,ZAH00016
     C                   EXSR      VLRCRN
     C                   END
      *
      ** RECEIVER'S CORRESPONDENT A/C LINE
      ** ---------------------------------
      *
     C     DDRcraOK      IFNE      'N'
     C     DDRCRA        ANDNE     *BLANKS
     C     ##PPAY        ANDNE     'Y'                                                      AR641619
     C                   EXSR      VLRCRA
     C                   END
     C                   MOVEL     DDRCRA        FLRCRA                                     AR641619
      *
      ** PAYMENT INTERMEDIARY BANK
      ** -------------------------
      *
     C     DDPibnOK      IFNE      'N'
     C     DDPIBN        ANDNE     *BLANKS
     C                   EXSR      VLPIBN
     C                   END
      *
      ** PAYMENT INTERMEDIARY BANK A/C LINE
      ** ----------------------------------
      *
     C     DDPibaOK      IFNE      'N'
     C     DDPIBA        ANDNE     *BLANKS
     C     ##PPAY        ANDNE     'Y'                                                      AR641619
     C                   EXSR      VLPIBA
     C                   END
     C                   MOVEL     DDPIBA        FLPIBA                                     AR641619
      *
      ** PAYMENT ACCOUNT WITH BANK
      ** -------------------------
     C/COPY WNCPYSRC,ZASETNVC06
      *
     C     DDAwbnOK      IFNE      'N'
     C     DDAWBN        ANDNE     *BLANKS
     C                   EXSR      VLAWBN
     C                   END
      *
      ** PAYMENT ACCOUNT WITH BANK A/C LINE
      ** ----------------------------------
     C/COPY WNCPYSRC,ZASETNVC07
      *
     C     DDAwbaOK      IFNE      'N'
     C     DDAWBA        ANDNE     *BLANKS
     C     ##PPAY        ANDNE     'Y'                                                      AR641619
     C                   EXSR      VLAWBA
     C                   END
     C                   MOVEL     DDAWBA        FLAWBA                                     AR641619
      *
      ** BENEFICIARY
      ** -----------
     C/COPY WNCPYSRC,ZASETNVC08
      *
     C     DDBennOK      IFNE      'N'
     C     DDPSTM        IFEQ      '01'
     C     DDPSTM        OREQ      '07'
     C     DDPSTM        OREQ      '08'
     C     DDPSTM        OREQ      '09'                                                       CLE033
     C     CLE033        ANDEQ     'Y'                                                        CLE033
     C/COPY WNCPYSRC,ZASETNVC04
     C                   EXSR      VLBENN
     C                   END
     C                   END
      *
      ** BENEFICIARY A/C WITH LINE
      ** --------------------------
      *
     C     DDBenaOK      IFNE      'N'
     C     DDBENA        ANDNE     *BLANKS
     C     ##PPAY        ANDNE     'Y'                                                      AR641619
     C                   EXSR      VLBENA
     C                   END
     C                   MOVEL     DDBENA        FLBENA                                     AR641619
      *
      ** NUMEROUS PAYMENT FIELDS
      ** -----------------------
      *
     C     ##PPAY        IFNE      'Y'                                                      AR641619
     C                   EXSR      VLPNFD
     C                   ENDIF                                                              AR641619
      *
      ** DETAILS OF PAYMENT
      ** ------------------
     C/COPY WNCPYSRC,ZASETINV01                                                               CUT009
      *
     C                   EXSR      VLDTPI
      *
     C/COPY WNCPYSRC,ZASETINV02                                                               CUT009
      ** DETAILS OF CHARGES
      ** ------------------
      *
     C     ##PPAY        IFNE      'Y'                                                      AR641619
     C                   EXSR      VLDCHG
     C                   ENDIF                                                              AR641619
     C                   MOVEL     DDDCHG        FLDCHG                                     AR641619
      *
      ** INCLUDE 'IN' CCY IN FIELD 72
      ** ----------------------------
      *
     C     DDIC72        IFNE      *BLANKS
     C     ##PPAY        ANDNE     'Y'                                                      AR641619
     C                   EXSR      VLIC72
     C                   ENDIF
     C                   MOVEL     DDIC72        FLIC72
      *
      ** BANK TO BANK INFORMATION
      ** ------------------------
      *
     C/COPY WNCPYSRC,ZASETNVC25
     C                   EXSR      VLBTBI
     C/COPY WNCPYSRC,ZASETNVC26
     C*                                                                                       CLE033
     C                   ELSE                                                                 CLE033
     C                   MOVEL     DDPOCN        FLPOCN                                       CLE033
     C                   MOVEL     DDPOBN        FLPOBN                                       CLE033
     C                   MOVEL     DDRCRN        FLRCRN                                       CLE033
     C                   MOVEL     DDRCRA        FLRCRA                                       CLE033
     C                   MOVEL     DDPIBN        FLPIBN                                       CLE033
     C                   MOVE      DDPIBA        FLPIBA                                       CLE033
     C                   MOVEL     DDAWBN        FLAWBN                                       CLE033
     C                   MOVEL     DDAWBA        FLAWBA                                       CLE033
     C                   MOVEL     DDBENN        FLBENN                                       CLE033
     C                   MOVEL     DDBENA        FLBENA                                       CLE033
     C                   MOVEL     DDDTP1        FLDTP1                                       CLE033
     C                   MOVEL     DDDTP2        FLDTP2                                       CLE033
     C                   MOVEL     DDDTP3        FLDTP3                                       CLE033
     C                   MOVEL     DDDTP4        FLDTP4                                       CLE033
     C                   MOVEL     DDDCHG        FLDCHG                                       CLE033
     C                   MOVEL     DDIC72        FLIC72                                       CLE033
     C                   MOVEL     DDBTB1        FLBTB1                                       CLE033
     C                   MOVEL     DDBTB2        FLBTB2                                       CLE033
     C                   MOVEL     DDBTB3        FLBTB3                                       CLE033
     C                   MOVEL     DDBTB4        FLBTB4                                       CLE033
     C                   MOVEL     DDBTB5        FLBTB5                                       CLE033
     C                   MOVEL     DDBTB6        FLBTB6                                       CLE033
     C                   ENDIF                                                                CLE033
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLRSFD - VALIDATE RECEIVE SETTLEMENT FIELDS                   *
     C*                                                               *
     C*****************************************************************
     C     VLRSFD        BEGSR
      *
      ** ENTRY IN ALL RECEIPT INSTRUCTIONS PROHIBITED IF RECEIPT
      ** SETTLEMENT METHOD IS BLANK
      *
     C     DDRSTM        IFEQ      *BLANKS
      *
     C     DDRONS        IFNE      *BLANKS
     C     DDROBN        ORNE      *BLANKS
     C     DDROCN        ORNE      *BLANKS
     C     DDRIBN        ORNE      *BLANKS
     C     DDRIBA        ORNE      *BLANKS
     C     DDROBR        ORNE      *BLANKS
     C     DDRMAC        ORNE      *BLANKS                                                    CDL018
     C     DDREXR        ORNE      *BLANKS                                                    CLE031
     C     DDREXI        ORNE      *BLANKS                                                    CLE031
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRSTM'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0900'
     C                   MOVE      'N'           DDRstmOK
     C                   END
     C                   END
      *
      ** ENTRY PROHIBITED FOR ORDERING CUSTOMER; ORDERING BANK; INTERM.
      ** BANK AND INTERM. BANK A/C LINE UNLESS SETTL.TP IS 01 07 OR 08
      *
     C     DDRSTM        IFNE      '01'
     C     DDRSTM        ANDNE     '07'
     C     DDRSTM        ANDNE     '08'
     C     CLE033        ANDNE     'Y'                                                        CLE033
     C     DDRSTM        ORNE      '01'                                                       CLE033
     C     DDRSTM        ANDNE     '07'                                                       CLE033
     C     DDRSTM        ANDNE     '08'                                                       CLE033
     C     DDRSTM        ANDNE     '09'                                                       CLE033
     C     CLE033        ANDEQ     'Y'                                                        CLE033
      *
     C     DDROCN        IFNE      *BLANKS
     C     DDROBN        ORNE      *BLANKS
     C     DDRIBN        ORNE      *BLANKS
     C     DDRIBA        ORNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRSTM'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0901'
     C                   MOVE      'N'           DDRstmOK
     C     DDROCN        IFNE      *BLANKS
     C                   MOVE      'N'           DDRocnOK
     C                   END
     C     DDROBN        IFNE      *BLANKS
     C                   MOVE      'N'           DDRobnOK
     C                   END
     C     DDRIBN        IFNE      *BLANKS
     C                   MOVE      'N'           DDRibnOK
     C                   END
     C     DDRIBA        IFNE      *BLANKS
     C                   MOVE      'N'           DDRibaOK
     C                   END
      *
     C                   END
     C                   END
      *                                                                                       CDL018
      ** Entry Prohibited for 'MORE A/C' unless Sett. Method is 05 or 14                      CDL018
      *                                                                                       CDL018
     C     CDL018        IFEQ      'Y'                                                        CDL018
      *                                                                                       CDL018
     C     DDRSTM        IFNE      '05'                                                       CDL018
     C     DDRSTM        ANDNE     '14'                                                       CDL018
      *                                                                                       CDL018
     C     DDRMAC        IFNE      *BLANKS                                                    CDL018
     C                   ADD       1             Idx                                          CDL018
     C                   EVAL      FldNameArr(Idx) = 'DDRSTM'                                 CDL018
     C                   EVAL      MsgIDArr(Idx) = 'ESM1000'                                  CDL018
     C                   MOVE      'N'           DDRmacOK                                     CDL018
     C                   ENDIF                                                                CDL018
     C                   ENDIF                                                                CDL018
      *                                                                                       CDL018
     C                   ENDIF                                                                CDL018
      *                                                                                       CDL018
     C                   ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLRSCY - VALIDATE RECEIVE SETTLEMENT CURRENCY                 *
     C*                                                               *
     C*****************************************************************
     C     VLRSCY        BEGSR
      *
      **  Access Currency Details
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      DDRSCY        @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      **  Receipt settlement currency is invalid
      **  or not a dealing currency
      *
     C     @RTCD         IFNE      *BLANKS
     C     A6DLCI        ORNE      'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRSCY'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0862'
     C                   MOVE      'N'           DDRscyOK
     C                   ELSE
 
     C                   MOVEL     A6CYCD        DDRSCY
      *                                                                                       CLE031
      **  CLE031 enhancement allows settlement of In-ccy or Euro currency                     CLE031
      **  against other currencies                                                            CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C     ##CALP        ANDEQ     'LEND'                                                     CLE031
     C     CLE031        OREQ      'Y'                                                      AR853046
     C     ##CALP        ANDEQ     'MAPY'                                                   AR853046
     C                   MOVE      A6SPRT        AMREXR                                       CLE031
     C                   MOVE      A6MDIN        AMREXI                                       CLE031
     C                   MOVE      A6DLCI        BRDLCI            1                          CLE031
     C                   MOVE      A6INCY        BRINCY            1                          CLE031
      *                                                                                       CLE031
      **  Access Currency Details for transaction receive currency                            CLE031
      *                                                                                       CLE031
     C                   CALLB     'AOCURRR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*KEY    '    @OPTN                                        CLE031
     C                   PARM      ##RCCY        @CURR                                        CLE031
     C     SDCURR        PARM      SDCURR        DSSDY                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      A6SPRT        ARSPRT                                       CLE031
     C                   MOVE      A6MDIN        ARMDIN                                       CLE031
     C                   MOVE      A6INCY        ARINCY            1                          CLE031
      *                                                                                       CLE031
     C                   ELSE                                                                 CLE031
      *
      ** If the transaction receive currency is Euros
      *
     C     ##RCCY        IFEQ      BKEURO
      *
      ** Error if settlement currency is not an 'In' currency
      *
     C     A6INCY        IFNE      'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRSCY'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0850'
     C                   MOVE      'N'           DDRscyOK
     C                   ENDIF
      *
      ** If the transaction receive currency is NOT Euros (i.e. an 'in' ccy)
      *
     C                   ELSE
      *
      ** Error if settlement currency is not Euros
      *
     C     DDRSCY        IFNE      BKEURO
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRSCY'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0851'
     C                   MOVE      'N'           DDRscyOK
     C                   ELSE                                                   152344
      *                                                                         152344
      **  Access Currency Details for transaction receive currency              152344
      *                                                                         152344
     C                   CALLB     'AOCURRR0'                                   152344
     C                   PARM      *BLANKS       @RTCD                          152344
     C                   PARM      '*KEY    '    @OPTN                          152344
     C                   PARM      ##RCCY        @CURR                          152344
     C     SDCURR        PARM      SDCURR        DSSDY                          152344
      *                                                                         152344
      ** Error if receive currency is not an 'In' currency                      152344
      *                                                                         152344
     C     A6INCY        IFNE      'Y'                                          152344
     C                   ADD       1             Idx                            152344
     C                   EVAL      FldNameArr(Idx) = 'DDRSCY'                   152344
     C                   EVAL      MsgIDArr(Idx) = 'ESM0862'                    152344
     C                   MOVE      'N'           DDRscyOK                       152344
     C                   ENDIF                                                  152344
                                                                                152344
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   ENDIF
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************                       CDL018
      *                                                               *                       CDL018
      * VLRMAC - VALIDATE RECEIVE MORE ACCOUNT                        *                       CDL018
      *                                                               *                       CDL018
      *****************************************************************                       CDL018
     C     VLRMAC        BEGSR                                                                CDL018
      *                                                                                       CDL018
      ** More Accounts only valid for Deal Types IP, IT, TI or TD                             CDL018
      *                                                                                       CDL018
     C     ##TTYP        IFNE      'IP'                                                       CDL018
     C     ##TTYP        ANDNE     'IT'                                                       CDL018
     C     ##TTYP        ANDNE     'TI'                                                       CDL018
     C     ##TTYP        ANDNE     'TD'                                                       CDL018
     C     DDRMAC        ANDNE     *BLANKS                                                    CDL018
     C                   ADD       1             Idx                                          CDL018
     C                   EVAL      FldNameArr(Idx) = 'DDRMAC'                                 CDL018
     C                   EVAL      MsgIDArr(Idx) = 'ESM1025'                                  CDL018
     C                   MOVE      'N'           DDRmacOK                                     CDL018
     C                   ENDIF                                                                CDL018
      *                                                                                       CDL018
      ** Must be 'Y', 'N' or blanks                                                           CDL018
      *                                                                                       CDL018
     C     DDRMAC        IFNE      *BLANKS                                                    CDL018
     C     DDRMAC        ANDNE     'Y'                                                        CDL018
     C     DDRMAC        ANDNE     'N'                                                        CDL018
     C                   ADD       1             Idx                                          CDL018
     C                   EVAL      FldNameArr(Idx) = 'DDRMAC'                                 CDL018
     C                   EVAL      MsgIDArr(Idx) = 'ESM1001'                                  CDL018
     C                   MOVE      'N'           DDRmacOK                                     CDL018
     C                   ENDIF                                                                CDL018
      *                                                                                       CDL018
     C                   ENDSR                                                                CDL018
      *****************************************************************                       CDL018
      /EJECT                                                                                  CDL018
      *****************************************************************                       CLE031
      *                                                               *                       CLE031
      * VLREXR - VALIDATE RECEIVE EXCHANGE RATE                       *                       CLE031
      *                                                               *                       CLE031
      *****************************************************************                       CLE031
     C     VLREXR        BEGSR                                                                CLE031
      *                                                                                       CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      DDREXR        ZFIELD                                       CLE031
     C                   Z-ADD     5             ZADIG                                        CLE031
     C                   Z-ADD     8             ZADEC                                        CLE031
      *                                                                                       CLE031
     C                   CALLB     'ZALIGN'                                                   CLE031
     C**********         PARM      *BLANK        PRTCD                                 CLE031 CLE106
     C                   PARM      *BLANK        ZALIGNok          1                          CLE106
     C                   PARM                    ZFIELD                                       CLE031
     C                   PARM                    ZADEC                                        CLE031
     C                   PARM                    ZADIG                                        CLE031
     C**********         PARM      *BLANKS       ZAVAL                                 CLE031 CLE106
      *                                                                                       CLE031
     C**********         MOVE      ZAVAL         WMREXR           14 0                 CLE031 CLE106
     C*****ZAVAL         IFEQ      *BLANKS                                             CLE031 CLE106
     C                   MOVE      ZFIELD        WMREXR           14 0                        CLE106
     C     ZFIELD        IFEQ      *BLANKS                                                    CLE106
     C                   Z-ADD     *ZEROS        WMREXR                                       CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C     ARINCY        IFNE      'Y'                                                        CLE031
      *                                                                                       CLE031
     C     DDRSCY        IFEQ      *BLANKS                                                    CLE031
     C     DDREXR        ANDNE     *BLANKS                                                    CLE031
     C     WMREXR        ANDNE     *ZEROS                                                     CLE031
     C     DDRSCY        OREQ      *BLANKS                                                    CLE031
     C     DDREXI        ANDNE     *BLANKS                                                    CLE031
     C                   ADD       1             Idx                                          CLE031
     C                   EVAL      FldNameArr(Idx) = 'DDRexr'                                 CLE031
     C                   EVAL      MsgIDArr(Idx) = 'ESM0801'                                  CLE031
     C                   MOVE      'N'           DDRexrOK                                     CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C     ##RCCY        IFEQ      BKEURO                                                     CLE031
     C     BRINCY        ANDEQ     'Y'                                                        CLE031
     C     ##RCCY        OREQ      BKEURO                                                     CLE031
     C     DDRSCY        ANDEQ     BKEURO                                                     CLE031
      *                                                                                       CLE031
     C     DDREXR        IFNE      *BLANKS                                                    CLE031
     C     WMREXR        ANDNE     *ZEROS                                                     CLE031
     C     DDREXI        ORNE      *BLANKS                                                    CLE031
     C                   ADD       1             Idx                                          CLE031
     C                   EVAL      FldNameArr(Idx) = 'DDRexr'                                 CLE031
     C                   EVAL      MsgIDArr(Idx) = 'ESM0802'                                  CLE031
     C                   MOVE      'N'           DDRexrOK                                     CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C     ARINCY        IFNE      'Y'                                                        CLE031
     C     ##RCCY        ANDNE     BKEURO                                                     CLE031
     C     DDRSCY        ANDNE     *BLANKS                                                    CLE031
     C     BRINCY        ANDEQ     'Y'                                                        CLE031
     C                   ADD       1             Idx                                          CLE031
     C                   EVAL      FldNameArr(Idx) = 'DDRexr'                                 CLE031
     C                   EVAL      MsgIDArr(Idx) = 'ESM0810'                                  CLE031
     C                   MOVE      'N'           DDRexrOK                                     CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C     ##PREC        IFNE      'Y'                                                        CLE031
     C     ##ACTN        OREQ      'X'                                                        CLE031
     C     DDRSCY        IFNE      *BLANKS                                                    CLE031
     C*****BRDLCI        ANDNE     'Y'                                               CLE031 MD020816
     C     BRDLCI        ANDEQ     'N'                                                      MD020816
     C                   ADD       1             Idx                                          CLE031
     C                   EVAL      FldNameArr(Idx) = 'DDRexr'                                 CLE031
     C                   EVAL      MsgIDArr(Idx) = 'ESM0812'                                  CLE031
     C                   MOVE      'N'           DDRexrOK                                     CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C     DDRSCY        IFEQ      ##RCCY                                                     CLE031
     C     DDRSCY        ANDNE     *BLANKS                                                    CLE031
     C                   ADD       1             Idx                                          CLE031
     C**********         EVAL      FldNameArr(Idx) = 'DDRexr'                          CLE031 CLE106
     C                   EVAL      FldNameArr(Idx) = 'DDRSCY'                                 CLE106
     C                   EVAL      MsgIDArr(Idx) = 'ESM0814'                                  CLE031
     C                   MOVE      'N'           DDRexrOK                                     CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C     DDRexrOK      IFNE      'N'                                                        CLE031
     C                   MOVEL     *BLANKS       ZMDIX                                        CLE031
     C     DDREXR        IFEQ      *BLANKS                                                    CLE031
     C     WMREXR        OREQ      *ZEROS                                                     CLE031
     C     DDRSCY        IFNE      *BLANKS                                                    CLE031
     C     CLE033        IFEQ      'Y'                                                        CLE031
     C     SET09         ANDEQ     'T'                                                        CLE031
     C     DDRSTM        ANDEQ     '09'                                                       CLE031
      *                                                                                       CLE031
      ** Do not want exchange rate default in these circumstances                             CLE031
      *                                                                                       CLE031
     C                   ELSE                                                                 CLE031
      *                                                                                       CLE031
      ** Calculate cross rate from Receive Ccy to Receive Sett Ccy                            CLE031
      *                                                                                       CLE031
     C                   Z-ADD     ARSPRT        ZRATE1                                       CLE031
     C                   MOVEL     ARMDIN        ZMDI1                                        CLE031
     C                   Z-ADD     AMREXR        ZRATE2                                       CLE031
     C                   MOVEL     AMREXI        ZMDI2                                        CLE031
     C                   CALLB     'ZXRATE'                                                   CLE031
     C                   PARM                    ZRATE1           13 8                        CLE031
     C                   PARM                    ZMDI1             1                          CLE031
     C                   PARM                    ZRATE2           13 8                        CLE031
     C                   PARM                    ZMDI2             1                          CLE031
     C                   PARM                    ZRATEX           13 8                        CLE031
     C                   PARM                    ZMDIX             1                          CLE031
     C                   MOVE      ZRATEX        DDREXC           14                          CLE031
     C                   MOVE      ZRATEX        DDREXCR          13 8                        CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   ELSE                                                                 CLE031
      *                                                                                       CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      DDREXR        ZFIELD           16                          CLE031
     C                   Z-ADD     5             ZADIG             2 0                        CLE031
     C                   Z-ADD     8             ZADEC             1 0                        CLE031
      *                                                                                       CLE031
     C                   CALLB     'ZALIGN'                                                   CLE031
     C**********         PARM      *BLANK        PRTCD                                 CLE031 CLE106
     C                   PARM      *BLANK        ZALIGNok                                     CLE106
     C                   PARM                    ZFIELD                                       CLE031
     C                   PARM                    ZADEC                                        CLE031
     C                   PARM                    ZADIG                                        CLE031
     C**********         PARM      *BLANKS       ZAVAL            16                   CLE031 CLE106
      *                                                                                       CLE031
     C*****PRTCD         IFNE      *BLANK                                              CLE031 CLE106
     C     ZALIGNok      IFNE      'Y'                                                        CLE106
     C                   ADD       1             Idx                                          CLE031
     C                   EVAL      FldNameArr(Idx) = 'DDRexr'                                 CLE031
     C                   EVAL      MsgIDArr(Idx) = 'ESM0865'                                  CLE031
     C                   MOVE      'N'           DDRexrOK                                     CLE031
     C                   ELSE                                                                 CLE031
     C**********         MOVE      ZAVAL         DDREXC                                CLE031 CLE106
     C                   MOVE      ZFIELD        DDREXC                                       CLE106
     C                   MOVE      DDREXC        DDREXCR          13 8                        CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C*****PRTCD         IFEQ      *BLANKS                                             CLE031 CLE106
     C     ZALIGNok      IFEQ      'Y'                                                        CLE106
     C     DDREXC        ANDNE     *BLANKS                                                    CLE031
     C     DDRSCY        ANDNE     *BLANKS                                                    CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      DDREXC        ZFIELD                                       CLE031
     C                   Z-ADD     8             ZADEC                                        CLE031
     C                   CALLB     'ZEDIT'                                                    CLE031
     C                   PARM                    ZFIELD                                       CLE031
     C                   PARM                    ZADEC             1 0                        CLE031
     C                   MOVE      ZFIELD        DDREXR                                       CLE031
     C**********         MOVE      DDREXCR       FLREXR                                CLE031 CLE106
     C                   MOVEL     DDREXCR       FLREXR                                       CLE106
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C     DDRexrOK      IFNE      'N'                                                        CLE031
     C     DDREXI        IFNE      *BLANKS                                                    CLE031
     C     DDREXI        ANDNE     'M'                                                        CLE031
     C     DDREXI        ANDNE     'D'                                                        CLE031
     C                   ADD       1             Idx                                          CLE031
     C                   EVAL      FldNameArr(Idx) = 'DDRexi'                                 CLE031
     C                   EVAL      MsgIDArr(Idx) = 'ESM0878'                                  CLE031
     C                   MOVE      'N'           DDRexiOK                                     CLE031
     C                   ELSE                                                                 CLE031
      *                                                                                       CLE031
     C     DDREXI        IFEQ      *BLANKS                                                    CLE031
     C     DDREXR        ANDNE     *BLANKS                                                    CLE031
     C     CLE033        IFEQ      'Y'                                                        CLE031
     C     SET09         ANDEQ     'T'                                                        CLE031
     C     DDRSTM        ANDEQ     '09'                                                       CLE031
      *                                                                                       CLE031
      ** Do not want multiply/divide ind default in these circumstances                       CLE031
      *                                                                                       CLE031
     C                   ELSE                                                                 CLE031
     C     ZMDIX         IFNE      *BLANKS                                                    CLE031
     C                   MOVEL     ZMDIX         DDREXI                                       CLE031
     C                   ELSE                                                                 CLE031
     C                   MOVE      AMREXI        DDREXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
     C                   MOVEL     DDREXI        FLREXI                                       CLE031
      *                                                                                       CLE031
     C                   ELSE                                                                 CLE031
     C     DDREXR        IFNE      *BLANKS                                                    CLE031
     C     WMREXR        ANDNE     *ZEROS                                                     CLE031
     C                   ADD       1             Idx                                          CLE031
     C                   EVAL      FldNameArr(Idx) = 'DDRexr'                                 CLE031
     C                   EVAL      MsgIDArr(Idx) = 'ESM0802'                                  CLE031
     C                   MOVE      'N'           DDRexrOK                                     CLE031
     C                   ENDIF                                                                CLE031
     C     DDREXI        IFNE      *BLANKS                                                    CLE031
     C                   ADD       1             Idx                                          CLE031
     C                   EVAL      FldNameArr(Idx) = 'DDRexi'                                 CLE031
     C                   EVAL      MsgIDArr(Idx) = 'ESM0802'                                  CLE031
     C                   MOVE      'N'           DDRexiOK                                     CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   ENDSR                                                                CLE031
      *****************************************************************                       CLE031
      /EJECT                                                                                  CLE031
     C*****************************************************************
     C*                                                               *
     C* VLRSTM - VALIDATE RECEIVE SETTLEMENT METHOD                   *
     C*                                                               *
     C*****************************************************************
     C     VLRSTM        BEGSR
      *                                                                                       182114
      ** RESET A/C CLOSED INDICATOR                                                           182114
      *                                                                                       182114
     C                   MOVE      *BLANKS       W#ACOPEN                                     182114
     C/COPY WNCPYSRC,ZASETINV17                                                               CUT009
      *
      ** MUST BE 00,01,02,03,04,05,06,07,08,12 OR 14
      *
     C     DDRSTM        IFNE      '00'
     C     DDRSTM        ANDNE     '01'
     C     DDRSTM        ANDNE     '02'
     C     DDRSTM        ANDNE     '03'
     C     DDRSTM        ANDNE     '04'
     C     DDRSTM        ANDNE     '05'
     C     DDRSTM        ANDNE     '06'
     C     DDRSTM        ANDNE     '07'
     C     DDRSTM        ANDNE     '08'
     C     DDRSTM        ANDNE     '12'
     C     DDRSTM        ANDNE     '14'
     C     DDRSTM        ANDNE     '  '                                                       246120
     C     CLE033        ANDNE     'Y'                                                        CLE033
     C     DDRSTM        ORNE      '00'                                                       CLE033
     C     DDRSTM        ANDNE     '01'                                                       CLE033
     C     DDRSTM        ANDNE     '02'                                                       CLE033
     C     DDRSTM        ANDNE     '03'                                                       CLE033
     C     DDRSTM        ANDNE     '04'                                                       CLE033
     C     DDRSTM        ANDNE     '05'                                                       CLE033
     C     DDRSTM        ANDNE     '06'                                                       CLE033
     C     DDRSTM        ANDNE     '07'                                                       CLE033
     C     DDRSTM        ANDNE     '08'                                                       CLE033
     C     DDRSTM        ANDNE     '12'                                                       CLE033
     C     DDRSTM        ANDNE     '14'                                                       CLE033
     C     DDRSTM        ANDNE     '09'                                                       CLE033
     C     DDRSTM        ANDNE     '  '                                                       246120
     C     CLE033        ANDEQ     'Y'                                                        CLE033
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRSTM'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0902'
     C                   MOVE      'N'           DDRstmOK
     C                   END
     C/COPY WNCPYSRC,ZASETINV18                                                               CUT009
      *                                                                         CDL008
     C     CDL008        IFEQ      'Y'                                          CDL008
     C     ##CALP        ANDEQ     'FXDL'                                       CDL008
     C     ##TTYP        ANDEQ     'CL'                                         CDL008
     C     DDRSTM        ANDNE     '00'                                         CDL008
     C     DDRSTM        ANDNE     '01'                                         CDL008
     C     DDRSTM        ANDNE     '07'                                         CDL008
     C     DDRSTM        ANDNE     '08'                                         CDL008
     C     DDRSTM        ANDNE     '02'                                         CDL008
     C     DDRSTM        ANDNE     '12'                                         CDL008
     C                   ADD       1             Idx                            CDL008
     C                   EVAL      FldNameArr(Idx) = 'DDRSTM'                   CDL008
     C                   EVAL      MsgIDArr(Idx) = 'ESM0303'                    CDL008
     C                   MOVE      'N'           DDRstmOK                       CDL008
     C                   ENDIF                                                  CDL008
     C/COPY WNCPYSRC,ZASETNVC34
      *
      ** IF SETL TYPE IS 04 OR 14 THE RETAIL MODULE MUST BE PRESENT
      *
     C     DDRSTM        IFEQ      '04'
     C     DDRSTM        OREQ      '14'
     C     BGRTBN        IFNE      'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRSTM'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0903'
     C                   MOVE      'N'           DDRstmOK
     C                   END
     C                   END
      *
      ** IF REC SETL METHOD IS 04 A LIVE RECORD MUST EXIST IN ACCNTAB
      *
     C     DDRSTM        IFEQ      '04'
     C                   MOVEL     ##CSNM        @ACID
     C                   MOVE      E#RCCY        @CYCD
     C                   MOVE      BMACCD        @ACCD
     C                   MOVE      '01'          @ACSN
     C                   MOVE      ##BRCA        @BRCA
      *
      ** SET UP SETTLEMENT BRANCH
      *
     C                   MOVE      ##BRCA        DDROBR
     C                   MOVE      ##BRCA        FLROBR
      *
      **  FOR STANDING DATA - EXTENDED SETTLEMENTS:
      **  WITH SETTLEMENT TYPE 04 CHECKING OF ACCOUNT WON'T BE DONE
      *
     C     ##CALP        IFNE      'SSI '
      *
      * ACCESS ACCOUNT DETAILS
      *
     C                   EXSR      ACACCT
      *
      * ACCOUNT IS CLOSED
      *
     C     @RTCD         IFNE      *BLANKS
     C*****##PREC        ANDNE     'Y'                                                196461 BUG6010
     C     RECI          ORNE      'D'
     C*****##PREC        ANDNE     'Y'                                                196461 BUG6010
     C     ACST          OREQ      'C'
     C*****##PREC        ANDNE     'Y'                                                196461 BUG6010
     C                   IF        ##PREC = 'Y'                                              BUG6010
     C                   IF        ##ACTN <> 'R'                                             BUG6010
     C                   EVAL      WIdx = WIdx + 1                                           BUG6010
     C                   EVAL      WFldNameArr(WIdx) = 'DDRSTM'                              BUG6010
     C                   EVAL      WMsgIDArr(WIdx) = 'ESM1104'                               BUG6010
     C                   ENDIF                                                               BUG6010
     C                   ELSE                                                                BUG6010
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRSTM'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0904'
     C                   MOVE      'N'           DDRstmOK
     C                   ENDIF                                                               BUG6010
     C                   ELSE                                                                 182114
      *                                                                                       182114
     C                   MOVE      'Y'           W#ACOPEN                                     182114
      *                                                                                       182114
      ** Ensure account is not blocked for Debit/Credit                                       182114
      *                                                                                       182114
     C                   TESTB     '2'           RETB                     91    DEBIT         182114
     C                   TESTB     '3'           RETB                     92    CREDIT        182114
     C/COPY WNCPYSRC,ZAH00045
      *                                                                                       182114
      ** A/C IS BLOCKED                                                                       182114
      *                                                                                       182114
     C     ##PREC        IFNE      'Y'                                                        260863
     C     *IN91         IFEQ      '1'                                                        182114
     C     *IN92         OREQ      '1'                                                        182114
     C                   ADD       1             Idx                                          182114
     C                   EVAL      FldNameArr(Idx) = 'DDRONX'                                 182114
     C                   EVAL      MsgIDArr(Idx) = 'ESM0991'                                  182114
     C                   MOVE      'N'           DDRonxOK                                     182114
     C                   END                                                                  182114
     C                   ENDIF                                                                260863
     C                   END
                                                                                              CRE008
      ** Set up Account ID for Overdraft Limit Check                                          CRE008
                                                                                              CRE008
     C                   IF        CDL008 = 'Y'                                               CRE008
     C                             OR CGL014 = 'Y'                                            CGL014
     C                   EVAL      WkCust = CNUM                                              CRE008
     C                   EVAL      WkCcy  = CCY                                               CRE008
     C                   EVAL      WkACOD = ACOD                                              CRE008
     C                   EVAL      WkASeq = ACSQ                                              CRE008
     C                   EVAL      WkBRCA = BRCA                                              CRE008
     C                   ENDIF                                                                CRE008
      *
     C                   END
     C                   END
      *
      ** IF SETL TYPE IS 07 THE RECEIPT CURRENCY MUST BE USD
      *
     C     DDRSTM        IFEQ      '07'
     C     E#RCCY        ANDNE     'USD'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRSTM'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0905'
     C                   MOVE      'N'           DDRstmOK
     C                   END
      *
      ** IF SETL TYPE IS 14, RETAIL ACCOUNT NUMBERS MUST BE SUPPORTED
      *
     C     DDRSTM        IFEQ      '14'
     C     BMRANR        ANDNE     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRSTM'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0906'
     C                   MOVE      'N'           DDRstmOK
     C                   END
                                                                                              CGL014
     C                   IF        DDRSTM = '14' AND CGL014 = 'Y'                             CGL014
     C                   MOVEL     DDRONX        WRcRetail                                    CGL014
     C                   ENDIF                                                                CGL014
      *                                                                                       CLE033
      ** IF SETL TYPE IS 09, SET CORRECT CURRENCY UP ACCORDING TO                             CLE033
      ** SYSTEM VALUE                                                                         CLE033
      *                                                                                       CLE033
     C     DDRSTM        IFEQ      '09'                                                       CLE033
     C     CLE033        ANDEQ     'Y'                                                        CLE033
     C     A5ACTY        ANDEQ     'R'                                                        CLE033
      *                                                                                       CLE033
     C     DDRSCY        IFNE      *BLANKS                                                    CLE033
     C     SET09         ANDNE     'T'                                                        CLE033
     C                   MOVEL     DDRSCY        W0RSCY            3                          CLE033
     C                   END                                                                  CLE033
      *                                                                                       CLE033
     C     DDRSCY        IFEQ      *BLANKS                                                    CLE033
     C     SET09         OREQ      'T'                                                        CLE033
     C                   MOVEL     ##RCCY        W0RSCY                                       CLE033
     C                   END                                                                  CLE033
      *                                                                                       CLE033
     C                   MOVEL     P@VL02        W0ACCD           10                          CLE033
     C                   MOVEL     P@VL01        W0CNUM            6                          CLE033
      *                                                                                       CLE033
      ** For Settlement Type 09 for SSI, only partial checking of                             CLE033
      ** account entered can be done, as not all details are available.                       CLE033
      ** Therefore subroutine ACACCT should not be called.                                    CLE033
      *                                                                                       CLE033
     C     ##CALP        IFNE      'SSI '                                                     CLE033
     C*                                                                                       CLE033
     C                   MOVEL     *BLANKS       @ACID                                        CLE033
     C                   MOVEL     W0CNUM        @ACID                                        CLE033
     C                   MOVE      W0RSCY        @CYCD                                        CLE033
     C                   MOVE      W0ACCD        @ACCD                                        CLE033
     C                   MOVE      '01'          @ACSN                                        CLE033
     C                   MOVE      ##BRCA        @BRCA                                        CLE033
     C                   EXSR      ACACCT                                                     CLE033
     C*                                                                                       CLE033
     C     @RTCD         IFNE      *BLANKS                                                    CLE033
     C     RECI          ORNE      'D'                                                        CLE033
     C     ATYP          ORNE      'R'                                                        CLE033
     C                   ADD       1             Idx                                          CLE033
     C                   EVAL      FldNameArr(Idx) = 'DDRSTM'                                 CLE033
     C                   EVAL      MsgIDArr(Idx) = 'ESM0904'                                  CLE033
     C                   MOVE      'N'           DDRstmOK                                     CLE033
     C                   ENDIF                                                                CLE033
     C*                                                                                       CLE033
     C                   ENDIF                                                                CLE033
      *                                                                                       CLE033
     C                   ENDIF                                                                CLE033
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLROBR - VALIDATE RECEIVE SETTLEMENT BRANCH                   *
     C*                                                               *
     C*****************************************************************
     C     VLROBR        BEGSR
      *
      ** IF SETTLEMENT METHOD IS 05
      *
     C     DDRSTM        IFEQ      '05'
      *
      ** SETTLEMENT BRANCH IS MANDATORY
      *
     C     DDROBR        IFEQ      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0885'
     C                   MOVE      'N'           DDRonxOK
     C                   ELSE
      *
      ** NOW VALIDATE SETTLEMENT BRANCH
      *
     C                   MOVE      DDROBR        @BRCA
     C                   EXSR      ACBRCH
      *
      * NO SELECTION
      *
     C     @RTCD         IFEQ      '*NOSEL '
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0863'
     C                   MOVE      'N'           DDRonxOK
     C                   END
      *
      * ERROR IN SETTLEMENT BRANCH
      *
     C     @RTCD         IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0884'
     C                   MOVE      'N'           DDRonxOK
     C                   ELSE
     C                   MOVE      @DSNB         DDROBR
     C                   MOVE      @DSNB         FLROBR
     C                   END
     C                   END
      *                                                                                       CLE033
     C                   ELSE                                                                 CLE033
     C     CLE033        IFEQ      'Y'                                                        CLE033
     C     DDRSTM        ANDEQ     '09'                                                       CLE033
     C                   MOVEL     DDROBR        FLROBR                                       CLE033
     C                   ENDIF                                                                CLE033
      *                                                                                       CLE033
     C                   END
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLRONS - VALIDATE OUR RECEIVE NOSTRO                          *
     C*                                                               *
     C*****************************************************************
     C     VLRONS        BEGSR
      *
      ** RESET A/C CLOSED INDICATOR
      *
     C                   MOVE      *BLANKS       W#ACOPEN          1
      *
      ** MOVE OUR NOSTRO INTO OUR ACCOUNT DATA STRUCTURE
      *
     C                   MOVE      DDRONS        A#OURA
     C                   EVAL      SETTF = 'R'                                               CSF011A
      *
      ** OUR NOSTRO MUST BE BLANK IF SETTLEMENT TYPE IS 00,04 OR 06
      *
     C     DDRSTM        IFEQ      '00'
     C     DDRSTM        OREQ      '04'
     C     DDRSTM        OREQ      '06'
     C     DDRONS        IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0907'
     C                   MOVE      'N'           DDRonxOK
     C                   END
     C                   END
      *
      ** IF SETL TYPE IS 01,02,07,08 OR 12 MUST BE A 2 DIGIT NUMBER
      ** AND IDENTIFY A LIVE RECORD ON THE NOSTRO FILE SDNOSTPD
      *
     C     DDRSTM        IFEQ      '01'
     C     DDRSTM        OREQ      '02'
     C     DDRSTM        OREQ      '07'
     C     DDRSTM        OREQ      '08'
     C     DDRSTM        OREQ      '12'
      *
     C/COPY WNCPYSRC,ZASETINVC2
      *
      ** CHECK OTHER 10 CHARACTERS ARE BLANK
      *
     C                   TESTN                   A#NOST               99
     C     *IN99         IFNE      '1'
     C     A#REST        ORNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0908'
     C                   MOVE      'N'           DDRonxOK
     C                   ELSE
      *
      * NOW VALIDATE NOSTRO CODE
      *
     C                   MOVE      E#RCCY        @CYCD
     C                   MOVE      A#NOST        @NONB
      *
      * ACCESS NOSTRO DETAILS
      *
     C                   EXSR      ACNOST
      *
      * NOSTRO NOT FOUND
      *
     C     @RTCD         IFNE      *BLANKS
     C                   IF        ##PREC = 'Y'                                               260863
     C                   IF        ##ACTN <> 'R'                                              260863
     C                   EVAL      WIdx = WIdx + 1                                            260863
     C                   EVAL      WFldNameArr(WIdx) = 'DDRONX'                               260863
     C                   EVAL      WMsgIDArr(WIdx) = 'ESM1111'                                260863
     C                   MOVE      'W'           DDRonxOK                                     260863
     C                   ENDIF                                                                260863
     C                   ELSE                                                                 260863
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0908'
     C                   MOVE      'N'           DDRonxOK
     C                   ENDIF                                                                260863
     C                   ELSE
      *
      ** NOSTRO GL ACCOUNT
      *
     C     CDL008        IFEQ      'Y'                                          CDL008
      *                                                                         CDL008
     C     ##TTYP        IFEQ      'CL'                                         CDL008
     C     ##CALP        ANDEQ     'FXDL'                                       CDL008
     C     A7CLSD        ANDNE     'Y'                                          CDL008
     C                   ADD       1             Idx                            CDL008
     C                   EVAL      FldNameArr(Idx) = 'DDRONX'                   CDL008
     C                   EVAL      MsgIDArr(Idx) = 'ESM0301'                    CDL008
     C                   MOVE      'N'           DDRonxOK                       CDL008
     C                   ENDIF                                                  CDL008
      *                                                                         CDL008
     C     ##TTYP        IFNE      'CL'                                         CDL008
     C     ##CALP        ANDEQ     'FXDL'                                       CDL008
     C     A7CLSD        ANDEQ     'Y'                                          CDL008
     C                   ADD       1             Idx                            CDL008
     C                   EVAL      FldNameArr(Idx) = 'DDRONX'                   CDL008
     C                   EVAL      MsgIDArr(Idx) = 'ESM0305'                    CDL008
     C                   MOVE      'N'           DDRonxOK                       CDL008
     C                   ENDIF                                                  CDL008
      *                                                                         CDL008
     C                   ENDIF                                                  CDL008
      *                                                                         CDL008
     C                   MOVEL     *BLANKS       @ACID
     C                   MOVEL     A7CUST        @ACID
     C                   MOVE      E#RCCY        @CYCD
     C                   MOVE      A7ACCD        @ACCD
     C                   MOVE      A7ACSN        @ACSN
     C                   MOVE      A7BRCD        @BRCA
      *
      ** SET UP SETTLEMENT BRANCH
      *
     C                   MOVE      A7BRCD        DDROBR
     C                   MOVE      A7BRCD        FLROBR
      *
      * ACCESS ACCOUNT DETAILS
      *
     C                   EXSR      ACACCT
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EXSR      CSFACT                                                    CSF011A
     C                   ENDIF                                                               CSF011A
      *
      * ACCOUNT IS CLOSED
      *
     C     @RTCD         IFNE      *BLANKS
     C*****##PREC        ANDNE     'Y'                                                196461 BUG6010
     C     RECI          ORNE      'D'
     C*****##PREC        ANDNE     'Y'                                                196461 BUG6010
      *                                                                                      BUG6010
      ** Warn if the account is closed.                                                      BUG6010
      *                                                                                      BUG6010
     C                   IF        ##ACTN <> 'R'                                             BUG6010
     C                   EVAL      WIdx = WIdx + 1                                           BUG6010
     C                   EVAL      WFldNameArr(WIdx) = 'DDRONX'                              BUG6010
     C                   EVAL      WMsgIDArr(WIdx) = 'ESM1105'                               BUG6010
     C                   ENDIF                                                               BUG6010
     C                   ELSE
      *
     C                   MOVE      'Y'           W#ACOPEN
      *                                                                                       182114
      ** Ensure account is not blocked for Debit/Credit                                       182114
      *                                                                                       182114
     C                   TESTB     '2'           RETB                     91    DEBIT         182114
     C/COPY WNCPYSRC,ZAH00046
      *                                                                                       182114
      ** A/C IS BLOCKED                                                                       182114
      *                                                                                       182114
     C     ##PREC        IFNE      'Y'                                                        260863
     C     *IN91         IFEQ      '1'                                                        182114
     C                   ADD       1             Idx                                          182114
     C                   EVAL      FldNameArr(Idx) = 'DDRONX'                                 182114
     C                   EVAL      MsgIDArr(Idx) = 'ESM0991'                                  182114
     C                   MOVE      'N'           DDRonxOK                                     182114
     C                   END                                                                  182114
     C                   ENDIF                                                                260863
      *
      ** IF NOT MULTIBRANCHING NOSTRO MUST BE IN SINGLE BRANCH
      *
     C     @MBIN         IFEQ      'N'
     C     BJSBRC        ANDNE     A7BRCD
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0500'
     C                   MOVE      'N'           DDRonxOK
     C                   END
      *
      ** RETRIEVE BRANCH INTERNAL CUSTOMER NUMBER ASSOCIATED WITH
      ** NOSTRO BRANCH FOR VALIDATION LATER.
      *
     C                   MOVE      A7BRCD        @BRCA
     C                   EXSR      ACBRCH
     C                   MOVEL     A8BICN        @RBICN            6
      *
     C                   END
                                                                                              CRE008
      ** Set up Account ID for Overdraft Limit Check                                          CRE008
                                                                                              CRE008
     C                   IF        CDL008 = 'Y'                                               CRE008
     C                   EVAL      WkCust = CNUM                                              CRE008
     C                   EVAL      WkCcy  = CCY                                               CRE008
     C                   EVAL      WkACOD = ACOD                                              CRE008
     C                   EVAL      WkASeq = ACSQ                                              CRE008
     C                   EVAL      WkBRCA = BRCA                                              CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
     C                   END
     C                   END
     C                   END
      *
      ** IF SETTLEMENT TYPE IS 03, 'OUR NOSTRO' MUST EITHER BE BLANK OR
      ** CONTAIN A SIX DIGIT DEAL NUMBER (TO COMPENSATE AGAINST).
      *
     C     DDRSTM        IFEQ      '03'
     C     A#OURA        ANDNE     *BLANKS
     C                   TESTN                   A#CNUM               99
     C     *IN99         IFNE      '1'
     C     A#ACAS        ORNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0909'
     C                   MOVE      'N'           DDRonxOK
     C                   ELSE                                                                CSF011A
     C                   EVAL      @RTCD = *BLANKS                                           CSF011A
     C                   EVAL      W@TYPE = 'CUST'                                           CSF011A
     C                   EXSR      CSFACT                                                    CSF011A
     C                   END
     C                   END
      *
      ** IF SETLEMENT TYPE IS 05 MUST IDENTIFY A LIVE RECORD ON ACCNTAB
      ** (IN COMBINATION WITH RECEIPT CURRENCY)
      *
     C     DDRSTM        IFEQ      '05'
      *
     C                   MOVEL     DDRONX        WDRONX           21                       MD024884A
     C     DDRONX        IFNE      *BLANKS                                                  BUG12624
     C     A#ACSQ        IFEQ      *BLANKS
     C     A#ACSQ        OREQ      '00'
     C                   MOVE      '01'          A#ACSQ
     C                   MOVE      A#ACSQ        DDRONX                                      BUG6393
     C                   END
      *
     C**********         TESTN                   A#CNUM               99                      CSD027
     C***99*****         TESTN                   A#ACOD               99                      CSD027
     C                   TESTN                   A#ACOD               99                      CSD027
     C   99              TESTN                   A#ACSQ               99
      *
      ** INVALID CUSTOMER, A/C CODE & A/C SEQUENCE
      *
     C     *IN99         IFNE      '1'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0910'
     C                   MOVE      'N'           DDRonxOK
     C                   ELSE
      *
     C                   MOVEL     *BLANKS       @ACID
     C                   MOVEL     A#CNUM        @ACID
     C                   MOVE      E#RCCY        @CYCD
     C                   MOVE      A#ACSQ        @ACSN
     C                   MOVE      A#ACOD        @ACCD
      *
      * Default branch
      *
     C     @MBIN         IFEQ      'N'
     C                   MOVE      BJSBRC        DDROBR
     C                   MOVE      BJSBRC        FLROBR
     C                   END
      *
     C                   MOVE      DDROBR        @BRCA
      *
      * ACCESS ACCOUNT DETAILS
      *
     C                   EXSR      ACACCT
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EXSR      CSFACT                                                    CSF011A
     C                   ENDIF                                                               CSF011A
      *
      * ACCOUNT IS CLOSED
      *
     C     @RTCD         IFNE      *BLANKS
     C*****##PREC        ANDNE     'Y'                                                196461 BUG6010
     C     RECI          ORNE      'D'
     C*****##PREC        ANDNE     'Y'                                                196461 BUG6010
     C     ACST          OREQ      'C'
     C*****##PREC        ANDNE     'Y'                                                196461 BUG6010
     C                   IF        ##PREC = 'Y'                                              BUG6010
     C                   IF        ##ACTN <> 'R'                                             BUG6010
     C                   EVAL      WIdx = WIdx + 1                                           BUG6010
     C                   EVAL      WFldNameArr(WIdx) = 'DDRONX'                              BUG6010
     C                   EVAL      WMsgIDArr(WIdx) = 'ESM1110'                               BUG6010
     C                   ENDIF                                                               BUG6010
     C                   ELSE                                                                BUG6010
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0910'
     C                   MOVE      'N'           DDRonxOK
     C                   ENDIF                                                               BUG6010
     C                   ELSE
     C                   MOVE      'Y'           W#ACOPEN
     C                   MOVE      A#OURA        DDRONS
      *                                                                                       182114
      ** Ensure account is not blocked for Debit/Credit                                       182114
      *                                                                                       182114
     C                   TESTB     '2'           RETB                     91    DEBIT         182114
     C/COPY WNCPYSRC,ZAH00047
      *                                                                                       182114
      ** A/C IS BLOCKED                                                                       182114
      *                                                                                       182114
     C     ##PREC        IFNE      'Y'                                                        260863
     C     *IN91         IFEQ      '1'                                                        182114
     C                   ADD       1             Idx                                          182114
     C                   EVAL      FldNameArr(Idx) = 'DDRONX'                                 182114
     C                   EVAL      MsgIDArr(Idx) = 'ESM0991'                                  182114
     C                   MOVE      'N'           DDRonxOK                                     182114
     C                   END                                                                  182114
     C                   ENDIF                                                                260863
     C                   END
                                                                                              CRE008
      ** Set up Account ID for Overdraft Limit Check                                          CRE008
                                                                                              CRE008
     C                   IF        CDL008 = 'Y'                                               CRE008
     C                   EVAL      WkCust = CNUM                                              CRE008
     C                   EVAL      WkCcy  = CCY                                               CRE008
     C                   EVAL      WkACOD = ACOD                                              CRE008
     C                   EVAL      WkASeq = ACSQ                                              CRE008
     C                   EVAL      WkBRCA = BRCA                                              CRE008
     C                   ENDIF                                                                CRE008
      *
     C                   END
     C                   ENDIF                                                              BUG12624
     C                   IF        DDRonxOK = 'N'                                          MD024884A
     C                   MOVEL     WDRONX        DDRONX                                    MD024884A
     C                   ENDIF                                                             MD024884A
     C                   END
      *
      ** IF SETL TYPE IS 14, NOSTRO MUST CONTAIN A 10 DIGIT NUMBER
      ** WHICH IDENTIFIES A LIVE RECORD ON FILE ACCNTAB
      *
     C     DDRSTM        IFEQ      '14'
     C                   TESTN                   A#RENO               99
      *
      ** INVALID RETAIL A/C NUMBER
      *
     C     *IN99         IFNE      '1'
     C     A#ACSQ        ORNE      *BLANKS
     C     A#RES2        ORNE      *BLANKS                                                    248393
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0911'
     C                   MOVE      'N'           DDRonxOK
     C                   ELSE
      *
     C                   MOVEL     A#RENO        @ACID
     C                   MOVE      *BLANKS       @CYCD
     C                   MOVE      *BLANKS       @ACSN
     C                   MOVE      *BLANKS       @ACCD
     C                   MOVE      *BLANKS       @BRCA
      *
      * ACCESS ACCOUNT DETAILS
      *
     C                   EXSR      ACACCT
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EXSR      CSFACT                                                    CSF011A
     C                   ENDIF                                                               CSF011A
      *
      * ACCOUNT IS CLOSED
      *
     C     @RTCD         IFNE      *BLANKS
     C*****##PREC        ANDNE     'Y'                                                196461 BUG6010
     C     RECI          ORNE      'D'
     C*****##PREC        ANDNE     'Y'                                                196461 BUG6010
     C     ACST          OREQ      'C'
     C*****##PREC        ANDNE     'Y'                                                196461 BUG6010
     C                   IF        ##PREC = 'Y'                                              BUG6010
     C                   IF        ##ACTN <> 'R'                                             BUG6010
     C                   EVAL      WIdx = WIdx + 1                                           BUG6010
     C                   EVAL      WFldNameArr(WIdx) = 'DDRONX'                              BUG6010
     C                   EVAL      WMsgIDArr(WIdx) = 'ESM1111'                               BUG6010
     C                   ENDIF                                                               BUG6010
     C                   ELSE                                                                BUG6010
     C**********         IF        ##ACTN <> 'R' AND ##PREC <> 'Y'                AR1096686 MD021526
     C**********                   AND ACST = 'C' AND @RTCD = '*ACST'             AR1096686 MD021526
     C**********         EVAL      WIdx = WIdx + 1                                AR1096686 MD021526
     C**********         EVAL      WFldNameArr(WIdx) = 'DDRONX'                   AR1096686 MD021526
     C**********         EVAL      WMsgIDArr(WIdx) = 'ESM1111'                    AR1096686 MD021526
     C**********         EVAL      WARN_RFLAG = 'Y'                               AR1096686 MD021526
     C**********         ENDIF                                                    AR1096686 MD021526
      *****************************************************************           AR1096686 MD021526
      ***Bypass*error*message*when*warning*is*already*been*issued******           AR1096686 MD021526
      *****************************************************************           AR1096686 MD021526
     C**********         IF        WARN_RFLAG <> 'Y'                              AR1096686 MD021526
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0911'
     C                   MOVE      'N'           DDRonxOK
     C**********         ENDIF                                                    AR1096686 MD021526
     C                   ENDIF                                                               BUG6010
     C                   ELSE
      *
     C                   MOVE      'Y'           W#ACOPEN
      *
      ** Ensure account is not blocked for Debit/Credit
      *
     C                   TESTB     '2'           RETB                     91    DEBIT
     C**********         TESTB     '3'           RETB                     92    CREDIT        182114
     C/COPY WNCPYSRC,ZAH00048
      *
      ** A/C IS BLOCKED
      *
     C     ##PREC        IFNE      'Y'                                                        260863
     C     *IN91         IFEQ      '1'
     C******IN92         OREQ      '1'                                                        182114
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0991'
     C                   MOVE      'N'           DDRonxOK
     C                   END
     C                   ENDIF                                                                260863
      *
      ** SET UP SETTLEMENT BRANCH
      *
     C                   MOVE      BRCA          DDROBR
     C                   MOVE      BRCA          FLROBR
      *
      ** IF SETL IS 14 AND NOSTRO IDENTIFIES A LIVE RECORD ON ACCNTAB
      ** RECEIPT CURRENCY MUST BE SAME AS CURRENCY OF ACCOUNT
      *
     C     E#RCCY        IFNE      CCY
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0914'
     C                   MOVE      'N'           DDRonxOK
      *
     C                   ELSE
      *
      ** IF NOT MULTIBRANCHING NOSTRO MUST BE IN SINGLE BRANCH
      *
     C     @MBIN         IFEQ      'N'
     C     BRCA          ANDNE     BJSBRC
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0888'
     C                   MOVE      'N'           DDRonxOK
     C                   END
     C*
     C                   END
     C                   END
                                                                                              CRE008
      ** Set up Account ID for Overdraft Limit Check                                          CRE008
                                                                                              CRE008
     C                   IF        CDL008 = 'Y'                                               CRE008
     C                             OR CGL014 = 'Y'                                            CGL014
     C                   EVAL      WkCust = CNUM                                              CRE008
     C                   EVAL      WkCcy  = CCY                                               CRE008
     C                   EVAL      WkACOD = ACOD                                              CRE008
     C                   EVAL      WkASeq = ACSQ                                              CRE008
     C                   EVAL      WkBRCA = BRCA                                              CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
     C                   END
     C/COPY WNCPYSRC,ZASETNVC03
     C                   END
      *
      ** IF SETL TYPE IS 01,02,05,07,08,12 OR 14 AND A/C IS NOT CLOSED
      ** THE DATE OF RECEIPT MUST NOT BE BEFORE THE DATE A/C OPENED
      *
     C     DDRSTM        IFEQ      '01'
     C     DDRSTM        OREQ      '02'
     C     DDRSTM        OREQ      '05'
     C     DDRSTM        OREQ      '07'
     C     DDRSTM        OREQ      '08'
     C     DDRSTM        OREQ      '12'
     C     DDRSTM        OREQ      '14'
      *
     C     W#ACOPEN      IFEQ      'Y'
     C     ##ACTN        ANDEQ     'I'                                                        185751
     C     ##DATR        ANDLT     DACO
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0912'
     C                   MOVE      'N'           DDRonxOK
     C                   END
      *
     C                   END
      *
      ** IF SETL TYPE IS 01,02,05,07,08,12 OR 14 AND A/C IS NOT CLOSED
      ** FOR RETAIL A/CS THE REC DATE CAN'T BE BEFORE THE BACK-VALUE PERIOD
      *
     C     DDRSTM        IFEQ      '01'
     C     DDRSTM        OREQ      '02'
     C     DDRSTM        OREQ      '05'
     C     DDRSTM        OREQ      '07'
     C     DDRSTM        OREQ      '08'
     C     DDRSTM        OREQ      '12'
     C     DDRSTM        OREQ      '14'
      *
     C     W#ACOPEN      IFEQ      'Y'
     C     ATYP          ANDEQ     'R'
     C     ##DATR        ANDLT     W#BVDT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0913'
     C                   MOVE      'N'           DDRonxOK
     C                   END
      *
     C                   END
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLROCN - VALIDATE RECEIVE ORDERING CUSTOMER                   *
     C*                                                               *
     C*****************************************************************
     C     VLROCN        BEGSR
      *
      * DETERMINE PARTY TYPE (CUSTOMER NO, SHORTNAME OR C/P NOSTRO)
      *
     C                   MOVE      *BLANKS       P#PART           10
     C                   MOVE      DDROCN        P#PART
     C                   MOVEL     'NOTALLOW'    @CPNAL            8
     C                   EXSR      PARTYT
                                                                                             CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EVAL      DDRSH4 = BBCSSN                                           CSF011A
     C                   EVAL      DDRRN4 = BBCRNM                                           CSF011A
     C                   EVAL      DDRRT4 = BBCRTN                                           CSF011A
     C                   EVAL      DDRSI4 = BBCSID                                           CSF011A
     C                   ENDIF                                                               CSF011A
      *
      * NO SELECTION
      *
     C     ##PREC        IFNE      'Y'                                                      AR641619
     C     @RTCD         IFEQ      '*NOSEL '
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDROCN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0868'
     C                   MOVE      'N'           DDRocnOK
     C                   GOTO      EVROCN
     C                   END
      *
      ** ERROR IF NOT A CUSTOMER NUMBER OR SHORTNAME
      *
     C     @PARTY        IFNE      'CUSTNUM'
     C     @PARTY        ANDNE     'CUSTSNM'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDROCN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0915'
     C                   MOVE      'N'           DDRocnOK
     C                   GOTO      EVROCN
     C                   END
      *
      ** Ordering customer can't be a bank
      *
     C     @BANK         IFEQ      'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDROCN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0803'
     C                   MOVE      'N'           DDRocnOK
     C                   GOTO      EVROCN
     C                   END
     C                   ENDIF                                                              AR641619
      *
      ** UPDATE OUTPUT FIELD
      *
     C                   MOVEL     BBCUST        FLROCN
      *
      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
      **   INTO SCREEN FIELD.
      *
     C                   MOVEL     DDROCN        @TSTQ             1
     C     @TSTQ         IFEQ      '?'
     C                   MOVEL     BBCSSN        DDROCN
     C                   END
      *
     C     EVROCN        ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLROBN - VALIDATE RECEIVE ORDERING BANK                       *
     C*                                                               *
     C*****************************************************************
     C     VLROBN        BEGSR
      *
      * DETERMINE PARTY TYPE (CUSTOMER NO, SHORTNAME OR C/P NOSTRO)
      *
     C                   MOVE      *BLANKS       P#PART
     C                   MOVE      DDROBN        P#PART
     C                   MOVEL     'NOTALLOW'    @CPNAL
     C                   EXSR      PARTYT
                                                                                             CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EVAL      DDRSH3 = BBCSSN                                           CSF011A
     C                   EVAL      DDRRN3 = BBCRNM                                           CSF011A
     C                   EVAL      DDRRT3 = BBCRTN                                           CSF011A
     C                   EVAL      DDRSI3 = BBCSID                                           CSF011A
     C                   ENDIF                                                               CSF011A
      *
      * NO SELECTION
      *
     C     ##PREC        IFNE      'Y'                                                      AR641619
     C     @RTCD         IFEQ      '*NOSEL '
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDROBN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0869'
     C                   MOVE      'N'           DDRobnOK
     C                   GOTO      EVROBN
     C                   END
      *
      ** ERROR IF NOT A CUSTOMER NUMBER OR SHORTNAME
      *
     C     @PARTY        IFNE      'CUSTNUM'
     C     @PARTY        ANDNE     'CUSTSNM'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDROBN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0917'
     C                   MOVE      'N'           DDRobnOK
     C                   GOTO      EVROBN
     C                   END
      *
      ** Ordering bank must be a bank
      *
     C     @BANK         IFNE      'Y'
     C*****DDRSTM        ANDEQ     '08'                                                194282 239836
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDROBN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0918'
     C                   MOVE      'N'           DDRobnOK
     C                   GOTO      EVROBN
     C                   END
      *
     C*****BBBNBI        IFNE      'Y'                                                 194282 239836
     C*****DDRSTM        ANDNE     '08'                                                194282 239836
     C**********         MOVE      'N'           @BANK                                 194282 239836
     C**********         ELSE                                                          194282 239836
     C**********         MOVE      'Y'           @BANK                                 194282 239836
     C**********         END                                                           194282 239836
      *                                                                                       194282
     C*****@BANK         IFNE      'Y'                                                 194282 239836
     C*****DDRSTM        ANDNE     '08'                                                194282 239836
     C**********         ADD       1             Idx                                   194282 239836
     C**********         EVAL      FldNameArr(Idx) = 'DDROBN'                          194282 239836
     C**********         EVAL      MsgIDArr(Idx) = 'ESM1918'                           194282 239836
     C**********         MOVE      'N'           DDRobnOK                              194282 239836
     C**********         GOTO      EVROBN                                              194282 239836
     C**********         END                                                           194282 239836
     C                   ENDIF                                                              AR641619
      *                                                                                       194282
      ** UPDATE OUTPUT FIELD
      *
     C                   MOVEL     BBCUST        FLROBN
      *
      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
      **   INTO SCREEN FIELD.
      *
     C                   MOVEL     DDROBN        @TSTQ             1
     C     @TSTQ         IFEQ      '?'
     C                   MOVEL     BBCSSN        DDROBN
     C                   END
      *
     C     EVROBN        ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLROCB - VALIDATE RECEIVE ORDERING CUSTOMER & BANK            *
     C*                                                               *
     C*****************************************************************
     C     VLROCB        BEGSR
      *
      ** FOR SETTLEMENT TYPE 01 OR 08 EITHER ORDERING BANK OR ORDERING
      ** CUSTOMER MUST BE ENTERED
      *
     C     DDRSTM        IFEQ      '01'
     C     DDRSTM        OREQ      '08'
     C     DDROBN        IFEQ      *BLANKS
     C     DDROCN        ANDEQ     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDROCN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0699'
     C                   MOVE      'N'           DDRocnOK
     C                   MOVE      'N'           DDRobnOK
     C                   END
     C                   END
     C/COPY WNCPYSRC,ZASETNVC05
      *
      ** ENTRY IN BOTH RECEIPT ORDERING BANK AND ORDERING CUSTOMER NOT
      ** ALLOWED
      *
     C     DDRSTM        IFEQ      '09'                                                       CLE033
     C     CLE033        ANDEQ     'Y'                                                        CLE033
     C     DDROBN        IFNE      *BLANKS
     C     DDROCN        ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDROCN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0919'
     C                   MOVE      'N'           DDRocnOK
     C                   MOVE      'N'           DDRobnOK
     C                   END
     C                   ENDIF                                                                CLE033
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLRIBN - VALIDATE RECEIVE INTERMEDIARY BANK                   *
     C*                                                               *
     C*****************************************************************
     C     VLRIBN        BEGSR
      *
      * DETERMINE PARTY TYPE (CUSTOMER NO, SHORTNAME OR C/P NOSTRO)
      *
     C                   MOVE      *BLANKS       P#PART
     C                   MOVE      DDRIBN        P#PART
     C                   MOVEL     'ALLOWED '    @CPNAL
     C                   EXSR      PARTYT
                                                                                             CSF011A
     C                   IF        @PARTY = 'CUSTNUM'                                        CSF011A
     C                             OR @PARTY = 'CUSTSNM'                                     CSF011A
     C                   EVAL      DDRSH2 = BBCSSN                                           CSF011A
     C                   EVAL      DDRRN2 = BBCRNM                                           CSF011A
     C                   EVAL      DDRRT2 = BBCRTN                                           CSF011A
     C                   EVAL      DDRSI2 = BBCSID                                           CSF011A
     C                   ELSEIF    @PARTY = 'COUNTNS'                                        CSF011A
     C                   EVAL      DDRSH2 = AWCSN1  + AWCSN2                                 CSF011A
     C                   EVAL      DDRRN2 = AWCPNM                                           CSF011A
     C                   EVAL      DDRRT2 = AWCNTN                                           CSF011A
     C                   EVAL      DDRSI2 = AWSWID                                           CSF011A
     C                   ENDIF                                                               CSF011A
      *
      * NO SELECTION
      *
     C     ##PREC        IFNE      'Y'                                                      AR641619
     C     @RTCD         IFEQ      '*NOSEL '
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRIBN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0870'
     C                   MOVE      'N'           DDRibnOK
     C                   GOTO      EVRIBN
     C                   END
      *
      * ERROR
      *
     C     @PARTY        IFEQ      'ERROR'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRIBN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0922'
     C                   MOVE      'N'           DDRibnOK
     C                   GOTO      EVRIBN
     C                   END
     C                   ENDIF                                                              AR641619
      *
      * TEST 1ST DIGIT
      *
     C                   MOVEL     DDRIBN        @TSTQ
      *
      ** IF A CUSTOMER NUMBER OR SHORTNAME
      *
     C     @PARTY        IFEQ      'CUSTNUM'
     C     @PARTY        OREQ      'CUSTSNM'
      *
      **  ERROR IF NOT A BANK
      *
     C     @BANK         IFEQ      'Y'
     C                   MOVEL     BBCUST        FLRIBN
     C                   ELSE
     C     ##PREC        IFNE      'Y'                                                      AR641619
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRIBN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0923'
     C                   MOVE      'N'           DDRibnOK
     C                   GOTO      EVRIBN
     C                   ENDIF                                                              AR641619
     C                   END
      *
      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
      **   INTO SCREEN FIELD.
      *
     C     @TSTQ         IFEQ      '?'
     C                   MOVEL     BBCSSN        DDRIBN
     C                   END
      *
      ** ELSE IF A COUNTERPARTY NOSTRO
      *
     C                   ELSE
     C                   MOVEL     AWCPNC        FLRIBN
      *
      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
      **   INTO SCREEN FIELD.
      *
     C     @TSTQ         IFEQ      '?'
     C                   MOVEL     *BLANKS       DDRIBN
     C                   MOVEL     AWCPNC        DDRIBN
     C                   END
     C                   END
      *
      ** ENTRY MUST NOT BE THE SAME AS BRANCH INTERNAL CUSTOMER NUMBER
      ** OF THE RECEIVE NOSTRO
      *
     C     FLRIBN        IFNE      *BLANKS
     C     FLRIBN        ANDEQ     @RBICN
     C     ##PREC        ANDNE     'Y'                                                      AR641619
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRIBN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0926'
     C                   MOVE      'N'           DDRibnOK
     C                   END
      *
     C     EVRIBN        ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLRIBA - VALIDATE RECEIVE INTERMEDIARY BANK A/C LINE          *
     C*                                                               *
     C*****************************************************************
     C     VLRIBA        BEGSR
      *
     C                   MOVE      DDRIBA        L#XIBA
      *
      ** ENTRY IS ONLY ALLOWED IF ENTRY HAS BEEN MADE IN INTER. BANK
      *
     C     DDRIBN        IFEQ      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRIBA'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0924'
     C                   MOVE      'N'           DDRibaOK
     C                   GOTO      EVRIBA
     C                   END
      *                                                                                       193584
      * If Nostro is a CLS Dummy Nostro, this field must be blank.                            193584
      *                                                                                       193584
     C                   MOVE      DDRONS        A#OURA                                       193584
     C                   MOVE      E#RCCY        @CYCD                                        193584
     C                   MOVE      A#NOST        @NONB                                        193584
      *                                                                                       193584
      * ACCESS NOSTRO DETAILS                                                                 193584
      *                                                                                       193584
     C                   EXSR      ACNOST                                                     193584
      *                                                                                       193584
     C     A7CLSD        IFEQ      'Y'                                                        193584
     C                   ADD       1             Idx                                          193584
     C                   EVAL      FldNameArr(Idx) = 'DDRIBA'                                 193584
     C                   EVAL      MsgIDArr(Idx) = 'ESM0160'                                  193584
     C                   MOVEL     'N'           DDRibaOK                                     193584
     C                   GOTO      EVRIBA                                                     193584
     C                   END                                                                  193584
      *
      * Call Account Line Validation object
      *
      * Set up parameters
      *
     C                   MOVEL     *BLANKS       W0RTN
     C                   CLEAR                   I#PARM
     C                   MOVEL     'INBK '       I#VFLD
     C                   MOVEL     'REC'         I#PR
     C                   MOVEL     'X'           I#PRTT
     C                   MOVEL     DDRIBN        I#PRTY
     C                   MOVEL     E#PCCY        I#PCCY
     C                   MOVEL     E#RCCY        I#RCCY
     C                   MOVEL     DDRIBA        I#ACLN
     C                   MOVEL     DDPSTM        I#PSTM
     C                   MOVEL     DDRSTM        I#RSTM
     C                   MOVEL     '210'         I#MTYP
      *
      * Set up receive account information
      *
     C     DDRONS        IFNE      *BLANKS
     C                   SELECT
     C     DDROBR        WHENNE    *BLANKS
     C     DDRONS        CAT       DDROBR        I#RCAC
     C     DDRONS        WHENNE    *BLANKS
     C                   MOVEL     DDRONS        I#RCAC
     C                   ENDSL
     C                   ENDIF
      *
      * Set up Pay account information
      *
     C     DDPONS        IFNE      *BLANKS
     C                   SELECT
     C     DDPOBR        WHENNE    *BLANKS
     C     DDPONS        CAT       DDPOBR        I#PYAC
     C     DDPONS        WHENNE    *BLANKS
     C                   MOVEL     DDPONS        I#PYAC
     C                   ENDSL
     C                   ENDIF
      *
      * If extra message and Rec Corr. then set 5354 field
      *
     C     DDRVNO        IFNE      *BLANKS
     C     DDRCRN        ANDNE     *BLANKS
     C                   MOVEL     'Y'           I#5354
     C                   ENDIF
      *
      * Transaction Type
      *
     C                   MOVEL     ##TTYP        I#TTYP
      *
      * Set up Cover field
      *
     C                   MOVEL     DDCVMR        I#COVR
      *
     C                   CLEAR                   O#PARM
     C                   CLEAR                   E#PARM
      *
      * Send messages to correct calling process
      *
     C                   SELECT
     C     ##CALP        WHENEQ    'FXDL'
     C                   MOVEL     'ME9940'      E#CPGM
     C                   MOVEL     'DL'          I#MMOD
     C     ##CALP        WHENEQ    'LDNI'
     C                   MOVEL     'ME9940'      E#CPGM
     C                   MOVEL     'DL'          I#MMOD
     C     ##CALP        WHENEQ    'LEND'                                                     CAP068
     C     ##CALP        OREQ      'MAPY'                                                     239587
     C                   MOVEL     'ME9940'      E#CPGM                                       CAP068
     C                   MOVEL     'LE'          I#MMOD                                       CAP068
     C     ##CALP        WHENEQ    'SSI '
     C                   MOVEL     'SD0401R'     E#CPGM
     C                   MOVEL     'AT'          I#MMOD
     C                   OTHER
     C                   MOVEL     'ME9940'      E#CPGM
     C                   ENDSL
     C                   MOVEL     'MEC0019'     E#MSGD
     C                   MOVEL     'MEMSG'       E#MSGF
      *
     C                   CALL      'ME9940'
     C                   PARM                    W0RTN             7
     C                   PARM                    I#PARM                         I Input Parms
     C                   PARM                    O#PARM                         O Output Parms
     C                   PARM                    E#PARM                         E Error Inform
     C                   PARM                    Z#PARM          256            B User Defined
      *
      * A/c line modified
     C                   MOVEL     O#ACLN        DDRIBA
      *
      ** Subtract 1 from error array index
     C                   SUB       1             E#INDX
      *
      * On return, if errors copy into error array
      *
     C     E#ERRM        IFNE      *BLANKS
     C     1             DO        E#INDX        Q#                5 0
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRIBA'
     C                   MOVEL     'ESM0'        WMessageID        7
     C                   MOVE      O#E(Q#)       WMessageID
     C                   EVAL      MsgIDArr(Idx) = WMessageID
     C                   ENDDO
     C                   MOVEL     'N'           DDRibaOK
     C                   ENDIF
      *
      *  UPDATE OUTPUT FIELD
      *
     C                   MOVE      DDRIBA        FLRIBA
      *
     C     EVRIBA        ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLPSFD - VALIDATE PAYMENT SETTLEMENT FIELDS                   *
     C*                                                               *
     C*****************************************************************
     C     VLPSFD        BEGSR
      *
      ** ENTRY IN ALL PAYMENT INSTRUCTIONS PROHIBITED IF PAYMENT
      ** SETTLEMENT METHOD IS 00
      *
     C     DDPSTM        IFEQ      *BLANKS
      *
     C     DDPONS        IFNE      *BLANKS
     C     DDPOBN        ORNE      *BLANKS
     C     DDPOCN        ORNE      *BLANKS
     C     DDPIBN        ORNE      *BLANKS
     C     DDPIBA        ORNE      *BLANKS
     C     DDRCRN        ORNE      *BLANKS
     C     DDRCRA        ORNE      *BLANKS
     C     DDRVNO        ORNE      *BLANKS
     C     DDCVMR        ORNE      *BLANKS
     C     DDAWBN        ORNE      *BLANKS
     C     DDAWBA        ORNE      *BLANKS
     C     DDBENN        ORNE      *BLANKS
     C     DDBENA        ORNE      *BLANKS
     C     DDDTP1        ORNE      *BLANKS
     C     DDDTP2        ORNE      *BLANKS
     C     DDDTP3        ORNE      *BLANKS
     C     DDDTP4        ORNE      *BLANKS
     C     DDDCHG        ORNE      *BLANKS
     C     DDPOBR        ORNE      *BLANKS
     C     DDPMAC        ORNE      *BLANKS                                                    CDL018
     C     DDPEXR        ORNE      *BLANKS                                                    CLE031
     C     DDPEXI        ORNE      *BLANKS                                                    CLE031
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPSTM'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0929'
     C                   MOVE      'N'           DDPstmOK
     C                   END
     C                   END
      *
     C/COPY WNCPYSRC,ZASETNVC32
      ** ENTRY IN FOLLOWING FIELDS IS PROHIBITED UNLESS SETL. TYPE
      ** IS 01,07 OR 08.
      *
     C     DDPSTM        IFNE      '01'
     C     DDPSTM        ANDNE     '07'
     C     DDPSTM        ANDNE     '08'
     C     CLE033        ANDNE     'Y'                                                        CLE033
     C     DDPSTM        ORNE      '01'                                                       CLE033
     C     DDPSTM        ANDNE     '07'                                                       CLE033
     C     DDPSTM        ANDNE     '08'                                                       CLE033
     C     DDPSTM        ANDNE     '09'                                                       CLE033
     C     CLE033        ANDEQ     'Y'                                                        CLE033
     C/COPY WNCPYSRC,ZASETINVC3
      *
     C     DDPOCN        IFNE      *BLANKS
     C     DDPOBN        ORNE      *BLANKS
     C     DDPIBN        ORNE      *BLANKS
     C     DDPIBA        ORNE      *BLANKS
     C     DDRVNO        ORNE      *BLANKS
     C     DDCVMR        ORNE      *BLANKS
     C     DDRCRN        ORNE      *BLANKS
     C     DDRCRA        ORNE      *BLANKS
     C     DDAWBN        ORNE      *BLANKS
     C     DDAWBA        ORNE      *BLANKS
     C     DDBENN        ORNE      *BLANKS
     C     DDBENA        ORNE      *BLANKS
     C     DDDTP1        ORNE      *BLANKS
     C     DDDTP2        ORNE      *BLANKS
     C     DDDTP3        ORNE      *BLANKS
     C     DDDTP4        ORNE      *BLANKS
     C     DDDCHG        ORNE      *BLANKS
     C*
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPSTM'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0930'
     C                   MOVE      'N'           DDPstmOK
     C     DDPOCN        IFNE      *BLANKS
     C                   MOVE      'N'           DDPocnOK
     C                   END
     C     DDPOBN        IFNE      *BLANKS
     C                   MOVE      'N'           DDPobnOK
     C                   END
     C     DDPIBN        IFNE      *BLANKS
     C                   MOVE      'N'           DDPibnOK
     C                   END
     C     DDPIBA        IFNE      *BLANKS
     C                   MOVE      'N'           DDPibaOK
     C                   END
     C     DDRVNO        IFNE      *BLANKS
     C                   MOVE      'N'           DDRvnoOK
     C                   END
     C     DDRCRN        IFNE      *BLANKS
     C                   MOVE      'N'           DDRcrnOK
     C                   END
     C     DDRCRA        IFNE      *BLANKS
     C                   MOVE      'N'           DDRcraOK
     C                   END
     C     DDAWBN        IFNE      *BLANKS
     C                   MOVE      'N'           DDAwbnOK
     C                   END
     C     DDAWBA        IFNE      *BLANKS
     C                   MOVE      'N'           DDAwbaOK
     C                   END
     C     DDBENN        IFNE      *BLANKS
     C                   MOVE      'N'           DDBennOK
     C                   END
     C     DDBENA        IFNE      *BLANKS
     C                   MOVE      'N'           DDBenaOK
     C                   END
     C*
     C                   END
     C                   END
      *                                                                                       CDL018
      ** Entry Prohibited for 'MORE A/C' unless Sett. Method is 05 or 14                      CDL018
      *                                                                                       CDL018
     C     CDL018        IFEQ      'Y'                                                        CDL018
      *                                                                                       CDL018
     C     DDPSTM        IFNE      '05'                                                       CDL018
     C     DDPSTM        ANDNE     '14'                                                       CDL018
      *                                                                                       CDL018
     C     DDPMAC        IFNE      *BLANKS                                                    CDL018
     C                   ADD       1             Idx                                          CDL018
     C                   EVAL      FldNameArr(Idx) = 'DDPSTM'                                 CDL018
     C                   EVAL      MsgIDArr(Idx) = 'ESM1000'                                  CDL018
     C                   MOVE      'N'           DDPmacOK                                     CDL018
     C                   ENDIF                                                                CDL018
     C                   ENDIF                                                                CDL018
      *                                                                                       CDL018
     C                   ENDIF                                                                CDL018
     C*
     C/COPY WNCPYSRC,ZASETNVC33
     C                   ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLRVNO - VALIDATE RECEIVE NUMBER                              *
     C*                                                               *
     C*****************************************************************
     C     VLRVNO        BEGSR
      *
      ** IF RECEIVER NUMBER ENTERED
      *
     C     DDRVNO        IFNE      *BLANKS
      *
      * DETERMINE PARTY TYPE (CUSTOMER NO OR SHORTNAME)
      *
     C                   MOVE      *BLANKS       P#PART
     C                   MOVE      DDRVNO        P#PART
     C                   MOVEL     'NOTALLOW'    @CPNAL
     C                   EXSR      PARTYT
                                                                                             CSF011A
      ** Populate Customer details                                                           CSF011A
                                                                                             CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EVAL      DDPSH2 = BBCSSN                                           CSF011A
     C                   EVAL      DDPRN2 = BBCRNM                                           CSF011A
     C                   EVAL      DDPRT2 = BBCRTN                                           CSF011A
     C                   EVAL      DDPSI2 = BBCSID                                           CSF011A
     C                   ENDIF                                                               CSF011A
      *
      * NO SELECTION
      *
     C     ##PPAY        IFNE      'Y'                                                      AR641619
     C     @RTCD         IFEQ      '*NOSEL '
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRVNO'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0871'
     C                   MOVE      'N'           DDRvnoOK
     C                   GOTO      EVRVNO
     C                   END
      *
      ** ERROR IF NOT A CUSTOMER NUMBER OR SHORTNAME
      *
     C     @PARTY        IFNE      'CUSTNUM'
     C     @PARTY        ANDNE     'CUSTSNM'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRVNO'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0952'
     C                   MOVE      'N'           DDRvnoOK
     C                   GOTO      EVRVNO
     C                   END
      *
      * CHECK RECIPIENT IS A BANK
      *
     C     @BANK         IFNE      'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRVNO'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0955'
     C                   MOVE      'N'           DDRvnoOK
     C                   GOTO      EVRVNO
     C                   END
     C                   ENDIF                                                              AR641619
      *
      ** UPDATE OUTPUT FIELD
      *
     C                   MOVEL     BBCUST        FLRVNO
      *
      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
      **   INTO SCREEN FIELD.
      *
     C                   MOVEL     DDRVNO        @TSTQ             1
     C     @TSTQ         IFEQ      '?'
     C                   MOVEL     BBCSSN        DDRVNO
     C                   END
      *
      ** RECEIVER MUST HAVE SWIFT ADDRESS, A STTX ADDRESS OR A TELEX
      ** ADDRESS
      *
     C     BBCSID        IFEQ      *BLANKS
     C     BBSTAD        ANDEQ     *BLANKS
     C     BBTXA1        ANDEQ     *BLANKS
     C     ##PPAY        ANDNE     'Y'                                                      AR641619
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRVNO'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0953'
     C                   MOVE      'N'           DDRvnoOK
     C                   END
      *
      **  CHECK COVER-MT202-REQUIRED IS "Y" OR "N"
      *
     C     DDCVMR        IFNE      'N'
     C     DDCVMR        ANDNE     'Y'
     C     ##PPAY        ANDNE     'Y'                                                      AR641619
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCVMR'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0889'
     C                   MOVE      'N'           DDCvmrOK
     C                   ELSE                                                   CAP003
     C                   MOVE      DDCVMR        FLCVMR                         CAP003
     C                   END
     C                   END
      *
      **  IF RECIPIENT OF PAYMENT INSTRUCTION HASN'T BEEN ENTERED,
      **  COVER-MT202-REQUIRED MUST BE BLANK
      *
     C     DDRVNO        IFEQ      *BLANKS
     C     DDCVMR        ANDNE     *BLANKS
     C     DDCVMR        ANDNE     'N'                                                       BUG7875
     C     ##PPAY        ANDNE     'Y'                                                      AR641619
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCVMR'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0890'
     C                   MOVE      'N'           DDCvmrOK
     C                   END
      *
     C/COPY WNCPYSRC,ZAH00005
     C     EVRVNO        ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLPSCY - VALIDATE PAYMENT SETTLEMENT CURRENCY                 *
     C*                                                               *
     C*****************************************************************
     C     VLPSCY        BEGSR
      *
      **  Access Currency Details
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      DDPSCY        @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      **  Payment settlement currency is invalid
      **  or not a dealing currency
      *
     C     @RTCD         IFNE      *BLANKS
     C     A6DLCI        ORNE      'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPSCY'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0848'
     C                   MOVE      'N'           DDPscyOK
     C                   ELSE
 
     C                   MOVEL     A6CYCD        DDPSCY
      *                                                                                       CLE031
      **  CLE031 enhancement allows settlement of In-ccy or Euro currency                     CLE031
      **  against other currencies                                                            CLE031
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C     ##CALP        ANDEQ     'LEND'                                                     CLE031
     C     CLE031        OREQ      'Y'                                                      AR853046
     C     ##CALP        ANDEQ     'MAPY'                                                   AR853046
     C                   MOVE      A6SPRT        AMPEXR                                       CLE031
     C                   MOVE      A6MDIN        AMPEXI                                       CLE031
     C                   MOVE      A6DLCI        BPDLCI            1                          CLE031
     C                   MOVE      A6INCY        BPINCY            1                          CLE031
      *                                                                                       CLE031
      **  Access Currency Details for transaction payment currency                            CLE031
      *                                                                                       CLE031
     C                   CALLB     'AOCURRR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*KEY    '    @OPTN                                        CLE031
     C                   PARM      ##PCCY        @CURR                                        CLE031
     C     SDCURR        PARM      SDCURR        DSSDY                                        CLE031
      *                                                                                       CLE031
     C                   MOVE      A6SPRT        APSPRT                                       CLE031
     C                   MOVE      A6MDIN        APMDIN                                       CLE031
     C                   MOVE      A6INCY        APINCY            1                          CLE031
      *                                                                                       CLE031
     C                   ELSE                                                                 CLE031
      *
      ** If the transaction payment currency is Euros
      *
     C     ##PCCY        IFEQ      BKEURO
      *
      ** Error if settlement currency is not an 'In' currency
      *
     C     A6INCY        IFNE      'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPSCY'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0853'
     C                   MOVE      'N'           DDPscyOK
     C                   ENDIF
      *
      ** If the transaction payment currency is NOT Euros (i.e. an 'in' ccy)
      *
     C                   ELSE
      *
      ** Error if settlement currency is not Euros
      *
     C     DDPSCY        IFNE      BKEURO
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPSCY'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0854'
     C                   MOVE      'N'           DDPscyOK
     C                   ELSE                                                   152344
      *                                                                         152344
      **  Access Currency Details for transaction payment currency              152344
      *                                                                         152344
     C                   CALLB     'AOCURRR0'                                   152344
     C                   PARM      *BLANKS       @RTCD                          152344
     C                   PARM      '*KEY    '    @OPTN                          152344
     C                   PARM      ##PCCY        @CURR                          152344
     C     SDCURR        PARM      SDCURR        DSSDY                          152344
      *                                                                         152344
      ** Error if payment currency is not an 'In' currency                      152344
      *                                                                         152344
     C     A6INCY        IFNE      'Y'                                          152344
     C                   ADD       1             Idx                            152344
     C                   EVAL      FldNameArr(Idx) = 'DDPSCY'                   152344
     C                   EVAL      MsgIDArr(Idx) = 'ESM0848'                    152344
     C                   MOVE      'N'           DDPscyOK                       152344
     C                   ENDIF                                                  152344
                                                                                152344
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   ENDIF
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
      *****************************************************************                       CDL018
      *                                                               *                       CDL018
      * VLPMAC - VALIDATE PAY MORE ACCOUNT                            *                       CDL018
      *                                                               *                       CDL018
      *****************************************************************                       CDL018
     C     VLPMAC        BEGSR                                                                CDL018
      *                                                                                       CDL018
      ** More Accounts only valid for Deal Types IP, IT, TI or TD                             CDL018
      *                                                                                       CDL018
     C     ##TTYP        IFNE      'IP'                                                       CDL018
     C     ##TTYP        ANDNE     'IT'                                                       CDL018
     C     ##TTYP        ANDNE     'TI'                                                       CDL018
     C     ##TTYP        ANDNE     'TD'                                                       CDL018
     C     DDPMAC        ANDNE     *BLANKS                                                    CDL018
     C                   ADD       1             Idx                                          CDL018
     C                   EVAL      FldNameArr(Idx) = 'DDPMAC'                                 CDL018
     C                   EVAL      MsgIDArr(Idx) = 'ESM1025'                                  CDL018
     C                   MOVE      'N'           DDPmacOK                                     CDL018
     C                   ENDIF                                                                CDL018
      *                                                                                       CDL018
      ** Must be 'Y', 'N' or blanks                                                           CDL018
      *                                                                                       CDL018
     C     DDPMAC        IFNE      *BLANKS                                                    CDL018
     C     DDPMAC        ANDNE     'Y'                                                        CDL018
     C     DDPMAC        ANDNE     'N'                                                        CDL018
     C                   ADD       1             Idx                                          CDL018
     C                   EVAL      FldNameArr(Idx) = 'DDPMAC'                                 CDL018
     C                   EVAL      MsgIDArr(Idx) = 'ESM1001'                                  CDL018
     C                   MOVE      'N'           DDPmacOK                                     CDL018
     C                   ENDIF                                                                CDL018
      *                                                                                       CDL018
     C                   ENDSR                                                                CDL018
      *****************************************************************                       CDL018
      /EJECT                                                                                  CDL018
      *****************************************************************                       CLE031
      *                                                               *                       CLE031
      * VLPEXR - VALIDATE PAYMENT EXCHANGE RATE                       *                       CLE031
      *                                                               *                       CLE031
      *****************************************************************                       CLE031
     C     VLPEXR        BEGSR                                                                CLE031
      *                                                                                       CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      DDPEXR        ZFIELD                                       CLE031
     C                   Z-ADD     5             ZADIG                                        CLE031
     C                   Z-ADD     8             ZADEC                                        CLE031
      *                                                                                       CLE031
     C                   CALLB     'ZALIGN'                                                   CLE031
     C**********         PARM      *BLANK        PRTCD                                 CLE031 CLE106
     C                   PARM      *BLANK        ZALIGNok                                     CLE106
     C                   PARM                    ZFIELD                                       CLE031
     C                   PARM                    ZADEC                                        CLE031
     C                   PARM                    ZADIG                                        CLE031
     C**********         PARM      *BLANKS       ZAVAL                                 CLE031 CLE106
      *                                                                                       CLE031
     C**********         MOVE      ZAVAL         WMPEXR           14 0                 CLE031 CLE106
     C*****ZAVAL         IFEQ      *BLANKS                                             CLE031 CLE106
     C                   MOVE      ZFIELD        WMPEXR           14 0                        CLE106
     C     ZFIELD        IFEQ      *BLANKS                                                    CLE106
     C                   Z-ADD     *ZEROS        WMPEXR                                       CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C     APINCY        IFNE      'Y'                                                        CLE031
      *                                                                                       CLE031
     C     DDPSCY        IFEQ      *BLANKS                                                    CLE031
     C     DDPEXR        ANDNE     *BLANKS                                                    CLE031
     C     WMPEXR        ANDNE     *ZEROS                                                     CLE031
     C     DDPSCY        OREQ      *BLANKS                                                    CLE031
     C     DDPEXI        ANDNE     *BLANKS                                                    CLE031
     C                   ADD       1             Idx                                          CLE031
     C                   EVAL      FldNameArr(Idx) = 'DDPexr'                                 CLE031
     C                   EVAL      MsgIDArr(Idx) = 'ESM0808'                                  CLE031
     C                   MOVE      'N'           DDPexrOK                                     CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C     ##PCCY        IFEQ      BKEURO                                                     CLE031
     C     BPINCY        ANDEQ     'Y'                                                        CLE031
     C     ##PCCY        OREQ      BKEURO                                                     CLE031
     C     DDPSCY        ANDEQ     BKEURO                                                     CLE031
      *                                                                                       CLE031
     C     DDPEXR        IFNE      *BLANKS                                                    CLE031
     C     WMPEXR        ANDNE     *ZEROS                                                     CLE031
     C     DDPEXI        ORNE      *BLANKS                                                    CLE031
     C                   ADD       1             Idx                                          CLE031
     C                   EVAL      FldNameArr(Idx) = 'DDPexr'                                 CLE031
     C                   EVAL      MsgIDArr(Idx) = 'ESM0809'                                  CLE031
     C                   MOVE      'N'           DDPexrOK                                     CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C     APINCY        IFNE      'Y'                                                        CLE031
     C     ##PCCY        ANDNE     BKEURO                                                     CLE031
     C     DDPSCY        ANDNE     *BLANKS                                                    CLE031
     C     BPINCY        ANDEQ     'Y'                                                        CLE031
     C                   ADD       1             Idx                                          CLE031
     C                   EVAL      FldNameArr(Idx) = 'DDPexr'                                 CLE031
     C                   EVAL      MsgIDArr(Idx) = 'ESM0811'                                  CLE031
     C                   MOVE      'N'           DDPexrOK                                     CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C     ##PPAY        IFNE      'Y'                                                        CLE031
     C     ##ACTN        OREQ      'X'                                                        CLE031
     C     DDPSCY        IFNE      *BLANKS                                                    CLE031
     C*****BPDLCI        ANDNE     'Y'                                               CLE031 MD020816
     C     BPDLCI        ANDEQ     'N'                                                      MD020816
     C                   ADD       1             Idx                                          CLE031
     C                   EVAL      FldNameArr(Idx) = 'DDPexr'                                 CLE031
     C                   EVAL      MsgIDArr(Idx) = 'ESM0813'                                  CLE031
     C                   MOVE      'N'           DDPexrOK                                     CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C     DDPSCY        IFEQ      ##PCCY                                                     CLE031
     C     DDPSCY        ANDNE     *BLANKS                                                    CLE031
     C                   ADD       1             Idx                                          CLE031
     C                   EVAL      FldNameArr(Idx) = 'DDPexr'                                 CLE031
     C                   EVAL      MsgIDArr(Idx) = 'ESM0815'                                  CLE031
     C                   MOVE      'N'           DDPexrOK                                     CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C     DDPexrOK      IFNE      'N'                                                        CLE031
     C                   MOVEL     *BLANKS       ZMDIX                                        CLE031
     C     DDPEXR        IFEQ      *BLANKS                                                    CLE031
     C     WMPEXR        OREQ      *ZEROS                                                     CLE031
     C     DDPSCY        IFNE      *BLANKS                                                    CLE031
     C     CLE033        IFEQ      'Y'                                                        CLE031
     C     SET09         ANDEQ     'T'                                                        CLE031
     C     DDPSTM        ANDEQ     '09'                                                       CLE031
      *                                                                                       CLE031
      ** Do not want exchange rate default in these circumstances                             CLE031
      *                                                                                       CLE031
     C                   ELSE                                                                 CLE031
      *                                                                                       CLE031
      ** Calculate cross rate from Receive Ccy to Receive Sett Ccy                            CLE031
      *                                                                                       CLE031
     C                   Z-ADD     APSPRT        ZRATE1                                       CLE031
     C                   MOVEL     APMDIN        ZMDI1                                        CLE031
     C                   Z-ADD     AMPEXR        ZRATE2                                       CLE031
     C                   MOVEL     AMPEXI        ZMDI2                                        CLE031
     C                   CALLB     'ZXRATE'                                                   CLE031
     C                   PARM                    ZRATE1           13 8                        CLE031
     C                   PARM                    ZMDI1             1                          CLE031
     C                   PARM                    ZRATE2           13 8                        CLE031
     C                   PARM                    ZMDI2             1                          CLE031
     C                   PARM                    ZRATEX           13 8                        CLE031
     C                   PARM                    ZMDIX             1                          CLE031
     C                   MOVE      ZRATEX        DDPEXC           14                          CLE031
     C                   MOVE      ZRATEX        DDPEXCR          13 8                        CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   ELSE                                                                 CLE031
      *                                                                                       CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      DDPEXR        ZFIELD           16                          CLE031
     C                   Z-ADD     5             ZADIG             2 0                        CLE031
     C                   Z-ADD     8             ZADEC             1 0                        CLE031
      *                                                                                       CLE031
     C                   CALLB     'ZALIGN'                                                   CLE031
     C**********         PARM      *BLANK        PRTCD                                 CLE031 CLE106
     C                   PARM      *BLANK        ZALIGNok                                     CLE106
     C                   PARM                    ZFIELD                                       CLE031
     C                   PARM                    ZADEC                                        CLE031
     C                   PARM                    ZADIG                                        CLE031
     C**********         PARM      *BLANKS       ZAVAL            16                   CLE031 CLE106
      *                                                                                       CLE031
     C*****PRTCD         IFNE      *BLANK                                              CLE031 CLE106
     C     ZALIGNok      IFNE      'Y'                                                        CLE106
     C                   ADD       1             Idx                                          CLE031
     C                   EVAL      FldNameArr(Idx) = 'DDPexr'                                 CLE031
     C                   EVAL      MsgIDArr(Idx) = 'ESM0866'                                  CLE031
     C                   MOVE      'N'           DDPexrOK                                     CLE031
     C                   ELSE                                                                 CLE031
     C**********         MOVE      ZAVAL         DDPEXC                                CLE031 CLE106
     C                   MOVE      ZFIELD        DDPEXC                                       CLE106
     C**********         MOVE      DDPEXR        DDPEXCR          13 8                 CLE031 CLE106
     C                   MOVE      DDPEXC        DDPEXCR          13 8                        CLE106
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C*****PRTCD         IFEQ      *BLANKS                                             CLE031 CLE106
     C     ZALIGNok      IFEQ      'Y'                                                        CLE106
     C     DDPEXC        ANDNE     *BLANKS                                                    CLE031
     C     DDPSCY        ANDNE     *BLANKS                                                    CLE031
     C                   MOVE      *BLANKS       ZFIELD                                       CLE031
     C                   MOVE      DDPEXC        ZFIELD                                       CLE031
     C                   Z-ADD     8             ZADEC                                        CLE031
     C                   CALLB     'ZEDIT'                                                    CLE031
     C                   PARM                    ZFIELD                                       CLE031
     C                   PARM                    ZADEC             1 0                        CLE031
     C                   MOVE      ZFIELD        DDPEXR                                       CLE031
     C                   Z-ADD     DDPEXCR       FLPEXR                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C     DDPexrOK      IFNE      'N'                                                        CLE031
     C     DDPEXI        IFNE      *BLANKS                                                    CLE031
     C     DDPEXI        ANDNE     'M'                                                        CLE031
     C     DDPEXI        ANDNE     'D'                                                        CLE031
     C                   ADD       1             Idx                                          CLE031
     C                   EVAL      FldNameArr(Idx) = 'DDPexi'                                 CLE031
     C                   EVAL      MsgIDArr(Idx) = 'ESM0880'                                  CLE031
     C                   MOVE      'N'           DDPexiOK                                     CLE031
     C                   ELSE                                                                 CLE031
      *                                                                                       CLE031
     C     DDPEXI        IFEQ      *BLANKS                                                    CLE031
     C     DDPEXR        ANDNE     *BLANKS                                                    CLE031
     C     CLE033        IFEQ      'Y'                                                        CLE031
     C     SET09         ANDEQ     'T'                                                        CLE031
     C     DDPSTM        ANDEQ     '09'                                                       CLE031
      *                                                                                       CLE031
      ** Do not want multiply/divide ind default in these circumstances                       CLE031
      *                                                                                       CLE031
     C                   ELSE                                                                 CLE031
     C     ZMDIX         IFNE      *BLANKS                                                    CLE031
     C                   MOVEL     ZMDIX         DDPEXI                                       CLE031
     C                   ELSE                                                                 CLE031
     C                   MOVE      AMREXI        DDPEXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
     C                   ENDIF                                                                CLE031
     C                   MOVEL     DDPEXI        FLPEXI                                       CLE031
      *                                                                                       CLE031
     C                   ELSE                                                                 CLE031
     C     DDPEXR        IFNE      *BLANKS                                                    CLE031
     C     WMPEXR        ANDNE     *ZEROS                                                     CLE031
     C                   ADD       1             Idx                                          CLE031
     C                   EVAL      FldNameArr(Idx) = 'DDPexr'                                 CLE031
     C                   EVAL      MsgIDArr(Idx) = 'ESM0809'                                  CLE031
     C                   MOVE      'N'           DDPexrOK                                     CLE031
     C                   ENDIF                                                                CLE031
     C     DDPEXI        IFNE      *BLANKS                                                    CLE031
     C                   ADD       1             Idx                                          CLE031
     C                   EVAL      FldNameArr(Idx) = 'DDPexi'                                 CLE031
     C                   EVAL      MsgIDArr(Idx) = 'ESM0809'                                  CLE031
     C                   MOVE      'N'           DDPexiOK                                     CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE031
     C                   ENDSR                                                                CLE031
      *****************************************************************                       CLE031
     C*****************************************************************
     C*                                                               *
     C* VLPSTM - VALIDATE PAYMENT SETTLEMENT METHOD                   *
     C*                                                               *
     C*****************************************************************
     C     VLPSTM        BEGSR
      *                                                                                       182114
      ** RESET A/C CLOSED INDICATOR                                                           182114
      *                                                                                       182114
     C                   MOVE      *BLANKS       W#ACOPEN                                     182114
     C/COPY WNCPYSRC,ZASETINV19                                                               CUT009
      *
      ** MUST BE 00,01,02,03,04,05,06,07,08,12 OR 14
      *
     C     DDPSTM        IFNE      '00'
     C     DDPSTM        ANDNE     '01'
     C     DDPSTM        ANDNE     '02'
     C     DDPSTM        ANDNE     '03'
     C     DDPSTM        ANDNE     '04'
     C     DDPSTM        ANDNE     '05'
     C     DDPSTM        ANDNE     '06'
     C     DDPSTM        ANDNE     '07'
     C     DDPSTM        ANDNE     '08'
     C     DDPSTM        ANDNE     '12'
     C     DDPSTM        ANDNE     '14'
     C     DDPSTM        ANDNE     '  '                                                       246120
     C     CLE033        ANDNE     'Y'                                                        CLE033
     C     DDPSTM        ORNE      '00'                                                       CLE033
     C     DDPSTM        ANDNE     '01'                                                       CLE033
     C     DDPSTM        ANDNE     '02'                                                       CLE033
     C     DDPSTM        ANDNE     '03'                                                       CLE033
     C     DDPSTM        ANDNE     '04'                                                       CLE033
     C     DDPSTM        ANDNE     '05'                                                       CLE033
     C     DDPSTM        ANDNE     '06'                                                       CLE033
     C     DDPSTM        ANDNE     '07'                                                       CLE033
     C     DDPSTM        ANDNE     '08'                                                       CLE033
     C     DDPSTM        ANDNE     '12'                                                       CLE033
     C     DDPSTM        ANDNE     '14'                                                       CLE033
     C     DDPSTM        ANDNE     '09'                                                       CLE033
     C     DDPSTM        ANDNE     '  '                                                       246120
     C     CLE033        ANDEQ     'Y'                                                        CLE033
     C/COPY WNCPYSRC,ZASETINVC4
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPSTM'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0931'
     C                   MOVE      'N'           DDPstmOK
     C                   END
     C/COPY WNCPYSRC,ZASETINV20                                                               CUT009
      *                                                                         CDL008
     C     CDL008        IFEQ      'Y'                                          CDL008
     C     ##CALP        ANDEQ     'FXDL'                                       CDL008
     C     ##TTYP        ANDEQ     'CL'                                         CDL008
     C     DDPSTM        ANDNE     '00'                                         CDL008
     C     DDPSTM        ANDNE     '01'                                         CDL008
     C     DDPSTM        ANDNE     '07'                                         CDL008
     C     DDPSTM        ANDNE     '08'                                         CDL008
     C     DDPSTM        ANDNE     '02'                                         CDL008
     C     DDPSTM        ANDNE     '12'                                         CDL008
     C                   ADD       1             Idx                            CDL008
     C                   EVAL      FldNameArr(Idx) = 'DDPSTM'                   CDL008
     C                   EVAL      MsgIDArr(Idx) = 'ESM0304'                    CDL008
     C                   MOVE      'N'           DDPstmOK                       CDL008
     C                   ENDIF                                                  CDL008
     C/COPY WNCPYSRC,ZASETNVC35
      *
      ** IF SETL TYPE IS 04 OR 14 THE RETAIL MODULE MUST BE PRESENT
      *
     C     DDPSTM        IFEQ      '04'
     C     DDPSTM        OREQ      '14'
     C     BGRTBN        IFNE      'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPSTM'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0932'
     C                   MOVE      'N'           DDPstmOK
     C                   END
     C                   END
      *
      ** IF PAY SETL METHOD IS 04 A LIVE RECORD MUST EXIST IN ACCNTAB
      *
     C     DDPSTM        IFEQ      '04'
     C                   MOVEL     ##CSNM        @ACID
     C                   MOVE      E#PCCY        @CYCD
     C                   MOVE      BMACCD        @ACCD
     C                   MOVE      '01'          @ACSN
     C                   MOVE      ##BRCA        @BRCA
      *
      ** SET UP SETTLEMENT BRANCH
      *
     C                   MOVE      ##BRCA        DDPOBR
     C                   MOVE      ##BRCA        FLPOBR
      *
      **  FOR STANDING DATA - EXTENDED SETTLEMENTS:
      **  WITH SETTLEMENT TYPE 04 CHECKING OF ACCOUNT WON'T BE DONE
      *
     C     ##CALP        IFNE      'SSI '
      *
      * ACCESS ACCOUNT DETAILS
      *
     C                   EXSR      ACACCT
      *
      * ACCOUNT IS CLOSED
      *
     C     @RTCD         IFNE      *BLANKS
     C*****##PPAY        ANDNE     'Y'                                                196461 BUG6010
     C     RECI          ORNE      'D'
     C*****##PPAY        ANDNE     'Y'                                                196461 BUG6010
     C     ACST          OREQ      'C'
     C*****##PPAY        ANDNE     'Y'                                                196461 BUG6010
     C                   IF        ##PPAY = 'Y'                                              BUG6010
     C                   IF        ##ACTN <> 'R'                                             BUG6010
     C                   EVAL      WIdx = WIdx + 1                                           BUG6010
     C                   EVAL      WFldNameArr(WIdx) = 'DDPSTM'                              BUG6010
     C                   EVAL      WMsgIDArr(WIdx) = 'ESM1134'                               BUG6010
     C                   ENDIF                                                               BUG6010
     C                   ELSE                                                                BUG6010
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPSTM'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0934'
     C                   MOVE      'N'           DDPstmOK
     C                   ENDIF                                                               BUG6010
     C                   ELSE                                                                 182114
      *                                                                                       182114
     C                   MOVE      'Y'           W#ACOPEN                                     182114
      *                                                                                       182114
      ** Ensure account is not blocked for Debit/Credit                                       182114
      *                                                                                       182114
     C                   TESTB     '3'           RETB                     92    CREDIT        182114
     C/COPY WNCPYSRC,ZAH00049
      *                                                                                       182114
      ** A/C IS BLOCKED                                                                       182114
      *                                                                                       182114
     C     ##PPAY        IFNE      'Y'                                                        260863
     C     *IN92         IFEQ      '1'                                                        182114
     C                   ADD       1             Idx                                          182114
     C                   EVAL      FldNameArr(Idx) = 'DDPONX'                                 182114
     C                   EVAL      MsgIDArr(Idx) = 'ESM0992'                                  182114
     C                   MOVE      'N'           DDPonxOK                                     182114
     C                   END                                                                  182114
     C                   ENDIF                                                                260863
     C                   END
      *
     C                   END
                                                                                              CGL014
     C                   IF        CGL014 = 'Y'                                               CGL014
     C                   EVAL      WPyCust = ##CSNM                                           CGL014
     C                   EVAL      WPyCcy  = E#PCCY                                           CGL014
     C                   EVAL      WPyACOD = BMACCD                                           CGL014
     C                   EVAL      WPyASEQ = '01'                                             CGL014
     C                   EVAL      WPyBRCA = ##BRCA                                           CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   END
      *
      ** IF SETTL. TYPE IS 07 THE PAYMENT CURRENCY MUST BE USD
      *
     C     DDPSTM        IFEQ      '07'
     C     E#PCCY        ANDNE     'USD'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPSTM'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0935'
     C                   MOVE      'N'           DDPstmOK
     C                   END
      *
      ** IF TYPE IS 14, RETAIL ACCOUNT NUMBERS MUST BE SUPPORTED
      *
     C     DDPSTM        IFEQ      '14'
     C     BMRANR        ANDNE     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPSTM'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0936'
     C                   MOVE      'N'           DDPstmOK
     C                   END
      *                                                                                       CLE033
      ** IF SETL TYPE IS 09, SET CORRECT CURRENCY UP ACCORDING TO                             CLE033
      ** SYSTEM VALUE                                                                         CLE033
      *                                                                                       CLE033
     C     DDPSTM        IFEQ      '09'                                                       CLE033
     C     CLE033        ANDEQ     'Y'                                                        CLE033
     C     A5ACTY        ANDEQ     'R'                                                        CLE033
      *                                                                                       CLE033
     C     DDPSCY        IFNE      *BLANKS                                                    CLE033
     C     SET09         ANDNE     'T'                                                        CLE033
     C                   MOVEL     DDPSCY        W0PSCY            3                          CLE033
     C                   ENDIF                                                                CLE033
      *                                                                                       CLE033
     C     DDPSCY        IFEQ      *BLANKS                                                    CLE033
     C     SET09         OREQ      'T'                                                        CLE033
     C                   MOVEL     ##PCCY        W0PSCY                                       CLE033
     C                   ENDIF                                                                CLE033
      *                                                                                       CLE033
     C                   MOVEL     P@VL02        W0ACCD           10                          CLE033
     C                   MOVEL     P@VL01        W0CNUM            6                          CLE033
      *                                                                                       CLE033
     **  For Settlement Type 09 for SSI, only partial checking of                             CLE033
     **  account entered can be done, as not all details are available.                       CLE033
     **  Therefore subroutine ACACCT should not be called.                                    CLE033
     C     ##CALP        IFNE      'SSI '                                                     CLE033
     C*                                                                                       CLE033
     C                   MOVEL     *BLANKS       @ACID                                        CLE033
     C                   MOVEL     W0CNUM        @ACID                                        CLE033
     C                   MOVE      W0PSCY        @CYCD                                        CLE033
     C                   MOVE      W0ACCD        @ACCD                                        CLE033
     C                   MOVE      '01'          @ACSN                                        CLE033
     C                   MOVE      ##BRCA        @BRCA                                        CLE033
     C                   EXSR      ACACCT                                                     CLE033
     C*                                                                                       CLE033
     C     @RTCD         IFNE      *BLANKS                                                    CLE033
     C     RECI          ORNE      'D'                                                        CLE033
     C     ATYP          ORNE      'R'                                                        CLE033
     C                   ADD       1             Idx                                          CLE033
     C                   EVAL      FldNameArr(Idx) = 'DDPSTM'                                 CLE033
     C                   EVAL      MsgIDArr(Idx) = 'ESM0934'                                  CLE033
     C                   MOVE      'N'           DDPstmOK                                     CLE033
     C                   ENDIF                                                                CLE033
     C*                                                                                       CLE033
     C                   ENDIF                                                                CLE033
      *                                                                                       CLE033
     C                   ENDIF                                                                CLE033
      *
     C/COPY WNCPYSRC,ZASETINVC5
     C                   ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLPOBR - VALIDATE PAYMENT SETTLEMENT BRANCH                   *
     C*                                                               *
     C*****************************************************************
     C     VLPOBR        BEGSR
      *
      ** IF SETTLEMENT METHOD IS 05
      *
     C     DDPSTM        IFEQ      '05'
      *
      ** SETTLEMENT BRANCH IS MANDATORY
      *
     C     DDPOBR        IFEQ      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0882'
     C                   MOVE      'N'           DDPonxOK
     C                   ELSE
      *
      ** NOW VALIDATE SETTLEMENT BRANCH
      *
     C                   MOVE      DDPOBR        @BRCA
     C                   EXSR      ACBRCH
      *
      * NO SELECTION
      *
     C     @RTCD         IFEQ      '*NOSEL '
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0864'
     C                   MOVE      'N'           DDPonxOK
     C                   END
      *
      * ERROR IN SETTLEMENT BRANCH
      *
     C     @RTCD         IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0881'
     C                   MOVE      'N'           DDPonxOK
     C                   ELSE
     C                   MOVE      @DSNB         DDPOBR
     C                   MOVE      @DSNB         FLPOBR
     C                   END
     C                   END
      *                                                                                       CLE033
     C                   ELSE                                                                 CLE033
     C     CLE033        IFEQ      'Y'                                                        CLE033
     C     DDPSTM        ANDEQ     '09'                                                       CLE033
     C                   MOVEL     DDPOBR        FLPOBR                                       CLE033
     C                   END                                                                  CLE033
      *                                                                                       CLE033
     C                   END
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLPONS - VALIDATE OUR PAYMENT NOSTRO                          *
     C*                                                               *
     C*****************************************************************
     C     VLPONS        BEGSR
     C/COPY WNCPYSRC,ZAH00011
      *
      ** RESET A/C CLOSED INDICATOR
      *
     C                   MOVE      *BLANKS       W#ACOPEN
      *
      ** MOVE OUR NOSTRO INTO OUR ACCOUNT DATA STRUCTURE
      *
     C                   MOVE      DDPONS        A#OURA
                                                                                             CSF011A
     C                   EVAL      SETTF = 'P'                                               CSF011A
      *
      ** OUR NOSTRO MUST BE BLANK IF SETTLEMENT TYPE IS 00,04 OR 06
      *
     C     DDPSTM        IFEQ      '00'
     C     DDPSTM        OREQ      '04'
     C     DDPSTM        OREQ      '06'
     C     DDPONS        IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0937'
     C                   MOVE      'N'           DDPonxOK
     C                   END
     C                   END
      *
      ** IF SETL TYPE IS 01,02,07,08 OR 12 MUST BE A 2 DIGIT NUMBER
      ** AND IDENTIFY A LIVE RECORD ON THE NOSTRO FILE SDNOSTPD
      *
     C     DDPSTM        IFEQ      '01'
     C     DDPSTM        OREQ      '02'
     C     DDPSTM        OREQ      '07'
     C     DDPSTM        OREQ      '08'
     C     DDPSTM        OREQ      '12'
     C/COPY WNCPYSRC,ZASETINVC6
      *
      ** CHECK OTHER 10 CHARACTERS ARE BLANK
      *
     C                   TESTN                   A#NOST               99
     C     *IN99         IFNE      '1'
     C     A#REST        ORNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0938'
     C                   MOVE      'N'           DDPonxOK
     C                   ELSE
      *
      * NOW VALIDATE NOSTRO CODE
      *
     C                   MOVE      E#PCCY        @CYCD
     C                   MOVE      A#NOST        @NONB
      *
      * ACCESS NOSTRO DETAILS
      *
     C                   EXSR      ACNOST
      *
      * NOSTRO NOT FOUND
      *
     C     @RTCD         IFNE      *BLANKS
     C                   IF        ##PPAY = 'Y'                                               260863
     C                   IF        ##ACTN <> 'R'                                              260863
     C                   EVAL      WIdx = WIdx + 1                                            260863
     C                   EVAL      WFldNameArr(WIdx) = 'DDPONX'                               260863
     C                   EVAL      WMsgIDArr(WIdx) = 'ESM1140'                                260863
     C                   MOVE      'W'           DDPonxOK                                     260863
     C                   ENDIF                                                                260863
     C                   ELSE                                                                 260863
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0938'
     C                   MOVE      'N'           DDPonxOK
     C                   ENDIF                                                                260863
     C                   ELSE
      *
      ** STORE CUSTOMER NUMBER OF OUR PAY NOSTRO FOR VALIDATION
      *
     C                   MOVEL     A7CUST        @PNOCN            8
     C/COPY WNCPYSRC,ZAH00012
      *
      ** NOSTRO GL ACCOUNT
      *
     C     CDL008        IFEQ      'Y'                                          CDL008
      *                                                                         CDL008
     C     ##TTYP        IFEQ      'CL'                                         CDL008
     C     ##CALP        ANDEQ     'FXDL'                                       CDL008
     C     A7CLSD        ANDNE     'Y'                                          CDL008
     C                   ADD       1             Idx                            CDL008
     C                   EVAL      FldNameArr(Idx) = 'DDPONX'                   CDL008
     C                   EVAL      MsgIDArr(Idx) = 'ESM0302'                    CDL008
     C                   MOVE      'N'           DDPonxOK                       CDL008
     C                   ENDIF                                                  CDL008
      *                                                                         CDL008
     C     ##TTYP        IFNE      'CL'                                         CDL008
     C     ##CALP        ANDEQ     'FXDL'                                       CDL008
     C     A7CLSD        ANDEQ     'Y'                                          CDL008
     C                   ADD       1             Idx                            CDL008
     C                   EVAL      FldNameArr(Idx) = 'DDPONX'                   CDL008
     C                   EVAL      MsgIDArr(Idx) = 'ESM0306'                    CDL008
     C                   MOVE      'N'           DDPonxOK                       CDL008
     C                   ENDIF                                                  CDL008
      *                                                                         CDL008
     C                   ENDIF                                                  CDL008
      *                                                                         CDL008
     C                   MOVEL     *BLANKS       @ACID
     C                   MOVEL     A7CUST        @ACID
     C                   MOVE      E#PCCY        @CYCD
     C                   MOVE      A7ACCD        @ACCD
     C                   MOVE      A7ACSN        @ACSN
     C                   MOVE      A7BRCD        @BRCA
      *
      ** SET UP SETTLEMENT BRANCH
      *
     C                   MOVE      A7BRCD        DDPOBR
     C                   MOVE      A7BRCD        FLPOBR
      *
      * ACCESS ACCOUNT DETAILS
      *
     C                   EXSR      ACACCT
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EXSR      CSFACT                                                    CSF011A
     C                   ENDIF                                                               CSF011A
      *
      * ACCOUNT IS CLOSED
      *
     C     @RTCD         IFNE      *BLANKS
     C*****##PPAY        ANDNE     'Y'                                                196461 BUG6010
     C     RECI          ORNE      'D'
     C*****##PPAY        ANDNE     'Y'                                                196461 BUG6010
      *                                                                                      BUG6010
      ** Warn if the account is closed.                                                      BUG6010
      *                                                                                      BUG6010
     C                   IF        ##ACTN <> 'R'                                             BUG6010
     C                   EVAL      WIdx = WIdx + 1                                           BUG6010
     C                   EVAL      WFldNameArr(WIdx) = 'DDPONX'                              BUG6010
     C                   EVAL      WMsgIDArr(WIdx) = 'ESM1138'                               BUG6010
     C                   ENDIF                                                               BUG6010
     C                   ELSE
      *
     C                   MOVE      'Y'           W#ACOPEN
      *                                                                                       182114
      ** Ensure account is not blocked for Debit/Credit                                       182114
      *                                                                                       182114
     C                   TESTB     '3'           RETB                     92    CREDIT        182114
     C/COPY WNCPYSRC,ZAH00050
      *                                                                                       182114
      ** A/C IS BLOCKED                                                                       182114
      *                                                                                       182114
     C     ##PPAY        IFNE      'Y'                                                        260863
     C     *IN92         IFEQ      '1'                                                        182114
     C                   ADD       1             Idx                                          182114
     C                   EVAL      FldNameArr(Idx) = 'DDPONX'                                 182114
     C                   EVAL      MsgIDArr(Idx) = 'ESM0992'                                  182114
     C                   MOVE      'N'           DDPonxOK                                     182114
     C                   END                                                                  182114
     C                   ENDIF                                                                260863
      *
      ** IF NOT MULTIBRANCHING NOSTRO MUST BE IN SINGLE BRANCH
      *
     C     @MBIN         IFEQ      'N'
     C     BJSBRC        ANDNE     A7BRCD
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0501'
     C                   MOVE      'N'           DDPonxOK
     C                   END
      *
      ** RETRIEVE BRANCH INTERNAL CUSTOMER NUMBER ASSOCIATED WITH
      ** NOSTRO BRANCH FOR VALIDATION LATER.
      *
     C                   MOVE      A7BRCD        @BRCA
     C                   EXSR      ACBRCH
     C                   MOVEL     A8BICN        @PBICN            8
      *
     C                   END
     C                   END
     C                   END
     C                   END
      *
      ** IF SETTLEMENT TYPE IS 03, 'OUR NOSTRO' MUST EITHER BE BLANK OR
      ** CONTAIN A SIX DIGIT DEAL NUMBER (TO COMPENSATE AGAINST).
      *
     C     DDPSTM        IFEQ      '03'
     C     A#OURA        ANDNE     *BLANKS
     C                   TESTN                   A#CNUM               99
     C     *IN99         IFNE      '1'
     C     A#ACAS        ORNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0939'
     C                   MOVE      'N'           DDPonxOK
     C                   ELSE                                                                CSF011A
     C                   EVAL      @RTCD = *BLANKS                                           CSF011A
     C                   EVAL      W@TYPE = 'CUST'                                           CSF011A
     C                   EXSR      CSFACT                                                    CSF011A
     C                   END
     C                   END
      *
      ** IF SETLEMENT TYPE IS 05 MUST IDENTIFY A LIVE RECORD ON ACCNTAB
      ** (IN COMBINATION WITH PAYMENT CURRENCY)
      *
     C     DDPSTM        IFEQ      '05'
      *
     C                   MOVEL     DDPONX        WDPONX           21                       MD024884A
     C     DDPONX        IFNE      *BLANKS                                                  BUG12624
     C     A#ACSQ        IFEQ      *BLANKS
     C     A#ACSQ        OREQ      '00'
     C                   MOVE      '01'          A#ACSQ
     C                   MOVE      A#ACSQ        DDPONX                                      BUG6393
     C                   END
      *
     C**********         TESTN                   A#CNUM               99                      CSD027
     C***99*****         TESTN                   A#ACOD               99                      CSD027
     C                   TESTN                   A#ACOD               99                      CSD027
     C   99              TESTN                   A#ACSQ               99
      *
      ** INVALID CUSTOMER, A/C CODE & A/C SEQUENCE
      *
     C     *IN99         IFNE      '1'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0940'
     C                   MOVE      'N'           DDPonxOK
     C                   ELSE
      *
     C                   MOVEL     *BLANKS       @ACID
     C                   MOVEL     A#CNUM        @ACID
     C                   MOVE      E#PCCY        @CYCD
     C                   MOVE      A#ACSQ        @ACSN
     C                   MOVE      A#ACOD        @ACCD
      *
      * Default branch
      *
     C     @MBIN         IFEQ      'N'
     C                   MOVE      BJSBRC        DDPOBR
     C                   MOVE      BJSBRC        FLPOBR
     C                   END
      *
     C                   MOVE      DDPOBR        @BRCA
      *
      * ACCESS ACCOUNT DETAILS
      *
     C                   EXSR      ACACCT
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EXSR      CSFACT                                                    CSF011A
     C                   ENDIF                                                               CSF011A
      *
      * ACCOUNT IS CLOSED
      *
     C     @RTCD         IFNE      *BLANKS
     C*****##PPAY        ANDNE     'Y'                                                196461 BUG6010
     C     RECI          ORNE      'D'
     C*****##PPAY        ANDNE     'Y'                                                196461 BUG6010
     C     ACST          OREQ      'C'
     C*****##PPAY        ANDNE     'Y'                                                196461 BUG6010
     C                   IF        ##PPAY = 'Y'                                              BUG6010
     C                   IF        ##ACTN <> 'R'                                             BUG6010
     C                   EVAL      WIdx = WIdx + 1                                           BUG6010
     C                   EVAL      WFldNameArr(WIdx) = 'DDPONX'                              BUG6010
     C                   EVAL      WMsgIDArr(WIdx) = 'ESM1140'                               BUG6010
     C                   ENDIF                                                               BUG6010
     C                   ELSE                                                                BUG6010
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0940'
     C                   MOVE      'N'           DDPonxOK
     C                   ENDIF                                                               BUG6010
     C                   ELSE
     C                   MOVE      'Y'           W#ACOPEN
     C                   MOVEL     A#OURA        DDPONS
      *                                                                                       182114
      ** Ensure account is not blocked for Debit/Credit                                       182114
      *                                                                                       182114
     C                   TESTB     '3'           RETB                     92    CREDIT        182114
     C/COPY WNCPYSRC,ZAH00051
      *                                                                                       182114
      ** A/C IS BLOCKED                                                                       182114
      *                                                                                       182114
     C     ##PPAY        IFNE      'Y'                                                        260863
     C     *IN92         IFEQ      '1'                                                        182114
     C                   ADD       1             Idx                                          182114
     C                   EVAL      FldNameArr(Idx) = 'DDPONX'                                 182114
     C                   EVAL      MsgIDArr(Idx) = 'ESM0992'                                  182114
     C                   MOVE      'N'           DDPonxOK                                     182114
     C                   END                                                                  182114
     C                   ENDIF                                                                260863
     C                   END
      *
     C                   END
     C                   ENDIF                                                              BUG12624
     C                   IF        DDPonxOK = 'N'                                          MD024884A
     C                   MOVEL     WDPONX        DDPONX                                    MD024884A
     C                   ENDIF                                                             MD024884A
     C                   END
      *
      ** IF SETL TYPE IS 14, NOSTRO MUST CONTAIN A 10 DIGIT NUMBER
      ** WHICH IDENTIFIES A LIVE RECORD ON FILE ACCNTAB
      *
     C     DDPSTM        IFEQ      '14'
     C                   TESTN                   A#RENO               99
      *
      ** INVALID RETAIL A/C NUMBER
      *
     C     *IN99         IFNE      '1'
     C     A#ACSQ        ORNE      *BLANKS
     C     A#RES2        ORNE      *BLANKS                                                    248393
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0941'
     C                   MOVE      'N'           DDPonxOK
     C                   ELSE
      *
     C                   MOVEL     A#RENO        @ACID
     C                   MOVE      *BLANKS       @CYCD
     C                   MOVE      *BLANKS       @ACSN
     C                   MOVE      *BLANKS       @ACCD
     C                   MOVE      *BLANKS       @BRCA
      *
      * ACCESS ACCOUNT DETAILS
      *
     C                   EXSR      ACACCT
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EXSR      CSFACT                                                    CSF011A
     C                   ENDIF                                                               CSF011A
      *
      * ACCOUNT IS CLOSED
      *
     C     @RTCD         IFNE      *BLANKS
     C*****##PPAY        ANDNE     'Y'                                                196461 BUG6010
     C     RECI          ORNE      'D'
     C*****##PPAY        ANDNE     'Y'                                                196461 BUG6010
     C     ACST          OREQ      'C'
     C*****##PPAY        ANDNE     'Y'                                                196461 BUG6010
     C                   IF        ##PPAY = 'Y'                                              BUG6010
     C                   IF        ##ACTN <> 'R'                                             BUG6010
     C                   EVAL      WIdx = WIdx + 1                                           BUG6010
     C                   EVAL      WFldNameArr(WIdx) = 'DDPONX'                              BUG6010
     C                   EVAL      WMsgIDArr(WIdx) = 'ESM1141'                               BUG6010
     C                   ENDIF                                                               BUG6010
     C                   ELSE                                                                BUG6010
     C**********         IF        ##ACTN <> 'R' AND ##PPAY <> 'Y'                AR1096686 MD021526
     C**********                   AND ACST = 'C' AND @RTCD = '*ACST'             AR1096686 MD021526
     C**********         EVAL      WIdx = WIdx + 1                                AR1096686 MD021526
     C**********         EVAL      WFldNameArr(WIdx) = 'DDPONX'                   AR1096686 MD021526
     C**********         EVAL      WMsgIDArr(WIdx) = 'ESM1141'                    AR1096686 MD021526
     C**********         EVAL      WARN_PFLAG = 'Y'                               AR1096686 MD021526
     C**********         ENDIF                                                    AR1096686 MD021526
      *****************************************************************           AR1096686 MD021526
      ***Bypass*error*message*when*warning*is*already*been*issued******           AR1096686 MD021526
      *****************************************************************           AR1096686 MD021526
     C**********         IF        WARN_PFLAG <> 'Y'                              AR1096686 MD021526
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0941'
     C                   MOVE      'N'           DDPonxOK
     C**********         ENDIF                                                    AR1096686 MD021526
     C                   ENDIF                                                               BUG6010
     C                   ELSE
      *
     C                   MOVE      'Y'           W#ACOPEN
      *
      ** Ensure account is not blocked for Debit/Credit
      *
     C**********         TESTB     '2'           RETB                     91    DEBIT         182114
     C                   TESTB     '3'           RETB                     92    CREDIT
     C/COPY WNCPYSRC,ZAH00052
      *
      ** A/C IS BLOCKED
      *
     C******IN91         IFEQ      '1'                                                        182114
     C******IN92         OREQ      '1'                                                        182114
     C     ##PPAY        IFNE      'Y'                                                        260863
     C     *IN92         IFEQ      '1'                                                        182114
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0992'
     C                   MOVE      'N'           DDPonxOK
     C                   END
     C                   ENDIF                                                                260863
      *
      ** SET UP SETTLEMENT BRANCH
      *
     C                   MOVE      BRCA          DDPOBR
     C                   MOVE      BRCA          FLPOBR
      *
      ** IF SETL IS 14 AND NOSTRO IDENTIFIES A LIVE RECORD ON ACCNTAB
      ** RECEIPT CURRENCY MUST BE SAME AS CURRENCY OF ACCOUNT
      *
     C     E#PCCY        IFNE      CCY
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0944'
     C                   MOVE      'N'           DDPonxOK
      *
     C                   ELSE
      *
      ** IF NOT MULTIBRANCHING NOSTRO MUST BE IN SINGLE BRANCH
      *
     C     @MBIN         IFEQ      'N'
     C     BRCA          ANDNE     BJSBRC
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0887'
     C                   MOVE      'N'           DDPonxOK
     C                   END
     C*
     C                   END
     C                   END
     C                   END
     C                   END
                                                                                              CGL014
     C                   IF        CGL014 = 'Y' AND DDPSTM = '14'                             CGL014
     C                             AND DDPonxOK <> 'N'                                        CGL014
     C                   MOVEL     A#RENO        WPyRetail                                    CGL014
     C                   ENDIF                                                                CGL014
      *
      ** IF SETL TYPE IS 01,02,05,07,08,12 OR 14 AND A/C IS NOT CLOSED
      ** THE DATE OF PAYMENT MUST NOT BE BEFORE THE DATE A/C OPENED
      *
     C     DDPSTM        IFEQ      '01'
     C     DDPSTM        OREQ      '02'
     C     DDPSTM        OREQ      '05'
     C     DDPSTM        OREQ      '07'
     C     DDPSTM        OREQ      '08'
     C     DDPSTM        OREQ      '12'
     C     DDPSTM        OREQ      '14'
      *
     C     W#ACOPEN      IFEQ      'Y'
     C     ##ACTN        ANDEQ     'I'                                                        207137
     C     ##DATP        ANDLT     DACO
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0942'
     C                   MOVE      'N'           DDPonxOK
     C                   END
      *
     C                   END
      *
      ** IF SETL TYPE IS 01,02,05,07,08,12 OR 14 AND A/C IS NOT CLOSED
      ** FOR RETAIL A/CS THE PAY DATE CAN'T BE BEFORE THE BACK-VALUE PERIOD
      *
     C     DDPSTM        IFEQ      '01'
     C     DDPSTM        OREQ      '02'
     C     DDPSTM        OREQ      '05'
     C     DDPSTM        OREQ      '07'
     C     DDPSTM        OREQ      '08'
     C     DDPSTM        OREQ      '12'
     C     DDPSTM        OREQ      '14'
      *
     C     W#ACOPEN      IFEQ      'Y'
     C     ATYP          ANDEQ     'R'
     C     ##DATP        ANDLT     W#BVDT
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPONX'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0943'
     C                   MOVE      'N'           DDPonxOK
     C                   END
     C*
     C                   END
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLPOCN - VALIDATE PAYMENT ORDERING CUSTOMER                   *
     C*                                                               *
     C*****************************************************************
     C     VLPOCN        BEGSR
      *
     C/COPY WNCPYSRC,ZASETINV03                                                               CUT009
      * DETERMINE PARTY TYPE (CUSTOMER NO, SHORTNAME OR C/P NOSTRO)
      *
     C                   MOVE      *BLANKS       P#PART
     C                   MOVE      DDPOCN        P#PART
     C                   MOVEL     'NOTALLOW'    @CPNAL
     C                   EXSR      PARTYT
                                                                                             CSF011A
      ** Populate customer details                                                           CSF011A
                                                                                             CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EVAL      DDPSH3 = BBCSSN                                           CSF011A
     C                   EVAL      DDPRN3 = BBCRNM                                           CSF011A
     C                   EVAL      DDPRT3 = BBCRTN                                           CSF011A
     C                   EVAL      DDPSI3 = BBCSID                                           CSF011A
     C                   ENDIF                                                               CSF011A
      *
      * NO SELECTION
      *
     C     ##PPAY        IFNE      'Y'                                                      AR641619
     C     @RTCD         IFEQ      '*NOSEL '
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPOCN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0872'
     C                   MOVE      'N'           DDPocnOK
     C                   GOTO      EVPOCN
     C                   END
      *
      ** ERROR IF NOT A CUSTOMER NUMBER OR SHORTNAME
      *
     C     @PARTY        IFNE      'CUSTNUM'
     C     @PARTY        ANDNE     'CUSTSNM'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPOCN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0946'
     C                   MOVE      'N'           DDPocnOK
     C                   GOTO      EVPOCN
     C                   END
      *
      ** Ordering customer can't be a bank
      *
     C     @BANK         IFEQ      'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPOCN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0804'
     C                   MOVE      'N'           DDPocnOK
     C                   GOTO      EVPOCN
     C                   END
     C                   ENDIF                                                              AR641619
      *
     C/COPY WNCPYSRC,ZASETINV04                                                               CUT009
      ** UPDATE OUTPUT FIELD
      *
     C                   MOVEL     BBCUST        FLPOCN
      *
      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
      **   INTO SCREEN FIELD.
      *
     C                   MOVEL     DDPOCN        @TSTQ             1
     C     @TSTQ         IFEQ      '?'
     C                   MOVEL     BBCSSN        DDPOCN
     C                   END
      *
     C     EVPOCN        ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLPOBN - VALIDATE PAYMENT ORDERING BANK                       *
     C*                                                               *
     C*****************************************************************
     C     VLPOBN        BEGSR
      *
      * DETERMINE PARTY TYPE (CUSTOMER NO, SHORTNAME OR C/P NOSTRO)
      *
     C                   MOVE      *BLANKS       P#PART
     C                   MOVE      DDPOBN        P#PART
     C                   MOVEL     'NOTALLOW'    @CPNAL
     C                   EXSR      PARTYT
                                                                                             CSF011A
      ** Populate customer details                                                           CSF011A
                                                                                             CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EVAL      DDPSH4 = BBCSSN                                           CSF011A
     C                   EVAL      DDPRN4 = BBCRNM                                           CSF011A
     C                   EVAL      DDPRT4 = BBCRTN                                           CSF011A
     C                   EVAL      DDPSI4 = BBCSID                                           CSF011A
     C                   ENDIF                                                               CSF011A
      *
      * NO SELECTION
      *
     C     ##PPAY        IFNE      'Y'                                                      AR641619
     C     @RTCD         IFEQ      '*NOSEL '
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPOBN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0873'
     C                   MOVE      'N'           DDPobnOK
     C                   GOTO      EVPOBN
     C                   END
      *
     C/COPY WNCPYSRC,ZASETINV05                                                               CUT009
      ** ERROR IF NOT A CUSTOMER NUMBER OR SHORTNAME
      *
     C     @PARTY        IFNE      'CUSTNUM'
     C     @PARTY        ANDNE     'CUSTSNM'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPOBN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0947'
     C                   MOVE      'N'           DDPobnOK
     C                   GOTO      EVPOBN
     C                   END
      *
      ** Ordering bank must be a bank
      *
     C     @BANK         IFNE      'Y'
     C*****DDPSTM        ANDEQ     '08'                                                194282 239836
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPOBN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0948'
     C                   MOVE      'N'           DDPobnOK
     C                   GOTO      EVPOBN
     C                   END
      *
     C*****BBBNBI        IFNE      'Y'                                                 194282 239836
     C*****DDPSTM        ANDNE     '08'                                                194282 239836
     C*********          MOVE      'N'           @BANK                                 194282 239836
     C*********          ELSE                                                          194282 239836
     C*********          MOVE      'Y'           @BANK                                 194282 239836
     C*********          END                                                           194282 239836
     C*****@BANK         IFNE      'Y'                                                 194282 239836
     C*****DDPSTM        ANDNE     '08'                                                194282 239836
     C*********          ADD       1             Idx                                   194282 239836
     C*********          EVAL      FldNameArr(Idx) = 'DDPOBN'                          194282 239836
     C*********          EVAL      MsgIDArr(Idx) = 'ESM1948'                           194282 239836
     C*********          MOVE      'N'           DDRobnOK                              194282 239836
     C*********          GOTO      EVPOBN                                              194282 239836
     C*********          END                                                           194282 239836
     C                   ENDIF                                                              AR641619
      *                                                                                       194282
      ** UPDATE OUTPUT FIELD
      *
     C                   MOVE      BBCUST        FLPOBN
      *
      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
      **   INTO SCREEN FIELD.
      *
     C                   MOVEL     DDPOBN        @TSTQ             1
     C     @TSTQ         IFEQ      '?'
     C                   MOVEL     BBCSSN        DDPOBN
     C                   END
      *
     C     EVPOBN        ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLPOCB - VALIDATE PAYMENT ORDERING CUSTOMER & BANK            *
     C*                                                               *
     C*****************************************************************
     C     VLPOCB        BEGSR
      *
      ** ORDERING BANK MUST NOT BE THE SAME AS ORDERING CUSTOMER
      *
     C*****FLPOBN        IFNE      *ZEROS                                                     CSD027
     C     FLPOBN        IFNE      *BLANKS                                                    CSD027
     C     FLPOBN        ANDEQ     FLPOCN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPOBN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0949'
     C                   MOVE      'N'           DDPobnOK
     C                   END
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLRCRN - VALIDATE RECEIVERS CORRESPONDENT                     *
     C*                                                               *
     C*****************************************************************
     C     VLRCRN        BEGSR
     C/COPY WNCPYSRC,ZAH00013
      *
      * DETERMINE PARTY TYPE (CUSTOMER NO, SHORTNAME OR C/P NOSTRO)
      *
     C                   MOVE      *BLANKS       P#PART
     C                   MOVE      DDRCRN        P#PART
     C                   MOVEL     'ALLOWED '    @CPNAL
     C/COPY WNCPYSRC,ZAH00018
     C                   EXSR      PARTYT
                                                                                             CSF011A
      ** Populate Customer details                                                           CSF011A
                                                                                             CSF011A
     C                   IF        @PARTY = 'CUSTNUM'                                        CSF011A
     C                             OR @PARTY = 'CUSTSNM'                                     CSF011A
     C                   EVAL      DDPSH5 = BBCSSN                                           CSF011A
     C                   EVAL      DDPRN5 = BBCRNM                                           CSF011A
     C                   EVAL      DDPRT5 = BBCRTN                                           CSF011A
     C                   EVAL      DDPSI5 = BBCSID                                           CSF011A
     C                   ELSEIF    @PARTY  = 'COUNTNS'                                       CSF011A
     C                   EVAL      DDPSH5 = AWCSN1 + AWCSN2                                  CSF011A
     C                   EVAL      DDPRN5 = AWCPNM                                           CSF011A
     C                   EVAL      DDPRT5 = AWCNTN                                           CSF011A
     C                   EVAL      DDPSI5 = AWSWID                                           CSF011A
     C                   ENDIF                                                               CSF011A
      *
      * NO SELECTION
      *
     C     ##PPAY        IFNE      'Y'                                                      AR641619
     C     @RTCD         IFEQ      '*NOSEL '
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRCRN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0874'
     C                   MOVE      'N'           DDRcrnOK
     C                   GOTO      EVRCRN
     C                   END
      *
      ** ERROR
      *
     C     @PARTY        IFEQ      'ERROR'
     C/COPY WNCPYSRC,ZAH00021
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRCRN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0957'
     C                   MOVE      'N'           DDRcrnOK
     C/COPY WNCPYSRC,ZAH00022
     C                   GOTO      EVRCRN
     C                   END
     C                   ENDIF                                                              AR641619
      *
      * TEST 1ST DIGIT
      *
     C                   MOVEL     DDRCRN        @TSTQ
      *
      ** IF A CUSTOMER NUMBER OR SHORTNAME
      *
     C     @PARTY        IFEQ      'CUSTNUM'
     C     @PARTY        OREQ      'CUSTSNM'
      *
      **  ERROR IF NOT A BANK
      *
     C     @BANK         IFEQ      'Y'
     C                   MOVEL     BBCUST        FLRCRN
     C/COPY WNCPYSRC,ZAH00014
     C                   ELSE
     C     ##PPAY        IFNE      'Y'                                                      AR641619
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRCRN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0958'
     C                   MOVE      'N'           DDRcrnOK
     C                   GOTO      EVRCRN
     C                   ENDIF                                                              AR641619
     C                   END
      *
      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
      **   INTO SCREEN FIELD.
      *
     C     @TSTQ         IFEQ      '?'
     C                   MOVEL     BBCSSN        DDRCRN
     C                   END
      *
      ** ELSE IF A COUNTERPARTY NOSTRO
      *
     C                   ELSE
     C                   MOVEL     AWCPNC        FLRCRN
      *
      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
      **   INTO SCREEN FIELD.
      *
     C     @TSTQ         IFEQ      '?'
     C                   MOVE      *BLANKS       DDRCRN
     C                   MOVEL     AWCPNC        DDRCRN
     C                   END
     C                   END
     C/COPY WNCPYSRC,ZAH00015
      *
     C     EVRCRN        ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLRCRA - VALIDATE RECEIVERS CORRESPONDENT A/C LINE            *
     C*                                                               *
     C*****************************************************************
     C     VLRCRA        BEGSR
      *
      ** ENTRY IS ONLY ALLOWED IF ENTRY HAS BEEN MADE IN REC. CORR.
      *
     C     DDRCRN        IFEQ      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRCRN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0899'
     C                   MOVE      'N'           DDRcrnOK
     C                   END
      *
      ** FIRST TWO CHARACTERS MAY NOT BE '//'
      *
     C                   MOVE      DDRCRA        L#XIBA
     C     L#RCR2        IFEQ      '//'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRCRA'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0960'
     C                   MOVE      'N'           DDRcraOK
     C                   END
      *
      ** If 1st & 3rd character are '/',
      ** then 2nd character must be 'C' or 'D'.
      *
     C     L#XIB1        IFEQ      '/'
     C     L#XIBE        ANDEQ     '/'
     C     L#XIB2        IFNE      'C'
     C     L#XIB2        ANDNE     'D'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRCRA'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0201'
     C                   MOVE      'N'           DDRcraOK
     C                   END
     C                   END
      *
      * UPDATE OUTPUT FIELD
      *
     C                   MOVEL     DDRCRA        FLRCRA
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLPIBN - VALIDATE PAYMENT INTERMEDIARY BANK                   *
     C*                                                               *
     C*****************************************************************
     C     VLPIBN        BEGSR
      *
      * DETERMINE PARTY TYPE (CUSTOMER NO, SHORTNAME OR C/P NOSTRO)
      *
     C                   MOVE      *BLANKS       P#PART
     C                   MOVE      DDPIBN        P#PART
     C                   MOVEL     'ALLOWED '    @CPNAL
     C     DDPSTM        IFEQ      '07'
     C                   MOVEL     'NOTALLOW'    @CPNAL
     C                   END
     C                   EXSR      PARTYT
                                                                                             CSF011A
      ** Populate customer details                                                           CSF011A
                                                                                             CSF011A
     C                   IF        @PARTY = 'CUSTNUM'                                        CSF011A
     C                             OR @PARTY = 'CUSTSNM'                                     CSF011A
     C                   EVAL      DDPSH6 = BBCSSN                                           CSF011A
     C                   EVAL      DDPRN6 = BBCRNM                                           CSF011A
     C                   EVAL      DDPRT6 = BBCRTN                                           CSF011A
     C                   EVAL      DDPSI6 = BBCSID                                           CSF011A
     C                   ELSEIF    @PARTY = 'COUNTNS'                                        CSF011A
     C                   EVAL      DDPSH6 = AWCSN1 + AWCSN2                                  CSF011A
     C                   EVAL      DDPRN6 = AWCPNM                                           CSF011A
     C                   EVAL      DDPRT6 = AWCNTN                                           CSF011A
     C                   EVAL      DDPSI6 = AWSWID                                           CSF011A
     C                   ENDIF                                                               CSF011A
      *
      * NO SELECTION
      *
     C     ##PPAY        IFNE      'Y'                                                      AR641619
     C     @RTCD         IFEQ      '*NOSEL '
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPIBN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0875'
     C                   MOVE      'N'           DDPibnOK
     C                   GOTO      EVPIBN
     C                   END
      *
      ** ERROR
      *
     C     @PARTY        IFEQ      'ERROR'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPIBN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0962'
     C                   MOVE      'N'           DDPibnOK
     C                   GOTO      EVPIBN
     C                   END
     C                   ENDIF                                                              AR641619
      *
      * TEST 1ST DIGIT
      *
     C                   MOVEL     DDPIBN        @TSTQ
      *
      ** IF A CUSTOMER NUMBER OR SHORTNAME
      *
     C     @PARTY        IFEQ      'CUSTNUM'
     C     @PARTY        OREQ      'CUSTSNM'
      *
      **  ERROR IF NOT A BANK
      *
     C     @BANK         IFEQ      'Y'
     C                   MOVEL     BBCUST        FLPIBN
     C                   ELSE
     C     ##PPAY        IFNE      'Y'                                                      AR641619
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPIBN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0963'
     C                   MOVE      'N'           DDPibnOK
     C                   GOTO      EVPIBN
     C                   ENDIF                                                              AR641619
     C                   END
      *
      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
      **   INTO SCREEN FIELD.
      *
     C     @TSTQ         IFEQ      '?'
     C                   MOVEL     BBCSSN        DDPIBN
     C                   END
      *
      ** ELSE IF A COUNTERPARTY NOSTRO
      *
     C                   ELSE
     C                   MOVEL     AWCPNC        FLPIBN
      *
      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
      **   INTO SCREEN FIELD.
      *
     C     @TSTQ         IFEQ      '?'
     C                   MOVE      *BLANKS       DDPIBN
     C                   MOVEL     AWCPNC        DDPIBN
     C                   END
     C                   END
      *
     C     EVPIBN        ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLPIBA - VALIDATE PAYMENT INTERMEDIARY BANK A/C LINE          *
     C*                                                               *
     C*****************************************************************
     C     VLPIBA        BEGSR
      *
     C                   MOVE      DDPIBA        L#XIBA
      *
      ** ENTRY IS ONLY ALLOWED IF ENTRY HAS BEEN MADE IN INTER. BANK
      *
     C     DDPIBN        IFEQ      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPIBA'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0965'
     C                   MOVE      'N'           DDPibaOK
     C                   GOTO      EVPIBA
     C                   END
      *                                                                                       193584
      * If Nostro is a CLS Dummy Nostro, field must be blank.                                 193584
      *                                                                                       193584
     C                   MOVE      DDPONS        A#OURA                                       193584
     C                   MOVE      E#PCCY        @CYCD                                        193584
     C                   MOVE      A#NOST        @NONB                                        193584
      *                                                                                       193584
      * ACCESS NOSTRO DETAILS                                                                 193584
      *                                                                                       193584
     C                   EXSR      ACNOST                                                     193584
      *                                                                                       193584
     C     A7CLSD        IFEQ      'Y'                                                        193584
     C                   ADD       1             Idx                                          193584
     C                   EVAL      FldNameArr(Idx) = 'DDPIBA'                                 193584
     C                   EVAL      MsgIDArr(Idx) = 'ESM0161'                                  193584
     C                   MOVE      'N'           DDPibaOK                                     193584
     C                   GOTO      EVPIBA                                                     193584
     C                   END                                                                  193584
      *
      * Call Account Line Validation object
      *
      * Set up parameters
      *
     C                   MOVEL     *BLANKS       W0RTN
     C                   CLEAR                   I#PARM
     C                   MOVEL     'INBK '       I#VFLD
     C                   MOVEL     'PAY'         I#PR
     C                   MOVEL     'X'           I#PRTT
     C                   MOVEL     DDPIBN        I#PRTY
     C                   MOVEL     E#PCCY        I#PCCY
     C                   MOVEL     E#RCCY        I#RCCY
     C                   MOVEL     DDPIBA        I#ACLN
     C                   MOVEL     DDPSTM        I#PSTM
     C                   MOVEL     DDRSTM        I#RSTM
     C     DDPOCN        IFNE      *BLANKS
                                                                                              CSW203
      ** Set I#MTYP to "103" instead of "100" if CSW203 is installed                          CSW203
                                                                                              CSW203
     C                   IF        CSW203 = 'Y'                                               CSW203
     C                   EVAL      I#MTYP = '103'                                             CSW203
     C                   ELSE                                                                 CSW203
     C                   MOVEL     '100'         I#MTYP
     C                   ENDIF                                                                CSW203
     C                   ELSE
     C                   MOVEL     '202'         I#MTYP
     C                   ENDIF
      *
      * Set up receive account information
      *
     C     DDRONS        IFNE      *BLANKS
     C                   SELECT
     C     DDROBR        WHENNE    *BLANKS
     C     DDRONS        CAT       DDROBR        I#RCAC
     C     DDRONS        WHENNE    *BLANKS
     C                   MOVEL     DDRONS        I#RCAC
     C                   ENDSL
     C                   ENDIF
      *
      * Set up Pay account information
      *
     C     DDPONS        IFNE      *BLANKS
     C                   SELECT
     C     DDPOBR        WHENNE    *BLANKS
     C     DDPONS        CAT       DDPOBR        I#PYAC
     C     DDPONS        WHENNE    *BLANKS
     C                   MOVEL     DDPONS        I#PYAC
     C                   ENDSL
     C                   ENDIF
      *
      * If extra message and Rec Corr. then set 5354 field
      *
     C     DDRVNO        IFNE      *BLANKS
     C     DDRCRN        ANDNE     *BLANKS
     C                   MOVEL     'Y'           I#5354
     C                   ENDIF
      *
      * Transaction Type
      *
     C                   MOVEL     ##TTYP        I#TTYP
      *
     C                   CLEAR                   O#PARM
     C                   CLEAR                   E#PARM
      *
      * Send messages to correct calling process
      *
     C                   SELECT
     C     ##CALP        WHENEQ    'FXDL'
     C                   MOVEL     'ME9940'      E#CPGM
     C                   MOVEL     'DL'          I#MMOD
     C     ##CALP        WHENEQ    'LDNI'
     C                   MOVEL     'ME9940'      E#CPGM
     C                   MOVEL     'DL'          I#MMOD
     C     ##CALP        WHENEQ    'LEND'                                                     CAP068
     C     ##CALP        OREQ      'MAPY'                                                     239587
     C                   MOVEL     'ME9940'      E#CPGM                                       CAP068
     C                   MOVEL     'LE'          I#MMOD                                       CAP068
     C     ##CALP        WHENEQ    'SSI '
     C                   MOVEL     'SD0401R'     E#CPGM
     C                   MOVEL     'AT'          I#MMOD
     C                   OTHER
     C                   MOVEL     'ME9940'      E#CPGM
     C                   ENDSL
     C                   MOVEL     'MEC0016'     E#MSGD
     C                   MOVEL     'MEMSG'       E#MSGF
      *
     C                   CALL      'ME9940'
     C                   PARM                    W0RTN             7
     C                   PARM                    I#PARM                         I Input Parms
     C                   PARM                    O#PARM                         O Output Parms
     C                   PARM                    E#PARM                         E Error Inform
     C                   PARM                    Z#PARM          256            B User Defined
      *
      * A/c line modified
     C                   MOVEL     O#ACLN        DDPIBA
      *
      ** Subtract 1 from error array index
     C                   SUB       1             E#INDX
      *
      * On return, if errors copy into error array
      *
     C     E#ERRM        IFNE      *BLANKS
     C     1             DO        E#INDX        Q#                5 0
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPIBA'
     C                   MOVEL     'ESM0'        WMessageID
     C                   MOVE      O#E(Q#)       WMessageID
     C                   EVAL      MsgIDArr(Idx) = WMessageID
     C                   ENDDO
     C                   MOVEL     'N'           DDPibaOK
     C                   ENDIF
      *
      * UPDATE OUTPUT FIELD
      *
     C                   MOVEL     DDPIBA        FLPIBA
      *
     C     EVPIBA        ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLAWBN - VALIDATE PAYMENT A/C WITH BANK                       *
     C*                                                               *
     C*****************************************************************
     C     VLAWBN        BEGSR
      *
      * DETERMINE PARTY TYPE (CUSTOMER NO, SHORTNAME OR C/P NOSTRO)
      *
     C                   MOVE      *BLANKS       P#PART
     C                   MOVE      DDAWBN        P#PART
     C                   MOVEL     'ALLOWED '    @CPNAL
     C     DDPSTM        IFEQ      '07'
     C                   MOVEL     'NOTALLOW'    @CPNAL
     C                   END
     C                   EXSR      PARTYT
                                                                                             CSF011A
     C                   IF        @PARTY = 'CUSTNUM'                                        CSF011A
     C                             OR @PARTY = 'CUSTSNM'                                     CSF011A
     C                   EVAL      DDPSH7 = BBCSSN                                           CSF011A
     C                   EVAL      DDPRN7 = BBCRNM                                           CSF011A
     C                   EVAL      DDPRT7 = BBCRTN                                           CSF011A
     C                   EVAL      DDPSI7 = BBCSID                                           CSF011A
     C                   ELSEIF    @PARTY = 'COUNTNS'                                        CSF011A
     C                   EVAL      DDPSH7 = AWCSN1 + AWCSN2                                  CSF011A
     C                   EVAL      DDPRN7 = AWCPNM                                           CSF011A
     C                   EVAL      DDPRT7 = AWCNTN                                           CSF011A
     C                   EVAL      DDPSI7 = AWSWID                                           CSF011A
     C                   ENDIF                                                               CSF011A
      *
      ** If no record selected from the Customer or Counterparty Nostro
      ** screens, or if field was neither of these, and only two
      ** characters have been entered into the field, check for a Nostro
      ** Number.
      *
     C     @RTCD         IFEQ      '*NOSEL '
     C     @PARTY        OREQ      'ERROR'
      *
      ** Set up work field for checking Nostro Number
      *
     C                   MOVEL     DDAWBN        W#AWBN
      *
      ** Align and check Nostro Number
      *
     C                   Z-ADD     1             @                 2 0
     C     *BLANKS       LOOKUP    W#AW(@)                            99
      *
      ** If a non-blank character was found:
      *
     C     *IN99         IFEQ      '1'
      *
     C                   MOVEL     *BLANKS       W#WK10           10
     C                   MOVEA     W#AW(@)       W#WK10
     C                   MOVE      W#WK10        W#AWBN
      *
      ** The first two characters of W#AWBN should now contain the Nostro
      ** Number; check that the remaining characters are blank
      *
     C     W#REST        IFEQ      *BLANKS
      *
      ** If they are, check whether the value in the first two characters
      ** is a valid Nostro Number
      *
     C                   MOVE      E#PCCY        @CYCD
     C                   MOVEL     W#NOST        @NONB
     C                   EXSR      ACNOST
                                                                                             CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EVAL      @CSCN  = A7CUST                                           CSF011A
     C                   EXSR      ACCUST                                                    CSF011A
     C                   EVAL      DDPSH7 = BBCSSN                                           CSF011A
     C                   EVAL      DDPRN7 = BBCRNM                                           CSF011A
     C                   EVAL      DDPRT7 = BBCRTN                                           CSF011A
     C                   EVAL      DDPSI7 = BBCSID                                           CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   END
     C                   END
     C                   END
      *
      * NO SELECTION
      *
     C     ##PPAY        IFNE      'Y'                                                      AR641619
     C     @RTCD         IFEQ      '*NOSEL '
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAWBN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0876'
     C                   MOVE      'N'           DDAwbnOK
     C                   GOTO      EVAWBN
     C                   END
      *
      * ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAWBN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0970'
     C                   MOVE      'N'           DDAwbnOK
     C                   GOTO      EVAWBN
     C                   END
     C                   ENDIF                                                              AR641619
      *
      * TEST 1ST DIGIT
      *
     C                   MOVEL     DDAWBN        @TSTQ
      *
      ** IF A CUSTOMER NUMBER OR SHORTNAME
      *
     C     @PARTY        IFEQ      'CUSTNUM'
     C     @PARTY        OREQ      'CUSTSNM'
     C/COPY WNCPYSRC,ZASETNVC09
      *
      **  ERROR IF NOT A BANK
      *
     C     @BANK         IFEQ      'Y'
     C                   MOVEL     BBCUST        FLAWBN
     C                   ELSE
     C     ##PPAY        IFNE      'Y'                                                      AR641619
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAWBN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0971'
     C                   MOVE      'N'           DDAwbnOK
     C                   GOTO      EVAWBN
     C                   ENDIF                                                              AR641619
     C                   END
     C/COPY WNCPYSRC,ZASETNVC10
      *
      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
      **   INTO SCREEN FIELD.
      *
     C     @TSTQ         IFEQ      '?'
     C                   MOVEL     BBCSSN        DDAWBN
     C                   END
      *
      ** ELSE IF A COUNTERPARTY NOSTRO
      *
     C                   ELSE
     C     @PARTY        IFEQ      'COUNTNS'
     C                   MOVEL     AWCPNC        FLAWBN
      *
      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
      **   INTO SCREEN FIELD.
      *
     C     @TSTQ         IFEQ      '?'
     C                   MOVE      *BLANKS       DDAWBN
     C                   MOVEL     AWCPNC        DDAWBN
     C                   END
      *
      ** ELSE IF A NOSTRO
      *
     C                   ELSE
     C                   MOVEL     A7CUST        FLAWBN
      *
      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
      **   INTO SCREEN FIELD.
      *
     C     @TSTQ         IFEQ      '?'
     C                   MOVE      *BLANKS       DDAWBN
     C                   MOVEL     A7CUST        DDAWBN
     C                   END
     C                   END
     C                   END
      *
     C     EVAWBN        ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLAWBA - VALIDATE PAYMENT A/C WITH BANK A/C LINE              *
     C*                                                               *
     C*****************************************************************
     C     VLAWBA        BEGSR
      *
     C                   MOVEL     DDAWBA        W#AW06            6
     C                   MOVE      DDAWBA        W#AW29           29
      *
      ** ACCOUNT WITH MUST BE BLANK IF 'DIRECT' ENTERED IN ACCOUNT WITH
      ** BANK A/C LINE
      *
     C     DDAWBN        IFNE      *BLANKS
     C     W#AW06        ANDEQ     'DIRECT'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAWBN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0973'
     C                   MOVE      'N'           DDAwbnOK
     C                   GOTO      EVAWBA
     C                   END
      *                                                                                       193584
      * If Nostro is a CLS Dummy Nostro, this field must be blank.                            193584
      *                                                                                       193584
     C                   MOVE      DDPONS        A#OURA                                       193584
     C                   MOVE      E#PCCY        @CYCD                                        193584
     C                   MOVE      A#NOST        @NONB                                        193584
      *                                                                                       193584
      * ACCESS NOSTRO DETAILS                                                                 193584
      *                                                                                       193584
     C                   EXSR      ACNOST                                                     193584
      *                                                                                       193584
     C     A7CLSD        IFEQ      'Y'                                                        193584
     C                   ADD       1             Idx                                          193584
     C                   EVAL      FldNameArr(Idx) = 'DDAWBA'                                 193584
     C                   EVAL      MsgIDArr(Idx) = 'ESM0162'                                  193584
     C                   MOVE      'N'           DDAwbaOK                                     193584
     C                   GOTO      EVAWBA                                                     193584
     C                   END                                                                  193584
      *
      ** AWBA MAY ONLY CONTAIN WORD 'DIRECT' WHEN AWBN BLANK
      *
     C     DDAWBN        IFEQ      *BLANKS
     C     DDAWBA        ANDNE     *BLANKS
     C     W#AW06        ANDNE     'DIRECT'
     C*
     C     DDAWBN        OREQ      *BLANKS
     C     DDAWBA        ANDNE     *BLANKS
     C     W#AW29        ANDNE     *BLANKS
     C*
     C     DDAWBN        OREQ      *BLANKS
     C     W#AW29        ANDNE     *BLANKS
     C*
     C     DDAWBN        ORNE      *BLANKS
     C     W#AW06        ANDEQ     'DIRECT'
     C     W#AW29        ANDEQ     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAWBA'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0974'
     C                   MOVE      'N'           DDAwbaOK
     C                   GOTO      EVAWBA
     C                   END
      *
     C     DDAWBA        IFNE      *BLANKS
     C     W#AW06        ANDNE     'DIRECT'
     C                   MOVE      DDAWBA        L#XIBA
      *
      ** FIRST CHARACTER MUST BE '/'
      *
     C     L#XIB1        IFNE      '/'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAWBA'
     C**********         EVAL      MsgIDArr(Idx) = 'ESM0974'                                  182652
     C                   EVAL      MsgIDArr(Idx) = 'ESM0502'                                  182652
     C                   MOVE      'N'           DDAwbaOK
     C                   END
      *
      * Call Account Line Validation object
      *
      * Set up parameters
      *
     C                   MOVEL     *BLANKS       W0RTN
     C                   CLEAR                   I#PARM
     C                   MOVEL     'AWBK '       I#VFLD
     C                   MOVEL     'PAY'         I#PR
     C                   MOVEL     'X'           I#PRTT
     C                   MOVEL     DDAWBN        I#PRTY
     C                   MOVEL     E#PCCY        I#PCCY
     C                   MOVEL     E#RCCY        I#RCCY
     C                   MOVEL     DDAWBA        I#ACLN
     C                   MOVEL     DDPSTM        I#PSTM
     C                   MOVEL     DDRSTM        I#RSTM
     C     DDPOCN        IFNE      *BLANKS
                                                                                              CSW203
      ** Set I#MTYP to "103" instead of "100" if CSW203 is installed                          CSW203
                                                                                              CSW203
     C                   IF        CSW203 = 'Y'                                               CSW203
     C                   EVAL      I#MTYP = '103'                                             CSW203
     C                   ELSE                                                                 CSW203
     C                   MOVEL     '100'         I#MTYP
     C                   ENDIF                                                                CSW203
     C                   ELSE
     C                   MOVEL     '202'         I#MTYP
     C                   ENDIF
      *
      * Set up receive account information
      *
     C     DDRONS        IFNE      *BLANKS
     C                   SELECT
     C     DDROBR        WHENNE    *BLANKS
     C     DDRONS        CAT       DDROBR        I#RCAC
     C     DDRONS        WHENNE    *BLANKS
     C                   MOVEL     DDRONS        I#RCAC
     C                   ENDSL
     C                   ENDIF
      *
      * Set up Pay account information
      *
     C     DDPONS        IFNE      *BLANKS
     C                   SELECT
     C     DDPOBR        WHENNE    *BLANKS
     C     DDPONS        CAT       DDPOBR        I#PYAC
     C     DDPONS        WHENNE    *BLANKS
     C                   MOVEL     DDPONS        I#PYAC
     C                   ENDSL
     C                   ENDIF
      *
      * If extra message and Rec Corr. then set 5354 field
      *
     C     DDRVNO        IFNE      *BLANKS
     C     DDRCRN        ANDNE     *BLANKS
     C                   MOVEL     'Y'           I#5354
     C                   ENDIF
      *
      * Transaction Type
      *
     C                   MOVEL     ##TTYP        I#TTYP
      *
     C                   CLEAR                   O#PARM
     C                   CLEAR                   E#PARM
      *
      * Send messages to correct calling process
      *
     C                   SELECT
     C     ##CALP        WHENEQ    'FXDL'
     C                   MOVEL     'ME9940'      E#CPGM
     C                   MOVEL     'DL'          I#MMOD
     C     ##CALP        WHENEQ    'LDNI'
     C                   MOVEL     'ME9940'      E#CPGM
     C                   MOVEL     'DL'          I#MMOD
     C     ##CALP        WHENEQ    'LEND'                                                     CAP068
     C     ##CALP        OREQ      'MAPY'                                                     239587
     C                   MOVEL     'ME9940'      E#CPGM                                       CAP068
     C                   MOVEL     'LE'          I#MMOD                                       CAP068
     C     ##CALP        WHENEQ    'SSI '
     C                   MOVEL     'SD0401R'     E#CPGM
     C                   MOVEL     'AT'          I#MMOD
     C                   OTHER
     C                   MOVEL     'ME9940'      E#CPGM
     C                   ENDSL
     C                   MOVEL     'MEC0017'     E#MSGD
     C                   MOVEL     'MEMSG'       E#MSGF
      *
     C                   CALL      'ME9940'
     C                   PARM                    W0RTN             7
     C                   PARM                    I#PARM                         I Input Parms
     C                   PARM                    O#PARM                         O Output Parms
     C                   PARM                    E#PARM                         E Error Inform
     C                   PARM                    Z#PARM          256            B User Defined
      *
      * A/c line modified
     C                   MOVEL     O#ACLN        DDAWBA
      *
      ** Subtract 1 from error array index
     C                   SUB       1             E#INDX
      *
      * On return if errors copy into error array
      *
     C     E#ERRM        IFNE      *BLANKS
     C     1             DO        E#INDX        Q#                5 0
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAWBA'
     C                   MOVEL     'ESM0'        WMessageID
     C                   MOVE      O#E(Q#)       WMessageID
     C                   EVAL      MsgIDArr(Idx) = WMessageID
     C                   ENDDO
     C                   MOVEL     'N'           DDAwbaOK
     C                   ENDIF
      *
     C                   ENDIF
      *
      * UPDATE OUTPUT FIELD
      *
     C                   MOVEL     DDAWBA        FLAWBA
      *
     C     EVAWBA        ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLBENN - VALIDATE BENEFICIARY                                 *
     C*                                                               *
     C*****************************************************************
     C     VLBENN        BEGSR
      *
      * DETERMINE PARTY TYPE (CUSTOMER NO, SHORTNAME OR C/P NOSTRO)
      *
     C                   MOVE      *BLANKS       P#PART
     C                   MOVE      DDBENN        P#PART
     C                   MOVEL     'ALLOWED '    @CPNAL
     C     DDPSTM        IFEQ      '07'
     C                   MOVEL     'NOTALLOW'    @CPNAL
     C                   END
     C                   EXSR      PARTYT
                                                                                             CSF011A
     C                   IF        @PARTY = 'CUSTNUM'                                        CSF011A
     C                             OR @PARTY = 'CUSTSNM'                                     CSF011A
     C                   EVAL      DDPSH8 = BBCSSN                                           CSF011A
     C                   EVAL      DDPRN8 = BBCRNM                                           CSF011A
     C                   EVAL      DDPRT8 = BBCRTN                                           CSF011A
     C                   EVAL      DDPSI8 = BBCSID                                           CSF011A
     C                   ELSEIF    @PARTY = 'COUNTNS'                                        CSF011A
     C                   EVAL      DDPSH8 = AWCSN1 + AWCSN2                                  CSF011A
     C                   EVAL      DDPRN8 = AWCPNM                                           CSF011A
     C                   EVAL      DDPRT8 = AWCNTN                                           CSF011A
     C                   EVAL      DDPSI7 = AWSWID                                           CSF011A
     C                   ENDIF                                                               CSF011A
      *
      * NO SELECTION
      *
     C     ##PPAY        IFNE      'Y'                                                      AR641619
     C     @RTCD         IFEQ      '*NOSEL '
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBENN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0877'
     C                   MOVE      'N'           DDBennOK
     C                   GOTO      EVBENN
     C                   END
      *
      ** ERROR IF NOT A CUSTOMER NUMBER OR SHORTNAME
      *
     C     @PARTY        IFEQ      'ERROR'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBENN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0978'
     C                   MOVE      'N'           DDBennOK
     C                   GOTO      EVBENN
     C                   END
     C                   ENDIF                                                              AR641619
      *
      * TEST 1ST DIGIT
      *
     C                   MOVEL     DDBENN        @TSTQ
      *
      ** IF A CUSTOMER NUMBER OR SHORTNAME
      *
     C     @PARTY        IFEQ      'CUSTNUM'
     C     @PARTY        OREQ      'CUSTSNM'
      *
      ** UPDATE OUTPUT FIELD
      *
     C                   MOVEL     BBCUST        FLBENN
      *                                                                                     AR892347
      ** UPDATE BENEFICIARY BANK/NON-BANK IND.                                              AR892347
      *                                                                                     AR892347
     C                   MOVEL     @BANK         @BBNBI                                     AR892347
      *
      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
      **   INTO SCREEN FIELD.
      *
     C     @TSTQ         IFEQ      '?'
     C                   MOVEL     BBCSSN        DDBENN
     C                   END
      *
      ** ELSE IF A COUNTERPARTY NOSTRO
      *
     C                   ELSE
      *
      ** UPDATE OUTPUT FIELD
      *
     C                   MOVEL     AWCPNC        FLBENN
      *
      **   CHECK IF '?' ENTERED, IF SO MOVE VALUE RETRIEVED
      **   INTO SCREEN FIELD.
      *
     C     @TSTQ         IFEQ      '?'
     C                   MOVE      *BLANKS       DDBENN
     C                   MOVEL     AWCPNC        DDBENN
     C                   END
      *
     C                   END
      *
     C     EVBENN        ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLBENA - VALIDATE BENEFICIARY A/C WITH LINE                   *
     C*                                                               *
     C*****************************************************************
     C     VLBENA        BEGSR
      *
     C                   MOVE      DDBENA        L#XIBA
      *
      ** ENTRY IS ONLY ALLOWED IF ENTRY HAS BEEN MADE IN BENEFICIARY
      *
     C     DDBENN        IFEQ      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBENN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0999'
     C                   MOVE      'N'           DDBennOK
     C                   GOTO      EVBENA
     C                   END
      *
      * Call Account Line Validation object
      *
      * Set up parameters
      *
     C                   MOVEL     *BLANKS       W0RTN
     C                   CLEAR                   I#PARM
     C                   MOVEL     'BENF '       I#VFLD
     C                   MOVEL     'PAY'         I#PR
     C                   MOVEL     'X'           I#PRTT
     C                   MOVEL     DDBENN        I#PRTY
     C                   MOVEL     E#PCCY        I#PCCY
     C                   MOVEL     E#RCCY        I#RCCY
     C                   MOVEL     DDBENA        I#ACLN
     C                   MOVEL     DDPSTM        I#PSTM
     C                   MOVEL     DDRSTM        I#RSTM
     C     DDPOCN        IFNE      *BLANKS
                                                                                              CSW203
      ** Set I#MTYP to "103" instead of "100" if CSW203 is installed                          CSW203
                                                                                              CSW203
     C                   IF        CSW203 = 'Y'                                               CSW203
     C                   EVAL      I#MTYP = '103'                                             CSW203
     C                   ELSE                                                                 CSW203
     C                   MOVEL     '100'         I#MTYP
     C                   ENDIF                                                                CSW203
     C                   ELSE
     C                   MOVEL     '202'         I#MTYP
     C                   ENDIF
      *
      * Set up receive account information
      *
     C     DDRONS        IFNE      *BLANKS
     C                   SELECT
     C     DDROBR        WHENNE    *BLANKS
     C     DDRONS        CAT       DDROBR        I#RCAC
     C     DDRONS        WHENNE    *BLANKS
     C                   MOVEL     DDRONS        I#RCAC
     C                   ENDSL
     C                   ENDIF
      *
      * Set up Pay account information
      *
     C     DDPONS        IFNE      *BLANKS
     C                   SELECT
     C     DDPOBR        WHENNE    *BLANKS
     C     DDPONS        CAT       DDPOBR        I#PYAC
     C     DDPONS        WHENNE    *BLANKS
     C                   MOVEL     DDPONS        I#PYAC
     C                   ENDSL
     C                   ENDIF
      *
      * If extra message and Rec Corr. then set 5354 field
      *
     C     DDRVNO        IFNE      *BLANKS
     C     DDRCRN        ANDNE     *BLANKS
     C                   MOVEL     'Y'           I#5354
     C                   ENDIF
      *
      * Transaction Type
      *
     C                   MOVEL     ##TTYP        I#TTYP
      *
     C                   CLEAR                   O#PARM
     C                   CLEAR                   E#PARM
      *
      * Send messages to correct calling process
      *
     C                   SELECT
     C     ##CALP        WHENEQ    'FXDL'
     C                   MOVEL     'ME9940'      E#CPGM
     C                   MOVEL     'DL'          I#MMOD
     C     ##CALP        WHENEQ    'LDNI'
     C                   MOVEL     'ME9940'      E#CPGM
     C                   MOVEL     'DL'          I#MMOD
     C     ##CALP        WHENEQ    'LEND'                                                     CAP068
     C     ##CALP        OREQ      'MAPY'                                                     239587
     C                   MOVEL     'ME9940'      E#CPGM                                       CAP068
     C                   MOVEL     'LE'          I#MMOD                                       CAP068
     C     ##CALP        WHENEQ    'SSI '
     C                   MOVEL     'SD0401R'     E#CPGM
     C                   MOVEL     'AT'          I#MMOD
     C                   OTHER
     C                   MOVEL     'ME9940'      E#CPGM
     C                   ENDSL
     C                   MOVEL     'MEC0018'     E#MSGD
     C                   MOVEL     'MEMSG'       E#MSGF
      *
     C                   CALL      'ME9940'
     C                   PARM                    W0RTN             7
     C                   PARM                    I#PARM                         I Input Parms
     C                   PARM                    O#PARM                         O Output Parms
     C                   PARM                    E#PARM                         E Error Inform
     C                   PARM                    Z#PARM          256            B User Defined
      *
      * A/c line modified
     C                   MOVEL     O#ACLN        DDBENA
      *
      ** Subtract 1 from error array index
     C                   SUB       1             E#INDX
      *
      * On return if errors copy into error array
      *
     C     E#ERRM        IFNE      *BLANKS
     C     1             DO        E#INDX        Q#                5 0
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBENA'
     C                   MOVEL     'ESM0'        WMessageID
     C                   MOVE      O#E(Q#)       WMessageID
     C                   EVAL      MsgIDArr(Idx) = WMessageID
     C                   ENDDO
     C                   MOVEL     'N'           DDBenaOK
     C                   ENDIF
      *
      * UPDATE OUTPUT FIELD
      *
     C                   MOVEL     DDBENA        FLBENA
      *
     C     EVBENA        ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLPNFD - CROSS VALIDATE NUMEROUS PAYMENT FIELDS               *
     C*                                                               *
     C*****************************************************************
     C     VLPNFD        BEGSR
      *
      ** IF BENEFICIARY IS A NON-BANK
      ** ORDERING CUSTOMER IS MANDATORY
      *
     C     @BBNBI        IFEQ      'N'
     C     DDPOCN        ANDEQ     *BLANKS
     C     DDPSTM        ANDEQ     '08'                                                       197865
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPOCN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0945'
     C                   MOVE      'N'           DDPocnOK
     C                   END
      *
      ** IF BENEFICIARY IS A BANK MAY NOT ENTER BOTH ORDERING
      ** CUSTOMER AND ORDERING BANK
      *
     C     @BBNBI        IFEQ      'Y'
     C     DDPOBN        ANDNE     *BLANKS
     C     DDPOCN        ANDNE     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPOBN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0951'
     C                   MOVE      'N'           DDPobnOK
     C                   END
     C/COPY WNCPYSRC,ZASETNVC11
      *
      ** RECEIVER (OF MT100) CAN'T BE THE SAME AS:
      ** BICN OF BRANCH OF OUR NOSTRO, OUR NOSTRO, RECEIVERS CORRESPONDENT,
      ** INTERMEDIARY OR A/C WITH BANK
      *
     C     FLRVNO        IFNE      *BLANKS
     C     FLRVNO        IFEQ      @PBICN
     C     FLRVNO        OREQ      @PNOCN
     C     FLRVNO        OREQ      FLRCRN
     C     FLRVNO        OREQ      FLPIBN
     C     FLRVNO        OREQ      FLAWBN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRVNO'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0954'
     C                   MOVE      'N'           DDRvnoOK
     C                   END
     C                   END
     C/COPY WNCPYSRC,ZASETNVC12
      *
      ** RECEIVER'S CORRESPONDANT CAN'T BE THE SAME AS:
      ** BICN OF BRANCH OF OUR NOSTRO, OUR NOSTRO, RECEIVER OF MT100,
      ** INTERMEDIARY OR A/C WITH BANK
      *
     C     FLRCRN        IFNE      *BLANKS
     C     FLRCRN        IFEQ      @PBICN
     C     FLRCRN        OREQ      @PNOCN
     C     FLRCRN        OREQ      FLRVNO
     C     FLRCRN        OREQ      FLPIBN
     C     FLRCRN        OREQ      FLAWBN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRCRN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0959'
     C                   MOVE      'N'           DDRcrnOK
     C                   END
     C                   END
     C/COPY WNCPYSRC,ZASETNVC13
      *
      ** INTERMEDIARY BANK CAN'T BE THE SAME AS:
      ** BICN OF BRANCH OF OUR NOSTRO, RECEIVER OF MT100, RECEIVERS
      ** CORRESPONDENT OR BENEFICIARY
      *
     C     FLPIBN        IFNE      *BLANKS
     C     FLPIBN        IFEQ      @PBICN
     C     FLPIBN        OREQ      FLRVNO
     C     FLPIBN        OREQ      FLRCRN
     C     FLPIBN        OREQ      FLBENN
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPIBN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0964'
     C                   MOVE      'N'           DDPibnOK
     C                   END
     C                   END
      *
      ** IF Account With Bank not entered, Intermediary Bank should
      ** also be blank
      *
     C     FLPIBN        IFNE      *BLANKS
     C     FLAWBN        ANDEQ     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPIBN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0979'
     C                   MOVE      'N'           DDPibnOK
     C                   END
     C/COPY WNCPYSRC,ZASETNVC14
      *
      ** ACCOUNT WITH BANK
      *
     C     FLAWBN        IFNE      *BLANKS
     C     FLAWBN        IFEQ      @PBICN
     C     FLAWBN        OREQ      FLRVNO
     C     FLAWBN        OREQ      FLRCRN
     C*****FLAWBN********OREQ      FLBENN                                       CAP004
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAWBN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0972'
     C                   MOVE      'N'           DDAwbnOK
     C                   END
     C                   END
     C/COPY WNCPYSRC,ZASETNVC15
      *
      ** BENEFICIARY CAN'T BE THE PAY INTERMEDIARY BANK
      ***OR*THE*ACCOUNT*WITH*BANK**********************                         CAP004
      *
     C     FLBENN        IFNE      *BLANKS
     C     FLBENN        IFEQ      FLPIBN
     C*****FLBENN********OREQ      FLAWBN                                       CAP004
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBENN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0980'
     C                   MOVE      'N'           DDBennOK
     C                   END
     C                   END
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLDTPI - VALIDATE DETAILS OF PAYMENT                          *
     C*                                                               *
     C*****************************************************************
     C     VLDTPI        BEGSR
      *
      ** MUST BE BLANK IF BENEFICIARY IS A BANK
      *
     C     @BBNBI        IFEQ      'Y'
     C     ##PPAY        ANDNE     'Y'                                                      AR641619
     C     DDDTP1        IFNE      *BLANKS
     C     DDDTP2        ORNE      *BLANKS
     C     DDDTP3        ORNE      *BLANKS
     C     DDDTP4        ORNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDTP1'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0987'
     C                   MOVE      'N'           DDDtp1OK
     C                   MOVE      'N'           DDDtp2OK
     C                   MOVE      'N'           DDDtp3OK
     C                   MOVE      'N'           DDDtp4OK
     C                   END
     C                   END
      *
      ** UPDATE OUTPUT FIELDS
      *
     C                   MOVEL     DDDTP1        FLDTP1
     C                   MOVEL     DDDTP2        FLDTP2
     C                   MOVEL     DDDTP3        FLDTP3
     C                   MOVEL     DDDTP4        FLDTP4
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLDCHG - VALIDATE DETAILS OF CHARGES                          *
     C*                                                               *
     C*****************************************************************
     C     VLDCHG        BEGSR
      *                                                                                      BUG4511
      ** Set up ordering bank indicator                                                      BUG4511
     C                   If        DDPOBN <> *Blank and                                      BUG4511
     C                             DDPOCN = *Blank                                           BUG4511
     C                   Eval      @OBNBI = 'Y'                                              BUG4511
     C                   EndIf                                                               BUG4511
      *
      ***MUST*BE*BLANK*IF*NO*MT100*MESSAGE*IS*TO*BE*PRODUCED***********                     AR892347
      ***(BOTH*PAY*ORDERING*CUSTOMER*AND*BENEFICIARY*ARE*BANKS)********                     AR892347
      ** MUST BE BLANK IF NO MT103 MESSAGE IS TO BE PRODUCED                                AR892347
      ** (BOTH PAY ORDERING BANK DEFINED AND BEFICIARY IS A BANK)                           AR892347
      *
     C     DDDCHG        IFNE      *BLANKS
     C     DDPOBN        ANDNE     *BLANK                                                   AR892347
     C*****@OBNBI        ANDEQ     'Y'                                                      AR892347
     C     @BBNBI        ANDEQ     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDCHG'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0920'
     C                   MOVE      'N'           DDDchgOK
     C                   END
                                                                                              219241
      ** If CFT013 is installed, use the default value from the                               219241
      ** Message Management ICD                                                               219241
                                                                                              219241
     C                   IF        CFT013 = 'Y'                                               219241
     C                             AND DDDCHG =  *BLANKS                                      219241
     C                             AND DDPOBN = *BLANK                                      AR892347
     C                             AND DDPOCN <>*BLANK                                      AR892347
     C**********                   AND @OBNBI <> 'Y'                                 219241 AR892347
     C                             OR CFT013 = 'Y'                                            219241
     C                             AND DDDCHG =  *BLANKS                                      219241
     C                             AND @BBNBI <> 'Y'                                          219241
     C                             AND DDBennOK <> 'N'                                      AR892347
     C                   IF        DDPSTM =  '01'                                             219241
     C                             OR DDPSTM = '07'                                           219241
     C                             OR DDPSTM = '08'                                           219241
     C                   EVAL      DDDCHG = ENDCHG                                            219241
     C                   ENDIF                                                                219241
     C                   ENDIF                                                                219241
      *
      ** MUST BE BEN,CLM OR OUR
      *
     C     DDDCHG        IFNE      *BLANKS
     C*****@OBNBI        ANDNE     'Y'                                                      AR892347
     C     DDPOBN        ANDEQ     *BLANK                                                   AR892347
     C     DDPOCN        ANDNE     *BLANK                                                   AR892347
     C     DDDCHG        ORNE      *BLANKS
     C     @BBNBI        ANDNE     'Y'
     C     DDBennOK      ANDNE     'N'                                                      AR892347
     C     DDDCHG        IFNE      'BEN'
     C     DDDCHG        ANDNE     'OUR'
     C     DDDCHG        ANDNE     'CLM'
     C     DDDCHG        ANDNE     'SHA'                                                      214110
     C     CFT013        ANDEQ     'N'                                                        219241
     C     DDDCHG        ORNE      'BEN'                                                      219241
     C     DDDCHG        ANDNE     'OUR'                                                      219241
     C     DDDCHG        ANDNE     'SHA'                                                      219241
     C     CFT013        ANDEQ     'Y'                                                        219241
     C     DDDCHG        OREQ      '?  '                                                      214110
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDCHG'
     C**********         EVAL      MsgIDArr(Idx) = 'ESM0961'                                  214110
     C                   EVAL      MsgIDArr(Idx) = 'ESM0986'                                  214110
     C                   MOVE      'N'           DDDchgOK
     C                   END
     C                   END
      *
      ** CLM ONLY ALLOWED IF THE BENEFICIARY IS A BANK
      *
     C     DDDCHG        IFEQ      'CLM'
     C     @BBNBI        ANDNE     'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDCHG'
     C**********         EVAL      MsgIDArr(Idx) = 'ESM0986'                                  214110
     C                   EVAL      MsgIDArr(Idx) = 'ESM0961'                                  214110
     C                   MOVE      'N'           DDDchgOK
     C                   END
      *
      ** UPDATE OUTPUT FIELD
      *
     C                   MOVEL     DDDCHG        FLDCHG
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLIC72 - VALIDATE INCLUDE 'IN' CURRENCY IN FIELD 72           *
     C*                                                               *
     C*****************************************************************
     C     VLIC72        BEGSR
      *
      **  Pay settlement ccy is Euros or
      **  pay settlement ccy is blank but transaction ccy is Euros
      *
     C     DDPSCY        IFEQ      BKEURO
     C     DDPSCY        OREQ      *BLANKS
     C     ##PCCY        ANDEQ     BKEURO
      *
      **  Pay settlement method is 01 or 08
      *
     C     DDPSTM        IFEQ      '01'
     C     DDPSTM        OREQ      '08'
      *
      **  Access Currency Details
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY    '    @OPTN
     C                   PARM      DDIC72        @CURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      **  'In' ccy in field 72 is invalid
      **  or not a dealing currency
      *
     C     @RTCD         IFNE      *BLANKS
     C     A6DLCI        ORNE      'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDIC72'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0849'
     C                   MOVE      'N'           DDIc72OK
     C                   ELSE
 
     C                   MOVEL     A6CYCD        DDIC72
 
      * If transaction pay currency is Euros
 
     C     ##PCCY        IFEQ      BKEURO
      *
      ** Currency in field 72 is not an 'In' currency
      *
     C     A6INCY        IFNE      'Y'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDIC72'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0856'
     C                   MOVE      'N'           DDIc72OK
     C                   ENDIF
      *
     C                   ELSE
      *
      **  Transaction currency is an 'In' currency but the currency
      **  entered is not equal to the transaction pay currency
      *
     C     ##PCCY        IFNE      DDIC72
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDIC72'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0858'
     C                   MOVE      'N'           DDIc72OK
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
      *
      **  Pay settlement method is not 01 or 08
      *
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDIC72'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0855'
     C                   MOVE      'N'           DDIc72OK
     C                   ENDIF
      *
     C                   ELSE
      *
      **  Transaction ccy is Euro but settlement ccy is not blank or
      **  settlement ccy is not Euro
      *
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDIC72'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0857'
     C                   MOVE      'N'           DDIc72OK
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLBTBI - VALIDATE BANK TO BANK INFO                           *
     C*                                                               *
     C*****************************************************************
     C     VLBTBI        BEGSR
      *
     C                   Z-ADD     *ZERO         X                 1 0
      *
      ** MUST BE BLANK IF SETTLEMENT TYPE IS '00'
      *
     C     ##PPAY        IFNE      'Y'                                                      AR641619
     C     DDPSTM        IFEQ      '00'
      *
     C     DDBTB1        IFNE      *BLANKS
     C     DDBTB2        ORNE      *BLANKS
     C     DDBTB3        ORNE      *BLANKS
     C     DDBTB4        ORNE      *BLANKS
     C     DDBTB5        ORNE      *BLANKS
     C     DDBTB6        ORNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBTB1'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0988'
     C                   MOVE      'N'           DDBtb1OK
     C                   MOVE      'N'           DDBtb2OK
     C                   MOVE      'N'           DDBtb3OK
     C                   MOVE      'N'           DDBtb4OK
     C                   MOVE      'N'           DDBtb5OK
     C                   MOVE      'N'           DDBtb6OK
     C                   END
     C                   END
      *
      * Call Bank to Bank Validation object
      *
      * Set up parameters
      *
     C                   MOVEL     *BLANKS       W0RTN
     C                   CLEAR                   I#PARM
      *
      * Set up Control fields
     C                   MOVEL     ':72: '       I#VFLD
     C                   MOVEL     'PAY'         I#PR
      *
      * Set up Currency fields
     C                   MOVEL     E#PCCY        I#PCCY
     C                   MOVEL     E#RCCY        I#RCCY
      *
      * Set up Intermediary
     C     DDPIBN        IFNE      *BLANKS
     C                   MOVEL     'X'           I#INBT
     C                   MOVEL     DDPIBN        I#INBK
     C                   ENDIF
      *
      * Set up Account with Bank
     C     DDAWBN        IFNE      *BLANKS
     C                   MOVEL     'X'           I#AWBT
     C                   MOVEL     DDAWBN        I#AWBK
     C                   ENDIF
      *
      * Set up Beneficiary
     C     DDBENN        IFNE      *BLANKS
     C                   MOVEL     'X'           I#BENT
     C                   MOVEL     DDBENN        I#BENF
     C                   ENDIF
     C/COPY WNCPYSRC,ZASETINVC7
      *
      * Move in Bank to Bank Information
     C                   MOVEL     DDBTB1        I#BTB1
     C                   MOVEL     DDBTB2        I#BTB2
     C                   MOVEL     DDBTB3        I#BTB3
     C                   MOVEL     DDBTB4        I#BTB4
     C                   MOVEL     DDBTB5        I#BTB5
     C                   MOVEL     DDBTB6        I#BTB6
     C                   MOVEL     DDPSTM        I#PSTM
     C                   MOVEL     DDRSTM        I#RSTM
     C/COPY WNCPYSRC,ZASETNVC27
      *
      * Set up receive account information
     C     DDRONS        IFNE      *BLANKS
     C                   SELECT
     C     DDROBR        WHENNE    *BLANKS
     C     DDRONS        CAT       DDROBR        I#RCAC
     C     DDRONS        WHENNE    *BLANKS
     C                   MOVEL     DDRONS        I#RCAC
     C                   ENDSL
     C                   ENDIF
      *
      * Set up Pay account information
     C     DDPONS        IFNE      *BLANKS
     C                   SELECT
     C     DDPOBR        WHENNE    *BLANKS
     C     DDPONS        CAT       DDPOBR        I#PYAC
     C     DDPONS        WHENNE    *BLANKS
     C                   MOVEL     DDPONS        I#PYAC
     C                   ENDSL
     C                   ENDIF
      *
      * If extra message and Rec Corr. then set 5354 field
     C     DDRVNO        IFNE      *BLANKS
     C     DDRCRN        ANDNE     *BLANKS
     C                   MOVEL     'Y'           I#5354
     C                   ENDIF
      *
      * Set up message type
     C     DDPOCN        IFNE      *BLANKS
                                                                                              CSW203
      ** Set I#MTYP to "103" instead of "100" if CSW203 is installed                          CSW203
                                                                                              CSW203
     C                   IF        CSW203 = 'Y'                                               CSW203
     C                   EVAL      I#MTYP = '103'                                             CSW203
     C                   ELSE                                                                 CSW203
     C                   MOVEL     '100'         I#MTYP
     C                   ENDIF                                                                CSW203
     C                   ELSE
     C                   MOVEL     '202'         I#MTYP
     C                   ENDIF
      *
      * Transaction Type
     C                   MOVEL     ##TTYP        I#TTYP
      *
     C                   CLEAR                   O#PARM
     C                   CLEAR                   E#PARM
      *
      * Send messages to correct calling process
     C                   SELECT
     C     ##CALP        WHENEQ    'FXDL'
     C                   MOVEL     'ME9950'      E#CPGM
     C                   MOVEL     'DL'          I#MMOD
     C     ##CALP        WHENEQ    'LDNI'
     C                   MOVEL     'ME9950'      E#CPGM
     C                   MOVEL     'DL'          I#MMOD
     C     ##CALP        WHENEQ    'LEND'                                                     CAP068
     C     ##CALP        OREQ      'MAPY'                                                     239587
     C                   MOVEL     'ME9950'      E#CPGM                                       CAP068
     C                   MOVEL     'LE'          I#MMOD                                       CAP068
     C*****##CALP        WHENEQ    'FRAS'                                       CAP003
     C     ##CALP        WHENEQ    'FRA '                                       CAP003
     C     CSW005        ANDEQ     'Y'
     C     ##CALP        OREQ      'SIRS'                                       164570
     C     CSW005        ANDEQ     'Y'                                          164570
     C     ##CALP        OREQ      'CIRS'                                       CAP004
     C     CSW005        ANDEQ     'Y'                                          CAP004
     C*****##CALP        OREQ      'FRAS'                                       CAP003
     C     ##CALP        OREQ      'FRA '                                       CAP003
     C     CSW011        ANDEQ     'Y'
     C*****##CALP        OREQ      'CIRS'                                CAP004 164570
     C*****CSW011        ANDEQ     'Y'                                   CAP004 164570
     C     ##CALP        OREQ      'CXSV'                                                     CIR003
     C     CSW005        ANDEQ     'Y'                                                        CIR003
     C     CIR003        ANDEQ     'Y'                                                        CIR003
     C     ##CALP        OREQ      'CXSM'                                                     CIR003
     C     CSW005        ANDEQ     'Y'                                                        CIR003
     C     CIR003        ANDEQ     'Y'                                                        CIR003
     C                   MOVEL     'ME9950'      E#CPGM
     C                   MOVEL     'DL'          I#MMOD
     C     ##CALP        WHENEQ    'SSI '
     C                   MOVEL     'SD0401R'     E#CPGM
     C                   MOVEL     'AT'          I#MMOD
     C                   OTHER
     C                   MOVEL     'ME9950'      E#CPGM
     C                   ENDSL
      *
      * Set standard message text
     C                   MOVEL     'MEC0114'     E#MSGD
     C                   MOVEL     'MEMSG'       E#MSGF
     C/COPY WNCPYSRC,ZASETNVC16
      *
     C                   CALL      'ME9950'
     C                   PARM                    W0RTN             7
     C                   PARM                    I#PARM                         I Input Parms
     C                   PARM                    O#PARM                         O Output Parms
     C                   PARM                    E#PARM                         E Error Inform
     C                   PARM                    Z#PARM          256            B User Defined
     C/COPY WNCPYSRC,ZASETNVC17
      *
      * On return if errors copy into error array
      *
     C                   MOVEL     O#BTB1        DDBTB1
     C                   MOVEL     O#BTB2        DDBTB2
     C                   MOVEL     O#BTB3        DDBTB3
     C                   MOVEL     O#BTB4        DDBTB4
     C                   MOVEL     O#BTB5        DDBTB5
     C                   MOVEL     O#BTB6        DDBTB6
     C/COPY WNCPYSRC,ZASETNVC18
      *
      ** Subtract 1 from error array index
     C                   SUB       1             E#INDX
      *
     C     E#ERRM        IFNE      *BLANKS
     C     1             DO        E#INDX        Q#                5 0
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBTB1'
     C                   MOVEL     'ESM0'        WMessageID
     C                   MOVE      O#E(Q#)       WMessageID
     C                   EVAL      MsgIDArr(Idx) = WMessageID
     C                   ENDDO
     C                   MOVE      'N'           DDBtb1OK
     C                   MOVE      'N'           DDBtb2OK
     C                   MOVE      'N'           DDBtb3OK
     C                   MOVE      'N'           DDBtb4OK
     C                   MOVE      'N'           DDBtb5OK
     C                   MOVE      'N'           DDBtb6OK
     C                   ENDIF
     C                   ENDIF                                                              AR641619
      *
      ** UPDATE OUTPUT FIELDS
      *
     C                   MOVEL     DDBTB1        FLBTB1
     C                   MOVEL     DDBTB2        FLBTB2
     C                   MOVEL     DDBTB3        FLBTB3
     C                   MOVEL     DDBTB4        FLBTB4
     C                   MOVEL     DDBTB5        FLBTB5
     C                   MOVEL     DDBTB6        FLBTB6
      *
     C                   ENDSR
     C********************************************************************
      /EJECT                                                                                  CDL094
     C*****************************************************************                       CDL094
     C*                                                               *                       CDL094
     C* VLRBTBI - VALIDATE RECEIVE BANK TO BANK INFO                  *                       CDL094
     C*                                                               *                       CDL094
     C*****************************************************************                       CDL094
     C     VLRBTBI       BEGSR                                                                CDL094
      *                                                                                       CDL094
     C                   Z-ADD     *ZERO         X                 1 0                        CDL094
      *                                                                                       CDL094
      ** MUST BE BLANK IF SETTLEMENT TYPE IS '00'                                             CDL094
      *                                                                                       CDL094
     C     ##PREC        IFNE      'Y'                                                        CDL094
     C     DDRSTM        IFEQ      '00'                                                       CDL094
     C     DDRSTM        OREQ      '  '                                                       CDL094
      *                                                                                       CDL094
     C     DDRBB1        IFNE      *BLANKS                                                    CDL094
     C     DDRBB2        ORNE      *BLANKS                                                    CDL094
     C     DDRBB3        ORNE      *BLANKS                                                    CDL094
     C     DDRBB4        ORNE      *BLANKS                                                    CDL094
     C     DDRBB5        ORNE      *BLANKS                                                    CDL094
     C     DDRBB6        ORNE      *BLANKS                                                    CDL094
     C                   ADD       1             Idx                                          CDL094
     C                   EVAL      FldNameArr(Idx) = 'DDRBB1'                                 CDL094
     C                   EVAL      MsgIDArr(Idx) = 'ESM0988'                                  CDL094
     C                   MOVE      'N'           DDRbb1OK                                     CDL094
     C                   MOVE      'N'           DDRbb2OK                                     CDL094
     C                   MOVE      'N'           DDRbb3OK                                     CDL094
     C                   MOVE      'N'           DDRbb4OK                                     CDL094
     C                   MOVE      'N'           DDRbb5OK                                     CDL094
     C                   MOVE      'N'           DDRbb6OK                                     CDL094
     C                   END                                                                  CDL094
     C                   END                                                                  CDL094
      *                                                                                       CDL094
      * Call Bank to Bank Validation object                                                   CDL094
      *                                                                                       CDL094
      * Set up parameters                                                                     CDL094
      *                                                                                       CDL094
     C                   MOVEL     *BLANKS       W0RTN                                        CDL094
     C                   CLEAR                   I#PARM                                       CDL094
      *                                                                                       CDL094
      * Set up Control fields                                                                 CDL094
     C                   MOVEL     ':72: '       I#VFLD                                       CDL094
     C                   MOVEL     'PAY'         I#PR                                         CDL094
      *                                                                                       CDL094
      * Set up Currency fields                                                                CDL094
     C                   MOVEL     E#RCCY        I#PCCY                                       CDL094
     C                   MOVEL     E#PCCY        I#RCCY                                       CDL094
      *                                                                                       CDL094
      * Set up Intermediary                                                                   CDL094
     C     DDRIBN        IFNE      *BLANKS                                                    CDL094
     C                   MOVEL     'X'           I#INBT                                       CDL094
     C                   MOVEL     DDRIBN        I#INBK                                       CDL094
     C                   ENDIF                                                                CDL094
      *                                                                                       CDL094
      * Set up Account with Bank (If defined for the Receive Nostro)                          CDL094
     C     A7RF57        IFNE      *BLANKS                                                    CDL094
     C                   MOVEL     'X'           I#AWBT                                       CDL094
     C                   MOVEL     A7RF57        I#AWBK                                       CDL094
     C                   ENDIF                                                                CDL094
      *                                                                                       CDL094
      * Set up Beneficiary (If defined for the Receive Nostro and not FX Deal)                CDL094
     C     A7RF58        IFNE      *BLANKS                                                    CDL094
     C     ##CALP        ANDNE     'FXDL'                                                     CDL094
     C                   MOVEL     'X'           I#BENT                                       CDL094
     C                   MOVEL     A7RF58        I#BENF                                       CDL094
     C                   ENDIF                                                                CDL094
      *                                                                                       CDL094
      * Move in Bank to Bank Information                                                      CDL094
     C                   MOVEL     DDRBB1        I#BTB1                                       CDL094
     C                   MOVEL     DDRBB2        I#BTB2                                       CDL094
     C                   MOVEL     DDRBB3        I#BTB3                                       CDL094
     C                   MOVEL     DDRBB4        I#BTB4                                       CDL094
     C                   MOVEL     DDRBB5        I#BTB5                                       CDL094
     C                   MOVEL     DDRBB6        I#BTB6                                       CDL094
     C                   MOVEL     DDRSTM        I#PSTM                                       CDL094
     C                   MOVEL     DDPSTM        I#RSTM                                       CDL094
      *                                                                                       CDL094
      * Set up receive account information (use Pay details since we are                      CDL094
      * calling ME9950 for the Receive Bank to Bank details)                                  CDL094
     C     DDPONS        IFNE      *BLANKS                                                    CDL094
     C                   SELECT                                                               CDL094
     C     DDPOBR        WHENNE    *BLANKS                                                    CDL094
     C     DDPONS        CAT       DDPOBR        I#RCAC                                       CDL094
     C     DDPONS        WHENNE    *BLANKS                                                    CDL094
     C                   MOVEL     DDPONS        I#RCAC                                       CDL094
     C                   ENDSL                                                                CDL094
     C                   ENDIF                                                                CDL094
      *                                                                                       CDL094
      * Set up Pay account information (use Receive details since we are                      CDL094
      * calling ME9950 for the Receive Bank to Bank details)                                  CDL094
     C     DDRONS        IFNE      *BLANKS                                                    CDL094
     C                   SELECT                                                               CDL094
     C     DDROBR        WHENNE    *BLANKS                                                    CDL094
     C     DDRONS        CAT       DDROBR        I#PYAC                                       CDL094
     C     DDRONS        WHENNE    *BLANKS                                                    CDL094
     C                   MOVEL     DDRONS        I#PYAC                                       CDL094
     C                   ENDSL                                                                CDL094
     C                   ENDIF                                                                CDL094
      *                                                                                       CDL094
      * Transaction Type                                                                      CDL094
     C                   MOVEL     ##TTYP        I#TTYP                                       CDL094
      *                                                                                       CDL094
     C                   CLEAR                   O#PARM                                       CDL094
     C                   CLEAR                   E#PARM                                       CDL094
      *                                                                                       CDL094
      * Send messages to correct calling process                                              CDL094
     C                   MOVEL     'ME9950'      E#CPGM                                       CDL094
     C                   MOVEL     'DL'          I#MMOD                                       CDL094
      *                                                                                       CDL094
      * Set standard message text                                                             CDL094
     C                   MOVEL     'MEC0114'     E#MSGD                                       CDL094
     C                   MOVEL     'MEMSG'       E#MSGF                                       CDL094
      *                                                                                       CDL094
     C                   CALL      'ME9950'                                                   CDL094
     C                   PARM                    W0RTN             7                          CDL094
     C                   PARM                    I#PARM                         I Input Parms CDL094
     C                   PARM                    O#PARM                         O Output ParmsCDL094
     C                   PARM                    E#PARM                         E Error InformCDL094
     C                   PARM                    Z#PARM          256            B User DefinedCDL094
      *                                                                                       CDL094
      * On return if errors copy into error array                                             CDL094
      *                                                                                       CDL094
     C                   MOVEL     O#BTB1        DDRBB1                                       CDL094
     C                   MOVEL     O#BTB2        DDRBB2                                       CDL094
     C                   MOVEL     O#BTB3        DDRBB3                                       CDL094
     C                   MOVEL     O#BTB4        DDRBB4                                       CDL094
     C                   MOVEL     O#BTB5        DDRBB5                                       CDL094
     C                   MOVEL     O#BTB6        DDRBB6                                       CDL094
      *                                                                                       CDL094
      ** Subtract 1 from error array index                                                    CDL094
     C                   SUB       1             E#INDX                                       CDL094
      *                                                                                       CDL094
     C     E#ERRM        IFNE      *BLANKS                                                    CDL094
     C     1             DO        E#INDX        Q#                5 0                        CDL094
     C                   ADD       1             Idx                                          CDL094
     C                   EVAL      FldNameArr(Idx) = 'DDRBB1'                                 CDL094
     C                   MOVEL     'ESM0'        WMessageID                                   CDL094
     C                   MOVE      O#E(Q#)       WMessageID                                   CDL094
     C                   EVAL      MsgIDArr(Idx) = WMessageID                                 CDL094
     C     O#E(Q#)       IFEQ      '994'                                                      CDL094
     C                   EVAL      MsgIDArr(Idx) = 'MEC0105'                                  CDL094
     C                   ENDIF                                                                CDL094
     C     O#E(Q#)       IFEQ      '101'                                                      CDL094
     C                   EVAL      MsgIDArr(Idx) = 'MEC0101'                                  CDL094
     C                   ENDIF                                                                CDL094
     C     O#E(Q#)       IFEQ      '100'                                                      CDL094
     C                   EVAL      MsgIDArr(Idx) = 'MEC0100'                                  CDL094
     C                   ENDIF                                                                CDL094
     C     O#E(Q#)       IFEQ      '302'                                                      CDL094
     C                   EVAL      MsgIDArr(Idx) = 'MEC0302'                                  CDL094
     C                   ENDIF                                                                CDL094
     C     O#E(Q#)       IFEQ      '103'                                                      CDL094
     C                   EVAL      MsgIDArr(Idx) = 'MEC0103'                                  CDL094
     C                   ENDIF                                                                CDL094
     C     O#E(Q#)       IFEQ      '104'                                                      CDL094
     C                   EVAL      MsgIDArr(Idx) = 'MEC0104'                                  CDL094
     C                   ENDIF                                                                CDL094
     C     O#E(Q#)       IFEQ      '897'                                                      CDL094
     C                   EVAL      MsgIDArr(Idx) = 'MEC0116'                                  CDL094
     C                   ENDIF                                                                CDL094
     C     O#E(Q#)       IFEQ      '893'                                                      CDL094
     C                   EVAL      MsgIDArr(Idx) = 'MEC0108'                                  CDL094
     C                   ENDIF                                                                CDL094
     C     O#E(Q#)       IFEQ      '895'                                                      CDL094
     C                   EVAL      MsgIDArr(Idx) = 'MEC0107'                                  CDL094
     C                   ENDIF                                                                CDL094
     C                   ENDDO                                                                CDL094
     C                   MOVE      'N'           DDRbb1OK                                     CDL094
     C                   MOVE      'N'           DDRbb2OK                                     CDL094
     C                   MOVE      'N'           DDRbb3OK                                     CDL094
     C                   MOVE      'N'           DDRbb4OK                                     CDL094
     C                   MOVE      'N'           DDRbb5OK                                     CDL094
     C                   MOVE      'N'           DDRbb6OK                                     CDL094
     C                   ENDIF                                                                CDL094
     C                   ENDIF                                                                CDL094
      *                                                                                       CDL094
      ** UPDATE OUTPUT FIELDS                                                                 CDL094
      *                                                                                       CDL094
     C                   MOVEL     DDRBB1        FLRBB1                                       CDL094
     C                   MOVEL     DDRBB2        FLRBB2                                       CDL094
     C                   MOVEL     DDRBB3        FLRBB3                                       CDL094
     C                   MOVEL     DDRBB4        FLRBB4                                       CDL094
     C                   MOVEL     DDRBB5        FLRBB5                                       CDL094
     C                   MOVEL     DDRBB6        FLRBB6                                       CDL094
      *                                                                                       CDL094
     C                   ENDSR                                                                CDL094
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* XVRPSETC - CROSS VALIDATE REC/PAY SETTLEMENT CURRENCY         *
     C*                                                               *
     C*****************************************************************
     C     XVRPSETC      BEGSR
      *
      * Receive and payment settlement currencies can't be different
      *
     C     DDRSCY        IFNE      DDPSCY
     C     ##CALP        IFEQ      'DEAM'                                                     196808
     C     DDRSCY        ANDEQ     *BLANK                                                     196808
     C     DDRSTM        ANDEQ     '00'                                                       196808
     C     ##CALP        OREQ      'DEAM'                                                     196808
     C     DDPSCY        ANDEQ     *BLANK                                                     196808
     C     DDPSTM        ANDEQ     '00'                                                       196808
     C     ##CALP        OREQ      'MAPY'                                                     239587
     C     DDRSCY        ANDEQ     *BLANK                                                     239587
     C*****DDRSTM        ANDEQ     '00'                                              239587 AR853046
     C     DDRSTM        ANDEQ     *BLANKS                                                  AR853046
     C     ##CALP        OREQ      'MAPY'                                                     239587
     C     DDPSCY        ANDEQ     *BLANK                                                     239587
     C*****DDPSTM        ANDEQ     '00'                                              239587 AR853046
     C     ##CALP        OREQ      'MAPY'                                                  AR1005230
     C     DDPSCY        ANDEQ     *BLANK                                                  AR1005230
     C     DDPSTM        ANDEQ     *BLANKS                                                  AR853046
     C                   GOTO      XVRPEND                                                    196808
     C                   ENDIF                                                                196808
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRSCY'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0847'
     C                   MOVE      'N'           DDRscyOK
     C                   MOVE      'N'           DDPscyOK
     C                   ENDIF
 
     C**********         ENDSR                                                                196808
     C     XVRPEND       ENDSR                                                                196808
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C**VLFRIR*-*VALIDATE*FRA/IRS*SETTLEMENT*DETAILS*******************                       CSW212
     C* VLFRIR - VALIDATE EXTENDED SETTLEMENT DETAILS                 *                       CSW212
     C*                                                               *
     C*****************************************************************
     C     VLFRIR        BEGSR
      *
      ** CLEAR OUTPUT FRA/IRS FIELDS
      *
     C                   CLEAR                   ##FRIF
      *
      ** DEFINITION SENDER TO RECEIVER INFORMATION
      ** -----------------------------------------
      *
     C                   EXSR      VLDSRI
      *
      ** SETTLEMENT/RESET SENDER TO RECEIVER INFORMATION
      ** -----------------------------------------------
      *
     C                   EXSR      VLSSRI
      *
      ** CONDITIONS
      ** ----------
      *
     C                   EXSR      VLCNDI
      *
      ** AGREEMENT DETAILS
      ** -----------------
      *
     C     ##TTYP        IFEQ      'RS'
     C     ##TTYP        OREQ      'FR'                                         CSW097
     C     ##TTYP        OREQ      'RX'
     C     CIR003        ANDEQ     'N'                                                        CIR003
     C     ##CALP        OREQ      'CIRS'                                                     CIR003
     C     CIR003        ANDEQ     'Y'                                                        CIR003
     C     ##CALP        OREQ      'SSI '
     C     ##TTYP        ANDEQ     'AT'
     C     CSW005        ANDEQ     'Y'
     C     ##CALP        OREQ      'FXDL'                                                     CSW212
     C     CSW212        ANDEQ     'Y'                                                        CSW212
     C                   EXSR      VLAGRD
     C                   ENDIF
      *
      ** UPDATE OUTPUT FIELDS
      *
     C                   MOVEL     ##FRIS        ##FRIF
     C**********         MOVEL     DDAGVV        FLAGVC                              CSW097 MD033870
     C**********         MOVE      DDAGVV        FLAGVV                              CSW097 MD033870
     C**********         MOVE      DDAGVV        FLAGVC                            MD033870 MD040199
     C**********         MOVEL     DDAGVV        FLAGVV                            MD033870 MD040199
     C                   MOVEL     DDAGVV        FLAGVC                                     MD040199
     C                   MOVE      DDAGVV        FLAGVV                                     MD040199
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLDSRI - VALIDATE DEFINITION SENDER TO RECEIVER INFORMATION   *
     C*                                                               *
     C*****************************************************************
     C     VLDSRI        BEGSR
      *
      **  First, convert Agreement Type to disregard leading blanks
      *
     C     DDAGTY        IFNE      *BLANKS
      *
     C     ##TTYP        IFEQ      'RS'
     C     ##TTYP        OREQ      'RX'
     C     ##TTYP        OREQ      'FR'                                         CSW097
     C     ##CALP        OREQ      'SSI '
     C     ##TTYP        ANDEQ     'AT'
     C     CSW005        ANDEQ     'Y'
     C     ##CALP        OREQ      'FXDL'                                                     CSW212
     C     CSW212        ANDEQ     'Y'                                                        CSW212
     C*
     C                   MOVEL     DDAGTY        WorkAGTY          6
     C     1             DO        6             W@X               1 0
     C     1             SUBST     DDAGTY:W@X    Work01            1
     C     Work01        IFNE      *BLANKS
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
     C*
     C                   SUBST(P)  WorkAGTY:W@X  DDAGTY
     C*
     C                   ENDIF
     C                   ENDIF
     C*
     C**  Definition Confirmation Sender to Receiver
     C*
     C                   CLEAR                   I#PARM
     C                   CLEAR                   E#PARM
     C                   CLEAR                   O#PARM
     C*
     C                   MOVEL(P)  ':72: '       I#VFLD
     C                   MOVEL     ##TTYP        I#TTYP
     C                   MOVEL     'FI'          I#MMOD
     C     DDAWBN        IFNE      *BLANKS
     C                   MOVEL     'X'           I#AWBT
     C                   MOVEL     DDAWBN        I#AWBK
     C                   ENDIF
     C                   MOVEL     DDDSR1        I#BTB1
     C                   MOVEL     DDDSR2        I#BTB2
     C                   MOVEL     DDDSR3        I#BTB3
     C                   MOVEL     DDDSR4        I#BTB4
     C                   MOVEL     DDDSR5        I#BTB5
     C                   MOVEL     DDDSR6        I#BTB6
      *
     C     ##CALP        IFEQ      'FXDL'                                                  AR1039735
     C     CSW212        ANDEQ     'Y'                                                     AR1039735
     C                   MOVEL     'DL'          I#MMOD                                    AR1039735
     C                   MOVEL     DDPSTM        I#PSTM                                    AR1039735
     C                   MOVEL     '202'         I#MTYP                                    AR1039735
     C                   ENDIF                                                             AR1039735
                                                                                           AR1039735
     C                   SELECT
     C*****##CALP        WHENEQ    'FRAS'                                       CAP003
     C******             MOVEL     'SD2400'      E#CPGM                         CAP003
     C     ##CALP        WHENEQ    'SSI '
     C                   MOVEL     'SD0402R'     E#CPGM
     C                   OTHER
     C                   MOVEL     'ME9950'      E#CPGM
     C                   ENDSL
      *
      * Set standard message text
      *
     C                   MOVEL     'MEC0201'     E#MSGD
     C                   MOVEL     'MEMSG'       E#MSGF
     C/COPY WNCPYSRC,ZASETNVC19
      *
     C                   CALL      'ME9950'
     C                   PARM                    W0RTN             7
     C                   PARM                    I#PARM                         I Input Parms
     C                   PARM                    O#PARM                         O Output Parms
     C                   PARM                    E#PARM                         E Error Inform
     C                   PARM                    Z#PARM          256            B User Defined
     C/COPY WNCPYSRC,ZASETNVC20
      *
      * On return if errors copy into error array
      *
     C                   MOVEL     O#BTB1        DDDSR1
     C                   MOVEL     O#BTB2        DDDSR2
     C                   MOVEL     O#BTB3        DDDSR3
     C                   MOVEL     O#BTB4        DDDSR4
     C                   MOVEL     O#BTB5        DDDSR5
     C                   MOVEL     O#BTB6        DDDSR6
     C/COPY WNCPYSRC,ZASETNVC21
      *
      ** Subtract 1 from error array index
     C                   SUB       1             E#INDX
      *                                                                                       CSW214
     C     ##CALP        IFEQ      'FXDL'                                                     CSW214
     C     ##CALP        OREQ      'FRA'                                                      CSW214
     C     ##CALP        OREQ      'SIRS'                                                     CSW214
     C     ##CALP        OREQ      'CIRS'                                                     CSW214
     C     CSW214        IFEQ      'Y'                                                        CSW214
     C     E#WARN        ANDEQ     'Y'                                                        CSW214
     C     1             DO        E#INDX        Q#                                           CSW214
     C                   ADD       1             WIdx                                         CSW214
     C                   EVAL      WMessageID = '5047377'                                     CSW214
     C                   EVAL      WMsgIDArr(WIdx) = WMessageID                               CSW214
     C                   EVAL      WFldNameArr(WIdx) = 'DDDSR1'                               CSW214
     C                   ENDDO                                                                CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
      *
     C     E#ERRM        IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDSR1'
     C**********         EVAL      MsgIDArr(Idx) = 'ESM0X01'                    CAP003
     C     ##CALP        IFEQ      'FXDL'                                                     CSW212
     C     CSW212        ANDEQ     'Y'                                                        CSW212
     C                   EVAL      MsgIDArr(Idx) = '5045758'                                  CSW212
     C                   ELSE                                                                 CSW212
     C**********         EVAL      MsgIDArr(Idx) = 'ESM0600'                         CAP003 MD029779
     C                   EVAL      MsgIDArr(Idx) = '5047378'                                MD029779
     C                   ENDIF                                                                CSW212
     C                   MOVE      'N'           DDDsr1OK
     C                   MOVE      'N'           DDDsr2OK
     C                   MOVE      'N'           DDDsr3OK
     C                   MOVE      'N'           DDDsr4OK
     C                   MOVE      'N'           DDDsr5OK
     C                   MOVE      'N'           DDDsr6OK
     C                   ENDIF
      *
      ** Field 72 (Cover Message) cannly be input if 'Cover MT202 required' flag is 'Y'       CSW212
      *                                                                                       CSW212
     C     ##CALP        IFEQ      'FXDL'                                                     CSW212
     C     CSW212        ANDEQ     'Y'                                                        CSW212
     C     DDCVMR        IFNE      'Y'                                                        CSW212
     C     DDDSR1        ANDNE     *BLANKS                                                    CSW212
     C                   ADD       1             Idx                                          CSW212
     C                   EVAL      FldNameArr(Idx) = 'DDDSR1'                                 CSW212
     C                   EVAL      MsgIDArr(Idx) = '5045750'                                  CSW212
     C                   MOVEL     'N'           DDDsr1OK                                     CSW212
     C                   ENDIF                                                                CSW212
     C                   ENDIF                                                                CSW212
      *                                                                                       CSW212
     C                   ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLSSRI - VALIDATE SETTLEMENT/RESET SENDER TO RECEIVER INFO    *
     C*                                                               *
     C*****************************************************************
     C     VLSSRI        BEGSR
      *
      **  Settlement/Reset Confirmation Sender to Receiver
      *
     C                   CLEAR                   I#PARM
     C                   CLEAR                   E#PARM
     C                   CLEAR                   O#PARM
     C*
     C                   MOVEL(P)  ':72: '       I#VFLD
     C                   MOVEL     ##TTYP        I#TTYP
     C                   MOVEL     'FI'          I#MMOD
     C     DDAWBN        IFNE      *BLANKS
     C                   MOVEL     'X'           I#AWBT
     C                   MOVEL     DDAWBN        I#AWBK
     C                   ENDIF
                                                                                           AR1039735
     C     ##CALP        IFEQ      'FXDL'                                                  AR1039735
     C     CSW212        ANDEQ     'Y'                                                     AR1039735
     C                   MOVEL     'DL'          I#MMOD                                    AR1039735
     C                   MOVEL     DDPSTM        I#PSTM                                    AR1039735
     C                   MOVEL     '300'         I#MTYP                                    AR1039735
      *                                                                                       CMG003
      **  Access Currency Details for transaction Payment Currency                            CMG003
      *                                                                                       CMG003
     C                   CALLB     'AOCURRR0'                                                 CMG003
     C                   PARM      *BLANKS       @RTCD                                        CMG003
     C                   PARM      '*KEY    '    @OPTN                                        CMG003
     C                   PARM      ##PCCY        @CURR                                        CMG003
     C     SDCURR        PARM      SDCURR        DSSDY                                        CMG003
      *                                                                                       CMG003
      ** Move Precious Metal Ind value to temporary workfield                                 CMG003
     C                   IF        @RTCD = *BLANKS                                            CMG003
     C                   EVAL      WPayPMRT = A6PMRT                                          CMG003
     C                   ENDIF                                                                CMG003
      *                                                                                       CMG003
      **  Access Currency Details for transaction Receive Currency                            CMG003
      *                                                                                       CMG003
     C                   CALLB     'AOCURRR0'                                                 CMG003
     C                   PARM      *BLANKS       @RTCD                                        CMG003
     C                   PARM      '*KEY    '    @OPTN                                        CMG003
     C                   PARM      ##RCCY        @CURR                                        CMG003
     C     SDCURR        PARM      SDCURR        DSSDY                                        CMG003
      *                                                                                       CMG003
      ** Move Precious Metal Ind value to temporary workfield                                 CMG003
     C                   IF        @RTCD = *BLANKS                                            CMG003
     C                   EVAL      WRecPMRT = A6PMRT                                          CMG003
     C                   ENDIF                                                                CMG003
      *                                                                                       CMG003
      ** If CMG003 is *ON, use I#MTYP = '600' if one and only the                             CMG003
      ** currency (Purchase or Sell) is flagged as previous metal                             CMG003
      *                                                                                       CMG003
     C                   IF        CMG003 = 'Y'                                               CMG003
     C                   IF        (WPayPMRT = 'Y' AND WRecPMRT = 'N') OR                     CMG003
     C                             (WPayPMRT = 'N' AND WRecPMRT = 'Y')                        CMG003
     C                   EVAL      I#MTYP = '600'                                             CMG003
     C                   ENDIF                                                                CMG003
     C                   ENDIF                                                                CMG003
      *                                                                                       CMG003
     C                   ENDIF                                                             AR1039735
                                                                                           AR1039735
     C                   MOVEL     DDSSR1        I#BTB1
     C                   MOVEL     DDSSR2        I#BTB2
     C                   MOVEL     DDSSR3        I#BTB3
     C                   MOVEL     DDSSR4        I#BTB4
     C                   MOVEL     DDSSR5        I#BTB5
     C                   MOVEL     DDSSR6        I#BTB6
      *
     C                   SELECT
     C*****##CALP        WHENEQ    'FRAS'                                       CAP003
     C******             MOVEL     'SD2400'      E#CPGM                         CAP003
     C     ##CALP        WHENEQ    'SSI '
     C                   MOVEL     'SD0402R'     E#CPGM
     C                   OTHER
     C                   MOVEL     'ME9950'      E#CPGM
     C                   ENDSL
      *
      * Set standard message text
     C                   MOVEL     'MEC0202'     E#MSGD
     C                   MOVEL     'MEMSG'       E#MSGF
     C/COPY WNCPYSRC,ZASETNVC22
      *
     C                   CALL      'ME9950'
     C                   PARM                    W0RTN             7
     C                   PARM                    I#PARM                         I Input Parms
     C                   PARM                    O#PARM                         O Output Parms
     C                   PARM                    E#PARM                         E Error Inform
     C                   PARM                    Z#PARM          256            B User Defined
     C/COPY WNCPYSRC,ZASETNVC23
      *
      * On return if errors copy into error array
      *
     C                   MOVEL     O#BTB1        DDSSR1
     C                   MOVEL     O#BTB2        DDSSR2
     C                   MOVEL     O#BTB3        DDSSR3
     C                   MOVEL     O#BTB4        DDSSR4
     C                   MOVEL     O#BTB5        DDSSR5
     C                   MOVEL     O#BTB6        DDSSR6
     C/COPY WNCPYSRC,ZASETNVC24
      *
      ** Subtract 1 from error array index
     C                   SUB       1             E#INDX
      *                                                                                       CSW214
     C     ##CALP        IFEQ      'FXDL'                                                     CSW214
     C     ##CALP        OREQ      'FRA'                                                      CSW214
     C     ##CALP        OREQ      'SIRS'                                                     CSW214
     C     ##CALP        OREQ      'CIRS'                                                     CSW214
     C     CSW214        IFEQ      'Y'                                                        CSW214
     C     E#WARN        ANDEQ     'Y'                                                        CSW214
     C     1             DO        E#INDX        Q#                                           CSW214
     C                   ADD       1             WIdx                                         CSW214
     C                   EVAL      WMessageID = '5047377'                                     CSW214
     C                   EVAL      WMsgIDArr(WIdx) = WMessageID                               CSW214
     C                   EVAL      WFldNameArr(WIdx) = 'DDSSR1'                               CSW214
     C                   ENDDO                                                                CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
      *
     C     E#ERRM        IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSSR1'
     C**********         EVAL      MsgIDArr(Idx) = 'ESM0X02'                    CAP003
     C     ##CALP        IFEQ      'FXDL'                                                     CSW212
     C     CSW212        ANDEQ     'Y'                                                        CSW212
     C                   EVAL      MsgIDArr(Idx) = '5045759'                                  CSW212
     C                   ELSE                                                                 CSW212
     C**********         EVAL      MsgIDArr(Idx) = 'ESM0601'                         CAP003 MD029779
     C                   EVAL      MsgIDArr(Idx) = '5047379'                                MD029779
     C                   ENDIF                                                                CSW212
     C                   MOVE      'N'           DDSsr1OK
     C                   MOVE      'N'           DDSsr2OK
     C                   MOVE      'N'           DDSsr3OK
     C                   MOVE      'N'           DDSsr4OK
     C                   MOVE      'N'           DDSsr5OK
     C                   MOVE      'N'           DDSsr6OK
     C                   ENDIF
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLCNDI - VALIDATE CONDITIONS                                  *
     C*                                                               *
     C*****************************************************************
     C     VLCNDI        BEGSR
      *
      **  Conditions
      *
      **     Condition 1 mandatory if Agreement type is 'OTHER'
      *
     C     ##TTYP        IFEQ      'RS'
     C     ##TTYP        OREQ      'RX'
     C     ##CALP        OREQ      'SSI '
     C     ##TTYP        ANDEQ     'AT'
     C     CSW005        ANDEQ     'Y'
     C     ##CALP        OREQ      'FXDL'                                                     CSW212
     C     CSW212        ANDEQ     'Y'                                                        CSW212
     C     DDAGTY        IFEQ      'OTHER'
     C     DDCND1        ANDEQ     *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCND1'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0400'
     C                   MOVE      'N'           DDCnd1OK
     C                   ENDIF
     C                   ENDIF
      *
      **     Other validation
      *
     C                   CLEAR                   I#PARM
     C                   CLEAR                   E#PARM
     C                   CLEAR                   O#PARM
      *
      * Set standard message text
     C                   MOVEL     'MEC0203'     E#MSGD
     C                   MOVEL     'MEMSG'       E#MSGF
     C*
     C                   MOVEL(P)  ':77D:'       I#VFLD
     C                   MOVEL(P)  ##TTYP        I#TTYP
     C                   MOVEL     'FI'          I#MMOD
     C                   MOVEL     DDCND1        I#BTB1
     C                   MOVEL     DDCND2        I#BTB2
     C                   MOVEL     DDCND3        I#BTB3
     C                   MOVEL     DDCND4        I#BTB4
     C                   MOVEL     DDCND5        I#BTB5
     C                   MOVEL     DDCND6        I#BTB6
      *
     C                   SELECT
     C*****##CALP        WHENEQ    'FRAS'                                       CAP003
     C******             MOVEL     'SD2400'      E#CPGM                         CAP003
     C     ##CALP        WHENEQ    'SSI '
     C                   MOVEL     'SD0402R'     E#CPGM
     C                   OTHER
     C******             MOVEL     'ME9950'      E#CPGM                         CAP003
     C                   MOVEL     'ME9960'      E#CPGM                         CAP003
     C                   ENDSL
      *
     C     CSW212        IFEQ      'Y'                                                        CSW212
     C     ##CALP        ANDEQ     'FXDL'                                                     CSW212
     C                   MOVEL     '300'         I#MTYP                                       CSW212
     C                   MOVEL     'FX'          I#TTYP                                       CSW212
      *                                                                                       CMG003
      ** If CMG003 is *ON, use I#MTYP = '600' if one and only the                             CMG003
      ** currency (Purchase or Sell) is flagged as previous metal and                         CMG003
      ** if the transaction type is related to FX deal                                        CMG003
      *                                                                                       CMG003
     C                   IF        CMG003 = 'Y'                                               CMG003
     C                   IF        ##TTYP <> 'CL' AND                                         CMG003
     C                             ##TTYP <> 'NX'                                             CMG003
     C                   IF        (WPayPMRT = 'Y' AND WRecPMRT = 'N') OR                     CMG003
     C                             (WPayPMRT = 'N' AND WRecPMRT = 'Y')                        CMG003
     C                   EVAL      I#MTYP = '600'                                             CMG003
     C                   ENDIF                                                                CMG003
     C                   ENDIF                                                                CMG003
     C                   ENDIF                                                                CMG003
                                                                                              CMG003
     C                   ENDIF                                                                CSW212
      *                                                                                       CSW212
     C     I#TTYP        IFEQ      'FX'                                                       CSW213
     C     I#TTYP        OREQ      'OP'                                                       CSW213
     C     I#TTYP        OREQ      'FF'                                                       CSW213
     C     I#TTYP        OREQ      'CL'                                                       CSW213
     C     CDL008        ANDEQ     'Y'                                                        CSW213
     C     CSW213        IFEQ      'Y'                                                        CSW213
                                                                                              CSW213
     C                   EVAL      I#MTYP = '300'                                             CSW213
                                                                                              CSW213
     C                   CALLB     'AOCURRR0'                                                 CSW213
     C                   PARM      *BLANKS       @RTCD                                        CSW213
     C                   PARM      '*KEY    '    @OPTN                                        CSW213
     C                   PARM      ##RCCY        @CURR                                        CSW213
     C     SDCURR        PARM      SDCURR        DSSDY                                        CSW213
     C     @RTCD         IFEQ      *BLANKS                                                    CSW213
     C                   MOVE      A6PMRT        RPMRT             1                          CSW213
     C                   ENDIF                                                                CSW213
                                                                                              CSW213
     C                   CALLB     'AOCURRR0'                                                 CSW213
     C                   PARM      *BLANKS       @RTCD                                        CSW213
     C                   PARM      '*KEY    '    @OPTN                                        CSW213
     C                   PARM      ##PCCY        @CURR                                        CSW213
     C     SDCURR        PARM      SDCURR        DSSDY                                        CSW213
     C     @RTCD         IFEQ      *BLANKS                                                    CSW213
     C                   MOVE      A6PMRT        PPMRT             1                          CSW213
     C                   ENDIF                                                                CSW213
                                                                                              CSW213
     C*****RPMRT         IFEQ      'Y'                                                 CSW213 CSW214
     C*****PPMRT         OREQ      'Y'                                                 CSW213 CSW214
     C                   IF        (RPMRT = 'Y' AND PPMRT = 'N')                              CSW214
     C                             OR (RPMRT = 'N' AND PPMRT = 'Y')                           CSW214
     C                   EVAL      I#MTYP = '600'                                             CSW213
     C                   ENDIF                                                                CSW213
                                                                                              CSW213
     C                   ENDIF                                                                CSW213
     C                   ENDIF                                                                CSW213
                                                                                              CSW213
     C                   CALL      'ME9960'
     C                   PARM                    W0RTN             7
     C                   PARM                    I#PARM                         I Input Parms
     C                   PARM                    O#PARM                         O Output Parms
     C                   PARM                    E#PARM                         E Error Inform
     C                   PARM                    Z#PARM          256            B User Defined
      *
      * On return if errors copy into error array
      *
     C                   MOVEL     O#BTB1        DDCND1
     C                   MOVEL     O#BTB2        DDCND2
     C                   MOVEL     O#BTB3        DDCND3
     C                   MOVEL     O#BTB4        DDCND4
     C                   MOVEL     O#BTB5        DDCND5
     C                   MOVEL     O#BTB6        DDCND6
      *
      ** Subtract 1 from error array index
     C                   SUB       1             E#INDX
      *
     C     E#ERRM        IFNE      *BLANKS
     C     E#MSGD        IFNE      *BLANKS                                                    CSW212
     C     1             DO        E#INDX        Q#                                           CSW212
     C                   ADD       1             Idx                                          CSW212
     C                   EVAL      FldNameArr(Idx) = 'DDCND1'                                 CSW212
     C                   MOVEL     '5045'        WMessageID                                   CSW212
     C                   MOVE      O#E(Q#)       WMessageID                                   CSW212
     C                   EVAL      MsgIDArr(Idx) = WMessageID                                 CSW212
     C     O#E(Q#)       IFEQ      'X03'                                                      CSW212
     C                   EVAL      MsgIDArr(Idx) = 'ESM0602'                                  CSW212
     C                   ENDIF                                                                CSW212
     C                   ENDDO                                                                CSW212
     C                   ELSE                                                                 CSW212
     C*****1****         DO        E#INDX        Q#                5 0          CAP003
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCND1'
     C**********         MOVEL     'ESM0'        WMessageID                     CAP003
     C**********         MOVE      O#E(Q#)       WMessageID                     CAP003
     C**********         EVAL      MsgIDArr(Idx) = WMessageID                   CAP003
     C**********         ENDDO                                                  CAP003
     C                   EVAL      MsgIDArr(Idx) = 'ESM0602'                    CAP003
     C                   ENDIF                                                                CSW212
     C                   MOVEL     'N'           DDCnd1OK
     C                   MOVEL     'N'           DDCnd2OK
     C                   MOVEL     'N'           DDCnd3OK
     C                   MOVEL     'N'           DDCnd4OK
     C                   MOVEL     'N'           DDCnd5OK
     C                   MOVEL     'N'           DDCnd6OK
     C                   ENDIF
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* VLAGRD - VALIDATE AGREEMENT DETAILS                           *
     C*                                                               *
     C*****************************************************************
     C     VLAGRD        BEGSR
      *                                                                         CSW097
     C     ##TTYP        IFEQ      'RS'                                         CSW097
     C     ##TTYP        OREQ      'RX'                                         CSW097
     C     ##TTYP        OREQ      'AT'                                         CSW097
     C     CSW005        ANDEQ     'Y'                                          CSW200
      *                                                                         CSW097
      **  Allow all blank entry for type AT only                                CSW097
      *                                                                         CSW097
     C     DDISDA        IFNE      *BLANKS                                      CSW097
     C     DDAGTY        ORNE      *BLANKS                                      CSW097
     C     DDAGDT        ORNE      *BLANKS                                      CSW097
     C     DDAGVV        ORNE      *BLANKS                                      CSW097
     C     ##TTYP        OREQ      'RS'                                         CSW097
     C     ##TTYP        OREQ      'RX'                                         CSW097
      *
      **  ISDA Rules version must be numeric
      **  RS/RX                                                                 CSW097
      *
     C     DDAGTY        IFNE      'ISDA  '                                     CSW097
     C     DDAGTY        ANDNE     'OTHER '                                     CSW097
     C     DDISDA        IFNE      *BLANKS                                      CSW097
     C     DDISDA        ANDNE     '0000'                                       CSW097
     C                   ADD       1             Idx                            CSW097
     C                   EVAL      FldNameArr(Idx) = 'DDISDA'                   CSW097
     C                   EVAL      MsgIDArr(Idx) = 'ESM0407'                    CSW097
     C                   MOVEL     'N'           DDIsdaOK                       CSW097
     C                   ENDIF                                                  CSW097
     C                   ENDIF                                                  CSW097
      *                                                                         CSW097
     C     DDAGTY        IFEQ      'ISDA  '                                     CSW097
     C     DDAGTY        OREQ      'OTHER '                                     CSW097
     C     DDISDA        ANDNE     *BLANKS                                      CSW097
     C                   MOVE      '0'           WISDA             5            CSW097
     C                   MOVEL     DDISDA        WISDA             5            CSW097
     C                   TESTN                   WISDA                99        CSW097
     C***********        TESTN                   DDISDA               99        CSW097
     C     *IN99         IFEQ      *OFF
     C     DDISDA        OREQ      *ZEROS                                       CSW097
     C     DDAGTY        ANDEQ     'ISDA  '                                     CSW097
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDISDA'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0406'
     C                   MOVEL     'N'           DDIsdaOK
     C                   ENDIF
     C                   ENDIF                                                  CSW097
      *                                                                                       CSW201
      ** If SWIFT 2001 is installed, DDISDA may be '2000'                                     CSW201
      *                                                                                       CSW201
     C     CSW201        IFEQ      'Y'                                                        CSW201
     C     DDISDA        ANDEQ     '2000'                                                     CSW201
     C                   MOVEL     'Y'           WY2000            1                          CSW201
     C                   ELSE                                                                 CSW201
     C                   MOVEL     'N'           WY2000                                       CSW201
     C                   ENDIF                                                                CSW201
                                                                                CSW200
     C     DDAGTY        IFEQ      'ISDA  '                                     CSW200
     C     DDISDA        IFNE      '1991'                                       CSW200
     C     DDISDA        ANDNE     '1998'                                       CSW200
     C     WY2000        ANDNE     'Y'                                                        CSW201
     C     DDISDA        ANDNE     '2006'                                                     254023
     C                   ADD       1             Idx                            CSW200
     C                   EVAL      FldNameArr(Idx) = 'DDISDA'                   CSW200
     C***********        EVAL      MsgIDArr(Idx) = 'ESM0414'                           CSW200 CSW201
     C**********         EVAL      MsgIDArr(Idx) = 'ESM0417'                           CSW201 CSW202
     C                   EVAL      MsgIDArr(Idx) = 'ESM0414'                                  CSW202
     C                   MOVEL     'N'           DDIsdaOK                       CSW200
     C                   ENDIF                                                  CSW200
     C                   ENDIF                                                  CSW200
      *
      **  Agreement Type
      **  RS/RX                                                                 CSW097
      *
     C     DDAGTY        IFNE      'ISDA  '
     C     DDAGTY        ANDNE     'AFB   '
     C     DDAGTY        ANDNE     'BBAIRS'
     C     DDAGTY        ANDNE     'OTHER '
     C     DDAGTY        ANDNE     'DERV  '                                                   CSW202
     C     DDAGTY        ANDNE     'ISDACN'                                                   CSW214
     C     DDAGTY        OREQ      'DERV  '                                                   CSW202
     C     CSW202        ANDEQ     'N'                                                        CSW202
     C     DDAGTY        OREQ      'ISDACN'                                                   CSW214
     C     CSW214        ANDEQ     'N'                                                        CSW214
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAGTY'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0401'
     C                   MOVEL     'N'           DDAgtyOK
     C                   ENDIF
      *
      **  Agreement Date
      **  RS/RX                                                                 CSW097
      *
     C*****DDAGTY        IFEQ      'OTHER'                                      CSW097
     C     DDAGTY        IFEQ      'BBAIRS'                                     CSW097
      *
     C     DDAGDT        IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAGDT'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0402'
     C                   MOVEL     'N'           DDAgdtOK
     C                   ENDIF
      *
     C                   ELSE
      *                                                                         CSW097
     C     DDAGTY        IFEQ      'OTHER '                                     CSW097
     C     DDAGDT        ANDNE     *BLANKS                                      CSW097
     C     DDAGTY        OREQ      'OTHER '                                     CSW097
     C     DDAGVV        ANDNE     *BLANK                                       CSW097
     C     DDAGDT        ANDEQ     *BLANK                                       CSW097
     C     DDAGTY        ORNE      'OTHER '                                     CSW097
      *
      **  Input date must be in YYMMDD format
      **  RS/RX                                                                 CSW097
      *
     C                   MOVE      '0'           WAGDT             7            CSW097
     C                   MOVEL     DDAGDT        WAGDT                          CSW097
     C                   TESTN                   WAGDT                99        CSW097
     C***********        TESTN                   DDAGDT               99        CSW097
      *
      ** Non Numeric Date
     C     *IN99         IFEQ      *OFF
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAGDT'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0403'
     C                   MOVEL     'N'           DDAgdtOK
     C                   ELSE
      *
      ** Numeric Date
     C                   MOVEL     DDAGDT        W#AGDR
     C                   Z-ADD     W#DDR         W#DD
     C                   Z-ADD     W#MMR         W#MM
     C                   Z-ADD     W#YYR         W#YY
     C                   RESET                   RetCodeOut
     C                   CALLB     'ZAVDATE'
     C                   PARM                    RetCodeOut
     C                   PARM                    W#AGDT
     C                   PARM      'D'           Datefmt           1
     C                   PARM                    @DAYNO            5 0
      *
      ** Error in form of date
     C     RetCodeOut    IFEQ      'Error'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAGDT'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0403'
     C                   MOVEL     'N'           DDAgdtOK
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                  CSW097
      *
      **  Agreement Version
      **  RS/RX                                                                 CSW097
      *
     C*****DDAGTY        IFEQ      'OTHER''                                     CSW097
     C     DDAGTY        IFEQ      'BBAIRS'                                     CSW097
     C     DDAGVV        IFNE      *BLANKS
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAGVV'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0404'
     C                   MOVEL     'N'           DDAgvvOK
     C                   ENDIF
     C                   ELSE
      *                                                                         CSW097
     C     DDAGTY        IFEQ      'OTHER '                                     CSW097
     C     DDAGVV        ANDNE     *BLANKS                                      CSW097
     C     DDAGTY        OREQ      'OTHER '                                     CSW097
     C     DDAGDT        ANDNE     *BLANK                                       CSW097
     C     DDAGVV        ANDEQ     *BLANK                                       CSW097
     C     DDAGTY        ORNE      'OTHER '                                     CSW097
     C                   MOVE      '0'           WAGVV             5            CSW097
     C                   MOVEL     DDAGVV        WAGVV                          CSW097
     C                   TESTN                   WAGVV                99        CSW097
     C***********        TESTN                   DDAGVV               99        CSW097
      *
      ** Version must be numeric
     C     *IN99         IFEQ      *OFF
     C     DDAGVV        OREQ      *ZEROS                                       CSW097
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAGVV'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0405'
     C                   MOVEL     'N'           DDAgvvOK
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                  CSW097
     C                   ENDIF                                                  CSW097
      *
     C                   ELSE                                                   CSW097
      *                                                                         CSW097
     C     ##TTYP        IFEQ      'FR'                                         CSW097
     C     ##TTYP        OREQ      'AT'                                         CSW200
     C     CSW011        ANDEQ     'Y'                                          CSW200
     C     CSW200        ANDEQ     'Y'                                          CSW200
      *                                                                         CSW097
      ** Validate ISDA fields for FR type agreement                             CSW097
      *                                                                         CSW097
      ** Allow all blank entry                                                  CSW097
      *                                                                         CSW097
     C     DDISDA        IFNE      *BLANKS                                      CSW097
     C     DDAGTY        ORNE      *BLANKS                                      CSW097
     C     DDAGDT        ORNE      *BLANKS                                      CSW097
     C     DDAGVV        ORNE      *BLANKS                                      CSW097
      *                                                                         CSW097
      ** FR ISDA Rules version must be numeric                                  CSW097
      *                                                                         CSW097
     C     DDAGTY        IFNE      'ISDA  '                                     CSW097
     C     DDISDA        IFNE      *BLANKS                                      CSW097
     C     DDISDA        ANDNE     '0000'                                       CSW097
     C                   ADD       1             Idx                            CSW097
     C                   EVAL      FldNameArr(Idx) = 'DDISDA'                   CSW097
     C                   EVAL      MsgIDArr(Idx) = 'ESM0408'                    CSW097
     C                   MOVEL     'N'           DDIsdaOK                       CSW097
     C                   ENDIF                                                  CSW097
     C                   ENDIF                                                  CSW097
     C     DDAGTY        IFEQ      'ISDA  '                                     CSW097
     C                   MOVE      '0'           WISDA             5            CSW097
     C                   MOVEL     DDISDA        WISDA             5            CSW097
     C                   TESTN                   WISDA                99        CSW097
     C     *IN99         IFEQ      *OFF                                         CSW097
     C     DDISDA        OREQ      *ZEROS                                       CSW097
     C                   ADD       1             Idx                            CSW097
     C                   EVAL      FldNameArr(Idx) = 'DDISDA'                   CSW097
     C                   EVAL      MsgIDArr(Idx) = 'ESM0406'                    CSW097
     C                   MOVEL     'N'           DDIsdaOK                       CSW097
     C                   ENDIF                                                  CSW097
     C                   ENDIF                                                  CSW097
      *                                                                                       CSW201
      ** If SWIFT 2001 is installed, DDISDA may be '2000'                                     CSW201
      *                                                                                       CSW201
     C     CSW201        IFEQ      'Y'                                                        CSW201
     C     DDISDA        ANDEQ     '2000'                                                     CSW201
     C                   MOVEL     'Y'           WY2000                                       CSW201
     C                   ELSE                                                                 CSW201
     C                   MOVEL     'N'           WY2000                                       CSW201
     C                   ENDIF                                                                CSW201
                                                                                CSW200
     C     DDAGTY        IFEQ      'ISDA  '                                     CSW200
     C     DDISDA        IFNE      '1991'                                       CSW200
     C     DDISDA        ANDNE     '1998'                                       CSW200
     C     WY2000        ANDNE     'Y'                                                        CSW201
     C     DDISDA        ANDNE     '2006'                                                     254023
     C                   ADD       1             Idx                            CSW200
     C                   EVAL      FldNameArr(Idx) = 'DDISDA'                   CSW200
     C***********        EVAL      MsgIDArr(Idx) = 'ESM0414'                           CSW200 CSW201
     C**********         EVAL      MsgIDArr(Idx) = 'ESM0417'                           CSW201 CSW202
     C                   EVAL      MsgIDArr(Idx) = 'ESM0414'                                  CSW202
     C                   MOVEL     'N'           DDIsdaOK                       CSW200
     C                   ENDIF                                                  CSW200
     C                   ENDIF                                                  CSW200
      *                                                                         CSW097
      ** FR Agreement Type                                                      CSW097
      *                                                                         CSW097
     C     DDAGTY        IFNE      'ISDA'                                       CSW097
     C     DDAGTY        ANDNE     'AFB'                                        CSW097
     C     DDAGTY        ANDNE     'DERV'                                       CSW200
     C     DDAGTY        ANDNE     'FRABBA'                                     CSW200
     C     DDAGTY        ANDNE     'EMA'                                                      CSW214
     C     DDAGTY        ANDNE     'ISDACN'                                                   CSW214
     C     DDAGTY        ANDNE     'OTHER'                                                    CSW214
     C     DDAGTY        OREQ      'DERV'                                       CSW200
     C     CSW200        ANDEQ     'N'                                          CSW200
     C     DDAGTY        OREQ      'FRABBA'                                     CSW200
     C     CSW200        ANDEQ     'N'                                          CSW200
     C     DDAGTY        OREQ      'ISDACN'                                                   CSW214
     C     CSW214        ANDEQ     'N'                                                        CSW214
     C                   ADD       1             Idx                            CSW097
     C                   EVAL      FldNameArr(Idx) = 'DDAGTY'                   CSW097
     C                   EVAL      MsgIDArr(Idx) = 'ESM0409'                    CSW097
     C                   MOVEL     'N'           DDAgtyOK                       CSW097
     C                   ENDIF                                                  CSW097
      *                                                                         CSW097
      ** FR Agreement Date                                                      CSW097
      *                                                                         CSW097
     C     CSW200        IFEQ      'Y'                                          CSW200
     C     DDAGTY        ANDEQ     'FRABBA'                                     CSW200
     C     DDAGDT        ANDNE     *BLANKS                                      CSW200
     C                   ADD       1             Idx                            CSW200
     C                   EVAL      FldNameArr(Idx) = 'DDAGDT'                   CSW200
     C                   EVAL      MsgIDArr(Idx) = 'ESM0415'                    CSW200
     C                   MOVEL     'N'           DDAgdtOK                       CSW200
     C                   ENDIF                                                  CSW200
      *                                                                         CSW200
     C     CSW200        IFEQ      'Y'                                          CSW200
     C     DDAGDT        ANDNE     *BLANKS                                      CSW200
     C     CSW200        OREQ      'N'                                          CSW200
      *                                                                         CSW200
      ** FR Input date, must be in YYMMDD format                                CSW097
      *                                                                         CSW097
     C                   MOVE      '0'           WAGDT             7            CSW097
     C                   MOVEL     DDAGDT        WAGDT                          CSW097
     C                   TESTN                   WAGDT                99        CSW097
     C     *IN99         IFEQ      *OFF                                         CSW097
     C                   ADD       1             Idx                            CSW097
     C                   EVAL      FldNameArr(Idx) = 'DDAGDT'                   CSW097
     C                   EVAL      MsgIDArr(Idx) = 'ESM0403'                    CSW097
     C                   MOVEL     'N'           DDAgdtOK                       CSW097
     C                   ELSE                                                   CSW097
      *                                                                         CSW097
      ** Numeric Date                                                           CSW097
     C                   MOVEL     DDAGDT        W#AGDR                         CSW097
     C                   Z-ADD     W#DDR         W#DD                           CSW097
     C                   Z-ADD     W#MMR         W#MM                           CSW097
     C                   Z-ADD     W#YYR         W#YY                           CSW097
     C                   RESET                   RetCodeOut                     CSW097
     C                   CALLB     'ZAVDATE'                                    CSW097
     C                   PARM                    RetCodeOut                     CSW097
     C                   PARM                    W#AGDT                         CSW097
     C                   PARM      'D'           Datefmt                        CSW097
     C                   PARM                    @DAYNO                         CSW097
      *                                                                         CSW097
      ** Error in form of date                                                  CSW097
     C     RetCodeOut    IFEQ      'Error'                                      CSW097
     C                   ADD       1             Idx                            CSW097
     C                   EVAL      FldNameArr(Idx) = 'DDAGDT'                   CSW097
     C                   EVAL      MsgIDArr(Idx) = 'ESM0403'                    CSW097
     C                   MOVEL     'N'           DDAgdtOK                       CSW097
     C                   ENDIF                                                  CSW097
     C                   ENDIF                                                  CSW097
      *                                                                         CSW097
     C                   ENDIF                                                  CSW200
      *                                                                         CSW200
      ** FR Agreement Version                                                   CSW097
      *                                                                         CSW097
     C     CSW200        IFEQ      'Y'                                          CSW200
     C     DDAGTY        ANDEQ     'FRABBA'                                     CSW200
     C     DDAGVV        ANDNE     *BLANKS                                      CSW200
     C                   ADD       1             Idx                            CSW200
     C                   EVAL      FldNameArr(Idx) = 'DDAGVV'                   CSW200
     C                   EVAL      MsgIDArr(Idx) = 'ESM0416'                    CSW200
     C                   MOVEL     'N'           DDAgvvOK                       CSW200
     C                   ENDIF                                                  CSW200
      *                                                                         CSW200
     C     CSW200        IFEQ      'Y'                                          CSW200
     C     DDAGVV        ANDNE     *BLANKS                                      CSW200
     C     CSW200        OREQ      'N'                                          CSW200
      *                                                                         CSW200
     C                   MOVE      '0'           WAGVV             5            CSW097
     C                   MOVEL     DDAGVV        WAGVV                          CSW097
     C                   TESTN                   WAGVV                99        CSW097
     C     *IN99         IFEQ      *OFF                                         CSW097
     C     DDAGVV        OREQ      *ZEROS                                       CSW097
     C                   ADD       1             Idx                            CSW097
     C                   EVAL      FldNameArr(Idx) = 'DDAGVV'                   CSW097
     C                   EVAL      MsgIDArr(Idx) = 'ESM0405'                    CSW097
     C                   MOVEL     'N'           DDAgvvOK                       CSW097
     C                   ENDIF                                                  CSW097
     C                   ENDIF                                                  CSW200
     C                   ENDIF                                                  CSW097
     C                   ENDIF                                                  CSW097
     C                   ENDIF                                                  CSW097
      *                                                                         CSW097
      ** Additional validations for FXDL if CSW212 is ON.                                     CSW212
      *                                                                                       CSW212
     C     ##CALP        IFEQ      'FXDL'                                                     CSW212
     C     CSW212        ANDEQ     'Y'                                                        CSW212
      *                                                                                       CSW212
      ** ISDA Rules version must be a valid year starting with 199 or 20.                     CSW212
      *                                                                                       CSW212
     C     DDISDA        IFNE      *BLANKS                                                    CSW212
     C     DDISDA        ANDNE     '0000'                                                     CSW212
     C                   MOVEL     DDISDA        ISDA3             3                          CSW212
     C                   MOVEL     DDISDA        ISDA2             2                          CSW212
     C     ISDA3         IFNE      '199'                                                      CSW212
     C     ISDA2         ANDNE     '20'                                                       CSW212
     C                   ADD       1             Idx                                          CSW212
     C                   EVAL      FldNameArr(Idx) = 'DDISDA'                                 CSW212
     C                   EVAL      MsgIDArr(Idx) = '5045747'                                  CSW212
     C                   MOVEL     'N'           DDIsdaOK                                     CSW212
     C                   ENDIF                                                                CSW212
     C                   MOVE      '0'           WISDA                                        CSW212
     C                   MOVEL     DDISDA        WISDA                                        CSW212
     C                   TESTN                   WISDA                99                      CSW212
     C     *IN99         IFEQ      *OFF                                                       CSW212
     C                   ADD       1             Idx                                          CSW212
     C                   EVAL      FldNameArr(Idx) = 'DDISDA'                                 CSW212
     C                   EVAL      MsgIDArr(Idx) = 'ESM0406'                                  CSW212
     C                   MOVEL     'N'           DDIsdaOK                                     CSW212
     C                   ENDIF                                                                CSW212
     C                   ENDIF                                                                CSW212
      *                                                                                       CSW212
      ** ISDA Agreement Type must only be any of the following:                               CSW212
      *                                                                                       CSW212
     C     DDAGTY        IFNE      *BLANKS                                                    CSW212
     C     DDAGTY        IFNE      'AFB'                                                      CSW212
     C     DDAGTY        ANDNE     'DERV'                                                  AR1000515
     C     DDAGTY        ANDNE     'FBF'                                                      CSW212
     C     DDAGTY        ANDNE     'FEOMA'                                                    CSW212
     C     DDAGTY        ANDNE     'ICOM'                                                     CSW212
     C     DDAGTY        ANDNE     'IFEMA'                                                    CSW212
     C     DDAGTY        ANDNE     'ISDA'                                                     CSW212
     C     DDAGTY        ANDNE     'OTHER'                                                    CSW212
     C     DDAGTY        ANDNE     'ISDACN'                                                   CSW214
     C     DDAGTY        OREQ      'ISDACN'                                                   CSW214
     C     CSW214        ANDEQ     'N'                                                        CSW214
     C                   ADD       1             Idx                                          CSW212
     C                   EVAL      FldNameArr(Idx) = 'DDAGTY'                                 CSW212
     C                   EVAL      MsgIDArr(Idx) = '5045748'                                  CSW212
     C                   MOVEL     'N'           DDAgtyOK                                     CSW212
     C                   ENDIF                                                                CSW212
      *                                                                                     MD030342
     C                   IF        I#MTYP = '600' AND                                       MD030342
     C                             (DDAGTY <> 'ISDA' AND                                    MD030342
     C                              DDAGTY <> 'OTHER')                                      MD030342
     C                   ADD       1             Idx                                        MD030342
     C                   EVAL      FldNameArr(Idx) = 'DDAGTY'                               MD030342
     C                   EVAL      MsgIDArr(Idx) = '5047391'                                MD030342
     C                   MOVEL     'N'           DDAgtyOK                                   MD030342
     C                   ENDIF                                                              MD030342
      *                                                                                       CSW212
     C                   ELSE                                                                 CSW212
      *                                                                                       CSW214
     C                   IF        CSW214 = 'Y' AND                                           CSW214
     C                             I#MTYP = '600'                                             CSW214
     C                   ADD       1             Idx                                          CSW214
     C                   EVAL      FldNameArr(Idx) = 'DDAGTY'                                 CSW214
     C                   EVAL      MsgIDArr(Idx) = '5047390'                                  CSW214
     C                   MOVEL     'N'           DDAgtyOK                                     CSW214
     C                   ENDIF                                                                CSW214
      *                                                                                       CSW212
      ** Mandatory if ISDA agreement date or version is inserted                              CSW212
      *                                                                                       CSW212
     C     DDAGDT        IFNE      *BLANKS                                                    CSW212
     C     DDAGVV        ORNE      *BLANKS                                                    CSW212
     C                   ADD       1             Idx                                          CSW212
     C                   EVAL      FldNameArr(Idx) = 'DDAGTY'                                 CSW212
     C                   EVAL      MsgIDArr(Idx) = '5045749'                                  CSW212
     C                   MOVEL     'N'           DDAgtyOK                                     CSW212
     C                   ENDIF                                                                CSW212
      *                                                                                       CSW212
     C                   ENDIF                                                                CSW212
      *                                                                                       CSW212
      ** ISDA Agreement Date must be valid in YYMMDD format                                   CSW212
      *                                                                                       CSW212
     C     DDAGDT        IFNE      *BLANKS                                                    CSW212
     C                   MOVE      '0'           WAGDT                                        CSW212
     C                   MOVEL     DDAGDT        WAGDT                                        CSW212
     C                   TESTN                   WAGDT                99                      CSW212
     C     *IN99         IFEQ      *OFF                                                       CSW212
     C                   ADD       1             Idx                                          CSW212
     C                   EVAL      FldNameArr(Idx) = 'DDAGDT'                                 CSW212
     C                   EVAL      MsgIDArr(Idx) = 'ESM0403'                                  CSW212
     C                   MOVEL     'N'           DDAgdtOK                                     CSW212
     C                   ELSE                                                                 CSW212
      *                                                                                       CSW212
      ** Numeric Date                                                                         CSW212
      *                                                                                       CSW212
     C                   MOVEL     DDAGDT        W#AGDR                                       CSW212
     C                   Z-ADD     W#DDR         W#DD                                         CSW212
     C                   Z-ADD     W#MMR         W#MM                                         CSW212
     C                   Z-ADD     W#YYR         W#YY                                         CSW212
     C                   RESET                   RetCodeOut                                   CSW212
     C                   CALLB     'ZAVDATE'                                                  CSW212
     C                   PARM                    RetCodeOut                                   CSW212
     C                   PARM                    W#AGDT                                       CSW212
     C                   PARM      'D'           Datefmt                                      CSW212
     C                   PARM                    @DAYNO                                       CSW212
      *                                                                                       CSW212
      ** Error in form of date                                                                CSW212
      *                                                                                       CSW212
     C     RetCodeOut    IFEQ      'Error'                                                    CSW212
     C                   ADD       1             Idx                                          CSW212
     C                   EVAL      FldNameArr(Idx) = 'DDAGDT'                                 CSW212
     C                   EVAL      MsgIDArr(Idx) = 'ESM0403'                                  CSW212
     C                   MOVEL     'N'           DDAgdtOK                                     CSW212
     C                   ENDIF                                                                CSW212
     C                   ENDIF                                                                CSW212
     C                   ENDIF                                                                CSW212
      *                                                                                       CSW212
      ** ISDA Agreement Version must be numeric                                               CSW212
      *                                                                                       CSW212
     C     DDAGVV        IFNE      *BLANKS                                                    CSW212
     C     DDAGVV        ANDNE     '0000'                                                     CSW212
     C                   MOVE      '0'           WAGVV                                        CSW212
     C                   MOVEL     DDAGVV        WAGVV                                        CSW212
     C                   TESTN                   WAGVV                99                      CSW212
      *                                                                                       CSW212
     C     *IN99         IFEQ      *OFF                                                       CSW212
     C     DDAGVV        OREQ      *ZEROS                                                     CSW212
     C                   ADD       1             Idx                                          CSW212
     C                   EVAL      FldNameArr(Idx) = 'DDAGVV'                                 CSW212
     C                   EVAL      MsgIDArr(Idx) = 'ESM0405'                                  CSW212
     C                   MOVEL     'N'           DDAgvvOK                                     CSW212
     C                   ENDIF                                                                CSW212
     C                   ENDIF                                                                CSW212
      *                                                                                       CSW212
     C                   ENDIF                                                                CSW212
      *                                                                                       CSW212
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*
     C* PARTYT - DETERMINE PARTY TYPE
     C*
     C*****************************************************************
     C     PARTYT        BEGSR
      *
      * INITIALIZE OUTPUT FIELDS. THEY ARE:
      *
      * @PARTY. TAKES VALUES: CUSTNUM = CUSTOMER NUMBER
      *                       CUSTSNM = CUSTOMER SHORTNAME
      *                       COUNTNS = COUNTERPARTY NOSTRO CODE
      *                       ERROR   = ERROR (NON OF ABOVE)
      * @BANK . TAKES VALUES: 'Y'     = BANK
      *                       'N'     = NON-BANK
      *
     C/COPY WNCPYSRC,ZASETNVC01
     C                   MOVE      *BLANKS       @PARTY           10
     C                   MOVE      *BLANKS       @BANK             1
      *
      ** CHECK FOR CUSTOMER NUMBER OR SHORTNAME
      *
     C                   MOVE      *BLANKS       @KEY1            10
     C                   MOVEL     P#PART        @KEY1
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY1
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      *BLANKS       DSSDY
      *
      * CUSTOMER FOUND
      *
     C     @RTCD         IFEQ      *BLANKS
      *
      ** CUSTOMER NUMBER OR SHORTNAME?
      *
     C     @KYST         IFEQ      '*CNUM  '
     C                   MOVEL     'CUSTNUM'     @PARTY
     C                   ELSE
     C                   MOVEL     'CUSTSNM'     @PARTY
     C                   END
      *
      ** TEST FOR BANK/NON-BANK WHEN LIVE CUSTOMER FOUND
      *
     C*****BBBNBI****    IFNE      'Y'                                          166320
     C     BBSWFI        IFNE      'Y'                                          166320
     C                   MOVE      'N'           @BANK
     C                   ELSE
     C                   MOVE      'Y'           @BANK
     C                   END
      *
      ** ELSE: NO VALID CUSTOMER NUMBER OR SHORTNAME RETURNED
      **       CHECK FOR COUNTERPARTY NOSTRO (IF ALLOWED)
      *
     C                   ELSE
      *
      ** COUNTERPARTY NOSTRO NOT ALLOWED
      *
     C     @CPNAL        IFNE      'ALLOWED '
     C                   MOVEL     'ERROR  '     @PARTY
     C                   ELSE
     C                   MOVE      *BLANKS       @CBNB             8
     C                   MOVEL     P#PART        @CBNB
      *
     C                   CALL      'AOCNSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CBNB
     C     SDCNST        PARM      SDCNST        DSFDY
      *
      * VALID COUNTERPARTY NOSTRO, OR NOT
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'COUNTNS'     @PARTY
     C                   ELSE
     C                   MOVEL     'ERROR  '     @PARTY
     C                   END
      *
     C                   END
      *
     C                   END
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* DEFPAY   - Do Payment side Defaulting                         *
     C*                                                               *
     C*****************************************************************
     C     DEFPAY        BEGSR
      *
      * FIND OUT WHAT THE PAY SETTLEMENT BRANCH IS
      *
     C                   EXSR      PYSETB
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     A7BRCD        @PSETB            3
     C                   ELSE
     C                   GOTO      EDEFPY
     C                   END
      *
      * FIELD 58, BENEFICIARY
      * ---------------------
      * BENEFICIARY DEFAULTS TO THE DEAL COUNTERPARTY
      *
     C     DDBENN        IFEQ      *BLANKS
     C                   MOVEL     ##CSNM        DDBENN
     C                   END
      *
      * FIND WHETHER BENEFICIARY IS A BANK AND
      * STORE INFORMATION FOR LATER USE
      *
     C                   MOVEL     DDBENN        @CSCN
     C                   EXSR      ACCUST
     C     @RTCD         IFEQ      *BLANKS
     C**********         MOVEL     BBBNBI        @BBNBI                                       197865
     C                   MOVEL     BBSWFI        @BBNBI                                       197865
     C                   ELSE
     C                   GOTO      EDEFPY
     C                   END
      *
      * FIELD 72, BANK TO BANK INFORMATION
      * ----------------------------------
      * FOR DEALS INPUT ONLY:
      *                    IF THE DEAL IS SETTLED VIA SWIFT AND
      * IF THE BENEFICIARY IS A BANK, AND NOT THE DEAL COUNTERPARTY
      * AND THE DEAL COUNTERPARTY IS ALSO A BANK AND THE DEAL BOOKING
      * BRANCH DIFFERS FROM THE SETTLEMENT BRANCH, DEFAULT FIELD 72.
      *
     C     ##CALP        IFNE      'SSI '
     C     DDBTB1        ANDEQ     *BLANKS
      *
     C     DDPSTM        ANDEQ     '08'
     C     @BBNBI        ANDEQ     'Y'
     C     DDBENN        ANDNE     @CCSSN
     C     DDBENN        ANDNE     @CCUST
     C     @CBNBI        ANDEQ     'Y'
     C     ##BRCA        ANDNE     @PSETB
      *
     C/COPY WNCPYSRC,ZASETINV06                                                               CUT009
      * USE COUNTERPARTY SWIFT ID IF PRESENT, ELSE USE REPORT NAME AND TOWN
      *
     C     @CCSID        IFNE      *BLANKS
     C                   MOVE      @CCSID        W#WK17           17
     C                   MOVEL     W#WK17        DDBTB1
     C                   ELSE
      *
      ** FIND COUNTERPARTY REPORT NAME AND TOWN
      *
     C                   MOVEL     ##CSNM        @CSCN
     C                   EXSR      ACCUST
     C     @RTCD         IFNE      *BLANKS
     C                   GOTO      EDEFPY
     C                   END
     C                   MOVEL     BBCRNM        W#WK30           30
     C                   MOVE      BBCRTN        W#WK30
     C                   MOVE      W#WK30        DDBTB1
     C                   END
      *
     C                   MOVEL     '/INS/'       DDBTB1
     C/COPY WNCPYSRC,ZASETINV07                                                               CUT009
     C                   END
      *                                                                         CAP004
      * TELEX DEFAULTING                                                        CAP004
      *                                                                         CAP004
     C     DDPSTM        IFEQ      '01'                                         CAP004
     C                   EXSR      TELEX                                        CAP004
     C                   END                                                    CAP004
      *
      * CHIPS DEFAULTING
      *
     C     DDPSTM        IFEQ      '07'
     C                   EXSR      CHIPS
     C                   END
      *
      * SWIFT DEFAULTING
      *
     C     DDPSTM        IFEQ      '08'
     C                   EXSR      SWIFT
     C                   END
      *
     C     EDEFPY        ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* PYSETB - GET PAY SETTLEMENT BRANCH                            *
     C*                                                               *
     C*****************************************************************
     C     PYSETB        BEGSR
      *
     C                   MOVEL     DDPONS        A#OURA
     C                   MOVEL     E#PCCY        @CYCD
     C                   MOVEL     A#NOST        @NONB
      *
     C**********         CALL      'AONOSTR0'                                                 CDL094
     C                   CALL      'AONOSTR1'                                                 CDL094
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       @CUST             6
     C                   PARM                    @CYCD             3
     C**********         PARM      *BLANKS       @ACCD             4                          CGL029
     C                   PARM      *BLANKS       @ACCD                                        CGL029
     C                   PARM      *BLANKS       @ACSN             2
     C                   PARM                    @NONB             2
     C                   PARM      *BLANKS       @BRCD             3
     C                   PARM      *BLANKS       @CSSN            10
     C                   PARM      *BLANKS       @PNOI             1
     C*****SDNOST        PARM      SDNOST        DSFDY                                        CDL094
     C     SDNOST        PARM      SDNOST        DSSDY                                        CDL094
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* CHIPS - CHIPS DEFAULTING                                      *
     C*                                                               *
     C*****************************************************************
     C     CHIPS         BEGSR
      *
      * FIELD 50, ORDERING CUSTOMER (PAY SIDE)
      * --------------------------------------
      * IF THE BENEFICIARY DIFFERS FROM THE DEAL COUNTERPARTY AND THE
      * DEAL COUNTERPARTY IS A NON-BANK, THEN DEFAULT TO THE DEAL
      * COUNTERPARTY.
      *
     C     DDPOCN        IFEQ      *BLANKS
     C     DDPOBN        ANDEQ     *BLANKS                                                   BUG4490
     C     DDBENN        ANDNE     @CCSSN
     C     DDBENN        ANDNE     @CCUST
     C     @CBNBI        ANDNE     'Y'
     C                   MOVEL     ##CSNM        DDPOCN
     C                   END
      *
      * FIELD 52 - ORDERING BANK, PAY SIDE.
      * -----------------------------------
      * IF THE BENEFICIARY DIFFERS FROM THE DEAL COUNTERPARTY
      * AND THE DEAL COUNTERPARTY IS A BANK THEN DEFAULT TO DEAL
      * COUNTERPARTY.
      *
     C     DDPOBN        IFEQ      *BLANKS
     C     DDPOCN        ANDEQ     *BLANKS                                                   BUG4490
     C     DDBENN        ANDNE     @CCSSN
     C     DDBENN        ANDNE     @CCUST
     C     @CBNBI        ANDEQ     'Y'
     C                   MOVEL     ##CSNM        DDPOBN
     C                   END
      *
      * IF FIELD 57 IS BLANK THEN DISPLAY ERROR MESSAGE
      *
     C     DDAWBN        IFEQ      *BLANKS
     C     ##FFND        ANDNE     'Y'                                                      BUG12540
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAWBN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0703'
     C                   MOVE      'N'           DDAwbnOK
     C                   END
     C*
     C                   ENDSR
     C*****************************************************************
      /EJECT                                                                    CAP004
     C*****************************************************************         CAP004
     C*                                                               *         CAP004
     C* TELEX - TELEX DEFAULTING                                      *         CAP004
     C*                                                               *         CAP004
     C*****************************************************************         CAP004
     C*                                                                         CAP004
     C     TELEX         BEGSR                                                  CAP004
      *                                                                         CAP004
      * FIELD 50, ORDERING CUSTOMER (PAY SIDE)                                  CAP004
      * --------------------------------------                                  CAP004
      ** IF PAY ORDERING CUSTOMER IS NOT DEFINED                                CAP004
      ** IF THE BENEFICIARY IS A NON BANK AND THE DEAL C/PARTY IS               CAP004
      ** A NON BANK THEN DEFAULT FIELD 50 TO THE DEAL C/PARTY                   CAP004
      *                                                                         CAP004
     C     DDPOCN        IFEQ      *BLANK                                       CAP004
     C     @BBNBI        IFEQ      'N'                                          CAP004
     C     @CBNBI        ANDEQ     'N'                                          CAP004
     C                   MOVEL     ##CSNM        DDPOCN                         CAP004
     C                   END                                                    CAP004
     C                   END                                                    CAP004
      *                                                                         CAP004
     C                   ENDSR                                                  CAP004
     C*****************************************************************         CAP004
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* SWIFT - SWIFT DEFAULTING                                      *
     C*                                                               *
     C*****************************************************************
     C*
     C     SWIFT         BEGSR
      *
      * FIELD 50, ORDERING CUSTOMER (PAY SIDE)
      * --------------------------------------
      ** IF THE BENEFICIARY IS A NON BANK OR THE DEAL C/PARTY IS
      ** A NON BANK THEN DEFAULT FIELD 50 TO THE DEAL C/PARTY
      *
     C     DDPOCN        IFEQ      *BLANKS                                                   BUG4490
     C     DDPOBN        ANDEQ     *BLANKS                                                   BUG4490
     C     @BBNBI        IFEQ      'N'
     C     @CBNBI        OREQ      'N'
     C**********         MOVEL     ##CSNM        DDPOCN                                       197865
     C                   MOVEL     ##CSNM        @CSCN                                        197865
     C                   EXSR      ACCUST                                                     197865
     C     BBSWFI        IFEQ      'N'                                                        197865
     C                   MOVEL     ##CSNM        DDPOCN                                       197865
     C                   ENDIF                                                                197865
     C                   END
     C                   ENDIF                                                               BUG4490
      *
      * FIELD 52 - ORDERING BANK, PAY SIDE.
      * -----------------------------------
      *
     C/COPY WNCPYSRC,ZASETNVC31
      ***IF*SD*INPUT,*OR*BOOKING BRANCH = SETTLEMENT BRANCH                     167942
      *******************                                                       167942
     C*****##CALP********IFEQ      'SSI '                                       167942
     C*****##BRCA********OREQ      @PSETB                                       167942
      *
      * IF PAY ORDERING BANK NOT DEFINED
      * BENEFICIARY IS A BANK AND C/PARTY IS A BANK
      * AND BENEFICIARY IS NOT THE  C/PARTY
      *
     C     DDPOBN        IFEQ      *BLANKS
     C     DDPOCN        ANDEQ     *BLANKS                                                   BUG4490
     C     @BBNBI        ANDEQ     'Y'
     C     @CBNBI        ANDEQ     'Y'
     C     DDBENN        ANDNE     @CCSSN
     C     DDBENN        ANDNE     @CCUST
      *
      **  DEFAULT TO DEAL COUNTERPARTY
      *
     C                   MOVEL     ##CSNM        DDPOBN
      *
     C                   END
     C/COPY WNCPYSRC,ZASETINV08                                                               CUT009
     C*******************END                                                    167942
      *
      ***IF*NOT*SD*INPUT,*AND*BOOKING*BRANCH*IS*NOT*=*SETTLEMENT*BRANCH******** 167942
      *******************                                                       167942
     C*****##CALP********IFNE      'SSI '                                       167942
     C*****##BRCA********ANDNE     @PSETB                                       167942
     C*****DDPOBN********ANDEQ     *BLANKS                                      167942
      *******************                                                       167942
      ***GET*BOOKING*BRANCH*BICN*********************************************** 167942
      *******************                                                       167942
     C*******************CALL      'AOBRCHR0'                                   167942
     C*******************PARM      *BLANKS       @RTCD                          167942
     C*******************PARM      '*KEY'        @OPTN                          167942
     C*******************PARM                    ##BRCA                         167942
     C*****SDBRCH********PARM      SDBRCH        DSFDY                          167942
      *******************                                                       167942
      ***ACCESS*CUSTOMER*FOR*THIS*BICN***************************************** 167942
      *******************                                                       167942
     C*****@RTCD*********IFEQ      *BLANKS                                      167942
     C*******************MOVEL(P)  A8BICN        @CSCN                          167942
     C*******************EXSR      ACCUST                                       167942
      *******************                                                       167942
      ***IF*SHORTNAME*IS*NON*BLANK*DEFAULT*FIELD*52*TO*THE*SHORTNAME*********** 167942
      *******************                                                       167942
     C*****BBCSSN********IFNE      *BLANKS                                      167942
     C*******************MOVEL     BBCSSN        DDPOBN                         167942
     C*******************ELSE                                                   167942
      *******************                                                       167942
      ***ELSE*DEFAULT*FIELD*52*TO*THE*CUSTOMER*NUMBER************************** 167942
      *******************                                                       167942
     C*******************MOVEL     A8BICN        DDPOBN                         167942
     C*******************END                                                    167942
     C*******************END                                                    167942
     C*******************END                                                    167942
      *
      * FIELD 57, 'ACCOUNT WITH' BANK (PAY SIDE)
      * ----------------------------------------
      * FOR DEALS INPUT ONLY:
      *
     C     ##CALP        IFNE      'SSI '
      *
      * IF THE DEAL IS FOR FEDERAL FUNDS AND THE DEAL (PAY) CURRENCY
      * IS US DOLLARS.
      *
     C     ##FFND        ANDEQ     'Y'
     C     E#PCCY        ANDEQ     BLUSCY
      *
      * IF FIELD 57 IS BLANK THEN DISPLAY ERROR MESSAGE
      *
     C     DDAWBN        IFEQ      *BLANKS
     C     ##FFND        ANDNE     'Y'                                                      BUG12540
     C*****W#BLK3        IFNE      'Y'                                               182652 BUG12540
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAWBN'
     C                   EVAL      MsgIDArr(Idx) = 'ESM0703'
     C                   MOVE      'N'           DDAwbnOK
     C**********         MOVE      'Y'           W#BLK3            1                 182652 BUG12540
     C**********         END                                                                BUG12540
     C                   END
      *
      * IF THE INTERMEDIARY BANK IS NOT BLANK:
      *
     C     DDPIBN        IFNE      *BLANKS
      *
      * IF INTERMEDIARY BANK A/C LINE IS BLANK DEFAULT, ELSE VALIDATE.
      *
     C     DDPIBA        IFEQ      *BLANKS
     C     ##FFND        ANDNE     'Y'                                                      BUG12540
     C*****W#BLK1        IFNE      'Y'                                               182652 BUG12540
     C                   MOVEL     '//FW'        DDPIBA
     C**********         MOVE      'Y'           W#BLK1            1                 182652 BUG12540
     C**********         END                                                                BUG12540
     C**********         ELSE                                                                 182652
     C**********         MOVEL     DDPIBA        W#CHK4            4                          182652
     C*****W#CHK4        IFNE      '//FW'                                                     182652
     C**********         ADD       1             Idx                                          182652
     C**********         EVAL      FldNameArr(Idx) = 'DDPIBN'                                 182652
     C**********         EVAL      MsgIDArr(Idx) = 'ESM0700'                                  182652
     C**********         MOVE      'N'           DDPibnOK                                     182652
     C**********         END                                                                  182652
     C*
     C                   END
      *
      * IF INTERMEDIARY BANK (FIELD 56) IS BLANK:
      *
     C                   ELSE
      *
      * IF ACCOUNT WITH BANK A/C LINE IS BLANK DEFAULT, ELSE VALIDATE.
      *
     C     DDAWBA        IFEQ      *BLANKS
     C     ##FFND        ANDNE     'Y'                                                      BUG12540
     C*****W#BLK2        IFNE      'Y'                                               182652 BUG12540
     C                   MOVEL     '//FW'        DDAWBA
     C**********         MOVE      'Y'           W#BLK2            1                 182652 BUG12540
     C**********         END                                                         182652 BUG12540
     C**********         ELSE                                                                 182652
     C**********         MOVEL     DDAWBA        W#CHK4                                       182652
     C*****W#CHK4        IFNE      '//FW'                                                     182652
     C**********         ADD       1             Idx                                          182652
     C**********         EVAL      FldNameArr(Idx) = 'DDAWBA'                                 182652
     C**********         EVAL      MsgIDArr(Idx) = 'ESM0701'                                  182652
     C**********         MOVE      'N'           DDAwbaOK                                     182652
     C**********         END                                                                  182652
     C                   END
     C                   END
     C                   END
      *
     C                   ENDSR
     C********************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* DEFREC   - Do Receive side Defaulting                         *
     C*                                                               *
     C*****************************************************************
     C     DEFREC        BEGSR
      *
      ** IF BOTH ORDERING CUSTOMER AND ORDERING BANK ARE BLANK
      ** AND THE DEAL COUNTERPARTY IS A BANK DEFAULT ORDERING
      ** BANK TO THE CUSTOMER
      *
     C     @CBNBI        IFEQ      'Y'
     C     DDROCN        ANDEQ     *BLANKS
     C     DDROBN        ANDEQ     *BLANKS
     C                   MOVE      ##CSNM        DDROBN
     C                   END
      *
      ** IF BOTH ORDERING CUSTOMER AND ORDERING BANK ARE BLANK
      ** AND THE DEAL COUNTERPARTY IS NOT A BANK DEFAULT ORDERING
      ** CUSTOMER TO THE CUSTOMER
      *
     C     @CBNBI        IFEQ      'N'
     C     DDROBN        ANDEQ     *BLANKS
     C     DDROCN        ANDEQ     *BLANKS
     C                   MOVE      ##CSNM        DDROCN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
     C*
     C* ACBRCH - ACCESS BRANCH DETAILS
     C*
     C*****************************************************************
     C     ACBRCH        BEGSR
      *
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      @BRCA         @DSNB             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* ACCUST - Access Customer Details                              *
     C*                                                               *
     C*****************************************************************
     C     ACCUST        BEGSR
      *
     C/COPY WNCPYSRC,ZASETNVC02
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CSCN            10
     C                   PARM                    @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   ENDSR
     C*********************************************************************
      /EJECT
     C*****************************************************************
     C*
     C* ACNOST - ACCESS NOSTRO DETAILS
     C*
     C*****************************************************************
     C     ACNOST        BEGSR
      *
     C**********         CALL      'AONOSTR0'                                                 CDL094
     C                   CALL      'AONOSTR1'                                                 CDL094
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      *BLANKS       @CUST             6
     C                   PARM                    @CYCD             3
     C**********         PARM      *BLANKS       @ACCD             4                          CGL029
     C                   PARM      *BLANKS       @ACCD                                        CGL029
     C                   PARM      *BLANKS       @ACSN             2
     C                   PARM                    @NONB             2
     C                   PARM      *BLANKS       @BRCD             3
     C                   PARM      *BLANKS       @CSSN            10
     C                   PARM      *BLANKS       @PNOI             1
     C*****SDNOST        PARM      SDNOST        DSFDY                                        CDL094
     C     SDNOST        PARM      SDNOST        DSSDY                                        CDL094
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*
     C* ACACCT - ACCESS ACCOUNT DETAILS
     C*
     C*****************************************************************
     C     ACACCT        BEGSR
      *
     C                   CLEAR                   DSSDY                                      MD023833
     C                   CLEAR                   ACCT                                       MD023833
     C                   CALL      'AOACCTV0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM                    @ACID            10
     C                   PARM                    @CYCD             3
     C**********         PARM                    @ACCD             4                          CGL029
     C                   PARM                    @ACCD                                        CGL029
     C                   PARM                    @ACSN             2
     C                   PARM                    @BRCA             3
     C                   PARM                    @TYPE             7
     C                   PARM                    @NOSN             2
     C     ACCT          PARM      ACCT          DSSDY
     C                   MOVEL     DSSDY         ACCT                                       MD023833
      *
     C                   ENDSR
     C*****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
     C*****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * CSFACT - Get Customer Details for Account field               *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     CSFACT        BEGSR                                                               CSF011A
                                                                                            MD023833
     C                   MOVE      @RTCD         #RTCD             7                        MD023833
                                                                                             CSF011A
     C                   IF        W@TYPE = 'CUST'                                           CSF011A
     C                   EVAL      @CSCN  = A#CNUM                                           CSF011A
     C                   ELSE                                                                CSF011A
     C                   EVAL      @CSCN  = CNUM                                             CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   EVAL      W@TYPE = *BLANKS                                          CSF011A
     C                   EVAL      @KYST = *BLANKS                                           CSF011A
     C                   EXSR      ACCUST                                                    CSF011A
                                                                                             CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
                                                                                             CSF011A
     C                   IF        SETTF = 'P'                                               CSF011A
     C                   EVAL      DDPSH1 = BBCSSN                                           CSF011A
     C                   EVAL      DDPRN1 = BBCRNM                                           CSF011A
     C                   EVAL      DDPRT1 = BBCRTN                                           CSF011A
     C                   EVAL      DDPAC1 = ANAM                                             CSF011A
     C                   EVAL      DDPSI1 = BBCSID                                           CSF011A
     C                   ELSEIF    SETTF = 'R'                                               CSF011A
     C                   EVAL      DDRSH1 = BBCSSN                                           CSF011A
     C                   EVAL      DDRRN1 = BBCRNM                                           CSF011A
     C                   EVAL      DDRRT1 = BBCRTN                                           CSF011A
     C                   EVAL      DDRAC1 = ANAM                                             CSF011A
     C                   EVAL      DDRSI1 = BBCSID                                           CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   MOVE      #RTCD         @RTCD                                      MD023833
     C                   ENDSR                                                               CSF011A
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - INITIAL PROCESSING                                   *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** INITIALIZE:
      *                                                                         CAP003
      ***Set*up*combined*FRA/IRS indicator                               CAP003 164570
      ***Validation*check*is same for FRAs and Single and Cross Ccy      CAP003 164570
      ***IRS*types*(where*differentiation required, use ##TTYP)          CAP003 164570
     C*****##CALP********IFEQ      'SIRS'                                CAP003 164570
     C*****##CALP********OREQ      'CIRS'                                CAP003 CAP004
     C*******************EVAL      ##CALP = 'FRA '                       CAP003 164570
     C*******************ENDIF                                           CAP003 164570
      ** Initialize packed fields to zero(0), serious midas error encountered               BUG11240
      **    in LEMAPYVU                                                                     BUG11240
     C                   Eval      FLREXR = 0                                               BUG11240
     C                   Eval      FLPEXR = 0                                               BUG11240
      *
      * Beneficiary bank/non-bank
     C                   MOVEL     *BLANK        @BBNBI            1
      *
      * Ordering cust bank/non-bank
     C                   MOVEL     *BLANK        @OBNBI            1
      *
      ** RECEIVE AND PAYMENT ACCOUNTS AND SETTLEMENT BRANCHES
      ** IF NOT MULTI-BRANCHING
      *
     C     @MBIN         IFNE      'Y'
     C**********         MOVEL     DDRONX        DDRONS           12                          CGL029
     C     CLE033        IFEQ      'Y'                                                        CLE033
     C     DDRSTM        ANDNE     '09'                                                       CLE033
     C                   MOVEL     DDRONX        DDRONS                                       CGL029
     C                   MOVEL     *BLANKS       DDROBR            3
     C                   ENDIF                                                                CLE033
     C**********         MOVEL     DDPONX        DDPONS           12                          CGL029
     C     CLE033        IFEQ      'Y'                                                        CLE033
     C     DDPSTM        ANDNE     '09'                                                       CLE033
     C                   MOVEL     DDPONX        DDPONS                                       CGL029
     C                   MOVEL     *BLANKS       DDPOBR            3
     C                   ENDIF                                                                CLE033
     C                   END
      *
      ** RECEIVE AND PAYMENT ACCOUNTS AND SETTLEMENT BRANCHES
      ** IF MULTI-BRANCHING
      *
     C     @MBIN         IFEQ      'Y'
     C     DDRSTM        IFEQ      '05'
     C     CLE033        OREQ      'Y'                                                        CLE033
     C     DDRSTM        ANDEQ     '09'                                                       CLE033
     C                   MOVE      DDRONX        DDRONS
     C                   MOVEL     DDRONX        DDROBR
     C                   ELSE
     C                   MOVEL     DDRONX        DDRONS
     C                   MOVEL     *BLANKS       DDROBR
     C                   END
     C     DDPSTM        IFEQ      '05'
     C     CLE033        OREQ      'Y'                                                        CLE033
     C     DDPSTM        ANDEQ     '09'                                                       CLE033
     C                   MOVE      DDPONX        DDPONS
     C                   MOVEL     DDPONX        DDPOBR
     C                   ELSE
     C                   MOVEL     DDPONX        DDPONS
     C                   MOVEL     *BLANKS       DDPOBR
     C                   END
     C                   END
      *
      ** Initialize Effective Receive and Payment Currencies
      *
     C                   MOVEL     ##RCCY        E#RCCY            3
     C                   MOVEL     ##PCCY        E#PCCY            3
                                                                                              CRE008
     C**********         EVAL      WIdx = *ZEROS                                      CRE008 BUG4478
      *
      ** Get Counterparty Details
      *
     C                   EXSR      CPTYDT
      *
     C/COPY WNCPYSRC,ZASETINVC8
      *
     C                   MOVEL     DDBENN        @CSCN                                        238721
     C                   EXSR      ACCUST                                                     238721
     C     @RTCD         IFEQ      *BLANKS                                                    238721
     C                   MOVEL     BBSWFI        @BBNBI                                       238721
     C                   ENDIF                                                                238721
                                                                                             CSF011A
      ** Initialise Customer Name on Input fields                                            CSF011A
                                                                                             CSF011A
     C                   IF        ##ACTN <> 'X' AND                                         CSF011A
     C                             ##ACTN <> 'R'                                             CSF011A
     C                   EVAL      DDPSH1 = *BLANKS                                          CSF011A
     C                   EVAL      DDPRN1 = *BLANKS                                          CSF011A
     C                   EVAL      DDPRT1 = *BLANKS                                          CSF011A
     C                   EVAL      DDPAC1 = *BLANKS                                          CSF011A
     C                   EVAL      DDPSI1 = *BLANKS                                          CSF011A
     C                   EVAL      DDPSH2 = *BLANKS                                          CSF011A
     C                   EVAL      DDPRN2 = *BLANKS                                          CSF011A
     C                   EVAL      DDPRT2 = *BLANKS                                          CSF011A
     C                   EVAL      DDPSI2 = *BLANKS                                          CSF011A
     C                   EVAL      DDPSH3 = *BLANKS                                          CSF011A
     C                   EVAL      DDPRN3 = *BLANKS                                          CSF011A
     C                   EVAL      DDPRT3 = *BLANKS                                          CSF011A
     C                   EVAL      DDPSI3 = *BLANKS                                          CSF011A
     C                   EVAL      DDPSH4 = *BLANKS                                          CSF011A
     C                   EVAL      DDPRN4 = *BLANKS                                          CSF011A
     C                   EVAL      DDPRT4 = *BLANKS                                          CSF011A
     C                   EVAL      DDPSI4 = *BLANKS                                          CSF011A
     C                   EVAL      DDPSH5 = *BLANKS                                          CSF011A
     C                   EVAL      DDPRN5 = *BLANKS                                          CSF011A
     C                   EVAL      DDPRT5 = *BLANKS                                          CSF011A
     C                   EVAL      DDPSI5 = *BLANKS                                          CSF011A
     C                   EVAL      DDPSH6 = *BLANKS                                          CSF011A
     C                   EVAL      DDPRN6 = *BLANKS                                          CSF011A
     C                   EVAL      DDPRT6 = *BLANKS                                          CSF011A
     C                   EVAL      DDPSI6 = *BLANKS                                          CSF011A
     C                   EVAL      DDPSH7 = *BLANKS                                          CSF011A
     C                   EVAL      DDPRN7 = *BLANKS                                          CSF011A
     C                   EVAL      DDPRT7 = *BLANKS                                          CSF011A
     C                   EVAL      DDPSI7 = *BLANKS                                          CSF011A
     C                   EVAL      DDPSH8 = *BLANKS                                          CSF011A
     C                   EVAL      DDPRN8 = *BLANKS                                          CSF011A
     C                   EVAL      DDPRT8 = *BLANKS                                          CSF011A
     C                   EVAL      DDPSI8 = *BLANKS                                          CSF011A
     C                   EVAL      DDRSH1 = *BLANKS                                          CSF011A
     C                   EVAL      DDRRN1 = *BLANKS                                          CSF011A
     C                   EVAL      DDRRT1 = *BLANKS                                          CSF011A
     C                   EVAL      DDRAC1 = *BLANKS                                          CSF011A
     C                   EVAL      DDRSI1 = *BLANKS                                          CSF011A
     C                   EVAL      DDRSH2 = *BLANKS                                          CSF011A
     C                   EVAL      DDRRN2 = *BLANKS                                          CSF011A
     C                   EVAL      DDRRT2 = *BLANKS                                          CSF011A
     C                   EVAL      DDRSI2 = *BLANKS                                          CSF011A
     C                   EVAL      DDRSH3 = *BLANKS                                          CSF011A
     C                   EVAL      DDRRN3 = *BLANKS                                          CSF011A
     C                   EVAL      DDRRT3 = *BLANKS                                          CSF011A
     C                   EVAL      DDRSI3 = *BLANKS                                          CSF011A
     C                   EVAL      DDRSH4 = *BLANKS                                          CSF011A
     C                   EVAL      DDRRN4 = *BLANKS                                          CSF011A
     C                   EVAL      DDRRT4 = *BLANKS                                          CSF011A
     C                   EVAL      DDRSI4 = *BLANKS                                          CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* CPTYDT - Get Counterparty Details                             *
     C*                                                               *
     C*****************************************************************
     C     CPTYDT        BEGSR
      *
      * GET DEAL COUNTERPARTY DETAILS
      *
     C                   MOVEL     ##CSNM        @CSCN
     C                   EXSR      ACCUST
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     ##CSNM        DBKEY
     C                   MOVEL     'SDCUSTPD'    DBFILE                         ************
     C                   MOVEL     '800'         DBASE                          * DBERR 800*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      * SAVE COUNTERPARTY BANK/NON-BANK IND, SWIFT ID, SHORTNAME & NUMBER
      *
     C**********         MOVEL     BBBNBI        @CBNBI            1                          197865
     C                   MOVEL     BBSWFI        @CBNBI            1                          197865
     C                   MOVEL     BBCSID        @CCSID           12
     C                   MOVEL     BBCSSN        @CCSSN           10
     C                   MOVEL     BBCUST        @CCUST            6
      *
     C                   ENDSR
     C********************************************************************
     C/COPY WNCPYSRC,ZASETNVC30
      /EJECT                                                                                  CRE008
      *****************************************************************                       CRE008
      *                                                               *                       CRE008
      * SROvrChk - Overdraft Limit Check for the receive settlement   *                       CRE008
      *            Account                                            *                       CRE008
      *                                                               *                       CRE008
      *****************************************************************                       CRE008
     C     SROvrChk      BEGSR                                                                CRE008
                                                                                              CRE008
     C                   EVAL      PInBranch = WkBRCA                                         CRE008
     C                   EVAL      PInCust = WkCust                                           CRE008
     C                   EVAL      PInCurr = WkCcy                                            CRE008
     C                   EVAL      PInACode = WkACOD                                          CRE008
     C                   EVAL      PInASeqN = WkASEQ                                          CRE008
                                                                                              CRE008
     C                   CALL      'RE101901'                                                 CRE008
     C                   PARM      *BLANKS       PRetCode                                     CRE008
     C                   PARM                    PInBranch                                    CRE008
     C                   PARM                    PInCust                                      CRE008
     C                   PARM                    PInCurr                                      CRE008
     C                   PARM                    PInACode                                     CRE008
     C                   PARM                    PInASeqN                                     CRE008
     C                   PARM                    PDebAmnt                                     CRE008
     C                   PARM                    POutBranch                                   CRE008
     C                   PARM                    POutCust                                     CRE008
     C                   PARM                    POutCurr                                     CRE008
     C                   PARM                    POutACode                                    CRE008
     C                   PARM                    POutASeqN                                    CRE008
     C                   PARM                    POutRetNo                                    CRE008
                                                                                              CRE008
     C                   IF        PRetCode = '*ODLMTX'                                       CRE008
     C                   MOVE      POutCust      WkCustA                                      CRE008
     C                   MOVE      POutACode     WkACodeA                                     CRE008
     C                   MOVE      POutASeqN     WkASeqNA                                     CRE008
     C                   MOVE      POutRetNo     WkRetNoA                                     CRE008
     C                   EVAL      WIdx = WIdx + 1                                            CRE008
     C                   EVAL      WFldNameArr(WIdx) = 'DDRONS'                               CRE008
     C                   EVAL      WMsgIDArr(WIdx) = 'ESM1949'                                CRE008
     C                   IF        POutRetNo = *Zeros                                         CRE008
     C**********         EVAL      WMsgDtaArr(WIdx) = POutBranch + '-' +             CRE008 MD000091
     C**********                   WkCustA + '-' + POutCurr + '-' +                  CRE008 MD000091
     C**********                   WkACodeA + '-' + WkASeqNA                         CRE008 MD000091
     C                   EVAL      MsgDtaTmp = POutBranch + '-' +                           MD000091
     C                             WkCustA + '-' + POutCurr + '-' +                         MD000091
     C                             WkACodeA + '-' + WkASeqNA                                MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtaArr(WIdx) = LenStr +%TRIM(MsgDtaTmp)              MD000091
     C                   ELSE                                                                 CRE008
     C**********         EVAL      WMsgDtaArr(WIdx) = POutBranch + '-' +             CRE008 MD000091
     C**********                   WkCustA + '-' + POutCurr + '-' +                  CRE008 MD000091
     C**********                   WkACodeA + '-' + WkASeqNA + '/' +                 CRE008 MD000091
     C**********                   WkRetNoA                                          CRE008 MD000091
     C                   EVAL      MsgDtaTmp = POutBranch + '-' +                           MD000091
     C                             WkCustA + '-' + POutCurr + '-' +                         MD000091
     C                             WkACodeA + '-' + WkASeqNA + '/' +                        MD000091
     C                             WkRetNoA                                                 MD000091
     C                   EVAL      BLen = %Len(%Trim(MsgDtaTmp))                            MD000091
     C                   EVAL      WMsgDtaArr(WIdx) = LenStr +%TRIM(MsgDtaTmp)              MD000091
     C                   ENDIF                                                                CRE008
     C                   ENDIF                                                                CRE008
                                                                                              CRE008
     C                   ENDSR                                                                CRE008
      *****************************************************************                       CRE008
      /EJECT                                                                                  CGL014
      *****************************************************************                       CGL014
      *                                                               *                       CGL014
      *  SRBlockAmt - Validation for Blocked Collateral Amount        *                       CGL014
      *                                                               *                       CGL014
      *****************************************************************                       CGL014
     C     SRBlockAmt    BEGSR                                                                CGL014
                                                                                              CGL014
     C                   IN        DLUFBO                                                     CGL014
                                                                                              CGL014
      ** If Action code is Insert                                                             CGL014
                                                                                              CGL014
     C                   IF        ##ACTN = 'I'                                               CGL014
                                                                                              CGL014
      ** Check for Up-Front details                                                           CGL014
                                                                                              CGL014
     C                   IF        DLUPPR = 'R' AND DLUPVD <= BJRDNB AND                      CGL014
     C                             DLUPFE > 0                                                 CGL014
     C                   EVAL      PAmount = DLUPFE                                           CGL014
     C                   EVAL      PTCCY = DLUCCY                                             CGL014
     C                   EVAL      PBranch = WRcBRCA                                          CGL014
     C                   EVAL      PCustNo = WRcCust                                          CGL014
     C                   EVAL      PCurr = WRcCcy                                             CGL014
     C                   EVAL      PActCode = WRcACOD                                         CGL014
     C                   EVAL      PAcSeq = WRcASEQ                                           CGL014
     C                   EVAL      PRetail = WRcRetail                                        CGL014
     C                   EVAL      WPRInd = 'R'                                               CGL014
     C                   IF        CIR003 = 'Y' AND ##CALP = 'CXSV'                           CGL014
     C                   EVAL      PTCCY = DLTCCY                                             CGL014
     C                   ENDIF                                                                CGL014
     C                   EXSR      SRCallPgm                                                  CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** Check for Buy-out Details                                                            CGL014
                                                                                              CGL014
     C                   IF        DLBOPR = 'R' AND DLBOVD <= BJRDNB AND                      CGL014
     C                             DLBOAM > 0                                                 CGL014
     C                   EVAL      PAmount = DLBOAM                                           CGL014
     C                   EVAL      PTCCY = DLUCCY                                             CGL014
     C                   EVAL      PBranch = WRcBRCA                                          CGL014
     C                   EVAL      PCustNo = WRcCust                                          CGL014
     C                   EVAL      PCurr = WRcCcy                                             CGL014
     C                   EVAL      PActCode = WRcACOD                                         CGL014
     C                   EVAL      PAcSeq = WRcASEQ                                           CGL014
     C                   EVAL      PRetail = WRcRetail                                        CGL014
     C                   EVAL      WPRInd = 'R'                                               CGL014
     C                   IF        CIR003 = 'Y' AND ##CALP = 'CXSV'                           CGL014
     C                   EVAL      PTCCY = DLTCCY                                             CGL014
     C                   ENDIF                                                                CGL014
     C                   EXSR      SRCallPgm                                                  CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** If Action is Amend                                                                   CGL014
                                                                                              CGL014
     C                   IF        ##ACTN = 'A'                                               CGL014
                                                                                              CGL014
      ** Retrieve the previous details                                                        CGL014
                                                                                              CGL014
     C     DLDLNO        CHAIN     DEALSDGF                                                   CGL014
     C                   IF        NOT %FOUND(DLDLDGLE)                                       CGL014
     C     *LOCK         IN        LDA                                                        CGL014
     C                   EVAL      DBFILE = 'DEALSDG'                                         CGL014
     C                   EVAL      DBASE = 7                                                  CGL014
     C                   MOVE      DLDLNO        DBKEY                                        CGL014
     C                   OUT       LDA                                                        CGL014
     C                   EXSR      SRERR                                                      CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        ##CALP = 'CXSV'                                            CGL014
     C                   OPEN      DLGXSTL0                                                   CGL014
     C                   EVAL      KEDCD = 'VAL'                                              CGL014
     C                   EVAL      KDLNO = DLDLNO                                             CGL014
     C     KGXST         CHAIN     DLGXSTL0                                                   CGL014
     C                   IF        NOT %FOUND(DLGXSTL0)                                       CGL014
     C     *LOCK         IN        LDA                                                        CGL014
     C                   EVAL      DBFILE = 'DLGXSTPD'                                        CGL014
     C                   EVAL      DBASE = 8                                                  CGL014
     C                   MOVE      DLDLNO        DBKEY                                        CGL014
     C                   OUT       LDA                                                        CGL014
     C                   EXSR      SRERR                                                      CGL014
     C                   ENDIF                                                                CGL014
     C                   CLOSE     DLGXSTL0                                                   CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        ##CALP = 'CXSM'                                            CGL014
     C                   OPEN      DLGXSTL0                                                   CGL014
     C                   EVAL      KEDCD = 'MAT'                                              CGL014
     C                   EVAL      KDLNO = DLDLNO                                             CGL014
     C     KGXST         CHAIN     DLGXSTL0                                                   CGL014
     C                   IF        NOT %FOUND(DLGXSTL0)                                       CGL014
     C     *LOCK         IN        LDA                                                        CGL014
     C                   EVAL      DBFILE = 'DLGXSTPD'                                        CGL014
     C                   EVAL      DBASE = 9                                                  CGL014
     C                   MOVE      DLDLNO        DBKEY                                        CGL014
     C                   OUT       LDA                                                        CGL014
     C                   EXSR      SRERR                                                      CGL014
     C                   ENDIF                                                                CGL014
     C                   CLOSE     DLGXSTL0                                                   CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        DLUPVD <= BJRDNB AND P_ORED = BJRDNB OR                    CGL014
     C                             DLBOVD <= BJRDNB AND P_ORED = BJRDNB                       CGL014
                                                                                              CGL014
      ** Up-Front Details checking                                                            CGL014
                                                                                              CGL014
     C                   EXSR      SRAmdUpFrt                                                 CGL014
                                                                                              CGL014
      ** Buy-out Details checking                                                             CGL014
                                                                                              CGL014
     C                   EXSR      SRAmdByOut                                                 CGL014
                                                                                              CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   ENDSR                                                                CGL014
      *****************************************************************                       CGL014
      /EJECT                                                                                  CGL014
      *****************************************************************                       CGL014
      *                                                               *                       CGL014
      *  SRCallPgm - Calls GL00600 to check for Blocked Amount        *                       CGL014
      *                                                               *                       CGL014
      *****************************************************************                       CGL014
     C     SRCallPgm     BEGSR                                                                CGL014
                                                                                              CGL014
     C                   CALL      'GL006000'                                                 CGL014
     C                   PARM                    PAmount                                      CGL014
     C                   PARM                    PTCCY                                        CGL014
     C                   PARM                    PBranch                                      CGL014
     C                   PARM                    PCustNo                                      CGL014
     C                   PARM                    PCurr                                        CGL014
     C                   PARM                    PActCode                                     CGL014
     C                   PARM                    PAcSeq                                       CGL014
     C                   PARM                    PRetail                                      CGL014
     C                   PARM                    PRTCD                                        CGL014
                                                                                              CGL014
      ** Send error message if available balance is not enough to cover                       CGL014
      ** blocked amount                                                                       CGL014
                                                                                              CGL014
     C                   IF        PRTCD = '*BLKERR'                                          CGL014
     C                   ADD       1             Idx                                          CGL014
     C                   EVAL      MsgIDArr(Idx) = 'MMA0862'                                  CGL014
     C                   IF        WPRInd = 'R'                                               CGL014
     C                   EVAL      FldNameArr(Idx) = 'DDRONX'                                 CGL014
     C                   EVAL      DDRonxOk = 'N'                                             CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      FldNameArr(Idx) = 'DDPONX'                                 CGL014
     C                   EVAL      DDPonxOk = 'N'                                             CGL014
     C                   ENDIF                                                                CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** Send warning message if minimum balance will be exceeded                             CGL014
                                                                                              CGL014
     C                   IF        PRTCD = '*WARN  '                                          CGL014
     C                   ADD       1             WIdx                                         CGL014
     C                   EVAL      WMsgIDArr(WIdx) = 'MMA0863'                                CGL014
     C                   IF        WPRInd = 'R'                                               CGL014
     C                   EVAL      WFldNameArr(Idx) = 'DDRONX'                                CGL014
     C                   EVAL      DDRonxOk = 'N'                                             CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      WFldNameArr(Idx) = 'DDPONX'                                CGL014
     C                   EVAL      DDPonxOk = 'N'                                             CGL014
     C                   ENDIF                                                                CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   ENDSR                                                                CGL014
      *****************************************************************                       CGL014
      /EJECT                                                                                  CGL014
      *****************************************************************                       CGL014
      *                                                               *                       CGL014
      *  SRChkDiff - Check for Amount difference                      *                       CGL014
      *                                                               *                       CGL014
      *****************************************************************                       CGL014
     C     SRChkDiff     BEGSR                                                                CGL014
                                                                                              CGL014
     C                   IF        WCurAmt > WPrvAmt                                          CGL014
     C                   EVAL      WDiff = WCurAmt - WPrvAmt                                  CGL014
     C                   EVAL      PAmount = WDiff                                            CGL014
     C                   EXSR      SRCallPgm                                                  CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   ENDSR                                                                CGL014
      *****************************************************************                       CGL014
      /EJECT                                                                                  CGL014
      *****************************************************************                       CGL014
      *                                                               *                       CGL014
      *  SRAmdUpFrt - Validation for Up-Front Details on Amend        *                       CGL014
      *                                                               *                       CGL014
      *****************************************************************                       CGL014
     C     SRAmdUpFrt    BEGSR                                                                CGL014
                                                                                              CGL014
                                                                                              CGL014
      ** If Pay/Rcv Indicator was changed                                                     CGL014
                                                                                              CGL014
     C                   IF        P_UPPR <> DLUPPR                                           CGL014
     C                   IF        DLUPPR = 'R'                                               CGL014
                                                                                              CGL014
      ** If New Receipt Account is not the same as previous accounts                          CGL014
                                                                                              CGL014
     C                   IF        DDRONS <> P_RONS AND ##CALP = 'SIRS' OR                    CGL014
     C                             DDRONS <> P_RXRONS AND ##CALP = 'CXSV' OR                  CGL014
     C                             DDRONS <> P_RXRONS AND ##CALP = 'CXSM'                     CGL014
     C                   EVAL      PAmount = DLUPFE                                           CGL014
     C                   EVAL      PTCCY = DLUCCY                                             CGL014
     C                   EVAL      PBranch = WRcBRCA                                          CGL014
     C                   EVAL      PCustNo = WRcCust                                          CGL014
     C                   EVAL      PCurr = WRcCcy                                             CGL014
     C                   EVAL      PActCode = WRcACOD                                         CGL014
     C                   EVAL      PAcSeq = WRcASEQ                                           CGL014
     C                   EVAL      PRetail = WRcRetail                                        CGL014
     C                   EVAL      WPRInd = 'R'                                               CGL014
     C                   IF        CIR003 = 'Y' AND ##CALP = 'CXSV'                           CGL014
     C                   EVAL      PTCCY = DLTCCY                                             CGL014
     C                   ENDIF                                                                CGL014
     C                   EXSR      SRCallPgm                                                  CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** If New Receipt Account is the same as Previous Pay Account                           CGL014
                                                                                              CGL014
     C                   IF        DDRONS = P_PONS AND ##CALP = 'SIRS' OR                     CGL014
     C                             DDRONS = P_RXRONS AND ##CALP = 'CXSV' OR                   CGL014
     C                             DDRONS = P_RXRONS AND ##CALP = 'CXSM'                      CGL014
     C                   EVAL      WCurAmt = DLUPFE                                           CGL014
     C                   EVAL      WPrvAmt = P_UPFE                                           CGL014
     C                   EVAL      PTCCY = DLUCCY                                             CGL014
     C                   EVAL      PBranch = WRcBRCA                                          CGL014
     C                   EVAL      PCustNo = WRcCust                                          CGL014
     C                   EVAL      PCurr = WRcCcy                                             CGL014
     C                   EVAL      PActCode = WRcACOD                                         CGL014
     C                   EVAL      PAcSeq = WRcASEQ                                           CGL014
     C                   EVAL      PRetail = WRcRetail                                        CGL014
     C                   EVAL      WPRInd = 'R'                                               CGL014
     C                   IF        CIR003 = 'Y' AND ##CALP = 'CXSV'                           CGL014
     C                   EVAL      PTCCY = DLTCCY                                             CGL014
     C                   ENDIF                                                                CGL014
     C                   EXSR      SRChkDiff                                                  CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   ENDIF                                                                CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** If Pay/Rcv Indicator was not changed                                                 CGL014
                                                                                              CGL014
     C                   IF        P_UPPR = DLUPPR                                            CGL014
                                                                                              CGL014
      ** If Receive Account was changed                                                       CGL014
                                                                                              CGL014
     C                   IF        DDRONS <> P_RONS AND ##CALP = 'SIRS' OR                    CGL014
     C                             DDRONS <> P_RXRONS AND ##CALP = 'CXSV' OR                  CGL014
     C                             DDRONS <> P_RXRONS AND ##CALP = 'CXSM'                     CGL014
     C                   EVAL      PAmount = DLUPFE                                           CGL014
     C                   EVAL      PTCCY = DLUCCY                                             CGL014
     C                   EVAL      PBranch = WRcBRCA                                          CGL014
     C                   EVAL      PCustNo = WRcCust                                          CGL014
     C                   EVAL      PCurr = WRcCcy                                             CGL014
     C                   EVAL      PActCode = WRcACOD                                         CGL014
     C                   EVAL      PAcSeq = WRcASEQ                                           CGL014
     C                   EVAL      PRetail = WRcRetail                                        CGL014
     C                   EVAL      WPRInd = 'R'                                               CGL014
     C                   IF        CIR003 = 'Y' AND ##CALP = 'CXSV'                           CGL014
     C                   EVAL      PTCCY = DLTCCY                                             CGL014
     C                   ENDIF                                                                CGL014
     C                   EXSR      SRCallPgm                                                  CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** If Receive Account was not changed                                                   CGL014
                                                                                              CGL014
     C                   IF        DDRONS = P_RONS AND ##CALP = 'SIRS' OR                     CGL014
     C                             DDRONS = P_RXRONS AND ##CALP = 'CXSV' OR                   CGL014
     C                             DDRONS = P_RXRONS AND ##CALP = 'CXSM'                      CGL014
     C                   EVAL      WCurAmt = DLUPFE                                           CGL014
     C                   EVAL      WPrvAmt = P_UPFE                                           CGL014
     C                   EVAL      PTCCY = DLUCCY                                             CGL014
     C                   EVAL      PBranch = WRcBRCA                                          CGL014
     C                   EVAL      PCustNo = WRcCust                                          CGL014
     C                   EVAL      PCurr = WRcCcy                                             CGL014
     C                   EVAL      PActCode = WRcACOD                                         CGL014
     C                   EVAL      PAcSeq = WRcASEQ                                           CGL014
     C                   EVAL      PRetail = WRcRetail                                        CGL014
     C                   EVAL      WPRInd = 'R'                                               CGL014
     C                   IF        CIR003 = 'Y' AND ##CALP = 'CXSV'                           CGL014
     C                   EVAL      PTCCY = DLTCCY                                             CGL014
     C                   ENDIF                                                                CGL014
     C                   EXSR      SRChkDiff                                                  CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   ENDSR                                                                CGL014
      *****************************************************************                       CGL014
      /EJECT                                                                                  CGL014
      *****************************************************************                       CGL014
      *                                                               *                       CGL014
      *  SRAmdByOut - Validation for Buy-Out Details on Amend         *                       CGL014
      *                                                               *                       CGL014
      *****************************************************************                       CGL014
     C     SRAmdByOut    BEGSR                                                                CGL014
                                                                                              CGL014
                                                                                              CGL014
      ** If Pay/Rcv Indicator was changed                                                     CGL014
                                                                                              CGL014
     C                   IF        P_BAPR <> DLBOPR                                           CGL014
     C                   IF        DLBOPR = 'R'                                               CGL014
                                                                                              CGL014
      ** If New Receipt Account is not the same as previous accounts                          CGL014
                                                                                              CGL014
     C                   IF        DDRONS <> P_RONS AND ##CALP = 'SIRS' OR                    CGL014
     C                             DDRONS <> P_RXRONS AND ##CALP = 'CXSV' OR                  CGL014
     C                             DDRONS <> P_RXRONS AND ##CALP = 'CXSM'                     CGL014
     C                   EVAL      PAmount = DLBOAM                                           CGL014
     C                   EVAL      PTCCY = DLUCCY                                             CGL014
     C                   EVAL      PBranch = WRcBRCA                                          CGL014
     C                   EVAL      PCustNo = WRcCust                                          CGL014
     C                   EVAL      PActCode = WRcACOD                                         CGL014
     C                   EVAL      PAcSeq = WRcASEQ                                           CGL014
     C                   EVAL      PRetail = WRcRetail                                        CGL014
     C                   EVAL      WPRInd = 'R'                                               CGL014
     C                   IF        CIR003 = 'Y' AND ##CALP = 'CXSV'                           CGL014
     C                   EVAL      PTCCY = DLTCCY                                             CGL014
     C                   ENDIF                                                                CGL014
     C                   EXSR      SRCallPgm                                                  CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** If New Receipt Account is the same as Previous Pay Account                           CGL014
                                                                                              CGL014
     C                   IF        DDRONS = P_PONS AND ##CALP = 'SIRS' OR                     CGL014
     C                             DDRONS = P_RXRONS AND ##CALP = 'CXSV' OR                   CGL014
     C                             DDRONS = P_RXRONS AND ##CALP = 'CXSM'                      CGL014
     C                   EVAL      WCurAmt = DLBOAM                                           CGL014
     C                   EVAL      WPrvAmt = P_BOAM                                           CGL014
     C                   EVAL      PTCCY = DLUCCY                                             CGL014
     C                   EVAL      PBranch = WRcBRCA                                          CGL014
     C                   EVAL      PCustNo = WRcCust                                          CGL014
     C                   EVAL      PCurr = WRcCcy                                             CGL014
     C                   EVAL      PActCode = WRcACOD                                         CGL014
     C                   EVAL      PAcSeq = WRcASEQ                                           CGL014
     C                   EVAL      PRetail = WRcRetail                                        CGL014
     C                   EVAL      WPRInd = 'R'                                               CGL014
     C                   IF        CIR003 = 'Y' AND ##CALP = 'CXSV'                           CGL014
     C                   EVAL      PTCCY = DLTCCY                                             CGL014
     C                   ENDIF                                                                CGL014
     C                   EXSR      SRChkDiff                                                  CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   ENDIF                                                                CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** If Pay/Rcv Indicator was not changed                                                 CGL014
                                                                                              CGL014
     C                   IF        P_BAPR = DLBOPR                                            CGL014
                                                                                              CGL014
      ** If Receive Account was changed                                                       CGL014
                                                                                              CGL014
     C                   IF        DDRONS <> P_RONS AND DDRONS <> P_PONS AND                  CGL014
     C                             ##CALP = 'SIRS' OR                                         CGL014
     C                             DDRONS <> P_RXPONS AND DDRONS <> P_RXPONS AND              CGL014
     C                             ##CALP = 'CXSV' OR                                         CGL014
     C                             DDRONS <> P_RXPONS AND DDRONS <> P_RXPONS AND              CGL014
     C                             ##CALP = 'CXSM'                                            CGL014
     C                   EVAL      PAmount = DLBOAM                                           CGL014
     C                   EVAL      PTCCY = DLUCCY                                             CGL014
     C                   EVAL      PBranch = WRcBRCA                                          CGL014
     C                   EVAL      PCustNo = WRcCust                                          CGL014
     C                   EVAL      PCurr = WRcCcy                                             CGL014
     C                   EVAL      PActCode = WRcACOD                                         CGL014
     C                   EVAL      PAcSeq = WRcASEQ                                           CGL014
     C                   EVAL      PRetail = WRcRetail                                        CGL014
     C                   EVAL      WPRInd = 'R'                                               CGL014
     C                   IF        CIR003 = 'Y' AND ##CALP = 'CXSV'                           CGL014
     C                   EVAL      PTCCY = DLTCCY                                             CGL014
     C                   ENDIF                                                                CGL014
     C                   EXSR      SRCallPgm                                                  CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** If Receive Account was not changed                                                   CGL014
                                                                                              CGL014
     C                   IF        DDRONS = P_RONS AND ##CALP = 'SIRS' OR                     CGL014
     C                             DDRONS = P_RXRONS AND ##CALP = 'CXSV' OR                   CGL014
     C                             DDRONS = P_RXRONS AND ##CALP = 'CXSM'                      CGL014
     C                   EVAL      WCurAmt = DLBOAM                                           CGL014
     C                   EVAL      WPrvAmt = P_BOAM                                           CGL014
     C                   EVAL      PTCCY = DLUCCY                                             CGL014
     C                   EVAL      PBranch = WRcBRCA                                          CGL014
     C                   EVAL      PCustNo = WRcCust                                          CGL014
     C                   EVAL      PCurr = WRcCcy                                             CGL014
     C                   EVAL      PActCode = WRcACOD                                         CGL014
     C                   EVAL      PAcSeq = WRcASEQ                                           CGL014
     C                   EVAL      PRetail = WRcRetail                                        CGL014
     C                   EVAL      WPRInd = 'R'                                               CGL014
     C                   IF        CIR003 = 'Y' AND  ##CALP = 'CXSV'                          CGL014
     C                   EVAL      PTCCY = DLTCCY                                             CGL014
     C                   ENDIF                                                                CGL014
     C                   EXSR      SRChkDiff                                                  CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   ENDSR                                                                CGL014
      *****************************************************************                       CGL014
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
      *
      * PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    RetCodeIn
 
      * INPUTS
      ** Code to indicate calling function
     C                   PARM                    ##CALP            4
 
      * Payment currency
     C                   PARM                    ##PCCY            3
 
      * Receive currency
     C                   PARM                    ##RCCY            3
 
      * Customer shortname (or number)
     C                   PARM                    ##CSNM           10
 
      * Transaction Type
     C                   PARM                    ##TTYP            2
 
      * Federal Funds Ind.
     C                   PARM                    ##FFND            1
 
      * Booking branch
     C                   PARM                    ##BRCA            3
 
      * Receipt Date
      * (must = 99999 if no back valuation validation to be done)
     C                   PARM                    ##DATR            5 0
 
      * Payment Date
      * (must = 99999 if no back valuation validation to be done)
     C                   PARM                    ##DATP            5 0
 
      * Payment instructions - screen format
     C                   PARM                    ##PAYS
 
      * Receive instructions - screen format
     C                   PARM                    ##RECS
 
      **FRA/IRS*instructions*-*screen*format***************************                       CSW212
      * Extended Settlement instructions - screen format                                      CSW212
     C                   PARM                    ##FRIS
 
      * Action Code                                                                           185751
     C                   PARM                    ##ACTN            1                          185751
      * Protect Payment Field                                                                 196461
     C                   PARM                    ##PPAY            1                          196461
      * Protect Receipt Field                                                                 196461
     C                   PARM                    ##PREC            1                          196461
                                                                                              185751
      * OUTPUTS
 
      * Payment instructions OK
     C                   PARM                    OKPayment
 
      * Receive instructions OK
     C                   PARM                    OKReceive
 
      * FRA/IRS instructions OK
     C                   PARM                    OKFRAIRS
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
                                                                                              CRE008
      ** Warning Messages                                                                     CRE008
     C                   PARM                    WFldNameArr                                  CRE008
     C                   PARM                    WMsgIdArr                                    CRE008
     C                   PARM                    WMsgDtaArr                                   CRE008
     C                   PARM                    WIdx                                         CRE008
 
      * Payment instructions - file format
     C                   PARM                    ##PAYF
 
      * Receive instructions - file format
     C                   PARM                    ##RECF
 
      **FRA/IRS*instructions*-*file*format*****************************                       CSW212
      * Extended Settlement instructions - file format                                        CSW212
     C                   PARM                    ##FRIF
      ** Extra Input                                                                          166888
      ** Action Code used                                                                     166888
     C                   PARM                    ##ACCD            1                          166888
      ** Validation Iteration                                                                 166888
     C                   PARM                    ##ValIter         3                          166888
      ************                                                                     179510 200400
      **MIDAS*Our*Receive/ Pay Instructions (for Settlm Meth = 04 )                    179510 200400
     C************       PARM                    @MORPI                                179510 200400
      ************                                                                     179510 200400
      *
      ** Remove CLEAR of passed parameter values; they will be cleared when
      ** needed on specific subroutines (PAYMNT, RECEIP, VLFRIR)
      *
     C**********         CLEAR                   ##PAYF                              CLE031 MD032089
     C**********         CLEAR                   ##RECF                              CLE031 MD032089
     C**********         CLEAR                   ##FRIF                              CLE031 MD032089
      *
      ** READ DATA AREA - RUNDAT
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** GET BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '900'         DBASE                          * DBERR 900*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      ** GET GENERAL LEDGER DETAILS
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE                         ************
     C                   MOVEL     '901'         DBASE                          * DBERR 900*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      ** SET UP BACK VALUE DATE
      *
     C*****BJRDNB        SUB       BJBVPD        W#BVDT            5 0          136939
     C                   Z-ADD     0             W#BVDT            5 0          136939
      *
      ** GET TRADING DETAILS
      *
     C                   CALLB     'AOTRADR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDTRAD        PARM      SDTRAD        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDTRADPD'    DBFILE                         ************
     C                   MOVEL     '902'         DBASE                          * DBERR 901*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      ** GET MODULE DETAILS
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE                         ************
     C                   MOVEL     '903'         DBASE                          * DBERR 902*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      ** GET RETAIL DETAILS
      *
     C     BGRTBN        IFEQ      'Y'
     C     BGIOAC        OREQ      'Y'
     C                   CALLB     'AORETLR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDRETLPD'    DBFILE                         ************
     C                   MOVEL     '904'         DBASE                          * DBERR 903*
     C                   EXSR      SRERR                                        ************
     C                   END
     C                   END
      *
      ** Check if switchable feature CSW005 is switched on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CSW005'      @SARD             6
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CSW005'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '905'         DBASE                          * DBERR 904*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CSW005            1
     C                   ENDIF
      *
      ** Check if switchable feature CSW011 is switched on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CSW011'      @SARD             6
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CSW011'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE                         ************
     C                   MOVEL     '906'         DBASE                          * DBERR 905*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CSW011            1
     C                   ENDIF
      *                                                                                       CIR003
      ** Check if switchable feature CIR003 is switched on                                    CIR003
      *                                                                                       CIR003
     C                   CALLB     'AOSARDR0'                                                 CIR003
     C                   PARM      *BLANKS       @RTCD                                        CIR003
     C                   PARM      '*VERIFY '    @OPTN                                        CIR003
     C                   PARM      'CIR003'      @SARD                                        CIR003
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR003
      *                                                                                       CIR003
     C     @RTCD         IFNE      *BLANK                                                     CIR003
     C     @RTCD         ANDNE     '*NRF   '                                                  CIR003
     C                   MOVEL     'CIR003'      DBKEY                                        CIR003
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CIR003
     C                   MOVEL     '002'         DBASE                                        CIR003
     C                   EXSR      SRERR                                                      CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C     @RTCD         IFEQ      *BLANKS                                                    CIR003
     C                   MOVE      'Y'           CIR003            1                          CIR003
     C                   ELSE                                                                 CIR003
     C                   MOVE      'N'           CIR003                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                         CDL008
      ** Check if switchable feature CDL008 is switched on                      CDL008
      *                                                                         CDL008
     C                   CALLB     'AOSARDR0'                                   CDL008
     C                   PARM      *BLANKS       @RTCD                          CDL008
     C                   PARM      '*VERIFY '    @OPTN                          CDL008
     C                   PARM      'CDL008'      @SARD                          CDL008
     C     SCSARD        PARM      SCSARD        DSFDY                          CDL008
      *                                                                         CDL008
     C     @RTCD         IFNE      *BLANK                                       CDL008
     C     @RTCD         ANDNE     '*NRF   '                                    CDL008
     C                   MOVEL     'CDL008'      DBKEY                          CDL008
     C                   MOVEL     'SCSARDPD'    DBFILE                         CDL008
     C                   MOVEL     '001'         DBASE                          CDL008
     C                   EXSR      SRERR                                        CDL008
     C                   ENDIF                                                  CDL008
      *                                                                         CDL008
     C     @RTCD         IFEQ      *BLANKS                                      CDL008
     C                   MOVE      'Y'           CDL008            1            CDL008
     C                   ELSE                                                   CDL008
     C                   MOVE      'N'           CDL008                         CDL008
     C                   ENDIF                                                  CDL008
                                                                                              CRE008
      ** Check if Cash Management is installed                                                CRE008
                                                                                              CRE008
     C                   CALL      'AOSARDR0'                                                 CRE008
     C                   PARM      *BLANKS       @RTCD                                        CRE008
     C                   PARM      '*VERIFY '    @OPTN                                        CRE008
     C                   PARM      'CRE008'      @SARD                                        CRE008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE008
                                                                                              CRE008
     C                   IF        @RTCD = *Blanks                                            CRE008
     C                   EVAL      CRE008 = 'Y'                                               CRE008
     C                   ELSE                                                                 CRE008
     C                   EVAL      CRE008 = 'N'                                               CRE008
     C                   IF        @RTCD <> '*NRF   '                                         CRE008
     C                   EVAL      DBKEY = 'CRE008'                                           CRE008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CRE008
     C                   EVAL      DBASE = 3                                                  CRE008
     C                   EXSR      SRERR                                                      CRE008
     C                   ENDIF                                                                CRE008
     C                   ENDIF                                                                CRE008
                                                                                              219241
      ** Check if switchable feature CFT013 is switched on                                    219241
                                                                                              219241
     C                   CALLB     'AOSARDR0'                                                 219241
     C                   PARM      *BLANKS       @RTCD                                        219241
     C                   PARM      '*VERIFY '    @OPTN                                        219241
     C                   PARM      'CFT013'      @SARD                                        219241
     C     SCSARD        PARM      SCSARD        DSFDY                                        219241
      *                                                                                       219241
     C                   IF        @RTCD <> *BLANK                                            219241
     C                             AND @RTCD <> '*NRF   '                                     219241
     C                   EVAL      DBKEY = 'CFT013'                                           219241
     C                   EVAL      DBFILE = 'SCSARDPD'                                        219241
     C                   EVAL      DBASE = 3                                                  219241
     C                   EXSR      SRERR                                                      219241
     C                   ENDIF                                                                219241
      *                                                                                       219241
     C                   IF        @RTCD = *BLANKS                                            219241
     C                   EVAL      CFT013 = 'Y'                                               219241
     C                   ELSE                                                                 219241
     C                   EVAL      CFT013 = 'N'                                               219241
     C                   ENDIF                                                                219241
                                                                                              219241
      ** Get Message Management Details if CFT013 is installed.                               219241
                                                                                              219241
     C                   IF        CFT013 = 'Y'                                               219241
                                                                                              219241
     C                   CALL      'AOMGMER1'                                                 219241
     C                   PARM      *BLANKS       @RTCD                                        219241
     C                   PARM      '*FIRST'      @OPTN                                        219241
     C     SDMGME        PARM      SDMGME        DSSDY                                        219241
                                                                                              219241
     C                   IF        @RTCD <> *BLANKS                                           219241
     C                   EVAL      DBKEY = @OPTN                                              219241
     C                   EVAL      DBFILE = 'SDMGMEPD'                                        219241
     C                   EVAL      DBASE = 4                                                  219241
     C                   EXSR      SRERR                                                      219241
     C                   ENDIF                                                                219241
                                                                                              219241
     C                   ENDIF                                                                219241
                                                                                              CMG003
      ** Check if switchable feature CMG003 is switched on                                    CMG003
                                                                                              CMG003
     C                   CALLB     'AOSARDR0'                                                 CMG003
     C                   PARM      *BLANKS       @RTCD                                        CMG003
     C                   PARM      '*VERIFY '    @OPTN                                        CMG003
     C                   PARM      'CMG003'      @SARD                                        CMG003
     C     SCSARD        PARM      SCSARD        DSFDY                                        CMG003
                                                                                              CMG003
     C                   IF        @RTCD <> *BLANK                                            CMG003
     C                             AND @RTCD <> '*NRF   '                                     CMG003
     C                   EVAL      DBKEY  = 'CMG003'                                          CMG003
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CMG003
     C                   EVAL      DBASE  = 700                                               CMG003
     C                   EXSR      SRERR                                                      CMG003
     C                   ENDIF                                                                CMG003
                                                                                              CMG003
     C                   IF        @RTCD = *BLANKS                                            CMG003
     C                   EVAL      CMG003 = 'Y'                                               CMG003
     C                   ELSE                                                                 CMG003
     C                   EVAL      CMG003 = 'N'                                               CMG003
     C                   ENDIF                                                                CMG003
                                                                                              CDL018
      ** Access SAR details file to determine if CDL018 is switched on                        CDL018
      ** (Multiple Settlement Accounts on Loans/Deposit)                                      CDL018
                                                                                              CDL018
     C                   CallB     'AOSARDR0'                                                 CDL018
     C                   Parm      *Blanks       @RTCD                                        CDL018
     C                   Parm      '*VERIFY'     @OPTN                                        CDL018
     C                   Parm      'CDL018'      @SARD                                        CDL018
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL018
      *                                                                                       CDL018
     C                   Move      'N'           CDL018            1                          CDL018
     C                   If        PRTCD = *Blanks                                            CDL018
     C                   Eval      CDL018 = 'Y'                                               CDL018
     C                   Endif                                                                CDL018
 
      ** Access SAR details file to determine if CDL036 is switched on                        CDL036
      ** (CLS Enhancements 2)                                                                 CDL036
     C                   CallB     'AOSARDR0'                                                 CDL036
     C                   Parm      *Blanks       @RTCD                                        CDL036
     C                   Parm      '*VERIFY'     @OPTN                                        CDL036
     C                   Parm      'CDL036'      @SARD                                        CDL036
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL036
      *                                                                                       CDL036
     C                   Move      'N'           CDL036            1                          CDL036
     C                   If        PRTCD = *Blanks                                            CDL036
     C                   Eval      CDL036 = 'Y'                                               CDL036
     C                   Endif                                                                CDL036
                                                                                              CDL036
      *                                                                                       CLE031
      ** Access SAR details file to determine if CLE031 is switched on                        CLE031
      ** (Settlement Currency and Exchange Rate)                                              CLE031
      *                                                                                       CLE031
     C                   CallB     'AOSARDR0'                                                 CLE031
     C                   Parm      *Blanks       @RTCD                                        CLE031
     C                   Parm      '*VERIFY'     @OPTN                                        CLE031
     C                   Parm      'CLE031'      @SARD                                        CLE031
     C     SCSARD        Parm      SCSARD        DSFDY                                        CLE031
      *                                                                                       CLE031
     C                   Move      'N'           CLE031            1                          CLE031
     C                   If        @RTCD = *Blanks                                            CLE031
     C                   Eval      CLE031 = 'Y'                                               CLE031
     C                   Endif                                                                CLE031
      *                                                                                       CLE033
      ** Access SAR details file to determine if CLE033 is switched on                        CLE033
      *                                                                                       CLE033
     C                   CallB     'AOSARDR0'                                                 CLE033
     C                   Parm      *Blanks       @RTCD                                        CLE033
     C                   Parm      '*VERIFY'     @OPTN                                        CLE033
     C                   Parm      'CLE033'      @SARD                                        CLE033
     C     SCSARD        Parm      SCSARD        DSFDY                                        CLE033
      *                                                                                       CLE033
     C                   Move      'N'           CLE033            1                          CLE033
     C                   If        @RTCD = *Blanks                                            CLE033
     C                   Eval      CLE033 = 'Y'                                               CLE033
      *                                                                                       CLE033
     C                   CALLB     'AOSVALR0'                                                 CLE033
     C                   PARM      *BLANKS       @RTCD                                        CLE033
     C                   PARM      SVAL(1)       P@OP01           20                          CLE033
     C                   PARM      *BLANKS       P@VL01          200                          CLE033
     C                   PARM      SVAL(2)       P@OP02           20                          CLE033
     C                   PARM      *BLANKS       P@VL02          200                          CLE033
     C                   PARM      SVAL(3)       P@OP03           20                          CLE033
     C                   PARM      *BLANKS       P@VL03          200                          CLE033
     C                   PARM      SVAL(4)       P@OP04           20                          CLE033
     C                   PARM      *BLANKS       P@VL04          200                          CLE033
     C                   PARM      *BLANKS       P@OP05           20                          CLE033
     C                   PARM      *BLANKS       P@VL05          200                          CLE033
     C                   PARM      *BLANKS       P@OP06           20                          CLE033
     C                   PARM      *BLANKS       P@VL06          200                          CLE033
     C                   PARM      *BLANKS       P@OP07           20                          CLE033
     C                   PARM      *BLANKS       P@VL07          200                          CLE033
     C                   PARM      *BLANKS       P@OP08           20                          CLE033
     C                   PARM      *BLANKS       P@VL08          200                          CLE033
     C                   PARM      *BLANKS       P@OP09           20                          CLE033
     C                   PARM      *BLANKS       P@VL09          200                          CLE033
     C                   PARM      *BLANKS       P@OP10           20                          CLE033
     C                   PARM      *BLANKS       P@VL10          200                          CLE033
      *                                                                                       CLE033
     C     @RTCD         IFNE      *BLANK                                                     CLE033
     C                   MOVEL     ##CSNM        DBKEY                                        CLE033
     C                   MOVEL     'SDSVALPD'    DBFILE                         ************  CLE033
     C                   MOVEL     '10'          DBASE                          * DBERR 10 *  CLE033
     C                   EXSR      SRERR                                        ************  CLE033
     C                   ENDIF                                                                CLE033
      *                                                                                       CLE033
     C                   MOVEL     P@VL02        W0ACOD           10                          CLE033
      *                                                                                       CLE033
      ** Save value of Settlement09Postings in a one character field                          CLE033
      *                                                                                       CLE033
     C                   MOVEL     P@VL04        SET09             1                          CLE033
      *                                                                                       CLE033
     C                   CALLB     'AOACODR0'                                                 CLE033
     C                   PARM      *BLANKS       @RTCD                                        CLE033
     C                   PARM      '*KEY    '    @OPTN                                        CLE033
     C                   PARM      W0ACOD        @ACCD                                        CLE033
     C     SDACOD        PARM      SDACOD        DSSDY                                        CLE033
      *                                                                                       CLE033
     C     @RTCD         IFNE      *BLANK                                                     CLE033
     C                   MOVEL     W0ACOD        DBKEY                                        CLE033
     C                   MOVEL     'SDACODPD'    DBFILE                         ************  CLE033
     C                   MOVEL     '11'          DBASE                          * DBERR 11 *  CLE033
     C                   EXSR      SRERR                                        ************  CLE033
     C                   ENDIF                                                                CLE033
      *                                                                                       CLE033
     C                   Endif                                                                CLE033
      *                                                                                       CDL094
      ** Access SAR details file to determine if CDL094 is switched on                        CDL094
      ** (Enhanced Receive Settlement Instructions)                                           CDL094
                                                                                              CDL094
     C                   CallB     'AOSARDR0'                                                 CDL094
     C                   Parm      *Blanks       @RTCD                                        CDL094
     C                   Parm      '*VERIFY'     @OPTN                                        CDL094
     C                   Parm      'CDL094'      @SARD                                        CDL094
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL094
      *                                                                                       CDL094
     C                   Move      'N'           CDL094            1                          CDL094
     C                   If        PRTCD = *Blanks                                            CDL094
     C                   Eval      CDL094 = 'Y'                                               CDL094
     C                   Endif                                                                CDL094
                                                                                              CDL094
     C     *LIKE         DEFINE    A6SPRT        ARSPRT                                       CLE031
     C     *LIKE         DEFINE    A6SPRT        APSPRT                                       CLE031
     C     *LIKE         DEFINE    A6SPRT        AMREXR                                       CLE031
     C     *LIKE         DEFINE    A6SPRT        AMPEXR                                       CLE031
     C     *LIKE         DEFINE    A6MDIN        ARMDIN                                       CLE031
     C     *LIKE         DEFINE    A6MDIN        APMDIN                                       CLE031
     C     *LIKE         DEFINE    A6MDIN        AMREXI                                       CLE031
     C     *LIKE         DEFINE    A6MDIN        AMPEXI                                       CLE031
      ** Check if SWIFT 2000 Changes is on.                                     CSW200
                                                                                CSW200
     C                   CALL      'SWIF2000'                                   CSW200
     C                   PARM      *BLANKS       @RTCD                          CSW200
      *                                                                         CSW200
     C                   MOVEL     'N'           CSW200            1            CSW200
     C     @RTCD         IFEQ      'CSW200'                                     CSW200
     C                   MOVEL     'Y'           CSW200                         CSW200
     C                   ENDIF                                                  CSW200
      *                                                                                       CSW201
      ** Check if SWIFT 2001 Changes is on.                                                   CSW201
      *                                                                                       CSW201
     C                   CALL      'SWIF2001'                                                 CSW201
     C                   PARM      *BLANKS       @RTCD                                        CSW201
      *                                                                                       CSW201
     C     @RTCD         IFEQ      'CSW2001'                                                  CSW201
     C                   MOVEL     'Y'           CSW201            1                          CSW201
     C                   ELSE                                                                 CSW201
     C                   MOVEL     'N'           CSW201                                       CSW201
     C                   ENDIF                                                                CSW201
      *                                                                                       CSW201
      ** Check if SWIFT 2002 Changes is on.                                                   CSW202
      *                                                                                       CSW202
     C                   CALL      'SWIF2002'                                                 CSW202
     C                   PARM      *BLANKS       @RTCD                                        CSW202
      *                                                                                       CSW202
     C     @RTCD         IFEQ      'CSW2002'                                                  CSW202
     C                   MOVEL     'Y'           CSW202            1                          CSW202
     C                   ELSE                                                                 CSW202
     C                   MOVEL     'N'           CSW202                                       CSW202
     C                   ENDIF                                                                CSW202
      *                                                                                       CSW202
      ** Call SWIF2003 to check if CSW203 is installed                                        CSW203
                                                                                              CSW203
     C                   CALL      'SWIF2003'                                                 CSW203
     C                   PARM      *BLANKS       PRTCD                                        CSW203
                                                                                              CSW203
      ** If ret. code is "CSW2003", set CSW203 flag to "Y", else set it to "N"                CSW203
                                                                                              CSW203
     C                   IF        PRTCD = 'CSW2003'                                          CSW203
     C                   EVAL      CSW203 = 'Y'                                               CSW203
     C                   ELSE                                                                 CSW203
     C                   EVAL      CSW203 = 'N'                                               CSW203
     C                   ENDIF                                                                CSW203
                                                                                              CSW203
     C/COPY WNCPYSRC,ZAH00053
      ** Check if Collaterals Processing is installed                                         CGL014
                                                                                              CGL014
     C                   CALL      'AOSARDR0'                                                 CGL014
     C                   PARM      *BLANKS       @RTCD                                        CGL014
     C                   PARM      '*VERIFY '    @OPTN                                        CGL014
     C                   PARM      'CGL014'      @SARD                                        CGL014
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL014
                                                                                              CGL014
     C                   IF        @RTCD = *Blanks                                            CGL014
     C                   EVAL      CGL014 = 'Y'                                               CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      CGL014 = 'N'                                               CGL014
     C                   IF        @RTCD <> '*NRF   '                                         CGL014
     C                   EVAL      DBKEY = 'CGL014'                                           CGL014
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL014
     C                   EVAL      DBASE = 6                                                  CGL014
     C                   EXSR      SRERR                                                      CGL014
     C                   ENDIF                                                                CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C     KGXST         KLIST                                                                CGL014
     C                   KFLD                    KDLNO                                        CGL014
     C                   KFLD                    KEDCD                                        CGL014
      *                                                                                       CSW212
      ** Check if SWIFT 2012 is on                                                            CSW212
      *                                                                                       CSW212
     C                   CALL      'SWIF2012'                                                 CSW212
     C                   PARM      *BLANKS       @RTCD                                        CSW212
      *                                                                                       CSW212
     C     @RTCD         IFEQ      'CSW2012'                                                  CSW212
     C                   MOVEL     'Y'           CSW212            1                          CSW212
     C                   ELSE                                                                 CSW212
     C                   MOVEL     'N'           CSW212                                       CSW212
     C                   ENDIF                                                                CSW212
      *                                                                                       CSW212
      ** Check if SWIFT 2013  is on                                                           CSW213
      *                                                                                       CSW213
     C                   CALL      'SWIF2013'                                                 CSW213
     C                   PARM      *BLANKS       @RTCD                                        CSW213
      *                                                                                       CSW213
     C     @RTCD         IFEQ      'CSW2013'                                                  CSW213
     C                   MOVEL     'Y'           CSW213            1                          CSW213
     C                   ELSE                                                                 CSW213
     C                   MOVEL     'N'           CSW213                                       CSW213
     C                   ENDIF                                                                CSW213
      *                                                                                       CSW213
                                                                                              CSW203
      *                                                                                       CSW214
      ** Check if SWIFT 2014  is on                                                           CSW214
      *                                                                                       CSW214
     C                   CALL      'SWIF2014'                                                 CSW214
     C                   PARM      *BLANKS       PRTCD                                        CSW214
      *                                                                                       CSW214
     C                   IF        PRTCD = 'CSW2014'                                          CSW214
     C                   EVAL      CSW214 = 'Y'                                               CSW214
     C                   ELSE                                                                 CSW214
     C                   EVAL      CSW214 = 'N'                                               CSW214
     C                   ENDIF                                                                CSW214
      *                                                                                       CSW214
     C/COPY WNCPYSRC,ZASETINV21                                                               CUT009
      *                                                                         CSW200
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C/COPY WNCPYSRC,ZASETINVC9
     C*****************************************************
     C*                                                   *
     C* SRERR - EXCEPTION ERRORS                          *
     C*                                                   *
     C*****************************************************
     C     SRERR         BEGSR
     C*
     C                   MOVEL     '*ERROR '     RetCodeIn
     C                   MOVEL     'ZASETINVAL'  DBPGM
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
     C*****************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**   SVAL  -  SYSTEM VALUES ARRAY                                                             CLE033
Settlement09Customer                                                                          CLE033
Settlement09AccCode                                                                           CLE033
Settlement09Hostpgm                                                                           CLE033
Settlement09Postings                                                                          CLE033
