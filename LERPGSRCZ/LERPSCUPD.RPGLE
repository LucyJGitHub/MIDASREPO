     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBI *  OVRDBF FILE(LOAMD) TOFILE(LOAMS) SHARE(*NO)                  *
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Repayments Schedule - Database update')       *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LERPSCUPD - Midas LE Repayments Schedule - Database update   *
      *                                                               *
      *  Function:  This is the update function for the Repayment     *
      *             Schedule                                          *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *                                                               *
      *  Last Amend No. AR887295           Date 15Aug12               *
      *  Prev Amend No. CER050             Date 16Jun19               *
      *                 MD054035           Date 03Sep19               *
      *                 MD054317           Date 09Sep19               *      
      *                 MD047554           Date 11Oct17               *      
      *                 CLE071             Date 18Jul18               *
      *                 MD046248           Date 27Oct17               *
      *                 AR943686           Date 23Sep16               *
      *                 MD040830           Date 14Sep16               *
      *                 CLE154             Date 02Aug12               *
      *                 MD025467           Date 08May14               *
      *                 MD024342B          Date 08May14               *
      *                 MD024342           Date 08May14               *
      *                 MD023787           Date 29Apr14               *
      *                 MD021356           Date 24Jul13               *
      *                 AR868380           Date 11Jun13               *
      *                 264065             Date 11Jun13               *
      *                 AR806351           Date 24Apr13               *
      *                 AR1031116          Date 11Sep12               *
      *                 CLE134             Date 01Aug12               *
      *                 AR322732           Date 23Jul12               *
      *                 CLE148             Date 23Jul12               *
      *                 CSC054             Date 23Feb12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CLE139             Date 06Dec10               *
      *                 CLE064             Date 06Dec10               *
      *                 CLE073             Date 13May08               *
      *                 262328             Date 30Oct09               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG22113           Date 16Jan09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CAS019             Date 20Apr07               *
      *                 245227B            Date 17Apr07               *
      *                 245227A            Date 30Mar07               *
      *                 245177A            Date 19Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 243154             Date 23Oct06               *
      *                 240408             Date 14Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG8529            Date 28Sep05               *
      *                 BUG9225            Date 16Nov05               *
      *                 BUG8333            Date 29Aug05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE034             Date 05May03               *
      *                 CLE031             Date 03Feb03               *
      *                 CAS011             Date 16May05               *
      *                 CAP086             Date 08Jun05               *
      *                 CSC024             Date 07Feb05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3760            Date 01Aug04               *
      *                 BUG3112            Date 11Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 TDA070             Date 26Mar04               *
      *                 CRE020             Date 20Jan04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 11Oct02               *
      *                 CDE005             Date 23Sep02               *
      *                 CAP079  *CREATE    Date 11Jul02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR887295 - Reversal shadow posting is equal to full repay-   *
      *             ment amount instead of outstanding principal.     *
      *             Calculate total repayment amount for shadow       *
      *             posting on reverse or amend. (Child: AR887296)    *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD054035 - Prevent file locking of LEFEED                    *
      *  MD054317 - PDCL X not generated for freq based repayment     *            
      *  MD047554 - Create shadow postings of INTEREST and MATURITY   *
      *             with recalculated amount based on newly inserted, *
      *             amended, or reversed RE. Check the change of the  *
      *             autosettle indicator and call LE2041.             *      
      *  CLE071 - Value Dating of Rate Changes to Fees (Recompile)    *
      *  MD046248 - Finastra Rebranding                               *
      *  AR943686 - CLE031: System generating wrong projected move-   *
      *             ment. Populate value of SCCY to convert amount    *
      *             to account currency. (Child: AR943687)            *
      *           - Applied for MD-40690                              *
      *  MD040830 - Amending the repayment type of a loan event of a  *
      *             loan does not take effect after authorisation     *
      *  CLE154 - Loan Repayment Schedule Enhancement                 *
      *  MD025467 - API locking issues Redesign Approach              *
      *  MD024342B - API issue. Trailer file allocation problem.      *
      *  MD024342 - LOAMSZ1 allocation problem                        *
      *  MD023787 - Add parameter on AOOULAU0.                        *
      *  MD021356 - Impossible to input repayment schedule for parti- *
      *             cipation sold; pattern fix after AR1069948        *
      *  AR868380 - APISERVER on LCKW status. Return *RECLCK to       *
      *             calling program if file locking occurred on       *
      *             online position files. (Child: AR868381)          *
      *  264065 - No adjustment on projections when amendments were   *
      *           inserted against the loan. Call LE2041 to reverse   *
      *           previous movements and repost adjusted movements.   *
      *  AR806351 - Incorrect facility utilisation on OSFC. Prevent   *
      *             facility update of RE for interest and fee PDCL   *
      *             with FAMU = 'N'. (Child: AR806352)                *
      *  AR1031116 - LEC06A component failed due to FOOB              *
      *              (Child: AR1031118)                               *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  AR322732 - LEC0212A and APISERVER locks LTRIX file.          *
      *           - Prevent LTRIX RRN 1 from being locked.            *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSC054 - Period End Adjustments                              *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            CCR016: Settlement Allocation                      *
      *  CLE139 - Lending Fee Capitalisation (Recompile)              *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CLE073 - Calculated Loan Based Fees                          *
      *  262328 - Serious Midas error occurred. Increase size of @BIC *
      *           array from 150 to 900.                              *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  BUG22113 - Event amount does not appear in listview for      *
      *             Repayment Schedule of Loans with Repayment type 1 *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CAS019  - Upgrade of CAS016 to Midas Plus.                   *
      *  245227B - Avoid Unlocking of FCLTYFN when Autosettle         *
      *            indicator is set ON.
      *  245227A - Update Exposure and Available Amount when loan     *
      *           changed to autosettle and vice versa.               *
      *  245177A - Consider today's change in revolving credit        *
      *            indicator.                                         *
      *  243154 - FCOOB in LER140 due to incorrect LCHD               *
      *  240408 - Apply 207629 to Lending APIs                        *
      *           LELOAMUPD and LEMAPYUPD output the customer to      *
      *           CNUM. Ensure the same happens for Repayment         *
      *           Schedules. Screen RPCNUM can be Original Borrower.  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  BUG8529- If no settlements details for a RPSC are entered    *
      *           then default settlement details from related loan   *
      *  BUG9225 - Update LESTALPD with correct loan amendment        *
      *            sequence number.                                   *
      *  BUG8333- Shadow postings not generated for repayment type 3  *
      *  CLE106 - Syndication Manager                                 *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A.           *
      *  CLE031 - Lending Enhancements                                *
      *  CAS011 - EIR/AC Accounting Upgrade to MP1                    *
      *  CAP086 - Introduce Auto Authorization to the API's           *
      *           without it                                          *
      *  CSC024 - Open Month End                                      *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3760- Compliance Watch (CSD015) changes missing from the  *
      *           Lending APIs                                        *
      *  BUG3112- Missing Facility History Improvements (CLE023)      *
      *           change.                                             *
      *  CLE025 - Credit Lines                                        *
      *  TDA070 - RPSC (settlement default wrong on Input)            *
      *         - settlement method defaulted 00 instead              *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  CSC022 - Commitment Control Changes for Midas Plus           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Midas Plus API development                          *
      *  CDE005   Reservation ID                                      *
      *  CAP079 - Lending API enhancements - Repayments schedule      *
      *                                                               *
      *****************************************************************
      *
      ***  Files
      *    =====
      *
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
      ***  Midas LE Loans details file
     F                                     IGNORE(CLOANHHF:CLOANZ1F)
      *
     FLOAMD     IF   E           K DISK    INFSR(*PSSR)
      ***  Loan Amendments Retrieval Index
     F                                     RENAME(LOAMSDKF:LOAMSD)
     F                                     IGNORE(LOAMSDHF)
     F                                     IGNORE(LOAMSZ1F)
      *
     FLOAMSOM3  IF   E           K DISK    RENAME(LOAMSDKF:LOAMRP)                          AR887295
     F                                     PREFIX(RS)                                       AR887295
      ** Loan Amendment for Shadow Posting                                                  AR887295
      *                                                                                     AR887295
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
     FREADVCL2  UF   E           K DISK    COMMIT
     F                                     USROPN                                             CRE020
                                                                                              CRE020
      ** Compliance Watch Hit List File                                                      BUG3760
     FSDCWHTL1  IF   E           K DISK                                                      BUG3760
                                                                                              CAS011
      ** Effective Interest Rate Details                                                      CAS011
     FLEEIRDL5  UF   E           K DISK    INFSR(*PSSR)                                       CAS011
     F                                     COMMIT                                             CAS011
      *
     FLESTALLA  UF   E           K DISK    COMMIT                                            BUG9225
     F                                     PREFIX(XX)                                        BUG9225
      ** Midas LE Settlement Allocation by Parent PC Reference                               BUG9225
                                                                                              CAS019
      ** Effective Interest Rate Details                                                      CAS019
     FLEEIRDL9  UF   E           K DISK    INFSR(*PSSR)                                       CAS019
     F                                     COMMIT                                             CAS019
     F                                     RENAME(LEEIRDD0:LEEIRDD9)                          CAS019
      ** Effective Interest Rate Details                                                      CAS019
     FLEERAPL1  UF   E           K DISK    INFSR(*PSSR)                                       CAS019
     F                                     COMMIT                                             CAS019
      *                                                                                       CAS019
     FLEFCAML3  IF   E           K DISK                                                      245177A
     F                                     RENAME(LEFCAMPF:LEFCAMD3)                         245177A
     F***SDAPDRL0    E           K DISK    INFSR(*PSSR)                            MD024342 MD025467
      **********                                                                   MD024342 MD025467
      ***Midas*SD API Driving File                                                 MD024342 MD025467
     F***LOAMSZ1X    E             DISK    COMMIT                                 MD024342B MD025467
     F**********                           RENAME(LOAMSZ1F:LOAMSZ1FX)             MD024342B MD025467
      ***API:*Midas LE LOAN AMENDS TRAILER                                        MD024342B MD025467
      **********                                                                  MD024342B MD025467
      *****************************************************************
      ** +--------------------------------------+
      ** Î Automatically included D-specs       Î
      ** Î ==============================       Î
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
      ** Î End of automatically included D-specsÎ
      ** Î =====================================Î
      ** +--------------------------------------+
      *
      *****************************************************************
      *
      ** Data structure for data area commitment control                                      CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  ComitJobs              4    103A                                                      CSC022
                                                                                              CSC022
     D JobCmtCtlDS     S             10A   DIM(10)                                            CSC022
      * MIDAS SC Jobs Handling Commitment Control Data Structure                              CSC022
                                                                                              CSC022
      ** External DS for SAR details                                                          CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
     D LCD1          E                     EXTFLD(LCD)                                        CSC022
                                                                                              CSC022
     D TimeStamp       S               Z
      ***  Timestamp
      *
     D POWR            S              7  3 DIM(7) CTDATA PERRCD(1)              Ccy conversion
     D*@BIC*****       S              6  0 DIM(150)                             Internal CustsCSD027
     D*@BIC*****       S              6    DIM(150)                                    CSD027 262328
     D @BIC            S              6    DIM(900)                                           262328
      *
     D CYA             S              3    DIM(150)
      ***  Currencies array
      *                                                                                      BUG3760
     D CWA             S             25    DIM(26) CTDATA PERRCD(1)                          BUG3760
      ** Array used in Midas Compliance Watch                                                BUG3760
      *                                                                                      BUG3760
     D TND             S              1  0 DIM(150)
      *
     D LEVRpSc       E DS                  EXTNAME(LEVRPSCPD)
      ***  Externally DS for valid Repayment Schedule
      *
     D CRpScFilFmt   E DS                  EXTNAME(LOAMSDK)
      ***  Repayment schedule in file format
      *
     D OKFlagsDS     E DS                  EXTNAME(LEERPSCPD)
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
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                 BUG3760
     D QQDFAC2       E                     EXTFLD(QQDFAC)                                    BUG3760
      ** Customer Details                                                                    BUG3760
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
      ***  Shadow posting parameters
      *
     D LEALLO        E DS                  EXTNAME(LEALLO)
      ***  DS for calculating PC reference
      *
                                                                                             BUG3760
      ** SD data structure                                                                   BUG3760
     D SDSTAT        E DS                  EXTNAME(SDSTAT)                                   BUG3760
                                                                                             BUG3760
      ** 24X7 status data structure                                                          BUG3760
     D SC24X7        E DS                  EXTNAME(SC24X7)                                   BUG3760
                                                                                             BUG3760
      ** Watch List Fields Array                                                             BUG3760
     D WLF             S             35    DIM(12)                                           BUG3760
                                                                                             BUG3760
      ** Data Structure for Watch List Checking Details                                      BUG3760
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                 BUG3760
                                                                                             BUG3760
      ** Data structure for passing a parameter to synon screen                              BUG3760
      ** handling program.                                                                   BUG3760
     D SETLIB        E DS                  EXTNAME(SETLIAB)                                  BUG3760
     D QQRONS2       E                     EXTFLD(QQRONS)                                    BUG3760
     D QQPONS2       E                     EXTFLD(QQPONS)                                    BUG3760
                                                                                             BUG3760
      ** Watch List Transaction Details File                                                 BUG3760
     D CWLCDS        E DS                  EXTNAME(SDWLTOPD)                                 BUG3760
                                                                                             BUG3760
      ** Compliance Watch Configuration Data File                                            BUG3760
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                 BUG3760
                                                                                             BUG3760
      ** Compliance Engine Free Format String Parameter.                                     BUG3760
     D PARMDS          DS          9999                                                      BUG3760
                                                                                             BUG3760
     D MPHAS           DS             1                                                     MD021423
      ** Data Structure for MPHAS Dataarea                                                  MD021423
      *                                                                                     MD021423
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
     D  SHTAMT                66     72P 0                                                   BUG8333
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
     D  Z#ADTE              1025   1280
     D**SHSCCY***           1058   1060                                                       CLE031
     D**SHICCY***           1061   1063                                                       CLE031
     D  SHSCCY              1061   1063                                                       CLE031
     D  SHICCY              1064   1066                                                       CLE031
     D  SHREXR              1090   1096P 8                                                    CLE031
     D  SHREXI              1097   1097                                                       CLE031
     D  SHPSCY              1098   1100                                                       CLE031
     D  SHPEXR              1101   1107P 8                                                    CLE031
     D  SHPEXI              1108   1108                                                       CLE031
     D  SHSTAL              1109   1109                                                      BUG9225
      *
     D                 DS
      ***  Last change data - LOAMS
     D  WLCD                   1      5  0
     D  WCHTP                  6      6
     D  WTNLU                  7     11  0
     D  WLSTC                  1     11
      *
     D  OldStsDS       DS
      ***  Old settlement details
      *
     D  OSETP                  1      2  0
     D***OOSAC**                3     14                                                      CGL029
     D***OTSEN**               15     24                                                      CGL029
     D***OFACO**               25     34                                                      CGL029
     D***OLDSET*                1     34                                                      CGL029
     D***OSPI1**               35     64                                                      CGL029
     D***OSPI2**               65     94                                                      CGL029
     D***OSPI3**               95    124                                                      CGL029
     D***OLDSTS*                1    124                                                      CGL029
     D  OOSAC                  3     20                                                       CGL029
     D  OTSEN                 21     30                                                       CGL029
     D  OFACO                 31     40                                                       CGL029
     D  OLDSET                 1     40                                                       CGL029
     D  OSPI1                 41     70                                                       CGL029
     D  OSPI2                 71    100                                                       CGL029
     D  OSPI3                101    130                                                       CGL029
     D  OLDSTS                 1    130                                                       CGL029
      *
     D  NewStsDS       DS
      ***  New settlement details
      *
     D  WSETP                  1      2
     D***WOSAC**                3     14                                                      CGL029
     D***WTSEN**               15     24                                                      CGL029
     D***WFACO**               25     34                                                      CGL029
     D***NEWSET*                1     34                                                      CGL029
     D***SSPI1**               35     64                                                      CGL029
     D***SSPI2**               65     94                                                      CGL029
     D***SSPI3**               95    124                                                      CGL029
     D***NEWSTS*                1    124                                                      CGL029
     D  WOSAC                  3     20                                                       CGL029
     D  WTSEN                 21     30                                                       CGL029
     D  WFACO                 31     40                                                       CGL029
     D  NEWSET                 1     40                                                       CGL029
     D  SSPI1                 41     70                                                       CGL029
     D  SSPI2                 71    100                                                       CGL029
     D  SSPI3                101    130                                                       CGL029
     D  NEWSTS                 1    130                                                       CGL029
      *
     D  PasDtaDS       DS           256
      ***  New settlement details
      *
     D  WSCCY                  1      3
     D  WOBBR                  4      6
     D  WOSBR                  7      9
     D  SAVLC                 10     20
      *
     D FLDTX           DS
      ***  Data Structure for PF/LTRIX
      *
     D  TXSTS            *STATUS
      *
     D Ix              S              3P 0
      ***  Index for arrays of of error message ids etc
      *
     D OTIST           S             40                                                       CGL029
     D @KEYC           S             10                                                       CGL029
     D @ACCD           S             10                                                       CGL029
     D T#TREF          S             26                                                       CGL029
                                                                                              TDA070
      ** Parameter for LERPSCRTV to retrive Extended settlement intruction                    TDA070
     D*PRcvParm********S             91                                              TDA070  BUG8529
     D***PRcvParm        S             92                                            BUG8529 CSF011A
     D***PPayParm        S            594                                            BUG8529 CSF011A
     D PRcvParm        S            335                                                      CSF011A
     D PPayParm        S           1045                                                      CSF011A
                                                                                              CGL029
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
      ** Data structure of rundates
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
      ** Parameters for Access Objects                                                        CSC022
     D PRtCd           S              7A                                                      CSC022
     D POptn           S              7A                                                      CSC022
     D PSarD           S              6A                                                      CSC022
      ** Define workfields for Commitment Control Changes for Midas Plus                      CSC022
     D CSC022          S              1A                                                      CSC022
     D WSkpCom         S              1A                                                      CSC022
     D WPos            S              2S 0                                                    CSC022
                                                                                              CSC022
      *                                                                                       CRE020
      ** Define fields used in CRE020                                                         CRE020
     D CRE020          S              1A                                                      CRE020
     D KRefNo          S             30A                                                      CRE020
     D KSeqNo          S              3A                                                      CRE020
     D KPrgMn          S             10A   INZ('LERPSCUPD ')                                  CRE020
     D PSysVal01       S             20A   INZ('RepaymentSchedules  ')                        CRE020
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
      *
     D CLE025          S              1                                                       CLE025
     D CAS009          S              1                                                       CAS011
     D CAS016          S              1                                                       CAS019
                                                                                             BUG3760
      ** Switchable feature - Watch List Checking                                            BUG3760
     D CSD015          S              1A                                                     BUG3760
                                                                                             BUG3760
     D CSC011          S              1                                                      BUG3760
     D CCF001          S              1                                                      BUG3760
     D CLE106          S              1                                                       CLE106
     D CLE031          S              1                                                       CLE031
     D CLE034          S              1A                                                      CLE034
      *
     D*POMESys01       S             20A   INZ('OMEIndicator')                         CSC024 CSC054
     D PPEASys01       S             20A   INZ('PEAIndicator')                                CSC054
     D PRetCode        S              7A                                                      CSC024
     D P@OP01          S             20A                                                      CSC024
     D P@VL01          S            200A                                                      CSC024
     D P@OP02          S             20A                                                      CSC024
     D P@VL02          S            200A                                                      CSC024
     D P@OP03          S             20A                                                      CSC024
     D P@VL03          S            200A                                                      CSC024
     D P@OP04          S             20A                                                      CSC024
     D P@VL04          S            200A                                                      CSC024
     D P@OP05          S             20A                                                      CSC024
     D P@VL05          S            200A                                                      CSC024
     D P@OP06          S             20A                                                      CSC024
     D P@VL06          S            200A                                                      CSC024
     D P@OP07          S             20A                                                      CSC024
     D P@VL07          S            200A                                                      CSC024
     D P@OP08          S             20A                                                      CSC024
     D P@VL08          S            200A                                                      CSC024
     D P@OP09          S             20A                                                      CSC024
     D P@VL09          S            200A                                                      CSC024
     D P@OP10          S             20A                                                      CSC024
     D P@VL10          S            200A                                                      CSC024
                                                                                              CSC024
     D*CSC024***       S              1A                                               CSC024 CSC054
     D*WOMEInd**       S              1A                                               CSC024 CSC054
     D CSC054          S              1A                                                      CSC054
     D WPEAInd         S              1A                                                      CSC054
                                                                                              CSC024
     D PUPDT           S              1A                                                      CLE148
     D PCNEXT          S              8A                                                      CLE148
     D PRI1            S              1S 0                                                  AR322732
     D WUpdExpo        S              1A                                                    AR806351
     D W#FRNT          S              8A                                                   MD0243423
      *                                                                                       CLE148
      *                                                                                     MD021356
     D WrkLnDetails  E DS                  EXTNAME(CLOANCL) Prefix(CL_)                     MD021356
      *                                                                                     MD021356
      ** Loan Details                                                                       MD021356
      *                                                                                     MD021356
      /EJECT
      *
      *    =============
      ***  Rename fields
      *    =============
      *
     ICLOANCLF
      ** Rename fields for Loans file - A
      *
     I              RECI                        RECIC
     I              CNUM                        CNUMC
     I              LTYP                        LTYPC
     I              SUTP                        SUTPC
     I              PTYP                        PTYPC
     I              CCY                         LCCYC
     I              MDAT                        MDATC
     I              VDAT                        VDATC
     I              FCUS                        FCUSC
     I              FTYP                        FTYPC
     I              FSEQ                        FSEQC
     I              REPT                        REPTC
     I              WTIN                        WTINC
     I              BRCA                        BRCAC
     I              LSWC                        LSWCC
     I              LSWS                        LSWSC
     I              FCLB                        FCLBC
     I              AUTO                        AUTOC
     I              LCD                         LCDC
     I              CHTP                        CHTPC
     I              TNLU                        TNLUC
     I              CLAS                        CLASC                                         CLE042
      *
      ** Extended settlement details
      *
     I              RSTM                        RSTMC
     I              RONS                        RONSC
     I              RIBN                        RIBNC
     I              RIBA                        RIBAC
     I              ROBN                        ROBNC
     I              ROCN                        ROCNC
     I              PSTM                        PSTMC
     I              PONS                        PONSC
     I              PIBN                        PIBNC
     I              PIBA                        PIBAC
     I              POBN                        POBNC
     I              POCN                        POCNC
     I              RCRN                        RCRNC
     I              RCRA                        RCRAC
     I              RVNO                        RVNOC
     I              AWBN                        AWBNC
     I              AWBA                        AWBAC
     I              BENN                        BENNC
     I              BENA                        BENAC
     I              DTP1                        DTP1C
     I              DTP2                        DTP2C
     I              DTP3                        DTP3C
     I              DTP4                        DTP4C
     I              DCHG                        DCHGC
     I              BTB1                        BTB1C
     I              BTB2                        BTB2C
     I              BTB3                        BTB3C
     I              BTB4                        BTB4C
     I              BTB5                        BTB5C
     I              BTB6                        BTB6C
     I              CVMR                        CVMRC
     I              OMDB                        OMDBC
     I              OSDB                        OSDBC
     I              FACO                        FACOC
     I              SCCY                        SCCYC
     I              ICCY                        ICCYC
     I              REXR                        REXRC                                         CLE031
     I              REXI                        REXIC                                         CLE031
     I              PSCY                        PSCYC                                         CLE031
     I              PEXR                        PEXRC                                         CLE031
     I              PEXI                        PEXIC                                         CLE031
     I              INTC                        INTCC                                         CLE154
      *
     ICLOANCKF
      ** Rename fields for Loans file - B
      *
     I              NLRA                        NLRAK
     I              SPI1                        SPI1K
     I              SPI2                        SPI2K
     I              SPI3                        SPI3K
     I              ECIN                        ECINK
      *
     ILOAMSD
      ** Rename fields for Loan Amendments Retrieval index
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
      *
      ** Extended settlement details
      *
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
     ILOAMSDKF
     I              PCRF                        PCRFK
     I              PCOB                        PCOBK
     ILEFCAMD3                                                                               245177A
      ** Rename fields                                                                       245177A
     I              RECI                        RECIF                                        245177A
     I              BRCA                        BRCAF                                        245177A
     I              CNUM                        CNUMF                                        245177A
     I              FACT                        FACTF                                        245177A
     I              FCNO                        FCNOF                                        245177A
     I              RVCR                        RVCRF                                        245177A
     I              ASTS                        ASTSF                                        245177A
     I              IUSR                        IUSRF                                        245177A
     I              AUSR                        AUSRF                                        245177A
     I              XUSR                        XUSRF                                        245177A
     I              CHTP                        CHTPF                                        245177A
     I              ORED                        OREDF                                        245177A
      *
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
      *
      ***Loan*transactions*index*file*-*Detail*record******************                     AR322732
      *
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
      *
      *****Loans*transactions*index*file*-*Catchall********************                     AR322732
      *
     I**********NS                                                                          AR322732
     I**********                        1    1  RECI                                        AR322732
      *
     IFCLTYFMF
      ***  Rename fields for Facility file
      *
     I              CNUM                        CNUMF
     I              BRCA                        BRCAF
     I              LCD                         LCDF
     I              CHTP                        CHTPF
     I              TNLU                        TNLUF
     I              RCSI                        RCSIF                           122685
      *
      ***  Rename extended settlement fields
      *
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
     I              SCCY                        SCCYC
     I              ICCY                        ICCYC
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
      *
      /EJECT
      *****************************************************************
      * MAIN - Main body                                              *
      *****************************************************************
 
      ** Check whether user is a web browser user, if so overwrite                            CAP084
     C                   CALL      'SFC000026'                                                CAP084
     C                   PARM      *BLANKS       USER             10                          CAP084
      *                                                                                       CAP084
     C                   IF        USER <> *BLANKS                                            CAP084
     C                   EVAL      PSUSER = USER                                              CAP084
     C                   ENDIF                                                                CAP084
      *
      ***  Ensure the record has not been updated by another workstation
      ***  - if so, bypass updating and return to calling program.
      *
     C                   EXSR      CHKOTHUPD
      *
     C                   IF        @@RTCD <> *BLANKS
     C                   GOTO      EXIT
     C                   ENDIF
      *
      ***  Process Insert, Amend, authorise or reverse
      *
     C                   EXSR      SROUTPUT
      *                                                                                       CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
      *                                                                                       CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
      *
      ***  Exit From Program
      *
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
      ***  Retrieve current repayment schedule
      *
     C                   MOVE      RPLNRF        MidasLNRF         6
      *
     C                   MOVE      RPVDAT        ZDateNum
     C                   MOVE      BJDFIN        ZDateFmtInd
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDateNum          5 0
     C                   PARM                    ZDateFmtInd       1
     C                   PARM                    ZDateFmt6         6 0
     C                   PARM                    ZDateFmt7         7
      *
     C                   MOVE      ZDateFmt6     MidasVDAT         6
      *
     C                   MOVE      RPLASN        MidasLASN         3
      *
      ***  Determine whether program is running interactively or in batch
      ***   ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @Return           6
     C                   PARM                    @Type             1
      *
      ***  Allow access to record by Front-Office ID when in Repair
      ***  mode for inserts . Set  *RTV module  parameter @@MODE  to   *FRONT
      ***  if the pgm is:  a) running in Interactive mode - @Type= 1   ~~~~~~
      ***                  b) action code is Insert - 'I'
      ***                  c) Front-Office Id is NOT Blank
      *
     C                   IF        @Type = '1' AND
     C                             RPCHTP = 'I' AND
     C                             RPFRNT <> *BLANKS
      *
     C                   EVAL      @@MODE = '*FRONT'
      *
     C                   ELSE
      *
      ***  Otherwise, if running in batch use Front-Office ID
      ***             (if insert)
      ***             else, use Midas repayment schedule key
      *
     C                   IF        @Type = '0' AND
     C                             RPCHTP = 'I'
     C                   EVAL      @@MODE = '*FRONT'
     C                   ELSE
     C                   EVAL      @@MODE = *BLANKS
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   CALLB     'LERPSCRTV'
      *
      ***  Inputs
      *
      ***  Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ***  Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    @@MODE            6
      *
      ***  Response mode
     C**********         PARM      ' '           @@RSMD            1                          CAP084
     C                   PARM      'S'           @@RSMD            1                          CAP084
      *
      ***  Action Code
     C                   PARM      RPCHTP        ACTN              1
      *
      ***  Front Office Transaction ID
     C                   PARM      RPFRNT        FOTRID           20
      *
      ***  Midas loan Number
     C                   PARM                    MidasLNRF         6
      *
      ***  Midas sequence
     C                   PARM                    MidasLASN         3
      *
      ***  Midas value date
     C                   PARM                    MidasVDAT         6
      *
      ***  Outputs
      *
      ***  (Current) repayment schedule in file format
      *
     C                   PARM                    CRpScFilFmt
      *
      ***  OK - Action code
     C                   PARM      *BLANK        DDACTNOK
      *
      ***  OK - Loan Number
     C                   PARM                    DDLNRFOK
      *
      ***  OK - Sequence no.
     C                   PARM                    DDSEQNOK
      *
      ***  OK - Value date
     C                   PARM                    DDVDATOK
      *
      ***  Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANK        FldNameArr
     C                   PARM      *BLANK        MsgIdArr
     C                   PARM      *BLANK        MsgDtaArr
      *
      ***  Array index (3P0) from/to caller
     C                   PARM      *ZERO         Ix                3 0
     C                   PARM                    PRcvParm                                     TDA070
     C                   PARM                    PPayParm                                    BUG8529
     C                   PARM                    WrkLnDetails                               MD021356
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
     C                   IF        (TMST <> RPTMES) AND (RPCHTP <> 'I')
     C                   EVAL      @@RTCD = '*RECUPD'
     C                   ENDIF
      *
      ***  Batch mode:
      *
     C                   ELSE
     C                   IF        DDACTNOK = 'N' OR
     C                             DDLNRFOK = 'N' OR
     C                             DDSEQNOK = 'N' OR
     C                             DDVDATOK = 'N'
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
      * SROUTPUT - Process Insert, Amend, authorise or reverse       *
      ****************************************************************
     C     SROUTPUT      BEGSR
      *
      ***  Access loan details
      *
     C                   MOVE      RPLNRF        WCLOAN
     C                   MOVE      'A'           WCRCDT
     C     WKLON         CHAIN(N)  CLOAN                              99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVE      RPLNRF        DBKEY                          *************
     C                   MOVEL     'CLOANCL '    DBFILE                         * DBERR 001 *
     C                   Z-ADD     1             DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Confirmation sequence number
      *
     C     RPCHTP        IFNE      'E'
     C                   MOVE      LSWCC         LSWCA             3
     C     LSWCA         IFEQ      *BLANK
     C                   Z-ADD     0             WLSWC             3 0
     C                   ELSE
     C                   Z-ADD     LSWCC         WLSWC             3 0
     C                   ENDIF
      *
     C                   MOVE      LSWSC         LSWSA             3
     C     LSWSA         IFEQ      *BLANK
     C                   Z-ADD     0             WLSWS             3 0
     C                   ELSE
     C                   Z-ADD     LSWSC         WLSWS             3 0
     C                   ENDIF
     C                   ENDIF
      *
      ***  Build key for chain to LOAMS
      *
     C**********         Z-ADD     RPLNRF        WLLOAN                                       CLE148
     C                   MOVEL     RPLNRF        WLLOAN                                       CLE148
     C                   Z-ADD     RPVDAT        WLVDAT
     C                   Z-ADD     RPLASN        WLLASN
      *                                                                                       CRE020
     C                   MOVE      RPCHTP        WSCHTP                                       CRE020
      *
      ***  Get next sequence number if Insert
      *
      *
     C     RPCHTP        IFEQ      'I'
                                                                                              CSC024
      ***Bypass*generate*Amendment*Seq.*No.*for*Insert*if*CSC024*is                    CSC024 CSC054
      ***switched*on*and*running*on*OME*system.                                        CSC024 CSC054
      ** Bypass generate Amendment Seq. No. for Insert if CSC054 is                           CSC054
      ** switched on and running on PEA system.                                               CSC054
                                                                                              CSC024
     C*****CSC024        IFNE      'Y'                                                 CSC024 CSC054
     C*****WOMEInd       ORNE      'Y'                                                 CSC024 CSC054
     C     CSC054        IFNE      'Y'                                                        CSC054
     C     WPEAInd       ORNE      'Y'                                                        CSC054
     C     WLLASN        OREQ      *ZERO                                                      CSC024
                                                                                              CSC024
     C                   EXSR      SRNSEQ
                                                                                              CSC024
     C                   ELSE                                                                 CSC024
  334C                   EVAL      WLASNX = WLLASN                                            CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C                   ENDIF
      *
      ***  Access record for any updates to this record
      *
     C     WKLAM         CHAIN     LOAMS                              99
      *
     C                   Z-ADD     LCD           WLCD
     C                   MOVE      CHTP          WCHTP
     C                   Z-ADD     TNLU          WTNLU
     C                   MOVE      WLSTC         NEWLC            11
      *
      ***  If:  Record not found and action is A, X or D, or found and
      *
     C     *IN99         IFEQ      *ON
     C     RPCHTP        ANDNE     'I'
      *
      ***  Action is Insert, or
      *
     C******IN99*        OREQ      *OFF                                                       CSC024
     C*****RPCHTP        ANDEQ     'I'                                                        CSC024
      *
      ***  Change details have been altered, or
      *
     C     NEWLC         ORNE      SAVLC
     C     RPCHTP        ANDNE     'I'
      *
      ***  Record already reversed
      *
     C     *IN99         OREQ      *OFF
     C     RECI          ANDNE     'D'
     C                   MOVEL     '*RECUPD   '  @@RTCD
     C                   MOVE      'N'           DDLNRFOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDLNRF      'FldNameArr(Ix)
     C                   MOVEL     'LES9999'     MsgIdArr(Ix)
     C                   MOVE      'N'           DDSEQNOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDSEQN      'FldNameArr(Ix)
     C                   MOVEL     *BLANKS       MsgIdArr(Ix)
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDVDAT      'FldNameArr(Ix)
     C                   MOVEL     *BLANKS       MsgIdArr(Ix)
     C                   GOTO      ENDOUTPUT
     C                   ENDIF
      *                                                                                       CSC024
      ***  Action is Insert, but record found.                                                CSC024
      *                                                                                       CSC024
     C                   IF        *In99 = *Off And RPCHTP = 'I'                              CSC024
     C                   EVAL      Ix   += 1                                                  CSC024
     C                   EVAL      FldNameArr(Ix) = 'DDLNRF    '                              CSC024
     C                   EVAL      MsgIdArr(Ix)   = 'LES0612'                                 CSC024
     C                   GOTO      ENDOUTPUT                                                  CSC024
     C                   ENDIF                                                                CSC024
      *
      ***  No errors, continue update
      *
      ***  Obtain last transaction number
      *
     C                   CALLB     'ZTNLU1'
     C                   PARM      *BLANK        P@RTCD           10
     C                   PARM                    P@NATN            5 0
     C                   Z-ADD     P@NATN        TNLU
      *
      ***  Setup fields for output to LOAMS
      *
     C                   EXSR      SRSETUP
      *
      ***  If SAR CEU020 is installed and loan amendment is allowed to ha
      ***  ve a loan amendment currency of Euro
      *
     C     CEU020        IFEQ      'Y'
     C     ECIN          ANDEQ     ' '
     C                   MOVE      'N'           ECIN
     C                   ENDIF
      *
      ***  Generate time stamp value
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
     C                   EVAL      TMST=TimeStamp
                                                                                              CAP086
      ** Automatic Authorisation flag                                                         CAP086
     C                   EVAL      AUTH = RPAUTH                                              CAP086
                                                                                              CAP086
      *                                                                                      BUG3760
      ** Call  SRWTCH if watch list checking is apllied.                                     BUG3760
      *                                                                                      BUG3760
     C                   MOVEL     'N'           WNBLNK            1                         BUG3760
                                                                                             BUG3760
     C                   IF        CSD015 = 'Y'  AND  W1EWLC = 'Y'                           BUG3760
                                                                                             BUG3760
     C                   IF        RPCHTP = 'I'                                              BUG3760
     C                   EXSR      SRBLDA                                                    BUG3760
                                                                                             BUG3760
     C                   IF        WNBLNK = 'Y'                                              BUG3760
                                                                                             BUG3760
      ** If 24x7 is not installed or the support system is off                               BUG3760
                                                                                             BUG3760
     C                   IF        CSC011 <> 'Y'                                             BUG3760
     C                             OR S1MAIN = LIBR                                          BUG3760
     C                   EXSR      SRWTCH                                                    BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        RPCHTP = 'A'                                              BUG3760
                                                                                             BUG3760
     C                   MOVEL     *BLANKS       KFUNT                                       BUG3760
     C                   MOVEL     *BLANKS       KIDEN                                       BUG3760
     C                   MOVEL     *BLANKS       KBRCH                                       BUG3760
     C                   MOVEL     *BLANKS       WKIDEN                                      BUG3760
     C                   MOVEL     *BLANKS       WLNRF                                       BUG3760
     C                   MOVEL     *BLANKS       WVDAT                                       BUG3760
     C                   MOVEL     *BLANKS       WLASN                                       BUG3760
     C                   MOVE      *OFF          *IN39                                       BUG3760
                                                                                             BUG3760
     C                   MOVE      LNRF          WLNRF                                       BUG3760
     C                   MOVE      VDAT          WVDAT                                       BUG3760
     C                   MOVE      LASN          WLASN                                       BUG3760
     C     WLNRF         CAT       WVDAT:0       WKIDEN           40                         BUG3760
     C                   CAT       WLASN:0       WKIDEN                                      BUG3760
                                                                                             BUG3760
      ** If 24x7 is not installed or the support system is off.                              BUG3760
                                                                                             BUG3760
     C                   IF        CSC011 <> 'Y'                                             BUG3760
     C                             OR S1MAIN = LIBR                                          BUG3760
                                                                                             BUG3760
     C                   MOVEL     'LOAMSDK'     KFUNT                                       BUG3760
     C                   MOVEL     WKIDEN        KIDEN                                       BUG3760
     C                   MOVEL     BRCA          KBRCH                                       BUG3760
     C     CWHTKY        CHAIN     SDCWHTL1                           39                     BUG3760
     C                   IF        *IN39 = *OFF                                              BUG3760
     C                             AND W3UNCF = 'Y'                                          BUG3760
     C                   EXSR      SRBLDA                                                    BUG3760
     C                   EXSR      SRWTCH                                                    BUG3760
     C                   ELSE                                                                BUG3760
                                                                                             BUG3760
     C                   IF        WDIFF = 'Y'                                               BUG3760
     C                   EXSR      SRWTCH                                                    BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                       CAS011
      ** If CAS009 is On, update LEEIRDPD if Insert or Reverse                                CAS011
      ** for all records affected by the value date of the                                    CAS011
      ** manual repayment record.                                                             CAS011
      *                                                                                       CAS011
     C     CAS009        IFEQ      'Y'                                                        CAS011
     C**********         MOVE      LNRF          WLOAN             6 0                 CAS011 CLE148
     C                   MOVE      LNRF          WLOAN             6                          CLE148
      *                                                                                       CAS019
      ** If CAS016 is on, use LEEIRDL9 for EIR details can have multiple records              CAS019
      *                                                                                       CAS019
     C                   IF        CAS016 = 'Y'                                               CAS019
     C     WLOAN         CHAIN     LEEIRDL9                           20                      CAS019
     C                   ELSE                                                                 CAS019
     C     WLOAN         CHAIN     LEEIRDL5                           20                      CAS011
     C                   ENDIF                                                                CAS019
      *                                                                                       CAS019
     C     *IN20         IFEQ      '0'                                                        CAS011
      *                                                                                       CAS011
     C     RPCHTP        IFEQ      'I'                                                        CAS011
     C     RPCHTP        OREQ      'R'                                                        CAS011
     C     VDAT          IFLE      EIENDT                                                     CAS011
     C                   MOVE      'Y'           EIRCAL                                       CAS011
      *                                                                                       CAS019
     C                   IF        CAS016 = 'Y'                                               CAS019
     C                   MOVE      'Y'           EIADJP                                       CAS019
     C                   UPDATE    LEEIRDD9                                                   CAS019
     C                   ELSE                                                                 CAS019
     C                   UPDATE    LEEIRDD0                                                   CAS011
     C                   ENDIF                                                                CAS019
      *                                                                                       CAS019
     C                   ENDIF                                                                CAS011
     C                   ENDIF                                                                CAS011
      *                                                                                       CAS011
     C                   ENDIF                                                                CAS011
      *                                                                                       CAS011
      ** Search all fees amortised separately                                                 CAS019
     C                   IF        CAS016 = 'Y'                                               CAS019
     C     WLOAN         CHAIN     LEERAPL1                           20                      CAS019
     C                   DOW       *IN20 = '0'                                                CAS019
      *                                                                                       CAS019
     C     RPCHTP        IFEQ      'I'                                                        CAS019
     C     RPCHTP        OREQ      'R'                                                        CAS019
     C     VDAT          IFLE      EIENDT                                                     CAS019
     C                   MOVE      'Y'           EIRCAL                                       CAS019
     C                   UPDATE    LEERAPD0                                                   CAS019
     C                   ENDIF                                                                CAS019
     C                   ENDIF                                                                CAS019
      *                                                                                       CAS019
     C     WLOAN         READE     LEERAPL1                               20                  CAS019
     C                   ENDDO                                                                CAS019
      *                                                                                       CAS019
     C                   ENDIF                                                                CAS019
     C                   ENDIF                                                                CAS011
      *
      *
      ***  Update Loan Amendments Detail
      *
     C     RPCHTP        IFEQ      'I'
     C                   WRITE     LOAMSDKF
     C                   ELSE
     C                   UPDATE    LOAMSDKF
     C                   ENDIF
      *
      ***  Other Updates
      *
      ***  Shadow posting
      *
     C     RPPCRF        CHAIN     LESTALLA                           99                     BUG9225
     C     *IN99         DOWEQ     *OFF                                                      BUG9225
     C                   Z-ADD     RPLASN        XXLASQ                                      BUG9225
     C                   EVAL      XXPTRF = PCRFK                                            CSF011A
     C                   UPDATE    LESTALD0                                                  BUG9225
     C     RPPCRF        READE     LESTALLA                               99                 BUG9225
     C                   ENDDO                                                               BUG9225
     C                   EVAL      RPPCRF = PCRFK                                            CSF011A
                                                                                             BUG9225
      *
      ***  Update on shadow files should only be done if not a Risk loan
      *
     C     PTYP          IFNE      70
     C     PTYP          ANDNE     71
     C     PTYP          ANDNE     72
     C     RPCHTP        IFNE      'X'
     C     RPCHTP        IFNE      'R'
     C                   MOVE      NEWSET        OTIST
     C                   ENDIF
     C                   EXSR      SRSHAD
     C                   MOVE      Z#ADTA        Z#ADT1
     C                   MOVE      Z#ADTB        Z#ADT2
      *
     C     CEU004        IFEQ      'Y'
     C     CLE031        OREQ      'Y'                                                        CLE031
     C                   MOVE      Z#ADTE        Z#ADT5
     C                   ENDIF
      *
     C                   EXSR      SRUSHD
     C                   ENDIF
     C                   ENDIF
     C/COPY WNCPYSRC,LEH01196
      *
      ***  Write to LTRIX if S01465 feature is switched on
      *
     C     S01465        IFEQ      'Y'
     C                   EXSR      SRUPLX
     C                   ENDIF
      *
      ***  Update Facility file
      *
     C     RPCHTP        IFNE      'X'
     C                   EXSR      SRUPFC
     C                   ENDIF
      *
      ***  If CLE009 is installed, update fees file
      *
     C     CLE009        IFEQ      'Y'
     C                   EXSR      SRFEES
     C                   ENDIF
      *
      ***  Update Loan Amendments Trailer
      *
     C                   EXSR      SRUPTR
      *
      ***  Data export for CCRM - Limits
      *
     C     CDE001        IFEQ      'Y'
     C     Ix            ANDEQ     *ZERO
     C     @RTCD         ANDEQ     *ZERO
     C                   MOVE      RPLNRF        T#TREF
     C                   CALL      'DEWTTRIG'
     C**********         PARM                    T#TREF           20                          CGL029
     C                   PARM                    T#TREF                                       CGL029
     C                   PARM      'LOAN'        T#TCAT            4
     C                   PARM                    ResrvId          10                          CDE005
     C                   ENDIF
      *
      ***  Commit changes only on non-Play mode and no errors on the
      ***  update proessing
      *
     C     @Type         IFNE      '0'
     C     Ix            ANDEQ     *ZERO
     C     @RTCD         ANDEQ     *BLANKS
     C                   IF        CSC022 = 'N' OR                                            CSC022
     C                             CSC022 = 'Y' AND WSkpCom = 'N'                             CSC022
     C                   COMMIT
     C                   ENDIF                                                                CSC022
     C                   ENDIF
      *
     C     ENDOUTPUT     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRNSEQ  -  Get next amendment sequence number                 *
      *****************************************************************
     C     SRNSEQ        BEGSR
      *
      ***  Find next available sequence no. for Insert
      *
     C                   Z-ADD     0             WLASNX            3 0
     C**********         Z-ADD     RPLNRF        WLLOAN                                       CLE148
     C                   MOVEL     RPLNRF        WLLOAN                                       CLE148
     C                   Z-ADD     RPVDAT        WLVDAT
     C                   Z-ADD     0             WLLASN
     C     WKLAM         SETLL     LOAMD
      *
     C                   READ      LOAMD                                  99
      *
     C     *IN99         DOWEQ     *OFF
     C     WLLOAN        IFNE      LNRFA
     C     WLVDAT        ORNE      VDATA
     C                   LEAVE
     C                   ENDIF
     C                   Z-ADD     LASNA         WLASNX
     C                   READ      LOAMD                                  99
     C                   ENDDO
      *
     C                   ADD       1             WLASNX
     C                   Z-ADD     WLASNX        WLLASN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSETUP - Setup fields for update                             *
      *****************************************************************
     C     SRSETUP       BEGSR
      *
      ***  Before-status for shadow posting
      *
     C     RPCHTP        IFEQ      'I'
     C                   CLEAR                   Z#BSTS
     C                   ELSE
      *
      ***  Set up old settlement details
     C                   MOVE      OLDSET        OTIST
      *
     C**********         MOVE      OLDSET        OTIST            34                          CGL029
     C                   MOVE      OLDSET        OTIST                                        CGL029
     C                   EXSR      SRSHAD
     C                   MOVE      Z#ADTA        Z#BDT1
     C                   MOVE      Z#ADTB        Z#BDT2
      *
     C     CEU004        IFEQ      'Y'
     C     CLE031        OREQ      'Y'                                                        CLE031
     C                   MOVE      Z#ADTE        Z#BDT5
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                                     MD047554
      ** Store inital value of autosettle indicator during amendment                        MD047554
      *                                                                                     MD047554
     C                   MOVE      *BLANKS       OAUTO                                      MD047554
     C     RPCHTP        IFEQ      'A'                                                      MD047554
     C                   MOVE      AUTO          OAUTO             1                        MD047554
     C                   ENDIF                                                              MD047554
      *
      ***  Set up the following fields for action Insert
      *
     C     RPCHTP        IFEQ      'I'
     C                   CLEAR                   LOAMSDKF
     C                   MOVE      RPLNRF        LNRF
     C                   MOVE      RPCCY         CCY
     C                   Z-ADD     RPVDAT        VDAT
     C                   MOVE      WLASNX        LASN
     C                   MOVE      WLASNX        RPLASN
     C                   MOVE      '2'           MRIN
     C                   MOVE      LTYPC         LTYP
     C                   MOVE      SUTPC         SUTP
     C                   MOVE      CLASC         CLAS                                         CLE042
     C                   MOVE      PTYPC         PTYP
     C                   MOVE      'RE'          AMTP
                                                                                              CLE106
     C                   IF        RPFRCY <> *Blanks                                          CLE106
     C                   EVAL      FRCY = RPFRCY                                              CLE106
     C                   EVAL      FRAM = RPFRAM                                              CLE106
     C                   ELSE                                                                 CLE106
     C                   EVAL      FRCY = *Blanks                                             CLE106
     C                   EVAL      FRAM = *Zeros                                              CLE106
     C                   ENDIF                                                                CLE106
      *
     C     REPTC         IFNE      1
     C     CLE154        ANDEQ     'N'                                                        CLE154
     C     RPREPT        ORNE      1                                                          CLE154
     C     CLE154        ANDEQ     'Y'                                                        CLE154
     C                   Z-ADD     RPTAMT        TAMT
     C                   ENDIF
      *
     C     REPTC         IFNE      3
     C     CLE154        ANDEQ     'N'                                                        CLE154
     C     RPREPT        ORNE      3                                                          CLE154
     C     CLE154        ANDEQ     'Y'                                                        CLE154
     C                   Z-ADD     RPPRAM        PRAM
     C                   ENDIF
      *                                                                                       CLE154
     C     REPTC         IFEQ      2                                                          CLE154
     C     CLE154        ANDEQ     'Y'                                                        CLE154
     C     PRAM          ANDEQ     0                                                          CLE154
     C     INTCC         IFNE      ' '                                                        CLE154
     C                   MOVE      INTCC         INTC                                         CLE154
     C                   ELSE                                                                 CLE154
     C                   MOVE      'N'           INTC                                         CLE154
     C                   ENDIF                                                                CLE154
     C                   ENDIF                                                                CLE154
     C     REPTC         IFEQ      2                                                          CLE154
     C     CLE154        ANDEQ     'Y'                                                        CLE154
     C     PRAM          ANDNE     0                                                          CLE154
     C                   MOVE      ' '           INTC                                         CLE154
     C                   ENDIF                                                                CLE154
      *
     C     RPTAMT        IFEQ      0                                                        BUG22113
     C     RPPRAM        ADD       RPINTA        RPTAMT                                     BUG22113
     C     RPPRAM        IFNE      0                                                        BUG22113
     C     RPINTA        ORNE      0                                                        BUG22113
     C                   Z-ADD     RPTAMT        TAMT                                       BUG22113
     C                   ELSE                                                               BUG22113
     C                   Z-ADD     0             TAMT                                       BUG22113
     C                   ENDIF                                                              BUG22113
     C                   ENDIF                                                              BUG22113
      *                                                                                     BUG22113
     C                   MOVE      BRCAC         BRCA
      *                                                                                       240408
      * Use customer from CLOANCL for database write.                                         240408
     C*********          MOVE      RPCNUM        CNUM                                         240408
     C                   MOVE      CNUMC         CNUM                                         240408
     C                   IF        CLE154 = 'N'                                               CLE154
     C                   MOVE      REPTC         REPT
     C                   ELSE                                                                 CLE154
     C                   Z-ADD     RPREPT        REPT                                         CLE154
     C                   ENDIF                                                                CLE154
     C                   BITOFF    '01234567'    LAIN
     C                   MOVE      WTINC         WTIN
     C                   MOVE      'A'           LLAG
     C                   MOVE      FCUSC         FCUS
     C                   MOVE      FTYPC         FTYP
     C                   MOVE      FSEQC         FSEQ
     C                   BITOFF    '01234567'    PONI
     C                   BITOFF    '01234567'    TLXY
     C                   MOVE      WOSBR         OSBR
     C                   MOVE      FCLBC         FCLB
     C                   MOVE      'I'           CHTP
     C     CLE002        IFNE      'Y'
     C     BPREAU        ORNE      'Y'
     C                   ENDIF
     C                   ENDIF
      *
      ***  Set status of Repayment
      *
