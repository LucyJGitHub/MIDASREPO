     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT IPAY validate and update')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAYVU - Incoming Payments validate and update             *
      *                                                               *
      *  Function: This program validates Incoming Payments           *
      *            transactions for input into the Midas database.    *
      *            The action code determines which processes are     *
      *            executed as follows:                               *
      *            - For I (=Insert) or A (=Amend)                    *
      *              - Validate the transaction details fields        *
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
      *            For all action codes, the decision to as to        *
      *            whether to write to the valid or invalid file and  *
      *            the call to the message handler will take place    *
      *            in this module                                     *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. 254598             Date 20Feb20               *
      *  Prev Amend No. MD050928           Date 15May18               *
      *                 MD047369A          Date 24Jan18               *
      *                 MD046248           Date 27Oct17               *
      *                 MD042042           Date 14Feb17               *
      *                 MD044395           Date 08Mar17               *
      *                 AR1090283          Date 10Aug16               *
      *                 MD036159           Date 15Jul16               *
      *                 MD034973           Date 16Jul15               *
      *                 MD032077           Date 26Jan15               *
      *                 MD030906           Date 13Nov14               *
      *                 CFT157             Date 29Aug14               *
      *                 MD025111           Date 10May14               *
      *                 CFT151             Date 20Mar14               *
      *                 CFT120             Date 28Sep12               *
      *                 CAP211             Date 28Sep12               *
      *                 CSC054             Date 23Feb12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CSF011             Date 12Sep11               *
      *                 CER049             Date 06Dec10               *
      *                 CRE075             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 262664             Date 11Nov09               *
      *                 CER030             Date 09Jul08               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG24998           Date 17Jul09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG22146           Date 16Jan09               *
      *                 256564             Date 17Sep08               *
      *                 255190             Date 21Jul08               *
      *                 BUG15006           Date 16Sep07               *
      *                 247398             Date 30Jun07               *
      *                 BUG14588           Date 12Sep07               *
      *                 243991             Date 05Dec06               *
      *                 BUG13159           Date 29Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 240137             Date 31May06               *
      *                 BUG6864            Date 15Dec05               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9106            Date 12Aug05               *
      *                 CER001             Date 25Apr05               *
      *                 BUG7101            Date 06Jul05               *
      *                 CSC024             Date 07Feb05               *
      *                 BUG7029            Date 09Jun05               *
      *                 BUG3279            Date 22Oct04               *
      *                 BUG4728            Date 05Nov04               *
      *                 BUG4196            Date 09Sep04               *
      *                 CFT115             Date 01Jul04               *
      *                 CGL014             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG515             Date 26Mar04               *
      *                 CSC022             Date 24Feb04               *
      *                 BUG1282            Date 25Mar04               *
      *                 BUG1493            Date 18Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001             Date 09Dec03               *
      *                 222373             Date 28Oct03               *
      *                 CAP084  *CREATE    Date 25Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  254598 - Increase length of DP32B and DATA2 (JMI106/113)     *
      *           (Recompile)                                         *
      *  MD050928 - SP15_MQ: Unclear error message - Error validating *
      *              'Stamp Tax Amount' : Invalid Numeric Value       *
      *           - Correction to CFT157. Move fields to end of Buffer*
      *           - Patterned after fix MD039094                      *
      *  MD047369A - Funds transfter does not check block Dr flag on  *
      *              beneficary customer account.                     *
      *  MD046248 - Finastra Rebranding                               *
      *  MD042042 - Input Officer 1 and Input Officer 2 are being     *
      *             populated with WIP authoriser. Use the WIP input  *
      *             user profile instead.                             *
      *  MD044395 - Incorrect Customer Name on Inputs details for     *
      *             valid BIC entry                                   *
      *  AR1090283 - Customer details not visible for enquire.        *
      *              (Child: AR1090284)                               *
      *            - Applied for MD-39986.                            *
      *  MD036159 - Systems allows payment with same FRNT.            *
      *             Pattern fix AR971184.                             *
      *           - Applied for MD-39705.                             *
      *  MD034973 - FT Payment Charges defaulting error               *
      *  MD032077 - Blank Front Office ID after authorisation. Do not *
      *             override IPFRNT when APFOTRANID is blank.         *
      *  MD030906 - Counterparty Nostro not defaulted.                *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *  MD025111 - Incoming payment without charges is not allowed   *
      *             if the account is blocked for DR                  *
      *  CFT151 - FT IN/OP Alphanumeric sequence                      *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CAP211 - FT IN_OP APIs - Auto-Authorization of Payment       *
      *  CSC054 - Period End Adjustments                              *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *          - Some codes of CSF011 will be physically deleted    *
      *  CSF011 - Customer Name on Inputs                             *
      *  CER049 - Stamp Tax                                           *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  262664 - Parameter conflict against SWIFT09.                 *
      *         - Change the parameter name.                          *
      *  CER030 - Multicash German Feature                            *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  BUG22146 - Missing authorization field in repository.        *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255190 - Added parameter message type to validate ordering   *
      *           customer.                                           *
      *  BUG15006 - A serious midas error occurred on IPAY            *
      *  247398 - Does not insert sender charges field from Incoming  *
      *           SWIFT message into FT incoming payment.             *
      * BUG14588 - Cannot Edit and Authorise using Incoming FT        *
      *            in JAVA Screen                                     *
      *  243991  - Always validate level 2 details when 'level joiner'*
      *            set to 'Y'                                         *
      * BUG13159 - After a successful update, the latest timestamp    *
      *            is not being passed back to the Java side. This    *
      *            later causes the WIP entry becoming impossible     *
      *            to authorise due to discrepancy between the        *
      *            timestamp initially stored in the WIP (which is    *
      *            incorrect) and the latest timestamp retreived from *
      *            INPAYDD when the amendment is being authorised.    *
      *            The timestamp in INPAYXPD is also not being        *
      *            updated properly.                                  *
      *            This actually is a lacking aspect of the fix done  *
      *            for BUG4196.                                       *
      *  CFT032 - Account Line in Field 50X in MT103                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  240137 - Applied fix 230309.                                 *
      *  230309 - If User enters Booking Branch, ignore value rtvd.   *
      *           by *MODULE FTVISNDR and set IPBRCA=DDBRCA.          *
      *  BUG6864 - Possible to get DB error if rate not entered       *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027A - Change Customer Number to alpha; post-103 build.   *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9106 - Allow mandatory Charge Details 2 validation        *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  BUG7101 - DB error in AOSPOSU0 due to blank INTRIT. Ensure   *
      *            fields are properly initialised.  Do the same      *
      *            changes done in FTIPAYSIN.                         *
      *  CSC024 - Open Month End                                      *
      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  BUG3279- Commit for MEINMRPD is needed                       *
      *  BUG4728 - Serious Midas error with blank timestamp when      *
      *            authorising insert of transaction.                 *
      *  BUG4196- Stopping changes being overwritten by other user    *
      *           when try to amend the record at the same time.      *
      *  CFT115 - Core changes for GBO015.                            *
      *         - Incoming Payments Beneficiary Validation            *
      *                  - Upgrade to Midasplus                       *
      *           Core hooks amended:FTIPAYV002,FTIPAYM01,FTIPAYV018  *
      *           Core hooks added:FTIPAYV021,FTIPAYV022,             *
      *                            FTIPAYV023,                        *
      *  CGL014 - Collaterals Processing                              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BUG515 - Set up error message for swift reference correctly  *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  BUG1282 - Delete reserved message if user presses cancel     *
      *  BUG1493 - Setup INUSR1 and INUSR2 correctly                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Recompiled due to change in FTV2OPYPD               *
      *  222373 - Correct parameters on program calls                 *
      *  CAP084 - Thin Client API Wrappers                            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *****************************************************************

      ** GL Accounts file
     FACCNT     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)

      ** Payment Charges file
     F***PYCHGDBIF   E           K DISK    INFSR(*PSSR)                                     MD034973
     FPYCHGL1   IF   E           K DISK    INFSR(*PSSR)                                     MD034973
     F                                     PREFIX(PY)

     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)

      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,FTIPAYV001

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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.

     D/COPY ZACPYSRC,PROCPARMS

      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------

      **-----------------------------------------------------------------------
      ** The following /COPY line includes the definitions for arrays
      ** specific to API CTL & VU modules.
     D/COPY ZACPYSRC,APICTLARR
      **-----------------------------------------------------------------------

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
     D*SysValOME       C                   CONST('OMEIndicator')                       CSC024 CSC054
     D SysValPEA       C                   CONST('PEAIndicator')                              CSC054
      ** System Values Array                                                                  CSC024

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** Narrative for Sender
     D PSNAR           S             35    DIM(1) CTDATA PERRCD(1)

      ** Work array for setting up new Payment Reference
     D WYA2            S              1    DIM(18)

      ** Work array for Amount for FONTIS processing
     D WYA1            S              1    DIM(15)

      ** Work array
     D WA              S              1    DIM(15)

      ** Work array used in SR CWVAL to store content of tag
     D W@CW            S              1    DIM(256)

      ** Work array used in SR CWVAL to store value extracted
     D W@VL            S              1    DIM(256)

      ** Work array for warning message Ids
     D WPrvWarnAr      S                   Dim(ArrayMax)
     D                                     Like(WMsgIDArr)

      ** Commitment Control Job Array                                                         CSC022
     D WJobs           S             10A   Dim(10)                                            CSC022
      **                                                                                      CSC022
      ** Incoming header
     D HeadIn        E DS                  EXTNAME(APHEADPD)

      ** Incoming transaction in screen format
     D TranInIPY1    E DS                  EXTNAME(FTIPY1PD)
     D TranInIP1A    E DS                  EXTNAME(FTIPY1APD)
     D TranInIPY2    E DS                  EXTNAME(FTIPY2PD)
     D TranInIPY3    E DS                  EXTNAME(FTIPY3PD)
     D TranInIPY4    E DS                  EXTNAME(FTIPY4PD)
     D TranInIP4A    E DS                  EXTNAME(FTIPY4APD)
     D TranInIPY5    E DS                  EXTNAME(FTIPY5PD)
     D TranInIPY6    E DS                  EXTNAME(FTIPY6PD)
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 7 from transaction - screen fmt                         CSW209
     D TranInIPY7    E DS                  EXTNAME(FTIPY7PD)                                  CSW209
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 8 from transaction - screen fmt                         CSW209
     D TranInIPY8    E DS                  EXTNAME(FTIPY8PD)                                  CSW209
      *                                                                                       CER049
      ** Incoming Payments Lvl 2 Scrn 9 from transaction - screen fmt                         CER049
     D TranInIPY9    E DS                  EXTNAME(FTIPY9PD)                                  CER049
      *
     D TranInIP6A    E DS                  EXTNAME(FTIPY6APD)                                 CER030

      ** Valid file layout
     D ValidIPAY     E DS                  EXTNAME(FTVIPAYPD)
     D ValidIPY2     E DS                  EXTNAME(FTVIPY2PD)

      ** Valid file layout - default
     D DefValid      E DS                  EXTNAME(FTVIPAYPD)
     D                                     PREFIX(D#)
     D DefValidx     E DS                  EXTNAME(FTVIPY2PD)
     D                                     PREFIX(D#)

      * Valid Incoming payment                                                                CER001
     D IPAYValPmt    E DS                  EXTNAME(FTVIPLX1PD)                                CER001
                                                                                              CER001
      ** Incoming Payment                                                                     CER001
     D IPAYExFilFmt  E DS                  EXTNAME(FTIPX1PD)                                  CER001
                                                                                              CER001
      ** Incoming Payment OK extension Flags                                                  CER001
     D OKExtFlg      E DS                  EXTNAME(FTEIPLX1PD)                                CER001
                                                                                              CER001
     D PDATALUX        DS          1024                                                       CER001
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
     D**#1RCCO**             134    143  0                                            CER001 CSD027A
     D  #1RCCO               134    143                                                      CSD027A
     D  #1SNTP               144    144                                                       CER001
     D  #1SND1               145    179                                                       CER001
                                                                                              CER001
      ** Current transaction record in file format
     D IPAYFilFmt    E DS                  EXTNAME(INPAYDD)
     D IPY2FilFmt    E DS                  EXTNAME(INPAYXPD)
     D                                     PREFIX(CR)                                         CER001

      ** Current transaction in screen format
     D CurTrIPY1     E DS                  EXTNAME(FTIPY1PD)
     D                                     PREFIX(O)
     D CurTrIP1A     E DS                  EXTNAME(FTIPY1APD)
     D                                     PREFIX(O)
     D CurTrIPY2     E DS                  EXTNAME(FTIPY2PD)
     D                                     PREFIX(O)
     D CurTrIPY3     E DS                  EXTNAME(FTIPY3PD)
     D                                     PREFIX(O)
     D CurTrIPY4     E DS                  EXTNAME(FTIPY4PD)
     D                                     PREFIX(O)
     D CurTrIP4A     E DS                  EXTNAME(FTIPY4APD)
     D                                     PREFIX(O)
     D CurTrIPY5     E DS                  EXTNAME(FTIPY5PD)
     D                                     PREFIX(O)
     D CurTrIPY6     E DS                  EXTNAME(FTIPY6PD)
     D                                     PREFIX(O)
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 7 from file - screen format                             CSW209
     D CurTrIPY7     E DS                  EXTNAME(FTIPY7PD)                                  CSW209
     D                                     PREFIX(O)                                          CSW209
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 8 from file - screen format                             CSW209
     D CurTrIPY8     E DS                  EXTNAME(FTIPY8PD)                                  CSW209
     D                                     PREFIX(O)                                          CSW209
      *                                                                                       CER030
     D CurTrIP6A     E DS                  EXTNAME(FTIPY6APD)                                 CER030
     D                                     PREFIX(O)                                          CER030

      ** Extra data in file format
     D ExtData       E DS                  EXTNAME(FTIPEXPD)
     D RegData       E DS                  EXTNAME(FTIPRXPD)                                  CER001
     D StopFTDta     E DS                  EXTNAME(FTIPY10APD)                              MD050928

      ** Error indicators
     D OKTrIPY1      E DS                  EXTNAME(FTEIPY1PD)
     D OKTrIPY2      E DS                  EXTNAME(FTEIPY2PD)
     D OKTrIPY3      E DS                  EXTNAME(FTEIPY3PD)
     D OKTrIPY4      E DS                  EXTNAME(FTEIPY4PD)
     D OKTrIPY5      E DS                  EXTNAME(FTEIPY5PD)
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 7 error indicators                                      CSW209
     D OKTrIPY7      E DS                  EXTNAME(FTEIPY7PD)                                 CSW209
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 8 error indicators                                      CSW209
     D OKTrIPY8      E DS                  EXTNAME(FTEIPY8PD)                                 CSW209

      ** Externally described DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Externally described DS for API ICD details
     D SDAPI         E DS                  EXTNAME(SDAPIPD)

      ** Externally described DS for General Ledger ICD details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)

      ** Externally described DS for Midas Modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      ** Externally described DS for Funds Transfer ICD details
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)

      ** Externally described DS for Retail ICD details
     D SDRETL        E DS                  EXTNAME(SDRETLPD)
     D  SDRETLACCD   E                     EXTFLD(QQACCD)                                     CGL029

      ** External DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)

      ** Externally described DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      ** Externally described DS for Branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)

      ** Externally described DS for FONTIS details
     D SDFONT        E DS                  EXTNAME(SDFONTPD)

      ** Externally described DS for Account details
     D SDACCT        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(IF)

      ** Externally described DS for Counterpary nostro                                     MD030906
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)                                MD030906
                                                                                            MD030906
      ** Externally described DS for Nostro details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D  QQACC2       E                     EXTFLD(QQACCD)                                     CGL029

      ** First DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** Second DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** 24X7 Status DataArea Layout
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
     D  WPRDTE                 5      9  0

      ** SD Status DataArea Layout
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)

      ** SCCMTJOB DataArea Layout                                                             CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WDSJobs                4    103A                                                      CSC022
      **                                                                                      CSC022
      ** FT Control Data
     D PCNTRL          DS           256
     D  PGLUI                  4      4
     D  PVATT                  6      6

      ** DS for VAT details
     D PVATDS          DS
     D  PVATR                 10     12P 4

      ** DS for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10
     D  PDBRN                 11     13
     D  PDPPT                 14     16

      ** DS for CASH details
     D PCSHDTA         DS           512
     D  WDACACD               21     24  0

      ** DS to split Message Reference when maintenance is called
      ** by linked maintenance/enquiry
     D WMsgRefDS       DS
     D  WRefMsg                1      8  0
     D  WRefPrt                9     11  0

      **  DS for Date change
     D WWDT            DS             6
     D  WD1                    1      2
     D  WD2                    3      4
     D  WD3                    5      6

      ** DS for Account key
     D***WACKYDS         DS            18                                                     CGL029
     D WACKYDS         DS            24                                                       CGL029
     D**KACNUM**               1      6  0                                                    CSD027
     D  KACNUM                 1      6                                                       CSD027
     D  KACCCY                 7      9
     D***KACCD**               10     13  0                                                   CGL029
     D***KACSQ**               14     15  0                                                   CGL029
     D***KBRCA**               16     18                                                      CGL029
     D  KACCD                 10     19  0                                                    CGL029
     D  KACSQ                 20     21  0                                                    CGL029
     D  KBRCA                 22     24                                                       CGL029

      ** DS for IBANs full account
     D PIBANAcc        DS
     D**IBCNUM**               1      6  0                                                    CSD027
     D  IBCNUM                 1      6                                                       CSD027
     D  IBCCY                  7      9
     D***IBACOD*               10     13  0                                                   CGL029
     D***IBACSQ*               14     15  0                                                   CGL029
     D***IBBRCA*               16     18                                                      CGL029
     D  IBACOD                10     19  0                                                    CGL029
     D  IBACSQ                20     21  0                                                    CGL029
     D  IBBRCA                22     24                                                       CGL029

      ** DS to format P53
     D                 DS
     D  WWP53                  1     35
     D  WWP53A                 1      1
     D  WWP53B                 2     35

      ** DS to format P59
     D                 DS
     D  WWP59                  1     35
     D  WWP59A                 1      1
     D  WWP59B                 2     35

      ** DS to format work variable of Beneficiary
     D                 DS
     D  WWBNC1                 1     35
     D  WWCUS1                 1      6
     D***WWACD1*                7     10                                                      CGL029
     D***WWSQN1*               11     12                                                      CGL029
     D***WWBCH1*               13     15                                                      CGL029
     D  WWACD1                 7     16                                                       CGL029
     D  WWSQN1                17     18                                                       CGL029
     D  WWBCH1                19     21                                                       CGL029

      ** DS for obtaining Rate
     D WR1             DS
     D  WSR                    1     13
     D                                     DIM(13)

      ** DS for obtaining Rate (SRRATE36)
     D WWR1            DS
     D  W@R1                   1     13
     D                                     DIM(13)

      ** Work array - Multiple lines of First Line of Pxx fields
     D                 DS
     D  LFLT                   1    295    DIM(5)
     D**BG1*****               1     24                                                       247398
     D**TV1*****              25     59                                                       247398
     D**BG2*****              60     83                                                       247398
     D**TV2*****              84    118                                                       247398
     D**BG3*****             119    142                                                       247398
     D**TV3*****             143    177                                                       247398
     D**BG4*****             178    201                                                       247398
     D**TV4*****             202    236                                                       247398
     D**BG5*****             237    260                                                       247398
     D**TV5*****             261    295                                                       247398
     D  BG1                    1     30                                                       247398
     D  TV1                   31     59                                                       247398
     D  BG2                   60     89                                                       247398
     D  TV2                   90    118                                                       247398
     D  BG3                  119    148                                                       247398
     D  TV3                  149    177                                                       247398
     D  BG4                  178    207                                                       247398
     D  TV4                  208    236                                                       247398
     D  BG5                  237    266                                                       247398
     D  TV5                  267    295                                                       247398

      ** Data structure used for FT0010
     D P#0010          DS           256
     D  P#NDCY                 1      3
     D  P#NDAM                 4     10P 0
     D  P#DBCY                11     13
     D  P#DBAM                14     20P 0
     D  P#DBDT                21     23P 0
     D  P#CRCY                24     26
     D  P#CRAM                27     33P 0
     D  P#PDCY                34     36
     D  P#PDAM                37     43P 0
     D  P#CRDT                44     46P 0
     D  P#RATE                47     53P 8
     D  P#MDIN                54     54  0
     D  P#OVRT                55     55
     D  P#SDIN                56     56
     D  P#RTDS                57     59P 4

     D  P#FRCY                11     13
     D  P#FRAM                14     20P 0
     D  P#FRDT                21     23P 0
     D  P#TOCY                24     26
     D  P#TOAM                27     33P 0
     D  P#TODT                44     46P 0

     D  P#PMSQ                60     69
     D  P#INDC                70     74
     D  P#RTCD                75     81
     D  P#INTC                82     99  3
     D  P#INTD               100    117  3

      ** Break down MIDAS equivalent
     D WRCDE2          DS
     D  WRCNUM                 1      6
     D  WRCYCD                 7      9
     D***WRACOD*               10     13                                                      CGL029
     D***WRACSQ*               14     15                                                      CGL029
     D***WRBRCD*               16     18                                                      CGL029
     D***WRCDSQ*               10     15                                                      CGL029
     D***WRCSB**               10     18                                                      CGL029
     D  WRACOD                10     19                                                       CGL029
     D  WRACSQ                20     21                                                       CGL029
     D  WRBRCD                22     24                                                       CGL029
     D  WRCDSQ                16     21                                                       CGL029
     D  WRCSB                 10     24                                                       CGL029

      ** DS to hold G/L account number
     D WDSGLDG         DS
     D  WGLCST                 1      6
     D  WGLCCY                 7      9
     D***WGLACD*               10     13                                                      CGL029
     D***WGLSQN*               14     15                                                      CGL029
     D***WGLBCH*               16     18                                                      CGL029
     D  WGLACD                10     19                                                       CGL029
     D  WGLSQN                20     21                                                       CGL029
     D  WGLBCH                22     24                                                       CGL029

      ** Output Data Structure for reformatted address
     D POADD           DS           175
     D  OADD1                  1     35
     D  OADD2                 36     70
     D  OADD3                 71    105
     D  OADD4                106    140
     D  OADD5                141    175

      ** DS for Additional Info details
     D PAddInfm        DS           196

      ** DS for Default Charge Amounts
     D PCharges        DS           196

      ** DS for Default Charge Currencies
     D PChgCcy         DS            48

      ** DS for next Incoming Payment Reference Number
     D WINPAY          DS             4
     D  WINSQ                  1      4  0

      ** Warning message work inds for charges screen
     D PChgWarn        DS            24
     D  WFTF3176               1      1
     D  WFTF3177               2      2
     D  WFTF3178               3      3
     D  WFTF3179               4      4
     D  WFTF3202               5      5
     D  WFTF3204               6      6
     D  WFTF3182               7      7
     D  WFTF3184               8      8
     D  WFTF3185               9      9
     D  WFTF3186              10     10
     D  WFTF3187              11     11
     D  WFTF3188              12     12
     D  WFTF3158              13     13
     D  WFTF3159              14     14
     D  WFTF3160              15     15
     D  WFTF3161              16     16
     D  WFTF3203              17     17
     D  WFTF3205              18     18
     D  WFTF3164              19     19
     D  WFTF3171              20     20
     D  WFTF3172              21     21
     D  WFTF3173              22     22
     D  WFTF3174              23     23
     D  WFTF3175              24     24

     D W@CHK           C                   CONST('0123456789.')

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Index for arrays of error message ids etc in amend validation
     D AmIdx           S              3P 0 INZ(0)

      ** Index for arrays of error message ids etc
     D Idx             S              3P 0 INZ(0)

      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0 INZ(0)

      ** Fields (1000A) to receive the incoming transaction                                  CSF011A
     D Trans01         S           1000A                                                     CSF011A
     D Trans03         S           1000A                                                     CSF011A
     D Trans05         S           1000A                                                     CSF011A
      ** Fields (500A) to receive the incoming transaction
     D Trans5001       S            500A
     D Trans5002       S            500A
     D Trans5003       S            500A
     D Trans5004       S            500A
     D Trans5005       S            500A
     D Trans5006       S            500A
     D Trans5007       S            500A
     D Trans5008       S            500A
     D Trans5009       S           1000A                                                      CSW209
     D Trans5010       S           1000A                                                      CSW209
     D Trans5011       S            500A                                                      CER049
     D***Trans5009       S            500A                                             CER030 262664
     D Trans5008A      S            500A                                                      262664
     D RegData500      S            500A                                                      CER001

      ** Field (500A) to receive the incoming Extra Data
     D ExtData500      S            500A

      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
     D PMode           S              6A
     D PModuleId       S              2A

      ** Entry parameters
     D UpdateYN        S              1A
     D Buffer          S           6000A
     D APIRetc         S              1A

     D PRetCodeIn      S             10                                                       CER001
     D PActn           S              1                                                       CER001
     D PFrontID        S             20                                                       CER001
     D PPayRef         S             15                                                       CER001
                                                                                              CER001
     D WWCUTY          S              2A                                                      CER001
     D @CUST           S              6A                                                      CER001
     D WFIND           S              1                                                       CER001
                                                                                              CER001
      ** SARs
     D S01494          S              1A
     D S01499          S              1A
     D S01506          S              1A
     D S01508          S              1A
     D CEU006          S              1A
     D CGL009          S              1A
     D CFT004          S              1A
     D CFT003          S              1A
     D CFT002          S              1A
     D CFT014          S              1A
     D CFT009          S              1A
     D CFT010          S              1A
     D CSC011          S              1A
     D CSD015          S              1A
     D CCF001          S              1A
     D CSC022          S              1A                                                      CSC022
      *                                                                                       CFT120
      ** CFT120 switchable field                                                              CFT120
      *                                                                                       CFT120
     D CFT120          S              1A                                                      CFT120
     D/COPY WNCPYSRC,FTH00559

      ** Work variables
     D PParmLEVEL      S              1A   INZ('1')
     D PLinkPgm        S             10A   INZ(*BLANKS)
     D PReference      S             18A
     D PAReference     S             18A
     D PProcDte        S              5P 0
     D PPrDate         S              6P 0
     D PPrADate        S              7A
     D WSubIP1         S              1A
     D WSubIP1a        S              1A
     D WSubIP2         S              1A
     D WSubIP3         S              1A
     D WSubIP4         S              1A
     D WSubIP4a        S              1A
     D WSubIP5         S              1A
     D WSubIP6         S              1A
     D WArrPtr         S              3S 0                                                    CSC022
     D WSkpComtRolbk   S              1A                                                      CSC022

     D PPRefInsert     S              1A   INZ(*BLANK)
     D WLvl2           S              1A
     D OKSWTN          S              1A
     D OKSEQNO         S              1A
     D WBTPCRD         S              5P 2

     D PPrvTRI         S             34A
     D PPrvNDAM        S             14A
     D PPYBR           S              3A
     D PACBDS          S             18A
     D PSNDDS          S             18A
     D PRCCDS          S             18A
     D PBNCDS          S             18A

     D PSetInCy        S              1A
     D PSetTPSD        S              5P 0
     D PPayInCy        S              1A
     D PPayTPSD        S              5P 0

     D PPrvCDRT        S              1A
     D***PPrvCDRO        S             12A                                                    CGL029
     D PPrvCDRO        S             18A                                                      CGL029
     D PPrvCDBR        S              3A
     D PPrvCDRC        S              3A                                                      CFT120
     D PReCalc         S              1A
     D PICcy           S              3A
     D PIInCy          S              1A
     D PINbdp          S              1P 0
     D PITPSD          S              5P 0
     D POCcy           S              3A
     D POInCy          S              1A
     D PONbdp          S              1P 0

     D PFrcRedisplay   S              1A
     D PPrvDDRCRM      S             12A
     D PPrvTotChg      S             15P 0
     D PCDROChg        S              1A

     D PStatus         S             10A
     D PPYTP           S              2A

     D PIncData        S           2000A
     D PCurData        S           2000A
     D PResetFld       S              1A
     D PAmendOk        S              1A
     D WWInsQ          S              4P 0
     D PDayNo          S              5P 0
     D PFmt            S              1A
     D PDate           S              6P 0
     D PADate          S              7A

     D WN2             S              2P 0
     D WA4             S              4A
     D WA2             S              2A
     D WA2A            S              2A
     D WA6             S              6A
     D IA              S              2P 0
     D PTranID         S             20A

     D PRtCd           S              7A   INZ(*BLANK)
     D POptn           S              7A   INZ(*BLANK)
     D PSard           S              7A   INZ(*BLANK)
     D PCurr           S              3A
     D ULX043          S              1A   INZ(*BLANKS)                                       CER001
     D PBCDP           S              1P 0
     D PLCDP           S              1P 0
     D PLMDIn          S              1P 0
     D PLSpot          S             13P 8

     D POrigActn       S              1A
     D PFTOV           S              1A
     D PResponse       S              1A   INZ('S')

     D PErrMs          S              7A
     D ZalignOk        S              1A
     D ZField          S             16A
     D ZADec           S              1P 0
     D ZADig           S              2P 0

     D WErr            S              1A   INZ(*BLANK)
     D PACTD           S              8A
     D L               S              2P 0
     D PCHR03          S              3A
     D WRCRMNDP        S              1P 0
     D Cx              S              3P 0
     D Ex              S              3P 0
     D WAMT            S             15A
     D ZDateIn         S              6A
     D ZDateOut        S              5P 0
     D ZDateFmt        S              1A
     D ZDate1OK        S              1A
     D WOVVLD          S              5P 0
     D WSLDT           S              5P 0
     D WWK1            S              1A
     D WOCMT           S              3P 0
     D WPCYD           S              1P 0
     D W1PYA           S             11P 0
     D WSMCY           S              1P 0
     D W1SMA           S             11P 0
     D W1RTE           S             11P 7
     D ZADEC2          S              2P 0
     D PBRCH           S              3A
     D WREAC           S             10A
     D P@IBAN          S             34A
     D WSEQNO          S              2P 0
     D PACT            S              7A
     D PMSGR           S              8P 0
     D PKPRT           S              3P 0
     D PMOR            S             28A
     D PMIR            S             28A
     D PRTN            S              7A
     D WFirstErr       S              1A   INZ('N')
                                                                                              CGL014
     D CGL014          S              1                                                       CGL014
                                                                                              CGL014
      ** Field (1000A) to receive the incoming Customer Name                                  CSF011
     D WNumDetlIn      S           1000A                                                      CSF011
                                                                                              CSF011
     D ACCNT_AC      E DS                  EXTNAME(ACCNTAB)                                   CSF011
     D                                     PREFIX(AC_)                                        CSF011
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSF011
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CSF011
     D CusIdx          S              4S 0 INZ(1)                                             CSF011
     D CusIdx2         S              4S 0 INZ(1)                                             CSF011
     D AccLength       S              2S 0 INZ(72)                                            CSF011
     D ACusLngth       S              2S 0 INZ(52)                                            CSF011
     D NoOfCusField    S              2S 0 INZ(10)                                            CSF011
     D CusOrAcc        C                   CONST('AAAAABABBA')                                CSF011
     D W@Len           S              2S 0                                                    CSF011
     D P@TYP           S             10                                                       CSF011
     D P@Str           S             35                                                       CSF011
     D WNStr           S             35                                                       CSF011
     D P0RETL          S             10                                                       CSF011
     D WCustomer       S             10                                                       CSF011
     D C#KYST          S              7                                                       CSF011
     D W@Abc           S              1                                                       CSF011
     D W@ATyp          S              1                                                       CSF011
     D W@CCY           S              3                                                       CSF011
     D W@BRC           S              3                                                       CSF011
                                                                                              CSW209
      ** SWIFT 2009 flag                                                                      CSW209
     D CSW209          S              1A                                                      CSW209
     D CSC054          S              1A                                                      CSC054
      *                                                                                       CSC054
     D PCNUM           S              6A                                                    MD034973
     D PPYTY           S              2A                                                    MD034973
     D PPYST           S              2A                                                    MD034973
     D InputUser       S             10A                                                    MD042042
      ** +--------------------------------------+
      ** ¦ /COPYs                               ¦
      ** ¦ ======                               ¦
      ** +--------------------------------------+

      /COPY MECPYSRC,ME1100_ILE

      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+

     D OVERRIDE        S              1                                                       CFT115
     D SOVRO           S             10                                                       CFT115
     D SPWRD           S             10                                                       CFT115
     D BtnPressed      S             10A                                                   AR1090283
      /COPY WNCPYSRC,FTIPAYV002

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *                                                                                      BUG7029
      ** Retrieve ZMUSER details.                                                            BUG7029
      *                                                                                      BUG7029
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C                   IN        ZMUSER                                                    BUG7029

      /COPY WNCPYSRC,FTIPAYV003

      ** Incoming transaction is broken into 500A fields, so that a common CL
      ** can be used between this module and the one that read the MQ queue.
      ** This module needs to break these 500A fields by loading them into
      ** the appropriate (externally described) data structure.

     C**********         MOVEL     Trans5001     TranInIPY1                                  CSF011A
     C                   MOVEL     Trans01       TranInIPY1                                  CSF011A
     C                   MOVEL     Trans5002     TranInIP1A
     C**********         MOVEL     Trans5003     TranInIPY2                                  CSF011A
     C                   MOVEL     Trans03       TranInIPY2                                  CSF011A
     C                   MOVEL     Trans5004     TranInIPY3
     C**********         MOVEL     Trans5005     TranInIPY4                                  CSF011A
     C                   MOVEL     Trans05       TranInIPY4                                  CSF011A
     C                   MOVEL     Trans5006     TranInIP4A
     C                   MOVEL     Trans5007     TranInIPY5
     C                   MOVEL     Trans5008     TranInIPY6
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   MOVEL     Trans5009     TranInIPY7                                   CSW209
     C                   MOVEL     Trans5010     TranInIPY8                                   CSW209
     C                   ENDIF                                                                CSW209
     C**********         MOVEL     Trans5009     TranInIP6A                            CER030 262664
     C                   MOVEL     Trans5008A    TranInIP6A                                   262664
     C                   MOVEL     Trans5011     TranInIPY9                                   CER049
     C                   MOVEL     RegData500    RegData                                      CER001
     C/COPY WNCPYSRC,FTIPAYV021
     C                   MOVEL     Extdata500    Extdata
     C
     C     NewButton     Ifeq      'YES'                                                      255190
     C                   Eval      PMTPY = *blanks                                            255190
     C                   Eval      NewButton = *blanks                                        255190
     C                   Else                                                                 255190
     C                   Eval      PMTPY = NewButton                                          255190
     C                   Endif                                                                255190

      ** Reset variables gradually updated
     C                   EXSR      ResetCycle

      /COPY WNCPYSRC,FTIPAYV004

      ** Validate action code
     C*****DDACTN        IFNE      'S'                                                BUG1282 CFT157
     C*****DDACTN        IFNE      'C'                                               CFT157 MD037938
     C*****CFT157        IFEQ      'N'                                             MD037938 MD038991
     C     DDSWFLG       IFEQ      'Y'                                                      MD038991
     C     DDACTN        ANDNE     'S'                                                      MD037938
     C*****CFT157        OREQ      'Y'                                             MD037938 MD038991
     C     DDSWFLG       ORNE      'Y'                                                      MD038991
     C     DDACTN        ANDNE     'C'                                                      MD037938
     C                   EXSR      ValidateAc
     C                   ELSE                                                                BUG1282
      *                                                                                      BUG1282
      ** Delete reserved messages if user presses cancel                                     BUG1282
      *                                                                                      BUG1282
     C                   EXSR      DlRsMsg                                                   BUG1282
     C                   EVAL      *INLR = *ON                                               BUG1282
     C                   RETURN                                                              BUG1282
     C                   ENDIF                                                               BUG1282

      /COPY WNCPYSRC,FTIPAYV005

      ** If error in validation of action code, fail this input
     C                   IF        Idx <> 0
     C                   GOTO      INVALID
     C                   ENDIF

      ** Processing depends upon action code
     C                   SELECT

      ** INSERT
      ** ======
     C                   WHEN         DDACTN = 'I'

      ** Set up necessary swift fields if swift reference is entered and
      ** it is still not yet reserved.
     C                   IF        DDSWTN <> *BLANKS AND
     C                             DDSWFLG <> 'Y'
     C                   EXSR      SrEISwft
      *                                                                                       BUG515
     C                   IF        Idx <> 0                                                   BUG515
     C                   GOTO      INVALID                                                    BUG515
     C                   ENDIF                                                                BUG515
      *                                                                                       BUG515
     C                   ENDIF

      /COPY WNCPYSRC,FTIPAYV006

      ** Validate incoming Incoming Payment details.
     C                   EXSR      ValidateTr

      /COPY WNCPYSRC,FTIPAYV007

      ** AMEND
      ** =====
     C                   WHEN         DDACTN = 'A'

      /COPY WNCPYSRC,FTIPAYV008

      ** Convert original Incoming Payment details from file
      ** to screen format.
     C                   EXSR      ConvertIPAY

      /COPY WNCPYSRC,FTIPAYV009

      ** Check if there are substitutions in the screen
      ** details.
     C                   EXSR      ChkDtaSubs

      /COPY WNCPYSRC,FTIPAYV010

      *                                                                                       CFT120
      ** Following lines taken from CFT009 in FTIPAY4DP no longer used                        CFT120
      ** in Java front end. Prevents spot rate on CFT009 extension file                       CFT120
      ** being updated without change to CDRO. Save Charges to the                            CFT120
      ** debit of field - we  need to know if it changes and we need                          CFT120
      ** to re-call ft000981 in validation modules if it has.                                 CFT120
      *                                                                                       CFT120
     C     *LIKE         DEFINE    DDCDRO        PrvDDCDRO                                    CFT120
     C     *LIKE         DEFINE    DDCDRC        PrvDDCDRC                                    CFT120
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   EVAL      PrvDDCDRO = DDCDRO                                         CFT120
     C                   EVAL      PrvDDCDRC = DDCDRC                                         CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
      ** Validate incoming Incoming Payment details.
     C                   EXSR      ValidateTr

      /COPY WNCPYSRC,FTIPAYV011

      ** Check if amended fields are amendable.
     C                   EXSR      ValidateAmd

      /COPY WNCPYSRC,FTIPAYV012

     C                   ENDSL
      *
     C     INVALID       TAG

      ** Populate Account Details                                                             CSF011
                                                                                              CSF011
     C                   EXSR      SrCustActN                                                 CSF011
                                                                                              CSF011
      /COPY WNCPYSRC,FTIPAYV013

      ** Write to database
     C                   IF        UpdateYN = 'Y' AND
     C                             Idx = 0 AND
     C                             WErr = *BLANK

      /COPY WNCPYSRC,FTIPAYV014
     C                   EXSR      SetUpValid
     C                   EXSR      UpdateDB
      *                                                                                      BUG3279
      * Clear any reserved messages by this job                                              BUG3279
     C     DDSWFLG       IFEQ      'Y'                                                       BUG3279
     C                   EXSR      DlRsMsg                                                   BUG3279
     C                   ENDIF                                                               BUG3279
     C                   ENDIF

      ** Set up default charges and currencies in TranInIPY6

     C                   EVAL      %SUBST(TranInIPY6:11:196) = PCharges
     C                   EVAL      WPICCY = PICCY
     C                   EVAL      WPOCCY = POCCY
      *                                                                                       255190
      ** If error occurred, save IPINMTPY to SavedPMTPY, else blank                           255190
      *                                                                                       255190
     C                   Eval      NewButton = IPINMTPY                                       255190

      ** Remerge buffer with all relevant data structures

     C                   EVAL      Buffer = TranInIPY1 + TranInIP1A +
     C                                      TranInIPY2 + TranInIPY3 +
     C                                      TranInIPY4 + TranInIP4A +
     C                                      TranInIPY5 + TranInIPY6 +
     C                                           OVERRIDE + SOVRO                             CFT115
     C                                           + SPWRD +                                    CFT115
     C                                      TranInIPY7 + TranInIPY8 +                         CSW209
     C                                      TranInIP6A +                                      CER030
     C                                      @TimeStamp +                                     BUG4196
     C                                      NewButton +                                       255190
     C                                      TranInIPY9 +                                      CER049
     C                                      AAuth +                                           CAP211
     C                                      BtnPressed +                                   AR1090283
     C                                      ExtData +                                       MD042042
     C                                      InputUser +                                     MD042042
     C                                      RegData +                                       MD050928
     C                                      StopFTDta                                       MD050928
     C**********                            RegData                                MD042042 MD050928
     C**********                            RegData +                                CER001 MD042042
     C**********                            ExtData                                         MD042042

     C                   EVAL      *INLR = *ON

     C                   RETURN

      *****************************************************************
      /EJECT
      *****************************************************************

      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FTIPAYV015

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ValidateAc - Routine to validate action code versus the       *
      *              transaction number supplied                      *
      *                                                               *
      *****************************************************************
     C     ValidateAc    BEGSR

      *                                                                                     MD036159
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)                        MD036159
      *  if insert                                                                          MD036159
      *  if not insert and Midas transaction ID is not present                              MD036159
      * Otherwise                                                                           MD036159
      *  Set retrieve mode to blank  (Access using Midas transaction ID).                   MD036159
      *                                                                                     MD036159
     C     DDACTN        IFEQ      'I'                                                      MD036159
     C                   MOVEL     '*FRONT'      PMode                                      MD036159
     C                   ELSE                                                               MD036159
     C     DDPREF        IFEQ      *BLANK                                                   MD036159
     C                   MOVEL     '*FRONT'      PMode                                      MD036159
     C                   ELSE                                                               MD036159
     C                   MOVEL     '      '      PMode                                      MD036159
     C                   ENDIF                                                              MD036159
     C                   ENDIF                                                              MD036159
                                                                                            MD036159
     C                   IF        APFOTRANID <> *BLANKS AND                                MD036159
     C                             DDACTN  = 'I'                                            MD036159
     C                   EVAL      PMode = '*FRONT'                                         MD036159
     C                   ELSE                                                               MD036159
     C                   MOVEL     '      '      PMode                                      MD036159
     C                   ENDIF                                                              MD036159
                                                                                            MD036159
      ** Validate action code versus transaction IDs supplied
      ** The Transaction in file format from the FT database is retrieved
      ** as well.

     C                   CALLB     'FTIPAYRTV'
      *                             =========
      ** INPUT
      ** =====

      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut

     C**********         PARM      *BLANKS       PMode                                      MD036159
     C                   PARM                    PMode                                      MD036159

      ** Response Mode (from caller: A=Asynchronous, S=Synchronous)
     C                   PARM                    PResponse

      ** Action Code
     C                   PARM                    DDACTN

      ** Front Office Transaction Id
     C                   PARM                    APFOTranId

      ** Payment Reference
     C                   PARM                    DDPREF

      ** Booking Branch
     C                   PARM                    DDBRCA

      ** SWIFT Reference
     C                   PARM                    DDSWTN

      ** Entry Point
     C                   PARM                    PParmLevel

      ** Linked Program
     C                   PARM                    PLinkPgm

      ** Validate Payment Reference for Insert
     C                   PARM      'Y'           PPrefInsert

      ** STANDING DATA
      ** =============

      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDGELR - Originating Branch/User Vald Req.
     C                   PARM                    BKOBUV
      *
      ** ZMUSER - Default Branch
     C                   PARM                    PDBRN

      ** SWITCHABLE FEATURES
      ** ===================

      ** BLI FT Enhancements Feature
     C                   PARM                    S01494

      ** BLI VAT Processing Feature
     C                   PARM                    S01499

      ** FT Batch Auth and Credit Advices
     C                   PARM                    CFT003

      ** STP Phase 2 MT103
     C                   PARM                    CFT014

      ** Fees & Charges
     C                   PARM                    CFT009

      ** OUTPUT
      ** ======

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** OK Action Code
     C                   PARM                    OKACTN

      ** OK Payment Reference
     C                   PARM                    OKPREF

      ** OK Booking Branch
     C                   PARM                    OKBRCA

      ** Incoming Payments retrieved from file - file format
     C                   PARM                    IPAYFilFmt
     C                   PARM                    IPY2FilFmt

      /COPY WNCPYSRC,FTIPAYV016
                                                                                              CER001
     C                   IF        ULX043 = 'Y'                                               CER001
                                                                                              CER001
     C                   CALLB     'FTIPAY2RV'                                                CER001
      *                                                                                       CER001
      ** Inputs                                                                               CER001
      *                                                                                       CER001
      ** Return code                                                                          CER001
      *                                                                                       CER001
     C                   PARM      *BLANKS       PRetCodeIn                                   CER001
      *                                                                                       CER001
      ** Action Code                                                                          CER001
      *                                                                                       CER001
     C                   PARM      DDACTN        PActn                                        CER001
      *                                                                                       CER001
      ** Front Office Transaction ID                                                          CER001
      *                                                                                       CER001
     C                   PARM      APFOTranId    PFrontID                                     CER001
      *                                                                                       CER001
      ** Payment Reference                                                                    CER001
      *                                                                                       CER001
     C                   PARM      DDPREF        PPayRef                                      CER001
      *                                                                                       CER001
      ** Outputs                                                                              CER001
      *                                                                                       CER001
      ** incoming payment extension details                                                   CER001
      *                                                                                       CER001
     C                   PARM                    IPAYExFilFmt                                 CER001
      *                                                                                       CER001
      ** Move the retrieved data to valid incoming payment extension DS                       CER001
      *                                                                                       CER001
     C                   EVAL      #LLXIPFOTR = PFrontID                                      CER001
     C                   EVAL      #LLXIPPREF = PPayRef                                       CER001
     C                   EVAL      #LLXIPORTY = INORTY                                        CER001
     C                   EVAL      #LLXIPBETY = INBETY                                        CER001
     C                   EVAL      #LLXIPOPCO = INOPCO                                        CER001
     C                   EVAL      #LLXIPCOCO = INCOCO                                        CER001
     C                   EVAL      #LLXIPIDCO = INIDCO                                        CER001
     C                   EVAL      #LLXIPIDEN = INIDEN                                        CER001
                                                                                              CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ConvertIPAY - Convert Incoming Payment details from file to  *
      *                screen format                                  *
      *                                                               *
      *****************************************************************

     C     ConvertIPAY   BEGSR

     C                   CALLB     'FTIPAYCVT'
      *                             =========
      ** INPUT
      ** =====

      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut

      ** Incoming Payments retrieved from file - file format
     C                   PARM                    IPAYFilFmt
     C                   PARM                    IPY2FilFmt

      ** Action Code
     C                   PARM                    DDACTN

      ** STANDING DATA
      ** =============

      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC

      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN

      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD

      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY

      ** SDGELR - Profit Centre Used
     C                   PARM                    BKPRCU

      ** SDGELR - Originating Branch Used
     C                   PARM                    BKOBRU

      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST

      ** SDFTFR - Charges Currency
     C                   PARM                    BTCHCY

      ** SDFTFR - Fixed Charge Currency
     C                   PARM                    FCHCCY

      ** SWITCHABLE FEATURES
      ** ===================

      ** EMU FT Settlement Currency Conversion
     C                   PARM                    CEU006

      ** BLI Funds Transfer Enhancement Feature
     C                   PARM                    S01494

      ** BLI VAT Processing Feature
     C                   PARM                    S01499

      ** Electronic Banking Interface IATs and TPPs
     C                   PARM                    CGL009

      ** STP Phase 2 MT103
     C                   PARM                    CFT014

      ** Fees & Charges
     C                   PARM                    CFT009
     C                   PARM                    CFT010

      ** OUTPUT
      ** ======

      ** Incoming Payments Lvl 1 Scrn details retrieved from file
      ** - screen format
     C                   PARM                    CurTrIPY1
     C                   PARM                    CurTrIP1A

      ** Incoming Payments Lvl 2 Scrn 1/1 details retrieved from file
      ** - screen format
     C                   PARM                    CurTrIPY2

      ** Incoming Payments Lvl 2 Scrn 1/2 details retrieved from file
      ** - screen format
     C                   PARM                    CurTrIPY3

      ** Incoming Payments Lvl 2 Scrn 2 details retrieved from file
      ** - screen format
     C                   PARM                    CurTrIPY4
     C                   PARM                    CurTrIP4A

      ** Incoming Payments Lvl 2 Scrn 3 details retrieved from file
      ** - screen format
     C                   PARM                    CurTrIPY5

      ** Incoming Payments Margin Info details retrieved from file
      ** - screen format
     C                   PARM                    CurTrIPY6
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 7 details retrieved from file                           CSW209
      ** - screen format                                                                      CSW209
     C                   PARM                    CurTrIPY7                                    CSW209
      *                                                                                       CSW209
      ** Incoming Payments Lvl 2 Scrn 8 details retrieved from file                           CSW209
      ** - screen format                                                                      CSW209
     C                   PARM                    CurTrIPY8                                    CSW209
      *                                                                                       CER030
      ** Incoming Payments Extended Narratives retrieved from file                            CER030
      ** - screen format                                                                      CER030
      *                                                                                       CER030
     C                   PARM                    CurTrIP6A                                    CER030

      ** DS for Additional Information details
     C                   PARM                    PAddInfm

      ** SWIFT Reference
     C                   PARM                    DDSWTN

      ** Sequence No.
     C                   PARM                    DDSEQNO

      ** Incoming Payment Status
     C                   PARM                    PStatus

      ** Payment Type
     C                   PARM                    PPYTP

      ** DS for Default Charge Amounts
     C                   PARM                    PCharges

      ** Input Charge Currency
     C                   PARM                    PICCY

      ** Output Charge Currency
     C                   PARM                    POCCY

      ** Input Charge Currency No. of Decimal Places
     C                   PARM                    PINBDP

      ** Output Charge Currency No. of Decimal Places
     C                   PARM                    PONBDP
     C                   PARM      *BLANKS       BtnPressed                                AR1090283

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ChkDtaSubs - Data Substitution Routine                       *
      *                                                               *
      *****************************************************************

     C     ChkDtaSubs    BEGSR

      ** Substitute the data for the various parts of the transaction.

     C                   IF        WSUBIP1 = 'Y'

     C                   CLEAR                   PIncData
     C                   CLEAR                   PCurData

     C                   CALLB     'APDTASUBS'
      *                             =========
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      ** Substitution Character
     C                   PARM                    GHSUBS
      ** Incoming Data
     C                   PARM      TranInIPY1    PIncData
      ** Current Data
     C                   PARM      CurTrIPY1     PCurData

     C                   MOVEL     PIncData      TranInIPY1

     C                   ENDIF

     C                   IF        WSUBIP1a = 'Y'

     C                   CLEAR                   PIncData
     C                   CLEAR                   PCurData

     C                   CALLB     'APDTASUBS'
      *                             =========
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      ** Substitution Character
     C                   PARM                    GHSUBS
      ** Incoming Data
     C                   PARM      TranInIP1A    PIncData
      ** Current Data
     C                   PARM      CurTrIP1A     PCurData

     C                   MOVEL     PIncData      TranInIP1A

     C                   ENDIF

     C                   IF        WSUBIP2 = 'Y'

     C                   CLEAR                   PIncData
     C                   CLEAR                   PCurData

     C                   CALLB     'APDTASUBS'
      *                             =========
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      ** Substitution Character
     C                   PARM                    GHSUBS
      ** Incoming Data
     C                   PARM      TranInIPY2    PIncData
      ** Current Data
     C                   PARM      CurTrIPY2     PCurData

     C                   MOVEL     PIncData      TranInIPY2

     C                   ENDIF

     C                   IF        WSUBIP3 = 'Y'

     C                   CLEAR                   PIncData
     C                   CLEAR                   PCurData

     C                   CALLB     'APDTASUBS'
      *                             =========
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      ** Substitution Character
     C                   PARM                    GHSUBS
      ** Incoming Data
     C                   PARM      TranInIPY3    PIncData
      ** Current Data
     C                   PARM      CurTrIPY3     PCurData

     C                   MOVEL     PIncData      TranInIPY3

     C                   ENDIF

     C                   IF        WSUBIP4 = 'Y'

     C                   CLEAR                   PIncData
     C                   CLEAR                   PCurData

     C                   CALLB     'APDTASUBS'
      *                             =========
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      ** Substitution Character
     C                   PARM                    GHSUBS
      ** Incoming Data
     C                   PARM      TranInIPY4    PIncData
      ** Current Data
     C                   PARM      CurTrIPY4     PCurData

     C                   MOVEL     PIncDATA      TranInIPY4

     C                   ENDIF

     C                   IF        WSUBIP4a = 'Y'

     C                   CLEAR                   PIncData
     C                   CLEAR                   PCurData

     C                   CALLB     'APDTASUBS'
      *                             =========
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      ** Substitution Character
     C                   PARM                    GHSUBS
      ** Incoming Data
     C                   PARM      TranInIP4A    PIncData
      ** Current Data
     C                   PARM      CurTrIP4A     PCurData

     C                   MOVEL     PIncData      TranInIP4A

     C                   ENDIF

     C                   IF        WSUBIP5 = 'Y'

     C                   CLEAR                   PIncData
     C                   CLEAR                   PCurData

     C                   CALLB     'APDTASUBS'
      *                             =========
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      ** Substitution Character
     C                   PARM                    GHSUBS
      ** Incoming Data
     C                   PARM      TranInIPY5    PIncData
      ** Current Data
     C                   PARM      CurTrIPY5     PCurData

     C                   MOVEL     PIncData      TranInIPY5

     C                   ENDIF

     C                   IF        WSUBIP6 = 'Y'

     C                   CLEAR                   PIncData
     C                   CLEAR                   PCurData

     C                   CALLB     'APDTASUBS'
      *                             =========
      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut
      ** Substitution Character
     C                   PARM                    GHSUBS
      ** Incoming Data
     C                   PARM      TranInIPY6    PIncData
      ** Current Data
     C                   PARM      CurTrIPY6     PCurData

     C                   MOVEL     PIncData      TranInIPY6

     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CSF011
      *****************************************************************                       CSF011
      *                                                               *                       CSF011
      * SrCustActN - Get the Customer or Account Details              *                       CSF011
      *                                                               *                       CSF011
      *****************************************************************                       CSF011
     C     SrCustActN    BEGSR                                                                CSF011
                                                                                              CSF011
      ** Customer fields for retrieval of details                                             CSF011
                                                                                              CSF011
     C                   EVAL      %SUBST(WNumDetlIn:1:35)   = DDSND1                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:36:35)  = DDRCO1                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:71:35)  = DDBNC1                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:106:35) = DDTRIB                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:141:35) = DDACBK                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:176:35) = DDOBK1                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:211:35) = DDORC1                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:246:35) = DDSNC1                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:281:35) = DDINB1                         CSF011
     C                   EVAL      %SUBST(WNumDetlIn:316:35) = DDCDRO                         CSF011
                                                                                              CSF011
      ** With '/' Account                                                                     CSF011
                                                                                              CSF011
     C                   IF        %SUBST(DDSND1:1:1) = '/'                                   CSF011
     C                   IF        DDSND2 <> *BLANKS                                          CSF011
     C                   EVAL      %SUBST(WNumDetlIn:1:35) = DDSND2                           CSF011
     C                   ELSE                                                                 CSF011
     C                   EVAL      WNStr= *BLANKS                                             CSF011
     C                   EVAL      WNStr= %SUBST(DDSND1:2:34)                                 CSF011
     C                   EVAL      %SUBST(WNumDetlIn:1:35) = WNStr                            CSF011
     C                   ENDIF                                                                CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   IF        %SUBST(DDRCO1:1:1) = '/'                                   CSF011
     C                   IF        DDRCO2 <> *BLANKS                                          CSF011
     C                   EVAL      %SUBST(WNumDetlIn:36:35)  = DDRCO2                         CSF011
     C                   ELSE                                                                 CSF011
     C                   EVAL      WNStr= *BLANKS                                             CSF011
     C                   EVAL      WNStr= %SUBST(DDRCO1:2:34)                                 CSF011
     C                   EVAL      %SUBST(WNumDetlIn:36:35)  = WNStr                          CSF011
     C                   ENDIF                                                                CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   IF        %SUBST(DDBNC1:1:1) = '/'                                   CSF011
     C                   IF        DDBNC2 <> *BLANKS                                          CSF011
     C                   EVAL      %SUBST(WNumDetlIn:71:35)  = DDBNC2                         CSF011
     C                   ELSE                                                                 CSF011
     C                   EVAL      WNStr= *BLANKS                                             CSF011
     C                   EVAL      WNStr= %SUBST(DDBNC1:2:34)                                 CSF011
     C                   EVAL      %SUBST(WNumDetlIn:71:35)  = WNStr                          CSF011
     C                   ENDIF                                                                CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   IF        %SUBST(DDOBK1:1:1) = '/'                                   CSF011
     C                   IF        DDOBK2 <> *BLANKS                                          CSF011
     C                   EVAL      %SUBST(WNumDetlIn:176:35) = DDOBK2                         CSF011
     C                   ELSE                                                                 CSF011
     C                   EVAL      WNStr= *BLANKS                                             CSF011
     C                   EVAL      WNStr= %SUBST(DDOBK1:2:34)                                 CSF011
     C                   EVAL      %SUBST(WNumDetlIn:176:35) = WNStr                          CSF011
     C                   ENDIF                                                                CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   IF        %SUBST(DDORC1:1:1) = '/'                                   CSF011
     C                   IF        DDORC2 <> *BLANKS                                          CSF011
     C                   EVAL      %SUBST(WNumDetlIn:211:35) = DDORC2                         CSF011
     C                   ELSE                                                                 CSF011
     C                   EVAL      WNStr= *BLANKS                                             CSF011
     C                   EVAL      WNStr= %SUBST(DDORC1:2:34)                                 CSF011
     C                   EVAL      %SUBST(WNumDetlIn:211:35) = WNStr                          CSF011
     C                   ENDIF                                                                CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   IF        %SUBST(DDSNC1:1:1) = '/'                                   CSF011
     C                   IF        DDSNC2 <> *BLANKS                                          CSF011
     C                   EVAL      %SUBST(WNumDetlIn:246:35) = DDSNC2                         CSF011
     C                   ELSE                                                                 CSF011
     C                   EVAL      WNStr= *BLANKS                                             CSF011
     C                   EVAL      WNStr= %SUBST(DDSNC1:2:34)                                 CSF011
     C                   EVAL      %SUBST(WNumDetlIn:246:35) = WNStr                          CSF011
     C                   ENDIF                                                                CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   IF        %SUBST(DDINB1:1:1) = '/'                                   CSF011
     C                   IF        DDINB2 <> *BLANKS                                          CSF011
     C                   EVAL      %SUBST(WNumDetlIn:281:35) = DDINB2                         CSF011
     C                   ELSE                                                                 CSF011
     C                   EVAL      WNStr= *BLANKS                                             CSF011
     C                   EVAL      WNStr= %SUBST(DDINB1:2:34)                                 CSF011
     C                   EVAL      %SUBST(WNumDetlIn:281:35) = WNStr                          CSF011
     C                   ENDIF                                                                CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   DOW       CusIdx <= NoOfCusField                                     CSF011
                                                                                              CSF011
     C                   EVAL      P@Str = %SUBST(WNumDetlIn:CusIdx2:35)                      CSF011
     C                   EVAL      W@Abc = %SUBST(CusOrAcc:CusIdx:1)                          CSF011
                                                                                              CSF011
     C                   IF        P@Str <> *BLANKS                                           CSF011
                                                                                              CSF011
     C                   IF        W@Abc = 'B'                                                CSF011
                                                                                              CSF011
     C                   EVAL      WCustomer = *BLANKS                                        CSF011
     C                   CALL      'AOCUSTR0'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      '*KEY'        @OPTN                                        CSF011
     C                   PARM                    P@Str                                        CSF011
     C                   PARM      *BLANKS       C#KYST                                       CSF011
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSF011
                                                                                              CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   CALL      'AOIBANR2'                                                 CSF011
     C                   PARM      *Blanks       @RTCD                                        CSF011
     C                   PARM                    P@Str                                        CSF011
     C                   PARM                    DSSDY                                        CSF011
                                                                                              CSF011
     C                   IF        @RTCD = *BLANKS                                            CSF011
     C                   EVAL      ACCNT_AC = DSSDY                                           CSF011
     C                   EVAL      WCustomer = AC_CNUM                                        CSF011
                                                                                              CSF011
     C                   ELSE                                                                 CSF011
                                                                                              CSF011
     C                   EVAL      W@CCY = DDSMCY                                             CSF011
     C                   EVAL      W@BRC = DDORBR                                             CSF011
     C                   IF        (CusIdx = 3 AND DDPCCY <> *BLANKS)                         CSF011
     C                             OR (CusIdx = 5 AND DDPCCY <> *BLANKS)                      CSF011
     C                             OR (CusIdx = 8 AND DDPCCY <> *BLANKS)                      CSF011
     C                   EVAL      W@CCY = DDPCCY                                             CSF011
     C                   ENDIF                                                                CSF011
     C                   IF        CusIdx = 5 AND DDACBB <> *BLANKS                           CSF011
     C                   EVAL      W@BRC = DDACBB                                             CSF011
     C                   ENDIF                                                                CSF011
     C                   IF        CusIdx = 10 AND DDCDBR <> *BLANKS                          CSF011
     C                   EVAL      W@BRC = DDCDBR                                             CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
      ** Format Full GL Account                                                               CSF011
      ** Format Partial Account                                                               CSF011
      ** Format Nostro Account                                                                CSF011
                                                                                              CSF011
     C                   SELECT                                                               CSF011
     C                   WHEN      %LEN(%TRIM(P@Str)) = 24                                    CSF011
     C                   EVAL      P@Str = %SUBST(P@Str:22:3)                                 CSF011
     C                             + %SUBST(P@Str:1:21)                                       CSF011
     C                   WHEN      %LEN(%TRIM(P@Str)) = 21                                    CSF011
     C                   EVAL      P@Str = %SUBST(P@Str:19:3) +                               CSF011
     C                             %SUBST(P@Str:1:6) + W@CCY +                                CSF011
     C                             %SUBST(P@Str:7:12)                                         CSF011
     C                   WHEN      %LEN(%TRIM(P@Str)) = 18                                    CSF011
     C                   EVAL      P@Str = W@BRC +                                            CSF011
     C                             %SUBST(P@Str:1:6) + W@CCY +                                CSF011
     C                             %SUBST(P@Str:7:12)                                         CSF011
     C                   WHEN      %LEN(%TRIM(P@Str)) = 2                                     CSF011
     C                   EVAL      P@Str = W@CCY + %SUBST(P@Str:1:2)                          CSF011
                                                                                              CSF011
     C                   ENDSL                                                                CSF011
                                                                                              CSF011
     C                   CALL      'AOACCTV1'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      *BLANKS       P@TYP                                        CSF011
     C                   PARM                    P@Str                                        CSF011
     C                   PARM                    DSSDY                                        CSF011
                                                                                              CSF011
      ** Retrieve Account Details, Customer Report Name,                                      CSF011
      ** and Town, Account Name and Swift ID                                                  CSF011
                                                                                              CSF011
     C                   SELECT                                                               CSF011
                                                                                              CSF011
     C                   WHEN      P@TYP = '*RETAIL' OR                                       CSF011
     C                             P@TYP = '*LEDGER'                                          CSF011
     C                   EVAL      ACCNT_AC = DSSDY                                           CSF011
     C                   EVAL      WCustomer = AC_CNUM                                        CSF011
                                                                                              CSF011
     C                   WHEN      P@TYP = '*NOSTRO'                                          CSF011
     C                   EVAL      SDNOST = DSSDY                                             CSF011
     C                   EVAL      WCustomer = A7CUST                                         CSF011
     C                   CALL      'AOACCTR0'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      '*KEY   '     @OPTN                                        CSF011
     C                   PARM      *BLANKS       P0RETL                                       CSF011
     C                   PARM                    A7CUST                                       CSF011
     C                   PARM                    A7CYCD                                       CSF011
     C                   PARM                    A7ACCD                                       CSF011
     C                   PARM                    A7ACSN                                       CSF011
     C                   PARM                    A7BRCD                                       CSF011
     C     ACCNT_AC      PARM                    DSSDY                                        CSF011
                                                                                              CSF011
     C                   WHEN      P@TYP = '*CUSTNO' OR                                       CSF011
     C                             P@TYP = '*SWIFT ' OR                                     MD044395
     C                             P@TYP = '*SHNAME'                                          CSF011
     C                   EVAL      SDCUST = DSSDY                                             CSF011
     C                   EVAL      WCustomer = *BLANKS                                        CSF011
     C                   EVAL      AC_ANAM  = *BLANKS                                       MD044395
                                                                                            MD044395
     C                   IF        P@TYP = '*SWIFT '                                        MD044395
     C                             AND BBCSSN = *BLANKS                                     MD044395
     C                   EVAL      BBCSID = *BLANKS                                         MD044395
     C                   ENDIF                                                              MD044395
                                                                                              CSF011
     C                   WHEN      P@TYP = '*NRF   '                                          CSF011
     C                   EVAL      WCustomer = *BLANKS                                        CSF011
                                                                                            MD030906
     C                   WHEN      P@TYP = '*CNST'                                          MD030906
                                                                                            MD030906
     C                   EVAL      SDCNST = DSSDY                                           MD030906
     C                   EVAL      WCustomer = *BLANKS                                      MD030906
                                                                                            MD030906
     C                   ENDSL                                                                CSF011
                                                                                              CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   IF         WCustomer <> *BLANKS                                      CSF011
     C                   CALL      'AOCUSTR0'                                                 CSF011
     C                   PARM      *BLANKS       @RTCD                                        CSF011
     C                   PARM      '*KEY'        @OPTN                                        CSF011
     C                   PARM                    WCustomer                                    CSF011
     C                   PARM      *BLANKS       C#KYST                                       CSF011
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSF011
                                                                                              CSF011
     C                   ENDIF                                                                CSF011
                                                                                             CSF011A
     C                   IF         @RTCD  = *BLANKS                                         CSF011A
     C                             OR P@TYP = '*CNST'                                       MD030906
     C                   SELECT                                                              CSF011A
                                                                                             CSF011A
      ** Destination                                                                         CSF011A
     C                   WHEN      CusIdx = 1                                                CSF011A
     C                   IF        P@TYP = '*CNST'                                          MD030906
     C                   EVAL      DDSNSN = AWCPNC                                          MD030906
     C                   EVAL      DDSNNM = AWCPNM                                          MD030906
     C                   EVAL      DDSNTN = AWCNTN                                          MD030906
     C                   EVAL      DDSNAN = *BLANKS                                         MD030906
     C                   EVAL      DDSNSW = AWSWID                                          MD030906
     C                   ELSE                                                               MD030906
     C                   EVAL      DDSNSN  = BBCSSN                                          CSF011A
     C                   EVAL      DDSNNM  = BBCRNM                                          CSF011A
     C                   EVAL      DDSNTN  = BBCRTN                                          CSF011A
     C                   EVAL      DDSNAN  = AC_ANAM                                         CSF011A
     C                   EVAL      DDSNSW  = BBCSID                                          CSF011A
     C                   ENDIF                                                              MD030906
                                                                                             CSF011A
      ** Receivers correspondent                                                             CSF011A
     C                   WHEN      CusIdx = 2                                                CSF011A
     C                   IF        P@TYP = '*CNST'                                          MD030906
     C                   EVAL      DDRCSN = AWCPNC                                          MD030906
     C                   EVAL      DDRCNM = AWCPNM                                          MD030906
     C                   EVAL      DDRCTN = AWCNTN                                          MD030906
     C                   EVAL      DDRCAN = *BLANKS                                         MD030906
     C                   EVAL      DDRCSW = AWSWID                                          MD030906
     C                   ELSE                                                               MD030906
     C                   EVAL      DDRCSN  = BBCSSN                                          CSF011A
     C                   EVAL      DDRCNM  = BBCRNM                                          CSF011A
     C                   EVAL      DDRCTN  = BBCRTN                                          CSF011A
     C                   EVAL      DDRCAN  = AC_ANAM                                         CSF011A
     C                   EVAL      DDRCSW  = BBCSID                                          CSF011A
     C                   ENDIF                                                              MD030906
                                                                                             CSF011A
      ** Beneficiary                                                                         CSF011A
     C                   WHEN      CusIdx = 3                                                CSF011A
     C                   IF        P@TYP = '*CNST'                                          MD030906
     C                   EVAL      DDBNSN = AWCPNC                                          MD030906
     C                   EVAL      DDBNNM = AWCPNM                                          MD030906
     C                   EVAL      DDBNTN = AWCNTN                                          MD030906
     C                   EVAL      DDBNAN = *BLANKS                                         MD030906
     C                   EVAL      DDBNSW = AWSWID                                          MD030906
     C                   ELSE                                                               MD030906
     C                   EVAL      DDBNSN  = BBCSSN                                          CSF011A
     C                   EVAL      DDBNNM  = BBCRNM                                          CSF011A
     C                   EVAL      DDBNTN  = BBCRTN                                          CSF011A
     C                   EVAL      DDBNAN  = AC_ANAM                                         CSF011A
     C                   EVAL      DDBNSW  = BBCSID                                          CSF011A
     C                   ENDIF                                                              MD030906
                                                                                             CSF011A
      ** Third Reimbursement Institution                                                     CSF011A
     C                   WHEN      CusIdx = 4                                                CSF011A
     C                   IF        P@TYP = '*CNST'                                          MD030906
     C                   EVAL      DDTRSN = AWCPNC                                          MD030906
     C                   EVAL      DDTRNM = AWCPNM                                          MD030906
     C                   EVAL      DDTRTN = AWCNTN                                          MD030906
     C                   EVAL      DDTRAN = *BLANKS                                         MD030906
     C                   EVAL      DDTRSW = AWSWID                                          MD030906
     C                   ELSE                                                               MD030906
     C                   EVAL      DDTRSN  = BBCSSN                                          CSF011A
     C                   EVAL      DDTRNM  = BBCRNM                                          CSF011A
     C                   EVAL      DDTRTN  = BBCRTN                                          CSF011A
     C                   EVAL      DDTRAN  = AC_ANAM                                         CSF011A
     C                   EVAL      DDTRSW  = BBCSID                                          CSF011A
     C                   ENDIF                                                              MD030906
                                                                                             CSF011A
      ** Account with Bank                                                                   CSF011A
     C                   WHEN      CusIdx = 5                                                CSF011A
     C                   IF        P@TYP = '*CNST'                                          MD030906
     C                   EVAL      DDABSN = AWCPNC                                          MD030906
     C                   EVAL      DDABNM = AWCPNM                                          MD030906
     C                   EVAL      DDABTN = AWCNTN                                          MD030906
     C                   EVAL      DDABAN = *BLANKS                                         MD030906
     C                   EVAL      DDABSW = AWSWID                                          MD030906
     C                   ELSE                                                               MD030906
     C                   EVAL      DDABSN  = BBCSSN                                          CSF011A
     C                   EVAL      DDABNM  = BBCRNM                                          CSF011A
     C                   EVAL      DDABTN  = BBCRTN                                          CSF011A
     C                   EVAL      DDABAN  = AC_ANAM                                         CSF011A
     C                   EVAL      DDABSW  = BBCSID                                          CSF011A
     C                   ENDIF                                                              MD030906
                                                                                             CSF011A
      ** Ordering Bank                                                                       CSF011A
     C                   WHEN      CusIdx = 6                                                CSF011A
     C                   IF        P@TYP = '*CNST'                                          MD030906
     C                   EVAL      DDOBSN = AWCPNC                                          MD030906
     C                   EVAL      DDOBNM = AWCPNM                                          MD030906
     C                   EVAL      DDOBTN = AWCNTN                                          MD030906
     C                   EVAL      DDOBSW = AWSWID                                          MD030906
     C                   ELSE                                                               MD030906
     C                   EVAL      DDOBSN  = BBCSSN                                          CSF011A
     C                   EVAL      DDOBNM  = BBCRNM                                          CSF011A
     C                   EVAL      DDOBTN  = BBCRTN                                          CSF011A
     C                   EVAL      DDOBSW  = BBCSID                                          CSF011A
     C                   ENDIF                                                              MD030906
                                                                                             CSF011A
      ** Ordering Customer                                                                   CSF011A
     C                   WHEN      CusIdx = 7                                                CSF011A
     C                   IF        P@TYP = '*CNST'                                          MD030906
     C                   EVAL      DDOCSN = AWCPNC                                          MD030906
     C                   EVAL      DDOCNM = AWCPNM                                          MD030906
     C                   EVAL      DDOCTN = AWCNTN                                          MD030906
     C                   EVAL      DDOCAN = *BLANKS                                         MD030906
     C                   EVAL      DDOCSW = AWSWID                                          MD030906
     C                   ELSE                                                               MD030906
     C                   EVAL      DDOCSN  = BBCSSN                                          CSF011A
     C                   EVAL      DDOCNM  = BBCRNM                                          CSF011A
     C                   EVAL      DDOCTN  = BBCRTN                                          CSF011A
     C                   EVAL      DDOCAN  = AC_ANAM                                         CSF011A
     C                   EVAL      DDOCSW  = BBCSID                                          CSF011A
     C                   ENDIF                                                              MD030906
                                                                                             CSF011A
      ** Ordering Bank                                                                       CSF011A
     C                   WHEN      CusIdx = 8                                                CSF011A
     C                   IF        P@TYP = '*CNST'                                          MD030906
     C                   EVAL      DDSCSN = AWCPNC                                          MD030906
     C                   EVAL      DDSCNM = AWCPNM                                          MD030906
     C                   EVAL      DDSCTN = AWCNTN                                          MD030906
     C                   EVAL      DDSCSW = AWSWID                                          MD030906
     C                   ELSE                                                               MD030906
     C                   EVAL      DDSCSN  = BBCSSN                                          CSF011A
     C                   EVAL      DDSCNM  = BBCRNM                                          CSF011A
     C                   EVAL      DDSCTN  = BBCRTN                                          CSF011A
     C                   EVAL      DDSCSW  = BBCSID                                          CSF011A
     C                   ENDIF                                                              MD030906
                                                                                             CSF011A
      ** Intermediary Bank                                                                   CSF011A
     C                   WHEN      CusIdx = 9                                                CSF011A
     C                   IF        P@TYP = '*CNST'                                          MD030906
     C                   EVAL      DDIBSN = AWCPNC                                          MD030906
     C                   EVAL      DDIBNM = AWCPNM                                          MD030906
     C                   EVAL      DDIBTN = AWCNTN                                          MD030906
     C                   EVAL      DDIBSW = AWSWID                                          MD030906
     C                   ELSE                                                               MD030906
     C                   EVAL      DDIBSN  = BBCSSN                                          CSF011A
     C                   EVAL      DDIBNM  = BBCRNM                                          CSF011A
     C                   EVAL      DDIBTN  = BBCRTN                                          CSF011A
     C                   EVAL      DDIBSW  = BBCSID                                          CSF011A
     C                   ENDIF                                                              MD030906
                                                                                             CSF011A
      ** Charges to the Debit of Account                                                     CSF011A
     C                   WHEN      CusIdx = 10                                               CSF011A
     C                   IF        P@TYP = '*CNST'                                          MD030906
     C                   EVAL      DDCDSN = AWCPNC                                          MD030906
     C                   EVAL      DDCDNM = AWCPNM                                          MD030906
     C                   EVAL      DDCDTN = AWCNTN                                          MD030906
     C                   EVAL      DDCDAN = *BLANKS                                         MD030906
     C                   EVAL      DDCDSW = AWSWID                                          MD030906
     C                   ELSE                                                               MD030906
     C                   EVAL      DDCDSN  = BBCSSN                                          CSF011A
     C                   EVAL      DDCDNM  = BBCRNM                                          CSF011A
     C                   EVAL      DDCDTN  = BBCRTN                                          CSF011A
     C                   EVAL      DDCDAN  = AC_ANAM                                         CSF011A
     C                   EVAL      DDCDSW  = BBCSID                                          CSF011A
     C                   ENDIF                                                              MD030906
     C                   ENDSL                                                               CSF011A
     C                   ENDIF                                                               CSF011A
                                                                                             CSF011A
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
      ** Increment counter fields                                                             CSF011
                                                                                              CSF011
     C                   IF        W@Abc = 'A'                                                CSF011
     C                   Z-ADD     AccLength     W@Len                                        CSF011
     C                   ELSE                                                                 CSF011
     C                   Z-ADD     ACusLngth     W@Len                                        CSF011
     C                   ENDIF                                                                CSF011
                                                                                              CSF011
     C                   EVAL      CusIdx = Cusidx + 1                                        CSF011
     C                   EVAL      CusIdx2 = Cusidx2 + 35                                     CSF011
                                                                                              CSF011
     C                   ENDDO                                                                CSF011
                                                                                              CSF011
     C                   ENDSR                                                                CSF011
      *****************************************************************                       CSF011
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateAmd - Routine to check whether the fields are        *
      *                amendable                                      *
      *                                                               *
      *****************************************************************
      *
     C     ValidateAmd   BEGSR
      *
     C                   CALLB     'FTIPAYAMD'
      *                             =========
      ** INPUT
      ** =====

      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut

      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    TranInIPY1

      ** Incoming Payments Lvl 1 Scrn details retrieved from file
      ** - screen format
     C                   PARM                    CurTrIPY1

      ** Reset of Fields in Error Required (Y/N)
     C                   PARM      'N'           PResetFld

      ** STANDING DATA
      ** =============

      ** SDMMOD - Multibranch Indicator
     C                   PARM                    BGMBIN

      ** SDGELR - Profit Centre Used
     C                   PARM                    BKPRCU

      ** SDGELR - Profit Centre Amendable
     C                   PARM                    BKPRCA

      ** OUTPUT
      ** ======

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    AMFldNamAr
     C                   PARM                    AMMsgIdArr
     C                   PARM                    AMMsgDtaAr

      ** Array index (3P0) from/to caller
     C                   PARM                    AmIdx

      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    OKTrIPY1

      ** OK Amendments field
     C                   PARM                    PAmendOK

      ** If errors occurred, overwrite previous error information.

     C                   IF        AmIdx <> 0
     C                   MOVEA     AMFldNamAr    FldNameArr
     C                   MOVEA     AMMsgIdArr    MsgIdArr
     C                   MOVEA     AMMsgDtaAr    MsgDtaArr
     C                   Z-ADD     AmIdx         Idx
     C                   ENDIF

     C                   ENDSR
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      *  SrEISwift - Routine to set up swift fields based on swift     *
      *              reference/sequence                                *
      *                                                                *
      ******************************************************************

     C     SrEISwft      BEGSR

      ** Initialise screen formats.

     C                   EXSR      SRInScn

      ** Get swift message reference details

     C                   EXSR      SRMKey

     C                   IF        WErr <> *BLANK
     C                   GOTO      EEISwft
     C                   ENDIF

      ** Reserve message

     C                   EXSR      SRMsgRsv

      ** If the SWIFT Reference is already allocated to another job,
      ** then display error messages.

     C                   IF        WErr <> *BLANK
     C                   GOTO      EEISwft
     C                   ENDIF

      ** Call ME1100 to translate the data of the messages for FT
      ** fields.

     C                   CALL      'ME1100'                             0101
     C                   PARM      '*TRANS  '    PACTD
     C                   PARM                    PHEAD
     C                   PARM      *BLANKS       PDATA
     C                   PARM      *BLANKS       PDAT2                                        CSW209
     C                   PARM      *BLANKS       PRTN

      ** If call to program resulted in an error, then end program.

     C                   IF        PRTN = '*ERROR*' AND
     C                             *IN01
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'ME1100'      DBFILE
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Set up the Detail screen fields from the message.

      ** Sender.

     C                   MOVEL     PSNDR         ODDSND1

     C                   IF        PSN <> *BLANKS
     C                   MOVEL     PSN           DSTRAN
     C                   IF        PSNDR = 'CASHIER'
     C                   MOVEL     PSNAR(1)      TMLIN2
     C                   ENDIF
     C                   MOVEL     TMLIN1        ODDSND1
     C                   MOVEL     TMLIN2        ODDSND2
     C                   MOVEL     TMLIN3        ODDSND3
     C                   MOVEL     TMLIN4        ODDSND4
     C                   ENDIF

      ** Message Type.

     C                   MOVE      PMTPY         IPINMTPY

      ** Msg Unique Reference.

     C                   Z-ADD     PHMSGR        IPINMSGR

      ** SWIFT Reference.

     C                   MOVEL     PHMIR         DDSWTN
     C                   MOVEL     PHMIR         ODDSWTN

      ** Part Number.

     C                   MOVE      PHPART        DDSEQNO
     C                   MOVE      PHPART        ODDSEQNO
     C                   Z-ADD     PHPART        IPINKPRT

      ** SWIFT Priority Code.

     C                   MOVE      PMPRY         ODDSWPC

      ** Branch Code.

     C                   IF        PBRCA <> *BLANKS
     C                   MOVEL     PBRCA         ODDBRCA
     C                   ENDIF

      ** Transaction Reference No.

     C                   IF        P20 <> *BLANKS
     C                   MOVEL     P20           DSTRAN
     C                   MOVEL     TTREF         IPINTRNO
     C                   ELSE
     C                   MOVEL     *BLANKS       IPINTRNO
     C                   ENDIF

      ** Related Reference.

     C                   IF        P21 <> *BLANKS
     C                   MOVEL     P21           DSTRAN
     C                   MOVEL     TTREF         IPRLPR
     C                   MOVEL     TTREF         ODDRLPR
     C                   ELSE
     C                   MOVEL     *BLANKS       IPRLPR
     C                   ENDIF

     C                   IF        CFT014 = 'Y'

      ** Sender's Charge fields

     C                   IF        P71FX <> *BLANKS

     C                   MOVEL     *BLANK        DSTRAN
     C                   MOVEL     P71FX         DSTRAN
     C                   Z-ADD     1             L
     C                   MOVEL     TMLIN1        TV1
     C                   MOVEL     TMLIN2        TV2
     C                   MOVEL     TMLIN3        TV3
     C                   MOVEL     TMLIN4        TV4
     C                   MOVEL     TMLIN5        TV5

     C                   DOW       L <= 5  AND
     C                             LFLT(L) <> *BLANK

     C                   MOVEL     *BLANK        DSTRAN
     C                   MOVEL     LFLT(L)       DSTRAN
     C                   EXSR      SrCcyA33B

     C                   SELECT
     C                   WHEN      L = 1
     C                   MOVEL     WCAAM         ODDSCH1
     C                   MOVEL     WCACY         ODDSCC1
     C                   WHEN      L = 2
     C                   MOVEL     WCAAM         ODDSCH2
     C                   MOVEL     WCACY         ODDSCC2
     C                   WHEN      L = 3
     C                   MOVEL     WCAAM         ODDSCH3
     C                   MOVEL     WCACY         ODDSCC3
     C                   WHEN      L = 4
     C                   MOVEL     WCAAM         ODDSCH4
     C                   MOVEL     WCACY         ODDSCC4
     C                   WHEN      L = 5
     C                   MOVEL     WCAAM         ODDSCH5
     C                   MOVEL     WCACY         ODDSCC5
     C                   ENDSL

     C                   ADD       1             L

     C                   ENDDO

     C                   ENDIF

      ** Receiver's Charge field

     C                   IF        P71G <> *BLANKS

     C                   MOVEL     *BLANK        DSTRAN
     C                   MOVEL     'N'           I2INRCUS
     C                   MOVEL     P71G          DSTRAN
     C                   EXSR      SrCcyA33B

      ** Save receiver's charges info for input to SR/SROV32AM

     C                   MOVEL     WCACY         WRCHCY
     C                   MOVEL     WCAAM         WRCHAM

     C                   CALL      'AOCURRR0'                           8080
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WCACY         PCHR03
     C     SDCURR        PARM      *BLANKS       DSSDY

     C                   IF        PRTCD = *BLANKS  AND
     C                             NOT(*IN80)
     C                   MOVE      *BLANK        ZFIELD
     C                   MOVE      WCAAM         ZFIELD
     C     13            SUB       A6NBDP        ZADIG
     C                   Z-ADD     A6NBDP        ZADEC
     C                   Z-ADD     A6NBDP        WRCRMNDP

     C                   CALLB     'ZALIGN'
     C                   PARM                    ZalignOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG

     C                   IF        ZAlignOK = 'Y'
     C                   MOVE      ZFIELD        I2INRCNW
     C                   MOVEL     WCACY         I2INRCCN
     C                   ENDIF

      ** Default receiver's charges screen field
     C                   MOVEL     WCAAM         ODDRCRM

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      ** Settlement Value Date/Currency/Amount.

     C                   IF        PDCA <> *BLANKS

     C                   MOVEL     PDCA          DSTRAN

      ** Settlement Value Date.

     C                   MOVEL     TVVDAT        WWDT

      ** MMDDYY format display.

     C                   IF        BJDFIN = 'M'

     C                   EVAL      ODDSLDT = WD2 + WD3 + WD1

     C                   ELSE

      ** DDMMYY format display.

     C                   EVAL      ODDSLDT = WD3 + WD2 + WD1

     C                   ENDIF

      ** Settlement Currency.

     C                   MOVEL     TVCCY         ODDSMCY

      ** Settlement Amount.

     C                   IF        PNWRK <> 'FONTIS'

      ** Format amount field (change ',' decimal point to '.').

     C                   MOVEA     *BLANKS       WYA1
     C                   MOVEA     TVAMT         WYA1
     C                   Z-ADD     1             Cx

     C                   DOU       Cx > 15
     C                   IF        WYA1(Cx) =  ','
     C                   MOVE      '.'           WYA1(Cx)
     C                   Z-ADD     16            Cx
     C                   ELSE
     C                   ADD       1             Cx
     C                   ENDIF
     C                   ENDDO

     C                   MOVEA     WYA1          WAMT

     C                   IF        CFT014 = 'Y' AND
     C                             P71G <> *BLANKS

     C                   MOVEL     ODDSLDT       ZDateIn
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDateIn
     C                   PARM      0             ZDateOut
     C                   PARM      BJDFIN        ZDateFmt
     C                   PARM      *BLANK        ZDate1OK
     C                   Z-ADD     ZDateOut      WOVVLD
     C                   Z-ADD     ZDateOut      WSLDT
     C                   MOVE      ODDSMCY       WOVICY
     C                   MOVEL     WAMT          WOVIAM
     C                   MOVEL     WRCHCY        WOVRCY
     C                   MOVEL     WRCHAM        WOVRAM
     C                   MOVEL     '*SUB'        WOVOPR
     C                   EXSR      SROV32AM
     C                   MOVEL     WOVAMT        ODDSMAM
     C                   ELSE
     C                   MOVEL     WAMT          ODDSMAM
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      ** Ordering Customer.

     C                   IF        P50 <> *BLANKS
     C                   MOVEL     P50           DSTRAN
     C                   MOVEL     TMLIN1        ODDORC1
     C                   MOVEL     TMLIN2        ODDORC2
     C                   MOVEL     TMLIN3        ODDORC3
     C                   MOVEL     TMLIN4        ODDORC4
     C                   MOVEL     TMLIN5        ODDORC5                                      CFT032
     C                   ENDIF

      ** Ordering Institution.

     C                   IF        P52 <> *BLANKS
     C                   MOVEL     P52           DSTRAN
     C                   MOVEL     TMLIN1        ODDOBK1
     C                   MOVEL     TMLIN2        ODDOBK2
     C                   MOVEL     TMLIN3        ODDOBK3
     C                   MOVEL     TMLIN4        ODDOBK4
     C                   MOVEL     TMLIN5        ODDOBK5
     C                   ENDIF

      ** Sender's Correspondent.

     C                   IF        P53 <> *BLANKS
     C                   MOVEL     P53           DSTRAN
     C                   MOVEL     TMLIN1        ODDSNC1
     C                   MOVEL     TMLIN2        ODDSNC2
     C                   MOVEL     TMLIN3        ODDSNC3
     C                   MOVEL     TMLIN4        ODDSNC4
     C                   MOVEL     TMLIN5        ODDSNC5
     C                   ENDIF

      ** Receiver's Correspondent.

     C                   IF        P54 <> *BLANKS

     C                   MOVEL     P54           DSTRAN
     C                   MOVEL     TMLIN1        ODDRCO1
     C                   MOVEL     TMLIN2        ODDRCO2
     C                   MOVEL     TMLIN3        ODDRCO3
     C                   MOVEL     TMLIN4        ODDRCO4
     C                   MOVEL     TMLIN5        ODDRCO5
     C                   MOVEL     TMLIN1        IPINRCO1
     C                   MOVEL     TMLIN2        IPINRCO2
     C                   MOVEL     TMLIN3        IPINRCO3
     C                   MOVEL     TMLIN4        IPINRCO4
     C                   MOVEL     TMLIN5        IPINRCO5

      ** If Network is SWIFT, find field type.
      ** Otherwise, default it to 'U'.

     C                   IF        PNWRK = 'SWIFT '

      ** Set up field type, if A->S, B->T, D->U.

     C     1             SUBST     TRTAG:4       WWK1

     C                   SELECT
     C                   WHEN      WWK1 = 'A'
     C                   MOVEL     'S'           IPINRCRT
     C                   WHEN      WWK1 = 'B'
     C                   MOVEL     'T'           IPINRCRT
     C                   OTHER
     C                   MOVEL     'U'           IPINRCRT
     C                   ENDSL

     C                   ELSE

      ** Network is not SWIFT.

     C                   MOVEL     'U'           IPINRCRT

     C                   ENDIF

     C                   ELSE

     C                   MOVEL     *BLANKS       IPINRCRT
     C                   MOVEL     *BLANKS       IPINRCO1
     C                   MOVEL     *BLANKS       IPINRCO2
     C                   MOVEL     *BLANKS       IPINRCO3
     C                   MOVEL     *BLANKS       IPINRCO4
     C                   MOVEL     *BLANKS       IPINRCO5

     C                   ENDIF

      ** Intermediary.

     C                   IF        P56 <> *BLANKS
     C                   MOVEL     P56           DSTRAN
     C                   MOVEL     TMLIN1        ODDINB1
     C                   MOVEL     TMLIN2        ODDINB2
     C                   MOVEL     TMLIN3        ODDINB3
     C                   MOVEL     TMLIN4        ODDINB4
     C                   MOVEL     TMLIN5        ODDINB5
     C                   ENDIF

      ** Account with Institution.

     C                   IF        P57 <> *BLANKS
     C                   MOVEL     P57           DSTRAN
     C                   MOVEL     TMLIN1        ODDACBK
     C                   MOVEL     TMLIN1        IPINACB1
     C                   MOVEL     TMLIN2        IPINACB2
     C                   MOVEL     TMLIN3        IPINACB3
     C                   MOVEL     TMLIN4        IPINACB4
     C                   MOVEL     TMLIN5        IPINACB5

      ** If Network is SWIFT, find field type.
      ** Otherwise, default it to 'U'.

     C                   IF        PNWRK = 'SWIFT '

      ** Set up field type, if A->S, B->T, D->U.

     C     1             SUBST     TRTAG:4       WWK1

     C                   SELECT
     C                   WHEN      WWK1 = 'A'
     C                   MOVEL     'S'           IPINACBT
     C                   WHEN      WWK1 = 'B'
     C                   MOVEL     'T'           IPINACBT
     C                   OTHER
     C                   MOVEL     'U'           IPINACBT
     C                   ENDSL

     C                   ELSE

      ** Network is not SWIFT.

     C                   MOVEL     'U'           IPINACBT

     C                   ENDIF

      ** P57 equals blanks.

     C                   ELSE

     C                   MOVEL     *BLANKS       IPINACBT
     C                   MOVEL     *BLANKS       IPINACB1
     C                   MOVEL     *BLANKS       IPINACB2
     C                   MOVEL     *BLANKS       IPINACB3
     C                   MOVEL     *BLANKS       IPINACB4
     C                   MOVEL     *BLANKS       IPINACB5

     C                   ENDIF

      ** Beneficiary Institution/ Beneficiary Customer.

     C                   IF        P58 <> *BLANKS
     C                   MOVEL     P58           DSTRAN
     C                   MOVEL     TMLIN1        ODDBNC1
     C                   MOVEL     TMLIN2        ODDBNC2
     C                   MOVEL     TMLIN3        ODDBNC3
     C                   MOVEL     TMLIN4        ODDBNC4
     C                   MOVEL     TMLIN5        ODDBNC5
     C                   ENDIF

     C                   IF        P59 <> *BLANKS
     C                   MOVEL     P59           DSTRAN
     C                   MOVEL     TMLIN1        ODDBNC1
     C                   MOVEL     TMLIN2        ODDBNC2
     C                   MOVEL     TMLIN3        ODDBNC3
     C                   MOVEL     TMLIN4        ODDBNC4
     C                   MOVEL     TMLIN5        ODDBNC5
     C                   ENDIF

      ** Details of Payment.

     C                   IF        P70 <> *BLANKS
     C                   MOVEL     P70           DSTRAN
     C                   MOVEL     TMLIN1        ODDDTP1
     C                   MOVEL     TMLIN2        ODDDTP2
     C                   MOVEL     TMLIN3        ODDDTP3
     C                   MOVEL     TMLIN4        ODDDTP4
     C                   ENDIF

      *                                                                                       CER030
      ** Move Extended Narratives to screen fields                                            CER030
      *                                                                                       CER030
     C                   IF        PEXN <> *BLANKS                                            CER030
     C                   MOVEL     PEXN          DSTRAN                                       CER030
     C                   MOVEL     TMLIN1        ODDEXT1                                      CER030
     C                   MOVEL     TMLIN2        ODDEXT2                                      CER030
     C                   MOVEL     TMLIN3        ODDEXT3                                      CER030
     C                   MOVEL     TMLIN4        ODDEXT4                                      CER030
     C                   MOVEL     TMLIN5        ODDEXT5                                      CER030
     C                   MOVEL     TMLIN6        ODDEXT6                                      CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** Details of Charges.

     C                   IF        P71 <> *BLANKS
     C                   MOVEL     P71           DSTRAN
     C                   MOVEL     TTREF         ODDDTCH
     C                   IF        CFT014 = 'Y'

     C                   IF        TTREF = 'OUR'
     C                   MOVE      'A'           ODDADDC
     C                   ELSE
     C                   MOVE      'D'           ODDADDC
     C                   ENDIF

      ** Check if receiver's charges screen field needs to be changed

     C                   IF        ODDADDC = 'A' AND
     C                             ODDSMCY <> I2INRCCN  AND
     C                             I2INRCNW <>  0

      ** Calculate receiver's charges network in settlement currency

     C                   CLEAR                   P#0010
     C                   Z-ADD     WSLDT         P#FRDT
     C                   Z-ADD     WSLDT         P#TODT
     C                   MOVEL     I2INRCCN      P#FRCY
     C                   Z-ADD     I2INRCNW      P#FRAM
     C                   MOVEL     ODDSMCY       P#TOCY
     C                   Z-ADD     0             P#TOAM
     C                   Z-ADD     0             P#RATE
     C                   CALL      'FT0010'
     C                   PARM                    P#0010

     C                   IF        P#RTCD <> *BLANKS
     C                   Z-ADD     2             DBASE
     C                   MOVEL     'FT0010'      DBFILE
     C                   MOVEL     '*CALL '      DBKEY
     C                   EXSR      *PSSR
     C                   ELSE

     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      P#TOAM        ZFIELD
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM      WRCRMNDP      ZADEC
     C                   MOVE      ZFIELD        ODDRCRM

      ** Left-justify the amount

     C                   Z-ADD     1             CX
     C                   MOVE      *BLANKS       WYA1
     C                   MOVEA     ODDRCRM       WYA1(1)
     C                   DOW       WYA1(CX) = *BLANK AND
     C                             CX < 12
     C                   ADD       1             CX
     C                   ENDDO
     C                   MOVE      *BLANKS       ODDRCRM
     C                   IF        CX <= 12
     C                   MOVEA     WYA1(CX)      ODDRCRM
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF

     C                   ENDIF
     C                   ENDIF

      ** Bank to Bank Information.

      ** Access Settlement Currency details.

     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      ODDSMCY       PCCY
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        P72 <> *BLANKS

     C                   MOVEL     P72           DSTRAN
     C                   MOVEL     TMLIN1        ODDBBI1
     C                   MOVEL     TMLIN2        ODDBBI2
     C                   MOVEL     TMLIN3        ODDBBI3
     C                   MOVEL     TMLIN4        ODDBBI4
     C                   MOVEL     TMLIN5        ODDBBI5
     C                   MOVEL     TMLIN6        ODDBBI6

     C                   IF        P33B = *BLANKS

     C     '/OCMT/'      SCAN      P72           WOCMT

     C                   IF        WOCMT <> 0
     C                   MOVEL     '/OCMT'       WCW
     C                   MOVEL     P72           WCWLIN
     C                   EXSR      SRFOCmt2
     C                   MOVEL     WCWCY         ODDNDCY
     C                   MOVEL     WCWAM         ODDNDAM
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      ** Additional Mapping for CASHIER.

      ** Pay Value Date/Currency/Amount.

     C                   IF        SDCA <> *BLANKS

     C                   Z-ADD     0             TVVDAT
     C                   MOVEL     SDCA          DSTRAN

      ** Pay Value Date.

     C                   IF        TVVDAT <> 0

     C                   MOVEL     TVVDAT        WWDT

      ** MMDDYY format display.

     C                   IF        BJDFIN = 'M'

     C                   EVAL      ODDPYDT = WD2 + WD3 + WD1

     C                   ELSE

      ** DDMMYY format display.

     C                   EVAL      ODDPYDT = WD3 + WD2 + WD1

     C                   ENDIF

     C                   ENDIF

      ** Pay Currency.

     C                   MOVEL     TVCCY         ODDPCCY

      ** Pay Amount.

      ** Format amount field (change ',' decimal point to '.').

     C                   MOVEA     *BLANKS       WYA1
     C                   MOVEA     TVAMT         WYA1
     C                   Z-ADD     1             Cx

     C                   DOU       Cx > 15
     C                   IF        WYA1(Cx) = ','
     C                   MOVE      '.'           WYA1(Cx)
     C                   Z-ADD     16            Cx
     C                   ELSE
     C                   ADD       1             Cx
     C                   ENDIF
     C                   ENDDO

     C                   MOVEA     WYA1          WAMT
     C                   MOVEL     WAMT          ODDPYAM

     C                   ENDIF

      ** Funding Currency/Funding Amount.

     C                   IF        PDC2 <> *BLANKS

     C                   Z-ADD     0             TVVDAT
     C                   MOVEL     PDC2          DSTRAN

      ** Settlement Value Date.

     C                   IF        TVVDAT <> 0

     C                   MOVEL     TVVDAT        WWDT

      ** MMDDYY format display.

     C                   IF        BJDFIN = 'M'

     C                   EVAL      ODDSLDT = WD2 + WD3 + WD1

     C                   ELSE

      ** DDMMYY format display.

     C                   EVAL      ODDSLDT = WD3 + WD2 + WD1

     C                   ENDIF

     C                   ENDIF

      ** Settlement Currency.

     C                   MOVEL     TVCCY         ODDSMCY

      ** Settlement AMount.

      ** Format amount field (change ',' decimal point to '.').

     C                   MOVEA     *BLANKS       WYA1
     C                   MOVEA     TVAMT         WYA1
     C                   Z-ADD     1             Cx

     C                   DOU       Cx > 15
     C                   IF        WYA1(CX) = ','
     C                   MOVE      '.'           WYA1(Cx)
     C                   Z-ADD     16            Cx
     C                   ELSE
     C                   ADD       1             Cx
     C                   ENDIF
     C                   ENDDO

     C                   MOVEA     WYA1          WAMT
     C                   MOVEL     WAMT          ODDSMAM

     C                   ENDIF

      ** Rate.

     C                   IF        ODDPYAM <> *BLANKS AND
     C                             ODDSMAM <> *BLANKS

      ** Get the numeric value of DDPYAM.

     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      ODDPCCY       PCCY
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        PRTCD <> *BLANKS
     C                   MOVEL     ODDPCCY       DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     3             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   Z-ADD     A6NBDP        WPCYD

      ** Align amount.

     C                   Z-ADD     WPCYD         ZADEC
     C     11            SUB       WPCYD         ZADIG
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      ODDPYAM       ZFIELD

     C                   CALLB     'ZALIGN'
     C                   PARM                    ZalignOk
     C                   PARM                    ZField
     C                   PARM                    ZADec
     C                   PARM                    ZADig

     C                   IF        ZalignOK = 'Y'
     C                   MOVE      ZFIELD        W1PYA
     C                   ENDIF

      ** Get the numeric value of ODDSMAM.

     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      ODDSMCY       PCCY
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   IF        PRTCD <> *BLANKS
     C                   MOVEL     ODDSMCY       DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     4             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   Z-ADD     A6NBDP        WSMCY

      ** Align amount.

     C                   Z-ADD     WSMCY         ZADEC
     C     11            SUB       WSMCY         ZADIG
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      ODDSMAM       ZFIELD

     C                   CALLB     'ZALIGN'
     C                   PARM                    ZalignOk
     C                   PARM                    ZField
     C                   PARM                    ZADec
     C                   PARM                    ZADig

     C                   IF        ZalignOk = 'Y'
     C                   MOVE      ZFIELD        W1SMA
     C                   ENDIF

     C                   IF        W1PYA <> 0 AND
     C                             W1SMA <> 0

      ** Calculate the Rate by dividing the larger amount
      ** by the smaller amount.

     C                   IF        W1PYA >= W1SMA
     C     W1PYA         DIV       W1SMA         W1RTE
     C                   MOVE      *BLANKS       ODDSMAM
     C                   ENDIF

     C                   IF        W1SMA > W1PYA
     C     W1PYA         DIV       W1SMA         W1RTE
     C                   MOVE      *BLANKS       ODDPYAM
     C                   ENDIF

      ** Format Rate field.

     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      W1RTE         ZFIELD
     C                   Z-ADD     7             ZADEC2

     C                   CALLB     'ZAEDITM'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC2

     C                   MOVE      ZFIELD        ODDRATE

     C                   ENDIF

     C                   ENDIF

     C                   IF        PNWRK = 'CASHV8'

      ** Receiver's Correspondent and Ordering Bank.

     C                   IF        P54 <> *BLANKS

     C                   MOVEL     P54           DSTRAN
     C                   MOVEL     *BLANKS       ODDRCO1
     C                   MOVEL     TMLIN         ODDRCO1
     C                   MOVEL     *BLANKS       ODDOBK1
     C                   MOVEL     TMLIN         ODDOBK1

     C                   ELSE

      ** Use the default account code from CASH dataarea and
      ** build the account number.

      ** Get Branch internal customer.

     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      ODDBRCA       PBRCH
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029

     C                   IF        PRTCD <> *BLANKS
     C                   MOVEL     ODDBRCA       DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   Z-ADD     5             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Retrieve Retail account number.

     C                   MOVE      A8BICN        KACNUM
     C                   MOVEL     ODDSMCY       KACCCY
     C                   MOVE      WDACACD       KACCD
     C                   Z-ADD     1             KACSQ
     C                   MOVEL     ODDBRCA       KBRCA

     C     KAccnt        CHAIN     ACCNT                              01

     C                   IF        *IN01
     C                   MOVEL     WACKYDS       DBKEY
     C                   MOVEL     'ACCNT'       DBFILE
     C                   Z-ADD     6             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Move Retail account number to Receiver's Correspondent.

     C                   MOVEL     *BLANKS       ODDRCO1
     C                   MOVE      ACNO          ODDRCO1

     C                   ENDIF

      ** Account with Institution.

     C                   IF        P57 <> *BLANKS
     C                   MOVEL     P57           DSTRAN
     C                   MOVEL     *BLANKS       WREAC
     C                   MOVEL     TMLIN         WREAC
     C                   MOVEL     *BLANKS       ODDACBK
     C                   MOVEL     WREAC         ODDACBK
     C                   ENDIF

     C                   MOVEL     'N'           ODDOPIN

     C                   ENDIF

     C                   IF        CFT014 = 'Y'

      ** Third Reimbursment Institution

     C                   IF        P55 <> *BLANKS

     C                   MOVEL     *BLANK        DSTRAN
     C                   MOVEL     P55           DSTRAN

      ** Map 1st line of SWIFT values into screen fields
     C                   MOVEL     TMLIN1        ODDTRIB

     C                   IF        CFT004 = 'Y'

      ** Check whether the field carries an IBAN
      ** If it is the case, move the IBAN into the 'screen' field
      ** which will be validated afterwards

     C                   MOVEL     ODDTRIB       P@IBAN

      ** Check that it is a valid IBAN
     C                   CALL      'AOIBANR2'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM                    P@IBAN
     C                   PARM      *BLANKS       DSSDY

      ** Network information is mapped onto the 'screen' field

     C                   IF        PRTCD = *BLANKS
     C                   MOVEL     *BLANK        ODDTRIB

      ** '/' has been removed
     C                   MOVEL     P@IBAN        ODDTRIB
     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      ** Bank Operation Code

     C                   IF        P23B <> *BLANKS
     C                   MOVEL     *BLANK        DSTRAN
     C                   MOVEL     P23B          DSTRAN
     C                   MOVEL     TTREF         ODDBOCD
     C                   ENDIF

      ** Instruction Code

     C                   IF        P23E <> *BLANKS
     C                   MOVEL     *BLANK        DSTRAN
     C                   MOVEL     P23E          DSTRAN
     C                   MOVEL     TMLIN1        ODDICD1
     C                   MOVEL     TMLIN2        ODDICD2
     C                   MOVEL     TMLIN3        ODDICD3
     C                   MOVEL     TMLIN4        ODDICD4
     C                   MOVEL     TMLIN5        ODDICD5
     C                   ENDIF

      ** Transaction Code

     C                   IF        P26T <> *BLANKS
     C                   MOVEL     *BLANK        DSTRAN
     C                   MOVEL     P26T          DSTRAN
     C                   MOVEL     TTREF         ODDTTCD
     C                   ENDIF

      ** Instructed Currency/Amount

     C                   IF        P33B <> *BLANKS
     C                   MOVEL     *BLANK        DSTRAN
     C                   MOVEL     P33B          DSTRAN
     C                   EXSR      SrCcyA33B
     C                   MOVEL     WCACY         ODDNDCY
     C                   MOVEL     WCAAM         ODDNDAM
     C                   ENDIF

      ** Original Rate Currency/Amount

     C                   IF        P36 <> *BLANKS
     C                   MOVEL     *BLANK        DSTRAN
     C                   MOVEL     P36           DSTRAN
     C                   EXSR      SRRATE36
     C                   MOVEL     W36RT         ODDOEXR
     C                   ENDIF

      ** Regulatory Reporting

     C                   IF        P77B <> *BLANKS
     C                   MOVEL     *BLANK        DSTRAN
     C                   MOVEL     P77B          DSTRAN
     C                   MOVEL     TMLIN1        ODDRRP1
     C                   MOVEL     TMLIN2        ODDRRP2
     C                   MOVEL     TMLIN3        ODDRRP3
     C                   ENDIF

     C                   ENDIF

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
     C                   EXSR      SrCcyA33B                                                  CSW209
     C                   EVAL      ODDCICY = WCACY                                            CSW209
     C                   EVAL      ODDCIAM = WCAAM                                            CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   ENDIF                                                                CSW209
      ** Default in Pay Currency.

     C                   MOVE      ODDSMCY       ODDPCCY

      ** Set up fields for Incoming FONTIS Messages.

     C                   IF        PNWRK = 'FONTIS'
     C                   EXSR      SRFont
     C                   ENDIF

      ** Decode data if feature installed.

     C                   IF        CFT002 = 'Y'

      ** Call ME1580 to translate the data of the messages for
      ** FT fields.

     C                   CALL      'ME1580'                             0101
     C                   PARM      '*TRANS  '    PACTD
     C                   PARM                    PHEAD
     C                   PARM                    PDATA
     C                   PARM                    PDAT2                                        CSW209
     C                   PARM      *BLANKS       PRTN

      ** If call to program resulted in an error, then end program.

     C                   IF        PRTN = '*ERROR*' OR
     C                             *IN01
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'ME1580'      DBFILE
     C                   Z-ADD     7             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

      ** If clearing, then copy.  Otherwise, map.

     C                   EXSR      SRIMsg

     C                   ENDIF

      ** Initialise screen fields with details of the electronic
      ** message.

     C                   MOVEL     CurTrIPY1     TranInIPY1
     C                   MOVEL     CurTrIP1A     TranInIP1A
     C                   MOVEL     CurTrIPY2     TranInIPY2
     C                   MOVEL     CurTrIPY3     TranInIPY3
     C                   MOVEL     CurTrIPY4     TranInIPY4
     C                   MOVEL     CurTrIP4A     TranInIP4A
     C                   MOVEL     CurTrIPY5     TranInIPY5
     C                   MOVEL     CurTrIPY6     TranInIPY6
     C                   MOVEL     CurTrIP6A     TranInIP6A                                   CER030
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   MOVEL     CurTrIPY7     TranInIPY7                                   CSW209
     C                   MOVEL     CurTrIPY8     TranInIPY8                                   CSW209
     C                   ENDIF                                                                CSW209

      ** Set Reserved Electronic Message flag to 'Y'.

     C**********         MOVEL     'Y'           DDSWFLG                                      CGL029
     C                   MOVEL     'Y'           DDSWFLG           1                          CGL029

     C     EEISwft       ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInScn - Initialise screen formats                          *
      *                                                               *
      *****************************************************************
      *
     C     SRInScn       BEGSR

      ** Set up default values on Level 1 screen.

     C                   MOVEL     'N'           DDSWPC
     C                   MOVEL     'D'           DDADDC

      ** Save Incoming Payments Lvl 1 screen details.

     C                   MOVEL     TranInIPY1    CurTrIPY1
     C                   MOVEL     TranInIP1A    CurTrIP1A
     C                   MOVEL     TranInIPY2    CurTrIPY2
     C                   MOVEL     TranInIPY3    CurTrIPY3
     C                   MOVEL     TranInIPY4    CurTrIPY4
     C                   MOVEL     TranInIP4A    CurTrIP4A
     C                   MOVEL     TranInIPY5    CurTrIPY5
     C                   MOVEL     TranInIPY6    CurTrIPY6
     C                   MOVEL     TranInIP6A    CurTrIP6A                                    CER030
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   MOVEL     TranInIPY7    CurTrIPY7                                    CSW209
     C                   MOVEL     TranInIPY8    CurTrIPY8                                    CSW209
     C                   ENDIF                                                                CSW209

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMKey - To determine if the SWIFT Reference holds a '?'     *
      *           or a valid SWIFT Reference                          *
      *                                                               *
      *****************************************************************

     C     SRMKey        BEGSR

      ** Set up part number parameter.

     C                   MOVEL     DDSEQNO       WSEQNO

     C     WSEQNO        IFEQ      0
     C                   Z-ADD     1             PKPRT
     C                   ELSE
     C                   Z-ADD     WSEQNO        PKPRT
     C                   ENDIF

      ** Check status of SWIFT Reference entered.

     C                   CALL      'ME1080'                             0101
     C                   PARM      '*KEY   '     PACT
     C     PHMSGR        PARM      *ZEROS        PMSGR
     C     PHPART        PARM                    PKPRT
     C     PHMOR         PARM      DDSWTN        PMOR
     C     PHMIR         PARM      DDSWTN        PMIR
     C                   PARM      *BLANKS       PRTN

      ** If call to program resulted in an error, then end program.

     C     PRTN          IFEQ      '*ERROR*'
     C     *IN01         OREQ      *ON
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'ME1080'      DBFILE
     C                   Z-ADD     8             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Message may not be processed by FT.

     C     PRTN          IFEQ      'MIN0197'
     C                   MOVEL     'Y'           WErr
     C                   MOVEL     'MIN0197'     PErrMs
     C                   EXSR      SRSndM
     C                   MOVEL     *BLANKS       DDSWTN
     C                   GOTO      EMKey
     C                   ENDIF

      ** A SWIFT Reference was entered.

      ** If any errors are detected, an error indicator is set on,
      ** control returns to SREISwft and from there, returns
      ** immediately to Initial screen processing.

      ** MIN0101 - SWIFT Reference not found or invalid.

     C     PRTN          IFEQ      'MIN0101'
     C                   MOVEL     'Y'           WErr
     C                   MOVEL     'MIN0101'     PErrMs
     C                   MOVE      'N'           OKSWTN
     C                   EXSR      SRSndM
     C                   GOTO      EMKey
     C                   ENDIF

      ** MIN0100 - Message part does not exist or has already been
      ** processed by Funds Transfer.

     C     PRTN          IFEQ      'MIN0100'
     C                   MOVEL     'Y'           WErr
     C                   MOVEL     'MIN0100'     PErrMs
     C                   MOVE      'N'           OKSWTN
     C                   EXSR      SRSndM
     C                   GOTO      EMKey
     C                   ENDIF

      ** MIN0103 - SWIFT Reference already reserved for this job.

     C     PRTN          IFEQ      'MIN0103'
     C                   MOVEL     'Y'           WErr
     C                   MOVEL     'MIN0103'     PErrMs
     C                   MOVE      'N'           OKSWTN
     C                   EXSR      SRSndM
     C                   GOTO      EMKey
     C                   ENDIF

      ** MIN0104 - SWIFT Reference reserved for another job.

     C     PRTN          IFEQ      'MIN0104'
     C                   MOVEL     'Y'           WErr
     C                   MOVEL     'MIN0104'     PErrMs
     C                   MOVE      'N'           OKSWTN
     C                   EXSR      SRSndM
     C                   GOTO      EMKey
     C                   ENDIF

     C     EMKey         ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMsgRsv - To reserve a selected/entered electronic message  *
      *             for use by the current job only                   *
      *                                                               *
      *****************************************************************

     C     SRMsgRsv      BEGSR

      ** The SWIFT Reference must be written to the reserved messages
      ** file to prevent other workstations accessing it for update.

     C                   CALL      'ME1070'                             0101
     C                   PARM      '*RESERV'     PACT
     C                   PARM                    PMSGR
     C                   PARM                    PKPRT
     C                   PARM                    PMOR
     C                   PARM                    PMIR
     C                   PARM      *BLANKS       PRTN

      ** If call to program resulted in an error, then end program.

     C     PRTN          IFEQ      '*ERROR*'
     C     *IN01         OREQ      *ON
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'ME1070'      DBFILE
     C                   Z-ADD     9             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

      ** If any errors are detected, an error indicator is set on,
      ** control returns to SREISwft and from there, returns
      ** to Initial screen processing.

      ** MIN0107 - Message previously reserved for this job.

     C     PRTN          IFEQ      'MIN0107'
     C                   MOVEL     'Y'           WErr
     C                   MOVEL     'MIN0107'     PErrMs
     C                   MOVE      'N'           OKSWTN
     C                   EXSR      SRSndM
     C                   GOTO      EMsgRsv
     C                   ENDIF

      ** MIN0108 - Message already reserved for another job.

     C     PRTN          IFEQ      'MIN0108'
     C                   MOVEL     'Y'           WErr
     C                   MOVEL     'MIN0108'     PErrMs
     C                   MOVE      'N'           OKSWTN
     C                   EXSR      SRSndM
     C                   GOTO      EMsgRsv
     C                   ENDIF

      ** If the SWIFT Reference is valid and available for use, then
      ** a reservation on the Reserved Messages file was made.

      ** MIN0109 - Message is now reserved for this job.

     C     PRTN          IFEQ      'MIN0109'
      **********                                                                      CSC022 BUG3279
      ***Execute commit if SAR CSC022 is not enrolled or                              CSC022 BUG3279
      *****job*is not currently running in batch mode                                 CSC022 BUG3279
      **********                                                                      CSC022 BUG3279
     C**********         If        CSC022 = 'N'                                       CSC022 BUG3279
     C**********                   Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')          CSC022 BUG3279
     C                   COMMIT
     C**********         EndIf                                                        CSC022 BUG3279
     C                   ENDIF

     C     EMsgRsv       ENDSR

      *****************************************************************                      BUG1282
      /EJECT                                                                                 BUG1282
      *****************************************************************                      BUG1282
      *                                                               *                      BUG1282
      *  DlRsMsg   - To delete the record that holds an electronic    *                      BUG1282
      *                message for use by the current job only        *                      BUG1282
      *                                                               *                      BUG1282
      *****************************************************************                      BUG1282
                                                                                             BUG1282
     C     DlRsMsg       BEGSR                                                               BUG1282
                                                                                             BUG1282
      ** The SWIFT Reference must be deleted from the reserved messages                      BUG1282
      ** file if the user cancels so that other workstations can access it                   BUG1282
                                                                                             BUG1282
     C                   CALL      'ME1070'                             0101                 BUG1282
     C                   PARM      '*END   '     PACT                                        BUG1282
     C                   PARM      *ZEROS        PMSGR                                       BUG1282
     C                   PARM      *ZEROS        PKPRT                                       BUG1282
     C                   PARM      *BLANKS       PMOR                                        BUG1282
     C                   PARM      *BLANKS       PMIR                                        BUG1282
     C                   PARM      *BLANKS       PRTN                                        BUG1282
                                                                                             BUG1282
      ** If call to program resulted in an error, then end program.                          BUG1282
                                                                                             BUG1282
     C     PRTN          IFEQ      '*ERROR*'                                                 BUG1282
     C     *IN01         OREQ      *ON                                                       BUG1282
     C                   MOVEL     '*CALL'       DBKEY                                       BUG1282
     C                   MOVEL     'ME1070'      DBFILE                                      BUG1282
     C                   Z-ADD     10            DBASE                                       BUG1282
     C                   EXSR      *PSSR                                                     BUG1282
     C                   ENDIF                                                               BUG1282
                                                                                             BUG1282
     C                   COMMIT                                                              BUG1282
                                                                                             BUG1282
     C                   ENDSR                                                               BUG1282
                                                                                             BUG1282
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCcyA33B - Retrieve the amount/currency from tag 33B.       *
      *           or a valid SWIFT Reference                          *
      *                                                               *
      *****************************************************************

     C     SrCcyA33B     BEGSR

      ** INPUT
      ** =====
      ** DS for tags  (will NOT be blanked at the end of the S/R)
      **                                  DSTRAN
      ** OUTPUT
      ** ======
      ** Currency

      ** Amount
     C                   MOVEL     *BLANKS       WCACY
     C                   MOVEL     *BLANKS       WCAAM

      ** Currency
     C                   MOVEL     TTCCY         WCACY

      ** Amount
      ** Format amount field (change ',' decimal point to '.').

     C                   MOVE      *BLANKS       WYA1
     C                   MOVEA     TTAMT         WYA1
     C                   Z-ADD     1             CX

     C                   DOU       CX > 15

     C                   IF        WYA1(CX) =  ','
     C                   MOVE      '.'           WYA1(CX)
     C                   Z-ADD     16            Cx
     C                   ELSE
     C                   ADD       1             Cx
     C                   ENDIF

     C                   ENDDO

     C                   MOVEA     WYA1          WAMT
     C                   MOVEL     WAMT          WCAAM

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROV32AM  - Overwrite transaction amount                     *
      *                                                               *
      *****************************************************************

     C     SROV32AM      BEGSR

      ** INPUTS
      ** ------
      ** Input amount
     C     *LIKE         DEFINE    DDSMAM        WOVIAM
      ** Input currency
     C     *LIKE         DEFINE    DDSMCY        WOVICY
      ** Receiver's Charges amount
     C     *LIKE         DEFINE    DDSMAM        WOVRAM
      ** Receiver's Charges currency
     C     *LIKE         DEFINE    DDSMCY        WOVRCY
      ** Operation
     C                   MOVE      WOVOPR        WOVOPR            4
      ** Value date
     C     *LIKE         DEFINE    ZDateOut      WOVVLD

      ** OUTPUTS
      ** -------
      ** Amount overwritten
     C     *LIKE         DEFINE    DDSMAM        WOVAMT

      ** Temporary variables
      ** -------------------
      ** Transaction amount numeric format
     C     *LIKE         DEFINE    P#TOAM        WOVTAN
      ** Receiver's charges amount numeric format
     C     *LIKE         DEFINE    P#TOAM        WOVRCN

      ** Reset output parameters and temporary variables

     C                   MOVEL     *BLANK        WOVAMT
     C                   Z-ADD     0             WOVTAN
     C                   Z-ADD     0             WOVRCN

      ** Retrieve details of transaction currency

     C                   CALL      'AOCURRR0'                           8080
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WOVICY        PCHR03
     C     SDCURR        PARM      *BLANKS       DSSDY
      *
      ** If both currencies are the same, we don't need to perform
      ** currency conversion before doing operation on the amounts
      *
     C                   IF        WOVICY = WOVRCY
      *
     C                   IF        PRTCD = *BLANKS AND
     C                             NOT(*IN80)
     C                   Z-ADD     A6NBDP        TRNBDP            1 0
     C                   Z-ADD     A6NBDP        RCNBDP            1 0
     C                   ENDIF
      *
      ** Format charges amount
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVEL     WOVRAM        ZFIELD
     C     13            SUB       RCNBDP        ZADIG
     C                   Z-ADD     RCNBDP        ZADEC
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZalignOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
     C                   IF        ZAlignOk = 'Y'
     C                   MOVE      ZFIELD        WOVRCN
     C                   ENDIF
      *
      ** Format input amount
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVEL     WOVIAM        ZFIELD
     C     13            SUB       TRNBDP        ZADIG
     C                   Z-ADD     TRNBDP        ZADEC
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZalignOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
     C                   IF        ZAlignOk = 'Y'
     C                   MOVE      ZFIELD        WOVTAN
     C                   ENDIF
      *
     C                   SELECT
     C                   WHEN      (WOVOPR = '*SUB')
      ** Final amount = Input amount - Charges amount
     C                   SUB       WOVRCN        WOVTAN
     C                   WHEN      (WOVOPR = '*ADD')
      ** Final amount = Input amount + Charges amount
     C                   ADD       WOVRCN        WOVTAN
     C                   ENDSL
      *
      ** Format Final amount
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVE      WOVTAN        ZFIELD
     C                   Z-ADD     TRNBDP        ZADEC
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   MOVE      ZFIELD        WOVAMT
      *
     C                   ELSE
      *
      ** Currencies are different
      *
      ** Begin to fill parameters for FT0010 (currency conversion)
     C                   CLEAR                   P#0010
     C                   MOVEL     WOVRCY        P#FRCY
     C                   MOVEL     WOVICY        P#TOCY
      *
     C                   IF        PRTCD = *BLANKS AND
     C                             NOT(*IN80)
     C                   Z-ADD     A6NBDP        TRNBDP
     C                   ENDIF
     C                   Z-ADD     WOVVLD        P#FRDT
     C                   Z-ADD     WOVVLD        P#TODT
      *
      ** Retrieve details of currency of Receiver's Charges
     C                   CALL      'AOCURRR0'                           8080
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      WOVRCY        PCHR03
     C     SDCURR        PARM      *BLANKS       DSSDY
      *
     C                   IF        PRTCD = *BLANKS AND
     C                             NOT(*IN80)
     C                   Z-ADD     A6NBDP        RCNBDP
      ** Format charges amount
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVEL     WOVRAM        ZFIELD
     C     13            SUB       RCNBDP        ZADIG
     C                   Z-ADD     RCNBDP        ZADEC
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZalignOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
     C                   IF        ZAlignOk = 'Y'
     C                   MOVE      ZFIELD        P#FRAM
     C                   ENDIF
      ** Convert the :71G: amount into the :32A: currency
     C                   CALL      'FT0010'
     C                   PARM                    P#0010
     C                   IF        P#RTCD <> *BLANK
     C                   MOVEL     'FT0010 '     DBFILE
     C                   MOVEL     '*CALL  '     DBKEY
     C                   Z-ADD     34            DBASE
     C                   EXSR      *PSSR
     C                   ELSE
     C                   Z-ADD     P#TOAM        WOVRCN           13 0
      ** Format input amount
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVEL     WOVIAM        ZFIELD
     C     13            SUB       TRNBDP        ZADIG
     C                   Z-ADD     TRNBDP        ZADEC
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZalignOK
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
     C                   IF        ZAlignOk = 'Y'
     C                   MOVE      ZFIELD        WOVTAN           13 0
     C                   ENDIF
      *
     C                   SELECT
     C                   WHEN      (WOVOPR = '*SUB')
      ** Final amount = Input amount - Charges amount
     C                   SUB       WOVRCN        WOVTAN
     C                   WHEN      (WOVOPR = '*ADD')
      ** Final amount = Input amount + Charges amount
     C                   ADD       WOVRCN        WOVTAN
     C                   ENDSL
      *
      ** Format Final amount
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVE      WOVTAN        ZFIELD
     C                   Z-ADD     TRNBDP        ZADEC
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   MOVE      ZFIELD        WOVAMT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Reset input parameters
      *
     C                   MOVEL     *BLANK        WOVIAM
     C                   MOVEL     *BLANK        WOVICY
     C                   MOVEL     *BLANK        WOVRAM
     C                   MOVEL     *BLANK        WOVRCY
     C                   MOVEL     *BLANK        WOVOPR
     C                   Z-ADD     0             WOVVLD

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRATE36  - Retrieve rate from tag 36                        *
      *                                                               *
      *****************************************************************
      *
     C     SRRATE36      BEGSR

      ** INPUTS
      ** ------
      ** Code work lines
      **                                  DSTRAN
      ** OUTPUTS
      ** -------
      ** Rate
     C     *LIKE         DEFINE    DDOEXR        W36RT
      ** Decimal Position Truncated
     C     *LIKE         DEFINE    A6NBDP        W36DPT
      ** Decimal Position
     C     *LIKE         DEFINE    A6NBDP        W36DP            +1

     C                   MOVEL     *BLANK        W36RT
     C                   Z-ADD     0             W36DPT
     C                   Z-ADD     0             W36DP

      ** Map Rate
      ** Move possible 12 chars to work array and work string

     C     12            SUBST     TMLIN1:1      @R               13
     C                   MOVEA     @R            W@R1
     C                   CLEAR                   @R

      ** If ',' in rate string @R change to '.'
      ** Only need to check valid chars till one ',' found
     C                   Z-ADD     1             @C                3 0
     C                   MOVE      *BLANK        @T                1

     C     1             DO        12            @C

     C     W@R1(@C)      IFEQ      ','
     C                   MOVE      '.'           W@R1(@C)
      ** Retrieve the number of decimal position
     C     W@CHK         CHECK     WWR1          @F                3 0
     C     @F            IFNE      0
     C     @F            SUB       1             @F
     C     @F            SUB       @C            W36DP
     C                   ELSE
     C     12            SUB       @C            W36DP
     C                   ENDIF

      ** Decimal position can be handled only on one 1 digit
      ** => range 0-9  (otherwise truncated to 9)
     C     W36DP         IFGT      9
     C                   Z-ADD     9             W36DPT
     C                   ELSE
     C                   Z-ADD     W36DP         W36DPT
     C                   ENDIF

     C                   LEAVE
     C                   ENDIF

     C                   ENDDO

     C                   Z-ADD     1             @C
     C                   MOVE      *BLANKS       @T                1
     C                   MOVEA     W@R1          @R

      ** Get amount - upto 12 chars possible

     C     @C            DOUGT     12

     C                   MOVE      W@R1(@C)      @T
     C     W@CHK         CHECK     @T            @F                       82

      ** Char not valid must be end of rate
     C     *IN82         IFEQ      *ON
     C     @C            IFNE      1
     C     @C            SUB       1             @F
     C     @F            SUBST     @R:1          W36RT
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF

      ** All chars in string are ok
     C     @C            IFEQ      12
     C                   MOVEL     @R            W36RT
     C                   ENDIF

     C                   ADD       1             @C

     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFOCmt2 - Extraction of field 72 from SWIFT Message         *
      *                                                               *
      *****************************************************************
      *
     C     SRFOCmt2      BEGSR

      ** Initialise working fields for FONTIS.

     C                   MOVE      *BLANKS       WCWCY             3
     C                   MOVE      *BLANKS       WCWAM            14

      ** Retrieve Notified Delivery Currency and Amount.

     C                   MOVEL     '012345'      WCHK             11
     C                   MOVE      '6789.'       WCHK

     C     WCW           SCAN      WCWLIN:1      WF                3 0    01

     C     *IN01         IFEQ      *ON

      ** Map Currency Code -> ODDNDCY.

     C                   ADD       6             WF
     C     3             SUBST     WCWLIN:WF     WCWCY

      ** Map Amount -> ODDNDAM.

      ** Move possible 15 chars to work array and work string.

     C                   ADD       3             WF
     C     15            SUBST     WCWLIN:WF     WS               15
     C                   MOVEA     WS            WA
     C                   CLEAR                   WS

      ** If ',' in amount string WS, change to '.'.
      ** Only need to check valid chars till one ',' found.

     C                   Z-ADD     1             WC                3 0
     C                   MOVE      *BLANKS       WT                1

     C     1             DO        15            WC
     C                   MOVE      WA(WC)        WT
     C     WT            IFEQ      ','
     C                   MOVE      '.'           WA(WC)
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO

     C                   Z-ADD     1             WC
     C                   MOVE      *BLANKS       WT                1
     C                   MOVEA     WA            WS

      ** Get Amount - up to 15 chars possible.

     C     WC            DOUGT     15

     C                   MOVE      WA(WC)        WT
     C     WCHK          CHECK     WT            WF                       01

      ** Char not valid, must be end of Amount.

     C     *IN01         IFEQ      *ON
     C     WC            IFNE      1
     C     WC            SUB       1             WF
     C     WF            SUBST     WS:1          WCWAM
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF

      ** All chars in string ok.

     C     WC            IFEQ      15
     C                   MOVEL     WS            WCWAM
     C                   ENDIF

     C                   ADD       1             WC

     C                   ENDDO

     C                   ENDIF

      ** Reset variables.

     C                   MOVEL     *BLANKS       WCWLIN          256
     C                   MOVEL     *BLANKS       WCW               6

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFont - Map translated data for Incoming FONTIS Messages    *
      *                                                               *
      *****************************************************************
      *
     C     SRFont        BEGSR

      ** Set up defaults for FONTIS.

     C                   MOVE      'N'           ODDSWPC
     C                   MOVE      *BLANKS       ODDACBK
     C                   MOVE      *BLANKS       ODDACBB

      ** Retrieve Electronic Banking ICD details.

     C                   CALL      'AOFONTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST'      POPTN
     C     SDFONT        PARM      SDFONT        DSFDY

     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST'      DBKEY
     C                   MOVEL     'SDFONTPD'    DBFILE
     C                   Z-ADD     027           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   MOVE      F8IPST        ODDPYST
     C                   MOVE      F8TBKC        ODDBOKC

      ** Related Reference.

     C     P20           IFNE      *BLANKS
     C                   MOVEL     P20           DSTRAN
     C                   MOVEL     TTREF         IPRLPR
     C                   MOVEL     TTREF         ODDRLPR
     C                   ELSE
     C                   MOVEL     *BLANKS       IPRLPR
     C                   MOVEL     *BLANKS       ODDRLPR
     C                   ENDIF

      ** Pay Currency/Value Date/Amount.

     C     PDCA          IFNE      *BLANKS

     C                   MOVEL     PDCA          DSTRAN

      ** Pay Currency.

     C                   MOVEL     TVCCY         ODDPCCY

      ** Pay Amount.

      ** Format amount field (change ',' decimal point to '.').

     C                   MOVEA     *BLANKS       WYA1
     C                   MOVEA     TVAMT         WYA1
     C                   Z-ADD     1             Cx

     C     Cx            DOUGT     15
     C     WYA1(Cx)      IFEQ      ','
     C                   MOVE      '.'           WYA1(Cx)
     C                   Z-ADD     16            Cx
     C                   ELSE
     C                   ADD       1             Cx
     C                   ENDIF
     C                   ENDDO

     C                   MOVEA     WYA1          WNLAM
     C                   MOVEA     WYA1          WWPYAM           14

     C                   EXSR      SRNull

     C     WNLNUL        IFEQ      'N'
     C                   MOVEL     WWPYAM        ODDPYAM
     C                   ELSE
     C                   MOVEL     *BLANKS       ODDPYAM
     C                   ENDIF

      ** Pay Value Date.

     C                   MOVEL     TVVDAT        WWDT

      ** MMDDYY format display.

     C     BJDFIN        IFEQ      'M'

     C                   EVAL      ODDPYDT = WD2 + WD3 + WD1

     C                   ELSE

      ** DDMMYY format display.

     C                   EVAL      ODDPYDT = WD3 + WD2 + WD1

     C                   ENDIF

     C                   CALLB     'ZDATE1'
     C                   PARM      ODDPYDT       PDateIn           6
     C                   PARM      *ZERO         PDaynoOut         5 0
     C                   PARM      BJDFIN        PDateFmt          1
     C                   PARM                    PError            1

     C     PError        IFNE      'Y'
     C                   Z-ADD     PDaynoOut     WVLDT
     C                   ELSE
     C                   Z-ADD     BJRDNB        WVLDT             5 0
     C                   ENDIF

     C                   ENDIF

      ** Debit Account.

     C     P53           IFNE      *BLANKS

     C                   MOVE      *BLANKS       WWP53P           35
     C                   MOVEL     P53           DSTRAN
     C                   MOVEL     TMLIN1        WWP53

     C     WWP53A        IFEQ      '/'
     C                   MOVEL     WWP53B        WWP53P
     C                   ENDIF

     C                   MOVEL     *BLANKS       ODDSND2
     C                   MOVEL     *BLANKS       ODDSND3
     C                   MOVEL     *BLANKS       ODDSND4

     C     ' '           CHECKR    WWP53P        WWLEN             2 0

      ** Check if it is a Retail Account.

     C     WWLEN         IFEQ      10

     C                   MOVEL     WWP53P        PPRETL
     C                   MOVEL     *BLANKS       PPCNUM
     C                   MOVEL     *BLANKS       PPCUCD
     C                   MOVEL     *BLANKS       PPACCD
     C                   MOVEL     *BLANKS       PPACSQ
     C                   MOVEL     *BLANKS       PPBRCA

     C                   ELSE

      ** Account is not Retail but General Ledger.

     C                   MOVEL     *BLANKS       PPRETL
     C     3             SUBST     WWP53P:1      PPBRCA
     C     6             SUBST     WWP53P:4      PPCNUM
     C     3             SUBST     WWP53P:10     PPCUCD
     C*****4****         SUBST     WWP53P:13     PPACCD                                       CGL029
     C*****2****         SUBST     WWP53P:17     PPACSQ                                       CGL029
     C     10            SUBST     WWP53P:13     PPACCD                                       CGL029
     C     2             SUBST     WWP53P:23     PPACSQ                                       CGL029

     C                   ENDIF

      ** Access Account Details.

     C                   CALLB     'AOACCTR0'
     C                   PARM      *BLANKS       PPRTCD            7
     C                   PARM      '*KEY   '     PPOPTN            7
     C                   PARM                    PPRETL           10
     C                   PARM                    PPCNUM            6
     C                   PARM                    PPCUCD            3
     C**********         PARM                    PPACCD            4                          CGL029
     C                   PARM                    PPACCD           10                          CGL029
     C                   PARM                    PPACSQ            2
     C                   PARM                    PPBRCA            3
     C     SDACCT        PARM      SDACCT        DSSDY

     C                   IF        PRTCD = *BLANKS

      ** If it is a G/L Account, we put the Branch as the end
      ** (BRCA/CUST/CCY/ACOD/SEQ) => (CUST/CCY/ACOD/SEQ/BRCA).
      ** If it is a Retail one, we don't format it.

     C     WWLEN         IFEQ      10
     C                   MOVEL     WWP53P        ODDSND1
     C                   ELSE
     C     3             SUBST     WWP53P:1      WGLBCH
     C     3             SUBST     WWP53P:10     WGLCCY
     C     6             SUBST     WWP53P:4      WGLCST
     C*****4****         SUBST     WWP53P:13     WGLACD                                       CGL029
     C*****2****         SUBST     WWP53P:17     WGLSQN                                       CGL029
     C     10            SUBST     WWP53P:13     WGLACD                                       CGL029
     C     2             SUBST     WWP53P:23     WGLSQN                                       CGL029
     C                   MOVEL     WDSGLDG       ODDSND1
     C                   ENDIF

     C                   MOVEL     IFBRCA        ODDBRCA
     C                   MOVEL     IFBRCA        ODDORBR

     C                   ELSE

      ** If no valid account in tag 53 we concatenate line of
      ** 53 (A/C debited)  + first lines of 50 (Ord Cust)
     C                   MOVEL     WWP53P        ODDSND1
     C                   MOVEL     P50           DSTRAN
     C                   MOVEL     TMLIN1        ODDSND2
     C                   MOVEL     TMLIN2        ODDSND3
     C                   MOVEL     TMLIN3        ODDSND4

     C                   ENDIF

     C                   ENDIF

      ** Profit Centre.

     C     BKPRCU        IFEQ      'Y'

      ** Retrieve default Profit Centre.

     C     BKPCDU        IFEQ      'Y'

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

     C                   IF        *In01 = *On
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'AOPRFMR0'    DBFILE
     C                   Z-ADD     028           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDIF

     C     ODDPRFC       IFEQ      *BLANKS
     C                   MOVEL     F8TPFC        ODDPRFC
     C                   ENDIF

     C                   ENDIF

      ** Beneficiary Customer.

     C     P59           IFNE      *BLANKS

     C                   MOVE      *BLANKS       WWP59P           35
     C                   MOVEL     P59           DSTRAN
     C                   MOVEL     TMLIN1        WWP59

     C     WWP59A        IFEQ      '/'
     C                   MOVEL     WWP59B        WWP59P
     C                   ENDIF

     C     ' '           CHECKR    WWP59P        WWLEN

      ** Check if it is a Retail Account.

     C     WWLEN         IFEQ      10

     C                   MOVEL     WWP59P        PPRETL
     C                   MOVEL     *BLANKS       PPCNUM
     C                   MOVEL     *BLANKS       PPCUCD
     C                   MOVEL     *BLANKS       PPACCD
     C                   MOVEL     *BLANKS       PPACSQ
     C                   MOVEL     *BLANKS       PPBRCA

     C                   ELSE

      ** Account is not Retail but General Ledger.

     C                   MOVEL     *BLANKS       PPRETL
     C     3             SUBST     WWP59P:1      PPBRCA
     C     6             SUBST     WWP59P:4      PPCNUM
     C     3             SUBST     WWP59P:10     PPCUCD
     C*****4****         SUBST     WWP59P:13     PPACCD                                       CGL029
     C*****2****         SUBST     WWP59P:17     PPACSQ                                       CGL029
     C     10            SUBST     WWP59P:13     PPACCD                                       CGL029
     C     2             SUBST     WWP59P:23     PPACSQ                                       CGL029

     C                   ENDIF

      ** Access Account details.

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

     C     PPRTCD        IFEQ      *BLANKS

     C     WWLEN         IFEQ      10
     C                   MOVEL     WWP59P        ODDBNC1
     C                   ELSE
     C     3             SUBST     WWP59P:1      WWBCH1
     C     6             SUBST     WWP59P:4      WWCUS1
     C*****4****         SUBST     WWP59P:13     WWACD1                                       CGL029
     C*****2****         SUBST     WWP59P:17     WWSQN1                                       CGL029
     C     4             SUBST     WWP59P:13     WWACD1                                       CGL029
     C     2             SUBST     WWP59P:17     WWSQN1                                       CGL029
     C                   MOVEL     WWBNC1        ODDBNC1
     C                   ENDIF

     C                   MOVEL     *BLANKS       ODDBNC2
     C                   MOVEL     *BLANKS       ODDBNC3
     C                   MOVEL     *BLANKS       ODDBNC4
     C                   MOVEL     *BLANKS       ODDBNC5

     C                   ENDIF

     C                   ENDIF

      ** Details of Charges.

     C     P71           IFNE      *BLANKS

     C                   MOVEL     P71           DSTRAN

     C     TTREF         IFEQ      'OUR'
     C                   MOVEL     'A'           ODDADDC
     C                   ELSE
     C                   MOVEL     'D'           ODDADDC
     C                   ENDIF

     C                   ELSE

     C                   MOVEL     'D'           ODDADDC

     C                   ENDIF

      ** Sender to Receiver Information.

     C     P72           IFEQ      *BLANKS

      ** Settlement CCY will be the same as the Account to be Debited.

     C                   MOVEL     *BLANKS       ODDSMCY

      ** FT fields have been cleared in SREISwft.

     C                   ELSE

     C                   EXSR      SRICChk

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

     C                   MOVEL     '/ORIG/'      WCW
     C                   MOVEL     FONT72        WCWLIN
     C                   EXSR      SRFOCmt2
     C     WCWCY         IFNE      *BLANK
     C                   MOVEL     WCWCY         ODDSMCY
     C                   ELSE
     C                   MOVEL     *BLANKS       ODDSMCY
     C                   ENDIF

     C                   MOVEL     WCWAM         WNLAM
     C                   EXSR      SRNull

     C     WNLNUL        IFEQ      'N'
     C                   MOVEL     WCWAM         ODDSMAM
     C                   ELSE
     C                   MOVEL     *BLANKS       ODDSMAM
     C                   ENDIF

     C                   MOVEL     '/RATE/'      WCW
     C                   MOVEL     FONT72        WCWLIN
     C                   EXSR      SRRate
     C                   MOVEL     WCWRT         WNLAM
     C                   EXSR      SRNull

     C     WNLNUL        IFEQ      'Y'

     C                   MOVEL     *BLANKS       WCWRT

     C                   ELSE

      ** Decimal places in FT are stored on 8 digits
      ** => truncated if greater.

     C     WCWDPT        IFGT      8

     C     '.'           SCAN      WCWRT         IN                2 0

      ** Extract Digits + comma.

     C     IN            SUBST(P)  WCWRT:1       W014A            14
     C                   ADD       1             IN

      ** Extract Decimals after comma.

     C     8             SUBST(P)  WCWRT:IN      W008A             8
     C     W014A         CAT(P)    W008A:0       WCWRT

     C                   ENDIF

     C                   ENDIF

     C     WCWRT         IFNE      *BLANKS
     C                   MOVE      WCWRT         ODDRATE
     C                   ENDIF

     C                   ENDIF

     C                   MOVEL     'N'           ODDOPIN
     C                   MOVEL     *BLANKS       ODDNDAM

     C     ODDSMCY       IFEQ      ODDNDCY
     C                   MOVEL     *BLANK        ODDNDCY
     C                   ENDIF

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

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNull - Test if Amount is null                              *
      *                                                               *
      *****************************************************************

     C     SRNULL        BEGSR

      ** Initialise working fields.

     C                   MOVEL     'Y'           WNLNUL            1
     C                   MOVEL     '123456'      WNUL              9
     C                   MOVE      '789'         WNUL

     C     WNLAM         IFNE      *BLANK
     C                   MOVEL     *BLANKS       WYA1
     C                   MOVEA     WNLAM         WYA1

     C                   DO        15            IN

     C     WNUL          CHECK     WYA1(IN)                               01

     C     *IN01         IFEQ      '0'
     C                   MOVEL     'N'           WNLNUL
     C                   LEAVE
     C                   ENDIF

     C                   ENDDO

     C                   ENDIF

      ** Initialise working fields.

     C                   MOVEL     *BLANKS       WNLAM            15
     C                   MOVEL     *BLANKS       WYA1              1

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRICChk - Scan for /OCMT/, /ORIG/, /RATE/                    *
      *                                                               *
      *****************************************************************

     C     SRICChk       BEGSR

     C                   MOVEL     *BLANKS       WFound            1

     C     '/RATE/'      SCAN      P72:1         PX                3 0    81
     C     *IN81         IFEQ      *OFF
     C     '/ORIG/'      SCAN      P72:1         PX                       81
     C     *IN81         IFEQ      *OFF
     C     '/OCMT/'      SCAN      P72:1         PX                       81
     C                   ENDIF
     C                   ENDIF

     C     *IN81         IFEQ      *ON
     C                   MOVE      'Y'           WFound
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRate - Retrieve the Rate and the Multiply/Divide indicator *
      *                                                               *
      *****************************************************************

     C     SRRate        BEGSR

      ** Reset work variables.

     C                   MOVEL     *BLANK        WCWRT            14
     C                   Z-ADD     0             WCWDPT            1 0
     C                   Z-ADD     0             WCWDP             2 0

     C     WCW           SCAN      WCWLIN:1      WF                3 0    01

     C     *IN01         IFEQ      *ON

     C                   ADD       6             WF

      ** Move possible 13 chars to work array and work string.

     C     13            SUBST     WCWLIN:WF     WR               13
     C                   MOVEA     WR            WSR
     C                   CLEAR                   WR

      ** If ',' in rate string WR, change to '.'.
      ** Only need to check valid chars till one ',' found.

     C                   Z-ADD     1             WC                3 0
     C                   MOVE      *BLANKS       WT                1

     C     1             DO        13            WC

     C     WSR(WC)       IFEQ      ','

     C                   MOVE      '.'           WSR(WC)

      ** Retrieve the number of decimal position.

     C     WCHK          CHECK     WR1           WF                3 0
     C     WF            IFNE      0
     C     WF            SUB       1             WF
     C     WF            SUB       WC            WCWDP
     C                   ELSE
     C     13            SUB       WC            WCWDP
     C                   ENDIF

      ** Decimal position can be handled only on one 1 digit
      ** => range 0-9  (otherwise, truncated to 9).

     C     WCWDP         IFGT      9
     C                   Z-ADD     9             WCWDPT
     C                   ELSE
     C                   Z-ADD     WCWDP         WCWDPT
     C                   ENDIF

     C                   LEAVE

     C                   ENDIF

     C                   ENDDO

     C                   Z-ADD     1             WC
     C                   MOVE      *BLANKS       WT                1
     C                   MOVEA     WSR           WR

      ** Get Amount - up to 13 chars possible.

     C     WC            DOUGT     13

     C                   MOVE      WSR(WC)       WT
     C     WCHK          CHECK     WT            WF                       01

      ** Char not valid must be end of rate.

     C     *IN01         IFEQ      *ON
     C     WC            IFNE      1
     C     WC            SUB       1             WF
     C     WF            SUBST     WR:1          WCWRT
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF

      ** All chars in string ok.

     C     WC            IFEQ      13
     C                   MOVEL     WR            WCWRT
     C                   ENDIF

     C                   ADD       1             WC

     C                   ENDDO

     C                   ENDIF

      ** Reset input variables.

     C                   MOVEL     *BLANKS       WCWLIN
     C                   MOVEL     *BLANKS       WCW

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIMsg - Map translated data for incoming messages           *
      *                                                               *
      *****************************************************************

     C     SRIMsg        BEGSR

      ** Set up the detail screen fields from the message.

      ** Sender.

      ** In FONTIS, this field can be translated only by
      ** the sender correspondant (P53).

     C     PNWRK         IFNE      'FONTIS'

     C     PSN           IFNE      *BLANKS

     C                   MOVEL     PSN           DSTRAN

     C     TRCODE        IFNE      *BLANKS

      ** Translate to Nostro and Retail account numbers.

     C                   EXSR      SRTran

     C                   SELECT

      ** If Local and Account Currency Local, then use Retail number.

     C     BJLCCY        WHENEQ    ODDSMCY
     C     WRCYCD        ANDEQ     ODDSMCY
     C     WWACNO        ANDNE     0
     C                   MOVE      *BLANKS       ODDSND1
     C                   MOVE      *BLANKS       ODDSND2
     C                   MOVE      *BLANKS       ODDSND3
     C                   MOVE      *BLANKS       ODDSND4
     C                   MOVEL     WWACNO        ODDSND1

      ** If Currency the same as Settle and Nostro, use Nostro.

     C     WWNCCY        WHENEQ    ODDSMCY
     C     WWNONB        ANDNE     *BLANKS
     C                   MOVE      *BLANKS       ODDSND1
     C                   MOVE      *BLANKS       ODDSND2
     C                   MOVE      *BLANKS       ODDSND3
     C                   MOVE      *BLANKS       ODDSND4
     C     WWNCCY        CAT(P)    WWNONB        ODDSND1

      ** If Currency the same, use GL Account.

     C     WRCYCD        WHENEQ    ODDSMCY
     C                   MOVE      *BLANKS       ODDSND1
     C                   MOVE      *BLANKS       ODDSND2
     C                   MOVE      *BLANKS       ODDSND3
     C                   MOVE      *BLANKS       ODDSND4
     C     BGMBIN        IFNE      'Y'
     C                   MOVE      '   '         TRCODE
     C                   ENDIF
     C                   MOVEL     TRCODE        ODDSND1

      ** Use Customer Number.

     C                   OTHER
     C                   MOVE      *BLANKS       ODDSND1
     C                   MOVE      *BLANKS       ODDSND2
     C                   MOVE      *BLANKS       ODDSND3
     C                   MOVE      *BLANKS       ODDSND4
     C                   MOVEL     WRCNUM        ODDSND1

     C                   ENDSL

     C                   ELSE

     C                   MOVEL     TMLIN2        ODDSND2

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      ** Senders Correspondent.

      **  By default, will translate the Sender field in FONTIS.

     C                   MOVEL     P54           DSTRAN
     C                   MOVEL     TRCODE        WRCDE2

     C     P54           IFEQ      *BLANKS
     C     P53           ANDNE     *BLANKS
     C     P54           ORNE      *BLANKS
     C     WRCNUM        ANDEQ     '501116'
     C     P53           ANDNE     *BLANKS

     C                   MOVEL     P53           DSTRAN
     C                   MOVEL     TRCODE        WRCDE2

     C     TRCODE        IFNE      *BLANKS
     C     WRCNUM        ANDNE     '501116'

      ** Translate to Nostro and Retail account numbers.

     C                   EXSR      SRTran

     C                   SELECT

      ** If Local and Account Currency Local, then use Retail number.

     C     BJLCCY        WHENEQ    ODDSMCY
     C     WRCYCD        ANDEQ     ODDSMCY
     C     WWACNO        ANDNE     0
     C                   MOVE      *BLANKS       ODDSND1
     C                   MOVE      *BLANKS       ODDSND2
     C                   MOVE      *BLANKS       ODDSND3
     C                   MOVE      *BLANKS       ODDSND4
     C                   MOVEL     WWACNO        ODDSND1

      ** If Currency the same as Settle and Nostro, use Nostro.

     C     WWNCCY        WHENEQ    ODDSMCY
     C     WWNONB        ANDNE     *BLANKS
     C                   MOVE      *BLANKS       ODDSND1
     C                   MOVE      *BLANKS       ODDSND2
     C                   MOVE      *BLANKS       ODDSND3
     C                   MOVE      *BLANKS       ODDSND4
     C     WWNCCY        CAT(P)    WWNONB        ODDSND1

      ** If Currency the same, use GL Account.

     C     WRCYCD        WHENEQ    ODDSMCY
     C                   MOVE      *BLANKS       ODDSND1
     C                   MOVE      *BLANKS       ODDSND2
     C                   MOVE      *BLANKS       ODDSND3
     C                   MOVE      *BLANKS       ODDSND4
     C     BGMBIN        IFNE      'Y'
     C                   MOVE      '   '         TRCODE
     C                   ENDIF
     C                   MOVEL     TRCODE        ODDSND1

      ** Use Customer Number.

     C                   OTHER
     C                   MOVE      *BLANKS       ODDSND1
     C                   MOVE      *BLANKS       ODDSND2
     C                   MOVE      *BLANKS       ODDSND3
     C                   MOVE      *BLANKS       ODDSND4
     C                   MOVEL     WRCNUM        ODDSND1

     C                   ENDSL

     C                   ENDIF

     C                   ENDIF

      ** Receiver's Correspondent.

     C                   SELECT

     C     PNWRK         WHENEQ    'YENKSI'

     C     P54           WHENNE    *BLANKS

     C                   MOVEL     P54           DSTRAN
     C                   MOVEL     TRCODE        WRCDE2
     C     TRCODE        IFNE      *BLANKS
     C     WRCNUM        ANDEQ     '501116'
     C                   MOVE      *BLANKS       ODDRCO1
     C                   ENDIF

     C     TRCODE        IFNE      *BLANKS
     C     WRCNUM        ANDNE     '501116'

      ** Translate to Nostro and Retail account numbers.

     C                   EXSR      SRTran

     C                   SELECT

      ** If Local and Account Currency Local, then use Retail number.

     C     BJLCCY        WHENEQ    ODDSMCY
     C     WRCYCD        ANDEQ     ODDSMCY
     C     WWACNO        ANDNE     0
     C                   MOVE      *BLANKS       ODDRCO1
     C                   MOVEL     WWACNO        ODDRCO1

      ** If Currency the same as Settle and Nostro, use Nostro.

     C     WWNCCY        WHENEQ    ODDSMCY
     C     WWNONB        ANDNE     *BLANKS
     C                   MOVE      *BLANKS       ODDRCO1
     C                   MOVEL     WWNONB        ODDRCO1

      ** Use Customer Number.

     C                   OTHER
     C                   MOVE      *BLANKS       ODDRCO1
     C                   MOVEL     WRCNUM        ODDRCO1

     C                   ENDSL

     C                   ENDIF

     C                   ENDSL

      ** Account with Institution.

      ** Can't be translated if FONTIS message.

     C     PNWRK         IFNE      'FONTIS'

     C     P57           IFNE      *BLANKS

     C                   MOVEL     P57           DSTRAN

      ** Translate to Nostro and Retail account numbers.

     C     TRCODE        IFNE      *BLANKS

     C                   EXSR      SRTran

     C                   SELECT

      ** If Local and Account Currency Local, then use Retail number.

     C     BJLCCY        WHENEQ    ODDSMCY
     C     WRCYCD        ANDEQ     ODDSMCY
     C     WWACNO        ANDNE     0
     C                   MOVE      *BLANKS       ODDACBK
     C                   MOVEL     WWACNO        ODDACBK

      ** If Currency the same as Settle and Nostro, use Nostro.

     C     WWNCCY        WHENEQ    ODDSMCY
     C     WWNONB        ANDNE     *BLANKS
     C                   MOVE      *BLANKS       ODDACBK
     C                   MOVEL     WWNONB        ODDACBK

      ** If Currency the same, use GL Account.

     C     WRCYCD        WHENEQ    ODDSMCY
     C                   MOVE      *BLANKS       ODDACBK
     C     WRCNUM        CAT       WRCDSQ        ODDACBK
     C     BGMBIN        IFEQ      'Y'
     C                   MOVE      WRBRCD        ODDACBB
     C                   ENDIF

      ** Use Customer Number.

     C                   OTHER
     C                   MOVE      *BLANKS       ODDACBK
     C                   MOVEL     WRCNUM        ODDACBK

     C                   ENDSL

     C                   ENDIF

     C                   ENDIF

     C                   ENDIF

      ** Beneficiary Institution/ Beneficiary Customer.

     C     P58           IFNE      *BLANKS

     C                   MOVEL     P58           DSTRAN

     C     TRCODE        IFNE      *BLANKS

      ** Translate to Nostro and Retail account numbers.

     C                   EXSR      SRTran

     C                   SELECT

      ** If Local and Account Currency Local, then use Retail number.

     C     BJLCCY        WHENEQ    ODDSMCY
     C     WRCYCD        ANDEQ     ODDSMCY
     C     WWACNO        ANDNE     0
     C                   MOVE      *BLANKS       ODDBNC1
     C                   MOVEL     WWACNO        ODDBNC1
     C                   MOVEL     *BLANKS       ODDBNC2
     C                   MOVEL     *BLANKS       ODDBNC3
     C                   MOVEL     *BLANKS       ODDBNC4
     C                   MOVEL     *BLANKS       ODDBNC5

      ** If Currency the same, use GL Account.

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

      ** Use Customer Number.

     C                   OTHER
     C                   MOVE      *BLANKS       ODDBNC1
     C                   MOVEL     WRCNUM        ODDBNC1
     C                   MOVEL     *BLANKS       ODDBNC2
     C                   MOVEL     *BLANKS       ODDBNC3
     C                   MOVEL     *BLANKS       ODDBNC4
     C                   MOVEL     *BLANKS       ODDBNC5

     C                   ENDSL

     C                   ENDIF

     C                   ENDIF

     C     P59           IFNE      *BLANKS

     C                   MOVEL     P59           DSTRAN

      ** Translate to Nostro and Retail account numbers.

     C     TRCODE        IFNE      *BLANKS

     C                   EXSR      SRTran

     C                   SELECT

      ** If Local and Account Currency Local, then use Retail number.

     C     BJLCCY        WHENEQ    ODDSMCY
     C     WRCYCD        ANDEQ     ODDSMCY
     C     WWACNO        ANDNE     0
     C                   MOVE      *BLANKS       ODDBNC1
     C                   MOVEL     WWACNO        ODDBNC1
     C                   MOVEL     *BLANKS       ODDBNC2
     C                   MOVEL     *BLANKS       ODDBNC3
     C                   MOVEL     *BLANKS       ODDBNC4
     C                   MOVEL     *BLANKS       ODDBNC5

      ** If Currency the same, use GL Account.

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

      ** Use Customer Number.

     C                   OTHER
     C                   MOVE      *BLANKS       ODDBNC1
     C                   MOVEL     WRCNUM        ODDBNC1
     C                   MOVEL     *BLANKS       ODDBNC2
     C                   MOVEL     *BLANKS       ODDBNC3
     C                   MOVEL     *BLANKS       ODDBNC4
     C                   MOVEL     *BLANKS       ODDBNC5

     C                   ENDSL

     C                   ENDIF

     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTran - Translate to Retail and Nostro Code                 *
      *                                                               *
      *****************************************************************

     C     SRTran        BEGSR

     C     *LIKE         DEFINE    ACNO          WWACNO
     C     *LIKE         DEFINE    A7CYCD        WWNCCY
     C     *LIKE         DEFINE    A7NONB        WWNONB

      ** Clear Retail number and Nostro Code.

     C                   Z-ADD     *ZERO         WWACNO
     C                   MOVEL     *BLANKS       WWNCCY
     C                   MOVEL     *BLANKS       WWNONB

      ** If TRCODE has no Currency, exit.

     C                   MOVE      TRCODE        WRCDE2
     C     WRCYCD        IFEQ      *BLANKS
     C                   GOTO      ETran
     C                   ENDIF

      ** Find Account details.

     C                   MOVEL     TRCODE        WACKYDS
     C     KAccnt        CHAIN     ACCNTABF                           01

     C     *IN01         IFEQ      *OFF
     C     RECI          ANDEQ     'D'
     C     ATYP          ANDEQ     'R'
     C                   Z-ADD     ACNO          WWACNO
     C                   ENDIF

      ** Move numeric fields to parameter fields.

     C                   MOVEL     CNUM          PCUST
     C                   MOVEL     ACOD          PACCD
     C                   MOVEL     ACSQ          PACSN

      ** Find Nostro details.

     C                   CALLB     'AONOSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCUST
     C                   PARM      CCY           PCYCD             3
     C**********         PARM                    PACCD             4                          CGL029
     C                   PARM                    PACCD            10                          CGL029
     C                   PARM                    PACSN             2
     C                   PARM      *BLANKS       PNONB             2
     C                   PARM      BRCA          PBRCD             3
     C                   PARM      *BLANKS       PCSSN            10
     C                   PARM      *BLANKS       PPNOI             1
     C     SDNOST        PARM      *BLANKS       DSFDY

     C     PRTCD         IFEQ      *BLANKS
     C                   MOVEL     A7CYCD        WWNCCY
     C                   MOVEL     A7NONB        WWNONB
     C                   ENDIF

     C     ETran         ENDSR

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
      *  SRSndM - Send error message to screen                        *
      *                                                               *
      *****************************************************************

     C     SRSndM        BEGSR

      ** Add error message to array passed to screen.

     C**********         Z-ADD     1             Ex                3 0                        BUG515
     C******BLANK        LOOKUP    FldNameArr(Ex)                         99                  BUG515
     C**********         MOVEL     '*ANY'        FldNameArr(Ex)                               BUG515
     C**********         MOVEL     PErrMs        MsgIdArr(Ex)                                 BUG515
     C                   Z-ADD     1             Idx                                          BUG515
     C                   EVAL      FldNameArr(Idx) = 'DDSWTN'                                 BUG515
     C                   EVAL      MsgIdArr(Idx) = PErrMs                                     BUG515

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      ******************************************************************
      *                                                                *
      *  ValidateTr - Routine to validate the main transaction details *
      *                                                                *
      ******************************************************************
     C     ValidateTr    BEGSR

      ** Move Incoming Payment details retrieved from the Midas
      ** database file into the update file record.  If no
      ** record has been retrieved (i.e. in Insert), fields
      ** contain initial values (zeros, blanks and 'Y's for
      ** VAT flags).

     C                   If        DDACTN <> 'I'                                              255190
     C                   MOVEL     IPAYFilFmt    ValidIPAY
     C                   Endif                                                                255190
      *                                                                                       255190
     C                   IF        CFT003 = 'Y' or CFT014 = 'Y'
     C                             OR CFT009 = 'Y'
     C                   MOVEL     IPY2FilFmt    ValidIPY2
     C                   ELSE                                                                BUG7101
     C                   CLEAR                   ValidIPY2                                   BUG7101
     C                   ENDIF

      ** Validate Level 1 screen details.

     C                   EXSR      ValidateTr1

      ** Check if errors found in main screen
     C                   IF        Idx <> *ZERO
     C                   EVAL      WFirstErr = 'Y'
     C                   ENDIF

      ** Initialise Level 2 Processing flag for update of Level 2
      ** details.

     C                   EVAL      WLvl2 = *BLANK

      ** Level 2 screen details exist.
      ** Or 'level joiner' = 'Y'                                                              243991

     C                   IF        TranInIPY2 <> *BLANKS OR
     C                             TranInIPY3 <> *BLANKS OR
     C                             TranInIPY4 <> *BLANKS OR
     C                             TranInIP4A <> *BLANKS OR
     C                             TranInIPY5 <> *BLANKS OR
     C******                       TranInIPY6 <> *BLANKS                                      243991
     C                             TranInIPY6 <> *BLANKS OR                                   243991
     C                             TranInIP6A <> *BLANKS OR                                   CER030
     C                             BTLVJN     =  'Y'                                          243991

      ** Set Level 2 Processing flag for update of Level 2 details.

     C                   EVAL      WLvl2 = 'Y'

      ** If Action is Insert, or Action is Amend and Level 2
      ** details have not been entered, default Transfer
      ** Commission Tariff based on Charges Branch.

     C                   IF        (DDACTN = 'I' OR
     C                             DDACTN = 'A' AND
     C                             INLVL2 <> 'Y') AND
     C                             DDTRCT = *BLANKS

     C                   EVAL      PPYTY = 'IN'                                             MD034973
     C                   EVAL      PCNUM = DDBNC1                                           MD034973
     C                   EVAL      PPYST = DDPYST                                           MD034973
     C     PPYKEY        CHAIN     PYCHGL1                            01                    MD034973
     C   01              EVAL      PPYST = *BLANKS                                          MD034973
     C   01              EVAL      PPYTY = *BLANKS                                          MD034973
     C   01PPYKEY        CHAIN     PYCHGL1                            01                    MD034973
     C   01              EVAL      PPYTY = 'IN'                                             MD034973
     C   01              EVAL      PCNUM = *BLANKS                                          MD034973
     C   01              EVAL      PPYST = DDPYST                                           MD034973
     C   01PPYKEY        CHAIN     PYCHGL1                            01                    MD034973
     C   01              EVAL      PPYST = *BLANKS                                          MD034973
     C   01PPYKEY        CHAIN     PYCHGL1                            01                    MD034973
     C*****PPYBR         CHAIN     PYCHGDB                            01                    MD034973
     C   01PPYBR         CHAIN     PYCHGL1                            01                    MD034973
     C                   IF        NOT(*IN01)
     C                   EVAL      DDTRCT = PYDFTRCT
     C                   MOVEL     TranInIPY3    CurTrIPY3
     C                   ENDIF

     C                   ENDIF

      ** Validate Level 2 screen 1 details.

     C                   EXSR      ValidateTr2

      ** Validate Level 2 screen 2 details.

     C                   EXSR      ValidateTr3

      ** Perform the following only if no errors found in
      ** screen 1 details so as to avoid database errors
      ** in computations

     C                   IF        WFirstErr <> 'Y'

      ** Default Charges and Commission details on Level 2
      ** screen 3.

     C                   IF        CFT009 = 'N'
     C                   EXSR      ValCcyVat
     C                   EXSR      DefaultChrg
     C                   ENDIF

      ** Validate Level 2 screen 3 details.

     C                   EXSR      ValidateTr4
     C**********         ENDIF                                                               BUG6864

      ** Validate Margin Infomation sobroutine.

     C                   EXSR      ValidateMg
     C                   ENDIF                                                               BUG6864

     C                   ELSE

      ** Compute Charges and Commissions, and Total VAT Amounts
      ** based on Level 1 details if there are no errors

     C                   IF        WFirstErr <> 'Y' AND
     C                             CFT009 = 'N'
     C                   EXSR      ValCcyVat
     C                   ENDIF

     C                   ENDIF
                                                                                              CER001
     C                   IF        ULX043 = 'Y'                                               CER001
                                                                                              CER001
     C                   EVAL       #1FLD1 = *ZERO                                            CER001
     C                   EVAL       PREF1  = IPPREF                                           CER001
     C                   EVAL       #1FOTR = APFOTranId                                       CER001
     C                   EVAL       #1TMST = IPTMST                                           CER001
     C                   EVAL       #1ACBT = IPACBT                                           CER001
     C                   EVAL       #1ACBK = IPACBK                                           CER001
     C                   EVAL       #1BNC1 = IPBNC1                                           CER001
     C                   EVAL       #1PCCY = IPPCCY                                           CER001
     C                   EVAL       #1BNCT = IPBNCT                                           CER001
     C                   EVAL       #1SMAM = IPSMAM                                           CER001
     C                   EVAL       #1RCRT = IPRCRT                                           CER001
     C                   EVAL       #1RCCO = IPRCCO                                           CER001
     C                   EVAL       #1SNTP = IPSNTP                                           CER001
     C                   EVAL       #1SND1 = IPSND1                                           CER001
                                                                                              CER001
     C                   CALLB     'FTIPAY6VL'                                                CER001
     C                   PARM                    PActn                                        CER001
     C                   PARM                    PDATALUX                                     CER001
     C                   PARM                    RegData                                      CER001
     C                   PARM                    OKExtFlg                                     CER001
     C                   PARM                    FldNameArr                                   CER001
     C                   PARM                    MsgIDArr                                     CER001
     C                   PARM                    MsgDtaArr                                    CER001
     C                   PARM                    Idx                                          CER001
     C                   PARM                    WFldNamArr                                   CER001
     C                   PARM                    WMsgIDArr                                    CER001
     C                   PARM                    WMsgDtaArr                                   CER001
     C                   PARM                    WIdx                                         CER001
     C                   PARM                    IPAYValPmt                                   CER001
     C                   PARM                    WWCUTY                                       CER001
     C                   PARM                    @CUST                                        CER001
     C                   PARM                    IPAYExFilFmt                                 CER001
                                                                                              CER001
     C                   ENDIF                                                                CER001
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   IF        TranInIPY7 <> *BLANKS OR                                   CSW209
     C                             TranInIPY8 <> *BLANKS                                      CSW209
     C                   EXSR      ValidateTr7                                                CSW209
     C                   EXSR      ValidateTr8                                                CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209

     C     EValidTr      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateTr1 - Validate Level 1 screen details                *
      *                                                               *
      *****************************************************************

     C     ValidateTr1   BEGSR

     C                   CALLB     'FTIPAYIVL'
      *                             =========
      ** INPUT
      ** =====

     C                   PARM      '*FRONT'      PMode

      ** Response Mode (from caller: A=Asynchronous, S=Synchronous)
     C                   PARM                    PResponse

      ** SWIFT Reference
     C                   PARM                    DDSWTN

      ** Sequence Number
     C                   PARM                    DDSEQNO

      ** Booking Branch
     C                   PARM                    DDBRCA

      ** Action Code
     C                   PARM                    DDACTN

      ** OK Payment Reference
     C                   PARM                    OKPREF

      ** Linked Program
     C                   PARM                    PLinkPgm

      ** Incoming Payments retrieved from file - file format
     C                   PARM                    IPAYFilFmt

      ** Incoming Payments extra data
     C                   PARM                    ExtData
     C/COPY WNCPYSRC,FTH00363

      ** STANDING DATA
      ** =============

      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC

      ** SDMMOD - Multibranch Indicator
     C                   PARM                    BGMBIN

      ** ZMUSER - Default Branch
     C                   PARM                    PDBRN

      ** OUTPUT
      ** ======

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx

      ** OK Action Code
     C                   PARM                    OKACTN

      ** OK SWIFT Reference
     C                   PARM                    OKSWTN

      ** OK Sequence No.
     C                   PARM                    OKSEQNO

      ** OK Booking Branch
     C                   PARM                    OKBRCA

      ** Incoming Payments for file update - file format
     C                   PARM                    ValidIPAY

     C                   Z-add     BTPCRD        WBTPCRD

     C                   CALLB     'FTIPAY1VL'
      *                             =========
      ** INPUT
      ** =====

     C                   PARM      '*FRONT'      PMode

      ** Response Mode (from caller: A=Asynchronous, S=Synchronous)
     C                   PARM                    PResponse

      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format

     C                   PARM                    TranInIPY1
     C                   PARM                    TranInIP1A

      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction
      ** - screen format

     C                   PARM                    TranInIPY5

      ** Third Reimbursement Institution (previous)
     C                   PARM      *BLANKS       PPrvTRI

      ** Previous Instructed Amount
     C                   PARM      *BLANKS       PPrvNDAM

      ** Base Currency No. of Decimal Places
     C                   PARM                    PBCDP

      ** Payment Type
     C                   PARM                    PPYTP

      ** Incoming Payments Lvl 1 Scrn details retrieved from file
      ** - screen format
     C                   PARM                    CurTrIPY1

      ** Incoming Payments extra data
     C                   PARM                    ExtData

      ** STANDING DATA
      ** =============

      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD

      ** SDBANK - Midas Run Date
     C                   PARM                    PProcDte

      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY

      ** SDBANK - Location Code
     C                   PARM                    BJSLCD

      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC

      ** SDBANK - Back Value Period in Days
     C                   PARM                    BJBVPD

      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN

      ** SDGELR - Currency Code for Euro
     C                   PARM                    BKEURO

      ** SDGELR - Profit Centre Default Used
     C                   PARM                    BKPCDU

      ** SDGELR - Profit Centre Used
     C                   PARM                    BKPRCU

      ** SDGELR - Originating Branch Used
     C                   PARM                    BKOBRU

      ** SDGELR - Originating Branch/User Vald Req.
     C                   PARM                    BKOBUV

      ** SDMMOD - Retail Banking
     C                   PARM                    BGRTBN

      ** SDMMOD - Multibranch Indicator
     C                   PARM                    BGMBIN

      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST

      ** SDMMOD - Dealing Foreign Exchange
     C                   PARM                    BGDLFX

      ** SDMMOD - Dealing Money Market
     C                   PARM                    BGDLMM

      ** SDRETL - Retail A/c Number Required?
     C                   PARM                    BMRANR

      ** SDFTFR - Level Join indicator
     C                   PARM                    BTLVJN

      ** SDFTFR - Percent Rate Discrepancy
     C                   PARM                    WBTPCRD

      ** SDMMOD - Interest on Accrual
     C                   PARM                    BGIOAC

      ** ZMUSER - Department Code
     C                   PARM                    PDPPT

      ** ZMUSER - User Id
     C                   PARM                    PUSRID

      ** SDFTFR - Charges Currency
     C                   PARM                    BTCHCY

      ** SDFTFR - Fixed Charge Currency
     C                   PARM                    FCHCCY

      ** SDFTFR - Charges calculated in transaction ccy
     C                   PARM                    CHTRCY

      ** VAT Rate
     C                   PARM                    PVATR

      ** SWITCHABLE FEATURES
      ** ===================

      ** EMU FT Settlement Currency Conversion
     C                   PARM                    CEU006

      ** Electronic Banking Interface IATs and TPPs
     C                   PARM                    CGL009

      ** IBAN numbers
     C                   PARM                    CFT004

      ** STP Phase 2 MT103
     C                   PARM                    CFT014

      ** Fees & Charges
     C                   PARM                    CFT009
     C                   PARM                    CFT010

      ** BLI FT Enhancements Feature
     C                   PARM                    S01494
                                                                                              CGL014
      ** Collaterals Processing                                                               CGL014
                                                                                              CGL014
     C                   PARM                    CGL014                                       CGL014

      ** OUTPUT
      ** ======

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx

      ** Incoming Payments Lvl 1 Scrn error indicators
     C                   PARM                    OKTrIPY1

      ** Incoming Payments for file update - file format
     C                   PARM                    ValidIPAY

      ** Incoming Payments (additional details) for file update - file format
     C                   PARM                    ValidIPY2

      ** Charges Branch
     C                   PARM                    PPYBR

      ** Account with Bank's full account
     C                   PARM                    PACBDS

      ** Sender's full account
     C                   PARM                    PSNDDS

      ** Receiver Correspondence's full account
     C                   PARM                    PRCCDS
      *                                                                                     BUG15006
      ** Third Reimbursemnt Party  full account                                             BUG15006
     C                   PARM                    PTRBDS           24                        BUG15006

      ** Beneficiary's full account
     C                   PARM                    PBNCDS

      ** IBANs full account
     C                   PARM                    PIBANAcc

      ** Settlement In Currency Indicator
     C                   PARM                    PSetInCy

      ** Settlement EMU Transaction Period Start Date
     C                   PARM                    PSetTPSD

      ** Payment In Currency Indicator
     C                   PARM                    PPayInCy

      ** Payment EMU Transaction Period Start Date
     C                   PARM                    PPayTPSD

      ** DS for Default Charge Amounts
     C                   PARM                    PCharges

      ** Input Charge Currency
     C                   PARM                    PICCY

      ** Output Charge Currency
     C                   PARM                    POCCY

      ** Input Charge Currency No. of Decimal Places
     C                   PARM                    PINBDP

      ** Output Charge Currency No. of Decimal Places
     C                   PARM                    PONBDP

      ** Saved default charges
     C                   PARM                    DefValid
     C                   PARM                    DefValidX
     C                   PARM                    BENEDrBlck        1                        MD025111
     C                   PARM                    BENEDrRefd        1                       MD047369A
      *                                                                                       230309
      *  If DDBRCA was not *BLANKS prior to CALLB 'FTIPAY1VL then                             230309
      *  ignore the value held in IPBRCA, set in *MODULE FTVISNDR, and                        230309
      *  set IPBRCA to the User-entered value held in DDBRCA                                  230309
     C     DDBRCA        IFNE      *BLANKS                                                    230309
     C                   MOVEL     DDBRCA        IPBRCA                                       230309
     C                   ENDIF                                                                230309
      *                                                                                       230309
     C/COPY WNCPYSRC,FTIPAYV023

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValCcyVat - Compute Charges and Commissions, and Total VAT   *
      *              Amounts based on Level 1 details                 *
      *                                                               *
      *****************************************************************

     C     ValCcyVat     BEGSR

     C                   CALLB     'FTIPAY1CH'
      *                             =========
      ** INPUT
      ** =====

      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    TranInIPY1

      ** Incoming Payments retrieved from file - file format
     C                   PARM                    IPAYFilFmt

      ** Incoming Payments (extension) retrieved from file - file fmt
     C                   PARM                    IPY2FilFmt

      ** Incoming Payments (extension) for file update - file format
     C                   PARM                    ValidIPY2

      ** Charges Branch
     C                   PARM                    PPYBR

      ** Base Currency No. of Decimal Places
     C                   PARM                    PBCDP

      ** Local Currency No. of Decimal Places
     C                   PARM                    PLCDP

      ** Local Currency Multiply/Divide Indicator
     C                   PARM                    PLMDIN

      ** Local Currency Spot Rate
     C                   PARM                    PLSPOT

      ** Entry Point
     C                   PARM                    PParmLevel

      ** STANDING DATA
      ** =============

      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD

      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY

      ** SDFTFR - Charges Currency
     C                   PARM                    BTCHCY

      ** VAT Rate
     C                   PARM                    PVATR

      ** SWITCHABLE FEATURES
      ** ===================

      ** BLI FT Enhancements Feature
     C                   PARM                    S01494

      ** BLI VAT Processing Feature
     C                   PARM                    S01499

      ** BLI Payment Charges Enhancements
     C                   PARM                    S01506

      ** BLI Extended Payment Charges
     C                   PARM                    S01508

      ** FT Batch Authorization and Credit Advices
     C                   PARM                    CFT004

      ** STP Phase 2 MT103
     C                   PARM                    CFT014

      ** OUTPUT
      ** ======

      ** Incoming Payments for file update - file format
     C                   PARM                    ValidIPAY

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateTr2 - Validate Level 2 screen 1 details              *
      *                                                               *
      *****************************************************************

     C     ValidateTr2   BEGSR

      *                                                                                       255190
      ** Move saved PMTPY when IPINMTPY is blank (not selected from ME1100)                   255190
      ** Or error occurred from previous try (re-enter)                                       255190
      *                                                                                       255190
     C     IPINMTPY      IFEQ      ' '                                                        255190
     C                   MOVE      PMTPY         IPINMTPY                                     255190
     C                   ENDIF                                                                255190
      *                                                                                       255190
     C                   CALLB     'FTIPAY2VL'
      *                             =========
      ** INPUT
      ** =====

     C                   PARM      '*FRONT'      PMode

      ** Response Mode (from caller: A=Asynchronous, S=Synchronous)
     C                   PARM                    PResponse

      ** Incoming Payments Lvl 1 Scrn format definition file 2
     C                   PARM                    TranInIP1A

      ** Incoming Payments Lvl 2 Scrn 1/1 details from incoming transaction
      ** - screen format
     C                   PARM                    TranInIPY2

      ** Incoming Payments Lvl 2 Scrn 1/2 details from incoming transaction
      ** - screen format
     C                   PARM                    TranInIPY3

      ** Incoming Payments extra data
     C                   PARM                    ExtData

      ** Charges Branch
     C                   PARM                    PPYBR

      ** STANDING DATA
      ** =============

      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD

      ** SDBANK - Midas Run Date
     C                   PARM                    PProcDte

      ** SDBANK - Back Value Period in Days
     C                   PARM                    BJBVPD

      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC

      ** SDMMOD - Multibranch Indicator
     C                   PARM                    BGMBIN

      ** SDMMOD - Retail Banking
     C                   PARM                    BGRTBN

      ** SDRETL - Retail A/c Number Required?
     C                   PARM                    BMRANR

      ** MT103 Messages Generation for FT
     C                   PARM                    CFT014
      *                                                                                     BUG15006
      ** Debit Account                                                                      BUG15006
     C                   PARM                    PDBACT           24                        BUG15006
      *                                                                                     BUG15006
      ** Credit Account                                                                     BUG15006
     C                   PARM                    PCDACT           24                        BUG15006
      *                                                                                     BUG15006
      ** Network                                                                            BUG15006
     C                   PARM                    PNWRK             6                        BUG15006

      ** OUTPUT
      ** ======

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx

      ** Incoming Payments Lvl 2 Scrn 1 error indicators
     C                   PARM                    OKTrIPY2

      ** Incoming Payments for file update - file format
     C                   PARM                    ValidIPAY

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DefaultChrg - Defaulting of Charges and Commission details   *
      *                                                               *
      *****************************************************************
      *
     C     DefaultChrg   BEGSR
      *
     C                   CALLB     'FTIPAY3DT'
      *                             =========
      ** INPUT
      ** =====

      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    TranInIPY1

      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction
      ** - screen format
     C                   PARM                    TranInIPY5

      ** Incoming Payments (additional info) for file update
      ** - file format
     C                   PARM                    ValidIPY2

      ** Incoming Payments retrieved from file - file format
     C                   PARM                    IPAYFilFmt

      ** Payment Type
     C                   PARM                    PPYTP

      ** Charges Branch
     C                   PARM                    PPYBR

     C                   PARM      '*FRONT'      PMode

      ** Previous values of 'Charges to the Debit of a/c'

     C                   PARM                    PPrvCDRT
     C                   PARM                    PPrvCDRO
     C                   PARM                    PPrvCDBR
     C                   PARM                    PPrvCDRC                                     CFT120

      ** Recalcution flag.

     C                   PARM                    PReCalc

      ** STANDING DATA
      ** =============

      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD

      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY

      ** SDFTFR - Charges Currency
     C                   PARM                    BTCHCY

      ** VAT Default Flag
     C                   PARM                    PVATT

      ** VAT Rate
     C                   PARM                    PVATR

      ** SWITCHABLE FEATURES
      ** ===================

      ** BLI FT Enhancements Feature
     C                   PARM                    S01494

      ** BLI VAT Processing Feature
     C                   PARM                    S01499

      ** BLI Payment Charges Enhancements
     C                   PARM                    S01506

      ** BLI Extended Payment Charges
     C                   PARM                    S01508

      ** FT Batch Authorization and Credit Advices
     C                   PARM                    CFT004

      ** MT103 Messages Generation for FT
     C                   PARM                    CFT014
      *                                                                                       CFT120
      ** FT IN/OP - Charges on DR of Account Ccy                                              CFT120
      *                                                                                       CFT120
     C                   PARM                    CFT120                                       CFT120

      ** OUTPUT
      ** ======

      ** Input Charge Currency
     C                   PARM                    PICCY

      ** Input Charge Currency In Currency Flag
     C                   PARM                    PIINCY

      ** Input Charge Currency No. of Decimal Places
     C                   PARM                    PINBDP

      ** Input Charge Currency EMU Transmission Period Start Date
     C                   PARM                    PITPSD

      ** Output Charge Currency
     C                   PARM                    POCCY

      ** Output Charge Currency In Currency Flag
     C                   PARM                    POINCY

      ** Output Charge Currency No. of Decimal Places
     C                   PARM                    PONBDP

      ** DS for Default Charge Amounts
     C                   PARM                    PCharges

      ** DS for Default Charge Currencies
     C                   PARM                    PChgCcy

      ** Incoming Payments for file update - file format
     C                   PARM                    ValidIPAY

     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateTr3 - Validate Level 2 screen 2 details              *
      *                                                               *
      *****************************************************************

     C     ValidateTr3   BEGSR

     C                   CALLB     'FTIPAY3VL'
      *                             =========
      ** INPUT
      ** =====

     C                   PARM      '*FRONT'      PMode

      ** Response Mode (from caller: A=Asynchronous, S=Synchronous)
     C                   PARM                    PResponse

      ** Incoming Payments Lvl 2 Scrn 2 details from incoming transaction
      ** - screen format
     C                   PARM                    TranInIPY4

      ** Incoming Payments Lvl 2 Scrn 2 file 2 from incoming transaction
      ** - screen format
     C                   PARM                    TranInIP4A

      ** Settlement In Currency Indicator
     C                   PARM                    PSetInCy

      ** Settlement EMU Transaction Period Start Date
     C                   PARM                    PSetTPSD

      ** Payment In Currency Indicator
     C                   PARM                    PPayInCy

      ** Payment EMU Transaction Period Start Date
     C                   PARM                    PPayTPSD

      ** Input Charge Currency
     C                   PARM                    PICCY

      ** Input Charge Currency No. of Decimal Places
     C                   PARM                    PINBDP

      ** Output Charge Currency
     C                   PARM                    POCCY

      ** Output Charge Currency No. of Decimal Places
     C                   PARM                    PONBDP

      ** Incoming Payments extra data
     C                   PARM                    ExtData

      ** Charges Branch
     C                   PARM                    PPYBR

      ** STANDING DATA
      ** =============

      ** SDGELR - Currency Code for Euro
     C                   PARM                    BKEURO

      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST

      ** VAT Default Flag
     C                   PARM                    PVATT

      ** VAT Rate
     C                   PARM                    PVATR

      ** SWITCHABLE FEATURES
      ** ===================

      ** EMU FT Settlement Currency Conversion
     C                   PARM                    CEU006

      ** BLI FT Enhancements Feature
     C                   PARM                    S01494

      ** BLI VAT Processing Feature
     C                   PARM                    S01499

      ** MT103 Messages Generation for FT
     C                   PARM                    CFT014

      ** Fees & Charges
     C                   PARM                    CFT009

      ** OUTPUT
      ** ======

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx

      ** Incoming Payments Lvl 2 Scrn 2 error indicators
     C                   PARM                    OKTrIPY3

      ** Incoming Payments for file update - file format
     C                   PARM                    ValidIPAY

      ** Incoming Payments (additional details) for file update
     C                   PARM                    ValidIPY2

      ***DS*for*Default*Charge*Amounts*********************************                       222373
     C*****              PARM                    PCharges                                     222373
      *****                                                                                   222373
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateTr4 - Validate Level 2 screen 3 details              *
      *                                                               *
      *****************************************************************

     C     ValidateTr4   BEGSR
      *                                                                                       CFT120
      ** Check if new value entered for Charges to the debit of                               CFT120
      *                                                                                       CFT120
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   IF        PrvDDCDRO <> DDCDRO                                        CFT120
     C                             OR  PrvDDCDRC <> DDCDRC                                    CFT120
     C                             OR  DDACTN = 'I'                                           CFT120
     C                   EVAL      PCDROCHG = 'Y'                                             CFT120
     C                   ELSE                                                                 CFT120
     C                   EVAL      PCDROCHG = *BLANKS                                         CFT120
     C                   ENDIF                                                                CFT120
     C                   ENDIF                                                                CFT120

     C                   CALLB     'FTIPAY4VL'
      *                             =========
      ** INPUT
      ** =====

     C                   PARM      '*FRONT'      PMode

      ** Response Mode (from caller: A=Asynchronous, S=Synchronous)
     C                   PARM                    PResponse

      ** Incoming Payments Lvl 1 details
     C                   PARM                    TranInIPY1

      ** Incoming Payments Lvl 2 Scrn 2 details from incoming transaction
      ** - screen format
     C                   PARM                    TranInIPY5

      ** Settlement In Currency Indicator
     C                   PARM                    PSetInCy

      ** Settlement EMU Transaction Period Start Date
     C                   PARM                    PSetTPSD

      ** Payment In Currency Indicator
     C                   PARM                    PPayInCy

      ** Payment EMU Transaction Period Start Date
     C                   PARM                    PPayTPSD

      ** Input Charge Currency
     C                   PARM                    PICCY

      ** Input Charge Currency No. of Decimal Places
     C                   PARM                    PINBDP

      ** Output Charge Currency
     C                   PARM                    POCCY

      ** Output Charge Currency No. of Decimal Places
     C                   PARM                    PONBDP

      ** Saved default charges
     C                   PARM                    DefValid
     C                   PARM                    DefValidx

      ** STANDING DATA
      ** =============

      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD

      ** SDBANK - Midas Run Date
     C                   PARM                    PPROCDTE

      ** SDBANK - Back Value Period in Days
     C                   PARM                    BJBVPD

      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC

      ** SDBANK - Local currency code
     C                   PARM                    BJLCCY

      ** SDMMOD - Multibranch Indicator
     C                   PARM                    BGMBIN

      ** SDMMOD - Retail Banking
     C                   PARM                    BGRTBN

      ** SDRETL - Retail A/c Number Required?
     C                   PARM                    BMRANR

      ** SDGELR - Currency Code for Euro
     C                   PARM                    BKEURO

      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST

      ** VAT Default Flag
     C                   PARM                    PVATT

      ** VAT Rate
     C                   PARM                    PVATR

      ** SDFTFR - Charges calculated in transaction ccy
     C                   PARM                    CHTRCY

      ** SDFTFR - Charges currency indicator
     C                   PARM                    BTCHCY

      ** SDFTFR - Fixed charge currency
     C                   PARM                    FCHCCY

      ** SWITCHABLE FEATURES
      ** ===================

      ** EMU FT Settlement Currency Conversion
     C                   PARM                    CEU006

      ** BLI FT Enhancements Feature
     C                   PARM                    S01494

      ** BLI VAT Processing Feature
     C                   PARM                    S01499

      ** MT103 Messages Generation for FT
     C                   PARM                    CFT014

      ** Fees & Charges
     C                   PARM                    CFT009
     C                   PARM                    CFT010
      *                                                                                       CFT120
      ** FT IN/OP - Charges on DR of Account Ccy                                              CFT120
      *                                                                                       CFT120
     C                   PARM                    CFT120                                       CFT120

      ** OUTPUT
      ** ======

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx

      ** Incoming Payments Lvl 2 Scrn 3 error indicators
     C                   PARM                    OKTrIPY4

      ** Incoming Payments for file update - file format
     C                   PARM                    ValidIPAY

      ** Incoming Payments (extension) for file update - file format
     C                   PARM                    ValidIPY2

      ** DS for Default Charge Amounts
     C                   PARM                    PCharges

      ** Force redisplay
     C                   PARM                    PFrcReDisplay

      ** I/O: Previous Receiver's charges remitted input
      **      Its value is maintained in FTVIRCRM
     C                   PARM                    PPrvDDRCRM

      ** I/O: Previous Total charges calculated
      **      Its value is maintained in FTVIRCRM
     C                   PARM                    PPrvTotChg

      ** Charges to the debit of - field changed (Y or blank)
     C                   PARM                    PCDROChg

      ** Previous warning messages array
     C                   PARM                    WPrvWarnAr

      ** Warning message work inds for charges screen
     C                   PARM                    PChgWarn
     C                   PARM                    BENEDrBlck                                 MD025111
     C                   PARM                    BENEDrRefd                                MD047369A

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  ValidateMg - Validate Margin Information details             *
      *                                                               *
      *****************************************************************

     C     ValidateMg    BEGSR

     C                   CALLB     'FTIPAY5VL'
      *                             =========
      ** INPUT
      ** =====

     C                   PARM      '*FRONT'      PMode

      ** Response Mode (from caller: A=Asynchronous, S=Synchronous)
     C                   PARM                    PResponse

      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
      ** - screen format
     C                   PARM                    TranInIPY1

      ** Incoming Payments Margin info from incoming transaction
      ** - screen format
     C                   PARM                    TranInIPY6
      *                                                                                       CER030
      ** Incoming Payments Extended Narratives incoming transaction                           CER030
      ** - screen format                                                                      CER030
      *                                                                                       CER030
     C                   PARM                    TranInIP6A                                   CER030
      *                                                                                       CER030
      ** Incoming Payments Transaction Code from screen 2 level 2 for                         CER030
      ** defaulting value of Retail Transaction Type                                          CER030
      *                                                                                       CER030
     C                   PARM                    DDTTCD                                       CER030

      ** STANDING DATA
      ** =============

      ** SDMMOD - Analytical Accounting
     C                   PARM                    BGN0ST

      ** OUTPUT
      ** ======

      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    Idx

      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr

      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx

      ** Incoming Payments Margin info error indicators
     C                   PARM                    OKTrIPY5

      ** Incoming Payments for file update - file format
     C                   PARM                    ValidIPAY
      *                                                                                       CER030
      ** Extension Valid File Value for Transaction code                                      CER030
      *                                                                                       CER030
     C                   PARM                    I2INTTCD                                     CER030

     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      *  ValidateTr7 - Validate input to Level 2 screen 7             *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
      *                                                                                       CSW209
     C     ValidateTr7   BEGSR                                                                CSW209
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
     C                   PARM                    ValidIPAY                                    CSW209
     C                   PARM                    TranInIPY2                                   CSW209
     C                   PARM                    TranInIPY4                                   CSW209
     C                   PARM                    TranInIPY7                                   CSW209
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
     C                   PARM                    OKTrIPY7                                     CSW209
      *                                                                                       CSW209
      ** Incoming Payments (additional details) for file update                               CSW209
     C                   PARM                    ValidIPY2                                    CSW209
      *                                                                                       CSW209
     C                   ENDSR                                                                CSW209
      *                                                                                       CSW209
      *****************************************************************                       CSW209
      /EJECT                                                                                  CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      *  ValidateTr8 - Validate input to Level 2 screen 8             *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
      *                                                                                       CSW209
     C     ValidateTr8   BEGSR                                                                CSW209
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
     C                   PARM                    TranInIPY7                                   CSW209
     C                   PARM                    TranInIPY8                                   CSW209
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
     C                   PARM                    OKTrIPY8                                     CSW209
      *                                                                                       CSW209
      ** Incoming Payments (additional details) for file update                               CSW209
     C                   PARM                    ValidIPY2                                    CSW209
      *                                                                                       CSW209
     C                   ENDSR                                                                CSW209
      *                                                                                       CSW209
      *****************************************************************                       CSW209
      /EJECT
      *****************************************************************
      *                                                               *
      *  ResetCycle - Reset error information that is gradually       *
      *               updated during each run of this program         *
      *                                                               *
      *****************************************************************

     C     ResetCycle    BEGSR

     C                   RESET                   FldNameArr
     C                   RESET                   MsgIDArr
     C                   RESET                   MsgDtaArr
     C                   RESET                   Idx

     C                   RESET                   WFldNamArr
     C                   RESET                   WMsgIDArr
     C                   RESET                   WMsgDtaArr
     C                   RESET                   WIdx

     C                   RESET                   AmFldNamAr
     C                   RESET                   AmMsgIDArr
     C                   RESET                   AmMsgDtaAr
     C                   RESET                   AmIdx


     C                   RESET                   FldNoArr

     C                   CLEAR                   CurTrIPY1
     C                   CLEAR                   CurTrIP1A
     C                   CLEAR                   CurTrIPY2
     C                   CLEAR                   CurTrIPY3
     C                   CLEAR                   CurTrIPY4
     C                   CLEAR                   CurTrIP4A
     C                   CLEAR                   CurTrIPY5
     C                   CLEAR                   CurTrIPY6
     C                   CLEAR                   CurTrIP6A                                    CER030
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   CLEAR                   CurTrIPY7                                    CSW209
     C                   CLEAR                   CurTrIPY8                                    CSW209
     C                   ENDIF                                                                CSW209

     C                   MOVE      *ALL'Y'       OKTrIPY1
     C                   MOVE      *ALL'Y'       OKTrIPY2
     C                   MOVE      *ALL'Y'       OKTrIPY3
     C                   MOVE      *ALL'Y'       OKTrIPY4
     C                   MOVE      *ALL'Y'       OKTrIPY5
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   MOVE      *ALL'Y'       OKTrIPY7                                     CSW209
     C                   MOVE      *ALL'Y'       OKTrIPY8                                     CSW209
     C                   ENDIF                                                                CSW209

     C                   CLEAR                   ValidIPAY
     C                   CLEAR                   ValidIPY2

     C                   MOVE      *BLANKS       PStatus
     C                   MOVE      'IN'          PPYTP
                                                                                             CSF011A
      **Initialise Customer Name on input fields                                             CSF011A
                                                                                             CSF011A
     C                   EVAL      DDSNSN  = *BLANKS                                         CSF011A
     C                   EVAL      DDSNNM  = *BLANKS                                         CSF011A
     C                   EVAL      DDSNTN  = *BLANKS                                         CSF011A
     C                   EVAL      DDSNAN  = *BLANKS                                         CSF011A
     C                   EVAL      DDSNSW  = *BLANKS                                         CSF011A
     C                   EVAL      DDRCSN  = *BLANKS                                         CSF011A
     C                   EVAL      DDRCNM  = *BLANKS                                         CSF011A
     C                   EVAL      DDRCTN  = *BLANKS                                         CSF011A
     C                   EVAL      DDRCAN  = *BLANKS                                         CSF011A
     C                   EVAL      DDRCSW  = *BLANKS                                         CSF011A
     C                   EVAL      DDBNSN  = *BLANKS                                         CSF011A
     C                   EVAL      DDBNNM  = *BLANKS                                         CSF011A
     C                   EVAL      DDBNTN  = *BLANKS                                         CSF011A
     C                   EVAL      DDBNAN  = *BLANKS                                         CSF011A
     C                   EVAL      DDBNSW  = *BLANKS                                         CSF011A
     C                   EVAL      DDTRSN  = *BLANKS                                         CSF011A
     C                   EVAL      DDTRNM  = *BLANKS                                         CSF011A
     C                   EVAL      DDTRTN  = *BLANKS                                         CSF011A
     C                   EVAL      DDTRAN  = *BLANKS                                         CSF011A
     C                   EVAL      DDTRSW  = *BLANKS                                         CSF011A
     C                   EVAL      DDABSN  = *BLANKS                                         CSF011A
     C                   EVAL      DDABNM  = *BLANKS                                         CSF011A
     C                   EVAL      DDABTN  = *BLANKS                                         CSF011A
     C                   EVAL      DDABAN  = *BLANKS                                         CSF011A
     C                   EVAL      DDABSW  = *BLANKS                                         CSF011A
     C                   EVAL      DDOBSN  = *BLANKS                                         CSF011A
     C                   EVAL      DDOBNM  = *BLANKS                                         CSF011A
     C                   EVAL      DDOBTN  = *BLANKS                                         CSF011A
     C                   EVAL      DDOBSW  = *BLANKS                                         CSF011A
     C                   EVAL      DDOCSN  = *BLANKS                                         CSF011A
     C                   EVAL      DDOCNM  = *BLANKS                                         CSF011A
     C                   EVAL      DDOCTN  = *BLANKS                                         CSF011A
     C                   EVAL      DDOCAN  = *BLANKS                                         CSF011A
     C                   EVAL      DDOCSW  = *BLANKS                                         CSF011A
     C                   EVAL      DDSCSN  = *BLANKS                                         CSF011A
     C                   EVAL      DDSCNM  = *BLANKS                                         CSF011A
     C                   EVAL      DDSCTN  = *BLANKS                                         CSF011A
     C                   EVAL      DDSCSW  = *BLANKS                                         CSF011A
     C                   EVAL      DDIBSN  = *BLANKS                                         CSF011A
     C                   EVAL      DDIBNM  = *BLANKS                                         CSF011A
     C                   EVAL      DDIBTN  = *BLANKS                                         CSF011A
     C                   EVAL      DDIBSW  = *BLANKS                                         CSF011A
     C                   EVAL      DDCDSN  = *BLANKS                                         CSF011A
     C                   EVAL      DDCDNM  = *BLANKS                                         CSF011A
     C                   EVAL      DDCDTN  = *BLANKS                                         CSF011A
     C                   EVAL      DDCDAN  = *BLANKS                                         CSF011A
     C                   EVAL      DDCDSW  = *BLANKS                                         CSF011A

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SetUpValid - Set up additional fields that are needed on the *
      *               valid file record.                              *
      *                                                               *
      *****************************************************************

     C     SetUpValid    BEGSR

      ** INSERT
      ** ======
     C                   IF        DDACTN = 'I'

      ** Update Incoming Payments data area with next
      ** Sequence Number.

     C                   IF        CFT151 = 'N'                                               CFT151
     C     *DTAARA       DEFINE    INPAYDA       WINPAY
     C     *LOCK         IN        WINPAY
     C                   Z-ADD     WINSQ         WWInsQ
                                                                                              CSC024
      ***Suppress*new*payment*reference*generation*if*CSC024*is                        CSC024 CSC054
      ***switched*on*and*this*is*running*on*OME*system.                                CSC024 CSC054
      ** Suppress new payment reference generation if CSC054 is                               CSC054
      ** switched on and this is running on PEA system.                                       CSC054
                                                                                              CSC024
     C                   IF        GENPREF = 'Y'                                              CSC024
     C                             OR DDPREF = *BLANKS                                        CSC024
     C                   ADD       1             WInsQ
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C                   OUT       WINPAY
                                                                                              CFT151
     C                   ELSE                                                                 CFT151
                                                                                              CFT151
     C                   IF        GENPREF = 'Y'                                              CFT151
     C                             OR DDPREF = *BLANKS                                        CFT151
     C                   CALL      'FT000328'                                                 CFT151
     C                   PARM                    PRTCD                                        CFT151
     C                   PARM      'IN'          W@OTIN            2                          CFT151
     C                   PARM      'A'           WCALC             1                          CFT151
     C                   PARM      'Y'           WUPD              1                          CFT151
     C                   PARM                    WWINSQT           4                          CFT151
     C                   PARM                    WNEWSQ            4                          CFT151
                                                                                              CFT151
     C                   ENDIF                                                                CFT151
                                                                                              CFT151
     C                   ENDIF                                                                CFT151

      ** Record Id.

     C                   MOVEL     'D'           IPRECI

      ** Payment Type.

     C                   EVAL      IPPYTP = 'IN'

      ** Original Entry Dates.

     C                   Z-ADD     BJRDNB        PDayNo

     C                   CALLB     'ZDATE2'
     C                   PARM                    PDayNo
     C                   PARM      BJDFIN        PFMT
     C                   PARM      *ZERO         PDate
     C                   PARM      *BLANKS       PADate

     C                   Z-ADD     BJRDNB        IPOEDT
     C                   Z-ADD     PDate         IPOEDTD1

     C                   MOVE      PDate         WN2
     C     WN2           IFLT      72
     C                   Z-ADD     20            IPOEDTD2
     C                   ELSE
     C                   Z-ADD     19            IPOEDTD2
     C                   ENDIF

     C                   MOVEL     PDate         WA4
     C     BJDFIN        IFNE      'M'
     C                   MOVEL     WA4           WA2
     C                   MOVE      WA4           WA2A
     C                   MOVEL     WA2A          WA4
     C                   MOVE      WA2           WA4
     C                   ENDIF

     C                   MOVE      PDate         WA2
     C                   MOVEL     WA2           PDate
     C                   MOVE      WA4           PDate
     C                   Z-ADD     PDate         IPOEDTD3

      ** New Payment Reference.

     C                   IF        CSC011 = 'Y' AND LIBR = S1SUPP

     C                   Z-ADD     WPRDTE        PDAYNO
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDAYNO
     C                   PARM      BJDFIN        PFMT
     C                   PARM      *ZERO         PPRDATE
     C                   PARM      *BLANKS       PPRADATE

     C                   MOVEL     PPRDATE       WA4
     C     BJDFIN        IFNE      'M'
     C                   MOVEL     WA4           WA2
     C                   MOVE      WA4           WA2A
     C                   MOVEL     WA2A          WA4
     C                   MOVE      WA2           WA4
     C                   ENDIF

     C                   MOVE      PPRDATE       WA2
     C                   MOVEL     WA2           PPRDATE
     C                   MOVE      WA4           PPRDATE
     C                   MOVE      PPRDATE       WA6
     C                   ELSE
     C                   MOVE      PDate         WA6
     C                   ENDIF
     C                   IF        CFT151 = 'N'                                               CFT151
     C                   MOVE      WWInsQ        WA4
     C                   ELSE                                                                 CFT151
     C                   MOVE      WWINSQT       WA4                                          CFT151
     C                   END                                                                  CFT151
     C                   MOVE      'P'           WYA1(1)
     C                   MOVEA     WA6           WYA1(2)
     C                   MOVEA     WA4           WYA1(8)
     C                   MOVEA     IPPYTP        WYA1(12)
     C                   MOVEA     '00'          WYA1(14)

     C     1             DO        15            IA
     C                   IF        WYA1(IA) = ' '
     C                   MOVEL     '0'           WYA1(IA)
     C                   ENDIF
     C                   ENDDO

     C                   IF        GENPREF = 'Y'                                              CSC024
     C                             OR DDPREF = *BLANKS                                        CSC024
     C                   MOVEA     WYA1(1)       IPPREF
     C                   ELSE                                                                 CSC024
     C                   EVAL      IPPREF = DDPREF                                            CSC024
     C                   ENDIF                                                                CSC024

      ** Level 1 Valid Indicator.

     C                   EVAL      IPINLVL1 = 'Y'

     C                   ENDIF

      ** INSERT OR AMEND
      ** ===============

     C                   IF        DDACTN = 'I' or
     C                             DDACTN = 'A'

      ** Input Officer 1.

     C**********         EVAL      IPINUSR1 = PSUser                                         BUG1493
     C**********         EVAL      IPINUSR1 = PUSRID                                BUG1493 MD042042
     C                   EVAL      IPINUSR1 = InputUser                                     MD042042

      ** Level 2 details have been processed.

     C                   IF        WLVL2 = 'Y'

      ** Input Officer 2.
     C**********         EVAL      IPINUSR2 = PSUser                                         BUG1493
     C**********         EVAL      IPINUSR2 = PUSRID                                BUG1493 MD042042
     C                   EVAL      IPINUSR2 = InputUser                                     MD042042
      ** Level 2 Valid Indicator.
     C                   EVAL      IPINLVL2 = 'Y'

     C                   ENDIF

     C                   ENDIF

      ** DELETE
      ** ======

     C                   IF        DDACTN = 'D'
     C                             or (DDACTN = 'S' AND CFT157 = 'Y')                         CFT157

      ** Move Incoming Payment details retrieved from file
      ** directly to the Valid Record data structure.

     C                   MOVEL     IPAYFilFmt    ValidIPAY
     C                   IF        CFT003 = 'Y' or CFT014 = 'Y'
     C                             OR CFT009 = 'Y'
     C                   MOVEL     IPY2FilFmt    ValidIPY2
     C                   ELSE                                                                BUG7101
     C                   CLEAR                   ValidIPY2                                   BUG7101
     C                   ENDIF

      ** Record Id - update to 'C'.

     C                   EVAL      IPRECI = 'C'
      *
     C                   ENDIF

      ** Enquire.

     C                   IF        DDACTN = 'E'

      ** Move Incoming Payment details retrieved from file
      ** directly to the Valid Record data structure.

     C                   MOVEL     IPAYFilFmt    ValidIPAY
     C                   IF        CFT003 = 'Y' or CFT014 = 'Y'
     C                             OR CFT009 = 'Y'
     C                   MOVEL     IPY2FilFmt    ValidIPY2
     C                   ELSE                                                                BUG7101
     C                   CLEAR                   ValidIPY2                                   BUG7101
     C                   ENDIF

     C                   ENDIF

      ** STOP                                                                                 CFT157
      ** ====                                                                                 CFT157
                                                                                              CFT157
     C                   IF        DDACTN = 'S' AND CFT157 = 'Y'                              CFT157
     C                   IF        AAUTH = 'Y'                                                CFT157
     C                   EVAL      IPSUSR = PUSRID                                            CFT157
     C                   ELSE                                                                 CFT157
     C                   EVAL      IPSUSR = DDSUSR                                            CFT157
     C                   EVAL      IPSAUS = PUSRID                                            CFT157
     C                   ENDIF                                                                CFT157
     C                   ENDIF                                                                CFT157
                                                                                              CFT157
      ** Last Change Type, Date and Time.

     C                   MOVEL     DDACTN        IPCHTP
     C                   Z-ADD     BJRDNB        IPLCD
     C                   TIME                    IPLCHT

      ** Message Header details.

     C                   IF        APFOTRANID <> *Blanks                                    MD032077
     C                   EVAL      IPFRNT = APFOTRANID
     C                   EVAL      IPREPA = APRPRLOCN
     C                   ENDIF                                                              MD032077

      ** Set up the following fields for update of FTVIPY2PD

     C                   IF        CFT003 = 'Y' OR
     C                             CFT014 = 'Y' OR
     C                             CFT009 = 'Y'

     C/COPY WNCPYSRC,FTH00416
     C                   EVAL      I2INAUTO = 'N'
     C/COPY WNCPYSRC,FTH00417

     C                   IF        DDACTN = 'I' OR
     C                             DDACTN = 'A' OR
     C                             DDACTN = 'D'
     C                             or (DDACTN = 'S' AND CFT157 = 'Y')                         CFT157

     C                   IF        DDACTN = 'I'
     C                   EVAL      I2INRECI = 'D'
     C                   EVAL      I2INPREF = IPPREF
     C                   EVAL      I2INFRNT = IPFRNT
     C                   ENDIF

     C                   EVAL      I2INTMST = IPTMST
     C                   ENDIF

     C                   ENDIF

      /COPY WNCPYSRC,FTIPAYV017
                                                                                             BUG4196
      * Restore Timestamp from the original record                                           BUG4196
     C                   IF        DDACTN <> 'I'                                             BUG4196
     C                             AND @TimeStamp <> *BLANKS                                 BUG4728
     C                   MOVEL     @TimeStamp    IPTMST                                      BUG4196
     C                   ENDIF                                                               BUG4196

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  UpdateDB - Update database                                   *
      *                                                               *
      *****************************************************************

     C     UpdateDB      BEGSR

      ** Update files.

     C                   CALLB     'FTIPAYUPD'
      *                             =========
      ** INPUT
      ** =====

      ** Return Code
     C                   PARM      *BLANKS       RetCodeOut

      ** Incoming Payments for file update - file format
     C                   PARM                    ValidIPAY

      ** Incoming Payments (additional details) for file update
     C                   PARM                    ValidIPY2

      ** IBANs full account
     C                   PARM                    PIBANAcc

      ** Originally Insert from Level 2 Entry
     C                   PARM      *BLANK        POrigActn

      ** FT Override for GL Balances
     C                   PARM                    PFTOV

      ** FT Control Data
     C                   PARM                    PCNTRL

      ** Network
     C                   PARM                    PNWRK

      ** Entry Point
     C                   PARM                    PParmLevel

      ** STANDING DATA
      ** =============

      ** SDBANK - Base Currency Code
     C                   PARM                    BJCYCD

      ** SDBANK - Midas Run Date
     C                   PARM                    BJRDNB

      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC

      ** SDGELR - Originating Branch/User Vald Req.
     C                   PARM                    BKOBUV

      ** ZMUSER - Default Branch
     C                   PARM                    PDBRN

      ** SWITCHABLE FEATURES
      ** ===================

      ** Batch Authorisation
     C                   PARM                    CFT003

      ** IBAN numbers
     C                   PARM                    CFT004

      ** BLI FT Enhancements Feature
     C                   PARM                    S01494

      ** BLI VAT Processing Feature
     C                   PARM                    S01499

      ** STP Phase 2 MT103
     C                   PARM                    CFT014

      ** Fees & Charges
     C                   PARM                    CFT009
     C                   PARM                    CFT010

      ** 24 X 7
     C                   PARM                    CSC011
     C                   PARM                    CSD015
     C                   PARM                    CCF001
      *                                                                                       CAP211
     C                   PARM                    AAuth                                        CAP211
     C                   PARM                    APUSERID                                     CAP211

      /COPY WNCPYSRC,FTIPAYV018

      ** If errors occurred on update, rollback uncommitted file
      ** changes.

     C                   IF        RetCodeOut <> *BLANKS and
     C                             RetCodeOut <> '*RECUPD'
     C                   MOVEL     '0'           APIRetc
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
     C                   EVAL      DDPREF = IPPREF
     C                   ENDIF
      *                                                                                     BUG13159
      ** Update @TimeStamp with IPTMST of ValidIPAY, if the Update/Write was a success      BUG13159
      *                                                                                     BUG13159
     C                   MOVE      IPTMST        @TimeStamp                                 BUG13159
      *                                                                                     BUG13159
     C                   ENDIF

      ** If update not done due to record being updated by another
      ** workstation, display message "The last transaction was not
      ** applied to the database." to the next screen.

     C                   IF        RetCodeOut <> *BLANKS
     C                   Z-ADD     1             Idx
     C                   EVAL      FldNameArr(Idx) = '*ANY'
     C                   EVAL      MsgIdArr(Idx) = 'FTA0120'
     C                   ENDIF

     C                   IF        ULX043 = 'Y'                                               CER001
                                                                                              CER001
     C                   EVAL      #LLXIPPREF = IPPREF                                        CER001
                                                                                              CER001
     C                   CALLB     'FTIPAY2UP'                                                CER001
     C                   PARM                    PActn                                        CER001
     C                   PARM      *BLANKS       PRetCodeIn                                   CER001
     C                   PARM                    WFIND                                        CER001
     C                   PARM                    IPAYValPmt                                   CER001
     C                   PARM                    IPAYExFilFmt                                 CER001
                                                                                              CER001
     C                   ENDIF                                                                CER001
                                                                                              CER001
     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR

     C     *ENTRY        PLIST

      ** Common header information (DS) from source system
     C                   PARM                    HeadIn

      ** Transaction information
     C**********         PARM                    Trans5001                                   CSF011A
     C                   PARM                    Trans01                                     CSF011A
     C                   PARM                    Trans5002
     C**********         PARM                    Trans5003                                   CSF011A
     C                   PARM                    Trans03                                     CSF011A
     C                   PARM                    Trans5004
     C**********         PARM                    Trans5005                                   CSF011A
     C                   PARM                    Trans05                                     CSF011A
     C                   PARM                    Trans5006
     C                   PARM                    Trans5007
     C                   PARM                    Trans5008
     C                   PARM                    Trans5009                                    CSW209
     C                   PARM                    Trans5010                                    CSW209
     C**********         PARM                    Trans5009                             CER030 262664
     C                   PARM                    Trans5008A                                   262664
     C                   PARM                    Trans5011                                    CER049

      ** Extra Data
     C                   PARM                    RegData500                                   CER001
     C                   PARM                    ExtData500
     C                   PARM                    StopFTDta                                  MD050928

      ** Error fields/message IDs/message data (arrays) from/to caller

     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr

      ** Warning error fields/message IDs/message data (arrays)
      ** from/to caller

     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    MsgFArray

      ** Update Transaction
     C                   PARM                    UpdateYN

      ** Output Buffer
     C                   PARM                    Buffer

      ** API Return Code
     C                   PARM                    APIRetc
     C                   PARM                    @TimeStamp       26                         BUG4196
     C                   PARM                    NewButton         3                          255190
     C                   PARM                    AAuth             1                        BUG22146
     C                   PARM                    InputUser                                  MD042042

      * Set up the names of the message files from which the message handler
      * will get the messages
     C                   EVAL      MsgFArray(1) = 'FTUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'MEMSG'

      * Hook to enable non-core message files to be included
     D/COPY WNCPYSRC,FTIPAYM01

      ** Set up the name of the module Id used to make the transaction
      ** number unique.

     C                   EVAL      PModuleId = 'FT'

      ** Access Bank details.

     C                   CALLB     'AOBANKR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Access API ICD details.

     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDAPI         PARM      SDAPI         DSFDY

      ** Access General Ledger ICD details.

     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDGELR        PARM      SDGELR        DSSDY

      ** Access Midas Modules details.

     C                   CALLB     'AOMMODR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY

      ** Access Funds Transfer ICD details.

     C                   CALL      'AOFTFRR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDFTFR        PARM      SDFTFR        DSFDY

      ** Access Retail ICD details if Retail module is
      ** installed.

     C                   IF        BGRTBN = 'Y'

     C                   CALLB     'AORETLR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDRETL        PARM      SDRETL        DSFDY

     C                   ENDIF

      ** Access SAR file to determine if S01494
      ** (BLI FT Enhancements Feature) is installed.

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'S01494'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     'Y'           S01494
     C                   ELSE
     C                   MOVEL     'N'           S01494
     C                   ENDIF

      ** Access SAR file to determine if S01499 (BLI VAT Processing)
      ** is installed.

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'S01499'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     'Y'           S01499
     C                   ELSE
     C                   MOVEL     'N'           S01499
     C                   ENDIF

      ** Access SAR file to determine if S01506 (BLI Payment Charges
      ** Enhancements) is installed.

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'S01506'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     'Y'           S01506
     C                   ELSE
     C                   MOVEL     'N'           S01506
     C                   ENDIF

      ** Access SAR file to determine if S01508 (BLI Extended Payment
      ** Charges) is installed.

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'S01508'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     'Y'           S01508
     C                   ELSE
     C                   MOVEL     'N'           S01508
     C                   ENDIF

      ** Access SAR file to determine if CEU006 (EMU FT Settlement
      ** Currency Conversion) is installed.

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CEU006'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     'Y'           CEU006
     C                   ELSE
     C                   MOVEL     'N'           CEU006
     C                   ENDIF

      ** Access SAR file to determine if CGL009 (Electronic Banking
      ** Interface IATs and TPPs) is installed.

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CGL009'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     'Y'           CGL009
     C                   ELSE
     C                   MOVEL     'N'           CGL009
     C                   ENDIF

      ** Access SAR file to determine if CFT002 (Straight
      ** Through Processing Phase 1) is installed.

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CFT002'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY

     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CFT002
     C                   ELSE
     C                   MOVEL     'N'           CFT002
     C                   ENDIF

      ** Access SAR file to determine if CFT004 (IBAN
      ** numbers) is installed.

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CFT004'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     'Y'           CFT004
     C                   ELSE
     C                   MOVEL     'N'           CFT004
     C                   ENDIF

      ** Access SAR file to determine if CFT003 is installed

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CFT003'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     'Y'           CFT003
     C                   ELSE
     C                   MOVEL     'N'           CFT003
     C                   ENDIF

      ** Access SAR file to determine if CFT014 is installed

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CFT014'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     'Y'           CFT014
     C                   ELSE
     C                   MOVEL     'N'           CFT014
     C                   ENDIF

      ** Access SAR file to determine if CFT009 is installed

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CFT009'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     'Y'           CFT009
     C                   ELSE
     C                   MOVEL     'N'           CFT009
     C                   ENDIF

      ** Access SAR file to determine if CFT010 is installed

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CFT010'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     'Y'           CFT010
     C                   ELSE
     C                   MOVEL     'N'           CFT010
     C                   ENDIF

     C                   EVAL      PProcDte = BJRDNB

      ** Access SAR details file to see if 24X7 (CSC011) is installed.

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSC011'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

      ** If installed, get support system prefix and current system prefix and
      ** use processing date defined in SC24X7 dataarea when support system is active

     C                   IF        PRtCd = *BLANKS
     C                   EVAL      CSC011 = 'Y'
     C                   IN        SC24X7
     C                   IN        SDSTAT
     C                   IF        LIBR = S1SUPP
     C                   EVAL      PPROCDTE = WPRDTE
     C                   ENDIF
     C                   ELSE
     C                   EVAL      CSC011 = 'N'
     C                   ENDIF

      *                                                                                       CSW209
      ** Check if SWIFT 2009 feature is ON                                                    CSW209
      *                                                                                       CSW209
     C                   CALL      'SWIF2009'                                                 CSW209
     C                   PARM      *BLANKS       PRtCd                                        CSW209
      *                                                                                       CSW209
     C                   IF        PRtCd = 'CSW2009'                                          CSW209
     C                   EVAL      CSW209 = 'Y'                                               CSW209
     C                   ELSE                                                                 CSW209
     C                   EVAL      CSW209 = 'N'                                               CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Check if Compliance Watch Enhancement (CSD015) is installed

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSD015'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     'Y'           CSD015
     C                   ELSE
     C                   MOVEL     'N'           CSD015
     C                   ENDIF
                                                                                              CSD083
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALL      'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRTCD                                        CSD083
     C                   PARM      '*VERIFY'     POPTN                                        CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRTCD <> *BLANKS  AND                                      CSD083
     C                             PRTCD <> '*NRF'                                            CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBKey = 'CSD083'                                           CSD083
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBase = 33                                                 CSD083
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
     C                                                                                        CSD083
     C                   IF        PRTCD = *BLANKS                                            CSD083
     C                   EVAL      CSD015 = 'N'                                               CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083

      ** Access SAR details to see if CCF001 is switched on.

     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CCF001'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY

     C                   IF        PRtCd = *BLANKS
     C                   MOVEL     'Y'           CCF001
     C                   ELSE
     C                   MOVEL     'N'           CCF001
     C                   ENDIF
      *                                                                                       CER001
      ** Access SAR details file to determine if ULX043 is on.                                CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       PRtCd                                        CER001
     C                   PARM      '*VERIFY'     POptn                                        CER001
     C                   PARM      'ULX043'      PSard                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        PRTCD <> *Blanks and                                       CER001
     C                             PRTCD <> '*NRF   '                                         CER001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
     C                   MOVEL     '011'         DBASE                                        CER001
     C                   MOVEL     'ULX043'      DBKEY                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   END                                                                  CER001
      *                                                                                       CER001
     C**********         IF        PRtCd = *BLANKS                                            CER001
     C                   IF        PRtCd = *BLANKS AND BGNWST = 'Y'                         BUG14588
     C                   MOVEL     'Y'           ULX043                                       CER001
     C                   ELSE                                                                 CER001
     C                   MOVEL     'N'           ULX043                                       CER001
     C                   ENDIF                                                                CER001

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
     C                   Eval      DBPgm  = 'FTIPAYVU'                                        CSC022
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
      *                                                                                       CFT120
      ** Check if CFT120 is on                                                                CFT120
      *                                                                                       CFT120
     C                   CALLB     'AOSARDR0'                                                 CFT120
     C                   PARM      *BLANKS       PRTCD                                        CFT120
     C                   PARM      '*VERIFY'     POPTN                                        CFT120
     C                   PARM      'CFT120'      PSARD                                        CFT120
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
                                                                                              CFT120
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CFT120
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT120
     C                   EVAL      DBKEY  = 'CFT120'                                          CFT120
     C                   EVAL      DBASE  = 42                                                CFT120
     C                   EXSR      *PSSR                                                      CFT120
     C                   ENDIF                                                                CFT120
                                                                                              CFT120
     C                   IF        PRTCD = *BLANKS                                            CFT120
     C                   EVAL      CFT120 = 'Y'                                               CFT120
     C                   ELSE                                                                 CFT120
     C                   EVAL      CFT120 = 'N'                                               CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT151
      ** Check if CFT151 is on                                                                CFT151
      *                                                                                       CFT151
     C                   CALLB     'AOSARDR0'                                                 CFT151
     C                   PARM      *BLANKS       PRTCD                                        CFT151
     C                   PARM      '*VERIFY'     POPTN                                        CFT151
     C                   PARM      'CFT151'      PSARD                                        CFT151
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT151
                                                                                              CFT151
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CFT151
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT151
     C                   EVAL      DBKEY  = 'CFT151'                                          CFT151
     C                   EVAL      DBASE  = 42                                                CFT151
     C                   EXSR      *PSSR                                                      CFT151
     C                   ENDIF                                                                CFT151
                                                                                              CFT151
     C                   IF        PRTCD = *BLANKS                                            CFT151
     C                   MOVEL     'Y'           CFT151            1                          CFT151
     C                   ELSE                                                                 CFT151
     C                   MOVEL     'N'           CFT151                                       CFT151
     C                   ENDIF                                                                CFT151
     C/COPY WNCPYSRC,FTIPAYV022
                                                                                              CGL014
      ***Check*if*enhancement*CSC024*(Open*Month*End)*is*on                            CSC024 CSC054
      ** Check if enhancement CSC054 (Period End Adjustments) is on                           CSC054
                                                                                              CSC024
     C                   CALLB     'AOSARDR0'                                                 CSC024
     C                   PARM      *BLANKS       PRTCD                                        CSC024
     C                   PARM      '*VERIFY'     POPTN                                        CSC024
     C                   PARM      'CSC024'      PSARD                                        CSC024
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
     C/COPY WNCPYSRC,FTH00483
      ** If S01499 is installed, retrieve VAT Rate.
      ** OR if CFT010 is installed

     C                   IF        S01499 = 'Y' AND
     C                             CFT009 = 'N' OR
     C                             CFT010 = 'Y'

     C                   CALL      'AOVATR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*FIRST '     POptn
     C                   PARM                    PVATDS

     C                   ENDIF

      ** Access FT Control Data.

     C                   CALL      'FT0005'                             9090
     C                   PARM      *BLANKS       PRtCd
     C                   PARM                    PCNTRL

      ** Error occurred.

     C                   IF        *IN90 OR
     C                             PRtCd <> *BLANKS
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'FT0005'      DBFILE
     C                   Z-ADD     1             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF

      ** Set up FT Override for GL Balances.

     C                   IF        PGLUI = 'I'
     C                   MOVEL     'Y'           PFTOV
     C                   ELSE
     C                   MOVEL     *BLANK        PFTOV
     C                   ENDIF

      ** Access Currency details file for Base Currency details.

     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BJCYCD        PCurr
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   Z-ADD     A6NBDP        PBCDP

      ** Access Currency details file for Local Currency details.

     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR '     PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      BJLCCY        PCurr
     C     SDCURR        PARM      SDCURR        DSSDY

     C                   Z-ADD     A6NBDP        PLCDp
     C                   IF        A6MDIN = 'M'
     C                   Z-ADD     1             PLMDIn
     C                   ELSE
     C                   Z-ADD     0             PLMDIn
     C                   ENDIF
     C                   Z-ADD     A6SPRT        PLSpot

     C/COPY WNCPYSRC,FTIPAYCC07
      ** Check if enhancement CFT157 is on                                                    CFT157
                                                                                              CFT157
     C                   CALLB     'AOSARDR0'                                                 CFT157
     C                   PARM      *BLANKS       PRTCD                                        CFT157
     C                   PARM      '*VERIFY'     POPTN                                        CFT157
     C                   PARM      'CFT157'      PSARD                                        CFT157
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT157
                                                                                              CFT157
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CFT157
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT157
     C                   EVAL      DBKEY  = 'CFT157'                                          CFT157
     C                   EVAL      DBASE  = 32                                                CFT157
     C                   EXSR      *PSSR                                                      CFT157
     C                   ENDIF                                                                CFT157
                                                                                              CFT157
     C                   IF        PRTCD = *BLANKS                                            CFT157
     C                   MOVEL     'Y'           CFT157            1                          CFT157
     C                   ELSE                                                                 CFT157
     C                   EVAL      CFT157 = 'N'                                               CFT157
     C                   ENDIF                                                                CFT157
                                                                                              CFT157
      **********                                                                             BUG7029
      ***Retrieve*ZMUSER*details.                                                            BUG7029
      **********                                                                             BUG7029
     C******DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C**********         IN        ZMUSER                                                    BUG7029

      ** Define Account key list.

     C     KAccnt        KLIST
     C                   KFLD                    KACNUM
     C                   KFLD                    KACCCY
     C                   KFLD                    KACCD
     C                   KFLD                    KACSQ
     C                   KFLD                    KBRCA
     C     PPYKEY        KLIST                                                              MD034973
     C                   KFLD                    PPYBR                                      MD034973
     C                   KFLD                    PCNUM                                      MD034973
     C                   KFLD                    PPYTY                                      MD034973
     C                   KFLD                    PPYST                                      MD034973

     C     *LIKE         DEFINE    DDSMCY        WRCHCY
     C     *LIKE         DEFINE    DDSMAM        WRCHAM
     C     *LIKE         DEFINE    DDSMCY        WCACY
     C     *LIKE         DEFINE    DDSMAM        WCAAM

      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.

      /COPY ZACPYSRC,DBFIELDS

      ** Hook to enable non-core initial processing to be included

      /COPY WNCPYSRC,FTIPAYV019


     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * The following /COPY contains the standard program status
      * subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
**  PSNAR
Payment Advice From Cashier System
