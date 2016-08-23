     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Invalid buy-sell back repair')                *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEBYSLRPR - Invalid SE Buy-Sell Back Repair                  *
      *                                                               *
      *  Function:  This function allows invalid buy-sell backs to    *
      *             be 'repaired' and applied to the Midas database.  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CSF011A            Date 28Nov11               *
      *  Prev Amend No. AR698195B          Date 20Jan11               *
      *                 CSW210             Date 04May10               *
      *                 CER059             Date 19Jul10               *
      *                 CER054             Date 07Apr09               *
      *                 BUG22911           Date 17Feb09               *
      *                 CER048             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 249071             Date 31Jul07               *
      *                 249107             Date 13Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 234300             Date 29Sep06               *
      *                 CSD027             Date 09Dec05               *
      *                 CAP087             Date 17Aug05               *
      *                 CSE075             Date 17Nov05               *
      *                 233881             Date 02Jun05               *
      *                 233708             Date 02Jun05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE071             Date 19Jul05               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 23Oct03               *
      *                 CAS006             Date 21Jan03               *
      *                 216338             Date 21Jan03               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 210284             Date 08Nov02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 08Apr02               *
      *                 CSC011             Date 14Mar02               *
      *                 201429             Date 14Jan02               *
      *                 CAP067  *CREATE    Date 24Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR698195B - Added Front Office field on the buffer for TRADS *
      *             (Child: AR698196)                                 *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER054 - German Features - Church Tax (Recompile)            *
      *  BUG22911 - Changes for Correct Tax Calculation (Recompile)   *
      *  CER048 - German Features - Taxes (Recompile)                 *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249071 - CSE097 problems in BYSL(Recompile)                  *
      *  249107 - Missing parameter for calling SETRADSVAL            *
      *  234300 - Recompiled over changed in PF/HSTTRD.               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAP087  - Enable the use of SETRADVU to process Buy/Sell     *
      *            trades.                                            *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  233881 - EU Tax amount should be subtracted from the         *
      *           Countervalue.                                       *
      *  233708 - Addition of fields for CGL031(Recompile)            *
      *  CGL031 - Taxation of Savings Income.                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Parameter Mismatch                                  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  216338 - Add missing parameter                               *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  210284 - Current factor not applied to countervalue for 'MP' *
      *           Securities. Add checking to SEDEV for new current   *
      *           factor and if it exists, use it in calculating the  *
      *           countervalue. Amended to be consistent with SE0050. *
      *           Applied fix 201168.                                 *
      *  CSE031 - Coupon Fixing for Floating Rate Notes. (Recompile)  *
      *  CSC011 - 24x7 Midas Availabilty                              *
      *  201429 - New validation needed for ISO15022 in               *
      *           extended settlement screen.                         *
      *  CAP067 - Repurchase Agreements API.                          *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
     FSEIBYSLL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEIBYSLD0 : SEIBYSLX0)
 
     FSEIBYSLL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
     FTRADHS    IF   E           K DISK    INFSR(*PSSR)
 
      ** API Invalid Log File                                                                 CSC011
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR)                                       CSC011
     F                                     COMMIT                                             CSC011
                                                                                              CSC011
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SEBYSLR011
 
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
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
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D @EI             S              1    DIM(60)
      *
      ** Invalid Trade in Screen Format - SWIFT Details
     D InvTrSwftA    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(A)
      *
      ** Invalid Trade in Screen Format - SWIFT Details
     D InvTrSwftB    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(B)
      *
      ** Current Trade in File Format
     D CrTrFilFmt    E DS                  EXTNAME(TRADSD)
     D                                     PREFIX(C_)
      *
      ** Current Trade in File Format (Extension File)
     D CT1AFilFmt    E DS                  EXTNAME(TRADSDX1)
     D                                     PREFIX(CA_)
      *
      ** Current Trade in File Format (Extension File)
     D CT1BFilFmt    E DS                  EXTNAME(TRADSDX1)
     D                                     PREFIX(CB_)
      *
      ** (Current) Trade in Screen Format - Primary Details
     D CurTrPrim     E DS                  EXTNAME(SETRPRPD)
     D                                     PREFIX(@)
      *
      ** (Current) Trade in Screen Format - Secondary Details
     D CurTrSeco     E DS                  EXTNAME(SETRSEPD)
     D                                     PREFIX(@)
      *
      ** (Current) Trade in Screen Format - Third screen details                              CAS006
     D CurTrThir     E DS                  EXTNAME(SETRTHPD)                                  CAS006
     D                                     PREFIX(@)                                          CAS006
      *                                                                                       CAS006
      ** (Current) Trade in Screen Format - Exchange Rates Details
     D CurTrExch     E DS                  EXTNAME(SETREXPD)
     D                                     PREFIX(@)
      *
      ** (Current) Trade in Screen Format - Settlement Instructions
     D CurTrSett     E DS                  EXTNAME(SETRSTPD)
     D                                     PREFIX(@)
     D @DDCLTY2      E                     EXTFLD(DDCLTY)
      *
      ** (Current) Trade in Screen Format - Charges/Commissions
     D CurTrChCm     E DS                  EXTNAME(SETRCCPD)
     D                                     PREFIX(@)
      *
      ** (Current) Trade in Screen Format - SWIFT Details
     D CurTrSwftA    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(@A)
      *
      ** (Current) Trade in Screen Format - SWIFT Details
     D CurTrSwftB    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(@B)
      *
      ** New Trade in File Format
     D NwTrFilFmt    E DS                  EXTNAME(SEVBYSLPD)
      *
      ** New Trade in File Format
     D NwTrFilFmt1   E DS                  EXTNAME(SEVBYSLPD)
     D                                     PREFIX(W1)
      *
      ** New Trade in File Format
     D NwTrFilFmt2   E DS                  EXTNAME(SEVBYSLPD)
     D                                     PREFIX(W2)
      *
      ** New Trade in File Format (Extension File)
     D NT1AFilFmt    E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(A_)
      *
      ** New Trade in File Format (Extension File)
     D NT1AFilFmt1   E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(W1A_)
      *
      ** New Trade in File Format (Extension File)
     D NT1AFilFmt2   E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(W2A_)
      *
      ** New Trade in File Format (Extension File)
     D NT1BFilFmt    E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(B_)
      *
      ** New Trade in File Format (Extension File)
     D NT1BFilFmt1   E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(W1B_)
      *
      ** New Trade in File Format (Extension File)
     D NT1BFilFmt2   E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(W2B_)
      *                                                                                       222373
      **  New Trade In File Format (Extension File 1)                                         222373
     D SEVTRDX2A     E DS                  EXTNAME(SEVTRX2PD)                                 222373
     D                                     PREFIX(AA_)                                        222373
      *                                                                                       222373
      **  New Trade In File Format (Extension File 1)                                         222373
     D SEVTRDX2A1    E DS                  EXTNAME(SEVTRX2PD)                                 222373
     D                                     PREFIX(WAA_)                                       222373
      *                                                                                       222373
      **  New Trade In File Format (Extension File 1)                                         222373
     D SEVTRDX2B     E DS                  EXTNAME(SEVTRX2PD)                                 222373
     D                                     PREFIX(AB_)                                        222373
      *                                                                                       222373
      **  New Trade In File Format (Extension File 1)                                         222373
     D SEVTRDX2B1    E DS                  EXTNAME(SEVTRX2PD)                                 222373
     D                                     PREFIX(WAB_)                                       222373
      *
      ** New Trade in Screen Format - Primary Details
     D NewTrPrim     E DS                  EXTNAME(SETRPRPD)
      *
      ** New Trade in Screen Format - Primary Details
     D NewTrPrim1    E DS                  EXTNAME(SETRPRPD)
     D                                     PREFIX(W1)
      *
      ** New Trade in Screen Format - Primary Details
     D NewTrPrim2    E DS                  EXTNAME(SETRPRPD)
     D                                     PREFIX(W2)
      *
      ** New Trade in Screen Format - Secondary Details
     D NewTrSeco     E DS                  EXTNAME(SETRSEPD)
      *
      ** New Trade in Screen Format - Secondary Details
     D NewTrSeco1    E DS                  EXTNAME(SETRSEPD)
     D                                     PREFIX(W1)
      *
      ** New Trade in Screen Format - Secondary Details
     D NewTrSeco2    E DS                  EXTNAME(SETRSEPD)
     D                                     PREFIX(W2)
      *                                                                                       CAS006
      ** New Trade in Screen Format - Third Screen Details                                    CAS006
     D NewTrThir     E DS                  EXTNAME(SETRTHPD)                                  CAS006
      *                                                                                       CAS006
      ** New Trade in Screen Format - Third Screen Details                                    CAS006
     D NewTrThir1    E DS                  EXTNAME(SETRTHPD)                                  CAS006
     D                                     PREFIX(W1)                                         CAS006
      *                                                                                       CAS006
      ** New Trade in Screen Format - Third Screen Details                                    CAS006
     D NewTrThir2    E DS                  EXTNAME(SETRTHPD)                                  CAS006
     D                                     PREFIX(W2)                                         CAS006
      *
      ** New Trade in Screen Format - Exchange Rate Details
     D NewTrExch     E DS                  EXTNAME(SETREXPD)
      *
      ** New Trade in Screen Format - Exchange Rate Details
     D NewTrExch1    E DS                  EXTNAME(SETREXPD)
     D                                     PREFIX(W1)
      *
      ** New Trade in Screen Format - Exchange Rate Details
     D NewTrExch2    E DS                  EXTNAME(SETREXPD)
     D                                     PREFIX(W2)
      *
      ** New Trade in Screen Format - Settlement Details
     D NewTrSett     E DS                  EXTNAME(SETRSTPD)
     D DDCLTY2       E                     EXTFLD(DDCLTY)
      *
      ** New Trade in Screen Format - Settlement Details
     D NewTrSett1    E DS                  EXTNAME(SETRSTPD)
     D                                     PREFIX(W1)
     D W1DDCLTY2     E                     EXTFLD(DDCLTY)
      *
      ** New Trade in Screen Format - Settlement Details
     D NewTrSett2    E DS                  EXTNAME(SETRSTPD)
     D                                     PREFIX(W2)
     D W1DDCLTY3     E                     EXTFLD(DDCLTY)
      *
      ** New Trade in Screen Format - Charge & Commission Details
     D NewTrChCm     E DS                  EXTNAME(SETRCCPD)
      *
      ** New Trade in Screen Format - Charge & Commission Details
     D NewTrChCm1    E DS                  EXTNAME(SETRCCPD)
     D                                     PREFIX(W1)
      *
      ** New Trade in Screen Format - Charge & Commission Details
     D NewTrChCm2    E DS                  EXTNAME(SETRCCPD)
     D                                     PREFIX(W2)
      *
      ** New Trade in Screen Format - SWIFT Details
     D NewTrSwftA    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(A_)
      *
      ** New Trade in Screen Format - SWIFT Details
     D NewTrSwftA1   E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(W1A_)
      *
      ** New Trade in Screen Format - SWIFT Details
     D NewTrSwftA2   E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(W2A_)
      *
      ** New Trade in Screen Format - SWIFT Details
     D NewTrSwftB    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(B_)
      *
      ** New Trade in Screen Format - SWIFT Details
     D NewTrSwftB1   E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(W1B_)
      *
      ** New Trade in Screen Format - SWIFT Details
     D NewTrSwftB2   E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(W2B_)
      *                                                                                       222373
      ** New Trade in Screen Format - Extension Details                                       222373
     D NewTrExts     E DS                  EXTNAME(SETESDPD)                                  222373
     D                                     PREFIX(EX)                                         222373
      *
      ** Previous Trade in Screen Format - Primary Details
     D PrvTrPrim     E DS                  EXTNAME(SETRPRPD)
     D                                     PREFIX(@P)
      *
      ** Previous Trade in Screen Format - Secondary Details
     D PrvTrSeco     E DS                  EXTNAME(SETRSEPD)
     D                                     PREFIX(@P)
      *                                                                                       CAS006
      ** Previous Trade in Screen Format - Third Screen Details                               CAS006
     D PrvTrThir     E DS                  EXTNAME(SETRTHPD)                                  CAS006
     D                                     PREFIX(@P)                                         CAS006
      *
      ** Previous Trade in Screen Format - Exchange Rate Details
     D PrvTrExch     E DS                  EXTNAME(SETREXPD)
     D                                     PREFIX(@P)
      *
      ** Previous Trade in Screen Format - Settlement Details
     D PrvTrSett     E DS                  EXTNAME(SETRSTPD)
     D                                     PREFIX(@P)
     D @PDDCLTY2     E                     EXTFLD(DDCLTY)
      *
      ** Previous Trade in Screen Format - Charge & Commission Details
     D PrvTrChCm     E DS                  EXTNAME(SETRCCPD)
     D                                     PREFIX(@P)
      *
      ** Previous Trade in Screen Format - SWIFT Details
     D PrvTrSwft     E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(@P)
                                                                                              222373
     D NwSEFilFmt    E DS                  EXTNAME(SEVTRX2PD)                                 222373
      *
      ** Error indicators
     D OKTrPrim      E DS                  EXTNAME(SEETRPRPD)
     D OKTrSeco      E DS                  EXTNAME(SEETRSEPD)
     D OKTrThir      E DS                  EXTNAME(SEETRTHPD)                                 CAS006
     D OKTrExch      E DS                  EXTNAME(SEETREXPD)
     D OKTrSett      E DS                  EXTNAME(SEETRSTPD)
     D DDCLTY2OK     E                     EXTFLD(DDCLTYOK)
     D OKTrChcm      E DS                  EXTNAME(SEETRCCPD)
     D OKTrSwft      E DS                  EXTNAME(SEETRSWPD)
     D OKTrExts      E DS                  EXTNAME(SEETESPD)                                  222373
      *
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
      *
      ** Investment Type Details
     D INVTP         E DS                  EXTNAME(INVTPD)
     D INV_RECI      E                     EXTFLD(RECI)
     D INV_LCD       E                     EXTFLD(LCD)
     D INV_CHTP      E                     EXTFLD(CHTP)
     D INV_TNLU      E                     EXTFLD(TNLU)
     D INV_NDEC      E                     EXTFLD(NDEC)                                       CAS006
      *
      ** The following /COPY includes the customer details data structure
     D/COPY SECPYSRC,SE_CUSTDT
      *
      ** The following /COPY includes the currency details data structures
     D/COPY SECPYSRC,SE_CCYDT
     D                 DS
      *
      **  Data structure for date in, to change format.
     D  DateIn                 1      8  0
     D  @@YY                   1      4  0
     D  @@MM                   5      6  0
     D  @@DD                   7      8  0
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for bank details
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** External DS for general ledger details
      *
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      ** External DS for securities trading details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External DS for Midas modules details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** External DS for SAR details
      *
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for access programs, long data structure
      *
     D ExtData       E DS                  EXTNAME(SETDEXPD)
      ** SE Trades Extra Data - File (D/B) format
      *
      ** 24X7 status data area                                                                CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SDSTAT data area                                                                     CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
                                                                                              CSC011
     D PMCWL           DS          9999                                                       CSD015
      ** Additional entry parameter for Midas Compliance Watch                                CSD015
                                                                                              CSD015
      ** TRADSDX2 record                                                                      216338
     D PTradeX2      E DS                  EXTNAME(TRADSDX2)                                  216338
     D                                     PREFIX(X2:2)                                       216338
                                                                                              216338
     D/COPY QWINDSRC,SETRADGDTA
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Work variables for timestamo, FO id
     D @TMESTPSEL      S             26Z
     D PFTMESTPSEL     S             26Z
     D PFFOTRANSEL     S             20A
      *
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
      *
      ** Fields for getting the starting field number from file (parameters
      ** to ZACGTFLDNO, plus the offset to the requested field).
     D Format          S             10A   INZ('SETRADPD')
     D FieldP          S             10A   INZ('DDACTN')
     D FieldS          S             10A   INZ('DDSETC')
     D FieldNo         S              5P 0
     D FldOffsetP      S              5P 0
     D FldOffsetS      S              5P 0
      *
      ** Country of treaty
     D PDRBW           S              2A
      *
      ** Withholding tax
     D DDWTAX          S             15A
      *
      ** Swift 2001 flag
     D CSW201          S              1A
      *
      ** Last screen before update
     D WLScrn          S              1A
      *
      ** Second buy-sell processed
     D PSBYSL          S              1A
      *
     D CSC011          S              1A                                                      CSC011
     D KMsgType        S              8A                                                      CSC011
     D KFrntOfcID      S             20A                                                      CSC011
     D KTimeStamp      S                   LIKE(@TMESTPSEL)                                   CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
                                                                                              CSC011
     D PMODE           S              3                                                       216338
                                                                                              216338
     D CAS006          S              1                                                       CAS006
     D DDHACR          S             13                                                       CAS006
     D DDPRICN         S             17                                                       CAS006
     D WIdx_TVAL       S              3  0                                                    CAS006
                                                                                              CAS006
      ** CGL031 Switchable Feature                                                            CGL031
                                                                                              CGL031
     D CGL031          S              1A                                                      CGL031
                                                                                              CGL031
     D PCALL           S              3A                                                      222373
     D CallFromVU      S              1A   INZ(' ')                                           CAP087
      ** Front office id variable.                                                         AR698195B
     D DDFRNT          S             20A                                                   AR698195B
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SEBYSLR012
      *
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      /COPY WNCPYSRC,SEBYSLR001
      *
      ** Issue rollback to clear any possible updates in window functions
      *
     C     @INKE         IFEQ      '1'
     C     @INKL         OREQ      '1'
     C                   ROLBK
     C                   ENDIF
      *
      /COPY WNCPYSRC,SEBYSLR002
      *
      ** DO Screen: Browse invalid buy-sell backs
      *
     C     WScrn         IFEQ      'I'
     C                   EXSR      SRScrnI
     C                   ENDIF
      *
      /COPY WNCPYSRC,SEBYSLR003
      *
      ** Read next browse subfile record
      *
     C     WScrn         IFEQ      'R'
     C                   EXSR      SRRdNBrw
     C                   ENDIF
      *
      /COPY WNCPYSRC,SEBYSLR004
      *
      ** DO WHILE screen: Primary Details Screen
      *
     C                   Z-ADD     *ZERO         WIdx_PVAL         3 0
     C     WScrn         DOWEQ     'P'
     C                   EXSR      SRScrnP
     C                   ENDDO
      *
      /COPY WNCPYSRC,SEBYSLR005
      *
      ** DO WHILE screen: Secondary Details Screen
      *
     C                   Z-ADD     *ZERO         WIdx_SVAL         3 0
     C     WScrn         DOWEQ     'S'
     C                   EXSR      SRScrnS
     C                   ENDDO
                                                                                              CAS006
      /COPY WNCPYSRC,SEBYSLR017                                                               CAS006
                                                                                              CAS006
      ** DO WHILE screen: Third Details Screen                                                CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EVAL      WIdx_TVAL = 0                                              CAS006
     C                   DOW       WScrn = 'H'                                                CAS006
     C                   EXSR      SRScrnT                                                    CAS006
     C                   ENDDO                                                                CAS006
     C                   ENDIF                                                                CAS006
      *
      /COPY WNCPYSRC,SEBYSLR006
      *
      ** DO WHILE screen: Other Details Screen
      *
     C                   Z-ADD     *ZERO         WIdx_OVAL         3 0
     C     WScrn         DOWEQ     'O'
     C                   EXSR      SRScrnO
     C                   ENDDO
      *
      /COPY WNCPYSRC,SEBYSLR007
      *
      ** DO WHILE screen: Extension (SWIFT) Details Screen A
      *
     C                   Z-ADD     *ZERO         WIdx_EVALA        3 0
     C                   EVAL      PUYAT = 'N'                                                201429
     C     WScrn         DOWEQ     'A'
     C                   EXSR      SRScrnE1
     C                   ENDDO
      *
      /COPY WNCPYSRC,SEBYSLR008
      *
      ** DO WHILE screen: Extension (SWIFT) Details Screen B
      *
     C                   Z-ADD     *ZERO         WIdx_EVALB        3 0
     C                   EVAL      PUYAT = 'N'                                                201429
     C     WScrn         DOWEQ     'B'
     C                   EXSR      SRScrnE2
     C                   ENDDO
      *
      /COPY WNCPYSRC,SEBYSLR009
      *
      ** Screen: Window
      *
     C     WScrn         IFEQ      'W'
     C                   EXSR      SRWindow
     C                   ENDIF
      *
      ** Do File updates
      *
     C     WScrn         IFEQ      'U'
     C                   EXSR      SRUpdate
     C                   ENDIF
      *
      /COPY WNCPYSRC,SEBYSLR010
      *
      ** Terminate program
      *
     C     WScrn         IFEQ      'T'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWindow - Call window manager                               *
      *                                                               *
      *****************************************************************
      *
     C     SRWindow      BEGSR
      *
      ** Reset Errors
      *
     C                   MOVE      *ALL'Y'       OKTrSwft
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** If trade reference is not defined (On Insert),
      ** get next available trade reference
      *
     C     DDTDRF        IFEQ      *BLANK
      *
     C                   IF        PFBYSL = 'Y'
     C                   EVAL      WFTrdBlk = 'Y'
     C                   ENDIF
      *
     C                   CALLB     'ZATRNRTV'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      'SE'          PMODU
     C                   PARM      'T'           PTRTY
     C                   PARM                    DDTDRF
     C                   PARM      *ZEROS        TDRF
      *
      ** Database Error
      *
     C     RetCodeOut    IFNE      *BLANK
     C                   MOVEL     'ZATRNRTV'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     DDTDRF        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Check if first leg is the same as second leg, if yes, generate
      ** another ref for the trade with initial blank reference.
      *
     C                   IF        PFBYSL <> 'Y' AND
     C                             W1DDTDRF = DDTDRF
      *
     C                   MOVEL     DDTDRF        PTDRF
     C                   DOU       NOT(*IN01)
     C                   ADD       1             PTDRF             6 0
     C                   MOVEL     PTDRF         WPTDRF
     C     WPTDRF        SETLL     TRADSDF                                01
     C                   IF        NOT(*IN01)
     C     WPTDRF        SETLL     HSTTRDF                                01
     C                   ENDIF
     C                   ENDDO
      *
     C                   IF        WFTrdBlk <> 'Y'
     C                   EVAL      DDTDRF = WPTDRF
     C                   ELSE
     C                   EVAL      W1DDTDRF = WPTDRF
     C                   ENDIF
 
     C                   ENDIF
 
     C/COPY QWINDSRC,SETRADMOV1
 
     C                   CALL      'WN0010'
     C                   PARM      'SETRADRPR'   #PGM             10
     C                   PARM                    FKEY              2
     C                   PARM      DDACTN        ACTION            1
     C                   PARM                    DATA
     C                   PARM      *BLANKS       #RTRN             7
     C                   PARM                    SPAREW          256
      *
      ** Process returned command keys
      *
     C     #RTRN         IFEQ      'Y2U9999'
     C                   EXSR      SREndP
     C                   ELSE
      *
      ** If Cmd12 pressed, or in enquiry, return to initial screen;
      ** otherwise, go to settlements screen
      *
     C     #RTRN         IFEQ      'USR0790'
     C     DDACTN        OREQ      'E'
     C     @RDNB         IFEQ      'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
     C                   EXSR      SRInitial
     C                   ENDIF
     C                   ELSE
     C                   EVAL      WScrn = 'U'
     C                   ENDIF
     C                   ENDIF
      *
     C     Wind          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SEBYSLR013
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrnI - Browse invalid first leg buy-sell backs            *
      *                                                               *
      *****************************************************************
      *
     C     SRScrnI       BEGSR
      *
      ** Reset read next browse subfile record
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      ** Build browse subfile
      *
     C                   CALLB     'SEBYSLRPB'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Build subfile
     C                   PARM      'Y'           @BDSFL            1
      *
      ** Read subfile record
     C                   PARM      *BLANK        @RDSFL            1
      *
      ** Error in update of previous deal
     C                   PARM                    @ERRUP            1
      *
      ** OUTPUT
      ** ======
      *
      ** Error message
     C                   PARM      *BLANK        @ERRMS            7
      *
      ** Option selcted
     C                   PARM                    @OPSEL            1
      *
      ** Action selected
     C                   PARM                    @ACSEL            1
      *
      ** FO transaction id selected
     C                   PARM                    @FOTRANSEL       20
      *
      ** Timestamp of transaction selected
     C                   PARM                    @TMESTPSEL
      *
      ** Command keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      ** Successfully Inserted first leg
     C                   PARM                    @SITR
      *
      ** Successfully Inserted second leg
     C                   PARM                    PSITR
     C                   PARM                    CSC011                                       CSC011
      *
      ** If error, set on external switches
      *
     C     @ERRMS        IFNE      *BLANK
     C                   MOVE      '1'           *INU6
     C                   ENDIF
      *
      ** If CK/3 or CK/12 taken in browse, or error message
      ** End program
      *
     C     @INKC         IFEQ      '1'
     C     @INKL         OREQ      '1'
     C     @ERRMS        ORNE      *BLANK
     C                   EXSR      SREndP
     C                   GOTO      ESRScrnI
     C                   ENDIF
      *
      ** Blank out narratives
     C                   EVAL      @SITR = *BLANKS
     C                   EVAL      PSITR = *BLANKS
      *
      * Read next browse subfile record
      *
     C                   MOVE      'Y'           @RDNB
     C                   MOVE      'R'           WScrn
      *
      ** Set first buy sell back indicator to 'Y'. This will
      ** be used in validation.
      *
     C                   EVAL      PFBYSL = 'Y'
     C                   EVAL      PSBYSL = 'N'
     C                   EVAL      WFTrdBlk = *BLANK
      *
     C     ESRScrnI      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdNBrw - Read next browse subfile record                   *
      *                                                               *
      *****************************************************************
      *
     C     SRRdNBrw      BEGSR
      *
      ** Read next subfile record
      *
     C                   CALLB     'SEBYSLRPB'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Ccode
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Build Subfile
     C                   PARM      *BLANK        @BDSFL
      *
      ** Read Subfile record
     C                   PARM      'Y'           @RDSFL
      *
      ** Error in update of previous deal
     C                   PARM                    @ERRUP
      *
      ** OUTPUT
      ** ======
      *
      ** Error message
     C                   PARM      *BLANK        @ERRMS
      *
      ** Option selected
     C                   PARM      *BLANK        @OPSEL
      *
      ** Action selected
     C                   PARM      *BLANK        @ACSEL
      *
      ** FO Transaction ID Selected
     C                   PARM      *BLANK        @FOTRANSEL
      *
      ** Timestamp
     C                   PARM                    @TMESTPSEL
      *
      ** Command Keys
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKL
      *
      ** Successfully Inserted Deal Number
     C                   PARM                    @SITR
      *
      ** Successfully Inserted second leg
     C                   PARM                    PSITR
     C                   PARM                    CSC011                                       CSC011
      *
      ** If CK/3 taken within invalid transaction deletion function,
      ** End program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      SREndP
     C                   GOTO      ESRRdNbrw
     C                   ENDIF
      *
      ** Process invalid buy-sell back read from subfile
      *
     C     @OPSEL        IFNE      *BLANK
     C                   EXSR      SRPrInv
     C                   ELSE
      *
      ** Else, if no invalid trade read from subfile
      ** Go to browse screen
      *
     C                   MOVE      'I'           WScrn
     C                   ENDIF
      *
     C     ESRRdNbrw     ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrInv - Process invalid trade                              *
      *                                                               *
      *****************************************************************
      *
     C     SrPrInv       BEGSR
      *
      ** Blank the screens
      *
     C                   MOVEL     *BLANK        NewTrPrim
     C                   MOVEL     *BLANK        NewTrSeco
     C                   MOVEL     *BLANK        NewTrThir                                    CAS006
     C                   MOVEL     *BLANK        NewTrExch
     C                   MOVEL     *BLANK        NewTrSett
     C                   MOVEL     *BLANK        NewTrChcm
     C                   MOVEL     *BLANK        NewTrSwftA
     C                   MOVEL     *BLANK        NewTrSwftB
     C                   MOVEL     *BLANK        DDSTAT
     C                   MOVEL     *BLANK        DDAUTH
     C                   MOVEL     *BLANK        DDSRNME
     C                   MOVEL     *BLANK        DDCRNM
     C                   MOVEL     *BLANK        DDCFCT
     C                   MOVEL     *BLANK        DDCPNR
     C                   MOVEL     *BLANK        DDMAMT
     C                   MOVEL     *BLANK        DDSPXR
     C                   MOVEL     *BLANK        DDSPMD
     C                   MOVEL     *BLANK        DDTCTR
      *
      ** Reset errors
      *
     C                   MOVE      *ALL'Y'       OKTrPrim
     C                   MOVE      *ALL'Y'       OKTrSeco
     C                   MOVE      *ALL'Y'       OKTrThir                                     CAS006
     C                   MOVE      *ALL'Y'       OKTrExch
     C                   MOVE      *ALL'Y'       OKTrSett
     C                   MOVE      *ALL'Y'       OKTrChcm
     C                   MOVE      *ALL'Y'       OKTrSwft
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
     C                   MOVEL     *BLANKS       ##ACTN
     C                   MOVEL     *BLANKS       ##TDRF
     C                   MOVEL     *BLANKS       ##SETC
     C                   MOVEL     *BLANKS       ##CNUM
 
     C                   MOVEL     *BLANKS       A_##TDRF
     C                   MOVEL     *BLANKS       A_##TDTP
     C                   MOVEL     *BLANKS       A_##SMTH
     C                   MOVEL     *BLANKS       A_##CLTY
     C                   MOVEL     *BLANKS       A_##PCOD
     C                   MOVEL     *BLANKS       A_##PRYC
     C                   MOVEL     *BLANKS       A_##CNUM
     C                   MOVEL     *BLANKS       A_##DELF
     C                   MOVEL     *BLANKS       A_##DELT
 
     C                   MOVEL     *BLANKS       B_##TDRF
     C                   MOVEL     *BLANKS       B_##TDTP
     C                   MOVEL     *BLANKS       B_##SMTH
     C                   MOVEL     *BLANKS       B_##CLTY
     C                   MOVEL     *BLANKS       B_##PCOD
     C                   MOVEL     *BLANKS       B_##PRYC
     C                   MOVEL     *BLANKS       B_##CNUM
     C                   MOVEL     *BLANKS       B_##DELF
     C                   MOVEL     *BLANKS       B_##DELT
      *
      ** Retrieve trade details
      *
     C                   MOVEL     @ACSEL        DDACTN
     C                   MOVEL     @FOTRANSEL    FOTRID
      *
      ** Make sure Invalid transaction's  details are passed to 'Retrieve'
      ** module for SPF checking .
      *
     C     ZATRNKX0      CHAIN     SEIBYSLX0                          99
      *
     C                   MOVEL     '*FRONT'      @@MODE
      *
     C                   EXSR      SRRtvTrd
      *
      ** Now overwite the fields on the main details screen with those
      ** on the invalid trades file (except for the Midas trade
      ** reference retrieved above using the front office transaction ID).
      ** Access invalid deal with timestamp and front office transaction ID.
      *
     C     ZATRNKX0      CHAIN     SEIBYSLX0                          99
      *
      ** Set up SWIFT 'A' and 'B' screens
      *
     C                   MOVEL     InvTrSwftA    NewTrSwftA
     C                   MOVEL     InvTrSwftB    NewTrSwftB
      *
      ** If action code, or trade reference were NOT OK
      ** blank out action code so that the input cannot proceed
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDTDRFOK      OREQ      'N'
     C                   MOVEL     *BLANK        DDACTN
     C                   ENDIF
      *
      ** Send the trades error messages to the primary details screen
      ** and go to primary details screen
      *
     C                   EXSR      SRSndMP
     C                   MOVE      'P'           WScrn
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndMP - Send a message to primary details screen           *
      *                                                               *
      *****************************************************************
      *
     C     SRSndMP       BEGSR
 
     C                   Z-ADD     Idx           E                 3 0
      *
      ** If there are fundamental errors in this transaction
      ** Identify this fact.
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDTDRFOK      OREQ      'N'
     C                   ADD       1             E
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     'APM0110'     MsgIdArr(E)
     C                   ENDIF
      *
      ** Initialize error indicators
      *
     C                   MOVEA     OKTrPrim      @EI
      *
      ** Read error messages for trade
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
 
     C     ABFIELDID     IFLT      FldOffsetS
     C     DDACTN        OREQ      ' '
     C     DDACTN        OREQ      'I'
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffsetP    F
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   ENDIF
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF
 
     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   ENDDO
      *
     C                   MOVEA     @EI           OKTrPrim
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSndMS - Send a message to secondary details screen          *
      *                                                               *
      *****************************************************************
      *
     C     SRSndMS       BEGSR
      *
      ** Initialize error indicators
      *
     C                   MOVEA     OKTrSeco      @EI
      *
      ** Read error messages for trade
      *
     C     ZATRNKD0      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
 
     C     ABFIELDID     IFGE      FldOffsetS
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffsetS    F
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   ENDIF
     C                   MOVE      'N'           @EI(F)
     C                   ENDIF
 
     C     ZATRNKD0      READE     ZATRNERRD0                             99
     C                   ENDDO
      *
     C                   MOVEA     @EI           OKTrSeco
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrnP - Process primary details screen                     *
      *                                                               *
      *****************************************************************
      *
     C     SRScrnP       BEGSR
      *
      ** If second leg processing, get second leg details
      *
     C                   IF        PFBYSL = 'N' AND
     C                             PSBYSL = 'Y'
     C                   EVAL      NwTrFilFmt = NwTrFilFmt2
     C                   EVAL      NT1AFilFmt = NT1AFilFmt2
     C                   EVAL      NT1BFilFmt = NT1BFilFmt2
     C                   EVAL      NewTrPrim  = NewTrPrim2
     C                   EVAL      NewTrSeco  = NewTrSeco2
     C                   EVAL      NewTrThir  = NewTrThir2                                    CAS006
     C                   EVAL      NewTrExch  = NewTrExch2
     C                   EVAL      NewTrSett  = NewTrSett2
     C                   EVAL      NewTrChcm  = NewTrChcm2
     C                   EVAL      NewTrSwftA = NewTrSwftA2
     C                   EVAL      NewTrSwftB = NewTrSwftB2
     C                   EVAL      PSBYSL = 'N'
     C                   ENDIF
      *
      ** Enable/disable detail fields on primary details screen
      ** if changes to the data are allowed
      ** (key fields = action code & trade reference; detail fields = rest)
      ** (Action code can only be 'I' or ' ' in this subroutine)
      *
     C     DDACTN        IFEQ      'I'
     C     @OPSEL        ANDEQ     'U'
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EDTFD
     C                   ENDIF
      *
      ** Update 'previous' screen
     C                   MOVEL     NewTrPrim     PrvTrPrim
      *
      ** Write/Read Display Screen - Primary Details
      *
     C                   CALLB     'SETRADPDSP'
      *                             ==========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Trade (IN SCREEN FORMAT - Primary)
     C                   PARM                    NewTrPrim
      *
      ** Trade Status
      ** Trade Authorized/Not Authorized
     C                   PARM                    DDSTAT            9
     C                   PARM                    DDAUTH           14
      *
      ** Security report name
      ** Customer report name
     C                   PARM                    DDSRNME          41
     C                   PARM                    DDCRNM           20
      *
      ** Fields in error
     C                   PARM                    OKTrPrim
      *
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Enabled Key Fields
      ** Enabled Detail Fields
     C                   PARM      'N'           @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      ** Indicator if this program from SE0190
     C                   PARM      'N'           @FRPGM
      *
      ** Enabled Function Keys
      ** KG = Command Key 07 = READ PREVIOUS
      ** KH = Command Key 08 = READ NEXT
      ** KP = Command Key 15 = BROWSE
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM      'N'           @EINKP            1
      *
      ** Successful insert Trade
     C                   PARM                    @SITR             6
      *
      * Protect book on second leg
     C                   PARM                    IN50              1
     C                   PARM                    TRDBK1            2
      *
      ** Buy-sell back
     C                   PARM      'Y'           PBYSL             1
      *
      ** Successful insert Trade 2
     C                   PARM                    PSITR             6
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
      *
      ** Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
      *
      ** Blank out narratives
     C                   EVAL      @SITR = *BLANKS
     C                   EVAL      PSITR = *BLANKS
      *
      ** Reset Errors
      *
     C                   MOVE      *ALL'Y'       OKTrPrim
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** F3 - End Program
     C     @INKC         CASEQ     '1'           SREndP
      *
      ** F12 - Cancel on Primary Screen
     C     @INKL         CASEQ     '1'           SRCancP
      *
      ** Validate input to Primary screen
     C                   CAS                     SRValP
      *
     C                   ENDCS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValP - Validate input to primary details screen            *
      *                                                               *
      *****************************************************************
      *
     C     SRValP        BEGSR
      *
      ** Retrieve Trade details
      *
     C                   MOVEL     '      '      @@MODE
      *
     C                   EXSR      SRRtvTrd
      *
      ** If action code, or trade reference are NOT OK
      ** Re-output screen with error messages on it
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDTDRFOK      OREQ      'N'
     C                   GOTO      ESRValP
     C                   ENDIF
      *
      ** Prior to validation, initialize error indicators as 'OK'
      ** and clear Trade in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx_PVAL         3 0
     C                   MOVE      *ALL'Y'       OKTrPrim
     C                   CLEAR                   NwTrFilFmt
     C                   CLEAR                   NT1AFilFmt
     C                   CLEAR                   NT1BFilFmt
     C                   EXSR      SRClear
      *
      ** If first leg, initalize first buy-sell variables
      *
     C                   IF        PFBYSL = 'Y'
     C                   EVAL      PFBPBK = *BLANKS
     C**********         EVAL      PFTCNR = *ZEROS                                            CSD027
     C                   EVAL      PFTCNR = *BLANKS                                           CSD027
     C                   EVAL      PFTDTP = *BLANKS
     C                   EVAL      PFTDVD = *ZEROS
     C                   ENDIF
      *
      ** Validate Primary trade details
      *
     C                   CALLB     'SETRADPVAL'
      *                             ==========
      ** INPUTS
      ** ======
      *
      ** Response mode
     C                   PARM                    RespMode
      *
      ** Trade Primary Details
     C                   PARM                    NewTrPrim
      *
      ** Custom Extra Data file data
     C                   PARM                    ExtData
      *
      ** Trade settlement currency
     C                   PARM                    DDSETC
      *
      ** Default & Validate (Y or N)
     C                   PARM      'Y'           Default           1
     C                   PARM      'Y'           Validate          1
      *
      ** Output details of original book.
     C                   PARM                    OLDBK1
