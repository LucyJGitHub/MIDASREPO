     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBI *  OVRDBF FILE(LOAMD) TOFILE(LOAMS) SHARE(*NO)                  *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Loan amendments database update')             *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LELOAMUPD - Midas LE Loan Amendment - Database Update        *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD054317           Date 09Sep19               *      
      *                 CER050             Date 16Jun19               *
      *                 CSD102             Date 08Jan19               *
      *                 MD050018           Date 05Nov18               *
      *                 MD047554           Date 11Oct17               *
      *                 MD046248           Date 27Oct17               *
      *                 AR848765           Date 30Jun15               *
      *                 AR943686           Date 23Sep16               *
      *                 CLE141             Date 08Feb16               *
      *                 AR547813           Date 13Nov15               *
      *                 MD026167           Date 13May14               *
      *                 MD025467           Date 08May14               *
      *                 MD024342B          Date 08May14               *
      *                 MD024342           Date 08May14               *
      *                 MD023787           Date 29Apr14               *
      *                 MD023203           Date 24Apr14               *
      *                 MD022807I          Date 24Apr14               *
      *                 AR876299           Date 07Dec11               *
      *                 MD022860           Date 14Oct13               *
      *                 MD021423E          Date 12Sep13               *
      *                 MD021423           Date 21Aug13               *
      *                 AR868380           Date 19Jun13               *
      *                 MD020568           Date 25May13               *
      *                 MD020534           Date 23May13               *
      *                 MD020390           Date 14May13               *
      *                 AR1035362          Date 15Oct12               *
      *                 AR580546           Date 24Apr13               *
      *                 AR1077027A         Date 19Mar13               *
      *                 AR1085742          Date 06Jan13               *
      *                 AR1021983          Date 01Aug12               *
      *                 AR656363           Date 01Aug12               *
      *                 264065             Date 01Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 AR322732           Date 23Jul12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSC054             Date 23Feb12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CLE139             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CLE073             Date 13May08               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG23026           Date 24Mar09               *
      *                 BUG26668           Date 04Nov09               *
      *                 243415             Date 23Oct06               *
      *                 243270             Date 03Nov06               *
      *                 CLE055             Date 04Jul06               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CAS019             Date 20Apr07               *
      *                 243275             Date 30Mar07               *
      *                 BUG13325           Date 15Feb07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG10655R          Date 24Feb06               *
