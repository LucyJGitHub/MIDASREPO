     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Incoming payments interface controller')      *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAYCTL - Incoming Payments Interface Controller           *
      *                                                               *
      *  Function: This module validates Incoming Payments for input  *
      *            into the Midas database.                           *
      *            Processes to be executed controlled by input       *
      *            Action Code:                                       *
      *            - For I (=INSERT) or A (=AMEND), validate the      *
      *              Incoming Payment.                                *
      *            - For A (=AMEND),                                  *
      *              - if transaction is a partial amendment, call a  *
      *                separate function to complete the transaction  *
      *                details.                                       *
      *              - if transaction is valid, call a separate       *
      *                function to check whether it is a valid        *
      *                amendment.                                     *
      *            - For D (=DELETE), call a separate function to     *
      *              process the transaction and bypass the rest of   *
      *              the validation.                                  *
      *                                                               *
      *            For all Action Codes, the decision as to whether   *
      *            to write to the Valid or Invalid file and the call *
      *            to the Message Handler (ZAMSGHNDLE) will take      *
      *            place in this module.                              *
      *                                                               *
      *  Component of: FTIPAYCTL                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD047369A          Date 24Jan18               *      
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR1090283          Date 10Aug16               *
      *                 MD025111           Date 24Feb14               *
      *                 CFT151             Date 21Mar14               *
      *                 CFT120             Date 28Sep12               *
      *                 CSC054             Date 23Feb12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR787620           Date 10Jun11               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 257897             Date 26Nov08               *
      *                 256564             Date 17Sep08               *
      *                 250600             Date 30Sep07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CER001             Date 25Apr05               *
      *                 BUG9105            Date 22Jul05               *
      *                 BUG7101            Date 05Jul05               *
      *                 CSC024             Date 07Feb05               *
      *                 CFT115             Date 01Jul04               *
      *                 TDA006             Date 16Mar04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001             Date 09Dec03               *
      *                 222373             Date 28Oct03               *
      *                 CAP084             Date 25Aug03               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *                 199992             Date 09Nov01               *
      *                 CSC011             Date 18Sep01               *
      *                 197220             Date 11Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
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
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CSC054 - Period End Adjustments                              *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,FTH00039                                 *
      *             WNCPYSRC,FTH00040                                 *
      *             WNCPYSRC,FTH00041                                 *
      *             WNCPYSRC,FTH00042                                 *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature                            *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  257897 - Pass transaction reference on reply.                *
      *           Apply client fix 250881                             *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  250600 - Fix to CFT032                                       *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  BUG9105 - CGL014 parameter to FTIPAY1VL missing.             *
      *  BUG7101 - DB error in AOSPOSU0 due to blank INTRIT. Ensure   *
      *            fields are properly initialised.  Applied core fix *
      *            216842.                                            *
      *  CSC024 - Open Month End                                      *
      *  CFT115 - Core changes for GBO015.                            *
      *         - Incoming Payments Beneficiary Validation            *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:FTIPAYC002                       *
      *           Core hooks added:FTIPAYCC15                         *
      *  TDA006 - Correct 10-digit full account processing.           *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CGP001 - Recompiled due to change in FTV2OPYPD               *
      *  222373 - Correct parameters on program calls                 *
      *  CAP084 - Thin Client API Wrappers                            *
      *           Recompiled over changed FTIPY6PD.                   *
      *  199992 - Timestamp of extension file FTVIPY2PD not updated   *
      *           when action is 'A' or 'D' resulting to DBERR 9 in   *
      *           FTIPAYUPC and error calling FTIPAY4VL due to        *
      *           incomplete parameters passed.                       *
      *  CSC011 - 24x7 Midas Availability                             *
      *  197220 - DB error because of DS Val@Fields not addressable,  *
      *           Pointer not set for location. Fix 187056 introduced *
      *           new parameter in FTIPAY3DT but parameter list of    *
      *           this module was not amended.                        *
      *  CFT009 - Funds Transfer Fees and Charges                     *
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
      ** Valid Incoming Payments
     FFTVIPAYPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *                                                                         CFT014
      ** Valid Incoming Payments Extension file                                 CFT014
     FFTVIPY2PD UF A E             DISK    INFSR(*PSSR)                         CFT014
     F                                     COMMIT                               CFT014
      *
      ** Invalid Incoming Payments
     FFTIIPAYPD UF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
      *
      ** Valid Incoming Payments by Front Office Id
     FFTVIPAYL0 IF   E           K DISK    RENAME(FTVIPAYD0:FTVIPAYCHK)
      *
      ** Valid Incoming Payments by Payment Reference and Timestamp
     FFTVIPAYL1 IF   E           K DISK    RENAME(FTVIPAYD0:FTVIPAYCHM)
     F/COPY WNCPYSRC,FTH00120
      *
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,FTIPAYC001
     FFTVIPLX1PDUF A E             DISK    USROPN                                             CER001
      *                                                                                       CER001
      ** Midas IBLC 2002 FT IPAY - Valid File - LU Window                                     CER001
      *                                                                                       CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
                                                                                              CER001
     FFTIIPLX1PDUF A E             DISK    USROPN                                             CER001
      *                                                                                       CER001
      ** Midas IBLC 2002 FT IPAY - Invalid File - LU Window                                   CER001
      *                                                                                       CER001
     F                                     INFSR(*pssr)                                       CER001
     F                                     COMMIT                                             CER001
                                                                                              CER001
     FSDCUX1L0  IF   E           K DISK    USROPN                                             CER001
      *                                                                                       CER001
      ** IBLC 2002 Customer Details                       Prefix CU                           CER001
      *                                                                                       CER001
      ** Network Transaction Identifier File                                                  CER030
      *                                                                                       CER030
     FSDNTTIL1  IF   E           K DISK    INFSR(*PSSR)                                       CER030
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
      ** The following /COPY line includes definition  for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
      *
      /COPY ZACPYSRC,PROCPARMS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes the definitions for arrays
      ** specific to API *CTL modules.
      *
      /COPY ZACPYSRC,APICTLARR
      *
      ** The following /COPY line includes the definitions for fields
      ** used in checking whether there are messages on the data queue.
      *
      /COPY ZACPYSRC,DTAQCHKDCL
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
      ** String for error messages to the operator
     D WProcErr        C                   CONST('Error in module')
      ** String for System Values Array                                                       CSC024
     D*SysValOME       C                   CONST('OMEIndicator')                       CSC024 CSC054
     D SysValPEA       C                   CONST('PEAIndicator')                              CSC054
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Work array for setting up new Payment Reference
     D WYA1            S              1    DIM(18)
                                                                                              199992
      ** Work array for warning message Ids                                                   199992
     D WPrvWarnAr      S                   Dim(ArrayMax)                                      199992
     D                                     Like(WMsgIDArr)                                    199992
      ** Commitment Control Job Array                                                         CSC022
     D WJobs           S             10A   Dim(10)                                            CSC022
      **                                                                                      CSC022
      *
      ** Message Header details
     D PHeadIn       E DS                  EXTNAME(APHEADPD)
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     D NwIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 Scrn 1/2 details from incoming tran-           CFT014
      ** saction - screen format                                                CFT014
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
      ** Incoming Payments Lvl 2 Scrn 2/2 details from incoming tran-           CFT014
      ** saction - screen format                                                CFT014
     D NwIP4aScnFmt  E DS                  EXTNAME(FTIPY4APD)                   CFT014
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming tran-             CFT014
      ** saction - screen format                                                CFT014
     D NwIP5ScnFmt   E DS                  EXTNAME(FTIPY5PD)                    CFT014
      *                                                                         CFT014
      ** Incoming Payments Margin Info details from incoming tran-              CFT014
      ** saction - screen format                                                CFT014
     D NwIP6ScnFmt   E DS                  EXTNAME(FTIPY6PD)                    CFT014
     D SDDSWTN       E                     EXTFLD(DDSWTN)                                     CAP084
     D SDDSEQNO      E                     EXTFLD(DDSEQNO)                                    CAP084
      *                                                                                       CSW209
      ** Incoming Payments API Cover Messages Format Definition -                             CSW209
      ** screen formmat                                                                       CSW209
     D NwIP7ScnFmt   E DS                  EXTNAME(FTIPY7PD)                                  CSW209
     D NwIP8ScnFmt   E DS                  EXTNAME(FTIPY8PD)                                  CSW209
      *                                                                                       CSW209
      *                                                                                       CER030
      ** Incoming Payments Extended Narratives from incoming tran-                            CER030
      ** saction - screen format                                                              CER030
      *                                                                                       CER030
     D NwIP6AScnFmt  E DS                  EXTNAME(FTIPY6APD)                                 CER030
      *
      ** Incoming Payments for file update - file format
     D NwIPFilFmt    E DS                  EXTNAME(FTVIPAYPD)
     D/COPY WNCPYSRC,FTH00121
      *                                                                         CFT014
      ** Incoming Payments (additional details) for file update - file format   CFT014
     D NwIP2FilFmt   E DS                  EXTNAME(FTVIPY2PD)                   CFT014
     D/COPY WNCPYSRC,FTH00122
      *
      ** Incoming Payments Lvl 1 Scrn details retrieved from file
      ** - screen format
     D CrIP1ScnFmt   E DS                  EXTNAME(FTIPY1PD)
     D                                     PREFIX(O)
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 Scn 1/2 details retrieved from file            CFT014
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
      ** Incoming Payments Lvl 2 Scn 2/2 details retrieved from file            CFT014
      ** - screen format                                                        CFT014
     D CrIP4aScnFmt  E DS                  EXTNAME(FTIPY4APD)                   CFT014
     D                                     PREFIX(O)                            CFT014
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scn 3 details retrieved from file              CFT014
      ** - screen format                                                        CFT014
     D CrIP5ScnFmt   E DS                  EXTNAME(FTIPY5PD)                    CFT014
     D                                     PREFIX(O)                            CFT014
      *                                                                         CFT014
      ** Incoming Payments Margin Info details retrieved from file              CFT014
      ** - screen format                                                        CFT014
     D CrIP6ScnFmt   E DS                  EXTNAME(FTIPY6PD)                    CFT014
     D                                     PREFIX(O)                            CFT014
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 7 details retrieved from file                           CSW209
      ** - screen format                                                                      CSW209
     D CrIP7ScnFmt   E DS                  EXTNAME(FTIPY7PD)                                  CSW209
     D                                     PREFIX(O)                                          CSW209
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 7 details retrieved from file                           CSW209
      ** - screen format                                                                      CSW209
     D CrIP8ScnFmt   E DS                  EXTNAME(FTIPY8PD)                                  CSW209
     D                                     PREFIX(O)                                          CSW209
      *                                                                                       CER030
      ** Incoming Payments Extended Narratives retrieved from file                            CER030
      ** - screen format                                                                      CER030
      *                                                                                       CER030
     D CrIP6AScnFmt  E DS                  EXTNAME(FTIPY6APD)                                 CER030
     D                                     PREFIX(O)                                          CER030
      *
      ** Incoming Payments retrieved from file - file format
     D CrIPFilFmt    E DS                  EXTNAME(INPAYDD)
      *                                                                         CFT014
      ** Incoming Payments (additional details) retrieve from file              CFT014
      ** - file format                                                          CFT014
     D CrIP2FilFmt   E DS                  EXTNAME(INPAYXPD)                    CFT014
                                                                                CFT009
      ** Valid Incoming Payments Extension File (default)                       CFT009
     D DEFVALIDX     E DS                  EXTNAME(FTVIPY2PD)                   CFT009
     D                                     PREFIX(D#)                           CFT009
                                                                                CFT009
      * Valid Payments layout (default)                                         CFT009
     D DEFVALID      E DS                  EXTNAME(FTVIPAYPD)                   CFT009
     D                                     PREFIX(D#)                           CFT009
     D/COPY WNCPYSRC,FTH00123
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
      ** Incoming Payments API Cover Messages Format Definition                               CSW209
      ** Info error indicators                                                                CSW209
     D FTEIPY7       E DS                  EXTNAME(FTEIPY7PD)                                 CSW209
     D FTEIPY8       E DS                  EXTNAME(FTEIPY8PD)                                 CSW209
      *
      ** Incoming Payments extra data
     D PExtData      E DS                  EXTNAME(FTIPEXPD)
     D PRegData      E DS                  EXTNAME(FTIPRXPD)                                  CER001
     D/COPY WNCPYSRC,FTH00124
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
      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
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
      *                                                                                       CFT120
      ** Variable for storing Previous value                                                  CFT120
      *                                                                                       CFT120
     D  PPrvCDRC       S              3A                                                      CFT120
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
      ** Indices for arrays used to set up corresponding sequence numbers
      ** for the fields that are in error
      *
     D W1              S              3P 0
     D W2              S              3P 0
      *
      ** Index for arrays of error message Ids in Amend Validation
     D AMIDx           S              3P 0
      *                                                                                      CSF011A
      ** Fields (1000A) to receive the incoming transaction                                  CSF011A
     D PTrans01        S           1000A                                                     CSF011A
     D PTrans03        S           1000A                                                     CSF011A
     D PTrans05        S           1000A                                                     CSF011A
      *
      ** Fields (500A) to receive the incoming transaction
     D PTrans5001      S            500A
     D PTrans5002      S            500A
     D PTrans5003      S            500A
     D PTrans5004      S            500A
     D PTrans5005      S            500A                                        CFT014
     D PTrans5006      S            500A                                        CFT014
     D PTrans5007      S            500A                                        CFT014
     D PTrans5008      S            500A                                        CFT014
     D PTrans5009A     S           1000A                                                      CSW209
     D PTrans5009B     S           1000A                                                      CSW209
     D PTrans5009      S            500A                                                      CER030
      *
      ** Field (500A) to receive the incoming extra data
     D PExtData500     S            500A
     D PRegData500     S            500A                                                      CER001
      *
      ** Timestamp for the transaction
     D PTimestamp      S               Z
      *
      ** Fields to be used on call to module APCALOBJ (Allocate Object API)
     D PObject         S             10A   INZ('FTIPAYUPC')
     D PLib            S             10A   INZ('*LIBL')
     D PObjType        S              7A
     D PLockState      S              7A   INZ('*SHRRD')
     D PMember         S             10A
     D PWaitTime       S              6A   INZ('0     ')
     D PDlcObj         S              1A   INZ('Y')
     D PReturn         S              7A
      *
      ** Module Id to be passed to the message handler
     D PModuleId       S              2A   INZ('FT')
      *
      ** Whether or not to clear the program message queue (this is not
      ** actually used, but is required by the message handler's parameter
      ** list)
     D PClrPgmMsgQ     S              1A   INZ('Y')
      *
      ** Overall Transaction status, to be passed to the message handler
     D PTranStatus     S              1A
      *
      ** Dummy message Id and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D PDummyMsgId     S                   LIKE(#MsgID)
     D PDummyMsgF      S             10A
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair Function)
      ** Mode = '*SIN  ' (Screen Input Function)
     D PMode           S              6A
      *
      ** Entry Point
     D PParmLEVEL      S              1A   INZ('1')
      *
      ** Linked Program
     D PLinkPgm        S             10A   INZ(*BLANKS)
                                                                                              CSC011
      ** 24X7 Midas Availability switchable field                                             CSC011
     D CSC011          S              1A                                                      CSC011
                                                                                              CSC011
      ** Transaction Detail Field                                                             CSC011
     D TRANSDTL        S           5800A                                                      CSC011
                                                                                              CSC011
      ** Transaction Reference                                                                CSC011
     D PREFERENCE      S             18A                                                      CSC011
     D PAREFERENCE     S             18A                                                      CSC011
                                                                                              CSC011
      ** Processing Date                                                                      CSC011
     D PPROCDTE        S              5  0                                                    CSC011
     D PPRDATE         S              6  0                                                    CSC011
     D PPRADATE        S              7                                                       CSC011
                                                                                              CSW209
      ** CSW209 other variables                                                               CSW209
     D WSubIP7         S              1A                                                      CSW209
     D WSubIP8         S              1A                                                      CSW209
     D CSW209          S              1A                                                      CSW209
                                                                                              CGL029
     D PPrvCDRO        S             18A                                                      CGL029
      ** CSC022 work fields                                                                   CSC022
     D WArrPtr         S              3S 0                                                    CSC022
     D WSkpComtRolbk   S              1A                                                      CSC022
      **                                                                                      CSC022
      ** CSC022 switchable field                                                              CSC022
     D CSC022          S              1A                                                      CSC022
      **                                                                                      CSC022
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,FTIPAYC002
      *                                                                                       CER001
      ** Valid Extended Incoming payments in File Format                                      CER001
      *                                                                                       CER001
     D ValidFilExtL  E DS                  EXTNAME(FTVIPLX1PD)                                CER001
                                                                                              CER001
      *                                                                                       CER001
      ** Errors Indicators Extended Fields                                                    CER001
      *                                                                                       CER001
     D OkFlagsExtL   E DS                  EXTNAME(FTEIPLX1PD)                                CER001
      *                                                                                       CER001
      ** Define parameters for call pgm                                                       CER001
      *                                                                                       CER001
     D @CURR           S              3A                                                      CER001
     D @TYPE           S              1A                                                      CER001
     D @LINE           S             35                                                       CER001
     D @OPCL           S              1  0                                                    CER001
     D @ACCD           S             10A                                                      CER001
     D @CUST           S              6A                                                      CER001
     D @FOUND          S              1A                                                      CER001
                                                                                              CER001
      *                                                                                       CER001
      ** Define working field                                                                 CER001
      *                                                                                       CER001
     D WWCUTY          S              2A                                                      CER001
     D ULX611          S              1A                                                      CER001
     D ULX043          S              1A                                                      CER001
     D CGL014          S              1A                                                     BUG9105
     D WWINSQ          S              4  0                                                    CER001
     D PDayNo          S              5  0                                                    CER001
     D PFMT            S              1A                                                      CER001
     D PDate           S              6  0                                                    CER001
     D PADate          S              7A                                                      CER001
     D WN2             S              2  0                                                    CER001
     D WA4             S              4A                                                      CER001
     D WA2             S              2A                                                      CER001
     D WA6             S              6A                                                      CER001
     D IA              S              2  0                                                    CER001
      *                                                                                       CER030
     D CER030          S              1A                                                      CER030
     D CGL013          S              1A                                                      CER030
     D KTtcd           S             10A                                                      CER030
      *
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
      *                                                                                       CER001
     D CSC054          S              1A                                                      CSC054
      *                                                                                       CSC054
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
      /COPY WNCPYSRC,FTIPAYC003
      *
      ** Incoming transaction is in 500A fields, so that a common
      ** CLP can be used between this module and the one that
      ** read the MQ queue.  Break the 500A data by loading
      ** them into the appropriate (externally-described)
      ** data structures.
      *
     C**********         MOVEL     PTrans5001    NwIP1ScnFmt                                 CSF011A
     C                   MOVEL     PTrans01      NwIP1ScnFmt                                 CSF011A
     C***********        MOVEL     PTrans5002    NwIP2ScnFmt                    CFT014
     C***********        MOVEL     PTrans5003    NwIP3ScnFmt                    CFT014
     C***********        MOVEL     PTrans5004    NwIP4ScnFmt                    CFT014
     C                   MOVEL     PTrans5002    NwIP1aScnFmt                   CFT014
     C***********        MOVEL     PTrans5003    NwIP2ScnFmt                          CFT014 CSF011A
     C                   MOVEL     PTrans03      NwIP2ScnFmt                                 CSF011A
     C                   MOVEL     PTrans5004    NwIP3ScnFmt                    CFT014
     C***********        MOVEL     PTrans5005    NwIP4ScnFmt                          CFT014 CSF011A
     C                   MOVEL     PTrans05      NwIP4ScnFmt                                 CSF011A
     C                   MOVEL     PTrans5006    NwIP4aScnFmt                   CFT014
     C                   MOVEL     PTrans5007    NwIP5ScnFmt                    CFT014
     C                   MOVEL     PTrans5008    NwIP6ScnFmt                    CFT014
      *                                                                                       CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   MOVEL     PTrans5009A   NwIP7ScnFmt                                  CSW209
     C                   MOVEL     PTrans5009B   NwIP8ScnFmt                                  CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   MOVEL     PTrans5009    NwIP6AScnFmt                                 CER030
     C                   MOVEL     PExtData500   PExtData
     C                   MOVEL     PRegData500   PRegData                                     CER001
      *
      ** Generate a Timestamp for this transaction.
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    PTimestamp
      *
      ** Reset fields.
      *
     C                   EXSR      SRResetFld
      *
      /COPY WNCPYSRC,FTIPAYC004
      *
      ** Check if valid Incoming Payment exists for Front Office Id
      ** in the Valid Records file.
      *
     C                   EXSR      SRChkValTran
      *
      ** If valid Incoming Payment does exist even after delay,
      ** fail this input.
      *
     C     IDx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF
      *
      ** Check if valid Incoming Payment exists for Midas Payment Reference.
      *
     C                   EXSR      SRChkValMTran
      *
      ** If valid Incoming Payment does exist even after delay,
      ** fail this input.
      *
     C     Idx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF
      *
      ** Reset fields again in case the details have been corrupted
      ** by previous chain to valid Incoming Payments file.
      *
     C                   EXSR      SRResetFld
      *
      /COPY WNCPYSRC,FTIPAYC005
      *
      ** Validate Action Code versus the Payment Reference supplied.
      ** Original Incoming Payment details are retrieved during the
      ** validation process.
      *
     C                   EXSR      SRValAction
      *
      /COPY WNCPYSRC,FTIPAYC006
      *
      ** If errors occurred in the initial validation, fail this input.
      *
     C     IDx           IFNE      0
     C                   GOTO      INVALID
     C                   ENDIF
      *
      ** Processing depends upon Action Code.
      *
     C                   SELECT
      *
      ** INSERT
      ** ======
      *
     C                   WHEN      DDACTN = 'I'
      *
      /COPY WNCPYSRC,FTIPAYC007
      *
      ** Validate incoming Incoming Payment details.
      *
     C                   EXSR      SRValDetails
      *
      /COPY WNCPYSRC,FTIPAYC008
      *
      ** AMEND
      ** =====
      *
     C                   WHEN      DDACTN = 'A'
      *
      /COPY WNCPYSRC,FTIPAYC009
      *
      ** Convert original Incoming Payment details from file
      ** to screen format.
      *
     C                   EXSR      SRCvtPref
      *
      /COPY WNCPYSRC,FTIPAYC010
      *
      ** Check for the existence of the replacement character; if this is
      ** used, only the changed data has been sent, and all occurrences of
      ** the replacement character must be replaced with the corresponding
      ** character from the original transaction.
      *
     C                   IF        GHSUBS <> *BLANK
      *
     C     GHSUBS        SCAN      NwIP1ScnFmt                            99
      *
     C                   IF        *IN99
     C                   MOVE      'Y'           WSubIP1           1
     C                   ELSE
     C                   MOVE      'N'           WSubIP1
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
      *
     C                   IF        *IN99
     C                   MOVE      'Y'           WSubIP2           1
     C                   ELSE
     C                   MOVE      'N'           WSubIP2
     C                   ENDIF
      *
     C     GHSUBS        SCAN      NwIP3ScnFmt                            99
      *
     C                   IF        *IN99
     C                   MOVE      'Y'           WSubIP3           1
     C                   ELSE
     C                   MOVE      'N'           WSubIP3
     C                   ENDIF
      *
     C     GHSUBS        SCAN      NwIP4ScnFmt                            99
      *
     C                   IF        *IN99
     C                   MOVE      'Y'           WSubIP4           1
     C                   ELSE
     C                   MOVE      'N'           WSubIP4
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
      *                                                                                       CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
     C     GHSUBS        SCAN      NwIP7ScnFmt                            99                  CSW209
      *                                                                                       CSW209
     C                   IF        *IN99                                                      CSW209
     C                   MOVE      'Y'           WSubIP7                                      CSW209
     C                   ELSE                                                                 CSW209
     C                   MOVE      'N'           WSubIP7                                      CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C     GHSUBS        SCAN      NwIP8ScnFmt                            99                  CSW209
      *                                                                                       CSW209
     C                   IF        *IN99                                                      CSW209
     C                   MOVE      'Y'           WSubIP8                                      CSW209
     C                   ELSE                                                                 CSW209
     C                   MOVE      'N'           WSubIP8                                      CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
      *
     C***********        IF        WSubIP1 = 'Y' or WSubIP2 = 'Y' or             CFT014
     C***********                  WSubIP3 = 'Y' or WSubIP4 = 'Y'                CFT014
     C                   IF        WSubIP1 = 'Y' or WSubIP1a = 'Y' or            CFT014
     C                             WSubIP2 = 'Y' or WSubIP3 = 'Y'  or            CFT014
     C                             WSubIP4 = 'Y' or WSubIP4a = 'Y'  or           CFT014
     C**********                   WSubIP5 = 'Y' or WSubIP6 = 'Y'                      CFT014 CSW209
     C                             WSubIP5 = 'Y' or WSubIP6 = 'Y' or                          CSW209
     C                             WSubIP7 = 'Y' or WSubIP8 = 'Y'                             CSW209
      *
      ** Do data substitution.
      *
     C                   EXSR      SRDtaSubs
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTIPAYC011
      *
      ** Validate incoming Incoming Payment details.
      *
     C                   EXSR      SRValDetails
      *
      /COPY WNCPYSRC,FTIPAYC012
      *
      ** Check if amended fields are amendable.
      *
     C                   EXSR      SRValAmend
      *
      /COPY WNCPYSRC,FTIPAYC013
      *
     C                   ENDSL
      *
     C     INVALID       TAG
      *
      ** Check for exception error from any program lower in the stack.
      ** If error detected, send message to system operator and
      ** return to calling program without updating database or
      ** prompting the database update program.
      *
     C                   IN        APDUMP
      *
      /COPY WNCPYSRC,FTIPAYC014
      *
     C     ARErrMod      IFNE      *BLANK
     C                   EVAL      PMQErrLong = *BLANK
     C                   MOVEL     WProcErr      WMQError
     C                   MOVE      ARErrMod      WMQError         28
     C                   MOVEL     WMQError      PMQErrLong
      *
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    PMQReturn        10
     C                   PARM                    PMQErrLong      132
     C                   PARM                    PDummyMsgId
     C                   PARM                    PDummyMsgF
      *
     C                   MOVEL     ARErrMod      APRetCode
     C     *LOCK         IN        APDUMP
     C                   EVAL      ARErrMod = *BLANK
     C                   OUT       APDUMP
     C                   RETURN
      *
     C                   ELSE
      *
      ** Processing for error checking/write to database.
      *
      /COPY WNCPYSRC,FTIPAYC015
      *                                                                                       CER001
     C                   IF        (ULX611 = 'Y') AND (ULX043 = 'Y')                          CER001
      *                                                                                       CER001
     C                   MOVE      *ALL'Y'       OkFlagsExtL                                  CER001
      *                                                                                       CER001
      ** Set up the Payment Reference                                                         CER001
      *                                                                                       CER001
     C                   IF        (DDACTN = 'I') AND (Idx = 0)                               CER001
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
     C     1             DO        15            IA                                           CER001
     C                   IF        WYA1(IA) = ' '                                             CER001
     C                   MOVEL     '0'           WYA1(IA)                                     CER001
     C                   ENDIF                                                                CER001
     C                   ENDDO                                                                CER001
      *                                                                                       CER001
     C                   MOVEA     WYA1(1)       IPPREF                                       CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   MOVE      IPPREF        PREF1                                        CER001
      *                                                                                       CER001
      ** Validate the extension transaction details                                           CER001
      *                                                                                       CER001
     C                   IF        ((DDACTN = 'I') AND (Idx = 0)                              CER001
     C                              OR (DDACTN <> 'I'))                                       CER001
      *                                                                                       CER001
      ** Setup parameters PTYPE and PLINE to call IL0421                                      CER001
      ** with FTVIPAYPD valid file                                                            CER001
      *                                                                                       CER001
     C                   IF        (IPBNCT = 'A') OR (IPBNCT = 'S')                           CER001
     C                   MOVE      IPACBT        @TYPE                                        CER001
     C                   MOVEL     IPACBK        @LINE                                        CER001
     C                   ELSE                                                                 CER001
     C                   MOVE      IPBNCT        @TYPE                                        CER001
     C                   MOVE      IPBNC1        @LINE                                        CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   CALL      'IL0421'                                                   CER001
      *                                                                                       CER001
      ** Input                                                                                CER001
      *                                                                                       CER001
     C                   PARM      IPPCCY        @CURR                                        CER001
     C                   PARM                    @TYPE                                        CER001
     C                   PARM                    @LINE                                        CER001
     C                   PARM      0             @OPCL                                        CER001
      *                                                                                       CER001
      ** Output                                                                               CER001
      *                                                                                       CER001
     C                   PARM      *BLANKS       @ACCD                                        CER001
     C                   PARM      *BLANKS       @CUST                                        CER001
     C                   PARM                    @FOUND                                       CER001
      *                                                                                       CER001
     C                   MOVE      *BLANKS       WWCUTY                                       CER001
      *                                                                                       CER001
     C                   IF        @FOUND = 'Y'                                               CER001
      *                                                                                       CER001
     C     @CUST         CHAIN     SDCUX1L0                           99                      CER001
     C                   IF        *IN99 = '1'                                                CER001
     C                   MOVEL     'SDCUX1L0'    DBFILE                                       CER001
     C                   MOVEL     '902'         DBASE                                        CER001
     C                   MOVEL     *BLANKS       DBKEY                                        CER001
     C                   MOVEL     @CUST         DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   MOVE      CUTYPE        WWCUTY                                       CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   MOVEL     APFOTRANID    #1FOTR                                       CER001
     C                   MOVEL     PTIMESTAMP    #1TMST                                       CER001
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
     C                   CALLB     'FTIPAY6VL'                                                CER001
     C                   PARM                    DDACTN                                       CER001
     C                   PARM                    PDATA                                        CER001
     C                   PARM                    PRegdata                                     CER001
     C                   PARM                    OkFlagsExtL                                  CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIdArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIdArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    ValidFilExtL                                 CER001
     C                   PARM                    WWCUTY                                       CER001
     C                   PARM                    @CUST                                        CER001
     C                   PARM                    NwIPFilFmt                                   CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Call pgm once more just to close files                                               CER001
      *                                                                                       CER001
     C                   CALL      'IL0421'                                                   CER001
      *                                                                                       CER001
      ** Input                                                                                CER001
      *                                                                                       CER001
     C                   PARM                    @CURR                                        CER001
     C                   PARM                    @TYPE                                        CER001
     C                   PARM                    @LINE                                        CER001
     C                   PARM      9             @OPCL                                        CER001
      *                                                                                       CER001
      ** Output                                                                               CER001
      *                                                                                       CER001
     C                   PARM                    @ACCD                                        CER001
     C                   PARM                    @CUST                                        CER001
     C                   PARM                    @FOUND                                       CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** No Errors, write in valid file                                                       CER001
      *                                                                                       CER001
     C                   IF        Idx = 0                                                    CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y'                                               CER001
     C                   EVAL      #LLXIPPREF = IPPREF                                        CER001
     C                   EVAL      #LLXIPFOTR = APFOTranID                                    CER001
     C                   EVAL      #LLXIPTMES = PTimeStamp                                    CER001
     C                   WRITE     FTVIPLXDL                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** Errors, write in invalid file                                                        CER001
      ** Only write to invalid files if repair in back office                                 CER001
      *                                                                                       CER001
     C                   IF        (Idx > 0) and (APRprLocn = 'B')                            CER001
      *                                                                                       CER001
     C                   IF        ULX043 = 'Y'                                               CER001
     C                   EVAL      #LLXFOTR = APFOTranID                                      CER001
     C                   EVAL      #LLXTMES = PTimeStamp                                      CER001
     C                   EVAL      #LLXORTY = LLLXORTY                                        CER001
     C                   EVAL      #LLXBETY = LLLXBETY                                        CER001
     C                   EVAL      #LLXOPCO = LLLXOPCO                                        CER001
     C                   EVAL      #LLXCOCO = LLLXCOCO                                        CER001
     C                   EVAL      #LLXIDCO = LLLXIDCO                                        CER001
     C                   EVAL      #LLXIDEN = LLLXIDEN                                        CER001
     C                   WRITE     FTIIPLXDL                                                  CER001
     C                   ENDIF                                                                CER001
     C                   ENDIF                                                                CER001
      *
     C                   EXSR      SRCheckWrite
      *
      /COPY WNCPYSRC,FTIPAYC016
      *
      ** If valid, send data queue entry to prompt DB update program.
      *
     C     IDx           IFEQ      0
     C                   EVAL      PObjType = '*DTAARA'
      *
      ** Check if update program active using Allocate Object API.
      ** No prompting necessary if program is running.
      *
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    PObject
     C                   PARM                    PLib
     C                   PARM                    PObjType
     C                   PARM                    PLockState
     C                   PARM                    PMember
     C                   PARM                    PWaitTime
     C                   PARM                    PDlcObj
     C                   PARM      *BLANK        PReturn
      *
     C     PReturn       IFEQ      *BLANK
      *
      ** Check if any messages are already on the data queue.
      ** No need to send duplicate prompt messages.
      *
      ** The following /COPY line includes a check for whether there
      ** are messages on the server/updater data queue, and sends a 'GO'
      ** message to the data queue if there are not.
      *
      /COPY ZACPYSRC,DTAQCHK
      *
     C                   ENDIF
     C/COPY WNCPYSRC,FTH00313
      *
     C/COPY WNCPYSRC,FTH00314
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      *
      /COPY WNCPYSRC,FTIPAYC017
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkValTran - Routine to check if valid Incoming Payment    *
      *                 exists for Front Office Id in the Valid       *
      *                 Incoming Payments file                        *
      *                                                               *
      *****************************************************************
      *
     C     SRChkValTran  BEGSR
      *
      ** Check for Front Office Id in the Valid Records file.
      *
     C     APFOTRANID    CHAIN     FTVIPAYL0                          01
      *
      ** Record found.
      *
     C     *IN01         IFEQ      '0'
      *
      ** Run delay program, then repeat chain.
      *
     C                   CALLB     'ZACDELAY'
      *
     C     APFOTRANID    CHAIN     FTVIPAYL0                          01
      *
      ** Error if Front Office Id is still present.
      *
     C     *IN01         IFEQ      '0'
     C                   ADD       1             IDx
     C                   EVAL      FldNameArr(IDx) = 'DDPREF'
     C                   EVAL      MsgIDArr(IDx)   = 'APM0900'
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
      * SRChkValMTran - Routine to check if valid Incoming Payment    *
      *                 exists for Midas Payment Reference in the     *
      *                 Valid Incoming Payments file                  *
      *                                                               *
      *****************************************************************
      *
     C     SRChkValMTran BEGSR
      *
      ** Check for Midas Payment Reference in the Valid Records file.
      *
     C     DDPREF        CHAIN     FTVIPAYL1                          01
      *
      ** Record found.
      *
     C     *IN01         IFEQ      '0'
      *
      ** Run delay program, then repeat chain.
      *
     C                   CALLB     'ZACDELAY'
      *
     C     DDPREF        CHAIN     FTVIPAYL1                          01
      *
      ** Error if Midas Payment Reference is still present.
      *
     C     *IN01         IFEQ      '0'
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = 'DDPREF'
     C                   EVAL      MsgIDArr(Idx) = 'APM0900'
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
      *  SRValAction - Routine to validate Action Code versus the     *
      *                Payment Reference supplied                     *
      *              - Original Incoming Payment details are          *
      *                retrieved during the validation process        *
      *                                                               *
      *****************************************************************
      *
     C     SRValAction   BEGSR
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
      ** Response Mode (from caller: A=Asynchronous, S=Synchronous)
     C                   PARM                    APRESPMODE
      *
      ** Action Code
     C                   PARM                    DDACTN
      *
      ** Front Office Transaction Id
     C                   PARM                    APFOTranId
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
     C                   PARM                    CFT003            1            CFT014
      *                                                                         CFT014
      ** STP Phase 2 MT103                                                      CFT014
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
     C                   PARM                    CrIP2FilFmt                    CFT014
     C/COPY WNCPYSRC,FTIPAYCC01
      *
      ** For the rest of the processing, set Mode of Operation
      ** to '*FRONT' for the other modules to process the
      ** transaction as coming from an external system.
      *
     C                   MOVEL     '*FRONT'      PMode
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValDetails - Routine to validate incoming Incoming         *
      *                 Payment details                               *
      *               - Amended file fields (for update) are set up   *
      *                 during the validation process                 *
      *                                                               *
      *****************************************************************
      *
     C     SRValDetails  BEGSR
      *
      ** Move Incoming Payment details retrieved from the Midas
      ** database file into the update file record.  If no
      ** record has been retrieved (i.e. in Insert), fields
      ** contain initial values (zeros, blanks and 'Y's for
      ** VAT flags).
      *
     C                   MOVEL     CrIPFilFmt    NwIPFilFmt
     C                   IF        CFT003 = 'Y' or CFT014 = 'Y'                 CFT014
     C                             OR CFT009 = 'Y'                              CFT009
     C                   MOVEL     CrIP2FilFmt   NwIP2FilFmt                    CFT014
     C                   ELSE                                                                BUG7101
     C                   CLEAR                   NwIP2FilFmt                                 BUG7101
     C                   ENDIF                                                  CFT014
      *
      ** Validate Level 1 screen details.
      *
     C                   EXSR      SRVL1Scrn
      *
      ** If error occurred in the previous validation, bypass
      ** remaining processing.
      *
     C     IDx           IFNE      0
     C                   GOTO      EValDetails
     C                   ENDIF
      *
      ** Compute Charges and Commissions, and Total VAT Amounts
      ** based on Level 1 details.
      *
     C                   IF        CFT009 = 'N'                                 CFT009
     C                   EXSR      SRCCVatL1
     C                   ENDIF                                                  CFT009
      *
      ** Initialise Level 2 Processing flag for update of Level 2
      ** details.
      *
     C                   MOVE      *BLANK        WLVL2             1
      *
      ** Level 2 screen details exist.
      *
     C                   IF        NwIP2ScnFmt <> *BLANKS OR
     C                             NwIP3ScnFmt <> *BLANKS OR
     C***********                  NwIP4ScnFmt <> *BLANKS                       CFT014
     C                             NwIP4ScnFmt <> *BLANKS OR                    CFT014
     C                             NwIP4aScnFmt <> *BLANKS OR                   CFT014
     C                             NwIP5ScnFmt <> *BLANKS OR                    CFT014
     C**********                   NwIP6ScnFmt <> *BLANKS                              CFT014 CSW209
     C                             NwIP6ScnFmt <> *BLANKS OR                                  CSW209
     C                             NwIP7ScnFmt <> *BLANKS OR                                  CSW209
     C**********                   NwIP8ScnFmt <> *BLANKS                              CSW209 CER030
     C                             NwIP8ScnFmt <> *BLANKS OR                                  CER030
     C                             NwIP6AScnFmt <> *BLANKS                                    CER030
      *
      ** Set Level 2 Processing flag for update of Level 2 details.
      *
     C                   MOVE      'Y'           WLVL2
      *
      ** Validate Level 2 screen 1 details.
      *
     C                   EXSR      SRVL2Scrn1
      *
      ** If error occurred in the previous validation, bypass
      ** remaining processing.
      *
     C     IDx           IFNE      0
     C                   GOTO      EValDetails
     C                   ENDIF
      ***********                                                               CFT014
      ***Default*Charges*and*Commission*details*on*Level*2*************         CFT014
      ***screen*2.*****************************************************         CFT014
      ***********                                                               CFT014
     C***********        EXSR      SRCDefault                                   CFT014
      *
      ** Validate Level 2 screen 2 details.
      *
     C                   EXSR      SRVL2Scrn2
      *                                                                         CFT014
      ** If error occurred in the previous validation, bypass                   CFT014
      ** remaining processing.                                                  CFT014
      *                                                                         CFT014
     C     IDx           IFNE      0                                            CFT014
     C                   GOTO      EValDetails                                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Default Charges and Commission details on Level 2                      CFT014
      ** screen 3.                                                              CFT014
      *                                                                         CFT014
     C                   IF        CFT009 = 'N'                                 CFT009
     C                   EXSR      SRCDefault                                   CFT014
     C                   ENDIF                                                  CFT009
      *                                                                         CFT014
      ** Validate Level 2 screen 3 details.                                     CFT014
      *                                                                         CFT014
     C                   EXSR      SRVL2Scrn3                                   CFT014
      *                                                                         CFT014
      ** If error occurred in the previous validation, bypass                   CFT014
      ** remaining processing.                                                  CFT014
      *                                                                         CFT014
     C     IDx           IFNE      0                                            CFT014
     C                   GOTO      EValDetails                                  CFT014
     C                   ENDIF                                                  CFT014
      *                                                                                       CER030
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'                               CER030
      *                                                                                       CER030
      ** Default Retail Transaction Type from Transaction code                                CER030
      ** If Retail Transaction type is blank                                                  CER030
      *                                                                                       CER030
     C                   IF        CER030 = 'Y' OR CGL013 = 'Y'                               CER030
     C                   IF        DDTTCD <> *BLANKS AND CFT014 = 'Y'                         CER030
     C                             AND DDRTTY = *BLANKS                                       CER030
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
     C                   ENDIF                                                                CER030
      *                                                                         CFT014
      ** Validate Margin Infomation sobroutine.                                 CFT014
      *                                                                         CFT014
     C                   EXSR      SRMargInf                                    CFT014
      *                                                                                       CSW209
      ** Validate IPAY API Cover Messages Format Definition                                   CSW209
      ** screen 7                                                                             CSW209
      *                                                                                       CSW209
     C     CSW209        IFEQ      'Y'                                                        CSW209
     C     IDx           ANDEQ     0                                                          CSW209
     C                   EXSR      SRVal7                                                     CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Validate IPAY API Cover Messages Format Definition                                   CSW209
      ** screen 8                                                                             CSW209
      *                                                                                       CSW209
     C     CSW209        IFEQ      'Y'                                                        CSW209
     C     IDx           ANDEQ     0                                                          CSW209
     C                   EXSR      SRVal8                                                     CSW209
     C                   ENDIF                                                                CSW209
      *
     C                   ENDIF
      *
     C     EValDetails   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVL1Scrn - Validate Level 1 screen details                  *
      *                                                               *
      *****************************************************************
      *
     C     SRVL1Scrn     BEGSR
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
      ** Response Mode (from caller: A=Asynchronous, S=Synchronous)
     C                   PARM                    APRESPMODE
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
     C/COPY WNCPYSRC,FTH00360
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
      *
     C                   Z-add     BTPCRD        WBTPCRD           5 2          CFT014
      *                                                                         CFT014
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
      ** Response Mode (from caller: A=Asynchronous, S=Synchronous)
     C                   PARM                    APRESPMODE
      *
      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    NwIP1ScnFmt
     C                   PARM                    NwIP1aScnFmt                   CFT014
      *                                                                         CFT009
      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction       CFT009
      ** - screen format                                                        CFT009
     C                   PARM                    NWIP5SCNFMT                    CFT009
      *                                                                         CFT014
      ** Third Reimbursement Institution (previous)                             CFT014
     C                   PARM      *BLANKS       PPrvTRI          34            CFT014
      *                                                                         CFT014
      ** Previous Instructed Amount                                             CFT014
     C                   PARM      *BLANKS       PPrvNDAM         14            CFT014
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
     C                   PARM                    CFT014            1            CFT014
     C/COPY WNCPYSRC,FTIPAYCC05
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
     C                   PARM                    CFT010                         CFT009
      *                                                                         CFT009
      ** BLI FT Enhancements Feature                                            CFT009
     C                   PARM                    S01494                         CFT009
      ** Collaterals Processing                                                              BUG9105
                                                                                             BUG9105
     C                   PARM                    CGL014                                      BUG9105
     C/COPY WNCPYSRC,FTIPAYCC02
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
      ** Incoming Payments (additional details) for file update - file format   CFT014
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
     C/COPY WNCPYSRC,FTIPAYCC15
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
      *                                                                                       250600
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCCVatL1 - Compute Charges and Commissions, and Total VAT   *
      *              Amounts based on Level 1 details                 *
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
      *  SRVL2Scrn1 - Validate Level 2 screen 1 details               *
      *                                                               *
      *****************************************************************
      *
     C     SRVL2Scrn1    BEGSR
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
      ** Response Mode (from caller: A=Asynchronous, S=Synchronous)
     C                   PARM                    APRESPMODE
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
     C                   PARM                    BGMBIN
      *
      ** SDMMOD - Retail Banking
     C                   PARM                    BGRTBN
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
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCDefault - Defaulting of Charges and Commission details    *
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
      *                                                                         CFT014
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
      *
      ** Previous values of 'Charges to the Debit of a/c'                                     197220
      *                                                                                       197220
     C                   PARM                    PPrvCDRT          1                          197220
     C**********         PARM                    PPrvCDRO         12                   197220 CGL029
     C                   PARM                    PPrvCDRO                                     CGL029
     C                   PARM                    PPrvCDBR          3                          197220
     C                   PARM                    PPrvCDRC                                     CFT120
      *                                                                                       197220
      ** Recalcution flag.                                                                    197220
      *                                                                                       197220
     C                   PARM                    PReCalc           1                          197220
      *                                                                                       197220
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
      ** FT IN/OP - Charges to DR of Account CCY                                              CFT120
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
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVL2Scrn2 - Validate Level 2 screen 2 details               *
      *                                                               *
      *****************************************************************
      *
     C     SRVL2Scrn2    BEGSR
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
      ** Response Mode (from caller: A=Asynchronous, S=Synchronous)
     C                   PARM                    APRESPMODE
      ***********                                                               CFT014
      ***Incoming*Payments*Lvl*1*Scrn*details*from*incoming*transaction         CFT014
      ***-*screen*format***********************************************         CFT014
     C***********        PARM                    NwIP1ScnFmt                    CFT014
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
      *
      ***DS*for Default Charge Amounts                                                        222373
     C*****              PARM                    PCharges                                     222373
      *****                                                                                   222373
     C                   ENDSR
      *
      *****************************************************************
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SRVL2Scrn3 - Validate Level 2 screen 3 details               *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
      *                                                                         CFT014
     C     SRVL2Scrn3    BEGSR                                                  CFT014
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
      ** Response Mode (from caller: A=Asynchronous, S=Synchronous)             CFT014
     C                   PARM                    APRESPMODE                     CFT014
      *                                                                         CFT014
      ** Incoming Payments Lvl 1 details                                        CFT014
     C                   PARM                    NwIP1ScnFmt                    CFT014
      *                                                                         CFT014
      ** Incoming Payments Lvl 2 Scrn 2 details from incoming transaction       CFT014
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
      ** FT IN/OP - Charges to DR of Account CCY                                              CFT120
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
     C                   PARM                    PFrcReDisplay     1            CFT014
      *                                                                         CFT014
      ** I/O: Previous Receiver's charges remitted input                        CFT014
      **      Its value is maintained in FTVIRCRM                               CFT014
     C                   PARM                    PPrvDDRCRM       12            CFT014
      *                                                                         CFT014
      ** I/O: Previous Total charges calculated                                 CFT014
      **      Its value is maintained in FTVIRCRM                               CFT014
     C                   PARM                    PPrvTOTCHG       15 0          CFT014
                                                                                              199992
      ** Charges to the debit of - field changed (Y or blank)                                 199992
                                                                                              199992
     C                   PARM                    PCDROCHG          1                          199992
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
     C                   ENDSR                                                  CFT014
      *                                                                         CFT014
      *****************************************************************         CFT014
      /EJECT                                                                    CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SRMargInf - Validate Margin Information details              *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
      *                                                                         CFT014
     C     SRMargInf     BEGSR                                                  CFT014
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
      *                                                                         CFT014
      ** Response Mode (from caller: A=Asynchronous, S=Synchronous)             CFT014
     C                   PARM                    APRESPMODE                     CFT014
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
     C                   ENDSR                                                  CFT014
      *                                                                         CFT014
      *****************************************************************         CFT014
      /EJECT                                                                                  CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      *  SRVal7 - Incoming Payments Validation Controller 7           *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
      *                                                                                       CSW209
     C     SRVal7        BEGSR                                                                CSW209
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
     C                   PARM                    IDx                                          CSW209
      *                                                                                       CSW209
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CSW209
     C                   PARM                    WFldNamArr                                   CSW209
     C                   PARM                    WMsgIdArr                                    CSW209
     C                   PARM                    WMsgDtaArr                                   CSW209
      *                                                                                       CSW209
      ** Array index (3P0) from/to caller                                                     CSW209
     C                   PARM                    WIDx                                         CSW209
      *                                                                                       CSW209
      ** Incoming Payments error indicators                                                   CSW209
     C                   PARM                    FTEIPY7                                      CSW209
      *                                                                                       CSW209
      ** Incoming Payments for file update - file format                                      CSW209
     C                   PARM                    NwIP2FilFmt                                  CSW209
      *                                                                                       CSW209
     C                   ENDSR                                                                CSW209
      *                                                                                       CSW209
      *****************************************************************                       CSW209
      /EJECT                                                                                  CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      *  SRVal8 - Incoming Payments Validation Controller 8           *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
      *                                                                                       CSW209
     C     SRVal8        BEGSR                                                                CSW209
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
     C                   PARM                    IDx                                          CSW209
      *                                                                                       CSW209
      ** Warning flds/message IDs/message data (arrays) from/to caller                        CSW209
     C                   PARM                    WFldNamArr                                   CSW209
     C                   PARM                    WMsgIdArr                                    CSW209
     C                   PARM                    WMsgDtaArr                                   CSW209
      *                                                                                       CSW209
      ** Array index (3P0) from/to caller                                                     CSW209
     C                   PARM                    WIDx                                         CSW209
      *                                                                                       CSW209
      ** Incoming Payments error indicators                                                   CSW209
     C                   PARM                    FTEIPY8                                      CSW209
      *                                                                                       CSW209
      ** Incoming Payments for file update - file format                                      CSW209
     C                   PARM                    NwIP2FilFmt                                  CSW209
      *                                                                                       CSW209
     C                   ENDSR                                                                CSW209
      *                                                                                       CSW209
      *****************************************************************                       CSW209
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtPref - Convert Incoming Payment details from file to    *
      *              screen format                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRCvtPref     BEGSR
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
      ** BLI Funds Transfer Enhancement Feature
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
     C/COPY WNCPYSRC,FTIPAYCC06
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
     C                   PARM                    CFT009                         CFT009
     C                   PARM                    CFT010                         CFT009
     C/COPY WNCPYSRC,FTIPAYCC03
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
     C                   PARM                    PStatus          10
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
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDtaSubs - Data Substitution Routine                        *
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
     C                   PARM      NwIP1aScnFmt  PIncData       2000            CFT014
      *                                                                         CFT014
      ** Current Data                                                           CFT014
     C                   PARM      CrIP1aScnFmt  PCurData       2000            CFT014
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
     C                   MOVEL     PIncDATA      NwIP4ScnFmt
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
     C                   PARM      NwIP4aScnFmt  PIncData       2000            CFT014
      *                                                                         CFT014
      ** Current Data                                                           CFT014
     C                   PARM      CrIP4aScnFmt  PCurData       2000            CFT014
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
     C                   PARM      NwIP5ScnFmt   PIncData       2000            CFT014
      *                                                                         CFT014
      ** Current Data                                                           CFT014
     C                   PARM      CrIP5ScnFmt   PCurData       2000            CFT014
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
     C                   PARM      NwIP6ScnFmt   PIncData       2000            CFT014
      *                                                                         CFT014
      ** Current Data                                                           CFT014
     C                   PARM      CrIP6ScnFmt   PCurData       2000            CFT014
      *                                                                         CFT014
     C                   MOVEL     PIncData      NwIP6ScnFmt                    CFT014
      *                                                                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                                       CSW209
     C                   IF        CSW209  = 'Y'                                              CSW209
     C                   IF        WSUBIP7 = 'Y'                                              CSW209
      *                                                                                       CSW209
     C                   CLEAR                   PIncData                                     CSW209
     C                   CLEAR                   PCurData                                     CSW209
      *                                                                                       CSW209
     C                   CALLB     'APDTASUBS'                                                CSW209
      *                             =========                                                 CSW209
      ** Return Code                                                                          CSW209
     C                   PARM      *BLANKS       RetCodeOut                                   CSW209
      *                                                                                       CSW209
      ** Substitution Character                                                               CSW209
     C                   PARM                    GHSUBS                                       CSW209
      *                                                                                       CSW209
      ** Incoming Data                                                                        CSW209
     C                   PARM      NwIP7ScnFmt   PIncData                                     CSW209
      *                                                                                       CSW209
      ** Current Data                                                                         CSW209
     C                   PARM      CrIP7ScnFmt   PCurData                                     CSW209
      *                                                                                       CSW209
     C                   MOVEL     PIncData      NwIP7ScnFmt                                  CSW209
      *                                                                                       CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   IF        WSUBIP8 = 'Y'                                              CSW209
      *                                                                                       CSW209
     C                   CLEAR                   PIncData                                     CSW209
     C                   CLEAR                   PCurData                                     CSW209
      *                                                                                       CSW209
     C                   CALLB     'APDTASUBS'                                                CSW209
      *                             =========                                                 CSW209
      ** Return Code                                                                          CSW209
     C                   PARM      *BLANKS       RetCodeOut                                   CSW209
      *                                                                                       CSW209
      ** Substitution Character                                                               CSW209
     C                   PARM                    GHSUBS                                       CSW209
      *                                                                                       CSW209
      ** Incoming Data                                                                        CSW209
     C                   PARM      NwIP8ScnFmt   PIncData                                     CSW209
      *                                                                                       CSW209
      ** Current Data                                                                         CSW209
     C                   PARM      CrIP8ScnFmt   PCurData                                     CSW209
      *                                                                                       CSW209
     C                   MOVEL     PIncData      NwIP8ScnFmt                                  CSW209
      *                                                                                       CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValAmend - Routine to check whether the fields are         *
      *               amendable                                       *
      *             - This subroutine calls a procedure which checks  *
      *               whether it is valid to amend the fields which   *
      *               have been altered.  To determine what fields    *
      *               have been changed, the current fields on file   *
      *               must be converted first to their screen formats.*
      *               These fields are then compared with the fields  *
      *               on the input transaction.  Any errors detected  *
      *               by the called procedure take precedence over    *
      *               any errors found during the validation of the   *
      *               transaction.  The errors from the called        *
      *               procedure are kept separately and if any are    *
      *               found, these errors will REPLACE the normal     *
      *               validation errors.                              *
      *                                                               *
      *****************************************************************
      *
     C     SRValAmend    BEGSR
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
     C                   PARM      'N'           PResetFld         1
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
     C                   PARM                    AMFldNamAr
     C                   PARM                    AMMsgIdArr
     C                   PARM                    AMMsgDtaAr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    AMIDx
      *
      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    FTEIPY1
      *
      ** OK Amendments field
     C                   PARM                    PAmendOK          1
      *
      ** If errors occurred, overwrite previous error information.
      *
     C                   IF        AMIDx <> 0
     C                   MOVEA     AMFldNamAr    FldNameArr
     C                   MOVEA     AMMsgIdArr    MsgIdArr
     C                   MOVEA     AMMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AMIDx         IDx
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCheckWrite - Routine to control checking of error status   *
      *                 and sending of messages/writing to the        *
      *                 database                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRCheckWrite  BEGSR
      *
      ** If no errors were found:
      ** - set up additional data
      ** - write a record to the Valid Records file
      ** - use std message handler to report transaction status
      ** If any errors were found:
      ** - set up additional data
      ** - write a record to the Invalid Records file
      ** - call the message handler to pass the errors back
      ** - use std message handler to report transaction status
      ** The index to the error arrays is checked for presence/absence of
      ** errors.
      *
      ** +--- Note for a later release -------------------------------+
      ** |                                                            |
      ** | At a later date, this routine will have to cater for       |
      ** | warning messages.  The following logic will have to be     |
      ** | inserted before "If no errors were found", in the          |
      ** | above comments (and the code):                             |
      ** |                                                            |
      ** | If 'Ignore warning messages' (from API ICD) is 'N', AND    |
      ** | any warning messages were returned (WIdx <> 0)             |
      ** |                                                            |
      ** | -   If errors exist                                        |
      ** |     -     Add the warning array index to the error array   |
      ** |           index                                            |
      ** |     -     Append the contents of the warning arrays to the |
      ** |           end of the error arrays                          |
      ** | -   Else                                                   |
      ** |     -     Set the error array index equal to the warning   |
      ** |           array index                                      |
      ** |     -     Copy the contents of the warning arrays to the   |
      ** |           error arrays                                     |
      ** | -   Endif                                                  |
      ** |                                                            |
      ** | Endif                                                      |
      ** |                                                            |
      ** | Note that the "If errors exist ... Else ... " block above  |
      ** | can probably be implemented unconditionally (i.e. the same |
      ** | logic will apply whether errors exist as well as warnings  |
      ** | or not).  It is shown in the above form for clarity.       |
      ** |                                                            |
      ** +------------------------------------------------------------+
      *
     C     IDx           IFEQ      0
     C/COPY WNCPYSRC,FTH00125
     C                   EXSR      SRSetValid
     C                   WRITE     FTVIPAYD0
     C                   IF        CFT003 = 'Y' or CFT014 = 'Y'                 CFT014
     C                             OR CFT009 = 'Y'                              CFT009
     C                   WRITE     FTVIPY2D0                                    CFT014
     C                   ENDIF                                                  CFT014
     C/COPY WNCPYSRC,FTH00126
     C                   EXSR      SRMsgHdl
     C                   ENDIF
      *
     C     IDx           IFGT      0
     C                   EXSR      SRSetInvalid
      *
      ** Only write to invalid file if repair in back office.
      *
     C/COPY WNCPYSRC,FTH00254
     C     APRPRLOCN     IFEQ      'B'
     C/COPY WNCPYSRC,FTH00255
     C                   WRITE     FTIIPAYD0
                                                                                              CSC011
      ** If support system is active, write invalid transaction to log file via               CSC011
      ** APLOGTRAN standard module.                                                           CSC011
                                                                                              CSC011
     C                   IF        (CSC011 = 'Y') AND (LIBR = S1SUPP)                         CSC011
                                                                                              CSC011
      ** Setup TRANSDTL transaction field.                                                    CSC011
                                                                                              CSC011
     C                   EXSR      SRSDTL                                                     CSC011
                                                                                              CSC011
     C                   EVAL      APTGTTYPE = 'FTIPAY'                                       CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANK        RetCodeOut                                   CSC011
     C                   PARM                    PHeadIn                                      CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM                    PTimeStamp                                   CSC011
     C                   PARM      DDPREF        PREFERENCE                                   CSC011
     C                   PARM      *BLANKS       PAREFERENCE                                  CSC011
                                                                                              CSC011
      ** Error writing in log file, process db error.                                         CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *BLANKS                                      CSC011
     C                   EVAL      DBFILE = 'APLOGTRAN'                                       CSC011
     C                   EVAL      DBASE = 23                                                 CSC011
     C                   EVAL      DBKEY = PREFERENCE                                         CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C/COPY WNCPYSRC,FTH00127
     C                   ENDIF
      *
     C                   EXSR      SRMsgHdl
     C                   ENDIF
      *
      **                                                                                      CSC022
      ** Execute commit if SAR CSC022 is not enrolled or                                      CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
      *
     C                   ENDSR
      *
      *****************************************************************                       CSC011
      /Title SR/SRSDTL                                                                        CSC011
      *****************************************************************                       CSC011
      *                                                               *                       CSC011
      * SRSDTL     - Setup TRANSDTL transaction field                 *                       CSC011
      *                                                               *                       CSC011
      * Called by: CheckWrite subroutine                              *                       CSC011
      *                                                               *                       CSC011
      * Calls:     None                                               *                       CSC011
      *                                                               *                       CSC011
      *****************************************************************                       CSC011
                                                                                              CSC011
     C     SRSDTL        BEGSR                                                                CSC011
                                                                                              CSC011
      ** Set TRANSDTL by joining all incoming payment screens and the extra                   CSC011
      ** data received by this module into a single data transaction field.                   CSC011
                                                                                              CSC011
     C                   EVAL      TRANSDTL = NwIP1ScnFmt + NwIP1aScnFmt +                    CSC011
     C                                        NwIP2ScnFmt + NwIP3ScnFmt +                     CSC011
     C                                        NwIP4ScnFmt + NwIP4aScnFmt +                    CSC011
     C                                        NwIP5ScnFmt + NwIP6ScnFmt +                     CSC011
     C                                        NwIP7ScnFmt + NwIP8ScnFmt +                     CSW209
     C                                        NwIP6AScnFmt +                                  CER030
     C**********                              PExtData                                 CSC011 CER001
     C                                        PRegData + PExtData                             CER001
                                                                                              CSC011
     C                   ENDSR                                                                CSC011
                                                                                              CSC011
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetValid - Routine to set up fields in the Valid File      *
      *               record                                          *
      *                                                               *
      *****************************************************************
      *
     C     SRSetValid    BEGSR
      *
      ** Action is Insert.
      *
     C     DDACTN        IFEQ      'I'
      *
      ** Update Incoming Payments data area with next
      ** Sequence Number.
      *
     C/COPY WNCPYSRC,FTH00039
     C                   IF        IPPREF = *Blanks                                           CER001
     C                   IF        CFT151  = 'N'                                              CFT151
     C     *DTAARA       DEFINE    INPAYDA       WINPAY
     C     *LOCK         IN        WINPAY
     C                   Z-ADD     WINSQ         WWINSQ            4 0
                                                                                              CSC024
      ***Suppress*new*payment*reference*generation*if*CSC024*is                        CSC024 CSC054
      ***switched*on*and*this*is*running*on*OME*system.                                CSC024 CSC054
      ** Suppress new payment reference generation if CSC054 is                               CSC054
      ** switched on and this is running on PEA system.                                       CSC054
                                                                                              CSC024
     C                   IF        GENPREF = 'Y'                                              CSC024
     C                   ADD       1             WINSQ
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C                   OUT       WINPAY
     C                   ELSE                                                                 CFT151
     C                   MOVE      WINPAY        WWINSQT                                      CFT151
     C                   IF        GENPREF = 'Y'                                              CFT151
     C                   CALL      'FT000328'                                                 CFT151
     C                   PARM                    PRTCD                                        CFT151
     C                   PARM      'IN'          W@OTIN            2                          CFT151
     C                   PARM      'A'           WCALC                                        CFT151
     C                   PARM      'Y'           WUPD              1                          CFT151
     C                   PARM                    WWINSQT           4                          CFT151
     C                   PARM                    WNEWSQ                                       CFT151
     C                   END                                                                  CFT151
     C                   END                                                                  CFT151
     C/COPY WNCPYSRC,FTH00040
     C                   ENDIF                                                                CER001
      *
      ** Record Id.
      *
     C                   MOVEL     'D'           IPRECI
      *
      ** Payment Type.
      *
     C                   EVAL      IPPYTP = 'IN'
      *
      ** Original Entry Dates.
      *
     C                   Z-ADD     BJRDNB        PDayNo
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDayNo            5 0
     C                   PARM      BJDFIN        PFMT              1
     C                   PARM      *ZERO         PDate             6 0
     C                   PARM      *BLANKS       PADate            7
      *
     C                   Z-ADD     BJRDNB        IPOEDT
     C                   Z-ADD     PDate         IPOEDTD1
      *
     C                   MOVE      PDate         WN2               2 0
     C     WN2           IFLT      72
     C                   Z-ADD     20            IPOEDTD2
     C                   ELSE
     C                   Z-ADD     19            IPOEDTD2
     C                   ENDIF
      *
     C                   MOVEL     PDate         WA4               4
     C     BJDFIN        IFNE      'M'
     C                   MOVEL     WA4           WA2               2
     C                   MOVE      WA4           WA2A              2
     C                   MOVEL     WA2A          WA4
     C                   MOVE      WA2           WA4
     C                   ENDIF
      *
     C                   MOVE      PDate         WA2
     C                   MOVEL     WA2           PDate
     C                   MOVE      WA4           PDate
     C                   Z-ADD     PDate         IPOEDTD3
      *
      ** New Payment Reference.
      *
     C/COPY WNCPYSRC,FTH00227
     C                   IF        IPPREF = *Blanks                                           CER001
      *                                                                                       CER001
     C                   IF        (CSC011 = 'Y') AND (LIBR = S1SUPP)                         CSC011
     C                   Z-ADD     WPRDTE        PDAYNO                                       CSC011
     C                   CALLB     'ZDATE2'                                                   CSC011
     C                   PARM                    PDAYNO                                       CSC011
     C                   PARM      BJDFIN        PFMT                                         CSC011
     C                   PARM      *ZERO         PPRDATE                                      CSC011
     C                   PARM      *BLANKS       PPRADATE                                     CSC011
      *                                                                                       CSC011
     C                   MOVEL     PPRDATE       WA4                                          CSC011
     C     BJDFIN        IFNE      'M'                                                        CSC011
     C                   MOVEL     WA4           WA2                                          CSC011
     C                   MOVE      WA4           WA2A                                         CSC011
     C                   MOVEL     WA2A          WA4                                          CSC011
     C                   MOVE      WA2           WA4                                          CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       CSC011
     C                   MOVE      PPRDATE       WA2                                          CSC011
     C                   MOVEL     WA2           PPRDATE                                      CSC011
     C                   MOVE      WA4           PPRDATE                                      CSC011
     C                   MOVE      PPRDATE       WA6                                          CSC011
     C                   ELSE                                                                 CSC011
     C                   MOVE      PDate         WA6               6
     C                   ENDIF                                                                CSC011
     C/COPY WNCPYSRC,FTH00041
     C                   IF        CFT151 = 'N'                                               CFT151
     C                   MOVE      WWINSQ        WA4
     C                   ELSE                                                                 CFT151
     C                   MOVE      WWINSQT       WA4                                          CFT151
     C                   END                                                                  CFT151
     C/COPY WNCPYSRC,FTH00042
     C                   MOVE      'P'           WYA1(1)
     C                   MOVEA     WA6           WYA1(2)
     C                   MOVEA     WA4           WYA1(8)
     C                   MOVEA     IPPYTP        WYA1(12)
     C                   MOVEA     '00'          WYA1(14)
      *
     C     1             DO        15            IA                2 0
     C     WYA1(IA)      IFEQ      ' '
     C                   MOVEL     '0'           WYA1(IA)
     C                   ENDIF
     C                   ENDDO
      *
     C                   IF        GENPREF = 'Y'                                              CSC024
     C                   MOVEA     WYA1(1)       IPPREF
     C                   ELSE                                                                 CSC024
     C                   EVAL      IPPREF = DDPREF                                            CSC024
     C                   ENDIF                                                                CSC024
     C/COPY WNCPYSRC,FTH00228
     C                   ENDIF                                                                CER001
      *
      ** Level 1 Valid Indicator.
      *
     C                   EVAL      IPINLVL1 = 'Y'
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
      ** Level 2 details have been processed.
      *
     C     WLVL2         IFEQ      'Y'
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
     C/COPY WNCPYSRC,FTH00128
     C                   ENDIF
      *
      ** Delete.
      *
     C     DDACTN        IFEQ      'D'
     C/COPY WNCPYSRC,FTH00437
      *
      ** Move Incoming Payment details retrieved from file
      ** directly to the Valid Record data structure.
      *
     C                   MOVEL     CrIPFilFmt    NwIPFilFmt
     C                   IF        CFT003 = 'Y' or CFT014 = 'Y'                 CFT014
     C                             OR CFT009 = 'Y'                              CFT009
     C                   MOVEL     CrIP2FilFmt   NwIP2FilFmt                    CFT014
     C                   ELSE                                                                BUG7101
     C                   CLEAR                   NwIP2FilFmt                                 BUG7101
     C                   ENDIF                                                  CFT014
      *
      ** Record Id - update to 'C'.
      *
     C                   EVAL      IPRECI = 'C'
      *
     C                   ENDIF
      *
      ** Enquire.
      *
     C     DDACTN        IFEQ      'E'
      *
      ** Move Incoming Payment details retrieved from file
      ** directly to the Valid Record data structure.
      *
     C                   MOVEL     CrIPFilFmt    NwIPFilFmt
     C                   IF        CFT003 = 'Y' or CFT014 = 'Y'                 CFT014
     C                             OR CFT009 = 'Y'                              CFT009
     C                   MOVEL     CrIP2FilFmt   NwIP2FilFmt                    CFT014
     C                   ELSE                                                                BUG7101
     C                   CLEAR                   NwIP2FilFmt                                 BUG7101
     C                   ENDIF                                                  CFT014
      *
     C                   ENDIF
      *
      ** Last Change Type, Date and Time.
      *
     C                   MOVEL     DDACTN        IPCHTP
     C                   Z-ADD     BJRDNB        IPLCD
     C                   TIME                    IPLCHT
      *
      ** Message Header details.
      *
     C                   EVAL      IPFRNT = APFOTRANID
     C                   EVAL      IPREPA = APRPRLOCN
     C                   EVAL      IPTMST = PTimestamp
      *
      ** Master files will be updated.
      *
     C                   EVAL      PTranStatus = 'S'
      *                                                                         CFT014
      ** Set up the following fields for update of FTVIPY2PD                    CFT014
      *                                                                         CFT014
     C*******************IF        (CFT003 = 'Y' or CFT014 = 'Y') and    CFT014 CFT009
     C                   IF        (CFT003 = 'Y' or CFT014 = 'Y'                CFT009
     C**********                   OR CFT009 = 'Y') AND                                CFT009 199992
     C**********                   (DDACTN = 'I' or DDACTN = 'A')                      CFT014 199992
     C                             OR CFT009 = 'Y')                                           199992
     C                   EVAL      I2INAUTO = 'N'                               CFT014
     C/COPY WNCPYSRC,FTH00129
     C                   IF        DDACTN = 'I' OR DDACTN = 'A' OR DDACTN = 'D'               199992
     C/COPY WNCPYSRC,FTH00438
     C                   IF        DDACTN = 'I'                                 CFT014
     C                   EVAL      I2INRECI = 'D'                               CFT014
     C                   EVAL      I2INPREF = IPPREF                            CFT014
     C                   EVAL      I2INFRNT = IPFRNT                            CFT014
     C**********         EVAL      I2INTMST = IPTMST                                   CFT014 199992
     C                   ENDIF                                                  CFT014
     C                   EVAL      I2INTMST = IPTMST                                          199992
     C                   ENDIF                                                                199992
     C                   ENDIF                                                  CFT014
      *
      /COPY WNCPYSRC,FTIPAYC018
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetInvalid - Routine to set up fields in the Invalid File  *
      *                 record                                        *
      *                                                               *
      *****************************************************************
      *
     C     SRSetInvalid  BEGSR
      *
     C                   EVAL      DDFRNT = APFOTRANID
     C                   EVAL      DDREPA = APRPRLOCN
     C                   EVAL      DDTMST = PTimestamp
      *
      ** Transaction needs to be repaired.
      *
     C                   EVAL      PTranStatus = 'F'
      *
      /COPY WNCPYSRC,FTIPAYC019
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMsgHdl - Routine to call the message handling module       *
      *                                                               *
      *****************************************************************
      *
     C     SRMsgHdl      BEGSR
      *
      ** Set up an array of sequence numbers that correspond to the
      ** fields with errors.
      *
     C                   Z-ADD     1             W1
      *
     C                   DO        ArrayMax
      *
     C     FldNameArr(W1)IFNE      *BLANKS
      *
     C                   Z-ADD     1             W2
     C     FldNameArr(W1)LOOKUP    FieldArr(W2)                           02
     C                   EVAL      FldNoArr(W1) = FldSeqArr(W2)
      *
     C                   ELSE
      *
     C                   LEAVE
      *
     C                   ENDIF
      *
     C                   ADD       1             W1
      *
     C                   ENDDO
      *
     C/COPY WNCPYSRC,FTH00500
     C**********         MOVEL     DDPREF        PTranID          20                          257897
     C                   MOVEL     IPPREF        PTranID          20                          257897
     C/COPY WNCPYSRC,FTH00501
      *
     C                   CALLB     'ZAMSGHNDLE'
      *
      ** Return Code (10A, returned to this procedure)
     C                   PARM      *BLANK        ReturnCode
      *
      ** Repair Location (1A, from caller)
     C                   PARM                    APRPRLOCN
      *
      ** Confirm Validity to Front Office (1A, from caller)
     C                   PARM                    APCNFVALFO
      *
      ** List of Messages (array of message Ids - from caller)
     C                   PARM                    MsgIDArr
      *
      ** List of Field Numbers (array of unsigned int. from caller)
     C                   PARM                    FldNoArr
      *
      ** List of Field Names (array of fields names from caller)
     C                   PARM                    FldNameArr
      *
      ** List of Message Data Entries (Array of <ArrayMax>x45 - from caller)
     C                   PARM                    MsgDtaArr
      *
      ** Front Office Transaction Identifier (20A from caller)
     C                   PARM                    APFOTRANID
      *
      ** Midas Module Id (2A)
     C                   PARM                    PModuleId
      *
      ** Midas Transaction Id (20A, from caller)
     C                   PARM                    PTranID
      *
      ** Message File (10A, from caller)
     C                   PARM                    #MSGFILE
      *
      ** Action Code of Transaction (1A, from transaction)
     C                   PARM                    DDACTN
      *
      ** Status of Transaction (1A, F=Failure, S=Success)
     C                   PARM                    PTranStatus
      *
      ** Response Mode (from caller: A=Asynchronous, S=Synchronous)
     C                   PARM                    APRESPMODE
      *
      ** The following three parameters are needed when messages are
      ** to be displayed on a screen
      *
      ** Screen-handling Program (10A, from caller)
     C                   PARM                    #PROCPGM
      *
      ** Screen-handling Module (10A, from caller)
     C                   PARM                    #PROCMOD
      *
      ** Screen-handling Procedure (10A, from caller)
     C                   PARM                    #PROCNAME
      *
      ** The MQ Series Queue to Send Replies to
     C                   PARM                    APRPYQUEUE
      *
      ** The Transaction's Timestamp
     C                   PARM                    PTimestamp
      *
      ** Additional Message Files to Check (Array of <MsgFArrMax> x 10)
     C                   PARM                    MSGFARRAY
      *
      ** Whether or Not Clear the Program Message Queue (1A)
     C                   PARM                    PClrPgmMsgQ
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetFld - Routine to reset fields                         *
      *                                                               *
      *****************************************************************
      *
     C     SRResetFld    BEGSR
      *
     C                   RESET                   FldNameArr
     C                   RESET                   MsgIdArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   IDx
      *
     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIdArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIDx
      *
     C                   RESET                   AMFldNamAr
     C                   RESET                   AMMsgIdArr
     C                   RESET                   AMMsgDtaAr
     C                   RESET                   AMIDx
      *
     C                   RESET                   FldNoArr
      *
     C                   MOVE      *ALL'Y'       FTEIPY1
     C                   MOVE      *ALL'Y'       FTEIPY2
     C                   MOVE      *ALL'Y'       FTEIPY3
     C                   MOVE      *ALL'Y'       FTEIPY4                        CFT014
     C                   MOVE      *ALL'Y'       FTEIPY5                        CFT014
      *                                                                                       CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   MOVE      *ALL'Y'       FTEIPY7                                      CSW209
     C                   MOVE      *ALL'Y'       FTEIPY8                                      CSW209
     C                   ENDIF                                                                CSW209
      *
     C                   CLEAR                   CrIP1ScnFmt
     C                   CLEAR                   CrIP1aScnFmt                   CFT014
     C                   CLEAR                   CrIP2ScnFmt
     C                   CLEAR                   CrIP3ScnFmt
     C                   CLEAR                   CrIP4ScnFmt
     C                   CLEAR                   CrIP4aScnFmt                   CFT014
     C                   CLEAR                   CrIP5ScnFmt                    CFT014
     C                   CLEAR                   CrIP6ScnFmt                    CFT014
      *                                                                                       CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   CLEAR                   CrIP7ScnFmt                                  CSW209
     C                   CLEAR                   CrIP8ScnFmt                                  CSW209
     C                   ENDIF                                                                CSW209
      *
     C                   CLEAR                   CrIP6AScnFmt                                 CER030
      *                                                                                       CER030
     C                   MOVE      *BLANKS       DDSWTN
     C                   MOVE      *BLANKS       DDSEQNO
     C                   MOVE      *BLANKS       PStatus
     C                   MOVE      'IN'          PPYTP
      *
     C                   ENDSR
      *
      *****************************************************************
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
      ** Message Header details
     C                   PARM                    PHeadIn
      *
      ** Incoming Transaction details
     C**********         PARM                    PTrans5001                                  CSF011A
     C                   PARM                    PTrans01                                    CSF011A
     C                   PARM                    PTrans5002
     C**********         PARM                    PTrans5003                                  CSF011A
     C                   PARM                    PTrans03                                    CSF011A
     C                   PARM                    PTrans5004
     C**********         PARM                    PTrans5005                           CFT014 CSF011A
     C                   PARM                    PTrans05                                    CSF011A
     C                   PARM                    PTrans5006                     CFT014
     C                   PARM                    PTrans5007                     CFT014
     C                   PARM                    PTrans5008                     CFT014
     C                   PARM                    PTrans5009A                                  CSW209
     C                   PARM                    PTrans5009B                                  CSW209
     C                   PARM                    PTrans5009                                   CER030
      *
      ** Incoming Payments extra data
     C                   PARM                    PRegData500                                  CER001
     C                   PARM                    PExtData500
      *
      ** Program details
     C                   PARM                    #PROCPGM
     C                   PARM                    #PROCMOD
     C                   PARM                    #PROCNAME
      *
      ** Set up the name of the module Id used to make the transaction
      ** number unique.
      *
     C                   EVAL      PModuleId = 'FT'
      *
      ** Set up the name of the primary and secondary message files from
      ** which the message handler will get the messages.
      *
     C                   EVAL      #MSGFILE     = 'FTUSRMSG'
     C                   EVAL      MSGFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'
     C/COPY WNCPYSRC,FTH00130
      *
      ** Set up the name of the server/database updater data queue.
      *
     C                   EVAL      DTAQNAME = 'APIPAYDTQ'
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
     C                   Z-ADD     016           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CGL009            1
     C                   ELSE
     C                   MOVEL     'N'           CGL009
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
 
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CFT004            1
     C                   ELSE
     C                   MOVEL     'N'           CFT004
     C                   ENDIF
      *                                                                         CFT014
      ** Access SAR file to determine if CFT003 is installed                    CFT014
      *                                                                         CFT014
     C                   CALLB     'AOSARDR0'                                   CFT014
     C                   PARM      *BLANKS       PRTCD                          CFT014
     C                   PARM      '*VERIFY'     POPTN                          CFT014
     C                   PARM      'CFT003'      PSARD                          CFT014
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT014
      *                                                                         CFT014
      ** An NRF (No Record Found) return code is valid.                         CFT014
      ** Issue database error only for error return codes.                      CFT014
      *                                                                         CFT014
     C     PRTCD         IFNE      *BLANKS                                      CFT014
     C     PRTCD         ANDNE     '*NRF   '                                    CFT014
     C                   MOVEL     'CFT003'      DBKEY                          CFT014
     C                   MOVEL     'SCSARDPD'    DBFILE                         CFT014
     C                   Z-ADD     018           DBASE                          CFT014
     C                   EXSR      *PSSR                                        CFT014
     C                   ENDIF                                                  CFT014
                                                                                CFT014
     C     PRTCD         IFEQ      *BLANK                                       CFT014
     C                   MOVEL     'Y'           CFT003            1            CFT014
     C                   ELSE                                                   CFT014
     C                   MOVEL     'N'           CFT003                         CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CFT014
      ** Access SAR file to determine if CFT014 is installed                    CFT014
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
     C                   Z-ADD     019           DBASE                          CFT014
     C                   EXSR      *PSSR                                        CFT014
     C                   ENDIF                                                  CFT014
                                                                                CFT014
     C     PRTCD         IFEQ      *BLANK                                       CFT014
     C                   MOVEL     'Y'           CFT014            1            CFT014
     C                   ELSE                                                   CFT014
     C                   MOVEL     'N'           CFT014                         CFT014
     C                   ENDIF                                                  CFT014
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
     C                   Z-ADD     020           DBASE                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
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
     C                   Z-ADD     021           DBASE                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
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
     C                   Z-ADD     020           DBASE                                        CFT151
     C                   EXSR      *PSSR                                                      CFT151
     C                   ENDIF                                                                CFT151
                                                                                              CFT151
     C     PRTCD         IFEQ      *BLANK                                                     CFT151
     C                   MOVEL     'Y'           CFT151            1                          CFT151
     C                   ELSE                                                                 CFT151
     C                   MOVEL     'N'           CFT151                                       CFT151
     C                   ENDIF                                                                CFT151
      *                                                                                       CFT151
      *                                                                                       CER030
      ** Access SAR file to determine if CER030 is installed                                  CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRTCD                                        CER030
     C                   PARM      '*VERIFY'     POPTN                                        CER030
     C                   PARM      'CER030'      PSARD                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
      ** An NRF (No Record Found) return code is valid.                                       CER030
      ** Issue database error only for error return codes.                                    CER030
      *                                                                                       CER030
     C     PRTCD         IFNE      *BLANKS                                                    CER030
     C     PRTCD         ANDNE     '*NRF   '                                                  CER030
     C                   MOVEL     'CER030'      DBKEY                                        CER030
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER030
     C                   Z-ADD     025           DBASE                                        CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C     PRTCD         IFEQ      *BLANK                                                     CER030
     C                   MOVEL     'Y'           CER030                                       CER030
     C                   ELSE                                                                 CER030
     C                   MOVEL     'N'           CER030                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Access SAR file to determine if CGL013 is installed                                  CER030
      *                                                                                       CER030
     C                   CALLB     'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRTCD                                        CER030
     C                   PARM      '*VERIFY'     POPTN                                        CER030
     C                   PARM      'CGL013'      PSARD                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
      ** An NRF (No Record Found) return code is valid.                                       CER030
      ** Issue database error only for error return codes.                                    CER030
      *                                                                                       CER030
     C     PRTCD         IFNE      *BLANKS                                                    CER030
     C     PRTCD         ANDNE     '*NRF   '                                                  CER030
     C                   MOVEL     'CGL013'      DBKEY                                        CER030
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER030
     C                   Z-ADD     026           DBASE                                        CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C     PRTCD         IFEQ      *BLANK                                                     CER030
     C                   MOVEL     'Y'           CGL013                                       CER030
     C                   ELSE                                                                 CER030
     C                   MOVEL     'N'           CGL013                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C/COPY WNCPYSRC,FTIPAYCC07
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
     C                   EVAL      DBASE = 22                                                 CSC011
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
      ** See if SWIFT 2009 Active                                                             CSW209
      *                                                                                       CSW209
     C                   CALL      'SWIF2009'                                                 CSW209
     C                   PARM                    PRTCD                                        CSW209
     C     PRTCD         IFEQ      'CSW2009'                                                  CSW209
     C                   MOVE      'Y'           CSW209                                       CSW209
     C                   ELSE                                                                 CSW209
     C                   MOVE      'N'           CSW209                                       CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
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
     C                   Eval      DBPgm  = 'FTIPAYCTL'                                       CSC022
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
     C                   EVAL      DBASE  = 24                                                CSC024
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
     C                   EVAL      DBase = 25                                                 CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ELSE                                                                 CSC024
     C                   IF        P@VL03 = 'Y'                                               CSC024
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
     C/COPY WNCPYSRC,FTIPAYCC04
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
     C                   Z-ADD     012           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C/COPY WNCPYSRC,FTH00132
      *
     C                   ENDIF
     C/COPY WNCPYSRC,FTH00131
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
     C                   Z-ADD     013           DBASE
     C                   EXSR      *PSSR
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
     C                   Z-ADD     014           DBASE
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
     C                   Z-ADD     015           DBASE
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
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      *
      /COPY WNCPYSRC,FTIPAYC020
      *                                                                                       CER001
      ** ULX611 - API Luxembourg - Function FTIPAY                                            CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX611                                       CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX611'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS                                            CER001
     C                   MOVEL     'Y'           ULX611                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** If return code <> *NRF, call program exception error routine                         CER001
      *                                                                                       CER001
     C                   If        @RTCD <> *BLANKS AND                                       CER001
     C                             @RTCD <> '*NRF'                                            CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBKEY = 'ULX611'                                           CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBASE = 903                                                CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** ULX043 - New IBLC 2002 as Feature                                                    CER001
      *                                                                                       CER001
     C                   MOVEL     'N'           ULX043                                       CER001
     C                   CALL      'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX043'      @SARD                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS                                            CER001
     C                   MOVEL     'Y'           ULX043                                       CER001
     C                   OPEN      FTVIPLX1PD                                                 CER001
     C                   OPEN      FTIIPLX1PD                                                 CER001
     C                   OPEN      SDCUX1L0                                                   CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
      ** If return code <> *NRF, call program exception error routine                         CER001
      *                                                                                       CER001
     C                   If        @RTCD <> *BLANKS AND                                       CER001
     C                             @RTCD <> '*NRF'                                            CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   EVAL      DBKEY = 'ULX043'                                           CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBASE = 904                                                CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                      BUG9105
      ** CGL014                                                                              BUG9105
      *                                                                                      BUG9105
     C                   MOVEL     'N'           CGL014                                      BUG9105
     C                   CALL      'AOSARDR0'                                                BUG9105
     C                   PARM      *BLANKS       @RTCD                                       BUG9105
     C                   PARM      '*VERIFY'     @OPTN                                       BUG9105
     C                   PARM      'CGL014'      @SARD                                       BUG9105
      *                                                                                      BUG9105
     C                   IF        @RTCD = *BLANKS                                           BUG9105
     C                   MOVEL     'Y'           CGL014                                      BUG9105
     C                   ENDIF                                                               BUG9105
      *                                                                                      BUG9105
      ** If return code <> *NRF, call program exception error routine                        BUG9105
      *                                                                                      BUG9105
     C                   If        @RTCD <> *BLANKS AND                                      BUG9105
     C                             @RTCD <> '*NRF'                                           BUG9105
     C     *LOCK         IN        LDA                                                       BUG9105
     C                   EVAL      DBKEY = 'CGL014'                                          BUG9105
     C                   EVAL      DBFILE = 'SCSARDPD'                                       BUG9105
     C                   EVAL      DBASE = 905                                               BUG9105
     C                   OUT       LDA                                                       BUG9105
     C                   EXSR      *PSSR                                                     BUG9105
     C                   ENDIF                                                               BUG9105
      *                                                                                       CFT120
      ** Access SAR file to determine if CFT120 is switched on                                CFT120
      *                                                                                       CFT120
     C                   MOVEL     'N'           CFT120            1                          CFT120
     C                   CALL      'AOSARDR0'                                                 CFT120
     C                   PARM      *BLANKS       @RTCD                                        CFT120
     C                   PARM      '*VERIFY'     @OPTN                                        CFT120
     C                   PARM      'CFT120'      @SARD                                        CFT120
      *                                                                                       CFT120
     C                   IF        @RTCD = *BLANKS                                            CFT120
     C                   MOVEL     'Y'           CFT120                                       CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
      ** If return code <> *NRF, call program exception error routine                         CFT120
      *                                                                                       CFT120
     C                   If        @RTCD <> *BLANKS AND                                       CFT120
     C                             @RTCD <> '*NRF'                                            CFT120
     C     *LOCK         IN        LDA                                                        CFT120
     C                   EVAL      DBKEY = 'CFT120'                                           CFT120
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT120
     C                   EVAL      DBASE = 906                                                CFT120
     C                   OUT       LDA                                                        CFT120
     C                   EXSR      *PSSR                                                      CFT120
     C                   ENDIF                                                                CFT120
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
