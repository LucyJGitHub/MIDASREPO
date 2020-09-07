     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Cross ccy IRS database update')               *
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing Module                               *
      *                                                               *
      *  IRCIRSUPD - Cross Currency IRS Database Update               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. 235567             Date 12Mar20               *
      *                 MD054117           Date 12Sep19               *
      *                 MD054095           Date 17Oct19               *
      *                 CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 CDL099             Date 06Oct17               *
      *                 MD036601           Date 29Aug16               *
      *                 AR743357           Date 22Apr15               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 01Sep14               *
      *                 MD025244           Date 09May14               *
      *                 AR1041215A         Date 28Dec12               *
      *                 253954             Date 19Nov12               *
      *                 CSF011A            Date 28Nov11               *
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
      *                 BUG7911            Date 31Oct05               *
      *                 CDL049             Date 07Jul06               *
      *                 CIR014             Date 11May06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG11266           Date 24Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE031             Date 26Apr05               *
      *                 235490             Date 01Sep05               *
      *                 227642             Date 23Aug04               *
      *                 236776             Date 25Nov05               *
      *                 BUG6877N           Date 10Jul05               *
      *                 CDL038             Date 10May05               *
      *                 BUG7535            Date 14Jun05               *
      *                 BUG6877R           Date 16Jun05               *
      *                 228071             Date 30Jun04               *
      *                 CAS008             Date 16Jun04               *
      *                 BUG7095            Date 09May05               *
      *                 CSW037A            Date 02May05               *
      *                 CDL028             Date 07Feb05               *
      *                 BUG6373            Date 24Mar05               *
      *                 BUG6671            Date 26Apr05               *
      *                 BUG6877            Date 29Apr05               *
      *                 BUG6418            Date 04Apr05               *
      *                 BUG5519            Date 16Feb05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG5291            Date 12Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CDL018             Date 03Feb04               *
      *                 TDA101             Date 02Apr04               *
      *                 TDA081             Date 01Apr04               *
      *                 CRE020             Date 20Jan04               *
      *                 TDA041             Date 22Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 222727             Date 05Nov03               *
      *                 CDE005             Date 19Aug03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CIR011             Date 15Apr02               *
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
      *                 CSC011             Date 18Sep01               *
      *                 194487             Date 16Aug01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 200400             Date 20Nov01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 184363             Date 23Jan01               *
      *                 CIR003             Date 13Sep00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 179510             Date 17Jul00               *
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CIR005             Date 21Jan00               *
      *                 CDE001             Date 12Apr00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CSW097             Date 10Feb00               *
      *                 CAP013             Date 07Sep99               *
      *                 168345             Date 13Oct99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 168981             Date 20May99               *
      * Midas DBA 3.00 -----------------Base--------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP006             Date 23Feb99               *
      *                 151240             Date 21Dec98               *
      *                 CAP004             Date 10Aug98               *
      *                 CAP003  *CREATE    Date 01Apr98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  235567 - Ensure pay/rcv msgs are generated during I/C when   *
      *           VDEI is 'Y' and value date SSIs are amended.        *
      *           Initialise BefRecVal and AftRecVal on 'Authorise'.  *
      *         - Applied for AR1041215. (Child: AR1041216)           *
      *  MD054117 - Principal change Increase/Decrease capability     *
      *  MD054095 - FRA/IRS: Impossible to input a CIRS deal with zero*
      *             rate                                              *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  MD036601 - DLC0606B failed in RU production dd 10.11.2015    *
      *             Reset URFIN / TRFIN whenever fix date is less than*
      *             rate change date.                                 *
      *  AR743357 - Reverse 246966. Error for 246966 should be put to *
      *             DLC02A.                                           *
      *           - Applied for MD033602                              *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompile)                                         *
      *  MD025244 - Added parameter in calling ZADLTRLRUD.            *
      *  AR1041215A - Ensure that PRIs on DTRIXDD were properly       *
      *               populated during authorizing an amended deal.   *
      *               (Child: AR1041216)                              *
      *  253954 - Blank-out Auto-authorisation field if transaction   *
      *           is inserted from third party API.                   *
      *         - Applied for AR981707 (Child: AR981710)              *
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
      *  248452 - Set up field F1BRCA in DLDLDGQD.                    *
      *  246966 - Override missing for DLPCSCPD.                      *
      *  239742 - No confirmation message for IRS deal amendment.     *
      *  BUG7911 - Prevent the generation of new MT361 when BOVD is   *
      *            no longer blanks, unless BOVD itself was amended.  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CIR014 - Mark to Market Cross-currency Interest Rate Swaps   *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG11266 - Apply 212988. Rate Fix Date should only be        *
      *             be recalculated during amendment if the Rate      *
      *             Change Date, Rate Fix Days and Effective          *
      *             Interest Rate is amended.                         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  235490 - Recalculate the Rate Fix Date when amending         *
      *           Currencies for Rate Fixing Convention.              *
      *  227642 - When only short term rate amended, do not produce   *
      *           MT360/MT361.  When short term rate amended, and     *
      *           base rate has been fixed, change rate fix indicator *
      *           to 'B'.  Update Rate Fix Date only when Rate Change *
      *           Date or Rate Fix Days amended.                      *
      *           (in part similar to 11266).                         *
      *  236776 - Ensure pay/rcv msgs are regenerated when settlement *
      *           details are amended.  Reset PMTP flag to blank.     *
      *  BUG6877N-Regenerate pay/receives where necessary.            *
      *  CDL038 - Extended Deal Sub Type                              *
      *  BUG7535- Initialise CDL028 fields                            *
      *  BUG6877R - Incorporated fix is incomplete.                   *
      *  228071 - When short term rate is amended, update FSUEFR and  *
      *           FSTEFR as well.                                     *
      *  CAS008 - IAS 39 Enhancements                                 *
      *  BUG7095 - Do not setup user in the *INZSR subroutine         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CDL028 - Automatic Rate Interpolations                       *
      *  BUG6373 - Call AOOUSWU1 instead of AOOUSWU0                  *
      *  BUG6671 - Implement Auto Authorisation                       *
      *  BUG6877 - Ensure confirmation is generated for amendment.    *
      *            Fix is patterned after 227212.                     *
      *  BUG6418 - Do not produce MT202/MT210 for backvalued deals    *
      *  BUG5519 - When CIR008 is on, projected accnt. movements are  *
      *            not updated after insterting IRS Deals. Fix is     *
      *            patterned after fix 223356.                        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG5291- Get correct user name if using a web browser        *
      *  CLE025 - Credit Lines                                        *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  TDA101 - After and Before image data structure (Z#AST        *
      *           and Z#BST) used in program is short FRA/IRS         *
      *           transaction.  (Recompile)                           *
      *  TDA081 - Fix will ensure that correct Rate fix day will be   *
      *           stored on file.                                     *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  TDA041 - Correct DS positions of DEALS.                      *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CDE005 - Data Export - Reservation ID.                       *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  CIR011 - FRA/IRS Rate Fix Days Adjustment                    *
      *  213055 - Set CNRQ field properly                             *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  CAP043 - Additional APIs for IRS Schedules                   *
      *  217684 - Authorisation User Malfunction                      *
      *  167793 - Amended program to retain negative value of         *
      *           effective interest rate even after deal amendment.  *
      *  CAP056 - Automatic Authorisation of Interface Deals.         *
      *  CIR008 - FRA/IRS Deals Authorisation.                        *
      *  CAS001 - Net Present Value (NPV) Accounting.                 *
      *  CAP041 - APIs for IRS Fees/Buy-Outs/Processing Method/Next   *
      *           Principal Change Date.                              *
      *           Recompiled due to changes in IRVCIRSPD.             *
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
      *  CIR005 - FRA/IRS Business Day Conventions                    *
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
      *  CPL002 - Midas-Plato Interface                               *
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
     FDLCFSCPD  UF A E           K DISK                                                       CAP043
     F                                     PREFIX(CF)                                         CAP043
     F                                     COMMIT                                             CAP043
     FDLPCSCPD  UF A E           K DISK                                                       CAP043
     F                                     PREFIX(PC)                                         CAP043
     F                                     COMMIT                                             CAP043
     FIRVDTSCL0 IF   E           K DISK                                                       CAP043
     FIRVCFSCL0 IF   E           K DISK    PREFIX(CV)                                         CAP043
     FIRVPCSCL0 IF   E           K DISK    PREFIX(PV)                                         CAP043
     FDLGXSTL0  UF A E           K DISK                                                       CIR003
     F                                     PREFIX(GX)                                         CIR003
     F                                     COMMIT                                             CIR003
     FDLGXSBL0  UF A E           K DISK                                                       235567
     F                                     PREFIX(BX)                                         235567
                                                                                              CSD015
      ** Compliance Watch Hit List                                                            CSD015
     FSDCWHTL1  IF   E           K DISK    INFSR(SRERR)                                       CSD015
     F/COPY WNCPYSRC,IRH00067
                                                                                              CSD015
      ** RE Settled Transaction Index File by Transaction Reference ID                        CRE020
      ** and Transaction Maintenance Program                                                  CRE020
     FREADVCL1  UF   E           K DISK    COMMIT                                             CRE020
     F                                     USROPN                                             CRE020
                                                                                              CRE020
     FDLDLDGLN  UF A E           K DISK                                                       CLE025
     F                                     COMMIT                                             CLE025
      ** Deals Extension file                                                                 CLE025
                                                                                              CLE025
     F/COPY WNCPYSRC,IRCIRSDF01
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

      **  EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID CROSS CCY IRS
     D IRVCIRS       E DS                  EXTNAME(IRVCIRSPD)
     D  @RXDET1               11    715
     D  @RXREC               716    784
     D  @RXPY1               785    990
     D  @RXPY2               991   1133
     D  @RXPY3              1134   1343
     D**@RXDET2*************1344   2044                                         CAP013
     D**@RXDET2**           1344   2200                                  CAP013 CIR005
     D**@RXDET2*            1344   2190                                                CIR005 CAS001
     D  @RXDET2             1344   2200                                                       CAS001
     D   OURCCY             2097   2126                                         CIR005
     D   THRCCY             2161   2190                                         CIR005
     D**@RXDET1Ext          2213   2248                                                CGL029 TDA041
     D**@RXRECExt           2249   2266                                                CGL029 TDA041
     D**@RXPY1Ext           2267   2284                                                CGL029 TDA041
     D  @RXDET1Ext          2469   2504                                                       TDA041
     D  @RXRECExt           2505   2522                                                       TDA041
     D  @RXPY1Ext           2523   2540                                                       TDA041
     D  @RXDET3             2551   2602                                                       CDL028

      **  DEALS FILE - FORWARD RATE AGREEMENTS
     D DEALS         E DS                  EXTNAME(DEALSDG)
     D  @DLDET1               11    715
     D  @DLREC               716    784
     D  @DLPY1               785    990
     D  @DLPY2               991   1133
     D  @DLPY3              1134   1343
     D**@DLDET2*************1344   2044                                         CAP013
     D**@DLDET2**           1344   2200                                  CAP013 CIR005
     D**@DLDET2*            1344   2190                                                CIR005 CAS001
     D  @DLDET2             1344   2200                                                       CAS001
     D**@DLDET1Ext**********2248   2283                                                       TDA041
     D**@DLRECExt***********2284   2301                                                       TDA041
     D**@DLPY1Ext***********2302   2319                                                       TDA041
     D  @DLDET1Ext          2469   2504                                                       TDA041
     D  @DLRECExt           2505   2522                                                       TDA041
     D  @DLPY1Ext           2523   2540                                                       TDA041
     D  @DLDET3             2551   2602                                                       CDL028
      *                                                                                       TDA041
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
     D IRECIRS       E DS                  EXTNAME(IRECIRSPD)                   CAP006
      * Error indicators                                                        CAP006
                                                                                              CIR003
     D DLGXST        E DS                  EXTNAME(DLGXSTPD)                                  CIR003
     D                                     PREFIX(GX)                                         CIR003
      *                                                                                       CIR003
     D DLGXSB        E DS                  EXTNAME(DLGXSBPD)                                  235567
     D                                     PREFIX(BX)                                         235567
                                                                                              CSD015
     D MXST          E DS                  EXTNAME(DLGXSTPD)                                  CSD015
     D                                     PREFIX(M:1)                                        CSD015
      ** Maturity Extended Settlements Data Store                                             CSD015
                                                                                              CSD015
     D VXST          E DS                  EXTNAME(DLGXSTPD)                                  CSD015
     D                                     PREFIX(V:1)                                        CSD015
      ** Value Extended Settlements Data Store                                                CSD015
                                                                                              CSD015
     D MXSTBC        E DS                  EXTNAME(DLGXSTPD)                                  CSD015
     D                                     PREFIX(MB:2)                                       CSD015
      ** Backup Container of Maturity Extended Settlements                                    CSD015
     D  QQRONS1      E                     EXTFLD(QQRONS)                                     CGL029
     D  QQPONS1      E                     EXTFLD(QQPONS)                                     CGL029
                                                                                              CSD015
     D VXSTBC        E DS                  EXTNAME(DLGXSTPD)                                  CSD015
     D                                     PREFIX(VB:2)                                       CSD015
      ** Backup Container of Value Extended Settlements                                       CSD015
     D  QQRONS2      E                     EXTFLD(QQRONS)                                     CGL029
     D  QQPONS2      E                     EXTFLD(QQPONS)                                     CGL029
                                                                                              CSD015
     D XSTBC         E DS                  EXTNAME(DLGXSTPD)                                  CSD015
     D                                     PREFIX(BC)                                         CSD015
      ** Backup Container of Extended Settlements                                             CSD015
     D  QQRONS3      E                     EXTFLD(QQRONS)                                     CGL029
     D  QQPONS3      E                     EXTFLD(QQPONS)                                     CGL029
                                                                                              CLE025
     D IRVXSIR       E DS                  EXTNAME(IRVXSIRPD)                                 CLE025
      **  Externally described data structure for valid extension file                        CLE025
                                                                                CAP006
      **  Time data structure for DTRIX.
     D                 DS
     D  @XTIME                 1      6  0
     D  DXTIM                  1      4  0
                                                                                              CAP043
      ** Last processing date (82nd PRDT) UR/UP/TR/TP                                         CAP043
     D PLastPRDT       DS                                                                     CAP043
     D WLastPRDT               1     12P 0 DIM(4) INZ(0)                                      CAP043

     D** Define external data-structures for before and after image
     D**   of deal for on-line updates.
     D*
     D Z#BSTS        E DS                  EXTNAME(Z#BST)
     D Z#ASTS        E DS                  EXTNAME(Z#AST)
     D Z#WSTS        E DS                  EXTNAME(Z#WST)                                     CIR003
     D  BefRecVal             10     84A                                                      CIR003
     D  BefPayVal             85   1283A                                                      CIR003
     D**BefPayPONS          1304   1321A                                           CGL029 AR1041215A
     D**BefRecRONS          1322   1339A                                           CGL029 AR1041215A
     D  BefRecRONS          1304   1321A                                                  AR1041215A
     D  BefPayPONS          1322   1339A                                                  AR1041215A
     D Z#XSTS        E DS                  EXTNAME(Z#XST)                                     CIR003
     D Z#YSTS        E DS                  EXTNAME(Z#YST)                                     CIR003
     D  AftRecVal             10     84A                                                      CIR003
     D  AftPayVal             85   1283A                                                      CIR003
     D**AftPayPONS          1304   1321A                                           CGL029 AR1041215A
     D**AftRecRONS          1322   1339A                                           CGL029 AR1041215A
     D  AftRecRONS          1304   1321A                                                  AR1041215A
     D  AftPayPONS          1322   1339A                                                  AR1041215A
     D Z#ZSTS        E DS                  EXTNAME(Z#ZST)                                     CIR003
     D*
     D ValExtSettV   E DS                  EXTNAME(IRVXSETPD)                                 CIR003
     D                                     PREFIX(E1)                                         CIR003
                                                                                              CIR003
     D ValExtSettI   E DS                  EXTNAME(IRVXSETPD)                                 CIR003
     D                                     PREFIX(E2)                                         CIR003
                                                                                              CIR003
     D ValExtSettM   E DS                  EXTNAME(IRVXSETPD)                                 CIR003
     D                                     PREFIX(E3)                                         CIR003
                                                                                              CIR003
     D ValExtSett1   E DS                  EXTNAME(IRVXSETPD)                                 CIR003
     D                                     PREFIX(V1)                                         CIR003
                                                                                              CIR003
     D ValExtSett2   E DS                  EXTNAME(IRVXSETPD)                                 CIR003
     D                                     PREFIX(V2)                                         CIR003
                                                                                              CIR003
     D ValExtSett3   E DS                  EXTNAME(IRVXSETPD)                                 CIR003
     D                                     PREFIX(V3)                                         CIR003
                                                                                              CIR003
  109D IRCDates      E DS                  EXTNAME(IRVDTSCPD)                   CAP004
      ** Data structure for Int. Rate Calendar dates.                           CAP004
     D  DatAlp                 1    294A                                        CAP004
     D  FOffID                 1     20A                                        CAP004
     D  RatPayInd             21     21A                                        CAP004
     D  OurThrInd             22     22A                                        CAP004
     D  InDate                23    268P 0 DIM(82)                              CAP004
     D  WDTSCConfH           269    350A   DIM(82)                                            CAP043
                                                                                              CAP043
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
                                                                                              CAP043
      ** FRA/IRS Interface Non-Screen Data                                                    CAP043
     D InfData       E DS                  EXTNAME(IRRXIFPD)                                  CAP043

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
     D  QQACCD1      E                     EXTFLD(QQACCD)                                     CGL029
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
      ** Module Details Data Structure                                                        CAP043
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)                                  CAP043
                                                                                              CAP043
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSD015
      ** External DS for Customer Details                                                     CSD015
     D  QQDFAC1      E                     EXTFLD(QQDFAC)                                     CGL029
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
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)                    BUG5291
      ** Java user information                                                               BUG5291
     D/COPY WNCPYSRC,IRH00068
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

     D***OVRDLPCSC       C                   Const('OVRDBF DLPCSCRX DLPCSCPD +       246966 AR743357
     D**********                           OVRSCOPE(*JOB)')                          246966 AR743357
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
                                                                                              CSD015
      ** Max. no. of elements associated with the CE arrays.                                  CSD015
     D ArrMax          C                   CONST(13)                                          CSD015
                                                                                              CSD015
      ** XML Opening Tags for the Compliance Engine.                                          CSD015
     D XOT             S             25A   DIM(ArrMax) PERRCD(1) CTDATA                       CSD015
                                                                                              CSD015
      ** XML Closing Tags for the Compliance Engine.                                          CSD015
     D XCT             S             25A   DIM(ArrMax) PERRCD(1) CTDATA                       CSD015
                                                                                              CSD015
      ** Watch List Fields Array.                                                             CSD015
     D WLF             S             35A   DIM(ArrMax)                                        CSD015
                                                                                              CSD015
      ** Watch List Fields Standing Data Array.                                               CSD015
     D WLFSD           S             35A   DIM(ArrMax)                                        CSD015
                                                                                              CSD015
      ** Maturity Watch List Fields Array.                                                    CSD015
     D MWLF            S             35A   DIM(ArrMax)                                        CSD015
                                                                                              CSD015
      ** Value Watch List Fields Array.                                                       CSD015
     D VWLF            S             35A   DIM(ArrMax)                                        CSD015
                                                                                              CSD015
      ** Working Watch List Fields Array.                                                     CSD015
     D WWLF            S             35A   DIM(ArrMax)                                        CSD015
                                                                                              CIR008
      ** Switchable Feature Parameter                                                         CIR008
     D CIR008          S              1A                                                      CIR008
     D CAP056          S              1A                                                      CAP056
     D CDL028          S              1A                                                      CDL028
     D CAP051          S              1A                                                     BUG6671
                                                                                              CAP056
      ** Parameter fields when calling ZAFUTSTATP                                             CIR008
     D P_ACTN          S              1A                                                      CIR008
     D P_CSTS          S              1A                                                      CIR008
     D P_DSTS          S              1A                                                      CIR008
                                                                                              CAP056
     D PModeOfOp       S              6A                                                      CAP056
     D WkActn          S              1A                                                      CIR008

      ** Fields defined for Enhancement CSC011                                                CSC011
     D CSC011          S              1A                                                      CSC011
     D TRANSDTL        S           5800A                                                      CSC011
     D Timestamp       S             26A                                                      CSC011
     D PRtCd           S              7A                                                      CSC011
     D POptn           S              7A                                                      CSC011
     D PSard           S              6A                                                      CSC011
     D PDealNum        S             18A                                                      CSC011
     D PADealNo        S             18A                                                      CSC011
     D WDealNo         S              6A                                                      CSC011
     D PCustNo         S             10A                                                      CSD015
     D PErrInf         S              7A                                                      CSD015
                                                                                              CSC011
      ** Variables defined for CAS001                                                         CAS001
                                                                                              CAS001
     D CAS001          S              1A                                                      CAS001
                                                                                              CAS001
      ** Variables defined for CAS005                                                         CAS005
     D CAS005          S              1A                                                      CAS005
                                                                                              CAS005
      ** Index for arrays of of warning message ids etc                                       CAS005
     D WIdx            S              3P 0                                                    CAS005
                                                                                              CAS005
      ** Variables defined for CIR011                                                         CIR011
                                                                                              CIR011
     D CIR011          S              1A                                                      CIR011
                                                                                              CIR011
      ** Variables defined for CAP043                                                         CAP043
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
     D WRSCY           S              3                                                       CSD015
     D WPSCY           S              3                                                       CSD015
     D WDEN1           S             10                                                       CSD015
     D WDEN2           S             10                                                       CSD015
     D WDTP1           S             35                                                       CSD015
     D WDTP2           S             35                                                       CSD015
     D WDTP3           S             35                                                       CSD015
     D WDTP4           S             35                                                       CSD015
     D WItr            S              1  0                                                    CSD015
     D WDetFlg         S              1                                                       CSD015
     D WVDtFlg         S              1                                                       CSD015
     D WMDtFlg         S              1                                                       CSD015
                                                                                              CSD015
      ** Compliance Watch Hit List Key Fields                                                 CSD015
     D KFuncType       S              8A                                                      CSD015
     D KIden           S             40A                                                      CSD015
     D KBranch         S              3A                                                      CSD015
                                                                                              CLE025
     D CLE025          S              1A                                                      CLE025
                                                                                              CSD015
      ** WMoveMode Constants                                                                  CSD015
     D ALL             C                   CONST('A')                                         CSD015
     D CHANGED         C                   CONST('C')                                         CSD015
                                                                                              CSD015
      ** WCompMode Constants                                                                  CSD015
     D OnInsert        C                   CONST('I')                                         CSD015
     D OnAmend         C                   CONST('A')                                         CSD015
                                                                                              CSD015
     D WRK_16          S             16A                                                      CGL029
                                                                                              CGL029
      ** Define fields used in CRE020                                                         CRE020
     D CRE020          S              1A                                                      CRE020
     D KRefNo          S             30A                                                      CRE020
     D KPrgMn          S             10A   INZ('IRCIRSUPD ')                                  CRE020
     D PSysVal01       S             20A   INZ('CrossCcyIntRateSwaps')                        CRE020
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
      ** Variables defined for CAS008                                                         CAS008
     D CAS008          S              1A                                                      CAS008
     D/COPY WNCPYSRC,IRH00069
                                                                                              CAS008
      **
     D SUEINR          S             12A                                                    MD054095
     D STEINR          S             12A                                                    MD054095
      *                                                                                     MD054117
     D PCIDCF          S              1A                                                    MD054117
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************

      * EXIT IF NOT INSERTION, AMENDMENT OR REVERSAL
      ** only if CIR008 is switched off                                                       CIR008

     C                   EVAL      WLastPRDT(1) = *ZERO                                       CGL029
     C                   EVAL      WLastPRDT(2) = *ZERO                                       CGL029
     C                   EVAL      WLastPRDT(3) = *ZERO                                       CGL029
     C                   EVAL      WLastPRDT(4) = *ZERO                                       CGL029
                                                                                              CGL029
      ** Check whether user is a web browser user, if so overwrite                           BUG7095
     C                   Call      'SFC000026'                                               BUG7095
     C                   Parm      *Blanks       User             10                         BUG7095
      *                                                                                      BUG7095
     C                   If        User <> *Blanks                                           BUG7095
     C                   Eval      PSUser = User                                             BUG7095
     C                   EndIf                                                               BUG7095
                                                                                             BUG7095
     C                   IF        CIR008 = 'N'                                               CIR008
     C     RXCHTP        IFNE      'I'
     C     RXCHTP        ANDNE     'A'
     C     RXCHTP        ANDNE     'R'
     C                   RETURN
     C                   END
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
      ** Include checking of authorisation if CIR008 is switched on                           CIR008
                                                                                              CIR008
     C                   IF        CIR008 = 'Y'                                               CIR008
     C                   IF        RXCHTP <> 'I'  AND  RXCHTP <> 'A'  AND                     CIR008
     C                             RXCHTP <> 'R'  AND  RXCHTP <> 'X'                          CIR008
     C                   RETURN                                                               CIR008
     C                   ENDIF                                                                CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CIR008
      ** Save the action code                                                                 CIR008
                                                                                              CIR008
     C                   EVAL      WkActn = RXCHTP                                            CIR008
     C                   EVAL      WSCHTP = RXCHTP                                            CRE020

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
     C                             RXAUTH = 'Y'                                               CAP056
     C                             OR CAP051 = 'Y' AND RXAUTH = 'Y'                          BUG6671
     C                   EVAL      BQFIAU = 'N'                                               CAP056
     C                   EVAL      BQFIRA = 'N'                                               CAP056
     C                   ELSE                                                                 CAP056
     C                   EVAL      BQFIAU = WkFIAU                                            CAP056
     C                   EVAL      BQFIRA = WkFIRA                                            CAP056
     C                   ENDIF                                                                CAP056
                                                                                              CAP056
      * INSERT, AMEND, OR REVERSE THE DEAL
      ** or Authorise                                                                         CIR008

     C     RXCHTP        CASEQ     'I'           CIRINS
     C     RXCHTP        CASEQ     'A'           CIRAMD
     C     RXCHTP        CASEQ     'R'           CIRDEL
     C     RXCHTP        CASEQ     'X'           SrAuthorise                                  CIR008
     C                   END
     C/COPY WNCPYSRC,IRH00070

      * SET PAY/RECEIVE INDICATORS TO BE WRITTEN TO DTRIX
      ** when CIR008 is switched off or when reversing a deal                                 CIR008
      ** Or Authorisation/Re-authorisation flags are both 'N'                                 CIR008
                                                                                              CIR008
     C                   IF        RXCHTP <> *BLANKS                                          CIR008

     C                   EXSR      PYRCIN

      * WRITE A DTRIX RECORD
     C/COPY WNCPYSRC,IRCIRSDC01

     C                   EXSR      WRTDTX
     C/COPY WNCPYSRC,IRCIRSDC02

      * UPDATE THE DTRIX HEADER RECORD
     C/COPY WNCPYSRC,IRCIRSDC03

     C                   EXSR      UPDDTH
     C/COPY WNCPYSRC,IRCIRSDC04
                                                                                              CIR008
     C                   ENDIF                                                                CIR008

      ** UPDATE THE DEALS FILE TRAILER
      ** ON INSERTS AND REVERSALS

     C     RXCHTP        IFEQ      'I'
     C     RXCHTP        OREQ      'R'
     C                   EXSR      UPDTRL
     C                   END
     C/COPY WNCPYSRC,IRCIRSDC10
      *
      ** UPDATE ON-LINE POSITION FILES
      ***only*if*the*deal*is*authorised*                                              CIR008 BUG5519
      *
     C**********         IF        RXCHTP <> *BLANKS                                  CIR008 BUG5519
     C     WkActn        IFEQ      'I'                                                CIR008 BUG5519
     C     WkActn        OREQ      'A'                                                CIR008 BUG5519
     C     WkActn        OREQ      'R'                                                CIR008 BUG5519
     C                   EXSR      UPDOLP
      *
     C* CALL SUMMARY UPDATE PGM
     C*
     C                   EXSR      UPDSUP
     C                   ENDIF                                                                CIR008
                                                                                              CRE020
      ** Handle the advice index of this transaction if CRE020 is enabled.                    CRE020
                                                                                              CRE020
     C                   IF        CRE020 = 'Y' AND                                           CRE020
     C                             WSysVal01 = 'Y'                                            CRE020
     C                   EXSR      SRIdxTrn                                                   CRE020
     C                   ENDIF                                                                CRE020
      *
      ** If 24x7 Midas Availability is installed                                              CSC011
      ** and Support System is active                                                         CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
                                                                                              CSC011
     C                   CALLB     'IRCIRSLOG'                                                CSC011
     C                   PARM      *Blanks       RetCodeOut                                   CSC011
     C                   PARM                    WkActn                                       CIR008
     C                   PARM                    DEALS                                        CSC011
     C                   PARM                    DEALEXT                                      CLE025
     C                   PARM                    PLastPRDT                                    CAP043
     C                   PARM      *BLANK        RECScnFmt                                    CAP043
     C                   PARM      *BLANK        PAYScnFmt                                    CAP043
     C                   PARM      *BLANK        FRIRScnFmt                                   CAP043
     C                   PARM      *BLANK        VRECScnFmt                                   CAP043
     C                   PARM      *BLANK        VPAYScnFmt                                   CAP043
     C                   PARM      *BLANK        MRECScnFmt                                   CAP043
     C                   PARM      *BLANK        MPAYScnFmt                                   CAP043
     C                   PARM      *BLANK        InfData                                      CAP043
     C                   PARM                    TRANSDTL                                     CSC011
                                                                                              CSC011
      ** If there is no error, write the log file                                             CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut = *Blanks                                       CSC011
                                                                                              CSC011
     C                   EVAL      APTGTTYPE = 'IRCIRS'                                       CSC011
     C                   EVAL      APFOTRANID = RXFRNT                                        CSC011
     C                   EVAL      APFOASOCID = RXFRNT                                        CAP043
     C                   EVAL      APRPRLOCN  = RXREPA                                        CSC011
     C                   EVAL      APUSERID   = PSUser                                        CSC011
     C                   EVAL      APMIDUSR   = PSUser                                        CSC011
                                                                                              CSC011
     C                   MOVEL     RXDLNO        PDealNum                                     CSC011
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
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** Log transaction for additional IRC schedules (greater than 82)                       CAP043
      ** if CAP043 is on.                                                                     CAP043
                                                                                              CAP043
     C                   IF        CAP043 = 'Y'                                               CAP043
                                                                                              CAP043
     C                   CALLB     'IRIRCLOG'                                                 CAP043
     C                   PARM      *BLANK        RetCodeOut                                   CAP043
     C                   PARM      'CIRS'        PFunction                                    CAP043
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
     C                   PARM                    VRECScnFmt                                   CAP043
     C                   PARM                    VPAYScnFmt                                   CAP043
     C                   PARM                    MRECScnFmt                                   CAP043
     C                   PARM                    MPAYScnFmt                                   CAP043
     C                   PARM      AUTH          PInfData                                     CAP043
                                                                                              CAP043
     C                   IF        RetCodeOut <> *BLANK                                       CAP043
     C                   EVAL      @@RTCD = '*ERROR'                                          CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
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
     C                   MOVE      RXDLNO        MidasDlNum        6            CAP006
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
     C     RXCHTP        ANDEQ     'I'                                          168345
     C     RXFRNT        ANDNE     *BLANKS                                      168345
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
     C     RXCHTP        ANDEQ     'I'                                          CAP013
     C                   MOVE      '*FRONT'      @@MODE                         CAP006
     C                   ELSE                                                   CAP006
     C                   MOVE      *BLANKS       @@MODE                         CAP006
     C                   END                                                    CAP006
      *                                                                         168345
     C                   END                                                    168345
                                                                                CAP006
     C                   CALLB     'IRCIRSRTV'                                  CAP006
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
     C                   PARM                    RXCHTP                         CAP006
      *                                                                         CAP006
      * Front Office Transaction ID                                             CAP006
     C                   PARM      RXFRNT        FOTRID           20            CAP006
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
     C                   PARM      RXBRCA        DDBRSN            3            CAP006
                                                                                              CIR008
      ** FRA/IRS Deals Authorisation                                                          CIR008
     C                   PARM                    CIR008                                       CIR008
      *                                                                         CAP006
      * OUTPUTS                                                                 CAP006
      *                                                                         CAP006
      * (Current) deal in file format                                           CAP006
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
     C                   PARM                    CIR003                                       CIR003
     C                   PARM                    ValExtSett1                                  CIR003
     C                   PARM                    ValExtSett2                                  CIR003
     C                   PARM                    ValExtSett3                                  CIR003
                                                                                              CAS005
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CAS005
                                                                                              CAS005
     C                   PARM                    WFldNamArr                                   CAS005
     C                   PARM                    WMsgIdArr                                    CAS005
     C                   PARM                    WMsgDtaArr                                   CAS005
                                                                                              CAS005
      ** Array index (3P0) from/to caller                                                     CAS005
                                                                                              CAS005
     C                   PARM                    WIdx                                         CAS005
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
     C     CHTNLU        IFNE      RXTNLU                                       CAP006
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
     C* CIRINS  - INSERT AN IRS                                       *
     C*                                                              *
     C****************************************************************
     C     CIRINS        BEGSR

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
     C                   PARM      *BLANK        RXCHTP                                       CIR008
                                                                                              CIR008
     C                   ENDIF                                                                CIR008

      * INITIALIZE DEAL

     C                   CLEAR                   DEALS
     C                   EVAL      FSOSDT = *ZEROS                                           BUG7535
     C**********         EVAL      FSOS1B = *ZEROS                                    BUG7535 CSD103
     C                   EVAL      FSOS1B = *BLANKS                                           CSD103
     C                   EVAL      FSOS1D = *ZEROS                                           BUG7535
     C**********         EVAL      FSOS2B = *ZEROS                                    BUG7535 CSD103
     C                   EVAL      FSOS2B = *BLANKS                                           CSD103
     C                   EVAL      FSOS2D = *ZEROS                                           BUG7535
     C                   EVAL      FSOEDT = *ZEROS                                           BUG7535
     C**********         EVAL      FSOE1B = *ZEROS                                    BUG7535 CSD103
     C                   EVAL      FSOE1B = *BLANKS                                           CSD103
     C                   EVAL      FSOE1D = *ZEROS                                           BUG7535
     C**********         EVAL      FSOE2B = *ZEROS                                    BUG7535 CSD103
     C                   EVAL      FSOE2B = *BLANKS                                           CSD103
     C                   EVAL      FSOE2D = *ZEROS                                           BUG7535
     C                   EVAL      FSTSDT = *ZEROS                                           BUG7535
     C**********         EVAL      FSTS1B = *ZEROS                                    BUG7535 CSD103
     C                   EVAL      FSTS1B = *BLANKS                                           CSD103
     C                   EVAL      FSTS1D = *ZEROS                                           BUG7535
     C**********         EVAL      FSTS2B = *ZEROS                                    BUG7535 CSD103
     C                   EVAL      FSTS2B = *BLANKS                                           CSD103
     C                   EVAL      FSTS2D = *ZEROS                                           BUG7535
     C                   EVAL      FSTEDT = *ZEROS                                           BUG7535
     C**********         EVAL      FSTE1B = *ZEROS                                    BUG7535 CSD103
     C                   EVAL      FSTE1B = *BLANKS                                           CSD103
     C                   EVAL      FSTE1D = *ZEROS                                           BUG7535
     C**********         EVAL      FSTE2B = *ZEROS                                    BUG7535 CSD103
     C                   EVAL      FSTE2B = *BLANKS                                           CSD103
     C                   EVAL      FSTE2D = *ZEROS                                           BUG7535
     C                                                                                       BUG7535
     C     CIR003        IFEQ      'Y'                                                        CIR003
     C                   MOVE      *BLANKS       Z#WSTS                                       CIR003
     C                   MOVE      *BLANKS       Z#XSTS                                       CIR003
     C                   MOVE      *BLANKS       Z#YSTS                                       CIR003
     C                   MOVE      *BLANKS       Z#ZSTS                                       CIR003
     C                   ENDIF                                                                CIR003

      ** Initialise "before" status of deal for on-line updates.
      *
     C                   MOVEL     *BLANK        Z#BSTS

      * RECORD ID

     C                   MOVEL     'D'           RECI

      * DEAL NUMBER & RECORD TYPE

     C                   Z-ADD     RXDLNO        DLNO
     C                   MOVE      'G'           RCDT

      * DEAL RECORD CODE

     C                   Z-ADD     23            RCDC

      *  DEAL DETAILS

     C                   MOVE      @RXDET1       @DLDET1
     C                   MOVE      @RXDET1Ext    @DLDET1Ext                                   CGL029
     C                   MOVE      @RXDET2       @DLDET2
                                                                                              CDL028
     C                   IF        CDL028 = 'Y'                                               CDL028
     C                   MOVE      @RXDET3       @DLDET3                                      CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CAS005
      ** If CAS005 is installed, move 'Their Yield Curve' and Our/Their Forward               CAS005
      ** Yield Curve details to the file field.                                               CAS005
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      FSOFYC = RXOFYC                                            CAS005
     C                   EVAL      FSTFYC = RXTFYC                                            CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS008
      ** If CAS008 and CIR003 are installed, move Our/Their Fwd Cmt Yield Curve               CAS008
      ** to the file fields.                                                                  CAS008
                                                                                              CAS008
     C                   IF        CAS008 = 'Y' AND                                           CAS008
     C                             CIR003 = 'Y'                                               CAS008
     C                   EVAL      FSOFCC = RXOFCC                                            CAS008
     C                   EVAL      FSTFCC = RXTFCC                                            CAS008
     C                   ENDIF                                                                CAS008
      *
      ** Deal Status and Insert User                                                          CIR008
                                                                                              CIR008
     C                   IF        CIR008 = 'Y'                                               CIR008
     C                   EVAL      FIUSRI = PsUser                                            CIR008
     C                   EVAL      FIDSTS = P_DSTS                                            CIR008
     C                   ENDIF                                                                CIR008
                                                                                              CAP056
      ** Update Auto Authorisation on DEALSDG with value from Valid file                      CAP056
                                                                                              CAP056
     C                   IF        CAP056 = 'Y'                                               CAP056
     C                             OR CAP051 = 'Y'                                           BUG6671
     C                   EVAL      FIAUTH = RXAUTH                                            CAP056
     C                   ENDIF                                                                CAP056
      *
      * RECEIVE SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @RXREC        @DLREC
     C                   MOVEL     @RXRECExt     @DLRECExt                                    CGL029
      *
      * PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @RXPY1        @DLPY1
     C                   MOVEL     @RXPY1Ext     @DLPY1Ext                                    CGL029
     C                   MOVEL     @RXPY2        @DLPY2
     C                   MOVEL     @RXPY3        @DLPY3
      *
      * 'OLD' SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     RXRSTM        RSETM
     C                   MOVEL     RXRONS        URACC
      *                                                                                       200400
      ** OUR RECEIVING ACCOUNT = CUSTOMER DEFAULT ACCOUNT, IF METHOD 04                       200400
      *                                                                                       200400
     C     RXRSTM        IFEQ      04                                                         200400
     C**********         MOVEL     RXCNUM        WRK_10           10                   200400 CGL029
     C**********         MOVE      BMACCD        WRK_10                                200400 CGL029
     C**********         MOVEL     WRK_10        URACC                                 200400 CGL029
     C                   MOVEL     RXCNUM        WRK_16                                       CGL029
     C                   MOVE      BMACCD        WRK_16                                       CGL029
     C                   MOVEL     WRK_16        URACC                                        CGL029
     C                   MOVE      '01'          URACC                                        200400
     C                   ENDIF                                                                200400
      ************                                                                     179510 200400
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **File-Parameter  into the  correspondent  file  field  .                        179510 200400
      ************                                                                     179510 200400
     C*****RXRSTM*       IFEQ      04                                                  179510 200400
     C************       MOVE      RXURACC       URACC                                 179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
     C***********        MOVEL     RXAWBN        CPPBK                          CSW097
     C                   MOVEL     RXRCRN        CPPBK                          CSW097
     C                   MOVEL     RXPSTM        PSETM
     C                   MOVEL     RXPONS        UPACC
      *                                                                                       200400
      ** OUR PAYMENT ACCOUNT = CUSTOMER DEFAULT ACCOUNT, IF METHOD 04                         200400
      *                                                                                       200400
     C     RXPSTM        IFEQ      04                                                         200400
     C**********         MOVEL     RXCNUM        WRK_10           10                   200400 CGL029
     C**********         MOVE      BMACCD        WRK_10                                200400 CGL029
     C**********         MOVEL     WRK_10        UPACC                                 200400 CGL029
     C                   MOVEL     RXCNUM        WRK_16                                       CGL029
     C                   MOVE      BMACCD        WRK_16                                       CGL029
     C                   MOVEL     WRK_16        UPACC                                        CGL029
     C                   MOVE      '01'          UPACC                                        200400
     C                   ENDIF                                                                200400
      ************                                                                     179510 200400
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **File-Parameter  into the  correspondent  file  field  .                        179510 200400
      ************                                                                     179510 200400
     C*****RXPSTM*       IFEQ      04                                                  179510 200400
     C************       MOVE      RXUPACC       UPACC                                 179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
     C***********        MOVEL     RXRIBN        CPRBK                          CSW097
     C                   MOVEL     RXAWBN        CPRBK                          CSW097
     C                   MOVEL     RXBENN        FACO
     C                   MOVEL     RXBTB1        SPI
      *
      * SET UP REQUIRED FIELDS ON DEALSDG THAT WERE NOT SET UP ON
      * VALID FILE
      *
     C                   EXSR      SETREQFLDI
      *                                                                                       CIR003
     C     CIR003        IFEQ      'Y'                                                        CIR003
     C                   EXSR      UPDXSET                                                    CIR003
     C                   ENDIF                                                                CIR003
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
     C                   MOVEL     RXCLAS        CLAS                                         CDL038
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
     C/COPY WNCPYSRC,IRCIRSDC05
      *
      ** If Interest Rate Calendars feature present and data has been           CAP004
      ** input via server write dates to file                                   CAP004
     C     CIR001        IFEQ      'Y'                                          CAP004
     C     ScreenInpt    ANDNE     'Y'                                          CAP004
     C                   EXSR      WRITEIRCS                                    CAP004
     C                   END                                                    CAP004
                                                                                CAP004
      ** Call PGM/DL2900 to set up deal activity for on-line updates.
      ***only*if*the*deal*is*authorised.*Else*perform*in*SrAuthorise.*                CIR008 BUG5519
      *
     C**********         IF        RXCHTP <> *BLANKS                                  CIR008 BUG5519
     C                   MOVEL     DEALS         Z#ASTS
     C                   MOVE      RXDLNO        PDLNO
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
      *
     C**********         ENDIF                                                        CIR008 BUG5519
                                                                                              CLE025
      ** Set up deal extension file if Credit Lines is installed                              CLE025
                                                                                              CLE025
     C                   IF        CLE025 = 'Y'                                               CLE025
     C                   CLEAR                   DEALEXT                                      CLE025
     C                   MOVEL     IRVXSIR       DEALEXT                                      CLE025
     C                   MOVEL     RXDLNO        F1DLNO                                       CDL038
     C                   MOVEL     RXBRCA        F1BRCA                                       248452
     C                   WRITE     DLDLDGD0                                                   CLE025
     C                   ENDIF                                                                CLE025
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CIRAMD  - AMEND AN IRS                                        *
     C*                                                              *
     C****************************************************************
     C     CIRAMD        BEGSR
      *
      * ACCESS DEAL
      *
     C     RXDLNO        CHAIN     DEALSDGF                           99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     RXDLNO        DBKEY
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
     C                   PARM      *BLANK        RXCHTP                                       CIR008
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
     C                   EVAL      FIAUTH = RXAUTH                                            CAP056
     C                   ENDIF                                                                CAP056
      *                                                                                       CIR003
      ** If CIR003 is on, set-up 'before' status of both value and maturity                   CIR003
      ** date extra settlement.                                                               CIR003
      *                                                                                       CIR003
     C     CIR003        IFEQ      'Y'                                                        CIR003
      *                                                                                       CIR003
     C     VDEI          IFEQ      'Y'                                                        CIR003
     C     PDEI          OREQ      'Y'                                                        CIR003
     C                   MOVE      DLNO          KDLNO                                        CIR003
     C                   MOVE      'VAL'         KEDCD                                        CIR003
     C     KGXST         CHAIN(N)  DLGXSTL0                           99                      CIR003
      *                                                                                       CIR003
      **  If record is found, keep 'before' status of value date extra settl.                 CIR003
      *                                                                                       CIR003
     C     *IN99         IFEQ      '0'                                                        CIR003
     C                   MOVEL     DLGXST        Z#WSTS                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C     MDEI          IFEQ      'Y'                                                        CIR003
     C     PDEI          OREQ      'Y'                                                        CIR003
     C                   MOVE      DLNO          KDLNO                                        CIR003
     C                   MOVE      'MAT'         KEDCD                                        CIR003
     C     KGXST         CHAIN(N)  DLGXSTL0                           99                      CIR003
      *                                                                                       CIR003
      **  If record is found, keep 'before' status of maturity date extra settl.              CIR003
      *                                                                                       CIR003
     C     *IN99         IFEQ      '0'                                                        CIR003
     C                   MOVEL     DLGXST        Z#XSTS                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C                   ENDIF                                                                CIR003
      *
      ** Set up "before" status of deal for on-line updates.
      ***only*if*the*deal*is*authorised.*Else*perform*in*SrAuthorise.*                CIR008 BUG5519
      *
     C                   IF        CSD015 = 'Y'                                               CSD015
     C                   MOVEL     DEALS         WLFBC                                        CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C**********         IF        RXCHTP <> *BLANKS                                  CIR008 BUG5519
     C                   MOVEL     DEALS         Z#BSTS
     C                   MOVE      RXDLNO        PDLNO

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
     C                   MOVEL     L2CYR1        ##L2CYR1                                     235490
     C                   MOVEL     L2CYR2        ##L2CYR2                                     235490
     C                   MOVEL     L2CYR3        ##L2CYR3                                     235490
     C                   MOVEL     L2CYR4        ##L2CYR4                                     235490
     C                   MOVEL     L2CYR5        ##L2CYR5                                     235490
     C                   MOVEL     L2CYR6        ##L2CYR6                                     235490
     C                   MOVEL     L2CYR7        ##L2CYR7                                     235490
     C                   MOVEL     L2CYR8        ##L2CYR8                                     235490
     C                   MOVEL     L2CYR9        ##L2CYR9                                     235490
     C                   MOVEL     L2CYR0        ##L2CYR0                                     235490
     C                   Z-ADD     UIPBD         WUIPBD            5 0          CIR005
     C                   Z-ADD     TIPBD         WTIPBD            5 0          CIR005
     C                   Z-ADD     UNIPD         WUNIPD            5 0          CIR005
     C                   Z-ADD     TNIPD         WTNIPD            5 0          CIR005
     C                   MOVEL     L1AMCN        WL1AMC            2            CIR005
     C                   MOVEL     L2AMCN        WL2AMC            2            CIR005

     C**********         CALLB     'DL2900'                                                 AR743357
     C**********         PARM      *BLANK        PRTCD                                      AR743357
     C**********         PARM                    PDLNO                                      AR743357
     C**********         PARM      'B'           PBEAF                                      AR743357
     C                   CALLB     'DL2901'                                                 AR743357
     C                   PARM      *BLANK        PRTCD                                      AR743357
     C                   PARM                    PDLNO                                      AR743357
     C                   PARM      'B'           PBEAF                                      AR743357
      *
     C     PRTCD         IFEQ      '*ERROR'
     C**********         MOVEL     'DL2900'      DBFILE                                     AR743357
     C                   MOVEL     'DL2901'      DBFILE                                     AR743357
     C                   MOVEL     '993'         DBASE
     C                   MOVEL     *BLANK        DBKEY
     C                   EXSR      *PSSR
     C                   END
     C**********         ENDIF                                                        CIR008 BUG5519
      *
      * SET CONFIRMATION BIT ON DEAL
      * AND CONFIRMATION REQUIRED INDICATOR
      * TO BE WRITTEN TO DTRIX
      ** when CIR008 is switched off                                                          CIR008
      *
     C**********         IF        CIR008 = 'N' OR                                   CIR008 BUG6877N
     C**********                   CIR008 = 'Y' AND  BQFIRA <> 'Y'                   CIR008 BUG6877N
     C                   EXSR      CNFAMD
     C**********         ENDIF                                                       CIR008 BUG6877N
      *
      *  DEAL DETAILS

     C                   MOVE      @RXDET1       @DLDET1
     C                   MOVE      @RXDET1Ext    @DLDET1Ext                                   CGL029
     C                   MOVE      @RXDET2       @DLDET2
                                                                                              CDL028
     C                   IF        CDL028 = 'Y'                                               CDL028
     C                   MOVE      @RXDET3       @DLDET3                                      CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CAS005
      ** If CAS005 is installed, move 'Their Yield Curve' and Our/Their Forward               CAS005
      ** Yield Curve details to the file field.                                               CAS005
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      FSOFYC = RXOFYC                                            CAS005
     C                   EVAL      FSTFYC = RXTFYC                                            CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS008
      ** If CAS008 and CIR003 are installed, move Our/Their Fwd Cmt Yield Curve               CAS008
      ** to the file fields.                                                                  CAS008
                                                                                              CAS008
     C                   IF        CAS008 = 'Y' AND                                           CAS008
     C                             CIR003 = 'Y'                                               CAS008
     C                   EVAL      FSOFCC = RXOFCC                                            CAS008
     C                   EVAL      FSTFCC = RXTFCC                                            CAS008
     C                   ENDIF                                                                CAS008
      *                                                                         CIR005
      ** Business Day Conventions details (OUR)                                 CIR005
      *                                                                         CIR005
     C                   IF        CIR005 = 'Y'  AND                            CIR005
     C                             RXUNIPD = WUIPBD  AND                        CIR005
     C                             WL1AMC = 'A'  AND                            CIR005
     C                             RXAMC1 = WL1AMC                              CIR005
      *                                                                         CIR005
     C                   EVAL      UNIPD = WUNIPD                               CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
      ** Business Day Conventions details (THEIR)                               CIR005
      *                                                                         CIR005
     C                   IF        CIR005 = 'Y'  AND                            CIR005
     C                             RXTNIPD = WTIPBD  AND                        CIR005
     C                             WL2AMC = 'A'  AND                            CIR005
     C                             RXAMC2 = WL2AMC                              CIR005
      *                                                                         CIR005
     C                   EVAL      TNIPD = WTNIPD                               CIR005
     C                   ENDIF                                                  CIR005
      *
      * RECEIVE SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @RXREC        @DLREC
     C                   MOVEL     @RXRECExt     @DLRECExt                                    CGL029
      *
      * PAYMENT SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     @RXPY1        @DLPY1
     C                   MOVEL     @RXPY1Ext     @DLPY1Ext                                    CGL029
     C                   MOVEL     @RXPY2        @DLPY2
     C                   MOVEL     @RXPY3        @DLPY3
      *
      * 'OLD' SETTLEMENT INSTRUCTIONS
      *
     C                   MOVEL     RXRSTM        RSETM
     C                   MOVEL     RXRONS        URACC
      *                                                                                       200400
      ** OUR RECEIVING ACCOUNT = CUSTOMER DEFAULT ACCOUNT, IF METHOD 04                       200400
      *                                                                                       200400
     C     RXRSTM        IFEQ      04                                                         200400
     C**********         MOVEL     RXCNUM        WRK_10           10                   200400 CGL029
     C**********         MOVE      BMACCD        WRK_10                                200400 CGL029
     C**********         MOVEL     WRK_10        URACC                                 200400 CGL029
     C                   MOVEL     RXCNUM        WRK_16                                       CGL029
     C                   MOVE      BMACCD        WRK_16                                       CGL029
     C                   MOVEL     WRK_16        URACC                                        CGL029
     C                   MOVE      '01'          URACC                                        200400
     C                   ENDIF                                                                200400
      ************                                                                     179510 200400
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **File-Parameter  into the  correspondent  file  field  .                        179510 200400
      ************                                                                     179510 200400
     C*****RXRSTM*       IFEQ      04                                                  179510 200400
     C************       MOVE      RXURACC       URACC                                 179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
     C***********        MOVEL     RXAWBN        CPPBK                          CSW097
     C                   MOVEL     RXRCRN        CPPBK                          CSW097
     C                   MOVEL     RXPSTM        PSETM
     C                   MOVEL     RXPONS        UPACC
      *                                                                                       200400
      ** OUR PAYMENT ACCOUNT = CUSTOMER DEFAULT ACCOUNT, IF METHOD 04                         200400
      *                                                                                       200400
     C     RXPSTM        IFEQ      04                                                         200400
     C**********         MOVEL     RXCNUM        WRK_10           10                   200400 CGL029
     C**********         MOVE      BMACCD        WRK_10                                200400 CGL029
     C**********         MOVEL     WRK_10        UPACC                                 200400 CGL029
     C                   MOVEL     RXCNUM        WRK_16                                       CGL029
     C                   MOVE      BMACCD        WRK_16                                       CGL029
     C                   MOVEL     WRK_16        UPACC                                        CGL029
     C                   MOVE      '01'          UPACC                                        200400
     C                   ENDIF                                                                200400
      ************                                                                     179510 200400
      **For*Settlement*method*04*,*move*the*required*part*of**the****                  179510 200400
      **File-Parameter  into the  correspondent  file  field  .                        179510 200400
      ************                                                                     179510 200400
     C*****RXPSTM*       IFEQ      04                                                  179510 200400
     C************       MOVE      RXUPACC       UPACC                                 179510 200400
     C************       ENDIF                                                         179510 200400
      ************                                                                     179510 200400
     C***********        MOVEL     RXRIBN        CPRBK                          CSW097
     C                   MOVEL     RXAWBN        CPRBK                          CSW097
     C                   MOVEL     RXBENN        FACO
     C                   MOVEL     RXBTB1        SPI
      *
      * SET UP REQUIRED FIELDS ON DEALSDG THAT WERE NOT SET UP ON
      * VALID FILE
      *
     C                   EXSR      SETREQFLDA
      *                                                                                       CIR003
     C     CIR003        IFEQ      'Y'                                                        CIR003
     C                   EXSR      UPDXSET                                                    CIR003
     C                   ENDIF                                                                CIR003
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
     C                   MOVEL     RXCLAS        CLAS                                         CDL038
      *
      * UPDATE DEAL
      *
     C                   UPDATE    DEALSDGF
     C/COPY WNCPYSRC,IRCIRSDC06
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
      ***only*if*the*deal*is*authorised.*Else*perform*in*SrAuthorise.*                CIR008 BUG5519
      *
     C**********         IF        RXCHTP <> *BLANKS                                  CIR008 BUG5519
     C                   MOVEL     DEALS         Z#ASTS
     C                   MOVE      RXDLNO        PDLNO
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
     C**********         ENDIF                                                        CIR008 BUG5519
                                                                                              CLE025
      ** Set up deal extension file is Credit Lines is installed                              CLE025
                                                                                              CLE025
     C                   IF        CLE025 = 'Y'                                               CLE025
                                                                                              CLE025
     C                   MOVEL     RXDLNO        PDLNO                                        CLE025
     C     PDLNO         CHAIN     DLDLDGD0                           01                      CLE025
     C                   IF        *IN01                                                      CLE025
     C                   MOVEL     RXDLNO        DBKEY                                        CLE025
     C                   MOVEL     'DLDLDGQD'    DBFILE                                       CLE025
     C                   MOVEL     '002'         DBASE                                        CLE025
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
     C****************************************************************                        CIR003
     C*                                                              *                        CIR003
     C* UPDXSET - Update Extra Settlement details                    *                        CIR003
     C*                                                              *                        CIR003
     C****************************************************************                        CIR003
     C     UPDXSET       BEGSR                                                                CIR003
      *                                                                                       CIR003
      ** Clear the XST Data Stores if CSD015 is enabled.                                      CSD015
      *                                                                                       CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
     C                   CLEAR                   MXST                                         CSD015
     C                   CLEAR                   VXST                                         CSD015
     C                   CLEAR                   MXSTBC                                       CSD015
     C                   CLEAR                   VXSTBC                                       CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C*****RXCHTP        IFEQ      'I'                                                 CIR003 CIR008
     C                   IF        WkActn = 'I'                                               CIR008
      *                                                                                       CIR003
      ** If Insert, process insert request for extra settlement                               CIR003
      *                                                                                       CIR003
     C     ValExtSettV   IFNE      *BLANK                                                     CIR003
     C     VDEI          ANDEQ     'Y'                                                        CIR003
     C     ValExtSettV   ORNE      *BLANK                                                     CIR003
     C     PDEI          ANDEQ     'Y'                                                        CIR003
     C**********         MOVEL     ValExtSettV   DLGXST                                CIR003 CGL029
     C                   EVAL      %SUBST(DLGXST:1:11) =                                      CGL029
     C                             %SUBST(ValExtSettV:1:11)                                   CGL029
     C                   EVAL      GXRXRONS = E1RXRONS                                        CGL029
     C                   EVAL      %SUBST(DLGXST:24:63) =                                     CGL029
     C                             %SUBST(ValExtSettV:30:63)                                  CGL029
     C                   EVAL      GXRXPONS = E1RXPONS                                        CGL029
     C                   EVAL      %SUBST(DLGXST:99:1205) =                                   CGL029
     C                             %SUBST(ValExtSettV:111:1205)                               CGL029
                                                                                              CGL029
      ** Since ValExtSettV has been moved to DLGXST, and ValExtSettV has                      CGL029
      ** different format from that of DLGXST, this line is amended to                        CGL029
      ** move the value of DLGXST to Z#YSTS instead of moving ValExtSettV,                    CGL029
      ** so that Z#YSTS will have consistent format in this module with                       CGL029
      ** Z#YSTS in AOOUSWU0 module                                                            CGL029
     C**********         MOVEL     ValExtSettV   Z#YSTS                                CIR003 CGL029
     C                   MOVEL     DLGXST        Z#YSTS                                       CGL029
      *                                                                                       CSD015
      ** Save the Value XST Details if CSD015 is enabled.                                     CSD015
      *                                                                                       CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
     C                   MOVEL     DLGXST        VXST                                         CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   WRITE     DLGXSTD0                                                   CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C     ValExtSettI   IFNE      *BLANK                                                     CIR003
     C**********         MOVEL     ValExtSettI   DLGXST                                CIR003 CGL029
     C                   EVAL      %SUBST(DLGXST:1:11) =                                      CGL029
     C                             %SUBST(ValExtSettI:1:11)                                   CGL029
     C                   EVAL      GXRXRONS = E2RXRONS                                        CGL029
     C                   EVAL      %SUBST(DLGXST:24:63) =                                     CGL029
     C                             %SUBST(ValExtSettI:30:63)                                  CGL029
     C                   EVAL      GXRXPONS = E2RXPONS                                        CGL029
     C                   EVAL      %SUBST(DLGXST:99:1205) =                                   CGL029
     C                             %SUBST(ValExtSettI:111:1205)                               CGL029
     C                   WRITE     DLGXSTD0                                                   CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C     ValExtSettM   IFNE      *BLANK                                                     CIR003
     C     MDEI          ANDEQ     'Y'                                                        CIR003
     C     ValExtSettM   ORNE      *BLANK                                                     CIR003
     C     PDEI          ANDEQ     'Y'                                                        CIR003
     C**********         MOVEL     ValExtSettM   DLGXST                                CIR003 CGL029
     C                   EVAL      %SUBST(DLGXST:1:11) =                                      CGL029
     C                             %SUBST(ValExtSettM:1:11)                                   CGL029
     C                   EVAL      GXRXRONS = E3RXRONS                                        CGL029
     C                   EVAL      %SUBST(DLGXST:24:63) =                                     CGL029
     C                             %SUBST(ValExtSettM:30:63)                                  CGL029
     C                   EVAL      GXRXPONS = E3RXPONS                                        CGL029
     C                   EVAL      %SUBST(DLGXST:99:1205) =                                   CGL029
     C                             %SUBST(ValExtSettM:111:1205)                               CGL029
                                                                                              CGL029
      ** Since ValExtSettM has been moved to DLGXST, and ValExtSettM has                      CGL029
      ** different format from that of DLGXST, this line is amended to                        CGL029
      ** move the value of DLGXST to Z#YSTS instead of moving ValExtSettM,                    CGL029
      ** so that Z#YSTS will have consistent format in this module with                       CGL029
      ** Z#YSTS in AOOUSWU0 module                                                            CGL029
     C**********         MOVEL     ValExtSettM   Z#ZSTS                                CIR003 CGL029
     C                   MOVEL     DLGXST        Z#ZSTS                                       CGL029
      *                                                                                       CSD015
      ** Save the Maturity XST Details if CSD015 is enabled.                                  CSD015
      *                                                                                       CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
     C                   MOVEL     DLGXST        MXST                                         CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   WRITE     DLGXSTD0                                                   CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C*****RXCHTP        IFEQ      'A'                                                 CIR003 CIR008
     C                   IF        WkActn = 'A'                                               CIR008
      *                                                                                       CIR003
      ** If Amend, process amend request for extra settlement                                 CIR003
      *                                                                                       CIR003
     C                   MOVE      *BLANKS       Z#YSTS                                       CIR003
     C                   MOVE      *BLANKS       Z#ZSTS                                       CIR003
     C                   MOVE      ' '           WAMDS             1                          236776
      *                                                                                       CIR003
     C     ValExtSettV   IFNE      *BLANK                                                     CIR003
     C     VDEI          ANDEQ     'Y'                                                        CIR003
     C     ValExtSettV   ORNE      *BLANK                                                     CIR003
     C     PDEI          ANDEQ     'Y'                                                        CIR003
      *                                                                                       CIR003
     C                   MOVE      DLNO          KDLNO                                        CIR003
     C                   MOVE      'VAL'         KEDCD                                        CIR003
     C     KGXST         CHAIN     DLGXSTL0                           99                      CIR003
      *                                                                                       CIR003
      **  If record is found, keep 'before' status of value date extra settl.                 CIR003
      *                                                                                       CIR003
     C     *IN99         IFEQ      '0'                                                        CIR003
     C                   MOVEL     DLGXST        Z#WSTS                                       CIR003
      *                                                                                       CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
     C                   MOVEL     DLGXST        VXSTBC                                       CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C**********         MOVEL     ValExtSettV   DLGXST                                CIR003 CGL029
     C                   EVAL      %SUBST(DLGXST:1:11) =                                      CGL029
     C                             %SUBST(ValExtSettV:1:11)                                   CGL029
     C                   EVAL      GXRXRONS = E1RXRONS                                        CGL029
     C                   EVAL      %SUBST(DLGXST:24:63) =                                     CGL029
     C                             %SUBST(ValExtSettV:30:63)                                  CGL029
     C                   EVAL      GXRXPONS = E1RXPONS                                        CGL029
     C                   EVAL      %SUBST(DLGXST:99:1205) =                                   CGL029
     C                             %SUBST(ValExtSettV:111:1205)                               CGL029
      *                                                                                       CSD015
      ** Save the Value XST Details if CSD015 is enabled.                                     CSD015
      *                                                                                       CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
     C                   MOVEL     DLGXST        VXST                                         CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CIR003
     C     *IN99         IFEQ      '1'                                                        CIR003
     C                   WRITE     DLGXSTD0                                                   CIR003
     C                   ELSE                                                                 CIR003
     C                   UPDATE    DLGXSTD0                                                   CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       235567
      ** Keep copy of "before" values in DLGXSBPD.                                            235567
      *                                                                                       235567
     C     KGXST         CHAIN     DLGXSBL0                           97                      235567
     C                   MOVEL     Z#WSTS        DLGXSB                                       235567
     C     *IN97         IFEQ      '1'                                                        235567
     C                   WRITE     DLGXSBD0                                                   235567
     C                   ELSE                                                                 235567
     C                   UPDATE    DLGXSBD0                                                   235567
     C                   ENDIF                                                                235567
      *                                                                                       CIR003
      ** Keep 'after' status of value date extra settlement record.                           CIR003
      *                                                                                       CIR003
      ** Since ValExtSettV has been moved to DLGXST, and ValExtSettV has                      CGL029
      ** different format from that of DLGXST, this line is amended to                        CGL029
      ** move the value of DLGXST to Z#YSTS instead of moving ValExtSettV,                    CGL029
      ** so that Z#YSTS will have consistent format in this module with                       CGL029
      ** Z#YSTS in AOOUSWU0 module                                                            CGL029
     C**********         MOVEL     ValExtSettV   Z#YSTS                                CIR003 CGL029
     C                   MOVEL     DLGXST        Z#YSTS                                       CGL029
      *                                                                                       236776
      ** Check if pay/rcv message needs to be regenerated for pricipal                        236776
      ** change.                                                                              236776
      *                                                                                       236776
     C     PDEI          IFEQ      'Y'                                                        236776
     C     Z#WSTS        ANDNE     Z#YSTS                                                     236776
     C                   MOVE      'V'           WAMDS                                        236776
     C                   EXSR      SRGenMsg                                                   236776
     C                   ENDIF                                                                236776
      *                                                                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C     ValExtSettI   IFNE      *BLANK                                                     CIR003
     C                   MOVE      DLNO          KDLNO                                        CIR003
     C                   MOVE      'INT'         KEDCD                                        CIR003
     C     KGXST         CHAIN     DLGXSTL0                           99                      CIR003
     C**********         MOVEL     ValExtSettI   DLGXST                                CIR003 CGL029
     C                   EVAL      %SUBST(DLGXST:1:11) =                                      CGL029
     C                             %SUBST(ValExtSettI:1:11)                                   CGL029
     C                   EVAL      GXRXRONS = E2RXRONS                                        CGL029
     C                   EVAL      %SUBST(DLGXST:24:63) =                                     CGL029
     C                             %SUBST(ValExtSettI:30:63)                                  CGL029
     C                   EVAL      GXRXPONS = E2RXPONS                                        CGL029
     C                   EVAL      %SUBST(DLGXST:99:1205) =                                   CGL029
     C                             %SUBST(ValExtSettI:111:1205)                               CGL029
      *                                                                                       CIR003
     C     *IN99         IFEQ      '1'                                                        CIR003
     C                   WRITE     DLGXSTD0                                                   CIR003
     C                   ELSE                                                                 CIR003
     C                   UPDATE    DLGXSTD0                                                   CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C     ValExtSettM   IFNE      *BLANK                                                     CIR003
     C     MDEI          ANDEQ     'Y'                                                        CIR003
     C     ValExtSettM   ORNE      *BLANK                                                     CIR003
     C     PDEI          ANDEQ     'Y'                                                        CIR003
     C                   MOVE      DLNO          KDLNO                                        CIR003
     C                   MOVE      'MAT'         KEDCD                                        CIR003
     C     KGXST         CHAIN     DLGXSTL0                           99                      CIR003
      *                                                                                       CIR003
      **  If record is found, keep 'before' status of maturity date extra settl.              CIR003
      *                                                                                       CIR003
     C     *IN99         IFEQ      '0'                                                        CIR003
     C                   MOVEL     DLGXST        Z#XSTS                                       CIR003
      *                                                                                       CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
     C                   MOVEL     DLGXST        MXSTBC                                       CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C**********         MOVEL     ValExtSettM   DLGXST                                CIR003 CGL029
     C                   EVAL      %SUBST(DLGXST:1:11) =                                      CGL029
     C                             %SUBST(ValExtSettM:1:11)                                   CGL029
     C                   EVAL      GXRXRONS = E3RXRONS                                        CGL029
     C                   EVAL      %SUBST(DLGXST:24:63) =                                     CGL029
     C                             %SUBST(ValExtSettM:30:63)                                  CGL029
     C                   EVAL      GXRXPONS = E3RXPONS                                        CGL029
     C                   EVAL      %SUBST(DLGXST:99:1205) =                                   CGL029
     C                             %SUBST(ValExtSettM:111:1205)                               CGL029
      *                                                                                       CSD015
      ** Save the Maturity XST Details if CSD015 is enabled.                                  CSD015
      *                                                                                       CSD015
     C                   IF        CSD015 = 'Y'                                               CSD015
     C                   MOVEL     DLGXST        MXST                                         CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CIR003
     C     *IN99         IFEQ      '1'                                                        CIR003
     C                   WRITE     DLGXSTD0                                                   CIR003
     C                   ELSE                                                                 CIR003
     C                   UPDATE    DLGXSTD0                                                   CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
      ** Keep 'after' status of value date extra settlement record.                           CIR003
      *                                                                                       CIR003
      ** Since ValExtSettM has been moved to DLGXST, and ValExtSettM has                      CGL029
      ** different format from that of DLGXST, this line is amended to                        CGL029
      ** move the value of DLGXST to Z#YSTS instead of moving ValExtSettM,                    CGL029
      ** so that Z#YSTS will have consistent format in this module with                       CGL029
      ** Z#YSTS in AOOUSWU0 module                                                            CGL029
     C**********         MOVEL     ValExtSettM   Z#ZSTS                                CIR003 CGL029
     C                   MOVEL     DLGXST        Z#ZSTS                                       CGL029
      *                                                                                       236776
      ** Check if pay/rcv message needs to be regenerated for pricipal                        236776
      ** change.                                                                              236776
      *                                                                                       236776
     C     PDEI          IFEQ      'Y'                                                        236776
     C     Z#XSTS        ANDNE     Z#ZSTS                                                     236776
     C                   MOVE      'M'           WAMDS                                        236776
     C                   EXSR      SrGenMsg                                                   236776
     C                   ENDIF                                                                236776
      *                                                                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C*****RXCHTP        IFEQ      'R'                                               CIR003 AR743357
     C     WkActn        IFEQ      'R'                                                      AR743357
      *                                                                                       CIR003
      ** If reverse, keep 'after' status for both value and maturity date                     CIR003
      ** extra settlement records.                                                            CIR003
      *                                                                                       CIR003
     C                   MOVE      *BLANKS       Z#YSTS                                       CIR003
     C                   MOVE      *BLANKS       Z#ZSTS                                       CIR003
      *                                                                                       CIR003
     C                   MOVE      DLNO          KDLNO                                        CIR003
     C                   MOVE      'VAL'         KEDCD                                        CIR003
     C     KGXST         CHAIN     DLGXSTL0                           99                      CIR003
      *                                                                                       CIR003
      **  If record is found, keep 'before' status of value date extra settl.                 CIR003
      *                                                                                       CIR003
     C     *IN99         IFEQ      '0'                                                        CIR003
     C                   MOVEL     DLGXST        Z#WSTS                                       CIR003
     C                   MOVEL     DLGXST        Z#YSTS                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C                   MOVE      DLNO          KDLNO                                        CIR003
     C                   MOVE      'MAT'         KEDCD                                        CIR003
     C     KGXST         CHAIN     DLGXSTL0                           99                      CIR003
      *                                                                                       CIR003
      **  If record is found, keep 'before' status of value date extra settl.                 CIR003
      *                                                                                       CIR003
     C     *IN99         IFEQ      '0'                                                        CIR003
     C                   MOVEL     DLGXST        Z#XSTS                                       CIR003
     C                   MOVEL     DLGXST        Z#ZSTS                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C                   ENDSR                                                                CIR003
     C****************************************************************                        CIR003
      /EJECT                                                                                  CIR003
     C****************************************************************
     C*                                                              *
     C* CIRDEL  - DELETE AN IRS                                      *
     C*                                                              *
     C****************************************************************
     C     CIRDEL        BEGSR
      *
      * ACCESS DEAL
      *
     C     RXDLNO        CHAIN     DEALSDGF                           99
      *
      ** DATABASE ERROR
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     RXDLNO        DBKEY
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
     C                   PARM      *BLANK        RXCHTP                                       CIR008
                                                                                              CIR008
     C                   ENDIF                                                                CIR008
      *
      ** Set up "before" status of deal for on-line updates.
      ***only*if*the*deal*is*authorised.*Else*perform*in*SrAuthorise.*                CIR008 BUG5519
      *
     C**********         IF        RXCHTP <> *BLANKS                                  CIR008 BUG5519
     C                   MOVEL     IRVCIRS       Z#BSTS
     C                   MOVE      RXDLNO        PDLNO

     C**********         CALLB     'DL2900'                                                 AR743357
     C**********         PARM      *BLANK        PRTCD                                      AR743357
     C**********         PARM                    PDLNO                                      AR743357
     C**********         PARM      'B'           PBEAF                                      AR743357
     C                   CALLB     'DL2901'                                                 AR743357
     C                   PARM      *BLANK        PRTCD                                      AR743357
     C                   PARM                    PDLNO                                      AR743357
     C                   PARM      'B'           PBEAF                                      AR743357
      *
     C     PRTCD         IFEQ      '*ERROR'
     C**********         MOVEL     'DL2900'      DBFILE                                     AR743357
     C                   MOVEL     'DL2901'      DBFILE                                     AR743357
     C                   MOVEL     '995'         DBASE
     C                   MOVEL     *BLANK        DBKEY
     C                   EXSR      *PSSR
     C                   END
     C**********         ENDIF                                                        CIR008 BUG5519
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
     C**********         EVAL      CHTP = RXCHTP                                      CIR008 BUG5519
     C                   MOVE      'R'           CHTP                                        BUG5519
      *
      * Set Transaction No. of Last Update                                      CAP006
     C                   ADD       1             TNLU                           CAP006
      *                                                                         CAP013
      ** Front office transaction ID                                            CAP013
      *                                                                         CAP013
     C                   MOVEL     RXFRNT        FRNT                           CAP013
      *
     C     CIR003        IFEQ      'Y'                                                        CIR003
     C                   EXSR      UPDXSET                                                    CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C                   UPDATE    DEALSDGF
     C/COPY WNCPYSRC,IRCIRSDC07

      ** If Interest Rate Calendars feature present and data has been           CAP004
      ** input via server clear dates from file.                                CAP004
     C     CIR001        IFEQ      'Y'                                          CAP004
     C     ScreenInpt    ANDNE     'Y'                                          CAP004
     C                   EXSR      CLEARIRCS                                    CAP004
     C                   END                                                    CAP004
                                                                                CAP004
      ** Call PGM/DL2900 to set up deal activity for on-line updates.
      ***only*if*the*deal*is*authorised.*Else*perform*in*SrAuthorise.*                CIR008 BUG5519
      *
     C**********         IF        RXCHTP <> *BLANKS                                  CIR008 BUG5519
     C                   MOVEL     DEALS         Z#ASTS
     C                   MOVE      RXDLNO        PDLNO
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
     C**********         ENDIF                                                        CIR008 BUG5519
      *
     C                   ENDSR
      *****************************************************************                       CIR008
      /EJECT                                                                                  CIR008
      *****************************************************************                       CIR008
      *                                                               *                       CIR008
      * SrAuthorise - Authorise an IRS                                *                       CIR008
      *                                                               *                       CIR008
      *****************************************************************                       CIR008
     C     SRAuthorise   BEGSR                                                                CIR008
                                                                                              CIR008
      ** Access Deal                                                                          CIR008
                                                                                              CIR008
     C     RXDLNO        CHAIN     DEALSDGF                           89                      CIR008
                                                                                              CIR008
      ** Database Error                                                                       CIR008
                                                                                              CIR008
     C                   IF        *IN89 = *ON                                                CIR008
     C                   MOVE      RXDLNO        DBKEY                                        CIR008
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
     C                   PARM      *BLANK        RXCHTP                                       CIR008
                                                                                              CIR008
     C                   EVAL      CHTP = RXCHTP                                              CIR008
                                                                                              CIR008
      ** Authorise User                                                                       217684
     C                   EVAL      FIUSRX = PsUser                                            217684
                                                                                              217684
      ** Last change date                                                                     CIR008
                                                                                              CIR008
     C                   Z-ADD     BJRDNB        LCD                                          CIR008
                                                                                              CIR008
      ***Set*up*"before"*status*of*deal*for*on-line*updates,*                         CIR008 BUG5519
      ***for*Amends*and*Deletes*                                                      CIR008 BUG5519
                                                                                              CIR008
     C**********         IF        RXCHTP = 'A' OR RXCHTP = 'R'                       CIR008 BUG5519
     C**********         MOVEL     DEALS         Z#BSTS                               CIR008 BUG5519
     C**********         MOVE      RXDLNO        PDLNO                                CIR008 BUG5519
                                                                                              CIR008
     C**********         CALLB     'DL2900'                                           CIR008 BUG5519
     C**********         PARM      *BLANK        PRTCD                                CIR008 BUG5519
     C**********         PARM                    PDLNO                                CIR008 BUG5519
     C**********         PARM      'B'           PBEAF                                CIR008 BUG5519
      *                                                                                       CIR008
     C**********         IF        PRTCD = '*ERROR'                                   CIR008 BUG5519
     C**********         EVAL      DBFILE = 'DL2900'                                  CIR008 BUG5519
     C**********         EVAL      DBASE = 997                                        CIR008 BUG5519
     C**********         MOVEL     *BLANK        DBKEY                                CIR008 BUG5519
     C**********         EXSR      *PSSR                                              CIR008 BUG5519
     C**********         ENDIF                                                        CIR008 BUG5519
     C**********         ENDIF                                                        CIR008 BUG5519
                                                                                              CIR008
      **  Update Record                                                                       CIR008
                                                                                              CIR008
     C                   UPDATE    DEALSDGF                                                   CIR008
                                                                                              CIR008
      ***Set*up*"after"*status*of*deal*for*on-line*updates*                           CIR008 BUG5519
                                                                                              CIR008
     C**********         MOVEL     DEALS         Z#ASTS                               CIR008 BUG5519
     C**********         MOVE      RXDLNO        PDLNO                                CIR008 BUG5519
                                                                                              CIR008
     C**********         CALLB     'DL2900'                                           CIR008 BUG5519
     C**********         PARM      *BLANK        PRTCD                                CIR008 BUG5519
     C**********         PARM                    PDLNO                                CIR008 BUG5519
     C**********         PARM      'A'           PBEAF                                CIR008 BUG5519
      *                                                                                       CIR008
     C**********         IF        PRTCD = '*ERROR'                                   CIR008 BUG5519
     C**********         EVAL      DBFILE = 'DL2900'                                  CIR008 BUG5519
     C**********         EVAL      DBASE = 998                                        CIR008 BUG5519
     C**********         MOVEL     *BLANK        DBKEY                                CIR008 BUG5519
     C**********         EXSR      *PSSR                                              CIR008 BUG5519
     C**********         ENDIF                                                        CIR008 BUG5519
      *                                                                                       235567
      ** Initialise values of BefRevVal and AftRecVal for                                     235567
      ** Pay/Rcv message processing.                                                          235567
      *                                                                                       235567
     C     CIR003        IFEQ      'Y'                                                        235567
     C     VDEI          ANDEQ     'Y'                                                        235567
     C     RXCHTP        ANDEQ     'A'                                                        235567
      *                                                                                       235567
     C                   MOVE      *BLANKS       Z#WSTS                                       235567
     C                   MOVE      *BLANKS       Z#YSTS                                       235567
     C                   MOVE      DLNO          KDLNO                                        235567
     C                   MOVE      'VAL'         KEDCD                                        235567
      *                                                                                       235567
     C     KGXST         CHAIN(N)  DLGXSBL0                           99                      235567
      *                                                                                       235567
      **  If record is found, keep 'before' status of value date extra                        235567
      **  settlement.  Take values from backup file DLGXSBPD.                                 235567
      *                                                                                       235567
     C     *IN99         IFEQ      '0'                                                        235567
     C                   MOVEL     DLGXSB        Z#WSTS                                       235567
     C                   ENDIF                                                                235567
      *                                                                                       235567
     C     KGXST         CHAIN(N)  DLGXSTL0                           99                      235567
      *                                                                                       235567
      **  If record is found, keep 'after' status of value date extra                         235567
      **  settlement.  Since this is authorisation, DLGXSTPD already                          235567
      **  contains new values.                                                                235567
      *                                                                                       235567
     C     *IN99         IFEQ      '0'                                                        235567
     C                   MOVEL     DLGXST        Z#YSTS                                       235567
     C                   ENDIF                                                                235567
      *                                                                                       235567
     C                   ENDIF                                                                235567
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
      ** Our/Their effective interest rate
      *
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      FSUEFR = RXUEINR                                           CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C*****RXUBRTT       IFEQ      *ZEROS                                                     CSD103
     C     RXUBRTT       IFEQ      *BLANKS                                                    CSD103
     C                   Z-ADD     URTSP         UEINR
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      FSUEFR = URTSP                                             CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   END
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      FSTEFR = RXTEINR                                           CAS005
     C                   ENDIF                                                                CAS005
      *
     C*****RXTBRTT       IFEQ      *ZEROS                                                     CSD103
     C     RXTBRTT       IFEQ      *BLANKS                                                    CSD103
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
     C*****RXUBRTT       IFEQ      *ZEROS                                                     CSD103
     C     RXUBRTT       IFEQ      *BLANKS                                                    CSD103
      *
     C                   Z-ADD     0             UINFD
     C                   ELSE
      *
      * User pays Floating Rate, Counterparty pays Fixed Rate
     C*****RXUFRFD       IFEQ      *ZEROS
     C*****BJLCCY        IFEQ      BLCYCD
     C*****RXUCUCY       ANDEQ     BLCYCD
     C*******            Z-ADD     0             UFRFD
     C*******            ELSE
     C*******            Z-ADD     2             UFRFD
     C*******            END
     C*******            END
                                                                                              CIR011
      ** Our Floating Rate Fix Days will be adjusted if CIR011 is ON.                         CIR011
                                                                                              CIR011
     C     CIR011        IFEQ      'Y'                                                        CIR011
     C     RXUICFR       ANDNE     'O'                                                        CIR011
     C                   MOVE      RXUCUCY       ##CUCY                                       CIR011
     C                   EXSR      ACSDCY                                                     CIR011
     C                   SUB       A6FXDY        UFRFD                                        CIR011
     C                   ENDIF                                                                CIR011
     C/COPY WNCPYSRC,IRCIRSDC11
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
     C                   MOVE      RXUCUCY       ZCCY
     C                   ENDIF
     C*
     C                   MOVE      *BLANKS       ZLOC
      *                                                                         CIR005
      ** Use Rate Fixing Currencies to get rate fixing date when                CIR005
      ** CIR005 is on. Otherwise, use transaction ccy.                          CIR005
      *                                                                         CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C     RXC1R1        ANDNE     *BLANKS                                      CIR005
     C                   Z-ADD     ZRFDY         PRFDY             2 0          CIR005
     C                   CALLB     'IRRTFXCNV'                                  CIR005
     C                   PARM                    ZINDT                          CIR005
     C                   PARM                    PRFDY                          CIR005
     C                   PARM                    ZLOC                           CIR005
     C                   PARM                    OURCCY                         CIR005
     C                   PARM                    ZRFDT                          CIR005
     C                   ELSE                                                   CIR005
     C                   EXSR      DLBACK
     C                   ENDIF                                                  CIR005
      *
      **  If deal forward-valued AND Short Term Rate NOT entered then
      **  the Next Interest Rate Fix Date must be that associated
      *   with the Value Date...
     C     ZRFDT         IFGE      BJRDNB
     C     RXUEINR       ANDEQ     *ZEROS
     C                   Z-ADD     ZRFDT         UINFD
      *
      **  ...else the Next Interest Rate Fix Date must be that
      **  associated with the Next Rate Change Date.
     C                   ELSE
     C     RXUNICD       IFNE      *ZEROS
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
     C                   MOVE      RXUCUCY       ZCCY
     C                   ENDIF
     C*
     C                   MOVE      *BLANKS       ZLOC
      *                                                                         CIR005
      ** Use Rate Fixing Currencies to get rate fixing date when                CIR005
      ** CIR005 is on. Otherwise, use transaction ccy.                          CIR005
      *                                                                         CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C     RXC1R1        ANDNE     *BLANKS                                      CIR005
     C                   Z-ADD     ZRFDY         PRFDY                          CIR005
     C                   CALLB     'IRRTFXCNV'                                  CIR005
     C                   PARM                    ZINDT                          CIR005
     C                   PARM                    PRFDY                          CIR005
     C                   PARM                    ZLOC                           CIR005
     C                   PARM                    OURCCY                         CIR005
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
     C*****RXTBRTT       IFEQ      *ZEROS                                                     CSD103
     C     RXTBRTT       IFEQ      *BLANKS                                                    CSD103

     C                   Z-ADD     0             TINFD
     C                   ELSE
      *
     C*****RXTFRFD       IFEQ      *ZEROS
     C*****BJLCCY        IFEQ      BLCYCD
     C*****RXTCUCY       ANDEQ     BLCYCD
     C*******            Z-ADD     0             TFRFD
     C*******            ELSE
     C*******            Z-ADD     2             TFRFD
     C*******            END
     C*******            END
      *
      ** Their Floating Rate Fix Days will be adjusted if CIR011 is ON.                       CIR011
      *                                                                                       CIR011
     C     CIR011        IFEQ      'Y'                                                        CIR011
     C     RXTICFR       ANDNE     'O'                                                        CIR011
     C                   MOVE      RXTCUCY       ##CUCY                                       CIR011
     C                   EXSR      ACSDCY                                                     CIR011
     C                   SUB       A6FXDY        TFRFD                                        CIR011
     C                   ENDIF                                                                CIR011
                                                                                              CIR011
     C/COPY WNCPYSRC,IRCIRSDC12
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
     C                   MOVE      RXTCUCY       ZCCY
     C                   ENDIF
     C*
     C                   MOVE      *BLANKS       ZLOC
      *                                                                         CIR005
      ** Use Rate Fixing Currencies to get rate fixing date when                CIR005
      ** CIR005 is on. Otherwise, use transaction ccy.                          CIR005
      *                                                                         CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C     RXC1R2        ANDNE     *BLANKS                                      CIR005
     C                   Z-ADD     ZRFDY         PRFDY                          CIR005
     C                   CALLB     'IRRTFXCNV'                                  CIR005
     C                   PARM                    ZINDT                          CIR005
     C                   PARM                    PRFDY                          CIR005
     C                   PARM                    ZLOC                           CIR005
     C                   PARM                    THRCCY                         CIR005
     C                   PARM                    ZRFDT                          CIR005
     C                   ELSE                                                   CIR005
     C                   EXSR      DLBACK
     C                   ENDIF                                                  CIR005
      *
      **  If deal forward-valued AND Short Term Rate NOT entered then
      **  the Next Interest Rate Fix Date must be that associated
      *   with the Value Date...
     C     ZRFDT         IFGE      BJRDNB
     C     RXTEINR       ANDEQ     *ZEROS
     C                   Z-ADD     ZRFDT         TINFD
     C                   ELSE
      *
      **  ...else the Next Interest Rate Fix Date must be that
      **  associated with the Next Rate Change Date.
     C     RXTNICD       IFNE      *ZEROS
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
     C                   MOVE      RXTCUCY       ZCCY
     C                   ENDIF
     C*
     C                   MOVE      *BLANKS       ZLOC
      *                                                                         CIR005
      ** Use Rate Fixing Currencies to get rate fixing date when                CIR005
      ** CIR005 is on. Otherwise, use transaction ccy.                          CIR005
      *                                                                         CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C     RXC1R2        ANDNE     *BLANKS                                      CIR005
     C                   Z-ADD     ZRFDY         PRFDY                          CIR005
     C                   CALLB     'IRRTFXCNV'                                  CIR005
     C                   PARM                    ZINDT                          CIR005
     C                   PARM                    PRFDY                          CIR005
     C                   PARM                    ZLOC                           CIR005
     C                   PARM                    THRCCY                         CIR005
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

      *                                                                        CPL002
      * Our/Their Last Rate Change Date                                        CPL002
     C                   Z-ADD     VDAT          PLULRC                        CPL002
     C                   Z-ADD     VDAT          PLTLRC                        CPL002
      *                                                                        CPL002
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
     C     RXUBCXR       IFEQ      *ZEROS
     C                   MOVE      RXUCUCY       ##CUCY            3
     C                   EXSR      ACSDCY
     C                   Z-ADD     A6SPRT        UBCXR
     C                   END
      *
     C     RXTBCXR       IFEQ      *ZEROS
     C                   MOVE      RXTCUCY       ##CUCY            3
     C                   EXSR      ACSDCY
     C                   Z-ADD     A6SPRT        TBCXR
     C                   END
      *
      * Interest Accrual Control Date
     C                   Z-ADD     VDAT          UIACD
     C                   Z-ADD     VDAT          TIACD

      * Last Interest Payment/Change Date
     C*****RXUBRTT       IFEQ      *ZEROS                                                     CSD103
     C     RXUBRTT       IFEQ      *BLANKS                                                    CSD103
     C                   Z-ADD     0             ULPCD
     C                   ELSE
     C                   Z-ADD     VDAT          ULPCD
     C                   END
      *
     C*****RXTBRTT       IFEQ      *ZEROS                                                     CSD103
     C     RXTBRTT       IFEQ      *BLANKS                                                    CSD103
     C                   Z-ADD     0             TLPCD
     C                   ELSE
     C                   Z-ADD     VDAT          TLPCD
     C                   END
      *
      * Spread Indicators
     C*****RXUBRTT       IFNE      *ZEROS                                                     CSD103
     C     RXUBRTT       IFNE      *BLANKS                                                    CSD103
     C     RXURTSP       ANDNE     *ZEROS
     C     RXUSPIN       ANDEQ     *BLANK
     C                   MOVE      'A'           USPIN
     C                   END
      *
     C*****RXTBRTT       IFNE      *ZEROS                                                     CSD103
     C     RXTBRTT       IFNE      *BLANKS                                                    CSD103
     C     RXTRTSP       ANDNE     *ZEROS
     C     RXTSPIN       ANDEQ     *BLANK
     C                   MOVE      'A'           TSPIN
     C                   END

      * Our and Their original principal amount
     C                   Z-ADD     UPAMT         UOPAM
     C                   Z-ADD     TPAMT         TOPAM
      *                                                                                       CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   Z-ADD     UPAMT         FSUPAM                                       CAS005
     C                   Z-ADD     TPAMT         FSTPAM                                       CAS005
     C                   ENDIF                                                                CAS005
      *
      **  Our and Their original base rate code
     C     RXUEINR       IFNE      *ZEROS
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
     C                   ELSE
     C                   Z-ADD     *ZEROS        UOBRT
     C                   ENDIF
      *
     C     RXTEINR       IFNE      *ZEROS
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
     C                   ELSE
     C                   Z-ADD     *ZEROS        TOBRT
     C                   ENDIF
      *
      * Non-Static Indicators
     C                   BITOFF    '01234567'    UDNSI
     C     RXUEINR       IFNE      *ZEROS
     C     SUEINR        ORNE      *BLANKS                                                  MD054095
     C                   BITON     '0'           UDNSI
     C                   END
      *
     C                   BITOFF    '01234567'    TDNSI
     C     RXTEINR       IFNE      *ZEROS
     C     STEINR        ORNE      *BLANKS                                                  MD054095
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
     C*****RXUBRTT       IFEQ      *ZEROS                                                     CSD103
     C     RXUBRTT       IFEQ      *BLANKS                                                    CSD103
     C                   Z-ADD     URTSP         UEINR
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      FSUEFR = URTSP                                             CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ELSE
     C                   Z-ADD     RXUEINR       UEINR
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
     C*****RXTBRTT       IFEQ      *ZEROS                                                     CSD103
     C     RXTBRTT       IFEQ      *BLANKS                                                    CSD103
     C                   Z-ADD     TRTSP         TEINR
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      FSTEFR = TRTSP                                             CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ELSE
     C                   Z-ADD     RXTEINR       TEINR
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
     C*****RXUBRTT       IFEQ      *ZEROS                                                     CSD103
     C     RXUBRTT       IFEQ      *BLANKS                                                    CSD103
      *
     C                   Z-ADD     0             UINFD
     C                   ELSE
      *
      * User pays Floating Rate, Counterparty pays Fixed Rate
      * Reset only, if Next Intr.Chg Date, or Rate Fix Days changed
      *
     C     RXUNICD       IFNE      ##UNICD                                                  BUG11266
     C     RXUFRFD       ORNE      ##UFRFD                                                  BUG11266
     C     RXUEINR       ORNE      ##UEINR                                                  BUG11266
     C     RXC1R1        ORNE      ##L1CYR1                                                   235490
     C     RXC2R1        ORNE      ##L1CYR2                                                   235490
     C     RXC3R1        ORNE      ##L1CYR3                                                   235490
     C     RXC4R1        ORNE      ##L1CYR4                                                   235490
     C     RXC5R1        ORNE      ##L1CYR5                                                   235490
     C     RXC6R1        ORNE      ##L1CYR6                                                   235490
     C     RXC7R1        ORNE      ##L1CYR7                                                   235490
     C     RXC8R1        ORNE      ##L1CYR8                                                   235490
     C     RXC9R1        ORNE      ##L1CYR9                                                   235490
     C     RXC0R1        ORNE      ##L1CYR0                                                   235490
      *                                                                                       227642
      *                                                                                     BUG11266
     C*****RXUNICD       IFNE      ##UNICD
     C*****RXUFRFD       ORNE      ##UFRFD
     C*****RXUEINR       ORNE      ##UEINR
      *
     C*****RXUFRFD       IFEQ      *ZEROS
     C*****BJLCCY        IFEQ      BLCYCD
     C*****RXUCUCY       ANDEQ     BLCYCD
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
     C     RXUICFR       ANDNE     'O'                                                        TDA081
     C                   MOVE      RXUCUCY       ##CUCY                                       TDA081
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
     C                   MOVE      RXUCUCY       ZCCY
     C                   ENDIF
     C*
     C                   MOVE      *BLANKS       ZLOC
      *                                                                         CIR005
      ** Use Rate Fixing Currencies to get rate fixing date when                CIR005
      ** CIR005 is on. Otherwise, use transaction ccy.                          CIR005
      *                                                                         CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C     RXC1R1        ANDNE     *BLANKS                                      CIR005
     C                   Z-ADD     ZRFDY         PRFDY                          CIR005
     C                   CALLB     'IRRTFXCNV'                                  CIR005
     C                   PARM                    ZINDT                          CIR005
     C                   PARM                    PRFDY                          CIR005
     C                   PARM                    ZLOC                           CIR005
     C                   PARM                    OURCCY                         CIR005
     C                   PARM                    ZRFDT                          CIR005
     C                   ELSE                                                   CIR005
     C                   EXSR      DLBACK
     C                   ENDIF                                                  CIR005
      *
      **  If deal forward-valued AND Short Term Rate NOT entered then
      **  the Next Interest Rate Fix Date must be that associated
      *   with the Value Date...
     C     ZRFDT         IFGE      BJRDNB
     C     RXUEINR       ANDEQ     *ZEROS
     C                   Z-ADD     ZRFDT         UINFD
      *
      **  ...else the Next Interest Rate Fix Date must be that
      **  associated with the Next Rate Change Date.
     C                   ELSE
     C     RXUNICD       IFNE      *ZEROS
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
     C                   MOVE      RXUCUCY       ZCCY
     C                   ENDIF
     C*
     C                   MOVE      *BLANKS       ZLOC
      *                                                                         CIR005
      ** Use Rate Fixing Currencies to get rate fixing date when                CIR005
      ** CIR005 is on. Otherwise, use transaction ccy.                          CIR005
      *                                                                         CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C     RXC1R1        ANDNE     *BLANKS                                      CIR005
     C                   Z-ADD     ZRFDY         PRFDY                          CIR005
     C                   CALLB     'IRRTFXCNV'                                  CIR005
     C                   PARM                    ZINDT                          CIR005
     C                   PARM                    PRFDY                          CIR005
     C                   PARM                    ZLOC                           CIR005
     C                   PARM                    OURCCY                         CIR005
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
      *                                                                                     BUG11266
     C                   ENDIF                                                              BUG11266
      *
     C                   END
      *
      * Their Floating Rate Fix Days
      **Default*if*not*entered********
      * (Defaulting done in IRVRTFXDAY)
      *
     C*****RXTBRTT       IFEQ      *ZEROS                                                     CSD103
     C     RXTBRTT       IFEQ      *BLANKS                                                    CSD103

     C                   Z-ADD     0             TINFD
     C                   ELSE
      *
      * User pays Fixed Rate, Counterparty pays Floating Rate
      * Reset only, if Next Intr.Chg Date, or Rate Fix Days changed
      *
     C     RXTNICD       IFNE      ##TNICD                                                  BUG11266
     C     RXTFRFD       ORNE      ##TFRFD                                                  BUG11266
     C     RXTEINR       ORNE      ##TEINR                                                  BUG11266
     C     RXC1R2        ORNE      ##L2CYR1                                                   235490
     C     RXC2R2        ORNE      ##L2CYR2                                                   235490
     C     RXC3R2        ORNE      ##L2CYR3                                                   235490
     C     RXC4R2        ORNE      ##L2CYR4                                                   235490
     C     RXC5R2        ORNE      ##L2CYR5                                                   235490
     C     RXC6R2        ORNE      ##L2CYR6                                                   235490
     C     RXC7R2        ORNE      ##L2CYR7                                                   235490
     C     RXC8R2        ORNE      ##L2CYR8                                                   235490
     C     RXC9R2        ORNE      ##L2CYR9                                                   235490
     C     RXC0R2        ORNE      ##L2CYR0                                                   235490
      *                                                                                       227642
      *                                                                                     BUG11266
     C*****RXTNICD       IFNE      ##TNICD
     C*****RXTFRFD       ORNE      ##TFRFD
     C*****RXTEINR       ORNE      ##TEINR
      *
     C*****RXTFRFD       IFEQ      *ZEROS
     C*****BJLCCY        IFEQ      BLCYCD
     C*****RXTCUCY       ANDEQ     BLCYCD
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
     C     RXTICFR       ANDNE     'O'                                                        TDA081
     C                   MOVE      RXTCUCY       ##CUCY                                       TDA081
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
     C                   MOVE      RXTCUCY       ZCCY
     C                   ENDIF
     C*
     C                   MOVE      *BLANKS       ZLOC
      *                                                                         CIR005
      ** Use Rate Fixing Currencies to get rate fixing date when                CIR005
      ** CIR005 is on. Otherwise, use transaction ccy.                          CIR005
      *                                                                         CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C     RXC1R2        ANDNE     *BLANKS                                      CIR005
     C                   Z-ADD     ZRFDY         PRFDY                          CIR005
     C                   CALLB     'IRRTFXCNV'                                  CIR005
     C                   PARM                    ZINDT                          CIR005
     C                   PARM                    PRFDY                          CIR005
     C                   PARM                    ZLOC                           CIR005
     C                   PARM                    THRCCY                         CIR005
     C                   PARM                    ZRFDT                          CIR005
     C                   ELSE                                                   CIR005
     C                   EXSR      DLBACK
     C                   ENDIF                                                  CIR005
      *
      **  If deal forward-valued AND Short Term Rate NOT entered then
      **  the Next Interest Rate Fix Date must be that associated
      *   with the Value Date...
     C     ZRFDT         IFGE      BJRDNB
     C     RXTEINR       ANDEQ     *ZEROS
     C                   Z-ADD     ZRFDT         TINFD
     C                   ELSE
      *
      **  ...else the Next Interest Rate Fix Date must be that
      **  associated with the Next Rate Change Date.
     C     RXTNICD       IFNE      *ZEROS
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
     C                   MOVE      RXTCUCY       ZCCY
     C                   ENDIF
     C*
     C                   MOVE      *BLANKS       ZLOC
      *                                                                         CIR005
      ** Use Rate Fixing Currencies to get rate fixing date when                CIR005
      ** CIR005 is on. Otherwise, use transaction ccy.                          CIR005
      *                                                                         CIR005
     C     CIR005        IFEQ      'Y'                                          CIR005
     C     RXC1R2        ANDNE     *BLANKS                                      CIR005
     C                   Z-ADD     ZRFDY         PRFDY                          CIR005
     C                   CALLB     'IRRTFXCNV'                                  CIR005
     C                   PARM                    ZINDT                          CIR005
     C                   PARM                    PRFDY                          CIR005
     C                   PARM                    ZLOC                           CIR005
     C                   PARM                    THRCCY                         CIR005
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
      *                                                                                     BUG11266
     C                   ENDIF                                                              BUG11266
      *
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
     C                             RXUNIPD = WUIPBD  AND                        CIR005
     C                             WL1AMC = 'A'  AND                            CIR005
     C                             RXAMC1 = WL1AMC  OR                          CIR005
     C                             CIR005 = 'Y'  AND                            CIR005
     C                             RXUNIPD = WUNIPD  AND                        CIR005
     C                             WL1AMC <> 'A'  AND                           CIR005
     C                             RXAMC1 = WL1AMC                              CIR005
      *                                                                         CIR005
     C                   EVAL      UIPBD = WUIPBD                               CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
      ** Business Day Conventions details (THEIR)                               CIR005
      *                                                                         CIR005
     C                   IF        CIR005 = 'Y'  AND                            CIR005
     C                             RXTNIPD = WTIPBD  AND                        CIR005
     C                             WL2AMC = 'A'  AND                            CIR005
     C                             RXAMC2 = WL2AMC  OR                          CIR005
     C                             CIR005 = 'Y'  AND                            CIR005
     C                             RXTNIPD = WTNIPD  AND                        CIR005
     C                             WL2AMC <> 'A'  AND                           CIR005
     C                             RXAMC2 = WL2AMC                              CIR005
      *                                                                         CIR005
     C                   EVAL      TIPBD = WTIPBD                               CIR005
     C                   ENDIF                                                  CIR005
      *
      * Base Currency Exchange Rate
      * Default if not entered
      *
     C     RXUBCXR       IFEQ      *ZEROS
     C                   MOVE      RXUCUCY       ##CUCY
     C                   EXSR      ACSDCY
     C                   Z-ADD     A6SPRT        UBCXR
     C                   END
      *
     C     RXTBCXR       IFEQ      *ZEROS
     C                   MOVE      RXTCUCY       ##CUCY
     C                   EXSR      ACSDCY
     C                   Z-ADD     A6SPRT        TBCXR
     C                   END
      *
      * Spread Indicators
     C*****RXUBRTT       IFNE      *ZEROS                                                     CSD103
     C     RXUBRTT       IFNE      *BLANKS                                                    CSD103
     C     RXURTSP       ANDNE     *ZEROS
     C     RXUSPIN       ANDEQ     *BLANK
     C                   MOVE      'A'           USPIN
     C                   END
      *
     C*****RXTBRTT       IFNE      *ZEROS                                                     CSD103
     C     RXTBRTT       IFNE      *BLANKS                                                    CSD103
     C     RXTRTSP       ANDNE     *ZEROS
     C     RXTSPIN       ANDEQ     *BLANK
     C                   MOVE      'A'           TSPIN
     C                   END

      **  Our and Their original base rate code
     C     RXUEINR       IFNE      *ZEROS
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
     C**********         EVAL      FSUEFR = RXUEINR                                    CAS005 228071
      **********                                                                       CAS005 228071
     C**********         IF        UOBRT >= 0                                          CAS005 228071
     C**********         EVAL      FSUEFR = UOBRT                                      CAS005 228071
     C**********         ENDIF                                                         CAS005 228071
     C**********         ENDIF                                                         CAS005 228071
      **********                                                                       CAS005 228071
     C                   ENDIF
                                                                                              228071
     C                   IF        CAS005 = 'Y' AND                                           228071
     C                             RXUEINR <> 0                                               228071
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
     C     RXTEINR       IFNE      *ZEROS
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
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C                   EVAL      FSTEFR = RXTEINR                                           CAS005
                                                                                              CAS005
     C                   IF        TOBRT >= 0                                                 CAS005
     C                   EVAL      FSTEFR = TOBRT                                             CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ELSE
     C                   ENDIF
                                                                                              228071
     C                   IF        CAS005 = 'Y' AND                                           228071
     C                             RXTEINR <> 0                                               228071
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
     C*****RXUBRTT       IFNE      *ZEROS                                                     CSD103
     C     RXUBRTT       IFNE      *BLANKS                                                    CSD103
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
     C*****RXTBRTT       IFNE      *ZEROS                                                     CSD103
     C     RXTBRTT       IFNE      *BLANKS                                                    CSD103
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
      *                                                                                      BUG6418
      ** Determine if local or deal currency to be used                                      BUG6418
      ** in holiday checking                                                                 BUG6418
      *                                                                                      BUG6418
     C                   MOVEL     'L'           @DLOLC                                      BUG6418
     C                   MOVEL     *BLANK        @NOSTR                                      BUG6418
      *
      ** If CIR003 is on, set up pay/receive indicators to generate pay/receive               CIR003
      ** messages for value date exchanges of principal.                                      CIR003
      *
     C     CIR003        IFEQ      'Y'                                                        CIR003
      *                                                                                       CIR003
     C     VDEI          IFEQ      'Y'                                                        CIR003
      *                                                                                       CIR003
      ** Setoff indicator 16 if value date account indicator is not yet set                   CIR003
      ** i.e. bit '1' of ACEI is OFF.                                                         CIR003
      *                                                                                       CIR003
     C                   TESTB     '1'           ACEI                     16                  CIR003
      *                                                                                       CIR003
      ** Set on indicator 17 if 'our' value date pay/receives have already                    CIR003
      ** been generated, i.e. bit '1' of TLXI is ON.                                          CIR003
      *                                                                                       CIR003
     C                   TESTB     '1'           TLXI                     17                  CIR003
      *                                                                                       CIR003
      ** For receipt setllement instructions                                                  CIR003
      *                                                                                       CIR003
     C     RXCHTP        IFEQ      'I'                                                        CIR003
     C     RXCHTP        OREQ      'A'                                                        CIR003
     C     BefRecVal     ANDNE     AftRecVal                                                  CIR003
     C     *IN16         ANDEQ     *OFF                                                   AR1041215A
     C     RXCHTP        OREQ      'A'                                                    AR1041215A
     C     BefRecRONS    ANDNE     AftRecRONS                                                 CGL029
     C     *IN16         ANDEQ     *OFF                                                       CIR003
     C     RXCHTP        OREQ      'R'                                                        CIR003
     C     *IN17         ANDEQ     *ON                                                        CIR003
      *                                                                                       CIR003
     C     E1RXRSTM      IFEQ      01                                                         CIR003
     C     E1RXRSTM      OREQ      02                                                         CIR003
     C     E1RXRSTM      OREQ      07                                                         CIR003
     C     E1RXRSTM      OREQ      08                                                         CIR003
     C     E1RXRSTM      OREQ      12                                                         CIR003
      *                                                                                       CIR003
     C**********         MOVE      RXUCUCY       ##CUCY                               CIR003 BUG6418
     C**********         EXSR      ACSDCY                                             CIR003 BUG6418
     C*****RXVDAT        SUB       A6TXND        WOVDAT            5 0                CIR003 BUG6418
      *                                                                                       CIR003
     C                   MOVE      RXUCUCY       @CCY                                        BUG6418
     C                   MOVE      'D'           @DLOLC                                      BUG6418
     C                   MOVEL     E1RXRONS      @NOSTR                                      BUG6418
     C                   EXSR      TLXDUE                                                    BUG6418
      *                                                                                      BUG6418
      * Set PRI1 if value date is within telex notice period                                 BUG6418
      *                                                                                      BUG6418
     C*****WOVDAT        IFLE      BJRDNB                                             CIR003 BUG6418
     C     RXVDAT        IFGE      BJRDNB                                                    BUG6418
     C     RXVDAT        ANDLE     @TLXDU                                                    BUG6418
     C                   Z-ADD     1             @@PRI1                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C                   ELSE                                                                 CIR003
      *                                                                                       CIR003
     C**********         MOVE      BJLCCY        ##CUCY                               CIR003 BUG6418
     C**********         EXSR      ACSDCY                                             CIR003 BUG6418
     C*****RXVDAT        SUB       A6TXND        WLVDAT            5 0                CIR003 BUG6418
      *                                                                                      BUG6418
      * Call TLXDUE with local ccy 'L' for @DLOLC                                            BUG6418
     C                   MOVE      BJLCCY        @CCY                                        BUG6418
     C                   MOVE      'L'           @DLOLC                                      BUG6418
     C                   MOVEL     E1RXRONS      @NOSTR                                      BUG6418
     C                   EXSR      TLXDUE                                                    BUG6418
      *                                                                                       CIR003
      * Set PRI1 if value date is within telex notice period                                 BUG6418
      *                                                                                      BUG6418
     C*****WLVDAT        IFLE      BJRDNB                                             CIR003 BUG6418
     C     RXVDAT        IFGE      BJRDNB                                                    BUG6418
     C     RXVDAT        ANDLE     @TLXDU                                                    BUG6418
     C                   Z-ADD     1             @@PRI1                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
      ** Set on indicator 17 if 'their' value date pay/receives have already                  CIR003
      ** been generated, i.e. bit '0' of TLXI is ON.                                          CIR003
      *                                                                                       CIR003
     C                   TESTB     '0'           TLXI                     17                  CIR003
      *                                                                                       CIR003
      ** For payment setllement instructions                                                  CIR003
      *                                                                                       CIR003
     C     RXCHTP        IFEQ      'I'                                                        CIR003
     C     RXCHTP        OREQ      'A'                                                        CIR003
     C     BefPayVal     ANDNE     AftPayVal                                                  CIR003
     C     *IN16         ANDEQ     *OFF                                                   AR1041215A
     C     RXCHTP        OREQ      'A'                                                    AR1041215A
     C     BefPayPONS    ANDNE     AftPayPONS                                                 CGL029
     C     *IN16         ANDEQ     *OFF                                                       CIR003
     C     RXCHTP        OREQ      'R'                                                        CIR003
     C     *IN17         ANDEQ     *ON                                                        CIR003
      *                                                                                       CIR003
     C     E1RXPSTM      IFEQ      01                                                         CIR003
     C     E1RXPSTM      OREQ      02                                                         CIR003
     C     E1RXPSTM      OREQ      07                                                         CIR003
     C     E1RXPSTM      OREQ      08                                                         CIR003
     C     E1RXPSTM      OREQ      12                                                         CIR003
      *                                                                                       CIR003
     C**********         MOVE      RXTCUCY       ##CUCY                               CIR003 BUG6418
     C**********         EXSR      ACSDCY                                             CIR003 BUG6418
     C*****RXVDAT        SUB       A6TXND        WOVDAT            5 0                CIR003 BUG6418
      *                                                                                       CIR003
     C                   MOVE      RXTCUCY       @CCY                                        BUG6418
     C                   MOVE      'D'           @DLOLC                                      BUG6418
     C                   MOVEL     E1RXPONS      @NOSTR                                      BUG6418
     C                   EXSR      TLXDUE                                                    BUG6418
      *                                                                                       CIR003
      * Set PRI1 if value date is within telex notice period                                 BUG6418
      *                                                                                      BUG6418
     C*****WOVDAT        IFLE      BJRDNB                                             CIR003 BUG6418
     C     RXVDAT        IFGE      BJRDNB                                                    BUG6418
     C     RXVDAT        ANDLE     @TLXDU                                                    BUG6418
     C                   Z-ADD     1             @@PRI3                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C                   ELSE                                                                 CIR003
      *                                                                                       CIR003
     C**********         MOVE      BJLCCY        ##CUCY                               CIR003 BUG6418
     C**********         EXSR      ACSDCY                                             CIR003 BUG6418
     C*****RXVDAT        SUB       A6TXND        WLVDAT                               CIR003 BUG6418
      *                                                                                      BUG6418
      * Call TLXDUE with local ccy 'L' for @DLOLC                                            BUG6418
     C                   MOVE      BJLCCY        @CCY                                        BUG6418
     C                   MOVE      'L'           @DLOLC                                      BUG6418
     C                   MOVEL     E1RXPONS      @NOSTR                                      BUG6418
     C                   EXSR      TLXDUE                                                    BUG6418
      *                                                                                       CIR003
      * Set PRI1 if value date is within telex notice period                                 BUG6418
      *                                                                                      BUG6418
     C*****WLVDAT        IFLE      BJRDNB                                                     CIR003
     C     RXVDAT        IFGE      BJRDNB                                                    BUG6418
     C     RXVDAT        ANDLE     @TLXDU                                                    BUG6418
     C                   Z-ADD     1             @@PRI3                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
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
     C     RXRSTM        IFNE      *ZERO
     C     RXPSTM        ORNE      *ZERO
     C     BLL2II        OREQ      'N'
     C     CIR008        OREQ      'Y'                                                        213055
     C     RXCHTP        ANDEQ     'X'                                                        213055
     C     RSTM          ANDNE     *ZERO                                                      213055
     C     CIR008        OREQ      'Y'                                                        213055
     C     RXCHTP        ANDEQ     'X'                                                        213055
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
     C                   MOVE      'N'           @@CNRQ                                       CIR003
      *
      * IF SETTLEMENT INSTRUCTIONS WERE PREVIOUSLY PRESENT
      * OR IF 2 LEVEL INPUT NOT PRESENT
      * OR IF ORIGINAL ENTRY DATE NOT EQUAL TO RUN DATE
      *
     C     RSTM          IFNE      *ZERO
     C     PSTM          ORNE      *ZERO
     C     RXRSTM        ORNE      *ZERO                                                      194487
     C     RXPSTM        ORNE      *ZERO                                                      194487
     C     BLL2II        OREQ      'N'
     C     ORED          ORNE      BJRDNB
      *
      ** If settlement instruction fields have changed
      *
     C     RSTM          IFNE      RXRSTM
     C     RONS          ORNE      RXRONS
     C     RIBN          ORNE      RXRIBN
     C     RIBA          ORNE      RXRIBA                                                     194487
     C     ROBN          ORNE      RXROBN                                                     194487
     C     ROCN          ORNE      RXROCN                                                     194487
     C     PSTM          ORNE      RXPSTM
     C     PONS          ORNE      RXPONS
     C     PIBN          ORNE      RXPIBN                                                     194487
     C     PIBA          ORNE      RXPIBA                                                     194487
     C     POBN          ORNE      RXPOBN                                                     194487
     C     POCN          ORNE      RXPOCN                                                     194487
     C     RCRN          ORNE      RXRCRN                                                     194487
     C     RCRA          ORNE      RXRCRA                                                     194487
     C     RVNO          ORNE      RXRVNO                                                     194487
     C     AWBN          ORNE      RXAWBN
     C     AWBA          ORNE      RXAWBA                                                     194487
     C     BENN          ORNE      RXBENN
     C     BENA          ORNE      RXBENA                                                     194487
     C     DTP1          ORNE      RXDTP1                                                     194487
     C     DTP2          ORNE      RXDTP2                                                     194487
     C     DTP3          ORNE      RXDTP3                                                     194487
     C     DTP4          ORNE      RXDTP4                                                     194487
     C     DCHG          ORNE      RXDCHG                                                     194487
     C     BTB1          ORNE      RXBTB1
     C     BTB2          ORNE      RXBTB2                                                     194487
     C     BTB3          ORNE      RXBTB3                                                     194487
     C     BTB4          ORNE      RXBTB4                                                     194487
     C     BTB5          ORNE      RXBTB5                                                     194487
     C     BTB6          ORNE      RXBTB6                                                     194487
     C     CVMR          ORNE      RXCVMR                                                     194487
     C     RSCY          ORNE      RXRSCY                                                     194487
     C     PSCY          ORNE      RXPSCY                                                     194487
     C     IC72          ORNE      RXIC72                                                     194487
      *
      ** or if Def. Sender-Receiver info has changed
     C     DSR1          ORNE      RXDSR1
     C     DSR2          ORNE      RXDSR2
     C     DSR3          ORNE      RXDSR3
     C     DSR4          ORNE      RXDSR4
     C     DSR5          ORNE      RXDSR5
     C     DSR6          ORNE      RXDSR6
      *
      ** or if the ISDA fields have changed                                     CSW097
      *                                                                         CSW097
     C     ISDA          ORNE      RXISDA                                       CSW097
     C     AGTY          ORNE      RXAGTY                                       CSW097
     C     AGDT          ORNE      RXAGDT                                       CSW097
     C     AGVC          ORNE      RXAGVC                                       CSW097
     C     AGVV          ORNE      RXAGVV                                       CSW097
      *                                                                         CSW097
      ** or if deal contract fields have changed
      *
     C*****NIDT          ORNE      IKNIPD
     C*****IPFR          ORNE      IKIPFQ
     C*****INTF          ORNE      IKIPDM
     C     VDAT          ORNE      RXVDAT                                                     194487
     C     MDAT          ORNE      RXMDAT                                                     194487
     C     USTRT         ORNE      RXUSTRT                                                    194487
     C*****UEINR         ORNE      RXUEINR                                             194487 227642
     C     UBRTE         ORNE      RXUBRTE                                                    194487
     C     URTSP         ORNE      RXURTSP                                                    194487
     C     UNICD         ORNE      RXUNICD                                                    194487
     C     UNIPD         ORNE      RXUNIPD                                                    194487
     C     UICFR         ORNE      RXUICFR                                                    194487
     C     UICFD         ORNE      RXUICFD                                                    194487
     C     UIPFR         ORNE      RXUIPFR                                                    194487
     C     UIPFD         ORNE      RXUIPFD                                                    194487
     C     TSTRT         ORNE      RXTSTRT                                                    194487
     C*****TEINR         ORNE      RXTEINR                                             194487 227642
     C     TBRTE         ORNE      RXTBRTE                                                    194487
     C     TRTSP         ORNE      RXTRTSP                                                    194487
     C     TNICD         ORNE      RXTNICD                                                    194487
     C     TNIPD         ORNE      RXTNIPD                                                    194487
     C     TICFR         ORNE      RXTICFR                                                    194487
     C     TICFD         ORNE      RXTICFD                                                    194487
     C     TIPFR         ORNE      RXTIPFR                                                    194487
     C     TIPFD         ORNE      RXTIPFD                                                    194487
     C     BOVD          ORNE      RXBOVD                                                    BUG7911
     C     UNPCD         ORNE      RXUNPCD                                                  BUG6877R
     C     TNPCD         ORNE      RXTNPCD                                                  BUG6877R
      *                                                                                      BUG6877
      ** if Reference Rate has changed                                                       BUG6877
      *                                                                                      BUG6877
     C     UBRTT         ORNE      RXUBRTT                                                   BUG6877
     C     TBRTT         ORNE      RXTBRTT                                                   BUG6877
      *
      ** Produce a confirmation now
      *
     C***********        BITOFF    '0'           CNFI                           CSW097
     C                   BITOFF    '0'           RXCNFI                         CSW097
      *                                                                                      BUG7911
      ** Only generate new MT361 during amend if BOVD is zero                                BUG7911
      *                                                                                      BUG7911
     C     BOVD          IFEQ      *ZEROS                                                    BUG7911
     C     RXBOVD        ANDEQ     *ZEROS                                                    BUG7911
     C     BOVD          ORNE      RXBOVD                                                    BUG7911
     C                   MOVE      'Y'           @@CNRQ
     C                   ENDIF                                                               BUG7911
      *                                                                                      BUG7911
      *                                                                                     BUG6877N
      ** If any of the Settlement Instruction fields has changed, reset                     BUG6877N
      ** bits 3 & 4 of TLXI field to allow regeneration of OUR/THEIR                        BUG6877N
      ** Pay/Receive messages.                                                              BUG6877N
      *                                                                                     BUG6877N
     C     RSTM          IFNE      RXRSTM                                                   BUG6877N
     C     RONS          ORNE      RXRONS                                                   BUG6877N
     C     RIBN          ORNE      RXRIBN                                                   BUG6877N
     C     RIBA          ORNE      RXRIBA                                                   BUG6877N
     C     ROBN          ORNE      RXROBN                                                   BUG6877N
     C     ROCN          ORNE      RXROCN                                                   BUG6877N
     C     PSTM          ORNE      RXPSTM                                                   BUG6877N
     C     PONS          ORNE      RXPONS                                                   BUG6877N
     C     PIBN          ORNE      RXPIBN                                                   BUG6877N
     C     PIBA          ORNE      RXPIBA                                                   BUG6877N
     C     POBN          ORNE      RXPOBN                                                   BUG6877N
     C     POCN          ORNE      RXPOCN                                                   BUG6877N
     C     RCRN          ORNE      RXRCRN                                                   BUG6877N
     C     RCRA          ORNE      RXRCRA                                                   BUG6877N
     C     RVNO          ORNE      RXRVNO                                                   BUG6877N
     C     AWBN          ORNE      RXAWBN                                                   BUG6877N
     C     AWBA          ORNE      RXAWBA                                                   BUG6877N
     C     BENN          ORNE      RXBENN                                                   BUG6877N
     C     BENA          ORNE      RXBENA                                                   BUG6877N
     C     DTP1          ORNE      RXDTP1                                                   BUG6877N
     C     DTP2          ORNE      RXDTP2                                                   BUG6877N
     C     DTP3          ORNE      RXDTP3                                                   BUG6877N
     C     DTP4          ORNE      RXDTP4                                                   BUG6877N
     C     DCHG          ORNE      RXDCHG                                                   BUG6877N
     C     BTB1          ORNE      RXBTB1                                                   BUG6877N
     C     BTB2          ORNE      RXBTB2                                                   BUG6877N
     C     BTB3          ORNE      RXBTB3                                                   BUG6877N
     C     BTB4          ORNE      RXBTB4                                                   BUG6877N
     C     BTB5          ORNE      RXBTB5                                                   BUG6877N
     C     BTB6          ORNE      RXBTB6                                                   BUG6877N
     C     CVMR          ORNE      RXCVMR                                                   BUG6877N
     C     RSCY          ORNE      RXRSCY                                                   BUG6877N
     C     PSCY          ORNE      RXPSCY                                                   BUG6877N
     C     IC72          ORNE      RXIC72                                                   BUG6877N
      * Fields that if changed will affect generated messages                               BUG6877N
     C     USTRT         ORNE      RXUSTRT                                                  BUG6877N
     C     TSTRT         ORNE      RXTSTRT                                                  BUG6877N
     C     UNPCD         ORNE      RXUNPCD                                                  BUG6877N
     C     TNPCD         ORNE      RXTNPCD                                                  BUG6877N
     C     UNIPD         ORNE      RXUNIPD                                                  BUG6877N
     C     TNIPD         ORNE      RXTNIPD                                                  BUG6877N
     C     UEINR         ORNE      RXUEINR                                                  BUG6877N
     C     TEINR         ORNE      RXTEINR                                                  BUG6877N
     C                   BITOFF    '34'          RXTLXI                                     BUG6877N
     C                   ENDIF                                                              BUG6877N
      *
      * Set off maturity and interest indicators if past value date
      *
     C     ORED          IFLT      BJRDNB
     C     VDAT          ANDLT     BJRDNB
     C***********        BITOFF    '12'          CNFI                           CSW097
     C                   BITOFF    '12'          RXCNFI                         CSW097
     C                   END
      *
     C                   END
      *                                                                                      BUG6877
     C     CIR008        IFEQ      'Y'                                                       BUG6877
     C     FIAUTH        ANDNE     'Y'                                                       BUG6877
     C     BQFIRA        ANDEQ     'Y'                                                        239742
     C                   BITOFF    '0'           RXCNFI                                      BUG6877
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
                                                                                              CIR008
     C                   EVAL      @@CNRQ = 'N'                                               CIR008
      *
     C                   MOVE      'N'           @@CNRQ            1                          194487
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
     C                   Z-ADD     RXDLNO        DXDLNO
     C                   Z-ADD     *ZERO         DXVDAT
     C                   Z-ADD     *ZERO         DXDASN
     C                   MOVE      RXCHTP        DXCHTP
     C                   MOVE      @@CNRQ        DXCNRQ
     C                   MOVE      'N'           DXCNPR
     C                   MOVE      ' '           DXREPR
     C                   TIME                    @XTIME
     C                   MOVE      @@PRI1        DXPRI1
     C                   MOVE      @@PRI2        DXPRI2
     C                   MOVE      @@PRI3        DXPRI3
     C                   Z-ADD     0             DXICIN
     C                   MOVEL     RXBRCA        DXBRCA
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
     C                   PARM      RXCHTP        @@CHTP            1
      *
      ** Amount
     C                   PARM      RXUPAMT       @@AMNP           15 0
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
      **Make*sure*overrides*exist**************************************              246966 AR743357
     C**********         Eval      QCMD = OVRDLPCSC                                  246966 AR743357
     C**********         Call      'QCMDEXC'                                         246966 AR743357
     C**********         Parm                    QCMD            100                 246966 AR743357
     C**********         Parm      100           QCMDLEN          15 5               246966 AR743357
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
     C/COPY WNCPYSRC,IRCIRSDC08
      *
      ** Data export for CCRM - Limits                                          CDE001
     C                   IF        CDE001 = 'Y'                                 CDE001
     C                   MOVEL     RXDLNO        T#TREF                         CDE001
     C                   CALLB     'DEWRTTRIG'                                  CDE001
     C                   PARM                    T#TREF           20            CDE001
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
     C                   MOVE      RXDLNO        @DLNUM
     C*
     C                   CALL      'DL1911'
     C                   PARM                    @TERM             1
     C                   PARM                    @DLNUM            6 0
     C**********         PARM                    RXCHTP                                      BUG5519
     C                   PARM                    WkActn                                      BUG5519
     C                   PARM                    RXUCUCY
     C*
     C     @TERM         IFEQ      'E'
     C                   EXSR      *PSSR
     C                   END
     C*
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
      ** on when CAP043 is on                                                                 CAP043
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
     C                   EVAL      PCOTIN = PVYOURTHR                                         CAP043
     C                   EVAL      PCDTPR = *BLANK                                            CAP043
     C                   EVAL      PCPMTP = *BLANK                                            CAP043
                                                                                              CAP043
     C                   SELECT                                                               CAP043
                                                                                              CAP043
      ** Our Principal Change Schedule                                                        CAP043
                                                                                              CAP043
     C                   WHEN      (PVYOURTHR = 'U')                                          CAP043
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
     C                   EVAL      PCPAMT = RXUPAMT + WPAMT                                   CAP043
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
     C                   EVAL      PCPAMT = RXUPAMT + WPAMT                                   CAP043
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
      ** Their Principal Change Schedule                                                      CAP043
                                                                                              CAP043
     C                   WHEN      (PVYOURTHR = 'T')                                          CAP043
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
     C                   EVAL      PCPAMT = RXTPAMT + WPAMT                                   CAP043
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
     C                   EVAL      PCPAMT = RXTPAMT + WPAMT                                   CAP043
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
     C                   ENDSL                                                                CAP043
                                                                                              CAP043
     C     KIRCList      READE     IRVPCSCL0                                                  CAP043
     C                   ENDDO                                                                CAP043
     C                   ENDIF                                                                CAP043
     C                   ENDIF                                                                CAP043
      **********                                                                       CAP004 CAP043
      ***Our*Rate Change Dates                                                         CAP004 CAP043
     C**********         IF        UICFR = 'Z'                                         CIR003 CAP043
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
     C**********         ENDIF                                                         CIR003 CAP043
      **********                                                                       CAP004 CAP043
      ***Our*Interest Payment Dates                                                    CAP004 CAP043
      **********                                                                       CAP004 CAP043
     C**********         IF        UIPFR = 'Z'                                         CIR003 CAP043
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
     C**********         ENDIF                                                         CIR003 CAP043
      **********                                                                       CAP004 CAP043
      ***Their*Rate Change Dates                                                       CAP004 CAP043
      **********                                                                       CAP004 CAP043
     C**********         IF        TICFR = 'Z'                                         CIR003 CAP043
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
     C**********         ENDIF                                                         CIR003 CAP043
      **********                                                                       CAP004 CAP043
      ***Their*Interest Payment Dates                                                  CAP004 CAP043
      **********                                                                       CAP004 CAP043
     C**********         IF        TIPFR = 'Z'                                         CIR003 CAP043
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
     C**********         ENDIF                                                         CIR003 CAP043
      **********                                                                CAP004 CAP004 CAP043
     C                   ENDSR                                                  CAP004
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
     C                   IF        (RXUNPCD <> *ZERO) AND (PVYOURTHR = 'U')                   CAP043
     C                   EVAL      WCTLDYN = RXUNPCD                                          CAP043
     C                   ENDIF                                                                CAP043
     C                   IF        (RXTNPCD <> *ZERO) AND (PVYOURTHR = 'T')                   CAP043
     C                   EVAL      WCTLDYN = RXTNPCD                                          CAP043
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
     C****************************************************************          CAP004
      /EJECT                                                                    CAP004
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
     C                   PARM      RXBOKC        @BOKC             2
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
     C                   PARM      RXBRCA        @DSNB             3
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
     C                   PARM      ##CUCY        @AJCD             3
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
     C                   MOVEL     'IRRX'        W4ITEM                                       CSD015
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
      ** Get the Counterparty Detail.                                                         CSD015
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
     C                   MOVEL     TCUCY         W4DEN2                                       CSD015
     C                   MOVEL     TCUCY         PZACcy                                       CSD015
     C                   MOVE      *BLANKS       PZANtvAmt                                    CSD015
     C                   MOVE      TPAMT         PZANtvAmt                                    CSD015
     C                   EXSR      SRAmtToNum                                                 CSD015
     C                   EVAL      W4AMT2 = WAMT                                              CSD015
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
      ** Initialise working variables.                                                        CSD015
      *                                                                                       CSD015
     C                   EVAL      WDTP1 = DTP1                                               CSD015
     C                   EVAL      WDTP2 = DTP2                                               CSD015
     C                   EVAL      WDTP3 = DTP3                                               CSD015
     C                   EVAL      WDTP4 = DTP4                                               CSD015
      *                                                                                       CSD015
      ** Switch denominations for transactions of type INT (default).                         CSD015
      *                                                                                       CSD015
     C                   EVAL      WRSCY = PSCY                                               CSD015
     C                   EVAL      WPSCY = RSCY                                               CSD015
     C                   EVAL      WDEN1 = W4DEN2                                             CSD015
     C                   EVAL      WDEN2 = W4DEN1                                             CSD015
      *                                                                                       CSD015
     C                   EVAL      PFreeFmtStr = *BLANKS                                      CSD015
      *                                                                                       CSD015
      ** Build the XML Packet chain.                                                          CSD015
      *                                                                                       CSD015
     C                   EXSR      SRBldXPC                                                   CSD015
      *                                                                                       CSD015
      ** Add the Extended Settlement XML Packets if CIR003 is enabled.                        CSD015
      *                                                                                       CSD015
     C                   IF        CIR003 = 'Y'                                               CSD015
     C                   EXSR      SRMVXSTXP                                                  CSD015
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
      * SRBldXPC - Builds the XML Packet chain on the Compliance      *                       CSD015
      *            Engine Free Format String.                         *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRBldXPC      BEGSR                                                                CSD015
      *                                                                                       CSD015
      ** Begin string and packet assembly.                                                    CSD015
      *                                                                                       CSD015
     C                   EVAL      Ctr = 1                                                    CSD015
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
     C                   IF        WRSCY <> *BLANKS                                           CSD015
     C                   EVAL      WCcy = WRSCY                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      WCcy = WDEN1                                               CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        Ctr = 5                                                    CSD015
     C                   IF        WPSCY <> *BLANKS                                           CSD015
     C                   EVAL      WCcy = WPSCY                                               CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      WCcy = WDEN2                                               CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      ** Use the 1st Denomination if the Payment Settlement Currency                          CSD015
      ** is still undefined at this point.                                                    CSD015
      *                                                                                       CSD015
     C                   IF        WCcy = *BLANKS                                             CSD015
     C                   EVAL      WCcy = WDEN1                                               CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
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
     C                   IF        WDetFlg = 'Y'                                              CSD015
      *                                                                                       CSD015
     C                   IF        WDTP1 <> *BLANKS OR                                        CSD015
     C                             WDTP2 <> *BLANKS OR                                        CSD015
     C                             WDTP3 <> *BLANKS OR                                        CSD015
     C                             WDTP4 <> *BLANKS                                           CSD015
      *                                                                                       CSD015
     C                   CAT       XOT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       WDTP1:0       WXMLPacket                                   CSD015
     C                   CAT       WDTP2:1       WXMLPacket                                   CSD015
     C                   CAT       WDTP3:1       WXMLPacket                                   CSD015
     C                   CAT       WDTP4:1       WXMLPacket                                   CSD015
     C                   CAT       XCT(Ctr):0    WXMLPacket                                   CSD015
     C                   CAT       WXMLPacket:0  PFreeFmtStr                                  CSD015
      *                                                                                       CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRMVDB2W - Moves Maturity and Value Extended Settlement       *                       CSD015
      *            Fields to their respective Watch List Fields.      *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRMVDB2W      BEGSR                                                                CSD015
      *                                                                                       CSD015
      ** Initialise relevant variables.                                                       CSD015
      *                                                                                       CSD015
     C                   MOVEA     *BLANKS       MWLF                                         CSD015
     C                   MOVEA     *BLANKS       VWLF                                         CSD015
     C                   EVAL      WMDtFlg = 'N'                                              CSD015
     C                   EVAL      WVDtFlg = 'N'                                              CSD015
      *                                                                                       CSD015
     C                   FOR       WItr = 1 TO 2                                              CSD015
      *                                                                                       CSD015
     C                   CLEAR                   DLGXST                                       CSD015
     C                   CLEAR                   XSTBC                                        CSD015
     C                   MOVEA     *BLANKS       WWLF                                         CSD015
      *                                                                                       CSD015
      ** Process Maturity Settlements on the first iteration and                              CSD015
      ** Value Settlements on the second iteration.                                           CSD015
      *                                                                                       CSD015
     C                   IF        WItr = 1                                                   CSD015
     C                   MOVE      MXST          DLGXST                                       CSD015
     C                   MOVE      MXSTBC        XSTBC                                        CSD015
     C                   ELSE                                                                 CSD015
     C                   MOVE      VXST          DLGXST                                       CSD015
     C                   MOVE      VXSTBC        XSTBC                                        CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   SELECT                                                               CSD015
      *                                                                                       CSD015
      ** Execute an unconditional move if necessary.                                          CSD015
      *                                                                                       CSD015
     C                   WHEN      WMoveMode = ALL                                            CSD015
      *                                                                                       CSD015
     C                   MOVEL     GXRXRONS      WWLF(1)                                      CSD015
     C                   MOVEL     GXRXRIBN      WWLF(2)                                      CSD015
     C                   MOVEL     GXRXROBN      WWLF(3)                                      CSD015
     C                   MOVEL     GXRXROCN      WWLF(4)                                      CSD015
     C                   MOVEL     GXRXPONS      WWLF(5)                                      CSD015
     C                   MOVEL     GXRXPIBN      WWLF(6)                                      CSD015
     C                   MOVEL     GXRXPOBN      WWLF(7)                                      CSD015
     C                   MOVEL     GXRXPOCN      WWLF(8)                                      CSD015
     C                   MOVEL     GXRXRCRN      WWLF(9)                                      CSD015
     C                   MOVEL     GXRXRVNO      WWLF(10)                                     CSD015
     C                   MOVEL     GXRXAWBN      WWLF(11)                                     CSD015
     C                   MOVEL     GXRXBENN      WWLF(12)                                     CSD015
     C                   EVAL      WMDtFlg = 'Y'                                              CSD015
     C                   EVAL      WVDtFlg = 'Y'                                              CSD015
      *                                                                                       CSD015
     C                   WHEN      WMoveMode = CHANGED                                        CSD015
      *                                                                                       CSD015
      ** Move only the fields that have changed since the last save.                          CSD015
      *                                                                                       CSD015
     C                   IF        GXRXRONS <> BCRXRONS                                       CSD015
     C                   MOVEL     GXRXRONS      WWLF(1)                                      CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        GXRXRIBN <> BCRXRIBN                                       CSD015
     C                   MOVEL     GXRXRIBN      WWLF(2)                                      CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        GXRXROBN <> BCRXROBN                                       CSD015
     C                   MOVEL     GXRXROBN      WWLF(3)                                      CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        GXRXROCN <> BCRXROCN                                       CSD015
     C                   MOVEL     GXRXROCN      WWLF(4)                                      CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        GXRXPONS <> BCRXPONS                                       CSD015
     C                   MOVEL     GXRXPONS      WWLF(5)                                      CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        GXRXPIBN <> BCRXPIBN                                       CSD015
     C                   MOVEL     GXRXPIBN      WWLF(6)                                      CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        GXRXPOBN <> BCRXPOBN                                       CSD015
     C                   MOVEL     GXRXPOBN      WWLF(7)                                      CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        GXRXPOCN <> BCRXPOCN                                       CSD015
     C                   MOVEL     GXRXPOCN      WWLF(8)                                      CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        GXRXRCRN <> BCRXRCRN                                       CSD015
     C                   MOVEL     GXRXRCRN      WWLF(9)                                      CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        GXRXRVNO <> BCRXRVNO                                       CSD015
     C                   MOVEL     GXRXRVNO      WWLF(10)                                     CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        GXRXAWBN <> BCRXAWBN                                       CSD015
     C                   MOVEL     GXRXAWBN      WWLF(11)                                     CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        GXRXBENN <> BCRXBENN                                       CSD015
     C                   MOVEL     GXRXBENN      WWLF(12)                                     CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   IF        GXRXDTP1 <> BCRXDTP1 OR                                    CSD015
     C                             GXRXDTP2 <> BCRXDTP2 OR                                    CSD015
     C                             GXRXDTP3 <> BCRXDTP3 OR                                    CSD015
     C                             GXRXDTP4 <> BCRXDTP4                                       CSD015
     C                   EVAL      WChgFlg = 'Y'                                              CSD015
      *                                                                                       CSD015
     C                   IF        WItr = 1                                                   CSD015
     C                   EVAL      WMDtFlg = 'Y'                                              CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      WVDtFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDSL                                                                CSD015
      *                                                                                       CSD015
      ** Save the Working WLFs to their respective data store.                                CSD015
      *                                                                                       CSD015
     C                   IF        WItr = 1                                                   CSD015
     C                   MOVEA     WWLF          MWLF                                         CSD015
     C                   ELSE                                                                 CSD015
     C                   MOVEA     WWLF          VWLF                                         CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDFOR                                                               CSD015
      *                                                                                       CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRMVWLFC - Watch List Fields check for Maturity and Value     *                       CSD015
      *            Extended Settlement Details.                       *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRMVWLFC      BEGSR                                                                CSD015
      *                                                                                       CSD015
     C                   FOR       WItr = 1 TO 2                                              CSD015
      *                                                                                       CSD015
     C                   MOVEA     *BLANKS       WWLF                                         CSD015
      *                                                                                       CSD015
      ** Check Maturity Settlements on the first iteration and                                CSD015
      ** Value Settlements on the second iteration.                                           CSD015
      *                                                                                       CSD015
     C                   IF        WItr = 1                                                   CSD015
     C                   MOVEA     MWLF          WWLF                                         CSD015
     C                   EVAL      WDTP1 = MXDTP1                                             CSD015
     C                   EVAL      WDTP2 = MXDTP2                                             CSD015
     C                   EVAL      WDTP3 = MXDTP3                                             CSD015
     C                   EVAL      WDTP4 = MXDTP4                                             CSD015
     C                   ELSE                                                                 CSD015
     C                   MOVEA     VWLF          WWLF                                         CSD015
     C                   EVAL      WDTP1 = VXDTP1                                             CSD015
     C                   EVAL      WDTP2 = VXDTP2                                             CSD015
     C                   EVAL      WDTP3 = VXDTP3                                             CSD015
     C                   EVAL      WDTP4 = VXDTP4                                             CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      ** Check the Working Watch List Fields array.                                           CSD015
      *                                                                                       CSD015
     C                   EVAL      Ctr = 1                                                    CSD015
      *                                                                                       CSD015
     C                   DOU       Ctr = ArrMax                                               CSD015
     C                   IF        WWLF(Ctr) <> *BLANKS AND                                   CSD015
     C                             %CHECK('0 ':WWLF(Ctr)) <> 0                                CSD015
     C                   EVAL      WOKFlg = 'Y'                                               CSD015
     C                   LEAVE                                                                CSD015
     C                   ENDIF                                                                CSD015
     C                   EVAL      Ctr = Ctr + 1                                              CSD015
     C                   ENDDO                                                                CSD015
      *                                                                                       CSD015
      ** Check the Payment Details.                                                           CSD015
      *                                                                                       CSD015
     C                   IF        WOKFlg = 'N'                                               CSD015
     C                   IF        WDTP1 <> *BLANKS OR                                        CSD015
     C                             WDTP2 <> *BLANKS OR                                        CSD015
     C                             WDTP3 <> *BLANKS OR                                        CSD015
     C                             WDTP4 <> *BLANKS                                           CSD015
     C                   EVAL      WOKFlg = 'Y'                                               CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      ** Stop checking if the OK Flag has been set.                                           CSD015
      *                                                                                       CSD015
     C                   IF        WOKFlg = 'Y'                                               CSD015
     C                   LEAVE                                                                CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDFOR                                                               CSD015
      *                                                                                       CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRMVXSTXP - Adds Extended Settlement XML Packets to the       *                       CSD015
      *             Compliance Engine Free Format string.             *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRMVXSTXP     BEGSR                                                                CSD015
      *                                                                                       CSD015
     C                   FOR       WItr = 1 TO 2                                              CSD015
      *                                                                                       CSD015
     C                   MOVEA     *BLANKS       WLF                                          CSD015
     C                   MOVEA     *BLANKS       WLFSD                                        CSD015
     C                   CLEAR                   DLGXST                                       CSD015
      *                                                                                       CSD015
      ** Add Maturity Settlements on the first iteration and                                  CSD015
      ** Value Settlements on the second iteration.                                           CSD015
      *                                                                                       CSD015
     C                   IF        WItr = 1                                                   CSD015
     C                   MOVEA     MWLF          WLF                                          CSD015
     C                   MOVE      MXST          DLGXST                                       CSD015
     C                   EVAL      WDetFlg = WMDtFlg                                          CSD015
     C                   EVAL      WRSCY = MXPSCY                                             CSD015
     C                   EVAL      WPSCY = MXRSCY                                             CSD015
     C                   ELSE                                                                 CSD015
     C                   MOVEA     VWLF          WLF                                          CSD015
     C                   MOVE      VXST          DLGXST                                       CSD015
     C                   EVAL      WDetFlg = WVDtFlg                                          CSD015
      *                                                                                       CSD015
      ** Set usual denominations for transactions of type VAL.                                CSD015
      *                                                                                       CSD015
     C                   EVAL      WRSCY = VXRSCY                                             CSD015
     C                   EVAL      WPSCY = VXPSCY                                             CSD015
     C                   EVAL      WDEN1 = W4DEN1                                             CSD015
     C                   EVAL      WDEN2 = W4DEN2                                             CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      ** Initialise additional standing data.                                                 CSD015
      *                                                                                       CSD015
     C                   MOVEA     *BLANKS       WLFSD                                        CSD015
     C                   MOVEL     GXRXRIBA      WLFSD(2)                                     CSD015
     C                   MOVEL     GXRXPIBA      WLFSD(6)                                     CSD015
     C                   MOVEL     GXRXRCRA      WLFSD(9)                                     CSD015
     C                   MOVEL     GXRXAWBA      WLFSD(11)                                    CSD015
     C                   MOVEL     GXRXBENA      WLFSD(12)                                    CSD015
      *                                                                                       CSD015
      ** Initialise working variables.                                                        CSD015
      *                                                                                       CSD015
     C                   EVAL      WDTP1 = GXRXDTP1                                           CSD015
     C                   EVAL      WDTP2 = GXRXDTP2                                           CSD015
     C                   EVAL      WDTP3 = GXRXDTP3                                           CSD015
     C                   EVAL      WDTP4 = GXRXDTP4                                           CSD015
      *                                                                                       CSD015
      ** Build the XML Packet chain.                                                          CSD015
      *                                                                                       CSD015
     C                   EXSR      SRBldXPC                                                   CSD015
      *                                                                                       CSD015
     C                   ENDFOR                                                               CSD015
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
      *                                                                                       CSD015
      ** Move database file fields into watch list fields array                               CSD015
      *                                                                                       CSD015
     C                   EXSR      SRDBFsToWLFs                                               CSD015
      *                                                                                       CSD015
      ** Check if watch list engine needs to be called                                        CSD015
      *                                                                                       CSD015
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
      ** Verify if transaction is on the hit list file but Unconfirmed                        CSD015
      *                                                                                       CSD015
     C                   EXSR      SRRetryChk                                                 CSD015
      *                                                                                       CSD015
     C                   IF        WRetryFlg = 'Y'                                            CSD015
     C                   EVAL      WMoveMode = ALL                                            CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      WMoveMode = CHANGED                                        CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
      ** Move database file fields into watch list fields array                               CSD015
      *                                                                                       CSD015
     C                   EXSR      SRDBFsToWLFs                                               CSD015
      *                                                                                       CSD015
      ** Check if watch list engine needs to be called                                        CSD015
      *                                                                                       CSD015
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
     C                   EVAL      WDetFlg = 'Y'                                              CSD015
      *                                                                                       CSD015
     C                   WHEN      WMoveMode = CHANGED                                        CSD015
      *                                                                                       CSD015
      ** Move only the fields that have changed since the last save.                          CSD015
      *                                                                                       CSD015
     C                   EVAL      WChgFlg = 'N'                                              CSD015
     C                   EVAL      WDetFlg = 'N'                                              CSD015
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
     C                   EVAL      WDetFlg = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
      *                                                                                       CSD015
     C                   ENDSL                                                                CSD015
      *                                                                                       CSD015
      ** Consider Maturity and Value XST Details if CIR003 is enabled.                        CSD015
      *                                                                                       CSD015
     C                   IF        CIR003 = 'Y'                                               CSD015
     C                   EXSR      SRMVDB2W                                                   CSD015
     C                   ENDIF                                                                CSD015
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
     C                   IF        WLF(Ctr) <> *BLANKS AND                                    CSD015
     C                             %CHECK('0 ':WLF(Ctr)) <> 0                                 CSD015
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
      ** Check the Maturity and Value XST Details if CIR003 is enabled.                       CSD015
      *                                                                                       CSD015
     C                   IF        CIR003 = 'Y' AND                                           CSD015
     C                             WOKFlg = 'N'                                               CSD015
     C                   EXSR      SRMVWLFC                                                   CSD015
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
     C                   EVAL      KFuncType = *BLANKS                                        CSD015
     C                   EVAL      KIden = *BLANKS                                            CSD015
     C                   EVAL      KBranch = *BLANKS                                          CSD015
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
     C                   IF        @RtCd <> '*NRF'                                            CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = @Optn                                              CSD015
     C                   EVAL      DBFile = 'SDCUSTPD'                                        CSD015
     C                   EVAL      DBase = 913                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
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
     C                   PARM      *BLANKS       @RtCd                                        CSD015
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
     C/COPY WNCPYSRC,IRH00071
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
      ** If existing transaction was amended, authorised or deleted, update Last Change       CRE020
      ** Type, Authorise Indicator and Print Advice Indicator                                 CRE020
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
      /EJECT                                                                                  236776
      *****************************************************************                       236776
      *                                                               *                       236776
      *  SRGenMsg - Resets PMTP flag to 'Y' when settlement details   *                       236776
      *             were amended and principal change message have    *                       236776
      *             already been generated.                           *                       236776
      *                                                               *                       236776
      *****************************************************************                       236776
     C     SRGenMsg      BEGSR                                                                236776
                                                                                              236776
     C     RXDLNO        SETLL     DLPCSCD0                                                   236776
     C     RXDLNO        READE     DLPCSCD0                               98                  236776
                                                                                              236776
     C     *IN98         DOWEQ     '0'                                                        236776
     C     PCDTPR        IFNE      'Y'                                                        236776
     C     PCPMTP        ANDEQ     'Y'                                                        236776
                                                                                              236776
     C     PCOTIN        IFEQ      'T'                                                        236776
     C     WAMDS         IFEQ      'V'                                                        236776
     C     RXTPAMT       ANDLT     PCPAMT                                                     236776
     C     WAMDS         OREQ      'M'                                                        236776
     C     RXTPAMT       ANDGT     PCPAMT                                                     236776
     C                   MOVE      ' '           PCPMTP                                       236776
     C                   UPDATE    DLPCSCD0                                                   236776
     C                   ENDIF                                                                236776
     C                   ENDIF                                                                236776
                                                                                              236776
     C     PCOTIN        IFEQ      'U'                                                        236776
     C     WAMDS         IFEQ      'M'                                                        236776
     C     RXTPAMT       ANDGT     PCPAMT                                                     236776
     C     WAMDS         OREQ      'V'                                                        236776
     C     RXTPAMT       ANDLT     PCPAMT                                                     236776
     C                   MOVE      ' '           PCPMTP                                       236776
     C                   UPDATE    DLPCSCD0                                                   236776
     C                   ENDIF                                                                236776
     C                   ENDIF                                                                236776
                                                                                              236776
     C                   ENDIF                                                                236776
     C     RXDLNO        READE     DLPCSCD0                               98                  236776
     C                   ENDDO                                                                236776
                                                                                              236776
     C                   ENDSR                                                                236776
      *****************************************************************                       236776
      /EJECT                                                                                 BUG6418
     C****************************************************************                       BUG6418
     C*                                                              *                       BUG6418
     C* TLXDUE - DETERMINE TELEX DUE DATE                            *                       BUG6418
     C*                                                              *                       BUG6418
     C****************************************************************                       BUG6418
     C     TLXDUE        BEGSR                                                               BUG6418
      *                                                                                      BUG6418
     C                   CALLB     'ZATLXDUEDT'                                              BUG6418
      *                                                                                      BUG6418
      ** Deal or local Currency                                                              BUG6418
     C                   PARM                    @DLOLC            1                         BUG6418
      *                                                                                      BUG6418
      ** Currency                                                                            BUG6418
     C                   PARM                    @CCY              3                         BUG6418
      *                                                                                      BUG6418
      ** Nostro                                                                              BUG6418
     C                   PARM                    @NOSTR            2                         BUG6418
      *                                                                                      BUG6418
      ** Date of Next Working Day                                                            BUG6418
     C                   PARM                    BJDNWD            5 0                       BUG6418
      *                                                                                      BUG6418
      ** Local Currency                                                                      BUG6418
     C                   PARM                    BJLCCY            3                         BUG6418
      *                                                                                      BUG6418
      ** System Location                                                                     BUG6418
     C                   PARM                    BJSLCD            3                         BUG6418
      *                                                                                      BUG6418
      ** Telex Due Date                                                                      BUG6418
     C                   PARM      *ZERO         @TLXDU            5 0                       BUG6418
     C                   ENDSR                                                               BUG6418
     C****************************************************************                       BUG6418
      /EJECT
      /COPY ZACPYSRC,PSSR_ILE
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
     C                   PARM                    IRVCIRS
     C                   PARM                    IRVXSIR                                      CLE025
     C**********         PARM                    OurRatChgs      294                   CAP004 CAP043
     C**********         PARM                    OurPayDats      294                   CAP004 CAP043
     C**********         PARM                    ThrRatChgs      294                   CAP004 CAP043
     C**********         PARM                    ThrPayDats      294                   CAP004 CAP043
     C                   PARM                    ScreenInpt                     CAP004
     C                   PARM                    ValExtSettV                                  CIR003
     C                   PARM                    ValExtSettI                                  CIR003
     C                   PARM                    ValExtSettM                                  CIR003
     C                   PARM                    CIR008                                       CIR008
     C                   PARM                    CAP056                                       CAP056
     C                   PARM                    SUEINR                                     MD054095
     C                   PARM                    STEINR                                     MD054095
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
     C     *LIKE         DEFINE    L2CYR1        ##L2CYR1                                     235490
     C     *LIKE         DEFINE    L2CYR2        ##L2CYR2                                     235490
     C     *LIKE         DEFINE    L2CYR3        ##L2CYR3                                     235490
     C     *LIKE         DEFINE    L2CYR4        ##L2CYR4                                     235490
     C     *LIKE         DEFINE    L2CYR5        ##L2CYR5                                     235490
     C     *LIKE         DEFINE    L2CYR6        ##L2CYR6                                     235490
     C     *LIKE         DEFINE    L2CYR7        ##L2CYR7                                     235490
     C     *LIKE         DEFINE    L2CYR8        ##L2CYR8                                     235490
     C     *LIKE         DEFINE    L2CYR9        ##L2CYR9                                     235490
     C     *LIKE         DEFINE    L2CYR0        ##L2CYR0                                     235490
     C     *LIKE         DEFINE    BQFIRA        WkFIRA                                       CAP056
     C     *LIKE         DEFINE    BQFIAU        WkFIAU                                       CAP056
      *
      ** Partial Key for DLDTSCPD                                               CAP004
     C     KDTSC         KLIST                                                  CAP004
     C                   KFLD                    DLNO                           CAP004
     C                                                                          CAP004
      *                                                                                       CIR003
      ** Partial Key for LF/DLGXSTL0                                                          CIR003
      *                                                                                       CIR003
     C     KGXST         KLIST                                                                CIR003
     C                   KFLD                    KDLNO             6 0                        CIR003
     C                   KFLD                    KEDCD             3                          CIR003
      *                                                                                       CIR003
     C     KIRCList      KLIST                                                                CAP043
     C                   KFLD                    RXFRNT                                       CAP043
                                                                                              CAP043
     C     KIRSDL        KLIST                                                                CAP043
     C                   KFLD                    RXDLNO                                       CAP043
     C                   KFLD                    PVYOURTHR                                    CAP043
     C                   KFLD                    PCPRDT                                       CAP043
                                                                                              CAP043
     C     KIRSDP        KLIST                                                                CAP043
     C                   KFLD                    RXDLNO                                       CAP043
     C                   KFLD                    PVYOURTHR                                    CAP043
                                                                                              CAP043
      ** Compliance Watch Hit List Key.                                                       CSD015
      *                                                                                       CSD015
     C     KCWHT         KLIST                                                                CSD015
     C                   KFLD                    KFuncType                                    CSD015
     C                   KFLD                    KIden                                        CSD015
     C                   KFLD                    KBranch                                      CSD015
                                                                                              CRE020
      ** Midas RE Settled Transaction Index File Key List                                     CRE020
                                                                                              CRE020
     C     KADVC         KLIST                                                                CRE020
     C                   KFLD                    KRefNo                                       CRE020
     C                   KFLD                    KPrgMn                                       CRE020
      *                                                                                       CSD015
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
      *
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
     C/COPY WNCPYSRC,IRCIRSDC09
      *                                                                         CAP004
      ** Access SAR details for Business Day Conventions                        CIR005
      *                                                                         CIR005
     C                   CALL      'AOSARDR0'                                   CIR005
     C                   PARM      *BLANKS       @RTCD                          CIR005
     C                   PARM      '*VERIFY'     @OPTN                          CIR005
     C                   PARM      'CIR005'      @SARD                          CIR005
     C     SCSARD        PARM      SCSARD        DSFDY                          CIR005
      *                                                                         CIR005
      ** DATABASE ERROR                                                         CIR005
      *                                                                         CIR005
     C                   IF        @RTCD <> *Blanks and @RTCD <> '*NRF   '      CIR005
     C     *LOCK         IN        LDA                                          CIR005
     C                   MOVEL     'CIR005'      DBKEY                          CIR005
     C                   MOVEL     'SCSARDPD'    DBFILE                         CIR005
     C                   Z-ADD     906           DBASE                          CIR005
     C                   OUT       LDA                                          CIR005
     C                   EXSR      *PSSR                                        CIR005
     C                   ENDIF                                                  CIR005
      *                                                                         CIR005
     C                   IF        @RTCD = *BLANK                               CIR005
     C                   MOVEL     'Y'           CIR005            1            CIR005
     C                   ELSE                                                   CIR005
     C                   MOVEL     'N'           CIR005                         CIR005
     C                   ENDIF                                                  CIR005
      *                                                                                       CIR003
      ** Access SAR details for Additional Pay/Receive Messages for                           CIR003
      ** Exchanges of Principal on Cross Ccy IRS.                                             CIR003
      *                                                                                       CIR003
     C                   CALL      'AOSARDR0'                                                 CIR003
     C                   PARM      *BLANKS       @RTCD                                        CIR003
     C                   PARM      '*VERIFY'     @OPTN                                        CIR003
     C                   PARM      'CIR003'      @SARD                                        CIR003
     C     SCSARD        PARM      SCSARD        DSFDY                                        CIR003
      *                                                                                       CIR003
      ** DATABASE ERROR                                                                       CIR003
      *                                                                                       CIR003
     C                   IF        @RTCD <> *Blanks and @RTCD <> '*NRF   '                    CIR003
     C     *LOCK         IN        LDA                                                        CIR003
     C                   MOVEL     'CIR003'      DBKEY                                        CIR003
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CIR003
     C                   Z-ADD     907           DBASE                                        CIR003
     C                   OUT       LDA                                                        CIR003
     C                   EXSR      *PSSR                                                      CIR003
     C                   ENDIF                                                                CIR003
      *                                                                                       CIR003
     C                   IF        @RTCD = *BLANK                                             CIR003
     C                   MOVEL     'Y'           CIR003            1                          CIR003
     C                   ELSE                                                                 CIR003
     C                   MOVEL     'N'           CIR003                                       CIR003
     C                   ENDIF                                                                CIR003
      *                                                                         CIR005
      ** Determine if Data Export for CCRM Limits is active                     CDE001
     C                   CALL      'AOSARDR0'                                   CDE001
     C                   PARM      *BLANKS       @RTCD                          CDE001
     C                   PARM      '*VERIFY'     @OPTN                          CDE001
     C                   PARM      'CDE001'      @SARD                          CDE001
      *                                                                         CDE001
     C     @RTCD         IFEQ      *BLANK                                       CDE001
     C                   MOVEL     'Y'           CDE001            1            CDE001
     C                   ENDIF                                                  CDE001
      *                                                                         CDE001
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALL      'AOSARDR0'                                                 CSC011
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
     C                   EVAL      DBASE = 908                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
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
     C                   Z-ADD     908           DBASE                                        CAS001
     C                   MOVEL     'IRCIRSUPD'   DBPGM                                        CAS001
     C                   OUT       LDA                                                        CAS001
     C                   EXSR      *PSSR                                                      CAS001
     C                   ENDIF                                                                CAS001
      *                                                                                       CAS001
     C                   IF        PRTCD = *BLANK                                             CAS001
     C                   MOVEL     'Y'           CAS001                                       CAS001
     C                   ELSE                                                                 CAS001
     C                   MOVEL     'N'           CAS001                                       CAS001
     C                   ENDIF                                                                CAS001
                                                                                              CAS005
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
     C                   Z-ADD     909           DBASE                                        CAS005
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
                                                                                              CIR011
                                                                                              CAP043
      ** Check if CAP043 is installed                                                         CAP043
                                                                                              CAP043
     C                   CALL      'AOSARDR0'                                                 CAP043
     C                   PARM      *BLANKS       PRtCd                                        CAP043
     C                   PARM      '*VERIFY'     POptn                                        CAP043
     C                   PARM      'CAP043'      PSard                                        CAP043
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP043
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
     C                   EVAL      DBASE = 910                                                CAP043
     C                   OUT       LDA                                                        CAP043
     C                   EXSR      *PSSR                                                      CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CAP043
     C                   ENDIF                                                                CAP043
                                                                                              CSD015
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
     C                   EVAL      DBase = 909                                                CSD015
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
     C                   EVAL      DBase = 910                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      **  Access the Compliance Watch Configuration Data.                                     CSD015
                                                                                              CSD015
     C                   CALL      'AOCWCDR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*FIRST '     @Optn                                        CSD015
     C     SDCWCD        PARM      SDCWCD        DSSDY                                        CSD015
                                                                                              CSD015
     C                   IF        @RtCd <> *BLANKS                                           CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = @Optn                                              CSD015
     C                   EVAL      DBFile = 'SDCWCDPD'                                        CSD015
     C                   EVAL      DBase = 911                                                CSD015
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
     C                   EVAL      DBase = 912                                                CSD015
     C                   OUT       LDA                                                        CSD015
     C                   EXSR      SRERR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
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
     C                   EVAL      DBase = 914                                                CRE020
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
      *                                                                                       CRE020
     C                   EVAL      WSysVal01 = 'N'                                            CRE020
                                                                                              CRE020
     C                   IF        PRtCd = *BLANKS                                            CRE020
     C                   MOVEL     PCurSet01     WSysVal01                                    CRE020
     C                   ELSE                                                                 CRE020
                                                                                              CRE020
     C     *LOCK         IN        LDA                                                        CRE020
     C                   EVAL      DBFile = 'SDSVALPD'                                        CRE020
     C                   EVAL      DBase = 915                                                CRE020
     C                   EVAL      DBKey = PSysVal01                                          CRE020
     C                   OUT       LDA                                                        CRE020
     C                   EXSR      SRErr                                                      CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
      ** Check if enhancement CLE025 (Credit Lines) is on                                     CLE025
                                                                                              CLE025
     C                   CALL      'AOSARDR0'                                                 CLE025
     C                   PARM      *BLANKS       @RtCd                                        CLE025
     C                   PARM      '*VERIFY'     @Optn                                        CLE025
     C                   PARM      'CLE025'      @SARD                                        CLE025
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE025
                                                                                              CLE025
     C                   IF        @Rtcd <> *BLANKS AND @Rtcd <> '*NRF   '                    CLE025
     C     *LOCK         IN        LDA                                                        CLE025
     C                   EVAL      DBKey = 'CLE025'                                           CLE025
     C                   EVAL      DBFile = 'SCSARDPD'                                        CLE025
     C                   EVAL      DBase = 914                                                CLE025
     C                   OUT       LDA                                                        CLE025
     C                   EXSR      SRERR                                                      CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
     C                   IF        @RTCD = *BLANKS                                            CLE025
     C                   EVAL      CLE025 = 'Y'                                               CLE025
     C                   ELSE                                                                 CLE025
     C                   EVAL      CLE025 = 'N'                                               CLE025
     C                   ENDIF                                                                CLE025
                                                                                              CLE025
      ** Check if enhancement CDL028 (Automatic Rate Interpolation) is on                     CDL028
                                                                                              CDL028
     C                   CALL      'AOSARDR0'                                                 CDL028
     C                   PARM      *BLANKS       @RtCd                                        CDL028
     C                   PARM      '*VERIFY'     @Optn                                        CDL028
     C                   PARM      'CDL028'      @SARD                                        CDL028
     C     SCSARD        PARM      SCSARD        DSFDY                                        CDL028
                                                                                              CDL028
     C                   IF        @RtCd = *BLANKS                                            CDL028
     C                   EVAL      CDL028 = 'Y'                                               CDL028
     C                   ELSE                                                                 CDL028
     C                   EVAL      CDL028 = 'N'                                               CDL028
     C                   ENDIF                                                                CDL028
                                                                                              CDL028
      ***Check*whether*user*is*a*web*browser*user,*if*so*overwrite*****              BUG5291 BUG7095
     C**********         Call      'SFC000026'                                       BUG5291 BUG7095
     C**********         Parm      *Blanks       User             10                 BUG5291 BUG7095
      **********                                                                     BUG5291 BUG7095
     C**********         If        User <> *Blanks                                   BUG5291 BUG7095
     C**********         Eval      PSUser = User                                     BUG5291 BUG7095
     C**********         EndIf                                                       BUG5291 BUG7095
                                                                                     BUG5291 BUG7095
     C/COPY WNCPYSRC,IRCIRSDC13
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
     C                   Eval      DBASE = 916                                               BUG6671
     C                   OUT       LDA                                                       BUG6671
     C                   EXSR      *PSSR                                                     BUG6671
     C                   ENDIF                                                               BUG6671
      *                                                                                      BUG6671
     C                   If        PRTCD = *Blanks                                           BUG6671
     C                   Eval      CAP051 = 'Y'                                              BUG6671
     C                   Else                                                                BUG6671
     C                   Eval      CAP051 = 'N'                                              BUG6671
     C                   EndIf                                                               BUG6671
      ** Access SAR details to determine if enhancement CAS008                                CAS008
      ** is installed.                                                                        CAS008
                                                                                              CAS008
     C                   CALL      'AOSARDR0'                                                 CAS008
     C                   PARM      *BLANKS       PRTCD                                        CAS008
     C                   PARM      '*VERIFY'     POPTN                                        CAS008
     C                   PARM      'CAS008'      PSARD                                        CAS008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS008
                                                                                              CAS008
      ** Database Error                                                                       CAS008
                                                                                              CAS008
     C                   IF        PRTCD <> *BLANKS AND                                       CAS008
     C                             PRTCD <> '*NRF   '                                         CAS008
     C     *LOCK         IN        LDA                                                        CAS008
     C                   EVAL      DBKEY  = 'CAS008'                                          CAS008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS008
     C                   EVAL      DBASE  = 910                                               CAS008
     C                   EVAL      DBPGM  = 'IRCIRSUPD'                                       CAS008
     C                   OUT       LDA                                                        CAS008
     C                   EXSR      *PSSR                                                      CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
     C                   IF        PRTCD = *BLANK                                             CAS008
     C                   EVAL      CAS008 = 'Y'                                               CAS008
     C                   ELSE                                                                 CAS008
     C                   EVAL      CAS008 = 'N'                                               CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALL      'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRTCD                                        CSD083
     C                   PARM      '*VERIFY'     POPTN                                        CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
      ** Database Error                                                                       CSD083
                                                                                              CSD083
     C                   IF        PRTCD <> *BLANKS AND                                       CSD083
     C                             PRTCD <> '*NRF   '                                         CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBKEY  = 'CSD083'                                          CSD083
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBASE  = 917                                               CSD083
     C                   EVAL      DBPGM  = 'IRCIRSUPD'                                       CSD083
     C                   OUT       LDA                                                        CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRTCD = *BLANK                                             CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
     C/COPY WNCPYSRC,IRH00072
                                                                                              CSD083
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
     C                   EVAL      DBase = 24                                               MD054117
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
     C                   MOVEL     'IRCIRSUPD'   DBPGM            10
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
