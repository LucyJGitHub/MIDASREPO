     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities trade - interface controller')     *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRADVU - SE Securities Trades - validate and update        *
      *                                                               *
      *  Function: This program validates securities details for      *
      *            input into the Midas database.                     *
      *            The action code determines which processes are     *
      *            executed as follows:                               *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the transaction details fields        *
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
      *            whether to write to the valid or invalid file and  *
      *            the call to the message handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. MD035243           Date 29Jul15               *
      *  Prev Amend No. AR596191           Date 19Aug14               *
      *                 AR971184A          Date 22Jun12               *
      *                 AR971184           Date 28May12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CSF011             Date 12Sep11               *
      *                 CER049             Date 06Dec10               *
      *                 AR698195B          Date 20Jan11               *
      *                 AR639840           Date 09Sep10               *
      *                 AR638989           Date 08Sep10               *
      *                 AR589197           Date 11Aug10               *
      *                 CSW210             Date 04May10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22911           Date 17Feb09               *
      *                 CER048             Date 19May08               *
      *                 BUG27876           Date 06Jul10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG22232           Date 16Jan09               *
      *                 256564             Date 17Sep08               *
      *                 BUG21092           Date 23Sep08               *
      *                 BUG18525           Date 07May08               *
      *                 249422             Date 28Jul07               *
      *                 247873             Date 15Jun07               *
      *                 247451             Date 16May07               *
      *                 246736             Date 28Mar07               *
      *                 BUG14806A          Date 14Sep07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 245542             Date 11Feb07               *
      *                 244537             Date 17Aug05               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12874           Date 12Dec06               *
      *                 BUG12579           Date 21Nov06               *
      *                 CSW206E            Date 24Aug06               *
      *                 BUG8690R (Reopen)  Date 09Jun06               *
      *                 238825 (Reopen)    Date 06Jun06               *
      *                 BUG11622           Date 27Jun06               *
      *                 BUG11529           Date 22Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 238825             Date 21Apr06               *
      *                 238859             Date 21Apr06               *
      *                 BUG11213           Date 18Apr06               *
      *                 CSD027A            Date 05May06               *
      *                 BUG11197           Date 25Apr06               *
      *                 BUG11194           Date 24Apr06               *
      *                 BUG10476           Date 15Feb06               *
      *                 BUG10085           Date 15Mar06               *
      *                 BUG10041           Date 08Feb06               *
      *                 BUG10202           Date 29Jan06               *
      *                 BUG10021           Date 23Jan06               *
      *                 BUG9961            Date 19Jan06               *
      *                 BUG9917            Date 17Jan06               *
      *                 CAP087             Date 17Aug05               *
      *                 BUG9089            Date 25Apr05               *
      *                 CER001             Date 25Apr05               *
      *                 CSE075             Date 17Nov05               *
      *                 BUG8087            Date 03Aug05               *
      *                 BUG8039            Date 02Aug05               *
      *                 237063             Date 20Nov05               *
      *                 BUG8119            Date 20Oct05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG8690            Date 14Nov05               *
      *                 BUG7029            Date 09Jun05               *
      *                 BUG6496            Date 24Apr05               *
      *                 BUG5557            Date 26Jan05               *
      *                 BUG5230            Date 13Dec04               *
      *                 BUG4728            Date 05Nov04               *
      *                 BUG4482            Date 29Sep04               *
      *                 BUG4070            Date 24Aug04               *
      *                 BUG2274            Date 19Aug04               *
      *                 BUG3950            Date 10Aug04               *
      *                 BUG3122            Date 17Jul04               *
      *                 BUG3145            Date 15Jun04               *
      *                 MLFIX1             Date 26May04               *
      *                 CGL014             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 TDA035             Date 02Apr04               *
      *                 CSC022             Date 24Feb04               *
      *                 BUG1569            Date 17Mar04               *
      *                 225421  (BUG1356)  Date 04Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084  *CREATE    Date 14Jul03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD035243 - Error message for Account with Institution        *
      *             Account is not properly displayed                 *
      *  AR596191 - Error on Safekeeping Account is issued even if    *
      *             a valid value is inserted                         *
      *  AR971184A- During Amend Front Ofc Id must be updated with the*
      *             new one                                           *
      *  AR971184 - For some JMS APIs (CUSD, AMAD, DPMV, OPAY), Front *
      *             Office Id is no more updated in master database   *
      *             files which provokes some big problems in third   *
      *             party product such as TOF.(Child:AR971185)        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *  CSF011 - Customer Name on Inputs                             *
      *  CER049 - Stamp Tax                                           *
      *  AR698195B - Added Front Office field on the buffer for TRADS *
      *             (Child: AR698196)                                 *
      *  AR639840 - Safekeeping Account is being blanked-out          *
      *  AR638989 - Beneficiary of Money account should be            *
      *             highlighted in blue                               *
      *  AR589197 - The input validation of //xx has been removed if  *
      *             ISO15022 is switched on, it should be reapplied   *
      *             as the code is still used                         *
      *  CSW210 - SWIFT 2010 Changes                                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22911 - Changes for Correct Tax Calculation (Recompile)   *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  BUG27876 - Serious midas error upon clicking settlement tab  *
      *  BUG22232 - Missing authorization field in repository.        *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG21092 - Missing SWIFT Identifier in Destination of        *
      *             Confirmation field.                               *
      *  BUG18525 - Redefault Trade Extension (SWIFT) A details if    *
      *             blank and action code is insert.                  *
      *  249422 - Front Office ID should be blank.                    *
      *  247873 - Re-default Destination of Settlements based on new  *
      *           Deliver To/From when trade is edited.               *
      *  247451 - Pass Customer Number not Shortname to SETSESDFT and *
      *           SEDORFRTV to prevent dumps later.                   *
      *  246736 - Initialise ECD.                                     *
      *  BUG14806A - Recompile Program due to Decimal Error           *
      *  245542 - Do not default the safekeeping twice.               *
      *  244537 - To avoid overriding front office identifier.        *
      *  BUG12874 - Do not invoke AOSECSR0 if the depot customer      *
      *             is blank                                          *
      *  BUG12579 - Added CSW206 flag as parameter for SETRADCVT2     *
      *  CSW206E - Change Control for SWIFT 2006 Standard Changes     *
      *  BUG8690R - Countervalue not updated and Multiply/Divide      *
      *             indicator entered by user overridden              *
      *  238825 - (Reopen) Enhance part of fix BUG9917 and BUG8690    *
      *           to prevent overriding of defaults to blanks when    *
      *           no input is made to clearance tupe and with deliver *
      *           (to and from ) fields.                              *
      *           Part of this fix already done by BUG11529.          *
      *  BUG11622-Customer number not being setup correctly caused    *
      *           DB error in AOSECSR0.                               *
      *  BUG11529 - Error in defaulting Settlement Details            *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  238825 - Determine if CSE022 is switched on in order to      *
      *           call module SEDORFRTV for proper defaulting of      *
      *           of extended swift settlement details during insert  *
      *           of trade.                                           *
      *           Part of this fix already done by BUG10085.          *
      *  238859 - Do not validate transaction when deleting.  Applied *
      *           fix BUG8087.                                        *
      *  BUG11213- Defaulting of other details should be done only    *
      *            during first time of processing flow.  Applied     *
      *            fixes BUG8690, BUG9917 and BUG10021 annotated by   *
      *            the same corresponding bug references.             *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  BUG11197- Settlement Ex-rate and M/D indicator should        *
      *            default when ccy changes.                          *
      *  BUG11194 - SEFRN- Purchased Interest not recalculated when   *
      *             trade value date is changed
      *  BUG10476- Market Centre defaulting.                          *
      *          - Place of settlement defaulting.                    *
      *  BUG10085- Safekeeping Account not defaulted                  *
      *  BUG10041 - Checking of Security name should be done for      *
      *             delete.                                           *
      *  BUG10202- Mapping error in TRAD                              *
      *  BUG10021- Exchange rate and M/D indicator not defaulting.    *
      *  BUG9961- Parameter mismatch for ZDYYR due to changes made    *
      *           by CSE071 and CAP087.                               *
      *  BUG9917- Include the Deliver From and Deliver To Field       *
      *           in checking before passing thru the default values, *
      *           this is in conjunction with BUG8690.                *
      *  CAP087  - Enable the use of SETRADVU to process Buy/Sell     *
      *            trades.                                            *
      *  BUG9089- Mapping error with Java for DPMV                    *
      *  CER001 - LUX Upgrade to MidasPlus.                           *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  BUG8087 - Do not validate transaction when deleting          *
      *  BUG8039 - Recompile due to change in SEVTCUST                *
      *  237063 - EU Tax fixes upgrade to MP build 103.               *
      *  BUG8119 - Fields returned incorrectly from API if update     *
      *            flag set to 'Y' but data is invalid.               *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG8690 - Only default exchange rate, settlement details     *
      *            or charge details if they haven't been entered     *
      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  BUG6496 - Missing CAS006 fields in Securities and Trades     *
      *            Maintenance.                                       *
      *  BUG5557 - Information for TRADSDX2 are being dropped during  *
      *            insert.                                            *
      *  BUG5230 - To ensure information output to Buffer is a true   *
      *            picture of the update.                             *
      *  BUG4728 - Serious Midas error with blank timestamp when      *
      *            authorising insert of transaction.                 *
      *  BUG4482 - Authorise should call Validate to show all the     *
      *            warning errors.                                    *
      *  BUG4070 - Countervalue and nominal currency code not being   *
      *            passed to API for deletion of trades.              *
      *  BUG2274 - Unable to access SSI information because market    *
      *            not being passed in.                               *
      *  BUG3950 - Stop validation if there is error on Security      *
      *            and counterparty.                                  *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  BUG3145 - Charges and Commission are being missed out of the *
      *            calculation of countervalue.                       *
      *  MLFIX1 - Add investment type to output message for           *
      *           management limit.                                   *
      *  CGL014 - Collaterals Processing                              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  BUG1569- Stopping user updating the same record at the same  *
      *           time.                                               *
      *  225421 - The Validation of Safekeeping A/C is out off       *
      *           sequence.                                           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - API Wrapper project                                 *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************
 
      * Trades Extended Settlements
     FTRADSDY2  IF   E           K DISK
     FSEVTRADL1 IF   E           K DISK    RENAME(SEVTRADD0:SEVTRADCK1)
     F                                     INFSR(*pssr)
 
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
                                                                                            BUG10476
     FSEMKC     IF   E           K DISK                                                     BUG10476
      ** Midas SE Market Centres                                                            BUG10476
 
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
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API CTL & VU modules.
     D/COPY ZACPYSRC,APICTLARR
      **-----------------------------------------------------------------------
 
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
                                                                                              CSC022
     D WCmtJobArr      S             10A   DIM(10)                                            CSC022
      ** Array for commitment job names                                                       CSC022
 
      * Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)
      *
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(SETRPRPD)
     D TranInSeco    E DS                  EXTNAME(SETRSEPD)
     D TranInPrev    E DS                  EXTNAME(SETRPVPD)                                BUG11194
     D TranInExch    E DS                  EXTNAME(SETREXPD)
     D TranInSett    E DS                  EXTNAME(SETRSTPD)
     D DDCLTY2       E                     EXTFLD(DDCLTY)
     D TranInChCm    E DS                  EXTNAME(SETRCCPD)
     D TranInSwfA    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(A)
     D TranInSwfB    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(B)
     D TranInThir    E DS                  EXTNAME(SETRTHPD)
 
 
     D ValidTrad     E DS                  EXTNAME(SEVTRADPD)
     D                                     PREFIX(V_)
     D ValidTrX1     E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(V_)
     D ValidTX1A     E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(VA_)
     D ValidTX1B     E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(VB_)
 
     D ValidTrX2     E DS                  EXTNAME(SEVTRX2PD)
     D                                     PREFIX(V_)
     D ValidTX2A     E DS                  EXTNAME(SEVTRX2PD)
     D                                     PREFIX(VA_)
     D ValidTX2B     E DS                  EXTNAME(SEVTRX2PD)
     D                                     PREFIX(VB_)
     D ValidLUX      E DS                  EXTNAME(SEVTDLX1PD)                                CER001
      *                                                                                       CER001
      ** Trade Details Extension File                                                         CER001
      *                                                                                       CER001
     D SVRCD         E DS                  EXTNAME(SETRX1PD)                                  CER001
      *                                                                                       CER001
     D OKFlagsDS     E DS                  EXTNAME(SEETDLX1PD)                                CER001
 
     D TradFilFmt    E DS                  EXTNAME(TRADSD)
     D TX1AFilFmt    E DS                  EXTNAME(TRADSDX1)
     D                                     PREFIX(A_)
     D TX1BFilFmt    E DS                  EXTNAME(TRADSDX1)
     D                                     PREFIX(B_)
     D TX2AFilFmt    E DS                  EXTNAME(TRADSDX2)
     D                                     PREFIX(A_)
     D TX2BFilFmt    E DS                  EXTNAME(TRADSDX2)
     D                                     PREFIX(B_)
 
 
      * (Current) Trade in Screen Format - Primary Details
     D CurTrPrim     E DS                  EXTNAME(SETRPRPD)
     D                                     PREFIX(@)
      * (Current) Trade in Screen Format - Secondary Details
     D CurTrSeco     E DS                  EXTNAME(SETRSEPD)
     D                                     PREFIX(@)
      * (Current) Trade in Screen Format - Exchange Rates Details
     D CurTrExch     E DS                  EXTNAME(SETREXPD)
     D                                     PREFIX(@)
      * (Current) Trade in Screen Format - Settlement Instructions
     D CurTrSett     E DS                  EXTNAME(SETRSTPD)
     D                                     PREFIX(@)
     D @DDCLTY2      E                     EXTFLD(DDCLTY)
      * (Current) Trade in Screen Format - Charges/Commissions
     D CurTrChCm     E DS                  EXTNAME(SETRCCPD)
     D                                     PREFIX(@)
      * (Current) Trade in Screen Format - SWIFT 'A' Details
     D CurTrSwftA    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(@A)
      * (Current) Trade in Screen Format - SWIFT 'B' Details
     D CurTrSwftB    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(@B)
      * (Current) Trade in Screen Format - SWIFT 'A' Details
     D CurX2SwftA    E DS                  EXTNAME(SETESDPD)
     D                                     PREFIX(@A)
      * (Current) Trade in Screen Format - SWIFT 'B' Details
     D CurX2SwftB    E DS                  EXTNAME(SETESDPD)
     D                                     PREFIX(@B)
      ** (Current) Trade in Screen Format - Third screen details
     D CurTrThir     E DS                  EXTNAME(SETRTHPD)
     D                                     PREFIX(@)
      *
      ** Securities retrieved from file - file format
     D CrSEFilFmt    E DS                  EXTNAME(TRADSDX2)
 
     D*OthDdata        DS          3116                                                       CSW210
     D**TranInExt1             1   1558                                                       CSW210
     D**TranInExt2          1559   3116                                                       CSW210
     D***OthDdata        DS          3526                                             CSW210 CSF011A
     D***TranInExt1             1   1763                                              CSW210 CSF011A
     D***TranInExt2          1764   3526                                              CSW210 CSF011A
     D OthDdata        DS          4878                                                      CSF011A
     D  TranInExt1             1   2439                                                      CSF011A
     D  TranInExt2          2440   4878                                                      CSF011A
      *
     D  TranInExtA   E DS                  EXTNAME(SETESDPD)
     D                                     PREFIX(A)
     D  TranInExtB   E DS                  EXTNAME(SETESDPD)
     D                                     PREFIX(B)
      *
      ** Securities screen 1 details retrieved from file - screen format
     D NwSE1ScnFmt   E DS                  EXTNAME(SETESDPD)
      *
      * Error indicators
     D OKTrPrim      E DS                  EXTNAME(SEETRPRPD)
     D OKTrSeco      E DS                  EXTNAME(SEETRSEPD)
     D OKTrThir      E DS                  EXTNAME(SEETRTHPD)
     D OKTrExch      E DS                  EXTNAME(SEETREXPD)
     D OKTrSett      E DS                  EXTNAME(SEETRSTPD)
     D DDCLTY2OK     E                     EXTFLD(DDCLTYOK)
     D OKTrChcm      E DS                  EXTNAME(SEETRCCPD)
     D OKTrSwft      E DS                  EXTNAME(SEETRSWPD)
     D OKX2Swft      E DS                  EXTNAME(SEETESPD)
 
      ** Security Details
     D SECTY         E DS                  EXTNAME(SECTYD)
     D SEC_RECI      E                     EXTFLD(RECI)
     D SEC_ZZ005     E                     EXTFLD(ZZ005)
     D SEC_LCD       E                     EXTFLD(LCD)
     D SEC_CHTP      E                     EXTFLD(CHTP)
     D SEC_TNLU      E                     EXTFLD(TNLU)
     D SEC_REPI      E                     EXTFLD(REPI)
     D SEC_FRNT      E                     EXTFLD(FRNT)
     D SEC_REPA      E                     EXTFLD(REPA)
     D SEC_TMST      E                     EXTFLD(TMST)
     D SEC_SEZONE    E                     EXTFLD(SEZONE)                                     225421
     D  CDArr                183    230                                                       CAP087
     D  CRArr                231    242                                                       CAP087
     D SEC_SETX              243    243                                                       237063
 
      ** Investment Type Details
     D INVTP         E DS                  EXTNAME(INVTPD)
     D INV_RECI      E                     EXTFLD(RECI)
     D INV_LCD       E                     EXTFLD(LCD)
     D INV_CHTP      E                     EXTFLD(CHTP)
     D INV_TNLU      E                     EXTFLD(TNLU)
     D INV_NDEC      E                     EXTFLD(NDEC)
 
      ** Overall Transaction status, to be passed to the Message Handler
     D TranStatus      S              1A
 
      ** The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
      ** The following /COPY includes the currency details data structures
     D/COPY SECPYSRC,SE_CCYDT
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External DS for Branch Details
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
      ** External DS for Security Customer Details
      *
      ** Externally described DS for midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** Externally described DS for funds transfer ICD details
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
      *
      ** Externally described DS for API ICD details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      *
      ** Externally described DS for retail ICD details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  QQACC2       E                     EXTFLD(QQACCD)                                     CGL029
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SLCD          E                     EXTFLD(LCD)
      *
      ** Externally described DS for securities trading details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      *
      ** Externally described DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *                                                                                       247451
      ** Externally described DS for customer details                                         247451
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  247451
     D  QQDFA2       E                     EXTFLD(QQDFAC)                                     247451
 
     D Indicators      DS                  BASED(IndicatorP)
     D  RecNotFnd             01     01
 
      ** 24x7 Status Dataarea
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** Additional entry parameter for Midas Compliance Watch
     D PMCWL           DS          9999
 
      ** SD Data Area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
     D InfData       E DS                  EXTNAME(SETRIFPD)
      * SE Extra Data - Classe 1 Data - File (D/B) format
 
     D ExtData       E DS                  EXTNAME(SETDEXPD)
      * SE Trades Extra Data - File (D/B) format
      *                                                                                       CER001
      ** Extra data in file format (Regional)                                                 CER001
      *                                                                                       CER001
     D RegData       E DS                  EXTNAME(SETDRXPD)                                  CER001
 
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Stamp Tax                                                                            CER049
     D StampTax      E DS                  EXTNAME(TRADSDQD)                                  CER049
 
      ** DS for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10
     D  PDBRN                 11     13
     D  PDPPT                 14     16
      *
     D D@USER        E DS                  EXTNAME(MUSERDD)
     D DRECI         E                     EXTFLD(RECI)
     D DLCD          E                     EXTFLD(LCD)
     D DCHTP         E                     EXTFLD(CHTP)
 
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
     D  ComitJob               4    103                                                       CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
      *                                                                                       CER001
      ** Data passed from caller program                                                      CER001
      *                                                                                       CER001
     D DATALUX         DS          1024                                                       CER001
     D  PETDRF                 1      6                                                       CER001
     D  UTDBK                  7      8                                                       CER001
     D  UVTCNR                 9     14                                                       CER001
     D  #1TDVD                15     19  0                                                    CER001
     D  #1TDDT                20     24  0                                                    CER001
     D  #1ISSD                25     29  0                                                    CER001
     D  #1MATY                30     34  0                                                    CER001
     D  #1FOTR                35     54                                                       CER001
     D  #1TMST                55     80Z                                                      CER001
                                                                                              CSC022
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  CSF011
     D                                     PREFIX(NO_)                                        CSF011
     D ACCNT         E DS                  EXTNAME(ACCNTAB)                                   CSF011
     D                                     PREFIX(AC_)                                        CSF011
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      * Error message field(s)
     D     Msg1        S                   LIKE(#MsgID)
 
      * Index for arrays of error message ids etc in amend validation
     D AmIdx           S              3P 0 INZ(0)
 
      * Index for arrays of error message ids etc
     D Idx             S              3P 0 INZ(0)
 
      * Index for arrays of warning message ids etc
     D WIdx            S              3P 0 INZ(0)
 
      * Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
     D Trans5002       S            500A
     D Trans5002B      S            500A                                                    BUG11194
     D Trans5003       S            500A
     D***Trans5004       S            500A                                                   CSF011A
     D Trans5004       S           1000A                                                     CSF011A
     D Trans5005       S            500A
     D Trans5006       S            500A
     D Trans5007       S            500A
     D Trans5008       S            500A
     D TransQ          S            500A                                                      CER049
 
      * Field (500A) to receive the incoming Extra Data
     D OthData500      S            500A                                                     BUG9089
     D InfData500      S            500A
     D ExtData500      S            500A
      ** Field (4755A) to receive the incoming Extra Data
     D***OthDData4755    S           4755A                                                   CSF011A
     D OthrData        S           4878A                                                     CSF011A
      *                                                                                       CER001
      ** Extra Data (Regional)                                                                CER001
      *                                                                                       CER001
     D RegData500      S            500A                                                      CER001
 
      ** Country of treaty
     D PDRBW           S              2A
      *
      ** Withholding tax
     D DDWTAX          S             15A
      *
      ** Switchable features
     D CAP051          S              1A
     D CEU005          S              1A
     D CSW201          S              1A
     D CSW003          S              1A
     D CSE011          S              1A
     D S01401          S              1A
     D CSE028          S              1A
     D CSC011          S              1A
     D CAS006          S              1A
     D ULX008          S              1A                                                      CER001
     D ULX603          S              1A                                                      CER001
     D CGL031          S              1A                                                      CGL031
     D CSW206          S              1A                                                     CSW206E
     D CSW210          S              1A                                                      CSW210
     D CFT004          S              1A                                                      CSW210
      *
      ** Work variable
     D CallFromVU      S              1A   INZ('Y')                                           CAP087
     D CPartyClass     S              1A
     D DDHACR          S             13A
     D DDPRICN         S             17A
     D PMODE           S              3A
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
     D BeforeIdx       S              3  0
     D BeforeWIdx      S              3  0
     D StepIdx         S              3  0
     D UpdRtnCode      S              7A
     D WkDate          S              5  0
     D WkNext          S              5  0
     D WorkTime        S             26A
     D WDDDELF         S             10A                                                     BUG9917
     D WDDDELT         S             10A                                                     BUG9917
     D WDDORBR         S                   LIKE(DDORBR)                                     BUG11529
     D WrkDfltInd      S              1A                                                    BUG11529
                                                                                              CSF011
     D WNumDetlIn      S           1000A                                                      CSF011
     D CusIdx          S              4S 0 INZ(1)                                             CSF011
     D CusIdx2         S              4S 0 INZ(1)                                             CSF011
     D CusLength       S              2S 0 INZ(40)                                            CSF011
     D AccLength       S              2S 0 INZ(72)                                            CSF011
     D ACusLngth       S              2S 0 INZ(52)                                            CSF011
     D W@Len           S              2S 0                                                    CSF011
     D NoOfCusField    S              2S 0 INZ(21)                                            CSF011
     D NoOfCusField2   S              2S 0 INZ(13)                                           CSF011A
     D CusOrAcc        C                   CONST('CAABBBBBBBBBBBBBBBBBB')                     CSF011
     D P@TYP           S             10                                                       CSF011
     D P@Str           S             35                                                       CSF011
     D P0RETL          S             10                                                       CSF011
     D WCustomer       S             10                                                       CSF011
     D C#KYST          S              7                                                       CSF011
     D W@Abc           S              1                                                       CSF011
     D WBrch           S              3                                                       CSF011
 
      * Timestamp for the transaction
     D WTimeStamp      S               Z
     D CSE022          S              1A
     D CSW014          S              1A
     D SWRTN           S              7A
     D WTDTP           S              2A
     D WWCLTY          S              2A
     D PGMNAM          S              9A
     D PWHEN           S              1A
     D PMKCT           S              2A
     D DFTFLG          S              1A
     D PMODE2          S              6A                                                    MD035243
      *
      ** Data structure to receive parameters from SE1805 for MT5xxs
     D PDATA         E DS                  EXTNAME(SE50DT)
      *
      ** Mode = '*FRONT' (front office transaction interface)
      ** Mode = '      ' (not front office transaction interface)
      ** Mode = '*RPR  ' (repair function)
      ** Mode = '*SIN  ' (screen input function)
     D PINKS           S              1A
     D PINKT           S              1A
     D PCUST           S              6A
     D WCTPCN          S              6A
     D PDEPO           S              6A
     D PDEPO2          S              6A
     D PRETC           S             10A
     D PSKAL           S             20A
 
      * No of Interest Days in year                                                           CAP087
     D DaysInYear      S              3  0                                                    CAP087
     D Out_DaysYear    S              3A                                                      CAP087
                                                                                              CSC022
     D Trade_Value     S             15  0                                                    CAP087
     D Out_Value       S             15A                                                      CAP087
                                                                                              CAP087
     D CSC022          S              1A                                                      CSC022
                                                                                              CSC022
     D WCommitSkip     S              1A                                                      CSC022
      ** Commitment Skip Field                                                                CSC022
                                                                                             BUG3145
     D CGL014          S              1A                                                     BUG3145
      ** Front office id variable.                                                         AR698195B
     D DDFRNT          S             20A                                                   AR698195B
                                                                                             BUG5230
      ***** Data used by SETRADR ******                                                      BUG5230
      ** Array of Fields in error.                                                           BUG5230
     D @FldNameArr     S             10A   DIM(ArrayMax)                                     BUG5230
                                                                                             BUG5230
      ** Array of error message IDs                                                          BUG5230
     D @MsgIDArr       S                   DIM(ArrayMax)                                     BUG5230
     D                                     LIKE(#MsgID)                                      BUG5230
                                                                                             BUG5230
      ** Array of error message data.                                                        BUG5230
     D @MsgDtaArr      S                   DIM(ArrayMax)                                     BUG5230
     D                                     LIKE(#MsgData)                                    BUG5230
                                                                                             BUG5230
      ** Array of message files to check                                                     BUG5230
     D @MsgFArray      S             10A   DIM(MsgFArrMax)                                   BUG5230
                                                                                             BUG5230
     D ROU             S              1    DIM(12)                                            247873
      *                                                                                       247873
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
      ** +--- Start of main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *                                                                                      BUG7029
      ** Retrieve ZMUSER details.                                                            BUG7029
      *                                                                                      BUG7029
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C                   IN        ZMUSER                                                    BUG7029
 
      * Incoming transaction is broken into 500A fields, so that a common CL
      * can be used between this module and the one that read the MQ queue.
      * This module needs to break these 500A fields by loading them into
      * the appropriate (externally described) data structure.
     C                   MOVEL     Trans5001     TranInPrim
     C                   MOVEL     Trans5002     TranInSeco
     C                   MOVEL     Trans5002B    TranInPrev                                 BUG11194
     C                   MOVEL     Trans5003     TranInExch
     C                   MOVEL     Trans5004     TranInSett
     C                   MOVEL     Trans5005     TranInChCm
     C                   MOVEL     Trans5006     TranInSwfA
     C                   MOVEL     Trans5007     TranInSwfB
     C                   MOVEL     Trans5008     TranInThir
     C**********         MOVEL     Infdata500    Infdata                                    BUG10202
     C                   MOVEL     Extdata500    Extdata
     C                   MOVEL     RegData500    RegData                                      CER001
     C**********         MOVEL     OthDData4755  OthDData                                    CSF011A
     C                   MOVEL     OthrData      OthDData                                    CSF011A
     C                   MOVEL     TranInExt1    TranInExtA
     C                   MOVEL     TranInExt2    TranInExtB
     C                   MOVEL     TransQ        StampTax                                     CER049
 
      * Reset variables gradually updated
     C                   EXSR      RESETCYCLE
 
      *  Check if valid trade exists for Midas Trade Ref
 
     C                   EXSR      ChkValMiTR
      *
      *  If valid trade does exist (even after delay), fail this input
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   END
 
      * Reset variables again in case the details have been corrupted
      * by previous chain to valid trades file.
 
     C                   EXSR      RESETCYCLE
 
      * Validate action code
     C                   EXSR      ValidateAc
      *
      * If error in validation of action code, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF
                                                                                            BUG27876
     C                   Z-ADD     0             NomCcyDec                                  BUG27876
 
      * Processing depends upon action code
     C                   SELECT
     C                   WHEN         DDACTN = 'I'
      * Force Interest Recalculation                                                        BUG11194
     C                   EXSR      SRIntCal                                                 BUG11194
                                                                                            BUG11194
      *  Processing for Inserts
     C                   EXSR      ValidateTr
 
     C                   WHEN         DDACTN = 'D'                                          BUG10041
                                                                                            BUG10041
      ** Processing for Delete                                                              BUG10041
                                                                                            BUG10041
     C                   EXSR      ValdTrPrim                                               BUG10041
                                                                                            BUG10041
     C                   WHEN         DDACTN = 'A'
     C                             OR DDACTN = 'C'
     C                             OR DDACTN = 'D'                                           BUG4070
     C                   EXSR      Fil2ScrnConv
      *  Processing for Amends or Changes
     C     GHSUBS        ifne      *blank
     C     GHSUBS        scan      TranInPrim                             99
     C  N99GHSUBS        scan      TranInSeco                             99
     C  N99GHSUBS        scan      TranInThir                             99
     C  N99GHSUBS        scan      TranInExch                             99
     C  N99GHSUBS        scan      TranInSett                             99
     C  N99GHSUBS        scan      TranInChCm                             99
     C  N99GHSUBS        scan      TranInSwfA                             99
     C  N99GHSUBS        scan      TranInSwfB                             99
     C     *in99         ifeq      *on
     C                   EXSR      TDtDtaSubs
     C                   endif
     C                   endif
     C     DDACTN        IFNE      'D'                                                       BUG8087
     C                   EXSR      SetupAmd
     C                   EXSR      ValidateTr
     C                   EXSR      ValdateAmd
     C                   ENDIF                                                               BUG8087
                                                                                             BUG4482
     C                   WHEN      DDACTN = 'X'                                              BUG4482
     C                             OR DDACTN = 'Y'                                            CAP087
      *  Processing for Authorises                                                           BUG4482
     C                   EXSR      ValidateTr                                                BUG4482
 
     C                   ENDSL
      *
     C     INVALID       TAG
      *                                                                                       CAP087
      * Calculate Days in Year                                                                CAP087
     C                   IF        Idx = 0                                                    CAP087
     C                   EXSR      CalcDays                                                   CAP087
     C                   ENDIF                                                                CAP087
                                                                                              CSF011
      ** Populate Customer or Account Details                                                 CSF011
                                                                                              CSF011
     C                   EXSR      SrCustName                                                 CSF011
     C                   EXSR      SrCustName2                                               CSF011A
                                                                                              CSF011
 
      * Write to database
     C     UpdateYN      IFEQ      'Y'
     C     Idx           ANDEQ     0
     C     Idx           IFEQ      0
     C                   EXSR      SETUPVALID
     C                   EXSR      UpdateDB
      *                                                                                       CER001
     C                   MOVE      DDTDRF        #6LXCCTDRF                                   CER001
      *                                                                                       CER001
     C                   IF        ULX603 = 'Y'                                               CER001
     C                   CALLB     'SETRAD2UP'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM      *BLANKS       ReturnCode                                   CER001
     C                   PARM      'Y'           @@FIND            1                          CER001
     C                   PARM                    ValidLUX                                     CER001
     C                   PARM      *BLANKS       SVRCD                                        CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF
     C                   ENDIF
 
     C                   SETON                                        LR
 
      ** If action is for Update, get the correct record information                         BUG5230
      ** from file                                                                           BUG5230
     C                   IF        UpdateYN = 'Y'                                            BUG5230
     C                             AND Idx = 0                                               BUG8119
     C                   MOVE      DDTDRF        DDTDRF_IN                                   BUG5230
     C                   CALL      'SETRADR'                                                 BUG5230
     C                   PARM                    @AuthComp         1                         BUG5230
     C                   PARM                    @FwdBck           1                         BUG5230
     C                   PARM                    DDTDRF_IN         6                         BUG5230
     C                   PARM                    Buffer                                      BUG5230
     C                   PARM                    Buffer2                                     CSF011A
     C                   PARM                    @FldNameArr                                 BUG5230
     C                   PARM                    @MsgIDArr                                   BUG5230
     C                   PARM                    @MsgDtaArr                                  BUG5230
     C                   PARM                    @MsgFArray                                  BUG5230
     C                   PARM                    @APIRetC          1                         BUG5230
     C                   MOVEL     DDACTN        Buffer                                      BUG5230
     C                   ELSE                                                                BUG5230
      * Remerge buffer with all relevant data structures
      ** RegData is being used for regional enhancement and therefore should                BUG10202
      ** always be the last data to form the buffer if no ExtData included                  BUG10202
      ** otherwise it should be positioned before ExtData                                   BUG10202
     C                   EVAL      Buffer = TranInPrim + TranInSeco +
     C                                      TranInPrev              +                       BUG11194
     C                                      TranInExch + TranInSett +
     C                                      TranInChCm +
     C                                      TranInSwfA + TranInSwfB +
     C**********                            TranInExtA + TranInExtB +                        CSF011A
     C                                    TranInExtA + %SUBST(TranInExtB:1:2228)             CSF011A
     C************                          TranInThir +                                     BUG1569
     C**********                            TranInThir + @TimeStamp +                BUG1569 CSF011A
     C**********                            SPBS + STBS + PROT + NomCcySWCY +                CSF011A
     C**********                            CPartyClass + BVAUTH +                           CSF011A
     C**********                            DDCPNR + DDTCTR + DDCFCT +                       CSF011A
     C**********                            A_DDROUS + A_DDROTS +                            CSF011A
     C**********                            A_DDROUC + A_DDROTC +                            CSF011A
     C**********                            B_DDROUS + B_DDROTS +                            CSF011A
     C**********                            B_DDROUC + B_DDROTC +                            CSF011A
     C**********                            DDSPXR + DDSPMD + DDWTAX +                       CSF011A
     C**********                            BKEURO + DDSTAT + DDAUTH                          MLFIX1
     C**********                            BKEURO + DDSTAT + DDAUTH +                MLFIX1 CSF011A
     C**********                            SITP                                      MLFIX1 CSF011A
     C**********                            + DDPRICN + DDHACR                        BUG6496 CER001
     C**********                            + DDPRICN + DDHACR + RegData              CER001 BUG9089
     C**********                            + DDPRICN + DDHACR + InfData            BUG9089 BUG10202
     C**********                            + RegData                               BUG9089 BUG10202
     C**********                            + DDPRICN + DDHACR                      BUG10202 CSF011A
     C**********                            + Out_Value + Out_DaysYear                CAP087 CSF011A
     C**********                            + RegData                             BUG10202 AR698195B
     C**********                            + DDFRNT + AAuth + RegData              AR698195B CER049
     C**********                            + DDFRNT + StampTax                       CER049 CSF011A
     C**********                            + AAuth                                   CER049 CSF011A
     C**********                            + RegData                                 CER049 CSF011A
     C                   EVAL      Buffer2 = %SUBST(TranInExtB:2229:211)                     CSF011A
     C                                    + TranInThir + @TimeStamp                          CSF011A
     C                                    + SPBS + STBS + PROT + NomCcySWCY                  CSF011A
     C                                    + CPartyClass + BVAUTH                             CSF011A
     C                                    + DDCPNR + DDTCTR + DDCFCT                         CSF011A
     C                                    + A_DDROUS + A_DDROTS                              CSF011A
     C                                    + A_DDROUC + A_DDROTC                              CSF011A
     C                                    + B_DDROUS + B_DDROTS                              CSF011A
     C                                    + B_DDROUC + B_DDROTC                              CSF011A
     C                                    + DDSPXR + DDSPMD + DDWTAX                         CSF011A
     C                                    + BKEURO + DDSTAT + DDAUTH                         CSF011A
     C                                    + SITP   + DDPRICN                                 CSF011A
     C                                    + DDHACR + Out_Value + Out_DaysYear                CSF011A
     C                                    + DDFRNT + StampTax + AAuth + Regdata              CSF011A
     C                   ENDIF                                                               BUG5230
 
     C                   RETURN
 
      *****************************************************************                       CSF011
      /EJECT                                                                                  CSF011
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      * SrCustname - Get the Customer details                         *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
     C     SrCustName    BEGSR                                                                CSF011
      ** Customer fields for retrieval of details                                             CSF011
     C                   EVAL      %SUBST(WNumDetlIn:1:35)   = DDCNUM                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:36:35)  = DDPYFM                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:71:35)  = DDPAYT                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:106:35) = DDTDFA                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:141:35) = DDDELF                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:176:35) = DDDELT                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:211:35) = DDDFFA                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:246:35) = DDDTFA                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:281:35) = AESAP1L                        CSF011
     C                   EVAL      %SUBST(WNumDetlIn:316:35) = AESAP2N                        CSF011
     C                   EVAL      %SUBST(WNumDetlIn:351:35) = AESAWIN                        CSF011
     C                   EVAL      %SUBST(WNumDetlIn:386:35) = AESBOFN                        CSF011
     C                   EVAL      %SUBST(WNumDetlIn:421:35) = AESIPYN                        CSF011
     C                   EVAL      %SUBST(WNumDetlIn:456:35) = AESINVE                        CSF011
     C                   EVAL      %SUBST(WNumDetlIn:491:35) = AESSA1N                        CSF011
     C                   EVAL      %SUBST(WNumDetlIn:526:35) = AESSKAN                        CSF011
     C                   EVAL      %SUBST(WNumDetlIn:561:35) = AESCCTN                        CSF011
     C                   EVAL      %SUBST(WNumDetlIn:596:35) = AESRSSN                        CSF011
     C                   EVAL      %SUBST(WNumDetlIn:631:35) = AESIMMD1                       CSF011
     C                   EVAL      %SUBST(WNumDetlIn:666:35) = AESIMMD2                       CSF011
     C                   EVAL      %SUBST(WNumDetlIn:701:35) = AESPSET                        CSF011
     C                   EVAL      CusIdx = 1                                                 CSF011
                                                                                              CSF011
     C                   DOW       CusIdx <= NoOfCusField                                     CSF011
                                                                                              CSF011
     C                   EVAL      P@Str = %SUBST(WNumDetlIn:CusIdx2:35)                      CSF011
     C                   EVAL      W@Abc = %SUBST(CusOrAcc:CusIdx:1)                          CSF011
                                                                                              CSF011
     C                   IF        P@Str <> *BLANKS                                           CSF011
                                                                                              CSF011
     C                   IF        W@Abc = 'C' OR W@Abc  = 'B'                                CSF011
     C                   EVAL      WCustomer = *BLANKS                                       CSF011A
      ** Customer Type                                                                        CSF011
     C                   CALL      'AOCUSTR0'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      '*KEY'        @OPTN                                        CSF011
     C                   PARM                    P@Str                                       CSF011A
     C                   PARM      *BLANKS       C#KYST                                       CSF011
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSF011
     C                   ENDIF                                                               CSF011A
                                                                                              CSF011
     C                   CALL      'AOIBANR2'                                                CSF011A
     C                   PARM      *Blanks       @RTCD                                       CSF011A
     C                   PARM                    P@Str                                       CSF011A
     C                   PARM                    DSSDY                                       CSF011A
                                                                                             CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EVAL      ACCNT = DSSDY                                             CSF011A
     C                   EVAL      WCustomer = AC_CNUM                                       CSF011A
                                                                                              CSF011
     C                   ELSE                                                                 CSF011
                                                                                              CSF011
     C                   EVAL      WBrch = DDBRCD                                             CSF011
                                                                                              CSF011
      ** Pay from branch for GL Accounts                                                      CSF011
     C                   IF        CusIdx = 2 AND DDPYFB <> *BLANKS                          CSF011A
     C                   EVAL      WBrch = DDPYFB                                             CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
      ** Pay to branch for GL Accounts                                                        CSF011
     C                   IF        CusIdx = 3 AND DDPYTB <> *BLANKS                          CSF011A
     C                   EVAL      WBrch = DDPYTB                                             CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
      ** Account Type                                                                         CSF011
      ** Nostro Account                                                                       CSF011
     C                   SELECT                                                              CSF011A
     C                   WHEN      %LEN(%TRIM(P@Str)) = 2                                    CSF011A
     C                   EVAL      P@Str = DDSETC + %SUBST(P@Str:1:2)                         CSF011
      ** GL Accounts                                                                          CSF011
     C                   WHEN      %LEN(%TRIM(P@Str)) = 18                                   CSF011A
     C                   EVAL      P@Str = WBrch + %SUBST(P@Str:1:6) +                        CSF011
     C                                     DDSETC + %SUBST(P@Str:7:12)                        CSF011
     C                   ENDSL                                                               CSF011A
                                                                                              CSF011
     C                   CALL      'AOACCTV1'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      *BLANKS       P@TYP                                        CSF011
     C                   PARM                    P@Str                                        CSF011
     C                   PARM                    DSSDY                                        CSF011
                                                                                              CSF011
      ** Retrieve Account Details, Customer Shortname, Report Name,                           CSF011
      ** and Town, Account Name and Swift ID                                                  CSF011
                                                                                              CSF011
     C                   SELECT                                                               CSF011
                                                                                              CSF011
     C                   WHEN      P@TYP = '*RETAIL' OR                                       CSF011
     C                             P@TYP = '*LEDGER'                                          CSF011
     C                   EVAL      ACCNT = DSSDY                                              CSF011
     C                   EVAL      WCustomer = AC_CNUM                                        CSF011
                                                                                              CSF011
     C                   WHEN      P@TYP = '*NOSTRO'                                          CSF011
     C                   EVAL      SDNOST = DSSDY                                             CSF011
     C                   EVAL      WCustomer = NO_A7CUST                                      CSF011
     C                   CALL      'AOACCTR0'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      '*KEY   '     @OPTN                                        CSF011
     C                   PARM      *BLANKS       P0RETL                                       CSF011
     C                   PARM                    NO_A7CUST                                    CSF011
     C                   PARM                    NO_A7CYCD                                    CSF011
     C                   PARM                    NO_A7ACCD                                    CSF011
     C                   PARM                    NO_A7ACSN                                    CSF011
     C                   PARM                    NO_A7BRCD                                    CSF011
     C     ACCNT         PARM                    DSSDY                                        CSF011
     C                   WHEN      P@TYP = '*CUSTNO' OR                                      CSF011A
     C                             P@TYP = '*SHNAME'                                         CSF011A
     C                   EVAL      SDCUST = DSSDY                                            CSF011A
     C                   EVAL      WCustomer = *BLANKS                                       CSF011A
                                                                                             CSF011A
     C                   WHEN      P@TYP = '*NRF   '                                         CSF011A
     C                   EVAL      WCustomer = *BLANKS                                       CSF011A
                                                                                              CSF011
     C                   ENDSL                                                                CSF011
                                                                                              CSF011
     C                   ENDIF                                                               CSF011A
                                                                                              CSF011
     C                   IF         WCustomer <> *BLANKS                                     CSF011A
     C                   CALL      'AOCUSTR0'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      '*KEY'        @OPTN                                        CSF011
     C                   PARM                    WCustomer                                    CSF011
     C                   PARM      *BLANKS       C#KYST                                       CSF011
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSF011
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EXSR      SrXferCustName                                             CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
      ** Increment counter fields                                                             CSF011
                                                                                              CSF011
     C                   IF        W@Abc = 'A'                                                CSF011
     C                   Z-ADD     AccLength     W@Len                                        CSF011
     C                   ELSEIF    W@Abc = 'B'                                                CSF011
     C                   Z-ADD     ACusLngth     W@Len                                        CSF011
     C                   ELSE                                                                 CSF011
     C                   Z-ADD     CusLength     W@Len                                        CSF011
     C                   ENDIF                                                                CSF011
     C                   ENDIF                                                               CSF011A
                                                                                              CSF011
     C                   EVAL      CusIdx = Cusidx + 1                                        CSF011
     C                   EVAL      CusIdx2 = Cusidx2 + 35                                     CSF011
                                                                                              CSF011
     C                   ENDDO                                                                CSF011
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * SrXferCustName - Transfer Customer Details to Security Detls  *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     SrXferCustNameBEGSR                                                               CSF011A
                                                                                             CSF011A
     C                   SELECT                                                              CSF011A
      ** Counterparty                                                                        CSF011A
     C                   WHEN      CusIdx = 1                                                CSF011A
     C                   EVAL      DDCTSN = BBCSSN                                           CSF011A
     C                   EVAL      DDCTNM = BBCRNM                                           CSF011A
     C                   EVAL      DDCTTN = BBCRTN                                           CSF011A
      ** Pay From                                                                            CSF011A
     C                   WHEN      CusIdx = 2                                                CSF011A
     C                   EVAL      DDPFSN = BBCSSN                                           CSF011A
     C                   EVAL      DDPFNM = BBCRNM                                           CSF011A
     C                   EVAL      DDPFTN = BBCRTN                                           CSF011A
     C                   EVAL      DDPFAN = AC_ANAM                                          CSF011A
     C                   EVAL      DDPFSW = BBCSID                                           CSF011A
      ** Pay To                                                                              CSF011A
     C                   WHEN      CusIdx = 3                                                CSF011A
     C                   EVAL      DDPTSN = BBCSSN                                           CSF011A
     C                   EVAL      DDPTNM = BBCRNM                                           CSF011A
     C                   EVAL      DDPTTN = BBCRTN                                           CSF011A
     C                   EVAL      DDPTAN = AC_ANAM                                          CSF011A
     C                   EVAL      DDPTSW = BBCSID                                           CSF011A
      ** Pay to for Account Of                                                               CSF011A
     C                   WHEN      CusIdx = 4                                                CSF011A
     C                   EVAL      DDFASN = BBCSSN                                           CSF011A
     C                   EVAL      DDFANM = BBCRNM                                           CSF011A
     C                   EVAL      DDFATN = BBCRTN                                           CSF011A
     C                   EVAL      DDFASW = BBCSID                                           CSF011A
      ** Deliver From                                                                        CSF011A
     C                   WHEN      CusIdx = 5                                                CSF011A
     C                   EVAL      DDDFSN = BBCSSN                                           CSF011A
     C                   EVAL      DDDFNM = BBCRNM                                           CSF011A
     C                   EVAL      DDDFTN = BBCRTN                                           CSF011A
     C                   EVAL      DDDFSW = BBCSID                                           CSF011A
      ** Deliver To                                                                          CSF011A
     C                   WHEN      CusIdx = 6                                                CSF011A
     C                   EVAL      DDDTSN = BBCSSN                                           CSF011A
     C                   EVAL      DDDTNM = BBCRNM                                           CSF011A
     C                   EVAL      DDDTTN = BBCRTN                                           CSF011A
     C                   EVAL      DDDTSW = BBCSID                                           CSF011A
      ** Deliver from for Account Of                                                         CSF011A
     C                   WHEN      CusIdx = 7                                                CSF011A
     C                   EVAL      DDVFSN = BBCSSN                                           CSF011A
     C                   EVAL      DDVFNM = BBCRNM                                           CSF011A
     C                   EVAL      DDVFTN = BBCRTN                                           CSF011A
     C                   EVAL      DDVFSW = BBCSID                                           CSF011A
      ** Deliver to for Account Of                                                           CSF011A
     C                   WHEN      CusIdx = 8                                                CSF011A
     C                   EVAL      DDVTSN = BBCSSN                                           CSF011A
     C                   EVAL      DDVTNM = BBCRNM                                           CSF011A
     C                   EVAL      DDVTTN = BBCRTN                                           CSF011A
     C                   EVAL      DDVTSW = BBCSID                                           CSF011A
      ** Account for Payment 1                                                               CSF011A
     C                   WHEN      CusIdx = 9                                                CSF011A
     C                   EVAL      AESP1SN = BBCSSN                                          CSF011A
     C                   EVAL      AESP1NM = BBCRNM                                          CSF011A
     C                   EVAL      AESP1TN = BBCRTN                                          CSF011A
     C                   EVAL      AESP1SW = BBCSID                                          CSF011A
      ** Account for Payment 2                                                               CSF011A
     C                   WHEN      CusIdx = 10                                               CSF011A
     C                   EVAL      AESP2SN = BBCSSN                                          CSF011A
     C                   EVAL      AESP2NM = BBCRNM                                          CSF011A
     C                   EVAL      AESP2TN = BBCRTN                                          CSF011A
     C                   EVAL      AESP2SW = BBCSID                                          CSF011A
      ** Account with Institution                                                            CSF011A
     C                   WHEN      CusIdx = 11                                               CSF011A
     C                   EVAL      AESAWSN = BBCSSN                                          CSF011A
     C                   EVAL      AESAWNM = BBCRNM                                          CSF011A
     C                   EVAL      AESAWTN = BBCRTN                                          CSF011A
     C                   EVAL      AESAWSW = BBCSID                                          CSF011A
      ** Beneficiary Money                                                                   CSF011A
     C                   WHEN      CusIdx = 12                                               CSF011A
     C                   EVAL      AESBOSN = BBCSSN                                          CSF011A
     C                   EVAL      AESBONM = BBCRNM                                          CSF011A
     C                   EVAL      AESBOTN = BBCRTN                                          CSF011A
     C                   EVAL      AESBOSW = BBCSID                                          CSF011A
      ** Instructing Party                                                                   CSF011A
     C                   WHEN      CusIdx = 13                                               CSF011A
     C                   EVAL      AESIPSN = BBCSSN                                          CSF011A
     C                   EVAL      AESIPNM = BBCRNM                                          CSF011A
     C                   EVAL      AESIPTN = BBCRTN                                          CSF011A
     C                   EVAL      AESIPSW = BBCSID                                          CSF011A
      ** Investor                                                                            CSF011A
     C                   WHEN      CusIdx = 14                                               CSF011A
     C                   EVAL      AESIVSN = BBCSSN                                          CSF011A
     C                   EVAL      AESIVNM = BBCRNM                                          CSF011A
     C                   EVAL      AESIVTN = BBCRTN                                          CSF011A
     C                   EVAL      AESIVSW = BBCSID                                          CSF011A
      ** Counterparty safekeeper                                                             CSF011A
     C                   WHEN      CusIdx = 15                                               CSF011A
     C                   EVAL      AESCSSN = BBCSSN                                          CSF011A
     C                   EVAL      AESCSNM = BBCRNM                                          CSF011A
     C                   EVAL      AESCSTN = BBCRTN                                          CSF011A
     C                   EVAL      AESCSSW = BBCSID                                          CSF011A
      ** Safekeeping                                                                         CSF011A
     C                   WHEN      CusIdx = 16                                               CSF011A
     C                   EVAL      AESSKSN = BBCSSN                                          CSF011A
     C                   EVAL      AESSKNM = BBCRNM                                          CSF011A
     C                   EVAL      AESSKTN = BBCRTN                                          CSF011A
     C                   EVAL      AESSKSW = BBCSID                                          CSF011A
      ** Clearing Correspondent                                                              CSF011A
     C                   WHEN      CusIdx = 17                                               CSF011A
     C                   EVAL      AESCRSN = BBCSSN                                          CSF011A
     C                   EVAL      AESCRNM = BBCRNM                                          CSF011A
     C                   EVAL      AESCRTN = BBCRTN                                          CSF011A
     C                   EVAL      AESCRSW = BBCSID                                          CSF011A
      ** Receiver of Securities                                                              CSF011A
     C                   WHEN      CusIdx = 18                                               CSF011A
     C                   EVAL      AESRESN = BBCSSN                                          CSF011A
     C                   EVAL      AESRENM = BBCRNM                                          CSF011A
     C                   EVAL      AESRETN = BBCRTN                                          CSF011A
     C                   EVAL      AESRESW = BBCSID                                          CSF011A
      ** Intermediary 1                                                                      CSF011A
     C                   WHEN      CusIdx = 19                                               CSF011A
     C                   EVAL      AESI1SN = BBCSSN                                          CSF011A
     C                   EVAL      AESI1NM = BBCRNM                                          CSF011A
     C                   EVAL      AESI1TN = BBCRTN                                          CSF011A
     C                   EVAL      AESI1SW = BBCSID                                          CSF011A
      ** Intermediary 2                                                                      CSF011A
     C                   WHEN      CusIdx = 20                                               CSF011A
     C                   EVAL      AESI2SN = BBCSSN                                          CSF011A
     C                   EVAL      AESI2NM = BBCRNM                                          CSF011A
     C                   EVAL      AESI2TN = BBCRTN                                          CSF011A
     C                   EVAL      AESI2SW = BBCSID                                          CSF011A
      ** Placement of Settlement                                                             CSF011A
     C                   WHEN      CusIdx = 21                                               CSF011A
     C                   EVAL      AESPSSN = BBCSSN                                          CSF011A
     C                   EVAL      AESPSNM = BBCRNM                                          CSF011A
     C                   EVAL      AESPSTN = BBCRTN                                          CSF011A
     C                   EVAL      AESPSSW = BBCSID                                          CSF011A
     C                   ENDSL                                                               CSF011A
     C                                                                                       CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * SrCustname2 - Get the Customer details for Settle Details 2   *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     SrCustName2   BEGSR                                                               CSF011A
     C                   CLEAR                   WNumDetlIn                                  CSF011A
      ** Customer fields for retrieval of details                                            CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:1:35)   = BESAP1N                       CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:36:35)  = BESAP2N                       CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:71:35)  = BESAWIN                       CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:106:35) = BESBOFN                       CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:141:35) = BESIPYN                       CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:176:35) = BESINVE                       CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:211:35) = BESSA1N                       CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:246:35) = BESSKAN                       CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:281:35) = BESCCTN                       CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:316:35) = BESRSSN                       CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:351:35) = BESIMMD1                      CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:386:35) = BESIMMD2                      CSF011A
     C                   EVAL      %SUBST(WNumDetlIn:421:35) = BESPSET                       CSF011A
     C                   EVAL      CusIdx = 1                                                CSF011A
     C                   EVAL      CusIdx2 = 1                                               CSF011A
                                                                                             CSF011A
     C                   DOW       CusIdx <= NoOfCusField2                                   CSF011A
                                                                                             CSF011A
     C                   EVAL      P@Str = %SUBST(WNumDetlIn:CusIdx2:35)                     CSF011A
                                                                                             CSF011A
     C                   IF        P@Str <> *BLANKS                                          CSF011A
                                                                                             CSF011A
     C                   CALL      'AOCUSTR0'                                                CSF011A
     C                   PARM      *BLANKS       @RTCD                                       CSF011A
     C                   PARM      '*KEY'        @OPTN                                       CSF011A
     C                   PARM                    P@Str                                       CSF011A
     C                   PARM      *BLANKS       C#KYST                                      CSF011A
     C     SDCUST        PARM      SDCUST        DSSDY                                       CSF011A
                                                                                             CSF011A
     C                   IF        @RTCD = *BLANKS                                           CSF011A
     C                   EXSR      SrXferCustNam2                                            CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
      ** Increment counter fields                                                            CSF011A
                                                                                             CSF011A
     C                   EVAL      CusIdx = Cusidx + 1                                       CSF011A
     C                   EVAL      CusIdx2 = Cusidx2 + 35                                    CSF011A
                                                                                             CSF011A
     C                   ENDDO                                                               CSF011A
                                                                                             CSF011A
     C                   ENDSR                                                               CSF011A
      *****************************************************************                      CSF011A
      /EJECT                                                                                 CSF011A
      *****************************************************************                      CSF011A
      *                                                               *                      CSF011A
      * SrXferCustNam2 - Transfer Customer Details to Security Detls2 *                      CSF011A
      *                                                               *                      CSF011A
      *****************************************************************                      CSF011A
     C     SrXferCustNam2BEGSR                                                               CSF011A
     C                   SELECT                                                              CSF011A
      ** Account for Payment 1                                                               CSF011A
     C                   WHEN      CusIdx = 1                                                CSF011A
     C                   EVAL      BESP1SN = BBCSSN                                          CSF011A
     C                   EVAL      BESP1NM = BBCRNM                                          CSF011A
     C                   EVAL      BESP1TN = BBCRTN                                          CSF011A
     C                   EVAL      BESP1SW = BBCSID                                          CSF011A
      ** Account for Payment 2                                                               CSF011A
     C                   WHEN      CusIdx = 2                                                CSF011A
     C                   EVAL      BESP2SN = BBCSSN                                          CSF011A
     C                   EVAL      BESP2NM = BBCRNM                                          CSF011A
     C                   EVAL      BESP2TN = BBCRTN                                          CSF011A
     C                   EVAL      BESP2SW = BBCSID                                          CSF011A
      ** Account with Institution                                                            CSF011A
     C                   WHEN      CusIdx = 3                                                CSF011A
     C                   EVAL      BESAWSN = BBCSSN                                          CSF011A
     C                   EVAL      BESAWNM = BBCRNM                                          CSF011A
     C                   EVAL      BESAWTN = BBCRTN                                          CSF011A
     C                   EVAL      BESAWSW = BBCSID                                          CSF011A
      ** Beneficiary Money                                                                   CSF011A
     C                   WHEN      CusIdx = 4                                                CSF011A
     C                   EVAL      BESBOSN = BBCSSN                                          CSF011A
     C                   EVAL      BESBONM = BBCRNM                                          CSF011A
     C                   EVAL      BESBOTN = BBCRTN                                          CSF011A
     C                   EVAL      BESBOSW = BBCSID                                          CSF011A
      ** Instructing Party                           I                                       CSF011A
     C                   WHEN      CusIdx = 5                                                CSF011A
     C                   EVAL      BESIPSN = BBCSSN                                          CSF011A
     C                   EVAL      BESIPNM = BBCRNM                                          CSF011A
     C                   EVAL      BESIPTN = BBCRTN                                          CSF011A
     C                   EVAL      BESIPSW = BBCSID                                          CSF011A
      ** Investor                                                                            CSF011A
     C                   WHEN      CusIdx = 6                                                CSF011A
     C                   EVAL      BESIVSN = BBCSSN                                          CSF011A
     C                   EVAL      BESIVNM = BBCRNM                                          CSF011A
     C                   EVAL      BESIVTN = BBCRTN                                          CSF011A
     C                   EVAL      BESIVSW = BBCSID                                          CSF011A
      ** Counterparty safekeeper                                                             CSF011A
     C                   WHEN      CusIdx = 7                                                CSF011A
     C                   EVAL      BESCSSN = BBCSSN                                          CSF011A
     C                   EVAL      BESCSNM = BBCRNM                                          CSF011A
     C                   EVAL      BESCSTN = BBCRTN                                          CSF011A
     C                   EVAL      BESCSSW = BBCSID                                          CSF011A
      ** Safekeeping                                                                         CSF011A
     C                   WHEN      CusIdx = 8                                                CSF011A
     C                   EVAL      BESSKSN = BBCSSN                                          CSF011A
     C                   EVAL      BESSKNM = BBCRNM                                          CSF011A
     C                   EVAL      BESSKTN = BBCRTN                                          CSF011A
     C                   EVAL      BESSKSW = BBCSID                                          CSF011A
      ** Clearing Correspondent                                                              CSF011A
     C                   WHEN      CusIdx = 9                                                CSF011A
     C                   EVAL      BESCRSN = BBCSSN                                          CSF011A
     C                   EVAL      BESCRNM = BBCRNM                                          CSF011A
     C                   EVAL      BESCRTN = BBCRTN                                          CSF011A
     C                   EVAL      BESCRSW = BBCSID                                          CSF011A
      ** Receiver of Securities                                                              CSF011A
     C                   WHEN      CusIdx = 10                                               CSF011A
     C                   EVAL      BESRESN = BBCSSN                                          CSF011A
     C                   EVAL      BESRENM = BBCRNM                                          CSF011A
     C                   EVAL      BESRETN = BBCRTN                                          CSF011A
     C                   EVAL      BESRESW = BBCSID                                          CSF011A
      ** Intermediary 1                                                                      CSF011A
     C                   WHEN      CusIdx = 11                                               CSF011A
     C                   EVAL      BESI1SN = BBCSSN                                          CSF011A
     C                   EVAL      BESI1NM = BBCRNM                                          CSF011A
     C                   EVAL      BESI1TN = BBCRTN                                          CSF011A
     C                   EVAL      BESI1SW = BBCSID                                          CSF011A
      ** Intermediary 2                                                                      CSF011A
     C                   WHEN      CusIdx = 12                                               CSF011A
     C                   EVAL      BESI2SN = BBCSSN                                          CSF011A
     C                   EVAL      BESI2NM = BBCRNM                                          CSF011A
     C                   EVAL      BESI2TN = BBCRTN                                          CSF011A
     C                   EVAL      BESI2SW = BBCSID                                          CSF011A
      ** Placement of Settlement                                                             CSF011A
     C                   WHEN      CusIdx = 13                                               CSF011A
     C                   EVAL      BESPSSN = BBCSSN                                          CSF011A
     C                   EVAL      BESPSNM = BBCRNM                                          CSF011A
     C                   EVAL      BESPSTN = BBCRTN                                          CSF011A
     C                   EVAL      BESPSSW = BBCSID                                          CSF011A
     C                   ENDSL                                                               CSF011A
     C                                                                                       CSF011A
     C                   ENDSR                                                               CSF011A
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * RESETCYCLE- Reset error information that is gradually         *
      *             updated during each run of this program           *
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
 
     C                   CLEAR                   CurTrPrim
     C                   CLEAR                   CurTrSeco
     C                   CLEAR                   CurTrThir
     C                   CLEAR                   CurTrExch
     C                   CLEAR                   CurTrSett
     C                   CLEAR                   CurTrChcm
     C                   CLEAR                   CurTrSwftA
     C                   CLEAR                   CurTrSwftB
     C                   CLEAR                   CurX2SwftA
     C                   CLEAR                   CurX2SwftB
      **Initialise Customer Name on input fields                                             CSF011A
      ** Counterparty                                                                        CSF011A
     C                   EVAL      DDCTSN = *BLANKS                                          CSF011A
     C                   EVAL      DDCTNM = *BLANKS                                          CSF011A
     C                   EVAL      DDCTTN = *BLANKS                                          CSF011A
      ** Pay From                                                                            CSF011A
     C                   EVAL      DDPFSN = *BLANKS                                          CSF011A
     C                   EVAL      DDPFNM = *BLANKS                                          CSF011A
     C                   EVAL      DDPFTN = *BLANKS                                          CSF011A
     C                   EVAL      DDPFAN = *BLANKS                                          CSF011A
     C                   EVAL      DDPFSW = *BLANKS                                          CSF011A
      ** Pay To                                                                              CSF011A
     C                   EVAL      DDPTSN = *BLANKS                                          CSF011A
     C                   EVAL      DDPTNM = *BLANKS                                          CSF011A
     C                   EVAL      DDPTTN = *BLANKS                                          CSF011A
     C                   EVAL      DDPTAN = *BLANKS                                          CSF011A
     C                   EVAL      DDPTSW = *BLANKS                                          CSF011A
      ** Pay to for Account Of                                                               CSF011A
     C                   EVAL      DDFASN = *BLANKS                                          CSF011A
     C                   EVAL      DDFANM = *BLANKS                                          CSF011A
     C                   EVAL      DDFATN = *BLANKS                                          CSF011A
     C                   EVAL      DDFASW = *BLANKS                                          CSF011A
      ** Deliver From                                                                        CSF011A
     C                   EVAL      DDDFSN = *BLANKS                                          CSF011A
     C                   EVAL      DDDFNM = *BLANKS                                          CSF011A
     C                   EVAL      DDDFTN = *BLANKS                                          CSF011A
     C                   EVAL      DDDFSW = *BLANKS                                          CSF011A
      ** Deliver To                                                                          CSF011A
     C                   EVAL      DDDTSN = *BLANKS                                          CSF011A
     C                   EVAL      DDDTNM = *BLANKS                                          CSF011A
     C                   EVAL      DDDTTN = *BLANKS                                          CSF011A
     C                   EVAL      DDDTSW = *BLANKS                                          CSF011A
      ** Deliver from for Account Of                                                         CSF011A
     C                   EVAL      DDVFSN = *BLANKS                                          CSF011A
     C                   EVAL      DDVFNM = *BLANKS                                          CSF011A
     C                   EVAL      DDVFTN = *BLANKS                                          CSF011A
     C                   EVAL      DDVFSW = *BLANKS                                          CSF011A
      ** Deliver to for Account Of                                                           CSF011A
     C                   EVAL      DDVTSN = *BLANKS                                          CSF011A
     C                   EVAL      DDVTNM = *BLANKS                                          CSF011A
     C                   EVAL      DDVTTN = *BLANKS                                          CSF011A
     C                   EVAL      DDVTSW = *BLANKS                                          CSF011A
      ** SET A                                                                               CSF011A
      ** Account for Payment 1                                                               CSF011A
     C                   EVAL      AESP1SN = *BLANKS                                         CSF011A
     C                   EVAL      AESP1NM = *BLANKS                                         CSF011A
     C                   EVAL      AESP1TN = *BLANKS                                         CSF011A
     C                   EVAL      AESP1SW = *BLANKS                                         CSF011A
      ** Account for Payment 2                                                               CSF011A
     C                   EVAL      AESP2SN = *BLANKS                                         CSF011A
     C                   EVAL      AESP2NM = *BLANKS                                         CSF011A
     C                   EVAL      AESP2TN = *BLANKS                                         CSF011A
     C                   EVAL      AESP2SW = *BLANKS                                         CSF011A
      ** Account with Institution                                                            CSF011A
     C                   EVAL      AESAWSN = *BLANKS                                         CSF011A
     C                   EVAL      AESAWNM = *BLANKS                                         CSF011A
     C                   EVAL      AESAWTN = *BLANKS                                         CSF011A
     C                   EVAL      AESAWSW = *BLANKS                                         CSF011A
      ** Beneficiary Money                                                                   CSF011A
     C                   EVAL      AESBOSN = *BLANKS                                         CSF011A
     C                   EVAL      AESBONM = *BLANKS                                         CSF011A
     C                   EVAL      AESBOTN = *BLANKS                                         CSF011A
     C                   EVAL      AESBOSW = *BLANKS                                         CSF011A
      ** Instructing Party                                                                   CSF011A
     C                   EVAL      AESIPSN = *BLANKS                                         CSF011A
     C                   EVAL      AESIPNM = *BLANKS                                         CSF011A
     C                   EVAL      AESIPTN = *BLANKS                                         CSF011A
     C                   EVAL      AESIPSW = *BLANKS                                         CSF011A
      ** Investor                                                                            CSF011A
     C                   EVAL      AESIVSN = *BLANKS                                         CSF011A
     C                   EVAL      AESIVNM = *BLANKS                                         CSF011A
     C                   EVAL      AESIVTN = *BLANKS                                         CSF011A
     C                   EVAL      AESIVSW = *BLANKS                                         CSF011A
      ** Counterparty safekeeper                                                             CSF011A
     C                   EVAL      AESCSSN = *BLANKS                                         CSF011A
     C                   EVAL      AESCSNM = *BLANKS                                         CSF011A
     C                   EVAL      AESCSTN = *BLANKS                                         CSF011A
     C                   EVAL      AESCSSW = *BLANKS                                         CSF011A
      ** Safekeeping                                                                         CSF011A
     C                   EVAL      AESSKSN = *BLANKS                                         CSF011A
     C                   EVAL      AESSKNM = *BLANKS                                         CSF011A
     C                   EVAL      AESSKTN = *BLANKS                                         CSF011A
     C                   EVAL      AESSKSW = *BLANKS                                         CSF011A
      ** Clearing Correspondent                                                              CSF011A
     C                   EVAL      AESCRSN = *BLANKS                                         CSF011A
     C                   EVAL      AESCRNM = *BLANKS                                         CSF011A
     C                   EVAL      AESCRTN = *BLANKS                                         CSF011A
     C                   EVAL      AESCRSW = *BLANKS                                         CSF011A
      ** Receiver of Securities                                                              CSF011A
     C                   EVAL      AESRESN = *BLANKS                                         CSF011A
     C                   EVAL      AESRENM = *BLANKS                                         CSF011A
     C                   EVAL      AESRETN = *BLANKS                                         CSF011A
     C                   EVAL      AESRESW = *BLANKS                                         CSF011A
      ** Intermediary 1                                                                      CSF011A
     C                   EVAL      AESI1SN = *BLANKS                                         CSF011A
     C                   EVAL      AESI1NM = *BLANKS                                         CSF011A
     C                   EVAL      AESI1TN = *BLANKS                                         CSF011A
     C                   EVAL      AESI1SW = *BLANKS                                         CSF011A
      ** Intermediary 2                                                                      CSF011A
     C                   EVAL      AESI2SN = *BLANKS                                         CSF011A
     C                   EVAL      AESI2NM = *BLANKS                                         CSF011A
     C                   EVAL      AESI2TN = *BLANKS                                         CSF011A
     C                   EVAL      AESI2SW = *BLANKS                                         CSF011A
      ** Placement of Settlement                                                             CSF011A
     C                   EVAL      AESPSSN = *BLANKS                                         CSF011A
     C                   EVAL      AESPSNM = *BLANKS                                         CSF011A
     C                   EVAL      AESPSTN = *BLANKS                                         CSF011A
     C                   EVAL      AESPSSW = *BLANKS                                         CSF011A
      ** SET B                                                                               CSF011A
      ** Account for Payment 1                                                               CSF011A
     C                   EVAL      BESP1SN = *BLANKS                                         CSF011A
     C                   EVAL      BESP1NM = *BLANKS                                         CSF011A
     C                   EVAL      BESP1TN = *BLANKS                                         CSF011A
     C                   EVAL      BESP1SW = *BLANKS                                         CSF011A
      ** Account for Payment 2                                                               CSF011A
     C                   EVAL      BESP2SN = *BLANKS                                         CSF011A
     C                   EVAL      BESP2NM = *BLANKS                                         CSF011A
     C                   EVAL      BESP2TN = *BLANKS                                         CSF011A
     C                   EVAL      BESP2SW = *BLANKS                                         CSF011A
      ** Account with Institution                                                            CSF011A
     C                   EVAL      BESAWSN = *BLANKS                                         CSF011A
     C                   EVAL      BESAWNM = *BLANKS                                         CSF011A
     C                   EVAL      BESAWTN = *BLANKS                                         CSF011A
     C                   EVAL      BESAWSW = *BLANKS                                         CSF011A
      ** Beneficiary Money                                                                   CSF011A
     C                   EVAL      BESBOSN = *BLANKS                                         CSF011A
     C                   EVAL      BESBONM = *BLANKS                                         CSF011A
     C                   EVAL      BESBOTN = *BLANKS                                         CSF011A
     C                   EVAL      BESBOSW = *BLANKS                                         CSF011A
      ** Instructing Party                           I                                       CSF011A
     C                   EVAL      BESIPSN = *BLANKS                                         CSF011A
     C                   EVAL      BESIPNM = *BLANKS                                         CSF011A
     C                   EVAL      BESIPTN = *BLANKS                                         CSF011A
     C                   EVAL      BESIPSW = *BLANKS                                         CSF011A
      ** Investor                                                                            CSF011A
     C                   EVAL      BESIVSN = *BLANKS                                         CSF011A
     C                   EVAL      BESIVNM = *BLANKS                                         CSF011A
     C                   EVAL      BESIVTN = *BLANKS                                         CSF011A
     C                   EVAL      BESIVSW = *BLANKS                                         CSF011A
      ** Counterparty safekeeper                                                             CSF011A
     C                   EVAL      BESCSSN = *BLANKS                                         CSF011A
     C                   EVAL      BESCSNM = *BLANKS                                         CSF011A
     C                   EVAL      BESCSTN = *BLANKS                                         CSF011A
     C                   EVAL      BESCSSW = *BLANKS                                         CSF011A
      ** Safekeeping                                                                         CSF011A
     C                   EVAL      BESSKSN = *BLANKS                                         CSF011A
     C                   EVAL      BESSKNM = *BLANKS                                         CSF011A
     C                   EVAL      BESSKTN = *BLANKS                                         CSF011A
     C                   EVAL      BESSKSW = *BLANKS                                         CSF011A
      ** Clearing Correspondent                                                              CSF011A
     C                   EVAL      BESCRSN = *BLANKS                                         CSF011A
     C                   EVAL      BESCRNM = *BLANKS                                         CSF011A
     C                   EVAL      BESCRTN = *BLANKS                                         CSF011A
     C                   EVAL      BESCRSW = *BLANKS                                         CSF011A
      ** Receiver of Securities                                                              CSF011A
     C                   EVAL      BESRESN = *BLANKS                                         CSF011A
     C                   EVAL      BESRENM = *BLANKS                                         CSF011A
     C                   EVAL      BESRETN = *BLANKS                                         CSF011A
     C                   EVAL      BESRESW = *BLANKS                                         CSF011A
      ** Intermediary 1                                                                      CSF011A
     C                   EVAL      BESI1SN = *BLANKS                                         CSF011A
     C                   EVAL      BESI1NM = *BLANKS                                         CSF011A
     C                   EVAL      BESI1TN = *BLANKS                                         CSF011A
     C                   EVAL      BESI1SW = *BLANKS                                         CSF011A
      ** Intermediary 2                                                                      CSF011A
     C                   EVAL      BESI2SN = *BLANKS                                         CSF011A
     C                   EVAL      BESI2NM = *BLANKS                                         CSF011A
     C                   EVAL      BESI2TN = *BLANKS                                         CSF011A
     C                   EVAL      BESI2SW = *BLANKS                                         CSF011A
      ** Placement of Settlement                                                             CSF011A
     C                   EVAL      BESPSSN = *BLANKS                                         CSF011A
     C                   EVAL      BESPSNM = *BLANKS                                         CSF011A
     C                   EVAL      BESPSTN = *BLANKS                                         CSF011A
     C                   EVAL      BESPSSW = *BLANKS                                         CSF011A
                                                                                             CSF011A
 
     C                   MOVE      *ALL'Y'       OKTrPrim
     C                   MOVE      *ALL'Y'       OKTrSeco
     C                   MOVE      *ALL'Y'       OKTrThir
     C                   MOVE      *ALL'Y'       OKTrExch
     C                   MOVE      *ALL'Y'       OKTrSett
     C                   MOVE      *ALL'Y'       OKTrChcm
     C                   MOVE      *ALL'Y'       OKTrSwft
     C                   MOVE      *ALL'Y'       OKX2Swft
 
     C                   CLEAR                   ValidTrad
     C                   CLEAR                   ValidTX1A
     C                   CLEAR                   ValidTX1B
     C                   CLEAR                   ValidTX2A
     C                   CLEAR                   ValidTX2B
      *
      ** Also clear numeric variables
      *
     C**********         Z-ADD     0             V_TCNR                                      CSD027A
     C                   Eval      V_TCNR = *Blanks                                          CSD027A
     C                   Z-ADD     0             V_NOML
     C                   Z-ADD     0             V_TNMD
     C                   Z-ADD     0             V_TPDY
     C                   Z-ADD     0             V_TDVD
     C                   Z-ADD     0             V_TDDT
     C                   Z-ADD     0             V_TCAP
     C                   Z-ADD     0             V_DADJ
     C                   Z-ADD     0             V_ITRA
     C                   Z-ADD     0             V_TINA
     C                   Z-ADD     0             V_TDCR
     C                   Z-ADD     0             V_PRIC
     C                   Z-ADD     0             V_RALL
     C                   Z-ADD     0             V_TDER
     C                   Z-ADD     0             V_TBCR
     C                   Z-ADD     0             V_SMTH
     C                   Z-ADD     0             V_ASNM
     C**********         Z-ADD     0             V_DELT                                      CSD027A
     C**********         Z-ADD     0             V_DELF                                      CSD027A
     C                   Eval      V_DELT = *blanks                                          CSD027A
     C                   Eval      V_DELF = *blanks                                          CSD027A
     C                   Z-ADD     0             V_TBCA
     C                   Z-ADD     0             V_TCCA
     C                   Z-ADD     0             V_TCA1
     C                   Z-ADD     0             V_TCA2
     C                   Z-ADD     0             V_TCA3
     C                   Z-ADD     0             V_TCA4
     C                   Z-ADD     0             V_TCA5
     C                   Z-ADD     0             V_TCA6
     C                   Z-ADD     0             V_TCA7
     C                   Z-ADD     0             V_TAXA
     C                   Z-ADD     0             V_BCMR
     C                   Z-ADD     0             V_CCMR
     C                   Z-ADD     0             V_TXRB
     C                   Z-ADD     0             V_TIME
     C                   Z-ADD     0             V_TOSN
     C                   Z-ADD     0             V_TNSN
     C                   Z-ADD     0             V_TNSP
     C                   Z-ADD     0             V_TOSV
     C                   Z-ADD     0             V_TVSN
     C                   Z-ADD     0             V_TVSP
     C                   Z-ADD     0             V_TDSN
     C                   Z-ADD     0             V_TDSP
     C                   Z-ADD     0             V_TDFS
     C                   Z-ADD     0             V_TSSQ
     C                   Z-ADD     0             V_TCSR
     C                   Z-ADD     0             V_TCTR
     C                   Z-ADD     0             V_TDMC
     C                   Z-ADD     0             V_TOED
     C                   Z-ADD     0             V_LCD
     C                   Z-ADD     0             V_TNLU
     C                   Z-ADD     0             V_LSWS
     C                   Z-ADD     0             V_TCFC
     C                   Z-ADD     0             V_SPXR
     C                   Z-ADD     0             V_FXMP
     C                   Z-ADD     0             V_FXMR
     C                   Z-ADD     0             V_MAMT
     C                   Z-ADD     0             V_ORDE
     C                   Z-ADD     0             V_WHTX
     C                   Z-ADD     0             VA_T1LSWS
     C                   Z-ADD     0             VA_T1LSSC
     C                   Z-ADD     0             VB_T1LSWS
     C                   Z-ADD     0             VB_T1LSSC
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *              transaction number supplied                      *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR
      *
      **Set*retrieve*mode*to*'*FRONT'*(Access*using*Front*Office*ID)****                      CAP087
      ***if*insert******************************************************                      CAP087
      ***if*not*insert*and*Midas*transaction*ID*is*not*present**********                      CAP087
      **Otherwise*******************************************************                      CAP087
      ***Set*retrieve*mode*to*blank**(Access*using*Midas*transaction*ID).                     CAP087
      *
     C*****DDACTN        IFEQ      'I'                                                        CAP087
     C***********        MOVEL     '*FRONT'      ModeofOp                                     CAP087
     C***********        ELSE                                                                 CAP087
     C*****DDTDRF        IFEQ      *BLANK                                                     CAP087
     C***********        MOVEL     '*FRONT'      ModeofOp                                     CAP087
     C***********        ELSE                                                                 CAP087
     C                   MOVEL     '      '      ModeofOp
     C***********        ENDIF                                                                CAP087
     C***********        ENDIF                                                                CAP087
 
     C                   IF        APFOTRANID <> *BLANKS AND                                AR971184
     C                             DDACTN = 'I'                                             AR971184
     C                   EVAL      ModeOfOp = '*FRONT'                                      AR971184
     C                   ELSE                                                               AR971184
     C                   EVAL      ModeOfOp = *BLANKS                                       AR971184
     C                   ENDIF                                                              AR971184
      * Validate action code versus transaction IDs supplied
      * This function will set the Midas trade reference
      * The trade in file format from the SE database is retrieved as well.
 
     C                   RESET                   ReturnCode
     C                   CALLB     'SETRADRTV'
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
     C                   PARM                    APFOTranID
      *
      * (Midas) Trade Reference
     C                   PARM                    DDTDRF            6
      *
      * MT5XX - Phase 2 Message Generation is on.
     C                   PARM                    CSW003
      *
      * Buy-sell back
     C                   PARM                    PFBYSL            1
      *
      * Trade Reference
     C                   PARM                    PFTDRF            6
      *
      * OUTPUTS
      *
      * (Current) trade in file format
      * (Current) trade extension in file format
     C                   PARM                    TradFilFmt
     C                   PARM                    TX1AFilFmt
     C                   PARM                    TX1BFilFmt
      *
      * OK - Action code
     C                   PARM                    DDActnOK          1
      *
      * OK - Trade Reference
     C                   PARM                    DDTdrfOK          1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      **   Move book from file to work field for later checking.
      *
     C                   MOVE      TDBK          OLDBK1            2
     C                   MOVE      'W'           WARNIND           1
 
      * Get TRADSDX2 records
 
     C                   CALLB     'SETRADRTV2'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * (Midas) Trade Reference
     C                   PARM                    DDTDRF
      * MT5XX - Phase 2 Message Generation is on.
     C                   PARM                    CSW003
      * OUTPUTS :
      * (Current) TRADSDX2 in file format
     C                   PARM                    TX2AFilFmt
     C                   PARM                    TX2BFilFmt
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkValMiTR - Routine to check if valid trade exists for       *
      *    Midas Trade Reference                                      *
      *                                                               *
      *****************************************************************
 
     C     ChkValMiTR    BEGSR
 
      * If (numeric) Midas Trade Reference supplied
 
     C                   TESTN                   DDTDRF               9898
 
     C     DDTDRF        IFNE      *BLANKS
     C     *IN98         ANDEQ     '1'
 
      * Check for trade on Valid file
     C                   MOVEL     DDTDRF        TDRF
     C     TDRF          CHAIN     SEVTRADL1                          99
 
      * If record found...
     C     *IN99         IFEQ      '0'
 
      * ..delay, then repeat check
     C                   CALLB     'ZACDELAY'
 
     C     TDRF          CHAIN     SEVTRADL1                          99
 
      * Error if still present
     C     *IN99         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTDRF'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Fil2ScrnConv - Conversion file format to Screen Formate       *
      *                                                               *
      *****************************************************************
 
     C     Fil2ScrnConv  BEGSR
 
      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT
 
     C                   RESET                   RetCodeIn
     C                   CALLB     'SETRADCVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Trade - file formats
     C                   PARM                    TradFilFmt
     C                   PARM                    TX1AFilFmt
     C                   PARM                    TX1BFilFmt
      ** Hedge Accounting Phase B
 
     C                   PARM                    CAS006
                                                                                              CGL031
      ** CGL031 Switchable Feature                                                            CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      * Output parameters
      *
      * Trade - screen formats
     C                   PARM                    CurTrPrim
     C                   PARM                    CurTrSeco
     C                   PARM                    CurTrThir
     C                   PARM                    CurTrExch
     C                   PARM                    CurTrSett
     C                   PARM                    CurTrChCm
     C                   PARM                    CurTrSwftA
     C                   PARM                    CurTrSwftB
 
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
 
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
 
      ** Settlement Currency Details
     C                   PARM                    SetCcyDts
      *
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      *
      * Trade Status
      * Trade Authorized/Not Authorized
     C                   PARM                    DDSTAT            9
     C                   PARM                    DDAUTH           14
      * Security report name
      * Customer report name
     C                   PARM                    DDSRNME          41
     C                   PARM                    DDCRNM           20
 
      * Coupon Rate
      * Current Factor
      * Margin Amount
      * Portfolio Exchange Rate
      * Portfolio M/D Ind
      * Trade Countervalue
     C                   PARM                    DDCPNR           13
     C                   PARM                    DDCFCT           12
     C                   PARM                    DDMAMT           18
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
     C                   PARM                    DDTCTR           21
     C                   PARM                    DDWTAX
     C                   PARM                    DDPRICN
 
      * SCREEN A
      * Destination of Settlement
      * Destination of Confirmation
     C                   PARM                    A_DDROUS          6
     C                   PARM                    A_DDROTS         12
     C                   PARM                    A_DDROUC          6
     C                   PARM                    A_DDROTC         12
 
      * SCREEN B
      * Destination of Settlement
      * Destination of Confirmation
     C                   PARM                    B_DDROUS          6
     C                   PARM                    B_DDROTS         12
     C                   PARM                    B_DDROUC          6
     C                   PARM                    B_DDROTC         12
     C                   PARM                    DDFRNT                                    AR698195B
 
      * Converse TRADSDX2 into Screen Format
 
     C                   CALLB     'SETRADCVT2'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * (Current) TRADSDX2 in file format
     C                   PARM                    TX2AFilFmt
     C                   PARM                    TX2BFilFmt
     C                   PARM                    CSW206            1                        BUG12579
     C                   PARM                    CSW210                                       CSW210
      * OUTPUTS :
      * (Screen) TRADSDX2
     C                   PARM                    CurX2SwftA
     C                   PARM                    CurX2SwftB
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * TDtDtaSubs - Transaction Details Data Substitution            *
      *                                                               *
      *****************************************************************
 
     C     TDtDtaSubs    BEGSR
 
      ** Save Counterparty Classifcation
     C                   EVAL      CPartyClass = CustClass
 
      ** DATA SUBSTITUTION
 
     C                   RESET                   ReturnCode
 
      * TRADE PRIMARY DETAILS
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode       10
      * Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      * Incoming Data
     C                   PARM      TranInPrim    IncDATA        2000
      * Current Data
     C                   PARM      CurTrPrim     CurDATA        2000
 
     C                   MOVEL     IncDATA       TranInPrim
 
      * TRADE SECONDARY DETAILS
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode       10
      * Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      * Incoming Data
     C                   PARM      TranInSeco    IncDATA        2000
      * Current Data
     C                   PARM      CurTrSeco     CurDATA        2000
 
     C                   MOVEL     IncDATA       TranInSeco
 
      ** Trade Third screen details
 
     C                   IF        CAS006 = 'Y'
     C                   CALLB     'APDTASUBS'
 
      ** Return Code
 
     C                   PARM                    ReturnCode
 
      ** Substitution character
      ** Incoming Data
      ** Current Data
 
     C                   PARM      GHSUBS        SubsChar
     C                   PARM      TranInThir    IncDATA
     C                   PARM      CurTrThir     CurDATA
 
     C                   MOVEL     IncDATA       TranInThir
     C                   ENDIF
 
      * TRADE EXCHANGE RATES
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode       10
      * Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      * Incoming Data
     C                   PARM      TranInExch    IncDATA        2000
      * Current Data
     C                   PARM      CurTrExch     CurDATA        2000
 
     C                   MOVEL     IncDATA       TranInExch
 
      * TRADE SETTLEMENT DETAILS
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode       10
      * Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      * Incoming Data
     C                   PARM      TranInSett    IncDATA        2000
      * Current Data
     C                   PARM      CurTrSett     CurDATA        2000
 
     C                   MOVEL     IncDATA       TranInSett
 
      * TRADE CHARGE/COMMISSIONS
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode
      * Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      * Incoming Data
     C                   PARM      TranInChCm    IncDATA        2000
      * Current Data
     C                   PARM      CurTrChCm     CurDATA        2000
 
     C                   MOVEL     IncDATA       TranInChCm
 
      * TRADE SWIFT A DETAILS
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode       10
      * Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      * Incoming Data
     C                   PARM      TranInSwfA    IncDATA        2000
      * Current Data
     C                   PARM      CurTrSwftA    CurDATA        2000
 
     C                   MOVEL     IncDATA       TranInSwfA
 
      * TRADE SWIFT B DETAILS
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode       10
      * Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      * Incoming Data
     C                   PARM      TranInSwfB    IncDATA        2000
      * Current Data
     C                   PARM      CurTrSwftB    CurDATA        2000
 
     C                   MOVEL     IncDATA       TranInSwfB
 
      * TRADEX2 SWIFT A DETAILS
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode       10
      * Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      * Incoming Data
     C                   PARM      TranInExtA    IncDATA        2000
      * Current Data
     C                   PARM      CurX2SwftA    CurDATA        2000
 
     C                   MOVEL     IncDATA       TranInExtA
 
      * TRADEX2 SWIFT B DETAILS
     C                   CALLB     'APDTASUBS'
 
      * Return Code
     C                   PARM                    ReturnCode       10
      * Substitution character
     C                   PARM      GHSUBS        SubsChar          1
      * Incoming Data
     C                   PARM      TranInExtB    IncDATA        2000
      * Current Data
     C                   PARM      CurX2SwftB    CurDATA        2000
 
     C                   MOVEL     IncDATA       TranInExtB
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CalcTrCHCM - Calculate Trade Charges/Commissions              *
      *                                                               *
      *****************************************************************
     C     CalcTrCHCM    BEGSR
 
     C                   CALLB     'SETCHCMCAL'
 
      * INPUTS
 
      ** Trade reference
      ** Security
      ** Trade Type
     C                   PARM                    DDTDRF            6
     C                   PARM                    DDSESN           10
     C                   PARM                    DDTDTP            2
      *
      ** Trade Counterparty
      ** Trade Nominal
      ** Trade % price
      ** Trade Date
      ** Trade Purchased Interest
      ** Trade Current Factor
     C                   PARM                    V_TCNR
     C                   PARM                    V_NOML           11 0
     C                   PARM                    V_PRIC           15 8
     C                   PARM                    V_TDDT            5 0
     C                   PARM                    V_ITRA           13 0
     C                   PARM                    V_TCFC           10 9
      *
      ** Security & Investment Type details
     C                   PARM                    SECTY
     C                   PARM                    PROT              1
      *
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
      *
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      *
      ** Commission Rebate %
     C                   PARM                    CMRP              5 3
      *
      ** Previous Trade Charges & Commissions
     C                   PARM                    CurTrChCm
      *
      ** Trade Charges & Commissions OK inds
     C                   PARM                    OKTrChCm
      *
      ** ICD
      ** Autocharge Option
      ** Securities Charges Currency
      ** Adjust Commission Same Day T
     C                   PARM                    BVACOP            1
     C                   PARM                    BVCHRC            3
     C                   PARM                    BVACSD            1
     C                   PARM                    S01446            1
 
      * INPUTS & OUTPUTS
 
      ** Trade Charges & commissions screen fields
 
     C                   PARM                    TranInChcm
 
      ** Trade details
     C                   PARM                    V_TBCA           13 0
     C                   PARM                    V_TCCA           13 0
     C                   PARM                    V_TCA1           13 0
     C                   PARM                    V_TCA2           13 0
     C                   PARM                    V_TCA3           13 0
     C                   PARM                    V_TCA4           13 0
     C                   PARM                    V_TCA5           13 0
     C                   PARM                    V_TCA6           13 0
     C                   PARM                    V_TCA7           13 0
     C                   PARM                    V_TAXA           13 0
     C                   PARM                    V_BCMR           13 0
     C                   PARM                    V_CCMR           13 0
     C                   PARM                    V_TXRB           13 0
 
     C                   ENDSR
      *****************************************************************                       237063
      /EJECT                                                                                  237063
      *****************************************************************                       237063
      *                                                               *                       237063
      * CalcTrEUTX - Calculate EU Tax                                 *                       237063
      *                                                               *                       237063
      *****************************************************************                       237063
     C     CalcTrEUTX    BEGSR                                                                237063
                                                                                              237063
     C                   IF        DDPTFR <> *BLANKS AND PTFR = *BLANKS                       237063
     C                   EVAL      PTFR = DDPTFR                                              237063
     C                   ENDIF                                                                237063
                                                                                              237063
      ** CALCULATE EU TAX                                                                     237063
                                                                                              237063
     C                   CALLB     'SEVTRADTAX'                                               237063
                                                                                              237063
      * INPUTS                                                                                237063
                                                                                              237063
      * Response Mode                                                                         237063
     C                   PARM                    RetCodeIn                                    237063
      * Valid Trade Details                                                                   237063
     C                   PARM                    ValidTrad                                    237063
      * Security Details                                                                      237063
     C                   PARM                    SECTY                                        237063
      * Process Flag                                                                          237063
     C                   PARM      'E'           ProcFlag          1                          237063
                                                                                              237063
      * OUTPUTS                                                                               237063
                                                                                              237063
      * EU Tax Screen Format                                                                  237063
      * EU Tax in Nominal Currency File Format                                                237063
      * EU Tax in Settlement Currency File Format                                             237063
     C                   PARM                    DDEUTX                                       237063
     C                   PARM                    EUTX                                         237063
     C                   PARM                    EUTS                                         237063
                                                                                              237063
     C                   ENDSR                                                                237063
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * CalcTrCVAL - Calculate Trade Countervalue                     *
      *                                                               *
      *****************************************************************
     C     CalcTrCVAL    BEGSR
 
      ** CALCULATE COUNTERVALUE
 
     C                   CALLB     'SETCVALCAL'
 
      * INPUTS
 
      ** Trade details
     C                   PARM                    V_TDTP            2
     C                   PARM                    V_NOML           11 0
     C                   PARM                    V_PRIC           15 8
     C                   PARM                    V_RALL            9 5
     C                   PARM                    V_ITRA           13 0
     C                   PARM                    V_TBCA           13 0
     C                   PARM                    V_TCCA           13 0
     C                   PARM                    V_TCA1           13 0
     C                   PARM                    V_TCA2           13 0
     C                   PARM                    V_TCA3           13 0
     C                   PARM                    V_TCA4           13 0
     C                   PARM                    V_TCA5           13 0
     C                   PARM                    V_TCA6           13 0
     C                   PARM                    V_TCA7           13 0
     C                   PARM                    V_TAXA           13 0
     C                   PARM                    V_TDER           13 8
     C                   PARM                    V_TMDI            1
     C                   PARM                    V_SETC            3
     C                   PARM                    V_TDVD            5 0
 
      ** Security details
     C                   PARM                    PROT              1
     C                   PARM                    SPBS              1
     C                   PARM                    CFCT             10 9
     C                   PARM                    NMCY              3
     C                   PARM                    NMDP              1 0
     C                   PARM                    SESN             10
 
      ** Nominal Currency Details
      ** Settlement Currency Details
     C                   PARM                    NomCcyDts
     C                   PARM                    SetCcyDts
 
      ** Customer classification
     C                   PARM                    CustClass         1
 
      ** Country of treaty from PF/SECTYD
     C                   PARM                    CRTT
 
      ** Default basket for backup withholding
     C                   PARM                    PDRBW
 
      ** Value date
     C                   PARM                    TDVD
                                                                                              237063
      ** EU Tax                                                                               237063
     C                   PARM                    EUTX                                         237063
 
      * OUTPUTS
 
      * Trade consideration in nominal currency
      * Trade countervalue in nominal currency
      * Withholding tax
      * Trade countervalue in settlement currency in screen format
      * Withholding tax in screen format
     C                   PARM                    V_TCSR           15 0
     C                   PARM                    V_TCTR           15 0
     C                   PARM                    WHTX
     C                   PARM                    DDTCTR           21
     C                   PARM                    DDWTAX
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SetPDATA - Set up data structure for call to SE1806
      *****************************************************************
     C     SetPDATA      BEGSR
 
     C                   MOVEL     DDACTN        PACTN
     C     DDACTN        IFEQ      'C'
     C                   MOVEL     'A'           PACTN
     C                   END
     C                   MOVEL     DDTDRF        PTDRF
     C                   MOVEL     DDSETC        PTNMC
     C                   MOVEL     DDSESN        PSESN
     C                   MOVEL     DDBLKR        PBLKR
      *                                                                                       247451
      ** Access Customer details via access program                                           247451
      *  (database error handling done in access program)                                     247451
     C                   CALL      'AOCUSTR0'                                                 247451
     C                   PARM      '*DBERR '     @RTCD                                        247451
     C                   PARM      '*KEY   '     @OPTN                                        247451
     C                   PARM      DDCNUM        WCus10           10                          247451
     C                   PARM      *BLANKS       WKyst             7                          247451
     C     SDCUST        PARM      SDCUST        DSSDY                                        247451
      *                                                                                       247451
     C     @RTCD         IFEQ      *BLANK                                                     247451
     C                   MOVEL     BBCUST        PTCNR                                        247451
     C                   ENDIF                                                                247451
                                                                                              247451
     C*****              MOVEL     DDCNUM        PTCNR                                      BUG11622
     C**********         MOVEL     CustNum       PTCNR                               BUG11622 247451
     C                   MOVEL     DDBRCD        PTDBR
     C                   MOVEL     DDTDTP        PTDTP
     C                   MOVEL     V_NOML        PNOML
     C                   MOVEL     DDTDMI        PTDMI
     C                   MOVEL     DDAIIP        PAIIP
     C                   MOVEL     DDINCS        PINCS
     C                   MOVEL     BVDR1         PDC01
     C                   MOVEL     BVDR2         PDC02
     C                   MOVEL     DDCLTY        PCLTY
     C                   MOVEL     DDPCOD        PPCOD
     C                   MOVEL     V_DELT        PDELT
     C                   MOVEL     V_DELF        PDELF
     C                   MOVEL     DDTDSI        PTDSI
     C                   MOVEL     DDSMTH        PSMTH
     C                   MOVEL     BFDRF1        PC101
     C                   MOVEL     BFDRF2        PC102
     C                   MOVEL     DDPRYC        PPRYC
     C                   Z-ADD     V_TDVD        PTDVD
 
     C     CSE028        IFEQ      'Y'
     C                   MOVEL     DDBPBK        PPBKC
     C                   MOVEL     DDMRKT        PMKCT
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDefScn - Default fields in screen                          *
      *                                                               *
      *****************************************************************
 
     C     SRDefScn      BEGSR
 
     C     KEY001        KLIST
     C                   KFLD                    PTDRF
     C                   KFLD                    PWHEN
 
     C                   EVAL      PGMNAM = 'SEDORFRTV'                                     BUG10085
                                                                                            BUG10085
     C                   IF        PWHEN = 'A'
     C                   MOVEL     ADDGMES       PGMES
     C                   MOVEL     ADDGMEC       PGMEC
     C                   MOVEL     ADDCCID       PCCID
     C                   MOVEL     ADDSNEW       PSNEW
     C                   ELSE
     C                   MOVEL     BDDGMES       PGMES
     C                   MOVEL     BDDGMEC       PGMEC
     C                   MOVEL     BDDCCID       PCCID
     C                   MOVEL     BDDSNEW       PSNEW
     C                   ENDIF
      *
      ** Access Branch details via access program
      *  (database error handling done in access program)
     C                   MOVE      PTDBR         WDSNB
     C**********         CALLB     'AOBRCHR0'                                          CSE045 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C***********        PARM      '*FIRST '     @OPTN                                      BUG10085
     C                   PARM      '*KEY   '     @OPTN                                      BUG10085
     C                   PARM                    WDSNB             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                 CSE045 CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C                   MOVE      A8BICN        WWBICN
 
     C                   EVAL      CrSEFilFmt = *Blanks
     C     KEY001        CHAIN     TRADSDD2                           99
 
     C                   CALLB     'SETSESDFT'
      *                             =========
      *
      ** INPUT
      ** =====
      *
      ** Securities retrieved from file - file format
     C                   PARM                    CrSEFilFmt
 
     C                   PARM                    PDATA
 
     C                   PARM                    CSE022
 
     C                   PARM                    CSE028
 
     C                   PARM                    SWRTN
 
     C                   PARM                    DFTFLG
 
     C**********         PARM                    WWBICN            6 0                       CSD027A
     C                   PARM                    WWBICN            6                         CSD027A
 
     C                   PARM                    PGMNAM
     C                   PARM                    DDMRKT                                      BUG2274
      ** SWIFT 2006                                                                          CSW206E
     C                   PARM                    CSW206                                      CSW206E
      ** SWIFT 2010                                                                           CSW210
     C                   PARM                    CSW210                                       CSW210
      *
      ** OUTPUT
      ** ======
      *
      ** Securities screen 1 details retrieved from file - screen format
     C                   PARM                    NwSE1ScnFmt
                                                                                            BUG10476
      * If Place of settlement is blank then use market Centre to access SEMKC              BUG10476
      * and default from here.                                                              BUG10476
     C     ESPSET        IFEQ      *BLANKS                                                  BUG10476
     C     AESPSET       ANDEQ     *BLANKS                                                  BUG10476
     C     DDMRKT        IFNE      *BLANKS                                                  BUG10476
     C     DDMRKT        CHAIN     SEMKCDF                            99                    BUG10476
     C     *IN99         IFEQ      *OFF                                                     BUG10476
     C                   EVAL      AESPSET = PSETL                                          BUG10476
     C                   ENDIF                                                              BUG10476
     C                   ENDIF                                                              BUG10476
     C                   ENDIF                                                              BUG10476
                                                                                            BUG10476
      *
      ** Initialise Clearance Type (1 to 4 is MT580 for Settlements)
      *
     C     PWHEN         IFNE      'B'
     C     PCLTY         OREQ      '1'
     C     PCLTY         OREQ      '3'
 
     C     PCLTY         IFEQ      '1'
     C     PCLTY         OREQ      '2'
     C     PCLTY         OREQ      '3'
     C     PCLTY         OREQ      '4'
     C                   MOVE      '14'          WWCLTY
     C                   ENDIF
 
     C                   ELSE
     C     PTDTP         IFEQ      'TP'
     C                   MOVE      PDELF         WCUST
     C                   ELSE
     C                   MOVE      PDELT         WCUST
     C                   END
 
     C                   IF        WCUST <> *BLANKS                                         BUG12874
     C                   CALL      'AOSECSR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    WCUST             6
     C     SDSECS        PARM      SDSECS        DSSDY
     C                   ENDIF                                                              BUG12874
 
     C     BFCLAS        IFEQ      'E'
     C     PCLTY         ANDEQ     '4'
     C     BFCLAS        OREQ      'E'
     C     PCLTY         ANDEQ     '5'
     C     BFCLAS        OREQ      'C'
     C     PCLTY         ANDEQ     '2'
     C     BFCLAS        OREQ      'C'
     C     PCLTY         ANDEQ     '5'
     C                   MOVE      '14'          WWCLTY
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Set up trade type as opposite, if second record
      *
     C     PWHEN         IFEQ      'B'
     C     PTDTP         IFEQ      'TP'
     C                   MOVE      'TS'          WTDTP
     C                   ELSE
     C                   MOVE      'TP'          WTDTP
     C                   ENDIF
 
     C                   ELSE
     C                   MOVE      PTDTP         WTDTP
     C                   ENDIF
 
     C     ESRDefScn1    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrExSetA - Routine to validate Extended Settlements.      *
      *                                                               *
      *****************************************************************
     C     ValdTrExSetA  BEGSR
 
      *
      ** Access Branch details via access program
      *  (database error handling done in access program)
     C                   MOVE      PTDBR         WDSNB
     C**********         CALLB     'AOBRCHR0'                                          CSE045 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C***********        PARM      '*FIRST '     @OPTN                                      BUG10085
     C                   PARM      '*KEY   '     @OPTN                                      BUG10085
     C                   PARM                    WDSNB             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                 CSE045 CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C                   MOVE      A8BICN        WWBICN
 
     C*****              MOVEL     DDCNUM        WCTPCN                                     BUG11622
     C**********         MOVEL     CustNum       WCTPCN                              BUG11622 247451
     C                   MOVEL     PTCNR         WCTPCN                                       247451
                                                                                              CAP087
     C**********         IF        DDCNUM <> *BLANK                                  CAP087 BUG12874
     C                   IF        WCTPCN <> *BLANK                                         BUG12874
      *
      ** Retrieve classification of counterparty
      *
     C                   CALL      'AOSECSR0'
     C                   PARM      '*DBERR '     @Rtcd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      WCTPCN        WCust
     C     SDSECS        PARM      SDSECS        DSSDY
                                                                                              CAP087
     C                   ENDIF                                                                CAP087
      *
      ** Setup parameters to call module SEDORFRTV
      *
     C     PTDTP         IFEQ      'TP'
      *
     C     BFCLAS        IFEQ      'M'
     C                   MOVEL     PDELT         PDEPO
     C                   MOVEL     WWBICN        PCUST
     C                   MOVEL     PDELT         PDEPO2
     C                   ELSE
     C                   MOVEL     PDELT         PDEPO
     C*****              MOVEL     DDCNUM        PCUST                                      BUG11622
     C**********         MOVEL     CustNum       PCUST                               BUG11622 247451
     C                   MOVEL     PTCNR         PCUST                                        247451
     C                   MOVEL     PDELT         PDEPO2
     C                   ENDIF
 
     C                   ELSE
 
     C     BFCLAS        IFEQ      'M'
     C                   MOVEL     PDELF         PDEPO
     C                   MOVEL     WWBICN        PCUST
     C                   MOVEL     PDELT         PDEPO2
     C                   ELSE
     C                   MOVEL     PDELF         PDEPO
     C*****              MOVEL     DDCNUM        PCUST                                      BUG11622
     C**********         MOVEL     CustNum       PCUST                               BUG11622 247451
     C                   MOVEL     PTCNR         PCUST                                        247451
     C                   MOVEL     PDELT         PDEPO2
     C                   ENDIF
 
     C                   ENDIF
      ** If CSE022 is installed then setup Safekeeping A/C Line by using module SEDORFRTV
      *
     C     CSE022        IFEQ      'Y'
      *
     C                   CALL      PGMNAM
     C                   PARM      *BLANKS       PRETC
     C                   PARM                    PDEPO
     C                   PARM                    PCUST
     C                   PARM      *BLANKS       PSKAL
 
     C     AESSKAN       IFEQ      *BLANKS
     C                   MOVEL     PDEPO         AESSKAN
     C                   END
     C     AESSKAL       IFEQ      *BLANKS
     C                   MOVEL     PSKAL         AESSKAL
     C                   END
 
     C                   CALL      PGMNAM
     C                   PARM      *BLANKS       PRETC
     C                   PARM                    PDEPO2
     C                   PARM                    PTCNR
     C                   PARM      *BLANKS       PSKAL
 
     C     AESSA1N       IFEQ      *BLANKS
     C                   MOVEL     PDEPO2        AESSA1N
     C                   END
     C     AESSA1L       IFEQ      *BLANKS
     C                   MOVEL     PSKAL         AESSA1L
     C                   END
 
     C                   ENDIF
 
     C*****BFCLAS        IFNE      'S'                                                       BUG5557
     C*****BFCLAS        ANDNE     'D'                                                       BUG5557
     C*****BFCLAS        ANDNE     'I'                                                       BUG5557
     C     BFCLAS        IFNE      'I'                                                       BUG5557
     C                   EVAL      PMODE = '*FRONT'
     C                   EVAL      PMODE2 = '*FRONT'                                        MD035243
     C                   EVAL      BeforeIdx = Idx
     C                   EVAL      BeforeWIdx = WIdx
     C                   MOVE      'B_SESVAL_A'  D_Point          10                          245542
     C                   CALLB     'SETSESVAL'
      *                             =========
      *
      ** Mode = '*FRONT' (front office transaction interface)
      ** Mode = '      ' (not front office transaction interface)
      ** Mode = '*RPR  ' (repair function)
      ** Mode = '*SIN  ' (screen input function)
     C**********         PARM                    PMODE                                      MD035243
     C                   PARM                    PMODE2                                     MD035243
      *
      ** Response mode
     C                   PARM      'S'           APRespMode
      *
      ** Security API Trades Extended Settlement details from incoming transaction
      ** - screen format
     C                   PARM                    TranInExtA
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** MT5xx SSI Enhancements
     C                   PARM                    CSE028
      *
      ** ERI Information for non-EMU users
     C                   PARM                    CSW014
      *
      ** SWIFT 2001
     C                   PARM                    CSW201
      *
      ** CSW098
     C                   PARM                    SWRTN
      ** SWIFT 2006                                                                          CSW206E
     C                   PARM                    CSW206                                      CSW206E
      ** SWIFT 2010                                                                           CSW210
     C                   PARM                    CSW210                                       CSW210
      ** CFT004 - IBAN Numbers                                                                CSW210
     C                   PARM                    CFT004                                       CSW210
      *
      ** Other Parameters
     C                   PARM                    PDATA
 
     C                   PARM                    WTDTP
 
     C                   PARM                    WWCLTY
 
     C**********         PARM                    @ADDSAFA                                     245542
     C                   PARM                    ADDSAFA                                      245542
      *
      ** Function Keys
     C                   PARM                    PINKS
 
     C                   PARM                    PINKT
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IdX
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdX
      *
      ** Security API Trades Extended Settlements Error Indicators
     C                   PARM                    OKX2Swft
      *
      ** Security API Trades Extended Settlements Valid File
     C                   PARM                    ValidTX2A
     C                   MOVE      'A_SESVAL_A'  D_Point          10                          245542
 
      ** Identify each field in error with prefix A
     C                   IF        BeforeIdx <> Idx
     C                   EVAL      StepIdx = BeforeIdx + 1
     C     StepIdx       DOUGT     Idx
     C                   EVAL      FldNameArr(StepIdx) = 'A'
     C                                     + FldNameArr(StepIdx)
     C                   EVAL      StepIdx = StepIdx + 1
     C                   ENDDO
     C                   ENDIF
 
     C                   IF        BeforeWIdx <> WIdx
     C                   EVAL      StepIdx = BeforeWIdx +1
     C*****StepIdx       DOUGT     Idx                                                      AR638989
     C     StepIdx       DOUGT     WIdx                                                     AR638989
     C                   EVAL      WFldNamArr(StepIdx) = 'A'
     C                                     + WFldNamArr(StepIdx)
     C                   EVAL      StepIdx = StepIdx + 1
     C                   ENDDO
     C                   ENDIF
 
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrExSetB - Routine to validate Extended Settlements.      *
      *                                                               *
      *****************************************************************
     C     ValdTrExSetB  BEGSR
 
     C                   EVAL      PMODE = '*FRONT'
     C                   EVAL      PMODE2 = '*FRONT'                                        MD035243
     C                   MOVE      *ALL'Y'       OKX2Swft                                   MD035243
     C                   EVAL      BeforeIdx = Idx
     C                   EVAL      BeforeWIdx = WIdx
     C                   MOVE      'B_SESVAL_B'  D_Point          10                          245542
     C                   CALLB     'SETSESVAL'
      *                             =========
      *
      ** Mode = '*FRONT' (front office transaction interface)
      ** Mode = '      ' (not front office transaction interface)
      ** Mode = '*RPR  ' (repair function)
      ** Mode = '*SIN  ' (screen input function)
     C**********         PARM                    PMODE                                      MD035243
     C                   PARM                    PMODE2                                     MD035243
      *
      ** Response mode
     C                   PARM      'S'           APRespMode
      *
      ** Security API Trades Extended Settlement details from incoming transaction
      ** - screen format
     C                   PARM                    TranInExtB
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** MT5xx SSI Enhancements
     C                   PARM                    CSE028
      *
      ** ERI Information for non-EMU users
     C                   PARM                    CSW014
      *
      ** SWIFT 2001
     C                   PARM                    CSW201
      *
      ** CSW098
     C                   PARM                    SWRTN
      ** SWIFT 2006                                                                          CSW206E
     C                   PARM                    CSW206                                      CSW206E
      ** SWIFT 2010                                                                           CSW210
     C                   PARM                    CSW210                                       CSW210
      ** CFT004 - IBAN Numbers                                                                CSW210
     C                   PARM                    CFT004                                       CSW210
      *
      ** Other Parameters
     C                   PARM                    PDATA
 
     C                   PARM                    WTDTP
 
     C                   PARM                    WWCLTY
 
     C                   PARM                    @BDDSAFA
      *
      ** Function Keys
     C                   PARM                    PINKS
 
     C                   PARM                    PINKT
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IdX
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdX
      *
      ** Security API Trades Extended Settlements Error Indicators
     C                   PARM                    OKX2Swft
      *
      ** Security API Trades Extended Settlements Valid File
     C                   PARM                    ValidTX2B
     C                   MOVE      'A_SESVAL_B'  D_Point          10                          245542
 
     C                   IF        BeforeIdx <> Idx
     C                   EVAL      StepIdx = BeforeIdx + 1
     C     StepIdx       DOUGT     Idx
     C                   EVAL      FldNameArr(StepIdx) = 'B'
     C                                     + FldNameArr(StepIdx)
     C                   EVAL      StepIdx = StepIdx + 1
     C                   ENDDO
     C                   ENDIF
 
     C                   IF        BeforeWIdx <> WIdx
     C                   EVAL      StepIdx = BeforeWIdx +1
     C*****StepIdx       DOUGT     Idx                                                      AR638989
     C     StepIdx       DOUGT     WIdx                                                     AR638989
     C                   EVAL      WFldNamArr(StepIdx) = 'B'
     C                                     + WFldNamArr(StepIdx)
     C                   EVAL      StepIdx = StepIdx + 1
     C                   ENDDO
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdateAmd - Routine to check whether the fields amended      *
      *    are amendable.                                             *
      *                                                               *
      *****************************************************************
     C     ValdateAmd    BEGSR
      *
      ** This subroutine calls a procedure which checks whether it
      ** was valid to Amend or Change any of the fields which have been
      ** altered.  Some are never amendable and some are amendable depending
      ** on the Action Code - "A" for Amend, "C" for Change.
 
      ** To determine what fields have changed, the current fields
      ** on file must be converted to a 'screen' format.
 
      ** These fields are then compared with the fields on the input
      ** transaction.
 
      ** Any errors detected by the called procedure take precedence
      ** over any errors found during the validation of the complete
      ** transaction.  The errors from the called procedure are kept
      ** separately and, if any are found, these errors will REPLACE
      ** the normal validation errors.
 
     C                   CALLB     'SETRADAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Incoming Trade in Screen Format :
 Form * - Primary Details
      * - Secondary Details
      * - Third Screen Details
      * - Exchange Rate Details
      * - Settlement Details
      * - Charge & Commission Details
      * - SWIFT Details A
      * - SWIFT Details B
     C                   PARM                    TraninPrim
     C                   PARM                    TraninSeco
     C                   PARM                    TraninThir
     C                   PARM                    TraninExch
     C                   PARM                    TraninSett
     C                   PARM                    TraninChCm
     C                   PARM                    TraninSwfA
     C                   PARM                    TraninSwfB
      *
      * (Current) Trade in Screen Format :
 Form * - Primary Details
      * - Secondary Details
      * - Third Screen Details
      * - Exchange Rates Details
      * - Settlement Instructions
      * - Charges/Commissions
      * - SWIFT Details A
      * - SWIFT Details B
     C                   PARM                    CurTrPrim
     C                   PARM                    CurTrSeco
     C                   PARM                    CurTrThir
     C                   PARM                    CurTrExch
     C                   PARM                    CurTrSett
     C                   PARM                    CurTrChCm
     C                   PARM                    CurTrSwftA
     C                   PARM                    CurTrSwftB
      *
      * Customer classification
      * Trade incomplete ind
      * Trade Date Made Complete
     C                   PARM                    CustClass
     C                   PARM                    TINC
     C                   PARM                    TDMC
 
      ** Settlement Currency Decimal Places
 
     C                   PARM                    SetCcyDec
 
      ** Hedge Accounting Phase B
 
     C                   PARM                    CAS006
      *
      * OUTPUTS
      *
      * Error Indicators
     C                   PARM                    OKTrPrim
     C                   PARM                    OKTrSeco
     C                   PARM                    OKTrThir
     C                   PARM                    OKTrExch
     C                   PARM                    OKTrSett
     C                   PARM                    OKTrChCm
     C                   PARM                    OKTrSwft
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
     C                   Z-ADD     AmIdx         Idx
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPAMD - Set up fields that are needed in the validation    *
      *    of amendments and changes.                                 *
      *                                                               *
      *****************************************************************
     C     SetupAmd      BEGSR
 
      * For Amends, put the complete (pre-existing) trade into the Valid
      *  file record - fields in this will be updated during processing
 
     C                   MOVE      TradFilFmt    ValidTrad
     C                   MOVE      TX1AFilFmt    ValidTX1A
     C                   MOVE      TX1BFilFmt    ValidTX1B
     C                   MOVE      TX2AFilFmt    ValidTX2A
     C                   MOVE      TX2BFilFmt    ValidTX2B
 
      *  Certain groups of fields on the trade may not be supplied for an
      *  amendment. If none of the fields in each group were supplied
      *  (i.e. all are blank), default the existing database values ...
 
     C                   IF            (TranInExch = *blank)
     C                   EVAL      TranInExch = CurTrExch
     C                   ENDIF
 
     C                   IF            (TranInSett = *blank)
     C                   EVAL      TranInSett = CurTrSett
     C                   ENDIF
 
     C                   IF            (TranInChCm = *blank)
     C                   EVAL      TranInChCm = CurTrChCm
     C                   ENDIF
 
     C                   IF            (TranInSwfA = *blank)
     C                   EVAL      TranInSwfA = CurTrSwftA
     C                   ENDIF
 
     C                   IF            (TranInSwfB = *blank)
     C                   EVAL      TranInSwfB = CurTrSwftB
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateTr - Routine to validate the main tranaction details  *
      *                                                               *
      *****************************************************************
     C     ValidateTr    BEGSR
 
      * Validate Trade Primary details
 
     C                   EXSR      ValdTrPrim
                                                                                            BUG10476
      * Default Market Centre from security                                                 BUG10476
     C                   IF        DDMRKT = *BLANKS                                         BUG10476
     C                   EVAL      DDMRKT = SMCC                                            BUG10476
     C                   ENDIF                                                              BUG10476
 
      * Validate Trade Secondary details
 
     C                   IF        idx = 0                                                   BUG3950
     C                   EXSR      ValdTrSeco
 
      ** Save Previous entries for interest amount recalculation                            BUG11194
     C                   EXSR      SavePrevEnt                                              BUG11194
                                                                                            BUG11194
      ** Validate more Trade details (third screen)
 
     C                   IF        CAS006 = 'Y'
     C                   EXSR      ValdTrThir
     C                   ENDIF
 
      * Default Trade Other details
      * (Exchange Rate, Settlement, Charges and Commissions)
 
      * Exchange Rates                                                                      BUG10021
     C**********         If        TranInExch = *blanks                            BUG10021 BUG11197
     C                   If        TranInExch = *blanks                                     BUG8690R
     C                   EXSR      DfltTrExc                                                BUG10021
     C*********          Endif                                                     BUG10021 BUG11197
     C                   Endif                                                              BUG8690R
                                                                                            BUG10021
      * Don't default if details already entered                                             BUG8690
     C                   EVAL      WDDCLTY2= *BLANKS                                        BUG11529
     C                   EVAL      WDDDELF = *BLANKS                                        BUG11529
     C                   EVAL      WDDDELT = *BLANKS                                        BUG11529
     C                   EVAL      WDDORBR = *BLANKS                                        BUG11529
     C                   EVAL      WrkDfltInd = 'N'                                         BUG11529
      *
     C                   If        DDCLTY2 <> *Blanks                                        BUG8690
     C                   MOVE      DDCLTY2       WDDCLTY2          1                         BUG8690
     C                   Eval      DDCLTY2 = *blanks                                         BUG8690
     C                   EndIf                                                               BUG8690
                                                                                             BUG8690
     C                   IF        DDDELF  <> *Blanks                                        BUG9917
     C                   EVAL      WDDDELF = DDDELF                                          BUG9917
     C                   EVAL      DDDELF = *Blanks                                          BUG9917
     C                   ENDIF                                                               BUG9917
                                                                                             BUG9917
     C                   IF        DDDELT  <> *Blanks                                        BUG9917
     C                   EVAL      WDDDELT = DDDELT                                          BUG9917
     C                   EVAL      DDDELT = *Blanks                                          BUG9917
     C                   ENDIF                                                               BUG9917
                                                                                             BUG8690
     C                   IF        DDORBR  <> *BLANKS                                       BUG11529
     C                   EVAL      WDDORBR = DDORBR                                         BUG11529
     C                   EVAL      DDORBR = *BLANKS                                         BUG11529
     C                   ENDIF                                                              BUG11529
      *
     C*****************  If        TranInExch = *blanks                             BUG8690 BUG10021
     C****************             and TranInSett = *blanks                         BUG8690 BUG10021
     C****************             and TranInChCm = *blanks                         BUG8690 BUG10021
     C                   If        TranInSett = *blanks                                     BUG10021
     C                             and TranInChCm = *blanks                                 BUG10021
                                                                                             BUG8690
     C                   IF        WDDCLTY2  <> *BLANKS                                     BUG11529
     C                   EVAL      DDCLTY2 = WDDCLTY2                                       BUG11529
     C                   ENDIF                                                              BUG11529
     C                   IF        WDDDELF  <> *BLANKS                                      BUG11529
     C                   EVAL      DDDELF  = WDDDELF                                        BUG11529
     C                   ENDIF                                                              BUG11529
     C                   IF        WDDDELT  <> *BLANKS                                      BUG11529
     C                   EVAL      DDDELT  = WDDDELT                                        BUG11529
     C                   ENDIF                                                              BUG11529
     C                   IF        WDDORBR  <> *BLANKS                                      BUG11529
     C                   EVAL      DDORBR  = WDDORBR                                        BUG11529
     C                   ENDIF                                                              BUG11529
     C                   EVAL      WrkDfltInd = 'Y'                                         BUG11529
      *
     C                   EXSR      DfltTrOTH
     C                   EndIf                                                               BUG8690
      *
     C                   IF        WrkDfltInd <> 'Y'                                        BUG11529
     C                   IF        WDDCLTY2  <> *BLANKS                                     BUG11529
     C                   Eval      DDCLTY2 = WDDCLTY2                                        BUG8690
     C                   ENDIF                                                              BUG11529
     C                   IF        WDDDELF  <> *BLANKS                                      BUG11529
     C                   EVAL      DDDELF  = WDDDELF                                         BUG9917
     C                   ENDIF                                                              BUG11529
     C                   IF        WDDDELT  <> *BLANKS                                      BUG11529
     C                   EVAL      DDDELT  = WDDDELT                                         BUG9917
     C                   ENDIF                                                              BUG11529
     C                   IF        WDDORBR  <> *BLANKS                                      BUG11529
     C                   EVAL      DDORBR  = WDDORBR                                        BUG11529
     C                   ENDIF                                                              BUG11529
     C                   ENDIF                                                              BUG11529
 
      * CalcTrCHCM - Calculate Trade Charges/Commissions
 
     C                   EXSR      CalcTrCHCM
                                                                                      CGL014 BUG3145
      **CalcTrCVAL*-*Calculate*Trade*Countervalue                                     CGL014 BUG3145
                                                                                      CGL014 BUG3145
     C**********         EXSR      CalcTrCVAL                                         CGL014 BUG3145
 
      * Validate Trade Other details
      * (Exchange Rate, Settlement, Charges and Commissions)
 
     C                   EXSR      ValdTrOTH
                                                                                              237063
      * CalcTrEUTX - Calculate EU Tax                                                         237063
                                                                                              237063
     C                   IF        CGL031 = 'Y'                                               237063
     C                   EXSR      CalcTrEUTX                                                 237063
     C                   ENDIF                                                                237063
 
      * CalcTrCVAL - Calculate Trade Countervalue
 
     C                   EXSR      CalcTrCVAL                                                BUG3145
     C**********         EXSR      CalcTrCVAL                                                 CGL014
                                                                                             BUG3145
      ** Additional validations                                                              BUG3145
      ** (Pay To Account)                                                                    BUG3145
                                                                                             BUG3145
     C                   IF        CGL014 = 'Y'  AND  V_PAYT <> *BLANKS                      BUG3145
     C                             AND  DDPAYTOK <> 'N'                                      BUG3145
     C                   EXSR      ValdTrAddl                                                BUG3145
     C                   ENDIF                                                               BUG3145
      *
      * If MT5XX Message Generation are installed,
      *
     C     S01401        IFEQ      'Y'
 
      * Default Trade Extension (SWIFT) 'A' details
 
     C     TranInSwfA    IFEQ      *BLANK
     C*****DDACTN        OREQ      'I'                                                      BUG18525
     C*****DDACTN        ANDEQ     'I'                                             BUG18525 BUG21092
     C     DDACTN        OREQ      'I'                                                      BUG21092
     C                   EXSR      DfltTrSwfA
     C                   END
 
      *                                                                                       247873
      ** Destination of Settlements                                                           247873
      *                                                                                       247873
     C                   IF        DDTDTP = 'TP'                                              247873
     C                   MOVEL     V_DELT        WSNDR                                        247873
     C                   MOVEL     V_DELT        WDEST                                        247873
     C                   ELSE                                                                 247873
     C                   MOVEL     V_DELF        WSNDR                                        247873
     C                   MOVEL     V_DELF        WDEST                                        247873
     C                   ENDIF                                                                247873
     C                   MOVEL     V_SMTH        WSETP                                        247873
      *                                                                                       247873
     C                   IF        WDEST <> *Blanks                                           247873
     C                   EXSR      SR1100                                                     247873
     C                   MOVE      WWROU         A_DDROUS                                     247873
     C                   MOVE      WWROT         A_DDROTS                                     247873
     C                   ENDIF                                                                247873
      *                                                                                       247873
      **Validate*Trade*Extension*(SWIFT)*'A'*details**********************                    225421
      ** Validation to be done after Extended Settlement Information default                  225421
     C********           EXSR      ValdTrSwfA                                                 225421
      *
      ** Set up PDATA array fields for passing to SETSESVAL
      *
     C                   EXSR      SetPDATA
      *
      ** Validate Trade Extended Settlements Details A
      *
     C                   EVAL      PWHEN = 'A'
     C                   IF        (DDACTN = 'I') and (TranInExtA = *BLANKS)
     C                   EVAL      DFTFLG = 'Y'
     C                   ELSE
     C                   EVAL      DFTFLG = 'N'
     C                   ENDIF
     C                   EXSR      SRDefScn
      *                                                                                       245542
      ** Only default safekeeping account if not already defined                              245542
     C     AESSKAL       IFNE      *BLANKS                                                    245542
     C     ESSKAL        ORNE      *BLANKS                                                    245542
     C                   MOVE      *BLANKS       ADDSAFA                                      245542
     C                   ENDIF                                                                245542
      *                                                                                       245542
     C                   IF        TranInExtA = *BLANKS
      *                                                                                       245542
     C                   EVAL      TranInExtA = NwSE1ScnFmt
     C                   ENDIF
     C                   EXSR      ValdTrExSetA
                                                                                              225421
     C                   IF        DDACTN = 'I' AND A_T2SKAL = *BLANK                         225421
     C                   MOVE      AESSKAL       A_T2SKAL                                     225421
     C                   END                                                                  225421
      *                                                                                       247873
     C                   IF        A_T2SKAL = *Blanks AND AESSKAL <> *Blanks                  247873
     C                   MOVE      AESSKAL       A_T2SKAL                                     247873
     C                   ENDIF                                                                247873
                                                                                              225421
      * Validate Trade Extension (SWIFT) 'A' details                                          225421
     C                   EXSR      ValdTrSwfA                                                 225421
      *
      ** If screen B is required
      *
     C     CSW003        IFEQ      'Y'
     C     CustClass     IFEQ      'S'
     C     V_DELT        ANDNE     V_DELF
     C     CustClass     OREQ      'D'
     C     V_DELT        ANDNE     V_DELF
 
      * Default Trade Extension (SWIFT) 'B' details
 
     C     TranInSwfB    IFEQ      *BLANK
     C*****DDACTN        OREQ      'I'                                                      BUG18525
     C*****DDACTN        ANDEQ     'I'                                             BUG18525 BUG21092
     C     DDACTN        OREQ      'I'                                                      BUG21092
     C                   EXSR      DfltTrSwfB
     C                   END
      *                                                                                       247873
      ** Destination of Settlements                                                           247873
      *                                                                                       247873
     C                   IF        DDTDTP = 'TP'                                              247873
     C                   MOVEL     V_DELF        WSNDR                                        247873
     C                   MOVEL     V_DELF        WDEST                                        247873
     C                   ELSE                                                                 247873
     C                   MOVEL     V_DELT        WSNDR                                        247873
     C                   MOVEL     V_DELT        WDEST                                        247873
     C                   ENDIF                                                                247873
     C                   MOVEL     V_SMTH        WSETP                                        247873
      *                                                                                       247873
     C                   IF        WDEST <> *Blanks                                           247873
     C                   EXSR      SR1100                                                     247873
     C                   MOVE      WWROU         B_DDROUS                                     247873
     C                   MOVE      WWROT         B_DDROTS                                     247873
     C                   ENDIF                                                                247873
 
      **Validate*Trade*Extension*(SWIFT)*'B'*details**********************                    225421
      ** Validation to be done after Extended Settlement Information default                  225421
     C************       EXSR      ValdTrSwfB                                                 225421
     C                   EXSR      SETPDATA
     C                   EVAL      PWHEN = 'B'
     C                   IF        (DDACTN = 'I') and (TranInExtB = *BLANKS)
     C                   EVAL      DFTFLG = 'Y'
     C                   ELSE
     C                   EVAL      DFTFLG = 'N'
     C                   ENDIF
     C                   EXSR      SRDefScn
     C                   IF        TranInExtB = *BLANKS
     C                   EVAL      TranInExtB = NwSE1ScnFmt
     C                   ENDIF
      *                                                                                     AR596191
     C                   IF        DDACTN = 'I' AND BESSKAL = *BLANK                        AR596191
     C                   MOVE      AESSKAL       BESSKAL                                    AR596191
     C                   ENDIF                                                              AR596191
      *                                                                                     AR596191
     C                   EXSR      ValdTrExSetB
 
     C                   IF        DDACTN = 'I' AND B_T2SKAL = *BLANK                         225421
     C                   MOVE      AESSKAL       B_T2SKAL                                     225421
     C                   END                                                                  225421
      * Validate Trade Extension (SWIFT) 'B' details                                          225421
     C                   EXSR      ValdTrSwfB                                                 225421
     C                   END
     C                   END
 
     C                   END
      *                                                                                       CER001
     C     Idx           IFNE      0                                                          CER001
     C                   GOTO      EvalidTr                                                   CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Validate Extension Details Screen                                                    CER001
      *                                                                                       CER001
     C                   IF        ULX603 = 'Y'                                               CER001
     C                   EXSR      ValidateLUX                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                               BUG3950
 
     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * ValidateLUX  - Validate Extension Details                     *                       CER001
      *                                                               *                       CER001
      * Calls:                                                        *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
      *                                                                                       CER001
     C     ValidateLUX   BEGSR                                                                CER001
     C                   EVAL      PETDRF  =  DDTDRF                                          CER001
     C                   MOVEL(P)  DDBPBK        UTDBK                                        CER001
     C                   MOVEL(P)  DDCNUM        UVTCNR                                       CER001
     C                   MOVEL     V_TDVD        #1TDVD                                       CER001
     C                   MOVEL     V_TDDT        #1TDDT                                       CER001
     C                   MOVEL     ISSD          #1ISSD                                       CER001
     C                   MOVEL     MATY          #1MATY                                       CER001
      *                                                                                       CER001
     C                   CALLB     'SETRAD2VL'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    OkFlagsDS                                    CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIdArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIdArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    ValidLUX                                     CER001
      *                                                                                       CER001
     C                   PARM                    ULX008                                       CER001
     C                   ENDSR                                                                CER001
      *                                                                                       CER001
      *****************************************************************                       CER001
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrPrim - Validate Trade Primary details                   *
      *                                                               *
      *****************************************************************
     C     ValdTrPrim    BEGSR
 
     C                   CALLB     'SETRADPVAL'
 
      * INPUTS
 
      * Response mode
     C                   PARM      'S'           RespMode          1
 
      ** Trade Primary Details
     C                   PARM                    TranInPrim
      * Custom Extra Data file data
     C                   PARM                    ExtData
 
      ** Trade settlement currency
     C                   PARM                    DDSETC            3
      *
      ** Default & Validate (Y or N)
     C                   PARM      'Y'           Default           1
     C                   PARM      'Y'           Validate          1
 
      * Output details of original book.
     C                   PARM                    OLDBK1
     C                   PARM                    WARNIND
      *
      ** First Buy-sell back indicator
     C                   PARM                    PFBYSL            1
      *
      ** First Buy-sell book code
     C                   PARM                    PFBPBK            2
      *
      ** First Buy-sell counterparty
     C**********         PARM      *ZEROS        PFTCNR            6 0                       CSD027A
     C                   PARM      *Blanks       PFTCNR            6                         CSD027A
      *
      ** First Buy-sell trade type
     C                   PARM                    PFTDTP            2
      *
      ** First Buy-sell Value Date
     C                   PARM      *ZEROS        PFTDVD            5 0
      *
      ** First Buy-sell Security Shortname
     C                   PARM                    PFSESN           10
     C                   PARM                    CallFromVU                                   CAP087
      * OUTPUTS
 
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
 
      * Coupon Rate
      * Current Factor
     C                   PARM                    DDCPNR           13
     C                   PARM                    DDCFCT           12
 
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
      *
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      *
      ** Portfolio Details
     C                   PARM                    PortDts
      ** Default basket for backup withholding
     C                   PARM                    PDRBW
 
      ** Trade Primary Details OK inds
     C                   PARM                    OKTrPrim
 
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
 
      * Valid Trade layout (DS) from/to caller
     C                   PARM                    ValidTrad
 
      * PB Order Number
     C                   PARM                    DDORDE
 
      ** Save The Counterparty Classification for Output.
     C                   EVAL      CPartyClass = CustClass
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrSeco - Validate Trade Secondary details                 *
      *                                                               *
      *****************************************************************
     C     ValdTrSeco    BEGSR
 
     C                   CALLB     'SETRADSVAL'
 
      * INPUTS
 
      * Response mode
     C                   PARM      'S'           RespMode          1
 
      ** Trade Primary Details
      ** Trade Secondary Details
     C                   PARM                    TranInPrim
     C                   PARM                    TranInSeco
      * Custom Extra Data file data
     C                   PARM                    ExtData
      *
      ** Default & Validate (Y or N)
     C                   PARM      'Y'           Default
     C                   PARM      'Y'           Validate
 
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
 
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
      *
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      *
      ** MT5xx SSI (Phase 2)
     C                   PARM                    CSE028
                                                                                              CGL031
      ** CGL031 Switchable Feature                                                            CGL031
     C                   PARM                    CGL031                                       CGL031
                                                                                              237063
      ** Current File Trade Date                                                              237063
     C                   PARM                    TDVD                                         237063
      *
      * OUTPUTS
      *
      ** Settlement Currency Details
     C                   PARM                    SetCcyDts
 
      ** Trade Secondary Details OK inds
     C                   PARM                    OKTrSeco
 
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
 
      * Valid Trade layout (DS) from/to caller
     C                   PARM                    ValidTrad
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValdTrThir - Validate Trade third screen details             *
      *                                                               *
      *****************************************************************
 
     C     ValdTrThir    BEGSR
 
     C                   CALLB     'SETRADTVAL'
 
      ** INPUTS
      ** Response mode
 
     C                   PARM                    RespMode
 
      ** Trade Primary Details
      ** Trade Secondary Details
      ** Trade Third screen details
 
     C                   PARM                    TranInPrim
     C                   PARM                    TranInSeco
     C                   PARM                    TranInThir
 
      ** Custom Extra Data file data
 
     C                   PARM                    ExtData
 
      ** Default & Validate (Y or N)
 
     C                   PARM      'Y'           Default
     C                   PARM      'Y'           Validate
 
      ** Security Details
      ** Investment Type Details
 
     C                   PARM                    SECTY
     C                   PARM                    INVTP
 
      ** Coupon Rate using NTR
      ** Net Treasury Price
 
     C                   PARM                    DDHACR
     C                   PARM                    DDPRICN
 
      ** Customer (Counterparty) Details
      ** Portfolio Details
      ** Nominal Currency Details
      ** Settlement Currency Details
 
     C                   PARM                    CustDts
     C                   PARM                    PortDts
     C                   PARM                    NomCcyDts
     C                   PARM                    SetCcyDts
 
      ** OUTPUTS
 
      ** Trade Third screen details OK inds
 
     C                   PARM                    OKTrThir
 
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
 
      ** Valid Trade layout (DS) from/to caller
 
     C                   PARM                    ValidTrad
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************                     BUG10021
      *                                                               *                     BUG10021
      * DfltTrExc - Default Trade Exchange Rates Details              *                     BUG10021
      *                                                               *                     BUG10021
      *****************************************************************                     BUG10021
     C     DfltTrExc     BEGSR                                                              BUG10021
                                                                                            BUG10021
      ** EXCHANGE RATE DEFAULTING                                                           BUG10021
                                                                                            BUG10021
     C     DDACTN        IFEQ      'I'                                                      BUG10021
     C     DDACTN        OREQ      'C'                                                      BUG10021
     C     DDSETC        ANDNE     SETC                                                     BUG10021
     C     DDACTN        OREQ      'A'                                                      BUG11197
     C     DDSETC        ANDNE     SETC                                                     BUG11197
     C*****TRANINEXCH    OREQ      *BLANKS                                         BUG11197 BUG8690R
                                                                                            BUG10021
     C                   CALLB     'SETEXCHDFT'                                             BUG10021
                                                                                            BUG10021
      * INPUTS                                                                              BUG10021
      *                                                                                     BUG10021
      ** Nominal Currency                                                                   BUG10021
      ** Settlement Currency                                                                BUG10021
     C                   PARM                    NMCY              3                        BUG10021
     C                   PARM                    DDSETC            3                        BUG10021
                                                                                            BUG10021
      ** Nominal Currency Details                                                           BUG10021
      ** Settlement Currency Details                                                        BUG10021
     C                   PARM                    NomCcyDts                                  BUG10021
     C                   PARM                    SetCcyDts                                  BUG10021
      ** ICD                                                                                BUG10021
      ** Euro Currency                                                                      BUG10021
      ** EMU SE Settlement Ccy Conv.                                                        BUG10021
     C                   PARM                    BKEURO                                     BUG10021
     C                   PARM                    CEU005                                     BUG10021
                                                                                            BUG10021
      * OUTPUTS                                                                             BUG10021
                                                                                            BUG10021
      ** Trade Exchange Rate screen fields                                                  BUG10021
                                                                                            BUG10021
     C                   PARM                    TranInExch                                 BUG10021
                                                                                            BUG10021
      ** Trade Exchange Rate file fields                                                    BUG10021
                                                                                            BUG10021
     C                   PARM                    V_TDER           13 8                      BUG10021
     C                   PARM                    V_TMDI            1                        BUG10021
     C                   PARM                    V_TBCR           13 8                      BUG10021
                                                                                            BUG10021
     C                   END                                                                BUG10021
                                                                                            BUG10021
     C                   ENDSR                                                              BUG10021
      /EJECT                                                                                BUG10021
      *****************************************************************                     BUG10021
      *****************************************************************
      *                                                               *
      * DfltTrOTH - Default Trade Other details                       *
      *                                                               *
      *****************************************************************
     C     DfltTrOTH     BEGSR
 
     ****EXCHANGE*RATE*DEFAULTING***                                                        BUG10021
     ***********                                                                            BUG10021
     C*****DDACTN        IFEQ      'I'                                                      BUG10021
     C*****DDACTN        OREQ      'C'                                                      BUG10021
     C*****DDSETC        ANDNE     SETC                                                     BUG10021
     *********                                                                              BUG10021
     C********           CALLB     'SETEXCHDFT'                                             BUG10021
     ********                                                                               BUG10021
     ***INPUTS*                                                                             BUG10021
     ********                                                                               BUG10021
     *** Nominal Currency                                                                   BUG10021
     ****Settlement Currency                                                                BUG10021
     C*******            PARM                    NMCY              3                        BUG10021
     C*******            PARM                    DDSETC            3                        BUG10021
     ********                                                                               BUG10021
     ****Nominal Currency Details                                                           BUG10021
     ****Settlement Currency Details                                                        BUG10021
     C********           PARM                    NomCcyDts                                  BUG10021
     C********           PARM                    SetCcyDts                                  BUG10021
      ***ICD                                                                                BUG10021
      ***Euro Currency                                                                      BUG10021
      ***EMU SE Settlement Ccy Conv.                                                        BUG10021
     C*******            PARM                    BKEURO                                     BUG10021
     C******             PARM                    CEU005                                     BUG10021
     ********                                                                               BUG10021
     ***OUTPUTS                                                                             BUG10021
     ********                                                                               BUG10021
     ****Trade*Exchange Rate screen fields                                                  BUG10021
     ********                                                                               BUG10021
     C*******            PARM                    TranInExch                                 BUG10021
     *********                                                                              BUG10021
     ****Trade*Exchange Rate file fields                                                    BUG10021
     ********                                                                               BUG10021
     C********           PARM                    V_TDER           13 8                      BUG10021
     C********           PARM                    V_TMDI            1                        BUG10021
     C********           PARM                    V_TBCR           13 8                      BUG10021
                                                                                            BUG10021
     C********           END                                                                BUG10021
 
      ** SETTLEMENT INSTRUCTION DEFAULTING
 
     C     DDACTN        IFEQ      'I'
 
     C                   CALLB     'SETSETIDFT'
 
      * INPUTS
 
      ** Booking branch
      ** Incomplete Ind
      ** Trade Type
      ** Settlement Currency
      ** Market Ind.
      ** Book Code.
      ** Market Centre
     C                   PARM                    DDBRCD            3
     C                   PARM                    DDINCS            1
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDSETC            3
     C                   PARM                    DDTDMI            1
     C                   PARM                    DDBPBK
     C                   PARM                    DDMRKT
 
      ** Investment type (SECTYD)
 
     C                   PARM                    SITP              3
 
      ** Nominal Currency Details
      ** Settlement Currency Details
     C                   PARM                    NomCcyDts
     C                   PARM                    SetCcyDts
 
      ** Customer (Counterparty) Details
      ** ( Note: Customer Participant/Non-participant Indicator 1 and
      **  Customer Participant/Non-participant Indicator 2 are also outputs)
     C                   PARM                    CustDts
 
 
      ** ICD
      ** Depot 1 (Eurclear)
      ** Depot 2 (Cedel)
     C                   PARM                    BVDR1             6
     C                   PARM                    BVDR2             6
      *
      ** MT5xx SSI (Phase 2)
     C                   PARM                    CSE028
 
      * OUTPUTS
 
      ** Trade Settlement Instructions
 
     C                   PARM                    TranInSett
 
     C                   END
 
      ** CHARGE/COMMISSION DEFAULTING
 
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     DDACTN        OREQ      'C'
 
     C                   CALLB     'SETCHCMDFT'
 
      * INPUTS
 
      ** Bulk reference
      ** Incomplete Ind.
      ** Market Centre
     C                   PARM                    DDBLKR            6
     C                   PARM                    DDINCS            1
     C                   PARM                    DDMRKT            2
      *
      ** Trade Counterparty
     C                   PARM                    TCNR
      *
      ** Security details
     C                   PARM                    SECTY
      *
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
      *
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      *
      ** Portfolio Details
     C                   PARM                    PortDts
      *
      ** ICD
      ** PM installed
      ** Bank Portfolios installed
      ** Ref applied to 9997 portfolio
      ** Autocharge Option
      ** Adjust Commission Same Day T
      ** Priority of Cust Grp Dft
      ** Priority of Invst typ Dft
      ** Priority of Market Dft
      ** Priority of Cust Chrg Dft
      ** Midas/TOF I/F installed
     C                   PARM                    BGPFMG            1
     C                   PARM                    FCPORS            1
     C                   PARM                    FCR997            4
     C                   PARM                    BVACOP            1
     C                   PARM                    BVACSD            1
     C                   PARM                    BVPCSD            1
     C                   PARM                    BVPIDF            1
     C                   PARM                    BVPMDF            1
     C                   PARM                    BVPOCD            1
     C                   PARM                    S01496            1
     C                   PARM                    BGN4ST            1
 
      * OUTPUTS
 
      ** Commission Rebate %
     C                   PARM                    CMRP              5 3
 
      ** Trade Charges & Commissions screen fields
 
     C                   PARM                    TranInChcm
 
      ** Trade Charges & Commissions file fields
 
     C                   PARM                    V_TBCC            2
     C                   PARM                    V_TCCC            2
     C                   PARM                    V_TCC1            2
     C                   PARM                    V_TCC2            2
 
     C                   END
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrOTH - Validate Trade Other details                      *
      *                                                               *
      *****************************************************************
     C     ValdTrOTH     BEGSR
 
     C                   CALLB     'SETRADOVAL'
 
      * INPUTS
 
      * Response mode
     C                   PARM      'S'           RespMode          1
 
      ** Trade Primary Details
      ** Trade Secondary Details
      ** Trade Exchange Rates
      ** Trade Settlement Instructions
      ** Trade Charge & Commissions
     C                   PARM                    TranInPrim
     C                   PARM                    TranInSeco
     C                   PARM                    TranInExch
     C                   PARM                    TranInSett
     C                   PARM                    TranInChcm
      * Custom Extra Data file data
     C                   PARM                    ExtData
 
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
      *
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
 
      ** Portfolio Details
     C                   PARM                    PortDts
 
      ** Nominal Currency Details
      ** Settlement Currency Details
     C                   PARM                    NomCcyDts
     C                   PARM                    SetCcyDts
                                                                                              CGL031
      ** CGL031 Switchable Feature                                                            CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      * OUTPUTS
      *
      ** FX Margin Amount
      ** Portfolio exchange rate & M/D ind screen format
     C                   PARM                    DDMAMT           18
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
 
      ** Trade Exchange Rates OK inds
      ** Trade Settlement Instructions OK
      ** Trade Charge & Commissions OK inds
     C                   PARM                    OKTrExch
     C                   PARM                    OKTrSett
     C                   PARM                    OKTrChcm
 
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
 
      * Valid Trade layout (DS) from/to caller
     C                   PARM                    ValidTrad
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                      BUG3145
      *                                                               *                      BUG3145
      * ValdTrAddl - Additional validations                           *                      BUG3145
      *                                                               *                      BUG3145
      *****************************************************************                      BUG3145
     C     ValdTrAddl    BEGSR                                                               BUG3145
                                                                                             BUG3145
     C                   CALLB     'SETRADAVAL'                                              BUG3145
                                                                                             BUG3145
      ** INPUTS                                                                              BUG3145
                                                                                             BUG3145
      ** Action Code                                                                         BUG3145
      ** Nominal Currency                                                                    BUG3145
     C                   PARM                    DDACTN                                      BUG3145
     C                   PARM                    NMCY                                        BUG3145
                                                                                             BUG3145
      ** Valid Trade layout (DS) from/to caller                                              BUG3145
     C                   PARM                    ValidTrad                                   BUG3145
                                                                                             BUG3145
      ** OUTPUTS                                                                             BUG3145
                                                                                             BUG3145
      ** Trade Settlement Instructions OK                                                    BUG3145
     C                   PARM                    OKTrSett                                    BUG3145
                                                                                             BUG3145
      ** Error fields/message IDs/message data (arrays) from/to caller                       BUG3145
     C                   PARM                    FldNameArr                                  BUG3145
     C                   PARM                    MsgIDArr                                    BUG3145
     C                   PARM                    MsgDtaArr                                   BUG3145
                                                                                             BUG3145
      ** Array index (3P0) from/to caller                                                    BUG3145
     C                   PARM                    Idx                                         BUG3145
                                                                                             BUG3145
      ** Warning fields/message IDs/message data (arrays) from/to caller                     BUG3145
     C                   PARM                    WFldNamArr                                  BUG3145
     C                   PARM                    WMsgIDArr                                   BUG3145
     C                   PARM                    WMsgDtaArr                                  BUG3145
                                                                                             BUG3145
      ** Array index (3P0) from/to caller                                                    BUG3145
     C                   PARM                    WIdx                                        BUG3145
                                                                                             BUG3145
     C                   ENDSR                                                               BUG3145
      *****************************************************************                      BUG3145
      /EJECT                                                                                 BUG3145
      *****************************************************************
      *                                                               *
      * DfltTrSwfA - Default Trade Extension (SWIFT) 'A' details      *
      *                                                               *
      *****************************************************************
     C     DfltTrSwfA    BEGSR
 
     C                   CALLB     'SETSWFTDFT'
      *
      ** INPUT PARAMETERS :
      *
      * Screen (A or B)
     C                   PARM      'A'           Screen            1
      *
      * Trade Details (screen)
      *
     C                   PARM                    DDACTN            1
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDSETP            2
     C                   PARM                    DDCLTY2           1
     C                   PARM                    DDPCOD            1
     C                   PARM                    DDPRYC            1
     C                   PARM                    DDBRCD
     C                   PARM                    DDBPBK
     C                   PARM                    DDSETC
     C                   PARM                    DDMRKT
      *
      * Trade Details (file)
     C                   PARM                    V_TDVD
     C                   PARM                    V_TCNR
     C                   PARM                    V_DELF
     C                   PARM                    V_DELT
     C                   PARM                    INVT
      *
      * (CSW003) MT5XX - Phase 2 Message Generation
     C                   PARM                    CSW003
      *
      ** OUTPUT PARAMETERS :
      *
      * Screen A details
     C                   PARM                    TranInSwfA
     C                   PARM                    A_DDROUS          6
     C                   PARM                    A_DDROTS         12
     C                   PARM                    A_DDROUC          6
     C                   PARM                    A_DDROTC         12
      *
      * Screen B details
     C                   PARM                    TranInSwfB
     C                   PARM                    B_DDROUS          6
     C                   PARM                    B_DDROTS         12
     C                   PARM                    B_DDROUC          6
     C                   PARM                    B_DDROTC         12
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrSwfA - Validate Trade Extension (SWIFT) 'A' details     *
      *                                                               *
      *****************************************************************
     C     ValdTrSwfA    BEGSR
 
     C                   EVAL      BeforeIdx = Idx                                          AR639840
     C                   EVAL      BeforeWIdx = WIdx                                        AR639840
     C                   MOVE      'B_ADEVAL_A'  D_Point          10                          245542
     C                   CALLB     'SETRADEVAL'
      *
      ** INPUTS
      *
      * Response mode
     C                   PARM      'S'           RespMode          1
      *
      * Screen (A or B)
     C                   PARM      'A'           Screen            1
      *
      ** Trade Primary Details
      ** Trade Secondary Details
      ** Trade Exchange Rates
      ** Trade Settlement Details
     C                   PARM                    TranInPrim
     C                   PARM                    TranInSeco
     C                   PARM                    TranInExch
     C                   PARM                    TranInSett
      *
      ** Trade Extension File details
     C                   PARM                    TranInSwfA
      * Custom Extra Data file data
     C                   PARM                    ExtData
      *
      ** Previous inds
     C                   PARM                    @ADDGMES
     C                   PARM                    @ADDGMEC
     C                   PARM                    @ADDCCID
     C                   PARM                    A_T1CONG
      *
      ** Processing type
     C                   PARM                    PROT
      *
      ** Override errors
     C                   PARM                    OVRErrors
      *
      * Valid Trade layout (DS) from/to caller
     C                   PARM                    ValidTrad
      * Swift 2001 flag
     C                   PARM                    CSW201
      *
      ** Destination of settlement
     C                   PARM                    A_DDROTS
      *
      ** Process SE1806 flag
     C                   PARM                    PUYAT             1
     C                   PARM                    Tx2AFilFmt
      *
      ** OUTPUTS
      *
      * OK Flags
     C                   PARM                    OKTrSwft
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
      *
      * Valid Trade layout (DS) (Extension file) from/to caller
     C                   PARM                    ValidTX1A
     C                   MOVE      'A_ADEVAL_A'  D_Point          10                          245542
 
     C                   IF        BeforeIdx <> Idx                                         AR639840
     C                   EVAL      StepIdx = BeforeIdx + 1                                  AR639840
     C     StepIdx       DOUGT     Idx                                                      AR639840
     C                   EVAL      FldNameArr(StepIdx) = 'A'                                AR639840
     C                                     + FldNameArr(StepIdx)                            AR639840
     C                   EVAL      StepIdx = StepIdx + 1                                    AR639840
     C                   ENDDO                                                              AR639840
     C                   ENDIF                                                              AR639840
                                                                                            AR639840
     C                   IF        BeforeWIdx <> WIdx                                       AR639840
     C                   EVAL      StepIdx = BeforeWIdx +1                                  AR639840
     C     StepIdx       DOUGT     WIdx                                                     AR639840
     C                   EVAL      WFldNamArr(StepIdx) = 'A'                                AR639840
     C                                     + WFldNamArr(StepIdx)                            AR639840
     C                   EVAL      StepIdx = StepIdx + 1                                    AR639840
     C                   ENDDO                                                              AR639840
     C                   ENDIF                                                              AR639840
                                                                                            AR639840
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * DfltTrSwfB - Default Trade Extension (SWIFT) 'B' details      *
      *                                                               *
      *****************************************************************
     C     DfltTrSwfB    BEGSR
 
     C                   CALLB     'SETSWFTDFT'
      *
      ** INPUT PARAMETERS :
      *
      * Screen (A or B)
     C                   PARM      'B'           Screen            1
      *
      * Trade Details (screen)
      *
     C                   PARM                    DDACTN            1
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDSETP            2
     C                   PARM                    DDCLTY2           1
     C                   PARM                    DDPCOD            1
     C                   PARM                    DDPRYC            1
     C                   PARM                    DDBRCD
     C                   PARM                    DDBPBK
     C                   PARM                    DDSETC
     C                   PARM                    DDMRKT
      *
      * Trade Details (file)
     C                   PARM                    V_TDVD
     C                   PARM                    V_TCNR
     C                   PARM                    V_DELF
     C                   PARM                    V_DELT
     C                   PARM                    INVT
      *
      * (CSW003) MT5XX - Phase 2 Message Generation
     C                   PARM                    CSW003
      *
      ** OUTPUT PARAMETERS :
      *
      * Screen A details
     C                   PARM                    TranInSwfA
     C                   PARM                    A_DDROUS          6
     C                   PARM                    A_DDROTS         12
     C                   PARM                    A_DDROUC          6
     C                   PARM                    A_DDROTC         12
      *
      * Screen B details
     C                   PARM                    TranInSwfB
     C                   PARM                    B_DDROUS          6
     C                   PARM                    B_DDROTS         12
     C                   PARM                    B_DDROUC          6
     C                   PARM                    B_DDROTC         12
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValdTrSwfB - Validate Trade Extension (SWIFT) 'B' details     *
      *                                                               *
      *****************************************************************
     C     ValdTrSwfB    BEGSR
 
     C                   EVAL      BeforeIdx = Idx                                          AR639840
     C                   EVAL      BeforeWIdx = WIdx                                        AR639840
     C                   MOVE      'B_ADEVAL_B'  D_Point          10                          245542
     C                   CALLB     'SETRADEVAL'
      *
      ** INPUTS
      *
      * Response mode
     C                   PARM      'S'           RespMode          1
      *
      * Screen (A or B)
     C                   PARM      'B'           Screen            1
      *
      ** Trade Primary Details
      ** Trade Secondary Details
      ** Trade Exchange Rates
      ** Trade Settlement Details
     C                   PARM                    TranInPrim
     C                   PARM                    TranInSeco
     C                   PARM                    TranInExch
     C                   PARM                    TranInSett
      *
      ** Trade Extension File details
     C                   PARM                    TranInSwfB
      * Custom Extra Data file data
     C                   PARM                    ExtData
      *
      ** Previous inds
     C                   PARM                    @BDDGMES
     C                   PARM                    @BDDGMEC
     C                   PARM                    @BDDCCID
     C                   PARM                    B_T1CONG
      *
      ** Processing type
     C                   PARM                    PROT
      *
      ** Override errors
     C                   PARM                    OVRErrors         1
      *
      * Valid Trade layout (DS) from/to caller
     C                   PARM                    ValidTrad
      * Swift 2001 flag
     C                   PARM                    CSW201
      *
      ** Destination of settlement
     C                   PARM                    B_DDROTS
      *
      ** Process SE1806 flag
     C                   PARM                    PUYAT             1
     C                   PARM                    Tx2BFilFmt
      *
      ** OUTPUTS
      *
      * OK Flags
     C                   PARM                    OKTrSwft
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
      *
      * Valid Trade layout (DS) (Extension file) from/to caller
     C                   PARM                    ValidTX1B
     C                   MOVE      'A_ADEVAL_B'  D_Point          10                          245542
 
     C                   IF        BeforeIdx <> Idx                                         AR639840
     C                   EVAL      StepIdx = BeforeIdx + 1                                  AR639840
     C     StepIdx       DOUGT     Idx                                                      AR639840
     C                   EVAL      FldNameArr(StepIdx) = 'A'                                AR639840
     C                                     + FldNameArr(StepIdx)                            AR639840
     C                   EVAL      StepIdx = StepIdx + 1                                    AR639840
     C                   ENDDO                                                              AR639840
     C                   ENDIF                                                              AR639840
                                                                                            AR639840
     C                   IF        BeforeWIdx <> WIdx                                       AR639840
     C                   EVAL      StepIdx = BeforeWIdx +1                                  AR639840
     C     StepIdx       DOUGT     WIdx                                                     AR639840
     C                   EVAL      WFldNamArr(StepIdx) = 'A'                                AR639840
     C                                     + WFldNamArr(StepIdx)                            AR639840
     C                   EVAL      StepIdx = StepIdx + 1                                    AR639840
     C                   ENDDO                                                              AR639840
     C                   ENDIF                                                              AR639840
                                                                                            AR639840
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  247873
      *****************************************************************                       247873
      *                                                               *                       247873
      *  SR1100 - Determine Network and Addresses.                    *                       247873
      *                                                               *                       247873
      *****************************************************************                       247873
     C     SR1100        BEGSR                                                                247873
      *                                                                                       247873
     C                   CALL      'ZM1100'                             99                    247873
     C                   PARM                    WSNDR             6                          247873
     C                   PARM      *Blanks       WSCSD            12                          247873
     C                   PARM                    WDEST             6                          247873
     C                   PARM                    WSETP             2                          247873
     C                   PARM      *Blanks       WNWSN            20                          247873
     C                   PARM      *Blanks       WNWDS            22                          247873
     C                   PARM      *Blanks       WNWRK             6                          247873
     C                   PARM      *Blanks       WERRC             1                          247873
     C                   PARM      *Blanks       WSRNM            20                          247873
     C                   PARM      *Blanks       WSRTN            10                          247873
     C                   PARM      *Blanks       WDRNM            20                          247873
     C                   PARM      *Blanks       WDRTN            10                          247873
      *                                                                                       247873
     C     WSNDR         IFNE      *Blanks                                                    247873
     C     WDEST         ANDNE     *Blanks                                                    247873
      *                                                                                       247873
     C     *IN99         IFEQ      '1'                                                        247873
     C     WERRC         OREQ      'S'                                                        247873
     C     WERRC         OREQ      'D'                                                        247873
     C     WNWRK         OREQ      'UNROUT'                                                   247873
      *                                                                                       247873
     C                   MOVEL     *Blanks       WWROU             6                          247873
     C                   MOVEL     '  UNRO'      WWROT            12                          247873
     C                   MOVE      'UTABLE'      WWROT                                        247873
     C                   ELSE                                                                 247873
      *                                                                                       247873
     C                   MOVEL     WNWRK         WWROU                                        247873
     C                   MOVEA     WNWDS         ROU                                          247873
     C                   Z-ADD     1             J                 2 0                        247873
     C     ' '           LOOKUP    ROU(J)                                 99                  247873
     C     *IN99         IFEQ      '0'                                                        247873
     C                   MOVEL     WNWDS         WWROT                                        247873
     C                   ELSE                                                                 247873
     C     14            SUB       J             K                 2 0                        247873
     C                   MOVEA     *ALL' '       ROU                                          247873
     C                   MOVEA     WNWDS         ROU(K)                                       247873
     C                   MOVEA     ROU           WWROT                                        247873
     C                   ENDIF                                                                247873
     C                   ENDIF                                                                247873
      *                                                                                       247873
     C                   ELSE                                                                 247873
      *                                                                                       247873
     C                   MOVEL     *Blanks       WWROU                                        247873
     C                   MOVEL     *Blanks       WWROT                                        247873
      *                                                                                       247873
     C                   ENDIF                                                                247873
      *                                                                                       247873
     C                   ENDSR                                                                247873
      *****************************************************************                       247873
      /EJECT                                                                                  CAP087
      *****************************************************************                       CAP087
      * CalcDays - Calculate Days in a Year                                                   CAP087
      *****************************************************************                       CAP087
     C     CalcDays      BEGSR                                                                CAP087
                                                                                              CAP087
      ** For non-interest bearing securities, some of the parameters for                      CAP087
      ** ZDYYR are unknown.  In this case, set Divisor Basis to '3' and                       CAP087
      ** Next Coupon Date to the Value Date of the Buy-Sell Back.                             CAP087
     C                   IF        PROT = '2' or PROT = '4' or PROT = '7'                     CAP087
     C                   EVAL      DVBS = '3'                                                 CAP087
     C                   EVAL      NCD = V_TDVD                                               CAP087
     C                   ENDIF                                                                CAP087
                                                                                              CAP087
     C                   CALLB     'ZDYYR'                                                    CAP087
     C                   PARM                    DYBS                                         CAP087
     C                   PARM                    DVBS                                         CAP087
     C                   PARM                    ISSD                                         CAP087
     C                   PARM                    ITLD                                         CAP087
     C                   PARM                    LCPN                                         CAP087
     C                   PARM                    FCPN                                         CAP087
     C                   PARM                    MATY                                         CAP087
     C                   PARM                    IADJ                                         CAP087
     C                   PARM                    CDArr                                        CAP087
     C                   PARM                    CRArr                                        CAP087
     C                   PARM                    CPNR                                         CAP087
     C                   PARM                    DADJN             1                          CAP087
     C                   PARM                    NCD               5 0                        CAP087
     C                   PARM                    ECD               5 0                        CAP087
     C                   PARM                    BJDFIN                                       CAP087
                                                                                             BUG9961
      ** Holiday Currencies                                                                  BUG9961
                                                                                             BUG9961
     C                   PARM                    HCY1              3                         BUG9961
     C                   PARM                    HCY2              3                         BUG9961
     C                   PARM                    HCY3              3                         BUG9961
     C                   PARM                    HCY4              3                         BUG9961
     C                   PARM                    HCY5              3                         BUG9961
     C                   PARM                    HCY6              3                         BUG9961
     C                   PARM                    HCY7              3                         BUG9961
     C                   PARM                    HCY8              3                         BUG9961
     C                   PARM                    HCY9              3                         BUG9961
     C                   PARM      *Zeros        ZINTDD            5 0                        CAP087
     C                   PARM                    LCDD5             5 0                        CAP087
                                                                                              CAP087
     C                   Z-ADD     ZINTDD        DaysInYear                                   CAP087
     C                   MOVE      DaysInYear    Out_DaysYear                                 CAP087
                                                                                              CAP087
     C                   Z-ADD     V_TCSR        Trade_Value                                  CAP087
     C                   MOVE      *BLANKS       ZFIELD                                       CAP087
     C                   MOVE      Trade_Value   ZFIELD                                       CAP087
     C                   Z-ADD     NomCcyDec     ZADEC                                        CAP087
     C                   CALLB     'ZEDIT'                                                    CAP087
     C                   PARM                    ZFIELD           16                          CAP087
     C                   PARM                    ZADEC             1 0                        CAP087
     C                   MOVE      ZFIELD        Out_Value                                    CAP087
                                                                                              CAP087
     C                   ENDSR                                                                CAP087
      *****************************************************************                       CAP087
      /EJECT
      *****************************************************************                     BUG11194
      *                                                               *                     BUG11194
      *  SRIntCal  - Force Interest Recalculation                     *                     BUG11194
      *                                                               *                     BUG11194
      *****************************************************************                     BUG11194
                                                                                            BUG11194
     C     SRIntCal      BEGSR                                                              BUG11194
                                                                                            BUG11194
     C                   If        DDNOML <> DDNOM1  OR                                     BUG11194
     C                             DDTDVD <> DDTDV1  OR                                     BUG11194
     C                             DDACIN <> DDACI1  OR                                     BUG11194
     C                             DDDADJ <> DDDAD1  OR                                     BUG11194
     C                             DDACTD <> DDACT1                                         BUG11194
     C                   If        DDITRA =  DDITR1                                         BUG11194
     C                   Eval      DDITRA = *Blanks                                         BUG11194
     C                   Endif                                                              BUG11194
     C                   Endif                                                              BUG11194
                                                                                            BUG11194
     C                   ENDSR                                                              BUG11194
      *****************************************************************                     BUG11194
      *                                                               *                     BUG11194
      *  SavePrevEnt - Save Previous Entries for Interest Recal-      *                     BUG11194
      *                 culation                                      *                     BUG11194
      *                                                               *                     BUG11194
      *****************************************************************                     BUG11194
                                                                                            BUG11194
     C     SavePrevEnt   BEGSR                                                              BUG11194
                                                                                            BUG11194
     C                   Eval      DDNOM1 = DDNOML                                          BUG11194
     C                   Eval      DDTDV1 = DDTDVD                                          BUG11194
     C                   Eval      DDACI1 = DDACIN                                          BUG11194
     C                   Eval      DDDAD1 = DDDADJ                                          BUG11194
     C                   Eval      DDACT1 = DDACTD                                          BUG11194
     C                   Eval      DDITR1 = DDITRA                                          BUG11194
                                                                                            BUG11194
     C                   ENDSR                                                              BUG11194
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
     C                   PARM                    Trans5001
     C                   PARM                    Trans5002
     C                   PARM                    Trans5002B                                 BUG11194
     C                   PARM                    Trans5003
     C                   PARM                    Trans5004
     C                   PARM                    Trans5005
     C                   PARM                    Trans5006
     C                   PARM                    Trans5007
     C                   PARM                    Trans5008
     C**********         PARM                    OthDData4755                                CSF011A
     C                   PARM                    OthrData                                    CSF011A
     C                   PARM                    OthData500                                  BUG9089
     C**********         PARM                    InfData500                                 BUG10202
     C                   PARM                    RegData500                                   CER001
     C                   PARM                    ExtData500
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    UpdateYN          1
     C                   PARM                    Buffer         6000
     C                   PARM                    Buffer2        3999                         CSF011A
     C                   PARM                    APIRetc           1
     C                   PARM                    @TimeStamp       26                         BUG1569
     C                   PARM                    TransQ                                       CER049
     C                   PARM                    AAuth             1                        BUG22232
     C                   PARM                    DDFRNT                                    AR698195B
 
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'SEUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'MEMSG'                                   AR589197
 
      * Initialize ECD                                                                        246736
     C                   Z-ADD     0             ECD                                          246736
                                                                                              246736
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,SETRADM01
      *
      * Access bank details via access program
      * (database error handling done in access program)
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Access API ICD via access program
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Access midas modules details to determine if strategic
      ** risk management indicator is on.
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Database error.
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   Z-ADD     2             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access API ICD details.
      *
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Database error.
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDAPIPD'
     C                   Z-ADD     3             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR details file to determine if MT5XX Message
      ** Generation enhancement phase 2 is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW003'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CSW003
     C                   ELSE
     C                   MOVEL     'N'           CSW003
     C                   END
      *
      ** Access SAR details file to determine if CEU005
      ** (EMU SE Settlement Currency Conversion) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU005
     C                   ELSE
     C                   MOVEL     'N'           CEU005
     C                   END
      *
      ** Access SAR file to determine if CSE011
      ** (duplicate security code check) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSE011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C                   EVAL      DBKEY = 'CSE011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     7             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSE011 = 'Y'
     C                   ELSE
     C                   EVAL      CSE011 = 'N'
     C                   ENDIF
      *                                                                                     BUG10085
      ** Access SAR file to determine if CSE022                                             BUG10085
      ** is installed.                                                                      BUG10085
      *                                                                                     BUG10085
     C                   CALLB     'AOSARDR0'                                               BUG10085
     C                   PARM      *BLANKS       PRTCD                                      BUG10085
     C                   PARM      '*VERIFY'     POPTN                                      BUG10085
     C                   PARM      'CSE022'      PSARD                                      BUG10085
     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG10085
      *                                                                                     BUG10085
     C                   IF        PRTCD = *BLANKS                                          BUG10085
     C                   EVAL      CSE022 = 'Y'                                             BUG10085
     C                   EVAL      PGMNAM = 'SEDORFRTV'                                       238825
     C                   ELSE                                                               BUG10085
     C                   EVAL      CSE022 = 'N'                                             BUG10085
     C                   ENDIF                                                              BUG10085
      *
      ** Access SAR file to determine if S01401
      ** (MT5xx message generation) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01401'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRTCD <> *BLANKS AND
     C                             PRTCD <> '*NRF   '
     C                   EVAL      DBKEY = 'S01401'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     8             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      S01401 = 'Y'
     C                   ELSE
     C                   EVAL      S01401 = 'N'
     C                   ENDIF
 
      ** Access SAR details file to determine if
      ** Automatic Authorisation (SE Part) is installed
      *
     C                   MOVEL     'N'           CAP051
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAP051'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CAP051
     C                   ENDIF
      *
      ** Check to see if switchable feature CSW098 is on or if date is
      ** greater than 16 October 1998.
      *
     C                   CALL      'SWIFT98'                            99
     C                   PARM                    SWRTN
 
 
      ** Check if CSC011 is installed
 
     C                   EVAL      WkDate = BJRDNB
     C                   EVAL      WkNext = BJDNWD
     C                   EVAL      CSC011 = 'N'
     C                   CALLB     'AOSARDR0'
     C                   PARM      *Blanks       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD = *Blanks
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   IN        SDSTAT
     C                   IF        S1SUPP = LIBR
     C                   EVAL      WkDate = S1DATE
     C                   EVAL      WkNext = S1NEXT
     C                   ENDIF
     C                   ELSE
     C                   IF        PRTCD <> '*NRF   '
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY  = 'CSC011'
     C                   EVAL      DBASE  = 13
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
      ** Check if CSW201 - Swift 2001 Standards Update is installed
 
     C                   CALL      'SWIF2001'                           9090
     C                   PARM      *BLANKS       @RTCD
 
     C                   IF        *IN90 = *OFF AND @RTCD = 'CSW2001'
     C                   EVAL      CSW201 = 'Y'
     C                   ELSE
     C                   EVAL      CSW201 = 'N'
     C                   ENDIF
                                                                                             CSW206E
     C                   CALL      'SWIF2006'                                                CSW206E
     C                   PARM      *BLANKS       PRTCD                                       CSW206E
                                                                                             CSW206E
     C                   IF        PRTCD = 'CSW2006'                                         CSW206E
     C                   EVAL      CSW206 = 'Y'                                              CSW206E
     C                   ELSE                                                                CSW206E
     C                   EVAL      CSW206 = 'N'                                              CSW206E
     C                   ENDIF                                                               CSW206E
      *
      ** Check if CSE028 feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSE028'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CSE028
     C                   ELSE
     C                   MOVEL     'N'           CSE028
     C                   ENDIF
 
      ** Check if enhancement CAS006 (Hedge Accounting Phase B) is installed
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CAS006'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CAS006 = 'Y'
     C                   ELSE
     C                   EVAL      CAS006 = 'N'
     C                   ENDIF
 
      *
      ** Retrieve ICD for securities trading.
     C                   CALLB     'AOSTRDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** Database error.
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDSTRDPD'
     C                   Z-ADD     11            DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Generate a timestamp for this transaction
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    WTimeStamp
     C                   MOVE      WTimeStamp    WorkTime
 
      **********                                                                             BUG7029
      ***Retrieve*ZMUSER*details.                                                            BUG7029
      **********                                                                             BUG7029
     C******DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C**********         IN        ZMUSER                                                    BUG7029
 
      ** Set Front Office ID = User ID
     C**********         EVAL      APFOTranID = %SUBST(PUSRID:1:3) +                          249422
     C**********                                %SUBST(WorkTime:3:17)                         249422
      ** Front Office ID                                                                   AR698195B
     C                   EVAL      APFOTranID = DDFRNT                                     AR698195B
      *                                                                                       CSC022
      ** Access Switchable Features File, for CSC022                                          CSC022
      *                                                                                       CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RtCd                                        CSC022
     C                   Parm      '*VERIFY'     @Optn                                        CSC022
     C                   Parm      'CSC022'      @Sard             6                          CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
     C                   If        @RtCd = *Blanks                                            CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   Eval      WCommitSkip = 'N'                                          CSC022
      *                                                                                       CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
     C                   MoveA     ComitJob      WCmtJobArr                                   CSC022
      *                                                                                       CSC022
     C     PSJOBNAME     LOOKUP    WCmtJobArr                             87                  CSC022
     C                   If        *IN87 = *ON                                                CSC022
     C                   Eval      WCommitSkip = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   Else                                                                 CSC022
      *                                                                                       CSC022
      ** If return code <> *NRF, call program exception error routine                         CSC022
      *                                                                                       CSC022
     C                   If        @RtCd <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 914                                                CSC022
     C                   OUT       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       238825
      ** Access SAR file to determine if CSE022 is installed                                  238825
      *                                                                                       238825
     C                   CALLB     'AOSARDR0'                                                 238825
     C                   PARM      *BLANKS       @RTCD                                        238825
     C                   PARM      '*VERIFY'     @OPTN                                        238825
     C                   PARM      'CSE022'      @SARD                                        238825
     C     SCSARD        PARM      SCSARD        DSFDY                                        238825
                                                                                              238825
     C                   IF        @RTCD = *BLANK                                             238825
     C                   EVAL      CSE022 = 'Y'                                               238825
     C                   EVAL      PGMNAM = 'SEDORFRTV'                                       238825
     C                   ELSE                                                                 238825
     C                   EVAL      CSE022 = 'N'                                               238825
     C                   ENDIF                                                                238825
      *                                                                                       238825
      *                                                                                       CER001
      ** Retrieve the status of ULX008                                                        CER001
      *                                                                                       CER001
     C                   MOVE      'N'           ULX008                                       CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RtCd                                        CER001
     C                   PARM      '*VERIFY'     @Optn                                        CER001
     C                   PARM      'ULX008'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RtCd = *Blanks                                            CER001
     C                   MOVE      'Y'           ULX008                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Retrieve the status of ULX603                                                        CER001
      *                                                                                       CER001
     C                   MOVE      'N'           ULX603                                       CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RtCd                                        CER001
     C                   PARM      '*VERIFY'     @Optn                                        CER001
     C                   PARM      'ULX603'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RtCd = *Blanks                                            CER001
     C                   MOVE      'Y'           ULX603                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        @RtCd <> *Blanks AND                                       CER001
     C                             @RtCd <> '*NRF   '                                         CER001
     C                   EVAL      DBKEY = 'ULX603'                                           CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   Z-ADD     10            DBASE                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CSC022
      ** Check if enhancement CGL014 (Collaterals Processing) is on                          BUG3145
                                                                                             BUG3145
     C                   CALLB     'AOSARDR0'                                                BUG3145
     C                   PARM      *BLANKS       PRTCD                                       BUG3145
     C                   PARM      '*VERIFY'     POPTN                                       BUG3145
     C                   PARM      'CGL014'      PSARD                                       BUG3145
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3145
                                                                                             BUG3145
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                 BUG3145
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG3145
     C                   EVAL      DBKEY  = 'CGL014'                                         BUG3145
     C                   EVAL      DBASE  = 912                                              BUG3145
     C                   EXSR      *PSSR                                                     BUG3145
     C                   ENDIF                                                               BUG3145
                                                                                             BUG3145
     C                   IF        PRTCD = *BLANKS                                           BUG3145
     C                   EVAL      CGL014 = 'Y'                                              BUG3145
     C                   ELSE                                                                BUG3145
     C                   EVAL      CGL014 = 'N'                                              BUG3145
     C                   ENDIF                                                               BUG3145
                                                                                             BUG3145
      ** Check if CGL031 is enabled.                                                          CGL031
                                                                                              CGL031
     C                   CALLB     'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRtCd                                        CGL031
     C                   PARM      '*VERIFY'     POptn                                        CGL031
     C                   PARM      'CGL031'      PSARD                                        CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
                                                                                              CGL031
     C                   EVAL      CGL031 = 'N'                                               CGL031
                                                                                              CGL031
     C                   IF        PRtCd = *BLANKS                                            CGL031
     C                   EVAL      CGL031 = 'Y'                                               CGL031
     C                   ELSE                                                                 CGL031
                                                                                              CGL031
     C                   IF        PRtCd <> '*NRF   '                                         CGL031
     C     *LOCK         IN        LDA                                                        CGL031
     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL031
     C                   EVAL      DBKey = PSARD                                              CGL031
     C                   EVAL      DBase = 101                                                CGL031
     C                   OUT       LDA                                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   ENDIF                                                                CGL031
      *                                                                                       CSW210
      ** Check to see if switchable feature CSW210 is on or if date is                        CSW210
      ** equal or greater than 20 November 2010.                                              CSW210
      *                                                                                       CSW210
     C                   CALL      'SWIF2010'                                                 CSW210
     C                   PARM      *BLANKS       PRTCD                                        CSW210
                                                                                              CSW210
     C                   IF        PRTCD = 'CSW2010'                                          CSW210
     C                   EVAL      CSW210 = 'Y'                                               CSW210
     C                   ELSE                                                                 CSW210
     C                   EVAL      CSW210 = 'N'                                               CSW210
     C                   ENDIF                                                                CSW210
      *                                                                                       CSW210
      ** Check to see if switchable feature CFT004 in on.                                     CSW210
      *                                                                                       CSW210
     C                   CALLB     'AOSARDR0'                                                 CSW210
     C                   PARM      *BLANKS       PRtCd                                        CSW210
     C                   PARM      '*VERIFY'     POptn                                        CSW210
     C                   PARM      'CFT004'      PSARD                                        CSW210
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSW210
                                                                                              CSW210
     C                   EVAL      CFT004 = 'N'                                               CSW210
                                                                                              CSW210
     C                   IF        PRtCd = *BLANKS                                            CSW210
     C                   EVAL      CFT004 = 'Y'                                               CSW210
     C                   ELSE                                                                 CSW210
                                                                                              CSW210
     C                   IF        PRtCd <> '*NRF   '                                         CSW210
     C     *LOCK         IN        LDA                                                        CSW210
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSW210
     C                   EVAL      DBKey = PSARD                                              CSW210
     C                   EVAL      DBase = 102                                                CSW210
     C                   OUT       LDA                                                        CSW210
     C                   EXSR      *PSSR                                                      CSW210
     C                   ENDIF                                                                CSW210
                                                                                              CSW210
     C                   ENDIF                                                                CSW210
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *              valid file record.                               *
      *                                                               *
      *****************************************************************
 
     C     SETUPVALID    BEGSR
 
      * For Deletes & Authorises, put the complete (pre-existing) trade
      *  into the Valid file record
     C                   IF           DDACTN = 'D'
     C                             OR DDACTN = 'P'
     C                             OR DDACTN = 'Y'
     C                   MOVE      TradFilFmt    ValidTrad
     C                   MOVE      TX1AFilFmt    ValidTX1A
     C                   MOVE      TX1BFilFmt    ValidTX1B
     C                   ENDIF
 
     C                   IF        DDACTN = 'I'
     C                   EXSR      SETUPTRADR
     C                   ENDIF
 
      * Set Valid file field(s) that are needed for all Action Codes
     C                   EVAL      V_CHTP = DDACTN
 
      * Do not override header fields from existing transaction.                              244537
     C**********         IF        DDACTN = 'I'                                     244537 AR971184A
     C                   IF        APFOTranID <> *BLANKS                                   AR971184A
                                                                                              244537
      * Include Header fields that need to be o/p to the Valid file
     C                   EVAL      V_FRNT = APFOTranID
     C                   EVAL      V_AFRT = APFOAsocID
     C                   EVAL      V_REPA = APRprLocn
                                                                                              244537
     C                   ENDIF                                                                244537
 
      * Automatic Authorisation flag
     C                   IF        CAP051 = 'Y'
     C                   EVAL      V_AUTH = AUTHA
     C                   ENDIF
 
     C                   EVAL      TranStatus = 'S'
                                                                                             BUG1569
      * Restore Timestamp from the original record                                           BUG1569
     C                   IF        DDACTN <> 'I'                                             BUG1569
     C                             AND @TimeStamp <> *BLANKS                                 BUG4728
     C                   MOVEL     @TimeStamp    V_TMST                                      BUG1569
     C                   ENDIF                                                               BUG1569
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SETUPTRADR - Set up Trade Reference for Inserts               *
      *                                                               *
      *****************************************************************
     C     SETUPTRADR    BEGSR
 
     C                   IF           DDTDRF = *blanks
     C                             OR DDTDRF = *zeros
 
     C                   RESET                   ReturnCode
     C                   CALLB     'ZATRNRTV'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM      'SE'          MODU              2
     C                   PARM      'T'           TRTY              1
     C                   PARM                    DDTDRF
     C                   PARM      *ZERO         V_TDRF
 
     C     ReturnCode    IFNE      *BLANK
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDTDRF'
     C                   EVAL      MsgIDArr(Idx) = 'ZATRNRTV'
     C                   ENDIF
 
      ** If trade reference was entered, put it in the file field
     C                   ELSE
     C                   MOVE      DDTDRF        V_TDRF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * UPDATEDB - Update database                                    *
      *                                                               *
      *****************************************************************
 
     C     UPDATEDB      BEGSR
      *
      * Update
     C                   RESET                   UpdRtnCode
     C                   EVAL      PMODE = 'UPC'
 
     C                   CALLB     'SETRADUPD'
     C                   PARM                    UpdRtnCode
     C                   PARM                    ValidTrad
     C                   PARM                    ValidTx1A
     C                   PARM                    ValidTx1B
     C                   PARM                    S01401
     C                   PARM                    CSW003
     C                   PARM                    CAP051
     C                   PARM                    CAS006
     C                   PARM                    CGL031                                       CGL031
     C                   PARM                    PMODE
     C                   PARM                    PMCWL
     C                   PARM                    ValidTx2A
     C                   PARM                    ValidTx2B
 
      *
      * If there were any errors in the update functions, rollback any
      * updates (done in *PSSR) and end this program. Otherwise commit.
     C     UpdRtnCode    IFNE      *BLANK
     C     UpdRtnCode    ANDNE     '*RECUPD'
     C                   MOVEL     '0'           APIRetc
     C                   EXSR      *PSSR
     C                   ELSE
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   EndIf
      *
      * If update not done due to record being updated by another
      * workstation send message to screen.
 
     C     UpdRtnCode    IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
 
     C                   MOVEL     'SEW3004'     MsgIdArr(1)
 
     C                   EndIf
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * The following /COPY contains the standard program status
      * subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2003
