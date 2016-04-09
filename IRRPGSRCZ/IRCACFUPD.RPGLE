     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Caps/Collars/Floors Database Update')         *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRCACFUPD - Caps/Collars/Floors Database Update              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 CDL094             Date 01Sep14               *
      *                 MD029681           Date 12Aug14               *
      *                 MD025244           Date 09May14               *
      *                 AR958792           Date 12Dec12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER043             Date 19May08               *
      *               . CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 246966             Date 22Sep06               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239742             Date 22Sep06               *
      *                 240240             Date 26Jun06               *
      *                 CDL049             Date 07Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG8250            Date 26Aug05               *
      *                 220020             Date 08May06               *
      *                 BUG6877N           Date 10Jul05               *
      *                 BUG7952            Date 22Jul05               *
      *                 BUG7217            Date 07Jun05               *
      *                 BUG7535            Date 14Jun05               *
      *                 BUG7166            Date 12May05               *
      *                 CDL038             Date 10May05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6671            Date 26Apr05               *
      *                 CLE031             Date 26Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG6373            Date 24Mar05               *
      *                 CSD025             Date 11Jan05               *
      *                 BUG4788            Date 18Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG1099            Date 04May04               *
      *                 CDL018             Date 03Feb04               *
      *                 TDA101             Date 02Apr04               *
      *                 CRE020             Date 20Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CDE005             Date 21Aug03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CSD015             Date 14Oct02               *
      *                 CAS004             Date 26Jun02               *
      *                 CAP043             Date 02May02               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      *                 CAP055  *CREATE    Date 13Mar02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD029681 - Serious Midas Error occurred due to *LDA lock     *
      *             being not granted                                 *
      *  MD025244 - Added parameter in calling ZADLTRLRUD.            *
      *  AR958792 - Cannot insert CACF deal due to MMM3004 error.     *
      *             Correctly setup paramaters for calling IRCACFRTV. *
      *             (Child: AR958793)                                 *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  246966 - Override missing for DLPCSCPD.                      *
      *  239742 - No confirmation message for IRS deal amendment.     *
      *  240240 - Ensure locks don't remain on DLPCSCPD.              *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8250- Midas error / deal no. outside range for manual     *
      *           deal nos. RECOMPILE                                 *
      *  220020 - Field 72a is not generated for MT202 due to blank   *
      *           bank to bank information field (BTB1).              *
      *  220020 - Field :57a: is not generated for MT202 due to blank *
      *           Account with Bank (AWBN) field.  Also moved the     *
      *           values of CPPBK, PSETM, UPACC, CPRBK, FACO, RSETM   *
      *           and URACC to RCRN, PSTM, PONS, AWBN, BENN, BTB1,    *
      *           RSTM and RONS respectively.                         *
      *  BUG6877N-Regenerate pay/receives where necessary.            *
      *  BUG7952  Amend call to AOOUSWU1                              *
      *  BUG7217 - Populate field SDCAR for average rate method on    *
      *            insert of deal.
      *  BUG7535- Initialise CDL028 fields                            *
      *  BUG7166- Valid file does not match DEALSDG (Recompile)       *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6671- Implement Auto Authorisation                        *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  CDL028 - Automatic Rate Interpolations                       *
      *  BUG6373 - Call AOOUSWU1 instead of AOOUSWU0                  *
      *  CSD025 - Customer De-Activation                              *
      *  BUG4788 - MEMOS not updated for Buy amount and fees.         *
      *          - Fix patterned after 223356.                        *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG1099 - Check if web browser user.                         *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TDA101 - After and Before image data structure (Z#AST        *
      *           and Z#BST) used in program is short FRA/IRS         *
      *           transaction.  (Recompile)                           *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CDE005 - Date Export - Reservation ID                        *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  CAP043 - Additional APIs for IRS Schedules                   *
      *  217684 - Authorisation User Malfunction                      *
      *  CAP056 - Automatic Authorisation of Interface Deals          *
      *  CIR008 - FRA/IRS Deals Authorisation                         *
      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    89         Use for chaining to file and TESTB              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRChkOthUpd - Check for update by another workstation        *
      *  SRInsert    - Insert an IRS Record                           *
      *  SRClrDeals  - Initialise Deals                               *
      *  SRAmend     - Amend an IRS Record                            *
      *  SRClearPC   - Clear Principal Change Date Records            *                       CAP043
      *  SRWritePC   - Write Principal Change Date Records            *                       CAP043
      *  SRGetCtlDate- Get Control Date                               *                       CAP043
      *  SRUpdPCSC   - Change Principal Amount of Affected Record     *                       CAP043
      *  SRDelete    - Delete an IRS Record                           *
      *  SRAuthorise - Authorise an IRS Record                        *
      *  SRSetReqFldI- Set up Required Fields in DEALSDF that were    *
      *                not set up on Valid File - Insert Processing   *
      *  SrSetReqFldA- Set up Required Fields on DEALSDG that were    *
      *                not Set up on Valid File - Amend Processing    *
      *  SrDlBack    - Calculate Rate Fix Date for FRA/IRS            *
      *  SrCnfIns    - Set Confirmation Indicator on Insertion        *
      *  SrCnfAmd    - Set Confirmation Indicator on Amendment        *
      *  SrCnfDel    - Set Confirmation Indicator on Deletion         *
      *  SrWrtDtx    - Write a DTRIX Record                           *
      *  SrUpdDtxHdr - Update the DTRIX Header Record                 *
      *  SrUpdDlTrl  - Update Deals File Trailer                      *
      *  SrUpdSumm   - Summary Updates                                *
      *  SrUpdOLPos  - Update On Line Position Files                  *
      *  SrBookDet   - Access Book Details                            *
      *  SrDlCcyDet  - Access Deal Currency Details                   *
      *                                                               *
      *  SrErr       - Exception Errors                               *
      *  *INZSR      - Initialise                                     *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** DL IRS Principal Change Schedule File                                                CAP043
     F*DLPCSCL0**UF***E           K DISK    RENAME(DLPCSCD0:DLPCSCX0)                 CAP043  240240
     FDLPCSCL0  UF   E           K DISK    INFSR(*PSSR)                                       240240
     F                                     RENAME(DLPCSCD0:DLPCSCX0)                          240240
     F                                     PREFIX(XX)                                         CAP043
     F                                     COMMIT                                             CAP043
                                                                                              CAP043
      ** DL All Deals file
     FDEALALL   UF A E           K DISK
     F                                     COMMIT
     F                                     INCLUDE(DEALSDGF)
     F                                     INCLUDE(DEALSDFF)
 
      ** DL Sorted Deal Transaction Index
     FSDTIX     UF A E           K DISK
     F                                     COMMIT
     F                                     PREFIX(DX)
 
      ** DL Principal Change Schedule                                                         CAP043
     F*DLPCSCPD**UF*A*E           K DISK                                              CAP043  240240
     FDLPCSCPD  UF A E           K DISK    INFSR(*PSSR)                                       240240
     F                                     PREFIX(PC)                                         CAP043
     F                                     COMMIT                                             CAP043
                                                                                              CAP043
      ** IR Valid IRC Principal Change Schedule by Front Office ID                            CAP043
     FIRVPCSCL0 IF   E           K DISK    PREFIX(PV)                                         CAP043
                                                                                              CAP043
      ** Compliance Watch Hit List file                                                       CSD015
     FSDCWHTL1  IF   E           K DISK                                                       CSD015
                                                                                              CSD015
     FREADVCL1  UF   E           K DISK    COMMIT                                             CRE020
     F                                     USROPN                                             CRE020
      ** Midas RE Settled Transaction Index File by Ref No/Pgm Ref                            CRE020
                                                                                              CRE020
      /COPY WNCPYSRC,IRCACFDF01
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
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
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      **  Externally described data structure for valid Caps/Collars/Floors
     D IRVCACF       E DS                  EXTNAME(IRVCACFPD)
     D  WVRPDet1              11    715
     D  WVRPRecv             716    784
     D  WVRPPay1             785    990
     D  WVRPPay2             991   1133
     D  WVRPPay3            1134   1343
     D  WVRPDet2            1344   2126
     D  WVRtFxCcy           2097   2126
     D  WVRPDet3            2551   2602                                                       CDL028
 
      ** Deals file - Caps/Collars/Floors
     D DEALS         E DS                  EXTNAME(DEALSDG)
     D  WFRPDet1              11    715
     D  WFRPRecv             716    784
     D  WFRPPay1             785    990
     D  WFRPPay2             991   1133
     D  WFRPPay3            1134   1343
     D  WFRPDet2            1344   2126
     D  WFRPDet3            2551   2602                                                       CDL028
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSD015
      ** External DS for Customer Details                                                     CSD015
                                                                                              CSD015
      ** Midas Functions for Watch List Checking Details File                                 CSD015
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
                                                                                              CSD015
      ** Data structure for 1st parameter of Watchlist Engine (SDCWLCHK)                      CSD015
     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)                                  CSD015
                                                                                              CSD015
      ** External DS for Watch List Configuration Data File                                   CSD015
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                  CSD015
                                                                                              CSD015
      ** Data structure for 2st parameter of SDCWLCHK                                         CSD015
                                                                                              CSD015
     D PString         DS         30000                                                       CSD015
 
      ** Rename fields for Transaction No of Last Update Processing
     D ChkDealFmt    E DS                  EXTNAME(DEALSDG)
     D                                     PREFIX(CH)
 
      ** Error indicators
     D IRECACF       E DS                  EXTNAME(IRECACFPD)
 
      ** Time data structure for DTRIX
     D                 DS
     D  WXTime                 1      6  0
     D  DXTIM                  1      4  0
                                                                                              CAP043
      ** Last processing date (82nd PRDT) UR/UP/TR/TP                                         CAP043
     D PLastPRDT       DS                                                                     CAP043
     D WLastPRDT               1     12P 0 DIM(4)                                             CAP043
 
      ** Define external data-structures for before and after image
      ** of deal for on-line updates
     D Z#BSTS        E DS                  EXTNAME(Z#BST)
     D Z#ASTS        E DS                  EXTNAME(Z#AST)
     D Z#WSTS        E DS                  EXTNAME(Z#WST)
     D Z#XSTS        E DS                  EXTNAME(Z#XST)
     D Z#YSTS        E DS                  EXTNAME(Z#YST)
     D Z#ZSTS        E DS                  EXTNAME(Z#ZST)
 
      ** Valid Prin Change def file                                                           CAP043
     D VldPrinChg    E DS                  EXTNAME(IRVPCSCPD) PREFIX(PV)                      CAP043
     D WPrinChgD              22    267P 0 DIM(82)                                            CAP043
     D WPrinChgA             268    923P 0 DIM(82)                                            CAP043
     D WPrinChgCA            924   1579P 0 DIM(82)                                            CAP043
     D WPCSCConfH           1580   1661A   DIM(82)                                            CAP043
     D WPCSCIDInd           1662   1743A   DIM(82)                                            CAP043
                                                                                              CAP043
     D PAYScnFmt     E DS                  EXTNAME(SDESSPPD)                                  CAP043
                                                                                              CAP043
     D RECScnFmt     E DS                  EXTNAME(SDESSRPD)                                  CAP043
                                                                                              CAP043
     D FRIRScnFmt    E DS                  EXTNAME(SDESSFPD)                                  CAP043
                                                                                              CAP043
     D VPAYScnFmt    E DS                  EXTNAME(SDESSPPD)                                  CAP043
     D                                     PREFIX(V)                                          CAP043
                                                                                              CAP043
     D VRECScnFmt    E DS                  EXTNAME(SDESSRPD)                                  CAP043
     D                                     PREFIX(V)                                          CAP043
                                                                                              CAP043
     D MPAYScnFmt    E DS                  EXTNAME(SDESSPPD)                                  CAP043
     D                                     PREFIX(M)                                          CAP043
                                                                                              CAP043
     D MRECScnFmt    E DS                  EXTNAME(SDESSRPD)                                  CAP043
     D                                     PREFIX(M)                                          CAP043
                                                                                              CAP043
      ** FRA/IRS Interface Non-Screen Data                                                    CAP043
     D InfData       E DS                  EXTNAME(IRRPIFPD)                                  CAP043
                                                                                              CAP043
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for General Ledger ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** External DS for Retail Details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CGL029
 
      ** External DS for FRA/IRS ICD data
     D SDFAIS        E DS                  EXTNAME(SDFAISPD)
 
      ** External DS for Trading ICD Data
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  QQACCD2      E                     EXTFLD(QQACCD)                                     CGL029
 
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External DS for Book Details
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)
 
      ** Module Details Data Structure                                                        CAP043
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CAP043
                                                                                              CAP043
      ** First DS for Access Programs, Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Secod  DS for Access Programs, Long Date Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Next Available transaction number
     D MNATN         E DS                  EXTNAME(MNATN)
 
      ** SD data area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
 
      ** 24X7 status dataarea
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
 
      ** Midas API Message Header Format Definition
     D APHEAD        E DS                  EXTNAME(APHEADPD)
 
      ** External DS for SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D  WLCD         E                     EXTFLD(LCD)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D OVRDLPCSC       C                   Const('OVRDBF DLPCSCRX DLPCSCPD +                  246966
     D                                     OVRSCOPE(*JOB)')                                   246966
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Watch List Description Compiled Time Array                                           CSD015
     DWLARR            S             35    DIM(26) CTDATA PERRCD(2)                           CSD015
                                                                                              CSD015
      ** Date Array index (3P0) for use with IRCs
     D Wx              S              2P 0 INZ(*ZEROS)
     D Wc              S              2  0
     D Idx             S              3  0
 
      ** Parameters for Access Objects
     D PRtCd           S              7A
     D POptn           S              7A
     D PSarD           S              6A
     D PFunc           S              8A                                                      CSD015
 
      ** Parameters for ZARTVJOBA
     D PReturn         S              6A
     D PType           S              1A
 
      ** Parameters for ZAMSGTOOPR
     D PMsgSndRtn      S             10A
     D PDBError        S            132A
     D PDummyMsgID     S                   LIKE(#MsgID)
     D PDummyMsgF      S             10A
 
      ** Parameters for ZADLTRLRUD
     D PRetCodeIn      S              7A
     D WkAMNP          S             15  0
 
      ** Parameters for DEWRTTRIG
     D PTrRef          S             20A
     D PTrCat          S              4A
 
      ** Parameters for IRRTFXCNV
     D PZInDt          S              5  0
     D PZLoc           S              3
     D PZRfDt          S              5  0
     D PPRfDy          S              2  0
 
     D WZWkFld         S              5  0
     D WZRfDy          S              5  0
 
      ** Parameters for ZCHKH
     D PZDayNo         S              5  0
     D PZCcy           S              3A
     D PZind           S              1A
 
      ** Parameters for DL1911
     D PTerm           S              1A
     D PDlNum          S              6  0
 
      ** Parameters for DL2900
     D PDlNo           S              6A
     D PBeAf           S              1A
 
      ** Parameters for IRCACFRTV
     D PRetCodeOut     S             10A
     D PMode           S              6A
     D PRespMode       S              1A
     D PFrontId        S             20A
     D PFOAsId         S             20A
     D PDSDNo          S              6A
     D PDBrSn          S              3A
     D PDType          S              2A
     D P_Actn          S              1A                                                      CIR008
     D P_CSTS          S              1A                                                      CIR008
     D P_DSTS          S              1A                                                      CIR008
 
     D Wrk_10          S             10A
     D WkActn          S              1A                                                      CIR008
     D WkAJCD          S              3A
     D WkDSNB          S              3A
     D WkCNRQ          S              1A
     D WUIPBD          S              5  0
     D WTIPBD          S              5  0
     D WUNIPD          S              5  0
     D WTNIPD          S              5  0
     D WL1AMC          S              2A
     D WkBokC          S              2A
     D MidasDlNum      S              6A
 
      ** Switchable features
     D CAP056          S              1A                                                      CAP056
     D CAP051          S              1A                                                     BUG6671
     D CDE001          S              1A
     D CIR005          S              1A
     D CIR006          S              1A
     D CIR008          S              1A                                                      CIR008
     D CSC011          S              1A
     D CSD015          S              1A                                                      CSD015
     D CCF001          S              1A   INZ('N')                                           CSD015
     D CDL028          S              1A                                                      CDL028
 
     D PkDBRC          S              3A
     D PModeOfOp       S              6A                                                      CAP056
 
      ** Fields used in 24x7 Processing
     D PTimestamp      S             26A
     D TRANSDTL        S           5800A
     D WDealNo         S              6A
     D PDealNo         S             18A
     D PADealNo        S             18A
                                                                                              CAP043
      ** Variables defined for CAP043                                                         CAP043
     D CAP043          S              1A                                                      CAP043
     D CAP041          S              1A                                                      CAP043
     D PDealNum        S              6S 0                                                    CAP043
     D POurCCY         S              3A                                                      CAP043
     D PThrCCY         S              3A                                                      CAP043
     D PBGN2ST         S              1A                                                      CAP043
     D WPAMT           S             15  0                                                    CAP043
     D WCTLDYN         S              5  0                                                    CAP043
     D PFunction       S              4A                                                      CAP043
     D PInfData        S              1A                                                      CAP043
     D PScreenInpt     S              1A                                                      CAP043
                                                                                              CAP043
      * Date Array index (3P0) for use with IRCs                                              CAP043
     D   X             S              2P 0 INZ(*ZEROS)                                        CAP043
                                                                                              CSD015
      ** ZACVTDATE Parameters                                                                 CSD015
     D PZARtCd         S             10                                                       CSD015
     D PZADayNo        S              5                                                       CSD015
     D PZADDT          S               D                                                      CSD015
     D PConvtDate      S             10                                                       CSD015
                                                                                              CSD015
      ** ZACVTAMT Parameters                                                                  CSD015
     D PZAAmt          S             15                                                       CSD015
     D PZACcy          S              3                                                       CSD015
     D PZOutAmt        S             18  3                                                    CSD015
     D PZCvtAmt        S             16                                                       CSD015
                                                                                              CSD015
      ** SRConvert Parameters                                                                 CSD015
     D PInput          S             35                                                       CSD015
     D PInput1         S             35                                                       CSD015
     D PInput2         S             35                                                       CSD015
     D PInput3         S             35                                                       CSD015
     D PInput4         S             35                                                       CSD015
     D PInput5         S             35                                                       CSD015
     D PInCcy          S              3                                                       CSD015
     D OutFmt          S            216                                                       CSD015
     D OutFmt2         S              6                                                       CSD015
                                                                                              CSD015
      ** Work Variables                                                                       CSD015
     D WDDT            S               D                                                      CSD015
     D WFPDT           S              8F                                                      CSD015
     D Fld1            S             35                                                       CSD015
     D Fld2            S             35                                                       CSD015
     D Fld3            S             35                                                       CSD015
     D Fld4            S             35                                                       CSD015
     D Fld5            S             35                                                       CSD015
     D WFUNT           S              8                                                       CSD015
     D WIDEN           S             40                                                       CSD015
     D WCtrpRpt        S             30                                                       CSD015
     D WCtrpTyp        S              1                                                       CSD015
     D PCustNo         S             10A                                                      CSD015
     D PErrInf         S              7A                                                      CSD015
     D WUNCF           S              1A                                                      CSD015
     D U               S              2  0                                                    CSD015
                                                                                              CSD015
      ** Define fields used in CRE020                                                         CRE020
                                                                                              CRE020
     D CRE020          S              1A                                                      CRE020
     D KRefNo          S             30A                                                      CRE020
     D KPrgMn          S             10A   INZ('IRCACFUPD ')                                  CRE020
     D PSysVal01       S             20A   INZ('CapsCollarsFloorsMnt')                        CRE020
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
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Exit if not insertion, amendment or reversal
      ** only when CIR008 is switched off                                                     CIR008
 
     C                   IF        CIR008 = 'N'                                               CIR008
     C                   IF        RPCHTP <> 'I' AND RPCHTP <> 'A' AND
     C                             RPCHTP <> 'R'
     C                   RETURN
     C                   ENDIF
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
      ** Include checking of authorisation if CIR008 is switched on                           CIR008
                                                                                              CIR008
     C                   IF        CIR008 = 'Y'                                               CIR008
     C                   IF        RPCHTP <> 'I' AND RPCHTP <> 'A' AND                        CIR008
     C                             RPCHTP <> 'R' AND RPCHTP <> 'X'                            CIR008
     C                   RETURN                                                               CIR008
     C                   ENDIF                                                                CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
      ** Save the action code                                                                 CIR008
                                                                                              CIR008
     C                   EVAL      WkActn = RPCHTP                                            CIR008
 
      ** Check whether user is a web browser user, if so overwrite                           BUG1099
                                                                                             BUG1099
     C                   CALL      'SFC000026'                                               BUG1099
     C                   PARM      *BLANKS       USER             10                         BUG1099
                                                                                             BUG1099
     C                   IF        USER <> *BLANKS                                           BUG1099
     C                   EVAL      PSUSER = USER                                             BUG1099
     C                   ENDIF                                                               BUG1099
                                                                                             BUG1099
      ** Ensure transaction has not been updated by another workstation
      ** - if so, bypass updating and return to calling program
 
     C                   EXSR      SRChkOthUpd
 
     C                   IF        PRetCodeIn <> *BLANKS
     C                   GOTO      EXIT
     C                   ENDIF
                                                                                              CAP056
      ** Set ICD Authorisation of FRA/IRS to 'N'                                              CAP056
      ** if Auto Authorisation on Cross Ccy Valid File is 'Y'                                 CAP056
                                                                                              CAP056
     C                   IF        CAP056 = 'Y' AND PModeOfOp = '*FRONT' AND                  CAP056
     C                             RPAUTH = 'Y'                                               CAP056
     C                             OR CAP051 = 'Y' AND RPAUTH = 'Y'                          BUG6671
     C                   EVAL      BQFIAU = 'N'                                               CAP056
     C                   EVAL      BQFIRA = 'N'                                               CAP056
     C                   ELSE                                                                 CAP056
     C                   EVAL      BQFIAU = WkFIAU                                            CAP056
     C                   EVAL      BQFIRA = WkFIRA                                            CAP056
     C                   ENDIF                                                                CAP056
 
      ** Insert, Amend, or Reverse the deal
      ** or Authorise                                                                         CIR008
 
     C     RPCHTP        CASEQ     'I'           SrInsert
     C     RPCHTP        CASEQ     'A'           SrAmend
     C     RPCHTP        CASEQ     'R'           SrDelete
     C     RPCHTP        CASEQ     'X'           SrAuthorise                                  CIR008
     C                   END
 
      ** Write a DTRIX record
      ** when CIR008 is switched off or when reversing a deal                                 CIR008
      ** Or Authorisation/Re-authorisation flags are both 'N'                                 CIR008
                                                                                              CIR008
     C                   IF        RPCHTP <> *BLANKS                                          CIR008
      /COPY WNCPYSRC,IRCACFDC01
 
     C                   EXSR      SrWrtDtx
      /COPY WNCPYSRC,IRCACFDC02
 
      ** Update the DTRIX Header record
      /COPY WNCPYSRC,IRCACFDC03
 
     C                   EXSR      SrUpdDtxHdr
      /COPY WNCPYSRC,IRCACFDC04
                                                                                              CIR008
     C                   ENDIF                                                                CIR008
 
      ** Update the deals file trailer on inserts and reversals
 
     C                   IF        RPCHTP = 'I' OR RPCHTP = 'R'
     C                   EXSR      SrUpdDlTrl
     C                   ENDIF
 
      ** Update On-line Position files
 
     C**********         IF        RPCHTP <> *BLANKS                                  CIR008 BUG4788
     C     WkActn        IFEQ      'I'                                                       BUG4788
     C     WkActn        OREQ      'A'                                                       BUG4788
     C     WkActn        OREQ      'R'                                                       BUG4788
     C                   EXSR      SrUpdOLPos
 
      ** Call Summary Update program
 
     C                   EXSR      SrUpdSumm
     C                   ENDIF                                                                CIR008
 
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** If 24x7 Midas Availability is installed, write to the standard
      ** log file when support system is active
 
     C                   IF        CSC011 = 'Y' AND
     C                             S1SUPP = LIBR
 
      ** Setup Loans/Deposits support log
 
     C                   CALLB     'IRCACFLOG'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    WkActn                                       CIR008
     C                   PARM                    DEALS
     C                   PARM      *BLANK        RECScnFmt                                    CAP043
     C                   PARM      *BLANK        PAYScnFmt                                    CAP043
     C                   PARM      *BLANK        FRIRScnFmt                                   CAP043
     C                   PARM      *BLANK        InfData                                      CAP043
     C                   PARM                    TRANSDTL
 
      ** Write to support database log file
 
     C                   IF        RetCodeOut = *BLANKS
 
     C                   EVAL      APTGTTYPE = 'IRCACF'
     C                   EVAL      APFOTRANID = RPFRNT
     C                   EVAL      APFOASOCID = RPFRNT                                        CAP043
     C                   EVAL      APRPRLOCN = RPREPA
     C                   EVAL      APUSERID = PSUser
     C                   EVAL      APMIDUSR = PSUser
     C                   MOVEL     RPDLNO        PDealNo
 
     C                   CALLB     'APLOGTRAN'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    APHEAD
     C                   PARM                    TRANSDTL
     C                   PARM      *BLANKS       PTimestamp
     C                   PARM                    PDealNo
     C                   PARM      *BLANKS       PADealNo
 
     C                   ENDIF
 
      ** If error occurred
 
     C                   IF        RetCodeOut <> *BLANKS
     C                   EVAL      PRetCodeIn = '*ERROR'
     C                   ENDIF
                                                                                              CAP043
      ** Log transaction for additional IRC schedules (greater than 82)                       CAP043
      ** if CAP043 is on.                                                                     CAP043
                                                                                              CAP043
     C                   IF        CAP043 = 'Y'                                               CAP043
                                                                                              CAP043
     C                   CALLB     'IRIRCLOG'                                                 CAP043
     C                   PARM      *BLANK        RetCodeOut                                   CAP043
     C                   PARM      'CACF'        PFunction                                    CAP043
     C                   PARM      FRNT          PFrontID                                     CAP043
     C                   PARM      DLNO          PDealNum                                     CAP043
     C                   PARM      *Zero         PLastPRDT                                    CAP043
     C                   PARM      UCUCY         POurCcy                                      CAP043
     C                   PARM      TCUCY         PThrCcy                                      CAP043
     C                   PARM      BGN2ST        PBGN2ST                                      CAP043
     C                   PARM                    RECScnFmt                                    CAP043
     C                   PARM                    PAYScnFmt                                    CAP043
     C                   PARM                    FRIRScnFmt                                   CAP043
     C                   PARM      *BLANK        VRECScnFmt                                   CAP043
     C                   PARM      *BLANK        VPAYScnFmt                                   CAP043
     C                   PARM      *BLANK        MRECScnFmt                                   CAP043
     C                   PARM      *BLANK        MPAYScnFmt                                   CAP043
     C                   PARM      AUTH          PInfData                                     CAP043
                                                                                              CAP043
     C                   IF        RetCodeOut <> *BLANK                                       CAP043
     C                   EVAL      PRetCodeIn = '*ERROR'                                      CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
 
     C                   ENDIF
 
      ** Exit from program
 
     C     EXIT          TAG
 
     C                   RETURN
 
      ****************************************************************
      /EJECT
      *****************************************************************
      * SRChkOthUpd - Check for Update by Another Workstation         *
      *****************************************************************
     C     SRChkOthUpd   BEGSR
 
      ** Retrieve current deal details
 
     C                   MOVE      RPDLNO        MidasDlNum
 
      ** Determine whether program is running interactively or in batch
      ** ( 0 = batch   1 = interactive)
 
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    PReturn
     C                   PARM                    PType
 
      ** Allow access to transaction record by Front-Office ID when in Repair
      ** mode for inserts. Set  *RTV module  parameter PMode to *FRONT
      ** if the pgm is:  a) running in Interactive mode - PType = 1
      **                 b) action code is Insert - 'I'
      **                 c) Front-Office Id is NOT Blank
 
     C                   IF        PType = '1' AND RPCHTP = 'I' AND
     C                             RPFRNT <> *BLANKS
 
     C                   EVAL      PMode = '*FRONT'
 
     C                   ELSE
 
      ** Otherwise, if running in batch use Front-Office ID
      **           (if insert)
      **           else, use Midas Deal Number
 
     C                   IF        PType = '0' AND RPCHTP = 'I'
     C                   EVAL      PMode = '*FRONT'
     C                   ELSE
     C                   EVAL      PMode = *BLANKS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      PRetCodeOut = 'UPD'                                      AR958792
     C                   CALLB     'IRCACFRTV'
 
      ** Inputs:
      ** Return code
      ** Mode = '*FRONT' or *BLANK
      ** Response mode
 
     C**********         PARM      *BLANK        PRetCodeOut                                AR958792
     C                   PARM                    PRetCodeOut                                AR958792
     C                   PARM                    PMode
     C                   PARM      ' '           PRespMode
 
      ** Action Code
      ** Front Office Transaction ID
      ** Front Office Associated Transaction Id
      ** (Midas) Deal Number
      ** (Midas) Swap/Option Deal Number
      ** Booking branch
 
     C                   PARM                    RPCHTP
     C                   PARM      RPFRNT        PFrontId
     C                   PARM                    PFOAsId
     C                   PARM                    MidasDlNum
     C                   PARM                    PDSDNo
     C                   PARM      RPBRCA        PDBrSn
     C                   PARM      RPDTYP        PDType
 
      ** Single Branch Code from SDBANKPD
      ** Default Branch for ZMUSER
      ** Originating Branch/User Validation Required for SDGELRPD
      ** FRA/IRS Authorisation Required                                                       CIR008
      ** FRA/IRS Re-authorise Amended Deals                                                   CIR008
 
     C                   PARM                    BJSBRC
     C                   PARM                    PkDBRC
     C                   PARM                    BKOBUV
     C                   PARM                    BQFIAU                                       CIR008
     C                   PARM                    BQFIRA                                       CIR008
                                                                                              CIR008
      ** FRA/IRS Deals Authorisation                                                          CIR008
                                                                                              CIR008
     C                   PARM                    CIR008                                       CIR008
 
      ** Outputs:
      ** (Current) deal in file format
      ** Action Code OK flag
      ** Deal Number OK flag
      ** Booking branch OK flag
 
     C                   PARM                    ChkDealFmt
     C                   PARM      *BLANK        OKACCD
     C                   PARM      *BLANK        OKDLNO
     C                   PARM      *BLANK        OKBRCA
     C                   PARM                    OKDTYP
 
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
 
     C                   PARM      *BLANK        FldNameArr
     C                   PARM      *BLANK        MsgIdArr
     C                   PARM      *BLANK        MsgDtaArr
     C                   PARM      *ZERO         Idx
 
      ** Error if Transaction No. of Last Update (TNLU) not the same
      ** (Record has been changed by another workstation)
 
      ** Processing varies according to mode program is running in.
      ** In interacive mode simply check whether the TNLU field
      ** has been updated since the original deal was fetched by this
      ** program.
      ** In batch (API input) check return parameters from Retrieve
      ** module for errors, and send message to system operator.
 
      ** Interactive mode:
 
     C                   IF        PType = '1'
 
     C                   IF        CHTNLU <> RPTNLU
     C                   EVAL      PRetCodeIn = '*RECUPD'
     C                   ENDIF
 
      ** Batch mode:
 
     C                   ELSE
 
     C                   IF        OKACCD = 'N' OR OKDLNO = 'N'
     C                   EVAL      PRetCodeIn = '*RECUPD'
     C                   EVAL      Wc = 1
 
     C                   DOW        Wc <= ArrayMax AND FldNameArr(Wc) <> *BLANKS
     C                   CLEAR                   PDBError
     C                   EVAL      PDBerror = 'Update error: ' + PFrontId
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    PMsgSndRtn
     C                   PARM                    PDBError
     C                   PARM                    PDummyMsgID
     C                   PARM                    PDummyMsgF
 
     C                   ADD       1             Wc
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * SrInsert - Insert an IRS Record                              *
      ****************************************************************
     C     SrInsert      BEGSR
 
      ** Set confirmation required indicator to be written to DTRIX
      ** when CIR008 is switched off or Auto authorisation is not 'Y'                         CIR008
 
     C                   IF        CIR008 = 'N'  OR                                           CIR008
     C                             CIR008 = 'Y'  AND  BQFIAU <> 'Y'                           CIR008
     C                   EXSR      SrCnfIns
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
      ** Deal Status and Change Type                                                          CIR008
                                                                                              CIR008
     C                   IF        CIR008 = 'Y'                                               CIR008
                                                                                              CIR008
     C                   CALLB     'ZAFUTSTATP'                                               CIR008
     C                   PARM      'I'           P_ACTN                                       CIR008
     C                   PARM      *BLANK        P_CSTS                                       CIR008
     C                   PARM                    BQFIAU                                       CIR008
     C                   PARM                    BQFIRA                                       CIR008
     C                   PARM      *BLANK        P_DSTS                                       CIR008
     C                   PARM      *BLANK        RPCHTP                                       CIR008
                                                                                              CIR008
     C                   ENDIF                                                                CIR008
 
      ** Initialise deals
 
     C                   EXSR      SrClrDeals
 
      ** Initialise "before" status of deal for on-line updates
 
     C                   EVAL      Z#BSTS = *BLANKS
 
      ** Move fields from valid file to master file
      ** Record Id
 
     C                   EVAL      RECI = 'D'
     C                   EVAL      DTYP = RPDTYP
 
      ** Deal number & Record type
 
     C                   EVAL      DLNO = RPDLNO
     C                   EVAL      RCDT = 'G'
 
      ** Deal Record code
 
     C                   EVAL      RCDC = 24
 
      ** Deal Details
 
     C                   EVAL      RPUSTRT = 0
     C                   EVAL      RPUBRTE = 0
     C                   EVAL      RPUIACD = RPVDAT
     C                   EVAL      RPUIALC = 0
     C                   EVAL      RPUAITC = 0
     C                   EVAL      RPUAIPD = 0
     C                   EVAL      RPUAIAN = 0
     C                   EVAL      RPUAIAP = 0
     C                   EVAL      RPUIPRD = 0
     C                   EVAL      RPUIPRM = 0
     C                   EVAL      RPUNSAM = 0
     C                   EVAL      RPUTAXD = 0
     C                   EVAL      RPUTAXM = 0
     C                   EVAL      RPTSTRT = 0
     C                   EVAL      RPTBRTE = 0
     C                   EVAL      RPTIACD = RPVDAT
     C                   EVAL      RPTIALC = 0
     C                   EVAL      RPTAITC = 0
     C                   EVAL      RPTAIPD = 0
     C                   EVAL      RPTAIAN = 0
     C                   EVAL      RPTAIAP = 0
     C                   EVAL      RPTIPRD = 0
     C                   EVAL      RPTIPRM = 0
     C                   EVAL      RPTNSAM = 0
     C                   EVAL      RPTTAXD = 0
     C                   EVAL      RPTTAXM = 0
     C                   MOVE      WVRPDet1      WFRPDet1
     C                   MOVE      WVRPDet2      WFRPDet2
                                                                                              CDL028
     C                   IF        CDL028 = 'Y'                                               CDL028
     C                   MOVE      WVRPDet3      WFRPDet3                                     CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CIR008
      ** Deals Status and Insert User                                                         CIR008
                                                                                              CIR008
     C                   IF        CIR008 = 'Y'                                               CIR008
     C                   EVAL      FIUSRI = PsUSer                                            CIR008
     C                   EVAL      FIDSTS = P_DSTS                                            CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CAP056
      ** Update Auto Authorisation on DEALSDG with value from Valid file                      CAP056
                                                                                              CAP056
     C                   IF        CAP056 = 'Y'                                               CAP056
     C                             OR CAP051 = 'Y'                                           BUG6671
     C                   EVAL      FIAUTH = RPAUTH                                            CAP056
     C                   ENDIF                                                                CAP056
 
      ** Receive Settlement Instructions
 
     C                   EVAL      WFRPRecv = WVRPRecv
     C                   EVAL      RONS = RPRONS                                              CGL029
 
      ** Payment Settlement Instructions
 
     C                   EVAL      WFRPPay1 = WVRPPay1
     C                   EVAL      WFRPPay2 = WVRPPay2
     C                   EVAL      WFRPPay3 = WVRPPay3
     C                   EVAL      PONS = RPPONS                                              CGL029
 
      ** 'OLD' Settlement Instructions
 
     C                   EVAL      RSETM = RPRSTM
     C                   EVAL      URACC = RPRONS
 
      ** Our Receiving Account = Customer Default Account, If method 04
 
     C                   IF        RPRSTM = 04
     C                   MOVEL     RPCNUM        Wrk_10
     C                   MOVE      BMACCD        Wrk_10
     C                   EVAL      URACC = Wrk_10
     C                   MOVE      '01'          URACC
     C                   ENDIF
 
     C                   EVAL      CPPBK = RPRCRN
     C                   EVAL      PSETM = RPPSTM
     C                   EVAL      UPACC = RPPONS
 
      ** Our Payment Account = Customer Default Account, If method 04
 
     C                   IF        RPPSTM = 04
     C                   MOVEL     RPCNUM        Wrk_10
     C                   MOVE      BMACCD        Wrk_10
     C                   EVAL      UPACC = Wrk_10
     C                   MOVE      '01'          UPACC
     C                   ENDIF
 
     C                   EVAL      CPRBK = RPAWBN
     C                   EVAL      FACO = RPBENN
     C                   EVAL      SPI =  RPBTB1
                                                                                              CDL038
      ** Class                                                                                CDL038
     C                   EVAL      CLAS = RPCLAS                                              CDL038
 
      ** Set up required fields on DEALSDG that were not set up on
      ** Valid File
 
     C                   EXSR      SrSetReqFldI
 
      ** Set Transaction No. of Last Update
 
     C     *DTAARA       DEFINE                  MNATN
     C                   IN        MNATN
     C                   EVAL      TNLU = NATN
 
      ** If CSC011 is installed, supply a Front Office ID for the
      ** transaction even if it originated from SIN module.
 
     C                   IF        CSC011 = 'Y'
     C                   IF        FRNT = *BLANKS
     C                   MOVE      DLNO          WDealNo
     C                   EVAL      FRNT = 'MD' + WDealNo
     C                   ENDIF
     C                   ENDIF
 
      ** If compliance watch is installed, and entry watch list checking                      CSD015
      ** is being applied, perform compliance watch processing                                CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'  AND  W1EWLC = 'Y'                            CSD015
                                                                                              CSD015
     C                   IF        (CSC011 = 'Y' AND S1MAIN = LIBR)                           CSD015
     C                             OR CSC011 = 'N'                                            CSD015
     C                   EXSR      SrWatch                                                    CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Write Deal record on the master file
 
     C                   WRITE     DEALSDGF
 
     C                   IF        CAP043 = 'Y' AND CAP041 = 'Y' AND                          CAP043
     C                             PScreenInpt <> 'Y'                                         CAP043
     C                   EXSR      SRWritePC                                                  CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      /COPY WNCPYSRC,IRCACFDC05
      ** Call PGM/DL2900 to set up deal activity for on-line updates
      ***only*if*the*deal*is*authorised.*Else*perform*in*SrAuthorise.*                CIR008 BUG4788
 
     C**********         IF        RPCHTP <> *BLANKS                                  CIR008 BUG4788
     C                   EVAL      Z#ASTS = DEALS
     C                   MOVE      RPDLNO        PDlNo
 
     C                   CALLB     'DL2900'
     C                   PARM      *BLANK        PRtCd
     C                   PARM                    PDlNo
     C                   PARM      'A'           PBeAf
 
     C                   IF        PRtCd = '*ERROR'
     C                   EVAL      DBFILE = 'DL2900'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = *BLANK
     C                   EXSR      *PSSR
     C                   ENDIF
     C**********         ENDIF                                                        CIR008 BUG4788
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * SrClrDeals - Initialise Deals                                *
      ****************************************************************
     C     SrClrDeals    BEGSR
 
     C                   CLEAR                   DEALS
     C                   EVAL      DLNO = *ZEROS
     C                   EVAL      RCDC = *ZEROS
     C**********         EVAL      CNUM = *ZEROS                                              CSD027
     C                   EVAL      CNUM = *BLANKS                                             CSD027
     C                   EVAL      DDAT = *ZEROS
     C                   EVAL      VDAT = *ZEROS
     C                   EVAL      MDAT = *ZEROS
     C                   EVAL      CDAS = *ZEROS
     C                   EVAL      BAGE = *ZEROS
     C                   EVAL      LNKDN = *ZEROS
     C                   EVAL      UPAMT = *ZEROS
     C                   EVAL      UBRTT = *ZEROS
     C                   EVAL      USTRT = *ZEROS
     C                   EVAL      UBRTE = *ZEROS
     C                   EVAL      URTSP = *ZEROS
     C                   EVAL      UEINR = *ZEROS
     C                   EVAL      UICBS = *ZEROS
     C                   EVAL      UFRFD = *ZEROS
     C                   EVAL      UINFD = *ZEROS
     C                   EVAL      USLIP = *ZEROS
     C                   EVAL      UNICD = *ZEROS
     C                   EVAL      UICBD = *ZEROS
     C                   EVAL      UICFD = *ZEROS
     C                   EVAL      UNIPD = *ZEROS
     C                   EVAL      UIPBD = *ZEROS
     C                   EVAL      UIPFD = *ZEROS
     C                   EVAL      UBCXR = *ZEROS
     C                   EVAL      UIACD = *ZEROS
     C                   EVAL      UIALC = *ZEROS
     C                   EVAL      UAITC = *ZEROS
     C                   EVAL      UAIPD = *ZEROS
     C                   EVAL      UAIAN = *ZEROS
     C                   EVAL      UAIAP = *ZEROS
     C                   EVAL      UIPRD = *ZEROS
     C                   EVAL      UIPRM = *ZEROS
     C                   EVAL      UNSAM = *ZEROS
     C                   EVAL      UTAXD = *ZEROS
     C                   EVAL      UTAXM = *ZEROS
     C                   EVAL      TPAMT = *ZEROS
     C                   EVAL      TBRTT = *ZEROS
     C                   EVAL      TSTRT = *ZEROS
     C                   EVAL      TBRTE = *ZEROS
     C                   EVAL      TRTSP = *ZEROS
     C                   EVAL      TEINR = *ZEROS
     C                   EVAL      TICBS = *ZEROS
     C                   EVAL      TFRFD = *ZEROS
     C                   EVAL      TINFD = *ZEROS
     C                   EVAL      TSLIP = *ZEROS
     C                   EVAL      TNICD = *ZEROS
     C                   EVAL      TICBD = *ZEROS
     C                   EVAL      TICFD = *ZEROS
     C                   EVAL      TNIPD = *ZEROS
     C                   EVAL      TIPBD = *ZEROS
     C                   EVAL      TIPFD = *ZEROS
     C                   EVAL      TBCXR = *ZEROS
     C                   EVAL      TIACD = *ZEROS
     C                   EVAL      TIALC = *ZEROS
     C                   EVAL      TAITC = *ZEROS
     C                   EVAL      TAIPD = *ZEROS
     C                   EVAL      TAIAN = *ZEROS
     C                   EVAL      TAIAP = *ZEROS
     C                   EVAL      TIPRD = *ZEROS
     C                   EVAL      TIPRM = *ZEROS
     C                   EVAL      TNSAM = *ZEROS
     C                   EVAL      TTAXD = *ZEROS
     C                   EVAL      TTAXM = *ZEROS
     C                   EVAL      CLRAT = *ZEROS
     C                   EVAL      FLRAT = *ZEROS
     C                   EVAL      AVPER = *ZEROS
     C                   EVAL      TIRAT = *ZEROS
     C                   EVAL      AACRT = *ZEROS
     C                   EVAL      RSETM = *ZEROS
     C                   EVAL      PSETM = *ZEROS
     C                   EVAL      SDCAR = *ZEROS
     C                   EVAL      ULPCD = *ZEROS
     C                   EVAL      TLPCD = *ZEROS
     C                   EVAL      UAEXA = *ZEROS
     C                   EVAL      TAEXA = *ZEROS
     C                   EVAL      UNRL = *ZEROS
     C                   EVAL      UNRLP = *ZEROS
     C                   EVAL      DDTM = *ZEROS
     C                   EVAL      BRSQ = *ZEROS
     C                   EVAL      LSWC = *ZEROS
     C                   EVAL      LSWS = *ZEROS
     C                   EVAL      ORED = *ZEROS
     C                   EVAL      LCD = *ZEROS
     C                   EVAL      TNLU = *ZEROS
     C                   EVAL      UNPCD = *ZEROS
     C                   EVAL      TNPCD = *ZEROS
     C                   EVAL      BODD = *ZEROS
     C                   EVAL      BOVD = *ZEROS
     C                   EVAL      BOAM = *ZEROS
     C                   EVAL      OUSI = *ZEROS
     C                   EVAL      OUSA = *ZEROS
     C                   EVAL      TUSI = *ZEROS
     C                   EVAL      TUSA = *ZEROS
     C                   EVAL      UOBRT = *ZEROS
     C                   EVAL      TOBRT = *ZEROS
     C                   EVAL      UOPAM = *ZEROS
     C                   EVAL      TOPAM = *ZEROS
     C                   EVAL      RSTM = *ZEROS
     C**********         EVAL      ROBN = *ZEROS                                              CSD027
     C**********         EVAL      ROCN = *ZEROS                                              CSD027
     C                   EVAL      ROBN = *BLANKS                                             CSD027
     C                   EVAL      ROCN = *BLANKS                                             CSD027
     C                   EVAL      PSTM = *ZEROS
     C**********         EVAL      POBN = *ZEROS                                              CSD027
     C**********         EVAL      POCN = *ZEROS                                              CSD027
     C                   EVAL      POBN = *BLANKS                                             CSD027
     C                   EVAL      POCN = *BLANKS                                             CSD027
     C                   EVAL      ISDA = *ZEROS
     C                   EVAL      AGDT = *ZEROS
     C                   EVAL      AGVV = *ZEROS
     C                   EVAL      PLULRC = *ZEROS
     C                   EVAL      PLTLRC = *ZEROS
     C                   EVAL      AGVC = *ZEROS
     C                   EVAL      FSOSDT = *ZEROS                                           BUG7535
     C                   EVAL      FSOS1B = *ZEROS                                           BUG7535
     C                   EVAL      FSOS1D = *ZEROS                                           BUG7535
     C                   EVAL      FSOS2B = *ZEROS                                           BUG7535
     C                   EVAL      FSOS2D = *ZEROS                                           BUG7535
     C                   EVAL      FSOEDT = *ZEROS                                           BUG7535
     C                   EVAL      FSOE1B = *ZEROS                                           BUG7535
     C                   EVAL      FSOE1D = *ZEROS                                           BUG7535
     C                   EVAL      FSOE2B = *ZEROS                                           BUG7535
     C                   EVAL      FSOE2D = *ZEROS                                           BUG7535
     C                   EVAL      FSTSDT = *ZEROS                                           BUG7535
     C                   EVAL      FSTS1B = *ZEROS                                           BUG7535
     C                   EVAL      FSTS1D = *ZEROS                                           BUG7535
     C                   EVAL      FSTS2B = *ZEROS                                           BUG7535
     C                   EVAL      FSTS2D = *ZEROS                                           BUG7535
     C                   EVAL      FSTEDT = *ZEROS                                           BUG7535
     C                   EVAL      FSTE1B = *ZEROS                                           BUG7535
     C                   EVAL      FSTE1D = *ZEROS                                           BUG7535
     C                   EVAL      FSTE2B = *ZEROS                                           BUG7535
     C                   EVAL      FSTE2D = *ZEROS                                           BUG7535
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * SrAmend - Amend an IRS Record                                *
      ****************************************************************
     C     SrAmend       BEGSR
 
      ** Access deal via deal number
 
     C     RPDLNO        CHAIN     DEALSDGF                           89
 
      ** If not found, database error
 
     C                   IF        *IN89 = *ON
     C                   MOVEL     RPDLNO        DBKEY
     C                   EVAL      DBFILE = 'DEALSDG '
     C                   EVAL      DBASE = 2
     C                   EXSR      SrErr
     C                   ENDIF
                                                                                              CIR008
      ** Deal Status and Change Type                                                          CIR008
                                                                                              CIR008
     C                   IF        CIR008  = 'Y'                                              CIR008
                                                                                              CIR008
     C                   CALLB     'ZAFUTSTATP'                                               CIR008
     C                   PARM      'A'           P_ACTN                                       CIR008
     C                   PARM      FIDSTS        P_CSTS                                       CIR008
     C                   PARM                    BQFIAU                                       CIR008
     C                   PARM                    BQFIRA                                       CIR008
     C                   PARM      *BLANK        FIDSTS                                       CIR008
     C                   PARM      *BLANK        RPCHTP                                       CIR008
                                                                                              CIR008
      ** Amend User                                                                           217684
     C                   EVAL      FIUSRA = PsUser                                            217684
                                                                                              217684
     C                   ENDIF                                                                CIR008
                                                                                              CAP056
      ** Update Auto Authorisation on DEALSDG with value from Valid file                      CAP056
                                                                                              CAP056
     C                   IF        CAP056 = 'Y'                                               CAP056
     C                             OR CAP051 = 'Y'                                           BUG6671
     C                   EVAL      FIAUTH = RPAUTH                                            CAP056
     C                   ENDIF                                                                CAP056
 
      ** Set up "before" status of deal for on-line updates
 
     C                   EVAL      Z#BSTS = DEALS
     C                   MOVE      RPDLNO        PDlNo
 
      ** Store "before" values for later comparison
 
     C                   EVAL      WkUEINR = UEINR
     C                   EVAL      WkTEINR = TEINR
     C                   EVAL      WkUNICD = UNICD
     C                   EVAL      WkTNICD = TNICD
     C                   EVAL      WkUFRFD = UFRFD
     C                   EVAL      WkTFRFD = TFRFD
     C                   EVAL      WUIPBD = UIPBD
     C                   EVAL      WTIPBD = TIPBD
     C                   EVAL      WUNIPD = UNIPD
     C                   EVAL      WTNIPD = TNIPD
     C                   EVAL      WL1AMC = L1AMCN
 
      ** Determine activity for on-line updates
      ***only*if*the*deal*is*authorised.*Else*perform*in*SrAuthorise.*                CIR008 BUG4788
 
     C**********         IF        RPCHTP <> *BLANKS                                  CIR008 BUG4788
     C                   CALLB     'DL2900'
     C                   PARM      *BLANK        PRtCd
     C                   PARM                    PDlNo
     C                   PARM      'B'           PBeAf
 
     C                   IF        PRtCd = '*ERROR'
     C                   EVAL      DBFILE = 'DL2900'
     C                   EVAL      DBASE = 3
     C                   EVAL      DBKEY = *BLANK
     C                   EXSR      *PSSR
     C                   ENDIF
     C**********         ENDIF                                                        CIR008 BUG4788
 
      ** Set Confirmation bit on deal and confirmation required indicator
      ** is to be written to DTRIX
      ** when CIR008 is switched off or auto authorisation is not 'Y'                         CIR008
 
     C**********         IF        CIR008 = 'N'  OR                                  CIR008 BUG6877N
     C**********                   CIR008 = 'Y'  AND BQFIRA <> 'Y'                   CIR008 BUG6877N
     C                   EXSR      SrCnfAmd
     C**********         ENDIF                                                       CIR008 BUG6877N
 
      ** Deal details
 
     C                   MOVE      WVRPDet1      WFRPDet1
     C                   MOVE      WVRPDet2      WFRPDet2
                                                                                              CDL028
     C                   IF        CDL028 = 'Y'                                               CDL028
     C                   MOVE      WVRPDet3      WFRPDet3                                     CDL028
     C                   ENDIF                                                                CDL028
 
      ** Business Day Conventions details (OUR)
 
     C                   IF        CIR005 = 'Y' AND RPUNIPD = WUIPBD AND
     C                             WL1AMC = 'A' AND RPAMC1 = WL1AMC
 
     C                   EVAL      UNIPD = WUNIPD
     C                   ENDIF
 
      ** Business Day Conventions details (THEIR)
 
     C                   IF        CIR005 = 'Y' AND RPTNIPD = WTIPBD AND
     C                             WL1AMC = 'A' AND RPAMC1 = WL1AMC
 
     C                   EVAL      TNIPD = WTNIPD
     C                   ENDIF
 
      ** Receive settlement instructions
 
     C                   EVAL      WFRPRecv = WVRPRecv
     C                   EVAL      RONS = RPRONS                                              CGL029
 
      ** Payment settlement instructions
 
     C                   EVAL      WFRPPay1 = WVRPPay1
     C                   EVAL      WFRPPay2 = WVRPPay2
     C                   EVAL      WFRPPay3 = WVRPPay3
     C                   EVAL      PONS = RPPONS                                              CGL029
 
      ** 'OLD' settlement instructions
 
     C                   EVAL      RSETM = RPRSTM
     C                   EVAL      URACC = RPRONS
 
      ** Our receiving account = Customer default account, if method 04
 
     C                   IF        RPRSTM = 04
     C                   MOVEL     RPCNUM        Wrk_10
     C                   MOVE      BMACCD        Wrk_10
     C                   MOVEL     Wrk_10        URACC
     C                   MOVE      '01'          URACC
     C                   ENDIF
 
     C                   EVAL      CPPBK = RPRCRN
     C                   EVAL      PSETM = RPPSTM
     C                   EVAL      UPACC = RPPONS
 
      ** Our payment account = Customer default account, if method 04
 
     C                   IF        RPPSTM = 04
     C                   MOVEL     RPCNUM        Wrk_10
     C                   MOVE      BMACCD        Wrk_10
     C                   MOVEL     Wrk_10        UPACC
     C                   MOVE      '01'          UPACC
     C                   ENDIF
 
     C                   EVAL      CPRBK = RPAWBN
     C                   EVAL      FACO = RPBENN
     C                   EVAL      SPI = RPBTB1
                                                                                              CDL038
      ** Class                                                                                CDL038
     C                   EVAL      CLAS = RPCLAS                                              CDL038
 
      ** Set up required fields on DEALSDG that were not set up on valid file
 
     C                   EXSR      SrSetReqFldA
 
      ** Set Transaction No. of Last Update
 
     C                   IN        MNATN
     C                   EVAL      TNLU = NATN
 
      ** If compliance watch is installed, and entry watch list checking                      CSD015
      ** is being applied, perform compliance watch processing for amend mode                 CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'  AND  W1EWLC = 'Y'                            CSD015
                                                                                              CSD015
     C                   IF        (CSC011 = 'Y' AND S1MAIN = LIBR)                           CSD015
     C                             OR CSC011 = 'N'                                            CSD015
                                                                                              CSD015
     C                   EVAL      WUNCF = *Blanks                                            CSD015
     C                   EVAL      WFUNT = 'DEALSDG'                                          CSD015
     C                   MOVEL     DLNO          WIDEN                                        CSD015
     C     CWHTKY        CHAIN     SDCWHTL1                                                   CSD015
                                                                                              CSD015
     C                   IF        %FOUND(SDCWHTL1) AND W3UNCF = 'Y'                          CSD015
     C                             OR NOT %FOUND(SDCWHTL1)                                    CSD015
                                                                                              CSD015
     C                   IF        %FOUND(SDCWHTL1)                                           CSD015
     C                   EVAL      WUNCF = W3UNCF                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EXSR      SrWatch                                                    CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Update Deal record on the master file
 
     C                   UPDATE    DEALSDGF
 
     C                   IF        CAP043 = 'Y' AND CAP041 = 'Y' AND                          CAP043
     C                             PScreenInpt <> 'Y'                                         CAP043
     C                   EXSR      SRClearPC                                                  CAP043
     C                   EXSR      SRWritePC                                                  CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      /COPY WNCPYSRC,IRCACFDC06
      ** Call PGM/DL2900 to set up deal activity for on-line updates
      ***only*if*the*deal*is*authorised.*Else*perform*in*SrAuthorise.*                CIR008 BUG4788
 
     C**********         IF        RPCHTP <> *BLANKS                                  CIR008 BUG4788
     C                   EVAL      Z#ASTS = DEALS
     C                   MOVE      RPDLNO        PDlNo
 
     C                   CALLB     'DL2900'
     C                   PARM      *BLANK        PRtCd
     C                   PARM                    PDlNo
     C                   PARM      'A'           PBeAf
 
     C                   IF        PRtCd = '*ERROR'
     C                   EVAL      DBFILE = 'DL2900'
     C                   EVAL      DBASE = 4
     C                   EVAL      DBKEY = *BLANK
     C                   EXSR      *PSSR
     C                   ENDIF
     C**********         ENDIF                                                        CIR008 BUG4788
 
     C                   ENDSR
                                                                                              CAP043
      ****************************************************************                        CAP043
      /EJECT                                                                                  CAP043
      ****************************************************************                        CAP043
      * SRClearPC - Clear Principal Change date records              *                        CAP043
      ****************************************************************                        CAP043
     C     SRClearPC     BEGSR                                                                CAP043
                                                                                              CAP043
      ** Clear all dates for this transaction except those already                            CAP043
      ** processed (Principal Change)                                                         CAP043
                                                                                              CAP043
     C     KDTSC         SETLL     DLPCSCD0                                                   CAP043
     C     KDTSC         READE     DLPCSCD0                               98                  CAP043
                                                                                              CAP043
     C     *IN98         DOWEQ     '0'                                                        CAP043
                                                                                              CAP043
     C     PCDTPR        IFNE      'Y'                                                        CAP043
     C     PCDTPR        ANDNE     'y'                                                        CAP043
     C                   DELETE    DLPCSCD0                                                   CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C     KDTSC         READE     DLPCSCD0                               98                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
     C                   ENDSR                                                                CAP043
                                                                                              CAP043
      ****************************************************************                        CAP043
      /EJECT                                                                                  CAP043
      ****************************************************************                        CAP043
      * SRWritePC -Write Princiapl Change records                    *                        CAP043
      ****************************************************************                        CAP043
                                                                                              CAP043
     C     SRWritePC     BEGSR                                                                CAP043
                                                                                              CAP043
      ** Update DLPCSCPD thru records in valids file IRVPCSCPD                                CAP043
      ** on when CAP043 is on                                                                 CAP043
                                                                                              CAP043
     C     KIRCList      SETLL     IRVPCSCL0                                                  CAP043
     C     KIRCList      READE     IRVPCSCL0                                                  CAP043
                                                                                              CAP043
     C                   DOW       NOT %EOF                                                   CAP043
                                                                                              CAP043
      ** Set up database fields                                                               CAP043
                                                                                              CAP043
     C                   EVAL      PCDLNO = DLNO                                              CAP043
     C                   EVAL      PCOTIN = *BLANK                                            CAP043
     C                   EVAL      PCDTPR = *BLANK                                            CAP043
     C                   EVAL      PCPMTP = *BLANK                                            CAP043
                                                                                              CAP043
      ** Our Principal Change Schedule                                                        CAP043
                                                                                              CAP043
     C                   IF        (PVYOURTHR = ' ')                                          CAP043
     C                   EVAL      X = 1                                                      CAP043
                                                                                              CAP043
      ** Get principal change control date                                                    CAP043
                                                                                              CAP043
     C                   EXSR      SRGetCtlDate                                               CAP043
                                                                                              CAP043
     C                   DOW       (X < 83) AND (WPrinChgD(X) <> 0)                           CAP043
     C                   Z-ADD     WPrinChgD(X)  PCPRDT                                       CAP043
     C                   Z-ADD     WPrinChgA(X)  PCPAMT                                       CAP043
     C                   Z-ADD     *ZERO         PCCAMT                                       CAP043
                                                                                              CAP043
      ** Midas-Plato Interface is switched on                                                 CAP043
                                                                                              CAP043
     C                   IF        BGN2ST = 'Y'                                               CAP043
                                                                                              CAP043
      ** Move amount to workfield for computation                                             CAP043
                                                                                              CAP043
     C                   Z-ADD     PCPAMT        WPAMT                                        CAP043
                                                                                              CAP043
      ** Calculate for the new principal amount                                               CAP043
                                                                                              CAP043
     C                   IF        WPCSCIDInd(X) = 'D'                                        CAP043
     C                   Z-SUB     WPAMT         WPAMT                                        CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** If date entered is on or prior to the control date, add the change amount            CAP043
      ** to original principal amount                                                         CAP043
                                                                                              CAP043
     C                   IF        PCPRDT <= WCTLDYN                                          CAP043
     C                   EVAL      PCPAMT = RPUPAMT + WPAMT                                   CAP043
     C                   ELSE                                                                 CAP043
                                                                                              CAP043
      ** If date entered is between existing records, access the previous record and add      CAP043
      ** change amount to the principal amount on this record                                 CAP043
                                                                                              CAP043
     C     KIRSDL        SETLL     DLPCSCL0                                                   CAP043
     C                   READP     DLPCSCL0                                                   CAP043
                                                                                              CAP043
     C                   IF        NOT %EOF(DLPCSCL0) AND (PCDLNO = XXDLNO) AND               CAP043
     C                             (PCOTIN = XXOTIN)                                          CAP043
     C                   EVAL      PCPAMT = XXPAMT + WPAMT                                    CAP043
     C                   ELSE                                                                 CAP043
     C                   EVAL      PCPAMT = RPUPAMT + WPAMT                                   CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   Z-ADD     WPAMT         PCCAMT                                       CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
     C                   EVAL      PCCOHO = WPCSCConfH(X)                                     CAP043
     C                   WRITE     DLPCSCD0                                                   CAP043
                                                                                              CAP043
      ** Update records with processing dates greater than the processing                     CAP043
      ** date of the inserted record                                                          CAP043
                                                                                              CAP043
     C                   IF        BGN2ST = 'Y'                                               CAP043
     C                   EXSR      SRUpdPCSC                                                  CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   EVAL      X = X + 1                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C     KIRCList      READE     IRVPCSCL0                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
     C                   ENDSR                                                                CAP043
                                                                                              CAP043
      ********************************************************************                    CAP043
      /EJECT                                                                                  CAP043
      ********************************************************************                    CAP043
      *                                                                  *                    CAP043
      * SRGetCtlDate - Get Control Date                                  *                    CAP043
      *                                                                  *                    CAP043
      ********************************************************************                    CAP043
                                                                                              CAP043
     C     SRGetCtlDate  BEGSR                                                                CAP043
                                                                                              CAP043
      ** Get control date - the first non-processed date                                      CAP043
                                                                                              CAP043
     C                   EVAL      PCPRDT = *ZERO                                             CAP043
     C                   EVAL      WCTLDYN = *ZERO                                            CAP043
                                                                                              CAP043
     C     KIRSDL        SETLL     DLPCSCL0                                                   CAP043
     C     KIRSDP        READE     DLPCSCL0                                                   CAP043
                                                                                              CAP043
     C                   DOW       NOT %EOF(DLPCSCL0) AND                                     CAP043
     C                             WCTLDYN = *ZERO                                            CAP043
     C                   IF        XXDTPR <> 'Y'                                              CAP043
     C                   Z-ADD     XXPRDT        WCTLDYN                                      CAP043
     C                   ENDIF                                                                CAP043
     C     KIRSDP        READE     DLPCSCL0                                                   CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** If nothing was found, default control date to next principal                         CAP043
      ** change date                                                                          CAP043
                                                                                              CAP043
     C                   IF        (WCTLDYN = *ZERO)                                          CAP043
     C                   IF        (RPUNPCD <> *ZERO) AND (PVYOURTHR = 'U')                   CAP043
     C                   EVAL      WCTLDYN = RPUNPCD                                          CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDSR                                                                CAP043
                                                                                              CAP043
      ********************************************************************                    CAP043
      /EJECT                                                                                  CAP043
      ********************************************************************                    CAP043
      *                                                                  *                    CAP043
      * SRUpdPCSC - Change Principal Amount of affected record           *                    CAP043
      *                                                                  *                    CAP043
      ********************************************************************                    CAP043
                                                                                              CAP043
     C     SRUpdPCSC     BEGSR                                                                CAP043
                                                                                              CAP043
     C     KIRSDL        SETGT     DLPCSCL0                                                   CAP043
     C     KIRSDP        READE     DLPCSCL0                                                   CAP043
                                                                                              CAP043
     C                   DOW       NOT %EOF(DLPCSCL0)                                         CAP043
     C                   EVAL      XXPAMT = XXPAMT + WPAMT                                    CAP043
     C                   UPDATE    DLPCSCX0                                                   CAP043
     C     KIRSDP        READE     DLPCSCL0                                                   CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
     C                   ENDSR                                                                CAP043
                                                                                              CAP043
      ****************************************************************
      /EJECT
      ****************************************************************
      * SrDelete- Delete an IRS Record                               *
      ****************************************************************
     C     SrDelete      BEGSR
 
      ** Access deal record
 
     C     RPDLNO        CHAIN     DEALSDGF                           89
 
      ** If not found, database error
 
     C                   IF        *IN89 = *ON
     C                   MOVEL     RPDLNO        DBKEY
     C                   EVAL      DBFILE = 'DEALSDG '
     C                   EVAL      DBASE = 5
     C                   EXSR      SrErr
     C                   ENDIF
                                                                                              CIR008
      ** Deal Status and Change Type                                                          CIR008
                                                                                              CIR008
     C                   IF        CIR008 = 'Y'                                               CIR008
     C                   CALLB     'ZAFUTSTATP'                                               CIR008
     C                   PARM      'D'           P_ACTN                                       CIR008
     C                   PARM      FIDSTS        P_CSTS                                       CIR008
     C                   PARM                    BQFIAU                                       CIR008
     C                   PARM                    BQFIRA                                       CIR008
     C                   PARM      *BLANK        FIDSTS                                       CIR008
     C                   PARM      *BLANK        RPCHTP                                       CIR008
     C                   ENDIF                                                                CIR008
 
      ** Set up "before" status of deal for on-line updates
      ***only*if*the*deal*is*authorised.*Else*perform*in*SrAuthorise.*                CIR008 BUG4788
 
     C**********         IF        RPCHTP <> *BLANKS                                  CIR008 BUG4788
     C                   EVAL      Z#BSTS = IRVCACF
     C                   MOVE      RPDLNO        PDlNo
 
     C                   CALLB     'DL2900'
     C                   PARM      *BLANK        PRtCd
     C                   PARM                    PDlNo
     C                   PARM      'B'           PBeAf
 
     C                   IF        PRtCd = '*ERROR'
     C                   EVAL      DBFILE = 'DL2900'
     C                   EVAL      DBASE = 6
     C                   EVAL      DBKEY = *BLANK
     C                   EXSR      *PSSR
     C                   ENDIF
     C**********         ENDIF                                                        CIR008 BUG4788
 
      ** Set confirmation bit on deal and confirmation required indicator
      ** to be written to DTRIX
 
     C                   EXSR      SrCnfDel
 
      ** Flag record id as 'REVERSED'
 
     C                   EVAL      RECI = 'R'
 
      ** Last change date & type
 
     C                   EVAL      LCD = BJRDNB
     C**********         EVAL      CHTP = RPCHTP                                      CIR008 BUG4788
     C                   MOVE      'R'           CHTP                                        BUG4788
 
      ** Set Transaction No. of Last Update
 
     C                   IN        MNATN
     C                   EVAL      TNLU = NATN
 
      ** Front office transaction ID
 
     C                   EVAL      FRNT = RPFRNT
 
     C                   UPDATE    DEALSDGF
                                                                                              CAP043
     C                   IF        CAP043 = 'Y' AND CAP041 = 'Y' AND                          CAP043
     C                             PScreenInpt <> 'Y'                                         CAP043
     C                   EXSR      SRClearPC                                                  CAP043
     C                   ENDIF                                                                CAP043
 
      /COPY WNCPYSRC,IRCACFDC07
      ** Call PGM/DL2900 to set up deal activity for on-line updates
      ***only*if*the*deal*is*authorised.*Else*perform*in*SrAuthorise.*                CIR008 BUG4788
 
     C**********         IF        RPCHTP <> *BLANKS                                  CIR008 BUG4788
     C                   EVAL      Z#ASTS = DEALS
     C                   MOVE      RPDLNO        PDlNo
 
     C                   CALLB     'DL2900'
     C                   PARM      *BLANK        PRtCd
     C                   PARM                    PDlNo
     C                   PARM      'A'           PBeAf
 
     C                   IF        PRtCd = '*ERROR'
     C                   EVAL      DBFILE = 'DL2900'
     C                   EVAL      DBASE = 7
     C                   EVAL      DBKEY = *BLANK
     C                   EXSR      *PSSR
     C                   ENDIF
     C**********         ENDIF                                                        CIR008 BUG4788
 
     C                   ENDSR
      *****************************************************************                       CIR008
      /EJECT                                                                                  CIR008
      *****************************************************************                       CIR008
      * SrAuthorise - Authorise an IRS Record                         *                       CIR008
      *****************************************************************                       CIR008
     C     SrAuthorise   BEGSR                                                                CIR008
                                                                                              CIR008
      ** Access Deal                                                                          CIR008
                                                                                              CIR008
     C     RPDLNO        CHAIN     DEALSDGF                           89                      CIR008
                                                                                              CIR008
      ** If not found, database error                                                         CIR008
                                                                                              CIR008
     C                   IF        *IN89 = *ON                                                CIR008
     C                   MOVE      RPDLNO        DBKEY                                        CIR008
     C                   EVAL      DBFILE = 'DEALSDG'                                         CIR008
     C                   EVAL      DBASE = 13                                                 CIR008
     C                   EXSR      SRERR                                                      CIR008
     C                   END                                                                  CIR008
                                                                                              CIR008
      ** Set Confirmation required indicator to be written to DTRIX                           CIR008
                                                                                              CIR008
     C     FIDSTS        CASEQ     'C'           SrCnfIns                                     CIR008
     C     FIDSTS        CASEQ     'R'           SrCnfAmd                                     CIR008
     C                   END                                                                  CIR008
                                                                                              CIR008
      ** Deal Status and Change Type                                                          CIR008
                                                                                              CIR008
     C                   CALLB     'ZAFUTSTATP'                                               CIR008
     C                   PARM      'X'           P_ACTN                                       CIR008
     C                   PARM      FIDSTS        P_CSTS                                       CIR008
     C                   PARM                    BQFIAU                                       CIR008
     C                   PARM                    BQFIRA                                       CIR008
     C                   PARM      *BLANK        FIDSTS                                       CIR008
     C                   PARM      *BLANK        RPCHTP                                       CIR008
                                                                                              CIR008
     C                   EVAL      CHTP = RPCHTP                                              CIR008
                                                                                              CIR008
      ** Authorise User                                                                       217684
     C                   EVAL      FIUSRX = PsUser                                            217684
                                                                                              217684
      ** Last change date                                                                     CIR008
                                                                                              CIR008
     C                   Z-ADD     BJRDNB        LCD                                          CIR008
                                                                                              CIR008
      ***Set*up*"before"*status*of*deal*for*on-line*updates,*                         CIR008 BUG4788
      ***for*Amends*and*Deletes*                                                      CIR008 BUG4788
                                                                                              CIR008
     C**********         IF        RPCHTP = 'A' OR RPCHTP = 'R'                       CIR008 BUG4788
     C**********         EVAL      Z#BSTS = IRVCACF                                   CIR008 BUG4788
     C**********         MOVE      RPDLNO        PDlNo                                CIR008 BUG4788
                                                                                              CIR008
     C**********         CALLB     'DL2900'                                           CIR008 BUG4788
     C**********         PARM      *BLANK        PRtCd                                CIR008 BUG4788
     C**********         PARM                    PDlNo                                CIR008 BUG4788
     C**********         PARM      'B'           PBeAf                                CIR008 BUG4788
                                                                                              CIR008
     C**********         IF        PRtCd = '*ERROR'                                   CIR008 BUG4788
     C**********         EVAL      DBFILE = 'DL2900'                                  CIR008 BUG4788
     C**********         EVAL      DBASE = 14                                         CIR008 BUG4788
     C**********         EVAL      DBKEY = *BLANK                                     CIR008 BUG4788
     C**********         EXSR      *PSSR                                              CIR008 BUG4788
     C**********         ENDIF                                                        CIR008 BUG4788
     C**********         ENDIF                                                        CIR008 BUG4788
                                                                                              CIR008
      **  Update Record                                                                       CIR008
                                                                                              CIR008
     C                   UPDATE    DEALSDGF                                                   CIR008
                                                                                              CIR008
      ***Set*up*"after"*status*of*deal*for*on-line*updates*                           CIR008 BUG4788
                                                                                              CIR008
     C**********         EVAL      Z#ASTS = DEALS                                     CIR008 BUG4788
     C**********         MOVE      RPDLNO        PDlNo                                CIR008 BUG4788
                                                                                              CIR008
     C**********         CALLB     'DL2900'                                           CIR008 BUG4788
     C**********         PARM      *BLANK        PRtCd                                CIR008 BUG4788
     C**********         PARM                    PDlNo                                CIR008 BUG4788
     C**********         PARM      'A'           PBeAf                                CIR008 BUG4788
                                                                                              CIR008
     C**********         IF        PRtCd = '*ERROR'                                   CIR008 BUG4788
     C**********         EVAL      DBFILE = 'DL2900'                                  CIR008 BUG4788
     C**********         EVAL      DBASE = 15                                         CIR008 BUG4788
     C**********         EVAL      DBKEY = *BLANK                                     CIR008 BUG4788
     C**********         EXSR      *PSSR                                              CIR008 BUG4788
     C**********         ENDIF                                                        CIR008 BUG4788
                                                                                              CIR008
     C                   ENDSR                                                                CIR008
      ****************************************************************
      /EJECT
      ****************************************************************
      * SrSetReqFldI - Set up Required Fields on DEALSDG that were   *
      *                not set up on Valid File - Insert Processing  *
      ****************************************************************
     C     SrSetReqFldI  BEGSR
 
      ** Original Entry Date & Last Change Date
 
     C                   EVAL      ORED = BJRDNB
     C                   EVAL      LCD = BJRDNB
 
      ** Hedge Indicator
 
     C                   EXSR      SrBookDet
     C                   EVAL      HEDIN = BDHGIN
 
      ** Our/Their effective interest rate
 
     C                   IF        RPUBRTT = *ZEROS
     C                   EVAL      UEINR = URTSP
     C                   ENDIF
 
     C                   IF        RPTBRTT = *ZEROS
     C                   EVAL      TEINR = TRTSP
     C                   ENDIF
 
      ** Our Floating Rate Fix Days
      ** (Defaulting done in IRVRTFXDAY)
 
     C                   IF        RPUBRTT = *ZEROS
 
     C                   EVAL      UINFD = *ZEROS
     C                   ELSE
 
      ** Our interest fix date
 
     C                   EVAL      PZInDt = VDAT
     C                   MOVE      UFRFD         WZRfDy
 
      ** If 'currency for rate fix holiday' flag from FRA/IRS I.C.D.
      ** is 'F', 'L' or 'D', set currency code to 'sterling code',
      ** 'local currency code' or 'screen currency code' respectively
 
     C                   IF        BQCRFH = 'F'
     C                   EVAL      PZCcy = BLCYCD
     C                   ENDIF
 
     C                   IF        BQCRFH = 'L'
     C                   EVAL      PZCcy = BJLCCY
     C                   ENDIF
 
     C                   IF        BQCRFH = 'D' OR  BQCRFH = ' '
     C                   EVAL      PZCcy = RPUCUCY
     C                   ENDIF
 
     C                   EVAL      PZLoc = *BLANKS
 
      ** Use Rate Fixing Currencies to get rate fixing date when CIR005
      ** is installed. Otherwise, use transaction ccy
 
     C                   IF        CIR005 = 'Y' AND RPC1R1 <> *BLANKS
     C                   EVAL      PPRfDy = WZRfDy
 
     C                   CALLB     'IRRTFXCNV'
     C                   PARM                    PZInDt
     C                   PARM                    PPRfDy
     C                   PARM                    PZLoc
     C                   PARM                    WVRtFxCcy
     C                   PARM                    PZRfDt
 
     C                   ELSE
     C                   EXSR      SrDlBack
     C                   ENDIF
 
      ** If deal forward-valued AND Short Term Rate NOT entered then
      ** the Next Interest Rate Fix Date must be that associated
      ** with the Value Date...
 
     C                   IF        PZRfDt >= BJRDNB AND RPUEINR = *ZEROS
     C                   EVAL      UINFD = PZRfDt
 
      **  ...else the Next Interest Rate Fix Date must be that
      **  associated with the Next Rate Change Date
 
     C                   ELSE
 
     C                   IF        RPUNICD <> *ZEROS
     C                   EVAL      PZInDt = UNICD
     C                   MOVE      UFRFD         WZRfDy
 
      ** If 'currency for rate fix holiday' flag from FRA/IRS I.C.D.
      ** is 'F', 'L' or 'D', set currency code to 'sterling code',
      ** 'local currency code' or 'screen currency code' respectively
 
     C                   IF        BQCRFH = 'F'
     C                   EVAL      PZCcy = BLCYCD
     C                   ENDIF
 
     C                   IF        BQCRFH = 'L'
     C                   EVAL      PZCcy = BJLCCY
     C                   ENDIF
 
     C                   IF        BQCRFH = 'D' OR BQCRFH = ' '
     C                   EVAL      PZCcy = RPUCUCY
     C                   ENDIF
 
     C                   EVAL      PZLoc = *BLANKS
 
      ** Use Rate Fixing Currencies to get rate fixing date when
      ** CIR005 is on. Otherwise, use transaction ccy.
 
     C                   IF        CIR005 = 'Y' AND RPC1R1 <> *BLANKS
     C                   EVAL      PPRfDy = WZRfDy
 
     C                   CALLB     'IRRTFXCNV'
     C                   PARM                    PZInDt
     C                   PARM                    PPRfDy
     C                   PARM                    PZLoc
     C                   PARM                    WVRtFxCcy
     C                   PARM                    PZRfDt
 
     C                   ELSE
     C                   EXSR      SrDlBack
     C                   ENDIF
 
     C                   EVAL      UINFD = PZRfDt
     C                   ELSE
     C                   EVAL      UINFD = *ZEROS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Their Floating Rate Fix Days
      ** (Defaulting done in IRVRTFXDAY)
 
      ** User pays Fixed Rate, Counterparty pays Floating Rate
 
     C                   IF        RPTBRTT = *ZEROS
     C                   EVAL      TINFD = 0
     C                   ELSE
 
      ** User pays Fixed Rate, Counterparty pays Floating Rate
 
     C                   EVAL      PZInDt = VDAT
     C                   MOVE      TFRFD         WZRfDy
 
      ** If 'currency for rate fix holiday' flag from FRA/IRS I.C.D.
      ** is 'F', 'L' or 'D', set currency code to 'sterling code',
      ** 'local currency code' or 'screen currency code' respectively
 
     C                   IF        BQCRFH = 'F'
     C                   MOVE      BLCYCD        PZCcy
     C                   ENDIF
 
     C                   IF        BQCRFH = 'L'
     C                   MOVE      BJLCCY        PZCcy
     C                   ENDIF
 
     C                   IF        BQCRFH = 'D' OR BQCRFH = ' '
     C                   MOVE      RPUCUCY       PZCcy
     C                   ENDIF
 
     C                   EVAL      PZLoc = *BLANKS
 
      ** Use Rate Fixing Currencies to get rate fixing date when
      ** CIR005 is on. Otherwise, use transaction ccy.
 
     C                   IF        CIR005 = 'Y' AND RPC1R1 <> *BLANKS
     C                   EVAL      PPRfDy = WZRfDy
 
     C                   CALLB     'IRRTFXCNV'
     C                   PARM                    PZInDt
     C                   PARM                    PPRfDy
     C                   PARM                    PZLoc
     C                   PARM                    WVRtFxCcy
     C                   PARM                    PZRfDt
     C                   ELSE
     C                   EXSR      SrDlBack
     C                   ENDIF
 
      ** If deal forward-valued AND Short Term Rate NOT entered then
      ** the Next Interest Rate Fix Date must be that associated
      ** with the Value Date...
 
     C                   IF        PZRfDt >= BJRDNB AND RPTEINR = *ZEROS
     C                   EVAL      TINFD = PZRfDt
     C                   ELSE
 
      ** ...else the Next Interest Rate Fix Date must be that
      ** associated with the Next Rate Change Date.
 
     C                   IF        RPTNICD <> *ZEROS
     C                   EVAL      PZInDt = TNICD
     C                   MOVE      TFRFD         WZRfDy
 
      ** If 'currency for rate fix holiday' flag from FRA/IRS I.C.D.
      ** is 'F', 'L' or 'D', set currency code to 'sterling code',
      ** 'local currency code' or 'screen currency code' respectively
 
     C                   IF        BQCRFH = 'F'
     C                   EVAL      PZCcy = BLCYCD
     C                   ENDIF
 
     C                   IF        BQCRFH = 'L'
     C                   EVAL      PZCcy = BJLCCY
     C                   ENDIF
 
     C                   IF        BQCRFH = 'D' OR  BQCRFH = ' '
     C                   EVAL      PZCcy = RPUCUCY
     C                   ENDIF
 
     C                   EVAL      PZLoc = *BLANKS
 
      ** Use Rate Fixing Currencies to get rate fixing date when
      ** CIR005 is on. Otherwise, use transaction ccy.
 
     C                   IF        CIR005 = 'Y' AND RPC1R1 <> *BLANKS
     C                   EVAL      PPRfDy = WZRfDy
 
     C                   CALLB     'IRRTFXCNV'
     C                   PARM                    PZInDt
     C                   PARM                    PPRfDy
     C                   PARM                    PZLoc
     C                   PARM                    WVRtFxCcy
     C                   PARM                    PZRfDt
     C                   ELSE
     C                   EXSR      SrDlBack
     C                   ENDIF
 
     C                   EVAL      TINFD = PZRfDt
     C                   ELSE
     C                   EVAL      TINFD = 0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Start/Last Interest Payment Date
 
     C                   IF        DTYP = 'RP' AND BYSL = 'B' OR
     C                             DTYP = 'RR' AND BYSL = 'B' OR
     C                             DTYP = 'RF' AND BYSL = 'S'
     C                   EVAL      TSLIP = VDAT
     C                   ELSE
     C                   EVAL      USLIP = VDAT
     C                   ENDIF
 
      ** Interest Rate Change Base Date
 
     C                   EVAL      UICBD = UNICD
     C                   EVAL      TICBD = TNICD
 
      ** Interest Payment Base Date
 
     C                   EVAL      UIPBD = UNIPD
     C                   EVAL      TIPBD = TNIPD
 
      ** Base Currency Exchange Rate
      ** Default if not entered
 
     C                   IF        RPUBCXR = *ZEROS
     C                   EXSR      SrDlCcyDet
     C                   EVAL      UBCXR = A6SPRT
     C                   EVAL      TBCXR = A6SPRT
     C                   ENDIF
 
      ** Interest Accrual Control Date
 
     C                   EVAL      UIACD = VDAT
     C                   EVAL      TIACD =  VDAT
 
      ** Last Interest Payment/Change Date
 
     C                   IF        RPUBRTT = *ZEROS
     C                   EVAL      ULPCD = 0
     C                   ELSE
     C                   EVAL      ULPCD = VDAT
     C                   ENDIF
 
     C                   IF        RPTBRTT = *ZEROS
     C                   EVAL      TLPCD = 0
     C                   ELSE
     C                   EVAL      TLPCD = VDAT
     C                   ENDIF
 
      ** Spread Indicators
 
     C                   IF        RPUBRTT <> *ZEROS AND RPURTSP <> *ZEROS AND
     C                             RPUSPIN = *BLANKS
     C                   EVAL      USPIN = 'A'
     C                   ENDIF
 
     C                   IF        RPTBRTT <> *ZEROS AND RPTRTSP <> *ZEROS AND
     C                             RPTSPIN = *BLANKS
     C                   EVAL      TSPIN = 'A'
     C                   ENDIF
 
      ** Non-Static Indicators
 
     C                   BITOFF    '01234567'    UDNSI
 
     C                   IF        RPUEINR <> *ZEROS
     C                   BITON     '0'           UDNSI
     C                   ENDIF
 
     C                   BITOFF    '01234567'    TDNSI
 
     C                   IF        RPTEINR <> *ZEROS
     C                   BITON     '0'           TDNSI
     C                   ENDIF
 
      ** Initialise bit settings
 
     C                   BITOFF    '01234567'    ACEI
     C                   BITOFF    '01234567'    TLXI
     C                   BITOFF    '01234567'    CNFI
 
      ** Machine Time
 
     C                   TIME                    DDTM
 
      ** Base Rate Code for Sequencing
 
     C                   EVAL      BRSQ = *ZEROS
 
      ** Start Date Current Average Period                                                   BUG7217
                                                                                             BUG7217
     C     CIR006        IFEQ      'Y'                                                       BUG7217
     C     SDCAR         ANDEQ     0                                                         BUG7217
     C                   Z-ADD     VDAT          SDCAR                                       BUG7217
     C                   ENDIF                                                               BUG7217
                                                                                             BUG7217
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * SrSetReqFldA - Set up Required Fields on DEALSDG that were   *
      *                not Set up on Valid File - Amend Processing   *
      ****************************************************************
     C     SrSetReqFldA  BEGSR
 
      **  Our/Their effective interest rate
 
     C                   IF        RPUBRTT = *ZERO
     C                   EVAL      UEINR = URTSP
     C                   ELSE
     C                   EVAL      UEINR = RPUEINR
     C                   ENDIF
 
     C                   IF        RPTBRTT = *ZEROS
     C                   EVAL      TEINR = TRTSP
     C                   ELSE
     C                   EVAL      TEINR = RPTEINR
     C                   ENDIF
 
      ** Our Floating Rate Fix Days (Defaulting done in IRVRTFXDAY)
 
     C                   IF        RPUBRTT = *ZEROS
     C                   EVAL      UINFD = 0
     C                   ELSE
 
      **  Our interest fix date
 
     C                   EVAL      PZInDt = VDAT
     C                   MOVE      UFRFD         WZRfDy
 
      ** If 'currency for rate fix holiday' flag from FRA/IRS I.C.D.
      ** is 'F', 'L' or 'D', set currency code to 'sterling code',
      ** 'local currency code' or 'screen currency code' respectively
 
     C                   IF        BQCRFH = 'F'
     C                   EVAL      PZCcy = BLCYCD
     C                   ENDIF
 
     C                   IF        BQCRFH = 'L'
     C                   EVAL      PZCcy = BJLCCY
     C                   ENDIF
 
     C                   IF        BQCRFH = 'D' OR  BQCRFH = ' '
     C                   EVAL      PZCcy = RPUCUCY
     C                   ENDIF
 
     C                   EVAL      PZLoc = *BLANKS
 
      ** Use Rate Fixing Currencies to get rate fixing date when
      ** CIR005 is on. Otherwise, use transaction ccy.
 
     C                   IF        CIR005 = 'Y' AND RPC1R1 <> *BLANKS
     C                   EVAL      PPRfDy = WZRfDy
 
     C                   CALLB     'IRRTFXCNV'
     C                   PARM                    PZInDt
     C                   PARM                    PPRfDy
     C                   PARM                    PZLoc
     C                   PARM                    WVRtFxCcy
     C                   PARM                    PZRfDt
 
     C                   ELSE
     C                   EXSR      SrDlBack
     C                   ENDIF
 
      ** If deal forward-valued AND Short Term Rate NOT entered then
      ** the Next Interest Rate Fix Date must be that associated
      ** with the Value Date...
 
     C                   IF        PZRfDt >= BJRDNB AND RPUEINR = *ZEROS
     C                   EVAL      UINFD = PZRfDt
 
      ** ...else the Next Interest Rate Fix Date must be that
      **  associated with the Next Rate Change Date.
 
     C                   ELSE
 
     C                   IF        RPUNICD <> *ZEROS
     C                   EVAL      PZInDt = UNICD
     C                   MOVE      UFRFD         WZRfDy
 
      ** If 'currency for rate fix holiday' flag from FRA/IRS I.C.D.
      ** is 'F', 'L' or 'D', set currency code to 'sterling code',
      ** 'local currency code' or 'screen currency code' respectively
 
     C                   IF        BQCRFH = 'F'
     C                   EVAL      PZCcy = BLCYCD
     C                   ENDIF
 
     C                   IF        BQCRFH = 'L'
     C                   EVAL      PZCcy = BJLCCY
     C                   ENDIF
 
     C                   IF        BQCRFH = 'D' OR BQCRFH = ' '
     C                   EVAL      PZCcy = RPUCUCY
     C                   ENDIF
 
     C                   EVAL      PZLoc = *BLANKS
 
      ** Use Rate Fixing Currencies to get rate fixing date when
      ** CIR005 is on. Otherwise, use transaction ccy.
 
     C                   IF        CIR005 = 'Y' AND RPC1R1 <> *BLANKS
     C                   EVAL      PPRfDy = WZRfDy
 
     C                   CALLB     'IRRTFXCNV'
     C                   PARM                    PZInDt
     C                   PARM                    PPRfDy
     C                   PARM                    PZLoc
     C                   PARM                    WVRtFxCcy
     C                   PARM                    PZRfDt
 
     C                   ELSE
     C                   EXSR      SrDlBack
     C                   ENDIF
 
     C                   EVAL      UINFD = PZRfDt
     C                   ELSE
     C                   EVAL      UINFD = *ZEROS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Their Floating Rate Fix Days (Defaulting done in IRVRTFXDAY)
 
     C                   IF        RPTBRTT = *ZEROS
     C                   EVAL      TINFD = *ZERO
     C                   ELSE
 
      ** User pays Fixed Rate, Counterparty pays Floating Rate
      ** Reset only, if Next Intr.Chg Date, or Rate Fix Days changed
 
     C                   EVAL      PZInDt = VDAT
     C                   MOVE      TFRFD         WZRfDy
 
      ** If 'currency for rate fix holiday' flag from FRA/IRS I.C.D.
      ** is 'F', 'L' or 'D', set currency code to 'sterling code',
      ** 'local currency code' or 'screen currency code' respectively
 
     C                   IF        BQCRFH = 'F'
     C                   EVAL      PZCcy = BLCYCD
     C                   ENDIF
 
     C                   IF        BQCRFH = 'L'
     C                   EVAL      PZCcy = BJLCCY
     C                   ENDIF
 
     C                   IF        BQCRFH = 'D' OR  BQCRFH = ' '
     C                   EVAL      PZCcy = RPUCUCY
     C                   ENDIF
 
     C                   EVAL      PZLoc = *BLANKS
 
      ** Use Rate Fixing Currencies to get rate fixing date when
      ** CIR005 is on. Otherwise, use transaction ccy.
 
     C                   IF        CIR005 = 'Y' AND RPC1R1 <> *BLANKS
     C                   EVAL      PPRfDy = WZRfDy
 
     C                   CALLB     'IRRTFXCNV'
     C                   PARM                    PZInDt
     C                   PARM                    PPRfDy
     C                   PARM                    PZLoc
     C                   PARM                    WVRtFxCcy
     C                   PARM                    PZRfDt
 
     C                   ELSE
     C                   EXSR      SrDlBack
     C                   ENDIF
 
      ** If deal forward-valued AND Short Term Rate NOT entered then
      ** the Next Interest Rate Fix Date must be that associated
      ** with the Value Date...
 
     C                   IF        PZRfDt >= BJRDNB AND RPTEINR = *ZEROS
     C                   EVAL      TINFD = PZRfDt
     C                   ELSE
 
      ** ...else the Next Interest Rate Fix Date must be that
      ** associated with the Next Rate Change Date.
 
     C                   IF        RPTNICD <> *ZEROS
     C                   EVAL      PZInDt = TNICD
     C                   MOVE      TFRFD         WZRfDy
 
      ** If 'currency for rate fix holiday' flag from FRA/IRS I.C.D.
      ** is 'F', 'L' or 'D', set currency code to 'sterling code',
      ** 'local currency code' or 'screen currency code' respectively
 
     C                   IF        BQCRFH = 'F'
     C                   EVAL      PZCcy = BLCYCD
     C                   ENDIF
 
     C                   IF        BQCRFH = 'L'
     C                   EVAL      PZCcy = BJLCCY
     C                   ENDIF
 
     C                   IF        BQCRFH = 'D' OR BQCRFH = ' '
     C                   EVAL      PZCcy = RPUCUCY
     C                   ENDIF
 
     C                   EVAL      PZLoc = *BLANKS
 
      ** Use Rate Fixing Currencies to get rate fixing date when
      ** CIR005 is on. Otherwise, use transaction ccy.
 
     C                   IF        CIR005 = 'Y' AND RPC1R1 <> *BLANKS
     C                   EVAL      PPRfDy = WZRfDy
 
     C                   CALLB     'IRRTFXCNV'
     C                   PARM                    PZInDt
     C                   PARM                    PPRfDy
     C                   PARM                    PZLoc
     C                   PARM                    WVRtFxCcy
     C                   PARM                    PZRfDt
 
     C                   ELSE
     C                   EXSR      SrDlBack
     C                   ENDIF
 
     C                   EVAL      TINFD = PZRfDt
     C                   ELSE
     C                   EVAL      TINFD = *ZEROS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Interest Rate Change Base Date
 
     C                   EVAL      UICBD = UNICD
     C                   EVAL      TICBD = TNICD
 
      ** Interest Payment Base Date
 
     C                   EVAL      UIPBD = UNIPD
     C                   EVAL      TIPBD = TNIPD
 
      ** Business Day Conventions details (OUR)
 
     C                   IF        CIR005 = 'Y' AND RPUNIPD = WUIPBD AND
     C                             WL1AMC = 'A' AND RPAMC1 = WL1AMC OR
     C                             CIR005 = 'Y' AND RPUNIPD = WUNIPD AND
     C                             WL1AMC <> 'A' AND RPAMC1 = WL1AMC
 
     C                   EVAL      UIPBD = WUIPBD
     C                   ENDIF
 
      ** Business Day Conventions details (THEIR)
 
     C                   IF        CIR005 = 'Y' AND RPTNIPD = WTIPBD AND
     C                             WL1AMC = 'A' AND RPAMC1 = WL1AMC OR
     C                             CIR005 = 'Y' AND RPTNIPD = WTNIPD AND
     C                             WL1AMC <> 'A' AND RPAMC1 = WL1AMC
 
     C                   EVAL      TIPBD = WTIPBD
     C                   ENDIF
 
      ** Base Currency Exchange Rate
      ** Default if not entered
 
     C                   IF        RPUBCXR = *ZEROS
     C                   EXSR      SrDlCcyDet
     C                   EVAL      UBCXR = A6SPRT
     C                   EVAL      TBCXR = A6SPRT
     C                   ENDIF
 
      ** Spread Indicators
 
     C                   IF        RPUBRTT <> *ZEROS AND RPURTSP <> *ZEROS AND
     C                             RPUSPIN = *BLANKS
     C                   EVAL      USPIN = 'A'
     C                   ENDIF
 
     C                   IF        RPTBRTT <> *ZEROS AND RPTRTSP <> *ZEROS AND
     C                             RPTSPIN = *BLANKS
     C                   EVAL      TSPIN = 'A'
     C                   ENDIF
 
      ** Non-Static Indicators:
      ** Our short term rate / initial rate set entered bits
 
     C                   IF        RPUBRTT <> *ZEROS AND UEINR <> WkUEINR
     C                   BITON     '02'          UDNSI
     C                   ENDIF
 
      ** Their short term rate / initial rate set entered bits
 
     C                   IF        RPTBRTT <> *ZEROS AND TEINR <> WkTEINR
     C                   BITON     '02'          TDNSI
     C                   ENDIF
 
      ** Last Change Date & Last Change Type
 
     C                   EVAL      LCD = BJRDNB
 
      ** Machine Time
 
     C                   TIME                    DDTM
 
      ** Base Rate Code for Sequencing
 
     C                   EVAL      BRSQ = *ZEROS
 
     C                   EVAL      RSTM = RSETM                                               220020
     C                   EVAL      RONS = URACC                                               220020
     C                   EVAL      RCRN = CPPBK                                               220020
     C                   EVAL      PSTM = PSETM                                               220020
     C                   EVAL      PONS = UPACC                                               220020
     C                   EVAL      AWBN = CPRBK                                               220020
     C                   EVAL      BENN = FACO                                                220020
     C                   EVAL      BTB1 = SPI                                                 220020
     C                   ENDSR
      ****************************************************************
      /EJECT
      *****************************************************************
      * SrDlBack - Calculate Rate Fix Date for FRA/IRS                *
      *****************************************************************
     C     SrDlBack      BEGSR
 
      ** Input field PZLoc contains the relevant branch location
      ** Initialise Work Field
 
      ** Perform the following processing until the work field is
      ** greater than or equal to the Rate Fix Days
 
     C                   DOU       WZWkFld >= WZRfDy
 
      ** If the Rate Fix Days are not equal to zero subtract 1
      ** from the Rate Fix Date
 
     C                   IF        WZRfDy <> 0
     C                   SUB       1             PZRfDt
     C                   ENDIF
 
      ** The following is repeated until the resultant date is
      ** proved to be a working day in the relevant currency and
      ** location.
      ** Uses ZCHKH to check Rate Fix Date for a holiday
 
     C                   DOU       PZind = 'W'
 
     C                   EVAL      PZDayNo = PZRfDt
 
     C                   CALLB     'ZCHKH'
     C                   PARM                    PZDayNo
     C                   PARM                    PZCcy
     C                   PARM                    PZLoc
     C                   PARM                    PZind
 
      ** If date is a holiday (PZind = 'H'), subtract 1 from rate fix date
 
     C                   IF        PZind = 'H'
     C                   SUB       1             PZRfDt
     C                   ENDIF
 
     C                   ENDDO
 
      **  When a working day has been found, add 1 to the Work Field
 
     C                   ADD       1             WZWkFld
 
     C                   ENDDO
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * SrCnfIns - Set Confirmation Indicator on Insertion           *
      ****************************************************************
     C     SrCnfIns      BEGSR
 
     C                   EVAL      WkCNRQ = 'N'
 
      ** Confirmation required if settlement instructions present or if
      ** 2-level input is not present
 
     C                   IF        RPRSTM <> *ZERO OR RPPSTM <> *ZERO
     C                             OR BLL2II = 'N'
     C                   EVAL      WkCNRQ = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * SrCnfAmd - Set Confirmation Indicator on Amendment           *
      ****************************************************************
     C     SrCnfAmd      BEGSR
 
      ** If Settlement instructions were previously present
      ** or if 2-level input not present
      ** or if Original entry date not equal to run date
 
     C                   IF        RSTM <> *ZERO OR PSTM <> *ZERO OR
     C                             BLL2II = 'N' OR ORED <> BJRDNB
 
      ** If settlement instruction fields have changed
 
     C                   IF        RSTM <> RPRSTM OR RONS <> RPRONS OR
     C                             RIBN <> RPRIBN OR PSTM <> RPPSTM OR
     C                             PONS <> RPPONS OR AWBN <> RPAWBN OR
     C                             BENN <> RPBENN OR BTB1 <> RPBTB1 OR
 
      ** or if Def. Sender-Receiver info has changed
 
     C                             DSR1 <> RPDSR1 OR DSR2 <> RPDSR2 OR
     C                             DSR3 <> RPDSR3 OR DSR4 <> RPDSR4 OR
     C                             DSR5 <> RPDSR5 OR DSR6 <> RPDSR6 OR
 
      ** or if the ISDA fields have changed
 
     C                             ISDA <> RPISDA OR AGTY <> RPAGTY OR
     C                             AGDT <> RPAGDT OR AGVC <> RPAGVC OR
     C                             AGVV <> RPAGVV
 
      ** or if deal contract fields have changed
      ** Produce a confirmation now
 
     C                   BITOFF    '0'           RPCNFI
     C                   EVAL      WkCNRQ = 'Y'
 
      ** Set off maturity and interest indicators if past value date
 
     C                   IF        ORED < BJRDNB AND VDAT < BJRDNB
     C                   BITOFF    '12'          RPCNFI
     C                   ENDIF
 
     C                   ENDIF
 
      ** Generate confirmation message should CIR008 is switched                              239742
      *  on and auto-authorisation is 'N'.                                                    239742
      *                                                                                       239742
     C     CIR008        IFEQ      'Y'                                                        239742
     C     FIAUTH        ANDNE     'Y'                                                        239742
     C     BQFIRA        ANDEQ     'Y'                                                        239742
     C                   BITOFF    '0'           RPCNFI                                       239742
     C                   BITOFF    '0'           CNFI                                         239742
     C                   EVAL      WkCNRQ = 'Y'                                               239742
     C                   ENDIF                                                                239742
      *                                                                                       239742
     C                   ENDIF
      *                                                                                     BUG6877N
      ** If any of the Settlement Instruction fields has changed, reset                     BUG6877N
      ** bits 3 & 4 of TLXI field to allow regeneration of OUR/THEIR                        BUG6877N
      ** Pay/Receive messages.                                                              BUG6877N
      *                                                                                     BUG6877N
     C     RSTM          IFNE      RPRSTM                                                   BUG6877N
     C     RONS          ORNE      RPRONS                                                   BUG6877N
     C     RIBN          ORNE      RPRIBN                                                   BUG6877N
     C     RIBA          ORNE      RPRIBA                                                   BUG6877N
     C     ROBN          ORNE      RPROBN                                                   BUG6877N
     C     ROCN          ORNE      RPROCN                                                   BUG6877N
     C     PSTM          ORNE      RPPSTM                                                   BUG6877N
     C     PONS          ORNE      RPPONS                                                   BUG6877N
     C     PIBN          ORNE      RPPIBN                                                   BUG6877N
     C     PIBA          ORNE      RPPIBA                                                   BUG6877N
     C     POBN          ORNE      RPPOBN                                                   BUG6877N
     C     POCN          ORNE      RPPOCN                                                   BUG6877N
     C     RCRN          ORNE      RPRCRN                                                   BUG6877N
     C     RCRA          ORNE      RPRCRA                                                   BUG6877N
     C     RVNO          ORNE      RPRVNO                                                   BUG6877N
     C     AWBN          ORNE      RPAWBN                                                   BUG6877N
     C     AWBA          ORNE      RPAWBA                                                   BUG6877N
     C     BENN          ORNE      RPBENN                                                   BUG6877N
     C     BENA          ORNE      RPBENA                                                   BUG6877N
     C     DTP1          ORNE      RPDTP1                                                   BUG6877N
     C     DTP2          ORNE      RPDTP2                                                   BUG6877N
     C     DTP3          ORNE      RPDTP3                                                   BUG6877N
     C     DTP4          ORNE      RPDTP4                                                   BUG6877N
     C     DCHG          ORNE      RPDCHG                                                   BUG6877N
     C     BTB1          ORNE      RPBTB1                                                   BUG6877N
     C     BTB2          ORNE      RPBTB2                                                   BUG6877N
     C     BTB3          ORNE      RPBTB3                                                   BUG6877N
     C     BTB4          ORNE      RPBTB4                                                   BUG6877N
     C     BTB5          ORNE      RPBTB5                                                   BUG6877N
     C     BTB6          ORNE      RPBTB6                                                   BUG6877N
     C     CVMR          ORNE      RPCVMR                                                   BUG6877N
     C     RSCY          ORNE      RPRSCY                                                   BUG6877N
     C     PSCY          ORNE      RPPSCY                                                   BUG6877N
     C     IC72          ORNE      RPIC72                                                   BUG6877N
      * Fields that if changed will affect generated messages                               BUG6877N
     C     USTRT         ORNE      RPUSTRT                                                  BUG6877N
     C     TSTRT         ORNE      RPTSTRT                                                  BUG6877N
     C     UNPCD         ORNE      RPUNPCD                                                  BUG6877N
     C     TNPCD         ORNE      RPTNPCD                                                  BUG6877N
     C     UNIPD         ORNE      RPUNIPD                                                  BUG6877N
     C     TNIPD         ORNE      RPTNIPD                                                  BUG6877N
     C     UEINR         ORNE      RPUEINR                                                  BUG6877N
     C     TEINR         ORNE      RPTEINR                                                  BUG6877N
     C                   BITOFF    '34'          RPTLXI                                     BUG6877N
     C                   ENDIF                                                              BUG6877N
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * SrCnfDel - Set Confirmation Indicator on Deletion            *
      ****************************************************************
     C     SrCnfDel      BEGSR
                                                                                              CIR008
     C                   EVAL      WkCNRQ = 'N'                                               CIR008
 
      ** Confirmation required if one produced previously
 
     C                   TESTB     '7'           CNFI                     89
 
     C                   IF        *IN89 = *ON
     C                   BITOFF    '0'           CNFI
     C                   EVAL      WkCNRQ = 'Y'
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * SrWrtDtx - Write a DTRIX Record                              *
      ****************************************************************
     C     SrWrtDtx      BEGSR
 
      ** Set fields on record to be written to DTRIXDD
 
     C                   EVAL      DXRECI = 'D'
     C                   EVAL      DXRCDT = 'D'
     C                   EVAL      DXDLNO = RPDLNO
     C                   EVAL      DXVDAT = *ZERO
     C                   EVAL      DXDASN = *ZERO
     C                   EVAL      DXCHTP = RPCHTP
     C                   EVAL      DXCNRQ = WkCNRQ
     C                   EVAL      DXCNPR = 'N'
     C                   EVAL      DXREPR = ' '
     C                   TIME                    WXTime
     C                   EVAL      DXDADI = 'N'
     C                   EVAL      DXPRI1 = *ZERO
     C                   EVAL      DXPRI2 = *ZERO
     C                   EVAL      DXPRI3 = *ZERO
     C                   EVAL      DXICIN = *ZERO
     C                   IF        RPBRCA = *BLANKS
     C                   EVAL      DXBRCA = PkDBRC
     C                   ELSE
     C                   EVAL      DXBRCA = RPBRCA
     C                   ENDIF
 
     C                   IN        MNATN
     C                   EVAL      DXTNLU = NATN
 
     C                   WRITE     DTRIXDF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * SrUpdDtxHdr - Update the DTRIX Header Record                 *
      ****************************************************************
     C     SrUpdDtxHdr   BEGSR
 
      ** Access the header record
 
     C                   EVAL      DXDLNO = *ZERO
 
     C     DXDLNO        CHAIN     DTRIXHF                            89
 
      ** If deal number is not found, datbase error
 
     C                   IF        *IN89 = *ON
     C                   MOVEL     DXDLNO        DBKEY
     C                   EVAL      DBFILE = 'DTRIXHF '
     C                   EVAL      DBASE = 8
     C                   EXSR      SrErr
     C                   ENDIF
 
      ** Add 1 to number of deal records (on DTRIXDD)
 
     C                   ADD       1             DXNDLR
 
     C                   UPDATE    DTRIXHF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * SrUpdDlTrl - Update Deals File Trailer                       *
      ****************************************************************
     C     SrUpdDlTrl    BEGSR
 
     C                   MOVE      *BLANKS       EAPIC            10                        MD025244
      *                                                                                     MD025244
     C                   CALLB     'ZADLTRLRUD'
 
      ** Return Code
      ** Change Type
      ** Amount
      ** Run Date
 
     C                   PARM      *BLANKS       PRetCodeIn
     C                   PARM                    RPCHTP
     C                   PARM      RPUPAMT       WkAMNP
     C                   PARM                    BJRDNB
     C                   PARM                    EAPIC                                      MD025244
 
      ** If return code is error, database file
 
     C                   IF        PRetCodeIn = '*ERROR '
     C                   EVAL      DBKEY =  '999999'
     C                   EVAL      DBFILE = 'DEALSDF '
     C                   EVAL      DBASE = 9
     C                   EXSR      SrErr
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * SrUpdOLPos - Update On Line Position Files                   *
      ****************************************************************
     C     SrUpdOLPos    BEGSR
 
      * Make sure overrides exist                                                             246966
     C                   Eval      QCMD = OVRDLPCSC                                           246966
     C                   Call      'QCMDEXC'                                                  246966
     C                   Parm                    QCMD            100                          246966
     C                   Parm      100           QCMDLEN          15 5                        246966
     C**********         CALL      'AOOUSWU0'                                                BUG6373
     C**********         CALLB     'AOOUSWU1'                                         BUG6373BUG7952
     C                   CALL      'AOOUSWU1'                                                BUG7952
     C                   PARM      *BLANK        PRtCd
     C                   PARM                    Z#BSTS
     C                   PARM                    Z#ASTS
     C                   PARM                    Z#WSTS
     C                   PARM                    Z#XSTS
     C                   PARM                    Z#YSTS
     C                   PARM                    Z#ZSTS
 
     C                   IF        PRtCd = '*ERROR'
     C**********         EVAL      DBFILE = 'AOOUSWU0'                                       BUG6373
     C                   EVAL      DBFILE = 'AOOUSWU1'                                       BUG6373
     C                   EVAL      DBASE = 10
     C                   EVAL      DBKEY = *BLANK
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Data export for CCRM - Limits
 
     C                   IF        CDE001 = 'Y'
     C                   MOVEL     RPDLNO        PTrRef
     C                   CALLB     'DEWRTTRIG'
     C                   PARM                    PTrRef
     C                   PARM      'SWAP'        PTrCat
     C                   PARM      *BLANKS       T#RSRV           10                    CDE005
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * SrUpdSumm - Summary Updates                                  *
      ****************************************************************
     C     SrUpdSumm     BEGSR
 
      ** Setup Deal Number
 
     C                   EVAL      PDlNum = RPDLNO
 
     C                   CALL      'DL1911'
     C                   PARM                    PTerm
     C                   PARM                    PDlNum
     C**********         PARM                    RPCHTP                                      BUG4788
     C                   PARM                    WkActn                                      BUG4788
     C                   PARM                    RPUCUCY
 
     C                   IF        PTerm = 'E'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * SrBookDet - Access Book Details                              *
      ****************************************************************
     C     SrBookDet     BEGSR
 
      ** Access book record to pick up Hedge indicator
 
     C                   CALLB     'AOBOOKR0'
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      RPBOKC        WkBokC
     C     SDBOOK        PARM      SDBOOK        DSFDY
 
      ** If return code is not blank, database error
 
     C                   IF        PRtCd <> *BLANK
     C                   EVAL      DBKEY = WkDSNB
     C                   EVAL      DBFILE = 'SDBOOKPD'
     C                   EVAL      DBASE = 11
     C                   EXSR      SrErr
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      * SrDlCcyDet - Access Deal Currency Details                    *
      ****************************************************************
     C     SrDlCcyDet    BEGSR
 
      ** Access currency details using deal currency
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      RPUCUCY       WkAJCD
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** If return code is not blank, database error
 
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      DBKEY = WkAJCD
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 12
     C                   EXSR      SrErr
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SrWatch - Perform Midas Watch List processing.                *                       CSD015
      *                                                               *                       CSD015
      * Called by: SR/INSERT, SR/AMEND                                *                       CSD015
      *                                                               *                       CSD015
      * Calls: None                                                   *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SrWatch       BEGSR                                                                CSD015
                                                                                              CSD015
     C                   CLEAR                   SDWLTD                                       CSD015
     C                   CLEAR                   PString                                      CSD015
     C                   EVAL      U = *Zeros                                                 CSD015
     C                   EVAL      Fld1 = *Blanks                                             CSD015
     C                   EVAL      Fld2 = *Blanks                                             CSD015
     C                   EVAL      Fld3 = *Blanks                                             CSD015
     C                   EVAL      Fld4 = *Blanks                                             CSD015
     C                   EVAL      Fld5 = *Blanks                                             CSD015
     C                   IF        PSCY <> *BLANKS                                            CSD015
     C                   EVAL      PInCcy = PSCY                                              CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      PInCcy = UCUCY                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Receipt Nostro                                                                       CSD015
     C                   IF        RONS <> *Blanks                                            CSD015
                                                                                              CSD015
     C                   IF        WkActn = 'I'  OR  WUNCF = 'Y' OR                           CSD015
     C                             WkActn = 'A'  AND  RONS <> CHRONS                          CSD015
     C                   EVAL      Fld1 = RONS                                                CSD015
     C                   EVAL      U = 1                                                      CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Receipt Ordering Customer                                                            CSD015
     C**********         IF        ROCN <> *Zeros                                      CSD015 CSD027
     C                   IF        ROCN <> *Blanks                                            CSD027
                                                                                              CSD015
     C                   IF        WkActn = 'I'  OR  WUNCF = 'Y' OR                           CSD015
     C                             WkActn = 'A'  AND  ROCN <> CHROBN                          CSD015
     C                   MOVEL     ROCN          Fld1                                         CSD015
     C                   EVAL      U = 3                                                      CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Receipt Ordering Bank                                                                CSD015
     C**********         IF        ROBN <> *Zeros                                      CSD015 CSD027
     C                   IF        ROBN <> *Blanks                                            CSD027
                                                                                              CSD015
     C                   IF        WkActn = 'I'  OR  WUNCF = 'Y' OR                           CSD015
     C                             WkActn = 'A'  AND  ROBN <> CHROBN                          CSD015
     C                   MOVEL     ROBN          Fld1                                         CSD015
     C                   EVAL      U = 5                                                      CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Receipt Intermediary Bank                                                            CSD015
     C                   IF        RIBN <> *Blanks                                            CSD015
                                                                                              CSD015
     C                   IF        WkActn = 'I'  OR  WUNCF = 'Y' OR                           CSD015
     C                             WkActn = 'A'  AND  RIBN <> CHRIBN OR                       CSD015
     C                             WkActn = 'A'  AND  RIBA <> CHRIBA                          CSD015
     C                   EVAL      Fld1 = RIBN                                                CSD015
     C                   EVAL      Fld2 = RIBA                                                CSD015
     C                   EVAL      U = 7                                                      CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Pay Nostro                                                                           CSD015
     C                   IF        PONS <> *Blanks                                            CSD015
                                                                                              CSD015
     C                   IF        WkActn = 'I'  OR  WUNCF = 'Y' OR                           CSD015
     C                             WkActn = 'A'  AND  PONS <> CHPONS                          CSD015
     C                   EVAL      Fld1 = PONS                                                CSD015
     C                   EVAL      U = 9                                                      CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Pay Ordering Customer                                                                CSD015
     C**********         IF        POCN <> *Zeros                                      CSD015 CSD027
     C                   IF        POCN <> *Blanks                                            CSD027
                                                                                              CSD015
     C                   IF        WkActn = 'I'  OR  WUNCF = 'Y' OR                           CSD015
     C                             WkActn = 'A'  AND  POCN <> CHPOCN                          CSD015
     C                   MOVEL     POCN          Fld1                                         CSD015
     C                   EVAL      U = 11                                                     CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Pay Ordering Bank                                                                    CSD015
     C**********         IF        POBN <> *Zeros                                      CSD015 CSD027
     C                   IF        POBN <> *Blanks                                            CSD027
                                                                                              CSD015
     C                   IF        WkActn = 'I'  OR  WUNCF = 'Y' OR                           CSD015
     C                             WkActn = 'A'  AND  POBN <> CHPOBN                          CSD015
     C                   MOVEL     POBN          Fld1                                         CSD015
     C                   EVAL      U = 13                                                     CSD015
     C                   MOVEL     POCN          Fld1                                         CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Pay Intermediary Bank                                                                CSD015
     C                   IF        PIBN <> *Blanks                                            CSD015
                                                                                              CSD015
     C                   IF        WkActn = 'I'  OR  WUNCF = 'Y' OR                           CSD015
     C                             WkActn = 'A'  AND  PIBN <> CHPIBN OR                       CSD015
     C                             WkActn = 'A'  AND  PIBA <> CHPIBA                          CSD015
     C                   EVAL      Fld1 = PIBN                                                CSD015
     C                   EVAL      Fld2 = PIBA                                                CSD015
     C                   EVAL      U = 15                                                     CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Receivers Correspondent                                                              CSD015
     C                   IF        RCRN <> *Blanks                                            CSD015
     C                   IF        WkActn = 'I'  OR  WUNCF = 'Y' OR                           CSD015
     C                             WkActn = 'A'  AND  RCRN <> CHRCRN                          CSD015
     C                   EVAL      Fld1 = RCRN                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ELSE                                                                 CSD015
     C                   IF        WkActn = 'I'  OR  WUNCF = 'Y' OR                           CSD015
     C                             WkActn = 'A'  AND  RCRA <> CHRCRA                          CSD015
     C                   EVAL      Fld1 = RCRA                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        Fld1 <> *Blanks                                            CSD015
     C                   EVAL      U = 17                                                     CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Receiver Number                                                                      CSD015
     C                   IF        RVNO <> *Blanks                                            CSD015
                                                                                              CSD015
     C                   IF        WkActn = 'I'  OR  WUNCF = 'Y' OR                           CSD015
     C                             WkActn = 'A'  AND  RVNO <> CHRVNO                          CSD015
     C                   EVAL      Fld1 = RVNO                                                CSD015
     C                   EVAL      U = 19                                                     CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Account with Bank                                                                    CSD015
     C                   IF        AWBN <> *Blanks                                            CSD015
     C                   IF        WkActn = 'I'  OR  WUNCF = 'Y' OR                           CSD015
     C                             WkActn = 'A'  AND  AWBN <> CHAWBN                          CSD015
     C                   EVAL      Fld1 = AWBN                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ELSE                                                                 CSD015
     C                   IF        WkActn = 'I'  OR  WUNCF = 'Y' OR                           CSD015
     C                             WkActn = 'A'  AND  AWBA <> CHAWBA                          CSD015
     C                   EVAL      Fld1 = AWBA                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        Fld1 <> *Blanks                                            CSD015
     C                   EVAL      U = 21                                                     CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Beneficiary                                                                          CSD015
     C                   IF        BENN <> *Blanks                                            CSD015
                                                                                              CSD015
     C                   IF        WkActn = 'I'  OR  WUNCF = 'Y' OR                           CSD015
     C                             WkActn = 'A'  AND  BENN <> CHBENN OR                       CSD015
     C                             WkActn = 'A'  AND  BENA <> CHBENA                          CSD015
     C                   EVAL      Fld1 = BENN                                                CSD015
     C                   EVAL      Fld2 = BENA                                                CSD015
     C                   EVAL      U = 23                                                     CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Details of Payment                                                                   CSD015
     C                   IF        DTP1 <> *Blanks  OR  DTP2 <> *Blanks  OR                   CSD015
     C                             DTP3 <> *Blanks  OR  DTP4 <> *Blanks                       CSD015
                                                                                              CSD015
     C                   IF        WkActn = 'I'  OR  WUNCF = 'Y' OR                           CSD015
     C                             WkActn = 'A'  AND  DTP1 <> CHDTP1  OR                      CSD015
     C                             WkActn = 'A'  AND  DTP2 <> CHDTP2  OR                      CSD015
     C                             WkActn = 'A'  AND  DTP3 <> CHDTP3  OR                      CSD015
     C                             WkActn = 'A'  AND  DTP4 <> CHDTP4                          CSD015
     C                   EVAL      Fld1 = DTP1                                                CSD015
     C                   EVAL      Fld2 = DTP2                                                CSD015
     C                   EVAL      Fld3 = DTP3                                                CSD015
     C                   EVAL      Fld4 = DTP4                                                CSD015
     C                   EVAL      U = 25                                                     CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      *                                                                                       CSD015
      ** If second parameter is not blank, setup first parameter and                          CSD015
      ** send transaction details to Compliance Watch by calling SDCWLCHK                     CSD015
      *                                                                                       CSD015
     C                   IF        PString <> *Blanks                                         CSD015
                                                                                              CSD015
     C                   EXSR      SRSet1stParm                                               CSD015
                                                                                              CSD015
     C                   CALL      'SDCWLCHK'                                                 CSD015
     C                   PARM                    SDWLTD                                       CSD015
     C                   PARM                    PString                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRSet1stParm - Setup first parameter of SDCWLCHK.             *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRSet1stParm  BEGSR                                                                CSD015
                                                                                              CSD015
      ** Item Type Code                                                                       CSD015
     C                   EVAL      W4ITEM = 'IR' + DTYP                                       CSD015
                                                                                              CSD015
      ** Identifier                                                                           CSD015
     C                   MOVEL     DLNO          W4IDEN                                       CSD015
                                                                                              CSD015
      ** Branch                                                                               CSD015
     C                   EVAL      W4BRCH = BRCA                                              CSD015
                                                                                              CSD015
      ** System                                                                               CSD015
      ** If Midas 24x7 is installed, use Main system prefix otherwise use system prefix       CSD015
     C                   IF        CSC011 = 'Y'                                               CSD015
     C                   EVAL      W4SYSM = S1MAIN                                            CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4SYSM = LIBR                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Function Type                                                                        CSD015
     C                   EVAL      W4FUNT = 'DEALSDG'                                         CSD015
                                                                                              CSD015
      ** Counterparty Details                                                                 CSD015
     C                   EXSR      SRGetCtrpDet                                               CSD015
     C                   MOVEL     CNUM          W4CNUM                                       CSD015
     C                   EVAL      W4CTYP = WCtrpTyp                                          CSD015
     C                   EVAL      W4CUST = WCtrpRpt                                          CSD015
                                                                                              CSD015
      ** Deal Date                                                                            CSD015
     C                   MOVE      DDAT          PZADayNo                                     CSD015
     C                   EXSR      SRDateToDDT                                                CSD015
     C                   EVAL      W4DDAT = WDDT                                              CSD015
                                                                                              CSD015
      ** Value Date                                                                           CSD015
     C                   MOVE      VDAT          PZADayNo                                     CSD015
     C                   EXSR      SRDateToDDT                                                CSD015
     C                   EVAL      W4VDAT = WDDT                                              CSD015
                                                                                              CSD015
      ** Maturity Date                                                                        CSD015
     C                   MOVE      MDAT          PZADayNo                                     CSD015
     C                   EXSR      SRDateToDDT                                                CSD015
     C                   EVAL      W4MDAT = WDDT                                              CSD015
                                                                                              CSD015
      ** Denomination Side 1                                                                  CSD015
     C                   EVAL      W4DEN1  = UCUCY                                            CSD015
                                                                                              CSD015
      ** Denomination Side 2                                                                  CSD015
     C                   EVAL      W4DEN2  = *Blanks                                          CSD015
                                                                                              CSD015
      ** Amount Side 1                                                                        CSD015
     C                   EVAL      PZACcy = UCUCY                                             CSD015
     C                   MOVE      UPAMT         PZAAmt                                       CSD015
     C                   EXSR      SRAmtToFPDT                                                CSD015
     C                   EVAL      W4AMT1 = WFPDT                                             CSD015
                                                                                              CSD015
      ** Amount Side 2                                                                        CSD015
     C                   EVAL      W4AMT2 = *Zeros                                            CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRDateToDDT - Converts a date into Date Data Type format.     *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRDateToDDT   BEGSR                                                                CSD015
                                                                                              CSD015
      ** Convert the derived Midas Day Number into Date Data Type.                            CSD015
                                                                                              CSD015
     C                   CALL      'ZACVTDATE'                                                CSD015
     C                   PARM      *BLANKS       PZARtCd                                      CSD015
     C                   PARM                    PZADayNo                                     CSD015
     C                   PARM                    PZADDT                                       CSD015
     C                   PARM                    PConvtDate                                   CSD015
                                                                                              CSD015
     C                   EVAL      WDDT = PZADDT                                              CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRAmtToFPDT - Converts an amount into Floating Point Data     *                       CSD015
      *               Type format.                                    *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRAmtToFPDT   BEGSR                                                                CSD015
      *                                                                                       CSD015
      ** Directly convert the given amount into Floating Point format.                        CSD015
      *                                                                                       CSD015
     C                   CALL      'ZACVTAMT'                                                 CSD015
     C                   PARM      *BLANKS       PZARtCd                                      CSD015
     C                   PARM                    PZACcy                                       CSD015
     C                   PARM                    PZAAmt                                       CSD015
     C                   PARM                    PZOutAmt                                     CSD015
     C                   PARM                    PZCvtAmt                                     CSD015
      *                                                                                       CSD015
     C                   EVAL      WFPDT = PZOutAmt                                           CSD015
      *                                                                                       CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRGetCtrpDet - Gets the Counterparty Details given a Customer *                       CSD015
      *                Number.                                        *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRGetCtrpDet  BEGSR                                                                CSD015
      *                                                                                       CSD015
      ** Initialise the relevant variables.                                                   CSD015
      *                                                                                       CSD015
     C                   EVAL      WCtrpRpt = *BLANKS                                         CSD015
     C                   EVAL      WCtrpTyp = *BLANKS                                         CSD015
     C                   MOVEL     CNUM          PCustNo                                      CSD015
      *                                                                                       CSD015
      ** Get the Customer Detail.                                                             CSD015
      *                                                                                       CSD015
     C                   CALL      'AOCUSTR0'                                                 CSD015
     C                   PARM      *BLANKS       PRtCd                                        CSD015
     C                   PARM      '*KEY   '     POptn                                        CSD015
     C                   PARM                    PCustNo                                      CSD015
     C                   PARM      *BLANKS       PErrInf                                      CSD015
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSD015
      *                                                                                       CSD015
     C                   IF        PRtCd = *BLANKS                                            CSD015
      *                                                                                       CSD015
      ** Assemble the Counterparty Report information.                                        CSD015
      *                                                                                       CSD015
     C     BBCRNM        CAT       BBCRTN        WCtrpRpt                                     CSD015
      *                                                                                       CSD015
      ** Determine the Counterparty Type.                                                     CSD015
      *                                                                                       CSD015
     C                   IF        CCF001 = 'Y'                                               CSD015
      *                                                                                       CSD015
     C                   IF        BBCRPC = 'Y'                                               CSD015
     C                   EVAL      WCtrpTyp = 'C'                                             CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      WCtrpTyp = 'I'                                             CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ELSE                                                                 CSD015
      *                                                                                       CSD015
     C                   IF        BBLICD <> *BLANKS AND                                      CSD015
     C                             BBLICD <> W1IND1  AND                                      CSD015
     C                             BBLICD <> W1IND2  AND                                      CSD015
     C                             BBLICD <> W1IND3  AND                                      CSD015
     C                             BBLICD <> W1IND4  AND                                      CSD015
     C                             BBLICD <> W1IND5                                           CSD015
     C                   EVAL      WCtrpTyp = 'C'                                             CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      WCtrpTyp = 'I'                                             CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ELSE                                                                 CSD015
      *                                                                                       CSD015
      ** Handle Database Errors if any occur.                                                 CSD015
      *                                                                                       CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = POptn                                              CSD015
     C                   EVAL      DBFile = 'SDCUSTPD'                                        CSD015
     C                   EVAL      DBase = 21                                                 CSD015
     C                   OUT       LDA                                                      MD029681
     C                   EXSR      SrErr                                                      CSD015
      *                                                                                       CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRConvert - Subroutine to convert accounts, customer no. to   *                       CSD015
      *             customer name and address.                        *                       CSD015
      * Called by: SRWatch                                            *                       CSD015
      *                                                               *                       CSD015
      * Calls: SDCWHLCHK                                              *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRConvert     BEGSR                                                                CSD015
                                                                                              CSD015
     C                   EVAL      OutFmt = *Blanks                                           CSD015
     C                   EVAL      PInput = *Blanks                                           CSD015
     C                   EVAL      PInput1 = *Blanks                                          CSD015
     C                   EVAL      PInput2 = *Blanks                                          CSD015
     C                   EVAL      PInput3 = *Blanks                                          CSD015
     C                   EVAL      PInput4 = *Blanks                                          CSD015
                                                                                              CSD015
     C                   CALL      'SDCWLFMT'                                                 CSD015
     C                   PARM      *Blanks       PRtcd                                        CSD015
     C                   PARM      Fld1          PInput                                       CSD015
     C                   PARM      Fld2          PInput1                                      CSD015
     C                   PARM      Fld3          PInput2                                      CSD015
     C                   PARM      Fld4          PInput3                                      CSD015
     C                   PARM      Fld5          PInput4                                      CSD015
     C                   PARM                    PInput5                                      CSD015
     C                   PARM                    PInCcy                                       CSD015
     C                   PARM                    OutFmt                                       CSD015
     C                   PARM                    OutFmt2                                      CSD015
                                                                                              CSD015
     C                   EVAL      Fld1 = *Blanks                                             CSD015
     C                   EVAL      Fld2 = *Blanks                                             CSD015
     C                   EVAL      Fld3 = *Blanks                                             CSD015
     C                   EVAL      Fld4 = *Blanks                                             CSD015
     C                   EVAL      Fld5 = *Blanks                                             CSD015
                                                                                              CSD015
     C     PString       CAT       WLARR(U):0    PString                                      CSD015
     C     PString       CAT       OUTFMT:0      PString                                      CSD015
     C                   EVAL      U = U+1                                                    CSD015
     C     PString       CAT(P)    WLARR(U):0    PString                                      CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      /COPY ZACPYSRC,PSSR_ILE
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Program parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PRetCodeIn
     C                   PARM                    PModeOfOp                                    CAP056
     C                   PARM                    IRVCACF
     C                   PARM                    PScreenInpt                                  CAP043
 
      ** Default Branch for ZMUSER
      ** Bank Details (SDBANKPD)
      ** General Ledger ICD (SDGELRPD)
      ** Trading ICD (SDTRADPD)
      ** Retail ICD (SDRETLPD)
      ** FRA/IRS ICD (SDFAISPD)
 
     C                   PARM                    PkDBRC
     C                   PARM                    SDBANK
     C                   PARM                    SDGELR
     C                   PARM                    SDTRAD
     C                   PARM                    SDRETL
     C                   PARM                    SDFAIS
 
      ** Business Day Convention
      ** Amortisation of Caps/Collars/Floors
      ** 24x7 Midas Availability
      ** CCRM Limits
      ** FRA/IRS Deals Authorisation                                                          CIR008
      ** Automatic Authorisation of Interface Deals                                           CAP056
 
     C                   PARM                    CIR005
     C                   PARM                    CIR006
     C                   PARM                    CSC011
     C                   PARM                    CDE001
     C                   PARM                    CIR008                                       CIR008
     C                   PARM                    CAP056                                       CAP056
 
     C     *LIKE         DEFINE    UEINR         WkUEINR
     C     *LIKE         DEFINE    TEINR         WkTEINR
     C     *LIKE         DEFINE    UNICD         WkUNICD
     C     *LIKE         DEFINE    TNICD         WkTNICD
     C     *LIKE         DEFINE    UFRFD         WkUFRFD
     C     *LIKE         DEFINE    TFRFD         WkTFRFD
     C     *LIKE         DEFINE    BQFIRA        WkFIRA                                       CAP056
     C     *LIKE         DEFINE    BQFIAU        WkFIAU                                       CAP056
                                                                                              CAP056
      ** Store the original value of the flags to a work variable                             CAP056
                                                                                              CAP056
     C                   EVAL      WkFIRA = BQFIRA                                            CAP056
     C                   EVAL      WkFIAU = BQFIAU                                            CAP056
                                                                                              CAP043
      ** Partial Key for DLDTSCPD                                                             CAP043
                                                                                              CAP043
     C     KDTSC         KLIST                                                                CAP043
     C                   KFLD                    DLNO                                         CAP043
                                                                                              CAP043
     C     KIRCList      KLIST                                                                CAP043
     C                   KFLD                    RPFRNT                                       CAP043
                                                                                              CAP043
     C     KIRSDL        KLIST                                                                CAP043
     C                   KFLD                    RPDLNO                                       CAP043
     C                   KFLD                    PVYOURTHR                                    CAP043
     C                   KFLD                    PCPRDT                                       CAP043
                                                                                              CAP043
     C     KIRSDP        KLIST                                                                CAP043
     C                   KFLD                    RPDLNO                                       CAP043
     C                   KFLD                    PVYOURTHR                                    CAP043
                                                                                              CRE020
      ** Midas RE Settled Transaction Index File Key List                                     CRE020
                                                                                              CRE020
     C     KADVC         KLIST                                                                CRE020
     C                   KFLD                    KRefNo                                       CRE020
     C                   KFLD                    KPrgMn                                       CRE020
                                                                                              CAP043
      ** Access module details to see if Midas-Plato is installed                             CAP043
                                                                                              CAP043
     C                   CALLB     'AOMMODR0'                                                 CAP043
     C                   PARM      '*DBERR '     PRTCD                                        CAP043
     C                   PARM      '*FIRST '     POPTN                                        CAP043
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CAP043
 
      ** Check if 24x7 Midas Availability is installed
 
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSC011'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRTCD = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C**********         IN        SDSTAT                                                     CSD015
     C                   ELSE
     C                   IF        PRTCD <> '*NRF'
     C                   EVAL      DBKEY = 'CSC011'
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBASE = 16
     C                   EXSR      SrErr
     C                   ENDIF
     C                   ENDIF
                                                                                              CAP043
      ** Determine if CAP043 enhancement is installed                                         CAP043
                                                                                              CAP043
     C                   CALL      'AOSARDR0'                                                 CAP043
     C                   PARM      *BLANKS       PRTCD                                        CAP043
     C                   PARM      '*VERIFY'     POPTN                                        CAP043
     C                   PARM      'CAP043'      PSARD                                        CAP043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP043
                                                                                              CAP043
      ** Database Error                                                                       CAP043
                                                                                              CAP043
     C                   IF        PRtCd = *Blanks                                            CAP043
     C                   EVAL      CAP043 = 'Y'                                               CAP043
     C                   ELSE                                                                 CAP043
     C                   EVAL      CAP043 = 'N'                                               CAP043
                                                                                              CAP043
     C                   IF        PRtCd <> '*NRF'                                            CAP043
     C     *LOCK         IN        LDA                                                        CAP043
     C                   EVAL      DBKEY = 'CAP043'                                           CAP043
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP043
     C                   EVAL      DBASE = 910                                                CAP043
     C                   OUT       LDA                                                        CAP043
     C                   EXSR      *PSSR                                                      CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Check if CAP041 is installed                                                         CAP043
                                                                                              CAP043
     C                   CALL      'AOSARDR0'                                                 CAP043
     C                   PARM      *BLANKS       PRtCd                                        CAP043
     C                   PARM      '*VERIFY'     POptn                                        CAP043
     C                   PARM      'CAP041'      PSard                                        CAP043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP043
                                                                                              CAP043
     C                   IF        PRtCd = *Blanks                                            CAP043
     C                   EVAL      CAP041 = 'Y'                                               CAP043
     C                   ELSE                                                                 CAP043
     C                   EVAL      CAP041 = 'N'                                               CAP043
                                                                                              CAP043
     C                   IF        PRtCd <> '*NRF'                                            CAP043
     C     *LOCK         IN        LDA                                                        CAP043
     C                   EVAL      DBKEY = 'CAP041'                                           CAP043
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP043
     C                   EVAL      DBASE = 911                                                CAP043
     C                   OUT       LDA                                                        CAP043
     C                   EXSR      *PSSR                                                      CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
                                                                                              CSD015
     C                   IN        SDSTAT                                                     CSD015
 
      ** Check if Compliance Watch Enhancement (CSD015) is on.                                CSD015
                                                                                              CSD015
     C                   EVAL      CSD015 = 'N'                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *Blank        PRtCd                                        CSD015
     C                   PARM      '*VERIFY'     POptn                                        CSD015
     C                   PARM      'CSD015'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
                                                                                              CSD015
     C                   IF        PRtCd = *BLANKS                                            CSD015
     C                   EVAL      CSD015 = 'Y'                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   IF        (PRtCd <> *Blank) AND                                      CSD015
     C                             (PRtCd <> '*NRF   ')                                       CSD015
     C                   EVAL      DBKey = 'CSD015'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 17                                                 CSD015
     C                   EXSR      SrErr                                                      CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check if function code is being monitored by the compliance watch                    CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
     C                   CALLB     'AOWLCCR0'                                                 CSD015
     C                   PARM      *Blank        PRtCd                                        CSD015
     C                   PARM      '*KEY   '     POptn                                        CSD015
     C                   PARM      'DEALING '    PFunc                                        CSD015
     C     SDWLCC        PARM      SDWLCC        DSSDY                                        CSD015
                                                                                              CSD015
      ** If return code not blank, then issue database errror                                 CSD015
                                                                                              CSD015
     C                   IF        (PRtCd <> *Blank)  AND                                     CSD015
     C                             (PRtCd <> '*NRF')                                          CSD015
     C                   EVAL      DBKey = 'DEALING '                                         CSD015
     C                   EVAL      DBFile = 'SDWLCCPD'                                        CSD015
     C                   EVAL      DBase = 18                                                 CSD015
     C                   EXSR      SrErr                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   CALL      'AOCWCDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRtCd                                        CSD015
     C                   PARM      '*FIRST'      POptn                                        CSD015
     C     SDCWCD        PARM      SDCWCD        DSSDY                                        CSD015
                                                                                              CSD015
     C                   IF        PRtCd <> *Blanks                                           CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = POptn                                              CSD015
     C                   EVAL      DBFile = 'SDCWCDPD'                                        CSD015
     C                   EVAL      DBase = 19                                                 CSD015
     C                   OUT       LDA                                                      MD029681
     C                   EXSR      SrErr                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      **  Access SAR details to see if CCF001 is switched on.                                 CSD015
                                                                                              CSD015
     C                   EVAL      CCF001 = 'N'                                               CSD015
     C                   CALL      'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRtCd                                        CSD015
     C                   PARM      '*VERIFY'     POptn                                        CSD015
     C                   PARM      'CCF001'      PSARD                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        PRtCd <> *Blanks  and                                      CSD015
     C                             PRtCd <> '*NRF'                                            CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = 'CCF001'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 20                                                 CSD015
     C                   OUT       LDA                                                      MD029681
     C                   EXSR      Srerr                                                      CSD015
                                                                                              CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      CCF001 = 'Y'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Compliance Watch Hit List Key List                                                   CSD015
                                                                                              CSD015
     C     CWHTKY        KLIST                                                                CSD015
     C                   KFLD                    WFUNT                                        CSD015
     C                   KFLD                    WIDEN                                        CSD015
     C                   KFLD                    BRCA                                         CSD015
                                                                                              CSD015
      ** Check if MidasPlus On line Printing of Advices is installed                          CRE020
                                                                                              CRE020
     C                   EVAL      CRE020 = 'N'                                               CRE020
                                                                                              CRE020
     C                   CALLB     'AOSARDR0'                                                 CRE020
     C                   PARM      *BLANKS       PRtCd                                        CRE020
     C                   PARM      '*VERIFY'     POptn                                        CRE020
     C                   PARM      'CRE020'      PSard                                        CRE020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE020
                                                                                              CRE020
     C                   IF        PRtCd = *BLANKS                                            CRE020
     C                   EVAL      CRE020 = 'Y'                                               CRE020
     C                   ELSE                                                                 CRE020
     C                   IF        (PRtCd <> '*NRF   ')                                       CRE020
     C                   EVAL      DBKey = 'CRE020'                                           CRE020
     C                   EVAL      DBFile = 'SCSARDPD'                                        CRE020
     C                   EVAL      DBase = 22                                                 CRE020
     C                   EXSR      SrErr                                                      CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
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
     C     *LOCK         IN        LDA                                                        CRE020
     C                   EVAL      DBFile = 'SDSVALPD'                                        CRE020
     C                   EVAL      DBase = 23                                                 CRE020
     C                   EVAL      DBKey = PSysVal01                                          CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      SRErr                                                      CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CDL028
      ** Check if CDL028 is installed                                                         CDL028
                                                                                              CDL028
     C                   CALL      'AOSARDR0'                                                 CDL028
     C                   PARM      *BLANKS       PRtCd                                        CDL028
     C                   PARM      '*VERIFY'     POptn                                        CDL028
     C                   PARM      'CDL028'      PSard                                        CDL028
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL028
                                                                                              CDL028
     C                   IF        PRtCd = *Blanks                                            CDL028
     C                   EVAL      CDL028 = 'Y'                                               CDL028
     C                   ELSE                                                                 CDL028
     C                   EVAL      CDL028 = 'N'                                               CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      *                                                                                      BUG6671
      ** Access SAR details file to determine if                                             BUG6671
      ** Automatic Authorisation is installed                                                BUG6671
      *                                                                                      BUG6671
     C                   CALL      'AOSARDR0'                                                BUG6671
     C                   PARM      *BLANKS       PRTCD                                       BUG6671
     C                   PARM      '*VERIFY'     POPTN                                       BUG6671
     C                   PARM      'CAP051'      PSARD                                       BUG6671
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG6671
                                                                                             BUG6671
     C                   If        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                   BUG6671
     C     *LOCK         IN        LDA                                                       BUG6671
     C                   Eval      DBKEY = 'CAP051'                                          BUG6671
     C                   Eval      DBFILE = 'SCSARDPD'                                       BUG6671
     C                   Eval      DBASE = 024                                               BUG6671
     C                   OUT       LDA                                                       BUG6671
     C                   EXSR      *PSSR                                                     BUG6671
     C                   ENDIF                                                               BUG6671
      *                                                                                      BUG6671
     C                   If        PRTCD = *Blanks                                           BUG6671
     C                   Eval      CAP051 = 'Y'                                              BUG6671
     C                   Else                                                                BUG6671
     C                   Eval      CAP051 = 'N'                                              BUG6671
     C                   EndIf                                                               BUG6671
                                                                                              CSD083
      ** Check if Watch List Element (CSD083) is on                                           CSD083
      *                                                                                       CSD083
     C                   CALL      'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRTCD                                        CSD083
     C                   PARM      '*VERIFY'     POPTN                                        CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   If        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBKEY = 'CSD083'                                           CSD083
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBASE = 025                                                CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
      *                                                                                       CSD083
     C                   IF        PRTCD = *BLANKS                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   ENDSR
      ****************************************************************
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
     C                   MOVEL     DLNO          KRefNo                                       CRE020
                                                                                              CRE020
     C                   OPEN      READVCL1                                                   CRE020
                                                                                              CRE020
     C     KADVC         SETLL     READVCL1                                                   CRE020
     C     KADVC         READE     READVCL1                                                   CRE020
                                                                                              CRE020
     C                   DOW       NOT %EOF(READVCL1)                                         CRE020
                                                                                              CRE020
      ** If the record was just inserted                                                      CRE020
                                                                                              CRE020
     C                   IF        RCHTYP = 'I' AND                                           CRE020
     C                             (RSAPIN = 'N' OR RSAPIN = ' ')                             CRE020
                                                                                              CRE020
     C                   SELECT                                                               CRE020
                                                                                              CRE020
     C                   WHEN      WKACTN = 'I'                                               CRE020
     C                   IF        BQFIAU = 'N'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   ENDIF                                                                CRE020
     C                   UPDATE    READVCD0                                                   CRE020
                                                                                              CRE020
     C                   WHEN      WKACTN = 'A'                                               CRE020
     C                   IF        BQFIRA = 'N'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   ELSE                                                                 CRE020
     C                   EVAL      RAUTHI = 'N'                                               CRE020
     C                   ENDIF                                                                CRE020
     C                   UPDATE    READVCD0                                                   CRE020
                                                                                              CRE020
     C                   WHEN      WKACTN = 'R'                                               CRE020
     C                   EVAL      RCHTYP = 'D'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'Y'                                               CRE020
     C                   UPDATE    READVCD0                                                   CRE020
                                                                                              CRE020
     C                   WHEN      WKACTN = 'X'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   UPDATE    READVCD0                                                   CRE020
                                                                                              CRE020
     C                   ENDSL                                                                CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
      ** If the record was already generated before                                           CRE020
                                                                                              CRE020
     C                   IF        WKACTN <> 'X'                                              CRE020
     C                   EVAL      RCHTYP = WKACTN                                            CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   SELECT                                                               CRE020
                                                                                              CRE020
     C                   WHEN      WKACTN = 'A'                                               CRE020
     C                   IF        BQFIRA = 'N'                                               CRE020
                                                                                              CRE020
     C                   IF        RAUTHI = 'N'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        RSAPIN = 'N'                                               CRE020
     C                   EVAL      RAUTHI = 'N'                                               CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   WHEN      WKACTN = 'R' OR WKACTN = 'X'                               CRE020
     C                   IF        RAUTHI = 'N'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDSL                                                                CRE020
                                                                                              CRE020
     C                   UPDATE    READVCD0                                                   CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C     KADVC         READE     READVCL1                                                   CRE020
                                                                                              CRE020
     C                   ENDDO                                                                CRE020
                                                                                              CRE020
     C                   CLOSE     READVCL1                                                   CRE020
                                                                                              CRE020
     C                   ENDSR                                                                CRE020
      *****************************************************************                       CRE020
      /EJECT
      *****************************************************************
      * SrErr - Exception Errors                                      *
      *****************************************************************
     C     SrErr         BEGSR
 
     C                   EVAL      PRetCodeIn = '*ERROR    '
     C                   EVAL      DBPGM = 'IRCACFUPD'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
 
      ** Terminate the program
 
     C                   RETURN
 
     C                   ENDSR
      ****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
** WLArr - Watch List Description Array                                                       CSD015
<Receipt Nostro>                   </Receipt Nostro>                                          CSD015
<Receipt Ordering Customer>        </Receipt Ordering Customer>                               CSD015
<Receipt Ordering Bank>            </Receipt Ordering Bank>                                   CSD015
<Receipt Intermediary Bank>        </Receipt Intermediary Bank>                               CSD015
<Pay Nostro>                       </Pay Nostro>                                              CSD015
<Pay Ordering Customer>            </Pay Ordering Customer>                                   CSD015
<Pay Ordering Bank>                </Pay Ordering Bank>                                       CSD015
<Pay Intermediary Bank>            </Pay Intermediary Bank>                                   CSD015
<Receivers Correspondent>          </Receivers Correspondent>                                 CSD015
<Receiver Number>                  </Receiver Number>                                         CSD015
<Account with Bank>                </Account with Bank>                                       CSD015
<Beneficiary>                      </Beneficiary>                                             CSD015
<Details of Payment>               </Details of Payment>                                      CSD015
