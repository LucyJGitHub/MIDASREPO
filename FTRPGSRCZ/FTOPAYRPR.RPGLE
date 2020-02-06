     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Invalid outgoing payments repair')            *
      *****************************************************************
      *                                                               *
      *  Midas - API Funds Transfer Module                            *
      *                                                               *
      *  FTOPAYRPR - Outgoing Payments Invalid transaction Repair     *
      *                                                               *
      *  Function:  This function allows invalid outgoing payments to *
      *             be 'repaired' and applied to the Midas database.  *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1090283          Date 10Aug16               *
      *                 CFT151             Date 21Mar14               *
      *                 MD022652           Date 07Oct13               *
      *                 258944             Date 23Jan13               *
      *                 CFT148             Date 23Jan13               *
      *                 CFT120             Date 28Sep12               *
      *                 CAP211             Date 28Sep12               *
      *                 CFT039             Date 28Sep12               *
      *                 CSC054             Date 23Feb12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR787620           Date 10Jun11               *
      *                 CRE067             Date 05Oct10               *
      *                 BUG26775           Date 27Nov09               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG26548           Date 23Oct09               *
      *                 CSW209             Date 01Apr09               *
      *                 257361             Date 10Nov08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 250600             Date 07Oct07               *
      *                 249652             Date 09Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 GBO009             Date 14Aug06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 220110             Date 06Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9075            Date 06Aug05               *
      *                 BUG9074            Date 06Aug05               *
      *                 CER001             Date 25Apr05               *
      *                 BUG7319            Date 23Sep05               *
      *                 CSC024             Date 07Feb05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4776R (Reopen)  Date 22Dec04               *
      *                 BUG4776            Date 15Nov04               *
      *                 CFT118             Date 02Sep04               *
      *                 CFT116             Date 12Jul04               *
      *                 CGL014             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 30Oct03               *
      *                 CGP001             Date 16Oct03               *
      *                 CAP084             Date 18Jul03               *
      *                 CSW203             Date 26May03               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 207404             Date 09Jan03               *
      *                 207329             Date 07Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 204029             Date 26Apr02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 200149             Date 15Nov01               *
      *                 CSC011             Date 18Sep01               *
      *                 193883             Date 20Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      *                 190845             Date 21Mar01               *
      *                 CPB002             Date 13Sep00               *
      *                 187413             Date 13Sep00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 187056             Date 01Dec00               *
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 23May00               *
      *                 CFT007             Date 03Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP011             Date 23Dec99               *
      *                 CPB001             Date 23Aug99               *
      *                 CAP014             Date 08Dec99               *
      *                 CAP013             Date 22Nov99               *
      *                 CFT004             Date 22Nov99               *
      *                 CAP031  *CREATE    Date 08Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1090283 - Customer details not visible for enquire.        *
      *              (Child: AR1090284)                               *
      *            - Applied for MD-39986.                            *
      *  CFT151 - FT IN/OP Alphanumeric sequence                      *
      *  MD022652 - Excluded Phase Processing                         *
      *  258944 - APISERVER API FTOPAY: correct positions; fix use of *
      *           APNARV in CFT148 which adds one to positions        *
      *           Amended hook: CFT148_004 (Recompile)                *
      *  CFT148 - FT Remove Validation on Field 50F                   *
      *           Added hooks: CFT148_004, CFT148_005, CFT148_006     *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CAP211 - FT IN_OP APIs - Auto-Authorization of Payment       *
      *  CFT039 - SWIFT Mapping of Field Ordering Bank                *
      *  CSC054 - Period End Adjustments                              *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,FTH00059                                 *
      *             WNCPYSRC,FTH00060                                 *
      *             WNCPYSRC,FTH00061                                 *
      *             WNCPYSRC,FTH00062                                 *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  BUG26775 - Validation error in Outgoing Validation Flag      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  BUG26548 - Passed parm does not match entry parm for FTVXVXV *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  257361 - Pass SDFTFR to FTOPAV1VL in case Warning message    *
      *           ('Network TELEX must be defined in Standing data')  *
      *           which appears for Settlement type '02' (cheques)    *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompiled)   *
      *  250600 - Recompiled for change in FTV@OPAYPD                 *
      *           to fix CFT032/CSW207 errors                         *
      *  249652 - CFT032, a few problems (Recompile)                  *
      *  GBO009 - Funds Transfer Outgoing Payment Reference           *
      *         - Added core hooks: FTOPAYRC27, FTOPAYRC28.           *
      *  CFT032 - Account line in field 50X in MT103                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  220110 - Logic when trying to access SWIFT details of        *
      *           destination incorrectly assumes the first 6 digits  *
      *           of the Account Number are the customer number       *
      *           resulting in database error at 82.                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9075 - Updates the database file for action 'N' even with *
      *            Errors.                                            *
      *  BUG9074 - DB Error occured for 'A'mend action.               *
      *  BUG7319- Parameter mismatch on call to FTOPAY1DP             *
      *  CSC024 - Open Month End                                      *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4776R-Reverse fix since fix only applies to Incoming.     *
      *           (Reopen)                                            *
      *  BUG4776- Correct skipping of transaction reference.          *
      *  CFT118 - Core changes for GBO018.                            *
      *           Demand Drafts Printing - Upgrade to MidasPlus       *
      *           Core hooks amended:FTOPAYB010                       *
      *                              FTOPAYRC01                       *
      *  CFT116 - Core changes for GBO016                             *
      *         - MT110 Generation in Funds Transfer                  *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:FTOPAYRC01,FTOPAYRC04,FTOPAYB010 *
      *           Core hooks added:FTOPAYPC01                         *
      *  CGL014 - Collaterals Processing                              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Correct parameters on program calls                 *
      *  CGP001 - Global Processing.                                  *
      *         - Recompile due to change in FTVOPY2PD                *
      *  CAP084 - MidasPlus Changes                                   *
      *  CSW203 - SWIFT 2003 Standards Update                         *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  207404 - Send msg with correct payment reference after       *
      *           successful insert                                   *
      *  207329 - Datas from old previous transaction are displayed   *
      *           in screen 4                                         *
      *  204029 - Data decimal error on fields MISC01,2,3,4,5         *
      *           and SWSCHG when CFT009 is not on (RECOMPILE).       *
      *  200149 - Program dumped on FTVCHPY.                          *
      *  CSC011 - 24x7 Midas Availability                             *
      *  193883 - Recompile over changed FTOPAYUPD.                   *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  190845 - Add extra fields for Message Unique Reference and   *
      *           Part Number                                         *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *  187413 - Payment never updated to Database once correctly    *
      *           Repaired. Bad definition of first parameter for     *
      *           the call of FTOPAYUPD.                              *
      *  187056 - IP and OP do not recalculate screen charges if      *
      *           'Charges to the Debit of a/c' has been changed      *
      *           from blank to non-blank.                            *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  175479 - Recompile over changes in outgoing payment file     *
      *  CFT007 - BIC Database Plus Integration                       *
      *  CAP011 - Substitution of Midas database flds for externl i/fs*
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *  CAP014 - Repair function enhancements                        *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CFT004 - IBAN, International Bank Account Number             *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *              CFT007 BIC Database Plus Integration             *
      *         //////////////////////////////////////////////////    *
      *        // NOTE: If the destination, ordering customer, //     *
      *       // receiver's correspondent, ordering bank,     //      *
      *      // beneficiary or intermediary bank fields      //       *
      *     // change position, the cursor position test in //        *
      *    // SR BICPrompt will need to be change.         //         *
      *   //////////////////////////////////////////////////          *
      *                                                               *
      *****************************************************************
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
 
     FFTIOPAYL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FTIOPAYD0 : FTIOPAYX0)
     FFTIOPAYL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
     FFTIOPLX1L0UF   E           K DISK    INFSR(*PSSR)                                       CER001
     F                                     USROPN                                             CER001
     F                                     COMMIT                                             CER001
      *                                                                                       CER001
     FFTOPX1L0  IF   E           K DISK    USROPN                                             CER001
     F                                     RENAME(OTPAYDDL:RTVIDX)                            CER001
     F                                     INFSR(*PSSR)                                       CER001
      *                                                                                       CER030
      ** Network Transaction Identifier File                                                  CER030
      *                                                                                       CER030
     FSDNTTIL1  IF   E           K DISK    INFSR(*PSSR)                                       CER030
 
      * Hook to enable non-core files to be included
      /COPY WNCPYSRC,SETRADR011
 
 
     F/COPY WNCPYSRC,FTOPAYRF01
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
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
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
                                                                                              CSC024
      ** String for System Values Array                                                       CSC024
     D*SysValOME       C                   CONST('OMEIndicator')                       CSC024 CSC054
     D SysValPEA       C                   CONST('PEAIndicator')                              CSC054
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D @EI             S              1    DIM(60)
 
      ** Commitment Control Job Array                                                         CSC022
     D WJobs           S             10A   Dim(10)                                            CSC022
      **                                                                                      CSC022
     D CrPtFilFmt    E DS                  EXTNAME(OTPAYDD)
      * Current Payment in File Format
 
     D CrPtFilFmX    E DS                  EXTNAME(OTPAYXPD)                    CFT014
      ** Current Payment in File Format (Extension)                             CFT014
 
     D CurPmtScn1    E DS                  EXTNAME(FTOPY1PD)
      * (Current) Payment in Screen Format (primary screen)
     D                                     PREFIX(@)
     D CurPmtSc2a    E DS                  EXTNAME(FTOPY2PD)
      * (Current) Payment in Screen Format (Secondary screen)
     D                                     PREFIX(@)
     D CurPmtSc2b    E DS                  EXTNAME(FTOPY3PD)
      * (Current) Payment in Screen Format (Secondary screen)
     D                                     PREFIX(@)
     D CurPmtScn3    E DS                  EXTNAME(FTOPY4PD)
      * (Current) Payment in Screen Format (Charges/Commissions screen)
     D                                     PREFIX(@)
                                                                                CFT014
     D CurPmtSc1b    E DS                  EXTNAME(FTOPY1APD)                   CFT014
      ** (Current) Payment in Screen Format (Primary Screen definition 2)       CFT014
     D                                     PREFIX(@)                            CFT014
                                                                                CFT014
     D CurPmtSc3b    E DS                  EXTNAME(FTOPY5PD)                    CFT014
      ** (Current) Payment in Screen Format (Lvl 2 Scrn 3 definition 2)         CFT014
     D                                     PREFIX(@)                            CFT014
                                                                                CFT014
     D CurPmtScn4    E DS                  EXTNAME(FTOPY6PD)                    CFT014
      ** (Current) Payment in Screen Format (Lvl 2 Scrn 4 Chrgs and Comms. scrn)CFT014
     D                                     PREFIX(@)                            CFT014
                                                                                CFT014
     D CurPmtScn5    E DS                  EXTNAME(FTOPY7PD)                    CFT014
      ** (Current) Payment in Screen Format (Margin Information Screen)         CFT014
     D                                     PREFIX(@)                            CFT014
     D CurPmtScn6    E DS                  EXTNAME(FTOPYAPD)                                  CSW209
     D                                     PREFIX(@A)                                         CSW209
     D CurPmtScn7    E DS                  EXTNAME(FTOPYCPD)                                  CSW209
     D                                     PREFIX(@C)                                         CSW209
 
 
     D NwPtFilFmt    E DS                  EXTNAME(FTVOPAYPD)
      * New Payment in File Format
                                                                                CFT014
     D NwPtFilFmx    E DS                  EXTNAME(FTVOPY2PD)                   CFT014
      ** New Payment in File Format (Extension)                                 CFT014
     D/COPY WNCPYSRC,FTH00208
 
 
     D NewPmtScn1    E DS                  EXTNAME(FTOPY1PD)
      * New Payment in Screen Format (Primary screen)
     D NewPmtSc2a    E DS                  EXTNAME(FTOPY2PD)
      * New Payment in Screen Format (Secondary screen)
     D NewPmtSc2b    E DS                  EXTNAME(FTOPY3PD)
      * New Payment in Screen Format (Secondary screen)
     D NewPmtScn3    E DS                  EXTNAME(FTOPY4PD)
      * New Payment in Screen Format (Charges/Commissions screen)
                                                                                CFT014
     D NewPmtSc1b    E DS                  EXTNAME(FTOPY1APD)                   CFT014
      ** New Payment in Screen Format (Primary Screen definition 2)             CFT014
                                                                                CFT014
     D NewPmtSc3b    E DS                  EXTNAME(FTOPY5PD)                    CFT014
      ** New Payment in Screen Format (Lvl 2 Screen 3 definition 2)             CFT014
                                                                                CFT014
     D NewPmtScn4    E DS                  EXTNAME(FTOPY6PD)                    CFT014
      ** New Payment in Screen Format (Lvl 2 Screen 4 Chrgs and Comms screen)   CFT014
                                                                                CFT014
     D NewPmtScn5    E DS                  EXTNAME(FTOPY7PD)                    CFT014
      ** New Payment in Screen Format (Margin Information Screen)               CFT014
     D NewPmtScn6    E DS                  EXTNAME(FTOPYAPD)                                  CSW209
      **  Screen Format (Cover Messages 1)                                                    CSW209
     D FTEOPYA       E DS                  EXTNAME(FTEOPYAPD)                                 CSW209
     D                                     PREFIX(@A)                                         CSW209
      ** Error indicators - Cover Msg Screen 1                                                CSW209
     D NewPmtScn7    E DS                  EXTNAME(FTOPYCPD)                                  CSW209
      **  Screen Format (Cover Messages 2)                                                    CSW209
     D FTEOPYC       E DS                  EXTNAME(FTEOPYCPD)                                 CSW209
     D                                     PREFIX(@C)                                         CSW209
      ** Error indicators - Cover Msg Screen 2                                                CSW209
 
 
     D PrvPmtScn1    E DS                  EXTNAME(FTOPY1PD)
      * (Previous) Payment in Screen Format (primary screen)
     D                                     PREFIX(@P)
     D PrvPmtSc2a    E DS                  EXTNAME(FTOPY2PD)
      * (Previous) Payment in Screen Format (Secondary screen)
     D                                     PREFIX(@P)
     D PrvPmtSc2b    E DS                  EXTNAME(FTOPY3PD)
      * (Previous) Payment in Screen Format (Secondary screen)
     D                                     PREFIX(@P)
     D PrvPmtScn3    E DS                  EXTNAME(FTOPY4PD)
      * (Previous) Payment in Screen Format (Charges/Commissions screen)
     D                                     PREFIX(@P)
                                                                                CFT014
     D PrvPmtSc1b    E DS                  EXTNAME(FTOPY1APD)                   CFT014
      ** (Previous) Payment in Screen Format (Primary Screen definition 2)      CFT014
     D                                     PREFIX(@P)                           CFT014
                                                                                CFT014
     D PrvPmtSc3b    E DS                  EXTNAME(FTOPY5PD)                    CFT014
      ** (Previous) Payment in Screen Format (Lvl2 Screen  3 definition 2)      CFT014
     D                                     PREFIX(@P)                           CFT014
                                                                                CFT014
     D PrvPmtScn4    E DS                  EXTNAME(FTOPY6PD)                    CFT014
      ** (Previous) Payment in Screen Format (Lvl2 Screen  4 Chrgs & Comms scrn)CFT014
     D                                     PREFIX(@P)                           CFT014
                                                                                CFT014
     D PrvPmtScn5    E DS                  EXTNAME(FTOPY7PD)                    CFT014
      ** (Previous) Payment in Screen Format (Margin Information Screen)        CFT014
     D                                     PREFIX(@P)                           CFT014
     D PrvPmtScn6    E DS                  EXTNAME(FTOPYAPD)                                  CSW209
     D                                     PREFIX(@P)                                         CSW209
     D PrvPmtScn7    E DS                  EXTNAME(FTOPYCPD)                                  CSW209
     D                                     PREFIX(@P)                                         CSW209
      *                                                                                       CFT039
      ** FT OPAY API Ordering Bank Details                                                    CFT039
     D TranInfoFlds  E DS                  EXTNAME(FTOPIFPD)                                  CFT039
      *                                                                                       CFT039
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
     D @NotDelAmt    E                     EXTFLD(@SNDAM)
     D @PayDelAmt    E                     EXTFLD(@SPDAM)
     D @PayAmount    E                     EXTFLD(@SPYAM)
     D @SettleAmt    E                     EXTFLD(@SSMAM)
     D @CDRO1        E                     EXTFLD(@CDRQQ)                                     CGL029
 
 
     D FTEOPY1       E DS                  EXTNAME(FTEOPY1PD)
      * Error indicators - Main screen
 
     D FTEOPY2       E DS                  EXTNAME(FTEOPY2PD)
      * Error indicators - Level 2 details
 
     D FTEOPY3       E DS                  EXTNAME(FTEOPY3PD)
      * Error indicators - Charges & Commissions screen
                                                                                CFT014
     D FTEOPY4       E DS                  EXTNAME(FTEOPY4PD)                   CFT014
      ** Error indicators - Charges & Commissions screen                        CFT014
                                                                                CFT014
     D FTEOPY5       E DS                  EXTNAME(FTEOPY5PD)                   CFT014
      ** Error indicators - Margin Infor screen                                 CFT014
 
     D*OTPAYD***     E DS                  EXTNAME(OTPAYDA)                                   CFT151
      ***** DATA AREA FOR ORDINARY PAYMENT REF NUMBERING                                      CFT151
      ** DS for next Outgoing Payment Reference Number                                        CFT151
     D OTPAYD          DS             4                                                       CFT151
     D  WOTSQ                  1      4  0                                                    CFT151
     D*     DATA AREA FOR ORDINARY PAYMENT REF NUMBERING
 
     D RGPAYD        E DS                  EXTNAME(RGPAYDA)
     D*     DATA AREA FOR REGULAR PAYMENT REF NUMBERING
     D*
                                                                                CFT009
      ** Valid Outgoing Payments Extension File (default)                       CFT009
     D DEFVALIDX     E DS                  EXTNAME(FTVOPY2PD)                   CFT009
     D                                     PREFIX(D#)                           CFT009
                                                                                CFT009
      * Valid Payments layout (default)                                         CFT009
     D DEFVALID      E DS                  EXTNAME(FTVOPAYPD)                   CFT009
     D                                     PREFIX(D#)                           CFT009
      * External DS for Midas SD Retail Details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
      * External DS for Midas SD Trading ICD Details
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  QQACC2       E                     EXTFLD(QQACCD)                                     CGL029
 
      * External DS for Funds Transfer details
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
     D  WRATDIS               44     48  4
 
      * External data structure for currency codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
     D SDFODA        E DS                  EXTNAME(SDFODAPD)
     D  QQACC3       E                     EXTFLD(QQACCD)                                     CGL029
      ** EXTERNAL DS FOR FUNDS TRANSFER ICD DETAILS
                                                                                CFT014
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                    CFT014
     D  QQACC4       E                     EXTFLD(QQACCD)                                     CGL029
      ** External DS for Nostro details                                         CFT014
                                                                                CFT014
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                    CFT014
      ** External DS for Branch details                                         CFT014
                                                                                CFT014
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    CFT014
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CGL029
      ** External DS for Customer details                                       CFT014
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
 
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)                     CAP011
      ** EXTERNAL DS FOR API ICD                                                CAP011
                                                                                CAP011
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D ExtData       E DS                  EXTNAME(FTOPEXPD)
     D/COPY WNCPYSRC,FTH00209
      * FT (OPAY) Extra Data - File (D/B) format
     D/COPY OFCPYSRCZ,CFT148_004                                                              CFT148
 
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 Status DataArea Layout                                                          CSC011
     D  WPRDTE                 5      9  0                                                    CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD Status DataArea Layout                                                            CSC011
                                                                                              CSC011
      ** SCCMTJOB DataArea Layout                                                             CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WDSJobs                4    103A                                                      CSC022
      *                                                                                       CER030
      ** Current DS for Extended Narrative Debit                                              CER030
      *                                                                                       CER030
     D CurPmtScn5A   E DS                  EXTNAME(FTOPY7APD)                                 CER030
     D                                     PREFIX(O)                                          CER030
      *                                                                                       CER030
      ** Current DS for Extended Narrative Credit                                             CER030
      *                                                                                       CER030
     D CurPmtScn5B   E DS                  EXTNAME(FTOPY7BPD)                                 CER030
     D                                     PREFIX(O)                                          CER030
      *                                                                                       CER030
      ** New DS for Extended Narrative Debit                                                  CER030
      *                                                                                       CER030
     D NewPmtScn5A   E DS                  EXTNAME(FTOPY7APD)                                 CER030
      *                                                                                       CER030
      ** New DS for Extended Narrative Credit                                                 CER030
      *                                                                                       CER030
     D NewPmtScn5B   E DS                  EXTNAME(FTOPY7BPD)                                 CER030
      *                                                                                       CER030
      ** Previous DS for Extended Narrative Debit                                             CER030
      *                                                                                       CER030
     D PrvPmtScn5A   E DS                  EXTNAME(FTOPY7APD)                                 CER030
     D                                     PREFIX(P)                                          CER030
      *                                                                                       CER030
      ** Previous DS for Extended Narrative Credit                                            CER030
      *                                                                                       CER030
     D PrvPmtScn5B   E DS                  EXTNAME(FTOPY7BPD)                                 CER030
     D                                     PREFIX(P)                                          CER030
      *                                                                                       CER030
      **                                                                                      CSC022
     D @CCI@M          DS
      ** CURRENT CONTROL INDICATORS FOR MAIN DETAIL SCREEN
     D  @EKYFD                 1      1
     D  @EDTFD                 2      2
 
     D @PCI@M          DS             2
      ** PREVIOUS CONTROL INDICATORS FOR MAIN DETAIL SCREEN
 
      *  User / Branch data area
     D ZMUSER          DS            17
     D  WUSRID                 1     10                                                       CAP084
     D  WDFBR                 11     13
     D  WDPPT                 14     16
 
      * Data structure to retrieve multi branch indicator
     DRUNDAT           DS
     D WMBIN                  13     13
     D/COPY WNCPYSRC,FTOPAYRD01
 
     D                 DS
     D*     REDEFINE IPREF FOR INSERTS
     D  IPREF                  1     15
     D  P                      1      1    INZ('P')
     D  RUNDYY                 2      3  0
     D  RUNDMD                 4      7  0
     D**PRNUM                  8     11  0                                                    CFT151
     D  PRNUM                  8     11                                                       CFT151
     D  PmntType              12     13
     D  StmtType              14     15  0
     D*
 
      * Overide file OTPAY in UPD module
     D  OVERRIDE                     47    INZ('OVRDBF FILE(OTPAYOVR)  +
     D                                            TOFILE(OTPAY) SHARE(*NO)')
                                                                                CFT014
      ** Overide file OTPAYXL0 in UPD module.                                   CFT014
     D  OVROPXL0                     49    INZ('OVRDBF FILE(OTXL0)  +           CFT014
     D                                            TOFILE(OTPAYXL0) SHARE(*NO)') CFT014
 
      ***Overide*file*FTPREFL0*in*UPD*module.**************************             BUG4776 BUG4776R
     D**OVRFTPRF                     49    INZ('OVRDBF FILE(FTPREFX1) +             BUG4776 BUG4776R
     D**********                                  TOFILE(FTPREFL0) SHARE(*NO)')     BUG4776 BUG4776R
      **********                                                                    BUG4776 BUG4776R
      * Output Data Structure for BIC reformatted address                       CFT007
     D @OAddress       DS           175                                         CFT007
     D  OAddress1              1     35                                         CFT007
     D  OAddress2             36     70                                         CFT007
     D  OAddress3             71    105                                         CFT007
     D  OAddress4            106    140                                         CFT007
     D  OAddress5            141    175                                         CFT007
                                                                                CFT007
      * Data Structure for BIC address input flags                              CFT007
     D*BicLines**      DS            12                                         CFT007 CFT014
     D BicLines        DS            14                                         CFT014
     D  Line1Dest              1      1                                         CFT007
     D  Line2Dest              2      2                                         CFT007
     D  Line1OCus              3      3                                         CFT007
     D  Line2OCus              4      4                                         CFT007
     D  Line1RCor              5      5                                         CFT007
     D  Line2RCor              6      6                                         CFT007
     D  Line1ABnk              7      7                                         CFT007
     D  Line2ABnk              8      8                                         CFT007
     D  Line1Benf              9      9                                         CFT007
     D  Line2Benf             10     10                                         CFT007
     D  Line1IBnk             11     11                                         CFT007
     D  Line2IBnk             12     12                                         CFT007
     D  Line1TRIn             13     13                                         CFT014
     D  Line2TRIn             14     14                                         CFT014
                                                                                CFT014
      ** Data structure to check when a single screen is already validated.     CFT014
                                                                                CFT014
     D  WScreenDS      DS             5                                         CFT014
     D  WScreen1               1      1    INZ('N')                             CFT014
     D  WScreen2               2      2    INZ('N')                             CFT014
     D  WScreen3               3      3    INZ('N')                             CFT014
     D  WScreen4               4      4    INZ('N')                             CFT014
     D  WScreen5               5      5    INZ('N')                             CFT014
      *                                                                                       187056
      ** Calling parameter DS for FT0035                                                      187056
     D P0DTA           DS           256                                                       187056
     D  WIPT1                  1      1                                                       187056
     D  WIPTY1                 2     36                                                       187056
     D  WIPT2                 37     37                                                       187056
     D  WIPTY2                38     72                                                       187056
     D  WICCY                 73     75                                                       187056
     D  WOCUST                76     81                                                       187056
                                                                                CFT007
     D/COPY QWINDSRC,FTOPAYSDTA
     D PDATA           DS          1024                                                       CER001
     D  #1FLD1#                1      6  0                                                    CER001
     D  PREF1                  7     21                                                       CER001
     D  #1FOTR                22     41                                                       CER001
     D  #1TMST                42     67Z                                                      CER001
     D  #1ORCT                68     68                                                       CER001
     D  #1ORBK                69     80                                                       CER001
     D  #1ORC1                81    115                                                       CER001
     D  #1SMCY               116    118                                                       CER001
     D  #1ORBT               119    119                                                       CER001
     D  #1SMAM               120    132P 0                                                    CER001
     D  #1PCCY               133    135                                                       CER001
     D  #1SNCT               136    136                                                       CER001
     D  #1SNCO               137    146                                                       CER001
     D  #1DSTT               147    147                                                       CER001
     D  #1DST1               148    182                                                       CER001
     D  #1DEXT               183    183                                                       CER001
                                                                                              CER001
     D NwOPIScnFmt   E DS                  EXTNAME(FTOPRXPD)                                  CER001
     D NwOPFilFmt    E DS                  EXTNAME(FTVOPLX1PD)                                CER001
     D CrOPFilFmt    E DS                  EXTNAME(FTOPX1L0)                                  CER001
     D   OPPAYREF    E                     EXTFLD(OPPREF)                                     CER001
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      **   Timestamp selected
     D @TMESTPSEL      S             26Z
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
      ** -------------------------------------------------------------------
      ** Fields for getting the starting field number from file (parameters
      ** to ZACGTFLDNO, plus the offset to the requested field).
     D Format          S             10A   INZ('FTOPAYPD')
 
     D FieldP          S             10A   INZ('SACTION')
     D*FieldS***       S             10A   INZ('STRCT')                         CFT014
     D*FieldT***       S             10A   INZ('SINB1')                         CFT014
     D FieldS          S             10A   INZ('SBOCD')                         CFT014
     D FieldT          S             10A   INZ('SDTP1')                         CFT014
     D Field4          S             10A   INZ('SCDRO')                         CFT014
     D Field5          S             10A   INZ('SFXMP')                         CFT014
 
     D FieldNo         S              5P 0
 
     D FldOffsetP      S              5P 0
     D FldOffsetS      S              5P 0
     D FldOffsetT      S              5P 0
     D FldOffset4      S              5P 0                                      CFT014
     D FldOffset5      S              5P 0                                      CFT014
 
      ** End of fields for getting starting field number
      ** -------------------------------------------------------------------
      ** Flags to indicate whether substitution is required in                  CAP011
      ** each of the various parts the transaction                              CAP011
     D RepPrim         S              1A   inz('N')                             CAP011
     D RepSecA         S              1A   inz('N')                             CAP011
     D RepSecB         S              1A   inz('N')                             CAP011
     D RepThir         S              1A   inz('N')                             CAP011
     D RepPrmB         S              1A   inz('N')                             CFT014
     D RepThrB         S              1A   inz('N')                             CFT014
     D RepFour         S              1A   inz('N')                             CFT014
     D RepMarg         S              1A   inz('N')                             CFT014
     D RepCovA         S              1A   inz('N')                                           CSW209
     D RepCovD         S              1A   inz('N')                                           CSW209
     D RepFivA         S              1A   inz('N')                                           CER059
     D RepFivB         S              1A   inz('N')                                           CER059
     D ULX043          S              1A   INZ('N')                                           CER001
     D ACTION          S              1A                                                      CER001
     D #RTRN           S              7A                                                      CER001
     D PFind           S              1                                                       CER001
     D PSACTION        S              1                                                       CER001
 
     D WkBlankfld      S             35    INZ(*Blanks)                         CFT007
     D WkCHIPCode      S             14    INZ(*Blanks)                         CFT007
                                                                                CFT007
      * Msg Unique Reference                                                                  190845
     D SHMSGR          S              8  0                                                    190845
     D                                                                                        190845
      * Part Number                                                                           190845
     D SHPART          S              3  0                                                    190845
      *                                                                                       190845
     D PReDspChg       S              1A                                                      200149
                                                                                              200149
      ** Message Type key field                                                               CSC011
     D KMTYP           S              8A                                                      CSC011
                                                                                              CSC011
      ** Access Object parameter fields                                                       CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
     D PACCD           S             10A                                                      CGL029
                                                                                              CSC011
      ** Flag to indicate if CSW203 is switched on                                            CSW203
     D CSW203          S              1A                                                      CSW203
                                                                                              CSW203
      ** CSC022 switchable field                                                              CSC022
     D CSC022          S              1A                                                      CSC022
      **                                                                                      CSC022
      ** CSC022 work fields                                                                   CSC022
     D WArrPtr         S              3S 0                                                    CSC022
     D WSkpComtRolbk   S              1A                                                      CSC022
      *                                                                                       CER030
     D KTtcd           S             10A                                                      CER030
     D WFlg            S              1A                                                      CER030
     D CER030          S              1A                                                      CER030
     D CER031          S              1A                                                      CER030
     D CGL013          S              1A                                                      CER030
      **                                                                                      CSC022
     D WIdx_AVAL       S              3  0                                                    CSW209
     D WIdx_DVAL       S              3  0                                                    CSW209
     D CSC054          S              1A                                                      CSC054
      *                                                                                       CSC054
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FTOPAYB010
 
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
      /COPY WNCPYSRC,FTOPAYB001
      * Issue rollback to clear any possible updates in window functions
      *
     C     @INKL         IFEQ      '1'
      **                                                                                      CSC022
      ** Execute rollback if SAR CSC022 is not enrolled or                                    CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        WSkpComtRolbk = 'N'                                        CSC022
     C                   RolBk                                                                CSC022
     C                   Else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   END
      *
      /COPY WNCPYSRC,FTOPAYB002
      *
      * DO SCREEN: BROWSE INVALID DEALS
      *
     C     @SCRN         IFEQ      'I'
     C                   MOVE      Wval          Val@Fields                                   207329
     C                   EXSR      SCRN@I
     C                   END
      *
      ** Read next browse subfile record
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTOPAYB003
      *
      ** DO WHILE screen: Primary Details Screen (Level 1)
      *
     C                   Z-ADD     *ZERO         WIdx_PVAL         3 0
     C                   MOVE      *Blanks       @FIND
     C                   MOVE      *Blanks       @NDAT
     C                   MOVE      *Blanks       @PYDT
     C                   MOVE      *Blanks       @PYVD
     C                   MOVE      *Blanks       @STTP
     C     @SCRN         DOWEQ     'P'
     C                   EXSR      Scrn@P
     C                   ENDDO
      *
      /COPY WNCPYSRC,FTOPAYB004
      *
      ** DO WHILE screen: Secondary Details Screen (Level 2)
      *
     C                   Z-ADD     *ZERO         WIdx_SVAL         3 0
     C                   MOVE      *Blanks       @ACB1
     C                   MOVE      *Blanks       @ACB2
     C                   MOVE      *Blanks       @BNC1
     C                   MOVE      *Blanks       @BNC2
     C                   MOVE      *Blanks       @RCO1
     C                   MOVE      *Blanks       @RCO2
     C                   MOVE      *Blanks       @TRI1                          CFT014
     C                   MOVE      *Blanks       @TRI2                          CFT014
     C                   MOVE      *Blanks       @INB1                          CFT014
     C                   MOVE      *Blanks       @INB2                          CFT014
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      Scrn@S
     C                   ENDDO
                                                                                CFT014
      ** Third detail screen level 2                                            CFT014
                                                                                CFT014
     C                   Z-Add     *Zero         WIdx_BVAL         3 0          CFT014
                                                                                CFT014
     C                   DoW       @SCRN = 'B'                                  CFT014
     C                   ExSr      SCRN@B                                       CFT014
     C                   Enddo                                                  CFT014
                                                                                CFT014
      ** Default charges & commissions screens                                  CFT014
                                                                                CFT014
     C                   IF        @CFT009 = 'N'                                CFT009
     C                   If        @SCRN = 'O'                                  CFT014
     C                   If        (NewPmtScn1 <> PrvPmtScn1) Or                CFT014
     C                             (NewPmtSc1b <> PrvPmtSc1b) Or                CFT014
     C                             (NewPmtSc2a <> PrvPmtSc2a) Or                CFT014
     C                             (NewPmtSc2b <> PrvPmtSc2b) Or                CFT014
     C                             (NewPmtScn3 <> PrvPmtScn3) Or                CFT014
     C                             (NewPmtSc3b <> PrvPmtSc3b)                   CFT014
     C                   ExSr      DFT@O                                        CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
     C                   ENDIF                                                  CFT009
                                                                                CFT014
      *
      /COPY WNCPYSRC,FTOPAYB005
      *
      ** DO WHILE screen: Charges & Commissions Screen
      *
     C                   Z-ADD     *ZERO         WIdx_OVAL         3 0
     C***********        MOVE      *Blanks       @INB1                          CFT014
     C***********        MOVE      *Blanks       @INB2                          CFT014
     C     @SCRN         DOWEQ     'O'
     C                   EXSR      Scrn@O
     C                   ENDDO
      *                                                                                       CER001
      ** Lux Details Screen                                                                   CER001
      *                                                                                       CER001
     C     @SCRN         DOWEQ     'L'                                                        CER001
     C                   EXSR      Scrn@Lux                                                   CER001
     C                   ENDDO                                                                CER001
                                                                                CFT014
      ** Margin Information                                                     CFT014
                                                                                CFT014
     C     @SCRN         DowEq     'M'                                          CFT014
     C                   ExSr      Scrn@M                                       CFT014
     C                   Enddo                                                  CFT014
      *                                                                                       CSW209
      ** Display Cover Message if SWIFT 2009 is ON                                            CSW209
      *                                                                                       CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      *                                                                                       CSW209
      ** Cover Message screen 1                                                               CSW209
      *                                                                                       CSW209
     C     @SCRN         DOWEQ     'A'                                                        CSW209
     C                   EXSR      SCRN@A                                                     CSW209
     C                   ENDDO                                                                CSW209
      *                                                                                       CSW209
      ** Cover Message screen 2                                                               CSW209
      *                                                                                       CSW209
     C     @SCRN         DOWEQ     'D'                                                        CSW209
     C                   EXSR      SCRN@D                                                     CSW209
     C                   ENDDO                                                                CSW209
      *                                                                                       CSW209
     C                   ENDIF                                                                CSW209
      *
      /COPY WNCPYSRC,FTOPAYB006
      *
      * SCREEN: WINDOW
     C                   Z-ADD     *ZERO         WIdx_WVAL         3 0
     C     @SCRN         IFEQ      'W'
     C                   EXSR      WINDOW
     C                   END
 
      /COPY WNCPYSRC,FTOPAYB008
      *
      * SCREEN: CONFIRMATION OF INPUT
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   END
 
      ** Do File updates
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTOPAYB009
      *
      ** Terminate program
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      *ON           *INLR
     C                   IF        ULX043 = 'Y'                                               CER001
     C                   CLOSE     FTIOPLX1L0                                                 CER001
     C                   CLOSE     FTOPX1L0                                                   CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF
      *
      *****************************************************************
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FTOPAYB011
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * Scrn@Lux - Process Lux Extension Data                         *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     Scrn@Lux      BEGSR                                                                CER001
      *                                                                                       CER001
      ** Using Same Details but Call with 2Part validated                                     CER001
      *                                                                                       CER001
     C                   MOVEL     SPREF         PREF1                                        CER001
     C                   MOVEL     SFOTRANID     #1FOTR                                       CER001
     C                   MOVEL     STMESTMP      #1TMST                                       CER001
     C                   MOVEL     @ORCT         #1ORCT                                       CER001
     C                   MOVEL     @ORBT         #1ORBT                                       CER001
     C                   MOVEL     SORBK         #1ORBK                                       CER001
     C                   MOVEL     SORC1         #1ORC1                                       CER001
     C                   MOVEL     SSMCY         #1SMCY                                       CER001
     C                   Z-ADD     @SMAM         #1SMAM                                       CER001
     C                   MOVEL     SPCCY         #1PCCY                                       CER001
     C                   MOVEL     @SNCT         #1SNCT                                       CER001
     C                   MOVEL     SSNCO         #1SNCO                                       CER001
     C                   MOVEL     @DSTT         #1DSTT                                       CER001
     C                   MOVEL     SDST1         #1DST1                                       CER001
      *                                                                                       CER001
      ** Retrieve record in extension file                                                    CER001
      *                                                                                       CER001
     C                   MOVE      PREF1         K@PREF                                       CER001
     C     K@KEY         CHAIN(N)  RTVIDX                             85                      CER001
     C     *IN85         IFEQ      *OFF                                                       CER001
     C                   EXSR      SRFTOS                                                     CER001
     C                   ELSE                                                                 CER001
     C                   EXSR      SRINZ                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        @OPSEL = 'N'                                               CER001
     C                   EVAL      PSACTION = SACTION                                         CER001
     C                   EVAL      SACTION = 'E'                                              CER001
     C                   EVAL      #1DEXT = 'Y'                                               CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   CALL      'FTOPAY2RP'                                                CER001
     C                   PARM      SACTION       ACTION                                       CER001
     C                   PARM                    PDATA                                        CER001
     C                   PARM      *BLANKS       #RTRN                                        CER001
     C                   PARM                    NwOPFilFmt                                   CER001
     C                   PARM                    NwOPIScnFmt                                  CER001
      *                                                                                       CER001
     C                   EVAL      #1DEXT = *BLANK                                            CER001
     C                   IF        @OPSEL = 'N'                                               CER001
     C                   EVAL      SACTION = PSACTION                                         CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Process returned command keys                                                        CER001
      *                                                                                       CER001
     C                   SELECT                                                               CER001
     C                   WHEN      #RTRN = 'Y2U9999'                                          CER001
     C                   EXSR      ENDP                                                       CER001
      *                                                                                       CER001
      ** If Cmd12 pressed, return to main details screen;                                     CER001
      ** otherwise, go to second screen                                                       CER001
      *                                                                                       CER001
     C                   WHEN      #RTRN = 'USR0790'                                          CER001
     C                   EVAL      @SCRN = 'O'                                                CER001
      *                                                                                       CER001
     C                   OTHER                                                                CER001
     C                   IF        @OPSEL <> 'N'                                              CER001
     C                   EVAL      @SCRN = 'C'                                                CER001
     C                   ELSE                                                                 CER001
     C     @RDNB         IFEQ      'Y'                                                        CER001
     C                   EVAL      @SCRN = 'R'                                                CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      @SCRN = 'I'                                                CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
     C                   ENDSL                                                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
 
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * SRFTOS - Move file fields to screen fields                    *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
      *                                                                                       CER001
     C     SRFTOS        BEGSR                                                                CER001
      *                                                                                       CER001
     C                   MOVE      'Y'           PFind                                        CER001
      *                                                                                       CER001
     C                   MOVEL     OPPREF        OPPAYREF                                     CER001
     C                   MOVEL     OPORTY        #LLXORTY                                     CER001
     C                   MOVEL     OPBETY        #LLXBETY                                     CER001
     C                   MOVEL     OPOPCO        #LLXOPCO                                     CER001
     C                   MOVEL     OPCOCO        #LLXCOCO                                     CER001
     C                   MOVEL     OPIDCO        #LLXIDCO                                     CER001
     C                   MOVEL     OPIDEN        #LLXIDEN                                     CER001
      *                                                                                       CER001
     C                   EVAL      #LLXOPFOTR = FRNT                                          CER001
     C                   EVAL      #LLXOPPREF = OPPAYREF                                      CER001
     C                   EVAL      #LLXOPORTY = OPORTY                                        CER001
     C                   EVAL      #LLXOPBETY = OPBETY                                        CER001
     C                   EVAL      #LLXOPOPCO = OPOPCO                                        CER001
     C                   EVAL      #LLXOPCOCO = OPCOCO                                        CER001
     C                   EVAL      #LLXOPIDCO = OPIDCO                                        CER001
     C                   EVAL      #LLXOPIDEN = OPIDEN                                        CER001
     C                   EVAL      #LLXOPTMES = TMST                                          CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * SRINZ - Initialize screen fields                              *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
      *                                                                                       CER001
     C     SRINZ         BEGSR                                                                CER001
      *                                                                                       CER001
     C                   MOVE      *BLANKS       PFind                                        CER001
      *                                                                                       CER001
     C                   MOVE      *BLANKS       #LLXORTY                                     CER001
     C                   MOVE      *BLANKS       #LLXBETY                                     CER001
     C                   MOVE      *BLANKS       #LLXOPCO                                     CER001
     C                   MOVE      *BLANKS       #LLXCOCO                                     CER001
     C                   MOVE      *BLANKS       #LLXIDCO                                     CER001
     C                   MOVE      *BLANKS       #LLXIDEN                                     CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      /EJECT
      *****************************************************************
      * SCRN@I - BROWSE INVALID TRADES
      *****************************************************************
     C     SCRN@I        BEGSR
      *
      * RESET READ NEXT BROWSE SUBFILE RECORD
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      * BUILD BROWSE SUBFILE
      *
     C                   CALLB     'FTOPAYRPB'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * BUILD SUB-FILE
     C                   PARM      'Y'           @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      *BLANK        @RDSFL            1
      *
      * Error in update of previous deal
     C                   PARM                    @ERRUP            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM                    @OPSEL            1
      *
      * ACTION SELECTED
     C                   PARM                    @ACSEL            1
      *
      * FO TRANSACTION ID SELECTED
     C                   PARM                    @FOTRANSEL       20
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
     C                   PARM                    Val@Fields                                   CSC011
      *                                                                                       207404
      ** Successful insert Payment                                                            207404
      *                                                                                       207404
     C                   PARM                    @SITR            15                          207404
      ** CSC022 Enhancement is installed                                                      CSC022
      **                                                                                      CSC022
     C                   PARM                    CSC022                                       CSC022
      **                                                                                      CSC022
      *
      *
      * If error set on external switches
      *
     C     @ERRMS        IFNE      *BLANK
     C                   MOVE      '1'           *INU6
     C                   END
      *
      * If CK/3 or CK/12 taken in browse, or error message
      * End program
      *
     C     @INKC         IFEQ      '1'
     C     @INKL         OREQ      '1'
     C     @ERRMS        ORNE      *BLANK
     C                   EXSR      ENDP
     C                   GOTO      ESCRN@I
     C                   END
      *
      * Read next browse subfile record
      *
     C                   MOVE      'Y'           @RDNB
     C                   MOVE      'R'           @SCRN
      *
     C     ESCRN@I       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@P - PROCESS SCREEN: PRIMARY DETAILS
      *****************************************************************
     C     SCRN@P        BEGSR
 
      * Enable/disable detail fields on main details screen
      * if changes to the data are allowed                                      CAP014
      * (key fields = action code & payment ref; detail fields = rest)
      * (Action code can only be 'I', 'A', or 'D')
      *
     C     SACTION       IFEQ      'I'
     C     @OPSEL        ANDEQ     'U'                                          CAP014
     C     SACTION       OREQ      'A'
     C     @OPSEL        ANDEQ     'U'                                          CAP014
     C/COPY WNCPYSRC,FTH00348
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EDTFD
     C                   END
      *
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      *
     C     SACTION       IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
     C*                                                                         CFT007
     C* If BIC database plus integration is on, set F4 and F16                  CFT007
     C*                                                                         CFT007
     C* KD = COMMAND KEY 04 = BIC in-line prompt                                CFT007
     C* KQ = COMMAND KEY 16 = BIC in-line search                                CFT007
     C*                                                                         CFT007
     C                   IF        @CFT007 = 'Y' and                            CFT007
     C                             SACTION <> 'D'                               CFT007
     C                   EVAL      @EINKD = 'Y'                                 CFT007
     C                   EVAL      @EINKD = 'Y'                                 CFT007
     C                   ELSE                                                   CFT007
     C                   EVAL      @EINKD = 'N'                                 CFT007
     C                   EVAL      @EINKD = 'N'                                 CFT007
     C                   ENDIF                                                  CFT007
      *
      * Update 'previous' screen
 
     C                   MOVEL     NewPmtScn1    PrvPmtScn1
     C                   MOVEL     NewPmtSc1b    PrvPmtSc1b                     CFT014
     C                   Z-ADD     WIdx_PVAL     PrvN_Warn         3 0
     C                   MOVEL     @CCI@M        @PCI@M
      *
      ** WRITE/READ DISPLAY SCREEN - Primary Details
      *
     C/COPY WNCPYSRC,FTOPAYRC06
     C                   CALLB     'FTOPAY1DP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Payment (IN SCREEN FORMAT - Primary)
     C                   PARM                    NewPmtScn1
     C                   PARM                    NewPmtSc1b                     CFT014
      * Status
     C                   PARM                    DDSTAT           24
      *
      * Fields in error
     C                   PARM                    FTEOPY1
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * ENABLED KEY FIELDS
      * ENABLED DETAIL FIELDS
     C/COPY WNCPYSRC,FTH00349
     C                   PARM      'N'           @EKYFD            1
     C/COPY WNCPYSRC,FTH00350
     C                   PARM                    @EDTFD            1
      * ENABLED FUNCTION KEYS
      * KD = COMMAND KEY 04 = BIC IN-LINE PROMPT                                CFT007
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      * KP = COMMAND KEY 15 = BROWSE
      * KQ = COMMAND KEY 16 = BIC IN-LINE SEARCH                                CFT007
      * KS = COMMAND KEY 18 = READ NEXT (from linked enquiry)
      * KV = COMMAND KEY 21 = ADDITIONAL INFORMATION WINDOW
     C                   PARM                    @EINKD            1            CFT007
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM      'N'           @EINKP            1
     C                   PARM                    @EINKQ            1            CFT007
     C                   PARM      'N'           @EINKS            1
     C                   PARM      'N'           @EINKV            1
      * Successful insert Payment
     C                   PARM                    @SITR            15
      *
      * Data required for Additional Info window
     C                   PARM                    INUSR1
     C                   PARM                    INUSR2
     C                   PARM                    AUP1
     C                   PARM                    AUP2
     C                   PARM                    OPMSGR
 
      * SWIFT Identifier
     C                   PARM                    XPREF
 
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKD             1            CFT007
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKQ             1            CFT007
     C                   PARM      '0'           @INKS             1
     C                   PARM      '0'           @INKV             1
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
      * Cursor location on screen                                               CFT007
     C                   PARM      0             CursorLoc         5 0          CFT007
     C                   PARM      *BLANKS       SSIMode           1                         BUG7319
     C/COPY WNCPYSRC,FTOPAYRC07
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       FTEOPY1
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *                                                                         CFT007
      * F4 - BIC in-line prompt                                                 CFT007
     C     @INKD         CASEQ     '1'           BICPrompt                      CFT007
      *
      * F12 - Cancel on Primary Screen
     C     @INKL         CASEQ     '1'           CANC@P
      *                                                                         CFT007
      * F16 - BIC in-line search                                                CFT007
     C     @INKQ         CASEQ     '1'           BICPrompt                      CFT007
      *
      * Validate input to Primary screen
     C                   CAS                     VAL@P
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@P  - VALIDATE INPUT TO PRIMARY DETAILS SCREEN
      *****************************************************************
     C     VAL@P         BEGSR
      *
      * Retrieve Payment details
      *
     C                   MOVEL     '      '      @@MODE
     C                   EXSR      RTVPMT
      *
      * If primary fields are NOT OK
      * Re-output screen with error messages on it
      *
     C     OKACTION      IFEQ      'N'
     C     OKPREF        OREQ      'N'
     C     OKBRCA        OREQ      'N'
     C                   GOTO      EndVAL@P
     C                   END
      *
      * Prior to validation, initialize error indicators as 'OK'
      * clear Payment in File Format, blank the following screens
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx_PVAL         3 0
     C                   MOVE      *ALL'Y'       FTEOPY1
     C                   IF        SACTION = 'I'                                             BUG9074
     C                   CLEAR                   NwPtFilFmt
     C                   CLEAR                   NwPtFilFmX                     CFT014
     C                   ENDIF                                                               BUG9074
      *
      *----------------------------------------------------------------
      * IF DELETE
      *
     C     SACTION       IFEQ      'D'
      *
      * IF F10 TAKEN, GO ON TO UPDATES
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   MOVE      'N'           @EINKJ
     C                   END
     C                   GOTO      EndVAL@P
     C                   END
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND
      *
     C     SACTION       IFEQ      'I'
     C     SACTION       OREQ      'A'
 
      * IF AMEND
      *
     C     SACTION       IFEQ      'A'
      *
      * Validate whether non-amenable fields have been changed
      *
     C                   CALLB     'FTOPAYAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * New Payment in Screen Format
     C                   PARM                    NewPmtScn1
     C                   PARM                    NewPmtSc2a
     C                   PARM                    NewPmtSc2b
     C                   PARM                    NewPmtScn3
     C                   PARM                    NewPmtSc1b                     CFT014
     C                   PARM                    NewPmtSc3b                     CFT014
     C                   PARM                    NewPmtScn4                     CFT014
     C                   PARM                    NewPmtScn5                     CFT014
      *
      * Current Payment in Screen Format
     C                   PARM                    CurPmtScn1
     C                   PARM                    CurPmtSc2a
     C                   PARM                    CurPmtSc2b
     C                   PARM                    CurPmtScn3
     C                   PARM                    CurPmtSc1b                     CFT014
     C                   PARM                    CurPmtSc3b                     CFT014
     C                   PARM                    CurPmtScn4                     CFT014
     C                   PARM                    CurPmtScn5                     CFT014
      *
      * Current Deal in file format
     C                   PARM                    CrPtFilFmt
     C                   PARM                    CrPtFilFmX                     CFT014
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    FTEOPY1
     C                   PARM                    FTEOPY2
     C                   PARM                    FTEOPY3
     C                   PARM                    FTEOPY4                        CFT014
     C                   PARM                    FTEOPY5                        CFT014
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Amendments OK
     C                   PARM                    @@AMOK            1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           @@RSTE            1
     C                   END
      *
     C/COPY OFCPYSRCZ,CFT148_005                                                              CFT148
      *
      * Validate Primary Payment details
      *
     C                   CALLB     'FTOPAY1VL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
 
      * Response mode
     C                   PARM                    RespMode
 
      ** Payment Primary Details
     C                   PARM                    NewPmtScn1
     C                   PARM                    PrvPmtScn1
     C                   PARM                    NewPmtSc1b                     CFT014
     C                   PARM                    PrvPmtSc1b                     CFT014
     C                   PARM      FOTRID        FrontOffice      20            CPB002
     C                   PARM                    NEWPMTSCN4                     CFT009
     C                   PARM                    TranInfoFlds                                 CFT039
      * Custom Extra Data file data
     C                   PARM                    ExtData
     C/COPY WNCPYSRC,FTOPAYRC10
 
      * OUTPUTS :
 
      ** Payment Primary Details OK inds
     C                   PARM                    FTEOPY1
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx_PVAL
      * Valid Payment layout (DS) from/to caller
     C                   PARM                    NwPtFilFmt
     C                   PARM                    NwPtFilFmX                     CFT014
      *  Validation Work Fields from/to caller
     C                   PARM                    Val@Fields
     C/COPY WNCPYSRC,FTOPAYRC11
     C* Msg Unique Reference                                                                  190845
     C                   PARM                    SHMSGR                                       190845
     C* Part Number                                                                           190845
     C                   PARM                    SHPART                                       190845
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
                                                                                              257361
      *  Funds Transfer Details                                                               257361
     C                   PARM                    SDFTFR                                       257361
                                                                                              257361
     C/COPY WNCPYSRC,FTOPAYRC01
                                                                                CFT014
      ** Update screen validated workfield                                      CFT014
                                                                                CFT014
     C                   If        WScreen1 = 'N'                               CFT014
     C                   Eval      WScreen1 = 'Y'                               CFT014
     C                   EndIf                                                  CFT014
 
      *
      * If errors returned
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@P
     C                   END
      *
 
      * if there are warnings which have not been displayed
      * re-output the screen
 
     C                   Eval      Widx_PVAL = Widx_PVAL + Widx
     C     WIdx_PVAL     IFNE      PrvN_Warn
     C                   GOTO      EndVAL@P
     C                   END
      *
      * Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       FTEOPY1
     C                   MOVE      *ALL'Y'       FTEOPY2
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * If windows processing on, call window routine, otherwise
      * Send the payments error messages to the secondary details screen
      * Go to Secondary details screen
      *
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C                   If        WScreen2 = 'N'                               CFT014
     C                   EXSR      SNDM@S
     C                   EndIf                                                  CFT014
     C                   MOVEL     'S'           @SCRN
     C                   END
      *
     C                   END
      *
     C     EndVAL@P      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@S - PROCESS SECOND SCREEN
      *****************************************************************
     C     SCRN@S        BEGSR
 
      * Update 'previous' screens and previous number of warnings
 
     C***********        MOVEL     NewPmtScn1    PrvPmtScn1                     CFT014
     C                   MOVEL     NewPmtSc2a    PrvPmtSc2a
     C                   MOVEL     NewPmtSc2b    PrvPmtSc2b
     C                   Z-ADD     WIdx_SVAL     PrvN_Warn         3 0
      *
      ** WRITE/READ DISPLAY SCREEN - Secondary Details
      *
     C                   CALLB     'FTOPAY2DP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Payment (IN SCREEN FORMAT - Primary / Secondary)
     C                   PARM                    NewPmtScn1
     C                   PARM                    NewPmtSc2a
     C                   PARM                    NewPmtSc2b
     C                   PARM                    NewPmtSc1b                     CFT014
      * Status
     C                   PARM                    DDSTAT
      *
      * Fields in error
     C                   PARM                    FTEOPY1
     C                   PARM                    FTEOPY2
      *
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * ENABLED Function Keys
     C                   PARM      'N'           @EKYFD            1
     C                   PARM                    @EDTFD            1
      *
      * ENABLED FUNCTION KEYS
     C                   PARM                    @EINKD                         CFT007
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM      'N'           @EINKP            1
     C                   PARM                    @EINKQ                         CFT007
     C                   PARM      'N'           @EINKS            1
      *
      * SUCCESFUL INSERT TRANSACTION
     C                   PARM                    @SITR            15
      *
      * OUTPUT PARAMETERS :
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKD             1             CFT007
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKQ             1             CFT007
     C                   PARM      '0'           @INKS             1
 
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
                                                                                CFT007
      * Cursor location on screen                                               CFT007
     C                   PARM      0             CursorLoc         5 0          CFT007
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       FTEOPY1
     C                   MOVE      *ALL'Y'       FTEOPY2
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *                                                                         CFT007
      * F4 - BIC in-line prompt                                                 CFT007
     C     @INKD         CASEQ     '1'           BICPrompt                      CFT007
      *
      * F12 - Cancel on Secondary Screen
     C     @INKL         CASEQ     '1'           CANC@S
      *                                                                         CFT007
      * F16 - BIC in-line search                                                CFT007
     C     @INKQ         CASEQ     '1'           BICPrompt                      CFT007
      *
      *
      * Validate Input to Secondary Screen
     C                   CAS                     VAL@S
      *
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@S  - VALIDATE INPUT TO SECONDARY SCREEN
      *****************************************************************
     C     VAL@S         BEGSR
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND
      *
     C     SACTION       IFEQ      'I'
     C     SACTION       OREQ      'A'
                                                                                CFT014
      ** Find out if there is a MT103 bilateral agreement exists between        CFT014
      ** the booking branch and the receiver only when CFT014 is setup.         CFT014
                                                                                CFT014
     C                   If        @CFT014 = 'Y'                                CFT014
     C                   Eval      @MT103 = *Blank                              CFT014
     C                   ExSr      SrBMT103                                     CFT014
     C                   EndIf                                                  CFT014
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   Z-ADD     *ZERO         WIdx_SVAL         3 0
     C                   MOVE      *ALL'Y'       FTEOPY1
     C                   MOVE      *ALL'Y'       FTEOPY2
      *
      * Validate Secondary Screen details
      *
     C                   CALLB     'FTOPAY2VL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Response mode
     C                   PARM                    RespMode
      ** Payment Primary & Secondary Details
     C                   PARM                    NewPmtScn1
     C                   PARM                    NewPmtSc2a
     C                   PARM                    NewPmtSc2b
     C                   PARM                    NewPmtSc1b                     CFT014
     C                   PARM                    NewPmtScn3                     CFT014
      * Custom Extra Data file data
     C                   PARM                    ExtData
 
      * OUTPUTS :
      ** Payment Primary Details OK inds
     C                   PARM                    FTEOPY2
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      * Valid Payment layout (DS) from/to caller
     C                   PARM                    NwPtFilFmt
     C                   PARM                    NwPtFilFmX                     CFT014
      *  Validation Work Fields from/to caller
     C                   PARM                    Val@Fields
                                                                                CFT014
      ** Update screen validated workfield                                      CFT014
                                                                                CFT014
     C                   If        WScreen2 = 'N'                               CFT014
     C                   Eval      WScreen2 = 'Y'                               CFT014
     C                   EndIf                                                  CFT014
 
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@S
     C                   END
      *
      *   re-output the screen
      *
     C                   Eval      Widx_SVAL = Widx_SVAL + Widx
     C     WIdx_SVAL     IFNE      PrvN_Warn
     C     NewPmtSc2a    ORNE      PrvPmtSc2a                                   CFT004
     C     WIdx_SVAL     ANDEQ     PrvN_Warn                                    CFT004
     C     WIdx_SVAL     ANDNE     0                                            CFT004
     C     NewPmtSc2b    ORNE      PrvPmtSc2b                                   CFT014
     C     WIdx_SVAL     ANDEQ     PrvN_Warn                                    CFT014
     C     WIdx_SVAL     ANDNE     0                                            CFT014
     C                   GOTO      EndVAL@S
     C                   END
      *
      * Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       FTEOPY1
     C                   MOVE      *ALL'Y'       FTEOPY2
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      **Go*to*Charges*&*Commissions*screen*****************************         CFT014
      ***********                                                               CFT014
     C***********        MOVEL     'O'           @SCRN                          CFT014
      ** Goto Third screen                                                      CFT014
     C                   If        WScreen3 = 'N'                               CFT014
     C                   ExSr      SNDM@T                                       CFT014
     C                   EndIf                                                  CFT014
     C                   Movel     'B'           @SCRN                          CFT014
     C                   END
      *----------------------------------------------------------------
      *
     C     EndVAL@S      ENDSR
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/SrBMT103                                                        CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/SrBMT103   - Check MT103 agreement                         *         CFT014
      *                                                               *         CFT014
      * Called By: VAL@S subroutine                                   *         CFT014
      *                                                               *         CFT014
      * Calls:                                                        *         CFT014
      * AOCUSTR0  - Access Object to get customer details             *         CFT014
      * AOBRCHR0  - Access Object to get branch details               *         CFT014
      * ME1730    - Determines whether an MT103 exists                *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SrBMT103      BegSr                                                  CFT014
                                                                                CFT014
     C                   Eval      PSNBRC = *Blank                              CFT014
     C                   Eval      PSBICA = *Blank                              CFT014
     C                   Eval      PSWIFT = *Blank                              CFT014
     C                   Eval      PORDBK = *Blank                              CFT014
     C                   Eval      PORTCD = *Blank                              CFT014
     C                   Eval      WSWIFT = *Blank                              CFT014
     C                   Eval      WCNUM = *Blank                               CFT014
                                                                                CFT014
      ** Get SWIFT-BIC of destination                                           CFT014
                                                                                CFT014
     C                   If        @DSTT = 'S'                                  CFT014
     C     11            SubSt     SDST1:1       WSWIFT           11            CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Destination type is a full nostro 'F', customer number 'C'             CFT014
      ** retail account 'R' or GL account 'G', get SWIFT ID through             CFT014
      ** customer number                                                        CFT014
                                                                                CFT014
     C                   If        (@DSTT = 'F') Or (@DSTT = 'C') Or            CFT014
     C                             (@DSTT = 'R') Or (@DSTT = 'G')               CFT014
                                                                                CFT014
     C                   Select                                                 CFT014
     C                   When      @DSTT = 'F'                                  CFT014
     C     3             SubSt     SDST1:1       @CYCD                          CFT014
     C     2             SubSt     SDST1:4       @NONB                          CFT014
     C                   Call      'AONOSTR0'                                   CFT014
     C                   Parm      *Blanks       @RTCD                          CFT014
     C                   Parm      '*KEY   '     @OPTN                          CFT014
     C                   Parm      *Blanks       @CUST             6            CFT014
     C                   Parm                    @CYCD             3            CFT014
     C**********         Parm      *Blanks       @ACCD             4                   CFT014 CGL029
     C                   PARM      *BLANKS       PACCD                                        CGL029
     C                   Parm      *Blanks       @ACSN             2            CFT014
     C                   Parm                    @NONB             2            CFT014
     C                   Parm      *Blanks       @BRCD             3            CFT014
     C                   Parm      *Blanks       @CSSN            10            CFT014
     C                   Parm      *Blanks       @PNOI             1            CFT014
     C     SDNOST        Parm      SDNOST        DSFDY                          CFT014
                                                                                CFT014
      ** Error on call                                                          CFT014
                                                                                CFT014
     C                   If        @RTCD <> *Blanks                             CFT014
     C                   Movel     'SDNOSTPD'    DBFILE                         CFT014
     C                   Movel     '081'         DBASE                          CFT014
     C                   Movel     @CYCD         WKEY              5            CFT014
     C                   Move      @NONB         WKEY                           CFT014
     C                   Movel     WKEY          DBKEY                          CFT014
     C                   Exsr      *PSSR                                        CFT014
     C                   EndIf                                                  CFT014
     C                   Movel     A7CUST        WCNUM            10            CFT014
                                                                                CFT014
     C                   When      @DSTT = 'C'                                  CFT014
     C     10            SubSt     SDST1:1       WCNUM                          CFT014
                                                                                220110
     C                   When      @DSTT = 'R'                                  220110
     C     6             SubSt     @DSTDS:1      WCNUM                          220110
                                                                                CFT014
     C                   Other                                                  CFT014
     C     6             SubSt     SDST1:1       WCNUM                          CFT014
     C                   EndSl                                                  CFT014
                                                                                CFT014
      ** Access customer's file to get SWIFT id                                 CFT014
                                                                                CFT014
     C                   Call      'AOCUSTR0'                                   CFT014
     C                   Parm      *Blanks       @RTCD                          CFT014
     C                   Parm      '*KEY   '     @OPTN                          CFT014
     C                   Parm      WCNUM         @KEY1            10            CFT014
     C                   Parm      *Blanks       @KYST             7            CFT014
     C     SDCUST        Parm      SDCUST        DSSDY                          CFT014
                                                                                CFT014
     C                   If        @RTCD = *Blank                               CFT014
     C                   If        BBCSID <> *Blank                             CFT014
     C                   Movel     BBCSID        WSWIFT                         CFT014
     C                   EndIf                                                  CFT014
     C                   Else                                                   CFT014
     C                   Movel     'SDCUSTPD'    DBFILE                         CFT014
     C                   Movel     '082'         DBASE                          CFT014
     C                   Movel     WCNUM         DBKEY                          CFT014
     C                   Exsr      *PSSR                                        CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** If CSW203 is installed, ME1730 will not be called. Default                           CSW203
      ** PORTCD to '*CRT103'.                                                                 CSW203
                                                                                              CSW203
     C                   IF        CSW203 = 'Y'                                               CSW203
     C                   EVAL      @MT103 = 'Y'                                               CSW203
     C                   ELSE                                                                 CSW203
                                                                                              CSW203
      ** Setup parameter to ME1730                                              CFT014
                                                                                CFT014
     C                   If        WSWIFT <> *Blank                             CFT014
     C                   Movel     SBRCA         PSNBRC                         CFT014
     C**********         Call      'AOBRCHR0'                                          CFT014 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   Parm      *Blanks       @RTCD                          CFT014
     C                   Parm      '*KEY   '     @OPTN                          CFT014
     C                   Parm      SBRCA         @BRCD                          CFT014
     C*****SDBRCH        Parm      SDBRCH        DSFDY                                 CFT014 CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
                                                                                CFT014
     C                   If        @RTCD <> *Blank                              CFT014
     C                   Movel     'SDBRCHPD'    DBFILE                         CFT014
     C                   Movel     '083'         DBASE                          CFT014
     C                   Movel     SBRCA         DBKEY                          CFT014
     C                   Exsr      *PSSR                                        CFT014
     C                   EndIf                                                  CFT014
     C                   Movel     A8BTID        PSBICA                         CFT014
     C                   Movel     WSWIFT        PSWIFT                         CFT014
     C                   Movel     SORBK         PORDBK                         CFT014
                                                                                CFT014
      ** Call ME1730                                                            CFT014
                                                                                CFT014
     C                   Call      'ME1730'                                     CFT014
     C                   Parm                    PSNBRC            3            CFT014
     C                   Parm                    PSBICA           11            CFT014
     C                   Parm                    PSWIFT           11            CFT014
     C                   Parm                    PORDBK          256            CFT014
     C                   Parm                    PBBINF          256            CFT014
     C                   Parm                    PSNCOR          256            CFT014
     C                   Parm                    PRCCOR          256            CFT014
     C                   Parm                    PORTCD            7            CFT014
                                                                                CFT014
     C                   If        PORTCD = '*ERROR '                           CFT014
     C                   Movel     'ME1730'      DBFILE                         CFT014
     C                   Movel     '084'         DBASE                          CFT014
     C                   Movel     '*CALL   '    DBKEY                          CFT014
     C                   Exsr      *PSSR                                        CFT014
     C                   Else                                                   CFT014
     C                   If        PORTCD = '*CRT103'                           CFT014
     C                   Move      'Y'           @MT103                         CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                              CSW203
     C                   ENDIF                                                                CSW203
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/SCRN@B                                                          CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/SCRN@B     - Process Third Screen fields                   *         CFT014
      *                                                               *         CFT014
      * Called By: Main processing                                    *         CFT014
      *                                                               *         CFT014
      * Calls:                                                        *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SCRN@B        BegSr                                                  CFT014
                                                                                CFT014
      ** Update 'previous' screens and previous number of warnings              CFT014
                                                                                CFT014
     C                   MOVEL     NewPmtScn3    PrvPmtScn3                     CFT014
     C                   MOVEL     NewPmtSc3b    PrvPmtSc3b                     CFT014
     C                   Z-ADD     WIdx_BVAL     PrvN_Warn                      CFT014
                                                                                CFT014
      ** Write/Read display screen                                              CFT014
                                                                                CFT014
     C                   Callb     'FTOPAY3DP'                                  CFT014
     C                   Parm      *BLANK        RetCodeOut                     CFT014
     C                   Parm                    NewPmtScn1                     CFT014
     C                   Parm                    NewPmtScn3                     CFT014
     C                   Parm                    NewPmtSc1b                     CFT014
     C                   Parm                    NewPmtSc3b                     CFT014
     C                   Parm                    DDSTAT                         CFT014
     C                   Parm                    FTEOPY1                        CFT014
     C                   Parm                    FTEOPY2                        CFT014
     C                   Parm                    FTEOPY3                        CFT014
     C                   Parm                    FldNameArr                     CFT014
     C                   Parm                    MsgIdArr                       CFT014
     C                   Parm                    MsgDtaArr                      CFT014
     C                   Parm                    WFldNamArr                     CFT014
     C                   Parm                    WMsgIdArr                      CFT014
     C                   Parm                    WMsgDtaArr                     CFT014
     C                   Parm      'N'           @EKYFD                         CFT014
     C                   Parm                    @EDTFD                         CFT014
     C                   Parm      'N'           @EINKD                         CFT014
     C                   Parm      'N'           @EINKQ                         CFT014
     C                   Parm      '0'           @INKC                          CFT014
     C                   Parm      '0'           @INKD                          CFT014
     C                   Parm      '0'           @INKL                          CFT014
     C                   Parm      '0'           @INKQ                          CFT014
     C                   Parm      'N'           WriteOnly                      CFT014
     C                   Parm      0             CursorLoc                      CFT014
                                                                                CFT014
      ** Reset errors                                                           CFT014
                                                                                CFT014
     C                   Move      *All'Y'       FTEOPY1                        CFT014
     C                   Move      *All'Y'       FTEOPY2                        CFT014
     C                   Move      *All'Y'       FTEOPY3                        CFT014
     C                   Movel     *Blank        FldNameArr                     CFT014
     C                   Movel     *Blank        MsgIdArr                       CFT014
     C                   Movel     *Blank        MsgDtaArr                      CFT014
     C                   Movel     *Blank        WFldNamArr                     CFT014
     C                   Movel     *Blank        WMsgIdArr                      CFT014
     C                   Movel     *Blank        WMsgDtaArr                     CFT014
                                                                                CFT014
      ** F3 - End Program                                                       CFT014
                                                                                CFT014
     C     @INKC         CasEq     '1'           ENDP                           CFT014
                                                                                CFT014
      ** F4 - BIC in-line prompt                                                CFT014
                                                                                CFT014
     C     @INKD         CasEq     '1'           BICPrompt                      CFT014
                                                                                CFT014
      ** F12 - Cancel on Secondary Screen                                       CFT014
                                                                                CFT014
     C     @INKL         CasEq     '1'           CANC@B                         CFT014
                                                                                CFT014
      ** F16 - BIC in-line search                                               CFT014
                                                                                CFT014
     C     @INKQ         CasEq     '1'           BICPrompt                      CFT014
                                                                                CFT014
      ** Validate Input to Secondary Screen                                     CFT014
                                                                                CFT014
     C                   Cas                     VAL@B                          CFT014
                                                                                CFT014
     C                   EndCs                                                  CFT014
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/VAL@B                                                           CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/VAL@B      - Validate Input to Third Screen                *         CFT014
      *                                                               *         CFT014
      * Called By: SCRN@B Subroutine                                  *         CFT014
      *                                                               *         CFT014
      * Calls:                                                        *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     VAL@B         BegSr                                                  CFT014
                                                                                CFT014
      ** If insert or amend                                                     CFT014
                                                                                CFT014
     C     SACTION       IfEq      'I'                                          CFT014
     C     SACTION       OrEq      'A'                                          CFT014
                                                                                CFT014
      ** Prior to validation, initialize error indicators as 'OK'               CFT014
                                                                                CFT014
     C                   Z-Add     *Zero         Idx                            CFT014
     C                   Z-Add     *Zero         WIdx                           CFT014
     C                   Z-Add     *Zero         WIdx_BVAL                      CFT014
     C                   Move      *ALL'Y'       FTEOPY1                        CFT014
     C                   Move      *ALL'Y'       FTEOPY2                        CFT014
     C                   Move      *ALL'Y'       FTEOPY3                        CFT014
                                                                                CFT014
      ** Validate Third Screen details                                          CFT014
                                                                                CFT014
     C                   CallB     'FTOPAY3VL'                                  CFT014
     C                   PARM                    RespMode                       CFT014
     C                   PARM                    NewPmtScn1                     CFT014
     C                   PARM                    NewPmtSc2a                     CFT014
     C                   PARM                    NewPmtSc2b                     CFT014
     C                   PARM                    NewPmtScn3                     CFT014
     C                   PARM                    NewPmtSc1b                     CFT014
     C                   PARM                    NewPmtSc3b                     CFT014
     C                   PARM                    ExtData                        CFT014
     C                   PARM                    FTEOPY3                        CFT014
     C                   PARM                    FldNameArr                     CFT014
     C                   PARM                    MsgIDArr                       CFT014
     C                   PARM                    MsgDtaArr                      CFT014
     C                   PARM                    Idx                            CFT014
     C                   PARM                    WFldNamArr                     CFT014
     C                   PARM                    WMsgIDArr                      CFT014
     C                   PARM                    WMsgDtaArr                     CFT014
     C                   PARM                    WIdx                           CFT014
     C                   PARM                    NwPtFilFmt                     CFT014
     C                   PARM                    NwPtFilFmX                     CFT014
     C                   PARM                    Val@Fields                     CFT014
                                                                                CFT014
      ** Update screen validated workfield                                      CFT014
                                                                                CFT014
     C                   If        WScreen3 = 'N'                               CFT014
     C                   Eval      WScreen3 = 'Y'                               CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** If errors returned                                                     CFT014
                                                                                CFT014
     C     Idx           IfNe      0                                            CFT014
     C                   Goto      EndVAL@B                                     CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Re-output the screen                                                   CFT014
                                                                                CFT014
     C                   Eval      Widx_BVAL = Widx_BVAL + Widx                 CFT014
     C     WIdx_BVAL     IfNe      PrvN_Warn                                    CFT014
     C     NewPmtScn3    OrNe      PrvPmtScn3                                   CFT014
     C     WIdx_BVAL     AndEq     PrvN_Warn                                    CFT014
     C     WIdx_BVAL     AndNe     0                                            CFT014
     C     NewPmtSc3b    OrNe      PrvPmtSc3b                                   CFT014
     C     WIdx_BVAL     AndEq     PrvN_Warn                                    CFT014
     C     WIdx_BVAL     AndNe     0                                            CFT014
     C                   Goto      EndVAL@B                                     CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Clear any warning messages                                             CFT014
                                                                                CFT014
     C                   Move      *ALL'Y'       FTEOPY1                        CFT014
     C                   Move      *ALL'Y'       FTEOPY2                        CFT014
     C                   Move      *ALL'Y'       FTEOPY3                        CFT014
     C                   Movel     *BLANK        WFldNamArr                     CFT014
     C                   Movel     *BLANK        WMsgIdArr                      CFT014
     C                   Movel     *BLANK        WMsgDtaArr                     CFT014
                                                                                CFT014
      ** Go to Charges & Commissions screen                                     CFT014
                                                                                CFT014
     C                   If        WScreen4 = 'N'                               CFT014
     C                   ExSr      SNDM@4                                       CFT014
     C                   EndIf                                                  CFT014
     C                   Movel     'O'           @SCRN                          CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C     EndVAL@B      EndSr                                                  CFT014
      /Title Sr/SCRN@A                                                                        CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      * SR/SCRN@A     - Process Cover Message Screen  1               *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
     C     SCRN@A        BEGSR                                                                CSW209
      *                                                                                       CSW209
      ** Update 'previous' screens and previous number of warnings                            CSW209
      *                                                                                       CSW209
     C                   MOVEL     NewPmtScn6    PrvPmtScn6                                   CSW209
     C                   Z-ADD     WIdx_AVAL     PrvN_Warn                                    CSW209
      *                                                                                       CSW209
      ** Write/Read display screen                                                            CSW209
      *                                                                                       CSW209
     C                   CALLB     'FTOPAYADP'                                                CSW209
     C                   PARM      *BLANK        RetCodeOut                                   CSW209
     C                   PARM                    NewPmtScn1                                   CSW209
     C                   PARM                    NwPtFilFmt                                   CSW209
     C                   PARM                    NewPmtScn6                                   CSW209
     C                   PARM                    DDSTAT                                       CSW209
     C                   PARM                    FTEOPYA                                      CSW209
     C                   PARM                    FldNameArr                                   CSW209
     C                   PARM                    MsgIdArr                                     CSW209
     C                   PARM                    MsgDtaArr                                    CSW209
     C                   PARM                    WFldNamArr                                   CSW209
     C                   PARM                    WMsgIdArr                                    CSW209
     C                   PARM                    WMsgDtaArr                                   CSW209
     C                   PARM      'N'           @EKYFD                                       CSW209
     C                   PARM                    @EDTFD                                       CSW209
     C                   PARM      'N'           @EINKD                                       CSW209
     C                   PARM      '0'           @INKC                                        CSW209
     C                   PARM      '0'           @INKD                                        CSW209
     C                   PARM      '0'           @INKL                                        CSW209
     C                   PARM      '0'           @INKE                                        CSW209
     C                   PARM      'N'           WriteOnly                                    CSW209
     C                   PARM      0             CursorLoc                                    CSW209
      *                                                                                       CSW209
      ** Reset errors                                                                         CSW209
      *                                                                                       CSW209
     C                   MOVE      *ALL'Y'       FTEOPYA                                      CSW209
     C                   MOVEL     *BLANK        FldNameArr                                   CSW209
     C                   MOVEL     *BLANK        MsgIdArr                                     CSW209
     C                   MOVEL     *BLANK        MsgDtaArr                                    CSW209
     C                   MOVEL     *BLANK        WFldNamArr                                   CSW209
     C                   MOVEL     *BLANK        WMsgIdArr                                    CSW209
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CSW209
      *                                                                                       CSW209
      ** F3 - End Program                                                                     CSW209
      *                                                                                       CSW209
     C     @INKC         CASEQ     '1'           ENDP                                         CSW209
      *                                                                                       CSW209
      ** F12 - Cancel on Cover message screen                                                 CSW209
      *                                                                                       CSW209
     C     @INKL         CASEQ     '1'           CANC@A                                       CSW209
      *                                                                                       CSW209
      ** Validate Input to Cover message screen                                               CSW209
      *                                                                                       CSW209
     C                   CAS                     VAL@A                                        CSW209
      *                                                                                       CSW209
     C                   ENDCS                                                                CSW209
      *                                                                                       CSW209
     C                   ENDSR                                                                CSW209
      *****************************************************************                       CSW209
      /Title Sr/VAL@A                                                                         CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      * SR/VAL@A      - Validate Cover message information  Screen 1  *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
     C     VAL@A         BEGSR                                                                CSW209
      *                                                                                       CSW209
      ** If insert or amend                                                                   CSW209
      *                                                                                       CSW209
     C     SACTION       IFEQ      'I'                                                        CSW209
     C     SACTION       OREQ      'A'                                                        CSW209
      *                                                                                       CSW209
      ** Prior to validation, initialize error indicators as 'OK'                             CSW209
      *                                                                                       CSW209
     C                   Z-ADD     *Zero         Idx                                          CSW209
     C                   Z-ADD     *Zero         WIdx                                         CSW209
     C                   Z-ADD     *Zero         WIdx_AVAL                                    CSW209
     C                   MOVE      *ALL'Y'       FTEOPYA                                      CSW209
      *                                                                                       CSW209
      ** Validate Cover message info details Screen 1                                         CSW209
      *                                                                                       CSW209
     C                   CALLB     'FTOPAYAVL'                                                CSW209
     C                   PARM                    RespMode                                     CSW209
     C                   PARM                    NewPmtScn1                                   CSW209
     C                   PARM                    NwPtFilFmt                                   CSW209
     C                   PARM                    NwPtFilFmx                                   CSW209
     C                   PARM                    NewPmtScn6                                   CSW209
     C                   PARM                    FTEOPYA                                      CSW209
     C                   PARM                    FldNameArr                                   CSW209
     C                   PARM                    MsgIDArr                                     CSW209
     C                   PARM                    MsgDtaArr                                    CSW209
     C                   PARM                    Idx                                          CSW209
     C                   PARM                    WFldNamArr                                   CSW209
     C                   PARM                    WMsgIDArr                                    CSW209
     C                   PARM                    WMsgDtaArr                                   CSW209
     C                   PARM                    WIdx                                         CSW209
      *                                                                                       CSW209
      ** If errors returned                                                                   CSW209
      *                                                                                       CSW209
     C     Idx           IFNE      0                                                          CSW209
     C                   EVAL      @SCRN = 'A'                                                CSW209
     C                   LEAVESR                                                              CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Re-output the screen                                                                 CSW209
      *                                                                                       CSW209
     C                   EVAL      WIdx_AVAL = WIdx_AVAL + Widx                               CSW209
     C     WIdx_AVAL     IFNE      PrvN_Warn                                                  CSW209
     C     NewPmtScn6    ORNE      PrvPmtScn6                                                 CSW209
     C     WIdx_AVAL     ANDEQ     PrvN_Warn                                                  CSW209
     C     WIdx_AVAL     ANDNE     0                                                          CSW209
     C                   LEAVESR                                                              CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Clear any warning messages                                                           CSW209
      *                                                                                       CSW209
     C                   MOVE      *ALL'Y'       FTEOPYA                                      CSW209
      *                                                                                       CSW209
     C                   MOVEL     *BLANK        WFldNamArr                                   CSW209
     C                   MOVEL     *BLANK        WMsgIdArr                                    CSW209
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CSW209
      *                                                                                       CSW209
      **  If there are no errors Goto Next Screen                                             CSW209
      *                                                                                       CSW209
     C                   MOVEL     'D'           @SCRN                                        CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   ENDSR                                                                CSW209
      *****************************************************************                       CSW209
      /Title Sr/CANC@D                                                                        CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      * SR/CANC@A     - Cancel on Cover Message  Screen  1            *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
     C     CANC@A        BEGSR                                                                CSW209
      *                                                                                       CSW209
      ** Return to Charges and Commissions Screen                                             CSW209
      *                                                                                       CSW209
     C                   MOVEL     'O'           @SCRN                                        CSW209
      *                                                                                       CSW209
     C                   ENDSR                                                                CSW209
      /Title Sr/SCRN@D                                                                        CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      * SR/SCRN@D     - Process Cover Message 2nd Screen              *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
     C     SCRN@D        BEGSR                                                                CSW209
      *                                                                                       CSW209
      ** Update 'previous' screens and previous number of warnings                            CSW209
      *                                                                                       CSW209
     C                   MOVEL     NEWPMTSCN7    PrvPmtScn7                                   CSW209
     C                   Z-ADD     WIdx_DVAL     PrvN_Warn                                    CSW209
      *                                                                                       CSW209
      ** Write/Read display screen                                                            CSW209
      *                                                                                       CSW209
     C                   CALLB     'FTOPAYCDP'                                                CSW209
     C                   PARM      *BLANK        RetCodeOut                                   CSW209
     C                   PARM                    NewPmtScn1                                   CSW209
     C                   PARM                    NwPtFilFmt                                   CSW209
     C                   PARM                    NEWPMTSCN7                                   CSW209
     C                   PARM                    DDSTAT                                       CSW209
     C                   PARM                    FTEOPYC                                      CSW209
     C                   PARM                    FldNameArr                                   CSW209
     C                   PARM                    MsgIdArr                                     CSW209
     C                   PARM                    MsgDtaArr                                    CSW209
     C                   PARM                    WFldNamArr                                   CSW209
     C                   PARM                    WMsgIdArr                                    CSW209
     C                   PARM                    WMsgDtaArr                                   CSW209
     C                   PARM      'N'           @EKYFD                                       CSW209
     C                   PARM                    @EDTFD                                       CSW209
     C                   PARM      'N'           @EINKD                                       CSW209
     C                   PARM      '0'           @INKC                                        CSW209
     C                   PARM      '0'           @INKD                                        CSW209
     C                   PARM      '0'           @INKL                                        CSW209
     C                   PARM      '0'           @INKE                                        CSW209
     C                   PARM      'N'           WriteOnly                                    CSW209
     C                   PARM      0             CursorLoc                                    CSW209
                                                                                              CSW209
      ** Reset errors                                                                         CSW209
                                                                                              CSW209
     C                   MOVE      *All'Y'       FTEOPYC                                      CSW209
     C                   MOVEL     *Blank        FldNameArr                                   CSW209
     C                   MOVEL     *Blank        MsgIdArr                                     CSW209
     C                   MOVEL     *Blank        MsgDtaArr                                    CSW209
     C                   MOVEL     *Blank        WFldNamArr                                   CSW209
     C                   MOVEL     *Blank        WMsgIdArr                                    CSW209
     C                   MOVEL     *Blank        WMsgDtaArr                                   CSW209
      *                                                                                       CSW209
      ** F3 - End Program                                                                     CSW209
      *                                                                                       CSW209
     C     @INKC         CASEQ     '1'           ENDP                                         CSW209
      *                                                                                       CSW209
      ** F12 - Cancel on Cover message screen                                                 CSW209
      *                                                                                       CSW209
     C     @INKL         CASEQ     '1'           CANC@D                                       CSW209
      *                                                                                       CSW209
      ** Validate Input to Cover message screen                                               CSW209
      *                                                                                       CSW209
     C                   CAS                     VAL@D                                        CSW209
      *                                                                                       CSW209
     C                   ENDCS                                                                CSW209
      *                                                                                       CSW209
     C                   ENDSR                                                                CSW209
      *****************************************************************                       CSW209
      /Title Sr/VAL@D                                                                         CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      * SR/VAL@D      - Validate Cover message information screen 2   *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
     C     VAL@D         BEGSR                                                                CSW209
      *                                                                                       CSW209
      ** If insert or amend                                                                   CSW209
      *                                                                                       CSW209
     C     SACTION       IFEQ      'I'                                                        CSW209
     C     SACTION       OREQ      'A'                                                        CSW209
      *                                                                                       CSW209
      ** Prior to validation, initialize error indicators as 'OK'                             CSW209
      *                                                                                       CSW209
     C                   Z-ADD     *Zero         Idx                                          CSW209
     C                   Z-ADD     *Zero         WIdx                                         CSW209
     C                   Z-ADD     *Zero         WIdx_DVAL                                    CSW209
     C                   MOVE      *ALL'Y'       FTEOPYC                                      CSW209
      *                                                                                       CSW209
      ** Validate Cover message info details Screen 2                                         CSW209
      *                                                                                       CSW209
     C                   CALLB     'FTOPAYCVL'                                                CSW209
     C                   PARM                    RespMode                                     CSW209
     C                   PARM                    NwPtFilFmt                                   CSW209
     C                   PARM                    NwPtFilFmx                                   CSW209
     C                   PARM                    NewPmtScn1                                   CSW209
     C                   PARM                    NewPmtSc1b                                 BUG26775
     C                   PARM                    NewPmtSc2a                                 BUG26548
     C                   PARM                    NewPmtSc2b                                   CSW209
     C                   PARM                    NewPmtScn3                                   CSW209
     C                   PARM                    NEWPMTSCN6                                   CSW209
     C                   PARM                    NEWPMTSCN7                                   CSW209
     C                   PARM                    FTEOPYC                                      CSW209
     C                   PARM                    FldNameArr                                   CSW209
     C                   PARM                    MsgIDArr                                     CSW209
     C                   PARM                    MsgDtaArr                                    CSW209
     C                   PARM                    Idx                                          CSW209
     C                   PARM                    WFldNamArr                                   CSW209
     C                   PARM                    WMsgIDArr                                    CSW209
     C                   PARM                    WMsgDtaArr                                   CSW209
     C                   PARM                    WIdx                                         CSW209
      *                                                                                       CSW209
      ** If errors returned                                                                   CSW209
      *                                                                                       CSW209
     C     Idx           IFNE      0                                                          CSW209
     C                   EVAL      @SCRN = 'D'                                                CSW209
     C                   LEAVESR                                                              CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Re-output the screen                                                                 CSW209
      *                                                                                       CSW209
     C                   EVAL      WIdx_DVAL = WIdx_DVAL + Widx                               CSW209
     C     WIdx_DVAL     IFNE      PrvN_Warn                                                  CSW209
     C     NewPmtScn7    ORNE      PrvPmtScn7                                                 CSW209
     C     WIdx_DVAL     ANDEQ     PrvN_Warn                                                  CSW209
     C     WIdx_DVAL     ANDNE     0                                                          CSW209
     C                   LEAVESR                                                              CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Clear any warning messages                                                           CSW209
      *                                                                                       CSW209
     C                   MOVE      *ALL'Y'       FTEOPYC                                      CSW209
      *                                                                                       CSW209
     C                   MOVEL     *BLANK        WFldNamArr                                   CSW209
     C                   MOVEL     *BLANK        WMsgIdArr                                    CSW209
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CSW209
      *                                                                                       CSW209
      * Go To First screen for confirmation.                                                  CSW209
      *                                                                                       CSW209
     C                   MOVEL     'C'           @SCRN                                        CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   ENDSR                                                                CSW209
      *****************************************************************                       CSW209
      /Title Sr/CANC@D                                                                        CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      * SR/CANC@D     - Cancel on Cover Message  Screen  2            *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
     C     CANC@D        BEGSR                                                                CSW209
      *                                                                                       CSW209
      ** Return 1st Scree of Cover Message                                                    CSW209
      *                                                                                       CSW209
     C                   MOVEL     'A'           @SCRN                                        CSW209
      *                                                                                       CSW209
     C                   ENDSR                                                                CSW209
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@O - PROCESS CHARGES & COMMISSIONS SCREEN
      *****************************************************************
     C     SCRN@O        BEGSR
 
      * IF INSERT
      * DO DEFAULTING FOR CHARGES & COMMISSIONS SCREEN
      * (Only do this once per transaction unless details on other screens
      *  have changed)
      *
     C*****SACTION       IFEQ      'I'                                          CFT014
     C*****NewPmtScn1    IFNE      PrvPmtScn1                                   CFT014
     C*****NewPmtSc2a    ORNE      PrvPmtSc2a                                   CFT014
     C*****NewPmtSc2b    ORNE      PrvPmtSc2b                                   CFT014
     C***********        EXSR      DFT@O                                        CFT014
     C***********        END                                                    CFT014
     C***********        END                                                    CFT014
      *
      * IF AMEND OR ENQUIRE
      * Do charges and VAT calculations only if first time through
      * for transaction.
     C*****SACTION       IFNE      'I'                                          CFT014
     C*****SPREF         IFNE      #SPREF                                       CFT014
     C***********        EXSR      DFT@O                                        CFT014
     C***********        MOVE      SPREF         #SPREF           15            CFT014
     C***********        END                                                    CFT014
     C***********        END                                                    CFT014
                                                                                CFT014
      *                                                                                       CER030
      ** F19 - Margin Information /Extended Narratives                                        CER030
      *                                                                                       CER030
     C                   IF        (CER030 = 'Y') OR                                          CER030
     C                             (CER031 = 'Y') OR                                          CER030
     C                             (CGL013 = 'Y')                                             CER030
     C                   EVAL      @EINKT = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
      ** Setup F19 Key for Margin Information when Analytical Accoun -          CFT014
      ** ting is On.                                                            CFT014
                                                                                CFT014
     C                   If        BGN0ST = 'Y'                                 CFT014
     C                   Select                                                 CFT014
     C                   When      SACTION = 'E'                                CFT014
     C                   Eval      @EINKT = 'Y'                                 CFT014
                                                                                CFT014
      ** Margin Info will not be available during insert or amend when          CFT014
      ** payment and settlement currency are equal and the margin               CFT014
      ** info details are blanks.                                               CFT014
                                                                                CFT014
     C                   When      (SACTION = 'I') Or (SACTION = 'A')           CFT014
     C                   If        (SPCCY = SSMCY) And (SMBSI = *Blank) And     CFT014
     C                             (SMSIG = *Blank)                             CFT014
     C                   Eval      @EINKT = 'N'                                 CFT014
     C                   Else                                                   CFT014
     C                   Eval      @EINKT = 'Y'                                 CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   EndSl                                                  CFT014
     C                   EndIf                                                  CFT014
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
 
      * Update 'previous' screens and previous number of warnings
 
     C                   MOVEL     NewPmtScn1    PrvPmtScn1
     C                   MOVEL     NewPmtSc1b    PrvPmtSc1b                     CFT014
     C                   MOVEL     NewPmtSc2a    PrvPmtSc2a
     C                   MOVEL     NewPmtSc2b    PrvPmtSc2b
     C                   MOVEL     NewPmtScn3    PrvPmtScn3
     C                   MOVEL     NewPmtSc3b    PrvPmtSc3b                     CFT014
     C                   MOVEL     NewPmtScn4    PrvPmtScn4                     CFT014
     C                   Z-ADD     WIdx_OVAL     PrvN_Warn         3 0
 
      ** WRITE/READ DISPLAY - Charges Commissions Screen
      *
     C***********        CALLB     'FTOPAY3DP'                                  CFT014
     C                   CALLB     'FTOPAY4DP'                                  CFT014
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS:
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      * Payment (IN SCREEN FORMAT) - Primary/Secondary/Other Details
     C                   PARM                    NewPmtScn1
     C                   PARM                    NewPmtSc1b                     CFT014
     C                   PARM                    NewPmtSc2a
     C                   PARM                    NewPmtSc2b
     C                   PARM                    NewPmtScn3
     C                   PARM                    NewPmtSc3b                     CFT014
     C                   PARM                    NewPmtScn4                     CFT014
      *
      * Status
     C                   PARM                    DDSTAT
      *
      * Fields in error
     C                   PARM                    FTEOPY1
     C                   PARM                    FTEOPY2
     C                   PARM                    FTEOPY3
     C                   PARM                    FTEOPY4                        CFT014
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED DETAIL FIELDS
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      * ENABLED FUNCTION KEYS                                                   CFT007
      * KD = COMMAND KEYS 04/16 = BIC IN-LINE PROMPT/SEARCH                     CFT007
     C**********         PARM                    @EINKD                                CFT007 CFT014
     C**********         PARM                    @EINKQ                                CFT007 CFT014
     C                   PARM      'N'           @EINKD                                       CFT014
     C                   PARM      'N'           @EINKQ                                       CFT014
     C                   PARM                    @EINKT            1                          CFT014
 
      ** OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKD             1            CFT007
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKQ             1            CFT007
     C                   PARM      '0'           @INKT             1            CFT014
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
      * Cursor location on screen                                               CFT007
     C                   PARM      0             CursorLoc                      CFT007
      *  Validation Work Fields from/to caller
     C                   PARM                    Val@Fields
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG          1            CFT009
 
      *
      * RESET ERRORS ....
      *
     C***********        MOVE      *ALL'Y'       FTEOPY3                        CFT014
     C                   MOVE      *ALL'Y'       FTEOPY4                        CFT014
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *                                                                         CFT007
      * F4 - BIC in-line prompt                                                 CFT007
     C     @INKD         CASEQ     '1'           BICPrompt                      CFT007
      *
      * F12 - Cancel on Other Details Screen
     C     @INKL         CASEQ     '1'           CANC@O
      *                                                                         CFT007
      * F16 - BIC in-line search                                                CFT007
     C     @INKQ         CASEQ     '1'           BICPrompt                      CFT007
                                                                                CFT014
      ** F19 - Margin Information                                               CFT014
                                                                                CFT014
     C     @INKT         CASEQ     '1'           SCRN@M                         CFT014
      *
      * Validate Input to Charges & Comissions Screen
     C                   CAS                     VAL@O
      *
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DFT@O   - DEFAULTING FOR CHARGES & COMMISSIONS SCREEN
      *****************************************************************
     C     DFT@O         BEGSR
      *
     C                   CALLB     'FTOPAY3DT'
      *
      * INPUTS :
      * Response mode
     C                   PARM                    RespMode
      ** Payment Primary Details
      ** Payment Secondary Details
      ** Payment Charge & Commissions
     C                   PARM                    NewPmtScn1
     C                   PARM                    NewPmtSc2a
     C                   PARM                    NewPmtSc2b
     C                   PARM                    NewPmtScn3
     C                   PARM                    NewPmtScn4                     CFT014
 
      * Transaction information (DS) in file format
     C                   PARM                    CrPtFilFmt
 
      * Custom Extra Data file data
     C                   PARM                    ExtData
      *
      *  Funds transfer Details
     C                   Parm                    SDFTFR
      *                                                                                       187056
      ** Recalcution flag.                                                                    187056
     C                   PARM                    PReCalc           1                          187056
 
      * OUTPUTS :
 
      ** OK inds
     C                   PARM                    FTEOPY1
     C***********        PARM                    FTEOPY2                        CFT014
     C***********        PARM                    FTEOPY3                        CFT014
     C                   PARM                    FTEOPY4                        CFT014
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      * Valid Payment layout (DS) from/to caller
     C                   PARM                    NwPtFilFmt
      *  Validation Work Fields from/to caller
     C                   PARM                    Val@Fields
      *  Extra rate required for FTVCHPY module                                 CFT009
     C                   Parm                    O2XRTE                         CFT009
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@O  - VALIDATE INPUT TO CHARGES & COMMISSIONS SCREEN
      *****************************************************************
     C     VAL@O         BEGSR
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND
      *
     C     SACTION       IFEQ      'I'
     C     SACTION       OREQ      'A'
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   Z-ADD     *ZERO         WIdx_OVAL         3 0
     C***********        MOVE      *ALL'Y'       FTEOPY3                        CFT014
     C                   MOVE      *ALL'Y'       FTEOPY4                        CFT014
      *                                                                                       187056
      ** Check if charges needs to be recalculated.                                           187056
      *                                                                                       187056
     C                   EXSR      SRReCalc                                                   187056
      *
      * Validate "Charges & Comissions" Screen
      *
     C***********        CALLB     'FTOPAY3VL'                                  CFT014
     C                   CALLB     'FTOPAY4VL'                                  CFT014
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Response mode
     C                   PARM                    RespMode
      ** Payment Primary Details
      ** Payment Secondary Details
      ** Payment Charge & Commissions
     C                   PARM                    NewPmtScn1
     C                   PARM                    NewPmtSc2a
     C                   PARM                    NewPmtSc2b
     C                   PARM                    NewPmtScn3
     C                   PARM                    NewPmtSc1b                     CFT014
     C                   PARM                    NewPmtSc3b                     CFT014
     C                   PARM                    NewPmtScn4                     CFT014
      * Custom Extra Data file data
     C                   PARM                    ExtData
     C                   PARM                    PReDspChg                                    200149
      *
      * OUTPUTS :
 
      ** Payment Charge & Commissions OK inds
     C***********        PARM                    FTEOPY3                        CFT014
     C                   PARM                    FTEOPY4                        CFT014
 
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
 
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
 
      * Valid Payment layout (DS) from/to caller
     C                   PARM                    NwPtFilFmt
     C                   PARM                    NwPtFilFmX                     CFT014
      *  Validation Work Fields from/to caller
     C                   PARM                    Val@Fields
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG          1            CFT009
                                                                                CFT014
      ** Update screen validated workfield                                      CFT014
                                                                                CFT014
     C                   If        WScreen4 = 'N'                               CFT014
     C                   Eval      WScreen4 = 'Y'                               CFT014
     C                   EndIf                                                  CFT014
 
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@O
     C                   END
      *
      * or if there are warnings which have not been displayed
      *   re-output the screen
      *
     C                   Eval      Widx_OVAL = Widx_OVAL + Widx
     C     WIdx_OVAL     IFNE      PrvN_Warn
     C*****NewPmtScn3    ORNE      PrvPmtScn3                                   CFT004 CFT014
     C     NewPmtScn4    ORNE      PrvPmtScn4                                   CFT014
     C     WIdx_OVAL     ANDEQ     PrvN_Warn                                    CFT004
     C     WIdx_OVAL     ANDNE     0                                            CFT004
     C     WReDspChg     ORNE      'N'                                                        187056
     C                   GOTO      EndVAL@O
     C                   END
      *
      * Clear any warning messages
      *
     C***********        MOVE      *ALL'Y'       FTEOPY3                        CFT014
     C                   MOVE      *ALL'Y'       FTEOPY4                        CFT014
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *                                                                                       CER030
      ** If transaction type is not linked to transaction code                                CER030
      ** display screen                                                                       CER030
      *                                                                                       CER030
     C                   IF        (CER030 = 'Y') OR                                          CER030
     C                             (CGL013 = 'Y') OR                                          CER030
     C                             (CER031 = 'Y')                                             CER030
      *                                                                                       CER030
     C                   CALLB     'FTOPAY5VL'                                                CER030
     C                   PARM                    RespMode                                     CER030
     C                   PARM                    NewPmtScn1                                   CER030
     C                   PARM                    NewPmtScn5                                   CER030
      *                                                                                       CER030
     C                   PARM                    NewPmtScn5A                                  CER030
     C                   PARM                    NewPmtScn5B                                  CER030
     C                   PARM                    STRTC                                        CER030
      *                                                                                       CER030
     C                   PARM                    ExtData                                      CER030
     C                   PARM                    FTEOPY5                                      CER030
     C                   PARM                    FldNameArr                                   CER030
     C                   PARM                    MsgIDArr                                     CER030
     C                   PARM                    MsgDtaArr                                    CER030
     C                   PARM                    Idx                                          CER030
     C                   PARM                    WFldNamArr                                   CER030
     C                   PARM                    WMsgIDArr                                    CER030
     C                   PARM                    WMsgDtaArr                                   CER030
     C                   PARM                    WIdx                                         CER030
     C                   PARM                    NwPtFilFmt                                   CER030
     C                   PARM                    Val@Fields                                   CER030
     C                   PARM                    O2TTCD                                       CER030
      *                                                                                       CER030
      ** Update error information.                                                            CER030
      *                                                                                       CER030
     C                   IF        Idx <> *ZEROS                                              CER030
      *                                                                                       CER030
     C                   MOVEL     'M'           @SCRN                                        CER030
      *                                                                                       CER030
     C     @SCRN         DOWEQ     'M'                                                        CER030
     C                   EXSR      SCRN@M                                                     CER030
     C                   ENDDO                                                                CER030
      *                                                                                       CER030
     C                   GOTO      EndVAL@O                                                   CER030
     C                   ENDIF                                                                CER030
     C                   ENDIF                                                                CER030
      *
      * Go To First screen for confirmation.
      *
     C                   IF        @OPSEL <> 'N'                                             BUG9075
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   MOVEL     'A'           @SCRN                                        CSW209
     C                   ELSE                                                                 CSW209
     C                   MOVEL     'C'           @SCRN
     C/COPY WNCPYSRC,FTH00346
     C                   ENDIF                                                                CSW209
     C                   ELSE                                                                BUG9075
     C     @RDNB         IFEQ      'Y'                                                       BUG9075
     C                   MOVEL     'R'           @SCRN                                       BUG9075
     C                   ELSE                                                                BUG9075
     C                   MOVEL     'I'           @SCRN                                       BUG9075
     C                   ENDIF                                                               BUG9075
     C                   ENDIF                                                               BUG9075
     C                   IF        ULX043 = 'Y'                                               CER001
     C                   EVAL      @SCRN = 'L'                                                CER001
     C                   ENDIF                                                                CER001
      *
     C                   END
      *----------------------------------------------------------------
      *
     C     EndVAL@O      ENDSR
                                                                                CFT014
      *****************************************************************         CFT014
      /EJECT                                                                                  187056
      *****************************************************************                       187056
      *                                                               *                       187056
      *  SRReCalc - Perform recalculation of charges.                 *                       187056
      *                                                               *                       187056
      *****************************************************************                       187056
      *                                                                                       187056
     C     SRReCalc      BEGSR                                                                187056
      *                                                                                       187056
     C                   MOVE      *BLANKS       W0FCUS            6                          187056
     C                   MOVE      *BLANKS       W0SCUS            6                          187056
     C                   MOVE      'N'           WReDspChg         1                          187056
      *                                                                                       187056
      ** Perform the following only if core feature S01508                                    187056
      ** (BLI Extended Payment Charges) is installed and core                                 187056
      ** feature S01506 (BLI Payment Charges Enhancements)                                    187056
      ** is NOT installed.  Get "Charges to the Debit of"                                     187056
      ** Customer using FT0035 based on Level 2 details.                                      187056
      *                                                                                       187056
     C     @01508        IFEQ      'Y'                                                        187056
     C     @01506        ANDNE     'Y'                                                        187056
      *                                                                                       187056
      ** Get previous "Charges to the Debit of" Customer.                                     187056
      *                                                                                       187056
     C                   CLEAR                   P0DTA                                        187056
      *                                                                                       187056
     C     WPrvCDRT      IFNE      *BLANKS                                                    187056
     C                   MOVE      WPrvCDRT      WIPT1                                        187056
     C     @PSCDRO       CAT(P)    @PSCDBR       WIPTY1                                       187056
     C                   MOVE      BJCYCD        WICCY                                        187056
      *                                                                                       187056
     C                   CALL      'FT0035'                             9090                  187056
     C                   PARM      *BLANKS       @RTCD                                        187056
     C                   PARM                    P0DTA                                        187056
     C                   PARM                    P0MSG           256                          187056
      *                                                                                       187056
     C     *IN90         IFEQ      *ON                                                        187056
     C     @RTCD         ORNE      *BLANKS                                                    187056
     C                   MOVEL     '*CALL'       DBKEY                                        187056
     C                   MOVEL     'FT0035'      DBFILE                                       187056
     C                   Z-ADD     36            DBASE                                        187056
     C                   EXSR      *PSSR                                                      187056
     C                   ENDIF                                                                187056
      *                                                                                       187056
     C                   MOVE      WOCUST        W0FCUS                                       187056
      *                                                                                       187056
     C                   ENDIF                                                                187056
      *                                                                                       187056
      ** Get new "Charges to the Debit of" Customer.                                          187056
      *                                                                                       187056
     C                   CLEAR                   P0DTA                                        187056
      *                                                                                       187056
     C     OTCDRT        IFNE      *BLANKS                                                    187056
     C                   MOVE      OTCDRT        WIPT1                                        187056
     C     SCDRO         CAT(P)    SCDBR         WIPTY1                                       187056
     C                   MOVE      BJCYCD        WICCY                                        187056
      *                                                                                       187056
     C                   CALL      'FT0035'                             9090                  187056
     C                   PARM      *BLANKS       @RTCD                                        187056
     C                   PARM                    P0DTA                                        187056
     C                   PARM                    P0MSG                                        187056
      *                                                                                       187056
     C     *IN90         IFEQ      *ON                                                        187056
     C     @RTCD         ORNE      *BLANKS                                                    187056
     C                   MOVEL     '*CALL'       DBKEY                                        187056
     C                   MOVEL     'FT0035'      DBFILE                                       187056
     C                   Z-ADD     37            DBASE                                        187056
     C                   EXSR      *PSSR                                                      187056
     C                   ENDIF                                                                187056
      *                                                                                       187056
     C                   MOVE      WOCUST        W0SCUS                                       187056
     C                   ENDIF                                                                187056
      *                                                                                       187056
     C                   ENDIF                                                                187056
      *                                                                                       187056
      ** Call defaulting program to recalculate charges.                                      187056
      *                                                                                       187056
     C     SCDRO         IFNE      @PSCDRO                                                    187056
     C     SCDBR         ORNE      @PSCDBR                                                    187056
     C     W0FCUS        ORNE      W0SCUS                                                     187056
     C                   EVAL      PReCalc = 'Y'                                              187056
     C                   EXSR      DFT@O                                                      187056
     C                   EVAL      PReCalc = 'N'                                              187056
     C                   EVAL      WPrvCDRT = OTCDRT                                          187056
     C                   EVAL      WReDspChg = 'Y'                                            187056
     C                   ENDIF                                                                187056
      *                                                                                       187056
     C                   ENDSR                                                                187056
      *                                                                                       187056
      *****************************************************************                       187056
      /Title Sr/SCRN@M                                                          CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/SCRN@M     - Process Margin Information Screen             *         CFT014
      *                                                               *         CFT014
      * Called By: VAL@B Subroutine                                   *         CFT014
      *                                                               *         CFT014
      * Calls:                                                        *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SCRN@M        BegSr                                                  CFT014
                                                                                CFT014
      *                                                                                       CER030
     C                   IF        (SACTION = 'I' AND @OPSEL = 'U' OR                         CER030
     C                             SACTION = 'A' AND @OPSEL = 'U')                            CER030
      *                                                                                       CER030
      ** Default Retail Transaction Type from Transaction code                                CER030
      ** If Retail Transaction type is blank                                                  CER030
      *                                                                                       CER030
     C                   IF        CER030 = 'Y' OR CGL013 = 'Y'                               CER030
     C                   IF        STRTC <> *BLANKS AND @CFT014 = 'Y'                         CER030
     C                             AND SRTTY = *BLANKS AND                                    CER030
     C                             WFlg = 'N'                                                 CER030
      *                                                                                       CER030
     C                   EVAL      KTtcd = STRTC                                              CER030
      *                                                                                       CER030
     C     KTtcd         CHAIN     SDNTTIL1                                                   CER030
     C                   IF        %FOUND (SDNTTIL1)                                          CER030
     C                   EVAL      SRTTY = NIRTTY                                             CER030
     C                   ENDIF                                                                CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
     C                   EVAL      WFlg = 'Y'                                                 CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Update 'previous' screens and previous number of warnings              CFT014
                                                                                CFT014
     C                   Movel     NewPmtScn5    PrvPmtScn5                     CFT014
     C                   MOVEL     NewPmtScn5A   PrvPmtScn5A                                  CER030
     C                   MOVEL     NewPmtScn5B   PrvPmtScn5B                                  CER030
     C                   Z-Add     WIdx_MVAL     PrvN_Warn                      CFT014
                                                                                CFT014
      ** Load error messages for Margin Information screen.                     CFT014
                                                                                CFT014
     C                   If        WScreen5 = 'N'                               CFT014
     C                   ExSr      SNDM@5                                       CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Write/Read display screen                                              CFT014
                                                                                CFT014
     C                   Callb     'FTOPAY5DP'                                  CFT014
     C                   Parm      *BLANK        RetCodeOut                     CFT014
     C                   Parm                    NewPmtScn1                     CFT014
     C                   Parm                    NewPmtScn5                     CFT014
     C                   PARM                    NewPmtScn5A                                  CER030
     C                   PARM                    NewPmtScn5B                                  CER030
     C                   Parm                    DDSTAT                         CFT014
     C                   Parm                    FTEOPY5                        CFT014
     C                   Parm                    FldNameArr                     CFT014
     C                   Parm                    MsgIdArr                       CFT014
     C                   Parm                    MsgDtaArr                      CFT014
     C                   Parm                    WFldNamArr                     CFT014
     C                   Parm                    WMsgIdArr                      CFT014
     C                   Parm                    WMsgDtaArr                     CFT014
     C                   Parm      'N'           @EKYFD                         CFT014
     C                   Parm                    @EDTFD                         CFT014
     C                   Parm      '0'           @INKC                          CFT014
     C                   Parm      '0'           @INKL                          CFT014
     C                   Parm      '0'           @INKE             1            CFT014
     C                   Parm      'N'           WriteOnly                      CFT014
     C                   Parm      0             CursorLoc                      CFT014
     C                   PARM                    Val@Fields                                   222373
                                                                                CFT014
      ** Reset errors                                                           CFT014
                                                                                CFT014
     C                   Move      *All'Y'       FTEOPY5                        CFT014
     C                   Movel     *Blank        FldNameArr                     CFT014
     C                   Movel     *Blank        MsgIdArr                       CFT014
     C                   Movel     *Blank        MsgDtaArr                      CFT014
     C                   Movel     *Blank        WFldNamArr                     CFT014
     C                   Movel     *Blank        WMsgIdArr                      CFT014
     C                   Movel     *Blank        WMsgDtaArr                     CFT014
                                                                                CFT014
      ** F3 - End Program                                                       CFT014
                                                                                CFT014
     C     @INKC         CasEq     '1'           ENDP                           CFT014
                                                                                CFT014
      ** F12 - Cancel on Margin Info Screen                                     CFT014
                                                                                CFT014
     C     @INKL         CasEq     '1'           CANC@M                         CFT014
                                                                                CFT014
      ** F5 - Refresh                                                           CFT014
                                                                                CFT014
     C     @INKE         CasEq     '1'           REFR@M                         CFT014
                                                                                CFT014
      ** Validate Input to Margin Info Screen                                   CFT014
                                                                                CFT014
     C                   Cas                     VAL@M                          CFT014
                                                                                CFT014
     C                   EndCs                                                  CFT014
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/VAL@M                                                           CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/VAL@M      - Validate Margin Informations                  *         CFT014
      *                                                               *         CFT014
      * Called By: SCRN@M Subroutine                                  *         CFT014
      *                                                               *         CFT014
      * Calls:                                                        *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     VAL@M         BegSr                                                  CFT014
                                                                                CFT014
      ** If insert or amend                                                     CFT014
                                                                                CFT014
     C     SACTION       IfEq      'I'                                          CFT014
     C     SACTION       OrEq      'A'                                          CFT014
                                                                                CFT014
      ** Prior to validation, initialize error indicators as 'OK'               CFT014
                                                                                CFT014
     C                   Z-Add     *Zero         Idx                            CFT014
     C                   Z-Add     *Zero         WIdx                           CFT014
     C                   Z-Add     *Zero         WIdx_MVAL         3 0          CFT014
     C                   Move      *ALL'Y'       FTEOPY5                        CFT014
                                                                                CFT014
      ** Validate Margin Info details                                           CFT014
                                                                                CFT014
     C                   CallB     'FTOPAY5VL'                                  CFT014
     C                   PARM                    RespMode                       CFT014
     C                   PARM                    NewPmtScn1                     CFT014
     C                   PARM                    NewPmtScn5                     CFT014
     C                   PARM                    NewPmtScn5A                                  CER030
     C                   PARM                    NewPmtScn5B                                  CER030
     C                   PARM                    STRTC                                        CER030
     C                   PARM                    ExtData                        CFT014
     C                   PARM                    FTEOPY5                        CFT014
     C                   PARM                    FldNameArr                     CFT014
     C                   PARM                    MsgIDArr                       CFT014
     C                   PARM                    MsgDtaArr                      CFT014
     C                   PARM                    Idx                            CFT014
     C                   PARM                    WFldNamArr                     CFT014
     C                   PARM                    WMsgIDArr                      CFT014
     C                   PARM                    WMsgDtaArr                     CFT014
     C                   PARM                    WIdx                           CFT014
     C                   PARM                    NwPtFilFmt                     CFT014
     C                   PARM                    Val@Fields                     CFT014
     C                   PARM                    O2TTCD                                       CER030
                                                                                CFT014
      ** Update screen validated workfield                                      CFT014
                                                                                CFT014
     C                   If        WScreen5 = 'N'                               CFT014
     C                   Eval      WScreen5 = 'Y'                               CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** If errors returned                                                     CFT014
                                                                                CFT014
     C     Idx           IfNe      0                                            CFT014
     C                   Eval      @SCRN = 'M'                                  CFT014
     C                   Goto      EndVAL@M                                     CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Re-output the screen                                                   CFT014
                                                                                CFT014
     C                   Eval      Widx_MVAL = Widx_MVAL + Widx                 CFT014
     C     WIdx_MVAL     IfNe      PrvN_Warn                                    CFT014
     C     NewPmtScn5    OrNe      PrvPmtScn5                                   CFT014
     C     NewPmtScn5A   OrNe      PrvPmtScn5A                                                CER030
     C     NewPmtScn5B   OrNe      PrvPmtScn5B                                                CER030
     C     WIdx_MVAL     AndEq     PrvN_Warn                                    CFT014
     C     WIdx_MVAL     AndNe     0                                            CFT014
     C                   Goto      EndVAL@M                                     CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Clear any warning messages                                             CFT014
                                                                                CFT014
     C                   Move      *ALL'Y'       FTEOPY5                        CFT014
     C                   Movel     *BLANK        WFldNamArr                     CFT014
     C                   Movel     *BLANK        WMsgIdArr                      CFT014
     C                   Movel     *BLANK        WMsgDtaArr                     CFT014
                                                                                CFT014
      ** Go back to Charges & Commissions screen                                CFT014
                                                                                CFT014
     C                   Movel     'O'           @SCRN                          CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C     EndVAL@M      EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/REFR@M                                                          CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/REFR@M     - Refresh Margin Information Screen             *         CFT014
      *                                                               *         CFT014
      * Called By: SCRN@M Subroutine                                  *         CFT014
      *                                                               *         CFT014
      * Calls:                                                        *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     REFR@M        BegSr                                                  CFT014
                                                                                CFT014
      ** Clear Margin info detail screen                                        CFT014
                                                                                CFT014
     C                   Clear                   NewPmtScn5                     CFT014
     C                   CLEAR                   NewPmtScn5A                                  CER030
     C                   CLEAR                   NewPmtScn5B                                  CER030
     C                   Eval      @SCRN = 'M'                                  CFT014
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************
      /EJECT
      *****************************************************************
      * WINDOW - CALL WINDOW MANAGER
      *****************************************************************
     C     WINDOW        BEGSR
      *
     C/COPY WNCPYSRC,FTOPAYRC09
      * Reset erros
      *
     C                   MOVE      *ALL'Y'       FTEOPY1
     C                   MOVE      *ALL'Y'       FTEOPY2
     C                   MOVE      *ALL'Y'       FTEOPY3
     C                   MOVE      *ALL'Y'       FTEOPY4                        CFT014
     C                   MOVE      *ALL'Y'       FTEOPY5                        CFT014
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * Write out screen to remove error messages
      *
     C                   CALLB     'FTOPAY1DP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * Payment (IN SCREEN FORMAT - Primary)
     C                   PARM                    NewPmtScn1
     C                   PARM                    NewPmtSc1b                     CFT014
      *
      * STATUS
     C                   PARM                    DDSTAT           24
      *
      * FIELDS IN ERROR
     C                   PARM                    FTEOPY1
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
      *
      * ENABLED FUNCTION KEYS
     C                   PARM                    @EINKD            1            CFT007
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKP
     C                   PARM                    @EINKQ                         CFT007
     C                   PARM                    @EINKS
     C                   PARM                    @EINKV
      *
      * SUCCESFUL INSERT TRANSACTION
     C                   PARM                    @SITR
      *
      * Data required for Additional Info window
     C                   PARM                    INUSR1
     C                   PARM                    INUSR2
     C                   PARM                    AUP1
     C                   PARM                    AUP2
     C                   PARM                    OPMSGR
      *
      * SWIFT Identifier
     C                   PARM                    XPREF
 
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKD             1            CFT007
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKQ             1            CFT007
     C                   PARM      '0'           @INKS             1
     C                   PARM      '0'           @INKV             1
     C                   PARM      'Y'           WriteOnly         1
     C                   PARM      0             CursorLoc         5 0          CFT007
     C                   PARM      *BLANKS       SSIMode                                     BUG7319
      *
     C/COPY WNCPYSRC,FTOPAYSMV1
      *
     C                   CALL      'WN0010'
     C                   PARM      'FTOPAYRPR'   #PGM             10
     C                   PARM                    FKEY              2
     C                   PARM      SACTION       ACTION            1
     C                   PARM                    DATA
     C                   PARM      *BLANKS       #RTRN             7
     C                   PARM                    SPAREW          256
      *
      * Process returned command keys
      *
     C     #RTRN         IFEQ      'Y2U9999'
     C                   EXSR      ENDP
     C                   ELSE
      *
      *  If Cmd12 pressed, return to main details screen;
      *  otherwise, go to second screen
      *
     C     #RTRN         IFEQ      'USR0790'
     C     @RDNB         IFEQ      'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
     C                   EVAL      @SCRN = 'P'
     C                   END
     C                   ELSE
     C                   If        WScreen2 = 'N'                               CFT014
     C                   EXSR      SNDM@S
     C                   EndIf                                                  CFT014
     C                   EVAL      @SCRN = 'S'
     C                   ENDIF
     C                   ENDIF
      *
     C     WIND          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * Read Next Subfile Record
      *
     C                   CALLB     'FTOPAYRPB'
      * INPUT PARAMETERS :
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * BUILD SUB-FILE
     C                   PARM      *BLANK        @BDSFL            1
      *
      * READ SUBFILE RECORD
     C                   PARM      'Y'           @RDSFL            1
      *
      * Error in update of previous deal
     C                   PARM                    @ERRUP            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * OPTION SELECTED
     C                   PARM      *BLANK        @OPSEL            1
      *
      * ACTION SELECTED
     C                   PARM      *BLANK        @ACSEL            1
      *
      * FO TRANSACTION ID SELECTED
     C                   PARM      *BLANK        @FOTRANSEL       20
      *
      * TIMESTAMP OF TRANSACTION SELECTED
     C                   PARM                    @TMESTPSEL
      *
      * COMMAND KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
     C                   PARM                    Val@Fields                                   CSC011
      *                                                                                       207404
      ** Successful insert Payment                                                            207404
      *                                                                                       207404
     C                   PARM                    @SITR            15                          207404
      ** CSC022 Enhancement is installed                                                      CSC022
      **                                                                                      CSC022
     C                   PARM                    CSC022                                       CSC022
      **                                                                                      CSC022
      *
      * If CK/3 taken within invalid transaction deletion function,
      * End program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      ENDRDNBRW
     C                   END
      *
      * If Invalid Payment read from subfile
     C     @OPSEL        IFNE      *BLANK
      *
      * BLANK THE SCREENS
      *
     C                   MOVEL     *BLANK        NewPmtScn1
     C                   MOVEL     *BLANK        NewPmtSc2a
     C                   MOVEL     *BLANK        NewPmtSc2b
     C                   MOVEL     *BLANK        NewPmtScn3
     C                   MOVEL     *BLANK        NewPmtSc1b                     CFT014
     C                   MOVEL     *BLANK        NewPmtSc3b                     CFT014
     C                   MOVEL     *BLANK        NewPmtScn4                     CFT014
     C                   MOVEL     *BLANK        NewPmtScn5                     CFT014
     C                   MOVEL     *BLANK        NewPmtScn6                                   CSW209
     C                   MOVEL     *BLANK        NewPmtScn7                                   CSW209
     C                   MOVEL     *BLANKS       NewPmtScn5A                                  CER030
     C                   MOVEL     *BLANKS       NewPmtScn5B                                  CER030
     C                   MOVE      *BLANK        DDSTAT
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       FTEOPY1
     C                   MOVE      *ALL'Y'       FTEOPY2
     C                   MOVE      *ALL'Y'       FTEOPY3
     C                   MOVE      *ALL'Y'       FTEOPY4                        CFT014
     C                   MOVE      *ALL'Y'       FTEOPY5                        CFT014
     C                   MOVE      *ALL'Y'       FTEOPYA                                      CSW209
     C                   MOVE      *ALL'Y'       FTEOPYC                                      CSW209
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
 
      * Retrieve Payment details
      *
     C                   MOVEL     @ACSEL        SACTION
     C                   MOVEL     @FOTRANSEL    FOTRID
     C*******************MOVEL     '*FRONT'      @@MODE                         CAP013
      *                                                                         CAP013
      * Make sure Invalid transaction's  details are passed to 'Retrieve'       CAP013
      * module for SPF checking .                                               CAP013
      *                                                                         CAP013
     C     ZAPMTKX0      CHAIN     FTIOPAYL0                          99        CAP013
      *                                                                         CAP013
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
      *  if insert                                                              CAP013
      *  if not insert and Midas transaction ID is not present                  CAP013
      * Otherwise                                                               CAP013
      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
      *                                                                         CAP013
     C     SACTION       IFEQ      'I'                                          CAP013
     C                   MOVEL     '*FRONT'      @@MODE                         CAP013
     C                   ELSE                                                   CAP013
     C     SPREF         IFEQ      *BLANK                                       CAP013
     C                   MOVEL     '*FRONT'      @@MODE                         CAP013
     C                   ELSE                                                   CAP013
     C                   MOVEL     '      '      @@MODE                         CAP013
     C                   ENDIF                                                  CAP013
     C                   ENDIF                                                  CAP013
      *                                                                         CAP013
     C                   EXSR      RTVPMT
      *                                                                                       CER030
      ** Initialize Flag for defaulting in retail transaction type                            CER030
      *                                                                                       CER030
     C                   EVAL      WFlg = 'N'                                                 CER030
      *
      * If payment details were retrieved
      * Convert Payment to screen format
      *
     C     PREF          IFNE      *BLANK
     C     SACTION       ANDNE     'I'
     C                   EXSR      CVTPMT
     C                   MOVEL     CrPtFilFmt    NwPtFilFmt
     C                   MOVEL     CrPtFilFmX    NwPtFilFmX
     C                   END
      *
      * Now overwite the fields on the main details screen with those
      * on the invalid payments file (except for the Midas payment
      * reference retrieved above using the front office transaction ID).
      * Access invalid pmnt with timestamp and front office transaction ID.
      *
     C                   MOVEL     SPREF         ##SPREF          15
     C     ZAPMTKX0      CHAIN     FTIOPAYX0                          99
 
     C     PREF          IFNE      *BLANK
     C     SACTION       ANDNE     'I'
     C                   MOVEL     ##SPREF       SPREF
     C                   END
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y'                                               CER001
     C     ZAPMTKX0      CHAIN     FTIOPLX1L0                                                 CER001
     C                   IF        %FOUND                                                     CER001
     C                   EVAL      LLLXORTY = #LLXORTY                                        CER001
     C                   EVAL      LLLXBETY = #LLXBETY                                        CER001
     C                   EVAL      LLLXOPCO = #LLXOPCO                                        CER001
     C                   EVAL      LLLXCOCO = #LLXCOCO                                        CER001
     C                   EVAL      LLLXIDCO = #LLXIDCO                                        CER001
     C                   EVAL      LLLXIDEN = #LLXIDEN                                        CER001
     C                   EVAL      #1DEXT = 'Y'                                               CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                         CAP011
      * If Outgoing Payment details were retrieved and this is an amendment     CAP011
      *                                                                         CAP011
     C     SPREF         IFNE      *ZERO                                        CAP011
     C     SACTION       ANDEQ     'A'                                          CAP011
                                                                                CAP011
      * Data Substitution - Transaction Details                                 CAP011
                                                                                CAP011
     C     GHSUBS        ifne      *blank                                       CAP011
                                                                                CAP011
     C     GHSUBS        scan      NewPmtScn1                             99    CAP011
     C                   if        *in99                                        CAP011
     C                   eval      RepPrim = 'Y'                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C     GHSUBS        scan      NewPmtSc2a                             99    CAP011
     C                   if        *in99                                        CAP011
     C                   eval      RepSecA = 'Y'                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C     GHSUBS        scan      NewPmtSc2b                             99    CAP011
     C                   if        *in99                                        CAP011
     C                   eval      RepSecB = 'Y'                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C     GHSUBS        scan      NewPmtScn3                             99    CAP011
     C                   if        *in99                                        CAP011
     C                   eval      RepThir = 'Y'                                CAP011
     C                   endif                                                  CAP011
                                                                                CFT014
     C     GHSUBS        scan      NewPmtSc1b                             99    CFT014
     C                   if        *in99                                        CFT014
     C                   eval      RepPrmB = 'Y'                                CFT014
     C                   endif                                                  CFT014
                                                                                CFT014
     C     GHSUBS        scan      NewPmtSc3B                             99    CFT014
     C                   if        *in99                                        CFT014
     C                   eval      RepThrB = 'Y'                                CFT014
     C                   endif                                                  CFT014
                                                                                CFT014
     C     GHSUBS        scan      NewPmtScn4                             99    CFT014
     C                   if        *in99                                        CFT014
     C                   eval      RepFour = 'Y'                                CFT014
     C                   endif                                                  CFT014
                                                                                CFT014
     C     GHSUBS        scan      NewPmtScn5                             99    CFT014
     C                   if        *in99                                        CFT014
     C                   eval      RepMarg = 'Y'                                CFT014
     C                   endif                                                  CFT014
     C                   IF        CSW209 = 'Y'                                               CSW209
      *                                                                                       CSW209
     C     GHSUBS        SCAN      NewPmtScn6                             99                  CSW209
     C                   IF        *IN99                                                      CSW209
     C                   EVAL      RepCovA = 'Y'                                              CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C     GHSUBS        SCAN      NewPmtScn7                             99                  CSW209
     C                   IF        *IN99                                                      CSW209
     C                   EVAL      RepCovD = 'Y'                                              CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C     GHSUBS        SCAN      NewPmtScn5A                            99                  CER059
     C                   IF        *IN99                                                      CER059
     C                   EVAL      RepFivA = 'Y'                                              CER059
     C                   ENDIF                                                                CER059
      *                                                                                       CER059
     C     GHSUBS        SCAN      NewPmtScn5B                            99                  CER059
     C                   IF        *IN99                                                      CER059
     C                   EVAL      RepFivB = 'Y'                                              CER059
     C                   ENDIF                                                                CER059
                                                                                              CER059
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
                                                                                CAP011
      ** If any of the flags set above is true, do the data                     CAP011
      ** substution subroutine.                                                 CAP011
     C                   if         RepPrim = 'Y' OR RepSecA = 'Y' OR           CAP011
     C***********                   RepSecB = 'Y' OR RepThir = 'Y')             CAP011 CFT014
     C                              RepSecB = 'Y' OR RepThir = 'Y' OR           CFT014
     C                              RepPrmB = 'Y' OR RepThrB = 'Y' OR           CFT014
     C**********                    RepFour = 'Y' OR RepMarg = 'Y'                     CFT014 CSW209
     C                              RepFour = 'Y' OR RepMarg = 'Y'  OR                        CSW209
     C**********                    RepCovA = 'Y' OR RepCovD = 'Y'                            CSW209
     C                              RepCovA = 'Y' OR RepCovD = 'Y' OR                         CER059
     C                              RepFivA = 'Y' OR RepFivB = 'Y'                            CER059
     C                   EXSR      TDtDtaSubs                                   CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C                   END                                                    CAP011
                                                                                CAP011
                                                                                CAP011
     C                   END                                                    CAP011
     C                                                                          CAP011
      *
      * If action code, or trade reference were NOT OK
      * blank out action code so that the input cannot proceed
      *
     C     OKACTION      IFEQ      'N'
     C     OKPREF        OREQ      'N'
     C/COPY WNCPYSRC,FTH00351
     C                   MOVEL     *BLANK        SACTION
     C/COPY WNCPYSRC,FTH00352
     C                   END
      *
      * Send the payment error messages to the primary details screen
      * and GO TO PRIMARY DETAILS SCREEN
      *
     C                   If        WScreen1 = 'N'                               CFT014
     C                   EXSR      SNDM@P
     C                   EndIf                                                  CFT014
     C                   MOVEL     'P'           @SCRN
 
      * ELSE IF NO INVALID PAYMENT READ FROM SUBFILE
      * GO TO BROWSE SCREEN
      *
     C                   ELSE
     C                   MOVE      'I'           @SCRN
     C                   END
      *
     C     EndRDNBRW     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVPMT - RETRIEVE PAYMENT
      *****************************************************************
     C     RTVPMT        BEGSR
      *
      * RETRIEVE Payment
      *
      * Input is Level 1
     C                   MOVE      '1'           @Level            1
 
     C                   CALLB     'FTOPAYRTV'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    @@MODE            6
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      * Action Code
     C                   PARM                    SACTION
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      * (Midas) Payment Reference
     C                   PARM                    SPREF
      * Booking branch
     C                   PARM                    SBRCA             3
 
      * Level 1/2 indicator
     C                   PARM                    @Level            1
      * @CFT014 workfield                                                       CFT014
     C                   PARM                    Val@Fields                     CFT014
 
      * OUTPUTS :
      * (Current) Payment in file format
     C                   PARM                    CrPtFilFmt
     C                   PARM                    CrPtFilFmX                     CFT014
      * OK - Action code
     C                   PARM      *BLANK        OKACTION
      * OK - Payment Reference
     C                   PARM      *BLANK        OKPREF
      * OK - Booking branch
     C                   PARM                    OKBRCA
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
     C/COPY WNCPYSRC,FTOPAYPC01
      *
 
     C     EndRTVPMT     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTPMT - PUT A Payment ON THE MAIN DETAILS SCREEN
      *****************************************************************
     C     CVTPMT        BEGSR
      *
      * Call program to fill screen fields with data from OTPAYDD
      *
     C                   CALLB     'FTOPAYCVT'
      *
      * INPUTS :
      * Return Code
      * Payment in file format
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    CrPtFilFmt
     C                   PARM                    CrPtFilFmX                     CFT014
 
      * OUTPUTS
      * Payment - screen formats
     C                   PARM                    NewPmtScn1
     C                   PARM                    NewPmtSc1b                     CFT014
     C                   PARM                    NewPmtSc2a
     C                   PARM                    NewPmtSc2b
     C                   PARM                    NewPmtScn3
     C                   PARM                    NewPmtSc3b                     CFT014
     C                   PARM                    NewPmtScn4                     CFT014
     C                   PARM                    NewPmtScn5                     CFT014
     C                   PARM                    NewPmtScn6                                   CSW209
     C                   PARM                    NewPmtScn7                                   CSW209
     C                   PARM                    NewPmtScn5A                                  CER030
     C                   PARM                    NewPmtScn5B                                  CER030
     C                   PARM                    SDFTFR                         CFT014
 
      *  Validation Work Fields
     C                   PARM                    Val@Fields
 
      * Payment Status
     C                   PARM                    DDSTAT
      *
     C* Msg Unique Reference                                                                  190845
     C                   PARM                    SHMSGR                                       190845
     C* Part Number                                                                           190845
     C                   PARM                    SHPART                                       190845
     C                   PARM      *BLANKS       BtnPressed       10                       AR1090283
      *                                                                                       190845
      * Update 'Current' Payment with Payment in Screen Format
      *
     C                   MOVEL     NewPmtScn1    CurPmtScn1
     C                   MOVEL     NewPmtSc1b    CurPmtSc1b                     CFT014
     C                   MOVEL     NewPmtSc2a    CurPmtSc2a
     C                   MOVEL     NewPmtSc2b    CurPmtSc2b
     C                   MOVEL     NewPmtScn1    CurPmtScn3
     C                   MOVEL     NewPmtSc3b    CurPmtSc3b                     CFT014
     C                   MOVEL     NewPmtScn4    CurPmtScn4                     CFT014
     C                   MOVEL     NewPmtScn5    CurPmtScn5                     CFT014
     C                   MOVEL     NewPmtScn6    CurPmtScn6                                   CSW209
     C                   MOVEL     NewPmtScn7    CurPmtScn7                                   CSW209
     C                   MOVEL     NewPmtScn5A   CurPmtScn5A                                  CER030
     C                   MOVEL     NewPmtScn5B   CurPmtScn5B                                  CER030
     C                   MOVE      CDRT          WPrvCDRT          1                          187056
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFDS@P - SET FIELD STATUS ON PRIMARY SCREEN
      *****************************************************************
     C     SFDS@P        BEGSR
      *
      * Enable/disable fields on primary screen
      *
     C     SACTION       IFEQ      'I'
     C     SACTION       OREQ      'A'
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EKYFD
     C                   MOVEL     'N'           @EDTFD
     C                   END
      *
      * Enable/disable function keys
      *
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      *
     C                   MOVEL     'N'           @EINKG
     C                   MOVEL     'N'           @EINKH
      *
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      *
     C     SACTION       IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
      *
      * KP = COMMAND KEY 15 = BROWSE
      *
     C                   MOVEL     'N'           @EINKP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFDS@P - INITIALIZE FIELD STATUS ON PRIMARY SCREEN
      *****************************************************************
     C     IFDS@P        BEGSR
      *
      * ENABLE KEY FIELDS ON PRIMARY SCREEN
      *
     C                   MOVEL     'Y'           @EDTFD
     C                   MOVEL     'Y'           @EKYFD
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@P - SEND A MESSAGE TO PRIMARY DETAILS SCREEN
      *****************************************************************
     C     SNDM@P        BEGSR
      *
     C                   Z-ADD     Idx           E                 3 0
      *
      ** If there are fundamental errors in this transaction
      ** Identify this fact.
      *
     C     OKACTION      IFEQ      'N'
     C     OKPREF        OREQ      'N'
     C/COPY WNCPYSRC,FTH00353
     C                   ADD       1             E
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     'APM0110'     MsgIdArr(E)
     C                   ENDIF
      *
      ** Initialize error indicators
      *
     C                   MOVEA     FTEOPY1       @EI
      *
      ** Read error messages for trade
      *
     C     ZAPMTKD0      SETLL     ZATRNERRD0
     C     ZAPMTKD0      READE     ZATRNERRD0                             99    *
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
     C/COPY WNCPYSRC,FTH00145
 
     C     ABFIELDID     IFLT      FldOffsetS
     C     ABFIELDID     OREQ      FldOffsetS                                   CFT014
     C*****SACTION       OREQ      ' '                                          CFT014
     C*****SACTION       OREQ      'I'                                          CFT014
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffsetP    F
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
     C                   MOVE      'N'           @EI(F)
     C                   END
     C/COPY WNCPYSRC,FTH00146
 
     C     ZAPMTKD0      READE     ZATRNERRD0                             99    *
     C                   END
      *
     C                   MOVEA     @EI           FTEOPY1
      *
     C     EndSNDM@P     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************         CFT007
      * SNDM@P1 - SEND A MESSAGE TO PRIMARY DETAILS SCREEN                      CFT007
      *****************************************************************         CFT007
     C     SNDM@P1       BEGSR                                                  CFT007
      *                                                                         CFT007
      ** Add error message to array passed to detail screen                     CFT007
      *                                                                         CFT007
     C                   Z-ADD     1             E                 3 0          CFT007
     C     *BLANK        LOOKUP    FldNameArr(E)                          99    CFT007
     C                   MOVEL     '*ANY'        FldNameArr(E)                  CFT007
     C                   MOVEL     @ERRMS        MsgIdArr(E)                    CFT007
      *                                                                         CFT007
     C     EndSNDM@P1    ENDSR                                                  CFT007
      *****************************************************************         CFT007
      /EJECT                                                                    CFT007
      *****************************************************************
      * SNDM@S - SEND A MESSAGE TO SECONDARY DETAILS SCREEN
      *****************************************************************
     C     SNDM@S        BEGSR
      *
      ** Initialize error indicators
      *
     C                   MOVEA     FTEOPY2       @EI
     C                   Z-ADD     0             G
     C                   Z-ADD     0             E                              CFT014
      *
      ** Read error messages for trade
      *
     C     ZAPMTKD0      SETLL     ZATRNERRD0
     C     ZAPMTKD0      READE     ZATRNERRD0                             99    *
      *
      ** Add error message to array passed to detail screen
      ** and set OK flag for field to 'N'
      *
     C     *IN99         DOWEQ     '0'
     C/COPY WNCPYSRC,FTH00147
 
     C*****ABFIELDID     IFGE      FldOffsetS                                   CFT014
     C*****ABFIELDID     ANDLT     FldOffsetT                                   CFT014
     C     ABFIELDID     IFGT      FldOffsetS                                   CFT014
     C     ABFIELDID     ANDLE     FldOffsetT                                   CFT014
     C                   ADD       1             E
     C                   MOVEL     ABFIELDNAM    FldNameArr(E)
     C                   MOVEL     ABMSGID       MsgIdArr(E)
     C                   Z-ADD     ABFIELDID     F                 3 0
     C                   SUB       FldOffsetS    F
     C     F             IFLT      1
     C     F             ORGT      60
     C                   Z-ADD     1             F
     C                   END
      * Allow for 2 'dummy' fields on FTEOPY2PD (OKACTION2/OKPREF2)
     C     F             ADD       2             G                 3 0
     C                   MOVE      'N'           @EI(G)
     C                   END
     C/COPY WNCPYSRC,FTH00148
 
     C     ZAPMTKD0      READE     ZATRNERRD0                             99    *
     C                   END
      *
     C                   MOVEA     @EI           FTEOPY2
      *
     C                   ENDSR
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/SNDM@T                                                          CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/SNDM@T    - Send a message to the third screen.            *         CFT014
      *                                                               *         CFT014
      * Called By: VAL@S Subroutine                                   *         CFT014
      *                                                               *         CFT014
      * Calls: None                                                   *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SNDM@T        BegSr                                                  CFT014
                                                                                CFT014
      ** Initialise error indicators                                            CFT014
                                                                                CFT014
     C                   MoveA     FTEOPY3       @EI                            CFT014
     C                   Z-Add     *Zero         G                              CFT014
     C                   Z-Add     *Zero         E                              CFT014
                                                                                CFT014
      ** Read error messages for trade                                          CFT014
                                                                                CFT014
     C     ZAPMTKD0      Setll     ZATRNERRD0                                   CFT014
     C     ZAPMTKD0      ReadE     ZATRNERRD0                             99    CFT014
                                                                                CFT014
      ** Add error message to array passed to detail screen                     CFT014
      ** and set OK flag for field to 'N'                                       CFT014
                                                                                CFT014
     C                   DoW       *IN99 = *Off                                 CFT014
     C/COPY WNCPYSRC,FTH00149
                                                                                CFT014
      ** Add messages for third screen only when the field number cor -         CFT014
      ** responds to a field defined on the third screen.                       CFT014
                                                                                CFT014
     C                   If        (ABFIELDID > FldOffSetT) And                 CFT014
     C                             (ABFIELDID <= FldOffSet4)                    CFT014
     C                   Eval      E = E + 1                                    CFT014
     C                   Movel     ABFIELDNAM    FldNameArr(E)                  CFT014
     C                   Movel     ABMSGID       MsgIdArr(E)                    CFT014
     C                   Z-Add     ABFIELDID     F                              CFT014
     C                   Sub       FldOffsetT    F                              CFT014
     C                   If        (F < 1) Or (F > 60)                          CFT014
     C                   Z-Add     1             F                              CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Allow for 2 'dummy' fields on FTEOPY3PD (OKACTION3/OKPREF3)            CFT014
                                                                                CFT014
     C                   Eval      G = F + 2                                    CFT014
     C                   Move      'N'           @EI(G)                         CFT014
     C                   EndIf                                                  CFT014
     C/COPY WNCPYSRC,FTH00150
                                                                                CFT014
     C     ZAPMTKD0      ReadE     ZATRNERRD0                             99    CFT014
     C                   EndDo                                                  CFT014
      *                                                                         CFT014
     C                   MoveA     @EI           FTEOPY3                        CFT014
      *                                                                         CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/SNDM@4                                                          CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/SNDM@4    - Send a message to the Fourth screen.           *         CFT014
      *                                                               *         CFT014
      * Called By: VAL@B Subroutine                                   *         CFT014
      *                                                               *         CFT014
      * Calls: None                                                   *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SNDM@4        BegSr                                                  CFT014
                                                                                CFT014
      ** Initialise error indicators                                            CFT014
                                                                                CFT014
     C                   MoveA     FTEOPY4       @EI                            CFT014
     C                   Z-Add     *Zero         G                              CFT014
     C                   Z-Add     *Zero         E                              CFT014
                                                                                CFT014
      ** Read error messages for trade                                          CFT014
                                                                                CFT014
     C     ZAPMTKD0      Setll     ZATRNERRD0                                   CFT014
     C     ZAPMTKD0      ReadE     ZATRNERRD0                             99    CFT014
                                                                                CFT014
      ** Add error message to array passed to detail screen                     CFT014
      ** and set OK flag for field to 'N'                                       CFT014
                                                                                CFT014
     C                   DoW       *IN99 = *Off                                 CFT014
     C/COPY WNCPYSRC,FTH00151
                                                                                CFT014
      ** Add messages for 4th screen only when the field number cor -           CFT014
      ** responds to a field defined on the 4th screen.                         CFT014
                                                                                CFT014
     C                   If        (ABFIELDID > FldOffSet4) And                 CFT014
     C                             (ABFIELDID <= FldOffSet5)                    CFT014
     C                   Eval      E = E + 1                                    CFT014
     C                   Movel     ABFIELDNAM    FldNameArr(E)                  CFT014
     C                   Movel     ABMSGID       MsgIdArr(E)                    CFT014
     C                   Z-Add     ABFIELDID     F                              CFT014
     C                   Sub       FldOffset4    F                              CFT014
     C                   If        (F < 1) Or (F > 60)                          CFT014
     C                   Z-Add     1             F                              CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Allow for 2 'dummy' fields on FTEOPY4PD (OKACTION4/OKPREF4)            CFT014
                                                                                CFT014
     C                   Eval      G = F + 2                                    CFT014
     C                   Move      'N'           @EI(G)                         CFT014
     C                   EndIf                                                  CFT014
     C/COPY WNCPYSRC,FTH00152
                                                                                CFT014
     C     ZAPMTKD0      ReadE     ZATRNERRD0                             99    CFT014
     C                   EndDo                                                  CFT014
      *                                                                         CFT014
     C                   MoveA     @EI           FTEOPY4                        CFT014
      *                                                                         CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/SNDM@5                                                          CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/SNDM@5    - Send a message to Margin Information.          *         CFT014
      *                                                               *         CFT014
      * Called By: VAL@B Subroutine                                   *         CFT014
      *                                                               *         CFT014
      * Calls: None                                                   *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SNDM@5        BegSr                                                  CFT014
                                                                                CFT014
      ** Initialise error indicators                                            CFT014
                                                                                CFT014
     C                   MoveA     FTEOPY5       @EI                            CFT014
     C                   Z-Add     *Zero         G                              CFT014
     C                   Z-Add     *Zero         E                              CFT014
                                                                                CFT014
      ** Read error messages for trade                                          CFT014
                                                                                CFT014
     C     ZAPMTKD0      Setll     ZATRNERRD0                                   CFT014
     C     ZAPMTKD0      ReadE     ZATRNERRD0                             99    CFT014
                                                                                CFT014
      ** Add error message to array passed to detail screen                     CFT014
      ** and set OK flag for field to 'N'                                       CFT014
                                                                                CFT014
     C                   DoW       *IN99 = *Off                                 CFT014
     C/COPY WNCPYSRC,FTH00153
                                                                                CFT014
      ** Add messages for 5th screen only when the field number cor -           CFT014
      ** responds to a field defined on the 5th screen.                         CFT014
                                                                                CFT014
     C                   If        (ABFIELDID > FldOffSet5)                     CFT014
     C                   Eval      E = E + 1                                    CFT014
     C                   Movel     ABFIELDNAM    FldNameArr(E)                  CFT014
     C                   Movel     ABMSGID       MsgIdArr(E)                    CFT014
     C                   Z-Add     ABFIELDID     F                              CFT014
     C                   Sub       FldOffset5    F                              CFT014
     C                   If        (F < 1) Or (F > 60)                          CFT014
     C                   Z-Add     1             F                              CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Allow for 2 'dummy' fields on FTEOPY5PD (OKACTION5/OKPREF5)            CFT014
                                                                                CFT014
     C                   Eval      G = F + 2                                    CFT014
     C                   Move      'N'           @EI(G)                         CFT014
     C                   EndIf                                                  CFT014
     C/COPY WNCPYSRC,FTH00154
                                                                                CFT014
     C     ZAPMTKD0      ReadE     ZATRNERRD0                             99    CFT014
     C                   EndDo                                                  CFT014
      *                                                                         CFT014
     C                   MoveA     @EI           FTEOPY5                        CFT014
      *                                                                         CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@P - CANCEL ON PRIMARY DETAILS SCREEN
      *****************************************************************
     C     CANC@P        BEGSR
      *
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'I'           @SCRN
     C                   END
                                                                                CFT014
      ** Reset screen validated fields                                          CFT014
                                                                                CFT014
     C                   Reset                   WScreenDS                      CFT014
      *
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - CANCEL ON SECONDARY SCREEN
      *****************************************************************
     C     CANC@S        BEGSR
      *
      * Initialize field status on Primary Screen
     C                   EXSR      IFDS@P
      *
      * Return to Primary Screen
      *
     C                   MOVEL     'P'           @SCRN
      *
     C                   ENDSR
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/CANC@B                                                          CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/CANC@B     - Cancel on 3rd screen level 2                  *         CFT014
      *                                                               *         CFT014
      * Called By: SCRN@B Subroutine                                  *         CFT014
      *                                                               *         CFT014
      * Calls: None                                                   *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     CANC@B        BegSr                                                  CFT014
                                                                                CFT014
      ** Return to second screen level 2                                        CFT014
                                                                                CFT014
     C                   Movel     'S'           @SCRN                          CFT014
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/CANC@M                                                          CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/CANC@M     - Cancel on Margin Information Screen           *         CFT014
      *                                                               *         CFT014
      * Called By: SCRN@M Subroutine                                  *         CFT014
      *                                                               *         CFT014
      * Calls: None                                                   *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     CANC@M        BegSr                                                  CFT014
                                                                                CFT014
      ** Return to Charges and Commissions Screen                               CFT014
                                                                                CFT014
     C                   Movel     'O'           @SCRN                          CFT014
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@O - CANCEL ON CHARGES & PAYMENTS SCREEN
      *****************************************************************
     C     CANC@O        BEGSR
      *
      * Return to Secondary Screen
      *
     C***********        MOVEL     'S'           @SCRN                          CFT014
     C                   MOVEL     'B'           @SCRN                          CFT014
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * COMLEV1 - Update file with level one details
      *****************************************************************
     C     COMLEV1       BEGSR
      *
      * Go to Primary screen for confirmation.
      *
     C                   MOVEL     'C'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@C - PROCESS SCREEN: CONFIRMATION OF INPUT
      *          EVOKED FOR INSERTS, & AMENDS
      *****************************************************************
     C     SCRN@C        BEGSR
      *
      * If transaction is valid output message 'Press enter to accept'
      *
     C     Idx           IFEQ      *ZERO
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1030'     MsgIdArr(1)
     C                   END
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'FTOPAY1DP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NewPmtScn1
     C                   PARM                    NewPmtSc1b                     CFT014
      *
      * DEAL STATUS
     C                   PARM                    DDSTAT
      *
      * FIELDS IN ERROR
     C                   PARM                    FTEOPY1
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM      'N'           @EKYFD
     C                   PARM      'N'           @EDTFD
      *
      * ENABLED FUNCTION KEYS
     C                   PARM      'N'           @EINKD            1            CFT007
     C                   PARM      'N'           @EINKG
     C                   PARM      'N'           @EINKH
     C                   PARM      'N'           @EINKJ
     C                   PARM      'N'           @EINKP
     C                   PARM      'N'           @EINKQ            1            CFT007
     C                   PARM      'N'           @EINKS
     C                   PARM      'N'           @EINKV
      *
      * SUCCESFUL INSERT
     C                   PARM                    @SITR
      *
      * Data required for Additional Info window
     C                   PARM                    INUSR1
     C                   PARM                    INUSR2
     C                   PARM                    AUP1
     C                   PARM                    AUP2
     C                   PARM                    OPMSGR
      *
      * SWIFT Identifier
     C                   PARM                    XPREF
 
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKD             1            CFT007
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKQ             1            CFT007
     C                   PARM      '0'           @INKS             1
     C                   PARM      '0'           @INKV             1
     C                   PARM      'N'           WriteOnly         1
     C                   PARM      0             CursorLoc         5 0          CFT007
     C                   PARM      *BLANKS       SSIMode                                     BUG7319
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       FTEOPY1
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON CONFIRMATION SCREEN
      *
     C     @INKL         CASEQ     '1'           CANC@C
      *
      * EXIT CONFIRMATION SCREEN
      *
     C                   CAS                     EXIT@C
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@C - CANCEL ON CONFIRMATION SCREEN
      *****************************************************************
     C     CANC@C        BEGSR
      *
      * RETURN TO MAIN DETAILS SCREEN
      *
     C                   MOVEL     'P'           @SCRN
      *
      * Initialize field status on main details screen
      *
     C                   EXSR      IFDS@P
      *
      * Set function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@P
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@C - EXIT FROM CONFIRMATION SCREEN
      *****************************************************************
     C     EXIT@C        BEGSR
      *
      * IF NO ERRORS IN VALIDATION
      *
     C     Idx           IFEQ      *ZERO
      *
      * CONTINUE WITH UPDATES
      *
     C                   MOVEL     'U'           @SCRN
      *
      * ELSE, RETURN TO Main Details SCREEN
      *
     C                   ELSE
     C                   MOVEL     'P'           @SCRN
      *
      * Initialize field status on main details screen
      *
     C                   EXSR      IFDS@P
      *
      * Set function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@P
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
      *
     C/COPY WNCPYSRC,FTOPAYRC02
     **  If Insert, set up payment reference.
      ***Suppress*new*payment*reference*generation*if*CSC024*is                        CSC024 CSC054
      ***switched*on*and*this*is*running*on*OME*system.                                CSC024 CSC054
      ** Suppress new payment reference generation if CSC054 is                               CSC054
      ** switched on and this is running on PEA system.                                       CSC054
                                                                                              CSC024
     C     SACTION       IFEQ      'I'
     C     GENPREF       ANDEQ     'Y'                                                        CSC024
     C                   EXSR      SETPAYREF
     C                   END
     C/COPY WNCPYSRC,FTOPAYRC03
      *
      * UPDATE VALID Payment: Payment REFERENCE
      *
     C                   MOVEL     SPREF         OTPREF
      *
      * UPDATE VALID Payment: CHANGE TYPE
      *
     C                   MOVEL     SACTION       OTCHTP
      *
      * UPDATE VALID Payment: FRONT OFFICE TRANSACTION ID
      *
     C                   MOVEL     @FOTRANSEL    OTFRNT
      *
      * UPDATE VALID Payment: RECI
      *
                                                                                CFT014
     C                   If        (@CFT003 = 'Y') Or (@CFT014 = 'Y')           CFT014
     C                             OR (@CFT009 = 'Y')                           CFT009
     C                   Move      'D'           O2RECI                         CFT014
     C                   Movel     SPREF         O2PREF                         CFT014
                                                                                CFT014
      ** Action is 'I' or 'A'                                                   CFT014
                                                                                CFT014
     C                   If        (SACTION = 'I') Or (SACTION = 'A')           CFT014
     C                   Move      'N'           O2AUTO                         CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   MOVE      'D'           OTRECI
      *
      * PAYMENTS UPDATES
      *
     C                   CALLB     'FTOPAYUPD'
     C***********        PARM      *BLANKS       @RTCD                          CFT014
     C                   PARM      *BLANKS       RetCodeOut                     CFT014
      *  OK Flags
     C                   Parm                    FTEOPY1
     C                   Parm                    FTEOPY2
     C                   Parm                    FTEOPY3
     C                   Parm                    FTEOPY4                        CFT014
     C                   Parm                    FTEOPY5                        CFT014
 
      * New Valid payment layout
     C                   PARM                    NwPtFilFmt
     C                   PARM                    NwPtFilFmX                     CFT014
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
      *                                                                                       CAP211
     C                   PARM      *BLANK        PAuth             1                          CAP211
     C                   PARM      *BLANKS       PUser            10                          CAP211
      *                                                                                       CAP211
     C/COPY WNCPYSRC,FTOPAYRC28
      *                                                                                       CER001
     C                   IF        RetCodeOut = *BLANKS AND                                   CER001
     C                             ULX043  =  'Y'                                             CER001
     C                   EVAL      #LLXOPPREF = OTPREF                                        CER001
     C                   CALLB     'FTOPAY2UP'                                                CER001
     C                   PARM                    SACTION                                      CER001
     C                   PARM      *BLANKS       RetCodeOut                                   CER001
     C                   PARM                    PFind                                        CER001
     C                   PARM                    NwOPFilFmt                                   CER001
     C                   PARM                    CrOPFilFmt                                   CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C/COPY WNCPYSRC,FTOPAYRC04
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C*****@RTCD         IFNE      *BLANK                                       187413
     C*****@RTCD         ANDNE     '*RECUPD'                                    187413
     C     RetCodeOut    IFNE      *BLANK                                       187413
     C     RetCodeOut    ANDNE     '*RECUPD'                                    187413
      **                                                                                      CSC022
      ** Execute rollback if SAR CSC022 is not enrolled or                                    CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
     C                   EXSR      *PSSR
     C
     C                   ELSE
      *                                                                                       207404
      ** Take SPREF before it's overridden by value from FTIPAYD0                             207404
      *                                                                                       207404
     C     SACTION       IFEQ      'I'                                                        207404
     C                   MOVE      SPREF         @SITR                                        207404
     C/COPY WNCPYSRC,FTH00257
     C                   END                                                                  207404
     C*                                                                                       207404
     C     ZAPMTKD0      CHAIN     FTIOPAYD0                          99
     C  N99              DELETE    FTIOPAYD0
     C/COPY WNCPYSRC,FTH00210
     C                   IF        ULX043 = 'Y'                                               CER001
     C     FTIOPKEY      CHAIN     FTIOPLX1L0                                                 CER001
     C                   IF        %FOUND(FTIOPLX1L0)                                         CER001
     C                   DELETE    FTIOPLX1L0                                                 CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
                                                                                              CSC011
      ** Delete invalid record from the log file.                                             CSC011
                                                                                              CSC011
     C                   IF        (@CSC011 = 'Y') AND (LIBR = S1SUPP)                        CSC011
     C                   EVAL      KMTYP = 'FTOPAY'                                           CSC011
     C     KLOGL0        CHAIN     APILOGL0                           99                      CSC011
      *                                                                                       CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGD0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
     C/COPY WNCPYSRC,FTOPAYRC08
      **                                                                                      CSC022
      ** Execute commit if SAR CSC022 is not enrolled or                                      CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C*****SACTION***    IFEQ      'I'                                                        207404
     C**********         MOVE      SPREF         @SITR                                        207404
     C**********         END                                                                  207404
                                                                                CFT014
      ** Reset screen validated fields                                          CFT014
                                                                                CFT014
     C                   Reset                   WScreenDS                      CFT014
     C                   END
      *
      * If error occurred in updating last transaction set on flag to
      * display message on 'browse' screen.
     C*****@RTCD         IFEQ      '*RECUPD'                                    187413
     C     RetCodeOut    IFEQ      '*RECUPD'                                    187413
     C                   MOVE      'Y'           @ERRUP
     C                   ELSE
     C                   MOVE      'N'           @ERRUP
     C                   END
     C
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * ELSE, RETURN TO THE BROWSE SCREEN
      *
     C                   MOVEL     'I'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SETPAYREF  Set up Payment Reference
      *****************************************************************
     C     SETPAYREF     BEGSR
      *
     C                   MOVE      SPYTP         PmntType
     C                   MOVE      SSTTP         StmtType
                                                                                              CSC011
      ** Use processing date defined in SC24X7 dataarea when CSC011 is installed              CSC011
      ** and the support system is active.                                                    CSC011
                                                                                              CSC011
     C                   IF        (@CSC011 = 'Y') AND (LIBR = S1SUPP)                        CSC011
     C                   EVAL      ZDAYNO = WPRDTE                                            CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      ZDAYNO = BJRDNB                                            CSC011
     C                   ENDIF                                                                CSC011
 
     **  Convert rundate to YYMMDD format.
     C                   CALLB     'ZDATE2'
     C**********         PARM      BJRDNB        ZDAYNO            5 0                        CSC011
     C                   PARM                    ZDAYNO            5 0                        CSC011
     C                   PARM      'M'           ZDATFM            1
     C                   PARM      *ZEROS        ZDATE             6 0
     C                   PARM      *BLANK        ZADATE            7
 
     C                   MOVE      ZDATE         RUNDYY
     C                   MOVEL     ZDATE         RUNDMD
 
     **  Get sequence number from data area.
     C     PYTP          IFEQ      'RP'
     C     *LOCK         IN        RGPAYD
     C**********         Z-ADD     RSQNM         PRNUM                                        CFT151
     C                   MOVEL     RSQNM         PRNUM                                        CFT151
     C                   ADD       1             RSQNM
     C                   OUT       RGPAYD
     C                   ELSE
      *
     C/COPY WNCPYSRC,FTH00059
     C                   IF        CFT151 = 'N'                                               CFT151
     C     *LOCK         IN        OTPAYD
     C**********         Z-ADD     OSQNM         PRNUM                                        CFT151
     C**********         ADD       1             OSQNM                                        CFT151
     C                   MOVEL     WOTSQ         PRNUM                                        CFT151
     C                   ADD       1             WOTSQ                                        CFT151
     C                   OUT       OTPAYD
     C                   ELSE                                                                 CFT151
     C                   CALL      'FT000328'                                                 CFT151
     C                   PARM                    PRTCD                                        CFT151
     C                   PARM      'OT'          W@OTIN            2                          CFT151
     C                   PARM      'A'           WCALC             1                          CFT151
     C                   PARM      'Y'           WUPD              1                          CFT151
     C                   PARM                    PRNUM                                        CFT151
     C                   PARM                    WNEWSQ            4                          CFT151
     C                   ENDIF                                                                CFT151
     C/COPY WNCPYSRC,FTH00060
     C                   END
     C/COPY WNCPYSRC,FTH00061
 
     C                   MOVE      IPREF         SPREF
 
     C/COPY WNCPYSRC,FTH00062
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - End Program
      *****************************************************************
     C     ENDP          BEGSR
      *
     C                   MOVEL     'T'           @SCRN
     C/COPY WNCPYSRC,FTH00155
      *
     C                   ENDSR
      /EJECT                                                                    CAP011
      *****************************************************************         CAP011
      *                                                               *         CAP011
      * TDtDtaSubs - Transaction Details Data Substitution            *         CAP011
      *                                                               *         CAP011
      *****************************************************************         CAP011
                                                                                CAP011
     C     TDtDtaSubs    BEGSR                                                  CAP011
                                                                                CAP011
      ** Substitute the data for the various parts of the transaction,          CAP011
      ** dependent on the flags that were set earlier.                          CAP011
                                                                                CAP011
     C                   if        RepPrim = 'Y'                                CAP011
                                                                                CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   clear                   IncData                        CAP011
     C                   clear                   CurData                        CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
                                                                                CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode       10            CAP011
      * Substitution character                                                  CAP011
     C                   PARM      GHSUBS        SubsChar          1            CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NewPmtScn1    IncDATA        2000            CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurPmtScn1    CurDATA        2000            CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NewPmtScn1                     CAP011
                                                                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C                   if        RepSecA = 'Y'                                CAP011
                                                                                CAP011
     C                   clear                   IncData                        CAP011
     C                   clear                   CurData                        CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * Substitution character                                                  CAP011
     C                   PARM                    GHSUBS                         CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NewPmtSc2a    IncData                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurPmtSc2a    CurData                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NewPmtSc2a                     CAP011
                                                                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C                   if        RepSecB = 'Y'                                CAP011
                                                                                CAP011
     C                   clear                   IncData                        CAP011
     C                   clear                   CurData                        CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * Substitution character                                                  CAP011
     C                   PARM                    GHSUBS                         CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NewPmtSc2b    IncData                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurPmtSc2b    CurData                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       CurPmtSc2b                     CAP011
                                                                                CAP011
     C                   endif                                                  CAP011
                                                                                CAP011
     C                   if        RepThir = 'Y'                                CAP011
                                                                                CAP011
     C                   clear                   IncData                        CAP011
     C                   clear                   CurData                        CAP011
     C                   RESET                   ReturnCode                     CAP011
     C                   CALLB     'APDTASUBS'                                  CAP011
      * Return Code                                                             CAP011
     C                   PARM                    ReturnCode                     CAP011
      * Substitution character                                                  CAP011
     C                   PARM                    GHSUBS                         CAP011
      * Incoming Data                                                           CAP011
     C                   PARM      NewPmtScn3    IncData                        CAP011
      * Current Data                                                            CAP011
     C                   PARM      CurPmtScn3    CurData                        CAP011
                                                                                CAP011
     C                   MOVEL     IncDATA       NewPmtScn3                     CAP011
                                                                                CAP011
     C                   endif                                                  CAP011
                                                                                CFT014
     C                   If        RepPrmB = 'Y'                                CFT014
     C                   Clear                   IncData                        CFT014
     C                   Clear                   CurData                        CFT014
     C                   Reset                   ReturnCode                     CFT014
                                                                                CFT014
     C                   CallB     'APDTASUBS'                                  CFT014
     C                   Parm                    ReturnCode                     CFT014
     C                   Parm                    GHSUBS                         CFT014
     C                   Parm      NewPmtSc1b    IncData                        CFT014
     C                   Parm      CurPmtSc1b    CurData                        CFT014
                                                                                CFT014
     C                   Movel     IncDATA       NewPmtSc1b                     CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   If        RepThrB = 'Y'                                CFT014
     C                   Clear                   IncData                        CFT014
     C                   Clear                   CurData                        CFT014
     C                   Reset                   ReturnCode                     CFT014
                                                                                CFT014
     C                   CallB     'APDTASUBS'                                  CFT014
     C                   Parm                    ReturnCode                     CFT014
     C                   Parm                    GHSUBS                         CFT014
     C                   Parm      NewPmtSc3b    IncData                        CFT014
     C                   Parm      CurPmtSc3b    CurData                        CFT014
                                                                                CFT014
     C                   Movel     IncDATA       NewPmtSc3b                     CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   If        RepFour = 'Y'                                CFT014
     C                   Clear                   IncData                        CFT014
     C                   Clear                   CurData                        CFT014
     C                   Reset                   ReturnCode                     CFT014
                                                                                CFT014
     C                   CallB     'APDTASUBS'                                  CFT014
     C                   Parm                    ReturnCode                     CFT014
     C                   Parm                    GHSUBS                         CFT014
     C                   Parm      NewPmtScn4    IncData                        CFT014
     C                   Parm      CurPmtScn4    CurData                        CFT014
                                                                                CFT014
     C                   Movel     IncDATA       NewPmtScn4                     CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   If        RepMarg = 'Y'                                CFT014
     C                   Clear                   IncData                        CFT014
     C                   Clear                   CurData                        CFT014
     C                   Reset                   ReturnCode                     CFT014
                                                                                CFT014
     C                   CallB     'APDTASUBS'                                  CFT014
     C                   Parm                    ReturnCode                     CFT014
     C                   Parm                    GHSUBS                         CFT014
     C                   Parm      NewPmtScn5    IncData                        CFT014
     C                   Parm      CurPmtScn5    CurData                        CFT014
                                                                                CFT014
     C                   Movel     IncDATA       NewPmtScn5                     CFT014
     C                   EndIf                                                  CFT014
                                                                                CAP011
     C                   IF        CSW209 = 'Y'                                               CSW209
      *                                                                                       CSW209
     C                   IF        RepCovA = 'Y'                                              CSW209
     C                   CLEAR                   IncData                                      CSW209
     C                   CLEAR                   CurData                                      CSW209
     C                   RESET                   ReturnCode                                   CSW209
                                                                                              CSW209
     C                   CALLB     'APDTASUBS'                                                CSW209
     C                   PARM                    ReturnCode                                   CSW209
     C                   PARM                    GHSUBS                                       CSW209
     C                   PARM      NewPmtScn6    IncData                                      CSW209
     C                   PARM      CurPmtScn6    CurData                                      CSW209
                                                                                              CSW209
     C                   MOVEL     IncDATA       NewPmtScn6                                   CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   IF        RepCovD = 'Y'                                              CSW209
     C                   CLEAR                   IncData                                      CSW209
     C                   CLEAR                   CurData                                      CSW209
     C                   RESET                   ReturnCode                                   CSW209
                                                                                              CSW209
     C                   CALLB     'APDTASUBS'                                                CSW209
     C                   PARM                    ReturnCode                                   CSW209
     C                   PARM                    GHSUBS                                       CSW209
     C                   PARM      NewPmtScn7    IncData                                      CSW209
     C                   PARM      CurPmtScn7    CurData                                      CSW209
                                                                                              CSW209
     C                   MOVEL     IncDATA       NewPmtScn7                                   CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   IF        RepFivA = 'Y'                                              CER059
     C                   CLEAR                   IncData                                      CER059
     C                   CLEAR                   CurData                                      CER059
     C                   RESET                   ReturnCode                                   CER059
                                                                                              CER059
     C                   CALLB     'APDTASUBS'                                                CER059
     C                   PARM                    ReturnCode                                   CER059
     C                   PARM                    GHSUBS                                       CER059
     C                   PARM      NewPmtScn5A   IncData                                      CER059
     C                   PARM      CurPmtScn5A   CurData                                      CER059
                                                                                              CER059
     C                   MOVEL     IncDATA       NewPmtScn5A                                  CER059
     C                   ENDIF                                                                CER059
      *                                                                                       CER059
     C                   IF        RepFivB = 'Y'                                              CER059
     C                   CLEAR                   IncData                                      CER059
     C                   CLEAR                   CurData                                      CER059
     C                   RESET                   ReturnCode                                   CER059
                                                                                              CER059
     C                   CALLB     'APDTASUBS'                                                CER059
     C                   PARM                    ReturnCode                                   CER059
     C                   PARM                    GHSUBS                                       CER059
     C                   PARM      NewPmtScn5B   IncData                                      CER059
     C                   PARM      CurPmtScn5B   CurData                                      CER059
                                                                                              CER059
     C                   MOVEL     IncDATA       NewPmtScn5B                                  CER059
     C                   ENDIF                                                                CER059
      *                                                                                       CER059
     C                   ENDIF                                                                CSW209
                                                                                CAP011
     C                   ENDSR                                                  CAP011
      *****************************************************************
      /EJECT
      *****************************************************************         CFT007
      * BIC Database Plus Integration                                           CFT007
      *****************************************************************         CFT007
     C     BICPrompt     BEGSR                                                  CFT007
                                                                                CFT007
      * BIC Database update prompt and search processing                        CFT007
                                                                                CFT007
      * Determine whether the cursor is on an allowed field                     CFT007
                                                                                CFT007
      * Note: If these screen fields move then these values                     CFT007
      *       will need changing                                                CFT007
                                                                                CFT007
      *       The formula is (cursor row number * 256) + column number          CFT007
                                                                                CFT007
     C                   EVAL      BICLines = *Zeros                            CFT007
     C                   EVAL      @ICriteria = *Blanks                         CFT007
                                                                                CFT007
     C                   SELECT                                                 CFT007
                                                                                CFT007
      * Destination line 1                                                      CFT007
                                                                                CFT007
     C                   WHEN      @SCRN = 'P' and                              CFT007
     C                             CursorLoc >= 1794 and CursorLoc <= 1828      CFT007
     C                   EVAL      Line1Dest = *On                              CFT007
     C                   EVAL      @ICriteria = SDST1                           CFT007
                                                                                CFT007
      * Destination line 2                                                      CFT007
                                                                                CFT007
     C                   WHEN      @SCRN = 'P' and                              CFT007
     C                             CursorLoc >= 1837 and CursorLoc <= 1871      CFT007
     C                   EVAL      Line2Dest = *On                              CFT007
     C                   EVAL      @ICriteria = SDST2                           CFT007
                                                                                CFT007
      * Ordering customer line 1                                                CFT007
                                                                                CFT007
     C                   WHEN      @SCRN = 'P' and                              CFT007
     C                             CursorLoc >= 2562 and CursorLoc <= 2596      CFT007
     C                   EVAL      Line1OCus = *On                              CFT007
     C                   Eval      @ICriteria = SORC1                           CFT007
                                                                                CFT007
      * Ordering customer line 2                                                CFT007
                                                                                CFT007
     C                   WHEN      @SCRN = 'P' and                              CFT007
     C                             CursorLoc >= 2605 and CursorLoc <= 2639      CFT007
     C                   EVAL      Line2OCus = *On                              CFT007
     C                   EVAL      @ICriteria = SORC2                           CFT007
                                                                                CFT007
      * Receiver's correspondent line 1                                         CFT007
                                                                                CFT007
     C                   WHEN      @SCRN = 'S' and                              CFT007
     C                             CursorLoc >= 1325 and CursorLoc <= 1359      CFT007
     C                   EVAL      Line1RCor = *On                              CFT007
     C                   EVAL      @ICriteria = SRCO1                           CFT007
                                                                                CFT007
      * Receiver's correspondent line 2                                         CFT007
                                                                                CFT007
     C                   WHEN      @SCRN = 'S' and                              CFT007
     C                             CursorLoc >= 1538 and CursorLoc <= 1572      CFT007
     C                   EVAL      Line2RCor = *On                              CFT007
     C                   EVAL      @ICriteria = SRCO2                           CFT007
                                                                                CFT007
      * Account with bank line 1                                                CFT007
                                                                                CFT007
     C                   WHEN      @SCRN = 'S' and                              CFT007
     C***********                  CursorLoc >= 2093 and CursorLoc <= 2127      CFT007 CFT014
     C                             CursorLoc >= 3629 and CursorLoc <= 3663      CFT014
     C                   EVAL      Line1ABnk = *On                              CFT007
     C                   EVAL      @ICriteria = SACB1                           CFT007
                                                                                CFT007
      * Account with bank line 2                                                CFT007
                                                                                CFT007
     C                   WHEN      @SCRN = 'S' and                              CFT007
     C***********                  CursorLoc >= 2306 and CursorLoc <= 2340      CFT007 CFT014
     C                             CursorLoc >= 3842 and CursorLoc <= 3876      CFT014
     C                   EVAL      Line2ABnk = *On                              CFT007
     C                   EVAL      @ICriteria = SACB2                           CFT007
                                                                                CFT007
      * Beneficiary line 1                                                      CFT007
                                                                                CFT007
     C                   WHEN      @SCRN = 'S' and                              CFT007
     C***********                  CursorLoc >= 2861 and CursorLoc <= 2895      CFT007 CFT014
     C                             CursorLoc >= 4397 and CursorLoc <= 4431      CFT014
     C                   EVAL      Line1Benf = *On                              CFT007
     C                   EVAL      @ICriteria = SBNC1                           CFT007
                                                                                CFT007
      * Beneficiary line 2                                                      CFT007
                                                                                CFT007
     C                   WHEN      @SCRN = 'S' and                              CFT007
     C***********                  CursorLoc >= 3074 and CursorLoc <= 3108      CFT007 CFT014
     C                             CursorLoc >= 4610 and CursorLoc <= 4644      CFT014
     C                   EVAL      Line2Benf = *On                              CFT007
     C                   EVAL      @ICriteria = SBNC2                           CFT007
                                                                                CFT007
      * Intermediary bank line 1                                                CFT007
                                                                                CFT007
     C***********        WHEN      @SCRN = 'O' and                              CFT007 CFT014
     C***********                  CursorLoc >= 1050 and CursorLoc <= 1084      CFT007 CFT014
     C                   When      (@SCRN = 'S') And                            CFT014
     C                             (CursorLoc >= 2861) And (CursorLoc <= 2895)  CFT014
     C                   EVAL      Line1IBnk = *On                              CFT007
     C                   EVAL      @ICriteria = SINB1                           CFT007
                                                                                CFT007
      * Intermediary bank line 2                                                CFT007
                                                                                CFT007
     C***********        WHEN      @SCRN = 'O' and                              CFT007 CFT014
     C***********                  CursorLoc >= 1306 and CursorLoc <= 1340      CFT007 CFT014
     C                   When      (@SCRN = 'S') And                            CFT014
     C                             (CursorLoc >= 3074) And (CursorLoc <= 3108)  CFT014
     C                   EVAL      Line2IBnk = *On                              CFT007
     C                   EVAL      @ICriteria = SINB2                           CFT007
                                                                                CFT014
      ** Third reimbursement institution line 1                                 CFT014
                                                                                CFT014
     C                   When      (@SCRN = 'S') And                            CFT014
     C                             (CursorLoc >= 2093) And (CursorLoc <= 2127)  CFT014
     C                   Eval      Line1TRIn = *On                              CFT014
     C                   Eval      @ICriteria = STRI1                           CFT014
                                                                                CFT014
      ** Third reimbursement institution line 2                                 CFT014
                                                                                CFT014
     C                   When      (@SCRN = 'S') And                            CFT014
     C                             (CursorLoc >= 2306) And (CursorLoc <= 2340)  CFT014
     C                   Eval      Line2TRIn = *On                              CFT014
     C                   Eval      @ICriteria = STRI2                           CFT014
                                                                                CFT007
     C                   OTHER                                                  CFT007
                                                                                CFT007
      * Error: Cursor outside permitted fields when F4 or F16 pressed           CFT007
                                                                                CFT007
     C                   If        @CFT014 = 'Y'                                CFT014
     C                   Eval      @ERRMS = 'FTM3261'                           CFT014
     C                   Else                                                   CFT014
     C                   EVAL      @ERRMS = 'FTM2620'                           CFT007
     C                   Endif                                                  CFT014
     C                   EXSR      SNDM@P1                                      CFT007
                                                                                CFT007
     C                   ENDSL                                                  CFT007
                                                                                CFT007
      * If F4 or F16 pressed on a permitted line                                CFT007
                                                                                CFT007
     C                   IF        BICLines <> *Zeros                           CFT007
                                                                                CFT007
      * Set up prompt mode                                                      CFT007
     C                   IF        @INKD = *On                                  CFT007
     C                   EVAL      @IMode = 'P'                                 CFT007
     C                   ENDIF                                                  CFT007
                                                                                CFT007
      * Set up search mode                                                      CFT007
     C                   IF        @INKQ = *On                                  CFT007
     C                   EVAl      @IMode = 'F'                                 CFT007
     C                   ENDIF                                                  CFT007
                                                                                CFT007
      * Call BIC Plus enquiry program                                           CFT007
                                                                                CFT007
     C                   CALL      'FT0900'                                     CFT007
     C                   PARM                    @IMode            1            CFT007
     C                   PARM                    @ICriteria       35            CFT007
     C                   PARM      *Blanks       @OAddress       175            CFT007
     C                   PARM      *Blanks       @OCHIPCode       10            CFT007
     C                   PARM      *Blanks       @OOutCode         2            CFT007
     C                   PARM      *Blanks       @RTCD                          CFT007
                                                                                CFT007
      * F3 pressed, exit program                                                CFT007
                                                                                CFT007
     C                   IF        @RTCD = 'F3'                                 CFT007
     C                   EVAL      @SCRN = 'T'                                  CFT007
     C                   ENDIF                                                  CFT007
                                                                                CFT007
     C                   IF        @RTCD = *Blanks                              CFT007
                                                                                CFT007
      * If a CHIPS code exists and data returned is not BIC code with           CFT007
      * clearing code ('AC')                                                    CFT007
                                                                                CFT007
     C                   IF        @OChipCode <> *Blanks and                    CFT007
     C                             @OOutCode <> 'AC'                            CFT007
                                                                                CFT007
      * If settlement currency for ordering customer or payment currency        CFT007
      * for all other organisations, matches USD dollar code                    CFT007
                                                                                CFT007
     C                   IF        SSMCY=BLUSCY and Line1OCus = *On or          CFT007
     C                             SPCCY=BLUSCY and                             CFT007
     C                             (Line1Dest = *On or                          CFT007
     C                              Line1RCor = *On or                          CFT007
     C                              Line1ABnk = *On or                          CFT007
     C                              Line1Benf = *On or                          CFT007
     C***********                   Line1IBnk = *On)                            CFT007 CFT014
     C                              Line1IBnk = *On or                          CFT014
     C                              (Line1TRIn = *On And @CFT014 = 'Y'))        CFT014
                                                                                CFT007
      * If returned data is not branch with clearing code ('BC') or address     CFT007
      * with clearing code ('DC'), shift data along to make room for CHIPS      CFT007
                                                                                CFT007
     C                   IF        @OOutCode <> 'BC' and @OOutCode <> 'DC'      CFT007
     C                   EVAL      @OAddress = WkBlankfld + @OAddress           CFT007
     C                   ENDIF                                                  CFT007
                                                                                CFT007
      * Write CHIPS code to first line, overwriting clearing code if present    CFT007
                                                                                CFT007
     C                   EVAL      WkCHIPCode = '//CH' + @OCHIPCode             CFT007
     C                   EVAL      OAddress1 = WkCHIPCode                       CFT007
     C                                                                          CFT007
     C                   ENDIF                                                  CFT007
     C                                                                          CFT007
     C                   ENDIF                                                  CFT007
                                                                                CFT007
      * If return data is BIC code with clearing code 'AC' or (branch           CFT007
      * or address with clearing code 'BC'/'DC' and cursor is on                CFT007
      * a 2nd line)...                                                          CFT007
                                                                                CFT007
     C                   IF          @OOutCode = 'AC' or                        CFT007
     C                             ((@OOutCode = 'BC' or                        CFT007
     C                               @OOutCode = 'DC') and                      CFT007
     C                              (Line2OCus = *On or                         CFT007
     C                               Line2Dest = *On or                         CFT007
     C                               Line2RCor = *On or                         CFT007
     C                               Line2ABnk = *On or                         CFT007
     C                               Line2Benf = *On or                         CFT007
     C***********                    Line2IBnk = *On ))                         CFT007 CFT014
     C                              Line2IBnk = *On or                          CFT014
     C                              (Line2TRIn = *On And @CFT014 = 'Y')))       CFT014
                                                                                CFT007
      * Remove clearing code                                                    CFT007
                                                                                CFT007
     C                   MOVE      @OAddress     WkAddress       140            CFT007
     C                   MOVEL     WkAddress     @OAddress                      CFT007
                                                                                CFT007
     C                   ENDIF                                                  CFT007
                                                                                CFT007
      * Move details to screen                                                  CFT007
                                                                                CFT007
     C                   SELECT                                                 CFT007
                                                                                CFT007
      * Destination line 1                                                      CFT007
     C                   WHEN      Line1Dest = *On                              CFT007
     C                   EVAL      SDST1 = OAddress1                            CFT007
     C                   EVAL      SDST2 = OAddress2                            CFT007
     C                   EVAL      SDST3 = OAddress3                            CFT007
     C                   EVAL      SDST4 = OAddress4                            CFT007
                                                                                CFT007
      * Destination line 2                                                      CFT007
     C                   WHEN      Line2Dest = *On                              CFT007
     C                   EVAL      SDST2 = OAddress1                            CFT007
     C                   EVAL      SDST3 = OAddress2                            CFT007
     C                   EVAL      SDST4 = OAddress3                            CFT007
                                                                                CFT007
      * Ordering customer line 1                                                CFT007
     C                   WHEN      Line1OCus = *On                              CFT007
     C                   EVAL      SORC1 = OAddress1                            CFT007
     C                   EVAL      SORC2 = OAddress2                            CFT007
     C                   EVAL      SORC3 = OAddress3                            CFT007
     C                   EVAL      SORC4 = OAddress4                            CFT007
     C                   EVAL      SORC5 = OAddress5                                          CFT032
                                                                                CFT007
      * Ordering customer line 2                                                CFT007
     C                   WHEN      Line2OCus = *On                              CFT007
     C                   EVAL      SORC2 = OAddress1                            CFT007
     C                   EVAL      SORC3 = OAddress2                            CFT007
     C                   EVAL      SORC4 = OAddress3                            CFT007
     C                   EVAL      SORC5 = OAddress4                                          CFT032
                                                                                CFT007
      * Receiver's correspondent line 1                                         CFT007
     C                   WHEN      Line1RCor = *On                              CFT007
     C                   EVAL      SRCO1 = OAddress1                            CFT007
     C                   EVAL      SRCO2 = OAddress2                            CFT007
     C                   EVAL      SRCO3 = OAddress3                            CFT007
     C                   EVAL      SRCO4 = OAddress4                            CFT007
     C                   EVAL      SRCO5 = OAddress5                            CFT007
                                                                                CFT007
      * Receiver's correspondent line 2                                         CFT007
     C                   WHEN      Line2RCor = *On                              CFT007
     C                   EVAL      SRCO2 = OAddress1                            CFT007
     C                   EVAL      SRCO3 = OAddress2                            CFT007
     C                   EVAL      SRCO4 = OAddress3                            CFT007
     C                   EVAL      SRCO5 = OAddress4                            CFT007
                                                                                CFT007
      * Account with bank line 1                                                CFT007
     C                   WHEN      Line1ABnk = *On                              CFT007
     C                   EVAL      SACB1 = OAddress1                            CFT007
     C                   EVAL      SACB2 = OAddress2                            CFT007
     C                   EVAL      SACB3 = OAddress3                            CFT007
     C                   EVAL      SACB4 = OAddress4                            CFT007
     C                   EVAL      SACB5 = OAddress5                            CFT007
                                                                                CFT007
      * Account with bank line 2                                                CFT007
     C                   WHEN      Line2ABnk = *On                              CFT007
     C                   EVAL      SACB2 = OAddress1                            CFT007
     C                   EVAL      SACB3 = OAddress2                            CFT007
     C                   EVAL      SACB4 = OAddress3                            CFT007
     C                   EVAL      SACB5 = OAddress4                            CFT007
                                                                                CFT007
      * Beneficiary line 1                                                      CFT007
     C                   WHEN      Line1Benf = *On                              CFT007
     C                   EVAL      SBNC1 = OAddress1                            CFT007
     C                   EVAL      SBNC2 = OAddress2                            CFT007
     C                   EVAL      SBNC3 = OAddress3                            CFT007
     C                   EVAL      SBNC4 = OAddress4                            CFT007
     C                   EVAL      SBNC5 = OAddress5                            CFT007
                                                                                CFT007
      * Beneficiary line 2                                                      CFT007
     C                   WHEN      Line2Benf = *On                              CFT007
     C                   EVAL      SBNC2 = OAddress1                            CFT007
     C                   EVAL      SBNC3 = OAddress2                            CFT007
     C                   EVAL      SBNC4 = OAddress3                            CFT007
     C                   EVAL      SBNC5 = OAddress4                            CFT007
                                                                                CFT007
      * Intermediary bank line 1                                                CFT007
     C                   WHEN      Line1IBnk = *On                              CFT007
     C                   EVAL      SINB1 = OAddress1                            CFT007
     C                   EVAL      SINB2 = OAddress2                            CFT007
     C                   EVAL      SINB3 = OAddress3                            CFT007
     C                   EVAL      SINB4 = OAddress4                            CFT007
     C                   EVAL      SINB5 = OAddress5                            CFT007
                                                                                CFT007
      * Intermediary bank line 2                                                CFT007
     C                   WHEN      Line2IBnk = *On                              CFT007
     C                   EVAL      SINB2 = OAddress1                            CFT007
     C                   EVAL      SINB3 = OAddress2                            CFT007
     C                   EVAL      SINB4 = OAddress3                            CFT007
     C                   EVAL      SINB5 = OAddress4                            CFT007
                                                                                CFT014
      ** Third Reimbursement Institution Line 1                                 CFT014
                                                                                CFT014
     C                   When      (Line1TRIn = *On) And (@CFT014 = 'Y')        CFT014
     C                   Eval      STRI1 = OAddress1                            CFT014
     C                   Eval      STRI2 = OAddress2                            CFT014
     C                   Eval      STRI3 = OAddress3                            CFT014
     C                   Eval      STRI4 = OAddress4                            CFT014
     C                   Eval      STRI5 = OAddress5                            CFT014
                                                                                CFT014
      ** Third Reimbursement Institution Line 2                                 CFT014
                                                                                CFT014
     C                   When      (Line2TRIn = *On) And (@CFT014 = 'Y')        CFT014
     C                   Eval      STRI2 = OAddress1                            CFT014
     C                   Eval      STRI3 = OAddress2                            CFT014
     C                   Eval      STRI4 = OAddress3                            CFT014
     C                   Eval      STRI5 = OAddress4                            CFT014
                                                                                CFT007
     C                   ENDSL                                                  CFT007
                                                                                CFT007
     C                   ENDIF                                                  CFT007
                                                                                CFT007
     C                   ENDIF                                                  CFT007
                                                                                CFT007
     C                   ENDSR                                                  CFT007
      *****************************************************************         CFT007
      /EJECT                                                                    CFT007
      *****************************************************************
      * INITIAL Go To Initial Screen
      *****************************************************************
     C     INITIAL       BEGSR
      *
      * Blank the screens
      *
     C                   MOVEL     *BLANK        NewPmtScn1
     C                   MOVEL     *BLANK        NewPmtSc1b                     CFT014
     C                   MOVEL     *BLANK        NewPmtSc2a
     C                   MOVEL     *BLANK        NewPmtSc2b
     C                   MOVEL     *BLANK        NewPmtScn3
     C                   MOVEL     *BLANK        NewPmtSc3b                     CFT014
     C                   MOVEL     *BLANK        NewPmtScn4                     CFT014
     C                   MOVEL     *BLANK        NewPmtScn5                     CFT014
     C                   MOVEL     *BLANK        NewPmtScn6                                   CSW209
     C                   MOVEL     *BLANK        NewPmtScn7                                   CSW209
     C                   MOVEL     *BLANKS       NewPmtScn5A                                  CER030
     C                   MOVEL     *BLANKS       NewPmtScn5B                                  CER030
     C                   MOVEL     *BLANK        DDSTAT
      *
      * Primary Details Screen
      *
     C                   MOVEL     'P'           @SCRN             1
      *
      * Initialize field status on Primary Screen
      *
     C                   EXSR      IFDS@P
      *
      * Initialize F10 & F21 key fields
     C                   MOVE      'N'           @EINKJ
     C                   MOVE      'N'           @EINKV
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Dummy input parameters to allow call from FTC0041
     C     *ENTRY        PLIST
     C                   PARM                    @SORT             1
     C                   PARM                    XPREF            15
     C                   PARM                    @ReturnCde        1
      *
      ** Initialize program name
      *
     C                   MOVEL     'FTOPAYRPR'   DBPGM
 
      * Key Lists
      *
     C     ZAPMTKD0      KLIST
     C                   KFLD                    @FOTRANSEL
     C                   KFLD                    @TMESTPSEL
     C     ZAPMTKX0      KLIST
     C                   KFLD                    @TMESTPSEL
     C                   KFLD                    @FOTRANSEL
                                                                                              CSC011
     C     KLOGL0        KLIST                                                                CSC011
     C                   KFLD                    KMTYP                                        CSC011
     C                   KFLD                    @FOTRANSEL                                   CSC011
     C                   KFLD                    @TMESTPSEL                                   CSC011
 
     C     FTIOPKEY      KLIST                                                                CER001
     C                   KFLD                    #1TMST                                       CER001
     C                   KFLD                    #1FOTR                                       CER001
      *                                                                                       CER001
     C     *LIKE         DEFINE    OPPREF        K@PREF                                       CER001
     C     K@KEY         KLIST                                                                CER001
     C                   KFLD                    K@PREF                                       CER001
      *                                                                                       CER001
      * Clear fields used invalidation
     C                   Clear                   Val@Fields
 
      * GET ZMUSER to access default branch.
     C     *DTAARA       Define                  ZMUSER
     C                   In        ZMUSER
     C                   Unlock    ZMUSER
 
     C                   Eval      @DFBR = WDFBR
     C                   Eval      @DPPT = WDPPT
 
      * Get RUNDAT to access Multi Branch Indicator
     C     *DTAARA       Define                  RUNDAT
     C                   In        RUNDAT
     C                   Unlock    RUNDAT
 
     C                   Eval      @MBIN = WMBIN
 
      *  Move program name into *LDA field.
     C     *LOCK         In        LDA
     C                   Movel     'FTOPAYRPR'   DBPGM
     C                   Out       LDA
 
      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      * Access Funds Transfer details via access program
      *  (database error handling done in access program)
     C                   CALL      'AOFTFRR0'
     C                   Parm      '*DBERR'      @RTCD
     C                   Parm      '*FIRST'      @OPTN
     C     SDFTFR        Parm      SDFTFR        DSFDY
 
     C                   Eval      @RATDIS = WRATDIS
 
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      * Read SDRETLPD for retail details
      *  (database error handling done in access program)
      * Only if RETAIL switched on.
     C                   If        BGRTBN = 'Y'
     C                   CALLB     'AORETLR0'
     C                   Parm      '*DBERR'      @RTCD
     C                   Parm      '*FIRST'      @OPTN
     C     SDRETL        Parm      SDRETL        DSFDY
     C                   End
 
      * Read SDTRADPD for Trading Details
     C                   CALLB     'AOTRADR0'
     C                   Parm      '*DBERR'      @RTCD
     C                   Parm      '*FIRST'      @OPTN
     C     SDTRAD        Parm      SDTRAD        DSFDY
 
      * Access SAR details file to determine if CEU006 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CEU006'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C     *LOCK         In        LDA
     C                   Movel     'SCSARDPD'    DBFILE                         * DBERROR 002 *
     C                   Movel     '002'         DBASE
     C                   Movel     'CEU006'      DBKEY
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   End
 
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CEU006           1
     C                   Else
     C                   Movel     'N'           @CEU006
     C                   End
 
      * Access SAR details file to determine if S01494 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'S01494'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C     *LOCK         In        LDA
     C                   Movel     'SCSARDPD'    DBFILE                         * DBERROR 002 *
     C                   Movel     '002'         DBASE
     C                   Movel     'S01494'      DBKEY
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   End
 
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @01494
     C                   Else
     C                   Movel     'N'           @01494
     C                   End
 
      * Access SAR details file to determine if S01499 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'S01499'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C     *LOCK         In        LDA
     C                   Movel     'SCSARDPD'    DBFILE                         * DBERROR 002 *
     C                   Movel     '002'         DBASE
     C                   Movel     'S01499'      DBKEY
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   End
 
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @01499
     C                   Else
     C                   Movel     'N'           @01499
     C                   End
 
      * Access SAR details file to see if CFT003 is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CFT003'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C                   Movel     'SCSARDPD'    DBFILE                         * DBERROR 002 *
     C                   Movel     '002'         DBASE
     C                   Movel     'CFT003'      DBKEY
     C                   Exsr      *PSSR
     C                   End
 
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CFT003
     C                   Else
     C                   Movel     'N'           @CFT003
     C                   End
                                                                                CFT014
      ** Access SAR details file to see if CFT014 is installed.                 CFT014
                                                                                CFT014
     C                   CallB     'AOSARDR0'                                   CFT014
     C                   Parm      *Blanks       @RTCD                          CFT014
     C                   Parm      '*VERIFY'     @OPTN                          CFT014
     C                   Parm      'CFT014'      @SARD                          CFT014
     C     SCSARD        Parm      SCSARD        DSFDY                          CFT014
                                                                                CFT014
     C                   If        @RTCD <> *Blanks and                         CFT014
     C                             @RTCD <> '*NRF   '                           CFT014
     C                   Movel     'SCSARDPD'    DBFILE                         CFT014
     C                   Movel     '010'         DBASE                          CFT014
     C                   Movel     'CFT014'      DBKEY                          CFT014
     C                   ExSr      *PSSR                                        CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   If        @RTCD = *Blanks                              CFT014
     C                   Movel     'Y'           @CFT014                        CFT014
     C                   Else                                                   CFT014
     C                   Movel     'N'           @CFT014                        CFT014
     C                   EndIf                                                  CFT014
 
      * Access SAR details file to see if S01508 is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'S01508'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C                   Movel     'SCSARDPD'    DBFILE                         * DBERROR 002 *
     C                   Movel     '002'         DBASE
     C                   Movel     'S01508'      DBKEY
     C                   Exsr      *PSSR
     C                   End
 
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @01508
     C                   Else
     C                   Movel     'N'           @01508
     C                   End
 
      * Access SAR details file to see if S01506 is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'S01506'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C                   Movel     'SCSARDPD'    DBFILE                         * DBERROR 002 *
     C                   Movel     '002'         DBASE
     C                   Movel     'S01506'      DBKEY
     C                   Exsr      *PSSR
     C                   End
 
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @01506
     C                   Else
     C                   Movel     'N'           @01506
     C                   End
                                                                                CFT004
      * Access SAR details file to see if CFT004 is installed.                  CFT004
      *                                                                         CFT004
     C                   CALLB     'AOSARDR0'                                   CFT004
     C                   Parm      *BLANKS       @RTCD                          CFT004
     C                   Parm      '*VERIFY'     @OPTN                          CFT004
     C                   Parm      'CFT004'      @SARD                          CFT004
     C     SCSARD        Parm      SCSARD        DSFDY                          CFT004
                                                                                CFT004
     C                   If        @RTCD = *Blanks                              CFT004
     C                   Movel     'Y'           @CFT004                        CFT004
     C                   Else                                                   CFT004
     C                   Movel     'N'           @CFT004                        CFT004
     C                   End                                                    CFT004
     C/COPY WNCPYSRC,FTOPAYRC12
     C/COPY OFCPYSRCZ,CFT148_006                                                              CFT148
 
      * Retrieve Base Currency Details
     C                   Move      BJCYCD        @K101
     C                   CALLB     'AOCURRR0'
     C                   Parm      '*DBERR '     @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm                    @K101             3
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   Eval      @BCDP = A6NBDP
                                                                                CFT007
      * Access SAR details file to see if CFT007 is installed.                  CFT007
      *                                                                         CFT007
     C                   CALLB     'AOSARDR0'                                   CFT007
     C                   Parm      *BLANKS       @RTCD                          CFT007
     C                   Parm      '*VERIFY'     @OPTN                          CFT007
     C                   Parm      'CFT007'      @SARD                          CFT007
     C     SCSARD        Parm      SCSARD        DSFDY                          CFT007
                                                                                CFT007
     C                   If        @RTCD = *Blanks                              CFT007
     C                   Movel     'Y'           @CFT007           1            CFT007
     C                   Else                                                   CFT007
     C                   Movel     'N'           @CFT007                        CFT007
     C                   End                                                    CFT007
      *                                                                                     MD022652
      ** Access SAR details file to see if CFT050 is installed.                             MD022652
      *                                                                                     MD022652
     C                   CALLB     'AOSARDR0'                                               MD022652
     C                   Parm      *BLANKS       PRTCD             7                        MD022652
     C                   Parm      '*VERIFY'     POPTN             7                        MD022652
     C                   Parm      'CFT050'      PSARD             6                        MD022652
     C     SCSARD        Parm      SCSARD        DSFDY                                      MD022652
      ** CFT007 process will take place when CFT050 is switched on                          MD022652
     C                   IF        PRTCD = *Blanks                                          MD022652
     C                   EVAL      @CFT007 = 'Y'                                            MD022652
     C                   ENDIF                                                              MD022652
     C/COPY WNCPYSRC,FTOPAYRC13
                                                                                CFT009
      * Access SAR details file to see if CFT009 is installed.                  CFT009
      *                                                                         CFT009
     C                   CALLB     'AOSARDR0'                                   CFT009
     C                   PARM      *BLANKS       @RTCD                          CFT009
     C                   PARM      '*VERIFY'     @OPTN                          CFT009
     C                   PARM      'CFT009'      @SARD                          CFT009
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT009
                                                                                CFT009
     C                   IF        @RTCD = *BLANKS                              CFT009
     C                   MOVEL     'Y'           @CFT009           1            CFT009
     C                   ELSE                                                   CFT009
     C                   MOVEL     'N'           @CFT009                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      * Access SAR details file to see if CFT010 is installed.                  CFT009
      *                                                                         CFT009
     C                   CALLB     'AOSARDR0'                                   CFT009
     C                   PARM      *BLANKS       @RTCD                          CFT009
     C                   PARM      '*VERIFY'     @OPTN                          CFT009
     C                   PARM      'CFT010'      @SARD                          CFT009
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT009
                                                                                CFT009
     C                   IF        @RTCD = *BLANKS                              CFT009
     C                   MOVEL     'Y'           @CFT010           1            CFT009
     C                   ELSE                                                   CFT009
     C                   MOVEL     'N'           @CFT010                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                              CSC011
      ** Access SAR details file to see if 24X7 (CSC011) is installed.                        CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD <> *BLANKS AND                                       CSC011
     C                             PRTCD <> '*NRF   '                                         CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 11                                                 CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *BLANKS                                            CSC011
     C                   EVAL      @CSC011 = 'Y'                                              CSC011
                                                                                              CSC011
     C                   OPEN      APILOGL0                                                   CSC011
                                                                                              CSC011
      ** Get support system prefix and current system prefix                                  CSC011
                                                                                              CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      @CSC011 = 'N'                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CGL014
      ** Check if enhancement CGL014 (Collaterals Processing) is on                           CGL014
                                                                                              CGL014
     C                   CALLB     'AOSARDR0'                                                 CGL014
     C                   PARM      *BLANKS       PRTCD                                        CGL014
     C                   PARM      '*VERIFY'     POPTN                                        CGL014
     C                   PARM      'CGL014'      PSARD                                        CGL014
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL014
                                                                                              CGL014
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CGL014
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL014
     C                   EVAL      DBKEY  = 'CGL014'                                          CGL014
     C                   EVAL      DBASE  = 12                                                CGL014
     C                   EXSR      *PSSR                                                      CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        PRTCD = *BLANKS                                            CGL014
     C                   EVAL      @CGL014 = 'Y'                                              CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      @CGL014 = 'N'                                              CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C/COPY WNCPYSRC,FTOPAYRC05
                                                                                              CSC011
      ** Use processing date defined in SC24X7 dataarea when support system                   CSC011
      ** is active.                                                                           CSC011
                                                                                              CSC011
     C                   IF        (@CSC011 = 'Y') AND (LIBR = S1SUPP)                        CSC011
     C                   EVAL      ZDAYNO = WPRDTE                                            CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      ZDAYNO = BJRDNB                                            CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSD015
      ** Check if CSD015 is installed                                                         CSD015
                                                                                              CSD015
     C                   EVAL      @CSD015 = 'N'                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*VERIFY'     @Optn                                        CSD015
     C                   PARM      'CSD015'      @Sard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (@RtCd <> *BLANKS) and                                     CSD015
     C                             (@RtCd <> '*NRF   ')                                       CSD015
     C                   EVAL      DBKEY = 'CSD015'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 003                                                CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        @RtCd = *BLANKS                                            CSD015
     C                   EVAL      @CSD015 = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      **  Access SAR details to see if CCF001 is switched on.                                 CSD015
                                                                                              CSD015
     C                   EVAL      @CCF001 = 'N'                                              CSD015
     C                   CALL      'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*VERIFY'     @Optn                                        CSD015
     C                   PARM      'CCF001'      @SARD                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        @RtCd <> *Blanks  and                                      CSD015
     C                             @RtCd <> '*NRF'                                            CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = 'CCF001'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 004                                                CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        @RtCd = *BLANKS                                            CSD015
     C                   EVAL      @CCF001 = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      **                                                                                      CSC022
      ** Access SAR details to see if CSC022 is switched on                                   CSC022
      **                                                                                      CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *Blanks       PRtCd                                        CSC022
     C                   Parm      '*VERIFY'     POptn                                        CSC022
     C                   Parm      'CSC022'      PSard                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      ** Initialize CSC022 and Skip Commit Flags                                              CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   Eval      WSkpComtRolbk = 'N'                                        CSC022
      **                                                                                      CSC022
     C                   If        PRtCd = *BLANKS                                            CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
      **                                                                                      CSC022
      ** Get Jobs currently running i batch mode using SCCMRJOB dataarea                      CSC022
      **                                                                                      CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
      ** Move committed jobs to arrary for checking                                           CSC022
     C                   MoveA     WDSJobs       WJobs                                        CSC022
      ** Verify if job running exists in array                                                CSC022
     C                   Eval      WArrPtr = %LookUp(PSJobName:WJobs)                         CSC022
     C                   If        WArrPtr > 0                                                CSC022
     C                   Eval      WSkpComtRolbk = 'Y'                                        CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      **                                                                                      CSC022
     C                   Else                                                                 CSC022
      ** Execute *PSSR if CSC022 is not found or Database error                               CSC022
     C                   If        PRtCd <> '*NRF'                                            CSC022
     C     *Lock         In        LDA                                                        CSC022
     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
     C                   Eval      DBPgm  = 'FTOPAYRPR'                                       CSC022
     C                   Eval      DBKey  = 'CSC022'                                          CSC022
     C                   Eval      DBase  = 900                                               CSC022
     C                   Out       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      **                                                                                      CSC022
      ***Check*if*enhancement*CSC024*(Open*Month*End)*is*on                            CSC024 CSC054
      ** Check if enhancement CSC054 (Period End Adjustments) is on                           CSC054
                                                                                              CSC024
     C                   CALLB     'AOSARDR0'                                                 CSC024
     C                   PARM      *BLANKS       PRTCD                                        CSC024
     C                   PARM      '*VERIFY'     POPTN                                        CSC024
     C**********         PARM      'CSC024'      PSARD                                 CSC024 CSC054
     C                   PARM      'CSC054'      PSARD                                        CSC054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC024
                                                                                              CSC024
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSC024
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC024
     C**********         EVAL      DBKEY  = 'CSC024'                                   CSC024 CSC054
     C                   EVAL      DBKEY  = 'CSC054'                                          CSC054
     C                   EVAL      DBASE  = 85                                                CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C                   IF        PRTCD = *BLANKS                                            CSC024
     C**********         MOVEL     'Y'           CSC024            1                   CSC024 CSC054
     C                   MOVEL     'Y'           CSC054            1                          CSC054
                                                                                              CSC024
      ** Access System values                                                                 CSC024
                                                                                              CSC024
     C                   CALL      'AOSVALR0'                                                 CSC024
     C                   PARM      *BLANKS       PRetCode          7                          CSC024
     C**********         PARM      SysValOME     P@OP01           20                   CSC024 CSC054
     C                   PARM      SysValPEA     P@OP01           20                          CSC054
     C                   PARM      *BLANKS       P@VL01          200                          CSC024
     C                   PARM      *BLANKS       P@OP02           20                          CSC024
     C                   PARM      *BLANKS       P@VL02          200                          CSC024
     C                   PARM      *BLANKS       P@OP03           20                          CSC024
     C                   PARM      *BLANKS       P@VL03          200                          CSC024
     C                   PARM      *BLANKS       P@OP04           20                          CSC024
     C                   PARM      *BLANKS       P@VL04          200                          CSC024
     C                   PARM      *BLANKS       P@OP05           20                          CSC024
     C                   PARM      *BLANKS       P@VL05          200                          CSC024
     C                   PARM      *BLANKS       P@OP06           20                          CSC024
     C                   PARM      *BLANKS       P@VL06          200                          CSC024
     C                   PARM      *BLANKS       P@OP07           20                          CSC024
     C                   PARM      *BLANKS       P@VL07          200                          CSC024
     C                   PARM      *BLANKS       P@OP08           20                          CSC024
     C                   PARM      *BLANKS       P@VL08          200                          CSC024
     C                   PARM      *BLANKS       P@OP09           20                          CSC024
     C                   PARM      *BLANKS       P@VL09          200                          CSC024
     C                   PARM      *BLANKS       P@OP10           20                          CSC024
     C                   PARM      *BLANKS       P@VL10          200                          CSC024
                                                                                              CSC024
     C                   IF        PRetCode  <> *BLANKS                                       CSC024
     C                   EVAL      DBPGM = 'FTIPAYSIN'                                        CSC024
     C                   EVAL      DBFILE = 'SDSVALPD'                                        CSC024
     C                   EVAL      DBKEy = '*KEY   '                                          CSC024
     C                   EVAL      DBase = 86                                                 CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ELSE                                                                 CSC024
     C                   IF        P@VL01 = 'Y'                                               CSC024
     C                   MOVEL     'N'           GENPREF           1                          CSC024
     C                   ELSE                                                                 CSC024
     C                   EVAL      GENPREF = 'Y'                                              CSC024
     C                   ENDIF                                                                CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C                   ELSE                                                                 CSC024
     C**********         EVAL      CSC024 = 'N'                                        CSC024 CSC054
     C                   EVAL      CSC054 = 'N'                                               CSC054
     C                   EVAL      GENPREF = 'Y'                                              CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C/COPY WNCPYSRC,FTH00211
 
      * Calculate Run Date
     C                   CALLB     'ZDATE2'
     C**********         Parm      BJRDNB        ZDAYNO                                       CSC011
     C                   PARM                    ZDAYNO                                       CSC011
     C                   Parm                    BJDFIN
     C                   Parm      0             ZDATE
     C                   Parm      *Blanks       ZADATE
 
     C                   Eval      @RUNN = ZDATE
 
      * Calculate Back Value Date
      ** Use processing date defined in SC24X7 dataarea when support system is                CSC011
      ** active.                                                                              CSC011
                                                                                              CSC011
     C                   IF        (@CSC011 = 'Y') AND (LIBR = S1SUPP)                        CSC011
     C                   EVAL      @BVLD = WPRDTE - BJBVPD                                    CSC011
     C                   ELSE                                                                 CSC011
     C                   Eval      @BVLD = BJRDNB - BJBVPD
     C                   ENDIF                                                                CSC011
 
      * Set up User id
     C                   Eval      PSUSER = WUSRID                                            CAP084
     C                   Eval      @USRID = PSUSER
 
      *                                                                         CAP011
      ** Access API ICD Details                                                 CAP011
      *                                                                         CAP011
     C                   CALLB     'AOAPIR0'                                    CAP011
     C                   PARM      *BLANKS       @RTCD                          CAP011
     C                   PARM      '*FIRST '     @OPTN                          CAP011
     C     SDAPI         PARM      SDAPI         DSFDY                          CAP011
      *                                                                         CAP011
      * DATABASE ERROR                                                          CAP011
      *                                                                         CAP011
     C     @RTCD         IFNE      *BLANKS                                      CAP011
     C                   MOVEL     'SDAPIPD '    DBFILE                         CAP011
     C                   MOVEL     '903'         DBASE                          CAP011
     C                   MOVEL     @OPTN         DBKEY                          CAP011
     C                   EXSR      *PSSR                                        CAP011
     C                   END                                                    CAP011
      *                                                                                       CFT151
      * Access SAR details file to see if CFT151 is installed.                                CFT151
      *                                                                                       CFT151
     C                   CALLB     'AOSARDR0'                                                 CFT151
     C                   PARM      *BLANKS       @RTCD                                        CFT151
     C                   PARM      '*VERIFY'     @OPTN                                        CFT151
     C                   PARM      'CFT151'      @SARD                                        CFT151
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT151
                                                                                              CFT151
     C                   IF        @RTCD = *BLANKS                                            CFT151
     C                   MOVEL     'Y'           CFT151            1                          CFT151
     C                   ELSE                                                                 CFT151
     C                   MOVEL     'N'           CFT151                                       CFT151
     C                   ENDIF                                                                CFT151
      *                                                                                       CSW209
      ** Check if CSW209 is switched on                                                       CSW209
      *                                                                                       CSW209
     C                   CALLB     'SWIF2009'                                                 CSW209
     C                   PARM      *BLANKS       @RTCD                                        CSW209
      *                                                                                       CSW209
     C                   IF        @RTCD = 'CSW2009'                                          CSW209
     C                   MOVEL     'Y'           CSW209            1                          CSW209
     C                   ELSE                                                                 CSW209
     C                   MOVEL     'N'           CSW209                                       CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CER030
      ** CER030 - Multicash German Feature                                                    CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtcd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER030'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
      ** An NRF (No Record Found) return code is valid.                                       CER030
      ** Issue database error only for error return codes.                                    CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> *BLANKS AND                                       CER030
     C                             PRtcd <> '*NRF   '                                         CER030
     C                   EVAL      DBKEY = 'CER030'                                           CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   Z-ADD     905           DBASE                                        CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CER030 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CER030 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** CER031 - Multicash German Feature                                                    CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtcd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER031'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
      ** An NRF (No Record Found) return code is valid.                                       CER030
      ** Issue database error only for error return codes.                                    CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> *BLANKS AND                                       CER030
     C                             PRtcd <> '*NRF   '                                         CER030
     C                   EVAL      DBKEY = 'CER031'                                           CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   Z-ADD     906           DBASE                                        CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CER031 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CER031 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** CGL013 - SWIFT Feature                                                               CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtcd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CGL013'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
      ** An NRF (No Record Found) return code is valid.                                       CER030
      ** Issue database error only for error return codes.                                    CER030
      *                                                                                       CER030
     C                   IF        PRtcd <> *BLANKS AND                                       CER030
     C                             PRtcd <> '*NRF   '                                         CER030
     C                   EVAL      DBKEY = 'CGL013'                                           CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   Z-ADD     907           DBASE                                        CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtcd = *BLANKS                                            CER030
     C                   EVAL      CGL013 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CGL013 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *
      * GO TO INITIAL SCREEN
      *
     C                   EXSR      INITIAL
      *
      *  Data areas for Payment reference numbering.
     C     *DTAARA       DEFINE    OTPAYDA       OTPAYD
     C     *DTAARA       DEFINE    RGPAYDA       RGPAYD
 
      * Override file 'OTPAY' in UPD module to 'OTPAYOVR'
     C                   CALL      'QCMDEXC'
     C                   PARM                    OVERRIDE
     C                   PARM      47            OvrLen           15 5
                                                                                CFT014
      ** Override file 'OTPAYXL0' in UPD module with SHARE(*NO)                 CFT014
                                                                                CFT014
     C                   CALL      'QCMDEXC'                                    CFT014
     C                   PARM                    OVROPXL0                       CFT014
     C                   PARM      49            OvrLen1          15 5          CFT014
 
      ***Override*file*'FTPREFL0'*in*UPD*module*with*SHARE(*NO)********             BUG4776 BUG4776R
      **********                                                                    BUG4776 BUG4776R
     C**********         CALL      'QCMDEXC'                                        BUG4776 BUG4776R
     C**********         PARM                    OVRFTPRF                           BUG4776 BUG4776R
     C**********         PARM      49            OvrLen1          15 5              BUG4776 BUG4776R
      **********                                                                    BUG4776 BUG4776R
      * Set level 1/2 flag to '1'
     C                   MOVE      '1'           @Level            1
 
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
 
      ***Get*the*field*number*for*the*transfer*commission*tarif*field,*         CFT014
      ***the*secondary*************************************************         CFT014
      ** Get the field number for the bank operation code field the 2nd         CFT014
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
      ***Get*the*field*number*for*the*Intermediary*Bank*(1)*field,*the*third*   CFT014
      ***screen*fields*start*from*that*number.**Subtract*one*from*it*to******   CFT014
      ** give the value to subtract from each field's number.
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM                    ReturnCode
     C                   PARM                    Format
     C                   PARM                    FieldT
     C                   PARM                    FieldNo
 
     C                   IF        ReturnCode = *blank
     C                   EVAL      FldOffsetT = FieldNo - 1
     C                   ENDIF
                                                                                CFT014
      ** Get the field number for the Charges to the debit of field, 4th        CFT014
      ** screen fields start from that number.  Subtract one from it to         CFT014
      ** give the value to subtract from each field's number.                   CFT014
                                                                                CFT014
     C                   CallB     'ZACGTFLDNO'                                 CFT014
     C                   Parm                    ReturnCode                     CFT014
     C                   Parm                    Format                         CFT014
     C                   Parm                    Field4                         CFT014
     C                   Parm                    FieldNo                        CFT014
                                                                                CFT014
     C                   If        ReturnCode = *blank                          CFT014
     C                   Eval      FldOffset4 = FieldNo - 1                     CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Get the field number for the FX Margin Points field, the 5th           CFT014
      ** screen fields start from that number.  Subtract one from it to         CFT014
      ** give the value to subtract from each field's number.                   CFT014
                                                                                CFT014
     C                   CallB     'ZACGTFLDNO'                                 CFT014
     C                   Parm                    ReturnCode                     CFT014
     C                   Parm                    Format                         CFT014
     C                   Parm                    Field5                         CFT014
     C                   Parm                    FieldNo                        CFT014
                                                                                CFT014
     C                   If        ReturnCode = *blank                          CFT014
     C                   Eval      FldOffset5 = FieldNo - 1                     CFT014
     C                   EndIf                                                  CFT014
      *
      ** Call SWIF2003 to check if CSW203 is installed                                        CSW203
                                                                                              CSW203
     C                   CALL      'SWIF2003'                                                 CSW203
     C                   PARM      *BLANKS       PRTCD                                        CSW203
                                                                                              CSW203
      ** If ret. code is "CSW203", set CSW203 flag to "Y", else set it to "N"                 CSW203
                                                                                              CSW203
     C                   IF        PRTCD = 'CSW2003'                                          CSW203
     C                   EVAL      CSW203 = 'Y'                                               CSW203
     C                   ELSE                                                                 CSW203
     C                   EVAL      CSW203 = 'N'                                               CSW203
     C                   ENDIF                                                                CSW203
      *
      * Start on Browse Screen
      *
     C                   MOVEL     'I'           @SCRN             1
      *
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FTOPAYB012
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX043'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *Blanks AND                                       CER001
     C                             @RTCD <> '*NRF   '                                         CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
     C                   MOVEL     '100'         DBASE                                        CER001
     C                   MOVEL     'ULX043'      DBKEY                                        CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *Blanks                                            CER001
     C                   MOVEL     'Y'           ULX043                                       CER001
      *                                                                                       CER001
      ** Do not process lux extension details when IBLC Returns indicator is                  CER001
      ** not set to 'Y'                                                                       CER001
      *                                                                                       CER001
     C                   IF         BGNWST <> 'Y'                                             CER001
     C                   EVAL       ULX043 = 'N'                                              CER001
     C                   ELSE                                                                 CER001
     C                   OPEN      FTIOPLX1L0                                                 CER001
     C                   OPEN      FTOPX1L0                                                   CER001
     C                   ENDIF                                                                CER001
     C                   ELSE                                                                 CER001
     C                   MOVEL     'N'           ULX043                                       CER001
     C                   ENDIF                                                                CER001
 
     C                   MOVE      Val@Fields    Wval           1467                          207329
     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY WNCPYSRC,FTOPAYRC27
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
