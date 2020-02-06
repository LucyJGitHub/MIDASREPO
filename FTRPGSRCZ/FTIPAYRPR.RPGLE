     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Invalid incoming payments repair')            *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAYRPR - Invalid Incoming Payments Repair                 *
      *                                                               *
      *  Function: This module allows invalid Incoming Payments to be *
      *            'repaired' and applied to the Midas database.      *
      *                                                               *
      *  Component of: FTIPAYRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD047369A          Date 24Jan18               *      
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR1090283          Date 10Aug16               *
      *                 MD025111           Date 24Feb14               *
      *                 CFT151             Date 21Mar14               *
      *                 MD022652           Date 07Oct13               *
      *                 CFT120             Date 28Sep12               *
      *                 CAP211             Date 28Sep12               *
      *                 AR572681           Date 22Jul10               *
      *                 CSC054             Date 23Feb12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 250600             Date 30Sep07               *
      *                 232151             Date 30Sep07               *
      *                 249652             Date 09Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 GBO015             Date 06Sep06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 247142             Date 01Jun07               *
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9311            Date 25Apr05               *
      *                 CER001             Date 25Apr05               *
      *                 BUG7101            Date 05Jul05               *
      *                 CSC024             Date 07Feb05               *
      *                 CFT115             Date 01Jul04               *
      *                 CGL014             Date 20Oct03               *
      *                 TDA006             Date 23Mar04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001             Date 09Dec03               *
      *                 CAP084             Date 25Aug03               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209067             Date 14Oct02               *
      *                 203738             Date 22May02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 199992             Date 09Nov01               *
      *                 CSC011             Date 18Sep01               *
      *                 193883             Date 20Nov01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 187056             Date 01Dec00               *
      *                 CFT014             Date 25May99               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD047369A - Funds transfter does not check block Dr flag on  *
      *              beneficary customer account.                     *      
      *  MD046248 - Finastra Rebranding                               *
      *  AR1090283 - Customer details not visible for enquire.        *
      *              (Child: AR1090284)                               *
      *            - Applied for MD-39986.                            *
      *  MD025111 - Incoming payment without charges is not allowed   *
      *             if the account is blocked for DR                  *
      *  CFT151 - FT IN/OP Alphanumeric sequence                      *
      *  MD022652 - Excluded Phase Processing                         *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CAP211 - FT IN_OP APIs - Auto-Authorization of Payment       *
      *  AR572681 - When error is encountered in Receiver's Corr.,    *
      *             wrong field is highlighted.  Fix is to adjust the *
      *             ABFIELDID because of reference rate field         *
      *  CSC054 - Period End Adjustments                              *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  250600 - Fix to CFT032                                       *
      *  247142 - Funds Transfer allows payments over Blocked &       *
      *           Reffered Accounts without warning. Apply fix 232151.*
      *  232151 - Warning message for the first screen appears on the *
      *           second screen.                                      *
      *  249652 - CFT032, a few problems (Recompile)                  *
      *  GBO015 - Incoming Payments Beneficiary Validation            *
      *           Added hook FTIPAYR017                               *
      *  247142 - Funds Transfer allows payments over Blocked &       *
      *           Reffered Accounts without warning. Apply fix 232151.*
      *  CFT032 - Account line in field 50X in MT103                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9311- DB Error on FT0320 due to blank W7OCCY being passed *
      *           to it.                                              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  BUG7101 - DB error in AOSPOSU0 due to blank INTRIT. Ensure   *
      *            fields are properly initialised.  Applied core fix *
      *            216842.                                            *
      *  CSC024 - Open Month End                                      *
      *  CFT115 - Core changes for GBO015.                            *
      *         - Incoming Payments Beneficiary Validation            *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:FTIPAYR002,FTIPAYRC11,FTIPAYRC02 *
      *  CGL014 - Collaterals Processing                              *
      *  TDA006 - Correct 10-digit full account processing.           *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits.                 *
      *  CGP001 - Recompiled due to change in FTV2OPYPD               *
      *  CAP084 - Thin Client API Wrappers                            *
      *           Recompiled over changed FTIPY6PD.                   *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  209067 - Apply changes from FTIPAYSIN to RPR module, to      *
      *           enable symbols window input in repair function.     *
      *  203738 - PVATR should set to 0 as done in FTIPAYSIN (to avoid*
      *           decimal data error in FTIPAY4VL)                    *
      *  199992 - Error calling FTIPAY4VL due to incomplete parameters*
      *           passed.                                             *
      *  CSC011 - 24x7 Midas Availability                             *
      *  193883 - Recompile over changed FTIPAYUPD.                   *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  187056 - IP and OP do not recalculate screen charges if      *
      *           'Charges to the Debit of a/c' has been changed      *
      *           from blank to non-blank.                            *
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
      ** Transaction Errors file keyed on Front Office Transaction Id,
      ** Timestamp and Transaction Field Identifier
     FZATRNERRL1IF   E           K DISK    INFSR(*PSSR)
      *
      ** Invalid Incoming Payments by Timestamp and Front Office Id
      ** - for record retrieval
     FFTIIPAYL0 IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FTIIPAYD0:FTIIPAYX0)
      *
      ** Invalid Incoming Payments by Front Office Id and Timestamp
      ** - for record update
     FFTIIPAYL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     FAPILOGL0  UF   E           K DISK    INFSR(*PSSR) USROPN                                CSC011
     F                                     COMMIT                                             CSC011
      *                                                                                       CER001
     FFTIPX1L0  IF   E           K DISK    USROPN                                             CER001
     F                                     RENAME(INPAYDDL:RTVIDX)                            CER001
     F                                     INFSR(*PSSR)                                       CER001
      *                                                                                       CER001
     FFTIIPLX1L0UF   E           K DISK    USROPN                                             CER001
     F                                     RENAME(FTIIPLXDL:RTVIDX1)                          CER001
     F                                     INFSR(*PSSR)                                       CER001
     F                                     COMMIT                                             CER001
      *                                                                                       CER001
     FSDCUX1L0  IF   E           K DISK                                                       CER001
     F/COPY WNCPYSRC,FTH00141
      *                                                                                       CER030
      ** Network Transaction Identifier File                                                  CER030
      *                                                                                       CER030
     FSDNTTIL1  IF   E           K DISK    INFSR(*PSSR)                                       CER030
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,FTIPAYR001
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
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
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
      ** String for System Values Array                                                       CSC024
     D*SysValOME       C                   CONST('OMEIndicator')                       CSC024 CSC054
     D SysValPEA       C                   CONST('PEAIndicator')                              CSC054
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D WEI             S              1    DIM(60)
      *
      ** Work array for warning message Ids
     D WPrvWarnAr      S                   Dim(ArrayMax)
     D                                     Like(WMsgIDArr)
      *
      ** Backup arrays for error messages on Level 1 screen
      *
     D FldNameAr1      S                   Dim(ArrayMax)
     D                                     Like (FldNameArr)
     D MsgIdAr1        S                   Dim(ArrayMax)
     D                                     Like (MsgIdArr)
     D MsgDtaAr1       S                   Dim(ArrayMax)
     D                                     Like (MsgDtaArr)
      *
      ** Backup arrays for error messages on Level 2 screen 1
      *
     D FldNameAr2      S                   Dim(ArrayMax)
     D                                     Like (FldNameArr)
     D MsgIdAr2        S                   Dim(ArrayMax)
     D                                     Like (MsgIdArr)
     D MsgDtaAr2       S                   Dim(ArrayMax)
     D                                     Like (MsgDtaArr)
      *
      ** Backup arrays for error messages on Level 2 screen 2
      *
     D FldNameAr3      S                   Dim(ArrayMax)
     D                                     Like (FldNameArr)
     D MsgIdAr3        S                   Dim(ArrayMax)
     D                                     Like (MsgIdArr)
     D MsgDtaAr3       S                   Dim(ArrayMax)
     D                                     Like (MsgDtaArr)
      *                                                                         CFT014
      ** Backup arrays for error messages on Level 2 screen 3                   CFT014
      *                                                                         CFT014
     D FldNameAr4      S                   Dim(ArrayMax)                        CFT014
     D                                     Like (FldNameArr)                    CFT014
     D MsgIdAr4        S                   Dim(ArrayMax)                        CFT014
     D                                     Like (MsgIdArr)                      CFT014
     D MsgDtaAr4       S                   Dim(ArrayMax)                        CFT014
     D                                     Like (MsgDtaArr)                     CFT014
      *                                                                         CFT014
      ** Backup arrays for error messages on Margin Info scrn                   CFT014
      *                                                                         CFT014
     D FldNameAr5      S                   Dim(ArrayMax)                        CFT014
     D                                     Like (FldNameArr)                    CFT014
     D MsgIdAr5        S                   Dim(ArrayMax)                        CFT014
     D                                     Like (MsgIdArr)                      CFT014
     D MsgDtaAr5       S                   Dim(ArrayMax)                        CFT014
     D                                     Like (MsgDtaArr)                     CFT014
      *
      ** Work array for setting up new Payment Reference
     D WYA1            S              1    DIM(18)
      *                                                                                       209067
      ** Work array for setting up new Payment Reference                                      209067
     D WYA2            S              1    DIM(18)                                            209067
      ** Commitment Control Job Array                                                         CSC022
     D WJobs           S             10A   Dim(10)                                            CSC022
      **                                                                                      CSC022
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     D NwIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 Scrn 1/2 details from incoming transaction     CFT014
      ** - screen format                                                        CFT014
     D NwIP1aScnFmt  E DS                  EXTNAME(FTIPY1APD)                   CFT014
      *
      ** Incoming Payments Lvl 2 Scrn 1/1 details from incoming transaction
      ** - screen format
     D NwIP2ScnFmt   E DS                  EXTNAME(FTIPY2PD)
      *
      ** Incoming Payments Lvl 2 Scrn 1/2 details from incoming transaction
      ** - screen format
     D NwIP3ScnFmt   E DS                  EXTNAME(FTIPY3PD)
      *
      ** Incoming Payments Lvl 2 Scrn 2 details from incoming transaction
      ** - screen format
     D NwIP4ScnFmt   E DS                  EXTNAME(FTIPY4PD)
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 2/2 details from incoming transaction     CFT014
      ** - screen format                                                        CFT014
     D NwIP4aScnFmt  E DS                  EXTNAME(FTIPY4APD)                   CFT014
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction       CFT014
      ** - screen format                                                        CFT014
     D NwIP5ScnFmt   E DS                  EXTNAME(FTIPY5PD)                    CFT014
      *                                                                         CFT014
      ** Incoming Payments Margin Info details from incoming transaction        CFT014
      ** - screen format                                                        CFT014
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
      ** Incoming Payments Extended Narratives from incoming transaction                      CER030
      ** - screen format                                                                      CER030
      *                                                                                       CER030
     D NwIP6AScnFmt  E DS                  EXTNAME(FTIPY6APD)                                 CER030
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
      *                                                                         CFT014
      ** Incoming Payments (additional details) for file update - file format   CFT014
     D NwIP2FilFmt   E DS                  EXTNAME(FTVIPY2PD)                   CFT014
      *
      ** Incoming Payments Lvl 1 Scrn details retrieved from file
      ** - screen format
     D CrIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
     D                                     PREFIX(O)
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 Scrn 1/2 details retrieved from file           CFT014
      ** - screen format                                                        CFT014
     D CrIP1aScnFmt  E DS                  EXTNAME(FTIPY1APD)                   CFT014
     D                                     PREFIX(O)                            CFT014
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
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 2/2 details retrieved from file           CFT014
      ** - screen format                                                        CFT014
     D CrIP4aScnFmt  E DS                  EXTNAME(FTIPY4APD)                   CFT014
     D                                     PREFIX(O)                            CFT014
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction       CFT014
      ** - screen format                                                        CFT014
     D CrIP5ScnFmt   E DS                  EXTNAME(FTIPY5PD)                    CFT014
     D                                     PREFIX(O)                            CFT014
      *                                                                         CFT014
      ** Incoming Payments Margin Info details from incoming transaction        CFT014
      ** - screen format                                                        CFT014
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
      ** Incoming Payments Margin Info details from incoming transaction                      CER030
      ** - screen format                                                                      CER030
      *                                                                                       CER030
     D CrIP6AScnFmt  E DS                  EXTNAME(FTIPY6APD)                                 CER030
     D                                     PREFIX(O)                                          CER030
      *
      ** Incoming Payments retrieved from file - file format
     D CrIPFilFmt    E DS                  EXTNAME(INPAYDD)
      *                                                                         CFT014
      ** Incoming Payments (add'l details) retrieved from file - file format    CFT014
     D CrIP2FilFmt   E DS                  EXTNAME(INPAYXPD)                    CFT014
                                                                                CFT009
      ** Valid Incoming Payments Extension File (default)                       CFT009
     D DEFVALIDX     E DS                  EXTNAME(FTVIPY2PD)                   CFT009
     D                                     PREFIX(D#)                           CFT009
                                                                                CFT009
      * Valid Payments layout (default)                                         CFT009
     D DEFVALID      E DS                  EXTNAME(FTVIPAYPD)                   CFT009
     D                                     PREFIX(D#)                           CFT009
     D/COPY WNCPYSRC,FTH00142
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     D FTEIPY1       E DS                  EXTNAME(FTEIPY1PD)
      *
      ** Incoming Payments Lvl 2 Scrn 1 error indicators
     D FTEIPY2       E DS                  EXTNAME(FTEIPY2PD)
      *
      ** Incoming Payments Lvl 2 Scrn 2 error indicators
     D FTEIPY3       E DS                  EXTNAME(FTEIPY3PD)
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 3 error indicators                        CFT014
     D FTEIPY4       E DS                  EXTNAME(FTEIPY4PD)                   CFT014
      *                                                                         CFT014
      ** Incoming Payments Margin Info error indicators                         CFT014
     D FTEIPY5       E DS                  EXTNAME(FTEIPY5PD)                   CFT014
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 7 error indicators                                      CSW209
     D FTEIPY7       E DS                  EXTNAME(FTEIPY7PD)                                 CSW209
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 8 error indicators                                      CSW209
     D FTEIPY8       E DS                  EXTNAME(FTEIPY8PD)                                 CSW209
      *
      ** Incoming Payments extra data
     D PExtData      E DS                  EXTNAME(FTIPEXPD)
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
      ** Externally described DS for API ICD details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
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
      ** Externally described DS trading ICD data
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
     D  QQACC2       E                     EXTFLD(QQACCD)                                     CGL029
      *
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Backup data structures for screen details
      *
     D NwIP1ScnFmx   E DS                  EXTNAME(FTIPY1PD)
     D                                     PREFIX(B)
      *                                                                         CFT014
     D NwIP1aScnFmx  E DS                  EXTNAME(FTIPY1APD)                   CFT014
     D                                     PREFIX(B)                            CFT014
      *
     D NwIP2ScnFmx   E DS                  EXTNAME(FTIPY2PD)
     D                                     PREFIX(B)
      *
     D NwIP3ScnFmx   E DS                  EXTNAME(FTIPY3PD)
     D                                     PREFIX(B)
      *
     D NwIP4ScnFmx   E DS                  EXTNAME(FTIPY4PD)
     D                                     PREFIX(B)
      *                                                                         CFT014
     D NwIP4aScnFmx  E DS                  EXTNAME(FTIPY4APD)                   CFT014
     D                                     PREFIX(B)                            CFT014
      *                                                                         CFT014
     D NwIP5ScnFmx   E DS                  EXTNAME(FTIPY5PD)                    CFT014
     D                                     PREFIX(B)                            CFT014
      *                                                                         CFT014
     D NwIP6ScnFmx   E DS                  EXTNAME(FTIPY6PD)                    CFT014
     D                                     PREFIX(B)                            CFT014
      *                                                                                       CSW209
     D NwIP7ScnFmx   E DS                  EXTNAME(FTIPY7PD)                                  CSW209
     D                                     PREFIX(B)                                          CSW209
      *                                                                                       CSW209
     D NwIP8ScnFmx   E DS                  EXTNAME(FTIPY8PD)                                  CSW209
     D                                     PREFIX(B)                                          CSW209
      *                                                                                       CER030
     D NwIP6AScnFmx  E DS                  EXTNAME(FTIPY6APD)                                 CER030
     D                                     PREFIX(B)                                          CER030
      *
      ** Backup data structures for screen error indicators
      *
     D FTEIPY1x      E DS                  EXTNAME(FTEIPY1PD)
     D                                     PREFIX(B)
      *
     D FTEIPY2x      E DS                  EXTNAME(FTEIPY2PD)
     D                                     PREFIX(B)
      *
     D FTEIPY3x      E DS                  EXTNAME(FTEIPY3PD)
     D                                     PREFIX(B)
      *                                                                         CFT014
     D FTEIPY4x      E DS                  EXTNAME(FTEIPY4PD)                   CFT014
     D                                     PREFIX(B)                            CFT014
      *                                                                         CFT014
     D FTEIPY5x      E DS                  EXTNAME(FTEIPY5PD)                   CFT014
     D                                     PREFIX(B)                            CFT014
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
      *                                                                                       CER001
      ** New Incoming payments in File Format                                                 CER001
      *                                                                                       CER001
     D NwDlFilFmt    E DS                  EXTNAME(FTVIPLX1PD)                                CER001
      *                                                                                       CER001
      ** New Incoming payments in Screen Format                                               CER001
      *                                                                                       CER001
     D NwDlScnFmt    E DS                  EXTNAME(FTIPRXPD)                                  CER001
      *                                                                                       CER001
      ** Current Incoming payments in File Format                                             CER001
      *                                                                                       CER001
     D CrDlFilFmt    E DS                  EXTNAME(FTIPX1L0)                                  CER001
     D                                     PREFIX(S)                                          CER001
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
      ** DS for Additional Info details
     D PAddInfm        DS           196
      *
      ** DS for Default Charge Amounts
     D*PCharges********DS           108                                         CFT009
     D PCharges        DS           196                                         CFT009
      *
      ** DS for Default Charge Currencies
     D PChgCcy         DS            48
      *
      ** DS for next Incoming Payment Reference Number
     D WINPAY          DS             4
     D  WINSQ                  1      4  0
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
      ** Output Data Structure for reformatted address
     D POADD           DS           175
     D  OADD1                  1     35
     D  OADD2                 36     70
     D  OADD3                 71    105
     D  OADD4                106    140
     D  OADD5                141    175
      *                                                                                       187056
      ** Calling parameter DS for FT0035                                                      187056
     D P0DTA           DS           256                                                       187056
     D  WIPT1                  1      1                                                       187056
     D  WIPTY1                 2     36                                                       187056
     D  WIPT2                 37     37                                                       187056
     D  WIPTY2                38     72                                                       187056
     D  WICCY                 73     75                                                       187056
     D  WOCUST                76     81                                                       187056
                                                                                              199992
      ** Warning message work inds for charges screen                                         199992
     D PChgWarn        DS            24                                                       199992
     D  WFTF3176               1      1                                                       199992
     D  WFTF3177               2      2                                                       199992
     D  WFTF3178               3      3                                                       199992
     D  WFTF3179               4      4                                                       199992
     D  WFTF3202               5      5                                                       199992
     D  WFTF3204               6      6                                                       199992
     D  WFTF3182               7      7                                                       199992
     D  WFTF3184               8      8                                                       199992
     D  WFTF3185               9      9                                                       199992
     D  WFTF3186              10     10                                                       199992
     D  WFTF3187              11     11                                                       199992
     D  WFTF3188              12     12                                                       199992
     D  WFTF3158              13     13                                                       199992
     D  WFTF3159              14     14                                                       199992
     D  WFTF3160              15     15                                                       199992
     D  WFTF3161              16     16                                                       199992
     D  WFTF3203              17     17                                                       199992
     D  WFTF3205              18     18                                                       199992
     D  WFTF3164              19     19                                                       199992
     D  WFTF3171              20     20                                                       199992
     D  WFTF3172              21     21                                                       199992
     D  WFTF3173              22     22                                                       199992
     D  WFTF3174              23     23                                                       199992
     D  WFTF3175              24     24                                                       199992
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
      ** Backup index for error messages on Level 1 screen
     D ID1             S              3P 0
      *
      ** Backup index for error messages on Level 2 screen 1
     D ID2             S              3P 0
      *
      ** Backup index for error messages on Level 2 screen 2
     D ID3             S              3P 0
      *                                                                         CFT014
      ** Backup index for error messages on Level 2 screen 3                    CFT014
     D ID4             S              3P 0                                      CFT014
      *                                                                         CFT014
      ** Backup index for error messages on Margin Info scrn                    CFT014
     D ID5             S              3P 0                                      CFT014
      *
      ** Work index
     D Ex              S              3P 0
      *
      ** Timestamp selected
     D PTMESTPSEL      S             26Z
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     D PMode           S              6A   INZ('      ')
      *
      ** Entry Point
     D PParmLEVEL      S              1A   INZ('1')
      *
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous.
     D PResponse       S              1A   INZ('S')
      *
      ** Linked Program
     D PLinkPgm        S             10A   INZ(*BLANKS)
      *
      ** Fields for getting the starting field number from file
      ** (parameters to ZAGETFLDNO, plus the offset to the requested field)
     D PFormat         S             10A   INZ('FTIPAYPD')
     D PField1         S             10A   INZ('DDACTN')
     D PField2         S             10A   INZ('DDOBK1')
     D PField3         S             10A   INZ('DDINB1')
     D PField4         S             10A   INZ('DDCDRO')                        CFT014
     D PField5         S             10A   INZ('DDFXMP')                        CFT014
     D PFieldNo        S              5P 0
     D WFldOffset1     S              5P 0
     D WFldOffset2     S              5P 0
     D WFldOffset3     S              5P 0
     D WFldOffset4     S              5P 0                                      CFT014
     D WFldOffset5     S              5P 0                                      CFT014
      ** CSC022 work fields                                                                   CSC022
     D WArrPtr         S              3S 0                                                    CSC022
     D WSkpComtRolbk   S              1A                                                      CSC022
      **                                                                                      CSC022
      *
      ** Incoming Payment Status
     D PStatus         S             10A
      *
      ** Cursor position
     D PRowCol         S              4B 0
                                                                                              CSC011
      ** 24X7 Midas Availability switchable field                                             CSC011
     D CSC011          S              1A                                                      CSC011
                                                                                              CSC011
      ** Message Type key field                                                               CSC011
     D KMTYP           S              8A                                                      CSC011
                                                                                              CSC011
      ** Processing Date                                                                      CSC011
     D PPROCDTE        S              5  0                                                    CSC011
     D PPRDATE         S              6  0                                                    CSC011
     D PPRADATE        S              7                                                       CSC011
                                                                                              CSD015
      ** Switchable features                                                                  CSD015
     D CSD015          S              1A                                                      CSD015
                                                                                              CSD015
      ** Compliance Watch switchable field                                                    CSD015
     D CCF001          S              1A                                                      CSD015
                                                                                              CSD015
      ** CSC022 switchable field                                                              CSC022
     D CSC022          S              1A                                                      CSC022
      **                                                                                      CSC022
     D PPrvCDRO        S             18A                                                      CGL029
                                                                                              CGL014
     D CGL014          S              1                                                       CGL014
      /COPY WNCPYSRC,FTIPAYR017
      *                                                                                       CER001
      ** CER001 Declared Variables                                                            CER001
      *                                                                                       CER001
     D WFIND           S              1                                                       CER001
     D WWCUTY          S              2A                                                      CER001
     D P@CURR          S              3A                                                      CER001
     D P@TYPE          S              1A                                                      CER001
     D P@LINE          S             35                                                       CER001
     D P@OPCL          S              1  0                                                    CER001
     D P@ACCD          S             10A                                                      CER001
     D P@CUST          S              6A                                                      CER001
     D P@FOUND         S              1A                                                      CER001
     D PDDACTN         S              1A                                                      CER001
                                                                                              CSW209
      ** SWIFT 2009 flag                                                                      CSW209
     D CSW209          S              1A                                                      CSW209
      *                                                                                       CER030
     D CER030          S              1A                                                      CER030
     D CER031          S              1A                                                      CER030
     D CGL013          S              1A                                                      CER030
     D KTtcd           S             10A                                                      CER030
     D WFlg            S              1A                                                      CER030
     D Wk              S              3P 0                                                    CER030
      *
      ** Variable for storing previous value                                                  CFT120
      *                                                                                       CFT120
     D PPrvCDRC        S              3                                                       CFT120
      *                                                                                       CFT120
      ** CFT120 switchable field                                                              CFT120
      *                                                                                       CFT120
     D CFT120          S              1                                                       CFT120
      *                                                                                       CFT120
      ** +--------------------------------------+
      ** ¦ /COPYs                               ¦
      ** ¦ ======                               ¦
      ** +--------------------------------------+
      *
      /COPY QWINDSRC,FTIPAYDTA
     D/COPY WNCPYSRC,FTH00510
     D PDATA           DS          1024                                                       CER001
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
     D  #1DEXT               180    180                                                       CER001
     D/COPY WNCPYSRC,FTH00511
      *                                                                                       CER001
     D CSC054          S              1                                                       CSC054
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,FTIPAYR002
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
      /COPY WNCPYSRC,FTIPAYR003
      *
      ** Browse Invalid Incoming Payments.
      *
     C                   IF        WSCRN = 'B'
     C                   EXSR      SRScrn_B
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTIPAYR004
      *
      ** Read Next Browse Subfile record.
      *
     C                   IF        WSCRN = 'R'
     C                   EXSR      SRRdNBrw
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTIPAYR005
      *
      ** DO WHILE: Process Level 1 screen.
      *
     C                   DOW       WSCRN = 'P'
     C                   EXSR      SRScrn_P
     C                   ENDDO
      *
      /COPY WNCPYSRC,FTIPAYR006
      *
      ** DO WHILE: Process Level 2 screen 1.
      *
     C                   DOW       WSCRN = 'S'
     C                   EXSR      SRScrn_S
     C                   ENDDO
      *
      /COPY WNCPYSRC,FTIPAYR007
      *
      ** DO WHILE: Process Level 2 screen 2.
      *
     C                   DOW       WSCRN = 'C'
     C                   EXSR      SRScrn_C
     C                   ENDDO
      *                                                                         CFT014
      /COPY WNCPYSRC,FTIPAYR015                                                 CFT014
      *                                                                         CFT014
      ** DO WHILE: Process Level 2 screen 3.                                    CFT014
      *                                                                         CFT014
     C                   DOW       WSCRN = 'D'                                  CFT014
     C                   EXSR      SRScrn_D                                     CFT014
     C                   ENDDO                                                  CFT014
      *                                                                         CFT014
      /COPY WNCPYSRC,FTIPAYR016                                                 CFT014
      *                                                                         CFT014
      ** DO WHILE: Process Margin Information screen.                           CFT014
      *                                                                         CFT014
     C                   DOW       WSCRN = 'M'                                  CFT014
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
      /COPY WNCPYSRC,FTIPAYR008
      *
      ** Process Window screen.
      *
     C                   IF        WSCRN = 'W'
     C                   EXSR      SRScrn_W
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTIPAYR009
      *
      ** Process Confirmation screen.
      *
     C                   IF        WSCRN = 'F'
     C                   EXSR      SRScrn_F
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTIPAYR010
      *
      ** Process Additional Information screen.
      *
     C                   IF        WSCRN = 'A'
     C                   EXSR      SRScrn_A
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTIPAYR011
      *
      ** Update files.
      *
     C                   IF        WSCRN = 'U'
     C                   EXSR      SRUpdate
      *                                                                                       209067
      * Reset First Time through Flag                                                         209067
     C                   EVAL      FirstTime = 'Y'                                            209067
      *                                                                                       209067
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTIPAYR012
      *
      ** Terminate program.
      *
     C                   IF        WSCRN = 'T'
     C                   IF        ULX043 = 'Y'                                               CER001
     C                   EXSR      SREND                                                      CER001
     C                   ENDIF                                                                CER001
     C                   MOVE      *On           *INLR
     C                   ENDIF
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      *
      /COPY WNCPYSRC,FTIPAYR013
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      * SRPREX  - Call Extension field processing                     *                       CER001
      *****************************************************************                       CER001
     C     SRPREX        BEGSR                                                                CER001
      *                                                                                       CER001
      ** Using Same Details but Call with 2Part validated                                     CER001
      ** If Payment reference still blank when window is called                               CER001
      ** allocate payment reference                                                           CER001
      *                                                                                       CER001
     C                   MOVE      'N'           WAlloc                                       CER001
     C                   MOVE      *BLANKS       WAllPref                                     CER001
      *                                                                                       CER001
      *    Action is Insert.                                                                  CER001
      *                                                                                       CER001
     C                   IF        (DDACTN = 'I') AND (IPPREF = *BLANKS)                      CER001
      *                                                                                       CER001
      ** Update Incoming Payments data area with next                                         CER001
      ** Sequence Number.                                                                     CER001
      *                                                                                       CER001
     C                   IF        CFT151 = 'N'                                               CFT151
     C     *LOCK         IN        WINPAY                                                     CER001
     C                   Z-ADD     WINSQ         WWINSQ            4 0                        CER001
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
     C                   MOVEL     'D'           IPRECI                                       CER001
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
     C                   MOVE      PDate         WN2               2 0                        CER001
     C                   IF        WN2 < 72                                                   CER001
     C                   Z-ADD     20            IPOEDTD2                                     CER001
     C                   ELSE                                                                 CER001
     C                   Z-ADD     19            IPOEDTD2                                     CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   MOVEL     PDate         WA4               4                          CER001
     C                   IF        BJDFIN <> 'M'                                              CER001
     C                   MOVEL     WA4           WA2               2                          CER001
     C                   MOVE      WA4           WA2A              2                          CER001
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
     C                   MOVE      PDate         WA6               6                          CER001
     C                   IF        CFT151 = 'N'                                               CFT151
     C                   MOVE      WWINSQ        WA4                                          CER001
     C                   ELSE                                                                 CFT151
     C                   MOVE      WWINSQT       WA4                                          CFT151
     C                   END                                                                  CFT151
     C                   MOVE      'P'           WYA1(1)                                      CER001
     C                   MOVEA     WA6           WYA1(2)                                      CER001
     C                   MOVEA     WA4           WYA1(8)                                      CER001
     C                   MOVEA     IPPYTP        WYA1(12)                                     CER001
     C                   MOVEA     '00'          WYA1(14)                                     CER001
      *                                                                                       CER001
     C     1             DO        15            IA                2 0                        CER001
     C     WYA1(IA)      IFEQ      ' '                                                        CER001
     C                   MOVEL     '0'           WYA1(IA)                                     CER001
     C                   ENDIF                                                                CER001
     C                   ENDDO                                                                CER001
      *                                                                                       CER001
     C                   MOVEA     WYA1(1)       IPPREF                                       CER001
     C                   MOVEA     WYA1(1)       PPREFI                                       CER001
     C                   MOVE      'Y'           WInsert                                      CER001
      *                                                                                       CER001
      ** Level 1 Valid Indicator.                                                             CER001
      *                                                                                       CER001
     C                   EVAL      IPINLVL1 = 'Y'                                             CER001
      *                                                                                       CER001
     C                   MOVE      'Y'           WAlloc            1                          CER001
     C                   MOVEA     WYA1(1)       WAllPref         15                          CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   MOVEL     IPPREF        PREF1                                        CER001
     C                   MOVEL     PFOTRANSEL    #1FOTR                                       CER001
     C                   MOVEL     PTMESTPSEL    #1TMST                                       CER001
     C                   MOVEL     IPACBT        #1ACBT                                       CER001
     C                   MOVEL     IPBNCT        #1BNCT                                       CER001
     C                   MOVEL     IPACBK        #1ACBK                                       CER001
     C                   MOVEL     IPBNC1        #1BNC1                                       CER001
     C                   Z-ADD     IPSMAM        #1SMAM                                       CER001
     C                   MOVEL     IPPCCY        #1PCCY                                       CER001
      *                                                                                       CER001
     C                   MOVEL     IPRCRT        #1RCRT                                       CER001
     C                   MOVEL     IPRCCO        #1RCCO                                       CER001
     C                   MOVEL     IPSNTP        #1SNTP                                       CER001
     C                   MOVEL     IPSND1        #1SND1                                       CER001
      *                                                                                       CER001
      ** Retreive Beneficiary type BNCT                                                       CER001
      *                                                                                       CER001
      ** take screen value passed by FTIPAYDTA (Screen content)                               CER001
      *                                                                                       CER001
     C                   MOVEL     #1ACBT        ACBT                                         CER001
     C                   MOVEL     #1ACBK        ACBK                                         CER001
     C                   MOVEL     #1BNCT        BNCT                                         CER001
     C                   MOVEL     #1BNC1        BNC1                                         CER001
     C                   MOVEL     #1PCCY        PCCY                                         CER001
      *                                                                                       CER001
      ** Setup parameters PTYPE and PLINE to call IL0421                                      CER001
      *                                                                                       CER001
     C     BNCT          IFEQ      'A'                                                        CER001
     C     BNCT          OREQ      'S'                                                        CER001
     C                   MOVE      ACBT          P@TYPE                                       CER001
     C                   MOVEL     ACBK          P@LINE                                       CER001
     C                   ELSE                                                                 CER001
     C                   MOVE      BNCT          P@TYPE                                       CER001
     C                   MOVE      BNC1          P@LINE                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   CALL      'IL0421'                                                   CER001
      *                                                                                       CER001
      ** Input                                                                                CER001
      *                                                                                       CER001
     C                   PARM      PCCY          P@CURR                                       CER001
     C                   PARM                    P@TYPE                                       CER001
     C                   PARM                    P@LINE                                       CER001
     C                   PARM      0             P@OPCL                                       CER001
      *                                                                                       CER001
      ** Output                                                                               CER001
      *                                                                                       CER001
     C                   PARM      *BLANKS       P@ACCD                                       CER001
     C                   PARM      *BLANKS       P@CUST                                       CER001
     C                   PARM                    P@FOUND                                      CER001
      *                                                                                       CER001
     C                   MOVE      *BLANKS       WWCUTY                                       CER001
      *                                                                                       CER001
     C     P@FOUND       IFEQ      'Y'                                                        CER001
      *                                                                                       CER001
     C     P@CUST        CHAIN     SDCUX1L0                           99                      CER001
     C                   IF        *IN99 = *ON                                                CER001
     C                   MOVEL     'SDCUX1L0'    DBFILE                                       CER001
     C                   MOVEL     '901'         DBASE                                        CER001
     C                   MOVEL     *BLANKS       DBKEY                                        CER001
     C                   MOVEL     P@CUST        DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   MOVE      CUTYPE        WWCUTY                                       CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Retrieve record in extension file                                                    CER001
      *                                                                                       CER001
     C                   MOVEL     IPPREF        K@PREF                                       CER001
     C     K@KEY         CHAIN(N)  RTVIDX                                                     CER001
     C                   IF        %FOUND                                                     CER001
     C                   EXSR      SRFTOS                                                     CER001
     C                   ELSE                                                                 CER001
     C                   EXSR      SRINZ                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        POPSEL = 'N'                                               CER001
     C                   EVAL      PDDACTN = DDACTN                                           CER001
     C                   EVAL      DDACTN = 'E'                                               CER001
     C                   EVAL      #1DEXT = 'Y'                                               CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   CALL      'FTIPAY2RP'                                                CER001
     C                   PARM      DDACTN        ACTION            1                          CER001
     C/COPY WNCPYSRC,FTH00512
     C                   PARM                    PDATA                                        CER001
     C/COPY WNCPYSRC,FTH00513
     C                   PARM      *BLANKS       #RTRN             7                          CER001
     C                   PARM                    P@CUST                                       CER001
     C                   PARM                    WWCUTY                                       CER001
     C                   PARM                    NwDlScnFmt                                   CER001
     C                   PARM                    NwDlFilFmt                                   CER001
     C                   EVAL      #1DEXT = *BLANK                                            CER001
     C                   IF        POPSEL = 'N'                                               CER001
     C                   EVAL      DDACTN = PDDACTN                                           CER001
     C                   ENDIF                                                                CER001
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
     C                   MOVEL     'D'           WScrn                                        CER001
      *                                                                                       CER001
     C                   OTHER                                                                CER001
     C                   IF        POPSEL <> 'U'                                              CER001
     C                   IF        PRDNB = 'Y'                                                CER001
     C                   EVAL      WSCRN = 'R'                                                CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      WSCRN = 'B'                                                CER001
     C                   ENDIF                                                                CER001
     C                   ELSE                                                                 CER001
     C                   EVAL      WSCRN = 'F'                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDSL                                                                CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
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
     C***********        MOVEL     OADD5         DDORC5                         CFT014
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
     C***********        MOVEL     OADD4         DDORC5                         CFT014
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
      *  SRSCRN_B - Browse Invalid Incoming Payments                  *
      *                                                               *
      *****************************************************************
      *
     C     SRScrn_B      BEGSR
      *
      ** Reset Read Next Browse Subfile Record indicator.
      *
     C                   MOVE      *Blank        PRDNB             1
      *
      ** Browse Invalid Incoming Payments.
      *
     C                   CALLB     'FTIPAYRPB'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Build Subfile
     C                   PARM      'Y'           PBDSFL            1
      *
      ** Read Subfile Record
     C                   PARM      *BLANK        PRDSFL            1
      *
      ** Update Status of Previous Transaction
     C                   PARM                    PERRUP            1
      *
      ** Payment Reference Assigned to Previous Insert
     C                   PARM                    PPREFI
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
     C                   PARM                    PERRMS            7
      *
      ** Option Selected
     C                   PARM                    POPSEL            1
      *
      ** Action Selected
     C                   PARM                    PACSEL            1
      *
      ** Payment Reference Selected
     C                   PARM                    PPREFSEL         15
      *
      ** Front Office Transaction Id Selected
     C                   PARM                    PFOTRANSEL       20
      *
      ** Timestamp of Transaction Selected
     C                   PARM                    PTMESTPSEL
      *
      ** Function Key Enabled - F3
     C                   PARM                    PINKC             1
     C                   PARM                    CSC011                                       CSC011
      ** CSC022 Enhancement is installed                                                      CSC022
      **                                                                                      CSC022
     C                   PARM                    CSC022                                       CSC022
      **                                                                                      CSC022
      *
      ** Reset Update Status of Previous Transaction flag and
      ** Payment Reference Assigned to Previous Insert variable.
      *
     C                   EVAL      PERRUP = *BLANK
     C                   EVAL      PPREFI = *BLANKS
      *
      ** If error occurred, set on external job switch U6.
      *
     C                   IF        PERRMS <> *Blanks
     C                   MOVE      *On           *INU6
     C                   ENDIF
      *
      ** Terminate program if F3 was taken in Browse screen or
      ** if error occurred.  Otherwise, read selected Browse
      ** Subfile record.
      *
     C                   IF        PINKC = '1' or
     C                             PERRMS <> *Blanks
     C                   EXSR      SREndP
     C                   ELSE
     C                   EVAL      PRDNB = 'Y'
     C                   EVAL      WSCRN = 'R'
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRDNBRW - Read Next Browse Subfile Record                   *
      *                                                               *
      *****************************************************************
      *
     C     SRRdNBrw      BEGSR
      *
      ** Read Next Browse Subfile record.
      *
     C                   CALLB     'FTIPAYRPB'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Build Subfile
     C                   PARM      *BLANK        PBDSFL
      *
      ** Read Subfile Record
     C                   PARM      'Y'           PRDSFL
      *
      ** Update Status of Previous Transaction
     C                   PARM                    PERRUP
      *
      ** Payment Reference Assigned to Previous Insert
     C                   PARM                    PPREFI
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
     C                   PARM                    PERRMS
      *
      ** Option Selected
     C                   PARM                    POPSEL
      *
      ** Action Selected
     C                   PARM                    PACSEL
      *
      ** Payment Reference Selected
     C                   PARM                    PPREFSEL
      *
      ** Front Office Transaction Id Selected
     C                   PARM                    PFOTRANSEL
      *
      ** Timestamp of Transaction Selected
     C                   PARM                    PTMESTPSEL
      *
      ** Function Key Enabled - F3
     C                   PARM                    PINKC
     C                   PARM                    CSC011                                       CSC011
      ** CSC022 Enhancement is installed                                                      CSC022
      **                                                                                      CSC022
     C                   PARM                    CSC022                                       CSC022
      **                                                                                      CSC022
      *
      ** Terminate program if F3 was taken within Invalid
      ** Transaction Deletion function.
      *
     C                   IF        PINKC = '1'
     C                   EXSR      SREndP
     C                   GOTO      ERdNBrw
     C                   ENDIF
      *
      ** Display Browse screen if no Invalid Incoming
      ** Payment read from subfile.
      *
     C                   IF        POPSEL = *BLANK
     C                   EVAL      WSCRN = 'B'
     C                   GOTO      ERdNBrw
     C                   ENDIF
      *
      ** Clear Incoming Payment details in screen format from
      ** incoming transaction.
      *
     C                   CLEAR                   NwIP1ScnFmt
     C                   CLEAR                   NwIP1aScnFmt                   CFT014
     C                   CLEAR                   NwIP2ScnFmt
     C                   CLEAR                   NwIP3ScnFmt
     C                   CLEAR                   NwIP4ScnFmt
     C                   CLEAR                   NwIP4aScnFmt                   CFT014
     C                   CLEAR                   NwIP5ScnFmt                    CFT014
     C                   CLEAR                   NwIP6ScnFmt                    CFT014
     C                   CLEAR                   NwIP6AScnFmt                                 CER030
      *
      ** Clear Incoming Payment details in screen format
      ** retrieved from file.
      *
     C                   CLEAR                   CrIP1ScnFmt
     C                   CLEAR                   CrIP1aScnFmt                   CFT014
     C                   CLEAR                   CrIP2ScnFmt
     C                   CLEAR                   CrIP3ScnFmt
     C                   CLEAR                   CrIP4ScnFmt
     C                   CLEAR                   CrIP4aScnFmt                   CFT014
     C                   CLEAR                   CrIP5ScnFmt                    CFT014
     C                   CLEAR                   CrIP6ScnFmt                    CFT014
     C                   CLEAR                   CrIP6AScnFmt                                 CER030
      *
      ** Initialise other screen fields.
      *
     C                   MOVE      *BLANKS       DDSWTN
     C                   MOVE      *BLANKS       DDSEQNO
     C                   MOVE      *BLANKS       PStatus
     C                   MOVE      'IN'          PPYTP
      *
      ** Initialise work variables.
      *
     C                   MOVE      *BLANK        WSnd_L2S1         1
     C                   MOVE      *BLANK        WSnd_L2S2         1
     C                   MOVE      *BLANK        WSnd_L2S3         1            CFT014
     C                   MOVE      *BLANK        WSnd_Marg         1            CFT014
      *
      ** Validate Action Code and Payment Reference and retrieve
      ** Incoming Payments details.
      *
     C                   EVAL      DDACTN = PACSEL
     C                   EVAL      DDPREF = PPREFSEL
     C                   EVAL      FOTRID = PFOTRANSEL
      *
      ** If Insert, set Retrieve Mode to '*FRONT' (Access using Front Office
      ** Id).  Otherwise, if not Insert and Midas Payment Reference is present,
      ** set Retrieve Mode to blank (Access using Midas Payment Reference).
      *
     C     DDACTN        IFEQ      'I'
      *
     C                   MOVEL     '*FRONT'      PMode
      *
     C                   ELSE
      *
     C     DDPREF        IFEQ      *BLANK
     C                   MOVEL     '*FRONT'      PMode
     C                   ELSE
     C                   MOVEL     *BLANKS       PMode
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   EXSR      SRRtvPRef
      *
      ** For the rest of the processing, set Mode of Operation
      ** to '*RPR  ' for the other modules to process the
      ** transaction as coming from the repair function.
      *
     C                   EVAL      PMode = '*RPR  '
      *
      ** Move Incoming Payment details retrieved from the master
      ** database file into the update file record.  If no
      ** record has been retrieved (like in Insert), fields
      ** contain initial values.
      *
     C                   MOVEL     CrIPFilFmt    NwIPFilFmt
     C                   IF        CFT003 = 'Y' or CFT014 = 'Y'                              BUG7101
     C                             OR CFT009 = 'Y'                                           BUG7101
     C                   MOVEL     CrIP2FilFmt   NwIP2FilFmt                    CFT014
     C                   ELSE                                                                BUG7101
     C                   CLEAR                   NwIP2FilFmt                                 BUG7101
     C                   END                                                                 BUG7101
      *                                                                                       187056
      ** Initialise work fields for 'Charges to the Debit of a/c'.                            187056
      *                                                                                       187056
     C                   EVAL      PPrvCDRO = *BLANKS                                         187056
     C                   EVAL      PPrvCDBR = *BLANKS                                         187056
     C                   EVAL      PPrvCDRT = *BLANKS                                         187056
      *                                                                                       CER030
      ** Initialize Flag for defaulting in retail transaction type                            CER030
      *                                                                                       CER030
     C                   EVAL      WFlg = 'N'                                                 CER030
      *
      ** If original Incoming Payment details were retrieved,
      ** convert Incoming Payment details from file to screen
      ** format.
      *
     C                   IF        DDACTN <> 'I' and
     C                             RECI <> *BLANK
      *
     C                   EXSR      SRCvtPRef
      *
      ** Save Payment Reference retrieved from file.
      *
     C                   MOVEL     DDPREF        WDDPREF          15
      *                                                                                       187056
      ** Save previous value of 'Charges to the Debit of a/c'.                                187056
      *                                                                                       187056
     C                   EVAL      PPrvCDRO = ODDCDRO                                         187056
     C                   EVAL      PPrvCDBR = ODDCDBR                                         187056
     C                   EVAL      PPrvCDRT = CDRT                                            187056
      *                                                                         CFT009
      ** If CFT009 is on , save formatted charges                               CFT009
      *                                                                         CFT009
     C                   IF        CFT009 = 'Y'                                 CFT009
     C                   MOVEL     PCHARGES      WICHARGES                      CFT009
     C                   ENDIF                                                  CFT009
      *
     C                   ENDIF                                                  CFT009
      *
      ** Access Invalid Incoming Payments file with Timestamp and
      ** Front Office Transaction Id.
      *
     C     ZATRNKX0      CHAIN     FTIIPAYL0                          99
      *
      ** If original Incoming Payment details were retrieved,
      ** restore the Payment Reference retrieved from file.
      *
     C                   IF        DDACTN <> 'I' and
     C                             RECI <> *BLANK
     C                   EVAL      DDPREF = WDDPREF
     C                   ENDIF
      *
      ** If Action is Enquire or Delete, overwrite details from
      ** Invalid Incoming Payments file with the details retrieved
      ** from the master database file.
      *
     C                   IF        DDACTN = 'E' and RECI <> *BLANK or
     C                             DDACTN = 'D' and RECI <> *BLANK
     C                   MOVE      CrIP1ScnFmt   NwIP1ScnFmt
     C                   MOVE      CrIP1aScnFmt  NwIP1aScnFmt                   CFT014
     C                   MOVE      CrIP2ScnFmt   NwIP2ScnFmt
     C                   MOVE      CrIP3ScnFmt   NwIP3ScnFmt
     C                   MOVE      CrIP4ScnFmt   NwIP4ScnFmt
     C                   MOVE      CrIP4aScnFmt  NwIP4aScnFmt                   CFT014
     C                   MOVE      CrIP5ScnFmt   NwIP5ScnFmt                    CFT014
     C                   MOVE      CrIP6ScnFmt   NwIP6ScnFmt                    CFT014
     C                   MOVEL     CrIP7ScnFmt   NwIP7ScnFmt                                  CSW209
     C                   MOVEL     CrIP8ScnFmt   NwIP8ScnFmt                                  CSW209
     C                   MOVE      CrIP6AScnFmt  NwIP6AScnFmt                                 CER030
     C                   ENDIF
      *                                                                                       CER001
      ** Now overwrite the fields on the main details screen with those                       CER001
      ** on the invalid extended deals file                                                   CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y'                                               CER001
     C     ZATRNKX0      CHAIN     RTVIDX1                                                    CER001
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
      *
      ** Action is Amend and Original Incoming Payment details
      ** were retrieved.
      *
     C                   IF        DDACTN = 'A' and RECI <> *BLANK
      *
      ** Check for the existence of the replacement character; if this is
      ** used, only the changed data has been sent, and all occurrences of
      ** the replacement character must be replaced with the corresponding
      ** character from the original transaction.
      *
     C                   IF        GHSUBS <> *BLANK
      *
     C     GHSUBS        SCAN      NwIP1ScnFmt                            99
     C                   IF        *In99 = *On
     C                   MOVE      'Y'           WSUBIP1           1
     C                   ELSE
     C                   MOVE      'N'           WSUBIP1
     C                   ENDIF
      *                                                                         CFT014
     C     GHSUBS        SCAN      NwIP1aScnFmt                           99    CFT014
      *                                                                         CFT014
     C                   IF        *IN99                                        CFT014
     C                   MOVE      'Y'           WSubIP1a          1            CFT014
     C                   ELSE                                                   CFT014
     C                   MOVE      'N'           WSubIP1a                       CFT014
     C                   ENDIF                                                  CFT014
      *
     C     GHSUBS        SCAN      NwIP2ScnFmt                            99
     C                   IF        *In99 = *On
     C                   MOVE      'Y'           WSUBIP2           1
     C                   ELSE
     C                   MOVE      'N'           WSUBIP2
     C                   ENDIF
      *
     C     GHSUBS        SCAN      NwIP3ScnFmt                            99
     C                   IF        *In99 = *On
     C                   MOVE      'Y'           WSUBIP3           1
     C                   ELSE
     C                   MOVE      'N'           WSUBIP3
     C                   ENDIF
      *
     C     GHSUBS        SCAN      NwIP4ScnFmt                            99
     C                   IF        *In99 = *On
     C                   MOVE      'Y'           WSUBIP4           1
     C                   ELSE
     C                   MOVE      'N'           WSUBIP4
     C                   ENDIF
      *                                                                         CFT014
     C     GHSUBS        SCAN      NwIP4aScnFmt                           99    CFT014
      *                                                                         CFT014
     C                   IF        *IN99                                        CFT014
     C                   MOVE      'Y'           WSubIP4a          1            CFT014
     C                   ELSE                                                   CFT014
     C                   MOVE      'N'           WSubIP4a                       CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C     GHSUBS        SCAN      NwIP5ScnFmt                            99    CFT014
      *                                                                         CFT014
     C                   IF        *IN99                                        CFT014
     C                   MOVE      'Y'           WSubIP5           1            CFT014
     C                   ELSE                                                   CFT014
     C                   MOVE      'N'           WSubIP5                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C     GHSUBS        SCAN      NwIP6ScnFmt                            99    CFT014
      *                                                                         CFT014
     C                   IF        *IN99                                        CFT014
     C                   MOVE      'Y'           WSubIP6           1            CFT014
     C                   ELSE                                                   CFT014
     C                   MOVE      'N'           WSubIP6                        CFT014
     C                   ENDIF                                                  CFT014
      *
     C     GHSUBS        SCAN      NwIP6AScnFmt                           99                  CER059
      *                                                                                       CER059
     C                   IF        *IN99                                                      CER059
     C                   MOVE      'Y'           WSubIP6a          1                          CER059
     C                   ELSE                                                                 CER059
     C                   MOVE      'N'           WSubIP6a                                     CER059
     C                   ENDIF                                                                CER059
      *                                                                                       CER059
      ** Substitution character is present in the incoming
      ** transaction.
      *
     C                   IF        WSUBIP1 = 'Y' or
     C                             WSUBIP2 = 'Y' or
     C                             WSUBIP3 = 'Y' or
     C                             WSUBIP1a = 'Y' or                            CFT014
     C                             WSUBIP4a = 'Y' or                            CFT014
     C                             WSUBIP5 = 'Y' or                             CFT014
     C                             WSUBIP6 = 'Y' or                             CFT014
     C**********                   WSUBIP4 = 'Y'                                              CER059
     C                             WSUBIP4 = 'Y' or                                           CER059
     C                             WSUBIP6a= 'Y'                                              CER059
      *
      ** Do data substitution.
      *
     C                   EXSR      SRDtaSubs
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** If errors exist for Action Code or Payment Reference,
      ** blank out Action Code so input cannot proceed.
      *
     C                   IF        OKACTN = 'N' or OKPREF = 'N'
     C                   EVAL      DDACTN = *BLANK
     C                   ENDIF
      *
      ** Save screen details.
      *
     C                   MOVE      NwIP1ScnFmt   NwIP1ScnFmx
     C                   MOVE      NwIP1aScnFmt  NwIP1aScnFmx                   CFT014
     C                   MOVE      NwIP2ScnFmt   NwIP2ScnFmx
     C                   MOVE      NwIP3ScnFmt   NwIP3ScnFmx
     C                   MOVE      NwIP4ScnFmt   NwIP4ScnFmx
     C                   MOVE      NwIP4aScnFmt  NwIP4aScnFmx                   CFT014
     C                   MOVE      NwIP5ScnFmt   NwIP5ScnFmx                    CFT014
     C                   MOVE      NwIP6ScnFmt   NwIP6ScnFmx                    CFT014
     C                   MOVE      NwIP7ScnFmt   NwIP7ScnFmx                                  CSW209
     C                   MOVE      NwIP8ScnFmt   NwIP8ScnFmx                                  CSW209
     C                   MOVE      NwIP6AScnFmt  NwIP6AScnFmx                                 CER030
      *
      ** Send the Incoming Payments validation error messages
      ** to Level 1 screen.
      *
     C                   EXSR      SRSndM_L1
      *
      ** Display Level 1 screen.
      *
     C                   EVAL      WSCRN = 'P'
      *
     C     ERdNBrw       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSCRN_P - Process Level 1 Screen                            *
      *                                                               *
      *****************************************************************
      *
     C     SRScrn_P      BEGSR
      *
      ** If Action Code is Insert or Amend and Option selected is 'U',
      ** enable Detail fields on Level 1 screen (all fields on Level 1
      ** screen except Initial screen fields: Action Code, Payment
      ** Reference and Booking Branch). Also, enable F5=Refresh.
      *
     C                   IF        DDACTN = 'I' and POPSEL = 'U' or
     C                             DDACTN = 'A' and POPSEL = 'U'
     C                   EVAL      PEDTFLD = 'Y'
     C                   EVAL      PEINKE = 'Y'
     C                   ELSE
     C                   EVAL      PEDTFLD = 'N'
     C                   EVAL      PEINKE = 'N'
     C                   ENDIF
      *
      ** If Action is Delete and Option selected is 'U',
      ** enable F10=Delete.
      *
     C                   IF        DDACTN = 'D' and POPSEL = 'U'
     C                   EVAL      PEINKJ = 'Y'
     C                   ELSE
     C                   EVAL      PEINKJ = 'N'
     C                   ENDIF
      *
      ** If Action is Enquire, enable F21=Additional Information.
      *
     C                   IF        DDACTN = 'E'
     C                   EVAL      PEINKV = 'Y'
     C                   ELSE
     C                   EVAL      PEINKV = 'N'
     C                   ENDIF
      *
      ** If feature CFT007 is switched on and action is insert or amend,
      ** enable F4=prompt and F16=search
      *
     C                   IF        CFT007 = 'Y' AND
     C                             (DDACTN = 'I' OR DDACTN = 'A') AND
     C                             POPSEL = 'U'
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
     C                   PARM                    DDSWTN           28
      *
      ** Sequence No.
     C                   PARM                    DDSEQNO           2
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
     C                   PARM      'N'           PEINKG            1
     C                   PARM      'N'           PEINKH            1
     C                   PARM                    PEINKJ            1
     C                   PARM      'N'           PEINKP            1
     C                   PARM                    PEINKQ            1
     C                   PARM      'N'           PEINKS            1
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
     C/COPY WNCPYSRC,FTIPAYRC20
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
     C/COPY WNCPYSRC,FTIPAYRC04
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
     C                   WHEN      PINKC = '1'
     C                   EXSR      SREndP
      *
      ** F4 or F16 - BIC processing
      *
     C                   WHEN      PINKD = '1'  OR PINKQ = '1'
     C                   EXSR      SRBIC1
      *
      ** F5 - refresh Level 1 screen.
      *
     C                   WHEN      PINKE = '1'
     C                   MOVE      NwIP1ScnFmx   NwIP1ScnFmt
     C                   MOVE      FTEIPY1x      FTEIPY1
     C                   MOVE      FldNameAr1    FldNameArr
     C                   MOVE      MsgIdAr1      MsgIdArr
     C                   MOVE      MsgDtaAr1     MsgDtaArr
     C                   MOVE      ID1           IDx
      *
      ** F10 - delete record.  Proceed to update of files.
      *
     C                   WHEN      PINKJ = '1'
     C                   EVAL      WSCRN = 'U'
      *
      ** F12 - cancel.  Read Next Subfile record or display
      ** Browse screen.
      *
     C                   WHEN      PINKL = '1'
     C                   IF        PRDNB = 'Y'
     C                   EVAL      WSCRN = 'R'
     C                   ELSE
     C                   EVAL      WSCRN = 'B'
     C                   ENDIF
      *
      ** If Windows processing is on, clear any possible updates
      ** in Window function.
      *
     C                   IF        BGWDPR = 'Y'
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
      ** F21 - display Additional Information Window.
      *
     C                   WHEN      PINKV = '1'
     C                   EVAL      WSCRN = 'A'
      *
      ** Enter key was pressed.
      *
     C                   OTHER
      *
      ** If Action is Insert or Amend and Option selected is 'U',
      ** validate input to Level 1 screen.
      *
     C                   IF        DDACTN = 'I' and POPSEL = 'U' or
     C                             DDACTN = 'A' and POPSEL = 'U'
     C                   EXSR      SRVAL_P
     C                   GOTO      EScrn_P
     C                   ENDIF
      *
      ** If errors exist on Level 1 screen, no need to display
      ** succeeding screens.  Read Next Subfile record or
      ** display Browse screen instead.
      *
     C                   IF        ID1 > 1 or ID1 = 1 and
     C                             MsgIdAr1(1) <> 'FTA0120' and
     C                             MsgIdAr1(1) <> 'FTA0121'
     C                   IF        PRDNB = 'Y'
     C                   EVAL      WSCRN = 'R'
     C                   ELSE
     C                   EVAL      WSCRN = 'B'
     C                   ENDIF
     C                   GOTO      EScrn_P
     C                   ENDIF
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
     C                   IF        BGWDPR = 'Y'
      *
     C                   EVAL      WSCRN = 'W'
      *
     C                   ELSE
      *
      ** If this has not been done yet, send Incoming Payments
      ** validation error messages to Level 2 screen 1.
      *
     C                   IF        WSnd_L2S1 <> 'Y'
     C                   EXSR      SRSndM_L2S1
     C                   EVAL      WSnd_L2S1 = 'Y'
     C                   ELSE
     C                   MOVE      FTEIPY2x      FTEIPY2
     C                   MOVEA     FldNameAr2    FldNameArr
     C                   MOVEA     MsgIdAr2      MsgIdArr
     C                   MOVEA     MsgDtaAr2     MsgDtaArr
     C                   EVAL      IDx = ID2
     C                   ENDIF
      *
      ** Display Level 2 screen 1.
      *
     C                   EVAL      WSCRN = 'S'
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
      *  SRVAL_P - Validate Input to Level 1 Screen                   *
      *                                                               *
      *****************************************************************
      *
     C     SRVal_P       BEGSR
      *
      ** If Action is Amend, validate whether non-amendable fields
      ** have been amended.
      *
     C                   IF        DDACTN = 'A'
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
      ** Validate Branch Code.
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
     C                   PARM                    OKPREF            1
      *
      ** Linked Program
     C                   PARM                    PLinkPgm
      *
      ** Incoming Payments retrieved from file - file format
     C                   PARM                    CrIPFilFmt
      *
      ** Incoming Payments extra data
     C                   PARM                    PExtData
     C/COPY WNCPYSRC,FTH00361
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
     C                   PARM                    OKSWTN            1
      *
      ** OK Sequence No.
     C                   PARM                    OKSEQNO           1
      *
      ** OK Booking Branch
     C                   PARM                    OKBRCA
      *
      ** Incoming Payments for file update - file format
     C                   PARM                    NwIPFilFmt
     C*                                                                         CFT014
     C                   Z-add     BTPCRD        WBTPCRD           5 2          CFT014
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
     C                   PARM                    NWIP5SCNFMT                    CFT009
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
     C                   PARM                    WBTPCRD                        CFT014
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
      ** STP Phase 2 MT103                                                      CFT014
     C                   PARM                    CFT014                         CFT014
     C/COPY WNCPYSRC,FTIPAYRC21
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
     C/COPY WNCPYSRC,FTIPAYRC05
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
     C                   PARM                    PPYBR             3
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
     C                   PARM                    PSetInCy          1
      *
      ** Settlement EMU Transaction Period Start Date
     C                   PARM                    PSetTPSD          5 0
      *
      ** Payment In Currency Indicator
     C                   PARM                    PPayInCy          1
      *
      ** Payment EMU Transaction Period Start Date
     C                   PARM                    PPayTPSD          5 0
     C/COPY WNCPYSRC,FTIPAYRC22
      *                                                                         CFT009
      ** DS for Default Charge Amounts                                          CFT009
     C                   PARM                    PCHARGES                       CFT009
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
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
     C                   PARM                    BENEDrBlck        1                        MD025111
     C                   PARM                    BENEDrRefd        1                       MD047369A
     C/COPY WNCPYSRC,FTIPAYRC11
      *                                                                                       250600
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
      ** Redisplay Level 1 screen if there are errors or if there
      ** are warnings which have not been displayed yet.
      *
     C                   IF        IDx <> 0 or
     C                             WRedisplay = 'Y'
     C                   GOTO      EVal_P
     C                   ENDIF
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
      ** charges                                                                CFT009
      *                                                                         CFT009
     C                   IF        CFT009 = 'Y' AND DDACTN = 'I'                CFT009
     C                   MOVEL     PCHARGES      WICHARGES                      CFT009
     C                   ENDIF                                                  CFT009
      *
      ** If Windows processing is on, display Window screen.
      *
     C                   IF        BGWDPR = 'Y'
      *
     C                   EVAL      WSCRN = 'W'
      *
     C                   ELSE
      *
      ** If this has not been done yet, send Incoming Payments
      ** validation error messages to Level 2 screen 1.
      *
     C                   IF        WSnd_L2S1 <> 'Y'
     C                   EXSR      SRSndM_L2S1
     C                   EVAL      WSnd_L2S1 = 'Y'
     C                   ELSE
     C                   MOVE      FTEIPY2x      FTEIPY2
     C                   MOVEA     FldNameAr2    FldNameArr
     C                   MOVEA     MsgIdAr2      MsgIdArr
     C                   MOVEA     MsgDtaAr2     MsgDtaArr
     C                   EVAL      IDx = ID2
     C                   ENDIF
      *
      ** Display Level 2 screen 1.
      *
     C                   EVAL      WSCRN = 'S'
      *
     C                   ENDIF
      *
     C     EVal_P        ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSCRN_S - Process Level 2 Screen 1                          *
      *                                                               *
      *****************************************************************
      *
     C     SRScrn_S      BEGSR
      *
      ** If Action Code is Insert or Amend and Option selected is 'U',
      ** enable Detail fields on Level 2 screen 1 (all fields on
      ** Level 2 screen 1 except Action Code and Payment Reference).
      ** Also, enable F5=Refresh.
      *
     C                   IF        DDACTN = 'I' and POPSEL = 'U' or
     C                             DDACTN = 'A' and POPSEL = 'U'
     C                   EVAL      PEDTFLD = 'Y'
     C                   EVAL      PEINKE = 'Y'
     C                   ELSE
     C                   EVAL      PEDTFLD = 'N'
     C                   EVAL      PEINKE = 'N'
     C                   ENDIF
      *
      ** If feature CFT007 is switched on and action is insert or amend,
      ** enable F4=prompt and F16=search
      *
     C                   IF        CFT007 = 'Y' AND
     C                             (DDACTN = 'I' OR DDACTN = 'A') AND
     C                             POPSEL = 'U'
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
     C                   PARM      'N'           PEINKG
     C                   PARM      'N'           PEINKH
     C                   PARM      'N'           PEINKP
     C                   PARM                    PEINKQ
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
      ** Save Warning Message Ids array of Level 2 screen 1.
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
     C                   WHEN      PINKC = '1'
     C                   EXSR      SREndP
      *
      ** F4 or F16 - BIC processing
      *
     C                   WHEN      PINKD = '1'  OR PINKQ = '1'
     C                   EXSR      SRBIC2
      *
      ** F5 - refresh Level 2 screen 1.
      *
     C                   WHEN      PINKE = '1'
     C                   MOVE      NwIP2ScnFmx   NwIP2ScnFmt
     C                   MOVE      NwIP3ScnFmx   NwIP3ScnFmt
     C                   MOVE      FTEIPY2x      FTEIPY2
     C                   MOVE      FldNameAr2    FldNameArr
     C                   MOVE      MsgIdAr2      MsgIdArr
     C                   MOVE      MsgDtaAr2     MsgDtaArr
     C                   MOVE      ID2           IDx
      *
      ** F12 - cancel.  Display Level 1 screen.
      *
     C                   WHEN      PINKL = '1'
     C                   MOVE      NwIP2ScnFmx   NwIP2ScnFmt
     C                   MOVE      NwIP3ScnFmx   NwIP3ScnFmt
     C                   EVAL      WSCRN = 'P'
      *
      ** Enter key was pressed.
      *
     C                   OTHER
      *
      ** If Action is Insert or Amend and Option selected is 'U',
      ** validate input to Level 2 screen 1.
      *
     C                   IF        DDACTN = 'I' and POPSEL = 'U' or
     C                             DDACTN = 'A' and POPSEL = 'U'
     C                   EXSR      SRVAL_S
     C                   GOTO      EScrn_S
     C                   ENDIF
      *
      ** If errors exist on Level 2 screen 1, no need to display
      ** Level 2 screen 2.
      *
     C                   IF        ID2 > 0
     C                   IF        PRDNB = 'Y'
     C                   EVAL      WSCRN = 'R'
     C                   ELSE
     C                   EVAL      WSCRN = 'B'
     C                   ENDIF
     C                   GOTO      EScrn_S
     C                   ENDIF
      ***********                                                               CFT014
      ***Compute*Charges*and*Commissions,*and*Total*VAT*Amounts*based*on        CFT014
      ***Level*1*details.**********************************************         CFT014
      ***********                                                               CFT014
     C***********        EXSR      SRCCVatL1                                    CFT014
      ***********                                                               CFT014
      ***Do*defaulting*of*Charges*and*Commission*details*on*Level*2****         CFT014
      ***screen*2.*****************************************************         CFT014
     C***********        EXSR      SRCDefault                                   CFT014
      *
      ** If this has not been done yet, send Incoming Payments
      ** validation error messages to Level 2 screen 2.
      *
     C                   IF        WSnd_L2S2 <> 'Y'
     C                   EXSR      SRSndM_L2S2
     C                   EVAL      WSnd_L2S2 = 'Y'
     C                   ELSE
     C                   MOVE      FTEIPY3x      FTEIPY3
     C                   MOVEA     FldNameAr3    FldNameArr
     C                   MOVEA     MsgIdAr3      MsgIdArr
     C                   MOVEA     MsgDtaAr3     MsgDtaArr
     C                   EVAL      IDx = ID3
     C                   ENDIF
      *
      ** Display Level 2 screen 2.
      *
     C                   EVAL      WSCRN = 'C'
      *
     C                   ENDSL
      *
     C     EScrn_S       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVAL_S - Validate Input to Level 2 Screen 1                 *
      *                                                               *
      *****************************************************************
      *
     C     SRVal_S       BEGSR
      *
      ** Validate Detail fields on Level 2 screen 1.
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
     C                   PARM                    PPYBR
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
     C                   PARM                    PNWRK             6                          250600
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
     C                   ENDIF                                                  CFT009
      *
      ** If this has not been done yet, send Incoming Payments
      ** validation error messages to Level 2 screen 2.
      *
     C                   IF        WSnd_L2S2 <> 'Y'
     C                   EXSR      SRSndM_L2S2
     C                   EVAL      WSnd_L2S2 = 'Y'
     C                   ELSE
     C                   MOVE      FTEIPY3x      FTEIPY3
     C                   MOVEA     FldNameAr3    FldNameArr
     C                   MOVEA     MsgIdAr3      MsgIdArr
     C                   MOVEA     MsgDtaAr3     MsgDtaArr
     C                   EVAL      IDx = ID3
     C                   ENDIF
      *
      ** Display Level 2 screen 2.
      *
     C                   EVAL      WSCRN = 'C'
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
      ***********                                                               CFT014
      ***Incoming*Payments*Lvl*2*Scrn*2*details*from*incoming*transaction       CFT014
      ***-*screen*format***********************************************         CFT014
     C***********        PARM                    NwIP4ScnFmt                    CFT014
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
     C                   PARM                    PPrvCDRC                                     CFT120
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
      ** Save default Charge Amounts.
      *
     C****************** MOVEL     PCharges      WICharges       108            CFT009
     C                   MOVEL     PCharges      WICharges       196            CFT009
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSCRN_C - Process Level 2 Screen 2                          *
      *                                                               *
      *****************************************************************
      *
     C     SRScrn_C      BEGSR
      *
      ** If Action Code is Insert or Amend and Option selected is 'U',
      ** enable Detail fields on Level 2 screen 2 (all fields on
      ** Level 2 screen 2 except Action Code and Payment Reference).
      ** Also, enable F5=Refresh.
      *
     C                   IF        DDACTN = 'I' and POPSEL = 'U' or
     C                             DDACTN = 'A' and POPSEL = 'U'
     C                   EVAL      PEDTFLD = 'Y'
     C                   EVAL      PEINKE = 'Y'
     C                   ELSE
     C                   EVAL      PEDTFLD = 'N'
     C                   EVAL      PEINKE = 'N'
     C                   ENDIF
      *
      ** If feature CFT007 is switched on and action is insert or amend,
      ** enable F4=prompt and F16=search
      *
     C                   IF        CFT007 = 'Y' AND
     C                             (DDACTN = 'I' OR DDACTN = 'A') AND
     C                             POPSEL = 'U'
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
      ** Incoming Payments Lvl 2 Scrn 2/2 details from incoming transaction     CFT014
      ** - screen format                                                        CFT014
     C                   PARM                    NwIP4aScnFmt                   CFT014
      ***********                                                               CFT014
      ***DS*for*default*Charge*Amounts*********************************         CFT014
     C***********        PARM                    PCharges                       CFT014
      ***********                                                               CFT014
      ***DS*for*default*Charge*Currencies******************************         CFT014
     C***********        PARM                    PChgCcy                        CFT014
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
     C                   PARM      'N'           PEINKG
     C                   PARM      'N'           PEINKH
     C                   PARM      'N'           PEINKP
     C                   PARM                    PEINKQ
     C                   PARM      'N'           PEINKS
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
     C                   MOVEA     WMsgIDArr     WPrvWarnAr
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr
     C                   SELECT
      *
      ** F3 - end program.
      *
     C                   WHEN      PINKC = '1'
     C                   EXSR      SREndP
      *
      ** F4 or F16 - BIC processing
      *
     C                   WHEN      PINKD = '1'  OR PINKQ = '1'
     C                   EXSR      SRBIC2
      *
      ** F5 - refresh Level 2 screen 2.
      *
     C                   WHEN      PINKE = '1'
     C                   MOVE      NwIP4ScnFmx   NwIP4ScnFmt
     C                   MOVE      NwIP4aScnFmx  NwIP4aScnFmt                   CFT014
     C***********        MOVE      WICharges     PCharges                       CFT014
     C                   MOVE      FTEIPY3x      FTEIPY3
     C                   MOVE      FldNameAr3    FldNameArr
     C                   MOVE      MsgIdAr3      MsgIdArr
     C                   MOVE      MsgDtaAr3     MsgDtaArr
     C                   MOVE      ID3           IDx
      *
      ** F12 - cancel.  Display Level 2 screen 1.
      *
     C                   WHEN      PINKL = '1'
     C                   MOVE      NwIP4ScnFmx   NwIP4ScnFmt
     C                   MOVE      NwIP4aScnFmx  NwIP4aScnFmt                   CFT014
     C                   EVAL      WSCRN = 'S'
      *
      ** Enter key was pressed.
      *
     C                   OTHER
      *
      ** If Action is Insert or Amend and Option selected is 'U',
      ** validate input to Level 2 screen 2.
      *
     C                   IF        DDACTN = 'I' and POPSEL = 'U' or
     C                             DDACTN = 'A' and POPSEL = 'U'
     C                   EXSR      SRVAL_C
     C                   GOTO      EScrn_C
     C                   ENDIF
      *                                                                         CFT014
      ** If errors exist on Level 2 screen 2, no need to display                CFT014
      ** Level 2 screen 3.                                                      CFT014
      *                                                                         CFT014
     C                   IF        ID3 > 0                                      CFT014
      *
      ** Read Next Subfile record or display Browse screen.
      *
     C                   IF        PRDNB = 'Y'
     C                   EVAL      WSCRN = 'R'
     C                   ELSE
     C                   EVAL      WSCRN = 'B'
     C                   ENDIF
      *                                                                         CFT014
     C                   GOTO      EScrn_C                                      CFT014
     C                   ENDIF                                                  CFT014
 
     C**********         IF        CFT009 = 'N'                                       CFT009 BUG9311
      **********                                                                      CFT014 BUG9311
      ***Compute*Charges*and*Commissions,*and*Total*VAT*Amounts*based*on              CFT014 BUG9311
      ***Level*1*details.**********************************************               CFT014 BUG9311
      **********                                                                      CFT014 BUG9311
     C**********         EXSR      SRCCVatL1                                          CFT014 BUG9311
      **********                                                                      CFT014 BUG9311
      ***Do*defaulting*of*Charges*and*Commission*details*on*Level*2****               CFT014 BUG9311
      ***screen*2.*****************************************************               CFT014 BUG9311
     C**********         EXSR      SRCDefault                                         CFT014 BUG9311
     C**********         ENDIF                                                        CFT009 BUG9311
      *                                                                         CFT014
      ** If this has not been done yet, send Incoming Payments                  CFT014
      ** validation error messages to Level 2 screen 3.                         CFT014
      *                                                                         CFT014
     C                   IF        WSnd_L2S3 <> 'Y'                             CFT014
     C                   EXSR      SRSndM_L2S3                                  CFT014
     C                   EVAL      WSnd_L2S3 = 'Y'                              CFT014
     C                   ELSE                                                   CFT014
     C                   MOVE      FTEIPY4x      FTEIPY4                        CFT014
     C                   MOVEA     FldNameAr4    FldNameArr                     CFT014
     C                   MOVEA     MsgIdAr4      MsgIdArr                       CFT014
     C                   MOVEA     MsgDtaAr4     MsgDtaArr                      CFT014
     C                   EVAL      IDx = ID4                                    CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Display Level 2 screen 3.                                              CFT014
      *                                                                         CFT014
     C                   EVAL      WSCRN = 'D'                                  CFT014
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
      *  SRVAL_C - Validate Input to Level 2 Screen 2                 *
      *                                                               *
      *****************************************************************
      *
     C     SRVal_C       BEGSR
      *
      ** Validate Detail fields on Level 2 screen 2.
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
      ***********                                                               CFT014
      ***Incoming*Payments*Lvl*1*Scrn*details*from*incoming*transaction         CFT014
      ***-*screen*format***********************************************         CFT014
     C***********        PARM                    NwIP1ScnFmt                    CFT014
      *
      ** Incoming Payments Lvl 2 Scrn 2 details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP4ScnFmt
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 2/2 details from incoming transaction     CFT014
      ** - screen format                                                        CFT014
     C                   PARM                    NwIP4aScnFmt                   CFT014
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
     C                   PARM                    PPYBR                          CFT014
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
      ***DS*for*Default*Charge*Amounts*********************************         CFT014
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
      ** Redisplay Level 2 screen 2 if there are errors or if there
      ** are warnings which have not been displayed yet.
      *
     C                   IF        IDx <> 0 or
     C                             WRedisplay = 'Y'
     C                   GOTO      EVal_C
     C                   ENDIF
      ***********                                                               CFT014
      ***Display*Confirmation*screen.**********************************         CFT014
      ***********                                                               CFT014
     C***********        EVAL      WSCRN = 'F'                                  CFT014
 
     C                   IF        CFT009 = 'N'                                 CFT009
      *                                                                         CFT014
      ** Compute Charges and Commissions, and Total VAT Amounts based on        CFT014
      ** Level 1 details.                                                       CFT014
      *                                                                         CFT014
     C                   EXSR      SRCCVatL1                                    CFT014
      *                                                                         CFT014
      ** Do defaulting of Charges and Commission details on Level 2             CFT014
      ** screen 2.                                                              CFT014
     C                   EXSR      SRCDefault                                   CFT014
     C                   ENDIF                                                  CFT009
      *                                                                         CFT014
      ** If this has not been done yet, send Incoming Payments                  CFT014
      ** validation error messages to Level 2 screen 3.                         CFT014
      *                                                                         CFT014
     C                   IF        WSnd_L2S3 <> 'Y'                             CFT014
     C                   EXSR      SRSndM_L2S3                                  CFT014
     C                   EVAL      WSnd_L2S3 = 'Y'                              CFT014
     C                   ELSE                                                   CFT014
     C                   MOVE      FTEIPY4x      FTEIPY4                        CFT014
     C                   MOVEA     FldNameAr4    FldNameArr                     CFT014
     C                   MOVEA     MsgIdAr4      MsgIdArr                       CFT014
     C                   MOVEA     MsgDtaAr4     MsgDtaArr                      CFT014
     C                   EVAL      IDx = ID4                                    CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Display Level 2 screen 3.                                              CFT014
      *                                                                         CFT014
     C                   EVAL      WSCRN = 'D'                                  CFT014
      *                                                                         CFT014
      ** Reset work variables for 4th screen.                                   CFT014
      *                                                                         CFT014
     C                   IF        CFT014 = 'Y'                                 CFT014
     C                   EVAL      PPrvDDRCRM = *BLANKS                         CFT014
     C                   EVAL      PPrvTOTCHG = *Zero                           CFT014
     C                   ENDIF                                                  CFT014
      *
     C     EVal_C        ENDSR
      *
      *****************************************************************
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SRSCRN_D - Process Level 2 Screen 3                          *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
      *                                                                         CFT014
     C     SRScrn_D      BEGSR                                                  CFT014
      *                                                                         CFT014
      ** If Action Code is Insert or Amend and Option selected is 'U',          CFT014
      ** enable Detail fields on Level 2 screen 3 (all fields on                CFT014
      ** Level 2 screen 3 except Action Code and Payment Reference).            CFT014
      ** Also, enable F5=Refresh.                                               CFT014
      *                                                                         CFT014
     C                   IF        DDACTN = 'I' and POPSEL = 'U' or             CFT014
     C                             DDACTN = 'A' and POPSEL = 'U'                CFT014
     C                   EVAL      PEDTFLD = 'Y'                                CFT014
     C                   EVAL      PEINKE = 'Y'                                 CFT014
     C                   ELSE                                                   CFT014
     C                   EVAL      PEDTFLD = 'N'                                CFT014
     C                   EVAL      PEINKE = 'N'                                 CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Display Level 2 screen 3.                                              CFT014
      *                                                                         CFT014
     C                   CALLB     'FTIPAY4DP'                                  CFT014
      *                             =========                                   CFT014
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
      ** KT = Command Key 19 = Display Margin Info scrn                         CFT014
     C                   PARM                    PEINKE                         CFT014
     C                   PARM      'N'           PEINKG                         CFT014
     C                   PARM      'N'           PEINKH                         CFT014
     C                   PARM      'N'           PEINKP                         CFT014
     C                   PARM      'N'           PEINKS                         CFT014
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
     C/COPY WNCPYSRC,FTIPAYRC23
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
      ** KT = Command Key 19 = Display Margin Info scrn                         CFT014
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
      *                                                                         CFT014
      ** Save Warning Message Ids array of Level 2 screen 3.                    CFT014
      *                                                                         CFT014
     C                   MOVEA     WMsgIDArr     WPrvWarnAr                     CFT014
      *                                                                         CFT014
      ** Reset error fields.                                                    CFT014
      *                                                                         CFT014
     C                   EXSR      SRResetErr                                   CFT014
     C                   SELECT                                                 CFT014
      *                                                                         CFT014
      ** F3 - end program.                                                      CFT014
      *                                                                         CFT014
     C                   WHEN      PINKC = '1'                                  CFT014
     C                   EXSR      SREndP                                       CFT014
      *                                                                         CFT014
      ** F5 - refresh Level 2 screen 3.                                         CFT014
      *                                                                         CFT014
     C                   WHEN      PINKE = '1'                                  CFT014
     C                   MOVE      NwIP5ScnFmx   NwIP5ScnFmt                    CFT014
     C                   MOVE      WICharges     PCharges                       CFT014
     C                   MOVE      FTEIPY4x      FTEIPY4                        CFT014
     C                   MOVE      FldNameAr4    FldNameArr                     CFT014
     C                   MOVE      MsgIdAr4      MsgIdArr                       CFT014
     C                   MOVE      MsgDtaAr4     MsgDtaArr                      CFT014
     C                   MOVE      ID4           IDx                            CFT014
      *                                                                         CFT014
      ** F12 - cancel.  Display Level 2 screen 2.                               CFT014
      *                                                                         CFT014
     C                   WHEN      PINKL = '1'                                  CFT014
     C                   MOVE      NwIP5ScnFmx   NwIP5ScnFmt                    CFT014
     C                   EVAL      WSCRN = 'C'                                  CFT014
      *                                                                         CFT014
      ** F19 - Display Margin Info screen.                                      CFT014
      *                                                                         CFT014
     C                   WHEN      PINKT = '1'                                  CFT014
      *                                                                                       CER030
      ** F19 - Margin Information /Extended Narratives                                        CER030
      *                                                                                       CER030
     C                   IF        (CER030 = 'Y') OR                                          CER030
     C                             (CER031 = 'Y') OR                                          CER030
     C                             (CGL013 = 'Y')                                             CER030
     C                   MOVEL     'M'           WScrn                                        CER030
     C                   ELSE                                                                 CER030
      *                                                                         CFT014
     C                   IF        (BGN0ST = 'Y')                               CFT014
     C                   IF        (DDSMCY = DDPCCY)                            CFT014
     C                             AND (DDMBSI = *BLANK)                        CFT014
     C                             AND (DDMSIG = *BLANK)                        CFT014
     C                   ADD       1             Idx                            CFT014
     C                   Eval      FldNameArr(Idx) = '*ANY'                     CFT014
     C                   Eval      MsgIdArr(Idx) = 'FTM2554'                    CFT014
     C                   ELSE                                                   CFT014
      *                                                                         CFT014
      ** If this has not been done yet, send Incoming Payments                  CFT014
      ** validation error messages to Margin Info scrn.                         CFT014
     C                   IF        WSnd_Marg <> 'Y'                             CFT014
     C                   EXSR      SRSndM_Marg                                  CFT014
     C                   EVAL      WSnd_Marg = 'Y'                              CFT014
     C                   ELSE                                                   CFT014
     C                   MOVE      FTEIPY5x      FTEIPY5                        CFT014
     C                   MOVEA     FldNameAr5    FldNameArr                     CFT014
     C                   MOVEA     MsgIdAr5      MsgIdArr                       CFT014
     C                   MOVEA     MsgDtaAr5     MsgDtaArr                      CFT014
     C                   EVAL      IDx = ID5                                    CFT014
     C                   ENDIF                                                  CFT014
     C                   MOVEL     'M'           WScrn                          CFT014
     C                   ENDIF                                                  CFT014
     C                   ELSE                                                   CFT014
      *                                                                         CFT014
      ** If this has not been done yet, send Incoming Payments                  CFT014
      ** validation error messages to Margin Info scrn.                         CFT014
     C                   IF        WSnd_Marg <> 'Y'                             CFT014
     C                   EXSR      SRSndM_Marg                                  CFT014
     C                   EVAL      WSnd_Marg = 'Y'                              CFT014
     C                   ELSE                                                   CFT014
     C                   MOVE      FTEIPY5x      FTEIPY5                        CFT014
     C                   MOVEA     FldNameAr5    FldNameArr                     CFT014
     C                   MOVEA     MsgIdAr5      MsgIdArr                       CFT014
     C                   MOVEA     MsgDtaAr5     MsgDtaArr                      CFT014
     C                   EVAL      IDx = ID5                                    CFT014
     C                   ENDIF                                                  CFT014
     C                   MOVEL     'M'           WScrn                          CFT014
     C                   ENDIF                                                  CFT014
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                         CFT014
      ** Enter key was pressed.                                                 CFT014
      *                                                                         CFT014
     C                   OTHER                                                  CFT014
      *                                                                         CFT014
      ** If Action is Insert or Amend and Option selected is 'U',               CFT014
      ** validate input to Level 2 screen 3.                                    CFT014
      *                                                                         CFT014
     C                   IF        DDACTN = 'I' and POPSEL = 'U' or             CFT014
     C                             DDACTN = 'A' and POPSEL = 'U'                CFT014
      *                                                                                       187056
      ** Perform recalculation of charges if 'charges to the debit of a/c'                    187056
      ** has been changed.                                                                    187056
     C                   EXSR      SRReCalc                                                   187056
      *                                                                                       187056
     C                   EXSR      SRVAL_D                                      CFT014
     C/COPY WNCPYSRC,FTIPAYRC15
      *                                                                                       CER001
      **  ULX611 - Review window processing for Insertion                                     CER001
      **                                    for other mode except 'D'                         CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y'                                               CER001
     C                             and  BTLVJN = 'Y'                                          CER001
     C                             or ULX043 = 'Y'                                            CER001
     C                             and  PParmLevel = '2'                                      CER001
      *                                                                                       CER001
      **  New Window processing                                                               CER001
      *                                                                                       CER001
     C                   EXSR      SRPREX                                                     CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
     C                   GOTO      EScrn_D                                      CFT014
     C                   ENDIF                                                  CFT014
     C/COPY WNCPYSRC,FTIPAYRC16
      *                                                                                       CER001
      ** ULX611 - Review window processing for Insertion                                      CER001
      **                                   for other mode except 'D'                          CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y'                                               CER001
     C                             and  BTLVJN = 'Y'                                          CER001
     C                             or ULX043 = 'Y'                                            CER001
     C                             and  PParmLevel = '2'                                      CER001
      *                                                                                       CER001
      ** New Window processing                                                                CER001
      *                                                                                       CER001
     C                   EXSR      SRPREX                                                     CER001
      *                                                                                       CER001
      ** If F3 or F12 pressed on window, make sure that the Primary or                        CER001
      ** secondary screen or the subfile is displayed and not initial screen                  CER001
      *                                                                                       CER001
     C                   IF        #RTRN = 'Y2U9999'                                          CER001
     C                             or #RTRN = 'USR0790'                                       CER001
     C                   GOTO      EScrn_D                                                    CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CSW209
      ** Display Cover message if SWIFT 2009 is ON                                            CSW209
      ** for Action code not equal to 'I' and 'A'                                             CSW209
      *                                                                                       CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   EVAL      WScrn = 'N'                                                CSW209
     C                   LEAVESR                                                              CSW209
     C                   ENDIF                                                                CSW209
      *                                                                         CFT014
      ** If errors exist on Level 2 screen 3, no need to display                CFT014
      ** Margin Info scrn.                                                      CFT014
      *                                                                         CFT014
     C                   IF        ID4 > 0                                      CFT014
     C                   IF        PRDNB = 'Y'                                  CFT014
     C                   EVAL      WSCRN = 'R'                                  CFT014
     C                   ELSE                                                   CFT014
     C                   EVAL      WSCRN = 'B'                                  CFT014
     C                   ENDIF                                                  CFT014
     C                   GOTO      EScrn_D                                      CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   ENDSL                                                  CFT014
      *                                                                         CFT014
     C     EScrn_D       ENDSR                                                  CFT014
      *                                                                         CFT014
      *****************************************************************         CFT014
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SRVAL_D - Validate Input to Level 2 Screen 3                 *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
      *                                                                         CFT014
     C     SRVal_D       BEGSR                                                  CFT014
      *                                                                         CFT014
      ** Validate Detail fields on Level 2 screen 3.                            CFT014
      *                                                                         CFT014
     C                   CALLB     'FTIPAY4VL'                                  CFT014
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
      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
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
      ** SDFTFR - fixed charge currency                                         CFT009
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
     C                   PARM      *BLANKS       PFrcReDisplay     1            CFT014
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
                                                                                              199992
      ** Previous warning messages array                                                      199992
                                                                                              199992
     C                   PARM                    WPrvWarnAr                                   199992
                                                                                              199992
      ** Warning message work inds for charges screen                                         199992
                                                                                              199992
     C                   PARM                    PChgWarn                                     199992
     C                   PARM                    BENEDrBlck                                 MD025111
     C                   PARM                    BENEDrRefd                                MD047369A
      *                                                                         CFT014
     C                   MOVE      PFrcReDisplay WRedisplay                     CFT014
      *                                                                         CFT014
      ** If no errors occurred during validation of fields on Level 2           CFT014
      ** screen 3, check if there are warnings which have not been              CFT014
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
      ** Redisplay Level 2 screen 3 if there are errors or if there             CFT014
      ** are warnings which have not been displayed yet.                        CFT014
      *                                                                         CFT014
     C                   IF        IDx <> 0 or                                  CFT014
     C                             WRedisplay = 'Y'                             CFT014
     C                             OR WReDspChg = 'Y'                                         187056
     C                   GOTO      EVal_D                                       CFT014
     C                   ENDIF                                                  CFT014
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
      *                                                                         CFT014
      ** If this has not been done yet, send Incoming Payments                  CFT014
      ** validation error messages to Margin Info scrn.                         CFT014
     C                   IF        WSnd_Marg <> 'Y'                             CFT014
     C                   EXSR      SRSndM_Marg                                  CFT014
     C                   EVAL      WSnd_Marg = 'Y'                              CFT014
     C                   ELSE                                                   CFT014
     C                   MOVE      FTEIPY5x      FTEIPY5                        CFT014
     C                   MOVEA     FldNameAr5    FldNameArr                     CFT014
     C                   MOVEA     MsgIdAr5      MsgIdArr                       CFT014
     C                   MOVEA     MsgDtaAr5     MsgDtaArr                      CFT014
     C                   EVAL      IDx = ID5                                    CFT014
     C                   ENDIF                                                  CFT014
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
     C                   ELSE                                                   CFT014
      *                                                                         CFT014
      ** Display confirmation screen.                                           CFT014
     C                   EVAL      WSCRN = 'F'                                  CFT014
      *                                                                                       CSW209
      ** Display Cover message if SWIFT 2009 is ON                                            CSW209
      *                                                                                       CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   EVAL      WScrn = 'N'                                                CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C     EVal_D        ENDSR                                                  CFT014
      *                                                                         CFT014
      *****************************************************************         CFT014
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SRSCRN_M - Process Margin Information screen                 *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
      *                                                                         CFT014
     C     SRScrn_M      BEGSR                                                  CFT014
      *                                                                         CFT014
      ** If Action Code is Insert or Amend and Option selected is 'U',          CFT014
      ** enable Detail fields on Margin Info scrn (all fields on                CFT014
      ** Margin Info scrn except Action Code and Payment Reference).            CFT014
      ** Also, enable F5=Refresh.                                               CFT014
      *                                                                         CFT014
     C                   IF        DDACTN = 'I' and POPSEL = 'U' or             CFT014
     C                             DDACTN = 'A' and POPSEL = 'U'                CFT014
     C                   EVAL      PEDTFLD = 'Y'                                CFT014
     C                   EVAL      PEINKE = 'Y'                                 CFT014
     C                   ELSE                                                   CFT014
     C                   EVAL      PEDTFLD = 'N'                                CFT014
     C                   EVAL      PEINKE = 'N'                                 CFT014
     C                   ENDIF                                                  CFT014
      *                                                                                       CER030
     C                   IF        (DDACTN = 'I' AND POPSEL = 'U' OR                          CER030
     C                             DDACTN = 'A' AND POPSEL = 'U')                             CER030
      *                                                                                       CER030
      ** Default Retail Transaction Type from Transaction code                                CER030
      ** If Retail Transaction type is blank                                                  CER030
      *                                                                                       CER030
     C                   IF        CER030 = 'Y' OR CGL013 = 'Y'                               CER030
     C                   IF        DDTTCD <> *BLANKS AND CFT014 = 'Y'                         CER030
     C                             AND DDRTTY = *BLANKS AND                                   CER030
     C                             Wflg = 'N'                                                 CER030
      *                                                                                       CER030
     C                   EVAL      KTtcd = DDTTCD                                             CER030
      *                                                                                       CER030
     C     KTtcd         CHAIN     SDNTTIL1                                                   CER030
     C                   IF        %FOUND (SDNTTIL1)                                          CER030
     C                   EVAL      DDRTTY = NIRTTY                                            CER030
     C                   ENDIF                                                                CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
     C                   EVAL      WFlg = 'Y'                                                 CER030
     C                   ENDIF                                                                CER030
      *                                                                         CFT014
      ** Display Margin Info scrn.                                              CFT014
      *                                                                         CFT014
     C                   CALLB     'FTIPAY5DP'                                  CFT014
      *                             =========                                   CFT014
      ** INPUT                                                                  CFT014
      ** =====                                                                  CFT014
      *                                                                         CFT014
      ** Return Code                                                            CFT014
     C                   PARM      *BLANKS       RetCodeOut                     CFT014
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 screen details from incoming transaction       CFT014
      ** - screen format                                                        CFT014
     C                   PARM                    NwIP1ScnFmt                    CFT014
      *                                                                         CFT014
      ** Incoming Payments Margin Info scrn details from incoming transaction   CFT014
      ** - screen format                                                        CFT014
     C                   PARM                    NwIP6ScnFmt                    CFT014
      *                                                                                       CER030
      ** Incoming Payments Extended Narratives from incoming                                  CER030
      ** transaction - screen format                                                          CER030
      *                                                                                       CER030
     C                   PARM                    NwIP6AScnFmt                                 CER030
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 3 error indicators                        CFT014
     C                   PARM                    FTEIPY5                        CFT014
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
      ** Enable Detail Fields Indicator                                         CFT014
     C                   PARM                    PEDTFLD                        CFT014
      *                                                                         CFT014
      ** Function Keys Enabled                                                  CFT014
      ** KC = Command Key 03 = Exit                                             CFT014
      ** KL = Command Key 12 = Cancel                                           CFT014
      ** KE = Command Key 05 = Refresh                                          CFT014
     C                   PARM                    PINKC                          CFT014
     C                   PARM                    PINKL                          CFT014
     C                   PARM                    PINKE                          CFT014
      *                                                                         CFT014
      ** Write Screen with No Read Indicator                                    CFT014
     C                   PARM      'N'           PWriteOnly                     CFT014
      *                                                                         CFT014
      ** Cursor position                                                        CFT014
     C                   PARM                    PRowCol                        CFT014
      *                                                                         CFT014
      ** Save Warning Message Ids array of Margin Info scrn.                    CFT014
      *                                                                         CFT014
     C                   MOVEA     WMsgIDArr     WPrvWarnAr                     CFT014
      *                                                                         CFT014
      ** Reset error fields.                                                    CFT014
      *                                                                         CFT014
     C                   EXSR      SRResetErr                                   CFT014
     C                   SELECT                                                 CFT014
      *                                                                         CFT014
      ** F3 - end program.                                                      CFT014
      *                                                                         CFT014
     C                   WHEN      PINKC = '1'                                  CFT014
     C                   EXSR      SREndP                                       CFT014
      *                                                                         CFT014
      ** F5 - refresh Margin Info scrn.                                         CFT014
      *                                                                         CFT014
     C                   WHEN      PINKE = '1'                                  CFT014
     C                   MOVE      NwIP6ScnFmx   NwIP6ScnFmt                    CFT014
     C                   MOVE      NwIP6AScnFmx  NwIP6AScnFmt                                 CER030
     C                   MOVE      FTEIPY5x      FTEIPY5                        CFT014
     C                   MOVE      FldNameAr5    FldNameArr                     CFT014
     C                   MOVE      MsgIdAr5      MsgIdArr                       CFT014
     C                   MOVE      MsgDtaAr5     MsgDtaArr                      CFT014
     C                   MOVE      ID5           IDx                            CFT014
      *                                                                         CFT014
      ** F12 - cancel.  Display Level 2 screen 3.                               CFT014
      *                                                                         CFT014
     C                   WHEN      PINKL = '1'                                  CFT014
     C                   MOVE      NwIP6ScnFmx   NwIP6ScnFmt                    CFT014
     C                   MOVE      NwIP6AScnFmx  NwIP6AScnFmt                                 CER030
     C                   EVAL      WSCRN = 'D'                                  CFT014
      *                                                                         CFT014
      ** Enter key was pressed.                                                 CFT014
      *                                                                         CFT014
     C                   OTHER                                                  CFT014
      *                                                                         CFT014
      ** If Action is Insert or Amend and Option selected is 'U',               CFT014
      ** validate input to Margin Info scrn.                                    CFT014
      *                                                                         CFT014
     C                   IF        DDACTN = 'I' and POPSEL = 'U' or             CFT014
     C                             DDACTN = 'A' and POPSEL = 'U'                CFT014
     C                   EXSR      SRVAL_M                                      CFT014
     C                   IF        IDx <> 0 or                                  CFT014
     C                             WRedisplay = 'Y'                             CFT014
     C                   GOTO      EScrn_M                                      CFT014
     C                   ENDIF                                                  CFT014
     C                   ENDIF                                                  CFT014
     C                   EVAL      WSCRN = 'D'                                  CFT014
      *                                                                         CFT014
     C                   ENDSL                                                  CFT014
      *                                                                         CFT014
     C     EScrn_M       ENDSR                                                  CFT014
      *                                                                         CFT014
      *****************************************************************         CFT014
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SRVAL_M - Validate Input to Margin Info scrn                 *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
      *                                                                         CFT014
     C     SRVal_M       BEGSR                                                  CFT014
      *                                                                         CFT014
      ** Validate Detail fields on Margin Info scrn.                            CFT014
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
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction       CFT014
      ** - screen format                                                        CFT014
     C                   PARM                    NwIP6ScnFmt                    CFT014
      *                                                                                       CER030
      ** Incoming Payments Lvl 2 Scrn 3 Ext Narr details from incoming                        CER030
      ** transaction - screen format                                                          CER030
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
      ** Incoming Payments Margin Info error indicators                         CFT014
     C                   PARM                    FTEIPY5                        CFT014
      *                                                                         CFT014
      ** Incoming Payments for file update - file format                        CFT014
     C                   PARM                    NwIPFilFmt                     CFT014
      *                                                                                       CER030
      ** Extension Valid File Value for Transaction code                                      CER030
      *                                                                                       CER030
     C                   PARM                    I2INTTCD                                     CER030
      *                                                                         CFT014
     C                   MOVEL     *BLANK        WRedisplay                     CFT014
      *                                                                         CFT014
      ** If no errors occurred during validation of fields on Level 2           CFT014
      ** screen 3, check if there are warnings which have not been              CFT014
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
      ** Redisplay Margin Info scrn if there are errors or if there             CFT014
      ** are warnings which have not been displayed yet.                        CFT014
      *                                                                         CFT014
     C                   IF        IDx <> 0 or                                  CFT014
     C                             WRedisplay = 'Y'                             CFT014
     C                   GOTO      EVal_M                                       CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C     EVal_M        ENDSR                                                  CFT014
      *                                                                         CFT014
      *****************************************************************         CFT014
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSCRN_W - Process Window Screen                             *
      *                                                               *
      *****************************************************************
      *
     C     SRScrn_W      BEGSR
      *
      ** Write out screen to remove error messages.
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
     C/COPY WNCPYSRC,FTIPAYRC24
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
     C/COPY WNCPYSRC,FTIPAYRC06
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
      * Set up Payment Reference                                                              209067
     C     DDACTN        IFEQ      'I'                                                        209067
     C     FirstTime     ANDEQ     'Y'                                                        209067
     C                   EVAL      FirstTime = 'N'                                            209067
     C                   EXSR      SETPAYREF                                                  209067
     C/COPY WNCPYSRC,FTH00226
     C                   ENDIF                                                                209067
      *                                                                                       209067
      /COPY WNCPYSRC,FTIPAYMV1
      *
      ** Call Window Manager.
      *
     C                   CALL      'WN0010'
     C                   PARM      'FTIPAYRPR'   PWPGM            10
     C                   PARM                    PWKEY             2
     C                   PARM      DDACTN        PWACTION          1
     C                   PARM                    DATA
     C                   PARM      *BLANKS       PWRTN             7
     C                   PARM                    PWSPARE         256
      *
     C/COPY WNCPYSRC,FTIPAYRC31
     C                   SELECT
      *
      ** F3 - end program.
      *
     C                   WHEN      PWRTN = 'Y2U9999'
     C                   EXSR      SREndP
      *
      ** F12 - cancel.  Display Level 1 screen.
      *
     C                   WHEN      PWRTN = 'USR0790'
     C                   EVAL      WSCRN = 'P'
      *
      ** Enter key was pressed.
      *
     C                   OTHER
      *
      ** If this has not been done yet, send Incoming Payments
      ** validation error messages to Level 2 screen 1.
      *
     C                   IF        WSnd_L2S1 <> 'Y'
     C                   EXSR      SRSndM_L2S1
     C                   EVAL      WSnd_L2S1 = 'Y'
     C                   ELSE
     C                   MOVE      FTEIPY2x      FTEIPY2
     C                   MOVEA     FldNameAr2    FldNameArr
     C                   MOVEA     MsgIdAr2      MsgIdArr
     C                   MOVEA     MsgDtaAr2     MsgDtaArr
     C                   EVAL      IDx = ID2
     C                   ENDIF
      *
      ** Display Level 2 screen 1.
      *
     C                   EVAL      WSCRN = 'S'
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSCRN_F - Process Confirmation Screen                       *
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
      ** Display Confirmation screen.
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
     C/COPY WNCPYSRC,FTIPAYRC25
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
     C/COPY WNCPYSRC,FTIPAYRC07
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
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr
      *
     C                   SELECT
      *
      ** F3 - end program.
      *
     C                   WHEN      PINKC = '1'
     C                   EXSR      SREndP
      *
      ** F12 - cancel.  Display Level 1 screen.
      *
     C                   WHEN      PINKL = '1'
     C                   EVAL      WSCRN = 'P'
      *                                                                         CFT014
      ** Reset all error fields because at this point, all fields are valid.    CFT014
     C                   EXSR      SrResetErr                                   CFT014
     C                   CLEAR                   FldNameAr1                     CFT014
     C                   CLEAR                   MsgIDAr1                       CFT014
     C                   CLEAR                   MsgDtaAr1                      CFT014
     C                   CLEAR                   ID1                            CFT014
     C                   CLEAR                   FldNameAr2                     CFT014
     C                   CLEAR                   MsgIDAr2                       CFT014
     C                   CLEAR                   MsgDtaAr2                      CFT014
     C                   CLEAR                   ID2                            CFT014
     C                   CLEAR                   FldNameAr3                     CFT014
     C                   CLEAR                   MsgIDAr3                       CFT014
     C                   CLEAR                   MsgDtaAr3                      CFT014
     C                   CLEAR                   ID3                            CFT014
     C                   CLEAR                   FldNameAr4                     CFT014
     C                   CLEAR                   MsgIDAr4                       CFT014
     C                   CLEAR                   MsgDtaAr4                      CFT014
     C                   CLEAR                   ID4                            CFT014
     C                   CLEAR                   FldNameAr5                     CFT014
     C                   CLEAR                   MsgIDAr5                       CFT014
     C                   CLEAR                   MsgDtaAr5                      CFT014
     C                   CLEAR                   ID5                            CFT014
     C                   MOVE      *ALL'Y'       FTEIPY1x                       CFT014
     C                   MOVE      *ALL'Y'       FTEIPY2x                       CFT014
     C                   MOVE      *ALL'Y'       FTEIPY3x                       CFT014
     C                   MOVE      *ALL'Y'       FTEIPY4x                       CFT014
     C                   MOVE      *ALL'Y'       FTEIPY5x                       CFT014
      *
      ** Enter key was pressed.  Update files.
      *
     C                   OTHER
     C                   EVAL      WSCRN = 'U'
      *
     C                   ENDSL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSCRN_A - Process Additional Information Screen             *
      *                                                               *
      *****************************************************************
      *
     C     SRScrn_A      BEGSR
      *
      ** Display Level 1 screen without error messages.
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
     C                   PARM      'Y'           PAddInfo          1
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
     C/COPY WNCPYSRC,FTIPAYRC26
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
     C/COPY WNCPYSRC,FTIPAYRC08
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
     C/COPY WNCPYSRC,FTIPAYRC01
      *
     C                   SELECT
      *
      ** F3 - end program.
      *
     C                   WHEN      PINKC = '1'
     C                   EXSR      SREndP
      *
      ** F12 - cancel.  Display Level 1 screen.
      *
     C                   WHEN      PINKL = '1'
     C                   EVAL      WSCRN = 'P'
      *
      ** Enter key was pressed.  Display Level 1 screen.
      *
     C                   OTHER
     C                   EVAL      WSCRN = 'P'
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
      ** fields.                                                                              CSW209
      *                                                                                       CSW209
     C                   IF        DDACTN = 'I' AND                                           CSW209
     C                             POPSEL = 'U' OR                                            CSW209
     C                             DDACTN = 'A' AND                                           CSW209
     C                             POPSEL = 'U'                                               CSW209
     C                   EVAL      PEDTFLD = 'Y'                                              CSW209
     C                   ELSE                                                                 CSW209
     C                   EVAL      PEDTFLD = 'N'                                              CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   EVAL      PEINKG = 'N'                                               CSW209
     C                   EVAL      PEINKH = 'N'                                               CSW209
     C                   EVAL      PEINKP = 'N'                                               CSW209
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
      ** KL = Command Key 12 = Cancel                                                         CSW209
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
      ** F12 - cancel.  Refresh Level 2 screen 7 and redisplay                                CSW209
      ** Level 2 screen 4.                                                                    CSW209
      *                                                                                       CSW209
     C     PINKL         WHENEQ    *ON                                                        CSW209
     C                   MOVEL     NwIP7ScnFmx   NwIP7ScnFmt                                  CSW209
     C                   MOVEL     'D'           WScrn                                        CSW209
      *                                                                                       CSW209
      ** Enter key was pressed.                                                               CSW209
      *                                                                                       CSW209
     C                   OTHER                                                                CSW209
      *                                                                                       CSW209
      ** If Action is Insert or Amend, validate input to                                      CSW209
      ** Level 2 screen 7.                                                                    CSW209
      *                                                                                       CSW209
     C                   IF        DDACTN = 'I' AND                                           CSW209
     C                             POPSEL = 'U' OR                                            CSW209
     C                             DDACTN = 'A' AND                                           CSW209
     C                             POPSEL = 'U'                                               CSW209
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
      ** fields.                                                                              CSW209
      *                                                                                       CSW209
     C                   IF        DDACTN = 'I' AND                                           CSW209
     C                             POPSEL = 'U' OR                                            CSW209
     C                             DDACTN = 'A' AND                                           CSW209
     C                             POPSEL = 'U'                                               CSW209
     C                   EVAL      PEDTFLD = 'Y'                                              CSW209
     C                   ELSE                                                                 CSW209
     C                   EVAL      PEDTFLD = 'N'                                              CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   EVAL      PEINKG = 'N'                                               CSW209
     C                   EVAL      PEINKH = 'N'                                               CSW209
     C                   EVAL      PEINKP = 'N'                                               CSW209
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
      ** KL = Command Key 12 = Cancel                                                         CSW209
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
      ** F12 - cancel.  Refresh Level 2 screen 8 and redisplay                                CSW209
      ** Level 2 screen 7.                                                                    CSW209
      *                                                                                       CSW209
     C     PINKL         WHENEQ    *ON                                                        CSW209
     C                   MOVEL     NwIP8ScnFmx   NwIP8ScnFmt                                  CSW209
     C                   MOVEL     'N'           WScrn                                        CSW209
      *                                                                                       CSW209
      ** Enter key was pressed.                                                               CSW209
      *                                                                                       CSW209
     C                   OTHER                                                                CSW209
      *                                                                                       CSW209
      ** If Action is Insert or Amend, validate input to                                      CSW209
      ** Level 2 screen 8.                                                                    CSW209
      *                                                                                       CSW209
     C                   IF        DDACTN = 'I' AND                                           CSW209
     C                             POPSEL = 'U' OR                                            CSW209
     C                             DDACTN = 'A' AND                                           CSW209
     C                             POPSEL = 'U'                                               CSW209
      *                                                                                       CSW209
     C                   EXSR      SRVal_O                                                    CSW209
     C                   LEAVESR                                                              CSW209
      *                                                                                       CSW209
     C                   ELSE                                                                 CSW209
     C                   EVAL      WScrn = 'F'                                                CSW209
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
      /EJECT                                                                                  209067
      *****************************************************************                       209067
      *                                                               *                       209067
      *  SETPAYREF - Set up Payment Reference                         *                       209067
      *                                                               *                       209067
      *****************************************************************                       209067
      *                                                                                       209067
     C     SETPAYREF     BEGSR                                                                209067
      *                                                                                       209067
      ** Initialise variables used in determining successful                                  209067
      ** insert of an Incoming Payment.                                                       209067
      *                                                                                       209067
     C                   MOVE      *BLANKS       WPREFI           15                          209067
     C                   MOVE      *BLANK        WInsert           1                          209067
      *                                                                                       209067
      ** Update Incoming Payments data area with next                                         209067
      ** Sequence Number.                                                                     209067
      *                                                                                       209067
     C                   IF        CFT151  = 'N'                                              CFT151
     C     *DTAARA       DEFINE    INPAYDA       WINPAY                                       209067
     C     *LOCK         IN        WINPAY                                                     209067
     C                   Z-ADD     WINSQ         WWINSQ            4 0                        209067
                                                                                              CSC024
      ***Suppress*new*payment*reference*generation*if*CSC024*is                        CSC024 CSC054
      ***switched*on*and*this*is*running*on*OME*system.                                CSC024 CSC054
      ** Suppress new payment reference generation if CSC054 is                               CSC054
      ** switched on and this is running on PEA system.                                       CSC054
                                                                                              CSC024
     C                   IF        GENPREF = 'Y'                                              CSC024
     C                   ADD       1             WINSQ                                        209067
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C                   OUT       WINPAY                                                     209067
     C                   ELSE                                                                 CFT151
     C                   MOVE      WINPAY        WWINSQT                                      CFT151
     C                   IF        GENPREF = 'Y'                                              CFT151
     C                   CALL      'FT000328'                                                 CFT151
     C                   PARM                    PRTCD                                        CFT151
     C                   PARM      'IN'          W@OTIN            2                          CFT151
     C                   PARM      'A'           WCALC             1                          CFT151
     C                   PARM      'Y'           WUPD              1                          CFT151
     C                   PARM                    WWINSQT           4                          CFT151
     C                   PARM                    WNEWSQ                                       CFT151
     C                   END                                                                  CFT151
     C                   END                                                                  CFT151
      *                                                                                       209067
      ** Record Id.                                                                           209067
      *                                                                                       209067
     C                   MOVEL     'D'           IPRECI                                       209067
      *                                                                                       209067
      ** Payment Type.                                                                        209067
      *                                                                                       209067
     C                   EVAL      IPPYTP = 'IN'                                              209067
      *                                                                                       209067
      ** Original Entry Dates.                                                                209067
      *                                                                                       209067
     C                   Z-ADD     BJRDNB        PDayNo                                       209067
      *                                                                                       209067
     C                   CALLB     'ZDATE2'                                                   209067
     C                   PARM                    PDayNo            5 0                        209067
     C                   PARM      BJDFIN        PFMT              1                          209067
     C                   PARM      *ZERO         PDate             6 0                        209067
     C                   PARM      *BLANKS       PADate            7                          209067
      *                                                                                       209067
     C                   Z-ADD     BJRDNB        IPOEDT                                       209067
     C                   Z-ADD     PDate         IPOEDTD1                                     209067
      *                                                                                       209067
     C                   MOVE      PDate         WN2               2 0                        209067
     C     WN2           IFLT      72                                                         209067
     C                   Z-ADD     20            IPOEDTD2                                     209067
     C                   ELSE                                                                 209067
     C                   Z-ADD     19            IPOEDTD2                                     209067
     C                   ENDIF                                                                209067
      *                                                                                       209067
     C                   MOVEL     PDate         WA4               4                          209067
     C     BJDFIN        IFNE      'M'                                                        209067
     C                   MOVEL     WA4           WA2               2                          209067
     C                   MOVE      WA4           WA2A              2                          209067
     C                   MOVEL     WA2A          WA4                                          209067
     C                   MOVE      WA2           WA4                                          209067
     C                   ENDIF                                                                209067
      *                                                                                       209067
     C                   MOVE      PDate         WA2                                          209067
     C                   MOVEL     WA2           PDate                                        209067
     C                   MOVE      WA4           PDate                                        209067
     C                   Z-ADD     PDate         IPOEDTD3                                     209067
      *                                                                                       209067
      ** New Payment Reference.                                                               209067
      *                                                                                       209067
     C                   IF        (CSC011 = 'Y') AND (LIBR = S1SUPP)                         209067
     C                   Z-ADD     WPRDTE        PDAYNO                                       209067
     C                   CALLB     'ZDATE2'                                                   209067
     C                   PARM                    PDAYNO                                       209067
     C                   PARM      BJDFIN        PFMT                                         209067
     C                   PARM      *ZERO         PPRDATE                                      209067
     C                   PARM      *BLANKS       PPRADATE                                     209067
      *                                                                                       209067
     C                   MOVEL     PPRDATE       WA4                                          209067
     C     BJDFIN        IFNE      'M'                                                        209067
     C                   MOVEL     WA4           WA2                                          209067
     C                   MOVE      WA4           WA2A                                         209067
     C                   MOVEL     WA2A          WA4                                          209067
     C                   MOVE      WA2           WA4                                          209067
     C                   ENDIF                                                                209067
      *                                                                                       209067
     C                   MOVE      PPRDATE       WA2                                          209067
     C                   MOVEL     WA2           PPRDATE                                      209067
     C                   MOVE      WA4           PPRDATE                                      209067
     C                   MOVE      PPRDATE       WA6                                          209067
     C                   ELSE                                                                 209067
     C                   MOVE      PDate         WA6               6                          209067
     C                   ENDIF                                                                209067
     C                   IF        CFT151 = 'N'                                               CFT151
     C                   MOVE      WWINSQ        WA4                                          209067
     C                   ELSE                                                                 CFT151
     C                   MOVE      WWINSQT       WA4                                          CFT151
     C                   END                                                                  CFT151
     C                   MOVE      'P'           WYA2(1)                                      209067
     C                   MOVEA     WA6           WYA2(2)                                      209067
     C                   MOVEA     WA4           WYA2(8)                                      209067
     C                   MOVEA     IPPYTP        WYA2(12)                                     209067
     C                   MOVEA     '00'          WYA2(14)                                     209067
      *                                                                                       209067
     C     1             DO        15            IA                2 0                        209067
     C     WYA2(IA)      IFEQ      ' '                                                        209067
     C                   MOVEL     '0'           WYA2(IA)                                     209067
     C                   ENDIF                                                                209067
     C                   ENDDO                                                                209067
      *                                                                                       209067
     C                   IF        GENPREF = 'Y'                                              CSC024
     C                   MOVEA     WYA2(1)       IPPREF                                       209067
     C                   ELSE                                                                 CSC024
     C                   EVAL      IPPREF = DDPREF                                            CSC024
     C                   ENDIF                                                                CSC024
      *                                                                                       209067
     C                   ENDSR                                                                209067
      *****************************************************************                       209067
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPDATE - Update Files                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRUpdate      BEGSR
      *
      ** Initialise variables used in determining successful
      ** insert of an Incoming Payment.
      *
     C                   MOVE      *BLANKS       PPREFI           15
     C                   MOVE      *BLANK        WInsert           1
      *
      ** Action is Insert.
      *
     C                   IF        DDACTN = 'I'
     C/COPY WNCPYSRC,FTIPAYRC12
      *                                                                                       CER001
      ** check if already allocated in window                                                 CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'N' OR                                            CER001
     C                             (IPPREF = *BLANKS AND ULX043 = 'Y')                        CER001
      *                                                                                       CER001
      *
      ***Update*Incoming Payments data area with next                                         209067
      ***Sequence*Number.                                                                     209067
      **********                                                                              209067
     C**** *DTAARA       DEFINE    INPAYDA       WINPAY                                       209067
     C**** *LOCK         IN        WINPAY                                                     209067
     C**********         Z-ADD     WINSQ         WWINSQ            4 0                        209067
     C**********         ADD       1             WINSQ                                        209067
     C**********         OUT       WINPAY                                                     209067
      **********                                                                              209067
      ***Record*Id.                                                                           209067
      **********                                                                              209067
     C**********         MOVEL     'D'           IPRECI                                       209067
      **********                                                                              209067
      ***Payment Type.                                                                        209067
      **********                                                                              209067
     C**********         EVAL      IPPYTP = 'IN'                                              209067
      **********                                                                              209067
      ***Original Entry Dates.                                                                209067
      **********                                                                              209067
     C**********         Z-ADD     BJRDNB        PDayNo                                       209067
      **********                                                                              209067
     C**********         CALLB     'ZDATE2'                                                   209067
     C**********         PARM                    PDayNo            5 0                        209067
     C**********         PARM      BJDFIN        PFMT              1                          209067
     C**********         PARM      *ZERO         PDate             6 0                        209067
     C**********         PARM      *BLANKS       PADate            7                          209067
      **********                                                                              209067
     C**********         Z-ADD     BJRDNB        IPOEDT                                       209067
     C**********         Z-ADD     PDate         IPOEDTD1                                     209067
      **********                                                                              209067
     C**********         MOVE      PDate         WN2               2 0                        209067
     C**********         IF        WN2 < 72                                                   209067
     C**********         Z-ADD     20            IPOEDTD2                                     209067
     C**********         ELSE                                                                 209067
     C**********         Z-ADD     19            IPOEDTD2                                     209067
     C**********         ENDIF                                                                209067
      **********                                                                              209067
     C**********         MOVEL     PDate         WA4               4                          209067
     C*****BJDFIN        IFNE      'M'                                                        209067
     C**********         MOVEL     WA4           WA2               2                          209067
     C**********         MOVE      WA4           WA2A              2                          209067
     C**********         MOVEL     WA2A          WA4                                          209067
     C**********         MOVE      WA2           WA4                                          209067
     C**********         ENDIF                                                                209067
      **********                                                                              209067
     C**********         MOVE      PDate         WA2                                          209067
     C**********         MOVEL     WA2           PDate                                        209067
     C**********         MOVE      WA4           PDate                                        209067
     C**********         Z-ADD     PDate         IPOEDTD3                                     209067
      **********                                                                              209067
      ***New*Payment Reference.                                                               209067
      **********                                                                              209067
     C**********         IF        (CSC011 = 'Y') AND (LIBR = S1SUPP)                  CSC011 209067
     C**********         Z-ADD     WPRDTE        PDAYNO                                CSC011 209067
     C**********         CALLB     'ZDATE2'                                            CSC011 209067
     C**********         PARM                    PDAYNO                                CSC011 209067
     C**********         PARM      BJDFIN        PFMT                                  CSC011 209067
     C**********         PARM      *ZERO         PPRDATE                               CSC011 209067
     C**********         PARM      *BLANKS       PPRADATE                              CSC011 209067
      **********                                                                       CSC011 209067
     C**********         MOVEL     PPRDATE       WA4                                   CSC011 209067
     C*****BJDFIN        IFNE      'M'                                                 CSC011 209067
     C**********         MOVEL     WA4           WA2                                   CSC011 209067
     C**********         MOVE      WA4           WA2A                                  CSC011 209067
     C**********         MOVEL     WA2A          WA4                                   CSC011 209067
     C**********         MOVE      WA2           WA4                                   CSC011 209067
     C**********         ENDIF                                                         CSC011 209067
      **********                                                                       CSC011 209067
     C**********         MOVE      PPRDATE       WA2                                   CSC011 209067
     C**********         MOVEL     WA2           PPRDATE                               CSC011 209067
     C**********         MOVE      WA4           PPRDATE                               CSC011 209067
     C**********         MOVE      PPRDATE       WA6                                   CSC011 209067
     C**********         ELSE                                                          CSC011 209067
     C**********         MOVE      PDate         WA6               6                          209067
     C**********         ENDIF                                                         CSC011 209067
     C**********         MOVE      WWINSQ        WA4                                          209067
     C**********         MOVE      'P'           WYA1(1)                                      209067
     C**********         MOVEA     WA6           WYA1(2)                                      209067
     C**********         MOVEA     WA4           WYA1(8)                                      209067
     C**********         MOVEA     IPPYTP        WYA1(12)                                     209067
     C**********         MOVEA     '00'          WYA1(14)                                     209067
      **********                                                                              209067
     C*****1****         DO        15            IA                2 0                        209067
     C*****WYA1(IA)      IFEQ      ' '                                                        209067
     C**********         MOVEL     '0'           WYA1(IA)                                     209067
     C**********         ENDIF                                                                209067
     C**********         ENDDO                                                                209067
      **********                                                                              209067
     C**********         MOVEA     WYA1(1)       IPPREF                                       209067
     C/COPY WNCPYSRC,FTIPAYRC19
     C**********         MOVEA     WYA1(1)       PPREFI                                       209067
     C                   MOVE      IPPREF        WPREFI                                       209067
     C                   MOVE      'Y'           WInsert
     C/COPY WNCPYSRC,FTIPAYRC27
      *
      ** Level 1 Valid Indicator.
      *
     C                   EVAL      IPINLVL1 = 'Y'
      *
     C/COPY WNCPYSRC,FTIPAYRC13
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
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
      *                                                                                       CER001
      ** Level 1 Valid Indicator.                                                             CER001
      *                                                                                       CER001
     C                   EVAL      IPINLVL1 = 'Y'                                             CER001
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
      *
      ** Front Office Id.
      *
     C                   EVAL      IPFRNT = PFOTRANSEL
      *                                                                         CFT014
      ** Update fields for INPAYXPD if CFT003 or CFT014 is on.                  CFT014
      *                                                                         CFT014
     C***************    IF        (CFT003 = 'Y' or CFT014 = 'Y') and           CFT009CFT014
     C                   IF        (CFT003 = 'Y' or CFT014 = 'Y'                CFT009
     C                             OR CFT009 = 'Y') AND                         CFT009
     C                             (DDACTN = 'I' or DDACTN = 'A')               CFT014
     C                   EVAL      I2INAUTO = 'N'                               CFT014
     C                   IF        DDACTN = 'I'                                 CFT014
     C                   EVAL      I2INRECI = 'D'                               CFT014
     C                   EVAL      I2INPREF = IPPREF                            CFT014
     C                   EVAL      I2INFRNT = IPFRNT                            CFT014
     C                   ENDIF                                                  CFT014
     C                   ENDIF                                                  CFT014
     C/COPY WNCPYSRC,FTH00261
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
      ** Incoming Payments (additional info) for file update - file format      CFT014
     C                   PARM                    NwIP2FilFmt                    CFT014
      *
      ** IBANs full account
     C                   PARM                    PIBANAcc
      *
      ** Originally Insert from Level 2 Entry
     C                   PARM      *BLANK        POrigACTN         1
      *
      ** FT Override for GL Balances
     C                   PARM                    PFTOV
      *
      ** FT Control Data
     C                   PARM                    PCNTRL
      *
      ** Network
     C                   PARM      *BLANKS       PNWRK             6
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
     C                   PARM      *BLANK        PAuth             1                          CAP211
     C                   PARM      *BLANKS       PUser            10                          CAP211
      *                                                                                       CAP211
     C/COPY WNCPYSRC,FTIPAYRC02
      *                                                                                       CER001
      ** Update extension fields                                                              CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y' AND                                           CER001
     C                             RetCodeOut = *BLANKS                                       CER001
     C                   EXSR      SRUPDEXT                                                   CER001
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
     C                   ENDIF
     C     ZATRNKD0      CHAIN     FTIIPAYL1                          99
     C                   IF        *IN99 = *OFF
     C                   DELETE    FTIIPAYL1
      *                                                                                       CER001
      ** Delete the extension file                                                            CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y'                                               CER001
     C     ZATRNKX0      CHAIN     RTVIDX1                                                    CER001
     C                   IF        %FOUND                                                     CER001
     C                   DELETE    RTVIDX1                                                    CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF
      *                                                                                       CSC011
      ** Delete invalid record from the log file.                                             CSC011
      *                                                                                       CSC011
     C                   IF        (CSC011 = 'Y') AND (LIBR = S1SUPP)                         CSC011
     C                   EVAL      KMTYP = 'FTIPAY'                                           CSC011
     C     KLOGL0        CHAIN     APILOGL0                           99                      CSC011
      *                                                                                       CSC011
     C                   IF        *IN99 = *OFF                                               CSC011
     C                   DELETE    APILOGD0                                                   CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
     C/COPY WNCPYSRC,FTH00143
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
      ** If update not done due to record being updated by another
      ** workstation, display message "The last transaction was not
      ** applied to the database." to the next screen.
      *
     C                   IF        RetCodeOut = '*RECUPD'
      *
     C                   EVAL      PERRUP = 'Y'
      *
     C                   ENDIF
      *
      ** Display successful Insert.
      *
     C                   IF        RetCodeOut = *BLANKS and
     C                             WInsert = 'Y'
     C                   EVAL      PERRUP = 'I'
     C/COPY WNCPYSRC,FTH00262
     C                   ENDIF
      *
      ** Read Next Subfile record or display Browse screen.
      *
     C                   IF        PRDNB = 'Y'
     C                   EVAL      WSCRN = 'R'
     C                   ELSE
     C                   EVAL      WSCRN = 'B'
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRTVPREF - Retrieve Incoming Payment Details                *
      *                                                               *
      *****************************************************************
      *
     C     SRRtvPRef     BEGSR
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
     C                   PARM                    FOTRID           20
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
      ** Incoming Payments (additional info) retrieved from file - file format  CFT014
     C                   PARM                    CrIP2FilFmt                    CFT014
     C/COPY WNCPYSRC,FTIPAYRC03
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCVTPREF - Convert Incoming Payment Details to Screen       *
      *              Format                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRCvtPRef     BEGSR
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
      ** Incoming Payments (additional info) retrieved from file - file format  CFT014
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
     C/COPY WNCPYSRC,FTIPAYRC28
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
     C                   PARM                    CFT010                         CFT009
     C/COPY WNCPYSRC,FTIPAYRC09
      *
      ** OUTPUT
      ** ======
      *
      ** Incoming Payments Lvl 1 Scrn details retrieved from file
      ** - screen format
     C                   PARM                    CrIP1ScnFmt
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
     C                   PARM                    PStatus
      *
      ** Payment Type
     C                   PARM                    PPYTP             2
      *                                                                         CFT009
      ** DS for Default Charge Amounts                                          CFT009
     C                   PARM                    PCHARGES                       CFT009
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
     C                   PARM      *BLANKS       BtnPressed       10                       AR1090283
      *                                                                                       CSW209
      ** Initialise screen fields with values from file.                                      CSW209
      *                                                                                       CSW209
     C                   MOVEL     CrIP7ScnFmt   NwIP7ScnFmt                                  CSW209
     C                   MOVEL     CrIP8ScnFmt   NwIP8ScnFmt                                  CSW209
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
     C                   Z-ADD     22            DBASE                                        187056
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
     C                   Z-ADD     23            DBASE                                        187056
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
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDTASUBS - Data Substitution                                *
      *                                                               *
      *****************************************************************
      *
     C     SRDtaSubs     BEGSR
      *
      ** Substitute the data for the various parts of the transaction.
      *
     C                   IF        WSUBIP1 = 'Y'
      *
     C                   CLEAR                   PIncData
     C                   CLEAR                   PCurData
      *
     C                   CALLB     'APDTASUBS'
      *                             =========
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Substitution Character
     C                   PARM                    GHSUBS
      *
      ** Incoming Data
     C                   PARM      NwIP1ScnFmt   PIncData       2000
      *
      ** Current Data
     C                   PARM      CrIP1ScnFmt   PCurData       2000
      *
     C                   MOVEL     PIncData      NwIP1ScnFmt
      *
     C                   ENDIF
      *                                                                         CFT014
     C                   IF        WSUBIP1a = 'Y'                               CFT014
      *                                                                         CFT014
     C                   CLEAR                   PIncData                       CFT014
     C                   CLEAR                   PCurData                       CFT014
      *                                                                         CFT014
     C                   CALLB     'APDTASUBS'                                  CFT014
      *                             =========                                   CFT014
      ** Return Code                                                            CFT014
     C                   PARM      *BLANKS       RetCodeOut                     CFT014
      *                                                                         CFT014
      ** Substitution Character                                                 CFT014
     C                   PARM                    GHSUBS                         CFT014
      *                                                                         CFT014
      ** Incoming Data                                                          CFT014
     C                   PARM      NwIP1aScnFmt  PIncData                       CFT014
      *                                                                         CFT014
      ** Current Data                                                           CFT014
     C                   PARM      CrIP1aScnFmt  PCurData                       CFT014
      *                                                                         CFT014
     C                   MOVEL     PIncData      NwIP1aScnFmt                   CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *
     C                   IF        WSUBIP2 = 'Y'
      *
     C                   CLEAR                   PIncData
     C                   CLEAR                   PCurData
      *
     C                   CALLB     'APDTASUBS'
      *                             =========
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Substitution Character
     C                   PARM                    GHSUBS
      *
      ** Incoming Data
     C                   PARM      NwIP2ScnFmt   PIncData
      *
      ** Current Data
     C                   PARM      CrIP2ScnFmt   PCurData
      *
     C                   MOVEL     PIncData      NwIP2ScnFmt
      *
     C                   ENDIF
      *
     C                   IF        WSUBIP3 = 'Y'
      *
     C                   CLEAR                   PIncData
     C                   CLEAR                   PCurData
      *
     C                   CALLB     'APDTASUBS'
      *                             =========
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Substitution Character
     C                   PARM                    GHSUBS
      *
      ** Incoming Data
     C                   PARM      NwIP3ScnFmt   PIncData
      *
      ** Current Data
     C                   PARM      CrIP3ScnFmt   PCurData
      *
     C                   MOVEL     PIncData      NwIP3ScnFmt
      *
     C                   ENDIF
      *
     C                   IF        WSUBIP4 = 'Y'
      *
     C                   CLEAR                   PIncData
     C                   CLEAR                   PCurData
      *
     C                   CALLB     'APDTASUBS'
      *                             =========
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Substitution Character
     C                   PARM                    GHSUBS
      *
      ** Incoming Data
     C                   PARM      NwIP4ScnFmt   PIncData
      *
      ** Current Data
     C                   PARM      CrIP4ScnFmt   PCurData
      *
     C                   MOVEL     PIncData      NwIP4ScnFmt
      *
     C                   ENDIF
      *                                                                         CFT014
     C                   IF        WSUBIP4a = 'Y'                               CFT014
      *                                                                         CFT014
     C                   CLEAR                   PIncData                       CFT014
     C                   CLEAR                   PCurData                       CFT014
      *                                                                         CFT014
     C                   CALLB     'APDTASUBS'                                  CFT014
      *                             =========                                   CFT014
      ** Return Code                                                            CFT014
     C                   PARM      *BLANKS       RetCodeOut                     CFT014
      *                                                                         CFT014
      ** Substitution Character                                                 CFT014
     C                   PARM                    GHSUBS                         CFT014
      *                                                                         CFT014
      ** Incoming Data                                                          CFT014
     C                   PARM      NwIP4aScnFmt  PIncData                       CFT014
      *                                                                         CFT014
      ** Current Data                                                           CFT014
     C                   PARM      CrIP4aScnFmt  PCurData                       CFT014
      *                                                                         CFT014
     C                   MOVEL     PIncData      NwIP4aScnFmt                   CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   IF        WSUBIP5 = 'Y'                                CFT014
      *                                                                         CFT014
     C                   CLEAR                   PIncData                       CFT014
     C                   CLEAR                   PCurData                       CFT014
      *                                                                         CFT014
     C                   CALLB     'APDTASUBS'                                  CFT014
      *                             =========                                   CFT014
      ** Return Code                                                            CFT014
     C                   PARM      *BLANKS       RetCodeOut                     CFT014
      *                                                                         CFT014
      ** Substitution Character                                                 CFT014
     C                   PARM                    GHSUBS                         CFT014
      *                                                                         CFT014
      ** Incoming Data                                                          CFT014
     C                   PARM      NwIP5ScnFmt   PIncData                       CFT014
      *                                                                         CFT014
      ** Current Data                                                           CFT014
     C                   PARM      CrIP5ScnFmt   PCurData                       CFT014
      *                                                                         CFT014
     C                   MOVEL     PIncData      NwIP5ScnFmt                    CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   IF        WSUBIP6 = 'Y'                                CFT014
      *                                                                         CFT014
     C                   CLEAR                   PIncData                       CFT014
     C                   CLEAR                   PCurData                       CFT014
      *                                                                         CFT014
     C                   CALLB     'APDTASUBS'                                  CFT014
      *                             =========                                   CFT014
      ** Return Code                                                            CFT014
     C                   PARM      *BLANKS       RetCodeOut                     CFT014
      *                                                                         CFT014
      ** Substitution Character                                                 CFT014
     C                   PARM                    GHSUBS                         CFT014
      *                                                                         CFT014
      ** Incoming Data                                                          CFT014
     C                   PARM      NwIP6ScnFmt   PIncData                       CFT014
      *                                                                         CFT014
      ** Current Data                                                           CFT014
     C                   PARM      CrIP6ScnFmt   PCurData                       CFT014
      *                                                                         CFT014
     C                   MOVEL     PIncData      NwIP6ScnFmt                    CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *
     C                   IF        WSUBIP6a= 'Y'                                              CER059
      *                                                                                       CER059
     C                   CLEAR                   PIncData                                     CER059
     C                   CLEAR                   PCurData                                     CER059
      *                                                                                       CER059
     C                   CALLB     'APDTASUBS'                                                CER059
      *                             =========                                                 CER059
      ** Return Code                                                                          CER059
     C                   PARM      *BLANKS       RetCodeOut                                   CER059
      *                                                                                       CER059
      ** Substitution Character                                                               CER059
     C                   PARM                    GHSUBS                                       CER059
      *                                                                                       CER059
      ** Incoming Data                                                                        CER059
     C                   PARM      NwIP6AScnFmt  PIncData                                     CER059
      *                                                                                       CER059
      ** Current Data                                                                         CER059
     C                   PARM      CrIP6AScnFmt  PCurData                                     CER059
      *                                                                                       CER059
     C                   MOVEL     PIncData      NwIP6AScnFmt                                 CER059
      *                                                                                       CER059
     C                   ENDIF                                                                CER059
      *                                                                                       CER059
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSNDM_L1 - Send Error Message to Level 1 Screen             *
      *                                                               *
      *****************************************************************
      *
     C     SRSndM_L1     BEGSR
      *
      ** Reset array index.
      *
     C                   EVAL      Ex = 0
      *
      ** If error occurred in updating last transaction, display error
      ** message on screen.
      *
     C                   IF        PERRUP = 'Y'
     C                   EVAL      Ex = Ex + 1
     C                   MOVE      '*ANY'        FldNameArr(Ex)
     C                   MOVE      'FTA0120'     MsgIdArr(Ex)
     C                   MOVE      *BLANK        PERRUP
     C                   ENDIF
      *
      ** Update of last transaction is a successful Insert, display
      ** corresponding message on screen.
      *
     C                   IF        PERRUP = 'I'
     C                   EVAL      Ex = Ex + 1
     C                   MOVE      '*ANY'        FldNameArr(Ex)
     C                   MOVE      'FTA0121'     MsgIdArr(Ex)
     C                   MOVE      PPREFI        MsgDtaArr(Ex)
     C                   MOVE      *BLANK        PERRUP
     C                   MOVE      *BLANKS       PPREFI
     C                   ENDIF
      *
      ** If there are fundamental errors in this transaction, identify
      ** this fact.
      *
     C                   IF        OKACTN = 'N' or OKPREF = 'N'
     C                   EVAL      Ex = Ex + 1
     C                   MOVE      '*ANY'        FldNameArr(Ex)
     C                   MOVE      'APM0110'     MsgIdArr(Ex)
     C                   ENDIF
      *
      ** Initialise work array for error indicators.
      *
     C                   MOVEA     FTEIPY1       WEI
      *
      ** Read Incoming Payments validation error messages for
      ** Level 1 screen.
      *
     C                   EVAL      KABFIELDID = 0
      *
     C     ZATRNKD1      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message read for Level 1 screen to array
      ** and set OK flag for field to 'N'.
      *
     C                   DOW       *In99 = *Off and
     C                             ABFIELDID <= WFldOffSet2
      *
     C     ABMSGID       LOOKUP    MsgIdArr(1)                            98
      *
      ** If message already present in array, disregard it
      ** to avoid duplicate messages from being displayed.
      *
     C                   IF        *IN98 <> *On
     C                   ADD       1             Ex
     C                   MOVEL     ABFIELDNAM    FldNameArr(Ex)
     C                   MOVEL     ABMSGID       MsgIdArr(Ex)
     C                   ENDIF
      *
     C                   Z-ADD     ABFIELDID     Fx                3 0
      *                                                                                     AR572681
      ** Need to adjust Fx value because of Reference Rate field                            AR572681
      *                                                                                     AR572681
     C                   IF        Fx >= 50 and Fx < 59                                     AR572681
     C                   EVAL      Fx = Fx - 1                                              AR572681
     C                   ENDIF                                                              AR572681
      *                                                                                     AR572681
     C                   SUB       WFldOffset1   Fx
      *
     C                   IF        Fx < 1 or Fx > 60
     C                   Z-ADD     1             Fx
     C                   ENDIF
      *
     C                   MOVE      'N'           WEI(Fx)
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
     C                   ENDDO
      *
      ** Update error indicators using work array.
      *
     C                   MOVEA     WEI           FTEIPY1
      *
      ** Save error indicators and messages on Level 1 screen.
      *
     C                   MOVE      FTEIPY1       FTEIPY1x
     C                   MOVEA     FldNameArr    FldNameAr1
     C                   MOVEA     MsgIdArr      MsgIdAr1
     C                   MOVEA     MsgDtaArr     MsgDtaAr1
     C                   EVAL      ID1 = Ex
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSNDM_L2S1 - Send Error Message to Level 2 Screen 1         *
      *                                                               *
      *****************************************************************
      *
     C     SRSndM_L2S1   BEGSR
      *
      ** Reset array index.
      *
     C                   EVAL      Ex = 0
      *
      ** Initialise work array for error indicators.
      *
     C                   MOVEA     FTEIPY2       WEI
      *
      ** Read Incoming Payments validation error messages for
      ** Level 2 screen 1.
      *
     C                   EVAL      KABFIELDID = WfldOffset2
      *
     C     ZATRNKD1      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message read for Level 2 screen 1 to array and
      ** set OK flag for field to 'N'.
      *
     C                   DOW       *In99 = *Off and
     C                             ABFIELDID > WFldOffSet2 and
     C                             ABFIELDID <= WFldOffSet3
      *
     C     ABMSGID       LOOKUP    MsgIdArr(1)                            98
      *
      ** If message already present in array, disregard it
      ** to avoid duplicate messages from being displayed.
      *
     C                   IF        *IN98 <> *On
     C                   ADD       1             Ex
     C                   MOVEL     ABFIELDNAM    FldNameArr(Ex)
     C                   MOVEL     ABMSGID       MsgIdArr(Ex)
     C                   ENDIF
      *
     C                   Z-ADD     ABFIELDID     Fx
     C                   SUB       WFldOffset2   Fx
      *
     C                   IF        Fx < 1 or Fx > 60
     C                   Z-ADD     1             Fx
     C                   ENDIF
      *
     C                   MOVE      'N'           WEI(Fx)
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
     C                   ENDDO
      *
      ** Update error indicators using work array.
      *
     C                   MOVEA     WEI           FTEIPY2
      *
      ** Save error indicators and messages on Level 2 screen 1.
      *
     C                   MOVE      FTEIPY2       FTEIPY2x
     C                   MOVEA     FldNameArr    FldNameAr2
     C                   MOVEA     MsgIdArr      MsgIdAr2
     C                   MOVEA     MsgDtaArr     MsgDtaAr2
     C                   EVAL      ID2 = Ex
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSNDM_L2S2 - Send Error Message to Level 2 Screen 2         *
      *                                                               *
      *****************************************************************
      *
     C     SRSndM_L2S2   BEGSR
      *
      ** Reset array index.
      *
     C                   EVAL      Ex = 0
      *
      ** Initialise work array for error indicators.
      *
     C                   MOVEA     FTEIPY3       WEI
      *
      ** Read Incoming Payments validation error messages for
      ** Level 2 screen 2.
      *
     C                   EVAL      KABFIELDID = WfldOffset3
      *
     C     ZATRNKD1      SETLL     ZATRNERRD0
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
      ** Add error message read for Level 2 screen 2 to array and
      ** set OK flag for field to 'N'.
      *
     C                   DOW       *In99 = *Off and
     C                             ABFIELDID > WFldOffSet3
     C                             and ABFIELDID <= WFldOffSet4                 CFT014
      *
     C     ABMSGID       LOOKUP    MsgIdArr(1)                            98
      *
      ** If message already present in array, disregard it
      ** to avoid duplicate messages from being displayed.
      *
     C                   IF        *IN98 <> *On
     C                   ADD       1             Ex
     C                   MOVEL     ABFIELDNAM    FldNameArr(Ex)
     C                   MOVEL     ABMSGID       MsgIdArr(Ex)
     C                   ENDIF
      *
     C                   Z-ADD     ABFIELDID     Fx
     C                   SUB       WFldOffset3   Fx
      *
     C                   IF        Fx < 1 or Fx > 60
     C                   Z-ADD     1             Fx
     C                   ENDIF
      *
     C                   MOVE      'N'           WEI(Fx)
     C     ZATRNKD0      READE     ZATRNERRD0                             99
      *
     C                   ENDDO
      *
      ** Update error indicators using work array.
      *
     C                   MOVEA     WEI           FTEIPY3
      *
      ** Save error indicators and messages on Level 2 screen 2.
      *
     C                   MOVE      FTEIPY3       FTEIPY3x
     C                   MOVEA     FldNameArr    FldNameAr3
     C                   MOVEA     MsgIdArr      MsgIdAr3
     C                   MOVEA     MsgDtaArr     MsgDtaAr3
     C                   EVAL      ID3 = Ex
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SRSNDM_L2S3 - Send Error Message to Level 2 Screen 3         *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
      *                                                                         CFT014
     C     SRSndM_L2S3   BEGSR                                                  CFT014
      *                                                                         CFT014
      ** Reset array index.                                                     CFT014
      *                                                                         CFT014
     C                   EVAL      Ex = 0                                       CFT014
      *                                                                         CFT014
      ** Initialise work array for error indicators.                            CFT014
      *                                                                         CFT014
     C                   MOVEA     FTEIPY4       WEI                            CFT014
      *                                                                         CFT014
      ** Read Incoming Payments validation error messages for                   CFT014
      ** Level 2 screen 3.                                                      CFT014
      *                                                                         CFT014
     C                   EVAL      KABFIELDID = WfldOffset4                     CFT014
      *                                                                         CFT014
     C     ZATRNKD1      SETLL     ZATRNERRD0                                   CFT014
     C     ZATRNKD0      READE     ZATRNERRD0                             99    CFT014
      *                                                                         CFT014
      ** Add error message read for Level 2 screen 3 to array and               CFT014
      ** set OK flag for field to 'N'.                                          CFT014
      *                                                                         CFT014
     C                   DOW       *In99 = *Off and                             CFT014
     C                             ABFIELDID > WFldOffSet4                      CFT014
     C                             and ABFIELDID <= WFldOffSet5                 CFT014
      *                                                                         CFT014
     C     ABMSGID       LOOKUP    MsgIdArr(1)                            98    CFT014
      *                                                                         CFT014
      ** If message already present in array, disregard it                      CFT014
      ** to avoid duplicate messages from being displayed.                      CFT014
      *                                                                         CFT014
     C                   IF        *IN98 <> *On                                 CFT014
     C                   ADD       1             Ex                             CFT014
     C                   MOVEL     ABFIELDNAM    FldNameArr(Ex)                 CFT014
     C                   MOVEL     ABMSGID       MsgIdArr(Ex)                   CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   Z-ADD     ABFIELDID     Fx                             CFT014
     C                   SUB       WFldOffset4   Fx                             CFT014
      *                                                                         CFT014
     C                   IF        Fx < 1 or Fx > 60                            CFT014
     C                   Z-ADD     1             Fx                             CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   MOVE      'N'           WEI(Fx)                        CFT014
     C     ZATRNKD0      READE     ZATRNERRD0                             99    CFT014
      *                                                                         CFT014
     C                   ENDDO                                                  CFT014
      *                                                                         CFT014
      ** Update error indicators using work array.                              CFT014
      *                                                                         CFT014
     C                   MOVEA     WEI           FTEIPY4                        CFT014
      *                                                                         CFT014
      ** Save error indicators and messages on Level 2 screen 3.                CFT014
      *                                                                         CFT014
     C                   MOVE      FTEIPY4       FTEIPY4x                       CFT014
     C                   MOVEA     FldNameArr    FldNameAr4                     CFT014
     C                   MOVEA     MsgIdArr      MsgIdAr4                       CFT014
     C                   MOVEA     MsgDtaArr     MsgDtaAr4                      CFT014
     C                   EVAL      ID4 = Ex                                     CFT014
      *                                                                         CFT014
     C                   ENDSR                                                  CFT014
      *                                                                         CFT014
      *****************************************************************         CFT014
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SRSNDM_Marg - Send Error Message to Margin Info scrn         *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
      *                                                                         CFT014
     C     SRSndM_Marg   BEGSR                                                  CFT014
      *                                                                         CFT014
      ** Reset array index.                                                     CFT014
      *                                                                         CFT014
     C                   EVAL      Ex = 0                                       CFT014
      *                                                                         CFT014
      ** Initialise work array for error indicators.                            CFT014
      *                                                                         CFT014
     C                   MOVEA     FTEIPY5       WEI                            CFT014
      *                                                                         CFT014
      ** Read Incoming Payments validation error messages for                   CFT014
      ** Margin Info scrn.                                                      CFT014
      *                                                                         CFT014
     C                   EVAL      KABFIELDID = WfldOffset5                     CFT014
      *                                                                         CFT014
     C     ZATRNKD1      SETLL     ZATRNERRD0                                   CFT014
     C     ZATRNKD0      READE     ZATRNERRD0                             99    CFT014
      *                                                                         CFT014
      ** Add error message read for Margin Info scrn to array and               CFT014
      ** set OK flag for field to 'N'.                                          CFT014
      *                                                                         CFT014
     C                   DOW       *In99 = *Off and                             CFT014
     C                             ABFIELDID > WFldOffSet5                      CFT014
     C/COPY WNCPYSRC,FTIPAYRC17
      *                                                                         CFT014
     C     ABMSGID       LOOKUP    MsgIdArr(1)                            98    CFT014
      *                                                                         CFT014
      ** If message already present in array, disregard it                      CFT014
      ** to avoid duplicate messages from being displayed.                      CFT014
      *                                                                         CFT014
     C                   IF        *IN98 <> *On                                 CFT014
     C                   ADD       1             Ex                             CFT014
     C                   MOVEL     ABFIELDNAM    FldNameArr(Ex)                 CFT014
     C                   MOVEL     ABMSGID       MsgIdArr(Ex)                   CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   Z-ADD     ABFIELDID     Fx                             CFT014
     C                   SUB       WFldOffset5   Fx                             CFT014
      *                                                                         CFT014
     C                   IF        Fx < 1 or Fx > 60                            CFT014
     C                   Z-ADD     1             Fx                             CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C                   MOVE      'N'           WEI(Fx)                        CFT014
     C/COPY WNCPYSRC,FTIPAYRC18
     C     ZATRNKD0      READE     ZATRNERRD0                             99    CFT014
      *                                                                         CFT014
     C                   ENDDO                                                  CFT014
      *                                                                         CFT014
      ** Update error indicators using work array.                              CFT014
      *                                                                         CFT014
     C                   MOVEA     WEI           FTEIPY5                        CFT014
      *                                                                         CFT014
      ** Save error indicators and messages on Margin Info scrn.                CFT014
      *                                                                         CFT014
     C                   MOVE      FTEIPY5       FTEIPY5x                       CFT014
     C                   MOVEA     FldNameArr    FldNameAr5                     CFT014
     C                   MOVEA     MsgIdArr      MsgIdAr5                       CFT014
     C                   MOVEA     MsgDtaArr     MsgDtaAr5                      CFT014
     C                   EVAL      ID5 = Ex                                     CFT014
      *                                                                         CFT014
     C                   ENDSR                                                  CFT014
      *                                                                         CFT014
      *****************************************************************         CFT014
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRENDP - Set Program to End                                  *
      *                                                               *
      *****************************************************************
      *
     C     SREndP        BEGSR
      *                                                                                       209067
      * ONLY reduce PREF sequence number if it was incremented.                               209067
     C                   IF        FirstTime <> 'Y'                                           209067
      * Reduce Sequence number in DTAARA as number is not being used                          209067
     C     *LOCK         IN        WINPAY                                                     209067
     C                   IF        CFT151 = 'N'                                               CFT151
      *                                                                                       209067
      * Check to see if another pref has been generated by another function                   209067
      *                                                                                       209067
     C                   z-add     WWINSQ        svnum             4 0                        209067
     C                   eval      svnum = svnum + 1                                          209067
     C                   if        svnum = WINSQ                                              209067
      * No new reference has been generated - so reduce sequence number on data area.         209067
     C                   SUB       1             WINSQ                                        209067
     C                   else                                                                 209067
      * if another number has been generated, the current payment reference will be lost,     209067
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
     C                   ENDIF                                                                CFT151
     C                   ENDIF                                                                209067
      *                                                                                       209067
      *
      ** Rollback uncommitted file changes.
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
     C                   EVAL      WSCRN = 'T'
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRESETERR - Reset Error Fields                              *
      *                                                               *
      *****************************************************************
      *
     C     SRResetErr    BEGSR
      *
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   IDx
      *
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   CLEAR                   WIDx
      *
     C                   MOVE      *ALL'Y'       FTEIPY1
     C                   MOVE      *ALL'Y'       FTEIPY2
     C                   MOVE      *ALL'Y'       FTEIPY3
     C                   MOVE      *ALL'Y'       FTEIPY4                        CFT014
     C                   MOVE      *ALL'Y'       FTEIPY5                        CFT014
     C                   MOVE      *ALL'Y'       FTEIPY7                                      CSW209
     C                   MOVE      *ALL'Y'       FTEIPY8                                      CSW209
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * SRFTOS - Move file fields to screen fields                    *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
      *                                                                                       CER001
     C     SRFTOS        BEGSR                                                                CER001
      *                                                                                       CER001
     C                   MOVE      'Y'           WFIND                                        CER001
      *                                                                                       CER001
     C                   MOVEL     INORTY        #LLXORTY                                     CER001
     C                   MOVEL     INBETY        #LLXBETY                                     CER001
     C                   MOVEL     INOPCO        #LLXOPCO                                     CER001
     C                   MOVEL     INCOCO        #LLXCOCO                                     CER001
     C                   MOVEL     INIDCO        #LLXIDCO                                     CER001
     C                   MOVEL     INIDEN        #LLXIDEN                                     CER001
      *                                                                                       CER001
      ** save extension record for FTIPAY2UP                                                  CER001
      *                                                                                       CER001
     C                   MOVEL     INPREF        SINPREF                                      CER001
     C                   MOVEL     INORTY        SINORTY                                      CER001
     C                   MOVEL     INBETY        SINBETY                                      CER001
     C                   MOVEL     INOPCO        SINOPCO                                      CER001
     C                   MOVEL     INCOCO        SINCOCO                                      CER001
     C                   MOVEL     INIDCO        SINIDCO                                      CER001
     C                   MOVEL     INIDEN        SINIDEN                                      CER001
      *                                                                                       CER001
     C                   MOVE      CrDlFilFmt    NwDlFilFmt                                   CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * SRINZ - Initialize screen fields                              *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
      *                                                                                       CER001
     C     SRINZ         BEGSR                                                                CER001
      *                                                                                       CER001
     C                   MOVE      *BLANKS       WFIND                                        CER001
      *                                                                                       CER001
     C                   MOVE      *BLANKS       #LLXORTY                                     CER001
     C                   MOVE      WWCUTY        #LLXBETY                                     CER001
     C                   MOVE      *BLANKS       #LLXOPCO                                     CER001
     C                   MOVE      *BLANKS       #LLXCOCO                                     CER001
     C                   MOVE      *BLANKS       #LLXIDCO                                     CER001
     C                   MOVE      *BLANKS       #LLXIDEN                                     CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      *  SRUPDEXT - Update Extension Fields                           *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
      *                                                                                       CER001
     C     SRUPDEXT      BEGSR                                                                CER001
      *                                                                                       CER001
     C                   CALLB     'FTIPAY2UP'                                                CER001
     C                   PARM      DDACTN        ACTION                                       CER001
     C                   PARM      *BLANK        RetCodeOut                                   CER001
     C                   PARM                    WFIND                                        CER001
     C                   PARM                    NwDlFilFmt                                   CER001
     C                   PARM                    CrDlFilFmt                                   CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
      *                                                                                       CER001
      *****************************************************************                       CER001
      /EJECT                                                                                  CER001
      *****************************************************************                       CER001
      *                                                               *                       CER001
      * SREND - Exit from program                                     *                       CER001
      *                                                               *                       CER001
      *****************************************************************                       CER001
      *                                                                                       CER001
     C     SREND         BEGSR                                                                CER001
      *                                                                                       CER001
      ** Call pgm once more just to close files                                               CER001
      *                                                                                       CER001
     C                   CALL      'IL0421'                                                   CER001
     C                   PARM                    P@CURR                                       CER001
     C                   PARM                    P@TYPE                                       CER001
     C                   PARM                    P@LINE                                       CER001
     C                   PARM      9             P@OPCL                                       CER001
     C                   PARM                    P@ACCD                                       CER001
     C                   PARM                    P@CUST                                       CER001
     C                   PARM                    P@FOUND                                      CER001
      *                                                                                       CER001
     C                   CLOSE     FTIIPLX1L0                                                 CER001
      *                                                                                       CER001
     C                   ENDSR                                                                CER001
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
      ** Receive dummy entry parameters.
      *
     C     *ENTRY        PLIST
      *
      ** Action Code
     C                   PARM                    PDParACTN         1
      *
      ** Payment Reference
     C                   PARM                    PDParPREF        15
      *
      ** Return Code
     C                   PARM                    PDParRTCD         1
      *
      ** Linked Maintenance
     C                   PARM                    PDParLINK         1
      *
      ** Entry Level
     C                   PARM                    PDParLEVEL        1
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
      ** Access API ICD details.
      *
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Database error.
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDAPIPD'     DBFILE
     C                   Z-ADD     005           DBASE
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
     C                   Z-ADD     006           DBASE
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
     C                   Z-ADD     007           DBASE
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
     C                   Z-ADD     008           DBASE
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
     C                   Z-ADD     009           DBASE
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
     C                   Z-ADD     010           DBASE
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
     C                   Z-ADD     011           DBASE
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
     C                   Z-ADD     012           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CFT003            1
     C                   ELSE
     C                   MOVEL     'N'           CFT003
     C                   ENDIF
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
     C                   Z-ADD     017           DBASE
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
     C                   Z-ADD     018           DBASE
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
     C                   Z-ADD     019           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CGL009            1
     C                   ELSE
     C                   MOVEL     'N'           CGL009
     C                   ENDIF
      *                                                                         CFT014
      ** Access SAR file to determine if CFT014 (STP Phase MT103)               CFT014
      ** is installed.                                                          CFT014
      *                                                                         CFT014
     C                   CALLB     'AOSARDR0'                                   CFT014
     C                   PARM      *BLANKS       PRTCD                          CFT014
     C                   PARM      '*VERIFY'     POPTN                          CFT014
     C                   PARM      'CFT014'      PSARD                          CFT014
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT014
      *                                                                         CFT014
      ** An NRF (No Record Found) return code is valid.                         CFT014
      ** Issue database error only for error return codes.                      CFT014
      *                                                                         CFT014
     C     PRTCD         IFNE      *BLANKS                                      CFT014
     C     PRTCD         ANDNE     '*NRF   '                                    CFT014
     C                   MOVEL     'CFT014'      DBKEY                          CFT014
     C                   MOVEL     'SCSARDPD'    DBFILE                         CFT014
     C                   Z-ADD     021           DBASE                          CFT014
     C                   EXSR      *PSSR                                        CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
     C     PRTCD         IFEQ      *BLANK                                       CFT014
     C                   MOVEL     'Y'           CFT014            1            CFT014
     C                   ELSE                                                   CFT014
     C                   MOVEL     'N'           CFT014                         CFT014
     C                   ENDIF                                                  CFT014
     C/COPY WNCPYSRC,FTIPAYRC14
      *                                                                                       CFT151
      ** Access SAR file to determine if CFT151 is ON                                         CFT151
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
     C                   Z-ADD     021           DBASE                                        CFT151
     C                   EXSR      *PSSR                                                      CFT151
     C                   ENDIF                                                                CFT151
      *                                                                                       CFT151
     C     PRTCD         IFEQ      *BLANK                                                     CFT151
     C                   MOVEL     'Y'           CFT151            1                          CFT151
     C                   ELSE                                                                 CFT151
     C                   MOVEL     'N'           CFT151                                       CFT151
     C                   ENDIF                                                                CFT151
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
     C                   Z-ADD     022           DBASE                          CFT009
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
     C                   Z-ADD     023           DBASE                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
     C     PRTCD         IFEQ      *BLANK                                       CFT009
     C                   MOVEL     'Y'           CFT010            1            CFT009
     C                   ELSE                                                   CFT009
     C                   MOVEL     'N'           CFT010                         CFT009
     C                   ENDIF                                                  CFT009
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
     C                   EVAL      DBASE = 24                                                 CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *BLANKS                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
                                                                                              CSC011
     C                   OPEN      APILOGL0                                                   CSC011
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
     C                   Eval      DBPgm  = 'FTIPAYRPR'                                       CSC022
     C                   Eval      DBKey  = 'CSC022'                                          CSC022
     C                   Eval      DBase  = 900                                               CSC022
     C                   Out       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
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
     C                   EVAL      DBASE  = 25                                                CGL014
     C                   EXSR      *PSSR                                                      CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        PRTCD = *BLANKS                                            CGL014
     C                   EVAL      CGL014 = 'Y'                                               CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      CGL014 = 'N'                                               CGL014
     C                   ENDIF                                                                CGL014
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
     C                   EVAL      DBASE  = 41                                                CSC024
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
     C                   EVAL      DBase = 42                                                 CSC024
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
     C/COPY WNCPYSRC,FTH00144
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
     C                   Z-ADD     043           DBASE                                        CER030
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
     C                   Z-ADD     044           DBASE                                        CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRTCD = *BLANKS                                            CER030
     C                   EVAL      CER031 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CER031 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** CGL013 - SWIFT Feature                                                               CER030
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
     C                   Z-ADD     045           DBASE                                        CER030
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
     C                   Z-ADD     046           DBASE                                        CFT120
     C                   EXSR      *PSSR                                                      CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   IF        PRTCD = *BLANKS                                            CFT120
     C                   EVAL      CFT120 = 'Y'                                               CFT120
     C                   ELSE                                                                 CFT120
     C                   EVAL      CFT120 = 'N'                                               CFT120
     C                   ENDIF                                                                CFT120
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
     C                   EVAL      DBASE = 020
     C                   EXSR      *PSSR
     C                   ENDIF
     C/COPY WNCPYSRC,FTIPAYRC10
      *
      ** If S01499 is installed, retrieve VAT Rate.
      ** OR if CFT010 is installed                                              CFT009
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
     C                   Z-ADD     013           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ELSE                                                                 203738
     C                   Z-ADD     0             PVATR                                        203738
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
     C                   Z-ADD     014           DBASE
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
     C                   Z-ADD     015           DBASE
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
     C                   Z-ADD     016           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        PLCDP             1 0
     C     A6MDIN        IFEQ      'M'
     C                   Z-ADD     1             PLMDIN            1 0
     C                   ELSE
     C                   Z-ADD     0             PLMDIN
     C                   ENDIF
     C/COPY WNCPYSRC,FTIPAYRC29
     C                   Z-ADD     A6SPRT        PLSPOT           13 8
     C/COPY WNCPYSRC,FTIPAYRC30
      *
      ** Retrieve ZMUSER details.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
      *
      ** Get the field number for the first field in Level 1 screen.
      ** Subtract one from it to give the value to subtract from each
      ** field's number.
      *
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    PFormat
     C                   PARM                    PField1
     C                   PARM                    PFieldNo
      *
     C                   IF        RetCodeOut = *BLANKS
     C                   EVAL      WFldOffset1 = PFieldNo - 1
      *
      ** If there was an error, default the offset to 13.
      *
     C                   ELSE
     C                   EVAL      WFldOffset1 = 13
     C                   ENDIF
      *
      ** Get the field number for the first field in Level 2 screen 1.
      ** Subtract one from it to give the value to subtract from each
      ** field's number.
      *
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    PFormat
     C                   PARM                    PField2
     C                   PARM                    PFieldNo
      *
     C                   IF        RetCodeOut = *BLANKS
     C                   EVAL      WFldOffset2 = PFieldNo - 1
     C                   ENDIF
      *
      ** Get the field number for the first field in Level 2 screen 2.
      ** Subtract one from it to give the value to subtract from each
      ** field's number.
      *
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM      *BLANKS       RetCodeOut
     C                   PARM                    PFormat
     C                   PARM                    PField3
     C                   PARM                    PFieldNo
      *
     C                   IF        RetCodeOut = *BLANKS
     C                   EVAL      WFldOffset3 = PFieldNo - 1
     C                   ENDIF
      *                                                                         CFT014
      ** Get the field number for the first field in Level 2 screen 3.          CFT014
      ** Subtract one from it to give the value to subtract from each           CFT014
      ** field's number.                                                        CFT014
      *                                                                         CFT014
     C                   CALLB     'ZACGTFLDNO'                                 CFT014
     C                   PARM      *BLANKS       RetCodeOut                     CFT014
     C                   PARM                    PFormat                        CFT014
     C                   PARM                    PField4                        CFT014
     C                   PARM                    PFieldNo                       CFT014
      *                                                                         CFT014
     C                   IF        RetCodeOut = *BLANKS                         CFT014
     C                   EVAL      WFldOffset4 = PFieldNo - 1                   CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Get the field number for the first field in Margin Info scrn.          CFT014
      ** Subtract one from it to give the value to subtract from each           CFT014
      ** field's number.                                                        CFT014
      *                                                                         CFT014
     C                   CALLB     'ZACGTFLDNO'                                 CFT014
     C                   PARM      *BLANKS       RetCodeOut                     CFT014
     C                   PARM                    PFormat                        CFT014
     C                   PARM                    PField5                        CFT014
     C                   PARM                    PFieldNo                       CFT014
      *                                                                         CFT014
     C                   IF        RetCodeOut = *BLANKS                         CFT014
     C                   EVAL      WFldOffset5 = PFieldNo - 1                   CFT014
     C                   ENDIF                                                  CFT014
      *
      ** Define Key Lists.
      *
     C     ZATRNKD0      KLIST
     C                   KFLD                    PFOTRANSEL
     C                   KFLD                    PTMESTPSEL
      *
     C     *LIKE         DEFINE    ABFIELDID     KABFIELDID
      *
     C     ZATRNKD1      KLIST
     C                   KFLD                    PFOTRANSEL
     C                   KFLD                    PTMESTPSEL
     C                   KFLD                    KABFIELDID
      *
     C     ZATRNKX0      KLIST
     C                   KFLD                    PTMESTPSEL
     C                   KFLD                    PFOTRANSEL
      *                                                                                       CSC011
     C     KLOGL0        KLIST                                                                CSC011
     C                   KFLD                    KMTYP                                        CSC011
     C                   KFLD                    PFOTRANSEL                                   CSC011
     C                   KFLD                    PTMESTPSEL                                   CSC011
      *                                                                                       CER001
     C     *LIKE         DEFINE    INPREF        K@PREF                                       CER001
      *                                                                                       CER001
     C     K@KEY         KLIST                                                                CER001
     C                   KFLD                    K@PREF                                       CER001
      *
      ** Initialise error fields.
      *
     C                   EXSR      SRResetErr
      *
      ** Display Browse screen.
      *
     C                   MOVE      'B'           WSCRN             1
      *
      * Initialise flag to show first time through                                            209067
     C                   MOVE      'Y'           FirstTime         1                          209067
      *                                                                                       209067
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      *
      /COPY WNCPYSRC,FTIPAYR014
      *                                                                                       CER001
      ** ULX043 - New IBLC 2002 as Feature                                                    CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX043            1                          CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX043'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS                                            CER001
     C                   MOVEL     'Y'           ULX043                                       CER001
      *                                                                                       CER001
      ** Do not process lux extension details when IBLC Returns indicator is                  CER001
      ** not set to 'Y'                                                                       CER001
      *                                                                                       CER001
     C                   IF         BGNWST <> 'Y'                                             CER001
     C                   EVAL       ULX043 = 'N'                                              CER001
     C                   ELSE                                                                 CER001
     C                   OPEN      FTIPX1L0                                                   CER001
     C                   OPEN      FTIIPLX1L0                                                 CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS AND                                       CER001
     C                             @RTCD <> '*NRF   '                                         CER001
     C                   EVAL      DBKEY = 'ULX043'                                           CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBASE  = 017                                               CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
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
**  CPY@
(c) Finastra International Limited 2001
