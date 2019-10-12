     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/deposits interface controller')         *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMLDNICTL - Loans/Deposits Interface Controller              *
      *                                                               *
      *  Function: This Program Validates MM Deals for Input into     *
      *            the Midas database.                                *
      *            Processes executed controlled by input Action Code *
      *            - For I (=Insert)                                  *
      *              - If ALL of the settlement fields are blank, set *
      *                them up from standard settlement instructions  *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the deal fields                       *
      *              - Validate the settlement fields                 *
      *            - For A (=Amend) if it is valid, call a separate   *
      *              function to check whether it is a valid amendment*
      *            - For X (=Authorise) call a separate function to   *
      *              process this deal and bypass the rest of the     *
      *              validation                                       *
      *            - For D (=Delete) call a separate function to      *
      *              process this deal and bypass the rest of the     *
      *              validation                                       *
      *            For all action codes, the decision to as to        *
      *            whether to write to the Valid or Invalid file and  *
      *            the call to the Message Handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD054028           Date 05Sep19               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 AR701789           Date 26Sep16               *
      *                 CGL165             Date 23Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CSD095             Date 08Apr14               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 260027             Date 29Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247888             Date 18May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242553             Date 19Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027A            Date 09May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7285R           Date 02Aug05               *
      *                 CDL033             Date 10Feb05               *
      *                 BUG7285            Date 07Jun05               *
      *                 BUG7221            Date 18May05               *
      *                 BUG7220            Date 18May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CMM105             Date 22Jun04               *
      *                 CGL014             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 221989             Date 01Sep03               *
      *                 CGL029             Date 01Sep03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 222727             Date 05Nov03               *
      *                 217076             Date 23Jun03               *
      *                 CAS005             Date 16Dec02               *
      *                 CRE008             Date 19Feb02               *
      *                 CDL010             Date 02Aug02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209905             Date 25Sep02               *
      *                 196380             Date 15May02               *
      *                 196461             Date 22Apr02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      *                 CSC011             Date 18Sep01               *
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 200400             Date 20Nov01               *
      *                 165903             Date 18Apr01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CPB002             Date 08Aug00               *
      *                 185751             Date 17Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 179510             Date 07Nov00               *
      *                 166888             Date 08Sep99               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 174855             Date 23Feb00               *
      * Midas DBA 3.02 Patch Z ---------------------------------------*
      *                 176883             Date 24Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CGL011             Date 17Feb00               *
      *                 CSE006             Date 14Feb00               *
      *                 CAP033             Date 26Apr99               *
      *                 CAP051             DATE 10Nov99               *
      *                 CDL007             DATE 05Oct99               *
      *                 CPB001             Date 02Sep99               *
      *                 CAP013             Date 07Sep99               *
      *                 CAP011             Date 07Sep99               *
      *                 170909             Date 07Sep99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 154477             Date 29Jan99               *
      *                 148855             Date 26Nov98               *
      *                 CAP004             Date 07Sep98               *
      *                 CAP003             Date 30Jul98               *
      *                 CAP002  *CREATE    Date 06OCT97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054028 - Encountered issues in MQ Testing due to XML not   *
      *             being updated                                     *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR701789 - Unable to reject a deal amendment. Add a new      *
      *             parameter to indicate reject transaction.         *
      *             Applied for MD041482                              *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  CSD095 - Allow Deal Sub-Type and Branch for MM and FX SSIs   *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  260027 - Bypass IKAUT1 as it is causing Decimal Data Error   *
      *           in IKRRAT (Reference Rate)                          *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247888 - Missing record in CLE025 files.                     *
      *  242553 - Do a MOVEL instead of a MOVE to stop data being     *
      *           corrupted.                                          *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG7285R - Reopen fix. Pay/Rec instructions are being read   *
      *             from the wrong field positions on MMDELDPP format.*
      *  CDL033 - Floating Rate CDs Issued                            *
      *  BUG7285 - Recompiled over corrected MMVFIDTPD.               *
      *  BUG7221- Fix the mapping problem regarding LDNI workfile.    *
      *  BUG7220- Recompile due to changes in MMILDNIPD.              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CMM105 - Core changes for GBO005                             *
      *         - Fixed Deposits Held Under Lien                      *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:MMLDNICC01,MMLDNIC020,MMLDNICC14 *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  221989 - Call Access Objects for Fiduciary Dealing           *
      *           Transactions                                        *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposit       *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Automatic Rollover of Fixed Term Loan/Deposit       *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  217076 - Condition call to SDPORTPD on PM indicator.         *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  CRE008 - Cash Management  Added parameters to ZASETINVAL     *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.Recompile due to changes in MMVLDNIPD*
      *  CAS004 - Hedge Accounting Phase A                            *
      *  209905 - Fiduciary API Enhancement                           *
      *  196380 - Added parameter to MMLDNIRTV call.                  *
      *  196461 - Additional parameter ##PREC and ##PPAY in ZASETINVAL*
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAP067 - Repurchase Agreements API.                          *
      *  200400 - Reverse fix 179510                                  *
      *  165903 -  Receive ccy should also allow default (just like   *
      *            the back office input MMLDNISIN).                  *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *  185751 - Pass the action code as a parameter to ZASETINVAL,  *
      *           to be used in the validation.                       *
      *  179510 - Added  @MORPI  parameter at call to  ZASETINVAL     *
      *  166888 - Settlement Instructions - Pay Ordering Bank returns *
      *           to defaulted value all the time. Apply GEMS 163745  *
      *           However, 163745 only fixes the problem for 'A' and  *
      *           'X' processing. Problem still exists for insert.    *
      *           Need to default only the 1st time validation is     *
      *           done. Do not re-default for subsequent validations. *
      *           Due to this 163745 in its original form is no       *
      *           longer required, now default required only for      *
      *           'first time insert'.                                *
      *  174855 - Parameters MsgFarray and ClrPgmMsgQ were missing    *
      *           when calling ZAMSGHNDLE.                            *
      *  176883 - Errors found as a result of creating DBAR3.02       *
      *           Meridian repository file.                           *
      *           Recompiled due to mismatch between parameter calls  *
      *           to ZASETINDFT.                                      *
      *  CGL011 - Collateral Processing for Midas - new parameter     *
      *           on CALLB to MMLDNICVT.                              *
      *  CSE006 - Addition of Repos flag parameter to MMLDNIVAL call. *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs. Increased length of Transaction        *
      *           Reference ID from 6A to 20A.                        *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *  CDL007 - Deposit Breakdown Penalty                           *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in MMDELDPP               *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CAP011 - Substitution of Midas database flds for externl i/fs*
      *  170909 - Settlement instructions not updated on amendment    *
      *  154477 - Recompile for change to MMVLDNIPD.                  *
      *  148855 - Correct handling of the QMHRDQM API, by accessing   *
      *           it through the ZACHNDQMS module, which is included  *
      *           in the DTAQCHK* /COPYs.                             *
      *  CAP004 - API's Phase 3.                                      *
      *           Add extra parm for Extra Data                       *
      *  CAP003 - Conversion of Midas inputs to modular API structure *
      *           Phase 2.  Module recompiled over changed /COPY      *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FMMVLDNIPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FMMILDNIPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FAPIDSETPD UF A E             DISK    INFSR(*pssr)
     F                                     COMMIT
 
     FMMVLDNIL0 IF   E           K DISK    RENAME(MMVLDNID0:MMVLDNICHK)
     F                                     INFSR(*pssr)                         CAP013
     FMMVLDNIL1 IF   E           K DISK    RENAME(MMVLDNID0:MMVLDNICK1)         CAP013
     F                                     INFSR(*pssr)                         CAP013
 
     FMMWLDNIL0 UF A E           K DISK    INFSR(*PSSR) PREFIX(WJ)                            209905
     F                                     COMMIT                                             209905
                                                                                              209905
     FMMWFIDTL0 UF A E           K DISK    INFSR(*PSSR)                                       209905
     F                                     COMMIT                                             209905
                                                                                              209905
     FMMTFIDTL0 UF A E           K DISK    INFSR(*PSSR) PREFIX(JW)                            209905
     F                                     RENAME(MMVFIDTD0:TMPVFIDTD0)                       209905
     F                                     COMMIT                                             209905
                                                                                              209905
     FMMIFIDTL0 UF A E           K DISK    INFSR(*PSSR) PREFIX(RF)                            209905
     F                                     COMMIT                                             209905
                                                                                              209905
     FMMVFIDTL0 UF A E           K DISK    INFSR(*PSSR) PREFIX(JF)                            209905
     F                                     COMMIT                                             209905
                                                                                              209905
     FDLVFRSCPD UF A E             DISK    INFSR(*pssr)                                       CDL033
     F                                     COMMIT                                             CDL033
                                                                                              CDL033
     FDLIFRSCPD UF A E             DISK    INFSR(*pssr)                                       CDL033
     F                                     COMMIT                                             CDL033
                                                                                              CDL033
      ** FX/MM/FRA/IRS Extension files                                                        247888
     FDLDEALL5  UF A E           K DISK    PREFIX(DX_)                                        247888
     F                                     INFSR(*pssr)                                       247888
     F                                     COMMIT                                             247888
                                                                                              247888
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,MMLDNIC019
     FMMVLDLX1PDUF A E             DISK    USROPN                                             CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
                                                                                              CER001
     FMMILDLX1PDUF A E             DISK    USROPN                                             CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
 
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
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
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
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for fields           148855
      ** used in checking whether there are messages on the data queue.         148855
     D/COPY ZACPYSRC,DTAQCHKDCL                                                 148855
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
 
      ** String for error messages to the operator
     D ProcErr         C                   CONST('Error in module')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D***WFIDTARR        S             42A   DIM(99)                                   209905 CGL029
     D WFIDTARR        S             48A   DIM(99)                                            CGL029
                                                                                              209905
     D RChgArr         S              6A   DIM(82)                                            CDL033
     D PChgArr         S              6A   DIM(82)                                            CDL033
                                                                                              CDL033
      * Incoming Header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
     D WMSGTYPE                1      6                                                       209905
 
     D TranIn        E DS                  EXTNAME(MMLDNIPD)
      * Incoming Transaction
 
     D ValidDeal     E DS                  EXTNAME(MMVLDNIPD)
      * Valid Deals layout
     D***LDNIRecIns            456    524                                                     CGL029
     D***LDNIPayIns            525   1083                                                     CGL029
     D LDNIRecIns            470    524                                                       CGL029
     D LDNIPayIns            539   1083                                                       CGL029
     D***LDNIRecInsEx         1731   1748                                            CGL029 BUG7285R
     D***LDNIPayInsEx         1749   1766                                            CGL029 BUG7285R
     D LDNIRecInsEx         1756   1773                                                     BUG7285R
     D LDNIPayInsEx         1774   1791                                                     BUG7285R
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)
 
     D DealFilFmt    E DS                  EXTNAME(MMDELDPP)
     D QQDOR1        E                     EXTFLD(QQDORI)                                     CGL029
     D QQMOR1        E                     EXTFLD(QQMORI)                                     CGL029
     D QQDOP1        E                     EXTFLD(QQDOPI)                                     CGL029
     D QQMOP1        E                     EXTFLD(QQMOPI)                                     CGL029
     D QQRON1        E                     EXTFLD(QQRONS)                                     CGL029
     D QQPON1        E                     EXTFLD(QQPONS)                                     CGL029
     D QQINS1        E                     EXTFLD(QQINSA)                                     CGL029
     D DealFil1                1   1900                                                       260027
     D DealFil2             1901   1907                                                       260027
      * (Current) Deal in File Format
     D***DELDRecIns            456    524                                                     CGL029
     D***DELDPayIns            525   1083                                                     CGL029
     D DELDRecIns            470    524                                                       CGL029
     D DELDPayIns            539   1083                                                       CGL029
     D***DELDRecInsEx         1741   1758                                            CGL029 BUG7285R
     D***DELDPayInsEx         1759   1776                                            CGL029 BUG7285R
     D DELDRecInsEx         1756   1773                                                     BUG7285R
     D DELDPayInsEx         1774   1791                                                     BUG7285R
      * Large fields to include
      * - Receive instructions (xxRSTM to xxROCN)
      * - Pay     instructions (xxPSTM to xxBTB6)
 
     D DealScnFmt    E DS                  EXTNAME(MMLDNIPD)
     D                                     PREFIX(@)
      * (Current) Deal in Screen Format
 
     D InPaySttmt    E DS                  EXTNAME(SDESSPPD)
      * Pay Settlement Instructions - Input
 
     D InRecSttmt    E DS                  EXTNAME(SDESSRPD)
      * Receive Settlement Instructions - Input
 
     D InFRASttmt    E DS                  EXTNAME(SDESSFPD)
      * FRA/IRS Settlement Instructions - Input
 
     D CrPaySttmt    E DS                  EXTNAME(SDESSPPD) PREFIX(@)          CAP011
      * Pay Settlement Instructions - Current                                   CAP011
                                                                                CAP011
     D CrRecSttmt    E DS                  EXTNAME(SDESSRPD) PREFIX(@)          CAP011
      * Receive Settlement Instructions - Current                               CAP011
                                                                                CAP011
     D CrFRASttmt    E DS                  EXTNAME(SDESSFPD) PREFIX(@)          CAP011
      * FRA/IRS Settlement Instructions - Current                               CAP011
                                                                                CAP011
     D DBPaySttmt    E DS                  EXTNAME(SDESFPPD)
      * Pay Settlement Instructions - File (D/B) format
     D ESFPayIns              21    565                                                       CGL029
 
     D DBRecSttmt    E DS                  EXTNAME(SDESFRPD)
      * Receive Settlement Instructions - File (D/B) format
     D ESFRecIns              21     75                                                       CGL029
 
     D DBFRASttmt    E DS                  EXTNAME(SDESFFPD)
      * FRA/IRS Settlement Instructions - File (D/B) format
                                                                                CDL007
     D InfData       E DS                  EXTNAME(MMLDIFPD)                    CDL007
      * MM Extra Data - Classe 1 Data - File (D/B) format                       CDL007
     D                                     PREFIX(IF_)                          CDL007
                                                                                CAP004
     D ExtData       E DS                  EXTNAME(MMLDEXPD)                    CAP004
      * MM Extra Data - File (D/B) format                                       CAP004
     D RegData       E DS                  EXTNAME(MMLDRXPD)                                  CER001
                                                                                              209905
     D TMPFIDTDATA   E DS                  EXTNAME(MMTFIDTPD)                                 209905
     D                                     PREFIX(JW)                                         209905
      ** Fiduciary Takings Temporary File                                                     209905
                                                                                              209905
     D VALFIDTDATA   E DS                  EXTNAME(MMVFIDTPD)                                 209905
     D                                     PREFIX(JF)                                         209905
      ** Fiduciary Takings Valid File                                                         209905
                                                                                              209905
     D INVFIDTDATA   E DS                  EXTNAME(MMIFIDTPD)                                 209905
     D                                     PREFIX(RF)                                         209905
      ** Fiduciary Takings Invalid File                                                       209905
     D FIDTINVDTL              1   3936                                                       209905
                                                                                              209905
     D WRKLDNIDATA   E DS                  EXTNAME(MMWLDNIPD)                                 209905
     D                                     PREFIX(WJ)                                         209905
     D*** WRKLDNI              1    314                                               209905 BUG7221
     D WRKLDNI1                1    248                                                      BUG7221
     D WRKQQINSA             249    263                                                      BUG7221
     D WRKLDNI2              264    314                                                      BUG7221
     D WRKLDNI3              356    368                                                      BUG7221
     D WRKDDINSA             369    389                                                      BUG7221
     D WRKLDNI4              390    431                                                      BUG7221
     D WRKLDNI5              432    459                                                       CDL033
     D WRKLDNI6              460    951                                                       CDL033
     D WRKLDNI7              952   1443                                                       CDL033
                                                                                              209905
     D WRKFIDT       E DS                  EXTNAME(MMFIDTPD)                                  209905
     D WRKFIDT1                1    462                                                       209905
     D WRKFIDT2              463    924                                                       209905
     D WRKFIDT3              925   1386                                                       209905
     D WRKFIDT4             1387   1848                                                       209905
     D WRKFIDT5             1849   2310                                                       209905
     D WRKFIDT6             2311   2772                                                       209905
     D WRKFIDT7             2773   3234                                                       209905
     D WRKFIDT8             3235   3696                                                       209905
     D WRKFIDT9             3697   3936                                                       209905
                                                                                CDL007
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CDL007
      ** External DS for SAR details                                            CDL007
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  209905
      ** External DS for Customer Details                                                     209905
                                                                                              209905
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  209905
      ** External DS for Midas Modules                                                        209905
                                                                                              209905
     D SDPORT        E DS                  EXTNAME(SDPORTPD)                                  209905
      ** External DS for Portfolio Management ICD                                             209905
                                                                                              209905
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  209905
      ** External DS for Portfolio Management ICD                                             209905
                                                                                              209905
     D DSLDY         E DS                  EXTNAME(DSLDY)                                     209905
                                                                                              209905
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     209905
                                                                                              209905
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * First DS for Access programs - short data structure
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
      ** External DS for API ICD                                                CAP011
 
     D IntRatChgD1   E DS                  EXTNAME(DLFRSCPF)                                  CDL033
     D                                     PREFIX(RC1)                                        CDL033
     D IntRatChgD2   E DS                  EXTNAME(DLFRSCPF)                                  CDL033
     D                                     PREFIX(RC2)                                        CDL033
                                                                                              CDL033
     D IntPayChgD1   E DS                  EXTNAME(DLFRSCPF)                                  CDL033
     D                                     PREFIX(PC1)                                        CDL033
     D IntPayChgD2   E DS                  EXTNAME(DLFRSCPF)                                  CDL033
     D                                     PREFIX(PC2)                                        CDL033
                                                                                              CDL033
     D DLrFRHOds1    E DS                  EXTNAME(DLFRHOPD)                                  CDL033
     D                                     PREFIX(R1)                                         CDL033
     D DLrFRHOds2    E DS                  EXTNAME(DLFRHOPD)                                  CDL033
     D                                     PREFIX(R2)                                         CDL033
     D DLpFRHOds1    E DS                  EXTNAME(DLFRHOPD)                                  CDL033
     D                                     PREFIX(P1)                                         CDL033
     D DLpFRHOds2    E DS                  EXTNAME(DLFRHOPD)                                  CDL033
     D                                     PREFIX(P2)                                         CDL033
                                                                                              CDL033
     D*DtqRec**********DS            54                                         148855
     ******DS*for*Data*Queue****************************************************148855
     D**MsgNumber******        8     11B 0                                      148855
     D*DtqMsgSel*******DS             7                                         148855
     D**MsgType********        1      1    INZ('F')                             148855
     D**MsgBytes*******        4      7B 0                                      148855
 
     D MMLDNIUPC       DS             1    DTAARA(MMLDNIUPC)
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status dataarea                                                                 CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
                                                                                              CSC011
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WCMTJOBS               4    103A                                                      CSC022
      ** Commitment Control dataarea                                                          CSC022
                                                                                              CSC022
      ** Array to hold commitment jobs name                                                   CSC022
     D WCMT            S             10A   DIM(10)                                            CSC022
                                                                                              CSC022
     D ZMUSER          DS            17                                                       209905
     D  ZMBRCA                11     13                                                       209905
     D  ZMDEPT                14     16                                                       209905
                                                                                              209905
     D***WFIDTDTL        DS            42                                              209905 CGL029
     D WFIDTDTL        DS            48                                                       CGL029
     D  SFDLNO                 1      6                                                       209905
     D  SFCNUM                 7     16                                                       209905
     D  SFPTFR                17     20                                                       209905
     D  SFAMNT                21     35                                                       209905
     D***SFACOD*               36     39                                               209905 CGL029
     D***SFACSQ*               40     41                                               209905 CGL029
     D***SFTRAS*               42     42                                               209905 CGL029
     D  SFACOD                36     45                                                       CGL029
     D  SFACSQ                46     47                                                       CGL029
     D  SFTRAS                48     48                                                       CGL029
                                                                                              209905
     D***VFIDTDTL        DS            42                                              209905 CGL029
     D VFIDTDTL        DS            48                                                       CGL029
     D  VSFDLNO                1      6                                                       209905
     D  VSFCNUM                7     16                                                       209905
     D  VSFPTFR               17     20                                                       209905
     D  VSFAMNT               21     35                                                       209905
     D***VSFACOD               36     39                                               209905 CGL029
     D***VSFACSQ               40     41                                               209905 CGL029
     D***VSFTRAS               42     42                                               209905 CGL029
     D  VSFACOD               36     45                                                       CGL029
     D  VSFACSQ               46     47                                                       CGL029
     D  VSFTRAS               48     48                                                       CGL029
                                                                                              209905
     D WFIDTNAR        DS                                                                     209905
     D  WSFNAR1                1     60                                                       209905
     D  WSFNAR2               61    120                                                       209905
     D  WSFNAR3              121    180                                                       209905
     D  WSFNAR4              181    240                                                       209905
                                                                                              209905
     D/COPY WNCPYSRC,MMLDNICD01
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)
     D     MsgID1      S                   LIKE(#MsgID)                                       209905
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Field (500A) to receive the incoming transaction
     D***Trans500        S            500A                                                   CSF011A
     D Trans500        S           1000A                                                     CSF011A
     D TransB500       S            500A                                                      209905
     D TransC500       S            500A                                                      209905
     D TransD500       S            500A                                                      209905
     D TransE500       S            500A                                                      209905
     D TransF500       S            500A                                                      209905
     D TransG500       S            500A                                                      209905
     D TransH500       S            500A                                                      209905
     D TransI500       S            500A                                                      209905
                                                                                CDL007
      ** Field (500A) to receive the incoming Extra Data                        CDL007
     D InfData500      S            500A                                        CDL007
                                                                                CAP004
      ** Field (500A) to receive the incoming Extra Data                        CAP004
     D ExtData500      S            500A                                        CAP004
     D RegData500      S            500A                                                      CER001
     D RegDatawk       S            500A                                                      CER001
     D ULX600          S              1A                                                      CER001
     D SRER91          S              1A                                                      CER001
 
      ** Index for arrays of error message ids etc in Amend validation
     D AmIdx           S              3P 0
 
      ** Indicies for arrays used to set up corresponding sequence numbers
      **  for the fields that are in error
     D Ix              S              3P 0
     D Iy              S              3P 0
 
      ** Flags to indicate whether transaction fields are valid
     D OKFlagsDS       DS
     D  DDActnOK                      1A   INZ('Y')
     D  DDDlnoOK                      1A   INZ('Y')
     D  DDTypeOK                      1A   INZ('Y')
     D  DDStypOK                      1A   INZ('Y')
     D  DDFedFOK                      1A   INZ('Y')
     D  DDDADNOK                      1A   INZ('Y')
     D  DDDlDtOK                      1A   INZ('Y')
     D  DDBrCAOK                      1A   INZ('Y')
     D  DDBokCOK                      1A   INZ('Y')
     D  DDLnkNOK                      1A   INZ('Y')
     D  DDBkCdOK                      1A   INZ('Y')
     D  DDBrkgOK                      1A   INZ('Y')
     D  DDRaCDOK                      1A   INZ('Y')
     D  DDCustOK                      1A   INZ('Y')
     D  DDVDatOK                      1A   INZ('Y')
     D  DDMDatOK                      1A   INZ('Y')
     D  DDNtceOK                      1A   INZ('Y')
     D  DDAcSqOK                      1A   INZ('Y')
     D  DDCcyOK                       1A   INZ('Y')
     D  DDAmnpOK                      1A   INZ('Y')
     D  DDBRatOK                      1A   INZ('Y')
     D  DDDRIDOK                      1A   INZ('Y')
     D  DDDDMROK                      1A   INZ('Y')
     D  DDBsRCOK                      1A   INZ('Y')
     D  DDSpRtOK                      1A   INZ('Y')
     D  DDICMtOK                      1A   INZ('Y')
     D**DDNgvIOK**********************1A   INZ('Y')                                           CDL016
     D  DDROLIOK                      1A   INZ('Y')                                           CDL016
     D  DDIPFqOK                      1A   INZ('Y')
     D  DDNDatOK                      1A   INZ('Y')
     D  DDTotIOK                      1A   INZ('Y')
     D  DDIPDMOK                      1A   INZ('Y')
     D  DDCptIOK                      1A   INZ('Y')
     D  DDMTaxOK                      1A   INZ('Y')
     D  DDFUIDOK                      1A   INZ('Y')
     D  DDFLIdOK                      1A   INZ('Y')
     D  DDRDFCOK                      1A   INZ('Y')
     D  DDCDRfOK                      1A   INZ('Y')
     D  DDCDCHOK                      1A   INZ('Y')
     D  DDPrfCOK                      1A   INZ('Y')
     D  DDOrBrOK                      1A   INZ('Y')
     D  DDPtfROK                      1A   INZ('Y')
     D  DDAuRoOK                      1A   INZ('Y')
     D  DDCnNaOK                      1A   INZ('Y')
     D  DDRoFqOK                      1A   INZ('Y')
     D  DDRlDNOK                      1A   INZ('Y')
     D  DDIPdSOK                      1A   INZ('Y')
     D  DDIMetOK                      1A   INZ('Y')
     D  DDIScyOK                      1A   INZ('Y')
     D  DDInSAOK                      1A   INZ('Y')
     D  DDINosOK                      1A   INZ('Y')
     D  DDIi72OK                      1A   INZ('Y')
     D  DDFsrpOK                      1A   INZ('Y')
     D  DDFsgnOK                      1A   INZ('Y')
     D  DDFprcOK                      1A   INZ('Y')
     D  DDPenaOK                      1A   INZ('Y')                                           CAS001
     D  DDTrnTpOK                     1A   INZ('Y')                                           CAS001
     D  DDOylcOK                      1A   INZ('Y')                                           CAS001
     D  DDLQPROK                      1A   INZ('Y')                                           CAS005
     D  DDLQPSOK                      1A   INZ('Y')                                           CAS005
     D  DDClasOK                      1A   INZ('Y')                                           CDL038
                                                                                              CAS005
     D  DDRcDtOK                      1A   INZ('Y')                                           CDL033
     D  DDRcfROk                      1A   INZ('Y')                                           CDL033
     D  DDRcDmOk                      1A   INZ('Y')                                           CDL033
     D  DDStRtOk                      1A   INZ('Y')                                           CDL033
     D  DDFxDmOk                      1A   INZ('Y')                                           CDL033
     D  DDFYldOk                      1A   INZ('Y')                                           CDL033
                                                                                              CDL033
      ** Currencies for Payment Convention                                                    CDL096
     D  OKC1PC                        1A   INZ('Y')                                           CDL096
     D  OKC2PC                        1A   INZ('Y')                                           CDL096
     D  OKC3PC                        1A   INZ('Y')                                           CDL096
     D  OKC4PC                        1A   INZ('Y')                                           CDL096
     D  OKC5PC                        1A   INZ('Y')                                           CDL096
     D  OKC6PC                        1A   INZ('Y')                                           CDL096
     D  OKC7PC                        1A   INZ('Y')                                           CDL096
     D  OKC8PC                        1A   INZ('Y')                                           CDL096
     D  OKC9PC                        1A   INZ('Y')                                           CDL096
     D  OKC0PC                        1A   INZ('Y')                                           CDL096
                                                                                              CDL096
      ** Payment Date and Amount Convention                                                   CDL096
     D  OKPDC                         1A   INZ('Y')                                           CDL096
     D  OKAMC                         1A   INZ('Y')                                           CDL096
                                                                                              CDL096
      ** Flags to indicate whether transaction fields are valid                               CDL016
     D OKFlagsDS2      DS                                                                     CDL016
     D  DDSOFDOK                      1A   INZ('Y')                                           CDL016
     D  DDFBRTOK                      1A   INZ('Y')                                           CDL019
     D  DDAIROK                       1A   INZ('Y')                                           CDL020
 
      ** Flag(s) to indicate if combinations of transaction fields are valid
     D  DDDltStpOK                    1A   INZ('Y')
 
      ** Flags to indicate whether Pay Settlement instruction fields
      **  are valid
     D OKPayInsDS      DS
     D  DDPscyOK                      1A   INZ('Y')
     D  DDPstmOK                      1A   INZ('Y')
     D  DDPonxOK                      1A   INZ('Y')
     D  DDRvnoOK                      1A   INZ('Y')
     D  DDCvmrOK                      1A   INZ('Y')
     D  DDPocnOK                      1A   INZ('Y')
     D  DDPobnOK                      1A   INZ('Y')
     D  DDRcrnOK                      1A   INZ('Y')
     D  DDRcraOK                      1A   INZ('Y')
     D  DDPibnOK                      1A   INZ('Y')
     D  DDPibaOK                      1A   INZ('Y')
     D  DDAwbnOK                      1A   INZ('Y')
     D  DDAwbaOK                      1A   INZ('Y')
     D  DDBennOK                      1A   INZ('Y')
     D  DDBenaOK                      1A   INZ('Y')
     D  DDDtp1OK                      1A   INZ('Y')
     D  DDDtp2OK                      1A   INZ('Y')
     D  DDDtp3OK                      1A   INZ('Y')
     D  DDDtp4OK                      1A   INZ('Y')
     D  DDDchgOK                      1A   INZ('Y')
     D  DDIc72OK                      1A   INZ('Y')
     D  DDBtb1OK                      1A   INZ('Y')
     D  DDBtb2OK                      1A   INZ('Y')
     D  DDBtb3OK                      1A   INZ('Y')
     D  DDBtb4OK                      1A   INZ('Y')
     D  DDBtb5OK                      1A   INZ('Y')
     D  DDBtb6OK                      1A   INZ('Y')
 
      ** Flags to indicate whether Receive Settlement instruction fields
      **  are valid
     D OKRecInsDS      DS
     D  DDRscyOK                      1A   INZ('Y')
     D  DDRstmOK                      1A   INZ('Y')
     D  DDRonxOK                      1A   INZ('Y')
     D  DDRocnOK                      1A   INZ('Y')
     D  DDRobnOK                      1A   INZ('Y')
     D  DDRibnOK                      1A   INZ('Y')
     D  DDRibaOK                      1A   INZ('Y')
 
      ** Flags to indicate whether FRA/IRS instruction fields are valid
     D OKFRAInsDS      DS
     D  DDDsr1OK                      1A   INZ('Y')
     D  DDDsr2OK                      1A   INZ('Y')
     D  DDDsr3OK                      1A   INZ('Y')
     D  DDDsr4OK                      1A   INZ('Y')
     D  DDDsr5OK                      1A   INZ('Y')
     D  DDDsr6OK                      1A   INZ('Y')
     D  DDSsr1OK                      1A   INZ('Y')
     D  DDSsr2OK                      1A   INZ('Y')
     D  DDSsr3OK                      1A   INZ('Y')
     D  DDSsr4OK                      1A   INZ('Y')
     D  DDSsr5OK                      1A   INZ('Y')
     D  DDSsr6OK                      1A   INZ('Y')
     D  DDCnd1OK                      1A   INZ('Y')
     D  DDCnd2OK                      1A   INZ('Y')
     D  DDCnd3OK                      1A   INZ('Y')
     D  DDCnd4OK                      1A   INZ('Y')
     D  DDCnd5OK                      1A   INZ('Y')
     D  DDCnd6OK                      1A   INZ('Y')
     D  DDIsdaOK                      1A   INZ('Y')
     D  DDAgtyOK                      1A   INZ('Y')
     D  DDAgdtOK                      1A   INZ('Y')
     D  DDAgvvOK                      1A   INZ('Y')
 
      ** Flag to indicate outcome of call to lower level module
     D AmendOK         S              1A   INZ('Y')
 
      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A
                                                                                174855
      ** Whether or not to clear the program message queue                      174855
     D ClrPgmMsgQ      S              1A                                        174855
 
      ** Module ID, to be passed to the Message Handler
     D ModuleID        S              2A
 
      ** A code to indicate the calling function to the lower level modules
     D LDNI            S              4A   INZ('LDNI')
 
      ** Payment & Receipt dates, passed to Settlements Validation routine.
      ** spaces in parameter list not used by this function
     D PayDat          S              5P 0 INZ(99999)
     D RecDat          S              5P 0 INZ(99999)
 
      ** Value Date as a Midas Day Number to be placed in either Payment
      **  or Receipt Date
     D ValDateMDN      S              5P 0
 
      ** Blank fields, passed to Settlements Defaulting routine, to fill
      ** spaces in parameter list not used by this function
     D Blank2          S              2A   INZ(*BLANKS)
     D Blank3          S              3A   INZ(*BLANKS)
     D Blank4          S              4A   INZ(*BLANKS)
     D Blank6          S              6A   INZ(*BLANKS)
 
      ** Error Flag for call to Standard routines (equates to *IN99)
     D ErrorFlag       S              1A   INZ('N')
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z
 
      ** Receive / Pay Settlement Currency, Method & Nostro
     D RecSetCcy       S              3A
     D RecSetMeth      S              2S 0
     D***RecNostro       S             12A                                                    CGL029
     D RecNostro       S             18A                                                      CGL029
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D***PayNostro       S             12A                                                    CGL029
     D PayNostro       S             18A                                                      CGL029
 
     ****Data*queue*parms*******************************************************148855
     D*DtqLenB*********S              9B 0                                      148855
     D*DtqFmt**********S              8A                                        148855
     D*DtqNamLib*******S             20A                                        148855
     D*DtqMsgLen*******S              9B 0 INZ(8)                               148855
     D*DtqComp*********S              9B 0 INZ(939524096)                       148855
     D*DtqMsgFmt*******S              8A                                        148855
     D*DtqErr**********S             50A                                        148855
 
     D Object          S             10A   INZ('MMLDNIUPC')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A
     D LockState       S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('0     ')
     D Dlcobj          S              1A   INZ('Y')
     D Return          S              7A
     D OLD_MATD        S              5P 0                                      CDL007
     D IntRate         S              1A                                                      CDL033
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
     D CSC011          S              1A   INZ('N')                                           CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D***PDealNo         S             18A                                             CSC011 CGL029
     D***PADealNo        S             18A                                             CSC011 CGL029
     D PDealNo         S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
                                                                                              CSC011
     D WFIDTDTA        S           4158A                                                      209905
     D WFIDTDTA1       S           3696A                                                      209905
     D WFIDTDTA2       S            462A                                                      209905
     D WMAINFOID       S             20A                                                      209905
     D WMAINAFID       S             20A                                                      209905
     D WFIDT1FO        S             20A                                                      209905
     D WFIDT2FO        S             20A                                                      209905
     D WFITRFO         S             20A                                                      209905
     D MSGDATA         S             45A                                                      209905
     D OKFIDTDTL       S              1A                                                      209905
     D NNDCSP          S              1A                                                      209905
     D***CDL006*         S              1A   IMPORT                                    209905 221989
     D CDL006          S              1A                                                      221989
     D S01468          S              1A                                                      209905
     D A               S              3S 0                                                    209905
     D B               S              5S 0                                                    209905
     D CTR             S              3S 0                                                    209905
     D PACOF           S              2A                                                      209905
     D PBOOK           S              2A                                                      209905
     D PBRAN           S              3A                                                      209905
     D PCUST           S              6A                                                      209905
     D PDDMDAT         S              6A                                                      209905
     D PDDNTCE         S              3A                                                      209905
     D PDEPT1          S              3A                                                      209905
     D PKEY1           S             10A                                                      209905
     D PKYST           S              7A                                                      209905
     D PPRFC           S              4A                                                      209905
     D PSUTP           S              1A                                                      209905
     D PTOTI           S             14A                                                      209905
     D PTRTP           S              5A                                                      209905
     D PCCY            S              3A                                                      209905
     D PUSER           S             10A                                                      209905
     D PCYDP           S              1S 0                                                    209905
     D PNTCE           S              3S 0                                                    209905
     D PNXTDEAL        S              6P 0                                                    209905
     D WTAmount        S             15S 0                                                    209905
     D WAmount         S             15S 0                                                    209905
     D ZDECS           S              1P 0                                                    209905
     D ZADEC           S              1P 0                                                    209905
     D ZADIG           S              2P 0                                                    209905
     D ZALIGNOK        S              1A                                                      209905
     D ZECODE          S              1A                                                      209905
     D ZOUT21          S             21A                                                      209905
     D ZFIELD          S             16A                                                      209905
     D ZFLD15          S             15P 0                                                    209905
                                                                                              209905
     D DatesIn         S           3600                                                       CDL033
     D FLDNAMARRL      S             10A   DIM(75)                                            CDL033
     D OKLNRATCAL      S            600A                                                      CDL033
     D Paction         S              1A                                                      CDL033
     D PControlDate    S              5P 0                                                    CDL033
     D Pcurrency       S              3A                                                      CDL033
     D PmaturityDate   S              5P 0                                                    CDL033
     D PvalueDate      S              5P 0                                                    CDL033
     D PPrevDate       S              5P 0                                                    CDL033
     D PDateIn         S              6A                                                      CDL033
     D PDayNoOut       S              5P 0                                                    CDL033
     D PErrorFlg       S              1A                                                      CDL033
     D PValDateOut     S           1800A                                                      CDL033
     D RValDateOut     S           1800A                                                      CDL033
     D SRate           S             11P 7                                                    CDL033
     D CDL033          S              1A                                                      CDL033
     D PCONF           S              1A                                                      CDL033
                                                                                              CDL033
      ** Fields for enhancement CSC022                                                        CSC022
     D CSC022          S              1A   INZ('N')                                           CSC022
     D WCmtSk          S              1A                                                      CSC022
                                                                                              CSC022
     D #TRCCY          S              3A                                                     CSF011A
     D #TPCCY          S              3A                                                     CSF011A
                                                                                             CSF011A
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,MMLDNIC020
                                                                                              CER001
     D/COPY QWINDSRC,MMLDNISDTA                                                               CER001
     D DATALUX         DS          1024                                                       CER001
     D  #1FLD2                 1      6  0                                                    CER001
                                                                                              CER001
     D  #1DN38                 1      6                                                       CER001
     D  #1DLTP                 7      8                                                       CER001
     D  #1CNUM                 9     14                                                       CER001
     D  #1CCY                 15     17                                                       CER001
     D  #1AMNT                18     32  0                                                    CER001
     D  #1VDAT                33     38                                                       CER001
     D  #1MDAT                39     44                                                       CER001
     D  #1FOTR                45     64                                                       CER001
     D  #1TMST                65     90Z                                                      CER001
                                                                                              CER001
      ** Valid Extended Deal in File Format                                                   CER001
     D ValidFilExt   E DS                  EXTNAME(MMVLDLX1PD)                                CER001
                                                                                              CER001
      ** Errors Indicators Extended Fields                                                    CER001
     D OkFlagsExt    E DS                  EXTNAME(MMELDLX1PD)                                CER001
      *                                                                                       CER001
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,MMLDNIC001
                                                                                              209905
     C                   IF        CDL006 = 'Y'                                               209905
                                                                                              209905
      ** Save message to its corresponding work file when message is not                      209905
      ** a trailer, otherwise retrieve saved messages and continue normal                     209905
      ** processing                                                                           209905
                                                                                              209905
     C                   SELECT                                                               209905
                                                                                              209905
     C                   WHEN      WMSGTYPE = 'MMFIDT'                                        209905
                                                                                              209905
     C                   EVAL      WSFOTRANID = APFOTRANID                                    209905
     C                   EVAL      WSFOASOCID = APFOASOCID                                    209905
     C                   EVAL      WSRPRLOCN = APRPRLOCN                                      209905
     C                   MOVEL     Trans500      WRKFIDT1                                     209905
     C                   MOVEL     TransB500     WRKFIDT2                                     209905
     C                   MOVEL     TransC500     WRKFIDT3                                     209905
     C                   MOVEL     TransD500     WRKFIDT4                                     209905
     C                   MOVEL     TransE500     WRKFIDT5                                     209905
     C                   MOVEL     TransF500     WRKFIDT6                                     209905
     C                   MOVEL     TransG500     WRKFIDT7                                     209905
     C                   MOVEL     TransH500     WRKFIDT8                                     209905
     C                   MOVEL     TransI500     WRKFIDT9                                     209905
     C                   WRITE     MMWFIDTD0                                                  209905
                                                                                              209905
     C                   WHEN      WMSGTYPE = 'MMLDNI'                                        209905
     C                   EVAL      WJWSFOTRANID = APFOTRANID                                  209905
     C                   EVAL      WJWSFOASOCID = APFOASOCID                                  209905
     C                   EVAL      WJWSRPRLOCN = APRPRLOCN                                    209905
     C**********         MOVEL     Trans500      WRKLDNI                              209905 BUG7221
     C     248           SUBST     Trans500:1    WRKLDNI1                                    BUG7221
     C                   MOVE      *BLANKS       WRKQQINSA                                   BUG7221
     C     51            SUBST     Trans500:270  WRKLDNI2                                    BUG7221
     C     13            SUBST     Trans500:321  WRKLDNI3                                    BUG7221
     C     21            SUBST     Trans500:249  WRKDDINSA                                   BUG7221
     C     42            SUBST     Trans500:334  WRKLDNI4                                    BUG7221
     C                   EVAL      RegDatawk = RegData500                                     CER001
     C     CDL033        IFEQ      'Y'                                                        CDL033
     C     28            SUBST     Trans500:376  WRKLDNI5                                     CDL033
     C                   MOVEL     TransB500     WJWRCHGD1                                    CDL033
     C                   MOVEL     TransC500     WJWRCHGD2                                    CDL033
     C                   MOVEL     TransD500     WJWPCHGD1                                    CDL033
     C                   MOVEL     TransE500     WJWPCHGD2                                    CDL033
      ** TransF500 contains the 1st and 2nd sets of Rte Chg Holiday inds.                     CDL033
     C     82            SUBST     TransF500:1   WJWRCHGDHO1                                  CDL033
     C     82            SUBST     TransF500:83  WJWRCHGDHO2                                  CDL033
      ** TransG500 contains the 1st and 2nd sets of Pay Chg Holiday inds.                     CDL033
     C     82            SUBST     TransG500:1   WJWPCHGDHO1                                  CDL033
     C     82            SUBST     TransG500:83  WJWPCHGDHO2                                  CDL033
     C                   ENDIF                                                                CDL033
     C                   WRITE     MMWLDNID0                                                  209905
                                                                                              209905
     C                   ENDSL                                                                209905
                                                                                              209905
      ** Only process transaction record once the trailer arrives                             209905
                                                                                              209905
     C                   IF        WMSGTYPE <> 'MMFITR'                                       209905
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   COMMIT                                                               209905
     C                   ENDIF                                                                CSC022
     C                   RETURN                                                               209905
     C                   ELSE                                                                 209905
     C                   EVAL      WFITRFO = APFOTRANID                                       209905
     C                   ENDIF                                                                209905
                                                                                              209905
      ** Retrieve transaction message then load it onto receiving parameter                   209905
      ** data structure                                                                       209905
                                                                                              209905
     C     APFOASOCID    CHAIN     MMWLDNIL0                                                  209905
                                                                                              209905
     C                   IF        %FOUND(MMWLDNIL0)                                          209905
     C                   CLEAR                   Trans500                                     209905
     C**********         MOVEL     WRKLDNI       Trans500                             209905 BUG7221
     C                   EVAL      %SUBST(Trans500:1:248)=WRKLDNI1                           BUG7221
     C                   EVAL      %SUBST(Trans500:270:51)=WRKLDNI2                          BUG7221
     C                   EVAL      %SUBST(Trans500:321:13)=WRKLDNI3                          BUG7221
     C                   EVAL      %SUBST(Trans500:249:21)=WRKDDINSA                         BUG7221
     C                   EVAL      %SUBST(Trans500:334:42)=WRKLDNI4                          BUG7221
     C                   IF        CDL033 = 'Y'                                               CDL033
     C                   EVAL      %SUBST(Trans500:376:28)=WRKLDNI5                           CDL033
     C                   MOVEL     WJWRCHGD1     TransB500                                    CDL033
     C                   MOVEL     WJWRCHGD2     TransC500                                    CDL033
     C                   MOVEL     WJWPCHGD1     TransD500                                    CDL033
     C                   MOVEL     WJWPCHGD2     TransE500                                    CDL033
     C                   EVAL      %SUBST(TransF500:1:82)=WJWRCHGDHO1                         CDL033
     C                   EVAL      %SUBST(TransF500:83:82)=WJWRCHGDHO2                        CDL033
     C                   EVAL      %SUBST(TransG500:1:82)=WJWPCHGDHO1                         CDL033
     C                   EVAL      %SUBST(TransG500:83:82)=WJWPCHGDHO2                        CDL033
     C                   ENDIF                                                                CDL033
     C                   ENDIF                                                                209905
                                                                                              209905
      ** Override Front Office and Associated Front Office Id                                 209905
                                                                                              209905
     C                   EVAL      APFOTRANID =  *BLANKS                                      209905
     C                   EVAL      APFOTRANID =  WJWSFOTRANID                                 209905
     C                   EVAL      APFOASOCID =  *BLANKS                                      209905
     C                   EVAL      APFOASOCID =  WJWSFOASOCID                                 209905
                                                                                              209905
      ** Load work file records to respective arrays                                          209905
                                                                                              209905
     C                   EXSR      SRLOADARR                                                  209905
                                                                                              209905
     C                   ENDIF                                                                209905
 
      * Incoming transaction is in a 500A field, so that a common CLP
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break that 500A by loading it into the
      * appropriate (externally described) data structure.
     C                   MOVEL     Trans500      TranIn
     C                   MOVEL     Infdata500    Infdata                        CDL007
     C                   MOVEL     Extdata500    Extdata                        CAP004
     C                   EVAL      RegData = RegData500                                       CER001
     C                   EVAL      RegData = RegDatawk                                        CER001
                                                                                              CDL033
     C                   IF        CDL033 = 'Y'                                               CDL033
     C                   MOVEL     TransB500     IntRatChgD1                                  CDL033
     C                   MOVEL     TransC500     IntRatChgD2                                  CDL033
     C                   MOVEL     TransD500     IntPayChgD1                                  CDL033
     C                   MOVEL     TransE500     IntPayChgD2                                  CDL033
     C     82            SUBST     TransF500:1   DLrFRHOds1                                   CDL033
     C     82            SUBST     TransF500:83  DLrFRHOds2                                   CDL033
     C     82            SUBST     TransG500:1   DLpFRHOds1                                   CDL033
     C     82            SUBST     TransG500:83  DLpFRHOds2                                   CDL033
     C                   ENDIF                                                                CDL033
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
 
      * Reset variables gradually updated
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,MMLDNIC002
 
      *  Check if valid deal exists for Front Office ID
 
     C                   EXSR      ChkValDeal
      *
      *  If valid deal does exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
                                                                                CAP013
      *  Check if valid deal exists for Midas Deal Number                       CAP013
                                                                                CAP013
     C                   EXSR      ChkValMiDl                                   CAP013
      *                                                                         CAP013
      *  If valid deal does exist (even after delay), fail this input           CAP013
      *                                                                         CAP013
     C     Idx           IFNE      0                                            CAP013
     C                   GOTO      INVALID                                      CAP013
     C                   END                                                    CAP013
 
      * Reset variables again in case the details have been corrupted
      * by previous chain to valid deals file.
 
     C                   EXSR      RESETCYCLE
 
      /COPY WNCPYSRC,MMLDNIC003
 
      *  Validate Action Code
 
     C                   EXSR      ValidateAc
 
      /COPY WNCPYSRC,MMLDNIC004
 
      *  If error in validation of action code, fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      *  Processing depends upon Action Code
 
     C                   SELECT
 
     C                   WHEN      DDACTN = 'I'
      *  Processing for Inserts
      /COPY WNCPYSRC,MMLDNIC005
     C                   EXSR      DftSettmts
      /COPY WNCPYSRC,MMLDNIC006
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,MMLDNIC007
     C                   EXSR      ValidateSt
                                                                                              209905
     C                   IF        (CDL006 = 'Y') AND (Idx = 0)                               209905
     C                   EXSR      VALIDATEFD                                                 209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   IF        (CDL033 = 'Y')                                             CDL033
     C                             AND (Idx = *ZERO)                                          CDL033
     C                   EXSR      VALIDATERC                                                 CDL033
     C                   EXSR      VALIDATEPC                                                 CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
      /COPY WNCPYSRC,MMLDNIC008
 
     C                   WHEN      DDACTN = 'A'
      *  Processing for Amends
      /COPY WNCPYSRC,MMLDNIC009
     C     GHSUBS        ifne      *blank                                       CAP011
     C     GHSUBS        scan      TranIn                                 99    CAP011
     C     *in99         ifeq      *on                                          CAP011
     C                   EXSR      TDtDtaSubs                                   CAP011
     C                   endif                                                  CAP011
     C                   endif                                                  CAP011
     C                   EXSR      SetupAmend
      /COPY WNCPYSRC,MMLDNIC010
     C                   EXSR      ValidateTr
      /COPY WNCPYSRC,MMLDNIC011
     C                   EXSR      ValidateSt
      /COPY WNCPYSRC,MMLDNIC012
     C                   EXSR      ValdateAmd
     C                   IF        (CDL033='Y') AND (Idx=0)                                   CDL033
     C                   EXSR      VALIDATERC                                                 CDL033
     C                   EXSR      VALIDATEPC                                                 CDL033
     C                   ENDIF                                                                CDL033
      /COPY WNCPYSRC,MMLDNIC013
 
     C                   ENDSL
      *
     C     INVALID       TAG
 
      *  Check for exception error from any program lower in the stack
      *  If error detected, send message to system operator and
      *  return to calling program without updating database or
      *  prompting the database update program
     C                   IN        APDUMP
 
      /COPY WNCPYSRC,MMLDNIC014
 
     C     ARERRMOD      IFNE      *BLANK
     C                   EVAL      MQErrlong  = *blank
     C                   MOVEL     ProcErr       MQError
     C                   MOVE      ARERRMOD      MQError          28
     C                   MOVEL     MQError       MQErrlong
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MQReturn         10
     C                   PARM                    MQErrlong       132
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
     C                   MOVEL     ARERRMOD      APRETCODE
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARERRMOD = *BLANK
     C                   OUT       APDUMP
     C                   RETURN
 
     C                   ELSE
 
      *  Processing for Error checking/write to database
      /COPY WNCPYSRC,MMLDNIC015
      *                                                                                       CER001
      ** ULX600 - API Luxembourg - Function MMLDNI                                            CER001
      *                                                                                       CER001
     C     ULX600        IFEQ      'Y'                                                        CER001
     C     DDACTN        IFEQ      'I'                                                        CER001
      *                                                                                       CER001
     C                   MOVE      *ALL'Y'       OkFlagsExt                                   CER001
      *                                                                                       CER001
      ** Validate the extension transaction details                                           CER001
      *                                                                                       CER001
     C                   MOVE      DDTYPE        #1DLTP                                       CER001
     C*****HKCNUM********IFNE      0                                                  CER001 CSD027A
     C     HKCNUM        IFNE      *BLANKS                                                   CSD027A
     C                   MOVE      HKCNUM        #1CNUM                                       CER001
     C                   ELSE                                                                 CER001
     C                   MOVE      IKCNUM        #1CNUM                                       CER001
     C                   ENDIF                                                                CER001
     C                   MOVE      DDCCY         #1CCY                                        CER001
     C     HKAMNP        IFNE      0                                                          CER001
     C                   Z-ADD     HKAMNP        #1AMNT                                       CER001
     C                   ELSE                                                                 CER001
     C                   Z-ADD     IKAMNP        #1AMNT                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   CALLB     'MMLDNI2VL'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM                    Regdata                                      CER001
     C                   PARM                    OkFlagsExt                                   CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIdArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIdArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    ValidFilExt                                  CER001
     C                   PARM      'N'           SRER91                                       CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** No Errors, write in valid file                                                       CER001
      *                                                                                       CER001
     C     Idx           IFEQ      0                                                          CER001
      *                                                                                       CER001
     C     DDACTN        IFEQ      'I'                                                        CER001
     C                   EXSR      SETUPDEALN                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   EVAL      #6LXVLDN38 = IKDN38                                        CER001
     C                   EVAL      #6LXVLFOTR = APFOTranID                                    CER001
     C                   EVAL      #6LXVLSUBR = L6LXSUBR                                      CER001
     C                   EVAL      #6LXVLMOBL = L6LXMOBL                                      CER001
     C                   MOVE      L6LXRISC      #6LXVLRISC                                   CER001
     C                   MOVE      L6LXIMEX      #6LXVLIMEX                                   CER001
     C                   MOVE      L6LXPPSC      #6LXVLPPSC                                   CER001
     C                   MOVE      L6LXCOAM      #6LXVLCOAM                                   CER001
     C                   MOVE      L6LXIM93      #6LXVLIM93                                   CER001
     C                   MOVE      L6LXCLAT      #6LXVLCLAT                                   CER001
     C                   EVAL      #6LXVL1UAC = 0                                             CER001
     C                   MOVE      L6LXLUSU      #6LXVLLUSU                                   CER001
     C                   EVAL      #6LXVLLURA = 0                                             CER001
     C                   EVAL      #6LXVLTMES = TimeStamp                                     CER001
     C     DDACTN        IFNE      'I'                                                        CER001
     C                   EVAL      #6LXVLRISC = 0                                             CER001
     C                   EVAL      #6LXVLIMEX = 0                                             CER001
     C                   EVAL      #6LXVLPPSC = 0                                             CER001
     C                   EVAL      #6LXVLCOAM = 0                                             CER001
     C                   EVAL      #6LXVLIM93 = 0                                             CER001
     C                   EVAL      #6LXVLCLAT = 0                                             CER001
     C                   EVAL      #6LXVL1UAC = 0                                             CER001
     C                   EVAL      #6LXVLLUSU = 0                                             CER001
     C                   EVAL      #6LXVLLURA = 0                                             CER001
     C                   ENDIF                                                                CER001
     C                   WRITE     MMVLDLXD6                                                  CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Errors, write in invalid file                                                        CER001
      ** Only write to invalid files if repair in back office                                 CER001
      *                                                                                       CER001
     C     Idx           IFGT      0                                                          CER001
     C     APRprLocn     ANDEQ     'B'                                                        CER001
      *                                                                                       CER001
     C                   EVAL      #6LXFOTR = APFOTranID                                      CER001
     C                   EVAL      #6LXSUBR = L6LXSUBR                                        CER001
     C                   EVAL      #6LXMOBL = L6LXMOBL                                        CER001
     C                   MOVE      L6LXRISC      #6LXRISC                                     CER001
     C                   MOVE      L6LXIMEX      #6LXIMEX                                     CER001
     C                   MOVE      L6LXPPSC      #6LXPPSC                                     CER001
     C                   MOVE      L6LXCOAM      #6LXCOAM                                     CER001
     C                   MOVE      L6LXIM93      #6LXIM93                                     CER001
     C                   MOVE      L6LXCLAT      #6LXCLAT                                     CER001
     C                   MOVE      L6LXGUAC      #6LXGUAC                                     CER001
     C                   MOVE      L6LXLUSU      #6LXLUSU                                     CER001
     C                   EVAL      #6LXTIME = TimeStamp                                       CER001
     C                   WRITE     MMILDLXD6                                                  CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   EXSR      CheckWrite
      /COPY WNCPYSRC,MMLDNIC016
 
      *  If valid, send data queue entry to prompt DB update program
     C     Idx           IFEQ      0
     C                   EVAL      ObjType = '*DTAARA'
 
      *  Check if update program active using Allocate Object API
      *  No prompting necessary if program is running
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockState
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM      *BLANK        Return
     C     Return        IFEQ      *BLANK
      *  Check if any messages are already on the data queue
      *  No need to send duplicate prompt messages
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes a check for whether there            148855
      ** are messages on the server/updater data queue, and sends a 'GO'.       148855
      ** message to the data queue if there are not.                            148855
     D/COPY ZACPYSRC,DTAQCHK                                                    148855
      **--------------------------------------------------------------------------------------------
 
     C*******************EVAL      DtqLenB = 54                                 148855
     C*******************EVAL      DtqNamLib = 'APLDNIDTQ *LIBL'                148855
     C*******************EVAL      MsgBytes = 8                                 148855
     C*******************CALL      'QMHRDQM'                                    148855
     C*******************PARM                    DtqRec                         148855
     C*******************PARM                    DtqLenB                        148855
     C*******************PARM      'RDQM0100'    DtqFmt                         148855
     C*******************PARM                    DtqNamLib                      148855
     C*******************PARM                    DtqMsgSel                      148855
     C*******************PARM                    DtqMsgLen                      148855
     C*******************PARM      'RDQS0100'    DtqMsgFmt                      148855
     C*******************PARM                    DtqErr                         148855
      *******************                                                       148855
     C*****MsgNumber*****IFEQ      DtqComp                                      148855
     C*******************CALL      'QSNDDTAQ'                                   148855
     C*******************PARM      'APLDNIDTQ'   DtqNam           10            148855
     C*******************PARM      '*LIBL'       DtqLib           10            148855
     C*******************PARM                    DtqLen            5 0          148855
     C*******************PARM      'GO'          DtqDta           10            148855
     C*******************ENDIF                                                  148855
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,MMLDNIC021
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValDeal - Routine to check if valid deal exists for        *
      *    Front Office ID                                            *
      *                                                               *
      *****************************************************************
 
     C     ChkValDeal    BEGSR
 
      * Check for deal on Valid file
     C     APFOTranID    CHAIN     MMVLDNIL0                          99
 
      * If record found...
     C     *IN99         IFEQ      '0'
 
      * ..delay, then repeat check
     C                   CALLB     'ZACDELAY'
 
     C     APFOTranID    CHAIN     MMVLDNIL0                          99
 
      * Error if still present
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
 
     C                   ENDIF
                                                                                CAP013
      * Check for associated deal on Valid file                                 CAP013
     C     APFOAsocID    IFNE      *BLANK                                       CAP013
                                                                                CAP013
     C     APFOAsocID    CHAIN     MMVLDNIL0                          99        CAP013
                                                                                CAP013
      * If record found...                                                      CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
                                                                                CAP013
      * ..delay, then repeat check                                              CAP013
     C                   CALLB     'ZACDELAY'                                   CAP013
                                                                                CAP013
     C     APFOAsocID    CHAIN     MMVLDNIL0                          99        CAP013
                                                                                CAP013
      * Error if still present                                                  CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
     C                   ADD       1             Idx                            CAP013
     C                   EVAL      FldNameArr(Idx) = 'DDDADN'                   CAP013
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'                    CAP013
     C                   ENDIF                                                  CAP013
                                                                                CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CAP013
      *****************************************************************         CAP013
      *                                                               *         CAP013
      * ChkValMiDl - Routine to check if valid deal exists for        *         CAP013
      *    Midas Deal Number                                          *         CAP013
      *                                                               *         CAP013
      *****************************************************************         CAP013
                                                                                CAP013
     C     ChkValMiDl    BEGSR                                                  CAP013
                                                                                CAP013
      * If (numeric) Midas deal number supplied                                 CAP013
                                                                                CAP013
     C                   TESTN                   DDDLNO               9898      CAP013
                                                                                CAP013
     C     DDDLNO        IFNE      *BLANKS                                      CAP013
     C     *IN98         ANDEQ     '1'                                          CAP013
                                                                                CAP013
      * Check for deal on Valid file                                            CAP013
     C                   MOVEL     DDDLNO        IKDN38                         CAP013
     C     IKDN38        CHAIN     MMVLDNIL1                          99        CAP013
                                                                                CAP013
      * If record found...                                                      CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
                                                                                CAP013
      * ..delay, then repeat check                                              CAP013
     C                   CALLB     'ZACDELAY'                                   CAP013
                                                                                CAP013
     C     IKDN38        CHAIN     MMVLDNIL1                          99        CAP013
                                                                                CAP013
      * Error if still present                                                  CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
     C                   ADD       1             Idx                            CAP013
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'                   CAP013
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'                    CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
                                                                                CAP013
     C                   ENDIF                                                  CAP013
                                                                                CAP013
      * If (numeric) Midas associated deal number supplied                      CAP013
                                                                                CAP013
     C                   TESTN                   DDDADN               9898      CAP013
                                                                                CAP013
     C     DDDADN        IFNE      *BLANK                                       CAP013
     C     *IN98         ANDEQ     '1'                                          CAP013
                                                                                CAP013
      * Check for associated deal on Valid file                                 CAP013
     C                   MOVEL     DDDADN        IKDN38                         CAP013
     C     IKDN38        CHAIN     MMVLDNIL1                          99        CAP013
                                                                                CAP013
      * If record found...                                                      CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
                                                                                CAP013
      * ..delay, then repeat check                                              CAP013
     C                   CALLB     'ZACDELAY'                                   CAP013
                                                                                CAP013
     C     IKDN38        CHAIN     MMVLDNIL1                          99        CAP013
                                                                                CAP013
      * Error if still present                                                  CAP013
     C     *IN99         IFEQ      '0'                                          CAP013
     C                   ADD       1             Idx                            CAP013
     C                   EVAL      FldNameArr(Idx) = 'DDDADN'                   CAP013
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'                    CAP013
     C                   ENDIF                                                  CAP013
                                                                                CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
      *                                                                         CAP013
     C                   ENDSR                                                  CAP013
      *****************************************************************         CAP013
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *    transaction IDs supplied                                   *
      *                                                               *
      *****************************************************************
 
     C     ValidateAc    BEGSR
      *                                                                         CAP013
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
      *  if insert                                                              CAP013
      *  if not insert and Midas transaction ID is not present                  CAP013
      * Otherwise                                                               CAP013
      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
      *                                                                         CAP013
     C     DDACTN        IFEQ      'I'                                          CAP013
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
     C                   ELSE                                                   CAP013
     C     DDDLNO        IFEQ      *BLANK                                       CAP013
     C                   MOVEL     '*FRONT'      ModeofOp                       CAP013
     C                   ELSE                                                   CAP013
     C                   MOVEL     '      '      ModeofOp                       CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
 
      * Validate action code versus transaction IDs supplied
      * This function will set the Midas deal number and the Midas
      * associated deal number.
      * The deal in file format from the MM database is retrieved as well.
 
     C                   RESET                   ReturnCode
     C                   CALLB     'MMLDNIRTV'
 
      * INPUTS
 
      * Return code
     C                   PARM                    ReturnCode
 
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP013
     C*******************PARM      '*FRONT'      ModeofOp          6            CAP013
     C                   PARM                    ModeofOp          6            CAP013
      *
      * Response mode
     C                   PARM                    APRESPMODE
 
      * Action Code
     C                   PARM                    DDACTN
 
      * Front Office Transaction ID
     C                   PARM                    APFOTranID
 
      * Front Office Associated Transaction Id
     C                   PARM                    APFOAsocID
 
      * (Midas) Deal Number
     C                   PARM                    DDDLNO
 
      * (Midas) Depot Movement Reference                                                      196380
     C                   PARM                    DDDDMR                                       196380
      *                                                                                       196380
      * (Midas) Associated Deal Number
     C                   PARM                    DDDADN
 
      * Booking branch
     C                   PARM                    DDBRCA
                                                                                              CAP067
      * REPO Flag                                                                             CAP067
     C                   PARM      'N'           RepoFlag          1                          CAP067
 
      * OUTPUTS
 
      * (Current) deal in file format
     C                   PARM                    DealFilFmt
     C/COPY WNCPYSRC,MMLDNICC09
 
      *                                                                                     AR701789
     C                   PARM                    ACTRJ             1                        AR701789
      * OK - Action code
     C                   PARM                    DDActnOK
 
      * OK - Deal Number
     C                   PARM                    DDDlnoOK
 
      * OK - Booking branch
     C                   PARM                    DDBrcaOK
                                                                                              CDL016
      * Blocked/Unblock Action                                                                CDL016
     C                   PARM                    BUACT             1                          CDL016
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
 
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
                                                                                              CAS004
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CAS004
                                                                                              CAS004
     C                   PARM                    WFldNamArr                                   CAS004
     C                   PARM                    WMsgIdArr                                    CAS004
     C                   PARM                    WMsgDtaArr                                   CAS004
                                                                                              CAS004
      ** Array index (3P0) from/to caller                                                     CAS004
                                                                                              CAS004
     C                   PARM                    WIdx                                         CAS004
     C/COPY WNCPYSRC,MMLDNICC14
 
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
 
      * If ANY of the Settlements fields have been entered, bypass this
      *  routine.
      * Otherwise, use modules which will use Standard Settlement
      *  Instructions to apply defaults.
 
     C                   IF            (InRecSttmt = *blank)
     C                             AND (InPaySttmt = *blank)
 
     C/COPY WNCPYSRC,MMLDNICC02
     C                   CALLB     'ZASETINDFT'
     C/COPY WNCPYSRC,MMLDNICC03
 
      ** Output
      ** Calling function type
     C                   PARM                    LDNI
      ** Payment currency (or deal cuurency if only one currency on deal)
     C                   PARM                    DDCcy
      ** Receive currency (only if deal has two currencies)
     C**********         PARM                    Blank3                                       165903
     C                   PARM                    DDCcy                                        165903
     C/COPY WNCPYSRC,MMLDNICC08
      ** Customer (shortname or number)
     C                   PARM                    DDCust
      ** Deal type
     C                   PARM                    DDType
      ** Federal Funds Ind.
     C                   PARM                    DDFedF
      ** ISDA Rules for FRA/IRS deals only
      ** Version of ISDA Rules govern
     C                   PARM                    Blank4
      ** Type of ISDA agreement
     C                   PARM                    Blank6
      ** Date of ISDA Agreement
     C                   PARM                    Blank6
      ** Version of ISDA Agreement
     C                   PARM                    Blank2
      ** Version of ISDA Agreement century                                                    176883
     C                   PARM                    Blank2                                       176883
      ** Deal Subtype                                                                         CSD095
     C                   PARM                    DDSTYP                                       CSD095
      ** Branch                                                                               CSD095
     C                   PARM                    DDBRCA                                       CSD095
      *
      ** Return
      ** Defaulted Payment Settlement Instruction in file format
     C                   PARM                    DBPaySttmt
      ** Defaulted Receipt Settlement Instruction in file format
     C                   PARM                    DBRecSttmt
      ** Defaulted FRA/IRS Settlement Instruction in file format
     C                   PARM                    DBFRASttmt
     C/COPY WNCPYSRC,MMLDNICC06
 
      *  The defaulted instructions are in file format, but the
      *   Settlements validation requires that they are in the input format.
      *  Therefore run them through a conversion module.
 
     C                   CALLB     'ZASETINCVT'
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt
 
      ** Defaulted Settlement Instruction in input format
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM      DDCCY         #TRCCY                                      CSF011A
     C                   PARM      DDCCY         #TPCCY                                      CSF011A
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMEND - Set up fields that are needed in the validation  *
      *    of Amendments.                                             *
      *                                                               *
      *****************************************************************
 
     C     SetupAmend    BEGSR
 
      * For Amends, put the complete (pre-existing) deal into the Valid
      *  file record - fields in this will be updated during  processing
     C***********        MOVE      DealFilFmt    ValidDeal                                    242553
     C**********         MOVEL     DealFilFmt    ValidDeal                             242553 260027
     C                   MOVEL     DealFil1      ValidDeal                                    260027
     C                   MOVE      DealFil2      ValidDeal                                    260027
     C                   Z-ADD     HKMATD        OLD_MATD                       CDL007
 
      ***The*Settlement*Instructions*fields*may*not*be*supplied*for*an*****     CAP011
      ***amendment.*If*none*of*the*pay/receive*instructions*were***********     CAP011
      ***supplied*(i.e.*all*are*blank),*default*the*existing*database******     CAP011
      ***values*into*the*special*DB*Settlement*Instructions*DSs*....*******     CAP011
      *********************************************************************     CAP011
     C*******************IF************(InRecSttmt*=**blank)***************     CAP011
     C*****************************AND*(InPaySttmt*=**blank)***************     CAP011
 
     C                   EVAL      FLRSTM     = HKRSTM                                        CGL029
     C                   EVAL      FLRONS     = DELDRecInsEx                                  CGL029
     C                   EVAL      ESFRecIns  = DELDRecIns                                    CGL029
     C                   EVAL      FLROBR     = HKROBR                                        CGL029
     C**********         EVAL      DBRecSttmt = DELDRecIns + HKROBR                           CGL029
     C                   EVAL      FLRSCY     = HKSTCY
     C                   EVAL      FLPSTM     = HKPSTM                                        CGL029
     C                   EVAL      FLPONS     = DELDPayInsEx                                  CGL029
     C                   EVAL      ESFPayIns  = DELDPayIns                                    CGL029
     C                   EVAL      FLPOBR     = HKPOBR                                        CGL029
     C                   EVAL      FLCVMR     = HKCVMR                                        CGL029
     C**********         EVAL      DBPaySttmt = DELDPayIns + HKPOBR + HKCVMR                  CGL029
     C                   EVAL      FLPSCY     = HKSTCY
     C                   EVAL      FLIC72     = HKIC72
 
      *  .... and then convert these to the screen format
     C                   CALLB     'ZASETINCVT'
 
      ** Defaulted Settlement Instructions in file format
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt
                                                                                CAP011
      ** Current Settlement Instruction in input format                         CAP011
     C                   PARM                    CrPaySttmt                     CAP011
     C                   PARM                    CrRecSttmt                     CAP011
     C                   PARM                    CrFRASttmt                     CAP011
     C                   PARM      HKCCY         #TRCCY                                      CSF011A
     C                   PARM      HKCCY         #TPCCY                                      CSF011A
                                                                                CAP011
      *  If no Payment or Receive instructions have been supplied               CAP011
      *  Default them to those currently on the deal.                           CAP011
                                                                                CAP011
     C                   IF            (InPaySttmt = *blank)                    CAP011
     C                   EVAL      InPaySttmt = CrPaySttmt                      CAP011
     C                   ENDIF                                                  CAP011
                                                                                CAP011
     C                   IF            (InRecSttmt = *blank)                    CAP011
     C                   EVAL      InRecSttmt = CrRecSttmt                      CAP011
     C                   ENDIF                                                  CAP011
                                                                                CAP011
      * Do data substitution for Settlement Instructions                        CAP011
                                                                                CAP011
     C     GHSUBS        ifne      *blank                                       CAP011
     C     GHSUBS        scan      InPaySttmt                             99    CAP011
     C  N99GHSUBS        scan      InRecSttmt                             99    CAP011
     C     *in99         ifeq      *on                                          CAP011
     C                   EXSR      SDtDtaSubs                                   CAP011
     C                   endif                                                  CAP011
     C                   endif                                                  CAP011
 
      ***Defaulted*Settlement*Instruction*in*input*format**                     CAP011
     C*******************PARM********************InPaySttmt                     CAP011
     C*******************PARM********************InRecSttmt                     CAP011
     C*******************PARM********************InFRASttmt                     CAP011
      *****************************************************                     CAP011
     C*******************ENDIF*****************************                     CAP011
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateTr - Routine to validate the main tranaction details  *
      *                                                               *
      *****************************************************************
 
     C     ValidateTr    BEGSR
 
     C                   CALLB     'MMLDNIVAL'
      * Response mode (1A), from source system common header
     C                   PARM                    APRespMode
      * Transaction information (DS) from source system
     C                   PARM                    TranIn
      *                                                                                     AR701789
     C                   PARM                    ACTRJ                                      AR701789
     C                   PARM                    InfData                        CDL007
      * Receive Settlement Currency, Method & Nostro and
      * Payment Settlement Currency, Method & Nostro
      * Extra Data                                                              CAP004
     C                   PARM      *BLANK        RecSetCcy
     C                   PARM      *ZERO         RecSetMeth
     C                   PARM                    RecNostro
     C                   PARM      *BLANK        PaySetCcy
     C                   PARM      *ZERO         PaySetMeth
     C                   PARM                    PayNostro
     C                   PARM      HKFRNT        @@FRNT           20            CPB002
     C                   PARM                    ExtData                        CAP004
     C                   PARM                    DDAPRC            1                        MD054028
     C                   PARM                    DDAPRR            8                        MD054028
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
     C                   PARM                    WIdx
      * Valid Deals layout (DS) from/to caller
     C                   PARM                    ValidDeal
     C/COPY WNCPYSRC,MMLDNICC10
     C                   PARM      'N'           RepoFlag          1                          CSE006
      *                                                                                       CDL033
      ** Called from confirmation screen                                                      CDL033
     C                   PARM      'N'           PCONF                                        CDL033
     C/COPY WNCPYSRC,MMLDNICC01
      *                                                                                       CDL016
      * If errors bypass Screen 2 validation                                                  CDL016
      *                                                                                       CDL016
     C                   IF        Idx <> *ZERO                                               CDL016
     C                   GOTO      EValTr                                                     CDL016
     C                   ENDIF                                                                CDL016
      *                                                                                       CDL016
      * Validate screen 2 if feature is on and Fixed Deposit Deal                             CDL016
      *                                                                                       CDL016
     C     CDL016        IFEQ      'Y'                                                        CDL016
     C     CDL019        OREQ      'Y'                                                        CDL019
     C     CDL020        OREQ      'Y'                                                        CDL020
     C     CDL033        OREQ      'Y'                                                        CDL033
      *                                                                                       CDL016
     C     DDTYPE        IFEQ      'IT'                                                       CDL016
     C     DDTYPE        OREQ      'IP'                                                       CDL016
     C     DDTYPE        OREQ      'TD'                                                       CDL016
     C     DDTYPE        OREQ      'TI'                                                       CDL016
     C     DDTYPE        OREQ      'CF'                                                       CDL033
     C     DDTYPE        OREQ      'CI'                                                       CDL033
      *                                                                                       CDL016
     C                   CALLB     'MMLDNIVL2'                                                CDL016
      * Response mode (1A), from source system common header                                  CDL016
     C                   PARM                    APRespMode                                   CDL016
      * Transaction information (DS) from source system                                       CDL016
     C                   PARM                    TranIn                                       CDL016
     C                   PARM                    InfData                                      CDL016
      * Receive Settlement Currency, Method & Nostro and                                      CDL016
      * Payment Settlement Currency, Method & Nostro                                          CDL016
      * Extra Data                                                                            CDL016
     C                   PARM      *BLANK        RecSetCcy                                    CDL016
     C                   PARM      *ZERO         RecSetMeth                                   CDL016
     C                   PARM                    RecNostro                                    CDL016
     C                   PARM      *BLANK        PaySetCcy                                    CDL016
     C                   PARM      *ZERO         PaySetMeth                                   CDL016
     C                   PARM                    PayNostro                                    CDL016
     C                   PARM      HKFRNT        @@FRNT           20                          CDL016
     C                   PARM                    ExtData                                      CDL016
      * Field OK flags (DS) from/to caller                                                    CDL016
     C                   PARM                    OKFlagsDS2                                   CDL016
      * Error fields/message IDs/message data (arrays) from/to caller                         CDL016
     C                   PARM                    FldNameArr                                   CDL016
     C                   PARM                    MsgIDArr                                     CDL016
     C                   PARM                    MsgDtaArr                                    CDL016
      * Array index (3P0) from/to caller                                                      CDL016
     C                   PARM                    Idx                                          CDL016
      * Warning fields/message IDs/message data (arrays) from/to caller                       CDL016
     C                   PARM                    WFldNamArr                                   CDL016
     C                   PARM                    WMsgIDArr                                    CDL016
     C                   PARM                    WMsgDtaArr                                   CDL016
      * Array index (3P0) from/to caller                                                      CDL016
     C                   PARM                    WIdx                                         CDL016
      * Valid Deals layout (DS) from/to caller                                                CDL016
     C                   PARM                    ValidDeal                                    CDL016
     C                   PARM      'N'           RepoFlag          1                          CDL016
     C                   PARM                    CDL016                                       CDL016
     C                   PARM                    CDL019                                       CDL019
     C                   PARM                    CDL020                                       CDL020
     C                   PARM                    CAS005                                       CDL033
     C                   PARM                    CDL033                                       CDL033
     C                   PARM      *ZERO         SRATE                                        CDL033
                                                                                              CDL016
     C                   ENDIF                                                                CDL016
     C                   ENDIF                                                                CDL016
                                                                                              CDL016
     C     EValTr        TAG                                                                  CDL016
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateSt - Routine to validate the settlemnt instructions   *
      *                                                               *
      *****************************************************************
 
     C     ValidateSt    BEGSR
 
      * The called module requires that the customer number/name is valid,
      *  if it is not, exit from this subroutine.
     C                   IF        NOT (DDCustOK = 'Y')
     C                   GOTO      ValSetExit
     C                   ENDIF
 
      * The called module uses the value date in Midas Day Number format,
      *  which will not have been returned from the overall validation
      *  routine, so it needs to be converetd here.
 
     C                   IF        DDVDatOK <> 'N'
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    DDVDAT
     C                   PARM                    ValDateMDN
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag
 
      * If the Deal Type is for a Loan,    set the Pay Date = Value Date
      * If the Deal Type is for a Deposit, set the Receive Date = Value Date
     C                   IF           DDType = 'IP' OR DDType = 'TI'
     C                             OR DDType = 'CL' OR DDType = 'LN'
     C                             OR DDType = 'DL'
     C                             or (CDL006 = 'Y' and DDType = 'FL')                        209905
     C                             or (CDL006 = 'Y' and DDType = 'DP')                        209905
     C                             or (CDL006 = 'Y' and DDType = 'LP')                        209905
     C                   EVAL      PayDat = ValDateMDN
     C                   ELSE
     C                   EVAL      RecDat = ValDateMDN
     C                   ENDIF
 
     C                   ENDIF
 
     C                   RESET                   ReturnCode
     C/COPY WNCPYSRC,MMLDNICC04
     C                   CALLB     'ZASETINVAL'
     C/COPY WNCPYSRC,MMLDNICC05
 
      ** Return Code
     C                   PARM                    ReturnCode
      ** Following parameters are output to called module
      ** Calling function type
     C                   PARM                    LDNI
      ** Transaction Fields
      ** Payment currency (or deal currency if only one currency on deal)
     C                   PARM                    DDCCY
      ** Receive currency (or deal currency if only one currency on deal)
     C                   PARM                    DDCCY
      ** Customer (shortname or number)
     C                   PARM                    DDCUST
      ** Deal type
     C                   PARM                    DDTYPE
      ** Federal Funds Ind.
     C                   PARM                    DDFEDF
      ** Booking Branch
     C                   PARM                    DDBrCA
      ** Receipt Date
     C                   PARM                    RecDat
      ** Payment Date
     C                   PARM                    Paydat
      ** Input (or Defaulted) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
      * Action Code                                                                           185751
     C                   PARM                    DDACTN                                       185751
      * Protect Payment Field                                                                 196461
     C                   PARM                    ##PPAY            1                          196461
      * Protect Receipt Field                                                                 196461
     C                   PARM                    ##PREC            1                          196461
 
      ** Following parameters are returned by called module
      ** Payment Instruction OK flag
     C                   PARM                    OKPayInsDS
      ** Receive Instruction OK flag
     C                   PARM                    OKRecInsDS
      ** FRA/IRS Instruction OK flag
     C                   PARM                    OKFRAInsDS
      * Error fields/message IDs (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CRE008
     C                   PARM                    WFldNamArr                                   CRE008
     C                   PARM                    WMsgIDArr                                    CRE008
     C                   PARM                    WMsgDtaArr                                   CRE008
      ** Array index (3P0) from/to caller                                                     CRE008
     C                   PARM                    WIdx                                         CRE008
      ** File (D/B) Receipt/Payment/FRA/IRS Settlement Instruction
     C                   PARM                    DBPaySttmt
     C                   PARM                    DBRecSttmt
     C                   PARM                    DBFRASttmt
      ** Extra Input                                                                          166888
      ** Action Code used                                                                     166888
     C                   PARM      DDACTN        ##ACTN            1                          166888
      ** Validation Iteration                                                                 166888
     C                   PARM      '1ST'         ##ValIter         3                          166888
     C/COPY WNCPYSRC,MMLDNICC07
 
      **MIDAS*Our*Receive/ Pay Instructions (for Settlm Meth = 04 )                    179510 200400
     C************       PARM                    @MORPI           24                   179510 200400
      ************                                                                     179510 200400
     C     ValSetExit    TAG
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CAP011
      *****************************************************************         CAP011
      *                                                               *         CAP011
      * TDtDtaSubs - Transaction Details Data Substitution            *         CAP011
      *                                                               *         CAP011
      *****************************************************************         CAP011
                                                                                CAP011
     C     TDtDtaSubs    BEGSR                                                  CAP011
                                                                                CAP011
      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT                             CAP011
                                                                                CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'MMLDNICVT'                                  CAP011
                                                                                CAP011
      * INPUTS                                                                  CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * (Current) Deal in file format                                           CAP011
     C                   PARM                    DealFilfmt                     CAP011
      *                                                                                     MD054028
     C                   PARM                    DDAPRC            1                        MD054028
     C                   PARM                    DDAPRR            8                        MD054028
     C/COPY WNCPYSRC,MMLDNICC11
                                                                                CAP011
      * OUTPUTS                                                                 CAP011
      * (Current) Deal in screen format                                         CAP011
     C                   PARM                    DealScnfmt                     CAP011
     C/COPY WNCPYSRC,MMLDNICC12
      * Deal Status                                                             CAP011
     C                   PARM                    DDSTS                          CAP011
      *                                                                         CGL011
      ** Collateral Status                                                      CGL011
     C                   PARM                    DDCSTS           10            CGL011
                                                                                CAP011
      ** DATA SUBSTITUTION                                                      CAP011
                                                                                CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      TranIn        IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      DealScnfmt    CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       TranIn                         CAP011
                                                                                CAP011
     C                   ENDSR                                                  CAP011
      *****************************************************************         CAP011
      /EJECT                                                                    CAP011
      *****************************************************************         CAP011
      *                                                               *         CAP011
      * SDtDtaSubs - Settlement Details Data Substitution             *         CAP011
      *                                                               *         CAP011
      *****************************************************************         CAP011
                                                                                CAP011
     C     SDtDtaSubs    BEGSR                                                  CAP011
                                                                                CAP011
      ** PAYMENT INSTRUCTIONS                                                   CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar                       CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      InPaySttmt    IncDATA                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CrPaySttmt    CurDATA                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       InPaySttmt                     CAP011
                                                                                CAP011
      ** RECEIPT INSTRUCTIONS                                                   CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar                       CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      InRecSttmt    IncDATA                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CrRecSttmt    CurDATA                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       InRecSttmt                     CAP011
                                                                                CAP011
     C                   ENDSR                                                  CAP011
      *****************************************************************         CAP011
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdateAmd - Routine to check whether the fields amended      *
      *    are amendable.                                             *
      *                                                               *
      *****************************************************************
 
     C     ValdateAmd    BEGSR
 
      ** This subroutine calls a procedure which checks whether it
      ** was valid to amend any of the fields which have been
      ** changed.  Some are never amendable and some depend upon ICD
      ** settings as to whether they are amendable.
 
      ** To determine what fields have changed, the current fields
      ** on file must be converted to a 'screen' format.
 
      ** These fields are then compared with the fields on the input
      ** transaction.
 
      ** Any errors detected by the called procedure take precedence
      ** over any errors found during the validation of the complete
      ** transaction.  The errors from the called procedure are kept
      ** separately and, if any are found, these errors will REPLACE
      ** the normal validation errors.
 
      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT
 
     C                   RESET                   ReturnCode
     C                   CALLB     'MMLDNICVT'
 
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * (Current) Deal in file format
     C                   PARM                    DealFilfmt
      *                                                                                     MD054028
     C                   PARM                    DDAPRC            1                        MD054028
     C                   PARM                    DDAPRR            8                        MD054028
 
      * OUTPUTS
      * (Current) Deal in screen format
     C                   PARM                    DealScnfmt
      * Deal Status
     C                   PARM                    DDSTS            24
      *                                                                         CGL011
      ** Collateral Status                                                      CGL011
     C                   PARM                    DDCSTS           10            CGL011
 
      ** AMEND CHECKING
     C                   RESET                   ReturnCode
     C                   CALLB     'MMLDNIAMD'
 
      * INPUTS
      * Return Code
     C                   PARM                    ReturnCode
      * New Deal in Screen Format (Incoming Transaction)
     C                   PARM                    TranIn
      * (Current) Deal in Screen Format
     C                   PARM                    DealScnfmt
      * (Current) Deal in file format
     C                   PARM                    DealFilfmt
     C/COPY WNCPYSRC,MMLDNICC13
 
      * OUTPUTS
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AmFldNamAr
     C                   PARM                    AmMsgIdArr
     C                   PARM                    AmMsgDtaAr
      * Array index (3P0) from/to caller
     C                   PARM                    AmIdx
      * Amendments OK
     C                   PARM                    AmendOk           1
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'N'           ResetErrs         1
 
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
      *                                                               *
      * Check/Write - Routine to control checking of error status and *
      *    sending of messgaes/writing to the database                *
      *                                                               *
      *****************************************************************
 
     C     CheckWrite    BEGSR
 
      *  If no errors were found:
      *  - If Action Code is Insert and Deal Number is not supplied
      *     - set up the deal number
      *  - If there are still no errors
      *     - set up additional data
      *     - write a record to the Valid file
      *     - use std message handler to report deal status
      *  If any errors were found:
      *  - write a record to the Invalid file
      *  - call the message handler to pass the errors back
      *  - use std message handler to report deal status
      *  The index to the error arrays is checked for presence/absence of
      *   errors
     
      ** +--- Note for a later release -------------------------------+
      ** |                                                            |
      ** | At a later date this routine will have to cater for        |
      ** | warning messages.  The following logic will have to be     |
      ** | inserted before "If no errors were found", in the          |
      ** | above comments (and the code):                             |
      ** |                                                            |
      ** | If 'Ignore warning messages' (from API ICD) is 'N', AND    |
      ** | any warning messages were returned (WIdx <> 0)             |
      ** |                                                            |
      ** | -   If errors exist                                        |
      ** |     -     Add the warning array index to the error array   |
      ** |           index                                            |
      ** |     -     Append the contents of the warning arrays to the |
      ** |           end of the error arrays                          |
      ** | -   Else                                                   |
      ** |     -     Set the error array index equal to the warning   |
      ** |           array index                                      |
      ** |     -     Copy the contents of the warning arrays to the   |
      ** |           error arrays                                     |
      ** | -   Endif                                                  |
      ** |                                                            |
      ** | Endif                                                      |
      ** |                                                            |
      ** | Note that the "If errors exist ... Else ... " block above  |
      ** | can probably be implemented unconditionally (ie the same   |
      ** | logic will apply whether errors exist as well as warnings  |
      ** | or not).  It is shown in the above form for clarity.       |
      ** |                                                            |
      ** +------------------------------------------------------------+
 
     C     Idx           IFEQ      0
 
     C                   IF        DDACTN = 'I'
     C                   EXSR      SETUPDEALN
     C                   ENDIF
 
     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   WRITE     MMVLDNID0
                                                                                              209905
     C                   IF        CDL006 = 'Y'                                               209905
     C                   EXSR      SETUPVLDFD                                                 209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   IF        CDL033 = 'Y'                                               CDL033
     C                             AND (DDRCFR = 'Z' OR DDIPFQ = 'Z')                         CDL033
     C                   EXSR      SetValidDat                                                CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** Insert DLDLDCQD record for CLE025 processing                                         247888
     C                   IF        DDACTN = 'I' AND CLE025 = 'Y'                              247888
     C     DDDLNO        CHAIN     DLDLDCD0                           12                      247888
     C     *IN12         IFEQ      *ON                                                        247888
     C                   EVAL      DX_F1DLNO = DDDLNO                                         247888
     C                   EVAL      DX_F1BRCA = DDBRCA                                         247888
     C                   WRITE     DLDLDCD0                                                   247888
     C                   ENDIF                                                                247888
     C                   ENDIF                                                                247888
                                                                                              247888
     C                   EXSR      CallMsgHdl
     C                   ENDIF
 
     C                   ENDIF
 
     C     Idx           IFGT      0
     C                   EXSR      SETUPINVAL
      *                                                                         CAP004
      * Only write to invalid files if repair in back office                    CAP004
      *                                                                         CAP004
     C     APRprLocn     IFEQ      'B'                                          CAP004
     C                   WRITE     MMILDNID0
     C                   WRITE     APIDSETD0
                                                                                              CSC011
      ** Write all invalid records to the support log file                                    CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' AND                                           CSC011
     C                             S1SUPP = LIBR                                              CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = TranIn +                                        CSC011
     C                                        InRecSttmt +                                    CSC011
     C                                        InPaySttmt +                                    CSC011
     C                                        InfData +                                       CSC011
     C                                        RegData +                                       CER001
     C                                        ExtData                                         CSC011
                                                                                              CSC011
     C                   EVAL      APTGTTYPE  = 'MMLDNI'                                      CSC011
     C                   EVAL      PDealNo = DDDLNO                                           CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    HeadIn                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM                    Timestamp                                    CSC011
     C                   PARM                    PDealNo                                      CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *BLanks                                      CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = DDDLNO                                             CSC011
     C                   EVAL      DBFILE = 'APLOGTRAN'                                       CSC011
     C                   EVAL      DBASE = 901                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              209905
     C                   IF        CDL006 = 'Y'                                               209905
     C                   EXSR      SETUPINVFD                                                 209905
     C                   ENDIF                                                                209905
                                                                                              CDL033
     C                   IF        CDL033 = 'Y'                                               CDL033
     C                   EXSR      SetlnVldDat                                                CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CSC011
     C                   ENDIF                                                  CAP004
     C                   EXSR      CallMsgHdl
     C                   ENDIF
                                                                                              209905
      ** Remove records from work and temporary file                                          209905
                                                                                              209905
     C                   IF        CDL006 = 'Y'                                               209905
     C                   EXSR      SRCLRWRKTMP                                                209905
     C                   ENDIF                                                                209905
 
     C                   IF        (CSC022 = 'N')                                             CSC022
     C                             OR (CSC022 = 'Y') AND (WCMTSK = 'N')                       CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
 
     C                   ENDSR
                                                                                              209905
      ********************************************************************                    209905
      /EJECT                                                                                  209905
      ********************************************************************                    209905
      *                                                                  *                    209905
      * SRCLRWRKTMP - Clears Records from Work and Temporary File        *                    209905
      *                                                                  *                    209905
      ********************************************************************                    209905
                                                                                              209905
     C     SRClrWrkTmp   BEGSR                                                                209905
                                                                                              209905
      ** LDNI work file                                                                       209905
                                                                                              209905
     C     APFOTRANID    SETLL     MMWLDNIL0                                                  209905
     C     APFOTRANID    READE     MMWLDNIL0                                                  209905
     C                   DOW       NOT %EOF                                                   209905
     C                   DELETE    MMWLDNID0                                                  209905
     C     APFOTRANID    READE     MMWLDNIL0                                                  209905
     C                   ENDDO                                                                209905
                                                                                              209905
      ** FIDT work file                                                                       209905
                                                                                              209905
     C     APFOTRANID    SETLL     MMWFIDTL0                                                  209905
     C     APFOTRANID    READE     MMWFIDTL0                                                  209905
     C                   DOW       NOT %EOF                                                   209905
     C                   DELETE    MMWFIDTD0                                                  209905
     C     APFOTRANID    READE     MMWFIDTL0                                                  209905
     C                   ENDDO                                                                209905
                                                                                              209905
      ** FIDT temp file                                                                       209905
                                                                                              209905
     C     APFOTRANID    SETLL     MMTFIDTL0                                                  209905
     C     APFOTRANID    READE     MMTFIDTL0                                                  209905
     C                   DOW       NOT %EOF                                                   209905
     C                   DELETE    TMPVFIDTD0                                                 209905
     C     APFOTRANID    READE     MMTFIDTL0                                                  209905
     C                   ENDDO                                                                209905
                                                                                              209905
     C                   ENDSR                                                                209905
                                                                                              209905
      ********************************************************************                    209905
      /EJECT                                                                                  209905
      ********************************************************************                    209905
      *                                                                  *                    209905
      * SETUPVLDFD - Setup Valid Fiduciary Takings File                  *                    209905
      *                                                                  *                    209905
      ********************************************************************                    209905
                                                                                              209905
     C     SETUPVLDFD    BEGSR                                                                209905
                                                                                              209905
     C     APFOTRANID    SETLL     MMTFIDTL0                                                  209905
     C     APFOTRANID    READE     MMTFIDTL0                                                  209905
                                                                                              209905
     C                   DOW       NOT %EOF(MMTFIDTL0)                                        209905
     C                   EVAL      VALFIDTDATA = TMPFIDTDATA                                  209905
     C                   WRITE     MMVFIDTD0                                                  209905
     C     APFOTRANID    READE     MMTFIDTL0                                                  209905
     C                   ENDDO                                                                209905
                                                                                              209905
     C                   ENDSR                                                                209905
                                                                                              209905
      ********************************************************************                    209905
      /EJECT                                                                                  209905
      ********************************************************************                    209905
      *                                                                  *                    209905
      * SETUPINVFD - Setup Invalid Fiduciary Takings File                *                    209905
      *                                                                  *                    209905
      ********************************************************************                    209905
                                                                                              209905
     C     SETUPINVFD    BEGSR                                                                209905
                                                                                              209905
     C                   EVAL      WMAINFOID = APFOTRANID                                     209905
     C                   EVAL      WMAINAFID = APFOASOCID                                     209905
     C                   EVAL      RFSFOASOCID = APFOTRANID                                   209905
     C                   EVAL      RFSRPRLOCN  = APRPRLOCN                                    209905
     C                   EVAL      RFSFTMESTMP = TIMESTAMP                                    209905
                                                                                              209905
     C                   IF        WFIDT1FO <> *BLANK                                         209905
     C                   EVAL      RFSFOTRANID = WFIDT1FO                                     209905
     C                   EVAL      FIDTINVDTL = *BLANKS                                       209905
     C                   EVAL      FIDTINVDTL  = WFIDTDTA1 + WFIDTNAR                         209905
     C                   WRITE     MMIFIDTD0                                                  209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   IF        WFIDT2FO <> *BLANK                                         209905
     C                   EVAL      RFSFOTRANID = WFIDT2FO                                     209905
     C                   EVAL      FIDTINVDTL = *BLANKS                                       209905
     C                   EVAL      FIDTINVDTL  = WFIDTDTA2                                    209905
     C                   WRITE     MMIFIDTD0                                                  209905
     C                   ENDIF                                                                209905
                                                                                              209905
      ** If support system is active, write invalid transaction to                            209905
      ** log file via APLOGTRAN standard module.                                              209905
                                                                                              209905
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         209905
                                                                                              209905
     C                   EVAL      WMSGTYPE = 'MMFIDT'                                        209905
                                                                                              209905
     C                   IF        WFIDT1FO <> *BLANK                                         209905
     C                   EVAL      APFOTRANID = WFIDT1FO                                      209905
     C                   EVAL      APFOASOCID = WMAINFOID                                     209905
     C                   EVAL      TRANSDTL =  WFIDTDTA1                                      209905
     C                   EXSR      SRLogInvTr                                                 209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   IF        WFIDT2FO <> *BLANK                                         209905
     C                   EVAL      APFOTRANID = WFIDT2FO                                      209905
     C                   EVAL      APFOASOCID = WMAINFOID                                     209905
     C                   EVAL      TRANSDTL =  WFIDTDTA2                                      209905
     C                   EXSR      SRLogInvTr                                                 209905
     C                   ENDIF                                                                209905
                                                                                              209905
      ** Also log trailer file                                                                209905
                                                                                              209905
     C                   EVAL      WMSGTYPE = 'MMFITR'                                        209905
     C                   EVAL      APFOTRANID = WFITRFO                                       209905
     C                   EVAL      APFOASOCID = WMAINFOID                                     209905
     C                   EVAL      TRANSDTL =  InRecSttmt                                     209905
     C                                         + InPaySttmt                                   209905
     C                                         + InfData                                      209905
     C                                         + RegData                                      CER001
     C                                         + ExtData                                      209905
     C                   EXSR      SRLogInvTr                                                 209905
                                                                                              209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   EVAL      APFOTRANID = WMAINFOID                                     209905
     C                   EVAL      APFOASOCID = WMAINAFID                                     209905
                                                                                              209905
     C                   ENDSR                                                                209905
                                                                                              209905
      ********************************************************************                    209905
      /EJECT                                                                                  209905
      ********************************************************************                    209905
      *                                                                  *                    209905
      * SRLOADARR - Load Work File Records to Array                      *                    209905
      *                                                                  *                    209905
      ********************************************************************                    209905
                                                                                              209905
     C     SRLOADARR     BEGSR                                                                209905
                                                                                              209905
     C                   EVAL      WFIDTDTA = *BLANKS                                         209905
     C                   EVAL      WFIDT1FO = *BLANKS                                         209905
     C                   EVAL      WFIDT2FO = *BLANKS                                         209905
                                                                                              209905
     C     APFOTRANID    SETLL     MMWFIDTL0                                                  209905
     C     APFOTRANID    READE     MMWFIDTL0                                                  209905
     C                   IF        NOT %EOF                                                   209905
     C                   EVAL      WFIDTDTA1 = (%SUBST(WRKFIDT:1:3696))                       209905
     C                   EVAL      WFIDTNAR = (%SUBST(WRKFIDT:3697:240))                      209905
     C                   EVAL      WFIDT1FO = WSFOTRANID                                      209905
     C     APFOTRANID    READE     MMWFIDTL0                                                  209905
     C                   IF        NOT %EOF                                                   209905
     C                   EVAL      WFIDTDTA2 = (%SUBST(WRKFIDT:1:462))                        209905
     C                   EVAL      WFIDT2FO = WSFOTRANID                                      209905
     C                   ENDIF                                                                209905
     C                   EVAL      WFIDTDTA = WFIDTDTA1 + WFIDTDTA2                           209905
     C                   ENDIF                                                                209905
                                                                                              209905
      ** Reset counters                                                                       209905
                                                                                              209905
     C                   EVAL      A = 1                                                      209905
     C                   EVAL      B = 1                                                      209905
                                                                                              209905
     C                   DOW       A <= 99                                                    209905
                                                                                              209905
     C                   EVAL      WFIDTARR(A) = (%SUBST(WFIDTDTA:B:42))                      209905
                                                                                              209905
     C                   EVAL      A = A + 1                                                  209905
     C                   EVAL      B = B + 42                                                 209905
                                                                                              209905
     C                   ENDDO                                                                209905
                                                                                              209905
     C                   ENDSR                                                                209905
                                                                                              209905
      *****************************************************************                       209905
      /EJECT                                                                                  209905
      *****************************************************************                       209905
      *                                                               *                       209905
      * VALIDATEFD - Routine to Validate Fiduciary Takings            *                       209905
      *                                                               *                       209905
      *****************************************************************                       209905
                                                                                              209905
     C     VALIDATEFD    BEGSR                                                                209905
                                                                                              209905
     C                   IF        DDTYPE = 'FL' or DDTYPE = 'DP' or                          209905
     C                             DDTYPE = 'LP'                                              209905
                                                                                              209905
     C                   EVAL      CTR = 1                                                    209905
     C                   EVAL      WTAmount = *ZEROS                                          209905
                                                                                              209905
     C                   DOW       CTR <= 99                                                  209905
                                                                                              209905
     C                   IF        WFIDTARR(Ctr) = *BLANKS                                    209905
     C                   LEAVE                                                                209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   IF        DDTYPE = 'DP' and CTR > 1 or                               209905
     C                             DDTYPE = 'LP' and CTR > 1                                  209905
     C                   ADD       1             Idx                                          209905
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'                                 209905
     C                   EVAL      MsgIDArr(Idx) = 'MMM9039'                                  209905
     C                   GOTO      VALFIDTEXT                                                 209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   EVAL      WFIDTDTL = WFIDTARR(CTR)                                   209905
                                                                                              209905
     C                   CALLB     'MMFIDTVAL'                                                209905
     C                   PARM                    ReturnCode                                   209905
     C                   PARM                    DDACTN                                       209905
     C                   PARM                    DDDLNO                                       209905
     C                   PARM                    DDBRCA                                       209905
     C                   PARM                    DDCCY                                        209905
     C                   PARM                    DDTYPE                                       209905
     C                   PARM                    DDCUST                                       209905
     C                   PARM                    WFIDTDTL                                     209905
     C                   PARM                    BGPFMG                                       209905
     C                   PARM                    SDPORT                                       209905
     C                   PARM                    WTAmount                                     209905
     C                   PARM                    OKFIDTDTL                                    209905
     C                   PARM                    FldNameArr                                   209905
     C                   PARM                    MsgIDArr                                     209905
     C                   PARM                    MsgDtaArr                                    209905
     C                   PARM                    Idx                                          209905
     C                   PARM      *BLANKS       VFIDTDTL                                     209905
                                                                                              209905
     C                   EVAL      CTR = CTR + 1                                              209905
                                                                                              209905
     C                   IF        OKFIDTDTL = 'N'                                            209905
     C                   GOTO      VALFIDTEXT                                                 209905
     C                   ELSE                                                                 209905
     C                   EXSR      FIDTUPDATE                                                 209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   ENDDO                                                                209905
                                                                                              209905
                                                                                              209905
      ** Total amounts of takings deals must match the placing deal amount                    209905
                                                                                              209905
     C                   MOVE      *BLANKS       ZFIELD                                       209905
                                                                                              209905
     C                   CALLB     'ZALIGN'                                                   209905
     C                   PARM                    ZALIGNOK                                     209905
     C                   PARM      DDAMNP        ZFIELD                                       209905
     C                   PARM      PCYDP         ZADEC                                        209905
     C                   PARM      12            ZADIG                                        209905
                                                                                              209905
     C                   MOVE      ZFIELD        WAmount                                      209905
                                                                                              209905
     C                   IF        WTAmount <> WAmount                                        209905
     C                   MOVE      *BLANKS       ZFLD15                                       209905
                                                                                              209905
     C                   CALLB     'ZSEDIT'                                                   209905
     C                   PARM      WTAmount      ZFLD15                                       209905
     C                   PARM      PCYDP         ZDECS                                        209905
     C                   PARM      *BLANKS       ZECODE                                       209905
     C                   PARM                    ZOUT21                                       209905
                                                                                              209905
     C                   ADD       1             Idx                                          209905
     C                   EVAL      FldNameArr(Idx) = 'DDAMNP'                                 209905
     C                   EVAL      MsgIDArr(Idx) = 'MMA0579'                                  209905
     C                   EVAL      MsgDtaArr(Idx) = ZOUT21                                    209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C     VALFIDTEXT    TAG                                                                  209905
                                                                                              209905
     C                   ENDSR                                                                209905
                                                                                              209905
      *****************************************************************                       209905
      /EJECT                                                                                  209905
      *****************************************************************                       209905
      *                                                               *                       209905
      * FIDTUPDATE - Update Fiduciary Takings Temporary File          *                       209905
      *                                                               *                       209905
      *****************************************************************                       209905
                                                                                              209905
     C     FIDTUPDATE    BEGSR                                                                209905
                                                                                              209905
     C                   CALLB     'AOCUSTR1'                                                 209905
     C                   PARM      *BLANKS       PRTCD                                        209905
     C                   PARM      '*KEY   '     POPTN                                        209905
     C                   PARM      VSFCNUM       PKEY1                                        209905
     C                   PARM      *BLANKS       PKYST                                        209905
     C     SDCUST        PARM      SDCUST        DSLDY                                        209905
                                                                                              209905
     C                   IF        PRTCD <> *BLANKS                                           209905
     C     *LOCK         IN        LDA                                                        209905
     C                   EVAL      DBKEY = VSFCNUM                                            209905
     C                   EVAL      DBFILE = 'SDCUSTPD'                                        209905
     C                   EVAL      DBASE = 906                                                209905
     C                   OUT       LDA                                                        209905
     C                   EXSR      *PSSR                                                      209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   CALLB     'AOCURRR0'                                                 209905
     C                   PARM      *BLANKS       PRTCD                                        209905
     C                   PARM      '*KEY   '     POPTN                                        209905
     C                   PARM      DDCCY         PCCY                                         209905
     C     SDCURR        PARM      SDCURR        DSSDY                                        209905
                                                                                              209905
     C                   IF        PRTCD <> *BLANKS                                           209905
     C     *LOCK         IN        LDA                                                        209905
     C                   EVAL      DBKEY = DDCCY                                              209905
     C                   EVAL      DBFILE = 'SDCUSTPD'                                        209905
     C                   EVAL      DBASE = 907                                                209905
     C                   OUT       LDA                                                        209905
     C                   EXSR      *PSSR                                                      209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   CLEAR                   TMPVFIDTD0                                   209905
                                                                                              209905
     C                   EVAL      JWIKTMESTMP = TimeStamp                                    209905
                                                                                              209905
     C                   IF        CTR <=89                                                   209905
     C                   MOVE      WFIDT1FO      JWIKFRNT                                     209905
     C                   ELSE                                                                 209905
     C                   MOVE      WFIDT2FO      JWIKFRNT                                     209905
     C                   ENDIF                                                                209905
     C                   MOVE      APFOTRANID    JWIKAFRT                                     209905
     C                   MOVEL     IKRCID        JWIKRCID                                     209905
     C                   MOVEL     IKDLTF        JWIKDLTF                                     209905
     C                   Z-ADD     IKDLUP        JWIKDLUP                                     209905
     C                   MOVEL     IKMLUP        JWIKMLUP                                     209905
     C                   Z-ADD     IKYLUP        JWIKYLUP                                     209905
     C                   Z-ADD     IKTLUP        JWIKTLUP                                     209905
     C                   MOVEL     IKCHTP        JWIKCHTP                                     209905
     C                   Z-ADD     IKLCD         JWIKLCD                                      209905
     C                   MOVEL     IKLUID        JWIKLUID                                     209905
     C                   MOVE      VSFDLNO       JWIKDN38                                     209905
     C                   MOVEL     'MAIL'        JWIKBKCD                                     209905
     C                   MOVEL     DDCCY         JWIKCCY                                      209905
     C                   Z-ADD     IKCYDP        JWIKCYDP                                     209905
     C                   Z-ADD     IKVDYY        JWIKVDYY                                     209905
     C                   Z-ADD     IKVDMM        JWIKVDMM                                     209905
     C                   Z-ADD     IKVDDD        JWIKVDDD                                     209905
     C                   Z-ADD     IKDTYY        JWIKDTYY                                     209905
     C                   Z-ADD     IKDTMM        JWIKDTMM                                     209905
     C                   Z-ADD     IKDTDD        JWIKDTDD                                     209905
     C                   MOVEL     IKDDLT        JWIKDDLT                                     209905
     C                   MOVEL     IKMTYP        JWIKMTYP                                     209905
     C                   MOVEL     IKDSTS        JWIKDSTS                                     209905
                                                                                              209905
     C                   IF        DDTYPE = 'FL'                                              209905
     C                   MOVEL     'FT'          JWIKTYPE                                     209905
     C                   ELSE                                                                 209905
     C                   IF        DDTYPE = 'DP'                                              209905
     C                   MOVEL     'DT'          JWIKTYPE                                     209905
     C                   ELSE                                                                 209905
     C                   IF        DDTYPE = 'LP'                                              209905
     C                   MOVEL     'LT'          JWIKTYPE                                     209905
     C                   ENDIF                                                                209905
     C                   ENDIF                                                                209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   MOVEL     IKSTYP        JWIKSTYP                                     209905
     C                   MOVEL     BBCSSN        JWIKCSNM                                     209905
     C                   MOVE      BBCUST        JWIKCNUM                                     209905
                                                                                              209905
     C                   MOVEL     *BLANKS       ZFIELD                                       209905
     C                                                                                        209905
     C                   CALLB     'ZALIGN'                                                   209905
     C                   PARM                    ZALIGNOK                                     209905
     C                   PARM      VSFAMNT       ZFIELD                                       209905
     C                   PARM      A6NBDP        ZADEC                                        209905
     C                   PARM      12            ZADIG                                        209905
     C                   MOVE      ZFIELD        JWIKAMNP                                     209905
                                                                                              209905
     C                   Z-ADD     IKINTR        JWIKINTR                                     209905
     C                   MOVEL     IKBRCA        JWIKBRCA                                     209905
     C                   MOVEL     IKDBRC        JWIKDBRC                                     209905
     C                   Z-ADD     IKDDYY        JWIKDDYY                                     209905
     C                   Z-ADD     IKDDMM        JWIKDDMM                                     209905
     C                   Z-ADD     IKDDDD        JWIKDDDD                                     209905
     C                   Z-ADD     IKBRKG        JWIKBRKG                                     209905
     C                   MOVEL     IKFEDF        JWIKFEDF                                     209905
     C                   MOVEL     IKCDRF        JWIKCDRF                                     209905
     C                   Z-ADD     IKPCTN        JWIKPCTN                                     209905
     C                   MOVEL     IKCDRP        JWIKCDRP                                     209905
     C                   MOVEL     DDACTN        JWIKLACT                                     209905
     C                   Z-ADD     IKTIME        JWIKTIME                                     209905
     C                   MOVEL     IKDUSC        JWIKDUSC                                     209905
     C                   Z-ADD     IKLDAT        JWIKLDAT                                     209905
     C                   MOVEL     IKAOFR        JWIKAOFR                                     209905
     C                   Z-ADD     IKSLYY        JWIKSLYY                                     209905
     C                   Z-ADD     IKSLMM        JWIKSLMM                                     209905
     C                   Z-ADD     IKSLDD        JWIKSLDD                                     209905
     C                   Z-ADD     IKSPRD        JWIKSPRD                                     209905
     C                   Z-ADD     IKIIRT        JWIKIIRT                                     209905
     C                   Z-ADD     IKNIYY        JWIKNIYY                                     209905
     C                   Z-ADD     IKNIMM        JWIKNIMM                                     209905
     C                   Z-ADD     IKNIDD        JWIKNIDD                                     209905
     C                   MOVEL     IKIPFQ        JWIKIPFQ                                     209905
     C                   MOVEL     IKICMT        JWIKICMT                                     209905
     C                   Z-ADD     IKIPDM        JWIKIPDM                                     209905
     C                   MOVEL     *BLANKS       JWIKCPTI                                     209905
     C                   MOVEL     IKCNTI        JWIKCNTI                                     209905
     C                   MOVE      VSFACSQ       JWIKACSQ                                     209905
     C                   MOVEL     'N'           JWIKMTAX                                     209905
     C**********         Z-ADD     IKMCDH        JWIKMCDH                              209905 CSD027
     C                   EVAL      JWIKMCDH = IKMCDH                                          CSD027
     C                   Z-ADD     IKIAYY        JWIKIAYY                                     209905
     C                   Z-ADD     IKIAMM        JWIKIAMM                                     209905
     C                   Z-ADD     IKIADD        JWIKIADD                                     209905
     C                   MOVEL     IKBSRC        JWIKBSRC                                     209905
     C                   MOVEL     IKDBSR        JWIKDBSR                                     209905
     C                   Z-ADD     IKMDYY        JWIKMDYY                                     209905
     C                   Z-ADD     IKMDMM        JWIKMDMM                                     209905
     C                   Z-ADD     IKMDDD        JWIKMDDD                                     209905
     C                   Z-ADD     IKNTCE        JWIKNTCE                                     209905
     C                   Z-ADD     IKFCLY        JWIKFCLY                                     209905
     C                   Z-ADD     IKIMAT        JWIKIMAT                                     209905
     C                   Z-ADD     IKBRAT        JWIKBRAT                                     209905
     C                   MOVEL     IKMMDI        JWIKMMDI                                     209905
     C                   MOVEL     'MACC '       JWIKDORM                                     209905
     C                   MOVE      05            JWIKORCM                                     209905
     C                   EVAL      JWIKDORI = BBCUST + VSFACOD + VSFACSQ                      209905
     C                   EVAL      JWIKMORI = BBCUST + VSFACOD + VSFACSQ                      209905
     C                   MOVEL     'MACC '       JWIKDOPM                                     209905
     C                   MOVE      05            JWIKMOPM                                     209905
     C                   EVAL      JWIKDOPI = BBCUST + VSFACOD + VSFACSQ                      209905
     C                   EVAL      JWIKMOPI = BBCUST + VSFACOD + VSFACSQ                      209905
     C                   MOVEL     IKBOKC        JWIKBOKC                                     209905
     C                   MOVEL     IKDRID        JWIKDRID                                     209905
     C                   MOVEL     IKDDMR        JWIKDDMR                                     209905
     C                   Z-ADD     IKRBAT        JWIKRBAT                                     209905
     C                   MOVE      05            JWIKRSTM                                     209905
     C                   EVAL      JWIKRONS = BBCUST + VSFACOD + VSFACSQ                      209905
     C                   MOVE      05            JWIKPSTM                                     209905
     C                   EVAL      JWIKPONS = BBCUST + VSFACOD + VSFACSQ                      209905
     C                   Z-ADD     IKDVSD        JWIKDVSD                                     209905
     C                   Z-ADD     IKDDND        JWIKDDND                                     209905
     C                   Z-ADD     IKSLID        JWIKSLID                                     209905
     C                   Z-ADD     IKNIPD        JWIKNIPD                                     209905
     C                   Z-ADD     IKMATD        JWIKMATD                                     209905
     C                   MOVEL     IKORBR        JWIKORBR                                     209905
                                                                                              209905
     C                   CALLB     'AOPRFMR0'                                                 209905
     C                   PARM      *BLANKS       PRTCD                                        209905
     C                   PARM      IKBOKC        PBOOK                                        209905
     C                   PARM      IKTYPE        PTRTP                                        209905
     C                   PARM      IKSTYP        PSUTP                                        209905
     C                   PARM      IKBRCA        PBRAN                                        209905
     C                   PARM      ZMDEPT        PDEPT1                                       209905
     C                   PARM      PSUSER        PUSER                                        209905
     C                   PARM      BBACOC        PACOF                                        209905
     C                   PARM      BBCUST        PCUST                                        209905
     C                   PARM                    PPRFC                                        209905
                                                                                              209905
     C                   IF        PRTCD = *BLANKS                                            209905
     C                   MOVEL     PPRFC         JWIKPRFC                                     209005
     C                   ELSE                                                                 209905
     C                   MOVEL     IKPRFC        JWIKPRFC                                     209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   MOVEL     DDBRCA        JWIKPOBR                                     209905
     C                   MOVEL     DDBRCA        JWIKROBR                                     209905
     C                   MOVEL     IKCVMR        JWIKCVMR                                     209905
     C                   MOVEL     IKRDFC        JWIKRDFC                                     209905
     C                   MOVEL     IKFLID        JWIKFLID                                     209905
     C                   MOVEL     IKFUID        JWIKFUID                                     209905
     C                   MOVEL     IKAURO        JWIKAURO                                     209905
     C                   MOVEL     IKIPDS        JWIKIPDS                                     209905
     C                   MOVEL     IKROFQ        JWIKROFQ                                     209905
     C                   Z-ADD     IKRLDN        JWIKRLDN                                     209905
     C                   MOVEL     IKCNNA        JWIKCNNA                                     209905
     C                   MOVEL     IKIMET        JWIKIMET                                     209905
     C                   MOVEL     IKINSA        JWIKINSA                                     209905
     C                   MOVEL     IKINOS        JWIKINOS                                     209905
     C                   MOVEL     IKWRPI        JWIKWRPI                                     209905
     C                   MOVE      VSFTRAS       JWIKFTST                                     209905
     C                   IF        DDTYPE = 'LP'                                              209905
     C                   MOVE      WSFNAR1       JWIKFRN1                                     209905
     C                   MOVE      WSFNAR2       JWIKFRN2                                     209905
     C                   MOVE      WSFNAR3       JWIKFRN3                                     209905
     C                   MOVE      WSFNAR4       JWIKFRN4                                     209905
     C                   ELSE                                                                 209905
     C                   MOVE      *BLANKS       JWIKFRN1                                     209905
     C                   MOVE      *BLANKS       JWIKFRN2                                     209905
     C                   MOVE      *BLANKS       JWIKFRN3                                     209905
     C                   MOVE      *BLANKS       JWIKFRN4                                     209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   IF        BGPFMG  = 'Y'                                              209905
     C                   IF        VSFPTFR = FCR997                                           209905
     C                   MOVE      '9997'        JWIKPTFR                                     209905
     C                   ELSE                                                                 209905
     C                   MOVEL     VSFPTFR       JWIKPTFR                                     209905
     C                   ENDIF                                                                209905
     C                   ELSE                                                                 209905
     C                   MOVE      *BLANKS       JWIKPTFR                                     209905
     C                   ENDIF                                                                209905
                                                                                              209905
      ** Calculate total interest of the taking deal                                          209905
                                                                                              209905
     C                   Z-ADD     JWIKCYDP      PCYDP                                        209905
     C                   Z-ADD     JWIKNTCE      PNTCE                                        209905
                                                                                              209905
     C                   CALLB     'ZAVTOTINT'                                                209905
     C                   PARM      *BLANKS       RETURNCODE                                   209905
     C                   PARM      *BLANKS       MSGID1                                       209905
      ** Action Code (1A, from caller)                                                        209905
     C                   PARM                    DDACTN                                       209905
      ** Message data (45A)                                                                   209905
     C                   PARM      *BLANKS       MSGDATA                                      209905
      ** Total interest amount returned from this module (15,0P)                              209905
     C                   PARM      *ZERO         JWIKMTTI                                     209905
      ** Total interest amount (14A, from transaction)                                        209905
     C                   PARM      '*'           PTOTI                                        209905
      ** Default interest for CL and CD deals with zero notice days                           209905
      ** feature flag (1A, from SCSARDPD)                                                     209905
     C                   PARM                    S01468                                       209905
      ** Deal notice days (3A, from transaction)                                              209905
     C                   PARM                    PDDNTCE                                      209905
      ** Deal type (2A, from transaction)                                                     209905
     C                   PARM                    JWIKTYPE                                     209905
      ** Interest rate (11,7P)                                                                209905
     C                   PARM                    JWIKINTR                                     209905
      ** Deal amount (15,0P, from caller)                                                     209905
     C                   PARM                    JWIKAMNP                                     209905
      ** Interest calculation method (1A, from transaction)                                   209905
     C                   PARM                    JWIKICMT                                     209905
      ** Deal value date in Midas day number format (5,0P)                                    209905
     C                   PARM                    JWIKDVSD                                     209905
      ** Currency FldNameArr OK flag (1A)                                                     209905
     C                   PARM      'Y'           DDCCYOK                                      209905
      ** Number of decimal places in deal currency (1,0S, from SDCURRPD)                      209905
     C                   PARM                    PCYDP                                        209905
      ** Value date field OK (1A)                                                             209905
     C                   PARM      'Y'           DDVDATOK                                     209905
      ** Notice days field OK (1A)                                                            209905
     C                   PARM      'Y'           DDNTCEOK                                     209905
      ** Amount field OK (1A)                                                                 209905
     C                   PARM      'Y'           DDAMNPOK                                     209905
      ** Base Rate field OK (1A)                                                              209905
     C                   PARM      'Y'           DDBSRCOK                                     209905
      ** Spread/Rate field OK (1A)                                                            209905
     C                   PARM      'Y'           DDSPRTOK                                     209905
      ** Calculation method field OK (1A)                                                     209905
     C                   PARM      'Y'           DDICMTOK                                     209905
      ** Maturity date (6A, from transaction)                                                 209905
     C                   PARM                    PDDMDAT                                      209905
      ** Maturity date in Midas day number format (5,0P)                                      209905
     C                   PARM                    JWIKMATD                                     209905
      ** Maturity date field OK (1A)                                                          209905
     C                   PARM      'Y'           DDMDATOK                                     209905
      ** Notice days (3,0S)                                                                   209905
     C                   PARM                    PNTCE                                        209905
      ** First and last day interest flag (1A, from transaction)                              209905
     C                   PARM                    JWIKFLID                                     209905
      ** Round-down interest flag (1A, from transaction)                                      209905
     C                   PARM                    JWIKRDFC                                     209905
      ** Decimal separator (1A, from SDDEALPD)                                                209905
     C                   PARM                    NNDCSP                                       209905
                                                                                              209905
     C                   IF        RETURNCODE <> *BLANKS                                      209905
     C     *LOCK         IN        LDA                                                        209905
     C                   EVAL      DBASE = 905                                                209905
     C                   EVAL      DBFILE = 'ZAVTOTINT'                                       209905
     C                   OUT       LDA                                                        209905
     C                   EXSR      *PSSR                                                      209905
     C                   ENDIF                                                                209905
                                                                                              209905
      ** Generate the deal number of the placing if it has none yet so                        209905
      ** that the associated taking can already be attached to it. Thus,                      209905
      ** reducing the possibility of having takings in MMWFIDDPD that                         209905
      ** belong to a generic placing, that is, deal '000000'. Make sure                       209905
      ** also that the generated deal number is received by the calling                       209905
      ** program to avoid re-generation of deal number for the placing.                       209905
                                                                                              209905
     C                   IF        DDDLNO = *BLANKS                                           209905
     C                   CALLB     'CAGTNXTFID'                                               209905
     C                   PARM                    DDTYPE                                       209905
     C                   PARM      *ZERO         PNXTDEAL                                     209905
     C                   MOVE      PNXTDEAL      DDDLNO                                       209905
     C                   ENDIF                                                                209905
     C                   MOVE      DDDLNO        JWIKLNKN                                     209905
                                                                                              209905
     C                   WRITE     TMPVFIDTD0                                                 209905
                                                                                              209905
     C                   ENDSR                                                                209905
                                                                                              209905
      *****************************************************************                       209905
      /EJECT                                                                                  209905
      ********************************************************************                    209905
      *                                                                  *                    209905
      * SRLogInvTr - Logs the invalid transaction to log file via        *                    209905
      *              APLOGTRAN module                                    *                    209905
      *                                                                  *                    209905
      ********************************************************************                    209905
                                                                                              209905
     C     SRLogInvTr    BEGSR                                                                209905
                                                                                              209905
      ** If support system is active, write invalid transaction to                            209905
      ** log file via APLOGTRAN standard module                                               209905
                                                                                              209905
     C                   EVAL      APTGTTYPE = WMSGTYPE                                       209905
     C                   EVAL      PDealNo = *BLANKS                                          209905
                                                                                              209905
     C                   CALLB     'APLOGTRAN'                                                209905
     C                   PARM      *BLANKS       RetCodeOut                                   209905
     C                   PARM                    HeadIn                                       209905
     C                   PARM                    TRANSDTL                                     209905
     C                   PARM                    Timestamp                                    209905
     C                   PARM                    PDealNo                                      209905
     C                   PARM      *BLANKS       PADealNo                                     209905
                                                                                              209905
     C                   IF        RetCodeOut <> *BLANKS                                      209905
     C     *LOCK         IN        LDA                                                        209905
     C                   EVAL      DBKey = PDealNo                                            209905
     C                   EVAL      DBFile = 'APLOGTRAN'                                       209905
     C                   EVAL      DBase = 908                                                209905
     C                   OUT       LDA                                                        209905
     C                   EXSR      *PSSR                                                      209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   ENDSR                                                                209905
                                                                                              209905
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
 
     C                   RESET                   OKFlagsDS
     C                   RESET                   OKFlagsDS2                                   CDL016
 
     C                   RESET                   AmendOK
 
     C                   RESET                   OKPayInsDS
     C                   RESET                   OKRecInsDS
     C                   RESET                   OKFRAInsDS
 
     C                   RESET                   PayDat
     C                   RESET                   RecDat
 
     C                   CLEAR                   ValidDeal
      ** Numeric fields within 'ValidDeal' have to be reset explicitly as
      **  there are long alpha fileds overlapping these which cause the
      **  CLEAR to put blanks in the numeric fields
     C                   Z-ADD     *ZERO         IKRSTM
     C**********         Z-ADD     *ZERO         IKROBN                                       CSD027
     C                   EVAL      IKROBN = *BLANKS                                           CSD027
     C**********         Z-ADD     *ZERO         IKROCN                                       CSD027
     C                   EVAL      IKROCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         IKPSTM
     C**********         Z-ADD     *ZERO         IKPOBN                                       CSD027
     C                   EVAL      IKPOBN = *BLANKS                                           CSD027
     C**********         Z-ADD     *ZERO         IKPOCN                                       CSD027
     C                   EVAL      IKPOCN = *BLANKS                                           CSD027
     C                   Z-ADD     *ZERO         IKOMDT                         CDL007
 
      ** Have to clear the settlement data structure, or the packed numeric
      ** fields are not initialised correctly.
     C                   CLEAR                   DBPaySttmt
     C                   CLEAR                   DBRecSttmt
     C                   CLEAR                   DBFRASttmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPINVAL - Set up additional fields that are needed on the  *
      *        Valid file record.                                     *
      *                                                               *
      *****************************************************************
 
     C     SETUPINVAL    BEGSR
 
      * Include Header fields that need to be o/p to the Invalid files
     C                   EVAL      DDMsgType  = 'MMLDNI'
     C                   EVAL      DDFOtranID = APFOTranID
     C                   EVAL      DDFOAsocID = APFOAsocID
     C                   EVAL      DDRprLocn  = APRprLocn
     C                   EVAL      DDTMESTMP = TimeStamp
                                                                                CDL007
      * Setup the Last Breakdown User Id                                        CDL007
     C                   IF        CDL007 = 'Y'                                 CDL007
     C                   EVAL      DDBUSR     = IF_BUSR                         CDL007
     C                   ENDIF                                                  CDL007
                                                                                CAP051
      * Setup the Automatic Authorisation Flag                                  CAP051
     C                   IF        CAP051 = 'Y'                                 CAP051
     C                   EVAL      DDAUTH     = IF_AUTH                         CAP051
     C                   ENDIF                                                  CAP051
 
     C                   EVAL      TranStatus = 'F'
 
      /COPY WNCPYSRC,MMLDNIC017
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPDEALN - Set up Deal Number for Inserts                   *
      *                                                               *
      *****************************************************************
 
     C     SETUPDEALN    BEGSR
 
     C                   IF           DDDLNO = *blanks
     C                             OR DDDLNO = *zeros
 
     C                   RESET                   ReturnCode
     C                   CALLB     'CAGETNXTDL'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDDLNO
     C                   PARM      *ZEROS        IKDN38
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLNO'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDDlnoOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      ** If deal number was entered, put it in the file field
     C                   ELSE
     C                   MOVE      DDDLNO        IKDN38
 
     C                   ENDIF
 
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
 
      **For*Inserts,*put*the*Settlement*Instructions*(input*or*defaulted)***    170909
      ***into*the*Valid*file*record*****************************************    170909
                                                                                170909
      * For Inserts and Amends, put the Settlement Instructions (input or       170909
      *  defaulted) into the Valid file record.                                 170909
      * Two DSs (one Pay, one Receive) contain the Settlement Instructions
      *  in contiguous areas, which must be placed into the correct parts
      *  of the Valid file record
     C                   IF        DDACTN = 'I'
     C                             OR (DDACTN = 'A')                            170909
     C                   MOVE      FLRSTM        IKRSTM                                       CGL029
     C                   MOVE      FLPSTM        IKPSTM                                       CGL029
     C                   MOVE      FLRONS        LDNIRecInsEx                                 CGL029
     C                   MOVE      FLPONS        LDNIPayInsEx                                 CGL029
     C                   EVAL      LDNIPayIns =  ESFPayIns                                    CGL029
     C                   EVAL      LDNIRecIns =  ESFRecIns                                    CGL029
     C**********         MOVEL     DBPaySttmt    LDNIPayIns                                   CGL029
     C**********         MOVEL     DBRecSttmt    LDNIRecIns                                   CGL029
     C                   MOVE      FLPOBR        IKPOBR
     C                   MOVE      FLROBR        IKROBR
     C                   MOVE      FLCVMR        IKCVMR
     C                   MOVE      FLPSCY        IKSTCY
     C                   MOVE      FLIC72        IKIC72
     C                   ENDIF
 
      **For*Amends,*put*the*pre-existing*Settlement*Instructions*into*******    170909
      ***the*Valid*file*record**********************************************    170909
      **Two*large*fields*(one*Pay,*one*Receive)*do*most*of*this*but*a*few***    170909
      ***(physically*separate)*fields*also*need*to*be*done******************    170909
     C*******************IF********DDACTN*=*'A'*************                    170909
     C*******************MOVE******DELDRecIns****LDNIRecIns*                    170909
     C*******************MOVE******DELDPayIns****LDNIPayIns*                    170909
     C*******************MOVE******HKPOBR********IKPOBR*****                    170909
     C*******************MOVE******HKROBR********IKROBR*****                    170909
     C*******************MOVE******HKCVMR********IKCVMR*****                    170909
     C*******************MOVE******HKSTCY********IKSTCY*****                    170909
     C*******************MOVE******HKIC72********IKIC72*****                    170909
     C*******************ENDIF******************************                    170909
 
      * For Deletes & Authorises, put the complete (pre-existing) deal
      *  into the Valid file record
     C                   IF           DDACTN = 'D'
     C                             OR DDACTN = 'X'
     C***********        MOVE      DealFilFmt    ValidDeal                                    242553
     C**********         MOVEL     DealFilFmt    ValidDeal                             242553 260027
     C                   MOVEL     DealFil1      ValidDeal                                    260027
     C                   MOVE      DealFil2      ValidDeal                                    260027
     C                   ENDIF
 
      * Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      IKLACT = DDACTN
 
      * Include Header fields that need to be o/p to the Valid file
     C                   EVAL      IKFRNT = APFOTranID
     C                   EVAL      IKAFRT = APFOAsocID
     C                   EVAL      IKREPA = APRprLocn
     C                   EVAL      IKTMESTMP = TimeStamp
                                                                                CDL007
      * Information needed to broken down                                       CDL007
     C                   IF        CDL007 = 'Y'                                 CDL007
     C                                AND DDACTN = 'A'                          CDL007
                                                                                CDL007
      * Update Breakdown User Id with Last Breakdown User Id                    CDL007
     C                   EVAL      IKBUSR = IF_BUSR                             CDL007
                                                                                CDL007
      * Update The Original Maturity Date                                       CDL007
     C                   IF        IKMATD < OLD_MATD                            CDL007
     C                             AND DDTYPE = 'TD'                            CDL007
     C                             OR IKMATD < OLD_MATD                         CDL007
     C                             AND DDTYPE = 'TI'                            CDL007
     C                   EVAL      IKOMDT = OLD_MATD                            CDL007
     C                   EVAL      IKPRIN = *BLANKS                             CDL007
     C                   ENDIF                                                  CDL007
     C                   ENDIF                                                  CDL007
                                                                                CAP051
      * Automatic Authorisation flag                                            CAP051
     C                   IF        CAP051 = 'Y'                                 CAP051
     C                   EVAL      IKAUTH = IF_AUTH                             CAP051
     C                   ENDIF                                                  CAP051
 
     C                   EVAL      TranStatus = 'S'
 
      /COPY WNCPYSRC,MMLDNIC018
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CDL033
      *                                                               *                       CDL033
      * VALIDATEPC  - Routine to validate the data of PChgArr() array *                       CDL033
      *                                                               *                       CDL033
      *****************************************************************                       CDL033
      *                                                                                       CDL033
     C     VALIDATEPC    BEGSR                                                                CDL033
      *                                                                                       CDL033
      ** Check if at least one scheduled date exists and DDIPFQ <> 'Z'                        CDL033
      *                                                                                       CDL033
     C                   IF        (IntPayChgD1 <> *BLANKS and                                CDL033
     C                             DDIPFQ <> 'Z')                                             CDL033
     C                             OR (IntPayChgD2 <> *BLANKS and                             CDL033
     C                             DDIPFQ <> 'Z')                                             CDL033
     C                   ADD       1             Idx                                          CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDIPFQ'                                 CDL033
     C                   EVAL      MsgIDArr(Idx) = 'MMA1246'                                  CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   IF        Idx > 0                                                    CDL033
     C                   GOTO      VALPCEXT                                                   CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** Validate all the scheduled dates                                                     CDL033
      *                                                                                       CDL033
     C                   IF        IntPayChgD1 <> *BLANKS and                                 CDL033
     C                             DDIPFQ = 'Z'                                               CDL033
      *                                                                                       CDL033
      ** MMVMRCHG has the capacity to process 600 elements, however,                          CDL033
      ** only 164 elements are passed by this program.                                        CDL033
      *                                                                                       CDL033
     C                   MOVE      *BLANKS       DatesIn                                      CDL033
     C                   EVAL      %SUBST(DatesIn:1:492)=IntPayChgD1                          CDL033
     C                   EVAL      %SUBST(DatesIn:493:492)=IntPayChgD2                        CDL033
      *                                                                                       CDL033
     C                   MOVE      *BLANKS       PPConfHol                                    CDL033
     C                   EVAL      %SUBST(PPConfHol:1:82)=DLpFRHOds1                          CDL033
     C                   EVAL      %SUBST(PPConfHol:83:82)=DLpFRHOds2                         CDL033
      *                                                                                       CDL033
     C                   CALLB     'MMVMRCHG'                                                 CDL033
     C                   PARM      *BLANKS       ReturnCode                                   CDL033
     C                   PARM      IKDVSD        PvalueDate                                   CDL033
     C                   PARM      IKMATD        PmaturityDate                                CDL033
     C                   PARM      *ZEROS        PControlDate                                 CDL033
     C                   PARM                    BJDFIN                                       CDL033
     C                   PARM      DDACTN        Paction                                      CDL033
     C                   PARM      DDDLNO        PdealNo                                      CDL033
     C                   PARM      IKNIPD        PPrevDate                                    CDL033
     C                   PARM      DDCCY         Pcurrency                                    CDL033
     C                   PARM                    DatesIn                                      CDL033
     C                   PARM                    PPConfHol       600                          CDL033
     C                   PARM                    OklnRatCal                                   CDL033
     C                   PARM                    FldNameArr                                   CDL033
     C                   PARM                    MsgIDArr                                     CDL033
     C                   PARM                    Idx                                          CDL033
     C                   PARM      ' '           IntRate                                      CDL033
     C                   PARM      *BLANKS       PValDateOut                                  CDL033
      *                                                                                       CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C     VALPCEXT      TAG                                                                  CDL033
      *                                                                                       CDL033
     C                   ENDSR                                                                CDL033
      *****************************************************************                       CDL033
      /EJECT                                                                                  CDL033
      *****************************************************************                       CDL033
      *                                                               *                       CDL033
      * VALIDATERC  - Routine to validate the data of RChgArr() array *                       CDL033
      *                                                               *                       CDL033
      *****************************************************************                       CDL033
      *                                                                                       CDL033
     C     VALIDATERC    BEGSR                                                                CDL033
      *                                                                                       CDL033
      ** Check if at least one scheduled date exists and DDRCFR <> 'Z'                        CDL033
      *                                                                                       CDL033
     C                   IF        (IntRatChgD1 <> *BLANKS and                                CDL033
     C                             DDRCFR <> 'Z')                                             CDL033
     C                             OR (IntRatChgD2 <> *BLANKS and                             CDL033
     C                             DDRCFR <> 'Z')                                             CDL033
     C                   ADD       1             Idx                                          CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDRCFR'                                 CDL033
     C                   EVAL      MsgIDArr(Idx) = 'MMA1246'                                  CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   IF        Idx > 0                                                    CDL033
     C                   GOTO      VALRCEXT                                                   CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** Validate all the scheduled dates                                                     CDL033
      *                                                                                       CDL033
     C                   IF        IntRatChgD1 <> *BLANKS and                                 CDL033
     C                             DDRCFR = 'Z'                                               CDL033
      *                                                                                       CDL033
      ** MMVMRCHG has the capacity to process 600 elements, however,                          CDL033
      ** only 164 elements are passed by this program.                                        CDL033
      *                                                                                       CDL033
     C                   MOVE      *BLANKS       DatesIn                                      CDL033
     C                   EVAL      %SUBST(DatesIn:1:492)=IntRatChgD1                          CDL033
     C                   EVAL      %SUBST(DatesIn:493:492)=IntRatChgD2                        CDL033
      *                                                                                       CDL033
     C                   MOVE      *BLANKS       PRConfHol                                    CDL033
     C                   EVAL      %SUBST(PRConfHol:1:82)=DLrFRHOds1                          CDL033
     C                   EVAL      %SUBST(PRConfHol:83:82)=DLrFRHOds2                         CDL033
      *                                                                                       CDL033
     C                   CALLB     'MMVMRCHG'                                                 CDL033
     C                   PARM      *BLANKS       ReturnCode                                   CDL033
     C                   PARM      IKDVSD        PvalueDate                                   CDL033
     C                   PARM      IKMATD        PmaturityDate                                CDL033
     C                   PARM      *ZEROS        PControlDate                                 CDL033
     C                   PARM                    BJDFIN                                       CDL033
     C                   PARM      DDACTN        Paction                                      CDL033
     C                   PARM      DDDLNO        PdealNo                                      CDL033
     C                   PARM      IKRCDT        PPrevDate                                    CDL033
     C                   PARM      DDCCY         Pcurrency                                    CDL033
     C                   PARM                    DatesIn                                      CDL033
     C                   PARM                    PRConfHol       600                          CDL033
     C                   PARM                    OklnRatCal                                   CDL033
     C                   PARM                    FldNameArr                                   CDL033
     C                   PARM                    MsgIDArr                                     CDL033
     C                   PARM                    Idx                                          CDL033
     C                   PARM      'Y'           IntRate                                      CDL033
     C                   PARM      *BLANKS       RValDateOut                                  CDL033
      *                                                                                       CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C     VALRCEXT      TAG                                                                  CDL033
      *                                                                                       CDL033
     C                   ENDSR                                                                CDL033
      *****************************************************************                       CDL033
      /EJECT                                                                                  CDL033
      *****************************************************************                       CDL033
      *                                                               *                       CDL033
      * SetValidDat - Write the records to DLVFRSCPD.                 *                       CDL033
      *                                                               *                       CDL033
      *****************************************************************                       CDL033
      *                                                                                       CDL033
     C     SetValidDat   BEGSR                                                                CDL033
      *                                                                                       CDL033
     C                   EVAL      XFOTRANID = APFOTRANID                                     CDL033
     C                   EVAL      XRPRLOCN  = APRPRLOCN                                      CDL033
     C     492           SUBST     RValDateOut:1 XRDAT164                                     CDL033
     C                   MOVEL     PRConfHol     XRCOH164                                     CDL033
     C     492           SUBST     PValDateOut:1 XPDAT164                                     CDL033
     C                   MOVEL     PPConfHol     XPCOH164                                     CDL033
      *                                                                                       CDL033
      ** Write to valids file                                                                 CDL033
      *                                                                                       CDL033
     C                   WRITE     DLVFRSCD0                                                  CDL033
                                                                                              CDL033
     C                   ENDSR                                                                CDL033
      *****************************************************************                       CDL033
      /EJECT                                                                                  CDL033
      *****************************************************************                       CDL033
      *                                                               *                       CDL033
      * SETLNVLDDAT - Write the records to DLIFRSCPD.                 *                       CDL033
      *                                                               *                       CDL033
      *****************************************************************                       CDL033
      *                                                                                       CDL033
     C     SETLNVLDDAT   BEGSR                                                                CDL033
      *                                                                                       CDL033
     C                   EVAL      SFOTRANID = APFOTRANID                                     CDL033
     C                   EVAL      SRPRLOCN  = APRPRLOCN                                      CDL033
     C                   EVAL      %SUBST(SRDat164:1:492)=IntRatChgD1                         CDL033
     C                   EVAL      %SUBST(SRDat164:493:492)=IntRatChgD2                       CDL033
     C                   EVAL      %SUBST(SRCOH164:1:82)=DLrFRHOds1                           CDL033
     C                   EVAL      %SUBST(SRCOH164:83:82)=DLrFRHOds2                          CDL033
     C                   EVAL      %SUBST(SPDat164:1:492)=IntPayChgD1                         CDL033
     C                   EVAL      %SUBST(SPDat164:493:492)=IntPayChgD2                       CDL033
     C                   EVAL      %SUBST(SPCOH164:1:82)=DLpFRHOds1                           CDL033
     C                   EVAL      %SUBST(SPCOH164:83:82)=DLpFRHOds2                          CDL033
     C                   EVAL      STMESTMP=DDTMESTMP                                         CDL033
      *                                                                                       CDL033
      ** Write to invalid file                                                                CDL033
      *                                                                                       CDL033
     C                   WRITE     DLIFRSCD0                                                  CDL033
      *                                                                                       CDL033
     C                   ENDSR                                                                CDL033
      *****************************************************************                       CDL033
      /EJECT                                                                                  CDL033
      *****************************************************************
      *                                                               *
      * CallMsgHdl - Call the Message Handling module                 *
      *                                                               *
      *****************************************************************
 
     C     CallMsgHdl    BEGSR
 
      ** Set up an array of sequence numbers that correspond to the fields
      **  with errors
 
     C                   Z-ADD     1             Ix
     C                   DO        ArrayMax
 
     C     FldNameArr(Ix)IFNE      *BLANKS
 
     C                   Z-ADD     1             Iy
     C     FldNameArr(Ix)LOOKUP    FieldArr(Iy)                           20
     C                   EVAL      FldNoArr(Ix) = FldSeqArr(Iy)
 
     C                   ELSE
 
     C                   LEAVE
 
     C                   ENDIF
 
     C                   ADD       1             Ix
     C                   ENDDO
 
     C                   RESET                   ReturnCode
 
     C                   MOVEL     DDDLNO        PTranID          20                          CAP033
                                                                                              CAP033
     C                   CALLB     'ZAMSGHNDLE'
      ** Return code (10A, returned to this procedure)
     C                   PARM                    ReturnCode
      ** Deal repair location (1A, from caller)
     C                   PARM                    APRprLocn
      ** Confirm validity to front office (1A, from caller)
     C                   PARM                    APCnfValFO
      ** List of messages (Array of <ArrayMax>x7A message ids - from caller )
     C                   PARM                    MsgIDArr
      ** List of field numbers (Array of <ArrayMax>x2 unsigned integers - from caller)
     C                   PARM                    FldNoArr
      ** List of field names (Array of <ArrayMax>x10A names - from caller)
     C                   PARM                    FldNameArr
      ** List of message data entries (Array of <ArrayMax>x45 - from caller)
     C                   PARM                    MsgDtaArr
      ** Front office transaction identifier (20A, from caller)
     C                   PARM                    APFOTranID
      ** Midas module ID (2A)
     C                   Parm                    ModuleID
      ***Midas*transaction*ID*(6A,*from*caller)********************************************** CAP033
      ** Midas transaction ID (20A, from caller)                                              CAP033
     C***********        PARM                    DDDLNO                                       CAP033
     C                   PARM                    PTranID                                      CAP033
      ** Message file (10A, from caller)
     C                   PARM                    #MsgFile
      ** Action code of transaction (1A, from transaction)
     C                   PARM                    DDACTN
      ** Status of transaction (1A, F=Failure, S=Success)
     C                   PARM                    TranStatus
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    APRespMode
      ** The following three parameters are needed when messages are to
      ** be displayed on a screen
      ** Screen-handling program (10A, from caller)
     C                   PARM                    #ProcPgm
      ** Screen-handling module (10A, from caller)
     C                   PARM                    #ProcMod
      ** Screen-handling procedure (10A, from caller)
     C                   PARM                    #ProcName
      ** The MQSeries queue to send replies to
     C                   PARM                    APRpyQueue
      ** The transaction's timestamp
     C                   PARM                    TimeStamp
      ** Additional Message files to check                                      174855
     C                   PARM                    MsgFarray                      174855
      ** Whether or not to clear the program message queue.                     174855
     C                   PARM                    ClrPgmMsgQ                     174855
 
     C                   ENDSR
      *****************************************************************
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
      * Transaction information in a single large field from source system
     C                   PARM                    Trans500
     C                   PARM                    TransB500                                    209905
     C                   PARM                    TransC500                                    209905
     C                   PARM                    TransD500                                    209905
     C                   PARM                    TransE500                                    209905
     C                   PARM                    TransF500                                    209905
     C                   PARM                    TransG500                                    209905
     C                   PARM                    TransH500                                    209905
     C                   PARM                    TransI500                                    209905
     C                   PARM                    InfData500                     CDL007
      ** Payment/Receipt/FRA/IRS Settlement Instruction from source system
     C                   PARM                    InPaySttmt
     C                   PARM                    InRecSttmt
     C                   PARM                    InFRASttmt
     C                   PARM                    RegData500                                   CER001
     C                   PARM                    ExtData500                     CAP004
      ** Ultimate calling Program/Module/Procedure
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
 
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'
 
      *  Set up the Module ID, used to make the Transaction number unique
     C                   EVAL      ModuleID = 'DL'
 
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
                                                                                CAP011
      ** Access API ICD via access program                                      CAP011
      *  (database error handling done in access program)                       CAP011
     C                   CALLB     'AOAPIR0'                                    CAP011
     C                   PARM      '*DBERR '     @RTCD             7            CAP011
     C                   PARM      '*FIRST '     @OPTN             7            CAP011
     C     SDAPI         PARM      SDAPI         DSFDY                          CAP011
 
     ****Initialise*Data*queue*parms********************************************148855
     C*******************EVAL      DtqLen = 10                                  148855
                                                                                148855
      ** Set up the name of the server/database updater data queue.             148855
     C                   EVAL      DtaQName = 'APLDNIDTQ'                       148855
      *                                                                         CDL007
      ** Access SAR details file to determine if                                CDL007
      ** Deposit Breakdown Penalty is installed                                 CDL007
      *                                                                         CDL007
     C                   MOVEL     'N'           CDL007            1            CDL007
     C                   CALL      'AOSARDR0'                                   CDL007
     C                   PARM      *BLANKS       @RTCD                          CDL007
     C                   PARM      '*VERIFY'     @OPTN                          CDL007
     C                   PARM      'CDL007'      @SARD                          CDL007
     C     SCSARD        PARM      SCSARD        DSFDY                          CDL007
      *                                                                         CDL007
     C     @RTCD         IFEQ      *BLANK                                       CDL007
     C                   MOVEL     'Y'           CDL007                         CDL007
     C                   ENDIF                                                  CDL007
      *                                                                         CAP051
      ** Access SAR details file to determine if                                CAP051
      ** Automatic Authorisation (MM Part) is installed                         CAP051
      *                                                                         CAP051
     C                   MOVEL     'N'           CAP051            1            CAP051
     C                   CALL      'AOSARDR0'                                   CAP051
     C                   PARM      *BLANKS       @RTCD                          CAP051
     C                   PARM      '*VERIFY'     @OPTN                          CAP051
     C                   PARM      'CAP051'      @SARD                          CAP051
     C     SCSARD        PARM      SCSARD        DSFDY                          CAP051
      *                                                                         CAP051
     C     @RTCD         IFEQ      *BLANK                                       CAP051
     C                   MOVEL     'Y'           CAP051                         CAP051
     C                   ENDIF                                                  CAP051
                                                                                              CDL016
      ** Access SAR details file to determine if CDL016 is switched on                        CDL016
      ** (Automatic Rollover of Fixed Term Loan/Deposit)                                      CDL016
                                                                                              CDL016
     C                   CallB     'AOSARDR0'                                                 CDL016
     C                   Parm      *Blanks       PRTCD                                        CDL016
     C                   Parm      '*VERIFY'     POPTN                                        CDL016
     C                   Parm      'CDL016'      PSARD                                        CDL016
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL016
      *                                                                                       CDL016
     C                   Move      'N'           CDL016            1                          CDL016
     C                   If        PRTCD = *Blanks                                            CDL016
     C                   Eval      CDL016 = 'Y'                                               CDL016
     C                   Endif                                                                CDL016
                                                                                              CDL019
      ** Access SAR details file to determine if CDL019 is switched on                        CDL019
      ** (Allow Base Rate Changes on Fixed Deposits/Loans)                                    CDL019
                                                                                              CDL019
     C                   CallB     'AOSARDR0'                                                 CDL019
     C                   Parm      *Blanks       PRTCD                                        CDL019
     C                   Parm      '*VERIFY'     POPTN                                        CDL019
     C                   Parm      'CDL019'      PSARD                                        CDL019
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL019
      *                                                                                       CDL019
     C                   Move      'N'           CDL019            1                          CDL019
     C                   If        PRTCD = *Blanks                                            CDL019
     C                   Eval      CDL019 = 'Y'                                               CDL019
     C                   Endif                                                                CDL019
                                                                                              CDL020
      ** Access SAR details file to determine if CDL020 is switched on                        CDL020
      ** (Apply Base Rate at Value Date)                                                      CDL020
                                                                                              CDL020
     C                   CallB     'AOSARDR0'                                                 CDL020
     C                   Parm      *Blanks       PRTCD                                        CDL020
     C                   Parm      '*VERIFY'     POPTN                                        CDL020
     C                   Parm      'CDL020'      PSARD                                        CDL020
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDL020
      *                                                                                       CDL020
     C                   Move      'N'           CDL020            1                          CDL020
     C                   If        PRTCD = *Blanks                                            CDL020
     C                   Eval      CDL020 = 'Y'                                               CDL020
     C                   Endif                                                                CDL020
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALL      'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
                                                                                              CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 900                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              209905
      ** Access Dealing ICD and SAR files                                                     209905
                                                                                              209905
     C                   CALLB     'MMFIDINIT'                                                209905
     C                   PARM      *BLANKS       PRTCD                                        209905
                                                                                              209905
      ** Check if S01468 is installed                                                         209905
                                                                                              209905
     C                   CALL      'AOSARDR0'                                                 209905
     C                   PARM      *BLANKS       PRTCD                                        209905
     C                   PARM      '*VERIFY'     POPTN                                        209905
     C                   PARM      'S01468'      PSARD                                        209905
     C     SCSARD        PARM      SCSARD        DSFDY                                        209905
                                                                                              209905
     C                   IF        PRTCD = *BLANKS                                            209905
     C                   EVAL      S01468 = 'Y'                                               209905
     C                   ELSE                                                                 209905
     C                   EVAL      S01468 = 'N'                                               209905
                                                                                              209905
     C                   IF        PRTCD <> '*NRF'                                            209905
     C     *LOCK         IN        LDA                                                        209905
     C                   EVAL      DBKEY = 'S01468'                                           209905
     C                   EVAL      DBFILE = 'SCSARDPD'                                        209905
     C                   EVAL      DBASE = 907                                                209905
     C                   OUT       LDA                                                        209905
     C                   EXSR      *PSSR                                                      209905
     C                   ENDIF                                                                209905
                                                                                              209905
     C                   ENDIF                                                                209905
                                                                                              221989
      ** Check if Fiduciary Dealing is installed                                              221989
                                                                                              221989
     C                   CALL      'AOSARDR0'                                                 221989
     C                   PARM      *BLANKS       PRTCD                                        221989
     C                   PARM      '*VERIFY'     POPTN                                        221989
     C                   PARM      'CDL006'      PSARD                                        221989
     C     SCSARD        PARM      SCSARD        DSFDY                                        221989
                                                                                              221989
     C                   IF        PRTCD = *BLANKS                                            221989
     C                   EVAL      CDL006 = 'Y'                                               221989
     C                   ELSE                                                                 221989
     C                   EVAL      CDL006 = 'N'                                               221989
                                                                                              221989
     C                   IF        PRTCD <> '*NRF'                                            221989
     C     *LOCK         IN        LDA                                                        221989
     C                   EVAL      DBKEY = 'CDL006'                                           221989
     C                   EVAL      DBFILE = 'SCSARDPD'                                        221989
     C                   EVAL      DBASE = 909                                                221989
     C                   OUT       LDA                                                        221989
     C                   EXSR      *PSSR                                                      221989
     C                   ENDIF                                                                221989
                                                                                              221989
     C                   ENDIF                                                                221989
                                                                                              221989
      ** Modules Details                                                                      209905
                                                                                              209905
     C                   CALLB     'AOMMODR0'                                                 209905
     C                   PARM      '*DBERR '     PRTCD                                        209905
     C                   PARM      '*FIRST '     POPTN                                        209905
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        209905
                                                                                              209905
     C                   IF        PRTCD <> *BLANKS                                           209905
     C     *LOCK         IN        LDA                                                        209905
     C                   EVAL      DBKEY = '*FIRST'                                           209905
     C                   EVAL      DBFILE = 'SDMMODPD'                                        209905
     C                   EVAL      DBASE = 903                                                209905
     C                   OUT       LDA                                                        209905
     C                   EXSR      *PSSR                                                      209905
     C                   ENDIF                                                                209905
                                                                                              209905
      ** ICD Portfolio                                                                        209905
                                                                                              209905
     C     BGPFMG        IFEQ      'Y'                                                        217076
     C                   CALLB     'AOPORTR0'                                                 209905
     C                   PARM      '*DBERR '     PRTCD                                        209905
     C                   PARM      '*FIRST '     POPTN                                        209905
     C     SDPORT        PARM      SDPORT        DSFDY                                        209905
                                                                                              209905
     C                   IF        PRTCD <> *BLANKS                                           209905
     C     *LOCK         IN        LDA                                                        209905
     C                   EVAL      DBKEY = '*FIRST'                                           209905
     C                   EVAL      DBFILE = 'SDPORTPD'                                        209905
     C                   EVAL      DBASE = 904                                                209905
     C                   OUT       LDA                                                        209905
     C                   EXSR      *PSSR                                                      209905
     C                   ENDIF                                                                209905
     C                   ENDIF                                                                217076
                                                                                              209905
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      *                                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       @RTCD                                        CSC022
     C                   PARM      '*VERIFY'     @OPTN                                        CSC022
     C                   PARM      'CSC022'      @SARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        @RTCD = *Blanks                                            CSC022
                                                                                              CSC022
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
     C                   ELSE                                                                 CSC022
     C                   IF        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 910                                                CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CDL033
     C                   CALL      'AOSARDR0'                                                 CDL033
     C                   PARM      *BLANKS       PRTCD                                        CDL033
     C                   PARM      '*VERIFY'     POPTN                                        CDL033
     C                   PARM      'CDL033'      PSARD                                        CDL033
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL033
                                                                                              CDL033
     C                   IF        PRTCD = *Blanks                                            CDL033
                                                                                              CDL033
     C                   EVAL      CDL033 = 'Y'                                               CDL033
                                                                                              CDL033
     C                   ELSE                                                                 CDL033
      *                                                                                       CDL033
      ** Database error                                                                       CDL033
     C                   IF        PRTCD <> '*NRF'                                            CDL033
     C     *LOCK         IN        LDA                                                        CDL033
     C                   EVAL      DBKEY = 'CDL033'                                           CDL033
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL033
     C                   EVAL      DBASE = 911                                                CDL033
     C                   OUT       LDA                                                        CDL033
     C                   EXSR      *PSSR                                                      CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** Verify if Hedge Accounting Enhancement is on.                                        CDL033
      *                                                                                       CDL033
     C                   CALLB     'AOSARDR0'                                                 CDL033
     C                   PARM      *BLANKS       PRTCD                                        CDL033
     C                   PARM      '*VERIFY'     POPTN                                        CDL033
     C                   PARM      'CAS005'      PSARD                                        CDL033
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL033
     C                   SELECT                                                               CDL033
     C                   WHEN      PRTCD = *BLANKS                                            CDL033
     C                   MOVE      'Y'           CAS005            1                          CDL033
     C                   WHEN      PRTCD <> '*NRF   '                                         CDL033
     C     *LOCK         IN        LDA                                                        CDL033
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL033
     C                   EVAL      DBASE = 912                                                CDL033
     C                   EVAL      DBKEY = PSARD                                              CDL033
     C                   OUT       LDA                                                        CDL033
     C                   EXSR      *PSSR                                                      CDL033
     C                   OTHER                                                                CDL033
     C                   MOVE      'N'           CAS005                                       CDL033
     C                   ENDSL                                                                CDL033
                                                                                              CDL033
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,MMLDNIC022
      *                                                                                       CER001
      ** Access Module Details to verify if Lux Return feature is active                      CER001
      *                                                                                       CER001
     C                   CALL      'AOMMODR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*FIRST '     @OPTN                                        CER001
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CER001
      *                                                                                       CER001
      ** ULX600 - API Luxembourg - Function MMLDNI                                            CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX600                                       CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX600'      @SARD                                        CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANKS                                                    CER001
     C     BGLRIN        ANDEQ     'Y'                                                        CER001
     C                   MOVEL     'Y'           ULX600                                       CER001
     C                   OPEN      MMVLDLX1PD                                                 CER001
     C                   OPEN      MMILDLX1PD                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
                                                                                              247888
      ** Check if CLE025 is installed                                                         247888
                                                                                              247888
     C                   CALL      'AOSARDR0'                                                 247888
     C                   PARM      *BLANKS       @RTCD                                        247888
     C                   PARM      '*VERIFY'     @OPTN                                        247888
     C                   PARM      'CLE025'      @SARD                                        247888
     C     SCSARD        PARM      SCSARD        DSFDY                                        247888
                                                                                              247888
     C     @RTCD         IFEQ      *BLANK                                                     247888
     C                   MOVEL     'Y'           CLE025            1                          247888
     C                   ELSE                                                                 247888
     C                   MOVEL     'N'           CLE025                                       247888
     C                   ENDIF                                                                247888
                                                                                              247888
 
     C/COPY WNCPYSRC,MMH00025
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
