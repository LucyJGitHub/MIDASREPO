000100201218     H DEBUG
000200201218     H COPYRIGHT('(c) Finastra International Limited 2002')
000300201218      *****************************************************************
000400201218/*XBI *  OVRDBF FILE(LOAMD) TOFILE(LOAMS) SHARE(*NO)                  *
000500201218/*STD *  RPGBASEMOD                                                   *
000600201218/*EXI *  TEXT('Midas LE Loan amendments database update')             *
000700201218      *****************************************************************
000800201218      *                                                               *
000900201218      *  Midas - Customer Lending ILE Module                          *
001000201218      *                                                               *
001100201218      *  LELOAMUPD - Midas LE Loan Amendment - Database Update        *
001200201218      *                                                               *
001300201218      *  (c) Finastra International Limited 2002                      *
001400201218      *                                                               *
001500201218      *  Last Amend No. CLE172             Date 01Oct20               *
001600201218      *  Prev Amend No. CSD103             Date 10Aug20               *
001700201218      *                 MD054317           Date 09Sep19               *
001800201218      *                 CER050             Date 16Jun19               *
001900201218      *                 CSD102             Date 08Jan19               *
002000201218      *                 MD050018           Date 05Nov18               *
002100201218      *                 MD047554           Date 11Oct17               *
002200201218      *                 MD046248           Date 27Oct17               *
002300201218      *                 AR848765           Date 30Jun15               *
002400201218      *                 AR943686           Date 23Sep16               *
002500201218      *                 CLE141             Date 08Feb16               *
002600201218      *                 AR547813           Date 13Nov15               *
002700201218      *                 MD026167           Date 13May14               *
002800201218      *                 MD025467           Date 08May14               *
002900201218      *                 MD024342B          Date 08May14               *
003000201218      *                 MD024342           Date 08May14               *
003100201218      *                 MD023787           Date 29Apr14               *
003200201218      *                 MD023203           Date 24Apr14               *
003300201218      *                 MD022807I          Date 24Apr14               *
003400201218      *                 AR876299           Date 07Dec11               *
003500201218      *                 MD022860           Date 14Oct13               *
003600201218      *                 MD021423E          Date 12Sep13               *
003700201218      *                 MD021423           Date 21Aug13               *
003800201218      *                 AR868380           Date 19Jun13               *
003900201218      *                 MD020568           Date 25May13               *
004000201218      *                 MD020534           Date 23May13               *
004100201218      *                 MD020390           Date 14May13               *
004200201218      *                 AR1035362          Date 15Oct12               *
004300201218      *                 AR580546           Date 24Apr13               *
004400201218      *                 AR1077027A         Date 19Mar13               *
004500201218      *                 AR1085742          Date 06Jan13               *
004600201218      *                 AR1021983          Date 01Aug12               *
004700201218      *                 AR656363           Date 01Aug12               *
004800201218      *                 264065             Date 01Aug12               *
004900201218      *                 CLE134             Date 01Aug12               *
005000201218      *                 AR322732           Date 23Jul12               *
005100201218      *                 CLE148             Date 23Jul12               *
005200201218      *                 CSC054             Date 23Feb12               *
005300201218      *                 CRE073             Date 06Dec10               *
005400201218      *                 CLE143             Date 06Dec10               *
005500201218      *                 CLE139             Date 06Dec10               *
005600201218      *                 CLE064             Date 06Dec10               *
005700201218      *                 CLE073             Date 13May08               *
005800201218      *                 CER059             Date 19Jul10               *
005900201218      *                 CER020             Date 19May08               *
006000201218      *                 CSD083             Date 27May10               *
006100201218      * Bank Fusion Midas 1.4 Base -----------------------------------*
006200201218      *                 BUG23026           Date 24Mar09               *
006300201218      *                 BUG26668           Date 04Nov09               *
006400201218      *                 243415             Date 23Oct06               *
006500201218      *                 243270             Date 03Nov06               *
006600201218      *                 CLE055             Date 04Jul06               *
006700201218      * Midas Plus 1.4 Base 04 ---------------------------------------*
006800201218      *                 256564             Date 17Sep08               *
006900201218      *                 CAS019             Date 20Apr07               *
007000201218      *                 243275             Date 30Mar07               *
007100201218      *                 BUG13325           Date 15Feb07               *
007200201218      * Midas Plus 1.3 ----------- Base ------------------------------*
007300201218      *                 CSD031             Date 10Apr06               *
007400201218      *                 CSD027             Date 09Dec05               *
007500201218      *                 BUG10655R          Date 24Feb06               *
007600201218/*    *                 BUG10604           Date 23Feb06               *
007700201218/*    *                 CLE042             Date 06Sep05               *
007800201218/*    *                 BUG9225            Date 16Nov05               *
007900201218/*    *                 BUG8566            Date 02Sep05               *
008000201218/*    *                 BUG8366            Date 30Aug05               *
008100201218/*    *                 CLE106             Date 01Aug04               *
008200201218      *                 CLE036             Date 22Sep03               *
008300201218      *                 CLE034             Date 05May03               *
008400201218      *                 CLE031             Date 03Feb03               *
008500201218      *                 BUG8241            Date 23Aug05               *
008600201218      *                 CAS011             Date 16May05               *
008700201218      *                 CAP086             Date 08Jun05               *
008800201218      *                 CSW037A            Date 02May05               *
008900201218      *                 CSD025             Date 11Jan05               *
009000201218      *                 CSW037             Date 15Dec04               *
009100201218      *                 CSW036             Date 15Dec04               *
009200201218      *                 BUG4138            Date 02Sep04               *
009300201218      *                 BUG0393            Date 06Aug04               *
009400201218      *                 BUG3760            Date 30Jul04               *
009500201218      *                 BUG3054            Date 06Jul04               *
009600201218      *                 CLE025             Date 20Oct03               *
009700201218      *                 CRE020             Date 20Jan04               *
009800201218      *                 CGL029             Date 01Sep03               *
009900201218      *                 CLE034             Date 01Dec03               *
010000201218      *                 213280             Date 15Jan03               *
010100201218      *                 CAP084             Date 11Oct02               *
010200201218      *                 CLE030             Date 03Oct02               *
010300201218      *                 CLE023             Date 03Oct02               *
010400201218      *                 CAP075  *CREATE    Date 01Aug02               *
010500201218      *                                                               *
010600201218      *---------------------------------------------------------------*
010700201218      *                                                               *
010800201218      *  CLE172 - LIBOR Deregulation - Lending (Recompile)            *
010900201218      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
011000201218      *  MD054317 - PDCL X not generated for freq based repayment     *
011100201218      *  CER050 - Annualised Percentage Rate (Recompile)              *
011200201218      *  CSD102 - Password Length Extension (Recompile)               *
011300201218      *  MD050018 - PDP Enhancement: Generate Projected Accnt Movment *
011400201218      *             for Input Cycle Principal Increase Events to PDCL *
011500201218      *  MD047554 - Create shadow postings of INTEREST and MATURITY   *
011600201218      *             with recalculated amount based on newly inserted, *
011700201218      *             amended, or reversed PI, BC, or SC.               *
011800201218      *           - All fields for loan reference should be alpha     *
011900201218      *             numeric.                                          *
012000201218      *  MD046248 - Finastra Rebranding                               *
012100201218      *  AR848765 - During amend of Principal Increase, value of OSAC *
012200201218      *             is not updated correctly, Instead of PONS/RONS,   *
012300201218      *             LAPONS/LARONS will be moved to field OSAC.        *
012400201218      *           - Applied for MD034480                              *
012500201218      *  AR943686 - CLE031: System generating wrong projected move-   *
012600201218      *             ment. Populate value of SCCY to convert amount    *
012700201218      *             to account currency.                              *
012800201218      *           - Applied for MD-40690                              *
012900201218      *  CLE141 - Currency and Location Business Day Convention       *
013000201218      *           (Recompile)                                         *
013100201218      *  AR547813 - Base rate change not captured by loans thus affec-*
013200201218      *             ting interest calculation. BR events were not pro-*
013300201218      *             cessed during COB if CHIN = blank. Default CHIN to*
013400201218      *             D or N when attaching loan to a Base Rate Code.   *
013500201218      *           - Applied for: MD-35600                             *
013600201218      *  MD026167 - COB: PDP should not update online positions but   *
013700201218      *             GLOLPSPD is being updated by PDP transactions     *
013800201218      *             during COB                                        *
013900201218      *  MD025467 - API locking issues Redesign Approach              *
014000201218      *  MD024342B - API issue. Trailer file allocation problem.      *
014100201218      *  MD024342 - LOAMSZ1 allocation problem                        *
014200201218      *  MD023787 - Posting for PDCL's PI and MR.                     *
014300201218      *  MD023203 - Locking issues during PDCL creation               *
014400201218      *  MD022807I - Update of LEMQLGPD->LGSTAT to 'S' will now be    *
014500201218      *              done in Java layer                               *
014600201218      *  AR876299 - Reverse fix BUG23026 (Child:AR876300)             *
014700201218      *  MD022860 - Access and update the LELOMZPD on COB to prevent  *
014800201218      *             corruption on LOAMSZ1                             *
014900201218      *  MD021423E - Deal date should be the deal date of the OL      *
015000201218      *              Pay instruction should be defaulted from receipt *
015100201218      *              instruction of the OL                            *
015200201218      *  MD021423 - Abnormally long run of PDCL/MAPY processing       *
015300201218      *             components                                        *
015400201218      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
015500201218      *             calling program if file locking occurred on       *
015600201218      *             online position files. (Child: AR868381)          *
015700201218      *  MD020568 - Encountered FOOB in LEC06A 10008                  *
015800201218      *  MD020534 - System did not generate PDCL for the unpaid       *
015900201218      *             balance of interest after COB (Recompile)         *
016000201218      *  MD020390 - Update fields AUTO and MTPD correctly when        *
016100201218      *             generated from COB                                *
016200201218      *  AR1035362- Loan Events - PI no on-line mvmt generated.       *
016300201218      *             Generate shadow postings during Authorization.    *
016400201218      *             (Child: AR1035364)                                *
016500201218      *  AR580546 - FOOB occured on LE0370 after the amount of a PI   *
016600201218      *             was amended. Correct the trailer update for PI    *
016700201218      *             amendment. (Child: AR934535)                      *
016800201218      *  AR1077027A - Encountered FOOB in LEC06A seq 01001 (Reopen)   *
016900201218      *  AR1085742 - Recovery handling when PDP components loop due   *
017000201218      *              to database connection issues                    *
017100201218      *  AR1021983 - [PDP] Option C - Technical Enhancements Stated   *
017200201218      *              in POC                                           *
017300201218      *  AR656363 - Do not update exposure when facility utilisation  *
017400201218      *             is 'N'. (Child: AR656364)                         *
017500201218      *  264065 - No adjustment on projections when amendments were   *
017600201218      *           inserted against the loan. Call LE2041 to reverse   *
017700201218      *           previous movements and repost adjusted movements.   *
017800201218      *  CLE134 - Past Due Call Loan Processing                       *
017900201218      *  AR322732 - LEC0212A and APISERVER locks LTRIX file.          *
018000201218      *           - Prevent LTRIX RRN 1 from being locked.            *
018100201218      *  CLE148 - Alpha Loan Reference                                *
018200201218      *  CSC054 - Period End Adjustments                              *
018300201218      *  CRE073 - Interest Rate Rounding                              *
018400201218      *  CLE143 - Original Loan Contract Date & Effective Interest    *
018500201218      *           Rate (Recompile)                                    *
018600201218      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
018700201218      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
018800201218      *  CLE073 - Calculated Loan Based Fees                          *
018900201218      *  CER059 - German Feature Upgrade to Delhi                     *
019000201218      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
019100201218      *           Midas Plus (Recompile)                              *
019200201218      *  CSD083 - Watch List Compliance Upgrade                       *
019300201218      *  BUG23026 - Loan Confirmation Report is not showing Principal *
019400201218      *             Increase                                          *
019500201218      *  BUG26668 - Deleted lines without annotation for BUG8366      *
019600201218      *  243415 - Projected CR entries not generated even after       *
019700201218      *           authorisation.                                      *
019800201218      *  243270 - Errors in projected account movements               *
019900201218      *  CLE055 - Projected LE Movements                              *
020000201218      *  256564 - Recompile due to PF changes done by fix 256330      *
020100201218      *  CAS019 - Upgrade of CAS016 to Midas Plus                     *
020200201218      *  243275 - Principal Increase are doubling the exposure amount *
020300201218      *           during authorisation of the transaction.            *
020400201218      *  BUG13325 - No Swift MT202 produced in MT202, applied 238721A *
020500201218      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
020600201218      *  CSD027 - Conversion Of Customer Number to Alpha              *
020700201218      *  BUG10655R - PSAM is updated again during authorisation       *
020800201218      *  BUG10604- UNLOCK record locking for PTPF.                    *
020900201218      *  CLE042 - Extended Loan Sub Type                              *
021000201218      *  BUG9225 - Update LESTALPD with correct loan amendment        *
021100201218      *            sequence number.                                   *
021200201218      *  BUG8566- Principal Increase - authorized transaction creates *
021300201218      *           invalid postings in LEHOSTPD                        *
021400201218      *  BUG8366- Beneficiary not written in LEHOSTPD                 *
021500201218      *  CLE106 - Syndications Manager.                               *
021600201218      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2  *
021700201218      *           Allow specific base rates  (Recompile)              *
021800201218      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
021900201218      *           (Recompile)                                         *
022000201218      *  CLE031 - Lending Enhancements                                *
022100201218      *  BUG8241- OME RPG patch for delivery                          *
022200201218      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
022300201218      *  CAP086 - Introduce Auto Authorisation to the API's           *
022400201218      *           without it                                          *
022500201218      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
022600201218      *  CSD025 - Customer De-Activation                              *
022700201218      *  CSW037 - Additional Field Data on MT300/MT320                *
022800201218      *  CSW036 - Dual SWIFT BIC held on Client Details               *
022900201218      *  BUG4138 - Incorrect update of trailer file on authorisation. *
023000201218      *  BUG3936 - No need to count on Authorize action as Loan       *
023100201218      *            Amendment was already counted during Insert.       *
023200201218      *            Also, rename NORE of LTRIX to NORELX to avoid      *
023300201218      *            corruption with NORE of LOAMSZ1                    *
023400201218      *  BUG3760 - Compliance Watch (CSD015) changes missing from the *
023500201218      *            Lending APIs.                                      *
023600201218      *  BUG3054 - Update OSAC field in LOAMSDK to properly generate  *
023700201218      *            postings in RSACMTPD.                              *
023800201218      *  CLE025 - Credit Lines                                        *
023900201218      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
024000201218      *  CGL029 - Increase Account Code to 10 digits                  *
024100201218      *  CLE034 - Lending Enhancements Phase 1 Priority 1A (recompile)*
024200201218      *  213280 - Action field missing in LE0320P1                    *
024300201218      *  CAP084 - Midas Plus API development                          *
024400201218      *  CLE030 - Release Authorisation processing                    *
024500201218      *  CLE023 - Lending Facility History Improvements.              *
024600201218      *  CAP075 - Lending API enhancements - Loan Amendments          *
024700201218      *                                                               *
024800201218      *****************************************************************
024900201218      ** +--------------------------------------+
025000201218      **   F-specs                               
025100201218      **   =======                               
025200201218      ** +--------------------------------------+
025300201218
025400201218      ** Midas LE Loan Amendment Details
025500201218     FLOAMD     UF A E           K DISK    INFSR(*PSSR) COMMIT
025600201218     F                                     IGNORE(LOAMSDHF)
025700201218
025800201218      ** Midas LE Loan Transaction Index Detail
025900201218     F***LTRIX**** UF   F   43        DISK    INFSR(*PSSR) COMMIT                           AR322732
026000201218     FLTRIX     O  A F   45        DISK    INFSR(*PSSR) COMMIT                              AR322732
026100201218     F                                     INFDS(FLDTX)
026200201218
026300201218      ** Midas LE Customer loans
026400201218     FCLOAN     UF   E           K DISK    INFSR(*PSSR) COMMIT
026500201218     F                                     INCLUDE(CLOANCLF)
026600201218     F                                     PREFIX(LO_)
026700201218
026800201218      ** Midas LE Customer Lending Facility File
026900201218     FFCLTY     UF   E           K DISK    INFSR(*PSSR) COMMIT
027000201218     F                                     IGNORE(FCLTYHHF)
027100201218     F                                     IGNORE(FCLTYZZF)
027200201218     F                                     PREFIX(FA_)
027300201218
027400201218      ** Midas LE Loan amendment fee index file
027500201218     FLEFELAL0  UF A E           K DISK    INFSR(*PSSR) COMMIT
027600201218
027700201218      ** Midas LE Lending fees master detail inputs
027800201218     FLEFEEDL1  UF   E           K DISK    INFSR(*PSSR) COMMIT
027900201218
028000201218      *                                                                                     MD023203
028100201218     FLEFEEDL0  UF   E           K DISK    INFSR(*PSSR)                                     MD023203
028200201218     F                                     COMMIT                                           MD023203
028300201218     F                                     RENAME(LEFEEDF:LEFEEDX)                          MD023203
028400201218     F                                     PREFIX(X_)                                       MD023203
028500201218      *                                                                                       CLE030
028600201218     FLERELEPD  UF A E           K DISK    INFSR(*PSSR)                                       CLE030
028700201218     F                                     COMMIT                                             CLE030
028800201218                                                                                              CRE020
028900201218     FREADVCL2  UF   E           K DISK    USROPN                                             CRE020
029000201218     F                                     COMMIT                                             CRE020
029100201218      ** Midas RE Settled Transaction Index File by Ref No/Pgm Ref/Seq No                     CRE020
029200201218                                                                                              CRE020
029300201218     FSDCWHTL1  IF   E           K DISK                                                      BUG3760
029400201218      *                                                                                      BUG3760
029500201218      ** Compliance Watch Hit List                                                           BUG3760
029600201218      *                                                                                      BUG3760
029700201218     FLEEIRDL5  UF   E           K DISK    COMMIT                                             CAS011
029800201218     F                                     RENAME(LEEIRDD0: LEEIRDD5)                         CAS011
029900201218     FLESTALLA  UF   E           K DISK    COMMIT                                            BUG9225
030000201218      ** Midas LE Settlement Allocation by Parent PC Reference                               BUG9225
030100201218                                                                                              CAS019
030200201218      ** Effective Interest Rate Details                                                      CAS019
030300201218     FLEEIRDL9  UF   E           K DISK    INFSR(*PSSR)                                       CAS019
030400201218     F                                     COMMIT                                             CAS019
030500201218     F                                     RENAME(LEEIRDD0:LEEIRDD9)                          CAS019
030600201218      ** Effective Interest Rate Details                                                      CAS019
030700201218     FLEERAPL1  UF   E           K DISK    INFSR(*PSSR)                                       CAS019
030800201218     F                                     COMMIT                                             CAS019
030900201218      ** Loan Amendments for Updating                                                      AR1021983
031000201218     FLELOMKL3  UF A E           K DISK    COMMIT                                          AR1021983
031100201218     F                                     IGNORE(LOAMSDHF)                                AR1021983
031200201218     F                                     RENAME(LOAMSDKF:LOMKSDKF)                       AR1021983
031300201218     F                                     RENAME(LOAMSZ1F:LOMKSZ1F)                       AR1021983
031400201218      ** PDCL Loan Link file                                                                MD050018
031500201218     FLEPDUELE  UF A E           K DISK    COMMIT                                           MD050018
031600201218     F                                     INFSR(*PSSR)                                     MD050018
031700201218     FLEPDUEL6  UF   E           K DISK    COMMIT                                           MD050018
031800201218     F                                     INFSR(*PSSR)                                     MD050018
031900201218     F                                     RENAME(LEPDUED0:LEPDUED6)                        MD050018
032000201218     FLEPDUFLA  UF A E           K DISK    COMMIT                                           MD050018
032100201218     F                                     INFSR(*PSSR)                                     MD050018
032200201218     FLEPDUFLE  UF   E           K DISK    COMMIT                                           MD050018
032300201218     F                                     INFSR(*PSSR)                                     MD050018
032400201218     F                                     RENAME(LEPDUFD0:LEPDUFDE)                        MD050018
032500201218                                                                                              CLE134
032600201218      ** PDP Transaction Log File sent to MQ                                                  CLE134
032700201218     F***LEMQLGL0  UF   E           K DISK    INFSR(*PSSR)                          CLE134 MD022807I
032800201218     F**********                           COMMIT                                   CLE134 MD022807I
032900201218     F***SDAPDRL0  IF   E           K DISK    INFSR(*PSSR)                         MD024342 MD025467
033000201218      **********                                                                   MD024342 MD025467
033100201218      ***Midas*SD API Driving File                                                 MD024342 MD025467
033200201218     F***LOAMSZ1X  O    E             DISK    COMMIT                              MD024342B MD025467
033300201218     F**********                           RENAME(LOAMSZ1F:LOAMSZ1FX)             MD024342B MD025467
033400201218      ***API:*Midas LE LOAN AMENDS TRAILER                                        MD024342B MD025467
033500201218      **********                                                                  MD024342B MD025467
033600201218      *****************************************************************
033700201218      /EJECT
033800201218      *****************************************************************
033900201218      ** +--------------------------------------+
034000201218      **   Automatically included D-specs        
034100201218      **   ==============================        
034200201218      ** +--------------------------------------+
034300201218
034400201218      **----------------------------------------------------------------
034500201218      ** The following /COPY line includes (among others) the LDA layout
034600201218      ** and the copyright array definition:
034700201218     D/COPY ZACPYSRC,STD_D_SPEC
034800201218      **----------------------------------------------------------------
034900201218      *
035000201218      **----------------------------------------------------------------
035100201218      ** The following /COPY includes the MM standard declares:
035200201218     D/COPY ZACPYSRC,STDDECLARE
035300201218      **----------------------------------------------------------------
035400201218      *
035500201218      **----------------------------------------------------------------
035600201218      ** The following /COPY line includes all the defined fields in the
035700201218      ** Program Status Data Structures.  They have meaningful
035800201218      ** names, prefixed by 'PS'.
035900201218     D/COPY ZACPYSRC,PSDS
036000201218      **----------------------------------------------------------------
036100201218      ** The following /COPY line includes the definitions for error and
036200201218      ** warning message arrays.
036300201218     D/COPY ZACPYSRC,ERR_ARRAYS
036400201218      **----------------------------------------------------------------
036500201218      *
036600201218      **----------------------------------------------------------------
036700201218
036800201218      ** +--------------------------------------+
036900201218      **   End of automatically included D-specs 
037000201218      **   ===================================== 
037100201218      ** +--------------------------------------+
037200201218      *****************************************************************
037300201218      /EJECT
037400201218      *****************************************************************
037500201218      ** +--------------------------------------+
037600201218      **   Manually included D-specs             
037700201218      **   =========================             
037800201218      ** +--------------------------------------+
037900201218
038000201218      ** +--------------------------------------+
038100201218      **   Named constants                       
038200201218      **   ===============                       
038300201218      ** +--------------------------------------+
038400201218
038500201218     D*PSysValOME      C                   CONST('OMEIndicator')                      BUG8241 CSC054
038600201218     D PSysValPEA      C                   CONST('PEAIndicator')                              CSC054
038700201218     D PSysValPIAC     C                   CONST('PDCLPAMVPIAC')                            MD050018
038800201218      ** +--------------------------------------+
038900201218      **   Arrays and Data Structures            
039000201218      **   ==========================            
039100201218      ** +--------------------------------------+
039200201218                                                                                            AR656363
039300201218     D WUpdExpo        S              1A                                                    AR656363
039400201218     D CobMode         S              1A                                                   MD021423E
039500201218
039600201218      ** File information data structure for LTRIX
039700201218     D FLDTX           DS
039800201218     D   TXSTS           *STATUS
039900201218
040000201218      ** Switchable feature details                                                           CRE020
040100201218     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRE020
040200201218     D  SCLCD        E                     EXTFLD(LCD)                                        CRE020
040300201218                                                                                              CRE020
040400201218      ** Currency details
040500201218     D SDCURR        E DS                  EXTNAME(SDCURRPD)
040600201218
040700201218      ** Nostro details
040800201218     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
040900201218
041000201218      ** Midas API message header format definition
041100201218     D APHEAD        E DS                  EXTNAME(APHEADPD)
041200201218
041300201218      ** DS for access programs, short data structure
041400201218     D DSFDY         E DS                  EXTNAME(DSFDY)
041500201218
041600201218      ** DS for access programs, long data structure
041700201218     D DSSDY         E DS                  EXTNAME(DSSDY)
041800201218
041900201218      ** SD data area                                                                        BUG3760
042000201218      *                                                                                      BUG3760
042100201218     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                    BUG3760
042200201218      *                                                                                      BUG3760
042300201218      ** 24X7 status data area                                                               BUG3760
042400201218      *                                                                                      BUG3760
042500201218     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                    BUG3760
042600201218      *                                                                                      BUG3760
042700201218      ** External DS for Customer Details                                                    BUG3760
042800201218      *                                                                                      BUG3760
042900201218     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                 BUG3760
043000201218      *                                                                                      BUG3760
043100201218      ** External DS for Compliance Watch Transaction Details                                BUG3760
043200201218      *                                                                                      BUG3760
043300201218     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                 BUG3760
043400201218      *                                                                                      BUG3760
043500201218      ** Watch List Transaction Details Data Structure                                       BUG3760
043600201218      *                                                                                      BUG3760
043700201218     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)                                 BUG3760
043800201218      *                                                                                      BUG3760
043900201218      ** External DS for Watch List Configuration Data                                       BUG3760
044000201218      *                                                                                      BUG3760
044100201218     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                 BUG3760
044200201218                                                                                              CAS011
044300201218      ** External DS for Midas Hedging ICD file                                               CAS011
044400201218                                                                                              CAS011
044500201218     D SDHEDG        E DS                  EXTNAME(SDHEDGPD)                                  CAS011
044600201218      *                                                                                      BUG3760
044700201218      ** Compliance Engine Free Format String Parameter                                      BUG3760
044800201218      *                                                                                      BUG3760
044900201218     D PFreeFmtStr     S          30000A                                                     BUG3760
045000201218      *                                                                                      BUG3760
045100201218      ** Array Size Definition                                                               BUG3760
045200201218      *                                                                                      BUG3760
045300201218     D Elements        C                   CONST(26)                                         BUG3760
045400201218      *                                                                                      BUG3760
045500201218      ** CWA Array used in Midas Compliance Watch                                            BUG3760
045600201218      *                                                                                      BUG3760
045700201218     D CWA             S             25A   DIM(Elements) PERRCD(1) CTDATA                    BUG3760
045800201218      *                                                                                      BUG3760
045900201218      ** Watch List Fields Array.                                                            BUG3760
046000201218      *                                                                                      BUG3760
046100201218     D WLF             S             18A   DIM(12)                                           BUG3760
046200201218      *                                                                                      BUG3760
046300201218      ** Current loan amendment in file format
046400201218     D LoamFilFmt    E DS                  EXTNAME(LOAMSDK)
046500201218                                                                                              CRE073
046600201218      ** Current loan amendment in file format                                                CRE073
046700201218     D LoamFilXFmt   E DS                  EXTNAME(LEVLOAMPD)                                 CRE073
046800201218     D                                     PREFIX(@)                                          CRE073
046900201218      *
047000201218      ***  Loan details 'A' format
047100201218     D LoanDetsA     E DS                  EXTNAME(CLOAN:CLOANCLF)
047200201218     D                                     PREFIX(LO_)
047300201218     D RECIA         E                     EXTFLD(RECI)
047400201218     D PTYPA         E                     EXTFLD(PTYP)
047500201218     D LTYPA         E                     EXTFLD(LTYP)
047600201218     D SUTPA         E                     EXTFLD(SUTP)
047700201218     D AUTOC         E                     EXTFLD(AUTO)
047800201218     D FCUSC         E                     EXTFLD(FCUS)
047900201218     D FTYPC         E                     EXTFLD(FTYP)
048000201218     D FSEQC         E                     EXTFLD(FSEQ)
048100201218     D CCYD          E                     EXTFLD(CCY )
048200201218     D LCDA          E                     EXTFLD(LCD )
048300201218     D CHTPA         E                     EXTFLD(CHTP)
048400201218     D TNLUA         E                     EXTFLD(TNLU)
048500201218     D FCLBC         E                     EXTFLD(FCLB)
048600201218     D RCSIC         E                     EXTFLD(RCSI)
048700201218     D IUSRC         E                     EXTFLD(IUSR)
048800201218     D AUSRC         E                     EXTFLD(AUSR)
048900201218     D XUSRC         E                     EXTFLD(XUSR)
049000201218     D CLASA         E                     EXTFLD(CLAS)                                       CLE042
049100201218
049200201218      ***  Loan details 'B' format
049300201218     D LoanDetsB     E DS                  EXTNAME(CLOAN:CLOANCKF)
049400201218     D                                     PREFIX(LO_)
049500201218     D LB_RECI       E                     EXTFLD(RECI)
049600201218     D LB_LNRF       E                     EXTFLD(LNRF)
049700201218     D LB_RCDT       E                     EXTFLD(RCDT)
049800201218     D LB_MRIN       E                     EXTFLD(MRIN)
049900201218     D LB_ORED       E                     EXTFLD(ORED)
050000201218     D LB_LCD        E                     EXTFLD(LCD)
050100201218     D LB_CHTP       E                     EXTFLD(CHTP)
050200201218     D LB_TNLU       E                     EXTFLD(TNLU)
050300201218     D LB_FRNT       E                     EXTFLD(FRNT)
050400201218     D LB_AFRT       E                     EXTFLD(AFRT)
050500201218     D LB_REPA       E                     EXTFLD(REPA)
050600201218     D LB_TMST       E                     EXTFLD(TMST)
050700201218      *
050800201218      ***  Facility details 'A' format
050900201218     D FacilityA     E DS                  EXTNAME(FCLTY:FCLTYFMF)
051000201218     D                                     PREFIX(FA_)
051100201218     D CNUMF         E                     EXTFLD(CNUM)
051200201218      *
051300201218      ***  Facility details 'B' format
051400201218     D FacilityB     E DS                  EXTNAME(FCLTY:FCLTYFNF)
051500201218     D                                     PREFIX(FA_)
051600201218     D FB_RECI       E                     EXTFLD(RECI)
051700201218     D FB_CNUM       E                     EXTFLD(CNUM)
051800201218     D FB_FACT       E                     EXTFLD(FACT)
051900201218     D FB_FCNO       E                     EXTFLD(FCNO)
052000201218     D FB_RCTP       E                     EXTFLD(RCTP)
052100201218     D FB_ORED       E                     EXTFLD(ORED)
052200201218     D FB_LCD        E                     EXTFLD(LCD)
052300201218     D FB_CHTP       E                     EXTFLD(CHTP)
052400201218     D FB_TNLU       E                     EXTFLD(TNLU)
052500201218     D FB_FRNT       E                     EXTFLD(FRNT)
052600201218     D FB_AFRT       E                     EXTFLD(AFRT)
052700201218     D FB_REPA       E                     EXTFLD(REPA)
052800201218     D FB_STMP       E                     EXTFLD(STMP)
052900201218
053000201218      ** Error indicators
053100201218     D LOAM_OK       E DS                  EXTNAME(LEELOAMPD)
053200201218
053300201218      ** New loan amendment in file format
053400201218     D ValidLoam     E DS                  EXTNAME(LEVLOAMPD)
053500201218
053600201218      ** External data structures for update of PRONO, MEMOS etc.
053700201218     D Z#BSTS        E DS                  EXTNAME(Z#BST)
053800201218     D Z#ASTS        E DS                  EXTNAME(Z#AST)
053900201218     D Z#WSTS        E DS                  EXTNAME(Z#WST)
054000201218
054100201218      ***  before image1 of update to LE position files                                       CLE055
054200201218     D                 DS                                                                     CLE055
054300201218     D Z#ZADTB                      256                                                       CLE055
054400201218     D     ZB_TYPE            85     86                                                       243415
054500201218     D     ZB_OTOURS          87    104                                                       243415
054600201218                                                                                              CLE055
054700201218      ***  after image1 of update to LE position files                                        CLE055
054800201218     D                 DS                                                                     CLE055
054900201218     D Z#ZADTA                      256                                                       CLE055
055000201218     D     ZA_TYPE            85     86                                                       CLE055
055100201218     D     ZA_OTOURS          87    104                                                       CLE055
055200201218                                                                                              CLE055
055300201218      ** Fields used for update of MEMOS, PRONO etc.
055400201218     D                 DS
055500201218     D Z#ADTA                  1    256
055600201218     D   SHRECI                1      1
055700201218     D   SHLNRF                2      7
055800201218     D   SHVDAT                8     12  0
055900201218     D   SHLASN               13     15  0
056000201218     D   SHPTYP               21     22  0
056100201218     D   SHAMTP               23     24
056200201218     D   SHRTSP               29     34P 7
056300201218     D   SHCCY                35     37
056400201218     D   SHPRAM               38     44P 0
056500201218     D   SHBRCA               73     75
056600201218     D   SHREPT               82     82  0
056700201218     D***SHTIST*              85    118                                                       CGL029
056800201218     D   SHTIST               85    124                                                       CGL029
056900201218     D     TYPE               85     86
057000201218     D*****OTOURS             87     98                                                       CGL029
057100201218     D*****THRS*              99    108                                                       CGL029
057200201218     D*****OTFACO            109    118                                                       CGL029
057300201218     D     OTOURS             87    104                                                       CGL029
057400201218     D     THRS              105    114                                                       CGL029
057500201218     D     OTFACO            115    124                                                       CGL029
057600201218     D   SHINTC              253    253
057700201218      *
057800201218     D Z#ADTB                257    512
057900201218     D   SHOSBR              261    263
058000201218     D   SHCHTP              317    317
058100201218      *
058200201218     D Z#ADTE               1025   1280
058300201218     D   SHSCCY             1061   1063
058400201218     D   SHICCY             1064   1066
058500201218     D   SHREXR             1090   1096P 8                                                    CLE031
058600201218     D   SHREXI             1097   1097                                                       CLE031
058700201218     D   SHPSCY             1098   1100                                                       CLE031
058800201218     D   SHPEXR             1101   1107P 8                                                    CLE031
058900201218     D   SHPEXI             1108   1108                                                       CLE031
059000201218     D   SHSTAL             1109   1109                                                       CLE034
059100201218
059200201218     D Z#ADTH          DS                                                                     CLE134
059300201218     D  SHXRFI                        3A                                                      CLE134
059400201218     D  SHXRFN                       10S 0                                                    CLE134
059500201218
059600201218     D FCLKEY          DS
059700201218     D***WFCNM**               1      6  0                                                    CSD027
059800201218     D   WFCNM                 1      6                                                       CSD027
059900201218     D   WFACT                 7      9  0
060000201218     D   WFNUM                10     11  0
060100201218     D   WFRTP                12     12
060200201218
060300201218      ** Dates for Facility Exposure Array
060400201218     D                 DS
060500201218     D  FB_RUN0                1      3P 0
060600201218     D  FB_RUN1                4      6P 0
060700201218     D  FB_RUN2                7      9P 0
060800201218     D  FB_RUN3               10     12P 0
060900201218     D  FB_RUN4               13     15P 0
061000201218     D  FB_RUN5               16     18P 0
061100201218     D  FB_RUN6               19     21P 0
061200201218     D  FB_RUN7               22     24P 0
061300201218     D  FB_RUN8               25     27P 0
061400201218     D  FB_RUN9               28     30P 0
061500201218     D  FB_RUN                 1     30P 0 DIM(10) ASCEND
061600201218
061700201218      ** Facility Exposure Array
061800201218     D                 DS
061900201218     D  FB_OAM1                1      7P 0
062000201218     D  FB_OAM2                8     14P 0
062100201218     D  FB_OAM3               15     21P 0
062200201218     D  FB_OAM4               22     28P 0
062300201218     D  FB_OAM5               29     35P 0
062400201218     D  FB_OAM6               36     42P 0
062500201218     D  FB_OAM7               43     49P 0
062600201218     D  FB_OAM8               50     56P 0
062700201218     D  FB_OAM9               57     63P 0
062800201218     D  FB_OA10               64     70P 0
062900201218     D  FB_OAM                 1     70P 0 DIM(10)
063000201218      *                                                                                       CLE030
063100201218      ** Break up timestamp field to get RETIME for Release Authorisation Report              CLE030
063200201218     D  WRLTMST        DS            26                                                       CLE030
063300201218     D  WREHRS                12     13                                                       CLE030
063400201218     D  WREMIN                15     16                                                       CLE030
063500201218     D  WRESEC                18     19                                                       CLE030
063600201218
063700201218      ** Data Structure for MPHAS Dataarea                                                  MD021423
063800201218                                                                                            MD021423
063900201218     D MPHAS           DS             1                                                     MD021423
064000201218                                                                                            MD021423
064100201218      ** +--------------------------------------+
064200201218      **   Declared variables                    
064300201218      **   ==================                    
064400201218      ** +--------------------------------------+
064500201218
064600201218      ** Message file for ZAMSGTOOPR
064700201218     D DummyMsgF       S             10    INZ('LERMSGF')
064800201218
064900201218      ** Timestamp for the transaction
065000201218     D TimeStamp       S               Z
065100201218
065200201218      ** Currency conversion
065300201218     D POWR            S              7  3 DIM(7) CTDATA PERRCD(1)
065400201218
065500201218      ** Currencies and telex notice days
065600201218     D CYA             S              3    DIM(150)
065700201218     D TND             S              1  0 DIM(150)
065800201218
065900201218      ** Parameter for APLOGTRAN
066000201218     D TransDtl        S           5800A
066100201218                                                                                              CLE025
066200201218     D CLE025          S              1                                                       CLE025
066300201218     D CLE031          S              1                                                       CLE031
066400201218                                                                                              CRE020
066500201218      ** CRE020 Variables                                                                     CRE020
066600201218     D PRtCd           S              7A                                                      CRE020
066700201218     D POptn           S              7A                                                      CRE020
066800201218     D PSARD           S              6A                                                      CRE020
066900201218     D CRE020          S              1A                                                      CRE020
067000201218     D KRefNo          S             30A                                                      CRE020
067100201218     D KSeqNo          S              3A                                                      CRE020
067200201218     D KPrgMn          S             10A   INZ('LELOAMUPD ')                                  CRE020
067300201218     D PSysVal01       S             20A   INZ('LoanAmendments      ')                        CRE020
067400201218     D PCurSet01       S            200A                                                      CRE020
067500201218     D PSysVal02       S             20A                                                      CRE020
067600201218     D PCurSet02       S            200A                                                      CRE020
067700201218     D PSysVal03       S             20A                                                      CRE020
067800201218     D PCurSet03       S            200A                                                      CRE020
067900201218     D PSysVal04       S             20A                                                      CRE020
068000201218     D PCurSet04       S            200A                                                      CRE020
068100201218     D PSysVal05       S             20A                                                      CRE020
068200201218     D PCurSet05       S            200A                                                      CRE020
068300201218     D PSysVal06       S             20A                                                      CRE020
068400201218     D PCurSet06       S            200A                                                      CRE020
068500201218     D PSysVal07       S             20A                                                      CRE020
068600201218     D PCurSet07       S            200A                                                      CRE020
068700201218     D PSysVal08       S             20A                                                      CRE020
068800201218     D PCurSet08       S            200A                                                      CRE020
068900201218     D PSysVal09       S             20A                                                      CRE020
069000201218     D PCurSet09       S            200A                                                      CRE020
069100201218     D PSysVal10       S             20A                                                      CRE020
069200201218     D PCurSet10       S            200A                                                      CRE020
069300201218     D WEvent          S              8A                                                      CRE020
069400201218     D WPrtAdv         S              1A                                                      CRE020
069500201218     D WNew            S              1A                                                      CRE020
069600201218                                                                                              CGL029
069700201218     D T#TREF          S             26A                                                      CGL029
069800201218     D @ACCD           S             10A                                                      CGL029
069900201218     D PDealNo         S             24A                                                      CGL029
070000201218     D PADealNo        S             24A                                                      CGL029
070100201218
070200201218     D CAS016          S              1                                                       CAS019
070300201218     D CAS009          S              1                                                       CAS011
070400201218     D CSC011          S              1                                                      BUG3760
070500201218     D CSD015          S              1                                                      BUG3760
070600201218     D CCF001          S              1                                                      BUG3760
070700201218     D CLE055          S              1                                                       CLE055
070800201218      *                                                                                      BUG3760
070900201218     D WFuncType       S              8                                                      BUG3760
071000201218     D WIdntifier      S             40                                                      BUG3760
071100201218     D WBranch         S              3                                                      BUG3760
071200201218      *                                                                                      BUG3760
071300201218     D WData           S            216                                                      BUG3760
071400201218     D WDDT            S               D                                                     BUG3760
071500201218     D WLNRF           S              6                                                      BUG3760
071600201218     D WKVDAT          S              5                                                      BUG3760
071700201218     D WLASN           S              3                                                      BUG3760
071800201218     D*WROBN****       S              6P 0                                            BUG3760 CSD027
071900201218     D*WROCN****       S              6P 0                                            BUG3760 CSD027
072000201218     D*WPOBN****       S              6P 0                                            BUG3760 CSD027
072100201218     D*WPOCN****       S              6P 0                                            BUG3760 CSD027
072200201218     D WROBN           S              6                                                       CSD027
072300201218     D WROCN           S              6                                                       CSD027
072400201218     D WPOBN           S              6                                                       CSD027
072500201218     D WPOCN           S              6                                                       CSD027
072600201218     D WDTPC           S              1                                                      BUG3760
072700201218     D WDIFF           S              1                                                      BUG3760
072800201218     D WOPN            S             25                                                      BUG3760
072900201218     D WCLS            S             25                                                      BUG3760
073000201218     D WADJP           S              1                                                       CAS011
073100201218     D WDELR           S              1                                                       CAS011
073200201218     D*WTRAN****       S              6  0                                             CAS011 CLE148
073300201218     D WTRAN           S              6                                                       CLE148
073400201218     D WVALD           S              5  0                                                    CAS011
073500201218      *                                                                                      BUG3760
073600201218     D Ctr             S              2P 0                                                   BUG3760
073700201218     D CLS             S              2P 0                                                   BUG3760
073800201218     D OPN             S              2P 0                                                   BUG3760
073900201218     D PRetCode        S              7                                                      BUG3760
074000201218     D POption         S              7                                                      BUG3760
074100201218     D PCUST           S             10                                                      BUG3760
074200201218     D PYCCY           S              3                                                      BUG3760
074300201218     D PSTKey          S              7                                                      BUG3760
074400201218     D PFunc           S              8                                                      BUG3760
074500201218     D ConvertedAmt    S             18P 3                                                   BUG3760
074600201218     D PAmt            S             15                                                      BUG3760
074700201218     D PDummy6         S              6                                                      BUG3760
074800201218     D PDummy16        S             16                                                      BUG3760
074900201218     D PDummy35        S             35                                                      BUG3760
075000201218     D PDumy35a        S             35                                                      BUG3760
075100201218      *                                                                                      BUG3760
075200201218      ** ZACVTDATE Parameters                                                                BUG3760
075300201218      *                                                                                      BUG3760
075400201218     D PZARtCd         S              7                                                      BUG3760
075500201218     D PZADayNo        S              5                                                      BUG3760
075600201218     D PZADDT          S               D                                                     BUG3760
075700201218     D PZACvtDt        S             10                                                      BUG3760
075800201218      *                                                                                      BUG3760
075900201218     D*CSC024***       S              1A                                              BUG8241 CSC054
076000201218     D*WOMEInd**       S              1A                                              BUG8241 CSC054
076100201218     D CSC054          S              1A                                                      CSC054
076200201218     D WPEAInd         S              1A                                                      CSC054
076300201218                                                                                             BUG8241
076400201218     D WrkUpdFlag      S              1A                                                    BUG10604
076500201218                                                                                            BUG10604
076600201218     D PRI1            S              1S 0                                                  AR322732
076700201218     D CLE134          S              1A                                                   AR1021983
076800201218     D W#FRNT          S              8A                                                   AR1021983
076900201218     D WkPIAC          S              1A                                                    MD050018
077000201218     D PLoanType       S              2A                                                    MD050018
077100201218     D PLSubType       S              2A                                                    MD050018
077200201218     D PLClass         S              4A                                                    MD050018
077300201218     D WkCPAM          S             15  0                                                  MD050018
077400201218     D WkDINT          S             15  0                                                  MD050018
077500201218     D WkLASN          S              3  0                                                  MD050018
077600201218     D WkRECI          S              1A                                                    MD050018
077700201218     D WkPDCT          S              1A                                                    MD050018
077800201218      ** +--------------------------------------+
077900201218      **   End of D-specs                        
078000201218      **   ==============                        
078100201218      ** +--------------------------------------+
078200201218      *****************************************************************
078300201218      /EJECT
078400201218      *****************************************************************
078500201218      ** +--------------------------------------+
078600201218      **   Start of I-specs                      
078700201218      **   ================                      
078800201218      ** +--------------------------------------+
078900201218
079000201218      ** Loan transactions index file - Header record
079100201218     I*LTRIX**** NS        1 CH                                                             AR322732
079200201218     I**********                        1    1  RECI                                        AR322732
079300201218     I**********                        2    2  RCDT                                        AR322732
079400201218     I**********                        3    8 0LNRF                                        AR322732
079500201218     I**********                   P    9   11 0NORE                                        Bug03936
079600201218     I**********                   P    9   11 0NORELX                             Bug03936 AR322732
079700201218     I**********                   P   12   14 0FLSZ                                        AR322732
079800201218     I**********                   P   15   17 0RRLC                                        AR322732
079900201218     I**********                   P   18   20 0RRNA                                        AR322732
080000201218     I**********                   P   21   23 0RRLX                                        AR322732
080100201218     I**********                   P   24   26 0RRXP                                        AR322732
080200201218     I**********                   P   27   29 0NLNR                                        AR322732
080300201218     I**********                   P   30   32 0NLAR                                        AR322732
080400201218     I**********                       33   33 0STPI                                        AR322732
080500201218     I**********                   P   38   40 0TNLU                                        AR322732
080600201218      *
080700201218      ** Loan transactions index file - Detail record
080800201218     I*LTRIX**** NS        1 CD    2 CA                                                     AR322732
080900201218     I*********OR         1 CD    2 CL                                                      AR322732
081000201218     I**********                        1    1  RECI                                        AR322732
081100201218     I**********                        2    2  RCDT                                        AR322732
081200201218     I**********                        3    8 0LNRF                                        AR322732
081300201218     I**********                        9   13 0VDAT                                        AR322732
081400201218     I**********                       14   16 0LASN                                        AR322732
081500201218     I**********                       17   17  CHTP                                        AR322732
081600201218     I**********                       18   18  CNRQ                                        AR322732
081700201218     I**********                       19   19  CNPR                                        AR322732
081800201218     I**********                       20   20  REPR                                        AR322732
081900201218     I**********                       21   25 0RRLA                                        AR322732
082000201218     I**********                       26   26  LADI                                        AR322732
082100201218     I**********                       27   27 0PRI1                                        AR322732
082200201218     I**********                       32   34  BRCA                                        AR322732
082300201218     I**********                   P   35   37 0RRNT                                        AR322732
082400201218     I**********                   P   38   40 0TNLU                                        AR322732
082500201218      *
082600201218      ** Loans transactions index file - Catchall
082700201218     I**********NS                                                                          AR322732
082800201218     I**********                        1    1  RECI                                        AR322732
082900201218     ILESTALD0                                                                               BUG9225
083000201218     I              RECI                        RECIXX                                       BUG9225
083100201218     I              TYPE                        TYPEXX                                       BUG9225
083200201218     I              TMST                        TMSTXX                                       BUG9225
083300201218     I              PCRF                        PCRFXX                                       BUG9225
083400201218     I              LNRF                        LNRFXX                                       BUG9225
083500201218     I              VDAT                        VDATXX                                       BUG9225
083600201218     I              LASQ                        LASQXX                                       BUG9225
083700201218     I              CNUM                        CNUMXX                                       BUG9225
083800201218     I              FACL                        FACLXX                                       BUG9225
083900201218     I              FESQ                        FESQXX                                       BUG9225
084000201218     I              SEQ                         SEQXX                                        BUG9225
084100201218     I              RCPC                        RCPCXX                                       BUG9225
084200201218     I              RSTM                        RSTMXX                                       BUG9225
084300201218     I              RIBN                        RIBNXX                                       BUG9225
084400201218     I              RIBA                        RIBAXX                                       BUG9225
084500201218     I              ROBN                        ROBNXX                                       BUG9225
084600201218     I              ROCN                        ROCNXX                                       BUG9225
084700201218     I              ROBR                        ROBRXX                                       BUG9225
084800201218     I              RSCY                        RSCYXX                                       BUG9225
084900201218     I              REXR                        REXRXX                                       BUG9225
085000201218     I              REXI                        REXIXX                                       BUG9225
085100201218     I              PYPC                        PYPCXX                                       BUG9225
085200201218     I              PSTM                        PSTMXX                                       BUG9225
085300201218     I              PIBN                        PIBNXX                                       BUG9225
085400201218     I              PIBA                        PIBAXX                                       BUG9225
085500201218     I              POBN                        POBNXX                                       BUG9225
085600201218     I              POCN                        POCNXX                                       BUG9225
085700201218     I              RCRN                        RCRNXX                                       BUG9225
085800201218     I              RCRA                        RCRAXX                                       BUG9225
085900201218     I              RVNO                        RVNOXX                                       BUG9225
086000201218     I              AWBN                        AWBNXX                                       BUG9225
086100201218     I              AWBA                        AWBAXX                                       BUG9225
086200201218     I              BENN                        BENNXX                                       BUG9225
086300201218     I              BENA                        BENAXX                                       BUG9225
086400201218     I              DTP1                        DTP1XX                                       BUG9225
086500201218     I              DTP2                        DTP2XX                                       BUG9225
086600201218     I              DTP3                        DTP3XX                                       BUG9225
086700201218     I              DTP4                        DTP4XX                                       BUG9225
086800201218     I              DCHG                        DCHGXX                                       BUG9225
086900201218     I              BTB1                        BTB1XX                                       BUG9225
087000201218     I              BTB2                        BTB2XX                                       BUG9225
087100201218     I              BTB3                        BTB3XX                                       BUG9225
087200201218     I              BTB4                        BTB4XX                                       BUG9225
087300201218     I              BTB5                        BTB5XX                                       BUG9225
087400201218     I              BTB6                        BTB6XX                                       BUG9225
087500201218     I              POBR                        POBRXX                                       BUG9225
087600201218     I              CVMR                        CVMRXX                                       BUG9225
087700201218     I              PSCY                        PSCYXX                                       BUG9225
087800201218     I              IC72                        IC72XX                                       BUG9225
087900201218     I              PEXR                        PEXRXX                                       BUG9225
088000201218     I              PEXI                        PEXIXX                                       BUG9225
088100201218     I              PTRF                        PTRFXX                                       BUG9225
088200201218     I              RONS                        RONSXX                                       BUG9225
088300201218     I              PONS                        PONSXX                                       BUG9225
088400201218     I              PYBA                        PYBAXX                                       BUG9225
088500201218     I              PYAM                        PYAMXX                                       BUG9225
088600201218     I              RCBA                        RCBAXX                                       BUG9225
088700201218     I              RCAM                        RCAMXX                                       BUG9225
088800201218     I              CCY                         CCYXX                                        BUG9225
088900201218     I                                                                                       BUG9225
089000201218      ** +--------------------------------------+
089100201218      **   End of I-specs                        
089200201218      **   ==============                        
089300201218      ** +--------------------------------------+
089400201218      *****************************************************************
089500201218      /EJECT
089600201218      *****************************************************************
089700201218      ** +--- Start of Main processing -----------------------------------+
089800201218      **                                                                   
089900201218      **   Initial processing is performed automatically: the *INZSR is    
090000201218      **   executed at program activation.                                 
090100201218      **                                                                   
090200201218      ** +----------------------------------------------------------------+
090300201218
090400201218      ** Check whether user is a web browser user, if so overwrite              CAP084
090500201218     C                   CALL      'SFC000026'                                  CAP084
090600201218     C                   PARM      *BLANKS       USER             10            CAP084
090700201218      *                                                                         CAP084
090800201218     C                   IF        USER <> *BLANKS                              CAP084
090900201218     C                   EVAL      PSUSER = USER                                CAP084
091000201218     C                   ENDIF                                                  CAP084
091100201218
091200201218      ***Processing*init***********************************************                       CLE106
091300201218     C**********         EXSR      SRINIT                                                     CLE106
091400201218      *
091500201218      ** Ensure the amendment has not been updated by another workstation
091600201218      ** - if so, bypass updating and return to calling program.
091700201218     C                   EXSR      CHKOTHUPD
091800201218      ** Processing init                                                                      CLE106
091900201218     C                   EXSR      SRINIT                                                     CLE106
092000201218      *
092100201218     C                   IF        @@RTCD <> *BLANKS
092200201218     C                   GOTO      EXIT
092300201218     C                   ENDIF
092400201218      *
092500201218      ** Insert, amend, authorise or reverse the loan amendment
092600201218     C                   SELECT
092700201218     C     DDACTN        WHENEQ    'I'
092800201218     C                   EXSR      INSERT
092900201218     C     DDACTN        WHENEQ    'A'
093000201218     C     DDACTN        OREQ      'X'
093100201218     C     DDACTN        OREQ      'R'
093200201218     C     DDACTN        OREQ      'Q'                                                        CLE030
093300201218     C     CLE030        ANDEQ     'Y'                                                        CLE030
093400201218     C                   EXSR      AMEND
093500201218     C                   ENDSL
093600201218                                                                                              CRE020
093700201218      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
093800201218                                                                                              CRE020
093900201218     C                   IF        CRE020  = 'Y' AND                                          CRE020
094000201218     C                             WPrtAdv = 'Y'                                              CRE020
094100201218     C                   SELECT                                                               CRE020
094200201218     C                   WHEN      DDACTN = 'X' OR                                            CRE020
094300201218     C                             DDACTN = 'R'                                               CRE020
094400201218     C                   EXSR      SRIdxTrn                                                   CRE020
094500201218     C                   WHEN      DDACTN = 'A'                                               CRE020
094600201218     C                   EXSR      SRIdxAmd                                                   CRE020
094700201218                                                                                              CRE020
094800201218     C                   IF        BPLMAU = 'N'                                               CRE020
094900201218     C                   EXSR      SRIdxTrn                                                   CRE020
095000201218     C                   ENDIF                                                                CRE020
095100201218                                                                                              CRE020
095200201218     C                   WHEN      DDACTN = 'I'                                               CRE020
095300201218     C                   IF        BPLMAU = 'N'                                               CRE020
095400201218     C                   EXSR      SRIdxTrn                                                   CRE020
095500201218     C                   ENDIF                                                                CRE020
095600201218                                                                                              CRE020
095700201218     C                   ENDSL                                                                CRE020
095800201218                                                                                              CRE020
095900201218     C                   ENDIF                                                                CRE020
096000201218      *
096100201218      ***  Exit From Program
096200201218     C     EXIT          TAG
096300201218      *
096400201218     C                   RETURN
096500201218      ****************************************************************
096600201218      /EJECT
096700201218      *****************************************************************
096800201218      * CHKOTHUPD - Check for update by another workstation           *
096900201218      *****************************************************************
097000201218     C     CHKOTHUPD     BEGSR
097100201218      *
097200201218      ** Set up key fields for retrieve
097300201218     C                   MOVE      LALNRF        DDLOAN
097400201218     C                   MOVE      LAAMTP        DDATYP
097500201218      *
097600201218     C                   CALLB     'ZDATE2'
097700201218     C                   PARM      LAVDAT        ZDAYNO            5 0
097800201218     C                   PARM      BJDFIN        DateFmt           1
097900201218     C                   PARM                    ZDATE             6 0
098000201218     C                   PARM                    ZADATE            7
098100201218     C                   MOVEL     ZDATE         DDVDAT
098200201218      *
098300201218     C                   IF        LALASN <> 0
098400201218     C                   MOVE      LALASN        DDSEQN
098500201218     C                   ELSE
098600201218      *
098700201218     C                   MOVE      *Blanks       DDSEQN
098800201218     C                   ENDIF
098900201218      *
099000201218     C                   MOVEL     LoamFilFmt    LoamFilXFmt                                  CRE073
099100201218      ** Call to the retrieve module
099200201218     C                   CALLB     'LELOAMRTV'
099300201218
099400201218      ** Return code
099500201218     C                   PARM      *Blanks       RetCodeIn
099600201218
099700201218      * Mode = '*FRONT' (Front office transaction interface)
099800201218      * Mode = '      ' (Not front office transaction interface)
099900201218     C                   PARM                    ModeofOp          6
100000201218
100100201218      ** Response mode
100200201218     C                   PARM      *Blank        RespMode          1
100300201218
100400201218      ** Action Code
100500201218     C                   PARM                    DDACTN            1
100600201218
100700201218      ** Front Office Transaction ID
100800201218     C                   PARM      LAFRNT        FOTRID           20
100900201218
101000201218      * Loan number / value date / sequence / type
101100201218     C                   PARM                    DDLOAN            6
101200201218     C                   PARM                    DDVDAT            6
101300201218     C                   PARM                    DDSEQN            3
101400201218     C                   PARM                    DDATYP            2
101500201218
101600201218      * Where called from
101700201218     C                   PARM      'UPD'         CallModCod        3
101800201218
101900201218      ** Features
102000201218     C                   PARM                    CEU020
102100201218     C                   PARM                    CLE030                                       CLE030
102200201218
102300201218      * Multi-branching/date format indicators
102400201218     C                   PARM                    BGMBIN
102500201218     C                   PARM                    BJDFIN
102600201218
102700201218      * Current loan amendment in file format, plus loan/facility details
102800201218     C                   PARM                    LoamFilFmt
102900201218     C                   PARM                    LoanDetsA
103000201218     C                   PARM                    LoanDetsB
103100201218     C                   PARM                    FacilityA
103200201218     C                   PARM                    FacilityB
103300201218
103400201218      ** Error Indicators
103500201218     C                   PARM                    LOAM_OK
103600201218
103700201218      ** Error fields/message IDs/message data (arrays) from/to caller
103800201218     C                   PARM                    FldNameArr
103900201218     C                   PARM                    MsgIdArr
104000201218     C                   PARM                    MsgDtaArr
104100201218
104200201218      ** Array index (3P0) from/to caller
104300201218     C                   PARM                    Idx               3 0
104400201218     C                   PARM                    LoamFilXFmt                                  CRE073
104500201218     C                   PARM                    CobMode                                   MD021423E
104600201218      *
104700201218      ** Processing varies according to mode program is running in.
104800201218      ** In interactive mode simply check the timestamps.
104900201218      ** In batch (API input) check return parameters from Retrieve
105000201218      ** module for errors, and send message to system operator.
105100201218      *
105200201218      ** Interactive mode:
105300201218     C                   IF        @TYPE = '1'
105400201218      *
105500201218      **  Error if Timestamp is not the same (record has been changed
105600201218      **  by another workstation)
105700201218     C                   IF        TMST <> LATMST and
105800201218     C                             DDACTN <> 'I'
105900201218     C                   EVAL      @@RTCD = '*RECUPD'
106000201218     C                   ENDIF
106100201218      *
106200201218      ** Batch mode:
106300201218     C                   ELSE
106400201218      *
106500201218     C     DDACTNOK      IFEQ      'N'
106600201218     C     DDLOANOK      OREQ      'N'
106700201218     C     DDVDATOK      OREQ      'N'
106800201218     C     DDSEQNOK      OREQ      'N'
106900201218     C     DDATYPOK      OREQ      'N'
107000201218     C                   EVAL      @@RTCD = '*RECUPD'
107100201218     C                   EVAL      DBerror = 'Update error: ' + FOTRID
107200201218      *
107300201218     C                   CALLB     'ZAMSGTOOPR'
107400201218     C                   PARM                    MsgSndRtn        10
107500201218     C                   PARM                    DBError         132
107600201218     C                   PARM                    DummyMsgID        7
107700201218     C                   PARM                    DummyMsgF
107800201218      *
107900201218     C                   ENDIF
108000201218      *
108100201218     C                   ENDIF
108200201218      *
108300201218     C                   ENDSR
108400201218      ****************************************************************
108500201218      /EJECT
108600201218      ****************************************************************
108700201218      * INSERT - Insert a loan amendment                             *
108800201218      ****************************************************************
108900201218     C     INSERT        BEGSR
109000201218                                                                                             BUG8241
109100201218      ***bypass*generate*Amendment*Seq.*No.*for*Insert*if*CSC024*is                   BUG8241 CSC054
109200201218      ***switched*on*and*running*on*OME*system.                                       BUG8241 CSC054
109300201218      ** bypass generate Amendment Seq. No. for Insert if CSC054 is                           CSC054
109400201218      ** switched on and running on PEA system.                                               CSC054
109500201218                                                                                             BUG8241
109600201218     C**********         IF        MPHAS <> 'A'                                    MD021423 MD025467
109700201218     C                   IF        MPHAS =  'C'                                             MD025467
109800201218     C                             AND DDSEQN <> *BLANKS                                    MD021423
109900201218     C                             AND CLE134 = 'Y'                                         MD021423
110000201218     C                   MOVEL     DDSEQN        LALASN                                     MD021423
110100201218     C                   ELSE                                                               MD021423
110200201218     C*****CSC024        IFNE      'Y'                                                BUG8241 CSC054
110300201218     C*****WOMEInd       ORNE      'Y'                                                BUG8241 CSC054
110400201218     C     CSC054        IFNE      'Y'                                                        CSC054
110500201218     C     WPEAInd       ORNE      'Y'                                                        CSC054
110600201218     C     LALASN        OREQ      *ZERO                                                     BUG8241
110700201218      *
110800201218      ** Find next available sequence no. for insert
110900201218     C                   Z-ADD     0             LALASN
111000201218     C                   MOVE      LALNRF        WKLNR
111100201218     C                   Z-ADD     LAVDAT        WKVDT
111200201218     C                   Z-ADD     0             WKLSN
111300201218     C     KLAKEY        SETLL     LOAMD
111400201218     C                   READ(N)   LOAMD                                  99
111500201218      *
111600201218     C     *IN99         DOWEQ     '0'
111700201218      *
111800201218     C     RECI          IFEQ      'T'
111900201218     C                   LEAVE
112000201218     C                   ENDIF
112100201218      *
112200201218     C     LNRF          IFNE      LALNRF
112300201218     C     VDAT          ORNE      LAVDAT
112400201218     C                   LEAVE
112500201218     C                   ENDIF
112600201218      *
112700201218     C                   Z-ADD     LASN          LALASN
112800201218     C                   READ(N)   LOAMD                                  99
112900201218     C                   ENDDO
113000201218      *
113100201218     C                   ADD       1             LALASN
113200201218                                                                                             BUG8241
113300201218     C                   ENDIF                                                               BUG8241
113400201218     C                   ENDIF                                                              MD021423
113500201218      *
113600201218      ** Obtain last transaction number to be used
113700201218     C                   CALLB     'ZTNLU1'
113800201218     C                   PARM      *BLANKS       ReturnCode
113900201218     C                   PARM                    @Natn             5 0
114000201218      *
114100201218     C                   Z-ADD     @Natn         LATNLU
114200201218      *
114300201218      ** Generate a timestamp for this transaction
114400201218     C                   CALLB     'ZAGENTMSTM'
114500201218     C                   PARM                    TimeStamp
114600201218      *
114700201218     C                   MOVE      TimeStamp     LATMST
114800201218      *
114900201218      ** Verify if its a PI for PDCL and get loan records.                                  MD023787
115000201218      *                                                                                     MD023787
115100201218     C                   MOVE      *BLANKS       PDCLI             1                        MD023787
115200201218     C                   IF        CobMode <> 'Y'  and                                      MD023787
115300201218     C                             LAAMTP = 'PI' and                                        MD023787
115400201218     C                             (%SUBST(LTYPA:1:1) = 'X' or                              MD023787
115500201218     C                              %SUBST(LTYPA:1:1) =  'Y' or                             MD023787
115600201218     C                              %SUBST(LTYPA:1:1) =  'Z')                               MD023787
115700201218      *                                                                                     MD050018
115800201218      ** When PDCLPAMVPIAC is 'Y', use loan pay details                                     MD050018
115900201218     C                   IF        W#FRNT = 'LE000473' or                                   MD050018
116000201218     C                             WkPIAC = 'N'                                             MD050018
116100201218     C                   MOVE      LALNRF        WKLNR                                      MD023787
116200201218     C                   MOVE      'A'           WRCDT                                      MD023787
116300201218     C     KLKEY         CHAIN     CLOAN                              99                    MD023787
116400201218     C     LO_AUTO       IFEQ      'C'                                                      MD023787
116500201218     C     *IN99         ANDEQ     '0'                                                      MD023787
116600201218     C                   EXSR      GETLON                                                   MD023787
116700201218     C                   ENDIF                                                              MD023787
116800201218      *                                                                                     MD050018
116900201218     C                   ELSE                                                               MD050018
117000201218     C                   EVAL      PDCLI = 'P'                                              MD050018
117100201218     C                   ENDIF                                                              MD050018
117200201218     C                   ENDIF                                                              MD023787
117300201218      *                                                                                     MD023787
117400201218     C     WSOLD         IFEQ      'Y'                                                       BUG3054
117500201218     C     PDCLI         OREQ      'Y'                                                      MD023787
117600201218     C                   MOVE      LARONS        LAOSAC                                      BUG3054
117700201218     C                   ELSE                                                                BUG3054
117800201218     C                   MOVE      LAPONS        LAOSAC                                      BUG3054
117900201218     C                   ENDIF                                                               BUG3054
118000201218                                                                                             BUG3054
118100201218      ** Set up and write the new record to LOAMS
118200201218     C**********         MOVE      ValidLoam     LoamFilFmt                                   CRE073
118300201218     C                   MOVEL     ValidLoam     LoamFilFmt                                   CRE073
118400201218      *                                                                                      BUG3760
118500201218      ** Execute SRWTCH if compliance watch is installed, watch list checking                BUG3760
118600201218      ** is applied and in the main system.                                                  BUG3760
118700201218      *                                                                                      BUG3760
118800201218     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y' AND                         BUG3760
118900201218     C                             LAAMTP = 'PI'                                             BUG3760
119000201218      *                                                                                      BUG3760
119100201218     C                   IF        LARONS <> *BLANKS OR                                      BUG3760
119200201218     C                             LARIBN <> *BLANKS OR                                      BUG3760
119300201218     C**********                   LAROBN <> *ZERO   OR                               BUG3760 CSD027
119400201218     C**********                   LAROCN <> *ZERO   OR                               BUG3760 CSD027
119500201218     C                             LAROBN <> *BLANKS OR                                       CSD027
119600201218     C                             LAROCN <> *BLANKS OR                                       CSD027
119700201218     C                             LAPONS <> *BLANKS OR                                      BUG3760
119800201218     C                             LAPIBN <> *BLANKS OR                                      BUG3760
119900201218     C**********                   LAPOBN <> *ZERO   OR                               BUG3760 CSD027
120000201218     C**********                   LAPOCN <> *ZERO   OR                               BUG3760 CSD027
120100201218     C                             LAPOBN <> *BLANKS OR                                       CSD027
120200201218     C                             LAPOCN <> *BLANKS OR                                       CSD027
120300201218     C                             LARCRN <> *BLANKS OR                                      BUG3760
120400201218     C                             LARVNO <> *BLANKS OR                                      BUG3760
120500201218     C                             LAAWBN <> *BLANKS OR                                      BUG3760
120600201218     C                             LABENN <> *BLANKS OR                                      BUG3760
120700201218     C                             LADTP1 <> *BLANKS OR                                      BUG3760
120800201218     C                             LADTP2 <> *BLANKS OR                                      BUG3760
120900201218     C                             LADTP3 <> *BLANKS OR                                      BUG3760
121000201218     C                             LADTP4 <> *BLANKS                                         BUG3760
121100201218     C                   MOVEL     'Y'           WDTPC                                       BUG3760
121200201218     C                   MOVEL     LARONS        WLF(1)                                      BUG3760
121300201218     C                   MOVEL     LARIBN        WLF(2)                                      BUG3760
121400201218     C                   MOVEL     LAROBN        WLF(3)                                      BUG3760
121500201218     C                   MOVEL     LAROCN        WLF(4)                                      BUG3760
121600201218     C                   MOVEL     LAPONS        WLF(5)                                      BUG3760
121700201218     C                   MOVEL     LAPIBN        WLF(6)                                      BUG3760
121800201218     C                   MOVEL     LAPOBN        WLF(7)                                      BUG3760
121900201218     C                   MOVEL     LAPOCN        WLF(8)                                      BUG3760
122000201218     C                   MOVEL     LARCRN        WLF(9)                                      BUG3760
122100201218     C                   MOVEL     LARVNO        WLF(10)                                     BUG3760
122200201218     C                   MOVEL     LAAWBN        WLF(11)                                     BUG3760
122300201218     C                   MOVEL     LABENN        WLF(12)                                     BUG3760
122400201218      *                                                                                      BUG3760
122500201218     C                   IF        CSC011 = 'N' OR (CSC011 = 'Y'                             BUG3760
122600201218     C                             AND LIBR = S1MAIN)                                        BUG3760
122700201218      *                                                                                      BUG3760
122800201218     C                   EXSR      SrWTCH                                                    BUG3760
122900201218      *                                                                                      BUG3760
123000201218     C                   ENDIF                                                               BUG3760
123100201218      *                                                                                      BUG3760
123200201218     C                   ENDIF                                                               BUG3760
123300201218     C                   ENDIF                                                               BUG3760
123400201218                                                                                              CAS011
123500201218                                                                                              CAP086
123600201218      ** Automatic Authorisation flag                                                         CAP086
123700201218                                                                                              CAP086
123800201218     C                   IF        LAAUTH = 'Y'                                               CAP086
123900201218     C                   EVAL      AUTH = LAAUTH                                              CAP086
124000201218     C                   EVAL      ASTS = 'A'                                                 CAP086
124100201218     C                   ENDIF                                                                CAP086
124200201218                                                                                              CAP086
124300201218      ** Only process EIR cost accounting if loan's value date is same                        CAS011
124400201218      ** as or after the non-linear amortisation cut-off date                                 CAS011
124500201218                                                                                              CAS011
124600201218     C                   IF        CAS009 = 'Y'                                               CAS011
124700201218     C                             AND VDAT >= FSNLAC                                         CAS011
124800201218     C                             OR CAS016 = 'Y'                                            CAS019
124900201218                                                                                              CAS011
125000201218     C                   EVAL      WADJP = *BLANKS                                            CAS011
125100201218     C                   EVAL      WDELR = *BLANKS                                            CAS011
125200201218                                                                                              CAS011
125300201218      ** Need to recalculate the EIR of a loan on amendment.                                  CAS011
125400201218                                                                                              CAS011
125500201218     C                   IF        DDATYP = 'PF' OR DDATYP = 'PT' OR                          CAS011
125600201218     C                             DDATYP = 'PI' OR DDATYP = 'SA'                             CAS011
125700201218     C                   EVAL      WTRAN = LNRF                                               CAS011
125800201218     C                   EVAL      WVALD = VDAT                                               CAS011
125900201218     C                   IF        CAS016 = 'Y'                                               CAS019
126000201218     C                   EVAL      WADJP = 'Y'                                                CAS019
126100201218     C                   ENDIF                                                                CAS019
126200201218     C                   EXSR      SEIRI1                                                     CAS011
126300201218     C                   ENDIF                                                                CAS011
126400201218     C                   IF        DDATYP = 'SC' OR DDATYP = 'BC'                             CAS011
126500201218     C                   EVAL      WTRAN = LNRF                                               CAS011
126600201218     C                   EVAL      WVALD = VDAT                                               CAS011
126700201218     C                   EVAL      WADJP = 'Y'                                                CAS011
126800201218     C                   EXSR      SEIRI1                                                     CAS011
126900201218     C                   ENDIF                                                                CAS011
127000201218                                                                                              CAS011
127100201218     C                   ENDIF                                                                CAS011
127200201218                                                                                             BUG8366
127300201218     C                   MOVE      *BLANKS       Z#BSTS                                      BUG8366
127400201218     C                   MOVEL     LoamFilFmt    Z#ASTS                                      BUG8366
127500201218      *
127600201218     C                   IF        W#FRNT = 'LE000473'                                      MD020390
127700201218     C                   EVAL      AUTO = 'C'                                               MD020390
127800201218     C                   EVAL      MTPD = 'N'                                               MD020390
127900201218     C                   ENDIF                                                              MD020390
128000201218      *                                                                                     MD020390
128100201218     C                   WRITE     LOAMSDKF
128200201218      *                                                                                    AR1021983
128300201218      ** Write to Loan amendments update file                                              AR1021983
128400201218      *                                                                                    AR1021983
128500201218     C                   IF        CLE134 = 'Y' AND                                        AR1021983
128600201218     C                             (W#FRNT = 'LE000473' OR                                 AR1021983
128700201218     C                             W#FRNT = *BLANKS)                                       AR1021983
128800201218     C                   WRITE     LOMKSDKF                                                AR1021983
128900201218      *                                                                                       CLE134
129000201218     C*****LAFRNT        CHAIN     LEMQLGL0                                         CLE134 MD022807I
129100201218     C**********         IF        %FOUND(LEMQLGL0)                                 CLE134 MD022807I
129200201218     C**********         SELECT                                                     CLE134 MD022807I
129300201218      *                                                                                       CLE134
129400201218      ** If current value of transaction status is "S" set this to "P"                        CLE134
129500201218     C**********         WHEN      LGSTAT = 'S'                                     CLE134 MD022807I
129600201218     C**********         EVAL      LGSTAT = 'P'                                     CLE134 MD022807I
129700201218      *                                                                                       CLE134
129800201218      ** If current value of transaction status is "E" set this to "R"                        CLE134
129900201218     C**********         WHEN      LGSTAT = 'E'                                     CLE134 MD022807I
130000201218     C**********         EVAL      LGSTAT = 'R'                                     CLE134 MD022807I
130100201218     C**********         ENDSL                                                      CLE134 MD022807I
130200201218      *                                                                                    AR1085742
130300201218     C**********         CALLB     'ZAGENTMSTM'                                  AR1085742 MD022807I
130400201218     C**********         PARM                    TimeStamp                       AR1085742 MD022807I
130500201218      *                                                                                    AR1085742
130600201218      ** Timestamp                                                                         AR1085742
130700201218      *                                                                                    AR1085742
130800201218     C**********         EVAL      LGPROC = TimeStamp                            AR1085742 MD022807I
130900201218      *                                                                                    AR1085742
131000201218     C**********         UPDATE    LEMQLGPF                                         CLE134 MD022807I
131100201218     C**********         ENDIF                                                      CLE134 MD022807I
131200201218     C                   ENDIF                                                             AR1021983
131300201218      *                                                                                     MD050018
131400201218      ** Update the PDP link files LEPDUEPD and LEPDUFPD                                    MD050018
131500201218      *                                                                                     MD050018
131600201218     C                   IF        CLE134 = 'Y' AND CobMode <> 'Y' AND                      MD050018
131700201218     C                             W#FRNT <> 'LE000473' AND WkPIAC = 'Y' AND                MD050018
131800201218     C                             LAAMTP = 'PI' AND                                        MD050018
131900201218     C                             (%SUBST(LTYPA:1:1) = 'X' OR                              MD050018
132000201218     C                              %SUBST(LTYPA:1:1) = 'Y' OR                              MD050018
132100201218     C                              %SUBST(LTYPA:1:1) =  'Z')                               MD050018
132200201218     C                   EXSR      SrUpdPDCL                                                MD050018
132300201218     C                   ENDIF                                                              MD050018
132400201218      *
132500201218      ** Update the other files
132600201218     C                   EXSR      UpdOthFil
132700201218      *
132800201218     C                   ENDSR
132900201218      ****************************************************************
133000201218      /EJECT
133100201218      ****************************************************************
133200201218      * AMEND  - Amend a loan amendment                              *
133300201218      ****************************************************************
133400201218     C     AMEND         BEGSR
133500201218      *
133600201218      ** Access the record to be amended
133700201218     C                   MOVE      LALNRF        WKLNR
133800201218     C                   MOVE      LAVDAT        WKVDT
133900201218     C                   MOVE      LALASN        WKLSN
134000201218     C     KLAKEY        CHAIN     LOAMD                              99
134100201218      *
134200201218     C     *IN99         IFEQ      *ON
134300201218     C**********         EVAL      DBKEY = %Char(WKLNR) + %Char(WKVDT) +                      CLE148
134400201218     C                   EVAL      DBKEY = WKLNR + %Char(WKVDT) +                             CLE148
134500201218     C                                     %Char(WKLSN)                         ************
134600201218     C                   MOVEL(P)  'LOAMS'       DBFILE                         * DBERR 11 *
134700201218     C                   Z-ADD     11            DBASE                          ************
134800201218     C                   EXSR      *PSSR
134900201218     C                   ENDIF
135000201218                                                                                             BUG8366
135100201218     C                   MOVEL     LoamFilFmt    Z#BSTS                                      BUG8366
135200201218      *
135300201218      ** Save the current principal amount of the record
135400201218     C                   Z-ADD     PRAM          WPRAM            13 0
135500201218     C                   Z-ADD     PRAM          OPRAM                                      MD047554
135600201218      *
135700201218      ** Update on shadow files should only be done if not a Risk loan
135800201218     C     PTYP          IFNE      70
135900201218     C     PTYP          ANDNE     71
136000201218     C     PTYP          ANDNE     72
136100201218      *
136200201218     C     LAAMTP        IFNE      'PT'
136300201218     C     LAAMTP        ANDNE     'PF'
136400201218     C                   EXSR      SRSHAD
136500201218     C                   MOVE      Z#ADTA        Z#BDT1
136600201218     C                   MOVE      Z#ADTB        Z#BDT2
136700201218      *
136800201218     C     CLE055        Ifeq      'Y'                                                        243415
136900201218     C     BPLMAU        andeq     'Y'                                                        243415
137000201218     C     LAAUTH        andne     'Y'                                                        243415
137100201218     C     LAAMTP        andeq     'PI'                                                       243415
137200201218     C                   Clear                   Z#ZADTB                                      243415
137300201218     C                   Eval      Z#ZADTB   =    Z#BDT1                                      243415
137400201218      *                                                                                       243415
137500201218     C                   If        PONS = OTOURS and DDACTN = 'A' and                         243415
137600201218     C                             ASTS <> 'A' or PONS = OTOURS and                           243415
137700201218     C                             DDACTN = 'R' and ASTS <> 'A'                               243415
137800201218     C                   Clear                   ZB_Type                                      243415
137900201218     C                   Clear                   ZB_Otours                                    243415
138000201218     C                   Endif                                                                243415
138100201218     C                   If        DDACTN = 'X' or DDACTN = 'Q' and                           243415
138200201218     C                             CLE030 = 'Y'                                               243415
138300201218     C                   Clear                   ZB_Type                                      243415
138400201218     C                   Clear                   ZB_Otours                                    243415
138500201218     C                   Endif                                                                243415
138600201218     C                   Eval      Z#BDT1    =    Z#ZADTB                                     243415
138700201218      *                                                                                       243415
138800201218     C                   Endif                                                                243415
138900201218      *                                                                                       243415
139000201218     C     CEU004        IFEQ      'Y'
139100201218     C     CLE031        OREQ      'Y'                                                        CLE031
139200201218     C                   MOVE      Z#ADTE        Z#BDT5
139300201218     C                   ENDIF
139400201218                                                                                              CLE134
139500201218     C                   IF        CLE134      = 'Y'                                          CLE134
139600201218     C                   EVAL      Z#BDT8      = Z#ADTH                                       CLE134
139700201218     C                   ENDIF                                                                CLE134
139800201218      *
139900201218     C                   ENDIF
140000201218      *
140100201218     C                   ENDIF
140200201218      *
140300201218      ** Obtain last transaction number to be used
140400201218     C                   CALLB     'ZTNLU1'
140500201218     C                   PARM      *BLANKS       ReturnCode
140600201218     C                   PARM                    @Natn             5 0
140700201218      *
140800201218     C                   Z-ADD     @Natn         LATNLU
140900201218      *
141000201218      ** Generate a timestamp for this transaction
141100201218     C                   CALLB     'ZAGENTMSTM'
141200201218     C                   PARM                    TimeStamp
141300201218      *
141400201218     C                   MOVE      TimeStamp     LATMST
141500201218      *                                                                                     MD023787
141600201218      ** Verify if its a PI for PDCL and get loan records.                                  MD023787
141700201218      *                                                                                     MD023787
141800201218     C                   MOVE      *BLANKS       PDCLI             1                        MD023787
141900201218     C                   IF        CobMode <> 'Y'  and                                      MD023787
142000201218     C                             LAAMTP = 'PI' and                                        MD023787
142100201218     C                             (%SUBST(LTYPA:1:1) = 'X' or                              MD023787
142200201218     C                              %SUBST(LTYPA:1:1) =  'Y' or                             MD023787
142300201218     C                              %SUBST(LTYPA:1:1) =  'Z')                               MD023787
142400201218      *                                                                                     MD050018
142500201218      ** When PDCLPAMVPIAC is 'Y', use loan pay details                                     MD050018
142600201218     C                   IF        W#FRNT = 'LE000473' or                                   MD050018
142700201218     C                             WkPIAC = 'N'                                             MD050018
142800201218     C                   MOVE      LALNRF        WKLNR                                      MD023787
142900201218     C                   MOVE      'A'           WRCDT                                      MD023787
143000201218     C     KLKEY         CHAIN     CLOAN                              99                    MD023787
143100201218     C     LO_AUTO       IFEQ      'C'                                                      MD023787
143200201218     C     *IN99         ANDEQ     '0'                                                      MD023787
143300201218     C                   EXSR      GETLON                                                   MD023787
143400201218     C                   ENDIF                                                              MD023787
143500201218      *                                                                                     MD050018
143600201218     C                   ELSE                                                               MD050018
143700201218     C                   EVAL      PDCLI = 'P'                                              MD050018
143800201218     C                   ENDIF                                                              MD050018
143900201218     C                   ENDIF                                                              MD023787
144000201218      *
144100201218     C     WSOLD         IFEQ      'Y'                                                       BUG3054
144200201218     C     PDCLI         OREQ      'Y'                                                      MD023787
144300201218     C**********         MOVE      RONS          LAOSAC                             BUG3054 AR848765
144400201218     C                   MOVE      LARONS        LAOSAC                                     AR848765
144500201218     C                   ELSE                                                                BUG3054
144600201218     C**********         MOVE      PONS          LAOSAC                             BUG3054 AR848765
144700201218     C                   MOVE      LAPONS        LAOSAC                                     AR848765
144800201218     C                   ENDIF                                                               BUG3054
144900201218                                                                                             BUG3054
145000201218      ** Check if before and after image of the record of LOAMSDK is different               BUG3760
145100201218      *                                                                                      BUG3760
145200201218     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                             BUG3760
145300201218      *                                                                                      BUG3760
145400201218     C                   EVAL      WDIFF = 'N'                                               BUG3760
145500201218     C                   EVAL      WDTPC = 'N'                                               BUG3760
145600201218     C                   MOVE      ROBN          WROBN                                       BUG3760
145700201218     C                   MOVE      ROCN          WROCN                                       BUG3760
145800201218     C                   MOVE      POBN          WPOBN                                       BUG3760
145900201218     C                   MOVE      POCN          WPOCN                                       BUG3760
146000201218      *                                                                                      BUG3760
146100201218     C                   MOVE      *BLANKS       WLF                                         BUG3760
146200201218      *                                                                                      BUG3760
146300201218     C                   IF        RONS <> LARONS                                            BUG3760
146400201218     C                   MOVEL     LARONS        WLF(1)                                      BUG3760
146500201218     C                   MOVE      'Y'           WDIFF                                       BUG3760
146600201218     C                   ENDIF                                                               BUG3760
146700201218      *                                                                                      BUG3760
146800201218     C                   IF        RIBN <> LARIBN                                            BUG3760
146900201218     C                   MOVEL     LARIBN        WLF(2)                                      BUG3760
147000201218     C                   MOVE      'Y'           WDIFF                                       BUG3760
147100201218     C                   ENDIF                                                               BUG3760
147200201218      *                                                                                      BUG3760
147300201218     C                   IF        WROBN <> LAROBN                                           BUG3760
147400201218     C                   MOVEL     LAROBN        WLF(3)                                      BUG3760
147500201218     C                   MOVE      'Y'           WDIFF                                       BUG3760
147600201218     C                   ENDIF                                                               BUG3760
147700201218      *                                                                                      BUG3760
147800201218     C                   IF        WROCN <> LAROCN                                           BUG3760
147900201218     C                   MOVEL     LAROCN        WLF(4)                                      BUG3760
148000201218     C                   MOVE      'Y'           WDIFF                                       BUG3760
148100201218     C                   ENDIF                                                               BUG3760
148200201218      *                                                                                      BUG3760
148300201218     C                   IF        PONS <> LAPONS                                            BUG3760
148400201218     C                   MOVEL     LAPONS        WLF(5)                                      BUG3760
148500201218     C                   MOVE      'Y'           WDIFF                                       BUG3760
148600201218     C                   ENDIF                                                               BUG3760
148700201218      *                                                                                      BUG3760
148800201218     C                   IF        PIBN <> LAPIBN                                            BUG3760
148900201218     C                   MOVEL     LAPIBN        WLF(6)                                      BUG3760
149000201218     C                   MOVE      'Y'           WDIFF                                       BUG3760
149100201218     C                   ENDIF                                                               BUG3760
149200201218      *                                                                                      BUG3760
149300201218     C                   IF        WPOBN <> LAPOBN                                           BUG3760
149400201218     C                   MOVEL     LAPOBN        WLF(7)                                      BUG3760
149500201218     C                   MOVE      'Y'           WDIFF                                       BUG3760
149600201218     C                   ENDIF                                                               BUG3760
149700201218      *                                                                                      BUG3760
149800201218     C                   IF        WPOCN <> LAPOCN                                           BUG3760
149900201218     C                   MOVEL     LAPOCN        WLF(8)                                      BUG3760
150000201218     C                   MOVE      'Y'           WDIFF                                       BUG3760
150100201218     C                   ENDIF                                                               BUG3760
150200201218      *                                                                                      BUG3760
150300201218     C                   IF        RCRN <> LARCRN                                            BUG3760
150400201218     C                   MOVEL     LARCRN        WLF(9)                                      BUG3760
150500201218     C                   MOVE      'Y'           WDIFF                                       BUG3760
150600201218     C                   ENDIF                                                               BUG3760
150700201218      *                                                                                      BUG3760
150800201218     C                   IF        RVNO <> LARVNO                                            BUG3760
150900201218     C                   MOVEL     LARVNO        WLF(10)                                     BUG3760
151000201218     C                   MOVE      'Y'           WDIFF                                       BUG3760
151100201218     C                   ENDIF                                                               BUG3760
151200201218      *                                                                                      BUG3760
151300201218     C                   IF        AWBN <> LAAWBN                                            BUG3760
151400201218     C                   MOVEL     LAAWBN        WLF(11)                                     BUG3760
151500201218     C                   MOVE      'Y'           WDIFF                                       BUG3760
151600201218     C                   ENDIF                                                               BUG3760
151700201218      *                                                                                      BUG3760
151800201218     C                   IF        BENN <> LABENN                                            BUG3760
151900201218     C                   MOVEL     LABENN        WLF(12)                                     BUG3760
152000201218     C                   MOVE      'Y'           WDIFF                                       BUG3760
152100201218     C                   ENDIF                                                               BUG3760
152200201218      *                                                                                      BUG3760
152300201218     C                   IF        DTP1 <> LADTP1 OR                                         BUG3760
152400201218     C                             DTP2 <> LADTP2 OR                                         BUG3760
152500201218     C                             DTP3 <> LADTP3 OR                                         BUG3760
152600201218     C                             DTP4 <> LADTP4                                            BUG3760
152700201218     C                   MOVE      'Y'           WDTPC                                       BUG3760
152800201218     C                   MOVE      'Y'           WDIFF                                       BUG3760
152900201218     C                   ENDIF                                                               BUG3760
153000201218     C                   ENDIF                                                               BUG3760
153100201218      *                                                                                      BUG3760
153200201218      ** Set up and update the record of LOAMS
153300201218     C**********         MOVE      ValidLoam     LoamFilFmt                                   CRE073
153400201218     C                   MOVEL     ValidLoam     LoamFilFmt                                   CRE073
153500201218      *                                                                                      BUG3760
153600201218      ** Execute SRWTCH if compliance watch is installed, watch list checking                BUG3760
153700201218      ** is applied and in the main system.                                                  BUG3760
153800201218      *                                                                                      BUG3760
153900201218     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y' AND                         BUG3760
154000201218     C                             AMTP = 'PI' AND DDACTN = 'A'                              BUG3760
154100201218      *                                                                                      BUG3760
154200201218     C                   IF        CSC011 = 'Y' AND S1MAIN = LIBR OR                         BUG3760
154300201218     C                             CSC011 = 'N'                                              BUG3760
154400201218      *                                                                                      BUG3760
154500201218     C                   MOVEL     *BLANKS       WFuncType                                   BUG3760
154600201218     C                   MOVEL     *BLANKS       WIdntifier                                  BUG3760
154700201218     C                   MOVEL     *BLANKS       WBranch                                     BUG3760
154800201218     C                   MOVEL     *BLANKS       WLNRF                                       BUG3760
154900201218     C                   MOVEL     *BLANKS       WKVDAT                                      BUG3760
155000201218     C                   MOVEL     *BLANKS       WLASN                                       BUG3760
155100201218      *                                                                                      BUG3760
155200201218     C                   MOVEL     'LOAMSDK'     WFuncType                                   BUG3760
155300201218     C                   MOVE      LNRF          WLNRF                                       BUG3760
155400201218     C                   MOVE      VDAT          WKVDAT                                      BUG3760
155500201218     C                   MOVE      LASN          WLASN                                       BUG3760
155600201218     C                   EVAL      WIdntifier = WLNRF + WKVDAT + WLASN                       BUG3760
155700201218     C                   EVAL      WBranch = BRCA                                            BUG3760
155800201218      *                                                                                      BUG3760
155900201218     C     KCwFld        CHAIN     SDCWHTL1                                                  BUG3760
156000201218      *                                                                                      BUG3760
156100201218     C                   IF        %FOUND(SDCWHTL1) AND W3UNCF = 'Y'                         BUG3760
156200201218     C                   MOVEL     RONS          WLF(1)                                      BUG3760
156300201218     C                   MOVEL     RIBN          WLF(2)                                      BUG3760
156400201218     C                   MOVEL     ROBN          WLF(3)                                      BUG3760
156500201218     C                   MOVEL     ROCN          WLF(4)                                      BUG3760
156600201218     C                   MOVEL     PONS          WLF(5)                                      BUG3760
156700201218     C                   MOVEL     PIBN          WLF(6)                                      BUG3760
156800201218     C                   MOVEL     POBN          WLF(7)                                      BUG3760
156900201218     C                   MOVEL     POCN          WLF(8)                                      BUG3760
157000201218     C                   MOVEL     RCRN          WLF(9)                                      BUG3760
157100201218     C                   MOVEL     RVNO          WLF(10)                                     BUG3760
157200201218     C                   MOVEL     AWBN          WLF(11)                                     BUG3760
157300201218     C                   MOVEL     BENN          WLF(12)                                     BUG3760
157400201218     C                   EXSR      SrWTCH                                                    BUG3760
157500201218      *                                                                                      BUG3760
157600201218     C                   ELSE                                                                BUG3760
157700201218      *                                                                                      BUG3760
157800201218     C                   IF        WDIFF = 'Y'                                               BUG3760
157900201218     C                   EXSR      SrWTCH                                                    BUG3760
158000201218     C                   ENDIF                                                               BUG3760
158100201218      *                                                                                      BUG3760
158200201218     C                   ENDIF                                                               BUG3760
158300201218      *                                                                                      BUG3760
158400201218     C                   ENDIF                                                               BUG3760
158500201218     C                   ENDIF                                                               BUG3760
158600201218                                                                                              CAS011
158700201218                                                                                              CAP086
158800201218      ** Automatic Authorisation flag                                                         CAP086
158900201218                                                                                              CAP086
159000201218     C                   IF        LAAUTH = 'Y'                                               CAP086
159100201218     C                   EVAL      AUTH = LAAUTH                                              CAP086
159200201218     C                   EVAL      ASTS = 'A'                                                 CAP086
159300201218     C                   ENDIF                                                                CAP086
159400201218                                                                                              CAP086
159500201218      ** Only process EIR cost accounting if loan's value date is same                        CAS011
159600201218      ** as or after the non-linear amortisation cut-off date                                 CAS011
159700201218                                                                                              CAS011
159800201218     C                   IF        CAS009 = 'Y'                                               CAS011
159900201218     C                             AND VDAT >= FSNLAC                                         CAS011
160000201218     C                             OR CAS016 = 'Y'                                            CAS019
160100201218                                                                                              CAS011
160200201218     C                   EVAL      WADJP = *BLANKS                                            CAS011
160300201218     C                   EVAL      WDELR = *BLANKS                                            CAS011
160400201218                                                                                              CAS011
160500201218      ** Need to recalculate the EIR of a loan on amendment.                                  CAS011
160600201218                                                                                              CAS011
160700201218     C                   IF        DDATYP = 'PF' OR DDATYP = 'PT' OR                          CAS011
160800201218     C                             DDATYP = 'PI' OR DDATYP = 'SA'                             CAS011
160900201218     C                   EVAL      WTRAN = LNRF                                               CAS011
161000201218     C                   EVAL      WVALD = VDAT                                               CAS011
161100201218     C                   IF        CAS016 = 'Y'                                               CAS019
161200201218     C                   EVAL      WADJP = 'Y'                                                CAS019
161300201218     C                   ENDIF                                                                CAS019
161400201218     C                   EXSR      SEIRI1                                                     CAS011
161500201218     C                   ENDIF                                                                CAS011
161600201218     C                   IF        DDATYP = 'SC' OR DDATYP = 'BC'                             CAS011
161700201218     C                   EVAL      WTRAN = LNRF                                               CAS011
161800201218     C                   EVAL      WVALD = VDAT                                               CAS011
161900201218     C                   EVAL      WADJP = 'Y'                                                CAS011
162000201218     C                   EXSR      SEIRI1                                                     CAS011
162100201218     C                   ENDIF                                                                CAS011
162200201218                                                                                              CAS011
162300201218     C                   ENDIF                                                                CAS011
162400201218      *
162500201218     C                   UPDATE    LOAMSDKF
162600201218                                                                                              CLE055
162700201218      **If*authorization required clear settlement details.                            CLE055 243415
162800201218     C*********          If        CLE055 = 'Y'  and  BPLMAU = 'Y'                     CLE055 243415
162900201218     C*********                                  and  ASTS  <> 'A'                     CLE055 243415
163000201218     **********                                                                        CLE055 243415
163100201218     C*********          Clear                   Z#ZADTA                               CLE055 243415
163200201218     C*********          Clear                   Z#ZADTB                               CLE055 243415
163300201218      *********                                                                        CLE055 243415
163400201218     C*********          Eval      Z#ZADTB   =    Z#BDT1                               CLE055 243415
163500201218      *********                                                                        CLE055 243415
163600201218     C*********          Endif                                                         CLE055 243415
163700201218                                                                                       CLE055 243415
163800201218      *                                                                                     BUG26668
163900201218     C                   MOVEL     LoamFilFmt    Z#ASTS                                     BUG26668
164000201218      *                                                                                     MD050018
164100201218      ** Update the PDP link files LEPDUEPD and LEPDUFPD                                    MD050018
164200201218      *                                                                                     MD050018
164300201218     C                   IF        CLE134 = 'Y' AND CobMode <> 'Y' AND                      MD050018
164400201218     C                             W#FRNT <> 'LE000473' AND WkPIAC = 'Y' AND                MD050018
164500201218     C                             LAAMTP = 'PI' AND                                        MD050018
164600201218     C                             (%SUBST(LTYPA:1:1) = 'X' OR                              MD050018
164700201218     C                              %SUBST(LTYPA:1:1) = 'Y' OR                              MD050018
164800201218     C                              %SUBST(LTYPA:1:1) =  'Z')                               MD050018
164900201218     C                   EXSR      SrUpdPDCL                                                MD050018
165000201218     C                   ENDIF                                                              MD050018
165100201218      *
165200201218      ** Update the other files
165300201218     C                   EXSR      UpdOthFil
165400201218      *
165500201218     C                   ENDSR
165600201218      ****************************************************************
165700201218      /EJECT
165800201218      ****************************************************************
165900201218      * UpdOthFil - Update all the other files                       *
166000201218      ****************************************************************
166100201218     C     UpdOthFil     BEGSR
166200201218      *                                                                                       CLE030
166300201218     C     PCRF          CHAIN     LESTALLA                           99                     BUG9225
166400201218     C     *IN99         DOWEQ     *OFF                                                      BUG9225
166500201218     C                   Z-ADD     LASN          LASQXX                                      BUG9225
166600201218     C                   UPDATE    LESTALD0                                                  BUG9225
166700201218     C     PCRF          READE     LESTALLA                               99                 BUG9225
166800201218     C                   ENDDO                                                               BUG9225
166900201218      *                                                                                      BUG9225
167000201218      ** If Action is release, 'Q' and CLE030 is switched on                                  CLE030
167100201218      *                                                                                       CLE030
167200201218     C     DDACTN        IFEQ      'Q'                                                        CLE030
167300201218     C     CLE030        ANDEQ     'Y'                                                        CLE030
167400201218      *                                                                                       CLE030
167500201218      ** And move fields to and update the released items file - LERELEPD                     CLE030
167600201218      *                                                                                       CLE030
167700201218     C                   MOVE      RECI          RERECI                                       CLE030
167800201218     C                   MOVE      LNRF          RELNRF                                       CLE030
167900201218     C                   MOVE      PTYP          REPTYP                                       CLE030
168000201218     C                   MOVE      CNUM          RECNUM                                       CLE030
168100201218     C                   MOVE      BRCA          REBRCA                                       CLE030
168200201218     C                   MOVE      LTYP          RELTYP                                       CLE030
168300201218     C                   MOVE      SUTP          RESUTP                                       CLE030
168400201218     C                   MOVE      CLAS          RECLAS                                       CLE042
168500201218     C                   MOVE      AMTP          REAMTP                                       CLE030
168600201218     C                   MOVE      VDAT          REVDAT                                       CLE030
168700201218     C                   MOVE      FCUS          REFCUS                                       CLE030
168800201218     C                   MOVE      FTYP          REFTYP                                       CLE030
168900201218     C                   MOVE      FSEQ          REFSEQ                                       CLE030
169000201218     C                   MOVE      CCY           RECCY                                        CLE030
169100201218     C                   MOVE      PRAM          RECPAM                                       CLE030
169200201218     C                   MOVE      XUSR          REXUSR                                       CLE030
169300201218     C                   MOVE      PSUser        RERUSR                                       CLE030
169400201218     C                   MOVE      WRNDAY        RELCD                                        CLE030
169500201218     C                   MOVE      LATMST        WRLTMST                                      CLE030
169600201218     C                   MOVE      *BLANKS       WTIME             6                          CLE030
169700201218     C                   EVAL      WTIME  = WREHRS + WREMIN + WRESEC                          CLE030
169800201218     C                   MOVE      WTIME         RETIME                                       CLE030
169900201218      *                                                                                       CLE030
170000201218     C                   WRITE     LERELED0                                                   CLE030
170100201218      *                                                                                       CLE030
170200201218     C                   ENDIF                                                                CLE030
170300201218      *
170400201218      ** Pass parameter fields for shadow update
170500201218      ** Update on shadow files should only be done if not a Risk loan
170600201218     C     PTYP          IFNE      70
170700201218     C     PTYP          ANDNE     71
170800201218     C     PTYP          ANDNE     72
170900201218      *
171000201218     C     LAAMTP        IFNE      'PT'
171100201218     C     LAAMTP        ANDNE     'PF'
171200201218     C                   EXSR      SRSHAD
171300201218     C                   MOVE      Z#ADTA        Z#ADT1
171400201218     C                   MOVE      Z#ADTB        Z#ADT2
171500201218      *
171600201218     C     CEU004        IFEQ      'Y'
171700201218     C     CLE031        OREQ      'Y'                                                        CLE031
171800201218     C                   MOVE      Z#ADTE        Z#ADT5
171900201218     C                   ENDIF
172000201218                                                                                              CLE134
172100201218     C                   IF        CLE134      = 'Y'                                          CLE134
172200201218     C                   EVAL      Z#ADT8      = Z#ADTH                                       CLE134
172300201218     C                   ENDIF                                                                CLE134
172400201218      *
172500201218     C                   ENDIF
172600201218      *
172700201218     C                   ENDIF
172800201218      *
172900201218      ** Update Loan Amend. Trailer file, LTRIX, Loans file,
173000201218      ** Facility and Shadow Files
173100201218     C     CLE134        IFEQ      'N'                                                      MD021423
173200201218     C*****MPHAS         OREQ      'A'                                             MD021423 MD025467
173300201218     C     MPHAS         ORNE      'C'                                                      MD025467
173400201218     C                   EXSR      SRTRAL
173500201218     C                   ENDIF                                                              MD021423
173600201218     C                   EXSR      SRLTRX
173700201218      *
173800201218     C     LAAMTP        IFNE      'PT'
173900201218     C     LAAMTP        ANDNE     'PF'
174000201218     C                   EXSR      SRCLON
174100201218      *                                                                                    AR1021983
174200201218     C                   IF        CLE134 = 'Y' AND                                        AR1021983
174300201218     C                             W#FRNT = 'LE000473' AND                                 AR1021983
174400201218     C                             LO_FAMU <> 'Y' AND                                      AR1021983
174500201218     C                             (LALTYP = 'Y' OR LALTYP = 'Z')                          AR1021983
174600201218      ** Skip update of facilities file                                                    AR1021983
174700201218     C                   ELSE                                                              AR1021983
174800201218     C                   EXSR      SRFCLT
174900201218     C                   ENDIF                                                             AR1021983
175000201218      *
175100201218      ** If CLE009 is installed, update fees file
175200201218     C     CLE009        IFEQ      'Y'
175300201218     C                   EXSR      SRFEES
175400201218     C                   ENDIF
175500201218                                                                                              CLE055
175600201218     C********           If        CLE055 = 'Y'  and  BPLMAU = 'Y'                     243270 243415
175700201218     C********           If        DDACTN = 'I' or  DDACTN = 'A'                       CLE055 243415
175800201218                                                                                              CLE055
175900201218      * If authorization required clear settlement deatils.                                   CLE055
176000201218     C*********          If        CLE055 = 'Y'  and  BPLMAU = 'Y'                     CLE055 243270
176100201218     C                   If        CLE055 = 'Y'  and  BPLMAU = 'Y' and                        243415
176200201218     C                             LAAUTH <> 'Y' and LAAMTP = 'PI'                            243415
176300201218                                                                                              CLE055
176400201218     C                   If        DDACTN = 'I' or  DDACTN = 'A'                              243415
176500201218     C                   Clear                   Z#ZADTA                                      CLE055
176600201218     C*********          Clear                   Z#ZADTB                               CLE055 243415
176700201218                                                                                              CLE055
176800201218     C                   Eval      Z#ZADTA   =    Z#ADT1                                      CLE055
176900201218                                                                                              CLE055
177000201218     C                   If        PONS      = OTOURS                                         CLE055
177100201218     C                   Clear                   ZA_Type                                      CLE055
177200201218     C                   Clear                   ZA_Otours                                    CLE055
177300201218     C                   Eval      Z#ADT1    =    Z#ZADTA                                     243415
177400201218     C                   Endif                                                                CLE055
177500201218     C                   Endif                                                                243270
177600201218                                                                                              CLE055
177700201218      * Authorizatin mode.                                                                    CLE055
177800201218     C     DDACTN        IFEQ      'X'                                                        243270
177900201218     C     DDACTN        OREQ      'Q'                                                        243270
178000201218     C*****DDACTN        IFEQ      'Q'                                                 CLE055 243270
178100201218     C     CLE030        ANDEQ     'Y'                                                        CLE055
178200201218     C                   Clear                   Z#ZADTA                                      243415
178300201218     C                   Eval      Z#ZADTA   =    Z#ADT1                                      CLE055
178400201218                                                                                              CLE055
178500201218     C                   If        RONS      = OTOURS                                         CLE055
178600201218     C                   Clear                   ZA_Type                                      CLE055
178700201218     C                   Clear                   ZA_Otours                                    CLE055
178800201218     C                   Eval      Z#ADT1    =    Z#ZADTA                                     243415
178900201218     C                   Endif                                                                CLE055
179000201218                                                                                              CLE055
179100201218     C                   Endif                                                                CLE055
179200201218                                                                                              CLE055
179300201218     C*********          Endif                                                         CLE055 243270
179400201218                                                                                              CLE055
179500201218     C                   Endif                                                                CLE055
179600201218                                                                                              CLE055
179700201218      *
179800201218      ** Update on shadow files should only be done if not a Risk loan
179900201218     C     PTYP          IFNE      70
180000201218     C     PTYP          ANDNE     71
180100201218     C     PTYP          ANDNE     72
180200201218     C                   EXSR      SRUSHD
180300201218     C                   ENDIF
180400201218      *
180500201218     C                   ENDIF
180600201218     C/COPY WNCPYSRC,LEH01191
180700201218
180800201218      ** If support system active, write transaction to 24x7 log
180900201218     C     System        IFEQ      'S'
181000201218     C                   EXSR      APLGTR
181100201218     C                   ENDIF
181200201218      *
181300201218      ** Data export for CCRM - Limits
181400201218     C     CDE001        IFEQ      'Y'
181500201218     C                   MOVEL     LALNRF        T#TREF
181600201218     C                   CALL      'DEWTTRIG'
181700201218     C**********         PARM                    T#TREF           20                          CGL029
181800201218     C                   PARM                    T#TREF                                       CGL029
181900201218     C                   PARM      'LOAN'        T#TCAT            4
182000201218     C                   PARM                    ReservId
182100201218     C                   ENDIF
182200201218      *
182300201218      ** Perform Increase Part Sold Amount on Master Loan
182400201218     C                   EXSR      SRUPPS
182500201218      *
182600201218     C                   ENDSR
182700201218      *****************************************************************
182800201218      /EJECT
182900201218      *****************************************************************
183000201218      * SRSHAD  -  Retrieve parameter fields for Shadow Update        *
183100201218      *****************************************************************
183200201218     C     SRSHAD        BEGSR
183300201218      *
183400201218     C                   MOVE      RECI          SHRECI
183500201218     C                   MOVE      LNRF          SHLNRF
183600201218     C                   Z-ADD     VDAT          SHVDAT
183700201218     C                   Z-ADD     LASN          SHLASN
183800201218     C                   MOVE      PTYP          SHPTYP
183900201218     C                   MOVE      AMTP          SHAMTP
184000201218     C                   Z-ADD     RTSP          SHRTSP
184100201218     C                   MOVE      CCY           SHCCY
184200201218     C                   Z-ADD     PRAM          SHPRAM
184300201218     C                   MOVE      BRCA          SHBRCA
184400201218     C                   Z-ADD     0             SHREPT
184500201218      *
184600201218     C     WSOLD         IFEQ      'Y'
184700201218     C     PDCLI         OREQ      'Y'                                                      MD023787
184800201218     C                   MOVE      RSTM          TYPE
184900201218     C                   MOVE      RONS          OTOURS
185000201218     C                   ELSE
185100201218     C                   MOVE      PSTM          TYPE
185200201218     C                   MOVE      PONS          OTOURS
185300201218     C                   ENDIF
185400201218      *
185500201218     C                   MOVEL(P)  PIBN          THRS
185600201218     C                   MOVEL(P)  BENN          OTFACO
185700201218     C                   MOVE      *BLANK        SHINTC
185800201218      *
185900201218     C                   MOVE      OSBR          SHOSBR
186000201218     C                   MOVE      CHTP          SHCHTP
186100201218      *
186200201218     C     CEU004        IFEQ      'Y'
186300201218     C                   MOVE      SCCY          SHSCCY
186400201218     C                   MOVE      ICCY          SHICCY
186500201218     C                   ENDIF
186600201218      *
186700201218     C     CLE031        IFEQ      'Y'                                                        CLE031
186800201218     C                   MOVE      SCCY          SHSCCY                                     AR943686
186900201218     C                   Z-ADD     REXR          SHREXR                                       CLE031
187000201218     C                   MOVE      REXI          SHREXI                                       CLE031
187100201218     C                   MOVE      PSCY          SHPSCY                                       CLE031
187200201218     C                   Z-ADD     PEXR          SHPEXR                                       CLE031
187300201218     C                   MOVE      PEXI          SHPEXI                                       CLE031
187400201218     C                   ENDIF                                                                CLE031
187500201218     C*                                                                                       CLE034
187600201218     C                   MOVE      STAL          SHSTAL                                       CLE034
187700201218      *
187800201218     C                   MOVE      LO_XRFI       SHXRFI                                       CLE134
187900201218     C                   MOVE      LO_XRFN       SHXRFN                                       CLE134
188000201218     C                   ENDSR
188100201218      *****************************************************************
188200201218      /EJECT
188300201218      *****************************************************************
188400201218      * SRTRAL  -  Update Loan Amendments Trailer File                *
188500201218      *****************************************************************
188600201218     C     SRTRAL        BEGSR
188700201218      *
188800201218      ** Update Loan Amendments Trailer, No action for amendments
188900201218      **  (also needed for Principal Transfer amend)
189000201218     C*****LACHTP        IFEQ      'I'                                                       BUG4138
189100201218     C*****LACHTP        OREQ      'R'                                                       BUG4138
189200201218     C*****LACHTP        OREQ      'A'                                                       BUG4138
189300201218     C     DDACTN        IFEQ      'I'                                                       BUG4138
189400201218     C     DDACTN        OREQ      'R'                                                       BUG4138
189500201218     C     DDACTN        OREQ      'A'                                                       BUG4138
189600201218     C                   MOVE      '999999'      WKLNR
189700201218     C                   MOVE      '99999'       WKVDT
189800201218     C                   MOVE      '999'         WKLSN
189900201218     C                   IF        MTHREAD = 'N'                                            MD024342
190000201218     C     KLAKEY        CHAIN     LOAMD                              99
190100201218     C                   ELSE                                                               MD024342
190200201218     C                   EXSR      Initialise                                               MD024342
190300201218     C                   ENDIF                                                              MD024342
190400201218      *                                                                                    AR1021983
190500201218     C**********         IF        CLE134 = 'Y'                                   AR1021983 MD020568
190600201218     C                   IF        CLE134 = 'Y' AND                                         MD020568
190700201218     C                             W#FRNT = 'LE000473'                                      MD020568
190800201218     C                             and CobMode = 'Y'                                        MD022860
190900201218     C                   EVAL      NORE   = 1                                             AR1077027A
191000201218     C                   EVAL      NINS   = 0                                             AR1077027A
191100201218     C                   EVAL      NLRB   = 0                                             AR1077027A
191200201218     C                   EVAL      NDEL   = 0                                             AR1077027A
191300201218     C                   EVAL      NLRA   = 0                                             AR1077027A
191400201218     C                   EVAL      VLBF   = 0                                             AR1077027A
191500201218     C                   EVAL      VLBL   = 0                                             AR1077027A
191600201218     C                   EVAL      VRIF   = 0                                             AR1077027A
191700201218     C                   EVAL      VRIL   = 0                                             AR1077027A
191800201218     C                   EVAL      VRDF   = 0                                             AR1077027A
191900201218     C                   EVAL      VRDL   = 0                                             AR1077027A
192000201218     C                   EVAL      VRAF   = 0                                             AR1077027A
192100201218     C                   EVAL      VRAL   = 0                                             AR1077027A
192200201218     C                   EVAL      VRRF   = 0                                             AR1077027A
192300201218     C                   EVAL      VRRL   = 0                                             AR1077027A
192400201218     C     KLAKEY        CHAIN     LELOMKL3                           90                   AR1021983
192500201218     C                   ENDIF                                                             AR1021983
192600201218      *
192700201218     C                   IF        MTHREAD = 'N'                                            MD024342
192800201218     C     *IN99         IFEQ      '1'
192900201218     C                   MOVEL(P)  'LOAMS'       DBFILE                         ************
193000201218     C                   Z-ADD     12            DBASE                          * DBERR 12 *
193100201218     C                   MOVEL     '999999'      DBKEY                          ************
193200201218     C                   EXSR      *PSSR
193300201218     C                   ENDIF
193400201218     C                   ENDIF                                                              MD024342
193500201218      *
193600201218     C*****LACHTP        IFEQ      'A'                                                       BUG4138
193700201218     C     DDACTN        IFEQ      'A'                                                       BUG4138
193800201218      *
193900201218     C     LAAMTP        IFEQ      'PT'
194000201218     C     LAAMTP        OREQ      'PF'
194100201218     C     LAAMTP        OREQ      'PI'                                                     AR580546
194200201218     C     PRAM          SUB       WPRAM         PTDIFF           13 0
194300201218      *
194400201218     C     PTDIFF        IFNE      0
194500201218     C                   MOVE      PTDIFF        ZZAMT
194600201218     C                   Z-ADD     VRAF          ZZTOTI
194700201218     C                   Z-ADD     VRAL          ZZTOTD
194800201218     C                   EXSR      GLZADD
194900201218     C                   Z-ADD     ZZTOTI        VRAF
195000201218     C                   Z-ADD     ZZTOTD        VRAL
195100201218     C                   Z-ADD     VRRF          ZZTOTI
195200201218     C                   Z-ADD     VRRL          ZZTOTD
195300201218     C                   EXSR      GLZADD
195400201218     C                   Z-ADD     ZZTOTI        VRRF
195500201218     C                   Z-ADD     ZZTOTD        VRRL
195600201218     C                   ENDIF
195700201218      *
195800201218     C                   ENDIF
195900201218      *
196000201218      ** Action not Amend
196100201218     C                   ELSE
196200201218      *
196300201218      ** Action not Reversal (i.e. Action Insert)
196400201218     C*****LACHTP        IFNE      'R'                                                       BUG4138
196500201218     C     DDACTN        IFNE      'R'                                                       BUG4138
196600201218      *****************************************************************             Bug03936 BUG4138
196700201218      ***Do*not*re-count*during*authorize*action.**********************             Bug03936 BUG4138
196800201218      *****************************************************************             Bug03936 BUG4138
196900201218     C*****LACHTP        IFEQ      'I'                                              Bug03936 BUG4138
197000201218     C     NORE          ADD       1             NORE
197100201218     C     NINS          ADD       1             NINS
197200201218     C     NLRA          ADD       1             NLRA
197300201218      *
197400201218     C     LAAMTP        IFEQ      'PI'
197500201218     C     LAAMTP        OREQ      'PT'
197600201218     C     LAAMTP        OREQ      'PF'
197700201218     C                   MOVE      PRAM          ZZAMT
197800201218     C                   Z-ADD     VRIF          ZZTOTI
197900201218     C                   Z-ADD     VRIL          ZZTOTD
198000201218     C                   EXSR      GLZADD
198100201218     C                   Z-ADD     ZZTOTI        VRIF
198200201218     C                   Z-ADD     ZZTOTD        VRIL
198300201218     C                   Z-ADD     VRRF          ZZTOTI
198400201218     C                   Z-ADD     VRRL          ZZTOTD
198500201218     C                   EXSR      GLZADD
198600201218     C                   Z-ADD     ZZTOTI        VRRF
198700201218     C                   Z-ADD     ZZTOTD        VRRL
198800201218     C                   ENDIF
198900201218      *****************************************************************             Bug03936 BUG4138
199000201218     C**********         ENDIF                                                      Bug03936 BUG4138
199100201218      *
199200201218     C                   ELSE
199300201218      *
199400201218      ** Reverse action code
199500201218      ** Need to use TAMT now, since we can reverse PDs
199600201218     C                   MOVE      TAMT          ZZAMT
199700201218     C     NDEL          ADD       1             NDEL
199800201218     C     NLRA          SUB       1             NLRA
199900201218      *
200000201218     C     LAAMTP        IFEQ      'PI'
200100201218     C     LAAMTP        OREQ      'PT'
200200201218     C     LAAMTP        OREQ      'PF'
200300201218     C     LAAMTP        OREQ      'PD'
200400201218     C                   Z-ADD     VRDF          ZZTOTI
200500201218     C                   Z-ADD     VRDL          ZZTOTD
200600201218     C                   EXSR      GLZADD
200700201218     C                   Z-ADD     ZZTOTI        VRDF
200800201218     C                   Z-ADD     ZZTOTD        VRDL
200900201218     C                   Z-ADD     VRRF          ZZTOTI
201000201218     C                   Z-ADD     VRRL          ZZTOTD
201100201218     C                   EXSR      GLZSUB
201200201218     C                   Z-ADD     ZZTOTI        VRRF
201300201218     C                   Z-ADD     ZZTOTD        VRRL
201400201218     C                   ENDIF
201500201218      *
201600201218     C                   ENDIF
201700201218      *
201800201218     C                   ENDIF
201900201218      *
202000201218     C                   IF        MTHREAD = 'Y'                                            MD024342
202100201218     C                   Z-ADD     LATNLU        TNLU                                       MD024342
202200201218     C**********         WRITE     LOAMSZ1F                                       MD024342 MD024342B
202300201218     C**********         WRITE     LOAMSZ1FX                                      MD024342B MD025467
202400201218     C                   WRITE     LOAMSZ1F                                                 MD025467
202500201218     C                   ELSE                                                               MD024342
202600201218     C                   Z-ADD     LATNLU        TNLU
202700201218     C                   UPDATE    LOAMSZ1F
202800201218     C                   ENDIF                                                              MD024342
202900201218      *                                                                                    AR1021983
203000201218      ** Update loan amendments trailer file                                               AR1021983
203100201218      *                                                                                    AR1021983
203200201218     C                   IF        CLE134 = 'Y' AND                                        AR1021983
203300201218     C                             W#FRNT = 'LE000473'                                      MD020568
203400201218     C                             and CobMode = 'Y'                                        MD022860
203500201218     C**********                   (W#FRNT = 'LE000473' OR                        AR1021983 MD020568
203600201218     C**********                   W#FRNT = *BLANKS)                              AR1021983 MD020568
203700201218     C                   IF        *IN90 = *ON                                             AR1021983
203800201218     C                   WRITE     LOMKSZ1F                                                AR1021983
203900201218     C                   ELSE                                                              AR1021983
204000201218     C                   UPDATE    LOMKSZ1F                                                AR1021983
204100201218     C                   ENDIF                                                             AR1021983
204200201218     C                   ENDIF                                                             AR1021983
204300201218      *                                                                                    AR1021983
204400201218     C                   ENDIF
204500201218      *
204600201218     C                   ENDSR
204700201218      *****************************************************************
204800201218      /EJECT
204900201218      *****************************************************************
205000201218      * SRLTRX  -  Update Loan Transaction Index Detail (LTRIX)       *
205100201218      *****************************************************************
205200201218     C     SRLTRX        BEGSR
205300201218      *
205400201218      ** Update LTRIX if amendment type is PI, PT or PF only, and action
205500201218      ** is authorisation or reversal
205600201218     C     LAAMTP        IFEQ      'PI'
205700201218     C*****LACHTP        ANDEQ     'X'                                                      BUG13325
205800201218     C     DDACTN        ANDEQ     'X'                                                      BUG13325
205900201218     C     BPLMAU        ANDEQ     'Y'
206000201218      *
206100201218     C     LAAMTP        OREQ      'PI'
206200201218     C*****LACHTP        ANDEQ     'I'                                                      BUG13325
206300201218     C     DDACTN        ANDEQ     'I'                                                      BUG13325
206400201218     C     BPLMAU        ANDEQ     'N'
206500201218      *
206600201218     C     LAAMTP        OREQ      'PI'
206700201218     C*****LACHTP        ANDEQ     'A'                                                      BUG13325
206800201218     C     DDACTN        ANDEQ     'A'                                                      BUG13325
206900201218     C     BPLMAU        ANDEQ     'N'
207000201218      *
207100201218     C     LAAMTP        OREQ      'PT'
207200201218     C*****LACHTP        ANDEQ     'X'                                                      BUG13325
207300201218     C     DDACTN        ANDEQ     'X'                                                      BUG13325
207400201218     C     BPTPAU        ANDEQ     'Y'
207500201218      *
207600201218     C     LAAMTP        OREQ      'PT'
207700201218     C*****LACHTP        ANDEQ     'I'                                                      BUG13325
207800201218     C     DDACTN        ANDEQ     'I'                                                      BUG13325
207900201218     C     BPTPAU        ANDEQ     'N'
208000201218      *
208100201218     C     LAAMTP        OREQ      'PT'
208200201218     C*****LACHTP        ANDEQ     'A'                                                      BUG13325
208300201218     C     DDACTN        ANDEQ     'A'                                                      BUG13325
208400201218     C     BPTPAU        ANDEQ     'N'
208500201218      *
208600201218     C     LAAMTP        OREQ      'PF'
208700201218     C*****LACHTP        ANDEQ     'X'                                                      BUG13325
208800201218     C     DDACTN        ANDEQ     'X'                                                      BUG13325
208900201218     C     BPTPAU        ANDEQ     'Y'
209000201218      *
209100201218     C     LAAMTP        OREQ      'PF'
209200201218     C*****LACHTP        ANDEQ     'I'                                                      BUG13325
209300201218     C     DDACTN        ANDEQ     'I'                                                      BUG13325
209400201218     C     BPTPAU        ANDEQ     'N'
209500201218      *
209600201218     C     LAAMTP        OREQ      'PF'
209700201218     C*****LACHTP        ANDEQ     'A'                                                      BUG13325
209800201218     C     DDACTN        ANDEQ     'A'                                                      BUG13325
209900201218     C     BPTPAU        ANDEQ     'N'
210000201218      *
210100201218     C     LAAMTP        OREQ      'PI'
210200201218     C*****LACHTP        ANDEQ     'R'                                                      BUG13325
210300201218     C     DDACTN        ANDEQ     'R'                                                      BUG13325
210400201218     C     BPLMAU        ANDEQ     'Y'
210500201218     C     LAXUSR        ANDNE     *BLANK
210600201218      *
210700201218     C     LAAMTP        OREQ      'PI'
210800201218     C*****LACHTP        ANDEQ     'R'                                                      BUG13325
210900201218     C     DDACTN        ANDEQ     'R'                                                      BUG13325
211000201218     C     BPLMAU        ANDEQ     'N'
211100201218      *
211200201218     C     LAAMTP        OREQ      'PT'
211300201218     C*****LACHTP        ANDEQ     'R'                                                      BUG13325
211400201218     C     DDACTN        ANDEQ     'R'                                                      BUG13325
211500201218     C     BPTPAU        ANDEQ     'Y'
211600201218     C     LAXUSR        ANDNE     *BLANK
211700201218      *
211800201218     C     LAAMTP        OREQ      'PT'
211900201218     C*****LACHTP        ANDEQ     'R'                                                      BUG13325
212000201218     C     DDACTN        ANDEQ     'R'                                                      BUG13325
212100201218     C     BPTPAU        ANDEQ     'N'
212200201218      *
212300201218     C     LAAMTP        OREQ      'PF'
212400201218     C*****LACHTP        ANDEQ     'R'                                                      BUG13325
212500201218     C     DDACTN        ANDEQ     'R'                                                      BUG13325
212600201218     C     BPTPAU        ANDEQ     'Y'
212700201218     C     LAXUSR        ANDNE     *BLANK
212800201218      *
212900201218     C     LAAMTP        OREQ      'PF'
213000201218     C*****LACHTP        ANDEQ     'R'                                                      BUG13325
213100201218     C     DDACTN        ANDEQ     'R'                                                      BUG13325
213200201218     C     BPTPAU        ANDEQ     'N'
213300201218      *
213400201218     C     LAPCOB        ORNE      *BLANKS
213500201218     C     LAAMTP        ANDEQ     'PI'
213600201218      *
213700201218     C******IN98         DOUEQ     '0'                                                      AR322732
213800201218     C*****RECI*         ANDEQ     *BLANK                                                   AR322732
213900201218     C******IN99         OREQ      '1'                                                      AR322732
214000201218      *
214100201218     C**********         Z-ADD     1             LXRRN             5 0                      AR322732
214200201218      *
214300201218      ** Access LTRIX header
214400201218     C*****LXRRN         CHAIN(N)  LTRIX                              99                    AR322732
214500201218      *
214600201218     C******IN99         IFEQ      '0'                                                      AR322732
214700201218      *
214800201218     C*****RECI*         IFEQ      'H'                                                      AR322732
214900201218      *
215000201218     C*****RRNA*         IFGT      FLSZ                                                     AR322732
215100201218     C**********         MOVE      '1'           *INU8                                      AR322732
215200201218     C**********         ENDIF                                                              AR322732
215300201218      *
215400201218     C**********         ELSE                                                               AR322732
215500201218     C**********         MOVE      *ON           *IN99                                      AR322732
215600201218     C**********         ENDIF                                                              AR322732
215700201218      *
215800201218     C**********         ENDIF                                                              AR322732
215900201218      *
216000201218     C******IN99         IFEQ      *ON                                                      AR322732
216100201218     C******INU8         OREQ      *ON                                                      AR322732
216200201218     C**********         MOVEL     'LTRIX   '    DBFILE                         ************AR322732
216300201218     C**********         Z-ADD     13            DBASE                          * DBERR 13 *AR322732
216400201218     C**********         MOVEL     LXRRN         DBKEY                          ************AR322732
216500201218     C**********         EXSR      *PSSR                                                    AR322732
216600201218     C**********         ENDIF                                                              AR322732
216700201218      *
216800201218     C**********         MOVE      RRNA          LXRRN                                      AR322732
216900201218      *
217000201218     C*****LXRRN         CHAIN     LTRIX                              9998                  AR322732
217100201218      *
217200201218     C******IN98         IFEQ      '1'                                                      AR322732
217300201218      *
217400201218     C*****TXSTS         IFEQ      1218                                                     AR322732
217500201218     C**********         UNLOCK    LTRIX                                                    AR322732
217600201218     C**********         ELSE                                                               AR322732
217700201218     C**********         MOVE      '1'           *IN99                                      AR322732
217800201218     C**********         ENDIF                                                              AR322732
217900201218      *
218000201218     C**********         ENDIF                                                              AR322732
218100201218      *
218200201218     C**********         ENDDO                                                              AR322732
218300201218      *
218400201218     C******IN99         IFEQ      '1'                                                      AR322732
218500201218     C**********         MOVEL     'LTRIX   '    DBFILE                         ************AR322732
218600201218     C**********         Z-ADD     14            DBASE                          * DBERR 14 *AR322732
218700201218     C**********         MOVEL     LXRRN         DBKEY                          ************AR322732
218800201218     C**********         EXSR      *PSSR                                                    AR322732
218900201218     C**********         ENDIF                                                              AR322732
219000201218      *
219100201218     C                   Z-ADD     0             PRI1
219200201218      *
219300201218      ** Check settlement type
219400201218     C     LASETP        IFEQ      01
219500201218     C     LASETP        OREQ      02
219600201218     C     LASETP        OREQ      07
219700201218     C     LASETP        OREQ      08
219800201218     C     LASETP        OREQ      12
219900201218      *
220000201218      ** Obtain lowest telex notice days between loan & local CCY
220100201218     C                   CALLB     'AOCURRR0'
220200201218     C                   PARM      *BLANKS       @RtCd
220300201218     C                   PARM      '*KEY   '     @Optn
220400201218     C                   PARM      LACCY         @Curr             3
220500201218     C     SDCURR        PARM                    DSSDY
220600201218      *
220700201218     C     @RtCd         IFNE      *BLANKS
220800201218     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
220900201218     C                   Z-ADD     15            DBASE                          * DBERR 15 *
221000201218     C                   MOVEL     LACCY         DBKEY                          ************
221100201218     C                   EXSR      *PSSR
221200201218     C                   ENDIF
221300201218      *
221400201218      ** Default to local CCY for telex notice calculation
221500201218     C                   Z-ADD     TNOTL         ZNRDYS
221600201218     C                   Z-ADD     WRNDAY        ZDAYNO
221700201218     C                   MOVE      BJLCCY        ZCCY
221800201218      *
221900201218      ** For settlement types 01, 07, & 08 use loan currency instead
222000201218     C     LASETP        IFEQ      01
222100201218     C     LASETP        OREQ      07
222200201218     C     LASETP        OREQ      08
222300201218     C                   Z-ADD     A6TXND        ZNRDYS
222400201218     C                   MOVE      LACCY         ZCCY
222500201218     C                   ENDIF
222600201218      *
222700201218     C                   CALLB     'ZFWDT'
222800201218     C                   PARM                    ZDAYNO            5 0
222900201218     C                   PARM                    ZNRDYS            2 0
223000201218     C                   PARM      *ZERO         ZDYNBR            5 0
223100201218     C                   PARM                    ZCCY              3
223200201218     C                   PARM      *BLANKS       ZLOC              3
223300201218      *
223400201218     C     LAVDAT        IFLE      ZDYNBR
223500201218     C     LAVDAT        ANDGE     WRNDAY
223600201218     C                   Z-ADD     1             PRI1
223700201218     C                   ENDIF
223800201218      *
223900201218     C                   ENDIF
224000201218      *
224100201218      ** Interactive mode - if action is authorise and amendment
224200201218      ** status is complete, then for LTRIX purposes should be
224300201218      ** treated as an insert regardless of whether last change type
224400201218      ** is insert or amend, since it can never have been authorised
224500201218      ** previously (and hence never appeared on LTRIX)
224600201218     C*****LACHTP        IFEQ      'X'                                                      BUG13325
224700201218     C     DDACTN        IFEQ      'X'                                                      BUG13325
224800201218     C     LAASTS        ANDEQ     'C'
224900201218     C                   MOVE      'I'           CHTP
225000201218     C                   ELSE
225100201218     C                   MOVE      LACHTP        CHTP
225200201218     C                   ENDIF
225300201218      *
225400201218      ** Update LTRIX detail record
225500201218     C                   Z-ADD     0             RRNA              5 0                      AR322732
225600201218     C                   EXCEPT    LTRIXD
225700201218      *
225800201218      ** Get header record
225900201218     C**********         Z-ADD     1             LXRRN                                      AR322732
226000201218     C*****LXRRN         CHAIN     LTRIX                              99                    AR322732
226100201218      *
226200201218     C******IN99         IFEQ      '1'                                                      AR322732
226300201218     C**********         MOVEL     'LTRIX   '    DBFILE                         ************AR322732
226400201218     C**********         Z-ADD     16            DBASE                          * DBERR 16 *AR322732
226500201218     C**********         MOVEL     LXRRN         DBKEY                          ************AR322732
226600201218     C**********         EXSR      *PSSR                                                    AR322732
226700201218     C**********         ENDIF                                                              AR322732
226800201218      *
226900201218      ** Update relevant control fields
227000201218     C*****NORE*         ADD       1             NORE                                       Bug03936
227100201218     C*****NORELX        ADD       1             NORELX                            Bug03936 AR322732
227200201218     C*****RRNA*         ADD       1             RRNA                                       AR322732
227300201218     C*****NLAR*         ADD       1             NLAR                                       AR322732
227400201218      *
227500201218     C**********         EXCEPT    LTRIXH                                                   AR322732
227600201218     C                   ENDIF
227700201218      *
227800201218     C                   ENDSR
227900201218      *****************************************************************
228000201218      /EJECT
228100201218      *****************************************************************
228200201218      * SRCLON  -  Update Customer Loans Detail                       *
228300201218      *****************************************************************
228400201218     C     SRCLON        BEGSR
228500201218      *
228600201218      ** Update CLOAN file to unlink Loan to syndication and
228700201218      ** Consolidated confirmation
228800201218     C     LACHTP        IFEQ      'I'
228900201218     C     LACHTP        OREQ      'R'
229000201218     C                   MOVE      LALNRF        WKLNR
229100201218     C                   MOVE      'A'           WRCDT
229200201218     C     KLKEY         CHAIN     CLOAN                              99
229300201218      *
229400201218     C     *IN99         IFEQ      '1'
229500201218     C                   MOVEL     'CLOAN   '    DBFILE                         ************
229600201218     C                   Z-ADD     17            DBASE                          * DBERR 17 *
229700201218     C                   MOVEL     WKLNR         DBKEY                          ************
229800201218     C                   EXSR      *PSSR
229900201218     C                   ENDIF
230000201218      *
230100201218     C     BPCONR        IFEQ      'Y'
230200201218     C                   MOVE      'N'           LO_CNCF
230300201218     C                   ELSE
230400201218     C                   MOVE      *BLANK        LO_CNCF
230500201218     C                   ENDIF
230600201218      *
230700201218     C     LACHTP        IFEQ      'I'                                                      AR547813
230800201218     C     LAAMTP        ANDEQ     'BC'                                                     AR547813
230900201218     C*****LABRTT        IFNE      *ZERO                                             AR547813 CSD103
231000201218     C     LABRTT        IFNE      *BLANKS                                                    CSD103
231100201218     C     LO_CHIN       ANDEQ     *BLANK                                                   AR547813
231200201218     C     PTYPA         IFEQ      63                                                       AR547813
231300201218     C     PTYPA         OREQ      65                                                       AR547813
231400201218     C     PTYPA         OREQ      67                                                       AR547813
231500201218     C     PTYPA         OREQ      72                                                       AR547813
231600201218     C     PTYPA         OREQ      80                                                       AR547813
231700201218     C     CLE028        ANDEQ     'Y'                                                      AR547813
231800201218     C                   MOVE      'N'           LO_CHIN                                    AR547813
231900201218     C                   ELSE                                                               AR547813
232000201218     C                   MOVE      'D'           LO_CHIN                                    AR547813
232100201218     C                   ENDIF                                                              AR547813
232200201218     C                   ENDIF                                                              AR547813
232300201218     C                   ENDIF                                                              AR547813
232400201218      *                                                                                     AR547813
232500201218     C     LACHTP        IFEQ      'R'                                                      AR547813
232600201218     C     LAAMTP        ANDEQ     'BC'                                                     AR547813
232700201218     C*****LO_BRTT       ANDEQ     *ZERO                                             AR547813 CSD103
232800201218     C     LO_BRTT       ANDEQ     *BLANKS                                                    CSD103
232900201218     C                   MOVE      *BLANK        LO_CHIN                                    AR547813
233000201218     C                   ENDIF                                                              AR547813
233100201218      *                                                                                     AR547813
233200201218     C                   UPDATE    CLOANCLF
233300201218     C                   ENDIF
233400201218      *
233500201218     C                   ENDSR
233600201218      *****************************************************************
233700201218      /EJECT
233800201218      *****************************************************************
233900201218      * SRFCLT  -  Update Facility File                               *
234000201218      *****************************************************************
234100201218     C     SRFCLT        BEGSR
234200201218      *
234300201218     C                   MOVE      'N'           WPART             1
234400201218     C                   MOVE      LO_LPFI       WLPFI             1
234500201218      *
234600201218      ** Update Facility for type 'PI', for Insert and Reverse only
234700201218     C     LACHTP        IFEQ      'I'
234800201218     C     LAAMTP        ANDEQ     'PI'
234900201218      *
235000201218     C     LACHTP        OREQ      'R'
235100201218     C     LAAMTP        ANDEQ     'PI'
235200201218      *
235300201218     C                   MOVEL     FCUSC         WFCNM
235400201218     C                   MOVEL     FTYPC         WFACT
235500201218     C                   MOVEL     FSEQC         WFNUM
235600201218     C                   MOVE      'A'           WFRTP
235700201218     C     KFCLT         CHAIN(N)  FCLTY                              99
235800201218      *
235900201218     C     *IN99         IFEQ      '1'
236000201218     C                   MOVEL     'FCLTY   '    DBFILE                         ************
236100201218     C                   Z-ADD     18            DBASE                          * DBERR 18 *
236200201218     C                   MOVEL     FCLKEY        DBKEY                          ************
236300201218     C                   EXSR      *PSSR
236400201218     C                   ENDIF
236500201218      *
236600201218      * Get loan amendment currency details
236700201218     C                   CALLB     'AOCURRR0'
236800201218     C                   PARM      *BLANKS       @RtCd
236900201218     C                   PARM      '*KEY   '     @Optn
237000201218     C                   PARM      LACCY         @Curr
237100201218     C     SDCURR        PARM                    DSSDY
237200201218      *
237300201218     C     @RtCd         IFNE      *BLANKS
237400201218     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
237500201218     C                   Z-ADD     19            DBASE                          * DBERR 19 *
237600201218     C                   MOVEL     LACCY         DBKEY                          ************
237700201218     C                   EXSR      *PSSR
237800201218     C                   ENDIF
237900201218      *
238000201218      ** Save loan currency details.
238100201218     C     CLE023        IFEQ      'Y'
238200201218     C                   MOVE      LACCY         WCCYL             3
238300201218     C                   Z-ADD     A6SPRT        WSPRTL           13 8
238400201218     C                   MOVE      A6MDIN        WMDINL            1
238500201218     C                   Z-ADD     A6NBDP        WCDPL             1 0
238600201218     C                   ENDIF
238700201218      *
238800201218     C                   Z-ADD     A6NBDP        CDPL              1 0
238900201218      *
239000201218      * Get facility currency details
239100201218     C                   CALLB     'AOCURRR0'
239200201218     C                   PARM      *BLANKS       @RtCd
239300201218     C                   PARM      '*KEY   '     @Optn
239400201218     C                   PARM      FA_FCCY       @Curr
239500201218     C     SDCURR        PARM                    DSSDY
239600201218      *
239700201218     C     @RtCd         IFNE      *BLANKS
239800201218     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
239900201218     C                   Z-ADD     20            DBASE                          * DBERR 20 *
240000201218     C                   MOVEL     FA_FCCY       DBKEY                          ************
240100201218     C                   EXSR      *PSSR
240200201218     C                   ENDIF
240300201218      *
240400201218      ** Save facility currency details.
240500201218     C     CLE023        IFEQ      'Y'
240600201218     C                   MOVE      FA_FCCY       WCCYF             3
240700201218     C                   Z-ADD     A6SPRT        WSPRTF           13 8
240800201218     C                   MOVE      A6MDIN        WMDINF            1
240900201218     C                   Z-ADD     A6NBDP        WCDPF             1 0
241000201218     C                   ENDIF
241100201218      *
241200201218     C                   Z-ADD     A6NBDP        CDPF              1 0
241300201218      *
241400201218     C                   MOVEL     FCUSC         WFCNM
241500201218     C                   MOVEL     FTYPC         WFACT
241600201218     C                   MOVEL     FSEQC         WFNUM
241700201218     C                   MOVE      'B'           WFRTP
241800201218     C     KFCLT         CHAIN     FCLTY                              99
241900201218      *
242000201218     C     *IN99         IFEQ      '1'
242100201218     C                   MOVEL     'FCLTY   '    DBFILE                         ************
242200201218     C                   Z-ADD     21            DBASE                          * DBERR 21 *
242300201218     C                   MOVEL     FCLKEY        DBKEY                          ************
242400201218     C                   EXSR      *PSSR
242500201218     C                   ENDIF
242600201218      *
242700201218     C                   MOVE      *BLANK        WTRCA
242800201218     C                   MOVE      *BLANKS       WKSWRI
242900201218     C                   IF        CLE134 = 'Y'                                             AR656363
243000201218     C                   EVAL      WUpdExpo = 'Y'                                           AR656363
243100201218     C                   EXSR      SrPDCLPI                                                 AR656363
243200201218     C                   ENDIF                                                              AR656363
243300201218                                                                                            AR656363
243400201218     C                   EXSR      FCLTSR
243500201218      *
243600201218     C                   IF        CLE025 = 'N'                                               CLE025
243700201218     C                   Eval      FA_OAM1 =  FB_OAM1
243800201218     C                   Eval      FA_OAM2 =  FB_OAM2
243900201218     C                   Eval      FA_OAM3 =  FB_OAM3
244000201218     C                   Eval      FA_OAM4 =  FB_OAM4
244100201218     C                   Eval      FA_OAM5 =  FB_OAM5
244200201218     C                   Eval      FA_OAM6 =  FB_OAM6
244300201218     C                   Eval      FA_OAM7 =  FB_OAM7
244400201218     C                   Eval      FA_OAM8 =  FB_OAM8
244500201218     C                   Eval      FA_OAM9 =  FB_OAM9
244600201218     C                   Eval      FA_OA10 =  FB_OA10
244700201218     C                   ENDIF                                                                CLE025
244800201218
244900201218     C                   Z-ADD     WRNDAY        LCD
245000201218     C                   MOVE      'A'           CHTP
245100201218     C                   Z-ADD     LATNLU        TNLU
245200201218      *
245300201218     C                   UPDATE    FCLTYFNF
245400201218      *
245500201218     C     FA_TRCA       IFEQ      'TR'
245600201218     C     CLE005        ANDEQ     'Y'
245700201218     C                   EXSR      SRUPCA
245800201218     C                   ENDIF
245900201218      *
246000201218      ** Update also Participant's facility if a Participant or Internal
246100201218      ** facility
246200201218     C     WLPFI         IFNE      *BLANK
246300201218     C*****WLPFI         ANDNE     'R'                                                        CLE106
246400201218     C                   MOVE      'Y'           WPART             1
246500201218     C                   MOVEL     LO_PTFC       WFCNM
246600201218     C                   MOVEL     LO_PTFT       WFACT
246700201218     C                   MOVEL     LO_PTFN       WFNUM
246800201218     C                   MOVE      'A'           WFRTP
246900201218     C     KFCLT         CHAIN(N)  FCLTY                              99
247000201218      *
247100201218     C     *IN99         IFEQ      '1'
247200201218     C                   MOVEL     'FCLTY   '    DBFILE                         ************
247300201218     C                   Z-ADD     22            DBASE                          * DBERR 22 *
247400201218     C                   MOVEL     FCLKEY        DBKEY                          ************
247500201218     C                   EXSR      *PSSR
247600201218     C                   ENDIF
247700201218      *
247800201218     C                   CALLB     'AOCURRR0'
247900201218     C                   PARM      *BLANKS       @RtCd
248000201218     C                   PARM      '*KEY   '     @Optn
248100201218     C                   PARM      FA_FCCY       @Curr
248200201218     C     SDCURR        PARM                    DSSDY
248300201218      *
248400201218     C     @RtCd         IFNE      *BLANKS
248500201218     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
248600201218     C                   Z-ADD     23            DBASE                          * DBERR 23 *
248700201218     C                   MOVEL     FA_FCCY       DBKEY                          ************
248800201218     C                   EXSR      *PSSR
248900201218     C                   ENDIF
249000201218      *
249100201218      ** Save currency details.
249200201218     C     CLE023        IFEQ      'Y'
249300201218     C                   MOVE      FA_FCCY       WCCYF
249400201218     C                   Z-ADD     A6SPRT        WSPRTF
249500201218     C                   MOVE      A6MDIN        WMDINF
249600201218     C                   Z-ADD     A6NBDP        WCDPF
249700201218     C                   ENDIF
249800201218      *
249900201218     C                   Z-ADD     A6NBDP        CDPF              1 0
250000201218     C                   MOVE      'B'           WFRTP
250100201218     C     KFCLT         CHAIN     FCLTY                              99
250200201218      *
250300201218     C     *IN99         IFEQ      '1'
250400201218     C                   MOVEL     'FCLTY   '    DBFILE                         ************
250500201218     C                   Z-ADD     24            DBASE                          * DBERR 24 *
250600201218     C                   MOVEL     FCLKEY        DBKEY                          ************
250700201218     C                   EXSR      *PSSR
250800201218     C                   ENDIF
250900201218      *
251000201218     C                   IF        CLE134 = 'Y'                                             AR656363
251100201218     C                   EVAL      WUpdExpo = 'Y'                                           AR656363
251200201218     C                   EXSR      SrPDCLPI                                                 AR656363
251300201218     C                   ENDIF                                                              AR656363
251400201218                                                                                            AR656363
251500201218     C                   EXSR      FCLTSR
251600201218      *
251700201218     C                   IF        CLE025 = 'N'                                               CLE025
251800201218     C                   Eval      FA_OAM1 =  FB_OAM1
251900201218     C                   Eval      FA_OAM2 =  FB_OAM2
252000201218     C                   Eval      FA_OAM3 =  FB_OAM3
252100201218     C                   Eval      FA_OAM4 =  FB_OAM4
252200201218     C                   Eval      FA_OAM5 =  FB_OAM5
252300201218     C                   Eval      FA_OAM6 =  FB_OAM6
252400201218     C                   Eval      FA_OAM7 =  FB_OAM7
252500201218     C                   Eval      FA_OAM8 =  FB_OAM8
252600201218     C                   Eval      FA_OAM9 =  FB_OAM9
252700201218     C                   Eval      FA_OA10 =  FB_OA10
252800201218     C                   ENDIF                                                                CLE025
252900201218
253000201218     C                   Z-ADD     WRNDAY        LCD
253100201218     C                   MOVE      'A'           CHTP
253200201218     C                   Z-ADD     LATNLU        TNLU
253300201218      *
253400201218     C                   UPDATE    FCLTYFNF
253500201218      *
253600201218     C     FA_TRCA       IFEQ      'TR'
253700201218     C     CLE005        ANDEQ     'Y'
253800201218     C                   EXSR      SRUPCA
253900201218     C                   ENDIF
254000201218      *
254100201218     C                   ENDIF
254200201218      *
254300201218     C                   ENDIF
254400201218      *
254500201218     C                   ENDSR
254600201218      /EJECT                                                                                AR656363
254700201218      *****************************************************************                     AR656363
254800201218      * SRPDCLPI Check if loan has FAMU N/Y                           *                     AR656363
254900201218      *****************************************************************                     AR656363
255000201218     C     SRPDCLPI      BEGSR                                                              AR656363
255100201218                                                                                            AR656363
255200201218      ** Proceed only if Amendment Type is PI and for Interest(Y) or Fee(Z)                 AR656363
255300201218                                                                                            AR656363
255400201218     C     DDATYP        IFEQ      'PI'                                                     AR656363
255500201218     C     AUTOC         ANDEQ     'C'                                                      AR656363
255600201218     C                   IF        %SUBST(LTYPA:1:1) =  'Y'  and                            AR656363
255700201218     C                             LO_FAMU = 'N' OR                                         AR656363
255800201218     C                             %SUBST(LTYPA:1:1) =  'Z'  and                            AR656363
255900201218     C                             LO_FAMU = 'N'                                            AR656363
256000201218     C                   EVAL      WUpdExpo='N'                                             AR656363
256100201218     C                   ENDIF                                                              AR656363
256200201218     C                   ENDIF                                                              AR656363
256300201218                                                                                            AR656363
256400201218     C                   ENDSR                                                              AR656363
256500201218      *****************************************************************
256600201218      /EJECT
256700201218      *****************************************************************
256800201218      * FCLTSR  -  Evaluate Facility Exposure                         *
256900201218      *****************************************************************
257000201218     C     FCLTSR        BEGSR
257100201218      *
257200201218      ** Convert amounts in facility currency equivalent
257300201218     C     WTRCA         IFEQ      *BLANK
257400201218     C     CDPF          SUB       CDPL          CX                1 0
257500201218     C     CX            ADD       4             CX
257600201218      *
257700201218     C     LO_FMDI       COMP      'D'                                    92
257800201218      *
257900201218     C   92LO_FCXR       DIV(H)    POWR(CX)      OFCXRT
258000201218     C   921             DIV       OFCXRT        OFCXRT
258100201218     C  N92LO_FCXR       MULT(H)   POWR(CX)      OFCXRT           15 9
258200201218      *
258300201218      ** If CLE023 is ON, get cross rate of currencies spot.
258400201218     C     CLE023        IFEQ      'Y'
258500201218     C                   CALLB     'ZXRATE'
258600201218     C                   PARM      WSPRTL        ZRATE1           13 8
258700201218     C                   PARM      WMDINL        ZMDI1             1
258800201218     C                   PARM      WSPRTF        ZRATE2           13 8
258900201218     C                   PARM      WMDINF        ZMDI2             1
259000201218     C                   PARM                    ZRATEX           13 8
259100201218     C                   PARM                    ZMDIX             1
259200201218
259300201218     C                   MOVE      WCCYL         ZCCYI
259400201218     C                   MOVE      WCCYF         ZCCYO
259500201218     C                   MOVE      WCDPL         ZCDPI
259600201218     C                   MOVE      WCDPF         ZCDPO
259700201218     C                   Z-ADD     ZRATEX        ZEXCH
259800201218     C                   MOVE      ZMDIX         ZMD
259900201218     C                   ENDIF
260000201218
260100201218     C     DDACTN        IFEQ      'I'
260200201218     C     LAPRAM        MULT(H)   OFCXRT        ILAAMF           13 0
260300201218      *
260400201218      ** If CLE023 is ON convert amounts using spot rate.
260500201218     C     CLE023        IFEQ      'Y'
260600201218     C                   Z-ADD     LAPRAM        ZAMTCI
260700201218     C                   CALLB     'ZCONVZ1'
260800201218     C                   PARM                    ZAMTCI           15 0
260900201218     C                   PARM                    ZEXCH            13 8
261000201218     C                   PARM                    ZMD               1
261100201218     C                   PARM                    ZCCYI             3
261200201218     C                   PARM                    ZCCYO             3
261300201218     C                   PARM                    ZCDPI             1 0
261400201218     C                   PARM                    ZCDPO             1 0
261500201218     C                   PARM                    ZAMTCO           15 0
261600201218     C                   Z-ADD     ZAMTCO        WXAAMF           13 0
261700201218      *
261800201218      ** If rollover date is less than or equal to the value date of
261900201218      ** the amendment and there is a rollover of facility exchange
262000201218      ** rate, use the new facility exchange rate defined.
262100201218     C     LO_RLDT       IFLT      WRNDAY
262200201218     C     LO_RLDT       ANDNE     0
262300201218     C     LO_NFCE       ANDNE     0
262400201218     C     LO_NCCY       ANDEQ     *BLANKS
262500201218     C     LO_NFMD       IFEQ      'D'
262600201218     C     LO_NFCE       DIV(H)    POWR(CX)      WNFCE            15 9
262700201218     C     1             DIV       WNFCE         WNFCE
262800201218     C                   ELSE
262900201218     C     LO_NFCE       MULT(H)   POWR(CX)      WNFCE
263000201218     C                   ENDIF
263100201218     C     LAPRAM        MULT(H)   WNFCE         ILAAMF
263200201218     C                   ENDIF
263300201218     C                   ENDIF
263400201218      *
263500201218     C                   ENDIF
263600201218     C     DDACTN        IFEQ      'R'
263700201218     C     PRAM          MULT(H)   OFCXRT        ILAAMF
263800201218      *
263900201218      ** If CLE023 is ON convert amount using spot rate.
264000201218     C     CLE023        IFEQ      'Y'
264100201218     C                   Z-ADD     PRAM          ZAMTCI
264200201218     C                   CALLB     'ZCONVZ1'
264300201218     C                   PARM                    ZAMTCI           15 0
264400201218     C                   PARM                    ZEXCH            13 8
264500201218     C                   PARM                    ZMD               1
264600201218     C                   PARM                    ZCCYI             3
264700201218     C                   PARM                    ZCCYO             3
264800201218     C                   PARM                    ZCDPI             1 0
264900201218     C                   PARM                    ZCDPO             1 0
265000201218     C                   PARM                    ZAMTCO           15 0
265100201218     C                   Z-ADD     ZAMTCO        WXAAMF
265200201218      *
265300201218      ** If rollover date is less than or equal to the value date of
265400201218      ** the amendment and there is a rollover of facility exchange
265500201218      ** rate, use the new facility exchange rate defined.
265600201218     C     LO_RLDT       IFLT      WRNDAY
265700201218     C     LO_RLDT       ANDNE     0
265800201218     C     LO_NFCE       ANDNE     0
265900201218     C     LO_NCCY       ANDEQ     *BLANKS
266000201218     C     LO_NFMD       IFEQ      'D'
266100201218     C     LO_NFCE       DIV(H)    POWR(CX)      WNFCE
266200201218     C                   ELSE
266300201218     C     LO_NFCE       MULT(H)   POWR(CX)      WNFCE
266400201218     C                   ENDIF
266500201218     C     PRAM          MULT(H)   WNFCE         ILAAMF
266600201218     C                   ENDIF
266700201218     C                   ENDIF
266800201218
266900201218     C                   ENDIF
267000201218     C                   ENDIF
267100201218      *
267200201218      ** Set up fields for value date updating
267300201218      ** Also update availability of a prime facility without recourse
267400201218     C                   Z-ADD     LAVDAT        DAYNO             5 0
267500201218      *
267600201218     C     LACHTP        IFEQ      'I'
267700201218      *
267800201218     C     WSOLD         IFEQ      *BLANK
267900201218     C     WLPFI         ANDEQ     *BLANK
268000201218      *
268100201218     C     WPART         OREQ      'Y'
268200201218     C                   MOVE      '0'           *IN93
268300201218     C                   ELSE
268400201218     C                   MOVE      '1'           *IN93
268500201218     C                   ENDIF
268600201218      *
268700201218     C                   ENDIF
268800201218      *
268900201218     C     LACHTP        IFEQ      'R'
269000201218      *
269100201218     C     WSOLD         IFEQ      *BLANK
269200201218     C     WLPFI         ANDEQ     *BLANK
269300201218      *
269400201218     C     WPART         OREQ      'Y'
269500201218     C                   MOVE      '1'           *IN93
269600201218     C                   ELSE
269700201218     C                   MOVE      '0'           *IN93
269800201218     C                   ENDIF
269900201218      *
270000201218     C                   ENDIF
270100201218      *
270200201218     C                   IF        CLE134 = 'Y'   AND                                       AR656363
270300201218     C                             WUpdExpo= 'Y'   OR                                       AR656363
270400201218     C                             CLE134 = 'N'                                             AR656363
270500201218     C                   Z-ADD     ILAAMF        FCBAL            13 0
270600201218     C                   ELSE                                                               AR656363
270700201218     C                   Z-ADD     0             ILAAMF                                     AR656363
270800201218     C                   Z-ADD     0             FCBAL                                      AR656363
270900201218     C                   Z-ADD     0             WXAAMF                                     AR656363
271000201218     C                   ENDIF                                                              AR656363
271100201218      *
271200201218      * Load arrays
271300201218     C                   Eval      FB_RUN0 =  FA_RUN0
271400201218     C                   Eval      FB_RUN1 =  FA_RUN1
271500201218     C                   Eval      FB_RUN2 =  FA_RUN2
271600201218     C                   Eval      FB_RUN3 =  FA_RUN3
271700201218     C                   Eval      FB_RUN4 =  FA_RUN4
271800201218     C                   Eval      FB_RUN5 =  FA_RUN5
271900201218     C                   Eval      FB_RUN6 =  FA_RUN6
272000201218     C                   Eval      FB_RUN7 =  FA_RUN7
272100201218     C                   Eval      FB_RUN8 =  FA_RUN8
272200201218     C                   Eval      FB_RUN9 =  FA_RUN9
272300201218
272400201218     C                   IF        CLE025 = 'N'                                               CLE025
272500201218     C                   Eval      FB_OAM1 =  FA_OAM1
272600201218     C                   Eval      FB_OAM2 =  FA_OAM2
272700201218     C                   Eval      FB_OAM3 =  FA_OAM3
272800201218     C                   Eval      FB_OAM4 =  FA_OAM4
272900201218     C                   Eval      FB_OAM5 =  FA_OAM5
273000201218     C                   Eval      FB_OAM6 =  FA_OAM6
273100201218     C                   Eval      FB_OAM7 =  FA_OAM7
273200201218     C                   Eval      FB_OAM8 =  FA_OAM8
273300201218     C                   Eval      FB_OAM9 =  FA_OAM9
273400201218     C                   Eval      FB_OA10 =  FA_OA10
273500201218     C                   ENDIF                                                                CLE025
273600201218      *
273700201218     C     WPART         IFEQ      'Y'
273800201218      *
273900201218     C     WLPFI         OREQ      *BLANK
274000201218     C     WSOLD         ANDEQ     'Y'
274100201218     C     RCSIC         ANDNE     'Y'
274200201218      *
274300201218     C     WLPFI         OREQ      *BLANK
274400201218     C     WSOLD         ANDEQ     *BLANK
274500201218     C     DDACTN        ANDNE     'X'                                                        243275
274600201218     C                   EXSR      QFCLTY
274700201218     C                   ENDIF
274800201218      *
274900201218      ** Reverse exposure update procedure for:
275000201218      ** Prime facility - if Participant is Internal (for Parts Purch)
275100201218      ** or participant is parts sold
275200201218      ** Participant facility - for Parts Sold
275300201218      ** Update prime facility only when recourse N, like a part sold
275400201218      ** Internal and funding participants should be updated like a
275500201218      ** normal loan
275600201218      ** Non-syndicated loans would be updated as they currently are
275700201218     C     LAVDAT        IFLE      WRNDAY
275800201218      *
275900201218     C     PTYPA         IFEQ      66
276000201218     C     WLPFI         ANDEQ     *BLANK
276100201218      *
276200201218     C     PTYPA         OREQ      69
276300201218     C     WLPFI         ANDEQ     *BLANK
276400201218     C     CLE005        ANDEQ     'Y'
276500201218      *
276600201218     C     PTYPA         OREQ      67
276700201218     C     WLPFI         ANDEQ     *BLANK
276800201218      *
276900201218     C     CLE005        OREQ      'Y'
277000201218     C     WLPFI         ANDEQ     *BLANK
277100201218     C     PTYPA         ANDEQ     72
277200201218     C     WSPTYP        ANDEQ     66
277300201218      *
277400201218     C     CLE005        OREQ      'Y'
277500201218     C     WLPFI         ANDEQ     *BLANK
277600201218     C     PTYPA         ANDEQ     72
277700201218     C     WSPTYP        ANDEQ     67
277800201218      *
277900201218     C     CLE005        OREQ      'Y'
278000201218     C     WLPFI         ANDEQ     *BLANK
278100201218     C     PTYPA         ANDEQ     72
278200201218     C     WSPTYP        ANDEQ     69
278300201218      *
278400201218     C     WPART         OREQ      'N'
278500201218     C     WLPFI         ANDEQ     'I'
278600201218     C     PTYPA         ANDEQ     64
278700201218      *
278800201218     C     WPART         OREQ      'N'
278900201218     C     WLPFI         ANDEQ     'I'
279000201218     C     PTYPA         ANDEQ     65
279100201218      *
279200201218     C     WPART         OREQ      'N'
279300201218     C     WLPFI         ANDEQ     'P'
279400201218     C     PTYPA         ANDEQ     66
279500201218      *
279600201218     C     WPART         OREQ      'N'
279700201218     C     WLPFI         ANDEQ     'P'
279800201218     C     PTYPA         ANDEQ     69
279900201218     C     CLE005        ANDEQ     'Y'
280000201218      *
280100201218     C     WPART         OREQ      'N'
280200201218     C     WLPFI         ANDEQ     'P'
280300201218     C     PTYPA         ANDEQ     67
280400201218      *
280500201218     C     CLE005        OREQ      'Y'
280600201218     C     WPART         ANDEQ     'N'
280700201218     C     WLPFI         ANDEQ     'P'
280800201218     C     PTYPA         ANDEQ     72
280900201218     C     WSPTYP        ANDEQ     66
281000201218      *
281100201218     C     CLE005        OREQ      'Y'
281200201218     C     WPART         ANDEQ     'N'
281300201218     C     WLPFI         ANDEQ     'P'
281400201218     C     PTYPA         ANDEQ     72
281500201218     C     WSPTYP        ANDEQ     67
281600201218      *
281700201218     C     CLE005        OREQ      'Y'
281800201218     C     WPART         ANDEQ     'N'
281900201218     C     WLPFI         ANDEQ     'P'
282000201218     C     PTYPA         ANDEQ     72
282100201218     C     WSPTYP        ANDEQ     69
282200201218      *
282300201218     C     PTYPA         IFEQ      66
282400201218     C     RCSIC         ANDNE     'Y'
282500201218     C     WLPFI         ANDEQ     *BLANK
282600201218      *
282700201218     C     PTYPA         OREQ      67
282800201218     C     RCSIC         ANDNE     'Y'
282900201218     C     WLPFI         ANDEQ     *BLANK
283000201218      *
283100201218     C     PTYPA         OREQ      69
283200201218     C     RCSIC         ANDNE     'Y'
283300201218     C     WLPFI         ANDEQ     *BLANK
283400201218     C     CLE005        ANDEQ     'Y'
283500201218      *
283600201218     C     CLE005        OREQ      'Y'
283700201218     C     RCSIC         ANDNE     'Y'
283800201218     C     PTYPA         ANDEQ     72
283900201218     C     WSPTYP        ANDEQ     66
284000201218     C     WLPFI         ANDEQ     *BLANK
284100201218      *
284200201218     C     CLE005        OREQ      'Y'
284300201218     C     RCSIC         ANDNE     'Y'
284400201218     C     PTYPA         ANDEQ     72
284500201218     C     WSPTYP        ANDEQ     67
284600201218     C     WLPFI         ANDEQ     *BLANK
284700201218      *
284800201218     C     CLE005        OREQ      'Y'
284900201218     C     RCSIC         ANDNE     'Y'
285000201218     C     PTYPA         ANDEQ     72
285100201218     C     WSPTYP        ANDEQ     69
285200201218     C     WLPFI         ANDEQ     *BLANK
285300201218      *
285400201218     C     PTYPA         OREQ      66
285500201218     C     RCSIC         ANDNE     'Y'
285600201218     C     WLPFI         ANDEQ     'P'
285700201218     C     WPART         ANDEQ     'N'
285800201218      *
285900201218     C     PTYPA         OREQ      67
286000201218     C     RCSIC         ANDNE     'Y'
286100201218     C     WLPFI         ANDEQ     'P'
286200201218     C     WPART         ANDEQ     'N'
286300201218      *
286400201218     C     PTYPA         OREQ      69
286500201218     C     CLE005        ANDEQ     'Y'
286600201218     C     RCSIC         ANDNE     'Y'
286700201218     C     WLPFI         ANDEQ     'P'
286800201218     C     WPART         ANDEQ     'N'
286900201218      *
287000201218     C     PTYPA         OREQ      72
287100201218     C     CLE005        ANDEQ     'Y'
287200201218     C     RCSIC         ANDNE     'Y'
287300201218     C     WLPFI         ANDEQ     'P'
287400201218     C     WPART         ANDEQ     'N'
287500201218      *                                                                                       CLE106
287600201218     C     WPART         OREQ      'N'                                                        CLE106
287700201218     C     WLPFI         ANDEQ     'S'                                                        CLE106
287800201218     C     PTYPA         ANDEQ     66                                                         CLE106
287900201218      *                                                                                       CLE106
288000201218     C     WPART         OREQ      'N'                                                        CLE106
288100201218     C     WLPFI         ANDEQ     'S'                                                        CLE106
288200201218     C     PTYPA         ANDEQ     67                                                         CLE106
288300201218      *                                                                                       CLE106
288400201218     C     WPART         OREQ      'N'                                                        CLE106
288500201218     C     WLPFI         ANDEQ     'S'                                                        CLE106
288600201218     C     PTYPA         ANDEQ     69                                                         CLE106
288700201218      *                                                                                       CLE106
288800201218     C     WPART         OREQ      'N'                                                        CLE106
288900201218     C     WLPFI         ANDEQ     'S'                                                        CLE106
289000201218     C     PTYPA         ANDEQ     72                                                         CLE106
289100201218     C     WSPTYP        ANDEQ     66                                                         CLE106
289200201218      *                                                                                       CLE106
289300201218     C     WPART         OREQ      'N'                                                        CLE106
289400201218     C     WLPFI         ANDEQ     'S'                                                        CLE106
289500201218     C     PTYPA         ANDEQ     72                                                         CLE106
289600201218     C     WSPTYP        ANDEQ     67                                                         CLE106
289700201218      *                                                                                       CLE106
289800201218     C     WPART         OREQ      'N'                                                        CLE106
289900201218     C     WLPFI         ANDEQ     'S'                                                        CLE106
290000201218     C     PTYPA         ANDEQ     72                                                         CLE106
290100201218     C     WSPTYP        ANDEQ     69                                                         CLE106
290200201218      *                                                                                       CLE106
290300201218     C     WPART         OREQ      'N'                                                        CLE106
290400201218     C     WLPFI         ANDEQ     'R'                                                        CLE106
290500201218     C     PTYPA         ANDEQ     66                                                         CLE106
290600201218      *                                                                                       CLE106
290700201218     C     WPART         OREQ      'N'                                                        CLE106
290800201218     C     WLPFI         ANDEQ     'R'                                                        CLE106
290900201218     C     PTYPA         ANDEQ     72                                                         CLE106
291000201218      *                                                                                       243275
291100201218     C     DDACTN        IFNE      'X'                                                        243275
291200201218      *
291300201218     C     LACHTP        IFEQ      'I'
291400201218     C     CLE023        ANDEQ     'N'
291500201218     C     CLE025        ANDEQ     'N'                                                        CLE025
291600201218     C     FA_CAMD       SUB       ILAAMF        FA_CAMD
291700201218     C                   ENDIF
291800201218      *
291900201218     C     LACHTP        IFEQ      'R'
292000201218     C     CLE023        ANDEQ     'N'
292100201218     C     CLE025        ANDEQ     'N'                                                        CLE025
292200201218     C     FA_CAMD       ADD       ILAAMF        FA_CAMD
292300201218     C                   ENDIF
292400201218      *
292500201218      ** If CLE023 is on, update Current Exposure based on spot rate.
292600201218     C     CLE023        IFEQ      'Y'
292700201218     C     CLE025        ANDEQ     'N'                                                        CLE025
292800201218     C     LACHTP        IFEQ      'I'
292900201218     C     FA_CEXP       SUB       WXAAMF        FA_CEXP
293000201218     C                   ENDIF
293100201218     C     LACHTP        IFEQ      'R'
293200201218     C     FA_CEXP       ADD       WXAAMF        FA_CEXP
293300201218     C                   ENDIF
293400201218     C                   ENDIF
293500201218      *                                                                                       243275
293600201218     C                   ENDIF                                                                243275
293700201218      *
293800201218      ** If CLE009 is installed, set Work Regeneration Indicator to
293900201218      ** changed
294000201218     C     CLE009        IFEQ      'Y'
294100201218     C                   MOVE      'C'           WKSWRI            1
294200201218     C                   ENDIF
294300201218      *
294400201218     C                   ENDIF
294500201218      *
294600201218     C                   ELSE
294700201218      *
294800201218     C     PTYPA         IFEQ      66
294900201218      *
295000201218     C     PTYPA         OREQ      67
295100201218      *
295200201218     C     PTYPA         OREQ      69
295300201218     C     CLE005        ANDEQ     'Y'
295400201218      *
295500201218     C     CLE005        OREQ      'Y'
295600201218     C     RCSIC         ANDNE     'Y'
295700201218     C     PTYPA         ANDEQ     72
295800201218     C     WSPTYP        ANDEQ     66
295900201218      *
296000201218     C     CLE005        OREQ      'Y'
296100201218     C     RCSIC         ANDNE     'Y'
296200201218     C     PTYPA         ANDEQ     72
296300201218     C     WSPTYP        ANDEQ     67
296400201218      *
296500201218     C     CLE005        OREQ      'Y'
296600201218     C     RCSIC         ANDNE     'Y'
296700201218     C     PTYPA         ANDEQ     72
296800201218     C     WSPTYP        ANDEQ     69
296900201218      *
297000201218     C     PTYPA         ORNE      66
297100201218     C     PTYPA         ANDNE     67
297200201218     C     PTYPA         ANDNE     69
297300201218     C     PTYPA         ANDNE     72
297400201218      *                                                                                       CLE106
297500201218     C     WPART         OREQ      'N'                                                        CLE106
297600201218     C     WLPFI         ANDEQ     'S'                                                        CLE106
297700201218     C     PTYPA         ANDEQ     66                                                         CLE106
297800201218     C     RCSIC         ANDNE     'Y'                                                        CLE106
297900201218      *                                                                                       CLE106
298000201218     C     WPART         OREQ      'N'                                                        CLE106
298100201218     C     WLPFI         ANDEQ     'S'                                                        CLE106
298200201218     C     PTYPA         ANDEQ     67                                                         CLE106
298300201218     C     RCSIC         ANDNE     'Y'                                                        CLE106
298400201218      *                                                                                       CLE106
298500201218     C     WPART         OREQ      'N'                                                        CLE106
298600201218     C     WLPFI         ANDEQ     'S'                                                        CLE106
298700201218     C     PTYPA         ANDEQ     69                                                         CLE106
298800201218     C     RCSIC         ANDNE     'Y'                                                        CLE106
298900201218      *                                                                                       CLE106
299000201218     C     WPART         OREQ      'N'                                                        CLE106
299100201218     C     WLPFI         ANDEQ     'S'                                                        CLE106
299200201218     C     PTYPA         ANDEQ     72                                                         CLE106
299300201218     C     RCSIC         ANDNE     'Y'                                                        CLE106
299400201218      *                                                                                       CLE106
299500201218     C     WPART         OREQ      'N'                                                        CLE106
299600201218     C     WLPFI         ANDEQ     'R'                                                        CLE106
299700201218     C     PTYPA         ANDEQ     72                                                         CLE106
299800201218     C     RCSIC         ANDNE     'Y'                                                        CLE106
299900201218      *                                                                                       243275
300000201218     C     DDACTN        IFNE      'X'                                                        243275
300100201218      *
300200201218     C     LACHTP        IFEQ      'I'
300300201218     C     CLE025        ANDEQ     'N'                                                        CLE025
300400201218     C     FA_CAMD       ADD       ILAAMF        FA_CAMD
300500201218     C                   ENDIF
300600201218      *
300700201218     C     LACHTP        IFEQ      'R'
300800201218     C     CLE025        ANDEQ     'N'                                                        CLE025
300900201218     C     FA_CAMD       SUB       ILAAMF        FA_CAMD
301000201218     C                   ENDIF
301100201218      *
301200201218      ** If CLE023 is on, update current exposure based on spot rate.
301300201218     C     CLE023        IFEQ      'Y'
301400201218     C     CLE025        ANDEQ     'N'                                                        CLE025
301500201218     C     LACHTP        IFEQ      'I'
301600201218     C     FA_CEXP       ADD       WXAAMF        FA_CEXP
301700201218     C                   ENDIF
301800201218     C     LACHTP        IFEQ      'R'
301900201218     C     FA_CEXP       SUB       WXAAMF        FA_CEXP
302000201218     C                   ENDIF
302100201218     C                   ENDIF
302200201218      *                                                                                       243275
302300201218     C                   ENDIF                                                                243275
302400201218      *
302500201218      ** If CLE009 is installed, set Work Regeneration Indicator to
302600201218      ** changed
302700201218     C     CLE009        IFEQ      'Y'
302800201218     C                   MOVE      'C'           WKSWRI            1
302900201218     C                   ENDIF
303000201218      *
303100201218     C                   ENDIF
303200201218      *
303300201218     C                   ENDIF
303400201218      *
303500201218     C                   ENDIF
303600201218      *
303700201218      ** Also update availability of a prime facility without recourse
303800201218     C     FA_RVCR       IFEQ      'Y'
303900201218     C                   Z-ADD     LO_MDAT       DAYNO
304000201218      *
304100201218     C     LACHTP        IFEQ      'I'
304200201218      *
304300201218     C     WSOLD         IFEQ      *BLANK
304400201218     C     WLPFI         ANDEQ     *BLANK
304500201218      *
304600201218     C     WPART         OREQ      'Y'
304700201218     C                   MOVE      '1'           *IN93
304800201218     C                   ELSE
304900201218     C                   MOVE      '0'           *IN93
305000201218     C                   ENDIF
305100201218      *
305200201218     C                   ENDIF
305300201218      *
305400201218     C     LACHTP        IFEQ      'R'
305500201218      *
305600201218     C     WSOLD         IFEQ      *BLANK
305700201218     C     WLPFI         ANDEQ     *BLANK
305800201218      *
305900201218     C     WPART         OREQ      'Y'
306000201218     C                   MOVE      '0'           *IN93
306100201218     C                   ELSE
306200201218     C                   MOVE      '1'           *IN93
306300201218     C                   ENDIF
306400201218      *
306500201218     C                   ENDIF
306600201218      *
306700201218     C                   Z-ADD     ILAAMF        FCBAL
306800201218      *
306900201218     C     DAYNO         IFNE      0
307000201218      *
307100201218     C     WPART         IFEQ      'Y'
307200201218      *
307300201218     C     WLPFI         OREQ      *BLANK
307400201218     C     WSOLD         ANDEQ     'Y'
307500201218     C     RCSIC         ANDNE     'Y'
307600201218     C     CLE023        ANDEQ     'N'
307700201218      *
307800201218     C     WLPFI         OREQ      *BLANK
307900201218     C     WSOLD         ANDEQ     *BLANK
308000201218     C     DDACTN        ANDNE     'X'                                                        243275
308100201218     C                   EXSR      QFCLTY
308200201218     C                   ENDIF
308300201218      *
308400201218     C                   ENDIF
308500201218      *
308600201218     C                   ENDIF
308700201218      *
308800201218     C     ENDFAC        ENDSR
308900201218      *****************************************************************
309000201218      /EJECT
309100201218      *****************************************************************
309200201218      * SRUPCA  -  Update of credit agreement/superfacility           *
309300201218      *****************************************************************
309400201218     C     SRUPCA        BEGSR
309500201218      *
309600201218      ** Save the revolving credit indicator of the tranche
309700201218     C     CLE014        IFEQ      'Y'
309800201218     C                   MOVE      FA_RVCR       WRVCR             1
309900201218     C                   ENDIF
310000201218      *
310100201218      ** Whenever the facility utilisation is updated for a tranche,
310200201218      ** update the credit agreement/superfacility as well
310300201218     C                   MOVE      FA_FCCY       WTCCY             3
310400201218     C                   MOVEL     FA_CANM       WFCNM
310500201218     C                   MOVEL     FA_CAFT       WFACT
310600201218     C                   MOVEL     FA_CAFN       WFNUM
310700201218     C                   MOVE      'A'           WFRTP
310800201218      *
310900201218     C                   MOVE      FA_CMDI       WCMDI             1
311000201218     C                   Z-ADD     FA_CAXR       WCAXR            13 8
311100201218      *
311200201218     C     KFCLT         CHAIN(N)  FCLTY                              99
311300201218      *
311400201218     C     *IN99         IFEQ      '1'
311500201218     C                   MOVEL     'FCLTY   '    DBFILE                         ************
311600201218     C                   Z-ADD     25            DBASE                          * DBERR 25 *
311700201218     C                   MOVEL     FCLKEY        DBKEY                          ************
311800201218     C                   EXSR      *PSSR
311900201218     C                   ENDIF
312000201218      *
312100201218     C                   MOVE      'B'           WFRTP
312200201218     C     KFCLT         CHAIN     FCLTY                              99
312300201218      *
312400201218     C     *IN99         IFEQ      '1'
312500201218     C                   MOVEL     'FCLTY   '    DBFILE                         ************
312600201218     C                   Z-ADD     26            DBASE                          * DBERR 26 *
312700201218     C                   MOVEL     FCLKEY        DBKEY                          ************
312800201218     C                   EXSR      *PSSR
312900201218     C                   ENDIF
313000201218      *
313100201218      ** If tranche and superfacility currencies are different, get
313200201218      ** superfacility currency details
313300201218     C     WTCCY         IFNE      FA_FCCY
313400201218     C                   CALLB     'AOCURRR0'
313500201218     C                   PARM      *BLANKS       @RtCd
313600201218     C                   PARM      '*KEY   '     @Optn
313700201218     C                   PARM      FA_FCCY       @Curr
313800201218     C     SDCURR        PARM                    DSSDY
313900201218      *
314000201218     C     @RtCd         IFNE      *BLANKS
314100201218     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
314200201218     C                   Z-ADD     27            DBASE                          * DBERR 27 *
314300201218     C                   MOVEL     FA_FCCY       DBKEY                          ************
314400201218     C                   EXSR      *PSSR
314500201218     C                   ENDIF
314600201218      *
314700201218      ** Save superfacility currency details and obtain the cross exchange rate.
314800201218     C     CLE023        IFEQ      'Y'
314900201218     C                   MOVE      WCCYF         ZCCYI
315000201218     C                   Z-ADD     WSPRTF        ZRATE1
315100201218     C                   MOVE      WMDINF        ZMDI1
315200201218     C                   Z-ADD     WCDPF         ZCDPI
315300201218     C                   MOVE      FA_FCCY       ZCCYO
315400201218     C                   Z-ADD     A6SPRT        ZRATE2
315500201218     C                   MOVE      A6MDIN        ZMDI2
315600201218     C                   MOVE      A6NBDP        ZCDPO
315700201218
315800201218     C                   CALLB     'ZXRATE'
315900201218     C                   PARM                    ZRATE1
316000201218     C                   PARM                    ZMDI1
316100201218     C                   PARM                    ZRATE2
316200201218     C                   PARM                    ZMDI2
316300201218     C                   PARM                    ZRATEX
316400201218     C                   PARM                    ZMDIX
316500201218     C                   Z-ADD     ZRATEX        ZEXCH
316600201218     C                   MOVE      ZMDIX         ZMD
316700201218     C                   ENDIF
316800201218      *
316900201218      ** Convert facility amount to credit facility currency
317000201218     C                   Z-ADD     A6NBDP        CDPC              1 0
317100201218     C     CDPC          SUB       CDPF          CX
317200201218     C     CX            ADD       4             CX
317300201218      *
317400201218     C     WCMDI         IFEQ      'D'
317500201218     C     WCAXR         DIV(H)    POWR(CX)      OFCXRT
317600201218     C     1             DIV       OFCXRT        OFCXRT
317700201218     C                   ELSE
317800201218     C     WCAXR         MULT(H)   POWR(CX)      OFCXRT
317900201218     C                   ENDIF
318000201218      *
318100201218     C     FCBAL         MULT(H)   OFCXRT        ILAAMF           13 0
318200201218      *
318300201218      ** If CLE023 is ON convert amount using spot rate.
318400201218     C     CLE023        IFEQ      'Y'
318500201218     C                   Z-ADD     WXAAMF        ZAMTCI
318600201218     C                   CALLB     'ZCONVZ1'
318700201218     C                   PARM                    ZAMTCI           15 0
318800201218     C                   PARM                    ZEXCH            13 8
318900201218     C                   PARM                    ZMD               1
319000201218     C                   PARM                    ZCCYI             3
319100201218     C                   PARM                    ZCCYO             3
319200201218     C                   PARM                    ZCDPI             1 0
319300201218     C                   PARM                    ZCDPO             1 0
319400201218     C                   PARM                    ZAMTCO           15 0
319500201218      *
319600201218     C                   Z-ADD     ZAMTCO        WXAAMF
319700201218     C                   ENDIF
319800201218     C                   ENDIF
319900201218      *
320000201218      ** Restore the revolving credit indicator
320100201218     C     CLE014        IFEQ      'Y'
320200201218     C     FA_RVCR       ANDEQ     'T'
320300201218     C                   MOVE      WRVCR         FA_RVCR
320400201218     C                   ENDIF
320500201218      *
320600201218      ** Update facility exposure and availability
320700201218     C                   MOVE      'Y'           WTRCA             1
320800201218     C                   IF        CLE134 = 'Y'                                             AR656363
320900201218     C                   EVAL      WUpdExpo = 'Y'                                           AR656363
321000201218     C                   EXSR      SrPDCLPI                                                 AR656363
321100201218     C                   ENDIF                                                              AR656363
321200201218                                                                                            AR656363
321300201218     C                   EXSR      FCLTSR
321400201218      *
321500201218     C                   IF        CLE025 = 'N'                                               CLE025
321600201218     C                   Eval      FA_OAM1 =  FB_OAM1
321700201218     C                   Eval      FA_OAM2 =  FB_OAM2
321800201218     C                   Eval      FA_OAM3 =  FB_OAM3
321900201218     C                   Eval      FA_OAM4 =  FB_OAM4
322000201218     C                   Eval      FA_OAM5 =  FB_OAM5
322100201218     C                   Eval      FA_OAM6 =  FB_OAM6
322200201218     C                   Eval      FA_OAM7 =  FB_OAM7
322300201218     C                   Eval      FA_OAM8 =  FB_OAM8
322400201218     C                   Eval      FA_OAM9 =  FB_OAM9
322500201218     C                   Eval      FA_OA10 =  FB_OA10
322600201218     C                   ENDIF                                                                CLE025
322700201218
322800201218     C                   Z-ADD     WRNDAY        LCD
322900201218     C                   MOVE      'A'           CHTP
323000201218     C                   Z-ADD     LATNLU        TNLU
323100201218     C                   UPDATE    FCLTYFNF
323200201218     C                   MOVE      *BLANK        WTRCA
323300201218      *
323400201218     C                   ENDSR
323500201218      *****************************************************************
323600201218      /EJECT
323700201218      *****************************************************************
323800201218      * QFCLTY  -  Update Exposure Array                              *
323900201218      *****************************************************************
324000201218     C     QFCLTY        BEGSR
324100201218      *
324200201218     C     DAYNO         IFNE      0
324300201218     C                   Z-ADD     1             Z                 2 0
324400201218     C     DAYNO         LOOKUP    FB_RUN(Z)                          92  92
324500201218     C  N92              GOTO      ENDFCT
324600201218      *
324700201218     C     LOOPZ1        TAG
324800201218      *
324900201218     C     Z             COMP      11                                   92
325000201218      *
325100201218      ** Don't update beyond the expiry date
325200201218     C     *IN92         IFEQ      *ON
325300201218     C     FB_RUN(Z)     ANDGE     FA_DTEX
325400201218     C                   GOTO      ENDFCT
325500201218     C                   ENDIF
325600201218      *
325700201218     C  N92              GOTO      ENDFCT
325800201218      *
325900201218     C                   IF        CLE025 = 'N'                                               CLE025
326000201218     C   93FB_OAM(Z)     SUB       FCBAL         FB_OAM(Z)
326100201218     C  N93FB_OAM(Z)     ADD       FCBAL         FB_OAM(Z)
326200201218     C                   ENDIF                                                                CLE025
326300201218      *
326400201218      ** If CLE009 is installed, set Work Regeneration Indicator to
326500201218      ** changed
326600201218     C     CLE009        IFEQ      'Y'
326700201218     C                   MOVE      'C'           WKSWRI            1
326800201218     C                   ENDIF
326900201218      *
327000201218     C     Z             ADD       1             Z
327100201218     C                   GOTO      LOOPZ1
327200201218     C                   ENDIF
327300201218      *
327400201218     C     ENDFCT        ENDSR
327500201218      *****************************************************************
327600201218      /EJECT
327700201218      *****************************************************************
327800201218      * SRFEES  -  Update Fees File                                   *
327900201218      *****************************************************************
328000201218     C     SRFEES        BEGSR
328100201218      *
328200201218      ** If authorisation switchable feature is on and action code
328300201218      ** is insert or amend and Loans amendment authorisations is
328400201218      ** required
328500201218     C     CLE002        IFEQ      'Y'
328600201218     C     LACHTP        ANDNE     'X'
328700201218     C     LACHTP        ANDNE     'R'
328800201218     C     BPLMAU        ANDEQ     'Y'
328900201218      *
329000201218      ** If action code is insert
329100201218      *
329200201218     C     LACHTP        IFEQ      'I'
329300201218      *
329400201218      ** Write a record to Loan Amendment Fee Index File
329500201218     C                   MOVE      LALNRF        FFLNRF
329600201218     C                   Z-ADD     LAVDAT        FFVDAT
329700201218     C                   MOVE      LALASN        FFLASN
329800201218     C                   MOVE      *BLANKS       FFAUTH
329900201218     C                   MOVE      WKSWRI        FFSWRI
330000201218     C                   WRITE     LEFELAD0
330100201218     C                   ENDIF
330200201218      *
330300201218      ** If action code is amend
330400201218     C     LACHTP        IFEQ      'A'
330500201218      *
330600201218      ** Chain to Loan Amendment Fee Index File
330700201218     C                   MOVE      LALNRF        WKLOAN
330800201218     C                   Z-ADD     LAVDAT        WKDAY
330900201218     C                   MOVE      LALASN        WKSEQN
331000201218     C     KIDXF         CHAIN     LEFELAL0                           99
331100201218      *
331200201218      ** If record not found
331300201218     C     *IN99         IFEQ      *ON
331400201218      *
331500201218      ** Write a record to Loan Fee Index File
331600201218     C                   MOVE      LALNRF        FFLNRF
331700201218     C                   Z-ADD     LAVDAT        FFVDAT
331800201218     C                   MOVE      LALASN        FFLASN
331900201218     C                   MOVE      'Y'           FFAUTH
332000201218     C                   MOVE      WKSWRI        FFSWRI
332100201218     C                   WRITE     LEFELAD0
332200201218     C                   ELSE
332300201218      *
332400201218      ** If work regeneration indicator is changed and regeneration
332500201218      ** indicator is blank
332600201218     C     WKSWRI        IFEQ      'C'
332700201218     C     FFSWRI        ANDEQ     *BLANKS
332800201218      *
332900201218      ** Update the record to Loan Amendment Fee Index File
333000201218     C                   MOVE      WKSWRI        FFSWRI
333100201218     C                   UPDATE    LEFELAD0
333200201218     C                   ENDIF
333300201218      *
333400201218     C                   ENDIF
333500201218      *
333600201218     C                   ENDIF
333700201218      *
333800201218     C                   ELSE
333900201218      *
334000201218      ** If action code is authorise
334100201218     C     LACHTP        IFEQ      'X'
334200201218      *
334300201218      ** Chain to Loan Amendment Fee Index File
334400201218     C                   MOVE      LALNRF        WKLOAN
334500201218     C                   Z-ADD     LAVDAT        WKDAY
334600201218     C                   MOVE      LALASN        WKSEQN
334700201218     C     KIDXF         CHAIN     LEFELAL0                           99
334800201218      *
334900201218      ** If record is found
335000201218     C     *IN99         IFEQ      *OFF
335100201218      *
335200201218      ** Update the record to Loan Amendment Fee Index File
335300201218     C                   MOVE      FFSWRI        WKSWRI
335400201218     C                   MOVE      'Y'           FFAUTH
335500201218     C                   UPDATE    LEFELAD0
335600201218     C                   ENDIF
335700201218      *
335800201218     C                   ENDIF
335900201218      *
336000201218      ** If action code is reverse
336100201218     C     LACHTP        IFEQ      'R'
336200201218      *
336300201218      ** Chain to Loan Amendment Fee Index File
336400201218     C                   MOVE      LALNRF        WKLOAN
336500201218     C                   Z-ADD     LAVDAT        WKDAY
336600201218     C                   MOVE      LALASN        WKSEQN
336700201218     C     KIDXF         CHAIN     LEFELAL0                           99
336800201218      *
336900201218      ** If record is found
337000201218     C     *IN99         IFEQ      *OFF
337100201218      *
337200201218      ** If authorised is blank
337300201218     C     FFAUTH        IFEQ      *BLANKS
337400201218     C                   MOVE      *BLANKS       WKSWRI
337500201218     C                   ELSE
337600201218      *
337700201218      ** If work regeneration indicator is blank
337800201218     C     WKSWRI        IFEQ      *BLANKS
337900201218     C                   MOVE      FFSWRI        WKSWRI
338000201218     C                   ENDIF
338100201218      *
338200201218     C                   ENDIF
338300201218      *
338400201218     C                   ENDIF
338500201218      *
338600201218     C                   ENDIF
338700201218      *
338800201218      ** If work regeneration indicator is changed
338900201218     C     WKSWRI        IFEQ      'C'
339000201218      *
339100201218      ** Check if the facility has an associated fee
339200201218     C                   MOVE      WFACT         CHFACT            3
339300201218     C                   MOVE      WFNUM         CHFCNO            2
339400201218     C     CHFACT        CAT       CHFCNO        CHFACL            5
339500201218     C                   MOVE      CHFACL        WFFACL
339600201218     C**********         Z-ADD     0             WFLOAN                                       CLE148
339700201218     C                   MOVEL     *BLANKS       WFLOAN                                       CLE148
339800201218     C     WKFEE         SETLL     LEFEEDL1
339900201218     C*****WKFEE         READE     LEFEEDL1                               99                MD023203
340000201218     C     WKFEE         READE (N) LEFEEDL1                               99                MD023203
340100201218      *
340200201218      ** Do while an associated fee exists
340300201218     C     *IN99         DOWEQ     *OFF
340400201218      *
340500201218     C                   MOVE      FEAUTO        WFEAUT            1                          CLE134
340600201218     C     CLE134        IFEQ      'Y'                                                        CLE134
340700201218     C     WFEAUT        IFEQ      'C'                                                        CLE134
340800201218     C     FEAUT2        OREQ      'C'                                                        CLE134
340900201218     C                   MOVE      'Y'           WFEAUT            1                          CLE134
341000201218     C                   ENDIF                                                                CLE134
341100201218     C                   ENDIF                                                                CLE134
341200201218                                                                                              CLE134
341300201218      ** If the fee is a confirmed calculated fee and swift
341400201218      ** regeneration indicator is not 'I', 'B', 'H'
341500201218     C*****FEAUTO        IFEQ      'Y'                                                        CLE134
341600201218     C     WFEAUT        IFEQ      'Y'                                                        CLE134
341700201218     C     FECALT        ANDNE     *BLANKS
341800201218     C     FESWRI        ANDNE     'I'
341900201218     C     FESWRI        ANDNE     'B'
342000201218     C     FESWRI        ANDNE     'H'
342100201218      *
342200201218      ** Set currency to fee currency
342300201218      ** Set day to run date
342400201218      ** Set number of working days to telex notice days
342500201218     C                   MOVE      FEFCCY        ZCCY
342600201218     C                   Z-ADD     WRNDAY        ZDAYNO
342700201218     C                   Z-ADD     1             X
342800201218      *                                                                                     MD054317
342900201218      ** If CLE031 is on then use correct currency to access AONOSTR0                       MD054317
343000201218      *                                                                                     MD054317
343100201218     C                   MOVE      FEFCCY        WKCCY             3                        MD054317
343200201218      *                                                                                     MD054317
343300201218     C     CLE031        IFEQ      'Y'                                                      MD054317
343400201218      *                                                                                     MD054317
343500201218     C     PTFI          IFEQ      'P'                                                      MD054317
343600201218     C     FEPSCY        IFNE      *BLANKS                                                  MD054317
343700201218     C                   MOVE      FEPSCY        WKCCY                                      MD054317
343800201218     C                   ENDIF                                                              MD054317
343900201218     C                   ELSE                                                               MD054317
344000201218     C     FESCCY        IFNE      *BLANKS                                                  MD054317
344100201218     C                   MOVE      FESCCY        WKCCY                                      MD054317
344200201218     C                   ENDIF                                                              MD054317
344300201218     C                   ENDIF                                                              MD054317
344400201218      *                                                                                     MD054317
344500201218     C                   ENDIF                                                              MD054317
344600201218      *                                                                                     MD054317
344700201218     C                   MOVE      WKCCY         ZCCY                                       MD054317
344800201218     C                   MOVE      WKCCY         @CURR                                      MD054317
344900201218      *                                                                                     MD054317
345000201218     C*****FEFCCY        LOOKUP    CYA(X)                                 69                MD054317
345100201218     C     WKCCY         LOOKUP    CYA(X)                                 69                MD054317
345200201218     C                   MOVE      *OFF          *IN69
345300201218     C                   MOVE      TND(X)        ZNRDYS
345400201218      *
345500201218      ** If Fee Settlement type is '01', '02', '07', '08' or '12'
345600201218     C     FESTTL        IFEQ      01
345700201218     C     FESTTL        OREQ      02
345800201218     C     FESTTL        OREQ      07
345900201218     C     FESTTL        OREQ      08
346000201218     C     FESTTL        OREQ      12
346100201218      *
346200201218     C                   CALLB     'AONOSTR0'
346300201218     C                   PARM      *BLANKS       @RtCd
346400201218     C                   PARM      '*KEY   '     @Optn
346500201218     C                   PARM                    @Cusn             6
346600201218     C**********         PARM      FEFCCY        @Curr             3                        MD054317
346700201218     C                   PARM                    @Curr             3                        MD054317
346800201218     C**********         PARM                    @Accd             4                          CGL029
346900201218     C                   PARM                    @Accd                                        CGL029
347000201218     C                   PARM                    @Acsn             2
347100201218     C                   PARM      FEOURS        @Nonb             2
347200201218     C                   PARM                    @Brca             3
347300201218     C                   PARM                    @Cssn            10
347400201218     C                   PARM                    @Pnoi             1
347500201218     C     SDNOST        PARM                    DSFDY
347600201218      *
347700201218     C     @RtCd         IFNE      *BLANKS
347800201218     C                   MOVEL     'AONOSTR0'    DBFILE                         ************
347900201218     C                   Z-ADD     28            DBASE                          * DBERR 28 *
348000201218     C                   MOVEL     FEFCCY        DBKEY                          ************
348100201218     C                   EXSR      *PSSR
348200201218     C                   ELSE
348300201218      *
348400201218      ** Set Location to Nostro Location
348500201218     C                   MOVE      A7NOSN        ZLOC
348600201218     C                   ENDIF
348700201218      *
348800201218     C                   ELSE
348900201218      *
349000201218     C                   MOVE      *BLANKS       ZLOC
349100201218      *
349200201218     C                   ENDIF
349300201218      *
349400201218      ** Calculate number of working days forward
349500201218     C                   CALLB     'ZFWDT'
349600201218     C                   PARM                    ZDAYNO            5 0
349700201218     C                   PARM                    ZNRDYS            2 0
349800201218     C                   PARM      *ZERO         ZDYNBR            5 0
349900201218     C                   PARM                    ZCCY              3
350000201218     C                   PARM                    ZLOC              3
350100201218      *
350200201218      ** Set Telex Notice date to day number
350300201218     C                   Z-ADD     ZDYNBR        TXDT              5 0
350400201218      *                                                                                     MD023203
350500201218     C                   MOVEL     FECNUM        WFCNUMX                                    MD023203
350600201218     C                   MOVEL     FEFACL        WFFACLX                                    MD023203
350700201218     C                   MOVEL     FELOAN        WFLOANX                                    MD023203
350800201218     C                   MOVEL     FEFSEQ        WFSEQNX                                    MD023203
350900201218      *
351000201218      ** If next payment date is before or equals to Telex Notice date
351100201218      ** and Next Payment Telex indicator is set to 'Y'
351200201218     C     FENPYD        IFLE      TXDT
351300201218     C     FEPPTI        ANDEQ     'Y'
351400201218      *
351500201218      ** Update Fees file
351600201218     C     WKFEEX        CHAIN     LEFEEDL0                                                 MD023203
351700201218     C                   IF        %FOUND(LEFEEDL0)                                         MD023203
351800201218     C**********         MOVE      'A'           FESWRI                                     MD023203
351900201218     C**********         UPDATE    LEFEEDF                                                  MD023203
352000201218     C                   MOVE      'A'           X_FESWRI                                   MD023203
352100201218     C                   UPDATE    LEFEEDX                                                  MD023203
352200201218     C                   ENDIF                                                              MD023203
352300201218     C                   ELSE
352400201218      *
352500201218      ** If end date is before or equals to Telex Notice date and End
352600201218      ** Telex indicator is set to 'Y'
352700201218     C     FEPEND        IFLE      TXDT
352800201218     C     FEEPTI        ANDEQ     'Y'
352900201218      *
353000201218      ** Update Fees file
353100201218     C     WKFEEX        CHAIN     LEFEEDL0                                                 MD023203
353200201218     C                   IF        %FOUND(LEFEEDL0)                                         MD023203
353300201218     C**********         MOVE      'A'           FESWRI                                     MD023203
353400201218     C**********         UPDATE    LEFEEDF                                                  MD023203
353500201218     C                   MOVE      'A'           X_FESWRI                                   MD023203
353600201218     C                   UPDATE    LEFEEDX                                                  MD023203
353700201218     C                   ENDIF                                                              MD023203
353800201218     C                   ENDIF
353900201218      *
354000201218     C                   ENDIF
354100201218      *
354200201218     C                   ENDIF
354300201218      *
354400201218     C*****WKFEE         READE     LEFEEDL1                               99                MD023203
354500201218     C     WKFEE         READE (N) LEFEEDL1                               99                MD023203
354600201218     C                   ENDDO
354700201218      *                                                                                       CLE073
354800201218      ** Check if the loan has an associated fee                                              CLE073
354900201218      *                                                                                       CLE073
355000201218     C                   IF        CLE073 = 'Y' AND                                           CLE073
355100201218     C                             LAAMTP = 'PI' OR                                           CLE073
355200201218     C                             CLE073 = 'Y' AND                                           CLE073
355300201218     C                             LAAMTP = 'PD'                                              CLE073
355400201218     C                   EXSR      CHKLON                                                     CLE073
355500201218     C                   ENDIF                                                                CLE073
355600201218      *
355700201218     C                   ENDIF
355800201218      *
355900201218     C                   ENDIF
356000201218      *
356100201218     C                   MOVE      *BLANKS       WKSWRI
356200201218      *
356300201218     C                   ENDSR
356400201218      *****************************************************************
356500201218      /EJECT
356600201218      *****************************************************************
356700201218      * SRUSHD  -  Update Shadow Record                               *
356800201218      *****************************************************************
356900201218     C     SRUSHD        BEGSR
357000201218      *                                                                                     MD026167
357100201218     C                   IF        MPHAS = 'C'                                              MD026167
357200201218     C                   LEAVESR                                                            MD026167
357300201218     C                   ENDIF                                                              MD026167
357400201218      *
357500201218      ** Do On-line updates
357600201218     C*****LACHTP        IFEQ      'I'                                                       BUG8566
357700201218     C*****LACHTP        OREQ      'A'                                                       BUG8566
357800201218     C*****LACHTP        OREQ      'R'                                                       BUG8566
357900201218     C     DDACTN        IFEQ      'I'                                                       BUG8566
358000201218     C     DDACTN        OREQ      'A'                                                       BUG8566
358100201218     C     DDACTN        OREQ      'R'                                                       BUG8566
358200201218     C     LACHTP        OREQ      'X'                                                        243415
358300201218     C     CLE055        andeq     'Y'                                                        243415
358400201218     C     LAAMTP        andeq     'PI'                                                       243415
358500201218     C     BPLMAU        andeq     'Y'                                                        243415
358600201218     C     LACHTP        OREQ      'Q'                                                        243415
358700201218     C     CLE030        andeq     'Y'                                                        243415
358800201218     C     CLE055        andeq     'Y'                                                        243415
358900201218     C     LAAMTP        andeq     'PI'                                                       243415
359000201218     C     BPLMAU        andeq     'Y'                                                        243415
359100201218     C     DDACTN        OREQ      'X'                                                     AR1035362
359200201218     C     CLE055        andeq     'Y'                                                     AR1035362
359300201218     C     LAAMTP        andeq     'PI'                                                    AR1035362
359400201218     C     BPLMAU        andeq     'Y'                                                     AR1035362
359500201218      *                                                                                     MD047554
359600201218     C                   EVAL      OLNRF = LALNRF                                           MD047554
359700201218     C                   EVAL      OVDAT = SHVDAT                                           MD047554
359800201218     C                   EVAL      OLASN = SHLASN                                           MD047554
359900201218     C                   EVAL      OMPRAM = PRAM                                            MD047554
360000201218      *
360100201218     C     LAAMTP        IFEQ      'PI'
360200201218      *
360300201218     C     LAPCOB        IFNE      *BLANKS
360400201218     C                   MOVE      '*LEBTCH'     @RtCd
360500201218     C                   ELSE
360600201218     C                   MOVE      *BLANKS       @RtCd
360700201218     C                   ENDIF
360800201218     **********                                                                        CLE055 243415
360900201218      **If*authorization required:                                                     CLE055 243415
361000201218     C*********          If        CLE055 = 'Y'  and  BPLMAU = 'Y'                     CLE055 243415
361100201218     C*********          Eval      Z#BSTS = Z#ZADTB                                    CLE055 243415
361200201218     C*********          Eval      Z#ASTS = Z#ZADTA                                    CLE055 243415
361300201218     C*********          Endif                                                         CLE055 243415
361400201218      *
361500201218     C                   CALL      'AOOULAU0'
361600201218     C                   PARM                    @RtCd
361700201218     C                   PARM                    Z#BSTS
361800201218     C                   PARM                    Z#ASTS
361900201218     C                   PARM                    Z#WSTS
362000201218     C                   PARM                    PDCLI                                      MD023787
362100201218      *                                                                                     AR868380
362200201218     C     @RTCD         IFEQ      '*RECLCK'                                                AR868380
362300201218     C                   MOVEL     '*RECLCK'     @@RTCD                                     AR868380
362400201218     C                   GOTO      EXIT                                                     AR868380
362500201218     C                   ENDIF                                                              AR868380
362600201218      *
362700201218     C     @RtCd         IFEQ      '*ERROR*'
362800201218     C                   MOVEL     'AOOULAU0'    DBFILE                         ************
362900201218     C                   Z-ADD     29            DBASE                          * DBERR 29 *
363000201218     C                   MOVEL     @RtCd         DBKEY                          ************
363100201218     C                   EXSR      *PSSR
363200201218     C                   ENDIF
363300201218      *
363400201218      ** Create shadow posting of Interest and Maturity during                              MD047554
363500201218      ** insert, reversal, or amendment of amount                                           MD047554
363600201218      *                                                                                     MD047554
363700201218     C     DDACTN        IFEQ      'I'                                                      MD047554
363800201218     C     DDACTN        OREQ      'A'                                                      MD047554
363900201218     C     OPRAM         ANDNE     PRAM                                                     MD047554
364000201218     C     DDACTN        OREQ      'R'                                                      MD047554
364100201218     C                   CALL      'LE2041  '                                               MD047554
364200201218     C                   PARM                    OLNRF             6                        MD047554
364300201218     C                   PARM                    OVDAT             5 0                      MD047554
364400201218     C                   PARM                    OLASN             3 0                      MD047554
364500201218     C                   PARM                    OMPRAM           13 0                      MD047554
364600201218     C                   PARM                    DDATYP                                     MD047554
364700201218     C                   PARM                    DDACTN                                     MD047554
364800201218     C                   PARM                    OPRAM            13 0                      MD047554
364900201218     C                   PARM      *BLANKS       @RTCD                                      MD047554
365000201218     C                   ENDIF                                                              MD047554
365100201218      *                                                                                     MD047554
365200201218     C                   ENDIF
365300201218      *
365400201218     C                   MOVEL     SHLNRF        OLNRF                                        264065
365500201218     C                   MOVEL     SHVDAT        OVDAT                                        264065
365600201218     C                   MOVEL     SHLASN        OLASN                                        264065
365700201218     C                   MOVEL     SHPRAM        OMPRAM                                       264065
365800201218      *                                                                                     MD047554
365900201218     C                   IF        DDATYP <> 'PI'                                           MD047554
366000201218      *                                                                                     MD047554
366100201218     C                   IF        LAPCOB <> *BLANKS                                        MD047554
366200201218     C                   EVAL      @RTCD = '*LEBTCH'                                        MD047554
366300201218     C                   ELSE                                                               MD047554
366400201218     C                   EVAL      @RTCD = *BLANKS                                          MD047554
366500201218     C                   ENDIF                                                              MD047554
366600201218      *                                                                                     MD047554
366700201218     C                   EVAL      OPRAM = *ZERO                                            MD047554
366800201218      *                                                                                     MD047554
366900201218     C                   CALL      'LE2041  '                                                 264065
367000201218     C**********         PARM                    OLNRF             6 0               264065 MD047554
367100201218     C                   PARM                    OLNRF             6                        MD047554
367200201218     C                   PARM                    OVDAT             5 0                        264065
367300201218     C                   PARM                    OLASN             3 0                        264065
367400201218     C                   PARM                    OMPRAM           13 0                        264065
367500201218     C                   PARM                    AMTP                                         264065
367600201218     C                   PARM                    DDACTN                                       264065
367700201218     C                   PARM                    OPRAM                                      MD047554
367800201218     C                   PARM      *BLANKS       @RTCD                                      AR868380
367900201218                                                                                              264065
368000201218     C     @RTCD         IFEQ      '*RECLCK'                                                AR868380
368100201218     C                   MOVEL     '*RECLCK'     @@RTCD                                     AR868380
368200201218     C                   GOTO      EXIT                                                     AR868380
368300201218     C                   ENDIF                                                              AR868380
368400201218     C                   ENDIF                                                              MD047554
368500201218     C                   ENDIF
368600201218     C/COPY WNCPYSRC,LEH01192
368700201218      *
368800201218     C                   ENDSR
368900201218      *****************************************************************
369000201218      /EJECT
369100201218      *****************************************************************
369200201218      *  APLGTR  -  Write Loan Amendment transaction to the 24x7 Midas*
369300201218      *             availability Log File                             *
369400201218      *****************************************************************
369500201218     C     APLGTR        BEGSR
369600201218      *
369700201218      ** Format the transaction layout
369800201218      ** Note that, as the fields of the LOAMSDK record may have been overlaid
369900201218      ** during the other database updates, the valid file record is passed to
370000201218      ** LELOAMLOG. However, its format and values are the same as those of LOAMSDK
370100201218     C                   CALLB     'LELOAMLOG'
370200201218     C                   PARM      *BLANKS       RetCodeIn
370300201218     C                   PARM                    DDACTN
370400201218     C                   PARM                    ValidLoam
370500201218
370600201218      * Date format indicator
370700201218     C                   PARM                    BJDFIN
370800201218     C                   PARM                    TransDtl
370900201218     C                   PARM                    ValidLoam                                    CRE073
371000201218      *
371100201218      ***  Write to support database log file
371200201218     C     RetCodeIn     IFEQ      *BLANKS
371300201218      *
371400201218     C                   EVAL      APTGTTYPE = 'LELOAM'
371500201218     C                   EVAL      APUSERID = PSUser
371600201218     C                   MOVEL     LAFRNT        APFOTRANID
371700201218     C**********         EVAL      PDEALNO = %Char(LALNRF) + %Char(LAVDAT) +                  CLE148
371800201218     C                   EVAL      PDEALNO = LALNRF + %Char(LAVDAT) +                         CLE148
371900201218     C                                       %Char(LALASN)
372000201218      *
372100201218     C                   CALLB     'APLOGTRAN'
372200201218     C                   PARM      *BLANKS       RetCodeIn
372300201218     C                   PARM                    APHEAD
372400201218     C                   PARM                    TransDtl
372500201218     C                   PARM      *BLANKS       WTimeStamp       26
372600201218     C**********         PARM                    PDEALNO          18                          CGL029
372700201218     C**********         PARM      *BLANKS       PADEALNO         18                          CGL029
372800201218     C                   PARM                    PDEALNO                                      CGL029
372900201218     C                   PARM      *BLANKS       PADEALNO                                     CGL029
373000201218      *
373100201218     C                   ENDIF
373200201218      *
373300201218     C                   ENDSR
373400201218      *****************************************************************
373500201218      /EJECT
373600201218      *****************************************************************
373700201218      * SRUPPS   - Update Part Sold amount for Assignments            *
373800201218      *****************************************************************
373900201218     C     SRUPPS        BEGSR
374000201218      *
374100201218     C**********         Z-ADD     0             WKLNR                                        CLE148
374200201218     C                   MOVEL     *BLANKS       WKLNR                                        CLE148
374300201218     C                   EVAL      WrkUpdFlag = *BLANK                                      BUG10604
374400201218      *
374500201218      ** Only process if assignment flag is set
374600201218     C     LAGASS        IFEQ      'A'
374700201218      *
374800201218      ** Access Loans file using loan number
374900201218      *
375000201218     C                   MOVE      LALNRF        WKLNR
375100201218     C                   MOVE      'A'           WRCDT
375200201218     C     KLKEY         CHAIN(N)  CLOAN                              99
375300201218      *
375400201218     C     *IN99         IFEQ      *OFF
375500201218     C**********         Z-ADD     0             WKLNR                                        CLE148
375600201218     C                   MOVEL     *BLANKS       WKLNR                                        CLE148
375700201218      *
375800201218      ** If Mirror number not blank i.e. Loan is Part Purchased, access
375900201218      ** loans file using this number for main loan details
376000201218     C*****LO_MLNR       IFNE      *ZERO                                                      CLE148
376100201218     C     LO_MLNR       IFNE      *BLANKS                                                    CLE148
376200201218     C                   MOVE      LO_MLNR       WKLNR
376300201218     C     KLKEY         CHAIN     CLOAN                              99
376400201218     C                   ELSE
376500201218      *
376600201218      ** If Loan is Part Sold, Mirror Loan no will be blank so use LO_OLNO
376700201218      ** as key to access main loan details
376800201218     C     WSOLD         IFEQ      'Y'
376900201218     C                   MOVE      LO_OLNO       WKLNR
377000201218     C     KLKEY         CHAIN     CLOAN                              99
377100201218     C                   ELSE
377200201218     C                   MOVE      *ON           *IN99
377300201218     C                   ENDIF
377400201218      *
377500201218     C                   ENDIF
377600201218      *
377700201218     C     *IN99         IFEQ      *OFF
377800201218      *
377900201218      ** If action code is 'I' add principal amount to total sold
378000201218      ** amount
378100201218     C     LACHTP        IFEQ      'I'
378200201218     C     LO_PSAM       ADD       LAPRAM        LO_PSAM
378300201218     C                   ENDIF
378400201218      *
378500201218      ** If action code is 'A' subtract original principal amount
378600201218      ** accessed from LOAMSDK and add amended principal amount.
378700201218     C     LACHTP        IFEQ      'A'
378800201218     C     LO_PSAM       SUB       WPRAM         LO_PSAM
378900201218     C     LO_PSAM       ADD       LAPRAM        LO_PSAM
379000201218     C                   ENDIF
379100201218      *
379200201218      ** Update Amended Part Sold amount on Loan Master File
379300201218     C                   UPDATE    CLOANCLF
379400201218     C                   ENDIF
379500201218      *
379600201218     C                   ENDIF
379700201218      *
379800201218     C                   ENDIF
379900201218      *
380000201218     C                   MOVE      'N'           WPARTS            1
380100201218     C                   MOVE      '1'           *IN99
380200201218      *
380300201218      ** If principal transfer transaction, update LO_PSAM
380400201218     C     LAAMTP        IFEQ      'PF'
380500201218     C     LAAMTP        OREQ      'PT'
380600201218     C                   MOVE      LALNRF        WKLNR
380700201218     C                   MOVE      'A'           WRCDT
380800201218     C     KLKEY         CHAIN(N)  CLOAN                              99
380900201218     C                   EVAL      WrkUpdFlag = 'N'                                         BUG10604
381000201218      *
381100201218     C     *IN99         IFEQ      '0'
381200201218      *
381300201218      ** Check if loan is a parts sold or a parts purchased
381400201218     C     WSOLD         IFEQ      'Y'
381500201218     C*****LO_MLNR       ORNE      0                                                          CLE148
381600201218     C     LO_MLNR       ORNE      *BLANKS                                                    CLE148
381700201218      *
381800201218     C*****LO_MLNR       IFNE      0                                                          CLE148
381900201218     C     LO_MLNR       IFNE      *BLANKS                                                    CLE148
382000201218     C                   MOVE      LO_MLNR       WKLNR
382100201218     C                   ELSE
382200201218     C                   MOVE      LO_OLNO       WKLNR
382300201218     C                   ENDIF
382400201218      *
382500201218     C     KLKEY         CHAIN     CLOAN                              99
382600201218     C                   MOVE      'Y'           WPARTS
382700201218     C                   ENDIF
382800201218      *
382900201218     C                   ENDIF
383000201218      *
383100201218     C                   ENDIF
383200201218      *
383300201218      ** Insert
383400201218     C     WPARTS        IFEQ      'Y'
383500201218     C     *IN99         ANDEQ     '0'
383600201218     C     DDACTN        ANDNE     'X'                                                     BUG10655R
383700201218      *
383800201218     C     LACHTP        IFEQ      'I'
383900201218      *
384000201218      ** Subtract transfer amount from sold amount of the original
384100201218      ** loan if 'PF' else add if 'PT'
384200201218     C     LAAMTP        IFEQ      'PF'
384300201218     C                   SUB       LAPRAM        LO_PSAM
384400201218     C                   ELSE
384500201218     C                   ADD       LAPRAM        LO_PSAM
384600201218     C                   ENDIF
384700201218      *
384800201218      ** Update Sold Amount
384900201218     C                   UPDATE    CLOANCLF
385000201218     C                   EVAL      WrkUpdFlag = 'Y'                                         BUG10604
385100201218     C                   ENDIF
385200201218      *
385300201218      ** Amendment/Reverse
385400201218     C     LACHTP        IFEQ      'A'
385500201218     C     LACHTP        OREQ      'R'
385600201218      *
385700201218      ** For 'PF' restore the sold amount of the original loan. If amend
385800201218      ** subtract the transfer amount to the restored amount.
385900201218     C     LAAMTP        IFEQ      'PF'
386000201218      *
386100201218     C     LACHTP        IFEQ      'A'
386200201218     C                   ADD       WPRAM         LO_PSAM
386300201218     C                   SUB       LAPRAM        LO_PSAM
386400201218     C                   ELSE
386500201218     C                   ADD       WPRAM         LO_PSAM
386600201218     C                   ENDIF
386700201218      *
386800201218     C                   ELSE
386900201218      *
387000201218      ** For PT, restore the sold amount of the original loan. If amend
387100201218      ** add the transfer amount to the restored amount.
387200201218     C     LACHTP        IFEQ      'A'
387300201218     C                   SUB       WPRAM         LO_PSAM
387400201218     C                   ADD       LAPRAM        LO_PSAM
387500201218     C                   ELSE
387600201218     C                   SUB       WPRAM         LO_PSAM
387700201218     C                   ENDIF
387800201218      *
387900201218     C                   ENDIF
388000201218      *
388100201218      ** Update Sold Amount
388200201218     C                   UPDATE    CLOANCLF
388300201218     C                   EVAL      WrkUpdFlag = 'Y'                                         BUG10604
388400201218     C                   ENDIF
388500201218      *
388600201218     C                   ENDIF
388700201218                                                                                            BUG10604
388800201218     C                   IF        WrkUpdFlag = 'N'                                         BUG10604
388900201218     C                   UNLOCK    CLOAN                                                    BUG10604
389000201218     C                   ENDIF                                                              BUG10604
389100201218      *
389200201218     C                   ENDSR
389300201218      *****************************************************************
389400201218      /EJECT
389500201218      *****************************************************************
389600201218      * SRINIT - Initialisation for each call to this module          *
389700201218      *****************************************************************
389800201218     C     SRINIT        BEGSR
389900201218      *
390000201218      ** Determine whether program is running interactively or in batch
390100201218      **  ( 0 = batch   1 = interactive)
390200201218     C                   CALLB     'ZARTVJOBA'
390300201218     C                   PARM                    @Return           6
390400201218     C                   PARM                    @Type             1
390500201218      *
390600201218      ** Set *RTV module parameter ModeofOp to *FRONT if the pgm is running
390700201218      ** in batch or called from the repair or java browser modules.
390800201218     C                   IF        @Type  = '0' or
390900201218     C                             CallModCod = 'RPR'
391000201218     C                   EVAL      ModeofOp = '*FRONT'
391100201218     C                   ELSE
391200201218     C                   EVAL      ModeofOp = *BLANKS
391300201218     C                   ENDIF
391400201218      *
391500201218      ** Move selected action and run date to last changed fields
391600201218     C*******************MOVE      DDACTN        LACHTP                         213280
391700201218     C                   MOVE      WRNDAY        LALCD
391800201218      *
391900201218      ** Set up a flag for parts sold
392000201218     C                   MOVE      *BLANK        WSOLD             1
392100201218      *
392200201218     C*****PTYPA         IFEQ      66                                                         243270
392300201218     C*****PTYPA         OREQ      67                                                         243270
392400201218     C*****PTYPA         OREQ      69                                                         243270
392500201218     C*****CLE005        ANDEQ     'Y'                                                        243270
392600201218     C*****PTYPA         OREQ      72                                                         243270
392700201218     C*****CLE005        ANDEQ     'Y'                                                        243270
392800201218     C     LAPTYP        IFEQ      66                                                         243270
392900201218     C     LAPTYP        OREQ      67                                                         243270
393000201218     C     LAPTYP        OREQ      69                                                         243270
393100201218     C     CLE005        ANDEQ     'Y'                                                        243270
393200201218     C     LAPTYP        OREQ      72                                                         243270
393300201218     C     CLE005        ANDEQ     'Y'                                                        243270
393400201218     C                   MOVE      'Y'           WSOLD
393500201218     C                   ENDIF
393600201218      *
393700201218      ** For type 72 get processing type of loan sold
393800201218     C                   Z-ADD     0             WSPTYP            2 0
393900201218      *
394000201218     C     PTYPA         IFEQ      72
394100201218     C     CLE005        ANDEQ     'Y'
394200201218      *
394300201218     C**********         Z-ADD     LO_OLNO       WKLNR                                        CSD027
394400201218     C                   Move      LO_OLNO       WKLNR                                        CSD027
394500201218     C                   MOVE      'A'           WRCDT
394600201218     C     KLKEY         CHAIN     CLOANCLF                           99
394700201218      *
394800201218     C     *IN99         IFEQ      '1'
394900201218     C                   MOVEL     'CLOAN   '    DBFILE                         ************
395000201218     C                   Z-ADD     31            DBASE                          * DBERR 31 *
395100201218     C                   MOVEL     WKLNR         DBKEY                          ************
395200201218     C                   EXSR      *PSSR
395300201218     C                   ENDIF
395400201218      *
395500201218     C     PTYPA         IFEQ      63
395600201218     C     PTYPA         OREQ      65
395700201218     C                   Z-ADD     67            WSPTYP
395800201218     C                   ENDIF
395900201218      *
396000201218     C     PTYPA         IFEQ      62
396100201218     C     PTYPA         OREQ      64
396200201218     C                   Z-ADD     66            WSPTYP
396300201218     C                   ENDIF
396400201218      *
396500201218     C     PTYPA         IFEQ      61
396600201218     C     PTYPA         OREQ      68
396700201218     C                   Z-ADD     69            WSPTYP
396800201218     C                   ENDIF
396900201218      *
397000201218     C     PTYPA         IFEQ      70
397100201218     C     PTYPA         OREQ      71
397200201218     C                   Z-ADD     70            WSPTYP
397300201218     C                   ENDIF
397400201218      *
397500201218     C                   ENDIF
397600201218      *                                                                                     AR547813
397700201218     C                   CALLB     'AOSARDR0'                                               AR547813
397800201218     C                   PARM      *BLANKS       PRtCd                                      AR547813
397900201218     C                   PARM      '*VERIFY'     POptn                                      AR547813
398000201218     C                   PARM      'CLE028'      PSARD                                      AR547813
398100201218     C     SCSARD        PARM      SCSARD        DSFDY                                      AR547813
398200201218      *                                                                                     AR547813
398300201218     C                   MOVE      'N'           CLE028            1                        AR547813
398400201218      *                                                                                     AR547813
398500201218     C                   IF        PRtCd = *BLANKS                                          AR547813
398600201218     C                   MOVE      'Y'           CLE028                                     AR547813
398700201218     C                   ENDIF                                                              AR547813
398800201218      *
398900201218      ** Reset work fields
399000201218     C                   CLEAR                   Z#BSTS
399100201218     C                   CLEAR                   Z#ASTS
399200201218     C                   CLEAR                   Z#WSTS
399300201218     C                   MOVEL     LAFRNT        W#FRNT                                    AR1021983
399400201218      *
399500201218     C     EXINIT        ENDSR
399600201218      ****************************************************************
399700201218      /EJECT
399800201218      *****************************************************************
399900201218      * GLZADD - Subroutine to add an amount to the total             *
400000201218      *****************************************************************
400100201218     C     GLZADD        BEGSR
400200201218      *
400300201218     C                   Z-ADD     ZZAMT         ZZAMT            15 3    91    -DEFINE ZZAMT
400400201218     C   91              GOTO      ZZAEND                                       AMT = 0.BYPASS
400500201218      *
400600201218      ** Split ZZAMT into integer and decimal fields
400700201218     C                   Z-ADD     ZZAMT         ZZAMTI           15 0          INTEGER FIELD
400800201218     C                   MOVE      ZZAMT         ZZAMTD            3 0          DECIMAL FIELD
400900201218      *
401000201218      ** Both ZZAMTI and ZZAMTD contain a 'sign' zone now
401100201218      *
401200201218     C                   EXSR      GLZSUM
401300201218      *
401400201218     C     ZZAEND        ENDSR
401500201218      *****************************************************************
401600201218      /EJECT
401700201218      *****************************************************************
401800201218      * GLZSUB - Subroutine to subtract an amount to the total        *
401900201218      *****************************************************************
402000201218     C     GLZSUB        BEGSR
402100201218      *
402200201218      ** Processing just reverse the 'sign' and add
402300201218     C                   Z-SUB     ZZAMT         ZZAMT            15 3          REVERSE 'SIGN'
402400201218     C                   EXSR      GLZADD                                         AND 'ADD'
402500201218     C                   Z-SUB     ZZAMT         ZZAMT                          RESTORE 'SIGN'
402600201218      *
402700201218     C                   ENDSR
402800201218      /EJECT
402900201218      *****************************************************************
403000201218      * GLZSUM - Subroutine to carry out the additon for subroutine   *
403100201218      *****************************************************************
403200201218     C     GLZSUM        BEGSR
403300201218      *
403400201218     C                   Z-ADD     ZZTOTI        ZZTOTI           15 0          DEFINE ZZTOTI
403500201218     C                   Z-ADD     ZZTOTD        ZZTOTD            3 0          DEFINE ZZTOTD
403600201218     C                   SETOFF                                       919293
403700201218     C                   SETOFF                                       949599
403800201218      *
403900201218      ** Determine sign of ZZAMTI & D, 92 if negative
404000201218     C     ZZAMTI        COMP      0                                    9293
404100201218     C   93ZZAMTD        COMP      0                                    9293
404200201218     C   93              GOTO      ZZSEND                                       ZERO BYPASS
404300201218      *
404400201218      ** Determine sign of ZZTOTI & D, 91 if negative
404500201218     C     ZZTOTI        COMP      0                                    9193
404600201218     C   93ZZTOTD        COMP      0                                    9193
404700201218      *
404800201218      ** If ZZTOTAL is zero, return ZZAMOUNT
404900201218     C   93              Z-ADD     ZZAMTI        ZZTOTI
405000201218     C   93              Z-ADD     ZZAMTD        ZZTOTD
405100201218     C   93              GOTO      ZZSEND                                       ZERO BYPASS
405200201218      *
405300201218      ** If signs differ bypass overflow checks
405400201218     C   91
405500201218     CANN92
405600201218     CORN91
405700201218     CAN 92              GOTO      ZZOFPS
405800201218      *
405900201218     C     ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
406000201218     C     ZZWK2         COMP      999                                93        '93' = CARRY
406100201218     C  N93ZZWK2         COMP      -999                                 93        INTO INTEGER.
406200201218      *
406300201218     C   93
406400201218     CANN92ZZAMTI        ADD       1             ZZWK3            15 0          ADD 'CARRY' +VE
406500201218     C   93
406600201218     CAN 92ZZAMTI        SUB       1             ZZWK3                          SUB 'CARRY' -VE
406700201218     C   93ZZTOTI        ADD       ZZWK3         ZZWK3
406800201218     C  N93ZZTOTI        ADD       ZZAMTI        ZZWK3
406900201218      *
407000201218      ** If the modulus of ZZWK3 is less than the one of ZZTOTI
407100201218      ** then an overflow has occurred
407200201218     C  N92ZZWK3         COMP      ZZTOTI                               99      -92 MEANS NOS.
407300201218     C   92ZZWK3         COMP      ZZTOTI                             99         NEGATIVE
407400201218     C  N99              Z-ADD     ZZWK2         ZZTOTD
407500201218     C  N99              Z-ADD     ZZWK3         ZZTOTI
407600201218      *
407700201218      ** If overflow zeroise ZZAMT, set 99 on and let ZZTOT fields intact
407800201218     C   99              Z-ADD     0             ZZAMT            15 3
407900201218     C                   GOTO      ZZSEND
408000201218      *
408100201218      ** The 'signs' are different
408200201218     C     ZZOFPS        TAG
408300201218      *
408400201218      ** If ZZAMT was negative, make it positive to compare with ZZTOT
408500201218     C   92              Z-SUB     ZZAMTI        ZZAMTI           15 0
408600201218     C   92              Z-SUB     ZZAMTD        ZZAMTD            3 0
408700201218      *
408800201218      ** If ZZTOT was negative, make it positive to compare with ZZAMT
408900201218     C   91              Z-SUB     ZZTOTI        ZZTOTI
409000201218     C   91              Z-SUB     ZZTOTD        ZZTOTD
409100201218      *
409200201218      ** Both ZZAMT and ZZTOT are now positive
409300201218     C     ZZTOTI        COMP      ZZAMTI                             93  95
409400201218     C   95ZZTOTD        COMP      ZZAMTD                             93  95
409500201218      *
409600201218      ** If ZZTOT equals ZZAMT return zero
409700201218     C   95              Z-ADD     0             ZZTOTI
409800201218     C   95              Z-ADD     0             ZZTOTD
409900201218     C   95              GOTO      ZZSEND
410000201218      *
410100201218      ** If ZZTOT greater than ZZAMT
410200201218     C   93ZZAMTD        COMP      ZZTOTD                             94
410300201218     C   93
410400201218     CAN 94ZZTOTI        SUB       1             ZZTOTI
410500201218     C   93
410600201218     CAN 94ZZTOTD        ADD       1000          ZZWK2
410700201218     C   93ZZTOTI        SUB       ZZAMTI        ZZTOTI
410800201218     C   93
410900201218     CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
411000201218     C   93
411100201218     CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD
411200201218      *
411300201218      ** If ZZAMT greater than ZZTOT
411400201218     C  N93ZZTOTD        COMP      ZZAMTD                             94
411500201218     C  N93
411600201218     CAN 94ZZAMTI        SUB       1             ZZWK3            15 0
411700201218     C  N93
411800201218     CAN 94ZZAMTD        ADD       1000          ZZWK2
411900201218     C  N93
412000201218     CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
412100201218     C  N93
412200201218     CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
412300201218     C  N93
412400201218     CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
412500201218     C  N93
412600201218     CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD
412700201218      *
412800201218      ** Reverse sign of ZZTOT if larger I/P fields were negative
412900201218     C                   SETOFF                                       94
413000201218     C   93
413100201218     CAN 91
413200201218     CORN93
413300201218     CAN 92              SETON                                        94
413400201218     C   94              Z-SUB     ZZTOTI        ZZTOTI
413500201218     C   94              Z-SUB     ZZTOTD        ZZTOTD
413600201218      *
413700201218      ** Restore sign of ZZAMTI & ZZAMTD if it was reversed
413800201218     C   92              Z-SUB     ZZAMTI        ZZAMTI
413900201218     C   92              Z-SUB     ZZAMTD        ZZAMTD
414000201218      *
414100201218     C     ZZSEND        TAG
414200201218      *
414300201218      ** If ZZTOTD is zero, and ZZTOTI is negative set up ZZNEGD
414400201218     C                   SETOFF                                       96
414500201218     C     ZZTOTD        COMP      0                                      91
414600201218     C   91ZZTOTI        COMP      0                                    96
414700201218     C   96              MOVE      '.000-'       ZZNEGD            5
414800201218      *
414900201218     C                   ENDSR
415000201218      *****************************************************************                       CRE020
415100201218      /EJECT                                                                                  CRE020
415200201218      *****************************************************************                       CRE020
415300201218      *                                                               *                       CRE020
415400201218      *  SRIdxTrn - Handles the advice index of the current           *                       CRE020
415500201218      *             transaction.                                      *                       CRE020
415600201218      *                                                               *                       CRE020
415700201218      *****************************************************************                       CRE020
415800201218     C     SRIdxTrn      BEGSR                                                                CRE020
415900201218                                                                                              CRE020
416000201218      ** Initialise key values.                                                               CRE020
416100201218                                                                                              CRE020
416200201218     C                   MOVE      *BLANKS       KRefNo                                       CRE020
416300201218     C                   MOVE      *BLANKS       KSeqNo                                       CRE020
416400201218     C                   MOVEL     LALNRF        KRefNo                                       CRE020
416500201218     C                   MOVEL     LALASN        KSeqNo                                       CRE020
416600201218                                                                                              CRE020
416700201218      ** Begin advice index processing.                                                       CRE020
416800201218                                                                                              CRE020
416900201218     C                   MOVE      *BLANK        WNew                                         CRE020
417000201218                                                                                              CRE020
417100201218     C                   OPEN      READVCL2                                                   CRE020
417200201218                                                                                              CRE020
417300201218     C     KADVC         SETLL     READVCL2                                                   CRE020
417400201218     C     KADVC         READE     READVCL2                                                   CRE020
417500201218                                                                                              CRE020
417600201218     C                   DOW       NOT %EOF                                                   CRE020
417700201218                                                                                              CRE020
417800201218      ** Check first if this is a new advice index.                                           CRE020
417900201218                                                                                              CRE020
418000201218     C                   IF        WNew = *BLANK                                              CRE020
418100201218     C                   IF        RCHTYP = 'I' AND                                           CRE020
418200201218     C                             RSAPIN = 'N'                                               CRE020
418300201218     C                   MOVE      'Y'           WNew                                         CRE020
418400201218     C                   ELSE                                                                 CRE020
418500201218     C                   MOVE      'N'           WNew                                         CRE020
418600201218     C                   ENDIF                                                                CRE020
418700201218     C                   ENDIF                                                                CRE020
418800201218                                                                                              CRE020
418900201218      ** Set default values if the advice indicator is equal to blank.                        CRE020
419000201218                                                                                              CRE020
419100201218     C                   IF        RSAPIN = ' '                                               CRE020
419200201218                                                                                              CRE020
419300201218     C                   IF        LACHTP = 'R'                                               CRE020
419400201218     C                   MOVE      'R'           RCHTYP                                       CRE020
419500201218     C                   MOVE      'Y'           RSAPIN                                       CRE020
419600201218     C                   MOVE      'Y'           RAUTHI                                       CRE020
419700201218     C                   ELSE                                                                 CRE020
419800201218                                                                                              CRE020
419900201218     C                   MOVE      *BLANKS       WEvent                                       CRE020
420000201218     C                   MOVEL     RENARR        WEvent                                       CRE020
420100201218                                                                                              CRE020
420200201218      ** Change type is always 'I' for newly inserted value records. 'A'                      CRE020
420300201218      ** otherwise.                                                                           CRE020
420400201218                                                                                              CRE020
420500201218     C                   IF        WEvent = 'VALUE'                                           CRE020
420600201218     C                   MOVE      'I'           RCHTYP                                       CRE020
420700201218     C                   ELSE                                                                 CRE020
420800201218     C                   MOVE      'A'           RCHTYP                                       CRE020
420900201218     C                   ENDIF                                                                CRE020
421000201218                                                                                              CRE020
421100201218     C                   MOVE      'N'           RSAPIN                                       CRE020
421200201218     C                   MOVE      'Y'           RAUTHI                                       CRE020
421300201218     C                   ENDIF                                                                CRE020
421400201218                                                                                              CRE020
421500201218     C                   ELSE                                                                 CRE020
421600201218                                                                                              CRE020
421700201218      ** Execute reversal processing if necessary.                                            CRE020
421800201218                                                                                              CRE020
421900201218     C                   IF        LACHTP = 'R'                                               CRE020
422000201218                                                                                              CRE020
422100201218      ** Delete the advice index if the current record is a new loan                          CRE020
422200201218      ** amendment. Reverse it otherwise.                                                     CRE020
422300201218                                                                                              CRE020
422400201218     C                   MOVE      'R'           RCHTYP                                       CRE020
422500201218                                                                                              CRE020
422600201218     C                   IF        RAUTHI = 'N'                                               CRE020
422700201218     C                   MOVE      'Y'           RAUTHI                                       CRE020
422800201218                                                                                              CRE020
422900201218     C                   IF        WNew = 'Y'                                                 CRE020
423000201218     C                   MOVE      'Y'           RSAPIN                                       CRE020
423100201218     C                   ELSE                                                                 CRE020
423200201218     C                   MOVE      'N'           RSAPIN                                       CRE020
423300201218     C                   ENDIF                                                                CRE020
423400201218     C                   ENDIF                                                                CRE020
423500201218                                                                                              CRE020
423600201218     C                   ELSE                                                                 CRE020
423700201218                                                                                              CRE020
423800201218      ** Execute amend processing.                                                            CRE020
423900201218                                                                                              CRE020
424000201218     C                   IF        WNew = 'Y'                                                 CRE020
424100201218     C                   MOVE      *BLANKS       WEvent                                       CRE020
424200201218     C                   MOVEL     RENARR        WEvent                                       CRE020
424300201218                                                                                              CRE020
424400201218     C                   IF        WEvent = 'VALUE'                                           CRE020
424500201218     C                   MOVE      'I'           RCHTYP                                       CRE020
424600201218     C                   ELSE                                                                 CRE020
424700201218     C                   MOVE      'A'           RCHTYP                                       CRE020
424800201218     C                   ENDIF                                                                CRE020
424900201218                                                                                              CRE020
425000201218      ** Change field values only if the authorise indicator is equal to 'N'.                 CRE020
425100201218                                                                                              CRE020
425200201218     C                   IF        RAUTHI = 'N'                                               CRE020
425300201218     C                   EVAL      RAUTHI = 'Y'                                               CRE020
425400201218     C                   EVAL      RSAPIN = 'N'                                               CRE020
425500201218     C                   ENDIF                                                                CRE020
425600201218                                                                                              CRE020
425700201218     C                   ELSE                                                                 CRE020
425800201218                                                                                              CRE020
425900201218     C                   IF        RAUTHI = 'N'                                               CRE020
426000201218     C                   MOVE      LACHTP        RCHTYP                                       CRE020
426100201218     C                   MOVE      'Y'           RAUTHI                                       CRE020
426200201218     C                   MOVE      'N'           RSAPIN                                       CRE020
426300201218     C                   ENDIF                                                                CRE020
426400201218                                                                                              CRE020
426500201218     C                   ENDIF                                                                CRE020
426600201218                                                                                              CRE020
426700201218     C                   ENDIF                                                                CRE020
426800201218                                                                                              CRE020
426900201218     C                   ENDIF                                                                CRE020
427000201218                                                                                              CRE020
427100201218     C                   UPDATE    READVCD0                                                   CRE020
427200201218                                                                                              CRE020
427300201218     C     KADVC         READE     READVCL2                                                   CRE020
427400201218     C                   ENDDO                                                                CRE020
427500201218                                                                                              CRE020
427600201218     C                   CLOSE     READVCL2                                                   CRE020
427700201218                                                                                              CRE020
427800201218     C                   ENDSR                                                                CRE020
427900201218      *****************************************************************                       CRE020
428000201218      /EJECT                                                                                  CRE020
428100201218      *****************************************************************                       CRE020
428200201218      *                                                               *                       CRE020
428300201218      *  SRIdxAmd - Handles the advice index during 'A' processing.   *                       CRE020
428400201218      *                                                               *                       CRE020
428500201218      *****************************************************************                       CRE020
428600201218     C     SRIdxAmd      BEGSR                                                                CRE020
428700201218                                                                                              CRE020
428800201218      ** Initialise key values.                                                               CRE020
428900201218                                                                                              CRE020
429000201218     C                   MOVE      *BLANKS       KRefNo                                       CRE020
429100201218     C                   MOVE      *BLANKS       KSeqNo                                       CRE020
429200201218     C                   MOVEL     LALNRF        KRefNo                                       CRE020
429300201218     C                   MOVEL     LALASN        KSeqNo                                       CRE020
429400201218                                                                                              CRE020
429500201218      ** Begin advice index processing.                                                       CRE020
429600201218                                                                                              CRE020
429700201218     C                   OPEN      READVCL2                                                   CRE020
429800201218                                                                                              CRE020
429900201218     C     KADVC         SETLL     READVCL2                                                   CRE020
430000201218     C     KADVC         READE     READVCL2                                                   CRE020
430100201218                                                                                              CRE020
430200201218     C                   DOW       NOT %EOF                                                   CRE020
430300201218                                                                                              CRE020
430400201218      ** Execute amend processing if necessary.                                               CRE020
430500201218                                                                                              CRE020
430600201218     C                   IF        RAUTHI = 'Y' AND                                           CRE020
430700201218     C                             RSAPIN = 'N'                                               CRE020
430800201218     C                   MOVE      'N'           RAUTHI                                       CRE020
430900201218     C                   UPDATE    READVCD0                                                   CRE020
431000201218     C                   ENDIF                                                                CRE020
431100201218                                                                                              CRE020
431200201218     C     KADVC         READE     READVCL2                                                   CRE020
431300201218     C                   ENDDO                                                                CRE020
431400201218                                                                                              CRE020
431500201218     C                   CLOSE     READVCL2                                                   CRE020
431600201218                                                                                              CRE020
431700201218     C                   ENDSR                                                                CRE020
431800201218      ****************************************************************
431900201218      /EJECT
432000201218      *****************************************************************
432100201218      *                                                               *                      BUG3760
432200201218      * SRWTCH - Set-up parameter and send transaction details to     *                      BUG3760
432300201218      *          Compliance Watch by calling the Engine program       *                      BUG3760
432400201218      *                                                               *                      BUG3760
432500201218      *****************************************************************                      BUG3760
432600201218     C     SRWTCH        BEGSR                                                               BUG3760
432700201218      *                                                                                      BUG3760
432800201218      ** Set-up first parameter for Compliance Engine                                        BUG3760
432900201218      *                                                                                      BUG3760
433000201218     C                   CLEAR                   SDWLTD                                      BUG3760
433100201218      *                                                                                      BUG3760
433200201218      ** Build the free format string.                                                       BUG3760
433300201218      *                                                                                      BUG3760
433400201218     C                   EVAL      Ctr = 0                                                   BUG3760
433500201218     C                   EVAL      PFreeFmtStr = *BLANKS                                     BUG3760
433600201218     C                   EVAL      WData = *BLANKS                                           BUG3760
433700201218      *                                                                                      BUG3760
433800201218     C                   DOU       Ctr = 12                                                  BUG3760
433900201218     C                   ADD       1             Ctr                                         BUG3760
434000201218     C                   MOVEL     WLF(Ctr)      PDumy35a                                    BUG3760
434100201218      *                                                                                      BUG3760
434200201218     C                   IF        WLF(Ctr) <> *BLANKS AND WLF(Ctr) <> '000000'              BUG3760
434300201218      *                                                                                      BUG3760
434400201218     C                   IF        SCCY <> *BLANKS                                           BUG3760
434500201218     C                   MOVEL     SCCY          PYCCY                                       BUG3760
434600201218     C                   ELSE                                                                BUG3760
434700201218     C                   MOVEL     CCY           PYCCY                                       BUG3760
434800201218     C                   ENDIF                                                               BUG3760
434900201218      *                                                                                      BUG3760
435000201218     C                   CALL      'SDCWLFMT'                                                BUG3760
435100201218     C                   PARM                    PRetCode                                    BUG3760
435200201218     C                   PARM                    PDumy35a                                    BUG3760
435300201218     C                   PARM      *BLANKS       PDummy35                                    BUG3760
435400201218     C                   PARM      *BLANKS       PDummy35                                    BUG3760
435500201218     C                   PARM      *BLANKS       PDummy35                                    BUG3760
435600201218     C                   PARM      *BLANKS       PDummy35                                    BUG3760
435700201218     C                   PARM      *BLANKS       PDummy35                                    BUG3760
435800201218     C                   PARM                    PYCCY                                       BUG3760
435900201218     C                   PARM                    WData                                       BUG3760
436000201218     C                   PARM                    PDummy6                                     BUG3760
436100201218      *                                                                                      BUG3760
436200201218     C                   IF        WData <> *BLANKS                                          BUG3760
436300201218     C     Ctr           MULT      2             CLS                                         BUG3760
436400201218     C     CLS           SUB       1             OPN                                         BUG3760
436500201218     C                   MOVEL     CWA(OPN)      WOPN                                        BUG3760
436600201218     C                   MOVEL     CWA(CLS)      WCLS                                        BUG3760
436700201218      *                                                                                      BUG3760
436800201218     C     PFreeFmtStr   CAT       WOPN:0        PFreeFmtStr                                 BUG3760
436900201218     C                   CAT       WData:0       PFreeFmtStr                                 BUG3760
437000201218      *                                                                                      BUG3760
437100201218     C                   SELECT                                                              BUG3760
437200201218     C     Ctr           WHENEQ    2                                                         BUG3760
437300201218     C                   CAT       RIBA:0        PFreeFmtStr                                 BUG3760
437400201218     C     Ctr           WHENEQ    6                                                         BUG3760
437500201218     C                   CAT       PIBA:0        PFreeFmtStr                                 BUG3760
437600201218     C     Ctr           WHENEQ    9                                                         BUG3760
437700201218     C                   CAT       RCRA:0        PFreeFmtStr                                 BUG3760
437800201218     C     Ctr           WHENEQ    11                                                        BUG3760
437900201218     C                   CAT       AWBA:0        PFreeFmtStr                                 BUG3760
438000201218     C     Ctr           WHENEQ    12                                                        BUG3760
438100201218     C                   CAT       BENA:0        PFreeFmtStr                                 BUG3760
438200201218     C                   ENDSL                                                               BUG3760
438300201218      *                                                                                      BUG3760
438400201218     C                   CAT       WCLS:0        PFreeFmtStr                                 BUG3760
438500201218      *                                                                                      BUG3760
438600201218     C                   ENDIF                                                               BUG3760
438700201218     C                   ENDIF                                                               BUG3760
438800201218      *                                                                                      BUG3760
438900201218     C                   ENDDO                                                               BUG3760
439000201218      *                                                                                      BUG3760
439100201218     C                   IF        DTP1 <> *BLANKS OR                                        BUG3760
439200201218     C                             DTP2 <> *BLANKS OR                                        BUG3760
439300201218     C                             DTP3 <> *BLANKS OR                                        BUG3760
439400201218     C                             DTP4 <> *BLANKS OR                                        BUG3760
439500201218     C                             WDTPC = 'Y'                                               BUG3760
439600201218     C                   CAT       CWA(25):0     PFreeFmtStr                                 BUG3760
439700201218     C                   CAT       DTP1:0        PFreeFmtStr                                 BUG3760
439800201218     C                   CAT       DTP2:1        PFreeFmtStr                                 BUG3760
439900201218     C                   CAT       DTP3:1        PFreeFmtStr                                 BUG3760
440000201218     C                   CAT       DTP4:1        PFreeFmtStr                                 BUG3760
440100201218     C                   CAT       CWA(26):0     PFreeFmtStr                                 BUG3760
440200201218     C                   ENDIF                                                               BUG3760
440300201218      *                                                                                      BUG3760
440400201218      ** Setup parameter 1 and send details to engine only if                                BUG3760
440500201218      ** PFreeFmtStr is not empty.                                                           BUG3760
440600201218      *                                                                                      BUG3760
440700201218     C                   IF        PFreeFmtStr <> *BLANKS                                    BUG3760
440800201218      *                                                                                      BUG3760
440900201218      ** Parameter 1:                                                                        BUG3760
441000201218      ** Item Type Code                                                                      BUG3760
441100201218      *                                                                                      BUG3760
441200201218     C                   MOVEL     'LEAMD'       W4ITEM                                      BUG3760
441300201218      *                                                                                      BUG3760
441400201218      ** Identifier                                                                          BUG3760
441500201218      *                                                                                      BUG3760
441600201218     C                   MOVEL     *BLANKS       WLNRF                                       BUG3760
441700201218     C                   MOVEL     *BLANKS       WKVDAT                                      BUG3760
441800201218     C                   MOVEL     *BLANKS       WLASN                                       BUG3760
441900201218     C                   MOVEL     *BLANKS       W4IDEN                                      BUG3760
442000201218     C                   MOVEL     LNRF          WLNRF                                       BUG3760
442100201218     C                   MOVEL     VDAT          WKVDAT                                      BUG3760
442200201218     C                   MOVEL     LASN          WLASN                                       BUG3760
442300201218     C     WLNRF         CAT       WKVDAT:0      W4IDEN                                      BUG3760
442400201218     C                   CAT       WLASN:0       W4IDEN                                      BUG3760
442500201218      *                                                                                      BUG3760
442600201218      ** Branch                                                                              BUG3760
442700201218      *                                                                                      BUG3760
442800201218     C                   MOVEL     BRCA          W4BRCH                                      BUG3760
442900201218      *                                                                                      BUG3760
443000201218      ** System                                                                              BUG3760
443100201218      ** If Midas 24x7 is installed, use Main system prefix                                  BUG3760
443200201218      ** otherwise, use system prefix                                                        BUG3760
443300201218      *                                                                                      BUG3760
443400201218     C                   IF        CSC011 = 'Y'                                              BUG3760
443500201218     C                   MOVE      S1MAIN        W4SYSM                                      BUG3760
443600201218     C                   ELSE                                                                BUG3760
443700201218     C                   MOVE      LIBR          W4SYSM                                      BUG3760
443800201218     C                   ENDIF                                                               BUG3760
443900201218      *                                                                                      BUG3760
444000201218      ** Function Type                                                                       BUG3760
444100201218      *                                                                                      BUG3760
444200201218     C                   MOVEL     'LOAMSDK'     W4FUNT                                      BUG3760
444300201218      *                                                                                      BUG3760
444400201218      ** Counter Party Details                                                               BUG3760
444500201218      *                                                                                      BUG3760
444600201218     C                   MOVEL     CNUM          PCUST                                       BUG3760
444700201218     C                   CALLB     'AOCUSTR0'                                                BUG3760
444800201218     C                   PARM      *BLANKS       PRetCode                                    BUG3760
444900201218     C                   PARM      '*KEY'        POption                                     BUG3760
445000201218     C                   PARM                    PCUST                                       BUG3760
445100201218     C                   PARM      *BLANKS       PSTKEY                                      BUG3760
445200201218     C     SDCUST        PARM      SDCUST        DSSDY                                       BUG3760
445300201218      *                                                                                      BUG3760
445400201218     C                   IF        PRetCode <> *BLANKS                                       BUG3760
445500201218     C                   EVAL      DBKEY = POption                                           BUG3760
445600201218     C                   EVAL      DBFILE = 'SDCUSTPD'                                       BUG3760
445700201218     C                   EVAL      DBASE = 911                                               BUG3760
445800201218     C                   EXSR      *PSSR                                                     BUG3760
445900201218     C                   ELSE                                                                BUG3760
446000201218     C                   MOVE      *BLANKS       W4CUST                                      BUG3760
446100201218     C                   EVAL      W4CUST = BBCRNM + BBCRTN                                  BUG3760
446200201218     C                   EVAL      W4CNUM = PCUST                                            BUG3760
446300201218      *                                                                                      BUG3760
446400201218     C                   IF        CCF001 = 'Y'                                              BUG3760
446500201218      *                                                                                      BUG3760
446600201218     C                   IF        BBCRPC = 'Y'                                              BUG3760
446700201218     C                   EVAL      W4CTYP = 'C'                                              BUG3760
446800201218     C                   ELSE                                                                BUG3760
446900201218     C                   EVAL      W4CTYP = 'I'                                              BUG3760
447000201218     C                   ENDIF                                                               BUG3760
447100201218      *                                                                                      BUG3760
447200201218     C                   ELSE                                                                BUG3760
447300201218      *                                                                                      BUG3760
447400201218     C                   IF        BBLICD <> *BLANK AND                                      BUG3760
447500201218     C                             BBLICD <> W1IND1 AND                                      BUG3760
447600201218     C                             BBLICD <> W1IND2 AND                                      BUG3760
447700201218     C                             BBLICD <> W1IND3 AND                                      BUG3760
447800201218     C                             BBLICD <> W1IND4 AND                                      BUG3760
447900201218     C                             BBLICD <> W1IND5                                          BUG3760
448000201218     C                   EVAL      W4CTYP = 'C'                                              BUG3760
448100201218     C                   ELSE                                                                BUG3760
448200201218     C                   EVAL      W4CTYP = 'I'                                              BUG3760
448300201218     C                   ENDIF                                                               BUG3760
448400201218      *                                                                                      BUG3760
448500201218     C                   ENDIF                                                               BUG3760
448600201218      *                                                                                      BUG3760
448700201218     C                   ENDIF                                                               BUG3760
448800201218      *                                                                                      BUG3760
448900201218      ** Deal Date                                                                           BUG3760
449000201218      *                                                                                      BUG3760
449100201218     C                   MOVE      *ZERO         PZADayNo                                    BUG3760
449200201218     C                   EXSR      SRDateToDDT                                               BUG3760
449300201218     C                   EVAL      W4DDAT = WDDT                                             BUG3760
449400201218      *                                                                                      BUG3760
449500201218      ** Value Date                                                                          BUG3760
449600201218      *                                                                                      BUG3760
449700201218     C                   MOVE      VDAT          PZADayNo                                    BUG3760
449800201218     C                   EXSR      SRDateToDDT                                               BUG3760
449900201218     C                   EVAL      W4VDAT = WDDT                                             BUG3760
450000201218      *                                                                                      BUG3760
450100201218      ** Maturity Date                                                                       BUG3760
450200201218      *                                                                                      BUG3760
450300201218     C                   MOVE      *ZERO         PZADayNo                                    BUG3760
450400201218     C                   EXSR      SRDateToDDT                                               BUG3760
450500201218     C                   EVAL      W4MDAT = WDDT                                             BUG3760
450600201218      *                                                                                      BUG3760
450700201218      ** Denomination Side                                                                   BUG3760
450800201218      *                                                                                      BUG3760
450900201218     C                   MOVEL     CCY           W4DEN1                                      BUG3760
451000201218     C                   MOVEL     *BLANKS       W4DEN2                                      BUG3760
451100201218      *                                                                                      BUG3760
451200201218      ** Amount Side                                                                         BUG3760
451300201218      *                                                                                      BUG3760
451400201218     C                   MOVE      TAMT          PAMT                                        BUG3760
451500201218     C                   CALLB     'ZACVTAMT'                                                BUG3760
451600201218     C                   PARM                    PRetCode                                    BUG3760
451700201218     C                   PARM                    PYCCY                                       BUG3760
451800201218     C                   PARM                    PAMT                                        BUG3760
451900201218     C                   PARM                    ConvertedAmt                                BUG3760
452000201218     C                   PARM                    PDummy16                                    BUG3760
452100201218      *                                                                                      BUG3760
452200201218     C                   MOVE      ConvertedAmt  W4AMT1                                      BUG3760
452300201218     C                   EVAL      W4AMT2 = *ZERO                                            BUG3760
452400201218      *                                                                                      BUG3760
452500201218      ** Send transaction details to Compliance Watch                                        BUG3760
452600201218      *                                                                                      BUG3760
452700201218     C                   CALL      'SDCWLCHK'                                                BUG3760
452800201218     C                   PARM                    SDWLTD                                      BUG3760
452900201218     C                   PARM                    PFreeFmtStr                                 BUG3760
453000201218      *                                                                                      BUG3760
453100201218     C                   ENDIF                                                               BUG3760
453200201218      *                                                                                      BUG3760
453300201218     C                   ENDSR                                                               BUG3760
453400201218      *****************************************************************                      BUG3760
453500201218      /EJECT                                                                                 BUG3760
453600201218      *****************************************************************                      BUG3760
453700201218      *                                                               *                      BUG3760
453800201218      * SRDateToDDT - Converts a date into Date Data Type format.     *                      BUG3760
453900201218      *                                                               *                      BUG3760
454000201218      *****************************************************************                      BUG3760
454100201218     C     SRDateToDDT   BEGSR                                                               BUG3760
454200201218      *                                                                                      BUG3760
454300201218      ** Convert the derived Midas Day Number into Date Data Type.                           BUG3760
454400201218      *                                                                                      BUG3760
454500201218     C                   CALL      'ZACVTDATE'                                               BUG3760
454600201218     C                   PARM      *BLANKS       PZARtCd                                     BUG3760
454700201218     C                   PARM                    PZADayNo                                    BUG3760
454800201218     C                   PARM                    PZADDT                                      BUG3760
454900201218     C                   PARM                    PZACvtDt                                    BUG3760
455000201218      *                                                                                      BUG3760
455100201218     C                   EVAL      WDDT = PZADDT                                             BUG3760
455200201218      *                                                                                      BUG3760
455300201218     C                   ENDSR                                                               BUG3760
455400201218      *****************************************************************                      BUG3760
455500201218      /EJECT                                                                                 BUG3760
455600201218      *****************************************************************                       CAS011
455700201218      *                                                               *                       CAS011
455800201218      *  SEIRI1 - Set EIR Indicators to re-calculate.                 *                       CAS011
455900201218      *                                                               *                       CAS011
456000201218      *****************************************************************                       CAS011
456100201218                                                                                              CAS011
456200201218     C     SEIRI1        BEGSR                                                                CAS011
456300201218                                                                                              CAS011
456400201218     C                   IF        CAS016 = 'Y'                                               CAS019
456500201218     C     WTRAN         CHAIN     LEEIRDL9                                                   CAS019
456600201218     C                   ELSE                                                                 CAS019
456700201218     C     WTRAN         CHAIN     LEEIRDD5                                                   CAS011
456800201218     C                   ENDIF                                                                CAS019
456900201218     C                   IF        %FOUND AND WVALD <= EIENDT                                 CAS011
457000201218                                                                                              CAS011
457100201218     C                   EVAL      EIRCAL = 'Y'                                               CAS011
457200201218                                                                                              CAS011
457300201218     C                   IF        WDELR = 'Y' OR WADJP = 'Y'                                 CAS011
457400201218     C                   EVAL      EIADJP = 'Y'                                               CAS011
457500201218     C                   ENDIF                                                                CAS011
457600201218                                                                                              CAS011
457700201218     C                   IF        CAS016 = 'Y'                                               CAS019
457800201218     C                   UPDATE    LEEIRDD9                                                   CAS019
457900201218     C                   ELSE                                                                 CAS019
458000201218     C                   UPDATE    LEEIRDD5                                                   CAS011
458100201218     C                   ENDIF                                                                CAS019
458200201218                                                                                              CAS011
458300201218     C                   ENDIF                                                                CAS011
458400201218                                                                                              CAS019
458500201218      ** Search all fees amortised separately                                                 CAS019
458600201218                                                                                              CAS019
458700201218     C                   IF        CAS016 = 'Y'                                               CAS019
458800201218     C     WTRAN         CHAIN     LEERAPL1                           20                      CAS019
458900201218     C                   DOW       *IN20 = '0'                                                CAS019
459000201218      *                                                                                       CAS019
459100201218     C     LACHTP        IFEQ      'I'                                                        CAS019
459200201218     C     LACHTP        OREQ      'R'                                                        CAS019
459300201218     C     VDAT          IFLE      EIENDT                                                     CAS019
459400201218     C                   MOVE      'Y'           EIRCAL                                       CAS019
459500201218     C                   UPDATE    LEERAPD0                                                   CAS019
459600201218     C                   ENDIF                                                                CAS019
459700201218     C                   ENDIF                                                                CAS019
459800201218      *                                                                                       CAS019
459900201218     C     WTRAN         READE     LEERAPL1                               20                  CAS019
460000201218     C                   ENDDO                                                                CAS019
460100201218      *                                                                                       CAS019
460200201218     C                   ENDIF                                                                CAS019
460300201218                                                                                              CAS011
460400201218     C                   ENDSR                                                                CAS011
460500201218      *****************************************************************                       CAS011
460600201218      /EJECT                                                                                  CLE073
460700201218      *****************************************************************                       CLE073
460800201218      *  CHKLON  -  Check if loan has associated fees                 *                       CLE073
460900201218      *  Called by: SRFEES                                            *                       CLE073
461000201218      *  Calls    : None                                              *                       CLE073
461100201218      *****************************************************************                       CLE073
461200201218      *                                                                                       CLE073
461300201218     C     CHKLON        BEGSR                                                                CLE073
461400201218      *                                                                                       CLE073
461500201218     C                   Z-ADD     0             WFFACL                                       CLE073
461600201218     C                   MOVEL     LALNRF        WFLOAN                                       CLE073
461700201218     C     WKFEE         SETLL     LEFEEDL1                                                   CLE073
461800201218     C*****WKFEE         READE     LEFEEDL1                               89         CLE073 MD023203
461900201218     C     WKFEE         READE (N) LEFEEDL1                               89                MD023203
462000201218      *                                                                                       CLE073
462100201218      ** Do while an associated fee exists                                                    CLE073
462200201218      *                                                                                       CLE073
462300201218     C     *IN89         DOWEQ     *OFF                                                       CLE073
462400201218      *                                                                                       CLE073
462500201218      ** If the fee is a confirmed calculated fee and swift                                   CLE073
462600201218      ** regeneration indicator is not 'I', 'B', 'H'                                          CLE073
462700201218      ** and Value Date is on or after Fee Start and before or on Fee End date                CLE073
462800201218      *                                                                                       CLE073
462900201218     C     FEAUTO        IFEQ      'Y'                                                        CLE073
463000201218     C     FESWRI        ANDNE     'I'                                                        CLE073
463100201218     C     FESWRI        ANDNE     'B'                                                        CLE073
463200201218     C     FESWRI        ANDNE     'H'                                                        CLE073
463300201218     C     FECALT        ANDEQ     '97'                                                       CLE073
463400201218     C     LAVDAT        ANDGE     FEPSTD                                                     CLE073
463500201218     C     LAVDAT        ANDLE     FEPEND                                                     CLE073
463600201218      *                                                                                       CLE073
463700201218      ** Set currency to fee currency                                                         CLE073
463800201218      ** Set day to run date                                                                  CLE073
463900201218      ** Set number of working days to telex notice days                                      CLE073
464000201218      *                                                                                       CLE073
464100201218     C                   MOVE      FEFCCY        ZCCY                                         CLE073
464200201218     C                   Z-ADD     WRNDAY        ZDAYNO                                       CLE073
464300201218     C                   Z-ADD     1             X                                            CLE073
464400201218      *                                                                                     MD054317
464500201218      ** If CLE031 is on then use correct currency to access AONOSTR0                       MD054317
464600201218      *                                                                                     MD054317
464700201218     C                   MOVE      FEFCCY        WKCCY                                      MD054317
464800201218      *                                                                                     MD054317
464900201218     C     CLE031        IFEQ      'Y'                                                      MD054317
465000201218      *                                                                                     MD054317
465100201218     C     PTFI          IFEQ      'P'                                                      MD054317
465200201218     C     FEPSCY        IFNE      *BLANKS                                                  MD054317
465300201218     C                   MOVE      FEPSCY        WKCCY                                      MD054317
465400201218     C                   ENDIF                                                              MD054317
465500201218     C                   ELSE                                                               MD054317
465600201218     C     FESCCY        IFNE      *BLANKS                                                  MD054317
465700201218     C                   MOVE      FESCCY        WKCCY                                      MD054317
465800201218     C                   ENDIF                                                              MD054317
465900201218     C                   ENDIF                                                              MD054317
466000201218      *                                                                                     MD054317
466100201218     C                   ENDIF                                                              MD054317
466200201218      *                                                                                     MD054317
466300201218     C                   MOVE      WKCCY         ZCCY                                       MD054317
466400201218     C                   MOVE      WKCCY         @CURR                                      MD054317
466500201218      *                                                                                     MD054317
466600201218     C*****FEFCCY        LOOKUP    CYA(X)                                 69         CLE073 MD054317
466700201218     C     WKCCY         LOOKUP    CYA(X)                                 69                MD054317
466800201218     C                   MOVE      *OFF          *IN69                                        CLE073
466900201218     C                   MOVE      TND(X)        ZNRDYS                                       CLE073
467000201218      *                                                                                       CLE073
467100201218      ** If Fee Settlement type is '01', '02', '07', '08' or '12'                             CLE073
467200201218      *                                                                                       CLE073
467300201218     C     FESTTL        IFEQ      01                                                         CLE073
467400201218     C     FESTTL        OREQ      02                                                         CLE073
467500201218     C     FESTTL        OREQ      07                                                         CLE073
467600201218     C     FESTTL        OREQ      08                                                         CLE073
467700201218     C     FESTTL        OREQ      12                                                         CLE073
467800201218      *                                                                                       CLE073
467900201218     C                   CALLB     'AONOSTR0'                                                 CLE073
468000201218     C                   PARM      *BLANKS       @RtCd                                        CLE073
468100201218     C                   PARM      '*KEY   '     @Optn                                        CLE073
468200201218     C                   PARM                    @Cusn             6                          CLE073
468300201218     C**********         PARM      FEFCCY        @Curr             3                 CLE073 MD054317
468400201218     C                   PARM                    @Curr                                      MD054317
468500201218     C                   PARM                    @Accd                                        CLE073
468600201218     C                   PARM                    @Acsn             2                          CLE073
468700201218     C                   PARM      FEOURS        @Nonb             2                          CLE073
468800201218     C                   PARM                    @Brca             3                          CLE073
468900201218     C                   PARM                    @Cssn            10                          CLE073
469000201218     C                   PARM                    @Pnoi             1                          CLE073
469100201218     C     SDNOST        PARM                    DSFDY                                        CLE073
469200201218      *                                                                                       CLE073
469300201218     C     @RtCd         IFNE      *BLANKS                                                    CLE073
469400201218     C                   MOVEL     'AONOSTR0'    DBFILE                                       CLE073
469500201218     C                   Z-ADD     900           DBASE                                        CLE073
469600201218     C                   MOVEL     FEFCCY        DBKEY                                        CLE073
469700201218     C                   EXSR      *PSSR                                                      CLE073
469800201218     C                   ELSE                                                                 CLE073
469900201218      *                                                                                       CLE073
470000201218      ** Set Location to Nostro Location                                                      CLE073
470100201218      *                                                                                       CLE073
470200201218     C                   MOVE      A7NOSN        ZLOC                                         CLE073
470300201218     C                   ENDIF                                                                CLE073
470400201218      *                                                                                       CLE073
470500201218     C                   ELSE                                                                 CLE073
470600201218      *                                                                                       CLE073
470700201218     C                   MOVE      *BLANKS       ZLOC                                         CLE073
470800201218      *                                                                                       CLE073
470900201218     C                   ENDIF                                                                CLE073
471000201218      *                                                                                       CLE073
471100201218      ** Calculate number of working days forward                                             CLE073
471200201218      *                                                                                       CLE073
471300201218     C                   CALLB     'ZFWDT'                                                    CLE073
471400201218     C                   PARM                    ZDAYNO            5 0                        CLE073
471500201218     C                   PARM                    ZNRDYS            2 0                        CLE073
471600201218     C                   PARM      *ZERO         ZDYNBR            5 0                        CLE073
471700201218     C                   PARM                    ZCCY              3                          CLE073
471800201218     C                   PARM      *BLANKS       ZLOC              3                          CLE073
471900201218      *                                                                                       CLE073
472000201218      ** Set Telex Notice date to day number                                                  CLE073
472100201218      *                                                                                       CLE073
472200201218     C                   Z-ADD     ZDYNBR        TXDT              5 0                        CLE073
472300201218      *                                                                                     MD023203
472400201218     C                   MOVEL     FECNUM        WFCNUMX                                    MD023203
472500201218     C                   MOVEL     FEFACL        WFFACLX                                    MD023203
472600201218     C                   MOVEL     FELOAN        WFLOANX                                    MD023203
472700201218     C                   MOVEL     FEFSEQ        WFSEQNX                                    MD023203
472800201218      *                                                                                       CLE073
472900201218      ** If next payment date is before or equals to Telex Notice date                        CLE073
473000201218      ** and Next Payment Telex indicator is set to 'Y'                                       CLE073
473100201218      *                                                                                       CLE073
473200201218     C     FENPYD        IFLE      TXDT                                                       CLE073
473300201218     C     FEPPTI        ANDEQ     'Y'                                                        CLE073
473400201218      *                                                                                       CLE073
473500201218      ** Update Fees file                                                                     CLE073
473600201218      *                                                                                       CLE073
473700201218     C     WKFEEX        CHAIN     LEFEEDL0                                                 MD023203
473800201218     C                   IF        %FOUND(LEFEEDL0)                                         MD023203
473900201218     C**********         MOVE      'A'           FESWRI                              CLE073 MD023203
474000201218     C**********         UPDATE    LEFEEDF                                           CLE073 MD023203
474100201218     C                   MOVE      'A'           X_FESWRI                                   MD023203
474200201218     C                   UPDATE    LEFEEDX                                                  MD023203
474300201218     C                   ENDIF                                                              MD023203
474400201218     C                   ELSE                                                                 CLE073
474500201218      *                                                                                       CLE073
474600201218      ** If end date is before or equals to Telex Notice date and End                         CLE073
474700201218      ** Telex indicator is set to 'Y'                                                        CLE073
474800201218      *                                                                                       CLE073
474900201218     C     FEPEND        IFLE      TXDT                                                       CLE073
475000201218     C     FEEPTI        ANDEQ     'Y'                                                        CLE073
475100201218      *                                                                                       CLE073
475200201218      ** Update Fees file                                                                     CLE073
475300201218      *                                                                                       CLE073
475400201218     C     WKFEEX        CHAIN     LEFEEDL0                                                 MD023203
475500201218     C                   IF        %FOUND(LEFEEDL0)                                         MD023203
475600201218     C**********         MOVE      'A'           FESWRI                              CLE073 MD023203
475700201218     C**********         UPDATE    LEFEEDF                                           CLE073 MD023203
475800201218     C                   MOVE      'A'           X_FESWRI                                   MD023203
475900201218     C                   UPDATE    LEFEEDX                                                  MD023203
476000201218     C                   ENDIF                                                              MD023203
476100201218     C                   ENDIF                                                                CLE073
476200201218     C                   ENDIF                                                                CLE073
476300201218      *                                                                                       CLE073
476400201218     C                   ENDIF                                                                CLE073
476500201218      *                                                                                       CLE073
476600201218     C*****WKFEE         READE     LEFEEDL1                               89         CLE073 MD023203
476700201218     C     WKFEE         READE (N) LEFEEDL1                               89                MD023203
476800201218     C                   ENDDO                                                                CLE073
476900201218      *                                                                                       CLE073
477000201218     C                   ENDSR                                                                CLE073
477100201218      *                                                                                       CLE073
477200201218      *****************************************************************                       CLE073
477300201218      /EJECT                                                                                MD023787
477400201218      *****************************************************************                     MD023787
477500201218      *  GETLON  -  Get loan details for PDCL projection.             *                     MD023787
477600201218      *  Called by: INSERT                                            *                     MD023787
477700201218      *  Calls    : None                                              *                     MD023787
477800201218      *****************************************************************                     MD023787
477900201218     C     GETLON        BEGSR                                                              MD023787
478000201218      *                                                                                     MD023787
478100201218     C                   MOVE      'Y'           PDCLI                                      MD023787
478200201218      *                                                                                     MD023787
478300201218      ** Set the PI Reciept from loan Reciept.                                              MD023787
478400201218      *                                                                                     MD023787
478500201218     C     LARONS        IFEQ      *BLANKS                                                  MD023787
478600201218     C                   MOVE      LO_RSTM       LARSTM                                     MD023787
478700201218     C                   MOVE      LO_RONS       LARONS                                     MD023787
478800201218     C                   MOVE      LO_RIBN       LARIBN                                     MD023787
478900201218     C                   MOVE      LO_RIBA       LARIBA                                     MD023787
479000201218     C                   MOVE      LO_ROBN       LAROBN                                     MD023787
479100201218     C                   MOVE      LO_ROCN       LAROCN                                     MD023787
479200201218     C                   ENDIF                                                              MD023787
479300201218      *                                                                                     MD023787
479400201218      ** Set PI pay settlement into '00' and blanks.                                        MD023787
479500201218      *                                                                                     MD023787
479600201218     C                   MOVE      '00'          LAPSTM                                     MD023787
479700201218     C                   MOVE      *BLANKS       LAPONS                                     MD023787
479800201218     C                   MOVE      *BLANKS       LAPIBN                                     MD023787
479900201218     C                   MOVE      *BLANKS       LAPIBA                                     MD023787
480000201218     C                   MOVE      *BLANKS       LAPOBN                                     MD023787
480100201218     C                   MOVE      *BLANKS       LAPOCN                                     MD023787
480200201218     C                   MOVE      *BLANKS       LARCRN                                     MD023787
480300201218     C                   MOVE      *BLANKS       LARCRA                                     MD023787
480400201218     C                   MOVE      *BLANKS       LARVNO                                     MD023787
480500201218     C                   MOVE      *BLANKS       LAAWBN                                     MD023787
480600201218     C                   MOVE      *BLANKS       LABENN                                     MD023787
480700201218     C                   MOVE      *BLANKS       LADTP1                                     MD023787
480800201218     C                   MOVE      *BLANKS       LADTP2                                     MD023787
480900201218     C                   MOVE      *BLANKS       LADTP3                                     MD023787
481000201218     C                   MOVE      *BLANKS       LADTP4                                     MD023787
481100201218     C                   MOVE      *BLANKS       LADCHG                                     MD023787
481200201218     C                   MOVE      *BLANKS       LABTB1                                     MD023787
481300201218     C                   MOVE      *BLANKS       LABTB2                                     MD023787
481400201218     C                   MOVE      *BLANKS       LABTB3                                     MD023787
481500201218     C                   MOVE      *BLANKS       LABTB4                                     MD023787
481600201218     C                   MOVE      *BLANKS       LABTB5                                     MD023787
481700201218     C                   MOVE      *BLANKS       LABTB6                                     MD023787
481800201218     C                   MOVE      *BLANKS       LACVMR                                     MD023787
481900201218      *                                                                                     MD023787
482000201218     C                   ENDSR                                                              MD023787
482100201218      *                                                                                     MD023787
482200201218      *****************************************************************                     MD023787
482300201218      /EJECT                                                                                MD050018
482400201218      *****************************************************************                     MD050018
482500201218      *  SrUpdPDCL - Update of PDP link files LEPDUEPD/LEPDUFPD on ic *                     MD050018
482600201218      *  Called by: INSERT  and AMEND                                 *                     MD050018
482700201218      *  Calls    : SrLEPDUEIns, SrLEPDUFIns, SrLEPDUEDelAmd          *                     MD050018
482800201218      *             SrLEPDUFDelAmd                                    *                     MD050018
482900201218      *****************************************************************                     MD050018
483000201218     C     SrUpdPDCL     BEGSR                                                              MD050018
483100201218      *                                                                                     MD050018
483200201218      ** Check PDCL loan details                                                            MD050018
483300201218     C                   EVAL      WkLNR = LALNRF                                           MD050018
483400201218     C                   EVAL      WRCDT = 'A'                                              MD050018
483500201218     C     KLKEY         CHAIN(N)  CLOAN                              99                    MD050018
483600201218     C     *IN99         IFEQ      '1'                                                      MD050018
483700201218     C                   MOVEL     'CLOAN   '    DBFILE                                     MD050018
483800201218     C                   Z-ADD     33            DBASE                                      MD050018
483900201218     C                   MOVEL     WKLNR         DBKEY                                      MD050018
484000201218     C                   EXSR      *PSSR                                                    MD050018
484100201218     C                   ENDIF                                                              MD050018
484200201218      *                                                                                     MD050018
484300201218      ** For insert action, add new 'P' record                                              MD050018
484400201218      ** Also update 'D' record                                                             MD050018
484500201218     C                   IF        DDACTN = 'I'                                             MD050018
484600201218     C                   IF        %SUBST(LTYPA:1:1) = 'X' OR                               MD050018
484700201218     C                             %SUBST(LTYPA:1:1) = 'Y'                                  MD050018
484800201218     C                   EXSR      SrLEPDUEIns                                              MD050018
484900201218     C                   ELSE                                                               MD050018
485000201218     C                   EXSR      SrLEPDUFIns                                              MD050018
485100201218     C                   ENDIF                                                              MD050018
485200201218      *                                                                                     MD050018
485300201218     C                   ELSE                                                               MD050018
485400201218      ** For Amend/Delete action, update amount of the existing 'P' record                  MD050018
485500201218      ** Also update 'D' record                                                             MD050018
485600201218     C                   IF        %SUBST(LTYPA:1:1) = 'X' OR                               MD050018
485700201218     C                             %SUBST(LTYPA:1:1) = 'Y'                                  MD050018
485800201218     C                   EXSR      SrLEPDUEDelAmd                                           MD050018
485900201218     C                   ELSE                                                               MD050018
486000201218     C                   EXSR      SrLEPDUFDelAmd                                           MD050018
486100201218     C                   ENDIF                                                              MD050018
486200201218     C                   ENDIF                                                              MD050018
486300201218      *                                                                                     MD050018
486400201218     C                   ENDSR                                                              MD050018
486500201218      *****************************************************************                     MD050018
486600201218      /EJECT                                                                                MD050018
486700201218      *****************************************************************                     MD050018
486800201218      * SrLEPDUEIns - Update of LEPDUEPD on ic for insert             *                     MD050018
486900201218      * Called by: SrUpdPDCL                                          *                     MD050018
487000201218      * Calls    : None                                               *                     MD050018
487100201218      *****************************************************************                     MD050018
487200201218     C     SrLEPDUEIns   BEGSR                                                              MD050018
487300201218      *                                                                                     MD050018
487400201218     C                   CLEAR                   LEPDUED0                                   MD050018
487500201218      *                                                                                     MD050018
487600201218      ** Update the corresponding 'D' record to increase YPCPAM/YPDINT                      MD050018
487700201218     C                   EVAL      WkReci = 'D'                                             MD050018
487800201218     C                   IF        %SUBST(LTYPA:1:1) = 'X'                                  MD050018
487900201218     C                   EVAL      WkPDCT = 'P'                                             MD050018
488000201218     C                   ELSE                                                               MD050018
488100201218     C                   EVAL      WkPDCT = 'I'                                             MD050018
488200201218     C                   ENDIF                                                              MD050018
488300201218      *                                                                                     MD050018
488400201218     C     KLEPDUE2      CHAIN     LEPDUEL6                                                 MD050018
488500201218     C                   IF        %FOUND(LEPDUEL6)                                         MD050018
488600201218     C                   IF        %SUBST(LTYPA:1:1) = 'X'                                  MD050018
488700201218     C                   EVAL      YPCPAM = YPCPAM + LAPRAM                                 MD050018
488800201218     C                   ELSE                                                               MD050018
488900201218     C                   EVAL      YPDINT = YPDINT + LAPRAM                                 MD050018
489000201218     C                   ENDIF                                                              MD050018
489100201218     C                   UPDATE    LEPDUED6                                                 MD050018
489200201218     C                   ENDIF                                                              MD050018
489300201218      *                                                                                     MD050018
489400201218      ** Populate 'P' fields                                                                MD050018
489500201218     C                   EVAL      YRECI = 'P'                                              MD050018
489600201218     C                   EVAL      YPLON = LALNRF                                           MD050018
489700201218     C                   Z-ADD     LO_VDAT       YVDAT                                      MD050018
489800201218     C                   EVAL      YPORG = LO_ORLN                                          MD050018
489900201218     C                   EVAL      YBRCA = LO_BRCA                                          MD050018
490000201218     C                   EVAL      YTKPACL = *BLANKS                                        MD050018
490100201218     C                   EVAL      YTKPABR = *BLANKS                                        MD050018
490200201218     C                   Z-ADD     0             YTKPAAC                                    MD050018
490300201218     C                   Z-ADD     0             YTKPASE                                    MD050018
490400201218     C                   EVAL      YTKPACY = *BLANKS                                        MD050018
490500201218     C                   EVAL      YTKIACL = *BLANKS                                        MD050018
490600201218     C                   EVAL      YTKIABR = *BLANKS                                        MD050018
490700201218     C                   Z-ADD     0             YTKIAAC                                    MD050018
490800201218     C                   Z-ADD     0             YTKIASE                                    MD050018
490900201218     C                   EVAL      YTKIACY = *BLANKS                                        MD050018
491000201218     C                   EVAL      YDECRE = 'N'                                             MD050018
491100201218     C                   Z-ADD     LAVDAT        YPDVDT                                     MD050018
491200201218     C                   Z-ADD     WRNDAY        YLCD                                       MD050018
491300201218     C                   EVAL      YTYLC = 'I'                                              MD050018
491400201218     C                   EVAL      YPIUSE = LAIUSR                                          MD050018
491500201218     C                   EVAL      YPCBIC = 'I'                                             MD050018
491600201218     C                   Z-ADD     LALASN        YPOSEQ                                     MD050018
491700201218     C                   EVAL      YPFRNT = LAFRNT                                          MD050018
491800201218      *                                                                                     MD050018
491900201218     C                   IF        %SUBST(LTYPA:1:1) = 'X'                                  MD050018
492000201218     C                   EVAL      YPDCT = 'P'                                              MD050018
492100201218     C                   EVAL      WkPDCT = 'P'                                             MD050018
492200201218     C                   Z-ADD     LAPRAM        YPCPAM                                     MD050018
492300201218     C                   Z-ADD     LAPRAM        YPOREP                                     MD050018
492400201218     C                   Z-ADD     0             YPDINT                                     MD050018
492500201218     C                   Z-ADD     0             YPOREI                                     MD050018
492600201218     C                   ELSE                                                               MD050018
492700201218     C                   EVAL      YPDCT = 'I'                                              MD050018
492800201218     C                   EVAL      WkPDCT = 'I'                                             MD050018
492900201218     C                   Z-ADD     LAPRAM        YPDINT                                     MD050018
493000201218     C                   Z-ADD     LAPRAM        YPOREI                                     MD050018
493100201218     C                   Z-ADD     0             YPCPAM                                     MD050018
493200201218     C                   Z-ADD     0             YPOREP                                     MD050018
493300201218     C                   ENDIF                                                              MD050018
493400201218      *                                                                                     MD050018
493500201218     C                   CALLB     'ZAGENTMSTM'                                             MD050018
493600201218     C                   PARM                    YPTMST                                     MD050018
493700201218     C                   WRITE     LEPDUED0                                                 MD050018
493800201218      *                                                                                     MD050018
493900201218     C                   ENDSR                                                              MD050018
494000201218      *****************************************************************                     MD050018
494100201218      /EJECT                                                                                MD050018
494200201218      *****************************************************************                     MD050018
494300201218      * SrLEPDUEDelAmd - Update of LEPDUEPD on ic for amend and delete*                     MD050018
494400201218      * Called by: SrUpdPDCL                                          *                     MD050018
494500201218      * Calls    : None                                               *                     MD050018
494600201218      *****************************************************************                     MD050018
494700201218     C     SrLEPDUEDelAmdBEGSR                                                              MD050018
494800201218      *                                                                                     MD050018
494900201218      ** Update 'P record                                                                   MD050018
495000201218     C                   Z-ADD     0             WkDINT                                     MD050018
495100201218     C                   Z-ADD     0             WkCPAM                                     MD050018
495200201218     C                   Z-ADD     LALASN        WkLASN                                     MD050018
495300201218     C     KLEPDUE1      CHAIN     LEPDUELE                                                 MD050018
495400201218     C                   IF        %FOUND(LEPDUELE)                                         MD050018
495500201218      *                                                                                     MD050018
495600201218     C                   IF        %SUBST(LTYPA:1:1) = 'X'                                  MD050018
495700201218     C                   EVAL      WkPDCT = 'P'                                             MD050018
495800201218     C                   Z-ADD     YPCPAM        WkCPAM                                     MD050018
495900201218     C                   Z-ADD     LAPRAM        YPCPAM                                     MD050018
496000201218     C                   Z-ADD     LAPRAM        YPOREP                                     MD050018
496100201218     C                   Z-ADD     0             YPDINT                                     MD050018
496200201218     C                   Z-ADD     0             YPOREI                                     MD050018
496300201218     C                   ELSE                                                               MD050018
496400201218     C                   EVAL      WkPDCT = 'I'                                             MD050018
496500201218     C                   Z-ADD     YPDINT        WkDINT                                     MD050018
496600201218     C                   Z-ADD     LAPRAM        YPDINT                                     MD050018
496700201218     C                   Z-ADD     LAPRAM        YPOREI                                     MD050018
496800201218     C                   Z-ADD     0             YPCPAM                                     MD050018
496900201218     C                   Z-ADD     0             YPOREP                                     MD050018
497000201218     C                   ENDIF                                                              MD050018
497100201218      *                                                                                     MD050018
497200201218     C                   IF        DDACTN = 'R'                                             MD050018
497300201218     C                   DELETE    LEPDUED0                                                 MD050018
497400201218     C                   ELSE                                                               MD050018
497500201218     C                   CALLB     'ZAGENTMSTM'                                             MD050018
497600201218     C                   PARM                    YPTMST                                     MD050018
497700201218     C                   UPDATE    LEPDUED0                                                 MD050018
497800201218     C                   ENDIF                                                              MD050018
497900201218      *                                                                                     MD050018
498000201218      ** Update 'D' record to increase/decrease YPCPAM/YPDINT                               MD050018
498100201218     C                   EVAL      WkReci = 'D'                                             MD050018
498200201218     C     KLEPDUE2      CHAIN     LEPDUEL6                                                 MD050018
498300201218     C                   IF        %FOUND(LEPDUEL6)                                         MD050018
498400201218      *                                                                                     MD050018
498500201218     C                   IF        DDACTN = 'R'                                             MD050018
498600201218     C                   EVAL      YPCPAM = YPCPAM - WkCPAM                                 MD050018
498700201218     C                   EVAL      YPDINT = YPDINT - WkDINT                                 MD050018
498800201218     C                   ELSE                                                               MD050018
498900201218     C                   IF        %SUBST(LTYPA:1:1) = 'X'                                  MD050018
499000201218     C                   EVAL      YPCPAM = YPCPAM + LAPRAM - WkCPAM                        MD050018
499100201218     C                   ELSE                                                               MD050018
499200201218     C                   EVAL      YPDINT = YPDINT + LAPRAM - WkDINT                        MD050018
499300201218     C                   ENDIF                                                              MD050018
499400201218     C                   ENDIF                                                              MD050018
499500201218     C                   CALLB     'ZAGENTMSTM'                                             MD050018
499600201218     C                   PARM                    YPTMST                                     MD050018
499700201218     C                   UPDATE    LEPDUED6                                                 MD050018
499800201218     C                   ENDIF                                                              MD050018
499900201218      *                                                                                     MD050018
500000201218     C                   ENDIF                                                              MD050018
500100201218      *                                                                                     MD050018
500200201218     C                   ENDSR                                                              MD050018
500300201218      *****************************************************************                     MD050018
500400201218      /EJECT                                                                                MD050018
500500201218      *****************************************************************                     MD050018
500600201218      * SrLEPDUFIns - Update of LEPDUFPD on ic for insert             *                     MD050018
500700201218      * Called by: SrUpdPDCL                                          *                     MD050018
500800201218      * Calls    : None                                               *                     MD050018
500900201218      *****************************************************************                     MD050018
501000201218     C     SrLEPDUFIns   BEGSR                                                              MD050018
501100201218      *                                                                                     MD050018
501200201218     C                   CLEAR                   LEPDUFD0                                   MD050018
501300201218      *                                                                                     MD050018
501400201218     C                   EVAL      WkReci = 'D'                                             MD050018
501500201218     C     KLEPDUF1      CHAIN     LEPDUFLA                                                 MD050018
501600201218     C                   IF        %FOUND(LEPDUFLA)                                         MD050018
501700201218      ** Update 'D' record                                                                  MD050018
501800201218     C                   EVAL      YPCPAM = YPCPAM + LAPRAM                                 MD050018
501900201218     C                   UPDATE    LEPDUFD0                                                 MD050018
502000201218      *                                                                                     MD050018
502100201218      ** Insert 'P' record                                                                  MD050018
502200201218     C                   EVAL      YRECI = 'P'                                              MD050018
502300201218     C                   EVAL      YPLON = LALNRF                                           MD050018
502400201218     C                   Z-ADD     LO_VDAT       YVDAT                                      MD050018
502500201218     C                   Z-ADD     LAPRAM        YPCPAM                                     MD050018
502600201218     C                   EVAL      YTKPACL = *BLANKS                                        MD050018
502700201218     C                   EVAL      YTKPABR = *BLANKS                                        MD050018
502800201218     C                   Z-ADD     0             YTKPAAC                                    MD050018
502900201218     C                   Z-ADD     0             YTKPASE                                    MD050018
503000201218     C                   EVAL      YTKPACY = *BLANKS                                        MD050018
503100201218     C                   EVAL      YDECRE = 'N'                                             MD050018
503200201218     C                   Z-ADD     LAVDAT        YPDVDT                                     MD050018
503300201218     C                   Z-ADD     WRNDAY        YLCD                                       MD050018
503400201218     C                   EVAL      YTYLC = 'I'                                              MD050018
503500201218     C                   EVAL      YPIUSE = LAIUSR                                          MD050018
503600201218     C                   EVAL      YPCBIC = 'I'                                             MD050018
503700201218     C                   Z-ADD     LAPRAM        YPOREP                                     MD050018
503800201218     C                   EVAL      YPFRNT = LAFRNT                                          MD050018
503900201218     C                   CALLB     'ZAGENTMSTM'                                             MD050018
504000201218     C                   PARM                    YPTMST                                     MD050018
504100201218     C                   WRITE     LEPDUFD0                                                 MD050018
504200201218                                                                                            MD050018
504300201218     C                   ENDIF                                                              MD050018
504400201218     C                   ENDSR                                                              MD050018
504500201218      *****************************************************************                     MD050018
504600201218      /EJECT                                                                                MD050018
504700201218      *****************************************************************                     MD050018
504800201218      * SrLEPDUFDelAmd - Update of LEPDUFPD on ic for amend and delete*                     MD050018
504900201218      * Called by: SrUpdPDCL                                          *                     MD050018
505000201218      * Calls    : None                                               *                     MD050018
505100201218      *****************************************************************                     MD050018
505200201218     C     SrLEPDUFDelAmdBEGSR                                                              MD050018
505300201218      *                                                                                     MD050018
505400201218      ** Update amount of 'P' record'                                                       MD050018
505500201218     C                   Z-ADD     0             WkCPAM                                     MD050018
505600201218     C     KLEPDUF2      SETLL     LEPDUFLE                                                 MD050018
505700201218     C     KLEPDUF2      READE     LEPDUFLE                               70                MD050018
505800201218     C                   DOW       *IN70 = *OFF                                             MD050018
505900201218     C                   IF        YPCPAM = WPRAM                                           MD050018
506000201218     C                   Z-ADD     YPCPAM        WkCPAM                                     MD050018
506100201218     C                   IF        DDACTN = 'R'                                             MD050018
506200201218     C                   DELETE    LEPDUFDE                                                 MD050018
506300201218     C                   ELSE                                                               MD050018
506400201218     C                   Z-ADD     LAPRAM        YPCPAM                                     MD050018
506500201218     C                   Z-ADD     LAPRAM        YPOREP                                     MD050018
506600201218     C                   UPDATE    LEPDUFDE                                                 MD050018
506700201218     C                   ENDIF                                                              MD050018
506800201218      *                                                                                     MD050018
506900201218      ** Update amount of 'D' record                                                        MD050018
507000201218     C                   EVAL      WkReci = 'D'                                             MD050018
507100201218     C     KLEPDUF1      CHAIN     LEPDUFLA                                                 MD050018
507200201218     C                   IF        %FOUND(LEPDUFLA)                                         MD050018
507300201218     C                   IF        DDACTN = 'R'                                             MD050018
507400201218     C                   EVAL      YPCPAM = YPCPAM - WkCPAM                                 MD050018
507500201218     C                   ELSE                                                               MD050018
507600201218     C                   EVAL      YPCPAM = YPCPAM + LAPRAM - WkCPAM                        MD050018
507700201218     C                   ENDIF                                                              MD050018
507800201218     C                   UPDATE    LEPDUFD0                                                 MD050018
507900201218     C                   ENDIF                                                              MD050018
508000201218     C                   LEAVE                                                              MD050018
508100201218     C                   ENDIF                                                              MD050018
508200201218     C     KLEPDUF2      READE     LEPDUFLE                               70                MD050018
508300201218     C                   ENDDO                                                              MD050018
508400201218     C                   ENDSR                                                              MD050018
508500201218      *****************************************************************                     MD050018
508600201218      /EJECT                                                                                  CAS011
508700201218      *****************************************************************                      BUG3760
508800201218      * *INZSR - Program Initialisation routine                       *
508900201218      *****************************************************************
509000201218     C     *INZSR        BEGSR
509100201218      *
509200201218      ** Program parameters
509300201218     C     *ENTRY        PLIST
509400201218
509500201218      ** Return code
509600201218     C                   PARM                    @@RTCD            7
509700201218
509800201218      ** Action requested
509900201218     C                   PARM                    DDACTN            1
510000201218
510100201218      ** Externally described DS for valid loan amendment
510200201218     C                   PARM                    ValidLoam
510300201218
510400201218      * Calling module code
510500201218     C                   PARM                    CallModCod        3
510600201218
510700201218      ** Reservation ID (input from VU only)
510800201218     C                   PARM                    ReservId         10
510900201218
511000201218      * Features
511100201218     C                   PARM                    CDE001            1
511200201218     C                   PARM                    CDE005            1
511300201218     C                   PARM                    CEU004            1
511400201218     C                   PARM                    CEU020            1
511500201218     C                   PARM                    CLE002            1
511600201218     C                   PARM                    CLE005            1
511700201218     C                   PARM                    CLE009            1
511800201218     C                   PARM                    CLE014            1
511900201218     C                   PARM                    CLE023            1
512000201218     C                   PARM                    CLE030            1                          CLE030
512100201218
512200201218      * Authorise amends / authorise principal tfr / consolidated conf.
512300201218     C                   PARM                    BPLMAU            1
512400201218     C                   PARM                    BPTPAU            1
512500201218     C                   PARM                    BPCONR            1
512600201218
512700201218      ** Date format indicator, local currency & run day number
512800201218     C                   PARM                    BJDFIN            1
512900201218     C                   PARM                    BJLCCY            3
513000201218     C                   PARM                    WRNDAY            5 0
513100201218
513200201218      ** Multi-branching
513300201218     C                   PARM                    BGMBIN            1
513400201218
513500201218      * Which system is active (24x7)
513600201218     C                   PARM                    System            1
513700201218      *
513800201218      ** Initialise program name
513900201218     C                   MOVEL     'LELOAMUPD'   DBPGM
514000201218      *
514100201218      ** Klist's
514200201218      *
514300201218     C     KLAKEY        KLIST
514400201218     C**********         KFLD                    WKLNR             6 0                        CLE148
514500201218     C                   KFLD                    WKLNR             6                          CLE148
514600201218     C                   KFLD                    WKVDT             5 0
514700201218     C                   KFLD                    WKLSN             3 0
514800201218      *
514900201218     C     KLKEY         KLIST
515000201218     C                   KFLD                    WKLNR
515100201218     C                   KFLD                    WRCDT             1
515200201218      *
515300201218     C     KFCLT         KLIST
515400201218     C**********         KFLD                    WFCNM             6 0                        CSD027
515500201218     C                   KFLD                    WFCNM             6                          CSD027
515600201218     C                   KFLD                    WFACT             3 0
515700201218     C                   KFLD                    WFNUM             2 0
515800201218     C                   KFLD                    WFRTP             1
515900201218      *
516000201218     C     KIDXF         KLIST
516100201218     C**********         KFLD                    WKLOAN            6 0                        CLE148
516200201218     C                   KFLD                    WKLOAN            6                          CLE148
516300201218     C                   KFLD                    WKDAY             5 0
516400201218     C                   KFLD                    WKSEQN            3 0
516500201218      *
516600201218     C     WKFEE         KLIST
516700201218     C**********         KFLD                    WFCNM             6 0                        CSD027
516800201218     C                   KFLD                    WFCNM             6                          CSD027
516900201218     C                   KFLD                    WFFACL            5 0
517000201218     C**********         KFLD                    WFLOAN            6 0                        CLE148
517100201218     C                   KFLD                    WFLOAN            6                          CLE148
517200201218                                                                                            MD023203
517300201218     C     WKFEEX        KLIST                                                              MD023203
517400201218     C                   KFLD                    WFCNUMX           6                        MD023203
517500201218     C                   KFLD                    WFFACLX           5 0                      MD023203
517600201218     C                   KFLD                    WFLOANX           6                        MD023203
517700201218     C                   KFLD                    WFSEQNX           2 0                      MD023203
517800201218                                                                                              CRE020
517900201218      ** Midas RE Settled Transaction Index File Key Lists                                    CRE020
518000201218                                                                                              CRE020
518100201218     C     KADVC         KLIST                                                                CRE020
518200201218     C                   KFLD                    KRefNo                                       CRE020
518300201218     C                   KFLD                    KPrgMn                                       CRE020
518400201218     C                   KFLD                    KSeqNo                                       CRE020
518500201218      *                                                                                      BUG3760
518600201218     C     KCwFld        KLIST                                                               BUG3760
518700201218     C                   KFLD                    WFuncType                                   BUG3760
518800201218     C                   KFLD                    WIdntifier                                  BUG3760
518900201218     C                   KFLD                    WBranch                                     BUG3760
519000201218      *                                                                                     MD050018
519100201218     C     KLEPDUE1      KLIST                                                              MD050018
519200201218     C                   KFLD                    LALNRF                                     MD050018
519300201218     C                   KFLD                    LAVDAT                                     MD050018
519400201218     C                   KFLD                    WkLASN                                     MD050018
519500201218     C     KLEPDUE2      KLIST                                                              MD050018
519600201218     C                   KFLD                    WkReci                                     MD050018
519700201218     C                   KFLD                    LALNRF                                     MD050018
519800201218     C                   KFLD                    WkPDCT                                     MD050018
519900201218     C     KLEPDUF1      KLIST                                                              MD050018
520000201218     C                   KFLD                    WkReci                                     MD050018
520100201218     C                   KFLD                    LALNRF                                     MD050018
520200201218     C     KLEPDUF2      KLIST                                                              MD050018
520300201218     C                   KFLD                    LALNRF                                     MD050018
520400201218     C                   KFLD                    LAVDAT                                     MD050018
520500201218      **********                                                                   MD024342 MD025467
520600201218     C*****KAPILST       KLIST                                                     MD024342 MD025467
520700201218     C**********         KFLD                    WAPIC             4               MD024342 MD025467
520800201218     C**********         KFLD                    WFILN            10               MD024342 MD025467
520900201218      *                                                                                     MD021423
521000201218      ** Get MPHAS dataarea.                                                                MD021423
521100201218      *                                                                                     MD021423
521200201218     C     *DTAARA       DEFINE                  MPHAS                                      MD021423
521300201218     C                   IN        MPHAS                                                    MD021423
521400201218     C                   UNLOCK    MPHAS                                                    MD021423
521500201218      *                                                                                      BUG3760
521600201218     C                   EVAL      CobMode = 'N'                                           MD021423E
521700201218     C**********         IF        MPHAS <> 'A'                                   MD021423E MD025467
521800201218     C                   IF        MPHAS =  'C'                                             MD025467
521900201218     C                   EVAL      CobMode = 'Y'                                           MD021423E
522000201218     C                   ENDIF                                                             MD021423E
522100201218      *                                                                                    MD021423E
522200201218      ** Check if CSC011 is installed                                                        BUG3760
522300201218      *                                                                                      BUG3760
522400201218     C                   CALLB     'AOSARDR0'                                                BUG3760
522500201218     C                   PARM      *BLANKS       PRetCode                                    BUG3760
522600201218     C                   PARM      '*VERIFY'     POption                                     BUG3760
522700201218     C                   PARM      'CSC011'      PSard                                       BUG3760
522800201218     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3760
522900201218      *                                                                                      BUG3760
523000201218      ** Database error                                                                      BUG3760
523100201218      *                                                                                      BUG3760
523200201218     C                   IF        (PRetCode <> '*NRF') and                                  BUG3760
523300201218     C                             (PRetCode <> *Blanks)                                     BUG3760
523400201218     C     *LOCK         IN        LDA                                                       BUG3760
523500201218     C                   EVAL      DBKEY = 'CSC011'                                          BUG3760
523600201218     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG3760
523700201218     C                   EVAL      DBASE = 904                                               BUG3760
523800201218     C                   OUT       LDA                                                       BUG3760
523900201218     C                   EXSR      *PSSR                                                     BUG3760
524000201218     C                   ENDIF                                                               BUG3760
524100201218      *                                                                                      BUG3760
524200201218     C                   IF        PRetCode = *Blanks                                        BUG3760
524300201218     C                   EVAL      CSC011 = 'Y'                                              BUG3760
524400201218     C                   IN        SC24X7                                                    BUG3760
524500201218     C                   ELSE                                                                BUG3760
524600201218     C                   EVAL      CSC011 = 'N'                                              BUG3760
524700201218     C                   ENDIF                                                               BUG3760
524800201218     C/COPY WNCPYSRC,LEH01193
524900201218      *                                                                                      BUG3760
525000201218     C                   IN        SDSTAT                                                    BUG3760
525100201218      *                                                                                      BUG3760
525200201218      ** Check if Compliance Watch Enhancement - Watch List Checking                         BUG3760
525300201218      ** (CSD015) is on.                                                                     BUG3760
525400201218      *                                                                                      BUG3760
525500201218     C                   EVAL      CSD015 = 'N'                                              BUG3760
525600201218      *                                                                                      BUG3760
525700201218     C                   CALLB     'AOSARDR0'                                                BUG3760
525800201218     C                   PARM      *BLANKS       PRetCode                                    BUG3760
525900201218     C                   PARM      '*VERIFY'     POption                                     BUG3760
526000201218     C                   PARM      'CSD015'      PSard                                       BUG3760
526100201218     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3760
526200201218      *                                                                                      BUG3760
526300201218      ** Database error                                                                      BUG3760
526400201218      *                                                                                      BUG3760
526500201218     C                   IF        (PRetCode <> *BLANKS) AND                                 BUG3760
526600201218     C                             (PRetCode <> '*NRF   ')                                   BUG3760
526700201218     C     *LOCK         IN        LDA                                                       BUG3760
526800201218     C                   EVAL      DBKEY = 'CSD015'                                          BUG3760
526900201218     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG3760
527000201218     C                   EVAL      DBASE = 907                                               BUG3760
527100201218     C                   OUT       LDA                                                       BUG3760
527200201218     C                   EXSR      *PSSR                                                     BUG3760
527300201218     C                   ENDIF                                                               BUG3760
527400201218      *                                                                                      BUG3760
527500201218     C                   IF        PRetCode = *BLANKS                                        BUG3760
527600201218     C                   EVAL      CSD015 = 'Y'                                              BUG3760
527700201218     C                   ENDIF                                                               BUG3760
527800201218      *                                                                                      BUG3760
527900201218      ** Check if Concord Interface Development(CCF001) is installed.                        BUG3760
528000201218      *                                                                                      BUG3760
528100201218     C                   EVAL      CCF001 = 'N'                                              BUG3760
528200201218      *                                                                                      BUG3760
528300201218     C                   CALLB     'AOSARDR0'                                                BUG3760
528400201218     C                   PARM      *BLANKS       PRetCode                                    BUG3760
528500201218     C                   PARM      '*VERIFY'     POption                                     BUG3760
528600201218     C                   PARM      'CCF001'      PSard                                       BUG3760
528700201218     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3760
528800201218      *                                                                                      BUG3760
528900201218      ** Database error                                                                      BUG3760
529000201218      *                                                                                      BUG3760
529100201218     C                   IF        (PRetCode <> *BLANKS) AND                                 BUG3760
529200201218     C                             (PRetCode <> '*NRF   ')                                   BUG3760
529300201218     C     *LOCK         IN        LDA                                                       BUG3760
529400201218     C                   EVAL      DBKEY = 'CCF001'                                          BUG3760
529500201218     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG3760
529600201218     C                   EVAL      DBASE = 910                                               BUG3760
529700201218     C                   OUT       LDA                                                       BUG3760
529800201218     C                   EXSR      *PSSR                                                     BUG3760
529900201218     C                   ENDIF                                                               BUG3760
530000201218      *                                                                                      BUG3760
530100201218     C                   IF        PRetCode = *BLANKS                                        BUG3760
530200201218     C                   EVAL      CCF001 = 'Y'                                              BUG3760
530300201218     C                   ENDIF                                                               BUG3760
530400201218      *                                                                                      BUG3760
530500201218     C                   IF        CSD015 = 'Y'                                              BUG3760
530600201218      *                                                                                      BUG3760
530700201218      **  Access Compliance Watch Configuration file.                                        BUG3760
530800201218      *                                                                                      BUG3760
530900201218     C                   CALLB     'AOCWCDR0'                                                BUG3760
531000201218     C                   PARM      *BLANKS       PRetCode                                    BUG3760
531100201218     C                   PARM      '*FIRST'      POption                                     BUG3760
531200201218     C     SDCWCD        PARM      SDCWCD        DSFDY                                       BUG3760
531300201218      *                                                                                      BUG3760
531400201218      ** Database Error                                                                      BUG3760
531500201218      *                                                                                      BUG3760
531600201218     C                   IF        PRetCode <> *BLANKS                                       BUG3760
531700201218     C     *LOCK         IN        LDA                                                       BUG3760
531800201218     C                   EVAL      DBKEY = POption                                           BUG3760
531900201218     C                   EVAL      DBFILE = 'SDCWCDPD'                                       BUG3760
532000201218     C                   EVAL      DBASE = 909                                               BUG3760
532100201218     C                   OUT       LDA                                                       BUG3760
532200201218     C                   EXSR      *PSSR                                                     BUG3760
532300201218     C                   ENDIF                                                               BUG3760
532400201218      *                                                                                      BUG3760
532500201218      **  Check if function code is being monitored by compliance watch.                     BUG3760
532600201218      *                                                                                      BUG3760
532700201218     C                   CALLB     'AOWLCCR0'                                                BUG3760
532800201218     C                   PARM      *BLANKS       PRetCode                                    BUG3760
532900201218     C                   PARM      '*KEY    '    POption                                     BUG3760
533000201218     C                   PARM      'LENDING '    PFunc                                       BUG3760
533100201218     C     SDWLCC        PARM      SDWLCC        DSFDY                                       BUG3760
533200201218      *                                                                                      BUG3760
533300201218      ** Database Error                                                                      BUG3760
533400201218      *                                                                                      BUG3760
533500201218     C                   IF        PRetCode <> *BLANKS                                       BUG3760
533600201218     C                             AND PRetCode <> '*NRF'                                    BUG3760
533700201218     C     *LOCK         IN        LDA                                                       BUG3760
533800201218     C                   EVAL      DBKEY = PFunc                                             BUG3760
533900201218     C                   EVAL      DBFILE = 'SDWLCCPD'                                       BUG3760
534000201218     C                   EVAL      DBASE = 908                                               BUG3760
534100201218     C                   OUT       LDA                                                       BUG3760
534200201218     C                   EXSR      *PSSR                                                     BUG3760
534300201218     C                   ENDIF                                                               BUG3760
534400201218      *                                                                                      BUG3760
534500201218     C                   ENDIF                                                               BUG3760
534600201218      *
534700201218      ** Retrieve local currency details
534800201218     C                   CALLB     'AOCURRR0'
534900201218     C                   PARM      '*BLANK  '    @RtCd
535000201218     C                   PARM      '*KEY    '    @Optn
535100201218     C                   PARM      BJLCCY        @Curr             3
535200201218     C     SDCURR        PARM                    DSSDY
535300201218      *
535400201218     C     @RtCd         IFNE      *BLANKS
535500201218     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
535600201218     C                   Z-ADD     2             DBASE                          * DBERR 02 *
535700201218     C                   MOVEL     BJLCCY        DBKEY                          ************
535800201218     C                   EXSR      *PSSR
535900201218     C                   ENDIF
536000201218                                                                                              CLE025
536100201218      ** Determine if CLE025 is switched on                                                   CLE025
536200201218                                                                                              CLE025
536300201218     C                   MOVE      'N'           CLE025                                       CLE025
536400201218     C                   CALLB     'AOSARDR0'                                                 CLE025
536500201218     C                   PARM      *BLANKS       PRTCD                                        CLE025
536600201218     C                   PARM      '*VERIFY'     POPTN                                        CLE025
536700201218     C                   PARM      'CLE025'      PSARD                                        CLE025
536800201218                                                                                              CLE025
536900201218     C                   IF        PRTCD <> *BLANKS and                                       CLE025
537000201218     C                             PRTCD <> '*NRF   '                                         CLE025
537100201218     C                   MOVEL     PSARD         DBKEY                                        CLE025
537200201218     C                   MOVEL     'SCSARDPD'    DBFILE                                       CLE025
537300201218     C                   Z-ADD     32            DBASE                                        CLE025
537400201218     C                   EXSR      *PSSR                                                      CLE025
537500201218     C                   ENDIF                                                                CLE025
537600201218                                                                                              CLE025
537700201218     C                   IF        PRTCD = *BLANKS                                            CLE025
537800201218     C                   MOVE      'Y'           CLE025                                       CLE025
537900201218     C                   ENDIF                                                                CLE025
538000201218      *
538100201218     C                   Z-ADD     A6TXND        TNOTL             1 0
538200201218      *
538300201218      ** If CLE009 is installed, fill currency and their corresponding
538400201218      ** telex notice days arrays
538500201218     C     CLE009        IFEQ      'Y'
538600201218     C                   Z-ADD     0             X                 3 0
538700201218      *
538800201218     C                   CALLB     'AOCURRR0'
538900201218     C                   PARM      *BLANKS       @RtCd
539000201218     C                   PARM      '*FIRST '     @Optn
539100201218     C                   PARM                    @Curr             3
539200201218     C     SDCURR        PARM      SDCURR        DSSDY
539300201218      *
539400201218     C     @RtCd         DOWNE     '*EOF    '
539500201218     C                   ADD       1             X
539600201218     C                   MOVE      A6CYCD        CYA(X)
539700201218     C                   MOVE      A6TXND        TND(X)
539800201218      *
539900201218     C                   CALLB     'AOCURRR0'
540000201218     C                   PARM      *BLANKS       @RtCd
540100201218     C                   PARM      '*NEXT  '     @Optn
540200201218     C                   PARM                    @Curr             3
540300201218     C     SDCURR        PARM      SDCURR        DSSDY
540400201218      *
540500201218     C                   ENDDO
540600201218      *
540700201218     C                   ENDIF
540800201218
540900201218     C                   EVAL      @RTCD = *BLANKS
541000201218
541100201218      ** Check if CRE020 is enabled.                                                          CRE020
541200201218                                                                                              CRE020
541300201218     C                   CALLB     'AOSARDR0'                                                 CRE020
541400201218     C                   PARM      *BLANKS       PRtCd                                        CRE020
541500201218     C                   PARM      '*VERIFY'     POptn                                        CRE020
541600201218     C                   PARM      'CRE020'      PSARD                                        CRE020
541700201218     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE020
541800201218                                                                                              CRE020
541900201218     C                   EVAL      CRE020 = 'N'                                               CRE020
542000201218                                                                                              CRE020
542100201218     C                   IF        PRtCd = *BLANKS                                            CRE020
542200201218     C                   EVAL      CRE020 = 'Y'                                               CRE020
542300201218     C                   ELSE                                                                 CRE020
542400201218                                                                                              CRE020
542500201218     C                   IF        PRtCd <> '*NRF'                                            CRE020
542600201218     C     *LOCK         IN        LDA                                                        CRE020
542700201218     C                   EVAL      DBFile = 'SCSARDPD'                                        CRE020
542800201218     C                   EVAL      DBase = 101                                                CRE020
542900201218     C                   EVAL      DBKey = 'CRE020'                                           CRE020
543000201218     C                   OUT       LDA                                                        CRE020
543100201218     C                   EXSR      *PSSR                                                      CRE020
543200201218     C                   ENDIF                                                                CRE020
543300201218                                                                                              CRE020
543400201218     C                   ENDIF                                                                CRE020
543500201218                                                                                              CRE020
543600201218     C                   IF        CRE020 = 'Y'                                               CRE020
543700201218                                                                                              CRE020
543800201218     C                   CALLB     'AOSVALR0'                                                 CRE020
543900201218     C                   PARM      *BLANKS       PRtCd                                        CRE020
544000201218     C                   PARM                    PSysVal01                                    CRE020
544100201218     C                   PARM                    PCurSet01                                    CRE020
544200201218     C                   PARM                    PSysVal02                                    CRE020
544300201218     C                   PARM                    PCurSet02                                    CRE020
544400201218     C                   PARM                    PSysVal03                                    CRE020
544500201218     C                   PARM                    PCurSet03                                    CRE020
544600201218     C                   PARM                    PSysVal04                                    CRE020
544700201218     C                   PARM                    PCurSet04                                    CRE020
544800201218     C                   PARM                    PSysVal05                                    CRE020
544900201218     C                   PARM                    PCurSet05                                    CRE020
545000201218     C                   PARM                    PSysVal06                                    CRE020
545100201218     C                   PARM                    PCurSet06                                    CRE020
545200201218     C                   PARM                    PSysVal07                                    CRE020
545300201218     C                   PARM                    PCurSet07                                    CRE020
545400201218     C                   PARM                    PSysVal08                                    CRE020
545500201218     C                   PARM                    PCurSet08                                    CRE020
545600201218     C                   PARM                    PSysVal09                                    CRE020
545700201218     C                   PARM                    PCurSet09                                    CRE020
545800201218     C                   PARM                    PSysVal10                                    CRE020
545900201218     C                   PARM                    PCurSet10                                    CRE020
546000201218                                                                                              CRE020
546100201218     C                   IF        PRtCd = *BLANKS                                            CRE020
546200201218     C                   MOVEL     PCurSet01     WPrtAdv                                      CRE020
546300201218     C                   ELSE                                                                 CRE020
546400201218                                                                                              CRE020
546500201218     C                   IF        PRtCd <> '*NRF'                                            CRE020
546600201218     C     *LOCK         IN        LDA                                                        CRE020
546700201218     C                   EVAL      DBFile = 'SDSVALPD'                                        CRE020
546800201218     C                   EVAL      DBase = 101                                                CRE020
546900201218     C                   EVAL      DBKey = PSysVal01                                          CRE020
547000201218     C                   OUT       LDA                                                        CRE020
547100201218     C                   EXSR      *PSSR                                                      CRE020
547200201218     C                   ENDIF                                                                CRE020
547300201218                                                                                              CRE020
547400201218     C                   ENDIF                                                                CRE020
547500201218                                                                                              CRE020
547600201218     C                   ENDIF                                                                CRE020
547700201218                                                                                              CLE031
547800201218      ** Check if CLE031 is enabled.                                                          CLE031
547900201218                                                                                              CLE031
548000201218     C                   CALLB     'AOSARDR0'                                                 CLE031
548100201218     C                   PARM      *BLANKS       PRtCd                                        CLE031
548200201218     C                   PARM      '*VERIFY'     POptn                                        CLE031
548300201218     C                   PARM      'CLE031'      PSARD                                        CLE031
548400201218     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE031
548500201218                                                                                              CLE031
548600201218     C                   EVAL      CLE031 = 'N'                                               CLE031
548700201218                                                                                              CLE031
548800201218     C                   IF        PRtCd = *BLANKS                                            CLE031
548900201218     C                   EVAL      CLE031 = 'Y'                                               CLE031
549000201218     C                   ELSE                                                                 CLE031
549100201218                                                                                              CLE031
549200201218     C                   IF        PRtCd <> '*NRF'                                            CLE031
549300201218     C     *LOCK         IN        LDA                                                        CLE031
549400201218     C                   EVAL      DBFile = 'SCSARDPD'                                        CLE031
549500201218     C                   EVAL      DBase = 102                                                CLE031
549600201218     C                   EVAL      DBKey = 'CLE031'                                           CLE031
549700201218     C                   OUT       LDA                                                        CLE031
549800201218     C                   EXSR      *PSSR                                                      CLE031
549900201218     C                   ENDIF                                                                CLE031
550000201218                                                                                              CLE031
550100201218     C                   ENDIF                                                                CLE031
550200201218                                                                                             BUG8241
550300201218      ***Check*if*enhancement*CSC024*(Open*Month*End)*is*on                           BUG8241 CSC054
550400201218      ** Check if enhancement CSC024 (Period End Adjustments) is on                           CSC054
550500201218                                                                                             BUG8241
550600201218     C                   CALLB     'AOSARDR0'                                                BUG8241
550700201218     C                   PARM      *BLANKS       PRtCd                                       BUG8241
550800201218     C                   PARM      '*VERIFY'     POptn                                       BUG8241
550900201218     C**********         PARM      'CSC024'      PSARD                                BUG8241 CSC054
551000201218     C                   PARM      'CSC054'      PSARD                                        CSC054
551100201218     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG8241
551200201218                                                                                             BUG8241
551300201218     C                   IF        PRtCd  <> *BLANKS AND                                     BUG8241
551400201218     C                             PRtCd  <> '*NRF   '                                       BUG8241
551500201218     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG8241
551600201218     C**********         EVAL      DBKey  = 'CSC024'                                  BUG8241 CSC054
551700201218     C                   EVAL      DBKey  = 'CSC054'                                          CSC054
551800201218     C                   EVAL      DBase  = 1                                                BUG8241
551900201218     C                   EXSR      *PSSR                                                     BUG8241
552000201218     C                   ENDIF                                                               BUG8241
552100201218                                                                                             BUG8241
552200201218     C**********         EVAL      CSC024 = 'N'                                       BUG8241 CSC054
552300201218     C**********         EVAL      WOMEInd = 'N'                                      BUG8241 CSC054
552400201218     C                   EVAL      CSC054 = 'N'                                               CSC054
552500201218     C                   EVAL      WPEAInd = 'N'                                              CSC054
552600201218                                                                                             BUG8241
552700201218     C                   IF        PRtCd = *BLANKS                                           BUG8241
552800201218     C**********         EVAL      CSC024 = 'Y'                                       BUG8241 CSC054
552900201218     C                   EVAL      CSC054 = 'Y'                                               CSC054
553000201218                                                                                             BUG8241
553100201218      ** Access System values                                                                BUG8241
553200201218                                                                                             BUG8241
553300201218     C                   CALL      'AOSVALR0'                                                BUG8241
553400201218     C                   PARM      *BLANKS       PRetCode                                    BUG8241
553500201218     C**********         PARM      PSysValOME    PSysVal01                            BUG8241 CSC054
553600201218     C                   PARM      PSysValPEA    PSysVal01                                    CSC054
553700201218     C                   PARM      *BLANKS       PCurSet01                                   BUG8241
553800201218     C                   PARM      *BLANKS       PSysVal02                                   BUG8241
553900201218     C                   PARM      *BLANKS       PCurSet02                                   BUG8241
554000201218     C                   PARM      *BLANKS       PSysVal03                                   BUG8241
554100201218     C                   PARM      *BLANKS       PCurSet03                                   BUG8241
554200201218     C                   PARM      *BLANKS       PSysVal04                                   BUG8241
554300201218     C                   PARM      *BLANKS       PCurSet04                                   BUG8241
554400201218     C                   PARM      *BLANKS       PSysVal05                                   BUG8241
554500201218     C                   PARM      *BLANKS       PCurSet05                                   BUG8241
554600201218     C                   PARM      *BLANKS       PSysVal06                                   BUG8241
554700201218     C                   PARM      *BLANKS       PCurSet06                                   BUG8241
554800201218     C                   PARM      *BLANKS       PSysVal07                                   BUG8241
554900201218     C                   PARM      *BLANKS       PCurSet07                                   BUG8241
555000201218     C                   PARM      *BLANKS       PSysVal08                                   BUG8241
555100201218     C                   PARM      *BLANKS       PCurSet08                                   BUG8241
555200201218     C                   PARM      *BLANKS       PSysVal09                                   BUG8241
555300201218     C                   PARM      *BLANKS       PCurSet09                                   BUG8241
555400201218     C                   PARM      *BLANKS       PSysVal10                                   BUG8241
555500201218     C                   PARM      *BLANKS       PCurSet10                                   BUG8241
555600201218                                                                                             BUG8241
555700201218     C                   IF        PRetCode  <> *BLANKS                                      BUG8241
555800201218     C                   EVAL      DBFile = 'SDSVALPD'                                       BUG8241
555900201218     C                   EVAL      DBKEy = '*KEY   '                                         BUG8241
556000201218     C                   EVAL      DBase = 2                                                 BUG8241
556100201218     C                   EXSR      *PSSR                                                     BUG8241
556200201218     C                   ENDIF                                                               BUG8241
556300201218                                                                                             BUG8241
556400201218     C                   IF        PCurSet01 = 'Y'                                           BUG8241
556500201218     C*********          EVAL      WOMEInd = 'Y'                                      BUG8241 CSC054
556600201218     C                   EVAL      WPEAInd = 'Y'                                              CSC054
556700201218     C                   ENDIF                                                               BUG8241
556800201218     C                   ENDIF                                                               BUG8241
556900201218                                                                                              CAS011
557000201218      ** Determine if SAR CAS009 is installed                                                 CAS011
557100201218                                                                                              CAS011
557200201218     C                   CALL      'AOSARDR0'                                                 CAS011
557300201218     C                   PARM      *BLANKS       PRTCD                                        CAS011
557400201218     C                   PARM      '*VERIFY '    POPTN                                        CAS011
557500201218     C                   PARM      'CAS009'      PSARD                                        CAS011
557600201218     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS011
557700201218                                                                                              CAS011
557800201218     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CAS011
557900201218     C     *LOCK         IN        LDA                                                        CAS011
558000201218     C                   EVAL      DBFile = 'SCSARDPD'                                        CAS011
558100201218     C                   EVAL      DBase = 102                                                CAS011
558200201218     C                   EVAL      DBKey = 'CAS009'                                           CAS011
558300201218     C                   OUT       LDA                                                        CAS011
558400201218     C                   EXSR      *PSSR                                                      CAS011
558500201218     C                   ENDIF                                                                CAS011
558600201218                                                                                              CAS011
558700201218     C                   IF        PRTCD = *BLANKS                                            CAS011
558800201218     C                   EVAL      CAS009 = 'Y'                                               CAS011
558900201218     C                   ELSE                                                                 CAS011
559000201218     C                   EVAL      CAS009 = 'N'                                               CAS011
559100201218     C                   ENDIF                                                                CAS011
559200201218                                                                                              CAS011
559300201218      ** Access object for Hedge ICD                                                          CAS011
559400201218                                                                                              CAS011
559500201218     C                   IF        CAS009 = 'Y'                                               CAS011
559600201218     C                   CALL      'AOHEDGR0'                                                 CAS011
559700201218     C                   PARM      *BLANKS       PRTCD                                        CAS011
559800201218     C                   PARM      '*VERIFY '    POPTN                                        CAS011
559900201218     C     SDHEDG        PARM      SDHEDG        DSFDY                                        CAS011
560000201218                                                                                              CAS011
560100201218     C                   IF        PRTCD <> *BLANKS                                           CAS011
560200201218     C     *LOCK         IN        LDA                                                        CAS011
560300201218     C                   EVAL      DBFile = 'SDHEDGPD'                                        CAS011
560400201218     C                   EVAL      DBase = 103                                                CAS011
560500201218     C                   EVAL      DBKey = POPTN                                              CAS011
560600201218     C                   OUT       LDA                                                        CAS011
560700201218     C                   EXSR      *PSSR                                                      CAS011
560800201218     C                   ENDIF                                                                CAS011
560900201218     C                   ENDIF                                                                CAS011
561000201218      ** Determine if SAR CAS016 is installed                                                 CAS019
561100201218                                                                                              CAS019
561200201218     C                   CALL      'AOSARDR0'                                                 CAS019
561300201218     C                   PARM      *BLANKS       PRTCD                                        CAS019
561400201218     C                   PARM      '*VERIFY '    POPTN                                        CAS019
561500201218     C                   PARM      'CAS016'      PSARD                                        CAS019
561600201218     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS019
561700201218                                                                                              CAS019
561800201218     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CAS019
561900201218     C     *LOCK         IN        LDA                                                        CAS019
562000201218     C                   EVAL      DBFile = 'SCSARDPD'                                        CAS019
562100201218     C                   EVAL      DBase = 104                                                CAS019
562200201218     C                   EVAL      DBKey = 'CAS016'                                           CAS019
562300201218     C                   OUT       LDA                                                        CAS019
562400201218     C                   EXSR      *PSSR                                                      CAS019
562500201218     C                   ENDIF                                                                CAS019
562600201218                                                                                              CAS019
562700201218     C                   IF        PRTCD = *BLANKS                                            CAS019
562800201218     C                   EVAL      CAS016 = 'Y'                                               CAS019
562900201218     C                   ELSE                                                                 CAS019
563000201218     C                   EVAL      CAS016 = 'N'                                               CAS019
563100201218     C                   ENDIF                                                                CAS019
563200201218                                                                                              CAS019
563300201218      ** Check if CLE073 - Calculation of loan based fees is installed                        CLE073
563400201218                                                                                              CLE073
563500201218     C                   CALL      'AOSARDR0'                                                 CLE073
563600201218     C                   PARM      *BLANKS       @RTCD                                        CLE073
563700201218     C                   PARM      '*KEY    '    @OPTN                                        CLE073
563800201218     C                   PARM      'CLE073'      @SARD             6                          CLE073
563900201218     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE073
564000201218                                                                                              CLE073
564100201218     C     @RTCD         IFEQ      *BLANKS                                                    CLE073
564200201218     C                   MOVEL     'Y'           CLE073                                       CLE073
564300201218     C                   ELSE                                                                 CLE073
564400201218     C                   MOVEL     'N'           CLE073            1                          CLE073
564500201218     C                   ENDIF                                                                CLE073
564600201218                                                                                              CLE073
564700201218                                                                                              CLE134
564800201218      ** Check if CLE134 is ON                                                                CLE134
564900201218                                                                                              CLE134
565000201218     C                   MOVE      'N'           CLE134            1                          CLE134
565100201218     C                   CALLB     'AOSARDR0'                                                 CLE134
565200201218     C                   PARM      *BLANKS       PRtCd                                        CLE134
565300201218     C                   PARM      '*VERIFY'     POptn                                        CLE134
565400201218     C                   PARM      'CLE134'      PSARD                                        CLE134
565500201218     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE134
565600201218                                                                                              CLE134
565700201218     C                   IF        PRtCd = *BLANKS                                            CLE134
565800201218     C                   EVAL      CLE134 = 'Y'                                               CLE134
565900201218      *                                                                                     MD050018
566000201218      ** Access system values to check PDCL Projected acct movements on ic                  MD050018
566100201218     C                   CALL      'AOSVALR0'                                               MD050018
566200201218     C                   PARM      *BLANKS       PRetCode                                   MD050018
566300201218     C                   PARM      PSysValPIAC   PSysVal01                                  MD050018
566400201218     C                   PARM      *BLANKS       PCurSet01                                  MD050018
566500201218     C                   PARM      *BLANKS       PSysVal02                                  MD050018
566600201218     C                   PARM      *BLANKS       PCurSet02                                  MD050018
566700201218     C                   PARM      *BLANKS       PSysVal03                                  MD050018
566800201218     C                   PARM      *BLANKS       PCurSet03                                  MD050018
566900201218     C                   PARM      *BLANKS       PSysVal04                                  MD050018
567000201218     C                   PARM      *BLANKS       PCurSet04                                  MD050018
567100201218     C                   PARM      *BLANKS       PSysVal05                                  MD050018
567200201218     C                   PARM      *BLANKS       PCurSet05                                  MD050018
567300201218     C                   PARM      *BLANKS       PSysVal06                                  MD050018
567400201218     C                   PARM      *BLANKS       PCurSet06                                  MD050018
567500201218     C                   PARM      *BLANKS       PSysVal07                                  MD050018
567600201218     C                   PARM      *BLANKS       PCurSet07                                  MD050018
567700201218     C                   PARM      *BLANKS       PSysVal08                                  MD050018
567800201218     C                   PARM      *BLANKS       PCurSet08                                  MD050018
567900201218     C                   PARM      *BLANKS       PSysVal09                                  MD050018
568000201218     C                   PARM      *BLANKS       PCurSet09                                  MD050018
568100201218     C                   PARM      *BLANKS       PSysVal10                                  MD050018
568200201218     C                   PARM      *BLANKS       PCurSet10                                  MD050018
568300201218                                                                                            MD050018
568400201218     C                   IF        PRetCode  <> *BLANKS                                     MD050018
568500201218     C                   EVAL      DBFile = 'SDSVALPD'                                      MD050018
568600201218     C                   EVAL      DBKEy = '*KEY   '                                        MD050018
568700201218     C                   EVAL      DBase = 40                                               MD050018
568800201218     C                   EXSR      *PSSR                                                    MD050018
568900201218     C                   ELSE                                                               MD050018
569000201218     C                   EVAL      WKPIAC = PCurSet01                                       MD050018
569100201218     C                   ENDIF                                                              MD050018
569200201218      *                                                                                     MD050018
569300201218     C                   ENDIF                                                                CLE134
569400201218                                                                                              CLE134
569500201218      *
569600201218      ** Determine if CAR CLE055 is installed>                                                CLE055
569700201218      ** Do this is if authorisation is required to be performed.                             CLE055
569800201218      *                                                                                       CLE055
569900201218     C********           IF        CLE002 = 'Y'                                        CLE055 243415
570000201218     C                                                                                        CLE055
570100201218     C                   CALL      'AOSARDR0'                                                 CLE055
570200201218     C                   PARM      *BLANKS       PRetCode                                     CLE055
570300201218     C                   PARM      '*VERIFY'     POption                                      CLE055
570400201218     C                   PARM      'CLE055'      PSARD                                        CLE055
570500201218     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE055
570600201218      *                                                                                       CLE055
570700201218     C                   IF        PRetCode <> *BLANKS  and                                   CLE055
570800201218     C                             PRetCode <> '*NRF   '                                      CLE055
570900201218      *                                                                                       CLE055
571000201218     C     *LOCK         IN        LDA                                                        CLE055
571100201218     C                   EVAL      DBFile = 'SCSARDPD'                                        CLE055
571200201218     C                   EVAL      DBase = 69                                                 CLE055
571300201218     C                   EVAL      DBKey = 'CLE055'                                           CLE055
571400201218     C                   OUT       LDA                                                        CLE055
571500201218     C                   EXSR      *PSSR                                                      CLE055
571600201218     C                   ENDIF                                                                CLE055
571700201218      *                                                                                       CLE055
571800201218     C                   IF        PRetCode = *BLANKS                                         CLE055
571900201218     C                   EVAL      CLE055 = 'Y'                                               CLE055
572000201218     C                   ELSE                                                                 CLE055
572100201218     C                   EVAL      CLE055 = 'N'                                               CLE055
572200201218     C                   ENDIF                                                                CLE055
572300201218      *                                                                                       CLE055
572400201218     C********           ENDIF                                                         CLE055 243415
572500201218      *                                                                                       CLE055
572600201218      ** Check if Watch List Element (CSD083) is on                                           CSD083
572700201218      *                                                                                       CSD083
572800201218     C                   CALL      'AOSARDR0'                                                 CSD083
572900201218     C                   PARM      *BLANKS       PRetCode                                     CSD083
573000201218     C                   PARM      '*VERIFY'     POption                                      CSD083
573100201218     C                   PARM      'CSD083'      PSARD                                        CSD083
573200201218     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
573300201218                                                                                              CSD083
573400201218     C                   IF        PRetCode <> *BLANKS  and                                   CSD083
573500201218     C                             PRetCode <> '*NRF   '                                      CSD083
573600201218     C     *LOCK         IN        LDA                                                        CSD083
573700201218     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
573800201218     C                   EVAL      DBase = 70                                                 CSD083
573900201218     C                   EVAL      DBKey = 'CSD083'                                           CSD083
574000201218     C                   OUT       LDA                                                        CSD083
574100201218     C                   EXSR      *PSSR                                                      CSD083
574200201218     C                   ENDIF                                                                CSD083
574300201218                                                                                              CSD083
574400201218     C                   IF        PRetCode = *BLANKS                                         CSD083
574500201218     C                   EVAL      CSD015 = 'N'                                               CSD083
574600201218     C                   ENDIF                                                                CSD083
574700201218      *                                                                                     MD024342
574800201218     C                   MOVEL     'N'           MTHREAD           1                        MD024342
574900201218     C**********         MOVE      'LOAM'        WAPIC                             MD024342 MD025467
575000201218     C**********         MOVEL     'LOAMSZ1'     WFILN                             MD024342 MD025467
575100201218     C**********         IF        MPHAS = 'A' AND                                 MD024342 MD025467
575200201218     C                   IF        MPHAS <> 'C' AND                                         MD025467
575300201218     C                             W#FRNT <> 'LE000473'                                     MD024342
575400201218     C                   MOVEL     'Y'           MTHREAD                                    MD025467
575500201218     C*****KAPILST       CHAIN     SDAPDRL0                           99           MD024342 MD025467
575600201218     C******IN99         IFEQ      '0'                                             MD024342 MD025467
575700201218     C**********         MOVEL     A8MULT        MTHREAD                           MD024342 MD025467
575800201218     C**********         ENDIF                                                     MD024342 MD025467
575900201218     C                   ENDIF                                                              MD024342
576000201218                                                                                              CSD083
576100201218     C                   ENDSR
576200201218      *****************************************************************                     MD024342
576300201218      * Initialise - Initialise trailer fields                        *                     MD024342
576400201218      *****************************************************************                     MD024342
576500201218     C     Initialise    BEGSR                                                              MD024342
576600201218      *                                                                                     MD024342
576700201218     C                   EVAL      NORE = 0                                                 MD024342
576800201218     C                   EVAL      NLRB = 0                                                 MD024342
576900201218     C                   EVAL      NINS = 0                                                 MD024342
577000201218     C                   EVAL      NDEL = 0                                                 MD024342
577100201218     C                   EVAL      NLRA = 0                                                 MD024342
577200201218     C                   EVAL      VLBF = 0                                                 MD024342
577300201218     C                   EVAL      VLBL = 0                                                 MD024342
577400201218     C                   EVAL      VRIF = 0                                                 MD024342
577500201218     C                   EVAL      VRIL = 0                                                 MD024342
577600201218     C                   EVAL      VRDF = 0                                                 MD024342
577700201218     C                   EVAL      VRDL = 0                                                 MD024342
577800201218     C                   EVAL      VRAF = 0                                                 MD024342
577900201218     C                   EVAL      VRAL = 0                                                 MD024342
578000201218     C                   EVAL      VRRF = 0                                                 MD024342
578100201218     C                   EVAL      VRRL = 0                                                 MD024342
578200201218      *                                                                                     MD024342
578300201218     C                   ENDSR                                                              MD024342
578400201218      ****************************************************************
578500201218      /EJECT
578600201218      *****************************************************************
578700201218      ** Program, module and procedure names for database error processing.
578800201218      ** =================================================================
578900201218      ** The following /COPY sets these values, and also defines LDA as
579000201218      ** an external data area
579100201218      ********************************************************************
579200201218     C/COPY ZACPYSRC,PSSR_ILE
579300201218      ********************************************************************
579400201218      /EJECT
579500201218      ********************************************************************
579600201218
579700201218      ** Output LTRIX header record
579800201218     O*LTRIX**** E            LTRIXH                                                        AR322732
579900201218     O**********             NORE                11P                                        Bug03936
580000201218     O**********             NORELX              11P                               Bug03936 AR322732
580100201218     O**********             RRNA                20P                                        AR322732
580200201218     O**********             NLAR                32P                                        AR322732
580300201218     O**********             LATNLU              40P                                        AR322732
580400201218      *
580500201218      ** Output LTRIX detail record
580600201218     O**********E            LTRIXD                                                         AR322732
580700201218     OLTRIX     EADD         LTRIXD                                                         AR322732
580800201218     O                                            2 'DA'
580900201218     O                       LALNRF               8
581000201218     O                       LAVDAT              13
581100201218     O                       LALASN              16
581200201218     O                       CHTP                17
581300201218     O**********                                 18 'N'                                     BUG23026
581400201218     O**********                                 18 'Y'                            BUG23026 AR876299
581500201218     O                                           18 'N'                                     AR876299
581600201218     O                                           19 'N'
581700201218     O                                           25 '00001'
581800201218     O                                           26 'N'
581900201218     O                       PRI1                27
582000201218     O                       LABRCA              34
582100201218     O                       RRNA                37P
582200201218     O                       LATNLU              40P
582300201218     O                                           43 '000'                                   AR322732
582400201218     O                                           44 ' '                                     AR322732
582500201218     O                                           45 ' '                                     AR322732
582600201218      ********************************************************************
582700201218      /EJECT
582800201218      ********************************************************************
582900201218**CTDATA CPY@
583000201218(c) Finastra International Limited 2002
583100201218**CTDATA CWA - Array for watch list fields                                                   BUG3760
583200201218<Receipt Nostro>                                                                             BUG3760
583300201218</Receipt Nostro>                                                                            BUG3760
583400201218<Receipt Intermed Bank>                                                                      BUG3760
583500201218</Receipt Intermed Bank>                                                                     BUG3760
583600201218<Receipt Ordering Bank>                                                                      BUG3760
583700201218</Receipt Ordering Bank>                                                                     BUG3760
583800201218<Receipt Ordering Cust>                                                                      BUG3760
583900201218</Receipt Ordering Cust>                                                                     BUG3760
584000201218<Payment Nostro>                                                                             BUG3760
584100201218</Payment Nostro>                                                                            BUG3760
584200201218<Payment Intermed Bank>                                                                      BUG3760
584300201218</Payment Intermed Bank>                                                                     BUG3760
584400201218<Payment Ordering Bank>                                                                      BUG3760
584500201218</Payment Ordering Bank>                                                                     BUG3760
584600201218<Payment Ordering Cust>                                                                      BUG3760
584700201218</Payment Ordering Cust>                                                                     BUG3760
584800201218<Receiver Correspondent>                                                                     BUG3760
584900201218</Receiver Correspondent>                                                                    BUG3760
585000201218<Receiver>                                                                                   BUG3760
585100201218</Receiver>                                                                                  BUG3760
585200201218<Account With Bank>                                                                          BUG3760
585300201218</Account With Bank>                                                                         BUG3760
585400201218<Beneficiary>                                                                                BUG3760
585500201218</Beneficiary>                                                                               BUG3760
585600201218<Details Of Payment>                                                                         BUG3760
585700201218</Details Of Payment>                                                                        BUG3760
585800201218**CTDATA POWR
5859002012180000001
5860002012180000010
5861002012180000100
5862002012180001000
5863002012180010000
5864002012180100000
5865002012181000000