B001 C     CLE002        IFEQ      'Y'
     C     BPREAU        ANDEQ     'Y'
      *
B002 C                   SELECT
X002 C     RPCHTP        WHENEQ    'I'
     C                   MOVE      'C'           ASTS
X002 C     RPCHTP        WHENEQ    'A'
B003 C     ASTS          IFEQ      'A'
     C     ASTS          OREQ      'R'
     C                   MOVE      'R'           ASTS
X003 C                   ELSE
     C                   MOVE      'C'           ASTS
E003 C                   ENDIF
X002 C     RPCHTP        WHENEQ    'X'
     C                   MOVE      'A'           ASTS
X002 C     RPCHTP        WHENEQ    'R'
     C                   MOVE      'D'           ASTS
E002 C                   ENDSL
      *
X001 C                   ELSE
      *
B002 C     RPCHTP        IFNE      'R'
     C                   MOVE      'A'           ASTS
     C                   ELSE
     C                   MOVE      'R'           ASTS
E002 C                   ENDIF
      *
E001 C                   ENDIF
      *
B001 C     @Type         IFEQ      '0'
     C                   MOVE      'A'           ASTS
E001 C                   ENDIF
                                                                                              CAP086
      * Automatic Authorisation is on                                                         CAP086
      *                                                                                       CAP086
     C                   IF        RPAUTH = 'Y'                                               CAP086
     C                   EVAL      ASTS = 'A'                                                 CAP086
     C                   ENDIF                                                                CAP086
                                                                                              CAP086
      *
      ***  Inserting/Amending/Authorising user and other details
      *