TAS  C                   PARM                    WARNIND
      *
      ** First Buy-sell back indicator
      ** First Buy-sell Book code
      ** First Buy-sell counterparty
      ** First Buy-sell transfer type
      ** First Buy-sell value date
      ** First Buy-sell Security Shortname
     C                   PARM                    PFBYSL            1
     C                   PARM                    PFBPBK            2
     C**********         PARM                    PFTCNR            6 0                        CSD027
     C                   PARM                    PFTCNR            6                          CSD027
     C                   PARM                    PFTDTP            2
     C                   PARM                    PFTDVD            5 0
     C                   PARM                    PFSESN           10
     C                   PARM                    CallFromVU                                   CAP087
      *
      ** OUTPUTS
      ** =======
      *
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
      *
      ** Coupon Rate
      ** Current Factor
     C                   PARM                    DDCPNR
     C                   PARM                    DDCFCT
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
      ** Default basket for backup withholding
     C                   PARM                    PDRBW
      *
      ** Trade Primary Details OK inds
     C                   PARM                    OKTrPrim
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx_PVAL
      *
      ** Valid Trade layout (DS) from/to caller
     C                   PARM                    NwTrFilFmt
      *
      ** PB Order Number
     C                   PARM                    DDORDE
      *
      ** If errors returned
     C     Idx           IFNE      0
     C                   GOTO      ESRValP
     C                   ENDIF
      *
      ** Default Secondary Screen details
      *
     C                   CALLB     'SETRADSVAL'
      *                             ==========
      ** INPUTS
      ** ======
      *
      ** Response mode
     C                   PARM                    RespMode
      *
      ** Trade Primary Details
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
      *
      ** Custom Extra Data file data
     C                   PARM                    ExtData
      *
      ** Default & Validate (Y or N)
     C                   PARM      'Y'           Default           1
     C                   PARM      'N'           Validate          1
      *
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
      *
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
      *
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      *
      ** MT5xx SSI (Phase 2)
     C                   PARM                    CSE028
      *                                                                                       249107
      * CGL031                                                                                249107
     C                   PARM                    CGL031                                       249107
                                                                                              249107
      ** Current File Trade Date                                                              249107
     C                   PARM                    C_TDVD                                       249107
      *
      ** OUTPUTS
      ** =======
      *
      ** Settlement Currency Details
     C                   PARM                    SetCcyDts
      *
      ** Trade Primary Details OK inds
     C                   PARM                    OKTrSeco
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx_PVAL
      *
      ** Valid Trade layout (DS) from/to caller
     C                   PARM                    NwTrFilFmt
      *
      ** Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKTrPrim
     C                   MOVE      *ALL'Y'       OKTrSeco
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** Go to Secondary details screen
      *
     C                   MOVEL     'S'           WScrn
      *
     C     ESRValP       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrnS - Process second screen                              *
      *                                                               *
      *****************************************************************
      *
     C     SRScrnS       BEGSR
      *
      ** Update 'previous' screens and previous number of warnings
     C                   MOVEL     NewTrPrim     PrvTrPrim
     C                   MOVEL     NewTrSeco     PrvTrSeco
     C                   Z-ADD     WIdx_SVAL     PrvN_Warn         3 0
      *
      ** Write/Read display screen - Secondary Details
      *
     C                   CALLB     'SETRADSDSP'
      *                             ==========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Trade (in screen format - Primary / Secondary)
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
      *
      ** Trade Status
      ** Trade Authorized/Not Authorized
     C                   PARM                    DDSTAT            9
     C                   PARM                    DDAUTH           14
      *
      ** Security report name
      ** Customer report name
     C                   PARM                    DDSRNME
     C                   PARM                    DDCRNM           20
      *
      ** Current Factor
      ** Coupon Rate
     C                   PARM                    DDCFCT           12
     C                   PARM                    DDCPNR           13
      *
      ** Trade incomplete ind
     C                   PARM                    C_TINC
      *
      ** Fields in error
     C                   PARM                    OKTrPrim
     C                   PARM                    OKTrSeco
      *
      ** Customer classification
     C                   PARM                    CustClass
      *
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
      *
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Enabled Function Keys
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Confirm Delete
      ** KP = Command Key 15 = Browse
     C                   PARM      'N'           @EINKG
     C                   PARM      'N'           @EINKH
     C                   PARM      'N'           @EINKJ            1
     C                   PARM      'N'           @EINKP
      *
      ** Protect book on second leg
     C                   PARM                    IN50              1
     C                   PARM                    TRDBK1            2
                                                                                              CGL031
      ** CGL031 Switchable Feature                                                            CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      ** Buy-sell back
     C                   PARM      'Y'           PBYSL
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKE             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
     C                   PARM                    @INKW             1                          222373
     C                   PARM                    @INKWDisp         1                          222373
      *
      ** Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
      *
      ** Reset erros
      *
     C                   MOVE      *ALL'Y'       OKTrPrim
     C                   MOVE      *ALL'Y'       OKTrSeco
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** F3 - End Program
     C     @INKC         CASEQ     '1'           SREndP
      *
      ** F5 - Go to Initial Screen
     C     @INKE         CASEQ     '1'           SRInitial
      *
      ** F12 - Cancel on Secondary Screen
     C     @INKL         CASEQ     '1'           SRCancS
      *
      ** Validate Input to Secondary Screen
     C                   CAS                     SRValS
      *
     C                   ENDCS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValS - Validate input to secondary screen                  *
      *                                                               *
      *****************************************************************
      *
     C     SRValS        BEGSR
      *
      ** Force interest & price recalculation
      *
     C                   EXSR      SRIntRCal
     C                   EXSR      SRPrcRCal
      *
      ** Prior to validation, initialize error indicators as 'OK'
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx_SVAL         3 0
     C                   MOVE      *ALL'Y'       OKTrPrim
     C                   MOVE      *ALL'Y'       OKTrSeco
      *
      ** Validate Primary trade details
      *
     C                   CALLB     'SETRADPVAL'
      *                             ==========
      ** INPUTS
      ** ======
      *
      ** Response mode
     C                   PARM                    RespMode
      *
      ** Trade Primary Details
     C                   PARM                    NewTrPrim
      *
      ** Custom Extra Data file data
     C                   PARM                    ExtData
      *
      ** Trade settlement currency
     C                   PARM                    DDSETC
      *
      ** Default & Validate (Y or N)
     C                   PARM      'Y'           Default           1
     C                   PARM      'Y'           Validate          1
      *
      ** Output details of original book
     C                   PARM                    OLDBK1
