     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing payments screen input - level 2')    *
      *****************************************************************
      *                                                               *
      *  Midas - API Funds Transfer Module                            *
      *                                                               *
      *  FTOPAY2SN  - Outgoing Payments screen input - Level 2        *
      *                                                               *
      *  Function: This is the main screen input function             *
      *            for Funds Transfer Outgoing Payments level 2 input *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT050             Date 03Jun13               *
      *  Prev Amend No. 258944             Date 23Jan13               *
      *                 CFT148             Date 23Jan13               *
      *                 CFT120             Date 28Sep12               *
      *                 CAP211             Date 28Sep12               *
      *                 CFT039             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24803           Date 09Jul09               *
      *                 257361             Date 10Nov08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 250600             Date 07Oct07               *
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 222472             Date 06Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 BUG7029            Date 09Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4776R (Reopen)  Date 15Nov04               *
      *                 BUG4776            Date 15Nov04               *
      *                 CFT118             Date 01Sep04               *
      *                 CFT116             Date 12Jul04               *
      *                 CGL014             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 30Oct03               *
      *                 CGP001             Date 16Oct03               *
      *                 CAP084             Date 01Aug03               *
      *                 CSW203             Date 26May03               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 209867             Date 10Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 204029             Date 26Apr02               *
      *                 204067             Date 26Mar02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 195220             Date 21Jan02               *
      *                 193883             Date 20Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 01Mar01               *
      *                 190845             Date 21Mar01               *
      *                 CPB002             Date 13Sep00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 187056             Date 01Dec00               *
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 183140             Date 23Aug00               *
      *                 182962             Date 23Aug00               *
      *                 175479             Date 06Jun00               *
      *                 CFT007             Date 03Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 22Nov99               *
      *                 CPB001             Date 23Aug99               *
      *                 CAP031  *CREATE    Date  2Jul99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT050 - SWIFTRef Directories upload                         *
      *  258944 - APISERVER API FTOPAY: correct positions; fix use of *
      *           APNARV in CFT148 which adds one to positions        *
      *           Amended hook: CFT148_017 (Recompile)                *
      *  CFT148 - FT Remove Validation on Field 50F                   *
      *           Added hooks: CFT148_017, CFT148_018, CFT148_019     *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CAP211 - FT IN_OP APIs - Auto-Authorization of Payment       *
      *  CFT039 - SWIFT Mapping of Field Ordering Bank                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  BUG24803 - Payment Reference tag becomes                     *
      *  257361 - Pass SDFTFR to FTOPAV1VL in case Warning message    *
      *           ('Network TELEX must be defined in Standing data')  *
      *           which appears for Settlement type '02' (cheques)    *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate.                *
      *  250600 - Recompiled for change in FTV@OPAYPD                 *
      *           to fix CFT032/CSW207 errors                         *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  222472 - Charges should be redefaulted only if fields        *
      *           influencing their calculation are amended, not      *
      *           simply if any field is amended.                     *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4776R-Reverse fix since fix only applies to Incoming.     *
      *           (Reopen)                                            *
      *  BUG4776- Correct skipping of transaction reference.          *
      *  CFT118 - Core changes for GBO018.                            *
      *           Demand Drafts Printing - Upgrade to MidasPlus       *
      *           Core hooks amended:FTOPAYS010                       *
      *                              FTOPA2SC15                       *
      *  CFT116 - Core changes for GBO016                             *
      *         - MT110 Generation in Funds Transfer                  *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:FTOPA2SC09,FTOPAYS010            *
      *           Core hooks added:FTOPA2SC15,FTOPA2SC16              *
      *  CGL014 - Collaterals Processing                              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Correct parameters on program calls                 *
      *  CGP001 - Global Processing.                                  *
      *         - Recompile due to change in FTVOPY2PD.               *
      *  CAP084 - MidasPlus Changes                                   *
      *  CSW203 - SWIFT 2003 Standards Update                         *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  209867 - No rollback when F3 pressed. Msg ENDCMTCTL not      *
      *           allowed at signoff due to updates in window pgm.    *
      *  204029 - Data decimal error on fields MISC01,2,3,4,5         *
      *           and SWSCHG when CFT009 is not on (RECOMPILE).       *
      *  204067 - Insert gives record updated by another wrkstn when  *
      *           level joiner on ICD is N.                           *
      *  CSC011 - 24x7 Midas Availability                             *
      *  195220 - Restore unexpanded data on F12.                     *
      *  193883 - Recompile over changed FTOPAYUPD.                   *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  190845 - Add extra fields for Message Unique Reference and   *
      *           Part Number                                         *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *  187056 - IP and OP do not recalculate screen charges if      *
      *           'Charges to the Debit of a/c' has been changed      *
      *           from blank to non-blank.                            *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  183140 - 'Record updated by another user' prompted wrongly   *
      *  182962 - Program name changed to WN0010                      *
      *  175479 - Recompile over changes in outgoing payment file     *
      *  CFT007 - BIC Database Plus Integration                       *
      *  CFT004 - IBAN, International Bank Account Number             *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *              CFT007 BIC Database Plus Integration             *
      *         ///////////////////////////////////////////////////// *
      *        // NOTE: If the receiver's correspondent,          //  *
      *       // ordering customer, beneficiary or intermediary  //   *
      *      // bank fields change position, the cursor         //    *
      *     // position tests in SR BICPrompt will need        //     *
      *    // to be changed.                                  //      *
      *   /////////////////////////////////////////////////////       *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     F/COPY WNCPYSRC,FTOPA2SF01
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** Commitment Control Job Array                                                         CSC022
     D WJobs           S             10A   Dim(10)                                            CSC022
      **                                                                                      CSC022
 
     D CrPtFilFmt    E DS                  EXTNAME(OTPAYDD)
      * Current Payment in File Format
                                                                                CFT014
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
     D CurPmtScnA    E DS                  EXTNAME(FTOPYAPD)                                BUG24803
     D                                     PREFIX(@)                                        BUG24803
      ** (Current) Payment in Screen 1 Format (Cover Message)                               BUG24803
     D CurPmtScnC    E DS                  EXTNAME(FTOPYCPD)                                BUG24803
     D                                     PREFIX(@)                                        BUG24803
      ** (Current) Payment in Screen 2 Format (Cover Message)                               BUG24803
 
 
     D NwPtFilFmt    E DS                  EXTNAME(FTVOPAYPD)
      * New Payment in File Format
                                                                                CFT014
     D NwPtFilFmx    E DS                  EXTNAME(FTVOPY2PD)                   CFT014
      ** New Payment in File Format (Extension)                                 CFT014
 
 
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
     D NewPmtScnA    E DS                  EXTNAME(FTOPYAPD)                                BUG24803
      ** New Payment in Screen 1 Format (Cover Messages)                                    BUG24803
     D NewPmtScnC    E DS                  EXTNAME(FTOPYCPD)                                BUG24803
      ** New Payment in Screen 2 Format (Cover Messages)                                    BUG24803
 
 
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
 
     D OTPAYD        E DS                  EXTNAME(OTPAYDA)
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
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
      * External DS for Funds Transfer details
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
     D  WRATDIS               44     48  4
 
      * External data structure for currency codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
                                                                                CFT007
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)                    CFT007
      * External data structure for trading ICD data                            CFT007
 
     D SDFODA        E DS                  EXTNAME(SDFODAPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
      ** EXTERNAL DS FOR FUNDS TRANSFER ICD DETAILS
                                                                                CFT014
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)                    CFT014
     D  QQACC2       E                     EXTFLD(QQACCD)                                     CGL029
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
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D ExtData       E DS                  EXTNAME(FTOPEXPD)
      * FT (OPAY) Extra Data - File (D/B) format
     D/COPY OFCPYSRCZ,CFT148_017                                                              CFT148
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 Status DataArea Layout                                                          CSC011
     D  WPRDTE                 5      9  0                                                    CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD Status DataArea Layout                                                            CSC011
      ** SCCMTJOB DataArea Layout                                                             CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WDSJobs                4    103A                                                      CSC022
      **                                                                                      CSC022
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
 
     D @CCI@M          DS
      ** CURRENT CONTROL INDICATORS FOR MAIN DETAIL SCREEN
     D  @EKYFD                 1      1
     D  @EDTFD                 2      2
 
     D @PCI@M          DS             2
      ** PREVIOUS CONTROL INDICATORS FOR MAIN DETAIL SCREEN
 
      *  User / Branch data area
     D ZMUSER          DS            17
     D  WDFBR                 11     13
     D  WDPPT                 14     16
 
      * Data structure to retrieve multi branch indicator
     DRUNDAT           DS
     D WMBIN                  13     13
 
     D                 DS
     D*     REDEFINE IPREF FOR INSERTS
     D  IPREF                  1     15
     D  P                      1      1    INZ('P')
     D  RUNDYY                 2      3  0
     D  RUNDMD                 4      7  0
     D  PRNUM                  8     11  0
     D  PmntType              12     13
     D  StmtType              14     15  0
     D*
      *                                                                                       187056
      ** Calling parameter DS for FT0035                                                      187056
     D P0DTA           DS           256                                                       187056
     D  WIPT1                  1      1                                                       187056
     D  WIPTY1                 2     36                                                       187056
     D  WIPT2                 37     37                                                       187056
     D  WIPTY2                38     72                                                       187056
     D  WICCY                 73     75                                                       187056
     D  WOCUST                76     81                                                       187056
 
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
     D/COPY QWINDSRC,FTOPAYSDTA
      *                                                                                       CER001
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
 
      * Output Data Structure for BIC reformatted address                       CFT007
     D @OAddress       DS           175                                         CFT007
     D  OAddress1              1     35                                         CFT007
     D  OAddress2             36     70                                         CFT007
     D  OAddress3             71    105                                         CFT007
     D  OAddress4            106    140                                         CFT007
     D  OAddress5            141    175                                         CFT007
                                                                                CFT007
      * Data Structure for BIC address input flags                              CFT007
     D*BicLines**      DS             8                                         CFT007 CFT014
     D BicLines        DS            10                                         CFT014
     D  Line1RCor              1      1                                         CFT007
     D  Line2RCor              2      2                                         CFT007
     D  Line1ABnk              3      3                                         CFT007
     D  Line2ABnk              4      4                                         CFT007
     D  Line1Benf              5      5                                         CFT007
     D  Line2Benf              6      6                                         CFT007
     D  Line1IBnk              7      7                                         CFT007
     D  Line2IBnk              8      8                                         CFT007
     D  Line1TRIn              9      9                                         CFT014
     D  Line2TRIn             10     10                                         CFT014
                                                                                CFT007
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
 
     D WkBlankfld      S             35    INZ(*Blanks)                         CFT007
     D WkCHIPCode      S             14    INZ(*Blanks)                         CFT007
                                                                                CFT007
      * Msg Unique Reference                                                                  190845
     D SHMSGR          S              8  0                                                    190845
     D                                                                                        190845
      * Part Number                                                                           190845
     D SHPART          S              3  0                                                    190845
      *                                                                                       190845
      ** Access Object parameter fields                                                       CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
      *                                                                                     BUG24803
     D CSW209          S              1A                                                    BUG24803
                                                                                            BUG24803
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
     D CER030          S              1A                                                      CER030
     D CER031          S              1A                                                      CER030
     D CGL013          S              1A                                                      CER030
      **                                                                                      CSC022
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FTOPAYS010
     D STMESTMP        S             26Z                                                      CER001
     D SFOTRANID       S             20                                                       CER001
     D ULX043          S              1A   INZ('N')                                           CER001
     D ACTION          S              1A                                                      CER001
     D #RTRN           S              7A                                                      CER001
 
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
      ** Retrieve ZMUSER details.                                                            BUG7029
      *                                                                                      BUG7029
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C                   IN        ZMUSER                                                    BUG7029
     C                   UNLOCK    ZMUSER                                                    BUG7029
      *                                                                                      BUG7029
      /COPY WNCPYSRC,FTOPAYS001
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
      /COPY WNCPYSRC,FTOPAYS002
      *
      ** Read next browse subfile record
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTOPAYS003
      *
      /COPY WNCPYSRC,FTOPAYS004
      *
      ** DO WHILE screen: Level 2 Details Screen
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
     C                   If        (NewPmtSc2a <> PrvPmtSc2a) Or                CFT014
     C                             (NewPmtSc2b <> PrvPmtSc2b) Or                CFT014
     C                             (NewPmtScn3 <> PrvPmtScn3) Or                CFT014
     C                             (NewPmtSc3b <> PrvPmtSc3b)                   CFT014
                                                                                222472
      ** Charges should only be defaulted if transfer commission tarif          222472
      ** amended.                                                               222472
                                                                                222472
     C                   If        (STRCT <> @PSTRCT)                           222472
     C                   ExSr      DFT@O                                        CFT014
     C                   EndIf                                                  222472
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
     C                   ENDIF                                                  CFT009
                                                                                CFT014
                                                                                CFT014
      *
      /COPY WNCPYSRC,FTOPAYS005
      *
      ** DO WHILE screen: Charges & Commissions Screen
      *
     C                   Z-ADD     *ZERO         WIdx_OVAL         3 0
     C***********        MOVE      *Blanks       @INB1                          CFT014
     C***********        MOVE      *Blanks       @INB2                          CFT014
     C     @SCRN         DOWEQ     'O'
     C                   EXSR      Scrn@O
     C/COPY WNCPYSRC,FTOPA2SC04
     C                   ENDDO
                                                                                CFT014
      ** Margin Information                                                     CFT014
                                                                                CFT014
     C     @SCRN         DowEq     'M'                                          CFT014
     C                   ExSr      Scrn@M                                       CFT014
     C                   Enddo                                                  CFT014
      *
      /COPY WNCPYSRC,FTOPAYS006
      *
      * SCREEN: WINDOW
     C                   Z-ADD     *ZERO         WIdx_WVAL         3 0
     C     @SCRN         IFEQ      'W'
     C                   EXSR      WINDOW
     C                   END
 
      /COPY WNCPYSRC,FTOPAYS008
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
      /COPY WNCPYSRC,FTOPAYS009
      *
      ** Terminate program
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
      *****************************************************************
 
      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FTOPAYS011
     C     WINDOWI       BEGSR                                                                CER001
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
     C                   CALLB     'FTOPAY3SN'                                                CER001
     C                   PARM      SACTION       ACTION                                       CER001
     C                   PARM                    PDATA                                        CER001
     C                   PARM      *BLANKS       #RTRN                                        CER001
      *                                                                                       CER001
      ** Process returned command keys                                                        CER001
      *                                                                                       CER001
     C     #RTRN         IFEQ      'Y2U9999'                                                  CER001
     C                   COMMIT                                                               CER001
     C                   EXSR      ENDP                                                       CER001
      *                                                                                       CER001
      ** Otherwise, go to next screen after UPDATS routine                                    CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     WINDI         ENDSR                                                                CER001
 
      /EJECT
      *****************************************************************
      * SCRN@S - PROCESS SCREEN: LEVEL 2 DETAILS
      *****************************************************************
     C     SCRN@S        BEGSR
 
      * Update 'previous' screen
 
     C                   MOVEL     NewPmtScn1    PrvPmtScn1
     C                   MOVEL     NewPmtSc1b    PrvPmtSc1b                     CFT014
     C                   MOVEL     NewPmtSc2a    PrvPmtSc2a
     C                   MOVEL     NewPmtSc2b    PrvPmtSc2b
     C                   Z-ADD     WIdx_SVAL     PrvN_Warn         3 0
     C                   MOVEL     @CCI@M        @PCI@M
      *
      * If not called from linked enquiry enable CMDs 7,8 & 15.
     C     LinkedEnq     IFEQ      *BLANK
     C                   MOVE      'Y'           @EINKG
     C                   MOVE      'Y'           @EINKH
     C                   MOVE      'Y'           @EINKP
     C                   END
      *
      ** WRITE/READ DISPLAY SCREEN - Level 2 Details
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
     C                   PARM                    DDSTAT           24
      *
      * Fields in error
     C                   PARM                    FTEOPY1
     C                   PARM                    FTEOPY2
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
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      * ENABLED FUNCTION KEYS
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KP = COMMAND KEY 15 = BROWSE
      * KQ = COMMAND KEY 16 = UPDATE FILE WITH LEVEL ONE DETAILS
      * KS = COMMAND KEY 18 = READ NEXT (from linked enquiry)
     C                   PARM                    @EINKD            1            CFT007
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKP            1
     C                   PARM                    @EINKQ            1            CFT007
     C                   PARM                    @EINKS            1
      * Successful insert Payment
     C                   PARM                    @SITR            15
      *
      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKD             1             CFT007
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKQ             1            CFT007
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
      * F7 - Roll Backwards
     C     @INKG         CASEQ     '1'           ROLL
      *
      * F8 - Roll Forwards
     C     @INKH         CASEQ     '1'           ROLL
      *
      * F12 - Cancel on Level 2 Screen
     C     @INKL         CASEQ     '1'           CANC@S
      *
      * F15 - Build Browse
     C     @INKP         CASEQ     '1'           BLDBRW
      *                                                                         CFT007
      * F16 - BIC in-line search                                                CFT007
     C     @INKQ         CASEQ     '1'           BICPrompt                      CFT007
      *
      * F18 - Read next linked enquiry subfile record
     C     @INKS         CASEQ     '1'           CANC@S
      *
      * Validate input to Level 2 screen
     C                   CAS                     VAL@S
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@S  - VALIDATE INPUT TO LEVEL 2 DETAILS SCREEN
      *****************************************************************
     C     VAL@S         BEGSR
      *
      * Retrieve Payment details
      *
     C                   EXSR      RTVPMT
      *
      * If primary fields are NOT OK
      * Re-output screen with error messages on it
      *
     C     OKACTION      IFEQ      'N'
     C     OKPREF        OREQ      'N'
     C                   GOTO      EndVAL@S
     C                   END
      *
      * Set field status on LEVEL 2 screen
      * (according to action code)
      *
     C                   EXSR      SFDS@P
      *
      * If action code is enquire
      * or payment ref has changed
      *   Put the transaction on the main details screen
      *
     C     SACTION       IFEQ      'E'
     C     SPREF         ORNE      @PSPREF
     C                   EXSR      CVTPMT
     C                   MOVEL     CrPtFilFmt    NwPtFilFmt
     C                   MOVEL     CrPtFilFmX    NwPtFilFmX                     CFT014
     C                   END
      *
      * If payment ref or screen control indicators have changed
      *   Re-output screen
      *
     C     SPREF         IFNE      @PSPREF
     C     SACTION       ANDNE     'I'
     C     @CCI@M        ORNE      @PCI@M
     C     SACTION       ANDNE     'I'
     C                   GOTO      EndVAL@S
     C                   END
      *
      * Prior to validation, initialize error indicators as 'OK'
      * clear Payment in File Format.
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx_SVAL         3 0
     C                   MOVE      *ALL'Y'       FTEOPY1
     C                   MOVE      *ALL'Y'       FTEOPY2
     C     SACTION       IFEQ      'I'                                                        183140
     C                   CLEAR                   NwPtFilFmt
     C                   CLEAR                   NwPtFilFmX                     CFT014
     C                   ENDIF                                                                183140
      *
      *----------------------------------------------------------------
      * IF ENQUIRE
      *
     C     SACTION       IFEQ      'E'
      *
      * If windows processing on, call window routine
      * IF BROWSE OUTSTANDING, READ NEXT BROWSE SUBFILE RECORD
      * Else go to Other details screen
      *
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
     C***********        MOVEL     'O'           @SCRN                          CFT014
     C                   MOVEL     'B'           @SCRN                          CFT014
     C                   END
     C                   END
      *
     C                   GOTO      EndVAL@S
     C                   END
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND
      *
     C     SACTION       IFEQ      'I'
     C     SACTION       OREQ      'A'
 
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx
     C                   MOVE      *ALL'Y'       FTEOPY1
     C                   MOVE      *ALL'Y'       FTEOPY2
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
     C/COPY OFCPYSRCZ,CFT148_018                                                              CFT148
      *
      * Call primary screen validation in order to set up fields
      * on FTWOPAYPD
 
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
     C                   PARM      FRNT          FrontOffice      20            CPB002
     C                   PARM                    NEWPMTSCN4                     CFT009
     C                   PARM                    TranInfoFlds                                 CFT039
      * Custom Extra Data file data
     C                   PARM                    ExtData
 
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
     C                   PARM                    WIdx
      * Valid Payment layout (DS) from/to caller
     C                   PARM                    NwPtFilFmt
     C                   PARM                    NwPtFilFmX                     CFT014
      *  Validation Work Fields from/to caller
     C                   PARM                    Val@Fields
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
     C/COPY WNCPYSRC,FTOPA2SC15
                                                                                CFT014
      ** Find out if there is a MT103 bilateral agreement exists between        CFT014
      ** the booking branch and the receiver only when CFT014 is setup.         CFT014
                                                                                CFT014
     C                   If        @CFT014 = 'Y'                                CFT014
     C                   Eval      @MT103 = *Blank                              CFT014
     C                   ExSr      SrBMT103                                     CFT014
     C                   EndIf                                                  CFT014
 
      * Validate Level 2 Payment details
      *
     C                   CALLB     'FTOPAY2VL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
 
      * Response mode
     C                   PARM                    RespMode
 
      ** Payment Primary Details
     C                   PARM                    NewPmtScn1
     C                   PARM                    NewPmtSc2a
     C                   PARM                    NewPmtSc2b
     C                   PARM                    NewPmtSc1b                     CFT014
     C                   PARM                    NewPmtScn3                     CFT014
      * Custom Extra Data file data
     C                   PARM                    ExtData
 
      * OUTPUTS :
 
      ** Payment Level 2 Details OK inds
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
      ***Saved*default*charges***************************************                  CFT009 222373
     C*****              PARM                    DEFVALID                              CFT009 222373
     C*****              PARM                    DEFVALIDX                             CFT009 222373
 
      *
      * If errors returned
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@S
     C                   END
      *
      * if there are warnings which have not been displayed
      * re-output the screen
 
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
      * If windows processing on, call window routine, otherwise
      **Go*to*Charges*&*Commissions*screen*****************************         CFT014
      *
      ** Goto 2nd screen level 2                                                CFT014
                                                                                CFT014
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C***********        MOVEL     'O'           @SCRN                          CFT014
     C                   MOVEL     'B'           @SCRN                          CFT014
     C                   END
      *
     C                   END
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
      ** @MT103 to 'Y'.                                                                       CSW203
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
      * SR/SCRN@B     - Process Second Screen Level 2                 *         CFT014
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
      ** If enquire                                                             CFT014
                                                                                CFT014
     C     SACTION       IfEq      'E'                                          CFT014
                                                                                CFT014
      ** Go to Other details screen                                             CFT014
                                                                                CFT014
     C                   Movel     'O'           @SCRN                          CFT014
                                                                                CFT014
     C                   Goto      EndVAL@B                                     CFT014
     C                   EndIf                                                  CFT014
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
     C                   Movel     'O'           @SCRN                          CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C     EndVAL@B      EndSr                                                  CFT014
                                                                                CFT014
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
      *                                                                                       CER030
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
      ** KT = Command key 19                                                    CFT014
                                                                                CFT014
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
      *                                                                         CFT007
      * Cursor location on screen                                               CFT007
     C                   PARM      0             CursorLoc                      CFT007
      *
      *  Validation Work Fields from/to caller
     C                   PARM                    Val@Fields
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG          1            CFT009
 
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
      * IF ENQUIRE
      *
     C     SACTION       IFEQ      'E'
     C/COPY WNCPYSRC,FTOPA2SC02
     C                   IF        ULX043 = 'Y'                                               CER001
     C                             AND SACTION <> 'D'                                         CER001
      *                                                                                       CER001
      ** New Window processing, if F12 or F3                                                  CER001
      ** Create a Blank Record without details using call to FT0045XL                         CER001
      ** during Close of Business (No ext. details in this case)                              CER001
      *                                                                                       CER001
     C                   EXSR      WINDOWI                                                    CER001
     C                   ENDIF                                                                CER001
      *
      *     If Browse outstanding, read next Browse Subfile record
      *     Else, Go To Initial screen
      *
      *
   ??C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
      *
      * Else, if called from linked enquiry go back to calling program.
     C                   ELSE
     C     LinkedEnq     IFNE      *BLANKS
     C                   EXSR      CANC@S
 
      *     Else, Go To Initial screen
     C                   ELSE
     C                   EXSR      INITIAL
     C                   END
     C                   END
      *
     C                   GOTO      EndVAL@O
     C                   END
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
     C                   Z-ADD     *ZERO         WIdx_OVAL
     C***********        MOVE      *ALL'Y'       FTEOPY3                        CFT014
     C                   MOVE      *ALL'Y'       FTEOPY4                        CFT014
      *                                                                                       187056
      ** Check if charges needs to be recalculated.                                           187056
      *                                                                                       187056
     C                   IF        @CFT009 = 'N'                                CFT009
     C                   EXSR      SRReCalc                                                   187056
     C                   ENDIF                                                  CFT009
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
      *                                                                         CFT009
      ** Redisplay screen flag                                                  CFT009
     C                   PARM      'N'           WReDspChg                      CFT009
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
 
      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@O
     C                   END
      *
      * If there are warnings which have not been displayed
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
      ** or extended naaratives are in error display screen 5                                 CER030
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
      *                                                                                       CER030
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
     C                   ELSE                                                                 CER030
     C                   MOVEL     'C'           @SCRN                                        CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** No validation required                                                               CER030
      *                                                                                       CER030
     C                   ELSE                                                                 CER030
      *
      * Go To First screen for confirmation.
      *
     C                   MOVEL     'C'           @SCRN
     C/COPY WNCPYSRC,FTH00342
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *
     C                   END
      *----------------------------------------------------------------
      *
     C     EndVAL@O      ENDSR
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
      ** Update 'previous' screens and previous number of warnings              CFT014
                                                                                CFT014
     C                   Movel     NewPmtScn5    PrvPmtScn5                     CFT014
     C                   MOVEL     NewPmtScn5A   PrvPmtScn5A                                  CER030
     C                   MOVEL     NewPmtScn5B   PrvPmtScn5B                                  CER030
     C                   Z-Add     WIdx_MVAL     PrvN_Warn                      CFT014
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
      ** If enquire                                                             CFT014
                                                                                CFT014
     C     SACTION       IfEq      'E'                                          CFT014
                                                                                CFT014
      ** Go to Other details screen                                             CFT014
                                                                                CFT014
     C                   Movel     'O'           @SCRN                          CFT014
                                                                                CFT014
     C                   Goto      EndVAL@M                                     CFT014
     C                   EndIf                                                  CFT014
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
     C     NewPmtScn5A   ORNE      PrvPmtScn5A                                                CER030
     C     NewPmtScn5B   ORNE      PrvPmtScn5B                                                CER030
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
      * Reset errors
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
     C                   CALLB     'FTOPAY2DP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * Payment (IN SCREEN FORMAT - Primary / Secondary)
     C                   PARM                    NewPmtScn1
     C                   PARM                    NewPmtSc2a
     C                   PARM                    NewPmtSc2b
     C                   PARM                    NewPmtSc1b                     CFT014
      *
      * STATUS
     C                   PARM                    DDSTAT           24
      *
      * FIELDS IN ERROR
     C                   PARM                    FTEOPY1
     C                   PARM                    FTEOPY2
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
     C                   PARM                    @EINKD                         CFT007
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKP
     C                   PARM                    @EINKQ                         CFT007
     C                   PARM                    @EINKS
      *
      * SUCCESFUL INSERT TRANSACTION
     C                   PARM                    @SITR
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKD             1             CFT007
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKQ             1            CFT007
     C                   PARM      '0'           @INKS             1
     C                   PARM      'Y'           WriteOnly         1
     C                   PARM      0             CursorLoc         5 0          CFT007
      *
     C/COPY WNCPYSRC,FTOPAYSMV1
     C     ULX043        IFEQ      'Y'                                                        CER001
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
     C                   CALLB     'FTOPAY3SN'                                                CER001
     C                   PARM      SACTION       ACTION                                       CER001
     C                   PARM                    PDATA                                        CER001
     C                   PARM      *BLANKS       #RTRN                                        CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     #RTRN         IFNE      'Y2U9999'                                                  CER001
     C     #RTRN         ANDNE     'USR0790'                                                  CER001
     C     ULX043        OREQ      'N'                                                        CER001
      *
     C                   CALL      'WN0010'
     C*********          PARM      'FTOPAY1SN'   #PGM             10                          182962
     C                   PARM      'FTOPAY2SN'   #PGM             10                          182962
     C                   PARM                    FKEY              2
     C                   PARM      SACTION       ACTION            1
     C                   PARM                    DATA
     C                   PARM      *BLANKS       #RTRN             7
     C                   PARM                    SPAREW          256
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *
      * Process returned command keys
      *
     C     #RTRN         IFEQ      'Y2U9999'
     C                   EXSR      ENDP
     C                   ELSE
      *
      *  If Cmd12 pressed, return to level 2 screen;
      ***otherwise,*go*to*charges/commissions*screen*******************
      ** otherwise, go to 2nd screen level 2                                    CFT014
      *
     C     #RTRN         IFEQ      'USR0790'
     C     @RDNB         IFEQ      'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
     C                   EVAL      @SCRN = 'S'
     C                   END
     C                   ELSE
     C***********        EVAL      @SCRN = 'O'                                  CFT014
     C                   EVAL      @SCRN = 'B'                                  CFT014
     C                   ENDIF
     C                   ENDIF
      *
     C     WIND          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ROLL - ROLL BACKWARDS & FORWARDS THROUGH PaymentS FILE
      *****************************************************************
     C     ROLL          BEGSR
      *
      * Default action code to enquiry if not valid
      *
     C     SACTION       IFNE      'A'
     C     SACTION       ANDNE     'I'
     C                   MOVE      'E'           SACTION
     C                   END
      *
      * READ NEXT OR PREVIOUS RECORD ON PaymentS FILE
      * ACCORDING TO COMMAND KEY TAKEN (F7{=INKG} OR F8)
      *
     C     @INKG         IFEQ      '1'
     C                   MOVEL     *BLANK        @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     *BLANK        @RDBCK
     C                   END
      *
     C                   CALLB     'FTOPAYRED'
      *
      * INPUT PARAMETERS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Action Code
     C                   PARM                    SACTION
      *
      * Payment REF. POINTER
     C                   PARM                    SPREF            15
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * Error message
     C                   PARM      *BLANK        @ERRMS            7
      *
      * Payment REF. READ
     C                   PARM      *BLANK        @PRRED           15
      *
      * If error message returned from read, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@P
     C                   GOTO      EROLL
     C                   END
      *
      * If Payment read
      *
     C     @PRRED        IFNE      *BLANK
      *
      * Retrieve Payment details
      *
     C                   MOVEL     @PRRED        SPREF
     C                   EXSR      RTVPMT
      *
      * Convert Payment
     C                   EXSR      CVTPMT
     C                   MOVEL     CrPtFilFmt    NwPtFilFmt
     C                   MOVEL     CrPtFilFmX    NwPtFilFmX                     CFT014
      *
      * Set field status on SECONDARY screen
      * (according to action code)
      *
     C                   EXSR      SFDS@P
      *
      * put payment on the LEVEL 2 screen
      *
     C                   MOVEL     'S'           @SCRN
      *
     C                   ENDIF
      *
     C     EROLL         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDBRW - BUILD BROWSE SUBFILE
      *****************************************************************
     C     BLDBRW        BEGSR
      *
      * Reset Read next browse subfile record
     C                   MOVEL     *BLANK        @RDNB             1
      *
      * Build Browse subfile
     C                   CALLB     'FTOPAYBRW'
      *
      * INPUT PARAMETERS :
      * Return Code
      * Action Code
      * Payment Ref. Pointer
      * Build subfile
      * Read subfile record
      * Level 1/2 indicator
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    SACTION           1
     C                   PARM                    SPREF            15
     C                   PARM      'Y'           @BDSFL            1
     C                   PARM      *BLANK        @RDSFL            1
     C                   PARM                    @Level            1
      *
      * OUTPUT PARAMETERS :
      * Error message
      * Option Selected
      * Payment Reference Selected
      * Command Keys
     C                   PARM      *BLANK        @ERRMS            7
     C                   PARM      *BLANK        @OPSEL            1
     C                   PARM      *BLANK        @PRSEL           15
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      * If F3 taken in browse, End Program
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      EndBLDBRW
     C                   END
      *
      * If error message returned from browse, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@P
     C                   GOTO      EndBLDBRW
     C                   END
      *
      * If F12 not taken in browse
      * Read next browse subfile record
      *
     C     @INKL         IFNE      '1'
     C                   MOVE      'Y'           @RDNB
     C                   MOVEL     'R'           @SCRN
     C                   GOTO      EndBLDBRW
     C                   END
      *
     C     EndBLDBRW     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * Read Next Subfile Record
      *
     C                   CALLB     'FTOPAYBRW'
      * INPUT PARAMETERS :
      * Return code
      * Action code
      * Payment Ref. pointer
      * Build Sub-file
      * Read Sub-file record
      * Level 1/2 indicator
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    SACTION           1
     C                   PARM                    SPREF            15
     C                   PARM      *BLANK        @BDSFL            1
     C                   PARM      'Y'           @RDSFL            1
     C                   PARM                    @Level            1
      * OUTPUT PARAMETERS :
      * Error Message
      * Option Selected
      * Payment Ref. selected
      * Function keys
     C                   PARM      *BLANK        @ERRMS            7
     C                   PARM      *BLANK        @OPSEL            1
     C                   PARM      *BLANK        @PRSEL           15
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      * If Payment read from subfile
     C     @PRSEL        IFNE      *BLANK
      *
      * Retrieve Payment details
      *
     C                   MOVEL     @OPSEL        SACTION
     C                   MOVEL     @PRSEL        SPREF
     C                   EXSR      RTVPMT
      *
      * Convert Payment
     C                   EXSR      CVTPMT
     C                   MOVEL     CrPtFilFmt    NwPtFilFmt
     C                   MOVEL     CrPtFilFmX    NwPtFilFmX                     CFT014
      *
      * Set field status on SECONDARY screen
      * (according to action code)
      *
     C                   EXSR      SFDS@P
      *
      * Put the Payment on the Level 2 screen
      *
     C                   MOVEL     'S'           @SCRN
      *
      * No payment selected, go to initial screen
      *
     C                   ELSE
     C                   EXSR      INITIAL
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
     C                   CALLB     'FTOPAYRTV'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM      '      '      @@MODE            6
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
     C/COPY WNCPYSRC,FTOPA2SC16
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
     C                   PARM                    NewPmtScnA                                 BUG24803
     C                   PARM                    NewPmtScnC                                 BUG24803
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
     C                   If        CSW209 = 'Y'                                             BUG24803
     C                   MOVEL     NewPmtScnA    CurPmtScnA                                 BUG24803
     C                   MOVEL     NewPmtScnC    CurPmtScnC                                 BUG24803
     C                   EndIf                                                              BUG24803
     C                   MOVEL     NewPmtScn5A   CurPmtScn5A                                  CER030
     C                   MOVEL     NewPmtScn5B   CurPmtScn5B                                  CER030
     C                   MOVE      CDRT          WPrvCDRT          1                          187056
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFDS@P - SET FIELD STATUS ON LEVEL 2 SCREEN
      *****************************************************************
     C     SFDS@P        BEGSR
      *
      * Enable/disable fields on level 2 screen
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
      * Key fields must always be disabled if called from linked enquiry
     C     LinkedEnq     IFNE      *BLANKS
     C                   MOVEL     'N'           @EKYFD
     C                   END
 
      * Enable/disable function keys
      *
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KP = COMMAND KEY 15 = BROWSE
      *
     C     LinkedEnq     IFEQ      *BLANKS
     C                   MOVEL     'Y'           @EINKG
     C                   MOVEL     'Y'           @EINKH
     C                   MOVEL     'Y'           @EINKP
     C                   ELSE
     C                   MOVEL     'N'           @EINKG
     C                   MOVEL     'N'           @EINKH
     C                   MOVEL     'N'           @EINKP
     C                   END
      *
     C* IF CALLED FROM SUB-FILE ENQUIRY PROGRAM ENABLE F18,
     C     LinkedEnq     IFNE      *BLANKS
     C                   MOVEL     'Y'           @EINKS            1
     C                   ELSE
     C                   MOVEL     'N'           @EINKS
     C                   END
      *
      * If BIC database plus integration is on, set F4 and F16                  CFT007
                                                                                CFT007
      * KD = COMMAND KEY 04 = BIC in-line prompt                                CFT007
      * KQ = COMMAND KEY 16 = BIC in-line search                                CFT007
                                                                                CFT007
     C                   IF        @CFT007 = 'Y' and SACTION <> 'E'             CFT007
     C                   EVAL      @EINKD = 'Y'                                 CFT007
     C                   EVAL      @EINKQ = 'Y'                                 CFT007
     C                   ELSE                                                   CFT007
     C                   EVAL      @EINKD = 'N'                                 CFT007
     C                   EVAL      @EINKQ = 'N'                                 CFT007
     C                   ENDIF                                                  CFT007
                                                                                CFT007
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFDS@P - INITIALIZE FIELD STATUS ON LEVEL 2 SCREEN
      *****************************************************************
     C     IFDS@P        BEGSR
      *
      * ENABLE KEY FIELDS ON LEVEL 2 SCREEN
      *
     C                   MOVEL     'Y'           @EDTFD
     C                   MOVEL     'Y'           @EKYFD
      *                                                                                       195220
      ** F12 key pressed, restore unexpanded data.                                            195220
      *                                                                                       195220
     C     SACTION       IFEQ      'E'                                                        195220
     C     PREF          ANDEQ     SPREF                                                      195220
      *                                                                                       195220
     C                   MOVEL     RCO1          SRCO1                                        195220
     C                   MOVEL     RCO2          SRCO2                                        195220
     C                   MOVEL     RCO3          SRCO3                                        195220
     C                   MOVEL     RCO4          SRCO4                                        195220
     C                   MOVEL     RCO5          SRCO5                                        195220
      *                                                                                       195220
     C                   MOVEL     ACB1          SACB1                                        195220
     C                   MOVEL     ACB2          SACB2                                        195220
     C                   MOVEL     ACB3          SACB3                                        195220
     C                   MOVEL     ACB4          SACB4                                        195220
     C                   MOVEL     ACB5          SACB5                                        195220
      *                                                                                       195220
     C                   MOVEL     BNC1          SBNC1                                        195220
     C                   MOVEL     BNC2          SBNC2                                        195220
     C                   MOVEL     BNC3          SBNC3                                        195220
     C                   MOVEL     BNC4          SBNC4                                        195220
     C                   MOVEL     BNC5          SBNC5                                        195220
      *                                                                                       195220
     C                   MOVEL     INB1          SINB1                                        195220
     C                   MOVEL     INB2          SINB2                                        195220
     C                   MOVEL     INB3          SINB3                                        195220
     C                   MOVEL     INB4          SINB4                                        195220
     C                   MOVEL     INB5          SINB5                                        195220
      *                                                                                       195220
     C                   ENDIF                                                                195220
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@P - SEND A MESSAGE TO LEVEL 2 DETAILS SCREEN
      *****************************************************************
     C     SNDM@P        BEGSR
      *
      * If single branching, user can't browse file
      *
     C     @ERRMS        IFEQ      'FXM0292'
     C                   MOVE      'N'           OKACTION
     C                   END
      *
      ** Payment reference on screen must be blank or numeric for pointer
      *
     C     @ERRMS        IFEQ      'MMA1066'
     C                   MOVE      'N'           OKPREF
     C                   END
      *
      ** Add error message to array passed to detail screen
      *
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99          *
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
      *
     C     EndSNDM@P     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - CANCEL ON LEVEL 2 DETAILS SCREEN
      *****************************************************************
     C     CANC@S        BEGSR
      *
      * Reset Read Next Browse Subfile Record (if active)
      *
     C                   MOVEL     *BLANK        @RDNB
      *
      * If input fields are enabled
      * Blank the screens
      *
     C     @EKYFD        IFEQ      'Y'
     C     @EDTFD        OREQ      'Y'
     C                   MOVEL     *BLANK        NewPmtScn1
     C                   MOVEL     *BLANK        NewPmtSc1b                     CFT014
     C                   MOVEL     *BLANK        NewPmtSc2a
     C                   MOVEL     *BLANK        NewPmtSc2b
     C                   MOVEL     *BLANK        NewPmtScn3
     C                   MOVEL     *BLANK        NewPmtSc3b                     CFT014
     C                   MOVEL     *BLANK        NewPmtScn4                     CFT014
     C                   MOVEL     *BLANK        NewPmtScn5                     CFT014
     C                   MOVEL     *BLANK        NewPmtScn5A                                  CER030
     C                   MOVEL     *BLANK        NewPmtScn5B                                  CER030
     C                   MOVEL     *BLANK        DDSTAT
     C                   END
      *
     C                   MOVEL     'N'           @EINKJ
      *
      * Initialize field status on Level 2 Screen
      *
     C                   EXSR      IFDS@P
      *
      ** If called from linked enqiry return to calling program.
     C     LinkedEnq     IFNE      *BLANK
     C                   MOVEL     'T'           @SCRN
      ** F12
     C     @INKL         IFEQ      '1'
     C                   MOVEL     'USR0790'     @ReturnCde
      ** F18
     C                   ELSE
     C                   MOVEL     'FTM2005'     @ReturnCde
     C                   END
     C                   END
      *
     C                   ENDSR
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
      ** If not called from linked enquiry, initialise field status on          CFT014
      ** level 2 primary screen.                                                CFT014
                                                                                CFT014
     C                   If        LinkedEnq = *Blank                           CFT014
     C                   Exsr      IFDS@P                                       CFT014
     C                   EndIf                                                  CFT014
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
      * Return to Level 2 Screen
      *
     C***********        MOVEL     'S'           @SCRN                          CFT014
     C                   MOVEL     'B'           @SCRN                          CFT014
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * LINK - Set up processing for call from linked enqury.
      *****************************************************************
     C     LINK          BEGSR
      *
      ** If reference passed...
      *
     C     XPREF         IFNE      *BLANKS
     C                   MOVE      @SORT         SACTION
     C                   MOVE      XPREF         SPREF
      *
      * Retrieve & Validate Payment details prior to display
     C                   EXSR      VAL@S
     C                   END
      *
     C     EndLink       TAG
      *
      ** Disable CMDs 7,8 & 15 and key fields
 
     C                   MOVE      'N'           @EINKG
     C                   MOVE      'N'           @EINKH
     C                   MOVE      'N'           @EINKP
     C                   MOVE      'N'           @EKYFD
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
     C                   CALLB     'FTOPAY2DP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NewPmtScn1
     C                   PARM                    NewPmtSc2a
     C                   PARM                    NewPmtSc2b
     C                   PARM                    NewPmtSc1b                     CFT014
      *
      * DEAL STATUS
     C                   PARM                    DDSTAT
      *
      * FIELDS IN ERROR
     C                   PARM                    FTEOPY1
     C                   PARM                    FTEOPY2
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
     C                   PARM      'N'           @EINKD                         CFT007
     C                   PARM      'N'           @EINKG
     C                   PARM      'N'           @EINKH
     C                   PARM      'N'           @EINKP
     C                   PARM      'N'           @EINKQ                         CFT007
     C                   PARM      'N'           @EINKS
      *
      * SUCCESFUL INSERT
     C                   PARM                    @SITR
      *
      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKD             1             CFT007
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKQ             1            CFT007
     C                   PARM      '0'           @INKS             1
     C                   PARM      'N'           WriteOnly         1
     C                   PARM      0             CursorLoc         5 0          CFT007
      *
      * RESET ERRORS
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
      * RETURN TO LEVEL 2 SCREEN
      *
     C                   MOVEL     'S'           @SCRN
      *
      * Initialize field status on Level 2 screen
      *
     C                   EXSR      IFDS@P
      *
      * Set function key status on level 2 screen
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
      * ELSE, RETURN TO LEVEL 2 SCREEN
      *
     C                   ELSE
     C                   MOVEL     'S'           @SCRN
      *
      * Initialize field status on level 2 screen
      *
     C                   EXSR      IFDS@P
      *
      * Set function key status on level 2 screen
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
      * 'Inserts' from Level 2 maintenance are in reality 'amendments'
      * because the transaction already exists on OTPAYDD from Level 1
      * input. Change action code to 'A' to prevent duplicate key error.
 
     C     SACTION       IFEQ      'I'
     C                   MOVE      'A'           SACTION
      * use current file Timestamp as I is in fact A                                          204067
      * Timestamp is required to test if updated by another workstation                       204067
     C                   MOVE      TMST          OTTMESTMP                                    204067
     C                   END
     C/COPY WNCPYSRC,FTOPA2SC01
 
      * UPDATE VALID Payment: Payment REFERENCE
      *
     C                   MOVEL     SPREF         OTPREF
      *
      * UPDATE VALID Payment: CHANGE TYPE
      *
     C                   MOVEL     SACTION       OTCHTP
      *
      * UPDATE VALID Payment: RECI
      *
                                                                                CFT014
     C                   If        (@CFT003 = 'Y') Or (@CFT014 = 'Y')           CFT014
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
      *  Return Code
     C                   Parm                    RetCodeOut
 
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
     C                   PARM                    PAuth             1                          CAP211
     C                   PARM                    PUser            10                          CAP211
      *                                                                                       CAP211
     C/COPY WNCPYSRC,FTOPA2SC09
 
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     RetCodeOut    IFNE      *BLANK
     C     RetCodeOut    ANDNE     '*RECUPD'
      **                                                                                      CSC022
      ** Execute rollback if SAR CSC022 is not enrolled or                                    CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
     C/COPY WNCPYSRC,FTOPA2SC03
     C                   IF        ULX043 = 'Y'                                               CER001
     C                             AND SACTION <> 'D'                                         CER001
      *                                                                                       CER001
      ** New Window processing, if F12 or F3                                                  CER001
      ** Create a Blank Record without details using call to FT0045XL                         CER001
      ** during Close of Business (No ext. details in this case)                              CER001
      *                                                                                       CER001
     C                   EXSR      WINDOWI                                                    CER001
     C                   ENDIF                                                                CER001
      **                                                                                      CSC022
      ** Execute commit if SAR CSC022 is not enrolled or                                      CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   MOVE      SPREF         @SITR
     C                   END
      *
     C** If update not done due to record being updated by another
     C** workstation send message to screen.
     C
     C     RetCodeOut    IFEQ      '*RECUPD'
     C
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
     C
     C                   END
     C
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * Else, if called from linked enquiry go back to calling program.
     C     LinkedEnq     IFNE      *BLANKS
     C                   EXSR      CANC@S
     C                   ELSE
 
      * ELSE, GO TO INITIAL SCREEN
      *
     C                   EXSR      INITIAL
     C                   END
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - End Program
      *****************************************************************
     C     ENDP          BEGSR
      *                                                                                       209867
      ** Issue rollback to clear any possible updates in window function                      209867
      *                                                                                       209867
     C     BGWDPR        IFEQ      'Y'                                                        209867
      **                                                                                      CSC022
      ** Execute rollback if SAR CSC022 is not enrolled or                                    CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK                                                                209867
     C                   Else                                                                 CSC022
     C                   If        WSkpComtRolbk = 'N'                                        CSC022
     C                   RolBk                                                                CSC022
     C                   Else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   END                                                                  209867
      *
     C                   MOVEL     'T'           @SCRN
      *
      ** If called from linked enqiry return to calling program.
     C     LinkedEnq     IFNE      *BLANK
     C                   MOVEL     'Y2U9999'     @ReturnCde
     C                   END
      *
     C                   ENDSR
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
     C                   Eval      @ERRMS = 'FTM3262'                           CFT014
     C                   Else                                                   CFT014
     C                   EVAL      @ERRMS = 'FTM2621'                           CFT007
     C                   Endif                                                  CFT014
     C                   EXSR      SNDM@P                                       CFT007
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
     C                   IF        SPCCY=BLUSCY and                             CFT007
     C                             (Line1RCor = *On or                          CFT007
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
      * If return data is BIC code with clearing code,'AC',or (branch           CFT007
      * or address with clearing code,'BC'/'DC', and cursor is on               CFT007
      * a 2nd line), remove clearing code                                       CFT007
                                                                                CFT007
     C                   IF          @OOutCode = 'AC' or                        CFT007
     C                             ((@OOutCode = 'BC' or                        CFT007
     C                               @OOutCode = 'DC') and                      CFT007
     C                              (Line2RCor = *On or                         CFT007
     C                               Line2ABnk = *On or                         CFT007
     C                               Line2Benf = *On or                         CFT007
     C***********                    Line2IBnk = *On ))                         CFT007 CFT014
     C                              Line2IBnk = *On or                          CFT014
     C                              (Line2TRIn = *On And @CFT014 = 'Y')))       CFT014
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
      * Reset Read Next Browse Subfile Record (if active)
      *
     C                   MOVEL     *BLANK        @RDNB
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
     C                   MOVEL     *BLANKS       NewPmtScn5A                                  CER030
     C                   MOVEL     *BLANKS       NewPmtScn5B                                  CER030
     C                   MOVEL     *BLANK        DDSTAT
      *
      * Level 2 input Screen
      *
     C                   MOVEL     'S'           @SCRN             1
      *
      * Initialize field status on Level 2 Screen
      *
     C                   EXSR      IFDS@P
      *
      * Initialize F10 key field
     C                   MOVE      'N'           @EINKJ            1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    @ReturnCde        7
     C                   PARM                    @SORT             1
     C                   PARM                    XPREF            15
     C                   PARM                    P3PARM           64
     C                   PARM                    P4PARM           14
      *
      ** Initialize program name
      *
     C                   MOVEL     'FTOPAY2SN'   DBPGM
 
      ** If parameters are not blank then the program has been called
      ** from linked enquiry FT0140
      *
     C     @SORT         IFNE      *BLANKS
     C     XPREF         ORNE      *BLANKS
     C                   MOVE      'Y'           LinkedEnq         1
     C                   END
 
      * Clear fields used invalidation
     C                   Clear                   Val@Fields
      **********                                                                             BUG7029
      **GET*ZMUSER*to*access*default*branch.                                                 BUG7029
     C******DTAARA       Define                  ZMUSER                                      BUG7029
     C**********         In        ZMUSER                                                    BUG7029
     C**********         Unlock    ZMUSER                                                    BUG7029
 
     C                   Eval      @DFBR = WDFBR
     C                   Eval      @DPPT = WDPPT
 
      * Get RUNDAT to access Multi Branch Indicator
     C     *DTAARA       Define                  RUNDAT
     C                   In        RUNDAT
     C                   Unlock    RUNDAT
 
     C                   Eval      @MBIN = WMBIN
 
      *  Move program name into *LDA field.
     C     *LOCK         In        LDA
     C                   Movel     'FTPYOTVAL'   DBPGM
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
 
      * Access SAR details file to determine if S01494 is on.
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
                                                                                CFT014
      ** Access SAR details file to see if CFT014 is installed.                 CFT014
                                                                                CFT014
     C                   Callb     'AOSARDR0'                                   CFT014
     C                   Parm      *BLANKS       @RTCD                          CFT014
     C                   Parm      '*VERIFY'     @OPTN                          CFT014
     C                   Parm      'CFT014'      @SARD                          CFT014
     C     SCSARD        Parm      SCSARD        DSFDY                          CFT014
                                                                                CFT014
     C                   If        @RTCD <> *Blanks and                         CFT014
     C                             @RTCD <> '*NRF   '                           CFT014
     C                   Movel     'SCSARDPD'    DBFILE                         CFT014
     C                   Movel     '080'         DBASE                          CFT014
     C                   Movel     'CFT014'      DBKEY                          CFT014
     C                   Exsr      *PSSR                                        CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   If        @RTCD = *Blanks                              CFT014
     C                   Movel     'Y'           @CFT014                        CFT014
     C                   Else                                                   CFT014
     C                   Movel     'N'           @CFT014                        CFT014
     C                   EndIf                                                  CFT014
 
      * Retrieve Base Currency Details
     C                   Move      BJCYCD        @K101
     C                   CALLB     'AOCURRR0'
     C                   Parm      '*DBERR '     @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm                    @K101             3
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   Eval      @BCDP = A6NBDP
 
      * Access SAR details file to see if CFT007 is installed.                  CFT007
      *                                                                         CFT007
     C                   CALLB     'AOSARDR0'                                   CFT007
     C                   Parm      *BLANKS       @RTCD                          CFT007
     C                   Parm      '*VERIFY'     @OPTN                          CFT007
     C                   Parm      'CFT007'      @SARD                          CFT007
     C     SCSARD        Parm      SCSARD        DSFDY                          CFT007
                                                                                CFT007
     C                   If        @RTCD = *Blanks                              CFT007
     C                   Movel     'Y'           @CFT007                        CFT007
     C                   Else                                                   CFT007
     C                   Movel     'N'           @CFT007                        CFT007
     C                   End                                                    CFT007
      *                                                                                       CFT050
      ** Access SAR file to determine if CFT050 (SWIFTRef Directories                         CFT050
      ** upload) is installed.                                                                CFT050
      *                                                                                       CFT050
     C                   CALLB     'AOSARDR0'                                                 CFT050
     C                   PARM      *BLANKS       PRTCD                                        CFT050
     C                   PARM      '*VERIFY'     POPTN                                        CFT050
     C                   PARM      'CFT050'      PSARD                                        CFT050
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT050
      *                                                                                       CFT050
      ** CFT007 process will take place when CFT050 is switched on                            CFT050
      *                                                                                       CFT050
     C                   IF        PRTCD = *BLANKS                                            CFT050
     C                   EVAL      @CFT007 = 'Y'                                              CFT050
     C                   ENDIF                                                                CFT050
                                                                                CFT009
      ** Access SAR details file to see if CFT009 is installed.                 CFT009
                                                                                CFT009
     C                   CALLB     'AOSARDR0'                                   CFT009
     C                   PARM      *BLANKS       @RTCD                          CFT009
     C                   PARM      '*VERIFY'     @OPTN                          CFT009
     C                   PARM      'CFT009'      @SARD                          CFT009
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT009
                                                                                CFT009
     C                   IF        @RTCD <> *BLANKS AND                         CFT009
     C                             @RTCD <> '*NRF   '                           CFT009
     C                   MOVEL     'SCSARDPD'    DBFILE                         CFT009
     C                   MOVEL     '081'         DBASE                          CFT009
     C                   MOVEL     'CFT009'      DBKEY                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        @RTCD = *BLANKS                              CFT009
     C                   MOVEL     'Y'           @CFT009                        CFT009
     C                   ELSE                                                   CFT009
     C                   MOVEL     'N'           @CFT009                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
      ** Access SAR details file to see if CFT010 is installed.                 CFT009
                                                                                CFT009
     C                   CALLB     'AOSARDR0'                                   CFT009
     C                   PARM      *BLANKS       @RTCD                          CFT009
     C                   PARM      '*VERIFY'     @OPTN                          CFT009
     C                   PARM      'CFT010'      @SARD                          CFT009
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT009
                                                                                CFT009
     C                   IF        @RTCD <> *BLANKS AND                         CFT009
     C                             @RTCD <> '*NRF   '                           CFT009
     C                   MOVEL     'SCSARDPD'    DBFILE                         CFT009
     C                   MOVEL     '082'         DBASE                          CFT009
     C                   MOVEL     'CFT010'      DBKEY                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        @RTCD = *BLANKS                              CFT009
     C                   MOVEL     'Y'           @CFT010                        CFT009
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
     C                   EVAL      DBASE = 38                                                 CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *BLANKS                                            CSC011
     C                   EVAL      @CSC011 = 'Y'                                              CSC011
                                                                                              CSC011
      ** Get support system prefix and current system prefix                                  CSC011
                                                                                              CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      @CSC011 = 'N'                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSD015
      ** Check if CSD015 is installed                                                         CSD015
                                                                                              CSD015
     C                   EVAL      @CSD015 = 'N'                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PRtCd                                        CSD015
     C                   PARM      '*VERIFY'     POptn                                        CSD015
     C                   PARM      'CSD015'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRtCd <> *BLANKS) and                                     CSD015
     C                             (PRtCd <> '*NRF   ')                                       CSD015
     C                   EVAL      DBKEY = 'CSD015'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 003                                                CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRtCd = *BLANKS                                            CSD015
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
     C                   Eval      DBPgm  = 'FTOPAY2SN'                                       CSC022
     C                   Eval      DBKey  = 'CSC022'                                          CSC022
     C                   Eval      DBase  = 900                                               CSC022
     C                   Out       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      **                                                                                      CSC022
                                                                                              CSW203
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
     C                   EVAL      DBASE  = 39                                                CGL014
     C                   EXSR      *PSSR                                                      CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        PRTCD = *BLANKS                                            CGL014
     C                   EVAL      @CGL014 = 'Y'                                              CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      @CGL014 = 'N'                                              CGL014
     C                   ENDIF                                                                CGL014
                                                                                CFT007
     C/COPY OFCPYSRCZ,CFT148_019                                                              CFT148
     C/COPY WNCPYSRC,FTOPA2SC05
      * Read SDTRADPD for US dollar currency code                               CFT007
                                                                                CFT007
     C                   CALLB     'AOTRADR0'                                   CFT007
     C                   PARM      *BLANKS       @RTCD                          CFT007
     C                   PARM      '*FIRST'      @OPTN                          CFT007
     C     SDTRAD        PARM      SDTRAD        DSFDY                          CFT007
                                                                                CFT007
     C     @RTCD         IFNE      *BLANKS                                      CFT007
     C                   MOVEL     'SDTRADPD'    DBFILE                         CFT007
     C                   MOVEL     '902'         DBASE                          CFT007
     C                   MOVEL     @OPTN         DBKEY                          CFT007
     C                   EXSR      *PSSR                                        CFT007
     C                   END                                                    CFT007
                                                                                CFT007
      ** Use processing date defined in SC24X7 dataarea when support system                   CSC011
      ** is active.                                                                           CSC011
                                                                                              CSC011
     C                   IF        (@CSC011 = 'Y') AND (LIBR = S1SUPP)                        CSC011
     C                   EVAL      ZDAYNO = WPRDTE                                            CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      ZDAYNO = BJRDNB                                            CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      * Calculate Run Date
     C                   CALLB     'ZDATE2'
     C**********         Parm      BJRDNB        ZDAYNO            5 0                        CSC011
     C                   PARM                    ZDAYNO            5 0                        CSC011
     C                   Parm                    BJDFIN
     C                   Parm      0             ZDATE             6 0
     C                   Parm      *Blanks       ZADATE            7
 
     C                   Eval      @RUNN = ZDATE
 
      * Calculate Back Value Date
      ** Use processing date defined in SC24X7 dataarea when support system                   CSC011
      ** is active.                                                                           CSC011
                                                                                              CSC011
     C                   IF        (@CSC011 = 'Y') AND (LIBR = S1SUPP)                        CSC011
     C                   EVAL      @BVLD = WPRDTE - BJBVPD                                    CSC011
     C                   ELSE                                                                 CSC011
     C                   Eval      @BVLD = BJRDNB - BJBVPD
     C                   ENDIF                                                                CSC011
      *                                                                                     BUG24803
      ** Check if SWIFT2009 is installed                                                    BUG24803
      *                                                                                     BUG24803
     C                   Eval      CSW209 = 'N'                                             BUG24803
     C                   Call      'SWIF2009'                                               BUG24803
     C                   Parm      *BLANKS       PRTCD                                      BUG24803
                                                                                            BUG24803
     C                   If        PRTCD = 'CSW2009'                                        BUG24803
     C                   Eval      CSW209 = 'Y'                                             BUG24803
     C                   EndIf                                                              BUG24803
 
      * Set up User id
     C                   Eval      @USRID = PSUSER
 
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
      * Set level 1/2 flag to '2'
     C                   MOVE      '2'           @Level            1
 
      * If called from linked enquiry set up screen details
     C     LinkedEnq     IFNE      *BLANK
     C                   EXSR      LINK
     C                   END
      *
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FTOPAYS012
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
     C                   END                                                                  CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS                                            CER001
     C                   MOVEL     'Y'           ULX043                                       CER001
     C                   ELSE                                                                 CER001
     C                   MOVEL     'N'           ULX043                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER030
      ** CER030 - Multicash German Feature                                                    CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER030'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
      ** An NRF (No Record Found) return code is valid.                                       CER030
      ** Issue database error only for error return codes.                                    CER030
      *                                                                                       CER030
     C                   IF        PRtCd <> *BLANKS AND                                       CER030
     C                             PRtCd <> '*NRF   '                                         CER030
     C                   EVAL      DBKEY = 'CER030'                                           CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   Z-ADD     905           DBASE                                        CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtCd = *BLANKS                                            CER030
     C                   EVAL      CER030 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CER030 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** CER031 - Multicash German Feature                                                    CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER031'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
      ** An NRF (No Record Found) return code is valid.                                       CER030
      ** Issue database error only for error return codes.                                    CER030
      *                                                                                       CER030
     C                   IF        PRtCd <> *BLANKS AND                                       CER030
     C                             PRtCd <> '*NRF   '                                         CER030
     C                   EVAL      DBKEY = 'CER031'                                           CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   Z-ADD     906           DBASE                                        CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtCd = *BLANKS                                            CER030
     C                   EVAL      CER031 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CER031 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** CGL013 - SWIFT Feature                                                               CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CGL013'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
      ** An NRF (No Record Found) return code is valid.                                       CER030
      ** Issue database error only for error return codes.                                    CER030
      *                                                                                       CER030
     C                   IF        PRtCd <> *BLANKS AND                                       CER030
     C                             PRtCd <> '*NRF   '                                         CER030
     C                   EVAL      DBKEY = 'CGL013'                                           CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   Z-ADD     907           DBASE                                        CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtCd = *BLANKS                                            CER030
     C                   EVAL      CGL013 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CGL013 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
 
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
