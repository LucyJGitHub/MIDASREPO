     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*XBIA*  OVRDBF FILE(ACCNTLXX) TOFILE(ACCBR) SHARE(*NO)               *
/*XBIB*  OVRDBF FILE(REIACXX) TOFILE(REIAC) SHARE(*NO)                *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Validate and update')                         *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger ILE Module                            *
      *                                                               *
      *  GLAMADVU - Account Maintenance validate and update           *
      *                                                               *
      *  Function: This Program Validates Midas Account Details for   *
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
      *  Last Amend No. FVT106             Date 20Jul20               *
      *  Prev Amend No. MD039577           Date 08Jul16               *
      *                 260405             Date 04Apr20               *
      *                 MD055514           Date 06Apr20               *
      *                 MD055212           Date 14Feb20               *
      *                 MD054028           Date 05Sep19               *
      *                 MD041837           Date 16Jun19               *
      *                 CER050             Date 16Jun19               *
      *                 CSD101             Date 07Dec18               *
      *                 CSD102             Date 08Jan19               *
      *                 MD051247           Date 17Jul18               *
      *                 MD044880           Date 15Jan18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD044546           Date 20Mar17               *
      *                 MD043890           Date 06Feb17               *
      *                 MD042713           Date 05Dec16               *
      *                 222427             Date 05Dec16               *
      *                 MD040328           Date 16Aug16               *
      *                 MD040146           Date 11Aug16               *
      *                 LLN022A            Date 03Jun15               *
      *                 CRE101             Date 27Aug14               *
      *                 CGL165             Date 17Feb15               *
      *                 MD028970           Date 25Nov14               *
      *                 MD026979           Date 09Jun14               *
      *                 MD024398           Date 11May14               *
      *                 AR801992           Date 27Jul12               *
      *                 AR971184A          Date 22Jun12               *
      *                 AR971184           Date 28May12               *
      *                 AR946674           Date 03Apr12               *
      *                 AR947093           Date 26Apr12               *
      *                 AR847249           Date 28Jan12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR869261           Date 13Dec11               *
      *                 CSF011             Date 12Sep11               *
      *                 AR812501           Date 07Sep11               *
      *                 AR820577           Date 31Aug11               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      *                 CER055             Date 06Dec10               *
      *                 AR802610           Date 15Jul11               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 262070             Date 26Oct09               *
      *                 BUG24157           Date 04Jun09               *
      *                 BUG22742           Date 07Feb09               *
      *                 CER047             Date 19May08               *
      *                 BUG22973           Date 27May10               *
      *                 BUG23484           Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CRE015             Date 18Dec09               *
      *                 CRE030             Date 10Jul06               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG17361A          Date 11Apr08               *
      *                 245029A            Date 12Mar07               *
      *                 249966             Date 30Aug07               *
      *                 249660             Date 14Aug07               *
      *                 BUG13639           Date 27Mar07               *
      *                 245648             Date 15Feb07               *
      *                 243436             Date 22Dec06               *
      *                 243129             Date 27Oct06               *
      *                 BUG13120a          Date 26Jan07               *
      *                 BUG13120           Date 24Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242488             Date 27Sep06               *
      *                 240916             Date 12Sep06               *
      *                 CPK025             Date 29Aug06               *
      *                 240366             Date 19Jun06               *
      *                 237646             Date 13Jun06               *
      *                 240205             Date 06Jun06               *
      *                 240312             Date 06Jun06               *
      *                 239316             Date 01Jun06               *
      *                 237341             Date 29Apr06               *
      *                 238839 (Reopen)    Date 12Apr06               *
      *                 238625             Date 06Apr06               *
      *                 238839             Date 29Mar06               *
      *                 CSD031             Date 10Apr06               *
      *                 237401             Date 10Feb06               *
      *                 BUG10280           Date 02Feb06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9141            Date 02Dec05               *
      *                 BUG8210            Date 02Sep05               *
      *                 BUG8104            Date 19Aug05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 TMPFX01            Date 23Mar05               *
      *                 CER001             Date 25Apr05               *
      *                 LLN022             Date 24Jan05               *
      *                 BUG6218            Date 10Mar05               *
      *                 BUG4615            Date 26Oct04               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4686            Date 05Nov04               *
      *                 BUG4400            Date 30Sep04               *
      *                 CRE010             Date 10Sep04               *
      *                 BUG4252            Date 17Sep04               *
      *                 BUG4196            Date 09Sep04               *
      *                 BUG3068            Date 07Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG2733            Date 18May04               *
      *                 BG2557             Date 13May04               *
      *                 BG2651             Date 12May04               *
      *                 TDA084             Date 16Apr04               *
      *                 BUG553             Date 14Apr04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084  *CREATE    Date 17Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  FVT106 - Automatic Account Closure and Account re-opening    *
      *           Addition of hooks: FVT106_006 to FVT106_010         *
      *           Amendment of core hook GLH00652                     *
      *  MD039577 - Account maintenance - Account name different from *
      *  260405 - BRT Participation Date of Birth field is missing.   *
      *           Upgrade fix 235425. Recompile over changed SDCBRTPD.*
      *         - Applied for MD055446.                               *
      *  MD055514 - Not able to open a new Retail Account. Amend to   *
      *             add check if account in REDEFD is valid.          *
      *  MD055212 - Remove the defaulting of values for DDBAC, DDBAD, *
      *             DDRAC, DDRAD to 'N'.                              *
      *  MD054028 - Encountered issues in MQ Testing due to XML not   *
      *             being updated                                     *
      *  MD041837 - Tax indicator is not defaulted anymore with       *
      *             CER050.                                           *
      *  CER050 - Annualised Percentage Rate                          *
      *  CSD101 - Password Encryption                                 *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD051247 - SP15_CUSD API issue                               *
      *           - Code improvement                                  *
      *  MD044880 - BOE Switched On Testing and Fixing                *
      *  MD046248 - Finastra Rebranding                               *
      *  MD044546 - Enable the ABC flag when CAP205 is on.            *
      *  MD043890 - Cannot insert term and notice                     *
      *  MD042713 - Display Default Statement commission.             *
      *  222427 - AMAN - 'Extra Daily Statement Commission' default   *
      *           value is 0.00.  Data structure which includes       *
      *           DDSTFQ should be included in the parameter list on  *
      *           call to module GLAMAD4DT.                           *
      *           Partially Applied for MD042713.                     *
      *  MD040328 - Unable to update Include Account Balance check    *
      *             field via SOAP in AMAD                            *
      *  MD040146 - Account maintenance - Account name different from *
      *             Customer report name                              *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  CRE101 - Interim Interest Statements on a Frequency          *
      *           Added hooks: CRE101_008, CRE101_009, CRE101_014,    *
      *                        CRE101_017, CRE101_020, CRE101_022     *
      *                        CRE101_026, CRE101_028, CRE101_032     *
      *                        CRE101_033, CRE101_034, CRE101_035     *
      *                        CRE101_036, CRE101_037, CRE101_038     *
      *                        CRE101_039, CRE101_040, CRE101_041     *
      *                        CRE101_042, CRE101_043, CRE101_044     *
      *                        CRE101_045, CRE101_046, CRE101_047     *
      *                        CRE101_048, CRE101_057, CRE101_061     *
      *                        CRE101_062, CRE101_069                 *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  MD028970 - Added checking for feature CRE010 when processing *
      *             Account Balance Check.                            *
      *  MD026979 - Added field for Retail account and IBAN           *
      *             validation against WIP entries                    *
      *  MD024398 - API Performance Optimisation                      *
      *           - When deleting, retrieve account moves the need for*
      *             details for validation.  This removes the need for*
      *             Java to call APTRANR before APTRANVU.             *
      *  AR801992 - AcnothDet was blanked out when reviewing Accounts.*
      *             Blank out AcnothDet only for Insert transactions. *
      *             (Child: AR801993)                                 *
      *  AR971184A- During Amend Front Ofc Id must be updated with the*
      *             new one                                           *
      *  AR971184 - For some JMS APIs (CUSD, AMAD, DPMV, OPAY), Front *
      *             Office Id is no more updated in master database   *
      *             files which provokes some big problems in third   *
      *             party product such as TOF.(Child:AR971185)        *
      *  AR946674 - Serious midas error has occured (Child: AR946675) *
      *  AR947093 - Base Rate amendment resulted to 0 interest rate   *
      *  AR847249 - Negative interest is shown in the main list and   *
      *             Loan Details enquiry screen                       *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *  AR869261 - Account Name defaulted to old customer when       *
      *             it is manually inserted                           *
      *  CSF011 - Customer Name on Inputs                             *
      *  AR812501 - Acct name is mandatory in MQ/SOAP testing of AMAD *
      *  AR820577 - Previous Overdraft fields not displayed in        *
      *             Confirmation pages for Close action               *
      *  CER049 - Stamp Tax                                           *
      *  CRE073 - Interest Rate Rounding                              *
      *  CER055 - Penalty Interest on Exceeding Overdraft Limit       *
      *  AR802610 - Add Interest Scale flag in API definition.        *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  262070 - Problem with flag for par24C in Account details.    *
      *           Default par24C according to customer maintenance.   *
      *  BUG24157 - AMA KWG field does not default to CUAP KWG filed  *
      *             when field is set to Y (Recompile)                *
      *  BUG22742 - Rectify the invalid defaulting when customer is   *
      *             flagged as Taxable                                *
      *  CER047 - German Features LF037-00 Reporting §24c KWG         *
      *  BUG22973 - No TimeStamp in Transaction Confirmation during   *
      *             Completion and Authorisation                      *
      *  BUG23484 - Amend and AutoAuthorise existing record via SOAP  *
      *             fails, gets error message MMM1067                 *
      *  CRE015 - Retail Term and Notice Accounts                     *
      *  CRE030 - Default RE Accounts by Currency                     *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17361A- Incorrect IBAN number written on account          *
      *             maintenance(Recompile)                            *
      *  245029A - Problem on RETABLE parameter when calling GLAMAD4VL*
      *            GLAMAD4VL. The parameter is cleared after call to  *
      *            GLAMAD1VL.                                         *
      *  249966 - Blank out AcnothDet only when defaulting has been   *
      *           done for an account.  Otherwise, retain the values  *
      *           as these values may have come from the interface or *
      *           is system defined.                                  *
      *  249660 - Correct retail account defaulting.                  *
      *  BUG13639 - Serious midas error in AMAD                       *
      *  245648 - Do not allow account to be edited when it already   *
      *           has been updated by another user.                   *
      *  243436 - BUG9141 has changed the conditioning for            *
      *           GLAMADJC01 - Move /COPY.                            *
      *  243129 - Initialise AccnFilFmt data structure.               *
      *  BUG13120a - Reverse Fix for BUG13120                         *
      *  BUG13120 - Missing Field - Passbook used on savings account  *
      *  242488  - Recompiled over changes to GLAMADUPD.              *
      *  240916  - Allowed execution of subroutine DFT@O when DDACTN  *
      *            is equal to 'I'.                                   *
      *  CPK025 - MidasPlus 1.3 packaging.  Field name conflict.      *
      *  240366 - Correct part of 240312. GL defaults should not be   *
      *           used when default retail account exists.            *
      *  237646 - Do not reset value of Idx when calling GLAMADRTV so *
      *           that errors found in validation will not be lost.   *
      *  240205 - Don't default retail indicators.  Patterned from    *
      *           215802.                                             *
      *  240312 - WPROCDATE is not initialised properly               *
      *         - Wrong parameters on call to GLAMADCVT               *
      *         - Allow defaulting only if called from initial screen *
      *         - Blank next day if statement frequency not periodic  *
      *  239316 - Upon insert confirmation, error message "A serious  *
      *           Midas error has occured." was displayed.            *
      *         - Error message "Account code is mandatory." appears  *
      *           twice. Code already here as TMPFX01 - now annotated *
      *           as 239316.                                          *
      *  237341 - Allow to refresh the AccnInMast dataarea to update  *
      *           the default values of the account code.             *
      *  238839 (Reopen) - IBAN field disappears when message RE72026 *
      *           is displayed because DDIBA1 is blank.  Execute      *
      *           GLVALID within INVALID tag, do not execute DFT@O    *
      *           if there are errors.                                *
      *  238625 - DDICNST is incorrect, initialise field properly     *
      *  238839 - Pass parameter DDIBAN to GLAMADRTV.                 *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  237401  - Unable to delate account - error message on        *
      *            Dr Change value date. Caused by BUG4615.           *
      *            Also correct error in parameter length between     *
      *            GLAMASDVU and GLAMADRTV                            *
      *  BUG10280- Could not Amend record on AMAD                     *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9141 - Only call ValdAcMast if delete (recompile)         *
      *  BUG8210 - GLC3571 failed due to DBERR in ACCNTBXC (empty)    *
      *            Need to change condition to read/write on ACCNTBXC *
      *            simply for all retail accounts. (Recompile)        *
      *  BUG8104- Reinstate call to AOACODR0 to populate A5ACTY       *
      *           needed by condition to display. BUG8104 shows an    *
      *           error message 'Portfolio Reference not valid'.      *
      *           This occurs when DDPTFR is validated as blank but   *
      *           not displayed. To prevent TMPFX01 from reoccuring,  *
      *           do not add message to array as this is also done in *
      *           GLAMAD1VL in validation GLVPFPO.                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it.                                         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  TMPFX01- 2 same error msgs (Account code is mandatory).      *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *  BUG6218- Extra data must be included in the buffer           *
      *  BUG4615 - Show warning message upon deletion of account      *
      *            with cheque book details still existing            *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4686- When defaulting retail accounts do not default      *
      *           customer name as this is not the name for the       *
      *           newly entered accounts' customer                    *
      *  BUG4400 - DB error occurred due to invalid timestamp         *
      *  CRE010 - Retail Account Balance Check                        *
      *  BUG4252 - Make sure files are mapped correctly (RECOMD/      *
      *            GLVAMCOPD and REAPWDPD/GLVAMPWPD)                  *
      *  BUG4196- Stopping changes being overwritten by other user    *
      *           when try to amend the record at the same time.      *
      *  BUG3068- Move INVALID tag after EXSR GLVALID                 *
      *  CLE025 - Credit Lines                                        *
      *  BUG2733 - Make sure files are mapped correctly (RECOMD/      *
      *            GLVAMCOPD and REAPWDPD/GLVAMPWPD)                  *
      *  BG2557 - Amend program to cater CSD012 changes, Standing     *
      *           Data Authorisation.                                 *
      *  BG2651 - DB error occurs if currency is blank on insert      *
      *  TDA084 - Mismatched fields between ExRIFilFmt and ValidExRI  *
      *           data structures.  Some fields in ValidExRi are      *
      *           overwritten when the values of ExRIFilFmt are moved *
      *           into it.   Move the fields of ExRIFilfmt  only to   *
      *           their matching fields in ValidExRI.                 *
      *  BUG553 - Ensure SRDEFT defaulting is for blank fields.       *
      *         - Set defaults from default RE account if applicable. *
      *         - Remove changes for BUG545 after fix BUG1271.        *
      *         - Remove CPY@ array from footer of source.            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - API Wrapper project                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)

     FTABTBRE   IF   E             DISK    INFSR(*pssr)
     F                                     PREFIX(R_)

     FPMPORTLL  IF   E           K DISK    INFSR(*PSSR)  USROPN
     FACCPTFR   IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACCPTFRF)
     F                                     PREFIX(AC_)
      ** Default Retail Account
     FREDEF     IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(X_)
     F                                     IGNORE(REDEFAF)
     F                                     IGNORE(REDEFZF)

      ** Retail Interest and Charge File
     FREIACXX   IF   E           K DISK    INFSR(*PSSR)

      ** Accounts by Branch
     FACCNTLXX  IF   E           K DISK    INFSR(*PSSR)

      ** Account Numbers
     FACNUM     IF   E           K DISK    RENAME(ACCNTABF:ACNUMTBF)
     F                                     INFSR(*PSSR)

      ** BRT Customer Details
     FSDCBRTL1  IF   E           K DISK    INFSR(*PSSR)
                                                                                              CRE015
      ** Account code extension                                                               CRE015
                                                                                              CRE015
     FSDACD1L0  IF   E           K DISK    INFSR(*PSSR)                                       CRE015
     F                                     PREFIX(X5:2)                                       CRE015

     F/COPY WNCPYSRC,GLAMADJF01
      *                                                                                      LLN022A
     FBYACCTY0  IF   E           K DISK    INFSR(*pssr)                                      LLN022A
     F                                     USROPN                                           MD051247
      *                                                                                      LLN022A
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

      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)

      * Incoming Transaction
     D AccnInMast    E DS                  EXTNAME(GLAMADPD)
     D  AcnOthDet             84    213                                                       249660
     D  AccIn130             177    253                                                     MD041837
     D AccnInDebi    E DS                  EXTNAME(GLAMDIPD)
     D AccnInCred    E DS                  EXTNAME(GLAMCIPD)
     D AccnInComm    E DS                  EXTNAME(GLAMCOPD)
     D AccnInOthe    E DS                  EXTNAME(GLAMODPD)
     D AccnInPena    E DS                  EXTNAME(GLAMPPPD)                                  CRE015
     D AccnInPena1   E DS                  EXTNAME(GLAMPP1PD) PREFIX(P1:2)                    CRE015
     D AccnInPena2   E DS                  EXTNAME(GLAMPP2PD) PREFIX(P2:2)                    CRE015
     D/COPY OFCPYSRCZ,CRE101_017                                                              CRE101

     D/COPY WNCPYSRC,GLAMADJD01

     D ValidBoe      E DS                  EXTNAME(GLVAMADX0)                                LLN022A

     D/COPY QWINDSRC,GLAMADDTA
      * Valid Account layout
     D ValidAccn     E DS                  EXTNAME(GLVAMADPD)
     D                                     PREFIX(V_)
      * Valid Extn. Account layout -> ACCNTBXC
     D ValidExBX     E DS                  EXTNAME(GLVAMBXPD)
     D                                     PREFIX(V_)
     D V_QQACC1      E                     EXTFLD(QQACOD)                                     CGL029
      * Valid Extn. Account layout -> REIACD
     D ValidExRI     E DS                  EXTNAME(GLVAMRIPD)
     D                                     PREFIX(V_)
     D V_QQACC2      E                     EXTFLD(QQACOD)                                     CGL029
     D ValidExR2     E DS                  EXTNAME(GLVAMRIPD)                                 TDA084
     D                                     PREFIX(W_)                                         TDA084
     D ValidExsh               1    144                                                       TDA084
     D ValidExex             212    284                                                       TDA084
      * Valid Extn. Account layout -> RECOMD
     D ValidExCO     E DS                  EXTNAME(GLVAMCOPD)
     D                                     PREFIX(V_)
     D V_QQACC3      E                     EXTFLD(QQACOD)                                     CGL029
     D ValidExCO1              1    286                                                      BUG2733
     D ValidExCOEx           354    363                                                      BUG2733
      **Valid Extn. Account layout ->*REAPWDPD*************************                       CSD101
     D ValidExPW     E DS                  EXTNAME(GLVAMPWPD)
     D                                     PREFIX(V_)
     D V_QQACC4      E                     EXTFLD(QQACOD)                                     CGL029
     D*ValidExPW1              1     33                                               BUG2733 CSD101
     D***ValidExPWEx           101    110                                             BUG2733 CSD101
     D ValidExPW1              1    146                                                       CSD101
     D ValidExPWEx           214    223                                                       CSD101
      * Valid Extn. Account layout -> REPRPNPD                                                CRE015
     D ValidPena     E DS                  EXTNAME(GLVAMPPPD)                                 CRE015
     D                                     PREFIX(V_)                                         CRE015

     D/COPY OFCPYSRCZ,CRE101_032                                                              CRE101
     D ValidLux      E DS                  EXTNAME(GLVAMLX1PD)                                CER001
     D                                     PREFIX(V_)                                         CER001
     D SVRCD         E DS                  EXTNAME(REACX1PD)                                  CER001
     D                                     PREFIX(E_)                                         CER001

     D AccnFilFmt    E DS                  EXTNAME(ACCNTAB)
     D ExBXFilFmt    E DS                  EXTNAME(ACCNTBXC)
     D                                     PREFIX(A_)
     D ExRIFilFmt    E DS                  EXTNAME(REIACD)
     D                                     PREFIX(B_)
     D ExRIFilsh               1    144                                                       TDA084
     D ExRIFilex             146    218                                                       TDA084
     D ExCOFilFmt    E DS                  EXTNAME(RECOMD)
     D                                     PREFIX(C_)
     D ExCOFilFmt1             1    286                                                      BUG2733
     D ExCOFilFmtEx          287    296                                                      BUG2733
     D***ExPWFilFmt    E DS                  EXTNAME(REAPWDPD)                                CSD101
     D***                                     PREFIX(D_)                                      CSD101
     D***ExPWFilFmt1             1     33                                             BUG2733 CSD101
     D***ExPWFilFmtEx           34     43                                             BUG2733 CSD101
     D ExPWFilFmt    E DS                  EXTNAME(GLVAMPWPD)                                 CSD101
     D                                     PREFIX(D2_)                                        CSD101
     D ExPWFilFmt1             1    146                                                       CSD101
     D ExPWFilFmtEx          214    223                                                       CSD101
     D ExPPFilFmt    E DS                  EXTNAME(REPENAPD)                                  CRE015
     D                                     PREFIX(E_)                                         CRE015
     D/COPY OFCPYSRCZ,CRE101_033                                                              CRE101


      * (Current) Account in Screen Format - Master Details
     D CurAcMast     E DS                  EXTNAME(GLAMADPD)
     D                                     PREFIX(@)
      * (Current) Account in Screen Format - Debit Details
     D CurAcDebi     E DS                  EXTNAME(GLAMDIPD)
     D                                     PREFIX(@)
      * (Current) Account in Screen Format - Credit Details
     D CurAcCred     E DS                  EXTNAME(GLAMCIPD)
     D                                     PREFIX(@)
      * (Current) Account in Screen Format - Commision Details
     D CurAcComm     E DS                  EXTNAME(GLAMCOPD)
     D                                     PREFIX(@)
      * (Current) Account in Screen Format - Other Details
     D CurAcOthe     E DS                  EXTNAME(GLAMODPD)
     D                                     PREFIX(@)
      * Current account in screen format - Period and Penalty                                 CRE015
     D CurAcPena     E DS                  EXTNAME(GLAMPPPD)                                  CRE015
     D                                     PREFIX(@)                                          CRE015
     D CurExtDta     E DS                  EXTNAME(GLAMEXPD)                                MD044880
     D                                     PREFIX(@)                                        MD044880
     D/COPY OFCPYSRCZ,CRE101_034                                                              CRE101
      * Current Account in File Format                                                        BUG553
     D********CrAcFilFmt    E DS                  EXTNAME(ACCNTAB)                     BUG553 240312
     D**********                           PREFIX(E_)                                  BUG553 240312
     D CrAcFilFmt    E DS                  EXTNAME(GLVAMADPD)                                 240312
     D                                     PREFIX(E_)                                         240312
     D V_QQACC8      E                     EXTFLD(QQACOD)                                     CPK025
      * Current Account in File Format (Extension File)
     D*******CABXFilFmt    E DS                  EXTNAME(ACCNTBXC)                            240312
     D**********                           PREFIX(CA_)                                        240312
     D CABXFilFmt    E DS                  EXTNAME(GLVAMBXPD)                                 240312
     D                                     PREFIX(CA_)                                        240312
     D V_QQACC5      E                     EXTFLD(QQACOD)                                     240312
      * Current Account in File Format (Extension File)                                       BUG553
     D**********     CARIFilFmt    E DS                  EXTNAME(REIACD)               BUG553 240312
     D**********                           PREFIX(CB_)                                 BUG553 240312
     D CARIFilFmt    E DS                  EXTNAME(GLVAMRIPD)                                 240312
     D                                     PREFIX(CB_)                                        240312
     D V_QQACC6      E                     EXTFLD(QQACOD)                                     240312
      * Current Account in File Format (Extension File)                                       BUG553
     D*******CACOFilFmt    E DS                  EXTNAME(RECOMD)                       BUG553 240312
     D**********                           PREFIX(CC_)                                 BUG553 240312
     D CACOFilFmt    E DS                  EXTNAME(GLVAMCOPD)                                 240312
     D                                     PREFIX(CC_)                                        240312
     D V_QQACC7      E                     EXTFLD(QQACOD)                                     240312
      * Current Account in File Format (Extension File)                                       BUG553
     D***CAPWFilFmt    E DS                  EXTNAME(REAPWDPD)                         BUG553 240312
     D***                                    PREFIX(CD_)                               BUG553 240312
     D CAPWFilFmt    E DS                  EXTNAME(GLVAMPWPD)                                 240312
     D                                     PREFIX(CD_)                                        240312
     D CAPPFilFmt    E DS                  EXTNAME(GLVAMPPPD)                                 CRE015
     D                                     PREFIX(PP_)                                        CRE015
     D/COPY OFCPYSRCZ,CRE101_035                                                              CRE101
      * New Account in File Format                                                            BUG553
     D NwAcFilFmt    E DS                  EXTNAME(GLVAMADPD)                                 BUG553
      * New Account in File Format (Extension File)
     D NABXFilFmt    E DS                  EXTNAME(GLVAMBXPD)
     D                                     PREFIX(A_)
     D QQACOD1       E                     EXTFLD(QQACOD)                                     CGL029
      * New Account in File Format (Extension File)                                           BUG553
     D NARIFilFmt    E DS                  EXTNAME(GLVAMRIPD)                                 BUG553
     D                                     PREFIX(B_)                                         BUG553
      * New Account in File Format (Extension File)                                           BUG553
     D NACOFilFmt    E DS                  EXTNAME(GLVAMCOPD)                                 BUG553
     D                                     PREFIX(C_)                                         BUG553
      * New Account in File Format (Extension File)                                           BUG553
     D NAPWFilFmt    E DS                  EXTNAME(GLVAMPWPD)                                 BUG553
     D                                     PREFIX(D_)                                         BUG553
     D NAPPFilFmt    E DS                  EXTNAME(GLVAMPPPD)                                 CRE015
     D                                     PREFIX(P_)                                         CRE015
      * New Account in Screen Format - First Details                                          BUG553
     D NewAcPrim     E DS                  EXTNAME(GLAMADPD)                                  BUG553
     D                                     PREFIX(N)                                          BUG553
      * New Account in Screen Format - Debit Details                                          BUG553
     D NewAcDebt     E DS                  EXTNAME(GLAMDIPD)                                  BUG553
     D                                     PREFIX(N)                                          BUG553
      * New Account in Screen Format - Credit Details                                         BUG553
     D NewAcCrdt     E DS                  EXTNAME(GLAMCIPD)                                  BUG553
     D                                     PREFIX(N)                                          BUG553
      * New Account in Screen Format - Commission Details                                     BUG553
     D NewAcComm     E DS                  EXTNAME(GLAMCOPD)                                  BUG553
     D                                     PREFIX(N)                                          BUG553
      * New Account in Screen Format - Other Details                                          BUG553
     D NewAcOthr     E DS                  EXTNAME(GLAMODPD)                                  BUG553
     D                                     PREFIX(N)                                          BUG553
      * New Account in Screen Format - Period and Penalty                                     CRE015
     D NewAcPena     E DS                  EXTNAME(GLAMPPPD)                                  CRE015
     D                                     PREFIX(N)                                          CRE015
     D/COPY OFCPYSRCZ,CRE101_036                                                              CRE101


      * Error indicators
     D OKAcMast      E DS                  EXTNAME(GLEAMADPD)
     D OKAcDebi      E DS                  EXTNAME(GLEAMDIPD)
     D OKAcCred      E DS                  EXTNAME(GLEAMCIPD)
     D OKAcComm      E DS                  EXTNAME(GLEAMCOPD)
     D OKAcOthe      E DS                  EXTNAME(GLEAMODPD)
     D OKAcPena      E DS                  EXTNAME(GLEAMPPPD) PREFIX(X:1)                     CRE015
     D/COPY OFCPYSRCZ,CRE101_037                                                              CRE101


     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details

     D RETABLE       E DS                  EXTNAME(TABTBRE)
     D                                     PREFIX(R_)
      ** EXTERNAL DS FOR RETAIL TABLE FILE

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External DS for Midas Modules details

     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** EXTERNAL DS FOR BRANCH DETAILS

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  External DS for currency details

     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD

     D SCSARD        E DS                  EXTNAME(SCSARDPD)

     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
                                                                                              CRE010
      ** Externally described DS for Nostro Code details                                      CRE010
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  CRE010
     D SDNOSTACCD    E                     EXTFLD(QQACCD)                                     CRE010

     D InfData       E DS                  EXTNAME(GLAMIFPD)                                  CAP086
     D                                     PREFIX(IF_)                                        CAP086
      ** GL Extra Data - Classe 1 Data - File (D/B) format                                    CAP086
                                                                                              CAP086
     D ExtData       E DS                  EXTNAME(GLAMEXPD)
      * GL Accounts Extra Data - File (D/B) format
      *                                                                                       CER001
     D RegData       E DS                  EXTNAME(GLAMRXPD)                                  CER001
      *                                                                                       CER001
      ** GL Accounts Extra Data                                                               CER001
      *                                                                                       CER001
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * Second DS for Access programs - long data structure

     D DSLDY         E DS                  EXTNAME(DSLDY)
      * Third DS for access programs, very long data structure
                                                                                              BG2557
      **  Data Structure for AOSVALR0 string                                                  BG2557
     DSVAL1            DS           200                                                       BG2557
     DSVAL11                   1      1                                                       BG2557
                                                                                              BG2557
     D CSD012          S              1A                                                      BG2557
     D SVALKK          C                   CONST('AuthReqAccntMaint')                         BG2557
     D*Wtimeval*       C                   CONST('0000-00-00-00.00.00.0000000')   BUG13120 BUG13120A
                                                                                              BG2557
      ** Override SDAULGL0                                                                    BG2557
     D CMD             S              1    DIM(50) CTDATA PERRCD(50)                          BG2557
                                                                                              BG2557

     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 status dataarea

     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD data area

     D SDACOD        E DS                  EXTNAME(SDACODPD)
      ** External DS for Account Code Details

     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
      ** External DS for Portfolio Customer Details

     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D QQDFAC1       E                     EXTFLD(QQDFAC)                                     CGL029
      ** External DS for Customer Details

     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D QQACCD1       E                     EXTFLD(QQACCD)                                     CGL029
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS

      *                                                                                       CER001
      ** DS for Dealing Details                                                               CER001
      *                                                                                       CER001
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)                                  CER001
     D QQACCD2       E                     EXTFLD(QQACCD)                                     CER001
                                                                                              CER001
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      ** EXTERNAL DS FOR MIDAS BASE RATE CODE DETAILS

     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WCMTJOBS               4    103A                                                      CSC022
      ** Commitment Control dataarea                                                          CSC022
                                                                                              CSC022
      *                                                                                       CER001
      ** Valid Extended Account in File Format                                                CER001
      *                                                                                       CER001
     D ValidFilExt   E DS                  EXTNAME(GLVAMLX1PD)                                CER001
      *                                                                                       CER001
      ** Errors Indicators Extended Fields                                                    CER001
      *                                                                                       CER001
     D OkFlagsExt    E DS                  EXTNAME(GLEAMLX1PD)                                CER001
      *                                                                                       CER001
     D/COPY WNCPYSRC,GLH00644
      **--------------------------------------------------------------------------------------------
     D RUNDAT          DS            13
      * Rundate data area
     D  AGMBIN                13     13

      *                                                                                       CER001
      ** Data Structure for CER001                                                            CER001
      *                                                                                       CER001
     D DATALUX         DS          1024                                                       CER001
     D  #1FLD1                 1      6  0                                                    CER001
      *                                                                                       CER001
     D  #1CNUM                 1      6                                                       CER001
     D  #1CCY                  7      9                                                       CER001
     D  #1ACOD                10     19                                                       CER001
     D  #1ACSQ                20     21                                                       CER001
     D  #1BRCA                22     24                                                       CER001
     D  #1ATYP                25     25                                                       CER001
     D  #1STFQ                26     26                                                       CER001
     D  #1AMNT                27     41  0                                                    CER001
     D  #1FOTR                45     64                                                       CER001
     D  #1TMST                65     90Z                                                      CER001
      *                                                                                       CER001
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0

      ** Fields (500A) to receive the incoming transaction
     D Accnt5001       S            500A
     D Accnt5002       S            500A
     D Accnt5003       S            500A
     D Accnt5004       S            500A
     D Accnt5005       S            500A
     D Accnt5006       S            500A                                                      CRE015
     D StmpTax500      S            500A                                                      CER049
     D*RepeatData      S           4500A                                               CRE015 CRE073
     D RepeatData      S           5382A                                                      CRE073
     D/COPY OFCPYSRCZ,CRE101_038                                                              CRE101

      ** Field (500A) to receive the incoming Extra Data                                      CAP086
     D InfData500      S            500A                                                      CAP086
                                                                                              CAP086
      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A

      *                                                                                       CER001
      ** Field (500A) to receive the incoming Extra Data                                      CER001
      *                                                                                       CER001
     D RegData500      S            500A                                                      CER001
      *                                                                                       CER001
      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0

      ** Indices for arrays used to set up corresponding sequence numbers
      ** for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
     D TIx             S              3P 0                                                    238839

      ** Field to tell whether Commissions are to be displayed
     D CommDisp        S              1A

      ** Fields for enhancement CSC022                                                        CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D WCmtSk          S              1A                                                      CSC022
                                                                                              CSC022
      ** Auto Authorisation flag                                                              CAP086
     D CAP086          S              1    INZ('N')                                           CAP086
                                                                                              CAP086
      ** Array to hold commitment jobs name                                                   CSC022
     D WCMT            S             10A   DIM(10)                                            CSC022
                                                                                              CSC022
     D DDEABC          S              1A                                                      CRE010
     D DDZINS          S              1A                                                    AR802610
     D TranInStamp     S            124A                                                      CER049
     D FillerBOE       S             25A                                                    MD043890
      ** Flags to indicate whether substitution is required in
      ** each of the various parts the transaction
     D RepMast         S              1A   inz('N')
     D RepDebi         S              1A   inz('N')
     D RepCred         S              1A   inz('N')
     D RepComm         S              1A   inz('N')
     D RepOthe         S              1A   inz('N')

     D WProcDate       S                   LIKE(BJRDNB)
     D CSC011          S              1A   INZ('N')
     D CRE015          S              1A                                                      CRE015
     D CER055          S              1A                                                      CER055
     D CRE010          S              1A                                                    MD028970
     D CAP205          S              1A                                                    MD044546
                                                                                              240312
      ** Flag to indicate whether defaulting is required                                      240312
     D DefaultFlag     S              1A                                                      240312

      ** APR Fields                                                                         MD054028
     D CER050          S              1A                                                    MD054028
     D DDAPRC          S              1A                                                    MD054028
     D DDAPDR          S              8A                                                    MD054028
     D DDAPCR          S              8A                                                    MD054028
     D @DDAPRC         S              1A                                                    MD054028
     D @DDAPDR         S              8A                                                    MD054028
     D @DDAPCR         S              8A                                                    MD054028
      ** Input parameters on call to AOPLCSR1
     D I@PARM          DS           256
     D  I#PORS                 1      1
     D  I#R997                 2      5
     D  I#CUST                 6     15
     D  I#BRCA                16     18
     D  I#BOOK                19     20
     D  I#PTFR                21     24
     D  I#CPGM                25     34

      ** Output parameters on call to AOPLCSR1
     D O@PARM          S            256

      *                                                                                       CER001
      ** Parameters on call to GLAMAD6UP                                                      CER001
      *                                                                                       CER001
     D PFIND           S              1                                                       CER001
      *                                                                                       CER001
      ** Introduced by CER001                                                                 CER001
      *                                                                                       CER001
     D ULX606          S              1                                                       CER001
      *                                                                                     BUG22742
      ** Introduced by CER048                                                               BUG22742
      *                                                                                     BUG22742
     D CER048          S              1                                                     BUG22742
      *                                                                                     BUG22742
     D/COPY OFCPYSRCZ,CRE101_039                                                              CRE101
     D/COPY WNCPYSRC,GLAMADVD01

      *                                                                                      LLN022A
      ** Bank of England Details File                                                        LLN022A
      *                                                                                      LLN022A
     D SSVRCD        E DS                  EXTNAME(BYACCTY1)                                 LLN022A
     D                                     PREFIX(SV)                                        LLN022A
      *                                                                                      LLN022A
      ** Error indicators (OK#S)                                                             LLN022A
      *                                                                                      LLN022A
     D OkFlags       E DS                  EXTNAME(GLEAMADX0)                                LLN022A
      *                                                                                      LLN022A
     D WFind           S              1                                                      LLN022A
     D Idx             S              3P 0                                                   LLN022A
      *                                                                                      LLN022A
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
      *****************************************************************

     C                   MOVEL     Accnt5001     AccnInMast
     C                   MOVEL     Accnt5002     AccnInDebi
     C                   MOVEL     Accnt5003     AccnInCred
     C                   MOVEL     Accnt5004     AccnInComm
     C                   MOVEL     Accnt5005     AccnInOthe
     C                   MOVEL     Accnt5006     AccnInPena1                                  CRE015
     C                   EVAL      DDZINS = %SUBST(Accnt5006:33:1)                          AR802610
     C                   MOVEL     StmpTax500    TranInStamp                                  CER049
     C                   MOVEL     InfData500    InfData                                      CAP086
     C                   MOVEL     Extdata500    Extdata
     C                   MOVEL     RegData500    RegData                                      CER001
     C                   MOVEL     RepeatData    AccnInPena2                                  CRE015
     C                   EVAL      AccnInPena = AccnInPena1 + AccnInPena2                     CRE015
     C                   EVAL      DDEABC = %SUBST(Buffer:865:1)                            MD040328
     C/COPY OFCPYSRCZ,CRE101_040                                                              CRE101
     C                   EVAL      WAPFOTranID = APFOTRANID + APFOASOCID                    AR971184
     C                   EVAL      FOTRID =  APFOTRANID + APFOASOCID                        AR971184
      ** ExtData Buffer Pointer                                                             MD054028
     C                   Z-ADD     1             eBfp              4 0                      MD054028
     C                   MOVEL     'GLAMEXPD'    FileName                                   MD054028
     C                   EXSR      GETRCDLN                                                 MD054028
     C                   ADD       RecordLen     eBfp                                       MD054028
      ** CER050 Fields                                                                      MD054028
     C                   IF        CER050 = 'Y'                                             MD054028
     C                   EVAL      DDAPRC = %SUBST(Extdata500:eBfp:1)                       MD054028
     C                   ADD       1             eBfp                                       MD054028
     C                   IF        DDAPRC = 'Y'                                             MD054028
     C                   EVAL      DDAPDR = %SUBST(Extdata500:eBfp:8)                       MD054028
     C                   ADD       8             eBfp                                       MD054028
     C                   EVAL      DDAPCR = %SUBST(Extdata500:eBfp:8)                       MD054028
     C                   ADD       8             eBfp                                       MD054028
     C                   ELSE                                                               MD054028
     C                   EVAL      DDAPDR = *BLANKS                                         MD054028
     C                   ADD       8             eBfp                                       MD054028
     C                   EVAL      DDAPCR = *BLANKS                                         MD054028
     C                   ADD       8             eBfp                                       MD054028
     C                   ENDIF                                                              MD054028
     C                   ENDIF                                                              MD054028
      *                                                                                       249660
      * Only default field values if called from the initial screen                           249660
     C                   Eval      DefaultFlag = 'N'                                          249660
     C                   If        DDACTN = 'I'                                               249660
     C                             or DDACTN = '1'                                            249660
     C                   Eval      DefaultFlag = 'Y'                                          249660
     C                   Eval      DDACTN = 'I'                                               249660
     C                   EndIf                                                                249660

      * Reset variables gradually updated

     C                   EXSR      RESETCYCLE

     C                   MOVE      *OFF          *IN30
     C     DDACTN        IFEQ      'I'
     C                   MOVE      *ON           *IN30
     C                   ENDIF
      *
      *  Processing for Inserts

     C                   EXSR      GLVACSQ

      *  Validate Action Code

     C     DDACTN        IFNE      'I'                                                        249660
     C     DefaultFlag   OREQ      'Y'                                                        249660
     C                   EXSR      ValidatAcn
     C                   ENDIF                                                                249660

      *  If error in validation of action code, fail this input
      *
     C                   Eval      TIx = Ix                                                   238839
     C     Ix            IFNE      0
     C*****BLANKCHK      Ifeq      *Blanks                                           249966 MD041837
     C     AccIn130      Ifeq      *Blanks                                                  MD041837
     C     DDACTN        ANDEQ     'I'                                                      AR801992
     C                   MOVE      *Blanks       AcnOthDet                                    249660
     C                   Endif                                                                249966
     C                   GOTO      INVALID
     C                   END

     C/COPY WNCPYSRC,GLAMADSMV1
      *                                                                                      LLN022A
      ** Move fields from main screen to Data structure                                      LLN022A
      ** to be passed to window                                                              LLN022A
      *                                                                                      LLN022A
     C     LLN007        IFEQ      'Y'                                                       LLN022A
     C                   MOVE      DDBRCA        BYBRCD                                      LLN022A
     C                   MOVE      DDCUSN        BYCNUM                                      LLN022A
     C                   MOVE      DDCCY         BYCCY                                       LLN022A
     C                   MOVE      DDACOD        BYACOD                                      LLN022A
     C                   MOVE      DDACSQ        BYACSQ                                      LLN022A
      *                                                                                      LLN022A
      ** Account Type                                                                        LLN022A
      *                                                                                      LLN022A
     C                   MOVE      AMATYP        BYATYP                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A

     C/COPY WNCPYSRC,GLAMADVC01
      *                                                                                      LLN022A
     C     Key_Byaccty0  KLIST                                                               LLN022A
     C                   KFLD                    LBRCD                                       LLN022A
     C                   KFLD                    LCNUM                                       LLN022A
     C                   KFLD                    LCCY                                        LLN022A
     C                   KFLD                    LACOD                                       LLN022A
     C                   KFLD                    LACSQ                                       LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   CLEAR                   SSVRCD                                      LLN022A
      *                                                                                      LLN022A
     C                   MOVE      DDBRCA        LBRCD                                       LLN022A
     C                   MOVE      DDCUSN        LCNUM                                       LLN022A
     C                   MOVE      DDCCY         LCCY                                        LLN022A
     C                   MOVE      DDACOD        LACOD                                       LLN022A
     C                   MOVE      DDACSQ        LACSQ                                       LLN022A
      *                                                                                      LLN022A
     C     Key_Byaccty0  CHAIN     BYACCTY0                                                  LLN022A
      *                                                                                      LLN022A
     C                   IF        %FOUND(BYACCTY0)                                          LLN022A
     C                   EVAL      SVLBRCD  = LBRCD                                          LLN022A
     C                   EVAL      SVLCNUM  = LCNUM                                          LLN022A
     C                   EVAL      SVLCCY   = LCCY                                           LLN022A
     C                   EVAL      SVLACODQ = LACODQ                                         LLN022A
     C                   EVAL      SVLACOD  = LACOD                                          LLN022A
     C                   EVAL      SVLACSQ  = LACSQ                                          LLN022A
     C                   EVAL      SVLNETI  = LNETI                                          LLN022A
     C                   EVAL      SVLDPTP  = LDPTP                                          LLN022A
     C                   EVAL      SVLSNOD  = LSNOD                                          LLN022A
     C                   EVAL      SVLLNTP  = LLNTP                                          LLN022A
     C                   EVAL      SVLMDAT  = LMDAT                                          LLN022A
     C                   EVAL      SVLLLIM  = LLLIM                                          LLN022A
     C                   ENDIF                                                               LLN022A
     C                   ENDIF                                                               LLN022A

      *  Processing depends upon Action Code

     C                   SELECT

     C                   WHEN         DDACTN = 'I'
      ********************************OR DDACTN = 'D'                                BUG4615 BUG9141
      *  Processing for Inserts
     C                   EXSR      ValidateAc
     C/COPY WNCPYSRC,GLAMADJC01                                                               243436
     C                   EXSR      ValidateBOE                                              MD044880
                                                                                             BUG9141
     C                   WHEN         DDACTN = 'D'                                           BUG9141
     C/COPY WNCPYSRC,FVT106_006                                                               FVT106
      ***Processing*for*Inserts                                                     BUG9141 MD024398
      *  Processing for Deletes - set up field values from file to prevent                  MD024398
      *  failures in validation                                                             MD024398
     C                   EXSR      SetupAmd                                                 MD024398
     C                   MOVEL     CurAcMast     AccnInMast                                 MD024398
     C/COPY WNCPYSRC,FVT106_007                                                               FVT106
     C                   EVAL      DDACTN = 'D'                                             MD024398
     C/COPY WNCPYSRC,FVT106_008                                                               FVT106
     C                   MOVEL     CurAcDebi     AccnInDebi                                 MD024398
     C                   MOVEL     CurAcCred     AccnInCred                                 MD024398
     C                   MOVEL     CurAcComm     AccnInComm                                 MD024398
     C                   MOVEL     CurAcOthe     AccnInOthe                                 MD024398
     C                   MOVEL     CurAcPena     AccnInPena1                                MD024398
     C                   MOVEL     CurExtDta     ExtData                                    MD044880
     C/COPY OFCPYSRCZ,CRE101_041                                                              CRE101
     C                   EXSR      ValdAcMast                                                BUG9141
     C                   MOVEL     ExBXFilFmt    ValidExBX                                  AR820577
     C/COPY WNCPYSRC,GLH00645
                                                                                             BUG9141
     C*COPY*WNCPYSRC,GLAMADJC01*****                                                          243436

     C                   EXSR      ValidateBOE                                              MD044880
     C**********         IF        LLN007 = 'Y'                                     LLN022A MD044880
     C**********         CALLB     'BYAMADW0VL'                                     LLN022A MD044880
     C**********         PARM                    DDACTN                             LLN022A MD044880
     C**********         PARM                    DATA                               LLN022A MD044880
     C**********         PARM                    ExtData                            LLN022A MD044880
     C**********         PARM                    OKFlags                            LLN022A MD044880
     C**********         PARM                    FldNameArr                         LLN022A MD044880
     C**********         PARM                    MsgIDArr                           LLN022A MD044880
     C**********         PARM                    MsgDtaArr                          LLN022A MD044880
     C**********         PARM                    Idx                                LLN022A MD044880
     C**********         PARM                    WFldNamArr                         LLN022A MD044880
     C**********         PARM                    WMsgIDArr                          LLN022A MD044880
     C**********         PARM                    WMsgDtaArr                         LLN022A MD044880
     C**********         PARM                    WIdx                               LLN022A MD044880
     C**********         PARM                    ValidBoe                           LLN022A MD044880
     C**********         ENDIF                                                      LLN022A MD044880
      *                                                                                      LLN022A
     C                   WHEN         DDACTN = 'A'

      *  Processing for Amends or Changes
     C                   EXSR      SetupAmd
     C                   EXSR      ValdateAmd
     C                   EXSR      ValidateAc
     C/COPY WNCPYSRC,GLAMADJC02

     C                   EXSR      ValidateBOE                                              MD044880
     C**********         IF        LLN007 = 'Y'                                     LLN022A MD044880
     C**********         CALLB     'BYAMADW0VL'                                     LLN022A MD044880
     C**********         PARM                    DDACTN                             LLN022A MD044880
     C**********         PARM                    DATA                               LLN022A MD044880
     C**********         PARM                    ExtData                            LLN022A MD044880
     C**********         PARM                    OKFlags                            LLN022A MD044880
     C**********         PARM                    FldNameArr                         LLN022A MD044880
     C**********         PARM                    MsgIDArr                           LLN022A MD044880
     C**********         PARM                    MsgDtaArr                          LLN022A MD044880
     C**********         PARM                    Idx                                LLN022A MD044880
     C**********         PARM                    WFldNamArr                         LLN022A MD044880
     C**********         PARM                    WMsgIDArr                          LLN022A MD044880
     C**********         PARM                    WMsgDtaArr                         LLN022A MD044880
     C**********         PARM                    WIdx                               LLN022A MD044880
     C**********         PARM                    ValidBoe                           LLN022A MD044880
     C**********         ENDIF                                                      LLN022A MD044880
      *                                                                                      LLN022A
     C                   ENDSL
      *
     C*****INVALID       TAG                                                                 BUG3068
     C     INVALID       TAG                                                                  238839
                                                                                              CSF011
      ** Populate Customer Details                                                            CSF011
                                                                                              CSF011
     C                   EXSR      SrPopCust                                                  CSF011
      *
      * Validate miscellaneous screen fields.
     C                   EXSR      GLVALID
      **********                                                                      BUG3068 238839
     C*****INVALID       TAG                                                          BUG3068 238839

      *  Write to database

     C     UpdateYN      IFEQ      'Y'
     C     Ix            ANDEQ     0
     C                   EXSR      WriteToDB
     C                   ENDIF

     C                   SETON                                        LR

     C     DDAPRC        Ifeq      'N'                                                        CER050
     C     DDAPCR        Ifne      *Blanks                                                    CER050
     C                   Move      *Blanks       DDAPCR                                       CER050
     C                   Endif                                                                CER050
     C     DDAPDR        Ifne      *Blanks                                                    CER050
     C                   Move      *Blanks       DDAPDR                                       CER050
     C                   Endif                                                                CER050
     C                   Endif                                                                CER050
     C     DDAPRC        Ifeq      'Y'                                                        CER050
     C     DDAPCR        Ifeq      *Blanks                                                    CER050
     C     @DDAPCR       andne     *Blanks                                                    CER050
     C                   Move      @DDAPCR       DDAPCR                                       CER050
     C                   Endif                                                                CER050
     C     DDAPDR        Ifeq      *Blanks                                                    CER050
     C     @DDAPDR       andne     *Blanks                                                    CER050
     C                   Move      @DDAPDR       DDAPDR                                       CER050
     C                   Endif                                                                CER050
     C                   Endif                                                                CER050
      ** Please ensure that when setting up the buffer, new core fields                      BUG6218
      ** are added before the data structure ExtData                                         BUG6218
                                                                                             BUG6218
      **If*timestamp*is*equal*to*blanks*retrieve*a*value*on*time*stamp*           BUG13120 BUG13120A
      **so*JAVA*program*can*process*proper*data*structure**************           BUG13120 BUG13120A
     C**********         IF        @TimeStamp = *Blanks                           BUG13120 BUG13120A
     C**********         EVAL      @TimeStamp = Wtimeval                          BUG13120 BUG13120A
     C**********         ENDIF                                                    BUG13120 BUG13120A
      **********                                                                  BUG13120 BUG13120A
     C                   MOVEL     AccnInPena    AccnInPena1                                  CRE015
     C                   MOVE      AccnInPena    AccnInPena2                                  CRE015
                                                                                              CRE015
     C                   EVAL                    Buffer = AccnInMast
     C                                           + AccnInDebi + AccnInCred
     C                                           + AccnInComm + AccnInOthe
     C                                           + @TimeStamp                                BUG4196
     C                                           + DDFAMT + AMATYP + AMSTYP
     C                                           + DODRCD + DOCRCD + INCST
     C                                           + BRT + ALT + LTYP + LINK
     C                                           + IBA1 + DOPOLC + DOPOLE
     C                                           + DSPTFR + DDDRMG1 + DDCRMG1
     C                                           + DDCEXA1 + DDCEXB1 + DDCEXC1
     C                                           + DDCEXD1 + DDCEXE1 + DDCEXF1
     C                                           + DDCEXG1
     C**********                                 + DDEABC                              CRE010 CAP086
     C**********                                 + DDEABC + InfData                    CAP086 CRE015
     C                                           + DDEABC                                     CRE015
     C                                           + AccnInPena1                                CRE015
     C                                           + DDZINS                                   AR802610
     C                                           + TranInStamp                                CER049
     C                                           + GLFullAcct                               MD026979
     C/COPY OFCPYSRCZ,CRE101_020                                                              CRE101
     C                                           + InfData                                    CRE015
     C                                           + ExtData                                  MD044880
     C                                           + DDAPRC                                   MD054028
     C                                           + DDAPDR                                   MD054028
     C                                           + DDAPCR                                   MD054028
     C**********                                 + FillerBOE                       MD043890 MD044880
     C                                           + AccnInPena2                                CRE015
     C                                           + RegData                                  MD044880
     C**********                                 + RegData                             CER001 CRE073
     C**********                                 + ExtData                           BUG62183 CRE073
     C**********         EVAL      Buffer2 = %SUBST(AccnInPena2:4973) +                CRE073 CSF011
     C**********         EVAL      Buffer2 = %SUBST(AccnInPena2:4933) +              CSF011 AR946674
     C***/COPY*OFCPYSRCZ,CRE101_063                                                  CRE101 MD044880
     C**********         EVAL      Buffer2 = %SUBST(AccnInPena2:4924) +            AR946674 MD044880
     C***/COPY*OFCPYSRCZ,CRE101_068                                                  CRE101 MD044880
     C**********                               RegData + ExtData                     CRE073 MD044880

     C     *IN28         IFEQ      *ON
     C                   CLOSE     PMPORTLL
     C                   ENDIF
      *
     C     LLN007        IFEQ      'Y'                                                      MD051247
     C                   CLOSE     BYACCTY0                                                 MD051247
     C                   ENDIF                                                              MD051247
     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidatAcn - Routine to validate action code versus the       *
      *    Account IDs supplied                                       *
      *                                                               *
      *****************************************************************
     C     ValidatAcn    BEGSR

     C                   IF        APFOTRANID <> *BLANKS AND                                AR971184
     C                             DDACTN = 'I'                                             AR971184
     C                   EVAL      ModeOfOp = '*FRONT'                                      AR971184
     C                   ELSE                                                               AR971184
     C                   EVAL      ModeOfOp = *BLANKS                                       AR971184
     C                   ENDIF                                                              AR971184
      * Validate action code versus account IDs supplied
      * This function will set the Midas account reference
      * The account in file format from the GL database is retrieved as well

     C                   RESET                   ReturnCode
     C                   CALLB     'GLAMADRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM                    ReturnCode
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      * Response mode
     C                   PARM      'S'           APRESPMODE
      *
      * Action Code
     C                   PARM                    DDACTN            1
      *
      * Front Office Transaction ID
     C**********         PARM      DDACCN        APFOTranID                                   CLE025
     C**********         PARM      DDACCN        WAPFOTranID      40                 CLE025 AR971184
     C                   PARM                    WAPFOTranID      40                        AR971184
      *
      * (Midas) Account Key
     C                   PARM                    DDCUSN
     C                   PARM                    DDCCY
     C                   PARM                    DDACOD
     C                   PARM                    DDACSQ
     C                   PARM                    DDBRCA
     C                   PARM                    DDACNO
      *
      * Commissions
     C                   PARM                    CommDisp
      * IBAN
     C                   PARM                    CFT004
     C                   PARM                    DDIBAN                                       238839
     C                   PARM                    CRE015                                       CRE015
     C/COPY OFCPYSRCZ,CRE101_008                                                              CRE101
      *
      ** New Accounts Currency
      *
     C                   PARM                    WDCCY             3
      *
      * OUTPUTS
      *
      * (Current) Account in file format
      * (Current) Account extension in file format
     C                   PARM                    AccnFilFmt
     C                   PARM                    ExBXFilFmt
     C                   PARM                    ExRIFilFmt
     C                   PARM                    ExCOFilFmt
     C                   PARM                    ExPWFilFmt
     C                   PARM                    DDPSWD                                       CSD101
     C                   PARM                    ExPPFilFmt                                   CRE015
     C/COPY OFCPYSRCZ,CRE101_014                                                              CRE101
      *
      * OK - Action code
     C                   PARM                    DDActnOK          1
      * OK - Account Key
     C                   PARM                    DDCUSNOK
     C                   PARM                    DDCCYOK
     C                   PARM                    DDACODOK
     C                   PARM                    DDACSQOK
     C                   PARM                    DDBRCAOK
     C                   PARM                    DDACNOOK
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
      * Base Rate Auth Req
     C                   PARM                    AUTHRQ            1
      * Authorisation Mode
     C                   PARM                    AUTHMD            1

     C                   IF        ULX606 = 'Y'                                               CER001
     C                   CALLB     'GLAMAD2RV'                                                CER001
     C                   PARM                    ReturnCode                                   CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    WAPFOTranID                                  CER001
     C                   PARM                    DDCUSN                                       CER001
     C                   PARM                    DDCCY                                        CER001
     C                   PARM                    DDACOD                                       CER001
     C                   PARM                    DDACSQ                                       CER001
     C                   PARM                    DDBRCA                                       CER001
     C                   PARM                    DDACNO                                       CER001
     C                   PARM                    SVRCD                                        CER001
     C                   ENDIF                                                                CER001
      *                                                                                       245648
      ** Determine if another user has already updated the account                            245648
      ** before proceeding when action is not "Insert".                                       245648
      *                                                                                       245648
     C     DDACTN        IFNE      'I'                                                        245648
     C                   MOVEL     TMST          TimeStamp        26                          245648
      *                                                                                       CER001
     C     @TimeStamp    IFNE      *BLANKS                                                  BUG23484
      *                                                                                     BUG23484
     C     @TimeStamp    IFNE      TimeStamp                                                  245648
     C                   ADD       1             Ix                                           245648
     C                   MOVEL     '*ANY'        FldNameArr(1)                                245648
     C                   MOVEL     'MMM1067'     MsgIdArr(1)                                  245648
     C                   END                                                                  245648
      *                                                                                     BUG23484
     C                   ENDIF                                                              BUG23484
      *                                                                                       245648
     C                   ENDIF                                                                245648
      *                                                                                       245648
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * ValidateLUX - Routine to validate Gl Amad File - LU Window    *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     ValidateLUX   BEGSR                                                                CER001
                                                                                              CER001
     C                   MOVE      DDCCY         #1CCY                                        CER001
     C                   MOVE      DDACOD        #1ACOD                                       CER001
     C                   MOVE      DDACSQ        #1ACSQ                                       CER001
     C                   MOVE      DDBRCA        #1BRCA                                       CER001
     C                   MOVE      DDCUSN        #1CNUM                                       CER001
     C                   MOVE      AMATYP        #1ATYP                                       CER001
      *                                                                                       CER001
     C                   CALLB     'GLAMAD6VL'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    BNDCSP                                       CER001
     C                   PARM                    OkFlagsExt                                   CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIdArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Ix                                           CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIdArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    ValidFilExt                                  CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
     C/COPY WNCPYSRC,GLH00646
      **********************************************************************
     C     GLVACSQ       BEGSR

     C                   CALLB     'GLVACSQ'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      * Account Screen Fields
     C**********         PARM                    DDACOD            4                          CGL029
     C                   PARM                    DDACOD           10                          CGL029
     C                   PARM                    DDACSQ            2
     C                   PARM                    DDCUSN            6
     C                   PARM                    A8BICN            6
     C                   PARM                    AGMBIN            1
      * OUTPUTS :
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
     C                   PARM                    AMATYP            1
     C                   PARM                    AMSTYP            1
     C                   PARM                    WWTOIN            1
     C                   PARM                    WWRETL            1
      * Account Code - OK
      * Account Sequence - OK
     C**********         PARM      *ZERO         DDACODOK          1                        AR869261
     C**********         PARM      *ZERO         DDACSQOK          1                        AR869261
     C                   PARM      'Y'           DDACODOK          1                        AR869261
     C                   PARM      'Y'           DDACSQOK          1                        AR869261
      *                                                                                      239316
      ** Use the calling of this module only to populate necessary parameters                239316
      ** Clear the error messages as these fields will again be validated                    239316
      ** in GLAMAD1VL to avoid displaying the same error twice.                              239316
      *                                                                                      239316
     C                   CLEAR                   FldNameArr                                  239316
     C                   CLEAR                   MsgIdArr                                    239316
     C                   CLEAR                   MsgDtaArr                                   239316
     C**********         EVAL      DDACODOK = *BLANK                                 239316 AR869261
     C**********         EVAL      DDACSQOK = *BLANK                                 239316 AR869261
      *
      ** Access Account Code details via access program
      *  (database error handling done in access program)
     C**********         CALL      'AOACODR0'                                                239316
     C**********         PARM      '*DBERR '     @RTCD                                        BUG553
     C**********         PARM      *BLANKS       @RTCD                                BUG553 239316
     C**********         PARM      '*KEY   '     @OPTN                                       239316
     C**********         PARM      DDACOD        @ACOD            10                         239316
     C*****SDACOD        PARM      SDACOD        DSFDY                                       239316
      *
      * Not Found
     C*****@RTCD*        IFNE      *BLANKS                                                   239316
     C*****DDACOD        ANDNE     *BLANKS                                                   239316
     C***********        MOVEL     'N'           DDACODOK                                    239316
     C***********        ADD       1             Ix                                          239316
     C***********        MOVEL     'DDACOD'      FldNameArr(Ix)                              239316
     C***********        MOVEL     'RE71037'     MsgIdArr(Ix)                                239316
     C***********        END                                                                 239316
      *                                                                                      BUG8104
      ** Access Account Code details via access program                                      BUG8104
      ** (database error handling done in access program)                                    BUG8104
      ** The call is reinstated in order to populate SDACOD                                  BUG8104
      *                                                                                      BUG8104
     C                   CALL      'AOACODR0'                                                BUG8104
     C                   PARM      '*MSG   '     @RTCD                                       BUG8104
     C                   PARM      '*KEY   '     @OPTN                                       BUG8104
     C                   PARM      DDACOD        @ACOD            10                         BUG8104
     C     SDACOD        PARM      SDACOD        DSFDY                                       BUG8104
      *                                                                                      BUG8104
      *
      ** If each field filled, generate error on 1st input screen if account already exists.
      *
     C     DDCUSN        IFNE      *BLANKS
     C     DDCCY         ANDNE     *BLANKS
     C     DDACOD        ANDNE     *BLANKS
     C     DDACSQ        ANDNE     *BLANKS
     C     DDBRCA        ANDNE     *BLANKS
     C     DDACTN        ANDEQ     'I'
      **
     C                   MOVE      DDCUSN        WWCNUM
     C                   MOVEL     DDCCY         WWCCY
     C                   MOVE      DDACOD        WWACOD
     C                   MOVE      DDACSQ        WWACSQ
     C                   MOVE      DDBRCA        WWBRCA            3
      *
     C     WWACKA        CHAIN     ACCNTLXX                           80
      *
      ** If record was found then this account cannot be entered as new.
      ** Highlight Branch field (as only one field can be highlighted).
      *
     C     *IN80         IFEQ      '0'
     C                   MOVEL     'N'           DDBRCAOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDBRCA'      FldNameArr(Ix)
     C                   MOVEL     'RE71025'     MsgIdArr(Ix)
      *
     C                   END
     C                   END
      *
      ** Ensure all fields are defauted if appropriate.
      *
     C     DDACTN        IFEQ      'I'
     C                   EXSR      SRDEFT
     C                   ENDIF

     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
     C     GLVALID       BEGSR

      *
      * Initialise screen conditioning fields for initial insert.
      *
     C     CER055        IFEQ      'Y'                                                        CER055
     C     V_BXPOLC      IFEQ      *ZEROS                                                     CER055
     C                   EVAL      DOPOLC = *BLANKS                                           CER055
     C                   ELSE                                                                 CER055
     C                   EVAL      ZDAYNO = V_BXPOLC                                          CER055
     C                   CALLB     'ZDATE2'                                                   CER055
     C                   PARM                    ZDAYNO                                       CER055
     C                   PARM                    BJDFIN                                       CER055
     C                   PARM                    ZDATE                                        CER055
     C                   PARM      *ZEROS        ZADATE                                       CER055
     C                   MOVEL(P)  ZDATE         DOPOLC                                       CER055
     C                   ENDIF                                                                CER055
      *                                                                                       CER055
     C     V_BXPOLE      IFEQ      *ZEROS                                                     CER055
     C                   EVAL      DOPOLE = *BLANKS                                           CER055
     C                   ELSE                                                                 CER055
     C                   EVAL      ZDAYNO = V_BXPOLE                                          CER055
     C                   CALLB     'ZDATE2'                                                   CER055
     C                   PARM                    ZDAYNO                                       CER055
     C                   PARM                    BJDFIN                                       CER055
     C                   PARM                    ZDATE                                        CER055
     C                   PARM      *ZEROS        ZADATE                                       CER055
     C                   MOVEL(P)  ZDATE         DOPOLE                                       CER055
     C                   ENDIF                                                                CER055
      *                                                                                       CER055
     C     V_BXPOLA      IFEQ      *ZEROS                                                     CER055
     C                   EVAL      DDPOLA = *BLANKS                                           CER055
     C                   ELSE                                                                 CER055
     C                   EVAL      ZFLD15 = V_BXPOLA                                          CER055
     C                   CALLB     'ZSEDIT'                                                   CER055
     C                   PARM                    ZFLD15           15 0                        CER055
     C                   PARM                    ZDECS             1 0                        CER055
     C                   PARM      *BLANKS       ZECODE            1                          CER055
     C                   PARM                    ZOUT21           21                          CER055
     C                   MOVE      ZOUT21        DDPOLA                                       CER055
     C                   ENDIF                                                                CER055
      *                                                                                       CER055
     C                   EVAL      ZFLD15 = *ZEROS                                            CER055
                                                                                              CER055
     C                   ELSE                                                                 CER055
     C                   MOVE      *BLANKS       DOPOLC            6
     C                   MOVE      *BLANKS       DOPOLE            6
     C                   ENDIF                                                                CER055
     C                   MOVEL     'N'           ALT               1
     C                   MOVEL     ' '           LTYP              1
     C                   MOVEL     *BLANKS       LINK             18

     C                   MOVEL     'N'           INCST             1
      *
     C                   CLEAR                   SDCURR                                       BG2651
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCCY         @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C*****@RTCD*********IFNE      *BLANKS                                                    BG2651
     C******LOCK*********IN        LDA                                                        BG2651
     C*******************MOVEL     'SDCURRPD'    DBFILE                         ************* BG2651
     C*******************Z-ADD     5             DBASE                          * DBERR 005 * BG2651
     C*******************MOVEL     CCY           DBKEY                          ************* BG2651
     C*******************OUT       LDA                                                        BG2651
     C*******************EXSR      *PSSR                                                      BG2651
     C*******************ENDIF                                                                BG2651
      *
      * Display if is an In currency past the transition start date.
      *
     C     A6INCY        IFEQ      'Y'
     C     A6TPSD        ANDLE     WProcDate
     C     CSC011        ANDEQ     'Y'                                                        238625
     C     A6INCY        OREQ      'Y'                                                        238625
     C     A6TPSD        ANDLE     BJRDNB                                                     238625
     C     CSC011        ANDNE     'Y'                                                        238625
     C                   MOVEL     'Y'           INCST
     C                   ENDIF
      *
      * Validate BRT category extension record exists.
      *
     C                   MOVEL     'N'           BRT               1
     C**********         MOVE      DDCUSN        @CNUM6            6 0                        CSD027
     C                   MOVE      DDCUSN        @CNUM6            6                          CSD027
      *
     C     S01383        IFEQ      'Y'
     C     @CNUM6        CHAIN     SDCBRTL1                           81
     C     *IN81         IFEQ      *OFF
     C     XRECI         ANDEQ     'D'
     C                   MOVEL     'Y'           BRT
     C                   ENDIF
     C                   ENDIF
      *
      ** Access Branch details
      *
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDBRCA        @BRCH             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
      ** Not Found
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           DDBRCAOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDBRCA'      FldNameArr(Ix)
     C                   MOVEL     'RE71040'     MsgIdArr(Ix)
     C                   MOVE      'Y'           IBA1              1
     C                   ELSE
     C     A8GENM        IFEQ      '1'
     C     A8GENM        OREQ      ' '
     C                   MOVE      'N'           IBA1
     C                   ELSE
     C                   MOVE      'Y'           IBA1
     C                   ENDIF
     C                   ENDIF
      *
      ** Restrict output of Portfolio Reference
     C     BGPFMG        IFEQ      'Y'
      *
     C                   MOVEL     DDCUSN        I#CUST
     C                   MOVEL     DDBRCA        I#BRCA
     C                   MOVEL     *BLANKS       I#PTFR
     C                   MOVEL     *BLANKS       I#CPGM
      *
     C                   CALLB     'AOPLCSR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    I@PARM
     C                   PARM      *BLANKS       O@PARM
     C     SDPLCS        PARM      SDPLCS        DSFDY
      *
      ** Default to display.
     C                   MOVE      'Y'           DSPTFR            1
     C     @RTCD         IFEQ      'PMA0008'
     C     @RTCD         OREQ      'PMA0009'
      *
     C     *IN30         ORNE      *ON
     C     I#PORS        ANDNE     'B'
     C     AMATYP        ANDNE     'R'
      *
     C     *IN30         ORNE      *ON
     C     I#PORS        ANDEQ     'B'
     C     AMATYP        ANDNE     'R'
     C     AMATYP        ANDNE     'N'
      *
     C     *IN30         OREQ      *ON
     C     I#PORS        ANDNE     'B'
     C     A5ACTY        ANDNE     'R'
      *
     C     *IN30         OREQ      *ON
     C     I#PORS        ANDEQ     'B'
     C     A5ACTY        ANDNE     'R'
     C     A5ACTY        ANDNE     'N'
      *
      ** Suppress Portfolio Reference.
     C                   MOVE      'N'           DSPTFR
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Restrict output of Portfolio Reference
     C     BGN4ST        IFEQ      'Y'
     C                   MOVEL     DDCUSN        @KEY10
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @KEY10           10
     C                   PARM      *BLANKS       @KEY7             7
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C     BBPRBA        ANDEQ     'Y'
      ** Default to display.
     C                   MOVE      'Y'           DSPTFR
     C                   ELSE
     C     BGPFMG        IFNE      'Y'
      ** Suppress Portfolio Reference.
     C                   MOVE      'N'           DSPTFR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C     A5ACTY        IFEQ      'R'
     C     DSPTFR        ANDEQ     'Y'
     C     *IN28         ANDEQ     *ON
     C     DDPTFR        IFEQ      *BLANKS
     C**********         MOVEL     DDCUSN        KPCNUM            6 0                        CSD027
     C                   MOVEL     DDCUSN        KPCNUM            6                          CSD027
     C                   MOVE      DDCUSN        WWCNUM
     C                   MOVE      DDCCY         WWCCY
     C                   MOVE      DDACOD        WWACOD
     C                   MOVE      DDACSQ        WWACSQ
     C                   MOVE      'N'           WWVAL             1
     C     KPCNUM        SETLL     PMPORTLL
     C     KPCNUM        READE     PMPORTLL                               88
      *
     C     *IN88         DOWEQ     *OFF
     C     WWVAL         ANDEQ     'N'
     C     PNDPCL        IFEQ      0
     C                   MOVE      PNPTFR        WWPTFR            4
     C     PTFRK         CHAIN     ACCPTFR                            81
      *
     C     *IN81         IFEQ      '0'
     C     KPCNUM        READE     PMPORTLL                               88
     C                   ELSE
     C                   MOVE      PNPTFR        DDPTFR
     C                   MOVE      'Y'           WWVAL
     C                   ENDIF
      *
     C                   ELSE
     C     KPCNUM        READE     PMPORTLL                               88
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
     C                   ENDIF
      *
     C*****DDACTN        IFNE      'I'                                                        240916
     C     DDACTN        IFEQ      'I'                                                        240916
     C     TIx           ANDEQ     0                                                          238839
     C                   EXSR      DFT@O
     C                   END
      *
      ** Set up Enable Account Balance Check Flag                                             CRE010
     C                   IF        CRE010 = 'Y'                                             MD028970
     C                             or CAP205 = 'Y'                                          MD044546
     C                   EXSR      SREnableABC                                                CRE010
     C                   ENDIF                                                              MD028970
                                                                                              CRE010
     C                   ENDSR
      *****************************************************************                       CRE010
      /EJECT                                                                                  CRE010
      *****************************************************************                       CRE010
      *                                                               *                       CRE010
      *  SREnableABC - Subroutine to setup Enable Account Balance     *                       CRE010
      *                Check flag                                     *                       CRE010
      *                                                               *                       CRE010
      *****************************************************************                       CRE010
     C     SREnableABC   BEGSR                                                                CRE010
                                                                                              CRE010
      ** Initialise account flag to 'N'                                                       CRE010
     C                   EVAL      DDEABC = 'N'                                               CRE010
                                                                                              CRE010
      ** Set to 'Y' only if retail and non=nostro account                                     CRE010
                                                                                              CRE010
     C                   IF        AMATYP = 'R'                                               CRE010
     C                   CALLB     'AONOSTR0'                                                 CRE010
     C                   PARM      *BLANKS       PRTCD             7                          CRE010
     C                   PARM      '*KEY   '     POPTN             7                          CRE010
     C                   PARM      DDCUSN        PKCUST            6                          CRE010
     C                   PARM      DDCCY         PKCYCD            3                          CRE010
     C                   PARM      DDACOD        PKACCD           10                          CRE010
     C                   PARM      DDACSQ        PKACSN            2                          CRE010
     C                   PARM                    PKNONB            2                          CRE010
     C                   PARM      DDBRCA        PKBRCD            3                          CRE010
     C                   PARM                    PKUCSN           10                          CRE010
     C                   PARM                    PKPNOI            1                          CRE010
     C     SDNOST        PARM      SDNOST        DSFDY                                        CRE010
                                                                                              CRE010
     C                   IF        PRTCD <> *BLANKS                                           CRE010
     C                   EVAL      DDEABC = 'Y'                                               CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
     C                   ENDIF                                                                CRE010
                                                                                              CRE010
     C                   ENDSR                                                                CRE010
      **********************************************************************
      /EJECT
      **********************************************************************
      * DFT@O   - DEFAULTING FOR COMMISSIONS & OVERRIDES SCREEN
      **********************************************************************
     C     DFT@O         BEGSR
      *
     C                   MOVEL     CABXFilFmt    NABXFilFmt
      *
     C                   CALLB     'AOCUSTR1'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCUSN        @CNUM            10
     C                   PARM      *BLANKS       @CNST             7
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C     BBCGRP        IFEQ      *BLANKS
     C     @RTCD         ORNE      *BLANKS
     C                   MOVEL     '1'           BBCGRP
     C                   ENDIF
      *
      *
     C                   MOVEL     DDCCY         CCY                                          240916
     C                   MOVEL     BBCRNM        DDANAM                                     MD039577
     C                   MOVE      DDSTFQ        NDDSTFQ                                    MD042713
      *                                                                                     BUG13639
      ** Do not execute GLAMAD4DT when currency code is blanks,                             BUG13639
      ** Serious midas error will be encountered                                            BUG13639
      *                                                                                     BUG13639
     C                   If        DDCCY <> *Blanks                                         BUG13639
     C                   CALLB     'GLAMAD4DT'
      *
      * INPUTS :
      * Response mode
     C                   PARM                    RetCodeIn

      * Customer Retail Group
     C                   PARM                    BBCGRP
      *
      ** CCRM Revenue Analysis
     C                   PARM                    CDE002

      * Account details (DS) in file format
     C                   PARM                    AccnFilFmt
     C                   PARM                    NABXFilFmt
     C                   PARM                    NewAcPrim                                    222427

      * OUTPUTS :
      * Screen 4 Output
     C                   PARM                    DDCEXA1          11
     C                   PARM                    DDCEXB1          11
     C                   PARM                    DDCEXC1          11
     C                   PARM                    DDCEXD1           8
     C                   PARM                    DDCEXE1           8
     C                   PARM                    DDCEXF1           8
     C                   PARM                    DDCEXG1           8
     C                   PARM                    DDDRMG1
     C                   PARM                    DDCRMG1
     C                   EndIf                                                              BUG13639

     C                   ENDSR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *    of amendments and changes.                                 *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR

      * For Amends, put the complete (pre-existing) Account into the Valid
      *  file record - fields in this will be updated during processing

     C                   MOVEL     AccnFilFmt    ValidAccn
     C                   MOVEL     ExBXFilFmt    ValidExBX
     C**********         MOVEL     ExRIFilFmt    ValidExRI                                    TDA084
     C                   CLEAR                   ValidExR2                                    TDA084
     C                   MOVEL     ExRIFilsh     ValidExsh                                    TDA084
     C                   MOVEL     ExRIFilex     ValidExex                                    TDA084
     C                   MOVEL     ValidExR2     ValidExRI                                    TDA084
     C**********         MOVEL     ExCOFilFmt    ValidExCO                                   BUG2733
     C                   MOVEL     ExCOFilFmt1   ValidExCO1                                  BUG2733
     C                   MOVEL     ExCOFilFmtEx  ValidExCOEx                                 BUG2733
     C                   MOVEL     ExPWFilFmt    ValidExPW                            BUG2733 CSD101
     C                   MOVEL     ExPWFilFmt1   ValidExPW1                                  BUG2733
     C                   MOVEL     ExPWFilFmtEx  ValidExPWEx                                 BUG2733
     C                   IF        CRE015 = 'Y'                                               CRE015
     C                   MOVEL     ExPPFilFmt    ValidPena                                    CRE015
     C                   ENDIF                                                                CRE015
     C/COPY OFCPYSRCZ,CRE101_045                                                              CRE101

      * For Amends, convert the Account to screen format

     C                   IF        CER050 = 'Y'                                             MD054028
     C                   MOVE      DDAPRC        V_BXAPRC                                   MD054028
     C                   ENDIF                                                              MD054028
      *                                                                                     MD054028
     C                   CALLB     'GLAMADCVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Account - file formats
     C                   PARM                    ValidAccn
     C                   PARM                    ValidExBX
     C                   PARM                    ValidExRI
     C                   PARM                    ValidExCO
     C                   PARM                    ValidExPW
     C                   PARM                    ValidPena                                    CRE015
     C/COPY OFCPYSRCZ,CRE101_046                                                              CRE101
      *
      * Commissions
     C                   PARM                    CommDisp
      * CCRM Revenue Analysis
     C                   PARM                    CDE002            1
      * Retail charges details
     C                   PARM                    R_FACH
     C                   PARM                    R_TSTMC
      *                                                                                     MD054028
     C                   PARM                    DDAPRC            1                        MD054028
     C                   PARM                    DDAPDR            8                        MD054028
     C                   PARM                    DDAPCR            8                        MD054028
      *
      * Output parameters
      *
      * Account - screen formats
     C                   PARM                    CurAcMast
     C                   PARM                    CurAcDebi
     C                   PARM                    CurAcCred
     C                   PARM                    CurAcComm
     C                   PARM                    CurAcOthe
     C                   PARM                    CurAcPena                                    CRE015
     C/COPY OFCPYSRCZ,CRE101_057                                                              CRE101
      *
      * Screen 1 Output
     C                   PARM      *BLANK        DDDACC            6
     C**********         PARM      *BLANK        DDLINK           18                          CGL029
     C                   PARM      *BLANK        DDLINK           24                          CGL029
     C                   PARM      *BLANK        DDFAMT            8
      *
      * Screen 2 Output
     C                   PARM      *BLANK        DODRCD            6
     C**********         PARM      *BLANK        DDPOLC            6                          CER055
     C**********         PARM      *BLANK        DDPOLE            6                          CER055
     C                   PARM                    DOPOLC            6                          CER055
     C                   PARM                    DOPOLE            6                          CER055
      *
      * Screen 3 Output
     C                   PARM      *BLANK        DOCRCD            6
      *
      * Screen 4 Output
     C                   PARM      *BLANK        DDCEXA1          11
     C                   PARM      *BLANK        DDCEXB1          11
     C                   PARM      *BLANK        DDCEXC1          11
     C                   PARM      *BLANK        DDCEXD1           8
     C                   PARM      *BLANK        DDCEXE1           8
     C                   PARM      *BLANK        DDCEXF1           8
     C                   PARM      *BLANK        DDCEXG1           8
     C                   PARM      *BLANK        DDDRMG1          12
     C                   PARM      *BLANK        DDCRMG1          12
      *                                                                                     MD054028
     C                   MOVE      DDAPCR        @DDAPCR           8                        MD054028
     C                   MOVE      DDAPDR        @DDAPDR           8                        MD054028

     C                   IF        LLN007 = 'Y'                                             MD044880
     C                   CALLB     'GLAMADCVT1'                                             MD044880
     C                   PARM                    RetCodeIn                                  MD044880
     C                   PARM                    DDCUSN                                     MD044880
     C                   PARM                    DDCCY                                      MD044880
     C                   PARM                    DDACOD                                     MD044880
     C                   PARM                    DDACSQ                                     MD044880
     C                   PARM                    DDBRCA                                     MD044880
     C                   PARM                    SSVRCD                                     MD044880
     C                   PARM                    CurExtDta                                  MD044880
     C                   ENDIF                                                              MD044880

     C                   ENDSR
     C/COPY WNCPYSRC,GLH00647
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate the main Account details     *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR

      * Validate Account master details

     C                   EXSR      ValdAcMast
      *
      *  If error in validation, fail this input
      *
     C     Ix            IFNE      0
     C                   GOTO      EValidTr
     C                   END

     C     V_AMATYP      IFEQ      'R'
     C     DDACTN        ANDNE     'D'                                                        237401
                                                                                              CRE015
      ** Validate period and penalty details before the standard                              CRE015
      ** debit and credit details                                                             CRE015
                                                                                              CRE015
     C                   IF        CRE015 = 'Y'                                               CRE015
     C                             AND X5ATTY = 'P'                                           CRE015
     C                   EXSR      ValidatePen                                                CRE015
                                                                                              CRE015
      ** If error in validation, fail this input                                              CRE015
                                                                                              CRE015
     C     Ix            IFNE      0                                                          CRE015
     C                   GOTO      EValidTr                                                   CRE015
     C                   ENDIF                                                                CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
      * Validate Account debit details

     C                   EXSR      ValdAcDebi
      *
      *  If error in validation, fail this input
      *
     C     Ix            IFNE      0
     C                   GOTO      EValidTr
     C                   END

      * Validate Account credit details

     C                   EXSR      ValdAcCred
      *
      *  If error in validation, fail this input
      *
     C     Ix            IFNE      0
     C                   GOTO      EValidTr
     C                   END

      * Validate Account commission details

     C                   EXSR      ValdAcComm
      *
      *  If error in validation, fail this input
      *
     C     Ix            IFNE      0
     C                   GOTO      EValidTr
     C                   END

      * Validate Account other details

     C                   EXSR      ValdAcOthe
      *
      *  If error in validation, fail this input
      *
     C     Ix            IFNE      0
     C                   GOTO      EValidTr
     C                   END
     C                   ENDIF

      ** Validate Lux Amad File - LU Window                                                   CER001
      *                                                                                       CER001
     C     ULX606        IFEQ      'Y'                                                        CER001
     C                   EXSR      ValidateLux                                                CER001
      *                                                                                       CER001
      ** If error in validation, fail this input                                              CER001
      *                                                                                       CER001
     C     Ix            IFNE      0                                                          CER001
     C                   LEAVESR                                                              CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C/COPY WNCPYSRC,GLH00648
     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdAcMast - Validate Account Master details                  *
      *                                                               *
      *****************************************************************
     C     ValdAcMast    BEGSR

     C                   MOVE      RETABLE       WRETABLE         52                         245029A
     C                   CALLB     'GLAMAD1VL'

      * INPUTS

      * Response mode
     C                   PARM      'S'           APRESPMODE

      * Screen Format
     C**********         PARM      '  '          WFMT              2                          BUG553
     C                   PARM                    WFMT              2                          BUG553

      ** ICD
     C                   PARM                    RETABLE

      ** Account Master details
     C                   PARM                    AccnInMast
      * Front Office ID
     C**********         PARM                    APFOTranID       20                          CLE025
     C                   PARM                    WAPFOTranID                                  CLE025

      ** Account Master Details OK inds
     C                   PARM                    OKAcMast

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix

      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx

      * Full GL Account Number
     C**********         PARM      *BLANKS       WGLKEY           18                          CGL029
     C                   PARM      *BLANKS       WGLKEY           24                          CGL029
      * IBAN Sequence
     C                   Parm                    DDIBSQ            3

      * Valid Account layout (DS) from/to caller
     C                   PARM                    ValidAccn
     C                   PARM                    ValidEXBX
      * Base Rate Auth req
     C                   PARM                    AUTHRQ            1
      * Authorisation Mode
     C                   PARM                    AUTHMD            1
      *                                                                                     MD054028
     C                   PARM                    DDAPRC            1                        MD054028
     C                   PARM                    DDAPDR            8                        MD054028
     C                   PARM                    DDAPCR            8                        MD054028
      *
      * Ensure first individual alternate address field is read if error encountered.
     C                   Z-ADD     1             I                 3 0
     C                   MOVEL     'DDRef     '  TEST             10
     C     TEST          LOOKUP    FldNameArr(I)                          99
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'DDRF01    '  FldNameArr(I)
     C                   END
     C                   MOVE      WRETABLE      RETABLE                                     245029A

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdAcDebi - Validate Account Debit details                   *
      *                                                               *
      *****************************************************************
     C     ValdAcDebi    BEGSR

     C                   CALLB     'GLAMAD2VL'

      * INPUTS

      ** Account Master details
     C                   PARM                    AccnInMast

      ** Account Debit details
     C                   PARM                    AccnInDebi

      ** Account Commision details
     C                   PARM                    AccnInComm

      * Front Office ID
     C**********         PARM                    APFOTranID       20                          CLE025
     C                   PARM                    WAPFOTranID                                  CLE025

      ** Account Debit Details OK inds
     C                   PARM                    OKAcDebi

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
      * Warning fields/message IDs/message data (arrays) from/to caller                       CER055
     C                   PARM                    WFldNamArr                                   CER055
     C                   PARM                    WMsgIDArr                                    CER055
     C                   PARM                    WMsgDtaArr                                   CER055
      * Array index (3P0) from/to caller                                                      CER055
     C                   PARM                    WIdx                                         CER055

      * Valid Account layout (DS) from/to caller
     C                   PARM                    ValidAccn
     C                   PARM                    ValidExBX
     C                   PARM                    ValidExRI
      * Revenue Analysis
     C                   PARM                    CDE002            1
     C                   PARM                    CRE015                                     AR947093
     C                   PARM                    X5ATTY                                     AR947093
      **********                                                                              BUG553
      **Ensure*first*branch*field*is*highlighted*for*alt.*DR*int.*popup*errors.               BUG553
     C**********         Z-ADD     1             I                 3 0                        BUG553
     C**********         MOVEL     'DDDACP    '  TEST             10                          BUG553
     C*****TEST*         LOOKUP    FldNameArr(I)                          99                  BUG553
     C******IN99         IFEQ      '1'                                                        BUG553
     C**********         MOVEL     'DDDRBR    '  FldNameArr(I)                                BUG553
     C**********         END                                                                  BUG553

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdAcCred - Validate Account Credit details                  *
      *                                                               *
      *****************************************************************
     C     ValdAcCred    BEGSR

     C                   CALLB     'GLAMAD3VL'

      ** Account Master details
     C                   PARM                    AccnInMast

      ** Account Credit details
     C                   PARM                    AccnInCred

      ** Account Commision details
     C                   PARM                    AccnInComm

      ** ICD
     C                   PARM                    R_TCAL
      * Front Office ID
     C**********         PARM                    APFOTranID       20                          CLE025
     C                   PARM                    WAPFOTranID                                  CLE025

      ** Account Credit details OK inds
     C                   PARM                    OKAcCred

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix
      ** Warning fields/message IDs/message data (arrays) from/to caller                    AR847249
     C                   PARM                    WFldNamArr                                 AR847249
     C                   PARM                    WMsgIDArr                                  AR847249
     C                   PARM                    WMsgDtaArr                                 AR847249
      ** Array index (3P0) from/to caller                                                   AR847249
     C                   PARM                    WIdx                                       AR847249

      * Valid Account layout (DS) from/to caller
     C                   PARM                    ValidAccn
     C                   PARM                    ValidExRI
     C                   PARM                    ValidExBX
      * Revenue Analysis
     C                   PARM                    CDE002
     C                   PARM                    CRE015                                     AR947093
     C                   PARM                    X5ATTY                                     AR947093
      **********                                                                              BUG553
      **Ensure*first*branch*field*is*highlighted*for*alt.*CR*int.*popup*errors.               BUG553
     C**********         Z-ADD     1             I                 3 0                        BUG553
     C**********         MOVEL     'DDCACP    '  TEST             10                          BUG553
     C*****TEST*         LOOKUP    FldNameArr(I)                          99                  BUG553
     C******IN99         IFEQ      '1'                                                        BUG553
     C**********         MOVEL     'DDCRBR    '  FldNameArr(I)                                BUG553
     C**********         END                                                                  BUG553
      **********                                                                              BUG553
      **Ensure*first*branch*field*is*highlighted*for*alt.*charges*popup*errors.               BUG553
     C**********         Z-ADD     1             I                 3 0                        BUG553
     C**********         MOVEL     'DDCHCP    '  TEST             10                          BUG553
     C*****TEST*         LOOKUP    FldNameArr(I)                          99                  BUG553
     C******IN99         IFEQ      '1'                                                        BUG553
     C**********         MOVEL     'DDCHBR    '  FldNameArr(I)                                BUG553
     C**********         END                                                                  BUG553

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdAcComm - Validate Account Commission details              *
      *                                                               *
      *****************************************************************
     C     ValdAcComm    BEGSR

     C                   CALLB     'GLAMAD4VL'

      ** Account Master details
     C                   PARM                    AccnInMast

      ** Account Commision details
     C                   PARM                    AccnInComm

      ** ICD
     C                   PARM                    RETABLE
      ** CCRM Revenue Analysis
     C                   PARM                    CDE002            1

      ** Account Commissions OK inds
     C                   PARM                    OKAcComm

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix

      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      * Valid Account layout (DS) from/to caller
     C                   PARM                    ValidExCO
      * Valid Account layout (extension file) (DS) from/to caller
     C                   PARM                    ValidExBX
      * Valid Account layout (DS) from/to caller
     C                   PARM                    ValidAccn

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdAcOthe - Validate Account Other details                   *
      *                                                               *
      *****************************************************************
     C     ValdAcOthe    BEGSR

     C                   CALLB     'GLAMAD5VL'

      ** Account Master details
     C                   PARM                    AccnInMast

      ** Account Other Details
     C                   PARM                    AccnInOthe
     C/COPY OFCPYSRCZ,CRE101_022                                                              CRE101

      ** Account Other details OK inds
     C                   PARM                    OKAcOthe
     C/COPY OFCPYSRCZ,CRE101_061                                                              CRE101

      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix

      * Warning fields/message IDs/message data (arrays) from/to caller                       CER047
     C                   PARM                    WFldNamArr                                   CER047
     C                   PARM                    WMsgIDArr                                    CER047
     C                   PARM                    WMsgDtaArr                                   CER047
      * Array index (3P0) from/to caller                                                      CER047
     C                   PARM                    WIdx                                         CER047
                                                                                              CER047
      * Valid Account layout (DS) from/to caller
     C                   PARM                    ValidAccn
     C                   PARM                    ValidExRI
     C                   PARM                    ValidExPW
     C/COPY OFCPYSRCZ,CRE101_046                                                              CRE101

     C                   ENDSR
      *****************************************************************                       CRE015
      /EJECT                                                                                  CRE015
      *****************************************************************                       CRE015
      *                                                               *                       CRE015
      *  ValidatePen - Validate Period and Penalty Details            *                       CRE015
      *                                                               *                       CRE015
      *****************************************************************                       CRE015
     C     ValidatePen   BEGSR                                                                CRE015
                                                                                              CRE015
     C                   CALLB     'GLAMAD7VL'                                                CRE015
                                                                                              CRE015
      ** Input                                                                                CRE015
                                                                                              CRE015
     C                   PARM                    AccnInMast                                   CRE015
     C                   PARM                    AccnInDebi                                   CRE015
     C                   PARM                    AccnInCred                                   CRE015
     C                   PARM                    CurAcDebi                                    CRE015
     C                   PARM                    CurAcCred                                    CRE015
     C                   PARM                    AccnInPena                                   CRE015
     C                   PARM                    OKAcPena                                     CRE015
                                                                                              CRE015
      ** Error fields/message IDs/message data (arrays) from/to caller                        CRE015
                                                                                              CRE015
     C                   PARM                    FldNameArr                                   CRE015
     C                   PARM                    MsgIDArr                                     CRE015
     C                   PARM                    MsgDtaArr                                    CRE015
     C                   PARM                    Ix                                           CRE015
                                                                                              CRE015
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CRE015
                                                                                              CRE015
     C                   PARM                    WFldNamArr                                   CRE015
     C                   PARM                    WMsgIDArr                                    CRE015
     C                   PARM                    WMsgDtaArr                                   CRE015
     C                   PARM                    WIdx                                         CRE015
                                                                                              CRE015
      ** Valid account layout (DS) from/to caller                                             CRE015
                                                                                              CRE015
     C                   PARM                    AccnFilFmt                                   CRE015
     C                   PARM                    ValidAccn                                    CRE015
     C                   PARM                    ValidPena                                    CRE015
                                                                                              CRE015
     C                   ENDSR                                                                CRE015
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdateAmd - Routine to check whether the fields amended      *
      *    are amendable.                                             *
      *                                                               *
      *****************************************************************
     C     ValdateAmd    BEGSR

     C                   CALLB     'GLAMADAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Incoming Account in Screen Format :
 Form * - Master Details
      * - Debit Details
      * - Credit Details
      * - Commision Details
      * - Other Details
     C                   PARM                    AccninMast
     C                   PARM                    AccninDebi
     C                   PARM                    AccninCred
     C                   PARM                    AccninComm
     C                   PARM                    AccninOthe
     C                   PARM                    AccnInPena                                   CRE015
      *
      * (Current) Account in Screen Format :
 Form * - Master Details
      * - Debit Details
      * - Credit Details
      * - Commision Details
      * - Other Details
     C                   PARM                    CurAcMast
     C                   PARM                    CurAcDebi
     C                   PARM                    CurAcCred
     C                   PARM                    CurAcComm
     C                   PARM                    CurAcOthe
     C                   PARM                    CurAcPena                                    CRE015
      *
      * OUTPUTS
      *
      * Error Indicators
     C                   PARM                    OKAcMast
     C                   PARM                    OKAcDebi
     C                   PARM                    OKAcCred
     C                   PARM                    OKAcComm
     C                   PARM                    OKAcOthe
     C                   PARM                    OKAcPena                                     CRE015
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      *
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
     C                   Z-ADD     AmIdx         Ix
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                MD044880
      *****************************************************************                     MD044880
      *                                                               *                     MD044880
      * ValidatBOE - Routine to validate Bank of England fields       *                     MD044880
      *                                                               *                     MD044880
      *****************************************************************                     MD044880
     C     ValidateBOE   BEGSR                                                              MD044880
     C                   IF        LLN007 = 'Y'                                             MD044880
     C                   CALLB     'BYAMADW0VL'                                             MD044880
     C                   PARM                    DDACTN                                     MD044880
     C                   PARM                    DATA                                       MD044880
     C                   PARM                    ExtData                                    MD044880
     C                   PARM                    OKFlags                                    MD044880
     C                   PARM                    FldNameArr                                 MD044880
     C                   PARM                    MsgIDArr                                   MD044880
     C                   PARM                    MsgDtaArr                                  MD044880
     C                   PARM                    Ix                                         MD044880
     C                   PARM                    WFldNamArr                                 MD044880
     C                   PARM                    WMsgIDArr                                  MD044880
     C                   PARM                    WMsgDtaArr                                 MD044880
     C                   PARM                    WIdx                                       MD044880
     C                   PARM                    ValidBoe                                   MD044880
     C                   ENDIF                                                              MD044880
     C                   ENDSR                                                              MD044880
      *****************************************************************                     MD044880
      /EJECT
      *****************************************************************
     C     WriteToDB     BEGSR

     C     Ix            IFEQ      0
     C                   EXSR      SETUPVALID
     C                   EXSR      UpdateDB
     C/COPY WNCPYSRC,GLAMADJC03
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   CALLB     'BYAMADW0UP'                                              LLN022A
     C                   PARM                    DDACTN                                      LLN022A
     C                   PARM                    DATA                                        LLN022A
     C                   PARM                    @RTCD                                       LLN022A
     C                   PARM                    WFIND                                       LLN022A
     C                   PARM                    ValidBoE                                    LLN022A
     C                   PARM                    SSVRCD                                      LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
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
     C                   RESET                   Ix

     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx

     C                   RESET                   AmFldNamAr
     C                   RESET                   AmMsgIDArr
     C                   RESET                   AmMsgDtaAr
     C                   RESET                   AmIdx

     C                   RESET                   FldNoArr

     C                   CLEAR                   CurAcMast
     C                   CLEAR                   CurAcDebi
     C                   CLEAR                   CurAcCred
     C                   CLEAR                   CurAcComm
     C                   CLEAR                   CurAcOthe
     C                   CLEAR                   CurAcPena                                    CRE015
     C/COPY OFCPYSRCZ,CRE101_042                                                              CRE101

     C                   MOVE      *ALL'Y'       OKAcMast
     C                   MOVE      *ALL'Y'       OKAcDebi
     C                   MOVE      *ALL'Y'       OKAcCred
     C                   MOVE      *ALL'Y'       OKAcComm
     C                   MOVE      *ALL'Y'       OKAcOthe
     C                   MOVE      *ALL'Y'       OKAcPena                                     CRE015
     C/COPY OFCPYSRCZ,CRE101_043                                                              CRE101
     C/COPY WNCPYSRC,GLH00649

     C                   CLEAR                   AccnFilFmt                                   243129
     C                   CLEAR                   ValidAccn
     C                   CLEAR                   ValidExBX
     C                   CLEAR                   ValidExCO
     C                   CLEAR                   ValidExRI
     C                   CLEAR                   ValidExPW
     C                   CLEAR                   ValidPena                                    CRE015
     C/COPY OFCPYSRCZ,CRE101_044                                                              CRE101
                                                                                              CRE015
      ** Access account code extension details                                                CRE015
                                                                                              CRE015
     C                   IF        CRE015 = 'Y'                                               CRE015
     C     DDACOD        CHAIN     SDACD1L0                                                   CRE015
     C                   IF        NOT %FOUND(SDACD1L0)                                       CRE015
     C                   EVAL      X5ATTY = *BLANKS                                           CRE015
     C                   ENDIF                                                                CRE015
     C                   ENDIF                                                                CRE015

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

      * Set Valid file field for a delete.
     C                   IF        DDACTN = 'D'
     C/COPY WNCPYSRC,FVT106_009                                                               FVT106
     C                   EVAL      ValidAccn = AccnFilFmt
     C                   MOVEL     ExCOFilFmt    ValidExCO                                   BUG4252
     C                   MOVEL     ExPWFilFmt    ValidExPW                                   BUG4252
     C                   IF        CRE015 = 'Y'                                               CRE015
     C                   MOVEL     ExPPFilFmt    ValidPena                                    CRE015
     C                   ENDIF                                                                CRE015
     C/COPY OFCPYSRCZ,CRE101_045                                                              CRE101
     C                   ENDIF
      * Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      V_AMCHTP = DDACTN
     C                   EVAL      V_AMIBAN = DDIBAN
     C                   EVAL      V_AMIBSEQN = DDIBSQ
                                                                                            AR971184
     C**********         IF        DDACTN = 'I'                                   AR971184 AR971184A
     C                   IF        APFOTranID <> *BLANKS                                   AR971184A
     C                   EVAL      V_AMFRNT =  APFOTranID                                   AR971184
     C                   EVAL      V_AMAFRT =  APFOAsocID                                   AR971184
     C                   EVAL      V_AMREPA =  APRprLocn                                    AR971184
     C                   ENDIF                                                              AR971184
                                                                                             BUG4196
      * Restore Timestamp from the original record                                           BUG4196
     C                   IF        DDACTN <> 'I'                                             BUG4196
                                                                                             BUG4400
      ** If timestamp is blank, then generate it                                             BUG4400
     C                   IF        @TimeStamp = *BLANKS                                      BUG4400
     C                   CALLB     'ZAGENTMSTM'                                              BUG4400
     C                   PARM                    @TimeStamp                                  BUG4400
     C                   ENDIF                                                               BUG4400
                                                                                             BUG4400
     C                   MOVEL     @TimeStamp    AMTMST                                      BUG4196
     C                   ENDIF                                                               BUG4196
      ** Set Auto Authorise flag for transactions from Interface                              CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      V_AMAUTH = IF_AUTH                                         CAP086
     C                   ENDIF                                                                CAP086
     C/COPY WNCPYSRC,FVT106_010                                                               FVT106

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update Database                                    *
      *                                                               *
      *****************************************************************

     C     UPDATEDB      BEGSR

      ** ACCOUNT DATABASE UPDATE
     C                   CALLB     'GLAMADUPD'
     C                   PARM      *BLANK        @@RTCD            7
     C                   PARM      'S'           RespMode          1
     C                   PARM                    ValidAccn
     C                   PARM                    ValidExBX
     C                   PARM                    ValidExRI
     C                   PARM                    ValidExCO
     C                   PARM                    ValidExPW
     C                   PARM                    ValidPena                                    CRE015
     C/COPY OFCPYSRCZ,CRE101_046                                                              CRE101
     C                   PARM                    CEU013
     C                   PARM                    CRT001
     C                   PARM                    CRT002
     C                   PARM                    CRE001
     C                   PARM                    CRT101
     C                   PARM                    CFT004
     C                   PARM                    CDE002            1
     C/COPY OFCPYSRCZ,CRE101_008                                                              CRE101
     C                   PARM                    R_FACH
     C                   PARM                    R_TSTMC
      * Base Rate Auth req
     C                   PARM                    AUTHRQ            1
      * Authorisation Mode
     C                   PARM                    AUTHMD            1
      *
      *                                                                                       CER001
      ** Update extension details if ULX606 is switched on.                                   CER001
      *                                                                                       CER001
     C                   IF        @@RTCD = *BLANKS AND                                       CER001
     C                             ULX606 = 'Y'                                               CER001
     C                   CALLB     'GLAMAD6UP'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    @@RTCD                                       CER001
     C                   PARM                    PFIND                                        CER001
     C                   PARM                    ValidFilExt                                  CER001
     C                   PARM                    SVRCD                                        CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C/COPY WNCPYSRC,GLH00650
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C*****@RTCD         IFNE      *BLANK                                                     CLE025
     C*****@RTCD         ANDNE     '*RECUPD'                                                  CLE025
     C     @@RTCD        IFNE      *BLANK                                                     CLE025
     C     @@RTCD        ANDNE     '*RECUPD'                                                  CLE025
     C                   MOVEL     '0'           APIRetc
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   ROLBK
     C                   ENDIF                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
     C                   END
      *
      ** If update not done due to record being updated by another
      *  workstation send message to screen.
     C
     C*****@RTCD         IFEQ      '*RECUPD'                                                  245648
     C     @@RTCD        IFEQ      '*RECUPD'                                                  245648
     C
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
     C
     C                   END

      ** Send the timestamp back to the screen                                              BUG22973
                                                                                            BUG22973
     C     @@RTCD        IFEQ      *BLANKS                                                  BUG22973
     C                   MOVEL     V_AMTMST      @Timestamp                                 BUG22973
     C                   ENDIF                                                              BUG22973
                                                                                            BUG22973
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      ********************************************************************
      * SRDEFT - Process default values in INSERT MODE
      ********************************************************************
     C     SRDEFT        BEGSR
      *                                                                                       249660
     C                   MOVE      AccnInMast    BLANKCHK        130                          249660
      *
      ** Initialise screen fields to default values:
      ** if called from initial screen                                                        240312
     C                   If        DefaultFlag = 'Y'                                          240312
     C**********                   and Blankchk = *BLANKS                            249660 MD041837
     C                             and AccIn130 = *BLANKS                                   MD041837
      ***Test rightmost 130 characters of screen, if blank then default.               BUG553 240312
     C******             MOVE      AccnInMast    BLANKCHK        130                   BUG553 240312
     C*****BLANKCHK      IFEQ      *BLANKS                                             BUG553 237341
      *                                                                                       BUG553
      ** If account code is retail and on REDEFD then default from that.                      BUG553
     C     AMATYP        IFEQ      'R'                                                        BUG553
      *                                                                                       BUG553
     C                   MOVE      DDACOD        WWACOK                                       BUG553
     C                   MOVE      'D'           WWRECI                                       BUG553
      *                                                                                       CRE030
     C                   IF        CRE030 = 'Y'                                               CRE030
     C                   MOVE      DDCCY         WWACCY                                       CRE030
     C     ACODK2        CHAIN     REDEFDF                            50                      CRE030
     C                   ELSE                                                                 CRE030
     C*****ACODK         CHAIN     REDEF                              50               BUG553 CRE030
     C     ACODK         CHAIN     REDEFDF                            50                      CRE030
     C                   ENDIF                                                                CRE030
      *                                                                                       BUG553
     C     *IN50         IFEQ      '0'                                                        BUG553
     C     X_RECI        ANDEQ     'D'                                                        BUG553
      *                                                                                     MD055514
     C     X_CNUM        IFEQ      *BLANKS                                                  MD055514
      *                                                                                     MD055514
     C     X_RETN        CHAIN     ACNUM                              99                    MD055514
     C     *IN99         IFEQ      '0'                                                      MD055514
     C                   MOVE      CNUM          WWCUSK                                     MD055514
     C                   MOVE      CCY           WWCCYK                                     MD055514
     C                   MOVE      ACOD          WWACOK                                     MD055514
     C                   MOVE      ACSQ          WWACSK                                     MD055514
     C                   MOVE      BRCA          WWBRCK                                     MD055514
     C     WWACKB        CHAIN     ACCNTLXX                           99                    MD055514
     C                   ENDIF                                                              MD055514
      *                                                                                     MD055514
     C                   ELSE                                                               MD055514
     C                   MOVE      X_CNUM        WWCUSK                                     MD055514
     C                   MOVE      X_RCCY        WWCCYK                                     MD055514
     C                   MOVE      X_ACOD        WWACOK                                     MD055514
     C                   MOVE      X_SEQR        WWACSK                                     MD055514
     C                   MOVE      X_BRCA        WWBRCK                                     MD055514
     C     WWACKB        CHAIN     ACCNTLXX                           99                    MD055514
     C                   ENDIF                                                              MD055514
      *                                                                                     MD055514
     C     *IN99         IFEQ      '0'                                                      MD055514
      *                                                                                       BUG553
      * Save key of account being entered.                                                    BUG553
      *                                                                                       BUG553
     C                   MOVE      DDACTN        WDACTN            1                          BUG553
     C                   MOVE      DDCUSN        WDCUSN            6                          BUG553
     C                   MOVE      DDCCY         WDCCY             3                          BUG553
     C                   MOVE      DDACOD        WDACOD           10                          BUG553
     C                   MOVE      DDACSQ        WDACSQ            2                          BUG553
     C                   MOVE      DDBRCA        WDBRCA            3                          BUG553
     C                   MOVE      DDACNO        WDACNO           10                          BUG553
      *                                                                                       BUG553
      * Lookup account for default account found.                                             BUG553
      * Result returned to Current file formats.                                              BUG553
      *                                                                                       BUG553
     C                   MOVE      'R'           DDACTN                                       BUG553
      *                                                                                       BUG553
     C                   EXSR      SRRTVACC                                                   BUG553
      *                                                                                       BUG553
      * Convert the default Account to screen format                                          BUG553
      * Result returned to New screen formats.                                                BUG553
      * Then moved to the Current screen formats.                                             BUG553
      *                                                                                       BUG553
     C                   MOVE      WDACTN        DDACTN                                       BUG553
     C     DDCUSNOK      IFEQ      'N'                                                        249660
     C     DDCCYOK       OREQ      'N'                                                        249660
     C     DDACODOK      OREQ      'N'                                                        249660
     C     DDACSQOK      OREQ      'N'                                                        249660
     C     DDBRCAOK      OREQ      'N'                                                        249660
     C     DDACNOOK      OREQ      'N'                                                        249660
     C     Ix            ORNE      *Zero                                                      249660
     C                   Eval      DefaultFlag = 'N'                                          249660
     C                   Endif                                                                249660
      *                                                                                       249660
     C     DefaultFlag   Ifeq      'Y'                                                        249660
     C                   EXSR      SRCVTACC                                                   BUG553
      * Set action code in CurAcMast.                                                         BUG553
     C                   MOVE      WDACTN        @DDACTN                                      BUG553
      *                                                                                       BUG553
      ** Replace the original account reference and reset basic fields.                       BUG553
      *                                                                                       BUG553
     C                   MOVE      WDCUSN        DDCUSN                                       BUG553
     C                   MOVE      WDCCY         DDCCY                                        BUG553
     C                   MOVE      WDACOD        DDACOD                                       BUG553
     C                   MOVE      WDACSQ        DDACSQ                                       BUG553
     C                   MOVE      WDBRCA        DDBRCA                                       BUG553
     C                   MOVE      WDACNO        DDACNO                                       BUG553
     C                   MOVE      *BLANKS       DDDACO                                       BUG553
     C                   MOVE      *BLANKS       DDIBAN                                       BUG553
      *                                                                                       BUG553
      ** Copy the New account details to the current account details.                         BUG553
      *                                                                                       BUG553
     C******             MOVE      WDCUSN        E_CNUM                                BUG553 240312
     C******             MOVE      WDCCY         E_CCY                                 BUG553 240312
     C******             MOVE      WDACOD        E_ACOD                                BUG553 240312
     C******             MOVE      WDACSQ        E_ACSQ                                BUG553 240312
     C******             MOVE      WDBRCA        E_BRCA                                BUG553 240312
     C******             MOVE      WDACNO        E_ACNO                                BUG553 240312
     C******             MOVE      *BLANKS       E_IBAN                                BUG553 240312
     C******             MOVE      *BLANKS       E_IBSEQN                              BUG553 240312
     C                   MOVE      WDCUSN        E_AMCNUM                                     240312
     C                   MOVE      WDCCY         E_AMCCY                                      240312
     C                   MOVE      WDACOD        E_AMACOD                                     240312
     C                   MOVE      WDACSQ        E_AMACSQ                                     240312
     C                   MOVE      WDBRCA        E_AMBRCA                                     240312
     C                   MOVE      WDACNO        E_AMACNO                                     240312
     C                   MOVE      *BLANKS       E_AMIBAN                                     240312
     C                   MOVE      *BLANKS       E_AMIBSEQN                                   240312
     C                   MOVE      WDCUSN        E_AMCNUM                                     240312
                                                                                              240312
      *                                                                                       BUG553
     C                   MOVE      DDACOD        WWACOK                                       BUG553
     C                   MOVE      'D'           WWRECI                                       BUG553
      *                                                                                       BUG553
     C                   IF        CRE030 = 'Y'                                               CRE030
     C                   MOVE      DDCCY         WWACCY                                       CRE030
     C     ACODK2        CHAIN     REDEFDF                            99                      CRE030
     C                   ELSE                                                                 CRE030
     C*****ACODK         CHAIN     REDEF                              99               BUG553 CRE030
     C     ACODK         CHAIN     REDEFDF                            99                      CRE030
     C                   ENDIF                                                                CRE030
      *                                                                                       BUG553
     C     *IN99         IFEQ      '0'                                                        BUG553
     C     X_RECI        ANDEQ     'D'                                                        BUG553
      *                                                                                       BUG553
     C*****X_CNUM        IFEQ      *ZEROS                                              BUG553 CSD027
     C     X_CNUM        IFEQ      *BLANKS                                                    CSD027
      *                                                                                       BUG553
     C     X_RETN        CHAIN     ACNUM                              99                      BUG553
     C     *IN99         IFEQ      '0'                                                        BUG553
     C                   MOVE      CNUM          WWCUSK                                       BUG553
     C                   MOVE      CCY           WWCCYK                                       BUG553
     C                   MOVE      ACOD          WWACOK                                       BUG553
     C                   MOVE      ACSQ          WWACSK                                       BUG553
     C                   MOVE      BRCA          WWBRCK                                       BUG553
     C     WWACKB        CHAIN     ACCNTLXX                           99                      BUG553
     C                   ENDIF                                                                BUG553
      *                                                                                       BUG553
     C                   ELSE                                                                 BUG553
     C                   MOVE      X_CNUM        WWCUSK                                       BUG553
     C                   MOVE      X_RCCY        WWCCYK                                       BUG553
     C                   MOVE      X_ACOD        WWACOK                                       BUG553
     C                   MOVE      X_SEQR        WWACSK                                       BUG553
     C                   MOVE      X_BRCA        WWBRCK                                       BUG553
     C     WWACKB        CHAIN     ACCNTLXX                           99                      BUG553
     C                   ENDIF                                                                BUG553
      *                                                                                       BUG553
     C     *IN99         IFEQ      '0'                                                        BUG553
      *                                                                                       CRE030
      ** Default Minimum Balance if CRE030 is enabled                                         CRE030
     C                   IF        CRE030 = 'Y'                                               CRE030
     C                   IF        MINB=*ZERO                                                 CRE030
     C                   EVAL      DDMINB=*BLANKS                                             CRE030
     C                   ELSE                                                                 CRE030
     C                   MOVE      *BLANKS       ZFIELD                                       CRE030
     C                   MOVE(P)   MINB          ZFIELD                                       CRE030
     C                   Z-ADD     *ZERO         ZADEC                                        CRE030
     C                   CALLB     'ZEDIT'                                                    CRE030
     C                   PARM                    ZFIELD                                       CRE030
     C                   PARM                    ZADEC                                        CRE030
     C                   MOVEL     ZFIELD        DDMINB                                       CRE030
     C                   ENDIF                                                                CRE030
     C                   ENDIF                                                                CRE030
      *                                                                                       BUG553
     C     X_RCCY        IFEQ      DDCCY                                                      BUG553
     C     DRIB          IFEQ      *ZEROS                                                     BUG553
     C                   MOVEL     *BLANKS       DDDRIB                                       BUG553
     C                   ELSE                                                                 BUG553
     C                   MOVE      DRIB          DDDRIB                                       BUG553
     C                   ENDIF                                                                BUG553
      *                                                                                       BUG553
      ** If not the same Ccy - Check Base Type is valid for other Ccy                         BUG553
     C                   ELSE                                                                 BUG553
     C     DRIB          IFNE      *ZEROS                                                     BUG553
     C                   MOVE      DRIB          WWRIB             2                          BUG553
      *                                                                                       BUG553
      ** Get Base Rate Codes                                                                  BUG553
     C                   CALL      'AOBSRTR0'                                                 BUG553
     C                   PARM      '*MSG   '     @RTCD                                        BUG553
     C                   PARM      '*KEY   '     @OPTN                                        BUG553
     C                   PARM                    DDCCY                                        BUG553
     C                   PARM                    WWRIB                                        BUG553
     C     SDBSRT        PARM      SDBSRT        DSFDY                                        BUG553
                                                                                              BUG553
     C     @RTCD         IFEQ      *BLANKS                                                    BUG553
     C                   MOVE      DRIB          DDDRIB                                       BUG553
     C                   ELSE                                                                 BUG553
     C                   MOVE      *BLANKS       DDDRIB                                       BUG553
     C                   ENDIF                                                                BUG553
     C                   ENDIF                                                                BUG553
     C                   ENDIF                                                                BUG553
      *                                                                                       BUG553
     C     DRIS          IFEQ      *ZEROS                                                     BUG553
     C                   MOVE      *BLANKS       DDDRIS                                       BUG553
     C                   ELSE                                                                 BUG553
     C     DRIS          IFLT      *ZEROS                                                     BUG553
     C                   MOVE      '-'           DDDSIG                                       BUG553
     C                   Z-SUB     DRIS          DRIS                                         BUG553
     C                   ELSE                                                                 BUG553
     C                   MOVE      ' '           DDDSIG                                       BUG553
     C                   ENDIF                                                                BUG553
     C                   MOVE      *BLANKS       ZFIELD                                       BUG553
     C                   MOVE(P)   DRIS          ZFIELD                                       BUG553
     C                   Z-ADD     7             ZADEC                                        BUG553
     C                   CALLB     'ZEDIT'                                                    BUG553
     C                   PARM                    ZFIELD           16                          BUG553
     C                   PARM                    ZADEC             1 0                        BUG553
     C                   MOVEL     ZFIELD        DDDRIS                                       BUG553
     C                   ENDIF                                                                BUG553
      *                                                                                       BUG553
     C     X_RCCY        IFEQ      DDCCY                                                      BUG553
     C     CRIB          IFEQ      *ZEROS                                                     BUG553
     C                   MOVEL     *BLANKS       DDCRIB                                       BUG553
     C                   ELSE                                                                 BUG553
     C                   MOVE      CRIB          DDCRIB                                       BUG553
     C                   ENDIF                                                                BUG553
      *                                                                                       BUG553
      ** If not the same Ccy - Check Base Type is valid for other Ccy                         BUG553
     C                   ELSE                                                                 BUG553
     C     CRIB          IFNE      *ZEROS                                                     BUG553
     C                   MOVE      CRIB          WWRIB                                        BUG553
      *                                                                                       BUG553
      ** Get Base Rate Codes                                                                  BUG553
     C                   CALLB     'AOBSRTR0'                                                 BUG553
     C                   PARM      '*MSG   '     @RTCD                                        BUG553
     C                   PARM      '*KEY   '     @OPTN                                        BUG553
     C                   PARM                    DDCCY                                        BUG553
     C                   PARM                    WWRIB                                        BUG553
     C     SDBSRT        PARM      SDBSRT        DSFDY                                        BUG553
      *                                                                                       BUG553
     C     @RTCD         IFEQ      *BLANKS                                                    BUG553
     C                   MOVE      CRIB          DDCRIB                                       BUG553
     C                   ELSE                                                                 BUG553
     C                   MOVE      *BLANKS       DDCRIB                                       BUG553
     C                   ENDIF                                                                BUG553
     C                   ENDIF                                                                BUG553
     C                   ENDIF                                                                BUG553
      *                                                                                       BUG553
     C     CRIS          IFEQ      *ZEROS                                                     BUG553
     C                   MOVE      *BLANKS       DDCRIS                                       BUG553
     C                   ELSE                                                                 BUG553
     C     CRIS          IFLT      *ZEROS                                                     BUG553
     C                   MOVE      '-'           DDCSIG                                       BUG553
     C                   Z-SUB     CRIS          CRIS                                         BUG553
     C                   ELSE                                                                 BUG553
     C                   MOVE      ' '           DDCSIG                                       BUG553
     C                   ENDIF                                                                BUG553
     C                   MOVE      *BLANKS       ZFIELD                                       BUG553
     C                   MOVE(P)   CRIS          ZFIELD                                       BUG553
     C                   Z-ADD     7             ZADEC                                        BUG553
     C                   CALLB     'ZEDIT'                                                    BUG553
     C                   PARM                    ZFIELD           16                          BUG553
     C                   PARM                    ZADEC             1 0                        BUG553
     C                   MOVEL     ZFIELD        DDCRIS                                       BUG553
     C                   ENDIF                                                                BUG553
     C                   ENDIF                                                                BUG553
      *                                                                                       BUG553
     C     DRIC          IFEQ      *ZEROS                                                     BUG553
     C                   MOVE      *BLANKS       DDDRIC                                       BUG553
     C                   ELSE                                                                 BUG553
     C                   MOVE      DRIC          DDDRIC                                       BUG553
     C                   ENDIF                                                                BUG553
      *                                                                                       BUG553
     C     NDID          IFNE      *ZEROS                                                     BUG553
     C                   CallB     'ZDATE2'                                                   BUG553
     C                   Parm      NDID          ZDAYNO            5 0                        BUG553
     C                   Parm                    BJDFIN                                       BUG553
     C                   Parm      0             ZDATE             6 0                        BUG553
     C                   Parm      *Blanks       ZADATE            7                          BUG553
     C                   Move      ZDATE         DDNDID                                       BUG553
     C                   ELSE                                                                 BUG553
     C                   MOVEL     *BLANKS       DDNDID                                       BUG553
     C                   ENDIF                                                                BUG553
      *                                                                                       BUG553
     C                   MOVE      *BLANKS       DDDRCD                                       BUG553
     C                   MOVE      *BLANKS       DDCRCD                                       BUG553
      *                                                                                       BUG553
     C                   MOVEL     DRIF          DDDRIF                                       BUG553
     C                   MOVEL     CRIF          DDCRIF                                       BUG553
      *                                                                                       BUG553
     C     DDDRIF        IFEQ      'M'                                                        BUG553
     C     DDDRIF        OREQ      'T'                                                        BUG553
     C     DDDRIF        OREQ      'Q'                                                        BUG553
     C     DDDRIF        OREQ      'X'                                                        BUG553
     C     DDDRIF        OREQ      'Y'                                                        BUG553
     C                   MOVE      DRDY          DDDNCD                                       BUG553
     C                   ELSE                                                                 BUG553
     C                   MOVE      *BLANKS       DDDNCD                                       BUG553
     C                   ENDIF                                                                BUG553
      *                                                                                       BUG553
     C     DDCRIF        IFEQ      'M'                                                        BUG553
     C     DDCRIF        OREQ      'T'                                                        BUG553
     C     DDCRIF        OREQ      'Q'                                                        BUG553
     C     DDCRIF        OREQ      'X'                                                        BUG553
     C     DDCRIF        OREQ      'Y'                                                        BUG553
     C                   MOVE      CRDY          DDCNCD                                       BUG553
     C                   ELSE                                                                 BUG553
     C                   MOVE      *BLANKS       DDCNCD                                       BUG553
     C                   ENDIF                                                                BUG553
      *                                                                                       BUG553
     C     CRIC          IFEQ      *ZEROS                                                     BUG553
     C                   MOVE      *BLANKS       DDCRIC                                       BUG553
     C                   ELSE                                                                 BUG553
     C                   MOVE      CRIC          DDCRIC                                       BUG553
     C                   ENDIF                                                                BUG553
      *                                                                                       BUG553
     C     NCID          IFNE      *ZEROS                                                     BUG553
     C                   CallB     'ZDATE2'                                                   BUG553
     C                   Parm      NCID          ZDAYNO            5 0                        BUG553
     C                   Parm                    BJDFIN                                       BUG553
     C                   Parm      0             ZDATE             6 0                        BUG553
     C                   Parm      *Blanks       ZADATE            7                          BUG553
     C                   Move      ZDATE         DDNCID                                       BUG553
     C                   ELSE                                                                 BUG553
     C                   MOVEL     *BLANKS       DDNCID                                       BUG553
     C                   ENDIF                                                                BUG553
      *                                                                                       BUG553
     C     WWACK2        CHAIN     REIACXX                            99                      BUG553
      *                                                                                       BUG553
     C     *IN99         IFEQ      '0'                                                        BUG553
      *                                                                                       BUG553
     C     X_RCCY        IFEQ      DDCCY                                                      BUG553
      *                                                                                       BUG553
     C                   MOVEL     *BLANKS       DDDICT                                       BUG553
     C     DICT          IFNE      *ZEROS                                                     BUG553
     C                   MOVE      DICT          DDDICT                                       BUG553
     C                   ENDIF                                                                BUG553
      *                                                                                       BUG553
     C                   MOVEL     *BLANKS       DDCICT                                       BUG553
     C     CICT          IFNE      *ZEROS                                                     BUG553
     C                   MOVE      CICT          DDCICT                                       BUG553
     C                   ENDIF                                                                BUG553
      *                                                                                       BUG553
     C     DCST          IFEQ      *ZEROS                                                     BUG553
     C                   MOVEL     *BLANKS       DDDCST                                       BUG553
     C                   ELSE                                                                 BUG553
     C                   MOVE      DCST          DDDCST                                       BUG553
     C                   ENDIF                                                                BUG553
      *                                                                                       BUG553
     C     CCST          IFEQ      *ZEROS                                                     BUG553
     C                   MOVEL     *BLANKS       DDCCST                                       BUG553
     C                   ELSE                                                                 BUG553
     C                   MOVE      CCST          DDCCST                                       BUG553
     C                   ENDIF                                                                BUG553
      *                                                                                       BUG553
     C                   ENDIF                                                                BUG553
      *                                                                                       BUG553
     C                   ENDIF                                                                BUG553
      *                                                                                       BUG553
     C                   ENDIF                                                                BUG553
      *                                                                                       BUG553
      ** This moves the CurAcFilFmt retail defaults to CurAcMast.                             BUG553
     C******             Z-ADD     WprocDate     E_DACO                               BUG553  240312
     C                   Z-ADD     WprocDate     E_AMDACO                                     240312
     C                   EXSR      SRCVTACC                                                   BUG553
      * Set action code in CurAcMast.                                                         BUG553
     C                   MOVE      WDACTN        @DDACTN                                      BUG553
      ** Move the defaults to the screen fields.                                              BUG553
     C                   MOVEL     CurAcMast     AccnInMast                                   BUG553
     C                   CALLB     'AOCUSTR1'                                               MD040146
     C                   PARM      '*DBERR '     @RTCD                                      MD040146
     C                   PARM      '*KEY   '     @OPTN                                      MD040146
     C                   PARM      DDCUSN        @CNUM                                      MD040146
     C                   PARM      *BLANKS       @CNST                                      MD040146
     C     SDCUST        PARM      SDCUST        DSLDY                                      MD040146
     C                   EVAL      DDANAM = BBCRNM                                          MD040146
     C                   MOVEL     CurAcDebi     AccnInDebi                                   BUG553
     C                   MOVEL     CurAcCred     AccnInCred                                   BUG553
     C                   MOVEL     CurAcComm     AccnInComm                                   BUG553
     C                   MOVEL     CurAcOthe     AccnInOthe                                   BUG553
     C                   IF        CRE015 = 'Y'                                               CRE015
     C                   MOVEL     CurAcPena     AccnInPena                                   CRE015
     C                   ENDIF                                                                CRE015
     C/COPY OFCPYSRCZ,CRE101_062                                                              CRE101
      **********                                                                    BUG4686 AR869261
     C***Access*customer*details*doDdefault*theRcorrect*client*name****             BUG4686 AR869261
     C**********         CALLB     'AOCUSTR1'                                       BUG4686 AR869261
     C**********         PARM      '*DBERR '     @RTCD                              BUG4686 AR869261
     C**********         PARM      '*KEY   '     @OPTN                              BUG4686 AR869261
     C**********         PARM      DDCUSN        @CNUM            10                BUG4686 AR869261
     C**********         PARM      *BLANKS       @CNST             7                BUG4686 AR869261
     C*****SDCUST        PARM      SDCUST        DSLDY                              BUG4686 AR869261
      **********                                                                    BUG4686 AR869261
     C**********         Eval      DDANAM = BBCRNM                                  BUG4686 AR869261
      *                                                                                       240205
      * Setup DDACCN and reset values that shouldn't be defaulted                             240205
     C                   EVAL      %SUBST(DDACCN:1:3)=DDBRCA                                  240205
     C                   EVAL      %SUBST(DDACCN:4:6)=DDCUSN                                  240205
     C                   EVAL      %SUBST(DDACCN:10:3)=DDCCY                                  240205
     C                   EVAL      %SUBST(DDACCN:13:10)=DDACOD                                240205
     C                   EVAL      %SUBST(DDACCN:23:2)=DDACSQ                                 240205
     C                   MOVE      'N'           DDINAI                                       240205
     C                   MOVE      'N'           DDBRLI                                       240205
     C                   MOVE      'N'           DDBADI                                       240205
      *                                                                                       BUG553
     C                   ENDIF                                                                BUG553
      *                                                                                       BUG553
     C                   ENDIF                                                              MD055514
     C                   ENDIF                                                                249660
      *                                                                                       249660
     C                   ENDIF                                                                BUG553
      *                                                                                       262070
     C                   EVAL      DD24C = *BLANKS                                            262070
      *                                                                                       BUG553
     C**********         ENDIF                                                         BUG553 237341
     C                   EndIf                                                                240312
      *                                                                                       BUG553
      ** Proceed to the GL defaults if no RE default account was used.                        BUG553
      ** - if called from initial screen                                                      240312
     C                   MOVE      AccnInMast    BLANKCHK        130                          240366
     C                   If        DefaultFlag = 'Y'                                          240312
     C**********                   and Blankchk = *BLANKS                            240366 MD041837
     C                             and AccIn130 = *BLANKS                                   MD041837
      ** Test rightmost 130 characters of screen, if blank then default.                      BUG553
     C******             MOVE      AccnInMast    BLANKCHK                              BUG553 240312
     C*****BLANKCHK      IFEQ      *BLANKS                                             BUG553 240312
      *                                                                                       BUG553
     C                   MOVE      'Y'           DDPTAD
     C**********         MOVE      'N'           DDRAD                                      MD055212
     C**********         MOVE      'N'           DDRAC                                      MD055212
     C**********         MOVE      'N'           DDBAD                                      MD055212
     C**********         MOVE      'N'           DDBAC                                      MD055212
      *
      ** Dft the Statement Freq to the value held on the GL ICD (SdGelr)
     C                   MOVE      BKDSFC        DDSTFQ
      *                                                                                       240312
      ** Blank the next statement day field if it is an invalid period                        240312
     C                   If        BKDSFC <> 'M' and                                          240312
     C                             BKDSFC <> 'T' and                                          240312
     C                             BKDSFC <> 'Q' and                                          240312
     C                             BKDSFC <> 'X' and                                          240312
     C                             BKDSFC <> 'Y'                                              240312
     C                   Eval      DDNSDN = *Blanks                                           240312
     C                   EndIf                                                                240312
      *
      ** Access customer details
     C                   CALLB     'AOCUSTR1'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      DDCUSN        @CNUM            10
     C                   PARM      *BLANKS       @CNST             7
     C     SDCUST        PARM      SDCUST        DSLDY
      *
      ***Dft*Account*Name*to*Client*Name*******************************                     AR869261
     C**********         MOVE      BBCRNM        DDANAM                                     AR869261
     C**********         MOVE      BBCRNM        WWANAM           20                        AR869261
      *
      ** If Midas/Trade Innovation Interface is switched on then
      ** TI Account defaults to 'N' and other TI fields to blanks
     C     BGN3ST        IFEQ      'Y'
     C                   MOVE      'N'           DDTIAC
     C**********         MOVE      *BLANKS       DDTIAN                                       BUG553
     C**********         MOVE      *BLANKS       DDTIAS                                       BUG553
     C                   ENDIF
      *
     C**********         MOVE      *BLANKS       DDDACO                                       BUG553
     C**********         MOVE      *BLANKS       DDNSTD                                       BUG553
     C**********         MOVE      *BLANKS       DDENOC                                       BUG553
     C**********         MOVE      *BLANKS       DDNSDN                                       BUG553
     C**********         MOVE      *BLANKS       DDEUSB                                       BUG553
     C**********         MOVE      *BLANKS       DDREF                                        BUG553
     C**********         MOVE      *BLANKS       DDPRFC                                       BUG553
     C**********         MOVE      *BLANKS       DDMFFQ                                       BUG553
     C**********         MOVE      *BLANKS       DDPTFR                                       BUG553
      *
     C     CRE007        IFEQ      'N'
     C                   MOVE      BBTAIN        DDITAX
     C                   ELSE
     C                   MOVE      'N'           DDITAX
     C                   ENDIF
      *                                                                                     BUG22742
     C                   IF        CER048 = 'Y'                                             BUG22742
     C                   EVAL      DDITAX = *BLANKS                                         BUG22742
     C                   ENDIF                                                              BUG22742
      *
     C                   MOVE      R_TSTMC       DDSTCI
     C**********         MOVE      *BLANKS       DDCHIN                                       BUG553
     C**********         MOVE      *BLANKS       DDCHAM                                       BUG553
      *
     C                   EVAL      DD24C = *BLANKS                                            262070
      *                                                                                       262070
     C                   ENDIF                                                                BUG553
      *                                                                                       BUG553
     C**********         IF        DDANAM  =  *BLANKS                              AR812501 AR869261
     C**********         CALLB     'AOCUSTR1'                                      AR812501 AR869261
     C**********         PARM      '*DBERR '     @RTCD                             AR812501 AR869261
     C**********         PARM      '*KEY   '     @OPTN                             AR812501 AR869261
     C**********         PARM      DDCUSN        @CNUM                             AR812501 AR869261
     C**********         PARM      *BLANKS       @CNST                             AR812501 AR869261
     C*****SDCUST        PARM      SDCUST        DSLDY                             AR812501 AR869261
      **********                                                                   AR812501 AR869261
      ***Retrieve*Account*Name*from*Customer*Report*Name***************            AR812501 AR869261
      **********                                                                   AR812501 AR869261
     C**********         EVAL      DDANAM = BBCRNM                                 AR812501 AR869261
     C**********         ENDIF                                                     AR812501 AR869261
                                                                                              CRE015
      ** Retrieve penalty default details for period accounts                                 CRE015
                                                                                              CRE015
     C                   IF        CRE015 = 'Y'                                               CRE015
     C                             AND X5ATTY = 'P'                                           CRE015
     C                   MOVEL     AccnInPena    Blankchk                                     CRE015
     C                   IF        DefaultFlag = 'Y'                                          CRE015
     C                             AND Blankchk = *BLANKS                                     CRE015
     C                             AND DDCUSN <> *BLANKS                                      CRE015
     C                             AND DDCCY  <> *BLANKS                                      CRE015
     C                             AND DDACOD <> *BLANKS                                      CRE015
     C                   EXSR      SRRTVACC                                                   CRE015
     C                   IF        Ix = 0                                                     CRE015
     C                   EXSR      SRCVTACC                                                   CRE015
     C                   MOVEL     CurAcPena     AccnInPena                                   CRE015
     C                   ENDIF                                                                CRE015
     C                   ENDIF                                                                CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  BUG553
      *****************************************************************                       BUG553
      * SRRTVACC - Retrieve Account                                                           BUG553
      *****************************************************************                       BUG553
     C     SRRTVACC      BEGSR                                                                BUG553
                                                                                            AR971184
     C                   IF        APFOTRANID <> *BLANKS AND                                AR971184
     C                             DDACTN = 'I'                                             AR971184
     C                   EVAL      ModeOfOp = '*FRONT'                                      AR971184
     C                   ELSE                                                               AR971184
     C                   EVAL      ModeOfOp = *BLANKS                                       AR971184
     C                   ENDIF                                                              AR971184
      *                                                                                       BUG553
      * Retrieve Account                                                                      BUG553
      *                                                                                       BUG553
     C                   CALLB     'GLAMADRTV'                                                BUG553
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯                                                 BUG553
      * INPUTS :                                                                              BUG553
      * Return code                                                                           BUG553
     C                   PARM      *BLANK        RetCodeOut                                   BUG553
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                                  BUG553
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                              BUG553
     C                   PARM      '      '      @@MODE            6                          BUG553
      * Response mode                                                                         BUG553
     C                   PARM      'S'           @@RSMD            1                          BUG553
      * Action Code                                                                           BUG553
     C                   PARM                    DDACTN                                       BUG553
      * Front Office Transaction ID                                                           BUG553
     C*******            PARM                    FOTRID           20                   BUG553 237401
     C                   PARM                    FOTRID           40                          237401
      * (Midas) Account Reference                                                             BUG553
     C                   PARM                    DDCUSN                                       BUG553
     C                   PARM                    DDCCY                                        BUG553
     C                   PARM                    DDACOD                                       BUG553
     C                   PARM                    DDACSQ                                       BUG553
     C                   PARM                    DDBRCA                                       BUG553
     C                   PARM                    DDACNO                                       BUG553
      * Commissions                                                                           BUG553
     C                   PARM                    CommDisp                                     BUG553
      * IBAN                                                                                  BUG553
     C                   PARM                    CFT004                                       BUG553
     C                   PARM                    DDIBAN                                       238839
     C                   PARM                    CRE015                                       CRE015
     C/COPY OFCPYSRCZ,CRE101_008                                                              CRE101
      *                                                                                       BUG553
      ** New Accounts Currency                                                                BUG553
      *                                                                                       BUG553
     C                   PARM                    WDCCY                                        BUG553
      * OUTPUTS :                                                                             BUG553
      * (Current) Account in file format                                                      BUG553
     C                   PARM                    CrAcFilFmt                                   BUG553
     C                   PARM                    CABXFilFmt                                   BUG553
     C                   PARM                    CARIFilFmt                                   BUG553
     C                   PARM                    CACOFilFmt                                   BUG553
     C                   PARM                    CAPWFilFmt                                   BUG553
     C                   PARM                    DDPSWD                                       CSD101
     C                   PARM                    CAPPFilFmt                                   CRE015
     C/COPY OFCPYSRCZ,CRE101_026                                                              CRE101
      * OK - Action code                                                                      BUG553
     C                   PARM      *BLANK        DDACTNOK                                     BUG553
      * OK - Account Reference                                                                BUG553
     C                   PARM                    DDCUSNOK                                     BUG553
     C                   PARM                    DDCCYOK                                      BUG553
     C                   PARM                    DDACODOK                                     BUG553
     C                   PARM                    DDACSQOK                                     BUG553
     C                   PARM                    DDBRCAOK                                     BUG553
     C                   PARM                    DDACNOOK                                     BUG553
      * Error fields/message IDs/message data (arrays) from/to caller                         BUG553
     C                   PARM                    FldNameArr                                   BUG553
     C                   PARM                    MsgIdArr                                     BUG553
     C                   PARM                    MsgDtaArr                                    BUG553
      * Array index (3P0) from/to caller                                                      BUG553
     C***********        PARM      *ZERO         Ix                                    BUG553 237646
     C                   PARM                    Ix                                           237646
      * Base Rate Auth req                                                                    BUG553
     C                   PARM                    AUTHRQ                                       BUG553
      * Authorisation Mode                                                                    BUG553
     C                   PARM                    AUTHMD                                       BUG553
      *                                                                                       BUG553
     C     EndRTVACC     ENDSR                                                                BUG553
      *****************************************************************                       BUG553
      /EJECT                                                                                  BUG553
      *****************************************************************                       BUG553
      * SRCVTACC - Put a Account on the detial screens                                        BUG553
      *****************************************************************                       BUG553
     C     SRCVTACC      BEGSR                                                                BUG553
      *                                                                                       BUG553
     C                   IF        CER050 = 'Y'                                             MD054028
     C                   MOVE      DDAPRC        V_BXAPRC                                   MD054028
     C                   ENDIF                                                              MD054028
      * Call program to fill screen fields with data from master files                        BUG553
      *                                                                                       BUG553
     C                   CALLB     'GLAMADCVT'                                                BUG553
      *                                                                                       BUG553
      * INPUTS :                                                                              BUG553
      * Return Code                                                                           BUG553
      * Account in file format                                                                BUG553
     C                   PARM      *BLANK        RetCodeOut                                   BUG553
     C                   PARM                    CrAcFilFmt                                   BUG553
     C                   PARM                    CABXFilFmt                                   BUG553
     C                   PARM                    CARIFilFmt                                   BUG553
     C                   PARM                    CACOFilFmt                                   BUG553
     C                   PARM                    CAPWFilFmt                                   BUG553
     C                   PARM                    CAPPFilFmt                                   CRE015
     C/COPY OFCPYSRCZ,CRE101_026                                                              CRE101
      *                                                                                       BUG553
      * Commissions                                                                           BUG553
     C                   PARM                    CommDisp                                     BUG553
      * CCRM Revenue Analysis                                                                 BUG553
     C                   PARM                    CDE002            1                          BUG553
      *                                                                                       BUG553
      * Retail Details                                                                        BUG553
     C                   PARM                    R_FACH                                       BUG553
     C                   PARM                    R_TSTMC                                      BUG553
      *                                                                                     MD054028
     C                   PARM                    DDAPRC                                     MD054028
     C                   PARM                    DDAPDR                                     MD054028
     C                   PARM                    DDAPCR                                     MD054028
      * OUTPUTS                                                                               BUG553
      * Account - screen formats                                                              BUG553
     C                   PARM                    NewAcPrim                                    BUG553
     C                   PARM                    NewAcDebt                                    BUG553
     C                   PARM                    NewAcCrdt                                    BUG553
     C                   PARM                    NewAcComm                                    BUG553
     C                   PARM                    NewAcOthr                                    BUG553
     C                   PARM                    NewAcPena                                    CRE015
     C/COPY OFCPYSRCZ,CRE101_028                                                              CRE101
      *                                                                                       BUG553
      * Screen 1 Output                                                                       BUG553
     C                   PARM                    DDDACC            6                          BUG553
     C                   PARM                    DDLINK           24                          BUG553
     C                   PARM                    DDFAMT            8                          BUG553
      *                                                                                       BUG553
      * Screen 2 Output                                                                       BUG553
     C                   PARM                    DODRCD            6                          BUG553
     C                   PARM                    DOPOLC            6                          BUG553
     C                   PARM                    DOPOLE            6                          BUG553
      *                                                                                       BUG553
      * Screen 3 Output                                                                       BUG553
     C                   PARM                    DOCRCD            6                          BUG553
      *                                                                                       BUG553
      * Screen 4 Output                                                                       BUG553
     C                   PARM                    DDCEXA1          11                          BUG553
     C                   PARM                    DDCEXB1          11                          BUG553
     C                   PARM                    DDCEXC1          11                          BUG553
     C                   PARM                    DDCEXD1           8                          BUG553
     C                   PARM                    DDCEXE1           8                          BUG553
     C                   PARM                    DDCEXF1           8                          BUG553
     C                   PARM                    DDCEXG1           8                          BUG553
     C                   PARM                    DDDRMG1          12                          BUG553
     C                   PARM                    DDCRMG1          12                          BUG553
      *                                                                                     MD054028
     C                   MOVE      DDAPCR        @DDAPCR                                    MD054028
     C                   MOVE      DDAPDR        @DDAPDR                                    MD054028
      *                                                                                       BUG553
      * Update 'Current' Account with Account in Screen Format                                BUG553
      *                                                                                       BUG553
     C                   MOVEL     NewAcPrim     CurAcMast                                    BUG553
     C                   MOVEL     NewAcDebt     CurAcDebi                                    BUG553
     C                   MOVEL     NewAcCrdt     CurAcCred                                    BUG553
     C                   MOVEL     NewAcComm     CurAcComm                                    BUG553
     C                   MOVEL     NewAcOthr     CurAcOthe                                    BUG553
     C                   IF        CRE015 = 'Y'                                               CRE015
     C                   MOVEL     NewAcPena     CurAcPena                                    CRE015
     C                   ENDIF                                                                CRE015
     C/COPY OFCPYSRCZ,CRE101_047                                                              CRE101
      *                                                                                       BUG553
     C                   ENDSR                                                                BUG553
      *****************************************************************                       BUG553
      /EJECT
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      *  SrPopCust - Subroutine to Populate Customer Name Details     *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
      *                                                                                       CSF011
     C     SrPopCust     BEGSR                                                                CSF011
                                                                                              CSF011
      ** Retrieve Customer Details                                                            CSF011
                                                                                              CSF011
     C                   IF        DDCUSN <> *BLANKS                                          CSF011
                                                                                              CSF011
     C                   EXSR      SrRtvCust                                                  CSF011
     C                   IF        @RTCD = *BLANKS                                            CSF011
     C                   EVAL      DDCRSN = BBCSSN                                           CSF011A
     C                   EVAL      DDCRNM = BBCRNM                                           CSF011A
     C                   EVAL      DDCRTN = BBCRTN                                           CSF011A
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      *****************************************************************                       CSF011
      /EJECT                                                                                  CSF011
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      *  SrRtvCust - Subroutine to Retrieve Customer Details          *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
     C     SrRtvCust     BEGSR                                                                CSF011
                                                                                              CSF011
      ** Call AOCUSTR0 to get Customer Details                                                CSF011
                                                                                              CSF011
     C                   CALLB     'AOCUSTR0'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      '*KEY   '     @OPTN                                        CSF011
     C                   PARM      DDCUSN        @KEY10                                       CSF011
     C                   PARM      *BLANKS       @KEY7                                        CSF011
     C     SDCUST        PARM      SDCUST        DSLDY                                        CSF011
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      *****************************************************************                       CSF011
      /EJECT                                                                                  CSF011
      ****************************************************************                      MD054028
      *  Get Record Lengths of Transaction Data Blocks               *                      MD054028
      ****************************************************************                      MD054028
     C     GETRCDLN      BEGSR                                                              MD054028
                                                                                            MD054028
     C                   CALLB     'UTGETRCDLN'                                             MD054028
     C                   PARM                    ReturnCode       10                        MD054028
     C                   PARM      *ZERO         RecordLen         5 0                      MD054028
     C                   PARM                    FileName         10                        MD054028
     C                   PARM      '*LIBL     '  FileLib          10                        MD054028
                                                                                            MD054028
      ** If file not found (or any other error) shut down the program                       MD054028
     C     ReturnCode    Ifne      *Blanks                                                  MD054028
     C                   EXSR      *pssr                                                    MD054028
     C                   EndIf                                                              MD054028
                                                                                            MD054028
     C                   ENDSR                                                              MD054028
      *****************************************************************                     MD054028
      /EJECT                                                                                MD054028
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
     C                   PARM                    Accnt5001
     C                   PARM                    Accnt5002
     C                   PARM                    Accnt5003
     C                   PARM                    Accnt5004
     C                   PARM                    Accnt5005
     C                   PARM                    Accnt5006                                    CRE015
     C                   PARM                    StmpTax500                                   CER049
     C/COPY OFCPYSRCZ,CRE101_048                                                              CRE101
     C                   PARM                    InfData500                                 BUG10280
     C                   PARM                    RegData500                                   CER001
     C**********         PARM                    InfData500                                 BUG10280
     C                   PARM                    ExtData500
     C                   PARM                    RepeatData                                   CRE015
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN          1
     C**********         PARM                    Buffer         6000                        MD044880
     C**********         PARM                    Buffer2        3999                 CRE073 MD044880
     C                   PARM                    Buffer         9999                        MD044880
     C                   PARM                    APIRetc           1
     C                   PARM                    @TimeStamp       26                         BUG4196
     C                   PARM                    GLFullAcct       24                        MD026979
                                                                                            MD026979
     C/COPY WNCPYSRC,GLAMADVC02

      *                                                                                      LLN022A
      ** Access SAR details file to determine if LLN007                                      LLN022A
      ** Bank of England Yellow Book Changes is on.                                          LLN022A
      *                                                                                      LLN022A
     C                   MOVE      'N'           LLN007            1                         LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANKS       @RTCD                                       LLN022A
     C                   PARM      '*VERIFY'     @OPTN                                       LLN022A
     C                   PARM      'LLN007'      @SARD                                       LLN022A
     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
      *                                                                                      LLN022A
      ** Switchable Feature LLN007 is *ON                                                    LLN022A
      *                                                                                      LLN022A
     C                   IF        @RTCD = *Blanks                                           LLN022A
     C                   EVAL      LLN007 = 'Y'                                              LLN022A
     C                   OPEN      BYACCTY0                                                 MD051247
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'REUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'SDUSRMSG'                                  CRE073
     C/COPY WNCPYSRC,GLH00651

      * Hook to enable non-core message files to be included
     D/COPY WNCPYSRC,GLAMADM01
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   EVAL      MsgFArray (%LookUp(*Blanks:MsgFArray)) =                  LLN022A
     C                             'GBBYUSRMSG'                                              LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                              BG2557
      * Override SDAULGL0                                                                     BG2557
     C                   Z-ADD     50            CMDLEN           15 5                        BG2557
     C                   CALL      'QCMDEXC'                                                  BG2557
     C                   PARM                    CMD                                          BG2557
     C                   PARM                    CMDLEN                                       BG2557
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Access SAR details file to determine if CRE001 Overdraft
      ** interest calculations is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRE001'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRE001            1
     C                   ELSE
     C                   MOVEL     'N'           CRE001
     C                   END
      *
      ** Access SAR file to determine if S01383 is present.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01383'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************
     C                   Z-ADD     6             DBASE                          * DBERR 006 *
     C                   MOVEL     'S01383'      DBKEY                          *************
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   MOVEL     'N'           S01383            1
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01383
     C                   ENDIF
      *                                                                                       BG2557
      ** Access SAR details file to determine if CSD012 is on.                                BG2557
      *                                                                                       BG2557
     C                   CALLB     'AOSARDR0'                                                 BG2557
     C                   PARM      *BLANKS       @RTCD                                        BG2557
     C                   PARM      '*VERIFY'     @OPTN                                        BG2557
     C                   PARM      'CSD012'      @SARD                                        BG2557
     C     SCSARD        PARM      SCSARD        DSFDY                                        BG2557
      *                                                                                       BG2557
     C     @RTCD         IFEQ      *BLANK                                                     BG2557
     C                   MOVE      'Y'           CSD012                                       BG2557
     C                   ELSE                                                                 BG2557
     C                   MOVE      'N'           CSD012                                       BG2557
     C                   ENDIF                                                                BG2557
                                                                                              BG2557
      ** If CSD012 is ON, Check if Account Authorisation is ON                                BG2557
 B1  C     CSD012        IFEQ      'Y'                                                        BG2557
      *                                                                                       BG2557
     C                   CALL      'AOSVALR0'                                                 BG2557
     C                   PARM                    @RTCD                                        BG2557
     C                   PARM      SVALKK        SVALK1           20                          BG2557
     C                   PARM                    SVAL1           200                          BG2557
     C                   PARM                    SVALK2           20                          BG2557
     C                   PARM                    SVAL2           200                          BG2557
     C                   PARM                    SVALK3           20                          BG2557
     C                   PARM                    SVAL3           200                          BG2557
     C                   PARM                    SVALK4           20                          BG2557
     C                   PARM                    SVAL4           200                          BG2557
     C                   PARM                    SVALK5           20                          BG2557
     C                   PARM                    SVAL5           200                          BG2557
     C                   PARM                    SVALK6           20                          BG2557
     C                   PARM                    SVAL6           200                          BG2557
     C                   PARM                    SVALK7           20                          BG2557
     C                   PARM                    SVAL7           200                          BG2557
     C                   PARM                    SVALK8           20                          BG2557
     C                   PARM                    SVAL8           200                          BG2557
     C                   PARM                    SVALK9           20                          BG2557
     C                   PARM                    SVAL9           200                          BG2557
     C                   PARM                    SVALK0           20                          BG2557
     C                   PARM                    SVAL10          200                          BG2557
      *                                                                                       BG2557
     C     @RTCD         IFNE      *BLANKS                                                    BG2557
                                                                                              BG2557
     C     SVAL10        IFEQ      '*NRF'                                                     BG2557
     C                   MOVE      SVALK0        DBKEY                                        BG2557
     C                   ENDIF                                                                BG2557
     C     SVAL9         IFEQ      '*NRF'                                                     BG2557
     C                   MOVE      SVALK9        DBKEY                                        BG2557
     C                   ENDIF                                                                BG2557
     C     SVAL8         IFEQ      '*NRF'                                                     BG2557
     C                   MOVE      SVALK8        DBKEY                                        BG2557
     C                   ENDIF                                                                BG2557
     C     SVAL7         IFEQ      '*NRF'                                                     BG2557
     C                   MOVE      SVALK7        DBKEY                                        BG2557
     C                   ENDIF                                                                BG2557
     C     SVAL6         IFEQ      '*NRF'                                                     BG2557
     C                   MOVE      SVALK6        DBKEY                                        BG2557
     C                   ENDIF                                                                BG2557
     C     SVAL5         IFEQ      '*NRF'                                                     BG2557
     C                   MOVE      SVALK5        DBKEY                                        BG2557
     C                   ENDIF                                                                BG2557
     C     SVAL4         IFEQ      '*NRF'                                                     BG2557
     C                   MOVE      SVALK4        DBKEY                                        BG2557
     C                   ENDIF                                                                BG2557
     C     SVAL3         IFEQ      '*NRF'                                                     BG2557
     C                   MOVE      SVALK3        DBKEY                                        BG2557
     C                   ENDIF                                                                BG2557
     C     SVAL2         IFEQ      '*NRF'                                                     BG2557
     C                   MOVE      SVALK2        DBKEY                                        BG2557
     C                   ENDIF                                                                BG2557
     C     SVAL1         IFEQ      '*NRF'                                                     BG2557
     C                   MOVE      SVALK1        DBKEY                                        BG2557
     C                   ENDIF                                                                BG2557
                                                                                              BG2557
     C     *LOCK         IN        LDA                                                        BG2557
     C                   Z-ADD     13            DBASE                                        BG2557
     C                   MOVE      'SDSVALPD'    DBFILE                                       BG2557
     C                   MOVE      'GLAMADSIN'   DBPGM                                        BG2557
     C                   OUT       LDA                                                        BG2557
     C                   EXSR      *PSSR                                                      BG2557
     C                   ENDIF                                                                BG2557
      *                                                                                       BG2557
      ** If Account Authorisation is On set to Authorise                                      BG2557
     C     SVAL11        IFEQ      'Y'                                                        BG2557
     C                   MOVE      'Y'           AUTHRQ            1                          BG2557
     C                   ELSE                                                                 BG2557
     C                   MOVE      'N'           AUTHRQ                                       BG2557
     C                   ENDIF                                                                BG2557
      *                                                                                       BG2557
 E1  C                   ENDIF                                                                BG2557
      *
      ** Portfolio Management
      ** or Private Banking Module
     C                   MOVE      *OFF          *IN28
     C     BGPFMG        IFEQ      'Y'
     C     BGN4ST        OREQ      'Y'
     C                   OPEN      PMPORTLL
     C                   MOVE      *ON           *IN28
     C                   ENDIF

      *
      ** Access SAR details file to determine if CRT001 Retail
      ** Teller System is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRT001'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRT001            1
     C                   ELSE
     C                   MOVEL     'N'           CRT001
     C                   END

      *
      ** Access SAR details file to determine if CRT101 Password on
      ** Retail Teller account facilities is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRT101'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRT101            1
     C                   ELSE
     C                   MOVEL     'N'           CRT101
     C                   END
      *
      ** Access SAR details file to determine if CFT004 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFT004'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CFT004            1
     C                   ELSE
     C                   MOVEL     'N'           CFT004
     C                   END
      *
      ** Access SAR details file to determine if CDE002 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CDE002            1
     C                   ELSE
     C                   MOVEL     'N'           CDE002
     C                   END
      *
      ** Access SAR details file to determine if CEU013
      ** (EMU Account Postings Narrative) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CEU013'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU013            1
     C                   ELSE
     C                   MOVEL     'N'           CEU013
     C                   END
      *
      ** Access SAR details file to determine if CRT002
      ** (Retail Branch Access) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRT002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CRT002            1
     C                   ELSE
     C                   MOVEL     'N'           CRT002
     C                   END
      *
      * Access SAR details file to determine if CSC011 switchable feature
      * is switched on
      ** CSC011 is a redundant feature. No need to check                                    MD024398

     C**********         CALLB     'AOSARDR0'                                               MD024398
     C**********         PARM      *BLANKS       @RTCD                                      MD024398
     C**********         PARM      '*VERIFY'     @OPTN                                      MD024398
     C**********         PARM      'CSC011'      @SARD                                      MD024398
     C*****SCSARD        PARM      SCSARD        DSFDY                                      MD024398
      **********                                                                            MD024398
     C**********         IF        @RTCD = *Blanks                                          MD024398
      **********                                                                            MD024398
     C**********         EVAL      CSC011 = 'Y'                                             MD024398
      **********                                                                            MD024398
     C**********         IN        SC24X7                                                   MD024398
     C**********         IN        SDSTAT                                                   MD024398
      **********                                                                     240312 MD024398
     C**********         Else                                                        240312 MD024398
      ***Database*error************************************************              240312 MD024398
      **********                                                                     240312 MD024398
     C**********         If        @RTCD <> '*NRF'                                   240312 MD024398
     C******LOCK         In        LDA                                               240312 MD024398
     C**********         Eval      DBKEY = 'CSC011'                                  240312 MD024398
     C**********         Eval      DBFILE = 'SCSARDPD'                               240312 MD024398
     C**********         Eval      DBASE = 900                                       240312 MD024398
     C**********         Out       LDA                                               240312 MD024398
     C**********         ExSr      *PSSR                                             240312 MD024398
     C**********         EndIf                                                       240312 MD024398
      **********                                                                     240312 MD024398
     C**********         EndIf                                                       240312 MD024398
      *                                                                                       CER055
      * Access SAR details file to determine if CER055 switchable feature                     CER055
      * is switched on                                                                        CER055
                                                                                              CER055
     C                   CALLB     'AOSARDR0'                                                 CER055
     C                   PARM      *BLANKS       @RTCD                                        CER055
     C                   PARM      '*VERIFY'     @OPTN                                        CER055
     C                   PARM      'CER055'      @SARD                                        CER055
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER055
                                                                                              CER055
     C                   IF        @RTCD = *Blanks                                            CER055
     C                   EVAL      CER055 = 'Y'                                               CER055
     C                   ELSE                                                                 CER055
     C                   EVAL      CER055 = 'N'                                               CER055
      ** Database error                                                                       CER055
     C                   IF        @RTCD <> '*NRF'                                            CER055
     C     *LOCK         IN        LDA                                                        CER055
     C                   EVAL      DBKEY = 'CER055'                                           CER055
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER055
     C                   EVAL      DBASE = 904                                                CER055
     C                   OUT       LDA                                                        CER055
     C                   EXSR      *PSSR                                                      CER055
     C                   EndIf                                                                CER055
                                                                                              CER055
     C                   EndIf                                                                CER055

      ** If 24X7 Midas availability is installed and support system is
      ** active, used processing date from dataarea SC24X7 as the
      ** rundate.

     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
     C                   EVAL      WProcDate = S1DATE
     C                   ELSE
     C                   EVAL      WProcDate = BJRDNB
     C                   ENDIF

     C******             ELSE                                                                 240312
      ***Database error                                                                       240312
      ******                                                                                  240312
     C******             IF        @RTCD <> '*NRF'                                            240312
     C******LOCK         IN        LDA                                                        240312
     C******             EVAL      DBKEY = 'CSC011'                                           240312
     C******             EVAL      DBFILE = 'SCSARDPD'                                        240312
     C******             EVAL      DBASE = 900                                                240312
     C******             OUT       LDA                                                        240312
     C******             EXSR      *PSSR                                                      240312
     C******             ENDIF                                                                240312
      ******                                                                                  240312
     C******             ENDIF                                                                240312
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
      ** CSC022 is a mandatory feature already, so its always on                            MD024398
                                                                                            MD024398
     C**********         CALLB     'AOSARDR0'                                        CSC022 MD024398
     C**********         PARM      *BLANKS       @RTCD                               CSC022 MD024398
     C**********         PARM      '*VERIFY'     @OPTN                               CSC022 MD024398
     C**********         PARM      'CSC022'      @SARD                               CSC022 MD024398
     C*****SCSARD        PARM      SCSARD        DSFDY                               CSC022 MD024398
      **********                                                                     CSC022 MD024398
     C**********         IF        @RTCD = *Blanks                                   CSC022 MD024398
      **********                                                                     CSC022 MD024398
     C                   EVAL      CSC022 = 'Y'                                               CSC022
     C                   EVAL      WCMTSK = 'N'                                               CSC022
                                                                                              CSC022
     C                   IN        SCCMTJOB                                                   CSC022
                                                                                              CSC022
     C                   IF        COMITNUM > 0                                               CSC022
                                                                                              CSC022
     C                   MOVEA     WCMTJOBS      WCMT                                         CSC022
                                                                                              CSC022
     C                   IF        %LOOKUP(PSJOBNAME:WCMT) > 0                                CSC022
     C                   EVAL      WCMTSK = 'Y'                                               CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C**********         ELSE                                                        CSC022 MD024398
     C**********         IF        @RTCD <> '*NRF'                                   CSC022 MD024398
     C******LOCK         IN        LDA                                               CSC022 MD024398
     C**********         EVAL      DBKEY = 'CSC022'                                  CSC022 MD024398
     C**********         EVAL      DBFILE = 'SCSARDPD'                               CSC022 MD024398
     C**********         EVAL      DBASE = 901                                       CSC022 MD024398
     C**********         OUT       LDA                                               CSC022 MD024398
     C**********         EXSR      *PSSR                                             CSC022 MD024398
     C**********         ENDIF                                                       CSC022 MD024398
      **********                                                                     CSC022 MD024398
     C**********         ENDIF                                                       CSC022 MD024398
      *
      ** Access SAR details file to determine if CRE007 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CRE007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      * Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     7             DBASE
     C                   MOVEL     'CRE007'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVE      'Y'           CRE007            1
     C                   ELSE
     C                   MOVE      'N'           CRE007
     C                   END
      *                                                                                       CER001
      ** Access SAR details file to determine if ULX606 is on.                                CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX606'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
      ** Database Error                                                                       CER001
      *                                                                                       CER001
     C     @RTCD         IFNE      *BLANKS                                                    CER001
     C     @RTCD         ANDNE     '*NRF   '                                                  CER001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
     C                   Z-ADD     902           DBASE                                        CER001
     C                   MOVEL     'ULX606'      DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANK                                                     CER001
     C                   MOVE      'Y'           ULX606                                       CER001
     C                   ELSE                                                                 CER001
     C                   MOVE      'N'           ULX606                                       CER001
     C                   ENDIF                                                                CER001
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C                   CALLB     'AOGELRR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDGELR        PARM      SDGELR        DSSDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access Retail ICD for Commissions
      *
     C                   IF        BGNXST='Y' or BGNYST='Y'
     C     1             SETLL     TABTBRE
     C                   READ      TABTBRE                                80
     C     *IN80         IFEQ      *ON
     C     R_RECI        ORNE      'D'
     C                   MOVEL     'TABTBRE '    DBFILE                         ************
     C                   MOVEL     '101'         DBASE                          * DBERR 101*
     C                   EXSR      *PSSR                                        ************
     C                   ELSE
     C                   IF        R_CDTO='Y' or R_CHOV='Y' or R_FXAC='Y'
     C                             or R_CNDS='Y' or R_CDRI='Y'
     C                             or R_CMBL='Y' or R_CINA='Y'
     C                   EVAL      CommDisp='Y'
     C                   ELSE
     C                   EVAL      CommDisp='N'
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   EVAL      CommDisp='N'
     C                   ENDIF

      ** Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Access Dealing details via access program                                            CER001
      ** (database error handling done in access program)                                     CER001
      *                                                                                       CER001
     C                   CALLB     'AODEALR0'                                                 CER001
     C                   PARM      '*DBERR '     @RTCD                                        CER001
     C                   PARM      '*FIRST '     @OPTN                                        CER001
     C     SDDEAL        PARM      SDDEAL        DSFDY                                        CER001
      *                                                                                       CER001
      **  GET RUNDAT to access multi-branching indicator on.
      *
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   UNLOCK    RUNDAT
                                                                                              CAP086
      ** Access SAR details file to determine if                                              CAP086
      ** Automatic Authorisation is installed                                                 CAP086
                                                                                              CAP086
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
     C                   EVAL      DBPGM = 'GLAMADVU'                                         CAP086
     C                   EVAL      DBKEY = 'CAP086'                                           CAP086
     C                   EVAL      DBFILE ='SCSARDPD'                                         CAP086
     C                   EVAL      DBASE  = 1                                                 CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C     @RTCD         IFEQ      *BLANK                                                     CAP086
     C                   MOVEL     'Y'           CAP086                                       CAP086
     C                   ENDIF                                                                CAP086
      *                                                                                       CRE030
      ** Check if feature CRE030 is active                                                    CRE030
      *                                                                                       CRE030
     C                   CALL      'AOSARDR0'                                                 CRE030
     C                   PARM      '       '     @RTCD             7                          CRE030
     C                   PARM      '*VERIFY'     @OPTN             7                          CRE030
     C                   PARM      'CRE030'      @SARD             6                          CRE030
     C*                                                                                       CRE030
     C                   IF        @RTCD = *BLANKS                                            CRE030
     C                   MOVE      'Y'           CRE030            1                          CRE030
     C                   ELSE                                                                 CRE030
     C                   MOVE      'N'           CRE030                                       CRE030
     C                   ENDIF                                                                CRE030
                                                                                              CRE015
      ** Check if term and notice account feature is installed                                CRE015
                                                                                              CRE015
     C                   EVAL      CRE015 = 'N'                                               CRE015
     C                   CALL      'AOSARDR0'                                                 CRE015
     C                   PARM      *BLANKS       @RTCD                                        CRE015
     C                   PARM      '*VERIFY'     @OPTN                                        CRE015
     C                   PARM      'CRE015'      @SARD                                        CRE015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE015
                                                                                              CRE015
     C                   IF        @RTCD <> *BLANKS AND                                       CRE015
     C                             @RTCD <> '*NRF'                                            CRE015
     C     *LOCK         IN        LDA                                                        CRE015
     C                   EVAL      DBPGM = 'GLAMADVU'                                         CRE015
     C                   EVAL      DBKEY = 'CRE015'                                           CRE015
     C                   EVAL      DBFILE ='SCSARDPD'                                         CRE015
     C                   EVAL      DBASE  = 903                                               CRE015
     C                   OUT       LDA                                                        CRE015
     C                   EXSR      *PSSR                                                      CRE015
     C                   ENDIF                                                                CRE015
                                                                                              CRE015
     C                   IF        @RTCD = *BLANKS                                            CRE015
     C                   EVAL      CRE015 = 'Y'                                               CRE015
     C                   ENDIF                                                                CRE015
      *
      ** Access SAR details file to determine if CER048 is on.                              BUG22742
      *                                                                                     BUG22742
     C                   EVAL      CER048 = 'N'                                             BUG22742
      *                                                                                     BUG22742
     C                   CALL      'AOSARDR0'                                               BUG22742
     C                   PARM      *BLANKS       @RTCD                                      BUG22742
     C                   PARM      '*VERIFY'     @OPTN                                      BUG22742
     C                   PARM      'CER048'      @SARD                                      BUG22742
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG22742
      *                                                                                     BUG22742
     C                   IF        @RTCD <> *BLANKS AND                                     BUG22742
     C                             @RTCD <> '*NRF'                                          BUG22742
     C     *LOCK         IN        LDA                                                      BUG22742
     C                   EVAL      DBPGM = 'GLAMADVU'                                       BUG22742
     C                   EVAL      DBKEY = 'CER048'                                         BUG22742
     C                   EVAL      DBFILE ='SCSARDPD'                                       BUG22742
     C                   EVAL      DBASE = 903                                              BUG22742
     C                   OUT       LDA                                                      BUG22742
     C                   EXSR      *PSSR                                                    BUG22742
     C                   ENDIF                                                              BUG22742
      *                                                                                     BUG22742
     C     @RTCD         IFEQ      *BLANK                                                   BUG22742
     C                   MOVEL     'Y'           CER048                                     BUG22742
     C                   ENDIF                                                              BUG22742
      *                                                                                     BUG22742
      ** Check if retail account balance check feature is installed.                        MD028970
                                                                                            MD028970
     C                   EVAL      CRE010 = 'N'                                             MD028970
     C                   CALL      'AOSARDR0'                                               MD028970
     C                   PARM      *BLANKS       @RTCD                                      MD028970
     C                   PARM      '*VERIFY'     @OPTN                                      MD028970
     C                   PARM      'CRE010'      @SARD                                      MD028970
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD028970
                                                                                            MD028970
     C                   IF        @RTCD <> *BLANKS AND                                     MD028970
     C                             @RTCD <> '*NRF'                                          MD028970
     C     *LOCK         IN        LDA                                                      MD028970
     C                   EVAL      DBPGM = 'GLAMADVU'                                       MD028970
     C                   EVAL      DBKEY = 'CRE010'                                         MD028970
     C                   EVAL      DBFILE ='SCSARDPD'                                       MD028970
     C                   EVAL      DBASE  = 903                                             MD028970
     C                   OUT       LDA                                                      MD028970
     C                   EXSR      *PSSR                                                    MD028970
     C                   ENDIF                                                              MD028970
                                                                                            MD028970
     C                   IF        @RTCD = *BLANKS                                          MD028970
     C                   EVAL      CRE010 = 'Y'                                             MD028970
     C                   ENDIF                                                              MD028970
      *                                                                                     MD044546
      ** Check if CAP205 is installed.                                                      MD044546
      *                                                                                     MD044546
     C                   EVAL      CAP205 = 'N'                                             MD044546
     C                   CALL      'AOSARDR0'                                               MD044546
     C                   PARM      *BLANKS       @RTCD                                      MD044546
     C                   PARM      '*VERIFY'     @OPTN                                      MD044546
     C                   PARM      'CAP205'      @SARD                                      MD044546
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD044546
                                                                                            MD044546
     C                   IF        @RTCD <> *BLANKS AND                                     MD044546
     C                             @RTCD <> '*NRF'                                          MD044546
     C     *LOCK         IN        LDA                                                      MD044546
     C                   EVAL      DBPGM = 'GLAMADVU'                                       MD044546
     C                   EVAL      DBKEY = 'CAP205'                                         MD044546
     C                   EVAL      DBFILE ='SCSARDPD'                                       MD044546
     C                   EVAL      DBASE  = 905                                             MD044546
     C                   OUT       LDA                                                      MD044546
     C                   EXSR      *PSSR                                                    MD044546
     C                   ENDIF                                                              MD044546
                                                                                            MD044546
     C                   IF        @RTCD = *BLANKS                                          MD044546
     C                   EVAL      CAP205 = 'Y'                                             MD044546
     C                   ENDIF                                                              MD044546
      *                                                                                     MD044546
      ** Check if CER050 is ON                                                              MD054028
      *                                                                                     MD054028
     C                   CALLB     'AOSARDR0'                                               MD054028
     C                   PARM      *BLANKS       @RTCD                                      MD054028
     C                   PARM      '*VERIFY'     @OPTN                                      MD054028
     C                   PARM      'CER050'      @SARD                                      MD054028
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD054028
                                                                                            MD054028
     C     @RTCD         IFEQ      *BLANK                                                   MD054028
     C                   EVAL      CER050 = 'Y'                                             MD054028
     C                   ELSE                                                               MD054028
     C                   EVAL      CER050 = 'N'                                             MD054028
     C                   ENDIF                                                              MD054028
      *                                                                                     MD054028
     C/COPY OFCPYSRCZ,CRE101_009                                                              CRE101
     C/COPY WNCPYSRC,GLH00652
      **  Define key list to access ACCPTFR
     C     PTFRK         KLIST
     C                   KFLD                    WWPTFR            4
     C**********         KFLD                    WWCNUM            6 0                        CSD027
     C                   KFLD                    WWCNUM            6                          CSD027
     C                   KFLD                    WWCCY             3
     C                   KFLD                    WWACOD           10 0
     C                   KFLD                    WWACSQ            2 0
     C*
     C** Key list to access full account details from ACCNTLXX
     C*
     C     WWACKA        KLIST
     C                   KFLD                    WWBRCA
     C                   KFLD                    WWCNUM
     C                   KFLD                    WWCCY
     C                   KFLD                    WWACOD
     C                   KFLD                    WWACSQ
      *                                                                                       BUG553
     C     ACODK         KLIST                                                                BUG553
     C                   KFLD                    WWACOK           10 0                        BUG553
     C                   KFLD                    WWRECI            1                          BUG553
      *                                                                                       CRE030
     C     ACODK2        KLIST                                                                CRE030
     C                   KFLD                    WWACOK                                       CRE030
     C                   KFLD                    WWRECI                                       CRE030
     C                   KFLD                    WWACCY            3                          CRE030
      *                                                                                       BUG553
     C     WWACKB        KLIST                                                                BUG553
     C                   KFLD                    WWBRCK            3                          BUG553
     C**********         KFLD                    WWCUSK            6 0                 BUG553 CSD027
     C                   KFLD                    WWCUSK            6                          CSD027
     C                   KFLD                    WWCCYK            3                          BUG553
     C                   KFLD                    WWACOK           10 0                        BUG553
     C                   KFLD                    WWACSK            2 0                        BUG553
      *                                                                                       BUG553
     C     WWACK2        KLIST                                                                BUG553
     C                   KFLD                    WWCUSK                                       BUG553
     C                   KFLD                    WWCCYK                                       BUG553
     C                   KFLD                    WWACOK                                       BUG553
     C                   KFLD                    WWACSK                                       BUG553
     C                   KFLD                    WWBRCK                                       BUG553

     C                   ENDSR
      *****************************************************************