TAS  C                   PARM                    WARNIND
      *
      ** First Buy-sell back indicator
      ** First Buy-sell Book code
      ** First Buy-sell counterparty
      ** First Buy-sell transfer type
      ** First Buy-sell value date
      ** First Buy-sell security shortname
     C                   PARM                    PFBYSL
     C                   PARM                    PFBPBK
     C                   PARM                    PFTCNR
     C                   PARM                    PFTDTP
     C                   PARM                    PFTDVD
     C                   PARM                    PFSESN
     C                   PARM                    CallFromVU                                   CAP087
      *
      ** OUTPUTS
      ** =======
      *
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
      *
      ** Coupon Rate
      ** Current Factor
     C                   PARM                    DDCPNR
     C                   PARM                    DDCFCT
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
      ** Default basket for backup withholding
     C                   PARM                    PDRBW
      *
      ** Trade Primary Details OK inds
     C                   PARM                    OKTrPrim
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx_SVAL
      *
      ** Valid Trade layout (DS) from/to caller
     C                   PARM                    NwTrFilFmt
      *
      ** PB Order Number
     C                   PARM                    DDORDE
      *
      ** Validate Secondary Screen details
      *
     C                   CALLB     'SETRADSVAL'
      *                             ==========
      ** INPUTS
      ** ======
      *
      ** Response mode
     C                   PARM                    RespMode
      *
      ** Trade Primary Details
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
      *
      ** Custom Extra Data file data
     C                   PARM                    ExtData
      *
      ** Default & Validate (Y or N)
     C                   PARM      'Y'           Default           1
     C                   PARM      'Y'           Validate          1
      *
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
      *
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
      *                                                                                       249107
      ** Current File Trade Date                                                              249107
     C                   PARM                    C_TDVD                                       249107
      *
      ** OUTPUTS
      ** =======
      *
      ** Settlement Currency Details
     C                   PARM                    SetCcyDts
      *
      ** Trade Primary Details OK inds
     C                   PARM                    OKTrSeco
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx_SVAL
      *
      ** Valid Trade layout (DS) from/to caller
     C                   PARM                    NwTrFilFmt
      *
      ** If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      ESRValS
     C                   ENDIF
      *
      ** If the screen has changed in the course of the validation
      ** or if there are warnings which have not been displayed
      ** re-output the screen.
      *
     C     NewTrPrim     IFNE      PrvTrPrim
     C     NewTrSeco     ORNE      PrvTrSeco
     C     WIdx_SVAL     ORNE      PrvN_Warn
     C                   GOTO      ESRValS
     C                   ENDIF
      *
      ** Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKTrPrim
     C                   MOVE      *ALL'Y'       OKTrSeco
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** Go to Other details screen
      *
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   MOVEL     'H'           WScrn                                        CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVEL     'O'           WScrn
     C                   ENDIF                                                                CAS006
      *
     C     ESRValS       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SRScrnT - Process third details screen                       *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
                                                                                              CAS006
     C     SRScrnT       BEGSR                                                                CAS006
                                                                                              CAS006
      ** Call validation module for defaulting purposes only                                  CAS006
                                                                                              CAS006
     C                   CALLB     'SETRADTVAL'                                               CAS006
                                                                                              CAS006
      ** INPUTS                                                                               CAS006
                                                                                              CAS006
     C                   PARM                    RespMode                                     CAS006
     C                   PARM                    NewTrPrim                                    CAS006
     C                   PARM                    NewTrSeco                                    CAS006
     C                   PARM                    NewTrThir                                    CAS006
     C                   PARM                    ExtData                                      CAS006
     C                   PARM      'Y'           Default                                      CAS006
     C                   PARM      'N'           Validate                                     CAS006
     C                   PARM                    SECTY                                        CAS006
     C                   PARM                    INVTP                                        CAS006
     C                   PARM                    DDHACR                                       CAS006
     C                   PARM                    DDPRICN                                      CAS006
     C                   PARM                    CustDts                                      CAS006
     C                   PARM                    PortDts                                      CAS006
     C                   PARM                    NomCcyDts                                    CAS006
     C                   PARM                    SetCcyDts                                    CAS006
                                                                                              CAS006
      ** OUTPUTS                                                                              CAS006
                                                                                              CAS006
     C                   PARM                    OKTrThir                                     CAS006
     C                   PARM                    FldNameArr                                   CAS006
     C                   PARM                    MsgIDArr                                     CAS006
     C                   PARM                    MsgDtaArr                                    CAS006
     C                   PARM                    Idx                                          CAS006
     C                   PARM                    WFldNamArr                                   CAS006
     C                   PARM                    WMsgIDArr                                    CAS006
     C                   PARM                    WMsgDtaArr                                   CAS006
     C                   PARM                    WIdx_TVAL                                    CAS006
     C                   PARM                    NwTrFilFmt                                   CAS006
                                                                                              CAS006
      ** Update 'previous' screens and previous number of warnings                            CAS006
                                                                                              CAS006
     C                   MOVEL     NewTrThir     PrvTrThir                                    CAS006
     C                   Z-ADD     WIdx_TVAL     PrvN_Warn                                    CAS006
                                                                                              CAS006
      ** Write/Read display screen - Third Details screen                                     CAS006
                                                                                              CAS006
     C                   CALLB     'SETRADTDSP'                                               CAS006
                                                                                              CAS006
      ** INPUTS                                                                               CAS006
      ** Return code                                                                          CAS006
                                                                                              CAS006
     C                   PARM      *BLANKS       RetCodeOut                                   CAS006
                                                                                              CAS006
      ** Trade in screen format                                                               CAS006
                                                                                              CAS006
     C                   PARM                    NewTrPrim                                    CAS006
     C                   PARM                    NewTrThir                                    CAS006
                                                                                              CAS006
      ** Trade status                                                                         CAS006
      ** Security report name                                                                 CAS006
      ** Coupon Rate using Net Treasury Rate                                                  CAS006
      ** Net Treasury Price                                                                   CAS006
                                                                                              CAS006
     C                   PARM                    DDSTAT                                       CAS006
     C                   PARM                    DDSRNME                                      CAS006
     C                   PARM                    DDHACR                                       CAS006
     C                   PARM                    DDPRICN                                      CAS006
                                                                                              CAS006
      ** Trade incomplete ind                                                                 CAS006
                                                                                              CAS006
     C                   PARM                    C_TINC                                       CAS006
                                                                                              CAS006
      ** Security Details                                                                     CAS006
      ** Investment Type Details                                                              CAS006
                                                                                              CAS006
     C                   PARM                    SECTY                                        CAS006
     C                   PARM                    INVTP                                        CAS006
                                                                                              CAS006
      ** Buy-sell back                                                                        CAS006
                                                                                              CAS006
     C                   PARM      'N'           PBYSL                                        CAS006
                                                                                              CAS006
      ** Fields in error                                                                      CAS006
                                                                                              CAS006
     C                   PARM                    OKTrThir                                     CAS006
                                                                                              CAS006
      ** Errors                                                                               CAS006
                                                                                              CAS006
     C                   PARM                    FldNameArr                                   CAS006
     C                   PARM                    MsgIdArr                                     CAS006
     C                   PARM                    MsgDtaArr                                    CAS006
                                                                                              CAS006
      ** Warnings                                                                             CAS006
                                                                                              CAS006
     C                   PARM                    WFldNamArr                                   CAS006
     C                   PARM                    WMsgIdArr                                    CAS006
     C                   PARM                    WMsgDtaArr                                   CAS006
                                                                                              CAS006
      ** OUTPUTS                                                                              CAS006
      ** Function keys                                                                        CAS006
                                                                                              CAS006
     C                   PARM      '0'           @INKC                                        CAS006
     C                   PARM      '0'           @INKE                                        CAS006
     C                   PARM      '0'           @INKL                                        CAS006
                                                                                              CAS006
      ** Write screen with no read indicator                                                  CAS006
                                                                                              CAS006
     C                   PARM      'N'           WriteOnly                                    CAS006
                                                                                              CAS006
      ** Reset errors                                                                         CAS006
                                                                                              CAS006
     C                   MOVE      *ALL'Y'       OKTrThir                                     CAS006
     C                   MOVEL     *BLANK        FldNameArr                                   CAS006
     C                   MOVEL     *BLANK        MsgIdArr                                     CAS006
     C                   MOVEL     *BLANK        MsgDtaArr                                    CAS006
     C                   MOVEL     *BLANK        WFldNamArr                                   CAS006
     C                   MOVEL     *BLANK        WMsgIdArr                                    CAS006
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CAS006
                                                                                              CAS006
      ** F3 - End Program                                                                     CAS006
                                                                                              CAS006
     C     @INKC         CASEQ     '1'           SREndP                                       CAS006
                                                                                              CAS006
      ** F5 - Go to Initial Screen                                                            CAS006
                                                                                              CAS006
     C     @INKE         CASEQ     '1'           SRInitial                                    CAS006
                                                                                              CAS006
      ** F12 - Cancel on Secondary Screen                                                     CAS006
                                                                                              CAS006
     C     @INKL         CASEQ     '1'           SRCancT                                      CAS006
                                                                                              CAS006
      ** Validate Input to Third screen                                                       CAS006
                                                                                              CAS006
     C                   CAS                     SRValT                                       CAS006
                                                                                              CAS006
     C                   ENDCS                                                                CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
                                                                                              CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SRValT - Validate input to third screen                      *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
                                                                                              CAS006
     C     SRValT        BEGSR                                                                CAS006
                                                                                              CAS006
      ** If Authorize/Approve, go to Other details screen                                     CAS006
                                                                                              CAS006
     C                   IF        DDACTN = 'P'  OR  DDACTN = 'Y'                             CAS006
     C                   EVAL      WScrn = 'O'                                                CAS006
     C                   GOTO      ESRValT                                                    CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Insert, Amend, Change                                                                CAS006
                                                                                              CAS006
     C     DDACTN        IFEQ      'I'                                                        CAS006
     C     DDACTN        OREQ      'A'                                                        CAS006
     C     DDACTN        OREQ      'C'                                                        CAS006
                                                                                              CAS006
      ** Prior to validation, initialize error indicators as 'OK'                             CAS006
                                                                                              CAS006
     C                   Z-ADD     *ZERO         Idx                                          CAS006
     C                   Z-ADD     *ZERO         WIdx_TVAL                                    CAS006
     C                   MOVE      *ALL'Y'       OKTrThir                                     CAS006
                                                                                              CAS006
      ** Validate Third Screen details                                                        CAS006
                                                                                              CAS006
     C                   CALLB     'SETRADTVAL'                                               CAS006
                                                                                              CAS006
      ** INPUTS                                                                               CAS006
      ** Response mode                                                                        CAS006
                                                                                              CAS006
     C                   PARM                    RespMode                                     CAS006
                                                                                              CAS006
      ** Trade Primary Details                                                                CAS006
      ** Trade Secondary Details                                                              CAS006
      ** Trade Third Screen Details                                                           CAS006
                                                                                              CAS006
     C                   PARM                    NewTrPrim                                    CAS006
     C                   PARM                    NewTrSeco                                    CAS006
     C                   PARM                    NewTrThir                                    CAS006
                                                                                              CAS006
      ** Custom Extra Data file data                                                          CAS006
                                                                                              CAS006
     C                   PARM                    ExtData                                      CAS006
                                                                                              CAS006
      ** Default & Validate (Y or N)                                                          CAS006
                                                                                              CAS006
     C                   PARM      'Y'           Default                                      CAS006
     C                   PARM      'Y'           Validate                                     CAS006
                                                                                              CAS006
      ** Security Details                                                                     CAS006
      ** Investment Type Details                                                              CAS006
                                                                                              CAS006
     C                   PARM                    SECTY                                        CAS006
     C                   PARM                    INVTP                                        CAS006
                                                                                              CAS006
      ** Coupon rate using NTR                                                                CAS006
      ** Net Treasury Price                                                                   CAS006
                                                                                              CAS006
     C                   PARM                    DDHACR                                       CAS006
     C                   PARM                    DDPRICN                                      CAS006
                                                                                              CAS006
      ** Customer (Counterparty) Details                                                      CAS006
      ** Portfolio Details                                                                    CAS006
      ** Nominal Currency Details                                                             CAS006
      ** Settlement Currency Details                                                          CAS006
                                                                                              CAS006
     C                   PARM                    CustDts                                      CAS006
     C                   PARM                    PortDts                                      CAS006
     C                   PARM                    NomCcyDts                                    CAS006
     C                   PARM                    SetCcyDts                                    CAS006
                                                                                              CAS006
      ** Trade Exchange Rates OK inds                                                         CAS006
                                                                                              CAS006
     C                   PARM                    OKTrThir                                     CAS006
                                                                                              CAS006
      ** Error fields/message IDs/message data (arrays) from/to caller                        CAS006
                                                                                              CAS006
     C                   PARM                    FldNameArr                                   CAS006
     C                   PARM                    MsgIDArr                                     CAS006
     C                   PARM                    MsgDtaArr                                    CAS006
                                                                                              CAS006
      ** Array index (3P0) from/to caller                                                     CAS006
                                                                                              CAS006
     C                   PARM                    Idx                                          CAS006
                                                                                              CAS006
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CAS006
                                                                                              CAS006
     C                   PARM                    WFldNamArr                                   CAS006
     C                   PARM                    WMsgIDArr                                    CAS006
     C                   PARM                    WMsgDtaArr                                   CAS006
                                                                                              CAS006
      ** Array index (3P0) from/to caller                                                     CAS006
                                                                                              CAS006
     C                   PARM                    WIdx_TVAL                                    CAS006
                                                                                              CAS006
      ** Valid Trade layout (DS) from/to caller                                               CAS006
                                                                                              CAS006
     C                   PARM                    NwTrFilFmt                                   CAS006
                                                                                              CAS006
      ** Errors returned                                                                      CAS006
                                                                                              CAS006
     C                   IF        Idx <> 0                                                   CAS006
     C                   GOTO      ESRValT                                                    CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** If the screen has changed in the course of the validation                            CAS006
      ** or if there are warnings which have not been displayed                               CAS006
      ** re-output the screen                                                                 CAS006
                                                                                              CAS006
     C                   IF        NewTrThir <> PrvTrThir  OR                                 CAS006
     C                             WIdx_TVAL <> PrvN_Warn                                     CAS006
     C                   GOTO      ESRValT                                                    CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Clear any warning messages                                                           CAS006
                                                                                              CAS006
     C                   MOVE      *ALL'Y'       OKTrThir                                     CAS006
     C                   MOVEL     *BLANK        WFldNamArr                                   CAS006
     C                   MOVEL     *BLANK        WMsgIdArr                                    CAS006
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CAS006
                                                                                              CAS006
      ** Go to Other details screen                                                           CAS006
                                                                                              CAS006
     C                   MOVEL     'O'           WScrn                                        CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C     ESRValT       ENDSR                                                                CAS006
                                                                                              CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************
      *                                                               *
      *  SRScrnO - Process other details screen                       *
      *                                                               *
      *****************************************************************
      *
     C     SRScrnO       BEGSR
      *
      ** Update 'previous' screens and previous number of warnings
      *
     C                   MOVEL     NewTrExch     PrvTrExch
     C                   MOVEL     NewTrSett     PrvTrSett
     C                   MOVEL     NewTrChCm     PrvTrChCm
     C                   Z-ADD     WIdx_OVAL     PrvN_Warn         3 0
      *
      ** Pass clearance type from primary to other details screen
      *
     C                   MOVEL     DDCLTY        DDCLTY2
      *
      ** If first time for action code, trade ref, currency or customer
      ** or if no details present
      *
     C     DDACTN        IFNE      ##ACTN
     C     DDTDRF        ORNE      ##TDRF
     C     DDSETC        ORNE      ##SETC
     C     DDCNUM        ORNE      ##CNUM
     C     PrvTrExch     OREQ      *BLANK
     C     PrvTrSett     ANDEQ     *BLANK
     C     PrvTrChCm     ANDEQ     *BLANK
      *
      ** Do defaulting for other details screen
      ** Do charges and commissions calculation
      ** Do EU tax calculation if CGL031 is enabled                                           233881
      ** Do countervalue calculation
      /COPY WNCPYSRC,SEBYSLR014
      *
     C                   EXSR      SRDfltO
     C     BVACOP        IFEQ      'Y'
     C                   EXSR      SRChCmCal
     C                   ENDIF
     C                   IF        CGL031 = 'Y'                                               233881
     C                   EXSR      SREuTxCal                                                  233881
     C                   ENDIF                                                                233881
     C                   EXSR      SRCValCal
     C                   ENDIF
      *
      ** Write/read display - Other Details Screen
      /COPY WNCPYSRC,SEBYSLR015
      *
     C                   CALLB     'SETRADODSP'
      *                             ==========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Trade (IN SCREEN FORMAT) - Primary/Secondary/Other Details
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
     C                   PARM                    NewTrExch
     C                   PARM                    NewTrSett
     C                   PARM                    NewTrChCm
      *
      ** Current trade incomplete ind and date made complete
     C                   PARM                    C_TINC
     C                   PARM                    C_TDMC
      *
      ** Customer classification, Customer PM (Y/N) and nominal currency
      ** And Private Banking customer (Y/N)
     C                   PARM                    CustClass         1
     C                   PARM                    CustPM            1
     C                   PARM                    NMCY              3
     C                   PARM                    CustPB            1
      *
      ** Withholding tax
     C                   PARM                    DDWTAX
      *
      ** Fields in error
     C                   PARM                    OKTrExch
     C                   PARM                    OKTrSett
     C                   PARM                    OKTrChcm
      *
      ** Security report name
      ** Countervalue
      ** FX Margin Amount
      ** Portfolio exchange rate & M/D ind screen format
     C                   PARM                    DDSRNME
     C                   PARM                    DDTCTR
     C                   PARM                    DDMAMT           18
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
      *
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
                                                                                              CGL031
      ** CGL031 Switchable Feature                                                            CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      ** Buy-sell back
     C                   PARM      'Y'           PBYSL
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKE             1
     C                   PARM      '0'           @INKL             1
      *
      ** Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
      *
      ** Reset errors
      *
     C                   MOVE      *ALL'Y'       OKTrExch
     C                   MOVE      *ALL'Y'       OKTrSett
     C                   MOVE      *ALL'Y'       OKTrChcm
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** Pass clearance type from other details to primary screen
      *
     C                   MOVEL     DDCLTY2       DDCLTY
      *
      ** F3 - End Program
     C     @INKC         CASEQ     '1'           SREndP
      *
      ** F5 - Go To Initial Screen
     C     @INKE         CASEQ     '1'           SRInitial
      *
      ** F12 - Cancel on Other Details Screen
     C     @INKL         CASEQ     '1'           SRCancO
      *
      ** Validate Input to Other Details Screen
     C                   CAS                     SRValO
      *
     C                   ENDCS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDfltO - Do defaulting for other details screen             *
      *                                                               *
      *****************************************************************
      *
     C     SRDfltO       BEGSR
      *
      ** Exchange rate defaulting
      *
     C                   CALLB     'SETEXCHDFT'
      *                             ==========
      ** INPUTS
      ** ======
      *
      ** Nominal Currency
      ** Settlement Currency
     C                   PARM                    NMCY              3
     C                   PARM                    DDSETC            3
      *
      ** Nominal Currency Details
      ** Settlement Currency Details
     C                   PARM                    NomCcyDts
     C                   PARM                    SetCcyDts
      *
      ** ICD
      ** Euro Currency
      ** EMU SE Settlement Ccy Conv.
     C                   PARM                    BKEURO            3
     C                   PARM                    CEU005            1
      *
      ** OUTPUTS
      ** =======
      *
      ** Trade Exchange Rate screen fields
     C                   PARM                    NewTrExch
      *
      ** Trade Exchange Rate file fields
     C                   PARM                    TDER             13 8
     C                   PARM                    TMDI              1
     C                   PARM                    TBCR             13 8
      *
      ** Settlement instruction defaulting
      *
     C                   CALLB     'SETSETIDFT'
      *                             ==========
      ** INPUTS
      ** ======
      *
      ** Booking branch
      ** Incomplete Ind
      ** Trade Type
      ** Settlement Currency
      ** Market Ind.
      ** Book Code.
     C                   PARM                    DDBRCD            3
     C                   PARM                    DDINCS            1
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDSETC            3
     C                   PARM                    DDTDMI            1
     C                   PARM                    DDBPBK
     C                   PARM                    DDMRKT                                       216338
      *
      ** Investment type (SECTYD)
     C                   PARM                    SITP              3
      *
      ** Nominal Currency Details
      ** Settlement Currency Details
     C                   PARM                    NomCcyDts
     C                   PARM                    SetCcyDts
      *
      ** Customer (Counterparty) Details
      ** ( Note: Customer Participant/Non-participant Indicator 1 and
      **  Customer Participant/Non-participant Indicator 2 are also outputs)
     C                   PARM                    CustDts
      *
      ** ICD
      ** Depot 1 (Eurclear)
      ** Depot 2 (Cedel)
     C                   PARM                    BVDR1             6
     C                   PARM                    BVDR2             6
      *
      ** MT5xx SSI (Phase 2)
     C                   PARM                    CSE028
      *
      ** OUTPUTS
      ** =======
      *
      ** Trade Settlement Instructions
     C                   PARM                    NewTrSett
      *
      ** Charge/commission defaulting
      *
     C                   CALLB     'SETCHCMDFT'
      *                             ==========
      ** INPUTS
      ** ======
      *
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
      ** ===
      *
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
      *
      ** OUTPUTS
      ** =======
      *
      ** Commission Rebate %
     C                   PARM                    CMRP              5 3
      *
      ** Trade Charges & Commissions screen fields
     C                   PARM                    NewTrChCm
      *
      ** Trade Charges & Commissions file fields
     C                   PARM                    TBCC              2
     C                   PARM                    TCCC              2
     C                   PARM                    TCC1              2
     C                   PARM                    TCC2              2
      *
      ** Update check fields
     C                   MOVEL     DDACTN        ##ACTN            1
     C                   MOVEL     DDTDRF        ##TDRF            6
     C                   MOVEL     DDSETC        ##SETC            3
     C                   MOVEL     DDCNUM        ##CNUM           10
 
     C     ESRDfltO      ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValO - Validate input to other details screen              *
      *                                                               *
      *****************************************************************
      *
     C     SRValO        BEGSR
      *
      ** Charges and commissions calculation
      *
     C     BVACOP        IFEQ      'Y'
     C                   EXSR      SRChCmCal
     C                   ENDIF
      *
      ** Prior to validation, initialize error indicators as 'OK'
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx_OVAL         3 0
     C                   MOVE      *ALL'Y'       OKTrExch
     C                   MOVE      *ALL'Y'       OKTrSett
     C                   MOVE      *ALL'Y'       OKTrChcm
      *
      ** Validate "Other Details" Screen
      *
     C                   CALLB     'SETRADOVAL'
      *                             ==========
      ** INPUTS
      ** ======
      *
      ** Response mode
     C                   PARM                    RespMode
      *
      ** Trade Primary Details
      ** Trade Secondary Details
      ** Trade Exchange Rates
      ** Trade Settlement Instructions
      ** Trade Charge & Commissions
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
     C                   PARM                    NewTrExch
     C                   PARM                    NewTrSett
     C                   PARM                    NewTrChCm
      *
      ** Custom Extra Data file data
     C                   PARM                    ExtData
      *
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
      *
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      *
      ** Portfolio Details
     C                   PARM                    PortDts
      *
      ** Nominal Currency Details
      ** Settlement Currency Details
     C                   PARM                    NomCcyDts
     C                   PARM                    SetCcyDts
                                                                                              CGL031
      ** CGL031 Switchable Feature                                                            CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      ** OUTPUTS
      ** =======
      *
      ** FX Margin Amount
      ** Portfolio exchange rate & M/D ind screen format
     C                   PARM                    DDMAMT           18
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
      *
      ** Trade Exchange Rates OK inds
      ** Trade Settlement Instructions OK
      ** Trade Charge & Commissions OK inds
     C                   PARM                    OKTrExch
     C                   PARM                    OKTrSett
     C                   PARM                    OKTrChcm
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx_OVAL
      *
      ** Valid Trade layout (DS) from/to caller
     C                   PARM                    NwTrFilFmt
                                                                                              233881
      ** Do EU tax calculation                                                                233881
                                                                                              233881
     C                   IF        CGL031 = 'Y'                                               233881
     C                   EXSR      SREuTxCal                                                  233881
     C                   ENDIF                                                                233881
      *
      ** Do countervalue calculation
      *
     C                   EXSR      SRCValCal
      *
      ** If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      ESRValO
     C                   ENDIF
      *
      ** Setup Automatic Authorisation flag on the Valid file
     C     CAP051        IFEQ      'Y'
     C                   EVAL      C_AUTH = DDAUTHA
     C                   ENDIF
      *
      ** If the screen has changed in the course of the validation
      ** or if there are warnings which have not been displayed
      ** re-output the screen
      *
     C     NewTrExch     IFNE      PrvTrExch
     C     NewTrSett     ORNE      PrvTrSett
     C     NewTrChCm     ORNE      PrvTrChCm
     C     WIdx_OVAL     ORNE      PrvN_Warn
     C                   GOTO      ESRValO
     C                   ENDIF
      *
      ** Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKTrExch
     C                   MOVE      *ALL'Y'       OKTrSett
     C                   MOVE      *ALL'Y'       OKTrChcm
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** If MT5XX Message Generation not installed, Go To Updates
      ** Else, Go to Extension (SWIFT) screen A
      *
     C     S01401        IFNE      'Y'
      *
      ** Get last screen before update
     C                   EVAL      WLScrn = WScrn
     C                   MOVEL     'U'           WScrn
     C                   ELSE
     C                   MOVEL     'A'           WScrn
     C                   ENDIF
      *
     C     ESRValO       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrnE1- Process extension (SWIFT) screen A                 *
      *                                                               *
      *****************************************************************
      *
     C     SRScrnE1      BEGSR
      *
      ** Check whether screen B is required
      *
     C                   MOVE      'N'           Display_B         1
     C     CSW003        IFEQ      'Y'
     C     CustClass     IFEQ      'S'
     C     DELT          ANDNE     DELF
     C     CustClass     OREQ      'D'
     C     DELT          ANDNE     DELF
     C                   MOVE      'Y'           Display_B
     C                   ENDIF
     C                   ENDIF
      *
      ** Update 'previous' screens and previous number of warnings
     C                   MOVEL     NewTrSwftA    PrvTrSwft
     C                   Z-ADD     WIdx_EVALA    PrvN_Warn         3 0
      *
      ** If instructions not present and if first time for trade ref
      ** type, method, clear type, depots
      *
     C     NewTrSwftA    IFEQ      *BLANK
      *
     C     DDTDRF        IFNE      A_##TDRF
     C     DDTDTP        ORNE      A_##TDTP
     C     DDSMTH        ORNE      A_##SMTH
     C     DDCLTY        ORNE      A_##CLTY
     C     DDPCOD        ORNE      A_##PCOD
     C     DDPRYC        ORNE      A_##PRYC
     C     DDCNUM        ORNE      A_##CNUM
     C     DDDELF        ORNE      A_##DELF
     C     DDDELT        ORNE      A_##DELT
      *
      ** Do defaulting for extension screen A
      *
     C                   EXSR      SRDfltE1
     C                   ENDIF
     C                   ENDIF
      *
      ** Write/read display - Extension Screen
      *
     C                   CALLB     'SETRADEDSP'
      *                             ==========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Screen A/B
     C                   PARM      'A'           Screen
      *
      ** Trade (IN SCREEN FORMAT) - Primary/Settlements/SWIFT
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
     C                   PARM                    NewTrSett
     C                   PARM                    NewTrSwftA
     C                   PARM                    NewTrExts                                    222373
      *
      ** Trade (file fields)
     C                   PARM                    TCNR
     C                   PARM                    TNMC
     C                   PARM                    NOML
     C                   PARM                    TDVD
     C                   PARM                    DELF
     C                   PARM                    DELT
      *                                                                                       201429
      ** Process SE1806 flag                                                                  201429
     C                   PARM                    PUYAT             1                          201429
      *                                                                                       201429
      ** ISO15022 indicator in file                                                           201429
     C                   PARM                    CA_T1NEW                                     201429
      *                                                                                       216338
      ** Default SSI Flag                                                                     216338
     C                   PARM      'Y'           DftFlag           1                          216338
      *
      ** Fields in error
     C                   PARM                    OKTrSwft
     C                   PARM                    OkTrExts                                     222373
      *
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Destination of Settlement Text fields
     C                   PARM                    A_DDROUS          6
     C                   PARM                    A_DDROTS         12
      *
      ** Destination of Confirmation Text fields
     C                   PARM                    A_DDROUC          6
     C                   PARM                    A_DDROTC         12
      *
      ** Security report name
     C                   PARM                    DDSRNME
      *
      ** Swift 2001 flag
     C                   PARM                    CSW201
     C                   PARM                    PCALL                                        222373
      *
      ** Buy-sell back
     C                   PARM      'Y'           PBYSL
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKE             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
      *
      ** Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
      **  Extra parameter needed to pass detail for Midas Compliance                          CSD015
      **  Watch Enhancement.                                                                  CSD015
     C                   PARM                    PMCWL                                        CSD015
      * API Trades Extended Settlements                                                       222373
     C                   PARM                    NwSEFilFmt                                   222373
      *
      ** RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       OKTrSwft
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** F3 - End Program
     C     @INKC         CASEQ     '1'           SREndP
      *
      ** F5 - Go To Initial Screen
     C     @INKE         CASEQ     '1'           SRInitial
      *
      ** F12 - Cancel on Extension Screen
     C     @INKL         CASEQ     '1'           SRCancE1
      *
      ** F14 - Return from F14 Ext. Settlements
     C     @INKN         CASEQ     '1'           SRExtSet1
      *
      ** Validate Input to Extension Screen
     C                   CAS                     SRValE1
      *
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDfltE1 - Do defaulting for extension screen 1              *
      *                                                               *
      *****************************************************************
      *
     C     SRDfltE1      BEGSR
      *
      ** SWIFT (screen) field defaulting
      *
     C                   CALLB     'SETSWFTDFT'
      *                             ==========
      ** INPUT
      ** =====
      *
      ** Screen A/B
     C                   PARM      'A'           Screen            1
      *
      ** Trade Details (screen)
      *
     C                   PARM                    DDACTN            1
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDSMTH            2
     C                   PARM                    DDCLTY            1
     C                   PARM                    DDPCOD            1
     C                   PARM                    DDPRYC            1
     C                   PARM                    DDBRCD
     C                   PARM                    DDBPBK
     C                   PARM                    DDSETC
     C                   PARM                    DDMRKT                                       222373
      *
      ** Trade Details (file)
     C                   PARM                    TDVD
     C                   PARM                    TCNR
     C                   PARM                    DELF
     C                   PARM                    DELT
     C                   PARM                    InvType           3                          222373
      *
      ** (CSW003) MT5XX - Phase 2 Message Generation
     C                   PARM                    CSW003            1
      *
      ** OUTPUT
      ** ======
      *
      ** Screen A details
     C                   PARM                    NewTrSwftA
     C                   PARM                    A_DDROUS          6
     C                   PARM                    A_DDROTS         12
     C                   PARM                    A_DDROUC          6
     C                   PARM                    A_DDROTC         12
      *
      ** Screen B details
     C                   PARM                    NewTrSwftB
     C                   PARM                    B_DDROUS          6
     C                   PARM                    B_DDROTS         12
     C                   PARM                    B_DDROUC          6
     C                   PARM                    B_DDROTC         12
 
     C                   MOVEL     DDTDRF        A_##TDRF          6
     C                   MOVEL     DDTDTP        A_##TDTP          2
     C                   MOVEL     DDSMTH        A_##SMTH          2
     C                   MOVEL     DDCLTY        A_##CLTY          1
     C                   MOVEL     DDPCOD        A_##PCOD          1
     C                   MOVEL     DDPRYC        A_##PRYC          1
     C                   MOVEL     DDCNUM        A_##CNUM         10
     C                   MOVEL     DDDELF        A_##DELF         10
     C                   MOVEL     DDDELT        A_##DELT         10
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValE1 - Validate input to extension screen A               *
      *                                                               *
      *****************************************************************
      *
     C     SRValE1       BEGSR
      *
      ** Prior to validation, initialize error indicators as 'OK'
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx_EVALA        3 0
     C                   MOVE      *ALL'Y'       OKTrSwft
      *
      ** Validate Extension Screen
      *
     C                   CALLB     'SETRADEVAL'
      *                             ==========
      ** INPUTS
      ** ======
      *
      ** Response mode
     C                   PARM                    RespMode          1
      *
      ** Screen (A or B)
     C                   PARM      'A'           Screen            1
      *
      ** Trade Primary Details
      ** Trade Secondary Details
      ** Trade Exchange Rates
      ** Trade Settlement Details
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
     C                   PARM                    NewTrExch
     C                   PARM                    NewTrSett
      *
      ** Trade Extension File details
     C                   PARM                    NewTrSwftA
      *
      ** Custom Extra Data file data
     C                   PARM                    ExtData
      *
      ** Previous inds
     C                   PARM                    @ADDGMES
     C                   PARM                    @ADDGMEC
     C                   PARM                    @ADDCCID
     C                   PARM                    CA_T1CONG
      *
      ** Processing type
     C                   PARM                    PROT              1
      *
      ** Override errors
     C                   PARM                    OVRErrors         1
      *
      ** Valid Trade layout (DS) from/to caller
     C                   PARM                    NwTrFilFmt
      *
      ** Swift 2001 flag
     C                   PARM                    CSW201
      *                                                                                       201429
      ** Destination of settlement                                                            201429
     C                   PARM                    A_DDROTS                                     201429
      *                                                                                       201429
      ** Process SE1806 flag                                                                  201429
     C                   PARM                    PUYAT             1                          201429
                                                                                              216338
      ** Tradsdx2 data                                                                        216338
                                                                                              216338
     C                   PARM      *BLANKS       PTradeX2                                     216338
      *
      ** OUTPUTS
      ** =======
      *
      ** OK Flags
     C                   PARM                    OKTrSwft
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx_EVALA
      *
      ** Valid Trade layout (DS) (Extension file) from/to caller
     C                   PARM                    NT1AFilFmt
      *
      ** If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      ESRValE1
     C                   ENDIF
      *
      ** If the screen has changed in the course of the validation
      ** or if there are warnings which have not been displayed
      ** re-output the screen
      *
     C     NewTrSwftA    IFNE      PrvTrSwft
     C     WIdx_EVALA    ORNE      PrvN_Warn
     C     PUYAT         OREQ      'N'                                                        201429
     C     PUYAT         IFEQ      'N'                                                        201429
     C                   EVAL      PUYAT = 'Y'                                                201429
     C                   ENDIF                                                                201429
     C                   GOTO      ESRValE1
     C                   ENDIF
      *
      ** Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKTrSwft
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** If screen B can't be displayed go to updates
      ** Else, go to extension (SWIFT) screen B
      *
     C     Display_B     IFNE      'Y'
      *
      ** Get last screen before update
     C                   EVAL      WLScrn = WScrn
     C                   MOVEL     'U'           WScrn
     C                   ELSE
     C                   MOVEL     'B'           WScrn
     C                   ENDIF
      *
     C     ESRValE1      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrnE2 - Process extension (SWIFT) Screen B                *
      *                                                               *
      *****************************************************************
      *
     C     SRScrnE2      BEGSR
      *
      ** Update 'previous' screens and previous number of warnings
      *
     C                   MOVEL     NewTrSwftB    PrvTrSwft
     C                   Z-ADD     WIdx_EVALB    PrvN_Warn         3 0
      *
      ** If instructions not present and first time for trade
      ** ref, type, method, clear type, depots
      *
     C     NewTrSwftB    IFEQ      *BLANK
      *
     C     DDTDRF        IFNE      B_##TDRF
     C     DDTDTP        ORNE      B_##TDTP
     C     DDSMTH        ORNE      B_##SMTH
     C     DDCLTY        ORNE      B_##CLTY
     C     DDPCOD        ORNE      B_##PCOD
     C     DDPRYC        ORNE      B_##PRYC
     C     DDCNUM        ORNE      B_##CNUM
     C     DDDELF        ORNE      B_##DELF
     C     DDDELT        ORNE      B_##DELT
      *
      ** Do defaulting for extension screen B
      *
     C                   EXSR      SRDfltE2
     C                   ENDIF
     C                   ENDIF
      *
      ** Write/read display - Extension Screen
      *
     C                   CALLB     'SETRADEDSP'
      *                             ==========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Screen A/B
     C                   PARM      'B'           Screen
      *
      ** Trade (IN SCREEN FORMAT) - Primary/Settlements/SWIFT
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
     C                   PARM                    NewTrSett
     C                   PARM                    NewTrSwftB
     C                   PARM                    NewTrExts                                    222373
      *
      ** Trade (file fields)
     C                   PARM                    TCNR
     C                   PARM                    TNMC
     C                   PARM                    NOML
     C                   PARM                    TDVD
     C                   PARM                    DELF
     C                   PARM                    DELT
      *                                                                                       201429
      ** Process SE1806 flag                                                                  201429
     C                   PARM                    PUYAT             1                          201429
      *                                                                                       201429
      ** ISO15022 indicator in file                                                           201429
     C                   PARM                    CB_T1NEW                                     201429
      *                                                                                       216338
      ** Default SSI Flag                                                                     216338
     C                   PARM      'Y'           DftFlag           1                          216338
      *
      ** Fields in error
     C                   PARM                    OKTrSwft
     C                   PARM                    OkTrExts                                     222373
      *
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Destination of Settlement Text fields
     C                   PARM                    B_DDROUS          6
     C                   PARM                    B_DDROTS         12
      *
      ** Destination of Confirmation Text fields
     C                   PARM                    B_DDROUC          6
     C                   PARM                    B_DDROTC         12
      *
      ** Security report name
     C                   PARM                    DDSRNME
      *
      ** Swift 2001 flag
     C                   PARM                    CSW201
     C                   PARM                    PCALL                                        222373
      *
      ** Buy-sell back
     C                   PARM      'Y'           PBYSL
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKE             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
      *
      ** Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
      **  Extra parameter needed to pass detail for Midas Compliance                          CSD015
      **  Watch Enhancement.                                                                  CSD015
     C                   PARM                    PMCWL                                        CSD015
      * API Trades Extended Settlements                                                       222373
     C                   PARM                    NwSEFilFmt                                   222373
      *
      ** Reset Errors
      *
     C                   MOVE      *ALL'Y'       OKTrSwft
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** F3 - End Program
     C     @INKC         CASEQ     '1'           SREndP
      *
      ** F5 - Go To Initial Screen
     C     @INKE         CASEQ     '1'           SRInitial
      *
      ** F12 - Cancel on Extension Screen
     C     @INKL         CASEQ     '1'           SRCancE2
      *
      ** F14 - Return from F14 Ext. Settlements
     C     @INKN         CASEQ     '1'           SRExtSet2
      *
      ** Validate Input to Extension Screen
     C                   CAS                     SRValE2
      *
     C                   ENDCS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDfltE2 - Do defaulting for extension screen B              *
      *                                                               *
      *****************************************************************
      *
     C     SRDfltE2      BEGSR
      *
      ** SWIFT screen field defaulting
      *
     C                   CALLB     'SETSWFTDFT'
      *                             ==========
      ** INPUT
      ** =====
      *
      ** Screen A/B
     C                   PARM      'B'           Screen            1
      *
      ** Trade Details (screen)
      *
     C                   PARM                    DDACTN            1
     C                   PARM                    DDTDTP            2
     C                   PARM                    DDSMTH            2
     C                   PARM                    DDCLTY            1
     C                   PARM                    DDPCOD            1
     C                   PARM                    DDPRYC            1
     C                   PARM                    DDBRCD
     C                   PARM                    DDBPBK
     C                   PARM                    DDSETC
     C                   PARM                    DDMRKT                                       222373
      *
      ** Trade Details (file)
     C                   PARM                    TDVD
     C                   PARM                    TCNR
     C                   PARM                    DELF
     C                   PARM                    DELT
     C                   PARM                    InvType                                      222373
      *
      ** (CSW003) MT5XX - Phase 2 Message Generation
     C                   PARM                    CSW003            1
      *
      ** OUTPUT
      ** ======
      *
      ** Screen A details
     C                   PARM                    NewTrSwftA
     C                   PARM                    A_DDROUS          6
     C                   PARM                    A_DDROTS         12
     C                   PARM                    A_DDROUC          6
     C                   PARM                    A_DDROTC         12
      *
      ** Screen B details
     C                   PARM                    NewTrSwftB
     C                   PARM                    B_DDROUS          6
     C                   PARM                    B_DDROTS         12
     C                   PARM                    B_DDROUC          6
     C                   PARM                    B_DDROTC         12
 
     C                   MOVEL     DDTDRF        B_##TDRF          6
     C                   MOVEL     DDTDTP        B_##TDTP          2
     C                   MOVEL     DDSMTH        B_##SMTH          2
     C                   MOVEL     DDCLTY        B_##CLTY          1
     C                   MOVEL     DDPCOD        B_##PCOD          1
     C                   MOVEL     DDPRYC        B_##PRYC          1
     C                   MOVEL     DDCNUM        B_##CNUM         10
     C                   MOVEL     DDDELF        B_##DELF         10
     C                   MOVEL     DDDELT        B_##DELT         10
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValE2 - Validate input to extension screen 2               *
      *                                                               *
      *****************************************************************
      *
     C     SRValE2       BEGSR
      *
      ** Prior to validation, initialize error indicators as 'OK'
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx_EVALB        3 0
     C                   MOVE      *ALL'Y'       OKTrSwft
      *
      ** Validate Extension Screen
      *
     C                   CALLB     'SETRADEVAL'
      *                             ==========
      ** INPUTS
      ** ======
      *
      ** Response mode
     C                   PARM                    RespMode          1
      *
      ** Screen (A or B)
     C                   PARM      'B'           Screen            1
      *
      ** Trade Primary Details
      ** Trade Secondary Details
      ** Trade Exchange Rates
      ** Trade Settlement Details
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
     C                   PARM                    NewTrExch
     C                   PARM                    NewTrSett
      *
      ** Trade Extension File details
     C                   PARM                    NewTrSwftB
      * Custom Extra Data file data
     C                   PARM                    ExtData
      *
      ** Previous inds
     C                   PARM                    @BDDGMES
     C                   PARM                    @BDDGMEC
     C                   PARM                    @BDDCCID
     C                   PARM                    CB_T1CONG
      *
      ** Processing type
     C                   PARM                    PROT              1
      *
      ** Override errors
     C                   PARM                    OVRErrors         1
      *
      ** Valid Trade layout (DS) from/to caller
     C                   PARM                    NwTrFilFmt
      * Swift 2001 flag
     C                   PARM                    CSW201
      *                                                                                       201429
      ** Destination of settlement                                                            201429
     C                   PARM                    B_DDROTS                                     201429
      *                                                                                       201429
      ** Process SE1806 flag                                                                  201429
     C                   PARM                    PUYAT             1                          201429
                                                                                              216338
      ** Tradsdx2 data                                                                        216338
                                                                                              216338
     C                   PARM      *BLANKS       PTradeX2                                     216338
      *
      ** OUTPUTS
      ** =======
      *
      ** OK Flags
     C                   PARM                    OKTrSwft
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx_EVALB
      *
      ** Valid Trade layout (DS) (Extension file) from/to caller
     C                   PARM                    NT1BFilFmt
      *
      ** If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      ESRValE2
     C                   ENDIF
      *
      ** If the screen has changed in the course of the validation
      ** or if there are warnings which have not been displayed
      ** re-output the screen
      *
     C     NewTrSwftB    IFNE      PrvTrSwft
     C     WIdx_EVALB    ORNE      PrvN_Warn
     C     PUYAT         OREQ      'N'                                                        201429
     C     PUYAT         IFEQ      'N'                                                        201429
     C                   EVAL      PUYAT = 'Y'                                                201429
     C                   ENDIF                                                                201429
     C                   GOTO      ESRValE2
     C                   ENDIF
      *
      ** Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       OKTrSwft
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** Get last screen before update
     C                   EVAL      WLScrn = WScrn
      *
      ** If windows processing on, call window routine else
      ** Go to updates
      *
      *
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           WScrn
     C                   ELSE
     C                   MOVEL     'U'           WScrn
     C                   ENDIF
      *
     C     ESRValE2      ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvTrd - Retreive buy-sell trade                           *
      *                                                               *
      *****************************************************************
      *
     C     SRRtvTrd      BEGSR
      *
      ** Retrieve buy-sell trade
      *
     C                   CALLB     'SETRADRTV'
      *                             =========
      ** INPUTS
      ** ======
      *
      ** Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Mode = '*FRONT' (Front office transaction interface)
      ** Mode = '      ' (Not front office transaction interface)
     C                   PARM                    @@MODE            6
      *
      ** Response mode
     C                   PARM      'S'           @@RSMD            1
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      ** (Midas) Trade Reference
     C                   PARM                    DDTDRF
      *
      ** MT5XX - Phase 2 Message Generation is on.
     C                   PARM                    CSW003
      *
      * Buy-sell back
     C                   PARM                    PFBYSL            1
      *
      * Trade Reference
     C                   PARM                    PFTDRF            6
      *
      ** OUTPUTS
      ** =======
      *
      ** (Current) TRADE in file format
     C                   PARM                    CrTrFilFmt
     C                   PARM                    CT1AFilFmt
     C                   PARM                    CT1BFilFmt
      *
      ** OK - Action code
     C                   PARM      *BLANK        DDACTNOK
      *
      ** OK - Trade Reference
     C                   PARM      *BLANK        DDTDRFOK
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
      *
      ** Move book from file to work field for later checking.
      *
     C                   MOVE      C_TDBK        OLDBK1            2
     C                   MOVE      *BLANK        WARNIND           1
      *
     C     ESRRtvTrd     ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtTrd - Convert trade into screen fields                  *
      *                                                               *
      *****************************************************************
      *
     C     SRCvtTrd      BEGSR
      *
      ** Call program to fill screen fields with data from TRADSD
      *
     C                   CALLB     'SETRADCVT'
      *                             =========
      ** INPUTS
      ** ======
      *
      ** Return Code
      ** Trade in file format
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    CrTrFilFmt
     C                   PARM                    CT1AFilFmt
     C                   PARM                    CT1BFilFmt
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
                                                                                              CAS006
     C                   PARM                    CAS006                                       CAS006
      ** Taxation of Savings Income                                                           CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      ** OUTPUTS
      ** =======
      *
      ** Trade - screen formats
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
     C                   PARM                    NewTrThir                                    CAS006
     C                   PARM                    NewTrExch
     C                   PARM                    NewTrSett
     C                   PARM                    NewTrChCm
     C                   PARM                    NewTrSwftA
     C                   PARM                    NewTrSwftB
      *
      ** Security Details
      ** Investment Type Details
     C                   PARM                    SECTY
     C                   PARM                    INVTP
      *
      ** Nominal Currency Details
     C                   PARM                    NomCcyDts
      *
      ** Settlement Currency Details
     C                   PARM                    SetCcyDts
      *
      ** Customer (Counterparty) Details
     C                   PARM                    CustDts
      *
      ** Trade Status
      ** Trade Authorized/Not Authorized
     C                   PARM                    DDSTAT            9
     C                   PARM                    DDAUTH           14
      *
      ** Security report name
      ** Customer report name
     C                   PARM                    DDSRNME
     C                   PARM                    DDCRNM           20
      *
      ** Coupon Rate
      ** Current Factor
      ** Margin Amount
      ** Portfolio Exchange Rate
      ** Portfolio M/D Ind
      ** Trade Countervalue
     C                   PARM                    DDCPNR           13
     C                   PARM                    DDCFCT           12
     C                   PARM                    DDMAMT           18
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
     C                   PARM                    DDTCTR           21
     C                   PARM                    DDWTAX
     C                   PARM                    DDPRICN                                      CAS006
      *
      ** SCREEN A
      ** Destination of Settlement
      ** Destination of Confirmation
     C                   PARM                    A_DDROUS          6
     C                   PARM                    A_DDROTS         12
     C                   PARM                    A_DDROUC          6
     C                   PARM                    A_DDROTC         12
      *
      ** SCREEN B
      ** Destination of Settlement
      ** Destination of Confirmation
     C                   PARM                    B_DDROUS          6
     C                   PARM                    B_DDROTS         12
     C                   PARM                    B_DDROUC          6
     C                   PARM                    B_DDROTC         12
     C                   PARM                    DDFRNT                                    AR698195B
      *
      ** Update 'Current' TRADE with TRADE in Screen Format
      *
     C                   MOVEL     NewTrPrim     CurTrPrim
     C                   MOVEL     NewTrSeco     CurTrSeco
     C                   MOVEL     NewTrThir     CurTrThir                                    CAS006
     C                   MOVEL     NewTrExch     CurTrExch
     C                   MOVEL     NewTrSett     CurTrSett
     C                   MOVEL     NewTrChcm     CurTrChcm
     C                   MOVEL     NewTrSwftA    CurTrSwftA
     C                   MOVEL     NewTrSwftB    CurTrSwftB
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCancP - Cancel on primary details screen                   *
      *                                                               *
      *****************************************************************
      *
     C     SRCancP       BEGSR
      *
      ** If second leg processing and cancel was taken, save second leg
      ** details and set up first leg details.
      *
     C                   IF        PFBYSL = 'N'
 
     C                   EVAL      NwTrFilFmt2 = NwTrFilFmt
     C                   EVAL      NT1AFilFmt2 = NT1AFilFmt
     C                   EVAL      NT1BFilFmt2 = NT1BFilFmt
     C                   EVAL      NewTrPrim2  = NewTrPrim
     C                   EVAL      NewTrSeco2  = NewTrSeco
     C                   EVAL      NewTrThir2  = NewTrThir                                    CAS006
     C                   EVAL      NewTrExch2  = NewTrExch
     C                   EVAL      NewTrSett2  = NewTrSett
     C                   EVAL      NewTrChcm2  = NewTrChcm
     C                   EVAL      NewTrSwftA2 = NewTrSwftA
     C                   EVAL      NewTrSwftB2 = NewTrSwftB
 
     C                   EVAL      @FOTRANSEL  = W1FRNT
     C                   EVAL      @TMESTPSEL = PFTMESTPSEL
     C                   EVAL      DDFOASOCID  = W1AFRT
 
     C                   EVAL      NwTrFilFmt = NwTrFilFmt1
     C                   EVAL      NT1AFilFmt = NT1AFilFmt1
     C                   EVAL      NT1BFilFmt = NT1BFilFmt1
     C                   EVAL      NewTrPrim  = NewTrPrim1
     C                   EVAL      NewTrSeco  = NewTrSeco1
     C                   EVAL      NewTrThir  = NewTrThir1                                    CAS006
     C                   EVAL      NewTrExch  = NewTrExch1
     C                   EVAL      NewTrSett  = NewTrSett1
     C                   EVAL      NewTrChcm  = NewTrChcm1
     C                   EVAL      NewTrSwftA = NewTrSwftA1
     C                   EVAL      NewTrSwftB = NewTrSwftB1
      *
      ** Bring back processing to last screen of first trade
     C                   EVAL      WScrn = WLScrn
     C                   EVAL      PFBYSL= 'Y'
     C                   EVAL      PSBYSL= 'Y'
     C                   GOTO      ESrCancP
     C                   ENDIF
      *
      ** If records are still to be read from the subfile, read them
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           WScrn
     C                   GOTO      ESrCancP
     C                   ENDIF
      *
      ** Else, return to browse screen
      *
     C                   MOVEL     'I'           WScrn
      *
     C     ESrCancP      ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCancS - Cancel on secondary details screen                 *
      *                                                               *
      *****************************************************************
      *
     C     SRCancS       BEGSR
      *
      ** If action code is insert, go to primary screen
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     'P'           WScrn
     C                   ELSE
      *
      ** Else, return to the browse screen
      *
     C                   MOVEL     'I'           WScrn
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************                       CAS006
      *  SRCancT - CANCEL ON THIRD SCREEN                                                     CAS006
      *****************************************************************                       CAS006
                                                                                              CAS006
     C     SRCancT       BEGSR                                                                CAS006
                                                                                              CAS006
      ** Return to second screen                                                              CAS006
                                                                                              CAS006
     C                   MOVEL     'S'           WScrn                                        CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
                                                                                              CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************
      *                                                               *
      *  SRCancO - Cancel on other details screen                     *
      *                                                               *
      *****************************************************************
      *
     C     SRCancO       BEGSR
      *
      ** Return to Secondary Screen
      *
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   MOVEL     'H'           WScrn                                        CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVEL     'S'           WScrn
     C                   ENDIF                                                                CAS006
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCancE1 - Cancel on extension screen 1                      *
      *                                                               *
      *****************************************************************
      *
     C     SRCancE1      BEGSR
      *
      ** Return to Other Details Screen
      *
     C                   MOVEL     'O'           WScrn
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCancE2 - Cancel on extension screen 2                      *
      *                                                               *
      *****************************************************************
      *
     C     SRCancE2      BEGSR
      *
      ** Return to Extension Screen A
      *
     C                   MOVEL     'A'           WScrn
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExtSet1 - Return on extended settlement screen 1           *
      *                                                               *
      *****************************************************************
      *
     C     SRExtSet1     BEGSR
      *
      ** Return to SWIFT Details Screen A
      *
     C                   MOVEL     'A'           WScrn
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExtSet2 - Return on extended settlement screen 2           *
      *                                                               *
      *****************************************************************
      *
     C     SRExtSet2     BEGSR
      *
      ** Return to SWIFT Details Screen B
      *
     C                   MOVEL     'B'           WScrn
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update buy-sell trade details                     *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdate      BEGSR
      *
      ** Update valid deal: Front office transaction Id
     C                   MOVEL     @FOTRANSEL    FRNT
     C                   MOVEL     @FOTRANSEL    A_T1FRNT
     C                   MOVEL     @FOTRANSEL    B_T1FRNT
     C                   MOVEL     DDFOASOCID    AFRT
     C                   MOVEL     DDFOASOCID    A_T1AFRT
     C                   MOVEL     DDFOASOCID    B_T1AFRT
      *
      ** Update valid trade: change type
     C                   MOVEL     DDACTN        CHTP
      *
      ** Check if first leg, if yes, save details first
      *
     C                   IF        PFBYSL = 'Y'
      *
      ** Save first leg FO id and timestamp.
     C                   EVAL      PFFOTRANSEL = @FOTRANSEL
     C                   EVAL      PFTMESTPSEL = @TMESTPSEL
      *
     C                   EVAL      NwTrFilFmt1 = NwTrFilFmt
     C                   EVAL      NT1AFilFmt1 = NT1AFilFmt
     C                   EVAL      NT1BFilFmt1 = NT1BFilFmt
     C                   EVAL      NewTrPrim1  = NewTrPrim
     C                   EVAL      NewTrSeco1  = NewTrSeco
     C                   EVAL      NewTrThir1  = NewTrThir                                    CAS006
     C                   EVAL      NewTrExch1  = NewTrExch
     C                   EVAL      NewTrSett1  = NewTrSett
     C                   EVAL      NewTrChcm1  = NewTrChcm
     C                   EVAL      NewTrSwftA1 = NewTrSwftA
     C                   EVAL      NewTrSwftB1 = NewTrSwftB
      *
      ** Perform processing of second leg by getting reference number
     C                   EVAL      @ACSEL = 'I'
     C                   EVAL      @FOTRANSEL = DDFOASOCID
      *
      ** Get timestamp after obtaining second leg FO id.
     C     @FOTRANSEL    CHAIN     SEIBYSLD0                          99
      *
     C                   IF        NOT(*IN99)
     C                   EVAL      @TMESTPSEL = DDTMESTMP
     C                   EVAL      PFBYSL = 'N'
     C                   EXSR      SRPrInv
     C                   ENDIF
      *
     C                   GOTO      ESRUpdate
     C                   ENDIF
      *
      ** Generate trade numbers if not entered. Also set
      ** link references.
      *
     C                   EXSR      SRTradeRef
      *
      ** Perform trade update for first leg
      *
     C                   CALLB     'SETRADUPD'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    NwTrFilFmt1
     C                   PARM                    NT1AFilFmt1
     C                   PARM                    NT1BFilFmt1
     C                   PARM                    S01401
     C                   PARM                    CSW003
     C                   PARM                    CAP051
     C                   PARM                    CAS006                                       222373
     C                   PARM                    CGL031                                       CGL031
     C                   PARM      'RPR'         PMODE                                        222373
      **  Extra parameter needed to pass detail for Midas Compliance                          CSD015
      **  Watch Enhancement.                                                                  CSD015
     C                   PARM                    PMCWL                                        CSD015
     C**********         PARM                    CAS006                                CAS006 222373
     C**********         PARM      'RPR'         PMODE                                 216338 222373
     C                   PARM                    SEVTRDX2A1                                   222373
     C                   PARM                    SEVTRDX2B1                                   222373
      *
      ** If there were any errors in the update functions, rollback any
      ** updates and end this program.
      ** otherwise delete the invalid trade actioned & commit the updates
      *
     C     @RTCD         IFNE      *BLANK
     C                   ROLBK
     C     @RTCD         IFNE      '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ELSE
      *
      ** Perform update for second leg.
      *
     C                   CALLB     'SETRADUPD'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM                    NwTrFilFmt
     C                   PARM                    NT1AFilFmt
     C                   PARM                    NT1BFilFmt
     C                   PARM                    S01401
     C                   PARM                    CSW003
     C                   PARM                    CAP051
     C                   PARM                    CAS006                                       222373
     C                   PARM                    CGL031                                       CGL031
     C                   PARM      'RPR'         PMODE                                        222373
      **  Extra parameter needed to pass detail for Midas Compliance                          CSD015
      **  Watch Enhancement.                                                                  CSD015
     C                   PARM                    PMCWL                                        CSD015
     C**********         PARM                    CAS006                                CAS006 222373
     C**********         PARM      'RPR'         PMODE                                 216338 222373
     C                   PARM                    SEVTRDX2A                                    222373
     C                   PARM                    SEVTRDX2B                                    222373
      *
     C
     C     @RTCD         IFNE      *BLANK
     C                   ROLBK
     C     @RTCD         IFNE      '*RECUPD'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ELSE
      *
      ** No errors, delete invalid records and commit changes
      *
     C     ZATRNKD0      CHAIN     SEIBYSLD0                          99
     C                   IF        NOT(*IN99)
     C                   DELETE    SEIBYSLD0
                                                                                              CSC011
      ** Delete the record from the APILOGPD file for the second leg                          CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR                             CSC011
     C                   EVAL      KMsgType = 'SEBYSL'                                        CSC011
     C                   EVAL      KFrntOfcID = @FOTRANSEL                                    CSC011
     C                   EVAL      KTimeStamp = PFTMESTPSEL                                   CSC011
                                                                                              CSC011
     C     KAPILOGL0     CHAIN     APILOGL0                           99                      CSC011
                                                                                              CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGD0                                                   CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF
      *
     C                   EVAL      @FOTRANSEL = PFFOTRANSEL
     C                   EVAL      @TMESTPSEL = PFTMESTPSEL
      *
     C     ZATRNKD0      CHAIN     SEIBYSLD0                          99
     C                   IF        NOT(*IN99)
     C                   DELETE    SEIBYSLD0
                                                                                              CSC011
      ** Delete the record from the APILOGPD file for the first leg                           CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' and S1SUPP = LIBR                             CSC011
     C                   EVAL      KMsgType = 'SEBYSL'                                        CSC011
     C                   EVAL      KFrntOfcID = @FOTRANSEL                                    CSC011
     C                   EVAL      KTimeStamp = @TMESTPSEL                                    CSC011
                                                                                              CSC011
     C     KAPILOGL0     CHAIN     APILOGL0                           99                      CSC011
                                                                                              CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGD0                                                   CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF
      *
     C                   COMMIT
      *
      ** Set up narratives
     C                   EVAL      @SITR = W1TDRF
     C                   EVAL      PSITR = TDRF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** If error occurred in updating last transaction set on flag to
      ** display message on 'browse' screen.
     C     @RTCD         IFEQ      '*RECUPD'
     C                   MOVE      'Y'           @ERRUP
     C                   ELSE
     C                   MOVE      'N'           @ERRUP
     C                   ENDIF
     C
      *
      ** If records are still to be read from the subfile, read them
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           WScrn
     C                   ELSE
      *
      ** Else, return to the browse screen
      *
     C                   MOVEL     'I'           WScrn
     C                   ENDIF
      *
     C     ESRUpdate     ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTradeRf - Get trade reference                              *
      *                                                               *
      *****************************************************************
      *
     C     SRTradeRef    BEGSR
      *
     C     W1DDTDRF      IFEQ      *BLANK
      *
     C                   CALLB     'ZATRNRTV'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      'SE'          PMODU             2
     C                   PARM      'T'           PTRTY             1
     C                   PARM                    W1DDTDRF
     C                   PARM      *ZEROS        W1TDRF
      *
      ** Database error
      *
     C     RetCodeOut    IFNE      *BLANK
     C                   MOVEL     'ZATRNRTV'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   MOVEL     W1DDTDRF      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      'Y'           WFTrdBlk          1
     C                   ENDIF
      *
      ** Get trade reference number for the second leg.
      *
     C     DDTDRF        IFEQ      *BLANKS
      *
     C                   CALLB     'ZATRNRTV'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM      'SE'          PMODU             2
     C                   PARM      'T'           PTRTY             1
     C                   PARM                    DDTDRF
     C                   PARM      *ZEROS        TDRF
      *
      ** Database error
      *
     C     RetCodeOut    IFNE      *BLANK
     C                   MOVEL     'ZATRNRTV'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   MOVEL     DDTDRF        DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      'N'           WFTrdBlk
     C                   ENDIF
      *
      ** Check if first leg is the same as second leg, if yes, generate
      ** a new one for the second leg.
      *
     C                   IF        W1DDTDRF = DDTDRF
     C                   MOVEL     DDTDRF        PTDRF
      *
     C                   DOU       NOT(*IN01)
     C                   ADD       1             PTDRF             6 0
     C                   MOVEL     PTDRF         WPTDRF            6
     C     WPTDRF        SETLL     TRADSDF                                01
     C                   IF        NOT(*IN01)
     C     WPTDRF        SETLL     HSTTRDF                                01
     C                   ENDIF
     C                   ENDDO
      *
     C                   IF        WFTrdBlk <> 'Y'
     C                   EVAL      DDTDRF = WPTDRF
     C                   ELSE
     C                   EVAL      W1DDTDRF = WPTDRF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Save link reference numbers
     C                   EVAL      TDRF = DDTDRF
     C                   EVAL      W1TDRF = W1DDTDRF
     C                   EVAL      LKRF = W1TDRF
     C                   EVAL      W1LKRF = DDTDRF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate2 - Update buy-sell trade details                    *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdate2     BEGSR
      *
 
      *
      ** Update valid trade: trade reference
      *
     C                   MOVEL     DDTDRF        TDRF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREndP - End Program                                         *
      *                                                               *
      *****************************************************************
      *
     C     SREndP        BEGSR
      *
     C                   MOVEL     'T'           WScrn
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClear - Clear numeric variables                            *
      *                                                               *
      *****************************************************************
      *
     C     SRClear       BEGSR
      *
     C**********         Z-ADD     0             TCNR                                         CSD027
     C                   EVAL      TCNR = *BLANKS                                             CSD027
     C                   Z-ADD     0             NOML
     C                   Z-ADD     0             TNMD
     C                   Z-ADD     0             TPDY
     C                   Z-ADD     0             TDVD
     C                   Z-ADD     0             TDDT
     C                   Z-ADD     0             TCAP
     C                   Z-ADD     0             DADJ
     C                   Z-ADD     0             ITRA
     C                   Z-ADD     0             TINA
     C                   Z-ADD     0             TDCR
     C                   Z-ADD     0             PRIC
     C                   Z-ADD     0             RALL
     C                   Z-ADD     0             TDER
     C                   Z-ADD     0             TBCR
     C                   Z-ADD     0             SMTH
     C                   Z-ADD     0             ASNM
     C**********         Z-ADD     0             DELT                                         CSD027
     C**********         Z-ADD     0             DELF                                         CSD027
     C                   EVAL      DELT = *BLANKS                                             CSD027
     C                   EVAL      DELF = *BLANKS                                             CSD027
     C                   Z-ADD     0             TBCA
     C                   Z-ADD     0             TCCA
     C                   Z-ADD     0             TCA1
     C                   Z-ADD     0             TCA2
     C                   Z-ADD     0             TCA3
     C                   Z-ADD     0             TCA4
     C                   Z-ADD     0             TCA5
     C                   Z-ADD     0             TCA6
     C                   Z-ADD     0             TCA7
     C                   Z-ADD     0             TAXA
     C                   Z-ADD     0             BCMR
     C                   Z-ADD     0             CCMR
     C                   Z-ADD     0             TXRB
     C                   Z-ADD     0             TIME
     C                   Z-ADD     0             TOSN
     C                   Z-ADD     0             TNSN
     C                   Z-ADD     0             TNSP
     C                   Z-ADD     0             TOSV
     C                   Z-ADD     0             TVSN
     C                   Z-ADD     0             TVSP
     C                   Z-ADD     0             TDSN
     C                   Z-ADD     0             TDSP
     C                   Z-ADD     0             TDFS
     C                   Z-ADD     0             TSSQ
     C                   Z-ADD     0             TCSR
     C                   Z-ADD     0             TCTR
     C                   Z-ADD     0             TDMC
     C                   Z-ADD     0             TOED
     C                   Z-ADD     0             LCD
     C                   Z-ADD     0             TNLU
     C                   Z-ADD     0             LSWS
     C                   Z-ADD     0             TCFC
     C                   Z-ADD     0             SPXR
     C                   Z-ADD     0             FXMP
     C                   Z-ADD     0             FXMR
     C                   Z-ADD     0             MAMT
     C                   Z-ADD     0             ORDE
     C                   Z-ADD     0             WHTX
     C                   Z-ADD     0             A_T1LSWS
     C                   Z-ADD     0             A_T1LSSC
     C                   Z-ADD     0             B_T1LSWS
     C                   Z-ADD     0             B_T1LSSC
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInitial - Go to initial screen                             *
      *                                                               *
      *****************************************************************
      *
     C     SRInitial     BEGSR
      *
      ** If action code is insert, go to primary screen
      *
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     'P'           WScrn
     C                   ELSE
      *
      ** Else, go to secondary screen
      *
     C                   MOVEL     'S'           WScrn
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIntRCal - Force interest recalculation                     *
      *                                                               *
      *****************************************************************
      *
     C     SRIntRCal     BEGSR
      *
      ** If any of the following have changed, cause interest recalculation
      ** (by blanking out interest amount) - but only if interest hasn't
      ** been changed: nominal, value date, accrued indicator, days
      ** adjustment, and actual/difference ind.
      *
     C     DDNOML        IFNE      @PDDNOML
     C     DDTDVD        ORNE      @PDDTDVD
     C     DDACIN        ORNE      @PDDACIN
     C     DDDADJ        ORNE      @PDDDADJ
     C     DDACTD        ORNE      @PDDACTD
     C     DDITRA        IFEQ      @PDDITRA
     C                   MOVEL     *BLANK        DDITRA
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPrcRCal - Force price recalculation                        *
      *                                                               *
      *****************************************************************
      *
     C     SRPrcRCal     BEGSR
      *
      ** If any of the following have changed, cause price recalculation
      ** (by blanking out % price) - but only if price hasn't been
      ** changed: nominal, price/discount/yield, value date,
      ** accrued indicator, and interest
      *
     C     DDNOML        IFNE      @PDDNOML
     C     DDTPDY        ORNE      @PDDTPDY
     C     DDTDVD        ORNE      @PDDTDVD
     C     DDACIN        ORNE      @PDDACIN
     C     DDITRA        ORNE      @PDDITRA
     C     DDPRIC        IFEQ      @PDDPRIC
     C                   MOVEL     *BLANK        DDPRIC
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChCmCal - Charges and commission calculation               *
      *                                                               *
      *****************************************************************
      *
     C     SRChCmCal     BEGSR
 
     C                   CALLB     'SETCHCMCAL'
      *                             ==========
      ** INPUTS
      ** ======
      *
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
     C                   PARM                    TCNR
     C                   PARM                    NOML             11 0
     C                   PARM                    PRIC             15 8
     C                   PARM                    TDDT              5 0
     C                   PARM                    ITRA             13 0
     C                   PARM                    TCFC             10 9
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
     C                   PARM                    PrvTrChCm
      *
      ** Trade Charges & Commissions OK inds
     C                   PARM                    OKTrChCm
      *
      ** ICD
      ** ===
      *
      ** Autocharge Option
      ** Securities Charges Currency
      ** Adjust Commission Same Day T
     C                   PARM                    BVACOP            1
     C                   PARM                    BVCHRC            3
     C                   PARM                    BVACSD            1
     C                   PARM                    S01446            1
      *
      ** OUTPUTS
      ** =======
      *
      ** Trade Charges & commissions screen fields
     C                   PARM                    NewTrChCm
      *
      ** Trade details
     C                   PARM                    TBCA             13 0
     C                   PARM                    TCCA             13 0
     C                   PARM                    TCA1             13 0
     C                   PARM                    TCA2             13 0
     C                   PARM                    TCA3             13 0
     C                   PARM                    TCA4             13 0
     C                   PARM                    TCA5             13 0
     C                   PARM                    TCA6             13 0
     C                   PARM                    TCA7             13 0
     C                   PARM                    TAXA             13 0
     C                   PARM                    BCMR             13 0
     C                   PARM                    CCMR             13 0
     C                   PARM                    TXRB             13 0
 
     C                   ENDSR
      *
      *****************************************************************                       233881
      /EJECT                                                                                  233881
      *****************************************************************                       233881
      *                                                               *                       233881
      * SREuTxCal - EU Tax Calculation                                *                       233881
      *                                                               *                       233881
      *****************************************************************                       233881
     C     SREuTxCal     BEGSR                                                                233881
                                                                                              233881
     C                   CALLB     'SEVTRADTAX'                                               233881
                                                                                              233881
      * INPUTS                                                                                233881
                                                                                              233881
      * Response Mode                                                                         233881
     C                   PARM                    RespMode                                     233881
      * Valid Trade Details                                                                   233881
     C                   PARM                    NwTrFilFmt                                   233881
      * Security Details                                                                      233881
     C                   PARM                    SECTY                                        233881
      * Process Flag                                                                          233881
     C                   PARM      'E'           ProcFlag          1                          233881
                                                                                              233881
      * OUTPUTS                                                                               233881
                                                                                              233881
      * EU Tax Screen Format                                                                  233881
      * EU Tax in Nominal Currency File Format                                                233881
      * EU Tax in Settlement Currency File Format                                             233881
     C                   PARM                    DDEUTX                                       233881
     C                   PARM                    EUTX                                         233881
     C                   PARM                    EUTS                                         233881
                                                                                              233881
     C                   ENDSR                                                                233881
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCValCal - Countervalue calcualtion                         *
      *                                                               *
      *****************************************************************
      *
     C     SRCValCal     BEGSR
      *
      ** Calculate countervalue
     C                   CALLB     'SETCVALCAL'
      *                             ==========
      ** INPUTS
      ** ======
      *
      ** Trade details
     C                   PARM                    TDTP              2
     C                   PARM                    NOML             11 0
     C                   PARM                    PRIC             15 8
     C                   PARM                    RALL              9 5
     C                   PARM                    ITRA             13 0
     C                   PARM                    TBCA             13 0
     C                   PARM                    TCCA             13 0
     C                   PARM                    TCA1             13 0
     C                   PARM                    TCA2             13 0
     C                   PARM                    TCA3             13 0
     C                   PARM                    TCA4             13 0
     C                   PARM                    TCA5             13 0
     C                   PARM                    TCA6             13 0
     C                   PARM                    TCA7             13 0
     C                   PARM                    TAXA             13 0
     C                   PARM                    TDER             13 8
     C                   PARM                    TMDI              1
     C                   PARM                    SETC              3
     C                   PARM                    TDVD              5 0                        210284
      *
      ** Security details
     C                   PARM                    PROT              1
     C                   PARM                    SPBS              1
     C                   PARM                    CFCT             10 9
     C                   PARM                    NMCY              3
     C                   PARM                    NMDP              1 0
     C                   PARM                    SESN             10                          210284
      *
      ** Nominal Currency Details
      ** Settlement Currency Details
     C                   PARM                    NomCcyDts
     C                   PARM                    SetCcyDts
      *
      ** Customer classification
     C                   PARM                    CustClass         1
      *
      ** Country of treaty from PF/SECTYD
     C                   PARM                    CRTT
      *
      ** Default basket for backup withholding
     C                   PARM                    PDRBW
      *
      ** Value date
     C                   PARM                    TDVD
                                                                                              233881
      ** EU Tax                                                                               233881
     C                   PARM                    EUTX                                         233881
      *
      ** OUTPUTS
      ** =======
      *
      ** Trade consideration in nominal currency
      ** Trade countervalue in nominal currency
      ** Withholding tax
      ** Trade countervalue in settlement currency in screen format
      ** Withholding tax in screen format
     C                   PARM                    TCSR             15 0
     C                   PARM                    TCTR             15 0
     C                   PARM                    WHTX
     C                   PARM                    DDTCTR           21
     C                   PARM                    DDWTAX
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     'SETRADRPR'   DBPGM
      *
      ** Access Bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     3             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access general ledger details
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   Z-ADD     4             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access securities trading details
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** Database error
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     @OPTN         DBKEY
     C                   MOVEL     'SDSTRDPD'    DBFILE
     C                   Z-ADD     5             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   Z-ADD     6             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR details file to determine if S01401
      ** (MT5XX Message Generation) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01401'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     7             DBASE
     C                   MOVEL     'S01401'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01401            1
     C                   ELSE
     C                   MOVEL     'N'           S01401
     C                   ENDIF
      *
      ** Access SAR details file to determine if S01446
      ** (Customer commission switchable feature) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01446'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     8             DBASE
     C                   MOVEL     'S01446'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01446            1
     C                   ELSE
     C                   MOVEL     'N'           S01446
     C                   ENDIF
      *
      ** Access SAR details file to determine if S01496
      ** (Private Banking SE enhancements) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'S01496'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     9             DBASE
     C                   MOVEL     'S01496'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01496            1
     C                   ELSE
     C                   MOVEL     'N'           S01496
     C                   ENDIF
      *
      ** Access SAR details file to determine if CSW003
      ** (MT5XX - Phase 2 message generation) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSW003'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     10            DBASE
     C                   MOVEL     'CSW003'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CSW003            1
     C                   ELSE
     C                   MOVEL     'N'           CSW003
     C                   ENDIF
      *
      ** Access SAR details file to determine if CAP050
      ** (Midas/ToF Interface) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAP050'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     11            DBASE
     C                   MOVEL     'CAP050'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CAP050            1
     C                   ELSE
     C                   MOVEL     'N'           CAP050
     C                   ENDIF
      *
      ** Access SAR details file to determine if CAP051 is on.
      ** (Automatic Authorisation (SE Trades Part))
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAP051'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     12            DBASE
     C                   MOVEL     'CAP051'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CAP051            1
     C                   ELSE
     C                   MOVEL     'N'           CAP051
     C                   ENDIF
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
      ** Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     13            DBASE
     C                   MOVEL     'CEU005'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU005            1
     C                   ELSE
     C                   MOVEL     'N'           CEU005
     C                   ENDIF
      *
      ** Check if CSW201 - Swift 2001 Standards Update is installed
      *
     C                   CALL      'SWIF2001'                           9090
     C                   PARM      *BLANKS       @RTCD
 
     C                   IF        *IN90 = *ON
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   Z-ADD     14            DBASE
     C                   EVAL      DBKEY = 'CSW201'
     C                   EXSR      *PSSR
 
     C                   ELSE
     C                   IF        @RTCD = 'CSW2001'
     C                   EVAL      CSW201 = 'Y'
     C                   ELSE
     C                   EVAL      CSW201 = 'N'
     C                   ENDIF
     C                   ENDIF
      *
      ** Check if CSE028 feature is installed
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSE028'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Database Error
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C     *LOCK         IN        LDA
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     15            DBASE
     C                   MOVEL     'CSE028'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CSE028            1
     C                   ELSE
     C                   MOVEL     'N'           CSE028
     C                   ENDIF
      *
      ** Access API ICD Details
      *
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDAPIPD '    DBFILE
     C                   Z-ADD     16            DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CSC011
      ** Determine if CSC011 is installed                                                     CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *BLANKS                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C**********         IN        SDSTAT                                              CSC011 CSD015
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   IF        PRTCD <> '*NRF   '                                         CSC011
     C                   EVAL      DBKEY  = 'CSC011'                                          CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE  = 17                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CAS006
      ** Check if enhancement CAS006 (Hedge Accounting Phase B) is installed                  CAS006
                                                                                              CAS006
     C                   CALLB     'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRTCD                                        CAS006
     C                   PARM      '*VERIFY'     POPTN                                        CAS006
     C                   PARM      'CAS006'      PSARD                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS006
     C                   EVAL      DBKEY  = 'CAS006'                                          CAS006
     C                   EVAL      DBASE  = 18                                                CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        PRTCD = *BLANKS                                            CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      CAS006 = 'N'                                               CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
                                                                                              CSD015
     C                   IN        SDSTAT                                                     CSD015
      ** Access Switchable Features File, for Taxation Savings Income CGL031                  CGL031
                                                                                              CGL031
     C                   MOVE      'N'           CGL031                                       CGL031
     C                   CALL      'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRtcd                                        CGL031
     C                   PARM      '*VERIFY'     POptn                                        CGL031
     C                   PARM      'CGL031'      PSard                                        CGL031
                                                                                              CGL031
     C                   IF        PRtcd = *BLANKS                                            CGL031
     C                   MOVE      'Y'           CGL031                                       CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
      ** Database Error                                                                       CGL031
                                                                                              CGL031
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '                    CGL031
     C                   MOVEL     'CGL031 '     DBKEY                                        CGL031
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL031
     C                   MOVEL     '019'         DBASE                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
      *
      ** Key Lists
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
     C     ZATRNKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
                                                                                              CSC011
     C     KAPILOGL0     KLIST                                                                CSC011
     C                   KFLD                    KMsgType                                     CSC011
     C                   KFLD                    KFrntOfcID                                   CSC011
     C                   KFLD                    KTimeStamp                                   CSC011
      *
      ** Message Type
      ** Get the field number for the action code field; the primary
      ** screen fields start from that number.  Subtract one from it to
      ** give the value to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    Format
     C                   PARM                    FieldP
     C                   PARM                    FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffsetP = FieldNo - 1
     C                   ENDIF
      *
      ** Get the field number for the settle ccy field; the secondary
      ** screen fields start from that number.  Subtract one from it to
      ** give the value to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    Format
     C                   PARM                    FieldS
     C                   PARM                    FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffsetS = FieldNo - 1
     C                   ENDIF
      *
      ** Start on Browse Screen
      *
     C                   MOVEL     'I'           WScrn             1
     C                   MOVEL     'N'           @FRPGM            1
      *
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SEBYSLR016
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
