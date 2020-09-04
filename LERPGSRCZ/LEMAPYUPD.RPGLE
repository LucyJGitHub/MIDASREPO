     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBI *  OVRDBF FILE(LOAMD) TOFILE(LOAMS) SHARE(*NO)                  *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Manual Repayments - Database update')         *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEMAPYUPD - Midas LE Manual Repayments - Database update     *
      *                                                               *
      *  Function:  This is the update function for the Manual        *
      *             Repayments                                        *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD055733           Date 03Jul20               *
      *  Prev Amend No. AR927395           Date 05Aug13               *
      *                 CER050             Date 16Jun19               *
      *                 MD054035           Date 03Sep19               *
      *                 MD054317           Date 09Sep19               *
      *                 CSD102             Date 08Jan19               *
      *                 MD047554           Date 11Oct17               *
      *                 MD051892           Date 22Sep18               *
      *                 CLE071             Date 18Jul18               *
      *                 MD049571           Date 06Feb18               *
      *                 MD046248           Date 27Oct17               *
      *                 AR1002234          Date 12Jan17               *
      *                 MD040186           Date 13Sep16               *
      *                 MD045010           Date 05Apr17               *
      *                 AR943686           Date 23Sep16               *
      *                 CLE141A            Date 28Apr16               *
      *                 CLE141             Date 08Feb16               *
      *                 CLE164             Date 28Nov14               *
      *                 MD029048           Date 27Oct14               *
      *                 MD024398           Date 11May14               *
      *                 MD025467           Date 08May14               *
      *                 MD024342B          Date 08May14               *
      *                 MD024342           Date 08May14               *
      *                 MD023787           Date 29Apr14               *
      *                 MD022533           Date 25Sep13               *
      *                 AR868380           Date 19Jun13               *
      *                 MD020964           Date 19Jun13               *
      *                 MD020733           Date 14Jun13               *
      *                 MD020605           Date 10Jun13               *
      *                 MD020445A          Date 31May13               *
      *                 MD020445           Date 16May13               *
      *                 254634             Date 15Feb13               *
      *                 AR806351           Date 24Apr13               *
      *                 AR1080805          Date 25Feb13               *
      *                 AR628773           Date 01Aug12               *
      *                 264065             Date 01Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 AR322732           Date 23Jul12               *
      *                 CLE148             Date 23Jul12               *
      *                 264014             Date 31Jul12               *
      *                 CSC054             Date 23Feb12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER049             Date 06Dec10               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 AR787620           Date 10Jun11               *
      *                 CLE139             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CLE073             Date 13May08               *
      *                 262328             Date 30Oct09               *
      *                 AR702741           Date 02Feb11               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG23213           Date 16Mar09               *
      *                 BUG23031           Date 26Feb09               *
      *                 260446             Date 26May09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG17200           Date 25Apr08               *
      *                 245177A            Date 19Mar07               *
      *                 CAS019             Date 20Apr07               *
      *                 244636             Date 14Feb07               *
      *                 245226             Date 01Feb07               *
      *                 243154             Date 23Oct06               *
      *                 242276             Date 27Sep06               *
      *                 BUG12002           Date 15Sep06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12669           Date 15Nov06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 237242             Date 12Jun06               *
      *                 BUG11240           Date 23May06               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9225            Date 16Nov05               *
      *                 BUG8956            Date 23Sep05               *
      *                 BUG8458            Date 05Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE031             Date 03Feb03               *
      *                 BUG7348            Date 23Sep05               *
      *                 CAS011             Date 16May05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSC024             Date 07Feb05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6223            Date 15Mar05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4513            Date 25Nov04               *
      *                 BUG4774            Date 10Nov04               *
      *                 BUG4325            Date 21Oct04               *
      *                 BUG4774            Date 08Nov04               *
      *                 BUG3114            Date 09Aug04               *
      *                 BUG3829            Date 28Jul04               *
      *                 BUG3760            Date 30Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CRE020             Date 20Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 11Oct02               *
      *                 CDE005             Date 23Sep02               *
      *                 CAP077  *CREATE    Date 17Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD055733 - COB: Multiple UTCHOBJEX calls in LEC06A           *
      *             components.                                       *
      *           - Redeliver of MD050139.                            *
      *  AR927395 - Wrong COF repayment when loan had rate changes.   *
      *             Compute corresponding COFA when PD interest is    *
      *             paid off. (Child: AR927398)                       *
      *  CER050 - Annualised Percentage Rate (Recompile)              *       
      *  MD054035 - Prevent file locking of LEFEED                    *
      *  MD054317 - PDCL X not generated for freq based repayment     *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD047554 - Create shadow postings of INTEREST and MATURITY   *
      *             with recalculated amount based on newly inserted, *
      *             amended, or reversed MR. Call LE2041 and include  *
      *             current value of principal amount OPRAM as one of *
      *             the parameters.                                   *
      *  MD051892 - Proj settlement amnt calculated at defaulted rate *
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD049571 - Value date of Manual Repayment in Projected       *
      *             Account movement is incorrect                     *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1002234 - FCOOB in LE0320 when an MR with a 13-digit       *
      *              amount is inserted (Child: AR1002235).           *
      *            - Applied for MD-42936                             *
      *  MD040186 - Processing alignment to adopt MD023787 changes.   *
      *             Do not create projected movement when MAPY receipt*
      *             settlement account and PDCL receipt settlement    *
      *             account are the same.                             *
      *  MD045010 - Component LEC06A 10008 looping during COB caused  *
      *             by CGL184. Recompile due to changes in ZFRQB3.    *
      *  AR943686 - CLE031: System generating wrong projected move-   *
      *             ment. Populate value of SCCY to convert amount    *
      *             to account currency. (Child: AR943687)            *
      *           - Applied for MD-40690                              *
      *  CLE141A - CLE141 Change Control 1                            *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           for Lending Transactions                            *
      *  CLE164 - CLE134 Enhancement F (Repayment Methodology)        *
      *  MD029048 - Default Receipt/Payment details for generated RE  *
      *             via MR.                                           *
      *  MD024398 - API Performance Optimisation                      *
      *  MD025467 - API locking issues Redesign Approach              *
      *  MD024342B - API issue. Trailer file allocation problem.      *
      *  MD024342 - LOAMSZ1 allocation problem                        *
      *  MD023787 - Posting for PDCL's PI and MR.                     *
      *  MD022533 - When a PDCL is created in I/C with field 'Dec-    *
      *             rease' = Y, a Manual Repayment event (MR) is auto *
      *             matically generated for the original loan         *
      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
      *             calling program if file locking occurred on       *
      *             online position files. (Child: AR868381)          *
      *  MD020964 - CLE134 Manual Repayment for PDCL not checking the *
      *             available balance                                 *
      *  MD020733 - CLE134_transfer to past due duplicated. Output    *
      *             record to LELOMKPD (same as LOAMSDK) when MR is   *
      *             created by PDCL generation in IC. Reuse UpSRFlg   *
      *             to check MR Autogen events from PDCL online.      *
      *  MD020605 - CLE134 Impossible to create PDCL in IC            *
      *  MD020445A - System should not allow negative repayment       *
      *              schedule amount.                                 *
      *  MD020445 - CLE134 CCR2 updated functionality                 *
      *  254634    - Loan MAPY reversal - Wrong display in Projected  *
      *              Settlement Account. Wrong shadow posting gene-   *
      *              rated if penalty <>0.                            *
      *            - Applied for AR1086540 (Child: AR1086541)         *
      *  AR806351 - Incorrect facility utilisation on OSFC. Prevent   *
      *             facility update of MR for interest and fee PDCL   *
      *             with FAMU = 'N'. (Child: AR806352)                *
      *  AR1080805 - Error in LEMAPYUPD                               *
      *  AR628773 - Wrong automatic interest PDCL increase            *
      *           - PDIN should never be negative.                    *
      *             (Child: AR628774)                                 *
      *  264065 - Wrong projected movements entries                   *
      *         - No adjustment on projections when amendments were   *
      *           inserted against the loan. Call LE2041 to reverse   *
      *           previous movements and repost adjusted movements.   *
      *  CLE134 - Past Due Call Loan Processing                       *
      *         - CC02: Manual Repayment Feature                      *
      *  AR322732 - LEC0212A and APISERVER locks LTRIX file.          *
      *           - Prevent LTRIX RRN 1 from being locked.            *
      *  CLE148 - Alpha Loan Reference                                *
      *  264014 - Incorrect update of trailer file when a manual      *
      *           repayment overpay a repayment schedule causing an   *
      *           FOOB in LE0370AU. Applied fix 259547 to properly    *
      *           update the trailer file.                            *
      *  CSC054 - Period End Adjustments                              *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - CCR016: Settlement Allocation                      *
      *  CER049 - Stamp Tax                                           *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,LEH00159                                 *
      *             WNCPYSRC,LEH00160                                 *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CLE073 - Calculated Loan Based Fees                          *
      *  262328 - Serious Midas error occurred. Increase size of @BIC *
      *           array from 150 to 900.                              *
      *  AR702741 - Include location as parameter in ZFREQB to        *
      *             determine the next settlement date                *
      *             (Child: AR702742)                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  BUG23213 - Error occurred in Reversing the Loan event -      *
      *             Repayment schedule                                *
      *  BUG23031 - Loan not showing repayment date and frequency     *
      *  260446 - Component LEC06A 10008 failed. Applied fix 259927.  *
      *           Re-initialise WAMTP during update.                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG17200 - Trigger Adjustment to Period for EIR/AC when an   *
      *             input is done                                     *
      *  245177A - Consider today's change in revolving credit        *
      *            indicator.                                         *
      *  CAS019 - Upgrade of CAS016 to Midas Plus                     *
      *  244636 - If no settlement details for a MAPY are entered     *
      *           then default settlement details from related loan   *
      *  245226 - Available amount on revolving credit facility is    *
      *         - Incorrect. Applied fix 204708 from LE2110.          *
      *  204708 - If loan is non-autosettle, update the availability  *
      *         - beyond the loan's maturity date.                    *
      *  243154 - FCOOB in LER140 due to incorrect LCHD               *
      *  242276 - Cannot insert Manual Repayment for past due loans.  *
      *           Modified BUG4325 and restored BUG11240.             *
      *  BUG12002 - Reverse 11240 - fix is incorrect                  *
      *  BUG12669 - Allow MAPY insert.                                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  237242 - QZDASOINIT caused 99.9% high CPU utilisation        *
      *  BUG11240 - Unable to Authorise and/or Reject newly inserted  *
      *             Manual Repayment, error msg LEM0102 displayed.    *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9225 - Update LESTALPD with correct loan amendment        *
      *            sequence number.                                   *
      *  BUG8956- LEHOSTPD and Shadow posting are not being updated   *
      *  BUG8458- Incorrect amount posted in LEHOSTPD for manual      *
      *           repayment                                           *
      *  CLE106 - Syndication Manager                                 *
      *  CLE031 - Lending Enhancements                                *
      *  BUG7348- Don't change last change type in authorise mode     *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CAP086 - Introduce Auto Authorisation to the API's           *
      *           without it                                          *
      *  CSC024 - Open Month End                                      *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6223 - Slow system response when doing MAPY               *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4513- CLBL in memos not updated for parts. sold payment   *
      *           settlement account.                                 *
      *  BUG4774- (Reopen) Past Due Amount PDIN on CLOANCL increased  *
      *           again when Manual Repayment is later authorised.    *
      *  BUG4325- Expected seq ESEQ wrong for call to RTV module.     *
      *  BUG4774- Past Due Amount PDIN on CLOANCL was not updated by  *
      *           an MR linked to a Past Due; check PD_AMTP instead.  *
      *  BUG3114- Missing Rule of 78s (CLE028) change in the Lending  *
      *           APIs as description in the amendment history.       *
      *  BUG3829 - Invalid 'Record updated by another workstation'    *
      *  BUG3760 - Compliance Watch (CSD015) changes missing from the *
      *            Lending APIs                                       *
      *  CLE025 - Credit Lines                                        *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Midas Plus API development                          *
      *  CDE005 - Reservation ID                                      *
      *  CAP077 - Lending API enhancements - Manual Repayments        *
      *                                                               *
      *****************************************************************
      *
      ***  Files
      *    =====
      *
     FCLOAN     UF   E           K DISK    INFSR(*PSSR)
      ***  Midas LE Loans details file
     F                                     COMMIT
     F                                     Include(CLOANCLF:CLOANCKF)
      *
     FLOAMD     IF   E           K DISK    INFSR(*PSSR)
      ***  Loan Amendments Retrieval Index
     F                                     RENAME(LOAMSDKF:LOAMSD)
     F                                     IGNORE(LOAMSDHF)
     F                                     IGNORE(LOAMSZ1F)
     F                                     Prefix (CurrPD_)
      *
     FLOAMS     UF A E           K DISK    INFSR(*PSSR)
      ***  Loan Amendments for Updating
     F                                     COMMIT
      *
     F***LTRIX**** UF   F   43        DISK    INFSR(*PSSR)                                  AR322732
     FLTRIX     O  A F   45        DISK    INFSR(*PSSR)                                     AR322732
      ***  Loan Transaction Index Detail
     F                                     COMMIT
     F                                     INFDS(FLDTX)
      *
     FFCLTY     UF   E           K DISK    INFSR(*PSSR)
      ***  Customer Lending Facility file
     F                                     COMMIT
     F                                     IGNORE(FCLTYHHF)
     F                                     IGNORE(FCLTYZZF)
      *
     FSDBRCHL5  IF   E           K DISK
      ***  SD Branch Codes by Customer Number
      *
     FLEFEEDL1  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
     FLEFEEDL0  UF   E           K DISK    INFSR(*PSSR)                                     MD054035
     F                                     COMMIT                                           MD054035
     F                                     RENAME(LEFEEDF:LEFEEDX)                          MD054035
     F                                     PREFIX(X_)                                       MD054035
      *                                                                                     MD054035
     FLEFELAL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** RE Settled Transaction Index File by Transaction Reference ID                        CRE020
      ** and Transaction Maintenance Program                                                  CRE020
     FREADVCL2  UF   E           K DISK    COMMIT                                             CRE020
     F                                     USROPN                                             CRE020
                                                                                              CRE020
     FSDCWHTL1  IF   E           K DISK                                                      BUG3760
      *                                                                                      BUG3760
      ** Compliance Watch Hit List                                                           BUG3760
      *                                                                                      BUG3760
     FLESTALLA  UF   E           K DISK    COMMIT                                            BUG9225
     F                                     PREFIX(XX)                                        BUG9225
      ** Midas LE Settlement Allocation by Parent PC Reference                               BUG9225
      *
     FLEEIRDL5  UF   E           K DISK    INFSR(*PSSR)                                       CAS011
     F                                     COMMIT                                             CAS011
                                                                                              CAS019
      ** Effective Interest Rate Details                                                      CAS019
     FLEEIRDL9  UF   E           K DISK    INFSR(*PSSR)                                       CAS019
     F                                     COMMIT                                             CAS019
     F                                     RENAME(LEEIRDD0:LEEIRDD9)                          CAS019
      ** Effective Interest Rate Details                                                      CAS019
     FLEERAPL1  UF   E           K DISK    INFSR(*PSSR)                                       CAS019
     F                                     COMMIT                                             CAS019
     FLEFCAML3  IF   E           K DISK                                                      245177A
     F                                     RENAME(LEFCAMPF:LEFCAMD3)                         245177A
     F***LOAMSLA   IF   E           K DISK                                           CLE134 MD020445
     F**********                           RENAME(LOAMSDKF:LOAMLA)                   CLE134 MD020445
                                                                                            MD020733
      ** Loan Amendments Detail File                                                        MD020733
     FLELOMKL3  UF A E           K DISK    COMMIT                                           MD020733
     F                                     INFSR(*PSSR)                                     MD020733
     F                                     IGNORE(LOAMSDHF)                                 MD020733
     F                                     RENAME(LOAMSDKF:LOMKSDKF)                        MD020733
     F                                     RENAME(LOAMSZ1F:LOMKSZ1F)                        MD020733
      **********                                                                   MD024342 MD025467
     F***SDAPDRL0  IF   E           K DISK    INFSR(*PSSR)                         MD024342 MD025467
      **********                                                                   MD024342 MD025467
      ***Midas*SD API Driving File                                                 MD024342 MD025467
     F***LOAMSZ1X  O    E             DISK    COMMIT                              MD024342B MD025467
     F**********                           RENAME(LOAMSZ1F:LOAMSZ1FX)             MD024342B MD025467
      ***API:*Midas LE LOAN AMENDS TRAILER                                        MD024342B MD025467
      *                                                                           MD024342B MD025467
      *****************************************************************
      *
      ***  Definition of Compile Time Arrays before Copyrights statement Array
      *
     D POWR            S              7  3 DIM(7) CTDATA PERRCD(1)              Ccy conversion
      ***  For CCy Conversion
      *
      ** CWA Array used in Midas Compliance Watch                                            BUG3760
      *                                                                                      BUG3760
     D CWA             S             25A   DIM(Elements) PERRCD(1) CTDATA                    BUG3760
      *                                                                                      BUG3760
      ** +--------------------------------------+
      **   Automatically included D-specs        
      **   ==============================        
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
      *
      **--------------------------------------------------------------------------------------------
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
      **   End of automatically included D-specs 
      **   ===================================== 
      ** +--------------------------------------+
      *
      *****************************************************************
      *
     D TimeStamp       S               Z
      ***  Timestamp for the loan
      *
      ***  Definition of RunTime Arrays
      *
     D*@BIC*****       S              6  0 DIM(150)                            Internal Custs CSD027
     D*@BIC*****       S              6    DIM(150)                                    CSD027 262328
     D @BIC            S              6    DIM(900)                                           262328
      *
     D CYA             S              3    DIM(150)
      ***  Currencies array
     D TND             S              1  0 DIM(150)
      *
     D LEVMAPY       E DS                  EXTNAME(LEVMAPYPD)
      ***  Externally DS for valid Manual Repayment
      *
     D CMapyFilFmt   E DS                  EXTNAME(LOAMSDK)
      ***  Manual Repayment in file format
      ***  Rename fields As Loans Amendment file to avoid unwritting
     D DBRecSttmt            335    389                                                     MD029048
     D DBPaySttmt            404    948                                                     MD029048
     D PCRFK                1040   1054
     D PCOBK                1055   1057
     D SCCYK                1061   1063
     D REXRK                1090   1096P 8                                                    CLE031
     D REXIK                1097   1097                                                       CLE031
     D PSCYK                1098   1100                                                       CLE031
     D PEXRK                1101   1107P 8                                                    CLE031
     D PEXIK                1108   1108                                                       CLE031
      *
     D OKFlagsDS     E DS                  EXTNAME(LEEMapyPD)
      ***  Flags to indicate whether transaction fields are valid
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  Data structure for bank details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ***  Currency details
      *
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
      ***  Customer lending ICD
      *
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      ***  Customer lending ICD
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ***  Branch details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  Module details
      *
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D QQACCD2       E                     EXTFLD(QQACCD)                                     CGL029
      ***  Data structure for bank details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D QQACCD1       E                     EXTFLD(QQACCD)                                     CGL029
      ***  Data structure for bank details
      *
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D QQACCD3       E                     EXTFLD(QQACCD)                                     CGL029
      ***  Data structure for bank details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCLCD         E                     EXTFLD(LCD)
      ***  Midas Feature details accessed via access program
      *
      *                                                                                      BUG3760
      ** External DS for Customer Details                                                    BUG3760
      *                                                                                      BUG3760
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                 BUG3760
     D QQDFAC2       E                     EXTFLD(QQDFAC)                                    BUG3760
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
     D*P1MFPD***     E DS                  EXTNAME(LEP1MFPD)                         CLE134 MD020445
     D*P1MFPDRONS    E                     EXTFLD(QQRONS)                            CLE134 MD020445
     D*P1MFPDPONS    E                     EXTFLD(QQPONS)                            CLE134 MD020445
     D*P2MFPD***     E DS                  EXTNAME(LEP2MFPD)                         CLE134 MD020445
      *                                                                                      BUG3760
      ** Compliance Engine Free Format String Parameter                                      BUG3760
      *                                                                                      BUG3760
     D PFreeFmtStr     S           9999A                                                     BUG3760
      *                                                                                      BUG3760
      ** Array Size Definition                                                               BUG3760
      *                                                                                      BUG3760
     D Elements        C                   CONST(26)                                         BUG3760
      *                                                                                      BUG3760
      ** Watch List Fields Array.                                                            BUG3760
      *                                                                                      BUG3760
     D WLF             S             18A   DIM(12)                                           BUG3760
     D CobMode         S              1A                                                    MD023787
      *                                                                                      BUG3760
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ***  Second DS for access programs, long data structure
      *
     D Z#BSTS        E DS                  EXTNAME(Z#BST)
     D Z#ASTS        E DS                  EXTNAME(Z#AST)
     D Z#WSTS        E DS                  EXTNAME(Z#WST)
     D CLONQD        E DS                  EXTNAME(LESTMP2PD)                                 CER049
      ***  Externally desc'd DS for screen Loans extension                                    CER049
      ***  work file of update to LE position files                                          BUG4513
     D Z#ASTK          DS          2048                                                      BUG4513
     D Z#BSTK          DS          2048                                                      BUG4513
                                                                                             BUG4513
      ** Data Structure for MPHAS Dataarea                                                  MD023787
                                                                                            MD023787
     D MPHAS           DS             1                                                     MD023787
                                                                                            MD023787
      ***  Shadow posting parameters
      *
     D LEALLO        E DS                  EXTNAME(LEALLO)
      ***  DS for calculating PC reference
      *
     D                 DS
      ***  Fields used for update of MEMOS, PRONO etc.
      *
     D  Z#ADTA                 1    256
     D  SHRECI                 1      1
     D  SHLNRF                 2      7
     D  SHVDAT                 8     12  0
     D  SHLASN                13     15  0
     D  SHPTYP                21     22
     D  SHAMTP                23     24
     D  SHCCY                 35     37
     D  SHPRAM                38     44P 0
     D  SHTAMT                66     72P 0
     D  SHBRCA                73     75
     D  SHREPT                82     82  0
     D  SHAUTO                83     83
     D***SHTIST*               85    118                                                      CGL029
     D  SHTIST                85    124                                                       CGL029
      *
     D  Z#ADTB               257    512
     D  SHOSBR               261    263
     D  SHCHTP               317    317
      *
     D  Z#ADTD               769   1024
     D  SHPNAM              1001   1007P 0
      *
     D  Z#ADTE              1025   1280
     D  SHSCCY              1061   1063
     D  SHICCY              1064   1066
     D  SHREXR              1090   1096P 8                                                    CLE031
     D  SHREXI              1097   1097                                                       CLE031
     D  SHPSCY              1098   1100                                                       CLE031
     D  SHPEXR              1101   1107P 8                                                    CLE031
     D  SHPEXI              1108   1108                                                       CLE031
     D   SHSTAL             1109   1109                                                      BUG9225
      *
     D Z#ADTH          DS                                                                     CLE134
     D  SHXRFI                        3A                                                      CLE134
     D  SHXRFN                       10S 0                                                    CLE134
                                                                                              CLE134
     D                 DS
      ***  Last change data - LOAMS
     D  WLCD                   1      5  0
     D  WCHTP                  6      6
     D  WTNLU                  7     11  0
     D  WLSTC                  1     11
      *
     D  OldSettlDS     DS
      ***  Old settlement details
      *
     D  OSETP                  1      2  0
     D  OOSAC                  3     20                                                       CGL029
     D  OTSEN                 21     30                                                       CGL029
     D  OFACO                 31     40                                                       CGL029
     D  OLDSET                 1     40                                                       CGL029
     D***OOSAC**                3     14                                                      CGL029
     D***OTSEN**               15     24                                                      CGL029
     D***OFACO**               25     34                                                      CGL029
     D***OLDSET*                1     34                                                      CGL029
     D  OSCCY                 41     43                                                     MD051892
     D  OREXR                 44     50P 8                                                  MD051892
     D  OREXI                 51     51                                                     MD051892
      *
     D  NewSettlDS     DS
      ***  New settlement details
      *
     D  WTYP                   1      2
     D  WOURS                  3     20                                                       CGL029
     D  WTHRS                 21     30                                                       CGL029
     D  WFACO                 31     40                                                       CGL029
     D  WSETT                  1     40                                                       CGL029
     D***WOURS**                3     14                                                      CGL029
     D***WTHRS**               15     24                                                      CGL029
     D***WFACO**               25     34                                                      CGL029
     D***WSETT**                1     34                                                      CGL029
     D  WSCCY                 41     43                                                     MD051892
     D  WREXR                 44     50P 8                                                  MD051892
     D  WREXI                 51     51                                                     MD051892
      *
     D PDateOutZ9      DS                                                                     CLE134
     D  VDATYr                 1      4  0                                                    CLE134
     D  VDATMn                 5      6  0                                                    CLE134
     D  VDATDy                 7      8  0                                                    CLE134
     D FLDTX           DS
      ***  Data Structure for PF/LTRIX
      *
     D  TXSTS            *STATUS
      *
     D Ix              S              3P 0
      ***  Index for arrays of of error message ids etc
      *
                                                                                              244636
      ** Parameter for LERPSCRTV to retrive Extended settlement intruction                    244636
     D***PRcvParm        S             92                                             244636 CSF011A
     D PRcvParm        S            335                                                      CSF011A
                                                                                              244636
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
      ***  Dummy message ID and message file fields for use on the calls to
      ***  ZAMSGTOOPR
      *
     D                 DS
     D  WPRME                  1     12
     D  LPFI                   1      1
     D**PTFC****               2      7  0                                                    CSD027
     D  PTFC                   2      7                                                       CSD027
     D  PTFT                   8     10  0
     D  PTFN                  11     12  0
      *
     D                 DS
      ***  Data structure of rundates
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
     D                                     DIM(10) ASCEND                       Fclty dates
      *
     D                 DS
      ***  Data structure of drawn amounts
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
     D                                     DIM(10)                              Fclty amounts
      *
     D                 DS
     D**WFCNUM**               1      6  0                                                    CSD027
     D  WFCNUM                 1      6                                                       CSD027
     D  WFFACT                 7      9  0
     D  WFFCNO                10     11  0
     D  WFRCTP                12     12
     D  WFKEY                  1     12
      *
     D PDLoAmFilFmt  E DS                  EXTNAME(LOAMSDK)
      ***  Past Due/Repayment Scheduled Loan Amendment Details in file Format  (from RTV)
     D                                     PREFIX(PD_)
     D  CurrPDLastChg        314    320
     D ReadLoAm      E DS                  EXTNAME(LOAMSDK)
      ***  Past Due/Repayment Scheduled Loan Amendment Details in file Format (From Caller)
     D                                     PREFIX(ReadPD_)
     D  ReadPDLastChg        314    320
      *
     D WrkLnDetails  E DS                  EXTNAME(CLOANCL) Prefix(CL_)
     D  CurrLnLastChg        314    320
      *
     D ReadLoan      E DS                  EXTNAME(CLOANCL) Prefix(ReadCL)
     D  ReadLnLastChg        314    320
     D  ReadCLRecSttm        473    527                                                     MD029048
     D  ReadCLPaySttm        542   1086                                                     MD029048
      *
     D PassDtaDS       DS           512
      ***  Ds to pass details from caller
     D CLE002                  1      1A
     D CLE003                  2      2A
     D CLE004                  3      3A
     D CLE005                  4      4A
     D CLE007                  5      5A
     D CLE009                  6      6A
     D CLE014                  7      7A
     D CLE023                  8      8A
     D CEU004                  9      9A
     D CDE001                 10     10A
     D DDESEQ                 11     13A
     D DDPASD                 14     14A
     D WrkCntrMR              15     15  0
     D WrkReactFacil          16     16
      *
      ***  KLKEY for Database Error on Loan Amendment
      *
     D                 DS
     D**WLNRF***               1      6  0                                                    CLE148
     D  WLNRF                  1      6                                                       CLE148
     D  WVALD                  7     11  0
     D  SLASN                 12     14  0
     D  KLKEY                  1     14
      *
      ***  FCLKEY for Database Error on Facility
      *
     D                 DS
     D**WFCUS***               1      6  0                                                    CSD027
     D  WFCUS                  1      6                                                       CSD027
     D  WFTYP                  7      9  0
     D  WFSEQ                 10     11  0
     D  WRCDT1                12     12
     D  FCLKEY                 1     12
      *
     D                 DS
      ***  Working DS with Amounts
      *
     D  PRAMR                  1     13  0
     D  INTAR                 14     26  0
     D  PNAMR                 27     39  0
     D  TAMTR                 40     52  0
     D  WTXAR                 53     65  0
     D  COFAR                 66     78  0                                                  AR927395
     D**SAMT****               1     65                                                     AR927395
     D  SAMT                   1     78                                                     AR927395
      *** Loan Amendment Current Amount in numeric  (on Valid format LOAMSDKF)
      *
     D**OPRAM***              66     78  0                                                  AR927395
     D**OINTA***              79     91  0                                                  AR927395
     D**OPNAM***              92    104  0                                                  AR927395
     D**OTAMT***             105    117  0                                                  AR927395
     D**OWTXA***             118    130  0                                                  AR927395
     D**OAMT****              66    130                                                     AR927395
     D  OPRAM                 79     91  0                                                  AR927395
     D  OINTA                 92    104  0                                                  AR927395
     D  OPNAM                105    117  0                                                  AR927395
     D  OTAMT                118    130  0                                                  AR927395
     D  OWTXA                131    143  0                                                  AR927395
     D  OCOFA                144    156  0                                                  AR927395
     D  OAMT                  79    156                                                     AR927395
      *** Input Amount in numeric  (on Valid format LEVMAPY)
      *
      ***  24X7 interface
     D TRANSDTL        S           5800A
      ***  Flat Structure for 24x7
      *
     D SC24X7        E DS                  EXTNAME(SC24X7)
      * 24X7 Data Structure
      *
     D SDSTAT        E DS                  EXTNAME(SDSTAT)
      * SDSTAT Data Structure
      *
     D APHEAD        E DS                  EXTNAME(APHEADPD)
      ***  Midas API Message Header Format Definition
      *
     D WTimestamp      S             26A
     D***PDealNo         S             18A                                                    CGL029
     D***PADealNo        S             18A                                                    CGL029
     D PDealNo         S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D PACCD           S             10A                                                      CGL029
     D @KEYC           S             10A                                                      CGL029
     D SHSETT          S             40A                                                      CGL029
     D T#TREF          S             26A                                                      CGL029
                                                                                              CRE020
      ** Define fields used in CRE020                                                         CRE020
     D CRE020          S              1A                                                      CRE020
     D KRefNo          S             30A                                                      CRE020
     D KSeqNo          S              3A                                                      CRE020
     D KPrgMn          S             10A   INZ('LEMAPYUPD ')                                  CRE020
     D PSysVal01       S             20A   INZ('ManualRepayments    ')                        CRE020
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
     D WSCHTP          S              1A                                                      CRE020
                                                                                              CLE025
     D CLE025          S              1                                                       CLE025
     D PSARD           S              6                                                       CLE025
      *                                                                                      BUG3760
     D CSC011          S              1                                                      BUG3760
     D CSD015          S              1                                                      BUG3760
     D CCF001          S              1                                                      BUG3760
     D CAS009          S              1                                                       CAS011
     D CAS016          S              1                                                       CAS019
     D CLE031          S              1                                                       CLE031
      *                                                                                      BUG3760
     D WFuncType       S              8                                                      BUG3760
     D WIdntifier      S             40                                                      BUG3760
     D WBranch         S              3                                                      BUG3760
      *                                                                                      BUG3760
     D WData           S            216                                                      BUG3760
     D WDDT            S               D                                                     BUG3760
     D WKLNRF          S              6                                                      BUG3760
     D WKVDAT          S              5                                                      BUG3760
     D WLASN           S              3                                                      BUG3760
     D WDTPC           S              1                                                      BUG3760
     D*WROBN****       S              6P 0                                            BUG3760 CSD027
     D*WROCN****       S              6P 0                                            BUG3760 CSD027
     D*WPOBN****       S              6P 0                                            BUG3760 CSD027
     D*WPOCN****       S              6P 0                                            BUG3760 CSD027
     D WROBN           S              6A                                                      CSD027
     D WROCN           S              6A                                                      CSD027
     D WPOBN           S              6A                                                      CSD027
     D WPOCN           S              6A                                                      CSD027
     D WDIFF           S              1                                                      BUG3760
     D WOPN            S             25                                                      BUG3760
     D WCLS            S             25                                                      BUG3760
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
     D*POMESys01       S             20A   INZ('OMEIndicator        ')                 CSC024 CSC054
     D*CSC024***       S              1A                                               CSC024 CSC054
     D*WOMEInd**       S              1A                                               CSC024 CSC054
     D PPEASys01       S             20A   INZ('PEAIndicator        ')                        CSC054
     D CSC054          S              1A                                                      CSC054
     D WPEAInd         S              1A                                                      CSC054
                                                                                              CSC024
     D CAP086          S              1A   INZ('N')                                           CAP086
     D CLE106          S              1                                                       CLE106
     D MR_PTRF         S                   LIKE(MRPCRF)                                      CSF011A
      *
     D PUPDT           S              1A                                                      CLE148
     D PCNEXT          S              8A                                                      CLE148
     D PRI1            S              1S 0                                                  AR322732
     D WUpdExpo        S              1A                                                    AR806351
     D UpdateFlag      S              1A                                                    MD022533
     D WPDCLNoPost     S              1A                                                    MD040186
     D CurArr          S              3    DIM(10)                                            CLE141
     D LocArr          S              3    DIM(10)                                            CLE141
     D PPDDI           S              1                                                       CLE141
      *
      /EJECT
      *    =============
      ***  Rename fields
      *    =============
     ICLOANCLF
     I              RECI                        RECIL
     I              CNUM                        CNUML
     I              REPT                        REPTL
     I              PTYP                        PTYPL
     I              AUTO                        AUTOL
     I              RTSP                        RTSPL                                       MD029048
     I              CCY                         CCYL
     I              RDFC                        RDFCL
     I              INTC                        INTCL
     I              WTIN                        WTINL
     I              PDDI                        PDDIL
      ***  Extended settlements
     I              RSTM                        RSTML
     I              RONS                        RONSL
     I              RIBN                        RIBNL
     I              RIBA                        RIBAL
     I              ROBN                        ROBNL
     I              ROCN                        ROCNL
     I              PSTM                        PSTML
     I              PONS                        PONSL
     I              PIBN                        PIBNL
     I              PIBA                        PIBAL
     I              POBN                        POBNL
     I              POCN                        POCNL
     I              RCRN                        RCRNL
     I              RCRA                        RCRAL
     I              RVNO                        RVNOL
     I              AWBN                        AWBNL
     I              AWBA                        AWBAL
     I              BENN                        BENNL
     I              BENA                        BENAL
     I              DTP1                        DTP1L
     I              DTP2                        DTP2L
     I              DTP3                        DTP3L
     I              DTP4                        DTP4L
     I              DCHG                        DCHGL
     I              BTB1                        BTB1L
     I              BTB2                        BTB2L
     I              BTB3                        BTB3L
     I              BTB4                        BTB4L
     I              BTB5                        BTB5L
     I              BTB6                        BTB6L
     I              CVMR                        CVMRL
     I              SCCY                        SCCYL
     I              ICCY                        ICCYL
     I              GASS                        GASSL
     I              REXR                        REXRL                                         CLE031
     I              REXI                        REXIL                                         CLE031
     I              PSCY                        PSCYL                                         CLE031
     I              PEXR                        PEXRL                                         CLE031
     I              PEXI                        PEXIL                                         CLE031
      *
      ** Extension Reference                                                                  CLE134
                                                                                              CLE134
     I              XRFI                        XRFIL                                         CLE134
     I              XRFN                        XRFNL                                         CLE134
                                                                                              CLE141
      ** Business Day Convention                                                              CLE141
     I              C1PI                        C1PIL                                         CLE141
     I              C2PI                        C2PIL                                         CLE141
     I              C3PI                        C3PIL                                         CLE141
     I              C4PI                        C4PIL                                         CLE141
     I              C5PI                        C5PIL                                         CLE141
     I              C6PI                        C6PIL                                         CLE141
     I              C7PI                        C7PIL                                         CLE141
     I              C8PI                        C8PIL                                         CLE141
     I              C9PI                        C9PIL                                         CLE141
     I              C0PI                        C0PIL                                         CLE141
     I              L1PI                        L1PIL                                         CLE141
     I              L2PI                        L2PIL                                         CLE141
     I              L3PI                        L3PIL                                         CLE141
     I              L4PI                        L4PIL                                         CLE141
     I              L5PI                        L5PIL                                         CLE141
     I              L6PI                        L6PIL                                         CLE141
     I              L7PI                        L7PIL                                         CLE141
     I              L8PI                        L8PIL                                         CLE141
     I              L9PI                        L9PIL                                         CLE141
     I              L0PI                        L0PIL                                         CLE141

     ICLOANCKF
      ***  Rename fields for Loans file - B
      *
     I              NLRA                        NLRAK
     ILOAMSDKF
      ***  Rename fields for Loans Amendment file
     I              PCRF                        PCRFK
     I              PCOB                        PCOBK
     I              SCCY                        SCCYK
     I              REXR                        REXRK                                         CLE031
     I              REXI                        REXIK                                         CLE031
     I              PSCY                        PSCYK                                         CLE031
     I              PEXR                        PEXRK                                         CLE031
     I              PEXI                        PEXIK                                         CLE031
      *
     ILOMKSDKF                                                                              MD020733
      ** Rename fields such that it will have the same value as LOAMSDK                     MD020733
     I              PCRF                        PCRFK                                       MD020733
     I              PCOB                        PCOBK                                       MD020733
     I              SCCY                        SCCYK                                       MD020733
     I              REXR                        REXRK                                       MD020733
     I              REXI                        REXIK                                       MD020733
     I              PSCY                        PSCYK                                       MD020733
     I              PEXR                        PEXRK                                       MD020733
     I              PEXI                        PEXIK                                       MD020733
      *                                                                                     MD020733
     ILOAMSD
      ***  Rename fields for Loan Amendments Retrieval index
      *
     I              RECI                        RECIA
     I              LNRF                        LNRFA
     I              VDAT                        VDATA
     I              LASN                        LASNA
     I              AMTP                        AMTPA
     I              PTYP                        PTYPA
     I              PRAM                        PRAMA
     I              AUTO                        AUTOA
     I              SETP                        SETPA
     I              OSAC                        OSACA
     I              TSEN                        TSENA
     I              FACO                        FACOA
     I              SPI1                        SPI1A
     I              SPI2                        SPI2A
     I              SPI3                        SPI3A
     I              XASQ                        XASQA
     I              ASTS                        ASTSA
     I              IUSR                        IUSRA
     I              AUSR                        AUSRA
      ***  Extended settlement details
     I              RSTM                        RSTMA
     I              RONS                        RONSA
     I              RIBN                        RIBNA
     I              RIBA                        RIBAA
     I              ROBN                        ROBNA
     I              ROCN                        ROCNA
     I              PSTM                        PSTMA
     I              PONS                        PONSA
     I              PIBN                        PIBNA
     I              PIBA                        PIBAA
     I              POBN                        POBNA
     I              POCN                        POCNA
     I              RCRN                        RCRNA
     I              RCRA                        RCRAA
     I              RVNO                        RVNOA
     I              AWBN                        AWBNA
     I              AWBA                        AWBAA
     I              BENN                        BENNA
     I              BENA                        BENAA
     I              DTP1                        DTP1A
     I              DTP2                        DTP2A
     I              DTP3                        DTP3A
     I              DTP4                        DTP4A
     I              DCHG                        DCHGA
     I              BTB1                        BTB1A
     I              BTB2                        BTB2A
     I              BTB3                        BTB3A
     I              BTB4                        BTB4A
     I              BTB5                        BTB5A
     I              BTB6                        BTB6A
     I              CVMR                        CVMRA
     I              SCCY                        SCCYCL
     I              ICCY                        ICCYC
     I              REXR                        REXRA                                         CLE031
     I              REXI                        REXIA                                         CLE031
     I              PSCY                        PSCYA                                         CLE031
     I              PEXR                        PEXRA                                         CLE031
     I              PEXI                        PEXIA                                         CLE031
      *
     ILEFCAMD3                                                                               245177A
      ** Rename fields                                                                       245177A
     I              RECI                        RECIC                                        245177A
     I              BRCA                        BRCAC                                        245177A
     I              CNUM                        CNUMC                                        245177A
     I              FACT                        FACTC                                        245177A
     I              FCNO                        FCNOC                                        245177A
     I              RVCR                        RVCRC                                        245177A
     I              ASTS                        ASTSC                                        245177A
     I              IUSR                        IUSRC                                        245177A
     I              AUSR                        AUSRC                                        245177A
     I              XUSR                        XUSRC                                        245177A
     I              CHTP                        CHTPC                                        245177A
     I              ORED                        OREDC                                        245177A
     I/COPY WNCPYSRC,LEH00159
     I*LTRIX**** NS        1 CH                                                             AR322732
     I**********                        1    1  RECI                                        AR322732
     I**********                        2    2  RCDT                                        AR322732
     I**********                        3    8 0LNRF                                        AR322732
     I**********                   P    9   11 0NORE                                        AR322732
     I**********                   P   12   14 0FLSZ                                        AR322732
     I**********                   P   15   17 0RRLC                                        AR322732
     I**********                   P   18   20 0RRNA                                        AR322732
     I**********                   P   21   23 0RRLX                                        AR322732
     I**********                   P   24   26 0RRXP                                        AR322732
     I**********                   P   27   29 0NLNR                                        AR322732
     I**********                   P   30   32 0NLAR                                        AR322732
     I**********                       33   33 0STPI                                        AR322732
     I**********                   P   38   40 0TNLU                                        AR322732
      *****Loan*transactions*index*file*-*Detail*record****************                     AR322732
     I*LTRIX**** NS        1 CD    2 CA                                                     AR322732
     I*********OR         1 CD    2 CL                                                      AR322732
      *****Loans*transactions*index*file*-*Catchall********************                     AR322732
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
     I**********                   P   35   37 0RRNT                                        AR322732
     I**********                   P   38   40 0TNLU                                        AR322732
      *****Loans*transactions*index*file*-*Catchall********************                     AR322732
     I**********NS                                                                          AR322732
     I**********                        1    1  RECI                                        AR322732
      *
     IFCLTYFMF
      ***  Rename fields for Facility file
      *
     I              RECI                        RECIF
     I              CNUM                        CNUMF
     I              FACT                        FACTF
     I              FCNO                        FCNOF
     I              RCTP                        RCTPF
     I              BRCA                        BRCDF
     I              FCTI                        FCTIF
     I              FCCY                        FCCYF
     I              FAMT                        FAMTF
     I              OVPC                        OVPCF
     I              DTAP                        DTAPF
     I              DTEX                        DTEXF
     I              RVCR                        RVCRF
     I              SECI                        SECIF
     I              MCCY                        MCCYF
     I              MCSI                        MCSIF
     I              NACD                        NACDF
     I              CRSK                        CRSKF
     I              DLFS                        DLFSF
     I              NOMR                        NOMRF
     I              RVDT                        RVDTF
     I              RVFR                        RVFRF
     I              RVDY                        RVDYF
     I              NAR1                        NAR1F
     I              NAR2                        NAR2F
     I              NAR3                        NAR3F
     I              NAR4                        NAR4F
     I              MTDH                        MTDHF
     I              MTDL                        MTDLF
     I              MTDA                        MTDAF
     I              QTDA                        QTDAF
     I              YTDA                        YTDAF
     I              ACOF                        ACOFF
     I              ORED                        OREDF
     I              LCD                         LCDF
     I              CHTP                        CHTPF
     I              TNLU                        TNLUF
     I              RCSI                        RCSIF
     I              SCCY                        SCCYL
     I              ICCY                        ICCYL
      *** Extended settlements
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
     I              REXR                        REXRF                                         CLE031
     I              REXI                        REXIF                                         CLE031
     I              PSCY                        PSCYF                                         CLE031
     I              PEXR                        PEXRF                                         CLE031
     I              PEXI                        PEXIF                                         CLE031
      *
     IFCLTYFNF
      ***  Rename fields for Facility file
      *
     I              LCD                         LCDF
     I              CHTP                        CHTPF
     I              TNLU                        TNLUF
     I/COPY WNCPYSRC,LEH00160
      *
      /EJECT
      *****************************************************************
      * MAIN - Mainlines                                              *
      *****************************************************************

      ** Check whether user is a web browser user, if so overwrite              CAP084
     C                   CALL      'SFC000026'                                  CAP084
     C                   PARM      *BLANKS       USER             10            CAP084
      *                                                                         CAP084
     C                   IF        USER <> *BLANKS                              CAP084
     C                   EVAL      PSUSER = USER                                CAP084
     C                   ENDIF                                                  CAP084

     C                   EVAL      MR_PTRF = MRPCRF                                          CSF011A
                                                                                             CSF011A
      ***  Ensure that details used for update are right
      ***  - if so, bypass updating and return to calling program.

     C                   EXSR      CHKOTHUPD

     C                   IF        @@RTCD <> *BLANKS
     C                   GOTO      EXIT
     C                   ENDIF

      ***  Process Insert, Amend, authorise or reverse
     C                   EXSR      SROUTPUT
                                                                                              CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020

      ***  Exit From Program

     C     EXIT          TAG

     C                   RETURN
      ****************************************************************
      /EJECT
      *****************************************************************
      * CHKOTHUPD - Check for update by another workstation           *
      *****************************************************************
     C     CHKOTHUPD     BEGSR

      ***  Retrieve current Manual Repayment

     C                   Eval      @@RTCD = *BLANKS
     C                   MOVE      MRFRNT        FOTRID
     C                   MOVE      MRLNRF        MidasLNRF         6
     C                   MOVE      MRCHTP        WWACTN            1
     C                   MOVE      MRCHTP        WSCHTP                                       CRE020
      *
     C                   MOVE      MRVDAT        ZDateNum
     C                   MOVE      BJDFIN        ZDateFmtInd
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDateNum          5 0
     C                   PARM                    ZDateFmtInd       1
     C                   PARM                    ZDateFmt6         6 0
     C                   PARM                    ZDateFmt7         7
      *
     C                   MOVE      ZDateFmt6     MidasVDAT         6
      *
     C                   MOVE      MRLASN        MidasLASN         3
     C                   if        MRXAVD <> 0  and WWACTN = 'I'                Exp. Paym. (PD/RE)
      ***If*Manual Reypayment, move expected value date                            BUG11240 BUG12002
     C******                       Or ((WWACTN = 'X' Or WWACTN = 'R')              BUG11240 BUG12002
     C******                          and MRXAVD <> 0 And MRAMTP = 'MR')           BUG11240 BUG12002
      ******                                                                       BUG11240 BUG12002
      *  If Manual Reypayment, move expected value date                                       242276
     C                             Or ((WWACTN = 'X' Or WWACTN = 'R')                         242276
     C                                and MRXAVD <> 0 And MRAMTP = 'MR')                      242276
      *                                                                                       242276
     C                   MOVE      MRXAVD        ZDateNum
     C                   MOVE      BJDFIN        ZDateFmtInd
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDateNum          5 0
     C                   PARM                    ZDateFmtInd       1
     C                   PARM                    ZDateFmt6         6 0
     C                   PARM                    ZDateFmt7         7
      *
     C                   MOVE      ZDateFmt6     MidasEVAL         6
     C                   MOVE      MRXASQ        MidasESEQ         3
      ***If*Manual Repayment, move loan amend sequence number                      BUG11240 BUG12002
     C******             If        MRAMTP = 'MR'                                   BUG11240 BUG12002
     C******             MOVE      MRLASN        MidasESEQ                         BUG11240 BUG12002
     C******             EndIf                                                     BUG11240 BUG12002
      ******                                                                       BUG11240 BUG12002
      *  If Manual Repayment, move loan amend sequence number                                 242276
     C                   If        MRAMTP = 'MR'                                              242276
     C                   If        WWACTN <> 'I'                                            BUG12669
     C                   MOVE      MRLASN        MidasESEQ                                    242276
     C                   EndIf                                                              BUG12669
     C                   EndIf                                                                242276
      *                                                                                       242276
     C                   Else
     C                   eval      MidasEVAL = *blanks
     C                   eval      MidasEseq = *blanks
     C                   Endif

      ***  Determine whether program is running interactively or in batch
      ***   ( 0 = batch   1 = interactive)

     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @Return           6
     C                   PARM                    @Type             1

      ***  Allow access to loan record by Front-Office ID when in Repair
      ***  mode for inserts . Set  *RTV module  parameter @@MODE  to   *FRONT
      ***  if the pgm is:  a) running in Interactive mode - @Type= 1   ~~~~~~
      ***                  b) action code is Insert - 'I'
      ***                  c) Front-Office Id is NOT Blank

     C                   IF        @Type = '1' AND
     C                             WWACTN = 'I' AND
     C                             MRFRNT <> *BLANKS
      *
     C                   EVAL      @@MODE = '*FRONT'
      *
     C                   ELSE

      ***  Otherwise, if running in batch use Front-Office ID
      ***             (if insert)
      ***             else, use Midas Manual Repayment  key

     C                   IF        @Type = '0' AND
     C                             WWACTN = 'I'
     C                   EVAL      @@MODE = '*FRONT'
     C                   ELSE
     C                   EVAL      @@MODE = *BLANKS
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   Z-ADD     0             WrkCntrMR         1 0
      ***  If expected sequence number is 'LN ' use this in call to                          BUG4325
      ***  LEMAPYRTV then set back to what it was in MidasEseq.                              BUG4325
     C     *LIKE         DEFINE    MidasEseq     SavEseq                                     BUG4325
     C                   EVAL      SavEseq = MidasEseq                                       BUG4325
     C**********         IF        DDESEQ = 'LN '                                     BUG4325 242276
     C                   EVAL      MidasEseq = DDESEQ                                        BUG4325
     C**********         ENDIF                                                        BUG4325 242276
      *                                                                                      BUG4325
     C                   CALLB     'LEMAPYRTV'
      *
      ***  Inputs

     C                   PARM      *BLANK        RetCodeOut

      ***  Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ***  Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)

     C                   PARM                    @@MODE            6
     C                   PARM      'S'           @@RSMD            1            Response mode Sec
     C                   PARM                    WWACTN                         Action Code
     C                   PARM                    FOTRID           20            Front Office Id
     C                   PARM                    MidasLNRF         6            Midas Loan Ref
     C                   PARM                    MidasVDAT         6            Midas Sequ. no
     C                   PARM                    MidasLASN         3            Midas Value Date
     C                   PARM                    MidasEval                      Midas Expected Date
     C                   PARM                    MidasEseq                      Midas Expected Seq
      *** Feature indicator
     C                   PARM                    CLE002
     C                   PARM                    CLE003
     C                   PARM                    CLE005
     C                   PARM                    CLE007
     C                   PARM                    CLE009
     C                   PARM                    CLE014

      ***  Outputs
      ***  (Current) Manual Repayment in file format

     C                   PARM                    CMapyFilFmt
     C                   PARM      *BLANK        DDACTNOK                       OK Actn code
     C                   PARM      *BLANK        DDLNRFOK                       OK Loan ref
     C                   PARM      *BLANK        DDVALDOK                       OK Value Date
     C                   PARM      *BLANK        DDSEQNOK                       OK Sequence
     C                   PARM      *BLANK        DDEVALOK                       OK Expected Date
     C                   PARM      *BLANK        DDESEQOK                       OK Expected Sequence
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANK        FldNameArr
     C                   PARM      *BLANK        MsgIdArr
     C                   PARM      *BLANK        MsgDtaArr
      ***  Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      ***  Indicators for display
     C                   PARM                    WWHoldTaxRat     11 7          W/hold Tax Rate
     C                   PARM      ' '           WExpectType       1            Expected LOAM type
     C                   PARM      ' '           WPTYP72           1            Expected on type 72
     C                   PARM      '  '          WrkExpAmdTp       2            PD/RE Amend Type
     C                   PARM      0             WrkRepayTp        1 0          Loan Repay. Type
     C                   PARM                    WrkReactFacil     1            React. Matured
     C                   PARM                    WrkCntrMR                      React. Matured
     C                   PARM                    PDLoAmFilFmt                   Past Due/Repay. Sche
     C                   PARM                    WrkLnDetails                   Loan details
      ***  Array index (3P0) from/to caller
     C                   PARM      *ZERO         Ix                3 0
     C                   PARM      *ZERO         WIdx              3 0
     C                   PARM                    PRcvParm                                     244636
     C**********         PARM                    UpSRFlg                             CLE134 MD020445
     C                   PARM                    UpSRFlg           1                          CLE164
     C                   PARM                    DDauto            1                          CLE164

      ***  Reset MidasEseq regardless.                                                       BUG4325
     C                   EVAL      MidasEseq = SavEseq                                       BUG4325
                                                                                             BUG4325
      ** If authorise mode, do not update the last change type                               BUG7348
     C                   If        MRCHTP = 'X'                                              BUG7348
     C                   Eval      MRCHTP = CHTP                                             BUG7348
     C                   EndIf                                                               BUG7348
      *                                                                                      BUG7348
      ***  Error if Timestamp is not the same (record has been changed
      ***  by another workstation)

      ***  Processing varies according to mode program is running in.
      ***  In interacive mode
      ***  Check that details for input aren't changed since it was last used
      ***  if it was changed, it returns to caller in error
      ***  In batch (API input) check return parameters from Retrieve
      ***  module for errors, and send message to system operator.

      ***  Interactive mode:

     C                   IF        @TYPE = '1'

     C                   IF        TMST <> MRTMES
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   ENDIF

      ***  Batch mode:

     C                   ELSE
      *
      ***  Reset OKFlagsDS If ix = 0 and warning <> 0
      *
     C                   if        Ix = 0 and WIDX <> 0
     C                   Move      *ALL'Y'       OKFlagsDS
     C                   Endif
     C                   IF        DDACTNOK = 'N' OR
     C                             DDLNRFOK = 'N'
     C                   EVAL      @@RTCD = '*RECUPD'
      *
     C                   ENDIF
      *
     C                   ENDIF

      ***  check That Loan Amendment details were not update since details were used

     C                   IF        @@RTCD = *blanks
     C     DDESEQ        IFNE      'LN '
     C     MRXAVD        ANDNE     0                                            PD/RE Exist
     C     WWACTN        AndNE     'A'
     C     WWACTN        AndNE     'E'
     C     WWACTN        AndNE     'X'

      ***  Check details used to work = Current Details   (Past Due/Repayment Scheduled)

     C     CurrPDLastChg IFNE      ReadPDLastChg
      *
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVE      'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF      'FldNameArr(Ix)
     C                   MOVEL     'LEM0010'     MsgIdArr(Ix)
      *
     C                   Endif
     C                   Endif
     C                   Endif

      ***  check That Loan details were not update since details were used

     C                   IF        @@RTCD = *blanks

      ***  Check details used to work = Current Details   (Past Due/Repayment Scheduled)

     C     CurrLnLastChg IFNE      ReadLnLastChg
      *
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVE      'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF      'FldNameArr(Ix)
     C                   MOVEL     'LEM0010'     MsgIdArr(Ix)
      *
     C                   Endif
     C                   Endif

      ***  Batch - Return Details to Caller

     C                   IF        @TYPE <> '1' and @@RTCD <> *blank
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
     C                   Endif
      *
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * SROUTPUT - Process Insert, Amend, authorise or reverse       *
      ****************************************************************
     C     SROUTPUT      BEGSR

      ***  Access loan details

     C                   MOVE      MRLNRF        WCLOAN
     C                   MOVE      MRLNRF        WLNRF
     C                   MOVE      'A'           WCRCDT
     C     WKLON         CHAIN(N)  CLOAN                              99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVEL     'LEMAPYUPD'   DBPGM
     C                   MOVE      MRLNRF        DBKEY                          *************
     C                   MOVEL     'CLOANCL '    DBFILE                         * DBERR 010 *
     C                   Z-ADD     10            DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   if          PTYPL = 66 or PTYPL = 67 or PTYPL = 69 or
     C                               PTYPL = 72
     C                   move      *ON           *IN52
     C                   Else
     C                   MOVE      *OFF          *IN52
     C                   Endif
      *
     C                   MOVE      'B'           WCRCDT
     C     WKLON         CHAIN(N)  CLOAN                              99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVEL     'LEMAPYUPD'   DBPGM
     C                   MOVE      MRLNRF        DBKEY                          *************
     C                   MOVEL     'CLOANCK '    DBFILE                         * DBERR 011 *
     C                   Z-ADD     11            DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*BLANK  '    PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM      CCYL          PCURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVEL     'LEMAPYUPD'   DBPGM
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   Z-ADD     12            DBASE                          * DBERR 12 *
     C                   MOVEL     PCURR         DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        WCDP              1 0
     C     CLE023        IFEQ      'Y'
     C                   Z-ADD     A6SPRT        WSPRTL           13 8
     C                   MOVE      A6MDIN        WMDINL            1
     C                   ENDIF

      ***  Obtain last transaction number

     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANK        P@RTCD           10
     C                   PARM                    P@NATN            5 0
     C                   Z-ADD     P@NATN        TNLU
      *
     C                   if        WWACTN = 'I'
     C                   Exsr      SRWriteLoAm
     C                   Else
     C                   Exsr      SRUpdateLoAm
     C                   endif

      ***  Data export for CCRM - Limits

     C     CDE001        IFEQ      'Y'
     C     @@RTCD        ANDEQ     *BLANKS
     C                   MOVEL     MRLNRF        T#TREF
     C                   CALL      'DEWTTRIG'
     C**********         PARM                    T#TREF           20                          CGL029
     C                   PARM                    T#TREF                                       CGL029
     C                   PARM      'LOAN'        T#TCAT            4
     C                   PARM                    ResrvId          10                          CDE005
     C                   ENDIF
      *
     C                   if        CSC011 = 'Y'
     C                             AND  @@RTCD = *BLANKS
      *
     C**********         IN        SC24X7                                                   MD024398
     C**********         IN        SDSTAT                                                   MD024398
     C                   if        S1SUPP = LIBR

      ***  Setup Facility support log

     C                   CALLB     'LEMAPYLOG'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    WWACTN
     C                   PARM                    CMapyFilFmt
     C                   PARM                    ReadLoam
     C                   PARM                    PassDtaDS
     C                   PARM                    TRANSDTL

      ***  Write to support database log file

     C                   IF        RetCodeOut = *BLANKS
      *
     C                   EVAL      APTGTTYPE = 'LEMAPY'
     C                   EVAL      APUSERID = PsUser
     C                   MOVEL     FRNT          APFOTRANID
     C                   MOVEL     LNRF          W@MRCNUM          6
     C                   Z-ADD     VDAT          WrkVdate          5 0
     C                   MOVE      WrkVdate      W@MRVDAT          5
     C                   MOVE      LASN          W@MRLASN          2

      ***  Key Fields

     C                   EVAL      PDealNo = W@MRCNUM + W@MRVDAT +
     C                                       W@MRLASN
     C                   EVAL      PADealNo = *BLANKS
      *
     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    APHEAD
     C                   PARM                    TRANSDTL
     C                   PARM      *BLANKS       WTimestamp
     C                   PARM                    PDealNo
     C                   PARM                    PADealNo
     C                   Endif
     C                   Endif
     C                   Endif
      *
     c                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRWriteLoAm - Write Loan Amendment and Update Files           *
      *****************************************************************
     C     SRWriteLoAm   BEGSR

      ***  Fill Input amounts in Saved Amounts DS

     C                   Z-Add     MRPRAM        OPRAM
     C                   Z-Add     MRINTA        OINTA
     C                   Z-Add     MRPNAM        OPNAM
     C                   Z-Add     MRTAMT        OTAMT
     C                   Z-Add     MRWTXA        OWTXA
     C                   MOVE      *BLANK        WAMTP

     C                   MOVE      OAMT          SAMT
      *
     C                   if        PD_AMTP = 'PD'
     C                             or MRXAVD = 0

      ***  Do Facility Update

     C                   EXSR      SRFCLT
     C     @@RTCD        CABEQ     '*RECUPD'     EndWriteLoAm
     C                   endif

      ***  Loans file update

     C                   IF        DDESEQ = 'LN ' or
     C                             PD_AMTP = 'PD'
     C                   EXSR      SRLOAN
     C     @@RTCD        CABEQ     '*RECUPD'     EndWriteLoAm
     C                   Endif
      *
     C                   EXSR      SRLOAM
     C     @@RTCD        CABEQ     '*RECUPD'     EndWriteLoAm

      ***  If CLE009 is installed, update fees file

     C     CLE009        IFEQ      'Y'
     C                   EXSR      SRFEES
     C                   ENDIF

      ***  Update Trailer

     C                   EXSR      SRTRAL

     C*****PCRF*         CHAIN     LESTALLA                           99             BUG9225 CSF011A
     C     MR_PTRF       CHAIN     LESTALLA                           99                     CSF011A
     C     *IN99         DOWEQ     *OFF                                                      BUG9225
     C                   Z-ADD     MRLASN        XXLASQ                                      BUG9225
     C                   EVAL      XXPTRF = MRPCRF                                           CSF011A
     C                   UPDATE    LESTALD0                                                  BUG9225
     C*****PCRF*         READE     LESTALLA                               99         BUG9225 CSF011A
     C     MR_PTRF       READE     LESTALLA                               99                 CSF011A
     C                   ENDDO                                                               BUG9225
                                                                                             BUG9225
      ***  Shadow posting
      ***  Update on shadow posting shd only be done if not a Risk loan
      ***  If it is a Risk loan then it should have an interest payment.

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
     C     INTA          ANDNE     0
     C     PTYP          OREQ      71
     C     INTA          ANDNE     0
     C     PTYP          OREQ      72
     C     INTA          ANDNE     0
      *                                                                                     MD022533
     C                   EVAL      UpdateFlag = 'Y'                                         MD022533
     C                   IF        CLE134 = 'Y' AND UpSrFlg = 'Y' AND                       MD022533
     C                             AMTP = 'MR'                                              MD022533
     C                   IF        NOT(CL_REPT = 2  AND                                     MD022533
     C                             CL_NIDT < BJDNWD AND                                     MD022533
     C                             CL_AUTO = 'C' AND                                        MD022533
     C                             INTA > 0)                                                MD022533
     C                   EVAL      UpdateFlag = 'N'                                         MD022533
     C                   ENDIF                                                              MD022533
     C                   ENDIF                                                              MD022533
      *                                                                                      BUG8458
     C*****MRCHTP        IFNE      'X'                                              BUG8458 MD022533
     C                   IF        MRCHTP <> 'X' AND UpdateFlag = 'Y'                       MD022533
      *
     C**********         MOVE      WSETT         SHSETT           34                          CGL029
     C                   MOVE      WSETT         SHSETT                                       CGL029
     C     CLE031        IFEQ      'Y'                                                      MD051892
     C                   MOVE      SCCYK         SHSCCY                                     MD051892
     C                   Z-ADD     REXRK         SHREXR                                     MD051892
     C                   MOVE      REXIK         SHREXI                                     MD051892
     C                   MOVE      PSCYK         SHPSCY                                     MD051892
     C                   Z-ADD     PEXRK         SHPEXR                                     MD051892
     C                   MOVE      PEXIK         SHPEXI                                     MD051892
     C                   ENDIF                                                              MD051892
     C                   EXSR      SRSHAD
     C                   CLEAR                   Z#BSTS
     C                   MOVE      Z#ADTA        Z#ADT1
     C                   MOVE      Z#ADTB        Z#ADT2
     C                   MOVE      Z#ADTD        Z#ADT4
     C     CEU004        IFEQ      'Y'
     C     CLE031        OREQ      'Y'                                                        CLE031
     C                   MOVE      Z#ADTE        Z#ADT5
     C                   ENDIF
     C                   EXSR      SRUSHD
     C                   ENDIF                                                               BUG8458
     C                   ENDIF
      *
     C     ENDWriteLoAm  ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUpdateLoAm - Update Loan Amendment and Update Files         *
      *****************************************************************
     C     SRUpdateLoAm  BEGSR

      ***  Fill details with know details

     C                   Z-Add     MRPRAM        PRAMR
     C                   Z-Add     MRINTA        INTAR
     C                   Z-Add     MRPNAM        PNAMR
     C                   Z-Add     MRTAMT        TAMTR
     C                   Z-Add     MRWTXA        WTXAR
     C                   Z-Add     MRCOFA        COFAR                                      AR927395
     C                   Z-ADD     MRVDAT        WVALD
     C                   MOVE      MRLASN        SLASN
     C                   MOVE      *BLANK        WAMTP                                        260446

      ***  Update facility files

     C     WWACTN        IFEQ      'R'
     C     MRXAVD        IFEQ      0
     C     MRXAVD        ORNE      0
     C     PD_AMTP       ANDEQ     'PD'
     C                   EXSR      SRFCLT
     C     @@RTCD        CABEQ     '*RECUPD'     EndUpdateLoAm
     C                   ENDIF
     C                   ENDIF

      ***  Loans file update

     C     DDESEQ        IFEQ      'LN '
     C     PD_AMTP       OREQ      'PD'
     C                   EXSR      SRLOAN
     C     @@RTCD        CABEQ     '*RECUPD'     EndUpdateLoAm
     C                   ENDIF

      ***  Update loan amendment

     C     WWACTN        IFEQ      'R'
     C**********         Z-ADD     MRLNRF        W#LNRF                                       CLE148
     C                   MOVEL     MRLNRF        W#LNRF                                       CLE148
     C                   ENDIF
     C                   EXSR      SRLOAM
     C     WWACTN        IFEQ      'R'
     C**********         Z-ADD     W#LNRF        MRLNRF                                       CLE148
     C                   MOVEL     W#LNRF        MRLNRF                                       CLE148
     C                   ENDIF

      ***  If CLE009 is installed, update fees file

     C     CLE009        IFEQ      'Y'
     C                   EXSR      SRFEES
     C                   ENDIF
      *
     C     @@RTCD        CABEQ     '*RECUPD'     EndUpdateLoAm

      ***  Update trailer

     C     WWACTN        IFEQ      'R'
     C                   EXSR      SRTRAL
     C     @@RTCD        CABEQ     '*RECUPD'     EndUpdateLoAm
     C                   ENDIF

      ***  Shadow posting - Before Status
      ***  Update on shadow posting shd only be done if not a Risk loan
      ***  If it is a Risk loan then it should have an interest payment.

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
     C     INTA          ANDNE     0
     C     PTYP          OREQ      71
     C     INTA          ANDNE     0
     C     PTYP          OREQ      72
     C     INTA          ANDNE     0
      *                                                                                      BUG8458
     C     MRCHTP        IFNE      'X'                                                       BUG8458
      *
     C**********         MOVE      OLDSET        SHSETT           34                          CGL029
     C                   MOVE      OLDSET        SHSETT                                       CGL029
     C     CLE031        IFEQ      'Y'                                                      MD051892
     C                   MOVE      OSCCY         SHSCCY                                     MD051892
     C                   Z-ADD     OREXR         SHREXR                                     MD051892
     C                   MOVE      OREXI         SHREXI                                     MD051892
     C                   ENDIF                                                              MD051892
     C                   EXSR      SRSHAD
     C                   MOVE      Z#ADTA        Z#BDT1
     C                   MOVE      Z#ADTB        Z#BDT2
     C                   MOVE      Z#ADTD        Z#BDT4                                       254634
      *
     C     CEU004        IFEQ      'Y'
     C     CLE031        OREQ      'Y'                                                        CLE031
     C                   MOVE      Z#ADTE        Z#BDT5
     C                   ENDIF
                                                                                              CLE134
     C                   IF        CLE134      = 'Y'                                          CLE134
     C                   EVAL      Z#BDT8      = Z#ADTH                                       CLE134
     C                   ENDIF                                                                CLE134

      ***  Shadow posting - After Status

     C                   MOVE      WSETT         SHSETT
     C     CLE031        IFEQ      'Y'                                                      MD051892
     C                   MOVE      SCCYK         SHSCCY                                     MD051892
     C                   Z-ADD     REXRK         SHREXR                                     MD051892
     C                   MOVE      REXIK         SHREXI                                     MD051892
     C                   MOVE      PSCYK         SHPSCY                                     MD051892
     C                   Z-ADD     PEXRK         SHPEXR                                     MD051892
     C                   MOVE      PEXIK         SHPEXI                                     MD051892
     C                   ENDIF                                                              MD051892
     C                   EXSR      SRSHAD
     C                   MOVE      Z#ADTA        Z#ADT1
     C                   MOVE      Z#ADTB        Z#ADT2
     C                   MOVE      Z#ADTD        Z#ADT4
      *
     C     CEU004        IFEQ      'Y'
     C     CLE031        OREQ      'Y'                                                        CLE031
     C                   MOVE      Z#ADTE        Z#ADT5
     C                   ENDIF
                                                                                              CLE134
     C                   IF        CLE134      = 'Y'                                          CLE134
     C                   EVAL      Z#ADT8      = Z#ADTH                                       CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C                   EXSR      SRUSHD
      *
     C                   ENDIF                                                               BUG8458
     C                   ENDIF
      *
     C     ENDUpdateLoAm ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFCLT   - Facility file update                               *
      * Called by: SRWRIT, SRUPDT                                     *
      * Calls    : FCLTSR                                             *
      *****************************************************************
     C     SRFCLT        BEGSR
      *
     C                   MOVE      'N'           WrkPart           1
      *
     C     WWACTN        IFEQ      'I'
     C     WWACTN        OREQ      'R'

      ***  Access FACILITY 'A' record

     C                   MOVE      'A'           WRCDT1
     C                   MOVE      FCUS          WFCUS
     C                   MOVE      FTYP          WFTYP
     C                   MOVE      FSEQ          WFSEQ
      *
     C     KFCLT         CHAIN(n)  FCLTY                              50
     C     *IN50         IFEQ      *ON                                          Not found
     C     *LOCK         IN        LDA
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVEL     'LEMAPYUPD'   DBPGM
     C                   MOVEL     'FCLTY   '    DBFILE                         ************
     C                   Z-ADD     13            DBASE                          * DBERR 13 *
     C                   MOVEL     FCLKEY        DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   GOTO      ENDFCL
     C                   ENDIF

      ***  Access FACILITY 'B' record

     C                   MOVE      'B'           WRCDT1
     C*****KFCLT         CHAIN     FCLTY                              50                   AR1080805
     C     KFCLT         CHAIN(n)  FCLTY                              50                   AR1080805
     C     *IN50         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVEL     'LEMAPYUPD'   DBPGM
     C                   MOVEL(p)  'FCLTY'       DBFILE                         ************
     C                   Z-ADD     14            DBASE                          * DBERR 14 *
     C                   MOVEL     FCLKEY        DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   GOTO      ENDFCL
     C                   ENDIF

      *** Access LEFCAMPD file for change in revolving credit.

     C                   MOVE      ' '           WRVCRC            1                         245177A
     C                   Z-ADD     0             WVLDT             5 0                       245177A
     C     KFCAM         SETLL     LEFCAML3                                                  245177A
     C     KFCAM         READE     LEFCAML3                               85                 245177A
      *                                                                                      245177A
     C     *IN85         DOWEQ     *OFF                                                      245177A
     C     WRVCRC        ANDEQ     ' '                                                       245177A
     C     RECIC         IFEQ      'D'                                                       245177A
     C     FATP          ANDEQ     'RC'                                                      245177A
     C                   MOVE      RVCRC         WRVCRC                                      245177A
     C                   Z-ADD     VLDT          WVLDT                                       245177A
     C                   ENDIF                                                               245177A
     C     KFCAM         READE     LEFCAML3                               85                 245177A
     C                   ENDDO                                                               245177A

      ***  Access FCCY record for decimal places

     C                   CALLB     'AOCURRR0'
     C                   PARM      '*BLANK  '    PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM      FCCYF         PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVEL     'LEMAPYUPD'   DBPGM
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   Z-ADD     15            DBASE                          * DBERR 15 *
     C                   MOVEL     FCCYF         DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   GOTO      ENDFCL
     C                   ENDIF

      ***  Save currency details to work field

     C                   MOVE      A6NBDP        CDPF              1 0
     C     CLE023        IFEQ      'Y'
     C                   Z-ADD     A6SPRT        WSPRTF           13 8
     C                   MOVE      A6MDIN        WMDINF            1
     C                   ENDIF
     C                   IF        CLE134 = 'Y'                                             AR806351
     C                   EVAL      WUpdExpo = 'Y'                                           AR806351
     C                   EXSR      SrPDCLMR                                                 AR806351
     C                   ENDIF                                                              AR806351
      *                                                                                     AR806351
     C                   EXSR      FCLTSR
      *
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      'A'           CHTP
     C                   Z-ADD     P@NATN        TNLU
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      STMP=TimeStamp
     C                   UPDATE    FCLTYFNF                             50

      ***  Update superfacility of the tranche, if any, for CLE005

     C     CLE005        IFEQ      'Y'
     C     TRCA          ANDEQ     'TR'
     C                   Movel     WPRME         SPRME            12
     C                   Exsr      SRUPCA
     C                   MOVEL     SPRME         WPRME
     C                   endif

      ***  Update also the Participant facility if existing

     C     LPFI          IFNE      ' '
     C*****LPFI*         ANDNE     'R'                                                        CLE106
      *
     C                   MOVE      'Y'           WrkPART
      *
     C                   MOVEL     PTFC          WFCUS
     C                   MOVEL     PTFT          WFTYP
     C                   MOVEL     PTFN          WFSEQ
     C                   MOVE      'A'           WRCDT1
      *
     C     KFCLT         CHAIN(N)  FCLTY                              50
      *
     C     *IN50         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVEL     'LEMAPYUPD'   DBPGM
     C                   MOVEL     'FCLTY   '    DBFILE                         ************
     C                   Z-ADD     16            DBASE                          * DBERR 16 *
     C                   MOVEL     FCLKEY        DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ***  Access FACILITY 'B' record

     C                   MOVE      'B'           WRCDT1
     C     KFCLT         CHAIN     FCLTY                              50
     C     *IN50         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVEL     'LEMAPYUPD'   DBPGM
     C                   MOVEL     'FCLTY   '    DBFILE                         ************
     C                   Z-ADD     17            DBASE                          * DBERR 17 *
     C                   MOVEL     FCLKEY        DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   GOTO      ENDFCL
     C                   ENDIF

      ***  Access FCCY record for decimal places

     C                   CALLB     'AOCURRR0'
     C                   PARM      '*BLANK  '    PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM      FCCYF         PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVEL     'LEMAPYUPD'   DBPGM
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   Z-ADD     18            DBASE                          * DBERR 18 *
     C                   MOVEL     FCCYF         DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   GOTO      ENDFCL
     C                   ENDIF
      *
     C                   Move      A6NBDP        CDPF
      *
     C                   IF        CLE134 = 'Y'                                             AR806351
     C                   EVAL      WUpdExpo = 'Y'                                           AR806351
     C                   EXSR      SrPDCLMR                                                 AR806351
     C                   ENDIF                                                              AR806351
      *                                                                                     AR806351
     C                   EXSR      FCLTSR
      *
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      'A'           CHTP
     C                   Z-ADD     P@NATN        TNLU
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      STMP=TimeStamp
     C                   UPDATE    FCLTYFNF                             50
      *
     C                   ENDIF
     C                   ENDIF
      *
     C     ENDFCL        ENDSR
      /EJECT                                                                                AR806351
      *****************************************************************                     AR806351
      * SRPDCLMR - Check if loan has FAMU N/Y                         *                     AR806351
      *****************************************************************                     AR806351
     C     SRPDCLMR      BEGSR                                                              AR806351
      *                                                                                     AR806351
      ** Bypass if PDCL type is Interest(Y) or Fee(Z) and with FAMU = N                     AR806351
      ** Only do this if auto-settlement is equal to 'C' from CLOANCL                       AR806351
      *                                                                                     AR806351
     C     AUTOL         IFEQ      'C'                                                      AR806351
     C                   IF        %SUBST(LTYP:1:1) = 'Y' AND                               AR806351
     C                             FAMU = 'N' OR                                            AR806351
     C                             %SUBST(LTYP:1:1) = 'Z' AND                               AR806351
     C                             FAMU = 'N'                                               AR806351
     C                   EVAL      WUpdExpo='N'                                             AR806351
     C                   ENDIF                                                              AR806351
     C                   ENDIF                                                              AR806351
      *                                                                                     AR806351
     C                   ENDSR                                                              AR806351
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRLOAN   - Update Loans file                                  *
      * Called by: SRWRIT, SRUPDT                                     *
      * Calls    : SRSLOC                                             *
      *****************************************************************
     C     SRLOAN        BEGSR

      ***  Access the CLOAN record to be updated

     C                   MOVE      MRLNRF        WCLOAN
     C                   MOVE      'A'           WCRCDT
     C     WKLON         CHAIN     CLOAN                              50
      *
     C     *IN50         IFEQ      '1'
     C     RECIL         ORNE      'D'
     C     *LOCK         IN        LDA
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVEL     'LEMAPYUPD'   DBPGM
     C                   MOVEL     'CLOAN   '    DBFILE                         ************
     C                   Z-ADD     19            DBASE                          * DBERR 19 *
     C                   MOVEL     MRLNRF        DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   ELSE

      ***  Save repayment amount for generating 'RE' if match to cloan

     C                   Z-ADD     RAMT          RAMTS            13 0

      ***  Update fields for next repayment date

     C*****MRAMTP*       IFNE      'PD'                                         output rec   BUG4774
     C     PD_AMTP       IFNE      'PD'                                         output rec   BUG4774
      *
     C     RFRQ          IFNE      ' '
      *
     C                   MOVE      RFRQ          ZFREQ
     C                   Z-ADD     RBDT          ZDAYNO
     C                   Z-ADD     RDYN          ZMDAY
     C**********         MOVE      CCY           ZCCY                                        BUG3829
     C                   MOVE      CCYL          ZCCY                                        BUG3829

      ***  Find the location of the settlement

     C                   MOVE      MDST          W@SETP            2
     C                   MOVEL     OMDA          W@SNOS            2
     C**********         MOVE      CCY           W@CCY             3                         BUG3829
     C                   MOVE      CCYL          W@CCY             3                         BUG3829
     C                   EXSR      SRSLOC

      ***  Determine next repayment date

     C                   MOVE      W@STLL        ZLOC

      ** Get Currency and Location Value (Arrays)                                             CLE141
                                                                                              CLE141
     C                   IF        CLE141 = 'Y'                                               CLE141
     C                   EVAL      CurArr(1) = C1PIL                                          CLE141
     C                   EVAL      CurArr(2) = C2PIL                                          CLE141
     C                   EVAL      CurArr(3) = C3PIL                                          CLE141
     C                   EVAL      CurArr(4) = C4PIL                                          CLE141
     C                   EVAL      CurArr(5) = C5PIL                                          CLE141
     C                   EVAL      CurArr(6) = C6PIL                                          CLE141
     C                   EVAL      CurArr(7) = C7PIL                                          CLE141
     C                   EVAL      CurArr(8) = C8PIL                                          CLE141
     C                   EVAL      CurArr(9) = C9PIL                                          CLE141
     C                   EVAL      CurArr(10)= C0PIL                                          CLE141
     C                   EVAL      LocArr(1) = L1PIL                                          CLE141
     C                   EVAL      LocArr(2) = L2PIL                                          CLE141
     C                   EVAL      LocArr(3) = L3PIL                                          CLE141
     C                   EVAL      LocArr(4) = L4PIL                                          CLE141
     C                   EVAL      LocArr(5) = L5PIL                                          CLE141
     C                   EVAL      LocArr(6) = L6PIL                                          CLE141
     C                   EVAL      LocArr(7) = L7PIL                                          CLE141
     C                   EVAL      LocArr(8) = L8PIL                                          CLE141
     C                   EVAL      LocArr(9) = L9PIL                                          CLE141
     C                   EVAL      LocArr(10)= L0PIL                                          CLE141
     C                   ENDIF                                                                CLE141

      ***  If CLE005 exist, calculate the next repayment date based on
      ***  the Payment Due Day Indicator

     C     CLE005        IFEQ      'Y'
     C                   CallB     'ZFRQB3'
     C                   PARM                    ZFREQ             1
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZMDAY             2 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
     C                   PARM                    ZZERR@            7
     C                   Z-ADD     *ZERO         ZNRDYS
      ** Business Day Convention Date Calculation                                             CLE141
     C**********         IF        CLE141 = 'Y' and (MDST = 01 or                     CLE141 CLE141A
     C**********                   MDST = 07 or MDST = 08)                            CLE141 CLE141A
     C                   IF        CLE141 = 'Y'                                              CLE141A
      *                                                                                       CLE141
     C                   IF        PDDIL = 'A'                                                CLE141
     C                   Z-ADD     ZDAYNO        ZDYNBR                                       CLE141
     C                   ELSE                                                                 CLE141
     C                   CALL      'LEZBDYCD'                                                 CLE141
     C                   PARM                    ZDAYNO                                       CLE141
     C                   PARM                    CurArr                                       CLE141
     C                   PARM                    LocArr                                       CLE141
     C                   PARM      PDDIL         PPDDI                                        CLE141
     C                   PARM                    BJDFIN                                       CLE141
     C                   PARM                    ZCCY                                        CLE141A
     C                   PARM                    ZLOC                                        CLE141A
     C                   PARM                    ZDYNBR                                       CLE141
     C                   ENDIF                                                                CLE141
     C                   ELSE                                                                 CLE141
     C                   SELECT
     C     PDDIL         WHENEQ    'A'
     C                   Z-ADD     ZDAYNO        ZDYNBR
     C     PDDIL         WHENEQ    'P'
     C                   CallB     'ZBKDT'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
     C                   PARM                    ZNRDYS            2 0
     C                   PARM                    ZDYNBR            5 0
     C     PDDIL         WHENEQ    'N'
     C     PDDIL         OREQ      *BLANK
     C                   CallB     'ZFWDT'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZNRDYS            2 0
     C                   PARM                    ZDYNBR            5 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
     C     PDDIL         WHENEQ    'M'
     C                   CallB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
      *
     C     BJDFIN        IFNE      'M'
     C                   MOVE(P)   ZDATE         MMYY              4 0
     C                   MOVEL(P)  MMYY          MMNLCD            2 0
     C                   ELSE
     C                   MOVEL(P)  ZDATE         MMNLCD
     C                   ENDIF
     C                   Z-ADD     ZDAYNO        @DAYNO            5 0
     C                   callB     'ZFWDT'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZNRDYS            2 0
     C                   PARM                    ZDYNBR            5 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
     C                   Z-ADD     ZDYNBR        ZDAYNO
     C                   callb     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C     BJDFIN        IFNE      'M'
     C                   MOVE(P)   ZDATE         MMYY
     C                   MOVEL(P)  MMYY          MMNWKD            2 0
     C                   ELSE
     C                   MOVEL(P)  ZDATE         MMNWKD
     C                   ENDIF
     C     MMNLCD        IFNE      MMNWKD
     C                   Z-ADD     @DAYNO        ZDAYNO
     C                   CallB     'ZBKDT'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
     C                   PARM                    ZNRDYS            2 0
     C                   PARM                    ZDYNBR            5 0
     C                   ENDIF
     C                   ENDSL
     C                   ENDIF                                                                CLE141
     C                   ELSE
     C**********         IF        CLE141 = 'Y' and (MDST = 01 or                     CLE141 CLE141A
     C**********                   MDST = 07 or  MDST = 08)                           CLE141 CLE141A
     C                   IF        CLE141 = 'Y'                                              CLE141A
      *                                                                                       CLE141
     C                   CallB     'ZFRQB3'                                                   CLE141
     C                   PARM                    ZFREQ                                        CLE141
     C                   PARM                    ZDAYNO                                       CLE141
     C                   PARM                    ZMDAY                                        CLE141
     C                   PARM                    ZCCY                                         CLE141
     C                   PARM                    ZLOC                                         CLE141
     C                   PARM                    ZZERR@                                       CLE141
      *                                                                                       CLE141
     C                   CALL      'LEZBDYCD'                                                 CLE141
     C                   PARM                    ZDAYNO                                       CLE141
     C                   PARM                    CurArr                                       CLE141
     C                   PARM                    LocArr                                       CLE141
     C                   PARM      *Blanks       PDDIL                                        CLE141
     C                   PARM                    BJDFIN                                       CLE141
     C                   PARM                    ZCCY                                        CLE141A
     C                   PARM                    ZLOC                                        CLE141A
     C                   PARM                    ZDYNBR                                       CLE141
     C                   ELSE                                                                 CLE141
     C                   CallB     'ZFREQB'
     C                   PARM                    PRETCode          7
     C                   PARM                    ZFREQ
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC                                       AR702741
     c                   PARM                    ZMDAY
     C                   PARM                    BJDFIN
     C                   PARM                    SDGELR
      *
     C                   Z-ADD     0             ZNRDYS
     C                   callB     'ZFWDT'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZNRDYS            2 0
     C                   PARM                    ZDYNBR            5 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
     C                   ENDIF                                                                CLE141
     C                   ENDIF
     C                   ENDIF

      ***  Update next repayment date on insert only                                        BUG23031
                                                                                            BUG23031
     C     WWACTN        IFEQ      'I'                                                      BUG23031
                                                                                            BUG23031
      ***  If next repay date greater than maturity date zeroise fields

     C     MDAT          IFNE      0
     C     ZDYNBR        ANDGT     MDAT
     C     RFRQ          OREQ      ' '
     C                   Z-ADD     0             RAMT
     C                   Z-ADD     0             NRPD
     C                   Z-ADD     0             RBDT
     C                   MOVE      ' '           RFRQ
     C                   Z-ADD     0             RDYN
     C                   BITOFF    '23'          CBLI
     C                   BITOFF    '3'           TLXI
     C                   ELSE
      *
     C                   Z-ADD     ZDYNBR        NRPD
     C                   Z-ADD     ZDAYNO        RBDT
     C                   ENDIF
                                                                                            BUG23031
     C                   ENDIF                                                              BUG23031
      *
     C                   ELSE

      ***  Update Past Due Interest

     C                   Z-ADD     INTAR         WRK13            13 0
      *
     C     WTINL         IFEQ      'G'                                          Gross Withhold. tax
     C     WTINL         OREQ      'R'                                          Receivable W/hold Tx
     C     WRK13         ADD       WTXAR         WRK13
     C                   ENDIF
      *
     C     WWACTN        IFEQ      'I'
     C     PDIN          SUB       WRK13         PDIN
     C     PDIN          IFLT      0                                                        AR628773
     C                   Z-ADD     0             PDIN                                       AR628773
     C                   ENDIF                                                              AR628773
     C                   ELSE
     C     WWACTN        IFEQ      'R'                                                       BUG4774
     C     PDIN          ADD       WRK13         PDIN
     C                   ENDIF                                                               BUG4774
     C                   ENDIF
      *
     C                   ENDIF

      ***  Update CLOAN file to unlink Loan to syndication and
      ***  Consolidated confirmation

     C     BPCONR        IFEQ      'Y'
     C                   MOVE      'N'           CNCF
     C                   ELSE
     C                   MOVE      *BLANK        CNCF
     C                   ENDIF

      ***  Update CLOAN
      ***  Write after status of CLOAN record

     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      'A'           CHTP
     C                   Z-ADD     P@NATN        TNLU
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      TMST=TimeStamp
     C                   UPDATE    CLOANCLF                             50
      *
     C                   ENDIF
      *
     C     *IN50         IFEQ      '1'
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRLOAM   - Update loan amendment file                         *
      * Called by: SRWRIT, SRUPDT                                     *
      * Calls    : SRNSEQ, SRINRE, SRUPRE, SRINMR, SRUPMR             *
      *****************************************************************
     C     SRLOAM        BEGSR

      ***  1) Update/create Past due/ Repayment Scheduled Record

     C                   Z-ADD     0             SLASN             3 0
     C                   Z-ADD     0             XLASN             3 0
      *
     C     WWACTN        IFEQ      'I'

      ***  input details

     C                   Z-ADD     MRXAVD        WVALD
     C                   MOVE      MRXASQ        SLASN
     C                   Z-ADD     0             COFAR                                      AR927395
     C                   ENDIF
      *
     C     WWACTN        IFEQ      'R'

      ***  Current Loan Amendment has Expected date/seq

     C     MRXAVD        IFNE      0
     C     MRXASQ        ANDNE     0
     C                   Z-ADD     MRXAVD        WVALD
     C                   MOVE      MRXASQ        SLASN
     C                   ELSE
     C                   Z-ADD     DAYNO         WVALD                          = MRVDAT (FCTYSR)
     C                   MOVE      MRXASQ        SLASN
     C                   ENDIF
      *
     C                   ENDIF

      ***  Setup XLASN

     C                   MOVE      SLASN         XLASN

      ***  Expected payment date filled , or Reverse or Insert

     C     DDESEQ        IFNE      *BLANKS                                      Expect. paym.(RE/PD)
     C     WWACTN        ANDNE     'A'                                          Not Amend
     C     WWACTN        ANDNE     'X'                                          Not authorise

      ***  Get next available sequence for Insert of related RE

     C                   IF        DDESEQ = 'LN '
     C                   EXSR      SRNSEQ
     C                   MOVE      SLASN         XLASN
     C                   ENDIF

      ***  Chain to related LOAM record (Past due or Repayment schedule)

     C     KLMKEY        CHAIN     LOAMS                              50        Lock current Details
      *
     C     WWACTN        IFEQ      'R'                                          Reverse
     C     RECI          ANDNE     'D'                                            Not Live
     C     WWACTN        OREQ      'I'                                          Insert
     C     *IN50         ANDEQ     *OFF                                           Found
     C     RECI          ANDEQ     'D'                                            Live
     C     DDESEQ        ANDEQ     'LN '                                          ESEQ = 'LN '
     C     WWACTN        OREQ      'I'                                          Insert
     C     RECI          ANDNE     'D'                                            Not live
     C     *IN50         ANDEQ     *OFF                                           Found
     C     DDESEQ        ANDNE     'LN '                                          ESEQ <> 'LN '
     C     WWACTN        ORNE      'I'                                          Not Insert
     C     *IN50         ANDEQ     *ON                                            Found
     C                   SETON                                        U7U8
     C                   EVAL      @@RTCD = '*RECUPD'
     C     *LOCK         IN        LDA
     C                   MOVEL     'LEMAPYUPD'   DBPGM
     C                   Z-ADD     20            DBASE                          ************
     C                   MOVE      'LOAMS'       DBFILE                         * DBERR 20 *
     C                   MOVEL     KLKEY         DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ***  Save Before status of Related record

     C                   Z-ADD     PRAM          OPRAM
     C                   Z-ADD     INTA          OINTA
     C                   Z-ADD     PNAM          OPNAM
     C                   Z-ADD     TAMT          OTAMT
     C                   Z-ADD     WTXA          OWTXA
     C                   Z-ADD     COFA          OCOFA                                      AR927395

      ***  Repayment schedule only

     C     AMTP          IFEQ      'RE'
      *
     C     REPTL         IFNE      3
     C     WWACTN        IFEQ      'I'

      ***  Principal = Principal - Manual Repayment Principal amount

     C     PRAM          SUB       PRAMR         PRAM
      *                                                                                    MD020445A
     C                   IF        PRAM < 0                                                MD020445A
     C                   EVAL      PRAM = 0                                                MD020445A
     C                   ENDIF                                                             MD020445A
      *                                                                                    MD020445A
     C                   ENDIF
      *
     C     WWACTN        IFEQ      'R'

      ***  Principal = Principal + Manual Repayment Principal Amount

     C     PRAM          ADD       PRAMR         PRAM
     C                   ENDIF
     C                   ENDIF                                                  REPTL = 3
      *
     C     REPTL         IFEQ      2
     C     WWACTN        IFEQ      'I'
     C     TAMT          SUB       PRAMR         TAMT
      ***  Total  = Total - Manual Repayment Principal Amount
     C                   IF        TAMT < 0                                                MD020445A
     C                   EVAL      TAMT = 0                                                MD020445A
     C                   ENDIF                                                             MD020445A
     C                   ENDIF
     C     WWACTN        IFEQ      'R'
     C     TAMT          ADD       PRAMR         TAMT
      ***  Total  = Total + Manual Repayment Principal Amount
     C                   ENDIF
     C                   ENDIF                                                  REPTL = 2
      *
     C     REPTL         IFEQ      3                                            REPTL = 3
     C     WWACTN        IFEQ      'I'
      ***  Total  = Total - Manual Repayment Total Amount
     C     TAMT          SUB       TAMTR         TAMT
      *                                                                                    MD020445A
     C                   IF        TAMT < 0                                                MD020445A
     C                   EVAL      TAMT = 0                                                MD020445A
     C                   ENDIF                                                             MD020445A
      *                                                                                    MD020445A
     C                   ENDIF
     C     WWACTN        IFEQ      'R'
      ***  Total  = Total - Manual Repayment Total Amount
     C     TAMT          ADD       TAMTR         TAMT
     C                   ENDIF
     C                   ENDIF                                                  REPLT
      *
     C                   ENDIF                                                  Repayment Schedule

      ***  For Past Due Details

     C     AMTP          IFEQ      'PD'
      *
     C     WWACTN        IFEQ      'I'
      ***  Principal  = Principal  - Manual Repayment Principal Amount
      ***  Interests  = Interest   - Manual Repayment Interest  Amount
      ***  W/hold Tax = W/hold Tax - Manual Repayment W/hold Tax Amount
      ***  Total      = Total      - Manual Repayment Total Amount
     C     PRAM          SUB       PRAMR         PRAM
     C     INTA          SUB       INTAR         INTA
     C     WTXA          SUB       WTXAR         WTXA
     C     TAMT          SUB       TAMTR         TAMT
      *                                                                                     AR927395
     C     BGN0ST        IFEQ      'Y'                                                      AR927395
     C     OINTA         ANDNE     0                                                        AR927395
     C     INTA          IFEQ      0                                                        AR927395
     C                   Z-ADD     OCOFA         COFAR                                      AR927395
     C                   ELSE                                                               AR927395
     C     INTAR         MULT      OCOFA         COFAR                                      AR927395
     C     COFAR         DIV       OINTA         COFAR                                      AR927395
     C                   ENDIF                                                              AR927395
     C     OCOFA         SUB       COFAR         COFA                                       AR927395
     C                   ENDIF                                                              AR927395
      *                                                                                     AR927395
     C                   ENDIF

     C     WWACTN        IFEQ      'R'
      ***  Principal  = Principal  + Manual Repayment Principal Amount
      ***  Interests  = Interest   + Manual Repayment Interest  Amount
      ***  W/hold Tax = W/hold Tax + Manual Repayment W/hold Tax Amount
      ***  Total      = Total      + Manual Repayment Total Amount
     C     PRAM          ADD       PRAMR         PRAM
     C     INTA          ADD       INTAR         INTA
     C     WTXA          ADD       WTXAR         WTXA
     C     TAMT          ADD       TAMTR         TAMT
     C     COFA          ADD       COFAR         COFA                                       AR927395
     C                   ENDIF
      *
     C                   ENDIF                                                  End Past Due Rec.
      *
     C     DDESEQ        IFEQ      'LN '
      ***  Principal  = Loan Repayment Amount - Manual Repayment Principal Amount
     C     RAMTS         SUB       PRAMR         PRAM
      *                                                                                    MD020445A
     C                   IF        PRAM < 0                                                MD020445A
     C                   EVAL      PRAM = 0                                                MD020445A
     C                   ENDIF                                                             MD020445A
      *
     C                   SELECT
     C     REPTL         WHENEQ    1
     C                   Z-ADD     0             TAMT
      ***  Total      = 0
     C     REPTL         WHENEQ    2
      ***  Total      = Principal Amount
     C                   Z-ADD     PRAM          TAMT
     C     REPTL         WHENEQ    3
     C                   Z-ADD     0             PRAM
      ***  Total      = Loan Repayment Amount - Manual Repayment Total Amount
     C     RAMTS         SUB       TAMTR         TAMT
     C                   IF        TAMT < 0                                                MD020445A
     C                   EVAL      TAMT = 0                                                MD020445A
     C                   ENDIF                                                             MD020445A
     C                   ENDSL
      *
     C                   ENDIF

      ***  Save after status of TAMT of RE/PD

     C                   Z-ADD     TAMT          TAMTS            13 0
      *
     C     DDESEQ        IFEQ      'LN '
     C                   BITOFF    '01234567'    BIT               1
     C                   MOVE      BIT           LAIN
     C                   TESTB     '3'           TLXI                     86
     C   86              BITON     '1'           LAIN
     C                   TESTB     '2'           CBLI                     86
     C   86              BITON     '45'          LAIN
     C                   BITON     '27'          LAIN

      ***  Write new RE record

     C                   Z-ADD     1             XASQ
     C                   EXSR      SRINRE
      *
     C                   MOVE      *BLANKS       PCOB
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      TMST=TimeStamp
      *                                                                                      BUG3760
      ** Execute SRWTCH if compliance watch is installed, watch list checking                BUG3760
      ** is applied and in the main system.                                                  BUG3760
      *                                                                                      BUG3760
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y' AND                         BUG3760
     C                             AMTP = 'RE'                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        MRRONS <> *BLANKS OR                                      BUG3760
     C                             MRRIBN <> *BLANKS OR                                      BUG3760
     C**********                   MRROBN <> *ZERO   OR                               BUG3760 CSD027
     C**********                   MRROCN <> *ZERO   OR                               BUG3760 CSD027
     C                             MRROBN <> *BLANKS OR                                       CSD027
     C                             MRROCN <> *BLANKS OR                                       CSD027
     C                             MRPONS <> *BLANKS OR                                      BUG3760
     C                             MRPIBN <> *BLANKS OR                                      BUG3760
     C**********                   MRPOBN <> *ZERO   OR                               BUG3760 CSD027
     C**********                   MRPOCN <> *ZERO   OR                               BUG3760 CSD027
     C                             MRPOBN <> *BLANKS OR                                       CSD027
     C                             MRPOCN <> *BLANKS OR                                       CSD027
     C                             MRRCRN <> *BLANKS OR                                      BUG3760
     C                             MRRVNO <> *BLANKS OR                                      BUG3760
     C                             MRAWBN <> *BLANKS OR                                      BUG3760
     C                             MRBENN <> *BLANKS OR                                      BUG3760
     C                             MRDTP1 <> *BLANKS OR                                      BUG3760
     C                             MRDTP2 <> *BLANKS OR                                      BUG3760
     C                             MRDTP3 <> *BLANKS OR                                      BUG3760
     C                             MRDTP4 <> *BLANKS                                         BUG3760
     C                   MOVEL     'Y'           WDTPC                                       BUG3760
     C                   MOVEL     MRRONS        WLF(1)                                      BUG3760
     C                   MOVEL     MRRIBN        WLF(2)                                      BUG3760
     C                   MOVEL     MRROBN        WLF(3)                                      BUG3760
     C                   MOVEL     MRROCN        WLF(4)                                      BUG3760
     C                   MOVEL     MRPONS        WLF(5)                                      BUG3760
     C                   MOVEL     MRPIBN        WLF(6)                                      BUG3760
     C                   MOVEL     MRPOBN        WLF(7)                                      BUG3760
     C                   MOVEL     MRPOCN        WLF(8)                                      BUG3760
     C                   MOVEL     MRRCRN        WLF(9)                                      BUG3760
     C                   MOVEL     MRRVNO        WLF(10)                                     BUG3760
     C                   MOVEL     MRAWBN        WLF(11)                                     BUG3760
     C                   MOVEL     MRBENN        WLF(12)                                     BUG3760
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
      ** If CAS009 is On, update LEEIRDPD if Insert or Reverse                                CAS011
      ** for all records affected by the value date of the                                    CAS011
      ** manual repayment record.                                                             CAS011
                                                                                              CAS011
     C     CAS009        IFEQ      'Y'                                                        CAS011
                                                                                              CAS011
     C     WWACTN        IFEQ      'I'                                                        CAS011
                                                                                              CAS011
     C                   IF        CAS016 = 'Y'                                               CAS019
     C     WLNRF         CHAIN     LEEIRDL9                           20                      CAS019
     C                   IF        MRMTPD = 'Y' OR                                            CAS019
     C                             PAST = 'Y' OR                                              CAS019
     C                             AMTP = 'PD'                                                CAS019
     C                   EVAL      *IN20 = *ON                                                CAS019
     C                   ENDIF                                                                CAS019
     C                   ELSE                                                                 CAS019
     C     WLNRF         CHAIN     LEEIRDL5                           20                      CAS011
     C                   ENDIF                                                                CAS019
     C     *IN20         IFEQ      '0'                                                        CAS011
                                                                                              CAS011
     C     VDAT          IFLE      EIENDT                                                     CAS011
     C                   MOVE      'Y'           EIRCAL                                       CAS011
     C                   IF        CAS016 = 'Y'                                               CAS019
     C                   EVAL      EIADJP = 'Y'                                             BUG17200
     C                   UPDATE    LEEIRDD9                                                   CAS019
     C                   ELSE                                                                 CAS019
     C                   UPDATE    LEEIRDD0                                                   CAS011
     C                   ENDIF                                                                CAS019
                                                                                              CAS019
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS019
     C                   EXSR      SRFeesAmort                                                CAS019
                                                                                              CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
                                                                                              CAP086
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      AUTH = MRAUTH                                              CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   WRITE     LOAMSDKF
     C                   MOVE      *BLANK        WAMTP

      ***  Update related amendment

     C                   ELSE                                                   Insert/Reverse PD/RE

      ***  Amend / authorise

     C     AMTP          IFEQ      'RE'
     C     AMTP          OREQ      'PD'
     C                   MOVE      AMTP          WAMTP             2
                                                                                             BUG3760
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
     C                   IF        RONS <> MRRONS                                            BUG3760
     C                   MOVEL     MRRONS        WLF(1)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        RIBN <> MRRIBN                                            BUG3760
     C                   MOVEL     MRRIBN        WLF(2)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        WROBN <> MRROBN                                           BUG3760
     C                   MOVEL     MRROBN        WLF(3)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        WROCN <> MRROCN                                           BUG3760
     C                   MOVEL     MRROCN        WLF(4)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        PONS <> MRPONS                                            BUG3760
     C                   MOVEL     MRPONS        WLF(5)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        PIBN <> MRPIBN                                            BUG3760
     C                   MOVEL     MRPIBN        WLF(6)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        WPOBN <> MRPOBN                                           BUG3760
     C                   MOVEL     MRPOBN        WLF(7)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        WPOCN <> MRPOCN                                           BUG3760
     C                   MOVEL     MRPOCN        WLF(8)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        RCRN <> MRRCRN                                            BUG3760
     C                   MOVEL     MRRCRN        WLF(9)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        RVNO <> MRRVNO                                            BUG3760
     C                   MOVEL     MRRVNO        WLF(10)                                     BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        AWBN <> MRAWBN                                            BUG3760
     C                   MOVEL     MRAWBN        WLF(11)                                     BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        BENN <> MRBENN                                            BUG3760
     C                   MOVEL     MRBENN        WLF(12)                                     BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        DTP1 <> MRDTP1 OR                                         BUG3760
     C                             DTP2 <> MRDTP2 OR                                         BUG3760
     C                             DTP3 <> MRDTP3 OR                                         BUG3760
     C                             DTP4 <> MRDTP4                                            BUG3760
     C                   MOVE      'Y'           WDTPC                                       BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   EXSR      SRUPRE
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      TMST=TimeStamp
      *                                                                                      BUG3760
      ** Execute SRWTCH if compliance watch is installed, watch list checking                BUG3760
      ** is applied and in the main system.                                                  BUG3760
      *                                                                                      BUG3760
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y' AND                         BUG3760
     C                             AMTP = 'RE' AND WWACTN = 'A'                              BUG3760
      *                                                                                      BUG3760
     C                   IF        CSC011 = 'Y' AND S1MAIN = LIBR OR                         BUG3760
     C                             CSC011 = 'N'                                              BUG3760
      *                                                                                      BUG3760
     C                   MOVEL     *BLANKS       WFuncType                                   BUG3760
     C                   MOVEL     *BLANKS       WIdntifier                                  BUG3760
     C                   MOVEL     *BLANKS       WBranch                                     BUG3760
     C                   MOVEL     *BLANKS       WKLNRF                                      BUG3760
     C                   MOVEL     *BLANKS       WKVDAT                                      BUG3760
     C                   MOVEL     *BLANKS       WLASN                                       BUG3760
      *                                                                                      BUG3760
     C                   MOVEL     'LOAMSDK'     WFuncType                                   BUG3760
     C                   MOVE      LNRF          WKLNRF                                      BUG3760
     C                   MOVE      VDAT          WKVDAT                                      BUG3760
     C                   MOVE      LASN          WLASN                                       BUG3760
     C                   EVAL      WIdntifier = WKLNRF + WKVDAT + WLASN                      BUG3760
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
      ** If CAS009 is On, update LEEIRDPD if Insert or Reverse                                CAS011
      ** for all records affected by the value date of the                                    CAS011
      ** manual repayment record.                                                             CAS011
                                                                                              CAS011
     C     CAS009        IFEQ      'Y'                                                        CAS011
                                                                                              CAS011
     C     WWACTN        IFEQ      'R'                                                        CAS011
                                                                                              CAS011
     C                   IF        CAS016 = 'Y'                                               CAS019
     C     WLNRF         CHAIN     LEEIRDL9                           20                      CAS019
     C                   IF        MRMTPD = 'Y' OR                                            CAS019
     C                             PAST = 'Y' OR                                              CAS019
     C                             AMTP = 'PD'                                                CAS019
     C                   EVAL      *IN20 = *ON                                                CAS019
     C                   ENDIF                                                                CAS019
     C                   ELSE                                                                 CAS019
     C     WLNRF         CHAIN     LEEIRDL5                           20                      CAS011
     C                   ENDIF                                                                CAS019
     C     *IN20         IFEQ      '0'                                                        CAS011
                                                                                              CAS011
     C     VDAT          IFLE      EIENDT                                                     CAS011
     C                   MOVE      'Y'           EIRCAL                                       CAS011
     C                   IF        CAS016 = 'Y'                                               CAS019
     C                   EVAL      EIADJP = 'Y'                                             BUG17200
     C                   UPDATE    LEEIRDD9                                                   CAS019
     C                   ELSE                                                                 CAS019
     C                   UPDATE    LEEIRDD0                                                   CAS011
     C                   ENDIF                                                                CAS019
                                                                                              CAS019
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS019
     C                   EXSR      SRFeesAmort                                                CAS019
                                                                                              CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
                                                                                              CAP086
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      AUTH = MRAUTH                                              CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   UPDATE    LOAMSDKF
     C                   ENDIF                                                  RE/PD
     C                   ENDIF                                                  LN
      *
     C                   ENDIF                                                  I/R with PD/RE

      ***  2)Create/update Manual Repayment with Validated details

     C                   MOVE      MRLASN        SLASN
      *
     C     WWACTN        IFEQ      'I'                                          Insert
      *
     C                   Z-ADD     MRVDAT        WVALD
                                                                                              CSC024
      ***Bypass*generate*Amendment*Seq.*No.*for*Insert*if*CSC024*is                    CSC024 CSC054
      ***switched*on*and*running*on*OME*system.                                        CSC024 CSC054
      ** Bypass generate Amendment Seq. No. for Insert if CSC054 is                           CSC054
      ** switched on and running on PEA system.                                               CSC054
                                                                                              CSC024
     C**********         IF        CSC024 <> 'Y' OR                                    CSC024 CSC054
     C**********                   WOMEInd <> 'Y' OR                                   CSC024 CSC054
     C                   IF        CSC054 <> 'Y' OR                                           CSC054
     C                             WPEAInd <> 'Y' OR                                          CSC054
     C                             SLASN = *ZERO                                              CSC024
                                                                                              CSC024
     C                   Z-ADD     0             SLASN
     C                   EXSR      SRNSEQ
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C                   EXSR      SRINMR

      ***  Output MR record

     C                   MOVE      LeVMapy       CMapyFilFmt
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      TMST=TimeStamp
      *                                                                                      BUG3760
      ** Execute SRWTCH if compliance watch is installed, watch list checking                BUG3760
      ** is applied and in the main system.                                                  BUG3760
      *                                                                                      BUG3760
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y' AND                         BUG3760
     C                             AMTP = 'MR'                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        MRRONS      <> *BLANKS OR                                 BUG3760
     C                             MRRIBN      <> *BLANKS OR                                 BUG3760
     C**********                   MRROBN      <> *ZERO   OR                          BUG3760 CSD027
     C**********                   MRROCN      <> *ZERO   OR                          BUG3760 CSD027
     C                             MRROBN      <> *BLANKS OR                                  CSD027
     C                             MRROCN      <> *BLANKS OR                                  CSD027
     C                             MRPONS      <> *BLANKS OR                                 BUG3760
     C                             MRPIBN      <> *BLANKS OR                                 BUG3760
     C**********                   MRPOBN      <> *ZERO   OR                          BUG3760 CSD027
     C**********                   MRPOCN      <> *ZERO   OR                          BUG3760 CSD027
     C                             MRPOBN      <> *BLANKS OR                                  CSD027
     C                             MRPOCN      <> *BLANKS OR                                  CSD027
     C                             MRRCRN      <> *BLANKS OR                                 BUG3760
     C                             MRRVNO      <> *BLANKS OR                                 BUG3760
     C                             MRAWBN      <> *BLANKS OR                                 BUG3760
     C                             MRBENN      <> *BLANKS OR                                 BUG3760
     C                             MRDTP1      <> *BLANKS OR                                 BUG3760
     C                             MRDTP2      <> *BLANKS OR                                 BUG3760
     C                             MRDTP3      <> *BLANKS OR                                 BUG3760
     C                             MRDTP4      <> *BLANKS                                    BUG3760
     C                   MOVEL     'Y'           WDTPC                                       BUG3760
     C                   MOVEL     MRRONS        WLF(1)                                      BUG3760
     C                   MOVEL     MRRIBN        WLF(2)                                      BUG3760
     C                   MOVEL     MRROBN        WLF(3)                                      BUG3760
     C                   MOVEL     MRROCN        WLF(4)                                      BUG3760
     C                   MOVEL     MRPONS        WLF(5)                                      BUG3760
     C                   MOVEL     MRPIBN        WLF(6)                                      BUG3760
     C                   MOVEL     MRPOBN        WLF(7)                                      BUG3760
     C                   MOVEL     MRPOCN        WLF(8)                                      BUG3760
     C                   MOVEL     MRRCRN        WLF(9)                                      BUG3760
     C                   MOVEL     MRRVNO        WLF(10)                                     BUG3760
     C                   MOVEL     MRAWBN        WLF(11)                                     BUG3760
     C                   MOVEL     MRBENN        WLF(12)                                     BUG3760
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
      ** If CAS009 is On, update LEEIRDPD if Insert or Reverse                                CAS011
      ** for all records affected by the value date of the                                    CAS011
      ** manual repayment record.                                                             CAS011
                                                                                              CAS011
     C     CAS009        IFEQ      'Y'                                                        CAS011
                                                                                              CAS011
     C     WWACTN        IFEQ      'I'                                                        CAS011
                                                                                              CAS011
     C                   IF        CAS016 = 'Y'                                               CAS019
     C     WLNRF         CHAIN     LEEIRDL9                           20                      CAS019
     C                   IF        MRMTPD = 'Y' OR                                            CAS019
     C                             PAST = 'Y' OR                                              CAS019
     C                             AMTP = 'PD'                                                CAS019
     C                   EVAL      *IN20 = *ON                                                CAS019
     C                   ENDIF                                                                CAS019
     C                   ELSE                                                                 CAS019
     C     WLNRF         CHAIN     LEEIRDL5                           20                      CAS011
     C                   ENDIF                                                                CAS019
     C     *IN20         IFEQ      '0'                                                        CAS011
                                                                                              CAS011
     C     VDAT          IFLE      EIENDT                                                     CAS011
     C                   MOVE      'Y'           EIRCAL                                       CAS011
     C                   IF        CAS016 = 'Y'                                               CAS019
     C                   EVAL      EIADJP = 'Y'                                             BUG17200
     C                   UPDATE    LEEIRDD9                                                   CAS019
     C                   ELSE                                                                 CAS019
     C                   UPDATE    LEEIRDD0                                                   CAS011
     C                   ENDIF                                                                CAS019
                                                                                              CAS019
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS019
     C                   EXSR      SRFeesAmort                                                CAS019
                                                                                              CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
                                                                                              CAP086
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      AUTH = MRAUTH                                              CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   IF        CLE134 = 'Y' AND AMTP = 'MR'                             MD020964
     C**********         MOVE      AUTOL         AUTO                                MD020964 CLE164
     C                   MOVE      DDAUTO        AUTO                                         CLE164
     C                   ENDIF                                                              MD020964
                                                                                            MD020964
     C                   WRITE     LOAMSDKF
                                                                                            MD020733
      ** Output records (same as LOAMSDK) to LELOMKPD                                       MD020733
      ** when loan amendment is MR auto-gen from PDCL online creation                       MD020733
                                                                                            MD020733
     C                   IF        CLE134 = 'Y' and AMTP = 'MR' and                         MD020733
     C                             UpSRFlg = 'Y'                                            MD020733
     C                   WRITE     LOMKSDKF                                                 MD020733
     C                   ENDIF                                                              MD020733
                                                                                            MD020733
     C**********         IF        MRASTS = 'A'                                      CLE134 MD020445
     C**********         EXSR      SRSCRP                                            CLE134 MD020445
     C**********         ENDIF                                                       CLE134 MD020445
      *
     C     CLE005        IFEQ      'Y'
     C     RECIL         ANDEQ     'M'
     C     WWACTN        ANDEQ     'I'
      *
     C                   Eval      WLOAN = LNRF
     C                   Eval      WRCDT = 'A'
      *
     C     KCLOAN        CHAIN     CLOAN                              39
     C     *IN39         IFEQ      '0'
     C                   MOVEL     'Y'           RATF
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      TMST=TimeStamp
     C                   UPDATE    CLOANCLF
                                                                                            MD049571
      ** Move Manual Repayment field values                                                 MD049571
                                                                                            MD049571
     C                   MOVE      LeVMapy       CMapyFilFmt                                MD049571
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                     AR927395
     C     BGN0ST        IFEQ      'Y'                                                      AR927395
     C     WWACTN        ANDEQ     'I'                                                      AR927395
     C     MRXASQ        ANDNE     0                                                        AR927395
     C     MRMTPD        ANDEQ     'Y'                                                      AR927395
     C                   Eval      WLOAN = LNRF                                             AR927395
     C                   Eval      WRCDT = 'A'                                              AR927395
     C     KCLOAN        CHAIN     CLOAN                              39                    AR927395
     C     *IN39         IFEQ      '0'                                                      AR927395
     C                   Z-ADD     COFAR         WRK13N           13 0                      AR927395
     C     PDCF          SUB       WRK13N        PDCF                                       AR927395
     C                   CALLB     'ZAGENTMSTM'                                             AR927395
     C                   PARM                    TimeStamp                                  AR927395
     C                   EVAL      TMST=TimeStamp                                           AR927395
     C                   UPDATE    CLOANCLF                                                 AR927395
     C                   ENDIF                                                              AR927395
     C                   ENDIF                                                              AR927395
      *
     C                   ELSE

      ***  Setup MR details for update

     C                   Z-ADD     MRVDAT        WVALD
     C                   MOVE      MRLASN        SLASN
     C     KLMKEY        CHAIN     LOAMS                              50
      *
                                                                                             BUG3760
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
     C                   IF        RONS <> MRRONS                                            BUG3760
     C                   MOVEL     MRRONS        WLF(1)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        RIBN <> MRRIBN                                            BUG3760
     C                   MOVEL     MRRIBN        WLF(2)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        WROBN <> MRROBN                                           BUG3760
     C                   MOVEL     MRROBN        WLF(3)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        WROCN <> MRROCN                                           BUG3760
     C                   MOVEL     MRROCN        WLF(4)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        PONS <> MRPONS                                            BUG3760
     C                   MOVEL     MRPONS        WLF(5)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        PIBN <> MRPIBN                                            BUG3760
     C                   MOVEL     MRPIBN        WLF(6)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        WPOBN <> MRPOBN                                           BUG3760
     C                   MOVEL     MRPOBN        WLF(7)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        WPOCN <> MRPOCN                                           BUG3760
     C                   MOVEL     MRPOCN        WLF(8)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        RCRN <> MRRCRN                                            BUG3760
     C                   MOVEL     MRRCRN        WLF(9)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        RVNO <> MRRVNO                                            BUG3760
     C                   MOVEL     MRRVNO        WLF(10)                                     BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        AWBN <> MRAWBN                                            BUG3760
     C                   MOVEL     MRAWBN        WLF(11)                                     BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        BENN <> MRBENN                                            BUG3760
     C                   MOVEL     MRBENN        WLF(12)                                     BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   IF        DTP1 <> MRDTP1      OR                                    BUG3760
     C                             DTP2 <> MRDTP2      OR                                    BUG3760
     C                             DTP3 <> MRDTP3      OR                                    BUG3760
     C                             DTP4 <> MRDTP4                                            BUG3760
     C                   MOVE      'Y'           WDTPC                                       BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   EXSR      SRUPMR
     C                   MOVE      LeVMapy       CMapyFilFmt
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      TMST=TimeStamp
      *                                                                                      BUG3760
      ** Execute SRWTCH if compliance watch is installed, watch list checking                BUG3760
      ** is applied and in the main system.                                                  BUG3760
      *                                                                                      BUG3760
     C                   IF        CSD015 = 'Y' AND W1EWLC = 'Y' AND                         BUG3760
     C                             AMTP = 'MR' AND WWACTN = 'A'                              BUG3760
      *                                                                                      BUG3760
     C                   IF        CSC011 = 'Y' AND S1MAIN = LIBR OR                         BUG3760
     C                             CSC011 = 'N'                                              BUG3760
      *                                                                                      BUG3760
     C                   MOVEL     *BLANKS       WFuncType                                   BUG3760
     C                   MOVEL     *BLANKS       WIdntifier                                  BUG3760
     C                   MOVEL     *BLANKS       WBranch                                     BUG3760
     C                   MOVEL     *BLANKS       WKLNRF                                      BUG3760
     C                   MOVEL     *BLANKS       WKVDAT                                      BUG3760
     C                   MOVEL     *BLANKS       WLASN                                       BUG3760
      *                                                                                      BUG3760
     C                   MOVEL     'LOAMSDK'     WFuncType                                   BUG3760
     C                   MOVE      LNRF          WKLNRF                                      BUG3760
     C                   MOVE      VDAT          WKVDAT                                      BUG3760
     C                   MOVE      LASN          WLASN                                       BUG3760
     C                   EVAL      WIdntifier = WKLNRF + WKVDAT + WLASN                      BUG3760
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
      ** If CAS009 is On, update LEEIRDPD if Insert or Reverse                                CAS011
      ** for all records affected by the value date of the                                    CAS011
      ** manual repayment record.                                                             CAS011
                                                                                              CAS011
     C     CAS009        IFEQ      'Y'                                                        CAS011
                                                                                              CAS011
     C     WWACTN        IFEQ      'R'                                                        CAS011
                                                                                              CAS011
     C                   IF        CAS016 = 'Y'                                               CAS019
     C     WLNRF         CHAIN     LEEIRDL9                           20                      CAS019
     C                   IF        MRMTPD = 'Y' OR                                            CAS019
     C                             PAST = 'Y' OR                                              CAS019
     C                             AMTP = 'PD'                                                CAS019
     C                   EVAL      *IN20 = *ON                                                CAS019
     C                   ENDIF                                                                CAS019
     C                   ELSE                                                                 CAS019
     C     WLNRF         CHAIN     LEEIRDL5                           20                      CAS011
     C                   ENDIF                                                                CAS019
     C     *IN20         IFEQ      '0'                                                        CAS011
                                                                                              CAS011
     C     VDAT          IFLE      EIENDT                                                     CAS011
     C                   MOVE      'Y'           EIRCAL                                       CAS011
     C                   IF        CAS016 = 'Y'                                               CAS019
     C                   EVAL      EIADJP = 'Y'                                             BUG17200
     C                   UPDATE    LEEIRDD9                                                   CAS019
     C                   ELSE                                                                 CAS019
     C                   UPDATE    LEEIRDD0                                                   CAS011
     C                   ENDIF                                                                CAS019
                                                                                              CAS019
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS019
     C                   EXSR      SRFeesAmort                                                CAS019
                                                                                              CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
                                                                                              CAP086
      ** Automatic Authorisation flag                                                         CAP086
                                                                                              CAP086
     C                   IF        CAP086 = 'Y'                                               CAP086
     C                   EVAL      AUTH = MRAUTH                                              CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CLE164
     C     CLE134        IFEQ      'Y'                                                        CLE164
     C                   MOVE      DDAUTO        AUTO                                         CLE164
     C                   ENDIF                                                                CLE164
                                                                                              CAP086
     C                   UPDATE    LOAMSDKF
     C**********         IF        WWACTN = 'X' AND MRCHTP = 'I'                     CLE134 MD020445
     C**********                   OR WWACTN = 'R' AND MRASTS = 'A'                  CLE134 MD020445
     C**********         EXSR      SRSCRP                                            CLE134 MD020445
     C**********         ENDIF                                                       CLE134 MD020445
      *
     C     CLE005        IFEQ      'Y'
     C     RECIL         ANDEQ     'M'
     C     WWACTN        ANDEQ     'R'
     C     WrkCntrMR     ANDEQ     1
      *
     C                   Eval      WLOAN = LNRF                                               CAP084
     C                   Eval      WRCDT = 'A'                                                CAP084
      *                                                                                       CAP084
     C     KCLOAN        CHAIN     CLOAN                              39
      *
     C     *IN39         IFEQ      '0'
     C                   MOVE      *BLANK        RATF
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      TMST=TimeStamp
     C                   UPDATE    CLOANCLF
     C                   ENDIF
     C                   ENDIF
      *                                                                                     AR927395
     C     BGN0ST        IFEQ      'Y'                                                      AR927395
     C     WWACTN        ANDEQ     'R'                                                      AR927395
     C     MRXASQ        ANDNE     0                                                        AR927395
     C     MRMTPD        ANDEQ     'Y'                                                      AR927395
     C                   Eval      WLOAN = LNRF                                             AR927395
     C                   Eval      WRCDT = 'A'                                              AR927395
     C     KCLOAN        CHAIN     CLOAN                              39                    AR927395
     C     *IN39         IFEQ      '0'                                                      AR927395
     C                   Z-ADD     COFAR         WRK13N                                     AR927395
     C     PDCF          ADD       WRK13N        PDCF                                       AR927395
     C                   CALLB     'ZAGENTMSTM'                                             AR927395
     C                   PARM                    TimeStamp                                  AR927395
     C                   EVAL      TMST=TimeStamp                                           AR927395
     C                   UPDATE    CLOANCLF                                                 AR927395
     C                   ENDIF                                                              AR927395
     C                   ENDIF                                                              AR927395
      *                                                                                     AR927395
     C                   ENDIF
      *
     C                   EXSR      SRLTRX
      *
      ***  If LNRF field is blanked out due to LTRIX chaining,
      ***  move MRLNRF value to the said field.
      *
     C*****LNRF*         IFEQ      0                                                          CLE148
     C     LNRF          IFEQ      *BLANKS                                                    CLE148
     C                   MOVE      MRLNRF        LNRF
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRFEES  -  Update Fees File                                   *
      * Called by: SRWRIT - Write a new record in file                *
      *            SRUPDT - Update records                            *
      * Calls    : None                                               *
      *****************************************************************
     C     SRFEES        BEGSR

      ***  If authorisation switchable feature is on and action code
      ***  is insert or amend and Manual Repayments Authorisations is
      ***  required

     C     CLE002        IFEQ      'Y'
     C     WWACTN        ANDNE     'X'
     C     WWACTN        ANDNE     'R'
     C     BPMRAU        ANDEQ     'Y'

      ***  If action code is insert

     C     WWACTN        IFEQ      'I'

      ***  Write a record to Loan Amendment Fee Index File

     C                   MOVE      MRLNRF        FFLNRF
     C                   Z-ADD     MRVDAT        FFVDAT
     C                   MOVE      MRLASN        FFLASN
     C                   MOVE      *BLANKS       FFAUTH
     C                   MOVE      WKSWRI        FFSWRI
     C                   WRITE     LEFELAD0
      *
     C                   ENDIF

      ***  If action code is amend

     C     WWACTN        IFEQ      'A'

      ***  Chain to Loan Amendment Fee Index File

     C                   MOVE      MRLNRF        WKLOAN
     C                   Z-ADD     MRVDAT        WKDATE
     C                   MOVE      MRLASN        WKSEQN
     C     KIDXF         CHAIN     LEFELAL0                           13

      ***  If record not found

     C     *IN13         IFEQ      *ON

      ***  Write a record to Loan Fee Index File

     C                   MOVE      MRLNRF        FFLNRF
     C                   Z-ADD     MRVDAT        FFVDAT
     C                   MOVE      MRLASN        FFLASN
     C                   MOVE      'Y'           FFAUTH
     C                   MOVE      WKSWRI        FFSWRI
     C                   WRITE     LEFELAD0
      *
     C                   ELSE

      ***  If work regeneration indicator is changed and regeneration
      ***  indicator is blank

     C     WKSWRI        IFEQ      'C'
     C     FFSWRI        ANDEQ     *BLANKS

      ***  Update the record to Loan Amendment Fee Index File

     C                   MOVE      WKSWRI        FFSWRI
     C                   UPDATE    LEFELAD0
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE

      ***  If action code is authorise

     C     WWACTN        IFEQ      'X'

      ***  Chain to Loan Amendment Fee Index File

     C                   MOVE      MRLNRF        WKLOAN
     C                   Z-ADD     MRVDAT        WKDATE
     C                   MOVE      MRLASN        WKSEQN
     C     KIDXF         CHAIN     LEFELAL0                           13

     C     *IN13         IFEQ      *OFF                                         Found

      ***  Update the record to Loan Amendment Fee Index File

     C                   MOVE      FFSWRI        WKSWRI
     C                   MOVE      'Y'           FFAUTH
     C                   UPDATE    LEFELAD0
     C                   ENDIF
      *
     C                   ENDIF

      ***  If action code is reverse

     C     WWACTN        IFEQ      'R'
      *
      ***  Chain to Loan Amendment Fee Index File
      *
     C                   MOVE      MRLNRF        WKLOAN
     C                   Z-ADD     MRVDAT        WKDATE
     C                   MOVE      MRLASN        WKSEQN
     C     KIDXF         CHAIN     LEFELAL0                           13

     C     *IN13         IFEQ      *OFF                                         Found

      ***  If authorised is blank

     C     FFAUTH        IFEQ      *BLANKS
     C                   MOVE      *BLANKS       WKSWRI
     C                   ELSE

      ***  If work regeneration indicator is blank

     C     WKSWRI        IFEQ      *BLANKS
     C                   MOVE      FFSWRI        WKSWRI
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

      ***  If work regeneration indicator is changed

     C     WKSWRI        IFEQ      'C'

      ***  Check if the facility has an associated fee

     C                   MOVE      CL_FTYP       CHFACT            3
     C                   MOVE      CL_FSEQ       CHFCNO            2
     C     CHFACT        CAT       CHFCNO        CHFACL            5
     C                   MOVE      CHFACL        WFFACL
     C**********         Z-ADD     0             WFLOAN                                       CLE148
     C                   MOVEL     *BLANKS       WFLOAN                                       CLE148
     C     WKFEE         SETLL     LEFEEDL1
     C*****WKFEE         READE     LEFEEDL1                               14                MD054035
     C     WKFEE         READE (N) LEFEEDL1                               14                MD054035

      ***  Do while an associated fee exists

     C     *IN14         DOWEQ     *OFF

     C                   MOVE      FEAUTO        WFEAUT            1                          CLE134
     C     CLE134        IFEQ      'Y'                                                        CLE134
     C     WFEAUT        IFEQ      'C'                                                        CLE134
     C     FEAUT2        OREQ      'C'                                                        CLE134
     C                   MOVE      'Y'           WFEAUT            1                          CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
      ***  If the fee is a confirmed calculated fee and swift
      ***  regeneration indicator is not 'I', 'B', 'H'

     C*****FEAUTO        IFEQ      'Y'                                                        CLE134
     C     WFEAUT        IFEQ      'Y'                                                        CLE134
     C     FECALT        ANDNE     *BLANKS
     C     FESWRI        ANDNE     'I'
     C     FESWRI        ANDNE     'B'
     C     FESWRI        ANDNE     'H'

      ***  Set currency to fee currency
      ***  Set day to run date
      ***  Set number of working days to telex notice days

     C                   MOVE      FEFCCY        ZCCY
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   Z-ADD     1             Y
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
     C                   MOVE      WKCCY         PCURR                                      MD054317
      *                                                                                     MD054317
     C*****FEFCCY        LOOKUP    CYA(Y)                                 12                MD054317
     C     WKCCY         LOOKUP    CYA(Y)                                 12                MD054317
     C                   MOVE      *OFF          *IN12
     C                   MOVE      TND(Y)        ZNRDYS

      ***  If Fee Settlement type is '01', '02', '07', '08' or '12'

     C     FESTTL        IFEQ      01
     C     FESTTL        OREQ      02
     C     FESTTL        OREQ      07
     C     FESTTL        OREQ      08
     C     FESTTL        OREQ      12
      *
     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCUSN             6
     C**********         PARM      FEFCCY        PCURR                                      MD054317
     C                   PARM                    PCURR                                      MD054317
     C**********         PARM                    PACCD             4                          CGL029
     C                   PARM                    PACCD                                        CGL029
     C                   PARM                    PACSN             2
     C                   PARM      FEOURS        PNONB             2
     C                   PARM                    PBRCA
     C                   PARM                    PCSSN            10
     C                   PARM                    PPNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVEL     'LEMAPYUPD'   DBPGM
     C                   MOVEL     'AONOSTR0'    DBFILE                         ************
     C                   Z-ADD     21            DBASE                          * DBERR 21 *
     C                   MOVEL     FEFCCY        DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE

      ***  Set Location to Nostro Location

     C                   MOVE      A7NOSN        ZLOC
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVE      *BLANKS       ZLOC
      *
     C                   ENDIF

      ***  Calculate number of working days forward

     C                   CallB     'ZFWDT'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZNRDYS            2 0
     C                   PARM                    ZDYNBR            5 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3

      ***  Set Telex Notice date to day number

     C                   Z-ADD     ZDYNBR        TXDT              5 0

     C                   MOVEL     FECNUM        WFCNUMX                                    MD054035
     C                   MOVEL     FEFACL        WFFACLX                                    MD054035
     C                   MOVEL     FELOAN        WFLOANX                                    MD054035
     C                   MOVEL     FEFSEQ        WFSEQNX                                    MD054035

      ***  If next payment date is before or equals to Telex Notice date
      ***  and Next Payment Telex indicator is set to 'Y'

     C     FENPYD        IFLE      TXDT
     C     FEPPTI        ANDEQ     'Y'

      ***  Update Fees file

     C     WKFEEX        CHAIN     LEFEEDL0                                                 MD054035
     C                   IF        %FOUND(LEFEEDL0)                                         MD054035
     C**********         MOVE      'A'           FESWRI                                     MD054035
     C**********         Eval      FELCHD = BJRDNB                                   243154 MD054035
     C**********         UPDATE    LEFEEDF                                                  MD054035
     C                   MOVE      'A'           X_FESWRI                                   MD054035
     C                   EVAL      X_FELCHD = BJRDNB                                        MD054035
     C                   UPDATE    LEFEEDX                                                  MD054035
     C                   ENDIF                                                              MD054035
     C                   ELSE

      ***  If end date is before or equals to Telex Notice date and End
      ***  Telex indicator is set to 'Y'

     C     FEPEND        IFLE      TXDT
     C     FEEPTI        ANDEQ     'Y'

      ***  Update Fees file

     C     WKFEEX        CHAIN     LEFEEDL0                                                 MD054035
     C                   IF        %FOUND(LEFEEDL0)                                         MD054035
     C**********         MOVE      'A'           FESWRI                                     MD054035
     C**********         Eval      FELCHD = BJRDNB                                   243154 MD054035
     C**********         UPDATE    LEFEEDF                                                  MD054035
     C                   MOVE      'A'           X_FESWRI                                   MD054035
     C                   EVAL      X_FELCHD = BJRDNB                                        MD054035
     C                   UPDATE    LEFEEDX                                                  MD054035
     C                   ENDIF                                                              MD054035
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C*****WKFEE         READE     LEFEEDL1                                                 MD054035
     C     WKFEE         READE (N) LEFEEDL1                               14                MD054035
     C                   ENDDO
      *                                                                                       CLE073
      ** Check if the loan has an associated fee                                              CLE073
      *                                                                                       CLE073
     C                   IF        CLE073 = 'Y'                                               CLE073
     C                             OR CLE134 = 'Y'                                            CLE134
     C                   EXSR      CHKLON                                                     CLE073
     C                   ENDIF                                                                CLE073
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       WKSWRI
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      * SRUPCA   - Sub-routine to update credit agreement             *
      * Called by: SRFCLT                                             *
      * Calls    : FCLTSR                                             *
      *****************************************************************
     C     SRUPCA        BEGSR

      ***  Whenever the facility utilisation is updated for a tranche,
      ***  update the credit agreement/superfacility as well

     C                   MOVE      FCCY          WTCCY             3
     C                   MOVE      CMDI          WCMDI             1
     C                   Z-ADD     CAXR          WCAXR            13 8
     C                   MOVEL     CANM          WFCUS
     C                   MOVEL     CAFT          WFTYP
     C                   MOVEL     CAFN          WFSEQ
     C                   MOVE      'A'           WRCDT1

      ***  Save the revolving credit indicator specified for the tranche

     C     CLE014        IFEQ      'Y'
     C                   MOVE      RVCRF         WRVCRF            1
     C                   ENDIF
      *
     C     KFCLT         CHAIN(N)  FCLTY                              79
      *
     C     *IN79         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVEL     'LEMAPYUPD'   DBPGM
     C                   MOVEL     'FCLTY'       DBFILE                         ************
     C                   Z-ADD     22            DBASE                          * DBERR 22 *
     C                   MOVEL     FCLKEY        DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ***  If the revolving credit indicator for the credit agreement is
      ***  'T', use the saved tranche revolving credit indicator as the
      ***  credit agreement revolving indicator.

     C     CLE014        IFEQ      'Y'
      *
     C     RVCRF         IFEQ      'T'
     C                   MOVE      WRVCRF        RVCRF
     C                   ENDIF
      *
     C                   ENDIF
     C                   MOVE      'B'           WRCDT1
     C     KFCLT         CHAIN     FCLTY                              79
      *
     C     *IN79         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVEL     'LEMAPYUPD'   DBPGM
     C                   MOVEL     'FCLTY   '    DBFILE                         ************
     C                   Z-ADD     23            DBASE                          * DBERR 23 *
     C                   MOVEL     FCLKEY        DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ***  If tranche and superfacility currencies are different, get
      ***  superfacility currency details

     C     WTCCY         IFNE      FCCYF
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*KEY   '     POPTN             7
     C                   PARM      FCCYF         PCURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVEL     'LEMAPYUPD'   DBPGM
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   Z-ADD     24            DBASE                          * DBERR 24 *
     C                   MOVEL     FCCY          DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ***  Convert facility amount to credit facility currency

     C                   Z-ADD     A6NBDP        CDPC              1 0
     C                   Eval      CX = CDPC - CDPF + 4
     C     WCMDI         IFEQ      'D'
     C     WCAXR         DIV(H)    POWR(Cx)      OFCXRT
     C     1             DIV       OFCXRT        OFCXRT
     C                   ELSE
     C     WCAXR         MULT(H)   POWR(CX)      OFCXRT
     C                   ENDIF
      *
     C                   MULT(H)   OFCXRT        PRAM_Fac

      ***  Convert facility amount to Credit agreement facility using spot
      ***  rate for later update of Current exposure

     C     CLE023        IFEQ      'Y'
     C                   Z-ADD     WSPRTF        ZRATE1
     C                   MOVE      WMDINF        ZMDI1
     C                   Z-ADD     A6SPRT        ZRATE2
     C                   MOVE      A6MDIN        ZMDI2
     C                   Z-ADD     CDPF          ZNBDP1
     C                   Z-ADD     CDPC          ZNBDP2
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1           13 8
     C                   PARM                    ZMDI1             1
     C                   PARM                    ZRATE2           13 8
     C                   PARM                    ZMDI2             1
     C                   PARM                    ZRATEX           13 8
     C                   PARM                    ZMDIX             1
      *
     C                   Z-ADD     WrkPRAMS      ZAMTCI           15 0
     C                   Z-ADD     ZRATEX        ZEXCH            13 8
     C                   MOVE      ZMDIX         ZMD               1
     C                   MOVE      WTCCY         ZCCYI             3
     C                   MOVE      FCCYF         ZCCYO             3
     C                   Z-ADD     ZNBDP1        ZCDPI             1 0
     C                   Z-ADD     ZNBDP2        ZCDPO             1 0
     C                   CallB     'ZCONV'
     C                   PARM                    ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
     C                   PARM      0             ZAMTCO           15 0
      *
     C                   Z-ADD     ZAMTCO        WrkPRAMS         13 0
     C                   ENDIF
     C                   ENDIF

      ***  Update facility exposure and availability

     C                   MOVE      'Y'           WTRCA             1
     C                   IF        CLE134 = 'Y'                                             AR806351
     C                   EVAL      WUpdExpo = 'Y'                                           AR806351
     C                   EXSR      SrPDCLMR                                                 AR806351
     C                   ENDIF                                                              AR806351
      *                                                                                     AR806351
     C                   EXSR      FCLTSR
     C                   Z-ADD     BJRDNB        LCD                            Update rec 'B'
     C                   MOVE      'A'           CHTP
     C                   Z-ADD     P@NATN        TNLU
     C                   UPDATE    FCLTYFNF                             50
     C                   MOVE      *BLANK        WTRCA
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FCLTSR   - Sub-routine to update exposure.                    *
      *            internal customer.                                 *
      * Called by: SRFCLT                                             *
      * Calls    :  QFCLTY                                            *
      *****************************************************************
     C     FCLTSR        BEGSR

      ***  Convert amounts into facility currency equivalent

     C     WTRCA         IFEQ      *BLANK
      *
     C     CLE023        IFEQ      'Y'
     C     RLDT          ANDLT     BJRDNB
     C     RLDT          ANDNE     *ZERO
     C     NFCE          ANDNE     *ZERO
     C     NCCY          ANDEQ     *BLANKS
     C                   Z-ADD     NFCE          WFCXR            13 8
     C                   MOVE      'Y'           WROFXR            1
     C                   ELSE
     C                   Z-ADD     FCXR          WFCXR
     C                   MOVE      'N'           WROFXR            1
     C                   ENDIF
      *
     C     CDPF          SUB       WCDP          CX                1 0
     C     CX            ADD       4             CX
     C     FMDI          IFEQ      'D'
     C     WROFXR        ANDEQ     'N'
     C     NFMD          OREQ      'D'
     C     WROFXR        ANDEQ     'Y'
     C     WFCXR         MULT(H)   Powr(Cx)      OFCXRT           15 9
     C     1             DIV       OFCXRT        OFCXRT
     C                   ELSE
     C     WFCXR         MULT(H)   Powr(Cx)      OFCXRT           15 9
     C                   ENDIF
      *
     C     PRAMR         MULT(H)   OFCXRT        PRAM_Fac         13 0

      ***  Convert amount to facility currency using spot rates

     C     CLE023        IFEQ      'Y'
     C                   MOVE      WMDINL        ZMDI1             1
     C                   Z-ADD     WSPRTL        ZRATE1           13 8
     C                   Z-ADD     WCDP          ZNBDP1            1 0
     C                   MOVE      WMDINF        ZMDI2             1
     C                   Z-ADD(H)  WSPRTF        ZRATE2           13 8
     C                   Z-ADD     CDPF          ZNBDP2            1 0
     C                   CALLB     'ZXRATE'
     C                   PARM                    ZRATE1           13 8
     C                   PARM                    ZMDI1             1
     C                   PARM                    ZRATE2           13 8
     C                   PARM                    ZMDI2             1
     C                   PARM      0             ZRATEX           13 8
     C                   PARM      *blanks       ZMDIX             1
      *
     C                   Z-ADD     ZRATEX        ZEXCH            13 8
     C                   MOVE      ZMDIX         ZMD               1
     C                   Z-ADD     PRAMR         ZAMTCI           15 0
     C                   MOVE      CCYL          ZCCYI             3
     C                   MOVE      FCCY          ZCCYO             3
     C                   Z-ADD     ZNBDP1        ZCDPI             1 0
     C                   Z-ADD     ZNBDP2        ZCDPO             1 0
     C                   CallB     'ZCONV'
     C                   PARM                    ZAMTCI
     C                   PARM                    ZEXCH
     C                   PARM                    ZMD
     C                   PARM                    ZCCYI
     C                   PARM                    ZCCYO
     C                   PARM                    ZCDPI
     C                   PARM                    ZCDPO
     C                   PARM      0             ZAMTCO           15 0
      *
     C                   Z-ADD     ZAMTCO        WrkPRAMS         13 0
     C                   ENDIF
      *
     C                   ENDIF

      ***  Set up fields for availability updating

     C                   Z-ADD     MDAT          ENDAY             5 0    40
     C     *IN40         IFEQ      '1'
     C                   Z-ADD     99999         ENDAY
     C                   ENDIF
     C                   Z-ADD     MRVDAT        DAYNO             5 0
      *
     C                   MOVEA     '00'          *IN(41)

      ***  Similar update for a non-syndicated loan and part purchased,
      ***  internal parts purchased and funding participant

     C     RVCRF         IFEQ      'Y'
     C     WRVCRC        ANDEQ     ' '                                                       245177A
     C     RVCRF         OREQ      'N'                                                       245177A
     C     WRVCRC        ANDEQ     'Y'                                                       245177A
     C     WVLDT         ANDLE     BJRDNB                                                    245177A
     C     WrkPart       OREQ      'Y'
     C     GASS          ANDEQ     'A'
      *
      ***  Participation sold
      *
     C     *IN52         IFEQ      '0'
     C     LPFI          ANDEQ     ' '
     C     WrkPart       OREQ      'Y'
     C     WWACTN        IFEQ      'I'
     C                   MOVE      '1'           *IN41
     C                   ELSE
     C                   MOVE      '1'           *IN42
     C                   ENDIF

      ***  Similar update for a non-syndicated parts sold, and prime facilities

     C                   ELSE
     C     WWACTN        IFEQ      'I'
     C                   MOVE      '1'           *IN42
     C                   ELSE
     C                   MOVE      '1'           *IN41
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   IF        CLE134 = 'Y'   AND                                       AR806351
     C                             WUpdExpo= 'Y'   OR                                       AR806351
     C                             CLE134 = 'N'                                             AR806351
     C                   Z-ADD     PRAM_Fac      FCBAL            13 0
     C                   ELSE                                                               AR806351
     C                   Z-ADD     0             PRAM_Fac                                   AR806351
     C                   Z-ADD     0             FCBAL                                      AR806351
     C                   Z-ADD     0             WrkPRAMS                                   AR806351
     C                   ENDIF                                                              AR806351

      ***  Do not update for parts sold with recourse and
      ***  if CLE023 is not installed.  If CLE023 is installed, do not
      ***  update for parts sold for non-participant facility with or
      ***  without recourse.  Also do not update
      ***  Prime facility of a syndicated loan

     C     *IN52         IFEQ      '1'
     C     RCSI          ANDEQ     'Y'
     C     LPFI          ANDEQ     ' '
     C     CLE023        ANDEQ     'N'
      *
     C     *IN52         OREQ      '1'
     C     LPFI          ANDEQ     ' '
     C     CLE023        ANDEQ     'Y'
      *
     C     WrkPart       OREQ      'N'
     C     LPFI          ANDNE     ' '
     C                   MOVEA     '00'          *IN(41)
     C                   endif

      ***  If customer is branch internal customer, then no update to
      ***  facility availability

     C                   EXSR      SRCIBC
      *
      ***  If ind. 43 is on, then customer is an internal customer.
      ***  Or, if LPFI equals 'I', then loan is an IPP.
      *
     C     *IN43         IFEQ      '1'
     C     LPFI          ANDNE     'I'
     C     LPFI          OREQ      'I'
     C     WrkPart       ANDEQ     'N'
     C                   MOVE      '0'           *IN43
     C                   ELSE
      *
     C     *IN41         IFEQ      '1'
     C     *IN42         OREQ      '1'
     C                   EXSR      QFCLTY
     C                   ENDIF
      *
     C                   ENDIF

      ***  UPDATE EXPOSURE
      *
      ***  Internal parts purchased and funding participants are updated
      ***  just like any normal loan.  Prime facilities are updated only
      ***  when sold without recourse just like a parts sold
      ***  Also, since future-dated manual repayments can now be entered,
      ***  update exposure only when value date is not in the future
      ***  Update CAMD of Prime or normal facility only if loan is not
      ***  a parts sold.  If CLE023 is installed, update the exposure
      ***  only if normal loan or a funded loan is sold without recourse

     C     MRVDAT        IFLE      BJRDNB
     C     LPFI          IFNE      *BLANK
     C     WWACTN        IFEQ      'I'
     C     WrkPart       ANDEQ     'Y'
     C     WWACTN        OREQ      'R'
     C     WrkPart       ANDEQ     'N'
     C     RCSI          ANDNE     'Y'
     C     LPFI          ANDNE     'I'
      *
     C     WrkPart       IFEQ      'Y'
     C     CLE023        ANDEQ     'Y'
     C     CLE025        ANDEQ     'N'                                                        CLE025
     C     CLE023        OREQ      'N'
     C     CLE025        ANDEQ     'N'                                                        CLE025
     C     CAMD          SUB       PRAM_Fac      CAMD
     C                   ENDIF
      *
     C     CLE023        IFEQ      'Y'
     C     CLE025        ANDEQ     'N'                                                        CLE025
     C     CEXP          SUB       WrkPRAMS      CEXP
     C                   ENDIF

      ***  If CLE009 is installed, set Work Regeneration Indicator to 'C'hanged

     C     CLE009        IFEQ      'Y'
     C                   MOVE      'C'           WKSWRI            1
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     WWACTN        IFEQ      'R'
     C     WrkPart       ANDEQ     'Y'
     C     WWACTN        OREQ      'I'
     C     WrkPart       ANDEQ     'N'
     C     RCSI          ANDNE     'Y'
     C     LPFI          ANDNE     'I'
      *
     C     WrkPart       IFEQ      'Y'
     C     CLE023        ANDEQ     'Y'
     C     CLE025        ANDEQ     'N'                                                        CLE025
     C     CLE023        OREQ      'N'
     C     CLE025        ANDEQ     'N'                                                        CLE025
     C     CAMD          ADD       PRAM_Fac      CAMD
     C                   ENDIF
      *
     C     CLE023        IFEQ      'Y'
     C     CLE025        ANDEQ     'N'                                                        CLE025
     C     CEXP          ADD       WrkPRAMS      CEXP
     C                   ENDIF

      ***  If CLE009 is installed, set Work Regeneration Indicator to 'C'hanged

     C     CLE009        IFEQ      'Y'
     C                   MOVE      'C'           WKSWRI            1
     C                   ENDIF
      *
     C                   ENDIF

      ***  normal, non-syndicated loans

     C                   ELSE
      *
     C     *IN52         IFEQ      '0'
     C     WWACTN        ANDEQ     'I'
     C     *IN52         OREQ      '1'
     C     WWACTN        ANDEQ     'R'
     C     RCSI          ANDNE     'Y'
      *
     C     *IN52         IFEQ      '0'
     C     CLE023        ANDEQ     'Y'
     C     CLE025        ANDEQ     'N'                                                        CLE025
     C     CLE023        OREQ      'N'
     C     CLE025        ANDEQ     'N'                                                        CLE025
     C     CAMD          SUB       PRAM_Fac      CAMD
     C                   ENDIF
      *
     C     CLE023        IFEQ      'Y'
     C     CLE025        ANDEQ     'N'                                                        CLE025
     C     CEXP          SUB       WrkPRAMS      CEXP
     C                   ENDIF

      ***  If CLE009 is installed, set Work Regeneration Indicator to 'C'hanged

     C     CLE009        IFEQ      'Y'
     C                   MOVE      'C'           WKSWRI            1
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     *IN52         IFEQ      '0'
     C     WWACTN        ANDEQ     'R'
     C     *IN52         OREQ      '1'
     C     WWACTN        ANDEQ     'I'
     C     RCSI          ANDNE     'Y'
      *
     C     *IN52         IFEQ      '0'
     C     CLE023        ANDEQ     'Y'
     C     CLE025        ANDEQ     'N'                                                        CLE025
     C     CLE023        OREQ      'N'
     C     CLE025        ANDEQ     'N'                                                        CLE025
     C     CAMD          ADD       PRAM_Fac      CAMD
     C                   ENDIF
      *
     C     CLE023        IFEQ      'Y'
     C     CLE025        ANDEQ     'N'                                                        CLE025
     C     CEXP          ADD       WrkPRAMS      CEXP
     C                   ENDIF

      ***  If CLE009 is installed, set Work Regeneration Indicator to
      ***  changed

     C     CLE009        IFEQ      'Y'
     C                   MOVE      'C'           WKSWRI            1
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRCIBC   - Sub-routine to see if a customer is also a branch  *
      *            internal customer.                                 *
      * Called by: SRFCLT                                             *
      * Calls    : None                                               *
      *****************************************************************
     C     SRCIBC        BEGSR
      *
     C                   MOVE      '0'           *IN43
      *
     C**********         MOVEL     MRCNUM        ICUSTN            6 0                        CSD027
     C                   MOVEL     MRCNUM        ICUSTN            6                          CSD027
      *
     C                   Z-ADD     1             W
     C     ICUSTN        LOOKUP    @BIC(W)                                43
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * QFCLTY   - Sub-routine to update availability array - FCLTY   *
      * Called by: SRFCLT                                             *
      * Calls    : None                                               *
      *****************************************************************
     C     QFCLTY        BEGSR
      *
     C     DAYNO         IFEQ      0
     C                   GOTO      ENDFCT
     C                   ENDIF
      *
     C                   Z-ADD     1             X                 2 0
     C     ENDAY         LOOKUP    RUNS(X)                            40  40
     C     *IN40         IFEQ      '0'
     C                   Z-ADD     99            X

      ***  with Manual Repayment on loans during I/C
      ***  the availability (i.e. undrawn amount) should be updated
      ***  to reflect the repayment.
      ***  RUNS,1 = The previous working day
      ***  ENDAY  = Maturity date of loan

     C                   ELSE
      *                                                                                       204708
      * If Loan is not autosettled, then the O/S principal of that loan                       204708
      * is included in all elements of the drawn amount array, even                           204708
      * beyond the maturity date of the loan. So this MR amount should                        204708
      * update all elements of the array if the loan is non-autosettled                       204708
      *                                                                .                      204708
     C     AUTOL         IFEQ      'N'                                                        204708
     C                   Z-ADD     99            X                                            204708
     C                   ENDIF                                                                204708
      *                                                                                       204708
     C     ENDAY         IFLE      RUNS(1)
     C                   Z-ADD     99            X
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     1             W                 3 0
     C     DAYNO         LOOKUP    RUNS(W)                            40  40
     C     *IN40         IFEQ      '0'
     C                   GOTO      ENDFCT
     C                   ENDIF
      *
     C     W             DOWLE     10
     C     W             ANDLT     X
      *
     C     *IN41         IFEQ      '1'
     C     CLE025        ANDEQ     'N'                                                        CLE025
     C     OAM(W)        SUB       FCBAL         OAM(W)
     C                   ENDIF
     C     *IN42         IFEQ      '1'
     C     CLE025        ANDEQ     'N'                                                        CLE025
     C     OAM(W)        ADD       FCBAL         OAM(W)
     C                   ENDIF

      ***  If CLE009 is installed, set Work Regeneration Indicator to
      ***  changed

     C     CLE009        IFEQ      'Y'
     C                   MOVE      'C'           WKSWRI            1
     C                   ENDIF
      *
     C     W             ADD       1             W
     C                   ENDDO
      *
     C     ENDFCT        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRINRE   - Set up details for output of RE record             *
      * Called by: SRLOAM                                             *
      * Calls    : SRSTAT                                             *
      *****************************************************************
     C     SRINRE        BEGSR
      *
     C                   MOVE      'D'           RECI
     C                   MOVE      MRLNRF        LNRF
     C                   Z-ADD     MRXAVD        VDAT
     C*******************Z-ADD     MRXASQ        LASN                                        BUG4325
     C                   Z-ADD     XLASN         LASN                                        BUG4325
     C                   MOVE      '2'           MRIN
     C                   Z-ADD     PTYPL         PTYP
     C                   MOVE      'RE'          AMTP
     C                   Z-ADD     0             INTA
     C                   Z-ADD     0             RTSP                                       MD029048
     C                   Z-ADD     0             PRSQ
     C                   Z-ADD     0             BRTT
     C                   Z-ADD     0             FEAM
     C                   MOVE      CCYL          CCY
     C                   MOVE      BRCA          BRCA
     C                   MOVE      CNUML         CNUM
     C                   MOVE      REPTL         REPT
     C**********         MOVE      'N'           AUTO                                       MD020445
     C                   MOVE      AUTOL         AUTO                                       MD020445
     C**********         MOVE      *ZERO         SETP                                       MD029048
     C**********         MOVE      *BLANKS       OSAC                                       MD029048
      *                                                                                     MD029048
     C                   EVAL      CVMR       = ReadCLCvmr                                  MD029048
     C                   EVAL      ICCY       = ReadCLIccy                                  MD029048
     C                   Move      *blanks       WTSEN            10                        MD029048
      *                                                                                     MD029048
     C                   If        (ReadCLPtyp = 66 OR                                      MD029048
     C                             ReadCLPtyp = 67 OR                                       MD029048
     C                             ReadCLPtyp = 69 OR                                       MD029048
     C                             ReadCLPtyp = 72)                                         MD029048
      *                                                                                     MD029048
      ** Clear RECEIPT side                                                                 MD029048
      *                                                                                     MD029048
     C                   Eval      DBRecSttmt = *Blanks                                     MD029048
     C                   Eval      RSTM       = 00                                          MD029048
      *                                                                                     MD029048
      ** Default PAY Side                                                                   MD029048
      *                                                                                     MD029048
     C                   EVAL      PSTM       = ReadCLPstm                                  MD029048
     C                   Eval      PONS       = ReadCLPons                                  MD029048
     C                   Eval      DBPaySttmt = ReadCLPaySttm                               MD029048
     C                   Eval      SETP       = ReadCLPstm                                  MD029048
     C                   Eval      OSAC       = ReadCLPons                                  MD029048
     C                   Eval      WTSEN      = ReadCLPibn                                  MD029048
     C                   MoveL     WTSEN         TSEN                                       MD029048
      *                                                                                     MD029048
     C                   Else                                                               MD029048
      *                                                                                     MD029048
      ** Clear PAY side                                                                     MD029048
      *                                                                                     MD029048
     C                   Eval      DBPaySttmt = *Blanks                                     MD029048
     C                   Eval      PSTM       = 00                                          MD029048
      *                                                                                     MD029048
      ** Default RECEIPT side                                                               MD029048
      *                                                                                     MD029048
     C                   Eval      RSTM       = ReadCLRstm                                  MD029048
     C                   Eval      RONS       = ReadCLRons                                  MD029048
     C                   Eval      DBRecSttmt = ReadCLRecSttm                               MD029048
     C                   Eval      SETP       = ReadCLRstm                                  MD029048
     C                   Eval      OSAC       = ReadCLRons                                  MD029048
     C                   Eval      WTSEN      = ReadCLRibn                                  MD029048
     c                   MoveL     WTSEN         TSEN                                       MD029048
     C                   Endif                                                              MD029048
      *                                                                                     MD029048
     C**********         MOVE      *BLANKS       TSEN                                       MD029048
     C**********         MOVE      *BLANKS       FACO                                       MD029048
     C                   Eval      FACO       = ReadCLFaco                                  MD029048
     C                   MOVE      *ZERO         CALC
     C                   Z-ADD     0             BRTE
     C                   MOVE      WTINL         WTIN
     C                   MOVE      'A'           LLAG
     C                   MOVE      *ZERO         XAVD
     C**********         MOVE      *ZERO         RLON                                         CSD027
     C                   MOVE      *BLANKS       RLON                                         CSD027
     C                   MOVE      *ZERO         FECD
     C                   MOVE      BIT           PONI
     C*********          MOVE      OMDB          OSBR                                       MD029048
     C                   Eval      OSBR       = ReadCLOmdb                                  MD029048
     C                   Z-ADD     BJRDNB        ORED
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      'I'           CHTP
     C                   Z-ADD     P@NATN        TNLU
     C                   MOVE      'M'           MNSG
     C**********         MOVE      'N'           GASS                                         CLE106
     C                   MOVE      'P'           GASS                                         CLE106
     C                   MOVE      'N'           GPRT
     C                   MOVE      'N'           NRLI
     C**********         Z-ADD     0             ROLN                                         CLE148
     C                   MOVEL     *BLANKS       ROLN                                         CLE148
     C                   Z-ADD     0             ROSN
     C**********         Z-ADD     0             RORC                                         CSD027
     C                   EVAL      RORC = *BLANKS                                             CSD027
     C                   MOVE      *BLANK        ROBR
     C                   MOVE      *BLANK        PDGN
     C                   MOVE      *BLANK        GRIN
     C                   MOVE      *BLANK        RLCY
     C                   Z-ADD     0             PNAM
     C                   MOVEL     PsUSER        IUSR
     C                   MOVE      *BLANKS       AUSR
     C                   MOVE      *BLANKS       XUSR
      *
     C                   MOVE      MRPAST        PAST

      ***  Set status depending on ICD

     C**********         EXSR      SRSTAT                                                   MD029048
     C                   MOVE      'A'           ASTS                                       MD029048
      *
     C                   MOVE      *BLANKS       PCOBK
      *
     C     WWACTN        IFEQ      'I'
     C     CLE106        ANDNE     'Y'                                                        CLE106
     C     CLE134        ANDNE     'Y'                                                      MD020605
     C                   MOVE      BRCA          PBRCA
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PBRCA             3
     C     SDBRCH        PARM      SDBRCH        DSSDY

     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVEL     'LEMAPYUPD'   DBPGM
     C                   MOVEL     'SDBRCHPD'    DBFILE                         ************
     C                   Z-ADD     25            DBASE                          * DBERR 25 *
     C                   MOVEL     BRCA          DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   IF        A8MQSM <> *BLANKS                                         CSF011A
     C                   MOVEL     A8MQSM        W#1ST3            3
     C                   ELSE                                                                CSF011A
     C                   MOVEL     BRCA          W#1ST3                                      CSF011A
     C                   ENDIF                                                               CSF011A
      *
     C******DTAARA       DEFINE                  LEALLO                                       CLE148
     C******LOCK         IN        LEALLO                                                     CLE148
     C*****PCLAST        ADD       1             PCNEXT            8 0                        CLE148
      *
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM      'Y'           PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
     C                   MOVE      PCNEXT        W1ST11           11
     C                   MOVEL     W#1ST3        W1ST11
     C                   MOVEL     W1ST11        PCRFK
     C                   MOVE      '0001'        PCRFK
     C**********         Z-ADD     PCNEXT        PCLAST                                       CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C                   ENDIF
     C                   ENDIF

     C                   IF        CLE106 = 'Y' AND MR_PTRF <> *BLANKS                       CSF011A
     C                             OR @@MODE = '*FRONT'                                      CSF011A
     C                   EVAL      PCRFK  = MR_PTRF                                          CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
      ***  System generated

     C     CEU004        IFEQ      'Y'
     C                   MOVE      CL_SCCY       SCCYK
     C                   MOVE      CL_ICCY       ICCY
     C                   ENDIF
      *
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   MOVE      CL_SCCY       SCCYK                                      AR943686
     C                   Z-ADD     CL_REXR       REXRK                                        CLE031
     C                   MOVE      CL_REXI       REXIK                                        CLE031
     C                   MOVE      CL_PSCY       PSCYK                                        CLE031
     C                   Z-ADD     CL_PEXR       PEXRK                                        CLE031
     C                   MOVE      CL_PEXI       PEXIK                                        CLE031
     C                   ENDIF                                                                CLE031
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUPRE   - Set up details for updated of Related RE/PD record *
      * Called by: SRLOAM                                             *
      * Calls    : SRSTAT                                             *
      *****************************************************************
     C     SRUPRE        BEGSR
      *
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      'A'           CHTP
     C                   Z-ADD     P@NATN        TNLU
      *
     C                   SELECT
     C     WWACTN        WHENEQ    'A'
     C                   MOVE      PsUser        AUSR
     C                   ADD       1             XASQ
     C     WWACTN        WHENEQ    'X'
     C                   MOVE      PsUser        XUSR
     C                   ADD       1             XASQ
     C     WWACTN        WHENEQ    'R'
     C     XASQ          IFGT      0                                                        BUG23213
     C**********         SUB       1             XASQ                                       BUG23213
     C     XASQ          SUB       1             XASQ                                       BUG23213
     C                   ENDIF                                                              BUG23213
     C     PAST          IFEQ      'Y'
     C     AMTP          ANDNE     'PD'
     C                   MOVE      'R'           RECI
     C                   ENDIF
     C                   ENDSL
      *
     C     AMTP          IFEQ      'RE'
     C                   EXSR      SRSTAT
     C                   ENDIF

      ***   Setting of 'manual/system generated' flag.

     C     WWACTN        IFNE      'X'
     C                   MOVE      'M'           MNSG
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRINMR   - Set up details for output of MR/PD record          *
      * Called by: SRLOAM                                             *
      * Calls    : SRSTAT                                             *
      *****************************************************************
     C     SRINMR        BEGSR
      *
     C                   BITOFF    '01234567'    BIT
     C                   Z-ADD     SLASN         MRLASN
     C                   MOVE      WTYP          MRSETP
     C                   MOVE      WOURS         MROSAC
     C                   MOVE      WTHRS         MRTSEN
     C                   MOVE      BIT           MRLAIN
     C                   MOVE      BIT           MRPONI
     C                   Z-ADD     XLASN         MRXASQ
     C                   Z-ADD     P@NATN        MRTNLU
     C                   MOVE      PsUser        MRIUSR
     C     MRXASQ        IFEQ      0                                                        AR927395
     C                   Z-ADD     0             MRCOFA                                     AR927395
     C                   ELSE                                                               AR927395
     C                   Z-ADD     COFAR         MRCOFA                                     AR927395
     C                   ENDIF                                                              AR927395
      *
      ***  Set status depending on ICD
      *
     C                   Eval      AMTP = 'MR'                                   used by SRSTAT
     C                   Eval      MRASTS = 'A'
     C                   EXSR      SRSTAT

      ***  New Settlement details are already filled (In SIN or RPR, CALLB ZASETINSIN)
      ***                                            (IN CTL, CALLB ZASETINDFT)

     C     WWACTN        IFEQ      'I'
     C     CLE106        ANDNE     'Y'                                                        CLE106
     C     CLE134        ANDNE     'Y'                                                      MD020605
     C                   MOVE      BRCA          PBRCA
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PBRCA             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVEL     'SDBRCHPD'    DBFILE                         ************
     C                   Z-ADD     26            DBASE                          * DBERR 26 *
     C                   MOVEL     BRCA          DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   Endif
      *
     C                   IF        A8MQSM <> *BLANKS                                         CSF011A
     C                   MOVEL     A8MQSM        W#1ST3            3
     C                   ELSE                                                                CSF011A
     C                   MOVEL     BRCA          W#1ST3                                      CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C******LOCK         IN        LEALLO                                                     CLE148
     C*****PCLAST        ADD       1             PCNEXT            8 0                        CLE148
      *                                                                                       CLE148
     C                   CALL      'LEALLO'                                                   CLE148
     C                   PARM      *BLANKS       PRTCD                                        CLE148
     C                   PARM      'Y'           PUPDT                                        CLE148
     C                   PARM      *BLANKS       PCLAST                                       CLE148
     C                   PARM      *BLANKS       PCNEXT                                       CLE148
      *                                                                                       CLE148
     C                   MOVE      PCNEXT        W1ST11           11
     C                   MOVEL     W#1ST3        W1ST11
     C                   MOVEL     W1ST11        MRPCRF
     C                   MOVE      '0001'        MRPCRF
     C**********         Z-ADD     PCNEXT        PCLAST                                       CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C                   ENDIF

      *** if Expected Payment was a Past due

     C     PD_AMTP       IFEQ      'PD'
     C                   MOVE      'Y'           MRMTPD
     C                   ELSE
     C                   MOVE      'N'           MRMTPD
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUPMR   - Set up details for update of MR record             *
      * Called by: SRLOAM                                             *
      * Calls    : SRSTAT                                             *
      *****************************************************************
     C     SRUPMR        BEGSR
      *
     C                   MOVE      WTYP          MRSETP                         Update settl. dtls
     C                   MOVE      WOURS         MROSAC
     C                   MOVE      WTHRS         MRTSEN
     C                   Z-ADD     BJRDNB        MRLCD
     C                   Z-ADD     P@NATN        MRTNLU
     C     WWACTN        IFEQ      'A'
     C                   MOVEL     PsUser        MRAUSR
     C                   ELSE
     C                   MOVEL     PsUser        MRXUSR
     C                   ENDIF
      *
     C     WWACTN        IFEQ      'R'
     C                   MOVE      'R'           MRRECI
     C                   ENDIF

      ***  Set status depending on ICD

     C                   EXSR      SRSTAT

      ***   Setting of 'manual/system generated' flag.

     C     WWACTN        IFNE      'X'
     C                   MOVE      'M'           MRMNSG
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSTAT   - Set up status of amendment                         *
      * Called by: SRUPRE, SRINRE, SRUPMR, SRINMR                     *
      * Calls    : None                                               *
      *****************************************************************
     C     SRSTAT        BEGSR
      *
     C     CLE002        IFEQ      'Y'
      *
     C     BPMRAU        IFEQ      'Y'                                          Authorise MR
     C     AMTP          ANDEQ     'MR'
     C     BPREAU        OREQ      'Y'                                          Authorise RE
     C     AMTP          ANDEQ     'RE'
      *
     C                   SELECT
     C     WWACTN        WHENEQ    'I'
     C                   MOVE      'C'           MRASTS                         Completed
     C     WWACTN        WHENEQ    'A'
     C     ASTS          IFEQ      'A'
     C     ASTS          OREQ      'R'
     C                   MOVE      'R'           MRASTS                         Reauthorised
     C                   ELSE
     C                   MOVE      'C'           MRASTS                         Completed
     C                   ENDIF
     C     WWACTN        WHENEQ    'X'                                          Authorise
     C                   MOVE      'A'           MRASTS                         Authorised
     C                   ENDSL
                                                                                              CAP086
     C                   IF        MRAUTH = 'Y'                                               CAP086
     C                   EVAL      MRASTS = 'A'                                               CAP086
     C                   ENDIF                                                                CAP086
      *
     C                   ENDIF
     C                   ENDIF
      *
     C     CLE002        IFEQ      'N'
     C     BPMRAU        OREQ      'N'                                          authorise MR ?
     C     AMTP          ANDEQ     'MR'
     C     BPREAU        OREQ      'N'                                          authorise RE ?
     C     AMTP          ANDEQ     'RE'
     C                   MOVE      'A'           MRASTS                         Authorised
                                                                                              CAP086
     C                   IF        MRAUTH = 'Y'                                               CAP086
     C                   EVAL      MRASTS = 'A'                                               CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSLOC   - Get location                                       *
      * Called by: SRLOAN                                             *
      * Calls    : None                                               *
      *****************************************************************
     C     SRSLOC        BEGSR

      ***  Initialise working variable - settlement branch location

     C                   MOVE      *BLANKS       W@STLL            3

      ***  For type 01,02,07,08 or 12, settlement location is determined
      ***  by the nostro branch

     C     W@SETP        IFEQ      '01'
     C     W@SETP        OREQ      '02'
     C     W@SETP        OREQ      '07'
     C     W@SETP        OREQ      '08'
     C     W@SETP        OREQ      '12'
      *
     C                   CALLB     'AONOSTR0'
     C                   PARM      '*BLANKS'     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @KEYA             6
     C                   PARM      W@CCY         @KEYB             3
     C**********         PARM      *BLANKS       @KEYC             4                          CGL029
     C                   PARM      *BLANKS       @KEYC                                        CGL029
     C                   PARM      *BLANKS       @KEYD             2
     C                   PARM      W@SNOS        @KEYE             2
     C                   PARM      *BLANKS       @KEYF             3
     C                   PARM      *BLANKS       @KEYG            10
     C                   PARM      *BLANKS       @KEYH             1
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      A7NOSN        W@STLL
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVEL     'LEMAPYUPD'   DBPGM
     C                   Z-ADD     27            DBASE                          ************
     C                   MOVEL     'SDNOSTPD'    DBFILE                         * DBERR 27 *
     C                   MOVEL     W@CCY         DBKEY                          ************
     C                   MOVE      W@SNOS        DBKEY
     C                   OUT       LDA
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     SETRTN        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRNSEQ   -  Get next available sequence number                *
      * Called by: SRLOAM                                             *
      * Calls    : None                                               *
      *****************************************************************
     C     SRNSEQ        BEGSR
      *
     C                   Z-ADD     0             SLASN

      ***  Get next available sequence, for loan at Date

     C     KLMKEY        SETLL     LOAMD
     C                   READ      LOAMD                                  50
     C     *IN50         DOWEQ     *OFF
     C     LNRFA         IFNE      MRLNRF
     C     VDATA         ORNE      MRVDAT
     C                   MOVE      *BLANKS       RECIA
     C                   MOVE      *BLANKS       CurrPD_LTYP
     C                   MOVE      *BLANKS       CurrPD_SUTP
     C                   MOVE      *BLANKS       AMTPA
     C                   MOVE      *BLANKS       AUTOA
     C                   MOVE      *BLANKS       OSACA
     C                   MOVE      *BLANKS       TSENA
     C                   MOVE      *BLANKS       FACOA
     C**********         Z-ADD     *ZEROS        LNRFA                                        CLE148
     C                   MOVEL     *BLANKS       LNRFA                                        CLE148
     C                   Z-ADD     *ZEROS        VDATA
     C                   Z-ADD     *ZEROS        LASNA
     C                   Z-ADD     *ZEROS        PTYPA
     C                   Z-ADD     *ZEROS        CurrPD_INTA
     C                   Z-ADD     *ZEROS        PRAMA
     C                   Z-ADD     *ZEROS        CurrPD_TAMT
     C                   Z-ADD     *ZEROS        CurrPD_WTXA
     C                   Z-ADD     *ZEROS        CurrPD_PNAM
     C                   Z-ADD     *ZEROS        SETPA
     C                   LEAVE
     C                   ENDIF
     C                   Z-ADD     LASNA         SLASN
     C                   READ      LOAMD                                  50
     C                   ENDDO
      *
     C                   ADD       1             SLASN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRLTRX  -  Update Loan Transaction Index Detail (LTRIX)       *
      * Called by:                                                    *
      * Calls    : None                                               *
      *****************************************************************
     C     SRLTRX        BEGSR
      *
     C     WWACTN        IFEQ      'X'                                          Authorise when to do
     C     BPMRAU        ANDEQ     'Y'
     C     CLE002        ANDEQ     'Y'
      *
     C     WWACTN        OREQ      'I'                                          Insert when Authoris
     C     BPMRAU        ANDNE     'Y'                                          MR is not required
      *
     C     WWACTN        OREQ      'R'                                          Reverse when MR
     C     BPMRAU        ANDEQ     'Y'                                          must be authorised
     C     CLE002        ANDEQ     'Y'                                          and Already authoris
     C     XUSR          ANDNE     *BLANK
      *
     C     WWACTN        OREQ      'R'                                          Reverse when no
     C     BPMRAU        ANDNE     'Y'                                          MR authorisation req
      *
     C     WWACTN        OREQ      'A'                                          or Amend when no
     C     BPMRAU        ANDNE     'Y'                                          MR authorisation req
      *
     C**********         MOVE      *IN17         IN17              1                        AR322732
     C**********         MOVE      '1'           *IN17                                      AR322732
     C**********         MOVE      '0'           *IN79                                      AR322732
      *
     C******IN17         DOUEQ     '0'                                                      AR322732
     C*****RECI*         ANDEQ     *BLANK                                                   AR322732
     C******IN79         OREQ      '1'                                                      AR322732
      *
     C**********         Z-ADD     1             LXRRN             5 0                      AR322732

      ***  Access LTRIX header

     C*****LXRRN         CHAIN(N)  LTRIX                              79                    AR322732
      *
     C******IN79         IFEQ      '0'                                                      AR322732
     C*****RECI*         IFEQ      'H'                                                      AR322732
     C*****RRNA*         IFGT      FLSZ                                                     AR322732
     C**********         MOVE      '1'           *INU8                                      AR322732
     C**********         ENDIF                                                              AR322732
     C**********         ELSE                                                               AR322732
     C**********         MOVE      *ON           *IN79                                      AR322732
     C**********         ENDIF                                                              AR322732
     C**********         ENDIF                                                              AR322732
      *
     C******IN79         IFEQ      *ON                                                      AR322732
     C******INU8         OREQ      *ON                                                      AR322732
     C******LOCK         IN        LDA                                                      AR322732
     C**********         EVAL      @@RTCD = '*RECUPD'                                       AR322732
     C**********         MOVEL     'LEMAPYUPD'   DBPGM                                      AR322732
     C**********         MOVEL     'LTRIX   '    DBFILE                         ************AR322732
     C**********         Z-ADD     28            DBASE                          * DBERR 28 *AR322732
     C**********         MOVEL     LXRRN         DBKEY                          ************AR322732
     C**********         OUT       LDA                                                      AR322732
     C**********         EXSR      *PSSR                                                    AR322732
     C**********         ENDIF                                                              AR322732
      *
     C**********         MOVE      RRNA          LXRRN                                      AR322732
      *
     C*****LXRRN         CHAIN     LTRIX                              7917                  AR322732
      *
     C******IN17         IFEQ      '1'                                                      AR322732
     C*****TXSTS         IFEQ      1218                                                     AR322732
     C**********         UNLOCK    LTRIX                                                    AR322732
     C**********         ELSE                                                               AR322732
     C**********         MOVE      '1'           *IN79                                      AR322732
     C**********         ENDIF                                                              AR322732
     C**********         ENDIF                                                              AR322732
      *
     C**********         ENDDO                                                              AR322732
     C**********         MOVE      IN17          *IN17                                      AR322732
      *
     C******IN79         IFEQ      '1'                                                      AR322732
     C******LOCK         IN        LDA                                                      AR322732
     C**********         EVAL      @@RTCD = '*RECUPD'                                       AR322732
     C**********         MOVEL     'LEMAPYUPD'   DBPGM                                      AR322732
     C**********         MOVEL     'LTRIX   '    DBFILE                         ************AR322732
     C**********         Z-ADD     29            DBASE                          * DBERR 29 *AR322732
     C**********         MOVEL     LXRRN         DBKEY                          ************AR322732
     C**********         OUT       LDA                                                      AR322732
     C**********         EXSR      *PSSR                                                    AR322732
     C**********         ENDIF                                                              AR322732
      *
     C                   Z-ADD     0             PRI1

      ***  Check settlement type

     C     SETP          IFEQ      01
     C     SETP          OREQ      02
     C     SETP          OREQ      07
     C     SETP          OREQ      08
     C     SETP          OREQ      12

      ***  Obtain lowest telex notice days between loan & local CCY

     C                   CALLB     'AOCURRR0'
     C                   PARM      '*BLANK  '    PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM      CL_CCY        PCURR
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVEL     'LEMAPYUPD'   DBPGM
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   Z-ADD     30            DBASE                          * DBERR 30 *
     C                   MOVEL     CL_CCY        DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ***  Default to local CCY for telex notice calculation

     C                   Z-ADD     A6TXND        ZNRDYS
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   MOVE      BJLCCY        ZCCY

      ***  For settlement types 01, 07, & 08 use loan currency instead

     C     SETP          IFEQ      01
     C     SETP          OREQ      07
     C     SETP          OREQ      08
     C                   Z-ADD     A6TXND        ZNRDYS
     C                   MOVE      CL_CCY        ZCCY
     C                   ENDIF
      *
     C                   CallB     'ZFWDT'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZNRDYS            2 0
     C                   PARM                    ZDYNBR            5 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
      *
     C     MRVDAT        IFLE      ZDYNBR
     C     MRVDAT        IFGE      BJRDNB
     C                   Z-ADD     1             PRI1
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF

      ***  Update LTRIX detail record

     C                   Z-ADD     0             RRNA              5 0                      AR322732
     C                   EXCEPT    LTRIXD

      ***  Get header record

     C**********         Z-ADD     1             LXRRN                                      AR322732
     C*****LXRRN         CHAIN     LTRIX                              79                    AR322732
      *
     C******IN79         IFEQ      '1'                                                      AR322732
     C******LOCK         IN        LDA                                                      AR322732
     C**********         EVAL      @@RTCD = '*RECUPD'                                       AR322732
     C**********         MOVEL     'LEMAPYUPD'   DBPGM                                      AR322732
     C**********         MOVEL     'LTRIX   '    DBFILE                         ************AR322732
     C**********         Z-ADD     31            DBASE                          * DBERR 31 *AR322732
     C**********         MOVEL     LXRRN         DBKEY                          ************AR322732
     C**********         OUT       LDA                                                      AR322732
     C**********         EXSR      *PSSR                                                    AR322732
     C**********         ENDIF                                                              AR322732

      ***  Update relevant control fields

     C*****NORE*         ADD       1             NORE                                       AR322732
     C*****RRNA*         ADD       1             RRNA                                       AR322732
     C*****NLAR*         ADD       1             NLAR                                       AR322732
      *
     C**********         EXCEPT    LTRIXH                                                   AR322732
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRTRAL  -  Update Loan Amendments Trailer File                *
      * Called by: SRWRIT, SRUPDT                                     *
      * Calls    : GLZADD, GLZSUB                                     *
      *****************************************************************
     C     SRTRAL        BEGSR
      *
      ***  Update Loan Amendments Trailer, No action for amendments
      *
     C     WWACTN        IFEQ      'I'
     C     WWACTN        OREQ      'R'
      *
     C                   MOVE      '999999'      WLNRF
     C                   MOVE      '99999'       WVALD
     C                   MOVE      '999'         SLASN

      ***  Store values before updating loan amendments trailer

     C     *LIKE         DEFINE    VDAT          W#VDAT
     C     *LIKE         DEFINE    LNRF          W#LNRF
     C                   Z-ADD     VDAT          W#VDAT
     C**********         Z-ADD     LNRF          W#LNRF                                       CLE148
     C                   MOVEL     LNRF          W#LNRF                                       CLE148
      *
     C                   IF        MTHREAD = 'N'                                            MD024342
     C     KLMKEY        CHAIN     LOAMS                              59        Trailer
      *
     C     *IN59         IFEQ      '1'
     C     *LOCK         IN        LDA
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVEL     'LEMAPYUPD'   DBPGM
     C                   MOVEL     'LOAMS   '    DBFILE                         ************
     C                   Z-ADD     32            DBASE                          * DBERR 32 *
     C                   MOVEL     '999999'      DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   GOTO      ENTRAL
     C                   ENDIF
     C                   ELSE                                                               MD024342
     C                   EXSR      Initialise                                               MD024342
     C                   ENDIF                                                              MD024342

      ***  Action is insert

     C     WWACTN        IFEQ      'I'
     C     NORE          ADD       1             NORE
     C     NINS          ADD       1             NINS
     C     NLRA          ADD       1             NLRA
     C                   Z-ADD     VRIF          ZZTOTI
     C                   Z-ADD     VRIL          ZZTOTD
     C                   ENDIF

      ***  Action is reverse

     C     WWACTN        IFEQ      'R'
     C     NDEL          ADD       1             NDEL
     C     NLRA          SUB       1             NLRA
     C                   Z-ADD     VRDF          ZZTOTI
     C                   Z-ADD     VRDL          ZZTOTD
     C                   ENDIF

      ***  If matched against CLOAN add for extra 'RE' record

     C     DDESEQ        IFEQ      'LN '
     C     NORE          ADD       1             NORE
     C     NINS          ADD       1             NINS
     C     NLRA          ADD       1             NLRA
     C                   ENDIF

      ***  Update amount fields

     C     TAMTR         DIV       1000          ZZAMT                  40
     C     *IN40         IFEQ      '1'                                          Negative Amount
     C                   Z-SUB     ZZAMT         ZZAMT                          Reverse Sign
     C                   ENDIF
     C                   EXSR      GLZADD

      ***  Action is insert

     C     WWACTN        IFEQ      'I'
     C                   Z-ADD     ZZTOTI        VRIF
     C                   Z-ADD     ZZTOTD        VRIL
     C                   ENDIF

      ***  Action is reverse

     C     WWACTN        IFEQ      'R'
     C                   Z-ADD     ZZTOTI        VRDF
     C                   Z-ADD     ZZTOTD        VRDL
     C                   ENDIF

      ***  If matched against CLOAN add for extra 'RE' record

     C     DDESEQ        IFEQ      'LN '
     C     TAMTS         DIV       1000          ZZAMT                  40
     C     *IN40         IFEQ      '1'                                          Negative amount
     C                   Z-SUB     ZZAMT         ZZAMT                           reverse sign
     C                   ENDIF
     C                   Z-ADD     VRIF          ZZTOTI
     C                   Z-ADD     VRIL          ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        VRIF
     C                   Z-ADD     ZZTOTD        VRIL
     C                   ENDIF
      *
     C                   Z-ADD     0             WAMNT            13 0  40
      *
     C     WAMTP         IFEQ      'PD'
     C     WWACTN        IFEQ      'R'
     C                   Z-ADD     TAMTR         WAMNT
     C                   ENDIF
     C*****WWACTN        IFEQ      'I'                                                        264014
     C**********         Z-SUB     TAMTR         WAMNT                                        264014
     C**********         ENDIF                                                                264014
     C                   ENDIF

      ***  Also get absolute value of amount when linked to a past due.

     C     WAMTP         IFEQ      'PD'
     C     WWACTN        ANDEQ     'R'
     C     WAMNT         ANDLT     0
     C                   Z-SUB     WAMNT         WAMNT
     C                   ENDIF

      ***  Get absolute value of amount first before negating it.  This is
      ***  to accomodate negative manual repayments linked to a past due.

     C     WAMTP         IFEQ      'PD'
     C     WWACTN        ANDEQ     'I'
     C                   Z-ADD     TAMTR         WAMNT
     C     WAMNT         IFGE      0
     C                   Z-SUB     WAMNT         WAMNT
     C                   ENDIF
     C                   ENDIF

      ***  For match against 'RE' value of amend is absolute
      ***  value of TAMT of 'RE' after amend minus absolute value
      ***  of TAMT of 'RE' before amend

     C     WAMTP         IFEQ      'RE'
     C     REPTL         ANDNE     1
     C                   Z-ADD     OTAMT         WRK13                  40
     C     *IN40         IFEQ      '1'                                           negative
     C                   Z-SUB     WRK13         WRK13                            reverse sign
     C**********         ELSE                                                                 264014
     C                   ENDIF                                                                264014
      *                                                                                       264014
     C                   Z-ADD     TAMTS         WAMNT                  40
     C**********         ENDIF                                                                264014
     C     *IN40         IFEQ      '1'
     C                   Z-SUB     WAMNT         WAMNT
     C**********         ELSE                                                                 264014
     C                   ENDIF                                                                264014
      *                                                                                       264014
     C     WAMNT         SUB       WRK13         WAMNT
     C**********         ENDIF                                                                264014
     C                   ENDIF
      *
     C                   MOVE      WAMNT         ZZAMT
     C                   Z-ADD     VRAF          ZZTOTI
     C                   Z-ADD     VRAL          ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        VRAF
     C                   Z-ADD     ZZTOTD        VRAL
      *
     C**********         Z-ADD     TAMTR         ZZAMT                  40                 AR1002234
     C                   Z-ADD     TAMTR         WRK13                  40                 AR1002234
     C     *IN40         IFEQ      '1'
     C**********         Z-SUB     ZZAMT         ZZAMT                                     AR1002234
     C                   Z-SUB     WRK13         WRK13                                     AR1002234
     C                   ENDIF
      *
     C     WWACTN        IFEQ      'I'
     C*****ZZAMT         ADD       WAMNT         WRK13                                     AR1002234
     C     WRK13         ADD       WAMNT         WRK13                                     AR1002234
     C                   ENDIF
      *
     C     WWACTN        IFEQ      'R'
     C*****ZZAMT         SUB       WAMNT         WRK13                                     AR1002234
     C     WRK13         SUB       WAMNT         WRK13                                     AR1002234
     C                   ENDIF
      *
     C     WRK13         DIV       1000          ZZAMT                  40
     C     *IN40         IFEQ      '1'
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
      *
     C                   Z-ADD     VRRF          ZZTOTI
     C                   Z-ADD     VRRL          ZZTOTD
      *
     C     WWACTN        IFEQ      'I'
     C                   EXSR      GLZADD
     C                   ENDIF
      *
     C     WWACTN        IFEQ      'R'
     C                   EXSR      GLZSUB
     C                   ENDIF
      *
     C                   Z-ADD     ZZTOTI        VRRF
     C                   Z-ADD     ZZTOTD        VRRL
      *
     C     DDESEQ        IFEQ      'LN '
     C     TAMTS         DIV       1000          ZZAMT                  40
     C     *IN40         IFEQ      '1'
     C                   Z-SUB     ZZAMT         ZZAMT
     C                   ENDIF
     C                   Z-ADD     VRRF          ZZTOTI
     C                   Z-ADD     VRRL          ZZTOTD
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        VRRF
     C                   Z-ADD     ZZTOTD        VRRL
     C                   ENDIF
      *
     C                   Z-ADD     BJRDNB        LCD
     C                   MOVE      'A'           CHTP
     C                   Z-ADD     P@NATN        TNLU
      *
     C                   IF        MTHREAD = 'N'                                            MD024342
     C                   UPDATE    LOAMSZ1F
     C                   ELSE                                                               MD024342
     C**********         WRITE     LOAMSZ1F                                       MD024342 MD024342B
     C**********         WRITE     LOAMSZ1FX                                      MD024342B MD025467
     C                   WRITE     LOAMSZ1F                                                 MD025467
     C                   ENDIF                                                              MD024342

      ** Update Loan Amendments Trailer File                                                MD020733
                                                                                            MD020733
     C                   IF        CLE134 = 'Y' and UpSRFlg = 'Y'                           MD020733
     C                             and WWACTN = 'I'                                         MD020733
     C     KLMKEY        CHAIN     LELOMKL3                                                 MD020733
     C                   IF        NOT %FOUND(LELOMKL3)                                     MD020733
                                                                                            MD020733
      ** If LELOMKL3 trailer file is empty, set it up using the LOAMSZ1 file                MD020733
      ** plus the defaults                                                                  MD020733
                                                                                            MD020733
     C     KLMKEY        CHAIN     LOAMS                                                    MD020733
     C                   IF        %FOUND(LOAMS)                                            MD020733
     C                   Z-ADD     1             NORE                                       MD020733
     C                   Z-ADD     0             NLRB                                       MD020733
     C                   Z-ADD     1             NINS                                       MD020733
     C                   Z-ADD     0             NDEL                                       MD020733
     C                   Z-ADD     1             NLRA                                       MD020733
     C                   Z-ADD     0             VLBF                                       MD020733
     C                   Z-ADD     0             VLBL                                       MD020733
     C                   Z-ADD     0             VRIF                                       MD020733
     C                   Z-ADD     0             VRIL                                       MD020733
     C                   Z-ADD     0             VRDF                                       MD020733
     C                   Z-ADD     0             VRDL                                       MD020733
     C                   Z-ADD     0             VRAF                                       MD020733
     C                   Z-ADD     0             VRAL                                       MD020733
     C                   Z-ADD     0             VRRF                                       MD020733
     C                   Z-ADD     0             VRRL                                       MD020733
     C                   ENDIF                                                              MD020733
     C                   ELSE                                                               MD020733
     C     NORE          ADD       1             NORE                                       MD020733
     C     NINS          ADD       1             NINS                                       MD020733
     C     NLRA          ADD       1             NLRA                                       MD020733
     C                   ENDIF                                                              MD020733
                                                                                            MD020733
     C     TAMT          DIV       1000          ZZAMT                                      MD020733
     C     ZZAMT         IFLT      0                                                        MD020733
     C                   Z-SUB     ZZAMT         ZZAMT                                      MD020733
     C                   ENDIF                                                              MD020733
                                                                                            MD020733
     C                   Z-ADD     VRIF          ZZTOTI                                     MD020733
     C                   Z-ADD     VRIL          ZZTOTD                                     MD020733
     C                   EXSR      GLZADD                                                   MD020733
     C                   Z-ADD     ZZTOTI        VRIF                                       MD020733
     C                   Z-ADD     ZZTOTD        VRIL                                       MD020733
                                                                                            MD020733
     C                   Z-ADD     VRRF          ZZTOTI                                     MD020733
     C                   Z-ADD     VRRL          ZZTOTD                                     MD020733
     C                   EXSR      GLZADD                                                   MD020733
     C                   Z-ADD     ZZTOTI        VRRF                                       MD020733
     C                   Z-ADD     ZZTOTD        VRRL                                       MD020733
                                                                                            MD020733
     C                   Z-ADD     BJRDNB        LCD                                        MD020733
     C                   MOVE      'A'           CHTP                                       MD020733
     C                   Z-ADD     P@NATN        TNLU                                       MD020733
                                                                                            MD020733
     C                   IF        %FOUND(LELOMKL3)                                         MD020733
     C                   UPDATE    LOMKSZ1F                                                 MD020733
     C                   ELSE                                                               MD020733
     C                   WRITE     LOMKSZ1F                                                 MD020733
     C                   ENDIF                                                              MD020733
     C                   ENDIF                                                              MD020733
                                                                                            MD020733
      ***  Restore values after updating loan amendments trailer

     C                   MOVE      W#VDAT        VDAT
     C                   MOVE      W#LNRF        LNRF
      *
     C                   ENDIF
      *
     C     ENTRAL        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSHAD   - Set up details for shadow post                     *
      * Called by: SRWRIT, SRUPDT                                     *
      * Calls    : None                                               *
      *****************************************************************
     C     SRSHAD        BEGSR
      *
     C                   MOVE      RECI          SHRECI
     C                   MOVE      LNRF          SHLNRF
     C                   Z-ADD     VDAT          SHVDAT
     C***********        IF        CRE020 = 'Y'                                       CRE020 BUG8956
     C                   Z-ADD     MRLASN        SHLASN                                       CRE020
     C***********        ELSE                                                         CRE020 BUG8956
     C***********        Z-ADD     LASN          SHLASN                                      BUG8956
     C***********        ENDIF                                                        CRE020 BUG8956
     C                   MOVE      PTYPL         SHPTYP
     C                   MOVE      AMTP          SHAMTP
     C                   MOVE      CCY           SHCCY
     C                   Z-ADD     PRAM          SHPRAM
     C                   Z-ADD     TAMT          SHTAMT
     C                   MOVE      BRCA          SHBRCA
     C                   Z-ADD     0             SHREPT
     C                   MOVE      SHSETT        SHTIST
      *
     C                   MOVE      OSBR          SHOSBR
      *
     C     WWACTN        IFNE      'R'
     C                   MOVE      CHTP          SHCHTP
     C                   ELSE
     C                   MOVE      'R'           SHCHTP
     C                   ENDIF
      *
     C                   MOVE      PNAM          SHPNAM
      *
     C     CEU004        IFEQ      'Y'
     C                   MOVE      SCCYK         SHSCCY
     C                   MOVE      ICCY          SHICCY
     C                   ENDIF
      *
     C*****CLE031        IFEQ      'Y'                                              CLE031  MD051892
     C**********         MOVE      SCCYK         SHSCCY                            AR943686 MD051892
     C**********         Z-ADD     REXRK         SHREXR                              CLE031 MD051892
     C**********         MOVE      REXIK         SHREXI                              CLE031 MD051892
     C**********         MOVE      PSCYK         SHPSCY                              CLE031 MD051892
     C**********         Z-ADD     PEXRK         SHPEXR                              CLE031 MD051892
     C**********         MOVE      PEXIK         SHPEXI                              CLE031 MD051892
     C**********         ENDIF                                                       CLE031 MD051892
      *                                                                                      BUG9225
     C                   MOVE      STAL          SHSTAL                                      BUG9225
      *
     C                   MOVE      XRFIL         SHXRFI                                       CLE134
     C                   MOVE      XRFNL         SHXRFN                                       CLE134
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUSHD  -  Shadow posting update                              *
      * Called by: SRWRIT, SRUPDT                                     *
      * Calls    : AOOULAU0                                           *
      * Calls    : AOOULEU0                                           *                      BUG4513
      *                                                               *
      *****************************************************************
      *
     C     SRUSHD        BEGSR
      *                                                                                     MD023787
      ** Verify if its a MR for PDCL and get loan records.                                  MD023787
      *                                                                                     MD023787
     C                   MOVE      *BLANKS       PDCLI             1                        MD023787
     C                   MOVE      *BLANKS       PDRST             1                        MD023787
     C                   EVAL      WPDCLNoPost = ' '                                        MD040186
     C                   IF        CobMode <> 'Y'  and                                      MD023787
     C                             (%SUBST(MRLTYP:1:1) = 'X' or                             MD023787
     C                              %SUBST(MRLTYP:1:1) =  'Y' or                            MD023787
     C                              %SUBST(MRLTYP:1:1) =  'Z')                              MD023787
     C                   MOVE      MRLNRF        WKLNR                                      MD023787
     C                   MOVE      'A'           WKRCD                                      MD023787
     C     KLOAN         CHAIN     CLOAN                              99                    MD023787
     C     AUTOL         IFEQ      'C'                                                      MD023787
     C     *IN99         ANDEQ     '0'                                                      MD023787
      *                                                                                     MD023787
      ** If the Settlement on MR and Loan is the same, the projection                       MD023787
      ** should be done (credit) like a normal loan.                                        MD023787
      ** To convene with functionalities, no need to create PAMV if                         MD040186
      ** MAPY receipt account and PDCL receipt account are the same.                        MD040186
      *                                                                                     MD040186
     C     ReadCLRSTM    IFEQ      MRRSTM                                                   MD040186
     C     RONSL         ANDEQ     MRRONS                                                   MD040186
     C                   EVAL      WPDCLNoPost = 'Y'                                        MD040186
     C                   ENDIF                                                              MD040186
      *                                                                                     MD023787
     C     ReadCLRSTM    IFNE      MRRSTM                                                   MD023787
     C     RONSL         ORNE      MRRONS                                                   MD023787
     C                   MOVE      'Y'           PDCL1                                      MD023787
     C                   MOVE      'Y'           PDRST                                      MD023787
     C                   MOVE      WTYP          WTYP1             2                        MD023787
     C                   MOVE      WOURS         WOURS1           18                        MD023787
     C                   MOVE      WTHRS         WTHRS1           10                        MD023787
     C                   MOVE      WFACO         WFACO1           10                        MD023787
     C                   ENDIF                                                              MD023787
     C                   ENDIF                                                              MD023787
     C                   ENDIF                                                              MD023787
      *                                                                                     MD023787
     C     POSTPD        TAG                                                                MD023787

      ***  Do On-line updates

     C     WPDCLNoPost   IFEQ      ' '                                                      MD040186
     C                   MOVE      *BLANKS       ##RTCD            7
     C                   CALL      'AOOULAU0'
     C                   PARM      *BLANKS       ##RTCD            7
     C                   PARM                    Z#BSTS
     C                   PARM                    Z#ASTS
     C                   PARM                    Z#WSTS
     C                   PARM                    PDCLI             1                        MD023787
      *                                                                                     MD023787
      ** Post on PDCL reciept                                                               MD023787
      *                                                                                     MD023787
     C     PDCL1         IFEQ      'Y'                                                      MD023787
     C                   MOVE      RSTML         WTYP                                       MD023787
     C                   MOVE      RONSL         WOURS                                      MD023787
     C                   MOVE      RIBNL         WTHRS                                      MD023787
     C                   MOVE      BENNL         WFACO                                      MD023787
     C                   MOVE      WSETT         SHTIST                                     MD023787
     C                   MOVE      Z#ADTA        Z#ADT1                                     MD023787
     C     WWACTN        IFEQ      'R'                                                      MD023787
     C                   MOVE      Z#ADTA        Z#BDT1                                     MD023787
     C                   ENDIF                                                              MD023787
     C                   MOVE      'Y'           PDCLI                                      MD023787
     C                   MOVE      *BLANKS       PDCL1             1                        MD023787
     C                   GOTO      POSTPD                                                   MD023787
     C                   ENDIF                                                              MD023787
      *                                                                                     MD023787
      ** Restore MR settlement for further use.                                             MD023787
      *                                                                                     MD023787
     C     PDRST         IFEQ      'Y'                                                      MD023787
     C                   MOVE      WTYP1         WTYP                                       MD023787
     C                   MOVE      WOURS1        WOURS                                      MD023787
     C                   MOVE      WTHRS1        WTHRS                                      MD023787
     C                   MOVE      WFACO1        WFACO                                      MD023787
     C                   MOVE      WSETT         SHTIST                                     MD023787
     C                   MOVE      Z#ADTA        Z#ADT1                                     MD023787
     C     WWACTN        IFEQ      'R'                                                      MD023787
     C                   MOVE      Z#ADTA        Z#BDT1                                     MD023787
     C                   ENDIF                                                              MD023787
     C                   MOVE      *BLANKS       PDCLI                                      MD023787
     C                   MOVE      *BLANKS       PDRST                                      MD023787
     C                   ENDIF                                                              MD023787
      *                                                                                     AR868380
     C     ##RTCD        IFEQ      '*RECLCK'                                                AR868380
     C                   MOVEL     '*RECLCK'     @@RTCD                                     AR868380
     C                   GOTO      EXIT                                                     AR868380
     C                   ENDIF                                                              AR868380
      *
     C     ##RTCD        IFEQ      '*ERROR*'
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INU7
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              264065
     C     PRAM          IFNE      0                                                          264065
     C     TAMT          ORNE      0                                                          264065
     C                   MOVEL     SHLNRF        OLNRF                                        264065
     C                   MOVEL     SHVDAT        OVDAT                                        264065
     C                   MOVEL     SHLASN        OLASN                                        264065
     C                   MOVEL     SHPRAM        OMPRAM                                       264065
     C                   CALL      'LE2041  '                                                 264065
     C                   PARM                    OLNRF             6                          264065
     C                   PARM                    OVDAT             5 0                        264065
     C                   PARM                    OLASN             3 0                        264065
     C                   PARM                    OMPRAM           13 0                        264065
     C                   PARM                    AMTP                                         264065
     C                   PARM                    WWACTN                                       264065
     C                   PARM                    MRPRAM                                     MD047554
     C                   PARM      *BLANKS       ##RTCD                                     AR868380
      *                                                                                     AR868380
     C     ##RTCD        IFEQ      '*RECLCK'                                                AR868380
     C                   MOVEL     '*RECLCK'     @@RTCD                                     AR868380
     C                   GOTO      EXIT                                                     AR868380
     C                   ENDIF                                                              AR868380
     C                   ENDIF                                                                264065
     C                   ENDIF                                                              MD040186
      *
      * We only need to call AOOULEU0 if the Pay our Nostro fields                           BUG4513
      * are different for the Loan and Manual repayment.                                     BUG4513
      *                                                                                      BUG8458
     C                   MOVE      'N'           AOOULE            1                         BUG8458
     C                   MOVE      'N'           SETT09            1                         BUG8458
     C     PTYP          IFEQ      61                                                        BUG8458
     C     PTYP          OREQ      62                                                        BUG8458
     C     PTYP          OREQ      63                                                        BUG8458
     C     PTYP          OREQ      64                                                        BUG8458
     C     PTYP          OREQ      65                                                        BUG8458
     C     PTYP          OREQ      68                                                        BUG8458
     C     PTYP          OREQ      70                                                        BUG8458
     C     PTYP          OREQ      71                                                        BUG8458
      *                                                                                      BUG8458
     C     ReadCLRSTM    IFEQ      9                                                         BUG8458
     C     MRRSTM        OREQ      9                                                         BUG8458
      *                                                                                      BUG8458
     C                   MOVE      'Y'           SETT09                                      BUG8458
     C     ReadCLRSTM    IFNE      MRRSTM                                                    BUG8458
     C     ReadCLSCCY    ORNE      MRSCCY                                                    BUG8458
     C                   MOVE      'Y'           AOOULE                                      BUG8458
     C                   ENDIF                                                               BUG8458
      *                                                                                      BUG8458
     C                   ENDIF                                                               BUG8458
     C                   ENDIF                                                               BUG8458
      *                                                                                      BUG8458
     C     PTYP          IFEQ      66                                                        BUG8458
     C     PTYP          OREQ      67                                                        BUG8458
     C     PTYP          OREQ      69                                                        BUG8458
     C     PTYP          OREQ      72                                                        BUG8458
      *                                                                                      BUG8458
     C     ReadCLPSTM    IFEQ      9                                                         BUG8458
     C     MRPSTM        OREQ      9                                                         BUG8458
      *                                                                                      BUG8458
     C                   MOVE      'Y'           SETT09                                      BUG8458
     C     ReadCLPSTM    IFNE      MRPSTM                                                    BUG8458
     C     ReadCLPSCY    ORNE      MRPSCY                                                    BUG8458
     C                   MOVE      'Y'           AOOULE                                      BUG8458
     C                   ENDIF                                                               BUG8458
      *                                                                                      BUG8458
     C                   ENDIF                                                               BUG8458
     C                   ENDIF                                                               BUG8458
      *                                                                                      BUG8458
     C     ReadCLPONS    IFNE      MRPONS                                                    BUG4513
     C     SETT09        ANDNE     'Y'                                                       BUG8458
     C     AOOULE        OREQ      'Y'                                                       BUG8458
      *                                                                                     MD047554
      ** Processing of manual repayment amound should be done                               MD047554
      ** in the AO program to correctly recalculate interest                                MD047554
      ** and principal amounts.                                                             MD047554
      *                                                                                     MD047554
                                                                                             BUG6223
     C**********         IF        PTYP = 66 or PTYP = 67 or                        BUG6223 MD047554
     C**********                   PTYP = 69 or PTYP = 72                           BUG6223 MD047554
      *                                                                                      BUG4513
      * For Insert                                                                           BUG4513
     C*****MRCHTP        IFEQ      'I'                                              BUG4513 MD047554
     C                   MOVE      *BLANKS       @RTCD                                       BUG4513
     C*****ReadCLCPAM    ADD       PRAM          ReadCLCPAM                          BUG4513  237242
     C                   MOVEL     ReadLoan      Z#BSTS                                      BUG4513
     C*****ReadCLCPAM    SUB       PRAM          ReadCLCPAM                         BUG4513 MD047554
     C                   MOVEL     ReadLoan      Z#ASTS                                      BUG4513
     C**********         ENDIF                                                      BUG4513 MD047554
      * For Reverse                                                                          BUG4513
     C*****MRCHTP        IFEQ      'R'                                              BUG4513 MD047554
     C**********         MOVE      *BLANKS       @RTCD                              BUG4513 MD047554
     C*****ReadCLCPAM    SUB       PRAM          ReadCLCPAM                         BUG4513 MD047554
     C**********         MOVEL     ReadLoan      Z#BSTS                             BUG4513 MD047554
     C*****ReadCLCPAM    ADD       PRAM          ReadCLCPAM                         BUG4513 MD047554
     C**********         MOVEL     ReadLoan      Z#ASTS                             BUG4513 MD047554
     C**********         ENDIF                                                      BUG4513 MD047554
      *                                                                                       237242
      ** For Authorise                                                                        237242
     C     MRCHTP        IFEQ      'X'                                                        237242
     C     MRCHTP        OREQ      'A'                                                        237242
     C                   EVAL      @RTCD = *BLANKS                                            237242
     C                   MOVEL     ReadLoan      Z#BSTS                                       237242
     C                   MOVEL     ReadLoan      Z#ASTS                                       237242
     C                   ENDIF                                                                237242
      *                                                                                      BUG4513
     C**********         CALL      'AOOULEU0'                                       BUG4513 MD047554
     C**********         PARM                    @RTCD                              BUG4513 MD047554
     C**********         PARM                    Z#BSTS                             BUG4513 MD047554
     C**********         PARM                    Z#ASTS                             BUG4513 MD047554
     C**********         PARM                    Z#WSTS                             BUG4513 MD047554
     C**********         PARM                    Z#BSTK                             BUG4513 MD047554
     C**********         PARM                    Z#ASTK                             BUG4513 MD047554
     C**********         PARM      *BLANKS       CLONQD                              CER049 MD047554
      **********                                                                   AR868380 MD047554
     C*****@RTCD         IFEQ      '*RECLCK'                                       AR868380 MD047554
     C**********         MOVEL     '*RECLCK'     @@RTCD                            AR868380 MD047554
     C**********         GOTO      EXIT                                            AR868380 MD047554
     C**********         ENDIF                                                     AR868380 MD047554
      **********                                                                    BUG4513 MD047554
     C*****@RTCD         IFEQ      '*ERROR*'                                        BUG4513 MD047554
     C**********         MOVE      *ON           *INU8                              BUG4513 MD047554
     C**********         MOVE      *ON           *INU7                              BUG4513 MD047554
     C**********         EXSR      *PSSR                                            BUG4513 MD047554
     C**********         ENDIF                                                      BUG4513 MD047554
      **********                                                                    BUG4513 MD047554
     C**********         ENDIF                                                      BUG6223 MD047554
      *                                                                                      BUG6223
     C                   ENDIF                                                               BUG4513
     C/COPY WNCPYSRC,LEH01194
      *                                                                                      BUG4513
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GLZADD   - Subroutine to add an amount to the total           *
      * Called by: SRTRAL, GLZSUB                                     *
      * Calls    : GLZSUM                                             *
      *****************************************************************
      *
     C     GLZADD        BEGSR
      *
     C                   Z-ADD     ZZAMT         ZZAMT            15 3    91    -DEFINE ZZAMT
     C   91              GOTO      ZZAEND                                       AMT = 0.BYPASS

      ***  SPLIT ZZAMT INTO INTEGER AND DECIMAL FIELDS

     C                   Z-ADD     ZZAMT         ZZAMTI           15 0          INTEGER FIELD
     C                   MOVE      ZZAMT         ZZAMTD            3 0          DECIMAL FIELD

      ***  BOTH ZZAMTI AND ZZAMTD CONTAIN A 'SIGN' ZONE NOW

     C                   EXSR      GLZSUM
     C     ZZAEND        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GLZSUM   - Subroutine to carry out the addition for subroutine*
      * Called by: GLZSUM                                             *
      * Calls    : None                                               *
      *****************************************************************
     C     GLZSUM        BEGSR
      *
     C                   Z-ADD     ZZTOTI        ZZTOTI           15 0          DEFINE ZZTOTI
     C                   Z-ADD     ZZTOTD        ZZTOTD            3 0          DEFINE ZZTOTD
     C                   SETOFF                                       919293
     C                   SETOFF                                       949599

      ***  DETERMINE SIGN OF ZZAMTI & D,   92 IF NEG

     C     ZZAMTI        COMP      0                                    9293
     C   93ZZAMTD        COMP      0                                    9293
     C   93              GOTO      ZZSEND                                       ZERO BYPASS

      ***  DETERMINE SIGN OF ZZTOTI & D, 91 IF NEG.

     C     ZZTOTI        COMP      0                                    9193
     C   93ZZTOTD        COMP      0                                    9193

      ***  IF ZZTOTAL IS ZERO, RETURN ZZAMOUNT.

     C   93              Z-ADD     ZZAMTI        ZZTOTI
     C   93              Z-ADD     ZZAMTD        ZZTOTD
     C   93              GOTO      ZZSEND                                       ZERO BYPASS

      ***  IF SIGNS DIFFER BYPASS OVERFLOW CHECKS.

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

      ***  IF THE MODULUS OF ZZWK3 IS LT MOD. ZZTOTI THEN O/F HAS OCCURED

     C  N92ZZWK3         COMP      ZZTOTI                               99      -92 MEANS NOS.
     C   92ZZWK3         COMP      ZZTOTI                             99         NEGATIVE
     C  N99              Z-ADD     ZZWK2         ZZTOTD
     C  N99              Z-ADD     ZZWK3         ZZTOTI

      ***  IF O/F ZEROIZE ZZAMT , IND '99' SET AND ZZTOT FIELDS LEFT INTACT.

     C   99              Z-ADD     0             ZZAMT            15 3
     C                   GOTO      ZZSEND

      ***  THE 'SIGNS' ARE DIFFERENT

     C     ZZOFPS        TAG

      ***  IF ZZAMT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZTOT

     C   92              Z-SUB     ZZAMTI        ZZAMTI           15 0
     C   92              Z-SUB     ZZAMTD        ZZAMTD            3 0

      ***  IF ZZTOT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZAMT.

     C   91              Z-SUB     ZZTOTI        ZZTOTI
     C   91              Z-SUB     ZZTOTD        ZZTOTD

      ***  BOTH ZZAMT AND ZZTOT ARE NOW POSITIVE.

     C     ZZTOTI        COMP      ZZAMTI                             93  95
     C   95ZZTOTD        COMP      ZZAMTD                             93  95

      ***  IF ZZTOT EQ. ZZAMT RETURN ZERO.

     C   95              Z-ADD     0             ZZTOTI
     C   95              Z-ADD     0             ZZTOTD
     C   95              GOTO      ZZSEND

      ***  IF ZZTOT GT. ZZAMT.

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

      ***  IF ZZAMT GT. ZZTOT.

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

      ***  REVERSE SIGN OF ZZTOT IF LARGER I/P FIELDS WERE NEGATIVE

     C                   SETOFF                                       94
     C   93
     CAN 91
     CORN93
     CAN 92              SETON                                        94
     C   94              Z-SUB     ZZTOTI        ZZTOTI
     C   94              Z-SUB     ZZTOTD        ZZTOTD

      ***  RESTORE SIGN OF ZZAMTI & ZZAMTD IF IT WAS REVERSED.

     C   92              Z-SUB     ZZAMTI        ZZAMTI
     C   92              Z-SUB     ZZAMTD        ZZAMTD
     C     ZZSEND        TAG

      ***  IF ZZTOTD IS ZERO, AND ZZTOTI IS NEG. SET UP ZZNEGD.

     C                   SETOFF                                       96
     C     ZZTOTD        COMP      0                                      91
     C   91ZZTOTI        COMP      0                                    96
     C   96              MOVE      '.000-'       ZZNEGD            5
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GLZSUB   - Subroutine to subtract an amount from the total    *
      * Called by: SRTRAL                                             *
      * Calls    : GLZADD                                             *
      *****************************************************************
     C     GLZSUB        BEGSR

      ***  PROCESSING. JUST REVERSE THE 'SIGN' AND ADD

     C                   Z-SUB     ZZAMT         ZZAMT            15 3          REVERSE 'SIGN'
     C                   EXSR      GLZADD                                         AND 'ADD'
     C                   Z-SUB     ZZAMT         ZZAMT                          RESTORE 'SIGN'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CRE020
      *****************************************************************                       CRE020
      *                                                               *                       CRE020
      *  SRIdxTrn - Handles the advice index of the current           *                       CRE020
      *             transaction.                                      *                       CRE020
      *                                                               *                       CRE020
      *****************************************************************                       CRE020
     C     SRIdxTrn      BEGSR                                                                CRE020
                                                                                              CRE020
     C                   EVAL      KRefNo = *BLANKS                                           CRE020
     C                   EVAL      KSeqNo = *BLANKS                                           CRE020
     C                   MOVEL     MRLNRF        KRefNo                                       CRE020
     C                   MOVEL     MRLASN        KSeqNo                                       CRE020
                                                                                              CRE020
     C                   OPEN      READVCL2                                                   CRE020
                                                                                              CRE020
     C     KADVC         CHAIN     READVCL2                                                   CRE020
                                                                                              CRE020
     C                   IF        %FOUND (READVCL2)                                          CRE020
                                                                                              CRE020
      ** Check first if the record was just inserted                                          CRE020
                                                                                              CRE020
     C                   IF        RCHTYP = 'I' AND                                           CRE020
     C                             RSAPIN <>'Y'                                               CRE020
     C                   SELECT                                                               CRE020
                                                                                              CRE020
     C                   WHEN      WSCHTP = 'R'                                               CRE020
     C                   EVAL      RCHTYP = 'R'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'Y'                                               CRE020
     C                   UPDATE    READVCD0                                                   CRE020
                                                                                              CRE020
      ** If transaction was authorised, set the authorise indicator to 'Y'                    CRE020
                                                                                              CRE020
     C                   WHEN      ASTS   = 'A'                                               CRE020
     C                   IF        RAUTHI = 'N'                                               CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   UPDATE    READVCD0                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   OTHER                                                                CRE020
     C                   IF        RSAPIN = 'N'                                               CRE020
     C                   EVAL      RAUTHI = 'N'                                               CRE020
     C                   UPDATE    READVCD0                                                   CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDSL                                                                CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     **  If existing transaction was amended, authorised or deleted, update Last Change       CRE020
     **  Type, Authorise Indicator and Print Advice Indicator                                 CRE020
                                                                                              CRE020
     C                   IF        ASTS   = 'A' OR                                            CRE020
     C                             WSCHTP = 'R'                                               CRE020
     C                   IF        RAUTHI = 'N'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   ENDIF                                                                CRE020
     C                   ELSE                                                                 CRE020
     C                   IF        RSAPIN = 'N'                                               CRE020
     C                   EVAL      RAUTHI = 'N'                                               CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   IF        WSCHTP <>'X'                                               CRE020
     C                   EVAL      RCHTYP = WSCHTP                                            CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   UPDATE    READVCD0                                                   CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
     C                   CLOSE     READVCL2                                                   CRE020
                                                                                              CRE020
     C                   ENDSR                                                                CRE020
      *****************************************************************                       CRE020
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
     C                   MOVEL     *BLANKS       WKLNRF                                      BUG3760
     C                   MOVEL     *BLANKS       WKVDAT                                      BUG3760
     C                   MOVEL     *BLANKS       WLASN                                       BUG3760
     C                   MOVEL     *BLANKS       W4IDEN                                      BUG3760
     C                   MOVEL     LNRF          WKLNRF                                      BUG3760
     C                   MOVEL     VDAT          WKVDAT                                      BUG3760
     C                   MOVEL     LASN          WLASN                                       BUG3760
     C     WKLNRF        CAT       WKVDAT:0      W4IDEN                                      BUG3760
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
      *****************************************************************
      *****************************************************************                       CAS019
      *                                                               *                       CAS019
      * SRFeesAmort - Flag Fees Amortised Separately                  *                       CAS019
      *                                                               *                       CAS019
      *****************************************************************                       CAS019
     C     SRFeesAmort   BEGSR                                                                CAS019
                                                                                              CAS019
      ** Search all fees amortised separately                                                 CAS019
                                                                                              CAS019
     C                   IF        CAS016 = 'Y'                                               CAS019
     C                   IF        MRMTPD <> 'Y' AND                                          CAS019
     C                             PAST <> 'Y' AND                                            CAS019
     C                             AMTP <> 'Y'                                                CAS019
     C     WLOAN         CHAIN     LEERAPL1                           20                      CAS019
     C                   DOW       *IN20 = '0'                                                CAS019
                                                                                              CAS019
     C     MRCHTP        IFEQ      'I'                                                        CAS019
     C     MRCHTP        OREQ      'R'                                                        CAS019
     C     VDAT          IFLE      EIENDT                                                     CAS019
     C                   MOVE      'Y'           EIRCAL                                       CAS019
     C                   UPDATE    LEERAPD0                                                   CAS019
     C                   ENDIF                                                                CAS019
     C                   ENDIF                                                                CAS019
                                                                                              CAS019
     C     WLOAN         READE     LEERAPL1                               20                  CAS019
     C                   ENDDO                                                                CAS019
                                                                                              CAS019
     C                   ENDIF                                                                CAS019
     C                   ENDIF                                                                CAS019
                                                                                              CAS019
     C                   ENDSR                                                                CAS019
      *****************************************************************                       CAS019
      /EJECT                                                                                  CAS019
      *****************************************************************                       CLE073
      *  CHKLON  -  Check if loan has associated fees                 *                       CLE073
      *  Called by: SRFEES                                            *                       CLE073
      *  Calls    : None                                              *                       CLE073
      *****************************************************************                       CLE073
      *                                                                                       CLE073
     C     CHKLON        BEGSR                                                                CLE073
      *                                                                                       CLE073
     C                   Z-ADD     0             WFFACL                                       CLE073
     C                   MOVEL     MRLNRF        WFLOAN                                       CLE073
     C     WKFEE         SETLL     LEFEEDL1                                                   CLE073
     C*****WKFEE         READE     LEFEEDL1                               14         CLE073 MD054035
     C     WKFEE         READE (N) LEFEEDL1                               14                MD054035
      *                                                                                       CLE073
      ** Do while an associated fee exists                                                    CLE073
      *                                                                                       CLE073
     C     *IN14         DOWEQ     *OFF                                                       CLE073
      *                                                                                       CLE073
      ** If the fee is a confirmed calculated fee and swift                                   CLE073
      ** regeneration indicator is not 'I', 'B', 'H'                                          CLE073
      ** and Value Date is on or after Fee Start and before or on Fee End Date                CLE073
      *                                                                                       CLE073
     C                   MOVE      FEAUTO        WFEAUT            1                          CLE134
     C     CLE134        IFEQ      'Y'                                                        CLE134
     C     WFEAUT        IFEQ      'C'                                                        CLE134
     C     FEAUT2        OREQ      'C'                                                        CLE134
     C                   MOVE      'Y'           WFEAUT            1                          CLE134
     C                   ENDIF                                                                CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE134
     C*****FEAUTO        IFEQ      'Y'                                                CLE073  CLE134
     C     WFEAUT        IFEQ      'Y'                                                        CLE134
     C     FESWRI        ANDNE     'I'                                                        CLE073
     C     FESWRI        ANDNE     'B'                                                        CLE073
     C     FESWRI        ANDNE     'H'                                                        CLE073
     C     FECALT        ANDEQ     '97'                                                       CLE073
     C     MRVDAT        ANDGE     FEPSTD                                                     CLE073
     C     MRVDAT        ANDLE     FEPEND                                                     CLE073
      *                                                                                       CLE073
      ** Set currency to fee currency                                                         CLE073
      ** Set day to run date                                                                  CLE073
      ** Set number of working days to telex notice days                                      CLE073
      *                                                                                       CLE073
     C                   MOVE      FEFCCY        ZCCY                                         CLE073
     C                   Z-ADD     BJRDNB        ZDAYNO                                       CLE073
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
     C                   MOVE      WKCCY         PCURR                                      MD054317
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
     C                   PARM      *BLANKS       PRTCD                                        CLE073
     C                   PARM      '*KEY   '     POPTN                                        CLE073
     C                   PARM                    PCUSN             6                          CLE073
     C**********         PARM      FEFCCY        PCURR                               CLE073 MD054317
     C                   PARM                    PCURR                                      MD054317
     C                   PARM                    PACCD                                        CLE073
     C                   PARM                    PACSN             2                          CLE073
     C                   PARM      FEOURS        PNONB             2                          CLE073
     C                   PARM                    PBRCA                                        CLE073
     C                   PARM                    PCSSN            10                          CLE073
     C                   PARM                    PPNOI             1                          CLE073
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
                                                                                            MD054035
     C                   MOVEL     FECNUM        WFCNUMX                                    MD054035
     C                   MOVEL     FEFACL        WFFACLX                                    MD054035
     C                   MOVEL     FELOAN        WFLOANX                                    MD054035
     C                   MOVEL     FEFSEQ        WFSEQNX                                    MD054035
      *                                                                                       CLE073
      ** If next payment date is before or equals to Telex Notice date                        CLE073
      ** and Next Payment Telex indicator is set to 'Y'                                       CLE073
      *                                                                                       CLE073
     C     FENPYD        IFLE      TXDT                                                       CLE073
     C     FEPPTI        ANDEQ     'Y'                                                        CLE073
      *                                                                                       CLE073
      ** Update Fees file                                                                     CLE073
      *                                                                                       CLE073
     C     WKFEEX        CHAIN     LEFEEDL0                                                 MD054035
     C                   IF        %FOUND(LEFEEDL0)                                         MD054035
     C**********         MOVE      'A'           FESWRI                              CLE073 MD054035
     C**********         UPDATE    LEFEEDF                                           CLE073 MD054035
     C                   MOVE      'A'           X_FESWRI                                   MD054035
     C                   UPDATE    LEFEEDX                                                  MD054035
     C                   ENDIF                                                              MD054035
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
     C     WKFEEX        CHAIN     LEFEEDL0                                                 MD054035
     C                   IF        %FOUND(LEFEEDL0)                                         MD054035
     C**********         MOVE      'A'           FESWRI                              CLE073 MD054035
     C**********         UPDATE    LEFEEDF                                           CLE073 MD054035
     C                   MOVE      'A'           X_FESWRI                                   MD054035
     C                   UPDATE    LEFEEDX                                                  MD054035
     C                   ENDIF                                                              MD054035
     C                   ENDIF                                                                CLE073
     C                   ENDIF                                                                CLE073
      *                                                                                       CLE073
     C                   ENDIF                                                                CLE073
      *                                                                                       CLE073
     C*****WKFEE         READE     LEFEEDL1                               14         CLE073 MD054035
     C     WKFEE         READE (N) LEFEEDL1                               14                MD054035
     C                   ENDDO                                                                CLE073
      *                                                                                       CLE073
     C                   ENDSR                                                                CLE073
      *                                                                                       CLE073
      /EJECT                                                                                  CLE073
      *****************************************************************                       CLE073
     C*****SRSCRP        BEGSR                                                       CLE134 MD020445
     C**********         IF        UpSRFlg = 'Y' AND CLE134 = 'Y'                    CLE134 MD020445
     C**********         MOVE      MRLNRF        CLNRF                               CLE134 MD020445
     C**********         MOVE      BJRDNB        CVALD                               CLE134 MD020445
     C*****MRTKEY        CHAIN     LOAMLA                             51             CLE134 MD020445
     C**********         IF        *IN51 = *OFF                                      CLE134 MD020445
     C**********         CLEAR                   P1MFPD                              CLE134 MD020445
     C**********         CLEAR                   P2MFPD                              CLE134 MD020445
     C**********         EVAL      P1LNRF = MRLNRF                                   CLE134 MD020445
     C**********         EVAL      PDayNoIn = MRVDAT                                 CLE134 MD020445
     C**********         CALLB     'ZDATE9'                                          CLE134 MD020445
     C**********         PARM                    PDayNoIn          5 0               CLE134 MD020445
     C**********         PARM      *ZERO         PDateOutZ9                          CLE134 MD020445
     C**********         PARM                    PRetCode                            CLE134 MD020445
     C**********         EVAL      P1VDAT = %EDITC(VDATDy:'X') +                     CLE134 MD020445
     C**********                   %EDITC(VDATMn:'X') + %EDITC(VDATyr:'X')           CLE134 MD020445
     C**********         EVAL      P1LASN = LASNCK                                   CLE134 MD020445
     C**********         EVAL      P1FIL4 = 'C134'                                   CLE134 MD020445
     C**********         IF        MRPRAM >= PRAMCK OR WWACTN = 'R'                  CLE134 MD020445
     C**********         EVAL      P1ACTN = 'R'                                      CLE134 MD020445
     C**********         ELSE                                                        CLE134 MD020445
     C**********         EVAL      P1PRAM = %EDITC(PRAMCK - MRPRAM:'X')              CLE134 MD020445
     C**********         EVAL      P1ACTN = 'A'                                      CLE134 MD020445
     C**********         ENDIF                                                       CLE134 MD020445
     C**********         MOVE      'B'           P#MODE            1                CLE134 AR1080805
     C**********         CALL      'LE2120'                                         CLE134 AR1080805
     C**********         PARM                    P#MODE                             CLE134 AR1080805
     C**********         PARM                    P1MFPD                             CLE134 AR1080805
     C**********         PARM                    P2MFPD                             CLE134 AR1080805
     C**********         PARM                    TMST                               CLE134 AR1080805
     C**********         ENDIF                                                       CLE134 MD020445
     C**********         ENDIF                                                       CLE134 MD020445
     C**********         ENDSR                                                       CLE134 MD020445
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
      *****************************************************************              CLE134 MD020445
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C                   MOVEA     CPY@          CPY2@            80

      ***  Program Parameters

     C     *ENTRY        PLIST
      *
      ***  Inputs
      ***  ======
     C                   PARM                    @@RTCD            7            Return Code
      ***  Externally described DS for valid Manual Repayment
     C                   PARM                    LEVMaPy                        Valid details
     C                   PARM                    ReadLoAm                       PD/RE details
     C                   PARM                    ReadLoan                       Loan details
      ***  Old settlement details
     C                   PARM                    OldSettlDS
      ***  New settlement details
     C                   PARM                    NewSettlDS
      ***  Data
     C                   PARM                    PassDtaDS
      *
      ***  Outputs
      ***  =======
     C                   PARM                    OKFlagsDS                      Field OK flags
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
      * Reservation ID                                                          CDE005
     C                   PARM                    ResrvId                        CDE005
     C**********         PARM                    UpSRFlg           1                 CLE134 MD020445
     C                   PARM                    UpSRFlg           1                        MD020733
     C                   PARM                    DDAuto            1                          CLE164

      ***  Access Bank Details

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY

     C                   IF        @RTCD <> *BLANK
     C     *LOCK         IN        LDA
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVEL     'LEMAPYUPD'   DBPGM
     C                   MOVE      '*FIRST'      DBKEY                          *************
     C                   MOVEL     'SDBANKPD'    DBFILE                         * DBERR 001 *
     C                   Z-ADD     1             DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ***  Retrieve lending ICD

     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDCLND        PARM      SDCLND        DSFDY                                        CLE134
     C     SDCLND        PARM      SDCLND        DSSDY                                        CLE134
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVEL     'LEMAPYUPD'   DBPGM
     C                   MOVE      '*FIRST'      DBKEY                          *************
     C                   MOVEL     'SDCLNDPD'    DBFILE                         * DBERR 002 *
     C                   Z-ADD     2             DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ***  Access Trading Data

     C                   CALLB     'AOTRADR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDTRAD        PARM      SDTRAD        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVEL     'LEMAPYUPD'   DBPGM
     C                   MOVEL     'SDTRADPD'    DBFILE                         *************
     C                   Z-ADD     3             DBASE                          * DBERR 003 *
     C                   MOVEL     '*FIRST'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF

      ***  Retrieve module details

     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY

     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVEL     'LEMAPYUPD'   DBPGM
     C                   MOVE      '*FIRST'      DBKEY                          *************
     C                   MOVEL     'SDMMODPD'    DBFILE                         * DBERR 004 *
     C                   Z-ADD     04            DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     BGMBIN        MBIN              1

      ***  Access General Ledger

     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029

     C     @RTCD         IFNE      *BLANKS
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   MOVEL     'LEMAPYUPD'   DBPGM
     C                   MOVEL     'SDGELRPD'    DBFILE                         *************
     C                   Z-ADD     5             DBASE                          * DBERR 005 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
     C                   If        BGRTBN = 'Y'

     C                   CALLB     'AORETLR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDRETL        PARM      SDRETL        DSFDY

     C                   endif
                                                                                              CLE106
      **  Access CLE106 feature                                                               CLE106
                                                                                              CLE106
     C                   EVAL      CLE106 = 'N'                                               CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *Blanks       @RTCD                                        CLE106
     C                   PARM      '*VERIFY'     @OPTN                                        CLE106
     C                   PARM      'CLE106'      @SARD                                        CLE106
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE106
                                                                                              CLE106
     C                   IF        @RTCD = *Blanks                                            CLE106
     C                   EVAL      CLE106 = 'Y'                                               CLE106
     C                   ENDIF                                                                CLE106
                                                                                              CLE031
      **  Access CLE031 feature                                                               CLE031
                                                                                              CLE031
     C                   EVAL      CLE031 = 'N'                                               CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *Blanks       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE031
                                                                                              CLE031
     C                   IF        @RTCD = *Blanks                                            CLE031
     C                   EVAL      CLE031 = 'Y'                                               CLE031
     C                   ENDIF                                                                CLE031

      ***  Access CSC011 feature, 24X7 Interface
      ** CSC011 is a redundant feature. No need to check                                    MD024398

     C                   MOVE      'N'           CSC011            1
     C**********         CALLB     'AOSARDR0'                                               MD024398
     C**********         PARM      *BLANKS       @RTCD                                      MD024398
     C**********         PARM      '*VERIFY'     @OPTN                                      MD024398
     C**********         PARM      'CSC011'      @SARD             6                        MD024398
     C*****SCSARD        PARM      SCSARD        DSFDY                                      MD024398

     C*****@RTCD         IFEQ      *BLANKS                                                  MD024398
     C**********         MOVE      'Y'           CSC011                                     MD024398
     C     *DTAARA       DEFINE                  SDSTAT
     C******DTAARA       DEFINE                  SC24X7                                     MD024398
     C**********         Endif                                                              MD024398
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
     C                   Z-ADD     33            DBASE                                        CLE025
     C                   EXSR      *PSSR                                                      CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
     C                   IF        PRTCD = *BLANKS                                            CLE025
     C                   MOVE      'Y'           CLE025                                       CLE025
     C                   ENDIF                                                                CLE025

      ***  when feature CLE009 is Activated, fill in working Arrays

     C                   if        CLE009 = 'Y'
     C                   Z-ADD     1             Y                 3 0

     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C                   PARM                    PCURR             3
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   MOVE      A6CYCD        CYA(Y)
     C                   MOVE      A6TXND        TND(Y)

     C     PRTCD         DOWNE     '*EOF    '
     C                   ADD       1             Y

     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*NEXT  '     POPTN
     C                   PARM                    PCURR             3
     C     SDCURR        PARM      SDCURR        DSSDY

     C     PRTCD         IFNE      '*EOF    '
     C                   MOVE      A6CYCD        CYA(Y)
     C                   MOVE      A6TXND        TND(Y)
     C                   ENDIF

     C                   ENDDO

     C                   Endif
                                                                                              CRE020
      ** Check if CRE020 is enabled.                                                          CRE020
                                                                                              CRE020
     C                   CALLB     'AOSARDR0'                                                 CRE020
     C                   PARM      *BLANKS       @RTCD                                        CRE020
     C                   PARM      '*VERIFY'     @OPTN                                        CRE020
     C                   PARM      'CRE020'      @SARD                                        CRE020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE020
                                                                                              CRE020
     C                   EVAL      CRE020 = 'N'                                               CRE020
                                                                                              CRE020
     C                   IF        @RTCD = *BLANKS                                            CRE020
     C                   EVAL      CRE020 = 'Y'                                               CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        @RTCD <> '*NRF'                                            CRE020
     C     *LOCK         IN        LDA                                                        CRE020
     C                   EVAL      DBFile = 'SCSARDPD'                                        CRE020
     C                   EVAL      DBase = 40                                                 CRE020
     C                   EVAL      DBKey = 'CRE020'                                           CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      *PSSR                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
     C/COPY WNCPYSRC,LEH01195
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
     C                   EVAL      DBase = 41                                                 CRE020
     C                   EVAL      DBKey = PSysVal01                                          CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      *PSSR                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      *                                                                                     MD023787
      ** Get MPHAS dataarea.                                                                MD023787
      *                                                                                     MD023787
     C     *DTAARA       DEFINE                  MPHAS                                      MD023787
     C                   IN        MPHAS                                                    MD023787
     C                   UNLOCK    MPHAS                                                    MD023787
      *                                                                                     MD023787
     C                   EVAL      CobMode = 'N'                                            MD023787
     C**********         IF        MPHAS <> 'A'                                    MD023787 MD025467
     C                   IF        MPHAS =  'C'                                             MD025467
     C                   EVAL      CobMode = 'Y'                                            MD023787
     C                   ENDIF                                                              MD023787
      *                                                                                     MD023787

      ***  Define Key Lists

      ***  Loan Amendments

     C     KLMKEY        KLIST
     C**********         KFLD                    WLNRF             6 0                        CLE148
     C                   KFLD                    WLNRF                                        CLE148
     C                   KFLD                    WVALD             5 0
     C                   KFLD                    SLASN

      ***  Loans

     C     WKLON         KLIST
     C**********         KFLD                    WCLOAN            6 0                        CLE148
     C                   KFLD                    WCLOAN            6                          CLE148
     C                   KFLD                    WCRCDT            1
      *
     C     KCLOAN        KLIST
     C**********         KFLD                    WLOAN             6 0                        CLE148
     C                   KFLD                    WLOAN             6                          CLE148
     C                   KFLD                    WRCDT             1

      ***  Facility

     C     KFCLT         KLIST
     C                   KFLD                    WFCUS
     C                   KFLD                    WFTYP
     C                   KFLD                    WFSEQ
     C                   KFLD                    WRCDT1
      *                                                                                      245177A
     C     KFCAM         KLIST                                                               245177A
     C                   KFLD                    WFCUS                                       245177A
     C                   KFLD                    WFTYP                                       245177A
     C                   KFLD                    WFSEQ                                       245177A

      ***  Loan Amendment Fee Index

     C     KIDXF         KLIST
     C**********         KFLD                    WKLOAN            6 0                        CLE148
     C                   KFLD                    WKLOAN            6                          CLE148
     C                   KFLD                    WKDATE            5 0
     C                   KFLD                    WKSEQN            3 0

      ***  Fees

     C     WKFEE         KLIST
     C**********         KFLD                    WFCNUM            6 0                        CSD027
     C                   KFLD                    WFCNUM            6                          CSD027
     C                   KFLD                    WFFACL            5 0
     C**********         KFLD                    WFLOAN            6 0                        CLE148
     C                   KFLD                    WFLOAN            6                          CLE148
                                                                                              CRE020
      *** Midas RE Settled Transaction Index File Key List                                    CRE020
                                                                                              CRE020
     C     KADVC         KLIST                                                                CRE020
     C                   KFLD                    KRefNo                                       CRE020
     C                   KFLD                    KPrgMn                                       CRE020
     C                   KFLD                    KSeqNo                                       CRE020
      **********                                                                     CLE134 MD020445
     C*****MRTKEY        KLIST                                                       CLE134 MD020445
     C**********         KFLD                    CLNRF             6                 CLE134 MD020445
     C**********         KFLD                    CVALD             5 0               CLE134 MD020445
      *                                                                                      BUG3760
     C     KCwFld        KLIST                                                               BUG3760
     C                   KFLD                    WFuncType                                   BUG3760
     C                   KFLD                    WIdntifier                                  BUG3760
     C                   KFLD                    WBranch                                     BUG3760
      *                                                                                     MD023787
     C     KLOAN         KLIST                                                              MD023787
     C                   KFLD                    WKLNR             6                        MD023787
     C                   KFLD                    WKRCD             1                        MD023787
      *                                                                                     MD054035
     C     WKFEEX        KLIST                                                              MD054035
     C                   KFLD                    WFCNUMX           6                        MD054035
     C                   KFLD                    WFFACLX           5 0                      MD054035
     C                   KFLD                    WFLOANX           6                        MD054035
     C                   KFLD                    WFSEQNX           2 0                      MD054035
      **********                                                                   MD024342 MD025467
     C*****KAPILST       KLIST                                                     MD024342 MD025467
     C**********         KFLD                    WAPIC             4               MD024342 MD025467
     C**********         KFLD                    WFILN            10               MD024342 MD025467
      *                                                                                      BUG3760
      ** Check if CSC011 is installed                                                        BUG3760
      *                                                                                      BUG3760
      ** CSC011 is a redundant feature. No need to check                                    MD024398
     C**********         CALLB     'AOSARDR0'                                       BUG3760 MD024398
     C**********         PARM      *BLANKS       PRetCode                           BUG3760 MD024398
     C**********         PARM      '*VERIFY'     POption                            BUG3760 MD024398
     C**********         PARM      'CSC011'      PSard                              BUG3760 MD024398
     C*****SCSARD        PARM      SCSARD        DSFDY                              BUG3760 MD024398
      **********                                                                    BUG3760 MD024398
      ***Database*error                                                             BUG3760 MD024398
      **********                                                                    BUG3760 MD024398
     C**********         IF        (PRetCode <> '*NRF') and                         BUG3760 MD024398
     C**********                   (PRetCode <> *Blanks)                            BUG3760 MD024398
     C******LOCK         IN        LDA                                              BUG3760 MD024398
     C**********         EVAL      DBKEY = 'CSC011'                                 BUG3760 MD024398
     C**********         EVAL      DBFILE = 'SCSARDPD'                              BUG3760 MD024398
     C**********         EVAL      DBASE = 904                                      BUG3760 MD024398
     C**********         OUT       LDA                                              BUG3760 MD024398
     C**********         EXSR      *PSSR                                            BUG3760 MD024398
     C**********         ENDIF                                                      BUG3760 MD024398
      **********                                                                    BUG3760 MD024398
     C**********         IF        PRetCode = *Blanks                               BUG3760 MD024398
     C**********         EVAL      CSC011 = 'Y'                                     BUG3760 MD024398
     C**********         IN        SC24X7                                           BUG3760 MD024398
     C**********         ELSE                                                       BUG3760 MD024398
     C                   EVAL      CSC011 = 'N'                                              BUG3760
     C**********         ENDIF                                                      BUG3760 MD024398
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
                                                                                              CSC024
      ***Check*if*enhancement*CSC024*(Open*Month*End)*is*on                            CSC024 CSC054
      ** Check if enhancement CSC054 (Period End Adjustments) is on                           CSC054
                                                                                              CSC024
     C                   CALLB     'AOSARDR0'                                                 CSC024
     C                   PARM      *BLANKS       PRetCode                                     CSC024
     C                   PARM      '*VERIFY'     POption                                      CSC024
     C***********        PARM      'CSC024'      PSard                                 CSC024 CSC054
     C                   PARM      'CSC054'      PSard                                        CSC054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC024
                                                                                              CSC024
     C                   IF        PRetCode <> *BLANKS AND                                    CSC024
     C                             PretCode <> '*NRF   '                                      CSC024
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSC024
     C***********        EVAL      DBKey  = 'CSC024'                                   CSC024 CSC054
     C                   EVAL      DBKey  = 'CSC054'                                          CSC054
     C                   EVAL      DBase  = 34                                                CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C**********         EVAL      CSC024 = 'N'                                        CSC024 CSC054
     C**********         EVAL      WOMEInd = 'N'                                       CSC024 CSC054
     C                   EVAL      CSC054 = 'N'                                               CSC054
     C                   EVAL      WPEAInd = 'N'                                              CSC054
                                                                                              CSC024
     C                   IF        PRetCode = *BLANKS                                         CSC024
     C**********         EVAL      CSC024 = 'Y'                                        CSC024 CSC054
     C                   EVAL      CSC054 = 'Y'                                               CSC054
                                                                                              CSC024
      ** Access System values                                                                 CSC024
                                                                                              CSC024
     C**********         EVAL      PSysVal01 = POMESys01                               CSC024 CSC054
     C                   EVAL      PSysVal01 = PPEASys01                                      CSC054
     C                   CALL      'AOSVALR0'                                                 CSC024
     C                   PARM      *BLANKS       PRetCode                                     CSC024
     C                   PARM                    PSysVal01                                    CSC024
     C                   PARM      *BLANKS       PCurSet01                                    CSC024
     C                   PARM      *BLANKS       PSysVal02                                    CSC024
     C                   PARM      *BLANKS       PCurSet02                                    CSC024
     C                   PARM      *BLANKS       PSysVal03                                    CSC024
     C                   PARM      *BLANKS       PCurSet03                                    CSC024
     C                   PARM      *BLANKS       PSysVal04                                    CSC024
     C                   PARM      *BLANKS       PCurSet04                                    CSC024
     C                   PARM      *BLANKS       PSysVal05                                    CSC024
     C                   PARM      *BLANKS       PCurSet05                                    CSC024
     C                   PARM      *BLANKS       PSysVal06                                    CSC024
     C                   PARM      *BLANKS       PCurSet06                                    CSC024
     C                   PARM      *BLANKS       PSysVal07                                    CSC024
     C                   PARM      *BLANKS       PCurSet07                                    CSC024
     C                   PARM      *BLANKS       PSysVal08                                    CSC024
     C                   PARM      *BLANKS       PCurSet08                                    CSC024
     C                   PARM      *BLANKS       PSysVal09                                    CSC024
     C                   PARM      *BLANKS       PCurSet09                                    CSC024
     C                   PARM      *BLANKS       PSysVal10                                    CSC024
     C                   PARM      *BLANKS       PCurSet10                                    CSC024
                                                                                              CSC024
     C                   IF        PRetCode  <> *BLANKS                                       CSC024
     C                   EVAL      DBFile = 'SDSVALPD'                                        CSC024
     C                   EVAL      DBKEy = '*KEY   '                                          CSC024
     C                   EVAL      DBase = 35                                                 CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ENDIF                                                                CSC024
     C                   IF        PCurSet01 = 'Y'                                            CSC024
     C**********         EVAL      WOMEInd = 'Y'                                       CSC024 CSC054
     C                   EVAL      WPEAInd = 'Y'                                              CSC054
     C                   ENDIF                                                                CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
                                                                                              CAP086
      ** Check if CAP086 is enabled                                                           CAP086
                                                                                              CAP086
     C                   CALLB     'AOSARDR0'                                                 CAP086
     C                   PARM      *BLANKS       PRtCd                                        CAP086
     C                   PARM      '*VERIFY'     POptn                                        CAP086
     C                   PARM      'CAP086'      PSARD                                        CAP086
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP086
                                                                                              CAP086
     C                   IF        PRtCd = *BLANKS                                            CAP086
     C                   EVAL      CAP086 = 'Y'                                               CAP086
     C                   ELSE                                                                 CAP086
                                                                                              CAP086
     C                   IF        PRtCd <> '*NRF'                                            CAP086
     C     *LOCK         IN        LDA                                                        CAP086
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP086
     C                   EVAL      DBase = 36                                                 CAP086
     C                   EVAL      DBKey = 'CAP086'                                           CAP086
     C                   OUT       LDA                                                        CAP086
     C                   EXSR      *PSSR                                                      CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
     C                   ENDIF                                                                CAP086
      *
     C                   Z-ADD     0             I                 3 0
     C                   MOVE      *OFF          *IN99

      ***  First read, store BICN

     C     *LOVAL        SETLL     SDBRCHL5
     C                   READ      SDBRCHL5                               99

     C     *IN99         IFEQ      *ON
     C                   EVAL      @@RTCD = '*RECUPD'
     c     *LOCK         IN        LDA
     C                   MOVEL     'LEMAPYUPD'   DBPGM
     C                   MOVE      'SDBRCHL5'    DBFILE
     C                   MOVE      *BLANKS       DBKEY                          *************
     C                   Z-ADD     6             DBASE                          * DBERR 006 *
     C                   OUT       LDA                                          *************
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
     C     *IN99         DOUEQ     *ON
     C                   ADD       1             I
     C                   MOVE      A8BICN        @BIC(I)
     C                   READ      SDBRCHL5                               99
     C                   ENDDO
      *
     C                   ENDIF
     C                   MOVE      *OFF          *IN99
      *
      ** Check if switchable feature CAS009 is installed                                      CAS011
                                                                                              CAS011
     C                   EVAL      CAS009 = 'N'                                               CAS011
     C                   CALLB     'AOSARDR0'                                                 CAS011
     C                   PARM      *BLANKS       PRetCode                                     CAS011
     C                   PARM      '*VERIFY'     POption                                      CAS011
     C                   PARM      'CAS009'      PSard                                        CAS011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS011
                                                                                              CAS011
     C                   IF        PRetCode = *BLANKS                                         CAS011
     C                   EVAL      CAS009 = 'Y'                                               CAS011
     C                   ELSE                                                                 CAS011
     C                   IF        PRetCode <> '*NRF   '                                      CAS011
     C     *LOCK         IN        LDA                                                        CAS011
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAS011
     C                   EVAL      DBKey = 'CAS009'                                           CAS011
     C                   EVAL      DBase = 42                                                 CAS011
     C                   OUT       LDA                                                        CAS011
     C                   EXSR      *PSSR                                                      CAS011
     C                   ENDIF                                                                CAS011
     C                   ENDIF                                                                CAS011
                                                                                              CAS011
      ** Check if switchable feature CAS016 is installed                                      CAS019
                                                                                              CAS019
     C                   EVAL      CAS016 = 'N'                                               CAS019
                                                                                              CAS019
     C                   CALLB     'AOSARDR0'                                                 CAS019
     C                   PARM      *BLANKS       PRetCode                                     CAS019
     C                   PARM      '*VERIFY'     POption                                      CAS019
     C                   PARM      'CAS016'      PSard                                        CAS019
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS019
                                                                                              CAS019
     C                   IF        PRetCode = *BLANKS                                         CAS019
     C                   EVAL      CAS016 = 'Y'                                               CAS019
     C                   ELSE                                                                 CAS019
     C                   IF        PRetCode <> '*NRF   '                                      CAS019
     C     *LOCK         IN        LDA                                                        CAS019
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAS019
     C                   EVAL      DBKey = 'CAS016'                                           CAS019
     C                   EVAL      DBase = 43                                                 CAS019
     C                   OUT       LDA                                                        CAS019
     C                   EXSR      *PSSR                                                      CAS019
     C                   ENDIF                                                                CAS019
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
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALLB     'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRetCode                                     CSD083
     C                   PARM      '*VERIFY'     POption                                      CSD083
     C                   PARM      'CSD083'      PSard                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRetCode <> *BLANKS AND                                    CSD083
     C                             PRetCode <> '*NRF   '                                      CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBKey = 'CSD083'                                           CSD083
     C                   EVAL      DBase = 44                                                 CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRetCode = *BLANKS                                         CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
      ** Check if CLE134 - Past Due Call Loans                                                CLE134
                                                                                              CLE134
     C                   CALL      'AOSARDR0'                                                 CLE134
     C                   PARM      *BLANKS       @RTCD                                        CLE134
     C                   PARM      '*KEY    '    @OPTN                                        CLE134
     C                   PARM      'CLE134'      @SARD             6                          CLE134
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE134
                                                                                              CLE134
     C     @RTCD         IFEQ      *BLANKS                                                    CLE134
     C                   MOVEL     'Y'           CLE134                                       CLE134
     C                   ELSE                                                                 CLE134
     C                   MOVEL     'N'           CLE134            1                          CLE134
     C                   ENDIF                                                                CLE134
                                                                                              CLE141
      ** Check if Currency and Location Business Day Convention (CLE141) is On                CLE141
                                                                                              CLE141
     C                   CALL      'AOSARDR0'                                                 CLE141
     C                   PARM      *BLANKS       @RTCD                                        CLE141
     C                   PARM      '*KEY    '    @OPTN                                        CLE141
     C                   PARM      'CLE141'      @SARD                                        CLE141
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE141
                                                                                              CLE141
     C     @RTCD         IFEQ      *BLANKS                                                    CLE141
     C                   MOVEL     'Y'           CLE141                                       CLE141
     C                   ELSE                                                                 CLE141
     C                   MOVEL     'N'           CLE141            1                          CLE141
     C                   ENDIF                                                                CLE141
      *                                                                                     MD024342
     C                   MOVEL     'N'           MTHREAD           1                        MD024342
     C**********         MOVE      'MAPY'        WAPIC                             MD024342 MD025467
     C**********         MOVEL     'LOAMSZ1'     WFILN                             MD024342 MD025467
     C**********         IF        MPHAS = 'A' AND                                 MD024342 MD025467
     C                   IF        MPHAS <> 'C' AND                                         MD025467
     C                             MRFRNT <> 'LE000473'                                     MD024342
     C                   MOVEL     'Y'           MTHREAD                                    MD025467
     C*****KAPILST       CHAIN     SDAPDRL0                           99           MD024342 MD025467
     C******IN99         IFEQ      '0'                                             MD024342 MD025467
     C**********         MOVEL     A8MULT        MTHREAD                           MD024342 MD025467
     C**********         ENDIF                                                     MD024342 MD025467
     C                   ENDIF                                                              MD024342
                                                                                              CLE134
     C                   ENDSR
      ****************************************************************
      /EJECT
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
     O*LTRIX**** E            LTRIXH                                                        AR322732
     O**********             NORE                11P                                        AR322732
     O**********             RRNA                20P                                        AR322732
     O**********             NLAR                32P                                        AR322732
     O**********             P@NATN              40P                                        AR322732
      *
      ***  Output LTRIX detail record
      *
     O**********E            LTRIXD                                                         AR322732
     OLTRIX     EADD         LTRIXD                                                         AR322732
     O                                            2 'DA'
     O                       MRLNRF               8
     O                       MRVDAT              13
     O                       LASN                16
     O                       CHTP                17
     O                                           18 'N'
     O                                           19 'N'
     O                                           25 '00001'
     O                                           26 'N'
     O                       PRI1                27
     O                       RRNA                37P
     O                       P@NATN              40P
     O                                           43 '000'                                   AR322732
     O                                           44 ' '                                     AR322732
     O                                           45 ' '                                     AR322732
**  POWR -- USED IN CURRENCY CONVERSION(FACILITY)
0000001
0000010
0000100
0001000
0010000
0100000
1000000
** CWA -- Array for watch list fields                                                        BUG3760
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
** CPY@  **      Copyright statement
(c) Finastra International Limited 2002