B001 C                   SELECT
X001 C     RPCHTP        WHENEQ    'I'
     C                   Z-ADD     BJRDNB        ORED
     C                   MOVEL     PSUser        IUSR
     C                   MOVE      'D'           RECI
X001 C     RPCHTP        WHENEQ    'A'
B002 C     NEWSET        IFNE      OLDSET
     C                   BITOFF    '2'           LAIN
E002 C                   ENDIF
     C                   MOVEL     PSUser        AUSR
X001 C     RPCHTP        WHENEQ    'X'
     C                   MOVEL     PSUser        XUSR
X001 C     RPCHTP        WHENEQ    'R'
     C                   MOVE      'R'           RECI
E001 C                   ENDSL
      *
B001 C     @Type         IFEQ      '0'
     C                   MOVE      RPIUSR        IUSR
     C                   MOVE      RPAUSR        AUSR
     C                   MOVE      RPXUSR        XUSR
E001 C                   ENDIF
      *
     C                   MOVE      RPAUTO        AUTO
     C                   MOVE      NEWSTS        OLDSTS
     C                   Z-ADD     WLSWC         LSWCC
     C                   Z-ADD     WLSWS         LSWSC
     C                   MOVE      P@NATN        TNLU
B001 C     RPCHTP        IFNE      'X'
     C                   MOVE      RPCHTP        CHTP
     C                   MOVE      'M'           MNSG
E001 C                   ENDIF
     C                   Z-ADD     BJRDNB        LCD
     C**********         MOVE      'N'           GASS                                         CLE106
     C                   MOVE      'N'           GPRT
     C                   MOVE      'N'           NRLI
      *
      ***  Settlement details for Insert and Amend
      *
