     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Incoming payments input')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAYSIN - Incoming Payments Input                          *
      *                                                               *
      *  Function: This is the main module for the screen input       *
      *            function for Incoming Payments.                    *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. AR921987           Date 23Mar12               *
      *  Prev Amend No. AR928996A          Date 03May12               *
      *                 AR928996           Date 27Mar12               *
      *                 MD047369A          Date 24Jan18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD036089           Date 23Oct15               *
      *                 AR1090283          Date 10Aug16               *
      *                 MD025111           Date 10May14               *
      *                 CFT151             Date 21Mar14               *
      *                 MD022652           Date 07Oct13               *
      *                 MD023247           Date 03Dec13               *
      *                 MD022428           Date 17Sep13               *
      *                 257125             Date 28Sep12               *
      *                 CFT120             Date 28Sep12               *
      *                 CAP211             Date 28Sep12               *
      *                 261468             Date 10Aug12               *
      *                 CSC054             Date 23Feb12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 260326             Date 18Jun09               *
      *                 BUG24998           Date 17Jul09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 257665             Date 14Nov08               *
      *                 256256             Date 04Sep08               *
      *                 256117             Date 18Aug08               *
      *                 255350             Date 25Jul08               *
      *                 250600             Date 30Sep07               *
      *                 247142             Date 01Jun07               *
      *                 248631             Date 23Jun07               *
      *                 247665             Date 17May07               *
      *                 BUG14494A          Date 09Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 GBO015             Date 06Sep06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 241002             Date 18Jul06               *
      *                 CDL049             Date 06Jul06               *
      *                 226917             Date 06Jun06               *
      *                 225169             Date 06Jun06               *
      *                 226722             Date 06Jun06               *
      *                 216351             Date 06Jun06               *
      *                 219728             Date 06Jun06               *
      *                 220180             Date 06Jun06               *
      *                 237914             Date 18Apr06               *
      *                 237415             Date 21Feb06               *
      *                 237413             Date 08Feb06               *
      *                 CSD027             Date 09Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 BUG7101            Date 06Jul05               *
      *                 CSC024             Date 07Feb05               *
      *                 BUG4776            Date 15Nov04               *
      *                 CFT115             Date 01Jul04               *
      *                 CGL014             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 TDA006             Date 16Mar04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001             Date 09Dec03               *
      *                 CAP084             Date 25Aug03               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 210733             Date 11Dec02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209067             Date 09Sep02               *
      *                 207211             Date 16Jul02               *
      *                 204152             Date 10Apr02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 202322             Date 30Jan02               *
      *                 CSC011             Date 18Sep01               *
      *                 193883             Date 20Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 195545             Date 13Jul01               *
      *                 195063             Date 05Jul01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 28Feb01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 187056             Date 01Dec00               *
      *                 CSD009             Date 10Oct00               *
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR921987 - If Sender's Correspondent is decoded it must be   *
      *             placed in Receiver's Correspondent for IN (if     *
      *             Receiver's Correspondent is blank and Sender's    *
      *             Correspondent is non-blank). (Child: AR921990)    *
      *  AR928996A- Data truncation error. Amended PDATA and PDAT2    *
      *             data structure field to have the correct length.  *
      *             (Child: AR928997A)                                *
      *  AR928996 - Data lost due to rate field :36: being truncated. *
      *             (Child: AR928997)                                 *
      *  MD047369A - Funds transfter does not check block Dr flag on  *
      *              beneficary customer account.                     *
      *  MD046248 - Finastra Rebranding                               *
      *  MD036089 - Incorrect values appeared in FT IPN1              *
      *  AR1090283 - Customer details not visible for enquire.        *
      *              (Child: AR1090284)                               *
      *            - Applied for MD-39986.                            *
      *  MD025111 - Incoming payment without charges is not allowed   *
      *             if the account is blocked for DR                  *
      *  CFT151 - FT IN/OP Alphanumeric sequence                      *
      *  MD022652 - Excluded Phase Processing                         *
      *  MD023247 - Dbase Error in Incoming payments for a sender     *
      *  MD022428 - CAR CFT120 - points instead of currency           *
      *  257125 - CAR CFT120 Charge display error                     *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CAP211 - FT IN_OP APIs - Auto-Authorization of Payment       *
      *  261468 - Disable F7, F8 and F15 from screens 2, 3 and 4 to   *
      *           be consistent with Outgoing payments input screen.  *
      *           Also de-allocate payment reference numbers when     *
      *           browse functions keys are taken after an F12 in the *
      *           2nd, 3rd and 4th settlement/charges screen          *
      *  CSC054 - Period End Adjustments                              *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  260326 - Incorrect restoration of canceled ref seq number.   *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  257665 - Applied fix 247833. Process field 20 of the         *
      *           incoming message to related pay ref for MT103.      *
      *  256256 - Redisplay Level 2 Screen 3 if the value of          *
      *           'Charges to the debit of a/c' has been changed      *
      *  256117 - Error on charges screen not shown due to validations*
      *           setting screen to 'F' when warning counter is zero. *
      *  255350 - Patterned after 247833 and 220800.                  *
      *           Process field 20 of the incoming message            *
      *           to related pay reference number for MT202           *
      *  250600 - Fix to CFT032                                       *
      *  247142 - Funds Transfer allows payments over Blocked &       *
      *           Reffered Accounts without warning. Apply fix 232151.*
      *  232151 - Warning message for the first screen appears on the *
      *           second screen.                                      *
      *  248631 - No warning message for outbound FT on a holiday.    *
      *           Patterned fix after 223018 which resets the error   *
      *           messages after displaying.                          *
      *  247665 - Payment reference validation was removed in order   *
      *           to update the value of INLVL1 to "Y".               *
      *  BUG14494A - Incoming Payment not working                     *
      *  GBO015 - Incoming Payments Beneficiary Validation            *
      *           Added hook FTIPAYS015                               *
      *  CFT032 - Account line in field 50X in MT103                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  241002 - Cannot amend booking branch. Applied 227458.        *
      *           This fix has already been catered by 220180.        *
      *  227458 - Allow booking branch to be amendable. Applied part  *
      *           of 219713.                                          *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  226917 - 225169 should not perform database error processing *
      *           if a currency is not found.                         *
      *  225169 - When routed payment contains SWIFT currency code,   *
      *           translate it to Midas currency code.                *
      *  226722 - Transfer Commission Tariff code is redefaulted when *
      *           F12 is pressed in first screen. Applied fix 228749. *
      *           When F12 is pressed, data that was previously       *
      *           entered will be retained.                           *
      *  216351 - Re-initialise warning message array to blank before *
      *           showing 2nd level screen for IPN1 menu.             *
      *  219728 - Initial screen should be redisplayed after insert   *
      *           also when program called from linked function,      *
      *           otherwise user does not receive new payment         *
      *           reference.                                          *
      *  220180 - Make booking branch amendable.                      *
      *  237914 - Receivers's and Sender's Correspondents should be   *
      *           translated to 5 char Nostro Id, not to two digit    *
      *           Nostro Code. Add the missing translation processing *
      *           for P55 (Third Reimbursement Part). Also add the    *
      *           missing processing for IBAN in SrTran.              *
      *  237415 - Add a condition that when called from a link, the   *
      *           charges will not be overwritten if it is not blank. *
      *  237413 - Increase length of DS LFLT due to changes in CGL029.*
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  BUG7101 - DB error in AOSPOSU0 due to blank INTRIT. Ensure   *
      *            fields are properly initialised.  Applied core fix *
      *            216842.                                            *
      *  CSC024 - Open Month End                                      *
      *  BUG4776- Correct skipping of transaction reference.          *
      *  CFT115 - Core changes for GBO015.                            *
      *         - Incoming Payments Beneficiary Validation            *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:FTIPAYS002,FTIPAYSC11,FTIPAYSC02 *
      *  CGL014 - Collaterals Processing                              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  TDA006 - Correct 10-digit full account processing.           *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Recompiled due to change in FTV2OPYPD               *
      *  CAP084 - Thin Client API Wrappers                            *
      *           Recompiled over changed FTIPY6PD.                   *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  210733 - Transaction reference not displayed if SWIFT        *
      *           payments are routed to incoming payments or         *
      *           outgoing payments.                                  *
      *           Pass inserted reference and an 'I return code to    *
      *           display the transaction reference via ME1060        *
      *           program.  Apply fix 197712.                         *
      *  209067 - Amend 204152 to ensure payment number is decremented*
      *           only if a new payment was generated.                *
      *  207211 - invalid date not detected                           *
      *  204152 - Move SR to set up PREF to before window call        *
      *  202322 - FTIPAYSIN decimal data error in FTVITCHG            *
      *           (recompile)                                         *
      *  CSC011 - 24x7 Midas Availability                             *
      *  193883 - Recompile over changed FTIPAYUPD.                   *
      *  195545 - Cannot go through warning message FTM2070.          *
      *  195063 - Book Code defaults to 'FT' when transaction is      *
      *           coming from an Electronic Message.                  *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  187056 - IP and OP do not recalculate screen charges if      *
      *           'Charges to the Debit of a/c' has been changed      *
      *           from blank to non-blank.                            *
      *  CSD009 - Profit Centre Accounting Default Matrix Enhancement *
      *           Re-compiled due to changes in module AOPRFMR0.      *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
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
      ** GL Accounts file
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
      *
      ** Payment Charges file
     FPYCHGDB   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(PY)
     F*FTPREFL1**IF***E***********K*DISK***                                           BUG4776 260326
      *                                                                                       CER001
     FFTIPX1L0  IF   E           K DISK    COMMIT                                             CER001
     F                                     RENAME(INPAYDDL:RTVIDX)                            CER001
     F                                     USROPN                                             CER001
     F                                     INFSR(*PSSR)                                       CER001
                                                                                              CER001
     FSDCURRLD  IF   E           K DISK    INFSR(*PSSR)                                       225169
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,FTIPAYS001
      *
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *                                                                                       CER030
      ** The following /COPY line includes all the definitions of the                         CER030
      ** appended error arrays, including the named constant giving the size                  CER030
      ** of the arrays.                                                                       CER030
      *                                                                                       CER030
      /COPY ZACPYSRC,ERR_XARRYS                                                               CER030
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
                                                                                              CSC024
      ** System Values Array                                                                  CSC024
     D*SysValOME       C                   CONST('OMEIndicator')                       CSC024 CSC054
     D SysValPEA       C                   CONST('PEAIndicator')                              CSC054
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Narrative for Sender
     D PSNAR           S             35    DIM(1) CTDATA PERRCD(1)
                                                                                              CSC024
      *
      ** Work array for warning message Ids
     D WPrvWarnAr      S                   Dim(ArrayMax)
     D                                     Like(WMsgIDArr)
      *
      ** Work array for setting up new Payment Reference
     D WYA2            S              1    DIM(18)
      *
      ** Work array for Amount for FONTIS processing
     D WYA1            S              1    DIM(15)
      *
      ** Work array
     D WA              S              1    DIM(15)
      *
      ** Work array used in SR CWVAL to store content of tag
     D W@CW            S              1    DIM(256)
      *
      ** Work array used in SR CWVAL to store value extracted
     D W@VL            S              1    DIM(256)
      ** Commitment Control Job Array                                                         CSC022
     D WJobs           S             10A   Dim(10)                                            CSC022
      **                                                                                      CSC022
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming  transaction
      ** - screen format
     D NwIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
     D***NwDetailScrn          20    480                                                    MD036089
     D  NwDetailScrn          20    706                                                     MD036089
      *
      ** Incoming Payments Lvl 2 Scrn 1/1 details from incoming  transaction
      ** - screen format
     D NwIP2ScnFmt   E DS                  EXTNAME(FTIPY2PD)
      *
      ** Incoming Payments Lvl 2 Scrn 1/2 details from incoming  transaction
      ** - screen format
     D NwIP3ScnFmt   E DS                  EXTNAME(FTIPY3PD)
      *
      ** Incoming Payments Lvl 2 Scrn 2 details from incoming  transaction
      ** - screen format
     D NwIP4ScnFmt   E DS                  EXTNAME(FTIPY4PD)
      *
      ** Previous Incoming Payments Lvl 1 Scrn details                                        207211
     D PrvIP1ScnFmt  E DS                  EXTNAME(FTIPY1PD)                                  207211
     D                                     PREFIX(@P)                                         207211
      *                                                                                       207211
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
     D/COPY WNCPYSRC,FTH00156
      *
      ** Incoming Payments Lvl 1 Scrn details retrieved from file
      ** - screen format
     D CrIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
     D                                     PREFIX(O)
      *
      ** Incoming Payments Lvl 2 Scrn 1/1 details retrieved from file
      ** - screen format
     D CrIP2ScnFmt   E DS                  EXTNAME(FTIPY2PD)
     D                                     PREFIX(O)
      *
      ** Incoming Payments Lvl 2 Scrn 1/2 details retrieved from file
      ** - screen format
     D CrIP3ScnFmt   E DS                  EXTNAME(FTIPY3PD)
     D                                     PREFIX(O)
      *
      ** Incoming Payments Lvl 2 Scrn 2 details retrieved from file
      ** - screen format
     D CrIP4ScnFmt   E DS                  EXTNAME(FTIPY4PD)
     D                                     PREFIX(O)
      *
      ** Incoming Payments retrieved from file - file format
     D CrIPFilFmt    E DS                  EXTNAME(INPAYDD)
      *                                                                         CFT009
      ** Valid Incoming Payments Extension File (default)                       CFT009
     D DefValidX     E DS                  EXTNAME(FTVIPY2PD)                   CFT009
     D                                     PREFIX(D#)                           CFT009
      *                                                                         CFT009
      ** Valid Payments layout (default)                                        CFT009
     D DefValid      E DS                  EXTNAME(FTVIPAYPD)                   CFT009
     D                                     PREFIX(D#)                           CFT009
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     D FTEIPY1       E DS                  EXTNAME(FTEIPY1PD)
      *
      ** Incoming Payments Lvl 2 Scrn 1 error indicators
     D FTEIPY2       E DS                  EXTNAME(FTEIPY2PD)
      *
      ** Incoming Payments Lvl 2 Scrn 2 error indicators
     D FTEIPY3       E DS                  EXTNAME(FTEIPY3PD)
      *
      ** Incoming Payments extra data
     D PExtData      E DS                  EXTNAME(FTIPEXPD)
      *                                                                         CFT014
      ** Incoming Payments (additional details) for file update - file fmt      CFT014
     D NwIP2FilFmt   E DS                  EXTNAME(FTVIPY2PD)                   CFT014
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 Scrn 1/2 from transaction - screen fmt         CFT014
     D NwIP1AScnFmt  E DS                  EXTNAME(FTIPY1APD)                   CFT014
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 2/2 from transaction - screen fmt         CFT014
     D NwIP4AScnFmt  E DS                  EXTNAME(FTIPY4APD)                   CFT014
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 3 from transaction - screen fmt           CFT014
     D NwIP5ScnFmt   E DS                  EXTNAME(FTIPY5PD)                    CFT014
      *                                                                         CFT014
      ** Incoming Payments Margin info dtls from transaction - scrn fmt         CFT014
     D NwIP6ScnFmt   E DS                  EXTNAME(FTIPY6PD)                    CFT014
     D SDDSWTN       E                     EXTFLD(DDSWTN)                                     CAP084
     D SDDSEQNO      E                     EXTFLD(DDSEQNO)                                    CAP084
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 7 from transaction - screen fmt                         CSW209
     D NwIP7ScnFmt   E DS                  EXTNAME(FTIPY7PD)                                  CSW209
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 8 from transaction - screen fmt                         CSW209
     D NwIP8ScnFmt   E DS                  EXTNAME(FTIPY8PD)                                  CSW209
      *                                                                                       CER030
      ** Incoming Payments Extended Narratives from transaction                               CER030
      ** - scrn fmt                                                                           CER030
      *                                                                                       CER030
     D NwIP6AScnFmt  E DS                  EXTNAME(FTIPY6APD)                                 CER030
      *                                                                         CFT014
      ** Incoming Payments (additional details) from file - file fmt            CFT014
     D CrIP2FilFmt   E DS                  EXTNAME(INPAYXPD)                    CFT014
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 Scrn 1/2 from file - screen format             CFT014
     D CrIP1AScnFmt  E DS                  EXTNAME(FTIPY1APD)                   CFT014
     D                                     PREFIX(O)                            CFT014
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 2/2 from file - screen format             CFT014
     D CrIP4AScnFmt  E DS                  EXTNAME(FTIPY4APD)                   CFT014
     D                                     PREFIX(O)                            CFT014
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 3 from file - screen format               CFT014
     D CrIP5ScnFmt   E DS                  EXTNAME(FTIPY5PD)                    CFT014
     D                                     PREFIX(O)                            CFT014
      *                                                                         CFT014
      ** Incoming Payments Margin info details from file - screen fmt           CFT014
     D CrIP6ScnFmt   E DS                  EXTNAME(FTIPY6PD)                    CFT014
     D                                     PREFIX(O)                            CFT014
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 7 from file - screen format                             CSW209
     D CrIP7ScnFmt   E DS                  EXTNAME(FTIPY7PD)                                  CSW209
     D                                     PREFIX(O)                                          CSW209
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 8 from file - screen format                             CSW209
     D CrIP8ScnFmt   E DS                  EXTNAME(FTIPY8PD)                                  CSW209
     D                                     PREFIX(O)                                          CSW209
      *                                                                                       CER030
      ** Incoming Payments Extended Narratives from file                                      CER030
      ** - screen fmt                                                                         CER030
      *                                                                                       CER030
     D CrIP6AScnFmt  E DS                  EXTNAME(FTIPY6APD)                                 CER030
     D                                     PREFIX(O)                                          CER030
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 3 error indicators                        CFT014
     D FTEIPY4       E DS                  EXTNAME(FTEIPY4PD)                   CFT014
      *                                                                         CFT014
      ** Incoming Payments Margin info error indicators                         CFT014
     D FTEIPY5       E DS                  EXTNAME(FTEIPY5PD)                   CFT014
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 7 error indicators                                      CSW209
     D FTEIPY7       E DS                  EXTNAME(FTEIPY7PD)                                 CSW209
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 8 error indicators                                      CSW209
     D FTEIPY8       E DS                  EXTNAME(FTEIPY8PD)                                 CSW209
      *                                                                                       CER030
      ** External DS for Retail Transaction Types Details                                     CER030
      *                                                                                       CER030
     D SDRETR        E DS                  EXTNAME(SDRETRPD)                                  CER030
      *
      ** Externally described DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for General Ledger ICD details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      *
      ** Externally described DS for Midas Modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** Externally described DS for Funds Transfer ICD details
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
      *
      ** Externally described DS for Retail ICD details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SLCD          E                     EXTFLD(LCD)
      *
      ** Externally described DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Externally described DS for Branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** Externally described DS for FONTIS details
     D SDFONT        E DS                  EXTNAME(SDFONTPD)
      *
      ** Externally described DS for Account details
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(IF)
      *
      ** Externally described DS for Nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D  QQACC2       E                     EXTFLD(QQACCD)                                     CGL029
      *
      ** External DS for Profit Centres
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)
      *
      ** Externally described DS trading ICD data
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  QQACC3       E                     EXTFLD(QQACCD)                                     CGL029
      *
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
     D RegData       E DS                  EXTNAME(FTIPRXPD)                                  CER001
     D CrDlFilFmt    E DS                  EXTNAME(FTIPX1PD)                                  CER001
     D  INPREF1      E                     EXTFLD(INPREF)                                     CER001
     D NwDlFilFmt    E DS                  EXTNAME(FTVIPLX1PD)                                CER001
                                                                                              CSC011
      ** 24X7 Status DataArea Layout                                                          CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
     D  WPRDTE                 5      9  0                                                    CSC011
                                                                                              CSC011
      ** SD Status DataArea Layout                                                            CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SCCMTJOB DataArea Layout                                                             CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WDSJobs                4    103A                                                      CSC022
      **                                                                                      CSC022
      *
      ** FT Control Data
     D PCNTRL          DS           256
     D  PGLUI                  4      4
     D  PVATT                  6      6
      *
      ** DS for VAT details
     D PVATDS          DS
     D  PVATR                 10     12P 4
      *
      ** DS for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10
     D  PDBRN                 11     13
     D  PDPPT                 14     16
      *
      ** DS for CASH details
     D***PCSHDTA         DS           512                                                     CGL029
     D***WDACACD               21     24  0                                                   CGL029
     D PCSHDTA         DS           522                                                       CGL029
     D  WDACACD              513    522  0                                                    CGL029
      *
      ** DS for next Incoming Payment Reference Number
     D WINPAY          DS             4
     D  WINSQ                  1      4  0
      *
      ** DS to split Message Reference when maintenance is called
      ** by linked maintenance/enquiry
     D WMsgRefDS       DS
     D  WRefMsg                1      8  0
     D  WRefPrt                9     11  0
      *
      **  DS for Date change
     D WWDT            DS             6
     D  WD1                    1      2
     D  WD2                    3      4
     D  WD3                    5      6
      *
      ** DS for Account key
     D***WACKYDS         DS            18                                                     CGL029
     D WACKYDS         DS            24                                                       CGL029
     D**KACNUM**               1      6  0                                                    CSD027
     D  KACNUM                 1      6                                                       CSD027
     D  KACCCY                 7      9
     D  KACCD                 10     19  0                                                    CGL029
     D  KACSQ                 20     21  0                                                    CGL029
     D  KBRCA                 22     24                                                       CGL029
     D***KACCD**               10     13  0                                                   CGL029
     D***KACSQ**               14     15  0                                                   CGL029
     D***KBRCA**               16     18                                                      CGL029
      *
      ** DS for IBANs full account
     D PIBANAcc        DS
     D**IBCNUM**               1      6  0                                                    CSD027
     D  IBCNUM                 1      6                                                       CSD027
     D  IBCCY                  7      9
     D  IBACOD                10     19  0                                                    CGL029
     D  IBACSQ                20     21  0                                                    CGL029
     D  IBBRCA                22     24                                                       CGL029
     D***IBACOD*               10     13  0                                                   CGL029
     D***IBACSQ*               14     15  0                                                   CGL029
     D***IBBRCA*               16     18                                                      CGL029
      *
      ** DS to format P53
     D                 DS
     D  WWP53                  1     35
     D  WWP53A                 1      1
     D  WWP53B                 2     35
      *
      ** DS to format P59
     D                 DS
     D  WWP59                  1     35
     D  WWP59A                 1      1
     D  WWP59B                 2     35
      *
      ** DS to format work variable of Beneficiary
     D                 DS
     D  WWBNC1                 1     35
     D  WWCUS1                 1      6
     D  WWACD1                 7     16                                                       CGL029
     D  WWSQN1                17     18                                                       CGL029
     D  WWBCH1                19     21                                                       CGL029
     D***WWACD1*                7     10                                                      CGL029
     D***WWSQN1*               11     12                                                      CGL029
     D***WWBCH1*               13     15                                                      CGL029
      *
      ** DS for obtaining Rate
     D WR1             DS
     D  WSR                    1     13
     D                                     DIM(13)
      *
      ** DS for obtaining Rate (SRRATE36)
     D WWR1            DS
     D  W@R1                   1     13
     D                                     DIM(13)
      *                                                                         CFT014
      ** Work array - Multiple lines of First Line of Pxx fields                CFT014
     D                 DS                                                       CFT014
     D  LFLT                   1    355    DIM(5)                                             237413
     D  BG1                    1     30                                                       237413
     D  TV1                   31     71                                                       237413
     D  BG2                   72    101                                                       237413
     D  TV2                  102    142                                                       237413
     D  BG3                  143    172                                                       237413
     D  TV3                  173    213                                                       237413
     D  BG4                  214    243                                                       237413
     D  TV4                  244    284                                                       237413
     D  BG5                  285    314                                                       237413
     D  TV5                  315    355                                                       237413
      *                                                                                       237413
     D**LFLT****               1    295    DIM(5)                                      CFT014 237413
     D**BG1*****               1     24                                                CFT014 237413
     D**TV1*****              25     59                                                CFT014 237413
     D**BG2*****              60     83                                                CFT014 237413
     D**TV2*****              84    118                                                CFT014 237413
     D**BG3*****             119    142                                                CFT014 237413
     D**TV3*****             143    177                                                CFT014 237413
     D**BG4*****             178    201                                                CFT014 237413
     D**TV4*****             202    236                                                CFT014 237413
     D**BG5*****             237    260                                                CFT014 237413
     D**TV5*****             261    295                                                CFT014 237413
      *                                                                         CFT014
      ** Data structure used for FT0010                                         CFT014
     D P#0010          DS           256                                         CFT014
     D  P#NDCY                 1      3                                         CFT014
     D  P#NDAM                 4     10P 0                                      CFT014
     D  P#DBCY                11     13                                         CFT014
     D  P#DBAM                14     20P 0                                      CFT014
     D  P#DBDT                21     23P 0                                      CFT014
     D  P#CRCY                24     26                                         CFT014
     D  P#CRAM                27     33P 0                                      CFT014
     D  P#PDCY                34     36                                         CFT014
     D  P#PDAM                37     43P 0                                      CFT014
     D  P#CRDT                44     46P 0                                      CFT014
     D  P#RATE                47     53P 8                                      CFT014
     D  P#MDIN                54     54  0                                      CFT014
     D  P#OVRT                55     55                                         CFT014
     D  P#SDIN                56     56                                         CFT014
     D  P#RTDS                57     59P 4                                      CFT014
      *                                                                         CFT014
     D  P#FRCY                11     13                                         CFT014
     D  P#FRAM                14     20P 0                                      CFT014
     D  P#FRDT                21     23P 0                                      CFT014
     D  P#TOCY                24     26                                         CFT014
     D  P#TOAM                27     33P 0                                      CFT014
     D  P#TODT                44     46P 0                                      CFT014
      *                                                                         CFT014
     D  P#PMSQ                60     69                                         CFT014
     D  P#INDC                70     74                                         CFT014
     D  P#RTCD                75     81                                         CFT014
     D  P#INTC                82     99  3                                      CFT014
     D  P#INTD               100    117  3                                      CFT014
      *
      ** Break down MIDAS equivalent
     D WRCDE2          DS
     D  WRCNUM                 1      6
     D  WRCYCD                 7      9
     D  WRACOD                10     19                                                       CGL029
     D  WRACSQ                20     21                                                       CGL029
     D  WRBRCD                22     24                                                       CGL029
     D  WRCDSQ                10     21                                                       CGL029
     D  WRCSB                 10     24                                                       CGL029
     D***WRACOD*               10     13                                                      CGL029
     D***WRACSQ*               14     15                                                      CGL029
     D***WRBRCD*               16     18                                                      CGL029
     D***WRCDSQ*               10     15                                                      CGL029
     D***WRCSB**               10     18                                                      CGL029
      *
      ** DS to hold G/L account number
     D WDSGLDG         DS
     D  WGLCST                 1      6
     D  WGLCCY                 7      9
     D  WGLACD                10     19                                                       CGL029
     D  WGLSQN                20     21                                                       CGL029
     D  WGLBCH                22     24                                                       CGL029
     D***WGLACD*               10     13                                                      CGL029
     D***WGLSQN*               14     15                                                      CGL029
     D***WGLBCH*               16     18                                                      CGL029
      *
      ** Output Data Structure for reformatted address
     D POADD           DS           175
     D  OADD1                  1     35
     D  OADD2                 36     70
     D  OADD3                 71    105
     D  OADD4                106    140
     D  OADD5                141    175
      *
      ** DS for Additional Info details
     D PAddInfm        DS           196
      *
      ** DS for Default Charge Amounts
     D*PCharges*       DS           108                                         CFT009
     D PCharges        DS           196                                         CFT009
      *
      ** DS for Default Charge Currencies
     D PChgCcy         DS            48
      *                                                                                       187056
      ** Calling parameter DS for FT0035                                                      187056
     D P0DTA           DS           256                                                       187056
     D  WIPT1                  1      1                                                       187056
     D  WIPTY1                 2     36                                                       187056
     D  WIPT2                 37     37                                                       187056
     D  WIPTY2                38     72                                                       187056
     D  WICCY                 73     75                                                       187056
     D  WOCUST                76     81                                                       187056
      *                                                                         CFT009
      ** Warning message work inds for charges screen                           CFT009
     D PChgWarn        DS            24                                         CFT009
     D  WFTF3176               1      1                                         CFT009
     D  WFTF3177               2      2                                         CFT009
     D  WFTF3178               3      3                                         CFT009
     D  WFTF3179               4      4                                         CFT009
     D  WFTF3202               5      5                                         CFT009
     D  WFTF3204               6      6                                         CFT009
     D  WFTF3182               7      7                                         CFT009
     D  WFTF3184               8      8                                         CFT009
     D  WFTF3185               9      9                                         CFT009
     D  WFTF3186              10     10                                         CFT009
     D  WFTF3187              11     11                                         CFT009
     D  WFTF3188              12     12                                         CFT009
     D  WFTF3158              13     13                                         CFT009
     D  WFTF3159              14     14                                         CFT009
     D  WFTF3160              15     15                                         CFT009
     D  WFTF3161              16     16                                         CFT009
     D  WFTF3203              17     17                                         CFT009
     D  WFTF3205              18     18                                         CFT009
     D  WFTF3164              19     19                                         CFT009
     D  WFTF3171              20     20                                         CFT009
     D  WFTF3172              21     21                                         CFT009
     D  WFTF3173              22     22                                         CFT009
     D  WFTF3174              23     23                                         CFT009
     D  WFTF3175              24     24                                         CFT009
      *                                                                         CFT014
     D**********       DS                                                             BUG4776 260326
      ******WIPREF*Work*field*Data*Structure***************************               BUG4776 260326
     D**WIPREF**               1     13                                               BUG4776 260326
     D**WPRNUM**               8     11  0                                            BUG4776 260326
      *****************************************************************               BUG4776 260326
     D W@CHK           C                   CONST('0123456789.')                 CFT014
     D/COPY WNCPYSRC,FTH00268
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error messages
     D IDx             S              3P 0
      *
      ** Index for arrays of warning messages
     D WIDx            S              3P 0
      *
      ** Work index
     D WIx             S              3P 0
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     D PMode           S              6A   INZ('*SIN  ')
      *
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous.
     D PResponse       S              1A   INZ('S')
      *
      ** Cursor position
     D PRowCol         S              4B 0
                                                                                              CSC011
      ** 24X7 Midas Availability switchable field                                             CSC011
     D CSC011          S              1A                                                      CSC011
                                                                                              CSC011
      ** Processing Date                                                                      CSC011
     D PPROCDTE        S              5  0                                                    CSC011
     D PPRDATE         S              6  0                                                    CSC011
     D PPRADATE        S              7                                                       CSC011
                                                                                              CSW209
      ** SWIFT 2009 flag                                                                      CSW209
     D CSW209          S              1A                                                      CSW209
                                                                                              CSD015
      ** Switchable features                                                                  CSD015
     D CSD015          S              1A                                                      CSD015
                                                                                              CSD015
      ** Compliance Watch switchable field                                                    CSD015
     D CCF001          S              1A                                                      CSD015
      ** CSC022 switchable field                                                              CSC022
     D CSC022          S              1A                                                      CSC022
      **                                                                                      CSC022
                                                                                              CGL029
      ** Account Code Parameters                                                              CGL029
     D PACCD           S             10A                                                      CGL029
     D PPACCD          S             10A                                                      CGL029
                                                                                              CGL029
      ** FTIPAY3DT CDRO Parameter                                                             CGL029
     D PPrvCDRO        S             18A                                                      CGL029
      ** CSC022 work fields                                                                   CSC022
     D WArrPtr         S              3S 0                                                    CSC022
     D WSkpComtRolbk   S              1A                                                      CSC022
                                                                                              CGL014
     D CGL014          S              1                                                       CGL014
     D WFIND           S              1A                                                      CER001
     D WWERR           S              1A                                                      CER001
     D #RTRN           S              7A                                                      CER001
     D SPAREW          S            256A                                                      CER001
     D #PGM            S             10A                                                      CER001
     D FKEY            S              2A                                                      CER001
     D ACTION          S              1A                                                      CER001
     D ULX043          S              1A                                                      CER001
     D WWINSQ          S              4  0                                                    CER001
     D WN2             S              2  0                                                    CER001
     D WA4             S              4                                                       CER001
     D WA2             S              2                                                       CER001
     D WA2A            S              2                                                       CER001
     D WA6             S              6                                                       CER001
     D IA              S              2  0                                                    CER001
     D WAlloc          S              1                                                       CER001
     D WAllPref        S              1                                                       CER001
                                                                                              CGL014
     D PRtty           S              5A                                                      CER030
     D PTtcd           S             10A                                                      CER030
     D CER030          S              1A                                                      CER030
     D CER031          S              1A                                                      CER030
     D CGL013          S              1A                                                      CER030
     D Wk              S              3P 0                                                    CER030
      *                                                                                       CER030
      ** CFT120 switchable field                                                              CFT120
      *                                                                                       CFT120
     D CFT120          S              1A                                                      CFT120
      *                                                                                       CFT120
     D PPrvCDRC        S              3A                                                    MD023247
      *                                                                                     MD023247
      /COPY WNCPYSRC,FTIPAYS015
      **                                                                                      CSC022
      *
      ** +--------------------------------------+
      ** ¦ /COPYs                               ¦
      ** ¦ ======                               ¦
      ** +--------------------------------------+
      *
      /COPY MECPYSRC,ME1100_ILE
      *
      /COPY QWINDSRC,FTIPAYDTA
     D DATALUX         DS          1024                                                       CER001
     D  #1FLD1                 1      6  0                                                    CER001
     D  PREF1                  7     21                                                       CER001
     D  #1FOTR                22     41                                                       CER001
     D  #1TMST                42     67Z                                                      CER001
     D  #1ACBT                68     68                                                       CER001
     D  #1ACBK                69     80                                                       CER001
     D  #1BNC1                81    115                                                       CER001
     D  #1PCCY               116    118                                                       CER001
     D  #1BNCT               119    119                                                       CER001
     D  #1SMAM               120    132P 0                                                    CER001
     D  #1RCRT               133    133                                                       CER001
     D  #1RCCO               134    143  0                                                    CER001
     D  #1SNTP               144    144                                                       CER001
     D  #1SND1               145    179                                                       CER001
     D CSC054          S              1A                                                      CSC054
      *                                                                                       CSC054
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,FTIPAYS002
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
      /COPY WNCPYSRC,FTIPAYS003
      *
      ** Read Next Browse Subfile record.
      *
     C     WScrn         IFEQ      'R'
     C                   EXSR      SRRdNBrw
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTIPAYS004
      *
      ** DO WHILE: Process Initial screen.
      *
     C     WScrn         DOWEQ     'I'
     C                   EXSR      SRScrn_I
     C                   ENDDO
      *
      /COPY WNCPYSRC,FTIPAYS005
      *
      ** DO WHILE: Process Level 1 screen.
      *
     C     WScrn         DOWEQ     'P'
     C                   EXSR      SRScrn_P
     C                   ENDDO
      *
      /COPY WNCPYSRC,FTIPAYS006
      *
      ** DO WHILE: Process Level 2 screen 1.
      *
     C     WScrn         DOWEQ     'S'
     C                   EXSR      SRScrn_S
     C/COPY WNCPYSRC,FTIPAYSC39
     C                   ENDDO
      *
      /COPY WNCPYSRC,FTIPAYS007
      *
      ** DO WHILE: Process Level 2 screen 2.
      *
     C     WScrn         DOWEQ     'C'
     C                   EXSR      SRScrn_C
     C                   ENDDO
      *                                                                         CFT014
      ** DO WHILE: Process Level 2 screen 3.                                    CFT014
      *                                                                         CFT014
     C     WScrn         DOWEQ     'D'                                          CFT014
     C                   EXSR      SRScrn_D                                     CFT014
     C/COPY WNCPYSRC,FTH00275
     C                   ENDDO                                                  CFT014
      *                                                                         CFT014
      ** DO WHILE: Process Margin information                                   CFT014
      *                                                                         CFT014
     C     WScrn         DOWEQ     'M'                                          CFT014
     C                   EXSR      SRScrn_M                                     CFT014
     C                   ENDDO                                                  CFT014
      *                                                                                       CSW209
      ** Display Cover Message if SWIFT 2009 is ON                                            CSW209
      *                                                                                       CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      *                                                                                       CSW209
      ** DO WHILE: Cover Message Screen 1                                                     CSW209
      *                                                                                       CSW209
     C     WScrn         DOWEQ     'N'                                                        CSW209
     C                   EXSR      SRScrn_N                                                   CSW209
     C                   ENDDO                                                                CSW209
      *                                                                                       CSW209
      ** DO WHILE: Cover Message Screen 2                                                     CSW209
      *                                                                                       CSW209
     C     WScrn         DOWEQ     'O'                                                        CSW209
     C                   EXSR      SRScrn_O                                                   CSW209
     C                   ENDDO                                                                CSW209
      *                                                                                       CSW209
     C                   ENDIF                                                                CSW209
      *
      /COPY WNCPYSRC,FTIPAYS008
      *
      ** Process Window screen.
      *
     C     WScrn         IFEQ      'W'
     C/COPY WNCPYSRC,FTH00269
     C                   EXSR      SRScrn_W
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTIPAYS009
      *
      ** Process Confirmation screen.
      *
     C     WScrn         IFEQ      'F'
     C                   EXSR      SRScrn_F
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTIPAYS010
      *
      ** Process Additional Information screen.
      *
     C     WScrn         IFEQ      'A'
     C                   EXSR      SRScrn_A
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTIPAYS011
      *
      ** Update files.
      *
     C     WScrn         IFEQ      'U'
     C                   EXSR      SRUpdate
      *                                                                                       204152
      * Reset First Time through Flag                                                         204152
     C                   EVAL      FirstTime = 'Y'                                            204152
      *                                                                                       204152
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTIPAYS012
      *                                                                                       CER001
     C                   IF        WScrn = 'L'                                                CER001
     C                   EXSR      SREXT                                                      CER001
     C                   ENDIF                                                                CER001
      *
      ** Terminate program.
      *
     C     WScrn         IFEQ      'T'
     C                   IF        ULX043 = 'Y'                                               CER001
     C                   CLOSE     FTIPX1L0                                                   CER001
     C                   ENDIF                                                                CER001
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      *
      /COPY WNCPYSRC,FTIPAYS013
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      * WINDOWI - Call window manager in insertion                    *                       CER001
      *****************************************************************                       CER001
     C     WINDOWI       BEGSR                                                                CER001
      *                                                                                       CER001
      ** Using Same Details but Call with 2Part validated                                     CER001
      *                                                                                       CER001
     C/COPY WNCPYSRC,FTIPAYMV2                                                                CER001
      *                                                                                       CER001
     C                   CALL      'WN0010'                                                   CER001
     C                   PARM      'FTIPAYSNL'   #PGM                                         CER001
     C                   PARM                    FKEY                                         CER001
     C                   PARM      DDACTN        ACTION                                       CER001
     C                   PARM                    DATA                                         CER001
     C                   PARM      *BLANKS       #RTRN                                        CER001
     C                   PARM                    SPAREW                                       CER001
      *                                                                                       CER001
     C                   SELECT                                                               CER001
      *                                                                                       CER001
      ** F3 - end program.                                                                    CER001
      *                                                                                       CER001
     C                   WHEN      #RTRN = 'Y2U9999'                                          CER001
     C                   EXSR      SREndP                                                     CER001
      *                                                                                       CER001
      ** F12 - cancel.  Display Level 2 screen 3                                              CER001
      *                                                                                       CER001
     C                   WHEN      #RTRN = 'USR0790'                                          CER001
     C                   EVAL      WScrn = 'D'                                                CER001
      *                                                                                       CER001
      ** Enter key was pressed.                                                               CER001
      *                                                                                       CER001
     C                   OTHER                                                                CER001
      *                                                                                       CER001
     C                   ENDSL                                                                CER001
      *                                                                                       CER001
     C     WINDI         ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * SREXT - Call FTIPAY2SN                                        *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
     C     SREXT         BEGSR                                                                CER001
      *                                                                                       CER001
      ** Using Same Details but Call with 2Part validated                                     CER001
      *                                                                                       CER001
      *                                                                                       CER001
      ** If Payment reference still blank when window is called                               CER001
      ** allocate payment reference                                                           CER001
      *                                                                                       CER001
     C                   EVAL      WAlloc = 'N'                                               CER001
     C                   EVAL      WAllPref = *BLANKS                                         CER001
      *                                                                                       CER001
      ** Action is Insert.                                                                    CER001
      *                                                                                       CER001
     C                   IF        DDACTN = 'I'                                               CER001
     C**********                   and IPPREF = *BLANKS                                CER001 247665
      *                                                                                       CER001
      ** Entry point is Level 1.                                                              CER001
      *                                                                                       CER001
     C                   IF        PParmLevel = '1'                                           CER001
      *                                                                                       CER001
      ** Update Incoming Payments data area with next                                         CER001
      ** Sequence Number.                                                                     CER001
      *                                                                                       CER001
     C                   IF        CFT151 = 'N'                                               CFT151
     C     *LOCK         IN        WINPAY                                                     CER001
     C                   Z-ADD     WINSQ         WWINSQ                                       CER001
     C                   ADD       1             WINSQ                                        CER001
     C                   OUT       WINPAY                                                     CER001
     C                   ELSE                                                                 CFT151
     C                   CALL      'FT000328'                                                 CFT151
     C                   PARM                    PRTCD                                        CFT151
     C                   PARM      'IN'          W@OTIN            2                          CFT151
     C                   PARM      'A'           WCALC             1                          CFT151
     C                   PARM      'Y'           WUPD              1                          CFT151
     C                   PARM                    WWINSQT           4                          CFT151
     C                   PARM                    WNEWSQ            4                          CFT151
     C                   END                                                                  CFT151
      *                                                                                       CER001
      ** Record Id.                                                                           CER001
      *                                                                                       CER001
     C                   EVAL      IPRECI = 'D'                                               CER001
      *                                                                                       CER001
      ** Payment Type.                                                                        CER001
      *                                                                                       CER001
     C                   EVAL      IPPYTP = 'IN'                                              CER001
      *                                                                                       CER001
      ** Original Entry Dates.                                                                CER001
      *                                                                                       CER001
     C                   Z-ADD     BJRDNB        PDayNo                                       CER001
      *                                                                                       CER001
     C                   CALLB     'ZDATE2'                                                   CER001
     C                   PARM                    PDayNo                                       CER001
     C                   PARM      BJDFIN        PFMT                                         CER001
     C                   PARM      *ZERO         PDate                                        CER001
     C                   PARM      *BLANKS       PADate                                       CER001
      *                                                                                       CER001
     C                   Z-ADD     BJRDNB        IPOEDT                                       CER001
     C                   Z-ADD     PDate         IPOEDTD1                                     CER001
      *                                                                                       CER001
     C                   MOVE      PDate         WN2                                          CER001
     C                   IF        WN2 < 72                                                   CER001
     C                   Z-ADD     20            IPOEDTD2                                     CER001
     C                   ELSE                                                                 CER001
     C                   Z-ADD     19            IPOEDTD2                                     CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   MOVEL     PDate         WA4                                          CER001
     C                   IF        BJDFIN <> 'M'                                              CER001
     C                   MOVEL     WA4           WA2                                          CER001
     C                   MOVE      WA4           WA2A                                         CER001
     C                   MOVEL     WA2A          WA4                                          CER001
     C                   MOVE      WA2           WA4                                          CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   MOVE      PDate         WA2                                          CER001
     C                   MOVEL     WA2           PDate                                        CER001
     C                   MOVE      WA4           PDate                                        CER001
     C                   Z-ADD     PDate         IPOEDTD3                                     CER001
      *                                                                                       CER001
      ** New Payment Reference.                                                               CER001
      *                                                                                       CER001
     C                   MOVE      PDate         WA6                                          CER001
     C                   IF        CFT151  = 'N'                                              CFT151
     C                   MOVE      WWINSQ        WA4                                          CER001
     C                   ELSE                                                                 CFT151
     C                   MOVE      WWINSQT       WA4                                          CFT151
     C                   END                                                                  CFT151
     C                   MOVE      'P'           WYA2(1)                                      CER001
     C                   MOVEA     WA6           WYA2(2)                                      CER001
     C                   MOVEA     WA4           WYA2(8)                                      CER001
     C                   MOVEA     IPPYTP        WYA2(12)                                     CER001
     C                   MOVEA     '00'          WYA2(14)                                     CER001
      *                                                                                       CER001
     C     1             DO        15            IA                                           CER001
     C                   IF        WYA2(IA) = ' '                                             CER001
     C                   MOVEL     '0'           WYA2(IA)                                     CER001
     C                   ENDIF                                                                CER001
     C                   ENDDO                                                                CER001
      *                                                                                       CER001
     C                   MOVEA     WYA2(1)       IPPREF                                       CER001
     C                   MOVEA     WYA2(1)       WPREFI                                       CER001
     C                   EVAL      WInsert = 'Y'                                              CER001
      *                                                                                       CER001
      ** Level 1 Valid Indicator.                                                             CER001
      *                                                                                       CER001
     C                   EVAL      IPINLVL1 = 'Y'                                             CER001
      *                                                                                       CER001
     C                   EVAL      WAlloc = 'Y'                                               CER001
     C                   MOVEA     WYA2(1)       WAllPref                                     CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Populate fields that will be required by the display program.                        CER001
      *                                                                                       CER001
     C                   IF        DDACTN <> 'I'                                              CER001
      *                                                                                       CER001
     C     DDPREF        CHAIN     RTVIDX                             85                      CER001
     C                   IF        *IN85 = *OFF                                               CER001
     C                   EVAL      INPREF1  = INPREF                                          CER001
     C                   EVAL      LLLXORTY = INORTY                                          CER001
     C                   EVAL      LLLXBETY = INBETY                                          CER001
     C                   EVAL      LLLXOPCO = INOPCO                                          CER001
     C                   EVAL      LLLXCOCO = INCOCO                                          CER001
     C                   EVAL      LLLXIDCO = INIDCO                                          CER001
     C                   EVAL      LLLXIDEN = INIDEN                                          CER001
     C                   ELSE                                                                 CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBKEY = DDPREF                                             CER001
     C                   EVAL      DBFILE = 'FTIPX1L0'                                        CER001
     C                   EVAL      DBASE = 042                                                CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      LLLXORTY = *BLANKS                                         CER001
     C                   EVAL      LLLXBETY = *BLANKS                                         CER001
     C                   EVAL      LLLXOPCO = *BLANKS                                         CER001
     C                   EVAL      LLLXCOCO = *BLANKS                                         CER001
     C                   EVAL      LLLXIDCO = *BLANKS                                         CER001
     C                   EVAL      LLLXIDEN = *BLANKS                                         CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Populate fields that will be required by the called programs.                        CER001
      ** This is the DATALUX.                                                                 CER001
      *                                                                                       CER001
     C                   MOVEL     IPPREF        PREF1                                        CER001
     C                   MOVEL     IPFRNT        #1FOTR                                       CER001
     C                   MOVEL     IPTMST        #1TMST                                       CER001
     C                   MOVEL     IPACBT        #1ACBT                                       CER001
     C                   MOVEL     IPACBK        #1ACBK                                       CER001
     C                   MOVEL     IPBNC1        #1BNC1                                       CER001
     C                   MOVEL     IPPCCY        #1PCCY                                       CER001
     C                   MOVEL     IPBNCT        #1BNCT                                       CER001
     C                   Z-ADD     IPSMAM        #1SMAM                                       CER001
     C                   MOVEL     IPRCRT        #1RCRT                                       CER001
     C                   MOVEL     IPRCCO        #1RCCO                                       CER001
     C                   MOVEL     IPSNTP        #1SNTP                                       CER001
     C                   MOVEL     IPSND1        #1SND1                                       CER001
      *                                                                                       CER001
     C                   CALL      'FTIPAY2SN'                                                CER001
     C                   PARM      DDACTN        ACTION                                       CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM      *BLANKS       #RTRN                                        CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    NwDlFilFmt                                   CER001
      *                                                                                       CER001
     C                   SELECT                                                               CER001
      *                                                                                       CER001
      ** F3 - end program.                                                                    CER001
      *                                                                                       CER001
     C                   WHEN      #RTRN = 'Y2U9999'                                          CER001
     C                   EXSR      SREndP                                                     CER001
      *                                                                                       CER001
      ** F12 - cancel.  Display Level 2 screen 3                                              CER001
      *                                                                                       CER001
     C                   WHEN      #RTRN = 'USR0790'                                          CER001
     C                   EVAL      WScrn = 'D'                                                CER001
      *                                                                                       CER001
      ** Enter key was pressed.                                                               CER001
      *                                                                                       CER001
     C                   OTHER                                                                CER001
     C                   IF        DDACTN = 'E'                                               CER001
     C                   EVAL      WScrn = 'R'                                                CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      WScrn = 'F'                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDSL                                                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCWVAL - Retrieve FONTIS alphanumeric field identified by   *
      *            presence of codework /XXXX/                        *
      *                                                               *
      *****************************************************************
      *
     C     SRCWVAL       BEGSR
      *
      ** Inputs
      ** ------
      ** Code work lines
      **                                  WCWLIN
      ** Code work
      **                                  WCW
      ** Code work length
      **                                  WCWLEN
      ** Outputs
      ** -------
      *
      ** Reset temporary variables
     C                   MOVEL     *BLANK        W@CW
     C                   MOVEL     *BLANK        W@VL
     C                   MOVEL     *BLANK        WCWVAL          256
     C                   Z-ADD     0             WLn               2 0
     C                   Z-ADD     0             WVL               3 0
     C                   Z-ADD     0             WTagI             3 0
     C                   Z-ADD     0             WLnCW             3 0
      *
      ** Length of tag containing the code works
     C     ' '           CHECKR    WCWLIN        WLnCW
      *
      ** Length of search argument
     C     ' '           CHECKR    WCW           WLn

     C     WCW:WLn       SCAN      WCWLIN:1      WVL                      81
     C     *IN81         IFEQ      *ON
     C                   MOVEA     WCWLIN        W@CW
     C     WVL           ADD       WLn           WVL
      *
      ** We start to extract the value right after the code work
      ** (so we need to know the length of the code work)
      ** We stop extracting when
      ** - another / (and therefore another code work) has been found
      ** - we reached the length to extract
      ** - we reached the length of the tag
     C     WTagI         DOWLT     WCWLEN
     C     WVL           ANDLE     WLnCW
     C     W@CW(WVL)     ANDNE     '/'
     C                   ADD       1             WTagI
     C                   MOVEL     W@CW(WVL)     W@VL(WTagI)
     C                   ADD       1             WVL
     C                   ENDDO
     C                   MOVEA     W@VL          WCWVAL
     C                   ENDIF
      *
      ** Reset input variables
     C                   MOVEL     *BLANKS       WCWLIN
     C                   MOVEL     *BLANKS       WCW
     C                   Z-ADD     0             WCWLEN            3 0

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBIC1 - Level 1 BIC processing                              *
      *                                                               *
      *****************************************************************
      *
     C     SRBIC1        BEGSR
      *
      ** Determine whether cursor is on an allowed field
      *
     C                   Z-ADD     PRowCol       WKSCPS            5 0
      *
      ** Note: If these screen fields move then these values will
      **       need changing.
      *
      **       The value is cursor row number * 256 + column number
      *
      *
      ** Sender line 1
      *
     C                   MOVE      *OFF          LINE1S            1
     C*****WKSCPS        IFGE      2050                                         CFT014
     C*****WKSCPS        ANDLE     2084                                         CFT014
     C     WKSCPS        IFGE      1801                                         CFT014
     C     WKSCPS        ANDLE     1835                                         CFT014
     C                   MOVE      *ON           LINE1S
     C                   ENDIF
      *
      ** Sender line 2
      *
     C                   MOVE      *OFF          LINE2S            1
     C*****WKSCPS        IFGE      2093                                         CFT014
     C*****WKSCPS        ANDLE     2127                                         CFT014
     C     WKSCPS        IFGE      1837                                         CFT014
     C     WKSCPS        ANDLE     1871                                         CFT014
     C                   MOVE      *ON           LINE2S
     C                   ENDIF
      *
      ** Beneficiary line 1
      *
     C                   MOVE      *OFF          LINE1B            1
     C*****WKSCPS        IFGE      3117                                         CFT014
     C*****WKSCPS        ANDLE     3151                                         CFT014
     C     WKSCPS        IFGE      3373                                         CFT014
     C     WKSCPS        ANDLE     3407                                         CFT014
     C                   MOVE      *ON           LINE1B
     C                   ENDIF
      *
      ** Beneficiary line 2
      *
     C                   MOVE      *OFF          LINE2B            1
     C*****WKSCPS        IFGE      3330                                         CFT014
     C*****WKSCPS        ANDLE     3364                                         CFT014
     C     WKSCPS        IFGE      3593                                         CFT014
     C     WKSCPS        ANDLE     3627                                         CFT014
     C                   MOVE      *ON           LINE2B
     C                   ENDIF
      *                                                                         CFT014
      ** Receiver's Correspondent Line 1                                        CFT014
      *                                                                         CFT014
     C                   MOVE      *OFF          LINE1R            1            CFT014
     C     WKSCPS        IFGE      2349                                         CFT014
     C     WKSCPS        ANDLE     2383                                         CFT014
     C     CFT014        ANDEQ     'Y'                                          CFT014
     C                   MOVE      *ON           LINE1R                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Receiver's Correspondent Line 2                                        CFT014
      *                                                                         CFT014
     C                   MOVE      *OFF          LINE2R            1            CFT014
     C     WKSCPS        IFGE      2569                                         CFT014
     C     WKSCPS        ANDLE     2603                                         CFT014
     C     CFT014        ANDEQ     'Y'                                          CFT014
     C                   MOVE      *ON           LINE2R                         CFT014
     C                   ENDIF                                                  CFT014
      *
      ** If cursor is not on an allowed field, error
      *
     C     LINE1S        IFNE      *ON
     C     LINE2S        ANDNE     *ON
     C     LINE1B        ANDNE     *ON
     C     LINE2B        ANDNE     *ON
     C     LINE1R        ANDNE     *ON                                          CFT014
     C     LINE2R        ANDNE     *ON                                          CFT014

     C                   MOVE      '*ANY'        FldNameArr(1)
     C                   MOVEL     'FTM2625'     MsgIdArr(1)

     C                   ELSE
      *
      ** In-line prompt mode, capture search criteria from screen field
      *
     C     PINKD         IFEQ      *ON
     C                   MOVE      'P'           PIMODE

     C     LINE1S        IFEQ      *ON
     C                   MOVE      DDSND1        PICRIT
     C                   ENDIF

     C     LINE2S        IFEQ      *ON
     C                   MOVE      DDSND2        PICRIT
     C                   ENDIF

     C     LINE1B        IFEQ      *ON
     C                   MOVE      DDBNC1        PICRIT
     C                   ENDIF

     C     LINE2B        IFEQ      *ON
     C                   MOVE      DDBNC2        PICRIT
     C                   ENDIF
      *                                                                         CFT014
     C     LINE1R        IFEQ      *ON                                          CFT014
     C                   MOVE      DDRCO1        PICRIT                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C     LINE2R        IFEQ      *ON                                          CFT014
     C                   MOVE      DDRCO2        PICRIT                         CFT014
     C                   ENDIF                                                  CFT014

     C                   ENDIF
      *
      ** In-line search mode, capture search criteria from screen field
      *
     C     PINKQ         IFEQ      *ON
     C                   MOVE      'F'           PIMODE

     C     LINE1S        IFEQ      *ON
     C                   MOVE      DDSND1        PICRIT
     C                   ENDIF

     C     LINE2S        IFEQ      *ON
     C                   MOVE      DDSND2        PICRIT
     C                   ENDIF

     C     LINE1B        IFEQ      *ON
     C                   MOVE      DDBNC1        PICRIT
     C                   ENDIF

     C     LINE2B        IFEQ      *ON
     C                   MOVE      DDBNC2        PICRIT
     C                   ENDIF
      *                                                                         CFT014
     C     LINE1R        IFEQ      *ON                                          CFT014
     C                   MOVE      DDRCO1        PICRIT                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C     LINE2R        IFEQ      *ON                                          CFT014
     C                   MOVE      DDRCO2        PICRIT                         CFT014
     C                   ENDIF                                                  CFT014

     C                   ENDIF
      *
      ** Call BIC Plus enquiry program
      *
     C                   CALL      'FT0900'
     C                   PARM                    PIMODE            1
     C                   PARM                    PICRIT           35
     C                   PARM      *BLANKS       POADD           175
     C                   PARM      *BLANKS       POCHIP           10
     C                   PARM      *BLANKS       POUTCD            2
     C                   PARM      *BLANKS       PRTCD
     C                   MOVEL     *BLANKS       PICRIT
      *
      ** F3 pressed - exit program
      *
     C     PRTCD         IFEQ      'F3'
     C                   EXSR      SREndP
     C                   ENDIF

     C     PRTCD         IFEQ      *BLANKS
      *
      ** If a CHIPS code exists and relevant currency is USD, replace
      ** clearing code with CHIPS code
      *
     C     POCHIP        IFNE      *BLANKS
     C     POUTCD        ANDNE     'AC'
      *
     C     DDSMCY        IFEQ      BLUSCY
     C     LINE1S        ANDEQ     *ON
     C     DDSMCY        OREQ      BLUSCY                                       CFT014
     C     LINE1R        ANDEQ     *ON                                          CFT014
     C     DDPCCY        OREQ      BLUSCY
     C     LINE1B        ANDEQ     *ON
      *
      ** If clearing code is not present, move details down to
      ** create space for CHIPS code
      *
     C     POUTCD        IFNE      'BC'
     C     POUTCD        ANDNE     'DC'
     C                   MOVE      POADD         WKADD1          210
     C                   MOVEL     WKADD1        POADD
     C                   ENDIF

     C                   MOVEL     *BLANKS       WKCOCH           14
     C                   MOVEL     *BLANKS       OADD1
     C                   MOVEL     '//CH'        WKCOCH
     C                   MOVE      POCHIP        WKCOCH
     C                   MOVEL     WKCOCH        OADD1
     C                   ENDIF

     C                   ENDIF
      *
      ** If command key pressed on 2nd line, remove clearing
      ** code from details
      *
     C     LINE2S        IFEQ      *ON
     C     POUTCD        ANDEQ     'BC'
     C     LINE2S        OREQ      *ON
     C     POUTCD        ANDEQ     'DC'
     C     LINE2R        OREQ      *ON                                          CFT014
     C     POUTCD        ANDEQ     'BC'                                         CFT014
     C     LINE2R        OREQ      *ON                                          CFT014
     C     POUTCD        ANDEQ     'DC'                                         CFT014
     C     LINE2B        OREQ      *ON
     C     POUTCD        ANDEQ     'BC'
     C     LINE2B        OREQ      *ON
     C     POUTCD        ANDEQ     'DC'
     C     POUTCD        OREQ      'AC'
     C                   MOVE      POADD         WKADD2          140
     C                   MOVE      *BLANKS       POADD
     C                   MOVEL     WKADD2        POADD
     C                   ENDIF
      *
      ** Move details to screen
      *
     C     LINE1S        IFEQ      *ON
     C                   MOVEL     OADD1         DDSND1
     C                   MOVEL     OADD2         DDSND2
     C                   MOVEL     OADD3         DDSND3
     C                   MOVEL     OADD4         DDSND4
     C                   ENDIF
      *                                                                         CFT014
     C     LINE1R        IFEQ      *ON                                          CFT014
     C                   MOVEL     OADD1         DDRCO1                         CFT014
     C                   MOVEL     OADD2         DDRCO2                         CFT014
     C                   MOVEL     OADD3         DDRCO3                         CFT014
     C                   MOVEL     OADD4         DDRCO4                         CFT014
     C                   MOVEL     OADD5         DDRCO5                         CFT014
     C                   ENDIF                                                  CFT014

     C     LINE1B        IFEQ      *ON
     C                   MOVEL     OADD1         DDBNC1
     C                   MOVEL     OADD2         DDBNC2
     C                   MOVEL     OADD3         DDBNC3
     C                   MOVEL     OADD4         DDBNC4
     C                   MOVEL     OADD5         DDBNC5
     C                   ENDIF

     C     LINE2S        IFEQ      *ON
     C                   MOVEL     OADD1         DDSND2
     C                   MOVEL     OADD2         DDSND3
     C                   MOVEL     OADD3         DDSND4
     C                   ENDIF
      *                                                                         CFT014
     C     LINE2R        IFEQ      *ON                                          CFT014
     C                   MOVEL     OADD1         DDRCO2                         CFT014
     C                   MOVEL     OADD2         DDRCO3                         CFT014
     C                   MOVEL     OADD3         DDRCO4                         CFT014
     C                   MOVEL     OADD4         DDRCO5                         CFT014
     C                   ENDIF                                                  CFT014

     C     LINE2B        IFEQ      *ON
     C                   MOVEL     OADD1         DDBNC2
     C                   MOVEL     OADD2         DDBNC3
     C                   MOVEL     OADD3         DDBNC4
     C                   MOVEL     OADD4         DDBNC5
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBIC2 - Level 2 BIC processing                              *
      *                                                               *
      *****************************************************************
      *
     C     SRBIC2        BEGSR
      *
      ** Determine whether cursor is on an allowed field
      *
     C                   Z-ADD     PRowCol       WKSCPS
      *
      ** Note: If these screen fields move then these values will
      **       need changing.
      *
      **       The value is cursor row number * 256 + column number
      *
      ** Ordering institution line 1
      *
     C                   MOVE      *OFF          LIN1OI            1
     C     WScrn         IFEQ      'S'
     C     WKSCPS        ANDGE     1325
     C     WKSCPS        ANDLE     1359
     C                   MOVE      *ON           LIN1OI
     C                   ENDIF
      *
      ** Ordering institution line 2
      *
     C                   MOVE      *OFF          LIN2OI            1
     C     WScrn         IFEQ      'S'
     C     WKSCPS        ANDGE     1538
     C     WKSCPS        ANDLE     1572
     C                   MOVE      *ON           LIN2OI
     C                   ENDIF
      *
      ** Sender's correspondent line 1
      *
     C                   MOVE      *OFF          LIN1SC            1
     C     WScrn         IFEQ      'S'
     C     WKSCPS        ANDGE     2349
     C     WKSCPS        ANDLE     2383
     C                   MOVE      *ON           LIN1SC
     C                   ENDIF
      *
      ** Sender's correspondent line 2
      *
     C                   MOVE      *OFF          LIN2SC            1
     C     WScrn         IFEQ      'S'
     C     WKSCPS        ANDGE     2562
     C     WKSCPS        ANDLE     2596
     C                   MOVE      *ON           LIN2SC
     C                   ENDIF
      *
      ** Ordering Customer line 1
      *
     C                   MOVE      *OFF          LIN1OC            1
     C     WScrn         IFEQ      'S'
     C     WKSCPS        ANDGE     3373
     C     WKSCPS        ANDLE     3407
     C                   MOVE      *ON           LIN1OC
     C                   ENDIF
      *
      ** Ordering Customer line 2
      *
     C                   MOVE      *OFF          LIN2OC            1
     C     WScrn         IFEQ      'S'
     C     WKSCPS        ANDGE     3586
     C     WKSCPS        ANDLE     3620
     C                   MOVE      *ON           LIN2OC
     C                   ENDIF
      *
      ** Intermediary institution line 1
      *
     C                   MOVE      *OFF          LIN1II            1
     C     WScrn         IFEQ      'C'
     C*****WKSCPS        ANDGE     1069                                         CFT014
     C*****WKSCPS        ANDLE     1103                                         CFT014
     C     WKSCPS        ANDGE     1325                                         CFT014
     C     WKSCPS        ANDLE     1359                                         CFT014
     C                   MOVE      *ON           LIN1II
     C                   ENDIF
      *
      ** Intermediary institution line 2
      *
     C                   MOVE      *OFF          LIN2II            1
     C     WScrn         IFEQ      'C'
     C*****WKSCPS        ANDGE     1282                                         CFT014
     C*****WKSCPS        ANDLE     1316                                         CFT014
     C     WKSCPS        ANDGE     1538                                         CFT014
     C     WKSCPS        ANDLE     1572                                         CFT014
     C                   MOVE      *ON           LIN2II
     C                   ENDIF
      *
      ** If cursor is not on an allowed field, error
      *
     C     LIN1OI        IFNE      *ON
     C     LIN2OI        ANDNE     *ON
     C     LIN1SC        ANDNE     *ON
     C     LIN2SC        ANDNE     *ON
     C     LIN1OC        ANDNE     *ON
     C     LIN2OC        ANDNE     *ON
     C     LIN1II        ANDNE     *ON
     C     LIN2II        ANDNE     *ON

     C                   MOVE      '*ANY'        FldNameArr(1)
     C                   MOVEL     'FTM2613'     MsgIdArr(1)

     C                   ELSE
      *
      ** F4 and F16 are not allowed in Enquiry (and delete) mode
     C     DDACTN        IFEQ      'E'

     C                   MOVE      '*ANY'        FldNameArr(1)
     C                   MOVEL     'FTM2619'     MsgIdArr(1)

     C                   ELSE
      ** check indicators
      *
      ** In-line prompt or search mode, capture criteria from screen
      *
     C                   IF        PINKD = *ON OR PINKQ = *ON

     C     LIN1OI        IFEQ      *ON
     C                   MOVE      DDOBK1        PICRIT
     C                   ENDIF

     C     LIN2OI        IFEQ      *ON
     C                   MOVE      DDOBK2        PICRIT
     C                   ENDIF

     C     LIN1SC        IFEQ      *ON
     C                   MOVE      DDSNC1        PICRIT
     C                   ENDIF

     C     LIN2SC        IFEQ      *ON
     C                   MOVE      DDSNC2        PICRIT
     C                   ENDIF

     C     LIN1OC        IFEQ      *ON
     C                   MOVE      DDORC1        PICRIT
     C                   ENDIF

     C     LIN2OC        IFEQ      *ON
     C                   MOVE      DDORC2        PICRIT
     C                   ENDIF

     C     LIN1II        IFEQ      *ON
     C                   MOVE      DDINB1        PICRIT
     C                   ENDIF

     C     LIN2II        IFEQ      *ON
     C                   MOVE      DDINB2        PICRIT
     C                   ENDIF
      *
      ** In-line prompt mode
      *
     C                   IF        PINKD = *ON
     C                   MOVE      'P'           PIMODE
     C                   ENDIF
      *
      ** In-line search mode
      *
     C                   IF        PINKQ = *ON
     C                   MOVE      'F'           PIMODE
     C                   ENDIF

     C                   ENDIF
      *
      ** Call BIC Plus enquiry program
      *
     C                   CALL      'FT0900'
     C                   PARM                    PIMODE
     C                   PARM                    PICRIT
     C                   PARM      *BLANKS       POADD
     C                   PARM      *BLANKS       POCHIP
     C                   PARM      *BLANKS       POUTCD
     C                   PARM      *BLANKS       PRTCD
     C                   MOVEL     *BLANKS       PICRIT
      *
      ** F3 pressed - exit program
      *
     C     PRTCD         IFEQ      'F3'
     C                   EXSR      SREndP
     C                   END

     C     PRTCD         IFEQ      *BLANKS
      *
      ** If a CHIPS code exists and relevant currency is USD, replace
      ** clearing code with CHIPS code
      *
     C     POCHIP        IFNE      *BLANKS
     C     POUTCD        ANDNE     'AC'
      *
      ** Check payment currency against SDTRAD US dollar code
      *
     C     DDSMCY        IFEQ      BLUSCY
     C     LIN1OI        ANDEQ     *ON
     C     DDSMCY        OREQ      BLUSCY
     C     LIN1SC        ANDEQ     *ON
     C     DDSMCY        OREQ      BLUSCY
     C     LIN1OC        ANDEQ     *ON
     C     DDPCCY        OREQ      BLUSCY
     C     LIN1II        ANDEQ     *ON
      *
      ** If clearing code is not present, move details down to
      ** create space for CHIPS code
      *
     C     POUTCD        IFNE      'BC'
     C     POUTCD        ANDNE     'DC'
     C                   MOVE      POADD         WKADD1          210
     C                   MOVEL     WKADD1        POADD
     C                   ENDIF

     C                   MOVEL     *BLANKS       WKCOCH           14
     C                   MOVEL     '//CH'        WKCOCH
     C                   MOVE      POCHIP        WKCOCH
     C                   MOVEL     WKCOCH        OADD1
     C                   ENDIF

     C                   ENDIF
      *
      ** If command key pressed on 2nd line, remove clearing
      ** code from details
      *
     C     LIN2OI        IFEQ      *ON
     C     POUTCD        ANDEQ     'BC'
     C     LIN2OI        OREQ      *ON
     C     POUTCD        ANDEQ     'DC'
     C     LIN2SC        OREQ      *ON
     C     POUTCD        ANDEQ     'BC'
     C     LIN2SC        OREQ      *ON
     C     POUTCD        ANDEQ     'DC'
     C     LIN2OC        OREQ      *ON
     C     POUTCD        ANDEQ     'BC'
     C     LIN2OC        OREQ      *ON
     C     POUTCD        ANDEQ     'DC'
     C     LIN2II        OREQ      *ON
     C     POUTCD        ANDEQ     'BC'
     C     LIN2II        OREQ      *ON
     C     POUTCD        ANDEQ     'DC'
     C     POUTCD        OREQ      'AC'
     C                   MOVE      POADD         WKADD2          140
     C                   MOVE      *BLANKS       POADD
     C                   MOVEL     WKADD2        POADD
     C                   ENDIF
      *
      ** Move details to screen
      *
     C     LIN1OI        IFEQ      *ON
     C                   MOVEL     OADD1         DDOBK1
     C                   MOVEL     OADD2         DDOBK2
     C                   MOVEL     OADD3         DDOBK3
     C                   MOVEL     OADD4         DDOBK4
     C                   MOVEL     OADD5         DDOBK5
     C                   ENDIF

     C     LIN1SC        IFEQ      *ON
     C                   MOVEL     OADD1         DDSNC1
     C                   MOVEL     OADD2         DDSNC2
     C                   MOVEL     OADD3         DDSNC3
     C                   MOVEL     OADD4         DDSNC4
     C                   MOVEL     OADD5         DDSNC5
     C                   ENDIF

     C     LIN1OC        IFEQ      *ON
     C                   MOVEL     OADD1         DDORC1
     C                   MOVEL     OADD2         DDORC2
     C                   MOVEL     OADD3         DDORC3
     C                   MOVEL     OADD4         DDORC4
     C*****              MOVEL     OADD5         DDORC5                         CFT014
     C                   EVAL      DDORC5 = OADD5                                             CFT032
     C                   ENDIF

     C     LIN1II        IFEQ      *ON
     C                   MOVEL     OADD1         DDINB1
     C                   MOVEL     OADD2         DDINB2
     C                   MOVEL     OADD3         DDINB3
     C                   MOVEL     OADD4         DDINB4
     C                   MOVEL     OADD5         DDINB5
     C                   ENDIF

     C     LIN2OI        IFEQ      *ON
     C                   MOVEL     OADD1         DDOBK2
     C                   MOVEL     OADD2         DDOBK3
     C                   MOVEL     OADD3         DDOBK4
     C                   MOVEL     OADD4         DDOBK5
     C                   ENDIF

     C     LIN2SC        IFEQ      *ON
     C                   MOVEL     OADD1         DDSNC2
     C                   MOVEL     OADD2         DDSNC3
     C                   MOVEL     OADD3         DDSNC4
     C                   MOVEL     OADD4         DDSNC5
     C                   ENDIF

     C     LIN2OC        IFEQ      *ON
     C                   MOVEL     OADD1         DDORC2
     C                   MOVEL     OADD2         DDORC3
     C                   MOVEL     OADD3         DDORC4
     C*****              MOVEL     OADD4         DDORC5                         CFT014
     C                   EVAL      DDORC5 = OADD4                                             CFT032
     C                   ENDIF

     C     LIN2II        IFEQ      *ON
     C                   MOVEL     OADD1         DDINB2
     C                   MOVEL     OADD2         DDINB3
     C                   MOVEL     OADD3         DDINB4
     C                   MOVEL     OADD4         DDINB5
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrn_I - Process Initial Screen                            *
      *                                                               *
      *****************************************************************
      *
     C     SRScrn_I      BEGSR
     C/COPY WNCPYSRC,FTIPAYSC21
      *
      ** If Windows processing is on, clear any possible updates
      ** in Window function.
      *
     C     BGWDPR        IFEQ      'Y'
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
     C                   ENDIF
      *
      ** Incoming Payments Maintenance has been called by linked
      ** maintenance/enquiry.
      *
     C     PParmLink     IFEQ      'Y'
      *
      ** Protect screen fields.  Also, disable F7=Read Previous,
      ** F8=Read Next and F15=Browse.
      *
     C                   MOVEL     'N'           PEDTKEY
     C                   MOVEL     'N'           PEINKG
     C                   MOVEL     'N'           PEINKH
     C                   MOVEL     'N'           PEINKP
      *
      ** If Incoming Payments Maintenance has been called from a Subfile
      ** program, enable F18=Next Payment.
      *
     C     PLinkPgm      IFNE      'GL4442    '
     C     PLinkPgm      ANDNE     'GL0090    '
     C                   MOVEL     'Y'           PEINKS
     C                   ELSE
     C                   MOVEL     'N'           PEINKS
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVEL     'Y'           PEDTKEY
     C                   MOVEL     'Y'           PEINKG
     C                   MOVEL     'Y'           PEINKH
     C                   MOVEL     'Y'           PEINKP
     C                   MOVEL     'N'           PEINKS
      *
     C                   ENDIF
      *
      ** Display Initial screen.
      *
     C     PParmLevel    IFEQ      '1'
      *
      ** Entry is Level 1 Maintenance.
      *
     C                   CALLB     'FTIPAYIDP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** Payment Reference
     C                   PARM                    DDPREF
      *
      ** Booking Branch
     C                   PARM                    DDBRCA
      *
      ** SWIFT Reference
     C                   PARM                    DDSWTN           28
      *
      ** Sequence Number
     C                   PARM                    DDSEQNO           2
      *
      ** Enable Screen Fields
     C                   PARM                    PEDTKEY           1
      *
      ** Enable Function Keys
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KP = Command Key 15 = Browse
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
     C                   PARM                    PEINKG            1
     C                   PARM                    PEINKH            1
     C                   PARM                    PEINKP            1
     C                   PARM                    PEINKS            1
      *
      ** OK Action Code
     C                   PARM                    OKACTN
      *
      ** OK Payment Reference
     C                   PARM                    OKPREF
      *
      ** OK Branch Code
     C                   PARM                    OKBRCA
      *
      ** OK SWIFT Reference
     C                   PARM                    OKSWTN            1
      *
      ** OK Sequence Number
     C                   PARM                    OKSEQNO           1
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys Enabled
      ** KC = Command Key 03 = Exit
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
     C                   PARM                    PINKC
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKL
     C                   PARM                    PINKP
     C                   PARM                    PINKS
      *
     C                   ELSE
      *
      ** Entry is Level 2 Maintenance.
      *
     C                   CALLB     'FTIPAYSDP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** Payment Reference
     C                   PARM                    DDPREF
      *
      ** Enable Screen Fields
     C                   PARM                    PEDTKEY
      *
      ** Enable Function Keys
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KP = Command Key 15 = Browse
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKP
     C                   PARM                    PEINKS
      *
      ** OK Action Code
     C                   PARM                    OKACTN
      *
      ** OK Payment Reference
     C                   PARM                    OKPREF
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys Enabled
      ** KC = Command Key 03 = Exit
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
     C                   PARM                    PINKC
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKL
     C                   PARM                    PINKP
     C                   PARM                    PINKS
      *
     C                   ENDIF
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr
     C                   MOVEL     *BLANKS       WTRCT                                        226722
      *
     C                   SELECT
      *
      ** F3 - end program.
      *
     C     PINKC         WHENEQ    *ON
     C                   EXSR      SREndP
      *
      ** F7 - roll backwards.
      *
     C     PINKG         WHENEQ    *ON
     C                   EXSR      SRRoll
      *
      ** F8 - roll forwards.
      *
     C     PINKH         WHENEQ    *ON
     C                   EXSR      SRRoll
      *
      ** F12 - cancel.
      *
     C     PINKL         WHENEQ    *ON
      *
      ** If Incoming Payments Maintenance has been called by
      ** linked maintenance/enquiry, terminate program.
      *
     C     PParmLink     IFEQ      'Y'
      *
     C                   MOVEL     '5'           PParmRtcd
     C                   MOVEL     'T'           WScrn
      *
     C                   ELSE
      *
      ** Otherwise, display Initial screen with blank fields.
      ** Release all electronic messages that are reserved for
      ** this job and reset Read Next Browse Subfile Record
      ** indicator.
      *
     C     WEMSG         IFEQ      'Y'
     C                   EXSR      SRMsgEnd
     C                   ENDIF
      *
     C                   MOVEL     *BLANK        PRDNB
     C                   MOVEL     *BLANKS       DDACTN
     C                   MOVEL     *BLANKS       DDPREF
     C                   MOVEL     *BLANKS       DDSWTN
     C                   MOVEL     *BLANKS       DDSEQNO
     C                   MOVEL     *BLANKS       DDBRCA
     C                   MOVEL     'I'           WScrn
      *                                                                                       261468
      ** Call CL program to deallocate this reference to a dataarea                           261468
      *                                                                                       261468
     C                   EVAL      C#RTCD = *Blanks                                           261468
     C                   EVAL      @MODLE = 'FT'                                              261468
     C                   EVAL      @TREF  = *Blanks                                           261468
     C                   EVAL      @RTINF = *Blanks                                           261468
      *                                                                                       261468
     C                   CALL      'AOC8000'                                                  261468
     C                   PARM                    C#RTCD            7                          261468
     C                   PARM                    @MODLE            2                          261468
     C                   PARM                    @TREF            15                          261468
     C                   PARM                    @RTINF           80                          261468
      *                                                                                       261468
      ** Reduce PREF sequence number if it was incremented.                                   261468
      *                                                                                       261468
     C                   IF        FirstTime <> 'Y'                                           261468
      *                                                                                       261468
      ** Reduce Sequence number in DTAARA as number is not being used                         261468
      *                                                                                       261468
     C     *LOCK         IN        WINPAY                                                     261468
     C                   IF        CFT151 = 'N'                                               CFT151
      *                                                                                       261468
      ** Check to see if another pref has been generated by another                           261468
      ** function                                                                             261468
      *                                                                                       261468
     C                   Z-ADD     WWINSQ        svnum             4 0                        261468
     C                   EVAL      svnum = svnum + 1                                          261468
     C                   IF        svnum = WINSQ                                              261468
      *                                                                                       261468
      ** No new reference has been generated - so reduce sequence                             261468
      ** number on data area                                                                  261468
      *                                                                                       261468
     C                   SUB       1             WINSQ                                        261468
      *                                                                                       261468
      ** Ensure PREF is generated again if entering a new payment after                       261468
      ** cancel                                                                               261468
      *                                                                                       261468
     C                   EVAL      FirstTime = 'Y'                                            261468
     C                   ELSE                                                                 261468
      *                                                                                       261468
      ** If another number has been generated, the current payment                            261468
      ** reference only if the program is exited, otherwise the pref is                       261468
      ** re-used.                                                                             261468
      *                                                                                       261468
     C                   ENDIF                                                                261468
     C                   OUT       WINPAY                                                     261468
     C                   ELSE                                                                 CFT151
     C                   MOVE      WWINSQT       svalph            4                          CFT151
     C                   CALL      'FT000328'                                                 CFT151
     C                   PARM                    PRTCD                                        CFT151
     C                   PARM      'IN'          W@OTIN            2                          CFT151
     C                   PARM      'A'           WCALC                                        CFT151
     C                   PARM      'N'           WUPD              1                          CFT151
     C                   PARM                    svalph                                       CFT151
     C                   PARM                    WNEWSQ                                       CFT151
     C                   if        WNEWSQ = WINPAY                                            CFT151
     C                   CALL      'FT000328'                                                 CFT151
     C                   PARM                    PRTCD                                        CFT151
     C                   PARM      'IN'          W@OTIN            2                          CFT151
     C                   PARM      'S'           WCALC                                        CFT151
     C                   PARM      'Y'           WUPD                                         CFT151
     C                   PARM                    svalph                                       CFT151
     C                   PARM                    WNEWSQ                                       CFT151
     C                   ENDIF                                                                CFT151
     C                   ENDIF                                                                CFT151
      *                                                                                       261468
      ** Reset FirstTime field so new pref is generated if required.                          261468
      *                                                                                       261468
     C                   EVAL      FirstTime = 'Y'                                            261468
     C                   ENDIF                                                                261468
      *
     C                   ENDIF
      *
      ** F15 - build Browse.
      *
     C     PINKP         WHENEQ    *ON
     C                   EXSR      SRBldBrw
      *
      ** F18 - next Payment.  Read next subfile record in linked
      ** maintenance/enquiry.
      *
     C     PINKS         WHENEQ    *ON
     C                   MOVEL     '7'           PParmRtcd
     C                   MOVEL     'T'           WScrn
      *
      ** Enter key was pressed.  Validate input to Initial screen.
      *
     C                   OTHER
     C                   EXSR      SRVal_I
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVal_I - Validate input to Initial screen                   *
      *                                                               *
      *****************************************************************
      *
     C     SRVal_I       BEGSR
      *
      ** Validate key fields and retrieve Incoming Payment details.
      *
     C                   EXSR      SRRtvPref
      *
      ** If Incoming Payments Maintenance has been called from
      ** Account Movements Enquiry or from Account Postings
      ** Enquiry, and no record was read from Incoming Payments
      ** file, terminate program with error.
      *
     C     PLinkPgm      IFEQ      'GL4442    '
     C     RECI          ANDEQ     *BLANK
     C     PLinkPgm      OREQ      'GL0090    '
     C     RECI          ANDEQ     *BLANK
      *
     C                   MOVEL     'E'           PParmRtcd
     C                   MOVEL     'T'           WScrn
     C                   GOTO      EVal_I
      *
     C                   ENDIF
      *
      ** Move Incoming Payment details retrieved from the master
      ** database file into the update file record.  If no
      ** record has been retrieved (like in Insert), fields
      ** contain initial values.
      *
     C                   MOVEL     CrIPFilFmt    NwIPFilFmt
     C                   IF        (CFT003 = 'Y')                               CFT014
     C                             OR (CFT014 = 'Y')                            CFT014
     C                             OR CFT009 = 'Y'                              CFT009
     C                   MOVEL     CrIP2FilFmt   NwIP2FilFmt                    CFT014
     C                   ELSE                                                                BUG7101
     C                   CLEAR                   NwIP2FilFmt                                 BUG7101
     C                   ENDIF                                                  CFT014
      *
      ** If entry point is Level 1 Maintenance, validate non-key
      ** fields on Initial screen.
      *
     C     PParmLevel    IFEQ      '1'
      *
     C                   CALLB     'FTIPAYIVL'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Response Mode
     C                   PARM                    PResponse
      *
      ** SWIFT Reference
     C                   PARM                    DDSWTN
      *
      ** Sequence Number
     C                   PARM                    DDSEQNO
      *
      ** Booking Branch
     C                   PARM                    DDBRCA
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** OK Payment Reference
     C                   PARM                    OKPREF
      *
      ** Linked Program
     C                   PARM                    PLinkPgm
      *
      ** Incoming Payments retrieved from file - file format
     C                   PARM                    CrIPFilFmt
      *
      ** Incoming Payments extra data
     C                   PARM                    PExtData
     C/COPY WNCPYSRC,FTH00362
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDMMOD - Multibranch Indicator
     C                   PARM                    BGMBIN
      *
      ** ZMUSER - Default Branch
     C                   PARM                    PDBRN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
      *
      ** OK Action Code
     C                   PARM                    OKACTN
      *
      ** OK SWIFT Reference
     C                   PARM                    OKSWTN
      *
      ** OK Sequence No.
     C                   PARM                    OKSEQNO
      *
      ** OK Booking Branch
     C                   PARM                    OKBRCA
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
     C                   ENDIF
      *
      ** Errors occurred during retrieval of Incoming Payment details
      ** and in the validation of Initial screen fields.
      *
     C     IDx           IFNE      *ZERO
     C                   GOTO      EVal_I
     C                   ENDIF
      *
      ** Action Code is Insert and entry point is Level 1
      ** Maintenance.
      *
     C     DDACTN        IFEQ      'I'
     C     PParmLevel    ANDEQ     '1'
      *
      ** Initialise screen formats.
      *
     C                   EXSR      SRInScn
      *
      ** Load SWIFT details to the screen if SWIFT Reference has
      ** been entered or SWIFT Reference has been passed from
      ** linked maintenance/enquiry.
      *
     C     DDSWTN        IFNE      *BLANKS
     C     PParmPref     ORNE      *BLANKS
      *
     C     WNOCLEAR      IFNE      'Y'
     C                   MOVE      *BLANK        WEMSG             1
     C                   ENDIF
     C                   MOVE      ' '           WNOCLEAR
      *
     C                   EXSR      SREISwft
      *
      ** If there are errors in SWIFT validation, redisplay
      ** Initial screen, or terminate program if F3 has been
      ** pressed.
      *
     C     WEMSG         IFNE      'Y'
     C                   MOVEL     'I'           WScrn
     C                   GOTO      EVal_I
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Process Level 1 screen.
      *
     C                   MOVEL     'P'           WScrn
      *
      ** Else, Action is not Insert or entry point is Level 2.
      *
     C                   ELSE
      *
      ** Put Incoming Payment details on the screen.
      *
     C                   EXSR      SRPutRef
      *
      ** If entry point is Level 1 Maintenance, process Level 1
      ** screen.  Otherwise, process Level 2 screen 1.
      *
     C     PParmLevel    IFEQ      '1'
      *
     C                   MOVE      'P'           WScrn
      *
     C                   ELSE
      *
     C                   MOVE      'S'           WScrn
      *
      ** Set up Charges Branch.
      *
     C     BJSBRC        IFNE      *BLANKS
     C                   EVAL      PPYBR = BJSBRC
     C                   ELSE
     C     BKOBRU        IFEQ      'Y'
     C                   EVAL      PPYBR = IPORBR
     C                   ELSE
     C                   EVAL      PPYBR = IPBRCA
     C                   ENDIF
     C                   ENDIF
      *
      ** If Action is Insert, or Action is Amend and Level 2
      ** details have not been entered, default Transfer
      ** Commission Tariff based on Charges Branch.
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     INLVL2        ANDNE     'Y'
     C     PPYBR         CHAIN     PYCHGDB                            01
     C     *IN01         IFEQ      *OFF
     C                   EVAL      DDTRCT = PYDFTRCT
     C     WTRCT         IFNE      *BLANKS                                                    226722
     C                   EVAL      DDTRCT = WTRCT                                             226722
     C                   ENDIF                                                                226722
     C                   MOVEL     NwIP3ScnFmt   CrIP3ScnFmt
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     EVal_I        ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrn_P - Process Level 1 screen                            *
      *                                                               *
      *****************************************************************
      *
     C     SRScrn_P      BEGSR
      *
      ** Windows processing is on.
      *
     C     BGWDPR        IFEQ      'Y'
      *
      ** If Action Code and Payment Reference have changed,
      ** clear any possible updates in Window function.
      *
     C     DDACTN        IFNE      WDDACTN
     C     DDPREF        ORNE      WDDPREF
      **                                                                                      CSC022
      ** Execute rollback if SAR CSC022 is not enrolled or                                    CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        WSkpComtRolbk = 'N'                                        CSC022
     C                   Rolbk                                                                CSC022
     C                   Else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   ENDIF
      *
      ** Save Action Code and Payment Reference.
      *
     C                   MOVEL     DDACTN        WDDACTN           1
     C                   MOVEL     DDPREF        WDDPREF          15
      *
     C                   ENDIF
      *
      ** If Action Code is Insert or Amend, enable Detail
      ** fields on Level 1 screen (all fields on Level 1
      ** screen except Initial screen fields: Action Code,
      ** Payment Reference, SWIFT Reference, Sequence Number
      ** and Booking Branch).  Also, enable F5=Refresh.
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C                   MOVEL     'Y'           PEDTFLD
     C                   MOVEL     'Y'           PEINKE
     C                   ELSE
     C                   MOVEL     'N'           PEDTFLD
     C                   MOVEL     'N'           PEINKE
     C                   ENDIF
      *
      ** Incoming Payments Maintenance has been called by linked
      ** maintenance/enquiry.
      *
     C     PParmLink     IFEQ      'Y'
      *
      ** Disable F7=Read Previous, F8=Read Next and F15=Browse.
      *
     C                   MOVEL     'N'           PEINKG
     C                   MOVEL     'N'           PEINKH
     C                   MOVEL     'N'           PEINKP
      *
      ** If Incoming Payments Maintenance has been called from a Subfile
      ** program, enable F18=Next Payment.
      *
     C     PLinkPgm      IFNE      'GL4442    '
     C     PLinkPgm      ANDNE     'GL0090    '
     C                   MOVEL     'Y'           PEINKS
     C                   ELSE
     C                   MOVEL     'N'           PEINKS
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVEL     'Y'           PEINKG
     C                   MOVEL     'Y'           PEINKH
     C                   MOVEL     'Y'           PEINKP
     C                   MOVEL     'N'           PEINKS
      *
     C                   ENDIF
      *
      ** If Action is Delete, enable F10=Delete.
      *
     C     DDACTN        IFEQ      'D'
     C                   MOVE      'Y'           PEINKJ
     C                   ELSE
     C                   MOVE      'N'           PEINKJ
     C                   ENDIF
      *
      ** If Action is Enquire, enable F21=Additional Information.
      *
     C     DDACTN        IFEQ      'E'
     C                   MOVE      'Y'           PEINKV
     C                   ELSE
     C                   MOVE      'N'           PEINKV
     C                   ENDIF
      *
      ** If feature CFT007 is switched on and action is Insert or Amend,
      ** enable F4=Prompt and F16=Search
      *
     C                   IF        CFT007 = 'Y' AND
     C                             (DDACTN = 'I' OR DDACTN = 'A')
     C                   EVAL      PEINKD = 'Y'
     C                   EVAL      PEINKQ = 'Y'
     C                   ELSE
     C                   EVAL      PEINKD = 'N'
     C                   EVAL      PEINKQ = 'N'
     C                   ENDIF
      *
      ** Display Level 1 screen.
      *
     C                   CALLB     'FTIPAY1DP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 Scrn 1/2 details from incoming trans.          CFT014
      ** - screen format                                                        CFT014
     C                   PARM                    NwIP1aScnFmt                   CFT014
      *
      ** DS for Additional Information details
     C                   PARM                    PAddInfm
      *
      ** SWIFT Reference
     C                   PARM                    DDSWTN
      *
      ** Sequence No.
     C                   PARM                    DDSEQNO
      *
      ** Incoming Payment Status
     C                   PARM                    PStatus
      *
      ** Payment Type
     C                   PARM                    PPYTP
      *
      ** Display Additional Information Screen Indicator
     C                   PARM      'N'           PAddInfo          1
      *
      ** Enable Detail Fields Indicator
     C                   PARM                    PEDTFLD           1
      *
      ** Enable Function Keys
      ** KD = Command Key 04 = Prompt
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Delete
      ** KP = Command Key 15 = Browse
      ** KQ = Command Key 16 = Search
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
      ** KV = Command Key 21 = Additional Information Window
     C                   PARM                    PEINKD            1
     C                   PARM                    PEINKE            1
     C                   PARM                    PEINKG            1
     C                   PARM                    PEINKH            1
     C                   PARM                    PEINKJ            1
     C                   PARM                    PEINKP            1
     C                   PARM                    PEINKQ            1
     C                   PARM                    PEINKS            1
     C                   PARM                    PEINKV            1
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write Screen with No Read Indicator
     C                   PARM      'N'           PWriteOnly        1
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDGELR - Profit Centre Used
     C                   PARM                    BKPRCU
      *
      ** SDGELR - Originating Branch Used
     C                   PARM                    BKOBRU
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU FT Settlement Currency Conversion
     C                   PARM                    CEU006
      *
      ** BIC database plus
     C                   PARM                    CFT007
      *
      ** Electronic Banking Interface IATs and TPPs
     C                   PARM                    CGL009
      *                                                                         CFT014
      ** STP Phase 2 MT103 Messages Generation for FT.                          CFT014
     C                   PARM                    CFT014                         CFT014
     C/COPY WNCPYSRC,FTIPAYSC22
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
     C/COPY WNCPYSRC,FTIPAYSC04
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys Enabled
      ** KC = Command Key 03 = Exit
      ** KD = Command Key 04 = Prompt
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Delete
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
      ** KQ = Command Key 16 = Search
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
      ** KV = Command Key 21 = Additional Information Window
     C                   PARM                    PINKC             1
     C                   PARM                    PINKD             1
     C                   PARM                    PINKE             1
     C                   PARM                    PINKG             1
     C                   PARM                    PINKH             1
     C                   PARM                    PINKJ             1
     C                   PARM                    PINKL             1
     C                   PARM                    PINKP             1
     C                   PARM                    PINKQ             1
     C                   PARM                    PINKS             1
     C                   PARM                    PINKV             1
      *
      ** Cursor position
     C                   PARM                    PRowCol
     C/COPY WNCPYSRC,FTIPAYSC01
      *
      ** Save Warning Message Ids array of Level 1 screen.
      *
     C                   MOVEA     WMsgIDArr     WPrvWarnAr
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr

     C                   SELECT
      *
      ** F3 - end program.
      *
     C     PINKC         WHENEQ    *ON
     C                   EXSR      SREndP
      *
      ** F4 or F16 - BIC processing
      *
     C     PINKD         WHENEQ    *ON
     C     PINKQ         OREQ      *ON
     C                   EXSR      SRBIC1
      *
      ** F5 - refresh Level 1 screen.
      *
     C     PINKE         WHENEQ    *ON
     C                   MOVEL     CrIP1ScnFmt   NwIP1ScnFmt
     C                   MOVEL     CrIP1AScnFmt  NwIP1AScnFmt                   CFT014
      *
      ** F7 - roll backwards.
      *
     C     PINKG         WHENEQ    *ON
      *                                                                                       261468
      ** Call CL program to deallocate this reference to a dataarea                           261468
      *                                                                                       261468
     C                   EVAL      C#RTCD = *Blanks                                           261468
     C                   EVAL      @MODLE = 'FT'                                              261468
     C                   EVAL      @TREF  = *Blanks                                           261468
     C                   EVAL      @RTINF = *Blanks                                           261468
      *                                                                                       261468
     C                   CALL      'AOC8000'                                                  261468
     C                   PARM                    C#RTCD            7                          261468
     C                   PARM                    @MODLE            2                          261468
     C                   PARM                    @TREF            15                          261468
     C                   PARM                    @RTINF           80                          261468
      *                                                                                       261468
      ** Reduce PREF sequence number if it was incremented.                                   261468
      *                                                                                       261468
     C                   IF        FirstTime <> 'Y'                                           261468
      *                                                                                       261468
      ** Reduce Sequence number in DTAARA as number is not being used                         261468
      *                                                                                       261468
     C     *LOCK         IN        WINPAY                                                     261468
     C                   IF        CFT151 = 'N'                                               CFT151
      *                                                                                       261468
      ** Check to see if another pref has been generated by another                           261468
      ** function                                                                             261468
      *                                                                                       261468
     C                   Z-ADD     WWINSQ        svnum             4 0                        261468
     C                   EVAL      svnum = svnum + 1                                          261468
     C                   IF        svnum = WINSQ                                              261468
      *                                                                                       261468
      ** No new reference has been generated - so reduce sequence                             261468
      ** number on data area                                                                  261468
      *                                                                                       261468
     C                   SUB       1             WINSQ                                        261468
      *                                                                                       261468
      ** Ensure PREF is generated again if entering a new payment after                       261468
      ** cancel                                                                               261468
      *                                                                                       261468
     C                   EVAL      FirstTime = 'Y'                                            261468
     C                   ELSE                                                                 261468
      *                                                                                       261468
      ** if another number has been generated, the current payment                            261468
      ** reference only if the program is exited, otherwise the pref is                       261468
      ** re-used.                                                                             261468
      *                                                                                       261468
     C                   ENDIF                                                                261468
     C                   OUT       WINPAY                                                     261468
     C                   else                                                                 CFT151
     C                   MOVE      WWINSQT       svalph            4                          CFT151
     C                   CALL      'FT000328'                                                 CFT151
     C                   PARM                    PRTCD                                        CFT151
     C                   PARM      'IN'          W@OTIN            2                          CFT151
     C                   PARM      'A'           WCALC                                        CFT151
     C                   PARM      'N'           WUPD              1                          CFT151
     C                   PARM                    svalph                                       CFT151
     C                   PARM                    WNEWSQ                                       CFT151
     C                   if        WNEWSQ = WINPAY                                            CFT151
     C                   CALL      'FT000328'                                                 CFT151
     C                   PARM                    PRTCD                                        CFT151
     C                   PARM      'IN'          W@OTIN            2                          CFT151
     C                   PARM      'S'           WCALC                                        CFT151
     C                   PARM      'Y'           WUPD                                         CFT151
     C                   PARM                    svalph                                       CFT151
     C                   PARM                    WNEWSQ                                       CFT151
     C                   ENDIF                                                                CFT151
     C                   ENDIF                                                                CFT151
      *                                                                                       261468
      ** Reset FirstTime field so new pref is generated if required.                          261468
      *                                                                                       261468
     C                   Eval      FirstTime = 'Y'                                            261468
     C                   ENDIF                                                                261468
      *                                                                                       261468
     C                   EXSR      SRRoll
      *
      ** F8 - roll forwards.
      *
     C     PINKH         WHENEQ    *ON
      *                                                                                       261468
      ** Call CL program to deallocate this reference to a dataarea                           261468
      *                                                                                       261468
     C                   EVAL      C#RTCD = *Blanks                                           261468
     C                   EVAL      @MODLE = 'FT'                                              261468
     C                   EVAL      @TREF  = *Blanks                                           261468
     C                   EVAL      @RTINF = *Blanks                                           261468
      *                                                                                       261468
     C                   CALL      'AOC8000'                                                  261468
     C                   PARM                    C#RTCD            7                          261468
     C                   PARM                    @MODLE            2                          261468
     C                   PARM                    @TREF            15                          261468
     C                   PARM                    @RTINF           80                          261468
      *                                                                                       261468
      ** Reduce PREF sequence number if it was incremented.                                   261468
      *                                                                                       261468
     C                   IF        FirstTime <> 'Y'                                           261468
      *                                                                                       261468
      ** Reduce Sequence number in DTAARA as number is not being used                         261468
      *                                                                                       261468
     C     *LOCK         IN        WINPAY                                                     261468
     C                   IF        CFT151 = 'N'                                               CFT151
      *                                                                                       261468
      ** Check to see if another pref has been generated by another                           261468
      ** function                                                                             261468
      *                                                                                       261468
     C                   z-add     WWINSQ        svnum             4 0                        261468
     C                   eval      svnum = svnum + 1                                          261468
     C                   if        svnum = WINSQ                                              261468
      *                                                                                       261468
      ** No new reference has been generated - so reduce sequence                             261468
      ** number on data area                                                                  261468
      *                                                                                       261468
     C                   SUB       1             WINSQ                                        261468
      *                                                                                       261468
      ** Ensure PREF is generated again if entering a new payment after                       261468
      ** cancel                                                                               261468
      *                                                                                       261468
     C                   eval      FirstTime = 'Y'                                            261468
     C                   else                                                                 261468
      *                                                                                       261468
      ** if another number has been generated, the current payment                            261468
      ** reference only if the program is exited, otherwise the pref is                       261468
      ** re-used.                                                                             261468
      *                                                                                       261468
     C                   endif                                                                261468
     C                   OUT       WINPAY                                                     261468
     C                   else                                                                 CFT151
     C                   MOVE      WWINSQT       svalph            4                          CFT151
     C                   CALL      'FT000328'                                                 CFT151
     C                   PARM                    PRTCD                                        CFT151
     C                   PARM      'IN'          W@OTIN            2                          CFT151
     C                   PARM      'A'           WCALC                                        CFT151
     C                   PARM      'N'           WUPD              1                          CFT151
     C                   PARM                    svalph                                       CFT151
     C                   PARM                    WNEWSQ                                       CFT151
     C                   if        WNEWSQ = WINPAY                                            CFT151
     C                   CALL      'FT000328'                                                 CFT151
     C                   PARM                    PRTCD                                        CFT151
     C                   PARM      'IN'          W@OTIN            2                          CFT151
     C                   PARM      'S'           WCALC                                        CFT151
     C                   PARM      'Y'           WUPD                                         CFT151
     C                   PARM                    svalph                                       CFT151
     C                   PARM                    WNEWSQ                                       CFT151
     C                   ENDIF                                                                CFT151
     C                   endif                                                                CFT151
      *                                                                                       261468
      ** Reset FirstTime field so new pref is generated if required.                          261468
      *                                                                                       261468
     C                   Eval      FirstTime = 'Y'                                            261468
     C                   ENDIF                                                                261468
      *                                                                                       261468
     C                   EXSR      SRRoll
      *
      ** F10 - delete record.  Proceed to update of files.
      *
     C     PINKJ         WHENEQ    *ON
     C                   MOVEL     'U'           WScrn
      *
      ** F12 - cancel.
      *
     C     PINKL         WHENEQ    *ON
      *
      ** If Incoming Payments Maintenance has been called by
      ** linked maintenance/enquiry, terminate program.
      *
     C     PParmLink     IFEQ      'Y'
      *
     C                   MOVEL     '5'           PParmRtcd
     C                   MOVEL     'T'           WScrn
      *
     C                   ELSE
      *
      ** Otherwise, display Initial screen with blank fields.
      ** Release all electronic messages that are reserved for
      ** this job and reset Read Next Browse Subfile Record
      ** indicator.
      *
     C     WEMSG         IFEQ      'Y'
     C                   EXSR      SRMsgEnd
     C                   ENDIF
      *
     C                   MOVEL     *BLANK        PRDNB
     C                   MOVEL     *BLANKS       DDACTN
     C                   MOVEL     *BLANKS       DDPREF
     C                   MOVEL     *BLANKS       DDSWTN
     C                   MOVEL     *BLANKS       DDSEQNO
     C                   MOVEL     *BLANKS       DDBRCA
     C                   MOVEL     'I'           WScrn
      *
      * Reduce PREF sequence number if it was incremented.                                    209067
     C                   IF        FirstTime <> 'Y'                                           209067
      * Reduce Sequence number in DTAARA as number is not being used                          209067
     C     *LOCK         IN        WINPAY                                                     209067
     C                   IF        CFT151 = 'N'                                               CFT151
      *                                                                                       209067
      * Check to see if another pref has been generated by another function                   209067
      *                                                                                       209067
     C                   z-add     WWINSQ        svnum             4 0                        209067
     C                   eval      svnum = svnum + 1                                          209067
     C**********         if        svnum = WINSQ                                      209067 BUG4776
     C*****SVNUM         IFLE      WINSQ                                              BUG4776 260326
     C                   if        svnum = WINSQ                                              260326
      * No new reference has been generated - so reduce sequence number on data area          209067
     C**********         SUB       1             WINSQ                                209067 BUG4776
     C**********         EVAL      WINSQ = WWINSQ                                     BUG4776 260326
     C                   SUB       1             WINSQ                                        260326
      * Ensure PREF is generated again if entering a new payment after cancel                 209067
     C                   eval      FirstTime = 'Y'                                            209067
     C**********         else                                                         209067 BUG4776
     C                   else                                                                 260326
      * if another number has been generated, the current payment reference                   209067
      *  only if the program is exited, otherwise the pref is re-used.                        209067
     C                   endif                                                                209067
     C                   OUT       WINPAY                                                     209067
     C                   else                                                                 CFT151
     C                   MOVE      WWINSQT       svalph            4                          CFT151
     C                   CALL      'FT000328'                                                 CFT151
     C                   PARM                    PRTCD                                        CFT151
     C                   PARM      'IN'          W@OTIN            2                          CFT151
     C                   PARM      'A'           WCALC                                        CFT151
     C                   PARM      'N'           WUPD              1                          CFT151
     C                   PARM                    svalph                                       CFT151
     C                   PARM                    WNEWSQ                                       CFT151
     C                   if        WNEWSQ = WINPAY                                            CFT151
     C                   CALL      'FT000328'                                                 CFT151
     C                   PARM                    PRTCD                                        CFT151
     C                   PARM      'IN'          W@OTIN            2                          CFT151
     C                   PARM      'S'           WCALC                                        CFT151
     C                   PARM      'Y'           WUPD                                         CFT151
     C                   PARM                    svalph                                       CFT151
     C                   PARM                    WNEWSQ                                       CFT151
     C                   ENDIF                                                                CFT151
     C                   endif                                                                CFT151
      * Reset FirstTime field so new pref is generated if required.                           209067
     C                   Eval      FirstTime = 'Y'                                            209067
     C                   ENDIF                                                                209067
      *                                                                                       209067
     C                   ENDIF
      *
      ** F15 - build Browse.
      *
     C     PINKP         WHENEQ    *ON
      *                                                                                       261468
      ** Call CL program to deallocate this reference to a dataarea                           261468
      *                                                                                       261468
     C                   EVAL      C#RTCD = *Blanks                                           261468
     C                   EVAL      @MODLE = 'FT'                                              261468
     C                   EVAL      @TREF  = *Blanks                                           261468
     C                   EVAL      @RTINF = *Blanks                                           261468
      *                                                                                       261468
     C                   CALL      'AOC8000'                                                  261468
     C                   PARM                    C#RTCD            7                          261468
     C                   PARM                    @MODLE            2                          261468
     C                   PARM                    @TREF            15                          261468
     C                   PARM                    @RTINF           80                          261468
      *                                                                                       261468
      ** Reduce PREF sequence number if it was incremented.                                   261468
      *                                                                                       261468
     C                   IF        FirstTime <> 'Y'                                           261468
      *                                                                                       261468
      ** Reduce Sequence number in DTAARA as number is not being used                         261468
      *                                                                                       261468
     C     *LOCK         IN        WINPAY                                                     261468
     C                   IF        CFT151 = 'N'                                               CFT151
      *                                                                                       261468
      ** Check to see if another pref has been generated by another                           261468
      ** function                                                                             261468
      *                                                                                       261468
     C                   z-add     WWINSQ        svnum             4 0                        261468
     C                   eval      svnum = svnum + 1                                          261468
     C                   if        svnum = WINSQ                                              261468
      *                                                                                       261468
      ** No new reference has been generated - so reduce sequence                             261468
      ** number on data area                                                                  261468
      *                                                                                       261468
     C                   SUB       1             WINSQ                                        261468
      *                                                                                       261468
      ** Ensure PREF is generated again if entering a new payment after                       261468
      ** cancel                                                                               261468
      *                                                                                       261468
     C                   eval      FirstTime = 'Y'                                            261468
     C                   else                                                                 261468
      *                                                                                       261468
      ** if another number has been generated, the current payment                            261468
      ** reference only if the program is exited, otherwise the pref                          261468
      ** is re-used.                                                                          261468
      *                                                                                       261468
     C                   endif                                                                261468
     C                   OUT       WINPAY                                                     261468
     C                   else                                                                 CFT151
     C                   MOVE      WWINSQT       svalph            4                          CFT151
     C                   CALL      'FT000328'                                                 CFT151
     C                   PARM                    PRTCD                                        CFT151
     C                   PARM      'IN'          W@OTIN            2                          CFT151
     C                   PARM      'A'           WCALC                                        CFT151
     C                   PARM      'N'           WUPD              1                          CFT151
     C                   PARM                    svalph                                       CFT151
     C                   PARM                    WNEWSQ                                       CFT151
     C                   if        WNEWSQ = WINPAY                                            CFT151
     C                   CALL      'FT000328'                                                 CFT151
     C                   PARM                    PRTCD                                        CFT151
     C                   PARM      'IN'          W@OTIN            2                          CFT151
     C                   PARM      'S'           WCALC                                        CFT151
     C                   PARM      'Y'           WUPD                                         CFT151
     C                   PARM                    svalph                                       CFT151
     C                   PARM                    WNEWSQ                                       CFT151
     C                   ENDIF                                                                CFT151
     C                   endif                                                                CFT151
      *                                                                                       261468
      ** Reset FirstTime field so new pref is generated if required.                          261468
      *                                                                                       261468
     C                   Eval      FirstTime = 'Y'                                            261468
     C                   ENDIF                                                                261468
      *                                                                                       261468
     C                   EXSR      SRBldBrw
      *
      ** F18 - next Payment.  Read next subfile record in linked
      ** maintenance/enquiry.
      *
     C     PINKS         WHENEQ    *ON
     C                   MOVEL     '7'           PParmRtcd
     C                   MOVEL     'T'           WScrn
      *
      ** F21 - display Additional Information Window.
      *
     C     PINKV         WHENEQ    *ON
     C                   MOVEL     'A'           WScrn
      *
      ** Enter key was pressed.
      *
     C                   OTHER
      *
      ** If Action is Insert or Amend, validate input to
      ** Level 1 screen.
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C                   EXSR      SRVal_P
     C                   GOTO      EScrn_P
     C                   ENDIF
      *
      ** Action is Enquire.
      *
     C     DDACTN        IFEQ      'E'
      *
      ** Set up Charges Branch.
      *
     C     BJSBRC        IFNE      *BLANKS
     C                   EVAL      PPYBR = BJSBRC
     C                   ELSE
     C     BKOBRU        IFEQ      'Y'
     C                   EVAL      PPYBR = IPORBR
     C                   ELSE
     C                   EVAL      PPYBR = IPBRCA
     C                   ENDIF
     C                   ENDIF
      *
      ** If Windows processing is on, display Window screen.
      *
     C     BGWDPR        IFEQ      'Y'
     C                   MOVEL     'W'           WScrn
     C                   GOTO      EScrn_P
     C                   ENDIF
      *
      ** If Level 1 is linked with Level 2 or Incoming Payments
      ** Maintenance is called from linked maintenance/enquiry,
      ** display Level 2 screen 1.
      *
     C     BTLVJN        IFEQ      'Y'
     C     PParmLink     OREQ      'Y'
     C                   MOVEL     'S'           WScrn
     C                   GOTO      EScrn_P
     C                   ENDIF
      *
      ** Read Next Browse Subfile record.
      *
     C     PRDNB         IFEQ      'Y'
     C                   MOVEL     'R'           WScrn
     C                   GOTO      EScrn_P
     C                   ENDIF
      *
      ** Redisplay Initial screen with blank screen fields.
      *
     C                   MOVEL     *BLANKS       DDACTN
     C                   MOVEL     *BLANKS       DDPREF
     C                   MOVEL     *BLANKS       DDSWTN
     C                   MOVEL     *BLANKS       DDSEQNO
     C                   MOVEL     *BLANKS       DDBRCA
     C                   MOVEL     'I'           WScrn
      *
     C                   ENDIF
      *
     C                   ENDSL
      *
     C     EScrn_P       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVal_P - Validate input to Level 1 screen                   *
      *                                                               *
      *****************************************************************
      *
     C     SRVal_P       BEGSR
      *
      ** If Action is Amend, validate whether non-amendable fields
      ** have been amended.
      *
     C     DDACTN        IFEQ      'A'
      *
     C                   CALLB     'FTIPAYAMD'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ** Incoming Payments Lvl 1 Scrn details retrieved from file
      ** - screen format
     C                   PARM                    CrIP1ScnFmt
      *
      ** Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           PResetFld         1
      *
      ** STANDING DATA
      ** =============
      *
      ** SDMMOD - Multibranch Indicator
     C                   PARM                    BGMBIN
      *
      ** SDGELR - Profit Centre Used
     C                   PARM                    BKPRCU
      *
      ** SDGELR - Profit Centre Amendable
     C                   PARM                    BKPRCA
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** OK Amendments field
     C                   PARM                    PAmendOK          1
      *
     C                   ENDIF
      *
      ** Validate Detail fields on Level 1 screen.
      *
     C                   CALLB     'FTIPAY1VL'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Response Mode
     C                   PARM                    PResponse
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 Scrn 1/2 details from Incoming trans.          CFT014
     C                   PARM                    NwIP1aScnFmt                   CFT014
      *                                                                         CFT009
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction       CFT009
      ** - screen format                                                        CFT009
     C                   PARM                    NwIP5ScnFmt                    CFT009
      *                                                                         CFT014
      ** Third Reimbursement Institution (previous)                             CFT014
     C                   PARM                    PPrvTRI          34            CFT014
      *                                                                         CFT014
      ** Previous Instructed Amount                                             CFT014
     C                   PARM                    PPrvNDAM         14            CFT014
      *
      ** Base Currency No. of Decimal Places
     C                   PARM                    PBCDP
      *
      ** Payment Type
     C                   PARM                    PPYTP
      *
      ** Incoming Payments Lvl 1 Scrn details retrieved from file
      ** - screen format
     C                   PARM                    CrIP1ScnFmt
      *
      ** Incoming Payments extra data
     C                   PARM                    PExtData
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD
      *
      ** SDBANK - Midas Run Date
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    PPROCDTE                                     CSC011
      *
      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY
      *
      ** SDBANK - Location Code
     C                   PARM                    BJSLCD
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDBANK - Back Value Period in Days
     C                   PARM                    BJBVPD
      *
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN
      *
      ** SDGELR - Currency Code for Euro
     C                   PARM                    BKEURO
      *
      ** SDGELR - Profit Centre Default Used
     C                   PARM                    BKPCDU
      *
      ** SDGELR - Profit Centre Used
     C                   PARM                    BKPRCU
      *
      ** SDGELR - Originating Branch Used
     C                   PARM                    BKOBRU
      *
      ** SDGELR - Originating Branch/User Vald Req.
     C                   PARM                    BKOBUV
      *
      ** SDMMOD - Retail Banking
     C                   PARM                    BGRTBN
      *
      ** SDMMOD - Multibranch Indicator
     C                   PARM                    BGMBIN
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** SDMMOD - Dealing Foreign Exchange
     C                   PARM                    BGDLFX
      *
      ** SDMMOD - Dealing Money Market
     C                   PARM                    BGDLMM
      *
      ** SDRETL - Retail A/c Number Required?
     C                   PARM                    BMRANR
      *                                                                         CFT014
      ** SDFTFR - Level Join indicator                                          CFT014
     C                   PARM                    BTLVJN                         CFT014
      ** SDFTFR - Percent Rate Discrepancy                                      CFT014
     C                   PARM      BTPCRD        PBTPCRD           5 2          CFT014
      *                                                                         CFT014
      ** SDMMOD - Interest on Accrual                                           CFT014
     C                   PARM                    BGIOAC                         CFT014
      *
      ** ZMUSER - Department Code
     C                   PARM                    PDPPT
      *
      ** ZMUSER - User Id
     C                   PARM                    PUSRID
      *                                                                         CFT009
      ** SDFTFR - Charges Currency                                              CFT009
     C                   PARM                    BTCHCY                         CFT009
      *                                                                         CFT009
      ** SDFTFR - Fixed Charge Currency                                         CFT009
     C                   PARM                    FCHCCY                         CFT009
      *                                                                         CFT009
      ** SDFTFR - Charges calculated in transaction ccy                         CFT009
     C                   PARM                    CHTRCY                         CFT009
      *                                                                         CFT009
      ** VAT Rate                                                               CFT009
     C                   PARM                    PVATR                          CFT009
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU FT Settlement Currency Conversion
     C                   PARM                    CEU006
      *
      ** Electronic Banking Interface IATs and TPPs
     C                   PARM                    CGL009
      *
      ** IBAN numbers
     C                   PARM                    CFT004
      *                                                                         CFT014
      ** Straight Through processing Phase 2                                    CFT014
     C                   PARM                    CFT014                         CFT014
     C/COPY WNCPYSRC,FTIPAYSC23
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
     C                   PARM                    CFT010                         CFT009
      *                                                                         CFT009
      ** BLI FT Enhancements Feature                                            CFT009
     C                   PARM                    S01494                         CFT009
                                                                                              CGL014
      ** Collaterals Processing                                                               CGL014
                                                                                              CGL014
     C                   PARM                    CGL014                                       CGL014
     C/COPY WNCPYSRC,FTIPAYSC05
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *                                                                         CFT014
      ** Incoming Payments (additional details) for file update                 CFT014
     C                   PARM                    NwIP2FilFmt                    CFT014
      *
      ** Charges Branch
     C                   PARM                    PPYBR
      *
      ** Account with Bank's full account
     C**********         PARM                    PACBDS           18                          TDA006
     C                   PARM                    PACBDS           24                          TDA006
      *
      ** Sender's full account
     C**********         PARM                    PSNDDS           18                          TDA006
     C                   PARM                    PSNDDS           24                          TDA006
      *
      ** Receiver Correspondence's full account
     C**********         PARM                    PRCCDS           18                          TDA006
     C                   PARM                    PRCCDS           24                          TDA006
      *                                                                                       250600
      ** Third Reimbursemnt Party  full account                                               250600
     C                   PARM                    PTRBDS           24                          250600
      *
      ** Beneficiary's full account
     C**********         PARM                    PBNCDS           18                          TDA006
     C                   PARM                    PBNCDS           24                          TDA006
      *
      ** IBANs full account
     C                   PARM                    PIBANAcc
      *
      ** Settlement In Currency Indicator
     C                   PARM                    PSetInCy          1 0
      *
      ** Settlement EMU Transaction Period Start Date
     C                   PARM                    PSetTPSD          5 0
      *
      ** Payment In Currency Indicator
     C                   PARM                    PPayInCy          1 0
      *
      ** Payment EMU Transaction Period Start Date
     C                   PARM                    PPayTPSD          5 0
     C/COPY WNCPYSRC,FTIPAYSC24
      *                                                                         CFT009
      ** DS for Default Charge Amounts                                          CFT009
     C                   PARM                    PCharges                       CFT009
      *                                                                         CFT009
      ** Input Charge Currency                                                  CFT009
     C                   PARM                    PICCY                          CFT009
      *                                                                         CFT009
      ** Output Charge Currency                                                 CFT009
     C                   PARM                    POCCY                          CFT009
      *                                                                         CFT009
      ** Input Charge Currency No. of Decimal Places                            CFT009
     C                   PARM                    PINBDP                         CFT009
      *                                                                         CFT009
      ** Output Charge Currency No. of Decimal Places                           CFT009
     C                   PARM                    PONBDP                         CFT009
      *                                                                         CFT009
      ** Saved default charges                                                  CFT009
     C                   PARM                    DefValid                       CFT009
     C                   PARM                    DefValidX                      CFT009
     C                   PARM                    BENEDrBlck        1                        MD025111
     C                   PARM                    BENEDrRefd        1                       MD047369A
     C/COPY WNCPYSRC,FTIPAYSC11
      *
     C                   SELECT                                                               250600
     C                   WHEN      PTRBDS <> *BLANKS                                          250600
     C                   EVAL      PDBACT = PTRBDS                                            250600
     C                   WHEN      PRCCDS <> *BLANKS                                          250600
     C                   EVAL      PDBACT = PRCCDS                                            250600
     C                   WHEN      PSNDDS <> *BLANKS                                          250600
     C                   EVAL      PDBACT = PSNDDS                                            250600
     C                   ENDSL                                                                250600
      *                                                                                       250600
     C                   SELECT                                                               250600
     C                   WHEN      PACBDS <> *BLANKS                                          250600
     C                   EVAL      PCDACT = PACBDS                                            250600
     C                   WHEN      PBNCDS <> *BLANKS                                          250600
     C                   EVAL      PCDACT = PBNCDS                                            250600
     C                   ENDSL                                                                250600
      *                                                                         CFT014
      ** Save value of Third Reimbursement Institution and Instructed Amount.   CFT014
     C                   IF        CFT014 = 'Y'                                 CFT014
     C                   MOVE      DDTRIB        PPrvTRI                        CFT014
     C                   MOVE      DDNDAM        PPrvNDAM                       CFT014
     C                   ENDIF                                                  CFT014
      *
     C                   MOVEL     *BLANK        WRedisplay        1
      *
      ** If no errors occurred during validation of fields on Level 1
      ** screen, check if there are warnings which have not been
      ** displayed yet.
      *
     C                   IF        IDx = 0
      *
     C                   Z-ADD     1             WIx               3 0
      *
      * Force redisplay if details have changed                                               207211
     C     WIDx          IFNE      0                                                          207211
     C     NwIP1ScnFmt   ANDNE     PrvIP1ScnFmt                                               207211
     C                   EVAL      WRedisplay = 'Y'                                           207211
     C                   ENDIF                                                                207211
     C*                                                                                       207211
     C     WIx           DOWLE     WIDx
     C     WRedisplay    ANDEQ     *BLANK
     C                   IF        WMsgIdArr(WIx) <> WPrvWarnAr(WIx)
     C                   EVAL      WRedisplay = 'Y'
     C                   ELSE
     C                   MOVEL     *BLANKS       WMsgIdArr(WIx)                               216351
     C                   EVAL      WIx =WIx + 1
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Redisplay Level 1 screen if there are errors or if there
      ** are warnings which have not been displayed yet.
      *
     C                   IF        IDx <> 0 or
     C                             WRedisplay = 'Y'
     C                   MOVEL     NwIP1ScnFmt   PrvIP1ScnFmt                                 207211
     C                   GOTO      EVal_P
     C                   ENDIF
     C
      *                                                                                       237415
      ** Save values of Details of Charges, Receiver's Charges Remitted,                      237415
      ** Sender's Charges Currency and Sender's Charges                                       237415
      *                                                                                       237415
     C                   MOVEL     ODDDTCH       WDDTCH            3                          237415
     C                   MOVEL     ODDRCRM       WDRCRM           12                          237415
     C                   MOVEL     ODDSCC1       WDSCC1            3                          237415
     C                   MOVEL     ODDSCH1       WDSCH1           12                          237415
     C                   MOVEL     ODDSCC2       WDSCC2            3                          237415
     C                   MOVEL     ODDSCH2       WDSCH2           12                          237415
     C                   MOVEL     ODDSCC3       WDSCC3            3                          237415
     C                   MOVEL     ODDSCH3       WDSCH3           12                          237415
     C                   MOVEL     ODDSCC4       WDSCC4            3                          237415
     C                   MOVEL     ODDSCH4       WDSCH4           12                          237415
     C                   MOVEL     ODDSCC5       WDSCC5            3                          237415
     C                   MOVEL     ODDSCH5       WDSCH5           12                          237415
      *                                                                                       232151
      ** Clear any warning messages                                                           232151
      *                                                                                       232151
     C                   MOVE      *ALL'Y'       FTEIPY1                                      232151
     C                   MOVE      *ALL'Y'       FTEIPY2                                      232151
     C                   MOVEL     *BLANK        WFldNamArr                                   232151
     C                   MOVEL     *BLANK        WMsgIdArr                                    232151
     C                   MOVEL     *BLANK        WMsgDtaArr                                   232151
      *                                                                         CFT009
      ** If CFT009 is on and action code is insert, save defaulted              CFT009
      ** charges.                                                               CFT009
      *                                                                         CFT009
     C                   IF        CFT009 = 'Y' AND DDACTN = 'I'                CFT009
     C                   MOVEL     PCharges      WICharges                      CFT009
     C                   MOVEL     NwIP5ScnFmt   CrIP5ScnFmt                    CFT009
     C                   MOVEL     DDTRCD        WDTRCD                         CFT009
     C                   MOVEL     DDTXCD        WDTXCD                         CFT009
     C                   MOVEL     DDCQCD        WDCQCD                         CFT009
     C                   MOVEL     DDADCD        WDADCD                         CFT009
     C                   MOVEL     DDTLCD        WDTLCD                         CFT009
     C                   MOVEL     DDMSCD        WDMSCD                         CFT009
     C                   MOVEL     DDCHCD        WDCHCD                         CFT009
     C                   MOVEL     M1CD          WM1CD                          CFT009
     C                   MOVEL     M2CD          WM2CD                          CFT009
     C                   MOVEL     M3CD          WM3CD                          CFT009
     C                   MOVEL     M4CD          WM4CD                          CFT009
     C                   MOVEL     M5CD          WM5CD                          CFT009
      *                                                                                       237415
     C                   IF        PParmLink = 'Y' and CrIP5ScnFmt <> *Blanks                 237415
      *                                                                                       237415
     C                   IF        WDDTCH <> *Blanks                                          237415
     C                   MOVEL     WDDTCH        DDDTCH                                       237415
     C                   MOVEL     WDDTCH        ODDDTCH                                      237415
     C                   ENDIF                                                                237415
      *                                                                                       237415
     C                   IF        WDRCRM <> *Blanks                                          237415
     C                   MOVEL     WDRCRM        DDRCRM                                       237415
     C                   MOVEL     WDRCRM        ODDRCRM                                      237415
     C                   ENDIF                                                                237415
      *                                                                                       237415
     C                   IF        WDSCC1 <> *Blanks                                          237415
     C                   MOVEL     WDSCC1        DDSCC1                                       237415
     C                   MOVEL     WDSCC1        ODDSCC1                                      237415
     C                   ENDIF                                                                237415
      *                                                                                       237415
     C                   IF        WDSCH1 <> *Blanks                                          237415
     C                   MOVEL     WDSCH1        DDSCH1                                       237415
     C                   MOVEL     WDSCH1        ODDSCH1                                      237415
     C                   ENDIF                                                                237415
      *                                                                                       237415
     C                   IF        WDSCC2 <> *Blanks                                          237415
     C                   MOVEL     WDSCC2        DDSCC2                                       237415
     C                   MOVEL     WDSCC2        ODDSCC2                                      237415
     C                   ENDIF                                                                237415
      *                                                                                       237415
     C                   IF        WDSCH2 <> *Blanks                                          237415
     C                   MOVEL     WDSCH2        DDSCH2                                       237415
     C                   MOVEL     WDSCH2        ODDSCH2                                      237415
     C                   ENDIF                                                                237415
      *                                                                                       237415
     C                   IF        WDSCC3 <> *Blanks                                          237415
     C                   MOVEL     WDSCC3        DDSCC3                                       237415
     C                   MOVEL     WDSCC3        ODDSCC3                                      237415
     C                   ENDIF                                                                237415
      *                                                                                       237415
     C                   IF        WDSCH3 <> *Blanks                                          237415
     C                   MOVEL     WDSCH3        DDSCH3                                       237415
     C                   MOVEL     WDSCH3        ODDSCH3                                      237415
     C                   ENDIF                                                                237415
      *                                                                                       237415
     C                   IF        WDSCC4 <> *Blanks                                          237415
     C                   MOVEL     WDSCC4        DDSCC4                                       237415
     C                   MOVEL     WDSCC4        ODDSCC4                                      237415
     C                   ENDIF                                                                237415
      *                                                                                       237415
     C                   IF        WDSCH4 <> *Blanks                                          237415
     C                   MOVEL     WDSCH4        DDSCH4                                       237415
     C                   MOVEL     WDSCH4        ODDSCH4                                      237415
     C                   ENDIF                                                                237415
      *                                                                                       237415
     C                   IF        WDSCC5 <> *Blanks                                          237415
     C                   MOVEL     WDSCC5        DDSCC5                                       237415
     C                   MOVEL     WDSCC5        ODDSCC5                                      237415
     C                   ENDIF                                                                237415
      *                                                                                       237415
     C                   IF        WDSCH5 <> *Blanks                                          237415
     C                   MOVEL     WDSCH5        DDSCH5                                       237415
     C                   MOVEL     WDSCH5        ODDSCH5                                      237415
     C                   ENDIF                                                                237415
      *                                                                                       237415
     C                   ENDIF                                                                237415
      *                                                                                       237415
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
     C                   SELECT
      *
      ** If Windows processing is on, display Window screen.
      *
     C     BGWDPR        WHENEQ    'Y'
     C                   MOVEL     'W'           WScrn
      *
      ** If Level 1 is linked with Level 2 or Incoming Payments
      ** Maintenance is called from linked maintenance/enquiry,
      ** process Level 2 screen 1.
      *
     C     BTLVJN        WHENEQ    'Y'
     C     PParmLink     OREQ      'Y'
      *
     C                   MOVEL     'S'           WScrn
      *
      ** If Action is Insert, or Action is Amend and Level 2
      ** details have not been entered, default Transfer
      ** Commission Tariff based on Charges Branch.
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     INLVL2        ANDNE     'Y'
     C     PPYBR         CHAIN     PYCHGDB                            01
     C     *IN01         IFEQ      *OFF
     C                   EVAL      DDTRCT = PYDFTRCT
     C     WTRCT         IFNE      *BLANKS                                                    226722
     C                   EVAL      DDTRCT = WTRCT                                             226722
     C                   ENDIF                                                                226722
     C                   MOVEL     NwIP3ScnFmt   CrIP3ScnFmt
     C                   ENDIF
     C                   ENDIF
      *
      ** Compute Charges and Commissions, and Total VAT Amounts
      ** based on Level 1 details, and display Confirmation
      ** screen.
      *
     C                   OTHER
     C                   IF        CFT009 = 'N'                                 CFT009
     C                   EXSR      SRCCVatL1
     C                   ENDIF                                                  CFT009
     C                   MOVEL     'F'           WScrn
      *
     C                   ENDSL
      *
     C     EVal_P        ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrn_S - Process Level 2 screen 1                          *
      *                                                               *
      *****************************************************************
      *
     C     SRScrn_S      BEGSR
      *
      ** Entry point is Level 2 Maintenance and Windows processing
      ** is on.
      *
     C     PParmLevel    IFEQ      '2'
     C     BGWDPR        ANDEQ     'Y'
      *
      ** If Action Code and Payment Reference have changed,
      ** clear any possible updates in Window function.
      *
     C     DDACTN        IFNE      WDDACTN
     C     DDPREF        ORNE      WDDPREF
      **                                                                                      CSC022
      ** Execute rollback if SAR CSC022 is not enrolled or                                    CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        WSkpComtRolbk = 'N'                                        CSC022
     C                   Rolbk                                                                CSC022
     C                   Else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   ENDIF
      *
      ** Save Action Code and Payment Reference.
      *
     C                   MOVEL     DDACTN        WDDACTN
     C                   MOVEL     DDACTN        WDDPREF
      *
     C                   ENDIF
      *
      ** If Action Code is Insert or Amend, enable Detail
      ** fields on Level 2 screen 1 (all fields on Level 2
      ** screen 1 except Action Code and Payment Reference).
      ** Also, enable F5=Refresh.
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C                   MOVEL     'Y'           PEDTFLD
     C                   MOVEL     'Y'           PEINKE
     C                   ELSE
     C                   MOVEL     'N'           PEDTFLD
     C                   MOVEL     'N'           PEINKE
     C                   ENDIF
      *
      ** Incoming Payments Maintenance has been called by linked
      ** maintenance/enquiry.
      *
     C     PParmLink     IFEQ      'Y'
      *
      ** Disable F7=Read Previous, F8=Read Next and F15=Browse.
      *
     C                   MOVEL     'N'           PEINKG
     C                   MOVEL     'N'           PEINKH
     C                   MOVEL     'N'           PEINKP
      *
      ** If Incoming Payments Maintenance has been called from a Subfile
      ** program, enable F18=Next Payment.
      *
     C     PLinkPgm      IFNE      'GL4442    '
     C     PLinkPgm      ANDNE     'GL0090    '
     C                   MOVEL     'Y'           PEINKS
     C                   ELSE
     C                   MOVEL     'N'           PEINKS
     C                   ENDIF
      *
     C                   ELSE
      *
     C     PParmLevel    IFEQ      '1'                                                        261468
      *                                                                                       261468
     C                   MOVEL     'N'           PEINKG                                       261468
     C                   MOVEL     'N'           PEINKH                                       261468
     C                   MOVEL     'N'           PEINKP                                       261468
     C                   MOVEL     'N'           PEINKS                                       261468
      *                                                                                       261468
     C                   ELSE                                                                 261468
      *                                                                                       261468
     C                   MOVEL     'Y'           PEINKG
     C                   MOVEL     'Y'           PEINKH
     C                   MOVEL     'Y'           PEINKP
     C                   MOVEL     'N'           PEINKS
      *                                                                                       261468
     C                   ENDIF                                                                261468
      *
     C                   ENDIF
      *
      ** If feature CFT007 is switched on and action is Insert or Amend,
      ** enable F4=Prompt and F16=Search
      *
     C                   IF        CFT007 = 'Y' AND
     C                             (DDACTN = 'I' OR DDACTN = 'A')
     C                   EVAL      PEINKD = 'Y'
     C                   EVAL      PEINKQ = 'Y'
     C                   ELSE
     C                   EVAL      PEINKD = 'N'
     C                   EVAL      PEINKQ = 'N'
     C                   ENDIF
      *
      ** Display Level 2 screen 1.
      *
     C                   CALLB     'FTIPAY2DP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** Payment Reference
     C                   PARM                    DDPREF
      *
      ** Incoming Payments Lvl 2 Scrn 1/1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP2ScnFmt
      *
      ** Incoming Payments Lvl 2 Scrn 1/2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP3ScnFmt
      *
      ** Incoming Payment Status
     C                   PARM                    PStatus
      *
      ** Enable Detail Fields
     C                   PARM                    PEDTFLD
      *
      ** Enable Function Keys
      ** KD = Command Key 04 = Prompt
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KP = Command Key 15 = Browse
      ** KQ = Command Key 16 = Search
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
     C                   PARM                    PEINKD
     C                   PARM                    PEINKE
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKP
     C                   PARM                    PEINKQ
     C                   PARM                    PEINKS
      *
      ** Incoming Payments Lvl 2 Scrn 1 error indicators
     C                   PARM                    FTEIPY2
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write Screen with No Read Indicator
     C                   PARM      'N'           PWriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** BIC database plus
     C                   PARM                    CFT007
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys Enabled
      ** KC = Command Key 03 = Exit
      ** KD = Command Key 04 = Prompt
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
      ** KQ = Command Key 16 = Search
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
     C                   PARM                    PINKC
     C                   PARM                    PINKD
     C                   PARM                    PINKE
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKL
     C                   PARM                    PINKP
     C                   PARM                    PINKQ
     C                   PARM                    PINKS
      *
      ** Cursor position
     C                   PARM                    PRowCol
      *
      ** Save Warning Message Ids array of Level 2 screen 1.
      *
     C                   MOVEL     WMsgIDArr     WPrvWarnAr
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr

     C                   SELECT
      *
      ** F3 - end program.
      *
     C     PINKC         WHENEQ    *ON
     C                   EXSR      SREndP
      *
      ** F4 or F16 - BIC processing
      *
     C     PINKD         WHENEQ    *ON
     C     PINKQ         OREQ      *ON
     C                   EXSR      SRBIC2
      *
      ** F5 - refresh Level 2 screen 1.
      *
     C     PINKE         WHENEQ    *ON
     C                   MOVEL     CrIP2ScnFmt   NwIP2ScnFmt
     C                   MOVEL     CrIP3ScnFmt   NwIP3ScnFmt
      *
      ** F7 - roll backwards.
      *
     C     PINKG         WHENEQ    *ON
      *                                                                                       261468
      ** Call CL program to deallocate this reference to a dataarea                           261468
      *                                                                                       261468
     C     PParmLevel    IFEQ      '2'                                                        261468
      *                                                                                       261468
     C                   EVAL      C#RTCD = *Blanks                                           261468
     C                   EVAL      @MODLE = 'FT'                                              261468
     C                   EVAL      @TREF  = *Blanks                                           261468
     C                   EVAL      @RTINF = *Blanks                                           261468
      *                                                                                       261468
     C                   CALL      'AOC8000'                                                  261468
     C                   PARM                    C#RTCD            7                          261468
     C                   PARM                    @MODLE            2                          261468
     C                   PARM                    @TREF            15                          261468
     C                   PARM                    @RTINF           80                          261468
      *                                                                                       261468
     C                   MOVEL     *BLANKS       PRDNB                                        261468
     C                   MOVEL     *BLANKS       DDACTN                                       261468
     C                   MOVEL     *BLANKS       DDPREF                                       261468
     C                   MOVEL     *BLANKS       DDSWTN                                       261468
     C                   MOVEL     *BLANKS       DDSEQNO                                      261468
     C                   MOVEL     *BLANKS       DDBRCA                                       261468
      *                                                                                       261468
     C                   EXSR      SRRoll
      *                                                                                       261468
     C                   ENDIF                                                                261468
      *
      ** F8 - roll forwards.
      *
     C     PINKH         WHENEQ    *ON
      *                                                                                       261468
      ** Call CL program to deallocate this reference to a dataarea                           261468
      *                                                                                       261468
     C     PParmLevel    IFEQ      '2'                                                        261468
      *                                                                                       261468
     C                   EVAL      C#RTCD = *Blanks                                           261468
     C                   EVAL      @MODLE = 'FT'                                              261468
     C                   EVAL      @TREF  = *Blanks                                           261468
     C                   EVAL      @RTINF = *Blanks                                           261468
      *                                                                                       261468
     C                   CALL      'AOC8000'                                                  261468
     C                   PARM                    C#RTCD            7                          261468
     C                   PARM                    @MODLE            2                          261468
     C                   PARM                    @TREF            15                          261468
     C                   PARM                    @RTINF           80                          261468
      *                                                                                       261468
     C                   MOVEL     *BLANKS       PRDNB                                        261468
     C                   MOVEL     *BLANKS       DDACTN                                       261468
     C                   MOVEL     *BLANKS       DDPREF                                       261468
     C                   MOVEL     *BLANKS       DDSWTN                                       261468
     C                   MOVEL     *BLANKS       DDSEQNO                                      261468
     C                   MOVEL     *BLANKS       DDBRCA                                       261468
      *                                                                                       261468
     C                   EXSR      SRRoll
      *                                                                                       261468
     C                   ENDIF                                                                261468
      *
      ** F12 - cancel.
      *
     C     PINKL         WHENEQ    *ON
      *
      ** If entry point is Level 1, refresh Level 2 screen 1
      ** and redisplay Level 1 screen.
      *
     C     PParmLevel    IFEQ      '1'
      *
     C**********         MOVEL     CrIP2ScnFmt   NwIP2ScnFmt                                  226722
     C**********         MOVEL     CrIP3ScnFmt   NwIP3ScnFmt                                  226722
     C                   MOVEL     'P'           WScrn
      *
      ** Entry point is Level 2.
      *
     C                   ELSE
      *
      ** If Incoming Payments Maintenance has been called by
      ** linked maintenance/enquiry, terminate program.
      *
     C     PParmLink     IFEQ      'Y'
      *
     C                   MOVEL     '5'           PParmRtcd
     C                   MOVEL     'T'           WScrn
      *
     C                   ELSE
      *                                                                                       261468
      ** Call CL program to deallocate this reference to a dataarea                           261468
      *                                                                                       261468
     C                   EVAL      C#RTCD = *Blanks                                           261468
     C                   EVAL      @MODLE = 'FT'                                              261468
     C                   EVAL      @TREF  = *Blanks                                           261468
     C                   EVAL      @RTINF = *Blanks                                           261468
      *                                                                                       261468
     C                   CALL      'AOC8000'                                                  261468
     C                   PARM                    C#RTCD            7                          261468
     C                   PARM                    @MODLE            2                          261468
     C                   PARM                    @TREF            15                          261468
     C                   PARM                    @RTINF           80                          261468
      *
      ** Otherwise, display Initial screen with blank fields.
      ** Reset Read Next Browse Subfile Record indicator.
      *
     C                   MOVEL     *BLANK        PRDNB
     C                   MOVEL     *BLANKS       DDACTN
     C                   MOVEL     *BLANKS       DDPREF
     C                   MOVEL     *BLANKS       DDSWTN
     C                   MOVEL     *BLANKS       DDSEQNO
     C                   MOVEL     *BLANKS       DDBRCA
     C                   MOVEL     'I'           WScrn
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** F15 - build Browse.
      *
     C     PINKP         WHENEQ    *ON
      *                                                                                       261468
      ** Call CL program to deallocate this reference to a dataarea                           261468
      *                                                                                       261468
     C     PParmLevel    IFEQ      '2'                                                        261468
      *                                                                                       261468
     C                   EVAL      C#RTCD = *Blanks                                           261468
     C                   EVAL      @MODLE = 'FT'                                              261468
     C                   EVAL      @TREF  = *Blanks                                           261468
     C                   EVAL      @RTINF = *Blanks                                           261468
      *                                                                                       261468
     C                   CALL      'AOC8000'                                                  261468
     C                   PARM                    C#RTCD            7                          261468
     C                   PARM                    @MODLE            2                          261468
     C                   PARM                    @TREF            15                          261468
     C                   PARM                    @RTINF           80                          261468
      *                                                                                       261468
     C                   MOVEL     *BLANKS       PRDNB                                        261468
     C                   MOVEL     *BLANKS       DDACTN                                       261468
     C                   MOVEL     *BLANKS       DDPREF                                       261468
     C                   MOVEL     *BLANKS       DDSWTN                                       261468
     C                   MOVEL     *BLANKS       DDSEQNO                                      261468
     C                   MOVEL     *BLANKS       DDBRCA                                       261468
      *                                                                                       261468
     C                   EXSR      SRBldBrw
      *                                                                                       261468
     C                   ENDIF                                                                261468
      *
      ** F18 - next Payment.  Read next subfile record in linked
      ** maintenance/enquiry.
      *
     C     PINKS         WHENEQ    *ON
     C                   MOVEL     '7'           PParmRtcd
     C                   MOVEL     'T'           WScrn
      *
      ** Enter key was pressed.
      *
     C                   OTHER
      *
      ** If Action is Insert or Amend, validate input to
      ** Level 2 screen 1.
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
     C                   EXSR      SRVal_S
     C     WScrn         IFEQ      'C'                                                        226722
     C     DDTRCT        IFEQ      *BLANKS                                                    226722
     C     WTRCT         IFNE      *BLANKS                                                    226722
     C                   MOVE      WTRCT         DDTRCT                                       226722
     C                   ELSE                                                                 226722
     C                   MOVE      PYDFTRCT      DDTRCT                                       226722
     C                   ENDIF                                                                226722
     C                   ENDIF                                                                226722
     C                   ENDIF                                                                226722
      *
     C                   ELSE
      *
      ** If entry point is Level 2 and Windows processing is on,
      ** display Window screen.
      *
     C     PParmLevel    IFEQ      '2'
     C     BGWDPR        ANDEQ     'Y'
      *
     C                   MOVEL     'W'           WScrn
      *
     C                   ELSE
      *
      ***Compute*Charges*and*Commissions,*and*Total*VAT*Amounts*based*on        CFT014
      ***Level*1*details.**********************************************         CFT014
      *****************************************************************         CFT014
     C*****              EXSR      SRCCVatL1                                    CFT014
      *****************************************************************         CFT014
      ***Do*defaulting*of*Charges*and*Commission*details*on*Level*2****         CFT014
      ***screen*2.*****************************************************         CFT014
      *****************************************************************         CFT014
     C*****              EXSR      SRCDefault                                   CFT014
      *
      ** Display Level 2 Screen 2.
      *
     C                   MOVEL     'C'           WScrn
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVal_S - Validate input to Level 2 Screen 1                 *
      *                                                               *
      *****************************************************************
      *
     C     SRVal_S       BEGSR
      *
     C                   CALLB     'FTIPAY2VL'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Response Mode
     C                   PARM                    PResponse
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 Scrn format definition file 2                  CFT014
     C                   PARM                    NwIP1AScnFmt                   CFT014
      *
      ** Incoming Payments Lvl 2 Scrn 1/1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP2ScnFmt
      *
      ** Incoming Payments Lvl 2 Scrn 1/2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP3ScnFmt
      *
      ** Incoming Payments extra data
     C                   PARM                    PExtData
      *
      ** Charges Branch
     C                   PARM                    PPYBR             3
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD
      *
      ** SDBANK - Midas Run Date
     C**********         PARM                    BJRDNB                                       CSC011
     C                   PARM                    PPROCDTE                                     CSC011
      *
      ** SDBANK - Back Value Period in Days
     C                   PARM                    BJBVPD
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDMMOD - Multibranch Indicator
     C                   PARM                    BGMBIN            1
      *
      ** SDMMOD - Retail Banking
     C                   PARM                    BGRTBN            1
      *
      ** SDRETL - Retail A/c Number Required?
     C                   PARM                    BMRANR
      *                                                                         CFT014
      ** MT103 Messages Generation for FT                                       CFT014
     C                   PARM                    CFT014                         CFT014
      *                                                                                       250600
      ** Debit Account                                                                        250600
     C                   PARM                    PDBACT           24                          250600
      *                                                                                       250600
      ** Credit Account                                                                       250600
     C                   PARM                    PCDACT           24                          250600
      *                                                                                       250600
      ** Network                                                                              250600
     C                   PARM                    PNWRK                                        250600
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
      *
      ** Incoming Payments Lvl 2 Scrn 1 error indicators
     C                   PARM                    FTEIPY2
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
     C                   MOVEL     *BLANK        WRedisplay
      *
      ** If no errors occurred during validation of fields on Level 2
      ** screen 1, check if there are warnings which have not been
      ** displayed yet.
      *
     C                   IF        IDx = 0
      *
     C                   Z-ADD     1             WIx
      *
     C     WIx           DOWLE     WIDx
     C     WRedisplay    ANDEQ     *BLANK
     C                   IF        WMsgIdArr(WIx) <> WPrvWarnAr(WIx)
     C                   EVAL      WRedisplay = 'Y'
     C                   ELSE
     C                   EVAL      WIx =WIx + 1
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Redisplay Level 2 screen 1 if there are errors or if there
      ** are warnings which have not been displayed yet.
      *
     C                   IF        IDx <> 0 or
     C                             WRedisplay = 'Y'
     C                   GOTO      EVal_S
     C                   ENDIF
      *
      ** If entry is Level 2 and Windows processing in on,
      ** display Window screen.
      *
     C     PParmLevel    IFEQ      '2'
     C     BGWDPR        ANDEQ     'Y'
      *
     C                   MOVEL     'W'           WScrn
      *
     C                   ELSE
      *
      ***Compute*Charges*and*Commissions,*and*Total*VAT*Amounts*based*on        CFT014
      ***Level*1*details.**********************************************         CFT014
      *****************************************************************         CFT014
     C*****              EXSR      SRCCVatL1                                    CFT014
      *****************************************************************         CFT014
      ***Do*defaulting*of*Charges*and*Commission*details*on*Level*2****         CFT014
      ***screen*2.*****************************************************         CFT014
      *****************************************************************         CFT014
     C*****              EXSR      SRCDefault                                   CFT014
      *
     C     WIDx          IFNE      0                                                          195545
     C     Idx           ANDEQ     0                                                          195545
     C                   CLEAR                   WFldNamArr                                   195545
     C                   CLEAR                   WMsgIdArr                                    195545
     C                   CLEAR                   WMsgDtaArr                                   195545
     C                   CLEAR                   WIDx                                         195545
     C                   END                                                                  195545
      *                                                                                       195545
      ** Display Level 2 Screen 2.
      *
     C                   MOVEL     'C'           WScrn
      *
     C                   ENDIF
      *
     C     EVal_S        ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCCVatL1 - Compute Charges and Commissions, and Total VAT   *
      *              Amounts based on Level 1 Details                 *
      *                                                               *
      *****************************************************************
      *
     C     SRCCVatL1     BEGSR
      *
     C                   CALLB     'FTIPAY1CH'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ** Incoming Payments retrieved from file - file format
     C                   PARM                    CrIPFilFmt
      *                                                                         CFT014
      ** Incoming Payments (extension) retrieved from file - file fmt           CFT014
     C                   PARM                    CrIP2FilFmt                    CFT014
      *                                                                         CFT014
      ** Incoming Payments (extension) for file update - file format            CFT014
     C                   PARM                    NwIP2FilFmt                    CFT014
      *
      ** Charges Branch
     C                   PARM                    PPYBR
      *
      ** Base Currency No. of Decimal Places
     C                   PARM                    PBCDP
      *
      ** Local Currency No. of Decimal Places
     C                   PARM                    PLCDP
      *
      ** Local Currency Multiply/Divide Indicator
     C                   PARM                    PLMDIN
      *
      ** Local Currency Spot Rate
     C                   PARM                    PLSPOT
      *
      ** Entry Point
     C                   PARM                    PParmLevel
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD
      *
      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY
      *
      ** SDFTFR - Charges Currency
     C                   PARM                    BTCHCY
      *
      ** VAT Rate
     C                   PARM                    PVATR
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** BLI FT Enhancements Feature
     C                   PARM                    S01494
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499
      *
      ** BLI Payment Charges Enhancements
     C                   PARM                    S01506
      *
      ** BLI Extended Payment Charges
     C                   PARM                    S01508
      *                                                                         CFT014
      ** FT Batch Authorization and Credit Advices                              CFT014
     C                   PARM                    CFT004                         CFT014
      *                                                                         CFT014
      ** STP Phase 2 MT103                                                      CFT014
     C                   PARM                    CFT014                         CFT014
      *
      ** OUTPUT
      ** ======
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCDEFAULT - Defaulting of Charges and Commission            *
      *                                                               *
      *****************************************************************
      *
     C     SRCDefault    BEGSR
      *
     C                   CALLB     'FTIPAY3DT'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *
      ***Incoming*Payments*Lvl*2*Scrn*2*details*from*incoming*transaction       CFT014
      ***-*screen*format***********************************************         CFT014
     C*****              PARM                    NwIP4ScnFmt                    CFT014
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction       CFT014
      ** - screen format                                                        CFT014
     C                   PARM                    NwIP5ScnFmt                    CFT014
      *                                                                         CFT014
      ** Incoming Payments (additional info) for file update                    CFT014
      ** - file format                                                          CFT014
     C                   PARM                    NwIP2FilFmt                    CFT014
      *
      ** Incoming Payments retrieved from file - file format
     C                   PARM                    CrIPFilFmt
      *
      ** Payment Type
     C                   PARM                    PPYTP
      *
      ** Charges Branch
     C                   PARM                    PPYBR
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *                                                                                       187056
      ** Previous values of 'Charges to the Debit of a/c'                                     187056
     C                   PARM                    PPrvCDRT          1                          187056
     C**********         PARM                    PPrvCDRO         12                   187056 CGL029
     C                   PARM                    PPrvCDRO                                     CGL029
     C                   PARM                    PPrvCDBR          3                          187056
      *                                                                                     MD023247
     C                   PARM                    PPrvCDRC                                   MD023247
      *                                                                                       187056
      ** Recalcution flag.                                                                    187056
     C                   PARM                    PReCalc           1                          187056
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD
      *
      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY
      *
      ** SDFTFR - Charges Currency
     C                   PARM                    BTCHCY
      *
      ** VAT Default Flag
     C                   PARM                    PVATT
      *
      ** VAT Rate
     C                   PARM                    PVATR
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** BLI FT Enhancements Feature
     C                   PARM                    S01494
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499
      *
      ** BLI Payment Charges Enhancements
     C                   PARM                    S01506
      *
      ** BLI Extended Payment Charges
     C                   PARM                    S01508
      *                                                                         CFT014
      ** FT Batch Authorization and Credit Advices                              CFT014
     C                   PARM                    CFT004                         CFT014
      *                                                                         CFT014
      ** MT103 Messages Generation for FT                                       CFT014
     C                   PARM                    CFT014                         CFT014
      *                                                                                       CFT120
      ** FT IN/OP - Charges on DR of Account Ccy                                              CFT120
      *                                                                                       CFT120
     C                   PARM                    CFT120                                       CFT120
      *
      ** OUTPUT
      ** ======
      *
      ** Input Charge Currency
     C                   PARM                    PICCY             3
      *
      ** Input Charge Currency In Currency Flag
     C                   PARM                    PIINCY            1
      *
      ** Input Charge Currency No. of Decimal Places
     C                   PARM                    PINBDP            1 0
      *
      ** Input Charge Currency EMU Transmission Period Start Date
     C                   PARM                    PITPSD            5 0
      *
      ** Output Charge Currency
     C                   PARM                    POCCY             3
      *
      ** Output Charge Currency In Currency Flag
     C                   PARM                    POINCY            1
      *
      ** Output Charge Currency No. of Decimal Places
     C                   PARM                    PONBDP            1 0
      *
      ** DS for Default Charge Amounts
     C                   PARM                    PCharges
      *
      ** DS for Default Charge Currencies
     C                   PARM                    PChgCcy
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Save recalculated Charges.
      *
     C*****              MOVEL     NwIP4ScnFmt   CrIP4ScnFmt                    CFT014
     C                   MOVEL     NwIP5ScnFmt   CrIP5ScnFmt                    CFT014
     C*******************MOVEL     PCharges      WICharges       108            CFT009
     C*******************MOVEL     DDTRCD        WDTRCD           12            CFT009
     C*******************MOVEL     DDTXCD        WDTXCD           12            CFT009
     C*******************MOVEL     DDCQCD        WDCQCD           12            CFT009
     C*******************MOVEL     DDADCD        WDADCD           12            CFT009
     C*******************MOVEL     DDTLCD        WDTLCD           12            CFT009
     C*******************MOVEL     DDMSCD        WDMSCD           12            CFT009
     C*******************MOVEL     DDCHCD        WDCHCD           12            CFT009
      *                                                                         CFT009
     C                   MOVEL     PCharges      WICharges       196            CFT009
     C                   MOVEL     DDTRCD        WDTRCD                         CFT009
     C                   MOVEL     DDTXCD        WDTXCD                         CFT009
     C                   MOVEL     DDCQCD        WDCQCD                         CFT009
     C                   MOVEL     DDADCD        WDADCD                         CFT009
     C                   MOVEL     DDTLCD        WDTLCD                         CFT009
     C                   MOVEL     DDMSCD        WDMSCD                         CFT009
     C                   MOVEL     DDCHCD        WDCHCD                         CFT009
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrn_C - Process Level 2 screen 2                          *
      *                                                               *
      *****************************************************************
      *
     C     SRScrn_C      BEGSR
      *
      ** If Action Code is Insert or Amend, enable Detail
      ** fields on Level 2 screen 2 (all fields on Level 2
      ** screen 2 except Action Code and Payment Reference).
      ** Also, enable F5=Refresh.
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C                   MOVEL     'Y'           PEDTFLD
     C                   MOVEL     'Y'           PEINKE
     C                   ELSE
     C                   MOVEL     'N'           PEDTFLD
     C                   MOVEL     'N'           PEINKE
     C                   ENDIF
     C     *LIKE         DEFINE    DDTRCT        WTRCT                                        226722
     C                   MOVEL     *BLANKS       WTRCT                                        226722
      *
      ** Incoming Payments Maintenance has been called by linked
      ** maintenance/enquiry.
      *
     C     PParmLink     IFEQ      'Y'
      *
      ** Disable F7=Read Previous, F8=Read Next and F15=Browse.
      *
     C                   MOVEL     'N'           PEINKG
     C                   MOVEL     'N'           PEINKH
     C                   MOVEL     'N'           PEINKP
      *
      ** If Incoming Payments Maintenance has been called from a Subfile
      ** program, enable F18=Next Payment.
      *
     C     PLinkPgm      IFNE      'GL4442    '
     C     PLinkPgm      ANDNE     'GL0090    '
     C                   MOVEL     'Y'           PEINKS
     C                   ELSE
     C                   MOVEL     'N'           PEINKS
     C                   ENDIF
      *
     C                   ELSE
      *
     C**********         MOVEL     'Y'           PEINKG                                       261468
     C**********         MOVEL     'Y'           PEINKH                                       261468
     C**********         MOVEL     'Y'           PEINKP                                       261468
     C                   MOVEL     'N'           PEINKG                                       261468
     C                   MOVEL     'N'           PEINKH                                       261468
     C                   MOVEL     'N'           PEINKP                                       261468
     C                   MOVEL     'N'           PEINKS
      *
     C                   ENDIF
      *
      ** If feature CFT007 is switched on and action is Insert or Amend,
      ** enable F4=Prompt and F16=Search
      *
     C                   IF        CFT007 = 'Y' AND
     C                             DDACTN = 'I' OR DDACTN = 'A'
     C                   EVAL      PEINKD = 'Y'
     C                   EVAL      PEINKQ = 'Y'
     C                   ELSE
     C                   EVAL      PEINKD = 'N'
     C                   EVAL      PEINKQ = 'N'
     C                   ENDIF
      *
      ** Display Level 2 screen 2.
      *
     C                   CALLB     'FTIPAY3DP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** Payment Reference
     C                   PARM                    DDPREF
      *
      ** Incoming Payments Lvl 2 Scrn 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP4ScnFmt
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 2/2 from transaction - screen fmt         CFT014
     C                   PARM                    NwIP4aScnFmt                   CFT014
      *****************************************************************         CFT014
      ***DS*for*default*Charge*Amounts*********************************         CFT014
     C*****              PARM                    PCharges                       CFT014
      *****************************************************************         CFT014
      ***DS*for*default*Charge*Currencies******************************         CFT014
     C*****              PARM                    PChgCcy                        CFT014
      *
      ** Incoming Payment Status
     C                   PARM                    PStatus
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *
      ** Enable Detail Fields
     C                   PARM                    PEDTFLD
      *
      ** Enable Function Keys
      ** KD = Command Key 04 = Prompt
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KP = Command Key 15 = Browse
      ** KQ = Command Key 16 = Search
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
     C                   PARM                    PEINKD
     C                   PARM                    PEINKE
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKP
     C                   PARM                    PEINKQ
     C                   PARM                    PEINKS
      *
      ** Incoming Payments Lvl 2 Scrn 2 error indicators
     C                   PARM                    FTEIPY3
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write Screen with No Read Indicator
     C                   PARM      'N'           PWriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** BLI FT Enhancements Feature
     C                   PARM                    S01494
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499
      *
      ** BIC database plus
     C                   PARM                    CFT007
      *                                                                         CFT014
      ** STP Phase 2 MT103 Messages Generation for FT.                          CFT014
     C                   PARM                    CFT014                         CFT014
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys Enabled
      ** KC = Command Key 03 = Exit
      ** KD = Command Key 04 = Prompt
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
      ** KQ = Command Key 16 = Search
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
     C                   PARM                    PINKC
     C                   PARM                    PINKD
     C                   PARM                    PINKE
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKL
     C                   PARM                    PINKP
     C                   PARM                    PINKQ
     C                   PARM                    PINKS
      *
      ** Cursor position
     C                   PARM                    PRowCol
      *
      ** Save Warning Message Ids array of Level 2 screen 2.
      *
     C                   MOVEL     WMsgIDArr     WPrvWarnAr
     C                   MOVEL     DDTRCT        WTRCT                                        226722
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr
      *
     C                   SELECT
      *
      ** F3 - end program.
      *
     C     PINKC         WHENEQ    *ON
     C                   EXSR      SREndP
      *
      ** F4 or F16 - BIC processing
      *
     C     PINKD         WHENEQ    *ON
     C     PINKQ         OREQ      *ON
     C                   EXSR      SRBIC2
      *
      ** F5 - refresh Level 2 screen 2.
      *
     C     PINKE         WHENEQ    *ON
     C                   MOVEL     CrIP4ScnFmt   NwIP4ScnFmt
     C                   MOVEL     CrIP4AScnFmt  NwIP4AScnFmt                   CFT014
     C*****              MOVEL     WICharges     PCharges                       CFT014
     C*****              MOVEL     WDTRCD        DDTRCD                         CFT014
     C*****              MOVEL     WDTXCD        DDTXCD                         CFT014
     C*****              MOVEL     WDCQCD        DDCQCD                         CFT014
     C*****              MOVEL     WDADCD        DDADCD                         CFT014
     C*****              MOVEL     WDTLCD        DDTLCD                         CFT014
     C*****              MOVEL     WDMSCD        DDMSCD                         CFT014
     C*****              MOVEL     WDCHCD        DDCHCD                         CFT014
      *****************************************************************                       261468
      ***F7*-*roll*backwards.******************************************                       261468
      *****************************************************************                       261468
     C*****PINKG         WHENEQ    *ON                                                        261468
     C**********         EXSR      SRRoll                                                     261468
      *****************************************************************                       261468
      ***F8*-*roll*forwards.*******************************************                       261468
      *****************************************************************                       261468
     C*****PINKH         WHENEQ    *ON                                                        261468
     C**********         EXSR      SRRoll                                                     261468
      *
      ** F12 - cancel.  Refresh Level 2 screen 2 and redisplay
      ** Level 2 screen 1.
      *
     C     PINKL         WHENEQ    *ON
     C**********         MOVEL     CrIP4ScnFmt   NwIP4ScnFmt                                  226722
     C**********         MOVEL     CrIP4AScnFmt  NwIP4AScnFmt                   CFT014        226722
     C                   MOVEL     'S'           WScrn
      *****************************************************************                       261468
      ***F15*-*build*Browse.*******************************************                       261468
      *****************************************************************                       261468
     C*****PINKP         WHENEQ    *ON                                                        261468
     C**********         EXSR      SRBldBrw                                                   261468
      *
      ** F18 - next Payment.  Read next subfile record in linked
      ** maintenance/enquiry.
      *
     C     PINKS         WHENEQ    *ON
     C                   MOVEL     '7'           PParmRtcd
     C                   MOVEL     'T'           WScrn
      *
      ** Enter key was pressed.
      *
     C                   OTHER
      *
      ** If Action is Insert or Amend, validate input to
      ** Level 2 screen 2.
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C                   EXSR      SRVal_C
     C                   GOTO      EScrn_C
      *                                                                         CFT014
     C                   ELSE                                                   CFT014
     C                   IF        CFT009 = 'N'                                 CFT009
      ** Compute Charges and Commissions, and Total VAT Amounts based on        CFT014
      ** Level 1 details.                                                       CFT014
     C                   EXSR      SRCCVatL1                                    CFT014
      ** Do defaulting of Charges and Commission details                        CFT014
     C                   EXSR      SRCDefault                                   CFT014
     C                   ENDIF                                                  CFT009
     C                   ENDIF
      *
      ***If*Incoming*Payments*Maintenance*has*been*called*by***********         CFT014
      ***linked*maintenance/enquiry,*terminate*program.****************         CFT014
      *****************************************************************         CFT014
     C*****PParmLink     IFEQ      'Y'                                          CFT014
     C*****              MOVEL     *BLANK        PParmRtcd                      CFT014
     C*****              MOVEL     'T'           WScrn                          CFT014
     C*****              GOTO      EScrn_C                                      CFT014
     C*****              ENDIF                                                  CFT014
      *****************************************************************         CFT014
      ***Read*Next*Browse*Subfile*record.******************************         CFT014
      *****************************************************************         CFT014
     C*****PRDNB         IFEQ      'Y'                                          CFT014
     C*****              MOVEL     'R'           WScrn                          CFT014
     C*****              GOTO      EScrn_C                                      CFT014
     C*****              ENDIF                                                  CFT014
      *****************************************************************         CFT014
      *****************************************************************         CFT014
      ***Otherwise,*display*Initial*screen*with*blank*fields.**********         CFT014
      *****************************************************************         CFT014
     C*****              MOVEL     *BLANKS       DDACTN                         CFT014
     C*****              MOVEL     *BLANKS       DDPREF                         CFT014
     C*****              MOVEL     *BLANKS       DDSWTN                         CFT014
     C*****              MOVEL     *BLANKS       DDSEQNO                        CFT014
     C*****              MOVEL     *BLANKS       DDBRCA                         CFT014
     C*****              MOVEL     'I'           WScrn                          CFT014
      *                                                                         CFT014
      ** Process Level 2 Screen 3 details                                       CFT014
      *                                                                         CFT014
     C                   MOVEL     'D'           WScrn                          CFT014
      *                                                                         CFT014
      ** Reset work variables for 4th screen.                                   CFT014
      *                                                                         CFT014
     C                   IF        CFT014 = 'Y'                                 CFT014
     C                   EVAL      PPrvDDRCRM = *BLANKS                         CFT014
     C                   EVAL      PPrvTOTCHG = *Zero                           CFT014
     C                   ENDIF                                                  CFT014
      *
     C                   ENDSL
      *
     C     EScrn_C       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVal_C - Validate input to Level 2 screen 2                 *
      *                                                               *
      *****************************************************************
      *
     C     SRVal_C       BEGSR
      *
     C                   CALLB     'FTIPAY3VL'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Response Mode
     C                   PARM                    PResponse
      *
      ***Incoming*Payments*Lvl*1*Scrn*details*from*incoming*transaction
      ***-*screen*format***********************************************
     C*****              PARM                    NwIP1ScnFmt
      *
      ** Incoming Payments Lvl 2 Scrn 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP4ScnFmt
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 2 file 2 from incoming transaction        CFT014
      ** - screen format                                                        CFT014
     C                   PARM                    NwIP4AScnFmt                   CFT014
      *
      ** Settlement In Currency Indicator
     C                   PARM                    PSetInCy
      *
      ** Settlement EMU Transaction Period Start Date
     C                   PARM                    PSetTPSD
      *
      ** Payment In Currency Indicator
     C                   PARM                    PPayInCy
      *
      ** Payment EMU Transaction Period Start Date
     C                   PARM                    PPayTPSD
      *
      ** Input Charge Currency
     C                   PARM                    PICCY
      *
      ** Input Charge Currency No. of Decimal Places
     C                   PARM                    PINBDP
      *
      ** Output Charge Currency
     C                   PARM                    POCCY
      *
      ** Output Charge Currency No. of Decimal Places
     C                   PARM                    PONBDP
      *
      ** Incoming Payments extra data
     C                   PARM                    PExtData
      *                                                                         CFT014
      ** Charges Branch                                                         CFT014
     C                   PARM                    PPYBR             3            CFT014
      *
      ** STANDING DATA
      ** =============
      *
      ** SDGELR - Currency Code for Euro
     C                   PARM                    BKEURO
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** VAT Default Flag
     C                   PARM                    PVATT
      *
      ** VAT Rate
     C                   PARM                    PVATR
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU FT Settlement Currency Conversion
     C                   PARM                    CEU006
      *
      ** BLI FT Enhancements Feature
     C                   PARM                    S01494
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499
      *                                                                         CFT014
      ** MT103 Messages Generation for FT                                       CFT014
     C                   PARM                    CFT014            1            CFT014
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
      *
      ** Incoming Payments Lvl 2 Scrn 2 error indicators
     C                   PARM                    FTEIPY3
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *                                                                         CFT014
      ** Incoming Payments (additional details) for file update                 CFT014
     C                   PARM                    NwIP2FilFmt                    CFT014
      ***********                                                               CFT014
      ** DS*for*Default*Charge*Amounts*********************************         CFT014
     C***********        PARM                    PCharges                       CFT014
      *
     C                   MOVEL     *BLANK        WRedisplay
      *
      ** If no errors occurred during validation of fields on Level 2
      ** screen 2, check if there are warnings which have not been
      ** displayed yet.
      *
     C                   IF        IDx = 0
      *
     C                   Z-ADD     1             WIx
      *
     C     WIx           DOWLE     WIDx
     C     WRedisplay    ANDEQ     *BLANK
     C                   IF        WMsgIdArr(WIx) <> WPrvWarnAr(WIx)
     C                   EVAL      WRedisplay = 'Y'
     C                   ELSE
     C                   EVAL      WIx =WIx + 1
     C                   ENDIF
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** If no errors occurred during validation of Level 2
      ** screen 2 and if there are no warnings which have not been
      ** displayed, display Confirmation screen.
      *
     C     IDx           IFEQ      *ZERO
     C     WRedisplay    ANDEQ     *BLANK
     C*****              MOVEL     'F'           WScrn                          CFT014
                                                                                CFT009
     C                   IF        CFT009 = 'N'                                 CFT009
      *                                                                         CFT014
      ** Compute Charges and Commissions, and Total VAT Amounts based on        CFT014
      ** Level 1 details.                                                       CFT014
      *                                                                         CFT014
     C                   EXSR      SRCCVatL1                                    CFT014
      *                                                                         CFT014
      ** Do defaulting of Charges and Commission details                        CFT014
      *                                                                         CFT014
     C                   EXSR      SRCDefault                                   CFT014
                                                                                CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT014
      ** Display Level 2 Screen 3.                                              CFT014
      *                                                                         CFT014
     C                   MOVEL     'D'           WScrn                          CFT014
      *                                                                         CFT014
      ** Reset work variables for 4th screen.                                   CFT014
      *                                                                         CFT014
     C                   IF        CFT014 = 'Y'                                 CFT014
     C                   EVAL      PPrvDDRCRM = *BLANKS                         CFT014
     C                   EVAL      PPrvTOTCHG = *Zero                           CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SRScrn_D - Process Level 2 screen 3                          *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
      *                                                                         CFT014
     C     SRScrn_D      BEGSR                                                  CFT014
      *                                                                         CFT014
      ** If Action Code is Insert or Amend, enable Detail                       CFT014
      ** fields on Level 2 screen 3 (all fields on Level 2                      CFT014
      ** screen 3 except Action Code and Payment Reference).                    CFT014
      ** Also, enable F5=Refresh.                                               CFT014
      *                                                                         CFT014
     C     DDACTN        IFEQ      'I'                                          CFT014
     C     DDACTN        OREQ      'A'                                          CFT014
     C                   MOVEL     'Y'           PEDTFLD                        CFT014
     C                   MOVEL     'Y'           PEINKE                         CFT014
     C                   ELSE                                                   CFT014
     C                   MOVEL     'N'           PEDTFLD                        CFT014
     C                   MOVEL     'N'           PEINKE                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Incoming Payments Maintenance has been called by linked                CFT014
      ** maintenance/enquiry.                                                   CFT014
      *                                                                         CFT014
     C     PParmLink     IFEQ      'Y'                                          CFT014
      *                                                                         CFT014
      ** Disable F7=Read Previous, F8=Read Next and F15=Browse.                 CFT014
      *                                                                         CFT014
     C                   MOVEL     'N'           PEINKG                         CFT014
     C                   MOVEL     'N'           PEINKH                         CFT014
     C                   MOVEL     'N'           PEINKP                         CFT014
      *                                                                         CFT014
      ** If Incoming Payments Maintenance has been called from a Subfile        CFT014
      ** program, enable F18=Next Payment.                                      CFT014
      *                                                                         CFT014
     C     PLinkPgm      IFNE      'GL4442    '                                 CFT014
     C     PLinkPgm      ANDNE     'GL0090    '                                 CFT014
     C                   MOVEL     'Y'           PEINKS                         CFT014
     C                   ELSE                                                   CFT014
     C                   MOVEL     'N'           PEINKS                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ELSE                                                   CFT014
      *                                                                         CFT014
     C**********         MOVEL     'Y'           PEINKG                                CFT014 261468
     C**********         MOVEL     'Y'           PEINKH                                CFT014 261468
     C**********         MOVEL     'Y'           PEINKP                                CFT014 261468
     C                   MOVEL     'N'           PEINKG                                       261468
     C                   MOVEL     'N'           PEINKH                                       261468
     C                   MOVEL     'N'           PEINKP                                       261468
     C                   MOVEL     'N'           PEINKS                         CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** If feature CFT007 is switched on and action is Insert or Amend,        CFT014
      ** enable F4=Prompt and F16=Search                                        CFT014
      *                                                                         CFT014
     C                   IF        CFT007 = 'Y' AND                             CFT014
     C                             DDACTN = 'I' OR DDACTN = 'A'                 CFT014
     C                   EVAL      PEINKD = 'Y'                                 CFT014
     C                   EVAL      PEINKQ = 'Y'                                 CFT014
     C                   ELSE                                                   CFT014
     C                   EVAL      PEINKD = 'N'                                 CFT014
     C                   EVAL      PEINKQ = 'N'                                 CFT014
     C                   ENDIF                                                  CFT014
     C/COPY WNCPYSRC,FTIPAYSC25
      *                                                                         CFT014
      ** Display Level 2 screen 3.                                              CFT014
      *                                                                         CFT014
     C                   CALLB     'FTIPAY4DP'                                  CFT014
      *                                                                         CFT014
      ** INPUT                                                                  CFT014
      ** =====                                                                  CFT014
      *                                                                         CFT014
      ** Return Code                                                            CFT014
     C                   PARM      *BLANKS       RetCodeOut                     CFT014
      *                                                                         CFT014
      ** Action Code                                                            CFT014
     C                   PARM                    DDACTN                         CFT014
      *                                                                         CFT014
      ** Payment Reference                                                      CFT014
     C                   PARM                    DDPREF                         CFT014
      *                                                                         CFT014
      ** Settle Currency                                                        CFT014
     C                   PARM                    DDSMCY                         CFT014
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction       CFT014
      ** - screen format                                                        CFT014
     C                   PARM                    NwIP5ScnFmt                    CFT014
      *                                                                         CFT009
      ** Incoming Payments for file update - file format                        CFT009
     C                   PARM                    NwIPFilFmt                     CFT009
      *                                                                         CFT014
      ** DS for default Charge Amounts                                          CFT014
     C                   PARM                    PCharges                       CFT014
      *                                                                         CFT014
      ** DS for default Charge Currencies                                       CFT014
     C                   PARM                    PChgCcy                        CFT014
      *                                                                         CFT014
      ** Incoming Payment Status                                                CFT014
     C                   PARM                    PStatus                        CFT014
      *                                                                         CFT014
      ** Enable Detail Fields                                                   CFT014
     C                   PARM                    PEDTFLD                        CFT014
      *                                                                         CFT014
      ** Enable Function Keys                                                   CFT014
      ** KE = Command Key 05 = Refresh                                          CFT014
      ** KG = Command Key 07 = Read Previous                                    CFT014
      ** KH = Command Key 08 = Read Next                                        CFT014
      ** KP = Command Key 15 = Browse                                           CFT014
      ** KS = Command Key 18 = Next Payment (from linked enquiry)               CFT014
      ** KT = Command Key 19 = Margin Info                                      CFT014
     C                   PARM                    PEINKE                         CFT014
     C                   PARM                    PEINKG                         CFT014
     C                   PARM                    PEINKH                         CFT014
     C                   PARM                    PEINKP                         CFT014
     C                   PARM                    PEINKS                         CFT014
     C                   PARM      'Y'           PEINKT            1            CFT014
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 3 error indicators                        CFT014
     C                   PARM                    FTEIPY4                        CFT014
      *                                                                         CFT014
      ** Error fields/message IDs/message data (arrays) from/to caller          CFT014
     C                   PARM                    FldNameArr                     CFT014
     C                   PARM                    MsgIdArr                       CFT014
     C                   PARM                    MsgDtaArr                      CFT014
      *                                                                         CFT014
      ** Warning fields/message Ids/message data (arrays) from/to               CFT014
      ** caller                                                                 CFT014
     C                   PARM                    WFldNamArr                     CFT014
     C                   PARM                    WMsgIdArr                      CFT014
     C                   PARM                    WMsgDtaArr                     CFT014
      *                                                                         CFT014
      ** Write Screen with No Read Indicator                                    CFT014
     C                   PARM      'N'           PWriteOnly                     CFT014
      *                                                                         CFT014
      ** STANDING DATA                                                          CFT014
      ** =============                                                          CFT014
      *                                                                         CFT014
      ** SDBANK - System Runday                                                 CFT014
     C                   PARM                    BJMRDT                         CFT014
      *                                                                         CFT014
      ** SDBANK - Default branch code                                           CFT014
     C                   PARM                    BJSBRC                         CFT014
      *                                                                         CFT014
      ** SDMMOD - Analytical Accounting                                         CFT014
     C                   PARM                    BGN0ST                         CFT014
      *                                                                         CFT014
      ** SWITCHABLE FEATURES                                                    CFT014
      ** ===================                                                    CFT014
      *                                                                         CFT014
      ** BLI FT Enhancements Feature                                            CFT014
     C                   PARM                    S01494                         CFT014
      *                                                                         CFT014
      ** BLI VAT Processing Feature                                             CFT014
     C                   PARM                    S01499                         CFT014
      *                                                                         CFT014
      ** BIC database plus                                                      CFT014
     C                   PARM                    CFT007                         CFT014
      *                                                                         CFT014
      ** MT103 Messages Generation for FT                                       CFT014
     C                   PARM                    CFT014                         CFT014
     C/COPY WNCPYSRC,FTIPAYSC26
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
     C                   PARM                    CFT010                         CFT009
      *                                                                         CFT014
      ** OUTPUT                                                                 CFT014
      ** ======                                                                 CFT014
      *                                                                         CFT014
      ** Function Keys Enabled                                                  CFT014
      ** KC = Command Key 03 = Exit                                             CFT014
      ** KE = Command Key 05 = Refresh                                          CFT014
      ** KG = Command Key 07 = Read Previous                                    CFT014
      ** KH = Command Key 08 = Read Next                                        CFT014
      ** KL = Command Key 12 = Cancel                                           CFT014
      ** KP = Command Key 15 = Browse                                           CFT014
      ** KS = Command Key 18 = Next Payment (from linked enquiry)               CFT014
      ** KT = Command Key 19 = Margin Info                                      CFT014
     C                   PARM                    PINKC                          CFT014
     C                   PARM                    PINKE                          CFT014
     C                   PARM                    PINKG                          CFT014
     C                   PARM                    PINKH                          CFT014
     C                   PARM                    PINKL                          CFT014
     C                   PARM                    PINKP                          CFT014
     C                   PARM                    PINKS                          CFT014
     C                   PARM                    PINKT             1            CFT014
      *                                                                         CFT014
      ** Cursor position                                                        CFT014
     C                   PARM                    PRowCol                        CFT014
      *                                                                         CFT009
      ** Input Charge Currency                                                  CFT009
     C                   PARM                    PICCY                          CFT009
      *                                                                         CFT009
      ** Output Charge Currency                                                 CFT009
     C                   PARM                    POCCY                          CFT009
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG          1            CFT009
      *                                                                                       CFT120
      ** Control re-display of screen if CDRO is modified                                     CFT120
      *                                                                                       CFT120
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   MOVEL     PCDROCHG      CDROCHGD          1                          257125
     C                   ENDIF                                                                CFT120
      *                                                                         CFT009
      ** Clear warning message work inds for charges screen                     CFT009
      *                                                                         CFT009
     C                   IF        PINKL = *ON                                  CFT009
     C                   EVAL      PChgWarn = *BLANKS                           CFT009
     C                   ENDIF                                                  CFT009
      *
      ** Save Warning Message Ids array of Level 2 screen 3.
      *
     C                   MOVEL     WMsgIDArr     WPrvWarnAr
      *                                                                         CFT014
      ** Reset error fields.                                                    CFT014
      *                                                                         CFT014
     C                   EXSR      SRResetErr                                   CFT014
      *                                                                         CFT014
     C                   SELECT                                                 CFT014
      *                                                                         CFT014
      ** F3 - end program.                                                      CFT014
      *                                                                         CFT014
     C     PINKC         WHENEQ    *ON                                          CFT014
     C                   EXSR      SREndP                                       CFT014
      *                                                                         CFT014
      ** F5 - refresh Level 2 screen 3.                                         CFT014
      *                                                                         CFT014
     C     PINKE         WHENEQ    *ON                                          CFT014
     C                   MOVEL     CrIP5ScnFmt   NwIP5ScnFmt                    CFT014
     C                   MOVEL     WICharges     PCharges                       CFT014
     C                   MOVEL     WDTRCD        DDTRCD                         CFT014
     C                   MOVEL     WDTXCD        DDTXCD                         CFT014
     C                   MOVEL     WDCQCD        DDCQCD                         CFT014
     C                   MOVEL     WDADCD        DDADCD                         CFT014
     C                   MOVEL     WDTLCD        DDTLCD                         CFT014
     C                   MOVEL     WDMSCD        DDMSCD                         CFT014
     C                   MOVEL     WDCHCD        DDCHCD                         CFT014
      *****************************************************************                CFT014 261468
      ***F7*-*roll*backwards.******************************************                CFT014 261468
      *****************************************************************                CFT014 261468
     C*****PINKG         WHENEQ    *ON                                                 CFT014 261468
     C**********         EXSR      SRRoll                                              CFT014 261468
      *****************************************************************                CFT014 261468
      ***F8*-*roll*forwards.*******************************************                CFT014 261468
      *****************************************************************                CFT014 261468
     C*****PINKH         WHENEQ    *ON                                                 CFT014 261468
     C**********         EXSR      SRRoll                                              CFT014 261468
      *                                                                         CFT014
      ** F12 - cancel.  Refresh Level 2 screen 3 and redisplay                  CFT014
      ** Level 2 screen 2.                                                      CFT014
      *                                                                         CFT014
     C     PINKL         WHENEQ    *ON                                          CFT014
     C                   MOVEL     CrIP5ScnFmt   NwIP5ScnFmt                    CFT014
     C                   MOVEL     'C'           WScrn                          CFT014
      *****************************************************************                CFT014 261468
      ***F15*-*build*Browse.*******************************************                CFT014 261468
      *****************************************************************                CFT014 261468
     C*****PINKP         WHENEQ    *ON                                                 CFT014 261468
     C**********         EXSR      SRBldBrw                                            CFT014 261468
      *                                                                         CFT014
      ** F18 - next Payment.  Read next subfile record in linked                CFT014
      ** maintenance/enquiry.                                                   CFT014
      *                                                                         CFT014
     C     PINKS         WHENEQ    *ON                                          CFT014
     C                   MOVEL     '7'           PParmRtcd                      CFT014
     C                   MOVEL     'T'           WScrn                          CFT014
      *                                                                         CFT014
      ** F19 - Margin Information                                               CFT014
      *                                                                         CFT014
     C     PINKT         WHENEQ    *ON                                          CFT014
      *                                                                                       CER030
      ** F19 - Margin Information /Extended Narratives                                        CER030
      *                                                                                       CER030
     C                   IF        (CER030 = 'Y') OR                                          CER030
     C                             (CER031 = 'Y') OR                                          CER030
     C                             (CGL013 = 'Y')                                             CER030
     C                   MOVEL     'M'           WScrn                                        CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
     C                   IF        (BGN0ST = 'Y')                               CFT014
     C                   IF        (DDSMCY = DDPCCY)                            CFT014
     C                             AND (DDMBSI = *BLANK)                        CFT014
     C                             AND (DDMSIG = *BLANK)                        CFT014
     C                   ADD       1             Idx                            CFT014
     C                   Eval      FldNameArr(Idx) = '*ANY'                     CFT014
     C                   Eval      MsgIdArr(Idx) = 'FTM2554'                    CFT014
     C                   ELSE                                                   CFT014
     C                   MOVEL     'M'           WScrn                          CFT014
     C                   ENDIF                                                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                         CFT014
      ** Enter key was pressed.                                                 CFT014
      *                                                                         CFT014
     C                   OTHER                                                  CFT014
      *                                                                         CFT014
      ** If Action is Insert or Amend, validate input to                        CFT014
      ** Level 2 screen 3.                                                      CFT014
      *                                                                         CFT014
     C     DDACTN        IFEQ      'I'                                          CFT014
     C     DDACTN        OREQ      'A'                                          CFT014
     C                   IF        CFT009 = 'N'                                 CFT009
      *                                                                                       187056
      ** Perform recalculation of charges if 'charges to the debit of a/c'                    187056
      ** has been changed.                                                                    187056
     C                   EXSR      SRReCalc                                                   187056
      *                                                                                       187056
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
     C                   EXSR      SRVal_D                                      CFT014
     C/COPY WNCPYSRC,FTIPAYSC15
     C                   IF        WIDx = 0                                                   250600
     C                             And Idx = 0                                                256117
     C                             And PCDROCHG = *Blanks                                     256256
     C                             AND CFT120 = 'N'                                           CFT120
     C                             OR WIDx = 0                                                CFT120
     C                             And Idx = 0                                                CFT120
     C                             AND CDROCHGD = *BLANKS                                     257125
     C                             AND CFT120 = 'Y'                                           CFT120
     C                   EVAL      WScrn = 'F'                                                250600
      *                                                                                       CSW209
      ** Display Cover message if SWIFT 2009 is ON                                            CSW209
      *                                                                                       CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   EVAL      WScrn = 'N'                                                CSW209
      *                                                                                       CSW209
      ** Reset error fields.                                                                  CSW209
      *                                                                                       CSW209
     C                   EXSR      SRResetErr                                                 CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                250600
      *                                                                                       CER001
      ** ULX611 - window processing                                                           CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y'                                               CER001
     C                             and  BTLVJN = 'Y'                                          CER001
     C                             or ULX043 = 'Y'                                            CER001
     C                             and  PParmLevel = '2'                                      CER001
      *                                                                                       CER001
      ** New window processing                                                                CER001
      *                                                                                       CER001
     C                   EXSR      WINDOWI                                                    CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y'                                               CER001
     C                   EVAL      WScrn = 'L'                                                CER001
     C                   LEAVESR                                                              CER001
     C                   ENDIF                                                                CER001
     C                   IF        WIDx = 0                                                BUG14494A
     C                             And Idx = 0                                                256117
     C                             And PCDROCHG = *Blanks                                     256256
     C                             AND CFT120 = 'N'                                           CFT120
     C                             OR WIDx = 0                                                CFT120
     C                             And Idx = 0                                                CFT120
     C                             AND CDROCHGD = *BLANKS                                     257125
     C                             AND CFT120 = 'Y'                                           CFT120
     C                   EVAL      WScrn = 'F'                                             BUG14494A
     C                   ENDIF                                                             BUG14494A
      *                                                                                       CER001
     C                   GOTO      EScrn_D                                      CFT014
     C                   ENDIF                                                  CFT014
      *                                                                                       CSW209
      ** Display Cover message if SWIFT 2009 is ON                                            CSW209
      ** for Action code not equal to 'I' and 'A'                                             CSW209
      *                                                                                       CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   EVAL      WScrn = 'N'                                                CSW209
     C                   LEAVESR                                                              CSW209
     C                   ENDIF                                                                CSW209
     C/COPY WNCPYSRC,FTIPAYSC16
      *                                                                                       CER001
      ** Window processing                                                                    CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y'                                               CER001
     C                             and  BTLVJN = 'Y'                                          CER001
     C                             or ULX043 = 'Y'                                            CER001
     C                             and  PParmLevel = '2'                                      CER001
      *                                                                                       CER001
      ** New window processing                                                                CER001
      *                                                                                       CER001
     C                   EXSR      WINDOWI                                                    CER001
      *                                                                                       CER001
      **  If F3 or F12 pressed on window, make sure that the Primary or                       CER001
      **  secondary screen or the subfile is displayed and not initial                        CER001
      **  screen                                                                              CER001
      *                                                                                       CER001
     C                   IF        #RTRN = 'Y2U9999'                                          CER001
     C                             or #RTRN = 'USR0790'                                       CER001
     C                   GOTO      EScrn_D                                                    CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y'                                               CER001
     C                   EVAL      WScrn = 'L'                                                CER001
     C                   LEAVESR                                                              CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                         CFT014
      ** If Incoming Payments Maintenance has been called by                    CFT014
      ** linked maintenance/enquiry, terminate program.                         CFT014
      *                                                                         CFT014
     C     PParmLink     IFEQ      'Y'                                          CFT014
     C                   MOVEL     *BLANK        PParmRtcd                      CFT014
     C                   MOVEL     'T'           WScrn                          CFT014
     C                   GOTO      EScrn_D                                      CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Read Next Browse Subfile record.                                       CFT014
      *                                                                         CFT014
     C     PRDNB         IFEQ      'Y'                                          CFT014
     C                   MOVEL     'R'           WScrn                          CFT014
     C                   GOTO      EScrn_D                                      CFT014
     C                   ENDIF                                                  CFT014
     C/COPY WNCPYSRC,FTIPAYSC27
      *                                                                         CFT014
      ** Otherwise, display Initial screen with blank fields.                   CFT014
      *                                                                         CFT014
     C                   MOVEL     *BLANKS       DDACTN                         CFT014
     C                   MOVEL     *BLANKS       DDPREF                         CFT014
     C                   MOVEL     *BLANKS       DDSWTN                         CFT014
     C                   MOVEL     *BLANKS       DDSEQNO                        CFT014
     C                   MOVEL     *BLANKS       DDBRCA                         CFT014
     C                   MOVEL     'I'           WScrn                          CFT014
     C/COPY WNCPYSRC,FTIPAYSC28
      *                                                                         CFT014
     C                   ENDSL                                                  CFT014
      *                                                                         CFT014
     C     EScrn_D       ENDSR                                                  CFT014
      *****************************************************************         CFT014
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SRVal_D - Validate input to Level 2 screen 3                 *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
      *                                                                         CFT014
     C     SRVal_D       BEGSR                                                  CFT014
      *                                                                         CFT014
     C                   CALLB     'FTIPAY4VL'                                  CFT014
      *                             =========                                   CFT014
      *                                                                         CFT014
      ** INPUT                                                                  CFT014
      ** =====                                                                  CFT014
      *                                                                         CFT014
      ** Mode = '*FRONT' (Front Office Transaction Interface)                   CFT014
      ** Mode = '      ' (Not Front Office Transaction Interface)               CFT014
      ** Mode = '*RPR  ' (Repair Function)                                      CFT014
      ** Mode = '*SIN  ' (Screen Input Function)                                CFT014
     C                   PARM                    PMode                          CFT014
      *                                                                         CFT014
      ** Response Mode                                                          CFT014
     C                   PARM                    PResponse                      CFT014
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 details                                        CFT014
     C                   PARM                    NwIP1ScnFmt                    CFT014
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction       CFT014
      ** - screen format                                                        CFT014
     C                   PARM                    NwIP5ScnFmt                    CFT014
      *                                                                         CFT014
      ** Settlement In Currency Indicator                                       CFT014
     C                   PARM                    PSetInCy                       CFT014
      *                                                                         CFT014
      ** Settlement EMU Transaction Period Start Date                           CFT014
     C                   PARM                    PSetTPSD                       CFT014
      *                                                                         CFT014
      ** Payment In Currency Indicator                                          CFT014
     C                   PARM                    PPayInCy                       CFT014
      *                                                                         CFT014
      ** Payment EMU Transaction Period Start Date                              CFT014
     C                   PARM                    PPayTPSD                       CFT014
      *                                                                         CFT014
      ** Input Charge Currency                                                  CFT014
     C                   PARM                    PICCY                          CFT014
      *                                                                         CFT014
      ** Input Charge Currency No. of Decimal Places                            CFT014
     C                   PARM                    PINBDP                         CFT014
      *                                                                         CFT014
      ** Output Charge Currency                                                 CFT014
     C                   PARM                    POCCY                          CFT014
      *                                                                         CFT014
      ** Output Charge Currency No. of Decimal Places                           CFT014
     C                   PARM                    PONBDP                         CFT014
      *                                                                         CFT009
      ** Saved default charges                                                  CFT009
     C                   PARM                    DefValid                       CFT009
     C                   PARM                    DefValidX                      CFT009
      *                                                                         CFT014
      ** STANDING DATA                                                          CFT014
      ** =============                                                          CFT014
      *                                                                         CFT014
      ** SDBANK - Base Currency Code                                            CFT014
     C                   PARM                    BJCYCD                         CFT014
      *                                                                         CFT014
      ** SDBANK - Midas Run Date                                                CFT014
     C**********         PARM                    BJRDNB                                CFT014 CSC011
     C                   PARM                    PPROCDTE                                     CSC011
      *                                                                         CFT014
      ** SDBANK - Back Value Period in Days                                     CFT014
     C                   PARM                    BJBVPD                         CFT014
      *                                                                         CFT014
      ** SDBANK - Single Branch Code                                            CFT014
     C                   PARM                    BJSBRC                         CFT014
      *                                                                         CFT009
      ** SDBANK - Local currency code                                           CFT009
     C                   PARM                    BJLCCY                         CFT009
      *                                                                         CFT014
      ** SDMMOD - Multibranch Indicator                                         CFT014
     C                   PARM                    BGMBIN                         CFT014
      *                                                                         CFT014
      ** SDMMOD - Retail Banking                                                CFT014
     C                   PARM                    BGRTBN                         CFT014
      *                                                                         CFT014
      ** SDRETL - Retail A/c Number Required?                                   CFT014
     C                   PARM                    BMRANR                         CFT014
      *                                                                         CFT014
      ** SDGELR - Currency Code for Euro                                        CFT014
     C                   PARM                    BKEURO                         CFT014
      *                                                                         CFT014
      ** SDMMOD - Analytical Accounting                                         CFT014
     C                   PARM                    BGN0ST                         CFT014
      *                                                                         CFT014
      ** VAT Default Flag                                                       CFT014
     C                   PARM                    PVATT                          CFT014
      *                                                                         CFT014
      ** VAT Rate                                                               CFT014
     C                   PARM                    PVATR                          CFT014
      *                                                                         CFT009
      ** SDFTFR - Charges calculated in transaction ccy                         CFT009
     C                   PARM                    CHTRCY                         CFT009
      *                                                                         CFT009
      ** SDFTFR - Charges currency indicator                                    CFT009
     C                   PARM                    BTCHCY                         CFT009
      *                                                                         CFT009
      ** SDFTFR - Fixed charge currency                                         CFT009
     C                   PARM                    FCHCCY                         CFT009
      *                                                                         CFT014
      ** SWITCHABLE FEATURES                                                    CFT014
      ** ===================                                                    CFT014
      *                                                                         CFT014
      ** EMU FT Settlement Currency Conversion                                  CFT014
     C                   PARM                    CEU006                         CFT014
      *                                                                         CFT014
      ** BLI FT Enhancements Feature                                            CFT014
     C                   PARM                    S01494                         CFT014
      *                                                                         CFT014
      ** BLI VAT Processing Feature                                             CFT014
     C                   PARM                    S01499                         CFT014
      *                                                                         CFT014
      ** MT103 Messages Generation for FT                                       CFT014
     C                   PARM                    CFT014                         CFT014
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
     C                   PARM                    CFT010                         CFT009
      *                                                                                       CFT120
      ** FT IN/OP - Charges on DR of Account Ccy                                              CFT120
      *                                                                                       CFT120
     C                   PARM                    CFT120                                       CFT120
      *                                                                         CFT014
      ** OUTPUT                                                                 CFT014
      ** ======                                                                 CFT014
      *                                                                         CFT014
      ** Error fields/message IDs/message data (arrays) from/to caller          CFT014
     C                   PARM                    FldNameArr                     CFT014
     C                   PARM                    MsgIdArr                       CFT014
     C                   PARM                    MsgDtaArr                      CFT014
      *                                                                         CFT014
      ** Array index (3P0) from/to caller                                       CFT014
     C                   PARM                    IDx                            CFT014
      *                                                                         CFT014
      ** Warning flds/message IDs/message data (arrays) from/to caller          CFT014
     C                   PARM                    WFldNamArr                     CFT014
     C                   PARM                    WMsgIdArr                      CFT014
     C                   PARM                    WMsgDtaArr                     CFT014
      *                                                                         CFT014
      ** Array index (3P0) from/to caller                                       CFT014
     C                   PARM                    WIDx                           CFT014
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 3 error indicators                        CFT014
     C                   PARM                    FTEIPY4                        CFT014
      *                                                                         CFT014
      ** Incoming Payments for file update - file format                        CFT014
     C                   PARM                    NwIPFilFmt                     CFT014
      *                                                                         CFT014
      ** Incoming Payments (extension) for file update - file format            CFT014
     C                   PARM                    NwIP2FilFmt                    CFT014
      *                                                                         CFT014
      ** DS for Default Charge Amounts                                          CFT014
     C                   PARM                    PCharges                       CFT014
      *                                                                         CFT014
      ** Force redisplay                                                        CFT014
     C                   PARM      *BLANK        PFrcReDisplay     1            CFT014
      *                                                                         CFT014
      ** I/O: Previous Receiver's charges remitted input                        CFT014
      **      Its value is maintained in FTVIRCRM                               CFT014
     C                   PARM                    PPrvDDRCRM       12            CFT014
      *                                                                         CFT014
      ** I/O: Previous Total charges calculated                                 CFT014
      **      Its value is maintained in FTVIRCRM                               CFT014
     C                   PARM                    PPrvTOTCHG       15 0          CFT014
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG          1            CFT009
      *                                                                         CFT009
      ** Previous warning messages array                                        CFT009
     C                   PARM                    WPrvWarnAr                     CFT009
      *                                                                         CFT009
      ** Warning message work inds for charges screen                           CFT009
     C                   PARM                    PChgWarn                       CFT009
     C                   PARM                    BENEDrBlck                                 MD025111
     C                   PARM                    BENEDrRefd                                MD047369A
      *                                                                         CFT014
     C                   MOVE      PFrcReDisplay WRedisplay                     CFT014
      *                                                                         CFT014
      ** If no errors occurred during validation of fields on Level 2           CFT014
      ** screen 3, check if there are warnings which have not been              CFT014
      ** displayed yet.                                                         CFT014
      *                                                                         CFT014
     C*******************IF        IDx = 0                                CFT014CFT009
      *                                                                         CFT014
     C                   Z-ADD     1             WIx                            CFT014
     C                   EVAL      WRedisplay = ' '                                         MD022428
      *                                                                         CFT014
     C     WIx           DOWLE     WIDx                                         CFT014
     C     WRedisplay    ANDEQ     *BLANK                                       CFT014
     C                   IF        WMsgIdArr(WIx) <> WPrvWarnAr(WIx)            CFT014
     C                   EVAL      WRedisplay = 'Y'                             CFT014
     C                   ELSE                                                   CFT014
     C                   EVAL      WIx =WIx + 1                                 CFT014
     C                   ENDIF                                                  CFT014
     C                   ENDDO                                                  CFT014
      *                                                                         CFT014
     C**********         ENDIF                                                  CFT014
                                                                                            MD022428
     C                   IF        WRedisplay = ' '                                         MD022428
     C                   CLEAR                   WIDx                                       MD022428
     C                   IF        IDx = 0                                                  MD025111
     C                   MOVE      *ALL'Y'       FTEIPY4                                    MD022428
     C                   ENDIF                                                              MD025111
     C                   CLEAR                   WfldNamArr                                 MD022428
     C                   CLEAR                   WMsgIdarr                                  MD022428
     C                   CLEAR                   WMsgDtaArr                                 MD022428
     C                   ENDIF                                                              MD022428
      *                                                                         CFT009
      ** If no warnings which haven't been displayed then replace               CFT009
      ** any previous warnings (W) with ok (Y).                                 CFT009
      *                                                                         CFT009
     C                   IF        WRedisplay <> 'Y'                            CFT009
     C                   EVAL      *IN81 = *ON                                  CFT009
                                                                                CFT009
     C                   DOW       *IN81 = *ON                                  CFT009
     C     'W'           SCAN      FTEIPY4:1     @p                3 0    81    CFT009
                                                                                CFT009
     C     *IN81         IFEQ      *ON                                          CFT009
     C                   EVAL      %SUBST(FTEIPY4: @P: 1) = 'Y'                 CFT009
     C/COPY WNCPYSRC,FTH00514
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ENDDO                                                  CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
     C*******************ENDIF                                            CFT014CFT009
      *                                                                         CFT014
      ** If no errors occurred during validation of Level 2                     CFT014
      ** screen 3 and if there are no warnings which have not been              CFT014
      ** displayed, display Confirmation screen.                                CFT014
      *                                                                         CFT014
     C     IDx           IFEQ      *ZERO                                        CFT014
     C     WRedisplay    ANDEQ     *BLANK                                       CFT014
     C*****WReDspChg     ANDEQ     'N'                                                  187056CFT009
     C     WReDspChg     ANDNE     'Y'                                                        CFT009
      *                                                                                       CER030
     C                   IF        (CER030 = 'Y') OR                                          CER030
     C                             (CGL013 = 'Y') OR                                          CER030
     C                             (BGN0ST = 'Y')                                             CER030
      *                                                                         CFT014
      ** If Analytical Accounting is installed, settle and pay currency are     CFT014
      ** the same and Margin info details is not blank.                         CFT014
      *                                                                         CFT014
     C                   IF        (BGN0ST = 'Y') AND                           CFT014
     C                             DDSMCY = DDPCCY AND                          CFT014
     C                             DDMBSI <> *BLANK AND                         CFT014
     C                             DDMSIG <> *BLANK                             CFT014
     C                   MOVEL     'M'           WScrn                          CFT014
     C                   EVAL      OKFXMP = 'N'                                 CFT014
     C                   EVAL      OKMBSI = 'N'                                 CFT014
     C                   EVAL      OKMSIG = 'N'                                 CFT014
     C                   Eval      FldNameArr(1) = '*ALL'                       CFT014
     C                   Eval      MsgIdArr(1) = 'AAM0008'                      CFT014
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** If transaction type is not linked to transaction code                                CER030
      ** display screen                                                                       CER030
      *                                                                                       CER030
     C                   IF        (CER030 = 'Y') OR                                          CER030
     C                             (CGL013 = 'Y') OR                                          CER030
     C                             (CER031 = 'Y')                                             CER030
      *                                                                                       CER030
     C                   MOVEA     FldNameArr    FldNamXar                                    CER030
     C                   MOVEA     MsgIdArr      MsgIDXAr                                     CER030
      *                                                                                       CER030
     C                   CALLB     'FTIPAY5VL'                                                CER030
      *                                                                                       CER030
      ** INPUT                                                                                CER030
      *                                                                                       CER030
      ** Mode = '*FRONT' (Front Office Transaction Interface)                                 CER030
      ** Mode = '      ' (Not Front Office Transaction Interface)                             CER030
      ** Mode = '*RPR  ' (Repair Function)                                                    CER030
      ** Mode = '*SIN  ' (Screen Input Function)                                              CER030
     C                   PARM                    PMode                                        CER030
      *                                                                                       CER030
      ** Response Mode                                                                        CER030
     C                   PARM                    PResponse                                    CER030
      *                                                                                       CER030
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction                       CER030
      ** - screen format                                                                      CER030
     C                   PARM                    NwIP1ScnFmt                                  CER030
      *                                                                                       CER030
      ** Incoming Payments Margin info from incoming transaction                              CER030
      ** - screen format                                                                      CER030
     C                   PARM                    NwIP6ScnFmt                                  CER030
      *                                                                                       CER030
      ** Incoming Payments Extended Narratives incoming transaction                           CER030
      ** - screen format                                                                      CER030
      *                                                                                       CER030
     C                   PARM                    NwIP6AScnFmt                                 CER030
      *                                                                                       CER030
      ** Incoming Payments Transaction Code from screen 2 level 2 for                         CER030
      ** defaulting value of Retail Transaction Type                                          CER030
      *                                                                                       CER030
     C                   PARM                    DDTTCD                                       CER030
      *                                                                                       CER030
      ** STANDING DATA                                                                        CER030
      *                                                                                       CER030
      ** SDMMOD - Analytical Accounting                                                       CER030
     C                   PARM                    BGN0ST                                       CER030
      *                                                                                       CER030
      ** OUTPUT                                                                               CER030
      ** ======                                                                               CER030
      *                                                                                       CER030
      ** Error fields/message IDs/message data (arrays) from/to caller                        CER030
     C                   PARM                    FldNameArr                                   CER030
     C                   PARM                    MsgIdArr                                     CER030
     C                   PARM                    MsgDtaArr                                    CER030
      *                                                                                       CER030
      ** Array index (3P0) from/to caller                                                     CER030
     C                   PARM                    IDx                                          CER030
      *                                                                                       CER030
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CER030
     C                   PARM                    WFldNamArr                                   CER030
     C                   PARM                    WMsgIdArr                                    CER030
     C                   PARM                    WMsgDtaArr                                   CER030
      *                                                                                       CER030
      ** Array index (3P0) from/to caller                                                     CER030
     C                   PARM                    WIDx                                         CER030
      *                                                                                       CER030
      ** Incoming Payments Margin info error indicators                                       CER030
     C                   PARM                    FTEIPY5                                      CER030
      *                                                                                       CER030
      ** Incoming Payments for file update - file format                                      CER030
     C                   PARM                    NwIPFilFmt                                   CER030
      *                                                                                       CER030
      ** Extension Valid File Value for Transaction code                                      CER030
      *                                                                                       CER030
     C                   PARM                    I2INTTCD                                     CER030
      *                                                                                       CER030
      ** Update error information.                                                            CER030
      *                                                                                       CER030
     C                   IF        IDx <> *ZEROS                                              CER030
      *                                                                                       CER030
     C                   MOVEL     'M'           WScrn                                        CER030
      *                                                                                       CER030
     C                   EVAL      Wk = 1                                                     CER030
     C     *BLANKS       LOOKUP    FldNameArr(Wk)                         92                  CER030
      *                                                                                       CER030
     C                   IF        *IN92 = *ON                                                CER030
     C                   MOVEA     FldNamXar     FldNameArr(Wk)                               CER030
     C                   MOVEA     MsgIDXAr      MsgIdArr(Wk)                                 CER030
     C                   ENDIF                                                                CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C     WScrn         DOWEQ     'M'                                          CFT014
     C                   EXSR      SRScrn_M                                     CFT014
     C                   ENDDO                                                  CFT014
      *                                                                         CFT014
     C                   ELSE
     C/COPY WNCPYSRC,FTIPAYSC29
     C                   MOVEL     'F'           WScrn                          CFT014
      *                                                                                       CSW209
      ** Display Cover message if SWIFT 2009 is ON                                            CSW209
      *                                                                                       CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   EVAL      WScrn = 'N'                                                CSW209
     C                   ENDIF                                                                CSW209
     C/COPY WNCPYSRC,FTIPAYSC30
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ELSE                                                                 256117
     C                   If        Idx > 0                                                    256117
     C                   Eval      WRedisplay = 'Y'                                           256117
     C                   endif                                                                256117
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDSR                                                  CFT014
      *                                                                         CFT014
      *****************************************************************         CFT014
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SRScrn_M - Process Margin information                        *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
      *                                                                         CFT014
     C     SRScrn_M      BEGSR                                                  CFT014
      *                                                                         CFT014
      ** If Action Code is Insert or Amend, enable Detail                       CFT014
      ** fields on Margin info screen                                           CFT014
      ** Also, enable F5=Refresh.                                               CFT014
      *                                                                         CFT014
     C     DDACTN        IFEQ      'I'                                          CFT014
     C     DDACTN        OREQ      'A'                                          CFT014
     C                   MOVEL     'Y'           PEDTFLD                        CFT014
     C                   MOVEL     'Y'           PEINKE                         CFT014
     C                   ELSE                                                   CFT014
     C                   MOVEL     'N'           PEDTFLD                        CFT014
     C                   MOVEL     'N'           PEINKE                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Display Margin information screen                                      CFT014
      *                                                                         CFT014
     C                   CALLB     'FTIPAY5DP'                                  CFT014
     C                   Parm      *BLANKS       RetCodeOut                     CFT014
     C                   PARM                    NwIP1ScnFmt                    CFT014
     C                   PARM                    NwIP6ScnFmt                    CFT014
     C                   PARM                    NwIP6AScnFmt                                 CER030
     C                   PARM                    FTEIPY5                        CFT014
     C                   PARM                    FldNameArr                     CFT014
     C                   PARM                    MsgIdArr                       CFT014
     C                   PARM                    MsgDtaArr                      CFT014
     C                   PARM                    WFldNamArr                     CFT014
     C                   PARM                    WMsgIdArr                      CFT014
     C                   PARM                    WMsgDtaArr                     CFT014
     C                   PARM                    PEDTFLD                        CFT014
     C                   PARM                    PINKC                          CFT014
     C                   PARM                    PINKL                          CFT014
     C                   PARM                    PINKE                          CFT014
     C                   PARM      'N'           PWriteOnly                     CFT014
     C                   PARM                    PRowCol                        CFT014
      *                                                                         CFT014
      ** Reset error fields.                                                    CFT014
      *                                                                         CFT014
     C                   EXSR      SRResetErr                                   CFT014
      *                                                                         CFT014
     C                   SELECT                                                 CFT014
      *                                                                         CFT014
      ** F3 - end program.                                                      CFT014
      *                                                                         CFT014
     C     PINKC         WHENEQ    *ON                                          CFT014
     C                   EXSR      SREndP                                       CFT014
      *                                                                         CFT014
      ** F5 - refresh Margin info                                               CFT014
      *                                                                         CFT014
     C     PINKE         WHENEQ    *ON                                          CFT014
     C                   MOVEL     CrIP6ScnFmt   NwIP6ScnFmt                    CFT014
     C                   MOVEL     CrIP6AScnFmt  NwIP6AScnFmt                                 CER030
      *                                                                         CFT014
      ** F12 - cancel.  Refresh Margin info  and redisplay                      CFT014
      ** Level 2 screen 3.                                                      CFT014
      *                                                                         CFT014
     C     PINKL         WHENEQ    *ON                                          CFT014
     C                   MOVEL     CrIP6ScnFmt   NwIP6ScnFmt                    CFT014
     C                   MOVEL     CrIP6AScnFmt  NwIP6AScnFmt                                 CER030
     C                   MOVEL     'D'           WScrn                          CFT014
      *                                                                         CFT014
      ** Enter key was pressed.                                                 CFT014
      *                                                                         CFT014
     C                   OTHER                                                  CFT014
      *                                                                         CFT014
      ** If Action is Insert or Amend, validate input to                        CFT014
      ** Margin information screen.                                             CFT014
      *                                                                         CFT014
     C     DDACTN        IFEQ      'I'                                          CFT014
     C     DDACTN        OREQ      'A'                                          CFT014
     C                   EXSR      SRVal_M                                      CFT014
     C                   GOTO      EScrn_M                                      CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDSL                                                  CFT014
      *                                                                         CFT014
     C     EScrn_M       ENDSR                                                  CFT014
      *****************************************************************         CFT014
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SRVal_M - Validate Margin information                        *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
      *                                                                         CFT014
     C     SRVal_M       BEGSR                                                  CFT014
      *                                                                         CFT014
     C                   MOVEL     *BLANK        WRedisplay                     CFT014
      *                                                                         CFT014
     C                   CALLB     'FTIPAY5VL'                                  CFT014
      *                             =========                                   CFT014
      ** INPUT                                                                  CFT014
      ** =====                                                                  CFT014
      *                                                                         CFT014
      ** Mode = '*FRONT' (Front Office Transaction Interface)                   CFT014
      ** Mode = '      ' (Not Front Office Transaction Interface)               CFT014
      ** Mode = '*RPR  ' (Repair Function)                                      CFT014
      ** Mode = '*SIN  ' (Screen Input Function)                                CFT014
     C                   PARM                    PMode                          CFT014
      *                                                                         CFT014
      ** Response Mode                                                          CFT014
     C                   PARM                    PResponse                      CFT014
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction         CFT014
      ** - screen format                                                        CFT014
     C                   PARM                    NwIP1ScnFmt                    CFT014
      *                                                                         CFT014
      ** Incoming Payments Margin info from incoming transaction                CFT014
      ** - screen format                                                        CFT014
     C                   PARM                    NwIP6ScnFmt                    CFT014
      *                                                                                       CER030
      ** Incoming Payments Extended Narratives incoming transaction                           CER030
      ** - screen format                                                                      CER030
      *                                                                                       CER030
     C                   PARM                    NwIP6AScnFmt                                 CER030
      *                                                                                       CER030
      ** Incoming Payments Transaction Code from screen 2 level 2 for                         CER030
      ** defaulting value of Retail Transaction Type                                          CER030
      *                                                                                       CER030
     C                   PARM                    DDTTCD                                       CER030
      *                                                                         CFT014
      ** STANDING DATA                                                          CFT014
      ** =============                                                          CFT014
      *                                                                         CFT014
      ** SDMMOD - Analytical Accounting                                         CFT014
     C                   PARM                    BGN0ST                         CFT014
      *                                                                         CFT014
      ** OUTPUT                                                                 CFT014
      ** ======                                                                 CFT014
      *                                                                         CFT014
      ** Error fields/message IDs/message data (arrays) from/to caller          CFT014
     C                   PARM                    FldNameArr                     CFT014
     C                   PARM                    MsgIdArr                       CFT014
     C                   PARM                    MsgDtaArr                      CFT014
      *                                                                         CFT014
      ** Array index (3P0) from/to caller                                       CFT014
     C                   PARM                    IDx                            CFT014
      *                                                                         CFT014
      ** Warning flds/message IDs/message data (arrays) from/to caller          CFT014
     C                   PARM                    WFldNamArr                     CFT014
     C                   PARM                    WMsgIdArr                      CFT014
     C                   PARM                    WMsgDtaArr                     CFT014
      *                                                                         CFT014
      ** Array index (3P0) from/to caller                                       CFT014
     C                   PARM                    WIDx                           CFT014
      *                                                                         CFT014
      ** Incoming Payments Margin info error indicators                         CFT014
     C                   PARM                    FTEIPY5                        CFT014
      *                                                                         CFT014
      ** Incoming Payments for file update - file format                        CFT014
     C                   PARM                    NwIPFilFmt                     CFT014
      *                                                                                       CER030
      ** Extension Valid File Value for Transaction code                                      CER030
      *                                                                                       CER030
     C                   PARM                    I2INTTCD                                     CER030
      *                                                                         CFT014
      ** If no errors occurred during validation of fields on Margin            CFT014
      ** info, check if there are warnings which have not been                  CFT014
      ** displayed yet.                                                         CFT014
      *                                                                         CFT014
     C                   IF        IDx = 0                                      CFT014
      *                                                                         CFT014
     C                   Z-ADD     1             WIx                            CFT014
      *                                                                         CFT014
     C     WIx           DOWLE     WIDx                                         CFT014
     C     WRedisplay    ANDEQ     *BLANK                                       CFT014
     C                   IF        WMsgIdArr(WIx) <> WPrvWarnAr(WIx)            CFT014
     C                   EVAL      WRedisplay = 'Y'                             CFT014
     C                   ELSE                                                   CFT014
     C                   EVAL      WIx =WIx + 1                                 CFT014
     C                   ENDIF                                                  CFT014
     C                   ENDDO                                                  CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** If no errors occurred during validation of Margin info                 CFT014
      ** and if there are no warnings which have not been                       CFT014
      ** displayed, redisplay Level 2 Screen 3.                                 CFT014
      *                                                                         CFT014
     C     IDx           IFEQ      *ZERO                                        CFT014
     C     WRedisplay    ANDEQ     *BLANK                                       CFT014
     C                   MOVEL     'D'           WScrn                          CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDSR                                                  CFT014
      *                                                                         CFT014
      *****************************************************************         CFT014
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrn_W - Process Window screen                             *
      *                                                               *
      *****************************************************************
      *
     C     SRScrn_W      BEGSR
     C/COPY WNCPYSRC,FTIPAYSC31
      *
      ** If entry point is Level 1, display Level 1 screen
      ** without error messages.
      *
     C     PParmLevel    IFEQ      '1'
                                                                                CFT009
     C                   IF        CFT009 = 'Y'                                 CFT009
     C                   MOVE      *ALL'Y'       FTEIPY1                        CFT009
     C                   MOVE      *BLANKS       FldNameArr                     CFT009
     C                   MOVE      *BLANKS       MsgIdArr                       CFT009
     C                   MOVE      *BLANKS       MsgDtaArr                      CFT009
     C                   MOVE      *BLANKS       WFldNamArr                     CFT009
     C                   MOVE      *BLANKS       WMsgIdArr                      CFT009
     C                   MOVE      *BLANKS       WMsgDtaArr                     CFT009
     C                   ENDIF                                                  CFT009
      *
     C                   CALLB     'FTIPAY1DP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 Scrn 1/2 details from incoming trans.          CFT014
      ** - screen format                                                        CFT014
     C                   PARM                    NwIP1aScnFmt                   CFT014
      *
      ** DS for Additional Information details
     C                   PARM                    PAddInfm
      *
      ** SWIFT Reference
     C                   PARM                    DDSWTN
      *
      ** Sequence No.
     C                   PARM                    DDSEQNO
      *
      ** Incoming Payment Status
     C                   PARM                    PStatus
      *
      ** Payment Type
     C                   PARM                    PPYTP
      *
      ** Display Additional Information Screen Indicator
     C                   PARM      'N'           PAddInfo
      *
      ** Enable Detail Fields Indicator
     C                   PARM                    PEDTFLD
      *
      ** Enable Function Keys
      ** KD = Command Key 04 = Prompt
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Delete
      ** KP = Command Key 15 = Browse
      ** KQ = Command Key 16 = Search
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
      ** KV = Command Key 21 = Additional Information Window
     C                   PARM                    PEINKD
     C                   PARM                    PEINKE
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKP
     C                   PARM                    PEINKQ
     C                   PARM                    PEINKS
     C                   PARM                    PEINKV
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write Screen with No Read Indicator
     C                   PARM      'Y'           PWriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDGELR - Profit Centre Used
     C                   PARM                    BKPRCU
      *
      ** SDGELR - Originating Branch Used
     C                   PARM                    BKOBRU
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU FT Settlement Currency Conversion
     C                   PARM                    CEU006
      *
      ** BIC database plus
     C                   PARM                    CFT007
      *
      ** Electronic Banking Interface IATs and TPPs
     C                   PARM                    CGL009
      *                                                                         CFT014
      ** STP Phase 2 MT103 Messages Generation for FT.                          CFT014
     C                   PARM                    CFT014                         CFT014
     C/COPY WNCPYSRC,FTIPAYSC32
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
     C/COPY WNCPYSRC,FTIPAYSC06
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys Enabled
      ** KC = Command Key 03 = Exit
      ** KD = Command Key 04 = Prompt
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Delete
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
      ** KQ = Command Key 16 = Search
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
      ** KV = Command Key 21 = Additional Information Window
     C                   PARM                    PINKC
     C                   PARM                    PINKD
     C                   PARM                    PINKE
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKJ
     C                   PARM                    PINKL
     C                   PARM                    PINKP
     C                   PARM                    PINKQ
     C                   PARM                    PINKS
     C                   PARM                    PINKV
      *
      ** Cursor position
     C                   PARM                    PRowCol
     C                   EXSR      SRResetErr                                                 248631
      *
     C                   ELSE
      *
      ** Else, if entry point is Level 2, display Level 2 screen 1
      ** without error messages.
      *
     C                   CALLB     'FTIPAY2DP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** Payment Reference
     C                   PARM                    DDPREF
      *
      ** Incoming Payments Lvl 2 Scrn 1/1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP2ScnFmt
      *
      ** Incoming Payments Lvl 2 Scrn 1/2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP3ScnFmt
      *
      ** Incoming Payment Status
     C                   PARM                    PStatus
      *
      ** Enable Detail Fields
     C                   PARM                    PEDTFLD
      *
      ** Enable Function Keys
      ** KD = Command Key 04 = Prompt
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KP = Command Key 15 = Browse
      ** KQ = Command Key 16 = Search
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
     C                   PARM                    PEINKD
     C                   PARM                    PEINKE
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKP
     C                   PARM                    PEINKQ
     C                   PARM                    PEINKS
      *
      ** Incoming Payments Lvl 2 Scrn 1 error indicators
     C                   PARM                    FTEIPY2
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write Screen with No Read Indicator
     C                   PARM      'Y'           PWriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** BIC database plus
     C                   PARM                    CFT007
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys Enabled
      ** KC = Command Key 03 = Exit
      ** KD = Command Key 04 = Prompt
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
      ** KQ = Command Key 16 = Search
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
     C                   PARM                    PINKC
     C                   PARM                    PINKD
     C                   PARM                    PINKE
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKL
     C                   PARM                    PINKP
     C                   PARM                    PINKQ
     C                   PARM                    PINKS
      *
      ** Cursor position
     C                   PARM                    PRowCol
      *
     C                   ENDIF
      *
      * Set up Payment Reference                                                              204152
     C     DDACTN        IFEQ      'I'                                                        204152
     C     FirstTime     ANDEQ     'Y'                                                        204152
     C                   EVAL      FirstTime = 'N'                                            204152
     C                   EXSR      SETPAYREF                                                  204152
     C                   ENDIF                                                                204152
      *                                                                                       204152
      /COPY WNCPYSRC,FTIPAYMV1
      *
      ** Call Window Manager.
      *
     C                   CALL      'WN0010'
     C                   PARM      'FTIPAYSIN'   PWPgm            10
     C                   PARM                    PWKey             2
     C                   PARM      DDACTN        PWAction          1
     C                   PARM                    Data
     C                   PARM      *BLANKS       PWRtn             7
     C                   PARM                    PWSpare         256
      *
     C/COPY WNCPYSRC,FTIPAYSC17
     C                   SELECT
      *
      ** F3 - end program.
      *
     C     PWRtn         WHENEQ    'Y2U9999'
     C                   EXSR      SREndP
      *
      ** F12 - cancel.  Display Level 1 screen or Level 2 screen 1.
      *
     C     PWRtn         WHENEQ    'USR0790'
     C     PParmLevel    IFEQ      '1'
     C                   MOVEL     'P'           WScrn
     C                   ELSE
     C                   MOVEL     'S'           WScrn
     C                   ENDIF
      *
      ** Enter key was pressed.
      *
     C                   OTHER
      *
      ** Action is Insert or Amend.
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      ** Entry point is Level 1.
      *
     C     PParmLevel    IFEQ      '1'
      *
      ** If Level 1 is linked with Level 2 or Incoming Payments
      ** Maintenance is called from linked maintenance/enquiry,
      ** display Level 2 screen 1.
      *
     C     BTLVJN        IFEQ      'Y'
     C     PParmLink     OREQ      'Y'
      *
     C                   MOVEL     'S'           WScrn
      *
      ** If Action is Insert, or Action is Amend and Level 2
      ** details have not been entered, default Transfer
      ** Commission Tariff based on Charges Branch.
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     INLVL2        ANDNE     'Y'
     C     PPYBR         CHAIN     PYCHGDB                            01
     C     *IN01         IFEQ      *OFF
     C                   EVAL      DDTRCT = PYDFTRCT
     C     WTRCT         IFNE      *BLANKS                                                    226722
     C                   EVAL      DDTRCT = WTRCT                                             226722
     C                   ENDIF                                                                226722
     C                   MOVEL     NwIP3ScnFmt   CrIP3ScnFmt
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Otherwise, compute Charges and Commissions, and Total
      ** VAT Amounts based on Level 1 details, and display
      ** Confirmation screen.
      *
     C                   IF        CFT009 = 'N'                                 CFT009
     C                   EXSR      SRCCVatL1
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
     C                   MOVEL     'F'           WScrn
      *
     C                   ENDIF
      *
      ** Entry point is Level 2.
      *
     C                   ELSE
     C                   IF        CFT009 = 'N'                                 CFT009
      *
      ** Compute Charges and Commissions, and Total VAT Amounts based on
      ** Level 1 details.
      *
     C                   EXSR      SRCCVatL1
      *
      ** Do defaulting of Charges and Commission details on Level 2
      ** screen 2.
      *
     C                   EXSR      SRCDefault
                                                                                CFT009
     C                   ENDIF                                                  CFT009
      *
      ** Display Level 2 screen 2.
      *
     C                   MOVEL     'C'           WScrn
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Action is Enquire.
      *
     C     DDACTN        IFEQ      'E'
      *
      ** Entry point is Level 1.
      *
     C     PParmlevel    IFEQ      '1'
      *
      ** If Level 1 is linked with Level 2 or Incoming Payments
      ** Maintenance is called from linked maintenance/enquiry,
      ** display Level 2 screen 1.
      *
     C     BTLVJN        IFEQ      'Y'
     C     PParmLink     OREQ      'Y'
      *
     C                   MOVEL     'S'           WScrn
      *
     C                   ELSE
      *
      ** Otherwise, read Next Browse Subfile record or
      ** display Initial screen with blank fields.
      *
     C     PRDNB         IFEQ      'Y'
     C                   MOVEL     'R'           WScrn
     C                   ELSE
     C                   MOVEL     *BLANKS       DDACTN
     C                   MOVEL     *BLANKS       DDPREF
     C                   MOVEL     *BLANKS       DDSWTN
     C                   MOVEL     *BLANKS       DDSEQNO
     C                   MOVEL     *BLANKS       DDBRCA
     C                   MOVEL     'I'           WScrn
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Entry point is Level 2.
      *
     C                   ELSE

     C                   IF        CFT009 = 'N'                                  CFT009
      *
      ** Compute Charges and Commissions, and Total VAT Amounts based on
      ** Level 1 details.
      *
     C                   EXSR      SRCCVatL1
      *
      ** Do defaulting of Charges and Commission details on Level 2
      ** screen 2.
      *
     C                   EXSR      SRCDefault

     C                   ENDIF                                                   CFT009
      *
      ** Display Level 2 screen 2.
      *
     C                   MOVEL     'C'           WScrn
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrn_F - Process Confirmation screen                       *
      *                                                               *
      *****************************************************************
      *
     C     SRScrn_F      BEGSR
      *
      ** Reset error fields, specifically arrays for warning messages.
      *
     C                   EXSR      SRResetErr
      *
      ** Entries are valid or only warnings exist.  Output message
      ** "Press ENTER to apply transaction to database or F12 to change.".
      *
     C                   MOVE      '*ANY'        WFldNamArr(1)
     C                   MOVE      'FTA0119'     WMsgIdArr(1)
      *
      ** If entry point is Level 1, display Level 1 screen.
      *
     C     PParmLevel    IFEQ      '1'
      *
     C                   CALLB     'FTIPAY1DP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 Scrn 1/2 details from incoming trans.          CFT014
      ** - screen format                                                        CFT014
     C                   PARM                    NwIP1aScnFmt                   CFT014
      *
      ** DS for Additional Information details
     C                   PARM                    PAddInfm
      *
      ** SWIFT Reference
     C                   PARM                    DDSWTN
      *
      ** Sequence No.
     C                   PARM                    DDSEQNO
      *
      ** Incoming Payment Status
     C                   PARM                    PStatus
      *
      ** Payment Type
     C                   PARM                    PPYTP
      *
      ** Display Additional Information Screen Indicator
     C                   PARM      'N'           PAddInfo
      *
      ** Enable Detail Fields Indicator
     C                   PARM      'N'           PEDTFLD
      *
      ** Enable Function Keys
      ** KD = Command Key 04 = Prompt
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Delete
      ** KP = Command Key 15 = Browse
      ** KQ = Command Key 16 = Search
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
      ** KV = Command Key 21 = Additional Information Window
     C                   PARM      'N'           PEINKD
     C                   PARM      'N'           PEINKE
     C                   PARM      'N'           PEINKG
     C                   PARM      'N'           PEINKH
     C                   PARM      'N'           PEINKJ
     C                   PARM      'N'           PEINKP
     C                   PARM      'N'           PEINKQ
     C                   PARM      'N'           PEINKS
     C                   PARM      'N'           PEINKV
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write Screen with No Read Indicator
     C                   PARM      'N'           PWriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDGELR - Profit Centre Used
     C                   PARM                    BKPRCU
      *
      ** SDGELR - Originating Branch Used
     C                   PARM                    BKOBRU
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU FT Settlement Currency Conversion
     C                   PARM                    CEU006
      *
      ** BIC database plus
     C                   PARM                    CFT007
      *
      ** Electronic Banking Interface IATs and TPPs
     C                   PARM                    CGL009
      *                                                                         CFT014
      ** STP Phase 2 MT103 Messages Generation for FT.                          CFT014
     C                   PARM                    CFT014                         CFT014
     C/COPY WNCPYSRC,FTIPAYSC33
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
     C/COPY WNCPYSRC,FTIPAYSC07
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys Enabled
      ** KC = Command Key 03 = Exit
      ** KD = Command Key 04 = Prompt
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Delete
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
      ** KQ = Command Key 16 = Search
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
      ** KV = Command Key 21 = Additional Information Window
     C                   PARM                    PINKC
     C                   PARM                    PINKD
     C                   PARM                    PINKE
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKJ
     C                   PARM                    PINKL
     C                   PARM                    PINKP
     C                   PARM                    PINKQ
     C                   PARM                    PINKS
     C                   PARM                    PINKV
      *
      ** Cursor position
     C                   PARM                    PRowCol
      *
      ** Else, if entry point is Level 2, display Level 2
      ** screen 1.
      *
     C                   ELSE
      *
     C                   CALLB     'FTIPAY2DP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** Payment Reference
     C                   PARM                    DDPREF
      *
      ** Incoming Payments Lvl 2 Scrn 1/1 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP2ScnFmt
      *
      ** Incoming Payments Lvl 2 Scrn 1/2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP3ScnFmt
      *
      ** Incoming Payment Status
     C                   PARM                    PStatus
      *
      ** Enable Detail Fields
     C                   PARM      'N'           PEDTFLD
      *
      ** Enable Function Keys
      ** KD = Command Key 04 = Prompt
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KP = Command Key 15 = Browse
      ** KQ = Command Key 16 = Search
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
     C                   PARM      'N'           PEINKD
     C                   PARM      'N'           PEINKE
     C                   PARM      'N'           PEINKG
     C                   PARM      'N'           PEINKH
     C                   PARM      'N'           PEINKP
     C                   PARM      'N'           PEINKQ
     C                   PARM      'N'           PEINKS
      *
      ** Incoming Payments Lvl 2 Scrn 1 error indicators
     C                   PARM                    FTEIPY2
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write Screen with No Read Indicator
     C                   PARM      'N'           PWriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** BIC database plus
     C                   PARM                    CFT007
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys Enabled
      ** KC = Command Key 03 = Exit
      ** KD = Command Key 04 = Prompt
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
      ** KQ = Command Key 16 = Search
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
     C                   PARM                    PINKC
     C                   PARM                    PINKD
     C                   PARM                    PINKE
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKL
     C                   PARM                    PINKP
     C                   PARM                    PINKQ
     C                   PARM                    PINKS
      *
      ** Cursor position
     C                   PARM                    PRowCol
      *
     C                   ENDIF
      *                                                                         CFT009
      ** Clear warning message work inds for charges screen                     CFT009
      *                                                                         CFT009
     C                   IF        PINKL = *ON                                  CFT009
     C                   EVAL      PChgWarn = *BLANKS                           CFT009
     C                   ENDIF                                                  CFT009
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr
      *
     C                   SELECT
      *
      ** F3 - end program.
      *
     C     PINKC         WHENEQ    *ON
     C                   EXSR      SREndP
      *
      ** F12 - cancel.  Display Level 1 screen or Level 2
      ** screen 1.
      *
     C     PINKL         WHENEQ    *ON
     C     PParmLevel    IFEQ      '1'
     C                   MOVEL     'P'           WScrn
     C                   ELSE
     C                   MOVEL     'S'           WScrn
     C                   ENDIF
      *
      ** Enter key was pressed.  Update files.
      *
     C                   OTHER
     C                   MOVEL     'U'           WScrn
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrn_A - Process Additional Information screen             *
      *                                                               *
      *****************************************************************
      *
      ** Display Level 1 screen without error messages.
      *
     C     SRScrn_A      BEGSR
      *
     C                   CALLB     'FTIPAY1DP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 Scrn 1/2 details from incoming trans.          CFT014
      ** - screen format                                                        CFT014
     C                   PARM                    NwIP1aScnFmt                   CFT014
      *
      ** DS for Additional Information details
     C                   PARM                    PAddInfm
      *
      ** SWIFT Reference
     C                   PARM                    DDSWTN
      *
      ** Sequence No.
     C                   PARM                    DDSEQNO
      *
      ** Incoming Payment Status
     C                   PARM                    PStatus
      *
      ** Payment Type
     C                   PARM                    PPYTP
      *
      ** Display Additional Information Screen Indicator
     C                   PARM      'Y'           PAddInfo
      *
      ** Enable Detail Fields Indicator
     C                   PARM                    PEDTFLD
      *
      ** Enable Function Keys
      ** KD = Command Key 04 = Prompt
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Delete
      ** KP = Command Key 15 = Browse
      ** KQ = Command Key 16 = Search
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
      ** KV = Command Key 21 = Additional Information Window
     C                   PARM                    PEINKD
     C                   PARM                    PEINKE
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKP
     C                   PARM                    PEINKQ
     C                   PARM                    PEINKS
     C                   PARM                    PEINKV
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write Screen with No Read Indicator
     C                   PARM      'Y'           PWriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDGELR - Profit Centre Used
     C                   PARM                    BKPRCU
      *
      ** SDGELR - Originating Branch Used
     C                   PARM                    BKOBRU
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU FT Settlement Currency Conversion
     C                   PARM                    CEU006
      *
      ** BIC database plus
     C                   PARM                    CFT007
      *
      ** Electronic Banking Interface IATs and TPPs
     C                   PARM                    CGL009
      *                                                                         CFT014
      ** STP Phase 2 MT103 Messages Generation for FT.                          CFT014
     C                   PARM                    CFT014                         CFT014
     C/COPY WNCPYSRC,FTIPAYSC34
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
     C/COPY WNCPYSRC,FTIPAYSC08
      *
      ** OUTPUT
      ** ======
      *
      ** Function Keys Enabled
      ** KC = Command Key 03 = Exit
      ** KD = Command Key 04 = Prompt
      ** KE = Command Key 05 = Refresh
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Delete
      ** KL = Command Key 12 = Cancel
      ** KP = Command Key 15 = Browse
      ** KQ = Command Key 16 = Search
      ** KS = Command Key 18 = Next Payment (from linked enquiry)
      ** KV = Command Key 21 = Additional Information Window
     C                   PARM                    PINKC
     C                   PARM                    PINKD
     C                   PARM                    PINKE
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKJ
     C                   PARM                    PINKL
     C                   PARM                    PINKP
     C                   PARM                    PINKQ
     C                   PARM                    PINKS
     C                   PARM                    PINKV
      *
      ** Cursor position
     C                   PARM                    PRowCol
      *
     C                   SELECT
      *
      ** F3 - end program.
      *
     C     PINKC         WHENEQ    *ON
     C                   EXSR      SREndP
      *
      ** F12 - cancel.  Return to Level 1 screen.
      *
     C     PINKL         WHENEQ    *ON
     C                   MOVEL     'P'           WScrn
      *
      ** Enter key was pressed.  Return to Level 1 screen.
      *
     C                   OTHER
     C                   MOVEL     'P'           WScrn
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT                                                                                  CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      *  SRScrn_N - Process Level 2 screen 7                          *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
      *                                                                                       CSW209
     C     SRScrn_N      BEGSR                                                                CSW209
      *                                                                                       CSW209
      ** If Action Code is Insert or Amend, enable Detail                                     CSW209
      ** fields on Level 2 screen 7 (all fields on Level 2                                    CSW209
      ** screen 7 except Action Code and Payment Reference).                                  CSW209
      *                                                                                       CSW209
     C                   IF        DDACTN = 'I' OR                                            CSW209
     C                             DDACTN = 'A'                                               CSW209
     C                   EVAL      PEDTFLD = 'Y'                                              CSW209
     C                   ELSE                                                                 CSW209
     C                   EVAL      PEDTFLD = 'N'                                              CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Incoming Payments Maintenance has been called by linked                              CSW209
      ** maintenance/enquiry.                                                                 CSW209
      *                                                                                       CSW209
     C                   IF        PParmLink = 'Y'                                            CSW209
      *                                                                                       CSW209
      ** Disable F7=Read Previous, F8=Read Next and F15=Browse.                               CSW209
      *                                                                                       CSW209
     C                   EVAL      PEINKG = 'N'                                               CSW209
     C                   EVAL      PEINKH = 'N'                                               CSW209
     C                   EVAL      PEINKP = 'N'                                               CSW209
      *                                                                                       CSW209
     C                   ELSE                                                                 CSW209
      *                                                                                       CSW209
     C                   EVAL      PEINKG = 'Y'                                               CSW209
     C                   EVAL      PEINKH = 'Y'                                               CSW209
     C                   EVAL      PEINKP = 'Y'                                               CSW209
      *                                                                                       CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Display Level 2 screen 7.                                                            CSW209
      *                                                                                       CSW209
     C                   CALL      'FTIPAY7DP'                                                CSW209
      *                                                                                       CSW209
      ** INPUT                                                                                CSW209
      ** =====                                                                                CSW209
      *                                                                                       CSW209
      ** Return Code                                                                          CSW209
     C                   PARM      *BLANKS       RetCodeOut                                   CSW209
      *                                                                                       CSW209
      ** Action Code                                                                          CSW209
     C                   PARM                    DDACTN                                       CSW209
      *                                                                                       CSW209
      ** Payment Reference                                                                    CSW209
     C                   PARM                    DDPREF                                       CSW209
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 7 from transaction - screen format                      CSW209
     C                   PARM                    NwIP7ScnFmt                                  CSW209
      *                                                                                       CSW209
      ** Incoming Payments for file update - file format                                      CSW209
     C                   PARM                    NwIPFilFmt                                   CSW209
      *                                                                                       CSW209
      ** Incoming Payment Status                                                              CSW209
     C                   PARM                    PStatus                                      CSW209
      *                                                                                       CSW209
      ** Enable Detail Fields                                                                 CSW209
     C                   PARM                    PEDTFLD                                      CSW209
      *                                                                                       CSW209
      ** Enable Function Keys                                                                 CSW209
      ** KG = Command Key 07 = Read Previous                                                  CSW209
      ** KH = Command Key 08 = Read Next                                                      CSW209
      ** KP = Command Key 15 = Browse                                                         CSW209
     C                   PARM                    PEINKG                                       CSW209
     C                   PARM                    PEINKH                                       CSW209
     C                   PARM                    PEINKP                                       CSW209
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 7 error indicators                                      CSW209
     C                   PARM                    FTEIPY7                                      CSW209
      *                                                                                       CSW209
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW209
     C                   PARM                    FldNameArr                                   CSW209
     C                   PARM                    MsgIdArr                                     CSW209
     C                   PARM                    MsgDtaArr                                    CSW209
      *                                                                                       CSW209
      ** Warning fields/message Ids/message data (arrays) from/to                             CSW209
      ** caller                                                                               CSW209
     C                   PARM                    WFldNamArr                                   CSW209
     C                   PARM                    WMsgIdArr                                    CSW209
     C                   PARM                    WMsgDtaArr                                   CSW209
      *                                                                                       CSW209
      ** Write Screen with No Read Indicator                                                  CSW209
     C                   PARM      'N'           PWriteOnly                                   CSW209
      *                                                                                       CSW209
      ** STANDING DATA                                                                        CSW209
      ** =============                                                                        CSW209
      *                                                                                       CSW209
      ** SDBANK - System Runday                                                               CSW209
     C                   PARM                    BJMRDT                                       CSW209
      *                                                                                       CSW209
      ** SDBANK - Default branch code                                                         CSW209
     C                   PARM                    BJSBRC                                       CSW209
      *                                                                                       CSW209
      ** OUTPUT                                                                               CSW209
      ** ======                                                                               CSW209
      *                                                                                       CSW209
      ** Function Keys Enabled                                                                CSW209
      ** KC = Command Key 03 = Exit                                                           CSW209
      ** KG = Command Key 07 = Read Previous                                                  CSW209
      ** KH = Command Key 08 = Read Next                                                      CSW209
      ** KL = Command Key 12 = Cancel                                                         CSW209
      ** KP = Command Key 15 = Browse                                                         CSW209
     C                   PARM                    PINKC                                        CSW209
     C                   PARM                    PINKG                                        CSW209
     C                   PARM                    PINKH                                        CSW209
     C                   PARM                    PINKL                                        CSW209
     C                   PARM                    PINKP                                        CSW209
      *                                                                                       CSW209
      ** Save Warning Message Ids array of Level 2 screen 7.                                  CSW209
      *                                                                                       CSW209
     C                   MOVEL     WMsgIDArr     WPrvWarnAr                                   CSW209
      *                                                                                       CSW209
      ** Reset error fields.                                                                  CSW209
      *                                                                                       CSW209
     C                   EXSR      SRResetErr                                                 CSW209
      *                                                                                       CSW209
     C                   SELECT                                                               CSW209
      *                                                                                       CSW209
      ** F3 - end program.                                                                    CSW209
      *                                                                                       CSW209
     C     PINKC         WHENEQ    *ON                                                        CSW209
     C                   EXSR      SREndP                                                     CSW209
      *                                                                                       CSW209
      ** F7 - roll backwards.                                                                 CSW209
      *                                                                                       CSW209
     C     PINKG         WHENEQ    *ON                                                        CSW209
     C                   EXSR      SRRoll                                                     CSW209
      *                                                                                       CSW209
      ** F8 - roll forwards.                                                                  CSW209
      *                                                                                       CSW209
     C     PINKH         WHENEQ    *ON                                                        CSW209
     C                   EXSR      SRRoll                                                     CSW209
      *                                                                                       CSW209
      ** F12 - cancel.  Refresh Level 2 screen 7 and redisplay                                CSW209
      ** Level 2 screen 4.                                                                    CSW209
      *                                                                                       CSW209
     C     PINKL         WHENEQ    *ON                                                        CSW209
     C                   MOVEL     CrIP7ScnFmt   NwIP7ScnFmt                                  CSW209
     C                   MOVEL     'D'           WScrn                                        CSW209
      *                                                                                       CSW209
      ** F15 - build Browse.                                                                  CSW209
      *                                                                                       CSW209
     C     PINKP         WHENEQ    *ON                                                        CSW209
     C                   EXSR      SRBldBrw                                                   CSW209
      *                                                                                       CSW209
      ** Enter key was pressed.                                                               CSW209
      *                                                                                       CSW209
     C                   OTHER                                                                CSW209
      *                                                                                       CSW209
      ** If Action is Insert or Amend, validate input to                                      CSW209
      ** Level 2 screen 7.                                                                    CSW209
      *                                                                                       CSW209
     C                   IF        DDACTN = 'I' OR                                            CSW209
     C                             DDACTN = 'A'                                               CSW209
      *                                                                                       CSW209
     C                   EXSR      SRVal_N                                                    CSW209
      *                                                                                       CSW209
     C                   ELSE                                                                 CSW209
     C                   EVAL      WScrn = 'O'                                                CSW209
      *                                                                                       CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   ENDSL                                                                CSW209
      *                                                                                       CSW209
     C                   ENDSR                                                                CSW209
      *****************************************************************                       CSW209
      /EJECT                                                                                  CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      *  SRScrn_O - Process Level 2 screen 8                          *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
      *                                                                                       CSW209
     C     SRScrn_O      BEGSR                                                                CSW209
      *                                                                                       CSW209
      ** If Action Code is Insert or Amend, enable Detail                                     CSW209
      ** fields on Level 2 screen 8 (all fields on Level 2                                    CSW209
      ** screen 8 except Action Code and Payment Reference).                                  CSW209
      *                                                                                       CSW209
     C                   IF        DDACTN = 'I' OR                                            CSW209
     C                             DDACTN = 'A'                                               CSW209
     C                   EVAL      PEDTFLD = 'Y'                                              CSW209
     C                   ELSE                                                                 CSW209
     C                   EVAL      PEDTFLD = 'N'                                              CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Incoming Payments Maintenance has been called by linked                              CSW209
      ** maintenance/enquiry.                                                                 CSW209
      *                                                                                       CSW209
     C                   IF        PParmLink = 'Y'                                            CSW209
      *                                                                                       CSW209
      ** Disable F7=Read Previous, F8=Read Next and F15=Browse.                               CSW209
      *                                                                                       CSW209
     C                   EVAL      PEINKG = 'N'                                               CSW209
     C                   EVAL      PEINKH = 'N'                                               CSW209
     C                   EVAL      PEINKP = 'N'                                               CSW209
      *                                                                                       CSW209
     C                   ELSE                                                                 CSW209
      *                                                                                       CSW209
     C                   EVAL      PEINKG = 'Y'                                               CSW209
     C                   EVAL      PEINKH = 'Y'                                               CSW209
     C                   EVAL      PEINKP = 'Y'                                               CSW209
      *                                                                                       CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Display Level 2 screen 8.                                                            CSW209
      *                                                                                       CSW209
     C                   CALL      'FTIPAY8DP'                                                CSW209
      *                                                                                       CSW209
      ** INPUT                                                                                CSW209
      ** =====                                                                                CSW209
      *                                                                                       CSW209
      ** Return Code                                                                          CSW209
     C                   PARM      *BLANKS       RetCodeOut                                   CSW209
      *                                                                                       CSW209
      ** Action Code                                                                          CSW209
     C                   PARM                    DDACTN                                       CSW209
      *                                                                                       CSW209
      ** Payment Reference                                                                    CSW209
     C                   PARM                    DDPREF                                       CSW209
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 8 from transaction - screen format                      CSW209
     C                   PARM                    NwIP8ScnFmt                                  CSW209
      *                                                                                       CSW209
      ** Incoming Payments for file update - file format                                      CSW209
     C                   PARM                    NwIPFilFmt                                   CSW209
      *                                                                                       CSW209
      ** Incoming Payment Status                                                              CSW209
     C                   PARM                    PStatus                                      CSW209
      *                                                                                       CSW209
      ** Enable Detail Fields                                                                 CSW209
     C                   PARM                    PEDTFLD                                      CSW209
      *                                                                                       CSW209
      ** Enable Function Keys                                                                 CSW209
      ** KG = Command Key 07 = Read Previous                                                  CSW209
      ** KH = Command Key 08 = Read Next                                                      CSW209
      ** KP = Command Key 15 = Browse                                                         CSW209
     C                   PARM                    PEINKG                                       CSW209
     C                   PARM                    PEINKH                                       CSW209
     C                   PARM                    PEINKP                                       CSW209
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 8 error indicators                                      CSW209
     C                   PARM                    FTEIPY8                                      CSW209
      *                                                                                       CSW209
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW209
     C                   PARM                    FldNameArr                                   CSW209
     C                   PARM                    MsgIdArr                                     CSW209
     C                   PARM                    MsgDtaArr                                    CSW209
      *                                                                                       CSW209
      ** Warning fields/message Ids/message data (arrays) from/to                             CSW209
      ** caller                                                                               CSW209
     C                   PARM                    WFldNamArr                                   CSW209
     C                   PARM                    WMsgIdArr                                    CSW209
     C                   PARM                    WMsgDtaArr                                   CSW209
      *                                                                                       CSW209
      ** Write Screen with No Read Indicator                                                  CSW209
     C                   PARM      'N'           PWriteOnly                                   CSW209
      *                                                                                       CSW209
      ** STANDING DATA                                                                        CSW209
      ** =============                                                                        CSW209
      *                                                                                       CSW209
      ** SDBANK - System Runday                                                               CSW209
     C                   PARM                    BJMRDT                                       CSW209
      *                                                                                       CSW209
      ** SDBANK - Default branch code                                                         CSW209
     C                   PARM                    BJSBRC                                       CSW209
      *                                                                                       CSW209
      ** OUTPUT                                                                               CSW209
      ** ======                                                                               CSW209
      *                                                                                       CSW209
      ** Function Keys Enabled                                                                CSW209
      ** KC = Command Key 03 = Exit                                                           CSW209
      ** KG = Command Key 07 = Read Previous                                                  CSW209
      ** KH = Command Key 08 = Read Next                                                      CSW209
      ** KL = Command Key 12 = Cancel                                                         CSW209
      ** KP = Command Key 15 = Browse                                                         CSW209
     C                   PARM                    PINKC                                        CSW209
     C                   PARM                    PINKG                                        CSW209
     C                   PARM                    PINKH                                        CSW209
     C                   PARM                    PINKL                                        CSW209
     C                   PARM                    PINKP                                        CSW209
      *                                                                                       CSW209
      ** Save Warning Message Ids array of Level 2 screen 8.                                  CSW209
      *                                                                                       CSW209
     C                   MOVEL     WMsgIDArr     WPrvWarnAr                                   CSW209
      *                                                                                       CSW209
      ** Reset error fields.                                                                  CSW209
      *                                                                                       CSW209
     C                   EXSR      SRResetErr                                                 CSW209
      *                                                                                       CSW209
     C                   SELECT                                                               CSW209
      *                                                                                       CSW209
      ** F3 - end program.                                                                    CSW209
      *                                                                                       CSW209
     C     PINKC         WHENEQ    *ON                                                        CSW209
     C                   EXSR      SREndP                                                     CSW209
      *                                                                                       CSW209
      ** F7 - roll backwards.                                                                 CSW209
      *                                                                                       CSW209
     C     PINKG         WHENEQ    *ON                                                        CSW209
     C                   EXSR      SRRoll                                                     CSW209
      *                                                                                       CSW209
      ** F8 - roll forwards.                                                                  CSW209
      *                                                                                       CSW209
     C     PINKH         WHENEQ    *ON                                                        CSW209
     C                   EXSR      SRRoll                                                     CSW209
      *                                                                                       CSW209
      ** F12 - cancel.  Refresh Level 2 screen 8 and redisplay                                CSW209
      ** Level 2 screen 7.                                                                    CSW209
      *                                                                                       CSW209
     C     PINKL         WHENEQ    *ON                                                        CSW209
     C                   MOVEL     CrIP8ScnFmt   NwIP8ScnFmt                                  CSW209
     C                   MOVEL     'N'           WScrn                                        CSW209
      *                                                                                       CSW209
      ** F15 - build Browse.                                                                  CSW209
      *                                                                                       CSW209
     C     PINKP         WHENEQ    *ON                                                        CSW209
     C                   EXSR      SRBldBrw                                                   CSW209
      *                                                                                       CSW209
      ** Enter key was pressed.                                                               CSW209
      *                                                                                       CSW209
     C                   OTHER                                                                CSW209
      *                                                                                       CSW209
      ** If Action is Insert or Amend, validate input to                                      CSW209
      ** Level 2 screen 8.                                                                    CSW209
      *                                                                                       CSW209
     C                   IF        DDACTN = 'I' OR                                            CSW209
     C                             DDACTN = 'A'                                               CSW209
      *                                                                                       CSW209
     C                   EXSR      SRVal_O                                                    CSW209
     C                   LEAVESR                                                              CSW209
      *                                                                                       CSW209
     C                   ELSE                                                                 CSW209
     C                   EVAL      WScrn = 'F'                                                CSW209
      *                                                                                       CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** If Incoming Payments Maintenance has been called by                                  CSW209
      ** linked maintenance/enquiry, terminate program.                                       CSW209
      *                                                                                       CSW209
     C                   IF        PParmLink = 'Y'                                            CSW209
     C                   MOVEL     *BLANK        PParmRtcd                                    CSW209
     C                   MOVEL     'T'           WScrn                                        CSW209
     C                   LEAVESR                                                              CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Read Next Browse Subfile record.                                                     CSW209
      *                                                                                       CSW209
     C                   IF        PRDNB = 'Y'                                                CSW209
     C                   MOVEL     'R'           WScrn                                        CSW209
     C                   LEAVESR                                                              CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Otherwise, display Initial screen with blank fields.                                 CSW209
      *                                                                                       CSW209
     C                   MOVEL     *BLANKS       DDACTN                                       CSW209
     C                   MOVEL     *BLANKS       DDPREF                                       CSW209
     C                   MOVEL     *BLANKS       DDSWTN                                       CSW209
     C                   MOVEL     *BLANKS       DDSEQNO                                      CSW209
     C                   MOVEL     *BLANKS       DDBRCA                                       CSW209
     C                   MOVEL     'I'           WScrn                                        CSW209
      *                                                                                       CSW209
     C                   ENDSL                                                                CSW209
      *                                                                                       CSW209
     C                   ENDSR                                                                CSW209
      *****************************************************************                       CSW209
      /EJECT                                                                                  CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      *  SRVal_N - Validate input to Level 2 screen 7                 *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
      *                                                                                       CSW209
     C     SRVal_N       BEGSR                                                                CSW209
      *                                                                                       CSW209
     C                   CALLB     'FTIPAY7VL'                                                CSW209
      *                             =========                                                 CSW209
      ** INPUT                                                                                CSW209
      ** =====                                                                                CSW209
      *                                                                                       CSW209
      ** Mode = '*FRONT' (Front Office Transaction Interface)                                 CSW209
      ** Mode = '      ' (Not Front Office Transaction Interface)                             CSW209
      ** Mode = '*RPR  ' (Repair Function)                                                    CSW209
      ** Mode = '*SIN  ' (Screen Input Function)                                              CSW209
     C                   PARM                    PMode                                        CSW209
      *                                                                                       CSW209
      ** Incoming Payments details from incoming transaction                                  CSW209
      ** - screen format                                                                      CSW209
     C                   PARM                    NwIPFilFmt                                   CSW209
     C                   PARM                    NwIP2ScnFmt                                  CSW209
     C                   PARM                    NwIP4ScnFmt                                  CSW209
     C                   PARM                    NwIP7ScnFmt                                  CSW209
      *                                                                                       CSW209
      ** OUTPUT                                                                               CSW209
      ** ======                                                                               CSW209
      *                                                                                       CSW209
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW209
     C                   PARM                    FldNameArr                                   CSW209
     C                   PARM                    MsgIdArr                                     CSW209
     C                   PARM                    MsgDtaArr                                    CSW209
      *                                                                                       CSW209
      ** Array index (3P0) from/to caller                                                     CSW209
     C                   PARM                    Idx                                          CSW209
      *                                                                                       CSW209
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CSW209
     C                   PARM                    WFldNamArr                                   CSW209
     C                   PARM                    WMsgIdArr                                    CSW209
     C                   PARM                    WMsgDtaArr                                   CSW209
      *                                                                                       CSW209
      ** Array index (3P0) from/to caller                                                     CSW209
     C                   PARM                    WIDx                                         CSW209
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 7 error indicators                                      CSW209
     C                   PARM                    FTEIPY7                                      CSW209
      *                                                                                       CSW209
      ** Incoming Payments (additional details) for file update                               CSW209
     C                   PARM                    NwIP2FilFmt                                  CSW209
      *                                                                                       CSW209
      ** If no errors occurred during validation of fields on Level 2                         CSW209
      ** screen 7, check if there are warnings which have not been                            CSW209
      ** displayed yet.                                                                       CSW209
      *                                                                                       CSW209
     C                   EVAL      WRedisplay = ' '                                           CSW209
     C                   Z-ADD     1             WIx                                          CSW209
      *                                                                                       CSW209
     C     WIx           DOWLE     WIDx                                                       CSW209
     C     WRedisplay    ANDEQ     *BLANK                                                     CSW209
     C                   IF        WMsgIdArr(WIx) <> WPrvWarnAr(WIx)                          CSW209
     C                   EVAL      WRedisplay = 'Y'                                           CSW209
     C                   ELSE                                                                 CSW209
     C                   EVAL      WIx =WIx + 1                                               CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDDO                                                                CSW209
      *                                                                                       CSW209
      ** If no warnings which haven't been displayed then replace                             CSW209
      ** any previous warnings (W) with ok (Y).                                               CSW209
      *                                                                                       CSW209
     C                   IF        WRedisplay <> 'Y'                                          CSW209
     C                   EVAL      *IN81 = *ON                                                CSW209
                                                                                              CSW209
     C                   DOW       *IN81 = *ON                                                CSW209
     C     'W'           SCAN      FTEIPY7:1     @P                3 0    81                  CSW209
                                                                                              CSW209
     C     *IN81         IFEQ      *ON                                                        CSW209
     C                   EVAL      %SUBST(FTEIPY7:@P:1) = 'Y'                                 CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   ENDDO                                                                CSW209
                                                                                              CSW209
      ** Clear warnings so it will not be displayed on the next screen                        CSW209
     C                   EVAL      WMsgIdArr = *BLANKS                                        CSW209
                                                                                              CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** If no errors occurred during validation of Level 2                                   CSW209
      ** screen 7 and if there are no warnings which have not been                            CSW209
      ** displayed, display Cover Message screen 2.                                           CSW209
      *                                                                                       CSW209
     C     IDx           IFEQ      *ZERO                                                      CSW209
     C     WRedisplay    ANDEQ     *BLANK                                                     CSW209
     C                   MOVEL     'O'           WScrn                                        CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   ENDSR                                                                CSW209
      *                                                                                       CSW209
      *****************************************************************                       CSW209
      /EJECT                                                                                  CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      *  SRVal_O - Validate input to Level 2 screen 8                 *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
      *                                                                                       CSW209
     C     SRVal_O       BEGSR                                                                CSW209
      *                                                                                       CSW209
     C                   CALLB     'FTIPAY8VL'                                                CSW209
      *                             =========                                                 CSW209
      ** INPUT                                                                                CSW209
      ** =====                                                                                CSW209
      *                                                                                       CSW209
      ** Mode = '*FRONT' (Front Office Transaction Interface)                                 CSW209
      ** Mode = '      ' (Not Front Office Transaction Interface)                             CSW209
      ** Mode = '*RPR  ' (Repair Function)                                                    CSW209
      ** Mode = '*SIN  ' (Screen Input Function)                                              CSW209
     C                   PARM                    PMode                                        CSW209
      *                                                                                       CSW209
      ** Incoming Payments details from incoming transaction                                  CSW209
      ** - screen format                                                                      CSW209
     C                   PARM                    NwIP7ScnFmt                                  CSW209
     C                   PARM                    NwIP8ScnFmt                                  CSW209
      *                                                                                       CSW209
      ** OUTPUT                                                                               CSW209
      ** ======                                                                               CSW209
      *                                                                                       CSW209
      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW209
     C                   PARM                    FldNameArr                                   CSW209
     C                   PARM                    MsgIdArr                                     CSW209
     C                   PARM                    MsgDtaArr                                    CSW209
      *                                                                                       CSW209
      ** Array index (3P0) from/to caller                                                     CSW209
     C                   PARM                    Idx                                          CSW209
      *                                                                                       CSW209
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CSW209
     C                   PARM                    WFldNamArr                                   CSW209
     C                   PARM                    WMsgIdArr                                    CSW209
     C                   PARM                    WMsgDtaArr                                   CSW209
      *                                                                                       CSW209
      ** Array index (3P0) from/to caller                                                     CSW209
     C                   PARM                    WIDx                                         CSW209
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 7 error indicators                                      CSW209
     C                   PARM                    FTEIPY8                                      CSW209
      *                                                                                       CSW209
      ** Incoming Payments (additional details) for file update                               CSW209
     C                   PARM                    NwIP2FilFmt                                  CSW209
      *                                                                                       CSW209
      ** If no errors occurred during validation of fields on Level 2                         CSW209
      ** screen 7, check if there are warnings which have not been                            CSW209
      ** displayed yet.                                                                       CSW209
      *                                                                                       CSW209
      *                                                                                       CSW209
     C                   EVAL      WRedisplay = ' '                                           CSW209
     C                   Z-ADD     1             WIx                                          CSW209
      *                                                                                       CSW209
     C     WIx           DOWLE     WIDx                                                       CSW209
     C     WRedisplay    ANDEQ     *BLANK                                                     CSW209
     C                   IF        WMsgIdArr(WIx) <> WPrvWarnAr(WIx)                          CSW209
     C                   EVAL      WRedisplay = 'Y'                                           CSW209
     C                   ELSE                                                                 CSW209
     C                   EVAL      WIx =WIx + 1                                               CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDDO                                                                CSW209
      *                                                                                       CSW209
      ** If no warnings which haven't been displayed then replace                             CSW209
      ** any previous warnings (W) with ok (Y).                                               CSW209
      *                                                                                       CSW209
     C                   IF        WRedisplay <> 'Y'                                          CSW209
     C                   EVAL      *IN81 = *ON                                                CSW209
                                                                                              CSW209
     C                   DOW       *IN81 = *ON                                                CSW209
     C     'W'           SCAN      FTEIPY8:1     @P                3 0    81                  CSW209
                                                                                              CSW209
     C     *IN81         IFEQ      *ON                                                        CSW209
     C                   EVAL      %SUBST(FTEIPY8:@P:1) = 'Y'                                 CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   ENDDO                                                                CSW209
                                                                                              CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** If no errors occurred during validation of Level 2                                   CSW209
      ** screen 8 and if there are no warnings which have not been                            CSW209
      ** displayed, display Confirmation screen.                                              CSW209
      *                                                                                       CSW209
     C     IDx           IFEQ      *ZERO                                                      CSW209
     C     WRedisplay    ANDEQ     *BLANK                                                     CSW209
     C                   MOVEL     'F'           WScrn                                        CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   ENDSR                                                                CSW209
      *                                                                                       CSW209
      *****************************************************************                       CSW209
      /EJECT                                                                                  204152
      *****************************************************************                       204152
      *                                                               *                       204152
      *  SETPAYREF - Set up Payment Reference                         *                       204152
      *                                                               *                       204152
      *****************************************************************                       204152
      *                                                                                       204152
     C     SETPAYREF     BEGSR                                                                204152
      *                                                                                       204152
      ** Initialise variables used in determining successful                                  204152
      ** insert of an Incoming Payment.                                                       204152
      *                                                                                       204152
     C                   MOVE      *BLANKS       WPREFI           15                          204152
     C                   MOVE      *BLANK        WInsert           1                          204152
      *                                                                                       204152
      ** Update Incoming Payments data area with next                                         204152
      ** Sequence Number.                                                                     204152
      *                                                                                       204152
     C                   IF        CFT151 = 'N'                                               CFT151
     C     *DTAARA       DEFINE    INPAYDA       WINPAY                                       204152
     C     *LOCK         IN        WINPAY                                                     204152
     C                   Z-ADD     WINSQ         WWINSQ            4 0                        204152
     C**********         ADD       1             WINSQ                                204152 BUG4776
     C                   ADD       1             WINSQ                                        260326
     C                   OUT       WINPAY                                                     204152
     C                   ELSE                                                                 CFT151
     C                   CALL      'FT000328'                                                 CFT151
     C                   PARM                    PRTCD                                        CFT151
     C                   PARM      'IN'          W@OTIN            2                          CFT151
     C                   PARM      'A'           WCALC                                        CFT151
     C                   PARM      'Y'           WUPD              1                          CFT151
     C                   PARM                    WWINSQT           4                          CFT151
     C                   PARM                    WNEWSQ                                       CFT151
     C                   END                                                                  CFT151
      *                                                                                       204152
      ** Record Id.                                                                           204152
      *                                                                                       204152
     C                   MOVEL     'D'           IPRECI                                       204152
      *                                                                                       204152
      ** Payment Type.                                                                        204152
      *                                                                                       204152
     C                   EVAL      IPPYTP = 'IN'                                              204152
      *                                                                                       204152
      ** Original Entry Dates.                                                                204152
      *                                                                                       204152
     C                   Z-ADD     BJRDNB        PDayNo                                       204152
      *                                                                                       204152
     C                   CALLB     'ZDATE2'                                                   204152
     C                   PARM                    PDayNo                                       204152
     C                   PARM      BJDFIN        PFMT                                         204152
     C                   PARM      *ZERO         PDate                                        204152
     C                   PARM      *BLANKS       PADate                                       204152
      *                                                                                       204152
     C                   Z-ADD     BJRDNB        IPOEDT                                       204152
     C                   Z-ADD     PDate         IPOEDTD1                                     204152
      *                                                                                       204152
     C                   MOVE      PDate         WN2               2 0                        204152
     C     WN2           IFLT      72                                                         204152
     C                   Z-ADD     20            IPOEDTD2                                     204152
     C                   ELSE                                                                 204152
     C                   Z-ADD     19            IPOEDTD2                                     204152
     C                   ENDIF                                                                204152
      *                                                                                       204152
     C                   MOVEL     PDate         WA4               4                          204152
     C     BJDFIN        IFNE      'M'                                                        204152
     C                   MOVEL     WA4           WA2               2                          204152
     C                   MOVE      WA4           WA2A              2                          204152
     C                   MOVEL     WA2A          WA4                                          204152
     C                   MOVE      WA2           WA4                                          204152
     C                   ENDIF                                                                204152
      *                                                                                       204152
     C                   MOVE      PDate         WA2                                          204152
     C                   MOVEL     WA2           PDate                                        204152
     C                   MOVE      WA4           PDate                                        204152
     C                   Z-ADD     PDate         IPOEDTD3                                     204152
      *                                                                                       204152
      ** New Payment Reference.                                                               204152
      *                                                                                       204152
     C                   IF        (CSC011 = 'Y') AND (LIBR = S1SUPP)                         204152
     C                   Z-ADD     WPRDTE        PDAYNO                                       204152
     C                   CALLB     'ZDATE2'                                                   204152
     C                   PARM                    PDAYNO                                       204152
     C                   PARM      BJDFIN        PFMT                                         204152
     C                   PARM      *ZERO         PPRDATE                                      204152
     C                   PARM      *BLANKS       PPRADATE                                     204152
      *                                                                                       204152
     C                   MOVEL     PPRDATE       WA4                                          204152
     C     BJDFIN        IFNE      'M'                                                        204152
     C                   MOVEL     WA4           WA2                                          204152
     C                   MOVE      WA4           WA2A                                         204152
     C                   MOVEL     WA2A          WA4                                          204152
     C                   MOVE      WA2           WA4                                          204152
     C                   ENDIF                                                                204152
      *                                                                                       204152
     C                   MOVE      PPRDATE       WA2                                          204152
     C                   MOVEL     WA2           PPRDATE                                      204152
     C                   MOVE      WA4           PPRDATE                                      204152
     C                   MOVE      PPRDATE       WA6                                          204152
     C                   ELSE                                                                 204152
     C                   MOVE      PDate         WA6               6                          204152
     C                   ENDIF                                                                204152
     C                   IF        CFT151  = 'N'                                              CFT151
     C                   MOVE      WWINSQ        WA4                                          204152
     C                   ELSE                                                                 CFT151
     C                   MOVE      WWINSQT       WA4                                          CFT151
     C                   END                                                                  CFT151
     C                   MOVE      'P'           WYA2(1)                                      204152
     C                   MOVEA     WA6           WYA2(2)                                      204152
     C                   MOVEA     WA4           WYA2(8)                                      204152
     C                   MOVEA     IPPYTP        WYA2(12)                                     204152
     C                   MOVEA     '00'          WYA2(14)                                     204152
      *                                                                                       204152
     C     1             DO        15            IA                2 0                        204152
     C     WYA2(IA)      IFEQ      ' '                                                        204152
     C                   MOVEL     '0'           WYA2(IA)                                     204152
     C                   ENDIF                                                                204152
     C                   ENDDO                                                                204152
      *                                                                                       204152
      ***Suppress*new*payment*reference*generation*if*CSC024*is                        CSC024 CSC054
      ***switched*on*and*this*is*running*on*OME*system.                                CSC024 CSC054
      ** Suppress new payment reference generation if CSC054 is                               CSC024
      ** switched on and this is running on PEA system.                                       CSC024
                                                                                              CSC024
     C                   IF        GENPREF = 'Y'                                              CSC024
     C                   MOVEA     WYA2(1)       IPPREF                                       204152
     C                   MOVEL     IPPREF        DDPREF                                       210733
     C**********         MOVEL     IPPREF        WIPREF                               BUG4776 260326
     C******LOCK         IN        WINPAY                                             BUG4776 260326
     C**********         ADD       1             WINSQ                                BUG4776 260326
     C**********         EVAL      WPRNUM = WINSQ                                     BUG4776 260326
     C**********         EXSR      SETPREFSQ                                          BUG4776 260326
     C**********         OUT       WINPAY                                             BUG4776 260326
     C                   ELSE                                                                 CSC024
     C                   EVAL      IPPREF = DDPREF                                            CSC024
     C                   ENDIF                                                                CSC024
      *                                                                                       204152
     C                   ENDSR                                                                204152
      *****************************************************************                       204152
      /EJECT
      *****************************************************************               BUG4776 260326
      **SETPPREFSQ*Set*up*Next*Payment*Reference*sequence**************               BUG4776 260326
      *****************************************************************               BUG4776 260326
     C*****SETPREFSQ     BEGSR                                                        BUG4776 260326
      *****************************************************************               BUG4776 260326
     C**********         MOVE      'N'           WUREF1            1                  BUG4776 260326
     C*****WUREF1        DOWEQ     'N'                                                BUG4776 260326
      *****************************************************************               BUG4776 260326
     C*****WIPREF        CHAIN     FTPREFL1                           83              BUG4776 260326
      *****************************************************************               BUG4776 260326
      ****If*Payment*Reference*is*found,*increment*WINSQ*by*1.*********               BUG4776 260326
      *****************************************************************               BUG4776 260326
     C******IN83         IFEQ      '0'                                                BUG4776 260326
     C**********         EVAL      WINSQ = WINSQ + 1                                  BUG4776 260326
     C**********         EVAL      WPRNUM = WINSQ                                     BUG4776 260326
      *****************************************************************               BUG4776 260326
     C**********         ELSE                                                         BUG4776 260326
      *****************************************************************               BUG4776 260326
      ****Else*move*'Y'*to*WUREF*to*stop*the*loop.*********************               BUG4776 260326
      *****************************************************************               BUG4776 260326
     C**********         MOVE      'Y'           WUREF1                               BUG4776 260326
     C**********         ENDIF                                                        BUG4776 260326
      *****************************************************************               BUG4776 260326
     C**********         ENDDO                                                        BUG4776 260326
      *****************************************************************               BUG4776 260326
     C**********         ENDSR                                                        BUG4776 260326
      *****************************************************************               BUG4776 260326
      ***/EJECT                                                                       BUG4776 260326
      *****************************************************************
      *                                                               *
      *  SRUpdate - Update files                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdate      BEGSR
      *
      ** Initialise Originally Insert from Level 2 Entry flag.
      *
     C                   MOVE      *BLANK        POrigACTN
      *
      ** Initialise variables used in determining successful
      ** insert of an Incoming Payment.
      *
     C                   MOVE      *BLANKS       WPREFI           15
     C                   MOVE      *BLANK        WInsert           1
      *
      ** Action is Insert.
      *
     C     DDACTN        IFEQ      'I'
     C/COPY WNCPYSRC,FTIPAYSC12
      **********                                                                       CER001 247665
      **********                                                                       CER001 247665
      ***check*if*already*allocated*in*window                                          CER001 247665
      **********                                                                       CER001 247665
     C*****IPPREF        ANDEQ     *BLANKS                                             CER001 247665
      **********                                                                       CER001 247665
      *
      ** Entry point is Level 1.
      *
     C     PParmLevel    IFEQ      '1'
     C/COPY WNCPYSRC,FTIPAYSC18
      *
      ***Update*Incoming Payments data area with next                                         204152
      ***Sequence*Number.                                                                     204152
      **********                                                                              204152
     C**** *DTAARA       DEFINE    INPAYDA       WINPAY                                       204152
     C**** *LOCK         IN        WINPAY                                                     204152
     C**********         Z-ADD     WINSQ         WWINSQ            4 0                        204152
     C**********         ADD       1             WINSQ                                        204152
     C**********         OUT       WINPAY                                                     204152
      **********                                                                              204152
      ***Record*Id.                                                                           204152
      **********                                                                              204152
     C**********         MOVEL     'D'           IPRECI                                       204152
      **********                                                                              204152
      ***Payment Type.                                                                        204152
      **********                                                                              204152
     C**********         EVAL      IPPYTP = 'IN'                                              204152
      **********                                                                              204152
      ***Original Entry Dates.                                                                204152
      **********                                                                              204152
     C**********         Z-ADD     BJRDNB        PDayNo                                       204152
      **********                                                                              204152
     C**********         CALLB     'ZDATE2'                                                   204152
     C**********         PARM                    PDayNo                                       204152
     C**********         PARM      BJDFIN        PFMT                                         204152
     C**********         PARM      *ZERO         PDate                                        204152
     C**********         PARM      *BLANKS       PADate                                       204152
      **********                                                                              204152
     C**********         Z-ADD     BJRDNB        IPOEDT                                       204152
     C**********         Z-ADD     PDate         IPOEDTD1                                     204152
      **********                                                                              204152
     C**********         MOVE      PDate         WN2               2 0                        204152
     C*****WN2**         IFLT      72                                                         204152
     C**********         Z-ADD     20            IPOEDTD2                                     204152
     C**********         ELSE                                                                 204152
     C**********         Z-ADD     19            IPOEDTD2                                     204152
     C**********         ENDIF                                                                204152
      **********                                                                              204152
     C**********         MOVEL     PDate         WA4               4                          204152
     C*****BJDFIN        IFNE      'M'                                                        204152
     C**********         MOVEL     WA4           WA2               2                          204152
     C**********         MOVE      WA4           WA2A              2                          204152
     C**********         MOVEL     WA2A          WA4                                          204152
     C**********         MOVE      WA2           WA4                                          204152
     C**********         ENDIF                                                                204152
      **********                                                                              204152
     C**********         MOVE      PDate         WA2                                          204152
     C**********         MOVEL     WA2           PDate                                        204152
     C**********         MOVE      WA4           PDate                                        204152
     C**********         Z-ADD     PDate         IPOEDTD3                                     204152
      **********                                                                              204152
      ***New*Payment Reference.                                                               204152
      **********                                                                              204152
     C**********         IF        (CSC011 = 'Y') AND (LIBR = S1SUPP)                  CSC011 204152
     C**********         Z-ADD     WPRDTE        PDAYNO                                CSC011 204152
     C**********         CALLB     'ZDATE2'                                            CSC011 204152
     C**********         PARM                    PDAYNO                                CSC011 204152
     C**********         PARM      BJDFIN        PFMT                                  CSC011 204152
     C**********         PARM      *ZERO         PPRDATE                               CSC011 204152
     C**********         PARM      *BLANKS       PPRADATE                              CSC011 204152
      **********                                                                       CSC011 204152
     C**********         MOVEL     PPRDATE       WA4                                   CSC011 204152
     C*****BJDFIN        IFNE      'M'                                                 CSC011 204152
     C**********         MOVEL     WA4           WA2                                   CSC011 204152
     C**********         MOVE      WA4           WA2A                                  CSC011 204152
     C**********         MOVEL     WA2A          WA4                                   CSC011 204152
     C**********         MOVE      WA2           WA4                                   CSC011 204152
     C**********         ENDIF                                                         CSC011 204152
      **********                                                                       CSC011 204152
     C**********         MOVE      PPRDATE       WA2                                   CSC011 204152
     C**********         MOVEL     WA2           PPRDATE                               CSC011 204152
     C**********         MOVE      WA4           PPRDATE                               CSC011 204152
     C**********         MOVE      PPRDATE       WA6                                   CSC011 204152
     C**********         ELSE                                                          CSC011 204152
     C**********         MOVE      PDate         WA6               6                          204152
     C**********         ENDIF                                                         CSC011 204152
     C**********         MOVE      WWINSQ        WA4                                          204152
     C**********         MOVE      'P'           WYA2(1)                                      204152
     C**********         MOVEA     WA6           WYA2(2)                                      204152
     C**********         MOVEA     WA4           WYA2(8)                                      204152
     C**********         MOVEA     IPPYTP        WYA2(12)                                     204152
     C**********         MOVEA     '00'          WYA2(14)                                     204152
      **********                                                                              204152
     C*****1****         DO        15            IA                2 0                        204152
     C*****WYA2(IA)      IFEQ      ' '                                                        204152
     C**********         MOVEL     '0'           WYA2(IA)                                     204152
     C**********         ENDIF                                                                204152
     C**********         ENDDO                                                                204152
      **********                                                                              204152
     C**********         MOVEA     WYA2(1)       IPPREF                                       204152
     C**********         MOVEA     WYA2(1)       WPREFI                                       204152
     C                   MOVE      IPPREF        WPREFI                                       204152
     C/COPY WNCPYSRC,FTIPAYSC19
     C                   MOVE      'Y'           WInsert
      *
      ** Level 1 Valid Indicator.
      *
     C/COPY WNCPYSRC,FTIPAYSC35
     C                   EVAL      IPINLVL1 = 'Y'
      *
      ** Entry point is Level 2.
      *
     C                   ELSE
      *
      ** Save original Action Code.
      *
     C                   EVAL      POrigACTN = DDACTN
      *
      ** Change Action Code to 'A' (Amend).
      *
     C                   MOVEL     'A'           DDACTN
      *
     C                   ENDIF
     C/COPY WNCPYSRC,FTIPAYSC13
      *
     C                   ENDIF
      *
      ** Insert or Amend.
      *
     C                   IF        DDACTN = 'I' or
     C                             DDACTN = 'A'
      *
      ** Input Officer 1.
      *
     C                   EVAL      IPINUSR1 = PSUser
      *
      ** If entry point is Level 1 and Level 1 is linked with
      ** Level 2, or entry point is Level 1 and Incoming Payments
      ** Maintenance is called from linked maintenance/enquiry,
      ** or entry point is Level 2, update Level 2 fields.
      *
     C     PParmLevel    IFEQ      '1'
     C     BTLVJN        ANDEQ     'Y'
     C     PParmLevel    OREQ      '1'
     C     PParmLink     ANDEQ     'Y'
     C     PParmLevel    OREQ      '2'
      *
      ** Input Officer 2.
      *
     C                   EVAL      IPINUSR2 = PSUser
      *
      ** Level 2 Valid Indicator.
      *
     C                   EVAL      IPINLVL2 = 'Y'
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Delete.
      *
     C     DDACTN        IFEQ      'D'
      *
      ** Record Id - update to 'C'.
      *
     C                   EVAL      IPRECI = 'C'
      *
     C                   ENDIF
      *
      ** Last Change Type, Date and Time.
      *
     C                   MOVEL     DDACTN        IPCHTP
     C                   Z-ADD     BJRDNB        IPLCD
     C                   TIME                    IPLCHT
      *                                                                         N
      ** If entry 1 is not linked with Level 2 and entry point is               N
      ** Level 1 Maintenance and Pay currency is the same as                    N
      ** Settle Currency, clear Margin fields.                                  N
      *                                                                         N
     C     BTLVJN        IFNE      'Y'                                          N
     C     PParmLevel    ANDEQ     '1'                                          N
     C     IPPCCY        ANDEQ     IPSMCY                                       N
     C                   CLEAR                   IPMBSI                         N
     C                   CLEAR                   IPMSIG                         N
     C                   Z-ADD     *ZERO         IPMAMT                         N
     C                   ENDIF                                                  N
      *
      ** Update files.
      *
     C                   CALLB     'FTIPAYUPD'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
      *                                                                         CFT014
      ** Incoming Payments (additional details) for file update                 CFT014
     C                   PARM                    NwIP2FilFmt                    CFT014
      *
      ** IBANs full account
     C                   PARM                    PIBANAcc
      *
      ** Originally Insert from Level 2 Entry
     C                   PARM                    POrigACTN         1
      *
      ** FT Override for GL Balances
     C                   PARM                    PFTOV
      *
      ** FT Control Data
     C                   PARM                    PCNTRL
      *
      ** Network
     C                   PARM                    PNWRK
      *
      ** Entry Point
     C                   PARM                    PParmLevel
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD
      *
      ** SDBANK - Midas Run Date
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDGELR - Originating Branch/User Vald Req.
     C                   PARM                    BKOBUV
      *
      ** ZMUSER - Default Branch
     C                   PARM                    PDBRN
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Batch Authorisation
     C                   PARM                    CFT003
      *
      ** IBAN numbers
     C                   PARM                    CFT004
      *
      ** BLI FT Enhancements Feature
     C                   PARM                    S01494
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499
      *                                                                         CFT014
      ** STP Phase 2 MT103                                                      CFT014
     C                   PARM                    CFT014                         CFT014
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
     C                   PARM                    CFT010                         CFT009
     C                   PARM                    CSC011                                       CSC011
     C                   PARM                    CSD015                                       CSD015
     C                   PARM                    CCF001                                       CSD015
      *                                                                                       CAP211
     C                   PARM                    PAuth             1                          CAP211
     C                   PARM                    PUser            10                          CAP211
      *                                                                                       CAP211
     C/COPY WNCPYSRC,FTIPAYSC02
      *                                                                                       CER001
      ** Action is Delete                                                                     CER001
      *                                                                                       CER001
     C                   IF        DDACTN = 'D'                                               CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y'                                               CER001
     C                             and  BTLVJN = 'Y'                                          CER001
     C                             or ULX043 = 'Y'                                            CER001
     C                             and  PParmLevel = '2'                                      CER001
      *                                                                                       CER001
      ** New window processing                                                                CER001
      *                                                                                       CER001
     C                   EXSR      WINDOWI                                                    CER001
      *                                                                                       CER001
      ** If errors occurred on update, rollback uncommitted file                              CER001
      ** changes.                                                                             CER001
      *                                                                                       CER001
     C                   IF        #RTRN <> *BLANKS                                           CER001
     C                   ROLBK                                                                CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Case when IPPREF allocated by the window                                             CER001
      ** Update of last transaction is a successful Insert, display                           CER001
      ** corresponding message on screen.                                                     CER001
      *                                                                                       CER001
     C                   IF        RetCodeOut = *BLANKS and                                   CER001
     C                             WAlloc = 'Y'                                               CER001
     C                   Z-ADD     1             Idx                                          CER001
     C                   EVAL      FldNameArr(Idx) = '*ANY'                                   CER001
     C                   EVAL      MsgIdArr(Idx) = 'FTA0121'                                  CER001
     C                   EVAL      MsgDtaArr(Idx) = WAllPref                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y' and RetcodeOut = *BLANKS                      CER001
     C                             and DDACTN <> 'D'                                          CER001
     C                   EXSR      SRUPDAT                                                    CER001
     C                   ENDIF                                                                CER001
      *
      ** If errors occurred on update, rollback uncommitted file
      ** changes.
      *
     C                   IF        RetCodeOut <> *BLANKS and
     C                             RetCodeOut <> '*RECUPD'
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
     C                   IF        RetCodeOut = '*RECUPD'
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
     C                   ELSE
      **                                                                                      CSC022
      ** Execute commit if SAR CSC022 is not enrolled or                                      CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   ENDIF
     C                   ENDIF
      *
      ** If update not done due to record being updated by another
      ** workstation, display message "The last transaction was not
      ** applied to the database." to the next screen.
      *
     C                   IF        RetCodeOut = '*RECUPD'
     C                   Z-ADD     1             Idx
     C                   Eval      FldNameArr(Idx) = '*ANY'
     C                   Eval      MsgIdArr(Idx) = 'FTA0120'
     C                   ENDIF
      *
      ** Update of last transaction is a successful Insert, display
      ** corresponding message on screen.
      *
     C                   IF        RetCodeOut = *BLANKS and
     C                             WInsert = 'Y'
     C                   Z-ADD     1             Idx
     C                   Eval      FldNameArr(Idx) = '*ANY'
     C                   Eval      MsgIdArr(Idx) = 'FTA0121'
     C                   Eval      MsgDtaArr(Idx) = WPREFI
     C/COPY WNCPYSRC,FTH00265
                                                                                              219728
     C     PParmLink     IFEQ      'Y'                                                        219728
     C     PParmLevel    OREQ      '1'                                                        219728
     C     WEMSG         ANDEQ     'Y'                                                        219728
      *                                                                                       219728
      ** Display Initial screen in order to output new payment message reference              219728
     C                   CALLB     'FTIPAYIDP'                                                219728
     C                   PARM      *BLANKS       RetCodeOut                                   219728
     C                   PARM                    DDACTN                                       219728
     C                   PARM                    DDPREF                                       219728
     C                   PARM                    DDBRCA                                       219728
     C                   PARM                    DDSWTN           28                          219728
     C                   PARM                    DDSEQNO           2                          219728
     C                   PARM      'N'           PEDTKEY                                      219728
     C                   PARM      'N'           PEINKG                                       219728
     C                   PARM      'N'           PEINKH                                       219728
     C                   PARM      'N'           PEINKP                                       219728
     C                   PARM      'N'           PEINKS                                       219728
     C                   PARM                    OKACTN                                       219728
     C                   PARM                    OKPREF                                       219728
     C                   PARM                    OKBRCA                                       219728
     C                   PARM                    OKSWTN                                       219728
     C                   PARM                    OKSEQNO                                      219728
     C                   PARM                    FldNameArr                                   219728
     C                   PARM                    MsgIdArr                                     219728
     C                   PARM                    MsgDtaArr                                    219728
     C                   PARM                    WFldNamArr                                   219728
     C                   PARM                    WMsgIdArr                                    219728
     C                   PARM                    WMsgDtaArr                                   219728
     C                   PARM                    BJMRDT                                       219728
     C                   PARM                    BJSBRC                                       219728
     C                   PARM                    PINKC                                        219728
     C                   PARM                    PINKG                                        219728
     C                   PARM                    PINKH                                        219728
     C                   PARM                    PINKL                                        219728
     C                   PARM                    PINKP                                        219728
     C                   PARM                    PINKS                                        219728
      *                                                                                       219728
      * Disable any function key return codes                                                 219728
     C                   MOVE      'N'           PINKC                                        219728
     C                   MOVE      'N'           PINKG                                        219728
     C                   MOVE      'N'           PINKH                                        219728
     C                   MOVE      'N'           PINKL                                        219728
     C                   MOVE      'N'           PINKP                                        219728
     C                   MOVE      'N'           PINKS                                        219728
      *                                                                                       219728
      * Reset screen error information                                                        219728
     C                   EXSR      SRResetErr                                                 219728
     C                   ENDIF                                                                219728
      *                                                                                       219728
     C                   ENDIF
      *
      ** If Incoming Payments Maintenance has been called by
      ** linked maintenance/enquiry, terminate program.
      *
     C     PParmLink     IFEQ      'Y'
     C                   MOVEL     *BLANK        PParmRtcd
     C                   MOVEL     'T'           WScrn
      *                                                                                       210733
     C     WInsert       IFEQ      'Y'                                                        210733
     C                   MOVE      WPREFI        PParmPRef                                    210733
     C                   MOVE      'I'           PParmRtcd                                    210733
     C                   ENDIF                                                                210733
      *                                                                                       210733
     C                   GOTO      EUpdate
     C                   ENDIF
      *
      ** If entry point is Level 1 and there are reserved
      ** electronic messages present, load details of the
      ** next reserved electronic message to the screen.
      *
     C     PParmLevel    IFEQ      '1'
     C     WEMSG         ANDEQ     'Y'
      *
      ** Check if there is still reserved electronic message
      ** to be processed.
      *
     C                   EXSR      SRMsgNxt
      *
      ** If there are no reserved electronic messages to
      ** process, display Initial screen with blank screen
      ** fields.
      *
     C     WEMSG         IFNE      'Y'
      *
     C                   MOVEL     'I'           WScrn
     C                   MOVEL     *BLANKS       DDACTN
     C                   MOVEL     *BLANKS       DDPREF
     C                   MOVEL     *BLANKS       DDSWTN
     C                   MOVEL     *BLANKS       DDSEQNO
     C                   MOVEL     *BLANKS       DDBRCA
      *
     C                   ELSE
      *
      ** Load details of the next reserved electronic message
      ** to Level 1 screen.
      *
     C                   MOVE      'Y'           WNOCLEAR          1
     C                   EXSR      SRVal_I
      *
     C                   ENDIF
      *
     C                   GOTO      EUpdate
      *
     C                   ENDIF
      *
      ** Read Next Browse Subfile record.
      *
     C     PRDNB         IFEQ      'Y'
     C                   MOVEL     'R'           WScrn
     C                   GOTO      EUpdate
     C                   ENDIF
      *
      ** Display Initial screen with blank screen fields.
      *
     C                   MOVEL     *BLANKS       DDACTN
     C                   MOVEL     *BLANKS       DDPREF
     C                   MOVEL     *BLANKS       DDSWTN
     C                   MOVEL     *BLANKS       DDSEQNO
     C                   MOVEL     *BLANKS       DDBRCA
     C                   MOVEL     'I'           WScrn
      *
     C     EUpdate       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdNBrw - Read next Browse Subfile record                   *
      *                                                               *
      *****************************************************************
      *
     C     SRRdNBrw      BEGSR
      *
     C                   CALLB     'FTIPAYBRW'
      *                             =========
      ** INPUT
      ** =====
      *
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Payment Reference (Pointer)
     C                   PARM      *BLANKS       DDPREF
      *
      ** Build Subfile
     C                   PARM      *BLANK        PBDSFL            1
      *
      ** Read Subfile Record
     C                   PARM      'Y'           PRDSFL            1
      *
      ** Entry Point
     C                   PARM                    PParmLevel
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** OUTPUT
      ** ======
      *
      ** Error Message
     C                   PARM                    PErrMs            7
      *
      ** Option Selected
     C                   PARM                    PopSel            1
      *
      ** Payment Reference Selected
     C                   PARM                    PPRefSel         15
      *
      ** Function Key Enabled - F3
     C                   PARM                    PINKC
      *
      ** Function Key Enabled - F12
     C                   PARM                    PINKL
      *
      ** If no Incoming Payment selected from subfile, reset
      ** Read Next Browse Subfile Record indicator and then
      ** display Initial screen with blank screen fields.
      *
     C     POPSEL        IFEQ      *BLANK
     C                   MOVEL     *BLANK        PRDNB
     C                   MOVEL     *BLANKS       DDACTN
     C                   MOVEL     *BLANKS       DDPREF
     C                   MOVEL     *BLANKS       DDSWTN
     C                   MOVEL     *BLANKS       DDSEQNO
     C                   MOVEL     *BLANKS       DDBRCA
     C                   MOVEL     'I'           WScrn
     C                   GOTO      ERdNBrw
     C                   ENDIF
      *
      ** Update Action Code with Option selected.
      *
     C                   MOVEL     POPSEL        DDACTN
      *
      ** Default Action to Enquiry if entry is invalid.  Valid
      ** entries are A(Amend), D(Delete) and E(Enquire).
      ** I(Insert) is also a valid Action Code if entry point
      ** is Level 2.
      *
     C     DDACTN        IFNE      'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
      *
     C     PParmlevel    IFNE      '2'
     C     DDACTN        ORNE      'I'
     C                   MOVE      'E'           DDACTN
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Retrieve Incoming Payment details.
      *
     C                   MOVEL     PPREFSEL      DDPREF
     C                   EXSR      SRRtvPref
      *
      ** If errors occurred in the retrieval of Incoming
      ** Payment details, display error messages on the
      ** Initial screen.
      *
     C     IDx           IFGT      1
     C     IDx           OREQ      1
     C     MsgIdArr(1)   ANDNE     'FTA0120'
     C     MsgIdArr(1)   ANDNE     'FTA0121'
     C                   MOVEL     'I'           WScrn
     C                   GOTO      ERdNBrw
     C                   ENDIF
      *
      ** Move Incoming Payment details retrieved from the master
      ** database file into the update file record.
      *
     C                   MOVEL     CrIPFilFmt    NwIPFilFmt
     C                   IF        (CFT003 = 'Y')                               CFT014
     C                             OR (CFT014 = 'Y')                            CFT014
     C                             OR CFT009 = 'Y'                              CFT009
     C                   MOVEL     CrIP2FilFmt   NwIP2FilFmt                    CFT014
     C                   ELSE                                                                BUG7101
     C                   CLEAR                   NwIP2FilFmt                                 BUG7101
     C                   ENDIF                                                  CFT014
      *
      ** Put Incoming Payment details on the screen.
      *
     C                   EXSR      SRPutRef
      *
      ** If entry point is Level 1 Maintenance, process Level 1
      ** screen.  Otherwise, process Level 2 screen 1.
      *
     C     PParmLevel    IFEQ      '1'
      *
     C                   MOVE      'P'           WScrn
      *
     C                   ELSE
      *
     C                   MOVE      'S'           WScrn
      *
      ** Set up Charges Branch.
      *
     C     BJSBRC        IFNE      *BLANKS
     C                   EVAL      PPYBR = BJSBRC
     C                   ELSE
     C     BKOBRU        IFEQ      'Y'
     C                   EVAL      PPYBR = IPORBR
     C                   ELSE
     C                   EVAL      PPYBR = IPBRCA
     C                   ENDIF
     C                   ENDIF
      *
      ** If Action is Insert, or Action is Amend and Level 2
      ** details have not been entered, default Transfer
      ** Commission Tariff based on Charges Branch.
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     INLVL2        ANDNE     'Y'
     C     PPYBR         CHAIN     PYCHGDB                            01
     C     WTRCT         IFNE      *BLANKS                                                    226722
     C                   EVAL      DDTRCT = WTRCT                                             226722
     C                   ENDIF                                                                226722
     C     *IN01         IFEQ      *OFF
     C                   EVAL      DDTRCT = PYDFTRCT
     C                   MOVEL     NwIP3ScnFmt   CrIP3ScnFmt
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ERdNBrw       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldBrw - Build Browse screen                               *
      *                                                               *
      *****************************************************************
      *
     C     SRBldBrw      BEGSR
      *
      ** Release all reserved electronic messages for the job.
      *
     C     WEMSG         IFEQ      'Y'
     C                   EXSR      SRMsgEnd
     C                   ENDIF
      *
      ** Reset Read Next Browse Subfile Record indicator.
      *
     C                   MOVEL     *BLANK        PRDNB             1
      *
      ** Display Browse screen.
      *
     C                   CALLB     'FTIPAYBRW'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Payment Reference (pointer)
     C                   PARM      *BLANKS       DDPREF
      *
      ** Build Subfile
     C                   PARM      'Y'           PBDSFL
      *
      ** Read Subfile Record
     C                   PARM      *BLANK        PRDSFL
      *
      ** Entry Point
     C                   PARM                    PParmLevel
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** OUTPUT
      ** ======
      *
      ** Error Message
     C                   PARM                    PErrMs
      *
      ** Option Selected
     C                   PARM                    PopSel
      *
      ** Payment Reference Selected
     C                   PARM                    PPRefSel
      *
      ** Function Key Enabled - F3
     C                   PARM                    PINKC
      *
      ** Function Key Enabled - F12
     C                   PARM                    PINKL
      *
     C                   SELECT
      *
      ** F3 - end program.
      *
     C     PINKC         WHENEQ    *ON
     C                   EXSR      SREndP
      *
      ** Send error message returned from Browse screen.
      *
     C     PErrMs        WHENNE    *BLANKS
     C                   EXSR      SRSndM
      *
      ** F12 not pressed.  Read selected Browse Subfile record.
      *
     C                   OTHER
     C     PINKL         IFNE      *ON
     C                   MOVE      'Y'           PRDNB
     C                   MOVEL     'R'           WScrn
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRoll - Roll backwards or forwards through the Incoming     *
      *           Payments file                                       *
      *                                                               *
      *****************************************************************
      *
     C     SRRoll        BEGSR
      *
      ** Release all reserved electronic messages for the job.
      *
     C     WEMSG         IFEQ      'Y'
     C                   EXSR      SRMsgEnd
     C                   ENDIF
      *
      ** Read previous or next record in Incoming Payments file
      ** according to Function Key taken (F7=INKG or F8=INKH).
      *
     C     PINKG         IFEQ      *ON
     C                   MOVEL     'Y'           PRdBck
     C                   MOVEL     *BLANK        PRdFwd
     C                   ELSE
     C                   MOVEL     *BLANK        PRdBck
     C                   MOVEL     'Y'           PRdFwd
     C                   ENDIF
      *
      ** Read previous or next record in Incoming Payments file.
      *
     C                   CALLB     'FTIPAYRED'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Payment Reference (file pointer)
     C                   PARM                    DDPREF
      *
      ** Read backwards
     C                   PARM                    PRdBck            1
      *
      ** Read forwards
     C                   PARM                    PRdFwd            1
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** OUTPUT
      ** ======
      *
      ** Error message
     C                   PARM                    PErrMs
      *
      ** Payment Reference read
     C                   PARM                    PPrefSel
      *
      ** If error message returned from Read, send it to screen.
      *
     C     PErrMs        IFNE      *BLANKS
     C                   EXSR      SRSndM
     C                   GOTO      ERoll
     C                   ENDIF
      *
      ** Default Action to Enquiry if entry is invalid.  Valid
      ** entries are A(Amend), D(Delete) and E(Enquire).
      ** I(Insert) is also a valid Action Code if entry point
      ** is Level 2.
      *
     C     DDACTN        IFNE      'A'
     C     DDACTN        ANDNE     'D'
     C     DDACTN        ANDNE     'E'
      *
     C     PParmlevel    IFNE      '2'
     C     DDACTN        ORNE      'I'
     C                   MOVE      'E'           DDACTN
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Retrieve Incoming Payment details.
      *
     C                   MOVE      PPRefSel      DDPREF
     C                   EXSR      SRRtvPref
      *
      ** If errors occurred in the retrieval of Incoming
      ** Payment details, display error messages on the
      ** Initial screen.
      *
     C     Idx           IFNE      *ZERO
     C                   MOVEL     'I'           WScrn
     C                   GOTO      ERoll
     C                   ENDIF
      *
      ** Move Incoming Payment details retrieved from the master
      ** database file into the update file record.
      *
     C                   MOVEL     CrIPFilFmt    NwIPFilFmt
     C                   IF        (CFT003 = 'Y')                               CFT014
     C                             OR (CFT014 = 'Y')                            CFT014
     C                   MOVEL     CrIP2FilFmt   NwIP2FilFmt                    CFT014
     C                   ELSE                                                                BUG7101
     C                   CLEAR                   NwIP2FilFmt                                 BUG7101
     C                   ENDIF                                                  CFT014
      *
      ** Put Incoming Payment details on the screen.
      *
     C                   EXSR      SRPutRef
      *
      ** If entry point is Level 1 Maintenance, process Level 1
      ** screen.  Otherwise, process Level 2 screen 1.
      *
     C     PParmLevel    IFEQ      '1'
      *
     C                   MOVE      'P'           WScrn
      *
     C                   ELSE
      *
     C                   MOVE      'S'           WScrn
      *
      ** Set up Charges Branch.
      *
     C     BJSBRC        IFNE      *BLANKS
     C                   EVAL      PPYBR = BJSBRC
     C                   ELSE
     C     BKOBRU        IFEQ      'Y'
     C                   EVAL      PPYBR = IPORBR
     C                   ELSE
     C                   EVAL      PPYBR = IPBRCA
     C                   ENDIF
     C                   ENDIF
      *
      ** If Action is Insert, or Action is Amend and Level 2
      ** details have not been entered, default Transfer
      ** Commission Tariff based on Charges Branch.
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C     INLVL2        ANDNE     'Y'
     C     PPYBR         CHAIN     PYCHGDB                            01
     C     *IN01         IFEQ      *OFF
     C                   EVAL      DDTRCT = PYDFTRCT
     C     WTRCT         IFNE      *BLANKS                                                    226722
     C                   EVAL      DDTRCT = WTRCT                                             226722
     C                   ENDIF                                                                226722
     C                   MOVEL     NwIP3ScnFmt   CrIP3ScnFmt
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ERoll         ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvPref - Retrieve Incoming Payment details                *
      *                                                               *
      *****************************************************************
      *
     C     SRRtvPref     BEGSR
      *
     C                   CALLB     'FTIPAYRTV'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     C                   PARM                    PMode
      *
      ** Response Mode
     C                   PARM                    PResponse
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** Front Office Transaction Id
     C                   PARM      *BLANKS       FOTRID           20
      *
      ** Payment Reference
     C                   PARM                    DDPREF
      *
      ** Booking Branch
     C                   PARM                    DDBRCA
      *
      ** SWIFT Reference
     C                   PARM                    DDSWTN
      *
      ** Entry Point
     C                   PARM                    PParmLevel
      *
      ** Linked Program
     C                   PARM                    PLinkPgm
      *
      ** Validate Payment Reference for Insert
     C                   PARM      'Y'           PPrefInsert       1
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDGELR - Originating Branch/User Vald Req.
     C                   PARM                    BKOBUV
      *
      ** ZMUSER - Default Branch
     C                   PARM                    PDBRN
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** BLI FT Enhancements Feature
     C                   PARM                    S01494
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499
      *                                                                         CFT014
      ** FT Batch Auth and Credit Advices                                       CFT014
     C                   PARM                    CFT003                         CFT014
      *                                                                         CFT014
      ** STP Phase 2 MT103                                                      CFT014
     C                   PARM                    CFT014                         CFT014
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** OK Action Code
     C                   PARM                    OKACTN
      *
      ** OK Payment Reference
     C                   PARM                    OKPREF
      *
      ** OK Booking Branch
     C                   PARM                    OKBRCA
      *
      ** Incoming Payments retrieved from file - file format
     C                   PARM                    CrIPFilFmt
      *                                                                         CFT014
      ** Incoming Payments (additional) retrieved from file-file format         CFT014
     C                   PARM                    CrIP2FilFmt                    CFT014
     C/COPY WNCPYSRC,FTIPAYSC03
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPutRef - Convert Incoming Payment details to screen        *
      *             format                                            *
      *                                                               *
      *****************************************************************
      *
     C     SRPutRef      BEGSR
      *
     C                   CALLB     'FTIPAYCVT'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Incoming Payments retrieved from file - file format
     C                   PARM                    CrIPFilFmt
      *                                                                         CFT014
      ** Incoming Payments (additional) retrieved from file-file format         CFT014
     C                   PARM                    CrIP2FilFmt                    CFT014
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN
      *
      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD
      *
      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY
      *
      ** SDGELR - Profit Centre Used
     C                   PARM                    BKPRCU
      *
      ** SDGELR - Originating Branch Used
     C                   PARM                    BKOBRU
      *
      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST
      *
      ** SDFTFR - Charges Currency
     C                   PARM                    BTCHCY
      *                                                                         CFT009
      ** SDFTFR - Fixed Charge Currency                                         CFT009
     C                   PARM                    FCHCCY                         CFT009
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU FT Settlement Currency Conversion
     C                   PARM                    CEU006
      *
      ** BLI FT Enhancements Feature
     C                   PARM                    S01494
      *
      ** BLI VAT Processing Feature
     C                   PARM                    S01499
      *
      ** Electronic Banking Interface IATs and TPPs
     C                   PARM                    CGL009
      *                                                                         CFT014
      ** STP Phase 2 MT103                                                      CFT014
     C                   PARM                    CFT014                         CFT014
     C/COPY WNCPYSRC,FTIPAYSC38
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
     C                   PARM                    CFT010                         CFT009
     C/COPY WNCPYSRC,FTIPAYSC09
      *
      ** OUTPUT
      ** ======
      *
      ** Incoming Payments Lvl 1 Scrn details retrieved from file
      ** - screen format
     C                   PARM                    CrIP1ScnFmt
      *                                                                         CFT014
     C                   PARM                    CrIP1aScnFmt                   CFT014
      *
      ** Incoming Payments Lvl 2 Scrn 1/1 details retrieved from file
      ** - screen format
     C                   PARM                    CrIP2ScnFmt
      *
      ** Incoming Payments Lvl 2 Scrn 1/2 details retrieved from file
      ** - screen format
     C                   PARM                    CrIP3ScnFmt
      *
      ** Incoming Payments Lvl 2 Scrn 2 details retrieved from file
      ** - screen format
     C                   PARM                    CrIP4ScnFmt
      *                                                                         CFT014
     C                   PARM                    CrIP4aScnFmt                   CFT014
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 3 details retrieved from file             CFT014
      ** - screen format                                                        CFT014
     C                   PARM                    CrIP5ScnFmt                    CFT014
      *                                                                         CFT014
      ** Incoming Payments Margin Info details retrieved from file              CFT014
      ** - screen format                                                        CFT014
     C                   PARM                    CrIP6ScnFmt                    CFT014
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 7 details retrieved from file                           CSW209
      ** - screen format                                                                      CSW209
     C                   PARM                    CrIP7ScnFmt                                  CSW209
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 8 details retrieved from file                           CSW209
      ** - screen format                                                                      CSW209
     C                   PARM                    CrIP8ScnFmt                                  CSW209
      *                                                                                       CER030
      ** Incoming Payments Extended Narratives retrieved from file                            CER030
      ** - screen format                                                                      CER030
      *                                                                                       CER030
     C                   PARM                    CrIP6AScnFmt                                 CER030
      *
      ** DS for Additional Information details
     C                   PARM                    PAddInfm
      *
      ** SWIFT Reference
     C                   PARM                    DDSWTN           28
      *
      ** Sequence No.
     C                   PARM                    DDSEQNO           2
      *
      ** Incoming Payment Status
     C                   PARM                    PStatus          10
      *
      ** Payment Type
     C                   PARM                    PPYTP             2
      *                                                                          CFT009
      ** DS for Default Charge Amounts                                           CFT009
     C                   PARM                    PCharges                        CFT009
      *                                                                          CFT009
      ** Input Charge Currency                                                   CFT009
     C                   PARM                    PICCY                           CFT009
      *                                                                          CFT009
      ** Output Charge Currency                                                  CFT009
     C                   PARM                    POCCY                           CFT009
      *                                                                          CFT009
      ** Input Charge Currency No. of Decimal Places                             CFT009
     C                   PARM                    PINBDP                          CFT009
      *                                                                          CFT009
      ** Output Charge Currency No. of Decimal Places                            CFT009
     C                   PARM                    PONBDP                          CFT009
     C                   PARM      *BLANKS       BtnPressed       10                       AR1090283
      *
      ** Initialise screen fields with values from file.
      *
     C                   MOVEL     CrIP1ScnFmt   NwIP1ScnFmt
     C                   MOVEL     CrIP1AScnFmt  NwIP1AScnFmt                    CFT014
     C                   MOVEL     CrIP2ScnFmt   NwIP2ScnFmt
     C                   MOVEL     CrIP3ScnFmt   NwIP3ScnFmt
     C                   MOVEL     CrIP4ScnFmt   NwIP4ScnFmt
     C                   MOVEL     CrIP4AScnFmt  NwIP4AScnFmt                    CFT014
     C                   MOVEL     CrIP5ScnFmt   NwIP5ScnFmt                     CFT014
     C                   MOVEL     CrIP6ScnFmt   NwIP6ScnFmt                     CFT014
     C                   MOVEL     CrIP6AScnFmt  NwIP6AScnFmt                                 CER030
      *                                                                                       CER030
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   MOVEL     CrIP7ScnFmt   NwIP7ScnFmt                                  CSW209
     C                   MOVEL     CrIP8ScnFmt   NwIP8ScnFmt                                  CSW209
     C                   ENDIF                                                                CSW209
      *
      *                                                                                       187056
      ** Save previous value of 'Charges to the Debit of a/c'.                                187056
      *                                                                                       187056
     C                   EVAL      PPrvCDRO = DDCDRO                                          187056
     C                   EVAL      PPrvCDBR = DDCDBR                                          187056
     C                   EVAL      PPrvCDRT = CDRT                                            187056
      *                                                                         CFT009
      ** If CFT009 is on and action code <> 'I', save formatted charges         CFT009
      *                                                                         CFT009
     C                   IF        CFT009 = 'Y' AND DDACTN <> 'I'               CFT009
     C                   MOVEL     PCharges      WICharges                      CFT009
     C                   MOVEL     DDTRCD        WDTRCD           14            CFT009
     C                   MOVEL     DDTXCD        WDTXCD           14            CFT009
     C                   MOVEL     DDCQCD        WDCQCD           14            CFT009
     C                   MOVEL     DDADCD        WDADCD           14            CFT009
     C                   MOVEL     DDTLCD        WDTLCD           14            CFT009
     C                   MOVEL     DDMSCD        WDMSCD           14            CFT009
     C                   MOVEL     DDCHCD        WDCHCD           14            CFT009
     C                   MOVEL     M1CD          WM1CD            14            CFT009
     C                   MOVEL     M2CD          WM2CD            14            CFT009
     C                   MOVEL     M3CD          WM3CD            14            CFT009
     C                   MOVEL     M4CD          WM4CD            14            CFT009
     C                   MOVEL     M5CD          WM5CD            14            CFT009
     C                   ENDIF                                                  CFT009
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREISwft - Process Electronic Message                        *
      *                                                               *
      *****************************************************************
      *
     C     SREISwft      BEGSR
      *
     C                   MOVE      *BLANK        WErr              1
      *
      ** Incoming Payments Maintenance has been called by linked
      ** maintenance/enquiry.
      *
     C     PParmPref     IFEQ      *BLANKS
      *
      ** If Electronic Message Processing is not active, then
      ** determine if a '?' or a SWIFT Reference has been entered.
      *
     C     WEMSG         ANDEQ     *BLANK
      *
     C                   EXSR      SRMKey
      *
      ** If a '?' was entered and an electronic message was selected,
      ** or a valid SWIFT Reference was entered, then continue with the
      ** validation of the SWIFT Reference.
      *
      ** BUT, if a message was not selected or the entered SWIFT
      ** Reference is not available for use, then bypass SWIFT
      ** Reference validation and redisplay the Initial screen.
      *
      ** If the keyed SWIFT Reference was not found or invalid, then the
      ** condition will be picked up in the validation section of this
      ** subroutine.
      *
      ** Terminate program if F3 has been pressed.
      *
      ** Redispplay Initial screen if F12 has been pressed.
      *
     C     WErr          IFNE      *BLANK
     C                   GOTO      EEISwft
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Incoming Payments Maintenance has been called by linked
      ** maintenance/enquiry.
      *
     C     PParmPref     IFEQ      *BLANKS
      *
      ** If the SWIFT Reference is valid, then reserve it on file.
      ** A reserved message may not be selected by any other work
      ** station.
      *
      ** If Electronic Message Processing is active, then a
      ** reservation does not need to be made as it was done
      ** when the message was initially selected.
      *
     C     WEMSG         ANDEQ     *BLANK
      *
     C                   EXSR      SRMsgRsv
      *
      ** If the SWIFT Reference is already allocated to another job,
      ** then redisplay initial screen.
      *
     C     WErr          IFNE      *BLANK
     C                   GOTO      EEISwft
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Call ME1100 to translate the data of the messages for FT
      ** fields.
      *
     C                   CALL      'ME1100'                             0101
     C                   PARM      '*TRANS  '    PACTD             8
     C                   PARM                    PHEAD
     C                   PARM      *BLANKS       PDATA
     C                   PARM      *BLANKS       PDAT2                                        CSW209
     C                   PARM      *BLANKS       PRTN
      *
      ** If call to program resulted in an error, then end program.
      *
     C     PRTN          IFEQ      '*ERROR*'
     C     *IN01         ANDEQ     *ON
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'ME1100'      DBFILE
     C                   Z-ADD     019           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set up the Detail screen fields from the message.
      *
      ** Sender.
      *
     C                   MOVEL     PSNDR         ODDSND1
      *
     C     PSN           IFNE      *BLANKS
     C                   MOVEL     PSN           DSTRAN
     C     PSNDR         IFEQ      'CASHIER'
     C                   MOVEL     PSNAR(1)      TMLIN2
     C                   ENDIF
     C                   MOVEL     TMLIN1        ODDSND1
     C                   MOVEL     TMLIN2        ODDSND2
     C                   MOVEL     TMLIN3        ODDSND3
     C                   MOVEL     TMLIN4        ODDSND4
     C                   ENDIF
      *
      ** Message Type.
      *
     C                   MOVE      PMTPY         IPINMTPY
      *
      ** Msg Unique Reference.
      *
     C                   Z-ADD     PHMSGR        IPINMSGR
      *
      ** SWIFT Reference.
      *
     C                   MOVEL     PHMIR         DDSWTN
      *
      ** Part Number.
      *
     C                   MOVE      PHPART        DDSEQNO
     C                   Z-ADD     PHPART        IPINKPRT
      *
      ** SWIFT Priority Code.
      *
     C                   MOVE      PMPRY         ODDSWPC
      *
      ** Branch Code.
      *
     C     PBRCA         IFNE      *BLANKS
     C                   MOVEL     PBRCA         ODDBRCA
     C                   MOVEL     PBRCA         IPBRCA                                       220180
     C                   ENDIF
      *
      ** Transaction Reference No.
      *
     C     P20           IFNE      *BLANKS
     C                   MOVEL     P20           DSTRAN
     C                   MOVEL     TTREF         IPINTRNO
     C                   ELSE
     C                   MOVEL     *BLANKS       IPINTRNO
     C                   ENDIF
      *
      ** Related Reference.
      *
     C     P21           IFNE      *BLANKS
     C                   MOVEL     P21           DSTRAN
     C                   MOVEL     TTREF         IPRLPR
     C                   MOVEL     TTREF         ODDRLPR
     C                   ELSE
     C                   MOVEL     *BLANKS       IPRLPR
     C                   ENDIF
      *                                                                                       255350
     C     PMTPY         IFEQ      '202'                                                      255350
     C     P20           ANDNE     *BLANKS                                                    255350
     C     PMTPY         OREQ      '103'                                                      257665
     C     P20           ANDNE     *BLANKS                                                    257665
     C                   MOVEL     P20           DSTRAN                                       255350
     C                   MOVEL     TTREF         IPRLPR                                       255350
     C                   MOVEL     TTREF         ODDRLPR                                      255350
     C                   ENDIF                                                                255350
                                                                                CFT014
     C     CFT014        IFEQ      'Y'                                          CFT014
                                                                                CFT014
      ** Sender's Charge fields                                                 CFT014
                                                                                CFT014
     C     P71FX         IFNE      *BLANKS                                      CFT014
                                                                                CFT014
     C                   MOVEL     *BLANK        DSTRAN                         CFT014
     C                   MOVEL     P71FX         DSTRAN                         CFT014
     C                   Z-ADD     1             L                 2 0          CFT014
     C                   MOVEL     TMLIN1        TV1                            CFT014
     C                   MOVEL     TMLIN2        TV2                            CFT014
     C                   MOVEL     TMLIN3        TV3                            CFT014
     C                   MOVEL     TMLIN4        TV4                            CFT014
     C                   MOVEL     TMLIN5        TV5                            CFT014
                                                                                CFT014
     C     L             DOWLE     5                                            CFT014
     C     LFLT(L)       ANDNE     *BLANK                                       CFT014
                                                                                CFT014
     C                   MOVEL     *BLANK        DSTRAN                         CFT014
     C                   MOVEL     LFLT(L)       DSTRAN                         CFT014
     C                   EXSR      SRCYAM33B                                    CFT014
                                                                                CFT014
     C                   SELECT                                                 CFT014
     C                   WHEN      (L = 1)                                      CFT014
     C                   MOVEL     WCAAM         ODDSCH1                        CFT014
     C                   MOVEL     WCACY         ODDSCC1                        CFT014
     C                   WHEN      (L = 2)                                      CFT014
     C                   MOVEL     WCAAM         ODDSCH2                        CFT014
     C                   MOVEL     WCACY         ODDSCC2                        CFT014
     C                   WHEN      (L = 3)                                      CFT014
     C                   MOVEL     WCAAM         ODDSCH3                        CFT014
     C                   MOVEL     WCACY         ODDSCC3                        CFT014
     C                   WHEN      (L = 4)                                      CFT014
     C                   MOVEL     WCAAM         ODDSCH4                        CFT014
     C                   MOVEL     WCACY         ODDSCC4                        CFT014
     C                   WHEN      (L = 5)                                      CFT014
     C                   MOVEL     WCAAM         ODDSCH5                        CFT014
     C                   MOVEL     WCACY         ODDSCC5                        CFT014
     C                   ENDSL                                                  CFT014
                                                                                CFT014
     C                   ADD       1             L                              CFT014
                                                                                CFT014
     C                   ENDDO                                                  CFT014
                                                                                CFT014
     C                   ENDIF                                                  CFT014
                                                                                CFT014
      ** Receiver's Charge field                                                CFT014
                                                                                CFT014
     C     P71G          IFNE      *BLANKS                                      CFT014
                                                                                CFT014
     C                   MOVEL     *BLANK        DSTRAN                         CFT014
     C                   MOVEL     'N'           I2INRCUS                       CFT014
     C                   MOVEL     P71G          DSTRAN                         CFT014
     C                   EXSR      SRCYAM33B                                    CFT014
                                                                                CFT014
     C     *LIKE         DEFINE    DDSMCY        WRCHCY                         CFT014
     C     *LIKE         DEFINE    DDSMAM        WRCHAM                         CFT014
      ** Save receiver's charges info for input to SR/SROV32AM                  CFT014
     C                   MOVEL     WCACY         WRCHCY                         CFT014
     C                   MOVEL     WCAAM         WRCHAM                         CFT014
                                                                                CFT014
     C                   CALL      'AOCURRR0'                           8080    CFT014
     C                   PARM      *BLANKS       @RTCD                          CFT014
     C                   PARM      '*KEY   '     @OPTN                          CFT014
     C                   PARM      WCACY         @CHR03            3            CFT014
     C     SDCURR        PARM      *BLANKS       DSSDY                          CFT014
     C     @RTCD         IFEQ      *BLANKS                                      CFT014
     C     *IN80         ANDEQ     *OFF                                         CFT014
     C                   MOVE      *BLANK        ZFIELD                         CFT014
     C                   MOVE      WCAAM         ZFIELD                         CFT014
     C     13            SUB       A6NBDP        ZADIG                          CFT014
     C                   Z-ADD     A6NBDP        ZADEC                          CFT014
     C                   Z-ADD     A6NBDP        WRCRMNDP          1 0          CFT014
                                                                                CFT014
     C                   CALLB     'ZALIGN'                                     CFT014
     C                   PARM                    ZalignOK                       CFT014
     C                   PARM                    ZFIELD                         CFT014
     C                   PARM                    ZADEC                          CFT014
     C                   PARM                    ZADIG                          CFT014
                                                                                CFT014
     C     ZAlignOK      IFEQ      'Y'                                          CFT014
     C                   MOVE      ZFIELD        I2INRCNW                       CFT014
     C                   MOVEL     WCACY         I2INRCCN                       CFT014
     C                   ENDIF                                                  CFT014
                                                                                CFT014
      ** Default receiver's charges screen field                                CFT014
     C                   MOVEL     WCAAM         ODDRCRM                        CFT014
                                                                                CFT014
     C                   ENDIF                                                  CFT014
                                                                                CFT014
     C                   ENDIF                                                  CFT014
                                                                                CFT014
     C                   ENDIF                                                  CFT014
      *
      ** Settlement Value Date/Currency/Amount.
      *
     C     PDCA          IFNE      *BLANKS
      *
     C                   MOVEL     PDCA          DSTRAN
      *
      ** Settlement Value Date.
      *
     C                   MOVEL     TVVDAT        WWDT
      *
      ** MMDDYY format display.
      *
     C     BJDFIN        IFEQ      'M'
      *
     C                   EVAL      ODDSLDT = WD2 + WD3 + WD1
      *
     C                   ELSE
      *
      ** DDMMYY format display.
      *
     C                   EVAL      ODDSLDT = WD3 + WD2 + WD1
      *
     C                   ENDIF
      *
      ** Settlement Currency.
      *
      ** Translate currency to Midas currency if it is a different                            225169
      ** SWIFT currency code.                                                                 225169
      *                                                                                       225169
     C                   MOVE      TVCCY         W_CCY                                        225169
     C                   EXSR      WTRNCY                                                     225169
     C                   MOVE      W_CCY         TVCCY                                        225169
      *                                                                                       225169
     C                   MOVEL     TVCCY         ODDSMCY
      *
      ** Settlement Amount.
      *
     C     PNWRK         IFNE      'FONTIS'
      *
      ** Format amount field (change ',' decimal point to '.').
      *
     C                   MOVEA     *BLANKS       WYA1
     C                   MOVEA     TVAMT         WYA1
     C                   Z-ADD     1             Cx                3 0
      *
     C     Cx            DOUGT     15
     C     WYA1(Cx)      IFEQ      ','
     C                   MOVE      '.'           WYA1(Cx)
     C                   Z-ADD     16            Cx
     C                   ELSE
     C                   ADD       1             Cx
     C                   ENDIF
     C                   ENDDO
      *
     C                   MOVEA     WYA1          WAMT             15
     C     CFT014        IFEQ      'Y'                                          CFT014
     C     P71G          ANDNE     *BLANKS                                      CFT014
     C                   MOVEL     ODDSLDT       ZDateIn                        CFT014
     C                   CALLB     'ZDATE1'                                     CFT014
     C                   PARM                    ZDateIn           6            CFT014
     C                   PARM      0             ZDateOut          5 0          CFT014
     C                   PARM      BJDFIN        ZDateFmt          1            CFT014
     C                   PARM      *BLANK        ZDate1OK          1            CFT014
     C                   Z-ADD     ZDateOut      WOVVLD            5 0          CFT014
     C                   Z-ADD     ZDateOut      WSLDT             5 0          CFT014
     C                   MOVE      ODDSMCY       WOVICY                         CFT014
     C                   MOVEL     WAMT          WOVIAM                         CFT014
     C                   MOVEL     WRCHCY        WOVRCY                         CFT014
     C                   MOVEL     WRCHAM        WOVRAM                         CFT014
     C                   MOVEL     '*SUB'        WOVOPR                         CFT014
     C                   EXSR      SROV32AM                                     CFT014
     C                   MOVEL     WOVAMT        ODDSMAM                        CFT014
     C                   ELSE                                                   CFT014
     C                   MOVEL     WAMT          ODDSMAM
     C                   ENDIF                                                  CFT014
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Ordering Customer.
      *
     C     P50           IFNE      *BLANKS
     C                   MOVEL     P50           DSTRAN
     C                   MOVEL     TMLIN1        ODDORC1
     C                   MOVEL     TMLIN2        ODDORC2
     C                   MOVEL     TMLIN3        ODDORC3
     C                   MOVEL     TMLIN4        ODDORC4
     C                   EVAL      ODDORC5 = TMLIN5                                           CFT032
     C                   ENDIF
      *
      ** Ordering Institution.
      *
     C     P52           IFNE      *BLANKS
     C                   MOVEL     P52           DSTRAN
     C                   MOVEL     TMLIN1        ODDOBK1
     C                   MOVEL     TMLIN2        ODDOBK2
     C                   MOVEL     TMLIN3        ODDOBK3
     C                   MOVEL     TMLIN4        ODDOBK4
     C                   MOVEL     TMLIN5        ODDOBK5
     C                   ENDIF
      *
      ** Sender's Correspondent.
      *
     C     P53           IFNE      *BLANKS
     C                   MOVEL     P53           DSTRAN
     C                   MOVEL     TMLIN1        ODDSNC1
     C                   MOVEL     TMLIN2        ODDSNC2
     C                   MOVEL     TMLIN3        ODDSNC3
     C                   MOVEL     TMLIN4        ODDSNC4
     C                   MOVEL     TMLIN5        ODDSNC5
     C                   ENDIF
      *
      ** Receiver's Correspondent.
      *
     C     P54           IFNE      *BLANKS
     C     P54           OREQ      *BLANKS                                                  AR921987
     C     P53           ANDNE     *BLANKS                                                  AR921987
      *
     C     P54           IFNE      *BLANKS                                                  AR921987
     C                   MOVEL     P54           DSTRAN
     C                   ELSE                                                               AR921987
     C                   MOVEL     P53           DSTRAN                                     AR921987
     C                   ENDIF                                                              AR921987
     C*****              MOVEL     TMLIN1        ODDRCCO                        CFT014
     C                   MOVEL     TMLIN1        ODDRCO1                        CFT014
     C                   MOVEL     TMLIN2        ODDRCO2                        CFT014
     C                   MOVEL     TMLIN3        ODDRCO3                        CFT014
     C                   MOVEL     TMLIN4        ODDRCO4                        CFT014
     C                   MOVEL     TMLIN5        ODDRCO5                        CFT014
     C                   MOVEL     TMLIN1        IPINRCO1
     C                   MOVEL     TMLIN2        IPINRCO2
     C                   MOVEL     TMLIN3        IPINRCO3
     C                   MOVEL     TMLIN4        IPINRCO4
     C                   MOVEL     TMLIN5        IPINRCO5
      *
      ** If Network is SWIFT, find field type.
      ** Otherwise, default it to 'U'.
      *
     C     PNWRK         IFEQ      'SWIFT '
      *
      ** Set up field type, if A->S, B->T, D->U.
      *
     C     1             SUBST     TRTAG:4       WWK1              1
      *
     C                   SELECT
     C     WWK1          WHENEQ    'A'
     C                   MOVEL     'S'           IPINRCRT
     C     WWK1          WHENEQ    'B'
     C                   MOVEL     'T'           IPINRCRT
     C                   OTHER
     C                   MOVEL     'U'           IPINRCRT
     C                   ENDSL
      *
     C                   ELSE
      *
      ** Network is not SWIFT.
      *
     C                   MOVEL     'U'           IPINRCRT
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVEL     *BLANKS       IPINRCRT
     C                   MOVEL     *BLANKS       IPINRCO1
     C                   MOVEL     *BLANKS       IPINRCO2
     C                   MOVEL     *BLANKS       IPINRCO3
     C                   MOVEL     *BLANKS       IPINRCO4
     C                   MOVEL     *BLANKS       IPINRCO5
      *
     C                   ENDIF
      *
      ** Intermediary.
      *
     C     P56           IFNE      *BLANKS
     C                   MOVEL     P56           DSTRAN
     C                   MOVEL     TMLIN1        ODDINB1
     C                   MOVEL     TMLIN2        ODDINB2
     C                   MOVEL     TMLIN3        ODDINB3
     C                   MOVEL     TMLIN4        ODDINB4
     C                   MOVEL     TMLIN5        ODDINB5
     C                   ENDIF
      *
      ** Account with Institution.
      *
     C     P57           IFNE      *BLANKS
      *
     C                   MOVEL     P57           DSTRAN
     C                   MOVEL     TMLIN1        ODDACBK
     C                   MOVEL     TMLIN1        IPINACB1
     C                   MOVEL     TMLIN2        IPINACB2
     C                   MOVEL     TMLIN3        IPINACB3
     C                   MOVEL     TMLIN4        IPINACB4
     C                   MOVEL     TMLIN5        IPINACB5
      *
      ** If Network is SWIFT, find field type.
      ** Otherwise, default it to 'U'.
      *
     C     PNWRK         IFEQ      'SWIFT '
      *
      ** Set up field type, if A->S, B->T, D->U.
      *
     C     1             SUBST     TRTAG:4       WWK1
      *
     C                   SELECT
     C     WWK1          WHENEQ    'A'
     C                   MOVEL     'S'           IPINACBT
     C     WWK1          WHENEQ    'B'
     C                   MOVEL     'T'           IPINACBT
     C                   OTHER
     C                   MOVEL     'U'           IPINACBT
     C                   ENDSL
      *
     C                   ELSE
      *
      ** Network is not SWIFT.
      *
     C                   MOVEL     'U'           IPINACBT
      *
     C                   ENDIF
      *
      ** P57 equals blanks.
      *
     C                   ELSE
      *
     C                   MOVEL     *BLANKS       IPINACBT
     C                   MOVEL     *BLANKS       IPINACB1
     C                   MOVEL     *BLANKS       IPINACB2
     C                   MOVEL     *BLANKS       IPINACB3
     C                   MOVEL     *BLANKS       IPINACB4
     C                   MOVEL     *BLANKS       IPINACB5
      *
     C                   ENDIF
      *
      ** Beneficiary Institution/ Beneficiary Customer.
      *
     C     P58           IFNE      *BLANKS
     C                   MOVEL     P58           DSTRAN
     C                   MOVEL     TMLIN1        ODDBNC1
     C                   MOVEL     TMLIN2        ODDBNC2
     C                   MOVEL     TMLIN3        ODDBNC3
     C                   MOVEL     TMLIN4        ODDBNC4
     C                   MOVEL     TMLIN5        ODDBNC5
     C                   ENDIF
      *
     C     P59           IFNE      *BLANKS
     C                   MOVEL     P59           DSTRAN
     C                   MOVEL     TMLIN1        ODDBNC1
     C                   MOVEL     TMLIN2        ODDBNC2
     C                   MOVEL     TMLIN3        ODDBNC3
     C                   MOVEL     TMLIN4        ODDBNC4
     C                   MOVEL     TMLIN5        ODDBNC5
     C                   ENDIF
      *
      ** Details of Payment.
      *
     C     P70           IFNE      *BLANKS
     C                   MOVEL     P70           DSTRAN
     C                   MOVEL     TMLIN1        ODDDTP1
     C                   MOVEL     TMLIN2        ODDDTP2
     C                   MOVEL     TMLIN3        ODDDTP3
     C                   MOVEL     TMLIN4        ODDDTP4
     C                   ENDIF
      *                                                                                       CER030
      ** Details of Extended narrative                                                        CER030
      *                                                                                       CER030
     C     PEXN          IFNE      *BLANKS                                                    CER030
     C                   MOVEL     PEXN          DSTRAN                                       CER030
     C                   MOVEL     TMLIN1        ODDEXT1                                      CER030
     C                   MOVEL     TMLIN2        ODDEXT2                                      CER030
     C                   MOVEL     TMLIN3        ODDEXT3                                      CER030
     C                   MOVEL     TMLIN4        ODDEXT4                                      CER030
     C                   MOVEL     TMLIN5        ODDEXT5                                      CER030
     C                   MOVEL     TMLIN6        ODDEXT6                                      CER030
     C                   ENDIF                                                                CER030
      *
      ** Details of Charges.
      *
     C     P71           IFNE      *BLANKS
     C                   MOVEL     P71           DSTRAN
     C                   MOVEL     TTREF         ODDDTCH
     C     CFT014        IFEQ      'Y'                                          CFT014
      *                                                                         CFT014
     C     TTREF         IFEQ      'OUR'                                        CFT014
     C                   MOVE      'A'           ODDADDC                        CFT014
     C                   ELSE                                                   CFT014
     C                   MOVE      'D'           ODDADDC                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Check if receiver's charges screen field needs to be changed           CFT014
     C     ODDADDC       IFEQ      'A'                                          CFT014
     C     ODDSMCY       ANDNE     I2INRCCN                                     CFT014
     C     I2INRCNW      ANDNE     0                                            CFT014
      ** Calculate receiver's charges network in settlement currency            CFT014
     C                   CLEAR                   P#0010                         CFT014
     C                   Z-ADD     WSLDT         P#FRDT                         CFT014
     C                   Z-ADD     WSLDT         P#TODT                         CFT014
     C                   MOVEL     I2INRCCN      P#FRCY                         CFT014
     C                   Z-ADD     I2INRCNW      P#FRAM                         CFT014
     C                   MOVEL     ODDSMCY       P#TOCY                         CFT014
     C                   Z-ADD     0             P#TOAM                         CFT014
     C                   Z-ADD     0             P#RATE                         CFT014
     C                   CALL      'FT0010'                                     CFT014
     C                   PARM                    P#0010                         CFT014
     C     P#RTCD        IFNE      *BLANKS                                      CFT014
     C                   Z-ADD     35            DBASE                          CFT014
     C                   MOVEL     'FT0010'      DBFILE                         CFT014
     C                   MOVEL     '*CALL '      DBKEY                          CFT014
     C                   EXSR      *PSSR                                        CFT014
     C                   ELSE                                                   CFT014
     C                   MOVE      *BLANKS       ZFIELD                         CFT014
     C                   MOVE      P#TOAM        ZFIELD                         CFT014
     C                   CALLB     'ZEDIT'                                      CFT014
     C                   PARM                    ZFIELD                         CFT014
     C                   PARM      WRCRMNDP      ZADEC                          CFT014
     C                   MOVE      ZFIELD        ODDRCRM                        CFT014
      ** Left-justify the amount                                                CFT014
     C                   Z-ADD     1             CX                             CFT014
     C                   MOVE      *BLANKS       WYA1                           CFT014
     C                   MOVEA     ODDRCRM       WYA1(1)                        CFT014
     C     WYA1(CX)      DOWEQ     *BLANK                                       CFT014
     C     CX            ANDLT     12                                           CFT014
     C                   ADD       1             CX                             CFT014
     C                   ENDDO                                                  CFT014
     C                   MOVE      *BLANKS       ODDRCRM                        CFT014
     C     CX            IFLE      12                                           CFT014
     C                   MOVEA     WYA1(CX)      ODDRCRM                        CFT014
     C                   ENDIF                                                  CFT014
     C                   ENDIF                                                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
     C                   ENDIF
      *
      ** Bank to Bank Information.
      *
      ** Access Settlement Currency details.
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '       '     PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      ODDSMCY       PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     P72           IFNE      *BLANKS
      *
     C                   MOVEL     P72           DSTRAN
     C                   MOVEL     TMLIN1        ODDBBI1
     C                   MOVEL     TMLIN2        ODDBBI2
     C                   MOVEL     TMLIN3        ODDBBI3
     C                   MOVEL     TMLIN4        ODDBBI4
     C                   MOVEL     TMLIN5        ODDBBI5
     C                   MOVEL     TMLIN6        ODDBBI6
      *                                                                         CFT014
     C     P33B          IFEQ      *BLANKS                                      CFT014
      *
     C     '/OCMT/'      SCAN      P72           WOCMT             3 0
      *
     C     WOCMT         IFNE      0
     C                   MOVEL     '/OCMT'       WCW
     C                   MOVEL     P72           WCWLIN
     C                   EXSR      SRFOCmt2
     C                   MOVEL     WCWCY         ODDNDCY
     C                   MOVEL     WCWAM         ODDNDAM
     C                   ENDIF
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *
     C                   ENDIF
      *
      ** Additional Mapping for CASHIER.
      *
      ** Pay Value Date/Currency/Amount.
      *
     C     SDCA          IFNE      *BLANKS
      *
     C                   Z-ADD     0             TVVDAT
     C                   MOVEL     SDCA          DSTRAN
      *
      ** Pay Value Date.
      *
     C     TVVDAT        IFNE      0
      *
     C                   MOVEL     TVVDAT        WWDT
      *
      ** MMDDYY format display.
      *
     C     BJDFIN        IFEQ      'M'
      *
     C                   EVAL      ODDPYDT = WD2 + WD3 + WD1
      *
     C                   ELSE
      *
      ** DDMMYY format display.
      *
     C                   EVAL      ODDPYDT = WD3 + WD2 + WD1
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Pay Currency.
      *
      ** Translate currency to Midas currency if it is a different                            225169
      ** SWIFT currency code.                                                                 225169
      *                                                                                       225169
     C                   MOVE      TVCCY         W_CCY                                        225169
     C                   EXSR      WTRNCY                                                     225169
     C                   MOVE      W_CCY         TVCCY                                        225169
      *                                                                                       225169
     C                   MOVEL     TVCCY         ODDPCCY
      *
      ** Pay Amount.
      *
      ** Format amount field (change ',' decimal point to '.').
      *
     C                   MOVEA     *BLANKS       WYA1
     C                   MOVEA     TVAMT         WYA1
     C                   Z-ADD     1             Cx
      *
     C     Cx            DOUGT     15
     C     WYA1(Cx)      IFEQ      ','
     C                   MOVE      '.'           WYA1(Cx)
     C                   Z-ADD     16            Cx
     C                   ELSE
     C                   ADD       1             Cx
     C                   ENDIF
     C                   ENDDO
      *
     C                   MOVEA     WYA1          WAMT
     C                   MOVEL     WAMT          ODDPYAM
      *
     C                   ENDIF
      *
      ** Funding Currency/Funding Amount.
      *
     C     PDC2          IFNE      *BLANKS
      *
     C                   Z-ADD     0             TVVDAT
     C                   MOVEL     PDC2          DSTRAN
      *
      ** Settlement Value Date.
      *
     C     TVVDAT        IFNE      0
      *
     C                   MOVEL     TVVDAT        WWDT
      *
      ** MMDDYY format display.
      *
     C     BJDFIN        IFEQ      'M'
      *
     C                   EVAL      ODDSLDT = WD2 + WD3 + WD1
      *
     C                   ELSE
      *
      ** DDMMYY format display.
      *
     C                   EVAL      ODDSLDT = WD3 + WD2 + WD1
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Settlement Currency.
      *
      ** Translate currency to Midas currency if it is a different                            225169
      ** SWIFT currency code.                                                                 225169
      *                                                                                       225169
     C                   MOVE      TVCCY         W_CCY                                        225169
     C                   EXSR      WTRNCY                                                     225169
     C                   MOVE      W_CCY         TVCCY                                        225169
      *                                                                                       225169
     C                   MOVEL     TVCCY         ODDSMCY
      *
      ** Settlement AMount.
      *
      ** Format amount field (change ',' decimal point to '.').
      *
     C                   MOVEA     *BLANKS       WYA1
     C                   MOVEA     TVAMT         WYA1
     C                   Z-ADD     1             Cx
      *
     C     Cx            DOUGT     15
     C     WYA1(Cx)      IFEQ      ','
     C                   MOVE      '.'           WYA1(Cx)
     C                   Z-ADD     16            Cx
     C                   ELSE
     C                   ADD       1             Cx
     C                   ENDIF
     C                   ENDDO
      *
     C                   MOVEA     WYA1          WAMT
     C                   MOVEL     WAMT          ODDSMAM
      *
     C                   ENDIF
      *
      ** Rate.
      *
     C     ODDPYAM       IFNE      *BLANKS
     C     ODDSMAM       ANDNE     *BLANKS
      *
      ** Get the numeric value of DDPYAM.
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      ODDPCCY       PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     ODDPCCY       DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     020           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        WPCYD             1 0
      *
      ** Align amount.
      *
     C                   Z-ADD     WPCYD         ZADEC
     C     11            SUB       WPCYD         ZADIG
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      ODDPYAM       ZFIELD
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZalignOk          1
     C                   PARM                    ZField           16
     C                   PARM                    ZADec             1 0
     C                   PARM                    ZADig             2 0
      *
     C     ZalignOK      IFEQ      'Y'
     C                   MOVE      ZFIELD        W1PYA            11 0
     C                   ENDIF
      *
      ** Get the numeric value of ODDSMAM.
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      ODDSMCY       PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     ODDSMCY       DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     021           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        WSMCY             1 0
      *
      ** Align amount.
      *
     C                   Z-ADD     WSMCY         ZADEC
     C     11            SUB       WSMCY         ZADIG
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      ODDSMAM       ZFIELD
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZalignOk
     C                   PARM                    ZField
     C                   PARM                    ZADec
     C                   PARM                    ZADig
      *
     C     ZalignOK      IFEQ      'Y'
     C                   MOVE      ZFIELD        W1SMA            11 0
     C                   ENDIF
      *
     C     W1PYA         IFNE      0
     C     W1SMA         ANDNE     0
      *
      ** Calculate the Rate by dividing the larger amount
      ** by the smaller amount.
      *
     C     W1PYA         IFGE      W1SMA
     C     W1PYA         DIV       W1SMA         W1RTE            11 7
     C                   MOVE      *BLANKS       ODDSMAM
     C                   ENDIF
      *
     C     W1SMA         IFGT      W1PYA
     C     W1PYA         DIV       W1SMA         W1RTE
     C                   MOVE      *BLANKS       ODDPYAM
     C                   ENDIF
      *
      ** Format Rate field.
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      W1RTE         ZFIELD
     C                   Z-ADD     7             ZADEC2            2 0
      *
     C                   CALLB     'ZAEDITM'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC2
      *
     C                   MOVE      ZFIELD        ODDRATE
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     PNWRK         IFEQ      'CASHV8'
      *
      ** Receiver's Correspondent and Ordering Bank.
      *
     C     P54           IFNE      *BLANKS
      *
     C                   MOVEL     P54           DSTRAN
     C*****              MOVEL     *BLANKS       ODDRCCO                        CFT014
     C*****              MOVEL     TMLIN         ODDRCCO                        CFT014
     C                   MOVEL     *BLANKS       ODDRCO1                        CFT014
     C                   MOVEL     TMLIN         ODDRCO1                        CFT014
     C                   MOVEL     *BLANKS       ODDOBK1
     C                   MOVEL     TMLIN         ODDOBK1
      *
     C                   ELSE
      *
      ** Use the default account code from CASH dataarea and
      ** build the account number.
      *
      ** Get Branch internal customer.
      *
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      ODDBRCA       PBRCH             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     ODDBRCA       DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   Z-ADD     022           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve Retail account number.
      *
     C                   MOVE      A8BICN        KACNUM
     C                   MOVEL     ODDSMCY       KACCCY
     C                   MOVE      WDACACD       KACCD
     C                   Z-ADD     1             KACSQ
     C                   MOVEL     ODDBRCA       KBRCA
      *
     C     KAccnt        CHAIN     ACCNT                              01
      *
     C     *IN01         IFEQ      *ON
     C                   MOVEL     WACKYDS       DBKEY
     C                   MOVEL     'ACCNT'       DBFILE
     C                   Z-ADD     023           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Move Retail account number to Receiver's Correspondent.
      *
     C*****              MOVEL     *BLANKS       ODDRCCO                        CFT014
     C*****              MOVE      ACNO          ODDRCCO                        CFT014
     C                   MOVEL     *BLANKS       ODDRCO1                        CFT014
     C                   MOVE      ACNO          ODDRCO1                        CFT014
      *
     C                   ENDIF
      *
      ** Account with Institution.
      *
     C     P57           IFNE      *BLANKS
     C                   MOVEL     P57           DSTRAN
     C                   MOVEL     *BLANKS       WREAC            10
     C                   MOVEL     TMLIN         WREAC
     C                   MOVEL     *BLANKS       ODDACBK
     C                   MOVEL     WREAC         ODDACBK
     C                   ENDIF
      *
     C                   MOVEL     'N'           ODDOPIN
      *
     C                   ENDIF
      *                                                                         CFT014
     C     CFT014        IFEQ      'Y'                                          CFT014
      *                                                                         CFT014
      ** Third Reimbursment Institution                                         CFT014
      *                                                                         CFT014
     C     P55           IFNE      *BLANKS                                      CFT014
      *                                                                         CFT014
     C                   MOVEL     *BLANK        DSTRAN                         CFT014
     C                   MOVEL     P55           DSTRAN                         CFT014
      *                                                                         CFT014
      ** Map 1st line of SWIFT values into screen fields                        CFT014
     C                   MOVEL     TMLIN1        ODDTRIB                        CFT014
      *                                                                         CFT014
     C     CFT004        IFEQ      'Y'                                          CFT014
      ** Check whether the field carries an IBAN                                CFT014
      ** If it is the case, move the IBAN into the 'screen' field               CFT014
      ** which will be validated afterwards                                     CFT014
     C                   MOVEL     ODDTRIB       P@IBAN           34            CFT014
      ** Check that it is a valid IBAN                                          CFT014
     C                   CALL      'AOIBANR2'                                   CFT014
     C                   PARM      *BLANKS       @RTCD                          CFT014
     C                   PARM                    P@IBAN                         CFT014
     C                   PARM      *BLANKS       DSSDY                          CFT014
      ** Network information is mapped onto the 'screen' field                  CFT014
     C     @RTCD         IFEQ      *BLANKS                                      CFT014
     C                   MOVEL     *BLANK        ODDTRIB                        CFT014
      ** '/' has been removed                                                   CFT014
     C                   MOVEL     P@IBAN        ODDTRIB                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Bank Operation Code                                                    CFT014
      *                                                                         CFT014
     C     P23B          IFNE      *BLANKS                                      CFT014
     C                   MOVEL     *BLANK        DSTRAN                         CFT014
     C                   MOVEL     P23B          DSTRAN                         CFT014
     C                   MOVEL     TTREF         ODDBOCD                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Instruction Code                                                       CFT014
      *                                                                         CFT014
     C     P23E          IFNE      *BLANKS                                      CFT014
     C                   MOVEL     *BLANK        DSTRAN                         CFT014
     C                   MOVEL     P23E          DSTRAN                         CFT014
     C                   MOVEL     TMLIN1        ODDICD1                        CFT014
     C                   MOVEL     TMLIN2        ODDICD2                        CFT014
     C                   MOVEL     TMLIN3        ODDICD3                        CFT014
     C                   MOVEL     TMLIN4        ODDICD4                        CFT014
     C                   MOVEL     TMLIN5        ODDICD5                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Transaction Code                                                       CFT014
      *                                                                         CFT014
     C     P26T          IFNE      *BLANKS                                      CFT014
     C                   MOVEL     *BLANK        DSTRAN                         CFT014
     C                   MOVEL     P26T          DSTRAN                         CFT014
     C                   MOVEL     TTREF         ODDTTCD                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Instructed Currency/Amount                                             CFT014
      *                                                                         CFT014
     C     P33B          IFNE      *BLANKS                                      CFT014
     C                   MOVEL     *BLANK        DSTRAN                         CFT014
     C                   MOVEL     P33B          DSTRAN                         CFT014
     C                   EXSR      SRCYAM33B                                    CFT014
     C                   MOVEL     WCACY         ODDNDCY                        CFT014
     C                   MOVEL     WCAAM         ODDNDAM                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Original Rate Currency/Amount                                          CFT014
      *                                                                         CFT014
     C     P36           IFNE      *BLANKS                                      CFT014
     C                   MOVEL     *BLANK        DSTRAN                         CFT014
     C                   MOVEL     P36           DSTRAN                         CFT014
     C                   EXSR      SRRATE36                                     CFT014
     C                   MOVEL     W36RT         ODDOEXR                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Regulatory Reporting                                                   CFT014
      *                                                                         CFT014
     C     P77B          IFNE      *BLANKS                                      CFT014
     C                   MOVEL     *BLANK        DSTRAN                         CFT014
     C                   MOVEL     P77B          DSTRAN                         CFT014
     C                   MOVEL     TMLIN1        ODDRRP1                        CFT014
     C                   MOVEL     TMLIN2        ODDRRP2                        CFT014
     C                   MOVEL     TMLIN3        ODDRRP3                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *
      ***Default*in*Book*Code.                                                                195063
      **********                                                                              195063
     C**********         MOVE      'FT'          ODDBOKC                                      195063
      *                                                                                       CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
      *                                                                                       CSW209
     C                   EVAL      ODDNWRK = PNWRK                                            CSW209
     C                   EVAL      ODDMTPY = PMTPY                                            CSW209
     C                   EVAL      ODDVALF = P119                                             CSW209
      *                                                                                       CSW209
      ** Set Ordering Customer (Cover)                                                        CSW209
      *                                                                                       CSW209
     C                   IF        PB50 <> *BLANKS                                            CSW209
     C                   EVAL      DSTRAN  = PB50                                             CSW209
     C                   EVAL      ODDCOC1 = TMLIN1                                           CSW209
     C                   EVAL      ODDCOC2 = TMLIN2                                           CSW209
     C                   EVAL      ODDCOC3 = TMLIN3                                           CSW209
     C                   EVAL      ODDCOC4 = TMLIN4                                           CSW209
     C                   EVAL      ODDCOC5 = TMLIN5                                           CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Set Ordering Institution (Cover)                                                     CSW209
      *                                                                                       CSW209
     C                   IF        PB52 <> *BLANKS                                            CSW209
     C                   EVAL      DSTRAN  = PB52                                             CSW209
     C                   EVAL      ODDCOB1 = TMLIN1                                           CSW209
     C                   EVAL      ODDCOB2 = TMLIN2                                           CSW209
     C                   EVAL      ODDCOB3 = TMLIN3                                           CSW209
     C                   EVAL      ODDCOB4 = TMLIN4                                           CSW209
     C                   EVAL      ODDCOB5 = TMLIN5                                           CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Set Intermediary Institution (Cover)                                                 CSW209
      *                                                                                       CSW209
     C                   IF        PB56 <> *BLANKS                                            CSW209
     C                   EVAL      DSTRAN = PB56                                              CSW209
     C                   EVAL      ODDCIB1 = TMLIN1                                           CSW209
     C                   EVAL      ODDCIB2 = TMLIN2                                           CSW209
     C                   EVAL      ODDCIB3 = TMLIN3                                           CSW209
     C                   EVAL      ODDCIB4 = TMLIN4                                           CSW209
     C                   EVAL      ODDCIB5 = TMLIN5                                           CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Set Account with Institution (Cover)                                                 CSW209
      *                                                                                       CSW209
     C                   IF        PB57 <> *BLANKS                                            CSW209
     C                   EVAL      DSTRAN = PB57                                              CSW209
     C                   EVAL      ODDCAB1 = TMLIN1                                           CSW209
     C                   EVAL      ODDCAB2 = TMLIN2                                           CSW209
     C                   EVAL      ODDCAB3 = TMLIN3                                           CSW209
     C                   EVAL      ODDCAB4 = TMLIN4                                           CSW209
     C                   EVAL      ODDCAB5 = TMLIN5                                           CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Set Beneficiary Customer (Cover)                                                     CSW209
      *                                                                                       CSW209
     C                   IF        PB59 <> *BLANKS                                            CSW209
     C                   EVAL      DSTRAN = PB59                                              CSW209
     C                   EVAL      ODDCBC1 = TMLIN1                                           CSW209
     C                   EVAL      ODDCBC2 = TMLIN2                                           CSW209
     C                   EVAL      ODDCBC3 = TMLIN3                                           CSW209
     C                   EVAL      ODDCBC4 = TMLIN4                                           CSW209
     C                   EVAL      ODDCBC5 = TMLIN5                                           CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Set Remittance Information (Cover)                                                   CSW209
      *                                                                                       CSW209
     C                   IF        PB70 <> *BLANKS                                            CSW209
     C                   EVAL      DSTRAN = PB70                                              CSW209
     C                   EVAL      ODDCDP1 = TMLIN1                                           CSW209
     C                   EVAL      ODDCDP2 = TMLIN2                                           CSW209
     C                   EVAL      ODDCDP3 = TMLIN3                                           CSW209
     C                   EVAL      ODDCDP4 = TMLIN4                                           CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Set Sender to Receiver Information (Cover)                                           CSW209
      *                                                                                       CSW209
     C                   IF        PB72 <> *BLANKS                                            CSW209
     C                   EVAL      DSTRAN = PB72                                              CSW209
     C                   EVAL      ODDCBB1 = TMLIN1                                           CSW209
     C                   EVAL      ODDCBB2 = TMLIN2                                           CSW209
     C                   EVAL      ODDCBB3 = TMLIN3                                           CSW209
     C                   EVAL      ODDCBB4 = TMLIN4                                           CSW209
     C                   EVAL      ODDCBB5 = TMLIN5                                           CSW209
     C                   EVAL      ODDCBB6 = TMLIN6                                           CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Set Instructed Currency/Amount (Cover)                                               CSW209
      *                                                                                       CSW209
     C                   IF        PB33B <> *BLANKS                                           CSW209
     C                   EVAL      DSTRAN = *BLANKS                                           CSW209
     C                   EVAL      DSTRAN = PB33B                                             CSW209
     C                   EXSR      SRCYAM33B                                                  CSW209
     C                   EVAL      ODDCICY = WCACY                                            CSW209
     C                   EVAL      ODDCIAM = WCAAM                                            CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   ENDIF                                                                CSW209
      *
      ** Default in Pay Currency.
      *
     C                   MOVE      ODDSMCY       ODDPCCY
      *
      ** Set up fields for Incoming FONTIS Messages.
      *
     C     PNWRK         IFEQ      'FONTIS'
     C                   EXSR      SRFont
     C                   ENDIF
      *
      ** Decode data if feature installed.
      *
     C     CFT002        IFEQ      'Y'
      *
      ** Call ME1580 to translate the data of the messages for
      ** FT fields.
      *
     C                   CALL      'ME1580'                             0101
     C                   PARM      '*TRANS  '    PACTD
     C                   PARM                    PHEAD
     C                   PARM                    PDATA
     C                   PARM                    PDAT2                                        CSW209
     C                   PARM      *BLANKS       PRTN
      *
      ** If call to program resulted in an error, then end program.
      *
     C     PRTN          IFEQ      '*ERROR*'
     C     *IN01         OREQ      *ON
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'ME1580'      DBFILE
     C                   Z-ADD     024           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If clearing, then copy.  Otherwise, map.
      *
     C                   EXSR      SRIMsg
      *
     C                   ENDIF
      *
      ** Initialise screen fields with details of the electronic
      ** message.
      *
     C                   MOVEL     CrIP1ScnFmt   NwIP1ScnFmt
     C                   MOVEL     CrIP1AScnFmt  NwIP1AScnFmt                   CFT014
     C                   MOVEL     CrIP2ScnFmt   NwIP2ScnFmt
     C                   MOVEL     CrIP3ScnFmt   NwIP3ScnFmt
     C                   MOVEL     CrIP4ScnFmt   NwIP4ScnFmt
     C                   MOVEL     CrIP4AScnFmt  NwIP4AScnFmt                   CFT014
     C                   MOVEL     CrIP5ScnFmt   NwIP5ScnFmt                    CFT014
     C                   MOVEL     CrIP6ScnFmt   NwIP6ScnFmt                    CFT014
     C                   MOVEL     CrIP6AScnFmt  NwIP6AScnFmt                                 CER030
      *                                                                                       CER030
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   MOVEL     CrIP7ScnFmt   NwIP7ScnFmt                                  CSW209
     C                   MOVEL     CrIP8ScnFmt   NwIP8ScnFmt                                  CSW209
     C                   ENDIF                                                                CSW209
      *
      *
      ** Set Reserved Electronic Message flag to 'Y'.
      *
     C                   MOVEL     'Y'           WEMSG
      *
      ** Reset Read Next Browse Subfile indicator.
      *
     C                   MOVEL     *BLANK        PRDNB
     C/COPY WNCPYSRC,FTIPAYSC20
     C
     C     EEISwft       ENDSR
      *
      *****************************************************************
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SRCYAM33B - Retrieve the amount/currency from tag 33B.       *         CFT014
      *           or a valid SWIFT Reference                          *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
      *                                                                         CFT014
     C     SRCYAM33B     BEGSR                                                  CFT014
                                                                                CFT014
      ** Inputs                                                                 CFT014
      ** ------                                                                 CFT014
      ** DS for tags  (will NOT be blanked at the end of the S/R)               CFT014
      **                                  DSTRAN                                CFT014
      ** Outputs                                                                CFT014
      ** -------                                                                CFT014
      ** Currency                                                               CFT014
     C     *LIKE         DEFINE    DDSMCY        WCACY                          CFT014
      ** Amount                                                                 CFT014
     C     *LIKE         DEFINE    DDSMAM        WCAAM                          CFT014
                                                                                CFT014
     C                   MOVEL     *Blank        WCACY                          CFT014
     C                   MOVEL     *Blank        WCAAM                          CFT014
                                                                                CFT014
      ** Currency                                                               CFT014
                                                                                CFT014
      ** Translate currency to Midas currency if it is a different                            225169
      ** SWIFT currency code.                                                                 225169
      *                                                                                       225169
     C                   MOVE      TTCCY         W_CCY                                        225169
     C                   EXSR      WTRNCY                                                     225169
     C                   MOVE      W_CCY         TTCCY                                        225169
      *                                                                                       225169
     C                   MOVEL     TTCCY         WCACY                          CFT014
                                                                                CFT014
      ** Amount                                                                 CFT014
      * Format amount field (change ',' decimal point to '.').                  CFT014
                                                                                CFT014
     C                   MOVE      *BLANKS       WYA1                           CFT014
     C                   MOVEA     TTAMT         WYA1                           CFT014
     C                   Z-ADD     1             CX                             CFT014
                                                                                CFT014
     C     CX            DOUGT     15                                           CFT014
                                                                                CFT014
     C     WYA1(CX)      IFEQ      ','                                          CFT014
     C                   MOVE      '.'           WYA1(CX)                       CFT014
     C                   Z-ADD     16            Cx                             CFT014
     C                   ELSE                                                   CFT014
     C                   ADD       1             Cx                             CFT014
     C                   ENDIF                                                  CFT014
                                                                                CFT014
     C                   ENDDO                                                  CFT014
                                                                                CFT014
     C                   MOVEA     WYA1          WAMT                           CFT014
     C                   MOVEL     WAMT          WCAAM                          CFT014
                                                                                CFT014
     C                   ENDSR                                                  CFT014
      *                                                                         CFT014
      *****************************************************************         CFT014
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SROV32AM  - Overwrite transaction amount                     *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
      *                                                                         CFT014
     C     SROV32AM      BEGSR                                                  CFT014
      *                                                                         CFT014
      ** Inputs                                                                 CFT014
      ** ------                                                                 CFT014
      ** Input amount                                                           CFT014
     C     *LIKE         DEFINE    DDSMAM        WOVIAM                         CFT014
      ** Input currency                                                         CFT014
     C     *LIKE         DEFINE    DDSMCY        WOVICY                         CFT014
      ** Receiver's Charges amount                                              CFT014
     C     *LIKE         DEFINE    DDSMAM        WOVRAM                         CFT014
      ** Receiver's Charges currency                                            CFT014
     C     *LIKE         DEFINE    DDSMCY        WOVRCY                         CFT014
      ** Operation                                                              CFT014
     C                   MOVE      WOVOPR        WOVOPR            4            CFT014
      ** Value date                                                             CFT014
     C     *LIKE         DEFINE    ZDateOut      WOVVLD                         CFT014
      *                                                                         CFT014
      ** Outputs                                                                CFT014
      ** -------                                                                CFT014
      ** Amount overwritten                                                     CFT014
     C     *LIKE         DEFINE    DDSMAM        WOVAMT                         CFT014
      *                                                                         CFT014
      ** Temporary variables                                                    CFT014
      ** -------------------                                                    CFT014
      ** Transaction amount numeric format                                      CFT014
     C     *LIKE         DEFINE    P#TOAM        WOVTAN                         CFT014
      ** Receiver's charges amount numeric format                               CFT014
     C     *LIKE         DEFINE    P#TOAM        WOVRCN                         CFT014
      *                                                                         CFT014
      ** Reset output parameters and temporary variables                        CFT014
      *                                                                         CFT014
     C                   MOVEL     *BLANK        WOVAMT                         CFT014
     C                   Z-ADD     0             WOVTAN                         CFT014
     C                   Z-ADD     0             WOVRCN                         CFT014
      *                                                                         CFT014
      ** Retrieve details of transaction currency                               CFT014
      *                                                                         CFT014
     C                   CALL      'AOCURRR0'                           8080    CFT014
     C                   PARM      *BLANKS       @RTCD                          CFT014
     C                   PARM      '*KEY   '     @OPTN                          CFT014
     C                   PARM      WOVICY        @CHR03            3            CFT014
     C     SDCURR        PARM      *BLANKS       DSSDY                          CFT014
      *                                                                         CFT014
      ** If both currencies are the same, we don't need to perform              CFT014
      ** currency conversion before doing operation on the amounts              CFT014
      *                                                                         CFT014
     C     WOVICY        IFEQ      WOVRCY                                       CFT014
      *                                                                         CFT014
     C     @RTCD         IFEQ      *BLANKS                                      CFT014
     C     *IN80         ANDEQ     *OFF                                         CFT014
     C                   Z-ADD     A6NBDP        TRNBDP            1 0          CFT014
     C                   Z-ADD     A6NBDP        RCNBDP            1 0          CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Format charges amount                                                  CFT014
     C                   MOVEL     *BLANK        ZFIELD                         CFT014
     C                   MOVEL     WOVRAM        ZFIELD                         CFT014
     C     13            SUB       RCNBDP        ZADIG                          CFT014
     C                   Z-ADD     RCNBDP        ZADEC                          CFT014
     C                   CALLB     'ZALIGN'                                     CFT014
     C                   PARM                    ZalignOK                       CFT014
     C                   PARM                    ZFIELD                         CFT014
     C                   PARM                    ZADEC                          CFT014
     C                   PARM                    ZADIG                          CFT014
     C     ZAlignOK      IFEQ      'Y'                                          CFT014
     C                   MOVE      ZFIELD        WOVRCN                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Format input amount                                                    CFT014
     C                   MOVEL     *BLANK        ZFIELD                         CFT014
     C                   MOVEL     WOVIAM        ZFIELD                         CFT014
     C     13            SUB       TRNBDP        ZADIG                          CFT014
     C                   Z-ADD     TRNBDP        ZADEC                          CFT014
     C                   CALLB     'ZALIGN'                                     CFT014
     C                   PARM                    ZalignOK                       CFT014
     C                   PARM                    ZFIELD                         CFT014
     C                   PARM                    ZADEC                          CFT014
     C                   PARM                    ZADIG                          CFT014
     C     ZAlignOK      IFEQ      'Y'                                          CFT014
     C                   MOVE      ZFIELD        WOVTAN                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   SELECT                                                 CFT014
     C                   WHEN      (WOVOPR = '*SUB')                            CFT014
      ** Final amount = Input amount - Charges amount                           CFT014
     C                   SUB       WOVRCN        WOVTAN                         CFT014
     C                   WHEN      (WOVOPR = '*ADD')                            CFT014
      ** Final amount = Input amount + Charges amount                           CFT014
     C                   ADD       WOVRCN        WOVTAN                         CFT014
     C                   ENDSL                                                  CFT014
      *                                                                         CFT014
      ** Format Final amount                                                    CFT014
     C                   MOVEL     *BLANK        ZFIELD                         CFT014
     C                   MOVE      WOVTAN        ZFIELD                         CFT014
     C                   Z-ADD     TRNBDP        ZADEC                          CFT014
     C                   CALLB     'ZEDIT'                                      CFT014
     C                   PARM                    ZFIELD                         CFT014
     C                   PARM                    ZADEC                          CFT014
     C                   MOVE      ZFIELD        WOVAMT                         CFT014
      *                                                                         CFT014
     C                   ELSE                                                   CFT014
      *                                                                         CFT014
      ** Currencies are different                                               CFT014
      *                                                                         CFT014
      ** Begin to fill parameters for FT0010 (currency conversion)              CFT014
     C                   CLEAR                   P#0010                         CFT014
     C                   MOVEL     WOVRCY        P#FRCY                         CFT014
     C                   MOVEL     WOVICY        P#TOCY                         CFT014
      *                                                                         CFT014
     C     @RTCD         IFEQ      *BLANKS                                      CFT014
     C     *IN80         ANDEQ     *OFF                                         CFT014
     C                   Z-ADD     A6NBDP        TRNBDP                         CFT014
     C                   ENDIF                                                  CFT014
     C                   Z-ADD     WOVVLD        P#FRDT                         CFT014
     C                   Z-ADD     WOVVLD        P#TODT                         CFT014
      *                                                                         CFT014
      ** Retrieve details of currency of Receiver's Charges                     CFT014
     C                   CALL      'AOCURRR0'                           8080    CFT014
     C                   PARM      *BLANKS       @RTCD                          CFT014
     C                   PARM      '*KEY   '     @OPTN                          CFT014
     C                   PARM      WOVRCY        @CHR03                         CFT014
     C     SDCURR        PARM      *BLANKS       DSSDY                          CFT014
      *                                                                         CFT014
     C     @RTCD         IFEQ      *BLANKS                                      CFT014
     C     *IN80         ANDEQ     *OFF                                         CFT014
     C                   Z-ADD     A6NBDP        RCNBDP                         CFT014
      ** Format charges amount                                                  CFT014
     C                   MOVEL     *BLANK        ZFIELD                         CFT014
     C                   MOVEL     WOVRAM        ZFIELD                         CFT014
     C     13            SUB       RCNBDP        ZADIG                          CFT014
     C                   Z-ADD     RCNBDP        ZADEC                          CFT014
     C                   CALLB     'ZALIGN'                                     CFT014
     C                   PARM                    ZalignOK                       CFT014
     C                   PARM                    ZFIELD                         CFT014
     C                   PARM                    ZADEC                          CFT014
     C                   PARM                    ZADIG                          CFT014
     C     ZAlignOK      IFEQ      'Y'                                          CFT014
     C                   MOVE      ZFIELD        P#FRAM                         CFT014
     C                   ENDIF                                                  CFT014
      ** Convert the :71G: amount into the :32A: currency                       CFT014
     C                   CALL      'FT0010'                                     CFT014
     C                   PARM                    P#0010                         CFT014
     C     P#RTCD        IFNE      *BLANK                                       CFT014
     C                   MOVEL     'FT0010 '     DBFILE                         CFT014
     C                   MOVEL     '*CALL  '     DBKEY                          CFT014
     C                   Z-ADD     34            DBASE                          CFT014
     C                   EXSR      *PSSR                                        CFT014
     C                   ELSE                                                   CFT014
     C                   Z-ADD     P#TOAM        WOVRCN           13 0          CFT014
      ** Format input amount                                                    CFT014
     C                   MOVEL     *BLANK        ZFIELD                         CFT014
     C                   MOVEL     WOVIAM        ZFIELD                         CFT014
     C     13            SUB       TRNBDP        ZADIG                          CFT014
     C                   Z-ADD     TRNBDP        ZADEC                          CFT014
     C                   CALLB     'ZALIGN'                                     CFT014
     C                   PARM                    ZalignOK                       CFT014
     C                   PARM                    ZFIELD                         CFT014
     C                   PARM                    ZADEC                          CFT014
     C                   PARM                    ZADIG                          CFT014
     C     ZAlignOK      IFEQ      'Y'                                          CFT014
     C                   MOVE      ZFIELD        WOVTAN           13 0          CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   SELECT                                                 CFT014
     C                   WHEN      (WOVOPR = '*SUB')                            CFT014
      ** Final amount = Input amount - Charges amount                           CFT014
     C                   SUB       WOVRCN        WOVTAN                         CFT014
     C                   WHEN      (WOVOPR = '*ADD')                            CFT014
      ** Final amount = Input amount + Charges amount                           CFT014
     C                   ADD       WOVRCN        WOVTAN                         CFT014
     C                   ENDSL                                                  CFT014
      *                                                                         CFT014
      ** Format Final amount                                                    CFT014
     C                   MOVEL     *BLANK        ZFIELD                         CFT014
     C                   MOVE      WOVTAN        ZFIELD                         CFT014
     C                   Z-ADD     TRNBDP        ZADEC                          CFT014
     C                   CALLB     'ZEDIT'                                      CFT014
     C                   PARM                    ZFIELD                         CFT014
     C                   PARM                    ZADEC                          CFT014
     C                   MOVE      ZFIELD        WOVAMT                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Reset input parameters                                                 CFT014
      *                                                                         CFT014
     C                   MOVEL     *BLANK        WOVIAM                         CFT014
     C                   MOVEL     *BLANK        WOVICY                         CFT014
     C                   MOVEL     *BLANK        WOVRAM                         CFT014
     C                   MOVEL     *BLANK        WOVRCY                         CFT014
     C                   MOVEL     *BLANK        WOVOPR                         CFT014
     C                   Z-ADD     0             WOVVLD                         CFT014
                                                                                CFT014
     C                   ENDSR                                                  CFT014
      *                                                                         CFT014
      *****************************************************************         CFT014
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SRRATE36  - Retrieve rate from tag 36                        *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
      *                                                                         CFT014
     C     SRRATE36      BEGSR                                                  CFT014
      *                                                                         CFT014
      ** Inputs                                                                 CFT014
      ** ------                                                                 CFT014
      ** Code work lines                                                        CFT014
      **                                  DSTRAN                                CFT014
      ** Outputs                                                                CFT014
      ** -------                                                                CFT014
      ** Rate                                                                   CFT014
     C     *LIKE         DEFINE    DDOEXR        W36RT                          CFT014
      ** Decimal Position Truncated                                             CFT014
     C     *LIKE         DEFINE    A6NBDP        W36DPT                         CFT014
      ** Decimal Position                                                       CFT014
     C     *LIKE         DEFINE    A6NBDP        W36DP            +1            CFT014
      *                                                                         CFT014
     C                   MOVEL     *BLANK        W36RT                          CFT014
     C                   Z-ADD     0             W36DPT                         CFT014
     C                   Z-ADD     0             W36DP                          CFT014
      *                                                                         CFT014
      ** Map Rate                                                               CFT014
      ** Move possible 12 chars to work array and work string                   CFT014
      *                                                                         CFT014
     C     12            SUBST     TMLIN1:1      @R               13            CFT014
     C                   MOVEA     @R            W@R1                           CFT014
     C                   CLEAR                   @R                             CFT014
      *                                                                         CFT014
      ** If ',' in rate string @R change to '.'                                 CFT014
      ** Only need to check valid chars till one ',' found                      CFT014
     C                   Z-ADD     1             @C                3 0          CFT014
     C                   MOVE      *BLANK        @T                1            CFT014
      *                                                                         CFT014
     C     1             DO        12            @C                             CFT014
      *                                                                         CFT014
     C     W@R1(@C)      IFEQ      ','                                           CFT014
     C                   MOVE      '.'           W@R1(@C)                        CFT014
      ** Retrieve the number of decimal position                                CFT014
     C     W@CHK         CHECK     WWR1          @F                3 0           CFT014
     C     @F            IFNE      0                                            CFT014
     C     @F            SUB       1             @F                             CFT014
     C     @F            SUB       @C            W36DP                          CFT014
     C                   ELSE                                                   CFT014
     C     12            SUB       @C            W36DP                          CFT014
     C                   ENDIF                                                  CFT014
      ** Decimal position can be handled only on one 1 digit                    CFT014
      ** => range 0-9  (otherwise truncated to 9)                               CFT014
     C     W36DP         IFGT      9                                            CFT014
     C                   Z-ADD     9             W36DPT                         CFT014
     C                   ELSE                                                   CFT014
     C                   Z-ADD     W36DP         W36DPT                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   LEAVE                                                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDDO                                                  CFT014
      *                                                                         CFT014
     C                   Z-ADD     1             @C                             CFT014
     C                   MOVE      *BLANKS       @T                1            CFT014
     C                   MOVEA     W@R1          @R                              CFT014
      *                                                                         CFT014
      ** Get amount - upto 12 chars possible                                    CFT014
      *                                                                         CFT014
     C     @C            DOUGT     12                                           CFT014
      *                                                                         CFT014
     C                   MOVE      W@R1(@C)      @T                              CFT014
     C     W@CHK         CHECK     @T            @F                       82    CFT014
      *                                                                         CFT014
      ** Char not valid must be end of rate                                     CFT014
     C     *IN82         IFEQ      *ON                                          CFT014
     C     @C            IFNE      1                                            CFT014
     C     @C            SUB       1             @F                             CFT014
     C     @F            SUBST     @R:1          W36RT                          CFT014
     C                   ENDIF                                                  CFT014
     C                   LEAVE                                                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** All chars in string are ok                                             CFT014
     C     @C            IFEQ      12                                           CFT014
     C                   MOVEL     @R            W36RT                          CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ADD       1             @C                             CFT014
      *                                                                         CFT014
     C                   ENDDO                                                  CFT014
      *                                                                         CFT014
     C                   ENDSR                                                  CFT014
      *                                                                         CFT014
      *****************************************************************         CFT014
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMKey - To determine if the SWIFT Reference holds a '?'     *
      *           or a valid SWIFT Reference                          *
      *                                                               *
      *****************************************************************
      *
     C     SRMKey        BEGSR
      *
      ** Set up part number parameter.
      *
     C                   MOVEL     DDSEQNO       WSEQNO            2 0
      *
     C     WSEQNO        IFEQ      0
     C                   Z-ADD     1             PKPRT
     C                   ELSE
     C                   Z-ADD     WSEQNO        PKPRT
     C                   ENDIF
      *
      ** The SWIFT Reference may hold either a '?' or an actual SWIFT
      ** Reference.  The called program will determine which.
      *
     C                   CALL      'ME1080'                             0101
     C                   PARM      '*KEY   '     PACT              7
     C     PHMSGR        PARM      *ZEROS        PMSGR             8 0
     C     PHPART        PARM                    PKPRT             3 0
     C     PHMOR         PARM      DDSWTN        PMOR             28
     C     PHMIR         PARM      DDSWTN        PMIR             28
     C                   PARM      *BLANKS       PRTN              7
      *
      ** If call to program resulted in an error, then end program.
      *
     C     PRTN          IFEQ      '*ERROR*'
     C     *IN01         OREQ      *ON
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'ME1080'      DBFILE
     C                   Z-ADD     025           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** F3 - end program.
      *
     C     PRTN          IFEQ      'Y2U9999'
     C                   MOVEL     'Y'           WErr
     C                   EXSR      SREndP
     C                   GOTO      EMKey
     C                   ENDIF
      *
      ** F12 - cancel.  Redisplay Initial screen.
      *
     C     PRTN          IFEQ      'USR0790'
     C                   MOVEL     'Y'           WErr
     C                   MOVEL     'MIN0001'     PErrMs
     C                   EXSR      SRSndM
     C                   GOTO      EMKey
     C                   ENDIF
      *
      ** MIN0105 - Reserved message found.
      *
      ** If there is an electronic message for the current job, then
      ** prepare input fields for processing.  Messages that are
      ** selected using the '?' facility are reserved at time of
      ** selection.
      *
     C     PRTN          IFEQ      'MIN0105'
     C                   MOVEL     'Y'           WEMSG
     C                   MOVEL     PMIR          DDSWTN
     C                   GOTO      EMKey
     C                   ENDIF
      *
      ** MIN0106 - No reserved messages to process.
      *
      ** If there is no electronic message for the current job, then
      ** clear the SWIFT Reference field and set on error indicator.
      ** On return to SREISwft, control will return immediately
      ** to Initial screen processing.
      *
     C     PRTN          IFEQ      'MIN0106'
     C                   MOVEL     'Y'           WErr
     C                   MOVEL     'MIN0106'     PErrMs
     C                   EXSR      SRSndM
     C                   MOVEL     *BLANKS       DDSWTN
     C                   GOTO      EMKey
     C                   ENDIF
      *
      ** Message may not be processed by FT.
      *
     C     PRTN          IFEQ      'MIN0197'
     C                   MOVEL     'Y'           WErr
     C                   MOVEL     'MIN0197'     PErrMs
     C                   EXSR      SRSndM
     C                   MOVEL     *BLANKS       DDSWTN
     C                   GOTO      EMKey
     C                   ENDIF
      *
      ** A SWIFT Reference was entered.
      *
      ** If any errors are detected, an error indicator is set on,
      ** control returns to SREISwft and from there, returns
      ** immediately to Initial screen processing.
      *
      ** MIN0101 - SWIFT Reference not found or invalid.
      *
     C     PRTN          IFEQ      'MIN0101'
     C                   MOVEL     'Y'           WErr
     C                   MOVEL     'MIN0101'     PErrMs
     C                   MOVE      'N'           OKSWTN
     C                   EXSR      SRSndM
     C                   GOTO      EMKey
     C                   ENDIF
      *
      ** MIN0100 - Message part does not exist or has already been
      ** processed by Funds Transfer.
      *
     C     PRTN          IFEQ      'MIN0100'
     C                   MOVEL     'Y'           WErr
     C                   MOVEL     'MIN0100'     PErrMs
     C                   MOVE      'N'           OKSWTN
     C                   EXSR      SRSndM
     C                   GOTO      EMKey
     C                   ENDIF
      *
      ** MIN0103 - SWIFT Reference already reserved for this job.
      *
     C     PRTN          IFEQ      'MIN0103'
     C                   MOVEL     'Y'           WErr
     C                   MOVEL     'MIN0103'     PErrMs
     C                   MOVE      'N'           OKSWTN
     C                   EXSR      SRSndM
     C                   GOTO      EMKey
     C                   ENDIF
      *
      ** MIN0104 - SWIFT Reference reserved for another job.
      *
     C     PRTN          IFEQ      'MIN0104'
     C                   MOVEL     'Y'           WErr
     C                   MOVEL     'MIN0104'     PErrMs
     C                   MOVE      'N'           OKSWTN
     C                   EXSR      SRSndM
     C                   GOTO      EMKey
     C                   ENDIF
      *
      ** MIN0112 - Valid SWIFT Reference found - not yet reserved.
      *
      ** If the SWIFT Reference is valid and available for use, then
      ** a reservation on the Reserved Messages file will be made after
      ** further validation in SREISwft.
      *
      ** Messages that are selected using the '?' facility are reserved
      ** at time of selection.
      *
     C     PRTN          IFEQ      'MIN0112'
     C                   MOVEL     'MIN0112'     PErrMs
     C                   EXSR      SRSndM
     C                   ENDIF
      *
     C     EMKey         ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMsgRsv - To reserve a selected/entered electronic message  *
      *             for use by the current job only                   *
      *                                                               *
      *****************************************************************
      *
     C     SRMsgRsv      BEGSR
      *
      ** The SWIFT Reference must be written to the reserved messages
      ** file to prevent other workstations accessing it for update.
      *
     C                   CALL      'ME1070'                             0101
     C                   PARM      '*RESERV'     PACT
     C                   PARM                    PMSGR
     C                   PARM                    PKPRT
     C                   PARM                    PMOR
     C                   PARM                    PMIR
     C                   PARM      *BLANKS       PRTN
      *
      ** If call to program resulted in an error, then end program.
      *
     C     PRTN          IFEQ      '*ERROR*'
     C     *IN01         OREQ      *ON
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'ME1070'      DBFILE
     C                   Z-ADD     026           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If any errors are detected, an error indicator is set on,
      ** control returns to SREISwft and from there, returns
      ** to Initial screen processing.
      *
      ** MIN0107 - Message previously reserved for this job.
      *
     C     PRTN          IFEQ      'MIN0107'
     C                   MOVEL     'Y'           WErr
     C                   MOVEL     'MIN0107'     PErrMs
     C                   MOVE      'N'           OKSWTN
     C                   EXSR      SRSndM
     C                   GOTO      EMsgRsv
     C                   ENDIF
      *
      ** MIN0108 - Message already reserved for another job.
      *
     C     PRTN          IFEQ      'MIN0108'
     C                   MOVEL     'Y'           WErr
     C                   MOVEL     'MIN0108'     PErrMs
     C                   MOVE      'N'           OKSWTN
     C                   EXSR      SRSndM
     C                   GOTO      EMsgRsv
     C                   ENDIF
      *
      ** If the SWIFT Reference is valid and available for use, then
      ** a reservation on the Reserved Messages file was made.
      *
      ** MIN0109 - Message is now reserved for this job.
      *
     C     PRTN          IFEQ      'MIN0109'
     C                   MOVEL     'MIN0109'     PErrMs
     C                   EXSR      SRSndM
      **                                                                                      CSC022
      ** Execute commit if SAR CSC022 is not enrolled or                                      CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   ENDIF
      *
     C     EMsgRsv       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFOCmt2 - Extraction of field 72 from SWIFT Message         *
      *                                                               *
      *****************************************************************
      *
     C     SRFOCmt2      BEGSR
      *
      ** Initialise working fields for FONTIS.
      *
     C                   MOVE      *BLANKS       WCWCY             3
     C                   MOVE      *BLANKS       WCWAM            14
      *
      ** Retrieve Notified Delivery Currency and Amount.
      *
     C                   MOVEL     '012345'      WCHK             11
     C                   MOVE      '6789.'       WCHK
      *
     C     WCW           SCAN      WCWLIN:1      WF                3 0    01
      *
     C     *IN01         IFEQ      *ON
      *
      ** Map Currency Code -> ODDNDCY.
      *
     C                   ADD       6             WF
     C     3             SUBST     WCWLIN:WF     WCWCY
      *
      ** Translate currency to Midas currency if it is a different                            225169
      ** SWIFT currency code.                                                                 225169
      *                                                                                       225169
     C                   MOVE      WCWCY         W_CCY                                        225169
     C                   EXSR      WTRNCY                                                     225169
     C                   MOVE      W_CCY         WCWCY                                        225169
      *                                                                                       225169
      ** Map Amount -> ODDNDAM.
      *
      ** Move possible 15 chars to work array and work string.
      *
     C                   ADD       3             WF
     C     15            SUBST     WCWLIN:WF     WS               15
     C                   MOVEA     WS            WA
     C                   CLEAR                   WS
      *
      ** If ',' in amount string WS, change to '.'.
      ** Only need to check valid chars till one ',' found.
      *
     C                   Z-ADD     1             WC                3 0
     C                   MOVE      *BLANKS       WT                1
      *
     C     1             DO        15            WC
     C                   MOVE      WA(WC)        WT
     C     WT            IFEQ      ','
     C                   MOVE      '.'           WA(WC)
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
     C                   Z-ADD     1             WC
     C                   MOVE      *BLANKS       WT                1
     C                   MOVEA     WA            WS
      *
      ** Get Amount - up to 15 chars possible.
      *
     C     WC            DOUGT     15
      *
     C                   MOVE      WA(WC)        WT
     C     WCHK          CHECK     WT            WF                       01
      *
      ** Char not valid, must be end of Amount.
      *
     C     *IN01         IFEQ      *ON
     C     WC            IFNE      1
     C     WC            SUB       1             WF
     C     WF            SUBST     WS:1          WCWAM
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF
      *
      ** All chars in string ok.
      *
     C     WC            IFEQ      15
     C                   MOVEL     WS            WCWAM
     C                   ENDIF
      *
     C                   ADD       1             WC
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Reset variables.
      *
     C                   MOVEL     *BLANKS       WCWLIN          256
     C                   MOVEL     *BLANKS       WCW               6
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFont - Map translated data for Incoming FONTIS Messages    *
      *                                                               *
      *****************************************************************
      *
     C     SRFont        BEGSR
      *
      ** Set up defaults for FONTIS.
      *
     C                   MOVE      'N'           ODDSWPC
     C                   MOVE      *BLANKS       ODDACBK
     C                   MOVE      *BLANKS       ODDACBB
      *
      ** Retrieve Electronic Banking ICD details.
      *
     C                   CALL      'AOFONTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST'      POPTN
     C     SDFONT        PARM      SDFONT        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST'      DBKEY
     C                   MOVEL     'SDFONTPD'    DBFILE
     C                   Z-ADD     027           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      F8IPST        ODDPYST
     C                   MOVE      F8TBKC        ODDBOKC
      *
      ** Related Reference.
      *
     C     P20           IFNE      *BLANKS
     C                   MOVEL     P20           DSTRAN
     C                   MOVEL     TTREF         IPRLPR
     C                   MOVEL     TTREF         ODDRLPR
     C                   ELSE
     C                   MOVEL     *BLANKS       IPRLPR
     C                   MOVEL     *BLANKS       ODDRLPR
     C                   ENDIF
      *
      ** Pay Currency/Value Date/Amount.
      *
     C     PDCA          IFNE      *BLANKS
      *
     C                   MOVEL     PDCA          DSTRAN
      *
      ** Pay Currency.
      *
     C                   MOVEL     TVCCY         ODDPCCY
      *
      ** Pay Amount.
      *
      ** Format amount field (change ',' decimal point to '.').
      *
     C                   MOVEA     *BLANKS       WYA1
     C                   MOVEA     TVAMT         WYA1
     C                   Z-ADD     1             Cx
      *
     C     Cx            DOUGT     15
     C     WYA1(Cx)      IFEQ      ','
     C                   MOVE      '.'           WYA1(Cx)
     C                   Z-ADD     16            Cx
     C                   ELSE
     C                   ADD       1             Cx
     C                   ENDIF
     C                   ENDDO
      *
     C                   MOVEA     WYA1          WNLAM
     C                   MOVEA     WYA1          WWPYAM           14
      *
     C                   EXSR      SRNull
      *
     C     WNLNUL        IFEQ      'N'
     C                   MOVEL     WWPYAM        ODDPYAM
     C                   ELSE
     C                   MOVEL     *BLANKS       ODDPYAM
     C                   ENDIF
      *
      ** Pay Value Date.
      *
     C                   MOVEL     TVVDAT        WWDT
      *
      ** MMDDYY format display.
      *
     C     BJDFIN        IFEQ      'M'
      *
     C                   EVAL      ODDPYDT = WD2 + WD3 + WD1
      *
     C                   ELSE
      *
      ** DDMMYY format display.
      *
     C                   EVAL      ODDPYDT = WD3 + WD2 + WD1
      *
     C                   ENDIF
      *
     C                   CALLB     'ZDATE1'
     C                   PARM      ODDPYDT       PDateIn           6
     C                   PARM      *ZERO         PDaynoOut         5 0
     C                   PARM      BJDFIN        PDateFmt          1
     C                   PARM                    PError            1
      *
     C     PError        IFNE      'Y'
     C                   Z-ADD     PDaynoOut     WVLDT
     C                   ELSE
     C                   Z-ADD     BJRDNB        WVLDT             5 0
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Debit Account.
      *
     C     P53           IFNE      *BLANKS
      *
     C                   MOVE      *BLANKS       WWP53P           35
     C                   MOVEL     P53           DSTRAN
     C                   MOVEL     TMLIN1        WWP53
      *
     C     WWP53A        IFEQ      '/'
     C                   MOVEL     WWP53B        WWP53P
     C                   ENDIF
      *
     C                   MOVEL     *BLANKS       ODDSND2
     C                   MOVEL     *BLANKS       ODDSND3
     C                   MOVEL     *BLANKS       ODDSND4
      *
     C     ' '           CHECKR    WWP53P        WWLEN             2 0
      *
      ** Check if it is a Retail Account.
      *
     C     WWLEN         IFEQ      10
      *
     C                   MOVEL     WWP53P        PPRETL
     C                   MOVEL     *BLANKS       PPCNUM
     C                   MOVEL     *BLANKS       PPCUCD
     C                   MOVEL     *BLANKS       PPACCD
     C                   MOVEL     *BLANKS       PPACSQ
     C                   MOVEL     *BLANKS       PPBRCA
      *
     C                   ELSE
      *
      ** Account is not Retail but General Ledger.
      *
     C                   MOVEL     *BLANKS       PPRETL
     C     3             SUBST     WWP53P:1      PPBRCA
     C     6             SUBST     WWP53P:4      PPCNUM
     C     3             SUBST     WWP53P:10     PPCUCD
     C     10            SUBST     WWP53P:13     PPACCD                                       CGL029
     C     2             SUBST     WWP53P:23     PPACSQ                                       CGL029
     C*****4****         SUBST     WWP53P:13     PPACCD                                       CGL029
     C*****2****         SUBST     WWP53P:17     PPACSQ                                       CGL029
      *
     C                   ENDIF
      *
      ** Access Account Details.
      *
     C                   CALLB     'AOACCTR0'
     C                   PARM      *BLANKS       PPRTCD            7
     C                   PARM      '*KEY   '     PPOPTN            7
     C                   PARM                    PPRETL           10
     C                   PARM                    PPCNUM            6
     C                   PARM                    PPCUCD            3
     C**********         PARM                    PPACCD            4                          CGL029
     C                   PARM                    PPACCD                                       CGL029
     C                   PARM                    PPACSQ            2
     C                   PARM                    PPBRCA            3
     C     SDACCT        PARM      SDACCT        DSSDY

     C                   IF        PRTCD = *BLANKS
      *
      ** If it is a G/L Account, we put the Branch as the end
      ** (BRCA/CUST/CCY/ACOD/SEQ) => (CUST/CCY/ACOD/SEQ/BRCA).
      ** If it is a Retail one, we don't format it.
      *
     C     WWLEN         IFEQ      10
     C                   MOVEL     WWP53P        ODDSND1
     C                   ELSE
     C     3             SUBST     WWP53P:1      WGLBCH
     C     3             SUBST     WWP53P:10     WGLCCY
     C     6             SUBST     WWP53P:4      WGLCST
     C     10            SUBST     WWP53P:13     WGLACD                                       CGL029
     C     2             SUBST     WWP53P:23     WGLSQN                                       CGL029
     C*****4****         SUBST     WWP53P:13     WGLACD                                       CGL029
     C*****2****         SUBST     WWP53P:17     WGLSQN                                       CGL029
     C                   MOVEL     WDSGLDG       ODDSND1
     C                   ENDIF
      *
     C                   MOVEL     IFBRCA        ODDBRCA
     C                   MOVEL     IFBRCA        ODDORBR

     C                   ELSE
      *
      ** If no valid account in tag 53 we concatenate line of
      ** 53 (A/C debited)  + first lines of 50 (Ord Cust)
     C                   MOVEL     WWP53P        ODDSND1
     C                   MOVEL     P50           DSTRAN
     C                   MOVEL     TMLIN1        ODDSND2
     C                   MOVEL     TMLIN2        ODDSND3
     C                   MOVEL     TMLIN3        ODDSND4
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Profit Centre.
      *
     C     BKPRCU        IFEQ      'Y'
      *
      ** Retrieve default Profit Centre.
      *
     C     BKPCDU        IFEQ      'Y'
      *
     C                   CALLB     'AOPRFMR0'                           01
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      ODDBOKC       PBOKC             2
     C                   PARM      PPYTP         PTRTP             5
     C                   PARM      ODDPYST       PSUTP             2
     C                   PARM      ODDBRCA       PBRAN             3
     C                   PARM      *BLANKS       PDEPT             3
     C                   PARM      *BLANKS       PUSER            10
     C                   PARM      *BLANKS       PACOF             2
     C                   PARM      *BLANKS       PCUST             6
     C     ODDPRFC       PARM      *BLANKS       PPRFC             4
      *
     C                   IF        *In01 = *On
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'AOPRFMR0'    DBFILE
     C                   Z-ADD     028           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ODDPRFC       IFEQ      *BLANKS
     C                   MOVEL     F8TPFC        ODDPRFC
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Beneficiary Customer.
      *
     C     P59           IFNE      *BLANKS
      *
     C                   MOVE      *BLANKS       WWP59P           35
     C                   MOVEL     P59           DSTRAN
     C                   MOVEL     TMLIN1        WWP59
      *
     C     WWP59A        IFEQ      '/'
     C                   MOVEL     WWP59B        WWP59P
     C                   ENDIF
      *
     C     ' '           CHECKR    WWP59P        WWLEN
      *
      ** Check if it is a Retail Account.
      *
     C     WWLEN         IFEQ      10
      *
     C                   MOVEL     WWP59P        PPRETL
     C                   MOVEL     *BLANKS       PPCNUM
     C                   MOVEL     *BLANKS       PPCUCD
     C                   MOVEL     *BLANKS       PPACCD
     C                   MOVEL     *BLANKS       PPACSQ
     C                   MOVEL     *BLANKS       PPBRCA
      *
     C                   ELSE
      *
      ** Account is not Retail but General Ledger.
      *
     C                   MOVEL     *BLANKS       PPRETL
     C     3             SUBST     WWP59P:1      PPBRCA
     C     6             SUBST     WWP59P:4      PPCNUM
     C     3             SUBST     WWP59P:10     PPCUCD
     C     10            SUBST     WWP59P:13     PPACCD                                       CGL029
     C     2             SUBST     WWP59P:23     PPACSQ                                       CGL029
     C*****4****         SUBST     WWP59P:13     PPACCD                                       CGL029
     C*****2****         SUBST     WWP59P:17     PPACSQ                                       CGL029
      *
     C                   ENDIF
      *
      ** Access Account details.
      *
     C                   CALL      'AOACCTR0'
     C                   PARM      *BLANKS       PPRTCD
     C                   PARM      '*KEY   '     PPOPTN
     C                   PARM                    PPRETL
     C                   PARM                    PPCNUM
     C                   PARM                    PPCUCD
     C                   PARM                    PPACCD
     C                   PARM                    PPACSQ
     C                   PARM                    PPBRCA
     C     SDACCT        PARM      SDACCT        DSSDY
      *
     C     PPRTCD        IFEQ      *BLANKS
      *
     C     WWLEN         IFEQ      10
     C                   MOVEL     WWP59P        ODDBNC1
     C                   ELSE
     C     3             SUBST     WWP59P:1      WWBCH1
     C     6             SUBST     WWP59P:4      WWCUS1
     C     10            SUBST     WWP59P:13     WWACD1                                       CGL029
     C     2             SUBST     WWP59P:23     WWSQN1                                       CGL029
     C*****4****         SUBST     WWP59P:13     WWACD1                                       CGL029
     C*****2****         SUBST     WWP59P:17     WWSQN1                                       CGL029
     C                   MOVEL     WWBNC1        ODDBNC1
     C                   ENDIF
      *
     C                   MOVEL     *BLANKS       ODDBNC2
     C                   MOVEL     *BLANKS       ODDBNC3
     C                   MOVEL     *BLANKS       ODDBNC4
     C                   MOVEL     *BLANKS       ODDBNC5
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Details of Charges.
      *
     C     P71           IFNE      *BLANKS
      *
     C                   MOVEL     P71           DSTRAN
      *
     C     TTREF         IFEQ      'OUR'
     C                   MOVEL     'A'           ODDADDC
     C                   ELSE
     C                   MOVEL     'D'           ODDADDC
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVEL     'D'           ODDADDC
      *
     C                   ENDIF
      *
      ** Sender to Receiver Information.
      *
     C     P72           IFEQ      *BLANKS
      *
      ** Settlement CCY will be the same as the Account to be Debited.
      *
     C                   MOVEL     *BLANKS       ODDSMCY
      *
      ** FT fields have been cleared in SREISwft.
      *
     C                   ELSE
      *
     C                   EXSR      SRICChk
      *
     C                   MOVEL     P72           DSFONT
     C     WFound        IFEQ      'Y'
     C                   MOVEL     *BLANKS       ODDBBI6
     C                   MOVEL     FN72L2        ODDBBI1
     C                   MOVEL     FN72L3        ODDBBI2
     C                   MOVEL     FN72L4        ODDBBI3
     C                   MOVEL     FN72L5        ODDBBI4
     C                   MOVEL     FN72L6        ODDBBI5
     C                   ELSE
     C                   MOVEL     FN72L1        ODDBBI1
     C                   MOVEL     FN72L2        ODDBBI2
     C                   MOVEL     FN72L3        ODDBBI3
     C                   MOVEL     FN72L4        ODDBBI4
     C                   MOVEL     FN72L5        ODDBBI5
     C                   MOVEL     FN72L6        ODDBBI6
     C                   ENDIF

     C                   MOVEL     '/REF/'       WCW
     C                   MOVEL     FONT72        WCWLIN
     C                   Z-ADD     30            WCWLEN
     C                   EXSR      SRCWVAL
     C     WCWVAL        IFNE      *BLANK
     C                   MOVEL     WCWVAL        ODDFDLR
     C                   ENDIF
      *
     C                   MOVEL     '/ORIG/'      WCW
     C                   MOVEL     FONT72        WCWLIN
     C                   EXSR      SRFOCmt2
     C     WCWCY         IFNE      *BLANK
     C                   MOVEL     WCWCY         ODDSMCY
     C                   ELSE
     C                   MOVEL     *BLANKS       ODDSMCY
     C                   ENDIF
      *
     C                   MOVEL     WCWAM         WNLAM
     C                   EXSR      SRNull
      *
     C     WNLNUL        IFEQ      'N'
     C                   MOVEL     WCWAM         ODDSMAM
     C                   ELSE
     C                   MOVEL     *BLANKS       ODDSMAM
     C                   ENDIF
      *
     C                   MOVEL     '/RATE/'      WCW
     C                   MOVEL     FONT72        WCWLIN
     C                   EXSR      SRRate
     C                   MOVEL     WCWRT         WNLAM
     C                   EXSR      SRNull
      *
     C     WNLNUL        IFEQ      'Y'
      *
     C                   MOVEL     *BLANKS       WCWRT
      *
     C                   ELSE
      *
      ** Decimal places in FT are stored on 8 digits
      ** => truncated if greater.
      *
     C     WCWDPT        IFGT      8
      *
     C     '.'           SCAN      WCWRT         IN                2 0
      *
      ** Extract Digits + comma.
      *
     C     IN            SUBST(P)  WCWRT:1       W014A            14
     C                   ADD       1             IN
      *
      ** Extract Decimals after comma.
      *
     C     8             SUBST(P)  WCWRT:IN      W008A             8
     C     W014A         CAT(P)    W008A:0       WCWRT
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     WCWRT         IFNE      *BLANKS
     C                   MOVE      WCWRT         ODDRATE
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVEL     'N'           ODDOPIN
     C                   MOVEL     *BLANKS       ODDNDAM
      *
     C     ODDSMCY       IFEQ      ODDNDCY
     C                   MOVEL     *BLANK        ODDNDCY
     C                   ENDIF
      *
     C                   MOVEL     *BLANKS       ODDSNC1
     C                   MOVEL     *BLANKS       ODDSNC2
     C                   MOVEL     *BLANKS       ODDSNC3
     C                   MOVEL     *BLANKS       ODDSNC4
     C                   MOVEL     *BLANKS       ODDSNC5
     C                   MOVEL     *BLANKS       ODDINB1
     C                   MOVEL     *BLANKS       ODDINB2
     C                   MOVEL     *BLANKS       ODDINB3
     C                   MOVEL     *BLANKS       ODDINB4
     C                   MOVEL     *BLANKS       ODDINB5
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNull - Test if Amount is null                              *
      *                                                               *
      *****************************************************************
      *
     C     SRNULL        BEGSR
      *
      ** Initialise working fields.
      *
     C                   MOVEL     'Y'           WNLNUL            1
     C                   MOVEL     '123456'      WNUL              9
     C                   MOVE      '789'         WNUL
      *
     C     WNLAM         IFNE      *BLANK
     C                   MOVEL     *BLANKS       WYA1
     C                   MOVEA     WNLAM         WYA1
      *
     C                   DO        15            IN
      *
     C     WNUL          CHECK     WYA1(IN)                               01
      *
     C     *IN01         IFEQ      '0'
     C                   MOVEL     'N'           WNLNUL
     C                   LEAVE
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Initialise working fields.
      *
     C                   MOVEL     *BLANKS       WNLAM            15
     C                   MOVEL     *BLANKS       WYA1              1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRICChk - Scan for /OCMT/, /ORIG/, /RATE/                    *
      *                                                               *
      *****************************************************************
      *
     C     SRICChk       BEGSR
      *
     C                   MOVEL     *BLANKS       WFound            1
      *
     C     '/RATE/'      SCAN      P72:1         PX                3 0    81
     C     *IN81         IFEQ      *OFF
     C     '/ORIG/'      SCAN      P72:1         PX                       81
     C     *IN81         IFEQ      *OFF
     C     '/OCMT/'      SCAN      P72:1         PX                       81
     C                   ENDIF
     C                   ENDIF
     C*
     C     *IN81         IFEQ      *ON
     C                   MOVE      'Y'           WFound
     C                   ENDIF
     C*
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRate - Retrieve the Rate and the Multiply/Divide indicator *
      *                                                               *
      *****************************************************************
      *
     C     SRRate        BEGSR
      *
      ** Reset work variables.
      *
     C                   MOVEL     *BLANK        WCWRT            14
     C                   Z-ADD     0             WCWDPT            1 0
     C                   Z-ADD     0             WCWDP             2 0
      *
     C     WCW           SCAN      WCWLIN:1      WF                3 0    01
      *
     C     *IN01         IFEQ      *ON
      *
     C                   ADD       6             WF
      *
      ** Move possible 13 chars to work array and work string.
      *
     C     13            SUBST     WCWLIN:WF     WR               13
     C                   MOVEA     WR            WSR
     C                   CLEAR                   WR
      *
      ** If ',' in rate string WR, change to '.'.
      ** Only need to check valid chars till one ',' found.
      *
     C                   Z-ADD     1             WC                3 0
     C                   MOVE      *BLANKS       WT                1
      *
     C     1             DO        13            WC
      *
     C     WSR(WC)       IFEQ      ','
      *
     C                   MOVE      '.'           WSR(WC)
      *
      ** Retrieve the number of decimal position.
      *
     C     WCHK          CHECK     WR1           WF                3 0
     C     WF            IFNE      0
     C     WF            SUB       1             WF
     C     WF            SUB       WC            WCWDP
     C                   ELSE
     C     13            SUB       WC            WCWDP
     C                   ENDIF
      *
      ** Decimal position can be handled only on one 1 digit
      ** => range 0-9  (otherwise, truncated to 9).
      *
     C     WCWDP         IFGT      9
     C                   Z-ADD     9             WCWDPT
     C                   ELSE
     C                   Z-ADD     WCWDP         WCWDPT
     C                   ENDIF
      *
     C                   LEAVE
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   Z-ADD     1             WC
     C                   MOVE      *BLANKS       WT                1
     C                   MOVEA     WSR           WR
      *
      ** Get Amount - up to 13 chars possible.
      *
     C     WC            DOUGT     13
      *
     C                   MOVE      WSR(WC)       WT
     C     WCHK          CHECK     WT            WF                       01
      *
      ** Char not valid must be end of rate.
      *
     C     *IN01         IFEQ      *ON
     C     WC            IFNE      1
     C     WC            SUB       1             WF
     C     WF            SUBST     WR:1          WCWRT
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF
      *
      ** All chars in string ok.
      *
     C     WC            IFEQ      13
     C                   MOVEL     WR            WCWRT
     C                   ENDIF
      *
     C                   ADD       1             WC
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Reset input variables.
      *
     C                   MOVEL     *BLANKS       WCWLIN
     C                   MOVEL     *BLANKS       WCW
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIMsg - Map translated data for incoming messages           *
      *                                                               *
      *****************************************************************
      *
     C     SRIMsg        BEGSR
      *
      ** Set up the detail screen fields from the message.
      *
      ** Sender.
      *
      ** In FONTIS, this field can be translated only by
      ** the sender correspondant (P53).
      *
     C     PNWRK         IFNE      'FONTIS'
      *
     C     PSN           IFNE      *BLANKS
      *
     C                   MOVEL     PSN           DSTRAN
      *
     C     TRCODE        IFNE      *BLANKS
      *
      ** Translate to Nostro and Retail account numbers.
      *
     C                   EXSR      SRTran
      *
     C                   SELECT
      *
      ** If Local and Account Currency Local, then use Retail number.
      *
     C     BJLCCY        WHENEQ    ODDSMCY
     C     WRCYCD        ANDEQ     ODDSMCY
     C     WWACNO        ANDNE     0
     C                   MOVE      *BLANKS       ODDSND1
     C                   MOVE      *BLANKS       ODDSND2
     C                   MOVE      *BLANKS       ODDSND3
     C                   MOVE      *BLANKS       ODDSND4
     C                   MOVEL     WWACNO        ODDSND1
      *
      ** If Currency the same as Settle and Nostro, use Nostro.
      *
     C     WWNCCY        WHENEQ    ODDSMCY
     C     WWNONB        ANDNE     *BLANKS
     C                   MOVE      *BLANKS       ODDSND1
     C                   MOVE      *BLANKS       ODDSND2
     C                   MOVE      *BLANKS       ODDSND3
     C                   MOVE      *BLANKS       ODDSND4
     C     WWNCCY        CAT(P)    WWNONB        ODDSND1
      *
      ** If Currency the same, use GL Account.
      *
     C     WRCYCD        WHENEQ    ODDSMCY
     C                   MOVE      *BLANKS       ODDSND1
     C                   MOVE      *BLANKS       ODDSND2
     C                   MOVE      *BLANKS       ODDSND3
     C                   MOVE      *BLANKS       ODDSND4
     C     BGMBIN        IFNE      'Y'
     C                   MOVE      '   '         TRCODE
     C                   ENDIF
     C                   MOVEL     TRCODE        ODDSND1
      *
      ** Use Customer Number.
      *
     C                   OTHER
     C                   MOVE      *BLANKS       ODDSND1
     C                   MOVE      *BLANKS       ODDSND2
     C                   MOVE      *BLANKS       ODDSND3
     C                   MOVE      *BLANKS       ODDSND4
     C                   MOVEL     WRCNUM        ODDSND1
      *
     C                   ENDSL
      *
     C                   ELSE
      *
     C                   MOVEL     TMLIN2        ODDSND2
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Senders Correspondent.
      *
      **  By default, will translate the Sender field in FONTIS.
      *
     C                   MOVEL     P54           DSTRAN
     C                   MOVEL     TRCODE        WRCDE2
      *
     C     P54           IFEQ      *BLANKS
     C     P55           ANDEQ     *BLANKS                                                    237914
     C     P53           ANDNE     *BLANKS
     C     P54           ORNE      *BLANKS
     C*****WRCNUM        ANDEQ     '501116'                                                   237914
     C     P53           ANDNE     *BLANKS
      *
     C                   MOVEL     P53           DSTRAN
     C                   MOVEL     TRCODE        WRCDE2
      *
     C     TRCODE        IFNE      *BLANKS
     C*****WRCNUM        ANDNE     '501116'                                                   237914
      *
      ** Translate to Nostro and Retail account numbers.
      *
     C                   EXSR      SRTran
      *
     C                   SELECT
      *
      ** If Local and Account Currency Local, then use Retail number.
      *
     C     BJLCCY        WHENEQ    ODDSMCY
     C     WRCYCD        ANDEQ     ODDSMCY
     C     WWACNO        ANDNE     0
     C**********         MOVE      *BLANKS       ODDSND1                                    AR921987
     C**********         MOVE      *BLANKS       ODDSND2                                    AR921987
     C**********         MOVE      *BLANKS       ODDSND3                                    AR921987
     C**********         MOVE      *BLANKS       ODDSND4                                    AR921987
     C**********         MOVEL     WWACNO        ODDSND1                                    AR921987
      *                                                                                     AR921987
      ** Map the Retail Account to Receiver's Correspondent                                 AR921987
      *                                                                                     AR921987
     C                   MOVE      *BLANKS       ODDRCO1                                    AR921987
     C                   MOVEL     WWACNO        ODDRCO1                                    AR921987
      *
      ** If Currency the same as Settle and Nostro, use Nostro.
      *
     C     WWNCCY        WHENEQ    ODDSMCY
     C     WWNONB        ANDNE     *BLANKS
     C**********         MOVE      *BLANKS       ODDSND1                                    AR921987
     C**********         MOVE      *BLANKS       ODDSND2                                    AR921987
     C**********         MOVE      *BLANKS       ODDSND3                                    AR921987
     C**********         MOVE      *BLANKS       ODDSND4                                    AR921987
     C*****WWNCCY        CAT(P)    WWNONB        ODDSND1                                    AR921987
      *                                                                                     AR921987
      ** Map the Nostro to Receiver's Correspondent                                         AR921987
      *                                                                                     AR921987
     C                   MOVE      *BLANKS       ODDRCO1                                    AR921987
     C     WWNCCY        CAT(P)    WWNONB        ODDRCO1                                    AR921987
      *
      ** If Currency the same, use GL Account.
      *
     C     WRCYCD        WHENEQ    ODDSMCY
     C**********         MOVE      *BLANKS       ODDSND1                                    AR921987
     C**********         MOVE      *BLANKS       ODDSND2                                    AR921987
     C**********         MOVE      *BLANKS       ODDSND3                                    AR921987
     C**********         MOVE      *BLANKS       ODDSND4                                    AR921987
     C     BGMBIN        IFNE      'Y'
     C                   MOVE      '   '         TRCODE
     C                   ENDIF
      *                                                                                     AR921987
      ** Map the GL Account to Receiver's Correspondent                                     AR921987
      *                                                                                     AR921987
     C**********         MOVEL     TRCODE        ODDSND1                                    AR921987
     C                   MOVE      *BLANKS       ODDRCO1                                    AR921987
     C                   MOVEL     TRCODE        ODDRCO1                                    AR921987
      *
      ** Use Customer Number.
      *
     C                   OTHER
     C**********         MOVE      *BLANKS       ODDSND1                                    AR921987
     C**********         MOVE      *BLANKS       ODDSND2                                    AR921987
     C**********         MOVE      *BLANKS       ODDSND3                                    AR921987
     C**********         MOVE      *BLANKS       ODDSND4                                    AR921987
     C**********         MOVEL     WRCNUM        ODDSND1                                    AR921987
      *                                                                                     AR921987
      ** Map the Customer Number to Receiver's Correspondent                                AR921987
      *                                                                                     AR921987
     C                   MOVE      *BLANKS       ODDRCO1                                    AR921987
     C                   MOVEL     WRCNUM        ODDRCO1                                    AR921987
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Receiver's Correspondent.
      *
     C                   SELECT
      *
     C     PNWRK         WHENEQ    'YENKSI'
      *
     C     P54           WHENNE    *BLANKS
      *
     C                   MOVEL     P54           DSTRAN
     C                   MOVEL     TRCODE        WRCDE2
     C     TRCODE        IFNE      *BLANKS
     C     WRCNUM        ANDEQ     '501116'
     C*****              MOVE      *BLANKS       ODDRCCO                        CFT014
     C                   MOVE      *BLANKS       ODDRCO1                        CFT014
     C                   ENDIF
      *
     C     TRCODE        IFNE      *BLANKS
     C     WRCNUM        ANDNE     '501116'
      *
      ** Translate to Nostro and Retail account numbers.
      *
     C                   EXSR      SRTran
      *
     C                   SELECT
      *
      ** If Local and Account Currency Local, then use Retail number.
      *
     C     BJLCCY        WHENEQ    ODDSMCY
     C     WRCYCD        ANDEQ     ODDSMCY
     C     WWACNO        ANDNE     0
     C*****              MOVE      *BLANKS       ODDRCCO                        CFT014
     C*****              MOVEL     WWACNO        ODDRCCO                        CFT014
     C                   MOVE      *BLANKS       ODDRCO1                        CFT014
     C                   MOVEL     WWACNO        ODDRCO1                        CFT014
      *
      ** If Currency the same as Settle and Nostro, use Nostro.
      *
     C     WWNCCY        WHENEQ    ODDSMCY
     C     WWNONB        ANDNE     *BLANKS
     C*****              MOVE      *BLANKS       ODDRCCO                        CFT014
     C*****              MOVEL     WWNONB        ODDRCCO                        CFT014
     C                   MOVE      *BLANKS       ODDRCO1                        CFT014
     C**********         MOVEL     WWNONB        ODDRCO1                               CFT014 237914
     C     WWNCCY        CAT(P)    WWNONB        ODDRCO1                                      237914
      *
      ** Use Customer Number.
      *
     C                   OTHER
     C*****              MOVE      *BLANKS       ODDRCCO                        CFT014
     C*****              MOVEL     WRCNUM        ODDRCCO                        CFT014
     C                   MOVE      *BLANKS       ODDRCO1                        CFT014
     C                   MOVEL     WRCNUM        ODDRCO1                        CFT014
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDSL
      *                                                                                       237914
      ** Third Reimbursement                                                                  237914
      *                                                                                       237914
     C     P55           IFNE      *BLANKS                                                    237914
      *                                                                                       237914
     C                   MOVEL     P55           DSTRAN                                       237914
      *                                                                                       237914
     C     TRCODE        IFNE      *BLANKS                                                    237914
      *                                                                                       237914
      ** Translate to Nostro and Retail account numbers.                                      237914
      *                                                                                       237914
     C                   EXSR      SRTran                                                     237914
      *                                                                                       237914
     C                   SELECT                                                               237914
      *                                                                                       237914
      ** If Local and Account Currency Local, then use Retail number.                         237914
      *                                                                                       237914
     C     BJLCCY        WHENEQ    ODDSMCY                                                    237914
     C     WRCYCD        ANDEQ     ODDSMCY                                                    237914
     C     WWACNO        ANDNE     0                                                          237914
     C                   MOVE      *BLANKS       ODDTRIB                                      237914
     C                   MOVEL     WWACNO        ODDTRIB                                      237914
      *                                                                                       237914
      ** If Currency the same as Settle and Nostro, use Nostro.                               237914
      *                                                                                       237914
     C     WWNCCY        WHENEQ    ODDSMCY                                                    237914
     C     WWNONB        ANDNE     *BLANKS                                                    237914
     C                   MOVE      *BLANKS       ODDTRIB                                      237914
     C     WWNCCY        CAT(P)    WWNONB        ODDTRIB                                      237914
      *                                                                                       237914
      *                                                                                       237914
      ** If Currency the same as Settle and IBAN, use IBAN.                                   237914
      *                                                                                       237914
     C     WRCYCD        WHENEQ    ODDSMCY                                                    237914
     C     WWIBAN        ANDNE     *BLANKS                                                    237914
     C                   MOVE      *BLANKS       ODDTRIB                                      237914
     C                   MOVEL(P)  WWIBAN        ODDTRIB                                      237914
      *                                                                                       237914
      ** If Currency the same, use GL Account.                                                237914
      *                                                                                       237914
     C     WRCYCD        WHENEQ    ODDSMCY                                                    237914
     C                   MOVE      *BLANKS       ODDTRIB                                      237914
     C     BGMBIN        IFNE      'Y'                                                        237914
     C                   MOVE      '   '         TRCODE                                       237914
     C                   ENDIF                                                                237914
     C                   MOVEL     TRCODE        ODDTRIB                                      237914
      *                                                                                       237914
      ** Use Customer Number.                                                                 237914
      *                                                                                       237914
     C                   OTHER                                                                237914
     C                   MOVE      *BLANKS       ODDTRIB                                      237914
     C                   MOVEL     WRCNUM        ODDTRIB                                      237914
      *                                                                                       237914
     C                   ENDSL                                                                237914
      *                                                                                       237914
     C                   ELSE                                                                 237914
      *                                                                                       237914
     C                   MOVEL     TMLIN2        ODDTRIB                                      237914
      *                                                                                       237914
     C                   ENDIF                                                                237914
      *                                                                                       237914
     C                   ENDIF                                                                237914
      *
      ** Account with Institution.
      *
      ** Can't be translated if FONTIS message.
      *
     C     PNWRK         IFNE      'FONTIS'
      *
     C     P57           IFNE      *BLANKS
      *
     C                   MOVEL     P57           DSTRAN
      *
      ** Translate to Nostro and Retail account numbers.
      *
     C     TRCODE        IFNE      *BLANKS
      *
     C                   EXSR      SRTran
      *
     C                   SELECT
      *
      ** If Local and Account Currency Local, then use Retail number.
      *
     C     BJLCCY        WHENEQ    ODDSMCY
     C     WRCYCD        ANDEQ     ODDSMCY
     C     WWACNO        ANDNE     0
     C                   MOVE      *BLANKS       ODDACBK
     C                   MOVEL     WWACNO        ODDACBK
      *
      ** If Currency the same as Settle and Nostro, use Nostro.
      *
     C     WWNCCY        WHENEQ    ODDSMCY
     C     WWNONB        ANDNE     *BLANKS
     C                   MOVE      *BLANKS       ODDACBK
     C                   MOVEL     WWNONB        ODDACBK
      *
      ** If Currency the same, use GL Account.
      *
     C     WRCYCD        WHENEQ    ODDSMCY
     C                   MOVE      *BLANKS       ODDACBK
     C     WRCNUM        CAT       WRCDSQ        ODDACBK
     C     BGMBIN        IFEQ      'Y'
     C                   MOVE      WRBRCD        ODDACBB
     C                   ENDIF
      *
      ** Use Customer Number.
      *
     C                   OTHER
     C                   MOVE      *BLANKS       ODDACBK
     C                   MOVEL     WRCNUM        ODDACBK
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Beneficiary Institution/ Beneficiary Customer.
      *
     C     P58           IFNE      *BLANKS
      *
     C                   MOVEL     P58           DSTRAN
      *
     C     TRCODE        IFNE      *BLANKS
      *
      ** Translate to Nostro and Retail account numbers.
      *
     C                   EXSR      SRTran
      *
     C                   SELECT
      *
      ** If Local and Account Currency Local, then use Retail number.
      *
     C     BJLCCY        WHENEQ    ODDSMCY
     C     WRCYCD        ANDEQ     ODDSMCY
     C     WWACNO        ANDNE     0
     C                   MOVE      *BLANKS       ODDBNC1
     C                   MOVEL     WWACNO        ODDBNC1
     C                   MOVEL     *BLANKS       ODDBNC2
     C                   MOVEL     *BLANKS       ODDBNC3
     C                   MOVEL     *BLANKS       ODDBNC4
     C                   MOVEL     *BLANKS       ODDBNC5
      *
      ** If Currency the same, use GL Account.
      *
     C     WRCYCD        WHENEQ    ODDSMCY
     C                   MOVE      *BLANKS       ODDBNC1
     C     BGMBIN        IFNE      'Y'
     C                   MOVEL     *BLANKS       WRBRCD
     C                   ENDIF
     C     WRCNUM        CAT       WRCSB         ODDBNC1
     C                   MOVEL     *BLANKS       ODDBNC2
     C                   MOVEL     *BLANKS       ODDBNC3
     C                   MOVEL     *BLANKS       ODDBNC4
     C                   MOVEL     *BLANKS       ODDBNC5
      *
      ** Use Customer Number.
      *
     C                   OTHER
     C                   MOVE      *BLANKS       ODDBNC1
     C                   MOVEL     WRCNUM        ODDBNC1
     C                   MOVEL     *BLANKS       ODDBNC2
     C                   MOVEL     *BLANKS       ODDBNC3
     C                   MOVEL     *BLANKS       ODDBNC4
     C                   MOVEL     *BLANKS       ODDBNC5
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     P59           IFNE      *BLANKS
      *
     C                   MOVEL     P59           DSTRAN
      *
      ** Translate to Nostro and Retail account numbers.
      *
     C     TRCODE        IFNE      *BLANKS
      *
     C                   EXSR      SRTran
      *
     C                   SELECT
      *
      ** If Local and Account Currency Local, then use Retail number.
      *
     C     BJLCCY        WHENEQ    ODDSMCY
     C     WRCYCD        ANDEQ     ODDSMCY
     C     WWACNO        ANDNE     0
     C                   MOVE      *BLANKS       ODDBNC1
     C                   MOVEL     WWACNO        ODDBNC1
     C                   MOVEL     *BLANKS       ODDBNC2
     C                   MOVEL     *BLANKS       ODDBNC3
     C                   MOVEL     *BLANKS       ODDBNC4
     C                   MOVEL     *BLANKS       ODDBNC5
      *
      ** If Currency the same, use GL Account.
      *
     C     WRCYCD        WHENEQ    ODDSMCY
     C                   MOVE      *BLANKS       ODDBNC1
     C     BGMBIN        IFNE      'Y'
     C                   MOVEL     *BLANKS       WRBRCD
     C                   ENDIF
     C     WRCNUM        CAT       WRCSB         ODDBNC1
     C                   MOVEL     *BLANKS       ODDBNC2
     C                   MOVEL     *BLANKS       ODDBNC3
     C                   MOVEL     *BLANKS       ODDBNC4
     C                   MOVEL     *BLANKS       ODDBNC5
      *
      ** Use Customer Number.
      *
     C                   OTHER
     C                   MOVE      *BLANKS       ODDBNC1
     C                   MOVEL     WRCNUM        ODDBNC1
     C                   MOVEL     *BLANKS       ODDBNC2
     C                   MOVEL     *BLANKS       ODDBNC3
     C                   MOVEL     *BLANKS       ODDBNC4
     C                   MOVEL     *BLANKS       ODDBNC5
      *
     C                   ENDSL
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTran - Translate to Retail and Nostro Code                 *
      *                                                               *
      *****************************************************************
      *
     C     SRTran        BEGSR
      *
     C     *LIKE         DEFINE    ACNO          WWACNO
     C     *LIKE         DEFINE    A7CYCD        WWNCCY
     C     *LIKE         DEFINE    A7NONB        WWNONB
     C     *LIKE         DEFINE    IBAN          WWIBAN                                       237914
      *
      ** Clear Retail number and Nostro Code.
      *
     C                   Z-ADD     *ZERO         WWACNO
     C                   MOVEL     *BLANKS       WWNCCY
     C                   MOVEL     *BLANKS       WWNONB
      *
      ** If TRCODE has no Currency, exit.
      *
     C                   MOVE      TRCODE        WRCDE2
     C     WRCYCD        IFEQ      *BLANKS
     C                   GOTO      ETran
     C                   ENDIF
      *
      ** Find Account details.
      *
     C                   MOVEL     TRCODE        WACKYDS
     C     KAccnt        CHAIN     ACCNTABF                           01
      *
     C     *IN01         IFEQ      *OFF
     C     RECI          ANDEQ     'D'
     C     ATYP          ANDEQ     'R'
     C                   Z-ADD     ACNO          WWACNO
     C                   ENDIF
      *                                                                                       237914
      ** IBAN                                                                                 237914
      *                                                                                       237914
     C     *IN01         IFEQ      *OFF                                                       237914
     C     IBAN          ANDNE     *BLANKS                                                    237914
     C                   MOVEL(P)  IBAN          WWIBAN                                       237914
     C                   ENDIF                                                                237914
      *
      ** Move numeric fields to parameter fields.
      *
     C                   MOVEL     CNUM          PCUST
     C                   MOVEL     ACOD          PACCD
     C                   MOVEL     ACSQ          PACSN
      *
      ** Find Nostro details.
      *
     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCUST
     C                   PARM      CCY           PCYCD             3
     C**********         PARM                    PACCD             4                          CGL029
     C                   PARM                    PACCD                                        CGL029
     C                   PARM                    PACSN             2
     C                   PARM      *BLANKS       PNONB             2
     C                   PARM      BRCA          PBRCD             3
     C                   PARM      *BLANKS       PCSSN            10
     C                   PARM      *BLANKS       PPNOI             1
     C     SDNOST        PARM      *BLANKS       DSFDY
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVEL     A7CYCD        WWNCCY
     C                   MOVEL     A7NONB        WWNONB
     C                   ENDIF
      *
     C     ETran         ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMsgNxt - Check if there are more electronic messages to    *
      *             be processed                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRMsgNxt      BEGSR
      *
      ** All electronic messages selected are held on the file FTINMGPD
      ** for reservation purposes.  This file must be checked to see if
      ** there are any more outstanding for the current job.
      *
     C                   CALL      'ME1080'                             0101
     C                   PARM      '*NEXT  '     PACT
     C     PHMSGR        PARM      *ZEROS        PMSGR
     C     PHPART        PARM      *ZEROS        PKPRT
     C     PHMOR         PARM      *BLANKS       PMOR
     C     PHMIR         PARM      *BLANKS       PMIR
     C                   PARM      *BLANKS       PRTN
      *
      ** If call to program resulted in an error, then end program.
      *
     C     PRTN          IFEQ      '*ERROR*'
     C     *IN01         OREQ      *ON
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'ME1080'      DBFILE
     C                   Z-ADD     029           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** MIN0105 - Reserved message found.
      *
      ** If there is an electronic message for the current job, then
      ** prepare input fields for processing.
      *
     C     PRTN          IFEQ      'MIN0105'
     C                   MOVEL     'Y'           WEMSG
     C                   MOVEL     'I'           DDACTN
     C                   MOVEL     *BLANKS       DDPREF
     C                   MOVEL     *BLANKS       DDBRCA
     C                   MOVEL     PMIR          DDSWTN
     C                   MOVEL     *BLANKS       DDSEQNO
     C                   GOTO      EMsgNxt
     C                   ENDIF
      *
      ** MIN0106 - No reserved messages to process.
      *
      ** If there is no electronic message for the current job, then
      ** return to Initial screen.
      *
     C     PRTN          IFEQ      'MIN0106'
     C                   MOVEL     'N'           WEMSG
     C                   MOVEL     *BLANKS       DDACTN
     C                   MOVEL     *BLANKS       DDPREF
     C                   MOVEL     *BLANKS       DDBRCA
     C                   MOVEL     *BLANKS       DDSWTN
     C                   MOVEL     *BLANKS       DDSEQNO
     C                   MOVEL     'MIN0106'     PErrMs
     C                   EXSR      SRSndM
     C                   ENDIF
      *
     C     EMsgNxt       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMsgEnd - Remove all electronic messages reserved           *
      *             for the job                                       *
      *                                                               *
      *****************************************************************
      *
     C     SRMsgEnd      BEGSR
      *
      ** All electronic messages selected are held on the file FTINMGPD
      ** for reservation purposes.  This file must be cleared of all
      ** electronic messages that were selected for the current job.
      *
     C                   CALL      'ME1070'                             0101
     C                   PARM      '*END   '     PACT
     C                   PARM      *ZEROS        PMSGR
     C                   PARM      *ZEROS        PKPRT
     C                   PARM      *BLANKS       PMOR
     C                   PARM      *BLANKS       PMIR
     C                   PARM      *BLANKS       PRTN
      *
      ** If call to program resulted in an error, then end program.
      *
     C     PRTN          IFEQ      '*ERROR*'
     C     *IN01         OREQ      *ON
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'ME1070'      DBFILE
     C                   Z-ADD     030           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** If all reserved records were successfully cleared, then set the
      ** Electronic Message Processing flag and commit the file update.
      *
      ** MIN0111 - Reservation Processing Cancelled For Job.
      *
     C     PRTN          IFEQ      'MIN0111'
     C                   MOVEL     ' '           WEMSG
      **                                                                                      CSC022
      ** Execute commit if SAR CSC022 is not enrolled or                                      CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndM - Send error message to screen                        *
      *                                                               *
      *****************************************************************
      *
     C     SRSndM        BEGSR
      *
      ** If single-branching, user does not have the authority to
      ** Browse.
      *
     C     PErrMs        IFEQ      'FTA0114'
     C                   MOVE      'N'           OKACTN
     C                   ENDIF
      *
      ** Invalid Payment Reference.
      *
     C     PErrMs        IFEQ      'FTA0108'
     C                   MOVE      'N'           OKPREF
     C                   ENDIF
      *
      ** Add error message to array passed to screen.
      *
     C                   Z-ADD     1             Ex                3 0
     C     *BLANK        LOOKUP    FldNameArr(Ex)                         99
     C                   MOVEL     '*ANY'        FldNameArr(Ex)
     C                   MOVEL     PErrMs        MsgIdArr(Ex)
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREndP - Set program to end                                  *
      *                                                               *
      *****************************************************************
      *
     C     SREndP        BEGSR
      *
      * ONLY reduce PREF sequence number if it was incremented.                               209067
     C                   IF        FirstTime <> 'Y'                                           209067
      * Reduce Sequence number in DTAARA as number is not being used                          204152
     C     *LOCK         IN        WINPAY                                                     204152
     C                   IF        CFT151 = 'N'                                               CFT151
      *                                                                                       209067
      * Check to see if another pref has been generated by another function                   209067
      *                                                                                       209067
     C                   z-add     WWINSQ        svnum             4 0                        209067
     C                   eval      svnum = svnum + 1                                          209067
     C**********         if        svnum = WINSQ                                      209067 BUG4776
     C*****SVNUM         IFLE      WINSQ                                              BUG4776 260326
     C                   if        svnum = WINSQ                                              260326
      * No new reference has been generated - so reduce sequence number on data area          209067
     C**********         SUB       1             WINSQ                                204152 BUG4776
     C**********         EVAL      WINSQ = WWINSQ                                     BUG4776 260326
     C                   SUB       1             WINSQ                                        260326
     C**********         else                                                         209067 BUG4776
     C                   else                                                                 260326
      * if another number has been generated, the current payment reference                   209067
     C                   endif                                                                209067
     C                   OUT       WINPAY                                                     204152
     C                   else                                                                 CFT151
     C                   MOVE      WWINSQT       svalph            4                          CFT151
     C                   CALL      'FT000328'                                                 CFT151
     C                   PARM                    PRTCD                                        CFT151
     C                   PARM      'IN'          W@OTIN            2                          CFT151
     C                   PARM      'A'           WCALC                                        CFT151
     C                   PARM      'N'           WUPD              1                          CFT151
     C                   PARM                    svalph                                       CFT151
     C                   PARM                    WNEWSQ                                       CFT151
     C                   if        WNEWSQ = WINPAY                                            CFT151
     C                   CALL      'FT000328'                                                 CFT151
     C                   PARM                    PRTCD                                        CFT151
     C                   PARM      'IN'          W@OTIN            2                          CFT151
     C                   PARM      'S'           WCALC                                        CFT151
     C                   PARM      'Y'           WUPD                                         CFT151
     C                   PARM                    svalph                                       CFT151
     C                   PARM                    WNEWSQ                                       CFT151
     C                   ENDIF                                                                CFT151
     C                   endif                                                                CFT151
     C                   ENDIF                                                                209067
      *                                                                                       204152
      ** Issue rollback to clear any possible updates in lower
      ** level programs.
      *
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
      *                                                                                       261468
      ** Call CL program to deallocate this reference to a dataarea                           261468
      *                                                                                       261468
     C                   EVAL      C#RTCD = *Blanks                                           261468
     C                   EVAL      @MODLE = 'FT'                                              261468
     C                   EVAL      @TREF  = *Blanks                                           261468
     C                   EVAL      @RTINF = *Blanks                                           261468
      *                                                                                       261468
     C                   CALL      'AOC8000'                                                  261468
     C                   PARM                    C#RTCD            7                          261468
     C                   PARM                    @MODLE            2                          261468
     C                   PARM                    @TREF            15                          261468
     C                   PARM                    @RTINF           80                          261468
      *
      ** Release all electronic messages that are reserved for the job
      ** if Incoming Payments Maintenance has been called from
      ** Messages to be Processed thru Funds Transfer option or reserved
      ** electronic messages are present.
      *
     C     PParmActn     IFEQ      'I'
     C     PParmLevel    ANDEQ     '1'
     C     PParmLink     ANDEQ     'Y'
     C     WEMSG         OREQ      'Y'
     C                   EXSR      SRMsgEnd
     C                   ENDIF
      *
      ** Incoming Payments Maintenance has been called by linked
      ** maintenance/enquiry.
      *
     C     PParmLink     IFEQ      'Y'
     C                   MOVEL     '1'           PParmRtcd
     C                   ENDIF
      *
      ** Terminate the program.
      *
     C                   MOVEL     'T'           WScrn
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetErr - Reset error fields                              *
      *                                                               *
      *****************************************************************
      *
     C     SRResetErr    BEGSR
      *
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIDArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   IDx
      *
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   CLEAR                   WIDx
      *
      ** Initialise screen fields error indicators.
      *
     C                   MOVE      *ALL'Y'       FTEIPY1
     C                   MOVE      *ALL'Y'       FTEIPY2
     C                   MOVE      *ALL'Y'       FTEIPY3
     C                   MOVE      *ALL'Y'       FTEIPY4                        CFT014
     C                   MOVE      *ALL'Y'       FTEIPY5                        CFT014
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   MOVE      *ALL'Y'       FTEIPY7                                      CSW209
     C                   MOVE      *ALL'Y'       FTEIPY8                                      CSW209
     C                   ENDIF                                                                CSW209
      *
      ** Initialise SWIFT Reference and Sequence No. error
      ** indicators.
      *
     C                   MOVE      'Y'           OKSWTN
     C                   MOVE      'Y'           OKSEQNO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInScn - Initialise screen formats                          *
      *                                                               *
      *****************************************************************
      *
     C     SRInScn       BEGSR
      *
      ** Blank out Incoming Payment Status, as well as, Detail
      ** fields on Level 1 screen.
      *
     C                   MOVEL     *BLANKS       PStatus
     C                   MOVEL     *BLANKS       NwDetailScrn
     C                   MOVEL     *BLANKS       NwIP1AScnFmt                   CFT014
      *
      ** Blank out Level 2 screen fields.
      *
     C                   MOVEL     *BLANKS       NwIP2ScnFmt
     C                   MOVEL     *BLANKS       NwIP3ScnFmt
     C                   MOVEL     *BLANKS       NwIP4ScnFmt
     C                   MOVEL     *BLANKS       NwIP4AScnFmt                   CFT014
     C                   MOVEL     *BLANKS       NwIP5ScnFmt                    CFT014
     C                   MOVEL     *BLANKS       NwIP6ScnFmt                    CFT014
     C                   MOVEL     *BLANKS       NwIP7ScnFmt                                  CSW209
     C                   MOVEL     *BLANKS       NwIP8ScnFmt                                  CSW209
     C                   MOVEL     *BLANKS       NwIP6AScnFmt                                 CER030
      *
      ** Set up default values on Level 1 screen.
      *
     C                   MOVEL     'IN'          PPYTP
     C                   MOVEL     'N'           DDSWPC
     C**********         MOVEL     'D'           DDADDC                                     MD036089
                                                                                CFT009
     C                   IF        CFT009 = 'N'                                 CFT009
     C                   MOVEL     WRUNDAY       DDSLDT
     C                   ENDIF                                                  CFT009
      *
      ** Save Incoming Payments Lvl 1 screen details.
      *
     C                   MOVEL     NwIP1ScnFmt   CrIP1ScnFmt
     C                   MOVEL     NwIP1AScnFmt  CrIP1AScnFmt                   CFT014
     C                   MOVEL     NwIP2ScnFmt   CrIP2ScnFmt
     C                   MOVEL     NwIP3ScnFmt   CrIP3ScnFmt
     C                   MOVEL     NwIP4ScnFmt   CrIP4ScnFmt
     C                   MOVEL     NwIP4AScnFmt  CrIP4AScnFmt                   CFT014
     C                   MOVEL     NwIP5ScnFmt   CrIP5ScnFmt                    CFT014
     C                   MOVEL     NwIP6ScnFmt   CrIP6ScnFmt                    CFT014
     C                   MOVEL     NwIP6AScnFmt  CrIP6AScnFmt                                 CER030
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   MOVEL     NwIP7ScnFmt   CrIP7ScnFmt                                  CSW209
     C                   MOVEL     NwIP8ScnFmt   CrIP8ScnFmt                                  CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       187056
      ** Initialise work fields for 'Charges to the Debit of a/c'.                            187056
      *                                                                                       187056
     C                   EVAL      PPrvCDRO = *BLANKS                                         187056
     C                   EVAL      PPrvCDBR = *BLANKS                                         187056
     C                   EVAL      PPrvCDRT = *BLANKS                                         187056
      *
     C                   ENDSR
      *
      *****************************************************************
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
     C     S01508        IFEQ      'Y'                                                        187056
     C     S01506        ANDNE     'Y'                                                        187056
      *                                                                                       187056
      ** Get original "Charges to the Debit of" Customer.                                     187056
      *                                                                                       187056
     C                   CLEAR                   P0DTA                                        187056
      *                                                                                       187056
     C     PPrvCDRT      IFNE      *BLANKS                                                    187056
     C                   MOVE      PPrvCDRT      WIPT1                                        187056
     C     PPrvCDRO      CAT(P)    PPrvCDBR      WIPTY1                                       187056
     C                   MOVE      BJCYCD        WICCY                                        187056
      *                                                                                       187056
     C                   CALL      'FT0035'                             9090                  187056
     C                   PARM      *BLANKS       PRTCD                                        187056
     C                   PARM                    P0DTA                                        187056
     C                   PARM                    P0MSG           256                          187056
      *                                                                                       187056
     C     *IN90         IFEQ      *ON                                                        187056
     C     PRTCD         ORNE      *BLANKS                                                    187056
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
     C     IPCDRT        IFNE      *BLANKS                                                    187056
     C                   MOVE      IPCDRT        WIPT1                                        187056
     C     DDCDRO        CAT(P)    DDCDBR        WIPTY1                                       187056
     C                   MOVE      BJCYCD        WICCY                                        187056
      *                                                                                       187056
     C                   CALL      'FT0035'                             9090                  187056
     C                   PARM      *BLANKS       PRTCD                                        187056
     C                   PARM                    P0DTA                                        187056
     C                   PARM                    P0MSG                                        187056
      *                                                                                       187056
     C     *IN90         IFEQ      *ON                                                        187056
     C     PRTCD         ORNE      *BLANKS                                                    187056
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
     C     DDCDRO        IFNE      PPrvCDRO                                                   187056
     C     DDCDBR        ORNE      PPrvCDBR                                                   187056
     C     W0FCUS        ORNE      W0SCUS                                                     187056
     C                   EVAL      PReCalc = 'Y'                                              187056
     C                   EXSR      SrCDefault                                                 187056
     C                   EVAL      PPrvCDRO = DDCDRO                                          187056
     C                   EVAL      PPRVCDBR = DDCDBR                                          187056
     C                   EVAL      PPrvCDRT = IPCDRT                                          187056
     C                   EVAL      PReCalc = 'N'                                              187056
     C                   EVAL      WReDspChg = 'Y'                                            187056
     C                   ENDIF                                                                187056
      *                                                                                       187056
     C                   ENDSR                                                                187056
      *                                                                                       187056
      *****************************************************************                       187056
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * SRUPDAT - Update the extension file                           *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
      *                                                                                       CER001
     C     SRUPDAT       BEGSR                                                                CER001
      *                                                                                       CER001
     C                   CALLB     'FTIPAY2UP'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM      *BLANK        @RTCD                                        CER001
     C                   PARM                    WFIND                                        CER001
     C                   PARM                    NwDlFilFmt                                   CER001
     C                   PARM                    CrDlFilFmt                                   CER001
      *                                                                                       CER001
      ** If there were any errors in the update functions, rollback any                       CER001
      ** updates and end this pgm                                                             CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *Blank and                                        CER001
     C                             @RTCD <> '*RECUPD' and                                     CER001
     C                             @RTCD <> '*RECLCK'                                         CER001
     C                   ROLBK                                                                CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ELSE                                                                 CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** If update not done due to record has been updated by another                         CER001
      ** workstation send message to screen.                                                  CER001
      *                                                                                       CER001
     C                   IF        @RTCD = '*RECUPD'                                          CER001
     C                   EVAL      FldNameArr(1) = '*ANY'                                     CER001
     C                   EVAL      #MsgID = 'XXX9000'                                         CER001
     C                   EVAL      MsgIdArr(1) = #MsgID                                       CER001
     C                   EVAL      WWERR = ' '                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** If update not done due to record being locked by another                             CER001
      ** workstation send message to screen.                                                  CER001
      *                                                                                       CER001
     C                   IF        @RTCD = '*RECLCK'                                          CER001
     C                   EVAL      FldNameArr(1) = '*ANY'                                     CER001
     C                   EVAL      #MsgID = 'ULX0208'                                         CER001
     C                   EVAL      MsgIdArr(1) = #MsgID                                       CER001
     C                   EVAL      WWERR = ' '                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT
     C/COPY WNCPYSRC,FTIPAYSC36
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
      ** Receive entry parameters.
      *
     C     *ENTRY        PLIST
      *
      ** Action Code
     C                   PARM                    PParmActn         1
      *
      ** Payment Reference
     C                   PARM                    PParmPRef        15
      *
      ** Return Code
     C                   PARM                    PParmRtcd         1
      *
      ** Linked Maintenance
     C                   PARM                    PParmLink         1
      *
      ** Screen Level
     C                   PARM                    PParmLevel        1
      *
      ** Access Bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error.
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access General Ledger ICD details.
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDGELR        PARM      SDGELR        DSSDY
      *
      ** Database error.
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Midas Modules details.
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Database error.
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   Z-ADD     003           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Funds Transfer ICD details.
      *
     C                   CALL      'AOFTFRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDFTFR        PARM      SDFTFR        DSFDY
      *
      ** Database error.
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDFTFRPD'    DBFILE
     C                   Z-ADD     004           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Retail ICD details if Retail module is
      ** installed.
      *
     C     BGRTBN        IFEQ      'Y'
      *
     C                   CALLB     'AORETLR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDRETL        PARM      SDRETL        DSFDY
      *
      ** Database error.
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDRETLPD'    DBFILE
     C                   Z-ADD     005           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Access SAR file to determine if S01494
      ** (BLI FT Enhancements Feature) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01494'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01494'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     006           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01494            1
     C                   ELSE
     C                   MOVEL     'N'           S01494
     C                   ENDIF
      *
      ** Access SAR file to determine if S01499 (BLI VAT Processing)
      ** is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01499'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01499'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     007           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01499            1
     C                   ELSE
     C                   MOVEL     'N'           S01499
     C                   ENDIF
      *
      ** Access SAR file to determine if S01506 (BLI Payment Charges
      ** Enhancements) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01506'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01506'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     008           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01506            1
     C                   ELSE
     C                   MOVEL     'N'           S01506
     C                   ENDIF
      *
      ** Access SAR file to determine if S01508 (BLI Extended Payment
      ** Charges) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01508'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'S01508'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     009           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01508            1
     C                   ELSE
     C                   MOVEL     'N'           S01508
     C                   ENDIF
      *
      ** Access SAR file to determine if CEU006 (EMU FT Settlement
      ** Currency Conversion) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CEU006'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CEU006'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     010           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CEU006            1
     C                   ELSE
     C                   MOVEL     'N'           CEU006
     C                   ENDIF
      *
      ** Access SAR file to determine if CFT003 (Batch Authorisation)
      ** is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CFT003'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CFT003'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     011           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CFT003            1
     C                   ELSE
     C                   MOVEL     'N'           CFT003
     C                   ENDIF
      *
      ** Access SAR file to determine if CFT002 (Straight
      ** Through Processing Phase 1) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CFT002'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CFT002'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     012           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CFT002            1
     C                   ELSE
     C                   MOVEL     'N'           CFT002
     C                   ENDIF
      *                                                                         CFT014
      ** Straight Through Processing - Phase 2                                  CFT014
      *                                                                         CFT014
     C                   CALLB     'AOSARDR0'                                   CFT014
     C                   PARM      *BLANKS       PRTCD                          CFT014
     C                   PARM      '*VERIFY'     POPTN                          CFT014
     C                   PARM      'CFT014'      PSARD                          CFT014
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT014
     C     PRTCD         IFNE      *BLANKS                                      CFT014
     C     PRTCD         ANDNE     '*NRF   '                                    CFT014
     C                   MOVEL     'CFT014'      DBKEY                          CFT014
     C                   MOVEL     'SCSARDPD'    DBFILE                         CFT014
     C                   Z-ADD     33            DBASE                          CFT014
     C                   EXSR      *PSSR                                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C     PRTCD         IFEQ      *BLANK                                       CFT014
     C                   MOVEL     'Y'           CFT014            1            CFT014
     C                   ELSE                                                   CFT014
     C                   MOVEL     'N'           CFT014                         CFT014
     C                   ENDIF                                                  CFT014
      *
      ** Access SAR file to determine if CFT004 (IBAN
      ** numbers) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CFT004'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CFT004'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     013           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CFT004            1
     C                   ELSE
     C                   MOVEL     'N'           CFT004
     C                   ENDIF
      *
      ** Access SAR file to determine if CFT007 (BIC database
      ** plus) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CFT007'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CFT007'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     014           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CFT007            1
     C                   ELSE
     C                   MOVEL     'N'           CFT007
     C                   ENDIF
      *                                                                                     MD022652
      ** Access SAR file to determine if CFT050 (SWIFTRef Directories                       MD022652
      ** upload) is installed.                                                              MD022652
      *                                                                                     MD022652
     C                   CALLB     'AOSARDR0'                                               MD022652
     C                   PARM      *BLANKS       PRTCD                                      MD022652
     C                   PARM      '*VERIFY'     POPTN                                      MD022652
     C                   PARM      'CFT050'      PSARD                                      MD022652
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD022652
      *                                                                                     MD022652
      ** CFT007 process will take place when CFT050 is switched on                          MD022652
      *                                                                                     MD022652
     C                   IF        PRTCD = *BLANKS                                          MD022652
     C                   EVAL      CFT007 = 'Y'                                             MD022652
     C                   ENDIF                                                              MD022652
      *
      ** Access SAR file to determine if CGL009 (Electronic Banking
      ** Interface IATs and TPPs) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CGL009'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'CGL009'      DBKEY
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     031           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CGL009            1
     C                   ELSE
     C                   MOVEL     'N'           CGL009
     C                   ENDIF
     C/COPY WNCPYSRC,FTIPAYSC37
      *                                                                         CFT009
      ** Access SAR file to determine if CFT009 is installed                    CFT009
      *                                                                         CFT009
     C                   CALLB     'AOSARDR0'                                   CFT009
     C                   PARM      *BLANKS       PRTCD                          CFT009
     C                   PARM      '*VERIFY'     POPTN                          CFT009
     C                   PARM      'CFT009'      PSARD                          CFT009
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT009
      *                                                                         CFT009
      ** An NRF (No Record Found) return code is valid.                         CFT009
      ** Issue database error only for error return codes.                      CFT009
      *                                                                         CFT009
     C     PRTCD         IFNE      *BLANKS                                      CFT009
     C     PRTCD         ANDNE     '*NRF   '                                    CFT009
     C                   MOVEL     'CFT009'      DBKEY                          CFT009
     C                   MOVEL     'SCSARDPD'    DBFILE                         CFT009
     C                   Z-ADD     036           DBASE                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
     C     PRTCD         IFEQ      *BLANK                                       CFT009
     C                   MOVEL     'Y'           CFT009            1            CFT009
     C                   ELSE                                                   CFT009
     C                   MOVEL     'N'           CFT009                         CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
      ** Access SAR file to determine if CFT010 is installed                    CFT009
      *                                                                         CFT009
     C                   CALLB     'AOSARDR0'                                   CFT009
     C                   PARM      *BLANKS       PRTCD                          CFT009
     C                   PARM      '*VERIFY'     POPTN                          CFT009
     C                   PARM      'CFT010'      PSARD                          CFT009
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT009
      *                                                                         CFT009
      ** An NRF (No Record Found) return code is valid.                         CFT009
      ** Issue database error only for error return codes.                      CFT009
      *                                                                         CFT009
     C     PRTCD         IFNE      *BLANKS                                      CFT009
     C     PRTCD         ANDNE     '*NRF   '                                    CFT009
     C                   MOVEL     'CFT010'      DBKEY                          CFT009
     C                   MOVEL     'SCSARDPD'    DBFILE                         CFT009
     C                   Z-ADD     037           DBASE                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
     C     PRTCD         IFEQ      *BLANK                                       CFT009
     C                   MOVEL     'Y'           CFT010            1            CFT009
     C                   ELSE                                                   CFT009
     C                   MOVEL     'N'           CFT010                         CFT009
     C                   ENDIF                                                  CFT009
      *                                                                                       CFT151
      ** Access SAR file to determine if CFT151 is installed                                  CFT151
      *                                                                                       CFT151
     C                   CALLB     'AOSARDR0'                                                 CFT151
     C                   PARM      *BLANKS       PRTCD                                        CFT151
     C                   PARM      '*VERIFY'     POPTN                                        CFT151
     C                   PARM      'CFT151'      PSARD                                        CFT151
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT151
      *                                                                                       CFT151
      ** An NRF (No Record Found) return code is valid.                                       CFT151
      ** Issue database error only for error return codes.                                    CFT151
      *                                                                                       CFT151
     C     PRTCD         IFNE      *BLANKS                                                    CFT151
     C     PRTCD         ANDNE     '*NRF   '                                                  CFT151
     C                   MOVEL     'CFT151'      DBKEY                                        CFT151
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CFT151
     C                   Z-ADD     037           DBASE                                        CFT151
     C                   EXSR      *PSSR                                                      CFT151
     C                   ENDIF                                                                CFT151
      *                                                                                       CFT151
     C     PRTCD         IFEQ      *BLANK                                                     CFT151
     C                   MOVEL     'Y'           CFT151            1                          CFT151
     C                   ELSE                                                                 CFT151
     C                   MOVEL     'N'           CFT151                                       CFT151
     C                   ENDIF                                                                CFT151
                                                                                              CSC011
     C                   EVAL      PPROCDTE = BJRDNB                                          CSC011
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
     C                   EVAL      CSC011 = 'Y'                                               CSC011
                                                                                              CSC011
      ** Get support system prefix and current system prefix                                  CSC011
                                                                                              CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
                                                                                              CSC011
      ** Use processing date defined in SC24X7 dataarea when support system is active         CSC011
                                                                                              CSC011
     C                   IF        LIBR = S1SUPP                                              CSC011
     C                   EVAL      PPROCDTE = WPRDTE                                          CSC011
     C                   ENDIF                                                                CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       CSW209
      ** Check if SWIFT 2009 feature is ON                                                    CSW209
      *                                                                                       CSW209
     C                   CALL      'SWIF2009'                                                 CSW209
     C                   PARM      *BLANKS       PRTCD                                        CSW209
      *                                                                                       CSW209
     C                   IF        PRTCD = 'CSW2009'                                          CSW209
     C                   EVAL      CSW209 = 'Y'                                               CSW209
     C                   ELSE                                                                 CSW209
     C                   EVAL      CSW209 = 'N'                                               CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
                                                                                              CSD015
      ** Check if Compliance Watch Enhancement (CSD015) is installed                          CSD015
                                                                                              CSD015
     C                   EVAL      CSD015 = 'N'                                               CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *Blank        PRtCd                                        CSD015
     C                   PARM      '*VERIFY'     POptn                                        CSD015
     C                   PARM      'CSD015'      PSard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (PRtCd <> *BLANKS) AND                                     CSD015
     C                             (PRtCd <> '*NRF   ')                                       CSD015
     C                   EVAL      DBKey = 'CSD015'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 39                                                 CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PRtCd = *Blank                                             CSD015
     C                   EVAL      CSD015 = 'Y'                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      **  Access SAR details to see if CCF001 is switched on.                                 CSD015
                                                                                              CSD015
     C                   EVAL      CCF001 = 'N'                                               CSD015
     C                   CALL      'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       PrtCd                                        CSD015
     C                   PARM      '*VERIFY'     POptn                                        CSD015
     C                   PARM      'CCF001'      @SARD                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        PrtCd <> *Blanks  AND                                      CSD015
     C                             PrtCd <> '*NRF'                                            CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = 'CCF001'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 40                                                 CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        PrtCd = *BLANKS                                            CSD015
     C                   EVAL      CCF001 = 'Y'                                               CSD015
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
     C                   Eval      DBPgm  = 'FTIPAYSIN'                                       CSC022
     C                   Eval      DBKey  = 'CSC022'                                          CSC022
     C                   Eval      DBase  = 900                                               CSC022
     C                   Out       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      **                                                                                      CSC022
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
     C                   EVAL      DBASE  = 41                                                CGL014
     C                   EXSR      *PSSR                                                      CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        PRTCD = *BLANKS                                            CGL014
     C                   EVAL      CGL014 = 'Y'                                               CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      CGL014 = 'N'                                               CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** Check if enhancement CSC024 (Open Month End) is on                                   CSC024
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
     C                   EVAL      DBASE  = 42                                                CSC024
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
     C                   EVAL      DBase = 43                                                 CSC024
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
     C/COPY WNCPYSRC,FTIPAYSC10
      *
      ** Read SDTRADPD for US dollar currency code
      *
     C                   CALLB     'AOTRADR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST'      POPTN
     C     SDTRAD        PARM      SDTRAD        DSFDY

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDTRADPD'
     C                   EVAL      DBASE = 032
     C                   EXSR      *PSSR
     C                   ENDIF
     C/COPY WNCPYSRC,FTIPAYSC14
      *
      ** If S01499 is installed, retrieve VAT Rate.
      *
     C     S01499        IFEQ      'Y'
     C     CFT009        ANDEQ     'N'                                          CFT009
     C     CFT010        OREQ      'Y'                                          CFT009
      *
     C                   CALL      'AOVATR0'                            9090
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C                   PARM                    PVATDS
      *
      ** Error occurred.
      *
     C     *IN90         IFEQ      '1'
     C     PRTCD         OREQ      '*ERROR*'
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'ABSFI101'    DBFILE
     C                   Z-ADD     015           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ELSE                                                   CFT009
     C                   Z-ADD     0             PVATR                          CFT009
     C                   ENDIF
      *
      ** Access FT Control Data.
      *
     C                   CALL      'FT0005'                             9090
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    PCNTRL
      *
      ** Error occurred.
      *
     C     *IN90         IFEQ      '1'
     C     PRTCD         ORNE      *BLANKS
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'FT0005'      DBFILE
     C                   Z-ADD     016           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Set up FT Override for GL Balances.
      *
     C     PGLUI         IFEQ      'I'
     C                   MOVEL     'Y'           PFTOV             1
     C                   ELSE
     C                   MOVEL     *BLANK        PFTOV
     C                   ENDIF
      *
      ** Access Currency details file for Base Currency details.
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      BJCYCD        PCCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     017           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        PBCDP             1 0
      *
      ** Access Currency details file for Local Currency details.
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      BJLCCY        PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     018           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        PLCDP             1 0
     C     A6MDIN        IFEQ      'M'
     C                   Z-ADD     1             PLMDIN            1 0
     C                   ELSE
     C                   Z-ADD     0             PLMDIN
     C                   ENDIF
     C                   Z-ADD     A6SPRT        PLSPOT           13 8
      *
      ** Retrieve ZMUSER details.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
      *
      ** Retrieve CASH information.
      *
     C     *DTAARA       DEFINE    CASH          PCSHDTA
     C                   IN        PCSHDTA
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr
      *
     C     PParmLink     IFEQ      'Y'
      *
     C                   MOVEL     PParmActn     DDACTN
     C                   MOVEL     PParmPRef     DDPREF
      *
     C                   SELECT
      *
     C     PParmRtcd     WHENEQ    'G'
     C                   MOVEL     'GL4442    '  PLinkPgm         10
      *
     C     PParmRtcd     WHENEQ    'Z'
     C                   MOVEL     'GL0090    '  PLinkPgm
      *
     C                   OTHER
     C                   MOVEL     *BLANKS       PLinkPgm
      *
     C     PParmActn     IFEQ      'I'
     C     PParmLevel    ANDEQ     '1'
     C                   MOVEL     *BLANKS       DDPREF
     C                   MOVEL     PParmPref     WMsgRefDS
     C                   Z-ADD     WRefMsg       PHMsgR
     C                   Z-ADD     WRefPrt       PHPart
     C                   MOVEL     *BLANKS       PHMIR
     C                   MOVEL     *BLANKS       PHMOR
     C                   ENDIF
      *
     C                   ENDSL
      *
     C                   MOVE      *BLANK        PParmRtcd
     C                   MOVE      'I'           WScrn
      *
      ** Validate initial screen details.
     C                   EXSR      SRVal_I
      *
     C                   ELSE
      *
     C                   MOVE      'I'           WScrn             1
      *
     C                   ENDIF
      *
      ** Get screen format of rundate.
     C                   Z-ADD     BJRDNB        PDayNo
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDayNo            5 0
     C                   PARM      BJDFIN        PFMT              1
     C                   PARM      *ZERO         PDate             6 0
     C                   PARM      *BLANKS       PADate            7
     C                   MOVEL     PDate         WRUNDAY           6
      *
      ** Define Account key list.
      *
     C     KAccnt        KLIST
     C                   KFLD                    KACNUM
     C                   KFLD                    KACCCY
     C                   KFLD                    KACCD
     C                   KFLD                    KACSQ
     C                   KFLD                    KBRCA
      *
      * Initialise flag to show first time through                                            204152
     C                   MOVE      'Y'           FirstTime         1                          204152
      *                                                                                       204152
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      *
      /COPY WNCPYSRC,FTIPAYS014
      *                                                                                       CER001
      ** ULX043 - New IBLC 2002 as Feature                                                    CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX043                                       CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX043'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
      ** An NRF (No Record Found) return code is valid.                                       CER001
      ** Issue database error only for error return codes.                                    CER001
      *                                                                                       CER001
     C                   IF        PRTCD <> *BLANKS AND                                       CER001
     C                             PRTCD <> '*NRF   '                                         CER001
     C                   EVAL      DBKEY = 'ULX043'                                           CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   Z-ADD     901           DBASE                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS                                            CER001
     C                   EVAL      ULX043 = 'Y'                                               CER001
      *                                                                                       CER001
      ** Do not process lux extension details when IBLC Returns                               CER001
      ** indicator is not set to 'Y'                                                          CER001
      *                                                                                       CER001
     C                   IF        BGNWST <> 'Y'                                              CER001
     C                   EVAL      ULX043 = 'N'                                               CER001
     C                   ELSE                                                                 CER001
     C                   OPEN      FTIPX1L0                                                   CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** CER030 - Multicash German Feature                                                    CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRTCD                                        CER030
     C                   PARM      '*VERIFY'     POPTN                                        CER030
     C                   PARM      'CER030'      PSARD                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
      ** An NRF (No Record Found) return code is valid.                                       CER030
      ** Issue database error only for error return codes.                                    CER030
      *                                                                                       CER030
     C                   IF        PRTCD <> *BLANKS AND                                       CER030
     C                             PRTCD <> '*NRF   '                                         CER030
     C                   EVAL      DBKEY = 'CER030'                                           CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   Z-ADD     902           DBASE                                        CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRTCD = *BLANKS                                            CER030
     C                   EVAL      CER030 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CER030 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** CER031 - Multicash German Feature                                                    CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRTCD                                        CER030
     C                   PARM      '*VERIFY'     POPTN                                        CER030
     C                   PARM      'CER031'      PSARD                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
      ** An NRF (No Record Found) return code is valid.                                       CER030
      ** Issue database error only for error return codes.                                    CER030
      *                                                                                       CER030
     C                   IF        PRTCD <> *BLANKS AND                                       CER030
     C                             PRTCD <> '*NRF   '                                         CER030
     C                   EVAL      DBKEY = 'CER031'                                           CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   Z-ADD     903           DBASE                                        CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRTCD = *BLANKS                                            CER030
     C                   EVAL      CER031 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CER031 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER001
      ** CGL013 - SWIFT Switcahble Feature                                                    CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRTCD                                        CER030
     C                   PARM      '*VERIFY'     POPTN                                        CER030
     C                   PARM      'CGL013'      PSARD                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
      ** An NRF (No Record Found) return code is valid.                                       CER030
      ** Issue database error only for error return codes.                                    CER030
      *                                                                                       CER030
     C                   IF        PRTCD <> *BLANKS AND                                       CER030
     C                             PRTCD <> '*NRF   '                                         CER030
     C                   EVAL      DBKEY = 'CGL013'                                           CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   Z-ADD     904           DBASE                                        CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRTCD = *BLANKS                                            CER030
     C                   EVAL      CGL013 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CGL013 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CFT120
      ** CFT120 - FT IN/OP - Charges to DR of Account Ccy                                     CFT120
      *                                                                                       CFT120
     C                   CALL      'AOSARDR0'                                                 CFT120
     C                   PARM      *BLANKS       PRTCD                                        CFT120
     C                   PARM      '*VERIFY'     POPTN                                        CFT120
     C                   PARM      'CFT120'      PSARD                                        CFT120
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
      *                                                                                       CFT120
      ** An NRF (No Record Found) return code is valid.                                       CFT120
      ** Issue database error only for error return codes.                                    CFT120
      *                                                                                       CFT120
     C                   IF        PRTCD <> *BLANKS AND                                       CFT120
     C                             PRTCD <> '*NRF   '                                         CFT120
     C                   EVAL      DBKEY = 'CFT120'                                           CFT120
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT120
     C                   Z-ADD     905           DBASE                                        CFT120
     C                   EXSR      *PSSR                                                      CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   IF        PRTCD = *BLANKS                                            CFT120
     C                   EVAL      CFT120 = 'Y'                                               CFT120
     C                   ELSE                                                                 CFT120
     C                   EVAL      CFT120 = 'N'                                               CFT120
     C                   ENDIF                                                                CFT120
      *
     C/COPY WNCPYSRC,FTH00270
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************                       225169
      *                                                               *                       225169
      *  WTRNCY   :  Translate SWIFT ccy to Midas ccy if needed.      *                       225169
      *                                                               *                       225169
      *  CALLED BY:  SREISwft, SRCYAM33B, SRFOCmt2                    *                       225169
      *                                                               *                       225169
      *****************************************************************                       225169
     C     WTRNCY        BEGSR                                                                225169
     C     W_CCY         IFNE      *BLANKS                                                    225169
     C                   CALL      'AOCURRR0'                                                 225169
     C                   PARM      *BLANKS       PRTCD                                        225169
     C                   PARM      '*KEY   '     POPTN                                        225169
     C                   PARM      W_CCY         PCCY                                         225169
     C     SDCURR        PARM      SDCURR        DSSDY                                        225169
      *                                                                                       225169
     C     PRTCD         IFNE      *BLANKS                                                    225169
      *                                                                                       225169
      ** Access SDCURRLD keyed by SWIFT currency code, in case this is                        225169
      ** different from Midas currency code.                                                  225169
      *                                                                                       225169
     C     W_CCY         CHAIN     SDCURRLD                           80                      225169
     C******IN80***      IFEQ      *ON                                                 225169 226917
     C*************      MOVEL     W_CCY         DBKEY                                 225169 226917
     C*************      MOVEL     'SDCURRPD'    DBFILE                                225169 226917
     C*************      Z-ADD     87            DBASE                                 225169 226917
     C*************      EXSR      *PSSR                                               225169 226917
     C*************      ENDIF                                                         225169 226917
     C*************      ENDIF                                                         225169 226917
      *                                                                                       226917
      * Overwrite currency code if found                                                      226917
     C     *IN80         IFEQ      *OFF                                                       226917
     C                   MOVE      A6CYCD        W_CCY             3                          225169
     C                   ENDIF                                                                226917
      *                                                                                       226917
     C                   ENDIF                                                                226917
     C                   ENDIF                                                                225169
      *                                                                                       225169
     C                   ENDSR                                                                225169
     C/COPY WNCPYSRC,FTH00271
     C/EJECT                                                                                  225169
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
**  CPY@
(c) Finastra International Limited 2001
**  PSNAR
Payment Advice From Cashier System