/*    *                 BUG10604           Date 23Feb06               *
/*    *                 CLE042             Date 06Sep05               *
/*    *                 BUG9225            Date 16Nov05               *
/*    *                 BUG8566            Date 02Sep05               *
/*    *                 BUG8366            Date 30Aug05               *
/*    *                 CLE106             Date 01Aug04               *
      *                 CLE036             Date 22Sep03               *
      *                 CLE034             Date 05May03               *
      *                 CLE031             Date 03Feb03               *
      *                 BUG8241            Date 23Aug05               *
      *                 CAS011             Date 16May05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4138            Date 02Sep04               *
      *                 BUG0393            Date 06Aug04               *
      *                 BUG3760            Date 30Jul04               *
      *                 BUG3054            Date 06Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CRE020             Date 20Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE034             Date 01Dec03               *
      *                 213280             Date 15Jan03               *
      *                 CAP084             Date 11Oct02               *
      *                 CLE030             Date 03Oct02               *
      *                 CLE023             Date 03Oct02               *
      *                 CAP075  *CREATE    Date 01Aug02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD054317 - PDCL X not generated for freq based repayment     *      
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD050018 - PDP Enhancement: Generate Projected Accnt Movment *
      *             for Input Cycle Principal Increase Events to PDCL *
      *  MD047554 - Create shadow postings of INTEREST and MATURITY   *
      *             with recalculated amount based on newly inserted, *
      *             amended, or reversed PI, BC, or SC.               *
      *           - All fields for loan reference should be alpha     *
      *             numeric.                                          *
      *  MD046248 - Finastra Rebranding                               *
      *  AR848765 - During amend of Principal Increase, value of OSAC *
      *             is not updated correctly, Instead of PONS/RONS,   *
      *             LAPONS/LARONS will be moved to field OSAC.        *
      *           - Applied for MD034480                              *
      *  AR943686 - CLE031: System generating wrong projected move-   *
      *             ment. Populate value of SCCY to convert amount    *
      *             to account currency.                              *
      *           - Applied for MD-40690                              *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           (Recompile)                                         *
      *  AR547813 - Base rate change not captured by loans thus affec-*
      *             ting interest calculation. BR events were not pro-*
      *             cessed during COB if CHIN = blank. Default CHIN to*
      *             D or N when attaching loan to a Base Rate Code.   *
      *           - Applied for: MD-35600                             *
      *  MD026167 - COB: PDP should not update online positions but   *
      *             GLOLPSPD is being updated by PDP transactions     *
      *             during COB                                        *
      *  MD025467 - API locking issues Redesign Approach              *
      *  MD024342B - API issue. Trailer file allocation problem.      *
      *  MD024342 - LOAMSZ1 allocation problem                        *
      *  MD023787 - Posting for PDCL's PI and MR.                     *
      *  MD023203 - Locking issues during PDCL creation               *
      *  MD022807I - Update of LEMQLGPD->LGSTAT to 'S' will now be    *
      *              done in Java layer                               *
      *  AR876299 - Reverse fix BUG23026 (Child:AR876300)             *
      *  MD022860 - Access and update the LELOMZPD on COB to prevent  *
      *             corruption on LOAMSZ1                             *
      *  MD021423E - Deal date should be the deal date of the OL      *
      *              Pay instruction should be defaulted from receipt *
      *              instruction of the OL                            *
      *  MD021423 - Abnormally long run of PDCL/MAPY processing       *
      *             components                                        *
      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
      *             calling program if file locking occurred on       *
      *             online position files. (Child: AR868381)          *
      *  MD020568 - Encountered FOOB in LEC06A 10008                  *
      *  MD020534 - System did not generate PDCL for the unpaid       *
      *             balance of interest after COB (Recompile)         *
      *  MD020390 - Update fields AUTO and MTPD correctly when        *
      *             generated from COB                                *
      *  AR1035362- Loan Events - PI no on-line mvmt generated.       *
      *             Generate shadow postings during Authorization.    *
      *             (Child: AR1035364)                                *
      *  AR580546 - FOOB occured on LE0370 after the amount of a PI   *
      *             was amended. Correct the trailer update for PI    *
      *             amendment. (Child: AR934535)                      *
      *  AR1077027A - Encountered FOOB in LEC06A seq 01001 (Reopen)   *
      *  AR1085742 - Recovery handling when PDP components loop due   *
      *              to database connection issues                    *
      *  AR1021983 - [PDP] Option C - Technical Enhancements Stated   *
      *              in POC                                           *
      *  AR656363 - Do not update exposure when facility utilisation  *
      *             is 'N'. (Child: AR656364)                         *
      *  264065 - No adjustment on projections when amendments were   *
      *           inserted against the loan. Call LE2041 to reverse   *
      *           previous movements and repost adjusted movements.   *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  AR322732 - LEC0212A and APISERVER locks LTRIX file.          *
      *           - Prevent LTRIX RRN 1 from being locked.            *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSC054 - Period End Adjustments                              *
      *  CRE073 - Interest Rate Rounding                              *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CLE073 - Calculated Loan Based Fees                          *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  BUG23026 - Loan Confirmation Report is not showing Principal *
      *             Increase                                          *
      *  BUG26668 - Deleted lines without annotation for BUG8366      *
      *  243415 - Projected CR entries not generated even after       *
      *           authorisation.                                      *
      *  243270 - Errors in projected account movements               *
      *  CLE055 - Projected LE Movements                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CAS019 - Upgrade of CAS016 to Midas Plus                     *
      *  243275 - Principal Increase are doubling the exposure amount *
      *           during authorisation of the transaction.            *
      *  BUG13325 - No Swift MT202 produced in MT202, applied 238721A *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG10655R - PSAM is updated again during authorisation       *
      *  BUG10604- UNLOCK record locking for PTPF.                    *
      *  CLE042 - Extended Loan Sub Type                              *
      *  BUG9225 - Update LESTALPD with correct loan amendment        *
      *            sequence number.                                   *
      *  BUG8566- Principal Increase - authorized transaction creates *
      *           invalid postings in LEHOSTPD                        *
      *  BUG8366- Beneficiary not written in LEHOSTPD                 *
      *  CLE106 - Syndications Manager.                               *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2  *
      *           Allow specific base rates  (Recompile)              *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompile)                                         *
      *  CLE031 - Lending Enhancements                                *
      *  BUG8241- OME RPG patch for delivery                          *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it                                          *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4138 - Incorrect update of trailer file on authorisation. *
      *  BUG3936 - No need to count on Authorize action as Loan       *
      *            Amendment was already counted during Insert.       *
      *            Also, rename NORE of LTRIX to NORELX to avoid      *
      *            corruption with NORE of LOAMSZ1                    *
      *  BUG3760 - Compliance Watch (CSD015) changes missing from the *
      *            Lending APIs.                                      *
      *  BUG3054 - Update OSAC field in LOAMSDK to properly generate  *
      *            postings in RSACMTPD.                              *
      *  CLE025 - Credit Lines                                        *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A (recompile)*
      *  213280 - Action field missing in LE0320P1                    *
      *  CAP084 - Midas Plus API development                          *
      *  CLE030 - Release Authorisation processing                    *
      *  CLE023 - Lending Facility History Improvements.              *
      *  CAP075 - Lending API enhancements - Loan Amendments          *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      **   F-specs                               
      **   =======                               
      ** +--------------------------------------+

      ** Midas LE Loan Amendment Details
     FLOAMD     UF A E           K DISK    INFSR(*PSSR) COMMIT
     F                                     IGNORE(LOAMSDHF)

      ** Midas LE Loan Transaction Index Detail
     F***LTRIX**** UF   F   43        DISK    INFSR(*PSSR) COMMIT                           AR322732
     FLTRIX     O  A F   45        DISK    INFSR(*PSSR) COMMIT                              AR322732
     F                                     INFDS(FLDTX)

      ** Midas LE Customer loans
     FCLOAN     UF   E           K DISK    INFSR(*PSSR) COMMIT
     F                                     INCLUDE(CLOANCLF)
     F                                     PREFIX(LO_)

      ** Midas LE Customer Lending Facility File
     FFCLTY     UF   E           K DISK    INFSR(*PSSR) COMMIT
     F                                     IGNORE(FCLTYHHF)
     F                                     IGNORE(FCLTYZZF)
     F                                     PREFIX(FA_)

      ** Midas LE Loan amendment fee index file
     FLEFELAL0  UF A E           K DISK    INFSR(*PSSR) COMMIT

      ** Midas LE Lending fees master detail inputs
     FLEFEEDL1  UF   E           K DISK    INFSR(*PSSR) COMMIT

      *                                                                                     MD023203
     FLEFEEDL0  UF   E           K DISK    INFSR(*PSSR)                                     MD023203
     F                                     COMMIT                                           MD023203
     F                                     RENAME(LEFEEDF:LEFEEDX)                          MD023203
     F                                     PREFIX(X_)                                       MD023203
      *                                                                                       CLE030
     FLERELEPD  UF A E           K DISK    INFSR(*PSSR)                                       CLE030
     F                                     COMMIT                                             CLE030
                                                                                              CRE020
     FREADVCL2  UF   E           K DISK    USROPN                                             CRE020
     F                                     COMMIT                                             CRE020
      ** Midas RE Settled Transaction Index File by Ref No/Pgm Ref/Seq No                     CRE020
                                                                                              CRE020
     FSDCWHTL1  IF   E           K DISK                                                      BUG3760
      *                                                                                      BUG3760
      ** Compliance Watch Hit List                                                           BUG3760
      *                                                                                      BUG3760
     FLEEIRDL5  UF   E           K DISK    COMMIT                                             CAS011
     F                                     RENAME(LEEIRDD0: LEEIRDD5)                         CAS011
     FLESTALLA  UF   E           K DISK    COMMIT                                            BUG9225
      ** Midas LE Settlement Allocation by Parent PC Reference                               BUG9225
                                                                                              CAS019
      ** Effective Interest Rate Details                                                      CAS019
     FLEEIRDL9  UF   E           K DISK    INFSR(*PSSR)                                       CAS019
     F                                     COMMIT                                             CAS019
     F                                     RENAME(LEEIRDD0:LEEIRDD9)                          CAS019
      ** Effective Interest Rate Details                                                      CAS019
     FLEERAPL1  UF   E           K DISK    INFSR(*PSSR)                                       CAS019
     F                                     COMMIT                                             CAS019
      ** Loan Amendments for Updating                                                      AR1021983
     FLELOMKL3  UF A E           K DISK    COMMIT                                          AR1021983
     F                                     IGNORE(LOAMSDHF)                                AR1021983
     F                                     RENAME(LOAMSDKF:LOMKSDKF)                       AR1021983
     F                                     RENAME(LOAMSZ1F:LOMKSZ1F)                       AR1021983
      ** PDCL Loan Link file                                                                MD050018
     FLEPDUELE  UF A E           K DISK    COMMIT                                           MD050018
     F                                     INFSR(*PSSR)                                     MD050018
     FLEPDUEL6  UF   E           K DISK    COMMIT                                           MD050018
     F                                     INFSR(*PSSR)                                     MD050018
     F                                     RENAME(LEPDUED0:LEPDUED6)                        MD050018
     FLEPDUFLA  UF A E           K DISK    COMMIT                                           MD050018
     F                                     INFSR(*PSSR)                                     MD050018
     FLEPDUFLE  UF   E           K DISK    COMMIT                                           MD050018
     F                                     INFSR(*PSSR)                                     MD050018
     F                                     RENAME(LEPDUFD0:LEPDUFDE)                        MD050018
                                                                                              CLE134
      ** PDP Transaction Log File sent to MQ                                                  CLE134
     F***LEMQLGL0  UF   E           K DISK    INFSR(*PSSR)                          CLE134 MD022807I
     F**********                           COMMIT                                   CLE134 MD022807I
     F***SDAPDRL0  IF   E           K DISK    INFSR(*PSSR)                         MD024342 MD025467
      **********                                                                   MD024342 MD025467
      ***Midas*SD API Driving File                                                 MD024342 MD025467
     F***LOAMSZ1X  O    E             DISK    COMMIT                              MD024342B MD025467
     F**********                           RENAME(LOAMSZ1F:LOAMSZ1FX)             MD024342B MD025467
      ***API:*Midas LE LOAN AMENDS TRAILER                                        MD024342B MD025467
      **********                                                                  MD024342B MD025467
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
      ** +--------------------------------------+

      **----------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **----------------------------------------------------------------
      *
      **----------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **----------------------------------------------------------------
      *
      **----------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **----------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **----------------------------------------------------------------
      *
      **----------------------------------------------------------------

      ** +--------------------------------------+
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      **   Manually included D-specs             
      **   =========================             
      ** +--------------------------------------+

      ** +--------------------------------------+
      **   Named constants                       
      **   ===============                       
      ** +--------------------------------------+

     D*PSysValOME      C                   CONST('OMEIndicator')                      BUG8241 CSC054
     D PSysValPEA      C                   CONST('PEAIndicator')                              CSC054
     D PSysValPIAC     C                   CONST('PDCLPAMVPIAC')                            MD050018
      ** +--------------------------------------+
      **   Arrays and Data Structures            
      **   ==========================            
      ** +--------------------------------------+
                                                                                            AR656363
     D WUpdExpo        S              1A                                                    AR656363
     D CobMode         S              1A                                                   MD021423E

      ** File information data structure for LTRIX
     D FLDTX           DS
     D   TXSTS           *STATUS

      ** Switchable feature details                                                           CRE020
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRE020
     D  SCLCD        E                     EXTFLD(LCD)                                        CRE020
                                                                                              CRE020
      ** Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)

      ** Midas API message header format definition
     D APHEAD        E DS                  EXTNAME(APHEADPD)

      ** DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** SD data area                                                                        BUG3760
      *                                                                                      BUG3760
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                    BUG3760
      *                                                                                      BUG3760
      ** 24X7 status data area                                                               BUG3760
      *                                                                                      BUG3760
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                    BUG3760
      *                                                                                      BUG3760
      ** External DS for Customer Details                                                    BUG3760
      *                                                                                      BUG3760
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                 BUG3760
      *                                                                                      BUG3760
      ** External DS for Compliance Watch Transaction Details                                BUG3760
      *                                                                                      BUG3760
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                 BUG3760
      *                                                                                      BUG3760
      ** Watch List Transaction Details Data Structure                                       BUG3760
      *                                                                                      BUG3760
     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)                                 BUG3760
      *                                                                                      BUG3760
      ** External DS for Watch List Configuration Data                                       BUG3760
      *                                                                                      BUG3760
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                 BUG3760
                                                                                              CAS011
      ** External DS for Midas Hedging ICD file                                               CAS011
                                                                                              CAS011
     D SDHEDG        E DS                  EXTNAME(SDHEDGPD)                                  CAS011
      *                                                                                      BUG3760
      ** Compliance Engine Free Format String Parameter                                      BUG3760
      *                                                                                      BUG3760
     D PFreeFmtStr     S          30000A                                                     BUG3760
      *                                                                                      BUG3760
      ** Array Size Definition                                                               BUG3760
      *                                                                                      BUG3760
     D Elements        C                   CONST(26)                                         BUG3760
      *                                                                                      BUG3760
      ** CWA Array used in Midas Compliance Watch                                            BUG3760
      *                                                                                      BUG3760
     D CWA             S             25A   DIM(Elements) PERRCD(1) CTDATA                    BUG3760
      *                                                                                      BUG3760
      ** Watch List Fields Array.                                                            BUG3760
      *                                                                                      BUG3760
     D WLF             S             18A   DIM(12)                                           BUG3760
      *                                                                                      BUG3760
      ** Current loan amendment in file format
     D LoamFilFmt    E DS                  EXTNAME(LOAMSDK)
                                                                                              CRE073
      ** Current loan amendment in file format                                                CRE073
     D LoamFilXFmt   E DS                  EXTNAME(LEVLOAMPD)                                 CRE073
     D                                     PREFIX(@)                                          CRE073
      *
      ***  Loan details 'A' format
     D LoanDetsA     E DS                  EXTNAME(CLOAN:CLOANCLF)
     D                                     PREFIX(LO_)
     D RECIA         E                     EXTFLD(RECI)
     D PTYPA         E                     EXTFLD(PTYP)
     D LTYPA         E                     EXTFLD(LTYP)
     D SUTPA         E                     EXTFLD(SUTP)
     D AUTOC         E                     EXTFLD(AUTO)
     D FCUSC         E                     EXTFLD(FCUS)
     D FTYPC         E                     EXTFLD(FTYP)
     D FSEQC         E                     EXTFLD(FSEQ)
     D CCYD          E                     EXTFLD(CCY )
     D LCDA          E                     EXTFLD(LCD )
     D CHTPA         E                     EXTFLD(CHTP)
     D TNLUA         E                     EXTFLD(TNLU)
     D FCLBC         E                     EXTFLD(FCLB)
     D RCSIC         E                     EXTFLD(RCSI)
     D IUSRC         E                     EXTFLD(IUSR)
     D AUSRC         E                     EXTFLD(AUSR)
     D XUSRC         E                     EXTFLD(XUSR)
     D CLASA         E                     EXTFLD(CLAS)                                       CLE042

      ***  Loan details 'B' format
     D LoanDetsB     E DS                  EXTNAME(CLOAN:CLOANCKF)
     D                                     PREFIX(LO_)
     D LB_RECI       E                     EXTFLD(RECI)
     D LB_LNRF       E                     EXTFLD(LNRF)
     D LB_RCDT       E                     EXTFLD(RCDT)
     D LB_MRIN       E                     EXTFLD(MRIN)
     D LB_ORED       E                     EXTFLD(ORED)
     D LB_LCD        E                     EXTFLD(LCD)
     D LB_CHTP       E                     EXTFLD(CHTP)
     D LB_TNLU       E                     EXTFLD(TNLU)
     D LB_FRNT       E                     EXTFLD(FRNT)
     D LB_AFRT       E                     EXTFLD(AFRT)
     D LB_REPA       E                     EXTFLD(REPA)
     D LB_TMST       E                     EXTFLD(TMST)
      *
      ***  Facility details 'A' format
     D FacilityA     E DS                  EXTNAME(FCLTY:FCLTYFMF)
     D                                     PREFIX(FA_)
     D CNUMF         E                     EXTFLD(CNUM)
      *
      ***  Facility details 'B' format
     D FacilityB     E DS                  EXTNAME(FCLTY:FCLTYFNF)
     D                                     PREFIX(FA_)
     D FB_RECI       E                     EXTFLD(RECI)
     D FB_CNUM       E                     EXTFLD(CNUM)
     D FB_FACT       E                     EXTFLD(FACT)
     D FB_FCNO       E                     EXTFLD(FCNO)
     D FB_RCTP       E                     EXTFLD(RCTP)
     D FB_ORED       E                     EXTFLD(ORED)
     D FB_LCD        E                     EXTFLD(LCD)
     D FB_CHTP       E                     EXTFLD(CHTP)
     D FB_TNLU       E                     EXTFLD(TNLU)
     D FB_FRNT       E                     EXTFLD(FRNT)
     D FB_AFRT       E                     EXTFLD(AFRT)
     D FB_REPA       E                     EXTFLD(REPA)
     D FB_STMP       E                     EXTFLD(STMP)

      ** Error indicators
     D LOAM_OK       E DS                  EXTNAME(LEELOAMPD)

      ** New loan amendment in file format
     D ValidLoam     E DS                  EXTNAME(LEVLOAMPD)

      ** External data structures for update of PRONO, MEMOS etc.
     D Z#BSTS        E DS                  EXTNAME(Z#BST)
     D Z#ASTS        E DS                  EXTNAME(Z#AST)
     D Z#WSTS        E DS                  EXTNAME(Z#WST)

      ***  before image1 of update to LE position files                                       CLE055
     D                 DS                                                                     CLE055
     D Z#ZADTB                      256                                                       CLE055
     D     ZB_TYPE            85     86                                                       243415
     D     ZB_OTOURS          87    104                                                       243415
                                                                                              CLE055
      ***  after image1 of update to LE position files                                        CLE055
     D                 DS                                                                     CLE055
     D Z#ZADTA                      256                                                       CLE055
     D     ZA_TYPE            85     86                                                       CLE055
     D     ZA_OTOURS          87    104                                                       CLE055
                                                                                              CLE055
      ** Fields used for update of MEMOS, PRONO etc.
     D                 DS
     D Z#ADTA                  1    256
     D   SHRECI                1      1
     D   SHLNRF                2      7
     D   SHVDAT                8     12  0
     D   SHLASN               13     15  0
     D   SHPTYP               21     22  0
     D   SHAMTP               23     24
     D   SHRTSP               29     34P 7
     D   SHCCY                35     37
     D   SHPRAM               38     44P 0
     D   SHBRCA               73     75
     D   SHREPT               82     82  0
     D***SHTIST*              85    118                                                       CGL029
     D   SHTIST               85    124                                                       CGL029
     D     TYPE               85     86
     D*****OTOURS             87     98                                                       CGL029
     D*****THRS*              99    108                                                       CGL029
     D*****OTFACO            109    118                                                       CGL029
     D     OTOURS             87    104                                                       CGL029
     D     THRS              105    114                                                       CGL029
     D     OTFACO            115    124                                                       CGL029
     D   SHINTC              253    253
      *
     D Z#ADTB                257    512
     D   SHOSBR              261    263
     D   SHCHTP              317    317
      *
     D Z#ADTE               1025   1280
     D   SHSCCY             1061   1063
     D   SHICCY             1064   1066
     D   SHREXR             1090   1096P 8                                                    CLE031
     D   SHREXI             1097   1097                                                       CLE031
     D   SHPSCY             1098   1100                                                       CLE031
     D   SHPEXR             1101   1107P 8                                                    CLE031
     D   SHPEXI             1108   1108                                                       CLE031
     D   SHSTAL             1109   1109                                                       CLE034

     D Z#ADTH          DS                                                                     CLE134
     D  SHXRFI                        3A                                                      CLE134
     D  SHXRFN                       10S 0                                                    CLE134

     D FCLKEY          DS
     D***WFCNM**               1      6  0                                                    CSD027
     D   WFCNM                 1      6                                                       CSD027
     D   WFACT                 7      9  0
     D   WFNUM                10     11  0
     D   WFRTP                12     12

      ** Dates for Facility Exposure Array
     D                 DS
     D  FB_RUN0                1      3P 0
     D  FB_RUN1                4      6P 0
     D  FB_RUN2                7      9P 0
     D  FB_RUN3               10     12P 0
     D  FB_RUN4               13     15P 0
     D  FB_RUN5               16     18P 0
     D  FB_RUN6               19     21P 0
     D  FB_RUN7               22     24P 0
     D  FB_RUN8               25     27P 0
     D  FB_RUN9               28     30P 0
     D  FB_RUN                 1     30P 0 DIM(10) ASCEND

      ** Facility Exposure Array
     D                 DS
     D  FB_OAM1                1      7P 0
     D  FB_OAM2                8     14P 0
     D  FB_OAM3               15     21P 0
     D  FB_OAM4               22     28P 0
     D  FB_OAM5               29     35P 0
     D  FB_OAM6               36     42P 0
     D  FB_OAM7               43     49P 0
     D  FB_OAM8               50     56P 0
     D  FB_OAM9               57     63P 0
     D  FB_OA10               64     70P 0
     D  FB_OAM                 1     70P 0 DIM(10)
      *                                                                                       CLE030
      ** Break up timestamp field to get RETIME for Release Authorisation Report              CLE030
     D  WRLTMST        DS            26                                                       CLE030
     D  WREHRS                12     13                                                       CLE030
     D  WREMIN                15     16                                                       CLE030
     D  WRESEC                18     19                                                       CLE030

      ** Data Structure for MPHAS Dataarea                                                  MD021423
                                                                                            MD021423
     D MPHAS           DS             1                                                     MD021423
                                                                                            MD021423
      ** +--------------------------------------+
      **   Declared variables                    
      **   ==================                    
      ** +--------------------------------------+

      ** Message file for ZAMSGTOOPR
     D DummyMsgF       S             10    INZ('LERMSGF')

      ** Timestamp for the transaction
     D TimeStamp       S               Z

      ** Currency conversion
     D POWR            S              7  3 DIM(7) CTDATA PERRCD(1)

      ** Currencies and telex notice days
     D CYA             S              3    DIM(150)
     D TND             S              1  0 DIM(150)

      ** Parameter for APLOGTRAN
     D TransDtl        S           5800A
                                                                                              CLE025
     D CLE025          S              1                                                       CLE025
     D CLE031          S              1                                                       CLE031
                                                                                              CRE020
      ** CRE020 Variables                                                                     CRE020
     D PRtCd           S              7A                                                      CRE020
     D POptn           S              7A                                                      CRE020
     D PSARD           S              6A                                                      CRE020
     D CRE020          S              1A                                                      CRE020
     D KRefNo          S             30A                                                      CRE020
     D KSeqNo          S              3A                                                      CRE020
     D KPrgMn          S             10A   INZ('LELOAMUPD ')                                  CRE020
     D PSysVal01       S             20A   INZ('LoanAmendments      ')                        CRE020
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
     D WEvent          S              8A                                                      CRE020
     D WPrtAdv         S              1A                                                      CRE020
     D WNew            S              1A                                                      CRE020
                                                                                              CGL029
     D T#TREF          S             26A                                                      CGL029
     D @ACCD           S             10A                                                      CGL029
     D PDealNo         S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029

     D CAS016          S              1                                                       CAS019
     D CAS009          S              1                                                       CAS011
     D CSC011          S              1                                                      BUG3760
     D CSD015          S              1                                                      BUG3760
     D CCF001          S              1                                                      BUG3760
     D CLE055          S              1                                                       CLE055
      *                                                                                      BUG3760
     D WFuncType       S              8                                                      BUG3760
     D WIdntifier      S             40                                                      BUG3760
     D WBranch         S              3                                                      BUG3760
      *                                                                                      BUG3760
     D WData           S            216                                                      BUG3760
     D WDDT            S               D                                                     BUG3760
     D WLNRF           S              6                                                      BUG3760
     D WKVDAT          S              5                                                      BUG3760
     D WLASN           S              3                                                      BUG3760
     D*WROBN****       S              6P 0                                            BUG3760 CSD027
     D*WROCN****       S              6P 0                                            BUG3760 CSD027
     D*WPOBN****       S              6P 0                                            BUG3760 CSD027
     D*WPOCN****       S              6P 0                                            BUG3760 CSD027
     D WROBN           S              6                                                       CSD027
     D WROCN           S              6                                                       CSD027
     D WPOBN           S              6                                                       CSD027
     D WPOCN           S              6                                                       CSD027
     D WDTPC           S              1                                                      BUG3760
     D WDIFF           S              1                                                      BUG3760
     D WOPN            S             25                                                      BUG3760
     D WCLS            S             25                                                      BUG3760
     D WADJP           S              1                                                       CAS011
     D WDELR           S              1                                                       CAS011
     D*WTRAN****       S              6  0                                             CAS011 CLE148
     D WTRAN           S              6                                                       CLE148
     D WVALD           S              5  0                                                    CAS011
      *                                                                                      BUG3760
     D Ctr             S              2P 0                                                   BUG3760
     D CLS             S              2P 0                                                   BUG3760
     D OPN             S              2P 0                                                   BUG3760
     D PRetCode        S              7                                                      BUG3760
     D POption         S              7                                                      BUG3760
     D PCUST           S             10                                                      BUG3760
     D PYCCY           S              3                                                      BUG3760
     D PSTKey          S              7                                                      BUG3760
     D PFunc           S              8                                                      BUG3760
     D ConvertedAmt    S             18P 3                                                   BUG3760
     D PAmt            S             15                                                      BUG3760
     D PDummy6         S              6                                                      BUG3760
     D PDummy16        S             16                                                      BUG3760
     D PDummy35        S             35                                                      BUG3760
     D PDumy35a        S             35                                                      BUG3760
      *                                                                                      BUG3760
      ** ZACVTDATE Parameters                                                                BUG3760
      *                                                                                      BUG3760
     D PZARtCd         S              7                                                      BUG3760
     D PZADayNo        S              5                                                      BUG3760
     D PZADDT          S               D                                                     BUG3760
     D PZACvtDt        S             10                                                      BUG3760
      *                                                                                      BUG3760
     D*CSC024***       S              1A                                              BUG8241 CSC054
     D*WOMEInd**       S              1A                                              BUG8241 CSC054
     D CSC054          S              1A                                                      CSC054
     D WPEAInd         S              1A                                                      CSC054
                                                                                             BUG8241
     D WrkUpdFlag      S              1A                                                    BUG10604
                                                                                            BUG10604
     D PRI1            S              1S 0                                                  AR322732
     D CLE134          S              1A                                                   AR1021983
     D W#FRNT          S              8A                                                   AR1021983
     D WkPIAC          S              1A                                                    MD050018
     D PLoanType       S              2A                                                    MD050018
     D PLSubType       S              2A                                                    MD050018
     D PLClass         S              4A                                                    MD050018
     D WkCPAM          S             15  0                                                  MD050018
     D WkDINT          S             15  0                                                  MD050018
     D WkLASN          S              3  0                                                  MD050018
     D WkRECI          S              1A                                                    MD050018
     D WkPDCT          S              1A                                                    MD050018
      ** +--------------------------------------+
      **   End of D-specs                        
      **   ==============                        
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      **   Start of I-specs                      
      **   ================                      
      ** +--------------------------------------+

      ** Loan transactions index file - Header record
     I*LTRIX**** NS        1 CH                                                             AR322732
     I**********                        1    1  RECI                                        AR322732
     I**********                        2    2  RCDT                                        AR322732
     I**********                        3    8 0LNRF                                        AR322732
     I**********                   P    9   11 0NORE                                        Bug03936
     I**********                   P    9   11 0NORELX                             Bug03936 AR322732
     I**********                   P   12   14 0FLSZ                                        AR322732
     I**********                   P   15   17 0RRLC                                        AR322732
     I**********                   P   18   20 0RRNA                                        AR322732
     I**********                   P   21   23 0RRLX                                        AR322732
     I**********                   P   24   26 0RRXP                                        AR322732
     I**********                   P   27   29 0NLNR                                        AR322732
     I**********                   P   30   32 0NLAR                                        AR322732
     I**********                       33   33 0STPI                                        AR322732
     I**********                   P   38   40 0TNLU                                        AR322732
      *
      ** Loan transactions index file - Detail record
     I*LTRIX**** NS        1 CD    2 CA                                                     AR322732
     I*********OR         1 CD    2 CL                                                      AR322732
     I**********                        1    1  RECI                                        AR322732
     I**********                        2    2  RCDT                                        AR322732
     I**********                        3    8 0LNRF                                        AR322732
     I**********                        9   13 0VDAT                                        AR322732
     I**********                       14   16 0LASN                                        AR322732
     I**********                       17   17  CHTP                                        AR322732
     I**********                       18   18  CNRQ                                        AR322732
     I**********                       19   19  CNPR                                        AR322732
     I**********                       20   20  REPR                                        AR322732
     I**********                       21   25 0RRLA                                        AR322732
     I**********                       26   26  LADI                                        AR322732
     I**********                       27   27 0PRI1                                        AR322732
     I**********                       32   34  BRCA                                        AR322732
     I**********                   P   35   37 0RRNT                                        AR322732
     I**********                   P   38   40 0TNLU                                        AR322732
      *
      ** Loans transactions index file - Catchall
     I**********NS                                                                          AR322732
     I**********                        1    1  RECI                                        AR322732
     ILESTALD0                                                                               BUG9225
     I              RECI                        RECIXX                                       BUG9225
     I              TYPE                        TYPEXX                                       BUG9225
     I              TMST                        TMSTXX                                       BUG9225
     I              PCRF                        PCRFXX                                       BUG9225
     I              LNRF                        LNRFXX                                       BUG9225
     I              VDAT                        VDATXX                                       BUG9225
     I              LASQ                        LASQXX                                       BUG9225
     I              CNUM                        CNUMXX                                       BUG9225
     I              FACL                        FACLXX                                       BUG9225
     I              FESQ                        FESQXX                                       BUG9225
     I              SEQ                         SEQXX                                        BUG9225
     I              RCPC                        RCPCXX                                       BUG9225
     I              RSTM                        RSTMXX                                       BUG9225
     I              RIBN                        RIBNXX                                       BUG9225
     I              RIBA                        RIBAXX                                       BUG9225
     I              ROBN                        ROBNXX                                       BUG9225
     I              ROCN                        ROCNXX                                       BUG9225
     I              ROBR                        ROBRXX                                       BUG9225
     I              RSCY                        RSCYXX                                       BUG9225
     I              REXR                        REXRXX                                       BUG9225
     I              REXI                        REXIXX                                       BUG9225
     I              PYPC                        PYPCXX                                       BUG9225
     I              PSTM                        PSTMXX                                       BUG9225
     I              PIBN                        PIBNXX                                       BUG9225
     I              PIBA                        PIBAXX                                       BUG9225
     I              POBN                        POBNXX                                       BUG9225
     I              POCN                        POCNXX                                       BUG9225
     I              RCRN                        RCRNXX                                       BUG9225
     I              RCRA                        RCRAXX                                       BUG9225
     I              RVNO                        RVNOXX                                       BUG9225
     I              AWBN                        AWBNXX                                       BUG9225
     I              AWBA                        AWBAXX                                       BUG9225
     I              BENN                        BENNXX                                       BUG9225
     I              BENA                        BENAXX                                       BUG9225
     I              DTP1                        DTP1XX                                       BUG9225
     I              DTP2                        DTP2XX                                       BUG9225
     I              DTP3                        DTP3XX                                       BUG9225
     I              DTP4                        DTP4XX                                       BUG9225
     I              DCHG                        DCHGXX                                       BUG9225
     I              BTB1                        BTB1XX                                       BUG9225
     I              BTB2                        BTB2XX                                       BUG9225
     I              BTB3                        BTB3XX                                       BUG9225
     I              BTB4                        BTB4XX                                       BUG9225
     I              BTB5                        BTB5XX                                       BUG9225
     I              BTB6                        BTB6XX                                       BUG9225
     I              POBR                        POBRXX                                       BUG9225
     I              CVMR                        CVMRXX                                       BUG9225
     I              PSCY                        PSCYXX                                       BUG9225
     I              IC72                        IC72XX                                       BUG9225
     I              PEXR                        PEXRXX                                       BUG9225
     I              PEXI                        PEXIXX                                       BUG9225
     I              PTRF                        PTRFXX                                       BUG9225
     I              RONS                        RONSXX                                       BUG9225
     I              PONS                        PONSXX                                       BUG9225
     I              PYBA                        PYBAXX                                       BUG9225
     I              PYAM                        PYAMXX                                       BUG9225
     I              RCBA                        RCBAXX                                       BUG9225
     I              RCAM                        RCAMXX                                       BUG9225
     I              CCY                         CCYXX                                        BUG9225
     I                                                                                       BUG9225
      ** +--------------------------------------+
      **   End of I-specs                        
      **   ==============                        
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      **                                                                   
      **   Initial processing is performed automatically: the *INZSR is    
      **   executed at program activation.                                 
      **                                                                   
      ** +----------------------------------------------------------------+

      ** Check whether user is a web browser user, if so overwrite              CAP084
     C                   CALL      'SFC000026'                                  CAP084
     C                   PARM      *BLANKS       USER             10            CAP084
      *                                                                         CAP084
     C                   IF        USER <> *BLANKS                              CAP084
     C                   EVAL      PSUSER = USER                                CAP084
     C                   ENDIF                                                  CAP084

      ***Processing*init***********************************************                       CLE106
     C**********         EXSR      SRINIT                                                     CLE106
      *
      ** Ensure the amendment has not been updated by another workstation
      ** - if so, bypass updating and return to calling program.
     C                   EXSR      CHKOTHUPD
      ** Processing init                                                                      CLE106
     C                   EXSR      SRINIT                                                     CLE106
      *
     C                   IF        @@RTCD <> *BLANKS
     C                   GOTO      EXIT
     C                   ENDIF
      *
      ** Insert, amend, authorise or reverse the loan amendment
     C                   SELECT
     C     DDACTN        WHENEQ    'I'
     C                   EXSR      INSERT
     C     DDACTN        WHENEQ    'A'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'R'
     C     DDACTN        OREQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
     C                   EXSR      AMEND
     C                   ENDSL
                                                                                              CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        CRE020  = 'Y' AND                                          CRE020
     C                             WPrtAdv = 'Y'                                              CRE020
     C                   SELECT                                                               CRE020
     C                   WHEN      DDACTN = 'X' OR                                            CRE020
     C                             DDACTN = 'R'                                               CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   WHEN      DDACTN = 'A'                                               CRE020
     C                   EXSR      SRIdxAmd                                                   CRE020
                                                                                              CRE020
     C                   IF        BPLMAU = 'N'                                               CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   WHEN      DDACTN = 'I'                                               CRE020
     C                   IF        BPLMAU = 'N'                                               CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDSL                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
      *
      ***  Exit From Program
     C     EXIT          TAG
      *
     C                   RETURN
      ****************************************************************
      /EJECT
      *****************************************************************
      * CHKOTHUPD - Check for update by another workstation           *
      *****************************************************************
     C     CHKOTHUPD     BEGSR
      *
      ** Set up key fields for retrieve
     C                   MOVE      LALNRF        DDLOAN
     C                   MOVE      LAAMTP        DDATYP
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      LAVDAT        ZDAYNO            5 0
     C                   PARM      BJDFIN        DateFmt           1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZDATE         DDVDAT
      *
     C                   IF        LALASN <> 0
     C                   MOVE      LALASN        DDSEQN
     C                   ELSE
      *
     C                   MOVE      *Blanks       DDSEQN
     C                   ENDIF
      *
     C                   MOVEL     LoamFilFmt    LoamFilXFmt                                  CRE073
      ** Call to the retrieve module
     C                   CALLB     'LELOAMRTV'

      ** Return code
     C                   PARM      *Blanks       RetCodeIn

      * Mode = '*FRONT' (Front office transaction interface)
      * Mode = '      ' (Not front office transaction interface)
     C                   PARM                    ModeofOp          6

      ** Response mode
     C                   PARM      *Blank        RespMode          1

      ** Action Code
     C                   PARM                    DDACTN            1

      ** Front Office Transaction ID
     C                   PARM      LAFRNT        FOTRID           20

      * Loan number / value date / sequence / type
     C                   PARM                    DDLOAN            6
     C                   PARM                    DDVDAT            6
     C                   PARM                    DDSEQN            3
     C                   PARM                    DDATYP            2

      * Where called from
     C                   PARM      'UPD'         CallModCod        3

      ** Features
     C                   PARM                    CEU020
     C                   PARM                    CLE030                                       CLE030

      * Multi-branching/date format indicators
     C                   PARM                    BGMBIN
     C                   PARM                    BJDFIN

      * Current loan amendment in file format, plus loan/facility details
     C                   PARM                    LoamFilFmt
     C                   PARM                    LoanDetsA
     C                   PARM                    LoanDetsB
     C                   PARM                    FacilityA
     C                   PARM                    FacilityB

      ** Error Indicators
     C                   PARM                    LOAM_OK

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx               3 0
     C                   PARM                    LoamFilXFmt                                  CRE073
     C                   PARM                    CobMode                                   MD021423E
      *
      ** Processing varies according to mode program is running in.
      ** In interactive mode simply check the timestamps.
      ** In batch (API input) check return parameters from Retrieve
      ** module for errors, and send message to system operator.
      *
      ** Interactive mode:
     C                   IF        @TYPE = '1'
      *
      **  Error if Timestamp is not the same (record has been changed
      **  by another workstation)
     C                   IF        TMST <> LATMST and
     C                             DDACTN <> 'I'
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   ENDIF
      *
      ** Batch mode:
     C                   ELSE
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDLOANOK      OREQ      'N'
     C     DDVDATOK      OREQ      'N'
     C     DDSEQNOK      OREQ      'N'
     C     DDATYPOK      OREQ      'N'
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   EVAL      DBerror = 'Update error: ' + FOTRID
      *
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError         132
     C                   PARM                    DummyMsgID        7
     C                   PARM                    DummyMsgF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * INSERT - Insert a loan amendment                             *
      ****************************************************************
     C     INSERT        BEGSR
                                                                                             BUG8241
      ***bypass*generate*Amendment*Seq.*No.*for*Insert*if*CSC024*is                   BUG8241 CSC054
      ***switched*on*and*running*on*OME*system.                                       BUG8241 CSC054
      ** bypass generate Amendment Seq. No. for Insert if CSC054 is                           CSC054
      ** switched on and running on PEA system.                                               CSC054
                                                                                             BUG8241
     C**********         IF        MPHAS <> 'A'                                    MD021423 MD025467
     C                   IF        MPHAS =  'C'                                             MD025467
     C                             AND DDSEQN <> *BLANKS                                    MD021423
     C                             AND CLE134 = 'Y'                                         MD021423
     C                   MOVEL     DDSEQN        LALASN                                     MD021423
     C                   ELSE                                                               MD021423
     C*****CSC024        IFNE      'Y'                                                BUG8241 CSC054
     C*****WOMEInd       ORNE      'Y'                                                BUG8241 CSC054
     C     CSC054        IFNE      'Y'                                                        CSC054
     C     WPEAInd       ORNE      'Y'                                                        CSC054
     C     LALASN        OREQ      *ZERO                                                     BUG8241
      *
      ** Find next available sequence no. for insert
     C                   Z-ADD     0             LALASN
     C                   MOVE      LALNRF        WKLNR
     C                   Z-ADD     LAVDAT        WKVDT
     C                   Z-ADD     0             WKLSN
     C     KLAKEY        SETLL     LOAMD
     C                   READ(N)   LOAMD                                  99
      *
     C     *IN99         DOWEQ     '0'
      *
     C     RECI          IFEQ      'T'
     C                   LEAVE
     C                   ENDIF
      *
     C     LNRF          IFNE      LALNRF
     C     VDAT          ORNE      LAVDAT
     C                   LEAVE
     C                   ENDIF
      *
     C                   Z-ADD     LASN          LALASN
     C                   READ(N)   LOAMD                                  99
     C                   ENDDO
      *
     C                   ADD       1             LALASN
                                                                                             BUG8241
     C                   ENDIF                                                               BUG8241
     C                   ENDIF                                                              MD021423
      *
      ** Obtain last transaction number to be used
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    @Natn             5 0
      *
     C                   Z-ADD     @Natn         LATNLU
      *
      ** Generate a timestamp for this transaction
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      *
     C                   MOVE      TimeStamp     LATMST
      *
      ** Verify if its a PI for PDCL and get loan records.                                  MD023787
      *                                                                                     MD023787
     C                   MOVE      *BLANKS       PDCLI             1                        MD023787
     C                   IF        CobMode <> 'Y'  and                                      MD023787
     C                             LAAMTP = 'PI' and                                        MD023787
     C                             (%SUBST(LTYPA:1:1) = 'X' or                              MD023787
     C                              %SUBST(LTYPA:1:1) =  'Y' or                             MD023787
     C                              %SUBST(LTYPA:1:1) =  'Z')                               MD023787
      *                                                                                     MD050018
      ** When PDCLPAMVPIAC is 'Y', use loan pay details                                     MD050018
     C                   IF        W#FRNT = 'LE000473' or                                   MD050018
     C                             WkPIAC = 'N'                                             MD050018
     C                   MOVE      LALNRF        WKLNR                                      MD023787
     C                   MOVE      'A'           WRCDT                                      MD023787
     C     KLKEY         CHAIN     CLOAN                              99                    MD023787
     C     LO_AUTO       IFEQ      'C'                                                      MD023787
     C     *IN99         ANDEQ     '0'                                                      MD023787
     C                   EXSR      GETLON                                                   MD023787
     C                   ENDIF                                                              MD023787
      *                                                                                     MD050018
     C                   ELSE                                                               MD050018
     C                   EVAL      PDCLI = 'P'                                              MD050018
     C                   ENDIF                                                              MD050018
     C                   ENDIF                                                              MD023787
      *                                                                                     MD023787
     C     WSOLD         IFEQ      'Y'                                                       BUG3054
     C     PDCLI         OREQ      'Y'                                                      MD023787
     C                   MOVE      LARONS        LAOSAC                                      BUG3054
     C                   ELSE                                                                BUG3054
     C                   MOVE      LAPONS        LAOSAC                                      BUG3054
     C                   ENDIF                                                               BUG3054
                                                                                             BUG3054
      ** Set up and write the new record to LOAMS
     C**********         MOVE      ValidLoam     LoamFilFmt                                   CRE073
     C                   MOVEL     ValidLoam     LoamFilFmt                                   CRE073
      *                                                                                      BUG3760
      ** Execute SRWTCH if compliance watch is installed, watch list checking                BUG3760
      ** is applied and in the main system.                                                  BUG3760
      *                                                                                      BUG3760
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y' AND                         BUG3760
     C                             LAAMTP = 'PI'                                             BUG3760
      *                                                                                      BUG3760
     C                   IF        LARONS <> *BLANKS OR                                      BUG3760
     C                             LARIBN <> *BLANKS OR                                      BUG3760
     C**********                   LAROBN <> *ZERO   OR                               BUG3760 CSD027
     C**********                   LAROCN <> *ZERO   OR                               BUG3760 CSD027
     C                             LAROBN <> *BLANKS OR                                       CSD027
     C                             LAROCN <> *BLANKS OR                                       CSD027
     C                             LAPONS <> *BLANKS OR                                      BUG3760
     C                             LAPIBN <> *BLANKS OR                                      BUG3760
     C**********                   LAPOBN <> *ZERO   OR                               BUG3760 CSD027
     C**********                   LAPOCN <> *ZERO   OR                               BUG3760 CSD027
     C                             LAPOBN <> *BLANKS OR                                       CSD027
     C                             LAPOCN <> *BLANKS OR                                       CSD027
     C                             LARCRN <> *BLANKS OR                                      BUG3760
     C                             LARVNO <> *BLANKS OR                                      BUG3760
     C                             LAAWBN <> *BLANKS OR                                      BUG3760
     C                             LABENN <> *BLANKS OR                                      BUG3760
     C                             LADTP1 <> *BLANKS OR                                      BUG3760
     C                             LADTP2 <> *BLANKS OR                                      BUG3760
     C                             LADTP3 <> *BLANKS OR                                      BUG3760
     C                             LADTP4 <> *BLANKS                                         BUG3760
     C                   MOVEL     'Y'           WDTPC                                       BUG3760
     C                   MOVEL     LARONS        WLF(1)                                      BUG3760
     C                   MOVEL     LARIBN        WLF(2)                                      BUG3760
     C                   MOVEL     LAROBN        WLF(3)                                      BUG3760
     C                   MOVEL     LAROCN        WLF(4)                                      BUG3760
     C                   MOVEL     LAPONS        WLF(5)                                      BUG3760
     C                   MOVEL     LAPIBN        WLF(6)                                      BUG3760
     C                   MOVEL     LAPOBN        WLF(7)                                      BUG3760
     C                   MOVEL     LAPOCN        WLF(8)                                      BUG3760
     C                   MOVEL     LARCRN        WLF(9)                                      BUG3760
     C                   MOVEL     LARVNO        WLF(10)                                     BUG3760
     C                   MOVEL     LAAWBN        WLF(11)                                     BUG3760
     C                   MOVEL     LABENN        WLF(12)                                     BUG3760
      *                                                                                      BUG3760
     C                   IF        CSC011 = 'N' OR (CSC011 = 'Y'                             BUG3760
     C                             AND LIBR = S1MAIN)                                        BUG3760
      *                                                                                      BUG3760
     C                   EXSR      SrWTCH                                                    BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                              CAS011
                                                                                              CAP086
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        LAAUTH = 'Y'                                               CAP086
     C                   EVAL      AUTH = LAAUTH                                              CAP086
     C                   EVAL      ASTS = 'A'                                                 CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
      ** Only process EIR cost accounting if loan's value date is same                        CAS011
      ** as or after the non-linear amortisation cut-off date                                 CAS011
                                                                                              CAS011
     C                   IF        CAS009 = 'Y'                                               CAS011
     C                             AND VDAT >= FSNLAC                                         CAS011
     C                             OR CAS016 = 'Y'                                            CAS019
                                                                                              CAS011
     C                   EVAL      WADJP = *BLANKS                                            CAS011
     C                   EVAL      WDELR = *BLANKS                                            CAS011
                                                                                              CAS011
      ** Need to recalculate the EIR of a loan on amendment.                                  CAS011
                                                                                              CAS011
     C                   IF        DDATYP = 'PF' OR DDATYP = 'PT' OR                          CAS011
     C                             DDATYP = 'PI' OR DDATYP = 'SA'                             CAS011
     C                   EVAL      WTRAN = LNRF                                               CAS011
     C                   EVAL      WVALD = VDAT                                               CAS011
     C                   IF        CAS016 = 'Y'                                               CAS019
     C                   EVAL      WADJP = 'Y'                                                CAS019
     C                   ENDIF                                                                CAS019
     C                   EXSR      SEIRI1                                                     CAS011
     C                   ENDIF                                                                CAS011
     C                   IF        DDATYP = 'SC' OR DDATYP = 'BC'                             CAS011
     C                   EVAL      WTRAN = LNRF                                               CAS011
     C                   EVAL      WVALD = VDAT                                               CAS011
     C                   EVAL      WADJP = 'Y'                                                CAS011
     C                   EXSR      SEIRI1                                                     CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
     C                   ENDIF                                                                CAS011
                                                                                             BUG8366
     C                   MOVE      *BLANKS       Z#BSTS                                      BUG8366
     C                   MOVEL     LoamFilFmt    Z#ASTS                                      BUG8366
      *
     C                   IF        W#FRNT = 'LE000473'                                      MD020390
     C                   EVAL      AUTO = 'C'                                               MD020390
     C                   EVAL      MTPD = 'N'                                               MD020390
     C                   ENDIF                                                              MD020390
      *                                                                                     MD020390
     C                   WRITE     LOAMSDKF
      *                                                                                    AR1021983
      ** Write to Loan amendments update file                                              AR1021983
      *                                                                                    AR1021983
     C                   IF        CLE134 = 'Y' AND                                        AR1021983
     C                             (W#FRNT = 'LE000473' OR                                 AR1021983
     C                             W#FRNT = *BLANKS)                                       AR1021983
     C                   WRITE     LOMKSDKF                                                AR1021983
      *                                                                                       CLE134
     C*****LAFRNT        CHAIN     LEMQLGL0                                         CLE134 MD022807I
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
      *                                                                                    AR1085742
     C**********         CALLB     'ZAGENTMSTM'                                  AR1085742 MD022807I
     C**********         PARM                    TimeStamp                       AR1085742 MD022807I
      *                                                                                    AR1085742
      ** Timestamp                                                                         AR1085742
      *                                                                                    AR1085742
     C**********         EVAL      LGPROC = TimeStamp                            AR1085742 MD022807I
      *                                                                                    AR1085742
     C**********         UPDATE    LEMQLGPF                                         CLE134 MD022807I
     C**********         ENDIF                                                      CLE134 MD022807I
     C                   ENDIF                                                             AR1021983
      *                                                                                     MD050018
      ** Update the PDP link files LEPDUEPD and LEPDUFPD                                    MD050018
      *                                                                                     MD050018
     C                   IF        CLE134 = 'Y' AND CobMode <> 'Y' AND                      MD050018
     C                             W#FRNT <> 'LE000473' AND WkPIAC = 'Y' AND                MD050018
     C                             LAAMTP = 'PI' AND                                        MD050018
     C                             (%SUBST(LTYPA:1:1) = 'X' OR                              MD050018
     C                              %SUBST(LTYPA:1:1) = 'Y' OR                              MD050018
     C                              %SUBST(LTYPA:1:1) =  'Z')                               MD050018
     C                   EXSR      SrUpdPDCL                                                MD050018
     C                   ENDIF                                                              MD050018
      *
      ** Update the other files
     C                   EXSR      UpdOthFil
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * AMEND  - Amend a loan amendment                              *
      ****************************************************************
     C     AMEND         BEGSR
      *
      ** Access the record to be amended
     C                   MOVE      LALNRF        WKLNR
     C                   MOVE      LAVDAT        WKVDT
     C                   MOVE      LALASN        WKLSN
     C     KLAKEY        CHAIN     LOAMD                              99
      *
     C     *IN99         IFEQ      *ON
     C**********         EVAL      DBKEY = %Char(WKLNR) + %Char(WKVDT) +                      CLE148
     C                   EVAL      DBKEY = WKLNR + %Char(WKVDT) +                             CLE148
     C                                     %Char(WKLSN)                         ************
     C                   MOVEL(P)  'LOAMS'       DBFILE                         * DBERR 11 *
     C                   Z-ADD     11            DBASE                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                             BUG8366
     C                   MOVEL     LoamFilFmt    Z#BSTS                                      BUG8366
      *
      ** Save the current principal amount of the record
     C                   Z-ADD     PRAM          WPRAM            13 0
     C                   Z-ADD     PRAM          OPRAM                                      MD047554
      *
      ** Update on shadow files should only be done if not a Risk loan
     C     PTYP          IFNE      70
     C     PTYP          ANDNE     71
     C     PTYP          ANDNE     72
      *
     C     LAAMTP        IFNE      'PT'
     C     LAAMTP        ANDNE     'PF'
     C                   EXSR      SRSHAD
     C                   MOVE      Z#ADTA        Z#BDT1
     C                   MOVE      Z#ADTB        Z#BDT2
      *
     C     CLE055        Ifeq      'Y'                                                        243415
     C     BPLMAU        andeq     'Y'                                                        243415
     C     LAAUTH        andne     'Y'                                                        243415
     C     LAAMTP        andeq     'PI'                                                       243415
     C                   Clear                   Z#ZADTB                                      243415
     C                   Eval      Z#ZADTB   =    Z#BDT1                                      243415
      *                                                                                       243415
     C                   If        PONS = OTOURS and DDACTN = 'A' and                         243415
     C                             ASTS <> 'A' or PONS = OTOURS and                           243415
     C                             DDACTN = 'R' and ASTS <> 'A'                               243415
     C                   Clear                   ZB_Type                                      243415
     C                   Clear                   ZB_Otours                                    243415
     C                   Endif                                                                243415
     C                   If        DDACTN = 'X' or DDACTN = 'Q' and                           243415
     C                             CLE030 = 'Y'                                               243415
     C                   Clear                   ZB_Type                                      243415
     C                   Clear                   ZB_Otours                                    243415
     C                   Endif                                                                243415
     C                   Eval      Z#BDT1    =    Z#ZADTB                                     243415
      *                                                                                       243415
     C                   Endif                                                                243415
      *                                                                                       243415
     C     CEU004        IFEQ      'Y'
     C     CLE031        OREQ      'Y'                                                        CLE031
     C                   MOVE      Z#ADTE        Z#BDT5
     C                   ENDIF
                                                                                              CLE134
     C                   IF        CLE134      = 'Y'                                          CLE134
     C                   EVAL      Z#BDT8      = Z#ADTH                                       CLE134
     C                   ENDIF                                                                CLE134
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Obtain last transaction number to be used
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANKS       ReturnCode
     C                   PARM                    @Natn             5 0
      *
     C                   Z-ADD     @Natn         LATNLU
      *
      ** Generate a timestamp for this transaction
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      *
     C                   MOVE      TimeStamp     LATMST
      *                                                                                     MD023787
      ** Verify if its a PI for PDCL and get loan records.                                  MD023787
      *                                                                                     MD023787
     C                   MOVE      *BLANKS       PDCLI             1                        MD023787
     C                   IF        CobMode <> 'Y'  and                                      MD023787
     C                             LAAMTP = 'PI' and                                        MD023787
     C                             (%SUBST(LTYPA:1:1) = 'X' or                              MD023787
     C                              %SUBST(LTYPA:1:1) =  'Y' or                             MD023787
     C                              %SUBST(LTYPA:1:1) =  'Z')                               MD023787
      *                                                                                     MD050018
      ** When PDCLPAMVPIAC is 'Y', use loan pay details                                     MD050018
     C                   IF        W#FRNT = 'LE000473' or                                   MD050018
     C                             WkPIAC = 'N'                                             MD050018
     C                   MOVE      LALNRF        WKLNR                                      MD023787
     C                   MOVE      'A'           WRCDT                                      MD023787
     C     KLKEY         CHAIN     CLOAN                              99                    MD023787
     C     LO_AUTO       IFEQ      'C'                                                      MD023787
     C     *IN99         ANDEQ     '0'                                                      MD023787
     C                   EXSR      GETLON                                                   MD023787
     C                   ENDIF                                                              MD023787
      *                                                                                     MD050018
     C                   ELSE                                                               MD050018
     C                   EVAL      PDCLI = 'P'                                              MD050018
     C                   ENDIF                                                              MD050018
     C                   ENDIF                                                              MD023787
      *
     C     WSOLD         IFEQ      'Y'                                                       BUG3054
     C     PDCLI         OREQ      'Y'                                                      MD023787
     C**********         MOVE      RONS          LAOSAC                             BUG3054 AR848765
     C                   MOVE      LARONS        LAOSAC                                     AR848765
     C                   ELSE                                                                BUG3054
     C**********         MOVE      PONS          LAOSAC                             BUG3054 AR848765
     C                   MOVE      LAPONS        LAOSAC                                     AR848765
     C                   ENDIF                                                               BUG3054
                                                                                             BUG3054
      ** Check if before and after image of the record of LOAMSDK is different               BUG3760
      *                                                                                      BUG3760
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y'                             BUG3760
      *                                                                                      BUG3760
     C                   EVAL      WDIFF = 'N'                                               BUG3760
     C                   EVAL      WDTPC = 'N'                                               BUG3760
     C                   MOVE      ROBN          WROBN                                       BUG3760
     C                   MOVE      ROCN          WROCN                                       BUG3760
     C                   MOVE      POBN          WPOBN                                       BUG3760
     C                   MOVE      POCN          WPOCN                                       BUG3760
      *                                                                                      BUG3760
     C                   MOVE      *BLANKS       WLF                                         BUG3760
      *                                                                                      BUG3760
     C                   IF        RONS <> LARONS                                            BUG3760
     C                   MOVEL     LARONS        WLF(1)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        RIBN <> LARIBN                                            BUG3760
     C                   MOVEL     LARIBN        WLF(2)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        WROBN <> LAROBN                                           BUG3760
     C                   MOVEL     LAROBN        WLF(3)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        WROCN <> LAROCN                                           BUG3760
     C                   MOVEL     LAROCN        WLF(4)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        PONS <> LAPONS                                            BUG3760
     C                   MOVEL     LAPONS        WLF(5)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        PIBN <> LAPIBN                                            BUG3760
     C                   MOVEL     LAPIBN        WLF(6)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        WPOBN <> LAPOBN                                           BUG3760
     C                   MOVEL     LAPOBN        WLF(7)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        WPOCN <> LAPOCN                                           BUG3760
     C                   MOVEL     LAPOCN        WLF(8)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        RCRN <> LARCRN                                            BUG3760
     C                   MOVEL     LARCRN        WLF(9)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        RVNO <> LARVNO                                            BUG3760
     C                   MOVEL     LARVNO        WLF(10)                                     BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        AWBN <> LAAWBN                                            BUG3760
     C                   MOVEL     LAAWBN        WLF(11)                                     BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        BENN <> LABENN                                            BUG3760
     C                   MOVEL     LABENN        WLF(12)                                     BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        DTP1 <> LADTP1 OR                                         BUG3760
     C                             DTP2 <> LADTP2 OR                                         BUG3760
     C                             DTP3 <> LADTP3 OR                                         BUG3760
     C                             DTP4 <> LADTP4                                            BUG3760
     C                   MOVE      'Y'           WDTPC                                       BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
      ** Set up and update the record of LOAMS
     C**********         MOVE      ValidLoam     LoamFilFmt                                   CRE073
     C                   MOVEL     ValidLoam     LoamFilFmt                                   CRE073
      *                                                                                      BUG3760
      ** Execute SRWTCH if compliance watch is installed, watch list checking                BUG3760
      ** is applied and in the main system.                                                  BUG3760
      *                                                                                      BUG3760
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y' AND                         BUG3760
     C                             AMTP = 'PI' AND DDACTN = 'A'                              BUG3760
      *                                                                                      BUG3760
     C                   IF        CSC011 = 'Y' AND S1MAIN = LIBR OR                         BUG3760
     C                             CSC011 = 'N'                                              BUG3760
      *                                                                                      BUG3760
     C                   MOVEL     *BLANKS       WFuncType                                   BUG3760
     C                   MOVEL     *BLANKS       WIdntifier                                  BUG3760
     C                   MOVEL     *BLANKS       WBranch                                     BUG3760
     C                   MOVEL     *BLANKS       WLNRF                                       BUG3760
     C                   MOVEL     *BLANKS       WKVDAT                                      BUG3760
     C                   MOVEL     *BLANKS       WLASN                                       BUG3760
      *                                                                                      BUG3760
     C                   MOVEL     'LOAMSDK'     WFuncType                                   BUG3760
     C                   MOVE      LNRF          WLNRF                                       BUG3760
     C                   MOVE      VDAT          WKVDAT                                      BUG3760
     C                   MOVE      LASN          WLASN                                       BUG3760
     C                   EVAL      WIdntifier = WLNRF + WKVDAT + WLASN                       BUG3760
     C                   EVAL      WBranch = BRCA                                            BUG3760
      *                                                                                      BUG3760
     C     KCwFld        CHAIN     SDCWHTL1                                                  BUG3760
      *                                                                                      BUG3760
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
     C                   EXSR      SrWTCH                                                    BUG3760
      *                                                                                      BUG3760
     C                   ELSE                                                                BUG3760
      *                                                                                      BUG3760
     C                   IF        WDIFF = 'Y'                                               BUG3760
     C                   EXSR      SrWTCH                                                    BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                              CAS011
                                                                                              CAP086
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        LAAUTH = 'Y'                                               CAP086
     C                   EVAL      AUTH = LAAUTH                                              CAP086
     C                   EVAL      ASTS = 'A'                                                 CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
      ** Only process EIR cost accounting if loan's value date is same                        CAS011
      ** as or after the non-linear amortisation cut-off date                                 CAS011
                                                                                              CAS011
     C                   IF        CAS009 = 'Y'                                               CAS011
     C                             AND VDAT >= FSNLAC                                         CAS011
     C                             OR CAS016 = 'Y'                                            CAS019
                                                                                              CAS011
     C                   EVAL      WADJP = *BLANKS                                            CAS011
     C                   EVAL      WDELR = *BLANKS                                            CAS011
                                                                                              CAS011
      ** Need to recalculate the EIR of a loan on amendment.                                  CAS011
                                                                                              CAS011
     C                   IF        DDATYP = 'PF' OR DDATYP = 'PT' OR                          CAS011
     C                             DDATYP = 'PI' OR DDATYP = 'SA'                             CAS011
     C                   EVAL      WTRAN = LNRF                                               CAS011
     C                   EVAL      WVALD = VDAT                                               CAS011
     C                   IF        CAS016 = 'Y'                                               CAS019
     C                   EVAL      WADJP = 'Y'                                                CAS019
     C                   ENDIF                                                                CAS019
     C                   EXSR      SEIRI1                                                     CAS011
     C                   ENDIF                                                                CAS011
     C                   IF        DDATYP = 'SC' OR DDATYP = 'BC'                             CAS011
     C                   EVAL      WTRAN = LNRF                                               CAS011
     C                   EVAL      WVALD = VDAT                                               CAS011
     C                   EVAL      WADJP = 'Y'                                                CAS011
     C                   EXSR      SEIRI1                                                     CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
     C                   ENDIF                                                                CAS011
      *
     C                   UPDATE    LOAMSDKF
                                                                                              CLE055
      **If*authorization required clear settlement details.                            CLE055 243415
     C*********          If        CLE055 = 'Y'  and  BPLMAU = 'Y'                     CLE055 243415
     C*********                                  and  ASTS  <> 'A'                     CLE055 243415
     **********                                                                        CLE055 243415
     C*********          Clear                   Z#ZADTA                               CLE055 243415
     C*********          Clear                   Z#ZADTB                               CLE055 243415
      *********                                                                        CLE055 243415
     C*********          Eval      Z#ZADTB   =    Z#BDT1                               CLE055 243415
      *********                                                                        CLE055 243415
     C*********          Endif                                                         CLE055 243415
                                                                                       CLE055 243415
      *                                                                                     BUG26668
     C                   MOVEL     LoamFilFmt    Z#ASTS                                     BUG26668
      *                                                                                     MD050018
      ** Update the PDP link files LEPDUEPD and LEPDUFPD                                    MD050018
      *                                                                                     MD050018
     C                   IF        CLE134 = 'Y' AND CobMode <> 'Y' AND                      MD050018
     C                             W#FRNT <> 'LE000473' AND WkPIAC = 'Y' AND                MD050018
     C                             LAAMTP = 'PI' AND                                        MD050018
     C                             (%SUBST(LTYPA:1:1) = 'X' OR                              MD050018
     C                              %SUBST(LTYPA:1:1) = 'Y' OR                              MD050018
     C                              %SUBST(LTYPA:1:1) =  'Z')                               MD050018
     C                   EXSR      SrUpdPDCL                                                MD050018
     C                   ENDIF                                                              MD050018
      *
      ** Update the other files
     C                   EXSR      UpdOthFil
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * UpdOthFil - Update all the other files                       *
      ****************************************************************
     C     UpdOthFil     BEGSR
      *                                                                                       CLE030
     C     PCRF          CHAIN     LESTALLA                           99                     BUG9225
     C     *IN99         DOWEQ     *OFF                                                      BUG9225
     C                   Z-ADD     LASN          LASQXX                                      BUG9225
     C                   UPDATE    LESTALD0                                                  BUG9225
     C     PCRF          READE     LESTALLA                               99                 BUG9225
     C                   ENDDO                                                               BUG9225
      *                                                                                      BUG9225
      ** If Action is release, 'Q' and CLE030 is switched on                                  CLE030
      *                                                                                       CLE030
     C     DDACTN        IFEQ      'Q'                                                        CLE030
     C     CLE030        ANDEQ     'Y'                                                        CLE030
      *                                                                                       CLE030
      ** And move fields to and update the released items file - LERELEPD                     CLE030
      *                                                                                       CLE030
     C                   MOVE      RECI          RERECI                                       CLE030
     C                   MOVE      LNRF          RELNRF                                       CLE030
     C                   MOVE      PTYP          REPTYP                                       CLE030
     C                   MOVE      CNUM          RECNUM                                       CLE030
     C                   MOVE      BRCA          REBRCA                                       CLE030
     C                   MOVE      LTYP          RELTYP                                       CLE030
     C                   MOVE      SUTP          RESUTP                                       CLE030
     C                   MOVE      CLAS          RECLAS                                       CLE042
     C                   MOVE      AMTP          REAMTP                                       CLE030
     C                   MOVE      VDAT          REVDAT                                       CLE030
     C                   MOVE      FCUS          REFCUS                                       CLE030
     C                   MOVE      FTYP          REFTYP                                       CLE030
     C                   MOVE      FSEQ          REFSEQ                                       CLE030
     C                   MOVE      CCY           RECCY                                        CLE030
     C                   MOVE      PRAM          RECPAM                                       CLE030
     C                   MOVE      XUSR          REXUSR                                       CLE030
     C                   MOVE      PSUser        RERUSR                                       CLE030
     C                   MOVE      WRNDAY        RELCD                                        CLE030
     C                   MOVE      LATMST        WRLTMST                                      CLE030
     C                   MOVE      *BLANKS       WTIME             6                          CLE030
     C                   EVAL      WTIME  = WREHRS + WREMIN + WRESEC                          CLE030
     C                   MOVE      WTIME         RETIME                                       CLE030
      *                                                                                       CLE030
     C                   WRITE     LERELED0                                                   CLE030
      *                                                                                       CLE030
     C                   ENDIF                                                                CLE030
      *
      ** Pass parameter fields for shadow update
      ** Update on shadow files should only be done if not a Risk loan
     C     PTYP          IFNE      70
     C     PTYP          ANDNE     71
     C     PTYP          ANDNE     72
      *
     C     LAAMTP        IFNE      'PT'
     C     LAAMTP        ANDNE     'PF'
     C                   EXSR      SRSHAD
     C                   MOVE      Z#ADTA        Z#ADT1
     C                   MOVE      Z#ADTB        Z#ADT2
      *
     C     CEU004        IFEQ      'Y'
     C     CLE031        OREQ      'Y'                                                        CLE031
     C                   MOVE      Z#ADTE        Z#ADT5
     C                   ENDIF
                                                                                              CLE134
     C                   IF        CLE134      = 'Y'                                          CLE134
     C                   EVAL      Z#ADT8      = Z#ADTH                                       CLE134
     C                   ENDIF                                                                CLE134
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Update Loan Amend. Trailer file, LTRIX, Loans file,
      ** Facility and Shadow Files
     C     CLE134        IFEQ      'N'                                                      MD021423
     C*****MPHAS         OREQ      'A'                                             MD021423 MD025467
     C     MPHAS         ORNE      'C'                                                      MD025467
     C                   EXSR      SRTRAL
     C                   ENDIF                                                              MD021423
     C                   EXSR      SRLTRX
      *
     C     LAAMTP        IFNE      'PT'
     C     LAAMTP        ANDNE     'PF'
     C                   EXSR      SRCLON
      *                                                                                    AR1021983
     C                   IF        CLE134 = 'Y' AND                                        AR1021983
     C                             W#FRNT = 'LE000473' AND                                 AR1021983
     C                             LO_FAMU <> 'Y' AND                                      AR1021983
     C                             (LALTYP = 'Y' OR LALTYP = 'Z')                          AR1021983
      ** Skip update of facilities file                                                    AR1021983
     C                   ELSE                                                              AR1021983
     C                   EXSR      SRFCLT
     C                   ENDIF                                                             AR1021983
      *
      ** If CLE009 is installed, update fees file
     C     CLE009        IFEQ      'Y'
     C                   EXSR      SRFEES
     C                   ENDIF
                                                                                              CLE055
     C********           If        CLE055 = 'Y'  and  BPLMAU = 'Y'                     243270 243415
     C********           If        DDACTN = 'I' or  DDACTN = 'A'                       CLE055 243415
                                                                                              CLE055
      * If authorization required clear settlement deatils.                                   CLE055
     C*********          If        CLE055 = 'Y'  and  BPLMAU = 'Y'                     CLE055 243270
     C                   If        CLE055 = 'Y'  and  BPLMAU = 'Y' and                        243415
     C                             LAAUTH <> 'Y' and LAAMTP = 'PI'                            243415
                                                                                              CLE055
     C                   If        DDACTN = 'I' or  DDACTN = 'A'                              243415
     C                   Clear                   Z#ZADTA                                      CLE055
     C*********          Clear                   Z#ZADTB                               CLE055 243415
                                                                                              CLE055
     C                   Eval      Z#ZADTA   =    Z#ADT1                                      CLE055
                                                                                              CLE055
     C                   If        PONS      = OTOURS                                         CLE055
     C                   Clear                   ZA_Type                                      CLE055
     C                   Clear                   ZA_Otours                                    CLE055
     C                   Eval      Z#ADT1    =    Z#ZADTA                                     243415
     C                   Endif                                                                CLE055
     C                   Endif                                                                243270
                                                                                              CLE055
      * Authorizatin mode.                                                                    CLE055
     C     DDACTN        IFEQ      'X'                                                        243270
     C     DDACTN        OREQ      'Q'                                                        243270
     C*****DDACTN        IFEQ      'Q'                                                 CLE055 243270
     C     CLE030        ANDEQ     'Y'                                                        CLE055
     C                   Clear                   Z#ZADTA                                      243415
     C                   Eval      Z#ZADTA   =    Z#ADT1                                      CLE055
                                                                                              CLE055
     C                   If        RONS      = OTOURS                                         CLE055
     C                   Clear                   ZA_Type                                      CLE055
     C                   Clear                   ZA_Otours                                    CLE055
     C                   Eval      Z#ADT1    =    Z#ZADTA                                     243415
     C                   Endif                                                                CLE055
                                                                                              CLE055
     C                   Endif                                                                CLE055
                                                                                              CLE055
     C*********          Endif                                                         CLE055 243270
                                                                                              CLE055
     C                   Endif                                                                CLE055
                                                                                              CLE055
      *
      ** Update on shadow files should only be done if not a Risk loan
     C     PTYP          IFNE      70
     C     PTYP          ANDNE     71
     C     PTYP          ANDNE     72
     C                   EXSR      SRUSHD
     C                   ENDIF
      *
     C                   ENDIF
     C/COPY WNCPYSRC,LEH01191

      ** If support system active, write transaction to 24x7 log
     C     System        IFEQ      'S'
     C                   EXSR      APLGTR
     C                   ENDIF
      *
      ** Data export for CCRM - Limits
     C     CDE001        IFEQ      'Y'
     C                   MOVEL     LALNRF        T#TREF
     C                   CALL      'DEWTTRIG'
     C**********         PARM                    T#TREF           20                          CGL029
     C                   PARM                    T#TREF                                       CGL029
     C                   PARM      'LOAN'        T#TCAT            4
     C                   PARM                    ReservId
     C                   ENDIF
      *
      ** Perform Increase Part Sold Amount on Master Loan
     C                   EXSR      SRUPPS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSHAD  -  Retrieve parameter fields for Shadow Update        *
      *****************************************************************
     C     SRSHAD        BEGSR
      *
     C                   MOVE      RECI          SHRECI
     C                   MOVE      LNRF          SHLNRF
     C                   Z-ADD     VDAT          SHVDAT
     C                   Z-ADD     LASN          SHLASN
     C                   MOVE      PTYP          SHPTYP
     C                   MOVE      AMTP          SHAMTP
     C                   Z-ADD     RTSP          SHRTSP
     C                   MOVE      CCY           SHCCY
     C                   Z-ADD     PRAM          SHPRAM
     C                   MOVE      BRCA          SHBRCA
     C                   Z-ADD     0             SHREPT
      *
     C     WSOLD         IFEQ      'Y'
     C     PDCLI         OREQ      'Y'                                                      MD023787
     C                   MOVE      RSTM          TYPE
     C                   MOVE      RONS          OTOURS
     C                   ELSE
     C                   MOVE      PSTM          TYPE
     C                   MOVE      PONS          OTOURS
     C                   ENDIF
      *
     C                   MOVEL(P)  PIBN          THRS
     C                   MOVEL(P)  BENN          OTFACO
     C                   MOVE      *BLANK        SHINTC
      *
     C                   MOVE      OSBR          SHOSBR
     C                   MOVE      CHTP          SHCHTP
      *
     C     CEU004        IFEQ      'Y'
     C                   MOVE      SCCY          SHSCCY
     C                   MOVE      ICCY          SHICCY
     C                   ENDIF
      *
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   MOVE      SCCY          SHSCCY                                     AR943686
     C                   Z-ADD     REXR          SHREXR                                       CLE031
     C                   MOVE      REXI          SHREXI                                       CLE031
     C                   MOVE      PSCY          SHPSCY                                       CLE031
     C                   Z-ADD     PEXR          SHPEXR                                       CLE031
     C                   MOVE      PEXI          SHPEXI                                       CLE031
     C                   ENDIF                                                                CLE031
     C*                                                                                       CLE034
     C                   MOVE      STAL          SHSTAL                                       CLE034
      *
     C                   MOVE      LO_XRFI       SHXRFI                                       CLE134
     C                   MOVE      LO_XRFN       SHXRFN                                       CLE134
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRTRAL  -  Update Loan Amendments Trailer File                *
      *****************************************************************
     C     SRTRAL        BEGSR
      *
      ** Update Loan Amendments Trailer, No action for amendments
      **  (also needed for Principal Transfer amend)
     C*****LACHTP        IFEQ      'I'                                                       BUG4138
     C*****LACHTP        OREQ      'R'                                                       BUG4138
     C*****LACHTP        OREQ      'A'                                                       BUG4138
     C     DDACTN        IFEQ      'I'                                                       BUG4138
     C     DDACTN        OREQ      'R'                                                       BUG4138
     C     DDACTN        OREQ      'A'                                                       BUG4138
     C                   MOVE      '999999'      WKLNR
     C                   MOVE      '99999'       WKVDT
     C                   MOVE      '999'         WKLSN
     C                   IF        MTHREAD = 'N'                                            MD024342
     C     KLAKEY        CHAIN     LOAMD                              99
     C                   ELSE                                                               MD024342
     C                   EXSR      Initialise                                               MD024342
     C                   ENDIF                                                              MD024342
      *                                                                                    AR1021983
     C**********         IF        CLE134 = 'Y'                                   AR1021983 MD020568
     C                   IF        CLE134 = 'Y' AND                                         MD020568
     C                             W#FRNT = 'LE000473'                                      MD020568
     C                             and CobMode = 'Y'                                        MD022860
     C                   EVAL      NORE   = 1                                             AR1077027A
     C                   EVAL      NINS   = 0                                             AR1077027A
     C                   EVAL      NLRB   = 0                                             AR1077027A
     C                   EVAL      NDEL   = 0                                             AR1077027A
     C                   EVAL      NLRA   = 0                                             AR1077027A
     C                   EVAL      VLBF   = 0                                             AR1077027A
     C                   EVAL      VLBL   = 0                                             AR1077027A
     C                   EVAL      VRIF   = 0                                             AR1077027A
     C                   EVAL      VRIL   = 0                                             AR1077027A
     C                   EVAL      VRDF   = 0                                             AR1077027A
     C                   EVAL      VRDL   = 0                                             AR1077027A
     C                   EVAL      VRAF   = 0                                             AR1077027A
     C                   EVAL      VRAL   = 0                                             AR1077027A
     C                   EVAL      VRRF   = 0                                             AR1077027A
     C                   EVAL      VRRL   = 0                                             AR1077027A
     C     KLAKEY        CHAIN     LELOMKL3                           90                   AR1021983
     C                   ENDIF                                                             AR1021983
      *
     C                   IF        MTHREAD = 'N'                                            MD024342
     C     *IN99         IFEQ      '1'
     C                   MOVEL(P)  'LOAMS'       DBFILE                         ************
     C                   Z-ADD     12            DBASE                          * DBERR 12 *
     C                   MOVEL     '999999'      DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF                                                              MD024342
      *
     C*****LACHTP        IFEQ      'A'                                                       BUG4138
     C     DDACTN        IFEQ      'A'                                                       BUG4138
      *
     C     LAAMTP        IFEQ      'PT'
     C     LAAMTP        OREQ      'PF'
     C     LAAMTP        OREQ      'PI'                                                     AR580546
     C     PRAM          SUB       WPRAM         PTDIFF           13 0
      *
     C     PTDIFF        IFNE      0
     C                   MOVE      PTDIFF        ZZAMT
     C                   Z-ADD     VRAF          ZZTOTI
     C                   Z-ADD     VRAL          ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        VRAF
     C                   Z-ADD     ZZTOTD        VRAL
     C                   Z-ADD     VRRF          ZZTOTI
     C                   Z-ADD     VRRL          ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        VRRF
     C                   Z-ADD     ZZTOTD        VRRL
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Action not Amend
     C                   ELSE
      *
      ** Action not Reversal (i.e. Action Insert)
     C*****LACHTP        IFNE      'R'                                                       BUG4138
     C     DDACTN        IFNE      'R'                                                       BUG4138
      *****************************************************************             Bug03936 BUG4138
      ***Do*not*re-count*during*authorize*action.**********************             Bug03936 BUG4138
      *****************************************************************             Bug03936 BUG4138
     C*****LACHTP        IFEQ      'I'                                              Bug03936 BUG4138
     C     NORE          ADD       1             NORE
     C     NINS          ADD       1             NINS
     C     NLRA          ADD       1             NLRA
      *
     C     LAAMTP        IFEQ      'PI'
     C     LAAMTP        OREQ      'PT'
     C     LAAMTP        OREQ      'PF'
     C                   MOVE      PRAM          ZZAMT
     C                   Z-ADD     VRIF          ZZTOTI
     C                   Z-ADD     VRIL          ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        VRIF
     C                   Z-ADD     ZZTOTD        VRIL
     C                   Z-ADD     VRRF          ZZTOTI
     C                   Z-ADD     VRRL          ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        VRRF
     C                   Z-ADD     ZZTOTD        VRRL
     C                   ENDIF
      *****************************************************************             Bug03936 BUG4138
     C**********         ENDIF                                                      Bug03936 BUG4138
      *
     C                   ELSE
      *
      ** Reverse action code
      ** Need to use TAMT now, since we can reverse PDs
     C                   MOVE      TAMT          ZZAMT
     C     NDEL          ADD       1             NDEL
     C     NLRA          SUB       1             NLRA
      *
     C     LAAMTP        IFEQ      'PI'
     C     LAAMTP        OREQ      'PT'
     C     LAAMTP        OREQ      'PF'
     C     LAAMTP        OREQ      'PD'
     C                   Z-ADD     VRDF          ZZTOTI
     C                   Z-ADD     VRDL          ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        VRDF
     C                   Z-ADD     ZZTOTD        VRDL
     C                   Z-ADD     VRRF          ZZTOTI
     C                   Z-ADD     VRRL          ZZTOTD
     C                   EXSR      GLZSUB
     C                   Z-ADD     ZZTOTI        VRRF
     C                   Z-ADD     ZZTOTD        VRRL
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        MTHREAD = 'Y'                                            MD024342
     C                   Z-ADD     LATNLU        TNLU                                       MD024342
     C**********         WRITE     LOAMSZ1F                                       MD024342 MD024342B
     C**********         WRITE     LOAMSZ1FX                                      MD024342B MD025467
     C                   WRITE     LOAMSZ1F                                                 MD025467
     C                   ELSE                                                               MD024342
     C                   Z-ADD     LATNLU        TNLU
     C                   UPDATE    LOAMSZ1F
     C                   ENDIF                                                              MD024342
      *                                                                                    AR1021983
      ** Update loan amendments trailer file                                               AR1021983
      *                                                                                    AR1021983
     C                   IF        CLE134 = 'Y' AND                                        AR1021983
     C                             W#FRNT = 'LE000473'                                      MD020568
     C                             and CobMode = 'Y'                                        MD022860
     C**********                   (W#FRNT = 'LE000473' OR                        AR1021983 MD020568
     C**********                   W#FRNT = *BLANKS)                              AR1021983 MD020568
     C                   IF        *IN90 = *ON                                             AR1021983
     C                   WRITE     LOMKSZ1F                                                AR1021983
     C                   ELSE                                                              AR1021983
     C                   UPDATE    LOMKSZ1F                                                AR1021983
     C                   ENDIF                                                             AR1021983
     C                   ENDIF                                                             AR1021983
      *                                                                                    AR1021983
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRLTRX  -  Update Loan Transaction Index Detail (LTRIX)       *
      *****************************************************************
     C     SRLTRX        BEGSR
      *
      ** Update LTRIX if amendment type is PI, PT or PF only, and action
      ** is authorisation or reversal
     C     LAAMTP        IFEQ      'PI'
     C*****LACHTP        ANDEQ     'X'                                                      BUG13325
     C     DDACTN        ANDEQ     'X'                                                      BUG13325
     C     BPLMAU        ANDEQ     'Y'
      *
     C     LAAMTP        OREQ      'PI'
     C*****LACHTP        ANDEQ     'I'                                                      BUG13325
     C     DDACTN        ANDEQ     'I'                                                      BUG13325
     C     BPLMAU        ANDEQ     'N'
      *
     C     LAAMTP        OREQ      'PI'
     C*****LACHTP        ANDEQ     'A'                                                      BUG13325
     C     DDACTN        ANDEQ     'A'                                                      BUG13325
     C     BPLMAU        ANDEQ     'N'
      *
     C     LAAMTP        OREQ      'PT'
     C*****LACHTP        ANDEQ     'X'                                                      BUG13325
     C     DDACTN        ANDEQ     'X'                                                      BUG13325
     C     BPTPAU        ANDEQ     'Y'
      *
     C     LAAMTP        OREQ      'PT'
     C*****LACHTP        ANDEQ     'I'                                                      BUG13325
     C     DDACTN        ANDEQ     'I'                                                      BUG13325
     C     BPTPAU        ANDEQ     'N'
      *
     C     LAAMTP        OREQ      'PT'
     C*****LACHTP        ANDEQ     'A'                                                      BUG13325
     C     DDACTN        ANDEQ     'A'                                                      BUG13325
     C     BPTPAU        ANDEQ     'N'
      *
     C     LAAMTP        OREQ      'PF'
     C*****LACHTP        ANDEQ     'X'                                                      BUG13325
     C     DDACTN        ANDEQ     'X'                                                      BUG13325
     C     BPTPAU        ANDEQ     'Y'
      *
     C     LAAMTP        OREQ      'PF'
     C*****LACHTP        ANDEQ     'I'                                                      BUG13325
     C     DDACTN        ANDEQ     'I'                                                      BUG13325
     C     BPTPAU        ANDEQ     'N'
      *
     C     LAAMTP        OREQ      'PF'
     C*****LACHTP        ANDEQ     'A'                                                      BUG13325
     C     DDACTN        ANDEQ     'A'                                                      BUG13325
     C     BPTPAU        ANDEQ     'N'
      *
     C     LAAMTP        OREQ      'PI'
     C*****LACHTP        ANDEQ     'R'                                                      BUG13325
     C     DDACTN        ANDEQ     'R'                                                      BUG13325
     C     BPLMAU        ANDEQ     'Y'
     C     LAXUSR        ANDNE     *BLANK
      *
     C     LAAMTP        OREQ      'PI'
     C*****LACHTP        ANDEQ     'R'                                                      BUG13325
     C     DDACTN        ANDEQ     'R'                                                      BUG13325
     C     BPLMAU        ANDEQ     'N'
      *
     C     LAAMTP        OREQ      'PT'
     C*****LACHTP        ANDEQ     'R'                                                      BUG13325
     C     DDACTN        ANDEQ     'R'                                                      BUG13325
     C     BPTPAU        ANDEQ     'Y'
     C     LAXUSR        ANDNE     *BLANK
      *
     C     LAAMTP        OREQ      'PT'
     C*****LACHTP        ANDEQ     'R'                                                      BUG13325
     C     DDACTN        ANDEQ     'R'                                                      BUG13325
     C     BPTPAU        ANDEQ     'N'
      *
     C     LAAMTP        OREQ      'PF'
     C*****LACHTP        ANDEQ     'R'                                                      BUG13325
     C     DDACTN        ANDEQ     'R'                                                      BUG13325
     C     BPTPAU        ANDEQ     'Y'
     C     LAXUSR        ANDNE     *BLANK
      *
     C     LAAMTP        OREQ      'PF'
     C*****LACHTP        ANDEQ     'R'                                                      BUG13325
     C     DDACTN        ANDEQ     'R'                                                      BUG13325
     C     BPTPAU        ANDEQ     'N'
      *
     C     LAPCOB        ORNE      *BLANKS
     C     LAAMTP        ANDEQ     'PI'
      *
     C******IN98         DOUEQ     '0'                                                      AR322732
     C*****RECI*         ANDEQ     *BLANK                                                   AR322732
     C******IN99         OREQ      '1'                                                      AR322732
      *
     C**********         Z-ADD     1             LXRRN             5 0                      AR322732
      *
      ** Access LTRIX header
     C*****LXRRN         CHAIN(N)  LTRIX                              99                    AR322732
      *
     C******IN99         IFEQ      '0'                                                      AR322732
      *
     C*****RECI*         IFEQ      'H'                                                      AR322732
      *
     C*****RRNA*         IFGT      FLSZ                                                     AR322732
     C**********         MOVE      '1'           *INU8                                      AR322732
     C**********         ENDIF                                                              AR322732
      *
     C**********         ELSE                                                               AR322732
     C**********         MOVE      *ON           *IN99                                      AR322732
     C**********         ENDIF                                                              AR322732
      *
     C**********         ENDIF                                                              AR322732
      *
     C******IN99         IFEQ      *ON                                                      AR322732
     C******INU8         OREQ      *ON                                                      AR322732
     C**********         MOVEL     'LTRIX   '    DBFILE                         ************AR322732
     C**********         Z-ADD     13            DBASE                          * DBERR 13 *AR322732
     C**********         MOVEL     LXRRN         DBKEY                          ************AR322732
     C**********         EXSR      *PSSR                                                    AR322732
     C**********         ENDIF                                                              AR322732
      *
     C**********         MOVE      RRNA          LXRRN                                      AR322732
      *
     C*****LXRRN         CHAIN     LTRIX                              9998                  AR322732
      *
     C******IN98         IFEQ      '1'                                                      AR322732
      *
     C*****TXSTS         IFEQ      1218                                                     AR322732
     C**********         UNLOCK    LTRIX                                                    AR322732
     C**********         ELSE                                                               AR322732
     C**********         MOVE      '1'           *IN99                                      AR322732
     C**********         ENDIF                                                              AR322732
      *
     C**********         ENDIF                                                              AR322732
      *
     C**********         ENDDO                                                              AR322732
      *
     C******IN99         IFEQ      '1'                                                      AR322732
     C**********         MOVEL     'LTRIX   '    DBFILE                         ************AR322732
     C**********         Z-ADD     14            DBASE                          * DBERR 14 *AR322732
     C**********         MOVEL     LXRRN         DBKEY                          ************AR322732
     C**********         EXSR      *PSSR                                                    AR322732
     C**********         ENDIF                                                              AR322732
      *
     C                   Z-ADD     0             PRI1
      *
      ** Check settlement type
     C     LASETP        IFEQ      01
     C     LASETP        OREQ      02
     C     LASETP        OREQ      07
     C     LASETP        OREQ      08
     C     LASETP        OREQ      12
      *
      ** Obtain lowest telex notice days between loan & local CCY
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      LACCY         @Curr             3
     C     SDCURR        PARM                    DSSDY
      *
     C     @RtCd         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   Z-ADD     15            DBASE                          * DBERR 15 *
     C                   MOVEL     LACCY         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Default to local CCY for telex notice calculation
     C                   Z-ADD     TNOTL         ZNRDYS
     C                   Z-ADD     WRNDAY        ZDAYNO
     C                   MOVE      BJLCCY        ZCCY
      *
      ** For settlement types 01, 07, & 08 use loan currency instead
     C     LASETP        IFEQ      01
     C     LASETP        OREQ      07
     C     LASETP        OREQ      08
     C                   Z-ADD     A6TXND        ZNRDYS
     C                   MOVE      LACCY         ZCCY
     C                   ENDIF
      *
     C                   CALLB     'ZFWDT'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZNRDYS            2 0
     C                   PARM      *ZERO         ZDYNBR            5 0
     C                   PARM                    ZCCY              3
     C                   PARM      *BLANKS       ZLOC              3
      *
     C     LAVDAT        IFLE      ZDYNBR
     C     LAVDAT        ANDGE     WRNDAY
     C                   Z-ADD     1             PRI1
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Interactive mode - if action is authorise and amendment
      ** status is complete, then for LTRIX purposes should be
      ** treated as an insert regardless of whether last change type
      ** is insert or amend, since it can never have been authorised
      ** previously (and hence never appeared on LTRIX)
     C*****LACHTP        IFEQ      'X'                                                      BUG13325
     C     DDACTN        IFEQ      'X'                                                      BUG13325
     C     LAASTS        ANDEQ     'C'
     C                   MOVE      'I'           CHTP
     C                   ELSE
     C                   MOVE      LACHTP        CHTP
     C                   ENDIF
      *
      ** Update LTRIX detail record
     C                   Z-ADD     0             RRNA              5 0                      AR322732
     C                   EXCEPT    LTRIXD
      *
      ** Get header record
     C**********         Z-ADD     1             LXRRN                                      AR322732
     C*****LXRRN         CHAIN     LTRIX                              99                    AR322732
      *
     C******IN99         IFEQ      '1'                                                      AR322732
     C**********         MOVEL     'LTRIX   '    DBFILE                         ************AR322732
     C**********         Z-ADD     16            DBASE                          * DBERR 16 *AR322732
     C**********         MOVEL     LXRRN         DBKEY                          ************AR322732
     C**********         EXSR      *PSSR                                                    AR322732
     C**********         ENDIF                                                              AR322732
      *
      ** Update relevant control fields
     C*****NORE*         ADD       1             NORE                                       Bug03936
     C*****NORELX        ADD       1             NORELX                            Bug03936 AR322732
     C*****RRNA*         ADD       1             RRNA                                       AR322732
     C*****NLAR*         ADD       1             NLAR                                       AR322732
      *
     C**********         EXCEPT    LTRIXH                                                   AR322732
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCLON  -  Update Customer Loans Detail                       *
      *****************************************************************
     C     SRCLON        BEGSR
      *
      ** Update CLOAN file to unlink Loan to syndication and
      ** Consolidated confirmation
     C     LACHTP        IFEQ      'I'
     C     LACHTP        OREQ      'R'
     C                   MOVE      LALNRF        WKLNR
     C                   MOVE      'A'           WRCDT
     C     KLKEY         CHAIN     CLOAN                              99
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'CLOAN   '    DBFILE                         ************
     C                   Z-ADD     17            DBASE                          * DBERR 17 *
     C                   MOVEL     WKLNR         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     BPCONR        IFEQ      'Y'
     C                   MOVE      'N'           LO_CNCF
     C                   ELSE
     C                   MOVE      *BLANK        LO_CNCF
     C                   ENDIF
      *
     C     LACHTP        IFEQ      'I'                                                      AR547813
     C     LAAMTP        ANDEQ     'BC'                                                     AR547813
     C*****LABRTT        IFNE      *ZERO                                             AR547813 CSD103
     C     LABRTT        IFNE      *BLANKS                                                    CSD103
     C     LO_CHIN       ANDEQ     *BLANK                                                   AR547813
     C     PTYPA         IFEQ      63                                                       AR547813
     C     PTYPA         OREQ      65                                                       AR547813
     C     PTYPA         OREQ      67                                                       AR547813
     C     PTYPA         OREQ      72                                                       AR547813
     C     PTYPA         OREQ      80                                                       AR547813
     C     CLE028        ANDEQ     'Y'                                                      AR547813
     C                   MOVE      'N'           LO_CHIN                                    AR547813
     C                   ELSE                                                               AR547813
     C                   MOVE      'D'           LO_CHIN                                    AR547813
     C                   ENDIF                                                              AR547813
     C                   ENDIF                                                              AR547813
     C                   ENDIF                                                              AR547813
      *                                                                                     AR547813
     C     LACHTP        IFEQ      'R'                                                      AR547813
     C     LAAMTP        ANDEQ     'BC'                                                     AR547813
     C*****LO_BRTT       ANDEQ     *ZERO                                             AR547813 CSD103
     C     LO_BRTT       ANDEQ     *BLANKS                                                    CSD103
     C                   MOVE      *BLANK        LO_CHIN                                    AR547813
     C                   ENDIF                                                              AR547813
      *                                                                                     AR547813
     C                   UPDATE    CLOANCLF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFCLT  -  Update Facility File                               *
      *****************************************************************
     C     SRFCLT        BEGSR
      *
     C                   MOVE      'N'           WPART             1
     C                   MOVE      LO_LPFI       WLPFI             1
      *
      ** Update Facility for type 'PI', for Insert and Reverse only
     C     LACHTP        IFEQ      'I'
     C     LAAMTP        ANDEQ     'PI'
      *
     C     LACHTP        OREQ      'R'
     C     LAAMTP        ANDEQ     'PI'
      *
     C                   MOVEL     FCUSC         WFCNM
     C                   MOVEL     FTYPC         WFACT
     C                   MOVEL     FSEQC         WFNUM
     C                   MOVE      'A'           WFRTP
     C     KFCLT         CHAIN(N)  FCLTY                              99
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'FCLTY   '    DBFILE                         ************
     C                   Z-ADD     18            DBASE                          * DBERR 18 *
     C                   MOVEL     FCLKEY        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * Get loan amendment currency details
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      LACCY         @Curr
     C     SDCURR        PARM                    DSSDY
      *
     C     @RtCd         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   Z-ADD     19            DBASE                          * DBERR 19 *
     C                   MOVEL     LACCY         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Save loan currency details.
     C     CLE023        IFEQ      'Y'
     C                   MOVE      LACCY         WCCYL             3
     C                   Z-ADD     A6SPRT        WSPRTL           13 8
     C                   MOVE      A6MDIN        WMDINL            1
     C                   Z-ADD     A6NBDP        WCDPL             1 0
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        CDPL              1 0
      *
      * Get facility currency details
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      FA_FCCY       @Curr
     C     SDCURR        PARM                    DSSDY
      *
     C     @RtCd         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   Z-ADD     20            DBASE                          * DBERR 20 *
     C                   MOVEL     FA_FCCY       DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Save facility currency details.
     C     CLE023        IFEQ      'Y'
     C                   MOVE      FA_FCCY       WCCYF             3
     C                   Z-ADD     A6SPRT        WSPRTF           13 8
     C                   MOVE      A6MDIN        WMDINF            1
     C                   Z-ADD     A6NBDP        WCDPF             1 0
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        CDPF              1 0
      *
     C                   MOVEL     FCUSC         WFCNM
     C                   MOVEL     FTYPC         WFACT
     C                   MOVEL     FSEQC         WFNUM
     C                   MOVE      'B'           WFRTP
     C     KFCLT         CHAIN     FCLTY                              99
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'FCLTY   '    DBFILE                         ************
     C                   Z-ADD     21            DBASE                          * DBERR 21 *
     C                   MOVEL     FCLKEY        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      *BLANK        WTRCA
     C                   MOVE      *BLANKS       WKSWRI
     C                   IF        CLE134 = 'Y'                                             AR656363
     C                   EVAL      WUpdExpo = 'Y'                                           AR656363
     C                   EXSR      SrPDCLPI                                                 AR656363
     C                   ENDIF                                                              AR656363
                                                                                            AR656363
     C                   EXSR      FCLTSR
      *
     C                   IF        CLE025 = 'N'                                               CLE025
     C                   Eval      FA_OAM1 =  FB_OAM1
     C                   Eval      FA_OAM2 =  FB_OAM2
     C                   Eval      FA_OAM3 =  FB_OAM3
     C                   Eval      FA_OAM4 =  FB_OAM4
     C                   Eval      FA_OAM5 =  FB_OAM5
     C                   Eval      FA_OAM6 =  FB_OAM6
     C                   Eval      FA_OAM7 =  FB_OAM7
     C                   Eval      FA_OAM8 =  FB_OAM8
     C                   Eval      FA_OAM9 =  FB_OAM9
     C                   Eval      FA_OA10 =  FB_OA10
     C                   ENDIF                                                                CLE025

     C                   Z-ADD     WRNDAY        LCD
     C                   MOVE      'A'           CHTP
     C                   Z-ADD     LATNLU        TNLU
      *
     C                   UPDATE    FCLTYFNF
      *
     C     FA_TRCA       IFEQ      'TR'
     C     CLE005        ANDEQ     'Y'
     C                   EXSR      SRUPCA
     C                   ENDIF
      *
      ** Update also Participant's facility if a Participant or Internal
      ** facility
     C     WLPFI         IFNE      *BLANK
     C*****WLPFI         ANDNE     'R'                                                        CLE106
     C                   MOVE      'Y'           WPART             1
     C                   MOVEL     LO_PTFC       WFCNM
     C                   MOVEL     LO_PTFT       WFACT
     C                   MOVEL     LO_PTFN       WFNUM
     C                   MOVE      'A'           WFRTP
     C     KFCLT         CHAIN(N)  FCLTY                              99
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'FCLTY   '    DBFILE                         ************
     C                   Z-ADD     22            DBASE                          * DBERR 22 *
     C                   MOVEL     FCLKEY        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      FA_FCCY       @Curr
     C     SDCURR        PARM                    DSSDY
      *
     C     @RtCd         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   Z-ADD     23            DBASE                          * DBERR 23 *
     C                   MOVEL     FA_FCCY       DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Save currency details.
     C     CLE023        IFEQ      'Y'
     C                   MOVE      FA_FCCY       WCCYF
     C                   Z-ADD     A6SPRT        WSPRTF
     C                   MOVE      A6MDIN        WMDINF
     C                   Z-ADD     A6NBDP        WCDPF
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        CDPF              1 0
     C                   MOVE      'B'           WFRTP
     C     KFCLT         CHAIN     FCLTY                              99
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'FCLTY   '    DBFILE                         ************
     C                   Z-ADD     24            DBASE                          * DBERR 24 *
     C                   MOVEL     FCLKEY        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        CLE134 = 'Y'                                             AR656363
     C                   EVAL      WUpdExpo = 'Y'                                           AR656363
     C                   EXSR      SrPDCLPI                                                 AR656363
     C                   ENDIF                                                              AR656363
                                                                                            AR656363
     C                   EXSR      FCLTSR
      *
     C                   IF        CLE025 = 'N'                                               CLE025
     C                   Eval      FA_OAM1 =  FB_OAM1
     C                   Eval      FA_OAM2 =  FB_OAM2
     C                   Eval      FA_OAM3 =  FB_OAM3
     C                   Eval      FA_OAM4 =  FB_OAM4
     C                   Eval      FA_OAM5 =  FB_OAM5
     C                   Eval      FA_OAM6 =  FB_OAM6
     C                   Eval      FA_OAM7 =  FB_OAM7
     C                   Eval      FA_OAM8 =  FB_OAM8
     C                   Eval      FA_OAM9 =  FB_OAM9
     C                   Eval      FA_OA10 =  FB_OA10
     C                   ENDIF                                                                CLE025

     C                   Z-ADD     WRNDAY        LCD
     C                   MOVE      'A'           CHTP
     C                   Z-ADD     LATNLU        TNLU
      *
     C                   UPDATE    FCLTYFNF
      *
     C     FA_TRCA       IFEQ      'TR'
     C     CLE005        ANDEQ     'Y'
     C                   EXSR      SRUPCA
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT                                                                                AR656363
      *****************************************************************                     AR656363
      * SRPDCLPI Check if loan has FAMU N/Y                           *                     AR656363
      *****************************************************************                     AR656363
     C     SRPDCLPI      BEGSR                                                              AR656363
                                                                                            AR656363
      ** Proceed only if Amendment Type is PI and for Interest(Y) or Fee(Z)                 AR656363
                                                                                            AR656363
     C     DDATYP        IFEQ      'PI'                                                     AR656363
     C     AUTOC         ANDEQ     'C'                                                      AR656363
     C                   IF        %SUBST(LTYPA:1:1) =  'Y'  and                            AR656363
     C                             LO_FAMU = 'N' OR                                         AR656363
     C                             %SUBST(LTYPA:1:1) =  'Z'  and                            AR656363
     C                             LO_FAMU = 'N'                                            AR656363
     C                   EVAL      WUpdExpo='N'                                             AR656363
     C                   ENDIF                                                              AR656363
     C                   ENDIF                                                              AR656363
                                                                                            AR656363
     C                   ENDSR                                                              AR656363
      *****************************************************************
      /EJECT
      *****************************************************************
      * FCLTSR  -  Evaluate Facility Exposure                         *
      *****************************************************************
     C     FCLTSR        BEGSR
      *
      ** Convert amounts in facility currency equivalent
     C     WTRCA         IFEQ      *BLANK
     C     CDPF          SUB       CDPL          CX                1 0
     C     CX            ADD       4             CX
      *
     C     LO_FMDI       COMP      'D'                                    92
      *
     C   92LO_FCXR       DIV(H)    POWR(CX)      OFCXRT
     C   921             DIV       OFCXRT        OFCXRT
     C  N92LO_FCXR       MULT(H)   POWR(CX)      OFCXRT           15 9
      *
      ** If CLE023 is ON, get cross rate of currencies spot.
     C     CLE023        IFEQ      'Y'
     C                   CALLB     'ZXRATE'
     C                   PARM      WSPRTL        ZRATE1           13 8
     C                   PARM      WMDINL        ZMDI1             1
     C                   PARM      WSPRTF        ZRATE2           13 8
     C                   PARM      WMDINF        ZMDI2             1
     C                   PARM                    ZRATEX           13 8
     C                   PARM                    ZMDIX             1

     C                   MOVE      WCCYL         ZCCYI
     C                   MOVE      WCCYF         ZCCYO
     C                   MOVE      WCDPL         ZCDPI
     C                   MOVE      WCDPF         ZCDPO
     C                   Z-ADD     ZRATEX        ZEXCH
     C                   MOVE      ZMDIX         ZMD
     C                   ENDIF

     C     DDACTN        IFEQ      'I'
     C     LAPRAM        MULT(H)   OFCXRT        ILAAMF           13 0
      *
      ** If CLE023 is ON convert amounts using spot rate.
     C     CLE023        IFEQ      'Y'
     C                   Z-ADD     LAPRAM        ZAMTCI
     C                   CALLB     'ZCONVZ1'
     C                   PARM                    ZAMTCI           15 0
     C                   PARM                    ZEXCH            13 8
     C                   PARM                    ZMD               1
     C                   PARM                    ZCCYI             3
     C                   PARM                    ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
     C                   PARM                    ZAMTCO           15 0
     C                   Z-ADD     ZAMTCO        WXAAMF           13 0
      *
      ** If rollover date is less than or equal to the value date of
      ** the amendment and there is a rollover of facility exchange
      ** rate, use the new facility exchange rate defined.
     C     LO_RLDT       IFLT      WRNDAY
     C     LO_RLDT       ANDNE     0
     C     LO_NFCE       ANDNE     0
     C     LO_NCCY       ANDEQ     *BLANKS
     C     LO_NFMD       IFEQ      'D'
     C     LO_NFCE       DIV(H)    POWR(CX)      WNFCE            15 9
     C     1             DIV       WNFCE         WNFCE
     C                   ELSE
     C     LO_NFCE       MULT(H)   POWR(CX)      WNFCE
     C                   ENDIF
     C     LAPRAM        MULT(H)   WNFCE         ILAAMF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
     C     DDACTN        IFEQ      'R'
     C     PRAM          MULT(H)   OFCXRT        ILAAMF
      *
      ** If CLE023 is ON convert amount using spot rate.
     C     CLE023        IFEQ      'Y'
     C                   Z-ADD     PRAM          ZAMTCI
     C                   CALLB     'ZCONVZ1'
     C                   PARM                    ZAMTCI           15 0
     C                   PARM                    ZEXCH            13 8
     C                   PARM                    ZMD               1
     C                   PARM                    ZCCYI             3
     C                   PARM                    ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
     C                   PARM                    ZAMTCO           15 0
     C                   Z-ADD     ZAMTCO        WXAAMF
      *
      ** If rollover date is less than or equal to the value date of
      ** the amendment and there is a rollover of facility exchange
      ** rate, use the new facility exchange rate defined.
     C     LO_RLDT       IFLT      WRNDAY
     C     LO_RLDT       ANDNE     0
     C     LO_NFCE       ANDNE     0
     C     LO_NCCY       ANDEQ     *BLANKS
     C     LO_NFMD       IFEQ      'D'
     C     LO_NFCE       DIV(H)    POWR(CX)      WNFCE
     C                   ELSE
     C     LO_NFCE       MULT(H)   POWR(CX)      WNFCE
     C                   ENDIF
     C     PRAM          MULT(H)   WNFCE         ILAAMF
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF
      *
      ** Set up fields for value date updating
      ** Also update availability of a prime facility without recourse
     C                   Z-ADD     LAVDAT        DAYNO             5 0
      *
     C     LACHTP        IFEQ      'I'
      *
     C     WSOLD         IFEQ      *BLANK
     C     WLPFI         ANDEQ     *BLANK
      *
     C     WPART         OREQ      'Y'
     C                   MOVE      '0'           *IN93
     C                   ELSE
     C                   MOVE      '1'           *IN93
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     LACHTP        IFEQ      'R'
      *
     C     WSOLD         IFEQ      *BLANK
     C     WLPFI         ANDEQ     *BLANK
      *
     C     WPART         OREQ      'Y'
     C                   MOVE      '1'           *IN93
     C                   ELSE
     C                   MOVE      '0'           *IN93
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   IF        CLE134 = 'Y'   AND                                       AR656363
     C                             WUpdExpo= 'Y'   OR                                       AR656363
     C                             CLE134 = 'N'                                             AR656363
     C                   Z-ADD     ILAAMF        FCBAL            13 0
     C                   ELSE                                                               AR656363
     C                   Z-ADD     0             ILAAMF                                     AR656363
     C                   Z-ADD     0             FCBAL                                      AR656363
     C                   Z-ADD     0             WXAAMF                                     AR656363
     C                   ENDIF                                                              AR656363
      *
      * Load arrays
     C                   Eval      FB_RUN0 =  FA_RUN0
     C                   Eval      FB_RUN1 =  FA_RUN1
     C                   Eval      FB_RUN2 =  FA_RUN2
     C                   Eval      FB_RUN3 =  FA_RUN3
     C                   Eval      FB_RUN4 =  FA_RUN4
     C                   Eval      FB_RUN5 =  FA_RUN5
     C                   Eval      FB_RUN6 =  FA_RUN6
     C                   Eval      FB_RUN7 =  FA_RUN7
     C                   Eval      FB_RUN8 =  FA_RUN8
     C                   Eval      FB_RUN9 =  FA_RUN9

     C                   IF        CLE025 = 'N'                                               CLE025
     C                   Eval      FB_OAM1 =  FA_OAM1
     C                   Eval      FB_OAM2 =  FA_OAM2
     C                   Eval      FB_OAM3 =  FA_OAM3
     C                   Eval      FB_OAM4 =  FA_OAM4
     C                   Eval      FB_OAM5 =  FA_OAM5
     C                   Eval      FB_OAM6 =  FA_OAM6
     C                   Eval      FB_OAM7 =  FA_OAM7
     C                   Eval      FB_OAM8 =  FA_OAM8
     C                   Eval      FB_OAM9 =  FA_OAM9
     C                   Eval      FB_OA10 =  FA_OA10
     C                   ENDIF                                                                CLE025
      *
     C     WPART         IFEQ      'Y'
      *
     C     WLPFI         OREQ      *BLANK
     C     WSOLD         ANDEQ     'Y'
     C     RCSIC         ANDNE     'Y'
      *
     C     WLPFI         OREQ      *BLANK
     C     WSOLD         ANDEQ     *BLANK
     C     DDACTN        ANDNE     'X'                                                        243275
     C                   EXSR      QFCLTY
     C                   ENDIF
      *
      ** Reverse exposure update procedure for:
      ** Prime facility - if Participant is Internal (for Parts Purch)
      ** or participant is parts sold
      ** Participant facility - for Parts Sold
      ** Update prime facility only when recourse N, like a part sold
      ** Internal and funding participants should be updated like a
      ** normal loan
      ** Non-syndicated loans would be updated as they currently are
     C     LAVDAT        IFLE      WRNDAY
      *
     C     PTYPA         IFEQ      66
     C     WLPFI         ANDEQ     *BLANK
      *
     C     PTYPA         OREQ      69
     C     WLPFI         ANDEQ     *BLANK
     C     CLE005        ANDEQ     'Y'
      *
     C     PTYPA         OREQ      67
     C     WLPFI         ANDEQ     *BLANK
      *
     C     CLE005        OREQ      'Y'
     C     WLPFI         ANDEQ     *BLANK
     C     PTYPA         ANDEQ     72
     C     WSPTYP        ANDEQ     66
      *
     C     CLE005        OREQ      'Y'
     C     WLPFI         ANDEQ     *BLANK
     C     PTYPA         ANDEQ     72
     C     WSPTYP        ANDEQ     67
      *
     C     CLE005        OREQ      'Y'
     C     WLPFI         ANDEQ     *BLANK
     C     PTYPA         ANDEQ     72
     C     WSPTYP        ANDEQ     69
      *
     C     WPART         OREQ      'N'
     C     WLPFI         ANDEQ     'I'
     C     PTYPA         ANDEQ     64
      *
     C     WPART         OREQ      'N'
     C     WLPFI         ANDEQ     'I'
     C     PTYPA         ANDEQ     65
      *
     C     WPART         OREQ      'N'
     C     WLPFI         ANDEQ     'P'
     C     PTYPA         ANDEQ     66
      *
     C     WPART         OREQ      'N'
     C     WLPFI         ANDEQ     'P'
     C     PTYPA         ANDEQ     69
     C     CLE005        ANDEQ     'Y'
      *
     C     WPART         OREQ      'N'
     C     WLPFI         ANDEQ     'P'
     C     PTYPA         ANDEQ     67
      *
     C     CLE005        OREQ      'Y'
     C     WPART         ANDEQ     'N'
     C     WLPFI         ANDEQ     'P'
     C     PTYPA         ANDEQ     72
     C     WSPTYP        ANDEQ     66
      *
     C     CLE005        OREQ      'Y'
     C     WPART         ANDEQ     'N'
     C     WLPFI         ANDEQ     'P'
     C     PTYPA         ANDEQ     72
     C     WSPTYP        ANDEQ     67
      *
     C     CLE005        OREQ      'Y'
     C     WPART         ANDEQ     'N'
     C     WLPFI         ANDEQ     'P'
     C     PTYPA         ANDEQ     72
     C     WSPTYP        ANDEQ     69
      *
     C     PTYPA         IFEQ      66
     C     RCSIC         ANDNE     'Y'
     C     WLPFI         ANDEQ     *BLANK
      *
     C     PTYPA         OREQ      67
     C     RCSIC         ANDNE     'Y'
     C     WLPFI         ANDEQ     *BLANK
      *
     C     PTYPA         OREQ      69
     C     RCSIC         ANDNE     'Y'
     C     WLPFI         ANDEQ     *BLANK
     C     CLE005        ANDEQ     'Y'
      *
     C     CLE005        OREQ      'Y'
     C     RCSIC         ANDNE     'Y'
     C     PTYPA         ANDEQ     72
     C     WSPTYP        ANDEQ     66
     C     WLPFI         ANDEQ     *BLANK
      *
     C     CLE005        OREQ      'Y'
     C     RCSIC         ANDNE     'Y'
     C     PTYPA         ANDEQ     72
     C     WSPTYP        ANDEQ     67
     C     WLPFI         ANDEQ     *BLANK
      *
     C     CLE005        OREQ      'Y'
     C     RCSIC         ANDNE     'Y'
     C     PTYPA         ANDEQ     72
     C     WSPTYP        ANDEQ     69
     C     WLPFI         ANDEQ     *BLANK
      *
     C     PTYPA         OREQ      66
     C     RCSIC         ANDNE     'Y'
     C     WLPFI         ANDEQ     'P'
     C     WPART         ANDEQ     'N'
      *
     C     PTYPA         OREQ      67
     C     RCSIC         ANDNE     'Y'
     C     WLPFI         ANDEQ     'P'
     C     WPART         ANDEQ     'N'
      *
     C     PTYPA         OREQ      69
     C     CLE005        ANDEQ     'Y'
     C     RCSIC         ANDNE     'Y'
     C     WLPFI         ANDEQ     'P'
     C     WPART         ANDEQ     'N'
      *
     C     PTYPA         OREQ      72
     C     CLE005        ANDEQ     'Y'
     C     RCSIC         ANDNE     'Y'
     C     WLPFI         ANDEQ     'P'
     C     WPART         ANDEQ     'N'
      *                                                                                       CLE106
     C     WPART         OREQ      'N'                                                        CLE106
     C     WLPFI         ANDEQ     'S'                                                        CLE106
     C     PTYPA         ANDEQ     66                                                         CLE106
      *                                                                                       CLE106
     C     WPART         OREQ      'N'                                                        CLE106
     C     WLPFI         ANDEQ     'S'                                                        CLE106
     C     PTYPA         ANDEQ     67                                                         CLE106
      *                                                                                       CLE106
     C     WPART         OREQ      'N'                                                        CLE106
     C     WLPFI         ANDEQ     'S'                                                        CLE106
     C     PTYPA         ANDEQ     69                                                         CLE106
      *                                                                                       CLE106
     C     WPART         OREQ      'N'                                                        CLE106
     C     WLPFI         ANDEQ     'S'                                                        CLE106
     C     PTYPA         ANDEQ     72                                                         CLE106
     C     WSPTYP        ANDEQ     66                                                         CLE106
      *                                                                                       CLE106
     C     WPART         OREQ      'N'                                                        CLE106
     C     WLPFI         ANDEQ     'S'                                                        CLE106
     C     PTYPA         ANDEQ     72                                                         CLE106
     C     WSPTYP        ANDEQ     67                                                         CLE106
      *                                                                                       CLE106
     C     WPART         OREQ      'N'                                                        CLE106
     C     WLPFI         ANDEQ     'S'                                                        CLE106
     C     PTYPA         ANDEQ     72                                                         CLE106
     C     WSPTYP        ANDEQ     69                                                         CLE106
      *                                                                                       CLE106
     C     WPART         OREQ      'N'                                                        CLE106
     C     WLPFI         ANDEQ     'R'                                                        CLE106
     C     PTYPA         ANDEQ     66                                                         CLE106
      *                                                                                       CLE106
     C     WPART         OREQ      'N'                                                        CLE106
     C     WLPFI         ANDEQ     'R'                                                        CLE106
     C     PTYPA         ANDEQ     72                                                         CLE106
      *                                                                                       243275
     C     DDACTN        IFNE      'X'                                                        243275
      *
     C     LACHTP        IFEQ      'I'
     C     CLE023        ANDEQ     'N'
     C     CLE025        ANDEQ     'N'                                                        CLE025
     C     FA_CAMD       SUB       ILAAMF        FA_CAMD
     C                   ENDIF
      *
     C     LACHTP        IFEQ      'R'
     C     CLE023        ANDEQ     'N'
     C     CLE025        ANDEQ     'N'                                                        CLE025
     C     FA_CAMD       ADD       ILAAMF        FA_CAMD
     C                   ENDIF
      *
      ** If CLE023 is on, update Current Exposure based on spot rate.
     C     CLE023        IFEQ      'Y'
     C     CLE025        ANDEQ     'N'                                                        CLE025
     C     LACHTP        IFEQ      'I'
     C     FA_CEXP       SUB       WXAAMF        FA_CEXP
     C                   ENDIF
     C     LACHTP        IFEQ      'R'
     C     FA_CEXP       ADD       WXAAMF        FA_CEXP
     C                   ENDIF
     C                   ENDIF
      *                                                                                       243275
     C                   ENDIF                                                                243275
      *
      ** If CLE009 is installed, set Work Regeneration Indicator to
      ** changed
     C     CLE009        IFEQ      'Y'
     C                   MOVE      'C'           WKSWRI            1
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C     PTYPA         IFEQ      66
      *
     C     PTYPA         OREQ      67
      *
     C     PTYPA         OREQ      69
     C     CLE005        ANDEQ     'Y'
      *
     C     CLE005        OREQ      'Y'
     C     RCSIC         ANDNE     'Y'
     C     PTYPA         ANDEQ     72
     C     WSPTYP        ANDEQ     66
      *
     C     CLE005        OREQ      'Y'
     C     RCSIC         ANDNE     'Y'
     C     PTYPA         ANDEQ     72
     C     WSPTYP        ANDEQ     67
      *
     C     CLE005        OREQ      'Y'
     C     RCSIC         ANDNE     'Y'
     C     PTYPA         ANDEQ     72
     C     WSPTYP        ANDEQ     69
      *
     C     PTYPA         ORNE      66
     C     PTYPA         ANDNE     67
     C     PTYPA         ANDNE     69
     C     PTYPA         ANDNE     72
      *                                                                                       CLE106
     C     WPART         OREQ      'N'                                                        CLE106
     C     WLPFI         ANDEQ     'S'                                                        CLE106
     C     PTYPA         ANDEQ     66                                                         CLE106
     C     RCSIC         ANDNE     'Y'                                                        CLE106
      *                                                                                       CLE106
     C     WPART         OREQ      'N'                                                        CLE106
     C     WLPFI         ANDEQ     'S'                                                        CLE106
     C     PTYPA         ANDEQ     67                                                         CLE106
     C     RCSIC         ANDNE     'Y'                                                        CLE106
      *                                                                                       CLE106
     C     WPART         OREQ      'N'                                                        CLE106
     C     WLPFI         ANDEQ     'S'                                                        CLE106
     C     PTYPA         ANDEQ     69                                                         CLE106
     C     RCSIC         ANDNE     'Y'                                                        CLE106
      *                                                                                       CLE106
     C     WPART         OREQ      'N'                                                        CLE106
     C     WLPFI         ANDEQ     'S'                                                        CLE106
     C     PTYPA         ANDEQ     72                                                         CLE106
     C     RCSIC         ANDNE     'Y'                                                        CLE106
      *                                                                                       CLE106
     C     WPART         OREQ      'N'                                                        CLE106
     C     WLPFI         ANDEQ     'R'                                                        CLE106
     C     PTYPA         ANDEQ     72                                                         CLE106
     C     RCSIC         ANDNE     'Y'                                                        CLE106
      *                                                                                       243275
     C     DDACTN        IFNE      'X'                                                        243275
      *
     C     LACHTP        IFEQ      'I'
     C     CLE025        ANDEQ     'N'                                                        CLE025
     C     FA_CAMD       ADD       ILAAMF        FA_CAMD
     C                   ENDIF
      *
     C     LACHTP        IFEQ      'R'
     C     CLE025        ANDEQ     'N'                                                        CLE025
     C     FA_CAMD       SUB       ILAAMF        FA_CAMD
     C                   ENDIF
      *
      ** If CLE023 is on, update current exposure based on spot rate.
     C     CLE023        IFEQ      'Y'
     C     CLE025        ANDEQ     'N'                                                        CLE025
     C     LACHTP        IFEQ      'I'
     C     FA_CEXP       ADD       WXAAMF        FA_CEXP
     C                   ENDIF
     C     LACHTP        IFEQ      'R'
     C     FA_CEXP       SUB       WXAAMF        FA_CEXP
     C                   ENDIF
     C                   ENDIF
      *                                                                                       243275
     C                   ENDIF                                                                243275
      *
      ** If CLE009 is installed, set Work Regeneration Indicator to
      ** changed
     C     CLE009        IFEQ      'Y'
     C                   MOVE      'C'           WKSWRI            1
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Also update availability of a prime facility without recourse
     C     FA_RVCR       IFEQ      'Y'
     C                   Z-ADD     LO_MDAT       DAYNO
      *
     C     LACHTP        IFEQ      'I'
      *
     C     WSOLD         IFEQ      *BLANK
     C     WLPFI         ANDEQ     *BLANK
      *
     C     WPART         OREQ      'Y'
     C                   MOVE      '1'           *IN93
     C                   ELSE
     C                   MOVE      '0'           *IN93
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     LACHTP        IFEQ      'R'
      *
     C     WSOLD         IFEQ      *BLANK
     C     WLPFI         ANDEQ     *BLANK
      *
     C     WPART         OREQ      'Y'
     C                   MOVE      '0'           *IN93
     C                   ELSE
     C                   MOVE      '1'           *IN93
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   Z-ADD     ILAAMF        FCBAL
      *
     C     DAYNO         IFNE      0
      *
     C     WPART         IFEQ      'Y'
      *
     C     WLPFI         OREQ      *BLANK
     C     WSOLD         ANDEQ     'Y'
     C     RCSIC         ANDNE     'Y'
     C     CLE023        ANDEQ     'N'
      *
     C     WLPFI         OREQ      *BLANK
     C     WSOLD         ANDEQ     *BLANK
     C     DDACTN        ANDNE     'X'                                                        243275
     C                   EXSR      QFCLTY
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ENDFAC        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUPCA  -  Update of credit agreement/superfacility           *
      *****************************************************************
     C     SRUPCA        BEGSR
      *
      ** Save the revolving credit indicator of the tranche
     C     CLE014        IFEQ      'Y'
     C                   MOVE      FA_RVCR       WRVCR             1
     C                   ENDIF
      *
      ** Whenever the facility utilisation is updated for a tranche,
      ** update the credit agreement/superfacility as well
     C                   MOVE      FA_FCCY       WTCCY             3
     C                   MOVEL     FA_CANM       WFCNM
     C                   MOVEL     FA_CAFT       WFACT
     C                   MOVEL     FA_CAFN       WFNUM
     C                   MOVE      'A'           WFRTP
      *
     C                   MOVE      FA_CMDI       WCMDI             1
     C                   Z-ADD     FA_CAXR       WCAXR            13 8
      *
     C     KFCLT         CHAIN(N)  FCLTY                              99
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'FCLTY   '    DBFILE                         ************
     C                   Z-ADD     25            DBASE                          * DBERR 25 *
     C                   MOVEL     FCLKEY        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      'B'           WFRTP
     C     KFCLT         CHAIN     FCLTY                              99
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'FCLTY   '    DBFILE                         ************
     C                   Z-ADD     26            DBASE                          * DBERR 26 *
     C                   MOVEL     FCLKEY        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If tranche and superfacility currencies are different, get
      ** superfacility currency details
     C     WTCCY         IFNE      FA_FCCY
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM      FA_FCCY       @Curr
     C     SDCURR        PARM                    DSSDY
      *
     C     @RtCd         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   Z-ADD     27            DBASE                          * DBERR 27 *
     C                   MOVEL     FA_FCCY       DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Save superfacility currency details and obtain the cross exchange rate.
     C     CLE023        IFEQ      'Y'
     C                   MOVE      WCCYF         ZCCYI
     C                   Z-ADD     WSPRTF        ZRATE1
     C                   MOVE      WMDINF        ZMDI1
     C                   Z-ADD     WCDPF         ZCDPI
     C                   MOVE      FA_FCCY       ZCCYO
     C                   Z-ADD     A6SPRT        ZRATE2
     C                   MOVE      A6MDIN        ZMDI2
     C                   MOVE      A6NBDP        ZCDPO

     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1
     C                   PARM                    ZMDI1
     C                   PARM                    ZRATE2
     C                   PARM                    ZMDI2
     C                   PARM                    ZRATEX
     C                   PARM                    ZMDIX
     C                   Z-ADD     ZRATEX        ZEXCH
     C                   MOVE      ZMDIX         ZMD
     C                   ENDIF
      *
      ** Convert facility amount to credit facility currency
     C                   Z-ADD     A6NBDP        CDPC              1 0
     C     CDPC          SUB       CDPF          CX
     C     CX            ADD       4             CX
      *
     C     WCMDI         IFEQ      'D'
     C     WCAXR         DIV(H)    POWR(CX)      OFCXRT
     C     1             DIV       OFCXRT        OFCXRT
     C                   ELSE
     C     WCAXR         MULT(H)   POWR(CX)      OFCXRT
     C                   ENDIF
      *
     C     FCBAL         MULT(H)   OFCXRT        ILAAMF           13 0
      *
      ** If CLE023 is ON convert amount using spot rate.
     C     CLE023        IFEQ      'Y'
     C                   Z-ADD     WXAAMF        ZAMTCI
     C                   CALLB     'ZCONVZ1'
     C                   PARM                    ZAMTCI           15 0
     C                   PARM                    ZEXCH            13 8
     C                   PARM                    ZMD               1
     C                   PARM                    ZCCYI             3
     C                   PARM                    ZCCYO             3
     C                   PARM                    ZCDPI             1 0
     C                   PARM                    ZCDPO             1 0
     C                   PARM                    ZAMTCO           15 0
      *
     C                   Z-ADD     ZAMTCO        WXAAMF
     C                   ENDIF
     C                   ENDIF
      *
      ** Restore the revolving credit indicator
     C     CLE014        IFEQ      'Y'
     C     FA_RVCR       ANDEQ     'T'
     C                   MOVE      WRVCR         FA_RVCR
     C                   ENDIF
      *
      ** Update facility exposure and availability
     C                   MOVE      'Y'           WTRCA             1
     C                   IF        CLE134 = 'Y'                                             AR656363
     C                   EVAL      WUpdExpo = 'Y'                                           AR656363
     C                   EXSR      SrPDCLPI                                                 AR656363
     C                   ENDIF                                                              AR656363
                                                                                            AR656363
     C                   EXSR      FCLTSR
      *
     C                   IF        CLE025 = 'N'                                               CLE025
     C                   Eval      FA_OAM1 =  FB_OAM1
     C                   Eval      FA_OAM2 =  FB_OAM2
     C                   Eval      FA_OAM3 =  FB_OAM3
     C                   Eval      FA_OAM4 =  FB_OAM4
     C                   Eval      FA_OAM5 =  FB_OAM5
     C                   Eval      FA_OAM6 =  FB_OAM6
     C                   Eval      FA_OAM7 =  FB_OAM7
     C                   Eval      FA_OAM8 =  FB_OAM8
     C                   Eval      FA_OAM9 =  FB_OAM9
     C                   Eval      FA_OA10 =  FB_OA10
     C                   ENDIF                                                                CLE025

     C                   Z-ADD     WRNDAY        LCD
     C                   MOVE      'A'           CHTP
     C                   Z-ADD     LATNLU        TNLU
     C                   UPDATE    FCLTYFNF
     C                   MOVE      *BLANK        WTRCA
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * QFCLTY  -  Update Exposure Array                              *
      *****************************************************************
     C     QFCLTY        BEGSR
      *
     C     DAYNO         IFNE      0
     C                   Z-ADD     1             Z                 2 0
     C     DAYNO         LOOKUP    FB_RUN(Z)                          92  92
     C  N92              GOTO      ENDFCT
      *
     C     LOOPZ1        TAG
      *
     C     Z             COMP      11                                   92
      *
      ** Don't update beyond the expiry date
     C     *IN92         IFEQ      *ON
     C     FB_RUN(Z)     ANDGE     FA_DTEX
     C                   GOTO      ENDFCT
     C                   ENDIF
      *
     C  N92              GOTO      ENDFCT
      *
     C                   IF        CLE025 = 'N'                                               CLE025
     C   93FB_OAM(Z)     SUB       FCBAL         FB_OAM(Z)
     C  N93FB_OAM(Z)     ADD       FCBAL         FB_OAM(Z)
     C                   ENDIF                                                                CLE025
      *
      ** If CLE009 is installed, set Work Regeneration Indicator to
      ** changed
     C     CLE009        IFEQ      'Y'
     C                   MOVE      'C'           WKSWRI            1
     C                   ENDIF
      *
     C     Z             ADD       1             Z
     C                   GOTO      LOOPZ1
     C                   ENDIF
      *
     C     ENDFCT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFEES  -  Update Fees File                                   *
      *****************************************************************
     C     SRFEES        BEGSR
      *
      ** If authorisation switchable feature is on and action code
      ** is insert or amend and Loans amendment authorisations is
      ** required
     C     CLE002        IFEQ      'Y'
     C     LACHTP        ANDNE     'X'
     C     LACHTP        ANDNE     'R'
     C     BPLMAU        ANDEQ     'Y'
      *
      ** If action code is insert
      *
     C     LACHTP        IFEQ      'I'
      *
      ** Write a record to Loan Amendment Fee Index File
     C                   MOVE      LALNRF        FFLNRF
     C                   Z-ADD     LAVDAT        FFVDAT
     C                   MOVE      LALASN        FFLASN
     C                   MOVE      *BLANKS       FFAUTH
     C                   MOVE      WKSWRI        FFSWRI
     C                   WRITE     LEFELAD0
     C                   ENDIF
      *
      ** If action code is amend
     C     LACHTP        IFEQ      'A'
      *
      ** Chain to Loan Amendment Fee Index File
     C                   MOVE      LALNRF        WKLOAN
     C                   Z-ADD     LAVDAT        WKDAY
     C                   MOVE      LALASN        WKSEQN
     C     KIDXF         CHAIN     LEFELAL0                           99
      *
      ** If record not found
     C     *IN99         IFEQ      *ON
      *
      ** Write a record to Loan Fee Index File
     C                   MOVE      LALNRF        FFLNRF
     C                   Z-ADD     LAVDAT        FFVDAT
     C                   MOVE      LALASN        FFLASN
     C                   MOVE      'Y'           FFAUTH
     C                   MOVE      WKSWRI        FFSWRI
     C                   WRITE     LEFELAD0
     C                   ELSE
      *
      ** If work regeneration indicator is changed and regeneration
      ** indicator is blank
     C     WKSWRI        IFEQ      'C'
     C     FFSWRI        ANDEQ     *BLANKS
      *
      ** Update the record to Loan Amendment Fee Index File
     C                   MOVE      WKSWRI        FFSWRI
     C                   UPDATE    LEFELAD0
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If action code is authorise
     C     LACHTP        IFEQ      'X'
      *
      ** Chain to Loan Amendment Fee Index File
     C                   MOVE      LALNRF        WKLOAN
     C                   Z-ADD     LAVDAT        WKDAY
     C                   MOVE      LALASN        WKSEQN
     C     KIDXF         CHAIN     LEFELAL0                           99
      *
      ** If record is found
     C     *IN99         IFEQ      *OFF
      *
      ** Update the record to Loan Amendment Fee Index File
     C                   MOVE      FFSWRI        WKSWRI
     C                   MOVE      'Y'           FFAUTH
     C                   UPDATE    LEFELAD0
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If action code is reverse
     C     LACHTP        IFEQ      'R'
      *
      ** Chain to Loan Amendment Fee Index File
     C                   MOVE      LALNRF        WKLOAN
     C                   Z-ADD     LAVDAT        WKDAY
     C                   MOVE      LALASN        WKSEQN
     C     KIDXF         CHAIN     LEFELAL0                           99
      *
      ** If record is found
     C     *IN99         IFEQ      *OFF
      *
      ** If authorised is blank
     C     FFAUTH        IFEQ      *BLANKS
     C                   MOVE      *BLANKS       WKSWRI
     C                   ELSE
      *
      ** If work regeneration indicator is blank
     C     WKSWRI        IFEQ      *BLANKS
     C                   MOVE      FFSWRI        WKSWRI
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If work regeneration indicator is changed
     C     WKSWRI        IFEQ      'C'
      *
      ** Check if the facility has an associated fee
     C                   MOVE      WFACT         CHFACT            3
     C                   MOVE      WFNUM         CHFCNO            2
     C     CHFACT        CAT       CHFCNO        CHFACL            5
     C                   MOVE      CHFACL        WFFACL
     C**********         Z-ADD     0             WFLOAN                                       CLE148
     C                   MOVEL     *BLANKS       WFLOAN                                       CLE148
     C     WKFEE         SETLL     LEFEEDL1
     C*****WKFEE         READE     LEFEEDL1                               99                MD023203
     C     WKFEE         READE (N) LEFEEDL1                               99                MD023203
      *
      ** Do while an associated fee exists
     C     *IN99         DOWEQ     *OFF
      *
     C                   MOVE      FEAUTO        WFEAUT            1                          CLE134
     C     CLE134        IFEQ      'Y'                                                        CLE134
     C     WFEAUT        IFEQ      'C'                                                        CLE134
     C     FEAUT2        OREQ      'C'                                                        CLE134
     C                   MOVE      'Y'           WFEAUT            1                          CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ** If the fee is a confirmed calculated fee and swift
      ** regeneration indicator is not 'I', 'B', 'H'
     C*****FEAUTO        IFEQ      'Y'                                                        CLE134
     C     WFEAUT        IFEQ      'Y'                                                        CLE134
     C     FECALT        ANDNE     *BLANKS
     C     FESWRI        ANDNE     'I'
     C     FESWRI        ANDNE     'B'
     C     FESWRI        ANDNE     'H'
      *
      ** Set currency to fee currency
      ** Set day to run date
      ** Set number of working days to telex notice days
     C                   MOVE      FEFCCY        ZCCY
     C                   Z-ADD     WRNDAY        ZDAYNO
     C                   Z-ADD     1             X
      *                                                                                     MD054317
      ** If CLE031 is on then use correct currency to access AONOSTR0                       MD054317
      *                                                                                     MD054317
     C                   MOVE      FEFCCY        WKCCY             3                        MD054317
      *                                                                                     MD054317
     C     CLE031        IFEQ      'Y'                                                      MD054317
      *                                                                                     MD054317
     C     PTFI          IFEQ      'P'                                                      MD054317
     C     FEPSCY        IFNE      *BLANKS                                                  MD054317
     C                   MOVE      FEPSCY        WKCCY                                      MD054317
     C                   ENDIF                                                              MD054317
     C                   ELSE                                                               MD054317
     C     FESCCY        IFNE      *BLANKS                                                  MD054317
     C                   MOVE      FESCCY        WKCCY                                      MD054317
     C                   ENDIF                                                              MD054317
     C                   ENDIF                                                              MD054317
      *                                                                                     MD054317
     C                   ENDIF                                                              MD054317
      *                                                                                     MD054317
     C                   MOVE      WKCCY         ZCCY                                       MD054317
     C                   MOVE      WKCCY         @CURR                                      MD054317
      *                                                                                     MD054317
     C*****FEFCCY        LOOKUP    CYA(X)                                 69                MD054317
     C     WKCCY         LOOKUP    CYA(X)                                 69                MD054317
     C                   MOVE      *OFF          *IN69
     C                   MOVE      TND(X)        ZNRDYS
      *
      ** If Fee Settlement type is '01', '02', '07', '08' or '12'
     C     FESTTL        IFEQ      01
     C     FESTTL        OREQ      02
     C     FESTTL        OREQ      07
     C     FESTTL        OREQ      08
     C     FESTTL        OREQ      12
      *
     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    @Cusn             6
     C**********         PARM      FEFCCY        @Curr             3                        MD054317
     C                   PARM                    @Curr             3                        MD054317
     C**********         PARM                    @Accd             4                          CGL029
     C                   PARM                    @Accd                                        CGL029
     C                   PARM                    @Acsn             2
     C                   PARM      FEOURS        @Nonb             2
     C                   PARM                    @Brca             3
     C                   PARM                    @Cssn            10
     C                   PARM                    @Pnoi             1
     C     SDNOST        PARM                    DSFDY
      *
     C     @RtCd         IFNE      *BLANKS
     C                   MOVEL     'AONOSTR0'    DBFILE                         ************
     C                   Z-ADD     28            DBASE                          * DBERR 28 *
     C                   MOVEL     FEFCCY        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ELSE
      *
      ** Set Location to Nostro Location
     C                   MOVE      A7NOSN        ZLOC
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVE      *BLANKS       ZLOC
      *
     C                   ENDIF
      *
      ** Calculate number of working days forward
     C                   CALLB     'ZFWDT'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZNRDYS            2 0
     C                   PARM      *ZERO         ZDYNBR            5 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
      *
      ** Set Telex Notice date to day number
     C                   Z-ADD     ZDYNBR        TXDT              5 0
      *                                                                                     MD023203
     C                   MOVEL     FECNUM        WFCNUMX                                    MD023203
     C                   MOVEL     FEFACL        WFFACLX                                    MD023203
     C                   MOVEL     FELOAN        WFLOANX                                    MD023203
     C                   MOVEL     FEFSEQ        WFSEQNX                                    MD023203
      *
      ** If next payment date is before or equals to Telex Notice date
      ** and Next Payment Telex indicator is set to 'Y'
     C     FENPYD        IFLE      TXDT
     C     FEPPTI        ANDEQ     'Y'
      *
      ** Update Fees file
     C     WKFEEX        CHAIN     LEFEEDL0                                                 MD023203
     C                   IF        %FOUND(LEFEEDL0)                                         MD023203
     C**********         MOVE      'A'           FESWRI                                     MD023203
     C**********         UPDATE    LEFEEDF                                                  MD023203
     C                   MOVE      'A'           X_FESWRI                                   MD023203
     C                   UPDATE    LEFEEDX                                                  MD023203
     C                   ENDIF                                                              MD023203
     C                   ELSE
      *
      ** If end date is before or equals to Telex Notice date and End
      ** Telex indicator is set to 'Y'
     C     FEPEND        IFLE      TXDT
     C     FEEPTI        ANDEQ     'Y'
      *
      ** Update Fees file
     C     WKFEEX        CHAIN     LEFEEDL0                                                 MD023203
     C                   IF        %FOUND(LEFEEDL0)                                         MD023203
     C**********         MOVE      'A'           FESWRI                                     MD023203
     C**********         UPDATE    LEFEEDF                                                  MD023203
     C                   MOVE      'A'           X_FESWRI                                   MD023203
     C                   UPDATE    LEFEEDX                                                  MD023203
     C                   ENDIF                                                              MD023203
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C*****WKFEE         READE     LEFEEDL1                               99                MD023203
     C     WKFEE         READE (N) LEFEEDL1                               99                MD023203
     C                   ENDDO
      *                                                                                       CLE073
      ** Check if the loan has an associated fee                                              CLE073
      *                                                                                       CLE073
     C                   IF        CLE073 = 'Y' AND                                           CLE073
     C                             LAAMTP = 'PI' OR                                           CLE073
     C                             CLE073 = 'Y' AND                                           CLE073
     C                             LAAMTP = 'PD'                                              CLE073
     C                   EXSR      CHKLON                                                     CLE073
     C                   ENDIF                                                                CLE073
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       WKSWRI
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUSHD  -  Update Shadow Record                               *
      *****************************************************************
     C     SRUSHD        BEGSR
      *                                                                                     MD026167
     C                   IF        MPHAS = 'C'                                              MD026167
     C                   LEAVESR                                                            MD026167
     C                   ENDIF                                                              MD026167
      *
      ** Do On-line updates
     C*****LACHTP        IFEQ      'I'                                                       BUG8566
     C*****LACHTP        OREQ      'A'                                                       BUG8566
     C*****LACHTP        OREQ      'R'                                                       BUG8566
     C     DDACTN        IFEQ      'I'                                                       BUG8566
     C     DDACTN        OREQ      'A'                                                       BUG8566
     C     DDACTN        OREQ      'R'                                                       BUG8566
     C     LACHTP        OREQ      'X'                                                        243415
     C     CLE055        andeq     'Y'                                                        243415
     C     LAAMTP        andeq     'PI'                                                       243415
     C     BPLMAU        andeq     'Y'                                                        243415
     C     LACHTP        OREQ      'Q'                                                        243415
     C     CLE030        andeq     'Y'                                                        243415
     C     CLE055        andeq     'Y'                                                        243415
     C     LAAMTP        andeq     'PI'                                                       243415
     C     BPLMAU        andeq     'Y'                                                        243415
     C     DDACTN        OREQ      'X'                                                     AR1035362
     C     CLE055        andeq     'Y'                                                     AR1035362
     C     LAAMTP        andeq     'PI'                                                    AR1035362
     C     BPLMAU        andeq     'Y'                                                     AR1035362
      *                                                                                     MD047554
     C                   EVAL      OLNRF = LALNRF                                           MD047554
     C                   EVAL      OVDAT = SHVDAT                                           MD047554
     C                   EVAL      OLASN = SHLASN                                           MD047554
     C                   EVAL      OMPRAM = PRAM                                            MD047554
      *
     C     LAAMTP        IFEQ      'PI'
      *
     C     LAPCOB        IFNE      *BLANKS
     C                   MOVE      '*LEBTCH'     @RtCd
     C                   ELSE
     C                   MOVE      *BLANKS       @RtCd
     C                   ENDIF
     **********                                                                        CLE055 243415
      **If*authorization required:                                                     CLE055 243415
     C*********          If        CLE055 = 'Y'  and  BPLMAU = 'Y'                     CLE055 243415
     C*********          Eval      Z#BSTS = Z#ZADTB                                    CLE055 243415
     C*********          Eval      Z#ASTS = Z#ZADTA                                    CLE055 243415
     C*********          Endif                                                         CLE055 243415
      *
     C                   CALL      'AOOULAU0'
     C                   PARM                    @RtCd
     C                   PARM                    Z#BSTS
     C                   PARM                    Z#ASTS
     C                   PARM                    Z#WSTS
     C                   PARM                    PDCLI                                      MD023787
      *                                                                                     AR868380
     C     @RTCD         IFEQ      '*RECLCK'                                                AR868380
     C                   MOVEL     '*RECLCK'     @@RTCD                                     AR868380
     C                   GOTO      EXIT                                                     AR868380
     C                   ENDIF                                                              AR868380
      *
     C     @RtCd         IFEQ      '*ERROR*'
     C                   MOVEL     'AOOULAU0'    DBFILE                         ************
     C                   Z-ADD     29            DBASE                          * DBERR 29 *
     C                   MOVEL     @RtCd         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Create shadow posting of Interest and Maturity during                              MD047554
      ** insert, reversal, or amendment of amount                                           MD047554
      *                                                                                     MD047554
     C     DDACTN        IFEQ      'I'                                                      MD047554
     C     DDACTN        OREQ      'A'                                                      MD047554
     C     OPRAM         ANDNE     PRAM                                                     MD047554
     C     DDACTN        OREQ      'R'                                                      MD047554
     C                   CALL      'LE2041  '                                               MD047554
     C                   PARM                    OLNRF             6                        MD047554
     C                   PARM                    OVDAT             5 0                      MD047554
     C                   PARM                    OLASN             3 0                      MD047554
     C                   PARM                    OMPRAM           13 0                      MD047554
     C                   PARM                    DDATYP                                     MD047554
     C                   PARM                    DDACTN                                     MD047554
     C                   PARM                    OPRAM            13 0                      MD047554
     C                   PARM      *BLANKS       @RTCD                                      MD047554
     C                   ENDIF                                                              MD047554
      *                                                                                     MD047554
     C                   ENDIF
      *
     C                   MOVEL     SHLNRF        OLNRF                                        264065
     C                   MOVEL     SHVDAT        OVDAT                                        264065
     C                   MOVEL     SHLASN        OLASN                                        264065
     C                   MOVEL     SHPRAM        OMPRAM                                       264065
      *                                                                                     MD047554
     C                   IF        DDATYP <> 'PI'                                           MD047554
      *                                                                                     MD047554
     C                   IF        LAPCOB <> *BLANKS                                        MD047554
     C                   EVAL      @RTCD = '*LEBTCH'                                        MD047554
     C                   ELSE                                                               MD047554
     C                   EVAL      @RTCD = *BLANKS                                          MD047554
     C                   ENDIF                                                              MD047554
      *                                                                                     MD047554
     C                   EVAL      OPRAM = *ZERO                                            MD047554
      *                                                                                     MD047554
     C                   CALL      'LE2041  '                                                 264065
     C**********         PARM                    OLNRF             6 0               264065 MD047554
     C                   PARM                    OLNRF             6                        MD047554
     C                   PARM                    OVDAT             5 0                        264065
     C                   PARM                    OLASN             3 0                        264065
     C                   PARM                    OMPRAM           13 0                        264065
     C                   PARM                    AMTP                                         264065
     C                   PARM                    DDACTN                                       264065
     C                   PARM                    OPRAM                                      MD047554
     C                   PARM      *BLANKS       @RTCD                                      AR868380
                                                                                              264065
     C     @RTCD         IFEQ      '*RECLCK'                                                AR868380
     C                   MOVEL     '*RECLCK'     @@RTCD                                     AR868380
     C                   GOTO      EXIT                                                     AR868380
     C                   ENDIF                                                              AR868380
     C                   ENDIF                                                              MD047554
     C                   ENDIF
     C/COPY WNCPYSRC,LEH01192
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *  APLGTR  -  Write Loan Amendment transaction to the 24x7 Midas*
      *             availability Log File                             *
      *****************************************************************
     C     APLGTR        BEGSR
      *
      ** Format the transaction layout
      ** Note that, as the fields of the LOAMSDK record may have been overlaid
      ** during the other database updates, the valid file record is passed to
      ** LELOAMLOG. However, its format and values are the same as those of LOAMSDK
     C                   CALLB     'LELOAMLOG'
     C                   PARM      *BLANKS       RetCodeIn
     C                   PARM                    DDACTN
     C                   PARM                    ValidLoam

      * Date format indicator
     C                   PARM                    BJDFIN
     C                   PARM                    TransDtl
     C                   PARM                    ValidLoam                                    CRE073
      *
      ***  Write to support database log file
     C     RetCodeIn     IFEQ      *BLANKS
      *
     C                   EVAL      APTGTTYPE = 'LELOAM'
     C                   EVAL      APUSERID = PSUser
     C                   MOVEL     LAFRNT        APFOTRANID
     C**********         EVAL      PDEALNO = %Char(LALNRF) + %Char(LAVDAT) +                  CLE148
     C                   EVAL      PDEALNO = LALNRF + %Char(LAVDAT) +                         CLE148
     C                                       %Char(LALASN)
      *
     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeIn
     C                   PARM                    APHEAD
     C                   PARM                    TransDtl
     C                   PARM      *BLANKS       WTimeStamp       26
     C**********         PARM                    PDEALNO          18                          CGL029
     C**********         PARM      *BLANKS       PADEALNO         18                          CGL029
     C                   PARM                    PDEALNO                                      CGL029
     C                   PARM      *BLANKS       PADEALNO                                     CGL029
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUPPS   - Update Part Sold amount for Assignments            *
      *****************************************************************
     C     SRUPPS        BEGSR
      *
     C**********         Z-ADD     0             WKLNR                                        CLE148
     C                   MOVEL     *BLANKS       WKLNR                                        CLE148
     C                   EVAL      WrkUpdFlag = *BLANK                                      BUG10604
      *
      ** Only process if assignment flag is set
     C     LAGASS        IFEQ      'A'
      *
      ** Access Loans file using loan number
      *
     C                   MOVE      LALNRF        WKLNR
     C                   MOVE      'A'           WRCDT
     C     KLKEY         CHAIN(N)  CLOAN                              99
      *
     C     *IN99         IFEQ      *OFF
     C**********         Z-ADD     0             WKLNR                                        CLE148
     C                   MOVEL     *BLANKS       WKLNR                                        CLE148
      *
      ** If Mirror number not blank i.e. Loan is Part Purchased, access
      ** loans file using this number for main loan details
     C*****LO_MLNR       IFNE      *ZERO                                                      CLE148
     C     LO_MLNR       IFNE      *BLANKS                                                    CLE148
     C                   MOVE      LO_MLNR       WKLNR
     C     KLKEY         CHAIN     CLOAN                              99
     C                   ELSE
      *
      ** If Loan is Part Sold, Mirror Loan no will be blank so use LO_OLNO
      ** as key to access main loan details
     C     WSOLD         IFEQ      'Y'
     C                   MOVE      LO_OLNO       WKLNR
     C     KLKEY         CHAIN     CLOAN                              99
     C                   ELSE
     C                   MOVE      *ON           *IN99
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     *IN99         IFEQ      *OFF
      *
      ** If action code is 'I' add principal amount to total sold
      ** amount
     C     LACHTP        IFEQ      'I'
     C     LO_PSAM       ADD       LAPRAM        LO_PSAM
     C                   ENDIF
      *
      ** If action code is 'A' subtract original principal amount
      ** accessed from LOAMSDK and add amended principal amount.
     C     LACHTP        IFEQ      'A'
     C     LO_PSAM       SUB       WPRAM         LO_PSAM
     C     LO_PSAM       ADD       LAPRAM        LO_PSAM
     C                   ENDIF
      *
      ** Update Amended Part Sold amount on Loan Master File
     C                   UPDATE    CLOANCLF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVE      'N'           WPARTS            1
     C                   MOVE      '1'           *IN99
      *
      ** If principal transfer transaction, update LO_PSAM
     C     LAAMTP        IFEQ      'PF'
     C     LAAMTP        OREQ      'PT'
     C                   MOVE      LALNRF        WKLNR
     C                   MOVE      'A'           WRCDT
     C     KLKEY         CHAIN(N)  CLOAN                              99
     C                   EVAL      WrkUpdFlag = 'N'                                         BUG10604
      *
     C     *IN99         IFEQ      '0'
      *
      ** Check if loan is a parts sold or a parts purchased
     C     WSOLD         IFEQ      'Y'
     C*****LO_MLNR       ORNE      0                                                          CLE148
     C     LO_MLNR       ORNE      *BLANKS                                                    CLE148
      *
     C*****LO_MLNR       IFNE      0                                                          CLE148
     C     LO_MLNR       IFNE      *BLANKS                                                    CLE148
     C                   MOVE      LO_MLNR       WKLNR
     C                   ELSE
     C                   MOVE      LO_OLNO       WKLNR
     C                   ENDIF
      *
     C     KLKEY         CHAIN     CLOAN                              99
     C                   MOVE      'Y'           WPARTS
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Insert
     C     WPARTS        IFEQ      'Y'
     C     *IN99         ANDEQ     '0'
     C     DDACTN        ANDNE     'X'                                                     BUG10655R
      *
     C     LACHTP        IFEQ      'I'
      *
      ** Subtract transfer amount from sold amount of the original
      ** loan if 'PF' else add if 'PT'
     C     LAAMTP        IFEQ      'PF'
     C                   SUB       LAPRAM        LO_PSAM
     C                   ELSE
     C                   ADD       LAPRAM        LO_PSAM
     C                   ENDIF
      *
      ** Update Sold Amount
     C                   UPDATE    CLOANCLF
     C                   EVAL      WrkUpdFlag = 'Y'                                         BUG10604
     C                   ENDIF
      *
      ** Amendment/Reverse
     C     LACHTP        IFEQ      'A'
     C     LACHTP        OREQ      'R'
      *
      ** For 'PF' restore the sold amount of the original loan. If amend
      ** subtract the transfer amount to the restored amount.
     C     LAAMTP        IFEQ      'PF'
      *
     C     LACHTP        IFEQ      'A'
     C                   ADD       WPRAM         LO_PSAM
     C                   SUB       LAPRAM        LO_PSAM
     C                   ELSE
     C                   ADD       WPRAM         LO_PSAM
     C                   ENDIF
      *
     C                   ELSE
      *
      ** For PT, restore the sold amount of the original loan. If amend
      ** add the transfer amount to the restored amount.
     C     LACHTP        IFEQ      'A'
     C                   SUB       WPRAM         LO_PSAM
     C                   ADD       LAPRAM        LO_PSAM
     C                   ELSE
     C                   SUB       WPRAM         LO_PSAM
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Update Sold Amount
     C                   UPDATE    CLOANCLF
     C                   EVAL      WrkUpdFlag = 'Y'                                         BUG10604
     C                   ENDIF
      *
     C                   ENDIF
                                                                                            BUG10604
     C                   IF        WrkUpdFlag = 'N'                                         BUG10604
     C                   UNLOCK    CLOAN                                                    BUG10604
     C                   ENDIF                                                              BUG10604
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRINIT - Initialisation for each call to this module          *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @Return           6
     C                   PARM                    @Type             1
      *
      ** Set *RTV module parameter ModeofOp to *FRONT if the pgm is running
      ** in batch or called from the repair or java browser modules.
     C                   IF        @Type  = '0' or
     C                             CallModCod = 'RPR'
     C                   EVAL      ModeofOp = '*FRONT'
     C                   ELSE
     C                   EVAL      ModeofOp = *BLANKS
     C                   ENDIF
      *
      ** Move selected action and run date to last changed fields
     C*******************MOVE      DDACTN        LACHTP                         213280
     C                   MOVE      WRNDAY        LALCD
      *
      ** Set up a flag for parts sold
     C                   MOVE      *BLANK        WSOLD             1
      *
     C*****PTYPA         IFEQ      66                                                         243270
     C*****PTYPA         OREQ      67                                                         243270
     C*****PTYPA         OREQ      69                                                         243270
     C*****CLE005        ANDEQ     'Y'                                                        243270
     C*****PTYPA         OREQ      72                                                         243270
     C*****CLE005        ANDEQ     'Y'                                                        243270
     C     LAPTYP        IFEQ      66                                                         243270
     C     LAPTYP        OREQ      67                                                         243270
     C     LAPTYP        OREQ      69                                                         243270
     C     CLE005        ANDEQ     'Y'                                                        243270
     C     LAPTYP        OREQ      72                                                         243270
     C     CLE005        ANDEQ     'Y'                                                        243270
     C                   MOVE      'Y'           WSOLD
     C                   ENDIF
      *
      ** For type 72 get processing type of loan sold
     C                   Z-ADD     0             WSPTYP            2 0
      *
     C     PTYPA         IFEQ      72
     C     CLE005        ANDEQ     'Y'
      *
     C**********         Z-ADD     LO_OLNO       WKLNR                                        CSD027
     C                   Move      LO_OLNO       WKLNR                                        CSD027
     C                   MOVE      'A'           WRCDT
     C     KLKEY         CHAIN     CLOANCLF                           99
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'CLOAN   '    DBFILE                         ************
     C                   Z-ADD     31            DBASE                          * DBERR 31 *
     C                   MOVEL     WKLNR         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PTYPA         IFEQ      63
     C     PTYPA         OREQ      65
     C                   Z-ADD     67            WSPTYP
     C                   ENDIF
      *
     C     PTYPA         IFEQ      62
     C     PTYPA         OREQ      64
     C                   Z-ADD     66            WSPTYP
     C                   ENDIF
      *
     C     PTYPA         IFEQ      61
     C     PTYPA         OREQ      68
     C                   Z-ADD     69            WSPTYP
     C                   ENDIF
      *
     C     PTYPA         IFEQ      70
     C     PTYPA         OREQ      71
     C                   Z-ADD     70            WSPTYP
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                     AR547813
     C                   CALLB     'AOSARDR0'                                               AR547813
     C                   PARM      *BLANKS       PRtCd                                      AR547813
     C                   PARM      '*VERIFY'     POptn                                      AR547813
     C                   PARM      'CLE028'      PSARD                                      AR547813
     C     SCSARD        PARM      SCSARD        DSFDY                                      AR547813
      *                                                                                     AR547813
     C                   MOVE      'N'           CLE028            1                        AR547813
      *                                                                                     AR547813
     C                   IF        PRtCd = *BLANKS                                          AR547813
     C                   MOVE      'Y'           CLE028                                     AR547813
     C                   ENDIF                                                              AR547813
      *
      ** Reset work fields
     C                   CLEAR                   Z#BSTS
     C                   CLEAR                   Z#ASTS
     C                   CLEAR                   Z#WSTS
     C                   MOVEL     LAFRNT        W#FRNT                                    AR1021983
      *
     C     EXINIT        ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * GLZADD - Subroutine to add an amount to the total             *
      *****************************************************************
     C     GLZADD        BEGSR
      *
     C                   Z-ADD     ZZAMT         ZZAMT            15 3    91    -DEFINE ZZAMT
     C   91              GOTO      ZZAEND                                       AMT = 0.BYPASS
      *
      ** Split ZZAMT into integer and decimal fields
     C                   Z-ADD     ZZAMT         ZZAMTI           15 0          INTEGER FIELD
     C                   MOVE      ZZAMT         ZZAMTD            3 0          DECIMAL FIELD
      *
      ** Both ZZAMTI and ZZAMTD contain a 'sign' zone now
      *
     C                   EXSR      GLZSUM
      *
     C     ZZAEND        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GLZSUB - Subroutine to subtract an amount to the total        *
      *****************************************************************
     C     GLZSUB        BEGSR
      *
      ** Processing just reverse the 'sign' and add
     C                   Z-SUB     ZZAMT         ZZAMT            15 3          REVERSE 'SIGN'
     C                   EXSR      GLZADD                                         AND 'ADD'
     C                   Z-SUB     ZZAMT         ZZAMT                          RESTORE 'SIGN'
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * GLZSUM - Subroutine to carry out the additon for subroutine   *
      *****************************************************************
     C     GLZSUM        BEGSR
      *
     C                   Z-ADD     ZZTOTI        ZZTOTI           15 0          DEFINE ZZTOTI
     C                   Z-ADD     ZZTOTD        ZZTOTD            3 0          DEFINE ZZTOTD
     C                   SETOFF                                       919293
     C                   SETOFF                                       949599
      *
      ** Determine sign of ZZAMTI & D, 92 if negative
     C     ZZAMTI        COMP      0                                    9293
     C   93ZZAMTD        COMP      0                                    9293
     C   93              GOTO      ZZSEND                                       ZERO BYPASS
      *
      ** Determine sign of ZZTOTI & D, 91 if negative
     C     ZZTOTI        COMP      0                                    9193
     C   93ZZTOTD        COMP      0                                    9193
      *
      ** If ZZTOTAL is zero, return ZZAMOUNT
     C   93              Z-ADD     ZZAMTI        ZZTOTI
     C   93              Z-ADD     ZZAMTD        ZZTOTD
     C   93              GOTO      ZZSEND                                       ZERO BYPASS
      *
      ** If signs differ bypass overflow checks
     C   91
     CANN92
     CORN91
     CAN 92              GOTO      ZZOFPS
      *
     C     ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
     C     ZZWK2         COMP      999                                93        '93' = CARRY
     C  N93ZZWK2         COMP      -999                                 93        INTO INTEGER.
      *
     C   93
     CANN92ZZAMTI        ADD       1             ZZWK3            15 0          ADD 'CARRY' +VE
     C   93
     CAN 92ZZAMTI        SUB       1             ZZWK3                          SUB 'CARRY' -VE
     C   93ZZTOTI        ADD       ZZWK3         ZZWK3
     C  N93ZZTOTI        ADD       ZZAMTI        ZZWK3
      *
      ** If the modulus of ZZWK3 is less than the one of ZZTOTI
      ** then an overflow has occurred
     C  N92ZZWK3         COMP      ZZTOTI                               99      -92 MEANS NOS.
     C   92ZZWK3         COMP      ZZTOTI                             99         NEGATIVE
     C  N99              Z-ADD     ZZWK2         ZZTOTD
     C  N99              Z-ADD     ZZWK3         ZZTOTI
      *
      ** If overflow zeroise ZZAMT, set 99 on and let ZZTOT fields intact
     C   99              Z-ADD     0             ZZAMT            15 3
     C                   GOTO      ZZSEND
      *
      ** The 'signs' are different
     C     ZZOFPS        TAG
      *
      ** If ZZAMT was negative, make it positive to compare with ZZTOT
     C   92              Z-SUB     ZZAMTI        ZZAMTI           15 0
     C   92              Z-SUB     ZZAMTD        ZZAMTD            3 0
      *
      ** If ZZTOT was negative, make it positive to compare with ZZAMT
     C   91              Z-SUB     ZZTOTI        ZZTOTI
     C   91              Z-SUB     ZZTOTD        ZZTOTD
      *
      ** Both ZZAMT and ZZTOT are now positive
     C     ZZTOTI        COMP      ZZAMTI                             93  95
     C   95ZZTOTD        COMP      ZZAMTD                             93  95
      *
      ** If ZZTOT equals ZZAMT return zero
     C   95              Z-ADD     0             ZZTOTI
     C   95              Z-ADD     0             ZZTOTD
     C   95              GOTO      ZZSEND
      *
      ** If ZZTOT greater than ZZAMT
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
      ** If ZZAMT greater than ZZTOT
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
      ** Reverse sign of ZZTOT if larger I/P fields were negative
     C                   SETOFF                                       94
     C   93
     CAN 91
     CORN93
     CAN 92              SETON                                        94
     C   94              Z-SUB     ZZTOTI        ZZTOTI
     C   94              Z-SUB     ZZTOTD        ZZTOTD
      *
      ** Restore sign of ZZAMTI & ZZAMTD if it was reversed
     C   92              Z-SUB     ZZAMTI        ZZAMTI
     C   92              Z-SUB     ZZAMTD        ZZAMTD
      *
     C     ZZSEND        TAG
      *
      ** If ZZTOTD is zero, and ZZTOTI is negative set up ZZNEGD
     C                   SETOFF                                       96
     C     ZZTOTD        COMP      0                                      91
     C   91ZZTOTI        COMP      0                                    96
     C   96              MOVE      '.000-'       ZZNEGD            5
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
     C                   MOVE      *BLANKS       KSeqNo                                       CRE020
     C                   MOVEL     LALNRF        KRefNo                                       CRE020
     C                   MOVEL     LALASN        KSeqNo                                       CRE020
                                                                                              CRE020
      ** Begin advice index processing.                                                       CRE020
                                                                                              CRE020
     C                   MOVE      *BLANK        WNew                                         CRE020
                                                                                              CRE020
     C                   OPEN      READVCL2                                                   CRE020
                                                                                              CRE020
     C     KADVC         SETLL     READVCL2                                                   CRE020
     C     KADVC         READE     READVCL2                                                   CRE020
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
     C                   IF        LACHTP = 'R'                                               CRE020
     C                   MOVE      'R'           RCHTYP                                       CRE020
     C                   MOVE      'Y'           RSAPIN                                       CRE020
     C                   MOVE      'Y'           RAUTHI                                       CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   MOVE      *BLANKS       WEvent                                       CRE020
     C                   MOVEL     RENARR        WEvent                                       CRE020
                                                                                              CRE020
      ** Change type is always 'I' for newly inserted value records. 'A'                      CRE020
      ** otherwise.                                                                           CRE020
                                                                                              CRE020
     C                   IF        WEvent = 'VALUE'                                           CRE020
     C                   MOVE      'I'           RCHTYP                                       CRE020
     C                   ELSE                                                                 CRE020
     C                   MOVE      'A'           RCHTYP                                       CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   MOVE      'N'           RSAPIN                                       CRE020
     C                   MOVE      'Y'           RAUTHI                                       CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
      ** Execute reversal processing if necessary.                                            CRE020
                                                                                              CRE020
     C                   IF        LACHTP = 'R'                                               CRE020
                                                                                              CRE020
      ** Delete the advice index if the current record is a new loan                          CRE020
      ** amendment. Reverse it otherwise.                                                     CRE020
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
     C                   MOVE      *BLANKS       WEvent                                       CRE020
     C                   MOVEL     RENARR        WEvent                                       CRE020
                                                                                              CRE020
     C                   IF        WEvent = 'VALUE'                                           CRE020
     C                   MOVE      'I'           RCHTYP                                       CRE020
     C                   ELSE                                                                 CRE020
     C                   MOVE      'A'           RCHTYP                                       CRE020
     C                   ENDIF                                                                CRE020
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
     C                   MOVE      LACHTP        RCHTYP                                       CRE020
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
     C     KADVC         READE     READVCL2                                                   CRE020
     C                   ENDDO                                                                CRE020
                                                                                              CRE020
     C                   CLOSE     READVCL2                                                   CRE020
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
     C                   MOVE      *BLANKS       KSeqNo                                       CRE020
     C                   MOVEL     LALNRF        KRefNo                                       CRE020
     C                   MOVEL     LALASN        KSeqNo                                       CRE020
                                                                                              CRE020
      ** Begin advice index processing.                                                       CRE020
                                                                                              CRE020
     C                   OPEN      READVCL2                                                   CRE020
                                                                                              CRE020
     C     KADVC         SETLL     READVCL2                                                   CRE020
     C     KADVC         READE     READVCL2                                                   CRE020
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
     C     KADVC         READE     READVCL2                                                   CRE020
     C                   ENDDO                                                                CRE020
                                                                                              CRE020
     C                   CLOSE     READVCL2                                                   CRE020
                                                                                              CRE020
     C                   ENDSR                                                                CRE020
      ****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *                      BUG3760
      * SRWTCH - Set-up parameter and send transaction details to     *                      BUG3760
      *          Compliance Watch by calling the Engine program       *                      BUG3760
      *                                                               *                      BUG3760
      *****************************************************************                      BUG3760
     C     SRWTCH        BEGSR                                                               BUG3760
      *                                                                                      BUG3760
      ** Set-up first parameter for Compliance Engine                                        BUG3760
      *                                                                                      BUG3760
     C                   CLEAR                   SDWLTD                                      BUG3760
      *                                                                                      BUG3760
      ** Build the free format string.                                                       BUG3760
      *                                                                                      BUG3760
     C                   EVAL      Ctr = 0                                                   BUG3760
     C                   EVAL      PFreeFmtStr = *BLANKS                                     BUG3760
     C                   EVAL      WData = *BLANKS                                           BUG3760
      *                                                                                      BUG3760
     C                   DOU       Ctr = 12                                                  BUG3760
     C                   ADD       1             Ctr                                         BUG3760
     C                   MOVEL     WLF(Ctr)      PDumy35a                                    BUG3760
      *                                                                                      BUG3760
     C                   IF        WLF(Ctr) <> *BLANKS AND WLF(Ctr) <> '000000'              BUG3760
      *                                                                                      BUG3760
     C                   IF        SCCY <> *BLANKS                                           BUG3760
     C                   MOVEL     SCCY          PYCCY                                       BUG3760
     C                   ELSE                                                                BUG3760
     C                   MOVEL     CCY           PYCCY                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   CALL      'SDCWLFMT'                                                BUG3760
     C                   PARM                    PRetCode                                    BUG3760
     C                   PARM                    PDumy35a                                    BUG3760
     C                   PARM      *BLANKS       PDummy35                                    BUG3760
     C                   PARM      *BLANKS       PDummy35                                    BUG3760
     C                   PARM      *BLANKS       PDummy35                                    BUG3760
     C                   PARM      *BLANKS       PDummy35                                    BUG3760
     C                   PARM      *BLANKS       PDummy35                                    BUG3760
     C                   PARM                    PYCCY                                       BUG3760
     C                   PARM                    WData                                       BUG3760
     C                   PARM                    PDummy6                                     BUG3760
      *                                                                                      BUG3760
     C                   IF        WData <> *BLANKS                                          BUG3760
     C     Ctr           MULT      2             CLS                                         BUG3760
     C     CLS           SUB       1             OPN                                         BUG3760
     C                   MOVEL     CWA(OPN)      WOPN                                        BUG3760
     C                   MOVEL     CWA(CLS)      WCLS                                        BUG3760
      *                                                                                      BUG3760
     C     PFreeFmtStr   CAT       WOPN:0        PFreeFmtStr                                 BUG3760
     C                   CAT       WData:0       PFreeFmtStr                                 BUG3760
      *                                                                                      BUG3760
     C                   SELECT                                                              BUG3760
     C     Ctr           WHENEQ    2                                                         BUG3760
     C                   CAT       RIBA:0        PFreeFmtStr                                 BUG3760
     C     Ctr           WHENEQ    6                                                         BUG3760
     C                   CAT       PIBA:0        PFreeFmtStr                                 BUG3760
     C     Ctr           WHENEQ    9                                                         BUG3760
     C                   CAT       RCRA:0        PFreeFmtStr                                 BUG3760
     C     Ctr           WHENEQ    11                                                        BUG3760
     C                   CAT       AWBA:0        PFreeFmtStr                                 BUG3760
     C     Ctr           WHENEQ    12                                                        BUG3760
     C                   CAT       BENA:0        PFreeFmtStr                                 BUG3760
     C                   ENDSL                                                               BUG3760
      *                                                                                      BUG3760
     C                   CAT       WCLS:0        PFreeFmtStr                                 BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDDO                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        DTP1 <> *BLANKS OR                                        BUG3760
     C                             DTP2 <> *BLANKS OR                                        BUG3760
     C                             DTP3 <> *BLANKS OR                                        BUG3760
     C                             DTP4 <> *BLANKS OR                                        BUG3760
     C                             WDTPC = 'Y'                                               BUG3760
     C                   CAT       CWA(25):0     PFreeFmtStr                                 BUG3760
     C                   CAT       DTP1:0        PFreeFmtStr                                 BUG3760
     C                   CAT       DTP2:1        PFreeFmtStr                                 BUG3760
     C                   CAT       DTP3:1        PFreeFmtStr                                 BUG3760
     C                   CAT       DTP4:1        PFreeFmtStr                                 BUG3760
     C                   CAT       CWA(26):0     PFreeFmtStr                                 BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
      ** Setup parameter 1 and send details to engine only if                                BUG3760
      ** PFreeFmtStr is not empty.                                                           BUG3760
      *                                                                                      BUG3760
     C                   IF        PFreeFmtStr <> *BLANKS                                    BUG3760
      *                                                                                      BUG3760
      ** Parameter 1:                                                                        BUG3760
      ** Item Type Code                                                                      BUG3760
      *                                                                                      BUG3760
     C                   MOVEL     'LEAMD'       W4ITEM                                      BUG3760
      *                                                                                      BUG3760
      ** Identifier                                                                          BUG3760
      *                                                                                      BUG3760
     C                   MOVEL     *BLANKS       WLNRF                                       BUG3760
     C                   MOVEL     *BLANKS       WKVDAT                                      BUG3760
     C                   MOVEL     *BLANKS       WLASN                                       BUG3760
     C                   MOVEL     *BLANKS       W4IDEN                                      BUG3760
     C                   MOVEL     LNRF          WLNRF                                       BUG3760
     C                   MOVEL     VDAT          WKVDAT                                      BUG3760
     C                   MOVEL     LASN          WLASN                                       BUG3760
     C     WLNRF         CAT       WKVDAT:0      W4IDEN                                      BUG3760
     C                   CAT       WLASN:0       W4IDEN                                      BUG3760
      *                                                                                      BUG3760
      ** Branch                                                                              BUG3760
      *                                                                                      BUG3760
     C                   MOVEL     BRCA          W4BRCH                                      BUG3760
      *                                                                                      BUG3760
      ** System                                                                              BUG3760
      ** If Midas 24x7 is installed, use Main system prefix                                  BUG3760
      ** otherwise, use system prefix                                                        BUG3760
      *                                                                                      BUG3760
     C                   IF        CSC011 = 'Y'                                              BUG3760
     C                   MOVE      S1MAIN        W4SYSM                                      BUG3760
     C                   ELSE                                                                BUG3760
     C                   MOVE      LIBR          W4SYSM                                      BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
      ** Function Type                                                                       BUG3760
      *                                                                                      BUG3760
     C                   MOVEL     'LOAMSDK'     W4FUNT                                      BUG3760
      *                                                                                      BUG3760
      ** Counter Party Details                                                               BUG3760
      *                                                                                      BUG3760
     C                   MOVEL     CNUM          PCUST                                       BUG3760
     C                   CALLB     'AOCUSTR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*KEY'        POption                                     BUG3760
     C                   PARM                    PCUST                                       BUG3760
     C                   PARM      *BLANKS       PSTKEY                                      BUG3760
     C     SDCUST        PARM      SDCUST        DSSDY                                       BUG3760
      *                                                                                      BUG3760
     C                   IF        PRetCode <> *BLANKS                                       BUG3760
     C                   EVAL      DBKEY = POption                                           BUG3760
     C                   EVAL      DBFILE = 'SDCUSTPD'                                       BUG3760
     C                   EVAL      DBASE = 911                                               BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ELSE                                                                BUG3760
     C                   MOVE      *BLANKS       W4CUST                                      BUG3760
     C                   EVAL      W4CUST = BBCRNM + BBCRTN                                  BUG3760
     C                   EVAL      W4CNUM = PCUST                                            BUG3760
      *                                                                                      BUG3760
     C                   IF        CCF001 = 'Y'                                              BUG3760
      *                                                                                      BUG3760
     C                   IF        BBCRPC = 'Y'                                              BUG3760
     C                   EVAL      W4CTYP = 'C'                                              BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      W4CTYP = 'I'                                              BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ELSE                                                                BUG3760
      *                                                                                      BUG3760
     C                   IF        BBLICD <> *BLANK AND                                      BUG3760
     C                             BBLICD <> W1IND1 AND                                      BUG3760
     C                             BBLICD <> W1IND2 AND                                      BUG3760
     C                             BBLICD <> W1IND3 AND                                      BUG3760
     C                             BBLICD <> W1IND4 AND                                      BUG3760
     C                             BBLICD <> W1IND5                                          BUG3760
     C                   EVAL      W4CTYP = 'C'                                              BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      W4CTYP = 'I'                                              BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
      ** Deal Date                                                                           BUG3760
      *                                                                                      BUG3760
     C                   MOVE      *ZERO         PZADayNo                                    BUG3760
     C                   EXSR      SRDateToDDT                                               BUG3760
     C                   EVAL      W4DDAT = WDDT                                             BUG3760
      *                                                                                      BUG3760
      ** Value Date                                                                          BUG3760
      *                                                                                      BUG3760
     C                   MOVE      VDAT          PZADayNo                                    BUG3760
     C                   EXSR      SRDateToDDT                                               BUG3760
     C                   EVAL      W4VDAT = WDDT                                             BUG3760
      *                                                                                      BUG3760
      ** Maturity Date                                                                       BUG3760
      *                                                                                      BUG3760
     C                   MOVE      *ZERO         PZADayNo                                    BUG3760
     C                   EXSR      SRDateToDDT                                               BUG3760
     C                   EVAL      W4MDAT = WDDT                                             BUG3760
      *                                                                                      BUG3760
      ** Denomination Side                                                                   BUG3760
      *                                                                                      BUG3760
     C                   MOVEL     CCY           W4DEN1                                      BUG3760
     C                   MOVEL     *BLANKS       W4DEN2                                      BUG3760
      *                                                                                      BUG3760
      ** Amount Side                                                                         BUG3760
      *                                                                                      BUG3760
     C                   MOVE      TAMT          PAMT                                        BUG3760
     C                   CALLB     'ZACVTAMT'                                                BUG3760
     C                   PARM                    PRetCode                                    BUG3760
     C                   PARM                    PYCCY                                       BUG3760
     C                   PARM                    PAMT                                        BUG3760
     C                   PARM                    ConvertedAmt                                BUG3760
     C                   PARM                    PDummy16                                    BUG3760
      *                                                                                      BUG3760
     C                   MOVE      ConvertedAmt  W4AMT1                                      BUG3760
     C                   EVAL      W4AMT2 = *ZERO                                            BUG3760
      *                                                                                      BUG3760
      ** Send transaction details to Compliance Watch                                        BUG3760
      *                                                                                      BUG3760
     C                   CALL      'SDCWLCHK'                                                BUG3760
     C                   PARM                    SDWLTD                                      BUG3760
     C                   PARM                    PFreeFmtStr                                 BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDSR                                                               BUG3760
      *****************************************************************                      BUG3760
      /EJECT                                                                                 BUG3760
      *****************************************************************                      BUG3760
      *                                                               *                      BUG3760
      * SRDateToDDT - Converts a date into Date Data Type format.     *                      BUG3760
      *                                                               *                      BUG3760
      *****************************************************************                      BUG3760
     C     SRDateToDDT   BEGSR                                                               BUG3760
      *                                                                                      BUG3760
      ** Convert the derived Midas Day Number into Date Data Type.                           BUG3760
      *                                                                                      BUG3760
     C                   CALL      'ZACVTDATE'                                               BUG3760
     C                   PARM      *BLANKS       PZARtCd                                     BUG3760
     C                   PARM                    PZADayNo                                    BUG3760
     C                   PARM                    PZADDT                                      BUG3760
     C                   PARM                    PZACvtDt                                    BUG3760
      *                                                                                      BUG3760
     C                   EVAL      WDDT = PZADDT                                             BUG3760
      *                                                                                      BUG3760
     C                   ENDSR                                                               BUG3760
      *****************************************************************                      BUG3760
      /EJECT                                                                                 BUG3760
      *****************************************************************                       CAS011
      *                                                               *                       CAS011
      *  SEIRI1 - Set EIR Indicators to re-calculate.                 *                       CAS011
      *                                                               *                       CAS011
      *****************************************************************                       CAS011
                                                                                              CAS011
     C     SEIRI1        BEGSR                                                                CAS011
                                                                                              CAS011
     C                   IF        CAS016 = 'Y'                                               CAS019
     C     WTRAN         CHAIN     LEEIRDL9                                                   CAS019
     C                   ELSE                                                                 CAS019
     C     WTRAN         CHAIN     LEEIRDD5                                                   CAS011
     C                   ENDIF                                                                CAS019
     C                   IF        %FOUND AND WVALD <= EIENDT                                 CAS011
                                                                                              CAS011
     C                   EVAL      EIRCAL = 'Y'                                               CAS011
                                                                                              CAS011
     C                   IF        WDELR = 'Y' OR WADJP = 'Y'                                 CAS011
     C                   EVAL      EIADJP = 'Y'                                               CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
     C                   IF        CAS016 = 'Y'                                               CAS019
     C                   UPDATE    LEEIRDD9                                                   CAS019
     C                   ELSE                                                                 CAS019
     C                   UPDATE    LEEIRDD5                                                   CAS011
     C                   ENDIF                                                                CAS019
                                                                                              CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS019
      ** Search all fees amortised separately                                                 CAS019
                                                                                              CAS019
     C                   IF        CAS016 = 'Y'                                               CAS019
     C     WTRAN         CHAIN     LEERAPL1                           20                      CAS019
     C                   DOW       *IN20 = '0'                                                CAS019
      *                                                                                       CAS019
     C     LACHTP        IFEQ      'I'                                                        CAS019
     C     LACHTP        OREQ      'R'                                                        CAS019
     C     VDAT          IFLE      EIENDT                                                     CAS019
     C                   MOVE      'Y'           EIRCAL                                       CAS019
     C                   UPDATE    LEERAPD0                                                   CAS019
     C                   ENDIF                                                                CAS019
     C                   ENDIF                                                                CAS019
      *                                                                                       CAS019
     C     WTRAN         READE     LEERAPL1                               20                  CAS019
     C                   ENDDO                                                                CAS019
      *                                                                                       CAS019
     C                   ENDIF                                                                CAS019
                                                                                              CAS011
     C                   ENDSR                                                                CAS011
      *****************************************************************                       CAS011
      /EJECT                                                                                  CLE073
      *****************************************************************                       CLE073
      *  CHKLON  -  Check if loan has associated fees                 *                       CLE073
      *  Called by: SRFEES                                            *                       CLE073
      *  Calls    : None                                              *                       CLE073
      *****************************************************************                       CLE073
      *                                                                                       CLE073
     C     CHKLON        BEGSR                                                                CLE073
      *                                                                                       CLE073
     C                   Z-ADD     0             WFFACL                                       CLE073
     C                   MOVEL     LALNRF        WFLOAN                                       CLE073
     C     WKFEE         SETLL     LEFEEDL1                                                   CLE073
     C*****WKFEE         READE     LEFEEDL1                               89         CLE073 MD023203
     C     WKFEE         READE (N) LEFEEDL1                               89                MD023203
      *                                                                                       CLE073
      ** Do while an associated fee exists                                                    CLE073
      *                                                                                       CLE073
     C     *IN89         DOWEQ     *OFF                                                       CLE073
      *                                                                                       CLE073
      ** If the fee is a confirmed calculated fee and swift                                   CLE073
      ** regeneration indicator is not 'I', 'B', 'H'                                          CLE073
      ** and Value Date is on or after Fee Start and before or on Fee End date                CLE073
      *                                                                                       CLE073
     C     FEAUTO        IFEQ      'Y'                                                        CLE073
     C     FESWRI        ANDNE     'I'                                                        CLE073
     C     FESWRI        ANDNE     'B'                                                        CLE073
     C     FESWRI        ANDNE     'H'                                                        CLE073
     C     FECALT        ANDEQ     '97'                                                       CLE073
     C     LAVDAT        ANDGE     FEPSTD                                                     CLE073
     C     LAVDAT        ANDLE     FEPEND                                                     CLE073
      *                                                                                       CLE073
      ** Set currency to fee currency                                                         CLE073
      ** Set day to run date                                                                  CLE073
      ** Set number of working days to telex notice days                                      CLE073
      *                                                                                       CLE073
     C                   MOVE      FEFCCY        ZCCY                                         CLE073
     C                   Z-ADD     WRNDAY        ZDAYNO                                       CLE073
     C                   Z-ADD     1             X                                            CLE073
      *                                                                                     MD054317
      ** If CLE031 is on then use correct currency to access AONOSTR0                       MD054317
      *                                                                                     MD054317
     C                   MOVE      FEFCCY        WKCCY                                      MD054317
      *                                                                                     MD054317
     C     CLE031        IFEQ      'Y'                                                      MD054317
      *                                                                                     MD054317
     C     PTFI          IFEQ      'P'                                                      MD054317
     C     FEPSCY        IFNE      *BLANKS                                                  MD054317
     C                   MOVE      FEPSCY        WKCCY                                      MD054317
     C                   ENDIF                                                              MD054317
     C                   ELSE                                                               MD054317
     C     FESCCY        IFNE      *BLANKS                                                  MD054317
     C                   MOVE      FESCCY        WKCCY                                      MD054317
     C                   ENDIF                                                              MD054317
     C                   ENDIF                                                              MD054317
      *                                                                                     MD054317
     C                   ENDIF                                                              MD054317
      *                                                                                     MD054317
     C                   MOVE      WKCCY         ZCCY                                       MD054317
     C                   MOVE      WKCCY         @CURR                                      MD054317
      *                                                                                     MD054317
     C*****FEFCCY        LOOKUP    CYA(X)                                 69         CLE073 MD054317
     C     WKCCY         LOOKUP    CYA(X)                                 69                MD054317
     C                   MOVE      *OFF          *IN69                                        CLE073
     C                   MOVE      TND(X)        ZNRDYS                                       CLE073
      *                                                                                       CLE073
      ** If Fee Settlement type is '01', '02', '07', '08' or '12'                             CLE073
      *                                                                                       CLE073
     C     FESTTL        IFEQ      01                                                         CLE073
     C     FESTTL        OREQ      02                                                         CLE073
     C     FESTTL        OREQ      07                                                         CLE073
     C     FESTTL        OREQ      08                                                         CLE073
     C     FESTTL        OREQ      12                                                         CLE073
      *                                                                                       CLE073
     C                   CALLB     'AONOSTR0'                                                 CLE073
     C                   PARM      *BLANKS       @RtCd                                        CLE073
     C                   PARM      '*KEY   '     @Optn                                        CLE073
     C                   PARM                    @Cusn             6                          CLE073
     C**********         PARM      FEFCCY        @Curr             3                 CLE073 MD054317
     C                   PARM                    @Curr                                      MD054317
     C                   PARM                    @Accd                                        CLE073
     C                   PARM                    @Acsn             2                          CLE073
     C                   PARM      FEOURS        @Nonb             2                          CLE073
     C                   PARM                    @Brca             3                          CLE073
     C                   PARM                    @Cssn            10                          CLE073
     C                   PARM                    @Pnoi             1                          CLE073
     C     SDNOST        PARM                    DSFDY                                        CLE073
      *                                                                                       CLE073
     C     @RtCd         IFNE      *BLANKS                                                    CLE073
     C                   MOVEL     'AONOSTR0'    DBFILE                                       CLE073
     C                   Z-ADD     900           DBASE                                        CLE073
     C                   MOVEL     FEFCCY        DBKEY                                        CLE073
     C                   EXSR      *PSSR                                                      CLE073
     C                   ELSE                                                                 CLE073
      *                                                                                       CLE073
      ** Set Location to Nostro Location                                                      CLE073
      *                                                                                       CLE073
     C                   MOVE      A7NOSN        ZLOC                                         CLE073
     C                   ENDIF                                                                CLE073
      *                                                                                       CLE073
     C                   ELSE                                                                 CLE073
      *                                                                                       CLE073
     C                   MOVE      *BLANKS       ZLOC                                         CLE073
      *                                                                                       CLE073
     C                   ENDIF                                                                CLE073
      *                                                                                       CLE073
      ** Calculate number of working days forward                                             CLE073
      *                                                                                       CLE073
     C                   CALLB     'ZFWDT'                                                    CLE073
     C                   PARM                    ZDAYNO            5 0                        CLE073
     C                   PARM                    ZNRDYS            2 0                        CLE073
     C                   PARM      *ZERO         ZDYNBR            5 0                        CLE073
     C                   PARM                    ZCCY              3                          CLE073
     C                   PARM      *BLANKS       ZLOC              3                          CLE073
      *                                                                                       CLE073
      ** Set Telex Notice date to day number                                                  CLE073
      *                                                                                       CLE073
     C                   Z-ADD     ZDYNBR        TXDT              5 0                        CLE073
      *                                                                                     MD023203
     C                   MOVEL     FECNUM        WFCNUMX                                    MD023203
     C                   MOVEL     FEFACL        WFFACLX                                    MD023203
     C                   MOVEL     FELOAN        WFLOANX                                    MD023203
     C                   MOVEL     FEFSEQ        WFSEQNX                                    MD023203
      *                                                                                       CLE073
      ** If next payment date is before or equals to Telex Notice date                        CLE073
      ** and Next Payment Telex indicator is set to 'Y'                                       CLE073
      *                                                                                       CLE073
     C     FENPYD        IFLE      TXDT                                                       CLE073
     C     FEPPTI        ANDEQ     'Y'                                                        CLE073
      *                                                                                       CLE073
      ** Update Fees file                                                                     CLE073
      *                                                                                       CLE073
     C     WKFEEX        CHAIN     LEFEEDL0                                                 MD023203
     C                   IF        %FOUND(LEFEEDL0)                                         MD023203
     C**********         MOVE      'A'           FESWRI                              CLE073 MD023203
     C**********         UPDATE    LEFEEDF                                           CLE073 MD023203
     C                   MOVE      'A'           X_FESWRI                                   MD023203
     C                   UPDATE    LEFEEDX                                                  MD023203
     C                   ENDIF                                                              MD023203
     C                   ELSE                                                                 CLE073
      *                                                                                       CLE073
      ** If end date is before or equals to Telex Notice date and End                         CLE073
      ** Telex indicator is set to 'Y'                                                        CLE073
      *                                                                                       CLE073
     C     FEPEND        IFLE      TXDT                                                       CLE073
     C     FEEPTI        ANDEQ     'Y'                                                        CLE073
      *                                                                                       CLE073
      ** Update Fees file                                                                     CLE073
      *                                                                                       CLE073
     C     WKFEEX        CHAIN     LEFEEDL0                                                 MD023203
     C                   IF        %FOUND(LEFEEDL0)                                         MD023203
     C**********         MOVE      'A'           FESWRI                              CLE073 MD023203
     C**********         UPDATE    LEFEEDF                                           CLE073 MD023203
     C                   MOVE      'A'           X_FESWRI                                   MD023203
     C                   UPDATE    LEFEEDX                                                  MD023203
     C                   ENDIF                                                              MD023203
     C                   ENDIF                                                                CLE073
     C                   ENDIF                                                                CLE073
      *                                                                                       CLE073
     C                   ENDIF                                                                CLE073
      *                                                                                       CLE073
     C*****WKFEE         READE     LEFEEDL1                               89         CLE073 MD023203
     C     WKFEE         READE (N) LEFEEDL1                               89                MD023203
     C                   ENDDO                                                                CLE073
      *                                                                                       CLE073
     C                   ENDSR                                                                CLE073
      *                                                                                       CLE073
      *****************************************************************                       CLE073
      /EJECT                                                                                MD023787
      *****************************************************************                     MD023787
      *  GETLON  -  Get loan details for PDCL projection.             *                     MD023787
      *  Called by: INSERT                                            *                     MD023787
      *  Calls    : None                                              *                     MD023787
      *****************************************************************                     MD023787
     C     GETLON        BEGSR                                                              MD023787
      *                                                                                     MD023787
     C                   MOVE      'Y'           PDCLI                                      MD023787
      *                                                                                     MD023787
      ** Set the PI Reciept from loan Reciept.                                              MD023787
      *                                                                                     MD023787
     C     LARONS        IFEQ      *BLANKS                                                  MD023787
     C                   MOVE      LO_RSTM       LARSTM                                     MD023787
     C                   MOVE      LO_RONS       LARONS                                     MD023787
     C                   MOVE      LO_RIBN       LARIBN                                     MD023787
     C                   MOVE      LO_RIBA       LARIBA                                     MD023787
     C                   MOVE      LO_ROBN       LAROBN                                     MD023787
     C                   MOVE      LO_ROCN       LAROCN                                     MD023787
     C                   ENDIF                                                              MD023787
      *                                                                                     MD023787
      ** Set PI pay settlement into '00' and blanks.                                        MD023787
      *                                                                                     MD023787
     C                   MOVE      '00'          LAPSTM                                     MD023787
     C                   MOVE      *BLANKS       LAPONS                                     MD023787
     C                   MOVE      *BLANKS       LAPIBN                                     MD023787
     C                   MOVE      *BLANKS       LAPIBA                                     MD023787
     C                   MOVE      *BLANKS       LAPOBN                                     MD023787
     C                   MOVE      *BLANKS       LAPOCN                                     MD023787
     C                   MOVE      *BLANKS       LARCRN                                     MD023787
     C                   MOVE      *BLANKS       LARCRA                                     MD023787
     C                   MOVE      *BLANKS       LARVNO                                     MD023787
     C                   MOVE      *BLANKS       LAAWBN                                     MD023787
     C                   MOVE      *BLANKS       LABENN                                     MD023787
     C                   MOVE      *BLANKS       LADTP1                                     MD023787
     C                   MOVE      *BLANKS       LADTP2                                     MD023787
     C                   MOVE      *BLANKS       LADTP3                                     MD023787
     C                   MOVE      *BLANKS       LADTP4                                     MD023787
     C                   MOVE      *BLANKS       LADCHG                                     MD023787
     C                   MOVE      *BLANKS       LABTB1                                     MD023787
     C                   MOVE      *BLANKS       LABTB2                                     MD023787
     C                   MOVE      *BLANKS       LABTB3                                     MD023787
     C                   MOVE      *BLANKS       LABTB4                                     MD023787
     C                   MOVE      *BLANKS       LABTB5                                     MD023787
     C                   MOVE      *BLANKS       LABTB6                                     MD023787
     C                   MOVE      *BLANKS       LACVMR                                     MD023787
      *                                                                                     MD023787
     C                   ENDSR                                                              MD023787
      *                                                                                     MD023787
      *****************************************************************                     MD023787
      /EJECT                                                                                MD050018
      *****************************************************************                     MD050018
      *  SrUpdPDCL - Update of PDP link files LEPDUEPD/LEPDUFPD on ic *                     MD050018
      *  Called by: INSERT  and AMEND                                 *                     MD050018
      *  Calls    : SrLEPDUEIns, SrLEPDUFIns, SrLEPDUEDelAmd          *                     MD050018
      *             SrLEPDUFDelAmd                                    *                     MD050018
      *****************************************************************                     MD050018
     C     SrUpdPDCL     BEGSR                                                              MD050018
      *                                                                                     MD050018
      ** Check PDCL loan details                                                            MD050018
     C                   EVAL      WkLNR = LALNRF                                           MD050018
     C                   EVAL      WRCDT = 'A'                                              MD050018
     C     KLKEY         CHAIN(N)  CLOAN                              99                    MD050018
     C     *IN99         IFEQ      '1'                                                      MD050018
     C                   MOVEL     'CLOAN   '    DBFILE                                     MD050018
     C                   Z-ADD     33            DBASE                                      MD050018
     C                   MOVEL     WKLNR         DBKEY                                      MD050018
     C                   EXSR      *PSSR                                                    MD050018
     C                   ENDIF                                                              MD050018
      *                                                                                     MD050018
      ** For insert action, add new 'P' record                                              MD050018
      ** Also update 'D' record                                                             MD050018
     C                   IF        DDACTN = 'I'                                             MD050018
     C                   IF        %SUBST(LTYPA:1:1) = 'X' OR                               MD050018
     C                             %SUBST(LTYPA:1:1) = 'Y'                                  MD050018
     C                   EXSR      SrLEPDUEIns                                              MD050018
     C                   ELSE                                                               MD050018
     C                   EXSR      SrLEPDUFIns                                              MD050018
     C                   ENDIF                                                              MD050018
      *                                                                                     MD050018
     C                   ELSE                                                               MD050018
      ** For Amend/Delete action, update amount of the existing 'P' record                  MD050018
      ** Also update 'D' record                                                             MD050018
     C                   IF        %SUBST(LTYPA:1:1) = 'X' OR                               MD050018
     C                             %SUBST(LTYPA:1:1) = 'Y'                                  MD050018
     C                   EXSR      SrLEPDUEDelAmd                                           MD050018
     C                   ELSE                                                               MD050018
     C                   EXSR      SrLEPDUFDelAmd                                           MD050018
     C                   ENDIF                                                              MD050018
     C                   ENDIF                                                              MD050018
      *                                                                                     MD050018
     C                   ENDSR                                                              MD050018
      *****************************************************************                     MD050018
      /EJECT                                                                                MD050018
      *****************************************************************                     MD050018
      * SrLEPDUEIns - Update of LEPDUEPD on ic for insert             *                     MD050018
      * Called by: SrUpdPDCL                                          *                     MD050018
      * Calls    : None                                               *                     MD050018
      *****************************************************************                     MD050018
     C     SrLEPDUEIns   BEGSR                                                              MD050018
      *                                                                                     MD050018
     C                   CLEAR                   LEPDUED0                                   MD050018
      *                                                                                     MD050018
      ** Update the corresponding 'D' record to increase YPCPAM/YPDINT                      MD050018
     C                   EVAL      WkReci = 'D'                                             MD050018
     C                   IF        %SUBST(LTYPA:1:1) = 'X'                                  MD050018
     C                   EVAL      WkPDCT = 'P'                                             MD050018
     C                   ELSE                                                               MD050018
     C                   EVAL      WkPDCT = 'I'                                             MD050018
     C                   ENDIF                                                              MD050018
      *                                                                                     MD050018
     C     KLEPDUE2      CHAIN     LEPDUEL6                                                 MD050018
     C                   IF        %FOUND(LEPDUEL6)                                         MD050018
     C                   IF        %SUBST(LTYPA:1:1) = 'X'                                  MD050018
     C                   EVAL      YPCPAM = YPCPAM + LAPRAM                                 MD050018
     C                   ELSE                                                               MD050018
     C                   EVAL      YPDINT = YPDINT + LAPRAM                                 MD050018
     C                   ENDIF                                                              MD050018
     C                   UPDATE    LEPDUED6                                                 MD050018
     C                   ENDIF                                                              MD050018
      *                                                                                     MD050018
      ** Populate 'P' fields                                                                MD050018
     C                   EVAL      YRECI = 'P'                                              MD050018
     C                   EVAL      YPLON = LALNRF                                           MD050018
     C                   Z-ADD     LO_VDAT       YVDAT                                      MD050018
     C                   EVAL      YPORG = LO_ORLN                                          MD050018
     C                   EVAL      YBRCA = LO_BRCA                                          MD050018
     C                   EVAL      YTKPACL = *BLANKS                                        MD050018
     C                   EVAL      YTKPABR = *BLANKS                                        MD050018
     C                   Z-ADD     0             YTKPAAC                                    MD050018
     C                   Z-ADD     0             YTKPASE                                    MD050018
     C                   EVAL      YTKPACY = *BLANKS                                        MD050018
     C                   EVAL      YTKIACL = *BLANKS                                        MD050018
     C                   EVAL      YTKIABR = *BLANKS                                        MD050018
     C                   Z-ADD     0             YTKIAAC                                    MD050018
     C                   Z-ADD     0             YTKIASE                                    MD050018
     C                   EVAL      YTKIACY = *BLANKS                                        MD050018
     C                   EVAL      YDECRE = 'N'                                             MD050018
     C                   Z-ADD     LAVDAT        YPDVDT                                     MD050018
     C                   Z-ADD     WRNDAY        YLCD                                       MD050018
     C                   EVAL      YTYLC = 'I'                                              MD050018
     C                   EVAL      YPIUSE = LAIUSR                                          MD050018
     C                   EVAL      YPCBIC = 'I'                                             MD050018
     C                   Z-ADD     LALASN        YPOSEQ                                     MD050018
     C                   EVAL      YPFRNT = LAFRNT                                          MD050018
      *                                                                                     MD050018
     C                   IF        %SUBST(LTYPA:1:1) = 'X'                                  MD050018
     C                   EVAL      YPDCT = 'P'                                              MD050018
     C                   EVAL      WkPDCT = 'P'                                             MD050018
     C                   Z-ADD     LAPRAM        YPCPAM                                     MD050018
     C                   Z-ADD     LAPRAM        YPOREP                                     MD050018
     C                   Z-ADD     0             YPDINT                                     MD050018
     C                   Z-ADD     0             YPOREI                                     MD050018
     C                   ELSE                                                               MD050018
     C                   EVAL      YPDCT = 'I'                                              MD050018
     C                   EVAL      WkPDCT = 'I'                                             MD050018
     C                   Z-ADD     LAPRAM        YPDINT                                     MD050018
     C                   Z-ADD     LAPRAM        YPOREI                                     MD050018
     C                   Z-ADD     0             YPCPAM                                     MD050018
     C                   Z-ADD     0             YPOREP                                     MD050018
     C                   ENDIF                                                              MD050018
      *                                                                                     MD050018
     C                   CALLB     'ZAGENTMSTM'                                             MD050018
     C                   PARM                    YPTMST                                     MD050018
     C                   WRITE     LEPDUED0                                                 MD050018
      *                                                                                     MD050018
     C                   ENDSR                                                              MD050018
      *****************************************************************                     MD050018
      /EJECT                                                                                MD050018
      *****************************************************************                     MD050018
      * SrLEPDUEDelAmd - Update of LEPDUEPD on ic for amend and delete*                     MD050018
      * Called by: SrUpdPDCL                                          *                     MD050018
      * Calls    : None                                               *                     MD050018
      *****************************************************************                     MD050018
     C     SrLEPDUEDelAmdBEGSR                                                              MD050018
      *                                                                                     MD050018
      ** Update 'P record                                                                   MD050018
     C                   Z-ADD     0             WkDINT                                     MD050018
     C                   Z-ADD     0             WkCPAM                                     MD050018
     C                   Z-ADD     LALASN        WkLASN                                     MD050018
     C     KLEPDUE1      CHAIN     LEPDUELE                                                 MD050018
     C                   IF        %FOUND(LEPDUELE)                                         MD050018
      *                                                                                     MD050018
     C                   IF        %SUBST(LTYPA:1:1) = 'X'                                  MD050018
     C                   EVAL      WkPDCT = 'P'                                             MD050018
     C                   Z-ADD     YPCPAM        WkCPAM                                     MD050018
     C                   Z-ADD     LAPRAM        YPCPAM                                     MD050018
     C                   Z-ADD     LAPRAM        YPOREP                                     MD050018
     C                   Z-ADD     0             YPDINT                                     MD050018
     C                   Z-ADD     0             YPOREI                                     MD050018
     C                   ELSE                                                               MD050018
     C                   EVAL      WkPDCT = 'I'                                             MD050018
     C                   Z-ADD     YPDINT        WkDINT                                     MD050018
     C                   Z-ADD     LAPRAM        YPDINT                                     MD050018
     C                   Z-ADD     LAPRAM        YPOREI                                     MD050018
     C                   Z-ADD     0             YPCPAM                                     MD050018
     C                   Z-ADD     0             YPOREP                                     MD050018
     C                   ENDIF                                                              MD050018
      *                                                                                     MD050018
     C                   IF        DDACTN = 'R'                                             MD050018
     C                   DELETE    LEPDUED0                                                 MD050018
     C                   ELSE                                                               MD050018
     C                   CALLB     'ZAGENTMSTM'                                             MD050018
     C                   PARM                    YPTMST                                     MD050018
     C                   UPDATE    LEPDUED0                                                 MD050018
     C                   ENDIF                                                              MD050018
      *                                                                                     MD050018
      ** Update 'D' record to increase/decrease YPCPAM/YPDINT                               MD050018
     C                   EVAL      WkReci = 'D'                                             MD050018
     C     KLEPDUE2      CHAIN     LEPDUEL6                                                 MD050018
     C                   IF        %FOUND(LEPDUEL6)                                         MD050018
      *                                                                                     MD050018
     C                   IF        DDACTN = 'R'                                             MD050018
     C                   EVAL      YPCPAM = YPCPAM - WkCPAM                                 MD050018
     C                   EVAL      YPDINT = YPDINT - WkDINT                                 MD050018
     C                   ELSE                                                               MD050018
     C                   IF        %SUBST(LTYPA:1:1) = 'X'                                  MD050018
     C                   EVAL      YPCPAM = YPCPAM + LAPRAM - WkCPAM                        MD050018
     C                   ELSE                                                               MD050018
     C                   EVAL      YPDINT = YPDINT + LAPRAM - WkDINT                        MD050018
     C                   ENDIF                                                              MD050018
     C                   ENDIF                                                              MD050018
     C                   CALLB     'ZAGENTMSTM'                                             MD050018
     C                   PARM                    YPTMST                                     MD050018
     C                   UPDATE    LEPDUED6                                                 MD050018
     C                   ENDIF                                                              MD050018
      *                                                                                     MD050018
     C                   ENDIF                                                              MD050018
      *                                                                                     MD050018
     C                   ENDSR                                                              MD050018
      *****************************************************************                     MD050018
      /EJECT                                                                                MD050018
      *****************************************************************                     MD050018
      * SrLEPDUFIns - Update of LEPDUFPD on ic for insert             *                     MD050018
      * Called by: SrUpdPDCL                                          *                     MD050018
      * Calls    : None                                               *                     MD050018
      *****************************************************************                     MD050018
     C     SrLEPDUFIns   BEGSR                                                              MD050018
      *                                                                                     MD050018
     C                   CLEAR                   LEPDUFD0                                   MD050018
      *                                                                                     MD050018
     C                   EVAL      WkReci = 'D'                                             MD050018
     C     KLEPDUF1      CHAIN     LEPDUFLA                                                 MD050018
     C                   IF        %FOUND(LEPDUFLA)                                         MD050018
      ** Update 'D' record                                                                  MD050018
     C                   EVAL      YPCPAM = YPCPAM + LAPRAM                                 MD050018
     C                   UPDATE    LEPDUFD0                                                 MD050018
      *                                                                                     MD050018
      ** Insert 'P' record                                                                  MD050018
     C                   EVAL      YRECI = 'P'                                              MD050018
     C                   EVAL      YPLON = LALNRF                                           MD050018
     C                   Z-ADD     LO_VDAT       YVDAT                                      MD050018
     C                   Z-ADD     LAPRAM        YPCPAM                                     MD050018
     C                   EVAL      YTKPACL = *BLANKS                                        MD050018
     C                   EVAL      YTKPABR = *BLANKS                                        MD050018
     C                   Z-ADD     0             YTKPAAC                                    MD050018
     C                   Z-ADD     0             YTKPASE                                    MD050018
     C                   EVAL      YTKPACY = *BLANKS                                        MD050018
     C                   EVAL      YDECRE = 'N'                                             MD050018
     C                   Z-ADD     LAVDAT        YPDVDT                                     MD050018
     C                   Z-ADD     WRNDAY        YLCD                                       MD050018
     C                   EVAL      YTYLC = 'I'                                              MD050018
     C                   EVAL      YPIUSE = LAIUSR                                          MD050018
     C                   EVAL      YPCBIC = 'I'                                             MD050018
     C                   Z-ADD     LAPRAM        YPOREP                                     MD050018
     C                   EVAL      YPFRNT = LAFRNT                                          MD050018
     C                   CALLB     'ZAGENTMSTM'                                             MD050018
     C                   PARM                    YPTMST                                     MD050018
     C                   WRITE     LEPDUFD0                                                 MD050018
                                                                                            MD050018
     C                   ENDIF                                                              MD050018
     C                   ENDSR                                                              MD050018
      *****************************************************************                     MD050018
      /EJECT                                                                                MD050018
      *****************************************************************                     MD050018
      * SrLEPDUFDelAmd - Update of LEPDUFPD on ic for amend and delete*                     MD050018
      * Called by: SrUpdPDCL                                          *                     MD050018
      * Calls    : None                                               *                     MD050018
      *****************************************************************                     MD050018
     C     SrLEPDUFDelAmdBEGSR                                                              MD050018
      *                                                                                     MD050018
      ** Update amount of 'P' record'                                                       MD050018
     C                   Z-ADD     0             WkCPAM                                     MD050018
     C     KLEPDUF2      SETLL     LEPDUFLE                                                 MD050018
     C     KLEPDUF2      READE     LEPDUFLE                               70                MD050018
     C                   DOW       *IN70 = *OFF                                             MD050018
     C                   IF        YPCPAM = WPRAM                                           MD050018
     C                   Z-ADD     YPCPAM        WkCPAM                                     MD050018
     C                   IF        DDACTN = 'R'                                             MD050018
     C                   DELETE    LEPDUFDE                                                 MD050018
     C                   ELSE                                                               MD050018
     C                   Z-ADD     LAPRAM        YPCPAM                                     MD050018
     C                   Z-ADD     LAPRAM        YPOREP                                     MD050018
     C                   UPDATE    LEPDUFDE                                                 MD050018
     C                   ENDIF                                                              MD050018
      *                                                                                     MD050018
      ** Update amount of 'D' record                                                        MD050018
     C                   EVAL      WkReci = 'D'                                             MD050018
     C     KLEPDUF1      CHAIN     LEPDUFLA                                                 MD050018
     C                   IF        %FOUND(LEPDUFLA)                                         MD050018
     C                   IF        DDACTN = 'R'                                             MD050018
     C                   EVAL      YPCPAM = YPCPAM - WkCPAM                                 MD050018
     C                   ELSE                                                               MD050018
     C                   EVAL      YPCPAM = YPCPAM + LAPRAM - WkCPAM                        MD050018
     C                   ENDIF                                                              MD050018
     C                   UPDATE    LEPDUFD0                                                 MD050018
     C                   ENDIF                                                              MD050018
     C                   LEAVE                                                              MD050018
     C                   ENDIF                                                              MD050018
     C     KLEPDUF2      READE     LEPDUFLE                               70                MD050018
     C                   ENDDO                                                              MD050018
     C                   ENDSR                                                              MD050018
      *****************************************************************                     MD050018
      /EJECT                                                                                  CAS011
      *****************************************************************                      BUG3760
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Program parameters
     C     *ENTRY        PLIST

      ** Return code
     C                   PARM                    @@RTCD            7

      ** Action requested
     C                   PARM                    DDACTN            1

      ** Externally described DS for valid loan amendment
     C                   PARM                    ValidLoam

      * Calling module code
     C                   PARM                    CallModCod        3

      ** Reservation ID (input from VU only)
     C                   PARM                    ReservId         10

      * Features
     C                   PARM                    CDE001            1
     C                   PARM                    CDE005            1
     C                   PARM                    CEU004            1
     C                   PARM                    CEU020            1
     C                   PARM                    CLE002            1
     C                   PARM                    CLE005            1
     C                   PARM                    CLE009            1
     C                   PARM                    CLE014            1
     C                   PARM                    CLE023            1
     C                   PARM                    CLE030            1                          CLE030

      * Authorise amends / authorise principal tfr / consolidated conf.
     C                   PARM                    BPLMAU            1
     C                   PARM                    BPTPAU            1
     C                   PARM                    BPCONR            1

      ** Date format indicator, local currency & run day number
     C                   PARM                    BJDFIN            1
     C                   PARM                    BJLCCY            3
     C                   PARM                    WRNDAY            5 0

      ** Multi-branching
     C                   PARM                    BGMBIN            1

      * Which system is active (24x7)
     C                   PARM                    System            1
      *
      ** Initialise program name
     C                   MOVEL     'LELOAMUPD'   DBPGM
      *
      ** Klist's
      *
     C     KLAKEY        KLIST
     C**********         KFLD                    WKLNR             6 0                        CLE148
     C                   KFLD                    WKLNR             6                          CLE148
     C                   KFLD                    WKVDT             5 0
     C                   KFLD                    WKLSN             3 0
      *
     C     KLKEY         KLIST
     C                   KFLD                    WKLNR
     C                   KFLD                    WRCDT             1
      *
     C     KFCLT         KLIST
     C**********         KFLD                    WFCNM             6 0                        CSD027
     C                   KFLD                    WFCNM             6                          CSD027
     C                   KFLD                    WFACT             3 0
     C                   KFLD                    WFNUM             2 0
     C                   KFLD                    WFRTP             1
      *
     C     KIDXF         KLIST
     C**********         KFLD                    WKLOAN            6 0                        CLE148
     C                   KFLD                    WKLOAN            6                          CLE148
     C                   KFLD                    WKDAY             5 0
     C                   KFLD                    WKSEQN            3 0
      *
     C     WKFEE         KLIST
     C**********         KFLD                    WFCNM             6 0                        CSD027
     C                   KFLD                    WFCNM             6                          CSD027
     C                   KFLD                    WFFACL            5 0
     C**********         KFLD                    WFLOAN            6 0                        CLE148
     C                   KFLD                    WFLOAN            6                          CLE148
                                                                                            MD023203
     C     WKFEEX        KLIST                                                              MD023203
     C                   KFLD                    WFCNUMX           6                        MD023203
     C                   KFLD                    WFFACLX           5 0                      MD023203
     C                   KFLD                    WFLOANX           6                        MD023203
     C                   KFLD                    WFSEQNX           2 0                      MD023203
                                                                                              CRE020
      ** Midas RE Settled Transaction Index File Key Lists                                    CRE020
                                                                                              CRE020
     C     KADVC         KLIST                                                                CRE020
     C                   KFLD                    KRefNo                                       CRE020
     C                   KFLD                    KPrgMn                                       CRE020
     C                   KFLD                    KSeqNo                                       CRE020
      *                                                                                      BUG3760
     C     KCwFld        KLIST                                                               BUG3760
     C                   KFLD                    WFuncType                                   BUG3760
     C                   KFLD                    WIdntifier                                  BUG3760
     C                   KFLD                    WBranch                                     BUG3760
      *                                                                                     MD050018
     C     KLEPDUE1      KLIST                                                              MD050018
     C                   KFLD                    LALNRF                                     MD050018
     C                   KFLD                    LAVDAT                                     MD050018
     C                   KFLD                    WkLASN                                     MD050018
     C     KLEPDUE2      KLIST                                                              MD050018
     C                   KFLD                    WkReci                                     MD050018
     C                   KFLD                    LALNRF                                     MD050018
     C                   KFLD                    WkPDCT                                     MD050018
     C     KLEPDUF1      KLIST                                                              MD050018
     C                   KFLD                    WkReci                                     MD050018
     C                   KFLD                    LALNRF                                     MD050018
     C     KLEPDUF2      KLIST                                                              MD050018
     C                   KFLD                    LALNRF                                     MD050018
     C                   KFLD                    LAVDAT                                     MD050018
      **********                                                                   MD024342 MD025467
     C*****KAPILST       KLIST                                                     MD024342 MD025467
     C**********         KFLD                    WAPIC             4               MD024342 MD025467
     C**********         KFLD                    WFILN            10               MD024342 MD025467
      *                                                                                     MD021423
      ** Get MPHAS dataarea.                                                                MD021423
      *                                                                                     MD021423
     C     *DTAARA       DEFINE                  MPHAS                                      MD021423
     C                   IN        MPHAS                                                    MD021423
     C                   UNLOCK    MPHAS                                                    MD021423
      *                                                                                      BUG3760
     C                   EVAL      CobMode = 'N'                                           MD021423E
     C**********         IF        MPHAS <> 'A'                                   MD021423E MD025467
     C                   IF        MPHAS =  'C'                                             MD025467
     C                   EVAL      CobMode = 'Y'                                           MD021423E
     C                   ENDIF                                                             MD021423E
      *                                                                                    MD021423E
      ** Check if CSC011 is installed                                                        BUG3760
      *                                                                                      BUG3760
     C                   CALLB     'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*VERIFY'     POption                                     BUG3760
     C                   PARM      'CSC011'      PSard                                       BUG3760
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3760
      *                                                                                      BUG3760
      ** Database error                                                                      BUG3760
      *                                                                                      BUG3760
     C                   IF        (PRetCode <> '*NRF') and                                  BUG3760
     C                             (PRetCode <> *Blanks)                                     BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKEY = 'CSC011'                                          BUG3760
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBASE = 904                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        PRetCode = *Blanks                                        BUG3760
     C                   EVAL      CSC011 = 'Y'                                              BUG3760
     C                   IN        SC24X7                                                    BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      CSC011 = 'N'                                              BUG3760
     C                   ENDIF                                                               BUG3760
     C/COPY WNCPYSRC,LEH01193
      *                                                                                      BUG3760
     C                   IN        SDSTAT                                                    BUG3760
      *                                                                                      BUG3760
      ** Check if Compliance Watch Enhancement - Watch List Checking                         BUG3760
      ** (CSD015) is on.                                                                     BUG3760
      *                                                                                      BUG3760
     C                   EVAL      CSD015 = 'N'                                              BUG3760
      *                                                                                      BUG3760
     C                   CALLB     'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*VERIFY'     POption                                     BUG3760
     C                   PARM      'CSD015'      PSard                                       BUG3760
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3760
      *                                                                                      BUG3760
      ** Database error                                                                      BUG3760
      *                                                                                      BUG3760
     C                   IF        (PRetCode <> *BLANKS) AND                                 BUG3760
     C                             (PRetCode <> '*NRF   ')                                   BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKEY = 'CSD015'                                          BUG3760
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBASE = 907                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        PRetCode = *BLANKS                                        BUG3760
     C                   EVAL      CSD015 = 'Y'                                              BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
      ** Check if Concord Interface Development(CCF001) is installed.                        BUG3760
      *                                                                                      BUG3760
     C                   EVAL      CCF001 = 'N'                                              BUG3760
      *                                                                                      BUG3760
     C                   CALLB     'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*VERIFY'     POption                                     BUG3760
     C                   PARM      'CCF001'      PSard                                       BUG3760
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3760
      *                                                                                      BUG3760
      ** Database error                                                                      BUG3760
      *                                                                                      BUG3760
     C                   IF        (PRetCode <> *BLANKS) AND                                 BUG3760
     C                             (PRetCode <> '*NRF   ')                                   BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKEY = 'CCF001'                                          BUG3760
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBASE = 910                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        PRetCode = *BLANKS                                        BUG3760
     C                   EVAL      CCF001 = 'Y'                                              BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        CSD015 = 'Y'                                              BUG3760
      *                                                                                      BUG3760
      **  Access Compliance Watch Configuration file.                                        BUG3760
      *                                                                                      BUG3760
     C                   CALLB     'AOCWCDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*FIRST'      POption                                     BUG3760
     C     SDCWCD        PARM      SDCWCD        DSFDY                                       BUG3760
      *                                                                                      BUG3760
      ** Database Error                                                                      BUG3760
      *                                                                                      BUG3760
     C                   IF        PRetCode <> *BLANKS                                       BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKEY = POption                                           BUG3760
     C                   EVAL      DBFILE = 'SDCWCDPD'                                       BUG3760
     C                   EVAL      DBASE = 909                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
      **  Check if function code is being monitored by compliance watch.                     BUG3760
      *                                                                                      BUG3760
     C                   CALLB     'AOWLCCR0'                                                BUG3760
     C                   PARM      *BLANKS       PRetCode                                    BUG3760
     C                   PARM      '*KEY    '    POption                                     BUG3760
     C                   PARM      'LENDING '    PFunc                                       BUG3760
     C     SDWLCC        PARM      SDWLCC        DSFDY                                       BUG3760
      *                                                                                      BUG3760
      ** Database Error                                                                      BUG3760
      *                                                                                      BUG3760
     C                   IF        PRetCode <> *BLANKS                                       BUG3760
     C                             AND PRetCode <> '*NRF'                                    BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKEY = PFunc                                             BUG3760
     C                   EVAL      DBFILE = 'SDWLCCPD'                                       BUG3760
     C                   EVAL      DBASE = 908                                               BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
      *
      ** Retrieve local currency details
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*BLANK  '    @RtCd
     C                   PARM      '*KEY    '    @Optn
     C                   PARM      BJLCCY        @Curr             3
     C     SDCURR        PARM                    DSSDY
      *
     C     @RtCd         IFNE      *BLANKS
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   Z-ADD     2             DBASE                          * DBERR 02 *
     C                   MOVEL     BJLCCY        DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CLE025
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
     C                   Z-ADD     32            DBASE                                        CLE025
     C                   EXSR      *PSSR                                                      CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
     C                   IF        PRTCD = *BLANKS                                            CLE025
     C                   MOVE      'Y'           CLE025                                       CLE025
     C                   ENDIF                                                                CLE025
      *
     C                   Z-ADD     A6TXND        TNOTL             1 0
      *
      ** If CLE009 is installed, fill currency and their corresponding
      ** telex notice days arrays
     C     CLE009        IFEQ      'Y'
     C                   Z-ADD     0             X                 3 0
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C                   PARM                    @Curr             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RtCd         DOWNE     '*EOF    '
     C                   ADD       1             X
     C                   MOVE      A6CYCD        CYA(X)
     C                   MOVE      A6TXND        TND(X)
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*NEXT  '     @Optn
     C                   PARM                    @Curr             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C                   ENDDO
      *
     C                   ENDIF

     C                   EVAL      @RTCD = *BLANKS

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
     C                   EXSR      *PSSR                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
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
     C                   IF        PRtCd = *BLANKS                                            CRE020
     C                   MOVEL     PCurSet01     WPrtAdv                                      CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        PRtCd <> '*NRF'                                            CRE020
     C     *LOCK         IN        LDA                                                        CRE020
     C                   EVAL      DBFile = 'SDSVALPD'                                        CRE020
     C                   EVAL      DBase = 101                                                CRE020
     C                   EVAL      DBKey = PSysVal01                                          CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      *PSSR                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CLE031
      ** Check if CLE031 is enabled.                                                          CLE031
                                                                                              CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       PRtCd                                        CLE031
     C                   PARM      '*VERIFY'     POptn                                        CLE031
     C                   PARM      'CLE031'      PSARD                                        CLE031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE031
                                                                                              CLE031
     C                   EVAL      CLE031 = 'N'                                               CLE031
                                                                                              CLE031
     C                   IF        PRtCd = *BLANKS                                            CLE031
     C                   EVAL      CLE031 = 'Y'                                               CLE031
     C                   ELSE                                                                 CLE031
                                                                                              CLE031
     C                   IF        PRtCd <> '*NRF'                                            CLE031
     C     *LOCK         IN        LDA                                                        CLE031
     C                   EVAL      DBFile = 'SCSARDPD'                                        CLE031
     C                   EVAL      DBase = 102                                                CLE031
     C                   EVAL      DBKey = 'CLE031'                                           CLE031
     C                   OUT       LDA                                                        CLE031
     C                   EXSR      *PSSR                                                      CLE031
     C                   ENDIF                                                                CLE031
                                                                                              CLE031
     C                   ENDIF                                                                CLE031
                                                                                             BUG8241
      ***Check*if*enhancement*CSC024*(Open*Month*End)*is*on                           BUG8241 CSC054
      ** Check if enhancement CSC024 (Period End Adjustments) is on                           CSC054
                                                                                             BUG8241
     C                   CALLB     'AOSARDR0'                                                BUG8241
     C                   PARM      *BLANKS       PRtCd                                       BUG8241
     C                   PARM      '*VERIFY'     POptn                                       BUG8241
     C**********         PARM      'CSC024'      PSARD                                BUG8241 CSC054
     C                   PARM      'CSC054'      PSARD                                        CSC054
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG8241
                                                                                             BUG8241
     C                   IF        PRtCd  <> *BLANKS AND                                     BUG8241
     C                             PRtCd  <> '*NRF   '                                       BUG8241
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG8241
     C**********         EVAL      DBKey  = 'CSC024'                                  BUG8241 CSC054
     C                   EVAL      DBKey  = 'CSC054'                                          CSC054
     C                   EVAL      DBase  = 1                                                BUG8241
     C                   EXSR      *PSSR                                                     BUG8241
     C                   ENDIF                                                               BUG8241
                                                                                             BUG8241
     C**********         EVAL      CSC024 = 'N'                                       BUG8241 CSC054
     C**********         EVAL      WOMEInd = 'N'                                      BUG8241 CSC054
     C                   EVAL      CSC054 = 'N'                                               CSC054
     C                   EVAL      WPEAInd = 'N'                                              CSC054
                                                                                             BUG8241
     C                   IF        PRtCd = *BLANKS                                           BUG8241
     C**********         EVAL      CSC024 = 'Y'                                       BUG8241 CSC054
     C                   EVAL      CSC054 = 'Y'                                               CSC054
                                                                                             BUG8241
      ** Access System values                                                                BUG8241
                                                                                             BUG8241
     C                   CALL      'AOSVALR0'                                                BUG8241
     C                   PARM      *BLANKS       PRetCode                                    BUG8241
     C**********         PARM      PSysValOME    PSysVal01                            BUG8241 CSC054
     C                   PARM      PSysValPEA    PSysVal01                                    CSC054
     C                   PARM      *BLANKS       PCurSet01                                   BUG8241
     C                   PARM      *BLANKS       PSysVal02                                   BUG8241
     C                   PARM      *BLANKS       PCurSet02                                   BUG8241
     C                   PARM      *BLANKS       PSysVal03                                   BUG8241
     C                   PARM      *BLANKS       PCurSet03                                   BUG8241
     C                   PARM      *BLANKS       PSysVal04                                   BUG8241
     C                   PARM      *BLANKS       PCurSet04                                   BUG8241
     C                   PARM      *BLANKS       PSysVal05                                   BUG8241
     C                   PARM      *BLANKS       PCurSet05                                   BUG8241
     C                   PARM      *BLANKS       PSysVal06                                   BUG8241
     C                   PARM      *BLANKS       PCurSet06                                   BUG8241
     C                   PARM      *BLANKS       PSysVal07                                   BUG8241
     C                   PARM      *BLANKS       PCurSet07                                   BUG8241
     C                   PARM      *BLANKS       PSysVal08                                   BUG8241
     C                   PARM      *BLANKS       PCurSet08                                   BUG8241
     C                   PARM      *BLANKS       PSysVal09                                   BUG8241
     C                   PARM      *BLANKS       PCurSet09                                   BUG8241
     C                   PARM      *BLANKS       PSysVal10                                   BUG8241
     C                   PARM      *BLANKS       PCurSet10                                   BUG8241
                                                                                             BUG8241
     C                   IF        PRetCode  <> *BLANKS                                      BUG8241
     C                   EVAL      DBFile = 'SDSVALPD'                                       BUG8241
     C                   EVAL      DBKEy = '*KEY   '                                         BUG8241
     C                   EVAL      DBase = 2                                                 BUG8241
     C                   EXSR      *PSSR                                                     BUG8241
     C                   ENDIF                                                               BUG8241
                                                                                             BUG8241
     C                   IF        PCurSet01 = 'Y'                                           BUG8241
     C*********          EVAL      WOMEInd = 'Y'                                      BUG8241 CSC054
     C                   EVAL      WPEAInd = 'Y'                                              CSC054
     C                   ENDIF                                                               BUG8241
     C                   ENDIF                                                               BUG8241
                                                                                              CAS011
      ** Determine if SAR CAS009 is installed                                                 CAS011
                                                                                              CAS011
     C                   CALL      'AOSARDR0'                                                 CAS011
     C                   PARM      *BLANKS       PRTCD                                        CAS011
     C                   PARM      '*VERIFY '    POPTN                                        CAS011
     C                   PARM      'CAS009'      PSARD                                        CAS011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS011
                                                                                              CAS011
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CAS011
     C     *LOCK         IN        LDA                                                        CAS011
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAS011
     C                   EVAL      DBase = 102                                                CAS011
     C                   EVAL      DBKey = 'CAS009'                                           CAS011
     C                   OUT       LDA                                                        CAS011
     C                   EXSR      *PSSR                                                      CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
     C                   IF        PRTCD = *BLANKS                                            CAS011
     C                   EVAL      CAS009 = 'Y'                                               CAS011
     C                   ELSE                                                                 CAS011
     C                   EVAL      CAS009 = 'N'                                               CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
      ** Access object for Hedge ICD                                                          CAS011
                                                                                              CAS011
     C                   IF        CAS009 = 'Y'                                               CAS011
     C                   CALL      'AOHEDGR0'                                                 CAS011
     C                   PARM      *BLANKS       PRTCD                                        CAS011
     C                   PARM      '*VERIFY '    POPTN                                        CAS011
     C     SDHEDG        PARM      SDHEDG        DSFDY                                        CAS011
                                                                                              CAS011
     C                   IF        PRTCD <> *BLANKS                                           CAS011
     C     *LOCK         IN        LDA                                                        CAS011
     C                   EVAL      DBFile = 'SDHEDGPD'                                        CAS011
     C                   EVAL      DBase = 103                                                CAS011
     C                   EVAL      DBKey = POPTN                                              CAS011
     C                   OUT       LDA                                                        CAS011
     C                   EXSR      *PSSR                                                      CAS011
     C                   ENDIF                                                                CAS011
     C                   ENDIF                                                                CAS011
      ** Determine if SAR CAS016 is installed                                                 CAS019
                                                                                              CAS019
     C                   CALL      'AOSARDR0'                                                 CAS019
     C                   PARM      *BLANKS       PRTCD                                        CAS019
     C                   PARM      '*VERIFY '    POPTN                                        CAS019
     C                   PARM      'CAS016'      PSARD                                        CAS019
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS019
                                                                                              CAS019
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CAS019
     C     *LOCK         IN        LDA                                                        CAS019
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAS019
     C                   EVAL      DBase = 104                                                CAS019
     C                   EVAL      DBKey = 'CAS016'                                           CAS019
     C                   OUT       LDA                                                        CAS019
     C                   EXSR      *PSSR                                                      CAS019
     C                   ENDIF                                                                CAS019
                                                                                              CAS019
     C                   IF        PRTCD = *BLANKS                                            CAS019
     C                   EVAL      CAS016 = 'Y'                                               CAS019
     C                   ELSE                                                                 CAS019
     C                   EVAL      CAS016 = 'N'                                               CAS019
     C                   ENDIF                                                                CAS019
                                                                                              CAS019
      ** Check if CLE073 - Calculation of loan based fees is installed                        CLE073
                                                                                              CLE073
     C                   CALL      'AOSARDR0'                                                 CLE073
     C                   PARM      *BLANKS       @RTCD                                        CLE073
     C                   PARM      '*KEY    '    @OPTN                                        CLE073
     C                   PARM      'CLE073'      @SARD             6                          CLE073
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE073
                                                                                              CLE073
     C     @RTCD         IFEQ      *BLANKS                                                    CLE073
     C                   MOVEL     'Y'           CLE073                                       CLE073
     C                   ELSE                                                                 CLE073
     C                   MOVEL     'N'           CLE073            1                          CLE073
     C                   ENDIF                                                                CLE073
                                                                                              CLE073
                                                                                              CLE134
      ** Check if CLE134 is ON                                                                CLE134
                                                                                              CLE134
     C                   MOVE      'N'           CLE134            1                          CLE134
     C                   CALLB     'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANKS       PRtCd                                        CLE134
     C                   PARM      '*VERIFY'     POptn                                        CLE134
     C                   PARM      'CLE134'      PSARD                                        CLE134
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE134
                                                                                              CLE134
     C                   IF        PRtCd = *BLANKS                                            CLE134
     C                   EVAL      CLE134 = 'Y'                                               CLE134
      *                                                                                     MD050018
      ** Access system values to check PDCL Projected acct movements on ic                  MD050018
     C                   CALL      'AOSVALR0'                                               MD050018
     C                   PARM      *BLANKS       PRetCode                                   MD050018
     C                   PARM      PSysValPIAC   PSysVal01                                  MD050018
     C                   PARM      *BLANKS       PCurSet01                                  MD050018
     C                   PARM      *BLANKS       PSysVal02                                  MD050018
     C                   PARM      *BLANKS       PCurSet02                                  MD050018
     C                   PARM      *BLANKS       PSysVal03                                  MD050018
     C                   PARM      *BLANKS       PCurSet03                                  MD050018
     C                   PARM      *BLANKS       PSysVal04                                  MD050018
     C                   PARM      *BLANKS       PCurSet04                                  MD050018
     C                   PARM      *BLANKS       PSysVal05                                  MD050018
     C                   PARM      *BLANKS       PCurSet05                                  MD050018
     C                   PARM      *BLANKS       PSysVal06                                  MD050018
     C                   PARM      *BLANKS       PCurSet06                                  MD050018
     C                   PARM      *BLANKS       PSysVal07                                  MD050018
     C                   PARM      *BLANKS       PCurSet07                                  MD050018
     C                   PARM      *BLANKS       PSysVal08                                  MD050018
     C                   PARM      *BLANKS       PCurSet08                                  MD050018
     C                   PARM      *BLANKS       PSysVal09                                  MD050018
     C                   PARM      *BLANKS       PCurSet09                                  MD050018
     C                   PARM      *BLANKS       PSysVal10                                  MD050018
     C                   PARM      *BLANKS       PCurSet10                                  MD050018
                                                                                            MD050018
     C                   IF        PRetCode  <> *BLANKS                                     MD050018
     C                   EVAL      DBFile = 'SDSVALPD'                                      MD050018
     C                   EVAL      DBKEy = '*KEY   '                                        MD050018
     C                   EVAL      DBase = 40                                               MD050018
     C                   EXSR      *PSSR                                                    MD050018
     C                   ELSE                                                               MD050018
     C                   EVAL      WKPIAC = PCurSet01                                       MD050018
     C                   ENDIF                                                              MD050018
      *                                                                                     MD050018
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      *
      ** Determine if CAR CLE055 is installed>                                                CLE055
      ** Do this is if authorisation is required to be performed.                             CLE055
      *                                                                                       CLE055
     C********           IF        CLE002 = 'Y'                                        CLE055 243415
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
     C     *LOCK         IN        LDA                                                        CLE055
     C                   EVAL      DBFile = 'SCSARDPD'                                        CLE055
     C                   EVAL      DBase = 69                                                 CLE055
     C                   EVAL      DBKey = 'CLE055'                                           CLE055
     C                   OUT       LDA                                                        CLE055
     C                   EXSR      *PSSR                                                      CLE055
     C                   ENDIF                                                                CLE055
      *                                                                                       CLE055
     C                   IF        PRetCode = *BLANKS                                         CLE055
     C                   EVAL      CLE055 = 'Y'                                               CLE055
     C                   ELSE                                                                 CLE055
     C                   EVAL      CLE055 = 'N'                                               CLE055
     C                   ENDIF                                                                CLE055
      *                                                                                       CLE055
     C********           ENDIF                                                         CLE055 243415
      *                                                                                       CLE055
      ** Check if Watch List Element (CSD083) is on                                           CSD083
      *                                                                                       CSD083
     C                   CALL      'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRetCode                                     CSD083
     C                   PARM      '*VERIFY'     POption                                      CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRetCode <> *BLANKS  and                                   CSD083
     C                             PRetCode <> '*NRF   '                                      CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBase = 70                                                 CSD083
     C                   EVAL      DBKey = 'CSD083'                                           CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRetCode = *BLANKS                                         CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
      *                                                                                     MD024342
     C                   MOVEL     'N'           MTHREAD           1                        MD024342
     C**********         MOVE      'LOAM'        WAPIC                             MD024342 MD025467
     C**********         MOVEL     'LOAMSZ1'     WFILN                             MD024342 MD025467
     C**********         IF        MPHAS = 'A' AND                                 MD024342 MD025467
     C                   IF        MPHAS <> 'C' AND                                         MD025467
     C                             W#FRNT <> 'LE000473'                                     MD024342
     C                   MOVEL     'Y'           MTHREAD                                    MD025467
     C*****KAPILST       CHAIN     SDAPDRL0                           99           MD024342 MD025467
     C******IN99         IFEQ      '0'                                             MD024342 MD025467
     C**********         MOVEL     A8MULT        MTHREAD                           MD024342 MD025467
     C**********         ENDIF                                                     MD024342 MD025467
     C                   ENDIF                                                              MD024342
                                                                                              CSD083
     C                   ENDSR
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
     C                   EVAL      VRAF = 0                                                 MD024342
     C                   EVAL      VRAL = 0                                                 MD024342
     C                   EVAL      VRRF = 0                                                 MD024342
     C                   EVAL      VRRL = 0                                                 MD024342
      *                                                                                     MD024342
     C                   ENDSR                                                              MD024342
      ****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      ********************************************************************

      ** Output LTRIX header record
     O*LTRIX**** E            LTRIXH                                                        AR322732
     O**********             NORE                11P                                        Bug03936
     O**********             NORELX              11P                               Bug03936 AR322732
     O**********             RRNA                20P                                        AR322732
     O**********             NLAR                32P                                        AR322732
     O**********             LATNLU              40P                                        AR322732
      *
      ** Output LTRIX detail record
     O**********E            LTRIXD                                                         AR322732
     OLTRIX     EADD         LTRIXD                                                         AR322732
     O                                            2 'DA'
     O                       LALNRF               8
     O                       LAVDAT              13
     O                       LALASN              16
     O                       CHTP                17
     O**********                                 18 'N'                                     BUG23026
     O**********                                 18 'Y'                            BUG23026 AR876299
     O                                           18 'N'                                     AR876299
     O                                           19 'N'
     O                                           25 '00001'
     O                                           26 'N'
     O                       PRI1                27
     O                       LABRCA              34
     O                       RRNA                37P
     O                       LATNLU              40P
     O                                           43 '000'                                   AR322732
     O                                           44 ' '                                     AR322732
     O                                           45 ' '                                     AR322732
      ********************************************************************
      /EJECT
      ********************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2002
**CTDATA CWA - Array for watch list fields                                                   BUG3760
<Receipt Nostro>                                                                             BUG3760
</Receipt Nostro>                                                                            BUG3760
<Receipt Intermed Bank>                                                                      BUG3760
</Receipt Intermed Bank>                                                                     BUG3760
<Receipt Ordering Bank>                                                                      BUG3760
</Receipt Ordering Bank>                                                                     BUG3760
<Receipt Ordering Cust>                                                                      BUG3760
</Receipt Ordering Cust>                                                                     BUG3760
<Payment Nostro>                                                                             BUG3760
</Payment Nostro>                                                                            BUG3760
<Payment Intermed Bank>                                                                      BUG3760
</Payment Intermed Bank>                                                                     BUG3760
<Payment Ordering Bank>                                                                      BUG3760
</Payment Ordering Bank>                                                                     BUG3760
<Payment Ordering Cust>                                                                      BUG3760
</Payment Ordering Cust>                                                                     BUG3760
<Receiver Correspondent>                                                                     BUG3760
</Receiver Correspondent>                                                                    BUG3760
<Receiver>                                                                                   BUG3760
</Receiver>                                                                                  BUG3760
<Account With Bank>                                                                          BUG3760
</Account With Bank>                                                                         BUG3760
<Beneficiary>                                                                                BUG3760
</Beneficiary>                                                                               BUG3760
<Details Of Payment>                                                                         BUG3760
</Details Of Payment>                                                                        BUG3760
**CTDATA POWR
0000001
0000010
0000100
0001000
0010000
0100000
1000000