B001 C     RPCHTP        IFEQ      'I'
     C     RPCHTP        OREQ      'A'
      *                                                                                      BUG3760
      **  Check if before and after image of the record of LOAMSDK                           BUG3760
      **  is different.                                                                      BUG3760
      *                                                                                      BUG3760
     C     CSD015        IFEQ      'Y'                                                       BUG3760
     C     W1EWLC        ANDEQ     'Y'                                                       BUG3760
     C     RPCHTP        ANDEQ     'A'                                                       BUG3760
      *                                                                                      BUG3760
     C                   MOVE      ROBN          WKROBN            6                         BUG3760
     C                   MOVE      ROCN          WKROCN            6                         BUG3760
     C                   MOVE      POBN          WKPOBN            6                         BUG3760
     C                   MOVE      POCN          WKPOCN            6                         BUG3760
      *                                                                                      BUG3760
     C                   MOVE      'N'           WDIFF             1                         BUG3760
     C                   MOVE      'N'           WDTPC             1                         BUG3760
      *                                                                                      BUG3760
     C                   MOVEA     *BLANKS       WLF(1)                                      BUG3760
      *                                                                                      BUG3760
     C     RONS          IFNE      PMRONS                                                    BUG3760
     C                   MOVEL     PMRONS        WLF(1)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C     RIBN          IFNE      PARIBN                                                    BUG3760
     C                   MOVEL     PARIBN        WLF(2)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C     WKROBN        IFNE      PAROBN                                                    BUG3760
     C                   MOVEL     PAROBN        WLF(3)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C     WKROCN        IFNE      PAROCN                                                    BUG3760
     C                   MOVEL     PAROCN        WLF(4)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C     PONS          IFNE      PMPONS                                                    BUG3760
     C                   MOVEL     PMPONS        WLF(5)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C     PIBN          IFNE      PAPIBN                                                    BUG3760
     C                   MOVEL     PAPIBN        WLF(6)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C     WKPOBN        IFNE      PAPOBN                                                    BUG3760
     C                   MOVEL     PAPOBN        WLF(7)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C     WKPOCN        IFNE      PAPOCN                                                    BUG3760
     C                   MOVEL     PAPOCN        WLF(8)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C     RCRN          IFNE      PARCRN                                                    BUG3760
     C                   MOVEL     PARCRN        WLF(9)                                      BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C     RVNO          IFNE      PARVNO                                                    BUG3760
     C                   MOVEL     PARVNO        WLF(10)                                     BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C     AWBN          IFNE      PAAWBN                                                    BUG3760
     C                   MOVEL     PAAWBN        WLF(11)                                     BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C     BENN          IFNE      PABENN                                                    BUG3760
     C                   MOVEL     PABENN        WLF(12)                                     BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C     DTP1          IFNE      PMDTP1                                                    BUG3760
     C     DTP2          ORNE      PMDTP2                                                    BUG3760
     C     DTP3          ORNE      PMDTP3                                                    BUG3760
     C     DTP4          ORNE      PMDTP4                                                    BUG3760
     C                   MOVE      'Y'           WDTPC                                       BUG3760
     C                   MOVE      'Y'           WDIFF                                       BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
      *
     C                   MOVE      WSETP         SETP
     C                   MOVE      WOSAC         OSAC
     C                   MOVE      WOSBR         OSBR
     C                   MOVE      WTSEN         TSEN
     C                   MOVE      WFACO         FACO
     C                   MOVE      RPSPI1        SPI1
     C                   MOVE      RPSPI2        SPI2
     C                   MOVE      RPSPI3        SPI3
     C                   MOVE      RPSPI1        SSPI1
     C                   MOVE      RPSPI2        SSPI2
     C                   MOVE      RPSPI3        SSPI3
      *
     C                   Z-ADD     RPRSTM        RSTM
     C                   MOVE      RPRONS        RONS
     C                   MOVE      RPRIBN        RIBN
     C                   MOVE      RPRIBA        RIBA
     C                   MOVE      RPROBN        ROBN
     C                   MOVE      RPROCN        ROCN
     C                   MOVE      RPPSTM        PSTM
     C                   MOVE      RPPONS        PONS
     C                   MOVE      RPPIBN        PIBN
     C                   MOVE      RPPIBA        PIBA
     C                   MOVE      RPPIBA        PIBA
     C                   MOVE      RPPOBN        POBN
     C                   MOVE      RPPOCN        POCN
     C                   MOVE      RPRCRN        RCRN
     C                   MOVE      RPRCRA        RCRA
     C                   MOVE      RPRVNO        RVNO
     C                   MOVE      RPAWBN        AWBN
     C                   MOVE      RPAWBA        AWBA
     C                   MOVE      RPBENN        BENN
     C                   MOVE      RPBENA        BENA
     C                   MOVE      RPDTP1        DTP1
     C                   MOVE      RPDTP2        DTP2
     C                   MOVE      RPDTP3        DTP3
     C                   MOVE      RPDTP4        DTP4
     C                   MOVE      RPDCHG        DCHG
     C                   MOVE      RPBTB1        BTB1
     C                   MOVE      RPBTB2        BTB2
     C                   MOVE      RPBTB3        BTB3
     C                   MOVE      RPBTB4        BTB4
     C                   MOVE      RPBTB5        BTB5
     C                   MOVE      RPBTB6        BTB6
     C                   MOVE      RPCVMR        CVMR
      *
     C     CEU004        IFEQ      'Y'
     C                   MOVE      WSCCY         SCCY
     C                   MOVE      RPICCY        ICCY
     C                   ENDIF
      *
     C                   ENDIF
      *
      ***  Batch Mode: Set up Original Entry Date, and Last Change Date
      *
     C     @Type         IFEQ      '0'
      *
     C     RPCHTP        IFEQ      'I'
     C                   Z-ADD     RPORED        ORED
     C                   ENDIF
     C                   Z-ADD     RPLCD         LCD
      *
      ***  Set up Last Change Type and PC transaction reference
      *
     C     RPCHTP        IFNE      'X'
     C                   MOVE      RPCHTP        CHTP
     C                   ENDIF
      *
     C                   MOVE      RPPCOB        PCOBK
     C                   ELSE
     C                   MOVE      *BLANKS       PCOBK
     C                   ENDIF
      *
     C     @Type         IFNE      '0'
     C     RPCHTP        ANDEQ     'I'
     C     CLE106        ANDNE     'Y'                                                       CSF011A
     C                   MOVE      BRCA          @BRCA
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @BRCA             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBRCHPD'    DBFILE                         *************
     C                   Z-ADD     2             DBASE                          * DBERR 002 *
     C                   MOVEL     BRCA          DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   IF        A8MQSM <> *BLANKS                                         CSF011A
     C                   MOVEL     A8MQSM        W#1ST3            3
     C                   ELSE                                                                CSF011A
     C                   MOVEL     BRCA          W#1ST3                                      CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C******DTAARA       DEFINE                  LEALLO                                       CLE148
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
     C                   MOVEL     W1ST11        PCRFK
     C                   MOVE      '0001'        PCRFK
     C**********         Z-ADD     PCNEXT        PCLAST                                       CLE148
     C**********         OUT       LEALLO                                                     CLE148
     C                   ENDIF
     C                   ELSE
     C     @Type         IFEQ      '0'
     C                   MOVEL     RPPCRF        PCRFK
     C                   ENDIF
     C                   ENDIF
                                                                                              CLE106
     C                   IF        CLE106 = 'Y'                                               CLE106
     C                   EVAL      PCRFK = RPPCRF                                             CLE106
     C                   ENDIF                                                                CLE106
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EVAL      STAL = RPSTAL                                              CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE031
     C                   IF        CLE031 = 'Y'                                               CLE031
     C                   EVAL      SCCY = RPSCCY                                            AR943686
     C                   EVAL      REXR = RPREXR                                              CLE031
     C                   EVAL      REXI = RPREXI                                              CLE031
     C                   EVAL      PSCY = RPPSCY                                              CLE031
     C                   EVAL      PEXR = RPPEXR                                              CLE031
     C                   EVAL      PEXI = RPPEXI                                              CLE031
     C                   ENDIF                                                                CLE031
 
     C                   IF        CLE154 = 'Y'                                             MD040830
     C                   EVAL      REPT = RPREPT                                            MD040830
     C                   ENDIF                                                              MD040830
      *
      ***  System geFerated
      *
     C     @Type         IFEQ      '0'
     C                   MOVE      'S'           MNSG
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRSHAD   - Retrieve parameter fields for Shadow Update        *
      *****************************************************************
     C     SRSHAD        BEGSR
      *
     C                   MOVE      RECI          SHRECI
     C                   MOVE      LNRF          SHLNRF
     C                   Z-ADD     VDAT          SHVDAT
     C                   Z-ADD     LASN          SHLASN
     C                   MOVE      PTYPC         SHPTYP
     C                   MOVE      AMTP          SHAMTP
     C                   MOVE      CCY           SHCCY
     C                   MOVE      AUTO          SHAUTO
     C                   Z-ADD     PRAM          SHPRAM
     C                   Z-ADD     TAMT          SHTAMT                                      BUG8333
     C                   MOVE      BRCA          SHBRCA
     C***********        Z-ADD     0             SHREPT                                      BUG8333
     C                   Z-ADD     REPT          SHREPT                                      BUG8333
     C                   MOVE      OTIST         SHTIST
      *
     C                   MOVE      OSBR          SHOSBR
     C                   MOVE      CHTP          SHCHTP
      *                                                                                     AR887295
     C     RPCHTP        IFNE      'I'                                                      AR887295
     C     VDAT          ANDGT     ORED                                                     AR887295
     C     ORED          ANDLT     BJRDNB                                                   AR887295
     C                   EXSR      SRCALREP                                                 AR887295
     C                   ENDIF                                                              AR887295
      *                                                                                     MD047554
      ** If Autosettle indicator has been changed from Y to N, treat                        MD047554
      ** as reversal for shadow posting.                                                    MD047554
      *                                                                                     MD047554
     C     RPCHTP        IFEQ      'A'                                                      MD047554
     C     OAUTO         ANDEQ     'Y'                                                      MD047554
     C     RPAUTO        ANDEQ     'N'                                                      MD047554
     C                   EVAL      SHCHTP = 'R'                                             MD047554
     C                   ENDIF                                                              MD047554
      *
     C     CEU004        IFEQ      'Y'
     C                   MOVE      SCCY          SHSCCY
     C                   MOVE      ICCY          SHICCY
     C                   ENDIF
      *                                                                                       CLE031
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   MOVE      SCCY          SHSCCY                                     AR943686
     C                   Z-ADD     REXR          SHREXR                                       CLE031
     C                   MOVE      REXI          SHREXI                                       CLE031
     C                   MOVE      PSCY          SHPSCY                                       CLE031
     C                   Z-ADD     PEXR          SHPEXR                                       CLE031
     C                   MOVE      PEXI          SHPEXI                                       CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                      BUG9225
     C                   MOVE      STAL          SHSTAL                                      BUG9225
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                     AR887295
      * SRCALREP - Calculate Repayment Posting on Reverse or Amend    *                     AR887295
      *****************************************************************                     AR887295
     C     SRCALREP      BEGSR                                                              AR887295
      *                                                                                     AR887295
     C     RPSHP         KLIST                                                              AR887295
     C                   KFLD                    LNRF                                       AR887295
     C                   KFLD                    BJRDNB                                     AR887295
      *                                                                                     AR887295
     C                   Z-ADD     0             WTCPAM           13 0                      AR887295
      *                                                                                     AR887295
     C     RPSHP         SETLL     LOAMSOM3                                                 AR887295
     C                   READ      LOAMSOM3                               46                AR887295
      *                                                                                     AR887295
     C     *IN46         DOWEQ     '0'                                                      AR887295
     C     RSLNRF        ANDEQ     LNRF                                                     AR887295
     C     RSVDAT        ANDGT     RSORED                                                   AR887295
     C     RSORED        ANDLT     BJRDNB                                                   AR887295
     C     RSVDAT        ANDLE     VDAT                                                     AR887295
      *                                                                                     AR887295
      ** Consider loan amendment only when value date is less than or                       AR887295
      ** when value date is equal and LASN is less than 'RE' which                          AR887295
      ** will be process first 'RE' by the system.                                          AR887295
      *                                                                                     AR887295
     C     RSVDAT        IFLT      VDAT                                                     AR887295
     C     RSVDAT        OREQ      VDAT                                                     AR887295
     C     RSLASN        ANDLT     LASN                                                     AR887295
      *                                                                                     AR887295
      ** Calculate total principal amount to be less with CPAM.                             AR887295
      ** Add amount of 'MR', PF ,'RE' and RAMT to WTCPAM.                                   AR887295
      ** Subtract 'PI and 'PT' from WTCPAM.                                                 AR887295
      *                                                                                     AR887295
     C     RSAMTP        IFEQ      'MR'                                                     AR887295
     C                   ADD       RSPRAM        WTCPAM                                     AR887295
     C                   ENDIF                                                              AR887295
      *                                                                                     AR887295
     C     RSAMTP        IFEQ      'PI'                                                     AR887295
     C                   SUB       RSPRAM        WTCPAM                                     AR887295
     C                   ENDIF                                                              AR887295
      *                                                                                     AR887295
     C     RSAMTP        IFEQ      'PF'                                                     AR887295
     C                   ADD       RSPRAM        WTCPAM                                     AR887295
     C                   ENDIF                                                              AR887295
      *                                                                                     AR887295
     C     RSAMTP        IFEQ      'PT'                                                     AR887295
     C                   SUB       RSPRAM        WTCPAM                                     AR887295
     C                   ENDIF                                                              AR887295
      *                                                                                     AR887295
     C     RSAMTP        IFEQ      'RE'                                                     AR887295
     C     RSREPT        IFNE      3                                                        AR887295
     C                   ADD       RSPRAM        WTCPAM                                     AR887295
     C                   ELSE                                                               AR887295
     C                   ADD       RSTAMT        WTCPAM                                     AR887295
     C                   ENDIF                                                              AR887295
     C                   ENDIF                                                              AR887295
      *                                                                                     AR887295
     C                   ENDIF                                                              AR887295
      *                                                                                     AR887295
     C                   READ      LOAMSOM3                               46                AR887295
     C                   ENDDO                                                              AR887295
      *                                                                                     AR887295
      ** Add rebate amount when value date after next repayment date                        AR887295
      *                                                                                     AR887295
     C     NRPD          IFNE      0                                                        AR887295
     C     NRPD          ANDLT     VDAT                                                     AR887295
     C                   ADD       RAMT          WTCPAM                                     AR887295
     C                   ENDIF                                                              AR887295
      *                                                                                     AR887295
     C     CPAM          SUB       WTCPAM        WTCPAM                                     AR887295
      *                                                                                     AR887295
     C     WTCPAM        IFLT      PRAM                                                     AR887295
     C     REPT          ANDNE     3                                                        AR887295
     C     WTCPAM        ORLT      TAMT                                                     AR887295
     C     REPT          ANDEQ     3                                                        AR887295
      *                                                                                     AR887295
     C     WTCPAM        IFGT      0                                                        AR887295
      *                                                                                     AR887295
     C     REPT          IFNE      3                                                        AR887295
     C                   Z-ADD     WTCPAM        SHPRAM                                     AR887295
     C                   ENDIF                                                              AR887295
      *                                                                                     AR887295
     C     REPT          IFNE      1                                                        AR887295
     C                   Z-ADD     WTCPAM        SHTAMT                                     AR887295
     C                   ENDIF                                                              AR887295
      *                                                                                     AR887295
     C                   ELSE                                                               AR887295
      *                                                                                     AR887295
     C                   Z-ADD     0             SHPRAM                                     AR887295
     C                   Z-ADD     0             SHTAMT                                     AR887295
     C                   ENDIF                                                              AR887295
      *                                                                                     AR887295
     C                   ENDIF                                                              AR887295
      *                                                                                     AR887295
     C                   ENDSR                                                              AR887295
      *****************************************************************                     AR887295
      /EJECT                                                                                AR887295
      *****************************************************************
      * SRUSHD - Update Shadow Record                                 *
      *****************************************************************
     C     SRUSHD        BEGSR
      *
      ***  Do On-line updates
      *
     C     @Type         IFEQ      'B'
     C                   MOVE      '*LEBTCH'     @RTCD
     C                   ELSE
     C                   MOVE      *BLANKS       @RTCD
     C                   ENDIF
      *                                                                                     MD047554
      ** If Autosettle Indicator has been amended from N to Y,                              MD047554
      ** treat as newly inserted repayment to create shadow                                 MD047554
      ** posting. Blank out Z#BSTS to create VALUE posting.                                 MD047554
      *                                                                                     MD047554
     C                   MOVEL     *BLANKS       #AAUTO            1                        MD047554
     C     RPCHTP        IFEQ      'A'                                                      MD047554
     C     OAUTO         ANDEQ     'N'                                                      MD047554
     C     RPAUTO        ANDEQ     'Y'                                                      MD047554
     C                   MOVE      *BLANKS       Z#BSTS                                     MD047554
     C                   EVAL      #AAUTO = 'Y'                                             MD047554
     C                   ENDIF                                                              MD047554
      *
     C                   CALL      'AOOULAU0'
     C                   PARM                    @RTCD
     C                   PARM                    Z#BSTS
     C                   PARM                    Z#ASTS
     C                   PARM                    Z#WSTS
     C                   PARM      *BLANKS       PDCLI             1                        MD023787
      *                                                                                     AR868380
     C     @RTCD         IFEQ      '*RECLCK'                                                AR868380
     C                   MOVEL     '*RECLCK'     @@RTCD                                     AR868380
     C                   GOTO      EXIT                                                     AR868380
     C                   ENDIF                                                              AR868380
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C     'Access'      CAT       'Program':1   DBKEY                          *************
     C                   MOVEL     'AOOULAU0'    DBFILE                         * DBERR 003 *
     C                   Z-ADD     3             DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                     MD047554
     C                   EVAL      OPRAM = *Zero                                            MD047554
     C                   EVAL      OCHTP = RPCHTP                                           MD047554
      *                                                                                     MD047554
     C     RPCHTP        IFEQ      'A'                                                      MD047554
     C     OAUTO         ANDEQ     'Y'                                                      MD047554
     C     RPAUTO        ANDEQ     'N'                                                      MD047554
     C                   EVAL      OCHTP = 'R'                                              MD047554
     C                   ENDIF                                                              MD047554
      *                                                                                       264065
     C     PRAM          IFNE      0                                                          264065
     C     TAMT          ORNE      0                                                          264065
     C                   MOVEL     SHLNRF        OLNRF                                        264065
     C                   MOVEL     SHVDAT        OVDAT                                        264065
     C                   MOVEL     SHLASN        OLASN                                        264065
     C                   MOVEL     SHPRAM        OMPRAM                                       264065
     C                   CALL      'LE2041  '                                                 264065
     C**********         PARM                    OLNRF             6 0               264065 MD047554
     C                   PARM                    OLNRF             6                        MD047554
     C                   PARM                    OVDAT             5 0                        264065
     C                   PARM                    OLASN             3 0                        264065
     C                   PARM                    OMPRAM           13 0                        264065
     C                   PARM                    AMTP                                         264065
     C**********         PARM                    RPCHTP                              264065 MD047554
     C                   PARM                    OCHTP             1                        MD047554
     C                   PARM                    OPRAM            13 0                      MD047554
     C                   PARM      *BLANKS       @RTCD                                      AR868380
      *                                                                                     AR868380
     C     @RTCD         IFEQ      '*RECLCK'                                                AR868380
     C                   MOVEL     '*RECLCK'     @@RTCD                                     AR868380
     C                   GOTO      EXIT                                                     AR868380
     C                   ENDIF                                                              AR868380
     C                   ENDIF                                                                264065
     C/COPY WNCPYSRC,LEH01197
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUPLX - Update Shadow Record                                 *
      *****************************************************************
     C     SRUPLX        BEGSR
      *
      ***  Update LTRIX   - S01465
      *
     C     RPCHTP        IFEQ      'X'
     C     RPCHTP        OREQ      'R'
     C     BPREAU        ANDEQ     'Y'
     C     XUSR          ANDNE     *BLANKS
     C     @Type         OREQ      '0'
     C     BPREAU        OREQ      'N'
      *
      ***  Get Telex notice days form currencies file.  Use loan ccy
      ***  if start settlement type is 01,07 OR 08 otherwise use local
      ***  ccy.
      *
     C                   MOVE      BJLCCY        @CCY              3
     C                   MOVE      BJSLCD        ZLOC2
      *
     C     SDST          IFEQ      01
     C     SDST          OREQ      07
     C     SDST          OREQ      08
      *
     C                   MOVE      LCCYC         @CCY
      *
      ***  Get the nostro location of the nostro no.
      *
     C                   MOVEL     OSDA          STNOS             2
     C     STNOS         IFEQ      *BLANKS
     C     STNOS         OREQ      '00'
     C                   MOVE      *BLANKS       ZLOC2
     C                   ELSE
     C                   MOVE      STNOS         W@NSTR            2
      *
     C     CEU004        IFEQ      'Y'
     C     SCCYC         ANDNE     *BLANKS
     C                   MOVE      SCCYC         W@CCY             3
     C                   ELSE
     C                   MOVE      LCCYC         W@CCY             3
     C                   ENDIF
      *
     C                   EXSR      SRGNST
      *
     C     @RTCD         IFEQ      *BLANKS
     C     BGUDRS        IFEQ      'Y'
     C                   MOVE      A7NOSN        ZLOC2
     C                   ELSE
     C                   MOVE      *BLANKS       ZLOC2
     C                   END
     C                   END
     C                   END
     C                   END
      *
      ***  Get the telex notice days
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      @CCY          K101              3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   Z-ADD     4             DBASE                          * DBERR 004 *
     C                   MOVEL     @CCY          DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  Derive test date
      *
     C                   MOVE      BJLCCY        ZCCY1
     C                   MOVE      BJSLCD        ZLOC1
     C                   MOVE      @CCY          ZCCY2
     C                   Z-ADD     A6TXND        ZNRDYS
     C                   Z-ADD     BJRDNB        ZDAYNO
      *
     C                   CALLB     'ZF2C'
     C                   PARM                    RETCODE          10
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZCCY1             3
     C                   PARM                    ZLOC1             3
     C                   PARM                    ZCCY2             3
     C                   PARM                    ZLOC2             3
     C                   PARM                    ZNRDYS            2 0
     C                   PARM                    ZDYNBR            5 0
      *
     C     RPVDAT        IFLE      ZDYNBR
      *
     C**********         MOVE      '1'           *IN17                                      AR322732
     C**********         MOVE      '0'           *IN99                                      AR322732
      *
     C******IN17         DOUEQ     '0'                                                      AR322732
     C*****RECI*         ANDEQ     *BLANK                                                   AR322732
     C******IN99         OREQ      '1'                                                      AR322732
      *
      ***  Access LTRIX header for next available RRN
      *
     C*****1****         CHAIN(N)  LTRIX                              99                    AR322732
      *
     C******IN99         IFEQ      *OFF                                                     AR322732
      *
     C*****RECI          IFEQ      'H'                                                      AR322732
     C*****RRNA          ANDGT     FLSZ                                                     AR322732
     C**********         EXSR      *PSSR                                                    AR322732
     C**********         ENDIF                                                              AR322732
      *
     C**********         ELSE                                                               AR322732
     C******LOCK         IN        LDA                                                      AR322732
     C**********         MOVEL     'LTRIX   '    DBFILE                         ************AR322732
     C**********         Z-ADD     5             DBASE                          * DBERR 005 AR322732
     C**********         MOVEL     1             DBKEY                          ************AR322732
     C**********         OUT       LDA                                                      AR322732
     C**********         EXSR      *PSSR                                                    AR322732
     C**********         ENDIF                                                              AR322732
      *
     C**********         Z-ADD     RRNA          LXRRN             5 0                      AR322732
      *
     C*****LXRRN         CHAIN     LTRIX                              9917                  AR322732
      *
     C******IN17         IFEQ      '1'                                                      AR322732
     C*****TXSTS         IFEQ      1218                                                     AR322732
     C**********         UNLOCK    LTRIX                                                    AR322732
     C**********         ELSE                                                               AR322732
     C**********         MOVE      '1'           *IN99                                      AR322732
     C**********         ENDIF                                                              AR322732
     C**********         ENDIF                                                              AR322732
      *
     C**********         ENDDO                                                              AR322732
      *
     C******IN99         IFEQ      *ON                                                      AR322732
     C******LOCK         IN        LDA                                                      AR322732
     C**********         MOVEL     'LTRIX   '    DBFILE                         ************AR322732
     C**********         Z-ADD     6             DBASE                          * DBERR 006 AR322732
     C**********         MOVEL     LXRRN         DBKEY                          ************AR322732
     C**********         OUT       LDA                                                      AR322732
     C**********         EXSR      *PSSR                                                    AR322732
     C**********         ELSE                                                               AR322732
      *
     C                   Z-ADD     0             RRNA              5 0                      AR322732
     C                   Z-ADD     1             PRI1
      *
      ***  Backvalued repayments and non auto-settled repayments should
      ***  not be shown on Pay/rec reporting
      *
     C     RPVDAT        IFLT      BJRDNB
     C     AUTO          OREQ      'N'
     C                   Z-ADD     0             PRI1
     C                   ENDIF
      *
     C                   EXCEPT    LTRIXD
      *
      ***  Get header record
      *
     C*****1****         CHAIN     LTRIX                              99                    AR322732
      *
     C******IN99         IFEQ      *ON                                                      AR322732
     C******LOCK         IN        LDA                                                      AR322732
     C**********         MOVEL     'LTRIX   '    DBFILE                         ************AR322732
     C**********         Z-ADD     7             DBASE                          * DBERR 007 AR322732
     C**********         MOVEL     LXRRN         DBKEY                          ************AR322732
     C**********         OUT       LDA                                                      AR322732
     C**********         EXSR      *PSSR                                                    AR322732
     C**********         ENDIF                                                              AR322732
      *
      ***  Update relevant control fields
      *
     C*****NORE*         ADD       1             NORE                                       AR322732
     C*****RRNA*         ADD       1             RRNA                                       AR322732
     C*****NLAR*         ADD       1             NLAR                                       AR322732
      *
     C**********         EXCEPT    LTRIXH                                                   AR322732
      *
     C**********         ENDIF                                                              AR322732
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRGNST - Get nostro details                                   *
      *****************************************************************
     C     SRGNST        BEGSR
      *
     C                   MOVE      *BLANKS       W@STLC            3
      *
      ***  Access Nostro details to get nostro location code
      *
     C                   CALLB     'AONOSTR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      *BLANKS       @KEYA             6
     C                   PARM      W@CCY         @KEYB             3
     C**********         PARM      *BLANKS       @KEYC             4                          CGL029
     C                   PARM      *BLANKS       @KEYC                                        CGL029
     C                   PARM      *BLANKS       @KEYD             2
     C                   PARM      W@NSTR        @KEYE             2
     C                   PARM      *BLANKS       @KEYF             3
     C                   PARM      *BLANKS       @KEYG            10
     C                   PARM      *BLANKS       @KEYH             1
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUPFC -                                                      *
      *****************************************************************
     C     SRUPFC        BEGSR
      *
     C                   MOVE      'N'           WPART             1
      *
      ***  Access facility 'A' record
      *
     C                   MOVE      FCUSC         WFCNUM
     C                   MOVE      FTYPC         WFFACT
     C                   MOVE      FSEQC         WFFCNO
     C                   MOVE      'A'           WFRCTP
      *
     C     WKFAC         CHAIN(N)  FCLTY                              99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'FCLTY'       DBFILE                         *************
     C                   Z-ADD     8             DBASE                          * DBERR 008 *
     C                   MOVEL     WFKEY         DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                             245177A
      *** Access LEFCAMPD file for change in revolving credit.                               245177A
                                                                                             245177A
     C                   MOVE      ' '           WRVCRF            1                         245177A
     C                   Z-ADD     0             WVLDT             5 0                       245177A
     C     KFCAM         SETLL     LEFCAML3                                                  245177A
     C     KFCAM         READE     LEFCAML3                               85                 245177A
      *                                                                                      245177A
     C     *IN85         DOWEQ     *OFF                                                      245177A
     C     WRVCRF        ANDEQ     ' '                                                       245177A
     C     RECIF         IFEQ      'D'                                                       245177A
     C     FATP          ANDEQ     'RC'                                                      245177A
     C                   MOVE      RVCRF         WRVCRF                                      245177A
     C                   Z-ADD     VLDT          WVLDT                                       245177A
     C                   ENDIF                                                               245177A
     C     KFCAM         READE     LEFCAML3                               85                 245177A
     C                   ENDDO                                                               245177A
      *
     C                   IF        CLE134 = 'Y'                                             AR806351
     C                   EVAL      WUpdExpo = 'Y'                                           AR806351
     C                   EXSR      SrPDCLRE                                                 AR806351
     C                   ENDIF                                                              AR806351
      *                                                                                     AR806351
     C                   EXSR      FCLTSR
      *
      ***  Update superfacility of the tranche, if any, for CLE005
      *
     C     CLE005        IFEQ      'Y'
     C     TRCA          ANDEQ     'TR'
     C                   MOVEL     WPRME         SPRME            12
      *
      ***  Update credit agreement/superfacility
      *
     C                   MOVE      FCCY          WTCCY             3
     C                   MOVE      CMDI          WFCMDI            1
     C                   Z-ADD     CAXR          WFCAXR           13 8
     C                   MOVE      CANM          WFCNUM
     C                   MOVE      CAFT          WFFACT
     C                   MOVE      CAFN          WFFCNO
     C                   MOVE      'A'           WFRCTP
      *
      ***  Save the revolving credit indicator specified for the tranche
      *
     C     CLE014        IFEQ      'Y'
     C                   MOVE      RVCR          WRVCR             1
     C                   ENDIF
      *
     C     WKFAC         CHAIN(N)  FCLTY                              99
      *
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'FCLTY   '    DBFILE                         *************
     C                   Z-ADD     9             DBASE                          * DBERR 009 *
     C                   MOVEL     WFKEY         DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ***  If the revolving credit indicator for the credit agreement is
      ***  'T', use the saved tranche revolving credit indicator as the
      ***  credit agreement revolving indicator.
      *
     C     CLE014        IFEQ      'Y'
      *
     C     RVCR          IFEQ      'T'
     C                   MOVE      WRVCR         RVCR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVE      'Y'           WTRCA             1
      *
     C                   IF        CLE134 = 'Y'                                             AR806351
     C                   EVAL      WUpdExpo = 'Y'                                           AR806351
     C                   EXSR      SrPDCLRE                                                 AR806351
     C                   ENDIF                                                              AR806351
      *                                                                                     AR806351
     C                   EXSR      FCLTSR
     C                   MOVE      *BLANK        WTRCA
      *
     C                   MOVEL     SPRME         WPRME
     C                   ENDIF
      *
      ***  Update also the Participant facility if existing
      *
     C     LPFI          IFNE      ' '
     C*****LPFI*         ANDNE     'R'                                                        CLE106
      *
     C                   MOVE      'Y'           WPART
     C                   MOVE      PTFC          WFCNUM
     C                   MOVE      PTFT          WFFACT
     C                   MOVE      PTFN          WFFCNO
     C                   MOVE      'A'           WFRCTP
      *
     C     WKFAC         CHAIN(N)  FCLTY                              99
      *
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'FCLTY   '    DBFILE                         *************
     C                   Z-ADD     10            DBASE                          * DBERR 010 *
     C                   MOVEL     WFKEY         DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        CLE134 = 'Y'                                             AR806351
     C                   EVAL      WUpdExpo = 'Y'                                           AR806351
     C                   EXSR      SrPDCLRE                                                 AR806351
     C                   ENDIF                                                              AR806351
      *                                                                                     AR806351
     C                   EXSR      FCLTSR
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT                                                                                AR806351
      *****************************************************************                     AR806351
      * SRPDCLRE - Check if loan has FAMU N/Y                         *                     AR806351
      *****************************************************************                     AR806351
     C     SRPDCLRE      BEGSR                                                              AR806351
      *                                                                                     AR806351
      ** Bypass if PDCL type is Interest(Y) or Fee(Z) and with FAMU = N                     AR806351
      ** Use auto-settlement flag from CLOANCL (should be 'C')                              AR806351
      *                                                                                     AR806351
     C     AUTOC         IFEQ      'C'                                                      AR806351
     C                   IF        %SUBST(LTYPC:1:1) = 'Y' AND                              AR806351
     C                             FAMU = 'N' OR                                            AR806351
     C                             %SUBST(LTYPC:1:1) = 'Z' AND                              AR806351
     C                             FAMU = 'N'                                               AR806351
     C                   EVAL      WUpdExpo='N'                                             AR806351
     C                   ENDIF                                                              AR806351
     C                   ENDIF                                                              AR806351
      *                                                                                     AR806351
     C                   ENDSR                                                              AR806351
      *****************************************************************
      /EJECT
      *****************************************************************
      * FCLTSR -                                                      *
      *****************************************************************
     C     FCLTSR        BEGSR
      *
      ***  Get facility ccy decimal places
      *
     C                   Z-ADD     RPVDAT        DAYNO             5 0
     C     WTRCA         IFEQ      *BLANK
     C                   MOVE      FCCY          @CCY
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      @CCY          K101              3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   Z-ADD     11            DBASE                          * DBERR 011 *
     C                   MOVEL     @CCY          DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        WFCDP             1 0
     C                   MOVE      A6MDIN        WFMDI             1                         BUG3112
     C                   Z-ADD     A6SPRT        WFSPT            13 8                       BUG3112
      *
      ***  Get Loan ccy decimal places
      *
     C                   MOVE      LCCYC         @CCY
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      @CCY          K101              3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   Z-ADD     12            DBASE                          * DBERR 12 *
     C                   MOVEL     @CCY          DBKEY                          ************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        WLCDP             1 0
     C                   MOVEL     A6MDIN        WLMDI             1                         BUG3112
     C                   Z-ADD     A6SPRT        WLSPT            13 8                       BUG3112
     C                   MOVE      LCCYC         WCCYX             3                         BUG3112
      *
     C     WFCDP         SUB       WLCDP         WCX               1 0
     C                   ADD       4             WCX
     C     FMDI          IFEQ      'D'
     C     FCXR          DIV       POWR(WCX)     WFCXRT
     C     1             DIV       WFCXRT        WFCXRT
     C                   ELSE
     C     FCXR          MULT(H)   POWR(WCX)     WFCXRT           15 9
     C                   ENDIF
     C                   ENDIF
      *                                                                                      BUG3112
      ** Use new facility exchange rate (NFCE) to update CAMD if                             BUG3112
      ** backvalued rollover exists w/c is earlier than repayement                           BUG3112
      ** schedule                                                                            BUG3112
      *                                                                                      BUG3112
     C     CLE023        IFEQ      'Y'                                                       BUG3112
      *                                                                                      BUG3112
     C     RLDT          IFNE      0                                                         BUG3112
     C     NFCE          ANDNE     0                                                         BUG3112
     C     NCCY          ANDEQ     *BLANKS                                                   BUG3112
     C     RLDT          ANDLT     BJRDNB                                                    BUG3112
      *                                                                                      BUG3112
     C     NFMD          IFEQ      'D'                                                       BUG3112
     C     NFCE          DIV(H)    POWR(WCX)     WFCXRT                                      BUG3112
     C     1             DIV       WFCXRT        WFCXRT                                      BUG3112
     C                   ELSE                                                                BUG3112
     C     NFCE          MULT(H)   POWR(WCX)     WFCXRT           15 9                       BUG3112
     C                   ENDIF                                                               BUG3112
      *                                                                                      BUG3112
     C                   ENDIF                                                               BUG3112
     C                   ENDIF                                                               BUG3112
      *
      ***  Use WFCXRT when calculating for the correct payment amount.
      *
     C     REPTC         IFNE      3
     C     CLE154        ANDEQ     'N'                                                        CLE154
     C     RPREPT        ORNE      3                                                          CLE154
     C     CLE154        ANDEQ     'Y'                                                        CLE154
     C                   Z-ADD     RPPRAM        WLAMT            13 0
     C                   ELSE
     C                   Z-ADD     RPTAMT        WLAMT
     C                   ENDIF
      *
     C     RPCHTP        IFEQ      'I'
     C     WLAMT         MULT      WFCXRT        WFCBAL
     C                   ELSE
     C     REPTC         IFEQ      1
     C     CLE154        ANDEQ     'N'                                                        CLE154
     C     RPREPT        OREQ      1                                                          CLE154
     C     CLE154        ANDEQ     'Y'                                                        CLE154
     C     PRAM          MULT      WFCXRT        WFCBAL           13 0
     C                   ELSE
     C     TAMT          MULT      WFCXRT        WFCBAL
     C                   ENDIF
     C                   ENDIF
      *                                                                                      BUG3112
      ** Lending Enhancement CLE023 is switched on                                           BUG3112
      *                                                                                      BUG3112
     C     CLE023        IFEQ      'Y'                                                       BUG3112
      *                                                                                      BUG3112
      ** cross exchange rate bet Facility ccy and Loan ccy                                   BUG3112
      *                                                                                      BUG3112
     C                   MOVE      WLMDI         ZMDI1                                       BUG3112
     C                   Z-ADD     WLSPT         ZRATE1                                      BUG3112
     C                   MOVE      WFMDI         ZMDI2                                       BUG3112
     C                   Z-ADD     WFSPT         ZRATE2                                      BUG3112
     C                   EXSR      ZXRATE                                                    BUG3112
      *                                                                                      BUG3112
     C     ZMDIX         IFEQ      'D'                                                       BUG3112
     C     ZRATEX        DIV(H)    POWR(WCX)     WSPXRT                                      BUG3112
     C     1             DIV       WSPXRT        WSPXRT                                      BUG3112
     C                   ELSE                                                                BUG3112
     C     ZRATEX        MULT(H)   POWR(WCX)     WSPXRT           15 9                       BUG3112
     C                   ENDIF                                                               BUG3112
      *                                                                                      BUG3112
      ** Calculate equivalent repayment amount at spot rate                                  BUG3112
      *                                                                                      BUG3112
     C     RPCHTP        IFEQ      'I'                                                       BUG3112
     C     WLAMT         MULT(H)   WSPXRT        WCEXP            13 0                       BUG3112
     C                   ELSE                                                                BUG3112
     C     REPTC         IFEQ      1                                                         BUG3112
     C     CLE154        ANDEQ     'N'                                                        CLE154
     C     RPREPT        OREQ      1                                                          CLE154
     C     CLE154        ANDEQ     'Y'                                                        CLE154
     C     PRAM          MULT(H)   WSPXRT        WCEXP                                       BUG3112
     C                   ELSE                                                                BUG3112
     C     TAMT          MULT(H)   WSPXRT        WCEXP                                       BUG3112
     C                   ENDIF                                                               BUG3112
     C                   ENDIF                                                               BUG3112
      *                                                                                      BUG3112
     C                   ENDIF                                                               BUG3112
      *
      ***  Get amount in credit facility currency equivalent,
      ***  if necessary, for CLE005
      *
     C     WTRCA         IFEQ      'Y'
     C     WTCCY         ANDNE     FCCY
     C                   MOVE      FCCY          @CCY
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      @CCY          K101              3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   Z-ADD     13            DBASE                          * DBERR 013 *
     C                   MOVEL     @CCY          DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        WFCDP
     C                   MOVE      A6MDIN        WFMDI             1                         BUG3112
     C                   Z-ADD     A6SPRT        WFSPT            13 8                       BUG3112
     C                   MOVE      WTCCY         @CCY
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      @CCY          K101              3
     C     SDCURR        PARM      SDCURR        DSSDY
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE                         *************
     C                   Z-ADD     14            DBASE                          * DBERR 014 *
     C                   MOVEL     @CCY          DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        WLCDP
     C                   MOVEL     A6MDIN        WLMDI             1                         BUG3112
     C                   Z-ADD     A6SPRT        WLSPT            13 8                       BUG3112
     C                   MOVE      WTCCY         WCCYX             3                         BUG3112
      *
     C     WFCDP         SUB       WLCDP         WCX               1 0
     C                   ADD       4             WCX
     C     WFCMDI        IFEQ      'D'
     C     WFCAXR        DIV(H)    POWR(WCX)     WCXRT            15 9
     C     1             DIV       WCXRT         WCXRT
     C                   ELSE
     C     WFCAXR        MULT(H)   POWR(WCX)     WCXRT
     C                   ENDIF
     C**********         MULT      WCXRT         WFCBAL                                      BUG3112
     C                   MULT(H)   WCXRT         WFCBAL                                      BUG3112
     C                   ENDIF                                                               BUG3112
      *                                                                                      BUG3112
      ** Compute and update CEXP if CLE023 is on                                             BUG3112
      *                                                                                      BUG3112
     C     CLE023        IFEQ      'Y'                                                       BUG3112
      *                                                                                      BUG3112
     C                   MOVE      WLMDI         ZMDI1                                       BUG3112
     C                   Z-ADD     WLSPT         ZRATE1                                      BUG3112
     C                   MOVE      WFMDI         ZMDI2                                       BUG3112
     C                   Z-ADD     WFSPT         ZRATE2                                      BUG3112
     C                   EXSR      ZXRATE                                                    BUG3112
      *                                                                                      BUG3112
     C     ZMDIX         IFEQ      'D'                                                       BUG3112
     C     ZRATEX        DIV(H)    POWR(WCX)     WSPXRT                                      BUG3112
     C     1             DIV       WSPXRT        WSPXRT                                      BUG3112
     C                   ELSE                                                                BUG3112
     C     ZRATEX        MULT(H)   POWR(WCX)     WSPXRT                                      BUG3112
     C                   ENDIF                                                               BUG3112
     C                   MULT(H)   WSPXRT        WCEXP                                       BUG3112
      *                                                                                      BUG3112
     C                   ENDIF                                                               BUG3112
      *                                                                                      BUG3112
     C                   MOVE      'B'           WFRCTP
     C     WKFAC         CHAIN     FCLTY                              99
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'FCLTY'       DBFILE                         *************
     C                   Z-ADD     15            DBASE                          * DBERR 015 *
     C                   MOVEL     WFKEY         DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     RVCR          IFNE      'Y'
     C     RVCR          OREQ      'Y'                                                       245177A
     C     WRVCRF        ANDEQ     'N'                                                       245177A
     C                   MOVE      *ON           *IN60
     C                   ENDIF
      *                                                                                      245177A
     C                   IF        RVCR = 'N' and                                            245177A
     C                             WRVCRF = 'Y'                                              245177A
     C                   EVAL      *IN60 = '0'                                               245177A
     C                   ENDIF                                                               245177A
      *
     C     RPVDAT        IFGT      BJRDNB
     C     RPVDAT        ORLE      BJRDNB
     C     PTYP          ANDEQ     66
     C     RCSI          ANDEQ     'Y'
     C     LPFI          ANDEQ     *BLANK
     C     RPVDAT        ORLE      BJRDNB
     C     WPART         ANDEQ     'N'
     C     LPFI          ANDNE     *BLANK
     C     RCSI          ANDEQ     'Y'
      *
     C     RPVDAT        ORLE      BJRDNB
     C     CLE005        ANDEQ     'Y'
     C     PTYP          ANDEQ     69
     C     RCSI          ANDEQ     'Y'
      *
     C     AUTO          IFEQ      'Y'                                                       245227B
     C                   MOVE      *OFF          *IN60                                       245227B
     C                   MOVE      *OFF          *IN62                                       245227B
     C                   ELSE                                                                245227B
     C                   MOVE      *ON           *IN60                                       245227B
     C                   MOVE      *ON           *IN62                                       245227B
     C                   ENDIF                                                               245227B
      *                                                                                      245227B
     C     *IN60         IFEQ      *ON
     C                   UNLOCK    FCLTY
     C                   ENDIF
     C                   MOVE      *ON           *IN62
     C                   ENDIF
      *
      ***  Do not update OAM for Prime facility of syndicated loans
      ***  as well as exposure if sold with recourse
      *
     C     WPART         IFEQ      'N'
     C     LPFI          ANDNE     ' '
     C     CLE023        IFEQ      'N'                                                       BUG3112
     C     RCSI          ANDEQ     'Y'
     C     CLE023        OREQ      'Y'                                                       BUG3112
     C                   MOVE      *ON           *IN60
     C                   ELSE                                                                245227A
     C                   MOVE      *OFF          *IN60                                       245227A
     C                   ENDIF                                                               BUG3112
     C                   ELSE                                                                245227A
     C     AUTO          IFEQ      'Y'                                                       245227A
     C                   MOVE      *OFF          *IN60                                       245227A
     C                   MOVE      *OFF          *IN62                                       245227A
     C                   ELSE                                                                245227A
     C                   MOVE      *ON           *IN60                                       245227A
     C                   MOVE      *ON           *IN62                                       245227A
     C                   ENDIF                                                               245227A
     C                   ENDIF
      *                                                                                     AR806351
     C                   IF        CLE134 = 'Y'   AND                                       AR806351
     C                             WUpdExpo= 'N'                                            AR806351
     C                   EVAL      *IN60 = '1'                                              AR806351
     C                   EVAL      *IN62 = '1'                                              AR806351
     C                   UNLOCK    FCLTY                                                    AR806351
     C                   ENDIF                                                              AR806351
      *
      ***  Update facility exposure:
      *
     C     *IN62         IFEQ      *OFF
      *
      ***  Internal parts purchased and funding participants are updated
      ***  just like any normal loan.  Prime facilities are updated only
      ***  when sold without recourse just like a parts sold
      *
     C                   IF        CLE025 = 'N'                                               CLE025
                                                                                              CLE025
     C     LPFI          IFNE      *BLANK
      *
     C     RPCHTP        IFEQ      'R'
     C     WPART         ANDEQ     'Y'
     C     RPCHTP        OREQ      'I'
     C     WPART         ANDEQ     'N'
      *                                                                                      BUG3112
     C     WPART         IFEQ      'Y'                                                       BUG3112
     C     CLE023        ANDEQ     'Y'                                                       BUG3112
     C     CLE023        OREQ      'N'                                                       BUG3112
     C     CAMD          ADD       WFCBAL        CAMD
     C                   ENDIF                                                               BUG3112
      *                                                                                      BUG3112
      ** Update Current Exposure for Lending Enhancement CLE023                              BUG3112
      *                                                                                      BUG3112
     C     CLE023        IFEQ      'Y'                                                       BUG3112
     C     CEXP          ADD       WCEXP         CEXP                                        BUG3112
     C                   ENDIF                                                               BUG3112
      *                                                                                      BUG3112
     C                   ENDIF
      *
     C     RPCHTP        IFEQ      'I'
     C     WPART         ANDEQ     'Y'
     C     RPCHTP        OREQ      'R'
     C     WPART         ANDEQ     'N'
      *                                                                                      BUG3112
     C     WPART         IFEQ      'Y'                                                       BUG3112
     C     CLE023        ANDEQ     'Y'                                                       BUG3112
     C     CLE023        OREQ      'N'                                                       BUG3112
     C     CAMD          SUB       WFCBAL        CAMD
     C                   ENDIF                                                               BUG3112
      *                                                                                      BUG3112
      ** Update current exposure for Lending Enhancement CLE023                              BUG3112
      *                                                                                      BUG3112
     C     CLE023        IFEQ      'Y'                                                       BUG3112
     C     CEXP          SUB       WCEXP         CEXP                                        BUG3112
     C                   ENDIF                                                               BUG3112
      *                                                                                      BUG3112
     C                   ENDIF
      *
     C                   ELSE
      *
      ***  Update of non-syndicated loans
      *
     C     RPCHTP        IFEQ      'I'
     C     PTYP          ANDNE     66
     C     PTYP          ANDNE     69
     C     RPCHTP        OREQ      'R'
     C     PTYP          ANDEQ     66
     C     RPCHTP        OREQ      'R'
     C     PTYP          ANDEQ     69
     C     CLE005        ANDEQ     'Y'
      *                                                                                      BUG3112
      ** Do not update CAMD of normal facility if parts sold                                 BUG3112
      *                                                                                      BUG3112
     C     PTYP          IFNE      66                                                        BUG3112
     C     PTYP          ANDNE     69                                                        BUG3112
     C     PTYP          ANDNE     72                                                        BUG3112
     C     CLE023        ANDEQ     'Y'                                                       BUG3112
     C     CLE023        OREQ      'N'                                                       BUG3112
     C     CAMD          SUB       WFCBAL        CAMD
     C                   ENDIF                                                               BUG3112
      *                                                                                      BUG3112
     C     CLE023        IFEQ      'Y'                                                       BUG3112
     C     CEXP          SUB       WCEXP         CEXP                                        BUG3112
     C                   ENDIF                                                               BUG3112
      *                                                                                      BUG3112
     C                   ENDIF
      *
     C     RPCHTP        IFEQ      'R'
     C     PTYP          ANDNE     66
     C     PTYP          ANDNE     69
     C     RPCHTP        OREQ      'I'
     C     PTYP          ANDEQ     66
     C     RPCHTP        OREQ      'I'
     C     PTYP          ANDEQ     69
     C     CLE005        ANDEQ     'Y'
      *                                                                                      BUG3112
      ** Do not update CAMD of normal facility if parts sold                                 BUG3112
      *                                                                                      BUG3112
     C     PTYP          IFNE      66                                                        BUG3112
     C     PTYP          ANDNE     69                                                        BUG3112
     C     PTYP          ANDNE     72                                                        BUG3112
     C     CLE023        ANDEQ     'Y'                                                       BUG3112
     C     CLE023        OREQ      'N'                                                       BUG3112
     C     CAMD          ADD       WFCBAL        CAMD
     C                   ENDIF                                                               BUG3112
      *                                                                                      BUG3112
      ** Update current exposure for Lending Enchancement CLE023
      *
     C     CLE023        IFEQ      'Y'                                                       BUG3112
     C     CEXP          ADD       WCEXP         CEXP                                        BUG3112
     C                   ENDIF                                                               BUG3112
      *                                                                                      BUG3112
     C                   ENDIF
      *
     C                   ENDIF
                                                                                              CLE025
     C                   ENDIF                                                                CLE025
      *
      ***  If CLE009 is installed, set Work Regeneration Indicator to
      ***  changed
      *
     C     CLE009        IFEQ      'Y'
     C                   MOVE      'C'           WKSWRI            1
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     *IN60         IFEQ      *OFF
      *
      ***  Update OAM for facility - Value Date
      *
     C     LPFI          IFEQ      *BLANK
     C     PTYP          ANDNE     66
     C     LPFI          OREQ      *BLANK
     C     CLE005        ANDEQ     'Y'
     C     PTYP          ANDNE     69
     C     LPFI          ORNE      *BLANK
     C     WPART         ANDEQ     'Y'
     C     RPCHTP        IFEQ      'I'
     C                   MOVE      *OFF          *IN63
     C                   ELSE
     C                   MOVE      *ON           *IN63
     C                   ENDIF
     C                   ELSE
     C     RPCHTP        IFEQ      'I'
     C                   MOVE      *ON           *IN63
     C                   ELSE
     C                   MOVE      *OFF          *IN63
     C                   ENDIF
     C                   ENDIF
      *
     C                   EXSR      QFCLTY
      *
      ***  Update OAM for facility - Maturity date
      *
     C     LPFI          IFEQ      *BLANK
     C     PTYP          ANDNE     66
     C     LPFI          OREQ      *BLANK
     C     CLE005        ANDEQ     'Y'
     C     PTYP          ANDNE     69
     C     LPFI          ORNE      *BLANK
     C     WPART         ANDEQ     'Y'
     C     RPCHTP        IFEQ      'I'
     C                   MOVE      *ON           *IN63
     C                   ELSE
     C                   MOVE      *OFF          *IN63
     C                   ENDIF
     C                   ELSE
     C     RPCHTP        IFEQ      'I'
     C                   MOVE      *OFF          *IN63
     C                   ELSE
     C                   MOVE      *ON           *IN63
     C                   ENDIF
     C                   ENDIF
      *
     C                   Z-ADD     MDATC         DAYNO
      *
     C     DAYNO         IFGT      0
     C     RPCHTP        IFEQ      'I'
     C                   Z-ADD     WLAMT         WRK13
     C                   ELSE
     C     REPTC         IFEQ      1
     C     CLE154        ANDEQ     'N'                                                        CLE154
     C     RPREPT        OREQ      1                                                          CLE154
     C     CLE154        ANDEQ     'Y'                                                        CLE154
     C                   Z-ADD     PRAM          WRK13
     C                   ELSE
     C                   Z-ADD     TAMT          WRK13            13 0
     C                   ENDIF
     C                   ENDIF
     C*****WRK13         MULT      WFCXRT        WFCBAL                                      BUG3112
     C     WRK13         MULT(H)   WFCXRT        WFCBAL                                      BUG3112
      *
     C     WTRCA         IFEQ      'Y'
     C     WTCCY         ANDNE     FCCY
     C**********         MULT      WCXRT         WFCBAL                                      BUG3112
     C                   MULT(H)   WCXRT         WFCBAL                                      BUG3112
     C                   ENDIF
      *
     C                   EXSR      QFCLTY
     C                   ENDIF
     C                   ENDIF
      *
     C     *IN62         IFEQ      *OFF
     C     *IN60         OREQ      *OFF
     C                   UPDATE    FCLTYFNF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * QFCLTY -                                                      *
      *****************************************************************
     C     QFCLTY        BEGSR
      *
      *****Do*not*update*for*parts*sold*with*recourse******************                      BUG3112
      *****for*a*non-syndicated*loan.**Same*thing*with*prime*facilities                      BUG3112
      *****when*sold*with*recourse*************************************                      BUG3112
      **   Do not update for parts sold with or without recourse for a                       BUG3112
      ***  non-syndicated loan.  Prime facilities should not be updated                      BUG3112
      **   for internal participation purchased and parts sold.                              BUG3112
      *
     C                   MOVE      'Y'           WCOMAV            1                         BUG3112
     C     CLE023        IFEQ      'Y'                                                       BUG3112
     C     CLE023        OREQ      'N'                                                       BUG3112
     C     RCSI          ANDEQ     'Y'                                                       BUG3112
     C                   MOVE      'N'           WCOMAV                                      BUG3112
     C                   ENDIF                                                               BUG3112
      *                                                                                      BUG3112
     C     PTYP          IFEQ      66
     C*****RCSI*         ANDEQ     'Y'                                                       BUG3112
     C     WCOMAV        ANDEQ     'N'                                                       BUG3112
     C     LPFI          ANDEQ     *BLANK
     C     CLE005        OREQ      'Y'
     C     PTYP          ANDEQ     69
     C*****RCSI*         ANDEQ     'Y'                                                       BUG3112
     C     WCOMAV        ANDEQ     'N'                                                       BUG3112
     C     LPFI          ANDEQ     *BLANK
     C*****RCSI*         OREQ      'Y'                                                       BUG3112
     C     WCOMAV        OREQ      'N'                                                       BUG3112
     C     LPFI          ANDNE     *BLANK
     C     WPART         ANDEQ     'N'
     C                   ELSE
      *
      ***  LOOPZ is not to be executed if the customer is a branch
      ***  internal customer number.
      *
      ***  Use CNUM as SCUST may be a customer shortname
      *
     C**********         MOVEL     CNUM          WCNUMN            6 0                        CSD027
     C                   MOVEL     CNUM          WCNUMN            6                          CSD027
      *
     C                   Z-ADD     1             I
     C     WCNUMN        LOOKUP    @BIC(I)                                99
      *
      ***  Indicator 99 will be on if the customer was an internal cust.
      *
     C     *IN99         IFEQ      *OFF
      *
     C                   Z-ADD     1             Z                 2 0
     C     Z             DOWLT     11
      *
     C     DAYNO         LOOKUP    RUNS(Z)                            61  61
     C     *IN61         IFEQ      *OFF
     C                   LEAVE
     C                   ELSE
     C                   IF        CLE025 = 'N'                                               CLE025
     C  N63OAM(Z)        SUB       WFCBAL        OAM(Z)
     C   63OAM(Z)        ADD       WFCBAL        OAM(Z)
     C                   ENDIF                                                                CLE025
     C     Z             ADD       1             Z
     C                   ENDIF
      *
      ***  If CLE009 is installed, set Work Regeneration Indicator to
      ***  changed
      *
     C     CLE009        IFEQ      'Y'
     C                   MOVE      'C'           WKSWRI            1
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ELSE
      *
     C                   SETOFF                                       99
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                      BUG3760
      * SRBLDA - Build array used for storing fields in Compliance    *                      BUG3760
      *          Watch.                                               *                      BUG3760
      *****************************************************************                      BUG3760
     C     SRBLDA        BEGSR                                                               BUG3760
                                                                                             BUG3760
     C                   MOVEA     *BLANKS       WLF(1)                                      BUG3760
     C                   MOVEL     'N'           WNBLNK                                      BUG3760
                                                                                             BUG3760
     C     RONS          IFNE      *BLANKS                                                   BUG3760
     C     RIBN          ORNE      *BLANKS                                                   BUG3760
     C*****ROBN*         ORNE      *ZERO                                              BUG3760 CSD027
     C*****ROCN*         ORNE      *ZERO                                              BUG3760 CSD027
     C     ROBN          ORNE      *BLANKS                                                    CSD027
     C     ROCN          ORNE      *BLANKS                                                    CSD027
     C     PONS          ORNE      *BLANKS                                                   BUG3760
     C     PIBN          ORNE      *BLANKS                                                   BUG3760
     C*****POBN*         ORNE      *ZERO                                              BUG3760 CSD027
     C*****POCN*         ORNE      *ZERO                                              BUG3760 CSD027
     C     POBN          ORNE      *BLANKS                                                    CSD027
     C     POCN          ORNE      *BLANKS                                                    CSD027
     C     RCRN          ORNE      *BLANKS                                                   BUG3760
     C     RVNO          ORNE      *BLANKS                                                   BUG3760
     C     AWBN          ORNE      *BLANKS                                                   BUG3760
     C     BENN          ORNE      *BLANKS                                                   BUG3760
     C     DTP1          ORNE      *BLANKS                                                   BUG3760
     C     DTP2          ORNE      *BLANKS                                                   BUG3760
     C     DTP3          ORNE      *BLANKS                                                   BUG3760
     C     DTP4          ORNE      *BLANKS                                                   BUG3760
                                                                                             BUG3760
     C                   MOVEL     'Y'           WNBLNK                                      BUG3760
     C                   MOVEL     'Y'           WDTPC                                       BUG3760
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
     C                   ENDIF                                                               BUG3760
     C                   ENDSR                                                               BUG3760
      *****************************************************************                      BUG3760
      /EJECT                                                                                 BUG3760
      *****************************************************************                      BUG3760
      * SRWTCH - Performs the Watch list processing.                 *                       BUG3760
      *****************************************************************                      BUG3760
     C     SRWTCH        BEGSR                                                               BUG3760
      *                                                                                      BUG3760
      ** PARAMETER 2:                                                                        BUG3760
     C                   CLEAR                   PARMDS                                      BUG3760
     C                   Z-ADD     0             WID               2 0                       BUG3760
                                                                                             BUG3760
     C     WID           DOUEQ     12                                                        BUG3760
     C                   ADD       1             WID                                         BUG3760
     C                   MOVEL     WLF(WID)      PINP1                                       BUG3760
                                                                                             BUG3760
     C     WLF(WID)      IFNE      *BLANKS                                                   BUG3760
     C     WLF(WID)      ANDNE     '000000'                                                  BUG3760
                                                                                             BUG3760
     C     SCCY          IFNE      *BLANKS                                                   BUG3760
     C                   MOVEL     SCCY          PCCY                                        BUG3760
     C                   ELSE                                                                BUG3760
     C                   MOVEL     CCY           PCCY                                        BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   CALL      'SDCWLFMT'                                                BUG3760
     C                   PARM                    PRTCD             7                         BUG3760
     C                   PARM                    PINP1            35                         BUG3760
     C                   PARM      *BLANKS       PINP2            35                         BUG3760
     C                   PARM      *BLANKS       PINP3            35                         BUG3760
     C                   PARM      *BLANKS       PINP4            35                         BUG3760
     C                   PARM      *BLANKS       PINP5            35                         BUG3760
     C                   PARM      *BLANKS       PINP6            35                         BUG3760
     C                   PARM      CCY           PCCY              3                         BUG3760
     C                   PARM                    POUT            216                         BUG3760
     C                   PARM                    PCNUM             6                         BUG3760
                                                                                             BUG3760
     C     POUT          IFNE      *BLANKS                                                   BUG3760
     C                   EXSR      SRCWP2                                                    BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   ENDDO                                                               BUG3760
                                                                                             BUG3760
      ** Add the Payment Details.                                                            BUG3760
                                                                                             BUG3760
     C     DTP1          IFNE      *BLANKS                                                   BUG3760
     C     DTP2          ORNE      *BLANKS                                                   BUG3760
     C     DTP3          ORNE      *BLANKS                                                   BUG3760
     C     DTP4          ORNE      *BLANKS                                                   BUG3760
      *                                                                                      BUG3760
     C     WDTPC         IFEQ      'Y'                                                       BUG3760
      *                                                                                      BUG3760
     C                   CAT       CWA(25):0     PARMDS                                      BUG3760
     C                   CAT       DTP1:0        PARMDS                                      BUG3760
     C                   CAT       DTP2:1        PARMDS                                      BUG3760
     C                   CAT       DTP3:1        PARMDS                                      BUG3760
     C                   CAT       DTP4:1        PARMDS                                      BUG3760
     C                   CAT       CWA(26):0     PARMDS                                      BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
      **  Set up parameter 1 and send details to engine only if                              BUG3760
      **  PARMDS is not empty.                                                               BUG3760
      *                                                                                      BUG3760
     C     PARMDS        IFNE      *BLANKS                                                   BUG3760
      *                                                                                      BUG3760
      ** PARAMETER 1:                                                                        BUG3760
      ** Item Type Code                                                                      BUG3760
     C                   MOVEL     'LESCHD'      W4ITEM                                      BUG3760
      *                                                                                      BUG3760
      ** Identifier                                                                          BUG3760
     C                   MOVEL     *BLANKS       WLNRF                                       BUG3760
     C                   MOVEL     *BLANKS       WVDAT                                       BUG3760
     C                   MOVEL     *BLANKS       WLASN                                       BUG3760
     C                   MOVEL     *BLANKS       W4IDEN                                      BUG3760
      *                                                                                      BUG3760
     C                   MOVE      LNRF          WLNRF             6                         BUG3760
     C                   MOVE      VDAT          WVDAT             5                         BUG3760
     C                   MOVE      LASN          WLASN             3                         BUG3760
     C     WLNRF         CAT       WVDAT:0       W4IDEN                                      BUG3760
     C                   CAT       WLASN:0       W4IDEN                                      BUG3760
      *                                                                                      BUG3760
      ** Branch                                                                              BUG3760
     C                   MOVEL     BRCA          W4BRCH                                      BUG3760
      *                                                                                      BUG3760
      ** System                                                                              BUG3760
      ** If Midas 24x7 is installed, use Main system prefix otherwise use system prefix      BUG3760
     C     CSC011        IFEQ      'Y'                                                       BUG3760
     C                   MOVE      S1MAIN        W4SYSM                                      BUG3760
     C                   ELSE                                                                BUG3760
     C                   MOVE      LIBR          W4SYSM                                      BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
      ** Function Type                                                                       BUG3760
     C                   MOVEL     'LOAMSDK'     W4FUNT                                      BUG3760
      *                                                                                      BUG3760
      ** Counter Party                                                                       BUG3760
     C                   MOVE      PCNUM         WCNUM             6                         BUG3760
     C                   CALL      'AOCUSTR0'                                                BUG3760
     C                   PARM      *BLANKS       PRTCD                                       BUG3760
     C                   PARM      '*KEY   '     POPTN                                       BUG3760
     C                   PARM      WCNUM         PCUST            10                         BUG3760
     C                   PARM                    PKYST             7                         BUG3760
     C     SDCUST        PARM      SDCUST        DSSDY                                       BUG3760
      *                                                                                      BUG3760
     C     PRTCD         IFEQ      *BLANKS                                                   BUG3760
     C     BBCRNM        CAT       BBCRTN        W4CUST                                      BUG3760
     C                   MOVE      PCNUM         W4CNUM                                      BUG3760
      *                                                                                      BUG3760
     C     CCF001        IFEQ      'Y'                                                       BUG3760
      *                                                                                      BUG3760
     C     BBCRPC        IFEQ      'Y'                                                       BUG3760
     C                   MOVE      'C'           W4CTYP                                      BUG3760
     C                   ELSE                                                                BUG3760
     C                   MOVE      'I'           W4CTYP                                      BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ELSE                                                                BUG3760
      *                                                                                      BUG3760
     C     BBLICD        IFNE      *BLANK                                                    BUG3760
     C     BBLICD        ANDNE     W1IND1                                                    BUG3760
     C     BBLICD        ANDNE     W1IND2                                                    BUG3760
     C     BBLICD        ANDNE     W1IND3                                                    BUG3760
     C     BBLICD        ANDNE     W1IND4                                                    BUG3760
     C     BBLICD        ANDNE     W1IND5                                                    BUG3760
     C                   MOVE      'C'           W4CTYP                                      BUG3760
      *                                                                                      BUG3760
     C                   ELSE                                                                BUG3760
     C                   MOVE      'I'           W4CTYP                                      BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
      ** Deal Date                                                                           BUG3760
     C                   MOVE      *ZERO         W4DDAT                                      BUG3760
      *                                                                                      BUG3760
      ** Value Date                                                                          BUG3760
     C                   Z-ADD     VDATA         W4VDAT                                      BUG3760
      *                                                                                      BUG3760
      ** Maturity Date                                                                       BUG3760
     C                   MOVE      *ZERO         W4MDAT                                      BUG3760
      *                                                                                      BUG3760
      ** Denomination Side 1                                                                 BUG3760
     C                   MOVEL     CCY           W4DEN1                                      BUG3760
     C                   MOVE      *BLANKS       W4DEN2                                      BUG3760
      *                                                                                      BUG3760
      ** Amount Side 1                                                                       BUG3760
     C     TAMT          MULT      100           W4AMT1                                      BUG3760
     C                   MOVE      *ZERO         W4AMT2                                      BUG3760
      *                                                                                      BUG3760
      *                                                                                      BUG3760
      ** Send transaction details to Compliance Watch by calling SDWLCLOP                    BUG3760
      *                                                                                      BUG3760
     C                   CALL      'SDWLCLOP'                                                BUG3760
     C                   PARM                    CWLCDS                                      BUG3760
     C                   PARM                    PARMDS                                      BUG3760
      *                                                                                      BUG3760
     C                   ENDIF                                                               BUG3760
      *                                                                                      BUG3760
     C                   ENDSR                                                               BUG3760
      *****************************************************************                      BUG3760
      *  SRCWP2  -  Set up the 2nd parameter for Compliance Watch.    *                      BUG3760
      *****************************************************************                      BUG3760
     C     SRCWP2        BEGSR                                                               BUG3760
      *                                                                                      BUG3760
     C     WID           MULT      2             CLS               2 0                       BUG3760
     C     CLS           SUB       1             OPN               2 0                       BUG3760
      *                                                                                      BUG3760
     C                   MOVEL     CWA(OPN)      WOPN             25                         BUG3760
     C                   MOVEL     CWA(CLS)      WCLS             25                         BUG3760
      *                                                                                      BUG3760
     C     PARMDS        CAT       WOPN:0        PARMDS                                      BUG3760
     C                   CAT       POUT:0        PARMDS                                      BUG3760
      *                                                                                      BUG3760
     C                   SELECT                                                              BUG3760
     C     WID           WHENEQ    2                                                         BUG3760
     C                   CAT       RIBA:0        PARMDS                                      BUG3760
     C     WID           WHENEQ    6                                                         BUG3760
     C                   CAT       PIBA:0        PARMDS                                      BUG3760
     C     WID           WHENEQ    9                                                         BUG3760
     C                   CAT       RCRA:0        PARMDS                                      BUG3760
     C     WID           WHENEQ    11                                                        BUG3760
     C                   CAT       AWBA:0        PARMDS                                      BUG3760
     C     WID           WHENEQ    12                                                        BUG3760
     C                   CAT       BENA:0        PARMDS                                      BUG3760
     C                   ENDSL                                                               BUG3760
      *                                                                                      BUG3760
     C                   CAT       WCLS:0        PARMDS                                      BUG3760
      *                                                                                      BUG3760
     C                   ENDSR                                                               BUG3760
      *****************************************************************                      BUG3760
      /EJECT                                                                                 BUG3760
      *****************************************************************
      * SRFEES -                                                      *
      *****************************************************************
     C     SRFEES        BEGSR
      *
      ***  If authorisation switchable feature is on and action code
      ***  is insert or amend and Repayment Schedules Authorisations is
      ***  required
      *
     C     CLE002        IFEQ      'Y'
     C     RPCHTP        ANDNE     'X'
     C     RPCHTP        ANDNE     'R'
     C     BPREAU        ANDEQ     'Y'
      *
      ***  If action code is insert
      *
     C     RPCHTP        IFEQ      'I'
      *
      ***  Write a record to Loan Amendment Fee Index File
      *
     C                   MOVE      RPLNRF        FFLNRF
     C                   Z-ADD     RPVDAT        FFVDAT
     C                   MOVE      WLLASN        FFLASN
     C                   MOVE      *BLANKS       FFAUTH
     C                   MOVE      WKSWRI        FFSWRI
     C                   WRITE     LEFELAD0
      *
     C                   ENDIF
      *
      ***  If action code is amend
      *
     C     RPCHTP        IFEQ      'A'
      *
      ***  Chain to Loan Amendment Fee Index File
      *
     C                   MOVE      RPLNRF        WKLOAN
     C                   Z-ADD     RPVDAT        WKDATE
     C                   MOVE      RPLASN        WKSEQN
     C     KIDXF         CHAIN     LEFELAL0                           99
      *
      ***  If record not found
      *
     C     *IN99         IFEQ      *ON
      *
      ***  Write a record to Loan Fee Index File
      *
     C                   MOVE      RPLNRF        FFLNRF
     C                   Z-ADD     RPVDAT        FFVDAT
     C                   MOVE      RPLASN        FFLASN
     C                   MOVE      'Y'           FFAUTH
     C                   MOVE      WKSWRI        FFSWRI
     C                   WRITE     LEFELAD0
      *
     C                   ELSE
      *
      ***  If work regeneration indicator is changed and regeneration
      ***  indicator is blank
      *
     C     WKSWRI        IFEQ      'C'
     C     FFSWRI        ANDEQ     *BLANKS
      *
      ***  Update the record to Loan Amendment Fee Index File
      *
     C                   MOVE      WKSWRI        FFSWRI
     C                   UPDATE    LEFELAD0
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
      ***  If action code is authorise
      *
     C     RPCHTP        IFEQ      'X'
      *
      ***  Chain to Loan Amendment Fee Index File
      *
     C                   MOVE      RPLNRF        WKLOAN
     C                   Z-ADD     RPVDAT        WKDATE
     C                   MOVE      RPLASN        WKSEQN
     C     KIDXF         CHAIN     LEFELAL0                           99
      *
      ***  If record is found
      *
     C     *IN99         IFEQ      *OFF
      *
      ***  Update the record to Loan Amendment Fee Index File
      *
     C                   MOVE      FFSWRI        WKSWRI
     C                   MOVE      'Y'           FFAUTH
     C                   UPDATE    LEFELAD0
     C                   ENDIF
      *
     C                   ENDIF
      *
      ***  If action code is reverse
      *
     C     RPCHTP        IFEQ      'R'
      *
      ** Chain to Loan Amendment Fee Index File
      *
     C                   MOVE      RPLNRF        WKLOAN
     C                   Z-ADD     RPVDAT        WKDATE
     C                   MOVE      RPLASN        WKSEQN
     C     KIDXF         CHAIN     LEFELAL0                           99
      *
      ***  If record is found
      *
     C     *IN99         IFEQ      *OFF
      *
      ***  If authorised is blank
      *
     C     FFAUTH        IFEQ      *BLANKS
     C                   MOVE      *BLANKS       WKSWRI
     C                   ELSE
      *
      ***  If work regeneration indicator is blank
      *
     C     WKSWRI        IFEQ      *BLANKS
     C                   MOVE      FFSWRI        WKSWRI
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
     C                   MOVEL     *BLANKS       WFLOAN                                       CLE148
     C     WKFEE         SETLL     LEFEEDL1
     C*****WKFEE         READE     LEFEEDL1                               19                MD054035
     C     WKFEE         READE (N) LEFEEDL1                               19                MD054035
      *
      ***  Do while an associated fee exists
      *
     C     *IN19         DOWEQ     *OFF
      *
      ***  If the fee is a confirmed calculated fee and swift
      ***  regeneration indicator is not 'I', 'B', 'H'
      *
     C     FEAUTO        IFEQ      'Y'
     C     FECALT        ANDNE     *BLANKS
     C     FESWRI        ANDNE     'I'
     C     FESWRI        ANDNE     'B'
     C     FESWRI        ANDNE     'H'
      *
      ***  Set currency to fee currency
      ***  Set day to run date
      ***  Set number of working days to telex notice days
      *
     C                   MOVE      FEFCCY        ZCCY              3
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   Z-ADD     1             Y                 3 0
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
     C*****FEFCCY        LOOKUP    CYA(Y)                                 20                MD054317
     C     WKCCY         LOOKUP    CYA(Y)                                 20                MD054317
     C                   MOVE      *OFF          *IN20
     C                   MOVE      TND(Y)        ZNRDYS
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
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @CUSN             6
     C**********         PARM      FEFCCY        @CURR             3                        MD054317
     C                   PARM                    @CURR             3                        MD054317
     C**********         PARM                    @ACCD             4                          CGL029
     C                   PARM                    @ACCD                                        CGL029
     C                   PARM                    @ACSN             2
     C                   PARM      FEOURS        @NONB             2
     C                   PARM                    @BRCA
     C                   PARM                    @CSSN            10
     C                   PARM                    @PNOI             1
     C     SDNOST        PARM      SDNOST        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'AONOSTR0'    DBFILE                         *************
     C                   Z-ADD     16            DBASE                          * DBERR 016 *
     C                   MOVEL     FEFCCY        DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
      ***  Set Location to Nostro Location
      *
     C                   MOVE      A7NOSN        ZLOC              3
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
      ** Set Telex Notice date to day number
      *
     C                   Z-ADD     ZDYNBR        TXDT              5 0
      *                                                                                     MD054035
     C                   MOVEL     FECNUM        WFCNUMX                                    MD054035
     C                   MOVEL     FEFACL        WFFACLX                                    MD054035
     C                   MOVEL     FELOAN        WFLOANX                                    MD054035
     C                   MOVEL     FEFSEQ        WFSEQNX                                    MD054035
      *
      ***  If next payment date is before or equals to Telex Notice date
      ***  and Next Payment Telex indicator is set to 'Y'
      *
     C     FENPYD        IFLE      TXDT
     C     FEPPTI        ANDEQ     'Y'
      *
      ***  Update Fees file
      *
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
      *
      ***  If end date is before or equals to Telex Notice date and End
      ***  Telex indicator is set to 'Y'
      *
     C     FEPEND        IFLE      TXDT
     C     FEEPTI        ANDEQ     'Y'
      *
      ***  Update Fees file
      *
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
     C*****WKFEE         READE     LEFEEDL1                               19                MD054035
     C     WKFEE         READE (N) LEFEEDL1                               19                MD054035
     C                   ENDDO
      *                                                                                       CLE073
      ** Check if the loan has an associated fee                                              CLE073
      *                                                                                       CLE073
     C                   IF        CLE073 = 'Y'                                               CLE073
     C                   EXSR      CHKLON                                                     CLE073
     C                   EndIf                                                                CLE073
     C                   ENDIF
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       WKSWRI
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SRUPTR - Update Loan Amendments Trailer                       *
      *****************************************************************
     C     SRUPTR        BEGSR
      *
      ***  Update Loan Amendments Trailer, No action for amendments
      *
     C     RPCHTP        IFEQ      'I'
     C     RPCHTP        OREQ      'R'
      *
     C                   MOVE      '999999'      WLLOAN
     C                   MOVE      '99999'       WLVDAT
     C                   MOVE      '999'         WLLASN
      *
     C     MTHREAD       IFEQ      'N'                                                      MD024342
     C     WKLAM         CHAIN     LOAMS                              99
      *
     C     *IN99         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'LOAMS   '    DBFILE                         *************
     C                   Z-ADD     17            DBASE                          * DBERR 017 *
     C                   MOVEL     '999999'      DBKEY                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF                                                              MD024342
      *
      ***  Action not Reversal
      *
     C     RPCHTP        IFNE      'R'
                                                                                            MD024342
     C                   IF        MTHREAD = 'Y'                                            MD024342
     C                   EXSR      Initialise                                               MD024342
     C                   ENDIF                                                              MD024342
     C     NORE          ADD       1             NORE
     C     NINS          ADD       1             NINS
     C     NLRA          ADD       1             NLRA
      *
     C*****REPT*         IFNE      1                                                       AR1031116
     C                   MOVE      WLAMT         ZZAMT
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
     C**********         ENDIF                                                             AR1031116
     C                   ELSE
                                                                                            MD024342
     C                   IF        MTHREAD = 'Y'                                            MD024342
     C                   EXSR      Initialise                                               MD024342
     C                   ENDIF                                                              MD024342
      *
      ***  Reverse action code
      *
     C                   MOVE      TAMT          ZZAMT            15 3
      *
     C     NDEL          ADD       1             NDEL
     C     NLRA          SUB       1             NLRA
      *
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
     C                   Z-ADD     P@NATN        TNLU
      *
     C                   IF        MTHREAD = 'N'                                            MD024342
     C                   UPDATE    LOAMSZ1F
     C                   ELSE                                                               MD024342
     C                   MOVEL     'D'           RECI                                       MD024342
     C                   Z-ADD     BJRDNB        LCD                                        MD024342
     C                   MOVE      'I'           CHTP                                       MD024342
     C                   Z-ADD     P@NATN        TNLU                                       MD024342
     C**********         WRITE     LOAMSZ1F                                       MD024342 MD024342B
     C**********         WRITE     LOAMSZ1FX                                      MD024342B MD025467
     C                   WRITE     LOAMSZ1F                                                 MD025467
     C                   ENDIF                                                              MD024342
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GLZADD   - Add an amount to the total                         *
      *****************************************************************
     C     GLZADD        BEGSR
      *
     C     ZZAMT         IFNE      0
      *
      ***  Split ZZAMT into integer and decimal fields
      *
     C                   Z-ADD     ZZAMT         ZZAMTI           15 0          Integer
     C                   MOVE      ZZAMT         ZZAMTD            3 0          Decimal
      *
      ***  Both ZZAMTI and ZZAMTD contain a 'sign' zone now
      *
     C                   EXSR      GLZSUM
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GLZSUB   - Subroutine to subtract an amount to the total      *
      *****************************************************************
     C     GLZSUB        BEGSR
      *
      ** Processing - Just reverse the 'sign' and add
      *
     C                   Z-SUB     ZZAMT         ZZAMT            15 3          Reverse 'sign'
     C                   EXSR      GLZADD                                         and 'add'
     C                   Z-SUB     ZZAMT         ZZAMT                          Restore 'sign'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * GLZSUM   - Carry out the additon for subroutine               *
      *****************************************************************
     C     GLZSUM        BEGSR
      *
     C                   Z-ADD     ZZTOTI        ZZTOTI           15 0
     C                   Z-ADD     ZZTOTD        ZZTOTD            3 0
     C                   SETOFF                                       919293
     C                   SETOFF                                       949599
      *
      ***  Determine sign of ZZAMTI & D,  92 if neg
      *
     C     ZZAMTI        COMP      0                                    9293
     C   93ZZAMTD        COMP      0                                    9293
     C   93              GOTO      ZZSEND                                       ZERO BYPASS
      *
      ***  Determine sign of ZZTOTI & D, 91 if neg
      *
     C     ZZTOTI        COMP      0                                    9193
     C   93ZZTOTD        COMP      0                                    9193
      *
      ***  If ZZTOTAL is zero, return ZZAMOUNT
      *
     C   93              Z-ADD     ZZAMTI        ZZTOTI
     C   93              Z-ADD     ZZAMTD        ZZTOTD
     C   93              GOTO      ZZSEND                                       ZERO BYPASS
      *
      ***  If signs differ, bypass overflow checks
      *
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
      ***  If the modulus of ZZWK3 is lt mod. ZZTOTI then O/F has occured
      *
     C  N92ZZWK3         COMP      ZZTOTI                               99      -92 MEANS NOS.
     C   92ZZWK3         COMP      ZZTOTI                             99         NEGATIVE
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
     C     ZZOFPS        TAG                                                    ***  ZZOFPS ***
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
     C                   ENDSR
      ********************************************************************
      /EJECT                                                                                  CRE020
      *****************************************************************                       CRE020
      *                                                               *                       CRE020
      *  SRIdxTrn - Handles the advice index of the current           *                       CRE020
      *             transaction.                                      *                       CRE020
      *                                                               *                       CRE020
      *****************************************************************                       CRE020
     C     SRIdxTrn      BEGSR                                                                CRE020
      *                                                                                       CRE020
     C                   EVAL      KRefNo = *BLANKS                                           CRE020
     C                   EVAL      KSeqNo = *BLANKS                                           CRE020
     C                   MOVEL     RPLNRF        KRefNo                                       CRE020
     C                   MOVEL     RPLASN        KSeqNo                                       CRE020
      *                                                                                       CRE020
     C                   OPEN      READVCL2                                                   CRE020
      *                                                                                       CRE020
     C     KADVC         CHAIN     READVCL2                                                   CRE020
      *                                                                                       CRE020
     C                   IF        %FOUND (READVCL2)                                          CRE020
      *                                                                                       CRE020
      ** Check first if the record was just inserted                                          CRE020
      *                                                                                       CRE020
     C                   IF        RCHTYP = 'I' AND                                           CRE020
     C                             RSAPIN <>'Y'                                               CRE020
     C                   SELECT                                                               CRE020
                                                                                              CRE020
     C                   WHEN      WSCHTP = 'R'                                               CRE020
     C                   EVAL      RCHTYP = 'D'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'Y'                                               CRE020
     C                   UPDATE    READVCD0                                                   CRE020
      *                                                                                       CRE020
      ** If transaction was authorised, set the authorise indicator to 'Y'                    CRE020
      *                                                                                       CRE020
     C                   WHEN      ASTS   = 'A'                                               CRE020
     C                   IF        RAUTHI = 'N'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   UPDATE    READVCD0                                                   CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CRE020
     C                   OTHER                                                                CRE020
     C                   IF        RSAPIN = 'N'                                               CRE020
     C                   EVAL      RAUTHI = 'N'                                               CRE020
     C                   UPDATE    READVCD0                                                   CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDSL                                                                CRE020
      *                                                                                       CRE020
     C                   ELSE                                                                 CRE020
      *                                                                                       CRE020
      ** If existing transaction was amended, authorised or deleted, update Last Change       CRE020
      ** Type, Authorise Indicator and Print Advice Indicator                                 CRE020
      *                                                                                       CRE020
     C                   IF        WSCHTP <>'X'                                               CRE020
     C                   EVAL      RCHTYP = WSCHTP                                            CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CRE020
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
      *                                                                                       CRE020
     C                   UPDATE    READVCD0                                                   CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CRE020
     C                   CLOSE     READVCL2                                                   CRE020
      *                                                                                       CRE020
     C                   ENDSR                                                                CRE020
      *****************************************************************                       CRE020
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
     C                   MOVEL     RPLNRF        WFLOAN                                       CLE073
     C     WKFEE         SETLL     LEFEEDL1                                                   CLE073
     C*****WKFEE         READE     LEFEEDL1                               19         CLE073 MD054035
     C     WKFEE         READE (N) LEFEEDL1                               19                MD054035
      *                                                                                       CLE073
      ** Do while an associated fee exists                                                    CLE073
      *                                                                                       CLE073
     C     *IN19         DOWEQ     *OFF                                                       CLE073
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
     C     RPVDAT        ANDGE     FEPSTD                                                     CLE073
     C     RPVDAT        ANDLE     FEPEND                                                     CLE073
      *                                                                                       CLE073
      ** Set currency to fee currency                                                         CLE073
      ** Set day to run date                                                                  CLE073
      ** Set number of working days to telex notice days                                      CLE073
      *                                                                                       CLE073
     C                   MOVE      FEFCCY        ZCCY                                         CLE073
     C                   Z-ADD     BJRDNB        ZDAYNO                                       CLE073
     C                   Z-ADD     1             X                 3 0                        CLE073
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
     C                   PARM                    @Curr             3                        MD054317
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
      *                                                                                     MD054035
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
     C*****WKFEE         READE     LEFEEDL1                               19         CLE073 MD054035
     C     WKFEE         READE (N) LEFEEDL1                               19                MD054035
     C                   ENDDO                                                                CLE073
      *                                                                                       CLE073
     C                   ENDSR                                                                CLE073
      *                                                                                       CLE073
      *****************************************************************                       CLE073
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
     C                   EVAL      VRAF = 0                                                 MD024342
     C                   EVAL      VRAL = 0                                                 MD024342
     C                   EVAL      VRRF = 0                                                 MD024342
     C                   EVAL      VRRL = 0                                                 MD024342
      *                                                                                     MD024342
     C                   ENDSR                                                              MD024342
      *****************************************************************                     MD024342
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ***  Copyright
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ***  Program Parameters
      *
     C     *ENTRY        PLIST
      *
      * Inputs
      * ======
      ***  Return Code
     C                   PARM                    @@RTCD            7
      *
      ***  Externally described DS for valid repayment schedule
     C                   PARM                    LEVRpSc
      *
      ***  Old settlement details
     C                   PARM                    OldStsDS
      *
      ***  New settlement details
     C                   PARM                    NewStsDS
      *
      ***  Data
     C                   PARM                    PasDtaDS
      *
      * Outputs
      * =======
      * Field OK flags
     C                   PARM                    OKFlagsDS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
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
     C                   MOVEL     'SDBANKPD'    DBFILE                         * DBERR 018 *
     C                   Z-ADD     18            DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
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
     C                   MOVEL     'SDCLNDPD'    DBFILE                         * DBERR 019 *
     C                   Z-ADD     19            DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
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
     C                   MOVEL     'SDMMODPD'    DBFILE                         * DBERR 020 *
     C                   Z-ADD     20            DBASE                          *************
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C/COPY WNCPYSRC,LEH01198
      *
      ***  Define Key Lists
      *
      ** Loan Amendments
      *
     C     WKLAM         KLIST
     C**********         KFLD                    WLLOAN            6 0                        CLE148
     C                   KFLD                    WLLOAN            6                          CLE148
     C                   KFLD                    WLVDAT            5 0
     C                   KFLD                    WLLASN            3 0
      *
      ***  Loans
      *
     C     WKLON         KLIST
     C**********         KFLD                    WCLOAN            6 0                        CLE148
     C                   KFLD                    WCLOAN            6                          CLE148
     C                   KFLD                    WCRCDT            1
      *
      ***  Facility
      *
     C     WKFAC         KLIST
     C**********         KFLD                    WFCNUM            6 0                        CSD027
     C                   KFLD                    WFCNUM            6                          CSD027
     C                   KFLD                    WFFACT            3 0
     C                   KFLD                    WFFCNO            2 0
     C                   KFLD                    WFRCTP            1
      *                                                                                      245177A
     C     KFCAM         KLIST                                                               245177A
     C                   KFLD                    WFCNUM                                      245177A
     C                   KFLD                    WFFACT                                      245177A
     C                   KFLD                    WFFCNO                                      245177A
      *
      ***  Keylist for loan amendment fee index file
      *
     C     KIDXF         KLIST
     C**********         KFLD                    WKLOAN            6 0                        CLE148
     C                   KFLD                    WKLOAN            6                          CLE148
     C                   KFLD                    WKDATE            5 0
     C                   KFLD                    WKSEQN            3 0
      *
      ***  Key list for Fees file
      *
     C     WKFEE         KLIST
     C**********         KFLD                    WFCNUM            6 0                        CSD027
     C                   KFLD                    WFCNUM            6                          CSD027
     C                   KFLD                    WFFACL            5 0
     C**********         KFLD                    WFLOAN            6 0                        CLE148
     C                   KFLD                    WFLOAN            6                          CLE148
      *                                                                                     MD054035
     C     WKFEEX        KLIST                                                              MD054035
     C                   KFLD                    WFCNUMX           6                        MD054035
     C                   KFLD                    WFFACLX           5 0                      MD054035
     C                   KFLD                    WFLOANX           6                        MD054035
     C                   KFLD                    WFSEQNX           2 0                      MD054035
      *                                                                                       CRE020
      ** Midas RE Settled Transaction Index File Key List                                     CRE020
      *                                                                                       CRE020
     C     KADVC         KLIST                                                                CRE020
     C                   KFLD                    KRefNo                                       CRE020
     C                   KFLD                    KPrgMn                                       CRE020
     C                   KFLD                    KSeqNo                                       CRE020
      *                                                                                      BUG3760
      ** Used for Compliance Watch                                                           BUG3760
      *                                                                                      BUG3760
     C     CWHTKY        KLIST                                                               BUG3760
     C                   KFLD                    KFUNT             8                         BUG3760
     C                   KFLD                    KIDEN            40                         BUG3760
     C                   KFLD                    KBRCH             3                         BUG3760
      **********                                                                   MD024342 MD025467
     C*****KAPILST       KLIST                                                     MD024342 MD025467
     C**********         KFLD                    WAPIC             4               MD024342 MD025467
     C**********         KFLD                    WFILN            10               MD024342 MD025467
      *
      ***  Determine if the features are installed
      *
     C                   MOVEL     'N'           CEU004            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU004'      @SARD
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU004
     C                   END
      *
     C                   MOVEL     'N'           CLE002            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE002
     C                   END
      *
     C                   MOVEL     'N'           CEU020            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU020'      @SARD
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU020
     C                   END
      *
     C                   MOVEL     'N'           S01465            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01465'      @SARD
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           S01465
     C                   END
      *
     C                   MOVEL     'N'           CLE009            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE009'      @SARD
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE009
     C                   END
      *
     C                   MOVEL     'N'           CDE001            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CDE001'      @SARD
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CDE001
     C                   END
      *
     C                   MOVEL     'N'           CLE005            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE005
     C                   END
      *
     C                   MOVEL     'N'           CLE014            1
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE014
     C                   END
      *                                                                                      BUG3112
     C                   MOVEL     'N'           CLE023            1                         BUG3112
     C                   CALLB     'AOSARDR0'                                                BUG3112
     C                   PARM      *BLANKS       @RTCD                                       BUG3112
     C                   PARM      '*VERIFY'     @OPTN                                       BUG3112
     C                   PARM      'CLE023'      @SARD                                       BUG3112
     C     @RTCD         IFEQ      *BLANKS                                                   BUG3112
     C                   MOVE      'Y'           CLE023                                      BUG3112
     C                   END                                                                 BUG3112
      *                                                                                       CRE020
      ** Check if CRE020 is enabled.                                                          CRE020
      *                                                                                       CRE020
     C                   CALLB     'AOSARDR0'                                                 CRE020
     C                   PARM      *BLANKS       @RTCD                                        CRE020
     C                   PARM      '*VERIFY'     @OPTN                                        CRE020
     C                   PARM      'CRE020'      @SARD                                        CRE020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE020
      *                                                                                       CRE020
     C                   EVAL      CRE020 = 'N'                                               CRE020
      *                                                                                       CRE020
     C                   IF        @RTCD = *BLANKS                                            CRE020
     C                   EVAL      CRE020 = 'Y'                                               CRE020
     C                   ELSE                                                                 CRE020
      *                                                                                       CRE020
     C                   IF        @RTCD <> '*NRF'                                            CRE020
     C     *LOCK         IN        LDA                                                        CRE020
     C                   EVAL      DBFile = 'SCSARDPD'                                        CRE020
     C                   EVAL      DBase = 40                                                 CRE020
     C                   EVAL      DBKey = 'CRE020'                                           CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      *PSSR                                                      CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CRE020
      ** Check if a System Value exists for this maintenance.                                 CRE020
      *                                                                                       CRE020
     C                   IF        CRE020 = 'Y'                                               CRE020
      *                                                                                       CRE020
     C                   CALLB     'AOSVALR0'                                                 CRE020
     C                   PARM      *BLANKS       @RTCD                                        CRE020
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
      *                                                                                       CRE020
     C                   IF        @RTCD = *BLANKS                                            CRE020
     C                   MOVEL     PCurSet01     WSysVal01                                    CRE020
     C                   ELSE                                                                 CRE020
      *                                                                                       CRE020
     C                   IF        @RTCD <> '*NRF'                                            CRE020
     C     *LOCK         IN        LDA                                                        CRE020
     C                   EVAL      DBFile = 'SDSVALPD'                                        CRE020
     C                   EVAL      DBase = 41                                                 CRE020
     C                   EVAL      DBKey = PSysVal01                                          CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      *PSSR                                                      CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CRE020
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
     C                   Z-ADD     22            DBASE                                        CLE025
     C                   EXSR      *PSSR                                                      CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
     C                   IF        PRTCD = *BLANKS                                            CLE025
     C                   MOVE      'Y'           CLE025                                       CLE025
     C                   ENDIF                                                                CLE025
      *                                                                                       CLE154
     C                   MOVEL     'N'           CLE154            1                          CLE154
     C                   CALLB     'AOSARDR0'                                                 CLE154
     C                   PARM      *BLANKS       @RTCD                                        CLE154
     C                   PARM      '*VERIFY'     @OPTN                                        CLE154
     C                   PARM      'CLE154'      @SARD                                        CLE154
     C     @RTCD         IFEQ      *BLANKS                                                    CLE154
     C                   MOVE      'Y'           CLE154                                       CLE154
     C                   END                                                                  CLE154
      *
     C                   Z-ADD     0             I                 3 0
     C                   MOVE      *OFF          *IN99
      *
      ***  First read
      *
     C     *LOVAL        SETLL     SDBRCHL5
     C                   READ      SDBRCHL5                               99
      *
      ***  If no record found on first read end with DB error else
      ***  read branch codes file and build BICN array until EOF
      *
     C     *IN99         IFEQ      *ON
     C                   MOVE      'SDBRCHL5'    DBFILE
     C                   MOVE      *BLANKS       DBKEY                          *************
     C                   Z-ADD     21            DBASE                          * DBERR 021 *
     C                   EXSR      *PSSR                                        *************
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
                                                                                              CLE106
      ** Check if Syndications Manager is available                                           CLE106
                                                                                              CLE106
     C                   EVAL      CLE106 = 'N'                                               CLE106
     C                   CALLB     'AOSARDR0'                                                 CLE106
     C                   PARM      *Blanks       PRTCD                                        CLE106
     C                   PARM      '*VERIFY'     POPTN                                        CLE106
     C                   PARM      'CLE106'      PSARD                                        CLE106
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE106
                                                                                              CLE106
     C                   IF        PRTCD = *Blanks                                            CLE106
     C                   EVAL      CLE106 = 'Y'                                               CLE106
     C                   ENDIF                                                                CLE106
      ** Determine if CLE034 (Lending Enhancements)                                           CLE034
                                                                                              CLE034
     C                   MOVE      'N'           CLE034                                       CLE034
     C                   CALLB     'AOSARDR0'                                                 CLE034
     C                   PARM      *BLANKS       @RTCD                                        CLE034
     C                   PARM      '*VERIFY'     @OPTN                                        CLE034
     C                   PARM      'CLE034'      @SARD                                        CLE034
                                                                                              CLE034
     C     @RTCD         IFEQ      *BLANKS                                                    CLE034
     C                   MOVE      'Y'           CLE034                                       CLE034
     C                   ELSE                                                                 CLE034
     C                   MOVE      'N'           CLE034                                       CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE031
      ** Determine if CLE031 (Lending Enhancements)                                           CLE031
                                                                                              CLE031
     C                   MOVE      'N'           CLE031                                       CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY'     @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
                                                                                              CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVE      'Y'           CLE031                                       CLE031
     C                   ELSE                                                                 CLE031
     C                   MOVE      'N'           CLE031                                       CLE031
     C                   ENDIF                                                                CLE031
      *
      ** Check if Compliance Watch Enhancement (CSD015) is on                                BUG3760
      *                                                                                      BUG3760
     C                   CALLB     'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRTCD                                       BUG3760
     C                   PARM      '*VERIFY'     POPTN                                       BUG3760
     C                   PARM      'CSD015'      PSARD                                       BUG3760
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        PRTCD <> *BLANKS AND                                      BUG3760
     C                             PRTCD <> '*NRF   '                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKey = 'CSD015'                                          BUG3760
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBase = 55                                                BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        PrtCd = *BLANKS                                           BUG3760
     C                   EVAL      CSD015 = 'Y'                                              BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      CSD015 = 'N'                                              BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
                                                                                             BUG3760
      ** Check if function code is being monitored by compliance watch.                      BUG3760
                                                                                             BUG3760
     C                   IF        CSD015 = 'Y'                                              BUG3760
     C                                                                                       BUG3760
     C                   CALLB     'AOWLCCR0'                                                BUG3760
     C                   PARM      *BLANKS       PRtCd                                       BUG3760
     C                   PARM      '*KEY   '     POptn                                       BUG3760
     C                   PARM      'LENDING'     PFUNC             8                         BUG3760
     C     SDWLCC        PARM      SDWLCC        DSFDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        (PRtCd <> *BLANKS)                                        BUG3760
     C                             AND (PRtCd <> '*NRF')                                     BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBFILE = 'SDWLCCPD'                                       BUG3760
     C                   EVAL      DBASE = 56                                                BUG3760
     C                   EVAL      DBKEY = PFUNC                                             BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Access compliance watch configuration                                               BUG3760
                                                                                             BUG3760
     C                   CALLB     'AOCWCDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRTCD                                       BUG3760
     C                   PARM      '*FIRST '     POPTN                                       BUG3760
     C     SDCWCD        PARM      SDCWCD        DSSDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        (PRtCd <> *BLANKS)                                        BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBFILE = 'SDCWCDPD'                                       BUG3760
     C                   EVAL      DBASE  = 57                                               BUG3760
     C                   EVAL      DBKEY = POPTN                                             BUG3760
     C                   OUT       LDA                                                       BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Check if Concord Interface Development (CCF001) is on                               BUG3760
                                                                                             BUG3760
     C                   CALLB     'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRTCD                                       BUG3760
     C                   PARM      '*VERIFY'     POPTN                                       BUG3760
     C                   PARM      'CCF001'      PSARD                                       BUG3760
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        (PRTCD <> *BLANKS) and                                    BUG3760
     C                             (PRTCD <> '*NRF   ')                                      BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKEY = 'CCF001'                                          BUG3760
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBASE = 58                                                BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        PRTCD = *BLANKS                                           BUG3760
     C                   EVAL      CCF001 = 'Y'                                              BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      CCF001 = 'N'                                              BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      ** Determine if 24x7 Midas Availability active?                                        BUG3760
                                                                                             BUG3760
     C                   CALLB     'AOSARDR0'                                                BUG3760
     C                   PARM      *BLANKS       PRTCD                                       BUG3760
     C                   PARM      '*VERIFY'     POPTN                                       BUG3760
     C                   PARM      'CSC011'      PSARD                                       BUG3760
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG3760
                                                                                             BUG3760
     C                   IF        PRTCD = *BLANKS                                           BUG3760
     C                   EVAL      CSC011 = 'Y'                                              BUG3760
     C                   ELSE                                                                BUG3760
     C                   EVAL      CSC011 = 'N'                                              BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
     C                   IF        (PRTCD <> *BLANKS) and                                    BUG3760
     C                             (PRTCD <> '*NRF   ')                                      BUG3760
     C     *LOCK         IN        LDA                                                       BUG3760
     C                   EVAL      DBKEY = 'CSC011'                                          BUG3760
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG3760
     C                   EVAL      DBASE = 59                                                BUG3760
     C                   EXSR      *PSSR                                                     BUG3760
     C                   ENDIF                                                               BUG3760
                                                                                             BUG3760
      *                                                                                       CSC022
      ** Determine if enhancement CSC022 is switched on                                       CSC022
      *                                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       PRTCD                                        CSC022
     C                   PARM      '*VERIFY'     POPTN                                        CSC022
     C                   PARM      'CSC022'      PSARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
      ** Initialize work fields                                                               CSC022
      *                                                                                       CSC022
     C                   EVAL      CSC022 = 'N'                                               CSC022
     C                   EVAL      WSkpCom = 'N'                                              CSC022
      *                                                                                       CSC022
     C                   IF        PRTCD = *Blanks                                            CSC022
     C                   EVAL      CSC022 = 'Y'                                               CSC022
      *                                                                                       CSC022
     C                   IN        SCCMTJOB                                                   CSC022
      *                                                                                       CSC022
     C                   IF        COMITNUM <> 0                                              CSC022
     C                   MOVEA     Comitjobs     JobCmtctlDS                                  CSC022
     C                   EVAL      WPos = %Lookup(PSJOBNAME:JobCmtCtlDS)                      CSC022
     C                   IF        WPos > 0                                                   CSC022
     C                   EVAL      WSkpCom = 'Y'                                              CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   ELSE                                                                 CSC022
      *                                                                                       CSC022
      ** An NRF (No Record Found) return code is valid.                                       CSC022
      ** Issue database error only for error return codes.                                    CSC022
      *                                                                                       CSC022
     C                   IF        PRTCD <> '*NRF'                                            CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBASE = 022                                                CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC024
      ***Check*if*enhancement*CSC024*(Open*Month*End)*is*on                            CSC024 CSC054
      ** Check if enhancement CSC024 (Period End Adjustments) is on                           CSC054
                                                                                              CSC024
     C                   CALLB     'AOSARDR0'                                                 CSC024
     C                   PARM      *BLANKS       PRTCD                                        CSC024
     C                   PARM      '*VERIFY'     POPTN                                        CSC024
     C**********         PARM      'CSC024'      PSARD                                 CSC024 CSC054
     C                   PARM      'CSC054'      PSARD                                        CSC054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC024
                                                                                              CSC024
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSC024
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSC024
     C**********         EVAL      DBKey  = 'CSC024'                                   CSC024 CSC054
     C                   EVAL      DBKey  = 'CSC054'                                          CSC054
     C                   EVAL      DBase  = 23                                                CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C**********         EVAL      CSC024 = 'N'                                        CSC024 CSC054
     C**********         EVAL      WOMEInd = 'N'                                       CSC024 CSC054
     C                   EVAL      CSC054 = 'N'                                               CSC054
     C                   EVAL      WPEAInd = 'N'                                              CSC054
                                                                                              CSC024
     C                   IF        PRTCD = *BLANKS                                            CSC024
     C**********         EVAL      CSC024 = 'Y'                                        CSC024 CSC054
     C                   EVAL      CSC054 = 'Y'                                               CSC054
                                                                                              CSC024
      ** Access System values                                                                 CSC024
                                                                                              CSC024
     C                   CALL      'AOSVALR0'                                                 CSC024
     C                   PARM      *BLANKS       PRetCode                                     CSC024
     C**********         PARM      POMESys01     P@OP01                                CSC024 CSC054
     C                   PARM      PPEASys01     P@OP01                                       CSC054
     C                   PARM      *BLANKS       P@VL01                                       CSC024
     C                   PARM      *BLANKS       P@OP02                                       CSC024
     C                   PARM      *BLANKS       P@VL02                                       CSC024
     C                   PARM      *BLANKS       P@OP03                                       CSC024
     C                   PARM      *BLANKS       P@VL03                                       CSC024
     C                   PARM      *BLANKS       P@OP04                                       CSC024
     C                   PARM      *BLANKS       P@VL04                                       CSC024
     C                   PARM      *BLANKS       P@OP05                                       CSC024
     C                   PARM      *BLANKS       P@VL05                                       CSC024
     C                   PARM      *BLANKS       P@OP06                                       CSC024
     C                   PARM      *BLANKS       P@VL06                                       CSC024
     C                   PARM      *BLANKS       P@OP07                                       CSC024
     C                   PARM      *BLANKS       P@VL07                                       CSC024
     C                   PARM      *BLANKS       P@OP08                                       CSC024
     C                   PARM      *BLANKS       P@VL08                                       CSC024
     C                   PARM      *BLANKS       P@OP09                                       CSC024
     C                   PARM      *BLANKS       P@VL09                                       CSC024
     C                   PARM      *BLANKS       P@OP10                                       CSC024
     C                   PARM      *BLANKS       P@VL10                                       CSC024
                                                                                              CSC024
     C                   IF        PRetCode  <> *BLANKS                                       CSC024
     C                   EVAL      DBFile = 'SDSVALPD'                                        CSC024
     C                   EVAL      DBKEy = '*KEY   '                                          CSC024
     C                   EVAL      DBase = 24                                                 CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ENDIF                                                                CSC024
     C                   IF        P@VL01 = 'Y'                                               CSC024
     C**********         EVAL      WOMEInd = 'Y'                                       CSC024 CSC054
     C                   EVAL      WPEAInd = 'Y'                                              CSC054
     C                   ENDIF                                                                CSC024
     C                   ENDIF                                                                CSC024
 
     C                   EVAL      @RTCD = *BLANKS
      *                                                                                       CAS011
      ** Check if switchable feature CAS009 is installed                                      CAS011
      *                                                                                       CAS011
     C                   CALLB     'AOSARDR0'                                                 CAS011
     C                   PARM      *BLANKS       PRTCD                                        CAS011
     C                   PARM      '*VERIFY'     POPTN                                        CAS011
     C                   PARM      'CAS009'      PSARD                                        CAS011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS011
      *                                                                                       CAS011
     C                   IF        PRTCD = *Blanks                                            CAS011
     C                   EVAL      CAS009 = 'Y'                                               CAS011
     C                   ELSE                                                                 CAS011
     C                   EVAL      CAS009 = 'N'                                               CAS011
     C                   IF        PRTCD <> '*NRF    '                                        CAS011
     C     *LOCK         IN        LDA                                                        CAS011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS011
     C                   EVAL      DBASE = 39                                                 CAS011
     C                   EVAL      DBKEY = 'CAS009'                                           CAS011
     C                   OUT       LDA                                                        CAS011
     C                   EXSR      *PSSR                                                      CAS011
     C                   ENDIF                                                                CAS011
     C                   ENDIF                                                                CAS011
      *                                                                                       CAS019
      ** Check if switchable feature CAS016 is installed                                      CAS019
      *                                                                                       CAS019
     C                   CALLB     'AOSARDR0'                                                 CAS019
     C                   PARM      *BLANKS       PRTCD                                        CAS019
     C                   PARM      '*VERIFY'     POPTN                                        CAS019
     C                   PARM      'CAS016'      PSARD                                        CAS019
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS019
      *                                                                                       CAS019
     C                   IF        PRTCD = *Blanks                                            CAS019
     C                   EVAL      CAS016 = 'Y'                                               CAS019
     C                   ELSE                                                                 CAS019
     C                   EVAL      CAS016 = 'N'                                               CAS019
     C                   IF        PRTCD <> '*NRF    '                                        CAS019
     C     *LOCK         IN        LDA                                                        CAS019
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS019
     C                   EVAL      DBASE = 38                                                 CAS019
     C                   EVAL      DBKEY = 'CAS016'                                           CAS019
     C                   OUT       LDA                                                        CAS019
     C                   EXSR      *PSSR                                                      CAS019
     C                   ENDIF                                                                CAS019
     C                   ENDIF                                                                CAS019
                                                                                              CLE073
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
      *
      ** Check if CLE134 - Calculation of loan based fees is installed                      AR806351
      *                                                                                     AR806351
     C                   CALL      'AOSARDR0'                                               AR806351
     C                   PARM      *BLANKS       @RTCD                                      AR806351
     C                   PARM      '*KEY    '    @OPTN                                      AR806351
     C                   PARM      'CLE134'      @SARD             6                        AR806351
     C     SCSARD        PARM      SCSARD        DSFDY                                      AR806351
                                                                                            AR806351
     C     @RTCD         IFEQ      *BLANKS                                                  AR806351
     C                   MOVEL     'Y'           CLE134                                     AR806351
     C                   ELSE                                                               AR806351
     C                   MOVEL     'N'           CLE134            1                        AR806351
     C                   ENDIF                                                              AR806351
                                                                                            AR806351
 
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALLB     'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRTCD                                        CSD083
     C                   PARM      '*VERIFY'     POPTN                                        CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRTCD <> *BLANKS AND                                       CSD083
     C                             PRTCD <> '*NRF    '                                        CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBASE = 60                                                 CSD083
     C                   EVAL      DBKEY = 'CSD083'                                           CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRTCD = *Blanks                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
      *                                                                                     MD024342
      ** Get MPHAS dataarea.                                                                MD024342
      *                                                                                     MD024342
     C     *DTAARA       DEFINE                  MPHAS                                      MD024342
     C                   IN        MPHAS                                                    MD024342
     C                   UNLOCK    MPHAS                                                    MD024342
      *                                                                                     MD024342
     C                   MOVEL     RPFRNT        W#FRNT                                     MD024342
      *                                                                                     MD024342
     C                   MOVEL     'N'           MTHREAD           1                        MD024342
     C**********         MOVE      'RPSC'        WAPIC                             MD024342 MD025467
     C**********         MOVEL     'LOAMSZ1'     WFILN                             MD024342 MD025467
      *                                                                                     MD024342
     C**********         IF        MPHAS = 'A' AND                                 MD024342 MD025467
     C                   IF        MPHAS <> 'C' AND                                         MD025467
     C                             W#FRNT <> 'LE000473'                                     MD024342
     C                   MOVEL     'Y'           MTHREAD                                    MD025467
     C*****KAPILST       CHAIN     SDAPDRL0                           99           MD024342 MD025467
     C******IN99         IFEQ      '0'                                             MD024342 MD025467
     C**********         MOVEL     A8MULT        MTHREAD                           MD024342 MD025467
     C**********         ENDIF                                                     MD024342 MD025467
     C                   ENDIF                                                              MD024342
      *                                                                                     MD024342
     C                   ENDSR
      ****************************************************************                       BUG3112
      /EJECT                                                                                 BUG3112
      ****************************************************************                       BUG3112
      * ZXRATE - CROSS RATE CALCULATION                              *                       BUG3112
      ****************************************************************                       BUG3112
     C     ZXRATE        BEGSR                                                               BUG3112
     C                   CALLB     'ZXRATE'                                                  BUG3112
     C                   PARM                    ZRATE1           13 8                       BUG3112
     C                   PARM                    ZMDI1             1                         BUG3112
     C                   PARM                    ZRATE2           13 8                       BUG3112
     C                   PARM                    ZMDI2             1                         BUG3112
     C                   PARM                    ZRATEX           13 8                       BUG3112
     C                   PARM                    ZMDIX             1                         BUG3112
     C                   ENDSR                                                               BUG3112
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
     O                       RPLNRF               8
     O                       RPVDAT              13
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
** CPY@  **      Copyright statement
(c) Finastra International Limited 2002
**  POWR -- USED IN CURRENCY CONVERSION(FACILITY)
0000001
0000010
0000100
0001000
0010000
0100000
1000000
** CWA - Array for watch list fields                                                         BUG3760
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
