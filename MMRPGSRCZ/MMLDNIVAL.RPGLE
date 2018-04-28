     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Loans/deposits validation')                   *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMLDNIVAL - MM Loans/Deposits Validation                     *
      *                                                               *
      *  Function: This Program Validates MM Deals for Input into     *
      *            the Midas database.                                *
      *            The sequence of validation is based on subroutine  *
      *            #ZI in Midas program MM0089.                       *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. MD030409           Date 03Dec14               *
      *  Prev Amend No. MD029724           Date 03Dec14               *
      *                 MD031408           Date 25Nov14               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 01Sep14               *
      *                 MD025884           Date 19Aug14               *
      *                 MD027019           Date 19May14               *
      *                 CDL093             Date 08Apr14               *
      *                 CDL015             Date 27Aug13               *
      *                 245692             Date 12Dec13               *
      *                 MD023416           Date 16Nov13               *
      *                 MD023258           Date 06Nov13               *
      *                 MD000091           Date 14May13               *
      *                 AR1069531          Date 08Feb13               *
      *                 AR1049767          Date 07Feb13               *
      *                 AR569568           Date 22Nov12               *
      *                 AR947093           Date 26Apr12               *
      *                 AR953104           Date 14Apr12               *
      *                 AR941424           Date 28Mar12               *
      *                 AR847249           Date 28Jan12               *
      *                 AR937857           Date 25Mar12               *
      *                 AR910937           Date 27Feb12               *
      *                 AR917892           Date 21Feb12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR876535           Date 11Dec11               *
      *                 AR837654           Date 02Oct11               *
      *                 AR834585           Date 28Sep11               *
      *                 CRE073             Date 06Dec10               *
      *                 259981             Date 15May09               *
      *                 CER059             Date 19Jul10               *
      *                 BUG25287           Date 03Aug09               *
      *                 BUG23732           Date 23Apr09               *
      *                 CER054             Date 07Apr09               *
      *                 BUG23437           Date 20Mar08               *
      *                 BUG23048           Date 09May08               *
      *                 CER048             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 260340             Date 23May09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 247452             Date 05Jul07               *
      *                 249905             Date 29Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 243842             Date 29Nov06               *
      *                 BUG5169            Date 04Oct06               *
      *                 GBO005             Date 15Sep06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 240477             Date 16Jun06               *
      *                 238009             Date 17Feb06               *
      *                 CGL058             Date 30Jun06               *
      *                 CDL013             Date 08Jun06               *
      *                 CDL049             Date 11Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10810           Date 21Mar06               *
      *                 BUG10704           Date 13Mar06               *
      *                 BUG10661           Date 23Feb06               *
      *                 BUG10343           Date 06Feb06               *
      *                 BUG9827            Date 13Jan05               *
      *                 CAP087             Date 12Sep05               *
      *                 BUG9717            Date 29Dec05               *
      *                 BUG8582            Date 22Sep05               *
      *                 CDL038             Date 10May05               *
      *                 BUG8239            Date 30Aug05               *
      *                 CDL033             Date 10Feb05               *
      *                 CDL029A            Date 09May05               *
      *                 CSW037A            Date 02May05               *
      *                 CAS008             Date 16Jun04               *
      *                 BUG6459            Date 04Apr05               *
      *                 BUG5813            Date 30Mar05               *
      *                 BUG5508            Date 08Mar05               *
      *                 BUG6124            Date 03Mar05               *
      *                 BUG5517            Date 19Jan05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CDL029             Date 23NOV04               *
      *                 CMM105             Date 22Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL019             Date 03Feb04               *
      *                 CDL018             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CDL016             Date 03Feb04               *
      *                 BUG2310            Date 29Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 217845             Date 04Jun03               *
      *                 215264             Date 28Feb03               *
      *                 CAS005             Date 16Dec02               *
      *                 CDL010             Date 02Aug02               *
      *                 CDL011             Date 07Jul02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 208051             Date 02Aug02               *
      *                 191138             Date 18Jun02               *
      *                 194650             Date 24May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      *                 CSC011             Date 18Sep01               *
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 03Apr00               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      *                 CRE007             Date 01Mar01               *
      *                 CPB002             Date 08Aug00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 180191             Date 22Jun00               *
      * Midas DBA 3.02 Patch Z ---------------------------------------*
      *                 177547             Date 07Apr00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CGL011             Date 20Sep99               *
      *                 CSE006             Date 11May99               *
      *                 CAP051             DATE 09Nov99               *
      *                 CDL007             DATE 05Oct99               *
      *                 CPB001             Date 02Sep99               *
      *                 164565             Date 09Aug99               *
      *                 162441             Date 15Jun99               *
      *                 151977             Date 10Jun99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 154477             Date 29Jan99               *
      *                 CAP004             Date 07Sep98               *
      *                 CAP003             Date 05May98               *
      *                 CAP002  *CREATE    Date 06OCT97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD030409 - MM Rollover (RODL) of the deposit should only be  *
      *             allowed at the maturity date of the deposit when  *
      *             Taxable Indicator equal to 'A' and EU Tax status  *
      *             equal to T (Threshold).                           *
      *           - Consider the new Tax indicator value = 'A' in the *
      *             rollover validation when CER069 is ON.            *
      *  MD029724 - Rollover not allowed before maturity for deposits *
      *             with Taxable Indicator not equal to 'T'(Threshold)*
      *           - Include the taxable indicator in the rollover     *
      *             validation                                        *
      *  MD031408 - Serious Midas error when inserting in LDNI.       *
      *             Reverted BUG5517 fix and made input files user    *
      *             controlled to avoid multiple open.                *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD025884 - Bad response from SOAP due to character string    *
      *             substitution error. Removed duplicate BLen        *
      *             retrieval as this is already done in ZAVTOTINT.   *
      *  MD027019 - Replace '0' Total Interest with the calculated    *
      *              interest amount                                  *
      *  CDL093 - MM Interest calculation type 9.                     *
      *  CDL015 - Daily Compounding of Interest                       *
      *  245692 - Incorrect validation of rates when the decimal se-  *
      *           parator in the Dealing ICD was defined as "," ins-  *
      *           tead of ".".                                        *
      *         - Applied for MD23981.                                *
      *  MD023416 - Calculated actual interest is incorrect for deal  *
      *             with base rate and spread                         *
      *  MD023258 - Duplicate error message shown for actual interest *
      *             rate field                                        *
      *  MD000091 - Event Codes Substitution                          *
      *  AR1069531 - Zero interest dealing transactions               *
      *  AR1049767 - Invalid character displayed in error message     *
      *              (Child:AR1049768)                                *
      *  AR569568 - CDL006 is not being passed causing zero amount to *
      *             be valid in Insert.  But in amendment, it will    *
      *             issue an error message MMM0372.(Child: AR569569)  *
      *  AR947093 - Base Rate amendment resulted to 0 interest rate   *
      *  AR953104 - No error message for zero final rate              *
      *  AR941424 - The calculated interest amount becomes zero when  *
      *             only the base rate is used                        *
      *  AR847249 - Negative interest is shown in the main list and   *
      *             Loan Details enquiry screen                       *
      *  AR937857 - Total Interest becomes zero in LDNI and in Deal   *
      *             Enquiry screen                                    *
      *  AR910937 - Discrepancies in Total Interest Field when base   *
      *             rate was used                                     *
      *  AR917892 -  Warning error prompted for CL deal type liquidity*
      *              premium rate field is missing                    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR876535 - Error in Actual Interest Rate as affected by Base *
      *             Rate and rounding details                         *
      *  AR837654 - Inconsistent calculation of total interest and    *
      *             interest rate if base rate is blanks              *
      *  AR834585 - Actual Interest Rate used only the Base Rate      *
      *             and did not include the spread.                   *
      *  CRE073 - Interest Rate Rounding                              *
      *  259981 - Use Base Rate at Value Date for computation of      *
      *           Total Interest                                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG25287 - Strange error message when trying to              *
      *             Authorise/input Deal                              *
      *  BUG23732 - Joint Account Threshold                           *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG23437 - Correct validation of Initial start date and      *
      *             Final maturity date.                              *
      *  BUG23048 - Check tax status from SDACTXPD                    *
      *  CER048 - German Features - Taxes                             *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus; and apply 250597                        *
      *  250597 - Error MMM0117(MMVAUTROLL) is displayed when a deal  *
      *           is amended. Validation of the Automatic Rollover    *
      *           field should be done only if the Automatic Rollover *
      *           feature (S01435)is switched on. Therefore condition *
      *           call to MMVAUTROLL                                  *
      *  260340 - Check Maturity Date to recompute Total Interest     *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  247452 -  Short term not reflected in Actual Interest Rate.  *
      *  249905 - When CDL019 is ON, base rate changes should not be  *
      *           allowed for fixed term deals.                       *
      *  243842 - Display warning message if Rollover Freq = A and    *
      *           SDGELRPD is daily accrual.                          *
      *  BUG5169 - Setup ValidDeal for spread rate needed on VL2.     *
      *  GBO005 - Added Hook: MMLDNIVC19                              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  240477 - Repo field on Java screen not flagged for error.    *
      *  238009 - Authorisation Error on LDNI.  Retrieve Interest     *
      *  CGL058 - Default Branch Code                                 *
      *  CDL013 - Tiered Withholding Tax                              *
      *  CDL049 - Addition of a Reference Rate field                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10810 - Actual intest rate does not display the short     *
      *             term rate entered                                 *
      *  BUG10704 - If entered transaction customer is not valid      *
      *             or does not exist in file, validation of          *
      *             customer VS branch must not be carried out.       *
      *  BUG10661 - Wrong validation for Fiduciary Call Placing       *
      *  BUG10343 - DLC0606B 00001 failed, DBerror in LF/DAMBR        *
      *  BUG9827- Check if CDl006 is switched on                      *
      *  CAP087 - Depot Movement API - Java Wrapper in MidasPlus.     *
      *  BUG9717- Defaulting of class should be done when CDL038      *
      *           feature is currently ON.                            *
      *  BUG8582 -Pass deal type for rollover detail validation       *
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG8239 - Validation error in Money Market. Amount field     *
      *            does not validate for zero input.                  *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  CDL029A- Adding new field                                    *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CAS008 - IAS 39 Enhancements                                 *
      *  BUG6459- Can input trade types when customer de-activated    *
      *  BUG5813- Ignore 'Rolled over deal has matured' warining if   *
      *           an automatic rollover                               *
      *  BUG5508- If N-T-R is -ve, it should only be a warning.       *
      *  BUG6124 - Branch code error when CDL029 is set on.           *
      *  BUG5517- Authorisation Error on LDNI.  Retrieve contents of  *
      *           DTAARA/ZMUSER moved out of INZSR                    *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CDL029 - Midas SD Authorised Booking Branches for Customers  *
      *  CMM105 - Core changes for GBO005                             *
      *         - Fixed Deposits Held Under Lien                      *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:MMLDNIVC14,MMLDNIV090,MMLDNIV087,*
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CDL020 - Apply Base Rate at Value Date                       *
      *           (Recompile)                                         *
      *  CDL019 - Allow Base Rate Changes on Fixed Deposits/Loans     *
      *           (Recompile)                                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposit       *
      *           (Recompile)                                         *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CDL016 - Autumatic Rollover of Fixed Term Loan/Deposit       *
      *  BUG2310 - Interest Calculation Method being changed during   *
      *            input. Apply fix 216373.                           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  217845 - Deal with a negative interest rate debits Accrued   *
      *           Interest Receivable and credits Interest Income.    *
      *  215264 - Deal could not be rollover due to incorrect associa-*
      *           ted deal number.                                    *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.                                     *
      *  CDL011 - Expansion of Customer Number on Dealing Transactions*
      *  208051 - Ensure -ve interest amounts set the negative        *
      *           indicator to 'Y'.                                   *
      *  191138 - System validates base currency rate in amend mode   *
      *           but field is unamendable.  Validate this field only *
      *           when in insert mode.                                *
      *  194650 - Interest Calculation Method defaults to the previous*
      *           deal input.  Default the Interest Calculation method*
      *           to its Deal Currency.                               *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CAP067 - Repurchase Agreements API.                          *
      *  CDE002 - Revenue Analysis                                    *
      *  CSD006 - Use DSSDY as MMVCURCODE *ENTRY parm, not SDCURRPD   *
      *  CRE007 - Base Rate Tax 2001.                                 *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *  180191 - Pass additional parameter BGN4ST to MMVROLLONO      *
      *           (added by Private Banking CPB001)                   *
      *  177547 - Duplicate hook number MMLDNIV002 changed to V093    *
      *  CGL011 - Collateral Processing for Midas DBA                 *
      *  CSE006 - Repurchase Agreement Enhancements.                  *
      *  CAP051 - Automatic Authorisation (MM Part)                   *
      *           Recompiled due to changes in MMVLDNIPD              *
      *  CDL007 - Deposit Breakdown Penalty                           *
      *           Recompiled due to changes in MMVLDNIPD              *
      *  CPB001 - 'Private Banking' Module                            *
      *  164565 - Pass 'Action Code' as parameter to ZAVTOTINT for    *
      *           validation purposes .                               *
      *  162441 - Spread rate not updated on deal with base rate code *
      *  151977 - Program did not recalculate the interest, when the  *
      *           Calculation method was amended.                     *
      *  CDL006 - Fiduciary Dealing.                                  *
      *  154477 - Recompile for change to MMVLDNIPD.                  *
      *  CAP004 - API's Phase 3.                                      *
      *           Add extra parm for Extra Data                       *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs. (RECOMPILED)                           *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
     FSDBRTDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN                                           MD031408
                                                                                              CDL029
     FSDABBCL0  IF   E           K DISK    INFSR(*PSSR)                                       CDL029
     F                                     USROPN                                           MD031408
      ** Midas SD Authorised Booking Branches for Customers)                                  CDL029
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,MMLDNIV089
 
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
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
     D QQACC1        E                     EXTFLD(QQACCD)                                     CGL029
 
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
      ** EXTERNAL DS FOR Trading Data
     D QQACC2        E                     EXTFLD(QQACCD)                                     CGL029
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
      **  Data structure for Portfolio Management ICD File
 
     D SDPCAC        E DS                  EXTNAME(SDPCACPD)
      **  Data structure for Profit Centre Accounting ICD File
 
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
      ** EXTERNAL DS FOR RETAIL DETAILS
     D QQACC3        E                     EXTFLD(QQACCD)                                     CGL029
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
      ** External data structure for portfolio management details
 
     D SDDLST        E DS                  EXTNAME(SDDLSTPD)
      ** EXTERNAL DS FOR DEAL SUBTYPE DETAILS
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** External data structure for customer details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External data structure for currency details
 
     D SDACTX        E DS                  EXTNAME(SDACTXPD)                                MD030409
      ** External data structure for customer details by country of tax                     MD030409
                                                                                            MD030409
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External data structure for branch details
     D QQDFC1        E                     EXTFLD(QQDFAC)                                     CGL029
 
     D SDBROK        E DS                  EXTNAME(SDBROKPD)
      ** External data structure for broker details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
                                                                                CPB002
     D DSLDY         E DS                  EXTNAME(DSLDY)                       CPB002
      * THIRD DS FOR ACCESS PROGRAMS, VERY LONG DATA STRUCTURE                  CPB002
 
     D ValidDeal     E DS                  EXTNAME(MMVLDNIPD)
      * Valid Deals layout
     D   VldBsDyC           2148   2181                                                       CDL096
 
     D ZMUSER          DS            17
     D  ZUSER                  1     10                                                       CDL010
     D  BRC                   11     13
     D  DEPT                  14     16
      *                                                                                       CDL093
     D WDATE9          DS             6                                                       CDL093
     D  WDD9                   1      2  0                                                    CDL093
     D  WMM9                   3      4  0                                                    CDL093
     D  WYY9                   5      6  0                                                    CDL093
 
     D TranIn        E DS                  EXTNAME(MMLDNIPD)
      * Incoming Transaction
     D   BsDayConv           667    700                                                       CDL096
     D   PayCurr             667    696                                                       CDL096
     D     PCurrency                  3A   Dim(10)                                            CDL096
     D                                     Overlay(PayCurr)                                   CDL096
                                                                                CDL007
     D InfData       E DS                  EXTNAME(MMLDIFPD)                    CDL007
     D                                     PREFIX(IF_)                          CDL007
      * MM Extra Data - File (D/B) format                                       CDL007
                                                                                CAP004
     D ExtData       E DS                  EXTNAME(MMLDEXPD)                    CAP004
      * MM Extra Data - File (D/B) format                                       CAP004
     D   SDBSRT      E DS                  EXTNAME(SDBSRTPD)                                  CRE073
      **Base Rate Code details accessed via access programme                                  CRE073
                                                                                CPB002
      **  Front Office (2 First characters determine System Front Office)       CPB002
     D FrontOffice     DS            20                                         CPB002
     D  W_System               1      2                                         CPB002
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status dataarea                                                                 CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
     D/COPY WNCPYSRC,MMLDNIVD01
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
 
      ** Error message fields received as parameters
     D     Msg1        S                   LIKE(#MsgID)
     D     Msg2        S                   LIKE(#MsgID)
     D     Msg2C       S                   LIKE(#MsgID)                                       CDL038
     D     Msg3        S                   LIKE(#MsgID)
     D     Msg4        S                   LIKE(#MsgID)
     D     Msg5        S                   LIKE(#MsgID)
     D     Msg6        S                   LIKE(#MsgID)
     D     Msg7        S                   LIKE(#MsgID)
     D     Msg8        S                   LIKE(#MsgID)                                     BUG23732
     D     PMsg8       S                   LIKE(#MsgID)                                       CER020
     D     PMsg9       S                   LIKE(#MsgID)                                       CER020
     D     PMsg10      S                   LIKE(#MsgID)                                       CER020
 
      ** Warning error message fields received as parameters
     D     WMSGID1     S                   LIKE(#MsgID)
     D     WMSGID2     S                   LIKE(#MsgID)
     D     WMSGID3     S                   LIKE(#MsgID)
     D     WMSGID4     S                   LIKE(#MsgID)
     D     WMSGID5     S                   LIKE(#MsgID)
     D     WMSGID6     S                   LIKE(#MsgID)
     D     WMSGID7     S                   LIKE(#MsgID)
     D*****WMsgId8     S                   LIKE(#MsgID)                              CER048 BUG23732
     D WMsgid8         S                   LIKE(#MsgID)                                       CDL096
     D WMsgDta8        S                   LIKE(#MsgData)                                     CDL096
     D     PWMsgID8    S                   LIKE(#MsgID)                                       CER020
     D     PWMsgID9    S                   LIKE(#MsgID)                                       CER020
 
      ** Error message substitution data received as a parameter
     D MSGDATA         S                   LIKE(#MsgData)
     D MSGDATA2        S                   LIKE(#MsgData)
     D MSGDATA3        S                   LIKE(#MsgData)
     D MSGDATA4        S                   LIKE(#MsgData)
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
      ** Flags to indicate whether transaction fields are valid
      ** These have been declared for all MM0089D3 fields, some may not
      **  actually be needed if the field is not used/not validated
     D OKFlagsDS       DS
     D  DDActnOK                      1A
     D  DDDlnoOK                      1A
     D  DDTypeOK                      1A
     D  DDStypOK                      1A
     D  DDFedFOK                      1A
     D  DDDADNOK                      1A
     D  DDDlDtOK                      1A
     D  DDBrCAOK                      1A
     D  DDBokCOK                      1A
     D  DDLnkNOK                      1A
     D  DDBkCdOK                      1A
     D  DDBrkgOK                      1A
     D  DDRaCDOK                      1A
     D  DDCustOK                      1A
     D  DDVDatOK                      1A
     D  DDMDatOK                      1A
     D  DDNtceOK                      1A
     D  DDAcSqOK                      1A
     D  DDCcyOK                       1A
     D  DDAmnpOK                      1A
     D  DDBRatOK                      1A
     D  DDDRIDOK                      1A
     D  DDDDMROK                      1A
     D  DDBsRCOK                      1A
     D  DDSpRtOK                      1A
     D  DDICMtOK                      1A
     D**DDNgvIOK**********************1A                                                      CDL016
     D  DDROLIOK                      1A                                                      CDL016
     D  DDIPFqOK                      1A
     D  DDNDatOK                      1A
     D  DDTotIOK                      1A
     D  DDIPDMOK                      1A
     D  DDCptIOK                      1A
     D  DDMTaxOK                      1A
     D  DDFUIDOK                      1A
     D  DDFLIdOK                      1A
     D  DDRDFCOK                      1A
     D  DDCDRfOK                      1A
     D  DDCDCHOK                      1A
     D  DDPrfCOK                      1A
     D  DDOrBrOK                      1A
     D  DDPtfROK                      1A
     D  DDAuRoOK                      1A
     D  DDCnNaOK                      1A
     D  DDRoFqOK                      1A
     D  DDRlDNOK                      1A
     D  DDIPdSOK                      1A
     D  DDIMetOK                      1A
     D  DDIScyOK                      1A
     D  DDInSAOK                      1A
     D  DDINosOK                      1A
     D  DDIi72OK                      1A
     D  DDFsrpOK                      1A
     D  DDFsgnOK                      1A
     D  DDFprcOK                      1A
     D  DDPenaOK                      1A                                        CDL007
     D  DDTrnTpOK                     1A                                        CSE006
     D  DDOylcOK                      1A                                                      CAS001
     D  DDLQPROK                      1A                                                      CAS005
     D  DDLQPSOK                      1A                                                      CAS005
     D  DDClasOK                      1A                                                      CDL038
     D  OKPayDat                      1A                                                      CDL096
     D  OKAmtCde                      1A                                                      CDL096
     D  OKFlgPay                     10A                                                      CDL096
      ** Flag(s) to indicate if combinations of transaction fields are valid
     D  DDDltStpOK                    1A
     D  DDISDTOK                      1A                                                      CER020
     D  DDFMDTOK                      1A                                                      CER020
     D  DDORDNOK                      1A                                                      CER020
     D  DDCNSPOK                      1A                                                      CRE073
     D  DDRDMTOK                      1A                                                      CRE073
     D  DDRDFDOK                      1A                                                      CRE073
     D  DDAIROK                       1A                                                    AR876535
 
      ** Error flags from Dates validation routine
     D ErrDealDat      S              1A   INZ('N')
     D ErrValDate      S              1A   INZ('N')
     D ErrMatDate      S              1A   INZ('N')
     D ErrNxInDat      S              1A   INZ('N')
 
      ** Error flags from int settle ccy & 'in' ccy validation routine
     D ErrIntSetc      S              1A   INZ('N')
     D ErrIntin72      S              1A   INZ('N')
 
      ** Error flags from funding details validation routine
     D ErrFundRat      S              1A   INZ('N')
     D ErrFundSgn      S              1A   INZ('N')
     D ErrFundPrf      S              1A   INZ('N')
 
      ** Default Round Down indicators for Branch & Currency
     D BrRdfc          S              1A
 
      ** Portfolio reference (default value, received from AOPLCSR1 in
      ** MMVBOOKCDE, passed to MMVPORTREF)
     D PortRef         S              4A
 
      ** Extended Settlement fields used by MMVVALDATE
     D PMERCD          S            150A
 
      ** Receive / Pay Settlement Currency, Method & Nostro
     D RecSetCcy       S              3A
     D RecSetMeth      S              2S 0
     D***RecNostro       S             12A                                                    CGL029
     D RecNostro       S             18A                                                      CGL029
     D PaySetCcy       S              3A
     D PaySetMeth      S              2S 0
     D***PayNostro       S             12A                                                    CGL029
     D PayNostro       S             18A                                                      CGL029
 
      ** Flag for whether an error was found in the call to ZDATE1
     D ZDATE1Err       S              1A
 
      ** Numeric version of spread/rate
     D @SPRD           S             11P 7
 
      ** A code to indicate the calling function to the lower level modules
     D LDNI            S              4A   INZ('LDNI')
 
      ** Response Mode, received as a parameter from the common header
     D RespMode        S              1A
                                                                                CDL007
      ** Previous Maturity Date                                                 CDL007
     D OLD_IKMATD      S              5P 0 INZ(0)                               CDL007
                                                                                CDL006
     D*******CDL006          S              1A   IMPORT                               CDL006 BUG9827
     D*******CDL006          S              1A                                      BUG9827 BUG10661
     D CDL006          S              1A   EXPORT                                           BUG10661
                                                                                CSE006
      ** Repos indicator                                                        CSE006
     D Repo            S              1A                                        CSE006
 
     D CGL011          S              1A   IMPORT                                             CGL011
                                                                                              CSC011
     D CSC011          S              1A   INZ('N')                                           CSC011
     D WProcDate       S                   LIKE(BJRDNB)                                       CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
                                                                                              CSC011
      ** Define fields used in CAS001                                                         CAS001
     D CAS001          S              1A                                                      CAS001
     D PYCFN           S              6A                                                      CAS001
     D PERTP           S              1A                                                      CAS001
     D CDL013          S              1A                                                      CDL013
                                                                                              CDL010
      ** Fields defined for Enhancement CDL010                                                CDL010
     D CDL010          S              1A                                                      CDL010
                                                                                              CAS001
      ** Define fields used in CAS005                                                         CAS005
                                                                                              CAS005
     D @INTR           S                   LIKE(IKINTR)                                      BUG5508
     D CAS005          S              1A                                                      CAS005
     D PFwRv           S              1A                                                      CAS005
     D PFwYC           S              5A                                                      CAS005
                                                                                              CAS005
     D PFCRv           S              1A                                                      CAS008
                                                                                              CAS008
      ** Fields defined for Enhancement CDL029                                                CDL029
     D CDL029          S              1A                                                      CDL029
                                                                                              CDL029
     D CGL058          S              1A                                                      CGL058
     D CDL033          S              1A                                                      CDL033
     D PCONF           S              1A                                                      CDL033
                                                                                              CDL033
     D CDL038          S              1A                                                     BUG9717
     D CDL049          S              1A                                                      CDL049
      *                                                                                       CER048
     D CER048          S              1A                                                      CER048
      *                                                                                       CER020
      ** Parameters for the Access Object                                                     CER020
      *                                                                                       CER020
     D PDefISFlg       S              1A   INZ('N')                                           CER020
     D PDefFMFlg       S              1A   INZ('N')                                           CER020
     D PDefISVal       S              6P 0                                                    CER020
     D PDefFMVal       S              6P 0                                                    CER020
      *                                                                                       CER020
     D CER020          S              1A                                                      CER020
     D CRE073          S              1A   INZ('N')                                           CRE073
     D TMCNSP          S             11P 7                                                    CRE073
     D NEWSRT          S             11P 7                                                    CRE073
     D NEWFRT          S             11P 7                                                  AR847249
     D PModule         S              6A   INZ('LDNI')                                        CRE073
     D PCurset         S              2P 0                                                    CRE073
     D WWFXRT          S             12A                                                      CRE073
     D DDDCSG          S              1A   INZ('A')                                           CRE073
     D DDDCSGOK        S              1A                                                      CRE073
     D WWBRTT          S             11P 7                                                    CRE073
     D WDDBRTT         S             12A                                                      CRE073
                                                                                            AR910937
     D W@AMNP          S             15P 0                                                  AR910937
     D CDL093          S              1A                                                      CDL093
     D CDL096          S              1A   EXPORT                                             CDL096
                                                                                              CDL096
      ** Warning message data to be passed back to the calling module                         CDL096
     D  WMsgData       S                   LIKE(#MsgData)                                     CDL096
                                                                                              CDL096
      ** Validate Business Day Convention flag                                                CDL096
     D  WValBDC        S              1A                                                      CDL096
                                                                                              CDL096
      ** Index for arrays of error message ids etc                                            CDL096
     D Ix              S                   LIKE(Idx)                                          CDL096
                                                                                              CDL096
      ** Array for error message ids                                                          CDL096
     D MsgIdErr        S                   DIM(ArrayMax)                                      CDL096
     D                                     LIKE(#MsgID)                                       CDL096
                                                                                              CDL096
      ** Array for fields in error                                                            CDL096
     D FldNamErr       S                   DIM(ArrayMax)                                      CDL096
     D                                     LIKE(FldNameArr)                                   CDL096
                                                                                              CDL096
      ** Array for error message ids                                                          CDL096
     D WMsgIdErr       S                   DIM(ArrayMax)                                      CDL096
     D                                     LIKE(MsgIdArr)                                     CDL096
                                                                                              CDL096
      ** Array for fields in error                                                            CDL096
     D WFldNamErr      S                   DIM(ArrayMax)                                      CDL096
     D                                     LIKE(FldNameArr)                                   CDL096
                                                                                              CDL096
      ** Array of warning message data                                                        CDL096
     D WMsgDtaErr      S                   DIM(ArrayMax)                                      CDL096
     D                                     LIKE(FldNameArr)                                   CDL096
     D CER069          S              1A                                                    MD030409
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
     D/COPY ZSRSRC,ZFEB29Z1LE                                                                 CDL093
     D/COPY ZSRSRC,ZDATE9Z2LE                                                                 CDL093
     D/COPY ZSRSRC,ZDATE9Z1LE                                                                 CDL093
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,MMLDNIV090
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **  Rename fields to differentiate DEALSDC from SDBRTDL1 fields.
     ISDBRTDD0
     I              LCD                         BRTLCD
     I              LCT                         BRTLCT
     I              CHTP                        BRCHTP
     I*
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      /COPY WNCPYSRC,MMLDNIV001
      *                                                                                      BUG5517
      ****Get*default*branch*and*user*from*ZMUSER**********************             BUG5517 MD031408
     C******DTAARA       DEFINE                  ZMUSER                             BUG5517 MD031408
     C**********         IN        ZMUSER                                           BUG5517 MD031408
     C**********         UNLOCK    ZMUSER                                           BUG5517 MD031408
     C/COPY WNCPYSRC,MMH00143
                                                                                CPB002
      * Defautl Deal Type/Sub type if necessary                                 CPB002
      *                                                                         CPB002
     C     '?'           SCAN      DDCUST                                 01                  CAP067
     C                   IF        *IN01 <> *On                                               CAP067
                                                                                              CAP067
     C                   Eval      P_Cust = *Blanks                             CPB002
     C                   Callb     'AOCUSTR1'                                   CPB002
     C                   Parm      *Blanks       @RTCD                          CPB001
     C                   Parm      '*KEY   '     @OPTN                          CPB002
     C                   Parm      DDCUST        @CUST            10            CPB002
     C                   Parm                    @KEY7             7            CPB002
     C     SDCUST        Parm      SDCUST        DSLDY                          CPB002
      *                                                                         CPB002
     C     @RTCD         Ifeq      *Blanks                                      CPB002
     C     BBPRBA        Andeq     'Y'                                          CPB002
     C                   Movel     BBCUST        P_Cust                         CPB002
     C                   Call      'PBDFST'                                     CPB002
     C                   Parm                    P_Cust            6            CPB002
     C                   Parm      DDTYPE        P_DType           2            CPB002
     C                   Parm      DDSTYP        P_DSType          2            CPB002
     C                   Parm      DDACTN        P_Action          1            CPB002
                                                                                CPB002
      * Defautl Deal Type                                                       CPB002
     C     P_DType       Ifne      *Blanks                                      CPB002
     C                   Eval      DDTYPE = P_DType                             CPB002
     C                   Endif                                                  CPB002
                                                                                CPB002
      * Defautl Deal Sub Type                                                   CPB002
     C     P_DSType      Ifne      *Blanks                                      CPB002
     C                   Eval      DDSTYP = P_DSType                            CPB002
     C                   Endif                                                  CPB002
     C                   Endif                                                  CPB002
                                                                                              CAP067
     C                   ENDIF                                                                CAP067
      *                                                                         CDL038
      *  *-------------------------------*                                      CDL038
      *  * Default Sub Type and Class                                           CDL038
      *  *-------------------------------*                                      CDL038
      *                                                                         CDL038
     C                   IF        CDL038 = 'Y'                                              BUG9717
     C                   EXSR      DSUBTCLAS                                    CDL038
     C                   ENDIF                                                               BUG9717
 
      * Call Validation Modules in Sequence
 
      *  *-------------------------------*
      *  * Validate Deal Type / Sub-Type *  #01
      *  *-------------------------------*
 
      * Reset variables updated by each module before each call
     C                   EXSR      RESETERRS
     C/COPY WNCPYSRC,MMLDNIVC07
 
     C                   CALLB     'MMVDLTPSTP'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    MSG2C                                        CDL038
     C                   PARM                    MSG3
     C                   PARM                    DDTYPEOK
     C                   PARM                    DDTYPE
     C                   PARM                    DDSTYP
     C                   PARM                    DDCLAS                                       CDL038
      ** Type of this transaction function (4A)
     C                   PARM                    LDNI
     C                   PARM                    SDDLST
     C                   PARM                    DDACTN                         CDL006
     C                   PARM                    CDL033                                       CDL033
     C                   PARM      *BLANKS       PWMsgID1          7            CDL006
     C                   PARM                    CDL006                                      BUG9827
 
      /COPY WNCPYSRC,MMLDNIV002
 
      ** Total amount of fiduciary takings should match amount of associated    CDL006
      ** placing.                                                               CDL006
                                                                                CDL006
     C     CDL006        IFEQ      'Y'                                          CDL006
     C     PWMsgID1      ANDNE     *BLANKS                                      CDL006
     C                   ADD       1             WIdx                           CDL006
     C                   EVAL      WFldNamArr(WIdx) = 'DDTYPE'                  CDL006
     C                   EVAL      WMsgIDArr(WIdx) = PWMsgID1                   CDL006
     C                   ENDIF                                                  CDL006
                                                                                CDL006
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTYPE'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   MOVE      'N'           DDTypeOK
     C                   ENDIF
     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSTYP'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   MOVE      'N'           DDSTypOK
     C                   ENDIF
     C     MSG2C         IFNE      *BLANK                                       CDL038
     C                   ADD       1             Idx                            CDL038
     C                   EVAL      FldNameArr(Idx) = 'DDCLAS'                   CDL038
     C                   EVAL      MsgIDArr(Idx) = MSG2C                        CDL038
     C                   MOVE      'N'           DDClasOK                       CDL038
     C                   ENDIF                                                  CDL038
     C     MSG3          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTYPE'
     C                   EVAL      MsgIDArr(Idx) = MSG3
     C                   MOVE      'N'           DDTypeOK
     C                   MOVE      'N'           DDSTypOK
     C                   MOVE      'N'           DDClasOK                       CDL038
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDDltStpOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   Move      DDTYPE        W_Deal_type       2                          CGL011
     C                   Move      IKCOLF        W_Collateral      1                          CGL011
                                                                                              CGL011
      /COPY WNCPYSRC,MMLDNIV003
                                                                                CSE006
     C                   IF        CSE006='Y' and RepoFlag='Y'                  CSE006
                                                                                CSE006
      * Reset variables updated by each module before each call                 CSE006
     C                   EXSR      RESETERRS                                    CSE006
                                                                                CSE006
     C                   EVAL      IKDDMR = DDDDMR                                            CAP087
     C                   CALLB     'MMVRPTY'                                    CSE006
     C                   PARM                    ReturnCode                     CSE006
     C                   PARM                    MSG1                           CSE006
     C                   PARM                    MSG2                           CSE006
     C                   PARM                    MSG3                           CSE006
     C                   PARM                    MSG4                           CSE006
     C                   PARM                    DDTYPE                         CSE006
     C                   PARM                    DDTRTP                         CSE006
     C                   PARM                    IKDRID                         CSE006
     C                   PARM                    DDCUST                         CSE006
                                                                                CSE006
      *C*PY*W*C*YSRC*MMLDNIV002************************                   CSE006177547
      /COPY WNCPYSRC,MMLDNIV093                                                 177547
                                                                                CSE006
     C     MSG1          IFNE      *BLANK                                       CSE006
     C                   ADD       1             Idx                            CSE006
     C                   EVAL      FldNameArr(Idx) = 'DDTRTP'                   CSE006
     C                   EVAL      MsgIDArr(Idx) = MSG1                         CSE006
     C                   MOVE      'N'           DDTRNTPOK                      CSE006
     C                   ENDIF                                                  CSE006
     C     MSG2          IFNE      *BLANK                                       CSE006
     C                   ADD       1             Idx                            CSE006
     C                   EVAL      FldNameArr(Idx) = 'DDTYPE'                   CSE006
     C                   EVAL      MsgIDArr(Idx) = MSG2                         CSE006
     C                   MOVE      'N'           DDTYPEOK                       CSE006
     C                   ENDIF                                                  CSE006
     C     MSG3          IFNE      *BLANK                                       CSE006
     C                   ADD       1             Idx                            CSE006
     C                   EVAL      FldNameArr(Idx) = 'DDTRTP'                   CSE006
     C                   EVAL      MsgIDArr(Idx) = MSG3                         CSE006
     C                   MOVE      'N'           DDTRNTPOK                      CSE006
     C                   MOVE      'N'           DDTYPEOK                       CSE006
     C                   ENDIF                                                  CSE006
     C     MSG4          IFNE      *BLANK                                       CSE006
     C                   ADD       1             Idx                            CSE006
     C                   EVAL      FldNameArr(Idx) = 'DDTRTP'                   CSE006
     C                   EVAL      MsgIDArr(Idx) = MSG4                         CSE006
     C                   MOVE      'N'           DDTRNTPOK                      CSE006
     C                   ENDIF                                                  CSE006
                                                                                CSE006
      ** Use the return code's value to set the field's OK flag                 CSE006
     C                   CALLB     'ZASETOKFLG'                                 CSE006
     C                   PARM                    DDDltStpOK                     CSE006
     C                   PARM                    ReturnCode                     CSE006
     C                   PARM                    WarnGlobal                     CSE006
                                                                                CSE006
     C                   ENDIF                                                  CSE006
 
      *  *----------------------------------*
      *  * Validate Federal funds indicator *  #02
      *  *----------------------------------*
     C                   EXSR      RESETERRS
     C                   CALLB     'MMVFEDFUND'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
      ** Federal funds indicator
     C                   PARM                    DDFedf
      ** Currency code
     C                   PARM                    DDCcy
      ** US Currency code
     C                   PARM                    BLUSCY
 
      /COPY WNCPYSRC,MMLDNIV004
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFEDF'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDFedFOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV005
 
      *  *------------------------*
      *  * Validate Branch Code   *  #04
      *  *------------------------*
     C                   IF        CGL058 <> 'Y'                                              CGL058
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVBKGBRCH'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    BJSBRC
     C                   PARM                    BRC
     C                   PARM                    BRRDFC
     C                   PARM                    DDACTN
     C                   PARM                    DDBRCA
     C                   PARM                    RespMode
     C                   PARM                    IKDBRC
     C                   PARM                    SDBRCH
 
      /COPY WNCPYSRC,MMLDNIV006
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRCA'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      **********                                                                      CDL029 BUG6124
     C**********         IF        CDL029 ='Y'                                        CDL029 BUG6124
      **********                                                                      CDL029 BUG6124
     C*****KBRANCHAUTH   CHAIN     SDABBCL0                           91              CDL029 BUG6124
     C**********         IF        *IN91 = '1'                                        CDL029 BUG6124
     C**********         EVAL      ReturnCode = 'Error'                               CDL029 BUG6124
     C**********         ADD       1             Idx                                  CDL029 BUG6124
     C**********         EVAL      FldNameArr(Idx) = 'DDBRCA'                         CDL029 BUG6124
     C**********         EVAL      MsgIDArr(Idx) = 'FXM7001'                          CDL029 BUG6124
     C**********         END                                                          CDL029 BUG6124
      **********                                                                      CDL029 BUG6124
     C**********         END                                                          CDL029 BUG6124
      **********                                                                      CDL029 BUG6124
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDBRCAOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   ENDIF                                                                CGL058
 
      /COPY WNCPYSRC,MMLDNIV007
     C                   EXSR      VBDYCCY                                                    CDL096
     C                   EXSR      VPAMCNV                                                    CDL096
 
      *  *------------------------*
      *  * Validate All Dates     *  #03
      *  *------------------------*
 
     C                   EXSR      GetTaxInd                                                MD030409
                                                                                            MD030409
     C                   Z-ADD     IKMATD        OLD_IKMATD                     CDL007
     C                   EXSR      RESETERRS
     C                   CALLB     'MMVLDNIDAT'
     C                   PARM                    ReturnCode
      ***Message IDs 1 - 7 (Returned to caller)                                             BUG25287
     C**********         PARM                    Msg1                                       BUG25287
     C**********         PARM                    Msg2                                       BUG25287
     C**********         PARM                    Msg3                                       BUG25287
     C**********         PARM                    Msg4                                       BUG25287
     C**********         PARM                    Msg5                                       BUG25287
     C**********         PARM                    Msg6                                       BUG25287
     C**********         PARM                    Msg7                                       BUG25287
     C**********         PARM                    Msg8                              BUG23732 BUG25287
      ***Warning message IDs 1 - 7 (Returned to caller)                                     BUG25287
     C**********         PARM                    WMsgid1                                    BUG25287
     C**********         PARM                    WMsgid2                                    BUG25287
     C**********         PARM                    WMsgid3                                    BUG25287
     C**********         PARM                    WMsgid4                                    BUG25287
     C**********         PARM                    WMsgid5                                    BUG25287
     C**********         PARM                    WMsgid6                                    BUG25287
     C**********         PARM                    WMsgid7                                    BUG25287
     C**********         PARM                    WMsgid8                             CER048 BUG23732
      ** Message IDs 1 - 7 (Returned to caller)                                             BUG25287
     C                   PARM      *BLANKS       Msg1                                       BUG25287
     C                   PARM      *BLANKS       Msg2                                       BUG25287
     C                   PARM      *BLANKS       Msg3                                       BUG25287
     C                   PARM      *BLANKS       Msg4                                       BUG25287
     C                   PARM      *BLANKS       Msg5                                       BUG25287
     C                   PARM      *BLANKS       Msg6                                       BUG25287
     C                   PARM      *BLANKS       Msg7                                       BUG25287
     C                   PARM      *BLANKS       Msg8                                       BUG25287
      ** Warning message IDs 1 - 7 (Returned to caller)                                     BUG25287
     C                   PARM      *BLANKS       WMsgid1                                    BUG25287
     C                   PARM      *BLANKS       WMsgid2                                    BUG25287
     C                   PARM      *BLANKS       WMsgid3                                    BUG25287
     C                   PARM      *BLANKS       WMsgid4                                    BUG25287
     C                   PARM      *BLANKS       WMsgid5                                    BUG25287
     C                   PARM      *BLANKS       WMsgid6                                    BUG25287
     C                   PARM      *BLANKS       WMsgid7                                    BUG25287
     C                   PARM      *BLANKS       WMsgid8                                      CDL096
     C                   PARM      *BLANKS       WMsgDta8                                     CDL096
      ** Error in deal date flag (1A, returned to caller; contains 'Y'
      ** if errors, 'W' if warnings ONLY)
     C                   PARM                    ErrDealDat
      ** Error in value date flag (1A, returned to caller; contains 'Y'
      ** if errors, 'W' if warnings ONLY)
     C                   PARM                    ErrValDate
      ** Error in Maturity date flag (1A, returned to caller; contains 'Y'
      ** if errors, 'W' if warnings ONLY)
     C                   PARM                    ErrMatDate
      ** Error in Next interest date flag (1A, returned to caller; contains
      ** 'Y' if errors, 'W' if warnings ONLY)
     C                   PARM                    ErrNxInDat
      ** Standard deals file version of deal date (5,0P, returned from
      ** this module)
     C                   PARM                    IKDDND
      ** Standard deals file version of value date (5,0P, returned from
      ** this module)
     C                   PARM                    IKDVSD
      ** Standard deals file version of start/last interest date
      ** (5,0P, returned from this module)
     C                   PARM                    IKSLID
      ** Standard deals file version of maturity date (5,0P, returned by
      ** this module)
     C                   PARM                    IKMATD
      ** Standard Deals File version of next interest payment date
      ** (5,0P, returned from this module)
     C                   PARM                    IKNIPD
      ** Deal date (6A, from transaction)
     C                   PARM                    DDDLDT
      ** Value date (6A, from transaction)
     C                   PARM                    DDVDAT
      ** Maturity date (6A, from transaction)
     C                   PARM                    DDMDAT
      ** Next interest date (6A, from transaction)
     C                   PARM                    DDNDAT
      *                                                                                       CER048
     C                   PARM                    DDDADN                                       CER048
      ***Run*date*(5,0P*(Midas*day*number)*from*SDBANKPD*via*caller)***                       CSC011
     C**********         PARM                    BJRDNB                                       CSC011
      ** Processing Date (either from SDBANKPD or SC24X7)                                     CSC011
     C                   PARM                    WProcDate                                    CSC011
      ** Date format indicator (1A, from SDBANKPD via caller)
     C                   PARM                    BJDFIN
      ** Local Currency code (3A, from SDBANKPD via caller)
     C                   PARM                    BJLCCY
      ** Branch Location Code (3A, from SDBRCHPD)
     C                   PARM                    A8LCCD
      ** Deal currency (3A, from transaction)
     C                   PARM                    DDCCY
      ** Deal type (2A, from transaction)
     C                   PARM                    DDTYPE
      ** Error codes (150A)
     C                   PARM                    PMERCD
      ** Pay - settlement currency (3A, from caller)
     C                   PARM                    PaySetCcy
      ** Pay - our nostro (12A, from caller)
     C                   PARM                    PayNostro
      ** Pay - settlement method (2,0S, from caller)
     C                   PARM                    PaySetMeth
      ** Receive - settlement currency (3A, from caller)
     C                   PARM                    RecSetCcy
      ** Receive - our nostro (12A, from caller)
     C                   PARM                    RecNostro
      ** Receive - settlement method (2,0S, from caller)
     C                   PARM                    RecSetMeth
      ** Interest payment frequency (1A, from transaction)
     C                   PARM                    DDIPFQ
      ** Japanese sub-module on (1A, from caller)
     C                   PARM                    S01391
      ** Global warning flag (1A, from caller)
     C                   PARM                    WarnGlobal
      ** Type of this transaction function (4A)
     C                   PARM                    LDNI
      ** Action Code (1A, from caller)
     C                   PARM                    DDACTN
      ** Flag indicaating if Input Program is MMREPOSIN                         CSE006
     C                   PARM                    RepoFlag                       CSE006
      ** Floating Rate CDs Issued                                                             CDL033
     C                   PARM                    CDL033                                       CDL033
      ** Business Day Convention Currencies                                                   CDL096
     C                   PARM                    PCurrency                                    CDL096
      ** Taxable Indicator                                                                  MD029724
     C                   PARM                    TaxInd            1                        MD029724
 
      /COPY WNCPYSRC,MMLDNIV008
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLDT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDLDT'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF
     C     MSG3          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDVDAT'
     C                   EVAL      MsgIDArr(Idx) = MSG3
     C                   ENDIF
     C     MSG4          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   EVAL      MsgIDArr(Idx) = MSG4
     C                   ENDIF
     C     MSG5          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMDAT'
     C                   EVAL      MsgIDArr(Idx) = MSG5
     C                   ENDIF
     C     MSG6          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNDAT'
     C                   EVAL      MsgIDArr(Idx) = MSG6
     C                   ENDIF
     C     MSG7          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNDAT'
     C                   EVAL      MsgIDArr(Idx) = MSG7
     C                   ENDIF
     C     MSG8          IFNE      *BLANKS                                                  BUG23732
     C                   ADD       1             Idx                                        BUG23732
     C                   EVAL      FldNameArr(Idx) = 'DDVDAT'                               BUG23732
     C                   EVAL      MsgIDArr(Idx) = MSG8                                     BUG23732
     C                   ENDIF                                                              BUG23732
 
     C     WMSGID1       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDDDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
     C                   ENDIF
     C     WMSGID2       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDVDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID2
     C                   ENDIF
     C     WMSGID3       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDVDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID3
     C                   ENDIF
     C     WMSGID4       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDMDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID4
     C                   ENDIF
     C     WMSGID5       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDMDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID5
     C                   ENDIF
     C     WMSGID6       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDNDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID6
     C                   ENDIF
     C     WMSGID7       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDNDAT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID7
     C                   ENDIF
     C*****WMsgId8       IFNE      *BLANK                                            CER048 BUG23732
     C**********         ADD       1             WIdx                                CER048 BUG23732
     C**********         EVAL      WFldNamArr(WIdx) = 'DDVDAT'                       CER048 BUG23732
     C**********         EVAL      WMsgIDArr(WIdx) = WMsgId8                         CER048 BUG23732
     C**********         ENDIF                                                       CER048 BUG23732
     C     WMsgId8       IFNE      *BLANK                                                     CDL096
     C                   ADD       1             WIdx                                         CDL096
     C                   EVAL      WFldNamArr(WIdx) = 'DDNDAT'                                CDL096
     C                   EVAL      WMsgIDArr(WIdx) = WMsgId8                                  CDL096
     C                   EVAL      WMsgDtaArr(WIdx) = WMsgDta8                                CDL096
     C                   ENDIF                                                                CDL096
 
      ** Convert the 'field in error' flags to set the 'field OK' flags
      ** N.B. This is non-standard processing and takes the place of the
      **  call(s) to ZASETOKFLG.
     C                   CALLB     'ZACVTFLG'
     C                   PARM                    DDDlDtOK
     C                   PARM                    ErrDealDat
 
     C                   CALLB     'ZACVTFLG'
     C                   PARM                    DDVDatOK
     C                   PARM                    ErrValDate
 
     C                   CALLB     'ZACVTFLG'
     C                   PARM                    DDMDatOK
     C                   PARM                    ErrMatDate
 
     C                   CALLB     'ZACVTFLG'
     C                   PARM                    DDNDatOK
     C                   PARM                    ErrNxInDat
 
     C                   IF        WMSGID1 <> *BLANK OR WMSGID2 <> *BLANK
     C                             OR WMSGID3 <> *BLANK OR WMSGID4 <> *BLANK
     C                             OR WMSGID5 <> *BLANK
     C                   EVAL      WarnGlobal = 'Y'
     C                   ENDIF
 
     C     DDMDAT        IfNe      *BLANKS                                                    CGL011
     C                   Move      'Y'           W_Maturity        1                          CGL011
     C                   Else                                                                 CGL011
     C                   Move      'N'           W_Maturity                                   CGL011
     C                   Endif                                                                CGL011
 
      /COPY WNCPYSRC,MMLDNIV009
 
      *  *------------------------*
      *  * Validate Book Code     *  #04.5
      *  *------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVBOOKCDE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    MSG3
     C                   PARM                    MSG4
     C                   PARM                    MSGDATA2
     C                   PARM                    MSGDATA3
     C                   PARM                    MSGDATA4
     C                   PARM                    DDBOKC
     C                   PARM                    BNBCOP
     C                   PARM                    FCPORS
     C                   PARM                    BNBKCD
     C                   PARM                    DDCUST
     C                   PARM                    DDPTFR
     C                   PARM                    DDBRCA
     C                   PARM                    FCR997
     C                   PARM                    ERPLCS            7
     C                   PARM                    PortRef
     C                   PARM                    QBCUST
     C                   PARM                    BGPFMG                         CPB001
     C                   PARM                    BGN4ST                         CPB001
 
      /COPY WNCPYSRC,MMLDNIV010
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBOKC'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPTFR'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF
     C     MSGDATA2      IFNE      *BLANK
     C**********         MOVEA     MSGDATA2      MsgDtaArr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATA2))                             MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATA2)                 MD000091
     C                   ENDIF
 
     C     MSG3          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPTFR'
     C                   EVAL      MsgIDArr(Idx) = MSG3
     C                   ENDIF
     C     MSGDATA3      IFNE      *BLANK
     C**********         MOVEA     MSGDATA3      MsgDtaArr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATA3))                             MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATA3)                 MD000091
     C                   ENDIF
 
     C     MSG4          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPTFR'
     C                   EVAL      MsgIDArr(Idx) = MSG4
     C                   ENDIF
     C     MSGDATA4      IFNE      *BLANK
     C**********         MOVEA     MSGDATA4      MsgDtaArr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATA4))                             MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATA4)                 MD000091
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDBokcOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV011
 
      *  *----------------------------------*
      *  * Validate Linked Reference Number *  #04.7
      *  *----------------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVLINKREF'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDLnkN
      ** Decimal separator (1A, from SDDEALPD, via caller
     C                   PARM                    BNDCSP
 
      /COPY WNCPYSRC,MMLDNIV012
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDLNKN'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDLnkNOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      ** Additional fiduciary validation of linked reference                    CDL006
                                                                                CDL006
     C     CDL006        IFEQ      'Y'                                          CDL006
     C     DDLNKNOK      ANDEQ     'Y'                                          CDL006
                                                                                CDL006
     C     DDTYPE        IFEQ      'FL'                                         CDL006
     C     DDTYPE        OREQ      'FT'                                         CDL006
     C     DDTYPE        OREQ      'LP'                                         CDL006
     C     DDTYPE        OREQ      'LT'                                         CDL006
     C     DDTYPE        OREQ      'DP'                                         CDL006
     C     DDTYPE        OREQ      'DT'                                         CDL006
                                                                                CDL006
     C                   CALLB     'MMVLINKFID'                                 CDL006
     C                   PARM                    DDTYPE                         CDL006
     C                   PARM                    DDLNKN                         CDL006
     C                   PARM      *BLANKS       ReturnCode                     CDL006
     C                   PARM      *BLANKS       PErrMsgID1        7            CDL006
     C                   PARM      *BLANKS       PErrMsgID2        7            CDL006
                                                                                CDL006
     C     PErrMsgID1    IFNE      *BLANKS                                      CDL006
     C                   ADD       1             Idx                            CDL006
     C                   EVAL      FldNameArr(Idx) = 'DDLNKN'                   CDL006
     C                   EVAL      MsgIDArr(Idx) = PErrMsgID1                   CDL006
     C                   ENDIF                                                  CDL006
                                                                                CDL006
     C     PErrMsgID2    IFNE      *BLANKS                                      CDL006
     C                   ADD       1             Idx                            CDL006
     C                   EVAL      FldNameArr(Idx) = 'DDLNKN'                   CDL006
     C                   EVAL      MsgIDArr(Idx) = PErrMsgID2                   CDL006
     C                   ENDIF                                                  CDL006
                                                                                CDL006
     C                   CALLB     'ZASETOKFLG'                                 CDL006
     C                   PARM                    DDLnkNOK                       CDL006
     C                   PARM                    ReturnCode                     CDL006
     C                   PARM                    WarnGlobal                     CDL006
                                                                                CDL006
     C                   ENDIF                                                  CDL006
                                                                                CDL006
     C                   ENDIF                                                  CDL006
                                                                                CDL006
      /COPY WNCPYSRC,MMLDNIV013
 
      *  *------------------------*
      *  * Validate Broker Code   *  #05
      *  *------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVBROKCDE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDBKCD
     C                   PARM                    IKBKCY
     C                   PARM                    IKBCDP
     C                   PARM                    SDBROK
 
      /COPY WNCPYSRC,MMLDNIV014
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBKCD'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDBkCdOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV015
 
      *  *------------------------*
      *  * Validate R/A Indicator *  #06
      *  *------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVRAIND'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    AUS007
     C                   PARM                    DDRACD
     C                   PARM                    DDBKCD
     C                   PARM                    DDBRKG
     C                   PARM                    DDCCY
     C                   PARM                    BJLCCY
     C                   PARM                    DDBrkgOK
     C                   PARM                    DDACTN
 
      /COPY WNCPYSRC,MMLDNIV016
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRACD'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDRACDOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV017
 
      *  *------------------------*
      *  * Validate Brokerage     *  #07
      *  *------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVBROKAGE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDBKCD
     C                   PARM                    DDBKCDOk
     C                   PARM                    DDBRKG
     C                   PARM                    AUS007
     C                   PARM                    DDRACD
     C                   PARM                    DDRACDOk
     C                   PARM                    DDCCY
     C                   PARM                    IKBKCY
     C                   PARM                    IKBRKG
     C                   PARM                    IKBKCY
     C                   PARM                    DDTYPE
      ** Decimal separator (1A, from SDDEALPD, via caller
     C                   PARM                    BNDCSP
 
      /COPY WNCPYSRC,MMLDNIV018
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRKG'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDBrkgOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV019
                                                                                CDL007
      *  *-------------------------------------------*                          CDL007
      *  * Validate Penalty Amount                   *                          CDL007
      *  *-------------------------------------------*                          CDL007
                                                                                CDL007
      ** If Deposit Breakdown Penalty feature is switched ON                    CDL007
     C     CDL007        IFEQ      'Y'                                          CDL007
     C                   EXSR      RESETERRS                                    CDL007
                                                                                CDL007
     C                   CALLB     'MMVPNAM'                                    CDL007
     C                   PARM                    ReturnCode                     CDL007
     C                   PARM                    MSG1                           CDL007
     C                   PARM                    WMSGID1                        CDL007
      ** Action Code (1A, from transaction)                                     CDL007
     C                   PARM                    DDACTN                         CDL007
      ** Penalty Amount (14A, from transaction)                                 CDL007
     C                   PARM                    DDPENA                         CDL007
      ** Currency OK flag (1A)                                                  CDL007
     C                   PARM                    DDCcyOK                        CDL007
      ** Decimal places (2,0 from transaction)                                  CDL007
     C                   PARM                    IKCYDP                         CDL007
      ** Deal type (2A from Transaction)                                        CDL007
     C                   PARM                    DDTYPE                         CDL007
      ** Penalty Amount (13,0 from transaction)                                 CDL007
     C                   PARM                    IKPENA                         CDL007
      ** Maturity Date (5,0 from transaction)                                   CDL007
     C                   PARM                    IKMATD                         CDL007
      ** Previous Maturity Date (5,0 from transaction)                          CDL007
     C                   PARM                    OLD_IKMATD                     CDL007
      ** Currency separator (1A, from SDDEALPD, via caller)                     CDL007
     C                   PARM                    BNDCSP                         CDL007
      ** Response Mode (1A, from common API Header)                             CDL007
     C                   PARM                    RespMode                       CDL007
      ** Private Banking Module indicator (1A from SDMMODPD)                    CDL007
     C                   PARM                    BGN4ST                         CDL007
                                                                                CDL007
     C     MSG1          IFNE      *BLANK                                       CDL007
     C                   ADD       1             Idx                            CDL007
     C                   EVAL      FldNameArr(Idx) = 'DDPENA'                   CDL007
     C                   EVAL      MsgIDArr(Idx) = MSG1                         CDL007
     C                   ENDIF                                                  CDL007
                                                                                CDL007
     C     WMSGID1       IFNE      *BLANK                                       CDL007
     C                   ADD       1             WIdx                           CDL007
     C                   EVAL      WFldNamArr(WIdx) = 'DDPENA'                  CDL007
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1                    CDL007
     C                   EVAL      WarnGlobal = 'Y'                             CDL007
     C                   ENDIF                                                  CDL007
                                                                                CDL007
      ** Use the return code's value to set the field's OK flag                 CDL007
     C                   CALLB     'ZASETOKFLG'                                 CDL007
     C                   PARM                    DDPenaOK                       CDL007
     C                   PARM                    ReturnCode                     CDL007
     C                   PARM                    WarnGlobal                     CDL007
     C                   ENDIF                                                  CDL007
 
      /COPY WNCPYSRC,MMLDNIV094
 
      *  *------------------------*
      *  * Validate Customer      *  #08
      *  *------------------------*
     C                   EXSR      RESETERRS
 
      ** If this is a Repo use the special validation module...                 CSE006
     C                   IF        CSE006 = 'Y'  and  RepoFlag = 'Y'            CSE006
                                                                                CSE006
     C/COPY WNCPYSRC,MMH00021
     C                   CALLB     'MMVRPCS'                                    CSE006
     C                   PARM                    ReturnCode                     CSE006
     C                   PARM                    MSG1                           CSE006
     C                   PARM                    MSG2                           CSE006
     C                   PARM                    CustFormat                     CSE006
     C                   PARM                    DDACTN                         CSE006
     C                   PARM                    DDCUST                         CSE006
     C                   PARM                    DDTYPE                         CSE006
     C                   PARM                    IKCNUM                         CSE006
     C                   PARM                    IKCSNM                         CSE006
     C                   PARM                    SDCUST                         CSE006
                                                                                CSE006
     C/COPY WNCPYSRC,MMH00022
      ** ... else use the normal Loans/Deposits validation module.              CSE006
     C                   ELSE                                                   CSE006
     C/COPY WNCPYSRC,MMLDNIVC17
                                                                                CSE006
     C                   CALLB     'MMVLDNICUS'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    CustFormat
     C                   PARM                    DDCUST
     C                   PARM                    DDTYPE
     C                   PARM                    IKCNUM
     C                   PARM                    IKCSNM
     C                   PARM                    SDCUST
     C                   PARM                    DDACTN                                      BUG6459
 
     C/COPY WNCPYSRC,MMH00023
     C                   ENDIF                                                  CSE006
                                                                                CSE006
      /COPY WNCPYSRC,MMLDNIV020
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCUST'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCUST'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDCustOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *                                                                                      BUG6124
     C                   IF        CDL029 ='Y'                                               BUG6124
     C                             AND DDCustOK = 'Y'                                       BUG10704
      *                                                                                      BUG6124
     C                   MOVEL     *BLANKS       W0BRCD                                      CDL029A
     C                   MOVEL     BBCUST        W0CUST                                      CDL029A
      *                                                                                      CDL029A
     C                   OPEN      SDABBCL0                                                 MD031408
     C     KBRANCHAUTH   CHAIN     SDABBCL0                           91                     CDL029A
      *                                                                                      CDL029A
     C                   IF        *IN91 = '1'                                               CDL029A
      *                                                                                      CDL029A
     C                   MOVEL     BBBRCD        W0BRCD                                      CDL029A
     C                   MOVEL     *BLANKS       W0CUST                                      CDL029A
      *                                                                                      CDL029A
     C     KBRANCHAUTH   CHAIN     SDABBCL0                           91                     BUG6124
      *                                                                                      CDL029A
     C                   ENDIF                                                               CDL029A
     C                   CLOSE     SDABBCL0                                                 MD031408
      *                                                                                      CDL029A
     C                   IF        *IN91 = '1'                                               BUG6124
     C                   EVAL      ReturnCode = 'Error'                                      BUG6124
     C                   ADD       1             Idx                                         BUG6124
     C                   EVAL      FldNameArr(Idx) = 'DDBRCA'                                BUG6124
     C                   EVAL      MsgIDArr(Idx) = 'FXM7001'                                 BUG6124
     C                   END                                                                 BUG6124
      *                                                                                      BUG6124
      ** Use the return code's value to set the field's OK flag                              CDL029A
     C                   CALLB     'ZASETOKFLG'                                              CDL029A
     C                   PARM                    DDBRCAOK                                    CDL029A
     C                   PARM                    ReturnCode                                  CDL029A
     C                   PARM                    WarnGlobal                                  CDL029A
      *                                                                                      CDL029A
     C                   END                                                                 BUG6124
      *                                                                                      BUG6124
                                                                                CDL006
     C     CDL006        IFEQ      'Y'                                          CDL006
     C     DDCustOk      ANDEQ     'Y'                                          CDL006
     C     DDTYPE        IFEQ      'FL'                                         CDL006
     C     DDTYPE        OREQ      'FT'                                         CDL006
     C     DDTYPE        OREQ      'LP'                                         CDL006
     C     DDTYPE        OREQ      'LT'                                         CDL006
     C     DDTYPE        OREQ      'DP'                                         CDL006
     C     DDTYPE        OREQ      'DT'                                         CDL006
                                                                                CDL006
     C                   CALLB     'MMVCUSTFID'                                 CDL006
     C                   PARM                    DDTYPE                         CDL006
     C                   PARM                    DDCUST                         CDL006
     C                   PARM                    SDCUST                         CDL006
     C                   PARM      *BLANKS       ReturnCode                     CDL006
     C                   PARM      *BLANKS       PErrMsgID1        7            CDL006
     C                   PARM      *BLANKS       PErrMsgID2        7            CDL006
     C                   PARM      *BLANKS       PWMsgID1          7            CDL006
                                                                                CDL006
     C     PErrMsgID1    IFNE      *BLANK                                       CDL006
     C                   ADD       1             Idx                            CDL006
     C                   EVAL      FldNameArr(Idx) = 'DDCUST'                   CDL006
     C                   EVAL      MsgIDArr(Idx) = PErrMsgID1                   CDL006
     C                   ENDIF                                                  CDL006
                                                                                CDL006
     C     PErrMsgID2    IFNE      *BLANK                                       CDL006
     C                   ADD       1             Idx                            CDL006
     C                   EVAL      FldNameArr(Idx) = 'DDCUST'                   CDL006
     C                   EVAL      MsgIDArr(Idx) = PErrMsgID2                   CDL006
     C                   ENDIF                                                  CDL006
                                                                                CDL006
     C     PWMsgID1      IFNE      *BLANK                                       CDL006
     C                   ADD       1             WIdx                           CDL006
     C                   EVAL      WFldNamArr(WIdx) = 'DDCUST'                  CDL006
     C                   EVAL      WMsgIDArr(WIdx) = PWMsgID1                   CDL006
     C**********         EVAL      WMsgDtaArr(WIdx) = DDCUST                         CDL006 MD000091
     C                   EVAL      BLen = %Len(%Trim(DDCUST))                               MD000091
     C                   EVAL      WMsgDtaArr(WIdx) = LenStr +%TRIM(DDCUST)                 MD000091
     C                   ENDIF                                                  CDL006
                                                                                CDL006
     C                   CALLB     'ZASETOKFLG'                                 CDL006
     C                   PARM                    DDCustOK                       CDL006
     C                   PARM                    ReturnCode                     CDL006
     C                   PARM                    WarnGlobal                     CDL006
                                                                                CDL006
     C                   ENDIF                                                  CDL006
     C                   ENDIF                                                  CDL006
 
      /COPY WNCPYSRC,MMLDNIV021
 
      *  *------------------------------------*                                               CGL058
      *  * Default and Validate Branch Code   *  #04.8                                        CGL058
      *  *------------------------------------*                                               CGL058
     C                   IF        CGL058 = 'Y'                                               CGL058
     C                   EXSR      RESETERRS                                                  CGL058
      *                                                                                       CGL058
     C                   CALLB     'MMVABBBRCD'                                               CGL058
     c                   PARM                    DDACTN                                       CGL058
     C                   PARM                    BJSBRC                                       CGL058
     c                   PARM                    DDCUST                                       CGL058
     c                   PARM                    DDBRCA                                       CGL058
      *                                                                                       CGL058
     C                   CALLB     'MMVBKGBRCH'                                               CGL058
     C                   PARM                    ReturnCode                                   CGL058
     C                   PARM                    MSG1                                         CGL058
     C                   PARM                    BJSBRC                                       CGL058
     C                   PARM                    BRC                                          CGL058
     C                   PARM                    BRRDFC                                       CGL058
     C                   PARM                    DDACTN                                       CGL058
     C                   PARM                    DDBRCA                                       CGL058
     C                   PARM                    RespMode                                     CGL058
     C                   PARM                    IKDBRC                                       CGL058
     C                   PARM                    SDBRCH                                       CGL058
                                                                                              CGL058
     C     MSG1          IFNE      *BLANK                                                     CGL058
     C                   ADD       1             Idx                                          CGL058
     C                   EVAL      FldNameArr(Idx) = 'DDBRCA'                                 CGL058
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CGL058
     C                   ENDIF                                                                CGL058
      *                                                                                       CGL058
      ** Use the return code's value to set the field's OK flag                               CGL058
      *                                                                                       CGL058
     C                   CALLB     'ZASETOKFLG'                                               CGL058
     C                   PARM                    DDBRCAOK                                     CGL058
     C                   PARM                    ReturnCode                                   CGL058
     C                   PARM                    WarnGlobal                                   CGL058
     C                   ENDIF                                                                CGL058
                                                                                              CGL058
      *  *------------------------*
      *  * Validate Notice Days   *  #11
      *  *------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVNOTDAYS'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDNTCE
     C                   PARM                    DDMDAT
     C                   PARM                    DDTYPE
     C                   PARM                    IKNTCE
      ** Decimal separator (1A, from SDDEALPD, via caller
     C                   PARM                    BNDCSP
 
      /COPY WNCPYSRC,MMLDNIV022
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNTCE'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDNtceOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV023
                                                                                              CAS001
      *  *------------------------*                                                           CAS001
      *  * Validate Yield Rate    *                                                           CAS001
      *  *------------------------*                                                           CAS001
                                                                                              CAS001
     C                   IF        CAS001 = 'Y' AND                                           CAS001
     C                             DDTypeOK = 'Y' AND                                         CAS001
     C                             DDStypOK = 'Y' AND                                         CDL038
     C                             DDClasOK = 'Y'                                             CDL038
     C*****************************DDStypOK = 'Y'                                      CAS001 CDL038
                                                                                              CAS001
     C                   EXSR      RESETERRS                                                  CAS001
                                                                                              CAS001
     C                   CALLB     'ZAVYLDC01'                                                CAS001
                                                                                              CAS001
      ** Return Code                                                                          CAS001
     C                   PARM                    ReturnCode                                   CAS001
      ** Deal Screen fields                                                                   CAS001
     C                   PARM                    DDTYPE                                       CAS001
     C                   PARM                    DDSTYP                                       CAS001
     C                   PARM                    DDCLAS                                       CDL038
     C                   PARM                    DDOYLC                                       CAS001
      ** Field name                                                                           CAS001
     C                   PARM      'DDOYLC'      PYCFN                                        CAS001
                                                                                              CAS005
      ** Forward/Revaluation Flag                                                             CAS005
                                                                                              CAS005
     C                   PARM      *BLANKS       PFwRv                                        CAS005
                                                                                              CAS005
      ** Forward Yield Curve, to be checked if validating Reval Yield Curve                   CAS005
                                                                                              CAS005
     C                   PARM      *BLANKS       PFwYC                                        CAS005
                                                                                              CAS005
      ** Forward Commitment/Revaluation Flag                                                  CAS008
                                                                                              CAS008
     C                   PARM      *BLANKS       PFCRv                                        CAS008
                                                                                              CAS008
     C                   PARM                    DDOylcOK                                     CAS001
     C                   PARM      *BLANKS       PERTP                                        CAS001
     C                   PARM                    IKOYLC                                       CAS001
                                                                                              CAS001
     C                   IF        ReturnCode <> *Blanks                                      CAS001
     C                   EVAL      Idx = Idx + 1                                              CAS001
     C                   EVAL      FldNameArr(Idx) = 'DDOYLC'                                 CAS001
     C                   IF        PERTP = '1'                                                CAS001
     C                   EVAL      MsgIDArr(Idx) = 'FXM5055'                                  CAS001
     C                   ELSE                                                                 CAS001
     C                   EVAL      MsgIDArr(Idx) = 'FXM5057'                                  CAS001
     C                   ENDIF                                                                CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS001
      ** Use the return code's value to set the field's OK flag                               CAS001
     C                   CALLB     'ZASETOKFLG'                                               CAS001
     C                   PARM                    DDOylcOK                                     CAS001
     C                   PARM                    ReturnCode                                   CAS001
     C                   PARM                    WarnGlobal                                   CAS001
                                                                                              CAS001
     C                   ENDIF                                                                CAS001
 
      *  *------------------------*
      *  * Validate Portfolio Ref *  #12
      *  *------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVPORTREF'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    WMsgID1
     C                   PARM                    DDPTFR
     C                   PARM                    ERPLCS            7
     C                   PARM                    PortRef
     C                   PARM                    FCLIAB
     C                   PARM                    BGPFMG
     C                   PARM                    DDTYPE
     C                   PARM                    DDCustOK
     C                   PARM                    DDBokCOK
     C                   PARM                    FCR997
     C                   PARM                    QBCUST
     C                   PARM                    FCPORS
     C                   PARM                    DDBOKC
     C                   PARM                    BGN4ST                         CPB001
     C                   PARM                    BBPRBA                         CPB001
     C                   PARM                    BBCUST                         CPB001
 
      /COPY WNCPYSRC,MMLDNIV024
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPTFR'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C**********         EVAL      MsgDtaArr(Idx) = BBCUST                        AR1049767 MD000091
     C                   EVAL      BLen = %Len(%Trim(BBCUST))                               MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(BBCUST)                   MD000091
     C                   ENDIF
     C     WMSGID1       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDPTFR'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDPtfROK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV025
 
      *  *-------------------------------*
      *  * Validate Account Sequence No. *  #13
      *  *-------------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVACSEQ'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDACSQ
     C                   PARM                    IKACSQ
      ** Decimal separator (1A, from SDDEALPD, via caller
     C                   PARM                    BNDCSP
 
      /COPY WNCPYSRC,MMLDNIV026
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDACSQ'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDAcSqOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV027
 
      *  *-------------------*
      *  * Validate Currency *  #14
      *  *-------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVCURCODE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDCCY
     C                   PARM                    BGFIIN
     C                   PARM                    BGTRMG
     C****************** PARM                    SDCURR                                       CSD006
     C     SDCURR        PARM                    DSSDY                                        CSD006
 
      /COPY WNCPYSRC,MMLDNIV028
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCCY '
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Set up the file version of the field, if no error.
     C                   IF        ReturnCode = *blank
     C                   Z-ADD     A6NBDP        IKCYDP
     C                   MOVEL     A6INCY        DDccyINCY         1
     C     DDICMT        IFEQ      *BLANKS                                                   BUG2310
     C                   MOVEL     A6DICB        DDICMT                         194650
     C                   ENDIF                                                               BUG2310
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDCcyOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV029
 
      *  *-------------------*
      *  * Validate Amount   *  #15
      *  *-------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVAMOUNT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDAMNP
     C                   PARM                    DDCcyOK
     C                   PARM                    IKCYDP
     C                   PARM                    DDTYPE
     C                   PARM                    IKAMNP
      ** Currency separator (1A, from SDDEALPD, via caller)
     C                   PARM                    BNDCSP
     C                   PARM                    DDACTN                                     AR569568
     C                   PARM                    CDL006                                     AR569568
 
      /COPY WNCPYSRC,MMLDNIV030
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAMNP'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDAMNPOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV031
 
      *  *--------------------------------------*
      *  * Validate Base Currency Exchange Rate *  #16
      *  *--------------------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVBCURRAT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSGDATA
     C                   PARM                    DDBRAT
     C                   PARM                    DDCCY
     C                   PARM                    DDCCYOK
     C                   PARM                    A6SPRT
     C                   PARM                    A6SCEX
     C                   PARM                    A6MDIN
      ** Decimal separator (1A, from SDDEALPD, via caller
     C                   PARM                    BNDCSP
     C                   PARM                    BJCYCD
     C                   PARM                    IKBRAT
     C                   PARM                    IKMMDI
     C                   PARM                    DDACTN                                       191138
 
      /COPY WNCPYSRC,MMLDNIV032
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBRAT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C     MSGDATA       IFNE      *BLANK
     C**********         MOVEA     MSGDATA       MsgDtaArr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATA))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATA)                  MD000091
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDBRatOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV033
 
      *  *---------------------------------*
      *  * Validate Repo/Pledge Ind and no.*  #17
      *  *---------------------------------*
     C                   EXSR      RESETERRS
     C                                                                                        CSE006
     C** Do not call MMVREPO if this is a Repo                                                CSE006
     C                   IF        CSE006 <> 'Y' and RepoFlag <> 'Y'                          CSE006
 
     C                   CALLB     'MMVREPO'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    Msg2
     C                   PARM                    BGSECS
     C                   PARM                    DDDRID
     C                   PARM                    IKCNUM
     C                   PARM                    DDDDMR
     C                   PARM                    IKDRID
     C                   PARM                    IKDDMR
 
      /COPY WNCPYSRC,MMLDNIV034
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
                                                                                              240477
     C     MSG1          IFEQ      'MMM0524'                                                  240477
     C     MSG1          OREQ      'MMM0525'                                                  240477
     C                   EVAL      FldNameArr(Idx) = 'DDDDMR'                                 240477
     C                   ELSE                                                                 240477
     C                   EVAL      FldNameArr(Idx) = 'DDDRID'
     C                   ENDIF                                                                240477
                                                                                              240477
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
                                                                                              240477
     C     MSG2          IFEQ      'MMM0524'                                                  240477
     C     MSG2          OREQ      'MMM0525'                                                  240477
     C                   EVAL      FldNameArr(Idx) = 'DDDDMR'                                 240477
     C                   ELSE                                                                 240477
     C                   EVAL      FldNameArr(Idx) = 'DDDRID'
     C                   ENDIF                                                                240477
                                                                                              240477
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDDRIDOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                                                                                        CSE006
     C                   ENDIF                                                                CSE006
 
      /COPY WNCPYSRC,MMLDNIV035
 
      *  *-------------------------*
      *  * Validate Base Rate Code *  #18
      *  *-------------------------*
     C                   EXSR      RESETERRS
     C/COPY WNCPYSRC,MMLDNIVC15
                                                                                              CDL033
      ** For CF deals, if base rate code has not been                                         CDL033
      ** supplied, flag field as erroneous and bypass                                         CDL033
      ** other validation.                                                                    CDL033
      *                                                                                       CDL033
     C     CDL033        IFEQ      'Y'                                                        CDL033
     C     DDTYPE        ANDEQ     'CF'                                                       CDL033
     C     DDBSRC        ANDEQ     *BLANKS                                                    CDL033
                                                                                              CDL033
     C                   MOVE      *BLANKS       RETURNCODE                                   CDL033
     C                   MOVE      *BLANKS       MSG1                                         CDL033
     C                   MOVE      *BLANKS       WMSGID1                                      CDL033
                                                                                              CDL033
     C                   EVAL      RETURNCODE = 'Error'                                       CDL033
     C                   ADD       1             Idx                                          CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDBSRC'                                 CDL033
     C                   EVAL      MsgIDArr(Idx) = 'MMN9006'                                  CDL033
                                                                                              CDL033
     C                   ELSE                                                                 CDL033
                                                                                              CDL033
 
     C                   EVAL      BaseRate = 0                                             AR837654
     C                   CALLB     'ZAVBRATCDE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
      ** Warning message ID (10A)
     C                   PARM                    WMsgID1
      ** Base rate (11,7P, returned by this module)
     C                   PARM                    BaseRate         11 7
      ** DRS Base rate code (5A, returned by this module, and may be
      ** obsolete long since)
     C                   PARM                    IKDBSR
      ** Base rate code (2A, from transaction)
     C                   PARM                    DDBSRC
      ** Currency OK flag (1A)
     C                   PARM                    DDCcyOK
      ** Deal value date in Midas day number format (5,0P)
     C                   PARM                    IKDVSD
      ** Value date OK flag (1A)
     C                   PARM                    DDVDatOK
      ** Base rate code facility indicator (1A, from SDTRADPD)
     C                   PARM                    BLBRCF
      ** Deal currency (3A, from transaction)
     C                   PARM                    DDCCY
 
      /COPY WNCPYSRC,MMLDNIV036
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDBSRC'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C     WMSGID1       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDBSRC'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
     C                   ENDIF
                                                                                              CDL033
     C                   ENDIF                                                                CDL033
 
     C/COPY WNCPYSRC,MMLDNIVC08
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDBsRCOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV037
 
     C                   IF        CRE073 = 'N'                                               CRE073
      *  *-------------------------------*
      *  * Validate Interest Rate/Spread *  #19
      *  *-------------------------------*
     C                   EXSR      RESETERRS
     C/COPY WNCPYSRC,MMLDNIVC16
 
     C                   CALLB     'ZAVSPRRATE'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
      ** Warning message ID (10A)
     C                   PARM                    WMsgID1
      ** Standard deals file version of rate/spread (11,7P, from/to caller)
     C                   PARM                    IKINTR
      ** Standard deals file version of spread/rate (11,7P, from/to caller)
     C                   PARM                    @SPRD
      ** Spread/rate (12A, from transaction)
     C                   PARM                    DDSPRT
      ** Deal type (2A, from transaction)
     C                   PARM                    DDTYPE
      ** Base rate code (2A, from transaction)
     C                   PARM                    DDBSRC
      ** Base rate OK flag (1A)
     C                   PARM                    DDBsRCOK
      ** Deal date in Midas day number format (5,0P,            )
     C                   PARM                    IKDDND
      ** Value date in Midas day number format (5,0P,            )
     C                   PARM                    IKDVSD
      ** Maturity date in Midas day number format (5,0P,            )
     C                   PARM                    IKMATD
      ** Base rate (11,7P,)
     C                   PARM                    BaseRate
      ** Loan/deposits interest rate tolerance (3,1P, from SDDEALPD)
     C                   PARM                    BNLDIT
      ** Deal currency (3A, from transaction)
     C                   PARM                    DDCCY
      ** Decimal separator (1A, from SDDEALPD)
     C                   PARM                    BNDCSP
      ** Action code                                                                          CDL033
     C                   PARM                    DDACTN                                       CDL033
      ** Called from confirmation screen?                                                     CDL033
     C                   PARM                    PCONF                                        CDL033
 
      /COPY WNCPYSRC,MMLDNIV038
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDSPRT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C     WMSGID1       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDSPRT'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDSpRtOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
      *                                                                                       CRE073
     C                   ELSE                                                                 CRE073
                                                                                              CRE073
      ** Validate Contractual Spread/Sign                                                     CRE073
                                                                                              CRE073
      ** Reset @SPRD field for calculaton of new spread rate                                AR876535
     C                   EVAL      @SPRD = 0                                                AR876535
     C                   EXSR      SRSPSG                                                     CRE073
                                                                                              CRE073
      ** Validate Rounding Method                                                             CRE073
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
     C                   IF        DDCNSPOK = 'Y' AND                                         CRE073
     C                             DDCNSPOK = 'Y' AND                                         CRE073
     C                             DDRDMTOK = 'Y' AND                                         CRE073
     C                             DDRDFDOK = 'Y'                                             CRE073
     C                   EXSR      SRSPRT                                                     CRE073
                                                                                              CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   ENDIF                                                                CRE073
 
      /COPY WNCPYSRC,MMLDNIV039
 
      *  *-----------------------------*
      *  * Validate Calculation Method *  #20
      *  *-----------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'ZAVINTCALC'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDICMT
     C                   PARM                    A6DICB
 
      /COPY WNCPYSRC,MMLDNIV040
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDICMT'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
     C     DDICMT        IFEQ      '9'                                                        CDL093
     C     CDL093        ANDEQ     'Y'                                                        CDL093
                                                                                              CDL093
     C     DDTYPE        IFNE      'IT'                                                       CDL093
     C     DDTYPE        ANDNE     'IP'                                                       CDL093
     C     DDTYPE        ANDNE     'TD'                                                       CDL093
     C     DDTYPE        ANDNE     'TI'                                                       CDL093
     C     DDTYPE        ANDNE     'CD'                                                       CDL093
     C     DDTYPE        ANDNE     'CL'                                                       CDL093
     C                   ADD       1             Idx                                          CDL093
     C                   EVAL      FldNameArr(Idx) = 'DDICMT'                                 CDL093
     C                   EVAL      MsgIDArr(Idx) = '5046271'                                  CDL093
     C                   ENDIF                                                                CDL093
                                                                                              CDL093
     C                   ENDIF                                                                CDL093
                                                                                              CDL093
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDICMTOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV041
 
      *  *--------------------------------------*
      *  * Validate Negative Interest Indicator *  #21
      *  *--------------------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'ZAVNEGINT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDNGVI
 
      /COPY WNCPYSRC,MMLDNIV042
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDNGVI'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C*******************PARM                    DDNgvIOK                                     CDL016
     C                   PARM                    DDNgvIOK          1                          CDL016
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV043
 
      *  *--------------------------------------*
      *  * Validate Interest Payment Frequency  *  #22
      *  *--------------------------------------*
     C                   EXSR      RESETERRS
 
     C/COPY WNCPYSRC,MMLDNIVC09
                                                                                              CDL033
      ** Perform a different validation for CF deals.                                         CDL033
      ** For CF deal, frequecy 'Z' (irregular) is allowed and                                 CDL033
      ** with this frequency, blank interest payment date is                                  CDL033
      ** acceptable.                                                                          CDL033
                                                                                              CDL033
     C     CDL033        IFEQ      'Y'                                                        CDL033
                                                                                              CDL033
     C                   MOVE      *BLANKS       RETURNCODE                                   CDL033
     C                   MOVE      *BLANKS       MSG1                                         CDL033
     C                   MOVE      *BLANKS       MSG2                                         CDL033
      *                                                                                       CDL033
      ** If the next interest date is blank and the interest frequency                        CDL033
      ** is not blank and not 'N', it is an error.                                            CDL033
      *                                                                                       CDL033
     C     DDNDAT        IFEQ      *BLANKS                                                    CDL033
     C     DDIPFQ        ANDNE     *BLANK                                                     CDL033
     C     DDIPFQ        ANDNE     'N'                                                        CDL033
     C     DDTYPE        IFEQ      'CF'                                                       CDL033
     C     DDTYPE        OREQ      'CI'                                                       CDL033
     C     DDTYPE        OREQ      'TD'                                                       CDL033
     C     DDTYPE        OREQ      'TI'                                                       CDL033
     C     DDTYPE        OREQ      'IP'                                                       CDL033
     C     DDTYPE        OREQ      'IT'                                                       CDL033
     C                   EVAL      RETURNCODE = 'Error'                                       CDL033
     C                   ADD       1             Idx                                          CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDNDAT'                                 CDL033
     C                   EVAL      MsgIDArr(Idx) = 'FLR0020'                                  CDL033
     C                   ENDIF                                                                CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** If the interest frequency is not M,Q,X,Y,N,Z or blank,                               CDL033
      ** it is an error.                                                                      CDL033
      *                                                                                       CDL033
     C     DDIPFQ        IFNE      *BLANK                                                     CDL033
     C     DDIPFQ        ANDNE     'M'                                                        CDL033
     C     DDIPFQ        ANDNE     'Q'                                                        CDL033
     C     DDIPFQ        ANDNE     'X'                                                        CDL033
     C     DDIPFQ        ANDNE     'Y'                                                        CDL033
     C     DDIPFQ        ANDNE     'N'                                                        CDL033
     C     DDIPFQ        ANDNE     'Z'                                                        CDL033
     C                   EVAL      RETURNCODE = 'Error'                                       CDL033
     C                   ADD       1             Idx                                          CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDIPFQ'                                 CDL033
     C                   EVAL      MsgIDArr(Idx) = 'MMN9003'                                  CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** Frequency must not be 'N' if date has been entered.                                  CDL033
      *                                                                                       CDL033
     C     DDIPFQ        IFEQ      'N'                                                        CDL033
     C     DDNDAT        ANDNE     *BLANKS                                                    CDL033
     C                   EVAL      RETURNCODE = 'Error'                                       CDL033
     C                   ADD       1             Idx                                          CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDIPFQ'                                 CDL033
     C                   EVAL      MsgIDArr(Idx) = 'MMN9004'                                  CDL033
     C                   ENDIF                                                                CDL033
      *                                                                                       CDL033
      ** Frequency must not be 'N' for transaction currency other                             CDL033
      ** than 'AUD'.                                                                          CDL033
      *                                                                                       CDL033
     C     DDIPFQ        IFEQ      'N'                                                        CDL033
     C     DDCCY         ANDNE     'AUD'                                                      CDL033
     C                   EVAL      RETURNCODE = 'Error'                                       CDL033
     C                   ADD       1             Idx                                          CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDIPFQ'                                 CDL033
     C                   EVAL      MsgIDArr(Idx) = 'MMM0437'                                  CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   ELSE                                                                 CDL033
                                                                                              CDL033
     C                   CALLB     'ZAVINTPFRQ'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    Msg2
     C                   PARM                    DDIPFQ
     C                   PARM                    DDNDAT
     C                   PARM                    DDCCY
     C                   PARM                    CDL015                                       CDL015
 
      /COPY WNCPYSRC,MMLDNIV044
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDIPFQ'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDIPFQ'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF
     C/COPY WNCPYSRC,MMLDNIVC10
                                                                                              CDL033
     C                   ENDIF                                                                CDL033
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDIPFqOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV045
 
      *  *--------------------------------*
      *  * Validate Total Interest Amount *  #24
      *  *--------------------------------*
      ***(Only*on*insertion.*Note*that*total*interest*is*not*amendable)** CAP004151977
      *  (Note that total interest is amendable in 'Amend' and 'Insert')        151977
 
     C     DDACTN        IFEQ      'I'                                          CAP004
     C     DDACTN        OREQ      'A'                                          151977
     C     CDL019        ANDEQ     'Y'                                                        249905
     C     DDACTN        OREQ      'A'                                                        260340
     C     OLD_IKMATD    ANDNE     IKMATD                                                     260340
      *  (Need to retrieve interest on Authorise)                               238009
     C     DDACTN        OREQ      'X'                                          238009
     C     CDL019        ANDEQ     'Y'                                                        249905
     C     DDACTN        OREQ      'X'                                                        260340
     C     OLD_IKMATD    ANDNE     IKMATD                                                     260340
     C/COPY WNCPYSRC,MMLDNIVC11
      *                                                                                       CDL033
     C     CDL033        IFEQ      'Y'                                                        CDL033
     C     DDTYPE        ANDEQ     'CF'                                                       CDL033
     C     CDL033        OREQ      'Y'                                                        CDL033
     C     DDTYPE        ANDEQ     'CI'                                                       CDL033
     C     CDL033        OREQ      'Y'                                                        CDL033
     C     DDTYPE        ANDEQ     'IP'                                                       CDL033
     C     CDL033        OREQ      'Y'                                                        CDL033
     C     DDTYPE        ANDEQ     'IT'                                                       CDL033
     C     CDL033        OREQ      'Y'                                                        CDL033
     C     DDTYPE        ANDEQ     'TI'                                                       CDL033
     C     CDL033        OREQ      'Y'                                                        CDL033
     C     DDTYPE        ANDEQ     'TD'                                                       CDL033
                                                                                              CDL033
     C     DDACTN        IFNE      'I'                                                        CDL033
     C     PCONF         OREQ      'Y'                                                        CDL033
     C                   MOVEL     *BLANKS       DDTOTI                                       CDL033
     C                   MOVEL     '*'           DDTOTI                                       CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C     DDSTRT        IFNE      *BLANKS                                                    259981
     C     DDSTRT        ANDNE     '0.0000000'                                                259981
                                                                                              259981
      ** Initialize Actual Interest to *BLANKS                                              BUG10810
                                                                                            BUG10810
     C                   MOVE      *BLANKS       DDAIR                                      BUG10810
                                                                                            BUG10810
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   ENDIF                                                                259981
                                                                                              259981
     C                   EXSR      RESETERRS
 
      ** Validate Actual Interest Rate to assigned the correct interest rate                AR876535
     C                   EXSR      ValidActInt                                              AR876535
                                                                                            AR876535
      ** Inserted the following codes to assigned the correct amount                        AR876535
      ** when calculating for Total Interest same as SETUPVALID subroutine                  AR876535
     C                   IF        (DDAmnpOK <> 'N') AND                                    AR876535
     C                             (DDTotIOK <> 'N')                                        AR876535
                                                                                            AR876535
     C     DDSTRT        IFEQ      *BLANKS                                                  AR876535
                                                                                            AR876535
      **  Set the sign of the Amount and Total Interest depending upon the                  AR876535
      **  type of deal.  Signs of these two fields will always be opposite.                 AR876535
      **  Amount is -ive for a Loan, +ive for a deposit.                                    AR876535
                                                                                            AR876535
     C     DDTYPE        IFEQ      'IP'                                                     AR876535
     C     DDTYPE        OREQ      'TI'                                                     AR876535
     C     DDTYPE        OREQ      'CL'                                                     AR876535
     C     DDTYPE        OREQ      'LN'                                                     AR876535
     C     DDTYPE        OREQ      'DL'                                                     AR876535
                                                                                            AR876535
     C     IKAMNP        IFGT      0                                                        AR876535
     C                   Z-SUB     IKAMNP        IKAMNP                                     AR876535
     C                   ENDIF                                                              AR876535
     C     IKMTTI        IFLT      0                                                        AR876535
     C                   Z-SUB     IKMTTI        IKMTTI                                     AR876535
     C                   ENDIF                                                              AR876535
                                                                                            AR876535
     C                   ELSE                                                               AR876535
                                                                                            AR876535
     C     IKAMNP        IFLT      0                                                        AR876535
     C                   Z-SUB     IKAMNP        IKAMNP                                     AR876535
     C                   ENDIF                                                              AR876535
     C     IKMTTI        IFGT      0                                                        AR876535
     C                   Z-SUB     IKMTTI        IKMTTI                                     AR876535
     C                   ENDIF                                                              AR876535
                                                                                            AR876535
     C                   ENDIF                                                              AR876535
     C                   ENDIF                                                              AR876535
                                                                                            AR876535
     C                   ENDIF                                                              AR876535
                                                                                            BUG10810
      ** If there is a Short term rate provided, do not compute for                         BUG10810
      ** total interest until after short term rate has been processed                      BUG10810
                                                                                            BUG10810
     C     DDSTRT        IFEQ      *BLANKS                                                  BUG10810
     C     DDSTRT        OREQ      '0.0000000'                                                247452
                                                                                              259981
      ** Check if Actual Interest or Spread Rate and Base Rate is present                     259981
                                                                                              259981
      ** Remove this condition to always recalculate total interest                         AR876535
     C*****DDAIR         IFEQ      *BLANKS                                           259981 AR876535
      *                                                                                       259981
     C     DDSPRT        IFEQ      *BLANKS                                                    259981
     C     DDBSRC        OREQ      *BLANKS                                                    259981
     C     CDL020        OREQ      'N'                                                        259981
                                                                                            AR910937
     C                   EVAL      W@AMNP = IKAMNP                                          AR937857
     C     IKAMNP        IFLT      0                                                        AR910937
     C                   Z-SUB     IKAMNP        W@AMNP                                     AR910937
     C                   ENDIF                                                              AR910937
      *                                                                         CSE006
      * Ascertain if there is a 29FEB in the period                                           CDL093
     C                   MOVE      *BLANKS       #29FEB            1                          CDL093
     C                   Z-ADD     IKDVSD        @@DAYN            5 0                        CDL093
     C                   EXSR      ZDATE9                                                     CDL093
     C                   Z-ADD     @@VDT         ZZStartDate                                  CDL093
      *                                                                                       CDL093
     C                   Z-ADD     IKMATD        @@DAYN                                       CDL093
     C                   EXSR      ZDATE9                                                     CDL093
     C                   Z-ADD     @@VDT         ZZEndDate                                    CDL093
                                                                                              CDL093
     C                   EXSR      #FEB29                                                     CDL093
     C                   MOVE      ' '           WRK9              1                          CDL093
     C                   IF        DDICMT = '9'                                               CDL093
     C                             AND (DDTYPE = 'IP' OR DDTYPE = 'IT' OR                     CDL093
     C                                  DDTYPE = 'TD' OR DDTYPE = 'TI')                       CDL093
     C                             AND IKNIPD <> 0                                            CDL093
     C                             AND #29Feb = 'Y'                                           CDL093
     C                   IF        DDTOTI = *BLANKS OR DDTOTI = '*'                           CDL093
     C                             OR DDTOTI = '0'                                   CDL093 MD027019
     C                   MOVE      '*'           WRK9                                         CDL093
     C                   ELSE                                                                 CDL093
      *                                                                                       CDL093
     C                   MOVEL     *BLANKS       ZFIELD                                       CDL093
     C                   MOVEL     DDTOTI        ZFIELD                                       CDL093
     C                   CALLB     'ZALIGN'                                                   CDL093
     C                   PARM                    ZALIGNOK          1                          CDL093
     C                   PARM                    ZFIELD           16                          CDL093
     C                   PARM      A6NBDP        ZADEC             1 0                        CDL093
     C                   PARM      12            ZADIG             2 0                        CDL093
                                                                                              CDL093
     C                   MOVE      ZFIELD        IKMTTI                                       CDL093
     C                   ENDIF                                                                CDL093
     C                   MOVE      ' '           NxtFeb29          1                          CDL093
     C                   GOTO      TAGCALC9                                                   CDL093
     C                   ENDIF                                                                CDL093
      *                                                                                       CDL093
      ** If RepoFlag is Set to 'Y' call New Module MMVTOIT   to process         CSE006
      ** Call Loans and Deposits differently                                    CSE006
     C                   IF        RepoFlag = 'Y'                               CSE006
                                                                                CSE006
     C/COPY WNCPYSRC,MMLDNIVC01
     C                   EXSR      RESETERRS                                                MD023258
     C                   CALLB     'MMVTOIT'                                   CSE006
     C                   PARM                    ReturnCode                     CSE006
     C                   PARM                    MSG1                           CSE006
      ** Message data (45A)                                                     CSE006
     C                   PARM                    MSGDATA                        CSE006
      ** Total interest amount returned from this module (15,0P)                CSE006
     C                   PARM                    IKMTTI                         CSE006
      ** Total interest amount (14A, from transaction)                          CSE006
     C                   PARM                    DDTOTI                         CSE006
      ** Default interest for CL and CD deals with zero notice days             CSE006
      ** feature flag (1A, from SCSARDPD)                                       CSE006
     C                   PARM                    S01468                         CSE006
      ** Deal notice days (3A, from transaction)                                CSE006
     C                   PARM                    DDNTCE                         CSE006
      ** Deal type (2A, from transaction)                                       CSE006
     C                   PARM                    DDTYPE                         CSE006
      ** Interest rate (11,7P,)                                                 CSE006
     C                   PARM                    IKINTR                         CSE006
      ** Deal amount (15,0P, from caller)                                       CSE006
     C*********          PARM                    IKAMNP                              CSE006 AR910937
     C                   PARM                    W@AMNP                                     AR910937
      ** Interest calculation method (1A, from transaction)                     CSE006
     C                   PARM                    DDICMT                         CSE006
      ** Deal value date in Midas day number format (5,0P, )                    CSE006
     C                   PARM                    IKDVSD                         CSE006
      ** Currency FldNameArr OK flag (1A, )                                     CSE006
     C                   PARM                    DDCcyOK                        CSE006
      ** Number of decimal places in deal currency (1,0S, from SDCURRPD)        CSE006
     C                   PARM                    IKCYDP                         CSE006
      ** Value date field OK (1A, )                                             CSE006
     C                   PARM                    DDVDatOK                       CSE006
      ** Notice days field OK (1A, )                                            CSE006
     C                   PARM                    DDNtceOK                       CSE006
      ** Amount field OK (1A, )                                                 CSE006
     C                   PARM                    DDAMNPOK                       CSE006
      ** Base Rate field OK (1A, )                                              CSE006
     C                   PARM                    DDBsRCOK                       CSE006
      ** Spread/Rate field OK (1A, )                                            CSE006
     C                   PARM                    DDSpRtOK                       CSE006
      ** Calculation method field OK (1A, )                                     CSE006
     C                   PARM                    DDICMTOK                       CSE006
      ** Maturity date (6A, from transaction)                                   CSE006
     C                   PARM                    DDMDAT                         CSE006
      ** Maturity date in Midas day number format (5,0P, )                      CSE006
     C                   PARM                    IKMATD                         CSE006
      ** Maturity date field OK (1A, )                                          CSE006
     C                   PARM                    DDMDatOK                       CSE006
      ** Notice days (3,0S, )                                                   CSE006
     C                   PARM                    IKNTCE                         CSE006
      ** First and last day interest flag (1A, from transaction)                CSE006
     C                   PARM                    DDFLID                         CSE006
      ** Round-down interest flag (1A, from transaction)                        CSE006
     C                   PARM                    DDRDFC                         CSE006
      ** Decimal separator (1A, from SDDEALPD)                                  CSE006
     C                   PARM                    BNDCSP                         CSE006
     C/COPY WNCPYSRC,MMLDNIVC02
     C                   ELSE                                                   CSE006
     C/COPY WNCPYSRC,MMLDNIVC06
                                                                                CSE006
     C                   EXSR      RESETERRS                                                MD023258
     C                   CALLB     'ZAVTOTINT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
      ** Action Code (1A, from caller)                                          164565
     C                   PARM                    DDACTN                         164565
      ** Message data (45A)
     C                   PARM                    MSGDATA
      ** Total interest amount returned from this module (15,0P)
     C                   PARM                    IKMTTI
      ** Total interest amount (14A, from transaction)
     C                   PARM                    DDTOTI
      ** Default interest for CL and CD deals with zero notice days
      ** feature flag (1A, from SCSARDPD)
     C                   PARM                    S01468
      ** Deal notice days (3A, from transaction)
     C                   PARM                    DDNTCE
      ** Deal type (2A, from transaction)
     C                   PARM                    DDTYPE
      ** Interest rate (11,7P,)
     C                   PARM                    IKINTR
      ** Deal amount (15,0P, from caller)
     C*********          PARM                    IKAMNP                                     AR910937
     C                   PARM                    W@AMNP                                     AR910937
      ** Interest calculation method (1A, from transaction)
     C                   PARM                    DDICMT
      ** Deal value date in Midas day number format (5,0P, )
     C                   PARM                    IKDVSD
      ** Currency FldNameArr OK flag (1A, )
     C                   PARM                    DDCcyOK
      ** Number of decimal places in deal currency (1,0S, from SDCURRPD)
     C                   PARM                    IKCYDP
      ** Value date field OK (1A, )
     C                   PARM                    DDVDatOK
      ** Notice days field OK (1A, )
     C                   PARM                    DDNtceOK
      ** Amount field OK (1A, )
     C                   PARM                    DDAMNPOK
      ** Base Rate field OK (1A, )
     C                   PARM                    DDBsRCOK
      ** Spread/Rate field OK (1A, )
     C                   PARM                    DDSpRtOK
      ** Calculation method field OK (1A, )
     C                   PARM                    DDICMTOK
      ** Maturity date (6A, from transaction)
     C                   PARM                    DDMDAT
      ** Maturity date in Midas day number format (5,0P, )
     C                   PARM                    IKMATD
      ** Maturity date field OK (1A, )
     C                   PARM                    DDMDatOK
      ** Notice days (3,0S, )
     C                   PARM                    IKNTCE
      ** First and last day interest flag (1A, from transaction)
     C                   PARM                    DDFLID
      ** Round-down interest flag (1A, from transaction)
     C                   PARM                    DDRDFC
      ** Decimal separator (1A, from SDDEALPD)
     C                   PARM                    BNDCSP
     C/COPY WNCPYSRC,MMLDNIVC05
                                                                                CSE006
     C                   ENDIF                                                  CSE006
      *                                                                                       CDL093
     C     TAGCALC9      TAG                                                                  CDL093
     C                   IF        DDICMT = '9'                                               CDL093
     C                             AND (DDTYPE = 'IP' OR DDTYPE = 'IT' OR                     CDL093
     C                                  DDTYPE = 'TD' OR DDTYPE = 'TI')                       CDL093
     C                             AND IKNIPD <> 0                                            CDL093
     C                             AND #29Feb = 'Y'                                           CDL093
      * Call program to calculate interest based on Interest Calculation 9                    CDL093
     C                   MOVE      DDIPDM        @@IPDM            2 0                        CDL093
     C                   CALL      'MM001031'                                                 CDL093
     C                   PARM                    IKDVSD                                       CDL093
     C                   PARM                    IKMATD                                       CDL093
     C                   PARM                    IKNIPD                                       CDL093
     C                   PARM                    DDICMT                                       CDL093
     C                   PARM                    DDIPFQ                                       CDL093
     C                   PARM                    W@AMNP                                       CDL093
     C                   PARM                    IKINTR                                       CDL093
     C                   PARM                    DDRDFC                                       CDL093
     C                   PARM                    DDFLID                                       CDL093
     C                   PARM                    @@IPDM                                       CDL093
     C                   PARM                    WTOTI9           15 0                        CDL093
      *                                                                                       CDL093
     C                   EVAL      Amount13 = WTOTI9                                          CDL093
     C                   EVAL      NbrDecPl1 = A6NBDP                                         CDL093
     C                   CLEAR                   ReturnCode                                   CDL093
                                                                                              CDL093
     C                   CALLB     'ZA0920'                                                   CDL093
     C                   PARM                    ReturnCode       10                          CDL093
     C                   PARM                    Amount13         13 0                        CDL093
     C                   PARM                    NbrDecPl1         1 0                        CDL093
     C                   PARM                    BNDCSP                                       CDL093
     C                   PARM                    AmountOut        14                          CDL093
                                                                                              CDL093
     C                   IF        WRK9 = '*'                                                 CDL093
     C                   MOVEL     AmountOut     DDTOTI                                       CDL093
     C                   ENDIF                                                                CDL093
      *                                                                                       CDL093
      * If entered interest does not match calculated, set up error message                   CDL093
      * specifying this with the correct formatted interest amount                            CDL093
     C                   IF        WTOTI9 <> IKMTTI                                           CDL093
     C                             AND IKMTTI <> 0                                            CDL093
     C                   EVAL      Msg1 = 'MMM0453'                                           CDL093
     C                   MOVEL     AmountOut     MsgData                                      CDL093
     C                   ENDIF                                                                CDL093
      *                                                                                       CDL093
     C                   ENDIF                                                                CDL093
      *                                                                                       CDL093
     C                   ENDIF                                                                259981
     C**********         ENDIF                                                       259981 AR876535
     C                   ENDIF                                                              BUG10810
 
      /COPY WNCPYSRC,MMLDNIV046
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTOTI'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C     MSGDATA       IFNE      *BLANK
     C**********         MOVEA     MSGDATA       MsgDtaArr(Idx)                             MD000091
     C**********         EVAL      BLen = %Len(%Trim(MSGDATA))                     MD000091 MD025884
     C**********         EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATA)         MD000091 MD025884
     C                   EVAL      MsgDtaArr(Idx) = %TRIM(MSGDATA)                          MD025884
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDTotIOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
                                                                                              208051
      ** Set the negative indicator in step with the sign of the interest amount              208051
     C     IKMTTI        IFLT      0                                                          208051
     C                   MOVE      'Y'           DDNGVI                                       208051
     C                   ELSE                                                                 208051
     C                   MOVE      ' '           DDNGVI                                       208051
     C                   ENDIF                                                                208051
     C                   ENDIF                                                  CAP004
 
      /COPY WNCPYSRC,MMLDNIV047
 
      *  *------------------------------------------*
      *  * Validate Interest Frequency Day in Month *  #25
      *  *------------------------------------------*
     C                   EXSR      RESETERRS
 
     C/COPY WNCPYSRC,MMLDNIVC12
                                                                                              CDL033
      ** Perform a different validation for CF deals if                                       CDL033
      ** frequency is 'Z' (irregular).                                                        CDL033
                                                                                              CDL033
     C     CDL033        IFEQ      'Y'                                                        CDL033
     C     DDTYPE        ANDEQ     'CF'                                                       CDL033
     C     DDIPFQ        ANDEQ     'Z'                                                        CDL033
     C     CDL033        OREQ      'Y'                                                        CDL033
     C     DDTYPE        ANDEQ     'CI'                                                       CDL033
     C     DDIPFQ        ANDEQ     'Z'                                                        CDL033
     C     CDL033        OREQ      'Y'                                                        CDL033
     C     DDTYPE        ANDEQ     'IP'                                                       CDL033
     C     DDIPFQ        ANDEQ     'Z'                                                        CDL033
     C     CDL033        OREQ      'Y'                                                        CDL033
     C     DDTYPE        ANDEQ     'IT'                                                       CDL033
     C     DDIPFQ        ANDEQ     'Z'                                                        CDL033
     C     CDL033        OREQ      'Y'                                                        CDL033
     C     DDTYPE        ANDEQ     'TI'                                                       CDL033
     C     DDIPFQ        ANDEQ     'Z'                                                        CDL033
     C     CDL033        OREQ      'Y'                                                        CDL033
     C     DDTYPE        ANDEQ     'TD'                                                       CDL033
     C     DDIPFQ        ANDEQ     'Z'                                                        CDL033
                                                                                              CDL033
     C                   MOVE      *BLANKS       RETURNCODE                                   CDL033
     C                   MOVE      *BLANKS       MSG1                                         CDL033
      *                                                                                       CDL033
      ** Day in month must be blank for frequency 'Z'.                                        CDL033
      *                                                                                       CDL033
     C     DDIPDM        IFNE      *BLANKS                                                    CDL033
     C                   EVAL      RETURNCODE = 'Error'                                       CDL033
     C                   ADD       1             Idx                                          CDL033
     C                   EVAL      FldNameArr(Idx) = 'DDIPDM'                                 CDL033
     C                   EVAL      MsgIDArr(Idx) = 'MMN9005'                                  CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   ELSE                                                                 CDL033
                                                                                              CDL033
     C                   CALLB     'MMVNXINTDY'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDIPDM
     C                   PARM                    DDIPFQ
     C                   PARM                    DDNDAT
     C                   PARM                    DDNDatOK
     C                   PARM                    BJDFIN
     C                   PARM                    CDL015                                       CDL015
 
      /COPY WNCPYSRC,MMLDNIV048
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDIPDM'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C/COPY WNCPYSRC,MMLDNIVC13
                                                                                              CDL033
     C                   ENDIF                                                                CDL033
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDIPDMOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV049
 
      *  *----------------------------*
      *  * Validate Taxable Indicator *  #26
      *  *----------------------------*
     C                   EXSR      RESETERRS
 
     C/COPY WNCPYSRC,MMLDNIVC03
     C                   CALLB     'MMVTAXIND'
     C                   PARM                    ReturnCode
     C                   PARM                    WarnFound                                    CER048
     C                   PARM                    MSG1
     C                   PARM                    MSG2                                         CER048
     C                   PARM                    DDMTAX
     C                   PARM                    DDBRCA                                     BUG23048
     C                   PARM                    S01383
     C                   PARM                    DDType
     C                   PARM                    DDTypeOK
     C                   PARM                    DDCUST
     C                   PARM                    DDCUSTOK
     C                   PARM                    IKCNum
     C                   PARM                    BBTAIN
      ** AlwCali was *INL1 previously
     C                   PARM                    AlwCali           1
     C                   PARM                    IKAMNP                         CRE007
     C                   PARM                    DDCCY                          CRE007
     C                   PARM                    BJLCCY                         CRE007
     C                   PARM                    BBCSTY                                       CDL013
     C                   PARM                    CDL013                                       CDL013
 
      /COPY WNCPYSRC,MMLDNIV050
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDMTAX'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
      *                                                                                       CER048
     C     MSG2          IFNE      *BLANK                                                     CER048
     C                   ADD       1             WIdx                                         CER048
     C                   EVAL      WFldNamArr(WIdx) = 'DDMTAX'                                CER048
     C                   EVAL      WMsgIDArr(WIdx) = MSG2                                     CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        WarnFound = 'Y'                                            CER048
     C                   EVAL      ReturnCode = 'Warning'                                     CER048
     C                   ENDIF                                                                CER048
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDMTaxOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV051
 
      *  *-------------------------------------------*
      *  * Validate Certificate of Deposit Reference *  #27
      *  *-------------------------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVCDREF'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDTYPE
     C                   PARM                    DDCDRF
 
      /COPY WNCPYSRC,MMLDNIV052
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCDRF'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDCDRfOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV053
 
      *  *-------------------------------------------*
      *  * Validate Certificate of Deposit Holder    *  #28
      *  *-------------------------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVCDHOLD'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    IKMCDH
     C                   PARM                    DDTYPE
     C                   PARM                    DDCDCH
     C                   PARM                    IKCNUM
 
      /COPY WNCPYSRC,MMLDNIV054
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCDCH'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDCDCHOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV055
 
      *  *--------------------------------------------*
      *  * Validate Interest Capitalisation Indicator *  #29
      *  *--------------------------------------------*
     C                   EXSR      RESETERRS
 
     C/COPY WNCPYSRC,MMLDNIVC04
     C                   CALLB     'MMVCAPINT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDCptI
     C                   PARM                    DDType
     C                   PARM                    DDTypeOK
     C                   PARM                    DDIPFq
     C                   PARM                    CDL015                                       CDL015
 
      /COPY WNCPYSRC,MMLDNIV056
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDCPTI'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDCptIOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV057
 
      *  *--------------------------------------*
      *  * Validate Front Up Interest Indicator *  #30
      *  *--------------------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVFRONTUP'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDFUID
     C                   PARM                    S01391
     C                   PARM                    ASFUID
     C                   PARM                    DDTYPE
     C                   PARM                    DDSTYP
     C                   PARM                    DDMTAX
     C                   PARM                    DDIPFQ
     C                   PARM                    DDNDAT
     C                   PARM                    CDL013                                       CDL013
 
      /COPY WNCPYSRC,MMLDNIV058
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFUID'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDFUIDOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV059
 
      *  *----------------------------------------------*
      *  * Validate First & Last Day Interest Indicator *  #31
      *  *----------------------------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVFRSTLST'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDFLID
     C                   PARM                    ASFLID
     C                   PARM                    DDTYPE
     C                   PARM                    DDMTAX
     C                   PARM                    DDIPFQ
     C                   PARM                    DDNDAT
     C                   PARM                    CDL013                                       CDL013
 
      /COPY WNCPYSRC,MMLDNIV060
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFLID'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDFLIDOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV061
 
      *  *----------------------------------------*
      *  * Validate Round Down Interest Indicator *  #32
      *  *----------------------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVRNDDOWN'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDRdfc
     C                   PARM                    A6Rdfc
     C                   PARM                    BrRdfc
 
      /COPY WNCPYSRC,MMLDNIV062
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRDFC'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDRDFCOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV063
 
      *  *----------------------------*
      *  * Validate Rollover Deal No. *  #33
      *  *----------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVROLLONO'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    Msg2
     C                   PARM                    Msg3
     C                   PARM                    Msg4
      ** Warning message ID (10A)
     C                   PARM                    WMsgID1
      * Data describing the database error found
     C                   PARM                    DBErrData
      * Following fields are from the transaction
     C                   PARM                    DDDADN
     C                   PARM                    DDTYPE
     C                   PARM                    DDSTYP
     C                   PARM                    DDCLAS                                       CDL038
     C                   PARM                    DDDLNO
     C                   PARM                    DDCCY
     C                   PARM                    DDBRCA
     C                   PARM                    DDPTFR
     C                   PARM                    DDIPFQ
     C                   PARM                    DDFUID
     C                   PARM                    DDAURO                                      BUG5813
      * Following fields are in/valid indicators for the transaction fields
     C                   PARM                    DDTypeOK
     C                   PARM                    DDDlNoOK
     C                   PARM                    DDCcyOK
     C                   PARM                    DDCustOK
     C                   PARM                    DDBrcaOK
     C                   PARM                    DDPtfrOK
     C                   PARM                    DDDlDtOK
     C                   PARM                    DDAmnpOK
     C                   PARM                    DDICMtOK
     C                   PARM                    DDIPFqOK
     C                   PARM                    DDTotIOK
     C                   PARM                    DDMTaxOK
     C                   PARM                    DDNDatOK
      * Transaction Value Date as a Midas day number
     C                   PARM                    IKDVSD
      * Transaction Customer Number in a numeric, set up in the validation
     C                   PARM                    IKCNUM
      * Transaction Amount numeric, set up in the validation
     C                   PARM                    IKAMNP
      * Derived Related Deal Buy Amount which is (probably) used in the
      *  update of DEALSDC
     C                   PARM                    IKRBAT
      * Rollover Currency                                                       CAP004
      * Currency of rolled over deal if 'in' currency to Euro rollover          CAP004
     C                   PARM                    IKRTFC                         CAP004
      *                                                                         CAP004
      * Flag to show that warning errors have been found
     C                   PARM                    WarnGlobal
      * Flag for whether S01434 (Enhanced Rollovers) is switched on
     C                   PARM                    S01434
      * Flag for whether S01383 (Basic Rate Tax) is switched on
     C                   PARM                    S01383
      * Flag for whether CEU015 (EMU rollover) is switched on                   CAP004
     C                   PARM                    CEU015                         CAP004
      * System Location Code from Bank Details
     C                   PARM                    BJSLCD
      **Run*Date*******************************************************                CAP004 CSC011
     C**********         PARM                    BJRDNB                                CAP004 CSC011
      ** Processing Date                                                                      CSC011
     C                   PARM                    WProcDate                                    CSC011
      * Euro Currency                                                           CAP004
     C                   PARM                    BKEURO                         CAP004
      * Hong Kong Tax Rate from Dealing ICD
     C                   PARM                    BNHKTR
      * Type of Portfolios Supported & Ref attached to 9997, both from
      *  Portfolio Management ICD
     C                   PARM                    FCPORS
     C                   PARM                    FCR997
      * Private Banking Module Indicator (1A)                                   180191
     C                   PARM                    BGN4ST                         180191
      * Portfolio Management Indicator (1A)                                                   215264
     C                   PARM                    BGPFMG                                       215264
      * BRT Rate, Date Effective From, BRT Rate - Previous, all three from
      *  Basic Rate Tax ICD
     C                   PARM                    BRTR
     C                   PARM                    DEFF
     C                   PARM                    PBRTR
      * Action code
     C                   PARM                    DDACTN
     C                   PARM                    CDL013                                       CDL013
 
      /COPY WNCPYSRC,MMLDNIV064
 
      * Cater for Database Error detected
     C     DBErrData     IFNE      *BLANK
     C                   EVAL      FieldName = 'DDDADN'
     C                   EXSR      DBErrExit
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDADN'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDADN'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF
     C     MSG3          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDADN'
     C                   EVAL      MsgIDArr(Idx) = MSG3
     C                   ENDIF
     C     MSG4          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDDADN'
     C                   EVAL      MsgIDArr(Idx) = MSG4
     C                   ENDIF
 
     C     WMSGID1       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDDADN'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDDADNOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV065
                                                                                              CGL058
      *  *-------------------------------------------*                                        CGL058
      *  * Default Originating Branch                *  #34.0                                 CGL058
      *  *-------------------------------------------*                                        CGL058
     C                   IF        CGL058 = 'Y'                                               CGL058
     C                   CALLB     'MMVBBBBRCD'                                               CGL058
     C                   PARM                    DDACTN                                       CGL058
     C                   PARM                    BJSBRC                                       CGL058
     C                   PARM                    DDCUST                                       CGL058
     C                   PARM                    DDORBR                                       CGL058
     C                   ENDIF                                                                CGL058
 
      *  *--------------------------------------------*
      *  * Validate Originating Branch                *  #34
      *  *--------------------------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'ZAVORGBRCH'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDORBR
     C                   PARM                    DDBrCAOK
     C                   PARM                    DDBRCA
     C                   PARM                    BGMBIN
     C                   PARM                    BKOBRU
     C                   PARM                    BKOBUV
     C                   PARM                    RespMode
 
      /COPY WNCPYSRC,MMLDNIV066
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDORBR'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDOrBrOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV067
 
      *  *--------------------------------------------*
      *  * Validate Profit Centre                     *  #35
      *  *--------------------------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'ZAVPROFITC'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDPRFC
     C                   PARM                    BKPRCU
     C                   PARM                    BKPRCA
     C                   PARM                    BKPCDU
     C                   PARM                    DDTYPE
     C                   PARM                    BBACOC
     C                   PARM                    BBCUST
     C                   PARM                    DDBOKC
     C                   PARM                    DDSTYP
     C                   PARM                    DDBRCA
     C                   PARM                    DEPT
     C                   PARM                    PSUser
     C                   PARM                    DDCustOK
     C                   PARM                    BGN0ST
 
      /COPY WNCPYSRC,MMLDNIV068
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPRFC'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDPrfCOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV069
 
      *  *---------------------------------------*                                            CDL016
      *  * Validate Rollover Indicator           *                                            CDL016
      *  *---------------------------------------*                                            CDL016
     C     CDL016        IFEQ      'Y'                                                        CDL016
                                                                                              CDL016
     C                   EXSR      RESETERRS                                                  CDL016
                                                                                              CDL016
     C                   CALLB     'MMVROLLIND'                                               CDL016
     C                   PARM                    ReturnCode                                   CDL016
     C                   PARM                    MSG1                                         CDL016
     C                   PARM                    DDROLI                                       CDL016
     C                   PARM                    DDAURO                                       CDL016
     C                   Parm                    W_Deal_Type                                 BUG8582
                                                                                              CDL016
     C     MSG1          IFNE      *BLANK                                                     CDL016
     C                   ADD       1             Idx                                          CDL016
     C                   EVAL      FldNameArr(Idx) = 'DDROLI'                                 CDL016
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL016
     C                   ENDIF                                                                CDL016
                                                                                              CDL016
      ** Use the return code's value to set the field's OK flag                               CDL016
     C                   CALLB     'ZASETOKFLG'                                               CDL016
     C                   PARM                    DDROLIOK                                     CDL016
     C                   PARM                    ReturnCode                                   CDL016
     C                   PARM                    WarnGlobal                                   CDL016
                                                                                              CDL016
     C                   ENDIF                                                                CDL016
                                                                                              CDL016
      *  *--------------------------------------------*
      *  * Validate Automatic Rollover Indicator      *  #36
      *  *--------------------------------------------*
     C                   EXSR      RESETERRS
      *                                                                                       250597
      ** Only validate if automatic rollover is *on.                                          250597
      *                                                                                       250597
     C     S01434        IFEQ      'Y'                                                        250597
 
     C                   CALLB     'MMVAUTROLL'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDAURO
     C                   PARM                    S01434
     C                   Parm                    W_Collateral                                 CGL011
     C                   Parm                    W_Deal_Type                                  CGL011
     C                   Parm                    W_Maturity                                   CGL011
     C                   Parm                    CDL016                                       CDL016
 
      /COPY WNCPYSRC,MMLDNIV070
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDAURO'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDAuRoOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
     C                   END                                                                  250597
 
      /COPY WNCPYSRC,MMLDNIV071
 
      *  *--------------------------------------------*
      *  * Validate Rollover Frequency                *  #37
      *  *--------------------------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVROLLFRQ'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    WMSGID1                                      243842
     C                   PARM                    DDROFQ
     C                   PARM                    DDAURO
     C                   PARM                    S01434
     C                   Parm                    W_Deal_Type                                 BUG8582
     C                   PARM                    BKAPFQ                                       243842
 
      /COPY WNCPYSRC,MMLDNIV072
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDROFQ'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
                                                                                              243842
     C     WMSGID1       IFNE      *BLANK                                                     243842
     C                   ADD       1             WIdx                                         243842
     C                   EVAL      WFldNamArr(WIdx) = 'DDROFQ'                                243842
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1                                  243842
     C                   ENDIF                                                                243842
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDRoFqOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV073
 
      *  *-------------------------------------------*
      *  * Validate Rollover Day Number              *  #38
      *  *-------------------------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVROLLDAY'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDRLDN
     C                   PARM                    DDROFQ
     C                   PARM                    DDAURO
     C                   PARM                    S01434
     C                   PARM                    W_Deal_type                                 BUG8582
 
      /COPY WNCPYSRC,MMLDNIV074
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDRLDN'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDRlDnOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV075
 
      *  *-------------------------------------------*                                        CAS005
      *  * Validate Liquidity Premium                *                                        CAS005
      *  *-------------------------------------------*                                        CAS005
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                             AR917892
     C                   EXSR      RESETERRS                                                  CAS005
      ** Just to make sure API and Interactive input give the same result                    BUG5508
     C                   EVAL      @INTR = IKINTR                                            BUG5508
     C                   IF        DDNGVI = 'Y'                                              BUG5508
     C                             AND IKINTR > 0                                            BUG5508
     C                   EVAL      @INTR  = 0 - IKINTR                                       BUG5508
     C                   ENDIF                                                               BUG5508
                                                                                              CAS005
     C                   CALLB     'MMVLIQR'                                                  CAS005
     C                   PARM                    ReturnCode                                   CAS005
     C****************** PARM                    IKINTR                               CAS005 BUG5508
     C                   PARM                    @INTR                                       BUG5508
     C                   PARM                    DDLQPR                                       CAS005
     C                   PARM                    DDLQPS                                       CAS005
     C                   PARM                    IKMTTI                                       CAS005
     C                   PARM                    MSG1                                         CAS005
     C                   PARM                    MSG2                                         CAS005
     C                   PARM                    DDLQPROK                                     CAS005
     C                   PARM                    DDLQPSOK                                     CAS005
     C                   PARM                    IKLQPR                                       CAS005
     C                   PARM                    IKLQPS                                       CAS005
     C                   PARM                    IKTNTR                                       CAS005
     C                   PARM                    BNDCSP                                       245692
                                                                                              CAS005
     C     MSG1          IFNE      *BLANK                                                     CAS005
     C     ReturnCode    IFEQ      'Warning'                                                 BUG5508
     C                   ADD       1             WIdx                                        BUG5508
     C                   EVAL      WFldNamArr(WIdx) = 'DDLQPR'                               BUG5508
     C                   EVAL      WMsgIDArr(WIdx) = MSG1                                    BUG5508
     C                   ELSE                                                                BUG5508
     C                   ADD       1             Idx                                          CAS005
     C                   EVAL      FldNameArr(Idx) = 'DDLQPR'                                 CAS005
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CAS005
     C                   ENDIF                                                               BUG5508
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C     MSG2          IFNE      *BLANK                                                     CAS005
     C                   ADD       1             Idx                                          CAS005
     C                   EVAL      FldNameArr(Idx) = 'DDLQPS'                                 CAS005
     C                   EVAL      MsgIDArr(Idx) = MSG2                                       CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
      ** Use the return code's value to set the field's OK flag                               CAS005
                                                                                              CAS005
     C                   CALLB     'ZASETOKFLG'                                               CAS005
     C                   PARM                    DDLQPROK                                     CAS005
     C                   PARM                    ReturnCode                                   CAS005
     C                   PARM                    WarnGlobal                                   CAS005
                                                                                              CAS005
     C                   CALLB     'ZASETOKFLG'                                               CAS005
     C                   PARM                    DDLQPSOK                                     CAS005
     C                   PARM                    ReturnCode                                   CAS005
     C                   PARM                    WarnGlobal                                   CAS005
                                                                                              CAS005
     C                   ENDIF                                                              AR917892
      *  *---------------------------------------------*
      *  * Validate Interest Paid Separately Indicator *  #39
      *  *---------------------------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVINTPDSP'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    DDIPDS
     C                   PARM                    S01434
 
      /COPY WNCPYSRC,MMLDNIV076
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDIPDS'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDIPDSOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV077
 
      *  *-----------------------------------------------------*
      *  * Validate Interest Settle Ccy & 'In' Ccy in field 72 *  #40
      *  *-----------------------------------------------------*
 
     C     S01434        IFEQ      'Y'
     C     CEU003        ANDEQ     'Y'
 
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVINTSC72'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    ErrIntSetc
     C                   PARM                    ErrIntin72
     C                   PARM                    DDISCY
     C                   PARM                    DDII72
     C                   PARM                    DDTYPE
     C                   PARM                    DDCCY
     C                   PARM                    DDccyINCY
     C                   PARM                    DDIPDS
     C                   PARM                    DDIMET
     C                   PARM                    BKEURO
     C                   PARM                    IKISCY
     C                   PARM                    IKII72
 
      /COPY WNCPYSRC,MMLDNIV078
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDISCY'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDII72'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF
 
      ** Convert the 'field in error' flags to set the 'field OK' flags
      ** N.B. This is non-standard processing and takes the place of the
      **  call(s) to ZASETOKFLG.
     C                   CALLB     'ZACVTFLG'
     C                   PARM                    ddIscyok
     C                   PARM                    ErrIntSetc
 
     C                   CALLB     'ZACVTFLG'
     C                   PARM                    ddIi72ok
     C                   PARM                    ErrIntin72
 
     C                   ENDIF
 
      /COPY WNCPYSRC,MMLDNIV079
 
      *  *--------------------------------------------*
      *  * Validate Interest Settlement Method        *  #41
      *  *--------------------------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'ZAVSETMETH'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    MSGDATA
     C                   PARM                    DDINSAOK
     C                   PARM                    DDINOSOK
     C                   PARM                    S01434
     C                   PARM                    DDCCY
     C                   PARM                    DDISCY
     C                   PARM                    DDIPDS
     C                   PARM                    DDIMET
     C                   PARM                    BGRTBN
     C                   PARM                    IKCNUM
     C                   PARM                    BMACCD
     C                   PARM                    DDBRCA
     C                   PARM                    A8BICN
     C                   PARM                    BKACCD
     C                   PARM                    BLUSCY
     C                   PARM                    DDINSA
     C                   PARM                    DDINOS
 
      /COPY WNCPYSRC,MMLDNIV080
 
      ** The message ID & return code processing is non-standard, as
      **  ZAVSETMETH does some validation on the Interest Counterparty
      **  Nostro (DDINOS) as well as on the Interest Settlement Method
      **  (DDIMET).
      ** Errors on the Interest Counterparty Nostro will be in MSG1, and
      **  erors on the Interest Settlement Method will be in MSG2.
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDIMET'
     C                   EVAL      MsgIDArr(Idx) = MSG1
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDIMetOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   ENDIF
     C     MSGDATA       IFNE      *BLANK
     C**********         MOVEA     MSGDATA       MsgDtaArr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATA))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATA)                  MD000091
     C                   ENDIF
 
     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDINOS'
     C                   EVAL      MsgIDArr(Idx) = MSG2
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDINosOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
     C                   ENDIF
 
      /COPY WNCPYSRC,MMLDNIV081
 
      *  *--------------------------------------------*
      *  * Validate Interest Settlement Account       *  #42
      *  *--------------------------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'ZAVSETACCT'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
      ** Message data (45A)
     C                   PARM                    MSGDATA
      ** Interest settlement account identifier (15A, from transaction)
     C                   PARM                    DDINSA
      ** Switchable feature S01434 on (1A, from AOSARDPD)
     C                   PARM                    S01434
      ** Interest paid separately (1A, from transaction)
     C                   PARM                    DDIPDS
      ** Settlement method OK (1A, )
     C                   PARM                    DDIMetOK
      ** Interest settlement method (2A, from transaction)
     C                   PARM                    DDIMET
      ** Deal currency (3A, from transaction)
     C                   PARM                    DDCCY
      ** Interest settlement currency (3A, from transaction)
     C                   PARM                    DDISCY
 
      /COPY WNCPYSRC,MMLDNIV082
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDINSA'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C     MSGDATA       IFNE      *BLANK
     C**********         MOVEA     MSGDATA       MsgDtaArr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(MSGDATA))                              MD000091
     C                   EVAL      MsgDtaArr(Idx) = LenStr +%TRIM(MSGDATA)                  MD000091
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDInSAOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV083
 
      *  *-------------------------------------------*
      *  * Validate Interest Counterparty Nostro     *  #43
      *  *-------------------------------------------*
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVINCPNST'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
      ** Interest counterparty nostro (10A, from transaction)
     C                   PARM                    DDINOS
      ** Enhanced rollovers feature on (1A, from SCSARDPD)
     C                   PARM                    S01434
      ** Interest settlement method (2A, from transaction)
     C                   PARM                    DDIMET
 
      /COPY WNCPYSRC,MMLDNIV084
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDINOS'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
 
      ** Use the return code's value to set the field's OK flag
     C                   CALLB     'ZASETOKFLG'
     C                   PARM                    DDINosOK
     C                   PARM                    ReturnCode
     C                   PARM                    WarnGlobal
 
      /COPY WNCPYSRC,MMLDNIV085
 
      *  *-------------------------------*
      *  * Validate Funding Details      *  #44
      *  *-------------------------------*
 
     C     BGN0ST        IFEQ      'Y'
     C     CDE002        OREQ      'Y'                                                        CDE002
 
      * Reset variables updated by each module before each call
     C                   EXSR      RESETERRS
 
     C                   CALLB     'MMVFUNDDTS'
     C                   PARM                    ReturnCode
     C                   PARM                    MSG1
     C                   PARM                    MSG2
     C                   PARM                    MSG3
     C                   PARM                    WMSGID1
     C                   PARM                    ErrFundRat
     C                   PARM                    ErrFundSgn
     C                   PARM                    ErrFundPrf
     C                   PARM                    DDFSRP
     C                   PARM                    DDFSGN
     C                   PARM                    DDFPRC
     C                   PARM      DDCCY         TranCCY           3
     C                   PARM      DDPRFC        TranPCCD          4
     C                   PARM      IKINTR        TranINTR         11 7
     C                   PARM                    BJLCCY
     C                   PARM                    FTTFRT
     C                   PARM                    IKFSRP
     C                   PARM                    IKFSGN
     C                   PARM                    IKFPRC
     C                   PARM                    BGN0ST                                       CDE002
     C                   PARM                    BNDCSP                                       245692
 
      /COPY WNCPYSRC,MMLDNIV086
 
     C     MSG1          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFSRP'
     C                   EVAL      MsgIDArr(Idx) = MSG1
     C                   ENDIF
     C     MSG2          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFSGN'
     C                   EVAL      MsgIDArr(Idx) = MSG2
     C                   ENDIF
     C     MSG3          IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDFPRC'
     C                   EVAL      MsgIDArr(Idx) = MSG3
     C                   ENDIF
     C     WMSGID1       IFNE      *BLANK
     C                   ADD       1             WIdx
     C                   EVAL      WFldNamArr(WIdx) = 'DDFSRP'
     C                   EVAL      WMsgIDArr(WIdx) = WMSGID1
     C                   ENDIF
 
      ** Convert the 'field in error' flags to set the 'field OK' flags
      ** N.B. This is non-standard processing and takes the place of the
      **  call(s) to ZASETOKFLG.
     C                   CALLB     'ZACVTFLG'
     C                   PARM                    ddFSRPok
     C                   PARM                    ErrFundRat
 
     C                   CALLB     'ZACVTFLG'
     C                   PARM                    ddFSGNok
     C                   PARM                    ErrFundSgn
 
     C                   CALLB     'ZACVTFLG'
     C                   PARM                    ddFPRCok
     C                   PARM                    ErrFundPrf
 
     C                   ENDIF
                                                                                              CDL049
      *  *-------------------------------*                                                    CDL049
      *  * Validate Reference Rate       *  #45                                               CDL049
      *  *-------------------------------*                                                    CDL049
                                                                                              CDL049
     C                   IF        CDL049 = 'Y'                                               CDL049
                                                                                              CDL049
     C                   EXSR      RESETERRS                                                  CDL049
      *                                                                                       CDL049
     C                   CALLB     'MMVLDRRAT'                                                CDL049
     C                   PARM                    RETURNCODE                                   CDL049
     C                   PARM                    TRANIN                                       CDL049
     C                   PARM                    MSG1                                         CDL049
     C                   PARM      *BLANKS       PWMsgID1                                     CDL049
     C                   PARM                    IKINTR                                       CDL049
     C                   PARM                    IKRRAT                                       CDL049
      *                                                                                       CDL049
      * Update error fields/message IDs/message data (arrays)                                 CDL049
     C     MSG1          IFNE      *BLANK                                                     CDL049
     C                   ADD       1             Idx                                          CDL049
     C                   EVAL      FldNameArr(Idx) = 'DDRRAT'                                 CDL049
     C                   EVAL      MsgIDArr(Idx) = MSG1                                       CDL049
     C                   ENDIF                                                                CDL049
      * Update warning error fields/message IDs/message data (arrays)                         CDL049
     C     PWMsgID1      IFNE      *BLANKS                                                    CDL049
     C                   ADD       1             WIdx                                         CDL049
     C                   EVAL      WFldNamArr(WIdx) = 'DDRRAT'                                CDL049
     C                   EVAL      WMsgIDArr(WIdx) = PWMsgID1                                 CDL049
     C                   ENDIF                                                                CDL049
      *                                                                                       CDL049
     C                   ENDIF                                                                CDL049
 
      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*
 
      /COPY WNCPYSRC,MMLDNIV087
 
      *                                                                                       CER020
      ** Default and Validate the Original Deal Number if feature                             CER020
      ** is installed                                                                         CER020
      *                                                                                       CER020
     C                   IF        CER020 = 'Y'                                               CER020
      *                                                                                       CER020
     C                   EXSR      RESETERRS                                                  CER020
      *                                                                                       CER020
     C                   CALLB     'MMVORGDLNO'                                               CER020
     C                   PARM      *BLANKS       ReturnCode                                   CER020
     C                   PARM                    PMsg10                                       CER020
     C                   PARM                    DDVDAT                                       CER020
     C                   PARM                    DDMDAT                                       CER020
     C                   PARM                    DDDADN                                       CER020
     C                   PARM                    DDISDT                                       CER020
     C                   PARM                    DDFMDT                                       CER020
     C                   PARM      DDDLNO        DDORDN                                       CER020
     C                   PARM                    BJDFIN                                       CER020
     C**********         PARM                    PDefISFlg                           CER020 BUG23437
     C**********         PARM                    PDefISVal                           CER020 BUG23437
     C**********         PARM                    PDefFMFlg                           CER020 BUG23437
     C**********         PARM                    PDefFMVal                           CER020 BUG23437
     C                   PARM      'N'           PDefISFlg                                  BUG23437
     C                   PARM      *Zeros        PDefISVal                                  BUG23437
     C                   PARM      'N'           PDefFMFlg                                  BUG23437
     C                   PARM      *Zeros        PDefFMVal                                  BUG23437
      *                                                                                       CER020
     C                   IF        PMsg10 <> *BLANKS                                          CER020
      *                                                                                       CER020
     C                   EVAL      Idx = Idx + 1                                              CER020
     C                   EVAL      FldNameArr(Idx) = 'DDORDN'                                 CER020
     C                   EVAL      MsgIDArr(Idx) = PMsg10                                     CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
      ** Return code's value to set the field's OK flag                                       CER020
      *                                                                                       CER020
     C                   CALLB     'ZASETOKFLG'                                               CER020
     C                   PARM                    DDORDNOK                                     CER020
     C                   PARM                    ReturnCode                                   CER020
     C                   PARM                    WarnGlobal                                   CER020
      *                                                                                       CER020
      ** Validate Initial Start Date                                                          CER020
      *                                                                                       CER020
     C                   EXSR      RESETERRS                                                  CER020
      *                                                                                       CER020
     C                   CALLB     'MMVINSTDAT'                                               CER020
     C                   PARM      *BLANKS       ReturnCode                                   CER020
     C                   PARM                    PMsg8                                        CER020
     C                   PARM                    PWMsgID8                                     CER020
     C                   PARM                    IKISDT                                       CER020
     C                   PARM                    DDVDAT                                       CER020
     C                   PARM                    DDISDT                                       CER020
     C                   PARM                    DDCCY                                        CER020
     C                   PARM                    BJDFIN                                       CER020
     C                   PARM                    PDefISFlg                                    CER020
     C                   PARM                    PDefISVal                                    CER020
      *                                                                                       CER020
     C                   IF        PMsg8 <> *BLANKS                                           CER020
      *                                                                                       CER020
     C                   EVAL      Idx = Idx + 1                                              CER020
     C                   EVAL      FldNameArr(Idx) = 'DDISDT'                                 CER020
     C                   EVAL      MsgIDArr(Idx) = PMsg8                                      CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   IF        PWMsgID8 <> *BLANKS                                        CER020
     C                   EVAL      WIdx = WIdx + 1                                            CER020
     C                   EVAL      WFldNamArr(WIdx) = 'DDISDT'                                CER020
     C                   EVAL      WMsgIDArr(WIdx) = PWMsgID8                                 CER020
     C                   EVAL      WarnGlobal = 'Y'                                           CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
      ** Return code's value to set the field's OK flag                                       CER020
      *                                                                                       CER020
     C                   CALLB     'ZASETOKFLG'                                               CER020
     C                   PARM                    DDISDTOK                                     CER020
     C                   PARM                    ReturnCode                                   CER020
     C                   PARM                    WarnGlobal                                   CER020
      *                                                                                       CER020
      ** Validate Final Maturity Date                                                         CER020
      *                                                                                       CER020
     C                   EXSR      RESETERRS                                                  CER020
      *                                                                                       CER020
     C                   CALLB     'MMVFNMTDAT'                                               CER020
     C                   PARM      *BLANKS       ReturnCode                                   CER020
     C                   PARM                    PMsg9                                        CER020
     C                   PARM                    PWMsgID9                                     CER020
     C                   PARM                    IKFMDT                                       CER020
     C                   PARM                    DDMDAT                                       CER020
     C                   PARM                    DDFMDT                                       CER020
     C                   PARM                    DDTYPE                                       CER020
     C                   PARM                    DDCCY                                        CER020
     C                   PARM                    BJDFIN                                       CER020
     C                   PARM                    PDefFMFlg                                    CER020
     C                   PARM                    PDefFMVal                                    CER020
      *                                                                                       CER020
     C                   IF        PMsg9 <> *BLANKS                                           CER020
      *                                                                                       CER020
     C                   EVAL      Idx = Idx + 1                                              CER020
     C                   EVAL      FldNameArr(Idx) = 'DDFMDT'                                 CER020
     C                   EVAL      MsgIDArr(Idx) = PMsg9                                      CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   IF        PWMsgID9 <> *BLANKS                                        CER020
      *                                                                                       CER020
     C                   EVAL      WIdx = WIdx + 1                                            CER020
     C                   EVAL      WFldNamArr(WIdx) = 'DDFMDT'                                CER020
     C                   EVAL      WMsgIDArr(WIdx) = PWMsgID9                                 CER020
     C                   EVAL      WarnGlobal = 'Y'                                           CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
      ** Return code's value to set the field's OK flag                                       CER020
      *                                                                                       CER020
     C                   CALLB     'ZASETOKFLG'                                               CER020
     C                   PARM                    DDFMDTOK                                     CER020
     C                   PARM                    ReturnCode                                   CER020
     C                   PARM                    WarnGlobal                                   CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *                                                                                       CER020
     C                   IF        (DDBsRCOK <> 'N')                                         BUG5169
      **  Set spread field to spread/rate if base rate code entered,                         BUG5169
      **  if not, set input interest field to spread/rate.                                   BUG5169
     C     DDBSRC        IFNE      *BLANKS                                                   BUG5169
     C                   MOVE      @SPRD         IKSPRD                                      BUG5169
     C                   ELSE                                                                BUG5169
     C                   MOVE      @SPRD         IKIIRT                                      BUG5169
     C     DDNGVI        IFEQ      'Y'                                                       BUG5169
     C                   Z-SUB     IKIIRT        IKIIRT                                      BUG5169
     C                   END                                                                 BUG5169
     C                   END                                                                 BUG5169
                                                                                             BUG5169
     C                   ENDIF                                                               BUG5169
 
     C                   IF        Idx = 0
     C                   EXSR      SetupValid
     C                   ENDIF
 
      /COPY WNCPYSRC,MMLDNIV088
 
     C                   RETURN
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,MMLDNIV091
 
      *****************************************************************
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
 
     C     *ENTRY        PLIST
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      * Transaction information (DS) from source system
     C                   PARM                    TranIn
     C                   PARM                    InfData                        CDL007
      * Receive Settlement Ccy, Method & Nostro and  Pay Settlement Ccy,
      * Method & Nostro, from default or valid deal
     C                   PARM                    RecSetCcy
     C                   PARM                    RecSetMeth
     C                   PARM                    RecNostro
     C                   PARM                    PaySetCcy
     C                   PARM                    PaySetMeth
     C                   PARM                    PayNostro
     C                   PARM                    FrontOffice                    CPB002
     C                   PARM                    ExtData                        CAP004
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
     C/COPY WNCPYSRC,MMLDNIVC18
     C                   PARM                    RepoFlag          1            CSE006
      ** Called from confirmation screen?                                                     CDL033
     C                   PARM                    PCONF                                        CDL033
     C/COPY WNCPYSRC,MMLDNIVC19                                                               GBO005
                                                                                              CDL096
      ** Parameter lists for module MMVPAMCNV                                                 CDL096
                                                                                              CDL096
     C     PMMvPAmCnv    PLIST                                                                CDL096
     C                   PARM                    RetCodeOut                                   CDL096
     C                   PARM                    DDPYDC                                       CDL096
     C                   PARM                    DDAMTC                                       CDL096
     C                   PARM                    DDIPFQ                                       CDL096
     C                   PARM                    OKPayDat                                     CDL096
     C                   PARM                    OKAmtCde                                     CDL096
     C                   PARM                    MsgIdErr                                     CDL096
     C                   PARM                    FldNamErr                                    CDL096
                                                                                              CDL096
      ** Parameter lists for module MMVBDYCCY                                                 CDL096
                                                                                              CDL096
     C     PMMvBDyCcy    PLIST                                                                CDL096
     C                   PARM                    RetCodeOut                                   CDL096
     C                   PARM                    BJLCCY                                       CDL096
     C                   PARM                    DDCCY                                        CDL096
     C                   PARM                    PayCurr                                      CDL096
     C                   PARM                    DDIPFQ                                       CDL096
     C                   PARM                    IKNIPD                                       CDL096
     C                   Parm                    OkFlgPay                                     CDL096
     C                   PARM                    MsgIdErr                                     CDL096
     C                   PARM                    FldNamErr                                    CDL096
     C                   PARM                    WMsgIdErr                                    CDL096
     C                   PARM                    WFldNamErr                                   CDL096
     C                   Parm                    WMsgDtaErr                                   CDL096
                                                                                              CDL029
     C     KBRANCHAUTH   KLIST                                                                CDL029
     C**********         KFLD                    BBBRCD                               CDL029 CDL029A
     C                   KFLD                    W0BRCD            3                         CDL029A
     C                   KFLD                    W0CUST            6                         CDL029A
     C                   KFLD                    DDBRCA                                       CDL029
     C/COPY WNCPYSRC,MMLDNIVC14
      **************                                                                         BUG5517
      ****GET*ZMUSER to access default branch.                                               BUG5517
      **************                                                                         BUG5517
     C******DTAARA**     DEFINE                  ZMUSER                                      BUG5517
     C**************     IN        ZMUSER                                                    BUG5517
     C**************     UNLOCK    ZMUSER                                                    BUG5517
      *
      **  Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'MMLDNIVAL'   DBPGM
     C                   OUT       LDA
      *
      ** Access Bank details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Access General Ledger details via access program
      *  (database error handling done in access program)
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** Access Dealing details via access program
      *  (database error handling done in access program)
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      ** Access Trading data via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOTRADR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDTRAD        PARM      SDTRAD        DSFDY
      *
      ** Access MIDAS Modules details via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Access Portfolio Management details via access program
      *  (database error handling done in access program)
     C     BGPFMG        IFEQ      'Y'
     C                   CALLB     'AOPORTR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPORT        PARM      SDPORT        DSFDY
     C                   ENDIF
                                                                                              CDE002
      ** Access SAR details file to determine if CDE002 is switched on                        CDE002
                                                                                              CDE002
     C                   CallB     'AOSARDR0'                                                 CDE002
     C                   Parm      *Blanks       PRTCD             7                          CDE002
     C                   Parm      '*VERIFY'     POPTN             7                          CDE002
     C                   Parm      'CDE002'      PSARD             6                          CDE002
     C     SCSARD        Parm      SCSARD        DSFDY                                        CDE002
      *                                                                                       CDE002
     C                   Move      'N'           CDE002            1                          CDE002
     C                   If        PRTCD = *Blanks                                            CDE002
     C                   Eval      CDE002 = 'Y'                                               CDE002
     C                   Endif                                                                CDE002
     C/COPY WNCPYSRC,MMH00024
      *
      ** Access Profit Centre Accounting details via access program
      *  (database error handling done in access program)
     C     BGN0ST        IFEQ      'Y'
     C                   CALLB     'AOPCACR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDPCAC        PARM      SDPCAC        DSFDY
     C                   ENDIF
     C                   CALLB     'AOSARDR0'                                                 CDL013
     C                   PARM      *BLANKS       @RTCD                                        CDL013
     C                   PARM      '*VERIFY'     @OPTN                                        CDL013
     C                   PARM      'CDL013'      @SARD                                        CDL013
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL013
     C     @RTCD         IFEQ      *BLANKS                                                    CDL013
     C                   MOVE      'Y'           CDL013                                       CDL013
     C                   ELSE                                                                 CDL013
     C     @RTCD         IFNE      '*NRF   '                                                  CDL013
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL013
     C                   Z-ADD     15            DBASE                                        CDL013
     C                   MOVEL     'CDL013'      DBKEY                                        CDL013
     C                   EXSR      *PSSR                                                      CDL013
     C                   ENDIF                                                                CDL013
     C                   MOVE      'N'           CDL013                                       CDL013
     C                   ENDIF                                                                CDL013
                                                                                              CDL013
      *
      ** Access Retail details via access program
      *  (database error handling done in access program)
     C     BGRTBN        IFEQ      'Y'
     C     BGIOAC        OREQ      'Y'
     C                   CALLB     'AORETLR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY
     C                   ENDIF
      *
      ** Access SAR details file to determine if Australian Brokerage
      ** is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'AUS007'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 013 *
     C                   MOVEL     '001'         DBASE
     C                   MOVEL     'AUS007'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           AUS007            1
     C                   SETON                                        14
     C                   ELSE
     C                   MOVEL     'N'           AUS007
     C                   END
      *
      ** Access SAR details file to determine if Enhanced Rollovers
      ** is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01434'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 014 *
     C                   MOVEL     '002'         DBASE
     C                   MOVEL     'S01434'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01434            1
     C                   ELSE
     C                   MOVEL     'N'           S01434
     C                   END
      *
      ** Access SAR details file to determine if S01468 (changed
      ** validation for total interest field) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01468'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 020 *
     C                   MOVEL     '003'         DBASE
     C                   MOVEL     'S01468'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01468            1
     C                   ELSE
     C                   MOVEL     'N'           S01468
     C                   END
      *
      ** ACCESS SAR DETAILS FILE TO DETERMINE IF BRT SAR IS INSTALLED
      ** (DATABASE ERROR HANDLING DONE IN ACCESS PROGRAM)
      **
     C                   CALLB     'AOSARDR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01383'      @SARD             6
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 012 *
     C                   MOVEL     '004'         DBASE
     C                   MOVEL     @RTCD         DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01383            1
     C                   END
     C*
     C** IF BRT SAR INSTALLED, ACCESS BRT INSTALLATION CONTROL DATA
     C*
     C     S01383        IFEQ      'Y'
     C                   MOVE      'D'           BRTKEY            1
     C                   OPEN      SDBRTDL1                                                 MD031408
     C     BRTKEY        CHAIN     SDBRTDD0                           60
     C*
     C** if *in60 is on, then it is a data base error
     C*
     C     *IN60         IFEQ      '1'
     C     *LOCK         IN        LDA                                          ***************
     C                   MOVEL     'SDBRTDPD'    DBFILE                         * DBERROR 013 *
     C                   MOVEL     '005'         DBASE                          ***************
     C                   MOVEL     BRTKEY        DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
     C                   CLOSE     SDBRTDL1                                                 MD031408
     C                   END
     C**
     C** ACCESS SAR DETAILS FILE TO DETERMINE IF JSM SAR IS INSTALLED
     C** (DATABASE ERROR HANDLING DONE IN ACCESS PROGRAM)
     C**
     C                   CALLB     'AOSARDR0'
     C                   PARM      '       '     @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01391'      @SARD             6
     C     @RTCD         IFNE      *BLANK
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA                                          ***************
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 014 *
     C                   MOVEL     '006'         DBASE                          ***************
     C                   MOVEL     @RTCD         DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01391            1
     C                   END
      *
      ** Access SAR details file to determine if CDL005 is on.
      ** (Customer format in input functions is shortname)
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDL005'      @SARD             6
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 020 *
     C                   MOVEL     '007'         DBASE
     C                   MOVEL     'CDL005'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'S'           CustFormat        1
     C                   ELSE
     C                   MOVEL     'N'           CustFormat
     C                   END
      *                                                                                       CDL011
      ** Access SAR details file to determine if CDL011 is on.                                CDL011
      ** (Expansion of Customer Number on Dealing Transactions)                               CDL011
      *                                                                                       CDL011
     C                   CALLB     'AOSARDR0'                                                 CDL011
     C                   PARM      *BLANKS       @RTCD                                        CDL011
     C                   PARM      '*VERIFY'     @OPTN                                        CDL011
     C                   PARM      'CDL011'      @SARD                                        CDL011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL011
     C     @RTCD         IFNE      *BLANKS                                                    CDL011
     C     @RTCD         ANDNE     '*NRF   '                                                  CDL011
     C                   MOVEL     'CDL011'      DBKEY                                        CDL011
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL011
     C                   MOVEL     '013'         DBASE                                        CDL011
     C                   EXSR      *PSSR                                                      CDL011
     C                   END                                                                  CDL011
     C     @RTCD         IFEQ      *BLANK                                                     CDL011
     C                   MOVEL     'S'           CustFormat                                   CDL011
     C                   END                                                                  CDL011
      *
      ** Access SAR details file to determine if CEU003 is on.
      ** (EMU Dealing settlement currency conversion)
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU003'      @SARD
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE                         * DBERROR 020 *
     C                   MOVEL     '008'         DBASE
     C                   MOVEL     'CEU003'      DBKEY
     C                   OUT       LDA
     C                   SETON                                        U7U8LR
     C                   EXSR      #TERM
     C                   END
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU003            1
     C                   END
      *                                                                         CAP004
      ** Access SAR details file to determine if CEU015 is on.                  CAP004
      ** (EMU Rollover into Euros)                                              CAP004
      *                                                                         CAP004
     C                   CALLB     'AOSARDR0'                                   CAP004
     C                   PARM      *BLANKS       @RTCD                          CAP004
     C                   PARM      '*VERIFY'     @OPTN                          CAP004
     C                   PARM      'CEU015'      @SARD                          CAP004
     C     @RTCD         IFNE      *BLANKS                                      CAP004
     C     @RTCD         ANDNE     '*NRF   '                                    CAP004
     C     *LOCK         IN        LDA                                          CAP004
     C                   MOVEL     'SCSARDPD'    DBFILE                         CAP004
     C                   MOVEL     '009'         DBASE                          CAP004
     C                   MOVEL     'CEU015'      DBKEY                          CAP004
     C                   OUT       LDA                                          CAP004
     C                   SETON                                        U7U8LR    CAP004
     C                   EXSR      #TERM                                        CAP004
     C                   END                                                    CAP004
     C     @RTCD         IFEQ      *BLANK                                       CAP004
     C                   MOVEL     'Y'           CEU015            1            CAP004
     C                   END                                                    CAP004
      *                                                                         CSE006
      ** Access SAR details file to determine if CSE006 is on.                  CSE006
      ** (EMU Rollover into Euros)                                              CSE006
      *                                                                         CSE006
     C                   CALLB     'AOSARDR0'                                   CSE006
     C                   PARM      *BLANKS       @RTCD                          CSE006
     C                   PARM      '*VERIFY'     @OPTN                          CSE006
     C                   PARM      'CSE006'      @SARD                          CSE006
     C     @RTCD         IFNE      *BLANKS                                      CSE006
     C     @RTCD         ANDNE     '*NRF   '                                    CSE006
     C     *LOCK         IN        LDA                                          CSE006
     C                   MOVEL     'SCSARDPD'    DBFILE                         CSE006
     C                   MOVEL     '009'         DBASE                          CSE006
     C                   MOVEL     'CSE006'      DBKEY                          CSE006
     C                   OUT       LDA                                          CSE006
     C                   SETON                                        U7U8LR    CSE006
     C                   EXSR      #TERM                                        CSE006
     C                   END                                                    CSE006
     C     @RTCD         IFEQ      *BLANK                                       CSE006
     C                   MOVEL     'Y'           CSE006            1            CSE006
     C                   END                                                    CSE006
      *                                                                         CDL007
      ** Access SAR details file to determine if CDL007 is on.                  CDL007
      ** (Deposit Breakdown Penalty)                                            CDL007
      *                                                                         CDL007
     C                   CALLB     'AOSARDR0'                                   CDL007
     C                   PARM      *BLANKS       @RTCD                          CDL007
     C                   PARM      '*VERIFY'     @OPTN                          CDL007
     C                   PARM      'CDL007'      @SARD             6            CDL007
     C     @RTCD         IFNE      *BLANKS                                      CDL007
     C     @RTCD         ANDNE     '*NRF   '                                    CDL007
     C     *LOCK         IN        LDA                                          CDL007
     C                   MOVEL     'SCSARDPD'    DBFILE                         CDL007
     C                   MOVEL     '010'         DBASE                          CDL007
     C                   MOVEL     'CDL007'      DBKEY                          CDL007
     C                   OUT       LDA                                          CDL007
     C                   SETON                                        U7U8LR    CDL007
     C                   EXSR      #TERM                                        CDL007
     C                   END                                                    CDL007
     C     @RTCD         IFEQ      *BLANK                                       CDL007
     C                   MOVEL     'Y'           CDL007            1            CDL007
     C                   ELSE                                                   CDL007
     C                   MOVEL     'N'           CDL007                         CDL007
     C                   ENDIF                                                  CDL007
      *                                                                                       CDL015
      ** Access SAR details file to determine if CDL015 is on.                                CDL015
      *                                                                                       CDL015
     C                   CALLB     'AOSARDR0'                                                 CDL015
     C                   PARM      *BLANKS       @RTCD                                        CDL015
     C                   PARM      '*VERIFY'     @OPTN                                        CDL015
     C                   PARM      'CDL015'      @SARD             6                          CDL015
     C     @RTCD         IFNE      *BLANKS                                                    CDL015
     C     @RTCD         ANDNE     '*NRF   '                                                  CDL015
     C     *LOCK         IN        LDA                                                        CDL015
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL015
     C                   MOVEL     '011'         DBASE                                        CDL015
     C                   MOVEL     'CDL015'      DBKEY                                        CDL015
     C                   OUT       LDA                                                        CDL015
     C                   SETON                                        U7U8LR                  CDL015
     C                   EXSR      #TERM                                                      CDL015
     C                   END                                                                  CDL015
     C     @RTCD         IFEQ      *BLANK                                                     CDL015
     C                   MOVEL     'Y'           CDL015            1                          CDL015
     C                   ELSE                                                                 CDL015
     C                   MOVEL     'N'           CDL015                                       CDL015
     C                   ENDIF                                                                CDL015
                                                                                              CAS001
      ** Access SAR details file to determine if CAS001 is on.                                CAS001
      ** (Net Present Value Accounting)                                                       CAS001
                                                                                              CAS001
     C                   CALLB     'AOSARDR0'                                                 CAS001
     C                   PARM      *BLANKS       PRTCD                                        CAS001
     C                   PARM      '*VERIFY'     POPTN                                        CAS001
     C                   PARM      'CAS001'      PSARD                                        CAS001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS001
     C                   IF        PRTCD <> *BLANKS AND                                       CAS001
     C                             PRTCD <> '*NRF   '                                         CAS001
     C     *LOCK         IN        LDA                                                        CAS001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS001
     C                   EVAL      DBASE = 011                                                CAS001
     C                   EVAL      DBKEY = 'CAS001'                                           CAS001
     C                   OUT       LDA                                                        CAS001
     C                   EVAL      *INU7 = *ON                                                CAS001
     C                   EVAL      *INU8 = *ON                                                CAS001
     C                   EVAL      *INLR = *ON                                                CAS001
     C                   EXSR      #TERM                                                      CAS001
     C                   ENDIF                                                                CAS001
     C                   IF        PRTCD = *BLANKS                                            CAS001
     C                   EVAL      CAS001 = 'Y'                                               CAS001
     C                   ELSE                                                                 CAS001
     C                   EVAL      CAS001 = 'N'                                               CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
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
     C                   EVAL      DBASE = 905                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CDL010
      ** Access SAR details file to determine if CDL010 is on.                                CDL010
      ** (Dealing Transaction Authorisation)                                                  CDL010
                                                                                              CDL010
     C                   CALLB     'AOSARDR0'                                                 CDL010
     C                   PARM      *BLANKS       PRTCD                                        CDL010
     C                   PARM      '*VERIFY'     POPTN                                        CDL010
     C                   PARM      'CDL010'      PSARD                                        CDL010
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL010
     C                   IF        PRTCD <> *BLANKS AND                                       CDL010
     C                             PRTCD <> '*NRF   '                                         CDL010
     C     *LOCK         IN        LDA                                                        CDL010
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL010
     C                   EVAL      DBASE = 012                                                CDL010
     C                   EVAL      DBKEY = 'CDL010'                                           CDL010
     C                   OUT       LDA                                                        CDL010
     C                   EVAL      *INU7 = *ON                                                CDL010
     C                   EVAL      *INU8 = *ON                                                CDL010
     C                   EVAL      *INLR = *ON                                                CDL010
     C                   EXSR      #TERM                                                      CDL010
     C                   ENDIF                                                                CDL010
     C                   IF        PRTCD = *BLANKS                                            CDL010
     C                   EVAL      CDL010 = 'Y'                                               CDL010
     C                   ELSE                                                                 CDL010
     C                   EVAL      CDL010 = 'N'                                               CDL010
     C                   ENDIF                                                                CDL010
                                                                                              CSC011
      ** If 24X7 Midas availability is installed and support system is                        CSC011
      ** active, used processing date from dataarea SC24X7 as the                             CSC011
      ** rundate.                                                                             CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' AND                                           CSC011
     C                             S1SUPP = LIBR                                              CSC011
     C                   EVAL      WProcDate = S1DATE                                         CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      WProcDate = BJRDNB                                         CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CAS005
      ** Access SAR details file to determine if CAS005 is on.                                CAS005
      ** (Enhancements to CAS001, CAS002 and CAS004)                                          CAS005
                                                                                              CAS005
     C                   CALLB     'AOSARDR0'                                                 CAS005
     C                   PARM      *BLANKS       PRTCD                                        CAS005
     C                   PARM      '*VERIFY'     POPTN                                        CAS005
     C                   PARM      'CAS005'      PSARD                                        CAS005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS005
                                                                                              CAS005
     C                   IF        PRTCD <> *BLANKS AND                                       CAS005
     C                             PRTCD <> '*NRF   '                                         CAS005
     C     *LOCK         IN        LDA                                                        CAS005
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS005
     C                   EVAL      DBASE = 906                                                CAS005
     C                   EVAL      DBKEY = 'CAS005'                                           CAS005
     C                   OUT       LDA                                                        CAS005
     C                   EXSR      *PSSR                                                      CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        PRTCD = *BLANKS                                            CAS005
     C                   EVAL      CAS005 = 'Y'                                               CAS005
     C                   ELSE                                                                 CAS005
     C                   EVAL      CAS005 = 'N'                                               CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CDL016
      ** Access SAR details file to determine if CDL016 is switched on                        CDL016
      ** (Autumatic Rollover of Fixed Term Loan/Deposit)                                      CDL016
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
     C*                                                                                       CDL029
     C                   CALLB     'AOSARDR0'                                                 CDL029
     C                   PARM      *BLANKS       PRTCD                                        CDL029
     C                   PARM      '*VERIFY'     POPTN                                        CDL029
     C                   PARM      'CDL029'      PSARD                                        CDL029
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL029
     C                   IF        PRTCD <> *BLANKS AND                                       CDL029
     C                             PRTCD <> '*NRF   '                                         CDL029
     C     *LOCK         IN        LDA                                                        CDL029
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL029
     C                   EVAL      DBASE = 014                                                CDL029
     C                   EVAL      DBKEY = 'CDL029'                                           CDL029
     C                   OUT       LDA                                                        CDL029
     C                   EVAL      *INU7 = *ON                                                CDL029
     C                   EVAL      *INU8 = *ON                                                CDL029
     C                   EVAL      *INLR = *ON                                                CDL029
     C                   EXSR      #TERM                                                      CDL029
     C                   ENDIF                                                                CDL029
     C                   IF        PRTCD = *BLANKS                                            CDL029
     C                   EVAL      CDL029 = 'Y'                                               CDL029
     C                   ELSE                                                                 CDL029
     C                   EVAL      CDL029 = 'N'                                               CDL029
     C                   ENDIF                                                                CDL029
                                                                                              CDL029
      ** Access SAR details file to determine if CDL033 is switched on                        CDL033
                                                                                              CDL033
     C                   CALLB     'AOSARDR0'                                                 CDL033
     C                   PARM      *BLANKS       PRTCD                                        CDL033
     C                   PARM      '*VERIFY'     POPTN                                        CDL033
     C                   PARM      'CDL033'      PSARD                                        CDL033
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL033
                                                                                              CDL033
     C                   IF        PRTCD <> *BLANKS AND                                       CDL033
     C                             PRTCD <> '*NRF   '                                         CDL033
     C     *LOCK         IN        LDA                                                        CDL033
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CDL033
     C                   EVAL      DBASE = 907                                                CDL033
     C                   EVAL      DBKEY = 'CDL033'                                           CDL033
     C                   OUT       LDA                                                        CDL033
     C                   EXSR      *PSSR                                                      CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
     C                   IF        PRTCD = *BLANKS                                            CDL033
     C                   EVAL      CDL033 = 'Y'                                               CDL033
     C                   ELSE                                                                 CDL033
     C                   EVAL      CDL033 = 'N'                                               CDL033
     C                   ENDIF                                                                CDL033
                                                                                              CDL033
      ** Access SAR details file to determine if CDL020 is switched on                        259981
      ** (Apply Base Rate at Value Date)                                                      259981
                                                                                              259981
     C                   CallB     'AOSARDR0'                                                 259981
     C                   Parm      *Blanks       PRTCD                                        259981
     C                   Parm      '*VERIFY'     POPTN                                        259981
     C                   Parm      'CDL020'      PSARD                                        259981
     C     SCSARD        Parm      SCSARD        DSFDY                                        259981
      *                                                                                       259981
     C                   Move      'N'           CDL020            1                          259981
     C                   If        PRTCD = *Blanks                                            259981
     C                   Eval      CDL020 = 'Y'                                               259981
     C                   Endif                                                                259981
      *                                                                                       CGL058
      ** Check if CGL058 is on                                                                CGL058
      *                                                                                       CGL058
     C                   CALLB     'AOSARDR0'                                                 CGL058
     C                   PARM      *BLANKS       PRTCD                                        CGL058
     C                   PARM      '*VERIFY'     POPTN                                        CGL058
     C                   PARM      'CGL058'      PSARD                                        CGL058
      *                                                                                       CGL058
     C                   IF        PRTCD = *BLANKS                                            CGL058
     C                   EVAL      CGL058 = 'Y'                                               CGL058
     C                   ELSE                                                                 CGL058
     C                   EVAL      CGL058 = 'N'                                               CGL058
     C                   ENDIF                                                                CGL058
                                                                                              CGL058
      ** Access SAR details file to determine if CDL038 is switched on                       BUG9717
                                                                                             BUG9717
     C                   CALLB     'AOSARDR0'                                                BUG9717
     C                   PARM      *BLANKS       PRTCD                                       BUG9717
     C                   PARM      '*VERIFY'     POPTN                                       BUG9717
     C                   PARM      'CDL038'      PSARD                                       BUG9717
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG9717
                                                                                             BUG9717
     C                   IF        PRTCD <> *BLANKS AND                                      BUG9717
     C                             PRTCD <> '*NRF   '                                        BUG9717
     C     *LOCK         IN        LDA                                                       BUG9717
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG9717
     C                   EVAL      DBASE = 908                                               BUG9717
     C                   EVAL      DBKEY = 'CDL038'                                          BUG9717
     C                   OUT       LDA                                                       BUG9717
     C                   EXSR      *PSSR                                                     BUG9717
     C                   ENDIF                                                               BUG9717
                                                                                             BUG9717
     C                   IF        PRTCD = *BLANKS                                           BUG9717
     C                   EVAL      CDL038 = 'Y'                                              BUG9717
     C                   ELSE                                                                BUG9717
     C                   EVAL      CDL038 = 'N'                                              BUG9717
     C                   ENDIF                                                               BUG9717
                                                                                             BUG9717
      ** Access SAR details file to determine if CDL006 is switched on                       BUG9827
                                                                                             BUG9827
     C                   CALLB     'AOSARDR0'                                                BUG9827
     C                   PARM      *BLANKS       PRTCD                                       BUG9827
     C                   PARM      '*VERIFY'     POPTN                                       BUG9827
     C                   PARM      'CDL006'      PSARD                                       BUG9827
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG9827
                                                                                             BUG9827
     C                   IF        PRTCD <> *BLANKS AND                                      BUG9827
     C                             PRTCD <> '*NRF   '                                        BUG9827
     C     *LOCK         IN        LDA                                                       BUG9827
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG9827
     C                   EVAL      DBASE = 909                                               BUG9827
     C                   EVAL      DBKEY = 'CDL006'                                          BUG9827
     C                   OUT       LDA                                                       BUG9827
     C                   EXSR      *PSSR                                                     BUG9827
     C                   ENDIF                                                               BUG9827
                                                                                             BUG9827
     C                   IF        PRTCD = *BLANKS                                           BUG9827
     C                   EVAL      CDL006 = 'Y'                                              BUG9827
     C                   ELSE                                                                BUG9827
     C                   EVAL      CDL006 = 'N'                                              BUG9827
     C                   ENDIF                                                               BUG9827
                                                                                             BUG9827
      *                                                                                       CER048
      ** Access SAR details file to determine if CER048 is installed                          CER048
      *                                                                                       CER048
     C                   CALLB     'AOSARDR0'                                                 CER048
     C                   PARM      *BLANKS       PRTCD                                        CER048
     C                   PARM      '*VERIFY'     POPTN                                        CER048
     C                   PARM      'CER048'      PSARD                                        CER048
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER048
      *                                                                                       CER048
     C                   IF        PRTCD <> *BLANKS AND                                       CER048
     C                             PRTCD <> '*NRF   '                                         CER048
     C     *LOCK         IN        LDA                                                        CER048
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER048
     C                   EVAL      DBASE = 015                                                CER048
     C                   EVAL      DBKEY = 'CER048'                                           CER048
     C                   OUT       LDA                                                        CER048
     C                   EXSR      *PSSR                                                      CER048
     C                   ENDIF                                                                CER048
      *                                                                                       CER048
     C                   IF        PRTCD = *BLANKS                                            CER048
     C                   EVAL      CER048 = 'Y'                                               CER048
     C                   ELSE                                                                 CER048
     C                   EVAL      CER048 = 'N'                                               CER048
     C                   ENDIF                                                                CER048
      *                                                                                      BUG8239
      ** Call Fiduciary Dealing Initial Processing                                           BUG8239
      *                                                                                      BUG8239
     C                   CALLB     'MMFIDINIT'                                               BUG8239
     C                   PARM      *BLANK        PRTCD                                       BUG8239
                                                                                             BUG8239
      *                                                                                       CER020
      ** Call Access SAR details file to determine if CER020 is                               CER020
      ** installed                                                                            CER020
      *                                                                                       CER020
     C                   CALLB     'AOSARDR0'                                                 CER020
     C                   PARM      *BLANKS       PRTCD                                        CER020
     C                   PARM      '*VERIFY'     POPTN                                        CER020
     C                   PARM      'CER020'      PSARD                                        CER020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER020
      *                                                                                       CER020
     C     PRTCD         IFEQ      *BLANKS                                                    CER020
      *                                                                                       CER020
     C                   EVAL      CER020 = 'Y'                                               CER020
     C                   ELSE                                                                 CER020
     C                   EVAL      CER020 = 'N'                                               CER020
      *                                                                                       CER020
     C                   ENDIF                                                                CER020
      *
      ** Access SAR details file to determine if CDL049 is switched on                        CDL049
                                                                                              CDL049
     C                   CALLB     'AOSARDR0'                                                 CDL049
     C                   PARM      *BLANKS       PRTCD                                        CDL049
     C                   PARM      '*VERIFY'     POPTN                                        CDL049
     C                   PARM      'CDL049'      PSARD                                        CDL049
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL049
      *                                                                                       CDL049
     C                   IF        PRTCD = *BLANKS                                            CDL049
     C                   EVAL      CDL049 = 'Y'                                               CDL049
     C                   ELSE                                                                 CDL049
     C                   EVAL      CDL049 = 'N'                                               CDL049
     C                   ENDIF                                                                CDL049
      *                                                                                       CDL049
      *                                                                                       249905
      ** Determine if switchable feature CDL019 is installed                                  249905
      *                                                                                       249905
     C                   CALLB     'AOSARDR0'                                                 249905
     C                   PARM      *BLANKS       PRTCD                                        249905
     C                   PARM      '*VERIFY '    POPTN                                        249905
     C                   PARM      'CDL019'      PSARD                                        249905
      *                                                                                       249905
     C                   MOVE      'N'           CDL019            1                          249905
     C     PRTCD         IFEQ      *BLANKS                                                    249905
     C                   MOVE      'Y'           CDL019                                       249905
     C                   ENDIF                                                                249905
      *                                                                                       249905
                                                                                              CRE073
      ** Check if CRE073 is installed                                                         CRE073
                                                                                              CRE073
     C                   CALLB     'AOSARDR0'                                                 CRE073
     C                   PARM      *BLANKS       PRtCd                                        CRE073
     C                   PARM      '*VERIFY'     POptn                                        CRE073
     C                   PARM      'CRE073'      PSard                                        CRE073
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE073
                                                                                              CRE073
     C                   IF        PRtCd = *Blanks                                            CRE073
     C                   EVAL      CRE073 = 'Y'                                               CRE073
     C                   ELSE                                                                 CRE073
     C                   EVAL      CRE073 = 'N'                                               CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
      ** Check if CDL093 is installed                                                         CDL093
                                                                                              CDL093
     C                   CALLB     'AOSARDR0'                                                 CDL093
     C                   PARM      *BLANKS       PRtCd                                        CDL093
     C                   PARM      '*VERIFY'     POptn                                        CDL093
     C                   PARM      'CDL093'      PSard                                        CDL093
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL093
                                                                                              CDL093
     C                   IF        PRtCd = *Blanks                                            CDL093
     C                   EVAL      CDL093 = 'Y'                                               CDL093
     C                   ELSE                                                                 CDL093
     C                   EVAL      CDL093 = 'N'                                               CDL093
     C                   ENDIF                                                                CDL093
                                                                                              CDL093
      ** Check if CDL096 is installed                                                         CDL096
                                                                                              CDL096
     C                   CALLB     'AOSARDR0'                                                 CDL096
     C                   PARM      *BLANKS       PRtCd                                        CDL096
     C                   PARM      '*VERIFY'     POptn                                        CDL096
     C                   PARM      'CDL096'      PSard                                        CDL096
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL096
                                                                                              CDL096
     C                   IF        PRtCd = *Blanks                                            CDL096
     C                   EVAL      CDL096 = 'Y'                                               CDL096
     C                   ELSEIF    PRtCd = '*NRF'                                             CDL096
     C                   EVAL      CDL096 = 'N'                                               CDL096
     C                   ELSE                                                                 CDL096
     C     *LOCK         IN        LDA                                                        CDL096
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CDL096
     C                   MOVEL     '123'         DBASE                                        CDL096
     C                   MOVEL     'CDL096'      DBKEY                                        CDL096
     C                   OUT       LDA                                                        CDL096
     C                   EXSR      *PSSR                                                      CDL096
     C                   ENDIF                                                                CDL096
                                                                                              CDL096
      ** Check if CER069 is installed                                                       MD030409
                                                                                            MD030409
     C                   CALLB     'AOSARDR0'                                               MD030409
     C                   PARM      *BLANKS       PRtCd                                      MD030409
     C                   PARM      '*VERIFY'     POptn                                      MD030409
     C                   PARM      'CER069'      PSard                                      MD030409
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD030409
                                                                                            MD030409
     C                   IF        PRtCd = *Blanks                                          MD030409
     C                   EVAL      CER069 = 'Y'                                             MD030409
     C                   ELSE                                                               MD030409
     C                   EVAL      CER069 = 'N'                                             MD030409
     C                   ENDIF                                                              MD030409
                                                                                            MD030409
      *  Set up the name of the MSGF from which the message handler will
      *   get the messages
     C                   EVAL      #MsgFile = 'DRSMM'
      *
 
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,MMLDNIV092
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *                                                               *
      * Called by: Main processing, before each validation module     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     RESETERRS     BEGSR
 
     C                   RESET                   Msg1
     C                   RESET                   Msg2
     C                   RESET                   Msg2C                                        CDL038
     C                   RESET                   Msg3
     C                   RESET                   Msg4
     C                   RESET                   Msg5
     C                   RESET                   Msg6
     C                   RESET                   Msg7
     C                   RESET                   Msg8                                       BUG23732
     C                   RESET                   PMsg8                                        CER020
     C                   RESET                   PMsg9                                        CER020
     C                   RESET                   PMsg10                                       CER020
     C                   RESET                   PWMsgID8                                     CER020
     C                   RESET                   PWMsgID9                                     CER020
 
     C                   RESET                   WMsgID1
     C                   RESET                   WMsgID2
     C                   RESET                   WMsgID3
     C                   RESET                   WMsgID4
 
     C                   RESET                   MSGDATA
 
     C                   EVAL      ReturnCode= *Blanks
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CDL038
      *****************************************************************                       CDL038
      * Default Sub Type and Class                                                            CDL038
      *****************************************************************                       CDL038
     C     DSUBTCLAS     BEGSR                                                                CDL038
      *                                                                                       CDL038
     C                   CALL      'DL002000'                                                 CDL038
      * Inputs                                                                                CDL038
     C                   PARM                    DDACTN                                       CDL038
     C                   PARM                    DDTYPE                                       CDL038
     C                   PARM                    DDCUST                                       CDL038
     C                   PARM                    DDVDAT                                       CDL038
     C                   PARM                    DDMDAT                                       CDL038
     C                   PARM                    DDBOKC                                       CDL038
     C                   PARM                    DDPRFC                                       CDL038
     C                   PARM                    DDCCY                                        CDL038
     C                   PARM      *BLANK        @Currency2        3                          CDL038
     C                   PARM      *BLANK        @RelatedDeal      6                          CDL038
      * Inputs/Outputs                                                                        CDL038
     C                   PARM                    DDSTYP                                       CDL038
     C                   PARM                    DDCLAS                                       CDL038
      *                                                                                       CDL038
     C                   ENDSR                                                                CDL038
      *****************************************************************                       CDL038
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *    Valid file record.                                         *
      *                                                               *
      *****************************************************************
 
     C     SETUPVALID    BEGSR
                                                                                CSE006
     C                   IF        CSE006='Y' and RepoFlag='Y'                  CSE006
     C                                                                          CSE006
     C                   IF        DDTRTP='PR' or DDTRTP='RR'                   CSE006
     C                   EVAL      REPO='R'                                     CSE006
     C                   ENDIF                                                  CSE006
     C                                                                          CSE006
     C                   IF        DDTRTP='PL' or DDTRTP='PD'                   CSE006
     C                   EVAL      REPO='P'                                     CSE006
     C                   ENDIF                                                  CSE006
     C                                                                          CSE006
     C                   IF        DDTRTP='BB' or DDTRTP='BL'                   CSE006
     C                   EVAL      REPO='B'                                     CSE006
     C                   ENDIF                                                  CSE006
     C                                                                          CSE006
     C                   ENDIF                                                  CSE006
     C                                                                          CSE006
 
      * Other IKxxxx fields are set up during the individual date
      *  validation, such as the ones where the input & database formats
      *  are different, e.g. dates, amounts.
      * This SR sets up the fields with the same (or compatible) attributes
 
     C                   MOVE      DDTYPE        IKTYPE
     C                   MOVE      DDSTYP        IKSTYP
     C                   MOVE      DDFEDF        IKFEDF
     C                   MOVE      DDDADN        IKDADN
     C                   MOVE      DDBRCA        IKBRCA
     C                   MOVE      DDBOKC        IKBOKC
     C                   MOVE      DDLNKN        IKLNKN
     C                   MOVE      DDBKCD        IKBKCD
     C                   MOVE      DDCCY         IKCCY
     C                   MOVE      DDICMT        IKICMT
     C                   MOVE      DDNGVI        IKNGVI
     C                   MOVE      DDIPFQ        IKIPFQ
     C                   MOVE      DDIPDM        IKIPDM
     C                   MOVE      DDCPTI        IKCPTI
     C                   MOVE      DDMTAX        IKMTAX
     C                   MOVE      DDFUID        IKFUID
     C                   MOVE      DDFLID        IKFLID
     C                   MOVE      DDRDFC        IKRDFC
     C                   MOVE      DDCDRF        IKCDRF
     C                   MOVE      DDPRFC        IKPRFC
     C                   MOVE      DDORBR        IKORBR
     C                   MOVE      DDAURO        IKAURO
     C                   MOVE      DDCNNA        IKCNNA
     C                   MOVE      DDIPDS        IKIPDS
     C                   MOVE      DDIMET        IKIMET
     C                   MOVE      DDINSA        IKINSA
     C                   MOVE      DDROFQ        IKROFQ
     C                   MOVE      DDRLDN        IKRLDN
     C                   MOVE      DDINOS        IKINOS
     C                   MOVE      DDRACD        IKRACD
 
      **  If screen Portfolio Reference is the Non-Portfolio value default
      **   in the file equivalent of this
     C     DDPTFR        IFEQ      FCR997                                                      S0148
     C     ERPLCS        ANDEQ     *BLANKS                                                  BUG10343
     C     FCPORS        ANDNE     'B'                                                         10405
     C     BGN4ST        ANDNE     'Y'                                          CPB001
     C     FCPORS        OREQ      'B'                                                         10405
     C     DDPTFR        ANDNE     *BLANKS                                                     10405
     C     DDPTFR        ANDEQ     FCR997                                                      10405
     C     BGN4ST        ANDNE     'Y'                                          CPB001
     C                   MOVE      '9997'        IKPTFR                                        S0148
     C                   ELSE                                                                  S0148
     C                   MOVE      DDPTFR        IKPTFR                                        S0148
     C                   END                                                                   S0148
 
      **  This routine may be called as part of amend processing, only do
      **   following sections if the relevant fields are valid
 
     C*******************IF********(DDAmnpOK = 'Y') AND                         162441
     C*****************************(DDTotIOK = 'Y')                             162441
     C                   IF        (DDAmnpOK <> 'N') AND                        162441
     C                             (DDTotIOK <> 'N')                            162441
                                                                                              247452
     C     DDSTRT        IFEQ      *BLANKS                                                    247452
 
      **  Set the sign of the Amount and Total Interest depending upon the
      **  type of deal.  Signs of these two fields will always be opposite.
      **  Amount is -ive for a Loan, +ive for a deposit.
 
     C     DDTYPE        IFEQ      'IP'
     C     DDTYPE        OREQ      'TI'
     C     DDTYPE        OREQ      'CL'
     C     DDTYPE        OREQ      'LN'
     C     DDTYPE        OREQ      'DL'
 
     C     IKAMNP        IFGT      0
     C                   Z-SUB     IKAMNP        IKAMNP
     C                   ENDIF
     C     IKMTTI        IFLT      0
     C                   Z-SUB     IKMTTI        IKMTTI
     C                   ENDIF
 
     C                   ELSE
 
     C     IKAMNP        IFLT      0
     C                   Z-SUB     IKAMNP        IKAMNP
     C                   ENDIF
     C     IKMTTI        IFGT      0
     C                   Z-SUB     IKMTTI        IKMTTI
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF                                                                247452
 
     C                   ENDIF
 
     C*******************IF        (DDBsRCOK = 'Y')                             162441
     C                   IF        (DDBsRCOK <> 'N')                            162441
      **  Set spread field to spread/rate if base rate code entered,
      **  if not, set input interest field to spread/rate.
     C     DDBSRC        IFNE      *BLANKS
     C                   MOVE      @SPRD         IKSPRD
     C                   ELSE
     C                   MOVE      @SPRD         IKIIRT
     C     DDNGVI        IFEQ      'Y'
     C                   Z-SUB     IKIIRT        IKIIRT
     C                   END
     C                   END
 
     C                   ENDIF
 
      ****Reverse*Interest*rate*sign*if*negative*interest*is*required.*                       217845
     C*****DDNGVI        IFEQ      'Y'                                          B*2           217845
     C**********         Z-SUB     IKINTR        IKINTR                         **2           217845
     C**********         END                                                    E*2           217845
                                                                                              CDL010
      ** Set up The user field from ZMUSER which is the front office                          CDL010
      ** user if sent . Only if CDL010 is installed                                           CDL010
                                                                                              CDL010
     C     CDL010        IFEQ      'Y'                                                        CDL010
     C                   MOVE      ZUSER         IKUSER                                       CDL010
     C                   END                                                                  CDL010
                                                                                              CDL016
      ** Set up Rollover Indicator field if CDL016 is on                                      CDL016
                                                                                              CDL016
     C     CDL016        IFEQ      'Y'                                                        CDL016
     C                   MOVE      DDROLI        IKROLI                                       CDL016
     C                   ENDIF                                                                CDL016
                                                                                              CDL038
      ** Set up Class                                                                         CDL038
                                                                                              CDL038
     C                   MOVE      DDCLAS        IKCLAS                                       CDL038
      *                                                                                       CER020
     C                   IF        CER020 = 'Y'                                               CER020
     C                   MOVEL     DDORDN        IKORDN                                       CER020
     C                   ENDIF                                                                CER020
                                                                                              CRE073
     C                   IF        CRE073 = 'Y'                                               CRE073
     C                   MOVEL     TMCNSP        IKCNSP                                       CRE073
     C                   MOVEL     DDRDMT        IKRDMT                                       CRE073
     C                   MOVEL     DDRDFD        IKRDFD                                       CRE073
     C                   ENDIF                                                                CRE073
 
     C                   EVAL      VldBsDyC = BsDayConv                                       CDL096
                                                                                              CDL096
     C                   ENDSR
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *  SRSPSG - Validate Contractual Spread/Sign                    *                       CRE073
      *****************************************************************                       CRE073
     C     SRSPSG        BEGSR                                                                CRE073
                                                                                              CRE073
     C                   EXSR      RESETERRS                                                  CRE073
                                                                                              CRE073
     C                   MOVE      DDCNSP        PSCRF                                      AR947093
     C                   CALLB     'ZA0841'                                                 AR947093
     C                   PARM      *BLANKS       PRTCD                                      AR947093
     C                   PARM                    PSCRF            16                        AR947093
     C                   PARM      7             PNDEC             2 0                      AR947093
     C                   PARM      4             PNDIG             2 0                      AR947093
     C                   PARM      'N'           @@MTID            1                        AR947093
     C                   PARM      0             @@ERCD            1 0                      AR947093
     C                   PARM                    @@AMT            15 0                      AR947093
     C                   PARM                    BNDCSP                                     AR947093
                                                                                            AR947093
     C     @@ERCD        IFNE      0                                                        AR947093
     C                   EVAL      DDCNSPOK = 'N'                                           AR947093
     C                   EVAL      Idx = Idx + 1                                            AR947093
     C                   EVAL      FldNameArr(Idx) = 'DDCNSP'                               AR947093
     C                   EVAL      MsgIDArr(Idx) = 'USR9023'                                AR947093
     C                   ELSE                                                               AR947093
                                                                                            AR947093
     C                   CALLB     'AOBSRTR0'                                                 CRE073
     C                   PARM      *BLANK        PRTCD                                        CRE073
     C                   PARM      '*KEY'        POPTN                                        CRE073
     C                   PARM                    DDCCY                                        CRE073
     C                   PARM                    DDBSRC                                       CRE073
     C     SDBSRT        PARM      SDBSRT        DSSDY                                        CRE073
     C                                                                                        CRE073
     C                   EVAL      WWBRTT = 0                                                 CRE073
     C                   IF        PRTCD = *BLANKS                                            CRE073
     C                   EVAL      WWBRTT = BACBSR                                            CRE073
     C                   ENDIF                                                                CRE073
     C                                                                                        CRE073
     C                   EVAL      WDDBRTT = *BLANKS                                          CRE073
     C                   IF        WWBRTT <> 0                                                CRE073
     C                   EVAL      WDDBRTT = %CHAR(WWBRTT)                                    CRE073
     C                   EVAL      WDDBRTT = %TRIMR(WDDBRTT)                                  CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
      ** Need to set this ok flag to Yes because is not existing on OKFlagsDS                 CRE073
     C                   EVAL      DDDCSGOK ='Y'                                              CRE073
     C                   CALL      'ZAVCSPSG'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM                    WDDBRTT                                      CRE073
     C                   PARM                    DDBSRC                                       CRE073
     C                   PARM                    WWFXRT                                       CRE073
     C                   PARM                    DDCNSP                                       CRE073
     C                   PARM                    DDDCSG                                       CRE073
     C                   PARM      *ZERO         TMCNSP                                       CRE073
     C                   PARM                    PModule                                      CRE073
     C                   PARM      *ZERO         PCurset                                      CRE073
     C                   PARM                    FldNameArr                                   CRE073
     C                   PARM                    MsgIDArr                                     CRE073
     C                   PARM                    MsgDtaArr                                    CRE073
     C                   PARM                    Idx                                          CRE073
     C                   PARM                    DDCNSPOK                                     CRE073
     C                   PARM                    DDDCSGOK                                     CRE073
                                                                                              CRE073
     C                   MOVE      @@AMT         TMCNSP                                     AR947093
     C                   ENDIF                                                              AR947093
 
     C                   ENDSR                                                                CRE073
      *****************************************************************                       CRE073
      /EJECT                                                                                  CRE073
      *****************************************************************                       CRE073
      *  SRRNDM - Validate Rounding Method                            *                       CRE073
      *****************************************************************                       CRE073
     C     SRRNDM        BEGSR                                                                CRE073
                                                                                              CRE073
     C                   EXSR      RESETERRS                                                  CRE073
                                                                                              CRE073
     C                   CALL      'ZAVRNDMT'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM                    DDRDMT                                       CRE073
     C                   PARM                    DDCNSP                                       CRE073
     C                   PARM                    DDRDFD                                       CRE073
     C                   PARM                    PModule                                      CRE073
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
      *  SRRNDF - Validate Fraction/Decimal                           *                       CRE073
      *****************************************************************                       CRE073
     C     SRRNDF        BEGSR                                                                CRE073
                                                                                              CRE073
     C                   EXSR      RESETERRS                                                  CRE073
                                                                                              CRE073
     C                   EVAL      DDRDFDOK = 'Y'                                             CRE073
     C                   CALL      'ZAVRNDFD'                                                 CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM                    DDRDFD                                       CRE073
     C                   PARM                    DDCNSP                                       CRE073
     C                   PARM                    DDRDMT                                       CRE073
     C                   PARM                    PModule                                      CRE073
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
     C                   EVAL      DDSPRT = *BLANKS                                           CRE073
     C                   CALL      'ZACALCSPRT'                                               CRE073
     C                   PARM      *BLANKS       PRTCD                                        CRE073
     C                   PARM                    WWBRTT                                       CRE073
     C                   PARM                    TMCNSP                                       CRE073
     C                   PARM                    DDDCSG                                       CRE073
     C                   PARM                    DDRDMT                                       CRE073
     C                   PARM                    DDRDFD                                       CRE073
     C                   PARM      *ZERO         NEWSRT                                       CRE073
     C                   PARM      *ZEROS        NEWFRT                                     AR847249
                                                                                              CRE073
     C                   IF        PRTCD <> *BLANKS                                           CRE073
     C                   EXSR      *PSSR                                                      CRE073
     C                   ELSE                                                                 CRE073
                                                                                              CRE073
     C**********         IF        NEWFRT = 0 AND                                  AR953104 AR947093
     C**********                   DDRDMT <> *BLANKS                               AR953104 AR947093
     C**********         EVAL      DDRDMTOK = 'N'                                  AR953104 AR947093
     C**********         EVAL      Idx = Idx + 1                                   AR953104 AR947093
     C**********         EVAL      FldNameArr(Idx) = 'DDRDMT'                      AR953104 AR947093
     C**********         EVAL      MsgIDArr(Idx) = 'USS0015'                       AR953104 AR947093
      **********                                                                   AR953104 AR947093
     C**********         EVAL      MsgDtaArr(Idx) = %EDITC(NEWFRT:'J')             AR953104 AR947093
      **********                                                                   AR953104 AR947093
     C**********         ELSE                                                      AR953104 AR947093
     C                   IF        NEWSRT <> *ZERO                                            CRE073
     C                   EVAL      DDSPRT = %CHAR(NEWSRT)                                     CRE073
     C                   EVAL      DDSPRT = %TRIMR(DDSPRT)                                    CRE073
     C                   EVAL      @SPRD  = NEWSRT                                          AR834585
     C**********         EVAL      IKINTR = NEWSRT + BaseRate                      AR834585 AR941424
     C                   ELSE                                                              AR1069531
     C                   EVAL      DDSPRT = %CHAR(NEWSRT)                                  AR1069531
     C                   EVAL      DDSPRT = %TRIMR(DDSPRT)                                 AR1069531
     C                   ENDIF                                                                CRE073
     C**********         ENDIF                                                     AR953104 AR947093
     C                   EVAL      IKINTR = NEWSRT + BaseRate                               AR941424
                                                                                              CRE073
     C                   ENDIF                                                                CRE073
                                                                                              CRE073
     C                   ENDSR                                                                CRE073
      *****************************************************************                     AR876535
      *                                                               *                     AR876535
      * ValidActInt- Subroutine to validate Actual Interest rate      *                     AR876535
      *                                                               *                     AR876535
      *****************************************************************                     AR876535
                                                                                            AR876535
     C     ValidActInt   BEGSR                                                              AR876535
                                                                                            AR876535
     C     CDL020        IFEQ      'Y'                                                      AR876535
                                                                                            AR876535
     C                   EXSR      RESETERRS                                                AR876535
                                                                                            AR876535
     C                   IF        (DDBsRCOK <> 'N')                                        MD023416
      **  Set spread field to spread/rate if base rate code entered                         MD023416
     C     DDBSRC        IFNE      *BLANKS                                                  MD023416
     C                   MOVE      @SPRD         IKSPRD                                     MD023416
     C                   ENDIF                                                              MD023416
     C                   ENDIF                                                              MD023416
                                                                                            MD023416
     C                   CALLB     'MMVACTINTR'                                             AR876535
     C                   PARM                    ReturnCode                                 AR876535
     C                   PARM                    MSG1                                       AR876535
     C                   PARM                    DDAIR                                      AR876535
     C                   PARM                    BGN0ST                                     AR876535
     C                   PARM                    BNDCSP                                     AR876535
     C                   PARM                    DDCCY                                      AR876535
     C                   PARM                    DDBSRC                                     AR876535
     C                   PARM                    IKDVSD                                     AR876535
     C                   PARM                    BJRDNB                                     AR876535
     C                   PARM                    IKSPRD                                     AR876535
     C                   PARM                    IKINTR                                     AR876535
                                                                                            AR876535
     C                   IF        MSG1 <> *Blanks                                          AR876535
     C                   EVAL      Idx = Idx + 1                                            AR876535
     C                   EVAL      FldNameArr(Idx) = 'DDAIR'                                AR876535
     C                   EVAL      MsgIDArr(Idx) = MSG1                                     AR876535
     C                   ENDIF                                                              AR876535
                                                                                            AR876535
      ** Use the return code's value to set the field's OK flag                             AR876535
     C                   CALLB     'ZASETOKFLG'                                             AR876535
     C                   PARM                    DDAIROK                                    AR876535
     C                   PARM                    ReturnCode                                 AR876535
     C                   PARM                    WarnGlobal                                 AR876535
                                                                                            AR876535
     C                   ENDIF                                                              AR876535
                                                                                            AR876535
     C                   ENDSR                                                              AR876535
      *****************************************************************                     MD030409
      *                                                               *                     MD030409
      * GetTaxInd - Subroutine to retrieve the Tax Indicator          *                     MD030409
      *                                                               *                     MD030409
      *****************************************************************                     MD030409
                                                                                            MD030409
     C     GetTaxInd     BEGSR                                                              MD030409
                                                                                            MD030409
     C                   EVAL      TaxInd = DDMTAX                                          MD030409
                                                                                            MD030409
     C                   IF        CER069 = 'Y' AND                                         MD030409
     C                             DDMTAX = 'A'                                             MD030409
                                                                                            MD030409
     C                   CALLB     'AOCUSTR1'                                               MD030409
     C                   PARM      *BLANKS       PRTCD                                      MD030409
     C                   PARM      '*KEY   '     POPTN                                      MD030409
     C                   PARM                    DDCUST                                     MD030409
     C                   PARM      *BLANKS       @KEY7                                      MD030409
     C     SDCUST        PARM      SDCUST        DSLDY                                      MD030409
                                                                                            MD030409
     C                   IF        PRTCD = *BLANKS                                          MD030409
     C                   CALL      'AOACTXR0'                                               MD030409
     C                   PARM      *BLANKS       PRTCD                                      MD030409
     C                   PARM      '*KEY   '     POPTN                                      MD030409
     C                   PARM                    BBCUST                                     MD030409
     C                   PARM                    DDBRCA                                     MD030409
     C     SDACTX        PARM      SDACTX        DSFDY                                      MD030409
                                                                                            MD030409
     C                   IF        PRTCD = *BLANKS AND                                      MD030409
     C                             AXETXS = 'T'                                             MD030409
     C                   EVAL      TaxInd = 'T'                                             MD030409
     C                   ENDIF                                                              MD030409
     C                   ENDIF                                                              MD030409
                                                                                            MD030409
     C                   ENDIF                                                              MD030409
                                                                                            MD030409
     C                   ENDSR                                                              MD030409
      *****************************************************************
     C/EJECT                                                                                  CDL096
      *****************************************************************                       CDL096
      ** VBDYCCY - Validate Business Day Convention Currency Fields                           CDL096
      *****************************************************************                       CDL096
     C     VBDYCCY       BEGSR                                                                CDL096
                                                                                              CDL096
     C                   EXSR      RESETERRS                                                  CDL096
                                                                                              CDL096
     C                   IF        CDL096  <> 'Y'                                             CDL096
     C                   LEAVESR                                                              CDL096
     C                   ENDIF                                                                CDL096
      *                                                                                       CDL096
      ** Call validation module for Payment Convention Currencies                             CDL096
     C                   CALLB     'MMVBDYCCY'   PMMvBDyCcy                                   CDL096
                                                                                              CDL096
      ** Update error info with that returned                                                 CDL096
      ** from the validation module                                                           CDL096
                                                                                              CDL096
     C                   EVAL      Ix = 1                                                     CDL096
     C                   DOW       FldNamErr(Ix) <> *Blanks                                   CDL096
     C                   EVAL      Idx = Idx + 1                                              CDL096
     C                   EVAL      FldNameArr(Idx) = FldNamErr(Ix)                            CDL096
     C                   EVAL      MsgIdArr(Idx) = MsgIdErr(Ix)                               CDL096
     C                   EVAL      Ix = Ix + 1                                                CDL096
     C                   ENDDO                                                                CDL096
                                                                                              CDL096
     C                   EVAL      Ix = 1                                                     CDL096
     C                   DOW       FldNamErr(Ix) <> *Blanks                                   CDL096
     C                   EVAL      WIdx = WIdx + 1                                            CDL096
     C                   EVAL      WFldNamArr(WIdx) = WFldNamErr(Ix)                          CDL096
     C                   EVAL      WMsgIdArr(WIdx) = WMsgIdErr(Ix)                            CDL096
     C                   EVAL      WMsgDtaArr(WIdx) = WMsgIdErr(Ix)                           CDL096
     C                   EVAL      Ix = Ix + 1                                                CDL096
     C                   ENDDO                                                                CDL096
     C                                                                                        CDL096
      *                                                                                       CDL096
     C                   ENDSR                                                                CDL096
     C/EJECT                                                                                  CDL096
      *****************************************************************                       CDL096
      ** VPAMCNV - Validate Business Day Convention Payment and                               CDL096
      **           Amount Convention fields                                                   CDL096
      *****************************************************************                       CDL096
     C     VPAMCNV       BEGSR                                                                CDL096
                                                                                              CDL096
     C                   EXSR      RESETERRS                                                  CDL096
                                                                                              CDL096
     C                   IF        CDL096  <> 'Y'                                             CDL096
     C                   LEAVESR                                                              CDL096
     C                   ENDIF                                                                CDL096
      *                                                                                       CDL096
      ** Call validation module for Payment and Amount Convention                             CDL096
     C                   CALLB     'MMVPAMCNV'   PMMvPAmCnv                                   CDL096
                                                                                              CDL096
      ** Update error info with that returned                                                 CDL096
      ** from the validation module                                                           CDL096
                                                                                              CDL096
     C                   EVAL      Ix = 1                                                     CDL096
     C                   DOW       FldNamErr(Ix) <> *Blanks                                   CDL096
     C                   EVAL      Idx = Idx + 1                                              CDL096
     C                   EVAL      FldNameArr(Idx) = FldNamErr(Ix)                            CDL096
     C                   EVAL      MsgIdArr(Idx) = MsgIdErr(Ix)                               CDL096
     C                   EVAL      Ix = Ix + 1                                                CDL096
     C                   ENDDO                                                                CDL096
                                                                                              CDL096
     C                   EVAL      Ix = 1                                                     CDL096
     C                   DOW       FldNamErr(Ix) <> *Blanks                                   CDL096
     C                   EVAL      WIdx = WIdx + 1                                            CDL096
     C                   EVAL      WFldNamArr(WIdx) = WFldNamErr(Ix)                          CDL096
     C                   EVAL      WMsgIdArr(WIdx) = WMsgIdErr(Ix)                            CDL096
     C                   EVAL      WMsgDtaArr(WIdx) = WMsgIdErr(Ix)                           CDL096
     C                   EVAL      Ix = Ix + 1                                                CDL096
     C                   ENDDO                                                                CDL096
     C                                                                                        CDL096
      *                                                                                       CDL096
     C                   ENDSR                                                                CDL096
      /EJECT
      *****************************************************************
      *                                                               *
      * #TERM    - Termination processing.                            *
      *                                                               *
      *****************************************************************
     C     #TERM         BEGSR
      *
      **  Terminate program
      *
     C     *INU7         IFEQ      '1'
     C                   DUMP
     C                   END
      *
     C                   RETURN
      *
     C                   ENDSR
     C/COPY ZSRSRC,ZFEB29Z2LE                                                                 CDL093
     C/COPY ZSRSRC,ZDATE9Z3LE                                                                 CDL093
      ********************************************************************
      /EJECT
      ********************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,DBERREXIT
      ********************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
     X/COPY ZSRSRC,ZDATE9Z4                                                                   CDL093
