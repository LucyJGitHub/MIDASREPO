000100200529     H DEBUG
000200200529     H COPYRIGHT('(c) Finastra International Limited 2003')
000300200529      *****************************************************************
000400200529/*STD *  RPGBASEMOD                                                   *
000500200529/*EXI *  TEXT('Midas FT IPAY validate and update')                    *
000600200529      *****************************************************************
000700200529      *                                                               *
000800200529      *  Midas - Funds Transfer Module                                *
000900200529      *                                                               *
001000200529      *  FTIPAYVU - Incoming Payments validate and update             *
001100200529      *                                                               *
001200200529      *  Function: This program validates Incoming Payments           *
001300200529      *            transactions for input into the Midas database.    *
001400200529      *            The action code determines which processes are     *
001500200529      *            executed as follows:                               *
001600200529      *            - For I (=Insert) or A (=Amend)                    *
001700200529      *              - Validate the transaction details fields        *
001800200529      *            - For A (=AMEND),                                  *
001900200529      *              - if transaction is a partial amendment, call a  *
002000200529      *                separate function to complete the transaction  *
002100200529      *                details.                                       *
002200200529      *              - if transaction is valid, call a separate       *
002300200529      *                function to check whether it is a valid        *
002400200529      *                amendment.                                     *
002500200529      *            - For D (=DELETE), call a separate function to     *
002600200529      *              process the transaction and bypass the rest of   *
002700200529      *              the validation.                                  *
002800200529      *                                                               *
002900200529      *            For all action codes, the decision to as to        *
003000200529      *            whether to write to the valid or invalid file and  *
003100200529      *            the call to the message handler will take place    *
003200200529      *            in this module                                     *
003300200529      *                                                               *
003400200529      *  (c) Finastra International Limited 2002                      *
003500200529      *                                                               *
003600200604      *  Last Amend No. 259696             Date 22May20               *
003800200605      *  Prev Amend No. 257943             Date 22May20               *
003900200529      *                 CSD102             Date 08Jan19               *
004000200529      *                 MD050928           Date 15May18               *
004100200529      *                 MD047369A          Date 24Jan18               *
004200200529      *                 MD046248           Date 27Oct17               *
004300200529      *                 MD042042           Date 14Feb17               *
004400200529      *                 MD044395           Date 08Mar17               *
004500200529      *                 AR1090283          Date 10Aug16               *
004600200529      *                 MD036159           Date 15Jul16               *
004700200529      *                 MD034973           Date 16Jul15               *
004800200529      *                 MD032077           Date 26Jan15               *
004900200529      *                 MD030906           Date 13Nov14               *
005000200529      *                 CFT157             Date 29Aug14               *
005100200529      *                 MD025111           Date 10May14               *
005200200529      *                 CFT151             Date 20Mar14               *
005300200529      *                 CFT120             Date 28Sep12               *
005400200529      *                 CAP211             Date 28Sep12               *
005500200529      *                 CSC054             Date 23Feb12               *
005600200529      *                 CSF011A            Date 28Nov11               *
005700200529      *                 CSF011             Date 12Sep11               *
005800200529      *                 CER049             Date 06Dec10               *
005900200529      *                 CRE075             Date 06Dec10               *
006000200529      *                 CER059             Date 19Jul10               *
006100200529      *                 262664             Date 11Nov09               *
006200200529      *                 CER030             Date 09Jul08               *
006300200529      *                 CSD083             Date 27May10               *
006400200529      * Bank Fusion Midas 1.4 Base -----------------------------------*
006500200529      *                 BUG24998           Date 17Jul09               *
006600200529      *                 CSW209             Date 01Apr09               *
006700200529      * Midas Plus 1.4 Base 04 ---------------------------------------*
006800200529      *                 BUG22146           Date 16Jan09               *
006900200529      *                 256564             Date 17Sep08               *
007000200529      *                 255190             Date 21Jul08               *
007100200529      *                 BUG15006           Date 16Sep07               *
007200200529      *                 247398             Date 30Jun07               *
007300200529      *                 BUG14588           Date 12Sep07               *
007400200529      *                 243991             Date 05Dec06               *
007500200529      *                 BUG13159           Date 29Jan07               *
007600200529      * Midas Plus 1.3 ----------- Base ------------------------------*
007700200529      *                 CFT032             Date 11Sep06               *
007800200529      *                 CSD031             Date 10Apr06               *
007900200529      *                 240137             Date 31May06               *
008000200529      *                 BUG6864            Date 15Dec05               *
008100200529      *                 CDL049             Date 06Jul06               *
008200200529      *                 CSD027             Date 09Dec05               *
008300200529      *                 CSD027             Date 09Dec05               *
008400200529      *                 BUG9106            Date 12Aug05               *
008500200529      *                 CER001             Date 25Apr05               *
008600200529      *                 BUG7101            Date 06Jul05               *
008700200529      *                 CSC024             Date 07Feb05               *
008800200529      *                 BUG7029            Date 09Jun05               *
008900200529      *                 BUG3279            Date 22Oct04               *
009000200529      *                 BUG4728            Date 05Nov04               *
009100200529      *                 BUG4196            Date 09Sep04               *
009200200529      *                 CFT115             Date 01Jul04               *
009300200529      *                 CGL014             Date 20Oct03               *
009400200529      *                 CLE025             Date 20Oct03               *
009500200529      *                 BUG515             Date 26Mar04               *
009600200529      *                 CSC022             Date 24Feb04               *
009700200529      *                 BUG1282            Date 25Mar04               *
009800200529      *                 BUG1493            Date 18Mar04               *
009900200529      *                 CGL029             Date 01Sep03               *
010000200529      *                 CGP001             Date 09Dec03               *
010100200529      *                 222373             Date 28Oct03               *
010200200529      *                 CAP084  *CREATE    Date 25Aug03               *
010300200529      *                                                               *
010400200529      *---------------------------------------------------------------*
010500200529      *                                                               *
010600200529      *  252696 - Ensure that field Swift Reference field is save in  *
010700200529      *           in INPAYDD file for MidasPlus.                      *
011300200529      *  257943 - Using the CANCEL button after routing MT103 to an   *
011400200529      *           incoming message, does not release the MT103 to be  *
011500200529      *           routed again. Ensure that a selected message is     *
011600200529      *           released if the transaction is cancelled.           *
011700200529      *  CSD102 - Password Length Extension (Recompile)               *
011800200529      *  MD050928 - SP15_MQ: Unclear error message - Error validating *
011900200529      *              'Stamp Tax Amount' : Invalid Numeric Value       *
012000200529      *           - Correction to CFT157. Move fields to end of Buffer*
012100200529      *           - Patterned after fix MD039094                      *
012200200529      *  MD047369A - Funds transfter does not check block Dr flag on  *
012300200529      *              beneficary customer account.                     *
012400200529      *  MD046248 - Finastra Rebranding                               *
012500200529      *  MD042042 - Input Officer 1 and Input Officer 2 are being     *
012600200529      *             populated with WIP authoriser. Use the WIP input  *
012700200529      *             user profile instead.                             *
012800200529      *  MD044395 - Incorrect Customer Name on Inputs details for     *
012900200529      *             valid BIC entry                                   *
013000200529      *  AR1090283 - Customer details not visible for enquire.        *
013100200529      *              (Child: AR1090284)                               *
013200200529      *            - Applied for MD-39986.                            *
013300200529      *  MD036159 - Systems allows payment with same FRNT.            *
013400200529      *             Pattern fix AR971184.                             *
013500200529      *           - Applied for MD-39705.                             *
013600200529      *  MD034973 - FT Payment Charges defaulting error               *
013700200529      *  MD032077 - Blank Front Office ID after authorisation. Do not *
013800200529      *             override IPFRNT when APFOTRANID is blank.         *
013900200529      *  MD030906 - Counterparty Nostro not defaulted.                *
014000200529      *  CFT157 - Stop FT Transaction after Authorisation             *
014100200529      *  MD025111 - Incoming payment without charges is not allowed   *
014200200529      *             if the account is blocked for DR                  *
014300200529      *  CFT151 - FT IN/OP Alphanumeric sequence                      *
014400200529      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
014500200529      *  CAP211 - FT IN_OP APIs - Auto-Authorization of Payment       *
014600200529      *  CSC054 - Period End Adjustments                              *
014700200529      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
014800200529      *          - Some codes of CSF011 will be physically deleted    *
014900200529      *  CSF011 - Customer Name on Inputs                             *
015000200529      *  CER049 - Stamp Tax                                           *
015100200529      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
015200200529      *  CER059 - German Feature Upgrade to Delhi                     *
015300200529      *  262664 - Parameter conflict against SWIFT09.                 *
015400200529      *         - Change the parameter name.                          *
015500200529      *  CER030 - Multicash German Feature                            *
015600200529      *  CSD083 - Watch List Compliance Upgrade                       *
015700200529      *  BUG24998 - Bank operation code is missing (Recompile)        *
015800200529      *  CSW209 - SWIFT 2009 Changes                                  *
015900200529      *  BUG22146 - Missing authorization field in repository.        *
016000200529      *  256564 - Recompile due to PF changes done by fix 256330      *
016100200529      *  255190 - Added parameter message type to validate ordering   *
016200200529      *           customer.                                           *
016300200529      *  BUG15006 - A serious midas error occurred on IPAY            *
016400200529      *  247398 - Does not insert sender charges field from Incoming  *
016500200529      *           SWIFT message into FT incoming payment.             *
016600200529      * BUG14588 - Cannot Edit and Authorise using Incoming FT        *
016700200529      *            in JAVA Screen                                     *
016800200529      *  243991  - Always validate level 2 details when 'level joiner'*
016900200529      *            set to 'Y'                                         *
017000200529      * BUG13159 - After a successful update, the latest timestamp    *
017100200529      *            is not being passed back to the Java side. This    *
017200200529      *            later causes the WIP entry becoming impossible     *
017300200529      *            to authorise due to discrepancy between the        *
017400200529      *            timestamp initially stored in the WIP (which is    *
017500200529      *            incorrect) and the latest timestamp retreived from *
017600200529      *            INPAYDD when the amendment is being authorised.    *
017700200529      *            The timestamp in INPAYXPD is also not being        *
017800200529      *            updated properly.                                  *
017900200529      *            This actually is a lacking aspect of the fix done  *
018000200529      *            for BUG4196.                                       *
018100200529      *  CFT032 - Account Line in Field 50X in MT103                  *
018200200529      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
018300200529      *  240137 - Applied fix 230309.                                 *
018400200529      *  230309 - If User enters Booking Branch, ignore value rtvd.   *
018500200529      *           by *MODULE FTVISNDR and set IPBRCA=DDBRCA.          *
018600200529      *  BUG6864 - Possible to get DB error if rate not entered       *
018700200529      *  CDL049 - Addition of a Reference Rate field (recompile)      *
018800200529      *  CSD027A - Change Customer Number to alpha; post-103 build.   *
018900200529      *  CSD027 - Conversion Of Customer Number to Alpha              *
019000200529      *  BUG9106 - Allow mandatory Charge Details 2 validation        *
019100200529      *  CER001 - LUX Upgrade to MidasPlus                            *
019200200529      *  BUG7101 - DB error in AOSPOSU0 due to blank INTRIT. Ensure   *
019300200529      *            fields are properly initialised.  Do the same      *
019400200529      *            changes done in FTIPAYSIN.                         *
019500200529      *  CSC024 - Open Month End                                      *
019600200529      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
019700200529      *            move out of *INZSR.                                *
019800200529      *  BUG3279- Commit for MEINMRPD is needed                       *
019900200529      *  BUG4728 - Serious Midas error with blank timestamp when      *
020000200529      *            authorising insert of transaction.                 *
020100200529      *  BUG4196- Stopping changes being overwritten by other user    *
020200200529      *           when try to amend the record at the same time.      *
020300200529      *  CFT115 - Core changes for GBO015.                            *
020400200529      *         - Incoming Payments Beneficiary Validation            *
020500200529      *                  - Upgrade to Midasplus                       *
020600200529      *           Core hooks amended:FTIPAYV002,FTIPAYM01,FTIPAYV018  *
020700200529      *           Core hooks added:FTIPAYV021,FTIPAYV022,             *
020800200529      *                            FTIPAYV023,                        *
020900200529      *  CGL014 - Collaterals Processing                              *
021000200529      *  CLE025 - Credit Lines (Recompile)                            *
021100200529      *  BUG515 - Set up error message for swift reference correctly  *
021200200529      *  CSC022 - Commitment Control Changes for MidasPlus            *
021300200529      *  BUG1282 - Delete reserved message if user presses cancel     *
021400200529      *  BUG1493 - Setup INUSR1 and INUSR2 correctly                  *
021500200529      *  CGL029 - Increase Account Code to 10 digits                  *
021600200529      *  CGP001 - Recompiled due to change in FTV2OPYPD               *
021700200529      *  222373 - Correct parameters on program calls                 *
021800200529      *  CAP084 - Thin Client API Wrappers                            *
021900200529      *                                                               *
022000200529      *****************************************************************
022100200529      ** +--------------------------------------+
022200200529      ** ¦ F-specs                              ¦
022300200529      ** ¦ =======                              ¦
022400200529      ** +--------------------------------------+
022500200529      *****************************************************************
022600200529
022700200529      ** GL Accounts file
022800200529     FACCNT     IF   E           K DISK    INFSR(*PSSR)
022900200529     F                                     IGNORE(ACCNTAAF)
023000200529     F                                     IGNORE(ACCNTACF)
023100200529
023200200529      ** Payment Charges file
023300200529     F***PYCHGDBIF   E           K DISK    INFSR(*PSSR)                                     MD034973
023400200529     FPYCHGL1   IF   E           K DISK    INFSR(*PSSR)                                     MD034973
023500200529     F                                     PREFIX(PY)
023600200529
023700200529     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
023800200529
023900200529     FMEINCRL2  IF   E           K DISK    INFSR(*PSSR)                                       252696
024000200529     FMEINCRL3  IF   E           K DISK    INFSR(*PSSR)                                       257943
024100200529     FMEINMPL1  IF   E           K DISK    INFSR(*PSSR)                                       252696
024200200529     FINPAYLL   IF   E           K DISK    INFSR(*PSSR)                                       252696
024300200529      ** Hook to enable non-core files to be included
024400200529      /COPY WNCPYSRC,FTIPAYV001
024500200529
024600200529      *****************************************************************
024700200529      ** +--------------------------------------+
024800200529      ** ¦ Automatically included D-specs       ¦
024900200529      ** ¦ ==============================       ¦
025000200529      ** +--------------------------------------+
025100200529      **
025200200529      ** Standard D-specs
025300200529      ** ================
025400200529      **
025500200529      ** The following /COPY line includes the LDA layout,
025600200529      ** the copyright array definition,
025700200529      ** and the following named constants:
025800200529      **    True       logical = *on (for indicator processing)
025900200529      **    False      logical = *off (for indicator processing)
026000200529      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
026100200529      **                                    handler)
026200200529      ** and the following variables:
026300200529      **    RunBefore  1A (for the PSSR)
026400200529
026500200529     D/COPY ZACPYSRC,STD_D_SPEC
026600200529
026700200529      ** Program Status Data Structure
026800200529      ** =============================
026900200529      ** The following /COPY line includes all the defined fields in the
027000200529      ** PSDS.  They have meaningful names, prefixed by 'PS'.
027100200529
027200200529     D/COPY ZACPYSRC,PSDS
027300200529      ** The following /COPY line includes definitions for the above fields
027400200529      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
027500200529      ** corresponding fields in the PSDS /COPY member, so that member
027600200529      ** must be included where this one is used.
027700200529
027800200529     D/COPY ZACPYSRC,PROCPARMS
027900200529
028000200529      **-----------------------------------------------------------------------
028100200529      ** The following /COPY line includes the definitions for error and
028200200529      ** warning message arrays.
028300200529     D/COPY ZACPYSRC,ERR_ARRAYS
028400200529      **-----------------------------------------------------------------------
028500200529
028600200529      **-----------------------------------------------------------------------
028700200529      ** The following /COPY line includes the definitions for arrays
028800200529      ** specific to API CTL & VU modules.
028900200529     D/COPY ZACPYSRC,APICTLARR
029000200529      **-----------------------------------------------------------------------
029100200529
029200200529      ** +--------------------------------------+
029300200529      ** ¦ End of automatically included D-specs¦
029400200529      ** ¦ =====================================¦
029500200529      ** +--------------------------------------+
029600200529
029700200529      *****************************************************************
029800200529      /EJECT
029900200529      *****************************************************************
030000200529
030100200529      ** +--------------------------------------+
030200200529      ** ¦ Manually included D-specs            ¦
030300200529      ** ¦ =========================            ¦
030400200529      ** +--------------------------------------+
030500200529
030600200529      ** +--------------------------------------+
030700200529      ** ¦ Named constants                      ¦
030800200529      ** ¦ ===============                      ¦
030900200529      ** +--------------------------------------+
031000200529                                                                                              CSC024
031100200529     D*SysValOME       C                   CONST('OMEIndicator')                       CSC024 CSC054
031200200529     D SysValPEA       C                   CONST('PEAIndicator')                              CSC054
031300200529      ** System Values Array                                                                  CSC024
031400200529
031500200529      ** +--------------------------------------+
031600200529      ** ¦ Arrays and Data Structures           ¦
031700200529      ** ¦ ==========================           ¦
031800200529      ** +--------------------------------------+
031900200529
032000200529      ** Narrative for Sender
032100200529     D PSNAR           S             35    DIM(1) CTDATA PERRCD(1)
032200200529
032300200529      ** Work array for setting up new Payment Reference
032400200529     D WYA2            S              1    DIM(18)
032500200529
032600200529      ** Work array for Amount for FONTIS processing
032700200529     D WYA1            S              1    DIM(15)
032800200529
032900200529      ** Work array
033000200529     D WA              S              1    DIM(15)
033100200529
033200200529      ** Work array used in SR CWVAL to store content of tag
033300200529     D W@CW            S              1    DIM(256)
033400200529
033500200529      ** Work array used in SR CWVAL to store value extracted
033600200529     D W@VL            S              1    DIM(256)
033700200529
033800200529      ** Work array for warning message Ids
033900200529     D WPrvWarnAr      S                   Dim(ArrayMax)
034000200529     D                                     Like(WMsgIDArr)
034100200529
034200200529      ** Commitment Control Job Array                                                         CSC022
034300200529     D WJobs           S             10A   Dim(10)                                            CSC022
034400200529      **                                                                                      CSC022
034500200529      ** Incoming header
034600200529     D HeadIn        E DS                  EXTNAME(APHEADPD)
034700200529
034800200529      ** Incoming transaction in screen format
034900200529     D TranInIPY1    E DS                  EXTNAME(FTIPY1PD)
035000200529     D TranInIP1A    E DS                  EXTNAME(FTIPY1APD)
035100200529     D TranInIPY2    E DS                  EXTNAME(FTIPY2PD)
035200200529     D TranInIPY3    E DS                  EXTNAME(FTIPY3PD)
035300200529     D TranInIPY4    E DS                  EXTNAME(FTIPY4PD)
035400200529     D TranInIP4A    E DS                  EXTNAME(FTIPY4APD)
035500200529     D TranInIPY5    E DS                  EXTNAME(FTIPY5PD)
035600200529     D TranInIPY6    E DS                  EXTNAME(FTIPY6PD)
035700200529      *                                                                                       CSW209
035800200529      ** Incoming Payments Lvl 2 Scrn 7 from transaction - screen fmt                         CSW209
035900200529     D TranInIPY7    E DS                  EXTNAME(FTIPY7PD)                                  CSW209
036000200529      *                                                                                       CSW209
036100200529      ** Incoming Payments Lvl 2 Scrn 8 from transaction - screen fmt                         CSW209
036200200529     D TranInIPY8    E DS                  EXTNAME(FTIPY8PD)                                  CSW209
036300200529      *                                                                                       CER049
036400200529      ** Incoming Payments Lvl 2 Scrn 9 from transaction - screen fmt                         CER049
036500200529     D TranInIPY9    E DS                  EXTNAME(FTIPY9PD)                                  CER049
036600200529      *
036700200529     D TranInIP6A    E DS                  EXTNAME(FTIPY6APD)                                 CER030
036800200529
036900200529      ** Valid file layout
037000200529     D ValidIPAY     E DS                  EXTNAME(FTVIPAYPD)
037100200529     D ValidIPY2     E DS                  EXTNAME(FTVIPY2PD)
037200200529
037300200529      ** Valid file layout - default
037400200529     D DefValid      E DS                  EXTNAME(FTVIPAYPD)
037500200529     D                                     PREFIX(D#)
037600200529     D DefValidx     E DS                  EXTNAME(FTVIPY2PD)
037700200529     D                                     PREFIX(D#)
037800200529
037900200529      * Valid Incoming payment                                                                CER001
038000200529     D IPAYValPmt    E DS                  EXTNAME(FTVIPLX1PD)                                CER001
038100200529                                                                                              CER001
038200200529      ** Incoming Payment                                                                     CER001
038300200529     D IPAYExFilFmt  E DS                  EXTNAME(FTIPX1PD)                                  CER001
038400200529                                                                                              CER001
038500200529      ** Incoming Payment OK extension Flags                                                  CER001
038600200529     D OKExtFlg      E DS                  EXTNAME(FTEIPLX1PD)                                CER001
038700200529                                                                                              CER001
038800200529     D PDATALUX        DS          1024                                                       CER001
038900200529     D  #1FLD1                 1      6  0                                                    CER001
039000200529     D  PREF1                  7     21                                                       CER001
039100200529     D  #1FOTR                22     41                                                       CER001
039200200529     D  #1TMST                42     67Z                                                      CER001
039300200529     D  #1ACBT                68     68                                                       CER001
039400200529     D  #1ACBK                69     80                                                       CER001
039500200529     D  #1BNC1                81    115                                                       CER001
039600200529     D  #1PCCY               116    118                                                       CER001
039700200529     D  #1BNCT               119    119                                                       CER001
039800200529     D  #1SMAM               120    132P 0                                                    CER001
039900200529     D  #1RCRT               133    133                                                       CER001
040000200529     D**#1RCCO**             134    143  0                                            CER001 CSD027A
040100200529     D  #1RCCO               134    143                                                      CSD027A
040200200529     D  #1SNTP               144    144                                                       CER001
040300200529     D  #1SND1               145    179                                                       CER001
040400200529                                                                                              CER001
040500200529      ** Current transaction record in file format
040600200529     D IPAYFilFmt    E DS                  EXTNAME(INPAYDD)
040700200529     D IPY2FilFmt    E DS                  EXTNAME(INPAYXPD)
040800200529     D                                     PREFIX(CR)                                         CER001
040900200529
041000200529      ** Current transaction in screen format
041100200529     D CurTrIPY1     E DS                  EXTNAME(FTIPY1PD)
041200200529     D                                     PREFIX(O)
041300200529     D CurTrIP1A     E DS                  EXTNAME(FTIPY1APD)
041400200529     D                                     PREFIX(O)
041500200529     D CurTrIPY2     E DS                  EXTNAME(FTIPY2PD)
041600200529     D                                     PREFIX(O)
041700200529     D CurTrIPY3     E DS                  EXTNAME(FTIPY3PD)
041800200529     D                                     PREFIX(O)
041900200529     D CurTrIPY4     E DS                  EXTNAME(FTIPY4PD)
042000200529     D                                     PREFIX(O)
042100200529     D CurTrIP4A     E DS                  EXTNAME(FTIPY4APD)
042200200529     D                                     PREFIX(O)
042300200529     D CurTrIPY5     E DS                  EXTNAME(FTIPY5PD)
042400200529     D                                     PREFIX(O)
042500200529     D CurTrIPY6     E DS                  EXTNAME(FTIPY6PD)
042600200529     D                                     PREFIX(O)
042700200529      *                                                                                       CSW209
042800200529      ** Incoming Payments Lvl 2 Scrn 7 from file - screen format                             CSW209
042900200529     D CurTrIPY7     E DS                  EXTNAME(FTIPY7PD)                                  CSW209
043000200529     D                                     PREFIX(O)                                          CSW209
043100200529      *                                                                                       CSW209
043200200529      ** Incoming Payments Lvl 2 Scrn 8 from file - screen format                             CSW209
043300200529     D CurTrIPY8     E DS                  EXTNAME(FTIPY8PD)                                  CSW209
043400200529     D                                     PREFIX(O)                                          CSW209
043500200529      *                                                                                       CER030
043600200529     D CurTrIP6A     E DS                  EXTNAME(FTIPY6APD)                                 CER030
043700200529     D                                     PREFIX(O)                                          CER030
043800200529
043900200529      ** Extra data in file format
044000200529     D ExtData       E DS                  EXTNAME(FTIPEXPD)
044100200529     D RegData       E DS                  EXTNAME(FTIPRXPD)                                  CER001
044200200529     D StopFTDta     E DS                  EXTNAME(FTIPY10APD)                              MD050928
044300200529
044400200529      ** Error indicators
044500200529     D OKTrIPY1      E DS                  EXTNAME(FTEIPY1PD)
044600200529     D OKTrIPY2      E DS                  EXTNAME(FTEIPY2PD)
044700200529     D OKTrIPY3      E DS                  EXTNAME(FTEIPY3PD)
044800200529     D OKTrIPY4      E DS                  EXTNAME(FTEIPY4PD)
044900200529     D OKTrIPY5      E DS                  EXTNAME(FTEIPY5PD)
045000200529      *                                                                                       CSW209
045100200529      ** Incoming Payments Lvl 2 Scrn 7 error indicators                                      CSW209
045200200529     D OKTrIPY7      E DS                  EXTNAME(FTEIPY7PD)                                 CSW209
045300200529      *                                                                                       CSW209
045400200529      ** Incoming Payments Lvl 2 Scrn 8 error indicators                                      CSW209
045500200529     D OKTrIPY8      E DS                  EXTNAME(FTEIPY8PD)                                 CSW209
045600200529
045700200529      ** Externally described DS for Bank details
045800200529     D SDBANK        E DS                  EXTNAME(SDBANKPD)
045900200529
046000200529      ** Externally described DS for API ICD details
046100200529     D SDAPI         E DS                  EXTNAME(SDAPIPD)
046200200529
046300200529      ** Externally described DS for General Ledger ICD details
046400200529     D SDGELR        E DS                  EXTNAME(SDGELRPD)
046500200529
046600200529      ** Externally described DS for Midas Modules details
046700200529     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
046800200529
046900200529      ** Externally described DS for Funds Transfer ICD details
047000200529     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
047100200529
047200200529      ** Externally described DS for Retail ICD details
047300200529     D SDRETL        E DS                  EXTNAME(SDRETLPD)
047400200529     D  SDRETLACCD   E                     EXTFLD(QQACCD)                                     CGL029
047500200529
047600200529      ** External DS for SAR details
047700200529     D SCSARD        E DS                  EXTNAME(SCSARDPD)
047800200529     D SCA_LCD       E                     EXTFLD(LCD)
047900200529
048000200529      ** Externally described DS for Currency details
048100200529     D SDCURR        E DS                  EXTNAME(SDCURRPD)
048200200529
048300200529      ** Externally described DS for Branch details
048400200529     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
048500200529
048600200529      ** Externally described DS for FONTIS details
048700200529     D SDFONT        E DS                  EXTNAME(SDFONTPD)
048800200529
048900200529      ** Externally described DS for Account details
049000200529     D SDACCT        E DS                  EXTNAME(ACCNTAB)
049100200529     D                                     PREFIX(IF)
049200200529
049300200529      ** Externally described DS for Counterpary nostro                                     MD030906
049400200529     D SDCNST        E DS                  EXTNAME(SDCNSTPD)                                MD030906
049500200529                                                                                            MD030906
049600200529      ** Externally described DS for Nostro details
049700200529     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
049800200529     D  QQACC2       E                     EXTFLD(QQACCD)                                     CGL029
049900200529
050000200529      ** First DS for access programs - short data structure
050100200529     D DSFDY         E DS                  EXTNAME(DSFDY)
050200200529
050300200529      ** Second DS for access programs - long data structure
050400200529     D DSSDY         E DS                  EXTNAME(DSSDY)
050500200529
050600200529      ** 24X7 Status DataArea Layout
050700200529     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
050800200529     D  WPRDTE                 5      9  0
050900200529
051000200529      ** SD Status DataArea Layout
051100200529     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
051200200529
051300200529      ** SCCMTJOB DataArea Layout                                                             CSC022
051400200529     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
051500200529     D  WDSJobs                4    103A                                                      CSC022
051600200529      **                                                                                      CSC022
051700200529      ** FT Control Data
051800200529     D PCNTRL          DS           256
051900200529     D  PGLUI                  4      4
052000200529     D  PVATT                  6      6
052100200529
052200200529      ** DS for VAT details
052300200529     D PVATDS          DS
052400200529     D  PVATR                 10     12P 4
052500200529
052600200529      ** DS for ZMUSER details
052700200529     D ZMUSER          DS            17
052800200529     D  PUSRID                 1     10
052900200529     D  PDBRN                 11     13
053000200529     D  PDPPT                 14     16
053100200529
053200200529      ** DS for CASH details
053300200529     D PCSHDTA         DS           512
053400200529     D  WDACACD               21     24  0
053500200529
053600200529      ** DS to split Message Reference when maintenance is called
053700200529      ** by linked maintenance/enquiry
053800200529     D WMsgRefDS       DS
053900200529     D  WRefMsg                1      8  0
054000200529     D  WRefPrt                9     11  0
054100200529
054200200529      **  DS for Date change
054300200529     D WWDT            DS             6
054400200529     D  WD1                    1      2
054500200529     D  WD2                    3      4
054600200529     D  WD3                    5      6
054700200529
054800200529      ** DS for Account key
054900200529     D***WACKYDS         DS            18                                                     CGL029
055000200529     D WACKYDS         DS            24                                                       CGL029
055100200529     D**KACNUM**               1      6  0                                                    CSD027
055200200529     D  KACNUM                 1      6                                                       CSD027
055300200529     D  KACCCY                 7      9
055400200529     D***KACCD**               10     13  0                                                   CGL029
055500200529     D***KACSQ**               14     15  0                                                   CGL029
055600200529     D***KBRCA**               16     18                                                      CGL029
055700200529     D  KACCD                 10     19  0                                                    CGL029
055800200529     D  KACSQ                 20     21  0                                                    CGL029
055900200529     D  KBRCA                 22     24                                                       CGL029
056000200529
056100200529      ** DS for IBANs full account
056200200529     D PIBANAcc        DS
056300200529     D**IBCNUM**               1      6  0                                                    CSD027
056400200529     D  IBCNUM                 1      6                                                       CSD027
056500200529     D  IBCCY                  7      9
056600200529     D***IBACOD*               10     13  0                                                   CGL029
056700200529     D***IBACSQ*               14     15  0                                                   CGL029
056800200529     D***IBBRCA*               16     18                                                      CGL029
056900200529     D  IBACOD                10     19  0                                                    CGL029
057000200529     D  IBACSQ                20     21  0                                                    CGL029
057100200529     D  IBBRCA                22     24                                                       CGL029
057200200529
057300200529      ** DS to format P53
057400200529     D                 DS
057500200529     D  WWP53                  1     35
057600200529     D  WWP53A                 1      1
057700200529     D  WWP53B                 2     35
057800200529
057900200529      ** DS to format P59
058000200529     D                 DS
058100200529     D  WWP59                  1     35
058200200529     D  WWP59A                 1      1
058300200529     D  WWP59B                 2     35
058400200529
058500200529      ** DS to format work variable of Beneficiary
058600200529     D                 DS
058700200529     D  WWBNC1                 1     35
058800200529     D  WWCUS1                 1      6
058900200529     D***WWACD1*                7     10                                                      CGL029
059000200529     D***WWSQN1*               11     12                                                      CGL029
059100200529     D***WWBCH1*               13     15                                                      CGL029
059200200529     D  WWACD1                 7     16                                                       CGL029
059300200529     D  WWSQN1                17     18                                                       CGL029
059400200529     D  WWBCH1                19     21                                                       CGL029
059500200529
059600200529      ** DS for obtaining Rate
059700200529     D WR1             DS
059800200529     D  WSR                    1     13
059900200529     D                                     DIM(13)
060000200529
060100200529      ** DS for obtaining Rate (SRRATE36)
060200200529     D WWR1            DS
060300200529     D  W@R1                   1     13
060400200529     D                                     DIM(13)
060500200529
060600200529      ** Work array - Multiple lines of First Line of Pxx fields
060700200529     D                 DS
060800200529     D  LFLT                   1    295    DIM(5)
060900200529     D**BG1*****               1     24                                                       247398
061000200529     D**TV1*****              25     59                                                       247398
061100200529     D**BG2*****              60     83                                                       247398
061200200529     D**TV2*****              84    118                                                       247398
061300200529     D**BG3*****             119    142                                                       247398
061400200529     D**TV3*****             143    177                                                       247398
061500200529     D**BG4*****             178    201                                                       247398
061600200529     D**TV4*****             202    236                                                       247398
061700200529     D**BG5*****             237    260                                                       247398
061800200529     D**TV5*****             261    295                                                       247398
061900200529     D  BG1                    1     30                                                       247398
062000200529     D  TV1                   31     59                                                       247398
062100200529     D  BG2                   60     89                                                       247398
062200200529     D  TV2                   90    118                                                       247398
062300200529     D  BG3                  119    148                                                       247398
062400200529     D  TV3                  149    177                                                       247398
062500200529     D  BG4                  178    207                                                       247398
062600200529     D  TV4                  208    236                                                       247398
062700200529     D  BG5                  237    266                                                       247398
062800200529     D  TV5                  267    295                                                       247398
062900200529
063000200529      ** Data structure used for FT0010
063100200529     D P#0010          DS           256
063200200529     D  P#NDCY                 1      3
063300200529     D  P#NDAM                 4     10P 0
063400200529     D  P#DBCY                11     13
063500200529     D  P#DBAM                14     20P 0
063600200529     D  P#DBDT                21     23P 0
063700200529     D  P#CRCY                24     26
063800200529     D  P#CRAM                27     33P 0
063900200529     D  P#PDCY                34     36
064000200529     D  P#PDAM                37     43P 0
064100200529     D  P#CRDT                44     46P 0
064200200529     D  P#RATE                47     53P 8
064300200529     D  P#MDIN                54     54  0
064400200529     D  P#OVRT                55     55
064500200529     D  P#SDIN                56     56
064600200529     D  P#RTDS                57     59P 4
064700200529
064800200529     D  P#FRCY                11     13
064900200529     D  P#FRAM                14     20P 0
065000200529     D  P#FRDT                21     23P 0
065100200529     D  P#TOCY                24     26
065200200529     D  P#TOAM                27     33P 0
065300200529     D  P#TODT                44     46P 0
065400200529
065500200529     D  P#PMSQ                60     69
065600200529     D  P#INDC                70     74
065700200529     D  P#RTCD                75     81
065800200529     D  P#INTC                82     99  3
065900200529     D  P#INTD               100    117  3
066000200529
066100200529      ** Break down MIDAS equivalent
066200200529     D WRCDE2          DS
066300200529     D  WRCNUM                 1      6
066400200529     D  WRCYCD                 7      9
066500200529     D***WRACOD*               10     13                                                      CGL029
066600200529     D***WRACSQ*               14     15                                                      CGL029
066700200529     D***WRBRCD*               16     18                                                      CGL029
066800200529     D***WRCDSQ*               10     15                                                      CGL029
066900200529     D***WRCSB**               10     18                                                      CGL029
067000200529     D  WRACOD                10     19                                                       CGL029
067100200529     D  WRACSQ                20     21                                                       CGL029
067200200529     D  WRBRCD                22     24                                                       CGL029
067300200529     D  WRCDSQ                16     21                                                       CGL029
067400200529     D  WRCSB                 10     24                                                       CGL029
067500200529
067600200529      ** DS to hold G/L account number
067700200529     D WDSGLDG         DS
067800200529     D  WGLCST                 1      6
067900200529     D  WGLCCY                 7      9
068000200529     D***WGLACD*               10     13                                                      CGL029
068100200529     D***WGLSQN*               14     15                                                      CGL029
068200200529     D***WGLBCH*               16     18                                                      CGL029
068300200529     D  WGLACD                10     19                                                       CGL029
068400200529     D  WGLSQN                20     21                                                       CGL029
068500200529     D  WGLBCH                22     24                                                       CGL029
068600200529
068700200529      ** Output Data Structure for reformatted address
068800200529     D POADD           DS           175
068900200529     D  OADD1                  1     35
069000200529     D  OADD2                 36     70
069100200529     D  OADD3                 71    105
069200200529     D  OADD4                106    140
069300200529     D  OADD5                141    175
069400200529
069500200529      ** DS for Additional Info details
069600200529     D PAddInfm        DS           196
069700200529
069800200529      ** DS for Default Charge Amounts
069900200529     D PCharges        DS           196
070000200529
070100200529      ** DS for Default Charge Currencies
070200200529     D PChgCcy         DS            48
070300200529
070400200529      ** DS for next Incoming Payment Reference Number
070500200529     D WINPAY          DS             4
070600200529     D  WINSQ                  1      4  0
070700200529
070800200529      ** Warning message work inds for charges screen
070900200529     D PChgWarn        DS            24
071000200529     D  WFTF3176               1      1
071100200529     D  WFTF3177               2      2
071200200529     D  WFTF3178               3      3
071300200529     D  WFTF3179               4      4
071400200529     D  WFTF3202               5      5
071500200529     D  WFTF3204               6      6
071600200529     D  WFTF3182               7      7
071700200529     D  WFTF3184               8      8
071800200529     D  WFTF3185               9      9
071900200529     D  WFTF3186              10     10
072000200529     D  WFTF3187              11     11
072100200529     D  WFTF3188              12     12
072200200529     D  WFTF3158              13     13
072300200529     D  WFTF3159              14     14
072400200529     D  WFTF3160              15     15
072500200529     D  WFTF3161              16     16
072600200529     D  WFTF3203              17     17
072700200529     D  WFTF3205              18     18
072800200529     D  WFTF3164              19     19
072900200529     D  WFTF3171              20     20
073000200529     D  WFTF3172              21     21
073100200529     D  WFTF3173              22     22
073200200529     D  WFTF3174              23     23
073300200529     D  WFTF3175              24     24
073400200529
073500200529     D W@CHK           C                   CONST('0123456789.')
073600200529
073700200529      ** +--------------------------------------+
073800200529      ** ¦ Declared variables                   ¦
073900200529      ** ¦ ==================                   ¦
074000200529      ** +--------------------------------------+
074100200529
074200200529      ** Index for arrays of error message ids etc in amend validation
074300200529     D AmIdx           S              3P 0 INZ(0)
074400200529
074500200529      ** Index for arrays of error message ids etc
074600200529     D Idx             S              3P 0 INZ(0)
074700200529
074800200529      ** Index for arrays of warning message ids etc
074900200529     D WIdx            S              3P 0 INZ(0)
075000200529
075100200529      ** Fields (1000A) to receive the incoming transaction                                  CSF011A
075200200529     D Trans01         S           1000A                                                     CSF011A
075300200529     D Trans03         S           1000A                                                     CSF011A
075400200529     D Trans05         S           1000A                                                     CSF011A
075500200529      ** Fields (500A) to receive the incoming transaction
075600200529     D Trans5001       S            500A
075700200529     D Trans5002       S            500A
075800200529     D Trans5003       S            500A
075900200529     D Trans5004       S            500A
076000200529     D Trans5005       S            500A
076100200529     D Trans5006       S            500A
076200200529     D Trans5007       S            500A
076300200529     D Trans5008       S            500A
076400200529     D Trans5009       S           1000A                                                      CSW209
076500200529     D Trans5010       S           1000A                                                      CSW209
076600200529     D Trans5011       S            500A                                                      CER049
076700200529     D***Trans5009       S            500A                                             CER030 262664
076800200529     D Trans5008A      S            500A                                                      262664
076900200529     D RegData500      S            500A                                                      CER001
077000200529
077100200529      ** Field (500A) to receive the incoming Extra Data
077200200529     D ExtData500      S            500A
077300200529
077400200529      ** Mode = '*FRONT' (Front Office Transaction Interface)
077500200529      ** Mode = '      ' (Not Front Office Transaction Interface)
077600200529     D PMode           S              6A
077700200529     D PModuleId       S              2A
077800200529
077900200529      ** Entry parameters
078000200529     D UpdateYN        S              1A
078100200529     D Buffer          S           6000A
078200200529     D APIRetc         S              1A
078300200529
078400200529     D PRetCodeIn      S             10                                                       CER001
078500200529     D PActn           S              1                                                       CER001
078600200529     D PFrontID        S             20                                                       CER001
078700200529     D PPayRef         S             15                                                       CER001
078800200529                                                                                              CER001
078900200529     D WWCUTY          S              2A                                                      CER001
079000200529     D @CUST           S              6A                                                      CER001
079100200529     D WFIND           S              1                                                       CER001
079200200529                                                                                              CER001
079300200529      ** SARs
079400200529     D S01494          S              1A
079500200529     D S01499          S              1A
079600200529     D S01506          S              1A
079700200529     D S01508          S              1A
079800200529     D CEU006          S              1A
079900200529     D CGL009          S              1A
080000200529     D CFT004          S              1A
080100200529     D CFT003          S              1A
080200200529     D CFT002          S              1A
080300200529     D CFT014          S              1A
080400200529     D CFT009          S              1A
080500200529     D CFT010          S              1A
080600200529     D CSC011          S              1A
080700200529     D CSD015          S              1A
080800200529     D CCF001          S              1A
080900200529     D CSC022          S              1A                                                      CSC022
081000200529      *                                                                                       CFT120
081100200529      ** CFT120 switchable field                                                              CFT120
081200200529      *                                                                                       CFT120
081300200529     D CFT120          S              1A                                                      CFT120
081400200529     D/COPY WNCPYSRC,FTH00559
081500200529
081600200529      ** Work variables
081700200529     D PParmLEVEL      S              1A   INZ('1')
081800200529     D PLinkPgm        S             10A   INZ(*BLANKS)
081900200529     D PReference      S             18A
082000200529     D PAReference     S             18A
082100200529     D PProcDte        S              5P 0
082200200529     D PPrDate         S              6P 0
082300200529     D PPrADate        S              7A
082400200529     D WSubIP1         S              1A
082500200529     D WSubIP1a        S              1A
082600200529     D WSubIP2         S              1A
082700200529     D WSubIP3         S              1A
082800200529     D WSubIP4         S              1A
082900200529     D WSubIP4a        S              1A
083000200529     D WSubIP5         S              1A
083100200529     D WSubIP6         S              1A
083200200529     D WArrPtr         S              3S 0                                                    CSC022
083300200529     D WSkpComtRolbk   S              1A                                                      CSC022
083400200529
083500200529     D PPRefInsert     S              1A   INZ(*BLANK)
083600200529     D WLvl2           S              1A
083700200529     D OKSWTN          S              1A
083800200529     D OKSEQNO         S              1A
083900200529     D WBTPCRD         S              5P 2
084000200529
084100200529     D PPrvTRI         S             34A
084200200529     D PPrvNDAM        S             14A
084300200529     D PPYBR           S              3A
084400200529     D PACBDS          S             18A
084500200529     D PSNDDS          S             18A
084600200529     D PRCCDS          S             18A
084700200529     D PBNCDS          S             18A
084800200529
084900200529     D PSetInCy        S              1A
085000200529     D PSetTPSD        S              5P 0
085100200529     D PPayInCy        S              1A
085200200529     D PPayTPSD        S              5P 0
085300200529
085400200529     D PPrvCDRT        S              1A
085500200529     D***PPrvCDRO        S             12A                                                    CGL029
085600200529     D PPrvCDRO        S             18A                                                      CGL029
085700200529     D PPrvCDBR        S              3A
085800200529     D PPrvCDRC        S              3A                                                      CFT120
085900200529     D PReCalc         S              1A
086000200529     D PICcy           S              3A
086100200529     D PIInCy          S              1A
086200200529     D PINbdp          S              1P 0
086300200529     D PITPSD          S              5P 0
086400200529     D POCcy           S              3A
086500200529     D POInCy          S              1A
086600200529     D PONbdp          S              1P 0
086700200529
086800200529     D PFrcRedisplay   S              1A
086900200529     D PPrvDDRCRM      S             12A
087000200529     D PPrvTotChg      S             15P 0
087100200529     D PCDROChg        S              1A
087200200529
087300200529     D PStatus         S             10A
087400200529     D PPYTP           S              2A
087500200529
087600200529     D PIncData        S           2000A
087700200529     D PCurData        S           2000A
087800200529     D PResetFld       S              1A
087900200529     D PAmendOk        S              1A
088000200529     D WWInsQ          S              4P 0
088100200529     D PDayNo          S              5P 0
088200200529     D PFmt            S              1A
088300200529     D PDate           S              6P 0
088400200529     D PADate          S              7A
088500200529
088600200529     D WN2             S              2P 0
088700200529     D WA4             S              4A
088800200529     D WA2             S              2A
088900200529     D WA2A            S              2A
089000200529     D WA6             S              6A
089100200529     D IA              S              2P 0
089200200529     D PTranID         S             20A
089300200529
089400200529     D PRtCd           S              7A   INZ(*BLANK)
089500200529     D POptn           S              7A   INZ(*BLANK)
089600200529     D PSard           S              7A   INZ(*BLANK)
089700200529     D PCurr           S              3A
089800200529     D ULX043          S              1A   INZ(*BLANKS)                                       CER001
089900200529     D PBCDP           S              1P 0
090000200529     D PLCDP           S              1P 0
090100200529     D PLMDIn          S              1P 0
090200200529     D PLSpot          S             13P 8
090300200529
090400200529     D POrigActn       S              1A
090500200529     D PFTOV           S              1A
090600200529     D PResponse       S              1A   INZ('S')
090700200529
090800200529     D PErrMs          S              7A
090900200529     D ZalignOk        S              1A
091000200529     D ZField          S             16A
091100200529     D ZADec           S              1P 0
091200200529     D ZADig           S              2P 0
091300200529
091400200529     D WErr            S              1A   INZ(*BLANK)
091500200529     D PACTD           S              8A
091600200529     D L               S              2P 0
091700200529     D PCHR03          S              3A
091800200529     D WRCRMNDP        S              1P 0
091900200529     D Cx              S              3P 0
092000200529     D Ex              S              3P 0
092100200529     D WAMT            S             15A
092200200529     D ZDateIn         S              6A
092300200529     D ZDateOut        S              5P 0
092400200529     D ZDateFmt        S              1A
092500200529     D ZDate1OK        S              1A
092600200529     D WOVVLD          S              5P 0
092700200529     D WSLDT           S              5P 0
092800200529     D WWK1            S              1A
092900200529     D WOCMT           S              3P 0
093000200529     D WPCYD           S              1P 0
093100200529     D W1PYA           S             11P 0
093200200529     D WSMCY           S              1P 0
093300200529     D W1SMA           S             11P 0
093400200529     D W1RTE           S             11P 7
093500200529     D ZADEC2          S              2P 0
093600200529     D PBRCH           S              3A
093700200529     D WREAC           S             10A
093800200529     D P@IBAN          S             34A
093900200529     D WSEQNO          S              2P 0
094000200529     D PACT            S              7A
094100200529     D PMSGR           S              8P 0
094200200529     D PKPRT           S              3P 0
094300200529     D PMOR            S             28A
094400200529     D PMIR            S             28A
094500200529     D PRTN            S              7A
094600200529     D WFirstErr       S              1A   INZ('N')
094700200529                                                                                              CGL014
094800200529     D CGL014          S              1                                                       CGL014
094900200529                                                                                              CGL014
095100200529      ** Field (1000A) to receive the incoming Customer Name                                  CSF011
095200200529     D WNumDetlIn      S           1000A                                                      CSF011
095300200529                                                                                              CSF011
095400200529     D ACCNT_AC      E DS                  EXTNAME(ACCNTAB)                                   CSF011
095500200529     D                                     PREFIX(AC_)                                        CSF011
095600200529     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSF011
095700200529     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CSF011
095800200529     D CusIdx          S              4S 0 INZ(1)                                             CSF011
095900200529     D CusIdx2         S              4S 0 INZ(1)                                             CSF011
096000200529     D AccLength       S              2S 0 INZ(72)                                            CSF011
096100200529     D ACusLngth       S              2S 0 INZ(52)                                            CSF011
096200200529     D NoOfCusField    S              2S 0 INZ(10)                                            CSF011
096300200529     D CusOrAcc        C                   CONST('AAAAABABBA')                                CSF011
096400200529     D W@Len           S              2S 0                                                    CSF011
096500200529     D P@TYP           S             10                                                       CSF011
096600200529     D P@Str           S             35                                                       CSF011
096700200529     D WNStr           S             35                                                       CSF011
096800200529     D P0RETL          S             10                                                       CSF011
096900200529     D WCustomer       S             10                                                       CSF011
097000200529     D C#KYST          S              7                                                       CSF011
097100200529     D W@Abc           S              1                                                       CSF011
097200200529     D W@ATyp          S              1                                                       CSF011
097300200529     D W@CCY           S              3                                                       CSF011
097400200529     D W@BRC           S              3                                                       CSF011
097500200529                                                                                              CSW209
097600200529      ** SWIFT 2009 flag                                                                      CSW209
097700200529     D CSW209          S              1A                                                      CSW209
097800200529     D CSC054          S              1A                                                      CSC054
097900200529      *                                                                                       CSC054
098000200529     D PCNUM           S              6A                                                    MD034973
098100200529     D PPYTY           S              2A                                                    MD034973
098200200529     D PPYST           S              2A                                                    MD034973
098300200529     D InputUser       S             10A                                                    MD042042
098400200529      ** +--------------------------------------+
098500200529      ** ¦ /COPYs                               ¦
098600200529      ** ¦ ======                               ¦
098700200529      ** +--------------------------------------+
098800200529
098900200529      /COPY MECPYSRC,ME1100_ILE
099000200529
099100200529      ** +--------------------------------------+
099200200529      ** ¦ End of D-specs                       ¦
099300200529      ** ¦ ==============                       ¦
099400200529      ** +--------------------------------------+
099500200529
099600200529      ** +----------------------------------------+
099700200529      ** ¦ Hook for non-core D-specs (all types)  ¦
099800200529      ** ¦ also any I-specs (if necessary)        ¦
099900200529      ** ¦ =====================================  ¦
100000200529      ** +----------------------------------------+
100100200529
100200200529     D OVERRIDE        S              1                                                       CFT115
100300200529     D SOVRO           S             10                                                       CFT115
100400200529     D SPWRD           S             10                                                       CFT115
100500200529     D BtnPressed      S             10A                                                   AR1090283
100600200529      /COPY WNCPYSRC,FTIPAYV002
100700200529
100800200529      *****************************************************************
100900200529      /EJECT
101000200529      *****************************************************************
101100200529      ** +--- Start of main processing -----------------------------------+
101200200529      ** ¦                                                                ¦
101300200529      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
101400200529      ** ¦ executed at program activation.                                ¦
101500200529      ** ¦                                                                ¦
101600200529      ** +----------------------------------------------------------------+
101700200529      *                                                                                      BUG7029
101800200529      ** Retrieve ZMUSER details.                                                            BUG7029
101900200529      *                                                                                      BUG7029
102000200529     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7029
102100200529     C                   IN        ZMUSER                                                    BUG7029
102200200529
102300200529      /COPY WNCPYSRC,FTIPAYV003
102400200529
102500200529      ** Incoming transaction is broken into 500A fields, so that a common CL
102600200529      ** can be used between this module and the one that read the MQ queue.
102700200529      ** This module needs to break these 500A fields by loading them into
102800200529      ** the appropriate (externally described) data structure.
102900200529
103000200529     C**********         MOVEL     Trans5001     TranInIPY1                                  CSF011A
103100200529     C                   MOVEL     Trans01       TranInIPY1                                  CSF011A
103200200529     C                   MOVEL     Trans5002     TranInIP1A
103300200529     C**********         MOVEL     Trans5003     TranInIPY2                                  CSF011A
103400200529     C                   MOVEL     Trans03       TranInIPY2                                  CSF011A
103500200529     C                   MOVEL     Trans5004     TranInIPY3
103600200529     C**********         MOVEL     Trans5005     TranInIPY4                                  CSF011A
103700200529     C                   MOVEL     Trans05       TranInIPY4                                  CSF011A
103800200529     C                   MOVEL     Trans5006     TranInIP4A
103900200529     C                   MOVEL     Trans5007     TranInIPY5
104000200529     C                   MOVEL     Trans5008     TranInIPY6
104100200529     C                   IF        CSW209 = 'Y'                                               CSW209
104200200529     C                   MOVEL     Trans5009     TranInIPY7                                   CSW209
104300200529     C                   MOVEL     Trans5010     TranInIPY8                                   CSW209
104400200529     C                   ENDIF                                                                CSW209
104500200529     C**********         MOVEL     Trans5009     TranInIP6A                            CER030 262664
104600200529     C                   MOVEL     Trans5008A    TranInIP6A                                   262664
104700200529     C                   MOVEL     Trans5011     TranInIPY9                                   CER049
104800200529     C                   MOVEL     RegData500    RegData                                      CER001
104900200529     C/COPY WNCPYSRC,FTIPAYV021
105000200529     C                   MOVEL     Extdata500    Extdata
105100200529     C
105200200529     C     NewButton     Ifeq      'YES'                                                      255190
105300200529     C                   Eval      PMTPY = *blanks                                            255190
105400200529     C                   Eval      NewButton = *blanks                                        255190
105500200529     C                   Else                                                                 255190
105600200529     C                   Eval      PMTPY = NewButton                                          255190
105700200529     C                   Endif                                                                255190
105800200529
105900200529      ** Reset variables gradually updated
106000200529     C                   EXSR      ResetCycle
106100200529
106200200529      /COPY WNCPYSRC,FTIPAYV004
106300200529
106400200529      ** Validate action code
106500200529     C*****DDACTN        IFNE      'S'                                                BUG1282 CFT157
106600200529     C*****DDACTN        IFNE      'C'                                               CFT157 MD037938
106700200529     C*****CFT157        IFEQ      'N'                                             MD037938 MD038991
106800200529     C     DDSWFLG       IFEQ      'Y'                                                      MD038991
106900200529     C     DDACTN        ANDNE     'S'                                                      MD037938
107000200529     C*****CFT157        OREQ      'Y'                                             MD037938 MD038991
107100200529     C     DDSWFLG       ORNE      'Y'                                                      MD038991
107200200529     C     DDACTN        ANDNE     'C'                                                      MD037938
107300200529     C                   EXSR      ValidateAc
107400200529     C                   ELSE                                                                BUG1282
107500200529      *                                                                                      BUG1282
107600200529      ** Delete reserved messages if user presses cancel                                     BUG1282
107700200529      *                                                                                      BUG1282
107800200529     C                   MOVEL     DDSEQNO       WSEQNO                                       257943
107900200529                                                                                              257943
108000200529     C     WSEQNO        IFEQ      0                                                          257943
108100200529     C                   Z-ADD     1             PKPRT                                        257943
108200200529     C                   ELSE                                                                 257943
108300200529     C                   Z-ADD     WSEQNO        PKPRT                                        257943
108400200529     C                   ENDIF                                                                257943
108500200529     C     DDSWTN        CHAIN     @INCRL2                                                    257943
108600200529     C                   IF        %FOUND (MEINCRL2)                                          257943
108700200529     C                   EVAL      PMSGR = CRMSGR                                             257943
108800200529     C                   ELSE                                                                 257943
108900200529     C     DDSWTN        CHAIN     @INCRL3                                                    257943
109000200529     C                   IF        %FOUND (MEINCRL3)                                          257943
109100200529     C                   EVAL      PMSGR = CRMSGR                                             257943
109200200529     C                   ENDIF                                                                257943
109300200529     C                   ENDIF                                                                257943
109400200529                                                                                              257943
109500200529     C                   EXSR      DlRsMsg                                                   BUG1282
109600200529     C                   EVAL      *INLR = *ON                                               BUG1282
109700200529     C                   RETURN                                                              BUG1282
109800200529     C                   ENDIF                                                               BUG1282
109900200529
110000200529      /COPY WNCPYSRC,FTIPAYV005
110100200529
110200200529      ** If error in validation of action code, fail this input
110300200529     C                   IF        Idx <> 0
110400200529     C                   GOTO      INVALID
110500200529     C                   ENDIF
110600200529
110700200529      ** Processing depends upon action code
110800200529     C                   SELECT
110900200529
111000200529      ** INSERT
111100200529      ** ======
111200200529     C                   WHEN         DDACTN = 'I'
111300200529
111400200529      ** Set up necessary swift fields if swift reference is entered and
111500200529      ** it is still not yet reserved.
111600200529     C                   IF        DDSWTN <> *BLANKS AND
111700200529     C                             DDSWFLG <> 'Y'
111800200529     C                   EXSR      SrEISwft
111900200529      *                                                                                       BUG515
112000200529     C                   IF        Idx <> 0                                                   BUG515
112100200529     C                   GOTO      INVALID                                                    BUG515
112200200529     C                   ENDIF                                                                BUG515
112300200529      *                                                                                       BUG515
112400200529     C                   ENDIF
112500200529
112600200529      /COPY WNCPYSRC,FTIPAYV006
112700200529
112800200529      ** Validate incoming Incoming Payment details.
112900200529     C                   EXSR      ValidateTr
113000200529
113100200529      /COPY WNCPYSRC,FTIPAYV007
113200200529
113300200529      ** AMEND
113400200529      ** =====
113500200529     C                   WHEN         DDACTN = 'A'
113600200529
113700200529      /COPY WNCPYSRC,FTIPAYV008
113800200529
113900200529      ** Convert original Incoming Payment details from file
114000200529      ** to screen format.
114100200529     C                   EXSR      ConvertIPAY
114200200529
114300200529      /COPY WNCPYSRC,FTIPAYV009
114400200529
114500200529      ** Check if there are substitutions in the screen
114600200529      ** details.
114700200529     C                   EXSR      ChkDtaSubs
114800200529
114900200529      /COPY WNCPYSRC,FTIPAYV010
115000200529
115100200529      *                                                                                       CFT120
115200200529      ** Following lines taken from CFT009 in FTIPAY4DP no longer used                        CFT120
115300200529      ** in Java front end. Prevents spot rate on CFT009 extension file                       CFT120
115400200529      ** being updated without change to CDRO. Save Charges to the                            CFT120
115500200529      ** debit of field - we  need to know if it changes and we need                          CFT120
115600200529      ** to re-call ft000981 in validation modules if it has.                                 CFT120
115700200529      *                                                                                       CFT120
115800200529     C     *LIKE         DEFINE    DDCDRO        PrvDDCDRO                                    CFT120
115900200529     C     *LIKE         DEFINE    DDCDRC        PrvDDCDRC                                    CFT120
116000200529     C                   IF        CFT120 = 'Y'                                               CFT120
116100200529     C                   EVAL      PrvDDCDRO = DDCDRO                                         CFT120
116200200529     C                   EVAL      PrvDDCDRC = DDCDRC                                         CFT120
116300200529     C                   ENDIF                                                                CFT120
116400200529      *                                                                                       CFT120
116500200529      ** Validate incoming Incoming Payment details.
116600200529     C                   EXSR      ValidateTr
116700200529
116800200529      /COPY WNCPYSRC,FTIPAYV011
116900200529
117000200529      ** Check if amended fields are amendable.
117100200529     C                   EXSR      ValidateAmd
117200200529
117300200529      /COPY WNCPYSRC,FTIPAYV012
117400200529
117500200529     C                   ENDSL
117700200529      *
117800200529     C     INVALID       TAG
117900200529
118000200529      ** Populate Account Details                                                             CSF011
118100200529                                                                                              CSF011
118200200529     C                   EXSR      SrCustActN                                                 CSF011
118300200529                                                                                              CSF011
118400200529      /COPY WNCPYSRC,FTIPAYV013
118500200529
118600200529      ** Write to database
118700200529     C                   IF        UpdateYN = 'Y' AND
118800200529     C                             Idx = 0 AND
118900200529     C                             WErr = *BLANK
119000200529
119100200529      /COPY WNCPYSRC,FTIPAYV014
119200200529     C                   EXSR      SetUpValid
119300200529     C                   EXSR      UpdateDB
119400200529      *                                                                                      BUG3279
119500200529      * Clear any reserved messages by this job                                              BUG3279
119600200529     C     DDSWFLG       IFEQ      'Y'                                                       BUG3279
119700200529     C                   EXSR      DlRsMsg                                                   BUG3279
119800200529     C                   ENDIF                                                               BUG3279
119900200529     C                   ENDIF
120000200529
120100200529      ** Set up default charges and currencies in TranInIPY6
120200200529
120300200529     C                   EVAL      %SUBST(TranInIPY6:11:196) = PCharges
120400200529     C                   EVAL      WPICCY = PICCY
120500200529     C                   EVAL      WPOCCY = POCCY
120600200529      *                                                                                       255190
120700200529      ** If error occurred, save IPINMTPY to SavedPMTPY, else blank                           255190
120800200529      *                                                                                       255190
120900200529     C                   Eval      NewButton = IPINMTPY                                       255190
121000200529
121100200529      ** Remerge buffer with all relevant data structures
121200200529
121300200529     C                   EVAL      Buffer = TranInIPY1 + TranInIP1A +
121400200529     C                                      TranInIPY2 + TranInIPY3 +
121500200529     C                                      TranInIPY4 + TranInIP4A +
121600200529     C                                      TranInIPY5 + TranInIPY6 +
121700200529     C                                           OVERRIDE + SOVRO                             CFT115
121800200529     C                                           + SPWRD +                                    CFT115
121900200529     C                                      TranInIPY7 + TranInIPY8 +                         CSW209
122000200529     C                                      TranInIP6A +                                      CER030
122100200529     C                                      @TimeStamp +                                     BUG4196
122200200529     C                                      NewButton +                                       255190
122300200529     C                                      TranInIPY9 +                                      CER049
122400200529     C                                      AAuth +                                           CAP211
122500200529     C                                      BtnPressed +                                   AR1090283
122600200529     C                                      ExtData +                                       MD042042
122700200529     C                                      InputUser +                                     MD042042
122800200529     C                                      RegData +                                       MD050928
122900200529     C                                      StopFTDta                                       MD050928
123000200529     C**********                            RegData                                MD042042 MD050928
123100200529     C**********                            RegData +                                CER001 MD042042
123200200529     C**********                            ExtData                                         MD042042
123300200529
123400200529     C                   EVAL      *INLR = *ON
123500200529
123600200529     C                   RETURN
123700200529
123800200529      *****************************************************************
123900200529      /EJECT
124000200529      *****************************************************************
124100200529
124200200529      ** Hook to enable non-core subroutines to be included
124300200529      /COPY WNCPYSRC,FTIPAYV015
124400200529
124500200529      *****************************************************************
124600200529      /EJECT
124700200529      *****************************************************************
124800200529      *                                                               *
124900200529      * ValidateAc - Routine to validate action code versus the       *
125000200529      *              transaction number supplied                      *
125100200529      *                                                               *
125200200529      *****************************************************************
125300200529     C     ValidateAc    BEGSR
125400200529
125500200529      *                                                                                     MD036159
125600200529      * Set retrieve mode to '*FRONT' (Access using Front Office ID)                        MD036159
125700200529      *  if insert                                                                          MD036159
125800200529      *  if not insert and Midas transaction ID is not present                              MD036159
125900200529      * Otherwise                                                                           MD036159
126000200529      *  Set retrieve mode to blank  (Access using Midas transaction ID).                   MD036159
126100200529      *                                                                                     MD036159
126200200529     C     DDACTN        IFEQ      'I'                                                      MD036159
126300200529     C                   MOVEL     '*FRONT'      PMode                                      MD036159
126400200529     C                   ELSE                                                               MD036159
126500200529     C     DDPREF        IFEQ      *BLANK                                                   MD036159
126600200529     C                   MOVEL     '*FRONT'      PMode                                      MD036159
126700200529     C                   ELSE                                                               MD036159
126800200529     C                   MOVEL     '      '      PMode                                      MD036159
126900200529     C                   ENDIF                                                              MD036159
127000200529     C                   ENDIF                                                              MD036159
127100200529                                                                                            MD036159
127200200529     C                   IF        APFOTRANID <> *BLANKS AND                                MD036159
127300200529     C                             DDACTN  = 'I'                                            MD036159
127400200529     C                   EVAL      PMode = '*FRONT'                                         MD036159
127500200529     C                   ELSE                                                               MD036159
127600200529     C                   MOVEL     '      '      PMode                                      MD036159
127700200529     C                   ENDIF                                                              MD036159
127800200529                                                                                            MD036159
127900200529      ** Validate action code versus transaction IDs supplied
128000200529      ** The Transaction in file format from the FT database is retrieved
128100200529      ** as well.
128200200529
128300200529     C                   CALLB     'FTIPAYRTV'
128400200529      *                             =========
128500200529      ** INPUT
128600200529      ** =====
128700200529
128800200529      ** Return Code
128900200529     C                   PARM      *BLANKS       RetCodeOut
129000200529
129100200529     C**********         PARM      *BLANKS       PMode                                      MD036159
129200200529     C                   PARM                    PMode                                      MD036159
129300200529
129400200529      ** Response Mode (from caller: A=Asynchronous, S=Synchronous)
129500200529     C                   PARM                    PResponse
129600200529
129700200529      ** Action Code
129800200529     C                   PARM                    DDACTN
129900200529
130000200529      ** Front Office Transaction Id
130100200529     C                   PARM                    APFOTranId
130200200529
130300200529      ** Payment Reference
130400200529     C                   PARM                    DDPREF
130500200529
130600200529      ** Booking Branch
130700200529     C                   PARM                    DDBRCA
130800200529
130900200529      ** SWIFT Reference
131000200529     C                   PARM                    DDSWTN
131100200529
131200200529      ** Entry Point
131300200529     C                   PARM                    PParmLevel
131400200529
131500200529      ** Linked Program
131600200529     C                   PARM                    PLinkPgm
131700200529
131800200529      ** Validate Payment Reference for Insert
131900200529     C                   PARM      'Y'           PPrefInsert
132000200529
132100200529      ** STANDING DATA
132200200529      ** =============
132300200529
132400200529      ** SDBANK - Single Branch Code
132500200529     C                   PARM                    BJSBRC
132600200529      *
132700200529      ** SDGELR - Originating Branch/User Vald Req.
132800200529     C                   PARM                    BKOBUV
132900200529      *
133000200529      ** ZMUSER - Default Branch
133100200529     C                   PARM                    PDBRN
133200200529
133300200529      ** SWITCHABLE FEATURES
133400200529      ** ===================
133500200529
133600200529      ** BLI FT Enhancements Feature
133700200529     C                   PARM                    S01494
133800200529
133900200529      ** BLI VAT Processing Feature
134000200529     C                   PARM                    S01499
134100200529
134200200529      ** FT Batch Auth and Credit Advices
134300200529     C                   PARM                    CFT003
134400200529
134500200529      ** STP Phase 2 MT103
134600200529     C                   PARM                    CFT014
134700200529
134800200529      ** Fees & Charges
134900200529     C                   PARM                    CFT009
135000200529
135100200529      ** OUTPUT
135200200529      ** ======
135300200529
135400200529      ** Error fields/message IDs/message data (arrays) from/to caller
135500200529     C                   PARM                    FldNameArr
135600200529     C                   PARM                    MsgIdArr
135700200529     C                   PARM                    MsgDtaArr
135800200529
135900200529      ** Array index (3P0) from/to caller
136000200529     C                   PARM                    Idx
136100200529
136200200529      ** OK Action Code
136300200529     C                   PARM                    OKACTN
136400200529
136500200529      ** OK Payment Reference
136600200529     C                   PARM                    OKPREF
136700200529
136800200529      ** OK Booking Branch
136900200529     C                   PARM                    OKBRCA
137000200529
137100200529      ** Incoming Payments retrieved from file - file format
137200200529     C                   PARM                    IPAYFilFmt
137300200529     C                   PARM                    IPY2FilFmt
137400200529
137500200529      /COPY WNCPYSRC,FTIPAYV016
137600200529                                                                                              CER001
137700200529     C                   IF        ULX043 = 'Y'                                               CER001
137800200529                                                                                              CER001
137900200529     C                   CALLB     'FTIPAY2RV'                                                CER001
138000200529      *                                                                                       CER001
138100200529      ** Inputs                                                                               CER001
138200200529      *                                                                                       CER001
138300200529      ** Return code                                                                          CER001
138400200529      *                                                                                       CER001
138500200529     C                   PARM      *BLANKS       PRetCodeIn                                   CER001
138600200529      *                                                                                       CER001
138700200529      ** Action Code                                                                          CER001
138800200529      *                                                                                       CER001
138900200529     C                   PARM      DDACTN        PActn                                        CER001
139000200529      *                                                                                       CER001
139100200529      ** Front Office Transaction ID                                                          CER001
139200200529      *                                                                                       CER001
139300200529     C                   PARM      APFOTranId    PFrontID                                     CER001
139400200529      *                                                                                       CER001
139500200529      ** Payment Reference                                                                    CER001
139600200529      *                                                                                       CER001
139700200529     C                   PARM      DDPREF        PPayRef                                      CER001
139800200529      *                                                                                       CER001
139900200529      ** Outputs                                                                              CER001
140000200529      *                                                                                       CER001
140100200529      ** incoming payment extension details                                                   CER001
140200200529      *                                                                                       CER001
140300200529     C                   PARM                    IPAYExFilFmt                                 CER001
140400200529      *                                                                                       CER001
140500200529      ** Move the retrieved data to valid incoming payment extension DS                       CER001
140600200529      *                                                                                       CER001
140700200529     C                   EVAL      #LLXIPFOTR = PFrontID                                      CER001
140800200529     C                   EVAL      #LLXIPPREF = PPayRef                                       CER001
140900200529     C                   EVAL      #LLXIPORTY = INORTY                                        CER001
141000200529     C                   EVAL      #LLXIPBETY = INBETY                                        CER001
141100200529     C                   EVAL      #LLXIPOPCO = INOPCO                                        CER001
141200200529     C                   EVAL      #LLXIPCOCO = INCOCO                                        CER001
141300200529     C                   EVAL      #LLXIPIDCO = INIDCO                                        CER001
141400200529     C                   EVAL      #LLXIPIDEN = INIDEN                                        CER001
141500200529                                                                                              CER001
141600200529     C                   ENDIF                                                                CER001
141700200529                                                                                              CER001
141800200529
141900200529     C                   ENDSR
142000200529      *****************************************************************
142100200529      /EJECT
142200200529      *****************************************************************
142300200529      *                                                               *
142400200529      *  ConvertIPAY - Convert Incoming Payment details from file to  *
142500200529      *                screen format                                  *
142600200529      *                                                               *
142700200529      *****************************************************************
142800200529
142900200529     C     ConvertIPAY   BEGSR
143000200529
143100200529     C                   CALLB     'FTIPAYCVT'
143200200529      *                             =========
143300200529      ** INPUT
143400200529      ** =====
143500200529
143600200529      ** Return Code
143700200529     C                   PARM      *BLANKS       RetCodeOut
143800200529
143900200529      ** Incoming Payments retrieved from file - file format
144000200529     C                   PARM                    IPAYFilFmt
144100200529     C                   PARM                    IPY2FilFmt
144200200529
144300200529      ** Action Code
144400200529     C                   PARM                    DDACTN
144500200529
144600200529      ** STANDING DATA
144700200529      ** =============
144800200529
144900200529      ** SDBANK - Single Branch Code
145000200529     C                   PARM                    BJSBRC
145100200529
145200200529      ** SDBANK - Date Format Indicator
145300200529     C                   PARM                    BJDFIN
145400200529
145500200529      ** SDBANK - Base Currency Code
145600200529     C                   PARM                    BJCYCD
145700200529
145800200529      ** SDBANK - Local Currency Code
145900200529     C                   PARM                    BJLCCY
146000200529
146100200529      ** SDGELR - Profit Centre Used
146200200529     C                   PARM                    BKPRCU
146300200529
146400200529      ** SDGELR - Originating Branch Used
146500200529     C                   PARM                    BKOBRU
146600200529
146700200529      ** SDMMOD - Analytical Accounting
146800200529     C                   PARM                    BGN0ST
146900200529
147000200529      ** SDFTFR - Charges Currency
147100200529     C                   PARM                    BTCHCY
147200200529
147300200529      ** SDFTFR - Fixed Charge Currency
147400200529     C                   PARM                    FCHCCY
147500200529
147600200529      ** SWITCHABLE FEATURES
147700200529      ** ===================
147800200529
147900200529      ** EMU FT Settlement Currency Conversion
148000200529     C                   PARM                    CEU006
148100200529
148200200529      ** BLI Funds Transfer Enhancement Feature
148300200529     C                   PARM                    S01494
148400200529
148500200529      ** BLI VAT Processing Feature
148600200529     C                   PARM                    S01499
148700200529
148800200529      ** Electronic Banking Interface IATs and TPPs
148900200529     C                   PARM                    CGL009
149000200529
149100200529      ** STP Phase 2 MT103
149200200529     C                   PARM                    CFT014
149300200529
149400200529      ** Fees & Charges
149500200529     C                   PARM                    CFT009
149600200529     C                   PARM                    CFT010
149700200529
149800200529      ** OUTPUT
149900200529      ** ======
150000200529
150100200529      ** Incoming Payments Lvl 1 Scrn details retrieved from file
150200200529      ** - screen format
150300200529     C                   PARM                    CurTrIPY1
150400200529     C                   PARM                    CurTrIP1A
150500200529
150600200529      ** Incoming Payments Lvl 2 Scrn 1/1 details retrieved from file
150700200529      ** - screen format
150800200529     C                   PARM                    CurTrIPY2
150900200529
151000200529      ** Incoming Payments Lvl 2 Scrn 1/2 details retrieved from file
151100200529      ** - screen format
151200200529     C                   PARM                    CurTrIPY3
151300200529
151400200529      ** Incoming Payments Lvl 2 Scrn 2 details retrieved from file
151500200529      ** - screen format
151600200529     C                   PARM                    CurTrIPY4
151700200529     C                   PARM                    CurTrIP4A
151800200529
151900200529      ** Incoming Payments Lvl 2 Scrn 3 details retrieved from file
152000200529      ** - screen format
152100200529     C                   PARM                    CurTrIPY5
152200200529
152300200529      ** Incoming Payments Margin Info details retrieved from file
152400200529      ** - screen format
152500200529     C                   PARM                    CurTrIPY6
152600200529      *                                                                                       CSW209
152700200529      ** Incoming Payments Lvl 2 Scrn 7 details retrieved from file                           CSW209
152800200529      ** - screen format                                                                      CSW209
152900200529     C                   PARM                    CurTrIPY7                                    CSW209
153000200529      *                                                                                       CSW209
153100200529      ** Incoming Payments Lvl 2 Scrn 8 details retrieved from file                           CSW209
153200200529      ** - screen format                                                                      CSW209
153300200529     C                   PARM                    CurTrIPY8                                    CSW209
153400200529      *                                                                                       CER030
153500200529      ** Incoming Payments Extended Narratives retrieved from file                            CER030
153600200529      ** - screen format                                                                      CER030
153700200529      *                                                                                       CER030
153800200529     C                   PARM                    CurTrIP6A                                    CER030
153900200529
154000200529      ** DS for Additional Information details
154100200529     C                   PARM                    PAddInfm
154200200529
154300200529      ** SWIFT Reference
154400200529     C                   PARM                    DDSWTN
154500200529
154600200529      ** Sequence No.
154700200529     C                   PARM                    DDSEQNO
154800200529
154900200529      ** Incoming Payment Status
155000200529     C                   PARM                    PStatus
155100200529
155200200529      ** Payment Type
155300200529     C                   PARM                    PPYTP
155400200529
155500200529      ** DS for Default Charge Amounts
155600200529     C                   PARM                    PCharges
155700200529
155800200529      ** Input Charge Currency
155900200529     C                   PARM                    PICCY
156000200529
156100200529      ** Output Charge Currency
156200200529     C                   PARM                    POCCY
156300200529
156400200529      ** Input Charge Currency No. of Decimal Places
156500200529     C                   PARM                    PINBDP
156600200529
156700200529      ** Output Charge Currency No. of Decimal Places
156800200529     C                   PARM                    PONBDP
156900200529     C                   PARM      *BLANKS       BtnPressed                                AR1090283
157000200529
157100200529     C                   ENDSR
157200200529      *****************************************************************
157300200529      /EJECT
157400200529      *****************************************************************
157500200529      *                                                               *
157600200529      *  ChkDtaSubs - Data Substitution Routine                       *
157700200529      *                                                               *
157800200529      *****************************************************************
157900200529
158000200529     C     ChkDtaSubs    BEGSR
158100200529
158200200529      ** Substitute the data for the various parts of the transaction.
158300200529
158400200529     C                   IF        WSUBIP1 = 'Y'
158500200529
158600200529     C                   CLEAR                   PIncData
158700200529     C                   CLEAR                   PCurData
158800200529
158900200529     C                   CALLB     'APDTASUBS'
159000200529      *                             =========
159100200529      ** Return Code
159200200529     C                   PARM      *BLANKS       RetCodeOut
159300200529      ** Substitution Character
159400200529     C                   PARM                    GHSUBS
159500200529      ** Incoming Data
159600200529     C                   PARM      TranInIPY1    PIncData
159700200529      ** Current Data
159800200529     C                   PARM      CurTrIPY1     PCurData
159900200529
160000200529     C                   MOVEL     PIncData      TranInIPY1
160100200529
160200200529     C                   ENDIF
160300200529
160400200529     C                   IF        WSUBIP1a = 'Y'
160500200529
160600200529     C                   CLEAR                   PIncData
160700200529     C                   CLEAR                   PCurData
160800200529
160900200529     C                   CALLB     'APDTASUBS'
161000200529      *                             =========
161100200529      ** Return Code
161200200529     C                   PARM      *BLANKS       RetCodeOut
161300200529      ** Substitution Character
161400200529     C                   PARM                    GHSUBS
161500200529      ** Incoming Data
161600200529     C                   PARM      TranInIP1A    PIncData
161700200529      ** Current Data
161800200529     C                   PARM      CurTrIP1A     PCurData
161900200529
162000200529     C                   MOVEL     PIncData      TranInIP1A
162100200529
162200200529     C                   ENDIF
162300200529
162400200529     C                   IF        WSUBIP2 = 'Y'
162500200529
162600200529     C                   CLEAR                   PIncData
162700200529     C                   CLEAR                   PCurData
162800200529
162900200529     C                   CALLB     'APDTASUBS'
163000200529      *                             =========
163100200529      ** Return Code
163200200529     C                   PARM      *BLANKS       RetCodeOut
163300200529      ** Substitution Character
163400200529     C                   PARM                    GHSUBS
163500200529      ** Incoming Data
163600200529     C                   PARM      TranInIPY2    PIncData
163700200529      ** Current Data
163800200529     C                   PARM      CurTrIPY2     PCurData
163900200529
164000200529     C                   MOVEL     PIncData      TranInIPY2
164100200529
164200200529     C                   ENDIF
164300200529
164400200529     C                   IF        WSUBIP3 = 'Y'
164500200529
164600200529     C                   CLEAR                   PIncData
164700200529     C                   CLEAR                   PCurData
164800200529
164900200529     C                   CALLB     'APDTASUBS'
165000200529      *                             =========
165100200529      ** Return Code
165200200529     C                   PARM      *BLANKS       RetCodeOut
165300200529      ** Substitution Character
165400200529     C                   PARM                    GHSUBS
165500200529      ** Incoming Data
165600200529     C                   PARM      TranInIPY3    PIncData
165700200529      ** Current Data
165800200529     C                   PARM      CurTrIPY3     PCurData
165900200529
166000200529     C                   MOVEL     PIncData      TranInIPY3
166100200529
166200200529     C                   ENDIF
166300200529
166400200529     C                   IF        WSUBIP4 = 'Y'
166500200529
166600200529     C                   CLEAR                   PIncData
166700200529     C                   CLEAR                   PCurData
166800200529
166900200529     C                   CALLB     'APDTASUBS'
167000200529      *                             =========
167100200529      ** Return Code
167200200529     C                   PARM      *BLANKS       RetCodeOut
167300200529      ** Substitution Character
167400200529     C                   PARM                    GHSUBS
167500200529      ** Incoming Data
167600200529     C                   PARM      TranInIPY4    PIncData
167700200529      ** Current Data
167800200529     C                   PARM      CurTrIPY4     PCurData
167900200529
168000200529     C                   MOVEL     PIncDATA      TranInIPY4
168100200529
168200200529     C                   ENDIF
168300200529
168400200529     C                   IF        WSUBIP4a = 'Y'
168500200529
168600200529     C                   CLEAR                   PIncData
168700200529     C                   CLEAR                   PCurData
168800200529
168900200529     C                   CALLB     'APDTASUBS'
169000200529      *                             =========
169100200529      ** Return Code
169200200529     C                   PARM      *BLANKS       RetCodeOut
169300200529      ** Substitution Character
169400200529     C                   PARM                    GHSUBS
169500200529      ** Incoming Data
169600200529     C                   PARM      TranInIP4A    PIncData
169700200529      ** Current Data
169800200529     C                   PARM      CurTrIP4A     PCurData
169900200529
170000200529     C                   MOVEL     PIncData      TranInIP4A
170100200529
170200200529     C                   ENDIF
170300200529
170400200529     C                   IF        WSUBIP5 = 'Y'
170500200529
170600200529     C                   CLEAR                   PIncData
170700200529     C                   CLEAR                   PCurData
170800200529
170900200529     C                   CALLB     'APDTASUBS'
171000200529      *                             =========
171100200529      ** Return Code
171200200529     C                   PARM      *BLANKS       RetCodeOut
171300200529      ** Substitution Character
171400200529     C                   PARM                    GHSUBS
171500200529      ** Incoming Data
171600200529     C                   PARM      TranInIPY5    PIncData
171700200529      ** Current Data
171800200529     C                   PARM      CurTrIPY5     PCurData
171900200529
172000200529     C                   MOVEL     PIncData      TranInIPY5
172100200529
172200200529     C                   ENDIF
172300200529
172400200529     C                   IF        WSUBIP6 = 'Y'
172500200529
172600200529     C                   CLEAR                   PIncData
172700200529     C                   CLEAR                   PCurData
172800200529
172900200529     C                   CALLB     'APDTASUBS'
173000200529      *                             =========
173100200529      ** Return Code
173200200529     C                   PARM      *BLANKS       RetCodeOut
173300200529      ** Substitution Character
173400200529     C                   PARM                    GHSUBS
173500200529      ** Incoming Data
173600200529     C                   PARM      TranInIPY6    PIncData
173700200529      ** Current Data
173800200529     C                   PARM      CurTrIPY6     PCurData
173900200529
174000200529     C                   MOVEL     PIncData      TranInIPY6
174100200529
174200200529     C                   ENDIF
174300200529
174400200529     C                   ENDSR
174500200529      *****************************************************************
174600200529      /EJECT                                                                                  CSF011
174700200529      *****************************************************************                       CSF011
174800200529      *                                                               *                       CSF011
174900200529      * SrCustActN - Get the Customer or Account Details              *                       CSF011
175000200529      *                                                               *                       CSF011
175100200529      *****************************************************************                       CSF011
175200200529     C     SrCustActN    BEGSR                                                                CSF011
175300200529                                                                                              CSF011
175400200529      ** Customer fields for retrieval of details                                             CSF011
175500200529                                                                                              CSF011
175600200529     C                   EVAL      %SUBST(WNumDetlIn:1:35)   = DDSND1                         CSF011
175700200529     C                   EVAL      %SUBST(WNumDetlIn:36:35)  = DDRCO1                         CSF011
175800200529     C                   EVAL      %SUBST(WNumDetlIn:71:35)  = DDBNC1                         CSF011
175900200529     C                   EVAL      %SUBST(WNumDetlIn:106:35) = DDTRIB                         CSF011
176000200529     C                   EVAL      %SUBST(WNumDetlIn:141:35) = DDACBK                         CSF011
176100200529     C                   EVAL      %SUBST(WNumDetlIn:176:35) = DDOBK1                         CSF011
176200200529     C                   EVAL      %SUBST(WNumDetlIn:211:35) = DDORC1                         CSF011
176300200529     C                   EVAL      %SUBST(WNumDetlIn:246:35) = DDSNC1                         CSF011
176400200529     C                   EVAL      %SUBST(WNumDetlIn:281:35) = DDINB1                         CSF011
176500200529     C                   EVAL      %SUBST(WNumDetlIn:316:35) = DDCDRO                         CSF011
176600200529                                                                                              CSF011
176700200529      ** With '/' Account                                                                     CSF011
176800200529                                                                                              CSF011
176900200529     C                   IF        %SUBST(DDSND1:1:1) = '/'                                   CSF011
177000200529     C                   IF        DDSND2 <> *BLANKS                                          CSF011
177100200529     C                   EVAL      %SUBST(WNumDetlIn:1:35) = DDSND2                           CSF011
177200200529     C                   ELSE                                                                 CSF011
177300200529     C                   EVAL      WNStr= *BLANKS                                             CSF011
177400200529     C                   EVAL      WNStr= %SUBST(DDSND1:2:34)                                 CSF011
177500200529     C                   EVAL      %SUBST(WNumDetlIn:1:35) = WNStr                            CSF011
177600200529     C                   ENDIF                                                                CSF011
177700200529     C                   ENDIF                                                                CSF011
177800200529                                                                                              CSF011
177900200529     C                   IF        %SUBST(DDRCO1:1:1) = '/'                                   CSF011
178000200529     C                   IF        DDRCO2 <> *BLANKS                                          CSF011
178100200529     C                   EVAL      %SUBST(WNumDetlIn:36:35)  = DDRCO2                         CSF011
178200200529     C                   ELSE                                                                 CSF011
178300200529     C                   EVAL      WNStr= *BLANKS                                             CSF011
178400200529     C                   EVAL      WNStr= %SUBST(DDRCO1:2:34)                                 CSF011
178500200529     C                   EVAL      %SUBST(WNumDetlIn:36:35)  = WNStr                          CSF011
178600200529     C                   ENDIF                                                                CSF011
178700200529     C                   ENDIF                                                                CSF011
178800200529                                                                                              CSF011
178900200529     C                   IF        %SUBST(DDBNC1:1:1) = '/'                                   CSF011
179000200529     C                   IF        DDBNC2 <> *BLANKS                                          CSF011
179100200529     C                   EVAL      %SUBST(WNumDetlIn:71:35)  = DDBNC2                         CSF011
179200200529     C                   ELSE                                                                 CSF011
179300200529     C                   EVAL      WNStr= *BLANKS                                             CSF011
179400200529     C                   EVAL      WNStr= %SUBST(DDBNC1:2:34)                                 CSF011
179500200529     C                   EVAL      %SUBST(WNumDetlIn:71:35)  = WNStr                          CSF011
179600200529     C                   ENDIF                                                                CSF011
179700200529     C                   ENDIF                                                                CSF011
179800200529                                                                                              CSF011
179900200529     C                   IF        %SUBST(DDOBK1:1:1) = '/'                                   CSF011
180000200529     C                   IF        DDOBK2 <> *BLANKS                                          CSF011
180100200529     C                   EVAL      %SUBST(WNumDetlIn:176:35) = DDOBK2                         CSF011
180200200529     C                   ELSE                                                                 CSF011
180300200529     C                   EVAL      WNStr= *BLANKS                                             CSF011
180400200529     C                   EVAL      WNStr= %SUBST(DDOBK1:2:34)                                 CSF011
180500200529     C                   EVAL      %SUBST(WNumDetlIn:176:35) = WNStr                          CSF011
180600200529     C                   ENDIF                                                                CSF011
180700200529     C                   ENDIF                                                                CSF011
180800200529                                                                                              CSF011
180900200529     C                   IF        %SUBST(DDORC1:1:1) = '/'                                   CSF011
181000200529     C                   IF        DDORC2 <> *BLANKS                                          CSF011
181100200529     C                   EVAL      %SUBST(WNumDetlIn:211:35) = DDORC2                         CSF011
181200200529     C                   ELSE                                                                 CSF011
181300200529     C                   EVAL      WNStr= *BLANKS                                             CSF011
181400200529     C                   EVAL      WNStr= %SUBST(DDORC1:2:34)                                 CSF011
181500200529     C                   EVAL      %SUBST(WNumDetlIn:211:35) = WNStr                          CSF011
181600200529     C                   ENDIF                                                                CSF011
181700200529     C                   ENDIF                                                                CSF011
181800200529                                                                                              CSF011
181900200529     C                   IF        %SUBST(DDSNC1:1:1) = '/'                                   CSF011
182000200529     C                   IF        DDSNC2 <> *BLANKS                                          CSF011
182100200529     C                   EVAL      %SUBST(WNumDetlIn:246:35) = DDSNC2                         CSF011
182200200529     C                   ELSE                                                                 CSF011
182300200529     C                   EVAL      WNStr= *BLANKS                                             CSF011
182400200529     C                   EVAL      WNStr= %SUBST(DDSNC1:2:34)                                 CSF011
182500200529     C                   EVAL      %SUBST(WNumDetlIn:246:35) = WNStr                          CSF011
182600200529     C                   ENDIF                                                                CSF011
182700200529     C                   ENDIF                                                                CSF011
182800200529                                                                                              CSF011
182900200529     C                   IF        %SUBST(DDINB1:1:1) = '/'                                   CSF011
183000200529     C                   IF        DDINB2 <> *BLANKS                                          CSF011
183100200529     C                   EVAL      %SUBST(WNumDetlIn:281:35) = DDINB2                         CSF011
183200200529     C                   ELSE                                                                 CSF011
183300200529     C                   EVAL      WNStr= *BLANKS                                             CSF011
183400200529     C                   EVAL      WNStr= %SUBST(DDINB1:2:34)                                 CSF011
183500200529     C                   EVAL      %SUBST(WNumDetlIn:281:35) = WNStr                          CSF011
183600200529     C                   ENDIF                                                                CSF011
183700200529     C                   ENDIF                                                                CSF011
183800200529                                                                                              CSF011
183900200529     C                   DOW       CusIdx <= NoOfCusField                                     CSF011
184000200529                                                                                              CSF011
184100200529     C                   EVAL      P@Str = %SUBST(WNumDetlIn:CusIdx2:35)                      CSF011
184200200529     C                   EVAL      W@Abc = %SUBST(CusOrAcc:CusIdx:1)                          CSF011
184300200529                                                                                              CSF011
184400200529     C                   IF        P@Str <> *BLANKS                                           CSF011
184500200529                                                                                              CSF011
184600200529     C                   IF        W@Abc = 'B'                                                CSF011
184700200529                                                                                              CSF011
184800200529     C                   EVAL      WCustomer = *BLANKS                                        CSF011
184900200529     C                   CALL      'AOCUSTR0'                                                 CSF011
185000200529     C                   PARM      *BLANKS       @RTCD                                        CSF011
185100200529     C                   PARM      '*KEY'        @OPTN                                        CSF011
185200200529     C                   PARM                    P@Str                                        CSF011
185300200529     C                   PARM      *BLANKS       C#KYST                                       CSF011
185400200529     C     SDCUST        PARM      SDCUST        DSSDY                                        CSF011
185500200529                                                                                              CSF011
185600200529     C                   ENDIF                                                                CSF011
185700200529                                                                                              CSF011
185800200529     C                   CALL      'AOIBANR2'                                                 CSF011
185900200529     C                   PARM      *Blanks       @RTCD                                        CSF011
186000200529     C                   PARM                    P@Str                                        CSF011
186100200529     C                   PARM                    DSSDY                                        CSF011
186200200529                                                                                              CSF011
186300200529     C                   IF        @RTCD = *BLANKS                                            CSF011
186400200529     C                   EVAL      ACCNT_AC = DSSDY                                           CSF011
186500200529     C                   EVAL      WCustomer = AC_CNUM                                        CSF011
186600200529                                                                                              CSF011
186700200529     C                   ELSE                                                                 CSF011
186800200529                                                                                              CSF011
186900200529     C                   EVAL      W@CCY = DDSMCY                                             CSF011
187000200529     C                   EVAL      W@BRC = DDORBR                                             CSF011
187100200529     C                   IF        (CusIdx = 3 AND DDPCCY <> *BLANKS)                         CSF011
187200200529     C                             OR (CusIdx = 5 AND DDPCCY <> *BLANKS)                      CSF011
187300200529     C                             OR (CusIdx = 8 AND DDPCCY <> *BLANKS)                      CSF011
187400200529     C                   EVAL      W@CCY = DDPCCY                                             CSF011
187500200529     C                   ENDIF                                                                CSF011
187600200529     C                   IF        CusIdx = 5 AND DDACBB <> *BLANKS                           CSF011
187700200529     C                   EVAL      W@BRC = DDACBB                                             CSF011
187800200529     C                   ENDIF                                                                CSF011
187900200529     C                   IF        CusIdx = 10 AND DDCDBR <> *BLANKS                          CSF011
188000200529     C                   EVAL      W@BRC = DDCDBR                                             CSF011
188100200529     C                   ENDIF                                                                CSF011
188200200529                                                                                              CSF011
188300200529      ** Format Full GL Account                                                               CSF011
188400200529      ** Format Partial Account                                                               CSF011
188500200529      ** Format Nostro Account                                                                CSF011
188600200529                                                                                              CSF011
188700200529     C                   SELECT                                                               CSF011
188800200529     C                   WHEN      %LEN(%TRIM(P@Str)) = 24                                    CSF011
188900200529     C                   EVAL      P@Str = %SUBST(P@Str:22:3)                                 CSF011
189000200529     C                             + %SUBST(P@Str:1:21)                                       CSF011
189100200529     C                   WHEN      %LEN(%TRIM(P@Str)) = 21                                    CSF011
189200200529     C                   EVAL      P@Str = %SUBST(P@Str:19:3) +                               CSF011
189300200529     C                             %SUBST(P@Str:1:6) + W@CCY +                                CSF011
189400200529     C                             %SUBST(P@Str:7:12)                                         CSF011
189500200529     C                   WHEN      %LEN(%TRIM(P@Str)) = 18                                    CSF011
189600200529     C                   EVAL      P@Str = W@BRC +                                            CSF011
189700200529     C                             %SUBST(P@Str:1:6) + W@CCY +                                CSF011
189800200529     C                             %SUBST(P@Str:7:12)                                         CSF011
189900200529     C                   WHEN      %LEN(%TRIM(P@Str)) = 2                                     CSF011
190000200529     C                   EVAL      P@Str = W@CCY + %SUBST(P@Str:1:2)                          CSF011
190100200529                                                                                              CSF011
190200200529     C                   ENDSL                                                                CSF011
190300200529                                                                                              CSF011
190400200529     C                   CALL      'AOACCTV1'                                                 CSF011
190500200529     C                   PARM      *BLANKS       @RTCD                                        CSF011
190600200529     C                   PARM      *BLANKS       P@TYP                                        CSF011
190700200529     C                   PARM                    P@Str                                        CSF011
190800200529     C                   PARM                    DSSDY                                        CSF011
190900200529                                                                                              CSF011
191000200529      ** Retrieve Account Details, Customer Report Name,                                      CSF011
191100200529      ** and Town, Account Name and Swift ID                                                  CSF011
191200200529                                                                                              CSF011
191300200529     C                   SELECT                                                               CSF011
191400200529                                                                                              CSF011
191500200529     C                   WHEN      P@TYP = '*RETAIL' OR                                       CSF011
191600200529     C                             P@TYP = '*LEDGER'                                          CSF011
191700200529     C                   EVAL      ACCNT_AC = DSSDY                                           CSF011
191800200529     C                   EVAL      WCustomer = AC_CNUM                                        CSF011
191900200529                                                                                              CSF011
192000200529     C                   WHEN      P@TYP = '*NOSTRO'                                          CSF011
192100200529     C                   EVAL      SDNOST = DSSDY                                             CSF011
192200200529     C                   EVAL      WCustomer = A7CUST                                         CSF011
192300200529     C                   CALL      'AOACCTR0'                                                 CSF011
192400200529     C                   PARM      *BLANKS       @RTCD                                        CSF011
192500200529     C                   PARM      '*KEY   '     @OPTN                                        CSF011
192600200529     C                   PARM      *BLANKS       P0RETL                                       CSF011
192700200529     C                   PARM                    A7CUST                                       CSF011
192800200529     C                   PARM                    A7CYCD                                       CSF011
192900200529     C                   PARM                    A7ACCD                                       CSF011
193000200529     C                   PARM                    A7ACSN                                       CSF011
193100200529     C                   PARM                    A7BRCD                                       CSF011
193200200529     C     ACCNT_AC      PARM                    DSSDY                                        CSF011
193300200529                                                                                              CSF011
193400200529     C                   WHEN      P@TYP = '*CUSTNO' OR                                       CSF011
193500200529     C                             P@TYP = '*SWIFT ' OR                                     MD044395
193600200529     C                             P@TYP = '*SHNAME'                                          CSF011
193700200529     C                   EVAL      SDCUST = DSSDY                                             CSF011
193800200529     C                   EVAL      WCustomer = *BLANKS                                        CSF011
193900200529     C                   EVAL      AC_ANAM  = *BLANKS                                       MD044395
194000200529                                                                                            MD044395
194100200529     C                   IF        P@TYP = '*SWIFT '                                        MD044395
194200200529     C                             AND BBCSSN = *BLANKS                                     MD044395
194300200529     C                   EVAL      BBCSID = *BLANKS                                         MD044395
194400200529     C                   ENDIF                                                              MD044395
194500200529                                                                                              CSF011
194600200529     C                   WHEN      P@TYP = '*NRF   '                                          CSF011
194700200529     C                   EVAL      WCustomer = *BLANKS                                        CSF011
194800200529                                                                                            MD030906
194900200529     C                   WHEN      P@TYP = '*CNST'                                          MD030906
195000200529                                                                                            MD030906
195100200529     C                   EVAL      SDCNST = DSSDY                                           MD030906
195200200529     C                   EVAL      WCustomer = *BLANKS                                      MD030906
195300200529                                                                                            MD030906
195400200529     C                   ENDSL                                                                CSF011
195500200529                                                                                              CSF011
195600200529     C                   ENDIF                                                                CSF011
195700200529                                                                                              CSF011
195800200529     C                   IF         WCustomer <> *BLANKS                                      CSF011
195900200529     C                   CALL      'AOCUSTR0'                                                 CSF011
196000200529     C                   PARM      *BLANKS       @RTCD                                        CSF011
196100200529     C                   PARM      '*KEY'        @OPTN                                        CSF011
196200200529     C                   PARM                    WCustomer                                    CSF011
196300200529     C                   PARM      *BLANKS       C#KYST                                       CSF011
196400200529     C     SDCUST        PARM      SDCUST        DSSDY                                        CSF011
196500200529                                                                                              CSF011
196600200529     C                   ENDIF                                                                CSF011
196700200529                                                                                             CSF011A
196800200529     C                   IF         @RTCD  = *BLANKS                                         CSF011A
196900200529     C                             OR P@TYP = '*CNST'                                       MD030906
197000200529     C                   SELECT                                                              CSF011A
197100200529                                                                                             CSF011A
197200200529      ** Destination                                                                         CSF011A
197300200529     C                   WHEN      CusIdx = 1                                                CSF011A
197400200529     C                   IF        P@TYP = '*CNST'                                          MD030906
197500200529     C                   EVAL      DDSNSN = AWCPNC                                          MD030906
197600200529     C                   EVAL      DDSNNM = AWCPNM                                          MD030906
197700200529     C                   EVAL      DDSNTN = AWCNTN                                          MD030906
197800200529     C                   EVAL      DDSNAN = *BLANKS                                         MD030906
197900200529     C                   EVAL      DDSNSW = AWSWID                                          MD030906
198000200529     C                   ELSE                                                               MD030906
198100200529     C                   EVAL      DDSNSN  = BBCSSN                                          CSF011A
198200200529     C                   EVAL      DDSNNM  = BBCRNM                                          CSF011A
198300200529     C                   EVAL      DDSNTN  = BBCRTN                                          CSF011A
198400200529     C                   EVAL      DDSNAN  = AC_ANAM                                         CSF011A
198500200529     C                   EVAL      DDSNSW  = BBCSID                                          CSF011A
198600200529     C                   ENDIF                                                              MD030906
198700200529                                                                                             CSF011A
198800200529      ** Receivers correspondent                                                             CSF011A
198900200529     C                   WHEN      CusIdx = 2                                                CSF011A
199000200529     C                   IF        P@TYP = '*CNST'                                          MD030906
199100200529     C                   EVAL      DDRCSN = AWCPNC                                          MD030906
199200200529     C                   EVAL      DDRCNM = AWCPNM                                          MD030906
199300200529     C                   EVAL      DDRCTN = AWCNTN                                          MD030906
199400200529     C                   EVAL      DDRCAN = *BLANKS                                         MD030906
199500200529     C                   EVAL      DDRCSW = AWSWID                                          MD030906
199600200529     C                   ELSE                                                               MD030906
199700200529     C                   EVAL      DDRCSN  = BBCSSN                                          CSF011A
199800200529     C                   EVAL      DDRCNM  = BBCRNM                                          CSF011A
199900200529     C                   EVAL      DDRCTN  = BBCRTN                                          CSF011A
200000200529     C                   EVAL      DDRCAN  = AC_ANAM                                         CSF011A
200100200529     C                   EVAL      DDRCSW  = BBCSID                                          CSF011A
200200200529     C                   ENDIF                                                              MD030906
200300200529                                                                                             CSF011A
200400200529      ** Beneficiary                                                                         CSF011A
200500200529     C                   WHEN      CusIdx = 3                                                CSF011A
200600200529     C                   IF        P@TYP = '*CNST'                                          MD030906
200700200529     C                   EVAL      DDBNSN = AWCPNC                                          MD030906
200800200529     C                   EVAL      DDBNNM = AWCPNM                                          MD030906
200900200529     C                   EVAL      DDBNTN = AWCNTN                                          MD030906
201000200529     C                   EVAL      DDBNAN = *BLANKS                                         MD030906
201100200529     C                   EVAL      DDBNSW = AWSWID                                          MD030906
201200200529     C                   ELSE                                                               MD030906
201300200529     C                   EVAL      DDBNSN  = BBCSSN                                          CSF011A
201400200529     C                   EVAL      DDBNNM  = BBCRNM                                          CSF011A
201500200529     C                   EVAL      DDBNTN  = BBCRTN                                          CSF011A
201600200529     C                   EVAL      DDBNAN  = AC_ANAM                                         CSF011A
201700200529     C                   EVAL      DDBNSW  = BBCSID                                          CSF011A
201800200529     C                   ENDIF                                                              MD030906
201900200529                                                                                             CSF011A
202000200529      ** Third Reimbursement Institution                                                     CSF011A
202100200529     C                   WHEN      CusIdx = 4                                                CSF011A
202200200529     C                   IF        P@TYP = '*CNST'                                          MD030906
202300200529     C                   EVAL      DDTRSN = AWCPNC                                          MD030906
202400200529     C                   EVAL      DDTRNM = AWCPNM                                          MD030906
202500200529     C                   EVAL      DDTRTN = AWCNTN                                          MD030906
202600200529     C                   EVAL      DDTRAN = *BLANKS                                         MD030906
202700200529     C                   EVAL      DDTRSW = AWSWID                                          MD030906
202800200529     C                   ELSE                                                               MD030906
202900200529     C                   EVAL      DDTRSN  = BBCSSN                                          CSF011A
203000200529     C                   EVAL      DDTRNM  = BBCRNM                                          CSF011A
203100200529     C                   EVAL      DDTRTN  = BBCRTN                                          CSF011A
203200200529     C                   EVAL      DDTRAN  = AC_ANAM                                         CSF011A
203300200529     C                   EVAL      DDTRSW  = BBCSID                                          CSF011A
203400200529     C                   ENDIF                                                              MD030906
203500200529                                                                                             CSF011A
203600200529      ** Account with Bank                                                                   CSF011A
203700200529     C                   WHEN      CusIdx = 5                                                CSF011A
203800200529     C                   IF        P@TYP = '*CNST'                                          MD030906
203900200529     C                   EVAL      DDABSN = AWCPNC                                          MD030906
204000200529     C                   EVAL      DDABNM = AWCPNM                                          MD030906
204100200529     C                   EVAL      DDABTN = AWCNTN                                          MD030906
204200200529     C                   EVAL      DDABAN = *BLANKS                                         MD030906
204300200529     C                   EVAL      DDABSW = AWSWID                                          MD030906
204400200529     C                   ELSE                                                               MD030906
204500200529     C                   EVAL      DDABSN  = BBCSSN                                          CSF011A
204600200529     C                   EVAL      DDABNM  = BBCRNM                                          CSF011A
204700200529     C                   EVAL      DDABTN  = BBCRTN                                          CSF011A
204800200529     C                   EVAL      DDABAN  = AC_ANAM                                         CSF011A
204900200529     C                   EVAL      DDABSW  = BBCSID                                          CSF011A
205000200529     C                   ENDIF                                                              MD030906
205100200529                                                                                             CSF011A
205200200529      ** Ordering Bank                                                                       CSF011A
205300200529     C                   WHEN      CusIdx = 6                                                CSF011A
205400200529     C                   IF        P@TYP = '*CNST'                                          MD030906
205500200529     C                   EVAL      DDOBSN = AWCPNC                                          MD030906
205600200529     C                   EVAL      DDOBNM = AWCPNM                                          MD030906
205700200529     C                   EVAL      DDOBTN = AWCNTN                                          MD030906
205800200529     C                   EVAL      DDOBSW = AWSWID                                          MD030906
205900200529     C                   ELSE                                                               MD030906
206000200529     C                   EVAL      DDOBSN  = BBCSSN                                          CSF011A
206100200529     C                   EVAL      DDOBNM  = BBCRNM                                          CSF011A
206200200529     C                   EVAL      DDOBTN  = BBCRTN                                          CSF011A
206300200529     C                   EVAL      DDOBSW  = BBCSID                                          CSF011A
206400200529     C                   ENDIF                                                              MD030906
206500200529                                                                                             CSF011A
206600200529      ** Ordering Customer                                                                   CSF011A
206700200529     C                   WHEN      CusIdx = 7                                                CSF011A
206800200529     C                   IF        P@TYP = '*CNST'                                          MD030906
206900200529     C                   EVAL      DDOCSN = AWCPNC                                          MD030906
207000200529     C                   EVAL      DDOCNM = AWCPNM                                          MD030906
207100200529     C                   EVAL      DDOCTN = AWCNTN                                          MD030906
207200200529     C                   EVAL      DDOCAN = *BLANKS                                         MD030906
207300200529     C                   EVAL      DDOCSW = AWSWID                                          MD030906
207400200529     C                   ELSE                                                               MD030906
207500200529     C                   EVAL      DDOCSN  = BBCSSN                                          CSF011A
207600200529     C                   EVAL      DDOCNM  = BBCRNM                                          CSF011A
207700200529     C                   EVAL      DDOCTN  = BBCRTN                                          CSF011A
207800200529     C                   EVAL      DDOCAN  = AC_ANAM                                         CSF011A
207900200529     C                   EVAL      DDOCSW  = BBCSID                                          CSF011A
208000200529     C                   ENDIF                                                              MD030906
208100200529                                                                                             CSF011A
208200200529      ** Ordering Bank                                                                       CSF011A
208300200529     C                   WHEN      CusIdx = 8                                                CSF011A
208400200529     C                   IF        P@TYP = '*CNST'                                          MD030906
208500200529     C                   EVAL      DDSCSN = AWCPNC                                          MD030906
208600200529     C                   EVAL      DDSCNM = AWCPNM                                          MD030906
208700200529     C                   EVAL      DDSCTN = AWCNTN                                          MD030906
208800200529     C                   EVAL      DDSCSW = AWSWID                                          MD030906
208900200529     C                   ELSE                                                               MD030906
209000200529     C                   EVAL      DDSCSN  = BBCSSN                                          CSF011A
209100200529     C                   EVAL      DDSCNM  = BBCRNM                                          CSF011A
209200200529     C                   EVAL      DDSCTN  = BBCRTN                                          CSF011A
209300200529     C                   EVAL      DDSCSW  = BBCSID                                          CSF011A
209400200529     C                   ENDIF                                                              MD030906
209500200529                                                                                             CSF011A
209600200529      ** Intermediary Bank                                                                   CSF011A
209700200529     C                   WHEN      CusIdx = 9                                                CSF011A
209800200529     C                   IF        P@TYP = '*CNST'                                          MD030906
209900200529     C                   EVAL      DDIBSN = AWCPNC                                          MD030906
210000200529     C                   EVAL      DDIBNM = AWCPNM                                          MD030906
210100200529     C                   EVAL      DDIBTN = AWCNTN                                          MD030906
210200200529     C                   EVAL      DDIBSW = AWSWID                                          MD030906
210300200529     C                   ELSE                                                               MD030906
210400200529     C                   EVAL      DDIBSN  = BBCSSN                                          CSF011A
210500200529     C                   EVAL      DDIBNM  = BBCRNM                                          CSF011A
210600200529     C                   EVAL      DDIBTN  = BBCRTN                                          CSF011A
210700200529     C                   EVAL      DDIBSW  = BBCSID                                          CSF011A
210800200529     C                   ENDIF                                                              MD030906
210900200529                                                                                             CSF011A
211000200529      ** Charges to the Debit of Account                                                     CSF011A
211100200529     C                   WHEN      CusIdx = 10                                               CSF011A
211200200529     C                   IF        P@TYP = '*CNST'                                          MD030906
211300200529     C                   EVAL      DDCDSN = AWCPNC                                          MD030906
211400200529     C                   EVAL      DDCDNM = AWCPNM                                          MD030906
211500200529     C                   EVAL      DDCDTN = AWCNTN                                          MD030906
211600200529     C                   EVAL      DDCDAN = *BLANKS                                         MD030906
211700200529     C                   EVAL      DDCDSW = AWSWID                                          MD030906
211800200529     C                   ELSE                                                               MD030906
211900200529     C                   EVAL      DDCDSN  = BBCSSN                                          CSF011A
212000200529     C                   EVAL      DDCDNM  = BBCRNM                                          CSF011A
212100200529     C                   EVAL      DDCDTN  = BBCRTN                                          CSF011A
212200200529     C                   EVAL      DDCDAN  = AC_ANAM                                         CSF011A
212300200529     C                   EVAL      DDCDSW  = BBCSID                                          CSF011A
212400200529     C                   ENDIF                                                              MD030906
212500200529     C                   ENDSL                                                               CSF011A
212600200529     C                   ENDIF                                                               CSF011A
212700200529                                                                                             CSF011A
212800200529     C                   ENDIF                                                                CSF011
212900200529                                                                                              CSF011
213000200529      ** Increment counter fields                                                             CSF011
213100200529                                                                                              CSF011
213200200529     C                   IF        W@Abc = 'A'                                                CSF011
213300200529     C                   Z-ADD     AccLength     W@Len                                        CSF011
213400200529     C                   ELSE                                                                 CSF011
213500200529     C                   Z-ADD     ACusLngth     W@Len                                        CSF011
213600200529     C                   ENDIF                                                                CSF011
213700200529                                                                                              CSF011
213800200529     C                   EVAL      CusIdx = Cusidx + 1                                        CSF011
213900200529     C                   EVAL      CusIdx2 = Cusidx2 + 35                                     CSF011
214000200529                                                                                              CSF011
214100200529     C                   ENDDO                                                                CSF011
214200200529                                                                                              CSF011
214300200529     C                   ENDSR                                                                CSF011
214400200529      *****************************************************************                       CSF011
214500200529      /EJECT
214600200529      *****************************************************************
214700200529      *                                                               *
214800200529      *  ValidateAmd - Routine to check whether the fields are        *
214900200529      *                amendable                                      *
215000200529      *                                                               *
215100200529      *****************************************************************
215200200529      *
215300200529     C     ValidateAmd   BEGSR
215400200529      *
215500200529     C                   CALLB     'FTIPAYAMD'
215600200529      *                             =========
215700200529      ** INPUT
215800200529      ** =====
215900200529
216000200529      ** Return Code
216100200529     C                   PARM      *BLANKS       RetCodeOut
216200200529
216300200529      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
216400200529      ** - screen format
216500200529     C                   PARM                    TranInIPY1
216600200529
216700200529      ** Incoming Payments Lvl 1 Scrn details retrieved from file
216800200529      ** - screen format
216900200529     C                   PARM                    CurTrIPY1
217000200529
217100200529      ** Reset of Fields in Error Required (Y/N)
217200200529     C                   PARM      'N'           PResetFld
217300200529
217400200529      ** STANDING DATA
217500200529      ** =============
217600200529
217700200529      ** SDMMOD - Multibranch Indicator
217800200529     C                   PARM                    BGMBIN
217900200529
218000200529      ** SDGELR - Profit Centre Used
218100200529     C                   PARM                    BKPRCU
218200200529
218300200529      ** SDGELR - Profit Centre Amendable
218400200529     C                   PARM                    BKPRCA
218500200529
218600200529      ** OUTPUT
218700200529      ** ======
218800200529
218900200529      ** Error fields/message IDs/message data (arrays) from/to caller
219000200529     C                   PARM                    AMFldNamAr
219100200529     C                   PARM                    AMMsgIdArr
219200200529     C                   PARM                    AMMsgDtaAr
219300200529
219400200529      ** Array index (3P0) from/to caller
219500200529     C                   PARM                    AmIdx
219600200529
219700200529      ** Incoming Payments Lvl 1 Scrn error indicators
219800200529     C                   PARM                    OKTrIPY1
219900200529
220000200529      ** OK Amendments field
220100200529     C                   PARM                    PAmendOK
220200200529
220300200529      ** If errors occurred, overwrite previous error information.
220400200529
220500200529     C                   IF        AmIdx <> 0
220600200529     C                   MOVEA     AMFldNamAr    FldNameArr
220700200529     C                   MOVEA     AMMsgIdArr    MsgIdArr
220800200529     C                   MOVEA     AMMsgDtaAr    MsgDtaArr
220900200529     C                   Z-ADD     AmIdx         Idx
221000200529     C                   ENDIF
221100200529
221200200529     C                   ENDSR
221300200529      *****************************************************************
221400200529      /EJECT
221500200529      ******************************************************************
221600200529      *                                                                *
221700200529      *  SrEISwift - Routine to set up swift fields based on swift     *
221800200529      *              reference/sequence                                *
221900200529      *                                                                *
222000200529      ******************************************************************
222100200529
222200200529     C     SrEISwft      BEGSR
222300200529
222400200529      ** Initialise screen formats.
222500200529
222600200529     C                   EXSR      SRInScn
222700200529
222800200529      ** Get swift message reference details
222900200529
223000200529     C                   EXSR      SRMKey
223100200529
223200200529     C                   IF        WErr <> *BLANK
223300200529     C                   GOTO      EEISwft
223400200529     C                   ENDIF
223500200529
223600200529      ** Reserve message
223700200529
223800200529     C                   EXSR      SRMsgRsv
223900200529
224000200529      ** If the SWIFT Reference is already allocated to another job,
224100200529      ** then display error messages.
224200200529
224300200529     C                   IF        WErr <> *BLANK
224400200529     C                   GOTO      EEISwft
224500200529     C                   ENDIF
224600200529
224700200529      ** Call ME1100 to translate the data of the messages for FT
224800200529      ** fields.
224900200529
225000200529     C                   CALL      'ME1100'                             0101
225100200529     C                   PARM      '*TRANS  '    PACTD
225200200529     C                   PARM                    PHEAD
225300200529     C                   PARM      *BLANKS       PDATA
225400200529     C                   PARM      *BLANKS       PDAT2                                        CSW209
225500200529     C                   PARM      *BLANKS       PRTN
225600200529
225700200529      ** If call to program resulted in an error, then end program.
225800200529
225900200529     C                   IF        PRTN = '*ERROR*' AND
226000200529     C                             *IN01
226100200529     C                   MOVEL     '*CALL'       DBKEY
226200200529     C                   MOVEL     'ME1100'      DBFILE
226300200529     C                   Z-ADD     1             DBASE
226400200529     C                   EXSR      *PSSR
226500200529     C                   ENDIF
226600200529
226700200529      ** Set up the Detail screen fields from the message.
226800200529
226900200529      ** Sender.
227000200529
227100200529     C                   MOVEL     PSNDR         ODDSND1
227200200529
227300200529     C                   IF        PSN <> *BLANKS
227400200529     C                   MOVEL     PSN           DSTRAN
227500200529     C                   IF        PSNDR = 'CASHIER'
227600200529     C                   MOVEL     PSNAR(1)      TMLIN2
227700200529     C                   ENDIF
227800200529     C                   MOVEL     TMLIN1        ODDSND1
227900200529     C                   MOVEL     TMLIN2        ODDSND2
228000200529     C                   MOVEL     TMLIN3        ODDSND3
228100200529     C                   MOVEL     TMLIN4        ODDSND4
228200200529     C                   ENDIF
228300200529
228400200529      ** Message Type.
228500200529
228600200529     C                   MOVE      PMTPY         IPINMTPY
228700200529
228800200529      ** Msg Unique Reference.
228900200529
229000200529     C                   Z-ADD     PHMSGR        IPINMSGR
229100200529
229200200529      ** SWIFT Reference.
229300200529
229400200529     C                   MOVEL     PHMIR         DDSWTN
229500200529     C                   MOVEL     PHMIR         ODDSWTN
229600200529
229700200529      ** Part Number.
229800200529
229900200529     C                   MOVE      PHPART        DDSEQNO
230000200529     C                   MOVE      PHPART        ODDSEQNO
230100200529     C                   Z-ADD     PHPART        IPINKPRT
230200200529
230300200529      ** SWIFT Priority Code.
230400200529
230500200529     C                   MOVE      PMPRY         ODDSWPC
230600200529
230700200529      ** Branch Code.
230800200529
230900200529     C                   IF        PBRCA <> *BLANKS
231000200529     C                   MOVEL     PBRCA         ODDBRCA
231100200529     C                   ENDIF
231200200529
231300200529      ** Transaction Reference No.
231400200529
231500200529     C                   IF        P20 <> *BLANKS
231600200529     C                   MOVEL     P20           DSTRAN
231700200529     C                   MOVEL     TTREF         IPINTRNO
231800200529     C                   ELSE
231900200529     C                   MOVEL     *BLANKS       IPINTRNO
232000200529     C                   ENDIF
232100200529
232200200529      ** Related Reference.
232300200529
232400200529     C                   IF        P21 <> *BLANKS
232500200529     C                   MOVEL     P21           DSTRAN
232600200529     C                   MOVEL     TTREF         IPRLPR
232700200529     C                   MOVEL     TTREF         ODDRLPR
232800200529     C                   ELSE
232900200529     C                   MOVEL     *BLANKS       IPRLPR
233000200529     C                   ENDIF
233100200529
233200200529     C                   IF        CFT014 = 'Y'
233300200529
233400200529      ** Sender's Charge fields
233500200529
233600200529     C                   IF        P71FX <> *BLANKS
233700200529
233800200529     C                   MOVEL     *BLANK        DSTRAN
233900200529     C                   MOVEL     P71FX         DSTRAN
234000200529     C                   Z-ADD     1             L
234100200529     C                   MOVEL     TMLIN1        TV1
234200200529     C                   MOVEL     TMLIN2        TV2
234300200529     C                   MOVEL     TMLIN3        TV3
234400200529     C                   MOVEL     TMLIN4        TV4
234500200529     C                   MOVEL     TMLIN5        TV5
234600200529
234700200529     C                   DOW       L <= 5  AND
234800200529     C                             LFLT(L) <> *BLANK
234900200529
235000200529     C                   MOVEL     *BLANK        DSTRAN
235100200529     C                   MOVEL     LFLT(L)       DSTRAN
235200200529     C                   EXSR      SrCcyA33B
235300200529
235400200529     C                   SELECT
235500200529     C                   WHEN      L = 1
235600200529     C                   MOVEL     WCAAM         ODDSCH1
235700200529     C                   MOVEL     WCACY         ODDSCC1
235800200529     C                   WHEN      L = 2
235900200529     C                   MOVEL     WCAAM         ODDSCH2
236000200529     C                   MOVEL     WCACY         ODDSCC2
236100200529     C                   WHEN      L = 3
236200200529     C                   MOVEL     WCAAM         ODDSCH3
236300200529     C                   MOVEL     WCACY         ODDSCC3
236400200529     C                   WHEN      L = 4
236500200529     C                   MOVEL     WCAAM         ODDSCH4
236600200529     C                   MOVEL     WCACY         ODDSCC4
236700200529     C                   WHEN      L = 5
236800200529     C                   MOVEL     WCAAM         ODDSCH5
236900200529     C                   MOVEL     WCACY         ODDSCC5
237000200529     C                   ENDSL
237100200529
237200200529     C                   ADD       1             L
237300200529
237400200529     C                   ENDDO
237500200529
237600200529     C                   ENDIF
237700200529
237800200529      ** Receiver's Charge field
237900200529
238000200529     C                   IF        P71G <> *BLANKS
238100200529
238200200529     C                   MOVEL     *BLANK        DSTRAN
238300200529     C                   MOVEL     'N'           I2INRCUS
238400200529     C                   MOVEL     P71G          DSTRAN
238500200529     C                   EXSR      SrCcyA33B
238600200529
238700200529      ** Save receiver's charges info for input to SR/SROV32AM
238800200529
238900200529     C                   MOVEL     WCACY         WRCHCY
239000200529     C                   MOVEL     WCAAM         WRCHAM
239100200529
239200200529     C                   CALL      'AOCURRR0'                           8080
239300200529     C                   PARM      *BLANKS       PRTCD
239400200529     C                   PARM      '*KEY   '     POPTN
239500200529     C                   PARM      WCACY         PCHR03
239600200529     C     SDCURR        PARM      *BLANKS       DSSDY
239700200529
239800200529     C                   IF        PRTCD = *BLANKS  AND
239900200529     C                             NOT(*IN80)
240000200529     C                   MOVE      *BLANK        ZFIELD
240100200529     C                   MOVE      WCAAM         ZFIELD
240200200529     C     13            SUB       A6NBDP        ZADIG
240300200529     C                   Z-ADD     A6NBDP        ZADEC
240400200529     C                   Z-ADD     A6NBDP        WRCRMNDP
240500200529
240600200529     C                   CALLB     'ZALIGN'
240700200529     C                   PARM                    ZalignOK
240800200529     C                   PARM                    ZFIELD
240900200529     C                   PARM                    ZADEC
241000200529     C                   PARM                    ZADIG
241100200529
241200200529     C                   IF        ZAlignOK = 'Y'
241300200529     C                   MOVE      ZFIELD        I2INRCNW
241400200529     C                   MOVEL     WCACY         I2INRCCN
241500200529     C                   ENDIF
241600200529
241700200529      ** Default receiver's charges screen field
241800200529     C                   MOVEL     WCAAM         ODDRCRM
241900200529
242000200529     C                   ENDIF
242100200529
242200200529     C                   ENDIF
242300200529
242400200529     C                   ENDIF
242500200529
242600200529      ** Settlement Value Date/Currency/Amount.
242700200529
242800200529     C                   IF        PDCA <> *BLANKS
242900200529
243000200529     C                   MOVEL     PDCA          DSTRAN
243100200529
243200200529      ** Settlement Value Date.
243300200529
243400200529     C                   MOVEL     TVVDAT        WWDT
243500200529
243600200529      ** MMDDYY format display.
243700200529
243800200529     C                   IF        BJDFIN = 'M'
243900200529
244000200529     C                   EVAL      ODDSLDT = WD2 + WD3 + WD1
244100200529
244200200529     C                   ELSE
244300200529
244400200529      ** DDMMYY format display.
244500200529
244600200529     C                   EVAL      ODDSLDT = WD3 + WD2 + WD1
244700200529
244800200529     C                   ENDIF
244900200529
245000200529      ** Settlement Currency.
245100200529
245200200529     C                   MOVEL     TVCCY         ODDSMCY
245300200529
245400200529      ** Settlement Amount.
245500200529
245600200529     C                   IF        PNWRK <> 'FONTIS'
245700200529
245800200529      ** Format amount field (change ',' decimal point to '.').
245900200529
246000200529     C                   MOVEA     *BLANKS       WYA1
246100200529     C                   MOVEA     TVAMT         WYA1
246200200529     C                   Z-ADD     1             Cx
246300200529
246400200529     C                   DOU       Cx > 15
246500200529     C                   IF        WYA1(Cx) =  ','
246600200529     C                   MOVE      '.'           WYA1(Cx)
246700200529     C                   Z-ADD     16            Cx
246800200529     C                   ELSE
246900200529     C                   ADD       1             Cx
247000200529     C                   ENDIF
247100200529     C                   ENDDO
247200200529
247300200529     C                   MOVEA     WYA1          WAMT
247400200529
247500200529     C                   IF        CFT014 = 'Y' AND
247600200529     C                             P71G <> *BLANKS
247700200529
247800200529     C                   MOVEL     ODDSLDT       ZDateIn
247900200529     C                   CALLB     'ZDATE1'
248000200529     C                   PARM                    ZDateIn
248100200529     C                   PARM      0             ZDateOut
248200200529     C                   PARM      BJDFIN        ZDateFmt
248300200529     C                   PARM      *BLANK        ZDate1OK
248400200529     C                   Z-ADD     ZDateOut      WOVVLD
248500200529     C                   Z-ADD     ZDateOut      WSLDT
248600200529     C                   MOVE      ODDSMCY       WOVICY
248700200529     C                   MOVEL     WAMT          WOVIAM
248800200529     C                   MOVEL     WRCHCY        WOVRCY
248900200529     C                   MOVEL     WRCHAM        WOVRAM
249000200529     C                   MOVEL     '*SUB'        WOVOPR
249100200529     C                   EXSR      SROV32AM
249200200529     C                   MOVEL     WOVAMT        ODDSMAM
249300200529     C                   ELSE
249400200529     C                   MOVEL     WAMT          ODDSMAM
249500200529     C                   ENDIF
249600200529
249700200529     C                   ENDIF
249800200529
249900200529     C                   ENDIF
250000200529
250100200529      ** Ordering Customer.
250200200529
250300200529     C                   IF        P50 <> *BLANKS
250400200529     C                   MOVEL     P50           DSTRAN
250500200529     C                   MOVEL     TMLIN1        ODDORC1
250600200529     C                   MOVEL     TMLIN2        ODDORC2
250700200529     C                   MOVEL     TMLIN3        ODDORC3
250800200529     C                   MOVEL     TMLIN4        ODDORC4
250900200529     C                   MOVEL     TMLIN5        ODDORC5                                      CFT032
251000200529     C                   ENDIF
251100200529
251200200529      ** Ordering Institution.
251300200529
251400200529     C                   IF        P52 <> *BLANKS
251500200529     C                   MOVEL     P52           DSTRAN
251600200529     C                   MOVEL     TMLIN1        ODDOBK1
251700200529     C                   MOVEL     TMLIN2        ODDOBK2
251800200529     C                   MOVEL     TMLIN3        ODDOBK3
251900200529     C                   MOVEL     TMLIN4        ODDOBK4
252000200529     C                   MOVEL     TMLIN5        ODDOBK5
252100200529     C                   ENDIF
252200200529
252300200529      ** Sender's Correspondent.
252400200529
252500200529     C                   IF        P53 <> *BLANKS
252600200529     C                   MOVEL     P53           DSTRAN
252700200529     C                   MOVEL     TMLIN1        ODDSNC1
252800200529     C                   MOVEL     TMLIN2        ODDSNC2
252900200529     C                   MOVEL     TMLIN3        ODDSNC3
253000200529     C                   MOVEL     TMLIN4        ODDSNC4
253100200529     C                   MOVEL     TMLIN5        ODDSNC5
253200200529     C                   ENDIF
253300200529
253400200529      ** Receiver's Correspondent.
253500200529
253600200529     C                   IF        P54 <> *BLANKS
253700200529
253800200529     C                   MOVEL     P54           DSTRAN
253900200529     C                   MOVEL     TMLIN1        ODDRCO1
254000200529     C                   MOVEL     TMLIN2        ODDRCO2
254100200529     C                   MOVEL     TMLIN3        ODDRCO3
254200200529     C                   MOVEL     TMLIN4        ODDRCO4
254300200529     C                   MOVEL     TMLIN5        ODDRCO5
254400200529     C                   MOVEL     TMLIN1        IPINRCO1
254500200529     C                   MOVEL     TMLIN2        IPINRCO2
254600200529     C                   MOVEL     TMLIN3        IPINRCO3
254700200529     C                   MOVEL     TMLIN4        IPINRCO4
254800200529     C                   MOVEL     TMLIN5        IPINRCO5
254900200529
255000200529      ** If Network is SWIFT, find field type.
255100200529      ** Otherwise, default it to 'U'.
255200200529
255300200529     C                   IF        PNWRK = 'SWIFT '
255400200529
255500200529      ** Set up field type, if A->S, B->T, D->U.
255600200529
255700200529     C     1             SUBST     TRTAG:4       WWK1
255800200529
255900200529     C                   SELECT
256000200529     C                   WHEN      WWK1 = 'A'
256100200529     C                   MOVEL     'S'           IPINRCRT
256200200529     C                   WHEN      WWK1 = 'B'
256300200529     C                   MOVEL     'T'           IPINRCRT
256400200529     C                   OTHER
256500200529     C                   MOVEL     'U'           IPINRCRT
256600200529     C                   ENDSL
256700200529
256800200529     C                   ELSE
256900200529
257000200529      ** Network is not SWIFT.
257100200529
257200200529     C                   MOVEL     'U'           IPINRCRT
257300200529
257400200529     C                   ENDIF
257500200529
257600200529     C                   ELSE
257700200529
257800200529     C                   MOVEL     *BLANKS       IPINRCRT
257900200529     C                   MOVEL     *BLANKS       IPINRCO1
258000200529     C                   MOVEL     *BLANKS       IPINRCO2
258100200529     C                   MOVEL     *BLANKS       IPINRCO3
258200200529     C                   MOVEL     *BLANKS       IPINRCO4
258300200529     C                   MOVEL     *BLANKS       IPINRCO5
258400200529
258500200529     C                   ENDIF
258600200529
258700200529      ** Intermediary.
258800200529
258900200529     C                   IF        P56 <> *BLANKS
259000200529     C                   MOVEL     P56           DSTRAN
259100200529     C                   MOVEL     TMLIN1        ODDINB1
259200200529     C                   MOVEL     TMLIN2        ODDINB2
259300200529     C                   MOVEL     TMLIN3        ODDINB3
259400200529     C                   MOVEL     TMLIN4        ODDINB4
259500200529     C                   MOVEL     TMLIN5        ODDINB5
259600200529     C                   ENDIF
259700200529
259800200529      ** Account with Institution.
259900200529
260000200529     C                   IF        P57 <> *BLANKS
260100200529     C                   MOVEL     P57           DSTRAN
260200200529     C                   MOVEL     TMLIN1        ODDACBK
260300200529     C                   MOVEL     TMLIN1        IPINACB1
260400200529     C                   MOVEL     TMLIN2        IPINACB2
260500200529     C                   MOVEL     TMLIN3        IPINACB3
260600200529     C                   MOVEL     TMLIN4        IPINACB4
260700200529     C                   MOVEL     TMLIN5        IPINACB5
260800200529
260900200529      ** If Network is SWIFT, find field type.
261000200529      ** Otherwise, default it to 'U'.
261100200529
261200200529     C                   IF        PNWRK = 'SWIFT '
261300200529
261400200529      ** Set up field type, if A->S, B->T, D->U.
261500200529
261600200529     C     1             SUBST     TRTAG:4       WWK1
261700200529
261800200529     C                   SELECT
261900200529     C                   WHEN      WWK1 = 'A'
262000200529     C                   MOVEL     'S'           IPINACBT
262100200529     C                   WHEN      WWK1 = 'B'
262200200529     C                   MOVEL     'T'           IPINACBT
262300200529     C                   OTHER
262400200529     C                   MOVEL     'U'           IPINACBT
262500200529     C                   ENDSL
262600200529
262700200529     C                   ELSE
262800200529
262900200529      ** Network is not SWIFT.
263000200529
263100200529     C                   MOVEL     'U'           IPINACBT
263200200529
263300200529     C                   ENDIF
263400200529
263500200529      ** P57 equals blanks.
263600200529
263700200529     C                   ELSE
263800200529
263900200529     C                   MOVEL     *BLANKS       IPINACBT
264000200529     C                   MOVEL     *BLANKS       IPINACB1
264100200529     C                   MOVEL     *BLANKS       IPINACB2
264200200529     C                   MOVEL     *BLANKS       IPINACB3
264300200529     C                   MOVEL     *BLANKS       IPINACB4
264400200529     C                   MOVEL     *BLANKS       IPINACB5
264500200529
264600200529     C                   ENDIF
264700200529
264800200529      ** Beneficiary Institution/ Beneficiary Customer.
264900200529
265000200529     C                   IF        P58 <> *BLANKS
265100200529     C                   MOVEL     P58           DSTRAN
265200200529     C                   MOVEL     TMLIN1        ODDBNC1
265300200529     C                   MOVEL     TMLIN2        ODDBNC2
265400200529     C                   MOVEL     TMLIN3        ODDBNC3
265500200529     C                   MOVEL     TMLIN4        ODDBNC4
265600200529     C                   MOVEL     TMLIN5        ODDBNC5
265700200529     C                   ENDIF
265800200529
265900200529     C                   IF        P59 <> *BLANKS
266000200529     C                   MOVEL     P59           DSTRAN
266100200529     C                   MOVEL     TMLIN1        ODDBNC1
266200200529     C                   MOVEL     TMLIN2        ODDBNC2
266300200529     C                   MOVEL     TMLIN3        ODDBNC3
266400200529     C                   MOVEL     TMLIN4        ODDBNC4
266500200529     C                   MOVEL     TMLIN5        ODDBNC5
266600200529     C                   ENDIF
266700200529
266800200529      ** Details of Payment.
266900200529
267000200529     C                   IF        P70 <> *BLANKS
267100200529     C                   MOVEL     P70           DSTRAN
267200200529     C                   MOVEL     TMLIN1        ODDDTP1
267300200529     C                   MOVEL     TMLIN2        ODDDTP2
267400200529     C                   MOVEL     TMLIN3        ODDDTP3
267500200529     C                   MOVEL     TMLIN4        ODDDTP4
267600200529     C                   ENDIF
267700200529
267800200529      *                                                                                       CER030
267900200529      ** Move Extended Narratives to screen fields                                            CER030
268000200529      *                                                                                       CER030
268100200529     C                   IF        PEXN <> *BLANKS                                            CER030
268200200529     C                   MOVEL     PEXN          DSTRAN                                       CER030
268300200529     C                   MOVEL     TMLIN1        ODDEXT1                                      CER030
268400200529     C                   MOVEL     TMLIN2        ODDEXT2                                      CER030
268500200529     C                   MOVEL     TMLIN3        ODDEXT3                                      CER030
268600200529     C                   MOVEL     TMLIN4        ODDEXT4                                      CER030
268700200529     C                   MOVEL     TMLIN5        ODDEXT5                                      CER030
268800200529     C                   MOVEL     TMLIN6        ODDEXT6                                      CER030
268900200529     C                   ENDIF                                                                CER030
269000200529      *                                                                                       CER030
269100200529      ** Details of Charges.
269200200529
269300200529     C                   IF        P71 <> *BLANKS
269400200529     C                   MOVEL     P71           DSTRAN
269500200529     C                   MOVEL     TTREF         ODDDTCH
269600200529     C                   IF        CFT014 = 'Y'
269700200529
269800200529     C                   IF        TTREF = 'OUR'
269900200529     C                   MOVE      'A'           ODDADDC
270000200529     C                   ELSE
270100200529     C                   MOVE      'D'           ODDADDC
270200200529     C                   ENDIF
270300200529
270400200529      ** Check if receiver's charges screen field needs to be changed
270500200529
270600200529     C                   IF        ODDADDC = 'A' AND
270700200529     C                             ODDSMCY <> I2INRCCN  AND
270800200529     C                             I2INRCNW <>  0
270900200529
271000200529      ** Calculate receiver's charges network in settlement currency
271100200529
271200200529     C                   CLEAR                   P#0010
271300200529     C                   Z-ADD     WSLDT         P#FRDT
271400200529     C                   Z-ADD     WSLDT         P#TODT
271500200529     C                   MOVEL     I2INRCCN      P#FRCY
271600200529     C                   Z-ADD     I2INRCNW      P#FRAM
271700200529     C                   MOVEL     ODDSMCY       P#TOCY
271800200529     C                   Z-ADD     0             P#TOAM
271900200529     C                   Z-ADD     0             P#RATE
272000200529     C                   CALL      'FT0010'
272100200529     C                   PARM                    P#0010
272200200529
272300200529     C                   IF        P#RTCD <> *BLANKS
272400200529     C                   Z-ADD     2             DBASE
272500200529     C                   MOVEL     'FT0010'      DBFILE
272600200529     C                   MOVEL     '*CALL '      DBKEY
272700200529     C                   EXSR      *PSSR
272800200529     C                   ELSE
272900200529
273000200529     C                   MOVE      *BLANKS       ZFIELD
273100200529     C                   MOVE      P#TOAM        ZFIELD
273200200529     C                   CALLB     'ZEDIT'
273300200529     C                   PARM                    ZFIELD
273400200529     C                   PARM      WRCRMNDP      ZADEC
273500200529     C                   MOVE      ZFIELD        ODDRCRM
273600200529
273700200529      ** Left-justify the amount
273800200529
273900200529     C                   Z-ADD     1             CX
274000200529     C                   MOVE      *BLANKS       WYA1
274100200529     C                   MOVEA     ODDRCRM       WYA1(1)
274200200529     C                   DOW       WYA1(CX) = *BLANK AND
274300200529     C                             CX < 12
274400200529     C                   ADD       1             CX
274500200529     C                   ENDDO
274600200529     C                   MOVE      *BLANKS       ODDRCRM
274700200529     C                   IF        CX <= 12
274800200529     C                   MOVEA     WYA1(CX)      ODDRCRM
274900200529     C                   ENDIF
275000200529     C                   ENDIF
275100200529     C                   ENDIF
275200200529
275300200529     C                   ENDIF
275400200529     C                   ENDIF
275500200529
275600200529      ** Bank to Bank Information.
275700200529
275800200529      ** Access Settlement Currency details.
275900200529
276000200529     C                   CALLB     'AOCURRR0'
276100200529     C                   PARM      *BLANKS       PRTCD
276200200529     C                   PARM      '*KEY   '     POPTN
276300200529     C                   PARM      ODDSMCY       PCCY
276400200529     C     SDCURR        PARM      SDCURR        DSSDY
276500200529
276600200529     C                   IF        P72 <> *BLANKS
276700200529
276800200529     C                   MOVEL     P72           DSTRAN
276900200529     C                   MOVEL     TMLIN1        ODDBBI1
277000200529     C                   MOVEL     TMLIN2        ODDBBI2
277100200529     C                   MOVEL     TMLIN3        ODDBBI3
277200200529     C                   MOVEL     TMLIN4        ODDBBI4
277300200529     C                   MOVEL     TMLIN5        ODDBBI5
277400200529     C                   MOVEL     TMLIN6        ODDBBI6
277500200529
277600200529     C                   IF        P33B = *BLANKS
277700200529
277800200529     C     '/OCMT/'      SCAN      P72           WOCMT
277900200529
278000200529     C                   IF        WOCMT <> 0
278100200529     C                   MOVEL     '/OCMT'       WCW
278200200529     C                   MOVEL     P72           WCWLIN
278300200529     C                   EXSR      SRFOCmt2
278400200529     C                   MOVEL     WCWCY         ODDNDCY
278500200529     C                   MOVEL     WCWAM         ODDNDAM
278600200529     C                   ENDIF
278700200529
278800200529     C                   ENDIF
278900200529
279000200529     C                   ENDIF
279100200529
279200200529      ** Additional Mapping for CASHIER.
279300200529
279400200529      ** Pay Value Date/Currency/Amount.
279500200529
279600200529     C                   IF        SDCA <> *BLANKS
279700200529
279800200529     C                   Z-ADD     0             TVVDAT
279900200529     C                   MOVEL     SDCA          DSTRAN
280000200529
280100200529      ** Pay Value Date.
280200200529
280300200529     C                   IF        TVVDAT <> 0
280400200529
280500200529     C                   MOVEL     TVVDAT        WWDT
280600200529
280700200529      ** MMDDYY format display.
280800200529
280900200529     C                   IF        BJDFIN = 'M'
281000200529
281100200529     C                   EVAL      ODDPYDT = WD2 + WD3 + WD1
281200200529
281300200529     C                   ELSE
281400200529
281500200529      ** DDMMYY format display.
281600200529
281700200529     C                   EVAL      ODDPYDT = WD3 + WD2 + WD1
281800200529
281900200529     C                   ENDIF
282000200529
282100200529     C                   ENDIF
282200200529
282300200529      ** Pay Currency.
282400200529
282500200529     C                   MOVEL     TVCCY         ODDPCCY
282600200529
282700200529      ** Pay Amount.
282800200529
282900200529      ** Format amount field (change ',' decimal point to '.').
283000200529
283100200529     C                   MOVEA     *BLANKS       WYA1
283200200529     C                   MOVEA     TVAMT         WYA1
283300200529     C                   Z-ADD     1             Cx
283400200529
283500200529     C                   DOU       Cx > 15
283600200529     C                   IF        WYA1(Cx) = ','
283700200529     C                   MOVE      '.'           WYA1(Cx)
283800200529     C                   Z-ADD     16            Cx
283900200529     C                   ELSE
284000200529     C                   ADD       1             Cx
284100200529     C                   ENDIF
284200200529     C                   ENDDO
284300200529
284400200529     C                   MOVEA     WYA1          WAMT
284500200529     C                   MOVEL     WAMT          ODDPYAM
284600200529
284700200529     C                   ENDIF
284800200529
284900200529      ** Funding Currency/Funding Amount.
285000200529
285100200529     C                   IF        PDC2 <> *BLANKS
285200200529
285300200529     C                   Z-ADD     0             TVVDAT
285400200529     C                   MOVEL     PDC2          DSTRAN
285500200529
285600200529      ** Settlement Value Date.
285700200529
285800200529     C                   IF        TVVDAT <> 0
285900200529
286000200529     C                   MOVEL     TVVDAT        WWDT
286100200529
286200200529      ** MMDDYY format display.
286300200529
286400200529     C                   IF        BJDFIN = 'M'
286500200529
286600200529     C                   EVAL      ODDSLDT = WD2 + WD3 + WD1
286700200529
286800200529     C                   ELSE
286900200529
287000200529      ** DDMMYY format display.
287100200529
287200200529     C                   EVAL      ODDSLDT = WD3 + WD2 + WD1
287300200529
287400200529     C                   ENDIF
287500200529
287600200529     C                   ENDIF
287700200529
287800200529      ** Settlement Currency.
287900200529
288000200529     C                   MOVEL     TVCCY         ODDSMCY
288100200529
288200200529      ** Settlement AMount.
288300200529
288400200529      ** Format amount field (change ',' decimal point to '.').
288500200529
288600200529     C                   MOVEA     *BLANKS       WYA1
288700200529     C                   MOVEA     TVAMT         WYA1
288800200529     C                   Z-ADD     1             Cx
288900200529
289000200529     C                   DOU       Cx > 15
289100200529     C                   IF        WYA1(CX) = ','
289200200529     C                   MOVE      '.'           WYA1(Cx)
289300200529     C                   Z-ADD     16            Cx
289400200529     C                   ELSE
289500200529     C                   ADD       1             Cx
289600200529     C                   ENDIF
289700200529     C                   ENDDO
289800200529
289900200529     C                   MOVEA     WYA1          WAMT
290000200529     C                   MOVEL     WAMT          ODDSMAM
290100200529
290200200529     C                   ENDIF
290300200529
290400200529      ** Rate.
290500200529
290600200529     C                   IF        ODDPYAM <> *BLANKS AND
290700200529     C                             ODDSMAM <> *BLANKS
290800200529
290900200529      ** Get the numeric value of DDPYAM.
291000200529
291100200529     C                   CALLB     'AOCURRR0'
291200200529     C                   PARM      *BLANKS       PRTCD
291300200529     C                   PARM      '*KEY   '     POPTN
291400200529     C                   PARM      ODDPCCY       PCCY
291500200529     C     SDCURR        PARM      SDCURR        DSSDY
291600200529
291700200529     C                   IF        PRTCD <> *BLANKS
291800200529     C                   MOVEL     ODDPCCY       DBKEY
291900200529     C                   MOVEL     'SDCURRPD'    DBFILE
292000200529     C                   Z-ADD     3             DBASE
292100200529     C                   EXSR      *PSSR
292200200529     C                   ENDIF
292300200529
292400200529     C                   Z-ADD     A6NBDP        WPCYD
292500200529
292600200529      ** Align amount.
292700200529
292800200529     C                   Z-ADD     WPCYD         ZADEC
292900200529     C     11            SUB       WPCYD         ZADIG
293000200529     C                   MOVEL     *BLANKS       ZFIELD
293100200529     C                   MOVE      ODDPYAM       ZFIELD
293200200529
293300200529     C                   CALLB     'ZALIGN'
293400200529     C                   PARM                    ZalignOk
293500200529     C                   PARM                    ZField
293600200529     C                   PARM                    ZADec
293700200529     C                   PARM                    ZADig
293800200529
293900200529     C                   IF        ZalignOK = 'Y'
294000200529     C                   MOVE      ZFIELD        W1PYA
294100200529     C                   ENDIF
294200200529
294300200529      ** Get the numeric value of ODDSMAM.
294400200529
294500200529     C                   CALLB     'AOCURRR0'
294600200529     C                   PARM      *BLANKS       PRTCD
294700200529     C                   PARM      '*KEY   '     POPTN
294800200529     C                   PARM      ODDSMCY       PCCY
294900200529     C     SDCURR        PARM      SDCURR        DSSDY
295000200529
295100200529     C                   IF        PRTCD <> *BLANKS
295200200529     C                   MOVEL     ODDSMCY       DBKEY
295300200529     C                   MOVEL     'SDCURRPD'    DBFILE
295400200529     C                   Z-ADD     4             DBASE
295500200529     C                   EXSR      *PSSR
295600200529     C                   ENDIF
295700200529
295800200529     C                   Z-ADD     A6NBDP        WSMCY
295900200529
296000200529      ** Align amount.
296100200529
296200200529     C                   Z-ADD     WSMCY         ZADEC
296300200529     C     11            SUB       WSMCY         ZADIG
296400200529     C                   MOVEL     *BLANKS       ZFIELD
296500200529     C                   MOVE      ODDSMAM       ZFIELD
296600200529
296700200529     C                   CALLB     'ZALIGN'
296800200529     C                   PARM                    ZalignOk
296900200529     C                   PARM                    ZField
297000200529     C                   PARM                    ZADec
297100200529     C                   PARM                    ZADig
297200200529
297300200529     C                   IF        ZalignOk = 'Y'
297400200529     C                   MOVE      ZFIELD        W1SMA
297500200529     C                   ENDIF
297600200529
297700200529     C                   IF        W1PYA <> 0 AND
297800200529     C                             W1SMA <> 0
297900200529
298000200529      ** Calculate the Rate by dividing the larger amount
298100200529      ** by the smaller amount.
298200200529
298300200529     C                   IF        W1PYA >= W1SMA
298400200529     C     W1PYA         DIV       W1SMA         W1RTE
298500200529     C                   MOVE      *BLANKS       ODDSMAM
298600200529     C                   ENDIF
298700200529
298800200529     C                   IF        W1SMA > W1PYA
298900200529     C     W1PYA         DIV       W1SMA         W1RTE
299000200529     C                   MOVE      *BLANKS       ODDPYAM
299100200529     C                   ENDIF
299200200529
299300200529      ** Format Rate field.
299400200529
299500200529     C                   MOVE      *BLANKS       ZFIELD
299600200529     C                   MOVE      W1RTE         ZFIELD
299700200529     C                   Z-ADD     7             ZADEC2
299800200529
299900200529     C                   CALLB     'ZAEDITM'
300000200529     C                   PARM                    ZFIELD
300100200529     C                   PARM                    ZADEC2
300200200529
300300200529     C                   MOVE      ZFIELD        ODDRATE
300400200529
300500200529     C                   ENDIF
300600200529
300700200529     C                   ENDIF
300800200529
300900200529     C                   IF        PNWRK = 'CASHV8'
301000200529
301100200529      ** Receiver's Correspondent and Ordering Bank.
301200200529
301300200529     C                   IF        P54 <> *BLANKS
301400200529
301500200529     C                   MOVEL     P54           DSTRAN
301600200529     C                   MOVEL     *BLANKS       ODDRCO1
301700200529     C                   MOVEL     TMLIN         ODDRCO1
301800200529     C                   MOVEL     *BLANKS       ODDOBK1
301900200529     C                   MOVEL     TMLIN         ODDOBK1
302000200529
302100200529     C                   ELSE
302200200529
302300200529      ** Use the default account code from CASH dataarea and
302400200529      ** build the account number.
302500200529
302600200529      ** Get Branch internal customer.
302700200529
302800200529     C**********         CALLB     'AOBRCHR0'                                                 CGL029
302900200529     C                   CALL      'AOBRCHR1'                                                 CGL029
303000200529     C                   PARM      *BLANKS       PRTCD
303100200529     C                   PARM      '*KEY   '     POPTN
303200200529     C                   PARM      ODDBRCA       PBRCH
303300200529     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
303400200529     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
303500200529
303600200529     C                   IF        PRTCD <> *BLANKS
303700200529     C                   MOVEL     ODDBRCA       DBKEY
303800200529     C                   MOVEL     'SDBRCHPD'    DBFILE
303900200529     C                   Z-ADD     5             DBASE
304000200529     C                   EXSR      *PSSR
304100200529     C                   ENDIF
304200200529
304300200529      ** Retrieve Retail account number.
304400200529
304500200529     C                   MOVE      A8BICN        KACNUM
304600200529     C                   MOVEL     ODDSMCY       KACCCY
304700200529     C                   MOVE      WDACACD       KACCD
304800200529     C                   Z-ADD     1             KACSQ
304900200529     C                   MOVEL     ODDBRCA       KBRCA
305000200529
305100200529     C     KAccnt        CHAIN     ACCNT                              01
305200200529
305300200529     C                   IF        *IN01
305400200529     C                   MOVEL     WACKYDS       DBKEY
305500200529     C                   MOVEL     'ACCNT'       DBFILE
305600200529     C                   Z-ADD     6             DBASE
305700200529     C                   EXSR      *PSSR
305800200529     C                   ENDIF
305900200529
306000200529      ** Move Retail account number to Receiver's Correspondent.
306100200529
306200200529     C                   MOVEL     *BLANKS       ODDRCO1
306300200529     C                   MOVE      ACNO          ODDRCO1
306400200529
306500200529     C                   ENDIF
306600200529
306700200529      ** Account with Institution.
306800200529
306900200529     C                   IF        P57 <> *BLANKS
307000200529     C                   MOVEL     P57           DSTRAN
307100200529     C                   MOVEL     *BLANKS       WREAC
307200200529     C                   MOVEL     TMLIN         WREAC
307300200529     C                   MOVEL     *BLANKS       ODDACBK
307400200529     C                   MOVEL     WREAC         ODDACBK
307500200529     C                   ENDIF
307600200529
307700200529     C                   MOVEL     'N'           ODDOPIN
307800200529
307900200529     C                   ENDIF
308000200529
308100200529     C                   IF        CFT014 = 'Y'
308200200529
308300200529      ** Third Reimbursment Institution
308400200529
308500200529     C                   IF        P55 <> *BLANKS
308600200529
308700200529     C                   MOVEL     *BLANK        DSTRAN
308800200529     C                   MOVEL     P55           DSTRAN
308900200529
309000200529      ** Map 1st line of SWIFT values into screen fields
309100200529     C                   MOVEL     TMLIN1        ODDTRIB
309200200529
309300200529     C                   IF        CFT004 = 'Y'
309400200529
309500200529      ** Check whether the field carries an IBAN
309600200529      ** If it is the case, move the IBAN into the 'screen' field
309700200529      ** which will be validated afterwards
309800200529
309900200529     C                   MOVEL     ODDTRIB       P@IBAN
310000200529
310100200529      ** Check that it is a valid IBAN
310200200529     C                   CALL      'AOIBANR2'
310300200529     C                   PARM      *BLANKS       PRTCD
310400200529     C                   PARM                    P@IBAN
310500200529     C                   PARM      *BLANKS       DSSDY
310600200529
310700200529      ** Network information is mapped onto the 'screen' field
310800200529
310900200529     C                   IF        PRTCD = *BLANKS
311000200529     C                   MOVEL     *BLANK        ODDTRIB
311100200529
311200200529      ** '/' has been removed
311300200529     C                   MOVEL     P@IBAN        ODDTRIB
311400200529     C                   ENDIF
311500200529
311600200529     C                   ENDIF
311700200529
311800200529     C                   ENDIF
311900200529
312000200529      ** Bank Operation Code
312100200529
312200200529     C                   IF        P23B <> *BLANKS
312300200529     C                   MOVEL     *BLANK        DSTRAN
312400200529     C                   MOVEL     P23B          DSTRAN
312500200529     C                   MOVEL     TTREF         ODDBOCD
312600200529     C                   ENDIF
312700200529
312800200529      ** Instruction Code
312900200529
313000200529     C                   IF        P23E <> *BLANKS
313100200529     C                   MOVEL     *BLANK        DSTRAN
313200200529     C                   MOVEL     P23E          DSTRAN
313300200529     C                   MOVEL     TMLIN1        ODDICD1
313400200529     C                   MOVEL     TMLIN2        ODDICD2
313500200529     C                   MOVEL     TMLIN3        ODDICD3
313600200529     C                   MOVEL     TMLIN4        ODDICD4
313700200529     C                   MOVEL     TMLIN5        ODDICD5
313800200529     C                   ENDIF
313900200529
314000200529      ** Transaction Code
314100200529
314200200529     C                   IF        P26T <> *BLANKS
314300200529     C                   MOVEL     *BLANK        DSTRAN
314400200529     C                   MOVEL     P26T          DSTRAN
314500200529     C                   MOVEL     TTREF         ODDTTCD
314600200529     C                   ENDIF
314700200529
314800200529      ** Instructed Currency/Amount
314900200529
315000200529     C                   IF        P33B <> *BLANKS
315100200529     C                   MOVEL     *BLANK        DSTRAN
315200200529     C                   MOVEL     P33B          DSTRAN
315300200529     C                   EXSR      SrCcyA33B
315400200529     C                   MOVEL     WCACY         ODDNDCY
315500200529     C                   MOVEL     WCAAM         ODDNDAM
315600200529     C                   ENDIF
315700200529
315800200529      ** Original Rate Currency/Amount
315900200529
316000200529     C                   IF        P36 <> *BLANKS
316100200529     C                   MOVEL     *BLANK        DSTRAN
316200200529     C                   MOVEL     P36           DSTRAN
316300200529     C                   EXSR      SRRATE36
316400200529     C                   MOVEL     W36RT         ODDOEXR
316500200529     C                   ENDIF
316600200529
316700200529      ** Regulatory Reporting
316800200529
316900200529     C                   IF        P77B <> *BLANKS
317000200529     C                   MOVEL     *BLANK        DSTRAN
317100200529     C                   MOVEL     P77B          DSTRAN
317200200529     C                   MOVEL     TMLIN1        ODDRRP1
317300200529     C                   MOVEL     TMLIN2        ODDRRP2
317400200529     C                   MOVEL     TMLIN3        ODDRRP3
317500200529     C                   ENDIF
317600200529
317700200529     C                   ENDIF
317800200529
317900200529      *                                                                                       CSW209
318000200529     C                   IF        CSW209 = 'Y'                                               CSW209
318100200529      *                                                                                       CSW209
318200200529     C                   EVAL      ODDNWRK = PNWRK                                            CSW209
318300200529     C                   EVAL      ODDMTPY = PMTPY                                            CSW209
318400200529     C                   EVAL      ODDVALF = P119                                             CSW209
318500200529      *                                                                                       CSW209
318600200529      ** Set Ordering Customer (Cover)                                                        CSW209
318700200529      *                                                                                       CSW209
318800200529     C                   IF        PB50 <> *BLANKS                                            CSW209
318900200529     C                   EVAL      DSTRAN  = PB50                                             CSW209
319000200529     C                   EVAL      ODDCOC1 = TMLIN1                                           CSW209
319100200529     C                   EVAL      ODDCOC2 = TMLIN2                                           CSW209
319200200529     C                   EVAL      ODDCOC3 = TMLIN3                                           CSW209
319300200529     C                   EVAL      ODDCOC4 = TMLIN4                                           CSW209
319400200529     C                   EVAL      ODDCOC5 = TMLIN5                                           CSW209
319500200529     C                   ENDIF                                                                CSW209
319600200529      *                                                                                       CSW209
319700200529      ** Set Ordering Institution (Cover)                                                     CSW209
319800200529      *                                                                                       CSW209
319900200529     C                   IF        PB52 <> *BLANKS                                            CSW209
320000200529     C                   EVAL      DSTRAN  = PB52                                             CSW209
320100200529     C                   EVAL      ODDCOB1 = TMLIN1                                           CSW209
320200200529     C                   EVAL      ODDCOB2 = TMLIN2                                           CSW209
320300200529     C                   EVAL      ODDCOB3 = TMLIN3                                           CSW209
320400200529     C                   EVAL      ODDCOB4 = TMLIN4                                           CSW209
320500200529     C                   EVAL      ODDCOB5 = TMLIN5                                           CSW209
320600200529     C                   ENDIF                                                                CSW209
320700200529      *                                                                                       CSW209
320800200529      ** Set Intermediary Institution (Cover)                                                 CSW209
320900200529      *                                                                                       CSW209
321000200529     C                   IF        PB56 <> *BLANKS                                            CSW209
321100200529     C                   EVAL      DSTRAN = PB56                                              CSW209
321200200529     C                   EVAL      ODDCIB1 = TMLIN1                                           CSW209
321300200529     C                   EVAL      ODDCIB2 = TMLIN2                                           CSW209
321400200529     C                   EVAL      ODDCIB3 = TMLIN3                                           CSW209
321500200529     C                   EVAL      ODDCIB4 = TMLIN4                                           CSW209
321600200529     C                   EVAL      ODDCIB5 = TMLIN5                                           CSW209
321700200529     C                   ENDIF                                                                CSW209
321800200529      *                                                                                       CSW209
321900200529      ** Set Account with Institution (Cover)                                                 CSW209
322000200529      *                                                                                       CSW209
322100200529     C                   IF        PB57 <> *BLANKS                                            CSW209
322200200529     C                   EVAL      DSTRAN = PB57                                              CSW209
322300200529     C                   EVAL      ODDCAB1 = TMLIN1                                           CSW209
322400200529     C                   EVAL      ODDCAB2 = TMLIN2                                           CSW209
322500200529     C                   EVAL      ODDCAB3 = TMLIN3                                           CSW209
322600200529     C                   EVAL      ODDCAB4 = TMLIN4                                           CSW209
322700200529     C                   EVAL      ODDCAB5 = TMLIN5                                           CSW209
322800200529     C                   ENDIF                                                                CSW209
322900200529      *                                                                                       CSW209
323000200529      ** Set Beneficiary Customer (Cover)                                                     CSW209
323100200529      *                                                                                       CSW209
323200200529     C                   IF        PB59 <> *BLANKS                                            CSW209
323300200529     C                   EVAL      DSTRAN = PB59                                              CSW209
323400200529     C                   EVAL      ODDCBC1 = TMLIN1                                           CSW209
323500200529     C                   EVAL      ODDCBC2 = TMLIN2                                           CSW209
323600200529     C                   EVAL      ODDCBC3 = TMLIN3                                           CSW209
323700200529     C                   EVAL      ODDCBC4 = TMLIN4                                           CSW209
323800200529     C                   EVAL      ODDCBC5 = TMLIN5                                           CSW209
323900200529     C                   ENDIF                                                                CSW209
324000200529      *                                                                                       CSW209
324100200529      ** Set Remittance Information (Cover)                                                   CSW209
324200200529      *                                                                                       CSW209
324300200529     C                   IF        PB70 <> *BLANKS                                            CSW209
324400200529     C                   EVAL      DSTRAN = PB70                                              CSW209
324500200529     C                   EVAL      ODDCDP1 = TMLIN1                                           CSW209
324600200529     C                   EVAL      ODDCDP2 = TMLIN2                                           CSW209
324700200529     C                   EVAL      ODDCDP3 = TMLIN3                                           CSW209
324800200529     C                   EVAL      ODDCDP4 = TMLIN4                                           CSW209
324900200529     C                   ENDIF                                                                CSW209
325000200529      *                                                                                       CSW209
325100200529      ** Set Sender to Receiver Information (Cover)                                           CSW209
325200200529      *                                                                                       CSW209
325300200529     C                   IF        PB72 <> *BLANKS                                            CSW209
325400200529     C                   EVAL      DSTRAN = PB72                                              CSW209
325500200529     C                   EVAL      ODDCBB1 = TMLIN1                                           CSW209
325600200529     C                   EVAL      ODDCBB2 = TMLIN2                                           CSW209
325700200529     C                   EVAL      ODDCBB3 = TMLIN3                                           CSW209
325800200529     C                   EVAL      ODDCBB4 = TMLIN4                                           CSW209
325900200529     C                   EVAL      ODDCBB5 = TMLIN5                                           CSW209
326000200529     C                   EVAL      ODDCBB6 = TMLIN6                                           CSW209
326100200529     C                   ENDIF                                                                CSW209
326200200529      *                                                                                       CSW209
326300200529      ** Set Instructed Currency/Amount (Cover)                                               CSW209
326400200529      *                                                                                       CSW209
326500200529     C                   IF        PB33B <> *BLANKS                                           CSW209
326600200529     C                   EVAL      DSTRAN = *BLANKS                                           CSW209
326700200529     C                   EVAL      DSTRAN = PB33B                                             CSW209
326800200529     C                   EXSR      SrCcyA33B                                                  CSW209
326900200529     C                   EVAL      ODDCICY = WCACY                                            CSW209
327000200529     C                   EVAL      ODDCIAM = WCAAM                                            CSW209
327100200529     C                   ENDIF                                                                CSW209
327200200529      *                                                                                       CSW209
327300200529     C                   ENDIF                                                                CSW209
327400200529      ** Default in Pay Currency.
327500200529
327600200529     C                   MOVE      ODDSMCY       ODDPCCY
327700200529
327800200529      ** Set up fields for Incoming FONTIS Messages.
327900200529
328000200529     C                   IF        PNWRK = 'FONTIS'
328100200529     C                   EXSR      SRFont
328200200529     C                   ENDIF
328300200529
328400200529      ** Decode data if feature installed.
328500200529
328600200529     C                   IF        CFT002 = 'Y'
328700200529
328800200529      ** Call ME1580 to translate the data of the messages for
328900200529      ** FT fields.
329000200529
329100200529     C                   CALL      'ME1580'                             0101
329200200529     C                   PARM      '*TRANS  '    PACTD
329300200529     C                   PARM                    PHEAD
329400200529     C                   PARM                    PDATA
329500200529     C                   PARM                    PDAT2                                        CSW209
329600200529     C                   PARM      *BLANKS       PRTN
329700200529
329800200529      ** If call to program resulted in an error, then end program.
329900200529
330000200529     C                   IF        PRTN = '*ERROR*' OR
330100200529     C                             *IN01
330200200529     C                   MOVEL     '*CALL'       DBKEY
330300200529     C                   MOVEL     'ME1580'      DBFILE
330400200529     C                   Z-ADD     7             DBASE
330500200529     C                   EXSR      *PSSR
330600200529     C                   ENDIF
330700200529
330800200529      ** If clearing, then copy.  Otherwise, map.
330900200529
331000200529     C                   EXSR      SRIMsg
331100200529
331200200529     C                   ENDIF
331300200529
331400200529      ** Initialise screen fields with details of the electronic
331500200529      ** message.
331600200529
331700200529     C                   MOVEL     CurTrIPY1     TranInIPY1
331800200529     C                   MOVEL     CurTrIP1A     TranInIP1A
331900200529     C                   MOVEL     CurTrIPY2     TranInIPY2
332000200529     C                   MOVEL     CurTrIPY3     TranInIPY3
332100200529     C                   MOVEL     CurTrIPY4     TranInIPY4
332200200529     C                   MOVEL     CurTrIP4A     TranInIP4A
332300200529     C                   MOVEL     CurTrIPY5     TranInIPY5
332400200529     C                   MOVEL     CurTrIPY6     TranInIPY6
332500200529     C                   MOVEL     CurTrIP6A     TranInIP6A                                   CER030
332600200529     C                   IF        CSW209 = 'Y'                                               CSW209
332700200529     C                   MOVEL     CurTrIPY7     TranInIPY7                                   CSW209
332800200529     C                   MOVEL     CurTrIPY8     TranInIPY8                                   CSW209
332900200529     C                   ENDIF                                                                CSW209
333000200529
333100200529      ** Set Reserved Electronic Message flag to 'Y'.
333200200529
333300200529     C**********         MOVEL     'Y'           DDSWFLG                                      CGL029
333400200529     C                   MOVEL     'Y'           DDSWFLG           1                          CGL029
333500200529
333600200529     C     EEISwft       ENDSR
333700200529
333800200529      *****************************************************************
333900200529      /EJECT
334000200529      *****************************************************************
334100200529      *                                                               *
334200200529      *  SRInScn - Initialise screen formats                          *
334300200529      *                                                               *
334400200529      *****************************************************************
334500200529      *
334600200529     C     SRInScn       BEGSR
334700200529
334800200529      ** Set up default values on Level 1 screen.
334900200529
335000200529     C                   MOVEL     'N'           DDSWPC
335100200529     C                   MOVEL     'D'           DDADDC
335200200529
335300200529      ** Save Incoming Payments Lvl 1 screen details.
335400200529
335500200529     C                   MOVEL     TranInIPY1    CurTrIPY1
335600200529     C                   MOVEL     TranInIP1A    CurTrIP1A
335700200529     C                   MOVEL     TranInIPY2    CurTrIPY2
335800200529     C                   MOVEL     TranInIPY3    CurTrIPY3
335900200529     C                   MOVEL     TranInIPY4    CurTrIPY4
336000200529     C                   MOVEL     TranInIP4A    CurTrIP4A
336100200529     C                   MOVEL     TranInIPY5    CurTrIPY5
336200200529     C                   MOVEL     TranInIPY6    CurTrIPY6
336300200529     C                   MOVEL     TranInIP6A    CurTrIP6A                                    CER030
336400200529     C                   IF        CSW209 = 'Y'                                               CSW209
336500200529     C                   MOVEL     TranInIPY7    CurTrIPY7                                    CSW209
336600200529     C                   MOVEL     TranInIPY8    CurTrIPY8                                    CSW209
336700200529     C                   ENDIF                                                                CSW209
336800200529
336900200529     C                   ENDSR
337000200529      *
337100200529      *****************************************************************
337200200529      /EJECT
337300200529      *****************************************************************
337400200529      *                                                               *
337500200529      *  SRMKey - To determine if the SWIFT Reference holds a '?'     *
337600200529      *           or a valid SWIFT Reference                          *
337700200529      *                                                               *
337800200529      *****************************************************************
337900200529
338000200529     C     SRMKey        BEGSR
338100200529
338200200529      ** Set up part number parameter.
338300200529
338400200529     C                   MOVEL     DDSEQNO       WSEQNO
338500200529
338600200529     C     WSEQNO        IFEQ      0
338700200529     C                   Z-ADD     1             PKPRT
338800200529     C                   ELSE
338900200529     C                   Z-ADD     WSEQNO        PKPRT
339000200529     C                   ENDIF
339100200529
339200200529      ** Check status of SWIFT Reference entered.
339300200529
339400200529     C                   CALL      'ME1080'                             0101
339500200529     C                   PARM      '*KEY   '     PACT
339600200529     C     PHMSGR        PARM      *ZEROS        PMSGR
339700200529     C     PHPART        PARM                    PKPRT
339800200529     C     PHMOR         PARM      DDSWTN        PMOR
339900200529     C     PHMIR         PARM      DDSWTN        PMIR
340000200529     C                   PARM      *BLANKS       PRTN
340100200529
340200200529      ** If call to program resulted in an error, then end program.
340300200529
340400200529     C     PRTN          IFEQ      '*ERROR*'
340500200529     C     *IN01         OREQ      *ON
340600200529     C                   MOVEL     '*CALL'       DBKEY
340700200529     C                   MOVEL     'ME1080'      DBFILE
340800200529     C                   Z-ADD     8             DBASE
340900200529     C                   EXSR      *PSSR
341000200529     C                   ENDIF
341100200529
341200200529      ** Message may not be processed by FT.
341300200529
341400200529     C     PRTN          IFEQ      'MIN0197'
341500200529     C                   MOVEL     'Y'           WErr
341600200529     C                   MOVEL     'MIN0197'     PErrMs
341700200529     C                   EXSR      SRSndM
341800200529     C                   MOVEL     *BLANKS       DDSWTN
341900200529     C                   GOTO      EMKey
342000200529     C                   ENDIF
342100200529
342200200529      ** A SWIFT Reference was entered.
342300200529
342400200529      ** If any errors are detected, an error indicator is set on,
342500200529      ** control returns to SREISwft and from there, returns
342600200529      ** immediately to Initial screen processing.
342700200529
342800200529      ** MIN0101 - SWIFT Reference not found or invalid.
342900200529
343000200529     C     PRTN          IFEQ      'MIN0101'
343100200529     C                   MOVEL     'Y'           WErr
343200200529     C                   MOVEL     'MIN0101'     PErrMs
343300200529     C                   MOVE      'N'           OKSWTN
343400200529     C                   EXSR      SRSndM
343500200529     C                   GOTO      EMKey
343600200529     C                   ENDIF
343700200529
343800200529      ** MIN0100 - Message part does not exist or has already been
343900200529      ** processed by Funds Transfer.
344000200529
344100200529     C     PRTN          IFEQ      'MIN0100'
344200200529     C                   MOVEL     'Y'           WErr
344300200529     C                   MOVEL     'MIN0100'     PErrMs
344400200529     C                   MOVE      'N'           OKSWTN
344500200529     C                   EXSR      SRSndM
344600200529     C                   GOTO      EMKey
344700200529     C                   ENDIF
344800200529
344900200529      ** MIN0103 - SWIFT Reference already reserved for this job.
345000200529
345100200529     C     PRTN          IFEQ      'MIN0103'
345200200529     C                   MOVEL     'Y'           WErr
345300200529     C                   MOVEL     'MIN0103'     PErrMs
345400200529     C                   MOVE      'N'           OKSWTN
345500200529     C                   EXSR      SRSndM
345600200529     C                   GOTO      EMKey
345700200529     C                   ENDIF
345800200529
345900200529      ** MIN0104 - SWIFT Reference reserved for another job.
346000200529
346100200529     C     PRTN          IFEQ      'MIN0104'
346200200529     C                   MOVEL     'Y'           WErr
346300200529     C                   MOVEL     'MIN0104'     PErrMs
346400200529     C                   MOVE      'N'           OKSWTN
346500200529     C                   EXSR      SRSndM
346600200529     C                   GOTO      EMKey
346700200529     C                   ENDIF
346800200529
346900200529     C     EMKey         ENDSR
347000200529
347100200529      *****************************************************************
347200200529      /EJECT
347300200529      *****************************************************************
347400200529      *                                                               *
347500200529      *  SRMsgRsv - To reserve a selected/entered electronic message  *
347600200529      *             for use by the current job only                   *
347700200529      *                                                               *
347800200529      *****************************************************************
347900200529
348000200529     C     SRMsgRsv      BEGSR
348100200529
348200200529      ** The SWIFT Reference must be written to the reserved messages
348300200529      ** file to prevent other workstations accessing it for update.
348400200529
348500200529     C                   CALL      'ME1070'                             0101
348600200529     C                   PARM      '*RESERV'     PACT
348700200529     C                   PARM                    PMSGR
348800200529     C                   PARM                    PKPRT
348900200529     C                   PARM                    PMOR
349000200529     C                   PARM                    PMIR
349100200529     C                   PARM      *BLANKS       PRTN
349200200529
349300200529      ** If call to program resulted in an error, then end program.
349400200529
349500200529     C     PRTN          IFEQ      '*ERROR*'
349600200529     C     *IN01         OREQ      *ON
349700200529     C                   MOVEL     '*CALL'       DBKEY
349800200529     C                   MOVEL     'ME1070'      DBFILE
349900200529     C                   Z-ADD     9             DBASE
350000200529     C                   EXSR      *PSSR
350100200529     C                   ENDIF
350200200529
350300200529      ** If any errors are detected, an error indicator is set on,
350400200529      ** control returns to SREISwft and from there, returns
350500200529      ** to Initial screen processing.
350600200529
350700200529      ** MIN0107 - Message previously reserved for this job.
350800200529
350900200529     C     PRTN          IFEQ      'MIN0107'
351000200529     C                   MOVEL     'Y'           WErr
351100200529     C                   MOVEL     'MIN0107'     PErrMs
351200200529     C                   MOVE      'N'           OKSWTN
351300200529     C                   EXSR      SRSndM
351400200529     C                   GOTO      EMsgRsv
351500200529     C                   ENDIF
351600200529
351700200529      ** MIN0108 - Message already reserved for another job.
351800200529
351900200529     C     PRTN          IFEQ      'MIN0108'
352000200529     C                   MOVEL     'Y'           WErr
352100200529     C                   MOVEL     'MIN0108'     PErrMs
352200200529     C                   MOVE      'N'           OKSWTN
352300200529     C                   EXSR      SRSndM
352400200529     C                   GOTO      EMsgRsv
352500200529     C                   ENDIF
352600200529
352700200529      ** If the SWIFT Reference is valid and available for use, then
352800200529      ** a reservation on the Reserved Messages file was made.
352900200529
353000200529      ** MIN0109 - Message is now reserved for this job.
353100200529
353200200529     C     PRTN          IFEQ      'MIN0109'
353300200529      **********                                                                      CSC022 BUG3279
353400200529      ***Execute commit if SAR CSC022 is not enrolled or                              CSC022 BUG3279
353500200529      *****job*is not currently running in batch mode                                 CSC022 BUG3279
353600200529      **********                                                                      CSC022 BUG3279
353700200529     C**********         If        CSC022 = 'N'                                       CSC022 BUG3279
353800200529     C**********                   Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')          CSC022 BUG3279
353900200529     C                   COMMIT
354000200529     C**********         EndIf                                                        CSC022 BUG3279
354100200529     C                   ENDIF
354200200529
354300200529     C     EMsgRsv       ENDSR
354400200529
354500200529      *****************************************************************                      BUG1282
354600200529      /EJECT                                                                                 BUG1282
354700200529      *****************************************************************                      BUG1282
354800200529      *                                                               *                      BUG1282
354900200529      *  DlRsMsg   - To delete the record that holds an electronic    *                      BUG1282
355000200529      *                message for use by the current job only        *                      BUG1282
355100200529      *                                                               *                      BUG1282
355200200529      *****************************************************************                      BUG1282
355300200529                                                                                             BUG1282
355400200529     C     DlRsMsg       BEGSR                                                               BUG1282
355500200529                                                                                             BUG1282
355600200529      ** The SWIFT Reference must be deleted from the reserved messages                      BUG1282
355700200529      ** file if the user cancels so that other workstations can access it                   BUG1282
355800200529                                                                                             BUG1282
355900200529     C                   CALL      'ME1070'                             0101                 BUG1282
356000200529     C                   PARM      '*END   '     PACT                                        BUG1282
356100200529     C                   PARM      *ZEROS        PMSGR                                       BUG1282
356200200529     C                   PARM      *ZEROS        PKPRT                                       BUG1282
356300200529     C                   PARM      *BLANKS       PMOR                                        BUG1282
356400200529     C                   PARM      *BLANKS       PMIR                                        BUG1282
356500200529     C                   PARM      *BLANKS       PRTN                                        BUG1282
356600200529                                                                                             BUG1282
356700200529      ** If call to program resulted in an error, then end program.                          BUG1282
356800200529                                                                                             BUG1282
356900200529     C     PRTN          IFEQ      '*ERROR*'                                                 BUG1282
357000200529     C     *IN01         OREQ      *ON                                                       BUG1282
357100200529     C                   MOVEL     '*CALL'       DBKEY                                       BUG1282
357200200529     C                   MOVEL     'ME1070'      DBFILE                                      BUG1282
357300200529     C                   Z-ADD     10            DBASE                                       BUG1282
357400200529     C                   EXSR      *PSSR                                                     BUG1282
357500200529     C                   ENDIF                                                               BUG1282
357600200529                                                                                             BUG1282
357700200529     C                   COMMIT                                                              BUG1282
357800200529                                                                                             BUG1282
357900200529     C                   ENDSR                                                               BUG1282
358000200529                                                                                             BUG1282
358100200529      *****************************************************************
358200200529      /EJECT
358300200529      *****************************************************************
358400200529      *                                                               *
358500200529      *  SrCcyA33B - Retrieve the amount/currency from tag 33B.       *
358600200529      *           or a valid SWIFT Reference                          *
358700200529      *                                                               *
358800200529      *****************************************************************
358900200529
359000200529     C     SrCcyA33B     BEGSR
359100200529
359200200529      ** INPUT
359300200529      ** =====
359400200529      ** DS for tags  (will NOT be blanked at the end of the S/R)
359500200529      **                                  DSTRAN
359600200529      ** OUTPUT
359700200529      ** ======
359800200529      ** Currency
359900200529
360000200529      ** Amount
360100200529     C                   MOVEL     *BLANKS       WCACY
360200200529     C                   MOVEL     *BLANKS       WCAAM
360300200529
360400200529      ** Currency
360500200529     C                   MOVEL     TTCCY         WCACY
360600200529
360700200529      ** Amount
360800200529      ** Format amount field (change ',' decimal point to '.').
360900200529
361000200529     C                   MOVE      *BLANKS       WYA1
361100200529     C                   MOVEA     TTAMT         WYA1
361200200529     C                   Z-ADD     1             CX
361300200529
361400200529     C                   DOU       CX > 15
361500200529
361600200529     C                   IF        WYA1(CX) =  ','
361700200529     C                   MOVE      '.'           WYA1(CX)
361800200529     C                   Z-ADD     16            Cx
361900200529     C                   ELSE
362000200529     C                   ADD       1             Cx
362100200529     C                   ENDIF
362200200529
362300200529     C                   ENDDO
362400200529
362500200529     C                   MOVEA     WYA1          WAMT
362600200529     C                   MOVEL     WAMT          WCAAM
362700200529
362800200529     C                   ENDSR
362900200529
363000200529      *****************************************************************
363100200529      /EJECT
363200200529      *****************************************************************
363300200529      *                                                               *
363400200529      *  SROV32AM  - Overwrite transaction amount                     *
363500200529      *                                                               *
363600200529      *****************************************************************
363700200529
363800200529     C     SROV32AM      BEGSR
363900200529
364000200529      ** INPUTS
364100200529      ** ------
364200200529      ** Input amount
364300200529     C     *LIKE         DEFINE    DDSMAM        WOVIAM
364400200529      ** Input currency
364500200529     C     *LIKE         DEFINE    DDSMCY        WOVICY
364600200529      ** Receiver's Charges amount
364700200529     C     *LIKE         DEFINE    DDSMAM        WOVRAM
364800200529      ** Receiver's Charges currency
364900200529     C     *LIKE         DEFINE    DDSMCY        WOVRCY
365000200529      ** Operation
365100200529     C                   MOVE      WOVOPR        WOVOPR            4
365200200529      ** Value date
365300200529     C     *LIKE         DEFINE    ZDateOut      WOVVLD
365400200529
365500200529      ** OUTPUTS
365600200529      ** -------
365700200529      ** Amount overwritten
365800200529     C     *LIKE         DEFINE    DDSMAM        WOVAMT
365900200529
366000200529      ** Temporary variables
366100200529      ** -------------------
366200200529      ** Transaction amount numeric format
366300200529     C     *LIKE         DEFINE    P#TOAM        WOVTAN
366400200529      ** Receiver's charges amount numeric format
366500200529     C     *LIKE         DEFINE    P#TOAM        WOVRCN
366600200529
366700200529      ** Reset output parameters and temporary variables
366800200529
366900200529     C                   MOVEL     *BLANK        WOVAMT
367000200529     C                   Z-ADD     0             WOVTAN
367100200529     C                   Z-ADD     0             WOVRCN
367200200529
367300200529      ** Retrieve details of transaction currency
367400200529
367500200529     C                   CALL      'AOCURRR0'                           8080
367600200529     C                   PARM      *BLANKS       PRTCD
367700200529     C                   PARM      '*KEY   '     POPTN
367800200529     C                   PARM      WOVICY        PCHR03
367900200529     C     SDCURR        PARM      *BLANKS       DSSDY
368000200529      *
368100200529      ** If both currencies are the same, we don't need to perform
368200200529      ** currency conversion before doing operation on the amounts
368300200529      *
368400200529     C                   IF        WOVICY = WOVRCY
368500200529      *
368600200529     C                   IF        PRTCD = *BLANKS AND
368700200529     C                             NOT(*IN80)
368800200529     C                   Z-ADD     A6NBDP        TRNBDP            1 0
368900200529     C                   Z-ADD     A6NBDP        RCNBDP            1 0
369000200529     C                   ENDIF
369100200529      *
369200200529      ** Format charges amount
369300200529     C                   MOVEL     *BLANK        ZFIELD
369400200529     C                   MOVEL     WOVRAM        ZFIELD
369500200529     C     13            SUB       RCNBDP        ZADIG
369600200529     C                   Z-ADD     RCNBDP        ZADEC
369700200529     C                   CALLB     'ZALIGN'
369800200529     C                   PARM                    ZalignOK
369900200529     C                   PARM                    ZFIELD
370000200529     C                   PARM                    ZADEC
370100200529     C                   PARM                    ZADIG
370200200529     C                   IF        ZAlignOk = 'Y'
370300200529     C                   MOVE      ZFIELD        WOVRCN
370400200529     C                   ENDIF
370500200529      *
370600200529      ** Format input amount
370700200529     C                   MOVEL     *BLANK        ZFIELD
370800200529     C                   MOVEL     WOVIAM        ZFIELD
370900200529     C     13            SUB       TRNBDP        ZADIG
371000200529     C                   Z-ADD     TRNBDP        ZADEC
371100200529     C                   CALLB     'ZALIGN'
371200200529     C                   PARM                    ZalignOK
371300200529     C                   PARM                    ZFIELD
371400200529     C                   PARM                    ZADEC
371500200529     C                   PARM                    ZADIG
371600200529     C                   IF        ZAlignOk = 'Y'
371700200529     C                   MOVE      ZFIELD        WOVTAN
371800200529     C                   ENDIF
371900200529      *
372000200529     C                   SELECT
372100200529     C                   WHEN      (WOVOPR = '*SUB')
372200200529      ** Final amount = Input amount - Charges amount
372300200529     C                   SUB       WOVRCN        WOVTAN
372400200529     C                   WHEN      (WOVOPR = '*ADD')
372500200529      ** Final amount = Input amount + Charges amount
372600200529     C                   ADD       WOVRCN        WOVTAN
372700200529     C                   ENDSL
372800200529      *
372900200529      ** Format Final amount
373000200529     C                   MOVEL     *BLANK        ZFIELD
373100200529     C                   MOVE      WOVTAN        ZFIELD
373200200529     C                   Z-ADD     TRNBDP        ZADEC
373300200529     C                   CALLB     'ZEDIT'
373400200529     C                   PARM                    ZFIELD
373500200529     C                   PARM                    ZADEC
373600200529     C                   MOVE      ZFIELD        WOVAMT
373700200529      *
373800200529     C                   ELSE
373900200529      *
374000200529      ** Currencies are different
374100200529      *
374200200529      ** Begin to fill parameters for FT0010 (currency conversion)
374300200529     C                   CLEAR                   P#0010
374400200529     C                   MOVEL     WOVRCY        P#FRCY
374500200529     C                   MOVEL     WOVICY        P#TOCY
374600200529      *
374700200529     C                   IF        PRTCD = *BLANKS AND
374800200529     C                             NOT(*IN80)
374900200529     C                   Z-ADD     A6NBDP        TRNBDP
375000200529     C                   ENDIF
375100200529     C                   Z-ADD     WOVVLD        P#FRDT
375200200529     C                   Z-ADD     WOVVLD        P#TODT
375300200529      *
375400200529      ** Retrieve details of currency of Receiver's Charges
375500200529     C                   CALL      'AOCURRR0'                           8080
375600200529     C                   PARM      *BLANKS       PRTCD
375700200529     C                   PARM      '*KEY   '     POPTN
375800200529     C                   PARM      WOVRCY        PCHR03
375900200529     C     SDCURR        PARM      *BLANKS       DSSDY
376000200529      *
376100200529     C                   IF        PRTCD = *BLANKS AND
376200200529     C                             NOT(*IN80)
376300200529     C                   Z-ADD     A6NBDP        RCNBDP
376400200529      ** Format charges amount
376500200529     C                   MOVEL     *BLANK        ZFIELD
376600200529     C                   MOVEL     WOVRAM        ZFIELD
376700200529     C     13            SUB       RCNBDP        ZADIG
376800200529     C                   Z-ADD     RCNBDP        ZADEC
376900200529     C                   CALLB     'ZALIGN'
377000200529     C                   PARM                    ZalignOK
377100200529     C                   PARM                    ZFIELD
377200200529     C                   PARM                    ZADEC
377300200529     C                   PARM                    ZADIG
377400200529     C                   IF        ZAlignOk = 'Y'
377500200529     C                   MOVE      ZFIELD        P#FRAM
377600200529     C                   ENDIF
377700200529      ** Convert the :71G: amount into the :32A: currency
377800200529     C                   CALL      'FT0010'
377900200529     C                   PARM                    P#0010
378000200529     C                   IF        P#RTCD <> *BLANK
378100200529     C                   MOVEL     'FT0010 '     DBFILE
378200200529     C                   MOVEL     '*CALL  '     DBKEY
378300200529     C                   Z-ADD     34            DBASE
378400200529     C                   EXSR      *PSSR
378500200529     C                   ELSE
378600200529     C                   Z-ADD     P#TOAM        WOVRCN           13 0
378700200529      ** Format input amount
378800200529     C                   MOVEL     *BLANK        ZFIELD
378900200529     C                   MOVEL     WOVIAM        ZFIELD
379000200529     C     13            SUB       TRNBDP        ZADIG
379100200529     C                   Z-ADD     TRNBDP        ZADEC
379200200529     C                   CALLB     'ZALIGN'
379300200529     C                   PARM                    ZalignOK
379400200529     C                   PARM                    ZFIELD
379500200529     C                   PARM                    ZADEC
379600200529     C                   PARM                    ZADIG
379700200529     C                   IF        ZAlignOk = 'Y'
379800200529     C                   MOVE      ZFIELD        WOVTAN           13 0
379900200529     C                   ENDIF
380000200529      *
380100200529     C                   SELECT
380200200529     C                   WHEN      (WOVOPR = '*SUB')
380300200529      ** Final amount = Input amount - Charges amount
380400200529     C                   SUB       WOVRCN        WOVTAN
380500200529     C                   WHEN      (WOVOPR = '*ADD')
380600200529      ** Final amount = Input amount + Charges amount
380700200529     C                   ADD       WOVRCN        WOVTAN
380800200529     C                   ENDSL
380900200529      *
381000200529      ** Format Final amount
381100200529     C                   MOVEL     *BLANK        ZFIELD
381200200529     C                   MOVE      WOVTAN        ZFIELD
381300200529     C                   Z-ADD     TRNBDP        ZADEC
381400200529     C                   CALLB     'ZEDIT'
381500200529     C                   PARM                    ZFIELD
381600200529     C                   PARM                    ZADEC
381700200529     C                   MOVE      ZFIELD        WOVAMT
381800200529     C                   ENDIF
381900200529      *
382000200529     C                   ENDIF
382100200529      *
382200200529     C                   ENDIF
382300200529      *
382400200529      ** Reset input parameters
382500200529      *
382600200529     C                   MOVEL     *BLANK        WOVIAM
382700200529     C                   MOVEL     *BLANK        WOVICY
382800200529     C                   MOVEL     *BLANK        WOVRAM
382900200529     C                   MOVEL     *BLANK        WOVRCY
383000200529     C                   MOVEL     *BLANK        WOVOPR
383100200529     C                   Z-ADD     0             WOVVLD
383200200529
383300200529     C                   ENDSR
383400200529      *
383500200529      *****************************************************************
383600200529      /EJECT
383700200529      *****************************************************************
383800200529      *                                                               *
383900200529      *  SRRATE36  - Retrieve rate from tag 36                        *
384000200529      *                                                               *
384100200529      *****************************************************************
384200200529      *
384300200529     C     SRRATE36      BEGSR
384400200529
384500200529      ** INPUTS
384600200529      ** ------
384700200529      ** Code work lines
384800200529      **                                  DSTRAN
384900200529      ** OUTPUTS
385000200529      ** -------
385100200529      ** Rate
385200200529     C     *LIKE         DEFINE    DDOEXR        W36RT
385300200529      ** Decimal Position Truncated
385400200529     C     *LIKE         DEFINE    A6NBDP        W36DPT
385500200529      ** Decimal Position
385600200529     C     *LIKE         DEFINE    A6NBDP        W36DP            +1
385700200529
385800200529     C                   MOVEL     *BLANK        W36RT
385900200529     C                   Z-ADD     0             W36DPT
386000200529     C                   Z-ADD     0             W36DP
386100200529
386200200529      ** Map Rate
386300200529      ** Move possible 12 chars to work array and work string
386400200529
386500200529     C     12            SUBST     TMLIN1:1      @R               13
386600200529     C                   MOVEA     @R            W@R1
386700200529     C                   CLEAR                   @R
386800200529
386900200529      ** If ',' in rate string @R change to '.'
387000200529      ** Only need to check valid chars till one ',' found
387100200529     C                   Z-ADD     1             @C                3 0
387200200529     C                   MOVE      *BLANK        @T                1
387300200529
387400200529     C     1             DO        12            @C
387500200529
387600200529     C     W@R1(@C)      IFEQ      ','
387700200529     C                   MOVE      '.'           W@R1(@C)
387800200529      ** Retrieve the number of decimal position
387900200529     C     W@CHK         CHECK     WWR1          @F                3 0
388000200529     C     @F            IFNE      0
388100200529     C     @F            SUB       1             @F
388200200529     C     @F            SUB       @C            W36DP
388300200529     C                   ELSE
388400200529     C     12            SUB       @C            W36DP
388500200529     C                   ENDIF
388600200529
388700200529      ** Decimal position can be handled only on one 1 digit
388800200529      ** => range 0-9  (otherwise truncated to 9)
388900200529     C     W36DP         IFGT      9
389000200529     C                   Z-ADD     9             W36DPT
389100200529     C                   ELSE
389200200529     C                   Z-ADD     W36DP         W36DPT
389300200529     C                   ENDIF
389400200529
389500200529     C                   LEAVE
389600200529     C                   ENDIF
389700200529
389800200529     C                   ENDDO
389900200529
390000200529     C                   Z-ADD     1             @C
390100200529     C                   MOVE      *BLANKS       @T                1
390200200529     C                   MOVEA     W@R1          @R
390300200529
390400200529      ** Get amount - upto 12 chars possible
390500200529
390600200529     C     @C            DOUGT     12
390700200529
390800200529     C                   MOVE      W@R1(@C)      @T
390900200529     C     W@CHK         CHECK     @T            @F                       82
391000200529
391100200529      ** Char not valid must be end of rate
391200200529     C     *IN82         IFEQ      *ON
391300200529     C     @C            IFNE      1
391400200529     C     @C            SUB       1             @F
391500200529     C     @F            SUBST     @R:1          W36RT
391600200529     C                   ENDIF
391700200529     C                   LEAVE
391800200529     C                   ENDIF
391900200529
392000200529      ** All chars in string are ok
392100200529     C     @C            IFEQ      12
392200200529     C                   MOVEL     @R            W36RT
392300200529     C                   ENDIF
392400200529
392500200529     C                   ADD       1             @C
392600200529
392700200529     C                   ENDDO
392800200529
392900200529     C                   ENDSR
393000200529
393100200529      *****************************************************************
393200200529      /EJECT
393300200529      *****************************************************************
393400200529      *                                                               *
393500200529      *  SRFOCmt2 - Extraction of field 72 from SWIFT Message         *
393600200529      *                                                               *
393700200529      *****************************************************************
393800200529      *
393900200529     C     SRFOCmt2      BEGSR
394000200529
394100200529      ** Initialise working fields for FONTIS.
394200200529
394300200529     C                   MOVE      *BLANKS       WCWCY             3
394400200529     C                   MOVE      *BLANKS       WCWAM            14
394500200529
394600200529      ** Retrieve Notified Delivery Currency and Amount.
394700200529
394800200529     C                   MOVEL     '012345'      WCHK             11
394900200529     C                   MOVE      '6789.'       WCHK
395000200529
395100200529     C     WCW           SCAN      WCWLIN:1      WF                3 0    01
395200200529
395300200529     C     *IN01         IFEQ      *ON
395400200529
395500200529      ** Map Currency Code -> ODDNDCY.
395600200529
395700200529     C                   ADD       6             WF
395800200529     C     3             SUBST     WCWLIN:WF     WCWCY
395900200529
396000200529      ** Map Amount -> ODDNDAM.
396100200529
396200200529      ** Move possible 15 chars to work array and work string.
396300200529
396400200529     C                   ADD       3             WF
396500200529     C     15            SUBST     WCWLIN:WF     WS               15
396600200529     C                   MOVEA     WS            WA
396700200529     C                   CLEAR                   WS
396800200529
396900200529      ** If ',' in amount string WS, change to '.'.
397000200529      ** Only need to check valid chars till one ',' found.
397100200529
397200200529     C                   Z-ADD     1             WC                3 0
397300200529     C                   MOVE      *BLANKS       WT                1
397400200529
397500200529     C     1             DO        15            WC
397600200529     C                   MOVE      WA(WC)        WT
397700200529     C     WT            IFEQ      ','
397800200529     C                   MOVE      '.'           WA(WC)
397900200529     C                   LEAVE
398000200529     C                   ENDIF
398100200529     C                   ENDDO
398200200529
398300200529     C                   Z-ADD     1             WC
398400200529     C                   MOVE      *BLANKS       WT                1
398500200529     C                   MOVEA     WA            WS
398600200529
398700200529      ** Get Amount - up to 15 chars possible.
398800200529
398900200529     C     WC            DOUGT     15
399000200529
399100200529     C                   MOVE      WA(WC)        WT
399200200529     C     WCHK          CHECK     WT            WF                       01
399300200529
399400200529      ** Char not valid, must be end of Amount.
399500200529
399600200529     C     *IN01         IFEQ      *ON
399700200529     C     WC            IFNE      1
399800200529     C     WC            SUB       1             WF
399900200529     C     WF            SUBST     WS:1          WCWAM
400000200529     C                   ENDIF
400100200529     C                   LEAVE
400200200529     C                   ENDIF
400300200529
400400200529      ** All chars in string ok.
400500200529
400600200529     C     WC            IFEQ      15
400700200529     C                   MOVEL     WS            WCWAM
400800200529     C                   ENDIF
400900200529
401000200529     C                   ADD       1             WC
401100200529
401200200529     C                   ENDDO
401300200529
401400200529     C                   ENDIF
401500200529
401600200529      ** Reset variables.
401700200529
401800200529     C                   MOVEL     *BLANKS       WCWLIN          256
401900200529     C                   MOVEL     *BLANKS       WCW               6
402000200529
402100200529     C                   ENDSR
402200200529
402300200529      *****************************************************************
402400200529      /EJECT
402500200529      *****************************************************************
402600200529      *                                                               *
402700200529      *  SRFont - Map translated data for Incoming FONTIS Messages    *
402800200529      *                                                               *
402900200529      *****************************************************************
403000200529      *
403100200529     C     SRFont        BEGSR
403200200529
403300200529      ** Set up defaults for FONTIS.
403400200529
403500200529     C                   MOVE      'N'           ODDSWPC
403600200529     C                   MOVE      *BLANKS       ODDACBK
403700200529     C                   MOVE      *BLANKS       ODDACBB
403800200529
403900200529      ** Retrieve Electronic Banking ICD details.
404000200529
404100200529     C                   CALL      'AOFONTR0'
404200200529     C                   PARM      *BLANKS       PRTCD
404300200529     C                   PARM      '*FIRST'      POPTN
404400200529     C     SDFONT        PARM      SDFONT        DSFDY
404500200529
404600200529     C     PRTCD         IFNE      *BLANKS
404700200529     C                   MOVEL     '*FIRST'      DBKEY
404800200529     C                   MOVEL     'SDFONTPD'    DBFILE
404900200529     C                   Z-ADD     027           DBASE
405000200529     C                   EXSR      *PSSR
405100200529     C                   ENDIF
405200200529
405300200529     C                   MOVE      F8IPST        ODDPYST
405400200529     C                   MOVE      F8TBKC        ODDBOKC
405500200529
405600200529      ** Related Reference.
405700200529
405800200529     C     P20           IFNE      *BLANKS
405900200529     C                   MOVEL     P20           DSTRAN
406000200529     C                   MOVEL     TTREF         IPRLPR
406100200529     C                   MOVEL     TTREF         ODDRLPR
406200200529     C                   ELSE
406300200529     C                   MOVEL     *BLANKS       IPRLPR
406400200529     C                   MOVEL     *BLANKS       ODDRLPR
406500200529     C                   ENDIF
406600200529
406700200529      ** Pay Currency/Value Date/Amount.
406800200529
406900200529     C     PDCA          IFNE      *BLANKS
407000200529
407100200529     C                   MOVEL     PDCA          DSTRAN
407200200529
407300200529      ** Pay Currency.
407400200529
407500200529     C                   MOVEL     TVCCY         ODDPCCY
407600200529
407700200529      ** Pay Amount.
407800200529
407900200529      ** Format amount field (change ',' decimal point to '.').
408000200529
408100200529     C                   MOVEA     *BLANKS       WYA1
408200200529     C                   MOVEA     TVAMT         WYA1
408300200529     C                   Z-ADD     1             Cx
408400200529
408500200529     C     Cx            DOUGT     15
408600200529     C     WYA1(Cx)      IFEQ      ','
408700200529     C                   MOVE      '.'           WYA1(Cx)
408800200529     C                   Z-ADD     16            Cx
408900200529     C                   ELSE
409000200529     C                   ADD       1             Cx
409100200529     C                   ENDIF
409200200529     C                   ENDDO
409300200529
409400200529     C                   MOVEA     WYA1          WNLAM
409500200529     C                   MOVEA     WYA1          WWPYAM           14
409600200529
409700200529     C                   EXSR      SRNull
409800200529
409900200529     C     WNLNUL        IFEQ      'N'
410000200529     C                   MOVEL     WWPYAM        ODDPYAM
410100200529     C                   ELSE
410200200529     C                   MOVEL     *BLANKS       ODDPYAM
410300200529     C                   ENDIF
410400200529
410500200529      ** Pay Value Date.
410600200529
410700200529     C                   MOVEL     TVVDAT        WWDT
410800200529
410900200529      ** MMDDYY format display.
411000200529
411100200529     C     BJDFIN        IFEQ      'M'
411200200529
411300200529     C                   EVAL      ODDPYDT = WD2 + WD3 + WD1
411400200529
411500200529     C                   ELSE
411600200529
411700200529      ** DDMMYY format display.
411800200529
411900200529     C                   EVAL      ODDPYDT = WD3 + WD2 + WD1
412000200529
412100200529     C                   ENDIF
412200200529
412300200529     C                   CALLB     'ZDATE1'
412400200529     C                   PARM      ODDPYDT       PDateIn           6
412500200529     C                   PARM      *ZERO         PDaynoOut         5 0
412600200529     C                   PARM      BJDFIN        PDateFmt          1
412700200529     C                   PARM                    PError            1
412800200529
412900200529     C     PError        IFNE      'Y'
413000200529     C                   Z-ADD     PDaynoOut     WVLDT
413100200529     C                   ELSE
413200200529     C                   Z-ADD     BJRDNB        WVLDT             5 0
413300200529     C                   ENDIF
413400200529
413500200529     C                   ENDIF
413600200529
413700200529      ** Debit Account.
413800200529
413900200529     C     P53           IFNE      *BLANKS
414000200529
414100200529     C                   MOVE      *BLANKS       WWP53P           35
414200200529     C                   MOVEL     P53           DSTRAN
414300200529     C                   MOVEL     TMLIN1        WWP53
414400200529
414500200529     C     WWP53A        IFEQ      '/'
414600200529     C                   MOVEL     WWP53B        WWP53P
414700200529     C                   ENDIF
414800200529
414900200529     C                   MOVEL     *BLANKS       ODDSND2
415000200529     C                   MOVEL     *BLANKS       ODDSND3
415100200529     C                   MOVEL     *BLANKS       ODDSND4
415200200529
415300200529     C     ' '           CHECKR    WWP53P        WWLEN             2 0
415400200529
415500200529      ** Check if it is a Retail Account.
415600200529
415700200529     C     WWLEN         IFEQ      10
415800200529
415900200529     C                   MOVEL     WWP53P        PPRETL
416000200529     C                   MOVEL     *BLANKS       PPCNUM
416100200529     C                   MOVEL     *BLANKS       PPCUCD
416200200529     C                   MOVEL     *BLANKS       PPACCD
416300200529     C                   MOVEL     *BLANKS       PPACSQ
416400200529     C                   MOVEL     *BLANKS       PPBRCA
416500200529
416600200529     C                   ELSE
416700200529
416800200529      ** Account is not Retail but General Ledger.
416900200529
417000200529     C                   MOVEL     *BLANKS       PPRETL
417100200529     C     3             SUBST     WWP53P:1      PPBRCA
417200200529     C     6             SUBST     WWP53P:4      PPCNUM
417300200529     C     3             SUBST     WWP53P:10     PPCUCD
417400200529     C*****4****         SUBST     WWP53P:13     PPACCD                                       CGL029
417500200529     C*****2****         SUBST     WWP53P:17     PPACSQ                                       CGL029
417600200529     C     10            SUBST     WWP53P:13     PPACCD                                       CGL029
417700200529     C     2             SUBST     WWP53P:23     PPACSQ                                       CGL029
417800200529
417900200529     C                   ENDIF
418000200529
418100200529      ** Access Account Details.
418200200529
418300200529     C                   CALLB     'AOACCTR0'
418400200529     C                   PARM      *BLANKS       PPRTCD            7
418500200529     C                   PARM      '*KEY   '     PPOPTN            7
418600200529     C                   PARM                    PPRETL           10
418700200529     C                   PARM                    PPCNUM            6
418800200529     C                   PARM                    PPCUCD            3
418900200529     C**********         PARM                    PPACCD            4                          CGL029
419000200529     C                   PARM                    PPACCD           10                          CGL029
419100200529     C                   PARM                    PPACSQ            2
419200200529     C                   PARM                    PPBRCA            3
419300200529     C     SDACCT        PARM      SDACCT        DSSDY
419400200529
419500200529     C                   IF        PRTCD = *BLANKS
419600200529
419700200529      ** If it is a G/L Account, we put the Branch as the end
419800200529      ** (BRCA/CUST/CCY/ACOD/SEQ) => (CUST/CCY/ACOD/SEQ/BRCA).
419900200529      ** If it is a Retail one, we don't format it.
420000200529
420100200529     C     WWLEN         IFEQ      10
420200200529     C                   MOVEL     WWP53P        ODDSND1
420300200529     C                   ELSE
420400200529     C     3             SUBST     WWP53P:1      WGLBCH
420500200529     C     3             SUBST     WWP53P:10     WGLCCY
420600200529     C     6             SUBST     WWP53P:4      WGLCST
420700200529     C*****4****         SUBST     WWP53P:13     WGLACD                                       CGL029
420800200529     C*****2****         SUBST     WWP53P:17     WGLSQN                                       CGL029
420900200529     C     10            SUBST     WWP53P:13     WGLACD                                       CGL029
421000200529     C     2             SUBST     WWP53P:23     WGLSQN                                       CGL029
421100200529     C                   MOVEL     WDSGLDG       ODDSND1
421200200529     C                   ENDIF
421300200529
421400200529     C                   MOVEL     IFBRCA        ODDBRCA
421500200529     C                   MOVEL     IFBRCA        ODDORBR
421600200529
421700200529     C                   ELSE
421800200529
421900200529      ** If no valid account in tag 53 we concatenate line of
422000200529      ** 53 (A/C debited)  + first lines of 50 (Ord Cust)
422100200529     C                   MOVEL     WWP53P        ODDSND1
422200200529     C                   MOVEL     P50           DSTRAN
422300200529     C                   MOVEL     TMLIN1        ODDSND2
422400200529     C                   MOVEL     TMLIN2        ODDSND3
422500200529     C                   MOVEL     TMLIN3        ODDSND4
422600200529
422700200529     C                   ENDIF
422800200529
422900200529     C                   ENDIF
423000200529
423100200529      ** Profit Centre.
423200200529
423300200529     C     BKPRCU        IFEQ      'Y'
423400200529
423500200529      ** Retrieve default Profit Centre.
423600200529
423700200529     C     BKPCDU        IFEQ      'Y'
423800200529
423900200529     C                   CALLB     'AOPRFMR0'                           01
424000200529     C                   PARM      *BLANKS       PRTCD
424100200529     C                   PARM      ODDBOKC       PBOKC             2
424200200529     C                   PARM      PPYTP         PTRTP             5
424300200529     C                   PARM      ODDPYST       PSUTP             2
424400200529     C                   PARM      ODDBRCA       PBRAN             3
424500200529     C                   PARM      *BLANKS       PDEPT             3
424600200529     C                   PARM      *BLANKS       PUSER            10
424700200529     C                   PARM      *BLANKS       PACOF             2
424800200529     C                   PARM      *BLANKS       PCUST             6
424900200529     C     ODDPRFC       PARM      *BLANKS       PPRFC             4
425000200529
425100200529     C                   IF        *In01 = *On
425200200529     C                   MOVEL     '*CALL'       DBKEY
425300200529     C                   MOVEL     'AOPRFMR0'    DBFILE
425400200529     C                   Z-ADD     028           DBASE
425500200529     C                   EXSR      *PSSR
425600200529     C                   ENDIF
425700200529
425800200529     C                   ENDIF
425900200529
426000200529     C     ODDPRFC       IFEQ      *BLANKS
426100200529     C                   MOVEL     F8TPFC        ODDPRFC
426200200529     C                   ENDIF
426300200529
426400200529     C                   ENDIF
426500200529
426600200529      ** Beneficiary Customer.
426700200529
426800200529     C     P59           IFNE      *BLANKS
426900200529
427000200529     C                   MOVE      *BLANKS       WWP59P           35
427100200529     C                   MOVEL     P59           DSTRAN
427200200529     C                   MOVEL     TMLIN1        WWP59
427300200529
427400200529     C     WWP59A        IFEQ      '/'
427500200529     C                   MOVEL     WWP59B        WWP59P
427600200529     C                   ENDIF
427700200529
427800200529     C     ' '           CHECKR    WWP59P        WWLEN
427900200529
428000200529      ** Check if it is a Retail Account.
428100200529
428200200529     C     WWLEN         IFEQ      10
428300200529
428400200529     C                   MOVEL     WWP59P        PPRETL
428500200529     C                   MOVEL     *BLANKS       PPCNUM
428600200529     C                   MOVEL     *BLANKS       PPCUCD
428700200529     C                   MOVEL     *BLANKS       PPACCD
428800200529     C                   MOVEL     *BLANKS       PPACSQ
428900200529     C                   MOVEL     *BLANKS       PPBRCA
429000200529
429100200529     C                   ELSE
429200200529
429300200529      ** Account is not Retail but General Ledger.
429400200529
429500200529     C                   MOVEL     *BLANKS       PPRETL
429600200529     C     3             SUBST     WWP59P:1      PPBRCA
429700200529     C     6             SUBST     WWP59P:4      PPCNUM
429800200529     C     3             SUBST     WWP59P:10     PPCUCD
429900200529     C*****4****         SUBST     WWP59P:13     PPACCD                                       CGL029
430000200529     C*****2****         SUBST     WWP59P:17     PPACSQ                                       CGL029
430100200529     C     10            SUBST     WWP59P:13     PPACCD                                       CGL029
430200200529     C     2             SUBST     WWP59P:23     PPACSQ                                       CGL029
430300200529
430400200529     C                   ENDIF
430500200529
430600200529      ** Access Account details.
430700200529
430800200529     C                   CALL      'AOACCTR0'
430900200529     C                   PARM      *BLANKS       PPRTCD
431000200529     C                   PARM      '*KEY   '     PPOPTN
431100200529     C                   PARM                    PPRETL
431200200529     C                   PARM                    PPCNUM
431300200529     C                   PARM                    PPCUCD
431400200529     C                   PARM                    PPACCD
431500200529     C                   PARM                    PPACSQ
431600200529     C                   PARM                    PPBRCA
431700200529     C     SDACCT        PARM      SDACCT        DSSDY
431800200529
431900200529     C     PPRTCD        IFEQ      *BLANKS
432000200529
432100200529     C     WWLEN         IFEQ      10
432200200529     C                   MOVEL     WWP59P        ODDBNC1
432300200529     C                   ELSE
432400200529     C     3             SUBST     WWP59P:1      WWBCH1
432500200529     C     6             SUBST     WWP59P:4      WWCUS1
432600200529     C*****4****         SUBST     WWP59P:13     WWACD1                                       CGL029
432700200529     C*****2****         SUBST     WWP59P:17     WWSQN1                                       CGL029
432800200529     C     4             SUBST     WWP59P:13     WWACD1                                       CGL029
432900200529     C     2             SUBST     WWP59P:17     WWSQN1                                       CGL029
433000200529     C                   MOVEL     WWBNC1        ODDBNC1
433100200529     C                   ENDIF
433200200529
433300200529     C                   MOVEL     *BLANKS       ODDBNC2
433400200529     C                   MOVEL     *BLANKS       ODDBNC3
433500200529     C                   MOVEL     *BLANKS       ODDBNC4
433600200529     C                   MOVEL     *BLANKS       ODDBNC5
433700200529
433800200529     C                   ENDIF
433900200529
434000200529     C                   ENDIF
434100200529
434200200529      ** Details of Charges.
434300200529
434400200529     C     P71           IFNE      *BLANKS
434500200529
434600200529     C                   MOVEL     P71           DSTRAN
434700200529
434800200529     C     TTREF         IFEQ      'OUR'
434900200529     C                   MOVEL     'A'           ODDADDC
435000200529     C                   ELSE
435100200529     C                   MOVEL     'D'           ODDADDC
435200200529     C                   ENDIF
435300200529
435400200529     C                   ELSE
435500200529
435600200529     C                   MOVEL     'D'           ODDADDC
435700200529
435800200529     C                   ENDIF
435900200529
436000200529      ** Sender to Receiver Information.
436100200529
436200200529     C     P72           IFEQ      *BLANKS
436300200529
436400200529      ** Settlement CCY will be the same as the Account to be Debited.
436500200529
436600200529     C                   MOVEL     *BLANKS       ODDSMCY
436700200529
436800200529      ** FT fields have been cleared in SREISwft.
436900200529
437000200529     C                   ELSE
437100200529
437200200529     C                   EXSR      SRICChk
437300200529
437400200529     C                   MOVEL     P72           DSFONT
437500200529     C     WFound        IFEQ      'Y'
437600200529     C                   MOVEL     *BLANKS       ODDBBI6
437700200529     C                   MOVEL     FN72L2        ODDBBI1
437800200529     C                   MOVEL     FN72L3        ODDBBI2
437900200529     C                   MOVEL     FN72L4        ODDBBI3
438000200529     C                   MOVEL     FN72L5        ODDBBI4
438100200529     C                   MOVEL     FN72L6        ODDBBI5
438200200529     C                   ELSE
438300200529     C                   MOVEL     FN72L1        ODDBBI1
438400200529     C                   MOVEL     FN72L2        ODDBBI2
438500200529     C                   MOVEL     FN72L3        ODDBBI3
438600200529     C                   MOVEL     FN72L4        ODDBBI4
438700200529     C                   MOVEL     FN72L5        ODDBBI5
438800200529     C                   MOVEL     FN72L6        ODDBBI6
438900200529     C                   ENDIF
439000200529
439100200529     C                   MOVEL     '/REF/'       WCW
439200200529     C                   MOVEL     FONT72        WCWLIN
439300200529     C                   Z-ADD     30            WCWLEN
439400200529     C                   EXSR      SRCWVAL
439500200529     C     WCWVAL        IFNE      *BLANK
439600200529     C                   MOVEL     WCWVAL        ODDFDLR
439700200529     C                   ENDIF
439800200529
439900200529     C                   MOVEL     '/ORIG/'      WCW
440000200529     C                   MOVEL     FONT72        WCWLIN
440100200529     C                   EXSR      SRFOCmt2
440200200529     C     WCWCY         IFNE      *BLANK
440300200529     C                   MOVEL     WCWCY         ODDSMCY
440400200529     C                   ELSE
440500200529     C                   MOVEL     *BLANKS       ODDSMCY
440600200529     C                   ENDIF
440700200529
440800200529     C                   MOVEL     WCWAM         WNLAM
440900200529     C                   EXSR      SRNull
441000200529
441100200529     C     WNLNUL        IFEQ      'N'
441200200529     C                   MOVEL     WCWAM         ODDSMAM
441300200529     C                   ELSE
441400200529     C                   MOVEL     *BLANKS       ODDSMAM
441500200529     C                   ENDIF
441600200529
441700200529     C                   MOVEL     '/RATE/'      WCW
441800200529     C                   MOVEL     FONT72        WCWLIN
441900200529     C                   EXSR      SRRate
442000200529     C                   MOVEL     WCWRT         WNLAM
442100200529     C                   EXSR      SRNull
442200200529
442300200529     C     WNLNUL        IFEQ      'Y'
442400200529
442500200529     C                   MOVEL     *BLANKS       WCWRT
442600200529
442700200529     C                   ELSE
442800200529
442900200529      ** Decimal places in FT are stored on 8 digits
443000200529      ** => truncated if greater.
443100200529
443200200529     C     WCWDPT        IFGT      8
443300200529
443400200529     C     '.'           SCAN      WCWRT         IN                2 0
443500200529
443600200529      ** Extract Digits + comma.
443700200529
443800200529     C     IN            SUBST(P)  WCWRT:1       W014A            14
443900200529     C                   ADD       1             IN
444000200529
444100200529      ** Extract Decimals after comma.
444200200529
444300200529     C     8             SUBST(P)  WCWRT:IN      W008A             8
444400200529     C     W014A         CAT(P)    W008A:0       WCWRT
444500200529
444600200529     C                   ENDIF
444700200529
444800200529     C                   ENDIF
444900200529
445000200529     C     WCWRT         IFNE      *BLANKS
445100200529     C                   MOVE      WCWRT         ODDRATE
445200200529     C                   ENDIF
445300200529
445400200529     C                   ENDIF
445500200529
445600200529     C                   MOVEL     'N'           ODDOPIN
445700200529     C                   MOVEL     *BLANKS       ODDNDAM
445800200529
445900200529     C     ODDSMCY       IFEQ      ODDNDCY
446000200529     C                   MOVEL     *BLANK        ODDNDCY
446100200529     C                   ENDIF
446200200529
446300200529     C                   MOVEL     *BLANKS       ODDSNC1
446400200529     C                   MOVEL     *BLANKS       ODDSNC2
446500200529     C                   MOVEL     *BLANKS       ODDSNC3
446600200529     C                   MOVEL     *BLANKS       ODDSNC4
446700200529     C                   MOVEL     *BLANKS       ODDSNC5
446800200529     C                   MOVEL     *BLANKS       ODDINB1
446900200529     C                   MOVEL     *BLANKS       ODDINB2
447000200529     C                   MOVEL     *BLANKS       ODDINB3
447100200529     C                   MOVEL     *BLANKS       ODDINB4
447200200529     C                   MOVEL     *BLANKS       ODDINB5
447300200529
447400200529     C                   ENDSR
447500200529
447600200529      *****************************************************************
447700200529      /EJECT
447800200529      *****************************************************************
447900200529      *                                                               *
448000200529      *  SRNull - Test if Amount is null                              *
448100200529      *                                                               *
448200200529      *****************************************************************
448300200529
448400200529     C     SRNULL        BEGSR
448500200529
448600200529      ** Initialise working fields.
448700200529
448800200529     C                   MOVEL     'Y'           WNLNUL            1
448900200529     C                   MOVEL     '123456'      WNUL              9
449000200529     C                   MOVE      '789'         WNUL
449100200529
449200200529     C     WNLAM         IFNE      *BLANK
449300200529     C                   MOVEL     *BLANKS       WYA1
449400200529     C                   MOVEA     WNLAM         WYA1
449500200529
449600200529     C                   DO        15            IN
449700200529
449800200529     C     WNUL          CHECK     WYA1(IN)                               01
449900200529
450000200529     C     *IN01         IFEQ      '0'
450100200529     C                   MOVEL     'N'           WNLNUL
450200200529     C                   LEAVE
450300200529     C                   ENDIF
450400200529
450500200529     C                   ENDDO
450600200529
450700200529     C                   ENDIF
450800200529
450900200529      ** Initialise working fields.
451000200529
451100200529     C                   MOVEL     *BLANKS       WNLAM            15
451200200529     C                   MOVEL     *BLANKS       WYA1              1
451300200529
451400200529     C                   ENDSR
451500200529      *
451600200529      *****************************************************************
451700200529      /EJECT
451800200529      *****************************************************************
451900200529      *                                                               *
452000200529      *  SRICChk - Scan for /OCMT/, /ORIG/, /RATE/                    *
452100200529      *                                                               *
452200200529      *****************************************************************
452300200529
452400200529     C     SRICChk       BEGSR
452500200529
452600200529     C                   MOVEL     *BLANKS       WFound            1
452700200529
452800200529     C     '/RATE/'      SCAN      P72:1         PX                3 0    81
452900200529     C     *IN81         IFEQ      *OFF
453000200529     C     '/ORIG/'      SCAN      P72:1         PX                       81
453100200529     C     *IN81         IFEQ      *OFF
453200200529     C     '/OCMT/'      SCAN      P72:1         PX                       81
453300200529     C                   ENDIF
453400200529     C                   ENDIF
453500200529
453600200529     C     *IN81         IFEQ      *ON
453700200529     C                   MOVE      'Y'           WFound
453800200529     C                   ENDIF
453900200529
454000200529     C                   ENDSR
454100200529
454200200529      *****************************************************************
454300200529      /EJECT
454400200529      *****************************************************************
454500200529      *                                                               *
454600200529      *  SRRate - Retrieve the Rate and the Multiply/Divide indicator *
454700200529      *                                                               *
454800200529      *****************************************************************
454900200529
455000200529     C     SRRate        BEGSR
455100200529
455200200529      ** Reset work variables.
455300200529
455400200529     C                   MOVEL     *BLANK        WCWRT            14
455500200529     C                   Z-ADD     0             WCWDPT            1 0
455600200529     C                   Z-ADD     0             WCWDP             2 0
455700200529
455800200529     C     WCW           SCAN      WCWLIN:1      WF                3 0    01
455900200529
456000200529     C     *IN01         IFEQ      *ON
456100200529
456200200529     C                   ADD       6             WF
456300200529
456400200529      ** Move possible 13 chars to work array and work string.
456500200529
456600200529     C     13            SUBST     WCWLIN:WF     WR               13
456700200529     C                   MOVEA     WR            WSR
456800200529     C                   CLEAR                   WR
456900200529
457000200529      ** If ',' in rate string WR, change to '.'.
457100200529      ** Only need to check valid chars till one ',' found.
457200200529
457300200529     C                   Z-ADD     1             WC                3 0
457400200529     C                   MOVE      *BLANKS       WT                1
457500200529
457600200529     C     1             DO        13            WC
457700200529
457800200529     C     WSR(WC)       IFEQ      ','
457900200529
458000200529     C                   MOVE      '.'           WSR(WC)
458100200529
458200200529      ** Retrieve the number of decimal position.
458300200529
458400200529     C     WCHK          CHECK     WR1           WF                3 0
458500200529     C     WF            IFNE      0
458600200529     C     WF            SUB       1             WF
458700200529     C     WF            SUB       WC            WCWDP
458800200529     C                   ELSE
458900200529     C     13            SUB       WC            WCWDP
459000200529     C                   ENDIF
459100200529
459200200529      ** Decimal position can be handled only on one 1 digit
459300200529      ** => range 0-9  (otherwise, truncated to 9).
459400200529
459500200529     C     WCWDP         IFGT      9
459600200529     C                   Z-ADD     9             WCWDPT
459700200529     C                   ELSE
459800200529     C                   Z-ADD     WCWDP         WCWDPT
459900200529     C                   ENDIF
460000200529
460100200529     C                   LEAVE
460200200529
460300200529     C                   ENDIF
460400200529
460500200529     C                   ENDDO
460600200529
460700200529     C                   Z-ADD     1             WC
460800200529     C                   MOVE      *BLANKS       WT                1
460900200529     C                   MOVEA     WSR           WR
461000200529
461100200529      ** Get Amount - up to 13 chars possible.
461200200529
461300200529     C     WC            DOUGT     13
461400200529
461500200529     C                   MOVE      WSR(WC)       WT
461600200529     C     WCHK          CHECK     WT            WF                       01
461700200529
461800200529      ** Char not valid must be end of rate.
461900200529
462000200529     C     *IN01         IFEQ      *ON
462100200529     C     WC            IFNE      1
462200200529     C     WC            SUB       1             WF
462300200529     C     WF            SUBST     WR:1          WCWRT
462400200529     C                   ENDIF
462500200529     C                   LEAVE
462600200529     C                   ENDIF
462700200529
462800200529      ** All chars in string ok.
462900200529
463000200529     C     WC            IFEQ      13
463100200529     C                   MOVEL     WR            WCWRT
463200200529     C                   ENDIF
463300200529
463400200529     C                   ADD       1             WC
463500200529
463600200529     C                   ENDDO
463700200529
463800200529     C                   ENDIF
463900200529
464000200529      ** Reset input variables.
464100200529
464200200529     C                   MOVEL     *BLANKS       WCWLIN
464300200529     C                   MOVEL     *BLANKS       WCW
464400200529
464500200529     C                   ENDSR
464600200529
464700200529      *****************************************************************
464800200529      /EJECT
464900200529      *****************************************************************
465000200529      *                                                               *
465100200529      *  SRIMsg - Map translated data for incoming messages           *
465200200529      *                                                               *
465300200529      *****************************************************************
465400200529
465500200529     C     SRIMsg        BEGSR
465600200529
465700200529      ** Set up the detail screen fields from the message.
465800200529
465900200529      ** Sender.
466000200529
466100200529      ** In FONTIS, this field can be translated only by
466200200529      ** the sender correspondant (P53).
466300200529
466400200529     C     PNWRK         IFNE      'FONTIS'
466500200529
466600200529     C     PSN           IFNE      *BLANKS
466700200529
466800200529     C                   MOVEL     PSN           DSTRAN
466900200529
467000200529     C     TRCODE        IFNE      *BLANKS
467100200529
467200200529      ** Translate to Nostro and Retail account numbers.
467300200529
467400200529     C                   EXSR      SRTran
467500200529
467600200529     C                   SELECT
467700200529
467800200529      ** If Local and Account Currency Local, then use Retail number.
467900200529
468000200529     C     BJLCCY        WHENEQ    ODDSMCY
468100200529     C     WRCYCD        ANDEQ     ODDSMCY
468200200529     C     WWACNO        ANDNE     0
468300200529     C                   MOVE      *BLANKS       ODDSND1
468400200529     C                   MOVE      *BLANKS       ODDSND2
468500200529     C                   MOVE      *BLANKS       ODDSND3
468600200529     C                   MOVE      *BLANKS       ODDSND4
468700200529     C                   MOVEL     WWACNO        ODDSND1
468800200529
468900200529      ** If Currency the same as Settle and Nostro, use Nostro.
469000200529
469100200529     C     WWNCCY        WHENEQ    ODDSMCY
469200200529     C     WWNONB        ANDNE     *BLANKS
469300200529     C                   MOVE      *BLANKS       ODDSND1
469400200529     C                   MOVE      *BLANKS       ODDSND2
469500200529     C                   MOVE      *BLANKS       ODDSND3
469600200529     C                   MOVE      *BLANKS       ODDSND4
469700200529     C     WWNCCY        CAT(P)    WWNONB        ODDSND1
469800200529
469900200529      ** If Currency the same, use GL Account.
470000200529
470100200529     C     WRCYCD        WHENEQ    ODDSMCY
470200200529     C                   MOVE      *BLANKS       ODDSND1
470300200529     C                   MOVE      *BLANKS       ODDSND2
470400200529     C                   MOVE      *BLANKS       ODDSND3
470500200529     C                   MOVE      *BLANKS       ODDSND4
470600200529     C     BGMBIN        IFNE      'Y'
470700200529     C                   MOVE      '   '         TRCODE
470800200529     C                   ENDIF
470900200529     C                   MOVEL     TRCODE        ODDSND1
471000200529
471100200529      ** Use Customer Number.
471200200529
471300200529     C                   OTHER
471400200529     C                   MOVE      *BLANKS       ODDSND1
471500200529     C                   MOVE      *BLANKS       ODDSND2
471600200529     C                   MOVE      *BLANKS       ODDSND3
471700200529     C                   MOVE      *BLANKS       ODDSND4
471800200529     C                   MOVEL     WRCNUM        ODDSND1
471900200529
472000200529     C                   ENDSL
472100200529
472200200529     C                   ELSE
472300200529
472400200529     C                   MOVEL     TMLIN2        ODDSND2
472500200529
472600200529     C                   ENDIF
472700200529
472800200529     C                   ENDIF
472900200529
473000200529     C                   ENDIF
473100200529
473200200529      ** Senders Correspondent.
473300200529
473400200529      **  By default, will translate the Sender field in FONTIS.
473500200529
473600200529     C                   MOVEL     P54           DSTRAN
473700200529     C                   MOVEL     TRCODE        WRCDE2
473800200529
473900200529     C     P54           IFEQ      *BLANKS
474000200529     C     P53           ANDNE     *BLANKS
474100200529     C     P54           ORNE      *BLANKS
474200200529     C     WRCNUM        ANDEQ     '501116'
474300200529     C     P53           ANDNE     *BLANKS
474400200529
474500200529     C                   MOVEL     P53           DSTRAN
474600200529     C                   MOVEL     TRCODE        WRCDE2
474700200529
474800200529     C     TRCODE        IFNE      *BLANKS
474900200529     C     WRCNUM        ANDNE     '501116'
475000200529
475100200529      ** Translate to Nostro and Retail account numbers.
475200200529
475300200529     C                   EXSR      SRTran
475400200529
475500200529     C                   SELECT
475600200529
475700200529      ** If Local and Account Currency Local, then use Retail number.
475800200529
475900200529     C     BJLCCY        WHENEQ    ODDSMCY
476000200529     C     WRCYCD        ANDEQ     ODDSMCY
476100200529     C     WWACNO        ANDNE     0
476200200529     C                   MOVE      *BLANKS       ODDSND1
476300200529     C                   MOVE      *BLANKS       ODDSND2
476400200529     C                   MOVE      *BLANKS       ODDSND3
476500200529     C                   MOVE      *BLANKS       ODDSND4
476600200529     C                   MOVEL     WWACNO        ODDSND1
476700200529
476800200529      ** If Currency the same as Settle and Nostro, use Nostro.
476900200529
477000200529     C     WWNCCY        WHENEQ    ODDSMCY
477100200529     C     WWNONB        ANDNE     *BLANKS
477200200529     C                   MOVE      *BLANKS       ODDSND1
477300200529     C                   MOVE      *BLANKS       ODDSND2
477400200529     C                   MOVE      *BLANKS       ODDSND3
477500200529     C                   MOVE      *BLANKS       ODDSND4
477600200529     C     WWNCCY        CAT(P)    WWNONB        ODDSND1
477700200529
477800200529      ** If Currency the same, use GL Account.
477900200529
478000200529     C     WRCYCD        WHENEQ    ODDSMCY
478100200529     C                   MOVE      *BLANKS       ODDSND1
478200200529     C                   MOVE      *BLANKS       ODDSND2
478300200529     C                   MOVE      *BLANKS       ODDSND3
478400200529     C                   MOVE      *BLANKS       ODDSND4
478500200529     C     BGMBIN        IFNE      'Y'
478600200529     C                   MOVE      '   '         TRCODE
478700200529     C                   ENDIF
478800200529     C                   MOVEL     TRCODE        ODDSND1
478900200529
479000200529      ** Use Customer Number.
479100200529
479200200529     C                   OTHER
479300200529     C                   MOVE      *BLANKS       ODDSND1
479400200529     C                   MOVE      *BLANKS       ODDSND2
479500200529     C                   MOVE      *BLANKS       ODDSND3
479600200529     C                   MOVE      *BLANKS       ODDSND4
479700200529     C                   MOVEL     WRCNUM        ODDSND1
479800200529
479900200529     C                   ENDSL
480000200529
480100200529     C                   ENDIF
480200200529
480300200529     C                   ENDIF
480400200529
480500200529      ** Receiver's Correspondent.
480600200529
480700200529     C                   SELECT
480800200529
480900200529     C     PNWRK         WHENEQ    'YENKSI'
481000200529
481100200529     C     P54           WHENNE    *BLANKS
481200200529
481300200529     C                   MOVEL     P54           DSTRAN
481400200529     C                   MOVEL     TRCODE        WRCDE2
481500200529     C     TRCODE        IFNE      *BLANKS
481600200529     C     WRCNUM        ANDEQ     '501116'
481700200529     C                   MOVE      *BLANKS       ODDRCO1
481800200529     C                   ENDIF
481900200529
482000200529     C     TRCODE        IFNE      *BLANKS
482100200529     C     WRCNUM        ANDNE     '501116'
482200200529
482300200529      ** Translate to Nostro and Retail account numbers.
482400200529
482500200529     C                   EXSR      SRTran
482600200529
482700200529     C                   SELECT
482800200529
482900200529      ** If Local and Account Currency Local, then use Retail number.
483000200529
483100200529     C     BJLCCY        WHENEQ    ODDSMCY
483200200529     C     WRCYCD        ANDEQ     ODDSMCY
483300200529     C     WWACNO        ANDNE     0
483400200529     C                   MOVE      *BLANKS       ODDRCO1
483500200529     C                   MOVEL     WWACNO        ODDRCO1
483600200529
483700200529      ** If Currency the same as Settle and Nostro, use Nostro.
483800200529
483900200529     C     WWNCCY        WHENEQ    ODDSMCY
484000200529     C     WWNONB        ANDNE     *BLANKS
484100200529     C                   MOVE      *BLANKS       ODDRCO1
484200200529     C                   MOVEL     WWNONB        ODDRCO1
484300200529
484400200529      ** Use Customer Number.
484500200529
484600200529     C                   OTHER
484700200529     C                   MOVE      *BLANKS       ODDRCO1
484800200529     C                   MOVEL     WRCNUM        ODDRCO1
484900200529
485000200529     C                   ENDSL
485100200529
485200200529     C                   ENDIF
485300200529
485400200529     C                   ENDSL
485500200529
485600200529      ** Account with Institution.
485700200529
485800200529      ** Can't be translated if FONTIS message.
485900200529
486000200529     C     PNWRK         IFNE      'FONTIS'
486100200529
486200200529     C     P57           IFNE      *BLANKS
486300200529
486400200529     C                   MOVEL     P57           DSTRAN
486500200529
486600200529      ** Translate to Nostro and Retail account numbers.
486700200529
486800200529     C     TRCODE        IFNE      *BLANKS
486900200529
487000200529     C                   EXSR      SRTran
487100200529
487200200529     C                   SELECT
487300200529
487400200529      ** If Local and Account Currency Local, then use Retail number.
487500200529
487600200529     C     BJLCCY        WHENEQ    ODDSMCY
487700200529     C     WRCYCD        ANDEQ     ODDSMCY
487800200529     C     WWACNO        ANDNE     0
487900200529     C                   MOVE      *BLANKS       ODDACBK
488000200529     C                   MOVEL     WWACNO        ODDACBK
488100200529
488200200529      ** If Currency the same as Settle and Nostro, use Nostro.
488300200529
488400200529     C     WWNCCY        WHENEQ    ODDSMCY
488500200529     C     WWNONB        ANDNE     *BLANKS
488600200529     C                   MOVE      *BLANKS       ODDACBK
488700200529     C                   MOVEL     WWNONB        ODDACBK
488800200529
488900200529      ** If Currency the same, use GL Account.
489000200529
489100200529     C     WRCYCD        WHENEQ    ODDSMCY
489200200529     C                   MOVE      *BLANKS       ODDACBK
489300200529     C     WRCNUM        CAT       WRCDSQ        ODDACBK
489400200529     C     BGMBIN        IFEQ      'Y'
489500200529     C                   MOVE      WRBRCD        ODDACBB
489600200529     C                   ENDIF
489700200529
489800200529      ** Use Customer Number.
489900200529
490000200529     C                   OTHER
490100200529     C                   MOVE      *BLANKS       ODDACBK
490200200529     C                   MOVEL     WRCNUM        ODDACBK
490300200529
490400200529     C                   ENDSL
490500200529
490600200529     C                   ENDIF
490700200529
490800200529     C                   ENDIF
490900200529
491000200529     C                   ENDIF
491100200529
491200200529      ** Beneficiary Institution/ Beneficiary Customer.
491300200529
491400200529     C     P58           IFNE      *BLANKS
491500200529
491600200529     C                   MOVEL     P58           DSTRAN
491700200529
491800200529     C     TRCODE        IFNE      *BLANKS
491900200529
492000200529      ** Translate to Nostro and Retail account numbers.
492100200529
492200200529     C                   EXSR      SRTran
492300200529
492400200529     C                   SELECT
492500200529
492600200529      ** If Local and Account Currency Local, then use Retail number.
492700200529
492800200529     C     BJLCCY        WHENEQ    ODDSMCY
492900200529     C     WRCYCD        ANDEQ     ODDSMCY
493000200529     C     WWACNO        ANDNE     0
493100200529     C                   MOVE      *BLANKS       ODDBNC1
493200200529     C                   MOVEL     WWACNO        ODDBNC1
493300200529     C                   MOVEL     *BLANKS       ODDBNC2
493400200529     C                   MOVEL     *BLANKS       ODDBNC3
493500200529     C                   MOVEL     *BLANKS       ODDBNC4
493600200529     C                   MOVEL     *BLANKS       ODDBNC5
493700200529
493800200529      ** If Currency the same, use GL Account.
493900200529
494000200529     C     WRCYCD        WHENEQ    ODDSMCY
494100200529     C                   MOVE      *BLANKS       ODDBNC1
494200200529     C     BGMBIN        IFNE      'Y'
494300200529     C                   MOVEL     *BLANKS       WRBRCD
494400200529     C                   ENDIF
494500200529     C     WRCNUM        CAT       WRCSB         ODDBNC1
494600200529     C                   MOVEL     *BLANKS       ODDBNC2
494700200529     C                   MOVEL     *BLANKS       ODDBNC3
494800200529     C                   MOVEL     *BLANKS       ODDBNC4
494900200529     C                   MOVEL     *BLANKS       ODDBNC5
495000200529
495100200529      ** Use Customer Number.
495200200529
495300200529     C                   OTHER
495400200529     C                   MOVE      *BLANKS       ODDBNC1
495500200529     C                   MOVEL     WRCNUM        ODDBNC1
495600200529     C                   MOVEL     *BLANKS       ODDBNC2
495700200529     C                   MOVEL     *BLANKS       ODDBNC3
495800200529     C                   MOVEL     *BLANKS       ODDBNC4
495900200529     C                   MOVEL     *BLANKS       ODDBNC5
496000200529
496100200529     C                   ENDSL
496200200529
496300200529     C                   ENDIF
496400200529
496500200529     C                   ENDIF
496600200529
496700200529     C     P59           IFNE      *BLANKS
496800200529
496900200529     C                   MOVEL     P59           DSTRAN
497000200529
497100200529      ** Translate to Nostro and Retail account numbers.
497200200529
497300200529     C     TRCODE        IFNE      *BLANKS
497400200529
497500200529     C                   EXSR      SRTran
497600200529
497700200529     C                   SELECT
497800200529
497900200529      ** If Local and Account Currency Local, then use Retail number.
498000200529
498100200529     C     BJLCCY        WHENEQ    ODDSMCY
498200200529     C     WRCYCD        ANDEQ     ODDSMCY
498300200529     C     WWACNO        ANDNE     0
498400200529     C                   MOVE      *BLANKS       ODDBNC1
498500200529     C                   MOVEL     WWACNO        ODDBNC1
498600200529     C                   MOVEL     *BLANKS       ODDBNC2
498700200529     C                   MOVEL     *BLANKS       ODDBNC3
498800200529     C                   MOVEL     *BLANKS       ODDBNC4
498900200529     C                   MOVEL     *BLANKS       ODDBNC5
499000200529
499100200529      ** If Currency the same, use GL Account.
499200200529
499300200529     C     WRCYCD        WHENEQ    ODDSMCY
499400200529     C                   MOVE      *BLANKS       ODDBNC1
499500200529     C     BGMBIN        IFNE      'Y'
499600200529     C                   MOVEL     *BLANKS       WRBRCD
499700200529     C                   ENDIF
499800200529     C     WRCNUM        CAT       WRCSB         ODDBNC1
499900200529     C                   MOVEL     *BLANKS       ODDBNC2
500000200529     C                   MOVEL     *BLANKS       ODDBNC3
500100200529     C                   MOVEL     *BLANKS       ODDBNC4
500200200529     C                   MOVEL     *BLANKS       ODDBNC5
500300200529
500400200529      ** Use Customer Number.
500500200529
500600200529     C                   OTHER
500700200529     C                   MOVE      *BLANKS       ODDBNC1
500800200529     C                   MOVEL     WRCNUM        ODDBNC1
500900200529     C                   MOVEL     *BLANKS       ODDBNC2
501000200529     C                   MOVEL     *BLANKS       ODDBNC3
501100200529     C                   MOVEL     *BLANKS       ODDBNC4
501200200529     C                   MOVEL     *BLANKS       ODDBNC5
501300200529
501400200529     C                   ENDSL
501500200529
501600200529     C                   ENDIF
501700200529
501800200529     C                   ENDIF
501900200529
502000200529     C                   ENDSR
502100200529
502200200529      *****************************************************************
502300200529      /EJECT
502400200529      *****************************************************************
502500200529      *                                                               *
502600200529      *  SRTran - Translate to Retail and Nostro Code                 *
502700200529      *                                                               *
502800200529      *****************************************************************
502900200529
503000200529     C     SRTran        BEGSR
503100200529
503200200529     C     *LIKE         DEFINE    ACNO          WWACNO
503300200529     C     *LIKE         DEFINE    A7CYCD        WWNCCY
503400200529     C     *LIKE         DEFINE    A7NONB        WWNONB
503500200529
503600200529      ** Clear Retail number and Nostro Code.
503700200529
503800200529     C                   Z-ADD     *ZERO         WWACNO
503900200529     C                   MOVEL     *BLANKS       WWNCCY
504000200529     C                   MOVEL     *BLANKS       WWNONB
504100200529
504200200529      ** If TRCODE has no Currency, exit.
504300200529
504400200529     C                   MOVE      TRCODE        WRCDE2
504500200529     C     WRCYCD        IFEQ      *BLANKS
504600200529     C                   GOTO      ETran
504700200529     C                   ENDIF
504800200529
504900200529      ** Find Account details.
505000200529
505100200529     C                   MOVEL     TRCODE        WACKYDS
505200200529     C     KAccnt        CHAIN     ACCNTABF                           01
505300200529
505400200529     C     *IN01         IFEQ      *OFF
505500200529     C     RECI          ANDEQ     'D'
505600200529     C     ATYP          ANDEQ     'R'
505700200529     C                   Z-ADD     ACNO          WWACNO
505800200529     C                   ENDIF
505900200529
506000200529      ** Move numeric fields to parameter fields.
506100200529
506200200529     C                   MOVEL     CNUM          PCUST
506300200529     C                   MOVEL     ACOD          PACCD
506400200529     C                   MOVEL     ACSQ          PACSN
506500200529
506600200529      ** Find Nostro details.
506700200529
506800200529     C                   CALLB     'AONOSTR0'
506900200529     C                   PARM      *BLANKS       PRTCD
507000200529     C                   PARM      '*KEY   '     POPTN
507100200529     C                   PARM                    PCUST
507200200529     C                   PARM      CCY           PCYCD             3
507300200529     C**********         PARM                    PACCD             4                          CGL029
507400200529     C                   PARM                    PACCD            10                          CGL029
507500200529     C                   PARM                    PACSN             2
507600200529     C                   PARM      *BLANKS       PNONB             2
507700200529     C                   PARM      BRCA          PBRCD             3
507800200529     C                   PARM      *BLANKS       PCSSN            10
507900200529     C                   PARM      *BLANKS       PPNOI             1
508000200529     C     SDNOST        PARM      *BLANKS       DSFDY
508100200529
508200200529     C     PRTCD         IFEQ      *BLANKS
508300200529     C                   MOVEL     A7CYCD        WWNCCY
508400200529     C                   MOVEL     A7NONB        WWNONB
508500200529     C                   ENDIF
508600200529
508700200529     C     ETran         ENDSR
508800200529
508900200529      *****************************************************************
509000200529      /EJECT
509100200529      *****************************************************************
509200200529      *                                                               *
509300200529      *  SRCWVAL - Retrieve FONTIS alphanumeric field identified by   *
509400200529      *            presence of codework /XXXX/                        *
509500200529      *                                                               *
509600200529      *****************************************************************
509700200529      *
509800200529     C     SRCWVAL       BEGSR
509900200529      *
510000200529      ** Inputs
510100200529      ** ------
510200200529      ** Code work lines
510300200529      **                                  WCWLIN
510400200529      ** Code work
510500200529      **                                  WCW
510600200529      ** Code work length
510700200529      **                                  WCWLEN
510800200529      ** Outputs
510900200529      ** -------
511000200529      *
511100200529      ** Reset temporary variables
511200200529     C                   MOVEL     *BLANK        W@CW
511300200529     C                   MOVEL     *BLANK        W@VL
511400200529     C                   MOVEL     *BLANK        WCWVAL          256
511500200529     C                   Z-ADD     0             WLn               2 0
511600200529     C                   Z-ADD     0             WVL               3 0
511700200529     C                   Z-ADD     0             WTagI             3 0
511800200529     C                   Z-ADD     0             WLnCW             3 0
511900200529      *
512000200529      ** Length of tag containing the code works
512100200529     C     ' '           CHECKR    WCWLIN        WLnCW
512200200529      *
512300200529      ** Length of search argument
512400200529     C     ' '           CHECKR    WCW           WLn
512500200529
512600200529     C     WCW:WLn       SCAN      WCWLIN:1      WVL                      81
512700200529     C     *IN81         IFEQ      *ON
512800200529     C                   MOVEA     WCWLIN        W@CW
512900200529     C     WVL           ADD       WLn           WVL
513000200529      *
513100200529      ** We start to extract the value right after the code work
513200200529      ** (so we need to know the length of the code work)
513300200529      ** We stop extracting when
513400200529      ** - another / (and therefore another code work) has been found
513500200529      ** - we reached the length to extract
513600200529      ** - we reached the length of the tag
513700200529     C     WTagI         DOWLT     WCWLEN
513800200529     C     WVL           ANDLE     WLnCW
513900200529     C     W@CW(WVL)     ANDNE     '/'
514000200529     C                   ADD       1             WTagI
514100200529     C                   MOVEL     W@CW(WVL)     W@VL(WTagI)
514200200529     C                   ADD       1             WVL
514300200529     C                   ENDDO
514400200529     C                   MOVEA     W@VL          WCWVAL
514500200529     C                   ENDIF
514600200529      *
514700200529      ** Reset input variables
514800200529     C                   MOVEL     *BLANKS       WCWLIN
514900200529     C                   MOVEL     *BLANKS       WCW
515000200529     C                   Z-ADD     0             WCWLEN            3 0
515100200529
515200200529     C                   ENDSR
515300200529      *
515400200529      *****************************************************************
515500200529      /EJECT
515600200529      *****************************************************************
515700200529      *                                                               *
515800200529      *  SRSndM - Send error message to screen                        *
515900200529      *                                                               *
516000200529      *****************************************************************
516100200529
516200200529     C     SRSndM        BEGSR
516300200529
516400200529      ** Add error message to array passed to screen.
516500200529
516600200529     C**********         Z-ADD     1             Ex                3 0                        BUG515
516700200529     C******BLANK        LOOKUP    FldNameArr(Ex)                         99                  BUG515
516800200529     C**********         MOVEL     '*ANY'        FldNameArr(Ex)                               BUG515
516900200529     C**********         MOVEL     PErrMs        MsgIdArr(Ex)                                 BUG515
517000200529     C                   Z-ADD     1             Idx                                          BUG515
517100200529     C                   EVAL      FldNameArr(Idx) = 'DDSWTN'                                 BUG515
517200200529     C                   EVAL      MsgIdArr(Idx) = PErrMs                                     BUG515
517300200529
517400200529     C                   ENDSR
517500200529      *
517600200529      *****************************************************************
517700200529      /EJECT
517800200529      ******************************************************************
517900200529      *                                                                *
518000200529      *  ValidateTr - Routine to validate the main transaction details *
518100200529      *                                                                *
518200200529      ******************************************************************
518300200529     C     ValidateTr    BEGSR
518400200529
518500200529      ** Move Incoming Payment details retrieved from the Midas
518600200529      ** database file into the update file record.  If no
518700200529      ** record has been retrieved (i.e. in Insert), fields
518800200529      ** contain initial values (zeros, blanks and 'Y's for
518900200529      ** VAT flags).
519000200529
519100200529     C                   If        DDACTN <> 'I'                                              255190
519200200529     C                   MOVEL     IPAYFilFmt    ValidIPAY
519300200529     C                   Endif                                                                255190
519400200529      *                                                                                       255190
519500200529     C                   IF        CFT003 = 'Y' or CFT014 = 'Y'
519600200529     C                             OR CFT009 = 'Y'
519700200529     C                   MOVEL     IPY2FilFmt    ValidIPY2
519800200529     C                   ELSE                                                                BUG7101
519900200529     C                   CLEAR                   ValidIPY2                                   BUG7101
520000200529     C                   ENDIF
520100200529
520200200529      ** Validate Level 1 screen details.
520300200529
520400200529     C                   EXSR      ValidateTr1
520500200529
520600200529      ** Check if errors found in main screen
520700200529     C                   IF        Idx <> *ZERO
520800200529     C                   EVAL      WFirstErr = 'Y'
520900200529     C                   ENDIF
521000200529
521100200529      ** Initialise Level 2 Processing flag for update of Level 2
521200200529      ** details.
521300200529
521400200529     C                   EVAL      WLvl2 = *BLANK
521500200529
521600200529      ** Level 2 screen details exist.
521700200529      ** Or 'level joiner' = 'Y'                                                              243991
521800200529
521900200529     C                   IF        TranInIPY2 <> *BLANKS OR
522000200529     C                             TranInIPY3 <> *BLANKS OR
522100200529     C                             TranInIPY4 <> *BLANKS OR
522200200529     C                             TranInIP4A <> *BLANKS OR
522300200529     C                             TranInIPY5 <> *BLANKS OR
522400200529     C******                       TranInIPY6 <> *BLANKS                                      243991
522500200529     C                             TranInIPY6 <> *BLANKS OR                                   243991
522600200529     C                             TranInIP6A <> *BLANKS OR                                   CER030
522700200529     C                             BTLVJN     =  'Y'                                          243991
522800200529
522900200529      ** Set Level 2 Processing flag for update of Level 2 details.
523000200529
523100200529     C                   EVAL      WLvl2 = 'Y'
523200200529
523300200529      ** If Action is Insert, or Action is Amend and Level 2
523400200529      ** details have not been entered, default Transfer
523500200529      ** Commission Tariff based on Charges Branch.
523600200529
523700200529     C                   IF        (DDACTN = 'I' OR
523800200529     C                             DDACTN = 'A' AND
523900200529     C                             INLVL2 <> 'Y') AND
524000200529     C                             DDTRCT = *BLANKS
524100200529
524200200529     C                   EVAL      PPYTY = 'IN'                                             MD034973
524300200529     C                   EVAL      PCNUM = DDBNC1                                           MD034973
524400200529     C                   EVAL      PPYST = DDPYST                                           MD034973
524500200529     C     PPYKEY        CHAIN     PYCHGL1                            01                    MD034973
524600200529     C   01              EVAL      PPYST = *BLANKS                                          MD034973
524700200529     C   01              EVAL      PPYTY = *BLANKS                                          MD034973
524800200529     C   01PPYKEY        CHAIN     PYCHGL1                            01                    MD034973
524900200529     C   01              EVAL      PPYTY = 'IN'                                             MD034973
525000200529     C   01              EVAL      PCNUM = *BLANKS                                          MD034973
525100200529     C   01              EVAL      PPYST = DDPYST                                           MD034973
525200200529     C   01PPYKEY        CHAIN     PYCHGL1                            01                    MD034973
525300200529     C   01              EVAL      PPYST = *BLANKS                                          MD034973
525400200529     C   01PPYKEY        CHAIN     PYCHGL1                            01                    MD034973
525500200529     C*****PPYBR         CHAIN     PYCHGDB                            01                    MD034973
525600200529     C   01PPYBR         CHAIN     PYCHGL1                            01                    MD034973
525700200529     C                   IF        NOT(*IN01)
525800200529     C                   EVAL      DDTRCT = PYDFTRCT
525900200529     C                   MOVEL     TranInIPY3    CurTrIPY3
526000200529     C                   ENDIF
526100200529
526200200529     C                   ENDIF
526300200529
526400200529      ** Validate Level 2 screen 1 details.
526500200529
526600200529     C                   EXSR      ValidateTr2
526700200529
526800200529      ** Validate Level 2 screen 2 details.
526900200529
527000200529     C                   EXSR      ValidateTr3
527100200529
527200200529      ** Perform the following only if no errors found in
527300200529      ** screen 1 details so as to avoid database errors
527400200529      ** in computations
527500200529
527600200529     C                   IF        WFirstErr <> 'Y'
527700200529
527800200529      ** Default Charges and Commission details on Level 2
527900200529      ** screen 3.
528000200529
528100200529     C                   IF        CFT009 = 'N'
528200200529     C                   EXSR      ValCcyVat
528300200529     C                   EXSR      DefaultChrg
528400200529     C                   ENDIF
528500200529
528600200529      ** Validate Level 2 screen 3 details.
528700200529
528800200529     C                   EXSR      ValidateTr4
528900200529     C**********         ENDIF                                                               BUG6864
529000200529
529100200529      ** Validate Margin Infomation sobroutine.
529200200529
529300200529     C                   EXSR      ValidateMg
529400200529     C                   ENDIF                                                               BUG6864
529500200529
529600200529     C                   ELSE
529700200529
529800200529      ** Compute Charges and Commissions, and Total VAT Amounts
529900200529      ** based on Level 1 details if there are no errors
530000200529
530100200529     C                   IF        WFirstErr <> 'Y' AND
530200200529     C                             CFT009 = 'N'
530300200529     C                   EXSR      ValCcyVat
530400200529     C                   ENDIF
530500200529
530600200529     C                   ENDIF
530700200529                                                                                              CER001
530800200529     C                   IF        ULX043 = 'Y'                                               CER001
530900200529                                                                                              CER001
531000200529     C                   EVAL       #1FLD1 = *ZERO                                            CER001
531100200529     C                   EVAL       PREF1  = IPPREF                                           CER001
531200200529     C                   EVAL       #1FOTR = APFOTranId                                       CER001
531300200529     C                   EVAL       #1TMST = IPTMST                                           CER001
531400200529     C                   EVAL       #1ACBT = IPACBT                                           CER001
531500200529     C                   EVAL       #1ACBK = IPACBK                                           CER001
531600200529     C                   EVAL       #1BNC1 = IPBNC1                                           CER001
531700200529     C                   EVAL       #1PCCY = IPPCCY                                           CER001
531800200529     C                   EVAL       #1BNCT = IPBNCT                                           CER001
531900200529     C                   EVAL       #1SMAM = IPSMAM                                           CER001
532000200529     C                   EVAL       #1RCRT = IPRCRT                                           CER001
532100200529     C                   EVAL       #1RCCO = IPRCCO                                           CER001
532200200529     C                   EVAL       #1SNTP = IPSNTP                                           CER001
532300200529     C                   EVAL       #1SND1 = IPSND1                                           CER001
532400200529                                                                                              CER001
532500200529     C                   CALLB     'FTIPAY6VL'                                                CER001
532600200529     C                   PARM                    PActn                                        CER001
532700200529     C                   PARM                    PDATALUX                                     CER001
532800200529     C                   PARM                    RegData                                      CER001
532900200529     C                   PARM                    OKExtFlg                                     CER001
533000200529     C                   PARM                    FldNameArr                                   CER001
533100200529     C                   PARM                    MsgIDArr                                     CER001
533200200529     C                   PARM                    MsgDtaArr                                    CER001
533300200529     C                   PARM                    Idx                                          CER001
533400200529     C                   PARM                    WFldNamArr                                   CER001
533500200529     C                   PARM                    WMsgIDArr                                    CER001
533600200529     C                   PARM                    WMsgDtaArr                                   CER001
533700200529     C                   PARM                    WIdx                                         CER001
533800200529     C                   PARM                    IPAYValPmt                                   CER001
533900200529     C                   PARM                    WWCUTY                                       CER001
534000200529     C                   PARM                    @CUST                                        CER001
534100200529     C                   PARM                    IPAYExFilFmt                                 CER001
534200200529                                                                                              CER001
534300200529     C                   ENDIF                                                                CER001
534400200529     C                   IF        CSW209 = 'Y'                                               CSW209
534500200529     C                   IF        TranInIPY7 <> *BLANKS OR                                   CSW209
534600200529     C                             TranInIPY8 <> *BLANKS                                      CSW209
534700200529     C                   EXSR      ValidateTr7                                                CSW209
534800200529     C                   EXSR      ValidateTr8                                                CSW209
534900200529     C                   ENDIF                                                                CSW209
535000200529     C                   ENDIF                                                                CSW209
535100200529
535200200529     C     EValidTr      ENDSR
535300200529      *****************************************************************
535400200529      /EJECT
535500200529      *****************************************************************
535600200529      *                                                               *
535700200529      *  ValidateTr1 - Validate Level 1 screen details                *
535800200529      *                                                               *
535900200529      *****************************************************************
536000200529
536100200529     C     ValidateTr1   BEGSR
536200200529
536300200529     C                   CALLB     'FTIPAYIVL'
536400200529      *                             =========
536500200529      ** INPUT
536600200529      ** =====
536700200529
536800200529     C                   PARM      '*FRONT'      PMode
536900200529
537000200529      ** Response Mode (from caller: A=Asynchronous, S=Synchronous)
537100200529     C                   PARM                    PResponse
537200200529
537300200529      ** SWIFT Reference
537400200529     C                   PARM                    DDSWTN
537500200529
537600200529      ** Sequence Number
537700200529     C                   PARM                    DDSEQNO
537800200529
537900200529      ** Booking Branch
538000200529     C                   PARM                    DDBRCA
538100200529
538200200529      ** Action Code
538300200529     C                   PARM                    DDACTN
538400200529
538500200529      ** OK Payment Reference
538600200529     C                   PARM                    OKPREF
538700200529
538800200529      ** Linked Program
538900200529     C                   PARM                    PLinkPgm
539000200529
539100200529      ** Incoming Payments retrieved from file - file format
539200200529     C                   PARM                    IPAYFilFmt
539300200529
539400200529      ** Incoming Payments extra data
539500200529     C                   PARM                    ExtData
539600200529     C/COPY WNCPYSRC,FTH00363
539700200529
539800200529      ** STANDING DATA
539900200529      ** =============
540000200529
540100200529      ** SDBANK - Single Branch Code
540200200529     C                   PARM                    BJSBRC
540300200529
540400200529      ** SDMMOD - Multibranch Indicator
540500200529     C                   PARM                    BGMBIN
540600200529
540700200529      ** ZMUSER - Default Branch
540800200529     C                   PARM                    PDBRN
540900200529
541000200529      ** OUTPUT
541100200529      ** ======
541200200529
541300200529      ** Error fields/message IDs/message data (arrays) from/to caller
541400200529     C                   PARM                    FldNameArr
541500200529     C                   PARM                    MsgIdArr
541600200529     C                   PARM                    MsgDtaArr
541700200529
541800200529      ** Array index (3P0) from/to caller
541900200529     C                   PARM                    Idx
542000200529
542100200529      ** Warning flds/message IDs/message data (arrays) from/to caller
542200200529     C                   PARM                    WFldNamArr
542300200529     C                   PARM                    WMsgIdArr
542400200529     C                   PARM                    WMsgDtaArr
542500200529
542600200529      ** Array index (3P0) from/to caller
542700200529     C                   PARM                    WIdx
542800200529
542900200529      ** OK Action Code
543000200529     C                   PARM                    OKACTN
543100200529
543200200529      ** OK SWIFT Reference
543300200529     C                   PARM                    OKSWTN
543400200529
543500200529      ** OK Sequence No.
543600200529     C                   PARM                    OKSEQNO
543700200529
543800200529      ** OK Booking Branch
543900200529     C                   PARM                    OKBRCA
544000200529
544100200529      ** Incoming Payments for file update - file format
544200200529     C                   PARM                    ValidIPAY
544300200529
544400200529     C                   Z-add     BTPCRD        WBTPCRD
544500200529
544600200529     C                   CALLB     'FTIPAY1VL'
544700200529      *                             =========
544800200529      ** INPUT
544900200529      ** =====
545000200529
545100200529     C                   PARM      '*FRONT'      PMode
545200200529
545300200529      ** Response Mode (from caller: A=Asynchronous, S=Synchronous)
545400200529     C                   PARM                    PResponse
545500200529
545600200529      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
545700200529      ** - screen format
545800200529
545900200529     C                   PARM                    TranInIPY1
546000200529     C                   PARM                    TranInIP1A
546100200529
546200200529      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction
546300200529      ** - screen format
546400200529
546500200529     C                   PARM                    TranInIPY5
546600200529
546700200529      ** Third Reimbursement Institution (previous)
546800200529     C                   PARM      *BLANKS       PPrvTRI
546900200529
547000200529      ** Previous Instructed Amount
547100200529     C                   PARM      *BLANKS       PPrvNDAM
547200200529
547300200529      ** Base Currency No. of Decimal Places
547400200529     C                   PARM                    PBCDP
547500200529
547600200529      ** Payment Type
547700200529     C                   PARM                    PPYTP
547800200529
547900200529      ** Incoming Payments Lvl 1 Scrn details retrieved from file
548000200529      ** - screen format
548100200529     C                   PARM                    CurTrIPY1
548200200529
548300200529      ** Incoming Payments extra data
548400200529     C                   PARM                    ExtData
548500200529
548600200529      ** STANDING DATA
548700200529      ** =============
548800200529
548900200529      ** SDBANK - Base Currency Code
549000200529     C                   PARM                    BJCYCD
549100200529
549200200529      ** SDBANK - Midas Run Date
549300200529     C                   PARM                    PProcDte
549400200529
549500200529      ** SDBANK - Local Currency Code
549600200529     C                   PARM                    BJLCCY
549700200529
549800200529      ** SDBANK - Location Code
549900200529     C                   PARM                    BJSLCD
550000200529
550100200529      ** SDBANK - Single Branch Code
550200200529     C                   PARM                    BJSBRC
550300200529
550400200529      ** SDBANK - Back Value Period in Days
550500200529     C                   PARM                    BJBVPD
550600200529
550700200529      ** SDBANK - Date Format Indicator
550800200529     C                   PARM                    BJDFIN
550900200529
551000200529      ** SDGELR - Currency Code for Euro
551100200529     C                   PARM                    BKEURO
551200200529
551300200529      ** SDGELR - Profit Centre Default Used
551400200529     C                   PARM                    BKPCDU
551500200529
551600200529      ** SDGELR - Profit Centre Used
551700200529     C                   PARM                    BKPRCU
551800200529
551900200529      ** SDGELR - Originating Branch Used
552000200529     C                   PARM                    BKOBRU
552100200529
552200200529      ** SDGELR - Originating Branch/User Vald Req.
552300200529     C                   PARM                    BKOBUV
552400200529
552500200529      ** SDMMOD - Retail Banking
552600200529     C                   PARM                    BGRTBN
552700200529
552800200529      ** SDMMOD - Multibranch Indicator
552900200529     C                   PARM                    BGMBIN
553000200529
553100200529      ** SDMMOD - Analytical Accounting
553200200529     C                   PARM                    BGN0ST
553300200529
553400200529      ** SDMMOD - Dealing Foreign Exchange
553500200529     C                   PARM                    BGDLFX
553600200529
553700200529      ** SDMMOD - Dealing Money Market
553800200529     C                   PARM                    BGDLMM
553900200529
554000200529      ** SDRETL - Retail A/c Number Required?
554100200529     C                   PARM                    BMRANR
554200200529
554300200529      ** SDFTFR - Level Join indicator
554400200529     C                   PARM                    BTLVJN
554500200529
554600200529      ** SDFTFR - Percent Rate Discrepancy
554700200529     C                   PARM                    WBTPCRD
554800200529
554900200529      ** SDMMOD - Interest on Accrual
555000200529     C                   PARM                    BGIOAC
555100200529
555200200529      ** ZMUSER - Department Code
555300200529     C                   PARM                    PDPPT
555400200529
555500200529      ** ZMUSER - User Id
555600200529     C                   PARM                    PUSRID
555700200529
555800200529      ** SDFTFR - Charges Currency
555900200529     C                   PARM                    BTCHCY
556000200529
556100200529      ** SDFTFR - Fixed Charge Currency
556200200529     C                   PARM                    FCHCCY
556300200529
556400200529      ** SDFTFR - Charges calculated in transaction ccy
556500200529     C                   PARM                    CHTRCY
556600200529
556700200529      ** VAT Rate
556800200529     C                   PARM                    PVATR
556900200529
557000200529      ** SWITCHABLE FEATURES
557100200529      ** ===================
557200200529
557300200529      ** EMU FT Settlement Currency Conversion
557400200529     C                   PARM                    CEU006
557500200529
557600200529      ** Electronic Banking Interface IATs and TPPs
557700200529     C                   PARM                    CGL009
557800200529
557900200529      ** IBAN numbers
558000200529     C                   PARM                    CFT004
558100200529
558200200529      ** STP Phase 2 MT103
558300200529     C                   PARM                    CFT014
558400200529
558500200529      ** Fees & Charges
558600200529     C                   PARM                    CFT009
558700200529     C                   PARM                    CFT010
558800200529
558900200529      ** BLI FT Enhancements Feature
559000200529     C                   PARM                    S01494
559100200529                                                                                              CGL014
559200200529      ** Collaterals Processing                                                               CGL014
559300200529                                                                                              CGL014
559400200529     C                   PARM                    CGL014                                       CGL014
559500200529
559600200529      ** OUTPUT
559700200529      ** ======
559800200529
559900200529      ** Error fields/message IDs/message data (arrays) from/to caller
560000200529     C                   PARM                    FldNameArr
560100200529     C                   PARM                    MsgIdArr
560200200529     C                   PARM                    MsgDtaArr
560300200529
560400200529      ** Array index (3P0) from/to caller
560500200529     C                   PARM                    Idx
560600200529
560700200529      ** Warning flds/message IDs/message data (arrays) from/to caller
560800200529     C                   PARM                    WFldNamArr
560900200529     C                   PARM                    WMsgIdArr
561000200529     C                   PARM                    WMsgDtaArr
561100200529
561200200529      ** Array index (3P0) from/to caller
561300200529     C                   PARM                    WIdx
561400200529
561500200529      ** Incoming Payments Lvl 1 Scrn error indicators
561600200529     C                   PARM                    OKTrIPY1
561700200529
561800200529      ** Incoming Payments for file update - file format
561900200529     C                   PARM                    ValidIPAY
562000200529
562100200529      ** Incoming Payments (additional details) for file update - file format
562200200529     C                   PARM                    ValidIPY2
562300200529
562400200529      ** Charges Branch
562500200529     C                   PARM                    PPYBR
562600200529
562700200529      ** Account with Bank's full account
562800200529     C                   PARM                    PACBDS
562900200529
563000200529      ** Sender's full account
563100200529     C                   PARM                    PSNDDS
563200200529
563300200529      ** Receiver Correspondence's full account
563400200529     C                   PARM                    PRCCDS
563500200529      *                                                                                     BUG15006
563600200529      ** Third Reimbursemnt Party  full account                                             BUG15006
563700200529     C                   PARM                    PTRBDS           24                        BUG15006
563800200529
563900200529      ** Beneficiary's full account
564000200529     C                   PARM                    PBNCDS
564100200529
564200200529      ** IBANs full account
564300200529     C                   PARM                    PIBANAcc
564400200529
564500200529      ** Settlement In Currency Indicator
564600200529     C                   PARM                    PSetInCy
564700200529
564800200529      ** Settlement EMU Transaction Period Start Date
564900200529     C                   PARM                    PSetTPSD
565000200529
565100200529      ** Payment In Currency Indicator
565200200529     C                   PARM                    PPayInCy
565300200529
565400200529      ** Payment EMU Transaction Period Start Date
565500200529     C                   PARM                    PPayTPSD
565600200529
565700200529      ** DS for Default Charge Amounts
565800200529     C                   PARM                    PCharges
565900200529
566000200529      ** Input Charge Currency
566100200529     C                   PARM                    PICCY
566200200529
566300200529      ** Output Charge Currency
566400200529     C                   PARM                    POCCY
566500200529
566600200529      ** Input Charge Currency No. of Decimal Places
566700200529     C                   PARM                    PINBDP
566800200529
566900200529      ** Output Charge Currency No. of Decimal Places
567000200529     C                   PARM                    PONBDP
567100200529
567200200529      ** Saved default charges
567300200529     C                   PARM                    DefValid
567400200529     C                   PARM                    DefValidX
567500200529     C                   PARM                    BENEDrBlck        1                        MD025111
567600200529     C                   PARM                    BENEDrRefd        1                       MD047369A
567700200529      *                                                                                       230309
567800200529      *  If DDBRCA was not *BLANKS prior to CALLB 'FTIPAY1VL then                             230309
567900200529      *  ignore the value held in IPBRCA, set in *MODULE FTVISNDR, and                        230309
568000200529      *  set IPBRCA to the User-entered value held in DDBRCA                                  230309
568100200529     C     DDBRCA        IFNE      *BLANKS                                                    230309
568200200529     C                   MOVEL     DDBRCA        IPBRCA                                       230309
568300200529     C                   ENDIF                                                                230309
568400200529      *                                                                                       230309
568500200529     C/COPY WNCPYSRC,FTIPAYV023
568600200529
568700200529     C                   ENDSR
568800200529      *
568900200529      *****************************************************************
569000200529      /EJECT
569100200529      *****************************************************************
569200200529      *                                                               *
569300200529      *  ValCcyVat - Compute Charges and Commissions, and Total VAT   *
569400200529      *              Amounts based on Level 1 details                 *
569500200529      *                                                               *
569600200529      *****************************************************************
569700200529
569800200529     C     ValCcyVat     BEGSR
569900200529
570000200529     C                   CALLB     'FTIPAY1CH'
570100200529      *                             =========
570200200529      ** INPUT
570300200529      ** =====
570400200529
570500200529      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
570600200529      ** - screen format
570700200529     C                   PARM                    TranInIPY1
570800200529
570900200529      ** Incoming Payments retrieved from file - file format
571000200529     C                   PARM                    IPAYFilFmt
571100200529
571200200529      ** Incoming Payments (extension) retrieved from file - file fmt
571300200529     C                   PARM                    IPY2FilFmt
571400200529
571500200529      ** Incoming Payments (extension) for file update - file format
571600200529     C                   PARM                    ValidIPY2
571700200529
571800200529      ** Charges Branch
571900200529     C                   PARM                    PPYBR
572000200529
572100200529      ** Base Currency No. of Decimal Places
572200200529     C                   PARM                    PBCDP
572300200529
572400200529      ** Local Currency No. of Decimal Places
572500200529     C                   PARM                    PLCDP
572600200529
572700200529      ** Local Currency Multiply/Divide Indicator
572800200529     C                   PARM                    PLMDIN
572900200529
573000200529      ** Local Currency Spot Rate
573100200529     C                   PARM                    PLSPOT
573200200529
573300200529      ** Entry Point
573400200529     C                   PARM                    PParmLevel
573500200529
573600200529      ** STANDING DATA
573700200529      ** =============
573800200529
573900200529      ** SDBANK - Base Currency Code
574000200529     C                   PARM                    BJCYCD
574100200529
574200200529      ** SDBANK - Local Currency Code
574300200529     C                   PARM                    BJLCCY
574400200529
574500200529      ** SDFTFR - Charges Currency
574600200529     C                   PARM                    BTCHCY
574700200529
574800200529      ** VAT Rate
574900200529     C                   PARM                    PVATR
575000200529
575100200529      ** SWITCHABLE FEATURES
575200200529      ** ===================
575300200529
575400200529      ** BLI FT Enhancements Feature
575500200529     C                   PARM                    S01494
575600200529
575700200529      ** BLI VAT Processing Feature
575800200529     C                   PARM                    S01499
575900200529
576000200529      ** BLI Payment Charges Enhancements
576100200529     C                   PARM                    S01506
576200200529
576300200529      ** BLI Extended Payment Charges
576400200529     C                   PARM                    S01508
576500200529
576600200529      ** FT Batch Authorization and Credit Advices
576700200529     C                   PARM                    CFT004
576800200529
576900200529      ** STP Phase 2 MT103
577000200529     C                   PARM                    CFT014
577100200529
577200200529      ** OUTPUT
577300200529      ** ======
577400200529
577500200529      ** Incoming Payments for file update - file format
577600200529     C                   PARM                    ValidIPAY
577700200529
577800200529     C                   ENDSR
577900200529      *****************************************************************
578000200529      /EJECT
578100200529      *****************************************************************
578200200529      *                                                               *
578300200529      *  ValidateTr2 - Validate Level 2 screen 1 details              *
578400200529      *                                                               *
578500200529      *****************************************************************
578600200529
578700200529     C     ValidateTr2   BEGSR
578800200529
578900200529      *                                                                                       255190
579000200529      ** Move saved PMTPY when IPINMTPY is blank (not selected from ME1100)                   255190
579100200529      ** Or error occurred from previous try (re-enter)                                       255190
579200200529      *                                                                                       255190
579300200529     C     IPINMTPY      IFEQ      ' '                                                        255190
579400200529     C                   MOVE      PMTPY         IPINMTPY                                     255190
579500200529     C                   ENDIF                                                                255190
579600200529      *                                                                                       255190
579700200529     C                   CALLB     'FTIPAY2VL'
579800200529      *                             =========
579900200529      ** INPUT
580000200529      ** =====
580100200529
580200200529     C                   PARM      '*FRONT'      PMode
580300200529
580400200529      ** Response Mode (from caller: A=Asynchronous, S=Synchronous)
580500200529     C                   PARM                    PResponse
580600200529
580700200529      ** Incoming Payments Lvl 1 Scrn format definition file 2
580800200529     C                   PARM                    TranInIP1A
580900200529
581000200529      ** Incoming Payments Lvl 2 Scrn 1/1 details from incoming transaction
581100200529      ** - screen format
581200200529     C                   PARM                    TranInIPY2
581300200529
581400200529      ** Incoming Payments Lvl 2 Scrn 1/2 details from incoming transaction
581500200529      ** - screen format
581600200529     C                   PARM                    TranInIPY3
581700200529
581800200529      ** Incoming Payments extra data
581900200529     C                   PARM                    ExtData
582000200529
582100200529      ** Charges Branch
582200200529     C                   PARM                    PPYBR
582300200529
582400200529      ** STANDING DATA
582500200529      ** =============
582600200529
582700200529      ** SDBANK - Base Currency Code
582800200529     C                   PARM                    BJCYCD
582900200529
583000200529      ** SDBANK - Midas Run Date
583100200529     C                   PARM                    PProcDte
583200200529
583300200529      ** SDBANK - Back Value Period in Days
583400200529     C                   PARM                    BJBVPD
583500200529
583600200529      ** SDBANK - Single Branch Code
583700200529     C                   PARM                    BJSBRC
583800200529
583900200529      ** SDMMOD - Multibranch Indicator
584000200529     C                   PARM                    BGMBIN
584100200529
584200200529      ** SDMMOD - Retail Banking
584300200529     C                   PARM                    BGRTBN
584400200529
584500200529      ** SDRETL - Retail A/c Number Required?
584600200529     C                   PARM                    BMRANR
584700200529
584800200529      ** MT103 Messages Generation for FT
584900200529     C                   PARM                    CFT014
585000200529      *                                                                                     BUG15006
585100200529      ** Debit Account                                                                      BUG15006
585200200529     C                   PARM                    PDBACT           24                        BUG15006
585300200529      *                                                                                     BUG15006
585400200529      ** Credit Account                                                                     BUG15006
585500200529     C                   PARM                    PCDACT           24                        BUG15006
585600200529      *                                                                                     BUG15006
585700200529      ** Network                                                                            BUG15006
585800200529     C                   PARM                    PNWRK             6                        BUG15006
585900200529
586000200529      ** OUTPUT
586100200529      ** ======
586200200529
586300200529      ** Error fields/message IDs/message data (arrays) from/to caller
586400200529     C                   PARM                    FldNameArr
586500200529     C                   PARM                    MsgIdArr
586600200529     C                   PARM                    MsgDtaArr
586700200529
586800200529      ** Array index (3P0) from/to caller
586900200529     C                   PARM                    Idx
587000200529
587100200529      ** Warning flds/message IDs/message data (arrays) from/to caller
587200200529     C                   PARM                    WFldNamArr
587300200529     C                   PARM                    WMsgIdArr
587400200529     C                   PARM                    WMsgDtaArr
587500200529
587600200529      ** Array index (3P0) from/to caller
587700200529     C                   PARM                    WIdx
587800200529
587900200529      ** Incoming Payments Lvl 2 Scrn 1 error indicators
588000200529     C                   PARM                    OKTrIPY2
588100200529
588200200529      ** Incoming Payments for file update - file format
588300200529     C                   PARM                    ValidIPAY
588400200529
588500200529     C                   ENDSR
588600200529      *****************************************************************
588700200529      /EJECT
588800200529      *****************************************************************
588900200529      *                                                               *
589000200529      *  DefaultChrg - Defaulting of Charges and Commission details   *
589100200529      *                                                               *
589200200529      *****************************************************************
589300200529      *
589400200529     C     DefaultChrg   BEGSR
589500200529      *
589600200529     C                   CALLB     'FTIPAY3DT'
589700200529      *                             =========
589800200529      ** INPUT
589900200529      ** =====
590000200529
590100200529      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
590200200529      ** - screen format
590300200529     C                   PARM                    TranInIPY1
590400200529
590500200529      ** Incoming Payments Lvl 2 Scrn 3 details from incoming transaction
590600200529      ** - screen format
590700200529     C                   PARM                    TranInIPY5
590800200529
590900200529      ** Incoming Payments (additional info) for file update
591000200529      ** - file format
591100200529     C                   PARM                    ValidIPY2
591200200529
591300200529      ** Incoming Payments retrieved from file - file format
591400200529     C                   PARM                    IPAYFilFmt
591500200529
591600200529      ** Payment Type
591700200529     C                   PARM                    PPYTP
591800200529
591900200529      ** Charges Branch
592000200529     C                   PARM                    PPYBR
592100200529
592200200529     C                   PARM      '*FRONT'      PMode
592300200529
592400200529      ** Previous values of 'Charges to the Debit of a/c'
592500200529
592600200529     C                   PARM                    PPrvCDRT
592700200529     C                   PARM                    PPrvCDRO
592800200529     C                   PARM                    PPrvCDBR
592900200529     C                   PARM                    PPrvCDRC                                     CFT120
593000200529
593100200529      ** Recalcution flag.
593200200529
593300200529     C                   PARM                    PReCalc
593400200529
593500200529      ** STANDING DATA
593600200529      ** =============
593700200529
593800200529      ** SDBANK - Base Currency Code
593900200529     C                   PARM                    BJCYCD
594000200529
594100200529      ** SDBANK - Local Currency Code
594200200529     C                   PARM                    BJLCCY
594300200529
594400200529      ** SDFTFR - Charges Currency
594500200529     C                   PARM                    BTCHCY
594600200529
594700200529      ** VAT Default Flag
594800200529     C                   PARM                    PVATT
594900200529
595000200529      ** VAT Rate
595100200529     C                   PARM                    PVATR
595200200529
595300200529      ** SWITCHABLE FEATURES
595400200529      ** ===================
595500200529
595600200529      ** BLI FT Enhancements Feature
595700200529     C                   PARM                    S01494
595800200529
595900200529      ** BLI VAT Processing Feature
596000200529     C                   PARM                    S01499
596100200529
596200200529      ** BLI Payment Charges Enhancements
596300200529     C                   PARM                    S01506
596400200529
596500200529      ** BLI Extended Payment Charges
596600200529     C                   PARM                    S01508
596700200529
596800200529      ** FT Batch Authorization and Credit Advices
596900200529     C                   PARM                    CFT004
597000200529
597100200529      ** MT103 Messages Generation for FT
597200200529     C                   PARM                    CFT014
597300200529      *                                                                                       CFT120
597400200529      ** FT IN/OP - Charges on DR of Account Ccy                                              CFT120
597500200529      *                                                                                       CFT120
597600200529     C                   PARM                    CFT120                                       CFT120
597700200529
597800200529      ** OUTPUT
597900200529      ** ======
598000200529
598100200529      ** Input Charge Currency
598200200529     C                   PARM                    PICCY
598300200529
598400200529      ** Input Charge Currency In Currency Flag
598500200529     C                   PARM                    PIINCY
598600200529
598700200529      ** Input Charge Currency No. of Decimal Places
598800200529     C                   PARM                    PINBDP
598900200529
599000200529      ** Input Charge Currency EMU Transmission Period Start Date
599100200529     C                   PARM                    PITPSD
599200200529
599300200529      ** Output Charge Currency
599400200529     C                   PARM                    POCCY
599500200529
599600200529      ** Output Charge Currency In Currency Flag
599700200529     C                   PARM                    POINCY
599800200529
599900200529      ** Output Charge Currency No. of Decimal Places
600000200529     C                   PARM                    PONBDP
600100200529
600200200529      ** DS for Default Charge Amounts
600300200529     C                   PARM                    PCharges
600400200529
600500200529      ** DS for Default Charge Currencies
600600200529     C                   PARM                    PChgCcy
600700200529
600800200529      ** Incoming Payments for file update - file format
600900200529     C                   PARM                    ValidIPAY
601000200529
601100200529     C                   ENDSR
601200200529      *
601300200529      *****************************************************************
601400200529      /EJECT
601500200529      *****************************************************************
601600200529      *                                                               *
601700200529      *  ValidateTr3 - Validate Level 2 screen 2 details              *
601800200529      *                                                               *
601900200529      *****************************************************************
602000200529
602100200529     C     ValidateTr3   BEGSR
602200200529
602300200529     C                   CALLB     'FTIPAY3VL'
602400200529      *                             =========
602500200529      ** INPUT
602600200529      ** =====
602700200529
602800200529     C                   PARM      '*FRONT'      PMode
602900200529
603000200529      ** Response Mode (from caller: A=Asynchronous, S=Synchronous)
603100200529     C                   PARM                    PResponse
603200200529
603300200529      ** Incoming Payments Lvl 2 Scrn 2 details from incoming transaction
603400200529      ** - screen format
603500200529     C                   PARM                    TranInIPY4
603600200529
603700200529      ** Incoming Payments Lvl 2 Scrn 2 file 2 from incoming transaction
603800200529      ** - screen format
603900200529     C                   PARM                    TranInIP4A
604000200529
604100200529      ** Settlement In Currency Indicator
604200200529     C                   PARM                    PSetInCy
604300200529
604400200529      ** Settlement EMU Transaction Period Start Date
604500200529     C                   PARM                    PSetTPSD
604600200529
604700200529      ** Payment In Currency Indicator
604800200529     C                   PARM                    PPayInCy
604900200529
605000200529      ** Payment EMU Transaction Period Start Date
605100200529     C                   PARM                    PPayTPSD
605200200529
605300200529      ** Input Charge Currency
605400200529     C                   PARM                    PICCY
605500200529
605600200529      ** Input Charge Currency No. of Decimal Places
605700200529     C                   PARM                    PINBDP
605800200529
605900200529      ** Output Charge Currency
606000200529     C                   PARM                    POCCY
606100200529
606200200529      ** Output Charge Currency No. of Decimal Places
606300200529     C                   PARM                    PONBDP
606400200529
606500200529      ** Incoming Payments extra data
606600200529     C                   PARM                    ExtData
606700200529
606800200529      ** Charges Branch
606900200529     C                   PARM                    PPYBR
607000200529
607100200529      ** STANDING DATA
607200200529      ** =============
607300200529
607400200529      ** SDGELR - Currency Code for Euro
607500200529     C                   PARM                    BKEURO
607600200529
607700200529      ** SDMMOD - Analytical Accounting
607800200529     C                   PARM                    BGN0ST
607900200529
608000200529      ** VAT Default Flag
608100200529     C                   PARM                    PVATT
608200200529
608300200529      ** VAT Rate
608400200529     C                   PARM                    PVATR
608500200529
608600200529      ** SWITCHABLE FEATURES
608700200529      ** ===================
608800200529
608900200529      ** EMU FT Settlement Currency Conversion
609000200529     C                   PARM                    CEU006
609100200529
609200200529      ** BLI FT Enhancements Feature
609300200529     C                   PARM                    S01494
609400200529
609500200529      ** BLI VAT Processing Feature
609600200529     C                   PARM                    S01499
609700200529
609800200529      ** MT103 Messages Generation for FT
609900200529     C                   PARM                    CFT014
610000200529
610100200529      ** Fees & Charges
610200200529     C                   PARM                    CFT009
610300200529
610400200529      ** OUTPUT
610500200529      ** ======
610600200529
610700200529      ** Error fields/message IDs/message data (arrays) from/to caller
610800200529     C                   PARM                    FldNameArr
610900200529     C                   PARM                    MsgIdArr
611000200529     C                   PARM                    MsgDtaArr
611100200529
611200200529      ** Array index (3P0) from/to caller
611300200529     C                   PARM                    Idx
611400200529
611500200529      ** Warning flds/message IDs/message data (arrays) from/to caller
611600200529     C                   PARM                    WFldNamArr
611700200529     C                   PARM                    WMsgIdArr
611800200529     C                   PARM                    WMsgDtaArr
611900200529
612000200529      ** Array index (3P0) from/to caller
612100200529     C                   PARM                    WIdx
612200200529
612300200529      ** Incoming Payments Lvl 2 Scrn 2 error indicators
612400200529     C                   PARM                    OKTrIPY3
612500200529
612600200529      ** Incoming Payments for file update - file format
612700200529     C                   PARM                    ValidIPAY
612800200529
612900200529      ** Incoming Payments (additional details) for file update
613000200529     C                   PARM                    ValidIPY2
613100200529
613200200529      ***DS*for*Default*Charge*Amounts*********************************                       222373
613300200529     C*****              PARM                    PCharges                                     222373
613400200529      *****                                                                                   222373
613500200529     C                   ENDSR
613600200529      *****************************************************************
613700200529      /EJECT
613800200529      *****************************************************************
613900200529      *                                                               *
614000200529      *  ValidateTr4 - Validate Level 2 screen 3 details              *
614100200529      *                                                               *
614200200529      *****************************************************************
614300200529
614400200529     C     ValidateTr4   BEGSR
614500200529      *                                                                                       CFT120
614600200529      ** Check if new value entered for Charges to the debit of                               CFT120
614700200529      *                                                                                       CFT120
614800200529     C                   IF        CFT120 = 'Y'                                               CFT120
614900200529     C                   IF        PrvDDCDRO <> DDCDRO                                        CFT120
615000200529     C                             OR  PrvDDCDRC <> DDCDRC                                    CFT120
615100200529     C                             OR  DDACTN = 'I'                                           CFT120
615200200529     C                   EVAL      PCDROCHG = 'Y'                                             CFT120
615300200529     C                   ELSE                                                                 CFT120
615400200529     C                   EVAL      PCDROCHG = *BLANKS                                         CFT120
615500200529     C                   ENDIF                                                                CFT120
615600200529     C                   ENDIF                                                                CFT120
615700200529
615800200529     C                   CALLB     'FTIPAY4VL'
615900200529      *                             =========
616000200529      ** INPUT
616100200529      ** =====
616200200529
616300200529     C                   PARM      '*FRONT'      PMode
616400200529
616500200529      ** Response Mode (from caller: A=Asynchronous, S=Synchronous)
616600200529     C                   PARM                    PResponse
616700200529
616800200529      ** Incoming Payments Lvl 1 details
616900200529     C                   PARM                    TranInIPY1
617000200529
617100200529      ** Incoming Payments Lvl 2 Scrn 2 details from incoming transaction
617200200529      ** - screen format
617300200529     C                   PARM                    TranInIPY5
617400200529
617500200529      ** Settlement In Currency Indicator
617600200529     C                   PARM                    PSetInCy
617700200529
617800200529      ** Settlement EMU Transaction Period Start Date
617900200529     C                   PARM                    PSetTPSD
618000200529
618100200529      ** Payment In Currency Indicator
618200200529     C                   PARM                    PPayInCy
618300200529
618400200529      ** Payment EMU Transaction Period Start Date
618500200529     C                   PARM                    PPayTPSD
618600200529
618700200529      ** Input Charge Currency
618800200529     C                   PARM                    PICCY
618900200529
619000200529      ** Input Charge Currency No. of Decimal Places
619100200529     C                   PARM                    PINBDP
619200200529
619300200529      ** Output Charge Currency
619400200529     C                   PARM                    POCCY
619500200529
619600200529      ** Output Charge Currency No. of Decimal Places
619700200529     C                   PARM                    PONBDP
619800200529
619900200529      ** Saved default charges
620000200529     C                   PARM                    DefValid
620100200529     C                   PARM                    DefValidx
620200200529
620300200529      ** STANDING DATA
620400200529      ** =============
620500200529
620600200529      ** SDBANK - Base Currency Code
620700200529     C                   PARM                    BJCYCD
620800200529
620900200529      ** SDBANK - Midas Run Date
621000200529     C                   PARM                    PPROCDTE
621100200529
621200200529      ** SDBANK - Back Value Period in Days
621300200529     C                   PARM                    BJBVPD
621400200529
621500200529      ** SDBANK - Single Branch Code
621600200529     C                   PARM                    BJSBRC
621700200529
621800200529      ** SDBANK - Local currency code
621900200529     C                   PARM                    BJLCCY
622000200529
622100200529      ** SDMMOD - Multibranch Indicator
622200200529     C                   PARM                    BGMBIN
622300200529
622400200529      ** SDMMOD - Retail Banking
622500200529     C                   PARM                    BGRTBN
622600200529
622700200529      ** SDRETL - Retail A/c Number Required?
622800200529     C                   PARM                    BMRANR
622900200529
623000200529      ** SDGELR - Currency Code for Euro
623100200529     C                   PARM                    BKEURO
623200200529
623300200529      ** SDMMOD - Analytical Accounting
623400200529     C                   PARM                    BGN0ST
623500200529
623600200529      ** VAT Default Flag
623700200529     C                   PARM                    PVATT
623800200529
623900200529      ** VAT Rate
624000200529     C                   PARM                    PVATR
624100200529
624200200529      ** SDFTFR - Charges calculated in transaction ccy
624300200529     C                   PARM                    CHTRCY
624400200529
624500200529      ** SDFTFR - Charges currency indicator
624600200529     C                   PARM                    BTCHCY
624700200529
624800200529      ** SDFTFR - Fixed charge currency
624900200529     C                   PARM                    FCHCCY
625000200529
625100200529      ** SWITCHABLE FEATURES
625200200529      ** ===================
625300200529
625400200529      ** EMU FT Settlement Currency Conversion
625500200529     C                   PARM                    CEU006
625600200529
625700200529      ** BLI FT Enhancements Feature
625800200529     C                   PARM                    S01494
625900200529
626000200529      ** BLI VAT Processing Feature
626100200529     C                   PARM                    S01499
626200200529
626300200529      ** MT103 Messages Generation for FT
626400200529     C                   PARM                    CFT014
626500200529
626600200529      ** Fees & Charges
626700200529     C                   PARM                    CFT009
626800200529     C                   PARM                    CFT010
626900200529      *                                                                                       CFT120
627000200529      ** FT IN/OP - Charges on DR of Account Ccy                                              CFT120
627100200529      *                                                                                       CFT120
627200200529     C                   PARM                    CFT120                                       CFT120
627300200529
627400200529      ** OUTPUT
627500200529      ** ======
627600200529
627700200529      ** Error fields/message IDs/message data (arrays) from/to caller
627800200529     C                   PARM                    FldNameArr
627900200529     C                   PARM                    MsgIdArr
628000200529     C                   PARM                    MsgDtaArr
628100200529
628200200529      ** Array index (3P0) from/to caller
628300200529     C                   PARM                    Idx
628400200529
628500200529      ** Warning flds/message IDs/message data (arrays) from/to caller
628600200529     C                   PARM                    WFldNamArr
628700200529     C                   PARM                    WMsgIdArr
628800200529     C                   PARM                    WMsgDtaArr
628900200529
629000200529      ** Array index (3P0) from/to caller
629100200529     C                   PARM                    WIdx
629200200529
629300200529      ** Incoming Payments Lvl 2 Scrn 3 error indicators
629400200529     C                   PARM                    OKTrIPY4
629500200529
629600200529      ** Incoming Payments for file update - file format
629700200529     C                   PARM                    ValidIPAY
629800200529
629900200529      ** Incoming Payments (extension) for file update - file format
630000200529     C                   PARM                    ValidIPY2
630100200529
630200200529      ** DS for Default Charge Amounts
630300200529     C                   PARM                    PCharges
630400200529
630500200529      ** Force redisplay
630600200529     C                   PARM                    PFrcReDisplay
630700200529
630800200529      ** I/O: Previous Receiver's charges remitted input
630900200529      **      Its value is maintained in FTVIRCRM
631000200529     C                   PARM                    PPrvDDRCRM
631100200529
631200200529      ** I/O: Previous Total charges calculated
631300200529      **      Its value is maintained in FTVIRCRM
631400200529     C                   PARM                    PPrvTotChg
631500200529
631600200529      ** Charges to the debit of - field changed (Y or blank)
631700200529     C                   PARM                    PCDROChg
631800200529
631900200529      ** Previous warning messages array
632000200529     C                   PARM                    WPrvWarnAr
632100200529
632200200529      ** Warning message work inds for charges screen
632300200529     C                   PARM                    PChgWarn
632400200529     C                   PARM                    BENEDrBlck                                 MD025111
632500200529     C                   PARM                    BENEDrRefd                                MD047369A
632600200529
632700200529     C                   ENDSR
632800200529      *****************************************************************
632900200529      /EJECT
633000200529      *****************************************************************
633100200529      *                                                               *
633200200529      *  ValidateMg - Validate Margin Information details             *
633300200529      *                                                               *
633400200529      *****************************************************************
633500200529
633600200529     C     ValidateMg    BEGSR
633700200529
633800200529     C                   CALLB     'FTIPAY5VL'
633900200529      *                             =========
634000200529      ** INPUT
634100200529      ** =====
634200200529
634300200529     C                   PARM      '*FRONT'      PMode
634400200529
634500200529      ** Response Mode (from caller: A=Asynchronous, S=Synchronous)
634600200529     C                   PARM                    PResponse
634700200529
634800200529      ** Incoming Payments Lvl 1 Scrn details from incoming transaction
634900200529      ** - screen format
635000200529     C                   PARM                    TranInIPY1
635100200529
635200200529      ** Incoming Payments Margin info from incoming transaction
635300200529      ** - screen format
635400200529     C                   PARM                    TranInIPY6
635500200529      *                                                                                       CER030
635600200529      ** Incoming Payments Extended Narratives incoming transaction                           CER030
635700200529      ** - screen format                                                                      CER030
635800200529      *                                                                                       CER030
635900200529     C                   PARM                    TranInIP6A                                   CER030
636000200529      *                                                                                       CER030
636100200529      ** Incoming Payments Transaction Code from screen 2 level 2 for                         CER030
636200200529      ** defaulting value of Retail Transaction Type                                          CER030
636300200529      *                                                                                       CER030
636400200529     C                   PARM                    DDTTCD                                       CER030
636500200529
636600200529      ** STANDING DATA
636700200529      ** =============
636800200529
636900200529      ** SDMMOD - Analytical Accounting
637000200529     C                   PARM                    BGN0ST
637100200529
637200200529      ** OUTPUT
637300200529      ** ======
637400200529
637500200529      ** Error fields/message IDs/message data (arrays) from/to caller
637600200529     C                   PARM                    FldNameArr
637700200529     C                   PARM                    MsgIdArr
637800200529     C                   PARM                    MsgDtaArr
637900200529
638000200529      ** Array index (3P0) from/to caller
638100200529     C                   PARM                    Idx
638200200529
638300200529      ** Warning flds/message IDs/message data (arrays) from/to caller
638400200529     C                   PARM                    WFldNamArr
638500200529     C                   PARM                    WMsgIdArr
638600200529     C                   PARM                    WMsgDtaArr
638700200529
638800200529      ** Array index (3P0) from/to caller
638900200529     C                   PARM                    WIdx
639000200529
639100200529      ** Incoming Payments Margin info error indicators
639200200529     C                   PARM                    OKTrIPY5
639300200529
639400200529      ** Incoming Payments for file update - file format
639500200529     C                   PARM                    ValidIPAY
639600200529      *                                                                                       CER030
639700200529      ** Extension Valid File Value for Transaction code                                      CER030
639800200529      *                                                                                       CER030
639900200529     C                   PARM                    I2INTTCD                                     CER030
640000200529
640100200529     C                   ENDSR
640200200529      *****************************************************************
640300200529      /EJECT                                                                                  CSW209
640400200529      *****************************************************************                       CSW209
640500200529      *                                                               *                       CSW209
640600200529      *  ValidateTr7 - Validate input to Level 2 screen 7             *                       CSW209
640700200529      *                                                               *                       CSW209
640800200529      *****************************************************************                       CSW209
640900200529      *                                                                                       CSW209
641000200529     C     ValidateTr7   BEGSR                                                                CSW209
641100200529      *                                                                                       CSW209
641200200529     C                   CALLB     'FTIPAY7VL'                                                CSW209
641300200529      *                             =========                                                 CSW209
641400200529      ** INPUT                                                                                CSW209
641500200529      ** =====                                                                                CSW209
641600200529      *                                                                                       CSW209
641700200529      ** Mode = '*FRONT' (Front Office Transaction Interface)                                 CSW209
641800200529      ** Mode = '      ' (Not Front Office Transaction Interface)                             CSW209
641900200529      ** Mode = '*RPR  ' (Repair Function)                                                    CSW209
642000200529      ** Mode = '*SIN  ' (Screen Input Function)                                              CSW209
642100200529     C                   PARM                    PMode                                        CSW209
642200200529      *                                                                                       CSW209
642300200529      ** Incoming Payments details from incoming transaction                                  CSW209
642400200529      ** - screen format                                                                      CSW209
642500200529     C                   PARM                    ValidIPAY                                    CSW209
642600200529     C                   PARM                    TranInIPY2                                   CSW209
642700200529     C                   PARM                    TranInIPY4                                   CSW209
642800200529     C                   PARM                    TranInIPY7                                   CSW209
642900200529      *                                                                                       CSW209
643000200529      ** OUTPUT                                                                               CSW209
643100200529      ** ======                                                                               CSW209
643200200529      *                                                                                       CSW209
643300200529      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW209
643400200529     C                   PARM                    FldNameArr                                   CSW209
643500200529     C                   PARM                    MsgIdArr                                     CSW209
643600200529     C                   PARM                    MsgDtaArr                                    CSW209
643700200529      *                                                                                       CSW209
643800200529      ** Array index (3P0) from/to caller                                                     CSW209
643900200529     C                   PARM                    Idx                                          CSW209
644000200529      *                                                                                       CSW209
644100200529      ** Warning flds/message IDs/message data (arrays) from/to caller                        CSW209
644200200529     C                   PARM                    WFldNamArr                                   CSW209
644300200529     C                   PARM                    WMsgIdArr                                    CSW209
644400200529     C                   PARM                    WMsgDtaArr                                   CSW209
644500200529      *                                                                                       CSW209
644600200529      ** Array index (3P0) from/to caller                                                     CSW209
644700200529     C                   PARM                    WIDx                                         CSW209
644800200529      *                                                                                       CSW209
644900200529      ** Incoming Payments Lvl 2 Scrn 7 error indicators                                      CSW209
645000200529     C                   PARM                    OKTrIPY7                                     CSW209
645100200529      *                                                                                       CSW209
645200200529      ** Incoming Payments (additional details) for file update                               CSW209
645300200529     C                   PARM                    ValidIPY2                                    CSW209
645400200529      *                                                                                       CSW209
645500200529     C                   ENDSR                                                                CSW209
645600200529      *                                                                                       CSW209
645700200529      *****************************************************************                       CSW209
645800200529      /EJECT                                                                                  CSW209
645900200529      *****************************************************************                       CSW209
646000200529      *                                                               *                       CSW209
646100200529      *  ValidateTr8 - Validate input to Level 2 screen 8             *                       CSW209
646200200529      *                                                               *                       CSW209
646300200529      *****************************************************************                       CSW209
646400200529      *                                                                                       CSW209
646500200529     C     ValidateTr8   BEGSR                                                                CSW209
646600200529      *                                                                                       CSW209
646700200529     C                   CALLB     'FTIPAY8VL'                                                CSW209
646800200529      *                             =========                                                 CSW209
646900200529      ** INPUT                                                                                CSW209
647000200529      ** =====                                                                                CSW209
647100200529      *                                                                                       CSW209
647200200529      ** Mode = '*FRONT' (Front Office Transaction Interface)                                 CSW209
647300200529      ** Mode = '      ' (Not Front Office Transaction Interface)                             CSW209
647400200529      ** Mode = '*RPR  ' (Repair Function)                                                    CSW209
647500200529      ** Mode = '*SIN  ' (Screen Input Function)                                              CSW209
647600200529     C                   PARM                    PMode                                        CSW209
647700200529      *                                                                                       CSW209
647800200529      ** Incoming Payments details from incoming transaction                                  CSW209
647900200529      ** - screen format                                                                      CSW209
648000200529     C                   PARM                    TranInIPY7                                   CSW209
648100200529     C                   PARM                    TranInIPY8                                   CSW209
648200200529      *                                                                                       CSW209
648300200529      ** OUTPUT                                                                               CSW209
648400200529      ** ======                                                                               CSW209
648500200529      *                                                                                       CSW209
648600200529      ** Error fields/message IDs/message data (arrays) from/to caller                        CSW209
648700200529     C                   PARM                    FldNameArr                                   CSW209
648800200529     C                   PARM                    MsgIdArr                                     CSW209
648900200529     C                   PARM                    MsgDtaArr                                    CSW209
649000200529      *                                                                                       CSW209
649100200529      ** Array index (3P0) from/to caller                                                     CSW209
649200200529     C                   PARM                    Idx                                          CSW209
649300200529      *                                                                                       CSW209
649400200529      ** Warning flds/message IDs/message data (arrays) from/to caller                        CSW209
649500200529     C                   PARM                    WFldNamArr                                   CSW209
649600200529     C                   PARM                    WMsgIdArr                                    CSW209
649700200529     C                   PARM                    WMsgDtaArr                                   CSW209
649800200529      *                                                                                       CSW209
649900200529      ** Array index (3P0) from/to caller                                                     CSW209
650000200529     C                   PARM                    WIDx                                         CSW209
650100200529      *                                                                                       CSW209
650200200529      ** Incoming Payments Lvl 2 Scrn 7 error indicators                                      CSW209
650300200529     C                   PARM                    OKTrIPY8                                     CSW209
650400200529      *                                                                                       CSW209
650500200529      ** Incoming Payments (additional details) for file update                               CSW209
650600200529     C                   PARM                    ValidIPY2                                    CSW209
650700200529      *                                                                                       CSW209
650800200529     C                   ENDSR                                                                CSW209
650900200529      *                                                                                       CSW209
651000200529      *****************************************************************                       CSW209
651100200529      /EJECT
651300200529      *****************************************************************
651400200529      *                                                               *
651500200529      *  ResetCycle - Reset error information that is gradually       *
651600200529      *               updated during each run of this program         *
651700200529      *                                                               *
651800200529      *****************************************************************
651900200529
652000200529     C     ResetCycle    BEGSR
652100200529
652200200529     C                   RESET                   FldNameArr
652300200529     C                   RESET                   MsgIDArr
652400200529     C                   RESET                   MsgDtaArr
652500200529     C                   RESET                   Idx
652600200529
652700200529     C                   RESET                   WFldNamArr
652800200529     C                   RESET                   WMsgIDArr
652900200529     C                   RESET                   WMsgDtaArr
653000200529     C                   RESET                   WIdx
653100200529
653200200529     C                   RESET                   AmFldNamAr
653300200529     C                   RESET                   AmMsgIDArr
653400200529     C                   RESET                   AmMsgDtaAr
653500200529     C                   RESET                   AmIdx
653600200529
653700200529
653800200529     C                   RESET                   FldNoArr
653900200529
654000200529     C                   CLEAR                   CurTrIPY1
654100200529     C                   CLEAR                   CurTrIP1A
654200200529     C                   CLEAR                   CurTrIPY2
654300200529     C                   CLEAR                   CurTrIPY3
654400200529     C                   CLEAR                   CurTrIPY4
654500200529     C                   CLEAR                   CurTrIP4A
654600200529     C                   CLEAR                   CurTrIPY5
654700200529     C                   CLEAR                   CurTrIPY6
654800200529     C                   CLEAR                   CurTrIP6A                                    CER030
654900200529     C                   IF        CSW209 = 'Y'                                               CSW209
655000200529     C                   CLEAR                   CurTrIPY7                                    CSW209
655100200529     C                   CLEAR                   CurTrIPY8                                    CSW209
655200200529     C                   ENDIF                                                                CSW209
655300200529
655400200529     C                   MOVE      *ALL'Y'       OKTrIPY1
655500200529     C                   MOVE      *ALL'Y'       OKTrIPY2
655600200529     C                   MOVE      *ALL'Y'       OKTrIPY3
655700200529     C                   MOVE      *ALL'Y'       OKTrIPY4
655800200529     C                   MOVE      *ALL'Y'       OKTrIPY5
655900200529     C                   IF        CSW209 = 'Y'                                               CSW209
656000200529     C                   MOVE      *ALL'Y'       OKTrIPY7                                     CSW209
656100200529     C                   MOVE      *ALL'Y'       OKTrIPY8                                     CSW209
656200200529     C                   ENDIF                                                                CSW209
656300200529
656400200529     C                   CLEAR                   ValidIPAY
656500200529     C                   CLEAR                   ValidIPY2
656600200529
656700200529     C                   MOVE      *BLANKS       PStatus
656800200529     C                   MOVE      'IN'          PPYTP
656900200529                                                                                             CSF011A
657000200529      **Initialise Customer Name on input fields                                             CSF011A
657100200529                                                                                             CSF011A
657200200529     C                   EVAL      DDSNSN  = *BLANKS                                         CSF011A
657300200529     C                   EVAL      DDSNNM  = *BLANKS                                         CSF011A
657400200529     C                   EVAL      DDSNTN  = *BLANKS                                         CSF011A
657500200529     C                   EVAL      DDSNAN  = *BLANKS                                         CSF011A
657600200529     C                   EVAL      DDSNSW  = *BLANKS                                         CSF011A
657700200529     C                   EVAL      DDRCSN  = *BLANKS                                         CSF011A
657800200529     C                   EVAL      DDRCNM  = *BLANKS                                         CSF011A
657900200529     C                   EVAL      DDRCTN  = *BLANKS                                         CSF011A
658000200529     C                   EVAL      DDRCAN  = *BLANKS                                         CSF011A
658100200529     C                   EVAL      DDRCSW  = *BLANKS                                         CSF011A
658200200529     C                   EVAL      DDBNSN  = *BLANKS                                         CSF011A
658300200529     C                   EVAL      DDBNNM  = *BLANKS                                         CSF011A
658400200529     C                   EVAL      DDBNTN  = *BLANKS                                         CSF011A
658500200529     C                   EVAL      DDBNAN  = *BLANKS                                         CSF011A
658600200529     C                   EVAL      DDBNSW  = *BLANKS                                         CSF011A
658700200529     C                   EVAL      DDTRSN  = *BLANKS                                         CSF011A
658800200529     C                   EVAL      DDTRNM  = *BLANKS                                         CSF011A
658900200529     C                   EVAL      DDTRTN  = *BLANKS                                         CSF011A
659000200529     C                   EVAL      DDTRAN  = *BLANKS                                         CSF011A
659100200529     C                   EVAL      DDTRSW  = *BLANKS                                         CSF011A
659200200529     C                   EVAL      DDABSN  = *BLANKS                                         CSF011A
659300200529     C                   EVAL      DDABNM  = *BLANKS                                         CSF011A
659400200529     C                   EVAL      DDABTN  = *BLANKS                                         CSF011A
659500200529     C                   EVAL      DDABAN  = *BLANKS                                         CSF011A
659600200529     C                   EVAL      DDABSW  = *BLANKS                                         CSF011A
659700200529     C                   EVAL      DDOBSN  = *BLANKS                                         CSF011A
659800200529     C                   EVAL      DDOBNM  = *BLANKS                                         CSF011A
659900200529     C                   EVAL      DDOBTN  = *BLANKS                                         CSF011A
660000200529     C                   EVAL      DDOBSW  = *BLANKS                                         CSF011A
660100200529     C                   EVAL      DDOCSN  = *BLANKS                                         CSF011A
660200200529     C                   EVAL      DDOCNM  = *BLANKS                                         CSF011A
660300200529     C                   EVAL      DDOCTN  = *BLANKS                                         CSF011A
660400200529     C                   EVAL      DDOCAN  = *BLANKS                                         CSF011A
660500200529     C                   EVAL      DDOCSW  = *BLANKS                                         CSF011A
660600200529     C                   EVAL      DDSCSN  = *BLANKS                                         CSF011A
660700200529     C                   EVAL      DDSCNM  = *BLANKS                                         CSF011A
660800200529     C                   EVAL      DDSCTN  = *BLANKS                                         CSF011A
660900200529     C                   EVAL      DDSCSW  = *BLANKS                                         CSF011A
661000200529     C                   EVAL      DDIBSN  = *BLANKS                                         CSF011A
661100200529     C                   EVAL      DDIBNM  = *BLANKS                                         CSF011A
661200200529     C                   EVAL      DDIBTN  = *BLANKS                                         CSF011A
661300200529     C                   EVAL      DDIBSW  = *BLANKS                                         CSF011A
661400200529     C                   EVAL      DDCDSN  = *BLANKS                                         CSF011A
661500200529     C                   EVAL      DDCDNM  = *BLANKS                                         CSF011A
661600200529     C                   EVAL      DDCDTN  = *BLANKS                                         CSF011A
661700200529     C                   EVAL      DDCDAN  = *BLANKS                                         CSF011A
661800200529     C                   EVAL      DDCDSW  = *BLANKS                                         CSF011A
661900200529
662000200529     C                   ENDSR
662100200529      *****************************************************************
662200200529      /EJECT
662300200529      *****************************************************************
662400200529      *                                                               *
662500200529      *  SetUpValid - Set up additional fields that are needed on the *
662600200529      *               valid file record.                              *
662700200529      *                                                               *
662800200529      *****************************************************************
662900200529
663000200529     C     SetUpValid    BEGSR
663100200529
663200200529      ** INSERT
663300200529      ** ======
663400200529     C                   IF        DDACTN = 'I'
663500200529
663600200529      ** Update Incoming Payments data area with next
663700200529      ** Sequence Number.
663800200529
663900200529     C                   IF        CFT151 = 'N'                                               CFT151
664000200529     C     *DTAARA       DEFINE    INPAYDA       WINPAY
664100200529     C     *LOCK         IN        WINPAY
664200200529     C                   Z-ADD     WINSQ         WWInsQ
664300200529                                                                                              CSC024
664400200529      ***Suppress*new*payment*reference*generation*if*CSC024*is                        CSC024 CSC054
664500200529      ***switched*on*and*this*is*running*on*OME*system.                                CSC024 CSC054
664600200529      ** Suppress new payment reference generation if CSC054 is                               CSC054
664700200529      ** switched on and this is running on PEA system.                                       CSC054
664800200529                                                                                              CSC024
664900200529     C                   IF        GENPREF = 'Y'                                              CSC024
665000200529     C                             OR DDPREF = *BLANKS                                        CSC024
665100200529     C                   ADD       1             WInsQ
665200200529     C                   ENDIF                                                                CSC024
665300200529                                                                                              CSC024
665400200529     C                   OUT       WINPAY
665500200529                                                                                              CFT151
665600200529     C                   ELSE                                                                 CFT151
665700200529                                                                                              CFT151
665800200529     C                   IF        GENPREF = 'Y'                                              CFT151
665900200529     C                             OR DDPREF = *BLANKS                                        CFT151
666000200529     C                   CALL      'FT000328'                                                 CFT151
666100200529     C                   PARM                    PRTCD                                        CFT151
666200200529     C                   PARM      'IN'          W@OTIN            2                          CFT151
666300200529     C                   PARM      'A'           WCALC             1                          CFT151
666400200529     C                   PARM      'Y'           WUPD              1                          CFT151
666500200529     C                   PARM                    WWINSQT           4                          CFT151
666600200529     C                   PARM                    WNEWSQ            4                          CFT151
666700200529                                                                                              CFT151
666800200529     C                   ENDIF                                                                CFT151
666900200529                                                                                              CFT151
667000200529     C                   ENDIF                                                                CFT151
667100200529
667200200529      ** Record Id.
667300200529
667400200529     C                   MOVEL     'D'           IPRECI
667500200529
667600200529      ** Payment Type.
667700200529
667800200529     C                   EVAL      IPPYTP = 'IN'
667900200529
668000200529      ** Original Entry Dates.
668100200529
668200200529     C                   Z-ADD     BJRDNB        PDayNo
668300200529
668400200529     C                   CALLB     'ZDATE2'
668500200529     C                   PARM                    PDayNo
668600200529     C                   PARM      BJDFIN        PFMT
668700200529     C                   PARM      *ZERO         PDate
668800200529     C                   PARM      *BLANKS       PADate
668900200529
669000200529     C                   Z-ADD     BJRDNB        IPOEDT
669100200529     C                   Z-ADD     PDate         IPOEDTD1
669200200529
669300200529     C                   MOVE      PDate         WN2
669400200529     C     WN2           IFLT      72
669500200529     C                   Z-ADD     20            IPOEDTD2
669600200529     C                   ELSE
669700200529     C                   Z-ADD     19            IPOEDTD2
669800200529     C                   ENDIF
669900200529
670000200529     C                   MOVEL     PDate         WA4
670100200529     C     BJDFIN        IFNE      'M'
670200200529     C                   MOVEL     WA4           WA2
670300200529     C                   MOVE      WA4           WA2A
670400200529     C                   MOVEL     WA2A          WA4
670500200529     C                   MOVE      WA2           WA4
670600200529     C                   ENDIF
670700200529
670800200529     C                   MOVE      PDate         WA2
670900200529     C                   MOVEL     WA2           PDate
671000200529     C                   MOVE      WA4           PDate
671100200529     C                   Z-ADD     PDate         IPOEDTD3
671200200529
671300200529      ** New Payment Reference.
671400200529
671500200529     C                   IF        CSC011 = 'Y' AND LIBR = S1SUPP
671600200529
671700200529     C                   Z-ADD     WPRDTE        PDAYNO
671800200529     C                   CALLB     'ZDATE2'
671900200529     C                   PARM                    PDAYNO
672000200529     C                   PARM      BJDFIN        PFMT
672100200529     C                   PARM      *ZERO         PPRDATE
672200200529     C                   PARM      *BLANKS       PPRADATE
672300200529
672400200529     C                   MOVEL     PPRDATE       WA4
672500200529     C     BJDFIN        IFNE      'M'
672600200529     C                   MOVEL     WA4           WA2
672700200529     C                   MOVE      WA4           WA2A
672800200529     C                   MOVEL     WA2A          WA4
672900200529     C                   MOVE      WA2           WA4
673000200529     C                   ENDIF
673100200529
673200200529     C                   MOVE      PPRDATE       WA2
673300200529     C                   MOVEL     WA2           PPRDATE
673400200529     C                   MOVE      WA4           PPRDATE
673500200529     C                   MOVE      PPRDATE       WA6
673600200529     C                   ELSE
673700200529     C                   MOVE      PDate         WA6
673800200529     C                   ENDIF
673900200529     C                   IF        CFT151 = 'N'                                               CFT151
674000200529     C                   MOVE      WWInsQ        WA4
674100200529     C                   ELSE                                                                 CFT151
674200200529     C                   MOVE      WWINSQT       WA4                                          CFT151
674300200529     C                   END                                                                  CFT151
674400200529     C                   MOVE      'P'           WYA1(1)
674500200529     C                   MOVEA     WA6           WYA1(2)
674600200529     C                   MOVEA     WA4           WYA1(8)
674700200529     C                   MOVEA     IPPYTP        WYA1(12)
674800200529     C                   MOVEA     '00'          WYA1(14)
674900200529
675000200529     C     1             DO        15            IA
675100200529     C                   IF        WYA1(IA) = ' '
675200200529     C                   MOVEL     '0'           WYA1(IA)
675300200529     C                   ENDIF
675400200529     C                   ENDDO
675500200529
675600200529     C                   IF        GENPREF = 'Y'                                              CSC024
675700200529     C                             OR DDPREF = *BLANKS                                        CSC024
675800200529     C                   MOVEA     WYA1(1)       IPPREF
675900200529     C                   ELSE                                                                 CSC024
676000200529     C                   EVAL      IPPREF = DDPREF                                            CSC024
676100200529     C                   ENDIF                                                                CSC024
676200200529
676300200529      ** Level 1 Valid Indicator.
676400200529
676500200529     C                   EVAL      IPINLVL1 = 'Y'
676600200529
676700200529     C                   ENDIF
676800200529
676900200529      ** INSERT OR AMEND
677000200529      ** ===============
677100200529
677200200529     C                   IF        DDACTN = 'I' or
677300200529     C                             DDACTN = 'A'
677400200529
677500200529      ** Input Officer 1.
677600200529
677700200529     C**********         EVAL      IPINUSR1 = PSUser                                         BUG1493
677800200529     C**********         EVAL      IPINUSR1 = PUSRID                                BUG1493 MD042042
677900200529     C                   EVAL      IPINUSR1 = InputUser                                     MD042042
678000200529
678100200529      ** Level 2 details have been processed.
678200200529
678300200529     C                   IF        WLVL2 = 'Y'
678400200529
678500200529      ** Input Officer 2.
678600200529     C**********         EVAL      IPINUSR2 = PSUser                                         BUG1493
678700200529     C**********         EVAL      IPINUSR2 = PUSRID                                BUG1493 MD042042
678800200529     C                   EVAL      IPINUSR2 = InputUser                                     MD042042
678900200529      ** Level 2 Valid Indicator.
679000200529     C                   EVAL      IPINLVL2 = 'Y'
679100200529
679200200529     C                   ENDIF
679300200529
679400200529     C                   ENDIF
679500200529
679600200529      ** DELETE
679700200529      ** ======
679800200529
679900200529     C                   IF        DDACTN = 'D'
680000200529     C                             or (DDACTN = 'S' AND CFT157 = 'Y')                         CFT157
680100200529
680200200529      ** Move Incoming Payment details retrieved from file
680300200529      ** directly to the Valid Record data structure.
680400200529
680500200529     C                   MOVEL     IPAYFilFmt    ValidIPAY
680600200529     C                   IF        CFT003 = 'Y' or CFT014 = 'Y'
680700200529     C                             OR CFT009 = 'Y'
680800200529     C                   MOVEL     IPY2FilFmt    ValidIPY2
680900200529     C                   ELSE                                                                BUG7101
681000200529     C                   CLEAR                   ValidIPY2                                   BUG7101
681100200529     C                   ENDIF
681200200529
681300200529      ** Record Id - update to 'C'.
681400200529
681500200529     C                   EVAL      IPRECI = 'C'
681600200529      *
681700200529     C                   ENDIF
681800200529
681900200529      ** Enquire.
682000200529
682100200529     C                   IF        DDACTN = 'E'
682200200529
682300200529      ** Move Incoming Payment details retrieved from file
682400200529      ** directly to the Valid Record data structure.
682500200529
682600200529     C                   MOVEL     IPAYFilFmt    ValidIPAY
682700200529     C                   IF        CFT003 = 'Y' or CFT014 = 'Y'
682800200529     C                             OR CFT009 = 'Y'
682900200529     C                   MOVEL     IPY2FilFmt    ValidIPY2
683000200529     C                   ELSE                                                                BUG7101
683100200529     C                   CLEAR                   ValidIPY2                                   BUG7101
683200200529     C                   ENDIF
683300200529
683400200529     C                   ENDIF
683500200529
683600200529      ** STOP                                                                                 CFT157
683700200529      ** ====                                                                                 CFT157
683800200529                                                                                              CFT157
683900200529     C                   IF        DDACTN = 'S' AND CFT157 = 'Y'                              CFT157
684000200529     C                   IF        AAUTH = 'Y'                                                CFT157
684100200529     C                   EVAL      IPSUSR = PUSRID                                            CFT157
684200200529     C                   ELSE                                                                 CFT157
684300200529     C                   EVAL      IPSUSR = DDSUSR                                            CFT157
684400200529     C                   EVAL      IPSAUS = PUSRID                                            CFT157
684500200529     C                   ENDIF                                                                CFT157
684600200529     C                   ENDIF                                                                CFT157
684700200529                                                                                              CFT157
684800200529      ** Last Change Type, Date and Time.
684900200529
685000200529     C                   MOVEL     DDACTN        IPCHTP
685100200529     C                   Z-ADD     BJRDNB        IPLCD
685200200529     C                   TIME                    IPLCHT
685300200529
685400200529      ** Message Header details.
685500200529
685600200529     C                   IF        APFOTRANID <> *Blanks                                    MD032077
685700200529     C                   EVAL      IPFRNT = APFOTRANID
685800200529     C                   EVAL      IPREPA = APRPRLOCN
685900200529     C                   ENDIF                                                              MD032077
686000200529
686100200529      ** Set up the following fields for update of FTVIPY2PD
686200200529
686300200529     C                   IF        CFT003 = 'Y' OR
686400200529     C                             CFT014 = 'Y' OR
686500200529     C                             CFT009 = 'Y'
686600200529
686700200529     C/COPY WNCPYSRC,FTH00416
686800200529     C                   EVAL      I2INAUTO = 'N'
686900200529     C/COPY WNCPYSRC,FTH00417
687000200529
687100200529     C                   IF        DDACTN = 'I' OR
687200200529     C                             DDACTN = 'A' OR
687300200529     C                             DDACTN = 'D'
687400200529     C                             or (DDACTN = 'S' AND CFT157 = 'Y')                         CFT157
687500200529
687600200529     C                   IF        DDACTN = 'I'
687700200529     C                   EVAL      I2INRECI = 'D'
687800200529     C                   EVAL      I2INPREF = IPPREF
687900200529     C                   EVAL      I2INFRNT = IPFRNT
688000200529     C                   ENDIF
688100200529
688200200529     C                   EVAL      I2INTMST = IPTMST
688300200529     C                   ENDIF
688400200529
688500200529     C                   ENDIF
688600200529
688700200529      /COPY WNCPYSRC,FTIPAYV017
688800200529                                                                                             BUG4196
688900200529      * Restore Timestamp from the original record                                           BUG4196
689000200529     C                   IF        DDACTN <> 'I'                                             BUG4196
689100200529     C                             AND @TimeStamp <> *BLANKS                                 BUG4728
689200200529     C                   MOVEL     @TimeStamp    IPTMST                                      BUG4196
689300200529     C                   ENDIF                                                               BUG4196
689400200529
689500200529     C                   ENDSR
689600200529
689700200529      *****************************************************************
689800200529      /EJECT
689900200529      *****************************************************************
690000200529      *                                                               *
690100200529      *  UpdateDB - Update database                                   *
690200200529      *                                                               *
690300200529      *****************************************************************
690400200529
690500200529     C     UpdateDB      BEGSR
690600200529
690700200529      *                                                                                       252696
690800200529     C                   IF        IPMIR = *Blanks  and                                       252696
690900200529     C                             DDSWFLG  = 'Y'                                             252696
691000200529     C                   MOVEL     DDSWTN        IPMIR                                        252696
691100200529     C                   MOVEL     DDSWTN        MIR@             28                          252696
691200200529     C     MIR@          CHAIN     INPAYLL                            92                      252696
691300200529     C                   IF        *IN92 = '0'                                                252696
691400200529     C                   GOTO      EMUpd                                                      252696
691500200529     C                   ENDIF                                                                252696
691600200529     C     IPMIR         CHAIN     MEINCRL2                           93                      252696
691700200529     C                   IF        *IN93 = '1'                                                252696
691800200529     C                   MOVEL     'Y'           WErr                                         252696
691900200529     C                   MOVEL     'MIN0100'     PErrMs                                       252696
692000200529     C                   EXSR      SRSndM                                                     252696
692100200529     C                   MOVE      'N'           OKSWTN                                       252696
692200200529     C                   GOTO      EMUpd                                                      252696
692300200529     C                   ENDIF                                                                252696
692400200529     C                   IF        *IN93 = '0'                                                252696
692500200529     C                   MOVEL     CRMSGR        IPINMSGR                                     252696
692600200529     C                   MOVEL     CRMTPY        IPINMTPY                                     252696
692700200529     C                   MOVEL     CRNPRT        WWISEQ            3 0                        252696
692800200529     C                   Z-ADD     WWISEQ        IPINKPRT                                     252696
692900200529      *                                                                                       252696
693000200529     C     KEYMP         CHAIN     MEINMPL1                           94                      252696
693100200529     C                   IF        *IN94 = '0'                                                252696
693200200529     C                   MOVEL     MPTRNO        IPINTRNO                                     252696
693300200529     C                   ENDIF                                                                252696
693400200529     C                   ENDIF                                                                252696
693500200529      *                                                                                       252696
693600200529     C                   ENDIF                                                                252696
693700200529      *                                                                                       252696
693800200529     C                   IF        IPINLVL1  = 'Y' and                                        252696
693900200529     C                             IPINLVL2  = 'Y'                                            252696
694000200529     C                   IF        IPAUP1    = *Blanks  and                                   252696
694100200529     C                             IPAUP1    = *Blanks                                        252696
694200200529     C                   MOVEL     PUSRID        IPAUP1                                       252696
694300200529     C                   MOVEL     PUSRID        IPAUP2                                       252696
694400200529     C                   MOVEL     'Y'           IPAUIN                                       252696
694500200529     C                   ENDIF                                                                252696
694600200529     C                   ENDIF                                                                252696
694700200529      ** Update files.
694800200529
694900200529     C                   CALLB     'FTIPAYUPD'
695000200529      *                             =========
695100200529      ** INPUT
695200200529      ** =====
695300200529
695400200529      ** Return Code
695500200529     C                   PARM      *BLANKS       RetCodeOut
695600200529
695700200529      ** Incoming Payments for file update - file format
695800200529     C                   PARM                    ValidIPAY
695900200529
696000200529      ** Incoming Payments (additional details) for file update
696100200529     C                   PARM                    ValidIPY2
696200200529
696300200529      ** IBANs full account
696400200529     C                   PARM                    PIBANAcc
696500200529
696600200529      ** Originally Insert from Level 2 Entry
696700200529     C                   PARM      *BLANK        POrigActn
696800200529
696900200529      ** FT Override for GL Balances
697000200529     C                   PARM                    PFTOV
697100200529
697200200529      ** FT Control Data
697300200529     C                   PARM                    PCNTRL
697400200529
697500200529      ** Network
697600200529     C                   PARM                    PNWRK
697700200529
697800200529      ** Entry Point
697900200529     C                   PARM                    PParmLevel
698000200529
698100200529      ** STANDING DATA
698200200529      ** =============
698300200529
698400200529      ** SDBANK - Base Currency Code
698500200529     C                   PARM                    BJCYCD
698600200529
698700200529      ** SDBANK - Midas Run Date
698800200529     C                   PARM                    BJRDNB
698900200529
699000200529      ** SDBANK - Single Branch Code
699100200529     C                   PARM                    BJSBRC
699200200529
699300200529      ** SDGELR - Originating Branch/User Vald Req.
699400200529     C                   PARM                    BKOBUV
699500200529
699600200529      ** ZMUSER - Default Branch
699700200529     C                   PARM                    PDBRN
699800200529
699900200529      ** SWITCHABLE FEATURES
700000200529      ** ===================
700100200529
700200200529      ** Batch Authorisation
700300200529     C                   PARM                    CFT003
700400200529
700500200529      ** IBAN numbers
700600200529     C                   PARM                    CFT004
700700200529
700800200529      ** BLI FT Enhancements Feature
700900200529     C                   PARM                    S01494
701000200529
701100200529      ** BLI VAT Processing Feature
701200200529     C                   PARM                    S01499
701300200529
701400200529      ** STP Phase 2 MT103
701500200529     C                   PARM                    CFT014
701600200529
701700200529      ** Fees & Charges
701800200529     C                   PARM                    CFT009
701900200529     C                   PARM                    CFT010
702000200529
702100200529      ** 24 X 7
702200200529     C                   PARM                    CSC011
702300200529     C                   PARM                    CSD015
702400200529     C                   PARM                    CCF001
702500200529      *                                                                                       CAP211
702600200529     C                   PARM                    AAuth                                        CAP211
702700200529     C                   PARM                    APUSERID                                     CAP211
702800200529
702900200529      /COPY WNCPYSRC,FTIPAYV018
703000200529
703100200529      ** If errors occurred on update, rollback uncommitted file
703200200529      ** changes.
703300200529
703400200529     C                   IF        RetCodeOut <> *BLANKS and
703500200529     C                             RetCodeOut <> '*RECUPD'
703600200529     C                   MOVEL     '0'           APIRetc
703700200529      **                                                                                      CSC022
703800200529      ** Execute rollback if SAR CSC022 is not enrolled or                                    CSC022
703900200529      **   job is not currently running in batch mode                                         CSC022
704000200529      **                                                                                      CSC022
704100200529     C                   If        CSC022 = 'N'                                               CSC022
704200200529     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
704300200529     C                   ROLBK
704400200529     C                   EndIf                                                                CSC022
704500200529     C                   EXSR      *PSSR
704600200529     C                   ELSE
704700200529     C                   IF        RetCodeOut = '*RECUPD'
704800200529      **                                                                                      CSC022
704900200529      ** Execute rollback if SAR CSC022 is not enrolled or                                    CSC022
705000200529      **   job is not currently running in batch mode                                         CSC022
705100200529      **                                                                                      CSC022
705200200529     C                   If        CSC022 = 'N'                                               CSC022
705300200529     C                   ROLBK
705400200529     C                   Else                                                                 CSC022
705500200529     C                   If        WSkpComtRolbk = 'N'                                        CSC022
705600200529     C                   RolBk                                                                CSC022
705700200529     C                   Else                                                                 CSC022
705800200529     C                   SetOn                                        U7U8                    CSC022
705900200529     C                   EndIf                                                                CSC022
706000200529     C                   EndIf                                                                CSC022
706100200529     C                   ELSE
706200200529      **                                                                                      CSC022
706300200529      ** Execute commit if SAR CSC022 is not enrolled or                                      CSC022
706400200529      **   job is not currently running in batch mode                                         CSC022
706500200529      **                                                                                      CSC022
706600200529     C                   If        CSC022 = 'N'                                               CSC022
706700200529     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
706800200529     C                   COMMIT
706900200529     C                   EndIf                                                                CSC022
707000200529     C                   EVAL      DDPREF = IPPREF
707100200529     C                   ENDIF
707200200529      *                                                                                     BUG13159
707300200529      ** Update @TimeStamp with IPTMST of ValidIPAY, if the Update/Write was a success      BUG13159
707400200529      *                                                                                     BUG13159
707500200529     C                   MOVE      IPTMST        @TimeStamp                                 BUG13159
707600200529      *                                                                                     BUG13159
707700200529     C                   ENDIF
707800200529
707900200529      ** If update not done due to record being updated by another
708000200529      ** workstation, display message "The last transaction was not
708100200529      ** applied to the database." to the next screen.
708200200529
708300200529     C                   IF        RetCodeOut <> *BLANKS
708400200529     C                   Z-ADD     1             Idx
708500200529     C                   EVAL      FldNameArr(Idx) = '*ANY'
708600200529     C                   EVAL      MsgIdArr(Idx) = 'FTA0120'
708700200529     C                   ENDIF
708800200529
708900200529     C                   IF        ULX043 = 'Y'                                               CER001
709000200529                                                                                              CER001
709100200529     C                   EVAL      #LLXIPPREF = IPPREF                                        CER001
709200200529                                                                                              CER001
709300200529     C                   CALLB     'FTIPAY2UP'                                                CER001
709400200529     C                   PARM                    PActn                                        CER001
709500200529     C                   PARM      *BLANKS       PRetCodeIn                                   CER001
709600200529     C                   PARM                    WFIND                                        CER001
709700200529     C                   PARM                    IPAYValPmt                                   CER001
709800200529     C                   PARM                    IPAYExFilFmt                                 CER001
709900200529                                                                                              CER001
710000200529     C                   ENDIF                                                                CER001
710100200529                                                                                              CER001
710200200529     C**********         ENDSR                                                                252696
710300200529     C     EMUpd         ENDSR                                                                252696
710400200529
710500200529      *****************************************************************
710600200529      /EJECT
710700200529      *****************************************************************
710800200529      *                                                               *
710900200529      * *INZSR - Program Initialisation routine                       *
711000200529      *                                                               *
711100200529      *****************************************************************
711200200529     C     *INZSR        BEGSR
711300200529
711400200529     C     *ENTRY        PLIST
711500200529
711600200529      ** Common header information (DS) from source system
711700200529     C                   PARM                    HeadIn
711800200529
711900200529      ** Transaction information
712000200529     C**********         PARM                    Trans5001                                   CSF011A
712100200529     C                   PARM                    Trans01                                     CSF011A
712200200529     C                   PARM                    Trans5002
712300200529     C**********         PARM                    Trans5003                                   CSF011A
712400200529     C                   PARM                    Trans03                                     CSF011A
712500200529     C                   PARM                    Trans5004
712600200529     C**********         PARM                    Trans5005                                   CSF011A
712700200529     C                   PARM                    Trans05                                     CSF011A
712800200529     C                   PARM                    Trans5006
712900200529     C                   PARM                    Trans5007
713000200529     C                   PARM                    Trans5008
713100200529     C                   PARM                    Trans5009                                    CSW209
713200200529     C                   PARM                    Trans5010                                    CSW209
713300200529     C**********         PARM                    Trans5009                             CER030 262664
713400200529     C                   PARM                    Trans5008A                                   262664
713500200529     C                   PARM                    Trans5011                                    CER049
713600200529
713700200529      ** Extra Data
713800200529     C                   PARM                    RegData500                                   CER001
713900200529     C                   PARM                    ExtData500
714000200529     C                   PARM                    StopFTDta                                  MD050928
714100200529
714200200529      ** Error fields/message IDs/message data (arrays) from/to caller
714300200529
714400200529     C                   PARM                    FldNameArr
714500200529     C                   PARM                    MsgIDArr
714600200529     C                   PARM                    MsgDtaArr
714700200529
714800200529      ** Warning error fields/message IDs/message data (arrays)
714900200529      ** from/to caller
715000200529
715100200529     C                   PARM                    WFldNamArr
715200200529     C                   PARM                    WMsgIDArr
715300200529     C                   PARM                    WMsgDtaArr
715400200529     C                   PARM                    MsgFArray
715500200529
715600200529      ** Update Transaction
715700200529     C                   PARM                    UpdateYN
715800200529
715900200529      ** Output Buffer
716000200529     C                   PARM                    Buffer
716100200529
716200200529      ** API Return Code
716300200529     C                   PARM                    APIRetc
716400200529     C                   PARM                    @TimeStamp       26                         BUG4196
716500200529     C                   PARM                    NewButton         3                          255190
716600200529     C                   PARM                    AAuth             1                        BUG22146
716700200529     C                   PARM                    InputUser                                  MD042042
716800200529
716900200529      * Set up the names of the message files from which the message handler
717000200529      * will get the messages
717100200529     C                   EVAL      MsgFArray(1) = 'FTUSRMSG'
717200200529     C                   EVAL      MsgFArray(2) = 'DRSMM'
717300200529     C                   EVAL      MsgFArray(3) = 'MEMSG'
717400200529
717500200529      * Hook to enable non-core message files to be included
717600200529     D/COPY WNCPYSRC,FTIPAYM01
717700200529
717800200529      ** Set up the name of the module Id used to make the transaction
717900200529      ** number unique.
718000200529
718100200529     C                   EVAL      PModuleId = 'FT'
718200200529
718300200529      ** Access Bank details.
718400200529
718500200529     C                   CALLB     'AOBANKR0'
718600200529     C                   PARM      '*DBERR '     PRtCd
718700200529     C                   PARM      '*FIRST '     POptn
718800200529     C     SDBANK        PARM      SDBANK        DSFDY
718900200529
719000200529      ** Access API ICD details.
719100200529
719200200529     C                   CALLB     'AOAPIR0'
719300200529     C                   PARM      '*DBERR '     PRtCd
719400200529     C                   PARM      '*FIRST '     POptn
719500200529     C     SDAPI         PARM      SDAPI         DSFDY
719600200529
719700200529      ** Access General Ledger ICD details.
719800200529
719900200529     C**********         CALLB     'AOGELRR0'                                                 CGL029
720000200529     C                   CALLB     'AOGELRR1'                                                 CGL029
720100200529     C                   PARM      '*DBERR '     PRtCd
720200200529     C                   PARM      '*FIRST '     POptn
720300200529     C     SDGELR        PARM      SDGELR        DSSDY
720400200529
720500200529      ** Access Midas Modules details.
720600200529
720700200529     C                   CALLB     'AOMMODR0'
720800200529     C                   PARM      '*DBERR '     PRtCd
720900200529     C                   PARM      '*FIRST '     POptn
721000200529     C     SDMMOD        PARM      SDMMOD        DSFDY
721100200529
721200200529      ** Access Funds Transfer ICD details.
721300200529
721400200529     C                   CALL      'AOFTFRR0'
721500200529     C                   PARM      '*DBERR '     PRtCd
721600200529     C                   PARM      '*FIRST '     POptn
721700200529     C     SDFTFR        PARM      SDFTFR        DSFDY
721800200529
721900200529      ** Access Retail ICD details if Retail module is
722000200529      ** installed.
722100200529
722200200529     C                   IF        BGRTBN = 'Y'
722300200529
722400200529     C                   CALLB     'AORETLR0'
722500200529     C                   PARM      '*DBERR '     PRtCd
722600200529     C                   PARM      '*FIRST '     POptn
722700200529     C     SDRETL        PARM      SDRETL        DSFDY
722800200529
722900200529     C                   ENDIF
723000200529
723100200529      ** Access SAR file to determine if S01494
723200200529      ** (BLI FT Enhancements Feature) is installed.
723300200529
723400200529     C                   CALLB     'AOSARDR0'
723500200529     C                   PARM      *BLANKS       PRtCd
723600200529     C                   PARM      '*VERIFY'     POptn
723700200529     C                   PARM      'S01494'      PSard
723800200529     C     SCSARD        PARM      SCSARD        DSFDY
723900200529
724000200529     C                   IF        PRtCd = *BLANKS
724100200529     C                   MOVEL     'Y'           S01494
724200200529     C                   ELSE
724300200529     C                   MOVEL     'N'           S01494
724400200529     C                   ENDIF
724500200529
724600200529      ** Access SAR file to determine if S01499 (BLI VAT Processing)
724700200529      ** is installed.
724800200529
724900200529     C                   CALLB     'AOSARDR0'
725000200529     C                   PARM      *BLANKS       PRtCd
725100200529     C                   PARM      '*VERIFY'     POptn
725200200529     C                   PARM      'S01499'      PSard
725300200529     C     SCSARD        PARM      SCSARD        DSFDY
725400200529
725500200529     C                   IF        PRtCd = *BLANKS
725600200529     C                   MOVEL     'Y'           S01499
725700200529     C                   ELSE
725800200529     C                   MOVEL     'N'           S01499
725900200529     C                   ENDIF
726000200529
726100200529      ** Access SAR file to determine if S01506 (BLI Payment Charges
726200200529      ** Enhancements) is installed.
726300200529
726400200529     C                   CALLB     'AOSARDR0'
726500200529     C                   PARM      *BLANKS       PRtCd
726600200529     C                   PARM      '*VERIFY'     POptn
726700200529     C                   PARM      'S01506'      PSard
726800200529     C     SCSARD        PARM      SCSARD        DSFDY
726900200529
727000200529     C                   IF        PRtCd = *BLANKS
727100200529     C                   MOVEL     'Y'           S01506
727200200529     C                   ELSE
727300200529     C                   MOVEL     'N'           S01506
727400200529     C                   ENDIF
727500200529
727600200529      ** Access SAR file to determine if S01508 (BLI Extended Payment
727700200529      ** Charges) is installed.
727800200529
727900200529     C                   CALLB     'AOSARDR0'
728000200529     C                   PARM      *BLANKS       PRtCd
728100200529     C                   PARM      '*VERIFY'     POptn
728200200529     C                   PARM      'S01508'      PSard
728300200529     C     SCSARD        PARM      SCSARD        DSFDY
728400200529
728500200529     C                   IF        PRtCd = *BLANKS
728600200529     C                   MOVEL     'Y'           S01508
728700200529     C                   ELSE
728800200529     C                   MOVEL     'N'           S01508
728900200529     C                   ENDIF
729000200529
729100200529      ** Access SAR file to determine if CEU006 (EMU FT Settlement
729200200529      ** Currency Conversion) is installed.
729300200529
729400200529     C                   CALLB     'AOSARDR0'
729500200529     C                   PARM      *BLANKS       PRtCd
729600200529     C                   PARM      '*VERIFY'     POptn
729700200529     C                   PARM      'CEU006'      PSard
729800200529     C     SCSARD        PARM      SCSARD        DSFDY
729900200529
730000200529     C                   IF        PRtCd = *BLANKS
730100200529     C                   MOVEL     'Y'           CEU006
730200200529     C                   ELSE
730300200529     C                   MOVEL     'N'           CEU006
730400200529     C                   ENDIF
730500200529
730600200529      ** Access SAR file to determine if CGL009 (Electronic Banking
730700200529      ** Interface IATs and TPPs) is installed.
730800200529
730900200529     C                   CALLB     'AOSARDR0'
731000200529     C                   PARM      *BLANKS       PRtCd
731100200529     C                   PARM      '*VERIFY'     POptn
731200200529     C                   PARM      'CGL009'      PSard
731300200529     C     SCSARD        PARM      SCSARD        DSFDY
731400200529
731500200529     C                   IF        PRtCd = *BLANKS
731600200529     C                   MOVEL     'Y'           CGL009
731700200529     C                   ELSE
731800200529     C                   MOVEL     'N'           CGL009
731900200529     C                   ENDIF
732000200529
732100200529      ** Access SAR file to determine if CFT002 (Straight
732200200529      ** Through Processing Phase 1) is installed.
732300200529
732400200529     C                   CALLB     'AOSARDR0'
732500200529     C                   PARM      *BLANKS       PRTCD
732600200529     C                   PARM      '*VERIFY'     POPTN
732700200529     C                   PARM      'CFT002'      PSARD
732800200529     C     SCSARD        PARM      SCSARD        DSFDY
732900200529
733000200529     C     PRTCD         IFEQ      *BLANK
733100200529     C                   MOVEL     'Y'           CFT002
733200200529     C                   ELSE
733300200529     C                   MOVEL     'N'           CFT002
733400200529     C                   ENDIF
733500200529
733600200529      ** Access SAR file to determine if CFT004 (IBAN
733700200529      ** numbers) is installed.
733800200529
733900200529     C                   CALLB     'AOSARDR0'
734000200529     C                   PARM      *BLANKS       PRtCd
734100200529     C                   PARM      '*VERIFY'     POptn
734200200529     C                   PARM      'CFT004'      PSard
734300200529     C     SCSARD        PARM      SCSARD        DSFDY
734400200529
734500200529     C                   IF        PRtCd = *BLANKS
734600200529     C                   MOVEL     'Y'           CFT004
734700200529     C                   ELSE
734800200529     C                   MOVEL     'N'           CFT004
734900200529     C                   ENDIF
735000200529
735100200529      ** Access SAR file to determine if CFT003 is installed
735200200529
735300200529     C                   CALLB     'AOSARDR0'
735400200529     C                   PARM      *BLANKS       PRtCd
735500200529     C                   PARM      '*VERIFY'     POptn
735600200529     C                   PARM      'CFT003'      PSard
735700200529     C     SCSARD        PARM      SCSARD        DSFDY
735800200529
735900200529     C                   IF        PRtCd = *BLANKS
736000200529     C                   MOVEL     'Y'           CFT003
736100200529     C                   ELSE
736200200529     C                   MOVEL     'N'           CFT003
736300200529     C                   ENDIF
736400200529
736500200529      ** Access SAR file to determine if CFT014 is installed
736600200529
736700200529     C                   CALLB     'AOSARDR0'
736800200529     C                   PARM      *BLANKS       PRtCd
736900200529     C                   PARM      '*VERIFY'     POptn
737000200529     C                   PARM      'CFT014'      PSard
737100200529     C     SCSARD        PARM      SCSARD        DSFDY
737200200529
737300200529     C                   IF        PRtCd = *BLANKS
737400200529     C                   MOVEL     'Y'           CFT014
737500200529     C                   ELSE
737600200529     C                   MOVEL     'N'           CFT014
737700200529     C                   ENDIF
737800200529
737900200529      ** Access SAR file to determine if CFT009 is installed
738000200529
738100200529     C                   CALLB     'AOSARDR0'
738200200529     C                   PARM      *BLANKS       PRtCd
738300200529     C                   PARM      '*VERIFY'     POptn
738400200529     C                   PARM      'CFT009'      PSard
738500200529     C     SCSARD        PARM      SCSARD        DSFDY
738600200529
738700200529     C                   IF        PRtCd = *BLANKS
738800200529     C                   MOVEL     'Y'           CFT009
738900200529     C                   ELSE
739000200529     C                   MOVEL     'N'           CFT009
739100200529     C                   ENDIF
739200200529
739300200529      ** Access SAR file to determine if CFT010 is installed
739400200529
739500200529     C                   CALLB     'AOSARDR0'
739600200529     C                   PARM      *BLANKS       PRtCd
739700200529     C                   PARM      '*VERIFY'     POptn
739800200529     C                   PARM      'CFT010'      PSard
739900200529     C     SCSARD        PARM      SCSARD        DSFDY
740000200529
740100200529     C                   IF        PRtCd = *BLANKS
740200200529     C                   MOVEL     'Y'           CFT010
740300200529     C                   ELSE
740400200529     C                   MOVEL     'N'           CFT010
740500200529     C                   ENDIF
740600200529
740700200529     C                   EVAL      PProcDte = BJRDNB
740800200529
740900200529      ** Access SAR details file to see if 24X7 (CSC011) is installed.
741000200529
741100200529     C                   CALLB     'AOSARDR0'
741200200529     C                   PARM      *BLANKS       PRtCd
741300200529     C                   PARM      '*VERIFY'     POptn
741400200529     C                   PARM      'CSC011'      PSard
741500200529     C     SCSARD        PARM      SCSARD        DSFDY
741600200529
741700200529      ** If installed, get support system prefix and current system prefix and
741800200529      ** use processing date defined in SC24X7 dataarea when support system is active
741900200529
742000200529     C                   IF        PRtCd = *BLANKS
742100200529     C                   EVAL      CSC011 = 'Y'
742200200529     C                   IN        SC24X7
742300200529     C                   IN        SDSTAT
742400200529     C                   IF        LIBR = S1SUPP
742500200529     C                   EVAL      PPROCDTE = WPRDTE
742600200529     C                   ENDIF
742700200529     C                   ELSE
742800200529     C                   EVAL      CSC011 = 'N'
742900200529     C                   ENDIF
743000200529
743100200529      *                                                                                       CSW209
743200200529      ** Check if SWIFT 2009 feature is ON                                                    CSW209
743300200529      *                                                                                       CSW209
743400200529     C                   CALL      'SWIF2009'                                                 CSW209
743500200529     C                   PARM      *BLANKS       PRtCd                                        CSW209
743600200529      *                                                                                       CSW209
743700200529     C                   IF        PRtCd = 'CSW2009'                                          CSW209
743800200529     C                   EVAL      CSW209 = 'Y'                                               CSW209
743900200529     C                   ELSE                                                                 CSW209
744000200529     C                   EVAL      CSW209 = 'N'                                               CSW209
744100200529     C                   ENDIF                                                                CSW209
744200200529      *                                                                                       CSW209
744300200529      ** Check if Compliance Watch Enhancement (CSD015) is installed
744400200529
744500200529     C                   CALLB     'AOSARDR0'
744600200529     C                   PARM      *BLANKS       PRtCd
744700200529     C                   PARM      '*VERIFY'     POptn
744800200529     C                   PARM      'CSD015'      PSard
744900200529     C     SCSARD        PARM      SCSARD        DSFDY
745000200529
745100200529     C                   IF        PRtCd = *BLANKS
745200200529     C                   MOVEL     'Y'           CSD015
745300200529     C                   ELSE
745400200529     C                   MOVEL     'N'           CSD015
745500200529     C                   ENDIF
745600200529                                                                                              CSD083
745700200529      ** Check if Watch List Element (CSD083) is on                                           CSD083
745800200529                                                                                              CSD083
745900200529     C                   CALL      'AOSARDR0'                                                 CSD083
746000200529     C                   PARM      *BLANKS       PRTCD                                        CSD083
746100200529     C                   PARM      '*VERIFY'     POPTN                                        CSD083
746200200529     C                   PARM      'CSD083'      PSARD                                        CSD083
746300200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
746400200529                                                                                              CSD083
746500200529     C                   IF        PRTCD <> *BLANKS  AND                                      CSD083
746600200529     C                             PRTCD <> '*NRF'                                            CSD083
746700200529     C     *LOCK         IN        LDA                                                        CSD083
746800200529     C                   EVAL      DBKey = 'CSD083'                                           CSD083
746900200529     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD083
747000200529     C                   EVAL      DBase = 33                                                 CSD083
747100200529     C                   EXSR      *PSSR                                                      CSD083
747200200529     C                   ENDIF                                                                CSD083
747300200529     C                                                                                        CSD083
747400200529     C                   IF        PRTCD = *BLANKS                                            CSD083
747500200529     C                   EVAL      CSD015 = 'N'                                               CSD083
747600200529     C                   ENDIF                                                                CSD083
747700200529                                                                                              CSD083
747800200529
747900200529      ** Access SAR details to see if CCF001 is switched on.
748000200529
748100200529     C                   CALLB     'AOSARDR0'
748200200529     C                   PARM      *BLANKS       PRtCd
748300200529     C                   PARM      '*VERIFY'     POptn
748400200529     C                   PARM      'CCF001'      PSard
748500200529     C     SCSARD        PARM      SCSARD        DSFDY
748600200529
748700200529     C                   IF        PRtCd = *BLANKS
748800200529     C                   MOVEL     'Y'           CCF001
748900200529     C                   ELSE
749000200529     C                   MOVEL     'N'           CCF001
749100200529     C                   ENDIF
749200200529      *                                                                                       CER001
749300200529      ** Access SAR details file to determine if ULX043 is on.                                CER001
749400200529      *                                                                                       CER001
749500200529     C                   CALLB     'AOSARDR0'                                                 CER001
749600200529     C                   PARM      *BLANKS       PRtCd                                        CER001
749700200529     C                   PARM      '*VERIFY'     POptn                                        CER001
749800200529     C                   PARM      'ULX043'      PSard                                        CER001
749900200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
750000200529      *                                                                                       CER001
750100200529     C                   IF        PRTCD <> *Blanks and                                       CER001
750200200529     C                             PRTCD <> '*NRF   '                                         CER001
750300200529     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
750400200529     C                   MOVEL     '011'         DBASE                                        CER001
750500200529     C                   MOVEL     'ULX043'      DBKEY                                        CER001
750600200529     C                   EXSR      *PSSR                                                      CER001
750700200529     C                   END                                                                  CER001
750800200529      *                                                                                       CER001
750900200529     C**********         IF        PRtCd = *BLANKS                                            CER001
751000200529     C                   IF        PRtCd = *BLANKS AND BGNWST = 'Y'                         BUG14588
751100200529     C                   MOVEL     'Y'           ULX043                                       CER001
751200200529     C                   ELSE                                                                 CER001
751300200529     C                   MOVEL     'N'           ULX043                                       CER001
751400200529     C                   ENDIF                                                                CER001
751500200529
751600200529      **                                                                                      CSC022
751700200529      ** Access SAR details to see if CSC022 is switched on                                   CSC022
751800200529      **                                                                                      CSC022
751900200529     C                   CallB     'AOSARDR0'                                                 CSC022
752000200529     C                   Parm      *Blanks       PRtCd                                        CSC022
752100200529     C                   Parm      '*VERIFY'     POptn                                        CSC022
752200200529     C                   Parm      'CSC022'      PSard                                        CSC022
752300200529     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
752400200529      ** Initialize CSC022 and Skip Commit Flags                                              CSC022
752500200529     C                   Eval      CSC022 = 'N'                                               CSC022
752600200529     C                   Eval      WSkpComtRolbk = 'N'                                        CSC022
752700200529      **                                                                                      CSC022
752800200529     C                   If        PRtCd = *BLANKS                                            CSC022
752900200529     C                   Eval      CSC022 = 'Y'                                               CSC022
753000200529      **                                                                                      CSC022
753100200529      ** Get Jobs currently running i batch mode using SCCMRJOB dataarea                      CSC022
753200200529      **                                                                                      CSC022
753300200529     C                   In        SCCMTJOB                                                   CSC022
753400200529     C                   If        ComitNum > 0                                               CSC022
753500200529      ** Move committed jobs to arrary for checking                                           CSC022
753600200529     C                   MoveA     WDSJobs       WJobs                                        CSC022
753700200529      ** Verify if job running exists in array                                                CSC022
753800200529     C                   Eval      WArrPtr = %LookUp(PSJobName:WJobs)                         CSC022
753900200529     C                   If        WArrPtr > 0                                                CSC022
754000200529     C                   Eval      WSkpComtRolbk = 'Y'                                        CSC022
754100200529     C                   EndIf                                                                CSC022
754200200529     C                   EndIf                                                                CSC022
754300200529      **                                                                                      CSC022
754400200529     C                   Else                                                                 CSC022
754500200529      ** Execute *PSSR if CSC022 is not found or Database error                               CSC022
754600200529     C                   If        PRtCd <> '*NRF'                                            CSC022
754700200529     C     *Lock         In        LDA                                                        CSC022
754800200529     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
754900200529     C                   Eval      DBPgm  = 'FTIPAYVU'                                        CSC022
755000200529     C                   Eval      DBKey  = 'CSC022'                                          CSC022
755100200529     C                   Eval      DBase  = 900                                               CSC022
755200200529     C                   Out       LDA                                                        CSC022
755300200529     C                   Exsr      *PSSR                                                      CSC022
755400200529     C                   EndIf                                                                CSC022
755500200529     C                   EndIf                                                                CSC022
755700200529      **                                                                                      CSC022
755800200529      ** Check if enhancement CGL014 (Collaterals Processing) is on                           CGL014
755900200529                                                                                              CGL014
756000200529     C                   CALLB     'AOSARDR0'                                                 CGL014
756100200529     C                   PARM      *BLANKS       PRTCD                                        CGL014
756200200529     C                   PARM      '*VERIFY'     POPTN                                        CGL014
756300200529     C                   PARM      'CGL014'      PSARD                                        CGL014
756400200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL014
756500200529                                                                                              CGL014
756600200529     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CGL014
756700200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL014
756800200529     C                   EVAL      DBKEY  = 'CGL014'                                          CGL014
756900200529     C                   EVAL      DBASE  = 41                                                CGL014
757000200529     C                   EXSR      *PSSR                                                      CGL014
757100200529     C                   ENDIF                                                                CGL014
757200200529                                                                                              CGL014
757300200529     C                   IF        PRTCD = *BLANKS                                            CGL014
757400200529     C                   EVAL      CGL014 = 'Y'                                               CGL014
757500200529     C                   ELSE                                                                 CGL014
757600200529     C                   EVAL      CGL014 = 'N'                                               CGL014
757700200529     C                   ENDIF                                                                CGL014
757800200529      *                                                                                       CFT120
757900200529      ** Check if CFT120 is on                                                                CFT120
758000200529      *                                                                                       CFT120
758100200529     C                   CALLB     'AOSARDR0'                                                 CFT120
758200200529     C                   PARM      *BLANKS       PRTCD                                        CFT120
758300200529     C                   PARM      '*VERIFY'     POPTN                                        CFT120
758400200529     C                   PARM      'CFT120'      PSARD                                        CFT120
758500200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
758600200529                                                                                              CFT120
758700200529     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CFT120
758800200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT120
758900200529     C                   EVAL      DBKEY  = 'CFT120'                                          CFT120
759000200529     C                   EVAL      DBASE  = 42                                                CFT120
759100200529     C                   EXSR      *PSSR                                                      CFT120
759200200529     C                   ENDIF                                                                CFT120
759300200529                                                                                              CFT120
759400200529     C                   IF        PRTCD = *BLANKS                                            CFT120
759500200529     C                   EVAL      CFT120 = 'Y'                                               CFT120
759600200529     C                   ELSE                                                                 CFT120
759700200529     C                   EVAL      CFT120 = 'N'                                               CFT120
759800200529     C                   ENDIF                                                                CFT120
759900200529      *                                                                                       CFT151
760000200529      ** Check if CFT151 is on                                                                CFT151
760100200529      *                                                                                       CFT151
760200200529     C                   CALLB     'AOSARDR0'                                                 CFT151
760300200529     C                   PARM      *BLANKS       PRTCD                                        CFT151
760400200529     C                   PARM      '*VERIFY'     POPTN                                        CFT151
760500200529     C                   PARM      'CFT151'      PSARD                                        CFT151
760600200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT151
760700200529                                                                                              CFT151
760800200529     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CFT151
760900200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT151
761000200529     C                   EVAL      DBKEY  = 'CFT151'                                          CFT151
761100200529     C                   EVAL      DBASE  = 42                                                CFT151
761200200529     C                   EXSR      *PSSR                                                      CFT151
761300200529     C                   ENDIF                                                                CFT151
761400200529                                                                                              CFT151
761500200529     C                   IF        PRTCD = *BLANKS                                            CFT151
761600200529     C                   MOVEL     'Y'           CFT151            1                          CFT151
761700200529     C                   ELSE                                                                 CFT151
761800200529     C                   MOVEL     'N'           CFT151                                       CFT151
761900200529     C                   ENDIF                                                                CFT151
762000200529     C/COPY WNCPYSRC,FTIPAYV022
762100200529                                                                                              CGL014
762200200529      ***Check*if*enhancement*CSC024*(Open*Month*End)*is*on                            CSC024 CSC054
762300200529      ** Check if enhancement CSC054 (Period End Adjustments) is on                           CSC054
762400200529                                                                                              CSC024
762500200529     C                   CALLB     'AOSARDR0'                                                 CSC024
762600200529     C                   PARM      *BLANKS       PRTCD                                        CSC024
762700200529     C                   PARM      '*VERIFY'     POPTN                                        CSC024
762800200529     C                   PARM      'CSC024'      PSARD                                        CSC024
762900200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC024
763000200529                                                                                              CSC024
763100200529     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CSC024
763200200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC024
763300200529     C**********         EVAL      DBKEY  = 'CSC024'                                   CSC024 CSC054
763400200529     C                   EVAL      DBKEY  = 'CSC054'                                          CSC054
763500200529     C                   EVAL      DBASE  = 24                                                CSC024
763600200529     C                   EXSR      *PSSR                                                      CSC024
763700200529     C                   ENDIF                                                                CSC024
763800200529                                                                                              CSC024
763900200529     C                   IF        PRTCD = *BLANKS                                            CSC024
764000200529     C**********         MOVEL     'Y'           CSC024            1                   CSC024 CSC054
764100200529     C                   MOVEL     'Y'           CSC054            1                          CSC054
764200200529                                                                                              CSC024
764300200529      ** Access System values                                                                 CSC024
764400200529                                                                                              CSC024
764500200529     C                   CALL      'AOSVALR0'                                                 CSC024
764600200529     C                   PARM      *BLANKS       PRetCode          7                          CSC024
764700200529     C**********         PARM      SysValOME     P@OP01           20                   CSC024 CSC054
764800200529     C                   PARM      SysValPEA     P@OP01           20                          CSC054
764900200529     C                   PARM      *BLANKS       P@VL01          200                          CSC024
765000200529     C                   PARM      *BLANKS       P@OP02           20                          CSC024
765100200529     C                   PARM      *BLANKS       P@VL02          200                          CSC024
765200200529     C                   PARM      *BLANKS       P@OP03           20                          CSC024
765300200529     C                   PARM      *BLANKS       P@VL03          200                          CSC024
765400200529     C                   PARM      *BLANKS       P@OP04           20                          CSC024
765500200529     C                   PARM      *BLANKS       P@VL04          200                          CSC024
765600200529     C                   PARM      *BLANKS       P@OP05           20                          CSC024
765700200529     C                   PARM      *BLANKS       P@VL05          200                          CSC024
765800200529     C                   PARM      *BLANKS       P@OP06           20                          CSC024
765900200529     C                   PARM      *BLANKS       P@VL06          200                          CSC024
766000200529     C                   PARM      *BLANKS       P@OP07           20                          CSC024
766100200529     C                   PARM      *BLANKS       P@VL07          200                          CSC024
766200200529     C                   PARM      *BLANKS       P@OP08           20                          CSC024
766300200529     C                   PARM      *BLANKS       P@VL08          200                          CSC024
766400200529     C                   PARM      *BLANKS       P@OP09           20                          CSC024
766500200529     C                   PARM      *BLANKS       P@VL09          200                          CSC024
766600200529     C                   PARM      *BLANKS       P@OP10           20                          CSC024
766700200529     C                   PARM      *BLANKS       P@VL10          200                          CSC024
766800200529                                                                                              CSC024
766900200529     C                   IF        PRetCode  <> *BLANKS                                       CSC024
767000200529     C                   EVAL      DBPGM = 'FTIPAYSIN'                                        CSC024
767100200529     C                   EVAL      DBFILE = 'SDSVALPD'                                        CSC024
767200200529     C                   EVAL      DBKEy = '*KEY   '                                          CSC024
767300200529     C                   EVAL      DBase = 25                                                 CSC024
767400200529     C                   EXSR      *PSSR                                                      CSC024
767500200529     C                   ELSE                                                                 CSC024
767600200529     C                   IF        P@VL01 = 'Y'                                               CSC024
767700200529     C                   MOVEL     'N'           GENPREF           1                          CSC024
767800200529     C                   ELSE                                                                 CSC024
767900200529     C                   EVAL      GENPREF = 'Y'                                              CSC024
768000200529     C                   ENDIF                                                                CSC024
768100200529     C                   ENDIF                                                                CSC024
768200200529                                                                                              CSC024
768300200529     C                   ELSE                                                                 CSC024
768400200529     C**********         EVAL      CSC024 = 'N'                                        CSC024 CSC054
768500200529     C                   EVAL      CSC054 = 'N'                                               CSC054
768600200529     C                   EVAL      GENPREF = 'Y'                                              CSC024
768700200529     C                   ENDIF                                                                CSC024
768800200529                                                                                              CSC024
768900200529     C/COPY WNCPYSRC,FTH00483
769000200529      ** If S01499 is installed, retrieve VAT Rate.
769100200529      ** OR if CFT010 is installed
769200200529
769300200529     C                   IF        S01499 = 'Y' AND
769400200529     C                             CFT009 = 'N' OR
769500200529     C                             CFT010 = 'Y'
769600200529
769700200529     C                   CALL      'AOVATR0'
769800200529     C                   PARM      '*DBERR '     PRtCd
769900200529     C                   PARM      '*FIRST '     POptn
770000200529     C                   PARM                    PVATDS
770100200529
770200200529     C                   ENDIF
770300200529
770400200529      ** Access FT Control Data.
770500200529
770600200529     C                   CALL      'FT0005'                             9090
770700200529     C                   PARM      *BLANKS       PRtCd
770800200529     C                   PARM                    PCNTRL
770900200529
771000200529      ** Error occurred.
771100200529
771200200529     C                   IF        *IN90 OR
771300200529     C                             PRtCd <> *BLANKS
771400200529     C                   MOVEL     '*CALL'       DBKEY
771500200529     C                   MOVEL     'FT0005'      DBFILE
771600200529     C                   Z-ADD     1             DBASE
771700200529     C                   EXSR      *PSSR
771800200529     C                   ENDIF
771900200529
772000200529      ** Set up FT Override for GL Balances.
772100200529
772200200529     C                   IF        PGLUI = 'I'
772300200529     C                   MOVEL     'Y'           PFTOV
772400200529     C                   ELSE
772500200529     C                   MOVEL     *BLANK        PFTOV
772600200529     C                   ENDIF
772700200529
772800200529      ** Access Currency details file for Base Currency details.
772900200529
773000200529     C                   CALL      'AOCURRR0'
773100200529     C                   PARM      '*DBERR '     PRtCd
773200200529     C                   PARM      '*KEY   '     POptn
773300200529     C                   PARM      BJCYCD        PCurr
773400200529     C     SDCURR        PARM      SDCURR        DSSDY
773500200529
773600200529     C                   Z-ADD     A6NBDP        PBCDP
773700200529
773800200529      ** Access Currency details file for Local Currency details.
773900200529
774000200529     C                   CALL      'AOCURRR0'
774100200529     C                   PARM      '*DBERR '     PRtCd
774200200529     C                   PARM      '*KEY   '     POptn
774300200529     C                   PARM      BJLCCY        PCurr
774400200529     C     SDCURR        PARM      SDCURR        DSSDY
774500200529
774600200529     C                   Z-ADD     A6NBDP        PLCDp
774700200529     C                   IF        A6MDIN = 'M'
774800200529     C                   Z-ADD     1             PLMDIn
774900200529     C                   ELSE
775000200529     C                   Z-ADD     0             PLMDIn
775100200529     C                   ENDIF
775200200529     C                   Z-ADD     A6SPRT        PLSpot
775300200529
775400200529     C/COPY WNCPYSRC,FTIPAYCC07
775500200529      ** Check if enhancement CFT157 is on                                                    CFT157
775600200529                                                                                              CFT157
775700200529     C                   CALLB     'AOSARDR0'                                                 CFT157
775800200529     C                   PARM      *BLANKS       PRTCD                                        CFT157
775900200529     C                   PARM      '*VERIFY'     POPTN                                        CFT157
776000200529     C                   PARM      'CFT157'      PSARD                                        CFT157
776100200529     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT157
776200200529                                                                                              CFT157
776300200529     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CFT157
776400200529     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT157
776500200529     C                   EVAL      DBKEY  = 'CFT157'                                          CFT157
776600200529     C                   EVAL      DBASE  = 32                                                CFT157
776700200529     C                   EXSR      *PSSR                                                      CFT157
776800200529     C                   ENDIF                                                                CFT157
776900200529                                                                                              CFT157
777000200529     C                   IF        PRTCD = *BLANKS                                            CFT157
777100200529     C                   MOVEL     'Y'           CFT157            1                          CFT157
777200200529     C                   ELSE                                                                 CFT157
777300200529     C                   EVAL      CFT157 = 'N'                                               CFT157
777400200529     C                   ENDIF                                                                CFT157
777500200529                                                                                              CFT157
777600200529      **********                                                                             BUG7029
777700200529      ***Retrieve*ZMUSER*details.                                                            BUG7029
777800200529      **********                                                                             BUG7029
777900200529     C******DTAARA       DEFINE                  ZMUSER                                      BUG7029
778000200529     C**********         IN        ZMUSER                                                    BUG7029
778100200529
778200200529      ** Define Account key list.
778300200529
778400200529     C     KAccnt        KLIST
778500200529     C                   KFLD                    KACNUM
778600200529     C                   KFLD                    KACCCY
778700200529     C                   KFLD                    KACCD
778800200529     C                   KFLD                    KACSQ
778900200529     C                   KFLD                    KBRCA
779100200529     C     PPYKEY        KLIST                                                              MD034973
779200200529     C                   KFLD                    PPYBR                                      MD034973
779300200529     C                   KFLD                    PCNUM                                      MD034973
779400200529     C                   KFLD                    PPYTY                                      MD034973
779500200529     C                   KFLD                    PPYST                                      MD034973
779600200529      *                                                                                       252696
779700200529     C     KEYMP         KLIST                                                                252696
779800200529     C                   KFLD                    IPINMSGR                                     252696
779900200529     C                   KFLD                    IPINKPRT                                     252696
780000200529
780100200529     C     *LIKE         DEFINE    DDSMCY        WRCHCY
780200200529     C     *LIKE         DEFINE    DDSMAM        WRCHAM
780300200529     C     *LIKE         DEFINE    DDSMCY        WCACY
780400200529     C     *LIKE         DEFINE    DDSMAM        WCAAM
780600200529
780700200529      ** Program, module and procedure names for database error processing
780800200529      ** =================================================================
780900200529      ** The following /COPY sets these values.
781000200529
781100200529      /COPY ZACPYSRC,DBFIELDS
781200200529
781300200529      ** Hook to enable non-core initial processing to be included
781400200529
781500200529      /COPY WNCPYSRC,FTIPAYV019
781600200529
781700200529
781800200529     C                   ENDSR
781900200529      *****************************************************************
782000200529      /EJECT
782100200529      *****************************************************************
782200200529      * The following /COPY contains the standard program status
782300200529      * subroutine, including a bound call to the DBERRCTL module.
782400200529      *****************************************************************
782500200529     C/COPY ZACPYSRC,PSSR_ILE
782600200529      *****************************************************************
782700200529      /EJECT
782800200529      *****************************************************************
782900200529**  CPY@
783000200529(c) Finastra International Limited 2003
783100200529**  PSNAR
783200200529Payment Advice From Cashier System
