     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Validate IP beneficiary customer')            *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTVIBENC - Validate Beneficiary Customer                     *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                FTIPAYCTL                                      *
      *                FTIPAYRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. 259576             Date 02Apr14               *
      *  Prev Amend No. MD034521A          Date 14Sep15               *
      *                 MD039547           Date 20Sep16               *
      *                 MD047369A          Date 24Jan18               *
      *                 MD047369           Date 30Aug17               *
      *                 MD046248           Date 27Oct17               *
      *                 MD034709           Date 16Jun15               *
      *                 CSW215             Date 06Apr15               *
      *                 MD033530           Date 09Jun15               *
      *                 AR920574           Date 10Nov14               *
      *                 AR901277           Date 04Nov14               *
      *                 MD025111           Date 10May14               *
      *                 MD023025           Date 05Nov13               *
      *                 MD000091           Date 07May13               *
      *                 AR1077987          Date 17Jan13               *
      *                 CFT120             Date 28Sep12               *
      *                 AR851079           Date 22Oct12               *
      *                 AR750736           Date 22Oct12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE075             Date 06Dec10               *
      *                 259240             Date 17Mar09               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24378           Date 17Jun09               *
      *                 257001             Date 07Oct08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255286             Date 07Jul08               *
      *                 247142             Date 01Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 CFT032             Date 11Sep06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241002             Date 18Jul06               *
      *                 240689             Date 13Jul06               *
      *                 CDL049             Date 06Jul06               *
      *                 222466             Date 06Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4581            Date 20Oct04               *
      *                 BUG370             Date 15Sep04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  259576 - Remove warning message for Inactive accounts.       *
      *           Applied for MD-26109                                *
      *  MD034521A - Error handling of Blocked account is not the     *
      *              same across the modules                          *
      *  MD039547 - Referred account is not properly validated.       *
      *  MD047369A - Funds transfter does not check block Dr flag on  *
      *              beneficary customer account.                     *
      *  MD047369 - Funds transfter does not check block Dr flag on   *
      *             beneficary customer account.                      *
      *  MD046248 - Finastra Rebranding                               *
      *  MD034709 - A serious Midas error has occurred is encountered *
      *             upon hitting the Complete button in IPAY          *
      *  CSW215 - SWIFT Changes 2015                                  *
      *  MD033530 - Incorrect validation in case Retail Number is not *
      *             used.                                             *
      *  AR920574 - If a beneficiary of 35 chars is entered all       *
      *             IBANs afterwards are rejected. Cleared value of   *
      *             PIBAN to avoid having extra chars during          *
      *             validation. (Child: AR920575)                     *
      *  AR901277 - Beneficiary line 2 only contains a SWIFT BIC if   *
      *             it is in SWIFT BIC directory  (Child: AR901278)   *
      *  MD025111 - Incoming payment without charges is not allowed   *
      *             if the account is blocked for DR                  *
      *  MD023025 - SWIFT ID in Benefeciary Customer field of IPAY is *
      *             not accepted.                                     *
      *  MD000091 - Event Codes Substitution                          *
      *  AR1077987 - 45099999 Event code not found (Field:            *
      *              Beneficiary 1)                                   *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  AR851079 - Blocked debit account is debited in a FT          *
      *             transaction sent via API. Modified the validation *
      *             in AR750737 so that transactions sent via API will*
      *             be properly validated. (Child: AR851080)          *
      *  AR750736 - Blocked debit account is debited in a FT          *
      *             transaction. An error message will be displayed   *
      *             when a blocked debit account is about to be       *
      *             debited in a FT transaction. (Child: AR750737)    *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  259240 - FT IPAY validation of beneficiary field. Issue an   *
      *           error message if IBAN entered in the Beneficiary    *
      *           field is attached to an inactive account.           *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  BUG24378 - Comma is not being recognized as a valid          *
      *             SWIFT character                                   *
      *  257001 - Properly populate the fifth line.                   *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255286 - Allow lowercase characters on input                 *
      *  247142 - Funds Transfer allows payments over Blocked &       *
      *           Reffered Accounts without warning.                  *
      *           Apply fixes 232151 and 210654.                      *
      *  232151 - DBASE error when inserting an inactive account.     *
      *           Applied by 240689                                   *
      *  210654 - Check status of account. Applied by 240689          *
      *  CFT032 - Account line in field 50X in MT103 (Recompile)      *
      *  241002 - Cannot amend booking branch. Applied 227458.        *
      *  227458 - Do not override booking branch.  Applied part of    *
      *           217973.                                             *
      *  240689 - Applied fix 210654 + additional changes by 232151.  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  222466 - Booking branch should not be overwritten by the     *
      *           branch of the Beneficiary.                          *
      *           This fix is already catered by 227458.              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4581- Check for block debits/credits                      *
      *  BUG370 - Validation error not allowing first line of         *
      *           benficiary to be non blank and the rest blanks      *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT. (Recompiled)            *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Chain Full Account
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
      *
      ** Chain Retail Account
     FACNUMA    IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ACCNTABF:ACNUMABF)
      *****************************************************************
      /EJECT
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
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
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
      /COPY ZACPYSRC,ERR_XARRYS
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
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     D NwIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     D FTEIPY1       E DS                  EXTNAME(FTEIPY1PD)
      *
      ** Counterparty Nostros
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      *
      ** BIC Directory
     D MEBICD        E DS                  EXTNAME(MEBICDPD)
      *
      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** External DS for account details
     D P@ACCN        E DS                  EXTNAME(ACCNTAB)
     D  IBCNUM       E                     EXTFLD(CNUM)
     D  IBBRCA       E                     EXTFLD(BRCA)
     D  IBACOD       E                     EXTFLD(ACOD)
     D  IBACSQ       E                     EXTFLD(ACSQ)
     D  IBLCD        E                     EXTFLD(LCD)
      *
     D/COPY WNCPYSRC,FTH00517
      ** DS for access programs - Long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *                                                                                       CSW215
      ** DS for Access Objects - short data structure                                         CSW215
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSW215
      *                                                                                       CSW215
      ** Data structure for Nostro details                                                    CSW215
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                                  CSW215
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** DS for IBANs full account
     D PIBANAcc        DS
     D**PIBCNUM*               1      6  0                                                    CSD027
     D  PIBCNUM                1      6                                                       CSD027
     D  PIBCCY                 7      9
     D  PIBACOD               10     19  0                                                    CGL029
     D  PIBACSQ               20     21  0                                                    CGL029
     D  PIBBRCA               22     24                                                       CGL029
     D**PIBACOD*              10     13  0                                                    CGL029
     D**PIBACSQ*              14     15  0                                                    CGL029
     D**PIBBRCA*              16     18                                                       CGL029
      *
      ** Define full account to be passed for FT IMM update
     D*IMACNT***       DS            18                                                       CGL029
     D IMACNT          DS                                                                     CGL029
     D**IMCNUM**               1      6  0                                                    CSD027
     D  IMCNUM                 1      6                                                       CSD027
     D  IMCCY                  7      9
     D  IMACOD                10     19  0                                                    CGL029
     D  IMACSQ                20     21  0                                                    CGL029
     D  IMBRCA                22     24                                                       CGL029
     D**IMACOD**              10     13  0                                                    CGL029
     D**IMACSQ**              14     15  0                                                    CGL029
     D**IMBRCA**              16     18                                                       CGL029
      *
      ** Fields needed in setting default pay value date
     D PPYFLDS         DS
     D  CNUMPY                 1      6
     D  CCYPY                  7      9
     D  ACODPY                10     19                                                       CGL029
     D  ACSQPY                20     21                                                       CGL029
     D  BRCAPY                22     24                                                       CGL029
     D**ACODPY**              10     12                                                       CGL029
     D**ACSQPY**              13     15                                                       CGL029
     D**BRCAPY**              16     18                                                       CGL029
      *
      ** Data structure redefining address fields
     D                 DS
     D*Address**               1    140                                                       257001
     D Address                 1    175                                                       257001
     D  AdChk1                 1     35
     D  AdChk2                36     70
     D  AdChk3                71    105
     D  AdChk4               106    140
     D  AdChk5               141    175
      *
      ** Data Structure to concatanate screen Beneficiary Customer
     D                 DS
     D BCR0                    1    175
     D  W0BNC1                 1     35
     D  W0BNC2                36     70
     D  W0BNC3                71    105
     D  W0BNC4               106    140
     D  W0BNC5               141    175
      *
     D  BCSL                   1      1
     D**BPART***               1     12                                                       CGL029
     D  BPART                  1     18                                                       CGL029
     D**BCNUM***               1      6  0                                                    CSD027
     D  BCNUM                  1      6                                                       CSD027
     D  BCNUMA                 1      6
     D  BACOD                  7     16  0                                                    CGL029
     D  BACSQ                 17     18  0                                                    CGL029
     D  BBRCA                 19     21                                                       CGL029
     D**BACOD***               7     10  0                                                    CGL029
     D**BACSQ***              11     12  0                                                    CGL029
     D**BBRCA***              13     15                                                       CGL029
     D  BSNAM                  1     10
      *
     D  BCR6                   7    175
     D  BCR10                 11    175
     D  BCR12                 13    175
     D  BCR18                 19    175                                                       CSD027
     D  BCR21                 22    175                                                       CSD027
     D  BCR1318               13     18                                                       CSD027
     D  BCR1321               13     21                                                       CSD027
     D**BCR15***              16    175                                                       CGL029
     D  BCR15                 22    175                                                       CGL029
     D  ##140                 36    175
     D  ##129                 47    175
     D  ##011                 36     47
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *                                                                                       240689
     D WIx             S              3P 0                                                    240689
      *                                                                                       240689
      ** Index for arrays of warning message ids etc                                          240689
      *
     D SW              S              1    DIM(12)
     D WFld            S             35    DIM(1)
     D WTst            S              1    DIM(35)
     D*SWCH*****       S              1    DIM(47) CTDATA PERRCD(47)                          255286
     D SWCH            S              1    DIM(73) CTDATA PERRCD(73)                          255286
     D ##CSID          S              1
      *
      ** Alphabetic array
     D ALPH            S              1    DIM(26) CTDATA PERRCD(26)
      *
      ** Numeric array
     D NUMC            S              1    DIM(10) CTDATA PERRCD(10)
                                                                                              CGL029
      ** Fields redefined by CGL029                                                           CGL029
     D PBNCDS          S             24A                                                      CGL029
     D KACCD           S             10P 0                                                    CGL029
      *                                                                                     MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
      *                                                                                     MD025111
     D BENEDrBlck      S              1A                                                    MD025111
     D BENEDrRefd      S              1A                                                   MD047369A
                                                                                              CSW215
      ** Work variable for CSW215                                                             CSW215
     D CSW215          S              1A                                                      CSW215
     D PAType          S             10A                                                      CSW215
     D PErrTyp         S              1A                                                      CSW215
     D PNwrk           S              6A                                                      CSW215
     D PMsgTp          S              3A                                                      CSW215
     D PBrch           S              3A                                                      CSW215
     D PCurr           S              3A                                                      CSW215
     D PValTyp         S              4A                                                      CSW215
     D PCnty           S              2A                                                      CSW215
     D PNost           S              2A                                                      CSW215
     D POut1           S             35A                                                      CSW215
     D POut2           S             35A                                                      CSW215
     D POut3           S             35A                                                      CSW215
     D POut4           S             35A                                                      CSW215
     D POut5           S             35A                                                      CSW215
     D PMsgId          S              7A                                                      CSW215
     D PMsgTg          S              5A                                                      CSW215
     D ParmStr         S             35A                                                      CSW215
     D WCNum           S              6A                                                      CSW215
     D WCust           S             10A                                                      CSW215
     D POptn           S              7A                                                      CSW215
     D PDBACT          S             18A                                                      CSW215
     D PCUST           S              6A                                                      CSW215
     D PCYCD           S              3A                                                      CSW215
     D PACCD           S              4A                                                      CSW215
     D PACSQ           S              2A                                                      CSW215
     D PNONB           S              2A                                                      CSW215
     D PBRCD           S              3A                                                      CSW215
     D PCSSN           S             10A                                                      CSW215
     D PPNOI           S              1A                                                      CSW215
      *                                                                                       CSW215
     D I2ACNT          DS            18                                                       CSW215
     D  I2CNUM                 1      6  0                                                    CSW215
     D  I2CCY                  7      9                                                       CSW215
     D  I2ACOD                10     13  0                                                    CSW215
     D  I2ACSQ                14     15  0                                                    CSW215
     D  I2BRCA                16     18                                                       CSW215
      *
      ** +--------------------------------------+
      ** ¦ /COPYs                               ¦
      ** ¦ ======                               ¦
      ** +--------------------------------------+
      *
      ** General constant fields
     D/COPY FTCPYSRC,SFTVALCSLE
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Initialise output parameters.
      *
     C                   MOVE      *Blank        PATyp3            1
     C                   MOVE      *Blank        PAcSt3            1
     C                   Z-ADD     *Zeros        PDAcO3            5 0
     C                   MOVEL     *Blanks       PPYFLDS
     C**********         MOVEL     *Blanks       PBNCDS           18                          CGL029
     C                   MOVE      *BLANKS       PBNCDS                                       CGL029
      ** Initialise variables for update of Valid File fields.
      *
     C                   MOVE      *Blank        WBNCT             1
      ** Initialise work variables.
      *
     C                   EVAL      Idx = 0
     C                   Eval      WFldNmXAr = *Blanks                                        240689
     C                   Eval      WMsgIDXAr  = *Blanks                                       240689
     C                   Eval      WMsgDtXAr = *Blanks                                        240689
     C                   Eval      WIx = 0                                                    240689
     C                   BITOFF    '01234567'    WRETB             1                          240689
      *
      ** Validate Beneficiary Customer
      *
     C                   EXSR      SRValBenC
      *                                                                                       CSW215
      ** Validate 59F format if CSW215 is installed                                           CSW215
      *                                                                                       CSW215
     C                   IF        CSW215 = 'Y'                                               CSW215
     C                             AND Idx = 0                                                CSW215
     C                   EXSR      VAL59F                                                     CSW215
     C                   ENDIF                                                                CSW215
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update Valid File fields.
      *
     C                   IF        OKBNC1 = 'N' or
     C                             OKBNC2 = 'N' or
     C                             OKBNC3 = 'N' or
     C                             OKBNC4 = 'N' or
     C                             OKBNC5 = 'N'
     C                   EVAL      RetCodeIn = 'ERROR'
     C                   ELSE
     C                   MOVE      DDBNC1        IPBNC1
     C                   MOVE      DDBNC2        IPBNC2
     C                   MOVE      DDBNC3        IPBNC3
     C                   MOVE      DDBNC4        IPBNC4
     C                   MOVE      DDBNC5        IPBNC5
     C                   MOVE      WBNCT         IPBNCT
     C                   IF        BJSBRC <> *BLANKS and
     C                             IPBNCT = 'P'
     C                   EVAL      %SUBST(IPBNC1:13:3) = BJSBRC
     C                   ENDIF
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALBENC - Validate Beneficiary Customer                    *
      *                                                               *
      *****************************************************************
     C     SRValBenC     BEGSR
      *
     C                   EVAL      W0BNC1 = DDBNC1
     C                   EVAL      W0BNC2 = DDBNC2
     C                   EVAL      W0BNC3 = DDBNC3
     C                   EVAL      W0BNC4 = DDBNC4
     C                   EVAL      W0BNC5 = DDBNC5
      *
      ** Check that DDBNC1 field does not contain '?' - error if it does
      *
     C                   MOVE      *Off          *IN18
     C     '?'           SCAN      DDBNC1                                 18
      *
     C                   IF        *IN18 = *On
     C                   IF        PMode = '*FRONT'
     C                   MOVE      'N'           OKBNC1
     C                   ADD       1             Idx
     C                   MOVEL     'DDBNC1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0123'     MsgIdXAr(Idx)
     C**********         MOVEL     DDBNC1        MsgDtaXAr(Idx)                             MD000091
     C                   EVAL      BLen = %Len(%Trim(DDBNC1))                               MD000091
     C                   EVAL      MsgDtaXAr(Idx) = LenStr +%TRIM(DDBNC1)                   MD000091
     C                   GOTO      ESRValBenC
     C                   ELSE
      *
      ** Standing Data enquiry processing is not allowed for
      ** this field.
     C                   MOVE      'N'           OKBNC1
     C                   ADD       1             Idx
     C                   MOVEL     'DDBNC1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0001'     MsgIdXAr(Idx)
     C                   GOTO      ESRValBenC
     C                   ENDIF
     C                   ENDIF
      *
      ** If only six characters entered see if client number
     C                   IF        BCR6 = *Blank
      *
      ** Check for numeric
     C**********         TESTN                   BCNUMA               01                      CSD027
     C**********         IF        *In01 = *On                                                CSD027
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *Blanks       PRtCd             7
     C                   PARM      '*KEY   '     POptn             7
     C                   PARM      BCNUMA        PKey1            10
     C                   PARM      *Blanks       PKySt             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C**********         If        PRtCd <> *Blanks or                                        CSD027
     C**********                   PKySt <> '*CNUM'                                           CSD027
     C                   If        PRtCd <> *Blanks                                           CSD027
     C                   If        BCR10 = *Blanks                                            CSD027
      *
      ** The beneficiary is not a valid customer shortname or
      ** customer number or S.W.I.F.T address.
     C                   MOVE      'N'           OKBNC1
     C                   ADD       1             Idx
     C                   MOVEL     'DDBNC1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0011'     MsgIdXAr(Idx)
     C                   Else                                                                 CSD027
     C                   GOTO      GASHORT                                                    CSD027
     C                   Endif                                                                CSD027
     C                   Else
     C                   MOVE      BBCUST        CNUM
     C                   MOVE      BBCSID        CSID             12
     C                   MOVE      BBCSSN        CSNM             10
     C**********         MOVE      BBBRCD        IPBRCA                                       227458
     C                   MOVE      BBBRCD        TBRCA             3                          227458
     C                   MOVE      'C'           WBNCT
     C                   If        PKySt =  '*CSHT'                                           CSD027
     C                   MOVE      *Blanks       DDBNC1                                       CSD027
     C                   MOVEL     CNUM          DDBNC1                                       CSD027
     C                   EndIf                                                                CSD027
     C                   EndIf
      *
     C                   GOTO      GA500
      *
     C**********         ENDIF                                                                CSD027
     C                   ENDIF
      *
      ** Check for blank beneficiary
      *
     C                   IF        BCR0 = *Blanks
      *
      ** Entry is mandatory, but no entry has been made.
     C                   MOVE      'N'           OKBNC1
     C                   ADD       1             Idx
     C                   MOVEL     'DDBNC1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0012'     MsgIdXAr(Idx)
     C                   GOTO      GA500
     C                   ENDIF
      *
      ** If only 10 characters entered, check for retail account No.
      ** or customer shortname
      *
     C                   IF        BCR10 = *Blanks
      *
     C                   TESTN                   BSNAM                01
     C                   IF        *In01 = *On
     C                   MOVE      BSNAM         ACNO
     C     ACNO          CHAIN     ACNUMABF                           89
      *
     C                   If        *IN89 = *On or
     C                             RECI <> 'D'
      *
      ** The entry is not a valid retail account.
     C                   MOVE      'N'           OKBNC1
     C                   ADD       1             Idx
     C                   MOVEL     'DDBNC1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0006'     MsgIdXAr(Idx)
     C                   Else
      *                                                                                     AR750736
      ** Check for block debits on account                                                  AR750736
      *                                                                                     AR750736
     C                   MOVE      ' '           BENEDrBlck                                 MD025111
     C                   MOVE      ' '           BENEDrRefd                                MD047369A
     C     DDADDC        IFEQ      'D'                                                      AR851079
     C                   TESTB     '2'           RETB                     52                AR750736
     C     *IN52         IFEQ      '1'                                                      AR750736
     C                   MOVE      'Y'           BENEDrBlck                                 MD025111
     C**********         MOVE      'N'           OKBNC1                            AR750736 MD025111
     C**********         ADD       1             Idx                               AR750736 MD025111
     C**********         MOVEL     'DDBNC1'      FldNamXAr(Idx)                    AR750736 MD025111
     C**********         MOVEL     'FTM7120'     MsgIdXAr(Idx)                    AR750736 AR1077987
     C**********         MOVEL     '5045879'     MsgIdXAr(Idx)                    AR1077987 MD025111
     C                   ENDIF                                                              AR750736
     C                   TESTB     '0'           RETB                     53                MD047369
     C     *IN53         IFEQ      '1'                                                      MD047369
     C**********         MOVE      'R'           BENEDrBlck                       MD047369 MD047369A
     C                   MOVE      'Y'           BENEDrRefd                                MD047369A
     C                   ENDIF                                                              MD047369
     C                   ENDIF                                                              AR750736
      * Check for block credits on account                                                   BUG4581
     C                   TESTB     '3'           RETB                     51                 BUG4581
     C                   If        *in51 = *ON                                               BUG4581
     C/COPY WNCPYSRC,FTH00518
     C**********         Move      'N'           OKBNC1                            BUG4581 MD034521A
     C**********         Add       1             Idx                               BUG4581 MD034521A
     C**********         Movel     'DDBNC1'      FldNamXAr(Idx)                    BUG4581 MD034521A
     C**********         Movel     'FTM0019'     MsgIdXAr(Idx)                     BUG4581 MD034521A
     C                   Move      'W'           OKBNC1                                    MD034521A
     C                   Add       1             WIx                                       MD034521A
     C                   Movel     'DDBNC1'      WFldNmXAr(WIx)                            MD034521A
     C                   Movel     'FTM0019'     WMsgIdXAr(WIx)                            MD034521A
     C/COPY WNCPYSRC,FTH00519
     C                   End                                                                 BUG4581
      *
      ** If Retail Accounts not allowed, Display error message
     C                   If        BMRANR <> 'Y'
      *
      ** Retail Accounts not allowed.
     C                   MOVE      'N'           OKBNC1
     C                   ADD       1             Idx
     C                   MOVEL     'DDBNC1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0007'     MsgIdXAr(Idx)
     C                   Else
      *
     C                   If        CCY <> DDPCCY
      *
      ** The retail account must be in pay currency.
     C                   MOVE      'N'           OKBNC1
     C                   ADD       1             Idx
     C                   MOVEL     'DDBNC1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0013'     MsgIdXAr(Idx)
     C                   Else
     C                   MOVE      'R'           WBNCT
     C                   EndIf
     C                   EndIf
     C                   EndIf
      *
     C                   GOTO      GA500
      *
     C                   ELSE
      *
     C     GASHORT       TAG                                                                  CSD027
     C                   MOVE      BSNAM         CSNM
      *
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *Blanks       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      CSNM          PKey1
     C                   PARM      *Blanks       PKySt
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C                   If        PRtCd = *Blanks and
     C                             PKySt = '*CSHT'
     C                   MOVE      BBCUST        CNUM
     C                   MOVE      BBCSID        CSID
     C                   MOVE      BBCSSN        CSNM
     C**********         MOVE      BBBRCD        IPBRCA                                       227458
     C                   MOVE      BBBRCD        TBRCA                                        227458
     C                   MOVE      *Blanks       DDBNC1
     C                   MOVEL     CNUM          DDBNC1
     C                   MOVE      'C'           WBNCT
     C                   GOTO      GA500
     C                   Else                                                                 CSD027
      *                                                                                       CSD027
      ** The beneficiary is not a valid customer shortname or                                 CSD027
      ** customer number or S.W.I.F.T address.                                                CSD027
     C                   MOVE      'N'           OKBNC1                                       CSD027
     C                   ADD       1             Idx                                          CSD027
     C                   MOVEL     'DDBNC1'      FldNamXAr(Idx)                               CSD027
     C                   MOVEL     'FTA0011'     MsgIdXAr(Idx)                                CSD027
     C                   EndIf
     C                   ENDIF
     C                   ENDIF
      *
      ** If only 12 Characters entered, SWIFT address
      ** single branch - partial A/c is 12 long
      ** multi branch - partial A/c is 15 long
      *
     C**********         IF        BCR12 = *Blanks and                                        CSD027
     C                   IF        BCR18 = *Blanks and                                        CSD027
     C                             BGMBIN = 'N' or
     C**********                   BCR15 = *Blanks and                                        CSD027
     C                             BCR21 = *Blanks and                                        CSD027
     C                             BGMBIN = 'Y'
      *
     C**********         TESTN                   BPART                01                      CSD027
     C**********         IF        *In01 = *On                                                CSD027
     C                   IF        BCR18 = *Blanks and                                        CSD027
     C                             BCR1318 <> *Blanks or                                      CSD027
     C                             BCR21 = *Blanks and                                        CSD027
     C                             BCR1321 <> *Blanks                                         CSD027
      *
     C**********         Z-ADD     BCNUM         KACNUM                                       CSD027
     C                   EVAL      KACNUM = BCNUM                                             CSD027
     C                   MOVE      DDPCCY        KACCCY
     C                   Z-ADD     BACOD         KACCD
     C                   Z-ADD     BACSQ         KACSQ
      *
     C                   If        BGMBIN = 'N'
     C                   MOVE      BJSBRC        KBRCA
     C                   Else
     C                   MOVE      BBRCA         KBRCA
     C                   EndIf
      *
     C     KAcKey        CHAIN     ACCNT                              89
      *
     C                   If        *IN89 = *On or
     C                             RECI <> 'D'
      *
      ** The field must contain one of:
      **      A ten digit retail account number
      **      A twelve character partial account identifier.
      **      A name and address of five lines of 35 characters.
      **      A customer shortname or customer number.
     C                   MOVE      'N'           OKBNC1
     C                   ADD       1             Idx
     C                   MOVEL     'DDBNC1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0014'     MsgIdXAr(Idx)
     C                   Else
      *                                                                                     AR750736
      ** Check for block debits on account                                                  AR750736
      *                                                                                     AR750736
     C                   MOVE      ' '           BENEDrBlck                                 MD025111
     C     DDADDC        IFEQ      'D'                                                      AR851079
     C                   TESTB     '2'           RETB                     52                AR750736
     C     *IN52         IFEQ      '1'                                                      AR750736
     C                   MOVE      'Y'           BENEDrBlck                                 MD025111
     C**********         MOVE      'N'           OKBNC1                            AR750736 MD025111
     C**********         ADD       1             Idx                               AR750736 MD025111
     C**********         MOVEL     'DDBNC1'      FldNamXAr(Idx)                    AR750736 MD025111
     C**********         MOVEL     'FTM7120'     MsgIdXAr(Idx)                    AR750736 AR1077987
     C**********         MOVEL     '5045879'     MsgIdXAr(Idx)                    AR1077987 MD025111
     C                   ENDIF                                                              AR750736
     C                   ENDIF                                                              AR750736
      * Check for block credits on account                                                   BUG4581
     C                   TESTB     '3'           RETB                     51                 BUG4581
     C                   If        *in51 = *ON                                               BUG4581
     C/COPY WNCPYSRC,FTH00520
     C**********         Move      'N'           OKBNC1                            BUG4581 MD034521A
     C**********         Add       1             Idx                               BUG4581 MD034521A
     C**********         Movel     'DDBNC1'      FldNamXAr(Idx)                    BUG4581 MD034521A
     C**********         Movel     'FTM0019'     MsgIdXAr(Idx)                     BUG4581 MD034521A
     C                   Move      'W'           OKBNC1                                    MD034521A
     C                   Add       1             WIx                                       MD034521A
     C                   Movel     'DDBNC1'      WFldNmXAr(WIx)                            MD034521A
     C                   Movel     'FTM0019'     WMsgIdXAr(WIx)                            MD034521A
     C/COPY WNCPYSRC,FTH00521
     C                   End                                                                 BUG4581
     C                   MOVE      'P'           WBNCT
     C                   EndIf
      *
     C                   GOTO      GA500
      *
     C                   ELSE
      *
     C                   MOVE      *Blanks       SW
     C                   MOVEA     DDBNC1        SW
      *
      ** Call SWIFT subroutine to check *ddress
     C                   MOVEL     *Blanks       CLSWTK
     C                   MOVEL     DDBNC1        CLSWTK
      *
     C                   EXSR      SWIFT
      *
      **  No SWIFT address record but format is valid
     C                   IF        ##CSID = 'Y'
      *                                                                                     MD034709
     C                   IF        Idx = 0                                                  MD034709
     C                   EVAL      Idx = 1                                                  MD034709
     C                   ENDIF                                                              MD034709
      *                                                                                     MD023025
      ** If SWIFT ID is the input, perform clearing of error message for the necessary      MD023025
      ** SWIFT ID validation error messages.                                                MD023025
      *                                                                                     MD023025
     C                   MOVE      'Y'           OKBNC1                                     MD023025
     C                   MOVEL     *BLANKS       FldNamXAr(Idx)                             MD023025
     C                   MOVEL     *BLANKS       MsgIdXAr(Idx)                              MD023025
     C                   SUB       1             Idx                                        MD023025
      *
     C                   If        ##CSID = 'Y' and
     C                             *IN31 = *On or
     C                             *IN32 = *On and
     C                             *IN31 = *Off
      *
      ** The beneficiary is not a valid customer shortname or
      ** customer number or S.W.I.F.T address.
     C                   MOVE      'N'           OKBNC1
     C                   ADD       1             Idx
     C                   MOVEL     'DDBNC1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0015'     MsgIdXAr(Idx)
     C                   Else
     C                   MOVE      'S'           WBNCT
     C                   EndIf
      *
     C                   GOTO      GA500
      *
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Check for / and second line is SWIFT
      *
     C                   IF        BCSL = '/' and
     C                             ##140 <> *Blanks and
     C                             ##129 = *Blanks
      *
      ** Call SWIFT subroutine to check address
     C                   MOVEL     *Blanks       CLSWTK           12
     C                   MOVEL     ##011         CLSWTK
      *
     C                   EXSR      SWIFT
                                                                                            AR901277
      ** SWIFT BIC exists in line 2 of beneficiary                                          AR901277
                                                                                            AR901277
     C                   IF        ##CSID = 'Y'                                             AR901277
     C                             and *IN31 = *OFF and *IN32 = *OFF                        AR901277
     C                   MOVE      'S'           WBNCT                                      AR901277
     C                   GOTO      GA500                                                    AR901277
     C                   EndIf                                                              AR901277
      *
      ***No*SWIFT*address*record*but*format*is*valid*******************                     AR901277
     C**********         IF        ##CSID = 'Y'                                             AR901277
      *
     C**********         If        ##CSID = 'Y' and                                         AR901277
     C**********                   *IN31 = *On or                                           AR901277
     C**********                   *IN32 = *On and                                          AR901277
     C**********                   *IN31 = *Off                                             AR901277
      *
      ***The*beneficiary*is*not*a*valid*customer*shortname*or**********                     AR901277
      ***customer*number*or*S.W.I.F.T*address.*************************                     AR901277
     C**********         MOVE      'N'           OKBNC1                                     AR901277
     C**********         ADD       1             Idx                                        AR901277
     C**********         MOVEL     'DDBNC1'      FldNamXAr(Idx)                             AR901277
     C**********         MOVEL     'FTA0015'     MsgIdXAr(Idx)                              AR901277
     C**********         Else                                                               AR901277
     C**********         MOVE      'S'           WBNCT                                      AR901277
     C**********         GOTO      GA500                                                    AR901277
     C**********         EndIf                                                              AR901277
      *
     C**********         ENDIF                                                              AR901277
      *
     C                   ENDIF
      *
      ** IBAN
      ** If beneficiary start with '/aann' or 'aann'
      ** validate as an IBAN (INTERNATIONAL BANK ACCOUNT NUMBER)
      ** having first formatted field removing blanks and IBAN prefix
      *
     C                   IF        CFT004 = 'Y'

     C                   MOVEL     *BLANK        PIBAN                                      AR920574
     C                   IF        BCSL = '/'
     C     34            SUBST     DDBNC1:2      PIBAN
     C                   ELSE
     C                   MOVEL     DDBNC1        PIBAN
     C                   ENDIF

     C                   CALL      'AOIBANR3'
     C                   PARM                    PRTCD
     C                   PARM                    PIBAN            47
     C                   PARM                    POWITH           47
     C     P@IBAN        PARM                    PONOBL           34

     C     1             SUBST     P@IBAN:1      BCTY1             1
     C     1             SUBST     P@IBAN:2      BCTY2             1
     C     1             SUBST     P@IBAN:3      BDGT1             1
     C     1             SUBST     P@IBAN:4      BDGT2             1
     C     BCTY1         LOOKUP    ALPH                                   94
     C   94BCTY2         LOOKUP    ALPH                                   94
     C   94BDGT1         LOOKUP    NUMC                                   94
     C   94BDGT2         LOOKUP    NUMC                                   94
      *
      ** Check that it is a valid IBAN
     C                   IF        *IN94 = *ON
     C                   MOVE      *BLANKS       DSSDY
     C                   CALL      'AOIBANR2'
     C                   PARM                    PRTCD
     C                   PARM                    P@IBAN           34
     C     P@ACCN        PARM                    DSSDY
      *
      ** Invalid country
     C                   IF        PRTCD = '      1'
     C                   MOVE      'N'           OKBNC1
     C                   ADD       1             Idx
     C                   MOVEL     'DDBNC1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0125'     MsgIdXAr(Idx)
     C                   GOTO      GA500
     C                   ENDIF
      *
      ** Invalid BBAN length on country file
     C                   IF        PRTCD = '      2'
     C                   MOVE      'N'           OKBNC1
     C                   ADD       1             Idx
     C                   MOVEL     'DDBNC1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0126'     MsgIdXAr(Idx)
     C                   GOTO      GA500
     C                   ENDIF
      *
      ** IBAN contains invalid characters
     C                   IF        PRTCD = '      3'
     C                   MOVE      'N'           OKBNC1
     C                   ADD       1             Idx
     C                   MOVEL     'DDBNC1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0127'     MsgIdXAr(Idx)
     C                   GOTO      GA500
     C                   ENDIF
      *
      ** IBAN length of BBAN is incorrect
     C                   IF        PRTCD = '      4'
     C                   MOVE      'N'           OKBNC1
     C                   ADD       1             Idx
     C                   MOVEL     'DDBNC1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0128'     MsgIdXAr(Idx)
     C                   GOTO      GA500
     C                   ENDIF
      *
      ** Checks Digits are not corrects
     C                   IF        PRTCD = '      5'
     C                   MOVE      'N'           OKBNC1
     C                   ADD       1             Idx
     C                   MOVEL     'DDBNC1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0129'     MsgIdXAr(Idx)
     C                   GOTO      GA500
     C                   ENDIF
      *
      ** Valid IBAN but not on the system, Process as Customer name and
      ** Address field
     C                   IF        PRTCD = '      6'
     C                   MOVE      'A'           WBNCT
     C                   GOTO      GA500
     C                   ENDIF
      *                                                                                       259240
     C*****ACNO*         CHAIN     ACNUMABF                           90             259240 MD033530
      ** If Retail Number is not used, validation will always fail. Use full account        MD033530
      ** instead.                                                                           MD033530
     C                   EVAL      KACNUM = IBCNUM                                          MD033530
     C                   EVAL      KACCCY = CCY                                             MD033530
     C                   EVAL      KACCD  = IBACOD                                          MD033530
     C                   EVAL      KACSQ  = IBACSQ                                          MD033530
     C                   EVAL      KBRCA  = IBBRCA                                          MD033530
      *                                                                                     MD033530
     C     KAcKey        CHAIN     ACCNT                              90                    MD033530
      *                                                                                       259240
      ** The entry is attached to an inactive retail account                                  259240
     C                   IF        *IN90 = *On or                                             259240
     C                             RECI <> 'D'                                                259240
     C                             or ATYP <> 'R'                                           MD033530
     C                   MOVE      'N'           OKBNC1                                       259240
     C                   ADD       1             Idx                                          259240
     C                   MOVEL     'DDBNC1'      FldNamXAr(Idx)                               259240
     C                   MOVEL     'FTM2036'     MsgIdXAr(Idx)                                259240
     C                   GOTO      GA500                                                      259240
     C                   ENDIF                                                                259240
      *
      ** Check if Account Currency matchs with the pay currency
     C                   IF        PRTCD = *BLANKS
     C                   IF        CCY = DDPCCY
     C     '/'           CAT       P@IBAN        DDBNC1
     C**********         Z-ADD     IBCNUM        PIBCNUM                                      CSD027
     C                   EVAL      PIBCNUM = IBCNUM                                           CSD027
     C                   Z-ADD     IBACOD        PIBACOD
     C                   Z-ADD     IBACSQ        PIBACSQ
     C                   Z-ADD     IBLCD         LCD
     C                   MOVE      IBBRCA        PIBBRCA
     C                   MOVE      CCY           PIBCCY
     C                   MOVE      'I'           WBNCT
     C                   GOTO      GA500
     C                   ELSE
     C                   MOVE      'N'           OKBNC1
     C                   ADD       1             Idx
     C                   MOVEL     'DDBNC1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0130'     MsgIdXAr(Idx)
     C                   GOTO      GA500
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
      *
      ** If more than one field is entered, validate as an address
      ** also check first line for more than 12 characters
      *
     C                   MOVE      DDBNC1        WA23             23
      *
     C                   IF        WA23 <> *Blanks or
      *
     C                             DDBNC1 <> *Blanks and
     C                             DDBNC2 <> *Blanks or
     C                             DDBNC1 <> *Blanks and
     C                             DDBNC3 <> *Blanks or
     C                             DDBNC1 <> *Blanks and
     C                             DDBNC4 <> *Blanks or
     C                             DDBNC1 <> *Blanks and
     C                             DDBNC5 <> *Blanks or
      *
     C                             DDBNC2 <> *Blanks and
     C                             DDBNC3 <> *Blanks or
     C                             DDBNC2 <> *Blanks and
     C                             DDBNC4 <> *Blanks or
     C                             DDBNC2 <> *Blanks and
     C                             DDBNC5 <> *Blanks or
      *
     C                             DDBNC3 <> *Blanks and
     C                             DDBNC4 <> *Blanks or
     C                             DDBNC3 <> *Blanks and
     C                             DDBNC5 <> *Blanks or
      *
     C                             DDBNC4 <> *Blanks and
     C                             DDBNC5 <> *Blanks
      *
     C                   MOVE      *Blanks       Address
      *
     C                   MOVEL     DDBNC1        AdChk1
     C                   MOVEL     DDBNC2        AdChk2
     C                   MOVEL     DDBNC3        AdChk3
     C                   MOVEL     DDBNC4        AdChk4
     C                   MOVEL     DDBNC5        AdChk5
      *
     C                   MOVE      'A'           WBNCT
      *
     C                   EXSR      SRAdCheck
      *
     C                   ELSE
      *
      ** If a line is blank, all subsequent lines must be blank.
      *
     C                   If        DDBNC1 <> *Blanks and                                      BUG370
     C                             DDBNC2 = *Blanks and                                       BUG370
     C                             DDBNC3 = *Blanks and                                       BUG370
     C                             DDBNC4 = *Blanks and                                       BUG370
     C                             DDBNC5 = *Blanks                                           BUG370
      ** Allow first line to be non blank and all other lines blanks                          BUG370
      *                                                                                       BUG370
     C                   Else                                                                 BUG370
     C                   MOVE      'N'           OKBNC1
     C                   MOVE      'N'           OKBNC2
     C                   MOVE      'N'           OKBNC3
     C                   MOVE      'N'           OKBNC4
     C                   MOVE      'N'           OKBNC5
     C                   ADD       1             Idx
     C                   MOVEL     'DDBNC1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0016'     MsgIdXAr(Idx)
     C                   EndIf                                                                BUG370
     C                   ENDIF
      *
      **     i.e. Begins with '/'
      *
     C                   IF        DDBNC5 <> *Blanks and
     C                             BCSL <> '/'
      *
      ** Entry is mandatory, but no entry has been made.
     C                   MOVE      'N'           OKBNC1
     C                   ADD       1             Idx
     C                   MOVEL     'DDBNC1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0012'     MsgIdXAr(Idx)
     C                   ENDIF
      *
     C                   IF        OKBNC1 = 'Y' or
     C                             OKBNC2 = 'Y' or
     C                             OKBNC3 = 'Y' or
     C                             OKBNC4 = 'Y' or
     C                             OKBNC5 = 'Y'
     C                   MOVE      'A'           WBNCT
     C                   ENDIF
      *
      *          *****     ***
     C     GA500         TAG
      *          *****     ***
      *
      ** If a valid account has been entered store the account type and
      ** the date the account was opened.
      *
     C**********         IF        OKBNC1 = 'Y' and                                         MD039547
     C**********                   OKBNC2 = 'Y' and                                         MD039547
     C**********                   OKBNC3 = 'Y' and                                         MD039547
     C**********                   OKBNC4 = 'Y' and                                         MD039547
     C**********                   OKBNC5 = 'Y'                                             MD039547
     C                   IF        OKBNC1 <> 'N' and                                        MD039547
     C                             OKBNC2 <> 'N' and                                        MD039547
     C                             OKBNC3 <> 'N' and                                        MD039547
     C                             OKBNC4 <> 'N' and                                        MD039547
     C                             OKBNC5 <> 'N'                                            MD039547
      *
     C                   If        WBNCT = 'R' or
     C                             WBNCT = 'P' or
     C                             WBNCT = 'I' and CFT004 = 'Y'
      *
     C                   MOVE      ATYP          PATyp3
     C                   MOVE      ACST          PAcSt3
     C                   Z-ADD     DACO          PDAcO3
      *
      ** Store full account details for FT Transaction Status File
      ** record update.
     C**********         Z-ADD     CNUM          IMCNUM                                       CSD027
     C                   EVAL      IMCNUM = CNUM                                              CSD027
     C                   MOVE      CCY           IMCCY
     C                   Z-ADD     ACOD          IMACOD
     C                   Z-ADD     ACSQ          IMACSQ
     C                   MOVE      BRCA          IMBRCA
     C                   MOVEL     IMACNT        PBNCDS
      *
      ** Also save fields needed to set default pay value date
      *
     C                   MOVEL     CNUM          CNUMPY
     C                   MOVEL     CCY           CCYPY
     C                   MOVEL     ACOD          ACODPY
     C                   MOVEL     ACSQ          ACSQPY
     C                   MOVEL     BRCA          BRCAPY
      *                                                                                       240689
      ** Check Status of Account                                                              240689
      *                                                                                       240689
     C     DDACBK        IFEQ      *BLANKS                                                    240689
      *                                                                                       240689
     C                   MOVE      RETB          WRETB                                        240689
      *                                                                                       240689
      ** Bankrupt/Liquidated                                                                  240689
      *                                                                                       240689
     C                   TESTB     '6'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C                   MOVE      'N'           OKBNC1                                       240689
     C                   ADD       1             Idx                                          240689
     C                   MOVEL     'DDBNC1'      FldNamXAr(Idx)                               240689
     C                   MOVEL     'FTM0015'     MsgIdXAr(Idx)                                240689
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Bad Debt                                                                             240689
      *                                                                                       240689
     C                   TESTB     '7'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C                   MOVE      'N'           OKBNC1                                       240689
     C                   ADD       1             Idx                                          240689
     C                   MOVEL     'DDBNC1'      FldNamXAr(Idx)                               240689
     C                   MOVEL     'FTM0016'     MsgIdXAr(Idx)                                240689
     C                   ENDIF                                                                240689
      *                                                                                       240689
      ** Inactive                                                                             240689
      *                                                                                       240689
     C**********         TESTB     '4'           WRETB                    48           240689 259576
     C******IN48         IFEQ      '1'                                                 240689 259576
     C**********         MOVE      'N'           OKBNC1                                       240689
     C*****OKBNC1        IFNE      'N'                                                 240689 259576
     C**********         MOVE      'W'           OKBNC1                                240689 259576
     C**********         ENDIF                                                         240689 259576
     C**********         ADD       1             WIx                                   240689 259576
     C**********         MOVEL     'DDBNC1'      WFldNmXAr(WIx)                        240689 259576
     C**********         MOVEL     'FTM0017'     WMsgIdXAr(WIx)                        240689 259576
     C**********         ENDIF                                                         240689 259576
      *                                                                                       240689
      ** Referred Credit                                                                      240689
      *                                                                                       240689
     C                   TESTB     '1'           WRETB                    48                  240689
     C     *IN48         IFEQ      '1'                                                        240689
     C**********         MOVE      'N'           OKBNC1                                       240689
     C     OKBNC1        IFNE      'N'                                                        240689
     C                   MOVE      'W'           OKBNC1                                       240689
     C                   ENDIF                                                                240689
     C                   ADD       1             WIx                                          240689
     C                   MOVEL     'DDBNC1'      WFldNmXAr(WIx)                               240689
     C                   MOVEL     'FTM0020'     WMsgIdXAr(WIx)                               240689
     C                   ENDIF                                                                240689
      *                                                                                       240689
     C                   ENDIF                                                                240689
      *                                                                                       240689
     C                   EndIf
      *
     C                   ENDIF
      *
     C     ESRValBenC    ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRADCHECK - Validate Address Fields                          *
      *                                                               *
      *****************************************************************
     C     SRAdCheck     BEGSR
      *
      ** There should be no embedded spaces
      *
     C                   IF        AdChk1 = *Blanks and
     C                             AdChk2 <> *Blanks or
     C                             AdChk1 = *Blanks and
     C                             AdChk3 <> *Blanks or
     C                             AdChk1 = *Blanks and
     C                             AdChk4 <> *Blanks or
      *
     C                             AdChk2 = *Blanks and
     C                             AdChk3 <> *Blanks or
     C                             AdChk2 = *Blanks and
     C                             AdChk4 <> *Blanks or
      *
     C                             AdChk3 = *Blanks and
     C                             AdChk4 <> *Blanks or
      *
     C                             AdChk4 = *Blanks and
     C                             AdChk5 <> *Blanks
      *
      ** If a line is blank, all subsequent lines must be blank.
     C                   MOVE      'N'           OKBNC1
     C                   MOVE      'N'           OKBNC2
     C                   MOVE      'N'           OKBNC3
     C                   MOVE      'N'           OKBNC4
     C                   MOVE      'N'           OKBNC5
     C                   ADD       1             Idx
     C                   MOVEL     'DDBNC1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0016'     MsgIdXAr(Idx)
      *
     C                   ENDIF
      *
      ** Check for non-valid SWIFT characters
      *
     C                   IF        AdChk1 <> *Blanks
     C                   MOVEA     *Blanks       WFld
     C                   MOVE      AdChk1        WFld
     C                   EXSR      SRSWSET
     C                   If        WError = 'Y'
      *
      ** The first field contains non-S.W.I.F.T. characters.
     C                   MOVE      'N'           OKBNC1
     C                   MOVE      'N'           OKBNC2
     C                   MOVE      'N'           OKBNC3
     C                   MOVE      'N'           OKBNC4
     C                   MOVE      'N'           OKBNC5
     C                   ADD       1             Idx
     C                   MOVEL     'DDBNC1'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0017'     MsgIdXAr(Idx)
     C                   EndIf
     C                   ENDIF
      *
     C                   IF        AdChk2 <> *Blanks
     C                   MOVEA     *Blanks       WFld
     C                   MOVE      AdChk2        WFld
     C                   EXSR      SRSWSET
     C                   If        WError = 'Y'
      *
      ** The second field contains non-S.W.I.F.T. characters.
     C                   MOVE      'N'           OKBNC2
     C                   MOVE      'N'           OKBNC1
     C                   MOVE      'N'           OKBNC3
     C                   MOVE      'N'           OKBNC4
     C                   MOVE      'N'           OKBNC5
     C                   ADD       1             Idx
     C                   MOVEL     'DDBNC2'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0018'     MsgIdXAr(Idx)
     C                   EndIf
     C                   ENDIF
      *
     C                   IF        AdChk3 <> *Blanks
     C                   MOVEA     *Blanks       WFld
     C                   MOVE      AdChk3        WFld
     C                   EXSR      SRSWSET
     C                   If        WError = 'Y'
      *
      ** The third field contains non-S.W.I.F.T. characters.
     C                   MOVE      'N'           OKBNC3
     C                   MOVE      'N'           OKBNC2
     C                   MOVE      'N'           OKBNC1
     C                   MOVE      'N'           OKBNC4
     C                   MOVE      'N'           OKBNC5
     C                   ADD       1             Idx
     C                   MOVEL     'DDBNC3'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0019'     MsgIdXAr(Idx)
     C                   EndIf
     C                   ENDIF
      *
     C                   IF        AdChk4 <> *Blanks
     C                   MOVEA     *Blanks       WFld
     C                   MOVE      AdChk4        WFld
     C                   EXSR      SRSWSET
     C                   If        WError = 'Y'
      *
      ** The fourth field contains non-S.W.I.F.T. characters.
     C                   MOVE      'N'           OKBNC4
     C                   MOVE      'N'           OKBNC3
     C                   MOVE      'N'           OKBNC2
     C                   MOVE      'N'           OKBNC1
     C                   MOVE      'N'           OKBNC5
     C                   ADD       1             Idx
     C                   MOVEL     'DDBNC4'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0020'     MsgIdXAr(Idx)
     C                   EndIf
     C                   ENDIF
      *
     C                   IF        AdChk5 <> *Blanks
     C                   MOVEA     *Blanks       WFld
     C                   MOVE      AdChk5        WFld
     C                   EXSR      SRSWSET
     C                   If        WError = 'Y'
      *
      ** The fifth field contains non-S.W.I.F.T. characters.
     C                   MOVE      'N'           OKBNC5
     C                   MOVE      'N'           OKBNC4
     C                   MOVE      'N'           OKBNC3
     C                   MOVE      'N'           OKBNC2
     C                   MOVE      'N'           OKBNC1
     C                   ADD       1             Idx
     C                   MOVEL     'DDBNC4'      FldNamXAr(Idx)
     C                   MOVEL     'FTA0021'     MsgIdXAr(Idx)
     C                   EndIf
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSWSET - Check for valid SWIFT Character used.              *
      *                                                               *
      *****************************************************************
     C     SRSWSET       BEGSR
      *
     C                   MOVE      *BLANK        WError            1
     C                   MOVE      *On           *In94
      *
     C                   IF        WFld(1) <> *BLANK
      *
     C                   MOVEA     *Blanks       WTst
     C                   MOVEA     WFld          WTst
     C                   Z-ADD     1             Qx                5 0
      *
     C                   DOW       Qx <= 35
      *
     C                   IF        WTst(Qx) <> ' '
     C     WTst(Qx)      LOOKUP    SWCH                                   94
     C                   If        *In94 = *Off
     C                   MOVE      'Y'           WError
     C                   GOTO      ESRSWSET
     C                   EndIf
     C                   ENDIF
      *
     C                   ADD       1             Qx
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C     ESRSWSET      ENDSR
      ************************************************************                            CSW215
      /EJECT                                                                                  CSW215
      ************************************************************                            CSW215
      *                                                          *                            CSW215
      *  VAL59F - Validation of Beneficiary 59F Format           *                            CSW215
      *                                                          *                            CSW215
      ************************************************************                            CSW215
      *                                                                                       CSW215
     C     VAL59F        BEGSR                                                                CSW215
      *                                                                                       CSW215
     C                   MOVEL     PDBACT        I2ACNT                                       CSW215
     C                   MOVEL     I2CNUM        PCUST                                        CSW215
     C                   MOVEL     I2CCY         PCYCD                                        CSW215
     C                   MOVEL     I2ACOD        PACCD                                        CSW215
     C                   MOVEL     I2ACSQ        PACSQ                                        CSW215
     C                   MOVEL     I2BRCA        PBRCD                                        CSW215
      *                                                                                       CSW215
      ** Check if entry is an existing nostro identifier                                      CSW215
      *                                                                                       CSW215
     C                   CALL      'AONOSTR0'                                                 CSW215
     C                   PARM      *BLANKS       PRTCD                                        CSW215
     C                   PARM      '*KEY   '     POptn                                        CSW215
     C                   PARM                    PCUST                                        CSW215
     C                   PARM                    PCYCD                                        CSW215
     C                   PARM                    PACCD                                        CSW215
     C                   PARM                    PACSQ                                        CSW215
     C                   PARM      *BLANKS       PNONB                                        CSW215
     C                   PARM                    PBRCD                                        CSW215
     C                   PARM      *BLANKS       PCSSN                                        CSW215
     C                   PARM      *BLANKS       PPNOI                                        CSW215
     C     SDNOST        PARM      *BLANKS       DSFDY                                        CSW215
      *                                                                                       CSW215
     C                   IF        PRTCD <> *BLANKS                                           CSW215
     C                   MOVEL     *BLANKS       A7NONB                                       CSW215
     C                   MOVEL     *BLANKS       A7CYCD                                       CSW215
     C                   ENDIF                                                                CSW215
      *                                                                                       CSW215
      ** Get Country of location                                                              CSW215
      *                                                                                       CSW215
     C                   IF        IPSNTP = 'S'                                               CSW215
     C                   EVAL      PCnty  = %Subst(IPSND1:5:2)                                CSW215
     C                   ELSE                                                                 CSW215
      *                                                                                       CSW215
     C                   IF        IPSNTP = 'A'                                               CSW215
     C                   EVAL      PCnty  = *BLANKS                                           CSW215
     C                   ELSE                                                                 CSW215
      *                                                                                       CSW215
     C                   CALL      'AOACCTV1'                                                 CSW215
     C                   PARM      *BLANKS       PRTCD                                        CSW215
     C                   PARM      *BLANKS       PAType                                       CSW215
     C                   PARM      IPSND1        ParmStr                                      CSW215
     C                   PARM      *BLANKS       DSSDY                                        CSW215
      *                                                                                       CSW215
     C                   SELECT                                                               CSW215
     C                   WHEN      PAType = '*RETAIL'                                         CSW215
     C                             OR PAType = '*LEDGER'                                      CSW215
     C                   EVAL      P@ACCN  = DSSDY                                            CSW215
     C                   EVAL      WCnum   = IBCNUM                                           CSW215
      *                                                                                       CSW215
     C                   WHEN      PAType = '*NOSTRO'                                         CSW215
     C                   EVAL      SDNOST = DSSDY                                             CSW215
     C                   MOVE      A7CUST        WCNum                                        CSW215
      *                                                                                       CSW215
     C                   WHEN      PAType = '*CUSTNO'                                         CSW215
     C                             OR PAType = '*SHNAME'                                      CSW215
     C                   EVAL      SDCUST = DSSDY                                             CSW215
     C                   MOVE      BBCUST        WCNum                                        CSW215
     C                   ENDSL                                                                CSW215
      *                                                                                       CSW215
     C                   MOVEL     WCNum         WCust                                        CSW215
     C                   CALL      'AOCUSTR0'                                                 CSW215
     C                   PARM      *BLANKS       PRTCD                                        CSW215
     C                   PARM      '*KEY   '     POptn                                        CSW215
     C                   PARM      WCust         PKey1                                        CSW215
     C                   PARM      *BLANKS       PKyst                                        CSW215
     C     SDCUST        Parm      SDCUST        DSSDY                                        CSW215
      *                                                                                       CSW215
     C                   IF        PRTCD = *BLANKS                                            CSW215
     C                   EVAL      PCnty = BBCOLC                                             CSW215
     C                   ENDIF                                                                CSW215
      *                                                                                       CSW215
     C                   ENDIF                                                                CSW215
     C                   ENDIF                                                                CSW215
      *                                                                                       CSW215
      ** Get currency                                                                         CSW215
      *                                                                                       CSW215
     C                   IF        PCYCD <> *BLANKS                                           CSW215
     C                   EVAL      PCurr = A7CYCD                                             CSW215
     C                   ELSE                                                                 CSW215
     C                   EVAL      PCurr = IPSMCY                                             CSW215
     C                   ENDIF                                                                CSW215
      *                                                                                       CSW215
      ** Get nostro code                                                                      CSW215
      *                                                                                       CSW215
     C                   IF        A7NONB <> *BLANKS                                          CSW215
     C                   EVAL      PNost = A7NONB                                             CSW215
     C                   ELSE                                                                 CSW215
     C                   EVAL      PNost = *BLANKS                                            CSW215
     C                   ENDIF                                                                CSW215
      *                                                                                       CSW215
     C                   CALL      'MG001001'                                                 CSW215
      **Return Code                                                                           CSW215
     C                   PARM      *BLANKS       PRTCD                                        CSW215
      **Validation Type                                                                       CSW215
     C                   PARM      'TRAN'        PValTyp                                      CSW215
      **5X35 lines to be checked                                                              CSW215
     C                   PARM                    DDBNC1                                       CSW215
     C                   PARM                    DDBNC2                                       CSW215
     C                   PARM                    DDBNC3                                       CSW215
     C                   PARM                    DDBNC4                                       CSW215
     C                   PARM                    DDBNC5                                       CSW215
      ** Network                                                                              CSW215
     C                   PARM      'SWIFT'       PNwrk                                        CSW215
      ** Message Type                                                                         CSW215
     C                   PARM      '103'         PMsgTp                                       CSW215
      ** Message Tag                                                                          CSW215
     C                   PARM      ':59F:'       PMsgTg                                       CSW215
      ** Branch Code                                                                          CSW215
     C                   PARM      IPBRCA        PBrch                                        CSW215
      ** Country of Location                                                                  CSW215
     C                   PARM                    PCnty                                        CSW215
      ** Currency Code                                                                        CSW215
     C                   PARM                    PCurr                                        CSW215
      ** Nostro                                                                               CSW215
     C                   PARM                    PNost                                        CSW215
      ** 5X35 lines to be output                                                              CSW215
     C                   PARM      *BLANKS       POut1                                        CSW215
     C                   PARM      *BLANKS       POut2                                        CSW215
     C                   PARM      *BLANKS       POut3                                        CSW215
     C                   PARM      *BLANKS       POut4                                        CSW215
     C                   PARM      *BLANKS       POut5                                        CSW215
      ** Message ID Field                                                                     CSW215
     C                   PARM      *BLANKS       PMsgId                                       CSW215
      ** Error Type                                                                           CSW215
     C                   PARM      *BLANKS       PErrTyp                                      CSW215
      *                                                                                       CSW215
     C                   IF        PErrTyp = 'E'                                              CSW215
     C                   EVAL      Idx = Idx + 1                                              CSW215
     C                   EVAL      RetCodeIn = 'Error'                                        CSW215
     C                   EVAL      MsgIdXAr(Idx) = PMsgId                                     CSW215
     C                   EVAL      FldNamXAr(Idx) = 'DDBNC1'                                  CSW215
     C                   EVAL      OKBNC1    = 'N'                                            CSW215
     C                   EVAL      OKBNC2    = 'N'                                            CSW215
     C                   EVAL      OKBNC3    = 'N'                                            CSW215
     C                   EVAL      OKBNC4    = 'N'                                            CSW215
     C                   EVAL      OKBNC5    = 'N'                                            CSW215
     C                   ENDIF                                                                CSW215
      *                                                                                       CSW215
     C                   IF        PErrTyp = 'W'                                              CSW215
     C                   EVAL      WIx = WIx + 1                                              CSW215
     C                   EVAL      OKBNC1    = 'W'                                            CSW215
     C                   EVAL      OKBNC2    = 'W'                                            CSW215
     C                   EVAL      OKBNC3    = 'W'                                            CSW215
     C                   EVAL      OKBNC4    = 'W'                                            CSW215
     C                   EVAL      OKBNC5    = 'W'                                            CSW215
     C                   EVAL      WFldNmXAr(WIx) = 'DDBNC1'                                  CSW215
     C                   EVAL      WMsgIdXAr(WIx) = PMsgId                                    CSW215
      *                                                                                       CSW215
     C                   IF        PMsgId = 'ME00329'                                         CSW215
     C                   EVAL      WMsgDtXAr(WIx) = PNWRK                                     CSW215
     C                   ELSEIF    PMsgId = 'ME00330'                                         CSW215
     C                   EVAL      WMsgDtXAr(WIx) = PMsgTg                                    CSW215
     C                   ENDIF                                                                CSW215
      *                                                                                       CSW215
     C                   ENDIF                                                                CSW215
      *                                                                                       CSW215
     C                   ENDSR                                                                CSW215
      *
      *****************************************************************
      /EJECT
     C/COPY FTCPYSRC,SFTSWFTCLE
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*SIN  ' (SCREEN INPUT function)
     C                   PARM                    PMode             6
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Multi-Branching Indicator
     C                   PARM                    BGMBIN            1
      *
      ** SDMMOD - Retail Banking Indicator
     C                   PARM                    BGRTBN            1
      *
      ** SDRETL - Retail Account required ?
     C                   PARM                    BMRANR            1
      *
      ** SDBANK - Banks Detail
     C                   PARM                    BJSBRC            3
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** IBAN numbers
     C                   PARM                    CFT004            1
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
                                                                                              240689
     C                   Parm                    WFldNmXAr                                    240689
     C                   Parm                    WMsgIDXAr                                    240689
     C                   Parm                    WMsgDtXAr                                    240689
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Beneficiary Customer's Account Type
     C                   PARM                    PAtyp3
      *
      ** Beneficiary Customer's Account Status
     C                   PARM                    PAcSt3
      *
      ** Beneficiary Customer's Date Account Opened
     C                   PARM                    PDAcO3
      *
      ** Beneficiary Customer's Full Account
     C                   PARM                    PBNCDS
      *
      ** IBANs full account
     C                   PARM                    PIBANAcc
      *
      ** Account needed to set payment value date
     C                   PARM                    PPYFLDS
     C                   PARM                    BENEDrBlck                                 MD025111
     C                   PARM                    BENEDrRefd                                MD047369A
      *                                                                                       CSW215
      ** Debit Account                                                                        CSW215
     C                   PARM                    PDBACT                                       CSW215
      *                                                                                       CSW215
      ** SWIFT 2015 Indicator                                                                 CSW215
     C                   PARM                    CSW215                                       CSW215
     C/COPY WNCPYSRC,FTH00522
      *
     C     KAcKey        KLIST
     C**********         KFLD                    KACNUM            6 0                        CSD027
     C                   KFLD                    KACNUM            6                          CSD027
     C                   KFLD                    KACCCY            3
     C**********         KFLD                    KACCD             4 0                        CGL029
     C                   KFLD                    KACCD                                        CGL029
     C                   KFLD                    KACSQ             2 0
     C                   KFLD                    KBRCA             3
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Amend CTDATA SWCH                                                                  BUG24378
      ** Previous data:                                                                     BUG24378
      ** ABCDEABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz 1234567890/-?:().,'+     BUG24378
      *                                                                                     BUG24378
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA SWCH
ABCDEFGHIJKLMNOPQRSTUVWXYZ 1234567890/-?:().,'+abcdefghijklmnopqrstuvwxyz                     255286
**CTDATA ALPH
ABCDEFGHIJKLMNOPQRSTUVWXYZ
**CTDATA NUMC
1234567890
