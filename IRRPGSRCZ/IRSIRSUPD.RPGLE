     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Single ccy IRS database update')              *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRSIRSUPD - Single Currency IRS Database Update              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD054117           Date 12Sep19               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 MD036601           Date 29Aug16               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 01Sep14               *
      *                 MD025244           Date 09May14               *
      *                 CIR017             Date 10Apr14               *
      *                 253954             Date 19Nov12               *
      *                 CSF011A            Date 08Nov11               *
      *                 CRE073             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 CER048             Date 19May08               *
      *                 CER043             Date 19May08               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248452             Date 13Jun07               *
      *                 246966             Date 22Sep06               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239742             Date 22Sep06               *
      *                 BUG7911            Date 01Nov05               *
      *                 CDL049             Date 07Jul06               *
      *                 CIR014             Date 11May06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG11266           Date 24Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 235490             Date 01Sep05               *
      *                 227642             Date 23Aug04               *
      *                 BUG6877N           Date 10Jul05               *
      *                 BUG7217            Date 07Jun05               *
      *                 BUG7535            Date 14Jun05               *
      *                 BUG6877R           Date 16Jun05               *
      *                 BUG7166            Date 12May05               *
      *                 CDL038             Date 10May05               *
      *                 CSW037A            Date 02May05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG6671            Date 26Apr05               *
      *                 CLE031             Date 26Apr05               *
      *                 BUG6877            Date 29Apr05               *
      *                 228071             Date 30Jun04               *
      *                 BUG6373            Date 24Mar05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4646            Date 25Oct04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL014             Date 20Oct03               *
      *                 CDL018             Date 03Feb04               *
      *                 TDA101             Date 02Apr04               *
      *                 TDA081             Date 01Apr04               *
      *                 CRE020             Date 20Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CAP084             Date 02Jul03               *
      *                 CDE005             Date 19Aug03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CIR011             Date 15Apr01               *
      *                 213055             Date 20Nov02               *
      *                 CSD015             Date 14Oct02               *
      *                 CAS004             Date 26Jun02               *
      *                 CAP043             Date 02May02               *
      *                 217684             Date 12May03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 167793             Date 20Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      *                 CAS001             Date 23Nov01               *
      *                 CAP041             Date 07Jan01               *
      *                 199835             Date 07Nov01               *
      *                 CSC011             Date 18Sep01               *
      *                 194487             Date 16Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 200400             Date 20Nov01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 184363             Date 23Jan01               *
      *                 CIR003             Date 13Sep00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 179510             Date 07Nov00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005             Date 21Jan00               *
      *                 CDE001             Date 12Apr00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSW097             Date 10Feb00               *
      *                 CAP013             Date 07Sep99               *
      *                 168345             Date 13OCt99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 168981             Date 20May99               *
      * Midas DBA 3.00 -----------------Base--------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP006             Date 16Mar99               *
      *                 151240             Date 21Dec98               *
      *                 CAP004             Date 11Aug98               *
      *                 CAP003  *CREATE    Date 01Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD054117 - Principal change Increase/Decrease capability     *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  MD036601 - DLC0606B failed in RU production dd 10.11.2015    *
      *             Reset URFIN / TRFIN whenever fix date is less than*
      *             rate change date.                                 *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD025244 - Added parameter in calling ZADLTRLRUD.            *
      *  CIR017 - SIRS Business Day Conventions for both Legs         *
      *  253954 - Blank-out Auto-authorisation field if transaction   *
      *           is inserted from third party API.                   *
      *         - Applied for AR981707 (Child: AR981710)              *
      *  CSF011A- CCR015: Display Order in Confirmation Pages         *
      *           (Recompile)                                         *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248452 - Set up field F1BRCA in DLDLDGQD.                    *
      *  246966 - Override missing for DLPCSCPD.                      *
      *  239742   - No confirmation message for IRS deal amendment.   *
      *  BUG7911 - Prevent the generation of new MT360 when BOVD is   *
      *            no longer blanks, unless BOVD itself was amended.  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CIR014 - Mark to Market Cross-currency Interest Rate Swaps   *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG11266 - Apply 212988. Rate Fix Date should only be        *
      *             be recalculated during amendment if the Rate      *
      *             Change Date, Rate Fix Days and Effective          *
      *             Interest Rate is amended.                         *
      *             Applied 227642 in part.                           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  235490 - Recalculate the Rate Fix Date when amending         *
      *           Currencies for Rate Fixing Convention.              *
      *  227642 - When only short term rate amended, do not produce   *
      *           MT360/MT361.  When short term rate amended, and     *
      *           base rate has been fixed, change rate fix indicator *
      *           to 'B'.  Update Rate Fix Date only when Rate Change *
      *           Date or Rate Fix Days amended.                      *
      *  BUG6877N-Regenerate pay/receives where necessary.            *
      *  BUG7217 - Populate field SDCAR for average rate method on    *
      *            insert of deal.                                    *
      *  BUG7535- Initialise CDL028 fields                            *
      *  BUG6877R - Incorporated fix is incomplete.                   *
      *  BUG7166- Valid file does not match DEALSDG (Recompile)       *
      *  CDL038 - Extended Deal Sub Type                              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CDL028 - Automatic Rate Interpolations                       *
      *  BUG6671 - Implement Auto Authorisation                       *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  BUG6877 - Ensure confirmation is generated for amendment.    *
      *            Fix is patterned after 227212 and 218833.          *
      *  228071 - When short term rate is amended, update FSUEFR and  *
      *           FSTEFR as well.                                     *
      *  BUG6373 - Call AOOUSWU1 instead of AOOUSWU0                  *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4646- Completion of SIRS api                              *
      *  CLE025 - Credit Lines                                        *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TDA101 - After and Before image data structure (Z#AST        *
      *           and Z#BST) used in program is short FRA/IRS         *
      *           transaction.  (Recompile)                           *
      *  TDA081 - Fix will ensure that correct Rate fix day will be   *
      *           stored on file.                                     *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP084 - Synchronous calling of APIs                         *
      *  CDE005 - Data Export - Reservation ID                        *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  CIR011 - FRA/IRS Rate Fix Days Adjustment                    *
      *  213055 - Set CNRQ field properly                             *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  CAP043 - Additional APIs for IRS Schedules                   *
      *  217684 - Authorisation User Malfunction                      *
      *  167793 - Amended program to retain negative value of         *
      *           effective interest rate even after deal amendment.  *
      *  CAP056 - Automatic Authorisation of Interface Deals          *
      *  CIR008 - FRA/IRS Deals Authorisation                         *
      *  CAS001 - Net Present Value (NPV) Accounting.                 *
      *  CAP041 - APIs for IRS Fees/Buy-Outs/Processing Method/Next   *
      *           Principal Change Date.                              *
      *           Recompiled due to changes in IRVSIRSPD.             *
      *  199835 - Interest rate calendar validation fails             *
      *  CSC011 - 24x7 Midas Availability                             *
      *  194487 - Check other amended fields relevant for generation  *
      *           of an amended confirmation.  And default workfield  *
      *           @@CNRQ to 'N' to prevent a blank CNRQ in DTRIXDD.   *
      *  200400 - Reverse fix 179510 and replace it with a new fix.   *
      *  184363 - USLIP 'Our START/LAST INT PAY DATE' and             *
      *           TSLIP 'Their START/LAST INT PAY DATE' should not    *
      *           be set to VDAT in amend.                            *
      *  CIR003 - Principal Exchange on Cross Currencies IRS.         *
      *  179510 - For Settlement method 04 , fields  URACC  &  UPACC -*
      *            Our  Receiving/ Payment Account    respectively    *
      *           not  correctly  updated .  Introduced  new  coding  *
      *           to validate  the Settlement Method  when updating   *
      *           the  DEALSDG  file .                                *
      *  CDL008 - Continuous Linked Settlement (Recompiled)           *
      *  CIR005 - FRA/IRS Business Day Conventions.                   *
      *  CDE001 - Data Export - CCRM Limits                           *
      *  CSW097 - SWIFT97 Changes to MT34n and MT36n Msg Gen          *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  168345 - Prevent two users from accessing same transaction   *
      *           in repair screen at the same cycle, and converting  *
      *           it into two different Midas Deal No.s  .            *
      *           Second user should not be allowed to repair the tran-
      *           saction and convert it into a another Midas Deal .  *
      *  168981 - SWIFT 1997 Changes for FRAIRS MT34* and MT36*       *
      *           (recompiled)                                        *
      *  CPL002 - Midas - Plato Interface                             *
      *  CAP006 - Check for deal being updated by another workstation *
      *  151240 - Initialise bit settings on insert                   *
      *  CAP004 - Add APIs Interest Rate Calendar processing          *
      *  CAP003 - Conversion of IR inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
     FDEALALL   UF A E           K DISK
     F                                     COMMIT
     F                                     INCLUDE(DEALSDGF)
     F                                     INCLUDE(DEALSDFF)
     FDLDLDGLN  UF A E           K DISK                                                       CLE025
     F                                     COMMIT                                             CLE025
      ** Deals Extension file                                                                 CLE025
                                                                                              CLE025
     FSDTIX     UF A E           K DISK
     F                                     COMMIT
     F                                     PREFIX(DX)

     FDLDTSCPD  UF A E           K DISK                                         CAP004
     F                                     PREFIX(@)                            CAP004
     F                                     COMMIT                               CAP004
                                                                                              CAP043
     FDLPCSCL0  UF   E           K DISK    RENAME(DLPCSCD0:DLPCSCX0)                          CAP043
     F                                     PREFIX(XX)                                         CAP043
     F                                     COMMIT                                             CAP043
                                                                                              CAP043
     FDLCFSCPD  UF A E           K DISK    PREFIX(CF)                                         CAP043
     F                                     COMMIT                                             CAP043
                                                                                              CAP043
     FDLPCSCPD  UF A E           K DISK    PREFIX(PC)                                         CAP043
     F                                     COMMIT                                             CAP043
                                                                                              CAP043
     FIRVDTSCL0 IF   E           K DISK                                                       CAP043
                                                                                              CAP043
     FIRVCFSCL0 IF   E           K DISK    PREFIX(CV)                                         CAP043
                                                                                              CAP043
     FIRVPCSCL0 IF   E           K DISK    PREFIX(PV)                                         CAP043
                                                                                              CSD015
      ** Compliance Watch Hit List                                                            CSD015
     FSDCWHTL1  IF   E           K DISK    INFSR(*PSSR)                                       CSD015
     F/COPY WNCPYSRC,IRH00073
                                                                                              CSD015
      ** RE Settled Transaction Index File by Transaction Reference ID                        CRE020
      ** and Transaction Maintenance Program                                                  CRE020
     FREADVCL1  UF   E           K DISK    COMMIT                                             CRE020
     F                                     USROPN                                             CRE020
                                                                                              CRE020
     F/COPY WNCPYSRC,IRSIRSDF01
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

      **------------------------------------------------------------------------CAP006 -------------
      ** The following /COPY line includes the definitions for error and        CAP006
      ** warning message arrays.                                                CAP006
     D/COPY ZACPYSRC,ERR_ARRAYS                                                 CAP006
      **------------------------------------------------------------------------CAP006--------------
                                                                                CAP006
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

      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID SINGLE CCY IRS
     D IRVSIRS       E DS                  EXTNAME(IRVSIRSPD)
     D  @RSDET1               11    715
     D  @RSREC               716    784
     D  @RSPY1               785    990
     D  @RSPY2               991   1133
     D  @RSPY3              1134   1343
     D**@RSDET2*************1344   2044                                         CAP013
     D**@RSDET2**           1344   2200                                  CAP013 CIR005
     D  @RSDET2             1344   2126                                         CIR005
      ** Their details Business Day Convention fields                                         CIR017
     D  @RSDET2T            2127   2190                                                       CIR017
     D   RCCY               2097   2126                                         CIR005
     D  @RSDET3             2551   2602                                                       CDL028

     D IRVXSIR       E DS                  EXTNAME(IRVXSIRPD)                                 CLE025
      **  Externally described data structure for valid extension file                        CLE025
                                                                                              CLE025
      **  DEALS FILE - FORWARD RATE AGREEMENTS
     D DEALS         E DS                  EXTNAME(DEALSDG)
     D  @DLDET1               11    715
     D  @DLREC               716    784
     D  @DLPY1               785    990
     D  @DLPY2               991   1133
     D  @DLPY3              1134   1343
     D**@DLDET2*************1344   2044                                         CAP013
     D**@DLDET2**           1344   2200                                  CAP013 CIR005
     D  @DLDET2             1344   2126                                         CIR005
      ** Their details Business Day Convention fields                                         CIR017
     D  @DLDET2T            2127   2190                                                       CIR017
     D  @DLDET3             2551   2602                                                       CDL028

     D DEALEXT       E DS                  EXTNAME(DLDLDGQD)                                  CLE025
      ** Deals extension file                                                                 CLE025
                                                                                              CLE025
     D ChkDealFmt    E DS                  EXTNAME(DEALSDG)                     CAP006
      ** Rename fields for Transaction No of Last Update Processing             CAP006
     D                                     PREFIX(CH)                           CAP006
                                                                                              CLE025
     D ChkDealXFmt   E DS                  EXTNAME(DLDLDGQD)                                  CLE025
      ** Rename fields for Transaction No of Last Update Processing                           CLE025
     D                                     PREFIX(CH)                                         CLE025
                                                                                CAP006
     D IRESIRS       E DS                  EXTNAME(IRESIRSPD)                   CAP006
      * Error indicators                                                        CAP006
                                                                                CAP006
      **  Time data structure for DTRIX.
     D                 DS
     D  @XTIME                 1      6  0
     D  DXTIM                  1      4  0
                                                                                              CAP043
      ** Last processing date (82nd PRDT) UR/UP/TR/TP                                         CAP043
     D PLastPRDT       DS                                                                     CAP043
     D WLastPRDT               1     12P 0 DIM(4)                                             CAP043

     D** Define external data-structures for before and after image
     D**   of deal for on-line updates.
     D*
     D Z#BSTS        E DS                  EXTNAME(Z#BST)
     D Z#ASTS        E DS                  EXTNAME(Z#AST)
     D Z#WSTS        E DS                  EXTNAME(Z#WST)                                     CIR003
     D Z#XSTS        E DS                  EXTNAME(Z#XST)                                     CIR003
     D Z#YSTS        E DS                  EXTNAME(Z#YST)                                     CIR003
     D Z#ZSTS        E DS                  EXTNAME(Z#ZST)                                     CIR003
     D*
  109D IRCDates      E DS                  EXTNAME(IRVDTSCPD)                   CAP004
      ** Data structure for Int. Rate Calendar dates.                           CAP004
     D  DatAlp                 1    294A                                        CAP004
     D  FOffID                 1     20A                                        CAP004
     D  RatPayInd             21     21A                                        CAP004
     D  OurThrInd             22     22A                                        CAP004
     D  InDate                23    268P 0 DIM(82)                              CAP004
     D  WDTSCConfH           269    350A   DIM(82)                                            CAP043

     D VldCashFlw    E DS                  EXTNAME(IRVCFSCPD) PREFIX(CV)                      CAP043
      ** Valid Cash Flow definition file                                                      CAP043
     D WCashFlwD              22    267P 0 DIM(82)                                            CAP043
     D WCashFlwA             268    841P 0 DIM(82)                                            CAP043
     D WCFSCConfH            842    923A   DIM(82)                                            CAP043
                                                                                              CAP043
     D VldPrinChg    E DS                  EXTNAME(IRVPCSCPD) PREFIX(PV)                      CAP043
      ** Valid Prin Change def file                                                           CAP043
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
      * DATA STRUCTURES FOR USE WITH ACCESS PROGRAMS

     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * DATA STRUCTURE FOR BANK DETAILS

     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
      ** External DS for TRADE Details

     D SDFAIS        E DS                  EXTNAME(SDFAISPD)
      ** External data structure for FRA/IRS I.C.D. details
      *
     D SDRETL        E DS                  EXTNAME(SDRETLPD)                                  200400
      ** External data structure for RETAIL details                                           200400
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
                                                                                              200400
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** External DS for BRANCH Details

     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      ** External DS for BASE RATE Details

     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for CURRENCY Details

     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)
      ** External DS for BOOK Details

     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CAP004
     D SCA_LCD       E                     EXTFLD(LCD)                          CAP004
      ** EXTERNAL DS FOR SAR DETAILS                                            CAP004
                                                                                CAP004
      ** FRA/IRS Interface Non-Screen Data                                                    CAP043
     D InfData       E DS                  EXTNAME(IRRSIFPD)                                  CAP043
                                                                                              CAP043
      ** Module Details Data Structure                                                        CAP043
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CAP043
                                                                                              CAP043
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSD015
      ** External DS for Customer Details                                                     CSD015
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CGL029
                                                                                              CSD015
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
      ** External DS for Watch List Checking Details                                          CSD015
                                                                                              CSD015
     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)                                  CSD015
      ** Watch List Transaction Details Data Structure                                        CSD015
                                                                                              CSD015
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                  CSD015
      ** Compliance Watch Configuration Data DS                                               CSD015
                                                                                              CSD015
     D WLFBC         E DS                  EXTNAME(DEALSDG)                                   CSD015
     D                                     PREFIX(BC)                                         CSD015
      ** Backup Container of the Watch List Fields                                            CSD015
                                                                                              CSD015
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status data area                                                                CSC011
      *                                                                                       CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
      *                                                                                       CSC011
     D APHEAD        E DS                  EXTNAME(APHEADPD)                                  CSC011
      ** Midas API Message Header Format Definition                                           CSC011
      *                                                                                       CSC011
     D/COPY WNCPYSRC,IRH00074
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

      ** Value Date in Midas Day Number format returned as a parameter
     D ZDAYNO          S              5  0

      * Date Array index (3P0) for use with IRCs                                CAP004
     D   X             S              2P 0 INZ(*ZEROS)                          CAP004
                                                                                CAP004
      ** Screen/Server input flag to indicate                                   CAP004
      ** source of transaction.                                                 CAP004
     D ScreenInpt      S              1A                                        CAP004
                                                                                CAP004
      ** Dummy message ID and message file fields for use on the calls to       CAP006
      ** ZAMSGTOOPR                                                             CAP006
     D DummyMsgID      S                   LIKE(#MsgID)                         CAP006
     D DummyMsgF       S             10A                                        CAP006

      ** Max. no. of elements associated with the CE arrays.                                  CSD015
     D ArrMax          C                   CONST(13)                                          CSD015
                                                                                              CSD015
      ** XML Opening Tags for the Compliance Engine.                                          CSD015
     D XOT             S             25A   DIM(ArrMax) PERRCD(1) CTDATA                       CSD015
                                                                                              CSD015
      ** XML Closing Tags for the Compliance Engine.                                          CSD015
     D XCT             S             25A   DIM(ArrMax) PERRCD(1) CTDATA                       CSD015
                                                                                              CSD015
      ** Formatted Watch List Fields Array.                                                   CSD015
     D WLF             S             35A   DIM(ArrMax)                                        CSD015
                                                                                              CSD015
      ** Watch List Fields Standing Data Array.                                               CSD015
     D WLFSD           S             35A   DIM(ArrMax)                                        CSD015
                                                                                              CSD015
      ** Defined fields for Enhancement CSC011                                                CSC011
     D CSC011          S              1A                                                      CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D Timestamp       S             26A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D***PDealNum        S             18A                                             CSC011 CGL029
     D***PADealNo        S             18A                                             CSC011 CGL029
     D PDealNum        S             24A                                                      CGL029
     D PADealNo        S             24A                                                      CGL029
     D WDealNo         S              6A                                                      CSC011
     D PCustNo         S             10A                                                      CSD015
     D PErrInf         S              7A                                                      CSD015
                                                                                              CSC011
      ** Variables defined for CAS001                                                         CAS001
                                                                                              CAS001
     D CAS001          S              1A                                                      CAS001
                                                                                              CAS001
      ** Define fields used in CAS005                                                         CAS005
                                                                                              CAS005
     D CAS005          S              1A                                                      CAS005
                                                                                              CAS005
      ** Switchable Feature Parameter                                                         CIR008
     D CIR008          S              1A                                                      CIR008
     D CAP056          S              1A                                                      CAP056
     D CAP051          S              1A                                                     BUG6671
     D CIR011          S              1A                                                      CIR011
     D CDL028          S              1A                                                      CDL028
     D CIR006          S              1A                                                    BUG7217R
     D CIR017          S              1A                                                      CIR017
                                                                                              CIR008
      ** Parameter fields when calling ZAFUTSTATP                                             CIR008
     D P_ACTN          S              1A                                                      CIR008
     D P_CSTS          S              1A                                                      CIR008
     D P_DSTS          S              1A                                                      CIR008
                                                                                              CIR008
     D WkActn          S              1A                                                      CIR008
     D PModeOfOp       S              6A                                                      CAP056
                                                                                              CAS004
      ** Index for arrays of of warning message ids etc                                       CAS004
     D WIdx            S              3P 0                                                    CAS004
                                                                                              CAP056
      ** Variables used for CAP043                                                            CAP043
     D PDealNo         S              6S 0                                                    CAP043
     D POurCCY         S              3A                                                      CAP043
     D PThrCCY         S              3A                                                      CAP043
     D PBGN2ST         S              1A                                                      CAP043
     D CAP041          S              1A                                                      CAP043
     D CAP043          S              1A                                                      CAP043
     D WPAMT           S             15  0                                                    CAP043
     D WCTLDYN         S              5  0                                                    CAP043
     D PFunction       S              4A                                                      CAP043
     D PFrontID        S             20A                                                      CAP043
     D PInfData        S              1A                                                      CAP043
                                                                                              CAP043
      ** Compliance Watch Indicator                                                           CSD015
     D CSD015          S              1A   INZ('N')                                           CSD015
                                                                                              CSD015
      ** Concord Interface Development Indicator                                              CSD015
     D CCF001          S              1A   INZ('N')                                           CSD015
                                                                                              CSD015
      ** AOWLCCR0 Function Code Parameter                                                     CSD015
     D PFuncCode       S              8                                                       CSD015
                                                                                              CSD015
      ** Compliance Engine Free Format String Parameter                                       CSD015
     D PFreeFmtStr     S          30000A                                                      CSD015
                                                                                              CSD015
      ** SDCWLFMT Parameters.                                                                 CSD015
     D PInpA           S             35                                                       CSD015
     D PInpB           S             35                                                       CSD015
     D PInpC           S             35                                                       CSD015
     D PInpD           S             35                                                       CSD015
     D PInpE           S             35                                                       CSD015
     D POutA           S              6                                                       CSD015
                                                                                              CSD015
      ** ZACVTDATE Parameters                                                                 CSD015
     D PZADayNo        S              5                                                       CSD015
     D PZADDT          S               D                                                      CSD015
     D PZACvtDate      S             10                                                       CSD015
                                                                                              CSD015
      ** ZACVTAMT Parameters                                                                  CSD015
     D PZARtCd         S             10                                                       CSD015
     D PZACcy          S              3                                                       CSD015
     D PZANtvAmt       S             15                                                       CSD015
     D PZAAmt          S             18  3                                                    CSD015
     D PZACvtAmt       S             16                                                       CSD015
                                                                                              CSD015
      ** Working Variables                                                                    CSD015
     D Ctr             S              2  0                                                    CSD015
     D WData           S            216                                                       CSD015
     D WXMLPacket      S            400                                                       CSD015
     D WMoveMode       S              1                                                       CSD015
     D WCompMode       S              1                                                       CSD015
     D WChgFlg         S              1                                                       CSD015
     D WOKFlg          S              1                                                       CSD015
     D WRetryFlg       S              1                                                       CSD015
     D WCtrpRpt        S             30                                                       CSD015
     D WCtrpTyp        S              1                                                       CSD015
     D WDDT            S               D                                                      CSD015
     D WAMT            S             18  3                                                    CSD015
     D WCcy            S              3                                                       CSD015
     D WRK_10          S             16A                                                      CGL029
     D T#TREF          S             26A                                                      CGL029
                                                                                              CSD015
      ** Compliance Watch Hit List Key Fields                                                 CSD015
     D KFuncType       S              8A                                                      CSD015
     D KIden           S             40A                                                      CSD015
     D KBranch         S              3A                                                      CSD015
                                                                                              CSD015
      ** WMoveMode Constants                                                                  CSD015
     D ALL             C                   CONST('A')                                         CSD015
     D CHANGED         C                   CONST('C')                                         CSD015
                                                                                              CSD015
      ** WCompMode Constants                                                                  CSD015
     D OnInsert        C                   CONST('I')                                         CSD015
     D OnAmend         C                   CONST('A')                                         CSD015
                                                                                              CSD015
      ** Define fields used in CRE020                                                         CRE020
     D CRE020          S              1A                                                      CRE020
     D KRefNo          S             30A                                                      CRE020
     D KPrgMn          S             10A   INZ('IRSIRSUPD ')                                  CRE020
     D PSysVal01       S             20A   INZ('SngleCcyIntRateSwaps')                        CRE020
     D PCurSet01       S            200A                                                      CRE020
     D***PSysVal02     S             20A                                             CRE020 MD054117
     D PSysVal02       S             20A   INZ('DspPrinInDecInd')                           MD054117
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
                                                                                              CRE020
     D CLE025          S              1A                                                      CLE025
     D/COPY WNCPYSRC,IRH00075
                                                                                              CLE025
      *                                                                                     MD054117
     D PCIDCF          S              1A                                                    MD054117
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************

      * EXIT IF NOT INSERTION, AMENDMENT OR REVERSAL
      ** only when CIR008 is switched off                                                     CIR008

     C                   IF        CIR008 = 'N'                                               CIR008
     C     RSCHTP        IFNE      'I'
     C     RSCHTP        ANDNE     'A'
     C     RSCHTP        ANDNE     'R'
     C                   RETURN
     C                   END
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
      ** Include checking of authorisation if CIR008 is switched on                           CIR008
                                                                                              CIR008
     C                   IF        CIR008 = 'Y'                                               CIR008
     C                   IF        RSCHTP <> 'I'  AND  RSCHTP <> 'A' AND                      CIR008
     C                             RSCHTP <> 'R'  AND  RSCHTP <> 'X'                          CIR008
     C                   RETURN                                                               CIR008
     C                   ENDIF                                                                CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
      ** Save the action code                                                                 CIR008
                                                                                              CIR008
     C                   EVAL      WkActn = RSCHTP                                            CIR008
     C                   EVAL      WSCHTP = RSCHTP                                            CRE020

      ** Ensure transaction has not been updated by another workstation         CAP006
      ** - if so, bypass updating and return to calling program.                CAP006
     C                   EXSR      CHKOTHUPD                                    CAP006
                                                                                CAP006
     C     @@RTCD        IFNE      *BLANKS                                      CAP006
     C                   GOTO      EXIT                                         CAP006
     C                   END                                                    CAP006
                                                                                CAP006
      ** Set ICD Authorisation of FRA/IRS to 'N'                                              CAP056
      ** if Auto Authorisation on Cross Ccy Valid File is 'Y'                                 CAP056
                                                                                              CAP056
     C                   IF        CAP056 = 'Y' AND PModeofOp = '*FRONT' AND                  CAP056
     C                             RSAUTH = 'Y'                                               CAP056
     C                             OR CAP051 = 'Y' AND RSAUTH = 'Y'                          BUG6671
     C                   EVAL      BQFIAU = 'N'                                               CAP056
     C                   EVAL      BQFIRA = 'N'                                               CAP056
     C                   ELSE                                                                 CAP056
     C                   EVAL      BQFIAU = WkFIAU                                            CAP056
     C                   EVAL      BQFIRA = WkFIRA                                            CAP056
     C                   ENDIF                                                                CAP056
     C                                                                                        CAP056
      * INSERT, AMEND, OR REVERSE THE DEAL
      ** or Authorise                                                                         CIR008

     C     RSCHTP        CASEQ     'I'           SIRINS
     C     RSCHTP        CASEQ     'A'           SIRAMD
     C     RSCHTP        CASEQ     'R'           SIRDEL
     C     RSCHTP        CASEQ     'X'           SrAuthorise                                  CIR008
     C                   END
     C/COPY WNCPYSRC,IRH00076

      * SET PAY/RECEIVE INDICATORS TO BE WRITTEN TO DTRIX
      ** when CIR008 is switched off or when reversing a deal                                 CIR008
      ** Or Authorisation/Re-authorisation flags are both 'N'                                 CIR008
                                                                                              CIR008
     C                   IF        RSCHTP <> *BLANKS                                          CIR008

     C                   EXSR      PYRCIN

      * WRITE A DTRIX RECORD
     C/COPY WNCPYSRC,IRSIRSDC01

     C                   EXSR      WRTDTX
     C/COPY WNCPYSRC,IRSIRSDC02

      * UPDATE THE DTRIX HEADER RECORD
     C/COPY WNCPYSRC,IRSIRSDC03

     C                   EXSR      UPDDTH
     C/COPY WNCPYSRC,IRSIRSDC04
                                                                                              CIR008
     C                   ENDIF                                                                CIR008

      ** UPDATE THE DEALS FILE TRAILER
      ** ON INSERTS AND REVERSALS

     C     RSCHTP        IFEQ      'I'
     C     RSCHTP        OREQ      'R'
     C                   EXSR      UPDTRL
     C                   END
     C/COPY WNCPYSRC,IRSIRSDC10
      *
      ** UPDATE ON-LINE POSITION FILES
      *
     C**********         IF        RSCHTP <> *BLANKS                                  CIR008 BUG6373
     C                   EXSR      UPDOLP
      *
     C* CALL SUMMARY UPDATE PGM
     C*
     C                   EXSR      UPDSUP
     C**********         ENDIF                                                        CIR008 BUG6373
                                                                                              CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CSC011
      ** If 24x7 Midas Availability is installed                                              CSC011
      ** and Support System is active                                                         CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   CALLB     'IRSIRSLOG'                                                CSC011
     C                   PARM      *Blanks       RetCodeOut                                   CSC011
     C                   PARM                    WkActn                                       CIR008
     C                   PARM                    DEALS                                        CSC011
     C                   PARM                    DEALEXT                                      CLE025
     C                   PARM      *ZERO         PLastPRDT                                    CAP043
     C                   PARM      *BLANK        RECScnFmt                                    CAP043
     C                   PARM      *BLANK        PAYScnFmt                                    CAP043
     C                   PARM      *BLANK        FRIRScnFmt                                   CAP043
     C                   PARM      *BLANK        InfData                                      CAP043
     C                   PARM                    TRANSDTL                                     CSC011
                                                                                              CSC011
      ** If there is no error, write the log file                                             CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut = *Blanks                                       CSC011
                                                                                              CSC011
     C                   EVAL      APTGTTYPE = 'IRSIRS'                                       CSC011
     C                   EVAL      APFOTRANID = RSFRNT                                        CSC011
     C                   EVAL      APFOASOCID = RSFRNT                                        CAP043
     C                   EVAL      APRPRLOCN  = RSREPA                                        CSC011
     C                   EVAL      APUSERID   = PSUser                                        CSC011
     C                   EVAL      APMIDUSR   = PSUser                                        CSC011
                                                                                              CSC011
     C                   MOVEL     RSDLNO        PDealNum                                     CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    APHEAD                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM      *BLANKS       Timestamp                                    CSC011
     C                   PARM                    PDealNum                                     CSC011
     C                   PARM      *BLANKS       PADealNo                                     CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** If there is an error in either log file, end program                                 CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *Blanks                                      CSC011
     C                   EVAL      @@RTCD = '*ERROR'                                          CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CAP043
      ** Log transaction for additional IRC schedules (greater than 82)                       CAP043
      ** if CAP043 is on.                                                                     CAP043
                                                                                              CAP043
     C                   IF        CAP043 = 'Y'                                               CAP043
                                                                                              CAP043
     C                   CALLB     'IRIRCLOG'                                                 CAP043
     C                   PARM      *BLANK        RetCodeOut                                   CAP043
     C                   PARM      'SIRS'        PFunction                                    CAP043
     C                   PARM      FRNT          PFrontID                                     CAP043
     C                   PARM      DLNO          PDealNo                                      CAP043
     C                   PARM                    PLastPRDT                                    CAP043
     C                   PARM      UCUCY         POurCcy                                      CAP043
     C                   PARM      TCUCY         PThrCcy                                      CAP043
     C**********         PARM      BGN2ST        PBGN2ST                             CAP043 MD054117
     C                   PARM      PCIDCF        PBGN2ST                                    MD054117
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
     C                   EVAL      @@RTCD = '*ERROR'                                          CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
      *
      * EXIT FROM PROGRAM
     C     EXIT          TAG                                                    CAP006
      *
     C                   RETURN
     C****************************************************************
      /EJECT
     C*****************************************************************         CAP006
     C*                                                               *         CAP006
     C* CHKOTHUPD - Check for update by another workstation           *         CAP006
     C*                                                               *         CAP006
     C*****************************************************************         CAP006
     C     CHKOTHUPD     BEGSR                                                  CAP006
                                                                                CAP006
      ** Retrieve current deal details                                          CAP006
                                                                                CAP006
     C                   MOVE      RSDLNO        MidasDlNum        6            CAP006
                                                                                CAP006
      ** Determine whether program is running interactively or in batch         CAP006
      **  ( 0 = batch   1 = interactive)                                        CAP006
      *                                                                         CAP006
     C                   CALLB     'ZARTVJOBA'                                  CAP006
     C                   PARM                    @Return           6            CAP006
     C                   PARM                    @type             1            CAP006
      *                                                                         CAP006
      * Allow access to transaction record by Front-Office ID when in Repair    168345
      * mode for inserts . Set  *RTV module  parameter @@MODE  to   *FRONT      168345
      * if the pgm is:  a) running in Interactive mode - @Type= 1   ~~~~~~      168345
      * and             b) action code is Insert - 'I'                          168345
      * and             c) Front-Office Id is NOT Blank                         168345
      *                                                                         168345
     C     @Type         IFEQ      '1'                                          168345
     C     RSCHTP        ANDEQ     'I'                                          168345
     C     RSFRNT        ANDNE     *BLANKS                                      168345
      *                                                                         168345
     C                   MOVE      '*FRONT'      @@MODE                         168345
      *                                                                         168345
     C                   ELSE                                                   168345
      *                                                                         168345
      * Otherwise, if running in batch use Front-Office ID                      168345
      *            (if insert)                                                  CAP013
      *            else, use Midas Deal Number                                  168345
      *                                                                         168345
     C     @Type         IFEQ      '0'                                          CAP006
     C     RSCHTP        ANDEQ     'I'                                          CAP013
     C                   MOVE      '*FRONT'      @@MODE                         CAP006
     C                   ELSE                                                   CAP006
     C                   MOVE      *BLANKS       @@MODE                         CAP006
     C                   END                                                    CAP006
      *                                                                         168345
     C                   END                                                    168345
                                                                                CAP006
     C                   CALLB     'IRSIRSRTV'                                  CAP006
      * INPUTS                                                                  CAP006
      *                                                                         CAP006
      * Return code                                                             CAP006
     C                   PARM      *BLANK        RetCodeOut                     CAP006
      *                                                                         CAP006
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                    CAP006
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP006
      *                                                                         CAP006
     C                   PARM                    @@MODE            6            CAP006
      *                                                                         CAP006
      * Response mode                                                           CAP006
     C                   PARM      ' '           @@RSMD            1            CAP006
      *                                                                         CAP006
      * Action Code                                                             CAP006
     C                   PARM                    RSCHTP                         CAP006
      *                                                                         CAP006
      * Front Office Transaction ID                                             CAP006
     C                   PARM      RSFRNT        FOTRID           20            CAP006
      *                                                                         CAP006
      * Front Office Associated Transaction Id                                  CAP006
     C                   PARM                    FOASID           20            CAP006
      *                                                                         CAP006
      * (Midas) Deal Number                                                     CAP006
     C                   PARM                    MidasDlNum                     CAP006
      *                                                                         CAP006
      * (Midas) Swap/Option Deal Number                                         CAP006
     C                   PARM                    DDSDNO            6            CAP006
      *                                                                         CAP006
      * Booking branch                                                          CAP006
     C                   PARM      RSBRCA        DDBRSN            3            CAP006
                                                                                              CIR008
      ** FRA/IRS Deals Authorisation                                                          CIR008
     C                   PARM                    CIR008                                       CIR008
      *                                                                         CAP006
      * OUTPUTS                                                                 CAP006
      *                                                                         CAP006
      * (Current) deal in file format                                           CAP006
      ** (Current) deal extention in file format                                              CLE025
     C                   PARM                    ChkDealFmt                     CAP006
     C                   PARM                    ChkDealXFmt                                  CLE025
      *                                                                         CAP006
      * OK - Action code                                                        CAP006
     C                   PARM      *BLANK        OKACCD                         CAP006
      *                                                                         CAP006
      * OK - Deal Number                                                        CAP006
     C                   PARM      *BLANK        OKDLNO                         CAP006
      *                                                                         CAP006
      * OK - Booking branch                                                     CAP006
     C                   PARM      *BLANK        OKBRCA                         CAP006
      *                                                                         CAP006
      * Error fields/message IDs/message data (arrays) from/to caller           CAP006
     C                   PARM      *BLANK        FldNameArr                     CAP006
     C                   PARM      *BLANK        MsgIdArr                       CAP006
     C                   PARM      *BLANK        MsgDtaArr                      CAP006
      *                                                                         CAP006
      * Array index (3P0) from/to caller                                        CAP006
     C                   PARM      *ZERO         Idx               3 0          CAP006
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
      *                                                                         CAP006
      *                                                                         CAP006
      ** Error if Transaction No. of Last Update (TNLU) not the same            CAP006
      ** (Record has been changed by another workstation)                       CAP006
                                                                                CAP006
      ** Processing varies according to mode program is running in.             CAP006
      ** In interacive mode simply check whether the TNLU field                 CAP006
      ** has been updated since the original deal was fetched by this           CAP006
      ** program.                                                               CAP006
      ** In batch (API input) check return parameters from Retrieve             CAP006
      ** module for errors, and send message to system operator.                CAP006
                                                                                CAP006
      ** Interactive mode:                                                      CAP006
                                                                                CAP006
     C     @TYPE         IFEQ      '1'                                          CAP006
                                                                                CAP006
     C     CHTNLU        IFNE      RSTNLU                                       CAP006
     C                   MOVEL     '*RECUPD'     @@RTCD                         CAP006
     C                   END                                                    CAP006
                                                                                CAP006
      ** Batch mode:                                                            CAP006
     C                   ELSE                                                   CAP006
     C     OKACCD        IFEQ      'N'                                          CAP006
     C     OKDLNO        OREQ      'N'                                          CAP006
     C                   MOVEL     '*RECUPD'     @@RTCD                         CAP006
     C                   Z-ADD     1             C                 2 0          CAP006
                                                                                CAP006
     C     C             DOWLE     ArrayMax                                     CAP006
     C     FldNameArr(C) ANDNE     *BLANKS                                      CAP006
     C*******************MOVEL     *BLANKS       DBError          28     CAP006 CAP013
     C*******************MOVEL     MsgIDArr(C)   DBError                 CAP006 CAP013
     C                   CLEAR                   DBError         132            CAP013
     C                   EVAL      DBerror = 'Update error: ' + FOTRID          CAP013
     C                   CALLB     'ZAMSGTOOPR'                                 CAP006
     C                   PARM                    MsgSndRtn        10            CAP006
     C                   PARM                    DBError                        CAP006
     C                   PARM                    DummyMsgID                     CAP006
     C                   PARM                    DummyMsgF                      CAP006
     C                   ADD       1             C                              CAP006
     C                   END                                                    CAP006
                                                                                CAP006
     C                   END                                                    CAP006
                                                                                CAP006
     C                   END                                                    CAP006
                                                                                CAP006
     C                   ENDSR                                                  CAP006
     C****************************************************************
     C*                                                              *
     C* SIRINS  - INSERT AN IRS                                       *
     C*                                                              *
     C****************************************************************
     C     SIRINS        BEGSR

      * SET CONFIRMATION REQUIRED INDICATOR
      * TO BE WRITTEN TO DTRIX
      ** when CIR008 is switched off                                                          CIR008

     C                   IF        CIR008 = 'N'  OR                                           CIR008
     C                             CIR008 = 'Y'  AND  BQFIAU <> 'Y'                           CIR008
     C                   EXSR      CNFINS
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
     C                   PARM      *BLANK        RSCHTP                                       CIR008
                                                                                              CIR008
     C                   ENDIF                                                                CIR008

      * INITIALIZE DEAL

     C                   CLEAR                   DEALS
     C                   CLEAR                   DEALEXT                                      CLE025
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

      ** Initialise "before" status of deal for on-line updates.
      *
     C                   MOVEL     *BLANK        Z#BSTS

      * RECORD ID

     C                   MOVEL     'D'           RECI

      * DEAL NUMBER & RECORD TYPE

     C                   Z-ADD     RSDLNO        DLNO
     C                   MOVE      'G'           RCDT

      * DEAL RECORD CODE

     C                   Z-ADD     22            RCDC

      *  DEAL DETAILS

     C                   MOVE      @RSDET1       @DLDET1
     C                   MOVE      RSURACC       URACC                                        CGL029
     C                   MOVE      RSUPACC       UPACC                                        CGL029
     C                   MOVE      @RSDET2       @DLDET2
      **                                                                                      CIR017
      ** Update Their details Business Day Convention fields                                  CIR017
     C                   IF        CIR017 = 'Y'                                               CIR017
     C                   MOVE      @RSDET2T      @DLDET2T                                     CIR017
     C                   ENDIF                                                                CIR017
                                                                                              CDL028
     C                   IF        CDL028 = 'Y'                                               CDL028
     C                   MOVE      @RSDET3       @DLDET3                                      CDL028
     C                   ENDIF                                                                CDL028
      *
     C                   IF        CAS001 = 'Y'                                               CAS001
     C                   EVAL      FSOYLC = RSOYLC                                            CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS005
      ** If CAS005 is installed, move 'Their Yield Curve' and Our/Their Forward               CAS005
      ** Yield Curve details to the file field.                                               CAS005
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      FSTYLC = RSTYLC                                            CAS005
     C                   EVAL      FSOFYC = RSOFYC                                            CAS005
     C                   EVAL      FSTFYC = RSTFYC                                            CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CIR008
      ** Deals Status and Insert User                                                         CIR008
                                                                                              CIR008
     C                   IF        CIR008 = 'Y'                                               CIR008
     C**********         EVAL      FIUSRI = PsUSer                                     CIR008 CAP084
     C                   EXSR      SrGetUser                                                  CAP084
     C                   EVAL      FIUSRI = PUser                                             CAP084
     C                   EVAL      FIDSTS = P_DSTS                                            CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CAP056
      ** Update Auto Authorisation on DEALSDG with value from Valid file                      CAP056
                                                                                              CAP056
     C                   IF        CAP056 = 'Y'                                               CAP056
     C                             OR CAP051 = 'Y'                                           BUG6671
     C                   EVAL      FIAUTH = RSAUTH                                            CAP056
     C                   ENDIF                                                                CAP056
      *
      * RECEIVE SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @RSREC        @DLREC
     C                   MOVE      RSRONS        RONS                                         CGL029
      *
      * PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @RSPY1        @DLPY1
     C                   MOVE      RSPONS        PONS                                         CGL029
     C                   MOVEL     @RSPY2        @DLPY2
     C                   MOVEL     @RSPY3        @DLPY3
      *
      * 'OLD' SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     RSRSTM        RSETM
     C                   MOVEL     RSRONS        URACC
      *                                                                                       200400
      ** OUR RECEIVING ACCOUNT = CUSTOMER DEFAULT ACCOUNT, IF METHOD 04                       200400
      *                                                                                       200400
     C     RSRSTM        IFEQ      04                                                         200400
     C**********         MOVEL     RSCNUM        WRK_10           10                   200400 CGL029
     C                   MOVEL     RSCNUM        WRK_10                                       CGL029
     C                   MOVE      BMACCD        WRK_10                                       200400
     C                   MOVEL     WRK_10        URACC                                        200400
     C                   MOVE      '01'          URACC                                        200400
     C                   ENDIF                                                                200400
      ************                                                                     179510 200400
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **Data-Structure  into the  correspondent  file  field  .                        179510 200400
      ************                                                                     179510 200400
     C*****RSRSTM*       IFEQ      04                                                  179510 200400
     C************       MOVE      RSURACC       URACC                                 179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
     C***********        MOVEL     RSAWBN        CPPBK                          CSW097
     C                   MOVEL     RSRCRN        CPPBK                          CSW097
     C                   MOVEL     RSPSTM        PSETM
     C                   MOVEL     RSPONS        UPACC
      *                                                                                       200400
      ** OUR PAYMENT ACCOUNT = CUSTOMER DEFAULT ACCOUNT, IF METHOD 04                         200400
      *                                                                                       200400
     C     RSPSTM        IFEQ      04                                                         200400
     C**********         MOVEL     RSCNUM        WRK_10           10                   200400 CGL029
     C                   MOVEL     RSCNUM        WRK_10                                       CGL029
     C                   MOVE      BMACCD        WRK_10                                       200400
     C                   MOVEL     WRK_10        UPACC                                        200400
     C                   MOVE      '01'          UPACC                                        200400
     C                   ENDIF                                                                200400
      ************                                                                     179510 200400
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **File-Parameter  into the  correspondent  file  field  .                        179510 200400
      ************                                                                     179510 200400
     C*****RSPSTM*       IFEQ      04                                                  179510 200400
     C************       MOVE      RSUPACC       UPACC                                 179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
     C***********        MOVEL     RSRIBN        CPRBK                          CSW097
     C                   MOVEL     RSAWBN        CPRBK                          CSW097
     C                   MOVEL     RSBENN        FACO
     C                   MOVEL     RSBTB1        SPI
      *
      * SET UP REQUIRED FIELDS ON DEALSDG THAT WERE NOT SET UP ON
      * VALID FILE
      *
     C                   EXSR      SETREQFLDI
      *
      * Set Transaction No. of Last Update                                      CAP006
     C                   Z-ADD     1             TNLU                           CAP006
                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y'                                               CSC011
     C                   IF        FRNT = *BLANKS                                             CSC011
     C                   MOVE      DLNO          WDealNo                                      CSC011
     C                   EVAL      FRNT = 'MD' + WDealNo                                      CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       CSD015
      ** Check for compliance if necessary.                                                   CSD015
      *                                                                                       CSD015
     C                   IF        CSD015 = 'Y' AND                                           CSD015
     C                             W1EWLC = 'Y'                                               CSD015
      *                                                                                       CSD015
     C                   IF        CSC011 <> 'Y' OR                                           CSD015
     C                             (CSC011 = 'Y' AND                                          CSD015
     C                             S1MAIN = LIBR)                                             CSD015
     C                   EVAL      WCompMode = OnInsert                                       CSD015
     C                   EXSR      SRCompChk                                                  CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CDL038
      * Class                                                                                 CDL038
      *                                                                                       CDL038
     C                   MOVEL     RSCLAS        CLAS                                         CDL038
      *                                                                                       253954
      ** Blank-out Auto-authorisation field when transaction is                               253954
      ** inserted from third party API.                                                       253954
      *                                                                                       253954
     C     FRNT          IFNE      *BLANK                                                     253954
     C     CHTP          ANDEQ     'I'                                                        253954
     C     FIDSTS        ANDEQ     'A'                                                        253954
     C     FIAUTH        ANDEQ     'Y'                                                        253954
     C                   MOVEL     *BLANK        FIAUTH                                       253954
     C                   ENDIF                                                                253954
      *
      * WRITE DEAL
      *
     C                   WRITE     DEALSDGF
     C/COPY WNCPYSRC,IRSIRSDC05
      *
      ** If Interest Rate Calendars feature present and data has been           CAP004
      ** input via server write dates to file                                   CAP004
     C     CIR001        IFEQ      'Y'                                          CAP004
     C     ScreenInpt    ANDNE     'Y'                                          CAP004
     C                   EXSR      WRITEIRCS                                    CAP004
     C                   END                                                    CAP004
                                                                                CAP004
      ** Call PGM/DL2900 to set up deal activity for on-line updates.
      ** only if the deal is authorised. Else perform in SrAuthorise.                         CIR008
      *
     C**********         IF        RSCHTP <> *BLANKS                                  CIR008 BUG6373
     C                   MOVEL     DEALS         Z#ASTS
     C                   MOVE      RSDLNO        PDLNO
      *
     C                   CALLB     'DL2900'
     C                   PARM      *BLANK        PRTCD             7
     C                   PARM                    PDLNO             6
     C                   PARM      'A'           PBEAF             1
      *
     C     PRTCD         IFEQ      '*ERROR'
     C                   MOVEL     'DL2900'      DBFILE
     C                   MOVEL     '992'         DBASE
     C                   MOVEL     *BLANK        DBKEY
     C                   EXSR      *PSSR
     C                   END
     C**********         ENDIF                                                        CIR008 BUG6373
                                                                                              CLE025
      ** Set up deal extension file if Credit Lines is installed                              CLE025
                                                                                              CLE025
     C                   IF        CLE025 = 'Y'                                               CLE025
     C                   CLEAR                   DEALEXT                                      CLE025
     C                   MOVEL     IRVXSIR       DEALEXT                                      CLE025
     C                   MOVEL     RSDLNO        F1DLNO                                       CDL038
     C                   MOVEL     RSBRCA        F1BRCA                                       248452
     C                   WRITE     DLDLDGD0                                                   CLE025
     C                   ENDIF                                                                CLE025
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* SIRAMD  - AMEND AN IRS                                        *
     C*                                                              *
     C****************************************************************
     C     SIRAMD        BEGSR
      *
      * ACCESS DEAL
      *
     C     RSDLNO        CHAIN     DEALSDGF                           99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     RSDLNO        DBKEY
     C                   MOVEL     'DEALSDG '    DBFILE                         ************
     C                   MOVEL     '002'         DBASE                          * DBERR 002*
     C                   EXSR      SRERR                                        ************
     C                   END
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
     C                   PARM      *BLANK        RSCHTP                                       CIR008
                                                                                              CIR008
      ** Amend User                                                                           217684
     C*******************EVAL      FIUSRA = PsUser                                     217684BUG4646
     C                   EXSR      SrGetUser                                                 BUG4646
     C                   EVAL      FIUSRA = PUser                                            BUG4646
                                                                                              217684
     C                   ENDIF                                                                CIR008
                                                                                              CAP056
      ** Update Auto Authorisation on DEALSDG with value from Valid file                      CAP056
                                                                                              CAP056
     C                   IF        CAP056 = 'Y'                                               CAP056
     C                             OR CAP051 = 'Y'                                           BUG6671
     C                   EVAL      FIAUTH = RSAUTH                                            CAP056
     C                   ENDIF                                                                CAP056
      *
      ** Set up "before" status of deal for on-line updates.
      *
     C                   MOVEL     DEALS         Z#BSTS
     C                   MOVEL     DEALS         WLFBC                                        CSD015
     C                   MOVE      RSDLNO        PDLNO

      ** Store "before" values for later comparison.
     C                   Z-ADD     UEINR         ##UEINR
     C                   Z-ADD     TEINR         ##TEINR
     C                   Z-ADD     UNICD         ##UNICD
     C                   Z-ADD     TNICD         ##TNICD
     C                   Z-ADD     UFRFD         ##UFRFD
     C                   Z-ADD     TFRFD         ##TFRFD
     C                   MOVEL     L1CYR1        ##L1CYR1                                     235490
     C                   MOVEL     L1CYR2        ##L1CYR2                                     235490
     C                   MOVEL     L1CYR3        ##L1CYR3                                     235490
     C                   MOVEL     L1CYR4        ##L1CYR4                                     235490
     C                   MOVEL     L1CYR5        ##L1CYR5                                     235490
     C                   MOVEL     L1CYR6        ##L1CYR6                                     235490
     C                   MOVEL     L1CYR7        ##L1CYR7                                     235490
     C                   MOVEL     L1CYR8        ##L1CYR8                                     235490
     C                   MOVEL     L1CYR9        ##L1CYR9                                     235490
     C                   MOVEL     L1CYR0        ##L1CYR0                                     235490
     C                   Z-ADD     UIPBD         WUIPBD            5 0          CIR005
     C                   Z-ADD     TIPBD         WTIPBD            5 0          CIR005
     C                   Z-ADD     UNIPD         WUNIPD            5 0          CIR005
     C                   Z-ADD     TNIPD         WTNIPD            5 0          CIR005
     C                   MOVEL     L1AMCN        WL1AMC            2            CIR005

      ** Determine activity for on-line updates                                               CIR008
      ** only if the deal is authorised. Else perform in SrAuthorise.                         CIR008
                                                                                              CIR008
     C**********         IF        RSCHTP <> *BLANKS                                  CIR008 BUG6373
     C                   CALLB     'DL2900'
     C                   PARM      *BLANK        PRTCD
     C                   PARM                    PDLNO
     C                   PARM      'B'           PBEAF
      *
     C     PRTCD         IFEQ      '*ERROR'
     C                   MOVEL     'DL2900'      DBFILE
     C                   MOVEL     '993'         DBASE
     C                   MOVEL     *BLANK        DBKEY
     C                   EXSR      *PSSR
     C                   END
     C**********         ENDIF                                                        CIR008 BUG6373
      *
      * SET CONFIRMATION BIT ON DEAL
      * AND CONFIRMATION REQUIRED INDICATOR
      * TO BE WRITTEN TO DTRIX
      ** when CIR008 is switched off auto authorisation is not 'Y'                            CIR008
      *
     C**********         IF        CIR008 = 'N'  OR                                  CIR008 BUG6877N
     C**********                   CIR008 = 'Y'  AND  BQFIRA <> 'Y'                  CIR008 BUG6877N
     C                   EXSR      CNFAMD
     C**********         ENDIF                                                       CIR008 BUG6877N
      *
      *  DEAL DETAILS

     C                   MOVE      @RSDET1       @DLDET1
     C                   MOVE      RSURACC       URACC                                        CGL029
     C                   MOVE      RSUPACC       UPACC                                        CGL029
     C                   MOVE      @RSDET2       @DLDET2
                                                                                              CDL028
      ** Update Their details Business Day Convention fields                                  CIR017
     C                   IF        CIR017 = 'Y'                                               CIR017
     C                   MOVE      @RSDET2T      @DLDET2T                                     CIR017
     C                   ENDIF                                                                CIR017
      **                                                                                      CIR017
     C                   IF        CDL028 = 'Y'                                               CDL028
     C                   MOVE      @RSDET3       @DLDET3                                      CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CAS001
     C                   IF        CAS001 = 'Y'                                               CAS001
     C                   EVAL      FSOYLC = RSOYLC                                            CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS005
      ** If CAS005 is installed, move 'Their Yield Curve' and Our/Their Forward               CAS005
      ** Yield Curve details to the file field.                                               CAS005
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      FSTYLC = RSTYLC                                            CAS005
     C                   EVAL      FSOFYC = RSOFYC                                            CAS005
     C                   EVAL      FSTFYC = RSTFYC                                            CAS005
     C                   ENDIF                                                                CAS005
      *                                                                         CIR005
      ** Business Day Conventions details (OUR)                                 CIR005
      *                                                                         CIR005
     C                   IF        CIR005 = 'Y'  AND                            CIR005
     C                             RSUNIPD = WUIPBD  AND                        CIR005
     C                             WL1AMC = 'A'  AND                            CIR005
     C                             RSAMC1 = WL1AMC                              CIR005
      *                                                                         CIR005
     C                   EVAL      UNIPD = WUNIPD                               CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
      ** Business Day Conventions details (THEIR)                               CIR005
      *                                                                         CIR005
     C                   IF        CIR005 = 'Y'  AND                            CIR005
     C                             RSTNIPD = WTIPBD  AND                        CIR005
     C                             WL1AMC = 'A'  AND                            CIR005
     C                             RSAMC1 = WL1AMC                              CIR005
      *                                                                         CIR005
     C                   EVAL      TNIPD = WTNIPD                               CIR005
     C                   ENDIF                                                  CIR005
      *
      * RECEIVE SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @RSREC        @DLREC
     C                   MOVE      RSRONS        RONS                                         CGL029
      *
      * PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @RSPY1        @DLPY1
     C                   MOVE      RSPONS        PONS                                         CGL029
     C                   MOVEL     @RSPY2        @DLPY2
     C                   MOVEL     @RSPY3        @DLPY3
      *
      * 'OLD' SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     RSRSTM        RSETM
     C                   MOVEL     RSRONS        URACC
      *                                                                                       200400
      ** OUR RECEIVING ACCOUNT = CUSTOMER DEFAULT ACCOUNT, IF METHOD 04                       200400
      *                                                                                       200400
     C     RSRSTM        IFEQ      04                                                         200400
     C**********         MOVEL     RSCNUM        WRK_10           10                   200400 CGL029
     C                   MOVEL     RSCNUM        WRK_10                                       CGL029
     C                   MOVE      BMACCD        WRK_10                                       200400
     C                   MOVEL     WRK_10        URACC                                        200400
     C                   MOVE      '01'          URACC                                        200400
     C                   ENDIF                                                                200400
      ************                                                                     179510 200400
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **File-Parameter  into the  correspondent  file  field  .                        179510 200400
      ************                                                                     179510 200400
     C*****RSRSTM*       IFEQ      04                                                  179510 200400
     C************       MOVE      RSURACC       URACC                                 179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
     C***********        MOVEL     RSAWBN        CPPBK                          CSW097
     C                   MOVEL     RSRCRN        CPPBK                          CSW097
     C                   MOVEL     RSPSTM        PSETM
     C                   MOVEL     RSPONS        UPACC
      *                                                                                       200400
      ** OUR PAYMENT ACCOUNT = CUSTOMER DEFAULT ACCOUNT, IF METHOD 04                         200400
      *                                                                                       200400
     C     RSPSTM        IFEQ      04                                                         200400
     C**********         MOVEL     RSCNUM        WRK_10           10                   200400 CGL029
     C                   MOVEL     RSCNUM        WRK_10                                       CGL029
     C                   MOVE      BMACCD        WRK_10                                       200400
     C                   MOVEL     WRK_10        UPACC                                        200400
     C                   MOVE      '01'          UPACC                                        200400
     C                   ENDIF                                                                200400
      ************                                                                     179510 200400
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **Data-Structure  into the  correspondent  file  field  .                        179510 200400
      ************                                                                     179510 200400
     C*****RSPSTM*       IFEQ      04                                                  179510 200400
     C************       MOVE      RSUPACC       UPACC                                 179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
     C***********        MOVEL     RSRIBN        CPRBK                          CSW097
     C                   MOVEL     RSAWBN        CPRBK                          CSW097
     C                   MOVEL     RSBENN        FACO
     C                   MOVEL     RSBTB1        SPI
      *
      * SET UP REQUIRED FIELDS ON DEALSDG THAT WERE NOT SET UP ON
      * VALID FILE
      *
     C                   EXSR      SETREQFLDA
      *
      * Set Transaction No. of Last Update                                      CAP006
     C                   ADD       1             TNLU                           CAP006
      *                                                                                       CSD015
      ** Check for compliance if necessary.                                                   CSD015
      *                                                                                       CSD015
     C                   IF        CSD015 = 'Y' AND                                           CSD015
     C                             W1EWLC = 'Y'                                               CSD015
      *                                                                                       CSD015
     C                   IF        CSC011 <> 'Y' OR                                           CSD015
     C                             (CSC011 = 'Y' AND                                          CSD015
     C                             S1MAIN = LIBR)                                             CSD015
     C                   EVAL      WCompMode = OnAmend                                        CSD015
     C                   EXSR      SRCompChk                                                  CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CDL038
      * Class                                                                                 CDL038
      *                                                                                       CDL038
     C                   MOVEL     RSCLAS        CLAS                                         CDL038
      *
      * UPDATE DEAL
      *
     C                   UPDATE    DEALSDGF
     C/COPY WNCPYSRC,IRSIRSDC06
      *
      ** If Interest Rate Calendars feature present and data has been           CAP004
      ** input via server update file with new dates.                           CAP004
     C     CIR001        IFEQ      'Y'                                          CAP004
     C     ScreenInpt    ANDNE     'Y'                                          CAP004
     C                   EXSR      CLEARIRCS                                    CAP004
     C                   EXSR      WRITEIRCS                                    CAP004
     C                   END                                                    CAP004
                                                                                CAP004
      ** Call PGM/DL2900 to set up deal activity for on-line updates.
      ** only if the deal is authorised. Else perform in SrAuthorise.                         CIR008
      *
     C**********         IF        RSCHTP <> *BLANKS                                  CIR008 BUG6373
     C                   MOVEL     DEALS         Z#ASTS
     C                   MOVE      RSDLNO        PDLNO
      *
     C                   CALLB     'DL2900'
     C                   PARM      *BLANK        PRTCD
     C                   PARM                    PDLNO
     C                   PARM      'A'           PBEAF
      *
     C     PRTCD         IFEQ      '*ERROR'
     C                   MOVEL     'DL2900'      DBFILE
     C                   MOVEL     '994'         DBASE
     C                   MOVEL     *BLANK        DBKEY
     C                   EXSR      *PSSR
     C                   END
     C**********         ENDIF                                                        CIR008 BUG6373
                                                                                              CLE025
      ** Set up deal extension file if Credit Lines is installed                              CLE025
                                                                                              CLE025
     C                   IF        CLE025 = 'Y'                                               CLE025
                                                                                              CLE025
     C                   MOVEL     RSDLNO        PDLNO                                        CLE025
     C     PDLNO         CHAIN     DLDLDGD0                           01                      CLE025
     C     *IN01         IFEQ      '1'                                                        CLE025
     C                   MOVEL     RSDLNO        DBKEY                                        CLE025
     C                   MOVEL     'DLDLDGQD'    DBFILE                                       CLE025
     C                   MOVEL     '010'         DBASE                                        CLE025
     C                   EXSR      SRERR                                                      CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
     C                   MOVEL     IRVXSIR       DEALEXT                                      CLE025
     C                   UPDATE    DLDLDGD0                                                   CLE025
                                                                                              CLE025
     C                   ENDIF                                                                CLE025
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* SIRDEL  - DELETE AN IRS                                      *
     C*                                                              *
     C****************************************************************
     C     SIRDEL        BEGSR
      *
      * ACCESS DEAL
      *
     C     RSDLNO        CHAIN     DEALSDGF                           99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     RSDLNO        DBKEY
     C                   MOVEL     'DEALSDG '    DBFILE                         ************
     C                   MOVEL     '003'         DBASE                          * DBERR 003*
     C                   EXSR      SRERR                                        ************
     C                   END
                                                                                              CIR008
      ** Deal Status and Change Type                                                          CIR008
                                                                                              CIR008
     C                   IF        CIR008 = 'Y'                                               CIR008
                                                                                              CIR008
     C                   CALLB     'ZAFUTSTATP'                                               CIR008
     C                   PARM      'D'           P_ACTN                                       CIR008
     C                   PARM      FIDSTS        P_CSTS                                       CIR008
     C                   PARM                    BQFIAU                                       CIR008
     C                   PARM                    BQFIRA                                       CIR008
     C                   PARM      *BLANK        FIDSTS                                       CIR008
     C                   PARM      *BLANK        RSCHTP                                       CIR008
                                                                                              CIR008
     C                   ENDIF                                                                CIR008
      *
      ** Set up "before" status of deal for on-line updates.
      ** only if the deal is authorised. Else perform in SrAuthorise.                         CIR008
      *
     C**********         IF        RSCHTP <> *BLANKS                                  CIR008 BUG6373
     C                   MOVEL     IRVSIRS       Z#BSTS
     C                   MOVE      RSDLNO        PDLNO

     C                   CALLB     'DL2900'
     C                   PARM      *BLANK        PRTCD
     C                   PARM                    PDLNO
     C                   PARM      'B'           PBEAF
      *
     C     PRTCD         IFEQ      '*ERROR'
     C                   MOVEL     'DL2900'      DBFILE
     C                   MOVEL     '995'         DBASE
     C                   MOVEL     *BLANK        DBKEY
     C                   EXSR      *PSSR
     C                   END
     C**********         ENDIF                                                        CIR008 BUG6373
      *
      * SET CONFIRMATION BIT ON DEAL
      * AND CONFIRMATION REQUIRED INDICATOR
      * TO BE WRITTEN TO DTRIX
      *
     C                   EXSR      CNFDEL
      *
      * SET RECORD ID TO 'REVERSED'
      *
     C                   MOVE      'R'           RECI
      *
      ** LAST CHANGE DATE & TYPE
      *
     C                   Z-ADD     BJRDNB        LCD
     C**********         MOVE      'R'           CHTP                                         CIR008
     C                   EVAL      CHTP = RSCHTP                                              CIR008
      *
      * Set Transaction No. of Last Update                                      CAP006
     C                   ADD       1             TNLU                           CAP006
      *                                                                         CAP013
      ** Front office transaction ID                                            CAP013
      *                                                                         CAP013
     C                   MOVEL     RSFRNT        FRNT                           CAP013
      *
     C                   UPDATE    DEALSDGF
     C/COPY WNCPYSRC,IRSIRSDC07

      ** If Interest Rate Calendars feature present and data has been           CAP004
      ** input via server clear dates from file.                                CAP004
     C     CIR001        IFEQ      'Y'                                          CAP004
     C     ScreenInpt    ANDNE     'Y'                                          CAP004
     C                   EXSR      CLEARIRCS                                    CAP004
     C                   END                                                    CAP004
                                                                                CAP004
      ** Call PGM/DL2900 to set up deal activity for on-line updates.
      ** only if the deal is authorised. Else perform in SrAuthorise.                         CIR008
      *
     C**********         IF        RSCHTP <> *BLANKS                                  CIR008 BUG6373
     C                   MOVEL     DEALS         Z#ASTS
     C                   MOVE      RSDLNO        PDLNO
      *
     C                   CALLB     'DL2900'
     C                   PARM      *BLANK        PRTCD
     C                   PARM                    PDLNO
     C                   PARM      'A'           PBEAF
      *
     C     PRTCD         IFEQ      '*ERROR'
     C                   MOVEL     'DL2900'      DBFILE
     C                   MOVEL     '996'         DBASE
     C                   MOVEL     *BLANK        DBKEY
     C                   EXSR      *PSSR
     C                   END
     C**********         ENDIF                                                        CIR008 BUG6373
      *
     C                   ENDSR
      *****************************************************************                       CIR008
      /EJECT                                                                                  CIR008
      *****************************************************************                       CIR008
      *                                                               *                       CIR008
      * SrAuthorise - Authorise an IRS                                *                       CIR008
      *                                                               *                       CIR008
      *****************************************************************                       CIR008
     C     SrAuthorise   BEGSR                                                                CIR008
                                                                                              CIR008
      ** Access Deal                                                                          CIR008
                                                                                              CIR008
     C     RSDLNO        CHAIN     DEALSDGF                           89                      CIR008
                                                                                              CIR008
      ** Database Error                                                                       CIR008
                                                                                              CIR008
     C                   IF        *IN89 = *ON                                                CIR008
     C                   MOVE      RSDLNO        DBKEY                                        CIR008
     C                   EVAL      DBFILE = 'DEALSDG'                                         CIR008
     C                   EVAL      DBASE = 007                                                CIR008
     C                   EXSR      SRERR                                                      CIR008
     C                   END                                                                  CIR008
                                                                                              CIR008
      ** Set Confirmation required indicator to be written to DTRIX                           CIR008
                                                                                              CIR008
     C     FIDSTS        CASEQ     'C'           CNFINS                                       CIR008
     C     FIDSTS        CASEQ     'R'           CNFAMD                                       CIR008
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
     C                   PARM      *BLANK        RSCHTP                                       CIR008
                                                                                              CIR008
     C                   EVAL      CHTP = RSCHTP                                              CIR008
                                                                                              CIR008
      ** Authorise User                                                                       217684
     C*******************EVAL      FIUSRX = PsUser                                     217684BUG4646
     C                   EXSR      SrGetUser                                                 BUG4646
     C                   EVAL      FIUSRX = PUser                                            BUG4646
                                                                                              217684
      ** Last change date                                                                     CIR008
                                                                                              CIR008
     C                   Z-ADD     BJRDNB        LCD                                          CIR008
                                                                                              CIR008
      ** Set up "before" status of deal for on-line updates,                                  CIR008
      ** for Amends and Deletes                                                               CIR008
                                                                                              CIR008
     C**********         IF        RSCHTP = 'A' OR RSCHTP = 'R'                       CIR008 BUG6373
     C                   EVAL      Z#BSTS = IRVSIRS                                           CIR008
     C                   MOVE      RSDLNO        PDlNo                                        CIR008
                                                                                              CIR008
     C                   CALLB     'DL2900'                                                   CIR008
     C                   PARM      *BLANK        PRtCd                                        CIR008
     C                   PARM                    PDlNo                                        CIR008
     C                   PARM      'B'           PBeAf                                        CIR008
                                                                                              CIR008
     C                   IF        PRtCd = '*ERROR'                                           CIR008
     C                   EVAL      DBFILE = 'DL2900'                                          CIR008
     C                   EVAL      DBASE = 009                                                CIR008
     C                   EVAL      DBKEY = *BLANK                                             CIR008
     C                   EXSR      *PSSR                                                      CIR008
     C                   ENDIF                                                                CIR008
     C**********         ENDIF                                                        CIR008 BUG6373
                                                                                              CIR008
      **  Update Record                                                                       CIR008
                                                                                              CIR008
     C                   UPDATE    DEALSDGF                                                   CIR008
                                                                                              CIR008
      ** Set up "after" status of deal for on-line updates                                    CIR008
                                                                                              CIR008
     C                   EVAL      Z#ASTS = DEALS                                             CIR008
     C                   MOVE      RSDLNO        PDlNo                                        CIR008
                                                                                              CIR008
     C                   CALLB     'DL2900'                                                   CIR008
     C                   PARM      *BLANK        PRtCd                                        CIR008
     C                   PARM                    PDlNo                                        CIR008
     C                   PARM      'A'           PBeAf                                        CIR008
                                                                                              CIR008
     C                   IF        PRtCd = '*ERROR'                                           CIR008
     C                   EVAL      DBFILE = 'DL2900'                                          CIR008
     C                   EVAL      DBASE = 010                                                CIR008
     C                   EVAL      DBKEY = *BLANK                                             CIR008
     C                   EXSR      *PSSR                                                      CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
     C                   ENDSR                                                                CIR008
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* SETREQFLDI - SET UP REQUIRED FIELDS ON DEALSDG THAT WERE     *
     C*              NOT SET UP ON VALID FILE - INSERT PROCESSING    *
     C*                                                              *
     C****************************************************************
     C     SETREQFLDI    BEGSR
      *
      * Original Entry Date & Last Change Date
      *
     C                   Z-ADD     BJRDNB        ORED
     C                   Z-ADD     BJRDNB        LCD
      *
      * Hedge Indicator
      *
     C                   EXSR      ACSBOK
     C                   MOVE      BDHGIN        HEDIN
      *
      **  Our/Their effective interest rate
      *
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      FSUEFR = RSUEINR                                           CAS005
     C                   EVAL      FSUPAM = UPAMT                                             CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C     RSUBRTT       IFEQ      *ZEROS
     C                   Z-ADD     URTSP         UEINR
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      FSUEFR = URTSP                                             CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   END
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      FSTEFR = RSTEINR                                           CAS005
     C                   EVAL      FSTPAM = TPAMT                                             CAS005
     C                   ENDIF                                                                CAS005
      *
     C     RSTBRTT       IFEQ      *ZEROS
     C                   Z-ADD     TRTSP         TEINR
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      FSTEFR = TRTSP                                             CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   END
      *
      * Our Floating Rate Fix Days
      **Default*if*not*entered****
      * (Defaulting done in IRVRTFXDAY)
      *
     C     RSUBRTT       IFEQ      *ZEROS
      *
     C                   Z-ADD     0             UINFD
     C                   ELSE
      *
      * User pays Floating Rate, Counterparty pays Fixed Rate
     C*****RSUFRFD       IFEQ      *ZEROS
     C*****BJLCCY        IFEQ      BLCYCD
     C*****RSUCUCY       ANDEQ     BLCYCD
     C*******            Z-ADD     0             UFRFD
     C*******            ELSE
     C*******            Z-ADD     2             UFRFD
     C*******            END
     C*******            END
                                                                                              CIR011
      ** Our Foating Rate Fix Days will be adjusted if CIR011 is ON.                          CIR011
                                                                                              CIR011
     C     CIR011        IFEQ      'Y'                                                        CIR011
     C     RSUICFR       ANDNE     'O'                                                        CIR011
     C                   EXSR      ACSDCY                                                     CIR011
     C                   SUB       A6FXDY        UFRFD                                        CIR011
     C                   ENDIF                                                                CIR011
     C/COPY WNCPYSRC,IRSIRSDC11
      *
      **  Our interest fix date
      *
     C                   Z-ADD     VDAT          ZINDT
     C                   MOVE      UFRFD         ZRFDY
      *
      ** If 'currency for rate fix holiday' flag from FRA/IRS I.C.D.
      ** is 'F', 'L' or 'D', set currency code to 'sterling code',
      ** 'local currency code' or 'screen currency code' respectively
      *
     C     BQCRFH        IFEQ      'F'
     C                   MOVE      BLCYCD        ZCCY
     C                   ENDIF
      *
     C     BQCRFH        IFEQ      'L'
     C                   MOVE      BJLCCY        ZCCY
     C                   ENDIF
      *
     C     BQCRFH        IFEQ      'D'
     C     BQCRFH        OREQ      ' '
     C                   MOVE      RSUCUCY       ZCCY
     C                   ENDIF
     C*
     C                   MOVE      *BLANKS       ZLOC
      *                                                                         CIR005
      ** Use Rate Fixing Currencies to get rate fixing date when                CIR005
      ** CIR005 is on. Otherwise, use transaction ccy.                          CIR005
      *                                                                         CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C     RSC1R1        ANDNE     *BLANKS                                      CIR005
     C                   Z-ADD     ZRFDY         PRFDY             2 0          CIR005
     C                   CALLB     'IRRTFXCNV'                                  CIR005
     C                   PARM                    ZINDT                          CIR005
     C                   PARM                    PRFDY                          CIR005
     C                   PARM                    ZLOC                           CIR005
     C                   PARM                    RCCY                           CIR005
     C                   PARM                    ZRFDT                          CIR005
     C                   ELSE                                                   CIR005
     C                   EXSR      DLBACK
     C                   ENDIF                                                  CIR005
      *
      **  If deal forward-valued AND Short Term Rate NOT entered then
      **  the Next Interest Rate Fix Date must be that associated
      *   with the Value Date...
     C     ZRFDT         IFGE      BJRDNB
     C     RSUEINR       ANDEQ     *ZEROS
     C                   Z-ADD     ZRFDT         UINFD
      *
      **  ...else the Next Interest Rate Fix Date must be that
      **  associated with the Next Rate Change Date.
     C                   ELSE
     C     RSUNICD       IFNE      *ZEROS
     C                   Z-ADD     UNICD         ZINDT
     C                   MOVE      UFRFD         ZRFDY
      *
      ** If 'currency for rate fix holiday' flag from FRA/IRS I.C.D.
      ** is 'F', 'L' or 'D', set currency code to 'sterling code',
      ** 'local currency code' or 'screen currency code' respectively
      *
     C     BQCRFH        IFEQ      'F'
     C                   MOVE      BLCYCD        ZCCY
     C                   ENDIF
      *
     C     BQCRFH        IFEQ      'L'
     C                   MOVE      BJLCCY        ZCCY
     C                   ENDIF
      *
     C     BQCRFH        IFEQ      'D'
     C     BQCRFH        OREQ      ' '
     C                   MOVE      RSUCUCY       ZCCY
     C                   ENDIF
     C*
     C                   MOVE      *BLANKS       ZLOC
      *                                                                         CIR005
      ** Use Rate Fixing Currencies to get rate fixing date when                CIR005
      ** CIR005 is on. Otherwise, use transaction ccy.                          CIR005
      *                                                                         CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C     RSC1R1        ANDNE     *BLANKS                                      CIR005
     C                   Z-ADD     ZRFDY         PRFDY                          CIR005
     C                   CALLB     'IRRTFXCNV'                                  CIR005
     C                   PARM                    ZINDT                          CIR005
     C                   PARM                    PRFDY                          CIR005
     C                   PARM                    ZLOC                           CIR005
     C                   PARM                    RCCY                           CIR005
     C                   PARM                    ZRFDT                          CIR005
     C                   ELSE                                                   CIR005
     C                   EXSR      DLBACK
     C                   ENDIF                                                  CIR005
     C                   Z-ADD     ZRFDT         UINFD
     C                   ELSE
     C                   Z-ADD     0             UINFD
     C                   END
      *
     C                   END
      *
     C                   END
      *
      * Their Floating Rate Fix Days
      **Default*if*not*entered****
      * (Defaulting done in IRVRTFXDAY)
      *
      * User pays Fixed Rate, Counterparty pays Floating Rate
     C     RSTBRTT       IFEQ      *ZEROS

     C                   Z-ADD     0             TINFD
     C                   ELSE
      *
     C*****RSTFRFD       IFEQ      *ZEROS
     C*****BJLCCY        IFEQ      BLCYCD
     C*****RSUCUCY       ANDEQ     BLCYCD
     C*******            Z-ADD     0             TFRFD
     C*******            ELSE
     C*******            Z-ADD     2             TFRFD
     C*******            END
     C*******            END
                                                                                              CIR011
      ** Their Floating Rate Fix Days will be adjusted if CIR011 is ON.                       CIR011
                                                                                              CIR011
     C     CIR011        IFEQ      'Y'                                                        CIR011
     C     RSTICFR       ANDNE     'O'                                                        CIR011
     C                   EXSR      ACSDCY                                                     CIR011
     C                   SUB       A6FXDY        TFRFD                                        CIR011
     C                   ENDIF                                                                CIR011
     C/COPY WNCPYSRC,IRSIRSDC12
      *
      * User pays Fixed Rate, Counterparty pays Floating Rate
     C                   Z-ADD     VDAT          ZINDT
     C                   MOVE      TFRFD         ZRFDY
      *
      ** If 'currency for rate fix holiday' flag from FRA/IRS I.C.D.
      ** is 'F', 'L' or 'D', set currency code to 'sterling code',
      ** 'local currency code' or 'screen currency code' respectively
      *
     C     BQCRFH        IFEQ      'F'
     C                   MOVE      BLCYCD        ZCCY
     C                   ENDIF
      *
     C     BQCRFH        IFEQ      'L'
     C                   MOVE      BJLCCY        ZCCY
     C                   ENDIF
      *
     C     BQCRFH        IFEQ      'D'
     C     BQCRFH        OREQ      ' '
     C                   MOVE      RSUCUCY       ZCCY
     C                   ENDIF
     C*
     C                   MOVE      *BLANKS       ZLOC
      *                                                                         CIR005
      ** Use Rate Fixing Currencies to get rate fixing date when                CIR005
      ** CIR005 is on. Otherwise, use transaction ccy.                          CIR005
      *                                                                         CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C     RSC1R1        ANDNE     *BLANKS                                      CIR005
     C                   Z-ADD     ZRFDY         PRFDY                          CIR005
     C                   CALLB     'IRRTFXCNV'                                  CIR005
     C                   PARM                    ZINDT                          CIR005
     C                   PARM                    PRFDY                          CIR005
     C                   PARM                    ZLOC                           CIR005
     C                   PARM                    RCCY                           CIR005
     C                   PARM                    ZRFDT                          CIR005
     C                   ELSE                                                   CIR005
     C                   EXSR      DLBACK
     C                   ENDIF                                                  CIR005
      *
      **  If deal forward-valued AND Short Term Rate NOT entered then
      **  the Next Interest Rate Fix Date must be that associated
      *   with the Value Date...
     C     ZRFDT         IFGE      BJRDNB
     C     RSTEINR       ANDEQ     *ZEROS
     C                   Z-ADD     ZRFDT         TINFD
     C                   ELSE
      *
      **  ...else the Next Interest Rate Fix Date must be that
      **  associated with the Next Rate Change Date.
     C     RSTNICD       IFNE      *ZEROS
     C                   Z-ADD     TNICD         ZINDT
     C                   MOVE      TFRFD         ZRFDY
      *
      ** If 'currency for rate fix holiday' flag from FRA/IRS I.C.D.
      ** is 'F', 'L' or 'D', set currency code to 'sterling code',
      ** 'local currency code' or 'screen currency code' respectively
      *
     C     BQCRFH        IFEQ      'F'
     C                   MOVE      BLCYCD        ZCCY
     C                   ENDIF
      *
     C     BQCRFH        IFEQ      'L'
     C                   MOVE      BJLCCY        ZCCY
     C                   ENDIF
      *
     C     BQCRFH        IFEQ      'D'
     C     BQCRFH        OREQ      ' '
     C                   MOVE      RSUCUCY       ZCCY
     C                   ENDIF
     C*
     C                   MOVE      *BLANKS       ZLOC
      *                                                                         CIR005
      ** Use Rate Fixing Currencies to get rate fixing date when                CIR005
      ** CIR005 is on. Otherwise, use transaction ccy.                          CIR005
      *                                                                         CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C     RSC1R1        ANDNE     *BLANKS                                      CIR005
     C                   Z-ADD     ZRFDY         PRFDY                          CIR005
     C                   CALLB     'IRRTFXCNV'                                  CIR005
     C                   PARM                    ZINDT                          CIR005
     C                   PARM                    PRFDY                          CIR005
     C                   PARM                    ZLOC                           CIR005
     C                   PARM                    RCCY                           CIR005
     C                   PARM                    ZRFDT                          CIR005
     C                   ELSE                                                   CIR005
     C                   EXSR      DLBACK
     C                   ENDIF                                                  CIR005
     C                   Z-ADD     ZRFDT         TINFD
     C                   ELSE
     C                   Z-ADD     0             TINFD
     C                   END
      *
     C                   END
      *
     C                   END
      *
      * Start/Last Interest Payment Date
     C                   Z-ADD     VDAT          USLIP
     C                   Z-ADD     VDAT          TSLIP

      * Interest Rate Change Base Date
     C                   Z-ADD     UNICD         UICBD
     C                   Z-ADD     TNICD         TICBD
      *
      * Interest Payment Base Date
     C                   Z-ADD     UNIPD         UIPBD
     C                   Z-ADD     TNIPD         TIPBD
      *
      * Base Currency Exchange Rate
      * Default if not entered
      *
     C     RSUBCXR       IFEQ      *ZEROS
     C                   EXSR      ACSDCY
     C                   Z-ADD     A6SPRT        UBCXR
     C                   Z-ADD     A6SPRT        TBCXR
     C                   END
      *
      * Interest Accrual Control Date
     C                   Z-ADD     VDAT          UIACD
     C                   Z-ADD     VDAT          TIACD

      * Last Interest Payment/Change Date
     C     RSUBRTT       IFEQ      *ZEROS
     C                   Z-ADD     0             ULPCD
     C                   ELSE
     C                   Z-ADD     VDAT          ULPCD
     C                   END
      *
     C     RSTBRTT       IFEQ      *ZEROS
     C                   Z-ADD     0             TLPCD
     C                   ELSE
     C                   Z-ADD     VDAT          TLPCD
     C                   END
      *
      * Spread Indicators
     C     RSUBRTT       IFNE      *ZEROS
     C     RSURTSP       ANDNE     *ZEROS
     C     RSUSPIN       ANDEQ     *BLANK
     C                   MOVE      'A'           USPIN
     C                   END
      *
     C     RSTBRTT       IFNE      *ZEROS
     C     RSTRTSP       ANDNE     *ZEROS
     C     RSTSPIN       ANDEQ     *BLANK
     C                   MOVE      'A'           TSPIN
     C                   END

      * Our and Their original principal amount
     C                   Z-ADD     UPAMT         UOPAM
     C                   Z-ADD     TPAMT         TOPAM
      *
      **  Our and Their original base rate code
     C     RSUEINR       IFNE      *ZEROS
     C                   SELECT
     C     USPIN         WHENEQ    'A'
     C     UEINR         SUB       URTSP         UOBRT
      *
     C     USPIN         WHENEQ    ' '
     C                   Z-ADD     UEINR         UOBRT
      *
     C     USPIN         WHENEQ    'S'
     C     UEINR         ADD       URTSP         UOBRT
      *
     C     USPIN         WHENEQ    'P'
     C     100           MULT(H)   UEINR         NA117            11 7
     C     URTSP         ADD       100           NB117            11 7
     C     NA117         DIV(H)    NB117         UOBRT
     C                   ENDSL
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   IF        UOBRT >= 0                                                 CAS005
     C                   EVAL      FSUEFR = UOBRT                                             CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ELSE
     C                   Z-ADD     *ZEROS        UOBRT
     C                   ENDIF
      *
     C     RSTEINR       IFNE      *ZEROS
     C                   SELECT
     C     TSPIN         WHENEQ    'A'
     C     TEINR         SUB       TRTSP         TOBRT
      *
     C     TSPIN         WHENEQ    ' '
     C                   Z-ADD     TEINR         TOBRT
      *
     C     TSPIN         WHENEQ    'S'
     C     TEINR         ADD       TRTSP         TOBRT
      *
     C     TSPIN         WHENEQ    'P'
     C     100           MULT(H)   TEINR         NA117            11 7
     C     TRTSP         ADD       100           NB117            11 7
     C     NA117         DIV(H)    NB117         TOBRT
     C                   ENDSL
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   IF        TOBRT >= 0                                                 CAS005
     C                   EVAL      FSTEFR = TOBRT                                             CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ELSE
     C                   Z-ADD     *ZEROS        TOBRT
     C                   ENDIF
      *                                                                        CPL002
      * Our/Their Last Rate Change Date                                        CPL002
     C                   Z-ADD     VDAT          PLULRC                        CPL002
     C                   Z-ADD     VDAT          PLTLRC                        CPL002
      *
      * Non-Static Indicators
     C                   BITOFF    '01234567'    UDNSI
     C     RSUEINR       IFNE      *ZEROS
     C                   BITON     '0'           UDNSI
     C                   END
      *
     C                   BITOFF    '01234567'    TDNSI
     C     RSTEINR       IFNE      *ZEROS
     C                   BITON     '0'           TDNSI
     C                   END
                                                                                151240
      * INITIALIZE BIT SETTINGS                                                 151240
                                                                                151240
     C                   BITOFF    '01234567'    UDSTI                          151240
     C                   BITOFF    '01234567'    TDSTI                          151240
     C                   BITOFF    '01234567'    ACEI                           151240
     C                   BITOFF    '01234567'    TLXI                           151240
     C                   BITOFF    '01234567'    CNFI                           151240
      *
      * Machine Time
      *
     C                   TIME                    DDTM
      *
      * Base Rate Code for Sequencing
      *
     C                   Z-ADD     *ZEROS        BRSQ
      *
      ** Start Date Current Average Period                                                  BUG7217R
      *                                                                                     BUG7217R
     C     CIR006        IFEQ      'Y'                                                      BUG7217R
     C     SDCAR         ANDEQ     0                                                        BUG7217R
     C                   Z-ADD     VDAT          SDCAR                                      BUG7217R
     C                   ENDIF                                                              BUG7217R
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* SETREQFLDA - SET UP REQUIRED FIELDS ON DEALSDG THAT WERE     *
     C*              NOT SET UP ON VALID FILE - AMEND PROCESSING     *
     C*                                                              *
     C****************************************************************
     C     SETREQFLDA    BEGSR
      *
      **  Our/Their effective interest rate
      *
     C     RSUBRTT       IFEQ      *ZEROS
     C                   Z-ADD     URTSP         UEINR
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      FSUEFR = URTSP                                             CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ELSE
     C                   Z-ADD     RSUEINR       UEINR
                                                                                              228071
     C                   IF        CAS005 = 'Y'                                               228071
     C                   EVAL      FSUEFR = UEINR                                             228071
     C                   ENDIF                                                                228071
                                                                                              228071
     C                   END
      *                                                                         167793
      ** Retain negative value if original value of short term rate in          167793
      ** file is negative and the field was not amended.                        167793
      *                                                                         167793
     C     ##UEINR       IFLT      0                                            167793
     C                   Z-SUB     ##UEINR       WUEINR           11 7          167793
     C     WUEINR        IFEQ      UEINR                                        167793
     C                   MULT      -1            UEINR                          167793
     C                   ENDIF                                                  167793
     C                   ENDIF                                                  167793
      *                                                                         167793
      *
     C     RSTBRTT       IFEQ      *ZEROS
     C                   Z-ADD     TRTSP         TEINR
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      FSTEFR = TRTSP                                             CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ELSE
     C                   Z-ADD     RSTEINR       TEINR
                                                                                              228071
     C                   IF        CAS005 = 'Y'                                               228071
     C                   EVAL      FSTEFR = TEINR                                             228071
     C                   ENDIF                                                                228071
                                                                                              228071
     C                   END
      *                                                                         167793
      ** Retain negative value if original value of short term rate in          167793
      ** file is negative and the field was not amended.                        167793
      *                                                                         167793
     C     ##TEINR       IFLT      0                                            167793
     C                   Z-SUB     ##TEINR       WTEINR           11 7          167793
     C     WTEINR        IFEQ      TEINR                                        167793
     C                   MULT      -1            TEINR                          167793
     C                   ENDIF                                                  167793
     C                   ENDIF                                                  167793
      *
      * Our Floating Rate Fix Days
      **Default*if*not*entered*********
      * (Defaulting done in IRVRTFXDAY)
      *
     C     RSUBRTT       IFEQ      *ZEROS
      *
     C                   Z-ADD     0             UINFD
     C                   ELSE
      *
      * User pays Floating Rate, Counterparty pays Fixed Rate
      * Reset only, if Next Intr.Chg Date, or Rate Fix Days changed
      *
     C     RSUNICD       IFNE      ##UNICD                                                    227642
     C     RSUFRFD       ORNE      ##UFRFD                                                    227642
     C     RSUEINR       ORNE      ##UEINR                                                  BUG11266
     C     RSC1R1        ORNE      ##L1CYR1                                                   235490
     C     RSC2R1        ORNE      ##L1CYR2                                                   235490
     C     RSC3R1        ORNE      ##L1CYR3                                                   235490
     C     RSC4R1        ORNE      ##L1CYR4                                                   235490
     C     RSC5R1        ORNE      ##L1CYR5                                                   235490
     C     RSC6R1        ORNE      ##L1CYR6                                                   235490
     C     RSC7R1        ORNE      ##L1CYR7                                                   235490
     C     RSC8R1        ORNE      ##L1CYR8                                                   235490
     C     RSC9R1        ORNE      ##L1CYR9                                                   235490
     C     RSC0R1        ORNE      ##L1CYR0                                                   235490
      *                                                                                       227642
     C*****RSUNICD       IFNE      ##UNICD
     C*****RSUFRFD       ORNE      ##UFRFD
     C*****RSUEINR       ORNE      ##UEINR
      *
     C*****RSUFRFD       IFEQ      *ZEROS
     C*****BJLCCY        IFEQ      BLCYCD
     C*****RSUCUCY       ANDEQ     BLCYCD
     C*******            Z-ADD     0             UFRFD
     C*******            ELSE
     C*******            Z-ADD     2             UFRFD
     C*******            END
     C*******            END
      *
     C*******            END
      *                                                                                       TDA081
      ** Our Floating Rate Fix Days will be adjusted if CIR011 is ON.                         TDA081
      *                                                                                       TDA081
     C     CIR011        IFEQ      'Y'                                                        TDA081
     C     RSUICFR       ANDNE     'O'                                                        TDA081
     C                   EXSR      ACSDCY                                                     TDA081
     C                   SUB       A6FXDY        UFRFD                                        TDA081
     C                   ENDIF                                                                TDA081
      *
      **  Our interest fix date
      *
     C                   Z-ADD     VDAT          ZINDT
     C                   MOVE      UFRFD         ZRFDY
      *
      ** If 'currency for rate fix holiday' flag from FRA/IRS I.C.D.
      ** is 'F', 'L' or 'D', set currency code to 'sterling code',
      ** 'local currency code' or 'screen currency code' respectively
      *
     C     BQCRFH        IFEQ      'F'
     C                   MOVE      BLCYCD        ZCCY
     C                   ENDIF
      *
     C     BQCRFH        IFEQ      'L'
     C                   MOVE      BJLCCY        ZCCY
     C                   ENDIF
      *
     C     BQCRFH        IFEQ      'D'
     C     BQCRFH        OREQ      ' '
     C                   MOVE      RSUCUCY       ZCCY
     C                   ENDIF
     C*
     C                   MOVE      *BLANKS       ZLOC
      *                                                                         CIR005
      ** Use Rate Fixing Currencies to get rate fixing date when                CIR005
      ** CIR005 is on. Otherwise, use transaction ccy.                          CIR005
      *                                                                         CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C     RSC1R1        ANDNE     *BLANKS                                      CIR005
     C                   Z-ADD     ZRFDY         PRFDY                          CIR005
     C                   CALLB     'IRRTFXCNV'                                  CIR005
     C                   PARM                    ZINDT                          CIR005
     C                   PARM                    PRFDY                          CIR005
     C                   PARM                    ZLOC                           CIR005
     C                   PARM                    RCCY                           CIR005
     C                   PARM                    ZRFDT                          CIR005
     C                   ELSE                                                   CIR005
     C                   EXSR      DLBACK
     C                   ENDIF                                                  CIR005
      *
      **  If deal forward-valued AND Short Term Rate NOT entered then
      **  the Next Interest Rate Fix Date must be that associated
      *   with the Value Date...
     C     ZRFDT         IFGE      BJRDNB
     C     RSUEINR       ANDEQ     *ZEROS
     C                   Z-ADD     ZRFDT         UINFD
      *
      **  ...else the Next Interest Rate Fix Date must be that
      **  associated with the Next Rate Change Date.
     C                   ELSE
     C     RSUNICD       IFNE      *ZEROS
     C                   Z-ADD     UNICD         ZINDT
     C                   MOVE      UFRFD         ZRFDY
      *
      ** If 'currency for rate fix holiday' flag from FRA/IRS I.C.D.
      ** is 'F', 'L' or 'D', set currency code to 'sterling code',
      ** 'local currency code' or 'screen currency code' respectively
      *
     C     BQCRFH        IFEQ      'F'
     C                   MOVE      BLCYCD        ZCCY
     C                   ENDIF
      *
     C     BQCRFH        IFEQ      'L'
     C                   MOVE      BJLCCY        ZCCY
     C                   ENDIF
      *
     C     BQCRFH        IFEQ      'D'
     C     BQCRFH        OREQ      ' '
     C                   MOVE      RSUCUCY       ZCCY
     C                   ENDIF
     C*
     C                   MOVE      *BLANKS       ZLOC
      *                                                                         CIR005
      ** Use Rate Fixing Currencies to get rate fixing date when                CIR005
      ** CIR005 is on. Otherwise, use transaction ccy.                          CIR005
      *                                                                         CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C     RSC1R1        ANDNE     *BLANKS                                      CIR005
     C                   Z-ADD     ZRFDY         PRFDY                          CIR005
     C                   CALLB     'IRRTFXCNV'                                  CIR005
     C                   PARM                    ZINDT                          CIR005
     C                   PARM                    PRFDY                          CIR005
     C                   PARM                    ZLOC                           CIR005
     C                   PARM                    RCCY                           CIR005
     C                   PARM                    ZRFDT                          CIR005
     C                   ELSE                                                   CIR005
     C                   EXSR      DLBACK
     C                   ENDIF                                                  CIR005
     C                   Z-ADD     ZRFDT         UINFD
     C                   ELSE
     C                   Z-ADD     0             UINFD
     C                   END
      *
     C                   END
      *                                                                                       227642
     C                   END                                                                  227642
      *
     C                   END
      *
      * Their Floating Rate Fix Days
      **Default*if*not*entered********
      * (Defaulting done in IRVRTFXDAY)
      *
     C     RSTBRTT       IFEQ      *ZEROS

     C                   Z-ADD     0             TINFD
     C                   ELSE
      *
      * User pays Fixed Rate, Counterparty pays Floating Rate
      * Reset only, if Next Intr.Chg Date, or Rate Fix Days changed
      *
     C     RSTNICD       IFNE      ##TNICD                                                    227642
     C     RSTFRFD       ORNE      ##TFRFD                                                    227642
     C     RSTEINR       ORNE      ##TEINR                                                  BUG11266
     C     RSC1R1        ORNE      ##L1CYR1                                                   235490
     C     RSC2R1        ORNE      ##L1CYR2                                                   235490
     C     RSC3R1        ORNE      ##L1CYR3                                                   235490
     C     RSC4R1        ORNE      ##L1CYR4                                                   235490
     C     RSC5R1        ORNE      ##L1CYR5                                                   235490
     C     RSC6R1        ORNE      ##L1CYR6                                                   235490
     C     RSC7R1        ORNE      ##L1CYR7                                                   235490
     C     RSC8R1        ORNE      ##L1CYR8                                                   235490
     C     RSC9R1        ORNE      ##L1CYR9                                                   235490
     C     RSC0R1        ORNE      ##L1CYR0                                                   235490
      *                                                                                       227642
     C*****RSTNICD       IFNE      ##TNICD
     C*****RSTFRFD       ORNE      ##TFRFD
     C*****RSTEINR       ORNE      ##TEINR
      *
     C*****RSTFRFD       IFEQ      *ZEROS
     C*****BJLCCY        IFEQ      BLCYCD
     C*****RSUCUCY       ANDEQ     BLCYCD
     C*******            Z-ADD     0             TFRFD
     C*******            ELSE
     C*******            Z-ADD     2             TFRFD
     C*******            END
     C*******            END
      *
     C*******            END
      *
      *                                                                                       TDA081
      ** Their Floating Rate Fix Days will be adjusted if CIR011 is ON.                       TDA081
      *                                                                                       TDA081
     C     CIR011        IFEQ      'Y'                                                        TDA081
     C     RSTICFR       ANDNE     'O'                                                        TDA081
     C                   EXSR      ACSDCY                                                     TDA081
     C                   SUB       A6FXDY        TFRFD                                        TDA081
     C                   ENDIF                                                                TDA081
                                                                                              TDA081
     C                   Z-ADD     VDAT          ZINDT
     C                   MOVE      TFRFD         ZRFDY
      *
      ** If 'currency for rate fix holiday' flag from FRA/IRS I.C.D.
      ** is 'F', 'L' or 'D', set currency code to 'sterling code',
      ** 'local currency code' or 'screen currency code' respectively
      *
     C     BQCRFH        IFEQ      'F'
     C                   MOVE      BLCYCD        ZCCY
     C                   ENDIF
      *
     C     BQCRFH        IFEQ      'L'
     C                   MOVE      BJLCCY        ZCCY
     C                   ENDIF
      *
     C     BQCRFH        IFEQ      'D'
     C     BQCRFH        OREQ      ' '
     C                   MOVE      RSUCUCY       ZCCY
     C                   ENDIF
     C*
     C                   MOVE      *BLANKS       ZLOC
      *                                                                         CIR005
      ** Use Rate Fixing Currencies to get rate fixing date when                CIR005
      ** CIR005 is on. Otherwise, use transaction ccy.                          CIR005
      *                                                                         CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C     RSC1R1        ANDNE     *BLANKS                                      CIR005
     C                   Z-ADD     ZRFDY         PRFDY                          CIR005
     C                   CALLB     'IRRTFXCNV'                                  CIR005
     C                   PARM                    ZINDT                          CIR005
     C                   PARM                    PRFDY                          CIR005
     C                   PARM                    ZLOC                           CIR005
     C                   PARM                    RCCY                           CIR005
     C                   PARM                    ZRFDT                          CIR005
     C                   ELSE                                                   CIR005
     C                   EXSR      DLBACK
     C                   ENDIF                                                  CIR005
      *
      **  If deal forward-valued AND Short Term Rate NOT entered then
      **  the Next Interest Rate Fix Date must be that associated
      *   with the Value Date...
     C     ZRFDT         IFGE      BJRDNB
     C     RSTEINR       ANDEQ     *ZEROS
     C                   Z-ADD     ZRFDT         TINFD
     C                   ELSE
      *
      **  ...else the Next Interest Rate Fix Date must be that
      **  associated with the Next Rate Change Date.
     C     RSTNICD       IFNE      *ZEROS
     C                   Z-ADD     TNICD         ZINDT
     C                   MOVE      TFRFD         ZRFDY
      *
      ** If 'currency for rate fix holiday' flag from FRA/IRS I.C.D.
      ** is 'F', 'L' or 'D', set currency code to 'sterling code',
      ** 'local currency code' or 'screen currency code' respectively
      *
     C     BQCRFH        IFEQ      'F'
     C                   MOVE      BLCYCD        ZCCY
     C                   ENDIF
      *
     C     BQCRFH        IFEQ      'L'
     C                   MOVE      BJLCCY        ZCCY
     C                   ENDIF
      *
     C     BQCRFH        IFEQ      'D'
     C     BQCRFH        OREQ      ' '
     C                   MOVE      RSUCUCY       ZCCY
     C                   ENDIF
     C*
     C                   MOVE      *BLANKS       ZLOC
      *                                                                         CIR005
      ** Use Rate Fixing Currencies to get rate fixing date when                CIR005
      ** CIR005 is on. Otherwise, use transaction ccy.                          CIR005
      *                                                                         CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C     RSC1R1        ANDNE     *BLANKS                                      CIR005
     C                   Z-ADD     ZRFDY         PRFDY                          CIR005
     C                   CALLB     'IRRTFXCNV'                                  CIR005
     C                   PARM                    ZINDT                          CIR005
     C                   PARM                    PRFDY                          CIR005
     C                   PARM                    ZLOC                           CIR005
     C                   PARM                    RCCY                           CIR005
     C                   PARM                    ZRFDT                          CIR005
     C                   ELSE                                                   CIR005
     C                   EXSR      DLBACK
     C                   ENDIF                                                  CIR005
     C                   Z-ADD     ZRFDT         TINFD
     C                   ELSE
     C                   Z-ADD     0             TINFD
     C                   END
      *
     C                   END
      *
     C                   END                                                                  227642
      *                                                                                       227642
     C                   END
      *
      * Start/Last Interest Payment Date
     C**********         Z-ADD     VDAT          USLIP                                        184363
     C**********         Z-ADD     VDAT          TSLIP                                        184363

      * Interest Rate Change Base Date
     C                   Z-ADD     UNICD         UICBD
     C                   Z-ADD     TNICD         TICBD
      *
      * Interest Payment Base Date
     C                   Z-ADD     UNIPD         UIPBD
     C                   Z-ADD     TNIPD         TIPBD
      *                                                                         CIR005
      ** Business Day Conventions details (OUR)                                 CIR005
      *                                                                         CIR005
     C                   IF        CIR005 = 'Y'  AND                            CIR005
     C                             RSUNIPD = WUIPBD  AND                        CIR005
     C                             WL1AMC = 'A'  AND                            CIR005
     C                             RSAMC1 = WL1AMC  OR                          CIR005
     C                             CIR005 = 'Y'  AND                            CIR005
     C                             RSUNIPD = WUNIPD  AND                        CIR005
     C                             WL1AMC <> 'A'  AND                           CIR005
     C                             RSAMC1 = WL1AMC                              CIR005
      *                                                                         CIR005
     C                   EVAL      UIPBD = WUIPBD                               CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
      ** Business Day Conventions details (THEIR)                               CIR005
      *                                                                         CIR005
     C                   IF        CIR005 = 'Y'  AND                            CIR005
     C                             RSTNIPD = WTIPBD  AND                        CIR005
     C                             WL1AMC = 'A'  AND                            CIR005
     C                             RSAMC1 = WL1AMC  OR                          CIR005
     C                             CIR005 = 'Y'  AND                            CIR005
     C                             RSTNIPD = WTNIPD  AND                        CIR005
     C                             WL1AMC <> 'A'  AND                           CIR005
     C                             RSAMC1 = WL1AMC                              CIR005
      *                                                                         CIR005
     C                   EVAL      TIPBD = WTIPBD                               CIR005
     C                   ENDIF                                                  CIR005
      *
      * Base Currency Exchange Rate
      * Default if not entered
      *
     C     RSUBCXR       IFEQ      *ZEROS
     C                   EXSR      ACSDCY
     C                   Z-ADD     A6SPRT        UBCXR
     C                   Z-ADD     A6SPRT        TBCXR
     C                   END
      *
      * Spread Indicators
     C     RSUBRTT       IFNE      *ZEROS
     C     RSURTSP       ANDNE     *ZEROS
     C     RSUSPIN       ANDEQ     *BLANK
     C                   MOVE      'A'           USPIN
     C                   END
      *
     C     RSTBRTT       IFNE      *ZEROS
     C     RSTRTSP       ANDNE     *ZEROS
     C     RSTSPIN       ANDEQ     *BLANK
     C                   MOVE      'A'           TSPIN
     C                   END

      **  Our and Their original base rate code
     C     RSUEINR       IFNE      *ZEROS
     C     BJRDNB        ANDLE     VDAT
     C                   SELECT
     C     USPIN         WHENEQ    'A'
     C     UEINR         SUB       URTSP         UOBRT
      *
     C     USPIN         WHENEQ    ' '
     C                   Z-ADD     UEINR         UOBRT
      *
     C     USPIN         WHENEQ    'S'
     C     UEINR         ADD       URTSP         UOBRT
      *
     C     USPIN         WHENEQ    'P'
     C     100           MULT(H)   UEINR         NA117            11 7
     C     URTSP         ADD       100           NB117            11 7
     C     NA117         DIV(H)    NB117         UOBRT
     C                   ENDSL
      **********                                                                       CAS005 228071
     C**********         IF        CAS005 = 'Y'                                        CAS005 228071
     C**********         EVAL      FSUEFR = RSUEINR                                    CAS005 228071
     C**********         IF        UOBRT >= 0                                          CAS005 228071
     C**********         EVAL      FSUEFR = UOBRT                                      CAS005 228071
     C**********         ENDIF                                                         CAS005 228071
     C**********         ENDIF                                                         CAS005 228071
      **********                                                                       CAS005 228071

     C                   ENDIF
                                                                                              228071
     C                   IF        CAS005 = 'Y' AND                                           228071
     C                             RSUEINR <> 0                                               228071
     C                   SELECT                                                               228071
     C     USPIN         WHENEQ    'A'                                                        228071
     C     UEINR         SUB       URTSP         UBRATE           11 7                        228071
      *                                                                                       228071
     C     USPIN         WHENEQ    ' '                                                        228071
     C                   Z-ADD     UEINR         UBRATE                                       228071
      *                                                                                       228071
     C     USPIN         WHENEQ    'S'                                                        228071
     C     UEINR         ADD       URTSP         UBRATE                                       228071
      *                                                                                       228071
     C     USPIN         WHENEQ    'P'                                                        228071
     C     100           MULT(H)   UEINR         NA117                                        228071
     C     URTSP         ADD       100           NB117                                        228071
     C     NA117         DIV(H)    NB117         UBRATE                                       228071
     C                   ENDSL                                                                228071
                                                                                              228071
     C                   IF        UBRATE >= 0                                                228071
     C                   EVAL      FSUEFR = UBRATE                                            228071
     C                   ENDIF                                                                228071
                                                                                              228071
     C                   ENDIF                                                                228071
      *
     C     RSTEINR       IFNE      *ZEROS
     C     BJRDNB        ANDLE     VDAT
     C                   SELECT
     C     TSPIN         WHENEQ    'A'
     C     TEINR         SUB       TRTSP         TOBRT
      *
     C     TSPIN         WHENEQ    ' '
     C                   Z-ADD     TEINR         TOBRT
      *
     C     TSPIN         WHENEQ    'S'
     C     TEINR         ADD       TRTSP         TOBRT
      *
     C     TSPIN         WHENEQ    'P'
     C     100           MULT(H)   TEINR         NA117            11 7
     C     TRTSP         ADD       100           NB117            11 7
     C     NA117         DIV(H)    NB117         TOBRT
     C                   ENDSL
      **********                                                                       CAS005 228071
     C**********         IF        CAS005 = 'Y'                                        CAS005 228071
     C**********         EVAL      FSTEFR = RSTEINR                                    CAS005 228071
     C**********         IF        TOBRT >= 0                                          CAS005 228071
     C**********         EVAL      FSTEFR = TOBRT                                      CAS005 228071
     C**********         ENDIF                                                         CAS005 228071
     C**********         ENDIF                                                         CAS005 228071
      **********                                                                       CAS005 228071
     C                   ELSE
     C                   ENDIF
                                                                                              228071
     C                   IF        CAS005 = 'Y' AND                                           228071
     C                             RSTEINR <> 0                                               228071
     C                   SELECT                                                               228071
     C     TSPIN         WHENEQ    'A'                                                        228071
     C     TEINR         SUB       TRTSP         TBRATE           11 7                        228071
      *                                                                                       228071
     C     TSPIN         WHENEQ    ' '                                                        228071
     C                   Z-ADD     TEINR         TBRATE                                       228071
      *                                                                                       228071
     C     TSPIN         WHENEQ    'S'                                                        228071
     C     TEINR         ADD       TRTSP         TBRATE                                       228071
      *                                                                                       228071
     C     TSPIN         WHENEQ    'P'                                                        228071
     C     100           MULT(H)   TEINR         NA117                                        228071
     C     TRTSP         ADD       100           NB117                                        228071
     C     NA117         DIV(H)    NB117         TBRATE                                       228071
     C                   ENDSL                                                                228071
                                                                                              228071
     C                   IF        TBRATE >= 0                                                228071
     C                   EVAL      FSTEFR = TBRATE                                            228071
     C                   ENDIF                                                                228071
                                                                                              228071
     C                   ENDIF                                                                228071
      *
      * Non-Static Indicators
      *
      **  Our short term rate / initial rate set entered bits
      *
     C     RSUBRTT       IFNE      *ZEROS
     C     UEINR         ANDNE     ##UEINR
     C                   BITON     '02'          UDNSI
      *                                                                                       227642
     C     URFIN         IFEQ      'F'                                                        227642
     C                   EVAL      URFIN = 'B'                                                227642
     C                   ENDIF                                                                227642
      *                                                                                       227642
     C                   END
      *
      **  Their short term rate / initial rate set entered bits
      *
     C     RSTBRTT       IFNE      *ZEROS
     C     TEINR         ANDNE     ##TEINR
     C                   BITON     '02'          TDNSI
      *                                                                                       227642
     C     TRFIN         IFEQ      'F'                                                        227642
     C                   EVAL      TRFIN = 'B'                                                227642
     C                   ENDIF                                                                227642
      *                                                                                       227642
     C                   END
      **
      * Last Change Date & Last Change Type
      *
     C                   Z-ADD     BJRDNB        LCD
     C**********         MOVE      'A'           CHTP                                         CIR008
      *
      * Machine Time
      *
     C                   TIME                    DDTM
      *
      * Base Rate Code for Sequencing
      *
     C                   Z-ADD     *ZEROS        BRSQ
      *
     C                   IF        UINFD >= BJRDNB                                          MD036601
     C                             and UINFD <= UNICD                                       MD036601
     C                   MOVE      *BLANK        URFIN                                      MD036601
     C                   ENDIF                                                              MD036601
      *                                                                                     MD036601
     C                   IF        TINFD >= BJRDNB                                          MD036601
     C                             and TINFD <= TNICD                                       MD036601
     C                   MOVE      *BLANK        TRFIN                                      MD036601
     C                   ENDIF                                                              MD036601
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C*   SR: DLBACK - TO CALCULATE RATE FIX DATE FOR FRA/IRS         *
     C*                                                               *
     C*****************************************************************
     C     DLBACK        BEGSR                                                  ** DLBACK **
     C*
     C* INPUT FIELD ZLOC CONTAINS THE RELEVANT BRANCH LOCATION
     C*
     C**  Initialise Work Field
     C                   Z-ADD     ZINDT         ZINDT             5 0
     C                   Z-ADD     ZRFDY         ZRFDY             5 0
     C                   MOVE      ZCCY          ZCCY              3
     C                   Z-ADD     0             ZWKFLD            5 0
     C                   MOVE      ZLOC          ZLOC              3
     C**  Set Rate Fix Date equal to Input Date
     C                   Z-ADD     ZINDT         ZRFDT             5 0
     C*
     C**  Perform the following processing until the work field is
     C**  greater than or equal to the Rate Fix Days
     C     ZWKFLD        DOUGE     ZRFDY
     C*
     C**  If the Rate Fix Days are not equal to zero subtract 1
     C**  from the Rate Fix Date
     C     ZRFDY         IFNE      0
     C                   SUB       1             ZRFDT
     C                   END
     C*
     C*   The following is repeated until the resultant date is
     C*   proved to be a working day in the relevant currency and
     C*   location.
     C*   Uses ZCHKH to check Rate Fix Date for a holiday
     C*
     C     ZIND          DOUEQ     'W'                                          WORKING DAY
     C*
     C                   Z-ADD     ZRFDT         ZDAYNO
     C*
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    ZCCY
     C                   PARM                    ZLOC
     C                   PARM                    ZIND              1
     C*
     C* IF DATE IS A HOLIDAY (ZIND = 'H')
     C* SUBTRACT 1 FROM RATE FIX DATE
     C*
     C     ZIND          IFEQ      'H'
     C                   SUB       1             ZRFDT
     C                   END
     C                   END
     C*
     C**  When a working day has been found, add 1 to the Work Field
     C                   ADD       1             ZWKFLD
     C                   END
     C*
     C                   ENDSR
     C********************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* PYRCIN - DETERMINE PAY/RECEIVE INDICATORS                    *
     C*                                                              *
     C****************************************************************
     C     PYRCIN        BEGSR
      *
      * Indicators are '0' for IRSs.
     C                   Z-ADD     *ZERO         @@PRI1            1 0
     C                   Z-ADD     *ZERO         @@PRI2            1 0
     C                   Z-ADD     *ZERO         @@PRI3            1 0
      *
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CNFINS - SET CONFIRMATION INDICATOR ON INSERTION             *
     C*                                                              *
     C****************************************************************
     C     CNFINS        BEGSR
      *
     C                   MOVE      'N'           @@CNRQ            1
      *
      *
      * CONFIRMATION REQUIRED IF SETTLEMENT INSTRUCTIONS PRESENT
      * OR IF 2 LEVEL INPUT NOT PRESENT
      *
     C     RSRSTM        IFNE      *ZERO
     C     RSPSTM        ORNE      *ZERO
     C     BLL2II        OREQ      'N'
     C     CIR008        OREQ      'Y'                                                        213055
     C     RSCHTP        ANDEQ     'X'                                                        213055
     C     RSTM          ANDNE     *ZERO                                                      213055
     C     CIR008        OREQ      'Y'                                                        213055
     C     RSCHTP        ANDEQ     'X'                                                        213055
     C     PSTM          ANDNE     *ZERO                                                      213055
     C                   MOVE      'Y'           @@CNRQ
     C                   END
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CNFAMD - SET CONFIRMATION INDICATOR ON AMENDMENT             *
     C*                                                              *
     C****************************************************************
     C     CNFAMD        BEGSR
      *
     C                   MOVE      'N'           @@CNRQ                                       194487
      *                                                                                       194487
      * IF SETTLEMENT INSTRUCTIONS WERE PREVIOUSLY PRESENT
      * OR IF 2 LEVEL INPUT NOT PRESENT
      * OR IF ORIGINAL ENTRY DATE NOT EQUAL TO RUN DATE
      *
     C     RSTM          IFNE      *ZERO
     C     PSTM          ORNE      *ZERO
     C     RSRSTM        ORNE      *ZERO                                                      194487
     C     RSPSTM        ORNE      *ZERO                                                      194487
     C     BLL2II        OREQ      'N'
     C     ORED          ORNE      BJRDNB
      *
      ** If settlement instruction fields have changed
      *
     C     RSTM          IFNE      RSRSTM
     C     RONS          ORNE      RSRONS
     C     RIBN          ORNE      RSRIBN
     C     RIBA          ORNE      RSRIBA                                                     194487
     C     ROBN          ORNE      RSROBN                                                     194487
     C     ROCN          ORNE      RSROCN                                                     194487
     C     PSTM          ORNE      RSPSTM
     C     PONS          ORNE      RSPONS
     C     PIBN          ORNE      RSPIBN                                                     194487
     C     PIBA          ORNE      RSPIBA                                                     194487
     C     POBN          ORNE      RSPOBN                                                     194487
     C     POCN          ORNE      RSPOCN                                                     194487
     C     RCRN          ORNE      RSRCRN                                                     194487
     C     RCRA          ORNE      RSRCRA                                                     194487
     C     RVNO          ORNE      RSRVNO                                                     194487
     C     AWBN          ORNE      RSAWBN
     C     AWBA          ORNE      RSAWBA                                                     194487
     C     BENN          ORNE      RSBENN
     C     BENA          ORNE      RSBENA                                                     194487
     C     DTP1          ORNE      RSDTP1                                                     194487
     C     DTP2          ORNE      RSDTP2                                                     194487
     C     DTP3          ORNE      RSDTP3                                                     194487
     C     DTP4          ORNE      RSDTP4                                                     194487
     C     DCHG          ORNE      RSDCHG                                                     194487
     C     BTB1          ORNE      RSBTB1
     C     BTB2          ORNE      RSBTB2                                                     194487
     C     BTB3          ORNE      RSBTB3                                                     194487
     C     BTB4          ORNE      RSBTB4                                                     194487
     C     BTB5          ORNE      RSBTB5                                                     194487
     C     BTB6          ORNE      RSBTB6                                                     194487
     C     CVMR          ORNE      RSCVMR                                                     194487
     C     RSCY          ORNE      RSRSCY                                                     194487
     C     PSCY          ORNE      RSPSCY                                                     194487
     C     IC72          ORNE      RSIC72                                                     194487
      *
      ** or if Def. Sender-Receiver info has changed
     C     DSR1          ORNE      RSDSR1
     C     DSR2          ORNE      RSDSR2
     C     DSR3          ORNE      RSDSR3
     C     DSR4          ORNE      RSDSR4
     C     DSR5          ORNE      RSDSR5
     C     DSR6          ORNE      RSDSR6
      *
      ** or if the ISDA fields have changed                                     CSW097
      *                                                                         CSW097
     C     ISDA          ORNE      RSISDA                                       CSW097
     C     AGTY          ORNE      RSAGTY                                       CSW097
     C     AGDT          ORNE      RSAGDT                                       CSW097
     C     AGVC          ORNE      RSAGVC                                       CSW097
     C     AGVV          ORNE      RSAGVV                                       CSW097
      *                                                                         CSW097
      ** or if deal contract fields have changed
      *
     C*****NIDT          ORNE      IKNIPD
     C*****IPFR          ORNE      IKIPFQ
     C*****INTF          ORNE      IKIPDM
     C     VDAT          ORNE      RSVDAT                                                     194487
     C     MDAT          ORNE      RSMDAT                                                     194487
     C     USTRT         ORNE      RSUSTRT                                                    194487
     C*****UEINR         ORNE      RSUEINR                                             194487 227642
     C     UBRTE         ORNE      RSUBRTE                                                    194487
     C     URTSP         ORNE      RSURTSP                                                    194487
     C     UNICD         ORNE      RSUNICD                                                    194487
     C     UNIPD         ORNE      RSUNIPD                                                    194487
     C     UICFR         ORNE      RSUICFR                                                    194487
     C     UICFD         ORNE      RSUICFD                                                    194487
     C     UIPFR         ORNE      RSUIPFR                                                    194487
     C     UIPFD         ORNE      RSUIPFD                                                    194487
     C     TSTRT         ORNE      RSTSTRT                                                    194487
     C*****TEINR         ORNE      RSTEINR                                             194487 227642
     C     TBRTE         ORNE      RSTBRTE                                                    194487
     C     TRTSP         ORNE      RSTRTSP                                                    194487
     C     TNICD         ORNE      RSTNICD                                                    194487
     C     TNIPD         ORNE      RSTNIPD                                                    194487
     C     TICFR         ORNE      RSTICFR                                                    194487
     C     TICFD         ORNE      RSTICFD                                                    194487
     C     TIPFR         ORNE      RSTIPFR                                                    194487
     C     TIPFD         ORNE      RSTIPFD                                                    194487
     C     UNPCD         ORNE      RSUNPCD                                                  BUG6877R
     C     TNPCD         ORNE      RSTNPCD                                                  BUG6877R
     C     BOVD          ORNE      RSBOVD                                                    BUG7911
      *                                                                                      BUG6877
      ** if Reference Rate has changed                                                       BUG6877
      *                                                                                      BUG6877
     C     UBRTT         ORNE      RSUBRTT                                                   BUG6877
     C     TBRTT         ORNE      RSTBRTT                                                   BUG6877
      *
      ** Produce a confirmation now
      *
     C*****              BITOFF    '0'           CNFI                           CSW097
     C                   BITOFF    '0'           RSCNFI                         CSW097
      *                                                                                      BUG7911
      ** Only generate new MT360 during amend if BOVD is zero                                BUG7911
      *                                                                                      BUG7911
     C     BOVD          IFEQ      *ZEROS                                                    BUG7911
     C     RSBOVD        ANDEQ     *ZEROS                                                    BUG7911
     C     BOVD          ORNE      RSBOVD                                                    BUG7911
     C                   MOVE      'Y'           @@CNRQ
     C                   ENDIF                                                               BUG7911
      *                                                                                      BUG7911
      *                                                                                      BUG6877
      ** If any of the Settlement Instruction fields has changed, reset                      BUG6877
      ** bits 3 & 4 of TLXI field to allow regeneration of OUR/THEIR                         BUG6877
      ** Pay/Receive messages.                                                               BUG6877
      *                                                                                      BUG6877
     C     RSTM          IFNE      RSRSTM                                                    BUG8833
     C     RONS          ORNE      RSRONS                                                    BUG6877
     C     RIBN          ORNE      RSRIBN                                                    BUG6877
     C     RIBA          ORNE      RSRIBA                                                    BUG6877
     C     ROBN          ORNE      RSROBN                                                    BUG6877
     C     ROCN          ORNE      RSROCN                                                    BUG6877
     C     PSTM          ORNE      RSPSTM                                                    BUG6877
     C     PONS          ORNE      RSPONS                                                    BUG6877
     C     PIBN          ORNE      RSPIBN                                                    BUG6877
     C     PIBA          ORNE      RSPIBA                                                    BUG8833
     C     POBN          ORNE      RSPOBN                                                    BUG6877
     C     POCN          ORNE      RSPOCN                                                    BUG6877
     C     RCRN          ORNE      RSRCRN                                                    BUG6877
     C     RCRA          ORNE      RSRCRA                                                    BUG6877
     C     RVNO          ORNE      RSRVNO                                                    BUG6877
     C     AWBN          ORNE      RSAWBN                                                    BUG6877
     C     AWBA          ORNE      RSAWBA                                                    BUG6877
     C     BENN          ORNE      RSBENN                                                    BUG6877
     C     BENA          ORNE      RSBENA                                                    BUG6877
     C     DTP1          ORNE      RSDTP1                                                    BUG6877
     C     DTP2          ORNE      RSDTP2                                                    BUG6877
     C     DTP3          ORNE      RSDTP3                                                    BUG6877
     C     DTP4          ORNE      RSDTP4                                                    BUG6877
     C     DCHG          ORNE      RSDCHG                                                    BUG6877
     C     BTB1          ORNE      RSBTB1                                                    BUG6877
     C     BTB2          ORNE      RSBTB2                                                    BUG6877
     C     BTB3          ORNE      RSBTB3                                                    BUG6877
     C     BTB4          ORNE      RSBTB4                                                    BUG6877
     C     BTB5          ORNE      RSBTB5                                                    BUG6877
     C     BTB6          ORNE      RSBTB6                                                    BUG6877
     C     CVMR          ORNE      RSCVMR                                                    BUG6877
     C     RSCY          ORNE      RSRSCY                                                    BUG6877
     C     PSCY          ORNE      RSPSCY                                                    BUG6877
     C     IC72          ORNE      RSIC72                                                    BUG6877
      * Fields that if changed will affect generated messages                               BUG6877N
     C     USTRT         ORNE      RSUSTRT                                                  BUG6877N
     C     TSTRT         ORNE      RSTSTRT                                                  BUG6877N
     C     UNPCD         ORNE      RSUNPCD                                                  BUG6877N
     C     TNPCD         ORNE      RSTNPCD                                                  BUG6877N
     C     UNIPD         ORNE      RSUNIPD                                                  BUG6877N
     C     TNIPD         ORNE      RSTNIPD                                                  BUG6877N
     C     UEINR         ORNE      RSUEINR                                                  BUG6877N
     C     TEINR         ORNE      RSTEINR                                                  BUG6877N
     C                   BITOFF    '34'          RSTLXI                                      BUG6877
     C                   ENDIF                                                               BUG8833
      *
      * Set off maturity and interest indicators if past value date
      *
     C     ORED          IFLT      BJRDNB
     C     VDAT          ANDLT     BJRDNB
     C*****              BITOFF    '12'          CNFI                           CSW097
     C                   BITOFF    '12'          RSCNFI                         CSW097
     C                   END
      *
     C                   END
      *                                                                                      BUG6877
     C     CIR008        IFEQ      'Y'                                                       BUG6877
     C     FIAUTH        ANDNE     'Y'                                                       BUG6877
     C     BQFIRA        ANDEQ     'Y'                                                        239742
     C                   BITOFF    '0'           RSCNFI                                      BUG6877
     C                   BITOFF    '0'           CNFI                                        BUG6877
     C                   MOVE      'Y'           @@CNRQ                                      BUG6877
     C                   ENDIF                                                               BUG6877
      *                                                                                      BUG6877
     C                   END
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CNFDEL - SET CONFIRMATION INDICATOR ON DELETION              *
     C*                                                              *
     C****************************************************************
     C     CNFDEL        BEGSR
      *
     C                   MOVE      'N'           @@CNRQ                                       194487
      *                                                                                       194487
      * CONFIRMATION REQUIRED IF ONE PRODUCED PREVIOUSLY
      *
     C                   TESTB     '7'           CNFI                     99
     C     *IN99         IFEQ      '1'
     C                   BITOFF    '0'           CNFI
     C                   MOVE      'Y'           @@CNRQ
     C                   END
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* WRTDTX - WRITE A DTRIX RECORD                                *
     C*                                                              *
     C****************************************************************
     C     WRTDTX        BEGSR
      *
      **  SET FIELDS ON RECORD TO BE WRITTEN TO DTRIXDD
      *
     C                   MOVE      'D'           DXRECI
     C                   MOVE      'D'           DXRCDT
     C                   Z-ADD     RSDLNO        DXDLNO
     C                   Z-ADD     *ZERO         DXVDAT
     C                   Z-ADD     *ZERO         DXDASN
     C                   MOVE      RSCHTP        DXCHTP
     C                   MOVE      @@CNRQ        DXCNRQ
     C                   MOVE      'N'           DXCNPR
     C                   MOVE      ' '           DXREPR
     C                   TIME                    @XTIME
     C                   MOVE      @@PRI1        DXPRI1
     C                   MOVE      @@PRI2        DXPRI2
     C                   MOVE      @@PRI3        DXPRI3
     C                   Z-ADD     0             DXICIN
     C                   MOVEL     RSBRCA        DXBRCA
     C                   Z-ADD     *ZERO         DXTNLU
     C*
     C                   WRITE     DTRIXDF
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* UPDDTH - UPDATE THE DTRIX HEADER RECORD                      *
     C*                                                              *
     C****************************************************************
     C     UPDDTH        BEGSR
      *
      ** Access the header record
      *
     C                   Z-ADD     *ZERO         DXDLNO
     C     DXDLNO        CHAIN     DTRIXHF                            99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     DXDLNO        DBKEY
     C                   MOVEL     'DTRIXHF '    DBFILE                         ************
     C                   MOVEL     '004'         DBASE                          * DBERR 004*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
      * Add 1 to number of deal records (on DTRIXDD)
      *
     C                   ADD       1             DXNDLR
      *
     C                   UPDATE    DTRIXHF
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* UPDTRL- UPDATE THE DEALS FILE TRAILER                        *
     C*                                                              *
     C****************************************************************
     C     UPDTRL        BEGSR
      *
     C                   MOVE      *BLANKS       EAPIC            10                        MD025244
      *                                                                                     MD025244
     C                   CALLB     'ZADLTRLRUD'
      *
      ** Return Code
     C                   PARM      *BLANKS       @@RTCD            7
      *
      ** Change Type
     C                   PARM      RSCHTP        @@CHTP            1
      *
      ** Amount
     C                   PARM      RSUPAMT       @@AMNP           15 0
      *
      ** Run Date
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    EAPIC                                      MD025244
      *
      ** DATABASE ERROR
      *
     C     @@RTCD        IFEQ      '*ERROR '
     C                   MOVEL     '999999'      DBKEY
     C                   MOVEL     'DEALSDF '    DBFILE                         ************
     C                   MOVEL     '005'         DBASE                          * DBERR 005*
     C                   EXSR      SRERR                                        ************
     C                   END
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* UPDOLP- UPDATE THE ON-LINE POSITION FILES                    *
     C*                                                              *
     C****************************************************************
     C     UPDOLP        BEGSR
      *
      * Make sure overrides exist                                                             246966
     C                   Eval      QCMD = OVRDLPCSC                                           246966
     C                   Call      'QCMDEXC'                                                  246966
     C                   Parm                    QCMD            100                          246966
     C                   Parm      100           QCMDLEN          15 5                        246966
     C**********         CALL      'AOOUSWU0'                                                BUG6373
     C                   CALL      'AOOUSWU1'                                                BUG6373
     C                   PARM      *BLANK        ##RTCD            7
     C                   PARM                    Z#BSTS
     C                   PARM                    Z#ASTS
     C                   PARM                    Z#WSTS                                       CIR003
     C                   PARM                    Z#XSTS                                       CIR003
     C                   PARM                    Z#YSTS                                       CIR003
     C                   PARM                    Z#ZSTS                                       CIR003
      *
     C     ##RTCD        IFEQ      '*ERROR'
     C**********         MOVEL     'AOOUSWU0'    DBFILE                                      BUG6373
     C                   MOVEL     'AOOUSWU1'    DBFILE                                      BUG6373
     C                   MOVEL     '991'         DBASE
     C                   MOVEL     *BLANK        DBKEY
     C                   EXSR      *PSSR
     C                   END
     C/COPY WNCPYSRC,IRSIRSDC08
      *
      ** Data export for CCRM - Limits                                          CDE001
     C                   IF        CDE001 = 'Y'                                 CDE001
     C                   MOVEL     RSDLNO        T#TREF                         CDE001
     C                   CALLB     'DEWRTTRIG'                                  CDE001
     C**********         PARM                    T#TREF           20                   CDE001 CGL029
     C                   PARM                    T#TREF                                       CGL029
     C                   PARM      'SWAP'        T#TCAT            4            CDE001
     C                   PARM      *BLANKS       T#RSRV           10            CDE005
     C                   ENDIF                                                  CDE001
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* UPDSUP- SUMMARY UPDATES                                      *
     C*                                                              *
     C****************************************************************
     C     UPDSUP        BEGSR
      *
     C* SETUP DEAL NO.
     C*
     C                   MOVE      RSDLNO        @DLNUM
     C*
     C                   CALL      'DL1911'
     C                   PARM                    @TERM             1
     C                   PARM                    @DLNUM            6 0
     C                   PARM                    RSCHTP
     C                   PARM                    RSUCUCY
     C*
     C     @TERM         IFEQ      'E'
     C                   EXSR      *PSSR
     C                   END
     C*                                                                   S01408
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************          CAP004
     C*                                                              *          CAP004
     C* CLEARIRCS - Clear Interest Rate Calendar date records        *          CAP004
     C*                                                              *          CAP004
     C****************************************************************          CAP004
     C     CLEARIRCS     BEGSR                                                  CAP004
      *                                                                         CAP004
      ** Clear all dates for this transaction except those already              CAP004
      ** processed.                                                             CAP004
      *                                                                         CAP004
     C     KDTSC         SETLL     DLDTSCD0                                     CAP004
     C     KDTSC         READE     DLDTSCD0                               98    CAP004
      *                                                                         CAP004
     C     *IN98         DOWEQ     '0'                                          CAP004
     C                                                                          CAP004
     C     @DTPR         IFNE      'Y'                                          CAP004
     C     @DTPR         ANDNE     'y'                                          CAP004
     C                   DELETE    DLDTSCD0                                     CAP004
     C                   END                                                    CAP004
     C                                                                          CAP004
     C     KDTSC         READE     DLDTSCD0                               98    CAP004
     C                   END                                                    CAP004
                                                                                              CAP043
      ** Clear all dates for this transaction except those already                            CAP043
      ** processed (Cash Flow)                                                                CAP043
                                                                                              CAP043
     C                   IF        CAP043 = 'Y'                                               CAP043
     C     KDTSC         SETLL     DLCFSCD0                                                   CAP043
     C     KDTSC         READE     DLCFSCD0                               98                  CAP043
                                                                                              CAP043
     C     *IN98         DOWEQ     '0'                                                        CAP043
      *                                                                                       CAP043
     C     CFDTPR        IFNE      'Y'                                                        CAP043
     C     CFDTPR        ANDNE     'y'                                                        CAP043
     C                   DELETE    DLCFSCD0                                                   CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C     KDTSC         READE     DLCFSCD0                               98                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** Clear all dates for this transaction except those already                            CAP043
      ** processed (Principal Change)                                                         CAP043
                                                                                              CAP043
     C                   IF        CAP041 = 'Y'                                               CAP043
     C     KDTSC         SETLL     DLPCSCD0                                                   CAP043
     C     KDTSC         READE     DLPCSCD0                               98                  CAP043
                                                                                              CAP043
     C     *IN98         DOWEQ     '0'                                                        CAP043
     C                                                                                        CAP043
     C     PCDTPR        IFNE      'Y'                                                        CAP043
     C     PCDTPR        ANDNE     'y'                                                        CAP043
     C                   DELETE    DLPCSCD0                                                   CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C     KDTSC         READE     DLPCSCD0                               98                  CAP043
     C                   ENDDO                                                                CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
      *                                                                         CAP004
     C                   ENDSR                                                  CAP004
     C****************************************************************          CAP004
      /EJECT                                                                    CAP004
     C****************************************************************          CAP004
     C*                                                              *          CAP004
     C* WRITEIRCS - Write Interest Rate Calendar date records        *          CAP004
     C*                                                              *          CAP004
     C****************************************************************          CAP004
     C     WRITEIRCS     BEGSR                                                  CAP004
                                                                                              CAP043
      ** Update DLDTSCPD thru records in valids file IRVDTSCPD                                CAP043
                                                                                              CAP043
     C     KIRCList      SETLL     IRVDTSCL0                                                  CAP043
     C     KIRCList      READE     IRVDTSCL0                                                  CAP043
                                                                                              CAP043
     C                   DOW       NOT %EOF                                                   CAP043
                                                                                              CAP043
      ** Set up database fields                                                               CAP043
                                                                                              CAP043
     C                   EVAL      @DLNO = DLNO                                               CAP043
     C                   EVAL      @RCIP = RatPayInd                                          CAP043
     C                   EVAL      @OTIN = OurThrInd                                          CAP043
     C                   EVAL      @DTPR = *BLANK                                             CAP043
                                                                                              CAP043
     C                   SELECT                                                               CAP043
                                                                                              CAP043
      ** Our Rate Change Dates                                                                CAP043
                                                                                              CAP043
     C                   WHEN      (XOURTHR = 'U') AND (XRATPAY = 'R')                        CAP043
     C                   IF        UICFR = 'Z'                                                CAP043
     C                   EVAL      X = 1                                                      CAP043
                                                                                              CAP043
     C                   DOW       (X < 83) AND (InDate(X) <> 0)                              CAP043
     C                   Z-ADD     InDate(X)     @PRDT                                        CAP043
     C                   EVAL      @COHO = WDTSCConfH(X)                                      CAP043
     C                   WRITE     DLDTSCD0                                                   CAP043
     C                   EVAL      X = X + 1                                                  CAP043
     C                   ENDDO                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Our Interest Payment Dates                                                           CAP043
                                                                                              CAP043
     C                   WHEN      (XOURTHR = 'U') AND (XRATPAY = 'P')                        CAP043
     C                   IF        UIPFR = 'Z'                                                CAP043
     C                   EVAL      X = 1                                                      CAP043
                                                                                              CAP043
     C                   DOW       (X < 83) AND (InDate(X) <> 0)                              CAP043
     C                   Z-ADD     InDate(X)     @PRDT                                        CAP043
     C                   EVAL      @COHO = WDTSCConfH(X)                                      CAP043
     C                   WRITE     DLDTSCD0                                                   CAP043
     C                   EVAL      X = X + 1                                                  CAP043
     C                   ENDDO                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Their Rate Change Dates                                                              CAP043
                                                                                              CAP043
     C                   WHEN      (XOURTHR = 'T') AND (XRATPAY = 'R')                        CAP043
     C                   IF        TICFR = 'Z'                                                CAP043
     C                   EVAL      X = 1                                                      CAP043
                                                                                              CAP043
     C                   DOW       (X < 83) AND (InDate(X) <> 0)                              CAP043
     C                   Z-ADD     InDate(X)     @PRDT                                        CAP043
     C                   EVAL      @COHO = WDTSCConfH(X)                                      CAP043
     C                   WRITE     DLDTSCD0                                                   CAP043
     C                   EVAL      X = X + 1                                                  CAP043
     C                   ENDDO                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Their Interest Payment Dates                                                         CAP043
                                                                                              CAP043
     C                   WHEN      (XOURTHR = 'T') AND (XRATPAY = 'P')                        CAP043
     C                   IF        TIPFR = 'Z'                                                CAP043
     C                   EVAL      X = 1                                                      CAP043
                                                                                              CAP043
     C                   DOW       (X < 83) AND (InDate(X) <> 0)                              CAP043
     C                   Z-ADD     InDate(X)     @PRDT                                        CAP043
     C                   EVAL      @COHO = WDTSCConfH(X)                                      CAP043
     C                   WRITE     DLDTSCD0                                                   CAP043
     C                   EVAL      X = X + 1                                                  CAP043
     C                   ENDDO                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDSL                                                                CAP043
                                                                                              CAP043
     C     KIRCList      READE     IRVDTSCL0                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** Update DLCFSCPD thru records in valids file IRVCFSCPD                                CAP043
      ** only when CAP043 is on                                                               CAP043
                                                                                              CAP043
     C                   IF        CAP043 = 'Y'                                               CAP043
     C     KIRCList      SETLL     IRVCFSCL0                                                  CAP043
     C     KIRCList      READE     IRVCFSCL0                                                  CAP043
                                                                                              CAP043
     C                   DOW       NOT %EOF                                                   CAP043
                                                                                              CAP043
      ** Set up database fields                                                               CAP043
                                                                                              CAP043
     C                   EVAL      CFDLNO = DLNO                                              CAP043
     C                   EVAL      CFOTIN = CVXOURTHR                                         CAP043
     C                   EVAL      CFDTPR = *BLANK                                            CAP043
                                                                                              CAP043
     C                   SELECT                                                               CAP043
                                                                                              CAP043
      ** Our Cash Flow Schedule                                                               CAP043
                                                                                              CAP043
     C                   WHEN      (CVXOURTHR = 'U')                                          CAP043
     C                   IF        UIPFR = 'C'                                                CAP043
     C                   EVAL      X = 1                                                      CAP043
                                                                                              CAP043
     C                   DOW       (X < 83) AND (WCashFlwD(X) <> 0)                           CAP043
     C                   Z-ADD     WCashFlwD(X)  CFPRDT                                       CAP043
     C                   Z-ADD     WCashFlwA(X)  CFCFLA                                       CAP043
     C                   EVAL      CFCOHO = WCFSCConfH(X)                                     CAP043
     C                   WRITE     DLCFSCD0                                                   CAP043
     C                   EVAL      X = X + 1                                                  CAP043
     C                   ENDDO                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
      ** Their Cash Flow Schedule                                                             CAP043
                                                                                              CAP043
     C                   WHEN      (CVXOURTHR = 'T')                                          CAP043
     C                   IF        TIPFR = 'C'                                                CAP043
     C                   EVAL      X = 1                                                      CAP043
                                                                                              CAP043
     C                   DOW       (X < 83) AND (WCashFlwD(X) <> 0)                           CAP043
     C                   Z-ADD     WCashFlwD(X)  CFPRDT                                       CAP043
     C                   Z-ADD     WCashFlwA(X)  CFCFLA                                       CAP043
     C                   EVAL      CFCOHO = WCFSCConfH(X)                                     CAP043
     C                   WRITE     DLCFSCD0                                                   CAP043
     C                   EVAL      X = X + 1                                                  CAP043
     C                   ENDDO                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDSL                                                                CAP043
                                                                                              CAP043
     C     KIRCList      READE     IRVCFSCL0                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
      ** Update DLPCSCPD thru records in valids file IRVPCSCPD                                CAP043
      ** only when CAP041 is on                                                               CAP043
                                                                                              CAP043
     C                   IF        CAP041 = 'Y'                                               CAP043
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
     C                   SELECT                                                               CAP043
                                                                                              CAP043
      ** Our Principal Change Schedule                                                        CAP043
                                                                                              CAP043
     C                   WHEN      (PVYOURTHR = ' ')                                          CAP043
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
     C**********         IF        BGN2ST = 'Y'                                      CAP043 MD054117
     C                   IF        PCIDCF = 'Y'                                             MD054117
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
     C                   EVAL      PCPAMT = RSUPAMT + WPAMT                                   CAP043
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
     C                   EVAL      PCPAMT = RSUPAMT + WPAMT                                   CAP043
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
     C**********         IF        BGN2ST = 'Y'                                      CAP043 MD054117
     C                   IF        PCIDCF = 'Y'                                             MD054117
     C                   EXSR      SRUpdPCSC                                                  CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   EVAL      X = X + 1                                                  CAP043
     C                   ENDDO                                                                CAP043
                                                                                              CAP043
     C                   ENDSL                                                                CAP043
                                                                                              CAP043
     C     KIRCList      READE     IRVPCSCL0                                                  CAP043
     C                   ENDDO                                                                CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
      **********                                                                       CAP004 CAP043
      ***Our*Rate Change Dates                                                         CAP004 CAP043
     C**********         IF        UICFR = 'Z'                                         199835 CAP043
     C**********         CLEAR                   IRCDates                              CAP004 CAP043
     C**********         Z-ADD     1             X                                     CAP004 CAP043
     C**********         MOVE      OurRatChgs    DatAlp                                CAP004 CAP043
     C**********         MOVE      DLNO          @DLNO                                 CAP004 CAP043
     C**********         MOVE      RatPayInd     @RCIP                                 CAP004 CAP043
     C**********         MOVE      OurThrInd     @OTIN                                 CAP004 CAP043
     C**********         MOVE      *BLANKS       @COHO                                 CAP004 CAP043
     C**********         MOVE      *BLANKS       @DTPR                                 CAP004 CAP043
     C**********                                                                       CAP004 CAP043
     C*****X****         DOWLT     83                                                  CAP004 CAP043
     C*****InDate(X)     ANDNE     *ZEROS                                              CAP004 CAP043
     C**********         Z-ADD     InDate(X)     @PRDT                                 CAP004 CAP043
     C**********         WRITE     DLDTSCD0                                            CAP004 CAP043
     C**********         ADD       1             X                                     CAP004 CAP043
     C**********         END                                                           CAP004 CAP043
     C**********         ENDIF                                                         199835 CAP043
      **********                                                                       CAP004 CAP043
      ***Our*Interest Payment Dates                                                    CAP004 CAP043
      **********                                                                       CAP004 CAP043
     C**********         IF        UIPFR = 'Z'                                         199835 CAP043
     C**********         CLEAR                   IRCDates                              CAP004 CAP043
     C**********         Z-ADD     1             X                                     CAP004 CAP043
     C**********         MOVE      OurPayDats    DatAlp                                CAP004 CAP043
     C**********         MOVE      DLNO          @DLNO                                 CAP004 CAP043
     C**********         MOVE      RatPayInd     @RCIP                                 CAP004 CAP043
     C**********         MOVE      OurThrInd     @OTIN                                 CAP004 CAP043
     C**********         MOVE      *BLANKS       @COHO                                 CAP004 CAP043
     C**********         MOVE      *BLANKS       @DTPR                                 CAP004 CAP043
     C**********                                                                       CAP004 CAP043
     C*****X****         DOWLT     83                                                  CAP004 CAP043
     C*****InDate(X)     ANDNE     *ZEROS                                              CAP004 CAP043
     C**********         Z-ADD     InDate(X)     @PRDT                                 CAP004 CAP043
     C**********         WRITE     DLDTSCD0                                            CAP004 CAP043
     C**********         ADD       1             X                                     CAP004 CAP043
     C**********         END                                                           CAP004 CAP043
     C**********         ENDIF                                                         199835 CAP043
      **********                                                                       CAP004 CAP043
      ***Their*Rate Change Dates                                                       CAP004 CAP043
      **********                                                                       CAP004 CAP043
     C**********         IF        TICFR = 'Z'                                         199835 CAP043
     C**********         CLEAR                   IRCDates                              CAP004 CAP043
     C**********         Z-ADD     1             X                                     CAP004 CAP043
     C**********         MOVE      ThrRatChgs    DatAlp                                CAP004 CAP043
     C**********         MOVE      DLNO          @DLNO                                 CAP004 CAP043
     C**********         MOVE      RatPayInd     @RCIP                                 CAP004 CAP043
     C**********         MOVE      OurThrInd     @OTIN                                 CAP004 CAP043
     C**********         MOVE      *BLANKS       @COHO                                 CAP004 CAP043
     C**********         MOVE      *BLANKS       @DTPR                                 CAP004 CAP043
     C**********                                                                       CAP004 CAP043
     C*****X****         DOWLT     83                                                  CAP004 CAP043
     C*****InDate(X)     ANDNE     *ZEROS                                              CAP004 CAP043
     C**********         Z-ADD     InDate(X)     @PRDT                                 CAP004 CAP043
     C**********         WRITE     DLDTSCD0                                            CAP004 CAP043
     C**********         ADD       1             X                                     CAP004 CAP043
     C**********         END                                                           CAP004 CAP043
     C**********         ENDIF                                                         199835 CAP043
      **********                                                                       CAP004 CAP043
      ***Their*Interest Payment Dates                                                  CAP004 CAP043
      **********                                                                       CAP004 CAP043
     C**********         IF        TIPFR = 'Z'                                         199835 CAP043
     C**********         CLEAR                   IRCDates                              CAP004 CAP043
     C**********         Z-ADD     1             X                                     CAP004 CAP043
     C**********         MOVE      ThrPayDats    DatAlp                                CAP004 CAP043
     C**********         MOVE      DLNO          @DLNO                                 CAP004 CAP043
     C**********         MOVE      RatPayInd     @RCIP                                 CAP004 CAP043
     C**********         MOVE      OurThrInd     @OTIN                                 CAP004 CAP043
     C**********         MOVE      *BLANKS       @COHO                                 CAP004 CAP043
     C**********         MOVE      *BLANKS       @DTPR                                 CAP004 CAP043
     C**********                                                                       CAP004 CAP043
     C*****X****         DOWLT     83                                                  CAP004 CAP043
     C*****InDate(X)     ANDNE     *ZEROS                                              CAP004 CAP043
     C**********         Z-ADD     InDate(X)     @PRDT                                 CAP004 CAP043
     C**********         WRITE     DLDTSCD0                                            CAP004 CAP043
     C**********         ADD       1             X                                     CAP004 CAP043
     C**********         END                                                           CAP004 CAP043
     C**********         ENDIF                                                         199835 CAP043
      **********                                                                       CAP004 CAP043
     C                   ENDSR                                                  CAP004
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
     C                   IF        (RSUNPCD <> *ZERO) AND (PVYOURTHR = 'U')                   CAP043
     C                   EVAL      WCTLDYN = RSUNPCD                                          CAP043
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
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* ACSBOK - ACCESS BOOK DETAILS                                 *
     C*                                                              *
     C****************************************************************
     C     ACSBOK        BEGSR
      *
      ** Access book record to pick up Hedge indicator
      *
     C                   CALLB     'AOBOOKR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      RSBOKC        @BOKC             2
     C     SDBOOK        PARM      SDBOOK        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @DSNB         DBKEY
     C                   MOVEL     'SDBOOKPD'    DBFILE                         ************
     C                   MOVEL     '006'         DBASE                          * DBERR 006*
     C                   EXSR      SRERR                                        ************
     C                   END
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* ACSBRN - ACCESS BRANCH DETAILS                               *
     C*                                                              *
     C****************************************************************
     C     ACSBRN        BEGSR
      *
      ** Access branch record to pick up branch internal
      ** customer number.
      *
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      RSBRCA        @DSNB             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @DSNB         DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE                         ************
     C                   MOVEL     '006'         DBASE                          * DBERR 006*
     C                   EXSR      SRERR                                        ************
     C                   END
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* ACSDCY - ACCESS DEAL CURRENCY DETAILS                        *
     C*                                                              *
     C****************************************************************
     C     ACSDCY        BEGSR
      *
      ** Access currency details using deal currency.
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      RSUCUCY       @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @AJCD         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE                         ************
     C                   MOVEL     '008'         DBASE                          * DBERR 008*
     C                   EXSR      SRERR                                        ************
     C                   END
     C                   ENDSR
     C****************************************************************
      /EJECT
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRWatch - Initiates the Midas Compliance Engine.              *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRWatch       BEGSR                                                                CSD015
      *                                                                                       CSD015
      ** Initialise the Transaction Details Parameter                                         CSD015
      ** ============================================                                         CSD015
      *                                                                                       CSD015
     C                   CLEAR                   SDWLTD                                       CSD015
      *                                                                                       CSD015
      ** Item Type, Identifier, and Branch information.                                       CSD015
      *                                                                                       CSD015
     C                   MOVEL     'IRRS'        W4ITEM                                       CSD015
     C                   MOVEL     DLNO          W4IDEN                                       CSD015
     C                   MOVEL     BRCA          W4BRCH                                       CSD015
      *                                                                                       CSD015
      ** Select the System Prefix.                                                            CSD015
      *                                                                                       CSD015
     C                   IF        CSC011 = 'Y'                                               CSD015
     C                   EVAL      W4SYSM = S1MAIN                                            CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4SYSM = LIBR                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   MOVEL     'DEALSDG'     W4FUNT                                       CSD015
      *                                                                                       CSD015
      ** Get the Counter Party Detail.                                                        CSD015
      *                                                                                       CSD015
     C                   EXSR      SRGetCtrpDet                                               CSD015
     C                   MOVEL     CNUM          W4CNUM                                       CSD015
     C                   MOVEL     WCtrpTyp      W4CTYP                                       CSD015
     C                   MOVEL     WCtrpRpt      W4CUST                                       CSD015
      *                                                                                       CSD015
      ** Get the Deal Date.                                                                   CSD015
      *                                                                                       CSD015
     C                   MOVEL     DDAT          PZADayNo                                     CSD015
     C                   EXSR      SRDateToDDT                                                CSD015
     C                   EVAL      W4DDAT = WDDT                                              CSD015
      *                                                                                       CSD015
      ** Get the Value Date.                                                                  CSD015
      *                                                                                       CSD015
     C                   MOVEL     VDAT          PZADayNo                                     CSD015
     C                   EXSR      SRDateToDDT                                                CSD015
     C                   EVAL      W4VDAT = WDDT                                              CSD015
      *                                                                                       CSD015
      ** Get the Maturity Date.                                                               CSD015
      *                                                                                       CSD015
     C                   MOVEL     MDAT          PZADayNo                                     CSD015
     C                   EXSR      SRDateToDDT                                                CSD015
     C                   EVAL      W4MDAT = WDDT                                              CSD015
      *                                                                                       CSD015
      ** Currency and Amount information.                                                     CSD015
      *                                                                                       CSD015
     C                   MOVEL     UCUCY         W4DEN1                                       CSD015
     C                   MOVEL     UCUCY         PZACcy                                       CSD015
     C                   MOVE      *BLANKS       PZANtvAmt                                    CSD015
     C                   MOVE      UPAMT         PZANtvAmt                                    CSD015
     C                   EXSR      SRAmtToNum                                                 CSD015
     C                   EVAL      W4AMT1 = WAMT                                              CSD015
      *                                                                                       CSD015
      ** Build the Free Format String                                                         CSD015
      ** ============================                                                         CSD015
      *                                                                                       CSD015
      ** Initialise additional standing data.                                                 CSD015
      *                                                                                       CSD015
     C                   MOVEA     *BLANKS       WLFSD                                        CSD015
     C                   MOVEL     RIBA          WLFSD(2)                                     CSD015
     C                   MOVEL     PIBA          WLFSD(6)                                     CSD015
     C                   MOVEL     RCRA          WLFSD(9)                                     CSD015
     C                   MOVEL     AWBA          WLFSD(11)                                    CSD015
     C                   MOVEL     BENA          WLFSD(12)                                    CSD015
      *                                                                                       CSD015
      ** Begin string and packet assembly.                                                    CSD015
      *                                                                                       CSD015
     C                   EVAL      Ctr = 1                                                    CSD015
     C                   EVAL      PFreeFmtStr = *BLANKS                                      CSD015
     C                   EVAL      WXMLPacket = *BLANKS                                       CSD015
     C                   EVAL      WData = *BLANKS                                            CSD015
     C                   EVAL      WCcy = *BLANKS                                             CSD015
      *                                                                                       CSD015
     C                   DOU       Ctr = ArrMax                                               CSD015
      *                                                                                       CSD015
     C                   IF        WLF(Ctr) <> *BLANKS                                        CSD015
      *                                                                                       CSD015
      ** Select the currency for nostro fields.                                               CSD015
      *                                                                                       CSD015
     C                   IF        Ctr = 1                                                    CSD015
     C                   IF        PSCY <> *BLANKS                                            CSD015
     C                   EVAL      WCcy = PSCY                                                CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      WCcy = UCUCY                                               CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        Ctr = 5                                                    CSD015
     C                   IF        RSCY <> *BLANKS                                            CSD015
     C                   EVAL      WCcy = RSCY                                                CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      WCcy = TCUCY                                               CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      ** Call the detail retriever program.                                                   CSD015
      *                                                                                       CSD015
     C                   CALL      'SDCWLFMT'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM                    WLF(Ctr)                                     CSD015
     C                   PARM      *BLANKS       PInpA                                        CSD015
     C                   PARM      *BLANKS       PInpB                                        CSD015
     C                   PARM      *BLANKS       PInpC                                        CSD015
     C                   PARM      *BLANKS       PInpD                                        CSD015
     C                   PARM      *BLANKS       PInpE                                        CSD015
     C                   PARM                    WCcy                                         CSD015
     C                   PARM                    WData                                        CSD015
     C                   PARM                    POutA                                        CSD015
      *                                                                                       CSD015
     C                   IF        WData <> *BLANKS AND                                       CSD015
     C                             %CHECK('0 ':WData) <> 0 AND                                CSD015
     C                             @RtCd = *BLANKS                                            CSD015
     C                   CAT       XOT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       WData:0       WXMLPacket                                   CSD015
     C                   CAT       WLFSD(Ctr):1  WXMLPacket                                   CSD015
     C                   CAT       XCT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       WXMLPacket:0  PFreeFmtStr                                  CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   EVAL      WXMLPacket = *BLANKS                                       CSD015
     C                   EVAL      WData = *BLANKS                                            CSD015
     C                   EVAL      WCcy = *BLANKS                                             CSD015
      *                                                                                       CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   EVAL      Ctr = Ctr + 1                                              CSD015
      *                                                                                       CSD015
     C                   ENDDO                                                                CSD015
      *                                                                                       CSD015
      ** Add the Payment Details.                                                             CSD015
      *                                                                                       CSD015
     C                   IF        DTP1 <> *BLANKS OR                                         CSD015
     C                             DTP2 <> *BLANKS OR                                         CSD015
     C                             DTP3 <> *BLANKS OR                                         CSD015
     C                             DTP4 <> *BLANKS                                            CSD015
      *                                                                                       CSD015
     C                   CAT       XOT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       DTP1:0        WXMLPacket                                   CSD015
     C                   CAT       DTP2:1        WXMLPacket                                   CSD015
     C                   CAT       DTP3:1        WXMLPacket                                   CSD015
     C                   CAT       DTP4:1        WXMLPacket                                   CSD015
     C                   CAT       XCT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       WXMLPacket:0  PFreeFmtStr                                  CSD015
      *                                                                                       CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      ** Check for compliance.                                                                CSD015
      *                                                                                       CSD015
     C                   IF        PFreeFmtStr <> *BLANKS                                     CSD015
     C                   CALL      'SDCWLCHK'                                                 CSD015
     C                   PARM                    SDWLTD                                       CSD015
     C                   PARM                    PFreeFmtStr                                  CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRCompChk - Handles the entire compliance chkng. activities.  *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRCompChk     BEGSR                                                                CSD015
      *                                                                                       CSD015
     C                   SELECT                                                               CSD015
      *                                                                                       CSD015
      ** Execute a direct compliance check on insert operations.                              CSD015
      *                                                                                       CSD015
     C                   WHEN      WCompMode = OnInsert                                       CSD015
      *                                                                                       CSD015
     C                   EVAL      WMoveMode = ALL                                            CSD015
     C                   EXSR      SRDBFsToWLFs                                               CSD015
     C                   EXSR      SRWLFChk                                                   CSD015
      *                                                                                       CSD015
     C                   IF        WOKFlg = 'Y'                                               CSD015
     C                   EXSR      SRWatch                                                    CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      ** If the action associated with the current record is Amend,                           CSD015
      ** check first if this record has been analysed by the CE.                              CSD015
      *                                                                                       CSD015
     C                   WHEN      WCompMode = OnAmend                                        CSD015
      *                                                                                       CSD015
     C                   EXSR      SRRetryChk                                                 CSD015
      *                                                                                       CSD015
     C                   IF        WRetryFlg = 'Y'                                            CSD015
     C                   EVAL      WMoveMode = ALL                                            CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      WMoveMode = CHANGED                                        CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   EXSR      SRDBFsToWLFs                                               CSD015
     C                   EXSR      SRWLFChk                                                   CSD015
      *                                                                                       CSD015
     C                   IF        (WOKFlg = 'Y' AND                                          CSD015
     C                             WChgFlg = 'Y') OR                                          CSD015
     C                             WRetryFlg = 'Y'                                            CSD015
     C                   EXSR      SRWatch                                                    CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDSL                                                                CSD015
      *                                                                                       CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRDBFsToWLFs - Moves relevant database fields to their        *                       CSD015
      *                respective Watch List Fields.                  *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRDBFsToWLFs  BEGSR                                                                CSD015
      *                                                                                       CSD015
      ** Initialise the Watch List Fields array to blanks.                                    CSD015
      *                                                                                       CSD015
     C                   MOVEA     *BLANKS       WLF                                          CSD015
      *                                                                                       CSD015
     C                   SELECT                                                               CSD015
      *                                                                                       CSD015
      ** Execute an unconditional move if necessary.                                          CSD015
      *                                                                                       CSD015
     C                   WHEN      WMoveMode = ALL                                            CSD015
      *                                                                                       CSD015
     C                   MOVEL     RONS          WLF(1)                                       CSD015
     C                   MOVEL     RIBN          WLF(2)                                       CSD015
     C                   MOVEL     ROBN          WLF(3)                                       CSD015
     C                   MOVEL     ROCN          WLF(4)                                       CSD015
     C                   MOVEL     PONS          WLF(5)                                       CSD015
     C                   MOVEL     PIBN          WLF(6)                                       CSD015
     C                   MOVEL     POBN          WLF(7)                                       CSD015
     C                   MOVEL     POCN          WLF(8)                                       CSD015
     C                   MOVEL     RCRN          WLF(9)                                       CSD015
     C                   MOVEL     RVNO          WLF(10)                                      CSD015
     C                   MOVEL     AWBN          WLF(11)                                      CSD015
     C                   MOVEL     BENN          WLF(12)                                      CSD015
      *                                                                                       CSD015
     C                   WHEN      WMoveMode = CHANGED                                        CSD015
      *                                                                                       CSD015
      ** Move only the fields that have changed since the last save.                          CSD015
      *                                                                                       CSD015
     C                   EVAL      WChgFlg = 'N'                                              CSD015
      *                                                                                       CSD015
     C                   IF        RONS <> BCRONS                                             CSD015
     C                   MOVEL     RONS          WLF(1)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        RIBN <> BCRIBN                                             CSD015
     C                   MOVEL     RIBN          WLF(2)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        ROBN <> BCROBN                                             CSD015
     C                   MOVEL     ROBN          WLF(3)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        ROCN <> BCROCN                                             CSD015
     C                   MOVEL     ROCN          WLF(4)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        PONS <> BCPONS                                             CSD015
     C                   MOVEL     PONS          WLF(5)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        PIBN <> BCPIBN                                             CSD015
     C                   MOVEL     PIBN          WLF(6)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        POBN <> BCPOBN                                             CSD015
     C                   MOVEL     POBN          WLF(7)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        POCN <> BCPOCN                                             CSD015
     C                   MOVEL     POCN          WLF(8)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        RCRN <> BCRCRN                                             CSD015
     C                   MOVEL     RCRN          WLF(9)                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        RVNO <> BCRVNO                                             CSD015
     C                   MOVEL     RVNO          WLF(10)                                      CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        AWBN <> BCAWBN                                             CSD015
     C                   MOVEL     AWBN          WLF(11)                                      CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        BENN <> BCBENN                                             CSD015
     C                   MOVEL     BENN          WLF(12)                                      CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        DTP1 <> BCDTP1 OR                                          CSD015
     C                             DTP2 <> BCDTP2 OR                                          CSD015
     C                             DTP3 <> BCDTP3 OR                                          CSD015
     C                             DTP4 <> BCDTP4                                             CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDSL                                                                CSD015
      *                                                                                       CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRWLFChk - Checks if there is something useful to return      *                       CSD015
      *            to the Compliance Engine.                          *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRWLFChk      BEGSR                                                                CSD015
      *                                                                                       CSD015
      ** Check the Watch List Fields array.                                                   CSD015
      *                                                                                       CSD015
     C                   EVAL      WOKFlg = 'N'                                               CSD015
     C                   EVAL      Ctr = 1                                                    CSD015
      *                                                                                       CSD015
     C                   DOU       Ctr = ArrMax                                               CSD015
     C                   IF        WLF(Ctr) <> *BLANKS                                        CSD015
     C                             AND WLF(Ctr) <> '000000'                                   CSD015
     C                   EVAL      WOKFlg = 'Y'                                               CSD015
     C                   LEAVE                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   EVAL      Ctr = Ctr + 1                                              CSD015
     C                   ENDDO                                                                CSD015
      *                                                                                       CSD015
      ** Check the Payment Details.                                                           CSD015
      *                                                                                       CSD015
     C                   IF        WOKFlg = 'N'                                               CSD015
     C                   IF        DTP1 <> *BLANKS OR                                         CSD015
     C                             DTP2 <> *BLANKS OR                                         CSD015
     C                             DTP3 <> *BLANKS OR                                         CSD015
     C                             DTP4 <> *BLANKS                                            CSD015
     C                   EVAL      WOKFlg = 'Y'                                               CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRRetryChk - Checks if the current record is unconfirmed by   *                       CSD015
      *              the Compliance Engine.                           *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRRetryChk    BEGSR                                                                CSD015
      *                                                                                       CSD015
     C                   EVAL      WRetryFlg = 'N'                                            CSD015
      *                                                                                       CSD015
     C                   MOVEL     'DEALSDG'     KFuncType                                    CSD015
     C                   MOVEL     DLNO          KIden                                        CSD015
     C                   MOVEL     BRCA          KBranch                                      CSD015
      *                                                                                       CSD015
     C     KCWHT         CHAIN     SDCWHTL1                                                   CSD015
      *                                                                                       CSD015
     C                   IF        %FOUND(SDCWHTL1) AND                                       CSD015
     C                             W3UNCF = 'Y'                                               CSD015
     C                   EVAL      WRetryFlg = 'Y'                                            CSD015
     C                   ENDIF                                                                CSD015
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
     C                   EVAL      PCustNo = *BLANKS                                          CSD015
     C                   EVAL      WCtrpRpt = *BLANKS                                         CSD015
     C                   EVAL      WCtrpTyp = *BLANKS                                         CSD015
     C                   MOVEL     CNUM          PCustNo                                      CSD015
      *                                                                                       CSD015
      ** Get the Customer Detail.                                                             CSD015
      *                                                                                       CSD015
     C                   CALL      'AOCUSTR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*KEY   '     @Optn                                        CSD015
     C                   PARM                    PCustNo                                      CSD015
     C                   PARM      *BLANKS       PErrInf                                      CSD015
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSD015
      *                                                                                       CSD015
     C                   IF        @RtCd = *BLANKS                                            CSD015
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
     C                   EVAL      DBKey = PCustNo                                            CSD015
     C                   EVAL      DBFile = 'SDCUSTPD'                                        CSD015
     C                   EVAL      DBase = 911                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
      *                                                                                       CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRDateToDDT - Converts a date into Date Data Type format.     *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRDateToDDT   BEGSR                                                                CSD015
      *                                                                                       CSD015
      ** Convert the derived Midas Day Number into Date Data Type.                            CSD015
      *                                                                                       CSD015
     C                   CALL      'ZACVTDATE'                                                CSD015
     C                   PARM      *BLANKS       PZARtCd                                      CSD015
     C                   PARM                    PZADayNo                                     CSD015
     C                   PARM                    PZADDT                                       CSD015
     C                   PARM                    PZACvtDate                                   CSD015
      *                                                                                       CSD015
     C                   EVAL      WDDT = PZADDT                                              CSD015
      *                                                                                       CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRAmtToNum - Converts a native amount into numerical format.  *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRAmtToNum    BEGSR                                                                CSD015
      *                                                                                       CSD015
      ** Directly convert the given amount into numerical format.                             CSD015
      *                                                                                       CSD015
     C                   CALL      'ZACVTAMT'                                                 CSD015
     C                   PARM      *BLANKS       PZARtCd                                      CSD015
     C                   PARM                    PZACcy                                       CSD015
     C                   PARM                    PZANtvAmt                                    CSD015
     C                   PARM                    PZAAmt                                       CSD015
     C                   PARM                    PZACvtAmt                                    CSD015
      *                                                                                       CSD015
     C                   EVAL      WAMT = PZAAmt                                              CSD015
      *                                                                                       CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CAP084
      *  SrGetUser - Get web browser user                             *                       CAP084
      *****************************************************************                       CAP084
     C     SrGetUser     BEGSR                                                                CAP084
                                                                                              CAP084
     C                   CALL      'SFC000026'                                                CAP084
     C                   PARM      *BLANKS       PUser            10                          CAP084
                                                                                              CAP084
     C                   IF        PUser = *BLANKS                                            CAP084
     C                   EVAL      PUser = PSUser                                             CAP084
     C                   ENDIF                                                                CAP084
                                                                                              CAP084
     C                   ENDSR                                                                CAP084
      *****************************************************************                       CAP084
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
     C     KADVC         SETLL     READVCL1                                                   CRE020
     C     KADVC         READE     READVCL1                                                   CRE020
                                                                                              CRE020
     C                   DOW       NOT %EOF (READVCL1)                                        CRE020
                                                                                              CRE020
      ** Check first if the record was just inserted                                          CRE020
                                                                                              CRE020
     C                   IF        RCHTYP = 'I' AND                                           CRE020
     C                             RSAPIN <>'Y'                                               CRE020
     C                   SELECT                                                               CRE020
                                                                                              CRE020
     C                   WHEN      WSCHTP = 'R'                                               CRE020
     C                   EVAL      RCHTYP = 'D'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'Y'                                               CRE020
     C                   UPDATE    READVCD0                                                   CRE020
                                                                                              CRE020
      ** If reauthorisation is required for amended transaction, set Authorise Ind. to 'N'    CRE020
                                                                                              CRE020
     C                   WHEN      WSCHTP = 'A'                                               CRE020
     C                   IF        BQFIRA = 'Y'                                               CRE020
     C                   EVAL      RAUTHI = 'N'                                               CRE020
     C                   ELSE                                                                 CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   ENDIF                                                                CRE020
     C                   UPDATE    READVCD0                                                   CRE020
                                                                                              CRE020
     C                   OTHER                                                                CRE020
     C                   IF        WSCHTP = 'X' OR                                            CRE020
     C                             BQFIAU = 'N'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   UPDATE    READVCD0                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDSL                                                                CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     **  If existing transaction was amended, authorised or deleted, update Last Change       CRE020
     **  Type, Authorise Indicator and Print Advice Indicator                                 CRE020
                                                                                              CRE020
     C                   IF        WSCHTP <>'X'                                               CRE020
     C                   EVAL      RCHTYP = WSCHTP                                            CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   IF        WSCHTP = 'A'                                               CRE020
                                                                                              CRE020
     C                   IF        BQFIRA = 'N' AND                                           CRE020
     C                             RAUTHI = 'N'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   IF        BQFIRA = 'Y' AND                                           CRE020
     C                             RSAPIN = 'N'                                               CRE020
     C                   EVAL      RAUTHI = 'N'                                               CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C                   IF        RAUTHI = 'N'                                               CRE020
     C                   EVAL      RAUTHI = 'Y'                                               CRE020
     C                   EVAL      RSAPIN = 'N'                                               CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   UPDATE    READVCD0                                                   CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C     KADVC         READE     READVCL1                                                   CRE020
     C                   ENDDO                                                                CRE020
     C                   CLOSE     READVCL1                                                   CRE020
                                                                                              CRE020
     C                   ENDSR                                                                CRE020
      *****************************************************************                       CRE020
     C/COPY WNCPYSRC,IRH00077
      /EJECT                                                                                  CAP084
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
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@RTCD            7
     C                   PARM                    PModeOfOp                                    CAP056
     C                   PARM                    IRVSIRS
     C                   PARM                    IRVXSIR                                      CLE025
     C**********         PARM                    OurRatChgs      294                   CAP004 CAP043
     C**********         PARM                    OurPayDats      294                   CAP004 CAP043
     C**********         PARM                    ThrRatChgs      294                   CAP004 CAP043
     C**********         PARM                    ThrPayDats      294                   CAP004 CAP043
     C                   PARM                    ScreenInpt                     CAP004
     C                   PARM                    CIR008                                       CIR008
     C                   PARM                    CAP056                                       CAP056
      *
     C     *LIKE         DEFINE    UEINR         ##UEINR
     C     *LIKE         DEFINE    TEINR         ##TEINR
     C     *LIKE         DEFINE    UNICD         ##UNICD
     C     *LIKE         DEFINE    TNICD         ##TNICD
     C     *LIKE         DEFINE    UFRFD         ##UFRFD
     C     *LIKE         DEFINE    TFRFD         ##TFRFD
     C     *LIKE         DEFINE    L1CYR1        ##L1CYR1                                     235490
     C     *LIKE         DEFINE    L1CYR2        ##L1CYR2                                     235490
     C     *LIKE         DEFINE    L1CYR3        ##L1CYR3                                     235490
     C     *LIKE         DEFINE    L1CYR4        ##L1CYR4                                     235490
     C     *LIKE         DEFINE    L1CYR5        ##L1CYR5                                     235490
     C     *LIKE         DEFINE    L1CYR6        ##L1CYR6                                     235490
     C     *LIKE         DEFINE    L1CYR7        ##L1CYR7                                     235490
     C     *LIKE         DEFINE    L1CYR8        ##L1CYR8                                     235490
     C     *LIKE         DEFINE    L1CYR9        ##L1CYR9                                     235490
     C     *LIKE         DEFINE    L1CYR0        ##L1CYR0                                     235490
     C     *LIKE         DEFINE    BQFIRA        WkFIRA                                       CAP056
     C     *LIKE         DEFINE    BQFIAU        WkFIAU                                       CAP056
      *
      ** Partial Key for DLDTSCPD                                               CAP004
     C     KDTSC         KLIST                                                  CAP004
     C                   KFLD                    DLNO                           CAP004
     C                                                                          CAP004
     C     KIRCList      KLIST                                                                CAP043
     C                   KFLD                    RSFRNT                                       CAP043
                                                                                              CAP043
     C     KIRSDL        KLIST                                                                CAP043
     C                   KFLD                    RSDLNO                                       CAP043
     C                   KFLD                    PVYOURTHR                                    CAP043
     C                   KFLD                    PCPRDT                                       CAP043
                                                                                              CAP043
     C     KIRSDP        KLIST                                                                CAP043
     C                   KFLD                    RSDLNO                                       CAP043
     C                   KFLD                    PVYOURTHR                                    CAP043
      *                                                                                       CSD015
      ** Compliance Watch Hit List Key.                                                       CSD015
      *                                                                                       CSD015
     C     KCWHT         KLIST                                                                CSD015
     C                   KFLD                    KFuncType                                    CSD015
     C                   KFLD                    KIden                                        CSD015
     C                   KFLD                    KBranch                                      CSD015
      *                                                                                       CSD015
                                                                                              CRE020
      ** Midas RE Settled Transaction Index File Key List                                     CRE020
                                                                                              CRE020
     C     KADVC         KLIST                                                                CRE020
     C                   KFLD                    KRefNo                                       CRE020
     C                   KFLD                    KPrgMn                                       CRE020
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '900'         DBASE                          * DBERR 900 *
     C                   EXSR      SRERR                                        *************
     C                   END
      *
      ** ACCESS TRADING DETAILS
      *
     C                   CALLB     'AOTRADR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDTRAD        PARM      SDTRAD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDTRADPD'    DBFILE                         *************
     C                   MOVEL     '901'         DBASE                          * DBERR 901 *
     C                   EXSR      SRERR                                        *************
     C                   END
     C*
      ** Call Access Program for FRA/IRS I.C.D. details
      *
     C                   CALLB     'AOFAISR0'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDFAIS        PARM      SDFAIS        DSFDY
                                                                                              CAP056
      ** Store the original value of the flags to a work variable                             CAP056
                                                                                              CAP056
     C                   EVAL      WkFIRA = BQFIRA                                            CAP056
     C                   EVAL      WkFIAU = BQFIAU                                            CAP056
      *                                                                                       200400
      ** Access Retail details via access program                                             200400
      *                                                                                       200400
     C                   CALLB     'AORETLR0'                                                 200400
     C                   PARM      *BLANK        @RTCD                                        200400
     C                   PARM      '*FIRST '     @OPTN                                        200400
     C     SDRETL        PARM      SDRETL        DSFDY                                        200400
                                                                                              CAP043
      ** Access module details to see if Midas-Plato is installed                             CAP043
                                                                                              CAP043
     C                   CALLB     'AOMMODR0'                                                 CAP043
     C                   PARM      '*DBERR '     PRTCD                                        CAP043
     C                   PARM      '*FIRST '     POPTN                                        CAP043
     C     SDMMOD        PARM      SDMMOD        DSFDY                                        CAP043
     C*
      ** ACCESS SAR DETAILS FOR Interest Rate Calendars                         CAP004
      *                                                                         CAP004
     C                   CALL      'AOSARDR0'                                   CAP004
     C                   PARM      *BLANKS       @RTCD                          CAP004
     C                   PARM      '*VERIFY'     @OPTN                          CAP004
     C                   PARM      'CIR001'      @SARD             6            CAP004
     C     SCSARD        PARM      SCSARD        DSFDY                          CAP004
      *                                                                         CAP004
      * DATABASE ERROR                                                          CAP004
      *                                                                         CAP004
     C     @RTCD         IFNE      *BLANKS                                      CAP004
     C     @RTCD         ANDNE     '*NRF   '                                    CAP004
     C                   MOVEL     'CIR001'      DBKEY                          CAP004
     C                   MOVEL     'SCSARDPD'    DBFILE                         *************CAP004
     C                   MOVEL     '905'         DBASE                          * DBERR 905 *CAP004
     C                   EXSR      *PSSR                                        *************CAP004
     C                   END                                                    CAP004
     C*                                                                         CAP004
     C     @RTCD         IFEQ      *BLANK                                       CAP004
     C                   MOVEL     'Y'           CIR001            1            CAP004
     C                   ELSE                                                   CAP004
     C                   MOVEL     'N'           CIR001                         CAP004
     C                   END                                                    CAP004
     C/COPY WNCPYSRC,IRSIRSDC09
                                                                                CIR005
      ** Access SAR details file to determine if FRA/IRS Business Day           CIR005
      ** Day Convention is switched on.                                         CIR005
                                                                                CIR005
     C                   CALL      'AOSARDR0'                                   CIR005
     C                   PARM      *BLANKS       @RTCD                          CIR005
     C                   PARM      '*VERIFY'     @OPTN                          CIR005
     C                   PARM      'CIR005'      @SARD                          CIR005
     C     SCSARD        PARM      SCSARD        DSFDY                          CIR005
                                                                                CIR005
     C                   IF        (@RTCD <> *BLANKS) And (@RTCD <> '*NRF   ')  CIR005
     C                   MOVEL     'SCSARDPD'    DBFILE                         CIR005
     C                   MOVEL     '997'         DBASE                          CIR005
     C                   MOVEL     'CIR005'      DBKEY                          CIR005
     C                   EXSR      *PSSR                                        CIR005
     C                   ENDIF                                                  CIR005
                                                                                CIR005
     C                   IF        @RTCD = *BLANKS                              CIR005
     C                   MOVEL     'Y'           CIR005            1            CIR005
     C                   ELSE                                                   CIR005
     C                   MOVEL     'N'           CIR005                         CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CAP004
      ** Determine if Data Export for CCRM Limits is active                     CDE001
     C                   CALL      'AOSARDR0'                                   CDE001
     C                   PARM      *BLANKS       @RTCD                          CDE001
     C                   PARM      '*VERIFY'     @OPTN                          CDE001
     C                   PARM      'CDE001'      @SARD                          CDE001
      *                                                                         CDE001
     C     @RTCD         IFEQ      *BLANK                                       CDE001
     C                   MOVEL     'Y'           CDE001            1            CDE001
     C                   ENDIF                                                  CDE001
                                                                                              CIR011
      ** Access SAR details file to determine if Rate Fix Day Adjustment is on                CIR011
                                                                                              CIR011
     C                   CALL      'AOSARDR0'                                                 CIR011
     C                   PARM      *BLANKS       @RTCD                                        CIR011
     C                   PARM      '*VERIFY'     @OPTN                                        CIR011
     C                   PARM      'CIR011'      @SARD                                        CIR011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR011
                                                                                              CIR011
     C     @RTCD         IFNE      *BLANKS                                                    CIR011
     C     @RTCD         ANDNE     '*NRF   '                                                  CIR011
     C     *LOCK         IN        LDA                                                        CIR011
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CIR011
     C                   Z-ADD     998           DBASE                                        CIR011
     C                   MOVEL     'CIR011'      DBKEY                                        CIR011
     C                   OUT       LDA                                                        CIR011
     C                   EXSR      *PSSR                                                      CIR011
     C                   ENDIF                                                                CIR011
                                                                                              CIR011
     C     @RTCD         IFEQ      *BLANKS                                                    CIR011
     C                   MOVEL     'Y'           CIR011                                       CIR011
     C                   ELSE                                                                 CIR011
     C                   MOVEL     'N'           CIR011                                       CIR011
     C                   ENDIF                                                                CIR011
      *                                                                         CDE001
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRtCd                                        CSC011
     C                   PARM      '*VERIFY'     POptn                                        CSC011
     C                   PARM      'CSC011'      PSard                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRtCd = *Blanks                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C**********         IN        SDSTAT                                              CSC011 CSD015
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
                                                                                              CSC011
     C                   IF        PRtCd <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 905                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      SRERR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** Access SAR details for Net Present Value Accounting, CAS001                          CAS001
      *                                                                                       CAS001
     C                   CALL      'AOSARDR0'                                                 CAS001
     C                   PARM      *BLANKS       PRTCD                                        CAS001
     C                   PARM      '*VERIFY'     POPTN                                        CAS001
     C                   PARM      'CAS001'      PSARD                                        CAS001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS001
      *                                                                                       CAS001
      ** DATABASE ERROR                                                                       CAS001
      *                                                                                       CAS001
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CAS001
     C     *LOCK         IN        LDA                                                        CAS001
     C                   MOVEL     'CAS001'      DBKEY                                        CAS001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAS001
     C                   Z-ADD     906           DBASE                                        CAS001
     C                   MOVEL     'IRSIRSUPD'   DBPGM                                        CAS001
     C                   OUT       LDA                                                        CAS001
     C                   EXSR      *PSSR                                                      CAS001
     C                   ENDIF                                                                CAS001
      *                                                                                       CAS001
     C                   IF        PRTCD = *BLANK                                             CAS001
     C                   MOVEL     'Y'           CAS001                                       CAS001
     C                   ELSE                                                                 CAS001
     C                   MOVEL     'N'           CAS001                                       CAS001
     C                   ENDIF                                                                CAS001
      *                                                                                       CAS001
      ** Access SAR details to determine if enhancement CAS005                                CAS005
      ** is installed.                                                                        CAS005
                                                                                              CAS005
     C                   CALL      'AOSARDR0'                                                 CAS005
     C                   PARM      *BLANKS       PRTCD                                        CAS005
     C                   PARM      '*VERIFY'     POPTN                                        CAS005
     C                   PARM      'CAS005'      PSARD                                        CAS005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS005
                                                                                              CAS005
      ** Database Error                                                                       CAS005
                                                                                              CAS005
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CAS005
     C     *LOCK         IN        LDA                                                        CAS005
     C                   MOVEL     'CAS005'      DBKEY                                        CAS005
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CAS005
     C                   Z-ADD     907           DBASE                                        CAS005
     C                   MOVEL     'IRSIRSUPD'   DBPGM                                        CAS005
     C                   OUT       LDA                                                        CAS005
     C                   EXSR      *PSSR                                                      CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        PRTCD = *BLANK                                             CAS005
     C                   MOVEL     'Y'           CAS005                                       CAS005
     C                   ELSE                                                                 CAS005
     C                   MOVEL     'N'           CAS005                                       CAS005
     C                   ENDIF                                                                CAS005
      *                                                                                       CAS005
      ** Determine if CAP043 enhancement is installed                                         CAP043
      *                                                                                       CAP043
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
      **  Access the SDSTAT Data Area.                                                        CSD015
     C                   IN        SDSTAT                                                     CSD015
                                                                                              CSD015
      **  Access SAR details to see if CSD015 is switched on.                                 CSD015
                                                                                              CSD015
     C                   CALL      'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*VERIFY'     @Optn                                        CSD015
     C                   PARM      'CSD015'      @SARD                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
     C                   IF        @RtCd = *BLANKS                                            CSD015
     C                   EVAL      CSD015 = 'Y'                                               CSD015
     C                   ELSE                                                                 CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        @RtCd <> '*NRF'                                            CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = 'CSD015'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 907                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      **  Access SAR details to see if CCF001 is switched on.                                 CSD015
                                                                                              CSD015
     C                   CALL      'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*VERIFY'     @Optn                                        CSD015
     C                   PARM      'CCF001'      @SARD                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
     C                   IF        @RtCd = *BLANKS                                            CSD015
     C                   EVAL      CCF001 = 'Y'                                               CSD015
     C                   ELSE                                                                 CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        @RtCd <> '*NRF'                                            CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = 'CCF001'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 910                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Check if transactions are being monitored by Compliance Watch.                       CSD015
                                                                                              CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
                                                                                              CSD015
     C                   CALL      'AOWLCCR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*KEY   '     @Optn                                        CSD015
     C                   PARM      'DEALING '    PFuncCode                                    CSD015
     C     SDWLCC        PARM      SDWLCC        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        @RtCd <> *BLANKS AND                                       CSD015
     C                             @RtCd <> '*NRF'                                            CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = 'DEALING'                                          CSD015
     C                   EVAL      DBFile = 'SDWLCCPD'                                        CSD015
     C                   EVAL      DBase = 908                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      **  Access the Compliance Watch Configuration Data.                                     CSD015
                                                                                              CSD015
     C                   CALL      'AOCWCDR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*FIRST '     @Optn                                        CSD015
     C     SDCWCD        PARM      SDCWCD        DSFDY                                        CSD015
                                                                                              CSD015
     C                   IF        @RtCd <> *BLANKS                                           CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = @Optn                                              CSD015
     C                   EVAL      DBFile = 'SDCWCDPD'                                        CSD015
     C                   EVAL      DBase = 909                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CRE020
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
     C                   EVAL      DBase = 912                                                CRE020
     C                   EVAL      DBKey = 'CRE020'                                           CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      SRErr                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
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
     C                   EVAL      DBase = 913                                                CRE020
     C                   EVAL      DBKey = PSysVal01                                          CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      SRErr                                                      CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CSD015
      ** Access SAR details to determine if enhancement CLE025                                CLE025
      ** is installed.                                                                        CLE025
                                                                                              CLE025
     C                   CALL      'AOSARDR0'                                                 CLE025
     C                   PARM      *BLANKS       PRTCD                                        CLE025
     C                   PARM      '*VERIFY'     POPTN                                        CLE025
     C                   PARM      'CLE025'      PSARD                                        CLE025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE025
                                                                                              CLE025
      ** Database Error                                                                       CLE025
                                                                                              CLE025
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CLE025
     C     *LOCK         IN        LDA                                                        CLE025
     C                   MOVEL     'CLE025'      DBKEY                                        CLE025
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CLE025
     C                   Z-ADD     920           DBASE                                        CLE025
     C                   MOVEL     'IRSIRSUPD'   DBPGM                                        CLE025
     C                   OUT       LDA                                                        CLE025
     C                   EXSR      *PSSR                                                      CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
     C                   IF        PRTCD = *BLANK                                             CLE025
     C                   MOVEL     'Y'           CLE025                                       CLE025
     C                   ELSE                                                                 CLE025
     C                   MOVEL     'N'           CLE025                                       CLE025
     C                   ENDIF                                                                CLE025
      *                                                                                       CLE025
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
     C                   Eval      DBASE = 914                                               BUG6671
     C                   OUT       LDA                                                       BUG6671
     C                   EXSR      *PSSR                                                     BUG6671
     C                   ENDIF                                                               BUG6671
      *                                                                                      BUG6671
     C                   If        PRTCD = *Blanks                                           BUG6671
     C                   Eval      CAP051 = 'Y'                                              BUG6671
     C                   Else                                                                BUG6671
     C                   Eval      CAP051 = 'N'                                              BUG6671
     C                   EndIf                                                               BUG6671
      *                                                                                      BUG6671
      ** Access SAR details to determine if enhancement CDL028                                CDL028
      ** is installed.                                                                        CDL028
      *                                                                                       CDL028
     C                   CALL      'AOSARDR0'                                                 CDL028
     C                   PARM      *BLANKS       PRTCD                                        CDL028
     C                   PARM      '*VERIFY'     POPTN                                        CDL028
     C                   PARM      'CDL028'      PSARD                                        CDL028
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL028
                                                                                              CDL028
     C                   IF        PRTCD = *BLANK                                             CDL028
     C                   MOVEL     'Y'           CDL028                                       CDL028
     C                   ELSE                                                                 CDL028
     C                   MOVEL     'N'           CDL028                                       CDL028
     C                   ENDIF                                                                CDL028
      *                                                                                       CDL028
     C                   CALL      'AOSARDR0'                                                BUG7217
     C                   PARM      *BLANKS       PRTCD                                       BUG7217
     C                   PARM      '*VERIFY'     POPTN                                       BUG7217
     C                   PARM      'CIR006'      PSARD                                       BUG7217
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG7217
                                                                                             BUG7217
     C                   If        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                   BUG7217
     C     *LOCK         IN        LDA                                                       BUG7217
     C                   Eval      DBKEY = 'CIR006'                                          BUG7217
     C                   Eval      DBFILE = 'SCSARDPD'                                       BUG7217
     C                   Eval      DBASE = 915                                               BUG7217
     C                   OUT       LDA                                                       BUG7217
     C                   EXSR      *PSSR                                                     BUG7217
     C                   ENDIF                                                               BUG7217
      *                                                                                      BUG7217
     C                   IF        PRTCD = *BLANK                                            BUG7217
     C                   MOVEL     'Y'           CIR006                                      BUG7217
     C                   ELSE                                                                BUG7217
     C                   MOVEL     'N'           CIR006                                      BUG7217
     C                   ENDIF                                                               BUG7217
      *                                                                                      BUG7217
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
     C                   Eval      DBKEY = 'CSD083'                                           CSD083
     C                   Eval      DBFILE = 'SCSARDPD'                                        CSD083
     C                   Eval      DBASE = 916                                                CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
      *                                                                                       CSD083
     C                   IF        PRTCD = *BLANK                                             CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
     C/COPY WNCPYSRC,IRH00078
                                                                                              CSD083
      ** Check if CIR017 - Separate Business Day Convention for SIRS                          CIR017
                                                                                              CIR017
     C                   CALL      'AOSARDR0'                                                 CIR017
     C                   PARM      *BLANKS       PRTCD                                        CIR017
     C                   PARM      '*VERIFY'     POPTN                                        CIR017
     C                   PARM      'CIR017'      PSARD                                        CIR017
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR017
                                                                                              CIR017
     C                   IF        PRTCD <> *BLANKS AND                                       CIR017
     C                             PRTCD <> '*NRF   '                                         CIR017
     C     *LOCK         IN        LDA                                                        CIR017
     C                   EVAL      DBASE = 916                                                CIR017
     C                   EVAL      DBKEY = 'CIR017'                                           CIR017
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CIR017
     C                   OUT       LDA                                                        CIR017
     C                   EXSR      *PSSR                                                      CIR017
     C                   ENDIF                                                                CIR017
                                                                                              CIR017
     C                   IF        PRTCD = *BLANKS                                            CIR017
     C                   EVAL      CIR017 = 'Y'                                               CIR017
     C                   ELSE                                                                 CIR017
     C                   EVAL      CIR017 = 'N'                                               CIR017
     C                   ENDIF                                                                CIR017
                                                                                              CIR017
     C                   CALLB     'AOSVALR0'                                               MD054117
     C                   PARM      *BLANKS       PRtCd                                      MD054117
     C                   PARM                    PSysVal01                                  MD054117
     C                   PARM                    PCurSet01                                  MD054117
     C                   PARM                    PSysVal02                                  MD054117
     C                   PARM                    PCurSet02                                  MD054117
     C                   PARM                    PSysVal03                                  MD054117
     C                   PARM                    PCurSet03                                  MD054117
     C                   PARM                    PSysVal04                                  MD054117
     C                   PARM                    PCurSet04                                  MD054117
     C                   PARM                    PSysVal05                                  MD054117
     C                   PARM                    PCurSet05                                  MD054117
     C                   PARM                    PSysVal06                                  MD054117
     C                   PARM                    PCurSet06                                  MD054117
     C                   PARM                    PSysVal07                                  MD054117
     C                   PARM                    PCurSet07                                  MD054117
     C                   PARM                    PSysVal08                                  MD054117
     C                   PARM                    PCurSet08                                  MD054117
     C                   PARM                    PSysVal09                                  MD054117
     C                   PARM                    PCurSet09                                  MD054117
     C                   PARM                    PSysVal10                                  MD054117
     C                   PARM                    PCurSet10                                  MD054117
                                                                                            MD054117
     C                   EVAL      PCIDCF = 'N'                                             MD054117
                                                                                            MD054117
     C                   IF        PRtCd = *BLANKS                                          MD054117
     C                   MOVEL     PCurSet02     PCIDCF                                     MD054117
     C                   ELSE                                                               MD054117
                                                                                            MD054117
     C     *LOCK         IN        LDA                                                      MD054117
     C                   EVAL      DBFile = 'SDSVALPD'                                      MD054117
     C                   EVAL      DBase = 917                                              MD054117
     C                   EVAL      DBKey = PSysVal02                                        MD054117
     C                   OUT       LDA                                                      MD054117
     C                   EXSR      SRErr                                                    MD054117
                                                                                            MD054117
     C                   ENDIF                                                              MD054117
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* SRERR - EXCEPTION ERRORS                                     *
     C*                                                              *
     C****************************************************************
     C     SRERR         BEGSR
     C*
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'IRSIRSUPD'   DBPGM            10
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C*
     C**  TERMINATE THE PROGRAM
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C****************************************************************
**  CPY@
(c) Finastra International Limited 2001
** CTDATA XOT - XML Opening Tags for the Compliance Engine.                                   CSD015
<Receipt Our Nostro>                                                                          CSD015
<Receipt Inter. Bank>                                                                         CSD015
<Receipt Ord. Bank>                                                                           CSD015
<Receipt Ord. Customer>                                                                       CSD015
<Payment Our Nostro>                                                                          CSD015
<Payment Inter. Bank>                                                                         CSD015
<Payment Ord. Bank>                                                                           CSD015
<Payment Ord. Customer>                                                                       CSD015
<Payment Rec. Corr.>                                                                          CSD015
<Payment Recipient>                                                                           CSD015
<Payment Acc. with Bank>                                                                      CSD015
<Payment Beneficiary>                                                                         CSD015
<Payment Details>                                                                             CSD015
** CTDATA XCT - XML Closing Tags for the Compliance Engine.                                   CSD015
</Receipt Our Nostro>                                                                         CSD015
</Receipt Inter. Bank>                                                                        CSD015
</Receipt Ord. Bank>                                                                          CSD015
</Receipt Ord. Customer>                                                                      CSD015
</Payment Our Nostro>                                                                         CSD015
</Payment Inter. Bank>                                                                        CSD015
</Payment Ord. Bank>                                                                          CSD015
</Payment Ord. Customer>                                                                      CSD015
</Payment Rec. Corr.>                                                                         CSD015
</Payment Recipient>                                                                          CSD015
</Payment Acc. with Bank>                                                                     CSD015
</Payment Beneficiary>                                                                        CSD015
</Payment Details>                                                                            CSD015
