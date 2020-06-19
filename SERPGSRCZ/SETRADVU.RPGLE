000100200529     H DEBUG
000200200529     H COPYRIGHT('(c) Finastra International Limited 2003')
000300200529      *****************************************************************
000400200529/*STD *  RPGBASEMOD                                                   *
000500200529/*EXI *  TEXT('Midas SE Securities trade - interface controller')     *
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *  Midas - Securities Trading Module                            *
000900200529      *                                                               *
001000200529      *  SETRADVU - SE Securities Trades - validate and update        *
001100200529      *                                                               *
001200200529      *  Function: This program validates securities details for      *
001300200529      *            input into the Midas database.                     *
001400200529      *            The action code determines which processes are     *
001500200529      *            executed as follows:                               *
001600200529      *            - For I (=Insert) or A (=Amend)                    *
001700200529      *              - Validate the transaction details fields        *
001800200529      *            - For A (=AMEND),                                  *
001900200529      *              - if transaction is a partial amendment, call a  *
002000200529      *                separate function to complete the transaction  *
002100200529      *                details.                                       *
002200200529      *              - if transaction is valid, call a separate       *
002300200529      *                function to check whether it is a valid        *
002400200529      *                amendment.                                     *
002500200529      *            - For D (=DELETE), call a separate function to     *
002600200529      *              process the transaction and bypass the rest of   *
002700200529      *              the validation.                                  *
002800200529      *                                                               *
002900200529      *            For all action codes, the decision to as to        *
003000200529      *            whether to write to the valid or invalid file and  *
003100200529      *            the call to the message handler will take place    *
003200200529      *            in this module                                     *
003300200529      *                                                               *
003400200529      *  (c) Finastra International Limited 2003                      *
003500200529      *                                                               *
003600200604      *  Last Amend No. 258901             Date 22May20               *
003700200604      *  Prev Amend No. 247907             Date 22May20               *
003800200604      *                 257524             Date 22May20               *
003900200604      *                 CSD102             Date 08Jan19               *
004000200529      *                 MD049746           Date 15Mar18               *
004100200529      *                 MD046248           Date 27Oct17               *
004200200529      *                 MD035243           Date 29Jul15               *
004300200529      *                 AR596191           Date 19Aug14               *
004400200529      *                 AR971184A          Date 22Jun12               *
004500200529      *                 AR971184           Date 28May12               *
004600200529      *                 CSF011A            Date 28Nov11               *
004700200529      *                 CSF011             Date 12Sep11               *
004800200529      *                 CER049             Date 06Dec10               *
004900200529      *                 AR698195B          Date 20Jan11               *
005000200529      *                 AR639840           Date 09Sep10               *
005100200529      *                 AR638989           Date 08Sep10               *
005200200529      *                 AR589197           Date 11Aug10               *
005300200529      *                 CSW210             Date 04May10               *
005400200529      *                 CER059             Date 19Jul10               *
005500200529      *                 CER054             Date 07Apr09               *
005600200529      *                 BUG22911           Date 17Feb09               *
005700200529      *                 CER048             Date 19May08               *
005800200529      *                 BUG27876           Date 06Jul10               *
005900200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
006000200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
006100200529      *                 BUG22232           Date 16Jan09               *
006200200529      *                 256564             Date 17Sep08               *
006300200529      *                 BUG21092           Date 23Sep08               *
006400200529      *                 BUG18525           Date 07May08               *
006500200529      *                 249422             Date 28Jul07               *
006600200529      *                 247873             Date 15Jun07               *
006700200529      *                 247451             Date 16May07               *
006800200529      *                 246736             Date 28Mar07               *
006900200529      *                 BUG14806A          Date 14Sep07               *
007000200529      * Midas Plus 1.4 Base ------------------------------------------*
007100200529      *                 245542             Date 11Feb07               *
007200200529      *                 244537             Date 17Aug05               *
007300200529      * Midas Plus 1.3 ----------- Base ------------------------------*
007400200529      *                 BUG12874           Date 12Dec06               *
007500200529      *                 BUG12579           Date 21Nov06               *
007600200529      *                 CSW206E            Date 24Aug06               *
007700200529      *                 BUG8690R (Reopen)  Date 09Jun06               *
007800200529      *                 238825 (Reopen)    Date 06Jun06               *
007900200529      *                 BUG11622           Date 27Jun06               *
008000200529      *                 BUG11529           Date 22Jun06               *
008100200529      *                 CSD031             Date 10Apr06               *
008200200529      *                 238825             Date 21Apr06               *
008300200529      *                 238859             Date 21Apr06               *
008400200529      *                 BUG11213           Date 18Apr06               *
008500200529      *                 CSD027A            Date 05May06               *
008600200529      *                 BUG11197           Date 25Apr06               *
008700200529      *                 BUG11194           Date 24Apr06               *
008800200529      *                 BUG10476           Date 15Feb06               *
008900200529      *                 BUG10085           Date 15Mar06               *
009000200529      *                 BUG10041           Date 08Feb06               *
009100200529      *                 BUG10202           Date 29Jan06               *
009200200529      *                 BUG10021           Date 23Jan06               *
009300200529      *                 BUG9961            Date 19Jan06               *
009400200529      *                 BUG9917            Date 17Jan06               *
009500200529      *                 CAP087             Date 17Aug05               *
009600200529      *                 BUG9089            Date 25Apr05               *
009700200529      *                 CER001             Date 25Apr05               *
009800200529      *                 CSE075             Date 17Nov05               *
009900200529      *                 BUG8087            Date 03Aug05               *
010000200529      *                 BUG8039            Date 02Aug05               *
010100200529      *                 237063             Date 20Nov05               *
010200200529      *                 BUG8119            Date 20Oct05               *
010300200529      *                 CGL031             Date 05Jul04               *
010400200529      *                 CSE065             Date 08Nov04               *
010500200529      *                 CSE071             Date 19Jul05               *
010600200529      *                 BUG8690            Date 14Nov05               *
010700200529      *                 BUG7029            Date 09Jun05               *
010800200529      *                 BUG6496            Date 24Apr05               *
010900200529      *                 BUG5557            Date 26Jan05               *
011000200529      *                 BUG5230            Date 13Dec04               *
011100200529      *                 BUG4728            Date 05Nov04               *
011200200529      *                 BUG4482            Date 29Sep04               *
011300200529      *                 BUG4070            Date 24Aug04               *
011400200529      *                 BUG2274            Date 19Aug04               *
011500200529      *                 BUG3950            Date 10Aug04               *
011600200529      *                 BUG3122            Date 17Jul04               *
011700200529      *                 BUG3145            Date 15Jun04               *
011800200529      *                 MLFIX1             Date 26May04               *
011900200529      *                 CGL014             Date 20Oct03               *
012000200529      *                 CLE025             Date 20Oct03               *
012100200529      *                 TDA035             Date 02Apr04               *
012200200529      *                 CSC022             Date 24Feb04               *
012300200529      *                 BUG1569            Date 17Mar04               *
012400200529      *                 225421  (BUG1356)  Date 04Mar04               *
012500200529      *                 CGL029             Date 01Sep03               *
012600200529      *                 CAP084  *CREATE    Date 14Jul03               *
012700200529      *                                                               *
012800200529      *---------------------------------------------------------------*
012900200529      *  247524 - Securities Trades - charges are not defaulted and   *
013000200529      *           not calculated.                                     *
013100200529      *  258901 - Error in tax amount for charges and commissions.    *
013200200529      *  247907 - Wrong settlement amount for trades with the same    *
013300200529      *           nominal and settlement currency.                    *
013400200529
013500200529      *  CSD102 - Password Length Extension (Recompile)               *
013600200529      *  MD049746 - Settlement details is not defaulted when Charges/ *
013700200529      *             Commission fields have values when Trade is       *
013800200529      *             inserted via API                                  *
013900200529      *  MD046248 - Finastra Rebranding                               *
014000200529      *  MD035243 - Error message for Account with Institution        *
014100200529      *             Account is not properly displayed                 *
014200200529      *  AR596191 - Error on Safekeeping Account is issued even if    *
014300200529      *             a valid value is inserted                         *
014400200529      *  AR971184A- During Amend Front Ofc Id must be updated with the*
014500200529      *             new one                                           *
014600200529      *  AR971184 - For some JMS APIs (CUSD, AMAD, DPMV, OPAY), Front *
014700200529      *             Office Id is no more updated in master database   *
014800200529      *             files which provokes some big problems in third   *
014900200529      *             party product such as TOF.(Child:AR971185)        *
015000200529      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
015100200529      *          - Some codes of CSF011 will be physically deleted    *
015200200529      *  CSF011 - Customer Name on Inputs                             *
015300200529      *  CER049 - Stamp Tax                                           *
015400200529      *  AR698195B - Added Front Office field on the buffer for TRADS *
015500200529      *             (Child: AR698196)                                 *
015600200529      *  AR639840 - Safekeeping Account is being blanked-out          *
015700200529      *  AR638989 - Beneficiary of Money account should be            *
015800200529      *             highlighted in blue                               *
015900200529      *  AR589197 - The input validation of //xx has been removed if  *
016000200529      *             ISO15022 is switched on, it should be reapplied   *
016100200529      *             as the code is still used                         *
016200200529      *  CSW210 - SWIFT 2010 Changes                                  *
016300200529      *  CER059 - German Feature Upgrade to Delhi                     *
016400200529      *  CER054 - German Features - Church Tax (Recompile)            *
016500200529      *  BUG22911 - Changes for Correct Tax Calculation (Recompile)   *
016600200529      *  CER048 - German Features - Taxes (Recompile)                 *
016700200529      *  BUG27876 - Serious midas error upon clicking settlement tab  *
016800200529      *  BUG22232 - Missing authorization field in repository.        *
016900200529      *  256564 - Recompile due to PF changes done by fix 256330      *
017000200529      *  BUG21092 - Missing SWIFT Identifier in Destination of        *
017100200529      *             Confirmation field.                               *
017200200529      *  BUG18525 - Redefault Trade Extension (SWIFT) A details if    *
017300200529      *             blank and action code is insert.                  *
017400200529      *  249422 - Front Office ID should be blank.                    *
017500200529      *  247873 - Re-default Destination of Settlements based on new  *
017600200529      *           Deliver To/From when trade is edited.               *
017700200529      *  247451 - Pass Customer Number not Shortname to SETSESDFT and *
017800200529      *           SEDORFRTV to prevent dumps later.                   *
017900200529      *  246736 - Initialise ECD.                                     *
018000200529      *  BUG14806A - Recompile Program due to Decimal Error           *
018100200529      *  245542 - Do not default the safekeeping twice.               *
018200200529      *  244537 - To avoid overriding front office identifier.        *
018300200529      *  BUG12874 - Do not invoke AOSECSR0 if the depot customer      *
018400200529      *             is blank                                          *
018500200529      *  BUG12579 - Added CSW206 flag as parameter for SETRADCVT2     *
018600200529      *  CSW206E - Change Control for SWIFT 2006 Standard Changes     *
018700200529      *  BUG8690R - Countervalue not updated and Multiply/Divide      *
018800200529      *             indicator entered by user overridden              *
018900200529      *  238825 - (Reopen) Enhance part of fix BUG9917 and BUG8690    *
019000200529      *           to prevent overriding of defaults to blanks when    *
019100200529      *           no input is made to clearance tupe and with deliver *
019200200529      *           (to and from ) fields.                              *
019300200529      *           Part of this fix already done by BUG11529.          *
019400200529      *  BUG11622-Customer number not being setup correctly caused    *
019500200529      *           DB error in AOSECSR0.                               *
019600200529      *  BUG11529 - Error in defaulting Settlement Details            *
019700200529      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
019800200529      *  238825 - Determine if CSE022 is switched on in order to      *
019900200529      *           call module SEDORFRTV for proper defaulting of      *
020000200529      *           of extended swift settlement details during insert  *
020100200529      *           of trade.                                           *
020200200529      *           Part of this fix already done by BUG10085.          *
020300200529      *  238859 - Do not validate transaction when deleting.  Applied *
020400200529      *           fix BUG8087.                                        *
020500200529      *  BUG11213- Defaulting of other details should be done only    *
020600200529      *            during first time of processing flow.  Applied     *
020700200529      *            fixes BUG8690, BUG9917 and BUG10021 annotated by   *
020800200529      *            the same corresponding bug references.             *
020900200529      *  CSD027A - Conversion Of Customer Number to Alpha             *
021000200529      *  BUG11197- Settlement Ex-rate and M/D indicator should        *
021100200529      *            default when ccy changes.                          *
021200200529      *  BUG11194 - SEFRN- Purchased Interest not recalculated when   *
021300200529      *             trade value date is changed
021400200529      *  BUG10476- Market Centre defaulting.                          *
021500200529      *          - Place of settlement defaulting.                    *
021600200529      *  BUG10085- Safekeeping Account not defaulted                  *
021700200529      *  BUG10041 - Checking of Security name should be done for      *
021800200529      *             delete.                                           *
021900200529      *  BUG10202- Mapping error in TRAD                              *
022000200529      *  BUG10021- Exchange rate and M/D indicator not defaulting.    *
022100200529      *  BUG9961- Parameter mismatch for ZDYYR due to changes made    *
022200200529      *           by CSE071 and CAP087.                               *
022300200529      *  BUG9917- Include the Deliver From and Deliver To Field       *
022400200529      *           in checking before passing thru the default values, *
022500200529      *           this is in conjunction with BUG8690.                *
022600200529      *  CAP087  - Enable the use of SETRADVU to process Buy/Sell     *
022700200529      *            trades.                                            *
022800200529      *  BUG9089- Mapping error with Java for DPMV                    *
022900200529      *  CER001 - LUX Upgrade to MidasPlus.                           *
023000200529      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
023100200529      *           (Recompile)                                         *
023200200529      *  BUG8087 - Do not validate transaction when deleting          *
023300200529      *  BUG8039 - Recompile due to change in SEVTCUST                *
023400200529      *  237063 - EU Tax fixes upgrade to MP build 103.               *
023500200529      *  BUG8119 - Fields returned incorrectly from API if update     *
023600200529      *            flag set to 'Y' but data is invalid.               *
023700200529      *  CGL031 - Taxation of Savings Income                          *
023800200529      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
023900200529      *           (Recompile)                                         *
024000200529      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
024100200529      *  BUG8690 - Only default exchange rate, settlement details     *
024200200529      *            or charge details if they haven't been entered     *
024300200529      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
024400200529      *            move out of *INZSR.                                *
024500200529      *  BUG6496 - Missing CAS006 fields in Securities and Trades     *
024600200529      *            Maintenance.                                       *
024700200529      *  BUG5557 - Information for TRADSDX2 are being dropped during  *
024800200529      *            insert.                                            *
024900200529      *  BUG5230 - To ensure information output to Buffer is a true   *
025000200529      *            picture of the update.                             *
025100200529      *  BUG4728 - Serious Midas error with blank timestamp when      *
025200200529      *            authorising insert of transaction.                 *
025300200529      *  BUG4482 - Authorise should call Validate to show all the     *
025400200529      *            warning errors.                                    *
025500200529      *  BUG4070 - Countervalue and nominal currency code not being   *
025600200529      *            passed to API for deletion of trades.              *
025700200529      *  BUG2274 - Unable to access SSI information because market    *
025800200529      *            not being passed in.                               *
025900200529      *  BUG3950 - Stop validation if there is error on Security      *
026000200529      *            and counterparty.                                  *
026100200529      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
026200200529      *  BUG3145 - Charges and Commission are being missed out of the *
026300200529      *            calculation of countervalue.                       *
026400200529      *  MLFIX1 - Add investment type to output message for           *
026500200529      *           management limit.                                   *
026600200529      *  CGL014 - Collaterals Processing                              *
026700200529      *  CLE025 - Credit Lines (Recompile)                            *
026800200529      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
026900200529      *  CSC022 - Commitment Control Changes for MidasPlus            *
027000200529      *  BUG1569- Stopping user updating the same record at the same  *
027100200529      *           time.                                               *
027200200529      *  225421 - The Validation of Safekeeping A/C is out off       *
027300200529      *           sequence.                                           *
027400200529      *  CGL029 - Increase Account Code to 10 digits                  *
027500200529      *  CAP084 - API Wrapper project                                 *
027600200529      *                                                               *
027700200529      *****************************************************************
027800200529      ** +--------------------------------------+
027900200529      ** ¦ F-specs                              ¦
028000200529      ** ¦ =======                              ¦
028100200529      ** +--------------------------------------+
028200200529      *****************************************************************
028300200529
028400200529      * Trades Extended Settlements
028500200529     FTRADSDY2  IF   E           K DISK
028600200529     FSEVTRADL1 IF   E           K DISK    RENAME(SEVTRADD0:SEVTRADCK1)
028700200529     F                                     INFSR(*pssr)
028800200529
028900200529     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
029000200529                                                                                            BUG10476
029100200529     FSEMKC     IF   E           K DISK                                                     BUG10476
029200200529      ** Midas SE Market Centres                                                            BUG10476
029300200529
029400200529      *****************************************************************
029500200529      ** +--------------------------------------+
029600200529      ** ¦ Automatically included D-specs       ¦
029700200529      ** ¦ ==============================       ¦
029800200529      ** +--------------------------------------+
029900200529      **
030000200529      ** Standard D-specs
030100200529      ** ================
030200200529      **
030300200529      ** The following /COPY line includes the LDA layout,
030400200529      ** the copyright array definition,
030500200529      ** and the following named constants:
030600200529      **    True       logical = *on (for indicator processing)
030700200529      **    False      logical = *off (for indicator processing)
030800200529      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
030900200529      **                                    handler)
031000200529      ** and the following variables:
031100200529      **    RunBefore  1A (for the PSSR)
031200200529
031300200529     D/COPY ZACPYSRC,STD_D_SPEC
031400200529
031500200529      ** Program Status Data Structure
031600200529      ** =============================
031700200529      ** The following /COPY line includes all the defined fields in the
031800200529      ** PSDS.  They have meaningful names, prefixed by 'PS'.
031900200529
032000200529     D/COPY ZACPYSRC,PSDS
032100200529      ** The following /COPY line includes definitions for the above fields
032200200529      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
032300200529      ** corresponding fields in the PSDS /COPY member, so that member
032400200529      ** must be included where this one is used.
032500200529
032600200529     D/COPY ZACPYSRC,PROCPARMS
032700200529
032800200529      **-----------------------------------------------------------------------
032900200529      ** The following /COPY line includes the definitions for error and
033000200529      ** warning message arrays.
033100200529     D/COPY ZACPYSRC,ERR_ARRAYS
033200200529      **-----------------------------------------------------------------------
033300200529
033400200529      **-----------------------------------------------------------------------
033500200529      ** The following /COPY line includes the definitions for arrays
033600200529      ** specific to API CTL & VU modules.
033700200529     D/COPY ZACPYSRC,APICTLARR
033800200529      **-----------------------------------------------------------------------
033900200529
034000200529      ** +--------------------------------------+
034100200529      ** ¦ End of automatically included D-specs¦
034200200529      ** ¦ =====================================¦
034300200529      ** +--------------------------------------+
034400200529
034500200529      *****************************************************************
034600200529      /EJECT
034700200529      *****************************************************************
034800200529
034900200529      ** +--------------------------------------+
035000200529      ** ¦ Manually included D-specs            ¦
035100200529      ** ¦ =========================            ¦
035200200529      ** +--------------------------------------+
035300200529
035400200529      ** +--------------------------------------+
035500200529      ** ¦ Named constants                      ¦
035600200529      ** ¦ ===============                      ¦
035700200529      ** +--------------------------------------+
035800200529
035900200529      ** +--------------------------------------+
036000200529      ** ¦ Arrays and Data Structures           ¦
036100200529      ** ¦ ==========================           ¦
036200200529      ** +--------------------------------------+
036300200529                                                                                              CSC022
036400200529     D WCmtJobArr      S             10A   DIM(10)                                            CSC022
036500200529      ** Array for commitment job names                                                       CSC022
036600200529
036700200529      * Incoming header
036800200529     D HeadIn        E DS                  EXTNAME(APHEADPD)
036900200529      *
037000200529      * Incoming Transaction
037100200529     D TranInPrim    E DS                  EXTNAME(SETRPRPD)
037200200529     D TranInSeco    E DS                  EXTNAME(SETRSEPD)
037300200529     D TranInPrev    E DS                  EXTNAME(SETRPVPD)                                BUG11194
037400200529     D TranInExch    E DS                  EXTNAME(SETREXPD)
037500200529     D TranInSett    E DS                  EXTNAME(SETRSTPD)
037600200529     D DDCLTY2       E                     EXTFLD(DDCLTY)
037700200529     D TranInChCm    E DS                  EXTNAME(SETRCCPD)
037800200529     D TranInSwfA    E DS                  EXTNAME(SETRSWPD)
037900200529     D                                     PREFIX(A)
038000200529     D TranInSwfB    E DS                  EXTNAME(SETRSWPD)
038100200529     D                                     PREFIX(B)
038200200529     D TranInThir    E DS                  EXTNAME(SETRTHPD)
038300200529
038400200529
038500200529     D ValidTrad     E DS                  EXTNAME(SEVTRADPD)
038600200529     D                                     PREFIX(V_)
038700200529     D ValidTrX1     E DS                  EXTNAME(SEVTRX1PD)
038800200529     D                                     PREFIX(V_)
038900200529     D ValidTX1A     E DS                  EXTNAME(SEVTRX1PD)
039000200529     D                                     PREFIX(VA_)
039100200529     D ValidTX1B     E DS                  EXTNAME(SEVTRX1PD)
039200200529     D                                     PREFIX(VB_)
039300200529
039400200529     D ValidTrX2     E DS                  EXTNAME(SEVTRX2PD)
039500200529     D                                     PREFIX(V_)
039600200529     D ValidTX2A     E DS                  EXTNAME(SEVTRX2PD)
039700200529     D                                     PREFIX(VA_)
039800200529     D ValidTX2B     E DS                  EXTNAME(SEVTRX2PD)
039900200529     D                                     PREFIX(VB_)
040000200529     D ValidLUX      E DS                  EXTNAME(SEVTDLX1PD)                                CER001
040100200529      *                                                                                       CER001
040200200529      ** Trade Details Extension File                                                         CER001
040300200529      *                                                                                       CER001
040400200529     D SVRCD         E DS                  EXTNAME(SETRX1PD)                                  CER001
040500200529      *                                                                                       CER001
040600200529     D OKFlagsDS     E DS                  EXTNAME(SEETDLX1PD)                                CER001
040700200529
040800200529     D TradFilFmt    E DS                  EXTNAME(TRADSD)
040900200529     D TX1AFilFmt    E DS                  EXTNAME(TRADSDX1)
041000200529     D                                     PREFIX(A_)
041100200529     D TX1BFilFmt    E DS                  EXTNAME(TRADSDX1)
041200200529     D                                     PREFIX(B_)
041300200529     D TX2AFilFmt    E DS                  EXTNAME(TRADSDX2)
041400200529     D                                     PREFIX(A_)
041500200529     D TX2BFilFmt    E DS                  EXTNAME(TRADSDX2)
041600200529     D                                     PREFIX(B_)
041700200529
041800200529
041900200529      * (Current) Trade in Screen Format - Primary Details
042000200529     D CurTrPrim     E DS                  EXTNAME(SETRPRPD)
042100200529     D                                     PREFIX(@)
042200200529      * (Current) Trade in Screen Format - Secondary Details
042300200529     D CurTrSeco     E DS                  EXTNAME(SETRSEPD)
042400200529     D                                     PREFIX(@)
042500200529      * (Current) Trade in Screen Format - Exchange Rates Details
042600200529     D CurTrExch     E DS                  EXTNAME(SETREXPD)
042700200529     D                                     PREFIX(@)
042800200529      * (Current) Trade in Screen Format - Settlement Instructions
042900200529     D CurTrSett     E DS                  EXTNAME(SETRSTPD)
043000200529     D                                     PREFIX(@)
043100200529     D @DDCLTY2      E                     EXTFLD(DDCLTY)
043200200529      * (Current) Trade in Screen Format - Charges/Commissions
043300200529     D CurTrChCm     E DS                  EXTNAME(SETRCCPD)
043400200529     D                                     PREFIX(@)
043500200529      * (Current) Trade in Screen Format - SWIFT 'A' Details
043600200529     D CurTrSwftA    E DS                  EXTNAME(SETRSWPD)
043700200529     D                                     PREFIX(@A)
043800200529      * (Current) Trade in Screen Format - SWIFT 'B' Details
043900200529     D CurTrSwftB    E DS                  EXTNAME(SETRSWPD)
044000200529     D                                     PREFIX(@B)
044100200529      * (Current) Trade in Screen Format - SWIFT 'A' Details
044200200529     D CurX2SwftA    E DS                  EXTNAME(SETESDPD)
044300200529     D                                     PREFIX(@A)
044400200529      * (Current) Trade in Screen Format - SWIFT 'B' Details
044500200529     D CurX2SwftB    E DS                  EXTNAME(SETESDPD)
044600200529     D                                     PREFIX(@B)
044700200529      ** (Current) Trade in Screen Format - Third screen details
044800200529     D CurTrThir     E DS                  EXTNAME(SETRTHPD)
044900200529     D                                     PREFIX(@)
045000200529      *
045100200529      ** Securities retrieved from file - file format
045200200529     D CrSEFilFmt    E DS                  EXTNAME(TRADSDX2)
045300200529
045400200529     D*OthDdata        DS          3116                                                       CSW210
045500200529     D**TranInExt1             1   1558                                                       CSW210
045600200529     D**TranInExt2          1559   3116                                                       CSW210
045700200529     D***OthDdata        DS          3526                                             CSW210 CSF011A
045800200529     D***TranInExt1             1   1763                                              CSW210 CSF011A
045900200529     D***TranInExt2          1764   3526                                              CSW210 CSF011A
046000200529     D OthDdata        DS          4878                                                      CSF011A
046100200529     D  TranInExt1             1   2439                                                      CSF011A
046200200529     D  TranInExt2          2440   4878                                                      CSF011A
046300200529      *
046400200529     D  TranInExtA   E DS                  EXTNAME(SETESDPD)
046500200529     D                                     PREFIX(A)
046600200529     D  TranInExtB   E DS                  EXTNAME(SETESDPD)
046700200529     D                                     PREFIX(B)
046800200529      *
046900200529      ** Securities screen 1 details retrieved from file - screen format
047000200529     D NwSE1ScnFmt   E DS                  EXTNAME(SETESDPD)
047100200529      *
047200200529      * Error indicators
047300200529     D OKTrPrim      E DS                  EXTNAME(SEETRPRPD)
047400200529     D OKTrSeco      E DS                  EXTNAME(SEETRSEPD)
047500200529     D OKTrThir      E DS                  EXTNAME(SEETRTHPD)
047600200529     D OKTrExch      E DS                  EXTNAME(SEETREXPD)
047700200529     D OKTrSett      E DS                  EXTNAME(SEETRSTPD)
047800200529     D DDCLTY2OK     E                     EXTFLD(DDCLTYOK)
047900200529     D OKTrChcm      E DS                  EXTNAME(SEETRCCPD)
048000200529     D OKTrSwft      E DS                  EXTNAME(SEETRSWPD)
048100200529     D OKX2Swft      E DS                  EXTNAME(SEETESPD)
048200200529
048300200529      ** Security Details
048400200529     D SECTY         E DS                  EXTNAME(SECTYD)
048500200529     D SEC_RECI      E                     EXTFLD(RECI)
048600200529     D SEC_ZZ005     E                     EXTFLD(ZZ005)
048700200529     D SEC_LCD       E                     EXTFLD(LCD)
048800200529     D SEC_CHTP      E                     EXTFLD(CHTP)
048900200529     D SEC_TNLU      E                     EXTFLD(TNLU)
049000200529     D SEC_REPI      E                     EXTFLD(REPI)
049100200529     D SEC_FRNT      E                     EXTFLD(FRNT)
049200200529     D SEC_REPA      E                     EXTFLD(REPA)
049300200529     D SEC_TMST      E                     EXTFLD(TMST)
049400200529     D SEC_SEZONE    E                     EXTFLD(SEZONE)                                     225421
049500200529     D  CDArr                183    230                                                       CAP087
049600200529     D  CRArr                231    242                                                       CAP087
049700200529     D SEC_SETX              243    243                                                       237063
049800200529
049900200529      ** Investment Type Details
050000200529     D INVTP         E DS                  EXTNAME(INVTPD)
050100200529     D INV_RECI      E                     EXTFLD(RECI)
050200200529     D INV_LCD       E                     EXTFLD(LCD)
050300200529     D INV_CHTP      E                     EXTFLD(CHTP)
050400200529     D INV_TNLU      E                     EXTFLD(TNLU)
050500200529     D INV_NDEC      E                     EXTFLD(NDEC)
050600200529
050700200529      ** Overall Transaction status, to be passed to the Message Handler
050800200529     D TranStatus      S              1A
050900200529
051000200529      ** The following /COPY includes the customer details data structure
051100200529     D/COPY SECPYSRC,SE_CUSTDT
051200200529      ** The following /COPY includes the currency details data structures
051300200529     D/COPY SECPYSRC,SE_CCYDT
051400200529      *
051500200529      ** Externally described DS for bank details
051600200529     D SDBANK        E DS                  EXTNAME(SDBANKPD)
051700200529
051800200529      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
051900200529     D SDGELR        E DS                  EXTNAME(SDGELRPD)
052000200529
052100200529     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
052200200529      ** External DS for Branch Details
052300200529     D SDSECS        E DS                  EXTNAME(SDSECSPD)
052400200529     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
052500200529      ** External DS for Security Customer Details
052600200529      *
052700200529      ** Externally described DS for midas modules details
052800200529     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
052900200529      *
053000200529      ** Externally described DS for funds transfer ICD details
053100200529     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
053200200529      *
053300200529      ** Externally described DS for API ICD details
053400200529     D SDAPI         E DS                  EXTNAME(SDAPIPD)
053500200529      *
053600200529      ** Externally described DS for retail ICD details
053700200529     D SDRETL        E DS                  EXTNAME(SDRETLPD)
053800200529     D  QQACC2       E                     EXTFLD(QQACCD)                                     CGL029
053900200529      *
054000200529      ** Externally described DS for SAR details
054100200529     D SCSARD        E DS                  EXTNAME(SCSARDPD)
054200200529     D SLCD          E                     EXTFLD(LCD)
054300200529      *
054400200529      ** Externally described DS for securities trading details
054500200529     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
054600200529      *
054700200529      ** Externally described DS for currency details
054800200529     D SDCURR        E DS                  EXTNAME(SDCURRPD)
054900200529      *                                                                                       247451
055000200529      ** Externally described DS for customer details                                         247451
055100200529     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  247451
055200200529     D  QQDFA2       E                     EXTFLD(QQDFAC)                                     247451
055300200529
055400200529     D Indicators      DS                  BASED(IndicatorP)
055500200529     D  RecNotFnd             01     01
055600200529
055700200529      ** 24x7 Status Dataarea
055800200529     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
055900200529
056000200529      ** Additional entry parameter for Midas Compliance Watch
056100200529     D PMCWL           DS          9999
056200200529
056300200529      ** SD Data Area
056400200529     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
056500200529
056600200529     D InfData       E DS                  EXTNAME(SETRIFPD)
056700200529      * SE Extra Data - Classe 1 Data - File (D/B) format
056800200529
056900200529     D ExtData       E DS                  EXTNAME(SETDEXPD)
057000200529      * SE Trades Extra Data - File (D/B) format
057100200529      *                                                                                       CER001
057200200529      ** Extra data in file format (Regional)                                                 CER001
057300200529      *                                                                                       CER001
057400200529     D RegData       E DS                  EXTNAME(SETDRXPD)                                  CER001
057500200529
057600200529      ** DS for Access Objects - short data structure
057700200529     D DSFDY         E DS                  EXTNAME(DSFDY)
057800200529      *
057900200529      ** DS for Access Objects - long data structure
058000200529     D DSSDY         E DS                  EXTNAME(DSSDY)
058100200529      ** Stamp Tax                                                                            CER049
058200200529     D StampTax      E DS                  EXTNAME(TRADSDQD)                                  CER049
058300200529
058400200529      ** DS for ZMUSER details
058500200529     D ZMUSER          DS            17
058600200529     D  PUSRID                 1     10
058700200529     D  PDBRN                 11     13
058800200529     D  PDPPT                 14     16
058900200529      *
059000200529     D D@USER        E DS                  EXTNAME(MUSERDD)
059100200529     D DRECI         E                     EXTFLD(RECI)
059200200529     D DLCD          E                     EXTFLD(LCD)
059300200529     D DCHTP         E                     EXTFLD(CHTP)
059400200529
059500200529     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
059600200529     D  ComitJob               4    103                                                       CSC022
059700200529      ** Midas SC Jobs handling commitment control data area                                  CSC022
059800200529      *                                                                                       CER001
059900200529      ** Data passed from caller program                                                      CER001
060000200529      *                                                                                       CER001
060100200529     D DATALUX         DS          1024                                                       CER001
060200200529     D  PETDRF                 1      6                                                       CER001
060300200529     D  UTDBK                  7      8                                                       CER001
060400200529     D  UVTCNR                 9     14                                                       CER001
060500200529     D  #1TDVD                15     19  0                                                    CER001
060600200529     D  #1TDDT                20     24  0                                                    CER001
060700200529     D  #1ISSD                25     29  0                                                    CER001
060800200529     D  #1MATY                30     34  0                                                    CER001
060900200529     D  #1FOTR                35     54                                                       CER001
061000200529     D  #1TMST                55     80Z                                                      CER001
061100200529     D*
061200200529      ** DS to keep old TranInExch data                                                       247907
061300200529     D OldTranInExch E DS                  EXTNAME(SETREXPD)                                  247907
061400200529     D                                     PREFIX(O)                                          247907
061500200529      ** DS to keep retrieved TanInExch data                                                  247907
061600200529     D NewTranInExch E DS                  EXTNAME(SETREXPD)                                  247907
061700200529     D                                     PREFIX(N)                                          247907
061800200529                                                                                              247907
061900200529     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  CSF011
062000200529     D                                     PREFIX(NO_)                                        CSF011
062100200529     D ACCNT         E DS                  EXTNAME(ACCNTAB)                                   CSF011
062200200529     D                                     PREFIX(AC_)                                        CSF011
062300200529      ** +--------------------------------------+
062400200529      ** ¦ Declared variables                   ¦
062500200529      ** ¦ ==================                   ¦
062600200529      ** +--------------------------------------+
062700200529
062800200529      * Error message field(s)
062900200529     D     Msg1        S                   LIKE(#MsgID)
063000200529
063100200529      * Index for arrays of error message ids etc in amend validation
063200200529     D AmIdx           S              3P 0 INZ(0)
063300200529
063400200529      * Index for arrays of error message ids etc
063500200529     D Idx             S              3P 0 INZ(0)
063600200529
063700200529      * Index for arrays of warning message ids etc
063800200529     D WIdx            S              3P 0 INZ(0)
063900200529
064000200529      * Fields (500A) to receive the incoming transaction
064100200529     D Trans5001       S            500A
064200200529     D Trans5002       S            500A
064300200529     D Trans5002B      S            500A                                                    BUG11194
064400200529     D Trans5003       S            500A
064500200529     D***Trans5004       S            500A                                                   CSF011A
064600200529     D Trans5004       S           1000A                                                     CSF011A
064700200529     D Trans5005       S            500A
064800200529     D Trans5006       S            500A
064900200529     D Trans5007       S            500A
065000200529     D Trans5008       S            500A
065100200529     D TransQ          S            500A                                                      CER049
065200200529
065300200529      * Field (500A) to receive the incoming Extra Data
065400200529     D OthData500      S            500A                                                     BUG9089
065500200529     D InfData500      S            500A
065600200529     D ExtData500      S            500A
065700200529      ** Field (4755A) to receive the incoming Extra Data
065800200529     D***OthDData4755    S           4755A                                                   CSF011A
065900200529     D OthrData        S           4878A                                                     CSF011A
066000200529      *                                                                                       CER001
066100200529      ** Extra Data (Regional)                                                                CER001
066200200529      *                                                                                       CER001
066300200529     D RegData500      S            500A                                                      CER001
066400200529
066500200529      ** Country of treaty
066600200529     D PDRBW           S              2A
066700200529      *
066800200529      ** Withholding tax
066900200529     D DDWTAX          S             15A
067000200529      *
067100200529      ** Switchable features
067200200529     D CAP051          S              1A
067300200529     D CEU005          S              1A
067400200529     D CSW201          S              1A
067500200529     D CSW003          S              1A
067600200529     D CSE011          S              1A
067700200529     D S01401          S              1A
067800200529     D CSE028          S              1A
067900200529     D CSC011          S              1A
068000200529     D CAS006          S              1A
068100200529     D ULX008          S              1A                                                      CER001
068200200529     D ULX603          S              1A                                                      CER001
068300200529     D CGL031          S              1A                                                      CGL031
068400200529     D CSW206          S              1A                                                     CSW206E
068500200529     D CSW210          S              1A                                                      CSW210
068600200529     D CFT004          S              1A                                                      CSW210
068700200529      *
068800200529      ** Work variable
068900200529     D CallFromVU      S              1A   INZ('Y')                                           CAP087
069000200529     D CPartyClass     S              1A
069100200529     D DDHACR          S             13A
069200200529     D DDPRICN         S             17A
069300200529     D PMODE           S              3A
069400200529     D PRTCD           S              7A
069500200529     D POPTN           S              7A
069600200529     D PSARD           S              6A
069700200529     D BeforeIdx       S              3  0
069800200529     D BeforeWIdx      S              3  0
069900200529     D StepIdx         S              3  0
070000200529     D UpdRtnCode      S              7A
070100200529     D WkDate          S              5  0
070200200529     D WkNext          S              5  0
070300200529     D WorkTime        S             26A
070400200529     D WDDDELF         S             10A                                                     BUG9917
070500200529     D WDDDELT         S             10A                                                     BUG9917
070600200529     D WDDORBR         S                   LIKE(DDORBR)                                     BUG11529
070700200529     D WrkDfltInd      S              1A                                                    BUG11529
070800200529                                                                                              CSF011
070900200529     D WNumDetlIn      S           1000A                                                      CSF011
071000200529     D CusIdx          S              4S 0 INZ(1)                                             CSF011
071100200529     D CusIdx2         S              4S 0 INZ(1)                                             CSF011
071200200529     D CusLength       S              2S 0 INZ(40)                                            CSF011
071300200529     D AccLength       S              2S 0 INZ(72)                                            CSF011
071400200529     D ACusLngth       S              2S 0 INZ(52)                                            CSF011
071500200529     D W@Len           S              2S 0                                                    CSF011
071600200529     D NoOfCusField    S              2S 0 INZ(21)                                            CSF011
071700200529     D NoOfCusField2   S              2S 0 INZ(13)                                           CSF011A
071800200529     D CusOrAcc        C                   CONST('CAABBBBBBBBBBBBBBBBBB')                     CSF011
071900200529     D P@TYP           S             10                                                       CSF011
072000200529     D P@Str           S             35                                                       CSF011
072100200529     D P0RETL          S             10                                                       CSF011
072200200529     D WCustomer       S             10                                                       CSF011
072300200529     D C#KYST          S              7                                                       CSF011
072400200529     D W@Abc           S              1                                                       CSF011
072500200529     D WBrch           S              3                                                       CSF011
072600200529
072700200529      * Timestamp for the transaction
072800200529     D WTimeStamp      S               Z
072900200529     D CSE022          S              1A
073000200529     D CSW014          S              1A
073100200529     D SWRTN           S              7A
073200200529     D WTDTP           S              2A
073300200529     D WWCLTY          S              2A
073400200529     D PGMNAM          S              9A
073500200529     D PWHEN           S              1A
073600200529     D PMKCT           S              2A
073700200529     D DFTFLG          S              1A
073800200529     D PMODE2          S              6A                                                    MD035243
073900200529      *
074000200529      ** Data structure to receive parameters from SE1805 for MT5xxs
074100200529     D PDATA         E DS                  EXTNAME(SE50DT)
074200200529      *
074300200529      ** Mode = '*FRONT' (front office transaction interface)
074400200529      ** Mode = '      ' (not front office transaction interface)
074500200529      ** Mode = '*RPR  ' (repair function)
074600200529      ** Mode = '*SIN  ' (screen input function)
074700200529     D PINKS           S              1A
074800200529     D PINKT           S              1A
074900200529     D PCUST           S              6A
075000200529     D WCTPCN          S              6A
075100200529     D PDEPO           S              6A
075200200529     D PDEPO2          S              6A
075300200529     D PRETC           S             10A
075400200529     D PSKAL           S             20A
075500200529
075600200529      * No of Interest Days in year                                                           CAP087
075700200529     D DaysInYear      S              3  0                                                    CAP087
075800200529     D Out_DaysYear    S              3A                                                      CAP087
075900200529                                                                                              CSC022
076000200529     D Trade_Value     S             15  0                                                    CAP087
076100200529     D Out_Value       S             15A                                                      CAP087
076200200529                                                                                              CAP087
076300200529     D CSC022          S              1A                                                      CSC022
076400200529                                                                                              CSC022
076500200529     D WCommitSkip     S              1A                                                      CSC022
076600200529      ** Commitment Skip Field                                                                CSC022
076700200529                                                                                             BUG3145
076800200529     D CGL014          S              1A                                                     BUG3145
076900200529     D*
077000200529      ** For Countervalue computation                                                         247907
077100200529     D OldV_TDER       S             13  8                                                    247907
077200200529     D OldV_TMDI       S              1A                                                      247907
077300200529     D OldV_TBCR       S             13  8                                                    247907
077400200529     D NewV_TDER       S             13  8                                                    247907
077500200529     D NewV_TMDI       S              1A                                                      247907
077600200529                                                                                              247907
077700200529      ** Parameters for ZASIGN                                                                247907
077800200529     D ZASIGNOK        S              1A                                                      247907
077900200529     D ZFLD17          S             17A                                                      247907
078000200529     D ZFSIGN          S              1A                                                      247907
078100200529     D ZOUT15          S             15A                                                      247907
078200200529     D ZSDEC           S              1P 0                                                    247907
078300200529     D ZSDCSP          S              1A                                                      247907
078400200529     D ZSDIG           S              2P 0                                                    247907
078500200529     D ZECODE          S              1A                                                      247907
078600200529     D ZFLD15          S             15P 0                                                    247907
078700200529     D ZOUT21          S             21A                                                      247907
078800200529                                                                                              247907
078900200529      ** Front office id variable.                                                         AR698195B
079000200529     D DDFRNT          S             20A                                                   AR698195B
079100200529                                                                                             BUG5230
079200200529      ***** Data used by SETRADR ******                                                      BUG5230
079300200529      ** Array of Fields in error.                                                           BUG5230
079400200529     D @FldNameArr     S             10A   DIM(ArrayMax)                                     BUG5230
079500200529                                                                                             BUG5230
079600200529      ** Array of error message IDs                                                          BUG5230
079700200529     D @MsgIDArr       S                   DIM(ArrayMax)                                     BUG5230
079800200529     D                                     LIKE(#MsgID)                                      BUG5230
079900200529                                                                                             BUG5230
080000200529      ** Array of error message data.                                                        BUG5230
080100200529     D @MsgDtaArr      S                   DIM(ArrayMax)                                     BUG5230
080200200529     D                                     LIKE(#MsgData)                                    BUG5230
080300200529                                                                                             BUG5230
080400200529      ** Array of message files to check                                                     BUG5230
080500200529     D @MsgFArray      S             10A   DIM(MsgFArrMax)                                   BUG5230
080600200529                                                                                             BUG5230
080700200529     D ROU             S              1    DIM(12)                                            247873
080800200529      *                                                                                       247873
080900200529      ** +--------------------------------------+
081000200529      ** ¦ End of D-specs                       ¦
081100200529      ** ¦ ==============                       ¦
081200200529      ** +--------------------------------------+
081300200529
081400200529      ** +----------------------------------------+
081500200529      ** ¦ Hook for non-core D-specs (all types)  ¦
081600200529      ** ¦ also any I-specs (if necessary)        ¦
081700200529      ** ¦ =====================================  ¦
081800200529      ** +----------------------------------------+
081900200529
082000200529      *****************************************************************
082100200529      /EJECT
082200200529      *****************************************************************
082300200529      ** +--- Start of main processing -----------------------------------+
082400200529      ** ¦                                                                ¦
082500200529      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
082600200529      ** ¦ executed at program activation.                                ¦
082700200529      ** ¦                                                                ¦
082800200529      ** +----------------------------------------------------------------+
082900200529      *                                                                                      BUG7029
083000200529      ** Retrieve ZMUSER details.                                                            BUG7029
083100200529      *                                                                                      BUG7029
083200200529     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7029
083300200529     C                   IN        ZMUSER                                                    BUG7029
083400200529
083500200529      * Incoming transaction is broken into 500A fields, so that a common CL
083600200529      * can be used between this module and the one that read the MQ queue.
083700200529      * This module needs to break these 500A fields by loading them into
083800200529      * the appropriate (externally described) data structure.
083900200529     C                   MOVEL     Trans5001     TranInPrim
084000200529     C                   MOVEL     Trans5002     TranInSeco
084100200529     C                   MOVEL     Trans5002B    TranInPrev                                 BUG11194
084200200529     C                   MOVEL     Trans5003     TranInExch
084300200529     C                   MOVEL     Trans5004     TranInSett
084400200529     C                   MOVEL     Trans5005     TranInChCm
084500200529     C                   MOVEL     Trans5006     TranInSwfA
084600200529     C                   MOVEL     Trans5007     TranInSwfB
084700200529     C                   MOVEL     Trans5008     TranInThir
084800200529     C**********         MOVEL     Infdata500    Infdata                                    BUG10202
084900200529     C                   MOVEL     Extdata500    Extdata
085000200529     C                   MOVEL     RegData500    RegData                                      CER001
085100200529     C**********         MOVEL     OthDData4755  OthDData                                    CSF011A
085200200529     C                   MOVEL     OthrData      OthDData                                    CSF011A
085300200529     C                   MOVEL     TranInExt1    TranInExtA
085400200529     C                   MOVEL     TranInExt2    TranInExtB
085500200529     C                   MOVEL     TransQ        StampTax                                     CER049
085600200529
085700200529      * Reset variables gradually updated
085800200529     C                   EXSR      RESETCYCLE
085900200529
086000200529      *  Check if valid trade exists for Midas Trade Ref
086100200529
086200200529     C                   EXSR      ChkValMiTR
086300200529      *
086400200529      *  If valid trade does exist (even after delay), fail this input
086500200529      *
086600200529     C     Idx           IFNE      0
086700200529     C                   GOTO      INVALID
086800200529     C                   END
086900200529
087000200529      * Reset variables again in case the details have been corrupted
087100200529      * by previous chain to valid trades file.
087200200529
087300200529     C                   EXSR      RESETCYCLE
087400200529
087500200529      * Validate action code
087600200529     C                   EXSR      ValidateAc
087700200529      *
087800200529      * If error in validation of action code, fail this input
087900200529     C                   IF        Idx <> 0
088000200529     C                   GOTO      INVALID
088100200529     C                   ENDIF
088200200529                                                                                            BUG27876
088300200529     C                   Z-ADD     0             NomCcyDec                                  BUG27876
088400200529
088500200529      * Processing depends upon action code
088600200529     C                   SELECT
088700200529     C                   WHEN         DDACTN = 'I'
088800200529      * Force Interest Recalculation                                                        BUG11194
088900200529     C                   EXSR      SRIntCal                                                 BUG11194
089000200529                                                                                            BUG11194
089100200529      *  Processing for Inserts
089200200529     C                   EXSR      ValidateTr
089300200529
089400200529     C                   WHEN         DDACTN = 'D'                                          BUG10041
089500200529                                                                                            BUG10041
089600200529      ** Processing for Delete                                                              BUG10041
089700200529                                                                                            BUG10041
089800200529     C                   EXSR      ValdTrPrim                                               BUG10041
089900200529                                                                                            BUG10041
090000200529     C                   WHEN         DDACTN = 'A'
090100200529     C                             OR DDACTN = 'C'
090200200529     C                             OR DDACTN = 'D'                                           BUG4070
090300200529     C                   EXSR      Fil2ScrnConv
090400200529      *  Processing for Amends or Changes
090500200529     C     GHSUBS        ifne      *blank
090600200529     C     GHSUBS        scan      TranInPrim                             99
090700200529     C  N99GHSUBS        scan      TranInSeco                             99
090800200529     C  N99GHSUBS        scan      TranInThir                             99
090900200529     C  N99GHSUBS        scan      TranInExch                             99
091000200529     C  N99GHSUBS        scan      TranInSett                             99
091100200529     C  N99GHSUBS        scan      TranInChCm                             99
091200200529     C  N99GHSUBS        scan      TranInSwfA                             99
091300200529     C  N99GHSUBS        scan      TranInSwfB                             99
091400200529     C     *in99         ifeq      *on
091500200529     C                   EXSR      TDtDtaSubs
091600200529     C                   endif
091700200529     C                   endif
091800200529     C     DDACTN        IFNE      'D'                                                       BUG8087
091900200529     C                   EXSR      SetupAmd
092000200529     C                   EXSR      ValidateTr
092100200529     C                   EXSR      ValdateAmd
092200200529     C                   ENDIF                                                               BUG8087
092300200529                                                                                             BUG4482
092400200529     C                   WHEN      DDACTN = 'X'                                              BUG4482
092500200529     C                             OR DDACTN = 'Y'                                            CAP087
092600200529      *  Processing for Authorises                                                           BUG4482
092700200529     C                   EXSR      ValidateTr                                                BUG4482
092800200529
092900200529     C                   ENDSL
093000200529      *
093100200529     C     INVALID       TAG
093200200529      *                                                                                       CAP087
093300200529      * Calculate Days in Year                                                                CAP087
093400200529     C                   IF        Idx = 0                                                    CAP087
093500200529     C                   EXSR      CalcDays                                                   CAP087
093600200529     C                   ENDIF                                                                CAP087
093700200529                                                                                              CSF011
093800200529      ** Populate Customer or Account Details                                                 CSF011
093900200529                                                                                              CSF011
094000200529     C                   EXSR      SrCustName                                                 CSF011
094100200529     C                   EXSR      SrCustName2                                               CSF011A
094200200529                                                                                              CSF011
094300200529
094400200529      * Write to database
094500200529     C     UpdateYN      IFEQ      'Y'
094600200529     C     Idx           ANDEQ     0
094700200529     C     Idx           IFEQ      0
094800200529     C                   EXSR      SETUPVALID
094900200529     C                   EXSR      UpdateDB
095000200529      *                                                                                       CER001
095100200529     C                   MOVE      DDTDRF        #6LXCCTDRF                                   CER001
095200200529      *                                                                                       CER001
095300200529     C                   IF        ULX603 = 'Y'                                               CER001
095400200529     C                   CALLB     'SETRAD2UP'                                                CER001
095500200529     C                   PARM                    DDACTN                                       CER001
095600200529     C                   PARM      *BLANKS       ReturnCode                                   CER001
095700200529     C                   PARM      'Y'           @@FIND            1                          CER001
095800200529     C                   PARM                    ValidLUX                                     CER001
095900200529     C                   PARM      *BLANKS       SVRCD                                        CER001
096000200529     C                   ENDIF                                                                CER001
096100200529      *                                                                                       CER001
096200200529     C                   ENDIF
096300200529     C                   ENDIF
096400200529
096500200529     C                   SETON                                        LR
096600200529
096700200529      ** If action is for Update, get the correct record information                         BUG5230
096800200529      ** from file                                                                           BUG5230
096900200529     C                   IF        UpdateYN = 'Y'                                            BUG5230
097000200529     C                             AND Idx = 0                                               BUG8119
097100200529     C                   MOVE      DDTDRF        DDTDRF_IN                                   BUG5230
097200200529     C                   CALL      'SETRADR'                                                 BUG5230
097300200529     C                   PARM                    @AuthComp         1                         BUG5230
097400200529     C                   PARM                    @FwdBck           1                         BUG5230
097500200529     C                   PARM                    DDTDRF_IN         6                         BUG5230
097600200529     C                   PARM                    Buffer                                      BUG5230
097700200529     C                   PARM                    Buffer2                                     CSF011A
097800200529     C                   PARM                    @FldNameArr                                 BUG5230
097900200529     C                   PARM                    @MsgIDArr                                   BUG5230
098000200529     C                   PARM                    @MsgDtaArr                                  BUG5230
098100200529     C                   PARM                    @MsgFArray                                  BUG5230
098200200529     C                   PARM                    @APIRetC          1                         BUG5230
098300200529     C                   MOVEL     DDACTN        Buffer                                      BUG5230
098400200529     C                   ELSE                                                                BUG5230
098500200529      * Remerge buffer with all relevant data structures
098600200529      ** RegData is being used for regional enhancement and therefore should                BUG10202
098700200529      ** always be the last data to form the buffer if no ExtData included                  BUG10202
098800200529      ** otherwise it should be positioned before ExtData                                   BUG10202
098900200529     C                   EVAL      Buffer = TranInPrim + TranInSeco +
099000200529     C                                      TranInPrev              +                       BUG11194
099100200529     C                                      TranInExch + TranInSett +
099200200529     C                                      TranInChCm +
099300200529     C                                      TranInSwfA + TranInSwfB +
099400200529     C**********                            TranInExtA + TranInExtB +                        CSF011A
099500200529     C                                    TranInExtA + %SUBST(TranInExtB:1:2228)             CSF011A
099600200529     C************                          TranInThir +                                     BUG1569
099700200529     C**********                            TranInThir + @TimeStamp +                BUG1569 CSF011A
099800200529     C**********                            SPBS + STBS + PROT + NomCcySWCY +                CSF011A
099900200529     C**********                            CPartyClass + BVAUTH +                           CSF011A
100000200529     C**********                            DDCPNR + DDTCTR + DDCFCT +                       CSF011A
100100200529     C**********                            A_DDROUS + A_DDROTS +                            CSF011A
100200200529     C**********                            A_DDROUC + A_DDROTC +                            CSF011A
100300200529     C**********                            B_DDROUS + B_DDROTS +                            CSF011A
100400200529     C**********                            B_DDROUC + B_DDROTC +                            CSF011A
100500200529     C**********                            DDSPXR + DDSPMD + DDWTAX +                       CSF011A
100600200529     C**********                            BKEURO + DDSTAT + DDAUTH                          MLFIX1
100700200529     C**********                            BKEURO + DDSTAT + DDAUTH +                MLFIX1 CSF011A
100800200529     C**********                            SITP                                      MLFIX1 CSF011A
100900200529     C**********                            + DDPRICN + DDHACR                        BUG6496 CER001
101000200529     C**********                            + DDPRICN + DDHACR + RegData              CER001 BUG9089
101100200529     C**********                            + DDPRICN + DDHACR + InfData            BUG9089 BUG10202
101200200529     C**********                            + RegData                               BUG9089 BUG10202
101300200529     C**********                            + DDPRICN + DDHACR                      BUG10202 CSF011A
101400200529     C**********                            + Out_Value + Out_DaysYear                CAP087 CSF011A
101500200529     C**********                            + RegData                             BUG10202 AR698195B
101600200529     C**********                            + DDFRNT + AAuth + RegData              AR698195B CER049
101700200529     C**********                            + DDFRNT + StampTax                       CER049 CSF011A
101800200529     C**********                            + AAuth                                   CER049 CSF011A
101900200529     C**********                            + RegData                                 CER049 CSF011A
102000200529     C                   EVAL      Buffer2 = %SUBST(TranInExtB:2229:211)                     CSF011A
102100200529     C                                    + TranInThir + @TimeStamp                          CSF011A
102200200529     C                                    + SPBS + STBS + PROT + NomCcySWCY                  CSF011A
102300200529     C                                    + CPartyClass + BVAUTH                             CSF011A
102400200529     C                                    + DDCPNR + DDTCTR + DDCFCT                         CSF011A
102500200529     C                                    + A_DDROUS + A_DDROTS                              CSF011A
102600200529     C                                    + A_DDROUC + A_DDROTC                              CSF011A
102700200529     C                                    + B_DDROUS + B_DDROTS                              CSF011A
102800200529     C                                    + B_DDROUC + B_DDROTC                              CSF011A
102900200529     C                                    + DDSPXR + DDSPMD + DDWTAX                         CSF011A
103000200529     C                                    + BKEURO + DDSTAT + DDAUTH                         CSF011A
103100200529     C                                    + SITP   + DDPRICN                                 CSF011A
103200200529     C                                    + DDHACR + Out_Value + Out_DaysYear                CSF011A
103300200529     C                                    + DDFRNT + StampTax + AAuth + Regdata              CSF011A
103400200529     C                   ENDIF                                                               BUG5230
103500200529
103600200529     C                   RETURN
103700200529
103800200529      *****************************************************************                       CSF011
103900200529      /EJECT                                                                                  CSF011
104000200529      *****************************************************************                       CSF011
104100200529      *                                                               *                       CSF011
104200200529      * SrCustname - Get the Customer details                         *                       CSF011
104300200529      *                                                               *                       CSF011
104400200529      *****************************************************************                       CSF011
104500200529     C     SrCustName    BEGSR                                                                CSF011
104600200529      ** Customer fields for retrieval of details                                             CSF011
104700200529     C                   EVAL      %SUBST(WNumDetlIn:1:35)   = DDCNUM                         CSF011
104800200529     C                   EVAL      %SUBST(WNumDetlIn:36:35)  = DDPYFM                         CSF011
104900200529     C                   EVAL      %SUBST(WNumDetlIn:71:35)  = DDPAYT                         CSF011
105000200529     C                   EVAL      %SUBST(WNumDetlIn:106:35) = DDTDFA                         CSF011
105100200529     C                   EVAL      %SUBST(WNumDetlIn:141:35) = DDDELF                         CSF011
105200200529     C                   EVAL      %SUBST(WNumDetlIn:176:35) = DDDELT                         CSF011
105300200529     C                   EVAL      %SUBST(WNumDetlIn:211:35) = DDDFFA                         CSF011
105400200529     C                   EVAL      %SUBST(WNumDetlIn:246:35) = DDDTFA                         CSF011
105500200529     C                   EVAL      %SUBST(WNumDetlIn:281:35) = AESAP1L                        CSF011
105600200529     C                   EVAL      %SUBST(WNumDetlIn:316:35) = AESAP2N                        CSF011
105700200529     C                   EVAL      %SUBST(WNumDetlIn:351:35) = AESAWIN                        CSF011
105800200529     C                   EVAL      %SUBST(WNumDetlIn:386:35) = AESBOFN                        CSF011
105900200529     C                   EVAL      %SUBST(WNumDetlIn:421:35) = AESIPYN                        CSF011
106000200529     C                   EVAL      %SUBST(WNumDetlIn:456:35) = AESINVE                        CSF011
106100200529     C                   EVAL      %SUBST(WNumDetlIn:491:35) = AESSA1N                        CSF011
106200200529     C                   EVAL      %SUBST(WNumDetlIn:526:35) = AESSKAN                        CSF011
106300200529     C                   EVAL      %SUBST(WNumDetlIn:561:35) = AESCCTN                        CSF011
106400200529     C                   EVAL      %SUBST(WNumDetlIn:596:35) = AESRSSN                        CSF011
106500200529     C                   EVAL      %SUBST(WNumDetlIn:631:35) = AESIMMD1                       CSF011
106600200529     C                   EVAL      %SUBST(WNumDetlIn:666:35) = AESIMMD2                       CSF011
106700200529     C                   EVAL      %SUBST(WNumDetlIn:701:35) = AESPSET                        CSF011
106800200529     C                   EVAL      CusIdx = 1                                                 CSF011
106900200529                                                                                              CSF011
107000200529     C                   DOW       CusIdx <= NoOfCusField                                     CSF011
107100200529                                                                                              CSF011
107200200529     C                   EVAL      P@Str = %SUBST(WNumDetlIn:CusIdx2:35)                      CSF011
107300200529     C                   EVAL      W@Abc = %SUBST(CusOrAcc:CusIdx:1)                          CSF011
107400200529                                                                                              CSF011
107500200529     C                   IF        P@Str <> *BLANKS                                           CSF011
107600200529                                                                                              CSF011
107700200529     C                   IF        W@Abc = 'C' OR W@Abc  = 'B'                                CSF011
107800200529     C                   EVAL      WCustomer = *BLANKS                                       CSF011A
107900200529      ** Customer Type                                                                        CSF011
108000200529     C                   CALL      'AOCUSTR0'                                                 CSF011
108100200529     C                   PARM      *BLANKS       @RTCD                                        CSF011
108200200529     C                   PARM      '*KEY'        @OPTN                                        CSF011
108300200529     C                   PARM                    P@Str                                       CSF011A
108400200529     C                   PARM      *BLANKS       C#KYST                                       CSF011
108500200529     C     SDCUST        PARM      SDCUST        DSSDY                                        CSF011
108600200529     C                   ENDIF                                                               CSF011A
108700200529                                                                                              CSF011
108800200529     C                   CALL      'AOIBANR2'                                                CSF011A
108900200529     C                   PARM      *Blanks       @RTCD                                       CSF011A
109000200529     C                   PARM                    P@Str                                       CSF011A
109100200529     C                   PARM                    DSSDY                                       CSF011A
109200200529                                                                                             CSF011A
109300200529     C                   IF        @RTCD = *BLANKS                                           CSF011A
109400200529     C                   EVAL      ACCNT = DSSDY                                             CSF011A
109500200529     C                   EVAL      WCustomer = AC_CNUM                                       CSF011A
109600200529                                                                                              CSF011
109700200529     C                   ELSE                                                                 CSF011
109800200529                                                                                              CSF011
109900200529     C                   EVAL      WBrch = DDBRCD                                             CSF011
110000200529                                                                                              CSF011
110100200529      ** Pay from branch for GL Accounts                                                      CSF011
110200200529     C                   IF        CusIdx = 2 AND DDPYFB <> *BLANKS                          CSF011A
110300200529     C                   EVAL      WBrch = DDPYFB                                             CSF011
110400200529     C                   ENDIF                                                                CSF011
110500200529                                                                                              CSF011
110600200529      ** Pay to branch for GL Accounts                                                        CSF011
110700200529     C                   IF        CusIdx = 3 AND DDPYTB <> *BLANKS                          CSF011A
110800200529     C                   EVAL      WBrch = DDPYTB                                             CSF011
110900200529     C                   ENDIF                                                                CSF011
111000200529                                                                                              CSF011
111100200529      ** Account Type                                                                         CSF011
111200200529      ** Nostro Account                                                                       CSF011
111300200529     C                   SELECT                                                              CSF011A
111400200529     C                   WHEN      %LEN(%TRIM(P@Str)) = 2                                    CSF011A
111500200529     C                   EVAL      P@Str = DDSETC + %SUBST(P@Str:1:2)                         CSF011
111600200529      ** GL Accounts                                                                          CSF011
111700200529     C                   WHEN      %LEN(%TRIM(P@Str)) = 18                                   CSF011A
111800200529     C                   EVAL      P@Str = WBrch + %SUBST(P@Str:1:6) +                        CSF011
111900200529     C                                     DDSETC + %SUBST(P@Str:7:12)                        CSF011
112000200529     C                   ENDSL                                                               CSF011A
112100200529                                                                                              CSF011
112200200529     C                   CALL      'AOACCTV1'                                                 CSF011
112300200529     C                   PARM      *BLANKS       @RTCD                                        CSF011
112400200529     C                   PARM      *BLANKS       P@TYP                                        CSF011
112500200529     C                   PARM                    P@Str                                        CSF011
112600200529     C                   PARM                    DSSDY                                        CSF011
112700200529                                                                                              CSF011
112800200529      ** Retrieve Account Details, Customer Shortname, Report Name,                           CSF011
112900200529      ** and Town, Account Name and Swift ID                                                  CSF011
113000200529                                                                                              CSF011
113100200529     C                   SELECT                                                               CSF011
113200200529                                                                                              CSF011
113300200529     C                   WHEN      P@TYP = '*RETAIL' OR                                       CSF011
113400200529     C                             P@TYP = '*LEDGER'                                          CSF011
113500200529     C                   EVAL      ACCNT = DSSDY                                              CSF011
113600200529     C                   EVAL      WCustomer = AC_CNUM                                        CSF011
113700200529                                                                                              CSF011
113800200529     C                   WHEN      P@TYP = '*NOSTRO'                                          CSF011
113900200529     C                   EVAL      SDNOST = DSSDY                                             CSF011
114000200529     C                   EVAL      WCustomer = NO_A7CUST                                      CSF011
114100200529     C                   CALL      'AOACCTR0'                                                 CSF011
114200200529     C                   PARM      *BLANKS       @RTCD                                        CSF011
114300200529     C                   PARM      '*KEY   '     @OPTN                                        CSF011
114400200529     C                   PARM      *BLANKS       P0RETL                                       CSF011
114500200529     C                   PARM                    NO_A7CUST                                    CSF011
114600200529     C                   PARM                    NO_A7CYCD                                    CSF011
114700200529     C                   PARM                    NO_A7ACCD                                    CSF011
114800200529     C                   PARM                    NO_A7ACSN                                    CSF011
114900200529     C                   PARM                    NO_A7BRCD                                    CSF011
115000200529     C     ACCNT         PARM                    DSSDY                                        CSF011
115100200529     C                   WHEN      P@TYP = '*CUSTNO' OR                                      CSF011A
115200200529     C                             P@TYP = '*SHNAME'                                         CSF011A
115300200529     C                   EVAL      SDCUST = DSSDY                                            CSF011A
115400200529     C                   EVAL      WCustomer = *BLANKS                                       CSF011A
115500200529                                                                                             CSF011A
115600200529     C                   WHEN      P@TYP = '*NRF   '                                         CSF011A
115700200529     C                   EVAL      WCustomer = *BLANKS                                       CSF011A
115800200529                                                                                              CSF011
115900200529     C                   ENDSL                                                                CSF011
116000200529                                                                                              CSF011
116100200529     C                   ENDIF                                                               CSF011A
116200200529                                                                                              CSF011
116300200529     C                   IF         WCustomer <> *BLANKS                                     CSF011A
116400200529     C                   CALL      'AOCUSTR0'                                                 CSF011
116500200529     C                   PARM      *BLANKS       @RTCD                                        CSF011
116600200529     C                   PARM      '*KEY'        @OPTN                                        CSF011
116700200529     C                   PARM                    WCustomer                                    CSF011
116800200529     C                   PARM      *BLANKS       C#KYST                                       CSF011
116900200529     C     SDCUST        PARM      SDCUST        DSSDY                                        CSF011
117000200529     C                   ENDIF                                                               CSF011A
117100200529                                                                                             CSF011A
117200200529     C                   IF        @RTCD = *BLANKS                                           CSF011A
117300200529     C                   EXSR      SrXferCustName                                             CSF011
117400200529     C                   ENDIF                                                                CSF011
117500200529                                                                                              CSF011
117600200529      ** Increment counter fields                                                             CSF011
117700200529                                                                                              CSF011
117800200529     C                   IF        W@Abc = 'A'                                                CSF011
117900200529     C                   Z-ADD     AccLength     W@Len                                        CSF011
118000200529     C                   ELSEIF    W@Abc = 'B'                                                CSF011
118100200529     C                   Z-ADD     ACusLngth     W@Len                                        CSF011
118200200529     C                   ELSE                                                                 CSF011
118300200529     C                   Z-ADD     CusLength     W@Len                                        CSF011
118400200529     C                   ENDIF                                                                CSF011
118500200529     C                   ENDIF                                                               CSF011A
118600200529                                                                                              CSF011
118700200529     C                   EVAL      CusIdx = Cusidx + 1                                        CSF011
118800200529     C                   EVAL      CusIdx2 = Cusidx2 + 35                                     CSF011
118900200529                                                                                              CSF011
119000200529     C                   ENDDO                                                                CSF011
119100200529                                                                                              CSF011
119200200529     C                   ENDSR                                                                CSF011
119300200529      *****************************************************************                      CSF011A
119400200529      /EJECT                                                                                 CSF011A
119500200529      *****************************************************************                      CSF011A
119600200529      *                                                               *                      CSF011A
119700200529      * SrXferCustName - Transfer Customer Details to Security Detls  *                      CSF011A
119800200529      *                                                               *                      CSF011A
119900200529      *****************************************************************                      CSF011A
120000200529     C     SrXferCustNameBEGSR                                                               CSF011A
120100200529                                                                                             CSF011A
120200200529     C                   SELECT                                                              CSF011A
120300200529      ** Counterparty                                                                        CSF011A
120400200529     C                   WHEN      CusIdx = 1                                                CSF011A
120500200529     C                   EVAL      DDCTSN = BBCSSN                                           CSF011A
120600200529     C                   EVAL      DDCTNM = BBCRNM                                           CSF011A
120700200529     C                   EVAL      DDCTTN = BBCRTN                                           CSF011A
120800200529      ** Pay From                                                                            CSF011A
120900200529     C                   WHEN      CusIdx = 2                                                CSF011A
121000200529     C                   EVAL      DDPFSN = BBCSSN                                           CSF011A
121100200529     C                   EVAL      DDPFNM = BBCRNM                                           CSF011A
121200200529     C                   EVAL      DDPFTN = BBCRTN                                           CSF011A
121300200529     C                   EVAL      DDPFAN = AC_ANAM                                          CSF011A
121400200529     C                   EVAL      DDPFSW = BBCSID                                           CSF011A
121500200529      ** Pay To                                                                              CSF011A
121600200529     C                   WHEN      CusIdx = 3                                                CSF011A
121700200529     C                   EVAL      DDPTSN = BBCSSN                                           CSF011A
121800200529     C                   EVAL      DDPTNM = BBCRNM                                           CSF011A
121900200529     C                   EVAL      DDPTTN = BBCRTN                                           CSF011A
122000200529     C                   EVAL      DDPTAN = AC_ANAM                                          CSF011A
122100200529     C                   EVAL      DDPTSW = BBCSID                                           CSF011A
122200200529      ** Pay to for Account Of                                                               CSF011A
122300200529     C                   WHEN      CusIdx = 4                                                CSF011A
122400200529     C                   EVAL      DDFASN = BBCSSN                                           CSF011A
122500200529     C                   EVAL      DDFANM = BBCRNM                                           CSF011A
122600200529     C                   EVAL      DDFATN = BBCRTN                                           CSF011A
122700200529     C                   EVAL      DDFASW = BBCSID                                           CSF011A
122800200529      ** Deliver From                                                                        CSF011A
122900200529     C                   WHEN      CusIdx = 5                                                CSF011A
123000200529     C                   EVAL      DDDFSN = BBCSSN                                           CSF011A
123100200529     C                   EVAL      DDDFNM = BBCRNM                                           CSF011A
123200200529     C                   EVAL      DDDFTN = BBCRTN                                           CSF011A
123300200529     C                   EVAL      DDDFSW = BBCSID                                           CSF011A
123400200529      ** Deliver To                                                                          CSF011A
123500200529     C                   WHEN      CusIdx = 6                                                CSF011A
123600200529     C                   EVAL      DDDTSN = BBCSSN                                           CSF011A
123700200529     C                   EVAL      DDDTNM = BBCRNM                                           CSF011A
123800200529     C                   EVAL      DDDTTN = BBCRTN                                           CSF011A
123900200529     C                   EVAL      DDDTSW = BBCSID                                           CSF011A
124000200529      ** Deliver from for Account Of                                                         CSF011A
124100200529     C                   WHEN      CusIdx = 7                                                CSF011A
124200200529     C                   EVAL      DDVFSN = BBCSSN                                           CSF011A
124300200529     C                   EVAL      DDVFNM = BBCRNM                                           CSF011A
124400200529     C                   EVAL      DDVFTN = BBCRTN                                           CSF011A
124500200529     C                   EVAL      DDVFSW = BBCSID                                           CSF011A
124600200529      ** Deliver to for Account Of                                                           CSF011A
124700200529     C                   WHEN      CusIdx = 8                                                CSF011A
124800200529     C                   EVAL      DDVTSN = BBCSSN                                           CSF011A
124900200529     C                   EVAL      DDVTNM = BBCRNM                                           CSF011A
125000200529     C                   EVAL      DDVTTN = BBCRTN                                           CSF011A
125100200529     C                   EVAL      DDVTSW = BBCSID                                           CSF011A
125200200529      ** Account for Payment 1                                                               CSF011A
125300200529     C                   WHEN      CusIdx = 9                                                CSF011A
125400200529     C                   EVAL      AESP1SN = BBCSSN                                          CSF011A
125500200529     C                   EVAL      AESP1NM = BBCRNM                                          CSF011A
125600200529     C                   EVAL      AESP1TN = BBCRTN                                          CSF011A
125700200529     C                   EVAL      AESP1SW = BBCSID                                          CSF011A
125800200529      ** Account for Payment 2                                                               CSF011A
125900200529     C                   WHEN      CusIdx = 10                                               CSF011A
126000200529     C                   EVAL      AESP2SN = BBCSSN                                          CSF011A
126100200529     C                   EVAL      AESP2NM = BBCRNM                                          CSF011A
126200200529     C                   EVAL      AESP2TN = BBCRTN                                          CSF011A
126300200529     C                   EVAL      AESP2SW = BBCSID                                          CSF011A
126400200529      ** Account with Institution                                                            CSF011A
126500200529     C                   WHEN      CusIdx = 11                                               CSF011A
126600200529     C                   EVAL      AESAWSN = BBCSSN                                          CSF011A
126700200529     C                   EVAL      AESAWNM = BBCRNM                                          CSF011A
126800200529     C                   EVAL      AESAWTN = BBCRTN                                          CSF011A
126900200529     C                   EVAL      AESAWSW = BBCSID                                          CSF011A
127000200529      ** Beneficiary Money                                                                   CSF011A
127100200529     C                   WHEN      CusIdx = 12                                               CSF011A
127200200529     C                   EVAL      AESBOSN = BBCSSN                                          CSF011A
127300200529     C                   EVAL      AESBONM = BBCRNM                                          CSF011A
127400200529     C                   EVAL      AESBOTN = BBCRTN                                          CSF011A
127500200529     C                   EVAL      AESBOSW = BBCSID                                          CSF011A
127600200529      ** Instructing Party                                                                   CSF011A
127700200529     C                   WHEN      CusIdx = 13                                               CSF011A
127800200529     C                   EVAL      AESIPSN = BBCSSN                                          CSF011A
127900200529     C                   EVAL      AESIPNM = BBCRNM                                          CSF011A
128000200529     C                   EVAL      AESIPTN = BBCRTN                                          CSF011A
128100200529     C                   EVAL      AESIPSW = BBCSID                                          CSF011A
128200200529      ** Investor                                                                            CSF011A
128300200529     C                   WHEN      CusIdx = 14                                               CSF011A
128400200529     C                   EVAL      AESIVSN = BBCSSN                                          CSF011A
128500200529     C                   EVAL      AESIVNM = BBCRNM                                          CSF011A
128600200529     C                   EVAL      AESIVTN = BBCRTN                                          CSF011A
128700200529     C                   EVAL      AESIVSW = BBCSID                                          CSF011A
128800200529      ** Counterparty safekeeper                                                             CSF011A
128900200529     C                   WHEN      CusIdx = 15                                               CSF011A
129000200529     C                   EVAL      AESCSSN = BBCSSN                                          CSF011A
129100200529     C                   EVAL      AESCSNM = BBCRNM                                          CSF011A
129200200529     C                   EVAL      AESCSTN = BBCRTN                                          CSF011A
129300200529     C                   EVAL      AESCSSW = BBCSID                                          CSF011A
129400200529      ** Safekeeping                                                                         CSF011A
129500200529     C                   WHEN      CusIdx = 16                                               CSF011A
129600200529     C                   EVAL      AESSKSN = BBCSSN                                          CSF011A
129700200529     C                   EVAL      AESSKNM = BBCRNM                                          CSF011A
129800200529     C                   EVAL      AESSKTN = BBCRTN                                          CSF011A
129900200529     C                   EVAL      AESSKSW = BBCSID                                          CSF011A
130000200529      ** Clearing Correspondent                                                              CSF011A
130100200529     C                   WHEN      CusIdx = 17                                               CSF011A
130200200529     C                   EVAL      AESCRSN = BBCSSN                                          CSF011A
130300200529     C                   EVAL      AESCRNM = BBCRNM                                          CSF011A
130400200529     C                   EVAL      AESCRTN = BBCRTN                                          CSF011A
130500200529     C                   EVAL      AESCRSW = BBCSID                                          CSF011A
130600200529      ** Receiver of Securities                                                              CSF011A
130700200529     C                   WHEN      CusIdx = 18                                               CSF011A
130800200529     C                   EVAL      AESRESN = BBCSSN                                          CSF011A
130900200529     C                   EVAL      AESRENM = BBCRNM                                          CSF011A
131000200529     C                   EVAL      AESRETN = BBCRTN                                          CSF011A
131100200529     C                   EVAL      AESRESW = BBCSID                                          CSF011A
131200200529      ** Intermediary 1                                                                      CSF011A
131300200529     C                   WHEN      CusIdx = 19                                               CSF011A
131400200529     C                   EVAL      AESI1SN = BBCSSN                                          CSF011A
131500200529     C                   EVAL      AESI1NM = BBCRNM                                          CSF011A
131600200529     C                   EVAL      AESI1TN = BBCRTN                                          CSF011A
131700200529     C                   EVAL      AESI1SW = BBCSID                                          CSF011A
131800200529      ** Intermediary 2                                                                      CSF011A
131900200529     C                   WHEN      CusIdx = 20                                               CSF011A
132000200529     C                   EVAL      AESI2SN = BBCSSN                                          CSF011A
132100200529     C                   EVAL      AESI2NM = BBCRNM                                          CSF011A
132200200529     C                   EVAL      AESI2TN = BBCRTN                                          CSF011A
132300200529     C                   EVAL      AESI2SW = BBCSID                                          CSF011A
132400200529      ** Placement of Settlement                                                             CSF011A
132500200529     C                   WHEN      CusIdx = 21                                               CSF011A
132600200529     C                   EVAL      AESPSSN = BBCSSN                                          CSF011A
132700200529     C                   EVAL      AESPSNM = BBCRNM                                          CSF011A
132800200529     C                   EVAL      AESPSTN = BBCRTN                                          CSF011A
132900200529     C                   EVAL      AESPSSW = BBCSID                                          CSF011A
133000200529     C                   ENDSL                                                               CSF011A
133100200529     C                                                                                       CSF011A
133200200529     C                   ENDSR                                                               CSF011A
133300200529      *****************************************************************                      CSF011A
133400200529      /EJECT                                                                                 CSF011A
133500200529      *****************************************************************                      CSF011A
133600200529      *                                                               *                      CSF011A
133700200529      * SrCustname2 - Get the Customer details for Settle Details 2   *                      CSF011A
133800200529      *                                                               *                      CSF011A
133900200529      *****************************************************************                      CSF011A
134000200529     C     SrCustName2   BEGSR                                                               CSF011A
134100200529     C                   CLEAR                   WNumDetlIn                                  CSF011A
134200200529      ** Customer fields for retrieval of details                                            CSF011A
134300200529     C                   EVAL      %SUBST(WNumDetlIn:1:35)   = BESAP1N                       CSF011A
134400200529     C                   EVAL      %SUBST(WNumDetlIn:36:35)  = BESAP2N                       CSF011A
134500200529     C                   EVAL      %SUBST(WNumDetlIn:71:35)  = BESAWIN                       CSF011A
134600200529     C                   EVAL      %SUBST(WNumDetlIn:106:35) = BESBOFN                       CSF011A
134700200529     C                   EVAL      %SUBST(WNumDetlIn:141:35) = BESIPYN                       CSF011A
134800200529     C                   EVAL      %SUBST(WNumDetlIn:176:35) = BESINVE                       CSF011A
134900200529     C                   EVAL      %SUBST(WNumDetlIn:211:35) = BESSA1N                       CSF011A
135000200529     C                   EVAL      %SUBST(WNumDetlIn:246:35) = BESSKAN                       CSF011A
135100200529     C                   EVAL      %SUBST(WNumDetlIn:281:35) = BESCCTN                       CSF011A
135200200529     C                   EVAL      %SUBST(WNumDetlIn:316:35) = BESRSSN                       CSF011A
135300200529     C                   EVAL      %SUBST(WNumDetlIn:351:35) = BESIMMD1                      CSF011A
135400200529     C                   EVAL      %SUBST(WNumDetlIn:386:35) = BESIMMD2                      CSF011A
135500200529     C                   EVAL      %SUBST(WNumDetlIn:421:35) = BESPSET                       CSF011A
135600200529     C                   EVAL      CusIdx = 1                                                CSF011A
135700200529     C                   EVAL      CusIdx2 = 1                                               CSF011A
135800200529                                                                                             CSF011A
135900200529     C                   DOW       CusIdx <= NoOfCusField2                                   CSF011A
136000200529                                                                                             CSF011A
136100200529     C                   EVAL      P@Str = %SUBST(WNumDetlIn:CusIdx2:35)                     CSF011A
136200200529                                                                                             CSF011A
136300200529     C                   IF        P@Str <> *BLANKS                                          CSF011A
136400200529                                                                                             CSF011A
136500200529     C                   CALL      'AOCUSTR0'                                                CSF011A
136600200529     C                   PARM      *BLANKS       @RTCD                                       CSF011A
136700200529     C                   PARM      '*KEY'        @OPTN                                       CSF011A
136800200529     C                   PARM                    P@Str                                       CSF011A
136900200529     C                   PARM      *BLANKS       C#KYST                                      CSF011A
137000200529     C     SDCUST        PARM      SDCUST        DSSDY                                       CSF011A
137100200529                                                                                             CSF011A
137200200529     C                   IF        @RTCD = *BLANKS                                           CSF011A
137300200529     C                   EXSR      SrXferCustNam2                                            CSF011A
137400200529     C                   ENDIF                                                               CSF011A
137500200529                                                                                             CSF011A
137600200529     C                   ENDIF                                                               CSF011A
137700200529                                                                                             CSF011A
137800200529      ** Increment counter fields                                                            CSF011A
137900200529                                                                                             CSF011A
138000200529     C                   EVAL      CusIdx = Cusidx + 1                                       CSF011A
138100200529     C                   EVAL      CusIdx2 = Cusidx2 + 35                                    CSF011A
138200200529                                                                                             CSF011A
138300200529     C                   ENDDO                                                               CSF011A
138400200529                                                                                             CSF011A
138500200529     C                   ENDSR                                                               CSF011A
138600200529      *****************************************************************                      CSF011A
138700200529      /EJECT                                                                                 CSF011A
138800200529      *****************************************************************                      CSF011A
138900200529      *                                                               *                      CSF011A
139000200529      * SrXferCustNam2 - Transfer Customer Details to Security Detls2 *                      CSF011A
139100200529      *                                                               *                      CSF011A
139200200529      *****************************************************************                      CSF011A
139300200529     C     SrXferCustNam2BEGSR                                                               CSF011A
139400200529     C                   SELECT                                                              CSF011A
139500200529      ** Account for Payment 1                                                               CSF011A
139600200529     C                   WHEN      CusIdx = 1                                                CSF011A
139700200529     C                   EVAL      BESP1SN = BBCSSN                                          CSF011A
139800200529     C                   EVAL      BESP1NM = BBCRNM                                          CSF011A
139900200529     C                   EVAL      BESP1TN = BBCRTN                                          CSF011A
140000200529     C                   EVAL      BESP1SW = BBCSID                                          CSF011A
140100200529      ** Account for Payment 2                                                               CSF011A
140200200529     C                   WHEN      CusIdx = 2                                                CSF011A
140300200529     C                   EVAL      BESP2SN = BBCSSN                                          CSF011A
140400200529     C                   EVAL      BESP2NM = BBCRNM                                          CSF011A
140500200529     C                   EVAL      BESP2TN = BBCRTN                                          CSF011A
140600200529     C                   EVAL      BESP2SW = BBCSID                                          CSF011A
140700200529      ** Account with Institution                                                            CSF011A
140800200529     C                   WHEN      CusIdx = 3                                                CSF011A
140900200529     C                   EVAL      BESAWSN = BBCSSN                                          CSF011A
141000200529     C                   EVAL      BESAWNM = BBCRNM                                          CSF011A
141100200529     C                   EVAL      BESAWTN = BBCRTN                                          CSF011A
141200200529     C                   EVAL      BESAWSW = BBCSID                                          CSF011A
141300200529      ** Beneficiary Money                                                                   CSF011A
141400200529     C                   WHEN      CusIdx = 4                                                CSF011A
141500200529     C                   EVAL      BESBOSN = BBCSSN                                          CSF011A
141600200529     C                   EVAL      BESBONM = BBCRNM                                          CSF011A
141700200529     C                   EVAL      BESBOTN = BBCRTN                                          CSF011A
141800200529     C                   EVAL      BESBOSW = BBCSID                                          CSF011A
141900200529      ** Instructing Party                           I                                       CSF011A
142000200529     C                   WHEN      CusIdx = 5                                                CSF011A
142100200529     C                   EVAL      BESIPSN = BBCSSN                                          CSF011A
142200200529     C                   EVAL      BESIPNM = BBCRNM                                          CSF011A
142300200529     C                   EVAL      BESIPTN = BBCRTN                                          CSF011A
142400200529     C                   EVAL      BESIPSW = BBCSID                                          CSF011A
142500200529      ** Investor                                                                            CSF011A
142600200529     C                   WHEN      CusIdx = 6                                                CSF011A
142700200529     C                   EVAL      BESIVSN = BBCSSN                                          CSF011A
142800200529     C                   EVAL      BESIVNM = BBCRNM                                          CSF011A
142900200529     C                   EVAL      BESIVTN = BBCRTN                                          CSF011A
143000200529     C                   EVAL      BESIVSW = BBCSID                                          CSF011A
143100200529      ** Counterparty safekeeper                                                             CSF011A
143200200529     C                   WHEN      CusIdx = 7                                                CSF011A
143300200529     C                   EVAL      BESCSSN = BBCSSN                                          CSF011A
143400200529     C                   EVAL      BESCSNM = BBCRNM                                          CSF011A
143500200529     C                   EVAL      BESCSTN = BBCRTN                                          CSF011A
143600200529     C                   EVAL      BESCSSW = BBCSID                                          CSF011A
143700200529      ** Safekeeping                                                                         CSF011A
143800200529     C                   WHEN      CusIdx = 8                                                CSF011A
143900200529     C                   EVAL      BESSKSN = BBCSSN                                          CSF011A
144000200529     C                   EVAL      BESSKNM = BBCRNM                                          CSF011A
144100200529     C                   EVAL      BESSKTN = BBCRTN                                          CSF011A
144200200529     C                   EVAL      BESSKSW = BBCSID                                          CSF011A
144300200529      ** Clearing Correspondent                                                              CSF011A
144400200529     C                   WHEN      CusIdx = 9                                                CSF011A
144500200529     C                   EVAL      BESCRSN = BBCSSN                                          CSF011A
144600200529     C                   EVAL      BESCRNM = BBCRNM                                          CSF011A
144700200529     C                   EVAL      BESCRTN = BBCRTN                                          CSF011A
144800200529     C                   EVAL      BESCRSW = BBCSID                                          CSF011A
144900200529      ** Receiver of Securities                                                              CSF011A
145000200529     C                   WHEN      CusIdx = 10                                               CSF011A
145100200529     C                   EVAL      BESRESN = BBCSSN                                          CSF011A
145200200529     C                   EVAL      BESRENM = BBCRNM                                          CSF011A
145300200529     C                   EVAL      BESRETN = BBCRTN                                          CSF011A
145400200529     C                   EVAL      BESRESW = BBCSID                                          CSF011A
145500200529      ** Intermediary 1                                                                      CSF011A
145600200529     C                   WHEN      CusIdx = 11                                               CSF011A
145700200529     C                   EVAL      BESI1SN = BBCSSN                                          CSF011A
145800200529     C                   EVAL      BESI1NM = BBCRNM                                          CSF011A
145900200529     C                   EVAL      BESI1TN = BBCRTN                                          CSF011A
146000200529     C                   EVAL      BESI1SW = BBCSID                                          CSF011A
146100200529      ** Intermediary 2                                                                      CSF011A
146200200529     C                   WHEN      CusIdx = 12                                               CSF011A
146300200529     C                   EVAL      BESI2SN = BBCSSN                                          CSF011A
146400200529     C                   EVAL      BESI2NM = BBCRNM                                          CSF011A
146500200529     C                   EVAL      BESI2TN = BBCRTN                                          CSF011A
146600200529     C                   EVAL      BESI2SW = BBCSID                                          CSF011A
146700200529      ** Placement of Settlement                                                             CSF011A
146800200529     C                   WHEN      CusIdx = 13                                               CSF011A
146900200529     C                   EVAL      BESPSSN = BBCSSN                                          CSF011A
147000200529     C                   EVAL      BESPSNM = BBCRNM                                          CSF011A
147100200529     C                   EVAL      BESPSTN = BBCRTN                                          CSF011A
147200200529     C                   EVAL      BESPSSW = BBCSID                                          CSF011A
147300200529     C                   ENDSL                                                               CSF011A
147400200529     C                                                                                       CSF011A
147500200529     C                   ENDSR                                                               CSF011A
147600200529      ********************************************************************
147700200529      /EJECT
147800200529      *****************************************************************
147900200529      *                                                               *
148000200529      * RESETCYCLE- Reset error information that is gradually         *
148100200529      *             updated during each run of this program           *
148200200529      *                                                               *
148300200529      *****************************************************************
148400200529     C     RESETCYCLE    BEGSR
148500200529
148600200529     C                   RESET                   FldNameArr
148700200529     C                   RESET                   MsgIDArr
148800200529     C                   RESET                   MsgDtaArr
148900200529     C                   RESET                   Idx
149000200529
149100200529     C                   RESET                   WFldNamArr
149200200529     C                   RESET                   WMsgIDArr
149300200529     C                   RESET                   WMsgDtaArr
149400200529     C                   RESET                   WIdx
149500200529
149600200529     C                   RESET                   AmFldNamAr
149700200529     C                   RESET                   AmMsgIDArr
149800200529     C                   RESET                   AmMsgDtaAr
149900200529     C                   RESET                   AmIdx
150000200529
150100200529     C                   RESET                   FldNoArr
150200200529
150300200529     C                   CLEAR                   CurTrPrim
150400200529     C                   CLEAR                   CurTrSeco
150500200529     C                   CLEAR                   CurTrThir
150600200529     C                   CLEAR                   CurTrExch
150700200529     C                   CLEAR                   CurTrSett
150800200529     C                   CLEAR                   CurTrChcm
150900200529     C                   CLEAR                   CurTrSwftA
151000200529     C                   CLEAR                   CurTrSwftB
151100200529     C                   CLEAR                   CurX2SwftA
151200200529     C                   CLEAR                   CurX2SwftB
151300200529      **Initialise Customer Name on input fields                                             CSF011A
151400200529      ** Counterparty                                                                        CSF011A
151500200529     C                   EVAL      DDCTSN = *BLANKS                                          CSF011A
151600200529     C                   EVAL      DDCTNM = *BLANKS                                          CSF011A
151700200529     C                   EVAL      DDCTTN = *BLANKS                                          CSF011A
151800200529      ** Pay From                                                                            CSF011A
151900200529     C                   EVAL      DDPFSN = *BLANKS                                          CSF011A
152000200529     C                   EVAL      DDPFNM = *BLANKS                                          CSF011A
152100200529     C                   EVAL      DDPFTN = *BLANKS                                          CSF011A
152200200529     C                   EVAL      DDPFAN = *BLANKS                                          CSF011A
152300200529     C                   EVAL      DDPFSW = *BLANKS                                          CSF011A
152400200529      ** Pay To                                                                              CSF011A
152500200529     C                   EVAL      DDPTSN = *BLANKS                                          CSF011A
152600200529     C                   EVAL      DDPTNM = *BLANKS                                          CSF011A
152700200529     C                   EVAL      DDPTTN = *BLANKS                                          CSF011A
152800200529     C                   EVAL      DDPTAN = *BLANKS                                          CSF011A
152900200529     C                   EVAL      DDPTSW = *BLANKS                                          CSF011A
153000200529      ** Pay to for Account Of                                                               CSF011A
153100200529     C                   EVAL      DDFASN = *BLANKS                                          CSF011A
153200200529     C                   EVAL      DDFANM = *BLANKS                                          CSF011A
153300200529     C                   EVAL      DDFATN = *BLANKS                                          CSF011A
153400200529     C                   EVAL      DDFASW = *BLANKS                                          CSF011A
153500200529      ** Deliver From                                                                        CSF011A
153600200529     C                   EVAL      DDDFSN = *BLANKS                                          CSF011A
153700200529     C                   EVAL      DDDFNM = *BLANKS                                          CSF011A
153800200529     C                   EVAL      DDDFTN = *BLANKS                                          CSF011A
153900200529     C                   EVAL      DDDFSW = *BLANKS                                          CSF011A
154000200529      ** Deliver To                                                                          CSF011A
154100200529     C                   EVAL      DDDTSN = *BLANKS                                          CSF011A
154200200529     C                   EVAL      DDDTNM = *BLANKS                                          CSF011A
154300200529     C                   EVAL      DDDTTN = *BLANKS                                          CSF011A
154400200529     C                   EVAL      DDDTSW = *BLANKS                                          CSF011A
154500200529      ** Deliver from for Account Of                                                         CSF011A
154600200529     C                   EVAL      DDVFSN = *BLANKS                                          CSF011A
154700200529     C                   EVAL      DDVFNM = *BLANKS                                          CSF011A
154800200529     C                   EVAL      DDVFTN = *BLANKS                                          CSF011A
154900200529     C                   EVAL      DDVFSW = *BLANKS                                          CSF011A
155000200529      ** Deliver to for Account Of                                                           CSF011A
155100200529     C                   EVAL      DDVTSN = *BLANKS                                          CSF011A
155200200529     C                   EVAL      DDVTNM = *BLANKS                                          CSF011A
155300200529     C                   EVAL      DDVTTN = *BLANKS                                          CSF011A
155400200529     C                   EVAL      DDVTSW = *BLANKS                                          CSF011A
155500200529      ** SET A                                                                               CSF011A
155600200529      ** Account for Payment 1                                                               CSF011A
155700200529     C                   EVAL      AESP1SN = *BLANKS                                         CSF011A
155800200529     C                   EVAL      AESP1NM = *BLANKS                                         CSF011A
155900200529     C                   EVAL      AESP1TN = *BLANKS                                         CSF011A
156000200529     C                   EVAL      AESP1SW = *BLANKS                                         CSF011A
156100200529      ** Account for Payment 2                                                               CSF011A
156200200529     C                   EVAL      AESP2SN = *BLANKS                                         CSF011A
156300200529     C                   EVAL      AESP2NM = *BLANKS                                         CSF011A
156400200529     C                   EVAL      AESP2TN = *BLANKS                                         CSF011A
156500200529     C                   EVAL      AESP2SW = *BLANKS                                         CSF011A
156600200529      ** Account with Institution                                                            CSF011A
156700200529     C                   EVAL      AESAWSN = *BLANKS                                         CSF011A
156800200529     C                   EVAL      AESAWNM = *BLANKS                                         CSF011A
156900200529     C                   EVAL      AESAWTN = *BLANKS                                         CSF011A
157000200529     C                   EVAL      AESAWSW = *BLANKS                                         CSF011A
157100200529      ** Beneficiary Money                                                                   CSF011A
157200200529     C                   EVAL      AESBOSN = *BLANKS                                         CSF011A
157300200529     C                   EVAL      AESBONM = *BLANKS                                         CSF011A
157400200529     C                   EVAL      AESBOTN = *BLANKS                                         CSF011A
157500200529     C                   EVAL      AESBOSW = *BLANKS                                         CSF011A
157600200529      ** Instructing Party                                                                   CSF011A
157700200529     C                   EVAL      AESIPSN = *BLANKS                                         CSF011A
157800200529     C                   EVAL      AESIPNM = *BLANKS                                         CSF011A
157900200529     C                   EVAL      AESIPTN = *BLANKS                                         CSF011A
158000200529     C                   EVAL      AESIPSW = *BLANKS                                         CSF011A
158100200529      ** Investor                                                                            CSF011A
158200200529     C                   EVAL      AESIVSN = *BLANKS                                         CSF011A
158300200529     C                   EVAL      AESIVNM = *BLANKS                                         CSF011A
158400200529     C                   EVAL      AESIVTN = *BLANKS                                         CSF011A
158500200529     C                   EVAL      AESIVSW = *BLANKS                                         CSF011A
158600200529      ** Counterparty safekeeper                                                             CSF011A
158700200529     C                   EVAL      AESCSSN = *BLANKS                                         CSF011A
158800200529     C                   EVAL      AESCSNM = *BLANKS                                         CSF011A
158900200529     C                   EVAL      AESCSTN = *BLANKS                                         CSF011A
159000200529     C                   EVAL      AESCSSW = *BLANKS                                         CSF011A
159100200529      ** Safekeeping                                                                         CSF011A
159200200529     C                   EVAL      AESSKSN = *BLANKS                                         CSF011A
159300200529     C                   EVAL      AESSKNM = *BLANKS                                         CSF011A
159400200529     C                   EVAL      AESSKTN = *BLANKS                                         CSF011A
159500200529     C                   EVAL      AESSKSW = *BLANKS                                         CSF011A
159600200529      ** Clearing Correspondent                                                              CSF011A
159700200529     C                   EVAL      AESCRSN = *BLANKS                                         CSF011A
159800200529     C                   EVAL      AESCRNM = *BLANKS                                         CSF011A
159900200529     C                   EVAL      AESCRTN = *BLANKS                                         CSF011A
160000200529     C                   EVAL      AESCRSW = *BLANKS                                         CSF011A
160100200529      ** Receiver of Securities                                                              CSF011A
160200200529     C                   EVAL      AESRESN = *BLANKS                                         CSF011A
160300200529     C                   EVAL      AESRENM = *BLANKS                                         CSF011A
160400200529     C                   EVAL      AESRETN = *BLANKS                                         CSF011A
160500200529     C                   EVAL      AESRESW = *BLANKS                                         CSF011A
160600200529      ** Intermediary 1                                                                      CSF011A
160700200529     C                   EVAL      AESI1SN = *BLANKS                                         CSF011A
160800200529     C                   EVAL      AESI1NM = *BLANKS                                         CSF011A
160900200529     C                   EVAL      AESI1TN = *BLANKS                                         CSF011A
161000200529     C                   EVAL      AESI1SW = *BLANKS                                         CSF011A
161100200529      ** Intermediary 2                                                                      CSF011A
161200200529     C                   EVAL      AESI2SN = *BLANKS                                         CSF011A
161300200529     C                   EVAL      AESI2NM = *BLANKS                                         CSF011A
161400200529     C                   EVAL      AESI2TN = *BLANKS                                         CSF011A
161500200529     C                   EVAL      AESI2SW = *BLANKS                                         CSF011A
161600200529      ** Placement of Settlement                                                             CSF011A
161700200529     C                   EVAL      AESPSSN = *BLANKS                                         CSF011A
161800200529     C                   EVAL      AESPSNM = *BLANKS                                         CSF011A
161900200529     C                   EVAL      AESPSTN = *BLANKS                                         CSF011A
162000200529     C                   EVAL      AESPSSW = *BLANKS                                         CSF011A
162100200529      ** SET B                                                                               CSF011A
162200200529      ** Account for Payment 1                                                               CSF011A
162300200529     C                   EVAL      BESP1SN = *BLANKS                                         CSF011A
162400200529     C                   EVAL      BESP1NM = *BLANKS                                         CSF011A
162500200529     C                   EVAL      BESP1TN = *BLANKS                                         CSF011A
162600200529     C                   EVAL      BESP1SW = *BLANKS                                         CSF011A
162700200529      ** Account for Payment 2                                                               CSF011A
162800200529     C                   EVAL      BESP2SN = *BLANKS                                         CSF011A
162900200529     C                   EVAL      BESP2NM = *BLANKS                                         CSF011A
163000200529     C                   EVAL      BESP2TN = *BLANKS                                         CSF011A
163100200529     C                   EVAL      BESP2SW = *BLANKS                                         CSF011A
163200200529      ** Account with Institution                                                            CSF011A
163300200529     C                   EVAL      BESAWSN = *BLANKS                                         CSF011A
163400200529     C                   EVAL      BESAWNM = *BLANKS                                         CSF011A
163500200529     C                   EVAL      BESAWTN = *BLANKS                                         CSF011A
163600200529     C                   EVAL      BESAWSW = *BLANKS                                         CSF011A
163700200529      ** Beneficiary Money                                                                   CSF011A
163800200529     C                   EVAL      BESBOSN = *BLANKS                                         CSF011A
163900200529     C                   EVAL      BESBONM = *BLANKS                                         CSF011A
164000200529     C                   EVAL      BESBOTN = *BLANKS                                         CSF011A
164100200529     C                   EVAL      BESBOSW = *BLANKS                                         CSF011A
164200200529      ** Instructing Party                           I                                       CSF011A
164300200529     C                   EVAL      BESIPSN = *BLANKS                                         CSF011A
164400200529     C                   EVAL      BESIPNM = *BLANKS                                         CSF011A
164500200529     C                   EVAL      BESIPTN = *BLANKS                                         CSF011A
164600200529     C                   EVAL      BESIPSW = *BLANKS                                         CSF011A
164700200529      ** Investor                                                                            CSF011A
164800200529     C                   EVAL      BESIVSN = *BLANKS                                         CSF011A
164900200529     C                   EVAL      BESIVNM = *BLANKS                                         CSF011A
165000200529     C                   EVAL      BESIVTN = *BLANKS                                         CSF011A
165100200529     C                   EVAL      BESIVSW = *BLANKS                                         CSF011A
165200200529      ** Counterparty safekeeper                                                             CSF011A
165300200529     C                   EVAL      BESCSSN = *BLANKS                                         CSF011A
165400200529     C                   EVAL      BESCSNM = *BLANKS                                         CSF011A
165500200529     C                   EVAL      BESCSTN = *BLANKS                                         CSF011A
165600200529     C                   EVAL      BESCSSW = *BLANKS                                         CSF011A
165700200529      ** Safekeeping                                                                         CSF011A
165800200529     C                   EVAL      BESSKSN = *BLANKS                                         CSF011A
165900200529     C                   EVAL      BESSKNM = *BLANKS                                         CSF011A
166000200529     C                   EVAL      BESSKTN = *BLANKS                                         CSF011A
166100200529     C                   EVAL      BESSKSW = *BLANKS                                         CSF011A
166200200529      ** Clearing Correspondent                                                              CSF011A
166300200529     C                   EVAL      BESCRSN = *BLANKS                                         CSF011A
166400200529     C                   EVAL      BESCRNM = *BLANKS                                         CSF011A
166500200529     C                   EVAL      BESCRTN = *BLANKS                                         CSF011A
166600200529     C                   EVAL      BESCRSW = *BLANKS                                         CSF011A
166700200529      ** Receiver of Securities                                                              CSF011A
166800200529     C                   EVAL      BESRESN = *BLANKS                                         CSF011A
166900200529     C                   EVAL      BESRENM = *BLANKS                                         CSF011A
167000200529     C                   EVAL      BESRETN = *BLANKS                                         CSF011A
167100200529     C                   EVAL      BESRESW = *BLANKS                                         CSF011A
167200200529      ** Intermediary 1                                                                      CSF011A
167300200529     C                   EVAL      BESI1SN = *BLANKS                                         CSF011A
167400200529     C                   EVAL      BESI1NM = *BLANKS                                         CSF011A
167500200529     C                   EVAL      BESI1TN = *BLANKS                                         CSF011A
167600200529     C                   EVAL      BESI1SW = *BLANKS                                         CSF011A
167700200529      ** Intermediary 2                                                                      CSF011A
167800200529     C                   EVAL      BESI2SN = *BLANKS                                         CSF011A
167900200529     C                   EVAL      BESI2NM = *BLANKS                                         CSF011A
168000200529     C                   EVAL      BESI2TN = *BLANKS                                         CSF011A
168100200529     C                   EVAL      BESI2SW = *BLANKS                                         CSF011A
168200200529      ** Placement of Settlement                                                             CSF011A
168300200529     C                   EVAL      BESPSSN = *BLANKS                                         CSF011A
168400200529     C                   EVAL      BESPSNM = *BLANKS                                         CSF011A
168500200529     C                   EVAL      BESPSTN = *BLANKS                                         CSF011A
168600200529     C                   EVAL      BESPSSW = *BLANKS                                         CSF011A
168700200529                                                                                             CSF011A
168800200529
168900200529     C                   MOVE      *ALL'Y'       OKTrPrim
169000200529     C                   MOVE      *ALL'Y'       OKTrSeco
169100200529     C                   MOVE      *ALL'Y'       OKTrThir
169200200529     C                   MOVE      *ALL'Y'       OKTrExch
169300200529     C                   MOVE      *ALL'Y'       OKTrSett
169400200529     C                   MOVE      *ALL'Y'       OKTrChcm
169500200529     C                   MOVE      *ALL'Y'       OKTrSwft
169600200529     C                   MOVE      *ALL'Y'       OKX2Swft
169700200529
169800200529     C                   CLEAR                   ValidTrad
169900200529     C                   CLEAR                   ValidTX1A
170000200529     C                   CLEAR                   ValidTX1B
170100200529     C                   CLEAR                   ValidTX2A
170200200529     C                   CLEAR                   ValidTX2B
170300200529      *
170400200529      ** Also clear numeric variables
170500200529      *
170600200529     C**********         Z-ADD     0             V_TCNR                                      CSD027A
170700200529     C                   Eval      V_TCNR = *Blanks                                          CSD027A
170800200529     C                   Z-ADD     0             V_NOML
170900200529     C                   Z-ADD     0             V_TNMD
171000200529     C                   Z-ADD     0             V_TPDY
171100200529     C                   Z-ADD     0             V_TDVD
171200200529     C                   Z-ADD     0             V_TDDT
171300200529     C                   Z-ADD     0             V_TCAP
171400200529     C                   Z-ADD     0             V_DADJ
171500200529     C                   Z-ADD     0             V_ITRA
171600200529     C                   Z-ADD     0             V_TINA
171700200529     C                   Z-ADD     0             V_TDCR
171800200529     C                   Z-ADD     0             V_PRIC
171900200529     C                   Z-ADD     0             V_RALL
172000200529     C                   Z-ADD     0             V_TDER
172100200529     C                   Z-ADD     0             V_TBCR
172200200529     C                   Z-ADD     0             V_SMTH
172300200529     C                   Z-ADD     0             V_ASNM
172400200529     C**********         Z-ADD     0             V_DELT                                      CSD027A
172500200529     C**********         Z-ADD     0             V_DELF                                      CSD027A
172600200529     C                   Eval      V_DELT = *blanks                                          CSD027A
172700200529     C                   Eval      V_DELF = *blanks                                          CSD027A
172800200529     C                   Z-ADD     0             V_TBCA
172900200529     C                   Z-ADD     0             V_TCCA
173000200529     C                   Z-ADD     0             V_TCA1
173100200529     C                   Z-ADD     0             V_TCA2
173200200529     C                   Z-ADD     0             V_TCA3
173300200529     C                   Z-ADD     0             V_TCA4
173400200529     C                   Z-ADD     0             V_TCA5
173500200529     C                   Z-ADD     0             V_TCA6
173600200529     C                   Z-ADD     0             V_TCA7
173700200529     C                   Z-ADD     0             V_TAXA
173800200529     C                   Z-ADD     0             V_BCMR
173900200529     C                   Z-ADD     0             V_CCMR
174000200529     C                   Z-ADD     0             V_TXRB
174100200529     C                   Z-ADD     0             V_TIME
174200200529     C                   Z-ADD     0             V_TOSN
174300200529     C                   Z-ADD     0             V_TNSN
174400200529     C                   Z-ADD     0             V_TNSP
174500200529     C                   Z-ADD     0             V_TOSV
174600200529     C                   Z-ADD     0             V_TVSN
174700200529     C                   Z-ADD     0             V_TVSP
174800200529     C                   Z-ADD     0             V_TDSN
174900200529     C                   Z-ADD     0             V_TDSP
175000200529     C                   Z-ADD     0             V_TDFS
175100200529     C                   Z-ADD     0             V_TSSQ
175200200529     C                   Z-ADD     0             V_TCSR
175300200529     C                   Z-ADD     0             V_TCTR
175400200529     C                   Z-ADD     0             V_TDMC
175500200529     C                   Z-ADD     0             V_TOED
175600200529     C                   Z-ADD     0             V_LCD
175700200529     C                   Z-ADD     0             V_TNLU
175800200529     C                   Z-ADD     0             V_LSWS
175900200529     C                   Z-ADD     0             V_TCFC
176000200529     C                   Z-ADD     0             V_SPXR
176100200529     C                   Z-ADD     0             V_FXMP
176200200529     C                   Z-ADD     0             V_FXMR
176300200529     C                   Z-ADD     0             V_MAMT
176400200529     C                   Z-ADD     0             V_ORDE
176500200529     C                   Z-ADD     0             V_WHTX
176600200529     C                   Z-ADD     0             VA_T1LSWS
176700200529     C                   Z-ADD     0             VA_T1LSSC
176800200529     C                   Z-ADD     0             VB_T1LSWS
176900200529     C                   Z-ADD     0             VB_T1LSSC
177000200529
177100200529     C                   ENDSR
177200200529      *****************************************************************
177300200529      /EJECT
177400200529      *****************************************************************
177500200529      *                                                               *
177600200529      * ValidateAc - Routine to validate action code versus the       *
177700200529      *              transaction number supplied                      *
177800200529      *                                                               *
177900200529      *****************************************************************
178000200529     C     ValidateAc    BEGSR
178100200529      *
178200200529      **Set*retrieve*mode*to*'*FRONT'*(Access*using*Front*Office*ID)****                      CAP087
178300200529      ***if*insert******************************************************                      CAP087
178400200529      ***if*not*insert*and*Midas*transaction*ID*is*not*present**********                      CAP087
178500200529      **Otherwise*******************************************************                      CAP087
178600200529      ***Set*retrieve*mode*to*blank**(Access*using*Midas*transaction*ID).                     CAP087
178700200529      *
178800200529     C*****DDACTN        IFEQ      'I'                                                        CAP087
178900200529     C***********        MOVEL     '*FRONT'      ModeofOp                                     CAP087
179000200529     C***********        ELSE                                                                 CAP087
179100200529     C*****DDTDRF        IFEQ      *BLANK                                                     CAP087
179200200529     C***********        MOVEL     '*FRONT'      ModeofOp                                     CAP087
179300200529     C***********        ELSE                                                                 CAP087
179400200529     C                   MOVEL     '      '      ModeofOp
179500200529     C***********        ENDIF                                                                CAP087
179600200529     C***********        ENDIF                                                                CAP087
179700200529
179800200529     C                   IF        APFOTRANID <> *BLANKS AND                                AR971184
179900200529     C                             DDACTN = 'I'                                             AR971184
180000200529     C                   EVAL      ModeOfOp = '*FRONT'                                      AR971184
180100200529     C                   ELSE                                                               AR971184
180200200529     C                   EVAL      ModeOfOp = *BLANKS                                       AR971184
180300200529     C                   ENDIF                                                              AR971184
180400200529      * Validate action code versus transaction IDs supplied
180500200529      * This function will set the Midas trade reference
180600200529      * The trade in file format from the SE database is retrieved as well.
180700200529
180800200529     C                   RESET                   ReturnCode
180900200529     C                   CALLB     'SETRADRTV'
181000200529      *
181100200529      * INPUTS
181200200529      *
181300200529      * Return code
181400200529     C                   PARM                    ReturnCode
181500200529      *
181600200529      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
181700200529      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
181800200529      *
181900200529     C                   PARM                    ModeofOp          6
182000200529      *
182100200529      * Response mode
182200200529     C                   PARM      'S'           APRESPMODE
182300200529      *
182400200529      * Action Code
182500200529     C                   PARM                    DDACTN            1
182600200529      *
182700200529      * Front Office Transaction ID
182800200529     C                   PARM                    APFOTranID
182900200529      *
183000200529      * (Midas) Trade Reference
183100200529     C                   PARM                    DDTDRF            6
183200200529      *
183300200529      * MT5XX - Phase 2 Message Generation is on.
183400200529     C                   PARM                    CSW003
183500200529      *
183600200529      * Buy-sell back
183700200529     C                   PARM                    PFBYSL            1
183800200529      *
183900200529      * Trade Reference
184000200529     C                   PARM                    PFTDRF            6
184100200529      *
184200200529      * OUTPUTS
184300200529      *
184400200529      * (Current) trade in file format
184500200529      * (Current) trade extension in file format
184600200529     C                   PARM                    TradFilFmt
184700200529     C                   PARM                    TX1AFilFmt
184800200529     C                   PARM                    TX1BFilFmt
184900200529      *
185000200529      * OK - Action code
185100200529     C                   PARM                    DDActnOK          1
185200200529      *
185300200529      * OK - Trade Reference
185400200529     C                   PARM                    DDTdrfOK          1
185500200529      *
185600200529      * Error fields/message IDs/message data (arrays) from/to caller
185700200529     C                   PARM                    FldNameArr
185800200529     C                   PARM                    MsgIdArr
185900200529     C                   PARM                    MsgDtaArr
186000200529      *
186100200529      * Array index (3P0) from/to caller
186200200529     C                   PARM                    Idx
186300200529
186400200529      **   Move book from file to work field for later checking.
186500200529      *
186600200529     C                   MOVE      TDBK          OLDBK1            2
186700200529     C                   MOVE      'W'           WARNIND           1
186800200529
186900200529      * Get TRADSDX2 records
187000200529
187100200529     C                   CALLB     'SETRADRTV2'
187200200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
187300200529      * INPUTS :
187400200529      * (Midas) Trade Reference
187500200529     C                   PARM                    DDTDRF
187600200529      * MT5XX - Phase 2 Message Generation is on.
187700200529     C                   PARM                    CSW003
187800200529      * OUTPUTS :
187900200529      * (Current) TRADSDX2 in file format
188000200529     C                   PARM                    TX2AFilFmt
188100200529     C                   PARM                    TX2BFilFmt
188200200529
188300200529     C                   ENDSR
188400200529
188500200529      *****************************************************************
188600200529      /EJECT
188700200529      *****************************************************************
188800200529      *                                                               *
188900200529      * ChkValMiTR - Routine to check if valid trade exists for       *
189000200529      *    Midas Trade Reference                                      *
189100200529      *                                                               *
189200200529      *****************************************************************
189300200529
189400200529     C     ChkValMiTR    BEGSR
189500200529
189600200529      * If (numeric) Midas Trade Reference supplied
189700200529
189800200529     C                   TESTN                   DDTDRF               9898
189900200529
190000200529     C     DDTDRF        IFNE      *BLANKS
190100200529     C     *IN98         ANDEQ     '1'
190200200529
190300200529      * Check for trade on Valid file
190400200529     C                   MOVEL     DDTDRF        TDRF
190500200529     C     TDRF          CHAIN     SEVTRADL1                          99
190600200529
190700200529      * If record found...
190800200529     C     *IN99         IFEQ      '0'
190900200529
191000200529      * ..delay, then repeat check
191100200529     C                   CALLB     'ZACDELAY'
191200200529
191300200529     C     TDRF          CHAIN     SEVTRADL1                          99
191400200529
191500200529      * Error if still present
191600200529     C     *IN99         IFEQ      '0'
191700200529     C                   ADD       1             Idx
191800200529     C                   EVAL      FldNameArr(Idx) = 'DDTDRF'
191900200529     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
192000200529     C                   ENDIF
192100200529     C                   ENDIF
192200200529
192300200529     C                   ENDIF
192400200529      *
192500200529     C                   ENDSR
192600200529      *****************************************************************
192700200529      /EJECT
192800200529      *****************************************************************
192900200529      *                                                               *
193000200529      * Fil2ScrnConv - Conversion file format to Screen Formate       *
193100200529      *                                                               *
193200200529      *****************************************************************
193300200529
193400200529     C     Fil2ScrnConv  BEGSR
193500200529
193600200529      ** CONVERSION OF FILE FIELDS TO SCREEN FORMAT
193700200529
193800200529     C                   RESET                   RetCodeIn
193900200529     C                   CALLB     'SETRADCVT'
194000200529      *
194100200529      * INPUTS
194200200529      *
194300200529      * Return Code
194400200529     C                   PARM                    RetCodeIn
194500200529      *
194600200529      * Trade - file formats
194700200529     C                   PARM                    TradFilFmt
194800200529     C                   PARM                    TX1AFilFmt
194900200529     C                   PARM                    TX1BFilFmt
195000200529      ** Hedge Accounting Phase B
195100200529
195200200529     C                   PARM                    CAS006
195300200529                                                                                              CGL031
195400200529      ** CGL031 Switchable Feature                                                            CGL031
195500200529     C                   PARM                    CGL031                                       CGL031
195600200529      *
195700200529      * Output parameters
195800200529      *
195900200529      * Trade - screen formats
196000200529     C                   PARM                    CurTrPrim
196100200529     C                   PARM                    CurTrSeco
196200200529     C                   PARM                    CurTrThir
196300200529     C                   PARM                    CurTrExch
196400200529     C                   PARM                    CurTrSett
196500200529     C                   PARM                    CurTrChCm
196600200529     C                   PARM                    CurTrSwftA
196700200529     C                   PARM                    CurTrSwftB
196800200529
196900200529      ** Security Details
197000200529      ** Investment Type Details
197100200529     C                   PARM                    SECTY
197200200529     C                   PARM                    INVTP
197300200529
197400200529      ** Nominal Currency Details
197500200529     C                   PARM                    NomCcyDts
197600200529
197700200529      ** Settlement Currency Details
197800200529     C                   PARM                    SetCcyDts
197900200529      *
198000200529      ** Customer (Counterparty) Details
198100200529     C                   PARM                    CustDts
198200200529      *
198300200529      * Trade Status
198400200529      * Trade Authorized/Not Authorized
198500200529     C                   PARM                    DDSTAT            9
198600200529     C                   PARM                    DDAUTH           14
198700200529      * Security report name
198800200529      * Customer report name
198900200529     C                   PARM                    DDSRNME          41
199000200529     C                   PARM                    DDCRNM           20
199100200529
199200200529      * Coupon Rate
199300200529      * Current Factor
199400200529      * Margin Amount
199500200529      * Portfolio Exchange Rate
199600200529      * Portfolio M/D Ind
199700200529      * Trade Countervalue
199800200529     C                   PARM                    DDCPNR           13
199900200529     C                   PARM                    DDCFCT           12
200000200529     C                   PARM                    DDMAMT           18
200100200529     C                   PARM                    DDSPXR           14
200200200529     C                   PARM                    DDSPMD            1
200300200529     C                   PARM                    DDTCTR           21
200400200529     C                   PARM                    DDWTAX
200500200529     C                   PARM                    DDPRICN
200600200529
200700200529      * SCREEN A
200800200529      * Destination of Settlement
200900200529      * Destination of Confirmation
201000200529     C                   PARM                    A_DDROUS          6
201100200529     C                   PARM                    A_DDROTS         12
201200200529     C                   PARM                    A_DDROUC          6
201300200529     C                   PARM                    A_DDROTC         12
201400200529
201500200529      * SCREEN B
201600200529      * Destination of Settlement
201700200529      * Destination of Confirmation
201800200529     C                   PARM                    B_DDROUS          6
201900200529     C                   PARM                    B_DDROTS         12
202000200529     C                   PARM                    B_DDROUC          6
202100200529     C                   PARM                    B_DDROTC         12
202200200529     C                   PARM                    DDFRNT                                    AR698195B
202300200529
202400200529      * Converse TRADSDX2 into Screen Format
202500200529
202600200529     C                   CALLB     'SETRADCVT2'
202700200529      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
202800200529      * INPUTS :
202900200529      * (Current) TRADSDX2 in file format
203000200529     C                   PARM                    TX2AFilFmt
203100200529     C                   PARM                    TX2BFilFmt
203200200529     C                   PARM                    CSW206            1                        BUG12579
203300200529     C                   PARM                    CSW210                                       CSW210
203400200529      * OUTPUTS :
203500200529      * (Screen) TRADSDX2
203600200529     C                   PARM                    CurX2SwftA
203700200529     C                   PARM                    CurX2SwftB
203800200529
203900200529     C                   ENDSR
204000200529      *****************************************************************
204100200529      /EJECT
204200200529      *****************************************************************
204300200529      *                                                               *
204400200529      * TDtDtaSubs - Transaction Details Data Substitution            *
204500200529      *                                                               *
204600200529      *****************************************************************
204700200529
204800200529     C     TDtDtaSubs    BEGSR
204900200529
205000200529      ** Save Counterparty Classifcation
205100200529     C                   EVAL      CPartyClass = CustClass
205200200529
205300200529      ** DATA SUBSTITUTION
205400200529
205500200529     C                   RESET                   ReturnCode
205600200529
205700200529      * TRADE PRIMARY DETAILS
205800200529     C                   CALLB     'APDTASUBS'
205900200529
206000200529      * Return Code
206100200529     C                   PARM                    ReturnCode       10
206200200529      * Substitution character
206300200529     C                   PARM      GHSUBS        SubsChar          1
206400200529      * Incoming Data
206500200529     C                   PARM      TranInPrim    IncDATA        2000
206600200529      * Current Data
206700200529     C                   PARM      CurTrPrim     CurDATA        2000
206800200529
206900200529     C                   MOVEL     IncDATA       TranInPrim
207000200529
207100200529      * TRADE SECONDARY DETAILS
207200200529     C                   CALLB     'APDTASUBS'
207300200529
207400200529      * Return Code
207500200529     C                   PARM                    ReturnCode       10
207600200529      * Substitution character
207700200529     C                   PARM      GHSUBS        SubsChar          1
207800200529      * Incoming Data
207900200529     C                   PARM      TranInSeco    IncDATA        2000
208000200529      * Current Data
208100200529     C                   PARM      CurTrSeco     CurDATA        2000
208200200529
208300200529     C                   MOVEL     IncDATA       TranInSeco
208400200529
208500200529      ** Trade Third screen details
208600200529
208700200529     C                   IF        CAS006 = 'Y'
208800200529     C                   CALLB     'APDTASUBS'
208900200529
209000200529      ** Return Code
209100200529
209200200529     C                   PARM                    ReturnCode
209300200529
209400200529      ** Substitution character
209500200529      ** Incoming Data
209600200529      ** Current Data
209700200529
209800200529     C                   PARM      GHSUBS        SubsChar
209900200529     C                   PARM      TranInThir    IncDATA
210000200529     C                   PARM      CurTrThir     CurDATA
210100200529
210200200529     C                   MOVEL     IncDATA       TranInThir
210300200529     C                   ENDIF
210400200529
210500200529      * TRADE EXCHANGE RATES
210600200529     C                   CALLB     'APDTASUBS'
210700200529
210800200529      * Return Code
210900200529     C                   PARM                    ReturnCode       10
211000200529      * Substitution character
211100200529     C                   PARM      GHSUBS        SubsChar          1
211200200529      * Incoming Data
211300200529     C                   PARM      TranInExch    IncDATA        2000
211400200529      * Current Data
211500200529     C                   PARM      CurTrExch     CurDATA        2000
211600200529
211700200529     C                   MOVEL     IncDATA       TranInExch
211800200529
211900200529      * TRADE SETTLEMENT DETAILS
212000200529     C                   CALLB     'APDTASUBS'
212100200529
212200200529      * Return Code
212300200529     C                   PARM                    ReturnCode       10
212400200529      * Substitution character
212500200529     C                   PARM      GHSUBS        SubsChar          1
212600200529      * Incoming Data
212700200529     C                   PARM      TranInSett    IncDATA        2000
212800200529      * Current Data
212900200529     C                   PARM      CurTrSett     CurDATA        2000
213000200529
213100200529     C                   MOVEL     IncDATA       TranInSett
213200200529
213300200529      * TRADE CHARGE/COMMISSIONS
213400200529     C                   CALLB     'APDTASUBS'
213500200529
213600200529      * Return Code
213700200529     C                   PARM                    ReturnCode
213800200529      * Substitution character
213900200529     C                   PARM      GHSUBS        SubsChar          1
214000200529      * Incoming Data
214100200529     C                   PARM      TranInChCm    IncDATA        2000
214200200529      * Current Data
214300200529     C                   PARM      CurTrChCm     CurDATA        2000
214400200529
214500200529     C                   MOVEL     IncDATA       TranInChCm
214600200529
214700200529      * TRADE SWIFT A DETAILS
214800200529     C                   CALLB     'APDTASUBS'
214900200529
215000200529      * Return Code
215100200529     C                   PARM                    ReturnCode       10
215200200529      * Substitution character
215300200529     C                   PARM      GHSUBS        SubsChar          1
215400200529      * Incoming Data
215500200529     C                   PARM      TranInSwfA    IncDATA        2000
215600200529      * Current Data
215700200529     C                   PARM      CurTrSwftA    CurDATA        2000
215800200529
215900200529     C                   MOVEL     IncDATA       TranInSwfA
216000200529
216100200529      * TRADE SWIFT B DETAILS
216200200529     C                   CALLB     'APDTASUBS'
216300200529
216400200529      * Return Code
216500200529     C                   PARM                    ReturnCode       10
216600200529      * Substitution character
216700200529     C                   PARM      GHSUBS        SubsChar          1
216800200529      * Incoming Data
216900200529     C                   PARM      TranInSwfB    IncDATA        2000
217000200529      * Current Data
217100200529     C                   PARM      CurTrSwftB    CurDATA        2000
217200200529
217300200529     C                   MOVEL     IncDATA       TranInSwfB
217400200529
217500200529      * TRADEX2 SWIFT A DETAILS
217600200529     C                   CALLB     'APDTASUBS'
217700200529
217800200529      * Return Code
217900200529     C                   PARM                    ReturnCode       10
218000200529      * Substitution character
218100200529     C                   PARM      GHSUBS        SubsChar          1
218200200529      * Incoming Data
218300200529     C                   PARM      TranInExtA    IncDATA        2000
218400200529      * Current Data
218500200529     C                   PARM      CurX2SwftA    CurDATA        2000
218600200529
218700200529     C                   MOVEL     IncDATA       TranInExtA
218800200529
218900200529      * TRADEX2 SWIFT B DETAILS
219000200529     C                   CALLB     'APDTASUBS'
219100200529
219200200529      * Return Code
219300200529     C                   PARM                    ReturnCode       10
219400200529      * Substitution character
219500200529     C                   PARM      GHSUBS        SubsChar          1
219600200529      * Incoming Data
219700200529     C                   PARM      TranInExtB    IncDATA        2000
219800200529      * Current Data
219900200529     C                   PARM      CurX2SwftB    CurDATA        2000
220000200529
220100200529     C                   MOVEL     IncDATA       TranInExtB
220200200529
220300200529     C                   ENDSR
220400200529      *****************************************************************
220500200529      /EJECT
220600200529      *****************************************************************
220700200529      *                                                               *
220800200529      * CalcTrCHCM - Calculate Trade Charges/Commissions              *
220900200529      *                                                               *
221000200529      *****************************************************************
221100200529     C     CalcTrCHCM    BEGSR
221200200529
221300200529     C                   CALLB     'SETCHCMCAL'
221400200529
221500200529      * INPUTS
221600200529
221700200529      ** Trade reference
221800200529      ** Security
221900200529      ** Trade Type
222000200529     C                   PARM                    DDTDRF            6
222100200529     C                   PARM                    DDSESN           10
222200200529     C                   PARM                    DDTDTP            2
222300200529      *
222400200529      ** Trade Counterparty
222500200529      ** Trade Nominal
222600200529      ** Trade % price
222700200529      ** Trade Date
222800200529      ** Trade Purchased Interest
222900200529      ** Trade Current Factor
223000200529     C                   PARM                    V_TCNR
223100200529     C                   PARM                    V_NOML           11 0
223200200529     C                   PARM                    V_PRIC           15 8
223300200529     C                   PARM                    V_TDDT            5 0
223400200529     C                   PARM                    V_ITRA           13 0
223500200529     C                   PARM                    V_TCFC           10 9
223600200529      *
223700200529      ** Security & Investment Type details
223800200529     C                   PARM                    SECTY
223900200529     C                   PARM                    PROT              1
224000200529      *
224100200529      ** Nominal Currency Details
224200200529     C                   PARM                    NomCcyDts
224300200529      *
224400200529      ** Customer (Counterparty) Details
224500200529     C                   PARM                    CustDts
224600200529      *
224700200529      ** Commission Rebate %
224800200529     C                   PARM                    CMRP              5 3
224900200529      *
225000200529      ** Previous Trade Charges & Commissions
225100200529     C                   PARM                    CurTrChCm
225200200529      *
225300200529      ** Trade Charges & Commissions OK inds
225400200529     C                   PARM                    OKTrChCm
225500200529      *
225600200529      ** ICD
225700200529      ** Autocharge Option
225800200529      ** Securities Charges Currency
225900200529      ** Adjust Commission Same Day T
226000200529     C                   PARM                    BVACOP            1
226100200529     C                   PARM                    BVCHRC            3
226200200529     C                   PARM                    BVACSD            1
226300200529     C                   PARM                    S01446            1
226400200529
226500200529      * INPUTS & OUTPUTS
226600200529
226700200529      ** Trade Charges & commissions screen fields
226800200529
226900200529     C                   PARM                    TranInChcm
227000200529
227100200529      ** Trade details
227200200529     C                   PARM                    V_TBCA           13 0
227300200529     C                   PARM                    V_TCCA           13 0
227400200529     C                   PARM                    V_TCA1           13 0
227500200529     C                   PARM                    V_TCA2           13 0
227600200529     C                   PARM                    V_TCA3           13 0
227700200529     C                   PARM                    V_TCA4           13 0
227800200529     C                   PARM                    V_TCA5           13 0
227900200529     C                   PARM                    V_TCA6           13 0
228000200529     C                   PARM                    V_TCA7           13 0
228100200529     C                   PARM                    V_TAXA           13 0
228200200529     C                   PARM                    V_BCMR           13 0
228300200529     C                   PARM                    V_CCMR           13 0
228400200529     C                   PARM                    V_TXRB           13 0
228500200529
228600200529     C                   ENDSR
228700200529      *****************************************************************                       237063
228800200529      /EJECT                                                                                  237063
228900200529      *****************************************************************                       237063
229000200529      *                                                               *                       237063
229100200529      * CalcTrEUTX - Calculate EU Tax                                 *                       237063
229200200529      *                                                               *                       237063
229300200529      *****************************************************************                       237063
229400200529     C     CalcTrEUTX    BEGSR                                                                237063
229500200529                                                                                              237063
229600200529     C                   IF        DDPTFR <> *BLANKS AND PTFR = *BLANKS                       237063
229700200529     C                   EVAL      PTFR = DDPTFR                                              237063
229800200529     C                   ENDIF                                                                237063
229900200529                                                                                              237063
230000200529      ** CALCULATE EU TAX                                                                     237063
230100200529                                                                                              237063
230200200529     C                   CALLB     'SEVTRADTAX'                                               237063
230300200529                                                                                              237063
230400200529      * INPUTS                                                                                237063
230500200529                                                                                              237063
230600200529      * Response Mode                                                                         237063
230700200529     C                   PARM                    RetCodeIn                                    237063
230800200529      * Valid Trade Details                                                                   237063
230900200529     C                   PARM                    ValidTrad                                    237063
231000200529      * Security Details                                                                      237063
231100200529     C                   PARM                    SECTY                                        237063
231200200529      * Process Flag                                                                          237063
231300200529     C                   PARM      'E'           ProcFlag          1                          237063
231400200529                                                                                              237063
231500200529      * OUTPUTS                                                                               237063
231600200529                                                                                              237063
231700200529      * EU Tax Screen Format                                                                  237063
231800200529      * EU Tax in Nominal Currency File Format                                                237063
231900200529      * EU Tax in Settlement Currency File Format                                             237063
232000200529     C                   PARM                    DDEUTX                                       237063
232100200529     C                   PARM                    EUTX                                         237063
232200200529     C                   PARM                    EUTS                                         237063
232300200529                                                                                              237063
232400200529     C                   ENDSR                                                                237063
232500200529      *****************************************************************
232600200529      /EJECT
232700200529      *****************************************************************
232800200529      *                                                               *
232900200529      * CalcTrCVAL - Calculate Trade Countervalue                     *
233000200529      *                                                               *
233100200529      *****************************************************************
233200200529     C     CalcTrCVAL    BEGSR
233300200529
233400200529      ** CALCULATE COUNTERVALUE
233500200529
233600200529     C                   CALLB     'SETCVALCAL'
233700200529
233800200529      * INPUTS
233900200529
234000200529      ** Trade details
234100200529     C                   PARM                    V_TDTP            2
234200200529     C                   PARM                    V_NOML           11 0
234300200529     C                   PARM                    V_PRIC           15 8
234400200529     C                   PARM                    V_RALL            9 5
234500200529     C                   PARM                    V_ITRA           13 0
234600200529     C                   PARM                    V_TBCA           13 0
234700200529     C                   PARM                    V_TCCA           13 0
234800200529     C                   PARM                    V_TCA1           13 0
234900200529     C                   PARM                    V_TCA2           13 0
235000200529     C                   PARM                    V_TCA3           13 0
235100200529     C                   PARM                    V_TCA4           13 0
235200200529     C                   PARM                    V_TCA5           13 0
235300200529     C                   PARM                    V_TCA6           13 0
235400200529     C                   PARM                    V_TCA7           13 0
235500200529     C                   PARM                    V_TAXA           13 0
235600200529     C                   PARM                    V_TDER           13 8
235700200529     C                   PARM                    V_TMDI            1
235800200529     C                   PARM                    V_SETC            3
235900200529     C                   PARM                    V_TDVD            5 0
236000200529
236100200529      ** Security details
236200200529     C                   PARM                    PROT              1
236300200529     C                   PARM                    SPBS              1
236400200529     C                   PARM                    CFCT             10 9
236500200529     C                   PARM                    NMCY              3
236600200529     C                   PARM                    NMDP              1 0
236700200529     C                   PARM                    SESN             10
236800200529
236900200529      ** Nominal Currency Details
237000200529      ** Settlement Currency Details
237100200529     C                   PARM                    NomCcyDts
237200200529     C                   PARM                    SetCcyDts
237300200529
237400200529      ** Customer classification
237500200529     C                   PARM                    CustClass         1
237600200529
237700200529      ** Country of treaty from PF/SECTYD
237800200529     C                   PARM                    CRTT
237900200529
238000200529      ** Default basket for backup withholding
238100200529     C                   PARM                    PDRBW
238200200529
238300200529      ** Value date
238400200529     C                   PARM                    TDVD
238500200529                                                                                              237063
238600200529      ** EU Tax                                                                               237063
238700200529     C                   PARM                    EUTX                                         237063
238800200529
238900200529      * OUTPUTS
239000200529
239100200529      * Trade consideration in nominal currency
239200200529      * Trade countervalue in nominal currency
239300200529      * Withholding tax
239400200529      * Trade countervalue in settlement currency in screen format
239500200529      * Withholding tax in screen format
239600200529     C                   PARM                    V_TCSR           15 0
239700200529     C                   PARM                    V_TCTR           15 0
239800200529     C                   PARM                    WHTX
239900200529     C                   PARM                    DDTCTR           21
240000200529     C                   PARM                    DDWTAX
240100200529
240200200529     C                   ENDSR
240300200529      *****************************************************************
240400200529      /EJECT
240500200529      *****************************************************************
240600200529      * SetPDATA - Set up data structure for call to SE1806
240700200529      *****************************************************************
240800200529     C     SetPDATA      BEGSR
240900200529
241000200529     C                   MOVEL     DDACTN        PACTN
241100200529     C     DDACTN        IFEQ      'C'
241200200529     C                   MOVEL     'A'           PACTN
241300200529     C                   END
241400200529     C                   MOVEL     DDTDRF        PTDRF
241500200529     C                   MOVEL     DDSETC        PTNMC
241600200529     C                   MOVEL     DDSESN        PSESN
241700200529     C                   MOVEL     DDBLKR        PBLKR
241800200529      *                                                                                       247451
241900200529      ** Access Customer details via access program                                           247451
242000200529      *  (database error handling done in access program)                                     247451
242100200529     C                   CALL      'AOCUSTR0'                                                 247451
242200200529     C                   PARM      '*DBERR '     @RTCD                                        247451
242300200529     C                   PARM      '*KEY   '     @OPTN                                        247451
242400200529     C                   PARM      DDCNUM        WCus10           10                          247451
242500200529     C                   PARM      *BLANKS       WKyst             7                          247451
242600200529     C     SDCUST        PARM      SDCUST        DSSDY                                        247451
242700200529      *                                                                                       247451
242800200529     C     @RTCD         IFEQ      *BLANK                                                     247451
242900200529     C                   MOVEL     BBCUST        PTCNR                                        247451
243000200529     C                   ENDIF                                                                247451
243100200529                                                                                              247451
243200200529     C*****              MOVEL     DDCNUM        PTCNR                                      BUG11622
243300200529     C**********         MOVEL     CustNum       PTCNR                               BUG11622 247451
243400200529     C                   MOVEL     DDBRCD        PTDBR
243500200529     C                   MOVEL     DDTDTP        PTDTP
243600200529     C                   MOVEL     V_NOML        PNOML
243700200529     C                   MOVEL     DDTDMI        PTDMI
243800200529     C                   MOVEL     DDAIIP        PAIIP
243900200529     C                   MOVEL     DDINCS        PINCS
244000200529     C                   MOVEL     BVDR1         PDC01
244100200529     C                   MOVEL     BVDR2         PDC02
244200200529     C                   MOVEL     DDCLTY        PCLTY
244300200529     C                   MOVEL     DDPCOD        PPCOD
244400200529     C                   MOVEL     V_DELT        PDELT
244500200529     C                   MOVEL     V_DELF        PDELF
244600200529     C                   MOVEL     DDTDSI        PTDSI
244700200529     C                   MOVEL     DDSMTH        PSMTH
244800200529     C                   MOVEL     BFDRF1        PC101
244900200529     C                   MOVEL     BFDRF2        PC102
245000200529     C                   MOVEL     DDPRYC        PPRYC
245100200529     C                   Z-ADD     V_TDVD        PTDVD
245200200529
245300200529     C     CSE028        IFEQ      'Y'
245400200529     C                   MOVEL     DDBPBK        PPBKC
245500200529     C                   MOVEL     DDMRKT        PMKCT
245600200529     C                   ENDIF
245700200529
245800200529     C                   ENDSR
245900200529      *****************************************************************
246000200529      /EJECT
246100200529      *****************************************************************
246200200529      *                                                               *
246300200529      *  SRDefScn - Default fields in screen                          *
246400200529      *                                                               *
246500200529      *****************************************************************
246600200529
246700200529     C     SRDefScn      BEGSR
246800200529
246900200529     C     KEY001        KLIST
247000200529     C                   KFLD                    PTDRF
247100200529     C                   KFLD                    PWHEN
247200200529
247300200529     C                   EVAL      PGMNAM = 'SEDORFRTV'                                     BUG10085
247400200529                                                                                            BUG10085
247500200529     C                   IF        PWHEN = 'A'
247600200529     C                   MOVEL     ADDGMES       PGMES
247700200529     C                   MOVEL     ADDGMEC       PGMEC
247800200529     C                   MOVEL     ADDCCID       PCCID
247900200529     C                   MOVEL     ADDSNEW       PSNEW
248000200529     C                   ELSE
248100200529     C                   MOVEL     BDDGMES       PGMES
248200200529     C                   MOVEL     BDDGMEC       PGMEC
248300200529     C                   MOVEL     BDDCCID       PCCID
248400200529     C                   MOVEL     BDDSNEW       PSNEW
248500200529     C                   ENDIF
248600200529      *
248700200529      ** Access Branch details via access program
248800200529      *  (database error handling done in access program)
248900200529     C                   MOVE      PTDBR         WDSNB
249000200529     C**********         CALLB     'AOBRCHR0'                                          CSE045 CGL029
249100200529     C                   CALL      'AOBRCHR1'                                                 CGL029
249200200529     C                   PARM      '*DBERR '     @RTCD
249300200529     C***********        PARM      '*FIRST '     @OPTN                                      BUG10085
249400200529     C                   PARM      '*KEY   '     @OPTN                                      BUG10085
249500200529     C                   PARM                    WDSNB             3
249600200529     C*****SDBRCH        PARM      SDBRCH        DSFDY                                 CSE045 CGL029
249700200529     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
249800200529
249900200529     C                   MOVE      A8BICN        WWBICN
250000200529
250100200529     C                   EVAL      CrSEFilFmt = *Blanks
250200200529     C     KEY001        CHAIN     TRADSDD2                           99
250300200529
250400200529     C                   CALLB     'SETSESDFT'
250500200529      *                             =========
250600200529      *
250700200529      ** INPUT
250800200529      ** =====
250900200529      *
251000200529      ** Securities retrieved from file - file format
251100200529     C                   PARM                    CrSEFilFmt
251200200529
251300200529     C                   PARM                    PDATA
251400200529
251500200529     C                   PARM                    CSE022
251600200529
251700200529     C                   PARM                    CSE028
251800200529
251900200529     C                   PARM                    SWRTN
252000200529
252100200529     C                   PARM                    DFTFLG
252200200529
252300200529     C**********         PARM                    WWBICN            6 0                       CSD027A
252400200529     C                   PARM                    WWBICN            6                         CSD027A
252500200529
252600200529     C                   PARM                    PGMNAM
252700200529     C                   PARM                    DDMRKT                                      BUG2274
252800200529      ** SWIFT 2006                                                                          CSW206E
252900200529     C                   PARM                    CSW206                                      CSW206E
253000200529      ** SWIFT 2010                                                                           CSW210
253100200529     C                   PARM                    CSW210                                       CSW210
253200200529      *
253300200529      ** OUTPUT
253400200529      ** ======
253500200529      *
253600200529      ** Securities screen 1 details retrieved from file - screen format
253700200529     C                   PARM                    NwSE1ScnFmt
253800200529                                                                                            BUG10476
253900200529      * If Place of settlement is blank then use market Centre to access SEMKC              BUG10476
254000200529      * and default from here.                                                              BUG10476
254100200529     C     ESPSET        IFEQ      *BLANKS                                                  BUG10476
254200200529     C     AESPSET       ANDEQ     *BLANKS                                                  BUG10476
254300200529     C     DDMRKT        IFNE      *BLANKS                                                  BUG10476
254400200529     C     DDMRKT        CHAIN     SEMKCDF                            99                    BUG10476
254500200529     C     *IN99         IFEQ      *OFF                                                     BUG10476
254600200529     C                   EVAL      AESPSET = PSETL                                          BUG10476
254700200529     C                   ENDIF                                                              BUG10476
254800200529     C                   ENDIF                                                              BUG10476
254900200529     C                   ENDIF                                                              BUG10476
255000200529                                                                                            BUG10476
255100200529      *
255200200529      ** Initialise Clearance Type (1 to 4 is MT580 for Settlements)
255300200529      *
255400200529     C     PWHEN         IFNE      'B'
255500200529     C     PCLTY         OREQ      '1'
255600200529     C     PCLTY         OREQ      '3'
255700200529
255800200529     C     PCLTY         IFEQ      '1'
255900200529     C     PCLTY         OREQ      '2'
256000200529     C     PCLTY         OREQ      '3'
256100200529     C     PCLTY         OREQ      '4'
256200200529     C                   MOVE      '14'          WWCLTY
256300200529     C                   ENDIF
256400200529
256500200529     C                   ELSE
256600200529     C     PTDTP         IFEQ      'TP'
256700200529     C                   MOVE      PDELF         WCUST
256800200529     C                   ELSE
256900200529     C                   MOVE      PDELT         WCUST
257000200529     C                   END
257100200529
257200200529     C                   IF        WCUST <> *BLANKS                                         BUG12874
257300200529     C                   CALL      'AOSECSR0'
257400200529     C                   PARM      '*DBERR '     @RTCD
257500200529     C                   PARM      '*KEY   '     @OPTN
257600200529     C                   PARM                    WCUST             6
257700200529     C     SDSECS        PARM      SDSECS        DSSDY
257800200529     C                   ENDIF                                                              BUG12874
257900200529
258000200529     C     BFCLAS        IFEQ      'E'
258100200529     C     PCLTY         ANDEQ     '4'
258200200529     C     BFCLAS        OREQ      'E'
258300200529     C     PCLTY         ANDEQ     '5'
258400200529     C     BFCLAS        OREQ      'C'
258500200529     C     PCLTY         ANDEQ     '2'
258600200529     C     BFCLAS        OREQ      'C'
258700200529     C     PCLTY         ANDEQ     '5'
258800200529     C                   MOVE      '14'          WWCLTY
258900200529     C                   ENDIF
259000200529
259100200529     C                   ENDIF
259200200529      *
259300200529      ** Set up trade type as opposite, if second record
259400200529      *
259500200529     C     PWHEN         IFEQ      'B'
259600200529     C     PTDTP         IFEQ      'TP'
259700200529     C                   MOVE      'TS'          WTDTP
259800200529     C                   ELSE
259900200529     C                   MOVE      'TP'          WTDTP
260000200529     C                   ENDIF
260100200529
260200200529     C                   ELSE
260300200529     C                   MOVE      PTDTP         WTDTP
260400200529     C                   ENDIF
260500200529
260600200529     C     ESRDefScn1    ENDSR
260700200529      *****************************************************************
260800200529      /EJECT
260900200529      *****************************************************************
261000200529      *                                                               *
261100200529      * ValdTrExSetA - Routine to validate Extended Settlements.      *
261200200529      *                                                               *
261300200529      *****************************************************************
261400200529     C     ValdTrExSetA  BEGSR
261500200529
261600200529      *
261700200529      ** Access Branch details via access program
261800200529      *  (database error handling done in access program)
261900200529     C                   MOVE      PTDBR         WDSNB
262000200529     C**********         CALLB     'AOBRCHR0'                                          CSE045 CGL029
262100200529     C                   CALL      'AOBRCHR1'                                                 CGL029
262200200529     C                   PARM      '*DBERR '     @RTCD
262300200529     C***********        PARM      '*FIRST '     @OPTN                                      BUG10085
262400200529     C                   PARM      '*KEY   '     @OPTN                                      BUG10085
262500200529     C                   PARM                    WDSNB             3
262600200529     C*****SDBRCH        PARM      SDBRCH        DSFDY                                 CSE045 CGL029
262700200529     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
262800200529
262900200529     C                   MOVE      A8BICN        WWBICN
263000200529
263100200529     C*****              MOVEL     DDCNUM        WCTPCN                                     BUG11622
263200200529     C**********         MOVEL     CustNum       WCTPCN                              BUG11622 247451
263300200529     C                   MOVEL     PTCNR         WCTPCN                                       247451
263400200529                                                                                              CAP087
263500200529     C**********         IF        DDCNUM <> *BLANK                                  CAP087 BUG12874
263600200529     C                   IF        WCTPCN <> *BLANK                                         BUG12874
263700200529      *
263800200529      ** Retrieve classification of counterparty
263900200529      *
264000200529     C                   CALL      'AOSECSR0'
264100200529     C                   PARM      '*DBERR '     @Rtcd
264200200529     C                   PARM      '*KEY   '     @Optn
264300200529     C                   PARM      WCTPCN        WCust
264400200529     C     SDSECS        PARM      SDSECS        DSSDY
264500200529                                                                                              CAP087
264600200529     C                   ENDIF                                                                CAP087
264700200529      *
264800200529      ** Setup parameters to call module SEDORFRTV
264900200529      *
265000200529     C     PTDTP         IFEQ      'TP'
265100200529      *
265200200529     C     BFCLAS        IFEQ      'M'
265300200529     C                   MOVEL     PDELT         PDEPO
265400200529     C                   MOVEL     WWBICN        PCUST
265500200529     C                   MOVEL     PDELT         PDEPO2
265600200529     C                   ELSE
265700200529     C                   MOVEL     PDELT         PDEPO
265800200529     C*****              MOVEL     DDCNUM        PCUST                                      BUG11622
265900200529     C**********         MOVEL     CustNum       PCUST                               BUG11622 247451
266000200529     C                   MOVEL     PTCNR         PCUST                                        247451
266100200529     C                   MOVEL     PDELT         PDEPO2
266200200529     C                   ENDIF
266300200529
266400200529     C                   ELSE
266500200529
266600200529     C     BFCLAS        IFEQ      'M'
266700200529     C                   MOVEL     PDELF         PDEPO
266800200529     C                   MOVEL     WWBICN        PCUST
266900200529     C                   MOVEL     PDELT         PDEPO2
267000200529     C                   ELSE
267100200529     C                   MOVEL     PDELF         PDEPO
267200200529     C*****              MOVEL     DDCNUM        PCUST                                      BUG11622
267300200529     C**********         MOVEL     CustNum       PCUST                               BUG11622 247451
267400200529     C                   MOVEL     PTCNR         PCUST                                        247451
267500200529     C                   MOVEL     PDELT         PDEPO2
267600200529     C                   ENDIF
267700200529
267800200529     C                   ENDIF
267900200529      ** If CSE022 is installed then setup Safekeeping A/C Line by using module SEDORFRTV
268000200529      *
268100200529     C     CSE022        IFEQ      'Y'
268200200529      *
268300200529     C                   CALL      PGMNAM
268400200529     C                   PARM      *BLANKS       PRETC
268500200529     C                   PARM                    PDEPO
268600200529     C                   PARM                    PCUST
268700200529     C                   PARM      *BLANKS       PSKAL
268800200529
268900200529     C     AESSKAN       IFEQ      *BLANKS
269000200529     C                   MOVEL     PDEPO         AESSKAN
269100200529     C                   END
269200200529     C     AESSKAL       IFEQ      *BLANKS
269300200529     C                   MOVEL     PSKAL         AESSKAL
269400200529     C                   END
269500200529
269600200529     C                   CALL      PGMNAM
269700200529     C                   PARM      *BLANKS       PRETC
269800200529     C                   PARM                    PDEPO2
269900200529     C                   PARM                    PTCNR
270000200529     C                   PARM      *BLANKS       PSKAL
270100200529
270200200529     C     AESSA1N       IFEQ      *BLANKS
270300200529     C                   MOVEL     PDEPO2        AESSA1N
270400200529     C                   END
270500200529     C     AESSA1L       IFEQ      *BLANKS
270600200529     C                   MOVEL     PSKAL         AESSA1L
270700200529     C                   END
270800200529
270900200529     C                   ENDIF
271000200529
271100200529     C*****BFCLAS        IFNE      'S'                                                       BUG5557
271200200529     C*****BFCLAS        ANDNE     'D'                                                       BUG5557
271300200529     C*****BFCLAS        ANDNE     'I'                                                       BUG5557
271400200529     C     BFCLAS        IFNE      'I'                                                       BUG5557
271500200529     C                   EVAL      PMODE = '*FRONT'
271600200529     C                   EVAL      PMODE2 = '*FRONT'                                        MD035243
271700200529     C                   EVAL      BeforeIdx = Idx
271800200529     C                   EVAL      BeforeWIdx = WIdx
271900200529     C                   MOVE      'B_SESVAL_A'  D_Point          10                          245542
272000200529     C                   CALLB     'SETSESVAL'
272100200529      *                             =========
272200200529      *
272300200529      ** Mode = '*FRONT' (front office transaction interface)
272400200529      ** Mode = '      ' (not front office transaction interface)
272500200529      ** Mode = '*RPR  ' (repair function)
272600200529      ** Mode = '*SIN  ' (screen input function)
272700200529     C**********         PARM                    PMODE                                      MD035243
272800200529     C                   PARM                    PMODE2                                     MD035243
272900200529      *
273000200529      ** Response mode
273100200529     C                   PARM      'S'           APRespMode
273200200529      *
273300200529      ** Security API Trades Extended Settlement details from incoming transaction
273400200529      ** - screen format
273500200529     C                   PARM                    TranInExtA
273600200529      *
273700200529      ** SWITCHABLE FEATURES
273800200529      ** ===================
273900200529      *
274000200529      ** MT5xx SSI Enhancements
274100200529     C                   PARM                    CSE028
274200200529      *
274300200529      ** ERI Information for non-EMU users
274400200529     C                   PARM                    CSW014
274500200529      *
274600200529      ** SWIFT 2001
274700200529     C                   PARM                    CSW201
274800200529      *
274900200529      ** CSW098
275000200529     C                   PARM                    SWRTN
275100200529      ** SWIFT 2006                                                                          CSW206E
275200200529     C                   PARM                    CSW206                                      CSW206E
275300200529      ** SWIFT 2010                                                                           CSW210
275400200529     C                   PARM                    CSW210                                       CSW210
275500200529      ** CFT004 - IBAN Numbers                                                                CSW210
275600200529     C                   PARM                    CFT004                                       CSW210
275700200529      *
275800200529      ** Other Parameters
275900200529     C                   PARM                    PDATA
276000200529
276100200529     C                   PARM                    WTDTP
276200200529
276300200529     C                   PARM                    WWCLTY
276400200529
276500200529     C**********         PARM                    @ADDSAFA                                     245542
276600200529     C                   PARM                    ADDSAFA                                      245542
276700200529      *
276800200529      ** Function Keys
276900200529     C                   PARM                    PINKS
277000200529
277100200529     C                   PARM                    PINKT
277200200529      *
277300200529      ** OUTPUT
277400200529      ** ======
277500200529      *
277600200529      ** Error fields/message IDs/message data (arrays) from/to caller
277700200529     C                   PARM                    FldNameArr
277800200529     C                   PARM                    MsgIdArr
277900200529     C                   PARM                    MsgDtaArr
278000200529      *
278100200529      ** Array index (3P0) from/to caller
278200200529     C                   PARM                    IdX
278300200529      *
278400200529      ** Warning flds/message IDs/message data (arrays) from/to caller
278500200529     C                   PARM                    WFldNamArr
278600200529     C                   PARM                    WMsgIdArr
278700200529     C                   PARM                    WMsgDtaArr
278800200529      *
278900200529      ** Array index (3P0) from/to caller
279000200529     C                   PARM                    WIdX
279100200529      *
279200200529      ** Security API Trades Extended Settlements Error Indicators
279300200529     C                   PARM                    OKX2Swft
279400200529      *
279500200529      ** Security API Trades Extended Settlements Valid File
279600200529     C                   PARM                    ValidTX2A
279700200529     C                   MOVE      'A_SESVAL_A'  D_Point          10                          245542
279800200529
279900200529      ** Identify each field in error with prefix A
280000200529     C                   IF        BeforeIdx <> Idx
280100200529     C                   EVAL      StepIdx = BeforeIdx + 1
280200200529     C     StepIdx       DOUGT     Idx
280300200529     C                   EVAL      FldNameArr(StepIdx) = 'A'
280400200529     C                                     + FldNameArr(StepIdx)
280500200529     C                   EVAL      StepIdx = StepIdx + 1
280600200529     C                   ENDDO
280700200529     C                   ENDIF
280800200529
280900200529     C                   IF        BeforeWIdx <> WIdx
281000200529     C                   EVAL      StepIdx = BeforeWIdx +1
281100200529     C*****StepIdx       DOUGT     Idx                                                      AR638989
281200200529     C     StepIdx       DOUGT     WIdx                                                     AR638989
281300200529     C                   EVAL      WFldNamArr(StepIdx) = 'A'
281400200529     C                                     + WFldNamArr(StepIdx)
281500200529     C                   EVAL      StepIdx = StepIdx + 1
281600200529     C                   ENDDO
281700200529     C                   ENDIF
281800200529
281900200529     C                   END
282000200529
282100200529     C                   ENDSR
282200200529      *****************************************************************
282300200529      /EJECT
282400200529      *****************************************************************
282500200529      *                                                               *
282600200529      * ValdTrExSetB - Routine to validate Extended Settlements.      *
282700200529      *                                                               *
282800200529      *****************************************************************
282900200529     C     ValdTrExSetB  BEGSR
283000200529
283100200529     C                   EVAL      PMODE = '*FRONT'
283200200529     C                   EVAL      PMODE2 = '*FRONT'                                        MD035243
283300200529     C                   MOVE      *ALL'Y'       OKX2Swft                                   MD035243
283400200529     C                   EVAL      BeforeIdx = Idx
283500200529     C                   EVAL      BeforeWIdx = WIdx
283600200529     C                   MOVE      'B_SESVAL_B'  D_Point          10                          245542
283700200529     C                   CALLB     'SETSESVAL'
283800200529      *                             =========
283900200529      *
284000200529      ** Mode = '*FRONT' (front office transaction interface)
284100200529      ** Mode = '      ' (not front office transaction interface)
284200200529      ** Mode = '*RPR  ' (repair function)
284300200529      ** Mode = '*SIN  ' (screen input function)
284400200529     C**********         PARM                    PMODE                                      MD035243
284500200529     C                   PARM                    PMODE2                                     MD035243
284600200529      *
284700200529      ** Response mode
284800200529     C                   PARM      'S'           APRespMode
284900200529      *
285000200529      ** Security API Trades Extended Settlement details from incoming transaction
285100200529      ** - screen format
285200200529     C                   PARM                    TranInExtB
285300200529      *
285400200529      ** SWITCHABLE FEATURES
285500200529      ** ===================
285600200529      *
285700200529      ** MT5xx SSI Enhancements
285800200529     C                   PARM                    CSE028
285900200529      *
286000200529      ** ERI Information for non-EMU users
286100200529     C                   PARM                    CSW014
286200200529      *
286300200529      ** SWIFT 2001
286400200529     C                   PARM                    CSW201
286500200529      *
286600200529      ** CSW098
286700200529     C                   PARM                    SWRTN
286800200529      ** SWIFT 2006                                                                          CSW206E
286900200529     C                   PARM                    CSW206                                      CSW206E
287000200529      ** SWIFT 2010                                                                           CSW210
287100200529     C                   PARM                    CSW210                                       CSW210
287200200529      ** CFT004 - IBAN Numbers                                                                CSW210
287300200529     C                   PARM                    CFT004                                       CSW210
287400200529      *
287500200529      ** Other Parameters
287600200529     C                   PARM                    PDATA
287700200529
287800200529     C                   PARM                    WTDTP
287900200529
288000200529     C                   PARM                    WWCLTY
288100200529
288200200529     C                   PARM                    @BDDSAFA
288300200529      *
288400200529      ** Function Keys
288500200529     C                   PARM                    PINKS
288600200529
288700200529     C                   PARM                    PINKT
288800200529      *
288900200529      ** OUTPUT
289000200529      ** ======
289100200529      *
289200200529      ** Error fields/message IDs/message data (arrays) from/to caller
289300200529     C                   PARM                    FldNameArr
289400200529     C                   PARM                    MsgIdArr
289500200529     C                   PARM                    MsgDtaArr
289600200529      *
289700200529      ** Array index (3P0) from/to caller
289800200529     C                   PARM                    IdX
289900200529      *
290000200529      ** Warning flds/message IDs/message data (arrays) from/to caller
290100200529     C                   PARM                    WFldNamArr
290200200529     C                   PARM                    WMsgIdArr
290300200529     C                   PARM                    WMsgDtaArr
290400200529      *
290500200529      ** Array index (3P0) from/to caller
290600200529     C                   PARM                    WIdX
290700200529      *
290800200529      ** Security API Trades Extended Settlements Error Indicators
290900200529     C                   PARM                    OKX2Swft
291000200529      *
291100200529      ** Security API Trades Extended Settlements Valid File
291200200529     C                   PARM                    ValidTX2B
291300200529     C                   MOVE      'A_SESVAL_B'  D_Point          10                          245542
291400200529
291500200529     C                   IF        BeforeIdx <> Idx
291600200529     C                   EVAL      StepIdx = BeforeIdx + 1
291700200529     C     StepIdx       DOUGT     Idx
291800200529     C                   EVAL      FldNameArr(StepIdx) = 'B'
291900200529     C                                     + FldNameArr(StepIdx)
292000200529     C                   EVAL      StepIdx = StepIdx + 1
292100200529     C                   ENDDO
292200200529     C                   ENDIF
292300200529
292400200529     C                   IF        BeforeWIdx <> WIdx
292500200529     C                   EVAL      StepIdx = BeforeWIdx +1
292600200529     C*****StepIdx       DOUGT     Idx                                                      AR638989
292700200529     C     StepIdx       DOUGT     WIdx                                                     AR638989
292800200529     C                   EVAL      WFldNamArr(StepIdx) = 'B'
292900200529     C                                     + WFldNamArr(StepIdx)
293000200529     C                   EVAL      StepIdx = StepIdx + 1
293100200529     C                   ENDDO
293200200529     C                   ENDIF
293300200529
293400200529     C                   ENDSR
293500200529      *****************************************************************
293600200529      /EJECT
293700200529      *****************************************************************
293800200529      *                                                               *
293900200529      * ValdateAmd - Routine to check whether the fields amended      *
294000200529      *    are amendable.                                             *
294100200529      *                                                               *
294200200529      *****************************************************************
294300200529     C     ValdateAmd    BEGSR
294400200529      *
294500200529      ** This subroutine calls a procedure which checks whether it
294600200529      ** was valid to Amend or Change any of the fields which have been
294700200529      ** altered.  Some are never amendable and some are amendable depending
294800200529      ** on the Action Code - "A" for Amend, "C" for Change.
294900200529
295000200529      ** To determine what fields have changed, the current fields
295100200529      ** on file must be converted to a 'screen' format.
295200200529
295300200529      ** These fields are then compared with the fields on the input
295400200529      ** transaction.
295500200529
295600200529      ** Any errors detected by the called procedure take precedence
295700200529      ** over any errors found during the validation of the complete
295800200529      ** transaction.  The errors from the called procedure are kept
295900200529      ** separately and, if any are found, these errors will REPLACE
296000200529      ** the normal validation errors.
296100200529
296200200529     C                   CALLB     'SETRADAMD'
296300200529      *
296400200529      * INPUTS
296500200529      *
296600200529      * Return Code
296700200529     C                   PARM                    RetCodeIn
296800200529      *
296900200529      * Incoming Trade in Screen Format :
297000200529 Form * - Primary Details
297100200529      * - Secondary Details
297200200529      * - Third Screen Details
297300200529      * - Exchange Rate Details
297400200529      * - Settlement Details
297500200529      * - Charge & Commission Details
297600200529      * - SWIFT Details A
297700200529      * - SWIFT Details B
297800200529     C                   PARM                    TraninPrim
297900200529     C                   PARM                    TraninSeco
298000200529     C                   PARM                    TraninThir
298100200529     C                   PARM                    TraninExch
298200200529     C                   PARM                    TraninSett
298300200529     C                   PARM                    TraninChCm
298400200529     C                   PARM                    TraninSwfA
298500200529     C                   PARM                    TraninSwfB
298600200529      *
298700200529      * (Current) Trade in Screen Format :
298800200529 Form * - Primary Details
298900200529      * - Secondary Details
299000200529      * - Third Screen Details
299100200529      * - Exchange Rates Details
299200200529      * - Settlement Instructions
299300200529      * - Charges/Commissions
299400200529      * - SWIFT Details A
299500200529      * - SWIFT Details B
299600200529     C                   PARM                    CurTrPrim
299700200529     C                   PARM                    CurTrSeco
299800200529     C                   PARM                    CurTrThir
299900200529     C                   PARM                    CurTrExch
300000200529     C                   PARM                    CurTrSett
300100200529     C                   PARM                    CurTrChCm
300200200529     C                   PARM                    CurTrSwftA
300300200529     C                   PARM                    CurTrSwftB
300400200529      *
300500200529      * Customer classification
300600200529      * Trade incomplete ind
300700200529      * Trade Date Made Complete
300800200529     C                   PARM                    CustClass
300900200529     C                   PARM                    TINC
301000200529     C                   PARM                    TDMC
301100200529
301200200529      ** Settlement Currency Decimal Places
301300200529
301400200529     C                   PARM                    SetCcyDec
301500200529
301600200529      ** Hedge Accounting Phase B
301700200529
301800200529     C                   PARM                    CAS006
301900200529      *
302000200529      * OUTPUTS
302100200529      *
302200200529      * Error Indicators
302300200529     C                   PARM                    OKTrPrim
302400200529     C                   PARM                    OKTrSeco
302500200529     C                   PARM                    OKTrThir
302600200529     C                   PARM                    OKTrExch
302700200529     C                   PARM                    OKTrSett
302800200529     C                   PARM                    OKTrChCm
302900200529     C                   PARM                    OKTrSwft
303000200529      *
303100200529      * Error fields/message IDs/message data (arrays) from/to caller
303200200529     C                   PARM                    AmFldNamAr
303300200529     C                   PARM                    AmMsgIdArr
303400200529     C                   PARM                    AmMsgDtaAr
303500200529      *
303600200529      * Array index (3P0) from/to caller
303700200529     C                   PARM                    AmIdx
303800200529      *
303900200529      * Amendments OK
304000200529     C                   PARM                    AmendOk           1
304100200529      *
304200200529      * Reset of Fields in Error Required (Y/N)
304300200529     C                   PARM      'Y'           ResetErrs         1
304400200529
304500200529      ** If any errors overwrite previous error information
304600200529
304700200529     C                   IF        AmIdx <> 0
304800200529     C                   MOVEA     AmMsgIdArr    MsgidArr
304900200529     C                   MOVEA     AmFldNamAr    FldNameArr
305000200529     C                   MOVEA     AmMsgDtaAr    MsgDtaArr
305100200529     C                   Z-ADD     AmIdx         Idx
305200200529     C                   ENDIF
305300200529
305400200529     C                   ENDSR
305500200529      *****************************************************************
305600200529      /EJECT
305700200529      *****************************************************************
305800200529      *                                                               *
305900200529      * SETUPAMD - Set up fields that are needed in the validation    *
306000200529      *    of amendments and changes.                                 *
306100200529      *                                                               *
306200200529      *****************************************************************
306300200529     C     SetupAmd      BEGSR
306400200529
306500200529      * For Amends, put the complete (pre-existing) trade into the Valid
306600200529      *  file record - fields in this will be updated during processing
306700200529
306800200529     C                   MOVE      TradFilFmt    ValidTrad
306900200529     C                   MOVE      TX1AFilFmt    ValidTX1A
307000200529     C                   MOVE      TX1BFilFmt    ValidTX1B
307100200529     C                   MOVE      TX2AFilFmt    ValidTX2A
307200200529     C                   MOVE      TX2BFilFmt    ValidTX2B
307300200529
307400200529      *  Certain groups of fields on the trade may not be supplied for an
307500200529      *  amendment. If none of the fields in each group were supplied
307600200529      *  (i.e. all are blank), default the existing database values ...
307700200529
307800200529     C                   IF            (TranInExch = *blank)
307900200529     C                   EVAL      TranInExch = CurTrExch
308000200529     C                   ENDIF
308100200529
308200200529     C                   IF            (TranInSett = *blank)
308300200529     C                   EVAL      TranInSett = CurTrSett
308400200529     C                   ENDIF
308500200529
308600200529     C                   IF            (TranInChCm = *blank)
308700200529     C                   EVAL      TranInChCm = CurTrChCm
308800200529     C                   ENDIF
308900200529
309000200529     C                   IF            (TranInSwfA = *blank)
309100200529     C                   EVAL      TranInSwfA = CurTrSwftA
309200200529     C                   ENDIF
309300200529
309400200529     C                   IF            (TranInSwfB = *blank)
309500200529     C                   EVAL      TranInSwfB = CurTrSwftB
309600200529     C                   ENDIF
309700200529
309800200529     C                   ENDSR
309900200529      *****************************************************************
310000200529      /EJECT
310100200529      *****************************************************************
310200200529      *                                                               *
310300200529      * ValidateTr - Routine to validate the main tranaction details  *
310400200529      *                                                               *
310500200529      *****************************************************************
310600200529     C     ValidateTr    BEGSR
310700200529
310800200529      * Validate Trade Primary details
310900200529
311000200529     C                   EXSR      ValdTrPrim
311100200529                                                                                            BUG10476
311200200529      * Default Market Centre from security                                                 BUG10476
311300200529     C                   IF        DDMRKT = *BLANKS                                         BUG10476
311400200529     C                   EVAL      DDMRKT = SMCC                                            BUG10476
311500200529     C                   ENDIF                                                              BUG10476
311600200529
311700200529      * Validate Trade Secondary details
311800200529
311900200529     C                   IF        idx = 0                                                   BUG3950
312000200529     C                   EXSR      ValdTrSeco
312100200529
312200200529      ** Save Previous entries for interest amount recalculation                            BUG11194
312300200529     C                   EXSR      SavePrevEnt                                              BUG11194
312400200529                                                                                            BUG11194
312500200529      ** Validate more Trade details (third screen)
312600200529
312700200529     C                   IF        CAS006 = 'Y'
312800200529     C                   EXSR      ValdTrThir
312900200529     C                   ENDIF
313000200529
313100200529      * Default Trade Other details
313200200529      * (Exchange Rate, Settlement, Charges and Commissions)
313300200529                                                                                              247907
313400200529      * If with user inputs, keep current details for comparison later                        247907
313500200529     C                   If        TranInExch <> *blanks                                      247907
313600200529     C                   Eval      OldTranInExch = TranInExch                                 247907
313700200529     C                   Endif                                                                247907
313800200529     C*
313900200529      * Exchange Rates                                                                      BUG10021
314000200529     C**********         If        TranInExch = *blanks                            BUG10021 BUG11197
314100200529     C**********         If        TranInExch = *blanks                     BUG11197 BUG8690R 247907
314200200529     C                   EXSR      DfltTrExc                                                BUG10021
314300200529     C*********          Endif                                                     BUG10021 BUG11197
314400200529     C**********         Endif                                              BUG11197 BUG8690R 247907
314500200529     C*
314600200529      * If exchange rate defaulting was done, roght-align OldTranInExch for comparison        247907
314700200529     C                   If        DfltExFlg = 'Y'                                            247907
314800200529     C                   Exsr      RghtAlign                                                  247907
314900200529     C                   Eval      DfltExFlg = 'N'                                            247907
315000200529     C                   Endif                                                                247907
315100200529                                                                                              247907
315200200529      * If with user inputs, keep the retrieved transaction exchange details for              247907
315300200529      * validation later and display the original user screen inputs                          247907
315400200529     C                   If        OldTranInExch <> *blanks                                   247907
315500200529     C                             and OldTranInExch <> TranInExch                            247907
315600200529     C                   Eval      NewTranInExch = TranInExch                                 247907
315700200529     C                   Eval      NewV_TDER = V_TDER                                         247907
315800200529     C                   Eval      NewV_TMDI = V_TMDI                                         247907
315900200529     C                   Eval      TranInExch = OldTranInExch                                 247907
316000200529     C                   Eval      V_TDER = *zeros                                            247907
316100200529     C                   Eval      V_TMDI = *blanks                                           247907
316200200529     C                   Eval      V_TBCR = *zeros                                            247907
316300200529     C                   Endif                                                                247907
316400200529                                                                                              247907
316500200529      * If Settlement Currency and Nominal Currency is the same use the default value         247907
316600200529      * 1 and M.  These fields are protected when Settlement Ccy = Nominal Ccy except         247907
316700200529      * when Action is 'A'.                                                                   247907
316800200529     C                   If        NMCY = DDSETC and NDDSMDI <> *blanks                       247907
316900200529     C                             and NDDTDER <> *blanks and DDACTN <> 'A'                   247907
317000200529     C                   Eval      DDSMDI = NDDSMDI                                           247907
317100200529     C                   Eval      DDTDER = NDDTDER                                           247907
317200200529     C                   Eval      V_TDER = NewV_TDER                                         247907
317300200529     C                   Eval      V_TMDI = NewV_TMDI                                         247907
317400200529     C                   Endif                                                                247907
317500200529      *                                                                                       247907
317600200529      * Don't default if details already entered                                             BUG8690
317700200529     C                   EVAL      WDDCLTY2= *BLANKS                                        BUG11529
317800200529     C                   EVAL      WDDDELF = *BLANKS                                        BUG11529
317900200529     C                   EVAL      WDDDELT = *BLANKS                                        BUG11529
318000200529     C                   EVAL      WDDORBR = *BLANKS                                        BUG11529
318100200529     C                   EVAL      WrkDfltInd = 'N'                                         BUG11529
318200200529      *
318300200529     C                   If        DDCLTY2 <> *Blanks                                        BUG8690
318400200529     C                   MOVE      DDCLTY2       WDDCLTY2          1                         BUG8690
318500200529     C                   Eval      DDCLTY2 = *blanks                                         BUG8690
318600200529     C                   EndIf                                                               BUG8690
318700200529                                                                                             BUG8690
318800200529     C                   IF        DDDELF  <> *Blanks                                        BUG9917
318900200529     C                   EVAL      WDDDELF = DDDELF                                          BUG9917
319000200529     C                   EVAL      DDDELF = *Blanks                                          BUG9917
319100200529     C                   ENDIF                                                               BUG9917
319200200529                                                                                             BUG9917
319300200529     C                   IF        DDDELT  <> *Blanks                                        BUG9917
319400200529     C                   EVAL      WDDDELT = DDDELT                                          BUG9917
319500200529     C                   EVAL      DDDELT = *Blanks                                          BUG9917
319600200529     C                   ENDIF                                                               BUG9917
319700200529                                                                                             BUG8690
319800200529     C                   IF        DDORBR  <> *BLANKS                                       BUG11529
319900200529     C                   EVAL      WDDORBR = DDORBR                                         BUG11529
320000200529     C                   EVAL      DDORBR = *BLANKS                                         BUG11529
320100200529     C                   ENDIF                                                              BUG11529
320200200529      *
320300200529     C*****************  If        TranInExch = *blanks                             BUG8690 BUG10021
320400200529     C****************             and TranInSett = *blanks                         BUG8690 BUG10021
320500200529     C****************             and TranInChCm = *blanks                         BUG8690 BUG10021
320600200529     C                   If        TranInSett = *blanks                                     BUG10021
320700200529     C**********                   and TranInChCm = *blanks                        BUG10021 MD049746
320800200529     C                             or TranInChCm = *blanks                                  MD049746
320900200529                                                                                             BUG8690
321000200529     C                   IF        WDDCLTY2  <> *BLANKS                                     BUG11529
321100200529     C                   EVAL      DDCLTY2 = WDDCLTY2                                       BUG11529
321200200529     C                   ENDIF                                                              BUG11529
321300200529     C                   IF        WDDDELF  <> *BLANKS                                      BUG11529
321400200529     C                   EVAL      DDDELF  = WDDDELF                                        BUG11529
321500200529     C                   ENDIF                                                              BUG11529
321600200529     C                   IF        WDDDELT  <> *BLANKS                                      BUG11529
321700200529     C                   EVAL      DDDELT  = WDDDELT                                        BUG11529
321800200529     C                   ENDIF                                                              BUG11529
321900200529     C                   IF        WDDORBR  <> *BLANKS                                      BUG11529
322000200529     C                   EVAL      DDORBR  = WDDORBR                                        BUG11529
322100200529     C                   ENDIF                                                              BUG11529
322200200529     C                   EVAL      WrkDfltInd = 'Y'                                         BUG11529
322300200529      *
322400200529     C                   EXSR      SetTCNR                                                  MD049746
322500200529     C                   EXSR      DfltTrOTH
322600200529     C                   EndIf                                                               BUG8690
322700200529      *
322800200529     C                   IF        WrkDfltInd <> 'Y'                                        BUG11529
322900200529     C                   IF        WDDCLTY2  <> *BLANKS                                     BUG11529
323000200529     C                   Eval      DDCLTY2 = WDDCLTY2                                        BUG8690
323100200529     C                   ENDIF                                                              BUG11529
323200200529     C                   IF        WDDDELF  <> *BLANKS                                      BUG11529
323300200529     C                   EVAL      DDDELF  = WDDDELF                                         BUG9917
323400200529     C                   ENDIF                                                              BUG11529
323500200529     C                   IF        WDDDELT  <> *BLANKS                                      BUG11529
323600200529     C                   EVAL      DDDELT  = WDDDELT                                         BUG9917
323700200529     C                   ENDIF                                                              BUG11529
323800200529     C                   IF        WDDORBR  <> *BLANKS                                      BUG11529
323900200529     C                   EVAL      DDORBR  = WDDORBR                                        BUG11529
324000200529     C                   ENDIF                                                              BUG11529
324100200529     C                   ENDIF                                                              BUG11529
324200200529
324300200529      **CalcTrCHCM*-*Calculate*Trade*Charges/Commissions***************                       258901
324400200529      **********                                                                              258901
324500200529     C**********         EXSR      CalcTrCHCM                                                 258901
324600200529                                                                                      CGL014 BUG3145
324700200529      **CalcTrCVAL*-*Calculate*Trade*Countervalue                                     CGL014 BUG3145
324800200529                                                                                      CGL014 BUG3145
324900200529     C**********         EXSR      CalcTrCVAL                                         CGL014 BUG3145
325000200529
325100200529      * Validate Trade Other details
325200200529      * (Exchange Rate, Settlement, Charges and Commissions)
325300200529
325400200529     C                   EXSR      ValdTrOTH
325500200529                                                                                              258901
325600200529      * CalcTrCHCM - Calculate Trade Charges/Commissions                                      258901
325700200529                                                                                              258901
325800200529     C                   EXSR      CalcTrCHCM                                                 258901
325900200529     C*
326000200529      * CalcTrEUTX - Calculate EU Tax                                                         237063
326100200529                                                                                              237063
326200200529     C                   IF        CGL031 = 'Y'                                               237063
326300200529     C                   EXSR      CalcTrEUTX                                                 237063
326400200529     C                   ENDIF                                                                237063
326500200529     C*
326600200529      * Validate user input exchange details vs system defaulted details                      247907
326700200529      * When Action is 'A', user is not allowed to change the Settle Ccy                      247907
326800200529      * hence, no need to validate                                                            247907
326900200529     C                   If        DDACTN <> 'A'                                              247907
327000200529     C                   EXSR      ValdExch                                                   247907
327100200529     C                   Endif                                                                247907
327200200529                                                                                              247907
327300200529      * CalcTrCVAL - Calculate Trade Countervalue
327400200529
327500200529     C                   EXSR      CalcTrCVAL                                                BUG3145
327600200529     C**********         EXSR      CalcTrCVAL                                                 CGL014
327700200529                                                                                             BUG3145
327800200529      ** Additional validations                                                              BUG3145
327900200529      ** (Pay To Account)                                                                    BUG3145
328000200529                                                                                             BUG3145
328100200529     C                   IF        CGL014 = 'Y'  AND  V_PAYT <> *BLANKS                      BUG3145
328200200529     C                             AND  DDPAYTOK <> 'N'                                      BUG3145
328300200529     C                   EXSR      ValdTrAddl                                                BUG3145
328400200529     C                   ENDIF                                                               BUG3145
328500200529      *
328600200529      * If MT5XX Message Generation are installed,
328700200529      *
328800200529     C     S01401        IFEQ      'Y'
328900200529
329000200529      * Default Trade Extension (SWIFT) 'A' details
329100200529
329200200529     C     TranInSwfA    IFEQ      *BLANK
329300200529     C*****DDACTN        OREQ      'I'                                                      BUG18525
329400200529     C*****DDACTN        ANDEQ     'I'                                             BUG18525 BUG21092
329500200529     C     DDACTN        OREQ      'I'                                                      BUG21092
329600200529     C                   EXSR      DfltTrSwfA
329700200529     C                   END
329800200529
329900200529      *                                                                                       247873
330000200529      ** Destination of Settlements                                                           247873
330100200529      *                                                                                       247873
330200200529     C                   IF        DDTDTP = 'TP'                                              247873
330300200529     C                   MOVEL     V_DELT        WSNDR                                        247873
330400200529     C                   MOVEL     V_DELT        WDEST                                        247873
330500200529     C                   ELSE                                                                 247873
330600200529     C                   MOVEL     V_DELF        WSNDR                                        247873
330700200529     C                   MOVEL     V_DELF        WDEST                                        247873
330800200529     C                   ENDIF                                                                247873
330900200529     C                   MOVEL     V_SMTH        WSETP                                        247873
331000200529      *                                                                                       247873
331100200529     C                   IF        WDEST <> *Blanks                                           247873
331200200529     C                   EXSR      SR1100                                                     247873
331300200529     C                   MOVE      WWROU         A_DDROUS                                     247873
331400200529     C                   MOVE      WWROT         A_DDROTS                                     247873
331500200529     C                   ENDIF                                                                247873
331600200529      *                                                                                       247873
331700200529      **Validate*Trade*Extension*(SWIFT)*'A'*details**********************                    225421
331800200529      ** Validation to be done after Extended Settlement Information default                  225421
331900200529     C********           EXSR      ValdTrSwfA                                                 225421
332000200529      *
332100200529      ** Set up PDATA array fields for passing to SETSESVAL
332200200529      *
332300200529     C                   EXSR      SetPDATA
332400200529      *
332500200529      ** Validate Trade Extended Settlements Details A
332600200529      *
332700200529     C                   EVAL      PWHEN = 'A'
332800200529     C                   IF        (DDACTN = 'I') and (TranInExtA = *BLANKS)
332900200529     C                   EVAL      DFTFLG = 'Y'
333000200529     C                   ELSE
333100200529     C                   EVAL      DFTFLG = 'N'
333200200529     C                   ENDIF
333300200529     C                   EXSR      SRDefScn
333400200529      *                                                                                       245542
333500200529      ** Only default safekeeping account if not already defined                              245542
333600200529     C     AESSKAL       IFNE      *BLANKS                                                    245542
333700200529     C     ESSKAL        ORNE      *BLANKS                                                    245542
333800200529     C                   MOVE      *BLANKS       ADDSAFA                                      245542
333900200529     C                   ENDIF                                                                245542
334000200529      *                                                                                       245542
334100200529     C                   IF        TranInExtA = *BLANKS
334200200529      *                                                                                       245542
334300200529     C                   EVAL      TranInExtA = NwSE1ScnFmt
334400200529     C                   ENDIF
334500200529     C                   EXSR      ValdTrExSetA
334600200529                                                                                              225421
334700200529     C                   IF        DDACTN = 'I' AND A_T2SKAL = *BLANK                         225421
334800200529     C                   MOVE      AESSKAL       A_T2SKAL                                     225421
334900200529     C                   END                                                                  225421
335000200529      *                                                                                       247873
335100200529     C                   IF        A_T2SKAL = *Blanks AND AESSKAL <> *Blanks                  247873
335200200529     C                   MOVE      AESSKAL       A_T2SKAL                                     247873
335300200529     C                   ENDIF                                                                247873
335400200529                                                                                              225421
335500200529      * Validate Trade Extension (SWIFT) 'A' details                                          225421
335600200529     C                   EXSR      ValdTrSwfA                                                 225421
335700200529      *
335800200529      ** If screen B is required
335900200529      *
336000200529     C     CSW003        IFEQ      'Y'
336100200529     C     CustClass     IFEQ      'S'
336200200529     C     V_DELT        ANDNE     V_DELF
336300200529     C     CustClass     OREQ      'D'
336400200529     C     V_DELT        ANDNE     V_DELF
336500200529
336600200529      * Default Trade Extension (SWIFT) 'B' details
336700200529
336800200529     C     TranInSwfB    IFEQ      *BLANK
336900200529     C*****DDACTN        OREQ      'I'                                                      BUG18525
337000200529     C*****DDACTN        ANDEQ     'I'                                             BUG18525 BUG21092
337100200529     C     DDACTN        OREQ      'I'                                                      BUG21092
337200200529     C                   EXSR      DfltTrSwfB
337300200529     C                   END
337400200529      *                                                                                       247873
337500200529      ** Destination of Settlements                                                           247873
337600200529      *                                                                                       247873
337700200529     C                   IF        DDTDTP = 'TP'                                              247873
337800200529     C                   MOVEL     V_DELF        WSNDR                                        247873
337900200529     C                   MOVEL     V_DELF        WDEST                                        247873
338000200529     C                   ELSE                                                                 247873
338100200529     C                   MOVEL     V_DELT        WSNDR                                        247873
338200200529     C                   MOVEL     V_DELT        WDEST                                        247873
338300200529     C                   ENDIF                                                                247873
338400200529     C                   MOVEL     V_SMTH        WSETP                                        247873
338500200529      *                                                                                       247873
338600200529     C                   IF        WDEST <> *Blanks                                           247873
338700200529     C                   EXSR      SR1100                                                     247873
338800200529     C                   MOVE      WWROU         B_DDROUS                                     247873
338900200529     C                   MOVE      WWROT         B_DDROTS                                     247873
339000200529     C                   ENDIF                                                                247873
339100200529
339200200529      **Validate*Trade*Extension*(SWIFT)*'B'*details**********************                    225421
339300200529      ** Validation to be done after Extended Settlement Information default                  225421
339400200529     C************       EXSR      ValdTrSwfB                                                 225421
339500200529     C                   EXSR      SETPDATA
339600200529     C                   EVAL      PWHEN = 'B'
339700200529     C                   IF        (DDACTN = 'I') and (TranInExtB = *BLANKS)
339800200529     C                   EVAL      DFTFLG = 'Y'
339900200529     C                   ELSE
340000200529     C                   EVAL      DFTFLG = 'N'
340100200529     C                   ENDIF
340200200529     C                   EXSR      SRDefScn
340300200529     C                   IF        TranInExtB = *BLANKS
340400200529     C                   EVAL      TranInExtB = NwSE1ScnFmt
340500200529     C                   ENDIF
340600200529      *                                                                                     AR596191
340700200529     C                   IF        DDACTN = 'I' AND BESSKAL = *BLANK                        AR596191
340800200529     C                   MOVE      AESSKAL       BESSKAL                                    AR596191
340900200529     C                   ENDIF                                                              AR596191
341000200529      *                                                                                     AR596191
341100200529     C                   EXSR      ValdTrExSetB
341200200529
341300200529     C                   IF        DDACTN = 'I' AND B_T2SKAL = *BLANK                         225421
341400200529     C                   MOVE      AESSKAL       B_T2SKAL                                     225421
341500200529     C                   END                                                                  225421
341600200529      * Validate Trade Extension (SWIFT) 'B' details                                          225421
341700200529     C                   EXSR      ValdTrSwfB                                                 225421
341800200529     C                   END
341900200529     C                   END
342000200529
342100200529     C                   END
342200200529      *                                                                                       CER001
342300200529     C     Idx           IFNE      0                                                          CER001
342400200529     C                   GOTO      EvalidTr                                                   CER001
342500200529     C                   ENDIF                                                                CER001
342600200529      *                                                                                       CER001
342700200529      ** Validate Extension Details Screen                                                    CER001
342800200529      *                                                                                       CER001
342900200529     C                   IF        ULX603 = 'Y'                                               CER001
343000200529     C                   EXSR      ValidateLUX                                                CER001
343100200529     C                   ENDIF                                                                CER001
343200200529      *                                                                                       CER001
343300200529     C                   ENDIF                                                               BUG3950
343400200529
343500200529     C     EValidTr      ENDSR
343600200529      *****************************************************************
343700200529      /EJECT                                                                                  CER001
343800200529      *****************************************************************                       CER001
343900200529      *                                                               *                       CER001
344000200529      * ValidateLUX  - Validate Extension Details                     *                       CER001
344100200529      *                                                               *                       CER001
344200200529      * Calls:                                                        *                       CER001
344300200529      *                                                               *                       CER001
344400200529      *****************************************************************                       CER001
344500200529      *                                                                                       CER001
344600200529     C     ValidateLUX   BEGSR                                                                CER001
344700200529     C                   EVAL      PETDRF  =  DDTDRF                                          CER001
344800200529     C                   MOVEL(P)  DDBPBK        UTDBK                                        CER001
344900200529     C                   MOVEL(P)  DDCNUM        UVTCNR                                       CER001
345000200529     C                   MOVEL     V_TDVD        #1TDVD                                       CER001
345100200529     C                   MOVEL     V_TDDT        #1TDDT                                       CER001
345200200529     C                   MOVEL     ISSD          #1ISSD                                       CER001
345300200529     C                   MOVEL     MATY          #1MATY                                       CER001
345400200529      *                                                                                       CER001
345500200529     C                   CALLB     'SETRAD2VL'                                                CER001
345600200529     C                   PARM                    DDACTN                                       CER001
345700200529     C                   PARM                    DATALUX                                      CER001
345800200529     C                   PARM                    RegData                                      CER001
345900200529     C                   PARM                    OkFlagsDS                                    CER001
346000200529     C                   PARM                    FldNameArr                                   CER001
346100200529     C                   PARM                    MsgIdArr                                     CER001
346200200529     C                   PARM                    MsgDtaArr                                    CER001
346300200529     C                   PARM                    Idx                                          CER001
346400200529     C                   PARM                    WFldNamArr                                   CER001
346500200529     C                   PARM                    WMsgIdArr                                    CER001
346600200529     C                   PARM                    WMsgDtaArr                                   CER001
346700200529     C                   PARM                    WIdx                                         CER001
346800200529     C                   PARM                    ValidLUX                                     CER001
346900200529      *                                                                                       CER001
347000200529     C                   PARM                    ULX008                                       CER001
347100200529     C                   ENDSR                                                                CER001
347200200529      *                                                                                       CER001
347300200529      *****************************************************************                       CER001
347400200529      /EJECT
347500200529      *****************************************************************
347600200529      *                                                               *
347700200529      * ValdTrPrim - Validate Trade Primary details                   *
347800200529      *                                                               *
347900200529      *****************************************************************
348000200529     C     ValdTrPrim    BEGSR
348100200529
348200200529     C                   CALLB     'SETRADPVAL'
348300200529
348400200529      * INPUTS
348500200529
348600200529      * Response mode
348700200529     C                   PARM      'S'           RespMode          1
348800200529
348900200529      ** Trade Primary Details
349000200529     C                   PARM                    TranInPrim
349100200529      * Custom Extra Data file data
349200200529     C                   PARM                    ExtData
349300200529
349400200529      ** Trade settlement currency
349500200529     C                   PARM                    DDSETC            3
349600200529      *
349700200529      ** Default & Validate (Y or N)
349800200529     C                   PARM      'Y'           Default           1
349900200529     C                   PARM      'Y'           Validate          1
350000200529
350100200529      * Output details of original book.
350200200529     C                   PARM                    OLDBK1
350300200529     C                   PARM                    WARNIND
350400200529      *
350500200529      ** First Buy-sell back indicator
350600200529     C                   PARM                    PFBYSL            1
350700200529      *
350800200529      ** First Buy-sell book code
350900200529     C                   PARM                    PFBPBK            2
351000200529      *
351100200529      ** First Buy-sell counterparty
351200200529     C**********         PARM      *ZEROS        PFTCNR            6 0                       CSD027A
351300200529     C                   PARM      *Blanks       PFTCNR            6                         CSD027A
351400200529      *
351500200529      ** First Buy-sell trade type
351600200529     C                   PARM                    PFTDTP            2
351700200529      *
351800200529      ** First Buy-sell Value Date
351900200529     C                   PARM      *ZEROS        PFTDVD            5 0
352000200529      *
352100200529      ** First Buy-sell Security Shortname
352200200529     C                   PARM                    PFSESN           10
352300200529     C                   PARM                    CallFromVU                                   CAP087
352400200529      * OUTPUTS
352500200529
352600200529      ** Security Details
352700200529      ** Investment Type Details
352800200529     C                   PARM                    SECTY
352900200529     C                   PARM                    INVTP
353000200529
353100200529      * Coupon Rate
353200200529      * Current Factor
353300200529     C                   PARM                    DDCPNR           13
353400200529     C                   PARM                    DDCFCT           12
353500200529
353600200529      ** Nominal Currency Details
353700200529     C                   PARM                    NomCcyDts
353800200529      *
353900200529      ** Customer (Counterparty) Details
354000200529     C                   PARM                    CustDts
354100200529      *
354200200529      ** Portfolio Details
354300200529     C                   PARM                    PortDts
354400200529      ** Default basket for backup withholding
354500200529     C                   PARM                    PDRBW
354600200529
354700200529      ** Trade Primary Details OK inds
354800200529     C                   PARM                    OKTrPrim
354900200529
355000200529      * Error fields/message IDs/message data (arrays) from/to caller
355100200529     C                   PARM                    FldNameArr
355200200529     C                   PARM                    MsgIDArr
355300200529     C                   PARM                    MsgDtaArr
355400200529      * Array index (3P0) from/to caller
355500200529     C                   PARM                    Idx
355600200529
355700200529      * Warning fields/message IDs/message data (arrays) from/to caller
355800200529     C                   PARM                    WFldNamArr
355900200529     C                   PARM                    WMsgIDArr
356000200529     C                   PARM                    WMsgDtaArr
356100200529      * Array index (3P0) from/to caller
356200200529     C                   PARM                    WIdx
356300200529
356400200529      * Valid Trade layout (DS) from/to caller
356500200529     C                   PARM                    ValidTrad
356600200529
356700200529      * PB Order Number
356800200529     C                   PARM                    DDORDE
356900200529
357000200529      ** Save The Counterparty Classification for Output.
357100200529     C                   EVAL      CPartyClass = CustClass
357200200529
357300200529     C                   ENDSR
357400200529      *****************************************************************
357500200529      /EJECT
357600200529      *****************************************************************
357700200529      *                                                               *
357800200529      * ValdTrSeco - Validate Trade Secondary details                 *
357900200529      *                                                               *
358000200529      *****************************************************************
358100200529     C     ValdTrSeco    BEGSR
358200200529
358300200529     C                   CALLB     'SETRADSVAL'
358400200529
358500200529      * INPUTS
358600200529
358700200529      * Response mode
358800200529     C                   PARM      'S'           RespMode          1
358900200529
359000200529      ** Trade Primary Details
359100200529      ** Trade Secondary Details
359200200529     C                   PARM                    TranInPrim
359300200529     C                   PARM                    TranInSeco
359400200529      * Custom Extra Data file data
359500200529     C                   PARM                    ExtData
359600200529      *
359700200529      ** Default & Validate (Y or N)
359800200529     C                   PARM      'Y'           Default
359900200529     C                   PARM      'Y'           Validate
360000200529
360100200529      ** Security Details
360200200529      ** Investment Type Details
360300200529     C                   PARM                    SECTY
360400200529     C                   PARM                    INVTP
360500200529
360600200529      ** Nominal Currency Details
360700200529     C                   PARM                    NomCcyDts
360800200529      *
360900200529      ** Customer (Counterparty) Details
361000200529     C                   PARM                    CustDts
361100200529      *
361200200529      ** MT5xx SSI (Phase 2)
361300200529     C                   PARM                    CSE028
361400200529                                                                                              CGL031
361500200529      ** CGL031 Switchable Feature                                                            CGL031
361600200529     C                   PARM                    CGL031                                       CGL031
361700200529                                                                                              237063
361800200529      ** Current File Trade Date                                                              237063
361900200529     C                   PARM                    TDVD                                         237063
362000200529      *
362100200529      * OUTPUTS
362200200529      *
362300200529      ** Settlement Currency Details
362400200529     C                   PARM                    SetCcyDts
362500200529
362600200529      ** Trade Secondary Details OK inds
362700200529     C                   PARM                    OKTrSeco
362800200529
362900200529      * Error fields/message IDs/message data (arrays) from/to caller
363000200529     C                   PARM                    FldNameArr
363100200529     C                   PARM                    MsgIDArr
363200200529     C                   PARM                    MsgDtaArr
363300200529      * Array index (3P0) from/to caller
363400200529     C                   PARM                    Idx
363500200529
363600200529      * Warning fields/message IDs/message data (arrays) from/to caller
363700200529     C                   PARM                    WFldNamArr
363800200529     C                   PARM                    WMsgIDArr
363900200529     C                   PARM                    WMsgDtaArr
364000200529      * Array index (3P0) from/to caller
364100200529     C                   PARM                    WIdx
364200200529
364300200529      * Valid Trade layout (DS) from/to caller
364400200529     C                   PARM                    ValidTrad
364500200529
364600200529     C                   ENDSR
364700200529      *****************************************************************
364800200529      /EJECT
364900200529      *****************************************************************
365000200529      *                                                               *
365100200529      *  ValdTrThir - Validate Trade third screen details             *
365200200529      *                                                               *
365300200529      *****************************************************************
365400200529
365500200529     C     ValdTrThir    BEGSR
365600200529
365700200529     C                   CALLB     'SETRADTVAL'
365800200529
365900200529      ** INPUTS
366000200529      ** Response mode
366100200529
366200200529     C                   PARM                    RespMode
366300200529
366400200529      ** Trade Primary Details
366500200529      ** Trade Secondary Details
366600200529      ** Trade Third screen details
366700200529
366800200529     C                   PARM                    TranInPrim
366900200529     C                   PARM                    TranInSeco
367000200529     C                   PARM                    TranInThir
367100200529
367200200529      ** Custom Extra Data file data
367300200529
367400200529     C                   PARM                    ExtData
367500200529
367600200529      ** Default & Validate (Y or N)
367700200529
367800200529     C                   PARM      'Y'           Default
367900200529     C                   PARM      'Y'           Validate
368000200529
368100200529      ** Security Details
368200200529      ** Investment Type Details
368300200529
368400200529     C                   PARM                    SECTY
368500200529     C                   PARM                    INVTP
368600200529
368700200529      ** Coupon Rate using NTR
368800200529      ** Net Treasury Price
368900200529
369000200529     C                   PARM                    DDHACR
369100200529     C                   PARM                    DDPRICN
369200200529
369300200529      ** Customer (Counterparty) Details
369400200529      ** Portfolio Details
369500200529      ** Nominal Currency Details
369600200529      ** Settlement Currency Details
369700200529
369800200529     C                   PARM                    CustDts
369900200529     C                   PARM                    PortDts
370000200529     C                   PARM                    NomCcyDts
370100200529     C                   PARM                    SetCcyDts
370200200529
370300200529      ** OUTPUTS
370400200529
370500200529      ** Trade Third screen details OK inds
370600200529
370700200529     C                   PARM                    OKTrThir
370800200529
370900200529      ** Error fields/message IDs/message data (arrays) from/to caller
371000200529
371100200529     C                   PARM                    FldNameArr
371200200529     C                   PARM                    MsgIDArr
371300200529     C                   PARM                    MsgDtaArr
371400200529
371500200529      ** Array index (3P0) from/to caller
371600200529
371700200529     C                   PARM                    Idx
371800200529
371900200529      ** Warning fields/message IDs/message data (arrays) from/to caller
372000200529
372100200529     C                   PARM                    WFldNamArr
372200200529     C                   PARM                    WMsgIDArr
372300200529     C                   PARM                    WMsgDtaArr
372400200529
372500200529      ** Array index (3P0) from/to caller
372600200529
372700200529     C                   PARM                    WIdx
372800200529
372900200529      ** Valid Trade layout (DS) from/to caller
373000200529
373100200529     C                   PARM                    ValidTrad
373200200529
373300200529     C                   ENDSR
373400200529
373500200529      *****************************************************************
373600200529      /EJECT
373700200529      *****************************************************************                     BUG10021
373800200529      *                                                               *                     BUG10021
373900200529      * DfltTrExc - Default Trade Exchange Rates Details              *                     BUG10021
374000200529      *                                                               *                     BUG10021
374100200529      *****************************************************************                     BUG10021
374200200529     C     DfltTrExc     BEGSR                                                              BUG10021
374300200529                                                                                            BUG10021
374400200529      ** EXCHANGE RATE DEFAULTING                                                           BUG10021
374500200529                                                                                            BUG10021
374600200529     C     DDACTN        IFEQ      'I'                                                      BUG10021
374700200529     C     DDACTN        OREQ      'C'                                                      BUG10021
374800200529     C     DDSETC        ANDNE     SETC                                                     BUG10021
374900200529     C     DDACTN        OREQ      'A'                                                      BUG11197
375000200529     C     DDSETC        ANDNE     SETC                                                     BUG11197
375100200529     C*****TRANINEXCH    OREQ      *BLANKS                                         BUG11197 BUG8690R
375200200529     C     TranInExch    OREQ      *BLANKS                                  BUG11197 BUG8690R 247907
375300200529                                                                                            BUG10021
375400200529     C                   CALLB     'SETEXCHDFT'                                             BUG10021
375500200529                                                                                            BUG10021
375600200529      * INPUTS                                                                              BUG10021
375700200529      *                                                                                     BUG10021
375800200529      ** Nominal Currency                                                                   BUG10021
375900200529      ** Settlement Currency                                                                BUG10021
376000200529     C                   PARM                    NMCY              3                        BUG10021
376100200529     C                   PARM                    DDSETC            3                        BUG10021
376200200529                                                                                            BUG10021
376300200529      ** Nominal Currency Details                                                           BUG10021
376400200529      ** Settlement Currency Details                                                        BUG10021
376500200529     C                   PARM                    NomCcyDts                                  BUG10021
376600200529     C                   PARM                    SetCcyDts                                  BUG10021
376700200529      ** ICD                                                                                BUG10021
376800200529      ** Euro Currency                                                                      BUG10021
376900200529      ** EMU SE Settlement Ccy Conv.                                                        BUG10021
377000200529     C                   PARM                    BKEURO                                     BUG10021
377100200529     C                   PARM                    CEU005                                     BUG10021
377200200529                                                                                            BUG10021
377300200529      * OUTPUTS                                                                             BUG10021
377400200529                                                                                            BUG10021
377500200529      ** Trade Exchange Rate screen fields                                                  BUG10021
377600200529                                                                                            BUG10021
377700200529     C                   PARM                    TranInExch                                 BUG10021
377800200529                                                                                            BUG10021
377900200529      ** Trade Exchange Rate file fields                                                    BUG10021
378000200529                                                                                            BUG10021
378100200529     C                   PARM                    V_TDER           13 8                      BUG10021
378200200529     C                   PARM                    V_TMDI            1                        BUG10021
378300200529     C                   PARM                    V_TBCR           13 8                      BUG10021
378400200529                                                                                            BUG10021
378500200529      ** Set default flag                                                                     247907
378600200529     C                   Move      'Y'           DfltExFlg         1                          247907
378700200529                                                                                              247907
378800200529     C                   END                                                                BUG10021
378900200529                                                                                            BUG10021
379000200529     C                   ENDSR                                                              BUG10021
379100200529      /EJECT                                                                                BUG10021
379200200529      *****************************************************************                     BUG10021
379300200529      *****************************************************************
379400200529      *                                                               *
379500200529      * DfltTrOTH - Default Trade Other details                       *
379600200529      *                                                               *
379700200529      *****************************************************************
379800200529     C     DfltTrOTH     BEGSR
379900200529
380000200529     ****EXCHANGE*RATE*DEFAULTING***                                                        BUG10021
380100200529     ***********                                                                            BUG10021
380200200529     C*****DDACTN        IFEQ      'I'                                                      BUG10021
380300200529     C*****DDACTN        OREQ      'C'                                                      BUG10021
380400200529     C*****DDSETC        ANDNE     SETC                                                     BUG10021
380500200529     *********                                                                              BUG10021
380600200529     C********           CALLB     'SETEXCHDFT'                                             BUG10021
380700200529     ********                                                                               BUG10021
380800200529     ***INPUTS*                                                                             BUG10021
380900200529     ********                                                                               BUG10021
381000200529     *** Nominal Currency                                                                   BUG10021
381100200529     ****Settlement Currency                                                                BUG10021
381200200529     C*******            PARM                    NMCY              3                        BUG10021
381300200529     C*******            PARM                    DDSETC            3                        BUG10021
381400200529     ********                                                                               BUG10021
381500200529     ****Nominal Currency Details                                                           BUG10021
381600200529     ****Settlement Currency Details                                                        BUG10021
381700200529     C********           PARM                    NomCcyDts                                  BUG10021
381800200529     C********           PARM                    SetCcyDts                                  BUG10021
381900200529      ***ICD                                                                                BUG10021
382000200529      ***Euro Currency                                                                      BUG10021
382100200529      ***EMU SE Settlement Ccy Conv.                                                        BUG10021
382200200529     C*******            PARM                    BKEURO                                     BUG10021
382300200529     C******             PARM                    CEU005                                     BUG10021
382400200529     ********                                                                               BUG10021
382500200529     ***OUTPUTS                                                                             BUG10021
382600200529     ********                                                                               BUG10021
382700200529     ****Trade*Exchange Rate screen fields                                                  BUG10021
382800200529     ********                                                                               BUG10021
382900200529     C*******            PARM                    TranInExch                                 BUG10021
383000200529     *********                                                                              BUG10021
383100200529     ****Trade*Exchange Rate file fields                                                    BUG10021
383200200529     ********                                                                               BUG10021
383300200529     C********           PARM                    V_TDER           13 8                      BUG10021
383400200529     C********           PARM                    V_TMDI            1                        BUG10021
383500200529     C********           PARM                    V_TBCR           13 8                      BUG10021
383600200529                                                                                            BUG10021
383700200529     C********           END                                                                BUG10021
383800200529
383900200529      ** SETTLEMENT INSTRUCTION DEFAULTING
384000200529     C                   IF        TranInSett = *BLANKS                                     MD049746
384100200529
384200200529     C     DDACTN        IFEQ      'I'
384300200529
384400200529     C                   CALLB     'SETSETIDFT'
384500200529
384600200529      * INPUTS
384700200529
384800200529      ** Booking branch
384900200529      ** Incomplete Ind
385000200529      ** Trade Type
385100200529      ** Settlement Currency
385200200529      ** Market Ind.
385300200529      ** Book Code.
385400200529      ** Market Centre
385500200529     C                   PARM                    DDBRCD            3
385600200529     C                   PARM                    DDINCS            1
385700200529     C                   PARM                    DDTDTP            2
385800200529     C                   PARM                    DDSETC            3
385900200529     C                   PARM                    DDTDMI            1
386000200529     C                   PARM                    DDBPBK
386100200529     C                   PARM                    DDMRKT
386200200529
386300200529      ** Investment type (SECTYD)
386400200529
386500200529     C                   PARM                    SITP              3
386600200529
386700200529      ** Nominal Currency Details
386800200529      ** Settlement Currency Details
386900200529     C                   PARM                    NomCcyDts
387000200529     C                   PARM                    SetCcyDts
387100200529
387200200529      ** Customer (Counterparty) Details
387300200529      ** ( Note: Customer Participant/Non-participant Indicator 1 and
387400200529      **  Customer Participant/Non-participant Indicator 2 are also outputs)
387500200529     C                   PARM                    CustDts
387600200529
387700200529
387800200529      ** ICD
387900200529      ** Depot 1 (Eurclear)
388000200529      ** Depot 2 (Cedel)
388100200529     C                   PARM                    BVDR1             6
388200200529     C                   PARM                    BVDR2             6
388300200529      *
388400200529      ** MT5xx SSI (Phase 2)
388500200529     C                   PARM                    CSE028
388600200529
388700200529      * OUTPUTS
388800200529
388900200529      ** Trade Settlement Instructions
389000200529
389100200529     C                   PARM                    TranInSett
389200200529
389300200529     C                   END
389400200529     C                   ENDIF                                                              MD049746
389500200529
389600200529      ** CHARGE/COMMISSION DEFAULTING
389700200529     C                   IF        TranInChCm = *BLANKS                                     MD049746
389800200529
389900200529     C     DDACTN        IFEQ      'I'
390000200529     C     DDACTN        OREQ      'A'
390100200529     C     DDACTN        OREQ      'C'
390200200529
390300200529     C                   CALLB     'SETCHCMDFT'
390400200529
390500200529      * INPUTS
390600200529
390700200529      ** Bulk reference
390800200529      ** Incomplete Ind.
390900200529      ** Market Centre
391000200529     C                   PARM                    DDBLKR            6
391100200529     C                   PARM                    DDINCS            1
391200200529     C                   PARM                    DDMRKT            2
391300200529      *
391400200529      ** Trade Counterparty
391500200529     C                   PARM                    TCNR
391600200529      *
391700200529      ** Security details
391800200529     C                   PARM                    SECTY
391900200529      *
392000200529      ** Nominal Currency Details
392100200529     C                   PARM                    NomCcyDts
392200200529      *
392300200529      ** Customer (Counterparty) Details
392400200529     C                   PARM                    CustDts
392500200529      *
392600200529      ** Portfolio Details
392700200529     C                   PARM                    PortDts
392800200529      *
392900200529      ** ICD
393000200529      ** PM installed
393100200529      ** Bank Portfolios installed
393200200529      ** Ref applied to 9997 portfolio
393300200529      ** Autocharge Option
393400200529      ** Adjust Commission Same Day T
393500200529      ** Priority of Cust Grp Dft
393600200529      ** Priority of Invst typ Dft
393700200529      ** Priority of Market Dft
393800200529      ** Priority of Cust Chrg Dft
393900200529      ** Midas/TOF I/F installed
394000200529     C                   PARM                    BGPFMG            1
394100200529     C                   PARM                    FCPORS            1
394200200529     C                   PARM                    FCR997            4
394300200529     C                   PARM                    BVACOP            1
394400200529     C                   PARM                    BVACSD            1
394500200529     C                   PARM                    BVPCSD            1
394600200529     C                   PARM                    BVPIDF            1
394700200529     C                   PARM                    BVPMDF            1
394800200529     C                   PARM                    BVPOCD            1
394900200529     C                   PARM                    S01496            1
395000200529     C                   PARM                    BGN4ST            1
395100200529
395200200529      * OUTPUTS
395300200529
395400200529      ** Commission Rebate %
395500200529     C                   PARM                    CMRP              5 3
395600200529
395700200529      ** Trade Charges & Commissions screen fields
395800200529
395900200529     C                   PARM                    TranInChcm
396000200529
396100200529      ** Trade Charges & Commissions file fields
396200200529
396300200529     C                   PARM                    V_TBCC            2
396400200529     C                   PARM                    V_TCCC            2
396500200529     C                   PARM                    V_TCC1            2
396600200529     C                   PARM                    V_TCC2            2
396700200529
396800200529     C                   END
396900200529     C                   ENDIF                                                              MD049746
397000200529
397100200529     C                   ENDSR
397200200529      *****************************************************************
397300200529      /EJECT
397400200529      *****************************************************************
397500200529      *                                                               *
397600200529      * ValdTrOTH - Validate Trade Other details                      *
397700200529      *                                                               *
397800200529      *****************************************************************
397900200529     C     ValdTrOTH     BEGSR
398000200529
398100200529     C                   CALLB     'SETRADOVAL'
398200200529
398300200529      * INPUTS
398400200529
398500200529      * Response mode
398600200529     C                   PARM      'S'           RespMode          1
398700200529
398800200529      ** Trade Primary Details
398900200529      ** Trade Secondary Details
399000200529      ** Trade Exchange Rates
399100200529      ** Trade Settlement Instructions
399200200529      ** Trade Charge & Commissions
399300200529     C                   PARM                    TranInPrim
399400200529     C                   PARM                    TranInSeco
399500200529     C                   PARM                    TranInExch
399600200529     C                   PARM                    TranInSett
399700200529     C                   PARM                    TranInChcm
399800200529      * Custom Extra Data file data
399900200529     C                   PARM                    ExtData
400000200529
400100200529      ** Security Details
400200200529      ** Investment Type Details
400300200529     C                   PARM                    SECTY
400400200529     C                   PARM                    INVTP
400500200529      *
400600200529      ** Customer (Counterparty) Details
400700200529     C                   PARM                    CustDts
400800200529
400900200529      ** Portfolio Details
401000200529     C                   PARM                    PortDts
401100200529
401200200529      ** Nominal Currency Details
401300200529      ** Settlement Currency Details
401400200529     C                   PARM                    NomCcyDts
401500200529     C                   PARM                    SetCcyDts
401600200529                                                                                              CGL031
401700200529      ** CGL031 Switchable Feature                                                            CGL031
401800200529     C                   PARM                    CGL031                                       CGL031
401900200529      *
402000200529      * OUTPUTS
402100200529      *
402200200529      ** FX Margin Amount
402300200529      ** Portfolio exchange rate & M/D ind screen format
402400200529     C                   PARM                    DDMAMT           18
402500200529     C                   PARM                    DDSPXR           14
402600200529     C                   PARM                    DDSPMD            1
402700200529
402800200529      ** Trade Exchange Rates OK inds
402900200529      ** Trade Settlement Instructions OK
403000200529      ** Trade Charge & Commissions OK inds
403100200529     C                   PARM                    OKTrExch
403200200529     C                   PARM                    OKTrSett
403300200529     C                   PARM                    OKTrChcm
403400200529
403500200529      * Error fields/message IDs/message data (arrays) from/to caller
403600200529     C                   PARM                    FldNameArr
403700200529     C                   PARM                    MsgIDArr
403800200529     C                   PARM                    MsgDtaArr
403900200529      * Array index (3P0) from/to caller
404000200529     C                   PARM                    Idx
404100200529
404200200529      * Warning fields/message IDs/message data (arrays) from/to caller
404300200529     C                   PARM                    WFldNamArr
404400200529     C                   PARM                    WMsgIDArr
404500200529     C                   PARM                    WMsgDtaArr
404600200529      * Array index (3P0) from/to caller
404700200529     C                   PARM                    WIdx
404800200529
404900200529      * Valid Trade layout (DS) from/to caller
405000200529     C                   PARM                    ValidTrad
405100200529
405200200529     C                   ENDSR
405300200529      *****************************************************************
405400200529      /EJECT
405500200529      *****************************************************************                      BUG3145
405600200529      *                                                               *                      BUG3145
405700200529      * ValdTrAddl - Additional validations                           *                      BUG3145
405800200529      *                                                               *                      BUG3145
405900200529      *****************************************************************                      BUG3145
406000200529     C     ValdTrAddl    BEGSR                                                               BUG3145
406100200529                                                                                             BUG3145
406200200529     C                   CALLB     'SETRADAVAL'                                              BUG3145
406300200529                                                                                             BUG3145
406400200529      ** INPUTS                                                                              BUG3145
406500200529                                                                                             BUG3145
406600200529      ** Action Code                                                                         BUG3145
406700200529      ** Nominal Currency                                                                    BUG3145
406800200529     C                   PARM                    DDACTN                                      BUG3145
406900200529     C                   PARM                    NMCY                                        BUG3145
407000200529                                                                                             BUG3145
407100200529      ** Valid Trade layout (DS) from/to caller                                              BUG3145
407200200529     C                   PARM                    ValidTrad                                   BUG3145
407300200529                                                                                             BUG3145
407400200529      ** OUTPUTS                                                                             BUG3145
407500200529                                                                                             BUG3145
407600200529      ** Trade Settlement Instructions OK                                                    BUG3145
407700200529     C                   PARM                    OKTrSett                                    BUG3145
407800200529                                                                                             BUG3145
407900200529      ** Error fields/message IDs/message data (arrays) from/to caller                       BUG3145
408000200529     C                   PARM                    FldNameArr                                  BUG3145
408100200529     C                   PARM                    MsgIDArr                                    BUG3145
408200200529     C                   PARM                    MsgDtaArr                                   BUG3145
408300200529                                                                                             BUG3145
408400200529      ** Array index (3P0) from/to caller                                                    BUG3145
408500200529     C                   PARM                    Idx                                         BUG3145
408600200529                                                                                             BUG3145
408700200529      ** Warning fields/message IDs/message data (arrays) from/to caller                     BUG3145
408800200529     C                   PARM                    WFldNamArr                                  BUG3145
408900200529     C                   PARM                    WMsgIDArr                                   BUG3145
409000200529     C                   PARM                    WMsgDtaArr                                  BUG3145
409100200529                                                                                             BUG3145
409200200529      ** Array index (3P0) from/to caller                                                    BUG3145
409300200529     C                   PARM                    WIdx                                        BUG3145
409400200529                                                                                             BUG3145
409500200529     C                   ENDSR                                                               BUG3145
409600200529      *****************************************************************                      BUG3145
409700200529      /EJECT                                                                                 BUG3145
409800200529      *                                                               *                       247907
409900200529      * ValdExch -Validate Exchange Rate: User input vs System default*                       247907
410000200529      *                                                               *                       247907
410100200529      *****************************************************************                       247907
410200200529     C     ValdExch      BEGSR                                                                247907
410300200529                                                                                              247907
410400200529     C                   If        NewTranInExch <> OldTranInExch                             247907
410500200529     C                             and OldTranInExch <> *blanks                               247907
410600200529     C                             and NewTranInExch <> *blanks                               247907
410700200529                                                                                              247907
410800200529      ** Difference in Exchange Rate                                                          247907
410900200529     C                   If        DDTDER <> NDDTDER and DDTDER <> *blanks                    247907
411000200529     C                   ADD       1             WIdx                                         247907
411100200529     C                   Eval      WFldNamArr(WIdx) = 'DDTDER'                                247907
411200200529     C                   Eval      WMsgIDArr(WIdx) = 'MMA0741'                                247907
411300200529     C                   Eval      WMsgDtaArr(WIdx) = NDDTDER                                 247907
411400200529     C                   Endif                                                                247907
411500200529                                                                                              247907
411600200529      ** Difference in M/D Indicator                                                          247907
411700200529     C                   If        DDSMDI <> NDDSMDI and DDSMDI <> *blanks                    247907
411800200529     C                   ADD       1             WIdx                                         247907
411900200529     C                   Eval      WFldNamArr(WIdx) = 'DDSMDI'                                247907
412000200529     C                   Eval      WMsgIDArr(WIdx) = 'MMA0742'                                247907
412100200529     C                   Eval      WMsgDtaArr(WIdx) = NDDSMDI                                 247907
412200200529     C                   Endif                                                                247907
412300200529                                                                                              247907
412400200529      ** Difference in Margin                                                                 247907
412500200529     C                   If        DDFXMP <> NDDFXMP and DDFXMP <> *blanks                    247907
412600200529     C                   ADD       1             WIdx                                         247907
412700200529     C                   Eval      WFldNamArr(WIdx) = 'DDFXMP'                                247907
412800200529     C                   Eval      WMsgIDArr(WIdx) = 'MMA0743'                                247907
412900200529     C                   Eval      WMsgDtaArr(WIdx) = NDDFXMP                                 247907
413000200529     C                   Endif                                                                247907
413100200529                                                                                              247907
413200200529      ** Difference in Base Rate                                                              247907
413300200529     C                   If        DDBRTE <> NDDBRTE and DDBRTE <> *blanks                    247907
413400200529     C                   ADD       1             WIdx                                         247907
413500200529     C                   Eval      WFldNamArr(WIdx) = 'DDBRTE'                                247907
413600200529     C                   Eval      WMsgIDArr(WIdx) = 'MMA0744'                                247907
413700200529     C                   Eval      WMsgDtaArr(WIdx) = NDDBRTE                                 247907
413800200529     C                   Endif                                                                247907
413900200529     C                   Endif                                                                247907
414000200529                                                                                              247907
414100200529     C                   ENDSR                                                                247907
414200200529      *****************************************************************                       247907
414300200529      /EJECT                                                                                  247907
414400200529      *****************************************************************                       247907
414500200529      *                                                               *                       247907
414600200529      * RghtAlign - Right Align fields                                *                       247907
414700200529      *                                                               *                       247907
414800200529      *****************************************************************                       247907
414900200529     C     RghtAlign     BEGSR                                                                247907
415000200529                                                                                              247907
415100200529      ** Settlement Exchange Rate                                                             247907
415200200529     C                   If        ODDTDER <> *Blanks                                         247907
415300200529     C                   MOVE      *BLANKS       ZFLD17                                       247907
415400200529     C                   MOVEL     ODDTDER       ZFLD17                                       247907
415500200529     C                   Z-ADD     5             ZSDIG                                        247907
415600200529     C                   Z-ADD     8             ZSDEC                                        247907
415700200529                                                                                              247907
415800200529     C                   CALLB     'ZASIGN'                                                   247907
415900200529     C                   PARM                    ZASIGNok                                     247907
416000200529     C                   PARM                    ZFLD17                                       247907
416100200529     C                   PARM                    ZSDIG                                        247907
416200200529     C                   PARM                    ZSDEC                                        247907
416300200529     C                   PARM                    ZSDCSP                                       247907
416400200529     C                   PARM                    ZOUT15                                       247907
416500200529     C                   PARM                    ZFSIGN                                       247907
416600200529      *                                                                                       247907
416700200529                                                                                              247907
416800200529     C                   MOVE      *BLANKS       ZFLD15                                       247907
416900200529     C                   MOVE      ZOUT15        ZFLD15                                       247907
417000200529                                                                                              247907
417100200529     C                   CALLB     'ZSEDIT'                                                   247907
417200200529     C                   PARM                    ZFLD15                                       247907
417300200529     C                   PARM      8             ZSDEC                                        247907
417400200529     C                   PARM      *BLANK        ZECODE                                       247907
417500200529     C                   PARM      *BLANKS       ZOUT21                                       247907
417600200529                                                                                              247907
417700200529     C                   MOVE      ZOUT21        ODDTDER                                      247907
417800200529     C                   Endif                                                                247907
417900200529                                                                                              247907
418000200529      ** Base Currency Exchange Rate                                                          247907
418100200529     C                   If        ODDBRTE <> *Blanks                                         247907
418200200529     C                   MOVE      *BLANKS       ZFLD17                                       247907
418300200529     C                   MOVEL     ODDBRTE       ZFLD17                                       247907
418400200529     C                   Z-ADD     5             ZSDIG                                        247907
418500200529     C                   Z-ADD     8             ZSDEC                                        247907
418600200529                                                                                              247907
418700200529     C                   CALLB     'ZASIGN'                                                   247907
418800200529     C                   PARM                    ZASIGNok                                     247907
418900200529     C                   PARM                    ZFLD17                                       247907
419000200529     C                   PARM                    ZSDIG                                        247907
419100200529     C                   PARM                    ZSDEC                                        247907
419200200529     C                   PARM                    ZSDCSP                                       247907
419300200529     C                   PARM                    ZOUT15                                       247907
419400200529     C                   PARM                    ZFSIGN                                       247907
419500200529                                                                                              247907
419600200529     C                   MOVE      *BLANKS       ZFLD15                                       247907
419700200529     C                   MOVE      ZOUT15        ZFLD15                                       247907
419800200529                                                                                              247907
419900200529     C                   CALLB     'ZSEDIT'                                                   247907
420000200529     C                   PARM                    ZFLD15                                       247907
420100200529     C                   PARM      8             ZSDEC                                        247907
420200200529     C                   PARM      *BLANK        ZECODE                                       247907
420300200529     C                   PARM      *BLANKS       ZOUT21                                       247907
420400200529                                                                                              247907
420500200529     C                   MOVE      ZOUT21        ODDBRTE                                      247907
420600200529     C                   Endif                                                                247907
420700200529                                                                                              247907
420800200529     C                   ENDSR                                                                247907
420900200529      *****************************************************************                       247907
421000200529      /EJECT                                                                                  247907
421100200529      *****************************************************************                       247907
421200200529      *                                                               *
421300200529      * DfltTrSwfA - Default Trade Extension (SWIFT) 'A' details      *
421400200529      *                                                               *
421500200529      *****************************************************************
421600200529     C     DfltTrSwfA    BEGSR
421700200529
421800200529     C                   CALLB     'SETSWFTDFT'
421900200529      *
422000200529      ** INPUT PARAMETERS :
422100200529      *
422200200529      * Screen (A or B)
422300200529     C                   PARM      'A'           Screen            1
422400200529      *
422500200529      * Trade Details (screen)
422600200529      *
422700200529     C                   PARM                    DDACTN            1
422800200529     C                   PARM                    DDTDTP            2
422900200529     C                   PARM                    DDSETP            2
423000200529     C                   PARM                    DDCLTY2           1
423100200529     C                   PARM                    DDPCOD            1
423200200529     C                   PARM                    DDPRYC            1
423300200529     C                   PARM                    DDBRCD
423400200529     C                   PARM                    DDBPBK
423500200529     C                   PARM                    DDSETC
423600200529     C                   PARM                    DDMRKT
423700200529      *
423800200529      * Trade Details (file)
423900200529     C                   PARM                    V_TDVD
424000200529     C                   PARM                    V_TCNR
424100200529     C                   PARM                    V_DELF
424200200529     C                   PARM                    V_DELT
424300200529     C                   PARM                    INVT
424400200529      *
424500200529      * (CSW003) MT5XX - Phase 2 Message Generation
424600200529     C                   PARM                    CSW003
424700200529      *
424800200529      ** OUTPUT PARAMETERS :
424900200529      *
425000200529      * Screen A details
425100200529     C                   PARM                    TranInSwfA
425200200529     C                   PARM                    A_DDROUS          6
425300200529     C                   PARM                    A_DDROTS         12
425400200529     C                   PARM                    A_DDROUC          6
425500200529     C                   PARM                    A_DDROTC         12
425600200529      *
425700200529      * Screen B details
425800200529     C                   PARM                    TranInSwfB
425900200529     C                   PARM                    B_DDROUS          6
426000200529     C                   PARM                    B_DDROTS         12
426100200529     C                   PARM                    B_DDROUC          6
426200200529     C                   PARM                    B_DDROTC         12
426300200529
426400200529     C                   ENDSR
426500200529      *****************************************************************
426600200529      /EJECT
426700200529      *****************************************************************
426800200529      *                                                               *
426900200529      * ValdTrSwfA - Validate Trade Extension (SWIFT) 'A' details     *
427000200529      *                                                               *
427100200529      *****************************************************************
427200200529     C     ValdTrSwfA    BEGSR
427300200529
427400200529     C                   EVAL      BeforeIdx = Idx                                          AR639840
427500200529     C                   EVAL      BeforeWIdx = WIdx                                        AR639840
427600200529     C                   MOVE      'B_ADEVAL_A'  D_Point          10                          245542
427700200529     C                   CALLB     'SETRADEVAL'
427800200529      *
427900200529      ** INPUTS
428000200529      *
428100200529      * Response mode
428200200529     C                   PARM      'S'           RespMode          1
428300200529      *
428400200529      * Screen (A or B)
428500200529     C                   PARM      'A'           Screen            1
428600200529      *
428700200529      ** Trade Primary Details
428800200529      ** Trade Secondary Details
428900200529      ** Trade Exchange Rates
429000200529      ** Trade Settlement Details
429100200529     C                   PARM                    TranInPrim
429200200529     C                   PARM                    TranInSeco
429300200529     C                   PARM                    TranInExch
429400200529     C                   PARM                    TranInSett
429500200529      *
429600200529      ** Trade Extension File details
429700200529     C                   PARM                    TranInSwfA
429800200529      * Custom Extra Data file data
429900200529     C                   PARM                    ExtData
430000200529      *
430100200529      ** Previous inds
430200200529     C                   PARM                    @ADDGMES
430300200529     C                   PARM                    @ADDGMEC
430400200529     C                   PARM                    @ADDCCID
430500200529     C                   PARM                    A_T1CONG
430600200529      *
430700200529      ** Processing type
430800200529     C                   PARM                    PROT
430900200529      *
431000200529      ** Override errors
431100200529     C                   PARM                    OVRErrors
431200200529      *
431300200529      * Valid Trade layout (DS) from/to caller
431400200529     C                   PARM                    ValidTrad
431500200529      * Swift 2001 flag
431600200529     C                   PARM                    CSW201
431700200529      *
431800200529      ** Destination of settlement
431900200529     C                   PARM                    A_DDROTS
432000200529      *
432100200529      ** Process SE1806 flag
432200200529     C                   PARM                    PUYAT             1
432300200529     C                   PARM                    Tx2AFilFmt
432400200529      *
432500200529      ** OUTPUTS
432600200529      *
432700200529      * OK Flags
432800200529     C                   PARM                    OKTrSwft
432900200529      * Error fields/message IDs/message data (arrays) from/to caller
433000200529     C                   PARM                    FldNameArr
433100200529     C                   PARM                    MsgIDArr
433200200529     C                   PARM                    MsgDtaArr
433300200529      * Array index (3P0) from/to caller
433400200529     C                   PARM                    Idx
433500200529      * Warning fields/message IDs/message data (arrays) from/to caller
433600200529     C                   PARM                    WFldNamArr
433700200529     C                   PARM                    WMsgIDArr
433800200529     C                   PARM                    WMsgDtaArr
433900200529      * Array index (3P0) from/to caller
434000200529     C                   PARM                    WIdx
434100200529      *
434200200529      * Valid Trade layout (DS) (Extension file) from/to caller
434300200529     C                   PARM                    ValidTX1A
434400200529     C                   MOVE      'A_ADEVAL_A'  D_Point          10                          245542
434500200529
434600200529     C                   IF        BeforeIdx <> Idx                                         AR639840
434700200529     C                   EVAL      StepIdx = BeforeIdx + 1                                  AR639840
434800200529     C     StepIdx       DOUGT     Idx                                                      AR639840
434900200529     C                   EVAL      FldNameArr(StepIdx) = 'A'                                AR639840
435000200529     C                                     + FldNameArr(StepIdx)                            AR639840
435100200529     C                   EVAL      StepIdx = StepIdx + 1                                    AR639840
435200200529     C                   ENDDO                                                              AR639840
435300200529     C                   ENDIF                                                              AR639840
435400200529                                                                                            AR639840
435500200529     C                   IF        BeforeWIdx <> WIdx                                       AR639840
435600200529     C                   EVAL      StepIdx = BeforeWIdx +1                                  AR639840
435700200529     C     StepIdx       DOUGT     WIdx                                                     AR639840
435800200529     C                   EVAL      WFldNamArr(StepIdx) = 'A'                                AR639840
435900200529     C                                     + WFldNamArr(StepIdx)                            AR639840
436000200529     C                   EVAL      StepIdx = StepIdx + 1                                    AR639840
436100200529     C                   ENDDO                                                              AR639840
436200200529     C                   ENDIF                                                              AR639840
436300200529                                                                                            AR639840
436400200529     C                   ENDSR
436500200529      *****************************************************************
436600200529      /EJECT
436700200529      *****************************************************************
436800200529      *                                                               *
436900200529      * DfltTrSwfB - Default Trade Extension (SWIFT) 'B' details      *
437000200529      *                                                               *
437100200529      *****************************************************************
437200200529     C     DfltTrSwfB    BEGSR
437300200529
437400200529     C                   CALLB     'SETSWFTDFT'
437500200529      *
437600200529      ** INPUT PARAMETERS :
437700200529      *
437800200529      * Screen (A or B)
437900200529     C                   PARM      'B'           Screen            1
438000200529      *
438100200529      * Trade Details (screen)
438200200529      *
438300200529     C                   PARM                    DDACTN            1
438400200529     C                   PARM                    DDTDTP            2
438500200529     C                   PARM                    DDSETP            2
438600200529     C                   PARM                    DDCLTY2           1
438700200529     C                   PARM                    DDPCOD            1
438800200529     C                   PARM                    DDPRYC            1
438900200529     C                   PARM                    DDBRCD
439000200529     C                   PARM                    DDBPBK
439100200529     C                   PARM                    DDSETC
439200200529     C                   PARM                    DDMRKT
439300200529      *
439400200529      * Trade Details (file)
439500200529     C                   PARM                    V_TDVD
439600200529     C                   PARM                    V_TCNR
439700200529     C                   PARM                    V_DELF
439800200529     C                   PARM                    V_DELT
439900200529     C                   PARM                    INVT
440000200529      *
440100200529      * (CSW003) MT5XX - Phase 2 Message Generation
440200200529     C                   PARM                    CSW003
440300200529      *
440400200529      ** OUTPUT PARAMETERS :
440500200529      *
440600200529      * Screen A details
440700200529     C                   PARM                    TranInSwfA
440800200529     C                   PARM                    A_DDROUS          6
440900200529     C                   PARM                    A_DDROTS         12
441000200529     C                   PARM                    A_DDROUC          6
441100200529     C                   PARM                    A_DDROTC         12
441200200529      *
441300200529      * Screen B details
441400200529     C                   PARM                    TranInSwfB
441500200529     C                   PARM                    B_DDROUS          6
441600200529     C                   PARM                    B_DDROTS         12
441700200529     C                   PARM                    B_DDROUC          6
441800200529     C                   PARM                    B_DDROTC         12
441900200529
442000200529     C                   ENDSR
442100200529      *****************************************************************
442200200529      /EJECT
442300200529      *****************************************************************
442400200529      *                                                               *
442500200529      * ValdTrSwfB - Validate Trade Extension (SWIFT) 'B' details     *
442600200529      *                                                               *
442700200529      *****************************************************************
442800200529     C     ValdTrSwfB    BEGSR
442900200529
443000200529     C                   EVAL      BeforeIdx = Idx                                          AR639840
443100200529     C                   EVAL      BeforeWIdx = WIdx                                        AR639840
443200200529     C                   MOVE      'B_ADEVAL_B'  D_Point          10                          245542
443300200529     C                   CALLB     'SETRADEVAL'
443400200529      *
443500200529      ** INPUTS
443600200529      *
443700200529      * Response mode
443800200529     C                   PARM      'S'           RespMode          1
443900200529      *
444000200529      * Screen (A or B)
444100200529     C                   PARM      'B'           Screen            1
444200200529      *
444300200529      ** Trade Primary Details
444400200529      ** Trade Secondary Details
444500200529      ** Trade Exchange Rates
444600200529      ** Trade Settlement Details
444700200529     C                   PARM                    TranInPrim
444800200529     C                   PARM                    TranInSeco
444900200529     C                   PARM                    TranInExch
445000200529     C                   PARM                    TranInSett
445100200529      *
445200200529      ** Trade Extension File details
445300200529     C                   PARM                    TranInSwfB
445400200529      * Custom Extra Data file data
445500200529     C                   PARM                    ExtData
445600200529      *
445700200529      ** Previous inds
445800200529     C                   PARM                    @BDDGMES
445900200529     C                   PARM                    @BDDGMEC
446000200529     C                   PARM                    @BDDCCID
446100200529     C                   PARM                    B_T1CONG
446200200529      *
446300200529      ** Processing type
446400200529     C                   PARM                    PROT
446500200529      *
446600200529      ** Override errors
446700200529     C                   PARM                    OVRErrors         1
446800200529      *
446900200529      * Valid Trade layout (DS) from/to caller
447000200529     C                   PARM                    ValidTrad
447100200529      * Swift 2001 flag
447200200529     C                   PARM                    CSW201
447300200529      *
447400200529      ** Destination of settlement
447500200529     C                   PARM                    B_DDROTS
447600200529      *
447700200529      ** Process SE1806 flag
447800200529     C                   PARM                    PUYAT             1
447900200529     C                   PARM                    Tx2BFilFmt
448000200529      *
448100200529      ** OUTPUTS
448200200529      *
448300200529      * OK Flags
448400200529     C                   PARM                    OKTrSwft
448500200529      * Error fields/message IDs/message data (arrays) from/to caller
448600200529     C                   PARM                    FldNameArr
448700200529     C                   PARM                    MsgIDArr
448800200529     C                   PARM                    MsgDtaArr
448900200529      * Array index (3P0) from/to caller
449000200529     C                   PARM                    Idx
449100200529      * Warning fields/message IDs/message data (arrays) from/to caller
449200200529     C                   PARM                    WFldNamArr
449300200529     C                   PARM                    WMsgIDArr
449400200529     C                   PARM                    WMsgDtaArr
449500200529      * Array index (3P0) from/to caller
449600200529     C                   PARM                    WIdx
449700200529      *
449800200529      * Valid Trade layout (DS) (Extension file) from/to caller
449900200529     C                   PARM                    ValidTX1B
450000200529     C                   MOVE      'A_ADEVAL_B'  D_Point          10                          245542
450100200529
450200200529     C                   IF        BeforeIdx <> Idx                                         AR639840
450300200529     C                   EVAL      StepIdx = BeforeIdx + 1                                  AR639840
450400200529     C     StepIdx       DOUGT     Idx                                                      AR639840
450500200529     C                   EVAL      FldNameArr(StepIdx) = 'A'                                AR639840
450600200529     C                                     + FldNameArr(StepIdx)                            AR639840
450700200529     C                   EVAL      StepIdx = StepIdx + 1                                    AR639840
450800200529     C                   ENDDO                                                              AR639840
450900200529     C                   ENDIF                                                              AR639840
451000200529                                                                                            AR639840
451100200529     C                   IF        BeforeWIdx <> WIdx                                       AR639840
451200200529     C                   EVAL      StepIdx = BeforeWIdx +1                                  AR639840
451300200529     C     StepIdx       DOUGT     WIdx                                                     AR639840
451400200529     C                   EVAL      WFldNamArr(StepIdx) = 'A'                                AR639840
451500200529     C                                     + WFldNamArr(StepIdx)                            AR639840
451600200529     C                   EVAL      StepIdx = StepIdx + 1                                    AR639840
451700200529     C                   ENDDO                                                              AR639840
451800200529     C                   ENDIF                                                              AR639840
451900200529                                                                                            AR639840
452000200529     C                   ENDSR
452100200529      *****************************************************************
452200200529      /EJECT                                                                                  247873
452300200529      *****************************************************************                       247873
452400200529      *                                                               *                       247873
452500200529      *  SR1100 - Determine Network and Addresses.                    *                       247873
452600200529      *                                                               *                       247873
452700200529      *****************************************************************                       247873
452800200529     C     SR1100        BEGSR                                                                247873
452900200529      *                                                                                       247873
453000200529     C                   CALL      'ZM1100'                             99                    247873
453100200529     C                   PARM                    WSNDR             6                          247873
453200200529     C                   PARM      *Blanks       WSCSD            12                          247873
453300200529     C                   PARM                    WDEST             6                          247873
453400200529     C                   PARM                    WSETP             2                          247873
453500200529     C                   PARM      *Blanks       WNWSN            20                          247873
453600200529     C                   PARM      *Blanks       WNWDS            22                          247873
453700200529     C                   PARM      *Blanks       WNWRK             6                          247873
453800200529     C                   PARM      *Blanks       WERRC             1                          247873
453900200529     C                   PARM      *Blanks       WSRNM            20                          247873
454000200529     C                   PARM      *Blanks       WSRTN            10                          247873
454100200529     C                   PARM      *Blanks       WDRNM            20                          247873
454200200529     C                   PARM      *Blanks       WDRTN            10                          247873
454300200529      *                                                                                       247873
454400200529     C     WSNDR         IFNE      *Blanks                                                    247873
454500200529     C     WDEST         ANDNE     *Blanks                                                    247873
454600200529      *                                                                                       247873
454700200529     C     *IN99         IFEQ      '1'                                                        247873
454800200529     C     WERRC         OREQ      'S'                                                        247873
454900200529     C     WERRC         OREQ      'D'                                                        247873
455000200529     C     WNWRK         OREQ      'UNROUT'                                                   247873
455100200529      *                                                                                       247873
455200200529     C                   MOVEL     *Blanks       WWROU             6                          247873
455300200529     C                   MOVEL     '  UNRO'      WWROT            12                          247873
455400200529     C                   MOVE      'UTABLE'      WWROT                                        247873
455500200529     C                   ELSE                                                                 247873
455600200529      *                                                                                       247873
455700200529     C                   MOVEL     WNWRK         WWROU                                        247873
455800200529     C                   MOVEA     WNWDS         ROU                                          247873
455900200529     C                   Z-ADD     1             J                 2 0                        247873
456000200529     C     ' '           LOOKUP    ROU(J)                                 99                  247873
456100200529     C     *IN99         IFEQ      '0'                                                        247873
456200200529     C                   MOVEL     WNWDS         WWROT                                        247873
456300200529     C                   ELSE                                                                 247873
456400200529     C     14            SUB       J             K                 2 0                        247873
456500200529     C                   MOVEA     *ALL' '       ROU                                          247873
456600200529     C                   MOVEA     WNWDS         ROU(K)                                       247873
456700200529     C                   MOVEA     ROU           WWROT                                        247873
456800200529     C                   ENDIF                                                                247873
456900200529     C                   ENDIF                                                                247873
457000200529      *                                                                                       247873
457100200529     C                   ELSE                                                                 247873
457200200529      *                                                                                       247873
457300200529     C                   MOVEL     *Blanks       WWROU                                        247873
457400200529     C                   MOVEL     *Blanks       WWROT                                        247873
457500200529      *                                                                                       247873
457600200529     C                   ENDIF                                                                247873
457700200529      *                                                                                       247873
457800200529     C                   ENDSR                                                                247873
457900200529      *****************************************************************                       247873
458000200529      /EJECT                                                                                  CAP087
458100200529      *****************************************************************                       CAP087
458200200529      * CalcDays - Calculate Days in a Year                                                   CAP087
458300200529      *****************************************************************                       CAP087
458400200529     C     CalcDays      BEGSR                                                                CAP087
458500200529                                                                                              CAP087
458600200529      ** For non-interest bearing securities, some of the parameters for                      CAP087
458700200529      ** ZDYYR are unknown.  In this case, set Divisor Basis to '3' and                       CAP087
458800200529      ** Next Coupon Date to the Value Date of the Buy-Sell Back.                             CAP087
458900200529     C                   IF        PROT = '2' or PROT = '4' or PROT = '7'                     CAP087
459000200529     C                   EVAL      DVBS = '3'                                                 CAP087
459100200529     C                   EVAL      NCD = V_TDVD                                               CAP087
459200200529     C                   ENDIF                                                                CAP087
459300200529                                                                                              CAP087
459400200529     C                   CALLB     'ZDYYR'                                                    CAP087
459500200529     C                   PARM                    DYBS                                         CAP087
459600200529     C                   PARM                    DVBS                                         CAP087
459700200529     C                   PARM                    ISSD                                         CAP087
459800200529     C                   PARM                    ITLD                                         CAP087
459900200529     C                   PARM                    LCPN                                         CAP087
460000200529     C                   PARM                    FCPN                                         CAP087
460100200529     C                   PARM                    MATY                                         CAP087
460200200529     C                   PARM                    IADJ                                         CAP087
460300200529     C                   PARM                    CDArr                                        CAP087
460400200529     C                   PARM                    CRArr                                        CAP087
460500200529     C                   PARM                    CPNR                                         CAP087
460600200529     C                   PARM                    DADJN             1                          CAP087
460700200529     C                   PARM                    NCD               5 0                        CAP087
460800200529     C                   PARM                    ECD               5 0                        CAP087
460900200529     C                   PARM                    BJDFIN                                       CAP087
461000200529                                                                                             BUG9961
461100200529      ** Holiday Currencies                                                                  BUG9961
461200200529                                                                                             BUG9961
461300200529     C                   PARM                    HCY1              3                         BUG9961
461400200529     C                   PARM                    HCY2              3                         BUG9961
461500200529     C                   PARM                    HCY3              3                         BUG9961
461600200529     C                   PARM                    HCY4              3                         BUG9961
461700200529     C                   PARM                    HCY5              3                         BUG9961
461800200529     C                   PARM                    HCY6              3                         BUG9961
461900200529     C                   PARM                    HCY7              3                         BUG9961
462000200529     C                   PARM                    HCY8              3                         BUG9961
462100200529     C                   PARM                    HCY9              3                         BUG9961
462200200529     C                   PARM      *Zeros        ZINTDD            5 0                        CAP087
462300200529     C                   PARM                    LCDD5             5 0                        CAP087
462400200529                                                                                              CAP087
462500200529     C                   Z-ADD     ZINTDD        DaysInYear                                   CAP087
462600200529     C                   MOVE      DaysInYear    Out_DaysYear                                 CAP087
462700200529                                                                                              CAP087
462800200529     C                   Z-ADD     V_TCSR        Trade_Value                                  CAP087
462900200529     C                   MOVE      *BLANKS       ZFIELD                                       CAP087
463000200529     C                   MOVE      Trade_Value   ZFIELD                                       CAP087
463100200529     C                   Z-ADD     NomCcyDec     ZADEC                                        CAP087
463200200529     C                   CALLB     'ZEDIT'                                                    CAP087
463300200529     C                   PARM                    ZFIELD           16                          CAP087
463400200529     C                   PARM                    ZADEC             1 0                        CAP087
463500200529     C                   MOVE      ZFIELD        Out_Value                                    CAP087
463600200529                                                                                              CAP087
463700200529     C                   ENDSR                                                                CAP087
463800200529      *****************************************************************                       CAP087
463900200529      /EJECT
464000200529      *****************************************************************                     BUG11194
464100200529      *                                                               *                     BUG11194
464200200529      *  SRIntCal  - Force Interest Recalculation                     *                     BUG11194
464300200529      *                                                               *                     BUG11194
464400200529      *****************************************************************                     BUG11194
464500200529                                                                                            BUG11194
464600200529     C     SRIntCal      BEGSR                                                              BUG11194
464700200529                                                                                            BUG11194
464800200529     C                   If        DDNOML <> DDNOM1  OR                                     BUG11194
464900200529     C                             DDTDVD <> DDTDV1  OR                                     BUG11194
465000200529     C                             DDACIN <> DDACI1  OR                                     BUG11194
465100200529     C                             DDDADJ <> DDDAD1  OR                                     BUG11194
465200200529     C                             DDACTD <> DDACT1                                         BUG11194
465300200529     C                   If        DDITRA =  DDITR1                                         BUG11194
465400200529     C                   Eval      DDITRA = *Blanks                                         BUG11194
465500200529     C                   Endif                                                              BUG11194
465600200529     C                   Endif                                                              BUG11194
465700200529                                                                                            BUG11194
465800200529     C                   ENDSR                                                              BUG11194
465900200529      *****************************************************************                     BUG11194
466000200529      *                                                               *                     BUG11194
466100200529      *  SavePrevEnt - Save Previous Entries for Interest Recal-      *                     BUG11194
466200200529      *                 culation                                      *                     BUG11194
466300200529      *                                                               *                     BUG11194
466400200529      *****************************************************************                     BUG11194
466500200529                                                                                            BUG11194
466600200529     C     SavePrevEnt   BEGSR                                                              BUG11194
466700200529                                                                                            BUG11194
466800200529     C                   Eval      DDNOM1 = DDNOML                                          BUG11194
466900200529     C                   Eval      DDTDV1 = DDTDVD                                          BUG11194
467000200529     C                   Eval      DDACI1 = DDACIN                                          BUG11194
467100200529     C                   Eval      DDDAD1 = DDDADJ                                          BUG11194
467200200529     C                   Eval      DDACT1 = DDACTD                                          BUG11194
467300200529     C                   Eval      DDITR1 = DDITRA                                          BUG11194
467400200529                                                                                            BUG11194
467500200529     C                   ENDSR                                                              BUG11194
467600200529      *****************************************************************                     MD049746
467700200529      *                                                               *                     MD049746
467800200529      *  SetTCNR - Retrieve customer number of the counterparty       *                     MD049746
467900200529      *                                                               *                     MD049746
468000200529      *****************************************************************                     MD049746
468100200529                                                                                            MD049746
468200200529     C     SetTCNR       BEGSR                                                              MD049746
468300200529     C                   IF        DDCNUM <> *BLANKS                                        MD049746
468400200529     C                   CALL      'AOCUSTR0'                                               MD049746
468500200529     C                   PARM      '*DBERR '     @RTCD                                      MD049746
468600200529     C                   PARM      '*KEY   '     @OPTN                                      MD049746
468700200529     C                   PARM      DDCNUM        WCus10           10                        MD049746
468800200529     C                   PARM      *BLANKS       WKyst             7                        MD049746
468900200529     C     SDCUST        PARM      SDCUST        DSSDY                                      MD049746
469000200529      *                                                                                     MD049746
469100200529     C     @RTCD         IFEQ      *BLANK                                                   MD049746
469200200529     C                   MOVEL     BBCUST        TCNR                                       MD049746
469300200529     C                   ENDIF                                                              MD049746
469400200529     C                   ENDIF                                                              MD049746
469500200529     C                   ENDSR                                                              MD049746
469600200529      *****************************************************************
469700200529      *                                                               *
469800200529      * *INZSR - Program Initialisation routine                       *
469900200529      *                                                               *
470000200529      *****************************************************************
470100200529     C     *INZSR        BEGSR
470200200529
470300200529     C     *ENTRY        PLIST
470400200529
470500200529      * Common header information (DS) from source system
470600200529     C                   PARM                    HeadIn
470700200529
470800200529      * Transaction information
470900200529     C                   PARM                    Trans5001
471000200529     C                   PARM                    Trans5002
471100200529     C                   PARM                    Trans5002B                                 BUG11194
471200200529     C                   PARM                    Trans5003
471300200529     C                   PARM                    Trans5004
471400200529     C                   PARM                    Trans5005
471500200529     C                   PARM                    Trans5006
471600200529     C                   PARM                    Trans5007
471700200529     C                   PARM                    Trans5008
471800200529     C**********         PARM                    OthDData4755                                CSF011A
471900200529     C                   PARM                    OthrData                                    CSF011A
472000200529     C                   PARM                    OthData500                                  BUG9089
472100200529     C**********         PARM                    InfData500                                 BUG10202
472200200529     C                   PARM                    RegData500                                   CER001
472300200529     C                   PARM                    ExtData500
472400200529
472500200529     C                   PARM                    FldNameArr
472600200529     C                   PARM                    MsgIDArr
472700200529     C                   PARM                    MsgDtaArr
472800200529     C                   PARM                    WFldNamArr
472900200529     C                   PARM                    WMsgIDArr
473000200529     C                   PARM                    WMsgDtaArr
473100200529     C                   PARM                    MsgFArray
473200200529     C                   PARM                    UpdateYN          1
473300200529     C                   PARM                    Buffer         6000
473400200529     C                   PARM                    Buffer2        3999                         CSF011A
473500200529     C                   PARM                    APIRetc           1
473600200529     C                   PARM                    @TimeStamp       26                         BUG1569
473700200529     C                   PARM                    TransQ                                       CER049
473800200529     C                   PARM                    AAuth             1                        BUG22232
473900200529     C                   PARM                    DDFRNT                                    AR698195B
474000200529
474100200529      * Set up the name of the primary and secondary message files from
474200200529      * which the message handler will get the messages
474300200529     C                   EVAL      MsgFArray(1) = 'SEUSRMSG'
474400200529     C                   EVAL      MsgFArray(2) = 'DRSMM'
474500200529     C                   EVAL      MsgFArray(3) = 'MEMSG'                                   AR589197
474600200529
474700200529      * Initialize ECD                                                                        246736
474800200529     C                   Z-ADD     0             ECD                                          246736
474900200529                                                                                              246736
475000200529      *  Hook to enable non-core message files to be included
475100200529     C/COPY WNCPYSRC,SETRADM01
475200200529      *
475300200529      * Access bank details via access program
475400200529      * (database error handling done in access program)
475500200529     C                   CALLB     'AOBANKR0'
475600200529     C                   PARM      '*DBERR '     @RTCD             7
475700200529     C                   PARM      '*FIRST '     @OPTN             7
475800200529     C     SDBANK        PARM      SDBANK        DSFDY
475900200529
476000200529      * Access API ICD via access program
476100200529     C                   CALLB     'AOAPIR0'
476200200529     C                   PARM      '*DBERR '     @RTCD
476300200529     C                   PARM      '*FIRST '     @OPTN
476400200529     C     SDAPI         PARM      SDAPI         DSFDY
476500200529      *
476600200529      ** Access midas modules details to determine if strategic
476700200529      ** risk management indicator is on.
476800200529      *
476900200529     C                   CALLB     'AOMMODR0'
477000200529     C                   PARM      *BLANKS       PRTCD
477100200529     C                   PARM      '*FIRST '     POPTN
477200200529     C     SDMMOD        PARM      SDMMOD        DSFDY
477300200529      *
477400200529      ** Database error.
477500200529     C                   IF        PRTCD <> *BLANKS
477600200529     C                   EVAL      DBKEY = POPTN
477700200529     C                   EVAL      DBFILE = 'SDMMODPD'
477800200529     C                   Z-ADD     2             DBASE
477900200529     C                   EXSR      *PSSR
478000200529     C                   ENDIF
478100200529      *
478200200529      ** ACCESS GENERAL LEDGER DETAILS
478300200529      *
478400200529     C**********         CALL      'AOGELRR0'                                                 CGL029
478500200529     C                   CALL      'AOGELRR1'                                                 CGL029
478600200529     C                   PARM      *BLANKS       @RTCD             7
478700200529     C                   PARM      '*FIRST '     @OPTN             7
478800200529     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
478900200529     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
479000200529      *
479100200529      * DATABASE ERROR
479200200529      *
479300200529     C     @RTCD         IFNE      *BLANKS
479400200529     C                   MOVEL     'SDGELRPD'    DBFILE
479500200529     C                   MOVEL     '902'         DBASE
479600200529     C                   MOVEL     @OPTN         DBKEY
479700200529     C                   EXSR      *PSSR
479800200529     C                   END
479900200529      *
480000200529      ** Access API ICD details.
480100200529      *
480200200529     C                   CALLB     'AOAPIR0'
480300200529     C                   PARM      *BLANKS       PRTCD
480400200529     C                   PARM      '*FIRST '     POPTN
480500200529     C     SDAPI         PARM      SDAPI         DSFDY
480600200529      *
480700200529      ** Database error.
480800200529     C                   IF        PRTCD <> *BLANKS
480900200529     C                   EVAL      DBKEY = POPTN
481000200529     C                   EVAL      DBFILE = 'SDAPIPD'
481100200529     C                   Z-ADD     3             DBASE
481200200529     C                   EXSR      *PSSR
481300200529     C                   ENDIF
481400200529      *
481500200529      ** Access SAR details file to determine if MT5XX Message
481600200529      ** Generation enhancement phase 2 is switched on
481700200529      *
481800200529     C                   CALLB     'AOSARDR0'
481900200529     C                   PARM      *BLANKS       @RTCD
482000200529     C                   PARM      '*VERIFY'     @OPTN
482100200529     C                   PARM      'CSW003'      @SARD
482200200529     C     SCSARD        PARM      SCSARD        DSFDY
482300200529     C     @RTCD         IFEQ      *BLANK
482400200529     C                   MOVEL     'Y'           CSW003
482500200529     C                   ELSE
482600200529     C                   MOVEL     'N'           CSW003
482700200529     C                   END
482800200529      *
482900200529      ** Access SAR details file to determine if CEU005
483000200529      ** (EMU SE Settlement Currency Conversion) is on.
483100200529      *
483200200529     C                   CALLB     'AOSARDR0'
483300200529     C                   PARM      *BLANKS       @RTCD
483400200529     C                   PARM      '*VERIFY'     @OPTN
483500200529     C                   PARM      'CEU005'      @SARD
483600200529     C     SCSARD        PARM      SCSARD        DSFDY
483700200529      *
483800200529     C     @RTCD         IFEQ      *BLANK
483900200529     C                   MOVEL     'Y'           CEU005
484000200529     C                   ELSE
484100200529     C                   MOVEL     'N'           CEU005
484200200529     C                   END
484300200529      *                                                                                       247524
484400200529      ** Access SAR details file to determine if S01496 (Private                              247524
484500200529      ** Banking Securities Trading Enhancements) is on.                                      247524
484600200529      *                                                                                       247524
484700200529     C                   CALLB     'AOSARDR0'                                                 247524
484800200529     C                   PARM      *BLANKS       @RTCD                                        247524
484900200529     C                   PARM      '*VERIFY'     @OPTN                                        247524
485000200529     C                   PARM      'S01496'      @SARD                                        247524
485100200529     C     SCSARD        PARM      SCSARD        DSFDY                                        247524
485200200529      *                                                                                       247524
485300200529     C     @RTCD         IFEQ      *BLANK                                                     247524
485400200529     C                   MOVEL     'Y'           S01496                                       247524
485500200529     C                   ELSE                                                                 247524
485600200529     C                   MOVEL     'N'           S01496                                       247524
485700200529     C                   ENDIF                                                                247524
485800200529      ** Access SAR file to determine if CSE011
485900200529      ** (duplicate security code check) is installed.
486000200529      *
486100200529     C                   CALLB     'AOSARDR0'
486200200529     C                   PARM      *BLANKS       PRTCD
486300200529     C                   PARM      '*VERIFY'     POPTN
486400200529     C                   PARM      'CSE011'      PSARD
486500200529     C     SCSARD        PARM      SCSARD        DSFDY
486600200529      *
486700200529      ** An NRF (No Record Found) return code is valid.
486800200529      ** Issue database error only for error return codes.
486900200529      *
487000200529     C                   IF        PRTCD <> *BLANKS AND
487100200529     C                             PRTCD <> '*NRF   '
487200200529     C                   EVAL      DBKEY = 'CSE011'
487300200529     C                   EVAL      DBFILE = 'SCSARDPD'
487400200529     C                   Z-ADD     7             DBASE
487500200529     C                   EXSR      *PSSR
487600200529     C                   ENDIF
487700200529
487800200529     C                   IF        PRTCD = *BLANKS
487900200529     C                   EVAL      CSE011 = 'Y'
488000200529     C                   ELSE
488100200529     C                   EVAL      CSE011 = 'N'
488200200529     C                   ENDIF
488300200529      *                                                                                     BUG10085
488400200529      ** Access SAR file to determine if CSE022                                             BUG10085
488500200529      ** is installed.                                                                      BUG10085
488600200529      *                                                                                     BUG10085
488700200529     C                   CALLB     'AOSARDR0'                                               BUG10085
488800200529     C                   PARM      *BLANKS       PRTCD                                      BUG10085
488900200529     C                   PARM      '*VERIFY'     POPTN                                      BUG10085
489000200529     C                   PARM      'CSE022'      PSARD                                      BUG10085
489100200529     C     SCSARD        PARM      SCSARD        DSFDY                                      BUG10085
489200200529      *                                                                                     BUG10085
489300200529     C                   IF        PRTCD = *BLANKS                                          BUG10085
489400200529     C                   EVAL      CSE022 = 'Y'                                             BUG10085
489500200529     C                   EVAL      PGMNAM = 'SEDORFRTV'                                       238825
489600200529     C                   ELSE                                                               BUG10085
489700200529     C                   EVAL      CSE022 = 'N'                                             BUG10085
489800200529     C                   ENDIF                                                              BUG10085
489900200529      *
490000200529      ** Access SAR file to determine if S01401
490100200529      ** (MT5xx message generation) is installed.
490200200529      *
490300200529     C                   CALLB     'AOSARDR0'
490400200529     C                   PARM      *BLANKS       PRTCD
490500200529     C                   PARM      '*VERIFY'     POPTN
490600200529     C                   PARM      'S01401'      PSARD
490700200529     C     SCSARD        PARM      SCSARD        DSFDY
490800200529      *
490900200529      ** An NRF (No Record Found) return code is valid.
491000200529      ** Issue database error only for error return codes.
491100200529      *
491200200529     C                   IF        PRTCD <> *BLANKS AND
491300200529     C                             PRTCD <> '*NRF   '
491400200529     C                   EVAL      DBKEY = 'S01401'
491500200529     C                   EVAL      DBFILE = 'SCSARDPD'
491600200529     C                   Z-ADD     8             DBASE
491700200529     C                   EXSR      *PSSR
491800200529     C                   ENDIF
491900200529
492000200529     C                   IF        PRTCD = *BLANKS
492100200529     C                   EVAL      S01401 = 'Y'
492200200529     C                   ELSE
492300200529     C                   EVAL      S01401 = 'N'
492400200529     C                   ENDIF
492500200529
492600200529      ** Access SAR details file to determine if
492700200529      ** Automatic Authorisation (SE Part) is installed
492800200529      *
492900200529     C                   MOVEL     'N'           CAP051
493000200529     C                   CALL      'AOSARDR0'
493100200529     C                   PARM      *BLANKS       @RTCD
493200200529     C                   PARM      '*VERIFY'     @OPTN
493300200529     C                   PARM      'CAP051'      @SARD
493400200529     C     SCSARD        PARM      SCSARD        DSFDY
493500200529      *
493600200529     C     @RTCD         IFEQ      *BLANK
493700200529     C                   MOVEL     'Y'           CAP051
493800200529     C                   ENDIF
493900200529      *
494000200529      ** Check to see if switchable feature CSW098 is on or if date is
494100200529      ** greater than 16 October 1998.
494200200529      *
494300200529     C                   CALL      'SWIFT98'                            99
494400200529     C                   PARM                    SWRTN
494500200529
494600200529
494700200529      ** Check if CSC011 is installed
494800200529
494900200529     C                   EVAL      WkDate = BJRDNB
495000200529     C                   EVAL      WkNext = BJDNWD
495100200529     C                   EVAL      CSC011 = 'N'
495200200529     C                   CALLB     'AOSARDR0'
495300200529     C                   PARM      *Blanks       PRTCD
495400200529     C                   PARM      '*VERIFY'     POPTN
495500200529     C                   PARM      'CSC011'      PSARD
495600200529     C     SCSARD        PARM      SCSARD        DSFDY
495700200529
495800200529     C                   IF        PRTCD = *Blanks
495900200529     C                   EVAL      CSC011 = 'Y'
496000200529     C                   IN        SC24X7
496100200529     C                   IN        SDSTAT
496200200529     C                   IF        S1SUPP = LIBR
496300200529     C                   EVAL      WkDate = S1DATE
496400200529     C                   EVAL      WkNext = S1NEXT
496500200529     C                   ENDIF
496600200529     C                   ELSE
496700200529     C                   IF        PRTCD <> '*NRF   '
496800200529     C                   EVAL      DBFILE = 'SCSARDPD'
496900200529     C                   EVAL      DBKEY  = 'CSC011'
497000200529     C                   EVAL      DBASE  = 13
497100200529     C                   EXSR      *PSSR
497200200529     C                   ENDIF
497300200529     C                   ENDIF
497400200529
497500200529      ** Check if CSW201 - Swift 2001 Standards Update is installed
497600200529
497700200529     C                   CALL      'SWIF2001'                           9090
497800200529     C                   PARM      *BLANKS       @RTCD
497900200529
498000200529     C                   IF        *IN90 = *OFF AND @RTCD = 'CSW2001'
498100200529     C                   EVAL      CSW201 = 'Y'
498200200529     C                   ELSE
498300200529     C                   EVAL      CSW201 = 'N'
498400200529     C                   ENDIF
498500200529                                                                                             CSW206E
498600200529     C                   CALL      'SWIF2006'                                                CSW206E
498700200529     C                   PARM      *BLANKS       PRTCD                                       CSW206E
498800200529                                                                                             CSW206E
498900200529     C                   IF        PRTCD = 'CSW2006'                                         CSW206E
499000200529     C                   EVAL      CSW206 = 'Y'                                              CSW206E
499100200529     C                   ELSE                                                                CSW206E
499200200529     C                   EVAL      CSW206 = 'N'                                              CSW206E
499300200529     C                   ENDIF                                                               CSW206E
499400200529      *
499500200529      ** Check if CSE028 feature is installed
499600200529      *
499700200529     C                   CALLB     'AOSARDR0'
499800200529     C                   PARM      *BLANKS       @RTCD
499900200529     C                   PARM      '*VERIFY'     @OPTN
500000200529     C                   PARM      'CSE028'      @SARD
500100200529     C     SCSARD        PARM      SCSARD        DSFDY
500200200529     C     @RTCD         IFEQ      *BLANK
500300200529     C                   MOVEL     'Y'           CSE028
500400200529     C                   ELSE
500500200529     C                   MOVEL     'N'           CSE028
500600200529     C                   ENDIF
500700200529
500800200529      ** Check if enhancement CAS006 (Hedge Accounting Phase B) is installed
500900200529
501000200529     C                   CALLB     'AOSARDR0'
501100200529     C                   PARM      *BLANKS       PRTCD
501200200529     C                   PARM      '*VERIFY'     POPTN
501300200529     C                   PARM      'CAS006'      PSARD
501400200529     C     SCSARD        PARM      SCSARD        DSFDY
501500200529
501600200529     C                   IF        PRTCD = *BLANKS
501700200529     C                   EVAL      CAS006 = 'Y'
501800200529     C                   ELSE
501900200529     C                   EVAL      CAS006 = 'N'
502000200529     C                   ENDIF
502100200529
502200200529      *
502300200529      ** Retrieve ICD for securities trading.
502400200529     C                   CALLB     'AOSTRDR0'
502500200529     C                   PARM      *BLANKS       PRTCD
502600200529     C                   PARM      '*FIRST '     POPTN
502700200529     C     SDSTRD        PARM      SDSTRD        DSSDY
502800200529      *
502900200529      ** Database error.
503000200529     C                   IF        PRTCD <> *BLANKS
503100200529     C                   EVAL      DBKEY = POPTN
503200200529     C                   EVAL      DBFILE = 'SDSTRDPD'
503300200529     C                   Z-ADD     11            DBASE
503400200529     C                   EXSR      *PSSR
503500200529     C                   ENDIF
503600200529
503700200529      ** Generate a timestamp for this transaction
503800200529     C                   CALLB     'ZAGENTMSTM'
503900200529     C                   PARM                    WTimeStamp
504000200529     C                   MOVE      WTimeStamp    WorkTime
504100200529
504200200529      **********                                                                             BUG7029
504300200529      ***Retrieve*ZMUSER*details.                                                            BUG7029
504400200529      **********                                                                             BUG7029
504500200529     C******DTAARA       DEFINE                  ZMUSER                                      BUG7029
504600200529     C**********         IN        ZMUSER                                                    BUG7029
504700200529
504800200529      ** Set Front Office ID = User ID
504900200529     C**********         EVAL      APFOTranID = %SUBST(PUSRID:1:3) +                          249422
505000200529     C**********                                %SUBST(WorkTime:3:17)                         249422
505100200529      ** Front Office ID                                                                   AR698195B
505200200529     C                   EVAL      APFOTranID = DDFRNT                                     AR698195B
505300200529      *                                                                                       CSC022
505400200529      ** Access Switchable Features File, for CSC022                                          CSC022
505500200529      *                                                                                       CSC022
505600200529     C                   Eval      CSC022 = 'N'                                               CSC022
505700200529     C                   CallB     'AOSARDR0'                                                 CSC022
505800200529     C                   Parm      *BLANKS       @RtCd                                        CSC022
505900200529     C                   Parm      '*VERIFY'     @Optn                                        CSC022
506000200529     C                   Parm      'CSC022'      @Sard             6                          CSC022
506100200529     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
506200200529      *                                                                                       CSC022
506300200529     C                   If        @RtCd = *Blanks                                            CSC022
506400200529     C                   Eval      CSC022 = 'Y'                                               CSC022
506500200529     C                   Eval      WCommitSkip = 'N'                                          CSC022
506600200529      *                                                                                       CSC022
506700200529     C                   In        SCCMTJOB                                                   CSC022
506800200529     C                   If        ComitNum > 0                                               CSC022
506900200529     C                   MoveA     ComitJob      WCmtJobArr                                   CSC022
507000200529      *                                                                                       CSC022
507100200529     C     PSJOBNAME     LOOKUP    WCmtJobArr                             87                  CSC022
507200200529     C                   If        *IN87 = *ON                                                CSC022
507300200529     C                   Eval      WCommitSkip = 'Y'                                          CSC022
507400200529     C                   EndIf                                                                CSC022
507500200529     C                   EndIf                                                                CSC022
507600200529      *                                                                                       CSC022
507700200529     C                   Else                                                                 CSC022
507800200529      *                                                                                       CSC022
507900200529      ** If return code <> *NRF, call program exception error routine                         CSC022
508000200529      *                                                                                       CSC022
508100200529     C                   If        @RtCd <> '*NRF'                                            CSC022
508200200529     C     *LOCK         IN        LDA                                                        CSC022
508300200529     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
508400200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
508500200529     C                   EVAL      DBASE = 914                                                CSC022
508600200529     C                   OUT       LDA                                                        CSC022
508700200529     C                   Exsr      *PSSR                                                      CSC022
508800200529     C                   EndIf                                                                CSC022
508900200529     C                   EndIf                                                                CSC022
509000200529      *                                                                                       238825
509100200529      ** Access SAR file to determine if CSE022 is installed                                  238825
509200200529      *                                                                                       238825
509300200529     C                   CALLB     'AOSARDR0'                                                 238825
509400200529     C                   PARM      *BLANKS       @RTCD                                        238825
509500200529     C                   PARM      '*VERIFY'     @OPTN                                        238825
509600200529     C                   PARM      'CSE022'      @SARD                                        238825
509700200529     C     SCSARD        PARM      SCSARD        DSFDY                                        238825
509800200529                                                                                              238825
509900200529     C                   IF        @RTCD = *BLANK                                             238825
510000200529     C                   EVAL      CSE022 = 'Y'                                               238825
510100200529     C                   EVAL      PGMNAM = 'SEDORFRTV'                                       238825
510200200529     C                   ELSE                                                                 238825
510300200529     C                   EVAL      CSE022 = 'N'                                               238825
510400200529     C                   ENDIF                                                                238825
510500200529      *                                                                                       238825
510600200529      *                                                                                       CER001
510700200529      ** Retrieve the status of ULX008                                                        CER001
510800200529      *                                                                                       CER001
510900200529     C                   MOVE      'N'           ULX008                                       CER001
511000200529      *                                                                                       CER001
511100200529     C                   CALLB     'AOSARDR0'                                                 CER001
511200200529     C                   PARM      *BLANKS       @RtCd                                        CER001
511300200529     C                   PARM      '*VERIFY'     @Optn                                        CER001
511400200529     C                   PARM      'ULX008'      @SARD                                        CER001
511500200529      *                                                                                       CER001
511600200529     C                   IF        @RtCd = *Blanks                                            CER001
511700200529     C                   MOVE      'Y'           ULX008                                       CER001
511800200529     C                   ENDIF                                                                CER001
511900200529      *                                                                                       CER001
512000200529      ** Retrieve the status of ULX603                                                        CER001
512100200529      *                                                                                       CER001
512200200529     C                   MOVE      'N'           ULX603                                       CER001
512300200529      *                                                                                       CER001
512400200529     C                   CALLB     'AOSARDR0'                                                 CER001
512500200529     C                   PARM      *BLANKS       @RtCd                                        CER001
512600200529     C                   PARM      '*VERIFY'     @Optn                                        CER001
512700200529     C                   PARM      'ULX603'      @SARD                                        CER001
512800200529      *                                                                                       CER001
512900200529     C                   IF        @RtCd = *Blanks                                            CER001
513000200529     C                   MOVE      'Y'           ULX603                                       CER001
513100200529     C                   ENDIF                                                                CER001
513200200529      *                                                                                       CER001
513300200529     C                   IF        @RtCd <> *Blanks AND                                       CER001
513400200529     C                             @RtCd <> '*NRF   '                                         CER001
513500200529     C                   EVAL      DBKEY = 'ULX603'                                           CER001
513600200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
513700200529     C                   Z-ADD     10            DBASE                                        CER001
513800200529     C                   EXSR      *PSSR                                                      CER001
513900200529     C                   ENDIF                                                                CER001
514000200529      *                                                                                       CSC022
514100200529      ** Check if enhancement CGL014 (Collaterals Processing) is on                          BUG3145
514200200529                                                                                             BUG3145
514300200529     C                   CALLB     'AOSARDR0'                                                BUG3145
514400200529     C                   PARM      *BLANKS       PRTCD                                       BUG3145
514500200529     C                   PARM      '*VERIFY'     POPTN                                       BUG3145
514600200529     C                   PARM      'CGL014'      PSARD                                       BUG3145
514700200529     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3145
514800200529                                                                                             BUG3145
514900200529     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                 BUG3145
515000200529     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG3145
515100200529     C                   EVAL      DBKEY  = 'CGL014'                                         BUG3145
515200200529     C                   EVAL      DBASE  = 912                                              BUG3145
515300200529     C                   EXSR      *PSSR                                                     BUG3145
515400200529     C                   ENDIF                                                               BUG3145
515500200529                                                                                             BUG3145
515600200529     C                   IF        PRTCD = *BLANKS                                           BUG3145
515700200529     C                   EVAL      CGL014 = 'Y'                                              BUG3145
515800200529     C                   ELSE                                                                BUG3145
515900200529     C                   EVAL      CGL014 = 'N'                                              BUG3145
516000200529     C                   ENDIF                                                               BUG3145
516100200529                                                                                             BUG3145
516200200529      ** Check if CGL031 is enabled.                                                          CGL031
516300200529                                                                                              CGL031
516400200529     C                   CALLB     'AOSARDR0'                                                 CGL031
516500200529     C                   PARM      *BLANKS       PRtCd                                        CGL031
516600200529     C                   PARM      '*VERIFY'     POptn                                        CGL031
516700200529     C                   PARM      'CGL031'      PSARD                                        CGL031
516800200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
516900200529                                                                                              CGL031
517000200529     C                   EVAL      CGL031 = 'N'                                               CGL031
517100200529                                                                                              CGL031
517200200529     C                   IF        PRtCd = *BLANKS                                            CGL031
517300200529     C                   EVAL      CGL031 = 'Y'                                               CGL031
517400200529     C                   ELSE                                                                 CGL031
517500200529                                                                                              CGL031
517600200529     C                   IF        PRtCd <> '*NRF   '                                         CGL031
517700200529     C     *LOCK         IN        LDA                                                        CGL031
517800200529     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL031
517900200529     C                   EVAL      DBKey = PSARD                                              CGL031
518000200529     C                   EVAL      DBase = 101                                                CGL031
518100200529     C                   OUT       LDA                                                        CGL031
518200200529     C                   EXSR      *PSSR                                                      CGL031
518300200529     C                   ENDIF                                                                CGL031
518400200529                                                                                              CGL031
518500200529     C                   ENDIF                                                                CGL031
518600200529      *                                                                                       CSW210
518700200529      ** Check to see if switchable feature CSW210 is on or if date is                        CSW210
518800200529      ** equal or greater than 20 November 2010.                                              CSW210
518900200529      *                                                                                       CSW210
519000200529     C                   CALL      'SWIF2010'                                                 CSW210
519100200529     C                   PARM      *BLANKS       PRTCD                                        CSW210
519200200529                                                                                              CSW210
519300200529     C                   IF        PRTCD = 'CSW2010'                                          CSW210
519400200529     C                   EVAL      CSW210 = 'Y'                                               CSW210
519500200529     C                   ELSE                                                                 CSW210
519600200529     C                   EVAL      CSW210 = 'N'                                               CSW210
519700200529     C                   ENDIF                                                                CSW210
519800200529      *                                                                                       CSW210
519900200529      ** Check to see if switchable feature CFT004 in on.                                     CSW210
520000200529      *                                                                                       CSW210
520100200529     C                   CALLB     'AOSARDR0'                                                 CSW210
520200200529     C                   PARM      *BLANKS       PRtCd                                        CSW210
520300200529     C                   PARM      '*VERIFY'     POptn                                        CSW210
520400200529     C                   PARM      'CFT004'      PSARD                                        CSW210
520500200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSW210
520600200529                                                                                              CSW210
520700200529     C                   EVAL      CFT004 = 'N'                                               CSW210
520800200529                                                                                              CSW210
520900200529     C                   IF        PRtCd = *BLANKS                                            CSW210
521000200529     C                   EVAL      CFT004 = 'Y'                                               CSW210
521100200529     C                   ELSE                                                                 CSW210
521200200529                                                                                              CSW210
521300200529     C                   IF        PRtCd <> '*NRF   '                                         CSW210
521400200529     C     *LOCK         IN        LDA                                                        CSW210
521500200529     C                   EVAL      DBFile = 'SCSARDPD'                                        CSW210
521600200529     C                   EVAL      DBKey = PSARD                                              CSW210
521700200529     C                   EVAL      DBase = 102                                                CSW210
521800200529     C                   OUT       LDA                                                        CSW210
521900200529     C                   EXSR      *PSSR                                                      CSW210
522000200529     C                   ENDIF                                                                CSW210
522100200529                                                                                              CSW210
522200200529     C                   ENDIF                                                                CSW210
522300200529
522400200529     C                   ENDSR
522500200529      *****************************************************************
522600200529      /EJECT
522700200529      *****************************************************************
522800200529      *                                                               *
522900200529      * SETUPVALID - Set up additional fields that are needed on the  *
523000200529      *              valid file record.                               *
523100200529      *                                                               *
523200200529      *****************************************************************
523300200529
523400200529     C     SETUPVALID    BEGSR
523500200529
523600200529      * For Deletes & Authorises, put the complete (pre-existing) trade
523700200529      *  into the Valid file record
523800200529     C                   IF           DDACTN = 'D'
523900200529     C                             OR DDACTN = 'P'
524000200529     C                             OR DDACTN = 'Y'
524100200529     C                   MOVE      TradFilFmt    ValidTrad
524200200529     C                   MOVE      TX1AFilFmt    ValidTX1A
524300200529     C                   MOVE      TX1BFilFmt    ValidTX1B
524400200529     C                   ENDIF
524500200529
524600200529     C                   IF        DDACTN = 'I'
524700200529     C                   EXSR      SETUPTRADR
524800200529     C                   ENDIF
524900200529
525000200529      * Set Valid file field(s) that are needed for all Action Codes
525100200529     C                   EVAL      V_CHTP = DDACTN
525200200529
525300200529      * Do not override header fields from existing transaction.                              244537
525400200529     C**********         IF        DDACTN = 'I'                                     244537 AR971184A
525500200529     C                   IF        APFOTranID <> *BLANKS                                   AR971184A
525600200529                                                                                              244537
525700200529      * Include Header fields that need to be o/p to the Valid file
525800200529     C                   EVAL      V_FRNT = APFOTranID
525900200529     C                   EVAL      V_AFRT = APFOAsocID
526000200529     C                   EVAL      V_REPA = APRprLocn
526100200529                                                                                              244537
526200200529     C                   ENDIF                                                                244537
526300200529
526400200529      * Automatic Authorisation flag
526500200529     C                   IF        CAP051 = 'Y'
526600200529     C                   EVAL      V_AUTH = AUTHA
526700200529     C                   ENDIF
526800200529
526900200529     C                   EVAL      TranStatus = 'S'
527000200529                                                                                             BUG1569
527100200529      * Restore Timestamp from the original record                                           BUG1569
527200200529     C                   IF        DDACTN <> 'I'                                             BUG1569
527300200529     C                             AND @TimeStamp <> *BLANKS                                 BUG4728
527400200529     C                   MOVEL     @TimeStamp    V_TMST                                      BUG1569
527500200529     C                   ENDIF                                                               BUG1569
527600200529
527700200529     C                   ENDSR
527800200529
527900200529      *****************************************************************
528000200529      /EJECT
528100200529      *****************************************************************
528200200529      *                                                               *
528300200529      * SETUPTRADR - Set up Trade Reference for Inserts               *
528400200529      *                                                               *
528500200529      *****************************************************************
528600200529     C     SETUPTRADR    BEGSR
528700200529
528800200529     C                   IF           DDTDRF = *blanks
528900200529     C                             OR DDTDRF = *zeros
529000200529
529100200529     C                   RESET                   ReturnCode
529200200529     C                   CALLB     'ZATRNRTV'
529300200529     C                   PARM      *BLANKS       ReturnCode
529400200529     C                   PARM      'SE'          MODU              2
529500200529     C                   PARM      'T'           TRTY              1
529600200529     C                   PARM                    DDTDRF
529700200529     C                   PARM      *ZERO         V_TDRF
529800200529
529900200529     C     ReturnCode    IFNE      *BLANK
530000200529     C                   ADD       1             Idx
530100200529     C                   EVAL      FldNameArr(Idx) = 'DDTDRF'
530200200529     C                   EVAL      MsgIDArr(Idx) = 'ZATRNRTV'
530300200529     C                   ENDIF
530400200529
530500200529      ** If trade reference was entered, put it in the file field
530600200529     C                   ELSE
530700200529     C                   MOVE      DDTDRF        V_TDRF
530800200529
530900200529     C                   ENDIF
531000200529
531100200529     C                   ENDSR
531200200529      *****************************************************************
531300200529      /EJECT
531400200529      *****************************************************************
531500200529      *                                                               *
531600200529      * UPDATEDB - Update database                                    *
531700200529      *                                                               *
531800200529      *****************************************************************
531900200529
532000200529     C     UPDATEDB      BEGSR
532100200529      *
532200200529      * Update
532300200529     C                   RESET                   UpdRtnCode
532400200529     C                   EVAL      PMODE = 'UPC'
532500200529
532600200529     C                   CALLB     'SETRADUPD'
532700200529     C                   PARM                    UpdRtnCode
532800200529     C                   PARM                    ValidTrad
532900200529     C                   PARM                    ValidTx1A
533000200529     C                   PARM                    ValidTx1B
533100200529     C                   PARM                    S01401
533200200529     C                   PARM                    CSW003
533300200529     C                   PARM                    CAP051
533400200529     C                   PARM                    CAS006
533500200529     C                   PARM                    CGL031                                       CGL031
533600200529     C                   PARM                    PMODE
533700200529     C                   PARM                    PMCWL
533800200529     C                   PARM                    ValidTx2A
533900200529     C                   PARM                    ValidTx2B
534000200529
534100200529      *
534200200529      * If there were any errors in the update functions, rollback any
534300200529      * updates (done in *PSSR) and end this program. Otherwise commit.
534400200529     C     UpdRtnCode    IFNE      *BLANK
534500200529     C     UpdRtnCode    ANDNE     '*RECUPD'
534600200529     C                   MOVEL     '0'           APIRetc
534700200529     C                   EXSR      *PSSR
534800200529     C                   ELSE
534900200529     C                   If        (CSC022 <> 'Y')                                            CSC022
535000200529     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
535100200529     C                   COMMIT
535200200529     C                   EndIf                                                                CSC022
535300200529     C                   EndIf
535400200529      *
535500200529      * If update not done due to record being updated by another
535600200529      * workstation send message to screen.
535700200529
535800200529     C     UpdRtnCode    IFEQ      '*RECUPD'
535900200529     C                   MOVEL     '*ANY'        FldNameArr(1)
536000200529
536100200529     C                   MOVEL     'SEW3004'     MsgIdArr(1)
536200200529
536300200529     C                   EndIf
536400200529
536500200529     C                   ENDSR
536600200529      *****************************************************************
536700200529      /EJECT
536800200529      *****************************************************************
536900200529      * The following /COPY contains the standard program status
537000200529      * subroutine, including a bound call to the DBERRCTL module.
537100200529      *****************************************************************
537200200529     C/COPY ZACPYSRC,PSSR_ILE
537300200529      *****************************************************************
537400200529      /EJECT
537500200529      *****************************************************************
537600200529**  CPY@
537700200529(c) Finastra International Limited 2003
